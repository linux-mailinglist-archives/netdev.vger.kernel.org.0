Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F696613361
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 11:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiJaKNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 06:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiJaKNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 06:13:15 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106D4DF11
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 03:13:13 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id fn7-20020a05600c688700b003b4fb113b86so7705354wmb.0
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 03:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ryIaMazqnFqcUwJwOy/+lzOIXIT8CnKBUUltibz4SW8=;
        b=GoLaRt5XPEWNGR+XcW8ml/KP+XikBd80zZxZiQ+Fm35ZXqBCzTz7yOyjlxFyxF2T1z
         MrpUJbiBT2xIdelR502S6qc6kqjQb2Q7aqV98K15M3ViYDF0+WbADjy0iLAi00rGurb6
         DuYPMR7Z5o2rNkR4t18PVqDFdVh7uPjIUGocqmAytY/wfzHVd4n5UizqSA/SOzhZ2USY
         iSy9V/jzqNZvGupHxlrK7t9HyJjUN0dqH+JzP9YYh0MwCPHUB0LESiqzdRFj9iPcJ6Ja
         dNbeV/oHo/DVliyLsLg5vUEs5XWx5VFJCkbj0RxP0RE3NWKh24fEhpdlMLw38LBZdYl+
         eTeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ryIaMazqnFqcUwJwOy/+lzOIXIT8CnKBUUltibz4SW8=;
        b=JHki4AQZyUZ7vvqQrEzJ/7jH5kWymksaBglri3KsZMv+aOL9etMTF6A4TzIy7IhA1h
         SFR6FWE/8DtK6pgPFx5jrwwwLxtj7drtm6gyZVGGciNHj0VDgfDQM5EFBbs7h8/Q/1XC
         RKKk8kggldbQC/j7Mdg5kj+s2iQl0X36Bp/HgDYoMB0mKW8ea9ltgyfikQnP4TCR+Z1h
         U+FCcpL4C9bR5zWnTBcjRP5M0ygQDsFbH+HTkJoqaY18lGh5Ur1L/kRbZLmPvx0zhdsD
         4mJhEk+hW6fgCPkX8eyB5tATHGsEcHjtG9GeXnlJ9qHhtRsHvhvWjGUmndT2gONBmwSO
         NcjA==
X-Gm-Message-State: ACrzQf3IlP6GtJOYQfFCXUIfVXkMMIJ9TxAlhfR6g/U5bz9s5do+JrVP
        SCS6iTuni3xy1jmEpef56vL4+w==
X-Google-Smtp-Source: AMsMyM7Zprz2tfubiPmgTZeAvRtUKgywFC0UWtpyDFnqzSvKvz52UyEY+7oRRtTkbHZTcFFL7boaWw==
X-Received: by 2002:a1c:5454:0:b0:3cf:7521:3543 with SMTP id p20-20020a1c5454000000b003cf75213543mr1247257wmi.172.1667211191500;
        Mon, 31 Oct 2022 03:13:11 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id i9-20020a0560001ac900b00228a6ce17b4sm7144635wry.37.2022.10.31.03.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 03:13:10 -0700 (PDT)
Date:   Mon, 31 Oct 2022 11:13:09 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next v8 1/9] devlink: Introduce new parameter
 'tx_priority' to devlink-rate
Message-ID: <Y1+ftW7vmzJlg48+@nanopsycho>
References: <20221028105143.3517280-1-michal.wilczynski@intel.com>
 <20221028105143.3517280-2-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028105143.3517280-2-michal.wilczynski@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Oct 28, 2022 at 12:51:35PM CEST, michal.wilczynski@intel.com wrote:
>To fully utilize offload capabilities of Intel 100G card QoS capabilities
>new parameter 'tx_priority' needs to be introduced. This parameter allows

It is highly confusing to call this "parameter". Devlink parameters are
totally different thing. This is just another netlink attribute for
devlink rate object.


>for usage of strict priority arbiter among siblings. This arbitration
>scheme attempts to schedule nodes based on their priority as long as the
>nodes remain within their bandwidth limit.
>
>Introduce new parameter in devlink-rate that will allow for
>configuration of strict priority.
>
>Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
>---
> include/net/devlink.h        |  6 ++++++
> include/uapi/linux/devlink.h |  1 +
> net/core/devlink.c           | 29 +++++++++++++++++++++++++++++
> 3 files changed, 36 insertions(+)
>
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index ba6b8b094943..9d2b0c3c4ad3 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -114,6 +114,8 @@ struct devlink_rate {
> 			refcount_t refcnt;
> 		};
> 	};
>+
>+	u16 tx_priority;
> };
> 
> struct devlink_port {
>@@ -1493,10 +1495,14 @@ struct devlink_ops {
> 				      u64 tx_share, struct netlink_ext_ack *extack);
> 	int (*rate_leaf_tx_max_set)(struct devlink_rate *devlink_rate, void *priv,
> 				    u64 tx_max, struct netlink_ext_ack *extack);
>+	int (*rate_leaf_tx_priority_set)(struct devlink_rate *devlink_rate, void *priv,
>+					 u64 tx_priority, struct netlink_ext_ack *extack);
> 	int (*rate_node_tx_share_set)(struct devlink_rate *devlink_rate, void *priv,
> 				      u64 tx_share, struct netlink_ext_ack *extack);
> 	int (*rate_node_tx_max_set)(struct devlink_rate *devlink_rate, void *priv,
> 				    u64 tx_max, struct netlink_ext_ack *extack);
>+	int (*rate_node_tx_priority_set)(struct devlink_rate *devlink_rate, void *priv,
>+					 u64 tx_priority, struct netlink_ext_ack *extack);
> 	int (*rate_node_new)(struct devlink_rate *rate_node, void **priv,
> 			     struct netlink_ext_ack *extack);
> 	int (*rate_node_del)(struct devlink_rate *rate_node, void *priv,
>diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>index 2f24b53a87a5..b3df5bc45ba5 100644
>--- a/include/uapi/linux/devlink.h
>+++ b/include/uapi/linux/devlink.h
>@@ -607,6 +607,7 @@ enum devlink_attr {
> 
> 	DEVLINK_ATTR_SELFTESTS,			/* nested */
> 
>+	DEVLINK_ATTR_RATE_TX_PRIORITY,		/* u16 */
> 	/* add new attributes above here, update the policy in devlink.c */
> 
> 	__DEVLINK_ATTR_MAX,
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 89baa7c0938b..2586b1307cb4 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -1184,6 +1184,9 @@ static int devlink_nl_rate_fill(struct sk_buff *msg,
> 			      devlink_rate->tx_max, DEVLINK_ATTR_PAD))
> 		goto nla_put_failure;
> 
>+	if (nla_put_u16(msg, DEVLINK_ATTR_RATE_TX_PRIORITY,
>+			devlink_rate->tx_priority))
>+		goto nla_put_failure;
> 	if (devlink_rate->parent)
> 		if (nla_put_string(msg, DEVLINK_ATTR_RATE_PARENT_NODE_NAME,
> 				   devlink_rate->parent->name))
>@@ -1924,6 +1927,7 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
> {
> 	struct nlattr *nla_parent, **attrs = info->attrs;
> 	int err = -EOPNOTSUPP;
>+	u16 priority;
> 	u64 rate;
> 
> 	if (attrs[DEVLINK_ATTR_RATE_TX_SHARE]) {
>@@ -1952,6 +1956,20 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
> 		devlink_rate->tx_max = rate;
> 	}
> 
>+	if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY]) {
>+		priority = nla_get_u16(attrs[DEVLINK_ATTR_RATE_TX_PRIORITY]);
>+		if (devlink_rate_is_leaf(devlink_rate))
>+			err = ops->rate_leaf_tx_priority_set(devlink_rate, devlink_rate->priv,
>+							priority, info->extack);
>+		else if (devlink_rate_is_node(devlink_rate))
>+			err = ops->rate_node_tx_priority_set(devlink_rate, devlink_rate->priv,
>+							priority, info->extack);
>+
>+		if (err)
>+			return err;
>+		devlink_rate->tx_priority = priority;
>+	}
>+
> 	nla_parent = attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME];
> 	if (nla_parent) {
> 		err = devlink_nl_rate_parent_node_set(devlink_rate, info,
>@@ -1983,6 +2001,11 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
> 			NL_SET_ERR_MSG_MOD(info->extack, "Parent set isn't supported for the leafs");
> 			return false;
> 		}
>+		if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY] && !ops->rate_leaf_tx_priority_set) {
>+			NL_SET_ERR_MSG_MOD(info->extack,
>+					   "TX priority set isn't supported for the leafs");
>+			return false;
>+		}
> 	} else if (type == DEVLINK_RATE_TYPE_NODE) {
> 		if (attrs[DEVLINK_ATTR_RATE_TX_SHARE] && !ops->rate_node_tx_share_set) {
> 			NL_SET_ERR_MSG_MOD(info->extack, "TX share set isn't supported for the nodes");
>@@ -1997,6 +2020,11 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
> 			NL_SET_ERR_MSG_MOD(info->extack, "Parent set isn't supported for the nodes");
> 			return false;
> 		}
>+		if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY] && !ops->rate_node_tx_priority_set) {
>+			NL_SET_ERR_MSG_MOD(info->extack,
>+					   "TX priority set isn't supported for the nodes");
>+			return false;
>+		}
> 	} else {
> 		WARN(1, "Unknown type of rate object");
> 		return false;
>@@ -9172,6 +9200,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
> 	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
> 	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
> 	[DEVLINK_ATTR_SELFTESTS] = { .type = NLA_NESTED },
>+	[DEVLINK_ATTR_RATE_TX_PRIORITY] = { .type = NLA_U16 },

Why not u32?


> };
> 
> static const struct genl_small_ops devlink_nl_ops[] = {
>-- 
>2.37.2
>
