Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3206681B
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 10:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfGLIC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 04:02:58 -0400
Received: from mail-eopbgr00084.outbound.protection.outlook.com ([40.107.0.84]:19328
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726258AbfGLIC5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 04:02:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mCv/MxRHhOdMh6zvKVPcFmmJWOS/qCTVk7CKUGgNYszwiJMqG4pG8CG2IeXl8SUJWjjCSYkRyVwhvxWW4YHh1asa5dxsceldTwcdwtYipjGjU6gAnopKaKES2LkSdy15hHZipUPW7bE09SqwhzGopbTzjZxqXS0tFE9yahJAugW3vDKiX74EnD3E4hfUIODgpHR+msz7DgoMXVuDFByzt+LM6AQ9d/BsZ6kx7GBQGVpmsqeSiPT/7MRjoB+T3H8UzzpjQil1QNDuZjt8hgMFaJIz+ipJ3gOggTIm9JY7APuHHaEyJPNaUquMcIP+BxSHUQUsosb7NNOULWnlzh2Omg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yn22pt/v9272nVvpjD89xt0IX5due53zsFs762zEvaI=;
 b=WxHds203JrUZxc5+kP87aaq5keyBCZ+ijUBHzqh66kPkNvEYKPJvz4VKU6dseAGivPbbN6xkdRwsZee0fE7MsIbKJqqTHA0FRXKXC+qXJpXrQdxkXeVytewliLq3qOKS63XPTqZ0IqxNERRbPypX64l9KkDilPhJJU21dZLb//IArIuH8QBglNK/6IIH/mHD8akaZ6ezDa8lJ3zKMbV+MElKjEHoe0+TF7H9150W2SkXzPRcLiTHZM5WHKLbtaO4QzUKPFvCQl3nfpL++/f0iklpUBXl0HjJkmDdiiEd9H7Mgt63cBF9Dm4PnxlLEm+x3b+AIWgt8847CPvyMa7Y3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yn22pt/v9272nVvpjD89xt0IX5due53zsFs762zEvaI=;
 b=as7xC9DjcgJLjoC+iNKB9cvLLmV7eaQEm7/WJjddYg5w/O+L4xh2gyG8k0vSSlcUX7ec0Dxwk7Nd1zcAGPj+HDr/EH8NuQ5/zp2KLpNwcZVyt1hDXaZ0rL+zoXbinmh57LvuVKelqORCzSHvOxGwMERJqOy5Vdt5jyr8+QIUyyo=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4330.eurprd04.prod.outlook.com (52.134.108.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Fri, 12 Jul 2019 08:02:53 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b%5]) with mapi id 15.20.2073.008; Fri, 12 Jul 2019
 08:02:52 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH 4/8] can: flexcan: add CANFD BRS support
Thread-Topic: [PATCH 4/8] can: flexcan: add CANFD BRS support
Thread-Index: AQHVOIgxk/e1qoHwVkyOg+rkj+hT+A==
Date:   Fri, 12 Jul 2019 08:02:47 +0000
Message-ID: <20190712075926.7357-5-qiangqing.zhang@nxp.com>
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
x-ms-office365-filtering-correlation-id: fde09f85-b7c9-42e3-667a-08d7069f53a9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4330;
x-ms-traffictypediagnostic: DB7PR04MB4330:
x-microsoft-antispam-prvs: <DB7PR04MB433035DC4304F89BDE4FAC19E6F20@DB7PR04MB4330.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-forefront-prvs: 00963989E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(199004)(189003)(110136005)(25786009)(1076003)(54906003)(305945005)(3846002)(6116002)(7736002)(316002)(71200400001)(4326008)(66066001)(2906002)(66446008)(5660300002)(64756008)(66556008)(66476007)(71190400001)(2501003)(6666004)(478600001)(66946007)(2616005)(6506007)(102836004)(26005)(386003)(6436002)(186003)(6486002)(86362001)(50226002)(68736007)(256004)(14444005)(446003)(476003)(11346002)(486006)(8936002)(52116002)(76176011)(36756003)(53936002)(99286004)(14454004)(81156014)(81166006)(6512007)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4330;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hsnWoAIo+LlYTq0z5uY6rcng3bmD5+gr5DcpLfjEC0Yc7apydV5QNhNJAbqBNiIfAoiidWJUT72mOrr21b9C2B/ZfsqbLMP5HnPJmDiSaD8ZWNe4cKQ42JGw9gHtHh4QyYceu1aMGPXJiozBl+DJmFP1sQ+rpksFgVNe2ggS0klrc3FKH31RV6IEnQm13Gs+2jL7tk3Om35DQ8Aj5PWGsBd1l1rlN/b++7XEFV5zhQ6VKvR+w1pLk6P8EiUoQFS2empX71B5ceRoDd0KKvJ1ISDyxV/p4neDP18aPj+J4eCJqQwW5o30zsdH4+OFUjA/HB4TVd+QA9vqi5HuknrBFejzsvausem2qokLWc2Tqugln3dGYyxfgnFnaOdtdhckttIfuq2UksjoWMoRkiVvu+wtSZBUYpzI4zwAt5lO/5o=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fde09f85-b7c9-42e3-667a-08d7069f53a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2019 08:02:47.3209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiangqing.zhang@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4330
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch intends to add CAN FD BitRate Switch(BRS) support in driver.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 23e9407e33ff..4956ef64944a 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -684,9 +684,13 @@ static netdev_tx_t flexcan_start_xmit(struct sk_buff *=
skb, struct net_device *de
 	if (cfd->can_id & CAN_RTR_FLAG)
 		ctrl |=3D FLEXCAN_MB_CNT_RTR;
=20
-	if (can_is_canfd_skb(skb))
+	if (can_is_canfd_skb(skb)) {
 		ctrl |=3D FLEXCAN_MB_CNT_EDL;
=20
+		if (cfd->flags & CANFD_BRS)
+			ctrl |=3D FLEXCAN_MB_CNT_BRS;
+	}
+
 	for (i =3D 0; i < cfd->len; i +=3D sizeof(u32)) {
 		data =3D be32_to_cpup((__be32 *)&cfd->data[i]);
 		priv->write(data, &priv->tx_mb->data[i / sizeof(u32)]);
@@ -907,6 +911,9 @@ static unsigned int flexcan_mailbox_read(struct can_rx_=
offload *offload, bool dr
=20
 		if (reg_ctrl & FLEXCAN_MB_CNT_EDL) {
 			cfd->len =3D can_dlc2len(get_canfd_dlc((reg_ctrl >> 16) & 0x0F));
+
+			if (reg_ctrl & FLEXCAN_MB_CNT_BRS)
+				cfd->flags |=3D CANFD_BRS;
 		} else {
 			cfd->len =3D get_can_dlc((reg_ctrl >> 16) & 0x0F);
=20
--=20
2.17.1

