Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A33EF112A40
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 12:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbfLDLgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 06:36:08 -0500
Received: from mail-eopbgr140074.outbound.protection.outlook.com ([40.107.14.74]:18334
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727445AbfLDLgI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 06:36:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHPFBRguUT2Xj8OdKh704jaPXTQJVmXgG+mSVppJz/hhnRjOivFfonc5gHAyC0PPetM+1RIZTRM57t02aQdavQn5ttPfdi7Z+8lj9xxuAIRtnbfS8O6LYuLXuDKRWa41y5KlCwQo61zf9A4Dx4Nhe7IacNLF7PKmTn4hYQXWLH3VCckWuJfsP0sKFEEtXeQQoNOLpsYS0ZK9IOkdMF7y4gnICbTLcPA4+9c+FHHKOd413q1H+GiJ176EUtNalKoamFjg4zMumH6fyNdqHP7k0wKtCfd1bkSuWMS88hNF6VWBeOHv/CoEmOEGmZAouwTgfoCKnL7yb6csfO3j4FrVxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWeSGITK13b36wWl8Ot8yAaRa4ZxAGVf64VUVvW/X6k=;
 b=IEFz5A16wySwjijZAHB8zKWP/fJ00JKbDtgayRAKpYtVUyHDz4rCVji9CGu3r0k0hJZaSQTLdr9H7WAp+DnmBXtcxm6ogzUj20ryP1NfjD94eQv79LhDaKMn9mLkhhisHyQhKB0zx5N0bDmxVpIlQokGmo1qBrieWQFcVRC3sFqQEsCblTi4O8jX6Q2c456Dx4Ez2rS+yH/GLx2cprILs6fWVwIDzffoPKw7lnHo6XhTSSjpIscCZVRNPX1EwOaOavLTEuEBEC8YjX3Garfer0DNvvNUDlceYWKdIJdOTiDtsMnW16D88tfPtm2TRp2qUUfQp1szRN22IPEDWw3Dhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWeSGITK13b36wWl8Ot8yAaRa4ZxAGVf64VUVvW/X6k=;
 b=Hs0BL+SuqINr6ae84etWINwhZo7fueHbWfbTm+/ZIIuPP3OvgWWcEDWHce63hHnZ29oqt0tXjkp5WePM+Dc5/kGz+Ar/oKigruAmwd9DdRzMrY971z35pHnLZt7Z37RYxLcj77kp1djgbcgkHKFK6oJmXC6nEX2oj9Nfx3dsFOI=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5017.eurprd04.prod.outlook.com (20.176.234.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Wed, 4 Dec 2019 11:36:04 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 11:36:04 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V3 0/6] can: flexcan: fixes for stop mode
Thread-Topic: [PATCH V3 0/6] can: flexcan: fixes for stop mode
Thread-Index: AQHVqpcC9+9ZZuOr5E+r+rwXW/eLZA==
Date:   Wed, 4 Dec 2019 11:36:03 +0000
Message-ID: <20191204113249.3381-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR02CA0050.apcprd02.prod.outlook.com
 (2603:1096:4:54::14) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 69772538-82de-4502-7d1c-08d778ae24ef
x-ms-traffictypediagnostic: DB7PR04MB5017:|DB7PR04MB5017:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5017232297C03693AF54CFD9E65D0@DB7PR04MB5017.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(199004)(189003)(3846002)(316002)(36756003)(6512007)(305945005)(2201001)(6486002)(6436002)(2906002)(7736002)(52116002)(71190400001)(71200400001)(110136005)(6116002)(478600001)(14454004)(81166006)(99286004)(6506007)(102836004)(26005)(25786009)(1076003)(186003)(2501003)(81156014)(2616005)(8936002)(5660300002)(8676002)(50226002)(64756008)(4326008)(4744005)(66446008)(66946007)(66556008)(66476007)(86362001)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5017;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RHtwLCmy5KyGpTIXtK9p59RD2LJ30cIZdedt6ty/A2UsK1TdQ/zu/ofwotQ89qG9RVZF2g10b9TSNZ2oeTa8cR3j7+ipun2Ijv6qhd+JjwaiaZERB2xJn39K2kyhLE0G+9br0yUi5rW+gk03S6AKUMwWt7qAWRlXcHaJsALlC3asVFnXV+faIS59wkmFehg0F0DkrL4fPTDa07mVJ5PNSnDcDhKr1DN6n7mv9yqedhaR5peiJ4U6RnPQ2C4CSLYQFmRixb/uq86n64LVW8YxGcytCeBmSwsKxsXpHrd7SC3YUpY5/3YuKrMwENuviA4wbZHs3gckiVR4sBhcBmWSR2AK2aVcbFV94uuuLU8Xhe31t3qHlltSqe9lQR1cdTDBIG6rR4JsEXfb63AWQjkKaTyAxePcNVgt1mqjmr3Ytl6DZFMhM7byFkdwAkahkfKf
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69772538-82de-4502-7d1c-08d778ae24ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 11:36:03.8720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E+1BxOU9ouA4lFBcntj1IK5in8lT5yqAkye2n9GMzI4Rg/6YOUsUlG+U478/5EclBFvQYnE0AZldOBJdGOyOww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5017
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

   I removed the patch (can: flexcan: try to exit stop mode during probe st=
age)
out of this patch set for now. This patch should further discuss with Sean =
and
I will prepare it according to final conclusion. Thanks.

Regards,
Joakim Zhang

Joakim Zhang (5):
  can: flexcan: Ack wakeup interrupt separately
  can: flexcan: add low power enter/exit acknowledgment helper
  can: flexcan: change the way of stop mode acknowledgment
  can: flexcan: propagate error value of flexcan_chip_stop()
  can: flexcan: add LPSR mode support

Sean Nyekjaer (1):
  can: flexcan: fix deadlock when using self wakeup

 drivers/net/can/flexcan.c | 131 +++++++++++++++++++++++---------------
 1 file changed, 79 insertions(+), 52 deletions(-)

--=20
2.17.1

