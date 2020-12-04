Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3C72CF4B2
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 20:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730513AbgLDTYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 14:24:03 -0500
Received: from mail-eopbgr130055.outbound.protection.outlook.com ([40.107.13.55]:28803
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725923AbgLDTYD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 14:24:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ps8SxQKI5abiLBgHKFoYdsbOt0+5o7DGvhr1nZEauVmUsFZNl0HoQ6czDTpg9NCfxJL+Rc5t1iAmtsRuX76DOQWSqnDRHEMYeqtDVVoaXMP3a+BDB290jxr1QYqrzgdjK3Sie9kwIXNk+KKud3NryZew6dgHtutlm5JdkNvJhIjdt8i7db2Zzi+T47nbqOC9mClY6bmR50R3R9xAZRzLvQySzN+YW8DnfiplRi+1nBwPzLWqZ0lkfuDuc96+jRFNxFVFbi/qkMiSoPinI7LCGY7bmEU+ccA1tiTHFpP+BDSvDOzfNwLTT8h5GRNVCLgl0pxTrlFtvCu0/kzrpt3LyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eaj84btbwsXxtlggbs5LrjCI6kA0nXOlkHWTstii4Mo=;
 b=kZn87xDJIt0xEdLi3ufhZyzhiIjPNAQL8OGFSWDlh377rb9ZqKElH4ihAEFc3ay6ByktygSKBVbWqh104ILhg3gyxYrFstW24+T6a+4W3VXGzQXkSIw+s02avXz+95sT7AKtUx/eKThXnIceEKJ8zP/p463m3h5WnMEwgAkF2Q/K41lgYTudcCBplHJiOb3Ct7tFT6uvmgCGStdnzM/afFbHMpKVl4xCGEiMEFAZ3hZqO/5Bj3zq9/AGmCPy6uh2orys8Ys0EvCh9jTD/oGIiWp0hWG1cFxE5dasfMgEusKIZMF/4iLmcZA/Vmw8wmtWf7hwQnFG77Y5FO2HI4LV3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eaj84btbwsXxtlggbs5LrjCI6kA0nXOlkHWTstii4Mo=;
 b=mDimiIoKL/FfBBYpge04pj/zrpkB92OlRdI+NSkg/y8MQBGXKQDrAAQRM4HlqOa6Wdv79G/oqnp04tS384mzbM+HBDQx58ikAqiLvBma+x+3reZSzIiY+eMgs1Cb7A2ZMRkvBd6qGbFENF0pE2MRIDX2Uh994p118mbg/4ItLDc=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4911.eurprd04.prod.outlook.com (2603:10a6:803:56::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Fri, 4 Dec
 2020 19:23:12 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 19:23:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [PATCH v2 net] net: mscc: ocelot: install MAC addresses in
 .ndo_set_rx_mode from process context
Thread-Topic: [PATCH v2 net] net: mscc: ocelot: install MAC addresses in
 .ndo_set_rx_mode from process context
Thread-Index: AQHWymYcVtu/uzlPXESRU1bey3c5/qnnOd2AgAADfQCAAAvbAIAAB8wA
Date:   Fri, 4 Dec 2020 19:23:11 +0000
Message-ID: <20201204192310.al6fhkbarhbjng3a@skbuf>
References: <20201204175125.1444314-1-vladimir.oltean@nxp.com>
 <20201204100021.0b026725@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201204181250.t5d4hc7wis7pzqa2@skbuf>
 <20201204105516.1237a690@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204105516.1237a690@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ea6149b3-b842-4640-ef56-08d8988a0a7c
x-ms-traffictypediagnostic: VI1PR04MB4911:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB49110BE24604504CA0C4DE4CE0F10@VI1PR04MB4911.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 02Xp796TSfyjoCppYt45x2xVx0xcKzWQxqnZggeGhAAETLcQ88rbh8iwAhHOwTybvcAjT/w0uaffnNh0DrBPLb8rpTvyrZu+r8uDjC0jxjgtd2S3YQaCGgGq5opahYbmvpI2tTGWvxQU1ETG15bng4nwp4pQ00L9qtNQxyjSkmrjpBl7QC01NATWzuehqqcCckhhu1a/jF3MES8T1s1G0QODGEXMnEHAll1jsyLGSMxXB/CdaXYhIUMxzxVgm+UpF+qTXlFj2KhVg1pp7NARNRnX228zjwEBLmA6RCAoCcZQcOZeHeWMUrpNF09ynmWDrI2ZOr3s388uh2qy8F5wV3EAg2oshCH8IhOBYi6DTgmGuH4+2fMpp3O0j6vFVyfV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(346002)(136003)(396003)(376002)(39860400002)(8676002)(26005)(2906002)(186003)(7416002)(6916009)(478600001)(6486002)(64756008)(66476007)(66556008)(44832011)(66446008)(5660300002)(316002)(91956017)(71200400001)(76116006)(6512007)(1076003)(33716001)(8936002)(9686003)(86362001)(6506007)(4326008)(83380400001)(66946007)(54906003)(142923001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?NGgqX5x3pyP0wOrHvQtquySG3DrGdGkcaIYm8Zn+roZtePlT4rC0JVcRBqlV?=
 =?us-ascii?Q?ANf5NYLBefXwDDEPBr4C2AfL8HeT5CCIFUIHEftj6MVSKAC5LPnlpjpX/KXf?=
 =?us-ascii?Q?nDZpH2q2gHvv84wQqVRYozvIN8mxU6kImIRCZq2psQX3Ft+sUP6fZajJTTu8?=
 =?us-ascii?Q?NCRGBTbdubuACCxPHC85mje5RdjrsyUY9GwmcnqeWXYPyt6fT0u4/FMHlHCK?=
 =?us-ascii?Q?jNHJ6AZwHzBUVMUzd21uW6Mcpg9H9gFv5Omapp7AQg5lbvog+vxmZySoESx4?=
 =?us-ascii?Q?ji9u1gD9qiLwjNMVbyMoKzKwDBu2gBXR3Ga/4Ecr5ZBPEmnFmeFviDXAEL90?=
 =?us-ascii?Q?2mAohwAl2PgFlHSt41rxccy+v/3EK0yaLR/F8S3A6UXwL3H6O10NfOSalPXM?=
 =?us-ascii?Q?bbzPZ7X9giX49nG442ja+kGdglN5iTlWvS0lU74jUhM9umWJxjPElETtXttA?=
 =?us-ascii?Q?1Hkrs6wffDw1YphqeF98pT2kFb1+ygzmDkW4DyIWY5ftZ42ct299GqzyDaE9?=
 =?us-ascii?Q?sb2Xwa+VYZUT4qL2jM69bjg+ASgMu0NR4zqhSVd58arlUPVVhrqYxFuDvK1U?=
 =?us-ascii?Q?RyfhBUPRtZKfYrJsH9kkq+GAJNR91HTJranUHuxknx4tGg6Ecy9Ktpyb3Cj6?=
 =?us-ascii?Q?1P/exONRZdRk4nXCIAegMbV6KK4iaWMi6c1zt1z3gUTirEnXZnM4tvD+laTL?=
 =?us-ascii?Q?Ub2o5UWLZBz0vqjpuNSifkMq26ARzg9xVIK488VYfln9cu17LjXr9QL2J1EX?=
 =?us-ascii?Q?s44BnDEy8Gkrc8okCBST5u9Y9SchlN4MsYQgGRJFiKhZha8emZpcMA+uh8mB?=
 =?us-ascii?Q?QXlAS+Yis5BdlX+2OIcuXKrJTvj04vQABcfi8ME/ecPghBZiGnWFYmQaKyv2?=
 =?us-ascii?Q?snG6fj6YTJxpmpTm6qrfcr6v1NiEAto65MpyYJyNxaOfLD4J8tiY+b3MNO1x?=
 =?us-ascii?Q?Bmgpn3KONgcg3viQe5JElUu5UEfw/A9JqO4czCXtwiwbtCAnMOE409Vzq7l9?=
 =?us-ascii?Q?5u4v?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1A0B20193482844FBBD86F34A33679C9@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea6149b3-b842-4640-ef56-08d8988a0a7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 19:23:11.8875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GXZA67Y9f0c0b5xW3hA0tyhHvIDunhJu4rb+B4utsv6SS0WsGgTHNAd8P4V62USKz5Oe1N8i6Rjs7r6JT2MYHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4911
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 10:55:16AM -0800, Jakub Kicinski wrote:
> On Fri, 4 Dec 2020 18:12:51 +0000 Vladimir Oltean wrote:
> > On Fri, Dec 04, 2020 at 10:00:21AM -0800, Jakub Kicinski wrote:
> > > On Fri,  4 Dec 2020 19:51:25 +0200 Vladimir Oltean wrote:
> > > > Currently ocelot_set_rx_mode calls ocelot_mact_learn directly, whic=
h has
> > > > a very nice ocelot_mact_wait_for_completion at the end. Introduced =
in
> > > > commit 639c1b2625af ("net: mscc: ocelot: Register poll timeout shou=
ld be
> > > > wall time not attempts"), this function uses readx_poll_timeout whi=
ch
> > > > triggers a lot of lockdep warnings and is also dangerous to use fro=
m
> > > > atomic context, leading to lockups and panics.
> > > >
> > > > Steen Hegelund added a poll timeout of 100 ms for checking the MAC
> > > > table, a duration which is clearly absurd to poll in atomic context=
.
> > > > So we need to defer the MAC table access to process context, which =
we do
> > > > via a dynamically allocated workqueue which contains all there is t=
o
> > > > know about the MAC table operation it has to do.
> > > >
> > > > Fixes: 639c1b2625af ("net: mscc: ocelot: Register poll timeout shou=
ld be wall time not attempts")
> > > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > > > ---
> > > > Changes in v2:
> > > > - Added Fixes tag (it won't backport that far, but anyway)
> > > > - Using get_device and put_device to avoid racing with unbind
> > >
> > > Does get_device really protect you from unbind? I thought it only
> > > protects you from .release being called, IOW freeing struct device
> > > memory..
> >
> > Possibly.
> > I ran a bind && unbind loop for a while, and I couldn't trigger any
> > concurrency.
>
> You'd need to switch to a delayed work or add some other sleep for
> testing, maybe?

Ok, I'll test with a sleep in the worker task.

> > > More usual way of handling this would be allocating your own workqueu=
e
> > > and flushing that wq at the right point.
> >
> > Yeah, well I more or less deliberately lose track of the workqueue as
> > soon as ocelot_enqueue_mact_action is over, and that is by design. Ther=
e
> > is potentially more than one address to offload to the hardware in prog=
ress
> > at the same time, and any sort of serialization in .ndo_set_rx_mode (so
> > I could add the workqueue to a list of items to cancel on unbind)
> > would mean
> > (a) more complicated code
> > (b) more busy waiting
>
> Are you sure you're not confusing workqueue with a work entry?
>
> You can still put multiple work entries on the queue.

I am confused indeed. I will create an ordered_workqueue in ocelot and I
will flush it after unregistering the network interfaces and before
unbinding the device, when accesses to registers are still valid but
there is no further NDO that gets called.

> > > >  drivers/net/ethernet/mscc/ocelot_net.c | 83 ++++++++++++++++++++++=
+++-
> > > >  1 file changed, 80 insertions(+), 3 deletions(-)
> > >
> > > This is a little large for a rc7 fix :S
> >
> > Fine, net-next it is then.
>
> If this really is the fix we want, it's the fix we want, and it should
> go into net. We'll just need to test it very well is all.

Well, as I said, I don't care at all how far this patch will be backported.
I am not using the ocelot switchdev driver anyway (since I don't have
hardware that uses it), I just have a test vehicle that I use from time
to time to check that I don't introduce regressions in the various code
paths. And seeing lockdep give warnings is annoying. I am perfectly fine
with targeting v3 for net-next. I don't think even the AUTOSEL crew will
pick it up, since it's going to conflict with some refactoring.

> > > What's the expected poll time? maybe it's not that bad to busy wait?
> > > Clearly nobody noticed the issue in 2 years (you mention lockdep so
> > > not a "real" deadlock) which makes me think the wait can't be that lo=
ng?
> >
> > Not too much, but the sleep is there.
> > Also, all 3 of ocelot/felix/seville are memory-mapped devices. But I
> > heard from Alex a while ago that he intends to add support for a switch
> > managed over a slow bus like SPI, and to use the same regmap infrastruc=
ture.
> > That would mean that this problem would need to be resolved anyway.
>
> So it's MMIO but the other end is some firmware running on the device?

No. It's always register-based access, just that in some cases the
registers are directly memory-mapped for Linux, while in other cases
they are beyond an SPI bus. But there isn't any firmware in any case.=
