Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2375A646F24
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 12:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiLHL4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 06:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiLHLzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 06:55:53 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on20609.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31FC7DA48;
        Thu,  8 Dec 2022 03:55:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VqJt2veImlquT9FNAudtN2bbfm0IqzjRr70ZpjXdFFCtq03KqJe4xy0dg0d/Tl6JZrEV8LDJfpcwTxLSSRQo1I4ptu9piCZfOfbqNXB+kdlqDstxOafCU1ml59XSVbl33wQqsMMhLK/VYbxuMJ2x7JUBDizpA14omtS833Ne/XcwuXPUglz532iKiVnhXX70Ki5Dezc4DjvI2YYuddHIBQTUa2TNwMCnLTLPi/sCWKU3J86gEXbgxjSkqrU5oFmidaAjkUdX3ISxPeZis5fx0X0oes1KteQ/wOZ6metPPQdBlsxCWtLcmpw/SBY1rzee5PaWSPEZV+1PHK+K+QBpdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ER0TsY+H09EnNeaTAyoQsJqPtGQdMdKwYQBUIcLbVGw=;
 b=jKFcL93cAjLWCxRgnGrhr99BaJ8t9y7pD/fp9VMphGcu3Mqw1pKc1/0bjT14IIe42j8IIOt1he5rMVPtEG7opu9GgzTmgeJ29Je5rTihx+yqHzZnujPgMxCLLs5/CfBAWdOHEFArwXBhKZCGP3E9s4aA6S8Cm6Xw6O6FVULRFqsmrmSLK75cjiMLB7cjHqH6WUOjbyS1ODShVrcrX8YjMCpv5NFoaBCVaBeB7iaZPfRIvT/ctIuse+czR5ybrNQ1TItdQQo2fgPTRnuGydUhvBK/pbdaneo/CymR7JwqHT5uLE/e63DqN2yeX5BcLU1Zez5C+5DaVOC4xnRCPpEQFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ER0TsY+H09EnNeaTAyoQsJqPtGQdMdKwYQBUIcLbVGw=;
 b=mUADWmeh+jK5p0y78bjGhKOtiVRP+DP6bqpIaXoQY3wYvrNNCzxlArxty+fme+roJmVhEJ7vTY3qNm6YS+S4Dh4dOa3Sa1b+k8rc+lJFPxYuqt4DI6q+xSxVN93i0Bd893N1aM2uo5Wz/5QOes84LPntzg59JoXWOMxF6tTLNhYFQ32LJ+G06K2eTFD9QKGDjpa/C1rzu2wbLUTSad9dT5ytMn1gSp3pTY/dI+osTKSSsWOgfNB2C1UoWWhcp3e1xMlLAxw6mnZIvqWTTNAifRCT5J82V/6ydU6r5SF1zISvl//Idlzp7yFER2kbDASLahL5QiNUXQbVNkWvJR7zYQ==
Received: from MN2PR10CA0030.namprd10.prod.outlook.com (2603:10b6:208:120::43)
 by BL0PR12MB4931.namprd12.prod.outlook.com (2603:10b6:208:17e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 11:55:50 +0000
Received: from BL02EPF0000C409.namprd05.prod.outlook.com
 (2603:10b6:208:120:cafe::60) by MN2PR10CA0030.outlook.office365.com
 (2603:10b6:208:120::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Thu, 8 Dec 2022 11:55:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0000C409.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Thu, 8 Dec 2022 11:55:50 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 8 Dec 2022
 03:55:36 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 8 Dec 2022
 03:55:36 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 8 Dec
 2022 03:55:31 -0800
From:   <ehakim@nvidia.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <sd@queasysnail.net>, <atenart@kernel.org>, <jiri@resnulli.us>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v2 2/2] macsec: dump IFLA_MACSEC_OFFLOAD attribute as part of macsec dump
Date:   Thu, 8 Dec 2022 13:55:17 +0200
Message-ID: <20221208115517.14951-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20221208115517.14951-1-ehakim@nvidia.com>
References: <20221208115517.14951-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000C409:EE_|BL0PR12MB4931:EE_
X-MS-Office365-Filtering-Correlation-Id: 899d6db3-fb4c-4713-b02f-08dad91326b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zVbdUk7jq1oiG3GX3B6bW27FI5Kc1TTap7nP7Sj66n1+MrJSqHvlON2TuysPOQe+Lm8j9luTr3BFsV8KzvMzlt5RZyM/vBAzgyhVk5HWFxTrbdFv5GFt7AWsUcMNJMYET6i6f5qt8VF1qj64/Dv+u4/Qz6LdheFAe16Dcm25pwoWru/PWfgI6zhjGmX2Mf6025s+dEsFcVl8x4ypiMzwT+Ve/gxlWIlUuKok/Kql2AJ4EiU9bEu4nHNiDTBODySZM1d+fF46gXrNcDRUugGZLF3dZT8L6EmhTg7gcIElQPvjqiHt0XU7wE9j8nJxHj+bYEUE0AUFSrOddrjyRP7XLtyrM8Pr/VSQKRRolym/T8Ttd3MZCgR8c5AxG/6qCqNcSrfRRXncwdjqPbX6+T/RNC4f5h5NFC3YYv8g+JtL9PTDwWaFXGBvcW8j1j2QZG8YNQ+gow2EzZQXzWYQmMWX3oPDhPEYVYWLKgEFPfx/0SxXEHMafO04vBYCj9vPEGn7Yi6mLyx6lpu4mKc0276omVUFOk7V+BoBXdUXIUuOk73TcHJm9f01/b1ozrCZHPxG9A9ybywS0PIdeNfWhHNYqOjaS79WRGM8Eg+VIXezrnqLTmQFSSS7TMsWbj/WxRtGO3K68nGxMfFBFLdYyjy9td8oWxfgFl+hASr+ozCHYkqnlAjV/E/RXu9MzormHIIq/LQhzHDLi9ox6rvA0NRL2g==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199015)(40470700004)(46966006)(36840700001)(2616005)(86362001)(70206006)(83380400001)(2906002)(8676002)(41300700001)(4326008)(40460700003)(2876002)(5660300002)(7636003)(8936002)(36756003)(40480700001)(82740400003)(36860700001)(54906003)(316002)(426003)(6916009)(82310400005)(47076005)(1076003)(356005)(26005)(107886003)(186003)(478600001)(70586007)(336012)(6666004)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 11:55:50.1469
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 899d6db3-fb4c-4713-b02f-08dad91326b9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000C409.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4931
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

Support dumping offload netlink attribute in macsec's device
attributes dump.
Change macsec_get_size to consider the offload attribute in
the calculations of the required room for dumping the device
netlink attributes.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
V1 -> V2: Update commit message

 drivers/net/macsec.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index abfe4a612a2d..85208a64f259 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -4237,16 +4237,22 @@ static size_t macsec_get_size(const struct net_device *dev)
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
@@ -4271,6 +4277,7 @@ static int macsec_fill_info(struct sk_buff *skb,
 	    nla_put_u8(skb, IFLA_MACSEC_SCB, tx_sc->scb) ||
 	    nla_put_u8(skb, IFLA_MACSEC_REPLAY_PROTECT, secy->replay_protect) ||
 	    nla_put_u8(skb, IFLA_MACSEC_VALIDATION, secy->validate_frames) ||
+	    nla_put_u8(skb, IFLA_MACSEC_OFFLOAD, macsec->offload) ||
 	    0)
 		goto nla_put_failure;
 
-- 
2.21.3

