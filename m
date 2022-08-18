Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60B6598417
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245033AbiHRNYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245032AbiHRNY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:24:29 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2044.outbound.protection.outlook.com [40.107.95.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D4E3DF09
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:24:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bLR0/+XxJ1FIRJs25BKCApjCAC9RAGGdIKscD8bEO2G2iScPRSsqkj/QxAsu1EzAGYdXTTtL6av1LMGpofSoxz0zA5SHbO66UCySWYs/8rkFHq8AxTnMTBKiLiNDKm2aYUz8vrl7qgF2ZV8hVS46XgJQiml+UWgCEF9wWM15nAVAHSEroPDZWeKXBkB5CW9BrleYNyWTOpnO44Ie2jehQHXBxo39hRo+HCmdqTLYoYZDLidg6/biSjBxVBzs1fb1akYYfKhcHj1sJ4eDSw8mwoHnfumOBa5PLK+vOQJ4lIyL+pRE1Q+kLsQWWWMwnsndI7p9FhlzYi4NyI9nCEbzHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FPODQhaeEbvv7SCP/df8AkWEKmyAKFilj79vViT5fM4=;
 b=It5qyzpBE2Lk+W767UOBc3EJBAQddloz7hFYyeBWFHhUfEXpXK69DtI1Rb1IDcX06oUIl5X7exEWpfhtZGyNQoynSknxzJBNdbZZSc2Jly7Y9M5xNTc5v8mETTI6UPbQRttt+wrLI8dpnczQnvmsI8nB2uq7wwP2Ay56Q+QR9y4Xy/unbt0EBQtYYDVt/H5VWboF6wyvJIiX3FU1MIY1Q7zH4Rr7sn6YwTT9hWe+7fhj2lqk9NEOZHyByitaCn9t3XqyjR/U8REfJXaZCGcjqJrO3IFQ/QqUanqS++q4o8SB9lZOpgFRchiNvfE3IVad6YhaVk/jG5TyiWArFZRjOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FPODQhaeEbvv7SCP/df8AkWEKmyAKFilj79vViT5fM4=;
 b=FS0jMGpSdcXtc8i3CPPhlH5qsJ5XElv7eAIT1NmXeWDkeykrOLre41BCKVx2W+yzHNQgTwXQgi8BgqOYYNeRKPaPCSbCPhQ8NDhpn6LCZP/6vEOxKeeDx/TG6OT2+XZE5KsaHKsnwKtYKxoGwEZ+hoBDz7u1vb3TY0Tnvj92hyN+egkfwzt0G3rkgZPPcDofx9kU0jjBpYHxsjFE9ZKtXkvieEIulrs2fuI4RHOOnHVrhF7akS02WtuMro+jujV5mx90P555kp+HU4vd34uNeKis+7pPpoSm1ED8FWiJ6xRHoDid25RGa4rd852dDMVsgvfGNMKiTuRXIQjMavt1qw==
Received: from MW4PR03CA0314.namprd03.prod.outlook.com (2603:10b6:303:dd::19)
 by DM5PR12MB1802.namprd12.prod.outlook.com (2603:10b6:3:109::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 13:24:26 +0000
Received: from CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::2) by MW4PR03CA0314.outlook.office365.com
 (2603:10b6:303:dd::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19 via Frontend
 Transport; Thu, 18 Aug 2022 13:24:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT082.mail.protection.outlook.com (10.13.175.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Thu, 18 Aug 2022 13:24:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 18 Aug
 2022 13:24:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 18 Aug
 2022 06:24:25 -0700
Received: from nps-server-31.mtl.labs.mlnx (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Thu, 18 Aug 2022 06:24:22 -0700
From:   Lior Nahmanson <liorna@nvidia.com>
To:     <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 2/3] net/macsec: Add MACsec skb_metadata_dst Rx Data path support
Date:   Thu, 18 Aug 2022 16:24:10 +0300
Message-ID: <20220818132411.578-3-liorna@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220818132411.578-1-liorna@nvidia.com>
References: <20220818132411.578-1-liorna@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b644117a-b728-403d-b081-08da811cf901
X-MS-TrafficTypeDiagnostic: DM5PR12MB1802:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i53WMQtRDk9sInvZLZITCFKAZxIreIeqQjmlrR4xVihFApLxh0eWZhcVz0IvF6Ew+LOqjlzSsxLeiUKIl7E9xO7AqF5R6moO+oG5LTAPzIDgiMwQ5gyp+yOQVPYyTDFPONmYXoz+f+jsjViXeAmOh55haEQIAfAOM3tU7bqFglMxkbA3GD2kl4+bP+4IW7N+GgPraXDUuiqizq3TU3fCUKrhCMvqzVHerrWgjKpFizD9lRr/hya959ftmJaXZyUf14lU125TcqAoRXr2w5pgL2FAoeGHbvDS5byqqTtnxyZMZdbMaj0OxzIBBWs+Pk8JNnO2QxOlXniwsiNok+kp+8vXruhL/Kth0aW08K5gYR3tKI16Zk7FepC+dKARZ5R0nqAauCi6Fu54HBK/RhMoEu5SLdmF6oS9flydPkeAFH/Yi/WSIuw1s5XnX0jXQS0ARwYn/RsGv00cXz9A/vaMuj/5U8gq4PazqHYlitMibwD9QzW9hnReJ6XobvWsPJMvxZHhqc2jSNIRp0RsM80GwSTU3Q7qzK03acWHhYrWVrhHRMndx5ZFFC3K3bnwxxtp04GBHCOvODJ32/yTmP/X2pAk/InLoVDNSp3Gft3nViYDDTGyUHagJuFFhTmWpaEUFgdWm6Jl2bfKxt5TMW8lQgORfpxZE85JPKyJwFCHKEn+SqxgC2iUxby8kqo7USMEUsl2ZiolzDtgyCspgkR1vGXPc5Au364+cZmD4IuLmAsya4IE614WsiWA54+ZTvlls4z0xV4X4hq0XaPN/+SS+jvQ2xQudIWD2Wd53KLJa7LRQbWuMYlnb55mIP++v2iU
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(136003)(39860400002)(376002)(36840700001)(40470700004)(46966006)(26005)(186003)(1076003)(47076005)(426003)(336012)(2616005)(82740400003)(81166007)(356005)(36860700001)(40460700003)(8936002)(5660300002)(83380400001)(4326008)(8676002)(70586007)(70206006)(40480700001)(82310400005)(2906002)(478600001)(86362001)(107886003)(6666004)(41300700001)(316002)(110136005)(54906003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 13:24:26.1957
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b644117a-b728-403d-b081-08da811cf901
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1802
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like in the Tx changes, if there are more than one MACsec device with
the same MAC address as in the packet's destination MAC, the packet will
be forward only to one of the devices and not neccessarly to the desired one.

Offloading device driver sets the MACsec skb_metadata_dst sci
field with the appropriaate Rx SCI for each SKB so the MACsec rx handler
will know to which port to divert those skbs, instead of wrongly solely
relaying on dst MAC address comparison.

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/macsec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 4bf7f9870b91..534459dbc956 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1001,11 +1001,13 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
 	/* Deliver to the uncontrolled port by default */
 	enum rx_handler_result ret = RX_HANDLER_PASS;
 	struct ethhdr *hdr = eth_hdr(skb);
+	struct metadata_dst *md_dst;
 	struct macsec_rxh_data *rxd;
 	struct macsec_dev *macsec;
 
 	rcu_read_lock();
 	rxd = macsec_data_rcu(skb->dev);
+	md_dst = skb_metadata_dst(skb);
 
 	list_for_each_entry_rcu(macsec, &rxd->secys, secys) {
 		struct sk_buff *nskb;
@@ -1016,6 +1018,10 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
 		 * the SecTAG, so we have to deduce which port to deliver to.
 		 */
 		if (macsec_is_offloaded(macsec) && netif_running(ndev)) {
+			if (md_dst && md_dst->type == METADATA_MACSEC &&
+			    (!find_rx_sc(&macsec->secy, md_dst->u.macsec_info.sci)))
+				continue;
+
 			if (ether_addr_equal_64bits(hdr->h_dest,
 						    ndev->dev_addr)) {
 				/* exact match, divert skb to this port */
-- 
2.21.3

