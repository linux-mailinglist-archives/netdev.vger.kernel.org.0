Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4647251EC51
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 11:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbiEHJOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 05:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbiEHJOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 05:14:00 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55199DF1C
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 02:10:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aa61M4gcin10PCQRBo2IF4pgufD9pnI1z3RZ71w++i+cyeKiDVLJIJm9EIDpoO6/HD2cmgwZMFCU2SfZo5DdrhU1UR1g1ey4QnfUb0JJEFQYSBhyngkZqzbporMtwRtZ3Ym2WEPkyqvbh3uNG1c+K54uwg6e41JpOdKBQ0gSCryAP70EMbIcfVKr2ClEWglX0612qSIfgnkI1sxYheDCif5lzX78n98g5IhGVcw2fa8VXhBXOJt3+G9p3EQr+9KivwgRE+gc2RIjExYLhci1Yoildk0HkEsWXkca+jqKQkJkBnWEhH9EJNOUYhOGkTkkH4ITE44jTX9c+lZPDO6RUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QpkLZJjORwr2qSAIgXN7+4vIPrP7KJr/gS/jGpbRFjM=;
 b=X5+DgtsNEkH1EB39WIYPT+5jOR4Cd9T18HaMqhRu/sJAsEx5cegQwBG9S/Oqd8+1LTmuucXY3G0TcU81PCnWjpOlato/8EIdLlIfgWI48AVwqpd0D5ZGD8onzZFHTjy6/DbtTKJ5S8ccfPG0lerAVgtWfwkdEZJk4Lmim8FHQDVifaFXxzzMFJ6Flp/IAsrzc5Jduetvwfghs1yxGQ/7Alanwgb7yLBJ4g6fDqfsK4awZrtn2GFQn1zUkde0aMr9Hu6rct4JqV2YsZCXL0IWzoGWQHU+nrwWfT/mn+pi49F7h4Pg5qrcsPUerNVakz3Vtb158stsduOYhJ3lC3UrHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QpkLZJjORwr2qSAIgXN7+4vIPrP7KJr/gS/jGpbRFjM=;
 b=UqCkFTlaE6ge+pRuV8vwrZYttgFvg/9mCHXpMGHg0+EB+Vs8/Bq6MhotdykJt8URn7PUkJ8YfZ/C767kamN5RLqJMD6apOCXHkkrrT5zSiZeHWJmHr9daP6xz79SF3aOkoj7LAoPVvWVYoHCkt4Z37/KMSa+r6ULfxOxI8CeNEjHXpoV2f60eGhZJGf1+35HMBIODaqZ5G2yjo0Pybtd2AqDvQT+/5/K4H7EPw2+Lj6HOW2o8xM0M0JMlUEmIEOF/Qtg3PdjOu3K1KbtJHUvEFkaSV1PenD4F2n3TTUlOLAs52i7hg5t8ltBm+ZqV3UmRq33t38bXU8B9l2eeQOXOA==
Received: from MW4PR04CA0098.namprd04.prod.outlook.com (2603:10b6:303:83::13)
 by MN2PR12MB4989.namprd12.prod.outlook.com (2603:10b6:208:38::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sun, 8 May
 2022 09:10:07 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::24) by MW4PR04CA0098.outlook.office365.com
 (2603:10b6:303:83::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21 via Frontend
 Transport; Sun, 8 May 2022 09:10:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 09:10:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 8 May
 2022 09:10:06 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 8 May 2022
 02:10:05 -0700
Received: from nps-server-31.mtl.labs.mlnx (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Sun, 8 May 2022 02:10:03 -0700
From:   Lior Nahmanson <liorna@nvidia.com>
To:     <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>
Subject: [PATCH net-next v1 02/03] net/macsec: Add MACsec skb extension Rx Data path support
Date:   Sun, 8 May 2022 12:09:53 +0300
Message-ID: <20220508090954.10864-3-liorna@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220508090954.10864-1-liorna@nvidia.com>
References: <20220508090954.10864-1-liorna@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fbb74b5-f3dc-40de-f0f3-08da30d28bb0
X-MS-TrafficTypeDiagnostic: MN2PR12MB4989:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB49890F744546C0235F9A95C7BFC79@MN2PR12MB4989.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hs75b09VRTKZCtaJlt9wn1i7kMDH6DSsiT0XXCb6WAZ59BKWiniB56rKV5QxMDjcDmfE6FMgkti2lEX2rQIe5r+xfHroJBm92lPXLdlci0CESJSVcg5OhpAb1PKJUmvtMgfKATQ7pYaGrapVLB5JcXHuL0bCZyg7i0fIhfAqK7ewXaFtODtJxlAZPer4n1BKDLT+y8CfYn86k6tRMFcv+lqoNo7zpzRTn5Ay88t1LLj5/dcVcsJgLV/9l3vEQxDwyK/97DFihPx3TvZkAQ6kG2E44HtAfUi0GaPe+4DmdUDhzsocALGmUXPk28YoOQ02fxGkJUEtNg7t2mpbZ2QN06SXzZs+eXkK/81IjFIHPqRiVKAsVKjKYLtZ8Gq/vFak2StB3WyZVR5kXa+bRSiRrvHjBhN3X4vNMDdaPtarLddovryOC1oTKuV9hOOL1Bh6ntIZ36KS3p88FjbpItN7ltXyocKcVxm9aqt3tjXggcOTPyViH0JxnmuJeqTxBd9/4qL9qIL9xDnT95EuvnAGS3b0/oA2+OIF/CV8u97bqazy/7VdGzHe8vzXdZeuEv2hlSF6FkSOVNfo5r7kUBWeL66GUMX0UbZtZY+8PmPHtxpOhUACPFn+3PYqoMmAzfcQLzA8VZzEwf87g/y3v8Na+3XBqt8ogOnKfFD4if2QPOmfUdfWXLZzVPP/pdNETsGl1AsXGzPJb+lZFb52GR72CQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(70586007)(8676002)(81166007)(26005)(70206006)(8936002)(4326008)(86362001)(508600001)(5660300002)(2906002)(110136005)(2616005)(6666004)(1076003)(316002)(36756003)(36860700001)(54906003)(40460700003)(82310400005)(107886003)(336012)(426003)(186003)(83380400001)(356005)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 09:10:06.9991
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fbb74b5-f3dc-40de-f0f3-08da30d28bb0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4989
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like in the Tx changes, packet that don't have SecTAG
header aren't necessary been offloaded by the HW.
Therefore, the MACsec driver needs to distinguish if the packet
was offloaded or not and handle accordingly.
Moreover, if there are more than one MACsec device with the same MAC
address as in the packet's destination MAC, the packet will forward only
to this device and only to the desired one.

Used SKB extension and marking it by the HW if the packet was offloaded
and to which MACsec offload device it belongs according to the packet's
SCI.

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ben Ben-Ishay <benishay@nvidia.com>
---
 drivers/net/macsec.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 0960339e2442..ee83d6a6e818 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -997,11 +997,13 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
 	/* Deliver to the uncontrolled port by default */
 	enum rx_handler_result ret = RX_HANDLER_PASS;
 	struct ethhdr *hdr = eth_hdr(skb);
+	struct macsec_ext *macsec_ext;
 	struct macsec_rxh_data *rxd;
 	struct macsec_dev *macsec;
 
 	rcu_read_lock();
 	rxd = macsec_data_rcu(skb->dev);
+	macsec_ext = skb_ext_find(skb, SKB_EXT_MACSEC);
 
 	list_for_each_entry_rcu(macsec, &rxd->secys, secys) {
 		struct sk_buff *nskb;
@@ -1011,7 +1013,11 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
 		/* If h/w offloading is enabled, HW decodes frames and strips
 		 * the SecTAG, so we have to deduce which port to deliver to.
 		 */
-		if (macsec_is_offloaded(macsec) && netif_running(ndev)) {
+		if (macsec_is_offloaded(macsec) && netif_running(ndev) &&
+		    (!macsec_ext || macsec_ext->offloaded)) {
+			if ((macsec_ext) && (!find_rx_sc(&macsec->secy, macsec_ext->sci)))
+				continue;
+
 			if (ether_addr_equal_64bits(hdr->h_dest,
 						    ndev->dev_addr)) {
 				/* exact match, divert skb to this port */
-- 
2.25.4

