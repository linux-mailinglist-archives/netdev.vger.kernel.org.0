Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694E6FA666
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfKMBu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:50:27 -0500
Received: from mail-eopbgr10059.outbound.protection.outlook.com ([40.107.1.59]:15077
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726957AbfKMBu1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:50:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gp3L4a1AwrHW38E1TEr7uE++U+IrYH34yp2I2oMJjhAaSlwlXjDkZ5M6T6D57Y9DynrMDbp0/ZO5XFkOj8/Evi514mq5XvyAq7mQ47S9Fb1xqJfOdAO8dPWHfNoGZSwF9u/Hsp2xiOXP7Fls7JjMy5raxHiAE4Zg/Q2z7goJp4ttscibzBa2oRB8VrI8au7BjjYdaAmFzKJ+KdLPrk5zvQJvBAJYl9yKsm/DALIOfogLmitMWT9tXkSBDTUwGi8/a9u5vYJDInFeE8EERMZPo4ddoN+mqReLGICDnkCtaZmWoLc4/7pc5Av5cu6M2zdY+umMPghAjph+nLEVETzrZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHk3CG0jpzB0BVFt7309RiLh2hPBXlsMVzkAva5CXPE=;
 b=bM6B2uf6ChKL03jJwOFeGpxdlnq3h/NB3+EgYK59jvMN8swFXCWXYev0+hz5S9GOWM7hYnZgoT0ZRZaIecz/7sD3PdaXOOKAa3S6M22bx/4Gzw8YDqQ6Acs6/zYGmcDDSd0/B1wxPlTirbshEohPNb/o/S5RHhDRHmqwIaPgT7G+taAvX1UrIafsLVZO8arP5MHImoqoP1Ow0C/+sKWW9EenMxUsO4vlWZTffWj1qDmBkWHkSdTqLj3JMXOn5ZA/Lqs3IdLerXaSJ3aZQQnU4QUplNe4MMWI4mteT81ZzFKATxG7qdc8kttFtBabqh65WoLug6QYMVn/kDewJ+adJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHk3CG0jpzB0BVFt7309RiLh2hPBXlsMVzkAva5CXPE=;
 b=d1z08vAr510PrD75W3tDuKjn+90q6pK30ChkTiV82+6+o2nMuyyvTBrGyvgwosgX4CaBU0Si1L/SAcK+IsN+V2wb7Pu5R1gLJ5FdtWjnL3RThIDRwpCeG/DhJCx92bQEVcIzMhJIQer3bDBg/3I9G2juNXR7uJ/k1RIzYh8t6PI=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB3326.eurprd04.prod.outlook.com (52.134.4.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Wed, 13 Nov 2019 01:50:21 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::30e0:6638:e97c:e625]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::30e0:6638:e97c:e625%7]) with mapi id 15.20.2451.023; Wed, 13 Nov 2019
 01:50:21 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     David Miller <davem@davemloft.net>,
        "hslester96@gmail.com" <hslester96@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net v2] net: fec: add a check for CONFIG_PM to
 avoid clock count mis-match
Thread-Topic: [EXT] Re: [PATCH net v2] net: fec: add a check for CONFIG_PM to
 avoid clock count mis-match
Thread-Index: AQHVmY1BH6t5qwWOm0C3UJ3j4V7y5KeIUOgA
Date:   Wed, 13 Nov 2019 01:50:20 +0000
Message-ID: <VI1PR0402MB36002AEF160536CBD8121554FF760@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20191112112830.27561-1-hslester96@gmail.com>
 <20191112.111318.1764384720609728917.davem@davemloft.net>
In-Reply-To: <20191112.111318.1764384720609728917.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f67f55fd-80fc-4fbd-bac9-08d767dbd7ab
x-ms-traffictypediagnostic: VI1PR0402MB3326:
x-microsoft-antispam-prvs: <VI1PR0402MB332600885FEB78D8CC77FD0CFF760@VI1PR0402MB3326.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(396003)(366004)(39860400002)(199004)(189003)(25786009)(2501003)(14454004)(5660300002)(478600001)(6116002)(52536014)(6436002)(3846002)(4326008)(6246003)(229853002)(66476007)(66556008)(9686003)(66946007)(64756008)(66446008)(76116006)(55016002)(71200400001)(486006)(99286004)(71190400001)(446003)(256004)(14444005)(66066001)(11346002)(54906003)(81166006)(26005)(102836004)(8676002)(110136005)(8936002)(476003)(74316002)(186003)(7696005)(76176011)(33656002)(6506007)(7736002)(86362001)(316002)(81156014)(305945005)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3326;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: puxUJRkj5O6wnGbYwtIOUCypHCg7jPhQ5v5o+pYO6GF2EX2uoYrucN4UBSfUtRdosISjrSe0SOL3zl2ma2ryubMQr7ZuQx4HJ+lA89TEUoHkqdz1a+ah2T37+rIQDhllkO76jOaBeekt+qX+k1XYTCspguBOGyVm1vC1QVk1cri1lFcnkJcolE2UNEikYOhUAj6+Gh1W54FYyWWC3/zjhHBQby+jlUwuKskGDt/VptIa9G8W7TCZ5wcEQT1we7R6rjCWxLsDXnIxdtkQsMQpV8aAOnaaoozWwloadl4D71WrtU62BkB6edLB9wmrJLEd6ZyqAuLK5R1CTKAcMaIxyq43GpYj2ygRi42bVQWE+Mt0pF0XJtzLqC2X0QkDlk2KeThMTfMUGDx60evdCdR5M5ax79tjofuzQag6iqKul7TLAc9m6Skmmm0/g4qMdfZs
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f67f55fd-80fc-4fbd-bac9-08d767dbd7ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 01:50:20.9659
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p/ZcPltEggKV+/4HWrXnpSgx39/rg+c0T5UixVI0pH3vRsJQ0X2OrfZXsRAX2Yp+RLr39abzujiry8cnauvQiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3326
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net> Sent: Wednesday, November 13, 2019=
 3:13 AM
> From: Chuhong Yuan <hslester96@gmail.com>
> Date: Tue, 12 Nov 2019 19:28:30 +0800
>=20
> > If CONFIG_PM is enabled, runtime pm will work and call runtime_suspend
> > automatically to disable clks.
> > Therefore, remove only needs to disable clks when CONFIG_PM is disabled=
.
> > Add this check to avoid clock count mis-match caused by double-disable.
> >
> > Fixes: c43eab3eddb4 ("net: fec: add missed clk_disable_unprepare in
> > remove")
> > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
>=20
> I don't understand this at all.
>=20
> The clk disables here match the unconditional clk enables in the probe
> function.
>=20
> And that is how this is supposed to work, probe enables match remove
> disables.  And suspend disables match resume enables.
>=20
> Why isn't the probe enable taking the correct count, which the remove
> function must match with an appropriate disable?  There is no CONFIG_PM
> guarding the probe time clk enables.

Current driver runtime pm callback enable/disable clk_ipg/clk_ahb two clks.
CONFIG_PM is a optional config, if CONFIG_PM is disabled, runtime callbacks=
 will
Not be called.
The driver enable clk_ipg/clk_ahb two clks during probe, and depends runtim=
e
suspend to disable the two clks if CONFIG_PM is enabled.

In driver remove() also need to disable the two clks if CONIFG_PM is disabl=
ed.
So the patch c43eab3eddb4 ("net: fec: add missed clk_disable_unprepare in e=
move")
target the fixes if CONFIG_PM is not enabled, but the patch ignore to check=
 the=20
CONFIG_PM that make clock count mismatch in CONFIG_PM enabled case.

Andy
