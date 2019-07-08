Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E376270A
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 19:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732879AbfGHR0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 13:26:18 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35703 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728744AbfGHR0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 13:26:17 -0400
Received: by mail-wr1-f68.google.com with SMTP id y4so9445423wrm.2
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 10:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=laIe1oO3/TD+SpjZO01kcORWWEtDlsMggr6g/ttesJw=;
        b=TWyabnrOZMEw0USJiM8upXVFlA94tYNdp4t4iQ8BwPeCWQHkfbbnqqV4UAbTO1l8o9
         eP2bcd2BNRebTDAk0h0gIbwbi8apTjx6qnoB7JWMExNpnCTq6Hu70XGzyl4PXxCbqKVk
         0iuWAxe0rAzPacLd7VlrIFxdUVXgcO2YoSdcvi0XY0BG+N4EFkiV53NVpmy2azrH7eGO
         3Vpmh6arWETyzAileD8oY1t3wgUCjz305nfuPrD7qzpZQlQU/Rsq707dWIkRSj3opeIZ
         m34x5u/eEOdUC5/q65w9ZVnlWsfPkjgEsPrfKapI/yXjOayUIbwhOlVb984tXagwlE+x
         ykhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=laIe1oO3/TD+SpjZO01kcORWWEtDlsMggr6g/ttesJw=;
        b=JdEtWOwfSOhFrsUeSLSh53rWXUhFdD98zJZGvmBE/rajgSQroPw/ZFIgpP4V5kYsos
         zJnT4QckT8RNRh1f1WaeC+HR6ClK6nWb9uhzNDAaG1nk8xIrauvnKvEG3aAbPg4r4FoJ
         qX5nYptD/DS98aPROVtQJy9uMJINlPQPwWo/JfAhyGD/B5QxrWQAXCISQl0oZy2+8VR3
         PU2nslp+GTPdb/jPQV8YuXnYSSMzixL9y3FDuvlksPBe9wvoTcw5qSG6ayqOa7BWSflW
         mMwfI3fzHGjrge1iDg79+05Q3Z/0F9+Paa18qW/YP2pxxV1S+6KQWOrboeqso4lc5rQl
         IATg==
X-Gm-Message-State: APjAAAUIZmaV7N1rfewOlQ2OS0LQsdLWMvn+gLPTHeWNx7k4WZL8NJ4r
        eWprG1jPi9nCct1D429eHvYEwQ==
X-Google-Smtp-Source: APXvYqzL7etP72TdaZ1/WXt96wqAcjrj3TDD1y4V+6nk9kkw8lyLHOmPxS65F05L1bsz4YOvuwiLCw==
X-Received: by 2002:a5d:4f01:: with SMTP id c1mr4860990wru.43.1562606774614;
        Mon, 08 Jul 2019 10:26:14 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id w24sm122566wmc.30.2019.07.08.10.26.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 10:26:14 -0700 (PDT)
Date:   Mon, 8 Jul 2019 19:26:13 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        peppe.cavallaro@st.com, grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ogerlitz@mellanox.com, Manish.Chopra@cavium.com,
        marcelo.leitner@gmail.com, mkubecek@suse.cz,
        venkatkumar.duvvuru@broadcom.com, maxime.chevallier@bootlin.com,
        cphealy@gmail.com, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next,v3 05/11] net: flow_offload: add list handling
 functions
Message-ID: <20190708172613.GA2282@nanopsycho.orion>
References: <20190708160614.2226-1-pablo@netfilter.org>
 <20190708160614.2226-6-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708160614.2226-6-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 08, 2019 at 06:06:07PM CEST, pablo@netfilter.org wrote:
>This patch adds the list handling functions for the flow block API:
>
>* flow_block_cb_lookup() allows drivers to look up for existing flow blocks.
>* flow_block_cb_add() adds a flow block to the list to be registered by the
>  core.

Per driver? You say "per driver" in the "remove" part.


>* flow_block_cb_remove() to remove a flow block from the list of existing
>  flow blocks per driver and to request the core to unregister this.
>
>The flow block API also annotates the netns this flow block belongs to.
>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>---
>v3: extracted from former patch "net: flow_offload: add flow_block_cb API".
>
> include/net/flow_offload.h | 20 ++++++++++++++++++++
> net/core/flow_offload.c    | 18 ++++++++++++++++++
> net/sched/cls_api.c        |  3 +++
> 3 files changed, 41 insertions(+)
>
>diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>index bcc4e2fef6ba..06acde2960fa 100644
>--- a/include/net/flow_offload.h
>+++ b/include/net/flow_offload.h
>@@ -251,12 +251,16 @@ struct flow_block_offload {
> 	enum flow_block_command command;
> 	enum flow_block_binder_type binder_type;
> 	struct tcf_block *block;
>+	struct net *net;
>+	struct list_head cb_list;
> 	struct list_head *driver_block_list;
> 	struct netlink_ext_ack *extack;
> };
> 
> struct flow_block_cb {
>+	struct list_head	driver_list;
> 	struct list_head	list;
>+	struct net		*net;
> 	tc_setup_cb_t		*cb;
> 	void			*cb_ident;
> 	void			*cb_priv;
>@@ -269,6 +273,22 @@ struct flow_block_cb *flow_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,
> 					  void (*release)(void *cb_priv));
> void flow_block_cb_free(struct flow_block_cb *block_cb);
> 
>+struct flow_block_cb *flow_block_cb_lookup(struct net *net,
>+					   struct list_head *driver_flow_block_list,
>+					   tc_setup_cb_t *cb, void *cb_ident);
>+
>+static inline void flow_block_cb_add(struct flow_block_cb *block_cb,
>+				     struct flow_block_offload *offload)
>+{
>+	list_add_tail(&block_cb->driver_list, &offload->cb_list);
>+}
>+
>+static inline void flow_block_cb_remove(struct flow_block_cb *block_cb,
>+					struct flow_block_offload *offload)
>+{
>+	list_move(&block_cb->driver_list, &offload->cb_list);
>+}
>+
> int flow_block_cb_setup_simple(struct flow_block_offload *f,
> 			       struct list_head *driver_list, tc_setup_cb_t *cb,
> 			       void *cb_ident, void *cb_priv, bool ingress_only);
>diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
>index d08148cb6953..85fd5f4a1e0f 100644
>--- a/net/core/flow_offload.c
>+++ b/net/core/flow_offload.c
>@@ -176,6 +176,7 @@ struct flow_block_cb *flow_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,
> 	if (!block_cb)
> 		return ERR_PTR(-ENOMEM);
> 
>+	block_cb->net = net;
> 	block_cb->cb = cb;
> 	block_cb->cb_ident = cb_ident;
> 	block_cb->cb_priv = cb_priv;
>@@ -194,6 +195,23 @@ void flow_block_cb_free(struct flow_block_cb *block_cb)
> }
> EXPORT_SYMBOL(flow_block_cb_free);
> 
>+struct flow_block_cb *flow_block_cb_lookup(struct net *net,
>+					   struct list_head *driver_block_list,

In the header, you call this "driver_flow_block_list".

Where is this list coming from? In general, I don't think it is good to
have struct list_head as an arg of exported symbol. Should be contained
in some struct. Looks like this might be the "struct
flow_block_offload"?

Does this have anything to do with "struct list_head
*driver_block_list"? This is very confusing...



>+					   tc_setup_cb_t *cb, void *cb_ident)
>+{
>+	struct flow_block_cb *block_cb;
>+
>+	list_for_each_entry(block_cb, driver_block_list, driver_list) {
>+		if (block_cb->net == net &&
>+		    block_cb->cb == cb &&
>+		    block_cb->cb_ident == cb_ident)
>+			return block_cb;
>+	}
>+
>+	return NULL;
>+}
>+EXPORT_SYMBOL(flow_block_cb_lookup);
>+
> int flow_block_cb_setup_simple(struct flow_block_offload *f,
> 			       struct list_head *driver_block_list,
> 			       tc_setup_cb_t *cb, void *cb_ident, void *cb_priv,
>diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>index fa0c451aca59..72761b43ae41 100644
>--- a/net/sched/cls_api.c
>+++ b/net/sched/cls_api.c
>@@ -679,6 +679,7 @@ static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
> 	struct tc_block_offload bo = {
> 		.command	= command,
> 		.binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
>+		.net		= dev_net(indr_dev->dev),
> 		.block		= indr_dev->block,
> 	};
> 
>@@ -767,6 +768,7 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
> 	struct tc_block_offload bo = {
> 		.command	= command,
> 		.binder_type	= ei->binder_type,
>+		.net		= dev_net(dev),
> 		.block		= block,
> 		.extack		= extack,
> 	};
>@@ -795,6 +797,7 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
> {
> 	struct tc_block_offload bo = {};
> 
>+	bo.net = dev_net(dev);
> 	bo.command = command;
> 	bo.binder_type = ei->binder_type;
> 	bo.block = block;
>-- 
>2.11.0
>
