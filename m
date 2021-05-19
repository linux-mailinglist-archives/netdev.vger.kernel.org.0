Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E112389047
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353932AbhESOQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353988AbhESOPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:39 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE77C061345;
        Wed, 19 May 2021 07:14:06 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id o127so7378881wmo.4;
        Wed, 19 May 2021 07:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ia8yEEumaDfwO1+1AwrAneih7zxe+tE90lEQ3nBrXdA=;
        b=kIF6ZwdpWDvqeWiNerCWYEcZZTDQFXBAmVGVoRf/cIS5S6XeHSzLBVmF05Y/YvIYsg
         E2cfYjpexVaSmoMzaO5i6VdtCEi7J90y7Bl4FET4DA8uRzDmLbRNYN9D67/AFomkw7FR
         iRlUWRQielyRHRqFztu7fziWWA8gl4QNRLzapOhwl+DakaAhmKjTHojZ3IW82rYpcMJa
         ZAHoBiSnwrOmt4NJMLH47KlZvOZQug48k3DHSYF/VvFSVVC6pf74JhvacqOw0ZmMjYy6
         14BROARYwZU+yLOlcDuidocx71NwGp8ZzlW61t7fh3ZI1SPDTX4ZdWPOVjcthQnJHooB
         Cs0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ia8yEEumaDfwO1+1AwrAneih7zxe+tE90lEQ3nBrXdA=;
        b=uiWpT+p0VRcB9rmZDpEpnP0IWldDKgQxsQpEAjnQNVclIMj+Ivokd4NbeV/srRjyrP
         gczngpNDGz/nBbodzfap9mPgGCHiu1dCnWXQuQJ49/BtcAVG8FKgr0k20cJTpZ1eJC3/
         pTdUfYawUob3XbGFfcA/a21sGbA9M1C9v+Ut0doa2nZ4NdfqZzLOBcegICTVlwBzRYy4
         eE35t9a2q83vJUxkZG8yeWfbxEbYDorr5zkChl7IEb84lGO+tib0LIrKrKvWT/opex9a
         94Wx1dzC+GFj1Axxu7dQfuD8p9iAhnO7FbjMOfWzzrdJY+gyQCk/cVy1iyMaOH2ylNRE
         UccA==
X-Gm-Message-State: AOAM533OfqFDS8DvLuWIkFQkKy33Ogn4+lVktpkjS/lGBV2MieBrfD4i
        yCAtMIe3IOdHYyXZAUbRx0TBRpSkOxez7cm8
X-Google-Smtp-Source: ABdhPJyKH/yCHUDc+r67QSoXhMHTW2SqJ0qCGVPQAFyvcat2jjT6ZtYZxVKvkGp/yaswMTRd/lgdkg==
X-Received: by 2002:a1c:b306:: with SMTP id c6mr11247677wmf.37.1621433644583;
        Wed, 19 May 2021 07:14:04 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:14:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Christian Dietrich <stettberger@dokucode.de>
Subject: [PATCH 12/23] bpf: add IOURING program type
Date:   Wed, 19 May 2021 15:13:23 +0100
Message-Id: <3883680d4638504e3dcf79bf1c15d548a9cb7f3e.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Draft a new program type BPF_PROG_TYPE_IOURING, which will be used by
io_uring to execute BPF-based requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c             | 21 +++++++++++++++++++++
 include/linux/bpf_types.h |  2 ++
 include/uapi/linux/bpf.h  |  1 +
 kernel/bpf/syscall.c      |  1 +
 kernel/bpf/verifier.c     |  5 ++++-
 5 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1a4c9e513ac9..882b16b5e5eb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10201,6 +10201,27 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	return ret;
 }
 
+static const struct bpf_func_proto *
+io_bpf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	return bpf_base_func_proto(func_id);
+}
+
+static bool io_bpf_is_valid_access(int off, int size,
+				   enum bpf_access_type type,
+				   const struct bpf_prog *prog,
+				   struct bpf_insn_access_aux *info)
+{
+	return false;
+}
+
+const struct bpf_prog_ops bpf_io_uring_prog_ops = {};
+
+const struct bpf_verifier_ops bpf_io_uring_verifier_ops = {
+	.get_func_proto		= io_bpf_func_proto,
+	.is_valid_access	= io_bpf_is_valid_access,
+};
+
 SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 		void __user *, arg, unsigned int, nr_args)
 {
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 99f7fd657d87..d0b7954887bd 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -77,6 +77,8 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
 	       void *, void *)
 #endif /* CONFIG_BPF_LSM */
 #endif
+BPF_PROG_TYPE(BPF_PROG_TYPE_IOURING, bpf_io_uring,
+	      void *, void *)
 
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4ba4ef0ff63a..de544f0fbeef 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -206,6 +206,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_EXT,
 	BPF_PROG_TYPE_LSM,
 	BPF_PROG_TYPE_SK_LOOKUP,
+	BPF_PROG_TYPE_IOURING,
 };
 
 enum bpf_attach_type {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 250503482cda..6ef7a26f4dc3 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2041,6 +2041,7 @@ static bool is_net_admin_prog_type(enum bpf_prog_type prog_type)
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 	case BPF_PROG_TYPE_SOCK_OPS:
+	case BPF_PROG_TYPE_IOURING:
 	case BPF_PROG_TYPE_EXT: /* extends any prog */
 		return true;
 	case BPF_PROG_TYPE_CGROUP_SKB:
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0399ac092b36..2a53f44618a7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8558,6 +8558,9 @@ static int check_return_code(struct bpf_verifier_env *env)
 	case BPF_PROG_TYPE_SK_LOOKUP:
 		range = tnum_range(SK_DROP, SK_PASS);
 		break;
+	case BPF_PROG_TYPE_IOURING:
+		range = tnum_const(0);
+		break;
 	case BPF_PROG_TYPE_EXT:
 		/* freplace program can return anything as its return value
 		 * depends on the to-be-replaced kernel func or bpf program.
@@ -12560,7 +12563,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	u64 key;
 
 	if (prog->aux->sleepable && prog->type != BPF_PROG_TYPE_TRACING &&
-	    prog->type != BPF_PROG_TYPE_LSM) {
+	    prog->type != BPF_PROG_TYPE_LSM && prog->type != BPF_PROG_TYPE_IOURING) {
 		verbose(env, "Only fentry/fexit/fmod_ret and lsm programs can be sleepable\n");
 		return -EINVAL;
 	}
-- 
2.31.1

