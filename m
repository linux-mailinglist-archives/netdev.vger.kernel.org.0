Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED114DBC87
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 07:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504262AbfJRFG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 01:06:29 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33856 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504254AbfJRFG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 01:06:28 -0400
Received: by mail-pf1-f193.google.com with SMTP id b128so3105046pfa.1;
        Thu, 17 Oct 2019 22:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2WYqjTN1RUCVkv/Je1j3VKlKtOkDStGRgvwygXm30VE=;
        b=stVAgmUonojr7iuGmI4Ls1OhAgj/NAhYmLxFnkS+Ku/KXfGM2yrOPhODAJr04AJQUe
         LD2I/9nMW0LIcT0cjr71RIX8cfrmEiQu0fBalMETBkRtXASge4Uvwpzuqg6Kh/3d8WFL
         t95bYCAbedMYb9JAloXofu1OHjkJna83/NiMNfIXa8qLou3s/V5Pr4x+DYQoyAbQQ/Ie
         zWM2JQj77twrlVjM92Fm85HQTAJbwgmNCHi2gwPXbkjyjjKhgNm1cULX6oF77lCTcKnx
         unHqQx97wWXxa92boKNwLA/42Bw8RM2PLrqulVnppPk8e0NT7AB68IWIVDf4x69IByjj
         uYAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2WYqjTN1RUCVkv/Je1j3VKlKtOkDStGRgvwygXm30VE=;
        b=V8wMzoblKEO5GdFZwDjVPhyi9oduqybrhZZLFD13GXnQZIKWY53hJZqlpZswkVbvQk
         G+6WhP9tny5xjOx6rw+kWrn7UBM8Nv5HS5+1zOhvjGwp8bQnOn5XKZbZMnejSvWEJRKa
         cV+RC80DbICSLZCyksEG5Hzd7j5R5lBantAs/3eBl3Z0MBFL477Nmm9vvAhit/5CLgdZ
         XYfq9DSlpL8RXb6dIHjtBfm89z/0q9E3v9c1S2kTG4eGMf9S2y56UiR66Idsdkqd29Vh
         GIYsiD3XpoDc0vJqY87cc5opn46eIHpk3HcZ5YkR8UBDXPPYeTBMScV3YZ+83RCY87Rd
         Kz5w==
X-Gm-Message-State: APjAAAXaT1VsYsNsx13lumX/cm+9UYTLZqg70Knx6R2rU0M6fxNIjtyy
        vejsz0MuJflYT/WlqBXfEcIn7M/b
X-Google-Smtp-Source: APXvYqywM1MTmVDyX2VcXcBBiWD84D7G+0LcHfGimyOlkwTm6ToTV0VlTLXNOvWYP8rUIqSw+k42bQ==
X-Received: by 2002:aa7:8a84:: with SMTP id a4mr3999603pfc.99.1571371717724;
        Thu, 17 Oct 2019 21:08:37 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id d11sm4341680pfo.104.2019.10.17.21.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 21:08:37 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Subject: [RFC PATCH v2 bpf-next 03/15] bpf: Add API to get program from id
Date:   Fri, 18 Oct 2019 13:07:36 +0900
Message-Id: <20191018040748.30593-4-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out the logic in bpf_prog_get_fd_by_id() and add
bpf_prog_get_by_id()/bpf_prog_get_type_dev_by_id().
Also export bpf_prog_get_type_dev_by_id(), which will be used by the
following commit to get bpf prog from its id.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 include/linux/bpf.h  |  8 ++++++++
 kernel/bpf/syscall.c | 42 ++++++++++++++++++++++++++++++++++--------
 2 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 282e28b..78fe7ef 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -636,6 +636,8 @@ int bpf_prog_array_copy(struct bpf_prog_array *old_array,
 struct bpf_prog *bpf_prog_get(u32 ufd);
 struct bpf_prog *bpf_prog_get_type_dev(u32 ufd, enum bpf_prog_type type,
 				       bool attach_drv);
+struct bpf_prog *bpf_prog_get_type_dev_by_id(u32 id, enum bpf_prog_type type,
+					     bool attach_drv);
 struct bpf_prog * __must_check bpf_prog_add(struct bpf_prog *prog, int i);
 void bpf_prog_sub(struct bpf_prog *prog, int i);
 struct bpf_prog * __must_check bpf_prog_inc(struct bpf_prog *prog);
@@ -760,6 +762,12 @@ static inline struct bpf_prog *bpf_prog_get_type_dev(u32 ufd,
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static inline struct bpf_prog *
+bpf_prog_get_type_dev_by_id(u32 id, enum bpf_prog_type type, bool attach_drv)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 static inline struct bpf_prog * __must_check bpf_prog_add(struct bpf_prog *prog,
 							  int i)
 {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 82eabd4..2dd6cfc 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2139,6 +2139,39 @@ static int bpf_obj_get_next_id(const union bpf_attr *attr,
 	return err;
 }
 
+static struct bpf_prog *bpf_prog_get_by_id(u32 id)
+{
+	struct bpf_prog *prog;
+
+	spin_lock_bh(&prog_idr_lock);
+	prog = idr_find(&prog_idr, id);
+	if (prog)
+		prog = bpf_prog_inc_not_zero(prog);
+	else
+		prog = ERR_PTR(-ENOENT);
+	spin_unlock_bh(&prog_idr_lock);
+
+	return prog;
+}
+
+struct bpf_prog *bpf_prog_get_type_dev_by_id(u32 id, enum bpf_prog_type type,
+					     bool attach_drv)
+{
+	struct bpf_prog *prog;
+
+	prog = bpf_prog_get_by_id(id);
+	if (IS_ERR(prog))
+		return prog;
+
+	if (!bpf_prog_get_ok(prog, &type, attach_drv)) {
+		bpf_prog_put(prog);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return prog;
+}
+EXPORT_SYMBOL_GPL(bpf_prog_get_type_dev_by_id);
+
 #define BPF_PROG_GET_FD_BY_ID_LAST_FIELD prog_id
 
 static int bpf_prog_get_fd_by_id(const union bpf_attr *attr)
@@ -2153,14 +2186,7 @@ static int bpf_prog_get_fd_by_id(const union bpf_attr *attr)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	spin_lock_bh(&prog_idr_lock);
-	prog = idr_find(&prog_idr, id);
-	if (prog)
-		prog = bpf_prog_inc_not_zero(prog);
-	else
-		prog = ERR_PTR(-ENOENT);
-	spin_unlock_bh(&prog_idr_lock);
-
+	prog = bpf_prog_get_by_id(id);
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
 
-- 
1.8.3.1

