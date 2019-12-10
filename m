Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6E8A118132
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 08:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfLJHQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 02:16:01 -0500
Received: from mail-eopbgr40048.outbound.protection.outlook.com ([40.107.4.48]:35970
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727310AbfLJHQA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 02:16:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SvMVkN8/YrC4/Jsk1A1x9k//cS70mr8td9ew5LzP/bzqb5LM38bIV3DhZOJf1Tb6FIrgZXlxd2gqsiLAKYli5HS2TdgV2E2qZahCnFvJtCkcjrWP5aJhjnYbu9OLRnW5ukMPaZ9ye/1SoB2d4qJVKrVMRCOcYbBUlo8bAjldkS9wJf72GkcN8TwC1b3ociG2JjiOLLSyD1tFjMmK4/KrtE8UtSa1If81ErD+l8mAtx4sGSQlVHAr2xdhtjjsRDowQZuFF5WVJZntLmVKFK/Equ7adn4D80ZK0DYW9oI4PnSw0QSBO2ZFBPOu8eezMsvQW7Km/+oljbUXLJLK82GMJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OU3cl4CYr5J5CK1SSrVRR50c2baAuOJe+BPpaeqXjQk=;
 b=bcHr84sd1wT7JYxnenyylMehmpiKZvYJrDyF7aPqDq7FMxoDKecTo6OmBp0gN+56M91s9Kj5c/RvTjdk7cttPWy4FpnYlJJRI2Re7Z9iDfwpmbeKsPr6TzFoN2gRR3VBW/PGI3GveJSm/BIrqfFmGr/5PIQJ6i+kStNHyp4r+4SQ5OtKvtdQ6KAQ7oaqDBzWo7EHNXpnoPgDIdLe/hOd7VGmjxVT5iH1VyHJiM80sy3EJn3RcyXr5VkkonYAOuz4g6Bqam02r5FCn82FXABD4C60Ulw8ci9fuJgK2dQMylKvBfC2j7Y89GaVs7JNbhHm2BecOhfQpKfkEvOwEaig6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OU3cl4CYr5J5CK1SSrVRR50c2baAuOJe+BPpaeqXjQk=;
 b=m2G9M2rEgF0DzpAXNAGXwRafkYBkeIPwJV9C+FI7YBTY1tyk24lltSirb1Rj0ExN2QB8KoJ9yZekwMm/eIP0dBEfC+7Vmz4eLDORgF48udP3/WRBxQVkVIqRe7uDDvSk53bt8hGGNUNjstN/O+MuvgaJxUY/NI7WXu2ZlZmOqPY=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5340.eurprd04.prod.outlook.com (52.135.131.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Tue, 10 Dec 2019 07:15:57 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 07:15:57 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH 1/2] can: flexcan: disable runtime PM if register flexcandev
 failed
Thread-Topic: [PATCH 1/2] can: flexcan: disable runtime PM if register
 flexcandev failed
Thread-Index: AQHVrymrYtp7RILkH0KPmOsSLzpHxQ==
Date:   Tue, 10 Dec 2019 07:15:57 +0000
Message-ID: <20191210071252.26165-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR02CA0119.apcprd02.prod.outlook.com
 (2603:1096:4:92::35) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0a7107b9-c9b9-4420-96e5-08d77d40cd66
x-ms-traffictypediagnostic: DB7PR04MB5340:|DB7PR04MB5340:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB53403EEE914B5F87AAA021C8E65B0@DB7PR04MB5340.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:392;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(189003)(199004)(5660300002)(8936002)(6512007)(186003)(81166006)(81156014)(2906002)(8676002)(71200400001)(26005)(54906003)(52116002)(316002)(71190400001)(4326008)(305945005)(86362001)(66446008)(66556008)(66476007)(4744005)(478600001)(110136005)(64756008)(66946007)(6486002)(36756003)(6506007)(2616005)(1076003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5340;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TfvT156udW1/0I1OIyW4l1TOQHvm2geaYwRsBsdkYED2jAjGqIQk1iJC8s/SdjjwOvb4hbDA1WNegcpDUHyGXA63+9LiP9e9nhHcqqMYNCMqwlBvjke/CLZ/iU7Ad7SXM+yAOuCePOhnN7uNywT6vtNAuMKwvh2Zx7DuZZ6yQn7wBNiTsPZMfd+Hy+9m1rz94kIpVJyRLaEcylF5W+6xvxLJnYn5lnspIHHUHQtLQaUs87nKQVOTyF871jO2FVFJJ0hs9KotDCbG4AI8yWec3Sm7jaEDQFpGQJO82vg2ESHJs7WXbzzsKsZK1wXceKNOOAsNpyeqn0hwYnMcWL2IDWao2QRp6rEzVlpu9u7UQP6PMWBX6w9VSWwUDAuF/eyEIFUoiS7am5SY5l2ZFDrzazXNw9ZrLJWgPdKNxs2YD7M09s4YPPtHd/y4/1GmuCMh
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a7107b9-c9b9-4420-96e5-08d77d40cd66
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 07:15:57.7173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FoIiZu4ZfudiXKYwXT+zymB7t7vib9fDPrb788IoeoFp17Gj7FGW1uaGhAtAxYcOMI851UvmUV/tCC7xH/q1AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5340
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Had better disable runtime PM if register flexcandev failed.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 3a754355ebe6..6c1ccf9f6c08 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1681,6 +1681,8 @@ static int flexcan_probe(struct platform_device *pdev=
)
 	return 0;
=20
  failed_register:
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 	free_candev(dev);
 	return err;
 }
--=20
2.17.1

