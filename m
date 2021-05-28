Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3790E39479F
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 22:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhE1UCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 16:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhE1UCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 16:02:18 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68214C061574;
        Fri, 28 May 2021 13:00:43 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t193so3342985pgb.4;
        Fri, 28 May 2021 13:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tW2pKZu6OAKzS1unOPMj76xv7HXmN99D9Eqz8ZuKdvM=;
        b=XoUeNM/R9yAWFtBTLw4GcmAS9YORmfDrtiy8WaWLui0t8uJkTYDxK3D4MvJhF94NdQ
         vPKiHqqv4Jt6v8uy2YLWz5V2hD/+0qQgULvclupcfHHgKuf20sOBHHxJAPyh5MJ8NjbM
         eFztE1SrCK3KbpKz1RxrlWJcYnwXFmuuDZivuKA/6VCb2Dlc+lYAKXtP79+jbvSQ0u4K
         By6tvcc8FJqr0EHjylK9/ySKfUtHhL1rTaifAorTgT/LFuq+uVsBAyZjFWgkDWE2avTz
         VjKx+RLXa5WkALiZ+QyOIRR7uhNoFFQ9M+SJTH50Sqrmp7UEqqAwE9uN7t50GD804ml4
         nekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tW2pKZu6OAKzS1unOPMj76xv7HXmN99D9Eqz8ZuKdvM=;
        b=U7+s+wwtO7BnPRmrLj/QCeqtYnlFCpAXWRWnshV6g+EKl3AAFSQy2NYLhDqblBHgtX
         sHUkTfwW9G4CKglKhv1MjVdXiKeT2cj2VA2XI3TJveral+kZ3ecXPDcYLot/FQMGSZew
         4iEm/vsQRX8ZbAISEwteaL8mjOP8EeKHOKnv4xY0rhNoCBU14UEY4fFsS+MM1Mu8uIbJ
         khfQkVhM3ai5X14yF4zbqkQzp6k+gE4B+gVe/Zn9g2/Yxykd/5+jrWxL+xm3Nn9ICFkN
         pGI2MOzMS6Axgv16HaZDw/Ywagag2qE52nNrjK5yWRf+oZ7I+ql3EM0I31P8H5ZdXVo5
         7Hjw==
X-Gm-Message-State: AOAM533nqkdQzqDYtPuRdTIXXx0wEP1PYzXhHX3wxzlC42PC+38yWnPn
        i7l3/VbdJcqRNAjerXxWbA8fCpngbJQ=
X-Google-Smtp-Source: ABdhPJyQWmwzcpk88COU4sS01z3SCdhdZ7+LbgJ8OyH5PD1yq3nbgrJQ98GT6jN/4dIYFmR2a8A8OQ==
X-Received: by 2002:a63:f755:: with SMTP id f21mr10592373pgk.129.1622232042679;
        Fri, 28 May 2021 13:00:42 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id p30sm5059042pfq.218.2021.05.28.13.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 13:00:42 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH RFC bpf-next 1/7] net: sched: refactor cls_bpf creation code
Date:   Sat, 29 May 2021 01:29:40 +0530
Message-Id: <20210528195946.2375109-2-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528195946.2375109-1-memxor@gmail.com>
References: <20210528195946.2375109-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move parts of the code that are independent and need to be reused into
their own helpers. These will be needed for adding a bpf_link creation
path in a subsequent patch.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 net/sched/cls_bpf.c | 84 ++++++++++++++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 31 deletions(-)

diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index 6e3e63db0e01..360b97ab8646 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -455,6 +455,57 @@ static int cls_bpf_set_parms(struct net *net, struct tcf_proto *tp,
 	return 0;
 }
 
+static int __cls_bpf_alloc_idr(struct cls_bpf_head *head, u32 handle,
+			       struct cls_bpf_prog *prog,
+			       struct cls_bpf_prog *oldprog)
+{
+	int ret = 0;
+
+	if (oldprog) {
+		if (handle && oldprog->handle != handle)
+			return -EINVAL;
+	}
+
+	if (handle == 0) {
+		handle = 1;
+		ret = idr_alloc_u32(&head->handle_idr, prog, &handle, INT_MAX,
+				    GFP_KERNEL);
+	} else if (!oldprog) {
+		ret = idr_alloc_u32(&head->handle_idr, prog, &handle, handle,
+				    GFP_KERNEL);
+	}
+
+	prog->handle = handle;
+	return ret;
+}
+
+static int __cls_bpf_change(struct cls_bpf_head *head, struct tcf_proto *tp,
+			    struct cls_bpf_prog *prog,
+			    struct cls_bpf_prog *oldprog,
+			    struct netlink_ext_ack *extack)
+{
+	int ret;
+
+	ret = cls_bpf_offload(tp, prog, oldprog, extack);
+	if (ret)
+		return ret;
+
+	if (!tc_in_hw(prog->gen_flags))
+		prog->gen_flags |= TCA_CLS_FLAGS_NOT_IN_HW;
+
+	if (oldprog) {
+		idr_replace(&head->handle_idr, prog, prog->handle);
+		list_replace_rcu(&oldprog->link, &prog->link);
+		tcf_unbind_filter(tp, &oldprog->res);
+		tcf_exts_get_net(&oldprog->exts);
+		tcf_queue_work(&oldprog->rwork, cls_bpf_delete_prog_work);
+	} else {
+		list_add_rcu(&prog->link, &head->plist);
+	}
+
+	return 0;
+}
+
 static int cls_bpf_change(struct net *net, struct sk_buff *in_skb,
 			  struct tcf_proto *tp, unsigned long base,
 			  u32 handle, struct nlattr **tca,
@@ -483,48 +534,19 @@ static int cls_bpf_change(struct net *net, struct sk_buff *in_skb,
 	if (ret < 0)
 		goto errout;
 
-	if (oldprog) {
-		if (handle && oldprog->handle != handle) {
-			ret = -EINVAL;
-			goto errout;
-		}
-	}
-
-	if (handle == 0) {
-		handle = 1;
-		ret = idr_alloc_u32(&head->handle_idr, prog, &handle,
-				    INT_MAX, GFP_KERNEL);
-	} else if (!oldprog) {
-		ret = idr_alloc_u32(&head->handle_idr, prog, &handle,
-				    handle, GFP_KERNEL);
-	}
-
+	ret = __cls_bpf_alloc_idr(head, handle, prog, oldprog);
 	if (ret)
 		goto errout;
-	prog->handle = handle;
 
 	ret = cls_bpf_set_parms(net, tp, prog, base, tb, tca[TCA_RATE], ovr,
 				extack);
 	if (ret < 0)
 		goto errout_idr;
 
-	ret = cls_bpf_offload(tp, prog, oldprog, extack);
+	ret = __cls_bpf_change(head, tp, prog, oldprog, extack);
 	if (ret)
 		goto errout_parms;
 
-	if (!tc_in_hw(prog->gen_flags))
-		prog->gen_flags |= TCA_CLS_FLAGS_NOT_IN_HW;
-
-	if (oldprog) {
-		idr_replace(&head->handle_idr, prog, handle);
-		list_replace_rcu(&oldprog->link, &prog->link);
-		tcf_unbind_filter(tp, &oldprog->res);
-		tcf_exts_get_net(&oldprog->exts);
-		tcf_queue_work(&oldprog->rwork, cls_bpf_delete_prog_work);
-	} else {
-		list_add_rcu(&prog->link, &head->plist);
-	}
-
 	*arg = prog;
 	return 0;
 
-- 
2.31.1

