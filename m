Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDF547F419
	for <lists+netdev@lfdr.de>; Sat, 25 Dec 2021 18:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbhLYRhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Dec 2021 12:37:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52062 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230103AbhLYRhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Dec 2021 12:37:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640453871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PfLJ4QS3XWM5eK1msunIWbFBBtS4PdHQDRSrD6MoMIQ=;
        b=hEMdLU1XsmSNYmzDEPfA5ViuHjzaPZQNnVVBs/8lZ9J6pfhs8/BA8vLAXpWbT925ZHcKJZ
        rqiEwXRduXccS4kdPXx4GJU4e+qIDlJ8TKiyyEh6VN7V6aPtu2pEoN8SWeBYGXFb95rl6G
        /Eoo0sJP5erk/x9Kjuwi44ZgPL4nBbA=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-494-_8Yk8oWXPXyji_ls39MzNg-1; Sat, 25 Dec 2021 12:37:50 -0500
X-MC-Unique: _8Yk8oWXPXyji_ls39MzNg-1
Received: by mail-qt1-f199.google.com with SMTP id o12-20020a05622a008c00b002aff5552c89so8168772qtw.23
        for <netdev@vger.kernel.org>; Sat, 25 Dec 2021 09:37:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PfLJ4QS3XWM5eK1msunIWbFBBtS4PdHQDRSrD6MoMIQ=;
        b=oCR2/BVVx29uAvW9PSvnJr3G0FCvtYWlnrC9MZgiMLeLSyYLZdNF7uAu6/N0zj+OI7
         5F872phxzkZDhRJvtEbbCqGcU8hqN3kvOpHpbDXDAhJ7WMDaokh3NW4anurEMUf/D7c8
         F6/7etBUkF5ocKSLRA/0GZWHg49O1wkfxBiPaTgBNX6Ac0+LgRQ8N6K3kx5tx5jf6nOy
         ZuU3iHcdZ0tMgpXAOIXZJSnlnFZEeYKYEw7EWxmwlzqDKP6jTPLYTNvigHXzRvZlcQVc
         e0+cSC0vDWHU095Sbrf98lBi7H8ggoZz14NP0b69eMrqZVhcHulYTSIpV+dLN0IXL2TM
         ebGA==
X-Gm-Message-State: AOAM532lMiUj9LZigXd5p6m+dM4AZg0NC3yGyFhJn4YdjGlNhEAPOMtk
        YcJYxozTPYquMHuUESPewbvVmMpw8AkRqwSrDMazqG5mTdxqLaeBReHxnJ+iXRia/xVJHeIaN+/
        cCztBZ+db9aj/c5uf
X-Received: by 2002:a05:620a:28d3:: with SMTP id l19mr7881248qkp.675.1640453870030;
        Sat, 25 Dec 2021 09:37:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzuz8tvTMB4bLDfW0C5YAfFnb48WucYFQPi8z7cn1vFPp20Nl24sKrKoPFWCh7qrmcYrRCnew==
X-Received: by 2002:a05:620a:28d3:: with SMTP id l19mr7881238qkp.675.1640453869787;
        Sat, 25 Dec 2021 09:37:49 -0800 (PST)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id q196sm6036372qke.18.2021.12.25.09.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Dec 2021 09:37:49 -0800 (PST)
From:   trix@redhat.com
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] netfilter: extend CONFIG_NF_CONNTRACK compile time checks
Date:   Sat, 25 Dec 2021 09:37:44 -0800
Message-Id: <20211225173744.3318250-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Extends
commit 83ace77f5117 ("netfilter: ctnetlink: remove get_ct indirection")

Add some compile time checks by following the ct and ctinfo variables
that are only set when CONFIG_NF_CONNTRACK is enabled.

In nfulnl_log_packet(), ct is only set when CONFIG_NF_CONNTRACK
is enabled. ct's later use in __build_packet_message() is only
meaningful when CONFIG_NF_CONNTRACK is enabled, so add a check.

In nfqnl_build_packet_message(), ct and ctinfo are only set when
CONFIG_NF_CONNTRACK is enabled.  Add a check for their decl and use.

nfqnl_ct_parse() is a static function, move the check to the whole
function.

In nfqa_parse_bridge(), ct and ctinfo are only set by the only
call to nfqnl_ct_parse(), so add a check for their decl and use.

Consistently initialize ctinfo to 0.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/netfilter/nfnetlink_log.c   |  4 +++-
 net/netfilter/nfnetlink_queue.c | 18 +++++++++++++-----
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index ae9c0756bba59..e79d152184b71 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -627,9 +627,11 @@ __build_packet_message(struct nfnl_log_net *log,
 			 htonl(atomic_inc_return(&log->global_seq))))
 		goto nla_put_failure;
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	if (ct && nfnl_ct->build(inst->skb, ct, ctinfo,
 				 NFULA_CT, NFULA_CT_INFO) < 0)
 		goto nla_put_failure;
+#endif
 
 	if ((pf == NFPROTO_NETDEV || pf == NFPROTO_BRIDGE) &&
 	    nfulnl_put_bridge(inst, skb) < 0)
@@ -689,7 +691,7 @@ nfulnl_log_packet(struct net *net,
 	struct nfnl_log_net *log = nfnl_log_pernet(net);
 	const struct nfnl_ct_hook *nfnl_ct = NULL;
 	struct nf_conn *ct = NULL;
-	enum ip_conntrack_info ctinfo;
+	enum ip_conntrack_info ctinfo = 0;
 
 	if (li_user && li_user->type == NF_LOG_TYPE_ULOG)
 		li = li_user;
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 44c3de176d186..d59cae7561bf8 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -386,8 +386,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	struct sk_buff *entskb = entry->skb;
 	struct net_device *indev;
 	struct net_device *outdev;
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	struct nf_conn *ct = NULL;
 	enum ip_conntrack_info ctinfo = 0;
+#endif
 	struct nfnl_ct_hook *nfnl_ct;
 	bool csum_verify;
 	char *secdata = NULL;
@@ -595,8 +597,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
 		goto nla_put_failure;
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
 		goto nla_put_failure;
+#endif
 
 	if (cap_len > data_len &&
 	    nla_put_be32(skb, NFQA_CAP_LEN, htonl(cap_len)))
@@ -1104,13 +1108,13 @@ static int nfqnl_recv_verdict_batch(struct sk_buff *skb,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 static struct nf_conn *nfqnl_ct_parse(struct nfnl_ct_hook *nfnl_ct,
 				      const struct nlmsghdr *nlh,
 				      const struct nlattr * const nfqa[],
 				      struct nf_queue_entry *entry,
 				      enum ip_conntrack_info *ctinfo)
 {
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(entry->skb, ctinfo);
@@ -1125,10 +1129,8 @@ static struct nf_conn *nfqnl_ct_parse(struct nfnl_ct_hook *nfnl_ct,
 				      NETLINK_CB(entry->skb).portid,
 				      nlmsg_report(nlh));
 	return ct;
-#else
-	return NULL;
-#endif
 }
+#endif
 
 static int nfqa_parse_bridge(struct nf_queue_entry *entry,
 			     const struct nlattr * const nfqa[])
@@ -1172,11 +1174,13 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 	struct nfnl_queue_net *q = nfnl_queue_pernet(info->net);
 	u_int16_t queue_num = ntohs(info->nfmsg->res_id);
 	struct nfqnl_msg_verdict_hdr *vhdr;
-	enum ip_conntrack_info ctinfo;
 	struct nfqnl_instance *queue;
 	struct nf_queue_entry *entry;
 	struct nfnl_ct_hook *nfnl_ct;
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	struct nf_conn *ct = NULL;
+	enum ip_conntrack_info ctinfo = 0;
+#endif
 	unsigned int verdict;
 	int err;
 
@@ -1198,11 +1202,13 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 	/* rcu lock already held from nfnl->call_rcu. */
 	nfnl_ct = rcu_dereference(nfnl_ct_hook);
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	if (nfqa[NFQA_CT]) {
 		if (nfnl_ct != NULL)
 			ct = nfqnl_ct_parse(nfnl_ct, info->nlh, nfqa, entry,
 					    &ctinfo);
 	}
+#endif
 
 	if (entry->state.pf == PF_BRIDGE) {
 		err = nfqa_parse_bridge(entry, nfqa);
@@ -1218,8 +1224,10 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 				 payload_len, entry, diff) < 0)
 			verdict = NF_DROP;
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 		if (ct && diff)
 			nfnl_ct->seq_adjust(entry->skb, ct, ctinfo, diff);
+#endif
 	}
 
 	if (nfqa[NFQA_MARK])
-- 
2.26.3

