Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83FE3645732
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiLGKLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiLGKK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:10:56 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B8441999;
        Wed,  7 Dec 2022 02:10:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F3klwChn/5p/T992MDW1uOHfN7Hmtw7rLjWDVPiZRv2t4yKEbR4axLmcobDCFZwKp/Wm94XwVYZRcWyGq9VeNr1fcLjLOOhYGbwgZKXtwLx1TIVH/I3LOMDEd3pUbHi+RJXcyArRtS1kQHl/Xgzl4BHM5e6jvyNNKWO2HxR0Qn3Lxamvi5VphN36RyVW3bWuX4NhRTvDtyYrW/k1dXScC6kdcBv+soE+UmMbdgIZ113PQOMD6cmfpPPm+3bp1LyKA2h8/6R2k59WP7oDssz4BrnRvYXoPZqaJ1ehr/ngCbRe93jrV4U8gtjzdZv8tDB9Q9qRADI7yyRMjxsnA1IrYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d6oghMpOWCgD+1zkTyOvSufBvM3MetytJsmAEad4kvw=;
 b=chyvXvavdizcTsU+sIFvPL0TcORoYLcW2vcHJ9vJ7ljKRIo/fNmw1qmmWFYeEVvCW4I3IfQtB0mtMHX2LbNuOzaUv4u/y04+THRZrC8W/D7phbHaF+dEEjwcMvLE7P4CcNyfyCcORi/qSYR0VWNB+Bx4/jXSwkKrb/D0v4gxMuIJKXEOK+F3Aw0o69/lntrjJrRLMCZ8i4jk8fxWo8vaG2wnW2byDtlVUGbFhI2pmbskVI18vld5khYGgY3RFB+f0m5dzlUUfl0iknrj0/FNwdJoVwq1VpVU7ClM4LfcrYhPexdilikO0nZ3OZd+2yqq+GewrmoHDxYZ1b03B3Ekqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d6oghMpOWCgD+1zkTyOvSufBvM3MetytJsmAEad4kvw=;
 b=jFHPUUtCLBfNLIQZjF5wMqSn9BicohqQ6uv1aK5REvq8S3FBOdETd+kJArXBvoqhKn/xHR1fwGZRrKmOwzPRBGGZkzEUz81H5IDjU6YUq4TGpvNCjTxHB82kC+QH5hH/3B8mirTlz6wQe+tAMkGH4OlLdS1s5UJGtA5MQmEqOydML/MCM00mSAcaDrqIqjn9bcMCMeZmkREN177KBK8z/8879D1mCZDn5WXSCqdZjxILrKBSmIUmYRncwU5ZODXy0j/VN3wpMbjfswrhjz3obEjKmUYbtCDhhKPsMyCwgxEhx+jCycvwNYS0kDbk5lcuHVa6ZiyqlE/jrJbSVCuLWA==
Received: from BN0PR04CA0064.namprd04.prod.outlook.com (2603:10b6:408:ea::9)
 by BN9PR12MB5033.namprd12.prod.outlook.com (2603:10b6:408:132::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 10:10:54 +0000
Received: from BL02EPF0000C402.namprd05.prod.outlook.com
 (2603:10b6:408:ea:cafe::a8) by BN0PR04CA0064.outlook.office365.com
 (2603:10b6:408:ea::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 10:10:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0000C402.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Wed, 7 Dec 2022 10:10:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 7 Dec 2022
 02:10:34 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 7 Dec 2022
 02:10:33 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Wed, 7 Dec
 2022 02:10:30 -0800
From:   <ehakim@nvidia.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <sd@queasysnail.net>, <atenart@kernel.org>, <jiri@resnulli.us>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 2/2] macsec: dump IFLA_MACSEC_OFFLOAD attribute as part of macsec dump
Date:   Wed, 7 Dec 2022 12:10:17 +0200
Message-ID: <20221207101017.533-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20221207101017.533-1-ehakim@nvidia.com>
References: <20221207101017.533-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000C402:EE_|BN9PR12MB5033:EE_
X-MS-Office365-Filtering-Correlation-Id: 57b049ee-57a5-4c2a-d9e6-08dad83b5378
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iJNE4xUKAksJ32MMNPCl5iZVBE3h/eNdGyaiPlKxtzUg60dGRE2TspqJMYmKlnh3EmK9yY4t/JnZvta6At9POlPYRTUjm0SEBDwD41FtRvf3Mb5AMsfZvCadiGKMXGqUP6GcvZKOWHJx4KKRcY4jHXveqXuNJFZEdGHQ2nH3DBkUsSKi/+jxkq3HPT68AaJMAr9KyJsQ1nPXoz/BPked3yvBmeBsB5heksnj1bFtkDkWE4VFBNt6VKcVsOs+5Itj/pdxDcqfqwXf6s4tSWBwC2ml3xl2msm566y3bZLsK3Lq90drBC6yMDMnCW3CCXb7xg4F6wYHUmFuS4i/MI7hpb9vKk7WDOnTau77yax7+VCYtL9ALC7H19+yOeclMpsboxr2vGi+v4PeB5DOOcue0rG2eLlbuLpGvZ7LewTCthJaH6LzHRenGfDt3XQGQp/ipZ+dPIwSIUE6lMURRVtjqGX2tjKUlFWINlNyEtRtKSuweboqxfmYHWX8m0LWQrDG1kRWdYnUtbAbb9HCZQiVyOwsuTTfmbq7PTVwTS8yY2j/5j4nAfubYlGc1B/Fe2KEfPhMWx/CPl6NvjCTrwoxTsvte+JovqvJraHCcqnF5buPecViPEdn0l+uwqCPZ94wKroYqwi1pu/R8+MoQWYPd8DaD7p0XepjmWpmfm7L8Ga9PR43BP/2tyPlg3WDTtM2o+v9T0wAjewxkWRUsiFSfw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199015)(36840700001)(40470700004)(46966006)(2906002)(2876002)(41300700001)(70206006)(70586007)(4326008)(8676002)(5660300002)(1076003)(82740400003)(8936002)(83380400001)(86362001)(6916009)(316002)(54906003)(107886003)(36756003)(26005)(6666004)(82310400005)(7696005)(40480700001)(478600001)(7636003)(2616005)(36860700001)(186003)(426003)(40460700003)(47076005)(336012)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 10:10:53.9414
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57b049ee-57a5-4c2a-d9e6-08dad83b5378
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000C402.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5033
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

consider IFLA_MACSEC_OFFLOAD in macsec's device dump,
this mandates a change at macsec_get_size to consider the
additional attribute.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 drivers/net/macsec.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 1850a1ee4380..0b8613576383 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -4257,16 +4257,22 @@ static size_t macsec_get_size(const struct net_device *dev)
 		nla_total_size(1) + /* IFLA_MACSEC_SCB */
 		nla_total_size(1) + /* IFLA_MACSEC_REPLAY_PROTECT */
 		nla_total_size(1) + /* IFLA_MACSEC_VALIDATION */
+		nla_total_size(1) + /* IFLA_MACSEC_OFFLOAD */
 		0;
 }
 
 static int macsec_fill_info(struct sk_buff *skb,
 			    const struct net_device *dev)
 {
-	struct macsec_secy *secy = &macsec_priv(dev)->secy;
-	struct macsec_tx_sc *tx_sc = &secy->tx_sc;
+	struct macsec_tx_sc *tx_sc;
+	struct macsec_dev *macsec;
+	struct macsec_secy *secy;
 	u64 csid;
 
+	macsec = macsec_priv(dev);
+	secy = &macsec->secy;
+	tx_sc = &secy->tx_sc;
+
 	switch (secy->key_len) {
 	case MACSEC_GCM_AES_128_SAK_LEN:
 		csid = secy->xpn ? MACSEC_CIPHER_ID_GCM_AES_XPN_128 : MACSEC_DEFAULT_CIPHER_ID;
@@ -4291,6 +4297,7 @@ static int macsec_fill_info(struct sk_buff *skb,
 	    nla_put_u8(skb, IFLA_MACSEC_SCB, tx_sc->scb) ||
 	    nla_put_u8(skb, IFLA_MACSEC_REPLAY_PROTECT, secy->replay_protect) ||
 	    nla_put_u8(skb, IFLA_MACSEC_VALIDATION, secy->validate_frames) ||
+	    nla_put_u8(skb, IFLA_MACSEC_OFFLOAD, macsec->offload) ||
 	    0)
 		goto nla_put_failure;
 
-- 
2.21.3

