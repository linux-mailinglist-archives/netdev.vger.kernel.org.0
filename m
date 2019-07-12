Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1555A66819
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 10:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbfGLICz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 04:02:55 -0400
Received: from mail-eopbgr130089.outbound.protection.outlook.com ([40.107.13.89]:52706
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726078AbfGLICz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 04:02:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ClQRypyrbRtuJ3sL6D7fFpZ0T2ATW77YDhAg0g8VV/Sw2H8n4qk/9FcL940oHW+XCJDb+4SKpqiMpBORHI2Z7IaTWE78EI0eB6nb1jqTU0dTHCyNE8mJ1syhKWVQGIze8Z6dAuJ6BUu7YjDk8Lib9cXAhs5BbPOAlWDqJHBuZPO9yXLDcdsLSzPsfqfgO2Bed3PPLBdnmOYmbSObZW15ybDNz8xyrIw+CNH64U4mhtLJBdQm/hyMuEkTChLlh/iKyutuOUyMjQjeC2P8yuOn/jOCUtUJKUaNB8Rg3I5tsXTTY5vsgfN3XwTfhG2qlwyyXJgN91W/VuH5vXUAg92z4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R9nye2Srz8LcRDROgixMWMkYol45MuvZXOsvpxzh5AQ=;
 b=cYjKgZpw6GwogDZHNIhsqp+gLKtO335Ga8L2jkAsdlwGrbw2OvlJ0mieq+OvxAtPpB4oC9JMKUte05sXg0M1ANtK+sULcWXDmuivQxpJG5/xZ+nbxSfBpbjzEHp8KWOiPKHJy399Yb2V6ibaZx/FnpKp7GE99AkMm+oBklYaE3dovOVWTsoEOmKVCQp6ZH2iD6j7HYOTSz01dpoQZSTTznZloMJZRJ5kuNjCuyHZyuF45JGmTft9n7szdlTl2ZSfaglBFu6TDDDoLjUF+1pxqVEZxBdYdT+0hRANStd5YNSOiKHMHODNkhAQENaErXH1zq6sr2+E/b+eNfB33x33cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R9nye2Srz8LcRDROgixMWMkYol45MuvZXOsvpxzh5AQ=;
 b=MgsLpN8qZUsPVBdtOJFIP/pxWtjgg2cOgLfBi9m8ugj7yBpoF/PylhUtnCdPSnG8im+Vinq/t/O/DToM9oIpQA6UChKiaTd2aV7KiQOQWckz9uqo726Dsox0OjTRq0MFp0JzG8RIN7dSkNBXs317BMSz/E+RPHC9dsQYWNuuTjw=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4889.eurprd04.prod.outlook.com (20.176.234.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Fri, 12 Jul 2019 08:02:41 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b%5]) with mapi id 15.20.2073.008; Fri, 12 Jul 2019
 08:02:41 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH 2/8] can: flexcan: use struct canfd_frame for CAN classic
 frame
Thread-Topic: [PATCH 2/8] can: flexcan: use struct canfd_frame for CAN classic
 frame
Thread-Index: AQHVOIgtzkI2An/dl0uUbz4VEl5z7A==
Date:   Fri, 12 Jul 2019 08:02:41 +0000
Message-ID: <20190712075926.7357-3-qiangqing.zhang@nxp.com>
References: <20190712075926.7357-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20190712075926.7357-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR02CA0061.apcprd02.prod.outlook.com
 (2603:1096:4:54::25) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: adb4318a-22a0-450a-e621-08d7069f502d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB7PR04MB4889;
x-ms-traffictypediagnostic: DB7PR04MB4889:
x-microsoft-antispam-prvs: <DB7PR04MB4889E75436DD03D5F46C4EAEE6F20@DB7PR04MB4889.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1107;
x-forefront-prvs: 00963989E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(199004)(189003)(50226002)(66066001)(2906002)(71190400001)(2616005)(476003)(71200400001)(8936002)(11346002)(25786009)(446003)(1076003)(478600001)(53936002)(305945005)(2501003)(14454004)(486006)(7736002)(6512007)(36756003)(52116002)(76176011)(8676002)(99286004)(102836004)(86362001)(256004)(5660300002)(14444005)(81156014)(81166006)(26005)(64756008)(66556008)(66446008)(66476007)(386003)(6506007)(66946007)(3846002)(110136005)(4326008)(6116002)(54906003)(186003)(316002)(6486002)(68736007)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4889;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ffi3zcThdvAsopLQ+1Cmo6NZGkttx4JD4+iT0E20X5qYGpeJ46CoXqu7++BtH/31+YPG24YRmpobD49KUaNTNgH+8xGRd3RpW1HkhsCfqqZbzf/fXfyHNy/J1HZk4FC5GMgFSim+wDt+EzyyF0XKlmHHWtjBrPXKszRGzDox0cS87DgWukkntQcT4fQ2laOukgmjX75+ZsCUHm88sVauBYqJaZE97EsAmToUDxa+jPeRqI61OnJHCItAb95S0Nxd4rwwIuurQlmXcNf3isRIw7Eu7R7wCxIdODgDBG00vLyacm1SqRcF+QYxmCNAIieUPRG2lseDlu1KRj5EN3a1OcMrYfHVaJggi85hfprv2rludL4g24D28e6l7vd0qHpauFV0B6rljXSL+gOUmA+9M6MvKFssmc3yzL8+EYZNegk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adb4318a-22a0-450a-e621-08d7069f502d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2019 08:02:41.3744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiangqing.zhang@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4889
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch prepares for CAN FD mode, using struct canfd_frame can both
for classic format frame and fd format frame.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c    | 34 +++++++++++++++++-----------------
 drivers/net/can/rx-offload.c |  4 ++--
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 7e12f3db0915..5b0a159daa38 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -609,10 +609,10 @@ static int flexcan_get_berr_counter(const struct net_=
device *dev,
 static netdev_tx_t flexcan_start_xmit(struct sk_buff *skb, struct net_devi=
ce *dev)
 {
 	const struct flexcan_priv *priv =3D netdev_priv(dev);
-	struct can_frame *cf =3D (struct can_frame *)skb->data;
+	struct canfd_frame *cfd =3D (struct canfd_frame *)skb->data;
 	u32 can_id;
 	u32 data;
-	u32 ctrl =3D FLEXCAN_MB_CODE_TX_DATA | (cf->can_dlc << 16);
+	u32 ctrl =3D FLEXCAN_MB_CODE_TX_DATA | (cfd->len << 16);
 	int i;
=20
 	if (can_dropped_invalid_skb(dev, skb))
@@ -620,18 +620,18 @@ static netdev_tx_t flexcan_start_xmit(struct sk_buff =
*skb, struct net_device *de
=20
 	netif_stop_queue(dev);
=20
-	if (cf->can_id & CAN_EFF_FLAG) {
-		can_id =3D cf->can_id & CAN_EFF_MASK;
+	if (cfd->can_id & CAN_EFF_FLAG) {
+		can_id =3D cfd->can_id & CAN_EFF_MASK;
 		ctrl |=3D FLEXCAN_MB_CNT_IDE | FLEXCAN_MB_CNT_SRR;
 	} else {
-		can_id =3D (cf->can_id & CAN_SFF_MASK) << 18;
+		can_id =3D (cfd->can_id & CAN_SFF_MASK) << 18;
 	}
=20
-	if (cf->can_id & CAN_RTR_FLAG)
+	if (cfd->can_id & CAN_RTR_FLAG)
 		ctrl |=3D FLEXCAN_MB_CNT_RTR;
=20
-	for (i =3D 0; i < cf->can_dlc; i +=3D sizeof(u32)) {
-		data =3D be32_to_cpup((__be32 *)&cf->data[i]);
+	for (i =3D 0; i < cfd->len; i +=3D sizeof(u32)) {
+		data =3D be32_to_cpup((__be32 *)&cfd->data[i]);
 		priv->write(data, &priv->tx_mb->data[i / sizeof(u32)]);
 	}
=20
@@ -797,7 +797,7 @@ static unsigned int flexcan_mailbox_read(struct can_rx_=
offload *offload, bool dr
 	struct flexcan_regs __iomem *regs =3D priv->regs;
 	struct flexcan_mb __iomem *mb;
 	u32 reg_ctrl, reg_id, reg_iflag1;
-	struct can_frame *cf =3D NULL;
+	struct canfd_frame *cfd =3D NULL;
 	int i;
=20
 	mb =3D flexcan_get_mb(priv, n);
@@ -829,25 +829,25 @@ static unsigned int flexcan_mailbox_read(struct can_r=
x_offload *offload, bool dr
 	}
=20
 	if (!drop)
-		*skb =3D alloc_can_skb(offload->dev, &cf);
+		*skb =3D alloc_can_skb(offload->dev, (struct can_frame **)&cfd);
=20
-	if (*skb && cf) {
+	if (*skb && cfd) {
 		/* increase timstamp to full 32 bit */
 		*timestamp =3D reg_ctrl << 16;
=20
 		reg_id =3D priv->read(&mb->can_id);
 		if (reg_ctrl & FLEXCAN_MB_CNT_IDE)
-			cf->can_id =3D ((reg_id >> 0) & CAN_EFF_MASK) | CAN_EFF_FLAG;
+			cfd->can_id =3D ((reg_id >> 0) & CAN_EFF_MASK) | CAN_EFF_FLAG;
 		else
-			cf->can_id =3D (reg_id >> 18) & CAN_SFF_MASK;
+			cfd->can_id =3D (reg_id >> 18) & CAN_SFF_MASK;
=20
 		if (reg_ctrl & FLEXCAN_MB_CNT_RTR)
-			cf->can_id |=3D CAN_RTR_FLAG;
-		cf->can_dlc =3D get_can_dlc((reg_ctrl >> 16) & 0xf);
+			cfd->can_id |=3D CAN_RTR_FLAG;
+		cfd->len =3D get_can_dlc((reg_ctrl >> 16) & 0x0F);
=20
-		for (i =3D 0; i < cf->can_dlc; i +=3D sizeof(u32)) {
+		for (i =3D 0; i < cfd->len; i +=3D sizeof(u32)) {
 			__be32 data =3D cpu_to_be32(priv->read(&mb->data[i / sizeof(u32)]));
-			*(__be32 *)(cf->data + i) =3D data;
+			*(__be32 *)(cfd->data + i) =3D data;
 		}
 	}
=20
diff --git a/drivers/net/can/rx-offload.c b/drivers/net/can/rx-offload.c
index 632919484ff7..9f8c8410e19e 100644
--- a/drivers/net/can/rx-offload.c
+++ b/drivers/net/can/rx-offload.c
@@ -55,11 +55,11 @@ static int can_rx_offload_napi_poll(struct napi_struct =
*napi, int quota)
=20
 	while ((work_done < quota) &&
 	       (skb =3D skb_dequeue(&offload->skb_queue))) {
-		struct can_frame *cf =3D (struct can_frame *)skb->data;
+		struct canfd_frame *cfd =3D (struct canfd_frame *)skb->data;
=20
 		work_done++;
 		stats->rx_packets++;
-		stats->rx_bytes +=3D cf->can_dlc;
+		stats->rx_bytes +=3D cfd->len;
 		netif_receive_skb(skb);
 	}
=20
--=20
2.17.1

