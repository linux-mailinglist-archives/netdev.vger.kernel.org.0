Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D9651EC52
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 11:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbiEHJOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 05:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbiEHJNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 05:13:55 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639E9DF1C
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 02:10:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YHgRyFbfWXCWCchTLkr8SxdaRhOgftjpqvk14BO4L7U7eNrYE7S8GYcY4x1XZTT3XV21ajBKz7qeiLqHR7dsVS+UG6X/icQu/pHChC75oxXcWSpc26zJx5GNl8IoQrbWcN+TnpVP+/ZFddffcF1kPc7nIzEXGVUoKfiTVqEpI/XRpV++ign+aRTegfatAi9xD82LfxAIJmr+KbXblcZI6SSFR6qw8UKMEC4s1WMFGkU6YRGZyk2K7EejeZaJckE4ze5zFLxHdzOVWclPlB0SaKBbakr1lgi6VV9gP8czxwxWx+L9TIXThsSduKXRNT6vJEaWIaom2c1nhLATVwZqww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mR1PHQr79HqBd2W9uzr8JPnr1SPIM420MzWZmyN6Po0=;
 b=X8pKXdoMTBNzbAb0h2kusKsKONNbae6YqoKz06ZWNoZipGj9ybwGb2aB2tweJejGbuwzpAc4q7ccAlCDCBwZ6nqsPOxvODc2fCJMX7ZGAY4gkfGvzbprGmmvoX/pjUvg/aW0xKAWVwkia2vMkR2Nd/DLxuft5EQUbwLJcK91DOr3G4vPzWPiBbOZ1IymhzigwVVMKuAJH34XbHKIF51e1HeCVExqFb/uz6R7g4dFIKjQnVoSB0ncU8QxrArdQgV2xa1kBJkVE2Fa9e5Q3yBZjLx9YxOgyVgJHXtHyhHUtgGewLR/cUn/oWoewBRQY8vOzkv2ZbhGHwmlRuYug7ZzRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mR1PHQr79HqBd2W9uzr8JPnr1SPIM420MzWZmyN6Po0=;
 b=sRqZStJXGOXtvcfzVXe5Lkk6ZOhgx9EhYHnmMH0ZGtWZSN7Rp70Nnw5hYFtr6D7ai+VStGnMW98epG+60ZEiy7cB+dAYbbprY5/cGxFmwWuegbq8963G7FKJyyG1+TExi/d2PlAdLN6cRkF8Skcpp5lZvCGhwXofVpoqv7VcjPQ8+PfJDnVJpSyhUyVaDRKUCIk687dlu0JNErC/JPqoz+RtN5IjkjTcbUV/iE0Ayf7gYmQGi78OcSMAZlFYWnzBtDUofKen5I9nrj7/TMoTs2pQADF3m303lOLhbVgIpv1wkraKPSLXA+ARhaTQhz1IOg917NBEENZr/7OfZZN3gg==
Received: from BN9PR03CA0864.namprd03.prod.outlook.com (2603:10b6:408:13d::29)
 by BL0PR12MB2449.namprd12.prod.outlook.com (2603:10b6:207:40::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Sun, 8 May
 2022 09:10:04 +0000
Received: from BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13d:cafe::bd) by BN9PR03CA0864.outlook.office365.com
 (2603:10b6:408:13d::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24 via Frontend
 Transport; Sun, 8 May 2022 09:10:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT062.mail.protection.outlook.com (10.13.177.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 09:10:04 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 8 May
 2022 09:10:03 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 8 May 2022
 02:10:03 -0700
Received: from nps-server-31.mtl.labs.mlnx (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Sun, 8 May 2022 02:10:00 -0700
From:   Lior Nahmanson <liorna@nvidia.com>
To:     <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>
Subject: [PATCH net-next v1 01/03] net/macsec: Add MACsec skb extension Tx Data path support
Date:   Sun, 8 May 2022 12:09:52 +0300
Message-ID: <20220508090954.10864-2-liorna@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220508090954.10864-1-liorna@nvidia.com>
References: <20220508090954.10864-1-liorna@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8442b82-3fae-4d31-e086-08da30d28a29
X-MS-TrafficTypeDiagnostic: BL0PR12MB2449:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB24496A7B9EAE57B0AF2D006FBFC79@BL0PR12MB2449.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UxK5m/NYxIZs7rB4GP7l+fL51hU8wUpUwEJntDS9bFtfn6Ek+bUUZCGuna1qH4BBiBGfZuKyqc3cN8C+LeEO1YYvvleRkmY0fTz4NJ3F71hdvfyMYGvqPhYM1V04NiUhGj8axXXZ4RjEfVfyjzJBvT0CNQ7xHX38VdHq8mCf0eH0rTvNFmvfljWtI5X3ntePdv8hCp73LmDJghxbdMpL5bOCWLjeTyIUz59MfvLytoBnYU6rdE7DbCC45WxynjFhf/JnS3WpRWCLPnbJcD2Vl9dKyxmacEBP5Mv6TTVo2L1hhuwSA2dinKwbLtnQJG5FYXscs2ARZZffhhoiWHrt9OK6l/e0NYzza2/CmEF2hJ3BosoAZre5SlqFCmlOhGgH4vnIUMZ/3tezCiZ1y/ZqI+bRTDbzHp+qaPnCDsrZqdfnRJcPT7ZXKFwPTeR7dPHsBskB/enV+w0Y6Pg3PBSL6m6I++XHf4+RqsBtZDY0h9GUgnaPJx6spQkBzkq3VJ0OVie8wUpMCDuMm+aPDSRB4DoMklNVbZC43wKlnZp6OgOe5MXrUF0IcuGIffJptWx6+fkQseirCfmBGnLyLIpMO+NhVU56WlMg7J26xuMbzHr72vb2bL2rc2JJAIdkcDOtj+QOGjohyOpQRZB9QcXnfagNIq2nu9Bkbhd0VsbA0WqIqyHEE0mhJxbh/7zNVcPp7nzoA4HY2kAf6BuYHQFWMA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(2616005)(186003)(47076005)(107886003)(26005)(426003)(86362001)(336012)(1076003)(81166007)(356005)(40460700003)(82310400005)(508600001)(36860700001)(316002)(54906003)(110136005)(83380400001)(36756003)(8676002)(8936002)(2906002)(70206006)(70586007)(5660300002)(6666004)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 09:10:04.3893
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8442b82-3fae-4d31-e086-08da30d28a29
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2449
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the current MACsec offload implementation, MACsec interfaces are
sharing the same MAC address of their parent interface by default.
Therefore, HW can't distinguish if a packet was sent from MACsec
interface and need to be offloaded or not.
Also, it can't distinguish from which MACsec interface it was sent in
case there are multiple MACsec interface with the same MAC address.

Used SKB extension, so SW can mark if a packet is needed to be offloaded
and use the SCI, which is unique value for each MACsec interface,
to notify the HW from which MACsec interface the packet is sent.

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ben Ben-Ishay <benishay@nvidia.com>
---
 drivers/net/Kconfig    | 1 +
 drivers/net/macsec.c   | 5 +++++
 include/linux/skbuff.h | 3 +++
 include/net/macsec.h   | 6 ++++++
 net/core/skbuff.c      | 7 +++++++
 5 files changed, 22 insertions(+)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index b2a4f998c180..6c9a950b7010 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -313,6 +313,7 @@ config MACSEC
 	select CRYPTO_AES
 	select CRYPTO_GCM
 	select GRO_CELLS
+	select SKB_EXTENSIONS
 	help
 	   MACsec is an encryption standard for Ethernet.
 
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 832f09ac075e..0960339e2442 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3377,6 +3377,11 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
 	int ret, len;
 
 	if (macsec_is_offloaded(netdev_priv(dev))) {
+		struct macsec_ext *secext = skb_ext_add(skb, SKB_EXT_MACSEC);
+
+		secext->sci = secy->sci;
+		secext->offloaded = true;
+
 		skb->dev = macsec->real_dev;
 		return dev_queue_xmit(skb);
 	}
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 84d78df60453..4ee71c7848bf 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4552,6 +4552,9 @@ enum skb_ext_id {
 #endif
 #if IS_ENABLED(CONFIG_MCTP_FLOWS)
 	SKB_EXT_MCTP,
+#endif
+#if IS_ENABLED(CONFIG_MACSEC)
+	SKB_EXT_MACSEC,
 #endif
 	SKB_EXT_NUM, /* must be last */
 };
diff --git a/include/net/macsec.h b/include/net/macsec.h
index d6fa6b97f6ef..fcbca963c04d 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -20,6 +20,12 @@
 typedef u64 __bitwise sci_t;
 typedef u32 __bitwise ssci_t;
 
+/* MACsec sk_buff extension data */
+struct macsec_ext {
+	sci_t sci;
+	bool offloaded;
+};
+
 typedef union salt {
 	struct {
 		u32 ssci;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 30b523fa4ad2..7483f45a6a83 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -72,6 +72,7 @@
 #include <net/mptcp.h>
 #include <net/mctp.h>
 #include <net/page_pool.h>
+#include <net/macsec.h>
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -4345,6 +4346,9 @@ static const u8 skb_ext_type_len[] = {
 #if IS_ENABLED(CONFIG_MCTP_FLOWS)
 	[SKB_EXT_MCTP] = SKB_EXT_CHUNKSIZEOF(struct mctp_flow),
 #endif
+#if IS_ENABLED(CONFIG_MACSEC)
+	[SKB_EXT_MACSEC] = SKB_EXT_CHUNKSIZEOF(struct macsec_ext),
+#endif
 };
 
 static __always_inline unsigned int skb_ext_total_length(void)
@@ -4364,6 +4368,9 @@ static __always_inline unsigned int skb_ext_total_length(void)
 #endif
 #if IS_ENABLED(CONFIG_MCTP_FLOWS)
 		skb_ext_type_len[SKB_EXT_MCTP] +
+#endif
+#if IS_ENABLED(CONFIG_MACSEC)
+		skb_ext_type_len[SKB_EXT_MACSEC] +
 #endif
 		0;
 }
-- 
2.25.4

