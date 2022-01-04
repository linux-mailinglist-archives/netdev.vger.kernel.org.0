Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6C8483DC5
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 09:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbiADIKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 03:10:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:60490 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234006AbiADIKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 03:10:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641283823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QB0M13Hi340QTyzl9UwQ247tdhoefPKuVolRpwS7Wq0=;
        b=alg0DjU5vh5N/FC5f0d2sk2o67mdSGR1i/aizlNYhWBORW2Eg5GSvYAG3xwUmLk5NslxVp
        HkCUGshg+DsIDPcnUmZ+fIXEUUzC+km6BEbjrTe/nIpvkbnwVgFODeEGYkQGApdzgC7SY7
        JqZLEBLyxjO7eHmlVEkH/DoPxnYAfAM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-4ioLpslcMASbVeJm6hkhYA-1; Tue, 04 Jan 2022 03:10:22 -0500
X-MC-Unique: 4ioLpslcMASbVeJm6hkhYA-1
Received: by mail-ed1-f72.google.com with SMTP id dz8-20020a0564021d4800b003f897935eb3so24727580edb.12
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 00:10:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QB0M13Hi340QTyzl9UwQ247tdhoefPKuVolRpwS7Wq0=;
        b=eSUiA3vcyZmJaHzuyT3JiykvywENjt50hfOWoRekRF3BhLpHRDtTKV5e/RlmeEQQVc
         boagYX+NQv6zgsAS0eB7WBgxsKxQ82hrdu1QR2MJLIu7rSjMDllbLWVAMYYb8Iibb/Tz
         fkVnBJDgvQ+Nko7nbBE1ZV7xKu21OO6HGSecG0JMn70efweE8RmW9xcwH9mRJUqsCdNh
         z8REw8KRXsWVCjw2nzuMu47ZR1LWGm8EIwY9rbhHk5c7LTg2t7OGsrgyn9aq054SU2UR
         yPGFplj/D9kDmxY9l5+OYKDtnGchB3z2JQcjZzKbYxZr5Wt2K6HzmimyOGDpPFaHdaCW
         8Log==
X-Gm-Message-State: AOAM5328c+m6wzbRzI+YUyDs4p3cGZcrIKCrTVROnjUKyui177dZiiGS
        adbZiqBf6HAMAy+gtYFnS0RlF/vQ9/bqllOMOEUpgir86A9+t3ssuWUMYQqFHhulZxzBmtnkUfV
        LJeRdCv1JDSd42VIu
X-Received: by 2002:a05:6402:2747:: with SMTP id z7mr45776172edd.321.1641283821366;
        Tue, 04 Jan 2022 00:10:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx+KmDVeG+o44jzowNPWmFk6FPwCuGUaVo1KM8fWZVoz9xlx17ppDVM9J0ByCFBH8ZC6vK4bQ==
X-Received: by 2002:a05:6402:2747:: with SMTP id z7mr45776154edd.321.1641283821241;
        Tue, 04 Jan 2022 00:10:21 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id di16sm11303023ejc.82.2022.01.04.00.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 00:10:21 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 06/13] samples/kprobes: Add support for multi kprobe interface
Date:   Tue,  4 Jan 2022 09:09:36 +0100
Message-Id: <20220104080943.113249-7-jolsa@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220104080943.113249-1-jolsa@kernel.org>
References: <20220104080943.113249-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to test multi kprobe interface. It's now possible
to register multiple functions for the module handler, like:

  # modprobe kprobe_example symbol='sched_fork,kernel_clone'

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 samples/kprobes/kprobe_example.c | 47 +++++++++++++++++++++++++++++---
 1 file changed, 43 insertions(+), 4 deletions(-)

diff --git a/samples/kprobes/kprobe_example.c b/samples/kprobes/kprobe_example.c
index f991a66b5b02..4ae31184f098 100644
--- a/samples/kprobes/kprobe_example.c
+++ b/samples/kprobes/kprobe_example.c
@@ -15,8 +15,10 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/kprobes.h>
+#include <linux/slab.h>
+#include <linux/string.h>
 
-#define MAX_SYMBOL_LEN	64
+#define MAX_SYMBOL_LEN	4096
 static char symbol[MAX_SYMBOL_LEN] = "kernel_clone";
 module_param_string(symbol, symbol, sizeof(symbol), 0644);
 
@@ -97,17 +99,54 @@ static void __kprobes handler_post(struct kprobe *p, struct pt_regs *regs,
 
 static int __init kprobe_init(void)
 {
+	char **symbols = NULL;
 	int ret;
+
 	kp.pre_handler = handler_pre;
 	kp.post_handler = handler_post;
 
+#ifdef CONFIG_HAVE_KPROBES_MULTI_ON_FTRACE
+	if (strchr(symbol, ',')) {
+		char *p, *tmp;
+		int cnt;
+
+		tmp = kstrdup(symbol, GFP_KERNEL);
+		if (!tmp)
+			return -ENOMEM;
+
+		p = strchr(tmp, ',');
+		while (p) {
+			*p = ' ';
+			p = strchr(p + 1, ',');
+		}
+
+		symbols = argv_split(GFP_KERNEL, tmp, &cnt);
+		kfree(tmp);
+		if (!symbols) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		kp.multi.symbols = (const char **) symbols;
+		kp.multi.cnt = cnt;
+	}
+#endif
+
 	ret = register_kprobe(&kp);
 	if (ret < 0) {
 		pr_err("register_kprobe failed, returned %d\n", ret);
-		return ret;
+		goto out;
 	}
-	pr_info("Planted kprobe at %p\n", kp.addr);
-	return 0;
+
+	if (symbols)
+		pr_info("Planted multi kprobe to %s\n", symbol);
+	else
+		pr_info("Planted kprobe at %p\n", kp.addr);
+
+out:
+	if (symbols)
+		argv_free(symbols);
+	return ret;
 }
 
 static void __exit kprobe_exit(void)
-- 
2.33.1

