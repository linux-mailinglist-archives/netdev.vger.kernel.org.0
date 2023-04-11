Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3023F6DE3DD
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjDKS1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjDKS1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:27:33 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2068.outbound.protection.outlook.com [40.107.96.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAE65593
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 11:27:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KSKpQkm5PPzut9qtjPY9m9Iz9xWMdfk2R2pwKiF07FOVZPtM+r6zRBYwIV3d+Yt0YNFoAEz5E16HnP6fN/10B2x+wUNUQ2axi6YDv62sQvi4CeCLvAetXPD+YaNBT4CrT8jf5l6/pSnMCEFh4dTnskhaJsqsN/AmO4u9QE5JoUZi4B0eIcrcp1Mv23YXVhZd0hQQQCiBpwNCP3uY82EAJ+7+1eiYhruJ4s+4aIko2ke8CUMpSMOwnXxQ8Fblv6L5pot+1EBCQByZzf2fC39lqyTubWvcf1eA70YFgzJiV3ZKYWIapOw66+cMGvyktkF2v9e3IQOxLwkJf5Mrfr8SnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8M8DDhgB7aBo4b2Vat1j+mU1OtM2dNPoUJx3mgH4d4s=;
 b=GKpMIKcXpNNxbcBmuCYQVKNppjJwLJgqVtpBQ0UBYQPeSJwfLlOZwRJBAtukOuQ21HjkSDGNyr3oDtFcURhsiTalRJOPD2E1y/cWd5DCBv0qIkhwYwe4e4RZbB7ex7eivKsvF23Sl7BNfCUUqv9r6MJ2oosu2hBCAdq5ulNkT1Qu5Exqnty05JzSsZ52h7AzRRYw2dN9IfbK6UzAR0TEOvsnxz8sxFUYn/Xz6OC9T4luWs8Pg/LRH5vBCwWQVuxeFJmjLPzZ+/bZYno5RlJz1pa8VFVWcGAJGPMthEi91WC7uSJy2O65ThDVW+0fhSi91kJSo1qSufHvZK9ld6vbXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8M8DDhgB7aBo4b2Vat1j+mU1OtM2dNPoUJx3mgH4d4s=;
 b=MaBT+feEziL60bcxAXO30WTW1oFSHrMeqi7sNMdtsPHRuq0358ah9WQrOsWGVUCnQgHRoBwMIDvPSWcrsJVzOGOceNeQ2mbQ//VXChOOiXmoVgQxJToHfXN1Pv38Ij8mBostl5n9zliTl9kIGf8RWpjMRN+pAHSa63sfHDYlLEk=
Received: from MW4PR04CA0253.namprd04.prod.outlook.com (2603:10b6:303:88::18)
 by PH7PR12MB8121.namprd12.prod.outlook.com (2603:10b6:510:2b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 18:27:29 +0000
Received: from CO1NAM11FT090.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::6f) by MW4PR04CA0253.outlook.office365.com
 (2603:10b6:303:88::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.40 via Frontend
 Transport; Tue, 11 Apr 2023 18:27:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT090.mail.protection.outlook.com (10.13.175.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.28 via Frontend Transport; Tue, 11 Apr 2023 18:27:29 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 11 Apr
 2023 13:27:28 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Tue, 11 Apr 2023 13:27:27 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: [RFC PATCH v2 net-next 5/7] net: ethtool: add an extack parameter to new rxfh_context APIs
Date:   Tue, 11 Apr 2023 19:26:13 +0100
Message-ID: <a3eec616634b86a9368e5a17fe3eea1ff16133cb.1681236654.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1681236653.git.ecree.xilinx@gmail.com>
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT090:EE_|PH7PR12MB8121:EE_
X-MS-Office365-Filtering-Correlation-Id: 62395fe8-f059-4c24-578d-08db3aba6867
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YUIA/Mo5JOaWA/hsHhU+eTsjyAsF5Qnj/V1JxmIdOcZZ+nPSuuJ0mS4fJQC37zeWmuvNxWb4fv6/c/YzcYMTC88RbRkzKiin6LJZyculBjWdZOCkDNWPkdFH5lTyudQxsek2CBKamknu9Www8ZxGiFRSn6c+QEnZukITuoPOrsCmJ3cTciP4kJko2Exa5DuBWx8az0wZ4DLtVRZ072hAcX6ty3uWgwJXoFqvO2522oupVlWXr239bJKMWrJwc8Ww/DNlnJ14f5jp2LLBbHzbF90kHag33+DPm5U0IJQuybTj5Npa+disK+z77Y8ul1/4JlGZcnOn+0OqrObXP3N5Lo9a5P7Kz41uUJTzyHAOoN77XNf7xcfgtOIdV1N0gzbZ4p64ZIld8QyyHK8aXYQSVKnNihoipihX2VHf78EVUzEE89mGQFFqzVIYLByE1U/ywjKKR0rf4lWlpDVPRMMRkz+zCv0qhzdyzvcDIlhNG/3+/bBW/RvcUc5Q3irQ42DBwyu4/IZllMWhFlLj+utEvYVxWWLWJjk9DpVo2anK3WJdWxRjjoOgci75RNaD/W1HHfl8bukzbEn3urFloUUaP++fz8PGf7MbhvtopyyuFY8mDR9w5ODPOEJH8XBCsg9YSfLRBeD24TpEgq3tMeGFSf+s/vtcGipq6Phw6h/PmU/cJGQW2aaiVxxJu/neAm1YfwrP2wvxX8aBMzwfo+jhZOazQOtYPpGpPbl8Tv2BlGk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(136003)(396003)(451199021)(46966006)(36840700001)(40470700004)(5660300002)(40460700003)(8936002)(26005)(9686003)(40480700001)(6666004)(83380400001)(47076005)(2906002)(2876002)(36756003)(186003)(426003)(336012)(356005)(81166007)(82740400003)(86362001)(82310400005)(36860700001)(55446002)(478600001)(41300700001)(4326008)(70206006)(8676002)(70586007)(110136005)(316002)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 18:27:29.1269
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62395fe8-f059-4c24-578d-08db3aba6867
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT090.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8121
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

Currently passed as NULL, but will allow drivers to report back errors
 when ethnl support for these ops is added.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
Changes in v2: New patch.
---
 include/linux/ethtool.h | 9 ++++++---
 net/core/dev.c          | 3 ++-
 net/ethtool/ioctl.c     | 9 ++++++---
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 12ed3b79be68..724da9234cf1 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -926,14 +926,17 @@ struct ethtool_ops {
 	int	(*create_rxfh_context)(struct net_device *,
 				       struct ethtool_rxfh_context *ctx,
 				       const u32 *indir, const u8 *key,
-				       const u8 hfunc, u32 rss_context);
+				       const u8 hfunc, u32 rss_context,
+				       struct netlink_ext_ack *extack);
 	int	(*modify_rxfh_context)(struct net_device *,
 				       struct ethtool_rxfh_context *ctx,
 				       const u32 *indir, const u8 *key,
-				       const u8 hfunc, u32 rss_context);
+				       const u8 hfunc, u32 rss_context,
+				       struct netlink_ext_ack *extack);
 	int	(*remove_rxfh_context)(struct net_device *,
 				       struct ethtool_rxfh_context *ctx,
-				       u32 rss_context);
+				       u32 rss_context,
+				       struct netlink_ext_ack *extack);
 	int	(*set_rxfh_context)(struct net_device *, const u32 *indir,
 				    const u8 *key, const u8 hfunc,
 				    u32 *rss_context, bool delete);
diff --git a/net/core/dev.c b/net/core/dev.c
index 4feb58b0beb3..44668386f376 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10798,7 +10798,8 @@ static void netdev_rss_contexts_free(struct net_device *dev)
 
 		idr_remove(&dev->ethtool->rss_ctx, context);
 		if (dev->ethtool_ops->create_rxfh_context)
-			dev->ethtool_ops->remove_rxfh_context(dev, ctx, context);
+			dev->ethtool_ops->remove_rxfh_context(dev, ctx, context,
+							      NULL);
 		else
 			dev->ethtool_ops->set_rxfh_context(dev, indir, key,
 							   ctx->hfunc,
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 20154d6159a1..abd1cf50e681 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1384,14 +1384,17 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 			if (create)
 				ret = ops->create_rxfh_context(dev, ctx, indir,
 							       hkey, rxfh.hfunc,
-							       rxfh.rss_context);
+							       rxfh.rss_context,
+							       NULL);
 			else if (delete)
 				ret = ops->remove_rxfh_context(dev, ctx,
-							       rxfh.rss_context);
+							       rxfh.rss_context,
+							       NULL);
 			else
 				ret = ops->modify_rxfh_context(dev, ctx, indir,
 							       hkey, rxfh.hfunc,
-							       rxfh.rss_context);
+							       rxfh.rss_context,
+							       NULL);
 		} else {
 			ret = ops->set_rxfh_context(dev, indir, hkey,
 						    rxfh.hfunc,
