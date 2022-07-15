Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F121057698F
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbiGOWFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232251AbiGOWDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:03:46 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70058.outbound.protection.outlook.com [40.107.7.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42514BD1A;
        Fri, 15 Jul 2022 15:01:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ARGKlOlKvSO0vggmPQEEfnC2oM5Q3c5yVHbthFJCOVeo3jc0okxJF14XU5iZVw6P759GTaOLUC0SRGxkaxv47giQvYqODGo3ghHpjARWCva10HfWB3WoOKagJuLPx6s/utp5yazyWVLfbU28i2gMjmwHA70MWjQP+bqko/Um8FLe5f0i4v1YiVjdokEY44F/NzPf3fV/CORP7BDR/Xj7dBgDVcIVy9oTH686MYTXPfm0LS7h/dCjTc8wG/13X5shMEEE/TUdWWr/S9q1Gj9hMgDJN6f5cYXYcjSYFSn8838Tq4eZOkhKUxNFJTY+90yrvo2nNs9Cj/yDyyNLCpSG8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GCnkFbU0TAj16icomPgcXktaEQeVtiaAjBFYiBXhIY4=;
 b=gy+G7aIOexnC8fByjTuEZcHOioxyvqsdYx3Obpl7yTmW9AzEpDXY/DlbKmjLMk4q3ILPi0x+QNYOjZZL/EV6K/ZqEL/xwj4kqlJ1E1c7ZMSR+UNGS3GKyzjgWzcGLCYYnXkzgM5VPsuhB3vLvsGo5msbRQvGVCZ8reRw3WqQW42yoEEXjALGg+UflMmIFFtuCl6rM+UDFXFnVNEdJry3MReuIUEiIfludvXYngIjSRPZr3Vox8+wIkYyPpJg3UgZ0OUEYgiemgm7j31Pr3rUt3Yo0Uey+te61bwqBeyszKM8++LmlgO0VRQSnR5/C/FbM5gMXKhJ3H13FTlCqGoUFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GCnkFbU0TAj16icomPgcXktaEQeVtiaAjBFYiBXhIY4=;
 b=cY2ff8coSdCXGDYoeaJIRQTCWKAH+k9WeumqqfjISLTdVYalz21ZGXtVomtTwcj1l1BGFUT2bwHiFkTWlspykPm+bxGOchJPIgYfWEWDVYta0rMpdpLiwVC0ycf6aLdpilJ89LEf0zCi2ivLhOkltyN2XL3rspG7XQ4+JFm9/m0JYfVSVCmn1KdBjMtYvGuPlKaRn/5yxbvLyD1FGVjDRbdJbi4TG/q8/WbmT/9UeizYNPVoAf4KswjWVyYO21PinCBRNsWn7oVwYWsX1N2HaM1B8DVDZHEXcX2NCl4QkU7Q7kU2ChwR9jxKSdnAxKwS7wHhvAoR5v8m7U4oN63jpg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DB6PR03MB2902.eurprd03.prod.outlook.com (2603:10a6:6:34::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Fri, 15 Jul
 2022 22:01:25 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:25 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v3 32/47] net: fman: Specify type of mac_dev for exception_cb
Date:   Fri, 15 Jul 2022 17:59:39 -0400
Message-Id: <20220715215954.1449214-33-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 443fd466-fd3b-4e67-5c55-08da66ad8fb4
X-MS-TrafficTypeDiagnostic: DB6PR03MB2902:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zi0E5cBd8R8pmHB3ZZaoFdUmO1gPP8WxhYj64P2GukOw5if2lYUK2akcN9bCc6StgjUQUJriOMNMfwBPC6viql0GnCql1KIWoIiONE2ASBbEle0LIlOUhTDfc6lBMpyn+NgdMRvxnwE09AHMvLYxxacZyhIM/4MCy1pjgpcdp/swr4Arvw2wNdlSAqf7r0cZjuAwvn/iE+Ph7Ad0jDLzBO54SK//0j53NLgONI4azUyvZaP0yWsDkDBc1chPXRklm+pxTPUoB7z+uMGNdWjh4L3ZYevSTLl7QA1x2Bbf9q3aOmOYRBH2rwkMg8rbXxH4Te74vxVTl1Xmz/6DRgGrEYmSCreJyzE1cyf2KUflPS3SpAdJpnwIjS01iX3K+OPl6WIqHBpDcrl+fd/q1jjjequ5eFPbGdzzW7E7dY3AvoHS/IpeSl3q6N48RVYIXjJDAxf4Soo5Q4eeY3l1+aEHpvBL/coXQHii13SQ7C6NwhUqXLZ+ayqXnBin4xWHv5hZo774HjvIXOAFy/L4BUmOPWfky0uJG9MiJtONiWLKvYFZdPTsunZZwK3GJ/RqDNVFsCuQaOVhbgpub/wh0jcX9O8AjGabdSGlaec8s2G+GzXaudfuwL/b0IVzZ89JyKKwm9DeWfmaKWNg5DcfmKwrtV9/H9+306zDtDn5SJJwgOjjRtLVf44xkm3NCLfHi83VRCZm+ZnjRGmgFtO6GBCRvj8FUAeu+8Df6TIYJNaKBn0nCRpGjNSsVfDEO14PBxq5oXQU4RFoVNrnklB6IdmSG9x/PVZZeXTfFQSPY611cxyF7b0WO1hjTUUmsQh1T0A8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(39840400004)(136003)(376002)(396003)(86362001)(5660300002)(83380400001)(6512007)(1076003)(107886003)(38350700002)(38100700002)(186003)(2616005)(36756003)(26005)(6486002)(52116002)(316002)(41300700001)(6666004)(478600001)(6506007)(110136005)(54906003)(2906002)(8676002)(66946007)(66476007)(66556008)(44832011)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ah9B7cwfqwMre55+ElsGIWVYuNiQXUlocxc8Rem8M74/dcSa4Fek8L15l/xV?=
 =?us-ascii?Q?/2Kaz+HPf/w3DP+IOO1M9PoFCd7efygBmaZOETdefsI4xDrsyw9UJY6Sc5hl?=
 =?us-ascii?Q?pvAABOc6F9kleuRBbXN6y0kKwc+YC9cOWVStMdkxUJ18LlU8uH4EpLVpAeOF?=
 =?us-ascii?Q?QiqjqZ4kyHVTZbkYRKdPKjUsMZlRVWx8EpE0MLRnXh4ou0FicKr3yTpnnp4H?=
 =?us-ascii?Q?w4ocBzB95mhcxO4D00D9s7gj0+LA74+FurqaWtz7xo+IxlO41UJN6aa4AHZp?=
 =?us-ascii?Q?Sj9sguf4Ni0sRb1hZyZyGSD96yeZ9XpjbDJWLHvAexTGcUsrLhtac++uC4fn?=
 =?us-ascii?Q?c4yC4OriLgMZqYPF6GgIgt0vvHJQI7cpJaubpDM858ee32WXch5Sh8QYSpPJ?=
 =?us-ascii?Q?DGeP+l8QxXoeS3ZxW0Zt2l5exARTPOTbMkCd/FddT0NRZBn1n/Yph2/NM0Sc?=
 =?us-ascii?Q?nAV3jA+FyPZEHvcYE92hzVY/IBECSC3xFkPpM7iG7pftlGeXE+JNEEvgqOhs?=
 =?us-ascii?Q?wUQp+MXbCaG+zpoDv4dXosgxdSLRU/90pfrrorVQP+eaLqlwtffgVC15pm5Y?=
 =?us-ascii?Q?LClxepV8TzDaWPZ6A8wyqgJ+zMDMGKY1zCgm2GVeoNNavzsIrPSQYNH/fRNW?=
 =?us-ascii?Q?1oEsU3A43mCB6g5r8w5r9pW2Sls3EXItzqtcvSaxomuTgdkEMI9Nrh7PmvDd?=
 =?us-ascii?Q?A/FbITxW7IHbzyGgLFL5KcD/dIbQbzfgCiEWlw2PaEzmUmUIVCSoEUIvqZnO?=
 =?us-ascii?Q?vaYOwnalz7dY2TUTfX4hy1mbLT/oWxuLonM1ppaKG1duENC3QrCsH3R83m8c?=
 =?us-ascii?Q?7Dbh/++fcvgGLrDJMzcn0Y3sGBfJnNoSsMc5GBYxozcMocnH6J46+S7BHIcp?=
 =?us-ascii?Q?7jJsv7Df/8gjhfTi8XYphbWIF1dSnhWZCGHnp0Pxzku4YaXLiKnhPqJb2ZIF?=
 =?us-ascii?Q?0SO3TGOKTbH/Rn+enPNGaDbnHKAzMnEZTku3MSlVIOqHh86k2zdznfnHMWt3?=
 =?us-ascii?Q?j7Bn7viEyp1Xd3Dc967kNzNe/8SpmBg2Jgf6bNcoyTlmh8uLAT3/TK2eINI+?=
 =?us-ascii?Q?nWkopXZ7DkkSkTEtvf82TOCZ7jd6WEFVeeOMJ3WCn+1yH8O/LBzpOscaLnOb?=
 =?us-ascii?Q?pWT127os3H1FH2O73UyjQ8dmPCo535qcM+VCG8dMS7FQLlRq+vxcg9CoDMRA?=
 =?us-ascii?Q?ASZaPYdOiCINeXsfaGRIMJZN1kWCVDuKZRDzsiEHyzGscohlmb5rA5fcSclq?=
 =?us-ascii?Q?o+xXCrvxxWYMwgdZgvRlf1lN3ZbFdNwEl6y4xfv89uMFOvoVvj9D4S1s9jD8?=
 =?us-ascii?Q?cfa3SXKq9siM1OsW3sGSBSvvlxbiDvDntT7UUocYpsWLbwhvXfPGcnkvCw6t?=
 =?us-ascii?Q?YRdpCWlIYMLnsq2UJvbY5wNmaQEIGn1rC9bRXxG9K4YHOxOgO3XgC/z1f3Ca?=
 =?us-ascii?Q?+RZmG0TNq7KZsiBuekDwOC8mytHkXwcEVXb77yMSBWmXuVLUX8nmK/lOXaWV?=
 =?us-ascii?Q?aj1DFPnODSaL/fG1AekNeJtByV8UVNLQBca7h1CBWHMjgPMMAl4zoxLdVxeU?=
 =?us-ascii?Q?2pGBwLYeNAEdD/Hc1Y673l/6jmawuJqt0FM6VjYdQ42ziqWZR57mhfJZqQvf?=
 =?us-ascii?Q?Xw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 443fd466-fd3b-4e67-5c55-08da66ad8fb4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:25.3933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2QnK95Cb5Af4zr1KLS6ELQPTGSkOYcHL8xtOTT4JH4s95Huc+ilQBvCdgJ/bpM7XCKLHekuwOY2TGd2W7E91BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB2902
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using a void pointer for mac_dev, specify its type
explicitly.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v2)

Changes in v2:
- New

 drivers/net/ethernet/freescale/fman/fman_dtsec.c | 2 +-
 drivers/net/ethernet/freescale/fman/fman_mac.h   | 5 +++--
 drivers/net/ethernet/freescale/fman/fman_memac.c | 2 +-
 drivers/net/ethernet/freescale/fman/fman_tgec.c  | 2 +-
 drivers/net/ethernet/freescale/fman/mac.c        | 5 ++---
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 09ad1117005a..7acd57424034 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -301,7 +301,7 @@ struct fman_mac {
 	/* Ethernet physical interface */
 	phy_interface_t phy_if;
 	u16 max_speed;
-	void *dev_id; /* device cookie used by the exception cbs */
+	struct mac_device *dev_id; /* device cookie used by the exception cbs */
 	fman_mac_exception_cb *exception_cb;
 	fman_mac_exception_cb *event_cb;
 	/* Number of individual addresses in registers for this station */
diff --git a/drivers/net/ethernet/freescale/fman/fman_mac.h b/drivers/net/ethernet/freescale/fman/fman_mac.h
index 730aae7fed13..65887a3160d7 100644
--- a/drivers/net/ethernet/freescale/fman/fman_mac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_mac.h
@@ -41,6 +41,7 @@
 #include <linux/if_ether.h>
 
 struct fman_mac;
+struct mac_device;
 
 /* Ethernet Address */
 typedef u8 enet_addr_t[ETH_ALEN];
@@ -158,8 +159,8 @@ struct eth_hash_entry {
 	struct list_head node;
 };
 
-typedef void (fman_mac_exception_cb)(void *dev_id,
-				    enum fman_mac_exceptions exceptions);
+typedef void (fman_mac_exception_cb)(struct mac_device *dev_id,
+				     enum fman_mac_exceptions exceptions);
 
 /* FMan MAC config input */
 struct fman_mac_params {
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 2f3050df5ab9..19619af99f9c 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -311,7 +311,7 @@ struct fman_mac {
 	/* Ethernet physical interface */
 	phy_interface_t phy_if;
 	u16 max_speed;
-	void *dev_id; /* device cookie used by the exception cbs */
+	struct mac_device *dev_id; /* device cookie used by the exception cbs */
 	fman_mac_exception_cb *exception_cb;
 	fman_mac_exception_cb *event_cb;
 	/* Pointer to driver's global address hash table  */
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index 2642a4c27292..010c0e0b57d7 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -180,7 +180,7 @@ struct fman_mac {
 	/* MAC address of device; */
 	u64 addr;
 	u16 max_speed;
-	void *dev_id; /* device cookie used by the exception cbs */
+	struct mac_device *dev_id; /* device cookie used by the exception cbs */
 	fman_mac_exception_cb *exception_cb;
 	fman_mac_exception_cb *event_cb;
 	/* pointer to driver's global address hash table  */
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 0f9e3e9e60c6..66a3742a862b 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -41,10 +41,9 @@ struct mac_address {
 	struct list_head list;
 };
 
-static void mac_exception(void *handle, enum fman_mac_exceptions ex)
+static void mac_exception(struct mac_device *mac_dev,
+			  enum fman_mac_exceptions ex)
 {
-	struct mac_device *mac_dev = handle;
-
 	if (ex == FM_MAC_EX_10G_RX_FIFO_OVFL) {
 		/* don't flag RX FIFO after the first */
 		mac_dev->set_exception(mac_dev->fman_mac,
-- 
2.35.1.1320.gc452695387.dirty

