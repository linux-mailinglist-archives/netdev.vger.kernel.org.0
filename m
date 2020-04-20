Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7941B0F31
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730068AbgDTPEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgDTPEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 11:04:37 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE09C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 08:04:37 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j1so7176154wrt.1
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 08:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AfxYCUagHVkriVFGiHoiFAM/iAAZW4dWCcWu2PXZxWA=;
        b=lT7yUXqtaCjhNU22kXrqmeACaAIfGPuYn8guC9PTQcrJ0wU+d6Q9ztIftNy67fxChX
         3zpCeQ3snDtenTuIvff0kS2EouzZD+L4pBVHxXWzJk6nfNlE8+P9ndo9WIMsLsY1S/mM
         /yXO94aZxdZyaE1UtDGVMoU+ezCqEw2YdOFbSF2AFSZJLdwgQR3SHKGzjT7YEJjE2sWN
         URY4b8vXXwjhufzJBS5B6sRyq5CIM3oWjXx3lFB4OGmxGG3icX9pHGUWG2pdD56VO2/e
         NI0cBCkWS6XItMbrJs7CIbK5tSTp/shR65S2XSGR+d0RUHhz3lI8VBWe708K6ZFzKCkk
         8xrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AfxYCUagHVkriVFGiHoiFAM/iAAZW4dWCcWu2PXZxWA=;
        b=s3rk7BE4qkwlLqXOiryJolGFHqBDXr6qyGLxyH9lzWV5jKuxr2PAvJf4if0yIYgAso
         xtIqS7BoC8s6iUfXOoAAdaKsJFMkhTE+iMqKQaLg7D+zeox9FkOu1yUgZD4tBfJEnZ7M
         0sSR15Vcf/c/cKLReCXf79hMmUFPlye2vxVo3OReJW9xCUbF6Wr++ShHA1vpApv+bgmD
         SARUHVOc2WzEVDjNJH4ROXFkaQ+RVruIh7Hr5c5t1yhWoGjlhmQHDbIwAMOFf9TWPlMH
         THrX3pAIw3DvQ0cmdJ1bmNcUlS/f3JYQyE0U9roxEaaLTh8UQe5MfHUJspu+1bpj+XH6
         SwCg==
X-Gm-Message-State: AGi0PuZyA0/ZUtf156U6229uK7ZjvE0sjMyw7DvYNTgGauvfsmiDjyLt
        fs33CAjDnmc2O3K5SFw8Cql/6Q==
X-Google-Smtp-Source: APiQypJwETorjq0ibgeRfrLl7+cjR9eeqNwdcpv7N6XiTQBf9hU4ZCQn0eAm0/Ey0d2tFnk8zKUzsA==
X-Received: by 2002:adf:b6a8:: with SMTP id j40mr20352188wre.255.1587395075566;
        Mon, 20 Apr 2020 08:04:35 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id x6sm1674054wrg.58.2020.04.20.08.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 08:04:33 -0700 (PDT)
Date:   Mon, 20 Apr 2020 17:04:32 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, leonro@mellanox.com, saeedm@mellanox.com,
        jiri@mellanox.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, alexr@mellanox.com
Subject: Re: [PATCH V2 mlx5-next 04/10] bonding: Implement ndo_xmit_slave_get
Message-ID: <20200420150432.GQ6581@nanopsycho.orion>
References: <20200420075426.31462-1-maorg@mellanox.com>
 <20200420075426.31462-5-maorg@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420075426.31462-5-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 20, 2020 at 09:54:20AM CEST, maorg@mellanox.com wrote:
>Add implementation of ndo_xmit_slave_get.
>When user sets the LAG_FLAGS_HASH_ALL_SLAVES bit and the xmit slave
>result is based on the hash, then the slave will be selected from the
>array of all the slaves.
>
>Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
>---
> drivers/net/bonding/bond_main.c | 123 +++++++++++++++++++++++++++-----
> include/net/bonding.h           |   1 +
> 2 files changed, 105 insertions(+), 19 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index 7e04be86fda8..320bcb1394fd 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -4137,6 +4137,40 @@ static void bond_skip_slave(struct bond_up_slave *slaves,
> 	}
> }
> 
>+static void bond_set_slave_arr(struct bonding *bond,
>+			       struct bond_up_slave *usable_slaves,
>+			       struct bond_up_slave *all_slaves)
>+{
>+	struct bond_up_slave *usable, *all;
>+
>+	usable = rtnl_dereference(bond->usable_slaves);
>+	rcu_assign_pointer(bond->usable_slaves, usable_slaves);
>+	if (usable)
>+		kfree_rcu(usable, rcu);
>+
>+	all = rtnl_dereference(bond->all_slaves);
>+	rcu_assign_pointer(bond->all_slaves, all_slaves);
>+	if (all)
>+		kfree_rcu(all, rcu);
>+}
>+
>+static void bond_reset_slave_arr(struct bonding *bond)
>+{
>+	struct bond_up_slave *usable, *all;
>+
>+	usable = rtnl_dereference(bond->usable_slaves);
>+	if (usable) {
>+		RCU_INIT_POINTER(bond->usable_slaves, NULL);
>+		kfree_rcu(usable, rcu);
>+	}
>+
>+	all = rtnl_dereference(bond->all_slaves);
>+	if (all) {
>+		RCU_INIT_POINTER(bond->all_slaves, NULL);
>+		kfree_rcu(all, rcu);
>+	}
>+}

Could you please push addition of all_slaves arr into a separate patch?


>+
> /* Build the usable slaves array in control path for modes that use xmit-hash
>  * to determine the slave interface -
>  * (a) BOND_MODE_8023AD
>@@ -4147,7 +4181,7 @@ static void bond_skip_slave(struct bond_up_slave *slaves,
>  */
> int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
> {
>-	struct bond_up_slave *usable_slaves, *old_usable_slaves;
>+	struct bond_up_slave *usable_slaves = NULL, *all_slaves = NULL;
> 	struct slave *slave;
> 	struct list_head *iter;
> 	int agg_id = 0;
>@@ -4159,7 +4193,9 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
> 
> 	usable_slaves = kzalloc(struct_size(usable_slaves, arr,
> 					    bond->slave_cnt), GFP_KERNEL);
>-	if (!usable_slaves) {
>+	all_slaves = kzalloc(struct_size(all_slaves, arr,
>+					 bond->slave_cnt), GFP_KERNEL);
>+	if (!usable_slaves || !all_slaves) {
> 		ret = -ENOMEM;
> 		goto out;
> 	}
>@@ -4168,20 +4204,19 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
> 
> 		if (bond_3ad_get_active_agg_info(bond, &ad_info)) {
> 			pr_debug("bond_3ad_get_active_agg_info failed\n");
>-			kfree_rcu(usable_slaves, rcu);
> 			/* No active aggragator means it's not safe to use
> 			 * the previous array.
> 			 */
>-			old_usable_slaves = rtnl_dereference(bond->usable_slaves);
>-			if (old_usable_slaves) {
>-				RCU_INIT_POINTER(bond->usable_slaves, NULL);
>-				kfree_rcu(old_usable_slaves, rcu);
>-			}
>+			bond_reset_slave_arr(bond);
> 			goto out;
> 		}
> 		agg_id = ad_info.aggregator_id;
> 	}
> 	bond_for_each_slave(bond, slave, iter) {
>+		if (skipslave == slave)
>+			continue;
>+
>+		all_slaves->arr[all_slaves->count++] = slave;
> 		if (BOND_MODE(bond) == BOND_MODE_8023AD) {
> 			struct aggregator *agg;
> 
>@@ -4191,8 +4226,6 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
> 		}
> 		if (!bond_slave_can_tx(slave))
> 			continue;
>-		if (skipslave == slave)
>-			continue;
> 
> 		slave_dbg(bond->dev, slave->dev, "Adding slave to tx hash array[%d]\n",
> 			  usable_slaves->count);
>@@ -4200,14 +4233,17 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
> 		usable_slaves->arr[usable_slaves->count++] = slave;
> 	}
> 
>-	old_usable_slaves = rtnl_dereference(bond->usable_slaves);
>-	rcu_assign_pointer(bond->usable_slaves, usable_slaves);
>-	if (old_usable_slaves)
>-		kfree_rcu(old_usable_slaves, rcu);
>+	bond_set_slave_arr(bond, usable_slaves, all_slaves);
>+	return ret;
> out:
>-	if (ret != 0 && skipslave)
>+	if (ret != 0 && skipslave) {
>+		bond_skip_slave(rtnl_dereference(bond->all_slaves),
>+				skipslave);
> 		bond_skip_slave(rtnl_dereference(bond->usable_slaves),
> 				skipslave);
>+	}
>+	kfree_rcu(all_slaves, rcu);
>+	kfree_rcu(usable_slaves, rcu);
> 
> 	return ret;
> }
>@@ -4313,6 +4349,48 @@ static u16 bond_select_queue(struct net_device *dev, struct sk_buff *skb,
> 	return txq;
> }
> 
>+static struct net_device *bond_xmit_get_slave(struct net_device *master_dev,
>+					      struct sk_buff *skb,
>+					      u16 flags)
>+{
>+	struct bonding *bond = netdev_priv(master_dev);
>+	struct bond_up_slave *slaves;
>+	struct slave *slave = NULL;
>+
>+	switch (BOND_MODE(bond)) {
>+	case BOND_MODE_ROUNDROBIN:
>+		slave = bond_xmit_roundrobin_slave_get(bond, skb);
>+		break;
>+	case BOND_MODE_ACTIVEBACKUP:
>+		slave = bond_xmit_activebackup_slave_get(bond, skb);
>+		break;
>+	case BOND_MODE_8023AD:
>+	case BOND_MODE_XOR:
>+		if (flags & LAG_FLAGS_HASH_ALL_SLAVES)
>+			slaves = rcu_dereference(bond->all_slaves);
>+		else
>+			slaves = rcu_dereference(bond->usable_slaves);
>+		slave = bond_xmit_3ad_xor_slave_get(bond, skb, slaves);
>+		break;
>+	case BOND_MODE_BROADCAST:
>+		break;
>+	case BOND_MODE_ALB:
>+		slave = bond_xmit_alb_slave_get(bond, skb);
>+		break;
>+	case BOND_MODE_TLB:
>+		slave = bond_xmit_tlb_slave_get(bond, skb);
>+		break;
>+	default:
>+		/* Should never happen, mode already checked */
>+		WARN_ONCE(true, "Unknown bonding mode");

Return NULL here right away. No need to have the slave init to NULL at
the beginning.


>+		break;
>+	}
>+
>+	if (slave)
>+		return slave->dev;
>+	return NULL;
>+}
>+
> static netdev_tx_t __bond_start_xmit(struct sk_buff *skb, struct net_device *dev)
> {
> 	struct bonding *bond = netdev_priv(dev);
>@@ -4434,6 +4512,7 @@ static const struct net_device_ops bond_netdev_ops = {
> 	.ndo_del_slave		= bond_release,
> 	.ndo_fix_features	= bond_fix_features,
> 	.ndo_features_check	= passthru_features_check,
>+	.ndo_xmit_get_slave	= bond_xmit_get_slave,
> };
> 
> static const struct device_type bond_type = {
>@@ -4501,9 +4580,9 @@ void bond_setup(struct net_device *bond_dev)
> static void bond_uninit(struct net_device *bond_dev)
> {
> 	struct bonding *bond = netdev_priv(bond_dev);
>+	struct bond_up_slave *usable, *all;
> 	struct list_head *iter;
> 	struct slave *slave;
>-	struct bond_up_slave *arr;
> 
> 	bond_netpoll_cleanup(bond_dev);
> 
>@@ -4512,10 +4591,16 @@ static void bond_uninit(struct net_device *bond_dev)
> 		__bond_release_one(bond_dev, slave->dev, true, true);
> 	netdev_info(bond_dev, "Released all slaves\n");
> 
>-	arr = rtnl_dereference(bond->usable_slaves);
>-	if (arr) {
>+	usable = rtnl_dereference(bond->usable_slaves);
>+	if (usable) {
> 		RCU_INIT_POINTER(bond->usable_slaves, NULL);
>-		kfree_rcu(arr, rcu);
>+		kfree_rcu(usable, rcu);
>+	}
>+
>+	all = rtnl_dereference(bond->all_slaves);
>+	if (all) {
>+		RCU_INIT_POINTER(bond->all_slaves, NULL);
>+		kfree_rcu(all, rcu);
> 	}
> 
> 	list_del(&bond->bond_list);
>diff --git a/include/net/bonding.h b/include/net/bonding.h
>index 33bdb6d5182d..a2a7f461fa63 100644
>--- a/include/net/bonding.h
>+++ b/include/net/bonding.h
>@@ -201,6 +201,7 @@ struct bonding {
> 	struct   slave __rcu *current_arp_slave;
> 	struct   slave __rcu *primary_slave;
> 	struct   bond_up_slave __rcu *usable_slaves; /* Array of usable slaves */
>+	struct   bond_up_slave __rcu *all_slaves; /* Array of all slaves */
> 	bool     force_primary;
> 	s32      slave_cnt; /* never change this value outside the attach/detach wrappers */
> 	int     (*recv_probe)(const struct sk_buff *, struct bonding *,
>-- 
>2.17.2
>
