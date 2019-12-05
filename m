Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0151F114550
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 18:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbfLERD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 12:03:56 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43232 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729430AbfLERDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 12:03:55 -0500
Received: by mail-wr1-f66.google.com with SMTP id d16so4480123wre.10
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 09:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=J8rTFWjeRom2OSy8/VgjlS2zWoMCCYdnebKLS5jGnMQ=;
        b=FddM+lhhvPqVBKZyw+lvV2LrmZjFbkcwMakIlLwKT+MnmXGvEt/wWtQFuwmFsrNWI+
         RGAZNV/8pRqoyqPhn0oIMyLBs6b0fl6AIGEiRJ6lxkR4Kfp8IkYTZHThLjsa6jteOU2g
         9E0CRMa+72lezc9X4MkNsVyPoc2+dk8t7KfBmX+LEgeHfJZCiHVBn1QHzN1sfKU69bIq
         yoiGUqT4oaeOy4CHMDokRLlzuVAIF8APlFFCZlOXXDxqLjywSsA5zrkpt9n2X6xyOI4N
         /R3niRava1nFSVMtoAzkiOAJFlqtmw+G5uYYVrTdIAppzg600bOBZbFPpzrcxsLgFgty
         13Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=J8rTFWjeRom2OSy8/VgjlS2zWoMCCYdnebKLS5jGnMQ=;
        b=PQxB1Ixoj+ASWG4MeoT5FJ+uOMezRzO9gaDpunqK3Pi7LqmM9OSBemCWJHVfDuu3gM
         +hgGLkxG35ifiKrB6R0uGZHXqXn8nhuPKyAj0MCOdg2NJtFQdMABXojVfTxk8l9oPy73
         9njeSqRCwUzMMCbjtJ9/V0LB04IU0EUu4xZRoiJEMKLfweNT9sJxQG3HQOrHh7JuXTgv
         FLacWPuGymmAtPQXHbMG2QrcbrTotuVL84nOe40lsGvtJ5unkbHpJq0wPyT41jw7ncUF
         cHZ0GpZP8SQHqxZ2tLBOmPbfSHfWtNT9YQkxHxMVhMDQIGEk2wqyqU4f87ZtDOkIcgJe
         LM7g==
X-Gm-Message-State: APjAAAUvuD7ny2r7gnKiPlh7iBLqjh1WcVFcfFU4rbfMSVSi10yEONa2
        LccQum/40wNg/TAtTk9GVvrn/QL2DJiiv2L1kcwide97I6uXKVpCOBUwcQIp93ba2K8XduVGwu8
        DuJITpoiIxVkOojywJ/hzxBqnuGNn7F36IigORpMKfCmktAyXXjhEYRCsQJZnPAOY3/pgnYCU3w
        ==
X-Google-Smtp-Source: APXvYqwxfILcl6/l6QrOEJ6qfvAqVQG8Oo5bUP7AsgayBruTImS3+R7SArbGuKwk3lnvawBiNzOKRQ==
X-Received: by 2002:a5d:4ec2:: with SMTP id s2mr10819748wrv.291.1575565433523;
        Thu, 05 Dec 2019 09:03:53 -0800 (PST)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id b2sm13004971wrr.76.2019.12.05.09.03.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 05 Dec 2019 09:03:52 -0800 (PST)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net 1/2] net: core: rename indirect block ingress cb function
Date:   Thu,  5 Dec 2019 17:03:34 +0000
Message-Id: <1575565415-22942-2-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1575565415-22942-1-git-send-email-john.hurley@netronome.com>
References: <1575565415-22942-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With indirect blocks, a driver can register for callbacks from a device
that is does not 'own', for example, a tunnel device. When registering to
or unregistering from a new device, a callback is triggered to generate
a bind/unbind event. This, in turn, allows the driver to receive any
existing rules or to properly clean up installed rules.

When first added, it was assumed that all indirect block registrations
would be for ingress offloads. However, the NFP driver can, in some
instances, support clsact qdisc binds for egress offload.

Change the name of the indirect block callback command in flow_offload to
remove the 'ingress' identifier from it. While this does not change
functionality, a follow up patch will implement a more more generic
callback than just those currently just supporting ingress offload.

Fixes: 4d12ba42787b ("nfp: flower: allow offloading of matches on 'internal' ports")
Signed-off-by: John Hurley <john.hurley@netronome.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/net/flow_offload.h        | 15 ++++++-------
 net/core/flow_offload.c           | 45 +++++++++++++++++++--------------------
 net/netfilter/nf_tables_offload.c |  6 +++---
 net/sched/cls_api.c               |  4 ++--
 4 files changed, 34 insertions(+), 36 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 86c567f..c6f7bd2 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -380,19 +380,18 @@ static inline void flow_block_init(struct flow_block *flow_block)
 typedef int flow_indr_block_bind_cb_t(struct net_device *dev, void *cb_priv,
 				      enum tc_setup_type type, void *type_data);
 
-typedef void flow_indr_block_ing_cmd_t(struct net_device *dev,
-					flow_indr_block_bind_cb_t *cb,
-					void *cb_priv,
-					enum flow_block_command command);
+typedef void flow_indr_block_cmd_t(struct net_device *dev,
+				   flow_indr_block_bind_cb_t *cb, void *cb_priv,
+				   enum flow_block_command command);
 
-struct flow_indr_block_ing_entry {
-	flow_indr_block_ing_cmd_t *cb;
+struct flow_indr_block_entry {
+	flow_indr_block_cmd_t *cb;
 	struct list_head	list;
 };
 
-void flow_indr_add_block_ing_cb(struct flow_indr_block_ing_entry *entry);
+void flow_indr_add_block_cb(struct flow_indr_block_entry *entry);
 
-void flow_indr_del_block_ing_cb(struct flow_indr_block_ing_entry *entry);
+void flow_indr_del_block_cb(struct flow_indr_block_entry *entry);
 
 int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 				  flow_indr_block_bind_cb_t *cb,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index cf52d9c..45b6a59 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -283,7 +283,7 @@ int flow_block_cb_setup_simple(struct flow_block_offload *f,
 }
 EXPORT_SYMBOL(flow_block_cb_setup_simple);
 
-static LIST_HEAD(block_ing_cb_list);
+static LIST_HEAD(block_cb_list);
 
 static struct rhashtable indr_setup_block_ht;
 
@@ -391,20 +391,19 @@ static void flow_indr_block_cb_del(struct flow_indr_block_cb *indr_block_cb)
 	kfree(indr_block_cb);
 }
 
-static DEFINE_MUTEX(flow_indr_block_ing_cb_lock);
+static DEFINE_MUTEX(flow_indr_block_cb_lock);
 
-static void flow_block_ing_cmd(struct net_device *dev,
-			       flow_indr_block_bind_cb_t *cb,
-			       void *cb_priv,
-			       enum flow_block_command command)
+static void flow_block_cmd(struct net_device *dev,
+			   flow_indr_block_bind_cb_t *cb, void *cb_priv,
+			   enum flow_block_command command)
 {
-	struct flow_indr_block_ing_entry *entry;
+	struct flow_indr_block_entry *entry;
 
-	mutex_lock(&flow_indr_block_ing_cb_lock);
-	list_for_each_entry(entry, &block_ing_cb_list, list) {
+	mutex_lock(&flow_indr_block_cb_lock);
+	list_for_each_entry(entry, &block_cb_list, list) {
 		entry->cb(dev, cb, cb_priv, command);
 	}
-	mutex_unlock(&flow_indr_block_ing_cb_lock);
+	mutex_unlock(&flow_indr_block_cb_lock);
 }
 
 int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
@@ -424,8 +423,8 @@ int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 	if (err)
 		goto err_dev_put;
 
-	flow_block_ing_cmd(dev, indr_block_cb->cb, indr_block_cb->cb_priv,
-			   FLOW_BLOCK_BIND);
+	flow_block_cmd(dev, indr_block_cb->cb, indr_block_cb->cb_priv,
+		       FLOW_BLOCK_BIND);
 
 	return 0;
 
@@ -464,8 +463,8 @@ void __flow_indr_block_cb_unregister(struct net_device *dev,
 	if (!indr_block_cb)
 		return;
 
-	flow_block_ing_cmd(dev, indr_block_cb->cb, indr_block_cb->cb_priv,
-			   FLOW_BLOCK_UNBIND);
+	flow_block_cmd(dev, indr_block_cb->cb, indr_block_cb->cb_priv,
+		       FLOW_BLOCK_UNBIND);
 
 	flow_indr_block_cb_del(indr_block_cb);
 	flow_indr_block_dev_put(indr_dev);
@@ -499,21 +498,21 @@ void flow_indr_block_call(struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(flow_indr_block_call);
 
-void flow_indr_add_block_ing_cb(struct flow_indr_block_ing_entry *entry)
+void flow_indr_add_block_cb(struct flow_indr_block_entry *entry)
 {
-	mutex_lock(&flow_indr_block_ing_cb_lock);
-	list_add_tail(&entry->list, &block_ing_cb_list);
-	mutex_unlock(&flow_indr_block_ing_cb_lock);
+	mutex_lock(&flow_indr_block_cb_lock);
+	list_add_tail(&entry->list, &block_cb_list);
+	mutex_unlock(&flow_indr_block_cb_lock);
 }
-EXPORT_SYMBOL_GPL(flow_indr_add_block_ing_cb);
+EXPORT_SYMBOL_GPL(flow_indr_add_block_cb);
 
-void flow_indr_del_block_ing_cb(struct flow_indr_block_ing_entry *entry)
+void flow_indr_del_block_cb(struct flow_indr_block_entry *entry)
 {
-	mutex_lock(&flow_indr_block_ing_cb_lock);
+	mutex_lock(&flow_indr_block_cb_lock);
 	list_del(&entry->list);
-	mutex_unlock(&flow_indr_block_ing_cb_lock);
+	mutex_unlock(&flow_indr_block_cb_lock);
 }
-EXPORT_SYMBOL_GPL(flow_indr_del_block_ing_cb);
+EXPORT_SYMBOL_GPL(flow_indr_del_block_cb);
 
 static int __init init_flow_indr_rhashtable(void)
 {
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 68f17a69..431f3b8 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -588,7 +588,7 @@ static int nft_offload_netdev_event(struct notifier_block *this,
 	return NOTIFY_DONE;
 }
 
-static struct flow_indr_block_ing_entry block_ing_entry = {
+static struct flow_indr_block_entry block_ing_entry = {
 	.cb	= nft_indr_block_cb,
 	.list	= LIST_HEAD_INIT(block_ing_entry.list),
 };
@@ -605,13 +605,13 @@ int nft_offload_init(void)
 	if (err < 0)
 		return err;
 
-	flow_indr_add_block_ing_cb(&block_ing_entry);
+	flow_indr_add_block_cb(&block_ing_entry);
 
 	return 0;
 }
 
 void nft_offload_exit(void)
 {
-	flow_indr_del_block_ing_cb(&block_ing_entry);
+	flow_indr_del_block_cb(&block_ing_entry);
 	unregister_netdevice_notifier(&nft_offload_netdev_notifier);
 }
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 20d60b8..75b4808 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3626,7 +3626,7 @@ static struct pernet_operations tcf_net_ops = {
 	.size = sizeof(struct tcf_net),
 };
 
-static struct flow_indr_block_ing_entry block_ing_entry = {
+static struct flow_indr_block_entry block_ing_entry = {
 	.cb = tc_indr_block_get_and_ing_cmd,
 	.list = LIST_HEAD_INIT(block_ing_entry.list),
 };
@@ -3643,7 +3643,7 @@ static int __init tc_filter_init(void)
 	if (err)
 		goto err_register_pernet_subsys;
 
-	flow_indr_add_block_ing_cb(&block_ing_entry);
+	flow_indr_add_block_cb(&block_ing_entry);
 
 	rtnl_register(PF_UNSPEC, RTM_NEWTFILTER, tc_new_tfilter, NULL,
 		      RTNL_FLAG_DOIT_UNLOCKED);
-- 
2.7.4

