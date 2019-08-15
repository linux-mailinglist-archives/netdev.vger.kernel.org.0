Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B4B8E5E0
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 10:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730793AbfHOIAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 04:00:33 -0400
Received: from mail-eopbgr40064.outbound.protection.outlook.com ([40.107.4.64]:11267
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725961AbfHOIAd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 04:00:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYmB8UYZMASrB55ihiTWJ0bHP90xiNB3okfwAqmM1lQjmUMFU3A0GR8HogzFh3IMk8KCUpNMTM6ours8+/Nmn56FPscUsTb+x+SK6Ez7fnljTVt8s6Y/vgwotp8UxmhRj/S4AHtzZagyduv6gcUhlj0fhJy2yx41XbTeCsvR06IikaQ9LpkKZKQX33TKzgxbmN4ws9m92euSyeX7KfytnZrPHUK19AJFP+ykr9mIcQ26eUYjFj/k4z/CKLDdUGiAAIDObtWE5b9sT2PyNhorRVmn07gLkHCrMp3fyvZVrtBm1DHQeYAAQCukoBk7vmhLuO1IrSAWsSG1fQ4z2s5SLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4G5i1cpIpfu5x2OPiNfjWpcqyYa/iTlOtscahFnIZdI=;
 b=VB7syjYKRbKHwRdOqGVhknVrfO3blq8ro0bAma5f27Li8QuPDtXZRLfcXDU7x4ninyjnLaa1g475JEInuYjz45FctAjJoP/vxnj4jf3J5P2jSzfqjlNReHG13A92JfP2kSsgHsZ8qfNP8g/BZrHNTakG3dyWtSeo8H0c8NGaEkgAPweCcY95FY6oZXj7l1U3Ps1u45y2F1Zg4SJH1xEkA1kgzKFUWIf+byAMDUiCqM2tXU/XcusqORIPjampObVd0wfeA3LF/oE6xeLT5+ssWbw7oI2Cgbiqkni0ocBWTNmD2nwnrd5Fu3RRVQZyTT0jgmn8LbuhOeMoVDoy1i8BVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4G5i1cpIpfu5x2OPiNfjWpcqyYa/iTlOtscahFnIZdI=;
 b=TunQRR/mEoPQrF7nuYMy7W6av1DsNpqM76hhIvsvvc6h3ZT3TkgY2E9UJqKpEQ743HNg5/AK6vdpPfrMniHOqmXcnWtuwI9mx2WzhMIOxZssPBm9BbV3kzJc7IaZUpt+QuS3OKIKw9VWgmqkWCNYuZGRI/gsaApxbnpfl4qNfgs=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4633.eurprd04.prod.outlook.com (52.135.138.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 15 Aug 2019 08:00:26 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::c8ca:1c9c:6c3:fb6f]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::c8ca:1c9c:6c3:fb6f%4]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 08:00:26 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stefan@agner.ch" <stefan@agner.ch>,
        dl-linux-imx <linux-imx@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH] can: flexcan: disable completely the ECC mechanism
Thread-Topic: [PATCH] can: flexcan: disable completely the ECC mechanism
Thread-Index: AQHVUz9/01sBiEcbCkCiA+eVKuzQmw==
Date:   Thu, 15 Aug 2019 08:00:26 +0000
Message-ID: <20190815075806.23212-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR04CA0132.apcprd04.prod.outlook.com
 (2603:1096:3:16::16) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 426b27fb-3b78-435d-7dcb-08d72156a1ae
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4633;
x-ms-traffictypediagnostic: DB7PR04MB4633:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB463338C1848C8DE40A8A5997E6AC0@DB7PR04MB4633.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(39860400002)(376002)(346002)(189003)(199004)(486006)(99286004)(71190400001)(71200400001)(50226002)(25786009)(66066001)(6436002)(6116002)(3846002)(6486002)(305945005)(256004)(14444005)(2616005)(476003)(478600001)(2501003)(4326008)(66946007)(66446008)(64756008)(66556008)(66476007)(54906003)(186003)(110136005)(4744005)(316002)(81156014)(52116002)(5660300002)(81166006)(36756003)(8936002)(1076003)(26005)(53936002)(8676002)(7736002)(2906002)(102836004)(14454004)(386003)(6506007)(86362001)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4633;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1mYpnUTyXmjZuLS+4zlfQzQw/5+KvfQk8Jsn9oxhmPKZaRc0fcDhnYSX/2vUu1l7D5OU1L/LY8avWLF7QyvyLKuLwG4e4QyrbdiIX95TkeKd+E7QNejTRXeGBkajZunumpjnRqZgjyYqvNt2+dihzACszVv+0WzzxU028Uo4taO+EIeGeIIOvYgdKI/d97zSqJjlK52zJo9NaF1RWwTkuMqn1h5nAom4SwzqPdmsOOXnvHR1Kj5xkbRD+0smoEIYjZbD3aZ4XD4IdV1Db0cSTyf3hA4XiVeU3z3lTk6jxCGWVpEeIgMuXziVKKscuAwrBn883jSBF4MDrlmGG/c13UFQO3cgbFRJbaUGRkp+DaVFG7UIM3qvSW53D26+lw7jRxyiHcKtbzm8PzIUmI0+i6oVTtdcGvzu9Lprg+WoUJE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 426b27fb-3b78-435d-7dcb-08d72156a1ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 08:00:26.3003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y4xIPRR2QzbOj4vDy6CFREXV2N/ukW3PDdItEx9YXGcVqV5XZcdfQyWtyb3xtrxls6nWiPS5ykQhEdtkbxEwWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4633
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ECC(memory error detection and correction) mechanism can be
activated or not, controlled by the ECCDIS bit in CAN_MECR. When
disabled, updates on indications and reporting registers are stopped.
So if want to disable ECC completely, had better assert ECCDIS bit,
not just mask the related interrupts.

Fixes:cdce844865be("can: flexcan: add vf610 support for FlexCAN")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index def8cbbc04e8..6a48333b40c7 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1428,6 +1428,7 @@ static int flexcan_chip_start(struct net_device *dev)
 		reg_mecr =3D priv->read(&regs->mecr);
 		reg_mecr &=3D ~FLEXCAN_MECR_ECRWRDIS;
 		priv->write(reg_mecr, &regs->mecr);
+		reg_mecr |=3D FLEXCAN_MECR_ECCDIS;
 		reg_mecr &=3D ~(FLEXCAN_MECR_NCEFAFRZ | FLEXCAN_MECR_HANCEI_MSK |
 			      FLEXCAN_MECR_FANCEI_MSK);
 		priv->write(reg_mecr, &regs->mecr);
--=20
2.17.1

