Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7A6010AA6D
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 06:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfK0F4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 00:56:48 -0500
Received: from mail-eopbgr00087.outbound.protection.outlook.com ([40.107.0.87]:58850
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726078AbfK0F4s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 00:56:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMo5qQmz5aG0kXd4O1KRF+i7EiM1amKdDxTU0RicAEOUqAoPPh4afpa5lEvAfyZVC5KZzBrNNoK2djT1EtQEgw4wEw61hD7Sc5/c0/9wS21PFM2FXbjZqh+WmfjPi4a/BqPSu1UGpB94TXKsjIsCbC9W2Ypb1eKOTN6bQDejpG4wCIzsZsMXMuR11lPbxqspNX8KgZXbLIOtZfMpzIzwC+0WdUiAvwxiRjmS0qvRz150dvn3VA7Ws4rcxJ/9hCNeXJHy0pnyw6YljrXvzJhedrS0IRpWHmjy5Zp7w7VROlvcn60TfiCkCNfZXVx/4uj+QsETYiSwVGPI36NHar/e6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=96qOFXmxpyREkYnYS8ukLPjT4eXHTEWFSlH2ZYLMufw=;
 b=j/6mhZafisX6xhDBZyP0MiOtHGlmDJkzZ4YQz8RHeQ3hShtU9gotj/3i9GANAdHjIkNOr2GRv23HMg58fyKCaIhd1RkyE9rWy0F8J4NNS04ZfGE7cGaXzbNLOZ1+FTxc4/93yblJF5GgUSL/nOftbD4H0MQmUhb2LtGKt6OVQnHCvM1iwNujnpxaf3xDDW9J1jimotYf6ekVcNbz0kYvgXlOnScs20b7QSPiXQagoWublmkDETfGu9Nv2QgjP1cHiX/4zpEGXu++hos7/gbmsp70dqQr8khenKhz+yS+LBNOelyLGR4zzHYz3CADw3nSAvRP36liuamD+IMBu7iwBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=96qOFXmxpyREkYnYS8ukLPjT4eXHTEWFSlH2ZYLMufw=;
 b=JOAdF5OpmfeKvJRy0C6lybC8P6GAKUUnWvYVhXOGRA7JUwHDREtES2A+BkL6wY3R3WcHq49nwY12C+sPbHrd39QTNI/FYfDZW1IZ6SU6GObxfbyDUq8qyuLwzOn47pCmTFSgYNAbUhF71gSmotXZlLuwqprPPugs+B/646QOoV4=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4409.eurprd04.prod.outlook.com (52.135.137.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.17; Wed, 27 Nov 2019 05:56:42 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 05:56:42 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V2 0/4] can: flexcan: fixes for stop mode
Thread-Topic: [PATCH V2 0/4] can: flexcan: fixes for stop mode
Thread-Index: AQHVpOdxXAI9W9cZiUqxHtJbOFpoGw==
Date:   Wed, 27 Nov 2019 05:56:42 +0000
Message-ID: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR03CA0089.apcprd03.prod.outlook.com
 (2603:1096:4:7c::17) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 031e3532-5822-4c46-b69e-08d772fe93e5
x-ms-traffictypediagnostic: DB7PR04MB4409:|DB7PR04MB4409:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4409F1427C56B2668AD5AE63E6440@DB7PR04MB4409.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(199004)(189003)(26005)(36756003)(110136005)(316002)(386003)(2906002)(66066001)(25786009)(50226002)(8676002)(2616005)(81156014)(8936002)(2501003)(66476007)(64756008)(66556008)(66446008)(99286004)(14454004)(256004)(14444005)(7736002)(52116002)(1076003)(4326008)(66946007)(102836004)(2201001)(3846002)(478600001)(86362001)(5660300002)(81166006)(305945005)(6436002)(6116002)(71200400001)(71190400001)(186003)(54906003)(6506007)(6486002)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4409;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wk+cGYS0OGzx9LcfuQ6kZH76u8uLP3nxWK3PO2Pta7+7VVb+KDVvIJ0VqCZ/K8CHDJiX7xF6KIeMBG/0H0xP/8+wBOGoDmMr+OHwuNZGdwuY9pXsRk7bHr7mkhEpiK8/jpZsQ2eQX2vcOxoGMgEPReD1uLCYPIYxmjcbfC+Efir6cPv/QW2v0SpLwO6Dhxh4QtMWi2q2yqBaURJ9ADWBJFFkXps+gYgoFy+S8U5b6It7KoXjGVGvEyFMDPs6AquPvrerqim5tftJHO/u/APT43urIHRWhy0Z4aCXqHnUm+aJgOUkRP4RmaE6UoVDWdRjwud6mvFIX/R8+pQYIF6SzDWiBsaM3yqGwBCvanxB5XH91a6ohN2lqBglhMpNzttxfqKiKtmLmPemYwvzMEKEeVkHmHhXS8Jp7Azy0wC6cRf004HYSmcKejXRC4761H9L
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 031e3532-5822-4c46-b69e-08d772fe93e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 05:56:42.7797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZjQkkiFfJA2RVc9vv3wL1roBCRCyMOli4farmbsZ2huKbFq02k+9QzpGS03sqH6Fj08vmdqKjNMiojKd5JegLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4409
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,
	Could you help check the patch set? With your suggestions, I
have cooked a patch to exit stop mode during probe stage.

	IMHO, I think this patch is unneed, now in flexcan driver,
enter stop mode when suspend, and then exit stop mode when resume.
AFAIK, as long as flexcan_suspend has been called, flexcan_resume will
be called, unless the system hang during suspend/resume. If so, only
code reset can activate OS again. Could you please tell me how does CAN
stucked in stop mode at your side?

	If indeed need, Why not check it in flexcan_open? Once we find
CAN is stuckd in stop mode, users can down->up CAN interface to get out of
stop mode. I think this could be more reasonable.

Joakim Zhang

Joakim Zhang (3):
  can: flexcan: try to exit stop mode during probe stage
  can: flexcan: change the way of stop mode acknowledgment
  can: flexcan: add LPSR mode support

Sean Nyekjaer (1):
  can: flexcan: fix deadlock when using self wakeup

 drivers/net/can/flexcan.c | 132 +++++++++++++++++++++++---------------
 1 file changed, 80 insertions(+), 52 deletions(-)

--=20
2.17.1

