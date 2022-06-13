Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D526F549072
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351950AbiFMMk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 08:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358822AbiFMMkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 08:40:35 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2045.outbound.protection.outlook.com [40.107.94.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A6D5F8D3
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 04:10:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oEIW3dSRt8/l2LFvZzLPyKpfZI8wWeZ32SpTEc4TFVV6XY0SPO6oMVdsDfz7pX5fB3qAYsClwiuEqXmrw1HV6zr3XLWJe6887jMzQiJ4jYwQnVtw/8rXbHtGwSOHTSQvAuWlQr8NZy831dbzvmLzB/FO70E1g5DnWZYi0I82YxF38YqtBNrhVLuYpZ4BmiErOqGJd0rsYNWUqiYvpqWRwqfdJWFu8WFv7WjUOOkv4P975pf/6JJZPnI5XltQDXHU0IAlbe1GD+4gHXTbkLjmUbkxd53GoTWnfA3j5f0jE5RXCPVk512jtZ5mGWDECx+KmbKhb6STp9JDLf70WNuSpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4K7dZMgap2tsb44Aebo2Oue3butNHsBstzcZg/wItLs=;
 b=NoNaOgasrRwu4WXSGRdgu54iU1u3dH31bnBDJe0V03pmuiPGOCkTfyEtv7Zr/2yZaJrEGaPNF9H3VppVAoXPCnrXoZrOYIkeuJ5vGKK2NMvS8ME+jwQGvqD1R8hwfCnV/Shl1mfD34Jp5IH2OGVlf27BNk4twGFFD2hwU4lakCunBQDiuxqQd2ioB3tHJCRw9NO980eMyrad/gICfX/bUNvLa32JMBW3Afbv/QCQXdXtwpvEElgnEZeJQvDxT9rBNpIBqD0cffQd5KLDZgRH2CvxLMOtXrywbPeYMTHCDRxIljNk9h/6EnGHhCfxdHA1QNM+pU1KX6B6dok5Tk37sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4K7dZMgap2tsb44Aebo2Oue3butNHsBstzcZg/wItLs=;
 b=ABbPT+ru+zH3JDuEsSnqkG7psIHGf/tVtHzE3PFcs+nH/RtbGtUv97PRxYYplYZSnfwP5EPy0TzxYy3PhU2ScKlBTh6t3mQrYbZwRrBbVZuqTLd1PlHpdXxZbeQjHeu04P+F+yPItDxe06LjWBRxG6wJB5HS8sxf809uWRwO+4xekX7NL53sTFUxIksa4Nf+enDHq/wuccXLwX0prjfRoEb9IO9JyEGiH3UU7pNElM3fmUnS9lPKAmIQ0j6S7Bs8jxhlrsx1Y/ytpQOahgS8gz4/B8ZLiQvP+UEmI1dN2xeX5m/k/HjBdBnHnP3mGfWWwtZU2vb27YY2cX7gqjRToQ==
Received: from DM5PR21CA0065.namprd21.prod.outlook.com (2603:10b6:3:129::27)
 by MWHPR1201MB0175.namprd12.prod.outlook.com (2603:10b6:301:50::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Mon, 13 Jun
 2022 11:10:23 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:129:cafe::cf) by DM5PR21CA0065.outlook.office365.com
 (2603:10b6:3:129::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.6 via Frontend
 Transport; Mon, 13 Jun 2022 11:10:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Mon, 13 Jun 2022 11:10:22 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 13 Jun
 2022 11:09:54 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 13 Jun
 2022 04:09:53 -0700
Received: from nps-server-31.mtl.labs.mlnx (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 13 Jun 2022 04:09:51 -0700
From:   Lior Nahmanson <liorna@nvidia.com>
To:     <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>
Subject: [PATCH net-next v2 1/3] net/macsec: Add MACsec skb extension Tx Data path support
Date:   Mon, 13 Jun 2022 14:09:43 +0300
Message-ID: <20220613110945.7598-2-liorna@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220613110945.7598-1-liorna@nvidia.com>
References: <20220613110945.7598-1-liorna@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f07e1935-74ee-4595-41f8-08da4d2d4f96
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0175:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0175CF04B72B6CD32C79F7E1BFAB9@MWHPR1201MB0175.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xbmmxn+/CeXNH7ZbGZzwioWE7Nu/5h2ZmhH8uMt1V+z/P4HWm88FjukCAMwu7AIOLk4mxPlJDzdytAY4/5rlQJ4L72uphvP1sw3XkbNf7tHxOAQ9J7aL3YMz0+NGBZMEmiFyk0cGpB1eSpjhWPqqA9ExqZ5ZVRJoOkKzr4sIu0vIQK/jjevObTUaB16hYqcShcImnuXaqkojoCzpdXI2xkOMg2kqoDbrpceVLLhxUn1sJCexaP4YOLDbxOrOLSl7tjjDq1+uxojZU/9K3WyNmyChvHq7oZazeRj6Awk/PXhCKCsolk2Lrlb/xYTWnpSl2+H3QXkVaIA0JCoyxaJs03tqhjHGUONfKhiszelHW0+wjraECMDGz++Q5zqu1KCKMO2dYoe96Ix2+fl+8zwneT+nsjEbkve/g+b4MFcW1BKqANTQXGmW9eZi13EiHEeO3U+Z18CE6Q8uZ0KaB8qnW7kDhwuQzydg2qWNBNMpTo9CvAIj5sEeabXB/AFSH8VgZSaMnNZ2FGivHVEAlJfZQsmioAoAmu+VQU2wZJuqHIPVNnmB+UE+Jq/N8GB7+lJb4ehECbHksc/S2TjuYznMKjLAFbNbqoHVz4fxTOEHO3tbF+DTaJ3CswKhusoCrQ3dTCMCGvcHWQvJ55DoAudOvqtehOWlDMgjxIHWjOM1GGgPIejxGaPc6jrU6GqAzjiMY1K0zqZm2jOkMRguS0jCZQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(40470700004)(46966006)(36840700001)(81166007)(70586007)(356005)(86362001)(8676002)(8936002)(70206006)(4326008)(54906003)(508600001)(110136005)(186003)(2616005)(1076003)(26005)(36860700001)(107886003)(47076005)(6666004)(336012)(316002)(40460700003)(426003)(5660300002)(82310400005)(83380400001)(36756003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 11:10:22.8429
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f07e1935-74ee-4595-41f8-08da4d2d4f96
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0175
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

Issue: 2978949
Change-Id: I3bea59a39c73c3a7175dab078dfa67726c3ce9a6
Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ben Ben-Ishay <benishay@nvidia.com>
---
v1->v2:
- removed offloaded field from struct macsec_ext
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

