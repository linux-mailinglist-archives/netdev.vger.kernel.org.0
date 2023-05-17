Return-Path: <netdev+bounces-3441-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B238A7071FF
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:24:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 641782815DC
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47B4F31F17;
	Wed, 17 May 2023 19:23:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355A8449B5
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 19:23:15 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2104.outbound.protection.outlook.com [40.107.21.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6408A2119;
	Wed, 17 May 2023 12:23:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H/o5uUR4LtySj1hqHfeaZCxOJmP3RlXGTdq72fCqfRtioLl4ABuaxiPqV3h4JuQoJcg353Jv7fTxlzS6ooJraDLnWzdQb3EO070yMqSpQaYybe1SF9Nus6XjairQNpsHsE6BuA1Mvz2S42FnICcxl4vqmj4IKBMMCWzpagwAtJON2+0BpxpnDXhBPqwgOTp57KD2ZXnJAV5/yzxPR0578oNA2pTxOcAI9AzCu42w9rFi8wq9NSFhS+QH7LOZUU1pgTawCqAf86x8lrdWdSugKckdHPHeHDOTjJHQJZC0fr4LI5WvwJcqHpps9zLuhg5GtiZmL6Wx+Lx/LFmjY98uEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9mzkXC7OnBgzvVyTbbnxcK11B2UZs1EiM9aJqS0nfAg=;
 b=iieDzUL6I2pKm3oFho/lbRO0LffNcUFSdaPcLpJZEqC2PWSOirOdW2HcnT9/Vqa4z9fQTI82knu2O7+qqOe140FZ4PipijtClOR4t+y0elqBLs4jVbbeguj48Ly5jM/WB6TAgEi+DZrjVgxHZNbkSZgkkRVyNgVW+XYTxO7fgPxlEAY7nDdd9LESORXR5c7PgPgHa9TwVZMrx8jj20dGUJYw+zloeN8oKZESI3hWepHO4BCEnXXartdCqk9PmFXw0qU7/kDsZgY9GA4rvf0p0fhCSqQlHRbKnKCShashr7rojJJY6XyhfT+hVNR/RFuZzwQ+5puR/F/HANvk8BHZ7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9mzkXC7OnBgzvVyTbbnxcK11B2UZs1EiM9aJqS0nfAg=;
 b=DJ/To+S6eNl9Uyf2UpgYlNF50v+SyO6lNfSFdunDY9Y7SF1Ig6KnXwNCFPaiuNX64iZLom2S/QvWnntRkBa5GJn3Q9L/DTXoSmofuOugTWLWlVFzbV+t2TDsiRYaeQa5lz8IJmRcZ4d1IOYOiEewPzlLIdxuI8T4swkG3JxeRno=
Received: from DUZPR01CA0011.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::19) by DU0PR03MB9055.eurprd03.prod.outlook.com
 (2603:10a6:10:47f::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Wed, 17 May
 2023 19:22:56 +0000
Received: from DB8EUR06FT027.eop-eur06.prod.protection.outlook.com
 (2603:10a6:10:3c3:cafe::e7) by DUZPR01CA0011.outlook.office365.com
 (2603:10a6:10:3c3::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33 via Frontend
 Transport; Wed, 17 May 2023 19:22:56 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 DB8EUR06FT027.mail.protection.outlook.com (10.233.253.49) with Microsoft SMTP
 Server id 15.20.6411.17 via Frontend Transport; Wed, 17 May 2023 19:22:56
 +0000
Received: from esd-s20.esd.local (jenkins.esd.local [10.0.0.190])
	by esd-s7.esd (Postfix) with ESMTPS id DF0437C16CA;
	Wed, 17 May 2023 21:22:55 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
	id D720C2E1805; Wed, 17 May 2023 21:22:55 +0200 (CEST)
From: Frank Jungclaus <frank.jungclaus@esd.eu>
To: linux-can@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 3/6] can: esd_usb: Use consistent prefixes for macros
Date: Wed, 17 May 2023 21:22:48 +0200
Message-Id: <20230517192251.2405290-4-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230517192251.2405290-1-frank.jungclaus@esd.eu>
References: <20230517192251.2405290-1-frank.jungclaus@esd.eu>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8EUR06FT027:EE_|DU0PR03MB9055:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: b99daa0b-69f4-4f1d-3298-08db570c1e7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dHphiIcizK0Kbo3hQGIN2V7EMqNQcnjGFvbDLZtA1bqQbsbD35Q0/TFinWuB5+givlZzqh2NDnYcWtVDGfBt9EuMoRbL3Uf9y0fJB8dBR7EmVQ8hFemoaZb27bzV2vZordPioA7Cf+xzBOo4MuiSEjqPZSLqSwMO0kaptsuYShklga8Mm1LUEt6YYrQklREBnXni/6JrYqW6JlhA4NYPrrKU/1ZVPdc4A4M8UF2/tq2+8TxkkiAhed6gPI7JOOnayBX6xoXBl1BIH3IvT8nYD3uDuBjvtvlsG70lL8wssI32oTUNnTpzOxwDZA+eEuCCyy8uSyx8mtQzZP6xDXlZOhvz0McqsG8SuuoaKtAh/IgEBFymzazLCPmNoEsF1QbxpHQmJ0EsKK/+qhqrbbr54uAkWWnS3gR+dwj48iRUypC4eGpgHlpYG/6SiWgSnD4cmUWH4A5IRdhtpbY5R1GNK5ndlJlenXFPLBNdeKCl9drkCDUUReN8YLLINHSw1FHMO/Vo9AZyMVeaxWxCrr3cWvsxtijM3fV91sBifOqc70nGy6NbEDpD8wQtihkYqeMyw+FbhVK/sYy39WFB0qMaTDwGSgEPA2Sl2yWtThdjuscfDnwmgWurBGEge46FNLv87r78CC/rYwD4dSD4TJCuUkMlvK9NdoSe2rcLP+CUB3M0afTidVsQGCLKLIlKDgXS
X-Forefront-Antispam-Report:
	CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(39840400004)(346002)(451199021)(46966006)(36840700001)(83380400001)(6266002)(47076005)(478600001)(26005)(1076003)(2616005)(66574015)(336012)(186003)(966005)(36860700001)(356005)(81166007)(8676002)(8936002)(82310400005)(2906002)(41300700001)(36756003)(4326008)(316002)(40480700001)(6666004)(86362001)(42186006)(110136005)(44832011)(30864003)(70206006)(5660300002)(54906003)(70586007);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 19:22:56.4708
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b99daa0b-69f4-4f1d-3298-08db570c1e7d
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource:
	DB8EUR06FT027.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB9055
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Initiated by a comment from Vincent Mailhol add the consistent prefix
ESD_USB_ to all macros defined within esd_usb.c.

For macros specific to esd CAN-USB/2 use ESD_USB_2_ as prefix.
For macros specific to esd CAN-USB/Micro use ESD_USB_M_ as prefix.

Link: https://lore.kernel.org/all/CAMZ6RqLaDNy-fZ2G0+QMhUEckkXLL+ZyELVSDFmqpd++aBzZQg@mail.gmail.com/
Suggested-by: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 198 +++++++++++++++++-----------------
 1 file changed, 99 insertions(+), 99 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 194aa1cf37b5..23a568bfcdc2 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -23,33 +23,33 @@ MODULE_DESCRIPTION("CAN driver for esd electronics gmbh CAN-USB/2 and CAN-USB/Mi
 MODULE_LICENSE("GPL v2");
 
 /* USB vendor and product ID */
-#define USB_ESDGMBH_VENDOR_ID	0x0ab4
-#define USB_CANUSB2_PRODUCT_ID	0x0010
-#define USB_CANUSBM_PRODUCT_ID	0x0011
+#define ESD_USB_ESDGMBH_VENDOR_ID	0x0ab4
+#define ESD_USB_CANUSB2_PRODUCT_ID	0x0010
+#define ESD_USB_CANUSBM_PRODUCT_ID	0x0011
 
 /* CAN controller clock frequencies */
-#define ESD_USB2_CAN_CLOCK	(60 * MEGA) /* Hz */
-#define ESD_USBM_CAN_CLOCK	(36 * MEGA) /* Hz */
+#define ESD_USB_2_CAN_CLOCK	(60 * MEGA) /* Hz */
+#define ESD_USB_M_CAN_CLOCK	(36 * MEGA) /* Hz */
 
 /* Maximum number of CAN nets */
 #define ESD_USB_MAX_NETS	2
 
 /* USB commands */
-#define CMD_VERSION		1 /* also used for VERSION_REPLY */
-#define CMD_CAN_RX		2 /* device to host only */
-#define CMD_CAN_TX		3 /* also used for TX_DONE */
-#define CMD_SETBAUD		4 /* also used for SETBAUD_REPLY */
-#define CMD_TS			5 /* also used for TS_REPLY */
-#define CMD_IDADD		6 /* also used for IDADD_REPLY */
+#define ESD_USB_CMD_VERSION		1 /* also used for VERSION_REPLY */
+#define ESD_USB_CMD_CAN_RX		2 /* device to host only */
+#define ESD_USB_CMD_CAN_TX		3 /* also used for TX_DONE */
+#define ESD_USB_CMD_SETBAUD		4 /* also used for SETBAUD_REPLY */
+#define ESD_USB_CMD_TS			5 /* also used for TS_REPLY */
+#define ESD_USB_CMD_IDADD		6 /* also used for IDADD_REPLY */
 
 /* esd CAN message flags - dlc field */
 #define ESD_RTR	BIT(4) /* 0x10 */
 
 
 /* esd CAN message flags - id field */
-#define ESD_EXTID	BIT(29) /* 0x20000000 */
-#define ESD_EVENT	BIT(30) /* 0x40000000 */
-#define ESD_IDMASK	0x1fffffff
+#define ESD_USB_EXTID	BIT(29) /* 0x20000000 */
+#define ESD_USB_EVENT	BIT(30) /* 0x40000000 */
+#define ESD_USB_IDMASK	0x1fffffff
 
 /* esd CAN event ids */
 #define ESD_EV_CAN_ERROR_EXT	2 /* CAN controller specific diagnostic data */
@@ -59,35 +59,35 @@ MODULE_LICENSE("GPL v2");
 #define ESD_USB_UBR	BIT(31) /* 0x80000000, User Bit Rate (controller BTR) in bits 0..27 */
 #define ESD_USB_NO_BAUDRATE	0x7fffffff /* bit rate unconfigured */
 
-/* bit timing CAN-USB/2 */
-#define ESD_USB2_TSEG1_SHIFT	16
-#define ESD_USB2_TSEG2_SHIFT	20
-#define ESD_USB2_SJW_SHIFT	14
-#define ESD_USBM_SJW_SHIFT	24
-#define ESD_USB2_3_SAMPLES	0x00800000
+/* bit timing esd CAN-USB */
+#define ESD_USB_2_TSEG1_SHIFT	16
+#define ESD_USB_2_TSEG2_SHIFT	20
+#define ESD_USB_2_SJW_SHIFT	14
+#define ESD_USB_M_SJW_SHIFT	24
+#define ESD_USB_3_SAMPLES	0x00800000
 
 /* esd IDADD message */
-#define ESD_ID_ENABLE		0x80
-#define ESD_MAX_ID_SEGMENT	64
+#define ESD_USB_ID_ENABLE	0x80
+#define ESD_USB_MAX_ID_SEGMENT	64
 
 /* SJA1000 ECC register (emulated by usb firmware) */
-#define SJA1000_ECC_SEG		0x1F
-#define SJA1000_ECC_DIR		0x20
-#define SJA1000_ECC_ERR		0x06
-#define SJA1000_ECC_BIT		0x00
-#define SJA1000_ECC_FORM	0x40
-#define SJA1000_ECC_STUFF	0x80
-#define SJA1000_ECC_MASK	0xc0
+#define ESD_USB_SJA1000_ECC_SEG		0x1F
+#define ESD_USB_SJA1000_ECC_DIR		0x20
+#define ESD_USB_SJA1000_ECC_ERR		0x06
+#define ESD_USB_SJA1000_ECC_BIT		0x00
+#define ESD_USB_SJA1000_ECC_FORM	0x40
+#define ESD_USB_SJA1000_ECC_STUFF	0x80
+#define ESD_USB_SJA1000_ECC_MASK	0xc0
 
 /* esd bus state event codes */
-#define ESD_BUSSTATE_MASK	0xc0
-#define ESD_BUSSTATE_WARN	0x40
-#define ESD_BUSSTATE_ERRPASSIVE	0x80
-#define ESD_BUSSTATE_BUSOFF	0xc0
+#define ESD_USB_BUSSTATE_MASK	0xc0
+#define ESD_USB_BUSSTATE_WARN	0x40
+#define ESD_USB_BUSSTATE_ERRPASSIVE	0x80
+#define ESD_USB_BUSSTATE_BUSOFF	0xc0
 
-#define RX_BUFFER_SIZE		1024
-#define MAX_RX_URBS		4
-#define MAX_TX_URBS		16 /* must be power of 2 */
+#define ESD_USB_RX_BUFFER_SIZE		1024
+#define ESD_USB_MAX_RX_URBS		4
+#define ESD_USB_MAX_TX_URBS		16 /* must be power of 2 */
 
 struct header_msg {
 	u8 len; /* len is always the total message length in 32bit words */
@@ -156,7 +156,7 @@ struct id_filter_msg {
 	u8 cmd;
 	u8 net;
 	u8 option;
-	__le32 mask[ESD_MAX_ID_SEGMENT + 1];
+	__le32 mask[ESD_USB_MAX_ID_SEGMENT + 1];
 };
 
 struct set_baudrate_msg {
@@ -180,8 +180,8 @@ union __packed esd_usb_msg {
 };
 
 static struct usb_device_id esd_usb_table[] = {
-	{USB_DEVICE(USB_ESDGMBH_VENDOR_ID, USB_CANUSB2_PRODUCT_ID)},
-	{USB_DEVICE(USB_ESDGMBH_VENDOR_ID, USB_CANUSBM_PRODUCT_ID)},
+	{USB_DEVICE(ESD_USB_ESDGMBH_VENDOR_ID, ESD_USB_CANUSB2_PRODUCT_ID)},
+	{USB_DEVICE(ESD_USB_ESDGMBH_VENDOR_ID, ESD_USB_CANUSBM_PRODUCT_ID)},
 	{}
 };
 MODULE_DEVICE_TABLE(usb, esd_usb_table);
@@ -202,8 +202,8 @@ struct esd_usb {
 	int net_count;
 	u32 version;
 	int rxinitdone;
-	void *rxbuf[MAX_RX_URBS];
-	dma_addr_t rxbuf_dma[MAX_RX_URBS];
+	void *rxbuf[ESD_USB_MAX_RX_URBS];
+	dma_addr_t rxbuf_dma[ESD_USB_MAX_RX_URBS];
 };
 
 struct esd_usb_net_priv {
@@ -211,7 +211,7 @@ struct esd_usb_net_priv {
 
 	atomic_t active_tx_jobs;
 	struct usb_anchor tx_submitted;
-	struct esd_tx_urb_context tx_contexts[MAX_TX_URBS];
+	struct esd_tx_urb_context tx_contexts[ESD_USB_MAX_TX_URBS];
 
 	struct esd_usb *usb;
 	struct net_device *netdev;
@@ -226,7 +226,7 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 	struct net_device_stats *stats = &priv->netdev->stats;
 	struct can_frame *cf;
 	struct sk_buff *skb;
-	u32 id = le32_to_cpu(msg->rx.id) & ESD_IDMASK;
+	u32 id = le32_to_cpu(msg->rx.id) & ESD_USB_IDMASK;
 
 	if (id == ESD_EV_CAN_ERROR_EXT) {
 		u8 state = msg->rx.ev_can_err_ext.status;
@@ -255,15 +255,15 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 
 			priv->old_state = state;
 
-			switch (state & ESD_BUSSTATE_MASK) {
-			case ESD_BUSSTATE_BUSOFF:
+			switch (state & ESD_USB_BUSSTATE_MASK) {
+			case ESD_USB_BUSSTATE_BUSOFF:
 				new_state = CAN_STATE_BUS_OFF;
 				can_bus_off(priv->netdev);
 				break;
-			case ESD_BUSSTATE_WARN:
+			case ESD_USB_BUSSTATE_WARN:
 				new_state = CAN_STATE_ERROR_WARNING;
 				break;
-			case ESD_BUSSTATE_ERRPASSIVE:
+			case ESD_USB_BUSSTATE_ERRPASSIVE:
 				new_state = CAN_STATE_ERROR_PASSIVE;
 				break;
 			default:
@@ -285,14 +285,14 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 
 			cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
 
-			switch (ecc & SJA1000_ECC_MASK) {
-			case SJA1000_ECC_BIT:
+			switch (ecc & ESD_USB_SJA1000_ECC_MASK) {
+			case ESD_USB_SJA1000_ECC_BIT:
 				cf->data[2] |= CAN_ERR_PROT_BIT;
 				break;
-			case SJA1000_ECC_FORM:
+			case ESD_USB_SJA1000_ECC_FORM:
 				cf->data[2] |= CAN_ERR_PROT_FORM;
 				break;
-			case SJA1000_ECC_STUFF:
+			case ESD_USB_SJA1000_ECC_STUFF:
 				cf->data[2] |= CAN_ERR_PROT_STUFF;
 				break;
 			default:
@@ -300,11 +300,11 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 			}
 
 			/* Error occurred during transmission? */
-			if (!(ecc & SJA1000_ECC_DIR))
+			if (!(ecc & ESD_USB_SJA1000_ECC_DIR))
 				cf->data[2] |= CAN_ERR_PROT_TX;
 
 			/* Bit stream position in CAN frame as the error was detected */
-			cf->data[3] = ecc & SJA1000_ECC_SEG;
+			cf->data[3] = ecc & ESD_USB_SJA1000_ECC_SEG;
 		}
 
 		if (skb) {
@@ -331,7 +331,7 @@ static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv,
 
 	id = le32_to_cpu(msg->rx.id);
 
-	if (id & ESD_EVENT) {
+	if (id & ESD_USB_EVENT) {
 		esd_usb_rx_event(priv, msg);
 	} else {
 		skb = alloc_can_skb(priv->netdev, &cf);
@@ -340,11 +340,11 @@ static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv,
 			return;
 		}
 
-		cf->can_id = id & ESD_IDMASK;
+		cf->can_id = id & ESD_USB_IDMASK;
 		can_frame_set_cc_len(cf, msg->rx.dlc & ~ESD_RTR,
 				     priv->can.ctrlmode);
 
-		if (id & ESD_EXTID)
+		if (id & ESD_USB_EXTID)
 			cf->can_id |= CAN_EFF_FLAG;
 
 		if (msg->rx.dlc & ESD_RTR) {
@@ -371,7 +371,7 @@ static void esd_usb_tx_done_msg(struct esd_usb_net_priv *priv,
 	if (!netif_device_present(netdev))
 		return;
 
-	context = &priv->tx_contexts[msg->txdone.hnd & (MAX_TX_URBS - 1)];
+	context = &priv->tx_contexts[msg->txdone.hnd & (ESD_USB_MAX_TX_URBS - 1)];
 
 	if (!msg->txdone.status) {
 		stats->tx_packets++;
@@ -383,7 +383,7 @@ static void esd_usb_tx_done_msg(struct esd_usb_net_priv *priv,
 	}
 
 	/* Release context */
-	context->echo_index = MAX_TX_URBS;
+	context->echo_index = ESD_USB_MAX_TX_URBS;
 	atomic_dec(&priv->active_tx_jobs);
 
 	netif_wake_queue(netdev);
@@ -418,7 +418,7 @@ static void esd_usb_read_bulk_callback(struct urb *urb)
 		msg = (union esd_usb_msg *)(urb->transfer_buffer + pos);
 
 		switch (msg->hdr.cmd) {
-		case CMD_CAN_RX:
+		case ESD_USB_CMD_CAN_RX:
 			if (msg->rx.net >= dev->net_count) {
 				dev_err(dev->udev->dev.parent, "format error\n");
 				break;
@@ -427,7 +427,7 @@ static void esd_usb_read_bulk_callback(struct urb *urb)
 			esd_usb_rx_can_msg(dev->nets[msg->rx.net], msg);
 			break;
 
-		case CMD_CAN_TX:
+		case ESD_USB_CMD_CAN_TX:
 			if (msg->txdone.net >= dev->net_count) {
 				dev_err(dev->udev->dev.parent, "format error\n");
 				break;
@@ -448,7 +448,7 @@ static void esd_usb_read_bulk_callback(struct urb *urb)
 
 resubmit_urb:
 	usb_fill_bulk_urb(urb, dev->udev, usb_rcvbulkpipe(dev->udev, 1),
-			  urb->transfer_buffer, RX_BUFFER_SIZE,
+			  urb->transfer_buffer, ESD_USB_RX_BUFFER_SIZE,
 			  esd_usb_read_bulk_callback, dev);
 
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
@@ -557,7 +557,7 @@ static int esd_usb_setup_rx_urbs(struct esd_usb *dev)
 	if (dev->rxinitdone)
 		return 0;
 
-	for (i = 0; i < MAX_RX_URBS; i++) {
+	for (i = 0; i < ESD_USB_MAX_RX_URBS; i++) {
 		struct urb *urb = NULL;
 		u8 *buf = NULL;
 		dma_addr_t buf_dma;
@@ -569,7 +569,7 @@ static int esd_usb_setup_rx_urbs(struct esd_usb *dev)
 			break;
 		}
 
-		buf = usb_alloc_coherent(dev->udev, RX_BUFFER_SIZE, GFP_KERNEL,
+		buf = usb_alloc_coherent(dev->udev, ESD_USB_RX_BUFFER_SIZE, GFP_KERNEL,
 					 &buf_dma);
 		if (!buf) {
 			dev_warn(dev->udev->dev.parent,
@@ -582,7 +582,7 @@ static int esd_usb_setup_rx_urbs(struct esd_usb *dev)
 
 		usb_fill_bulk_urb(urb, dev->udev,
 				  usb_rcvbulkpipe(dev->udev, 1),
-				  buf, RX_BUFFER_SIZE,
+				  buf, ESD_USB_RX_BUFFER_SIZE,
 				  esd_usb_read_bulk_callback, dev);
 		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 		usb_anchor_urb(urb, &dev->rx_submitted);
@@ -590,7 +590,7 @@ static int esd_usb_setup_rx_urbs(struct esd_usb *dev)
 		err = usb_submit_urb(urb, GFP_KERNEL);
 		if (err) {
 			usb_unanchor_urb(urb);
-			usb_free_coherent(dev->udev, RX_BUFFER_SIZE, buf,
+			usb_free_coherent(dev->udev, ESD_USB_RX_BUFFER_SIZE, buf,
 					  urb->transfer_dma);
 			goto freeurb;
 		}
@@ -612,7 +612,7 @@ static int esd_usb_setup_rx_urbs(struct esd_usb *dev)
 	}
 
 	/* Warn if we've couldn't transmit all the URBs */
-	if (i < MAX_RX_URBS) {
+	if (i < ESD_USB_MAX_RX_URBS) {
 		dev_warn(dev->udev->dev.parent,
 			 "rx performance may be slow\n");
 	}
@@ -647,14 +647,14 @@ static int esd_usb_start(struct esd_usb_net_priv *priv)
 	 * the number of the starting bitmask (0..64) to the filter.option
 	 * field followed by only some bitmasks.
 	 */
-	msg->hdr.cmd = CMD_IDADD;
-	msg->hdr.len = 2 + ESD_MAX_ID_SEGMENT;
+	msg->hdr.cmd = ESD_USB_CMD_IDADD;
+	msg->hdr.len = 2 + ESD_USB_MAX_ID_SEGMENT;
 	msg->filter.net = priv->index;
-	msg->filter.option = ESD_ID_ENABLE; /* start with segment 0 */
-	for (i = 0; i < ESD_MAX_ID_SEGMENT; i++)
+	msg->filter.option = ESD_USB_ID_ENABLE; /* start with segment 0 */
+	for (i = 0; i < ESD_USB_MAX_ID_SEGMENT; i++)
 		msg->filter.mask[i] = cpu_to_le32(0xffffffff);
 	/* enable 29bit extended IDs */
-	msg->filter.mask[ESD_MAX_ID_SEGMENT] = cpu_to_le32(0x00000001);
+	msg->filter.mask[ESD_USB_MAX_ID_SEGMENT] = cpu_to_le32(0x00000001);
 
 	err = esd_usb_send_msg(dev, msg);
 	if (err)
@@ -683,8 +683,8 @@ static void unlink_all_urbs(struct esd_usb *dev)
 
 	usb_kill_anchored_urbs(&dev->rx_submitted);
 
-	for (i = 0; i < MAX_RX_URBS; ++i)
-		usb_free_coherent(dev->udev, RX_BUFFER_SIZE,
+	for (i = 0; i < ESD_USB_MAX_RX_URBS; ++i)
+		usb_free_coherent(dev->udev, ESD_USB_RX_BUFFER_SIZE,
 				  dev->rxbuf[i], dev->rxbuf_dma[i]);
 
 	for (i = 0; i < dev->net_count; i++) {
@@ -693,8 +693,8 @@ static void unlink_all_urbs(struct esd_usb *dev)
 			usb_kill_anchored_urbs(&priv->tx_submitted);
 			atomic_set(&priv->active_tx_jobs, 0);
 
-			for (j = 0; j < MAX_TX_URBS; j++)
-				priv->tx_contexts[j].echo_index = MAX_TX_URBS;
+			for (j = 0; j < ESD_USB_MAX_TX_URBS; j++)
+				priv->tx_contexts[j].echo_index = ESD_USB_MAX_TX_URBS;
 		}
 	}
 }
@@ -760,7 +760,7 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 	msg = (union esd_usb_msg *)buf;
 
 	msg->hdr.len = 3; /* minimal length */
-	msg->hdr.cmd = CMD_CAN_TX;
+	msg->hdr.cmd = ESD_USB_CMD_CAN_TX;
 	msg->tx.net = priv->index;
 	msg->tx.dlc = can_get_cc_dlc(cf, priv->can.ctrlmode);
 	msg->tx.id = cpu_to_le32(cf->can_id & CAN_ERR_MASK);
@@ -769,15 +769,15 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 		msg->tx.dlc |= ESD_RTR;
 
 	if (cf->can_id & CAN_EFF_FLAG)
-		msg->tx.id |= cpu_to_le32(ESD_EXTID);
+		msg->tx.id |= cpu_to_le32(ESD_USB_EXTID);
 
 	for (i = 0; i < cf->len; i++)
 		msg->tx.data[i] = cf->data[i];
 
 	msg->hdr.len += (cf->len + 3) >> 2;
 
-	for (i = 0; i < MAX_TX_URBS; i++) {
-		if (priv->tx_contexts[i].echo_index == MAX_TX_URBS) {
+	for (i = 0; i < ESD_USB_MAX_TX_URBS; i++) {
+		if (priv->tx_contexts[i].echo_index == ESD_USB_MAX_TX_URBS) {
 			context = &priv->tx_contexts[i];
 			break;
 		}
@@ -809,7 +809,7 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 	atomic_inc(&priv->active_tx_jobs);
 
 	/* Slow down tx path */
-	if (atomic_read(&priv->active_tx_jobs) >= MAX_TX_URBS)
+	if (atomic_read(&priv->active_tx_jobs) >= ESD_USB_MAX_TX_URBS)
 		netif_stop_queue(netdev);
 
 	err = usb_submit_urb(urb, GFP_ATOMIC);
@@ -859,18 +859,18 @@ static int esd_usb_close(struct net_device *netdev)
 		return -ENOMEM;
 
 	/* Disable all IDs (see esd_usb_start()) */
-	msg->hdr.cmd = CMD_IDADD;
-	msg->hdr.len = 2 + ESD_MAX_ID_SEGMENT;
+	msg->hdr.cmd = ESD_USB_CMD_IDADD;
+	msg->hdr.len = 2 + ESD_USB_MAX_ID_SEGMENT;
 	msg->filter.net = priv->index;
-	msg->filter.option = ESD_ID_ENABLE; /* start with segment 0 */
-	for (i = 0; i <= ESD_MAX_ID_SEGMENT; i++)
+	msg->filter.option = ESD_USB_ID_ENABLE; /* start with segment 0 */
+	for (i = 0; i <= ESD_USB_MAX_ID_SEGMENT; i++)
 		msg->filter.mask[i] = 0;
 	if (esd_usb_send_msg(priv->usb, msg) < 0)
 		netdev_err(netdev, "sending idadd message failed\n");
 
 	/* set CAN controller to reset mode */
 	msg->hdr.len = 2;
-	msg->hdr.cmd = CMD_SETBAUD;
+	msg->hdr.cmd = ESD_USB_CMD_SETBAUD;
 	msg->setbaud.net = priv->index;
 	msg->setbaud.rsvd = 0;
 	msg->setbaud.baud = cpu_to_le32(ESD_USB_NO_BAUDRATE);
@@ -928,27 +928,27 @@ static int esd_usb2_set_bittiming(struct net_device *netdev)
 	canbtr |= (bt->brp - 1) & (btc->brp_max - 1);
 
 	if (le16_to_cpu(priv->usb->udev->descriptor.idProduct) ==
-	    USB_CANUSBM_PRODUCT_ID)
-		sjw_shift = ESD_USBM_SJW_SHIFT;
+	    ESD_USB_CANUSBM_PRODUCT_ID)
+		sjw_shift = ESD_USB_M_SJW_SHIFT;
 	else
-		sjw_shift = ESD_USB2_SJW_SHIFT;
+		sjw_shift = ESD_USB_2_SJW_SHIFT;
 
 	canbtr |= ((bt->sjw - 1) & (btc->sjw_max - 1))
 		<< sjw_shift;
 	canbtr |= ((bt->prop_seg + bt->phase_seg1 - 1)
 		   & (btc->tseg1_max - 1))
-		<< ESD_USB2_TSEG1_SHIFT;
+		<< ESD_USB_2_TSEG1_SHIFT;
 	canbtr |= ((bt->phase_seg2 - 1) & (btc->tseg2_max - 1))
-		<< ESD_USB2_TSEG2_SHIFT;
+		<< ESD_USB_2_TSEG2_SHIFT;
 	if (priv->can.ctrlmode & CAN_CTRLMODE_3_SAMPLES)
-		canbtr |= ESD_USB2_3_SAMPLES;
+		canbtr |= ESD_USB_3_SAMPLES;
 
 	msg = kmalloc(sizeof(*msg), GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
 
 	msg->hdr.len = 2;
-	msg->hdr.cmd = CMD_SETBAUD;
+	msg->hdr.cmd = ESD_USB_CMD_SETBAUD;
 	msg->setbaud.net = priv->index;
 	msg->setbaud.rsvd = 0;
 	msg->setbaud.baud = cpu_to_le32(canbtr);
@@ -994,7 +994,7 @@ static int esd_usb_probe_one_net(struct usb_interface *intf, int index)
 	int err = 0;
 	int i;
 
-	netdev = alloc_candev(sizeof(*priv), MAX_TX_URBS);
+	netdev = alloc_candev(sizeof(*priv), ESD_USB_MAX_TX_URBS);
 	if (!netdev) {
 		dev_err(&intf->dev, "couldn't alloc candev\n");
 		err = -ENOMEM;
@@ -1006,8 +1006,8 @@ static int esd_usb_probe_one_net(struct usb_interface *intf, int index)
 	init_usb_anchor(&priv->tx_submitted);
 	atomic_set(&priv->active_tx_jobs, 0);
 
-	for (i = 0; i < MAX_TX_URBS; i++)
-		priv->tx_contexts[i].echo_index = MAX_TX_URBS;
+	for (i = 0; i < ESD_USB_MAX_TX_URBS; i++)
+		priv->tx_contexts[i].echo_index = ESD_USB_MAX_TX_URBS;
 
 	priv->usb = dev;
 	priv->netdev = netdev;
@@ -1019,10 +1019,10 @@ static int esd_usb_probe_one_net(struct usb_interface *intf, int index)
 		CAN_CTRLMODE_BERR_REPORTING;
 
 	if (le16_to_cpu(dev->udev->descriptor.idProduct) ==
-	    USB_CANUSBM_PRODUCT_ID)
-		priv->can.clock.freq = ESD_USBM_CAN_CLOCK;
+	    ESD_USB_CANUSBM_PRODUCT_ID)
+		priv->can.clock.freq = ESD_USB_M_CAN_CLOCK;
 	else {
-		priv->can.clock.freq = ESD_USB2_CAN_CLOCK;
+		priv->can.clock.freq = ESD_USB_2_CAN_CLOCK;
 		priv->can.ctrlmode_supported |= CAN_CTRLMODE_3_SAMPLES;
 	}
 
@@ -1085,7 +1085,7 @@ static int esd_usb_probe(struct usb_interface *intf,
 	}
 
 	/* query number of CAN interfaces (nets) */
-	msg->hdr.cmd = CMD_VERSION;
+	msg->hdr.cmd = ESD_USB_CMD_VERSION;
 	msg->hdr.len = 2;
 	msg->version.rsvd = 0;
 	msg->version.flags = 0;
-- 
2.25.1


