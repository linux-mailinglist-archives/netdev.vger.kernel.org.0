Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E562A1B0E50
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 16:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbgDTO1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 10:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729468AbgDTO13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 10:27:29 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BB5C061A0F
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 07:27:29 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x18so12464041wrq.2
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 07:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4eXKfVHyEMIaLYkf30EVGphjO5NPNXcxwM33LODIjFo=;
        b=ADccIzNC/dbBCPt3VQnYZSrFGByTc5RdlZu+Rh5jffjt0lhIsIUCUv/V1aRDU1Qk0t
         yFwtN1d2lLS/fc5Nnv9LykLUVEKQqSVR1UchHsQzhqVIvxF49GWdod363J31ygCHtgkH
         i+fvNtEVrA6rEeS+Ubcv1x2MAUWtUe29T8EqdrMtzMrOLewR25DB8uYvuAQMitgCdjGO
         40PbqSe9jPmyk99dyUE0SMwu0VLKOMMZ1TeRqyd+I2WU0TsuIC2hze0p3/cacvlGqaPw
         3sHIzc7KqFMaPtMr2+dfCBhQBtc7Xp98q5FvYXqwWqGILvu/gfPngQav2ZetD7Dj0Q54
         zmMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4eXKfVHyEMIaLYkf30EVGphjO5NPNXcxwM33LODIjFo=;
        b=pKUnY5hMIb1s/JiAjswpc/3ToHtWSc6jQ5olOrZs0Xau6Kzw89I8t6lPhz59sZJ1EF
         vsDksfJ9CPkJlAVrSY7eF3qeGmxFzZ1YjKoGFa3i0KqiIe4U8B2dMR+2j2mgMTyOzS9b
         mdaviVE96B0E3P7O5MEOf210+fyKMTxJHJ2npx4H5DMBBAUPy4XRXP4v2+DitN22LT9c
         8p86zh/KVsmrdFJT8kZgeA2oQK933LxFo3zQQu9wBxz05YxjIOqBciVgqaSEGousnBdb
         clGOcOp/REuBSmzlUEKTdz7KPmEep7c1b7ya4UIVryhioa4GdEiUjskOkwWJlINJng4/
         ND5g==
X-Gm-Message-State: AGi0PuakrhhoSQYxDvZWEwFaRH0htCpCi9apvBe8x5j3R/xnc+Vw6pVl
        x6XFEtr2hvgE/tAOMzTj3QYE0Q==
X-Google-Smtp-Source: APiQypKDsJPcZOA7NmqdaA2t6s+b7BCwJrCFCVKihvvQGZHTeUC87vX/jxW0Myxt+wVWtPwyHvopCg==
X-Received: by 2002:a5d:65d2:: with SMTP id e18mr19500849wrw.104.1587392848170;
        Mon, 20 Apr 2020 07:27:28 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z1sm1581564wmf.15.2020.04.20.07.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 07:27:27 -0700 (PDT)
Date:   Mon, 20 Apr 2020 16:27:26 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, leonro@mellanox.com, saeedm@mellanox.com,
        jiri@mellanox.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, alexr@mellanox.com
Subject: Re: [PATCH V2 mlx5-next 03/10] bonding: Add helpers to get xmit slave
Message-ID: <20200420142726.GM6581@nanopsycho.orion>
References: <20200420075426.31462-1-maorg@mellanox.com>
 <20200420075426.31462-4-maorg@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420075426.31462-4-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 20, 2020 at 09:54:19AM CEST, maorg@mellanox.com wrote:
>This helpers will be used by both the xmit function
>and the get xmit slave ndo.

Be more verbose about what you are doing please. From this I have no
clue what is going on.


>
>Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
>---
> drivers/net/bonding/bond_alb.c  | 35 ++++++++----
> drivers/net/bonding/bond_main.c | 94 +++++++++++++++++++++------------
> include/net/bond_alb.h          |  4 ++
> 3 files changed, 89 insertions(+), 44 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
>index 7bb49b049dcc..e863c694c309 100644
>--- a/drivers/net/bonding/bond_alb.c
>+++ b/drivers/net/bonding/bond_alb.c
>@@ -1334,11 +1334,11 @@ static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
> 	return NETDEV_TX_OK;
> }
> 
>-netdev_tx_t bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
>+struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
>+				      struct sk_buff *skb)
> {
>-	struct bonding *bond = netdev_priv(bond_dev);
>-	struct ethhdr *eth_data;
> 	struct slave *tx_slave = NULL;
>+	struct ethhdr *eth_data;
> 	u32 hash_index;
> 
> 	skb_reset_mac_header(skb);
>@@ -1369,20 +1369,29 @@ netdev_tx_t bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
> 			break;
> 		}
> 	}
>-	return bond_do_alb_xmit(skb, bond, tx_slave);
>+	return tx_slave;
> }
> 
>-netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
>+netdev_tx_t bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
> {
> 	struct bonding *bond = netdev_priv(bond_dev);
>-	struct ethhdr *eth_data;
>+	struct slave *tx_slave;
>+
>+	tx_slave = bond_xmit_tlb_slave_get(bond, skb);
>+	return bond_do_alb_xmit(skb, bond, tx_slave);
>+}
>+
>+struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
>+				      struct sk_buff *skb)
>+{
> 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
>-	struct slave *tx_slave = NULL;
> 	static const __be32 ip_bcast = htonl(0xffffffff);
>-	int hash_size = 0;
>+	struct slave *tx_slave = NULL;
>+	const u8 *hash_start = NULL;
> 	bool do_tx_balance = true;
>+	struct ethhdr *eth_data;
> 	u32 hash_index = 0;
>-	const u8 *hash_start = NULL;
>+	int hash_size = 0;
> 
> 	skb_reset_mac_header(skb);
> 	eth_data = eth_hdr(skb);
>@@ -1501,7 +1510,15 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
> 						       count];
> 		}
> 	}
>+	return tx_slave;
>+}
>+
>+netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
>+{
>+	struct bonding *bond = netdev_priv(bond_dev);
>+	struct slave *tx_slave = NULL;
> 
>+	tx_slave = bond_xmit_alb_slave_get(bond, skb);
> 	return bond_do_alb_xmit(skb, bond, tx_slave);
> }
> 
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index 2cb41d480ae2..7e04be86fda8 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -82,6 +82,7 @@
> #include <net/bonding.h>
> #include <net/bond_3ad.h>
> #include <net/bond_alb.h>
>+#include <net/lag.h>
> 
> #include "bonding_priv.h"
> 
>@@ -3406,10 +3407,26 @@ u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb)
> 		(__force u32)flow_get_u32_src(&flow);
> 	hash ^= (hash >> 16);
> 	hash ^= (hash >> 8);
>-

Please avoid changes like this one.


> 	return hash >> 1;
> }
> 
>+static struct slave *bond_xmit_3ad_xor_slave_get(struct bonding *bond,
>+						 struct sk_buff *skb,
>+						 struct bond_up_slave *slaves)
>+{
>+	struct slave *slave;
>+	unsigned int count;
>+	u32 hash;
>+
>+	hash = bond_xmit_hash(bond, skb);
>+	count = slaves ? READ_ONCE(slaves->count) : 0;
>+	if (unlikely(!count))
>+		return NULL;
>+
>+	slave = slaves->arr[hash % count];
>+	return slave;
>+}

Why don't you have this helper near bond_3ad_xor_xmit() as you have for
round robin for example?

I think it would make this patch much easier to review if you split to
multiple patches, per-mode.


>+
> /*-------------------------- Device entry points ----------------------------*/
> 
> void bond_work_init_all(struct bonding *bond)
>@@ -3923,16 +3940,15 @@ static int bond_set_mac_address(struct net_device *bond_dev, void *addr)
> }
> 
> /**
>- * bond_xmit_slave_id - transmit skb through slave with slave_id
>+ * bond_get_slave_by_id - get xmit slave with slave_id
>  * @bond: bonding device that is transmitting
>- * @skb: buffer to transmit
>  * @slave_id: slave id up to slave_cnt-1 through which to transmit
>  *
>- * This function tries to transmit through slave with slave_id but in case
>+ * This function tries to get slave with slave_id but in case
>  * it fails, it tries to find the first available slave for transmission.
>- * The skb is consumed in all cases, thus the function is void.
>  */
>-static void bond_xmit_slave_id(struct bonding *bond, struct sk_buff *skb, int slave_id)
>+static struct slave *bond_get_slave_by_id(struct bonding *bond,
>+					  int slave_id)
> {
> 	struct list_head *iter;
> 	struct slave *slave;
>@@ -3941,10 +3957,8 @@ static void bond_xmit_slave_id(struct bonding *bond, struct sk_buff *skb, int sl
> 	/* Here we start from the slave with slave_id */
> 	bond_for_each_slave_rcu(bond, slave, iter) {
> 		if (--i < 0) {
>-			if (bond_slave_can_tx(slave)) {
>-				bond_dev_queue_xmit(bond, skb, slave->dev);
>-				return;
>-			}
>+			if (bond_slave_can_tx(slave))
>+				return slave;
> 		}
> 	}
> 
>@@ -3953,13 +3967,11 @@ static void bond_xmit_slave_id(struct bonding *bond, struct sk_buff *skb, int sl
> 	bond_for_each_slave_rcu(bond, slave, iter) {
> 		if (--i < 0)
> 			break;
>-		if (bond_slave_can_tx(slave)) {
>-			bond_dev_queue_xmit(bond, skb, slave->dev);
>-			return;
>-		}
>+		if (bond_slave_can_tx(slave))
>+			return slave;
> 	}
>-	/* no slave that can tx has been found */
>-	bond_tx_drop(bond->dev, skb);
>+
>+	return NULL;
> }
> 
> /**
>@@ -3995,10 +4007,9 @@ static u32 bond_rr_gen_slave_id(struct bonding *bond)
> 	return slave_id;
> }
> 
>-static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
>-					struct net_device *bond_dev)
>+static struct slave *bond_xmit_roundrobin_slave_get(struct bonding *bond,
>+						    struct sk_buff *skb)
> {
>-	struct bonding *bond = netdev_priv(bond_dev);
> 	struct slave *slave;
> 	int slave_cnt;
> 	u32 slave_id;
>@@ -4020,24 +4031,40 @@ static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
> 		if (iph->protocol == IPPROTO_IGMP) {
> 			slave = rcu_dereference(bond->curr_active_slave);
> 			if (slave)
>-				bond_dev_queue_xmit(bond, skb, slave->dev);
>-			else
>-				bond_xmit_slave_id(bond, skb, 0);
>-			return NETDEV_TX_OK;
>+				return slave;
>+			return bond_get_slave_by_id(bond, 0);
> 		}
> 	}
> 
> non_igmp:
> 	slave_cnt = READ_ONCE(bond->slave_cnt);
> 	if (likely(slave_cnt)) {
>-		slave_id = bond_rr_gen_slave_id(bond);
>-		bond_xmit_slave_id(bond, skb, slave_id % slave_cnt);
>-	} else {
>-		bond_tx_drop(bond_dev, skb);
>+		slave_id = bond_rr_gen_slave_id(bond) % slave_cnt;
>+		return bond_get_slave_by_id(bond, slave_id);
> 	}
>+	return NULL;
>+}
>+
>+static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
>+					struct net_device *bond_dev)
>+{
>+	struct bonding *bond = netdev_priv(bond_dev);
>+	struct slave *slave;
>+
>+	slave = bond_xmit_roundrobin_slave_get(bond, skb);
>+	if (slave)
>+		bond_dev_queue_xmit(bond, skb, slave->dev);
>+	else
>+		bond_tx_drop(bond_dev, skb);
> 	return NETDEV_TX_OK;
> }
> 
>+static struct slave *bond_xmit_activebackup_slave_get(struct bonding *bond,
>+						      struct sk_buff *skb)
>+{
>+	return rcu_dereference(bond->curr_active_slave);
>+}
>+
> /* In active-backup mode, we know that bond->curr_active_slave is always valid if
>  * the bond has a usable interface.
>  */
>@@ -4047,7 +4074,7 @@ static netdev_tx_t bond_xmit_activebackup(struct sk_buff *skb,
> 	struct bonding *bond = netdev_priv(bond_dev);
> 	struct slave *slave;
> 
>-	slave = rcu_dereference(bond->curr_active_slave);
>+	slave = bond_xmit_activebackup_slave_get(bond, skb);
> 	if (slave)
> 		bond_dev_queue_xmit(bond, skb, slave->dev);
> 	else
>@@ -4193,18 +4220,15 @@ static netdev_tx_t bond_3ad_xor_xmit(struct sk_buff *skb,
> 				     struct net_device *dev)
> {
> 	struct bonding *bond = netdev_priv(dev);
>-	struct slave *slave;
> 	struct bond_up_slave *slaves;
>-	unsigned int count;
>+	struct slave *slave;
> 
> 	slaves = rcu_dereference(bond->usable_slaves);
>-	count = slaves ? READ_ONCE(slaves->count) : 0;
>-	if (likely(count)) {
>-		slave = slaves->arr[bond_xmit_hash(bond, skb) % count];
>+	slave = bond_xmit_3ad_xor_slave_get(bond, skb, slaves);
>+	if (likely(slave))
> 		bond_dev_queue_xmit(bond, skb, slave->dev);
>-	} else {
>+	else
> 		bond_tx_drop(dev, skb);
>-	}
> 
> 	return NETDEV_TX_OK;
> }
>diff --git a/include/net/bond_alb.h b/include/net/bond_alb.h
>index b3504fcd773d..f6af76c87a6c 100644
>--- a/include/net/bond_alb.h
>+++ b/include/net/bond_alb.h
>@@ -158,6 +158,10 @@ void bond_alb_handle_link_change(struct bonding *bond, struct slave *slave, char
> void bond_alb_handle_active_change(struct bonding *bond, struct slave *new_slave);
> int bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
> int bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
>+struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
>+				      struct sk_buff *skb);
>+struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
>+				      struct sk_buff *skb);
> void bond_alb_monitor(struct work_struct *);
> int bond_alb_set_mac_address(struct net_device *bond_dev, void *addr);
> void bond_alb_clear_vlan(struct bonding *bond, unsigned short vlan_id);
>-- 
>2.17.2
>
