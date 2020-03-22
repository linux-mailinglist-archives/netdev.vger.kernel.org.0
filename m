Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E198D18EBA4
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 19:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgCVSu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 14:50:26 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54005 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726816AbgCVSuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 14:50:23 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 155EC5C018A;
        Sun, 22 Mar 2020 14:50:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 22 Mar 2020 14:50:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=dHEPcc01oQJnt4NsTA+REvUxuKYTuSCMdprnGIX4gdM=; b=JOqv2wNE
        hHH2dPjyCPMXh7eRMhEy8K5/NPb1u8dd4tMsnPZQ8sBraUSqMTs8ug5GYVClOFRU
        oU3VJgcabaHRa25Vhb3TKmJBqMbThToTTHKhY2H9kTn5CpyLzD+oVP68ji9QoEeT
        TmqABBlwPzG1xLBeiIEj+AmQ8XwHSmfCJa/BsUOURA87K5PwOFkpvLALT09o9OvM
        l7AyHUOojmJoVonvm6EeT3Nw9D/uJYbDNmpZX8kpxuvbOBykGInhinekPLv6JzIa
        ma4rese4p4nY3FV1bja7BLn5sUInYAUsTpcWGPY0NwtV/rJsYLhq6NgZOSbidqFC
        SJoMu7X8GClOoA==
X-ME-Sender: <xms:brN3Xsarc6ynHR4h5u0BmDJ1bUdnln_AU4ksVv2B0cy8T--sHCrpHg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudegiedguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedtrdelgedrvddvheenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:brN3Xk6365dCNZudVzC79hR-bCPm-T2c31HHUynPB12hZgWppogpiQ>
    <xmx:brN3XjA2aiAgOluMXx88_xkSDXUPzJEFB-aeVhul66ZahOnlrZ_qeQ>
    <xmx:brN3Xj4amWwFaKLItGSK5oZfz9cSazue6scn_iRTGlY6aetKzniIZg>
    <xmx:b7N3XlleAdBvLTLhAGehqj54-CReEt8G4M6pOzRjh1iTWGlxWKUSIQ>
Received: from splinter.mtl.com (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8BC84328005A;
        Sun, 22 Mar 2020 14:50:21 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/5] netdevsim: Explicitly register packet trap groups
Date:   Sun, 22 Mar 2020 20:48:28 +0200
Message-Id: <20200322184830.1254104-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200322184830.1254104-1-idosch@idosch.org>
References: <20200322184830.1254104-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Use the previously added API to explicitly register / unregister
supported packet trap groups. This is in preparation for future patches
that will enable drivers to pass additional group attributes, such as
associated policer identifier.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/dev.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index f81c47377f32..edeb61ddc8bc 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -397,6 +397,13 @@ enum {
 			    DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
 			    NSIM_TRAP_METADATA)
 
+static const struct devlink_trap_group nsim_trap_groups_arr[] = {
+	DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS),
+	DEVLINK_TRAP_GROUP_GENERIC(L3_DROPS),
+	DEVLINK_TRAP_GROUP_GENERIC(BUFFER_DROPS),
+	DEVLINK_TRAP_GROUP_GENERIC(ACL_DROPS),
+};
+
 static const struct devlink_trap nsim_traps_arr[] = {
 	NSIM_TRAP_DROP(SMAC_MC, L2_DROPS),
 	NSIM_TRAP_DROP(VLAN_TAG_MISMATCH, L2_DROPS),
@@ -556,10 +563,15 @@ static int nsim_dev_traps_init(struct devlink *devlink)
 	nsim_trap_data->nsim_dev = nsim_dev;
 	nsim_dev->trap_data = nsim_trap_data;
 
+	err = devlink_trap_groups_register(devlink, nsim_trap_groups_arr,
+					   ARRAY_SIZE(nsim_trap_groups_arr));
+	if (err)
+		goto err_trap_items_free;
+
 	err = devlink_traps_register(devlink, nsim_traps_arr,
 				     ARRAY_SIZE(nsim_traps_arr), NULL);
 	if (err)
-		goto err_trap_items_free;
+		goto err_trap_groups_unregister;
 
 	INIT_DELAYED_WORK(&nsim_dev->trap_data->trap_report_dw,
 			  nsim_dev_trap_report_work);
@@ -568,6 +580,9 @@ static int nsim_dev_traps_init(struct devlink *devlink)
 
 	return 0;
 
+err_trap_groups_unregister:
+	devlink_trap_groups_unregister(devlink, nsim_trap_groups_arr,
+				       ARRAY_SIZE(nsim_trap_groups_arr));
 err_trap_items_free:
 	kfree(nsim_trap_data->trap_items_arr);
 err_trap_data_free:
@@ -582,6 +597,8 @@ static void nsim_dev_traps_exit(struct devlink *devlink)
 	cancel_delayed_work_sync(&nsim_dev->trap_data->trap_report_dw);
 	devlink_traps_unregister(devlink, nsim_traps_arr,
 				 ARRAY_SIZE(nsim_traps_arr));
+	devlink_trap_groups_unregister(devlink, nsim_trap_groups_arr,
+				       ARRAY_SIZE(nsim_trap_groups_arr));
 	kfree(nsim_dev->trap_data->trap_items_arr);
 	kfree(nsim_dev->trap_data);
 }
-- 
2.24.1

