Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6486E657CC
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 15:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbfGKNSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 09:18:44 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33255 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728527AbfGKNSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 09:18:44 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so6320736wru.0
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 06:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aocntufsZVGBNql5DzhcGPk+lOcsOz5bTYe18w9n+WM=;
        b=X+LIi7gjdv7tQtPjy/O68qSAbYJlfnhcCM7Tn3BaejGKBCaYFJdi51qchQ+TqO90dc
         UoCMWzV6L46wNdt4N1kQHktQqzeGbwkr6kYQjhbvZJv9pVJr9fL+cxyCq4eWn0l1d7uG
         C6WrWMBz21/fXyOakc7dtrCdnebY1h489xM1jN0T6GQuDvGh+NGETvekV+GUlS03jo1g
         dEF0m7keX+vNfcouWP/XM82rtT2CvxvMAn2EXZJO5EJq/x+wr6s8wlYBxjD1UZFvkgZM
         C44+RLZHc23dil1bY7GFDwrAr1h1/fGrprqvz/bCm5wot4GtuNB/QmUGJpg7LHskpfeV
         NVLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aocntufsZVGBNql5DzhcGPk+lOcsOz5bTYe18w9n+WM=;
        b=HK5/Lw++r/rKvDtbjN9zVN65cqBFVNgPfkKpZ28GWWDHoMTRI/6hiqwkKSXUcLpq/4
         Np6PzjpwniaMYn7BFxriwmFxJBonXRApZpLwZqSWdZv3KxakLmAb60xPdOR65tZXBta0
         0SDvauV+dagcPUYxkZ7HoJydwSIn/Mpc5Bu5HVBiIUDnH0WWZHI3XDADnOIO54dcyjr6
         S4ZJwUEY749bUnrYDwrswaxnl4cDW2bk41klVwnkuq5nEEU4v0bvhfdJt/DXvgz0RqrH
         fH9cBhBrLS7htRncykbMVD72/+0wQquKwWTXH+OsI2OUpD2XQW8Pe+3w7Xw/lUKk/5rp
         Urbg==
X-Gm-Message-State: APjAAAWTesr6gc/uY+QsXFQpVfH9uXDlkt9f6iCmjOhdqFI1Ca5qMSPz
        hftSaKMGPLEwz7LrF4FjoMg=
X-Google-Smtp-Source: APXvYqzRJZVlhJqHw9X4WM3Pnu8Uk1g48mDdMvq5ObUxft9zoi0AtT3PrbRlVRTv15fTLoLykDQg1A==
X-Received: by 2002:adf:dc51:: with SMTP id m17mr5508827wrj.256.1562851121329;
        Thu, 11 Jul 2019 06:18:41 -0700 (PDT)
Received: from localhost (ip-89-176-1-116.net.upcbroadband.cz. [89.176.1.116])
        by smtp.gmail.com with ESMTPSA id 91sm10129252wrp.3.2019.07.11.06.18.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 06:18:40 -0700 (PDT)
Date:   Thu, 11 Jul 2019 15:18:40 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next 3/3] net: flow_offload: add flow_block structure
 and use it
Message-ID: <20190711131840.GL2291@nanopsycho>
References: <20190711001235.20686-1-pablo@netfilter.org>
 <20190711001235.20686-3-pablo@netfilter.org>
 <20190711080609.GF2291@nanopsycho>
 <20190711131300.ojbo5hxzvv6wi44t@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711131300.ojbo5hxzvv6wi44t@salvia>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 11, 2019 at 03:13:00PM CEST, pablo@netfilter.org wrote:
>On Thu, Jul 11, 2019 at 10:06:09AM +0200, Jiri Pirko wrote:
>> Thu, Jul 11, 2019 at 02:12:35AM CEST, pablo@netfilter.org wrote:
>> >This object stores the flow block callbacks that are attached to this
>> >block. This patch restores block sharing.
>> >
>> >Fixes: da3eeb904ff4 ("net: flow_offload: add list handling functions")
>> >Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>> >---
>> > include/net/flow_offload.h        |  5 +++++
>> > include/net/netfilter/nf_tables.h |  5 +++--
>> > include/net/sch_generic.h         |  2 +-
>> > net/core/flow_offload.c           |  2 +-
>> > net/netfilter/nf_tables_api.c     |  2 +-
>> > net/netfilter/nf_tables_offload.c |  5 +++--
>> > net/sched/cls_api.c               | 10 +++++++---
>> > 7 files changed, 21 insertions(+), 10 deletions(-)
>> >
>> >diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>> >index 98bf3af5c84d..e50d94736829 100644
>> >--- a/include/net/flow_offload.h
>> >+++ b/include/net/flow_offload.h
>> >@@ -248,6 +248,10 @@ enum flow_block_binder_type {
>> > 	FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS,
>> > };
>> > 
>> >+struct flow_block {
>> >+	struct list_head cb_list;
>> >+};
>> >+
>> > struct netlink_ext_ack;
>> > 
>> > struct flow_block_offload {
>> >@@ -255,6 +259,7 @@ struct flow_block_offload {
>> > 	enum flow_block_binder_type binder_type;
>> > 	bool block_shared;
>> > 	struct net *net;
>> >+	struct flow_block *block;
>> > 	struct list_head cb_list;
>> > 	struct list_head *driver_block_list;
>> > 	struct netlink_ext_ack *extack;
>> >diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
>> >index 35dfdd9f69b3..00658462f89b 100644
>> >--- a/include/net/netfilter/nf_tables.h
>> >+++ b/include/net/netfilter/nf_tables.h
>> >@@ -11,6 +11,7 @@
>> > #include <linux/rhashtable.h>
>> > #include <net/netfilter/nf_flow_table.h>
>> > #include <net/netlink.h>
>> >+#include <net/flow_offload.h>
>> > 
>> > struct module;
>> > 
>> >@@ -951,7 +952,7 @@ struct nft_stats {
>> >  *	@stats: per-cpu chain stats
>> >  *	@chain: the chain
>> >  *	@dev_name: device name that this base chain is attached to (if any)
>> >- *	@cb_list: list of flow block callbacks (for hardware offload)
>> >+ *	@block: flow block (for hardware offload)
>> >  */
>> > struct nft_base_chain {
>> > 	struct nf_hook_ops		ops;
>> >@@ -961,7 +962,7 @@ struct nft_base_chain {
>> > 	struct nft_stats __percpu	*stats;
>> > 	struct nft_chain		chain;
>> > 	char 				dev_name[IFNAMSIZ];
>> >-	struct list_head		cb_list;
>> >+	struct flow_block		block;
>> > };
>> > 
>> > static inline struct nft_base_chain *nft_base_chain(const struct nft_chain *chain)
>> >diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
>> >index 9482e060483b..58041cb0ce15 100644
>> >--- a/include/net/sch_generic.h
>> >+++ b/include/net/sch_generic.h
>> >@@ -399,7 +399,7 @@ struct tcf_block {
>> > 	refcount_t refcnt;
>> > 	struct net *net;
>> > 	struct Qdisc *q;
>> >-	struct list_head cb_list;
>> >+	struct flow_block flow;
>> 
>> It is not a "flow", that is confusing. It should be named "flow_block".
>
>Done.
>
>> > 	struct list_head owner_list;
>> > 	bool keep_dst;
>> > 	unsigned int offloadcnt; /* Number of oddloaded filters */
>> >diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
>> >index a800fa78d96c..935c7f81a9ef 100644
>> >--- a/net/core/flow_offload.c
>> >+++ b/net/core/flow_offload.c
>> >@@ -198,7 +198,7 @@ struct flow_block_cb *flow_block_cb_lookup(struct flow_block_offload *f,
>> > {
>> > 	struct flow_block_cb *block_cb;
>> > 
>> >-	list_for_each_entry(block_cb, f->driver_block_list, driver_list) {
>> >+	list_for_each_entry(block_cb, &f->block->cb_list, list) {
>> 
>> Please made struct flow_block *block and argument of cb_lookup instead
>> of struct flow_block_offload *f (as it was previously).
>
>I can do so if you insist, this will make this fix larger.

Yes please. Thanks!


>
>> > 		if (block_cb->cb == cb &&
>> > 		    block_cb->cb_ident == cb_ident)
>> > 			return block_cb;
>> >diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>> >index ed17a7c29b86..c565f146435b 100644
>> >--- a/net/netfilter/nf_tables_api.c
>> >+++ b/net/netfilter/nf_tables_api.c
>> >@@ -1662,7 +1662,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
>> > 
>> > 		chain->flags |= NFT_BASE_CHAIN | flags;
>> > 		basechain->policy = NF_ACCEPT;
>> >-		INIT_LIST_HEAD(&basechain->cb_list);
>> >+		INIT_LIST_HEAD(&basechain->block.cb_list);
>> > 	} else {
>> > 		chain = kzalloc(sizeof(*chain), GFP_KERNEL);
>> > 		if (chain == NULL)
>> >diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
>> >index 2c3302845f67..2a184277ee58 100644
>> >--- a/net/netfilter/nf_tables_offload.c
>> >+++ b/net/netfilter/nf_tables_offload.c
>> >@@ -116,7 +116,7 @@ static int nft_setup_cb_call(struct nft_base_chain *basechain,
>> > 	struct flow_block_cb *block_cb;
>> > 	int err;
>> > 
>> >-	list_for_each_entry(block_cb, &basechain->cb_list, list) {
>> >+	list_for_each_entry(block_cb, &basechain->block.cb_list, list) {
>> > 		err = block_cb->cb(type, type_data, block_cb->cb_priv);
>> > 		if (err < 0)
>> > 			return err;
>> >@@ -154,7 +154,7 @@ static int nft_flow_offload_rule(struct nft_trans *trans,
>> > static int nft_flow_offload_bind(struct flow_block_offload *bo,
>> > 				 struct nft_base_chain *basechain)
>> > {
>> >-	list_splice(&bo->cb_list, &basechain->cb_list);
>> >+	list_splice(&bo->cb_list, &basechain->block.cb_list);
>> > 	return 0;
>> > }
>> > 
>> >@@ -198,6 +198,7 @@ static int nft_flow_offload_chain(struct nft_trans *trans,
>> > 		return -EOPNOTSUPP;
>> > 
>> > 	bo.command = cmd;
>> >+	bo.block = &basechain->block;
>> > 	bo.binder_type = FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
>> > 	bo.extack = &extack;
>> > 	INIT_LIST_HEAD(&bo.cb_list);
>> >diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>> >index 51fbe6e95a92..66181961ad6f 100644
>> >--- a/net/sched/cls_api.c
>> >+++ b/net/sched/cls_api.c
>> >@@ -691,6 +691,8 @@ static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
>> > 	if (!indr_dev->block)
>> > 		return;
>> > 
>> >+	bo.block = &indr_dev->block->flow;
>> >+
>> > 	indr_block_cb->cb(indr_dev->dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
>> > 			  &bo);
>> > 	tcf_block_setup(indr_dev->block, &bo);
>> >@@ -775,6 +777,7 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
>> > 		.command	= command,
>> > 		.binder_type	= ei->binder_type,
>> > 		.net		= dev_net(dev),
>> >+		.block		= &block->flow,
>> > 		.block_shared	= tcf_block_shared(block),
>> > 		.extack		= extack,
>> > 	};
>> >@@ -810,6 +813,7 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
>> > 	bo.net = dev_net(dev);
>> > 	bo.command = command;
>> > 	bo.binder_type = ei->binder_type;
>> >+	bo.block = &block->flow;
>> > 	bo.block_shared = tcf_block_shared(block);
>> > 	bo.extack = extack;
>> > 	INIT_LIST_HEAD(&bo.cb_list);
>> >@@ -988,7 +992,7 @@ static struct tcf_block *tcf_block_create(struct net *net, struct Qdisc *q,
>> > 	}
>> > 	mutex_init(&block->lock);
>> > 	INIT_LIST_HEAD(&block->chain_list);
>> >-	INIT_LIST_HEAD(&block->cb_list);
>> >+	INIT_LIST_HEAD(&block->flow.cb_list);
>> 
>> With introduction of struct flow_block, please introduce also a helper
>> to init this struct. Does not look right to init it from user codes
>> (tc/nft).
>
>Done.
