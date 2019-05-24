Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7683029748
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 13:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391168AbfEXLf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 07:35:58 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38980 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391133AbfEXLf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 07:35:57 -0400
Received: by mail-wm1-f66.google.com with SMTP id z23so4799247wma.4
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 04:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1ltC0XV47uD9Ss4Mv4UBpU2RzQzY2ir2n8PLOTN4Pg4=;
        b=t1TgPjC3VDUhBc1Ma0/Yt+K+ysU7yqa805qYamXVQSO2/Ggh9TFc53No+P9QiC/wP2
         w1pXHuvKAJw3KtyGwy+nvZQlOEgRMHQXr5vjq3aUh5XLTqlUhXRVbY4SyAVL+Vx+QjNb
         usAfI8fhXcqsdu35V1nps1ycI6X4kOY/FMapqX6M0x23DkbKBmXhs/wD2nGtuM0sB4LL
         kYdaPEnHTxSGdQgTd2o+BATRqEy7wq5fSwDmb9fsPGwV1GK6oQN8/poBpkg89KbUpSoO
         Yf3++wbD/36jA2ES8XD3YZw6xp9SKRBq8yHZ6+Ut/HQBLJSoH1AY0oXtneJuYR5iJUOj
         g/sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1ltC0XV47uD9Ss4Mv4UBpU2RzQzY2ir2n8PLOTN4Pg4=;
        b=HspN5aUFZNs32sDfYltpfGbCspoCjgsGqaRuulcL6JS2hnTp2G3/v3QlkVpZ1x0YnT
         Eljv+7YJKrTuQfvpvUnwuL7PS5wOzD0MkJ1C4V7SMgctDGwpDD/rrRBC1CX8QzuzxmkM
         Gb3RkPpxv8seCLUcYbeQp8+QjQmWY/vMc8LrxW1X6VaxUevXk9NWfQ/RCQ3CCi5stBIw
         226KPq/mKOAc0pZQICGf60BQwN2+nuAl12BP/8ixJF1qK5/JDC/FnlLe6NmYxvRiT41a
         mGLsjPMKZtrosGE4CHF3OwCnLiRdr5hiwGXbCOMJzHwkrIRGHmsSEUiDoalchuKRh71e
         V1iA==
X-Gm-Message-State: APjAAAXEbglIR5PxvALRjym98e+91lTI+pRjGXsh/IeD/oI71QwD6oiF
        FuDIkx9Fb6DGiXuuZ09hh6VnUw==
X-Google-Smtp-Source: APXvYqy2pqXk1y+0mda/71ruhME633JfzwLg/H4SmqlitWD37csQVtzzLNzC1Kd9GQlLcVd+doQ9pQ==
X-Received: by 2002:a1c:4045:: with SMTP id n66mr15703769wma.142.1558697754433;
        Fri, 24 May 2019 04:35:54 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id x22sm2462902wmi.4.2019.05.24.04.35.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 May 2019 04:35:53 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v8 bpf-next 07/16] libbpf: add "prog_flags" to bpf_program/bpf_prog_load_attr/bpf_load_program_attr
Date:   Fri, 24 May 2019 12:35:17 +0100
Message-Id: <1558697726-4058-8-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558697726-4058-1-git-send-email-jiong.wang@netronome.com>
References: <1558697726-4058-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

libbpf doesn't allow passing "prog_flags" during bpf program load in a
couple of load related APIs, "bpf_load_program_xattr", "load_program" and
"bpf_prog_load_xattr".

It makes sense to allow passing "prog_flags" which is useful for
customizing program loading.

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 tools/lib/bpf/bpf.c    | 1 +
 tools/lib/bpf/bpf.h    | 1 +
 tools/lib/bpf/libbpf.c | 3 +++
 tools/lib/bpf/libbpf.h | 1 +
 4 files changed, 6 insertions(+)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index c4a4808..0d4b4fe 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -256,6 +256,7 @@ int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
 	if (load_attr->name)
 		memcpy(attr.prog_name, load_attr->name,
 		       min(strlen(load_attr->name), BPF_OBJ_NAME_LEN - 1));
+	attr.prog_flags = load_attr->prog_flags;
 
 	fd = sys_bpf_prog_load(&attr, sizeof(attr));
 	if (fd >= 0)
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 9593fec..ff42ca0 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -87,6 +87,7 @@ struct bpf_load_program_attr {
 	const void *line_info;
 	__u32 line_info_cnt;
 	__u32 log_level;
+	__u32 prog_flags;
 };
 
 /* Flags to direct loading requirements */
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 197b574..ff14937 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -188,6 +188,7 @@ struct bpf_program {
 	void *line_info;
 	__u32 line_info_rec_size;
 	__u32 line_info_cnt;
+	__u32 prog_flags;
 };
 
 enum libbpf_map_type {
@@ -2076,6 +2077,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.line_info_rec_size = prog->line_info_rec_size;
 	load_attr.line_info_cnt = prog->line_info_cnt;
 	load_attr.log_level = prog->log_level;
+	load_attr.prog_flags = prog->prog_flags;
 	if (!load_attr.insns || !load_attr.insns_cnt)
 		return -EINVAL;
 
@@ -3521,6 +3523,7 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 						      expected_attach_type);
 
 		prog->log_level = attr->log_level;
+		prog->prog_flags = attr->prog_flags;
 		if (!first_prog)
 			first_prog = prog;
 	}
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index c5ff005..5abc237 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -320,6 +320,7 @@ struct bpf_prog_load_attr {
 	enum bpf_attach_type expected_attach_type;
 	int ifindex;
 	int log_level;
+	int prog_flags;
 };
 
 LIBBPF_API int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
-- 
2.7.4

