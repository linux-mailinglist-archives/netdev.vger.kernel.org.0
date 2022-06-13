Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CDD54966F
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358914AbiFMNMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 09:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359277AbiFMNJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 09:09:45 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCDE222B7
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 04:19:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lGmxCP2xnNvhvu30/LXdZGR16Nt6JrgZHm+pPQC5McqoXGdCPeHFtoC8d7kxNbeIrC9ducXWQeyke/gqwoZcLf6JxuM4wx8SSg4dNK4jpvzmt68rWq2lBeIQGyz9DYGlKwDJ5lpSx3xsu6S5bDbJc259GF8n4UCnDgpuXBXJpykPDhBFT0Jh32dk1rNDE7DlEpaEiqKeg03keUAODlSVj9L2Zhx4HGJHoCPOFd8vJ8i27w/LR/9EHm+50+HHcSHM9TaATHhhd2E45p/e0I9eVNNKwo45mB8o5Hqfnevxw6qb9DdyeCWlYlmQvZx0zcccT+EGo8dQ4YM0/lgsHX9kEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P263HxrgEk4c3V7RG5ghsB8uT57npQy/5wllDCjK+Ws=;
 b=Qik02KjtDmosgvg46kPXReC8IEq49Jy2th/NphBUDxSHgkJjaPSKjMsN/ujOn92F9EX1bGCtgjSngSJ/pL39hrbFOLtOH5MTaVjx2xQjCGDcqWppbw8oPu9us6xVftbGqOsCaKBD2nnaQUjTA+xKtkPmeiS8cK1ux8kww4sIJBpYH38EpI105AFqDY1Al4qIh78e4OIZsW1N9m3NqEVht5HKjrdQlX64jDdHibfcNHjAJGpU6TbvrhNR7YYpL3T46GlhW0N+e2835p278ab+O/kSkC1VV/gtE89DaUKf37QDRPcHLgoo98Kq1XirCbddIUab32M6bUiQR+Eg3euE9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P263HxrgEk4c3V7RG5ghsB8uT57npQy/5wllDCjK+Ws=;
 b=WngtqTHKAmmoJxNILgS+Xm9lzciHL0HBAQKVVljLOJ0DOs3aYFRPrRSmHNawcXs5XQSfMf2daiurjp6fhJQQrahTmjOexrYYa+qJJRdQeDBNs2ylPLCLhCDdlLFNDg30OEFuTGSUuRv4CzqGDkbkfu3k5/qfsMesY6Zz6hv+lkW6HuyFL0bXkBnhmHGPdhA/yy6yaE7LKhwDwfqwGJRHDH1YEBUF+RkOb7Y26FUWTCjxTc7K3XjyiHMTMOhCkshSL6iFSkECctnnSFvFpn9PHnT/rxCUkHQQg9oa3EIU8m1wU2DV6rGdIqDayi0/VhcEF37IfE1werBCAViMIv1YMQ==
Received: from DM5PR11CA0002.namprd11.prod.outlook.com (2603:10b6:3:115::12)
 by BN6PR12MB1122.namprd12.prod.outlook.com (2603:10b6:404:20::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Mon, 13 Jun
 2022 11:19:51 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:115:cafe::ef) by DM5PR11CA0002.outlook.office365.com
 (2603:10b6:3:115::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13 via Frontend
 Transport; Mon, 13 Jun 2022 11:19:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Mon, 13 Jun 2022 11:19:50 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 13 Jun
 2022 11:19:50 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 13 Jun
 2022 04:19:49 -0700
Received: from nps-server-31.mtl.labs.mlnx (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 13 Jun 2022 04:19:46 -0700
From:   Lior Nahmanson <liorna@nvidia.com>
To:     <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>
Subject: [PATCH net-next v3 1/3] net/macsec: Add MACsec skb extension Tx Data path support
Date:   Mon, 13 Jun 2022 14:19:40 +0300
Message-ID: <20220613111942.12726-2-liorna@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220613111942.12726-1-liorna@nvidia.com>
References: <20220613111942.12726-1-liorna@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7df476d1-98f1-4cff-f832-08da4d2ea20e
X-MS-TrafficTypeDiagnostic: BN6PR12MB1122:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1122810C4D57D66BA4F69D78BFAB9@BN6PR12MB1122.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: unFYsvbGauKI+STN3ohOut2RDqWAhm8lad9uH8j0pfgMTeFQ9cw5eB+JKf01dqzSNpPOOSjMpJef+/nE/kzZqnbhs5sLrWqst014n9CQZXvBMASclQdmt4Jl+b2iMl9ei2nXUzyZDtZ5pbQFaid/X5U+rOjYlw7AvQLFXRxuZG8DLGMIp/C9tz/4qnsPffUrQBv27pZ7eN514mFMBxhRV+0XoqEZPjqP8yhIl1V8RhtaA+GMMcoXKMmBZD6ij+ykusP0XbQWnUSLTCY3skOsyIvRDD+yxI4jZokuf13h5WV5k/+pPvYOmoRBGOXO4Nl2xbhaoN/t5xWReVOeC0sDTEVDXSzGeKD5R2lREPc6r7ja9ZbW7ffTwCqU6+dvpvkkZ/SpeoAqVR4MXgGuzoWTpAz4Z1buoT/anyuqtsAHZaDLF44BThOli6LYQO2uPwSbpd6qMVk3eS4/JXUwd+EetykatdYTdfkUOzHjBK8TtiT1ZWdyWqzNSLyAe0sxeo3UtTe4FJQcnu049ymo08hG32f4ZuPuJ9W22mfBFUL6e6DycgDEQm4TsNgMfK0xNjyK1RjTdj74tH+UfbK2v6JEgyhN8yMC1u0Qt69GI1roC2rgHd2McwTDD1bp0JiD8F9h/vRPnn1avM5wF6SM55RtTw4ZMX4Tyeblwmp5EvD73zBYm1PH2vl6h91nYvKeogqOF80becd6AsZ5ZEavU1BHuw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(46966006)(36840700001)(40470700004)(2906002)(36860700001)(8676002)(4326008)(8936002)(356005)(81166007)(70586007)(70206006)(54906003)(5660300002)(110136005)(47076005)(6666004)(83380400001)(316002)(82310400005)(86362001)(508600001)(2616005)(1076003)(426003)(107886003)(186003)(26005)(40460700003)(336012)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 11:19:50.7977
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7df476d1-98f1-4cff-f832-08da4d2ea20e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1122
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
v1->v2:
- removed offloaded field from struct macsec_ext
v2->v3:
- removed Issue and Change-Id from commit message
---
 drivers/net/Kconfig    | 1 +
 drivers/net/macsec.c   | 4 ++++
 include/linux/skbuff.h | 3 +++
 include/net/macsec.h   | 5 +++++
 net/core/skbuff.c      | 7 +++++++
 5 files changed, 20 insertions(+)

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
index c881e1bf6f6e..9be0606d70da 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3379,6 +3379,10 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
 	int ret, len;
 
 	if (macsec_is_offloaded(netdev_priv(dev))) {
+		struct macsec_ext *secext = skb_ext_add(skb, SKB_EXT_MACSEC);
+
+		secext->sci = secy->sci;
+
 		skb->dev = macsec->real_dev;
 		return dev_queue_xmit(skb);
 	}
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 82edf0359ab3..350693a787ca 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4495,6 +4495,9 @@ enum skb_ext_id {
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
index d6fa6b97f6ef..6de49d9c98bc 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -20,6 +20,11 @@
 typedef u64 __bitwise sci_t;
 typedef u32 __bitwise ssci_t;
 
+/* MACsec sk_buff extension data */
+struct macsec_ext {
+	sci_t sci;
+};
+
 typedef union salt {
 	struct {
 		u32 ssci;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index fec75f8bf1f4..640823b5bd2f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -72,6 +72,7 @@
 #include <net/mptcp.h>
 #include <net/mctp.h>
 #include <net/page_pool.h>
+#include <net/macsec.h>
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -4346,6 +4347,9 @@ static const u8 skb_ext_type_len[] = {
 #if IS_ENABLED(CONFIG_MCTP_FLOWS)
 	[SKB_EXT_MCTP] = SKB_EXT_CHUNKSIZEOF(struct mctp_flow),
 #endif
+#if IS_ENABLED(CONFIG_MACSEC)
+	[SKB_EXT_MACSEC] = SKB_EXT_CHUNKSIZEOF(struct macsec_ext),
+#endif
 };
 
 static __always_inline unsigned int skb_ext_total_length(void)
@@ -4365,6 +4369,9 @@ static __always_inline unsigned int skb_ext_total_length(void)
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

