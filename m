Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC132A653C
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730148AbgKDNcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:32:07 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53201 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730137AbgKDNcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:32:04 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4D3435C00F9;
        Wed,  4 Nov 2020 08:32:02 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 04 Nov 2020 08:32:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=4p5Zw9uujShRazFP9tEUDAge3lSsVWIMpMmolIEIaWc=; b=NG5O/vQq
        x7AyZoYiOPNEShyUOB7CJQgCda/cymCYzx1gMjoiERRa2ZZmW51GN5rHZQmUEwlZ
        +6vBQP3qNUVYjqNOZDOGGhuEg10pAgDg8gxXCekFt1zPqKS9FWxNrt8H0zlaX/dj
        n1/Q3T28g1INWditKgLtPkcgrexS298DMukRAw0cbZHCuT5Nl2/aF/RaerCF7Koq
        J0nfzSXGLIxdwGy0jX2PXk/K42OhRhWxe4XEc+cK8E8Z/ezpGThXfX14g7HAdJuh
        SubXMd4gSPaWDDgzwK9H9fd4abtBI66mNtGQ9PXrtVrJ73TXx2bSHP8aH4FPyWNN
        iGwoHXN4IK2HCQ==
X-ME-Sender: <xms:Uq2iXx9U9sdWHi-nzdNoZjlTdQcM_KwG4WpDPXAp52GPWwdlJNT7Ug>
    <xme:Uq2iX1vH_ym34MXIdVPa3I1dCIYg-B9uxA5b9tPqw5O4tqtYMtmBhP5uKM-xoA1R2
    I_ksC1Kp9arTFg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddthedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrvdeh
    heenucevlhhushhtvghrufhiiigvpedugeenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Uq2iX_D7R1hh4whQkvd341Gi3E3FieqcHDebU2tZC5KPtL1LrQkG3w>
    <xmx:Uq2iX1dRI-nlI7xgc-RPewfJu6s-XB8LDyIMrbprRdqcit4PoCnKiA>
    <xmx:Uq2iX2OQlamVP_ONnouE3hM6lfCGIy_HmXMO3nYSgzP7J6qAeoBVTw>
    <xmx:Uq2iXzqkO1ZIVTghc_fYGzTAfJtFHckKFhoUhNe55ZZfiBgkMCFlnA>
Received: from shredder.mtl.com (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id D29373064610;
        Wed,  4 Nov 2020 08:32:00 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 15/18] netdevsim: Add devlink resource for nexthops
Date:   Wed,  4 Nov 2020 15:30:37 +0200
Message-Id: <20201104133040.1125369-16-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201104133040.1125369-1-idosch@idosch.org>
References: <20201104133040.1125369-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The Spectrum ASIC has a dedicated table where nexthops (i.e., adjacency
entries) are populated. The size of this table can be controlled via
devlink-resource.

Add such a resource to netdevsim so that its occupancy will reflect the
number of nexthop objects currently programmed to the device.

By limiting the size of the resource, error paths could be exercised and
tested.

Example output:

# devlink resource show netdevsim/netdevsim10
netdevsim/netdevsim10:
  name IPv4 size unlimited unit entry size_min 0 size_max unlimited size_gran 1 dpipe_tables none
    resources:
      name fib size unlimited occ 4 unit entry size_min 0 size_max unlimited size_gran 1 dpipe_tables none
      name fib-rules size unlimited occ 3 unit entry size_min 0 size_max unlimited size_gran 1 dpipe_tables none
  name IPv6 size unlimited unit entry size_min 0 size_max unlimited size_gran 1 dpipe_tables none
    resources:
      name fib size unlimited occ 1 unit entry size_min 0 size_max unlimited size_gran 1 dpipe_tables none
      name fib-rules size unlimited occ 2 unit entry size_min 0 size_max unlimited size_gran 1 dpipe_tables none
  name nexthops size unlimited occ 0 unit entry size_min 0 size_max unlimited size_gran 1 dpipe_tables none

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../networking/devlink/netdevsim.rst          |  3 ++-
 drivers/net/netdevsim/dev.c                   |  6 +++++
 drivers/net/netdevsim/fib.c                   | 23 ++++++++++++++++++-
 drivers/net/netdevsim/netdevsim.h             |  1 +
 4 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/devlink/netdevsim.rst b/Documentation/networking/devlink/netdevsim.rst
index 2a266b7e7b38..02c2d20dc673 100644
--- a/Documentation/networking/devlink/netdevsim.rst
+++ b/Documentation/networking/devlink/netdevsim.rst
@@ -46,7 +46,7 @@ Resources
 =========
 
 The ``netdevsim`` driver exposes resources to control the number of FIB
-entries and FIB rule entries that the driver will allow.
+entries, FIB rule entries and nexthops that the driver will allow.
 
 .. code:: shell
 
@@ -54,6 +54,7 @@ entries and FIB rule entries that the driver will allow.
     $ devlink resource set netdevsim/netdevsim0 path /IPv4/fib-rules size 16
     $ devlink resource set netdevsim/netdevsim0 path /IPv6/fib size 64
     $ devlink resource set netdevsim/netdevsim0 path /IPv6/fib-rules size 16
+    $ devlink resource set netdevsim/netdevsim0 path /nexthops size 16
     $ devlink dev reload netdevsim/netdevsim0
 
 Driver-specific Traps
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index d07061417675..49cc1fea9e02 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -324,6 +324,12 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 		return err;
 	}
 
+	/* Resources for nexthops */
+	err = devlink_resource_register(devlink, "nexthops", (u64)-1,
+					NSIM_RESOURCE_NEXTHOPS,
+					DEVLINK_RESOURCE_ID_PARENT_TOP,
+					&params);
+
 out:
 	return err;
 }
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index deea17a0e79c..3ec0f8896efe 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -42,6 +42,7 @@ struct nsim_fib_data {
 	struct notifier_block fib_nb;
 	struct nsim_per_fib_data ipv4;
 	struct nsim_per_fib_data ipv6;
+	struct nsim_fib_entry nexthops;
 	struct rhashtable fib_rt_ht;
 	struct list_head fib_rt_list;
 	spinlock_t fib_lock;	/* Protects hashtable, list and accounting */
@@ -104,6 +105,9 @@ u64 nsim_fib_get_val(struct nsim_fib_data *fib_data,
 	case NSIM_RESOURCE_IPV6_FIB_RULES:
 		entry = &fib_data->ipv6.rules;
 		break;
+	case NSIM_RESOURCE_NEXTHOPS:
+		entry = &fib_data->nexthops;
+		break;
 	default:
 		return 0;
 	}
@@ -129,6 +133,9 @@ static void nsim_fib_set_max(struct nsim_fib_data *fib_data,
 	case NSIM_RESOURCE_IPV6_FIB_RULES:
 		entry = &fib_data->ipv6.rules;
 		break;
+	case NSIM_RESOURCE_NEXTHOPS:
+		entry = &fib_data->nexthops;
+		break;
 	default:
 		WARN_ON(1);
 		return;
@@ -866,12 +873,20 @@ static u64 nsim_fib_ipv6_rules_res_occ_get(void *priv)
 	return nsim_fib_get_val(data, NSIM_RESOURCE_IPV6_FIB_RULES, false);
 }
 
+static u64 nsim_fib_nexthops_res_occ_get(void *priv)
+{
+	struct nsim_fib_data *data = priv;
+
+	return nsim_fib_get_val(data, NSIM_RESOURCE_NEXTHOPS, false);
+}
+
 static void nsim_fib_set_max_all(struct nsim_fib_data *data,
 				 struct devlink *devlink)
 {
 	enum nsim_resource_id res_ids[] = {
 		NSIM_RESOURCE_IPV4_FIB, NSIM_RESOURCE_IPV4_FIB_RULES,
-		NSIM_RESOURCE_IPV6_FIB, NSIM_RESOURCE_IPV6_FIB_RULES
+		NSIM_RESOURCE_IPV6_FIB, NSIM_RESOURCE_IPV6_FIB_RULES,
+		NSIM_RESOURCE_NEXTHOPS,
 	};
 	int i;
 
@@ -929,6 +944,10 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 					  NSIM_RESOURCE_IPV6_FIB_RULES,
 					  nsim_fib_ipv6_rules_res_occ_get,
 					  data);
+	devlink_resource_occ_get_register(devlink,
+					  NSIM_RESOURCE_NEXTHOPS,
+					  nsim_fib_nexthops_res_occ_get,
+					  data);
 	return data;
 
 err_rhashtable_destroy:
@@ -941,6 +960,8 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 
 void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *data)
 {
+	devlink_resource_occ_get_unregister(devlink,
+					    NSIM_RESOURCE_NEXTHOPS);
 	devlink_resource_occ_get_unregister(devlink,
 					    NSIM_RESOURCE_IPV6_FIB_RULES);
 	devlink_resource_occ_get_unregister(devlink,
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 827fc80f50a0..698be048041b 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -158,6 +158,7 @@ enum nsim_resource_id {
 	NSIM_RESOURCE_IPV6,
 	NSIM_RESOURCE_IPV6_FIB,
 	NSIM_RESOURCE_IPV6_FIB_RULES,
+	NSIM_RESOURCE_NEXTHOPS,
 };
 
 struct nsim_dev_health {
-- 
2.26.2

