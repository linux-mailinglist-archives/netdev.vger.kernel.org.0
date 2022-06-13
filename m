Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E3E549868
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351645AbiFMMk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 08:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357367AbiFMMjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 08:39:45 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2078.outbound.protection.outlook.com [40.107.243.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E685DE4A
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 04:10:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhQuEtgwhomFVste5K/pRcSyHsuIORlGfV2MsTvoAv98cTKAlxHXsXW8sgJ1HZo6NrVcBm+ra6vrIvyJsWyFXm4MBsWvfwr4O86iELG8LYNhecMyWHE8qEdhaBi0UBO94QdkrbXkNCmX/6/MD91WxZm4Fm6dIvrRU6fg5nGLeOUaztefsE5s5io3Ml7WIUjn/2Pf+LeGEnjChh867nc4jU3lb1HKz2F8cjxOjmn5ZNGvHTJ0s3/p+i6es9OV4kanp9x61cnovqBCmThzGeXNZbrymjvGXXNDE1I2VL6z2jKSowM6vyXuChcMK42mEutOPdD1W76vXONCDTaCVvEZ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wrTvu47xtEMBgGOumiBcnu0RFNmeniRARcvGIXM3ot4=;
 b=ACjtjTeiZp0gCd0p1UQYflZRfVRkvfgZFr79GNdnZhCBaM84rLDbwpaaM4AB3r9AthuFsJVrIt4pvuhSvntSEBXHhlNsnw7TgOOjzGglzU7798PmrInMmA213ulKHJIt4U36K7njH4ite6FE4f2ifV1qFONcKgWvhB9IgQFL7yLSUT9J41kQcH8ks2FaTo1RNoZe54Y3vJ3kFIKNXVU2c+dPSTQE4gLbCqC4pDG4YgsbTJgBOgIprzKwiWNQ5SQrEgKA/xtmVELjo2SmqdZaLFnjBPrwhOMzhDCaFCChYae1Woui2uEJsahwO0Fa/4MJN+yk6bB7qgCK8aNHyChr7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wrTvu47xtEMBgGOumiBcnu0RFNmeniRARcvGIXM3ot4=;
 b=S1qvYjltTUss76FXFX/hEqGjHNDfWhcjppiyTKmbM3VvRJs0aECvY6/m5cy11x/mdFdSRxzvVqJlL84iVVgVHVM2tjzFjxFVpJdIeCn/O7MsxYFDt1KIlSAKsgUfdBRTelQllujdT9wvSA2H2cQCXteoCHZwdOvscNJHMS7zNlg1lFzJ+25pECuPpVTvvnrOvciwg1UYeIrkpVzdwgxQIsVcgC/yjdi7ImjCoFb9vXWQNWp3iT5haq7AlcTg2xq3zybNeeUWb/tafgsnXWZbr0SuR9Hy0SYwiy0aRi5XOAH/6yrl4ZxVdBXw9L3z1PjInFyuPTK+uweouRes9KndWg==
Received: from BN9PR03CA0559.namprd03.prod.outlook.com (2603:10b6:408:138::24)
 by CY4PR12MB1415.namprd12.prod.outlook.com (2603:10b6:903:43::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.19; Mon, 13 Jun
 2022 11:10:00 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:138:cafe::d5) by BN9PR03CA0559.outlook.office365.com
 (2603:10b6:408:138::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16 via Frontend
 Transport; Mon, 13 Jun 2022 11:09:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Mon, 13 Jun 2022 11:09:59 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 13 Jun
 2022 11:09:57 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 13 Jun
 2022 04:09:56 -0700
Received: from nps-server-31.mtl.labs.mlnx (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 13 Jun 2022 04:09:54 -0700
From:   Lior Nahmanson <liorna@nvidia.com>
To:     <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>
Subject: [PATCH net-next v2 2/3] net/macsec: Add MACsec skb extension Rx Data path support
Date:   Mon, 13 Jun 2022 14:09:44 +0300
Message-ID: <20220613110945.7598-3-liorna@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220613110945.7598-1-liorna@nvidia.com>
References: <20220613110945.7598-1-liorna@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bd5abc8-f356-4819-ed64-08da4d2d4187
X-MS-TrafficTypeDiagnostic: CY4PR12MB1415:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1415AE6458F37FB789A43622BFAB9@CY4PR12MB1415.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fpwuiI1zAIFUnzfHpRPv28y5Fz9o1iZx6UdDvY6eGXPYaTewOEjFxsDNB62iKxl4/R451NMKQHHSJoPg80fkqbDHEqBLxTLIrpkw+VoF9TINpiGFWAeB0DkXXJGfVkjiSClKfadCZsSs7onaSftkRGkZ2/heHi9Tmctcq8PpKZiOupFPj7LtKn9IRBiIxwvMS/CwAMQOyTEGUMWTN59yva8IZudqSYW6lZlP272QE2xm2MCj2RKJVYSV088PHMZ2Vg2unRt3vT4Fv58CJD9XvJt0uo2wtjoop6Hs1x7deyNxbwW+ekkDC2B6GRr4CrX6lnGvYFdLkeExiw3+0wf0//QWTOgjJW6XpSr50KA51d9wG5c+5AWx0BbTOPAsayw1UXkw6rnu7rCwpLd5BDyYn/G3sy52UabrjtuLo2Jg/klQ3e5byFZc2KhjeOnTH592ctQMZ/Bobge80hXnTH24N9iMPrkyrU6KPX+0tS9W9Rp60dGiY/7gn2eRwIXhmQ9kZjKVywg9AyfGpvg+8+QV3zySQkNXnqPi9+NjOgXbJdn5aN49vehkAMxXoie2FMAMnBiY4Jpq7A5HeQ0a/DR1kv8Sdj9aM/Z8uQkhFrAh/r2CDRxVXwoIqhsLIW2ylcZyerPmP09kihtnW7M4jzLvzRKsRRHqiFnkUH8Moe91v3wcLLKvX1qsOuF6yp/LSZpqrn5rX9I6Bbz/+/YLYKrrBQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(40470700004)(36840700001)(46966006)(4326008)(8676002)(86362001)(82310400005)(36756003)(356005)(5660300002)(81166007)(110136005)(8936002)(54906003)(316002)(40460700003)(2906002)(36860700001)(70206006)(186003)(26005)(70586007)(2616005)(508600001)(6666004)(107886003)(1076003)(83380400001)(47076005)(426003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 11:09:59.2922
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bd5abc8-f356-4819-ed64-08da4d2d4187
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1415
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Issue: 2978949
Change-Id: I6f9019f9f366c82428f498e31219c4b7691b4a12
Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ben Ben-Ishay <benishay@nvidia.com>
---
v1->v2:
- added GRO support
- added offloaded field to struct macsec_ext
---
 drivers/net/macsec.c |  8 +++++++-
 include/net/macsec.h |  1 +
 net/core/gro.c       | 16 ++++++++++++++++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 9be0606d70da..7b7baf3dd596 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -999,11 +999,13 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
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
@@ -1013,7 +1015,11 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
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
diff --git a/include/net/macsec.h b/include/net/macsec.h
index 6de49d9c98bc..fcbca963c04d 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -23,6 +23,7 @@ typedef u32 __bitwise ssci_t;
 /* MACsec sk_buff extension data */
 struct macsec_ext {
 	sci_t sci;
+	bool offloaded;
 };
 
 typedef union salt {
diff --git a/net/core/gro.c b/net/core/gro.c
index b4190eb08467..f68e950be37f 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 #include <net/gro.h>
+#include <net/macsec.h>
 #include <net/dst_metadata.h>
 #include <net/busy_poll.h>
 #include <trace/events/net.h>
@@ -390,6 +391,10 @@ static void gro_list_prepare(const struct list_head *head,
 			struct tc_skb_ext *skb_ext;
 			struct tc_skb_ext *p_ext;
 #endif
+#if IS_ENABLED(CONFIG_SKB_EXTENSIONS) && IS_ENABLED(CONFIG_MACSEC)
+			struct macsec_ext *macsec_skb_ext;
+			struct macsec_ext *macsec_p_ext;
+#endif
 
 			diffs |= p->sk != skb->sk;
 			diffs |= skb_metadata_dst_cmp(p, skb);
@@ -402,6 +407,17 @@ static void gro_list_prepare(const struct list_head *head,
 			diffs |= (!!p_ext) ^ (!!skb_ext);
 			if (!diffs && unlikely(skb_ext))
 				diffs |= p_ext->chain ^ skb_ext->chain;
+#endif
+#if IS_ENABLED(CONFIG_SKB_EXTENSIONS) && IS_ENABLED(CONFIG_MACSEC)
+			macsec_skb_ext = skb_ext_find(skb, SKB_EXT_MACSEC);
+			macsec_p_ext = skb_ext_find(p, SKB_EXT_MACSEC);
+
+			diffs |= (!!macsec_p_ext) ^ (!!macsec_skb_ext);
+			if (!diffs && unlikely(macsec_skb_ext)) {
+				diffs |= (__force unsigned long)macsec_p_ext->sci ^
+					 (__force unsigned long)macsec_skb_ext->sci;
+				diffs |= macsec_p_ext->offloaded ^ macsec_skb_ext->offloaded;
+			}
 #endif
 		}
 
-- 
2.25.4

