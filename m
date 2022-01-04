Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE3C483DBE
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 09:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbiADIKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 03:10:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37534 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233910AbiADIKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 03:10:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641283811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PrqUMFFn4pZh/YLFjtZhXl9wcsEGaC7EU4s7bjstbP0=;
        b=MRmZjZeR7IBYbZopgVZPx8LyoU7HOVUT8TyQIV+g5B/+mTuXXO77gpGYf5w1gH5QcBySUP
        p2SCixTC2tgEOP2Rw3fskldyrHfQshZ+nFI2dZroK/ccOAHmYP8KxEzo0YbUPdBbESXTzQ
        3NbNS/as7uJdWRJgG/b15nvEe5mXVPM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-Ui8hecG8OZuqDZQsXkR8NA-1; Tue, 04 Jan 2022 03:10:10 -0500
X-MC-Unique: Ui8hecG8OZuqDZQsXkR8NA-1
Received: by mail-ed1-f71.google.com with SMTP id x19-20020a05640226d300b003f8b80f5729so23373426edd.13
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 00:10:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PrqUMFFn4pZh/YLFjtZhXl9wcsEGaC7EU4s7bjstbP0=;
        b=czJBPEmzxQi0TbU5GqjGSM5ft3/lSX2xzW/r1keLB6/uAp0SDnlGsyYEEFR9LFG730
         RoJ8r4BQctQdZApN+s/AmkQLg/zvG8minfdxwJ//FuJZQ62WinjmefaSReXG+r/kKWGt
         MHnhq9KTjO36Ofzi8faSnZiUIlD2u/3D4U9IaL/ixviFsPo6eFkt3RmL/Zy1lMSFQb7q
         GkGAMNK7d97okwlYBj8EDBFrATD0zDTlGFNar4H5K/xx2/5CNhVhk2jCXVDPn7TAkdXE
         Afv3Qrll4Wi2DKUzclGbfpUqAfZH2A9MeUXzJQMnZvtvzh61KvTAFtRna3RRVVkgLNJE
         nIcQ==
X-Gm-Message-State: AOAM532Q8Tpr29yRRWxC0esqvcqTqvZtk9hRueMWpT5cyxsMr8PiYFZS
        HGv+Un0pZLZcQvxT/SHw7abC7r/FxzaG93WIyZ5mKC6z6nclOaL7bWSaM7fa67UkawZFf4LuHxp
        +B0O6q5X+h12XeU8o
X-Received: by 2002:a17:907:1c92:: with SMTP id nb18mr37866566ejc.157.1641283809093;
        Tue, 04 Jan 2022 00:10:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJySXjS/HZTpUVZPV0EmeRXwPa68kUDgpiR6qGwn7STyl529I3LJOrPLNrk7fQlc+nh3IzGqkg==
X-Received: by 2002:a17:907:1c92:: with SMTP id nb18mr37866543ejc.157.1641283808870;
        Tue, 04 Jan 2022 00:10:08 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id u9sm8293523ejh.193.2022.01.04.00.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 00:10:08 -0800 (PST)
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
Subject: [PATCH 04/13] kprobe: Add support to register multiple ftrace kretprobes
Date:   Tue,  4 Jan 2022 09:09:34 +0100
Message-Id: <20220104080943.113249-5-jolsa@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220104080943.113249-1-jolsa@kernel.org>
References: <20220104080943.113249-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to register kretprobe on multiple addresses within
single kprobe object instance.

The interface stays same as for kprobes, the patch just adds blacklist
check for each address, which is special for kretprobes.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/kprobes.h |  1 +
 kernel/kprobes.c        | 46 ++++++++++++++++++++++++++++++++---------
 2 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 03fd86ef69cb..a31da6202b5c 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -75,6 +75,7 @@ struct kprobe {
 		kprobe_opcode_t **addrs;
 		unsigned int cnt;
 		struct ftrace_ops ops;
+		bool check_kretprobe;
 	} multi;
 #endif
 
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index e7729e20d85c..04fc411ca30c 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1052,6 +1052,17 @@ static int check_ftrace_location(unsigned long addr, struct kprobe *p)
 	return 0;
 }
 
+static bool in_kretprobe_blacklist(void *addr)
+{
+	int i;
+
+	for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
+		if (kretprobe_blacklist[i].addr == addr)
+			return true;
+	}
+	return false;
+}
+
 #ifdef CONFIG_KPROBES_ON_FTRACE
 static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
 	.func = kprobe_ftrace_handler,
@@ -1155,7 +1166,8 @@ static int disarm_kprobe_ftrace(struct kprobe *p)
  * - ftrace managed function entry address
  * - kernel core only address
  */
-static unsigned long check_ftrace_addr(unsigned long addr)
+static unsigned long check_ftrace_addr(unsigned long addr,
+				       bool check_kretprobe)
 {
 	int err;
 
@@ -1168,6 +1180,8 @@ static unsigned long check_ftrace_addr(unsigned long addr)
 		return -EINVAL;
 	if (__module_text_address(addr))
 		return -EINVAL;
+	if (check_kretprobe && in_kretprobe_blacklist((void *) addr))
+		return -EINVAL;
 	return 0;
 }
 
@@ -1202,7 +1216,7 @@ static int check_ftrace_multi(struct kprobe *p)
 	preempt_disable();
 
 	for (i = 0; i < cnt; i++) {
-		err = check_ftrace_addr(ips[i]);
+		err = check_ftrace_addr(ips[i], p->multi.check_kretprobe);
 		if (err)
 			break;
 	}
@@ -2188,13 +2202,17 @@ int kprobe_on_func_entry(kprobe_opcode_t *addr, const char *sym, unsigned long o
 	return 0;
 }
 
-int register_kretprobe(struct kretprobe *rp)
+static int check_kretprobe_address(struct kretprobe *rp)
 {
 	int ret;
-	struct kretprobe_instance *inst;
-	int i;
 	void *addr;
 
+#ifdef CONFIG_HAVE_KPROBES_MULTI_ON_FTRACE
+	if (rp->kp.multi.cnt) {
+		rp->kp.multi.check_kretprobe = !!kretprobe_blacklist_size;
+		return 0;
+	}
+#endif
 	ret = kprobe_on_func_entry(rp->kp.addr, rp->kp.symbol_name, rp->kp.offset);
 	if (ret)
 		return ret;
@@ -2207,12 +2225,20 @@ int register_kretprobe(struct kretprobe *rp)
 		addr = kprobe_addr(&rp->kp);
 		if (IS_ERR(addr))
 			return PTR_ERR(addr);
-
-		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
-			if (kretprobe_blacklist[i].addr == addr)
-				return -EINVAL;
-		}
+		if (in_kretprobe_blacklist(addr))
+			return -EINVAL;
 	}
+	return 0;
+}
+
+int register_kretprobe(struct kretprobe *rp)
+{
+	struct kretprobe_instance *inst;
+	int i, ret = 0;
+
+	ret = check_kretprobe_address(rp);
+	if (ret)
+		return ret;
 
 	if (rp->data_size > KRETPROBE_MAX_DATA_SIZE)
 		return -E2BIG;
-- 
2.33.1

