Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13ED639B2A3
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 08:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhFDGeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 02:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhFDGeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 02:34:36 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AA9C061760;
        Thu,  3 Jun 2021 23:32:37 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id r1so7053822pgk.8;
        Thu, 03 Jun 2021 23:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FtYR0ttn+uxR+DkM856khEcyrIXwK/Nt1VkQyHgBwu0=;
        b=i4V0uOeUct45vWarFtGIXvyX9qMxoeg/yf2a7cmR6aQAyl8twD7mefamq6+iV7br1b
         xQLutuzKdgV4J+uVbyienAN85Sj6L0lzUCM2Y/IpvUT+5XjEFuARCO4c64M0QTGaWncr
         hze3CEVesQDMKuxD9vD1wN2vxx9VHsXhqteKTeDobsLbGFmE8eqW5IrWh/Q5Wy8QX93t
         YiwTED/DXxL2DZ1StT7Lz/9A4nNFf179FJdSCs7oDcw7Y6UEDW+zfDogtmwqETvvpyw0
         BiakiPDzbsyMl8FHDl/FE30Fr8SZ/jFLm5yCYReSm/W+1pRRLeEqT2LFRvb81DOezlWb
         vx/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FtYR0ttn+uxR+DkM856khEcyrIXwK/Nt1VkQyHgBwu0=;
        b=lHPsWsUjgKbotgxugrmTxveeqKCM5Luc1gqU4oAb4bf8pP3dOQT0LMeSqFJNKnYn4B
         V1e8YpkTJZSLTbNxauNU4HB14WK0VXYCPOdV2sNciYTG9zs9LINOB0CxY0fxG8u5L2NE
         ZZ1dYn1s2CJT5+0Aapodbc34LDRAUK1nZNb6hr5iM4Ihwsbny+FZ/m2/oCcO1iRKmrz0
         8E3cKxZq0u7l/aPZHFIXBhh8iXVozq8IYkELkfDcXV7mETeGyn7cjuPAMbWZ4xYu78Kd
         p1xhc4VsC45agHAUDECysCjBHom7EXFWc/mB2uFt2WVX0e8WstCUjfwUGM7mc7jimHKm
         TN8Q==
X-Gm-Message-State: AOAM531H7+OwQQsJDK0bRuJ3sWltf7OJQohr88nd5h6Eqnhnx+rOXOYm
        xdefNJzOCn0sHrCabzWMu/CcjXAUo7M=
X-Google-Smtp-Source: ABdhPJw00T3O+Z6NzhCMk0ORYWjUHPmTHQG+5uI/+RWT5VtAIH1HsjSBtogH/gzOWw5HXOK2cattCw==
X-Received: by 2002:a05:6a00:cd4:b029:2e1:b937:77e8 with SMTP id b20-20020a056a000cd4b02902e1b93777e8mr2891574pfv.43.1622788357271;
        Thu, 03 Jun 2021 23:32:37 -0700 (PDT)
Received: from localhost ([2402:3a80:11cb:b599:c759:2079:3ef5:1764])
        by smtp.gmail.com with ESMTPSA id 6sm868271pfw.56.2021.06.03.23.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 23:32:37 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 4/7] net: sched: add lightweight update path for cls_bpf
Date:   Fri,  4 Jun 2021 12:01:13 +0530
Message-Id: <20210604063116.234316-5-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210604063116.234316-1-memxor@gmail.com>
References: <20210604063116.234316-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is used by BPF_LINK_UPDATE to replace the attach SCHED_CLS bpf prog
effectively changing the classifier implementation for a given filter
owned by a bpf_link.

Note that READ_ONCE suffices in this case as the ordering for loads from
the filter are implicitly provided by the data dependency on BPF prog
pointer.

On the writer side we can just use a relaxed WRITE_ONCE store to make
sure one or the other value is visible to a reader in cls_bpf_classify.
Lifetime is managed using RCU so bpf_prog_put path should wait until
readers are done for old_prog.

All other parties accessing the BPF prog are under RTNL protection, so
need no changes.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>.
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 net/sched/cls_bpf.c | 55 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 2 deletions(-)

diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index bf61ffbb7fd0..f23304685c48 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -9,6 +9,7 @@
  * (C) 2013 Daniel Borkmann <dborkman@redhat.com>
  */
 
+#include <linux/atomic.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/skbuff.h>
@@ -104,11 +105,11 @@ static int cls_bpf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 			/* It is safe to push/pull even if skb_shared() */
 			__skb_push(skb, skb->mac_len);
 			bpf_compute_data_pointers(skb);
-			filter_res = BPF_PROG_RUN(prog->filter, skb);
+			filter_res = BPF_PROG_RUN(READ_ONCE(prog->filter), skb);
 			__skb_pull(skb, skb->mac_len);
 		} else {
 			bpf_compute_data_pointers(skb);
-			filter_res = BPF_PROG_RUN(prog->filter, skb);
+			filter_res = BPF_PROG_RUN(READ_ONCE(prog->filter), skb);
 		}
 
 		if (prog->exts_integrated) {
@@ -775,6 +776,55 @@ static int cls_bpf_link_detach(struct bpf_link *link)
 	return 0;
 }
 
+static int cls_bpf_link_update(struct bpf_link *link, struct bpf_prog *new_prog,
+			       struct bpf_prog *old_prog)
+{
+	struct cls_bpf_link *cls_link;
+	struct cls_bpf_prog cls_prog;
+	struct cls_bpf_prog *prog;
+	int ret;
+
+	rtnl_lock();
+
+	cls_link = container_of(link, struct cls_bpf_link, link);
+	if (!cls_link->prog) {
+		ret = -ENOLINK;
+		goto out;
+	}
+
+	prog = cls_link->prog;
+
+	/* BPF_F_REPLACEing? */
+	if (old_prog && prog->filter != old_prog) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	old_prog = prog->filter;
+
+	if (new_prog == old_prog) {
+		ret = 0;
+		goto out;
+	}
+
+	cls_prog = *prog;
+	cls_prog.filter = new_prog;
+
+	ret = cls_bpf_offload(prog->tp, &cls_prog, prog, NULL);
+	if (ret < 0)
+		goto out;
+
+	WRITE_ONCE(prog->filter, new_prog);
+
+	bpf_prog_inc(new_prog);
+	/* release our reference */
+	bpf_prog_put(old_prog);
+
+out:
+	rtnl_unlock();
+	return ret;
+}
+
 static void __bpf_fill_link_info(struct cls_bpf_link *link,
 				 struct bpf_link_info *info)
 {
@@ -859,6 +909,7 @@ static const struct bpf_link_ops cls_bpf_link_ops = {
 	.show_fdinfo = cls_bpf_link_show_fdinfo,
 #endif
 	.fill_link_info = cls_bpf_link_fill_link_info,
+	.update_prog = cls_bpf_link_update,
 };
 
 static inline char *cls_bpf_link_name(u32 prog_id, const char *name)
-- 
2.31.1

