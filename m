Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23DF96D4E12
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 18:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbjDCQhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 12:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbjDCQg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 12:36:59 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1282686
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 09:36:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L41iftJ1KgieBeE+4jtTBtB/0Z+W9REHlRj9ufTyyjpGlfXvEQq+CaFzuBJBSRkAa+RRpa+h3CETiJZP7PfbkeuwEGFPOYosHXRosRsGbAXOIx+PBHe7c165QIXysG4WC9zOC7wioMVtHp/nDFRyUU94rH9HLkMN65QHpg//WoZJEYb+KVsizCKLQQgbFxjilehXg5V+fpsPU2rf8LrK6jRV42iuqdQneecfKhGEGIVRiwVVPrG66abepySEVn+cCVV/8z2XiQYNzWrgYytV2w73jCTQH20v9crYhwPhs/0JnCf3g2mBmUnP1/wv4s1MqfDeqg/anjHPenubVZ4vyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tDQQWs4sekP5LF7zojHCGec7k/ZayGI6qQOhVRM2yx0=;
 b=djfKG3VsEMm3yylewOYGASlqE8sc1z5fmWD1pnN5egFTmWPtTyiMvNOuqnD96ajPyF4fyDH4lXoSKqDC2M6HCkcPKMQhzkIOY+f5uWbKaeYEdVy5qPYNj86Oz4s/1B7Ddo1AS3xRgESjhdCDltf/iSG69Ax+qGH9a+o+ROpPRoeoWWrPlpZE/qlLvQY8hEZ+BLVWnR/Gdbrw4YVgceIT3nUxsIH+xI69cVk4I0hmj3IaiQponmENYJD9/scwxVtDFYVB7gKo5PsPTSe4p9XnnvAWe/dHkYou0dVX94XRIarrJbYg3xGQboDhDpnAVkA6VkvYYbayrjxPilEWF6fGJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDQQWs4sekP5LF7zojHCGec7k/ZayGI6qQOhVRM2yx0=;
 b=SucfrCZ+OQ8ntyPN0XutQy4Xxf3ykMOXYgg+hzU99qraBxJpbT3/YJ1T8WLqayY1JKuz/Oe1h7hN8aSc3lLDWf36dPuKDh+FfwiBItJjLai+/hWtQKpsNEnU8LR7Edhk0Ugl6ei0YrIxWHRWTTEWpQhJicX0K4QloDo8kL6DZYg=
Received: from MW4PR04CA0130.namprd04.prod.outlook.com (2603:10b6:303:84::15)
 by CY8PR12MB8196.namprd12.prod.outlook.com (2603:10b6:930:78::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 16:36:55 +0000
Received: from CO1NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::2a) by MW4PR04CA0130.outlook.office365.com
 (2603:10b6:303:84::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Mon, 3 Apr 2023 16:36:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT077.mail.protection.outlook.com (10.13.175.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.38 via Frontend Transport; Mon, 3 Apr 2023 16:36:54 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 3 Apr
 2023 11:36:53 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 3 Apr
 2023 09:36:53 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 3 Apr 2023 11:36:52 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: [RFC PATCH net-next 4/6] net: ethtool: pass ctx_priv and create into .set_rxfh_context
Date:   Mon, 3 Apr 2023 17:33:01 +0100
Message-ID: <2b0bb0b96c09cc79d39ef79ce6733fc0244c5548.1680538846.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1680538846.git.ecree.xilinx@gmail.com>
References: <cover.1680538846.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT077:EE_|CY8PR12MB8196:EE_
X-MS-Office365-Filtering-Correlation-Id: 448c2412-2f22-4f43-b67d-08db3461a297
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0azhxRJ2u7up40+Ie+Vq64ke96s6naGE9BvMSsI3+LKRll+sV5+If5St+MVPq2At4kCB0LRT95Qm735NZJnOVuwIK9qHXvvFeXV1K5FBiGezHp6spe6Nc3UGUG+zmdneARqINXnxUkuynDI6J6GG9e3DLWUkKM2NCMnEDxELP+VUHrXufa3GOXEK+2bt3aZ194L02rTvBWm2I4CMolyHzLIuBS5sl0AvCusg+hdBuaJ8Sr20A9N0bCAqEakzs7tiX6/Go1TP8iQO5cIVySiwvZx+os7usDDFQQ/DDoh+tyWzipFgw779BlzBOwyQjr/QwgtSCA2LPXfruGeup554DoeVDflC49+Bj0tJ5fpvumBEFe28AUdCg/CHL1p7z9c2cnU/TaSbKEBOPwRj28d93a1g7qxp4J0pLAvcLyuVyQpY8jLOR5nJvEyVzr1Sux/f234xZwdqsv0W2YvpYKBT0Zyv7wn3kjF+4VnvNej6r38PiZJ7vYPz9G/kFoRoEeQT/m6rZPPSoB8O0RhyQekAbKpqU2A0PSNQVVfBq7+ikKUHJDQLytRJAjXhS4JtuKbYfBhgCX/rQ0LxuriqGBmreR7X7qbkUEuIO2PIdfjw/BgrXqMEFlSXBO/6xGz51I8nRUDBGmbZK+4KSicu6hJlLxhYCBSCJpFvbNMtP5gbjK/qeQNzykZZLuQRPAir+0RdDs7R9bUb3jnh52ZB8TBEWasIIrzJY/LkJl0JxJRHz4kkImaRqfLqxlohRUVjUgYd
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(39860400002)(376002)(451199021)(36840700001)(46966006)(40470700004)(40480700001)(40460700003)(8676002)(36860700001)(4326008)(70206006)(70586007)(478600001)(316002)(110136005)(8936002)(54906003)(41300700001)(356005)(81166007)(82740400003)(5660300002)(426003)(186003)(47076005)(83380400001)(336012)(26005)(6666004)(9686003)(86362001)(55446002)(36756003)(2906002)(2876002)(82310400005)(142923001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 16:36:54.5662
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 448c2412-2f22-4f43-b67d-08db3461a297
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8196
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Allows drivers to easily use the private data area in the ctx to store
 their hardware-specific state.
The create flag is needed to inform them that in this case ctx_priv
 has not already been populated.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 include/linux/ethtool.h | 12 ++++++++----
 net/core/dev.c          |  5 +++--
 net/ethtool/ioctl.c     |  6 ++++--
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 0c7df2e043b2..141b020a8855 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -750,11 +750,13 @@ struct ethtool_mm_stats {
  *	the contents of the RX flow hash indirection table, hash key, and/or
  *	hash function associated to the given context. Arguments which are set
  *	to %NULL or zero will remain unchanged.
+ *	The &struct ethtool_rxfh_context for this context is passed in @ctx;
+ *	note that it will still contain the *old* settings.  The driver does
+ *	not need to update these; the core will do so if this op succeeds.
  *	Returns a negative error code or zero. An error code must be returned
  *	if at least one unsupported change was requested.
  * @set_rxfh_context_old: Legacy version of @set_rxfh_context, where driver
  *	chooses the new context ID in the %ETH_RXFH_CONTEXT_ALLOC case.
- *	Arguments and return otherwise the same.
  * @get_channels: Get number of channels.
  * @set_channels: Set number of channels.  Returns a negative error code or
  *	zero.
@@ -902,9 +904,11 @@ struct ethtool_ops {
 	u16	(*get_rxfh_priv_size)(struct net_device *);
 	int	(*get_rxfh_context)(struct net_device *, u32 *indir, u8 *key,
 				    u8 *hfunc, u32 rss_context);
-	int	(*set_rxfh_context)(struct net_device *, const u32 *indir,
-				    const u8 *key, const u8 hfunc,
-				    u32 rss_context, bool delete);
+	int	(*set_rxfh_context)(struct net_device *,
+				    struct ethtool_rxfh_context *ctx,
+				    const u32 *indir, const u8 *key,
+				    const u8 hfunc, u32 rss_context,
+				    bool create, bool delete);
 	int	(*set_rxfh_context_old)(struct net_device *, const u32 *indir,
 					const u8 *key, const u8 hfunc,
 					u32 *rss_context, bool delete);
diff --git a/net/core/dev.c b/net/core/dev.c
index 0600945a6810..b2cfc631761d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10794,8 +10794,9 @@ static void netdev_rss_contexts_free(struct net_device *dev)
 
 		idr_remove(&dev->rss_ctx, context);
 		if (dev->ethtool_ops->set_rxfh_context)
-			dev->ethtool_ops->set_rxfh_context(dev, indir, key,
-							   ctx->hfunc, context,
+			dev->ethtool_ops->set_rxfh_context(dev, ctx, indir,
+							   key, ctx->hfunc,
+							   context, false,
 							   true);
 		else
 			dev->ethtool_ops->set_rxfh_context_old(dev, indir, key,
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 9e41dc9151d2..fa0a3de1e9fb 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1382,8 +1382,10 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 
 	if (rxfh.rss_context) {
 		if (ops->set_rxfh_context)
-			ret = ops->set_rxfh_context(dev, indir, hkey, rxfh.hfunc,
-						    rxfh.rss_context, delete);
+			ret = ops->set_rxfh_context(dev, ctx, indir, hkey,
+						    rxfh.hfunc,
+						    rxfh.rss_context, create,
+						    delete);
 		else
 			ret = ops->set_rxfh_context_old(dev, indir, hkey,
 							rxfh.hfunc,
