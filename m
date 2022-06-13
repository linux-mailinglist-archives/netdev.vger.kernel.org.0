Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9922548A0D
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359011AbiFMNMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 09:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359293AbiFMNJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 09:09:46 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2086.outbound.protection.outlook.com [40.107.95.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23DFD134
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 04:19:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=adt3/vnq9P4lvHu2ZzwoC6wPLU+9ggEsIYK6He8EpB2rVbXmRFE7czbHrSlGP0vZO8snzu56YRRW1sLfGX4Qd7R5YMrYGEeAOkExgNKJAc6hoDrXLadH9MBlnW16WIuGw9sq+y0b1Ur4m7p91mCQk52yLvr6N0H9jWGgX9c+IhilIeptmz3REP/77S7Q/P8ZMBnWWZWD5Ua6fdUIEPqHmpXBihE20T8lp8o8qo84xKkfO9/r2yrnXPj+XttSgHpSIvzuuEjmrwfRfxb3GQUnF2s0o8HmhkwyINNpdY9QPqDYS8b3enWFU0/TPbjxdnWV+Wbhb47s2Rdbl3jTeHNR2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LSBSNLrysNRSUmqG8tbOw5oqqpbaxWuSpnZpGnoKtH8=;
 b=ll50YpGkXX+CaD0EVRI36rsqn8RQr9w//6U9vV2QCKvxSB21lMLaQk51f/WwKJEMk+FF/RVfg/c4TTWyFFJQI8JnVX6CpQZJjG/5nL0RK+KlUYUpHwSpAnVADeGzfdFuVtxWnkNilXnsEEOg3mhMm6U+2zQL8jw9Ky3pBFpCOdu1V/FVXyGIOTq+ArwoKfUrYsKQ89cQN6EQdI9KphQ58M2E9vTghDsFMAbyFFY13vyilOo9Y0nSwQwTERn3qZiiWKVUmi6WG8nunub/xC+Sc9cE+6OH3fDjlTHwLBnm+KXSzlEN/Cy7xbtSnP/61DlxtuKSodu6kFSJofU+FrdZbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSBSNLrysNRSUmqG8tbOw5oqqpbaxWuSpnZpGnoKtH8=;
 b=QYX6PH8+lHK11bYCawzWwiRShKO+ILAZ+l+FQ5Njl4wF5tUPPDFOMGO5vcvUpfaXkfu7GjYOR2xYAymXTcvVAH01hl5d64gKERu0YMX6jMtCUEf7wisChpqgWaOiGs8CnRff1dtGw7U2rAQMjQ0/4959CnbIyyel4BZPeFVgcwcWbL62DZqGVc6XMYm6jDQ1j1wA6hm/32wyfw+g6zOf8eKB/7tm20ClHu2SQIAiIjDR30z3OX5LfG3/ZxrN2ZAe0F5yEzAMdWnL1hhJYrW6oRI1ILEKwnYDL1qjuM3h7wRTE+pn1vMZrKgxDrDq+cuYXdu5fFW1KA4NrvLLnLOzug==
Received: from DM5PR07CA0041.namprd07.prod.outlook.com (2603:10b6:3:16::27) by
 MN2PR12MB3774.namprd12.prod.outlook.com (2603:10b6:208:16a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Mon, 13 Jun
 2022 11:19:54 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:16:cafe::a0) by DM5PR07CA0041.outlook.office365.com
 (2603:10b6:3:16::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13 via Frontend
 Transport; Mon, 13 Jun 2022 11:19:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Mon, 13 Jun 2022 11:19:53 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 13 Jun
 2022 11:19:53 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 13 Jun
 2022 04:19:52 -0700
Received: from nps-server-31.mtl.labs.mlnx (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 13 Jun 2022 04:19:50 -0700
From:   Lior Nahmanson <liorna@nvidia.com>
To:     <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>
Subject: [PATCH net-next v3 2/3] net/macsec: Add MACsec skb extension Rx Data path support
Date:   Mon, 13 Jun 2022 14:19:41 +0300
Message-ID: <20220613111942.12726-3-liorna@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220613111942.12726-1-liorna@nvidia.com>
References: <20220613111942.12726-1-liorna@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c1cbb94-5ffb-4589-5c07-08da4d2ea3e5
X-MS-TrafficTypeDiagnostic: MN2PR12MB3774:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB377480E7A5ADD74EA4486849BFAB9@MN2PR12MB3774.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iI7EfqkYk3kKyWNkCAwRSKZSgyndpv6N1iSiGFMRNlKz1ARaRC8tZw4Dz0akQ0chkjCBKG+AFq7SA5uzxPhKMrnFTE92uYhrRksi1TqNfBAYGN10EmvcaUPuH1iIOwXItBPYBtBxjk3txj4aba4qfJ6QnozesecwfC8MTJQwwj2aA5i9+Y4XWmKAwEfsiQrlhQKQCG/AWGX/T+DHv1U1cGmyvrktToD7Qg29nCnZA98WVDeiEjfukj0FydUDpp0nunJzvnw1liCeKKOAg7xxxxlwQt8U3yrDfhzGuAjK6MmG1rUT0qgRAToeZkTMhSZ6v+1M6hHWh0nOUApBrf1OZcV7TeEbxkI+ECXZ5ZHWwt48XoQxa18rpLdA56OKLnCQAvDSk1WyieT7MzbdSUcjWO/0r6kz86lOo4+gcWhv2wLrZI7wJLExSyOSsszRw7AJZVbVL7DcLJC3QFipq9zVd6CeGJu12y7DxnFbM8VqVd2M5L27rqeSPaGIIXd36fDNGrEHxtI1Q+59cQNE/9z1ZmW9/vMCPIFdjHWS5cEv5blmHZbLKJNT4bzsOHEvH4t8DEUkchrpUfrh/j7vkprVYjUvdBlJ57PyLn0jzojACrDNoCD2tLX6mM1On4oq3qx7Is6sR8wihlDrhgw0AElsU/1Qei0gW7KU/fTUZR9sS5eCbx+QvUCV61YPpYcs8GCs5Q7R3KHf3O5R9Dxz/L5Fsg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(40470700004)(46966006)(36840700001)(8676002)(70206006)(70586007)(4326008)(6666004)(2906002)(83380400001)(508600001)(8936002)(5660300002)(40460700003)(26005)(54906003)(86362001)(316002)(36860700001)(36756003)(356005)(81166007)(110136005)(426003)(336012)(47076005)(2616005)(1076003)(107886003)(82310400005)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 11:19:53.8804
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c1cbb94-5ffb-4589-5c07-08da4d2ea3e5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3774
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

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ben Ben-Ishay <benishay@nvidia.com>
---
v1->v2:
- added GRO support
- added offloaded field to struct macsec_ext
v2->v3:
- removed Issue and Change-Id from commit message
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

