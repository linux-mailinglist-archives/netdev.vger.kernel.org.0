Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5852CF3B5
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgLDSNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:13:41 -0500
Received: from mail-eopbgr70041.outbound.protection.outlook.com ([40.107.7.41]:22142
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727901AbgLDSNl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 13:13:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fqKSQKNWu0Kc6GFkrojcutljc3pFYUVVAItYYjgNWyXc/4WZOBQGytjeLIq/XTiWPS/tYpw2ugknfmVrhSC9+6Rw1AWwt9rcn1w0kr5I1U8xb/PmLTsD6lcn0mufpE6Dos6nGCCvT57p86Ajmw5jh836GVLTYgGGm4ilfooiMV+1srWv3Jca1VABo8CMpl9NJHIL9oMRFsn82QWASuaWQf6B8lX/prYEr5AHKFvZS9KVS+Unnfp1aNU3OLtHJ7W3HKNrfuX7lUh3L07O7P04DcDJvlE4RmTOvDdpy9UA74Wc0jj6+/jOzfSBd18honIMmpro1NH57HcVgFtlQYMIpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Ku/CPgHoI+kCA/hCcJtrJfqmzRsGLh1W7OCisHiXiI=;
 b=NSAFSZdjRvvo+YSHbCgg+dhT05zmTvPbreT/G3ZfsQT+yOlAExtLdYOKADAF6sq8Wsjg0dhTbN0CqtJpDsaqjDA2x+lTOEffFP0nGclS9CDbJ7m5ILtaMQ6P4EoJSMcB4N24XRKVplqyFxoJHZgO20lXKecMF5Wb307uzwasVZSh0OjrJLLVYMJzPYTW8qr9GKgvcePVnaHBMxXm89lp8775l6Ji3o0GuaNuY6H9WHJW0z+/agncX0MoFknBpNGx0LFHx5Rx0/ADjvA5Jlyb+Y54iJKOE+q76CNZjvPXBm4VNgz1wfpBHqB2gtvXwmerqEHB9BhXC1/SA7W4dJaz8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Ku/CPgHoI+kCA/hCcJtrJfqmzRsGLh1W7OCisHiXiI=;
 b=N/gX2qcLXIdmqu02It5SaXLnOS2hm6jaCyiX1PkbR7v/3xCgXpPII352n3yYlfhnOZg7sQKZOc1Se9i4SyYAklTeYMw4IAHt4RWHL2zX4GJrt4yuIoDdlzixvgpEQ+zzOQpNEoLez4Mf+DyWwll5Bl0f8axctwav2uog8YIeDHU=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6638.eurprd04.prod.outlook.com (2603:10a6:803:119::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Fri, 4 Dec
 2020 18:12:51 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 18:12:51 +0000
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
Thread-Index: AQHWymYcVtu/uzlPXESRU1bey3c5/qnnOd2AgAADfQA=
Date:   Fri, 4 Dec 2020 18:12:51 +0000
Message-ID: <20201204181250.t5d4hc7wis7pzqa2@skbuf>
References: <20201204175125.1444314-1-vladimir.oltean@nxp.com>
 <20201204100021.0b026725@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204100021.0b026725@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e527ce76-ce33-4aae-71a7-08d8988036ad
x-ms-traffictypediagnostic: VE1PR04MB6638:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6638E6F4754D901E7CA5C980E0F10@VE1PR04MB6638.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nE3FMKA4qjLIDctOpCCt10R221o90ZV51yy6vqxvvaABkR1Soxph63VhAmsJnRgPmpV2NszD4xwGlvk4IeFDUoZ+TXBselFHUOAN/HC9IsLw0Mp4SCey820+O3Eil6ipJrIEgwDgm+qa7Cj7m7rUXr+nprcL6iavjskDBYJRutniIKyNl29hlgDhh15PQiMl2d/H/l4f8gFBwqHpdBQPA5NgWu1+nh8A3fmrXZ1i12gnDgHwdPPla4n7AM5RbtJ5GPzGhDPJjmDWI80ZaiRMLRsAq0Cyg9zpYCPFztkgoWUbOGo7CnRWRIZO8ItE1Fy51hvkm0WVgcFczcQF42t/Wy6fH/EKuhlt0SKYM3KI4KZrNHBk3tduacvEMh45maJg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(39860400002)(376002)(396003)(136003)(346002)(478600001)(5660300002)(44832011)(4326008)(83380400001)(54906003)(316002)(6506007)(186003)(26005)(71200400001)(6512007)(1076003)(7416002)(9686003)(6486002)(6916009)(33716001)(8936002)(76116006)(8676002)(66946007)(91956017)(2906002)(66476007)(66446008)(66556008)(64756008)(86362001)(142923001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?JSisbjf+tPC26TuiE4b8Fghhn5VBq2mYiIzzir63pCuTl8seM59V5vKCq+sa?=
 =?us-ascii?Q?YRiGbEIUXNsDHk7x8AHKvBUQc/ydf/Pna06qcqo60omcUI46de4yA3LjDwh1?=
 =?us-ascii?Q?+4djFpWod1HgDQ4qMgcxQPXZOmVATjw070qWB6KMj0L5A3AnWUkenLAjxL10?=
 =?us-ascii?Q?wt5BRz+SdGYd8iXWyub9iCRhVm049FU5wsleF16pnObwFLeSJsxZe74Jkej4?=
 =?us-ascii?Q?hbWcklw5f+Wxbc/qpXVMICR2vRgZfSVS2FxIKM7HQEHxBmgQV51zLENhR7CJ?=
 =?us-ascii?Q?NRwIWzXCX4FjpUwDicSWdaojVw9TKeLfNkKweNMG4VSuV287+26LX8nph0hg?=
 =?us-ascii?Q?RhqsEecYMcWImAFZrexPRjkc7Dap0cxmSmSEvL638t2SX+DzAImCk/mj5omf?=
 =?us-ascii?Q?NUhXQ8igcaFmaZPVWMKUFSIg9SVxZU66428kmT9T1Yln3FF/bfy/SV5Y0mYF?=
 =?us-ascii?Q?dW5q/cq0WfqQj7FjfBz4BrvLOSdHV+IZ0okFme95MSEd+yJ6vmHLgUSTLJ/X?=
 =?us-ascii?Q?9DjnUHs3xSEuSBl5ouOAsCYhwEUExvjQVli7LA8RHqo83rmvtIKm3pDugcSj?=
 =?us-ascii?Q?gswlQdd7SVxZKEu+NEwt5cF9gqMnXLoeBl1L2GzYRUnydtjvQ7OnnuIp+fvC?=
 =?us-ascii?Q?1/Sym2hrE3wEd8eUQqkSUAThh2+kxUQg/6BGxdHxnu+Q5nAe8YXHHg7Yc78/?=
 =?us-ascii?Q?F7l1MvmVix1hIC5RXxUfZM9H52YDNXHkFxKt0ld7JWGoZSHZ7El3sH+lW12t?=
 =?us-ascii?Q?MXlvqY2oALQYa1kaa2UI7AlbCX+uIP8k752qe53Xo3wuvlBx1c5uqgYHGJfk?=
 =?us-ascii?Q?RtjSWNAUuJABsXfGTiu2L6BJ2gug3rVk2Ykz8WbGTcqGQYFTok2suc0trTbG?=
 =?us-ascii?Q?PVLUkJzvvW+1uCPv1D2rBeoIAk5pdap0H4c0rrNcOEFPsas0ydg4daYksAXW?=
 =?us-ascii?Q?4ypscp7ETIrmoQbLLsKBxkbFTNfNM4NRPjp8KAoPknZSDaHJvIgBjO3f2zTg?=
 =?us-ascii?Q?ikIu?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <381AAB0CC6904B469DC828CBA7A297E2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e527ce76-ce33-4aae-71a7-08d8988036ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 18:12:51.2368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SK3xPTndyTRX511SzWbDWRcYbaQELEasw61vn3qCWSXS1LRsmIsn4EgTSp9nYrpfDL9uDfRbBGQ+uXmjpu3Xmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6638
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 10:00:21AM -0800, Jakub Kicinski wrote:
> On Fri,  4 Dec 2020 19:51:25 +0200 Vladimir Oltean wrote:
> > Currently ocelot_set_rx_mode calls ocelot_mact_learn directly, which ha=
s
> > a very nice ocelot_mact_wait_for_completion at the end. Introduced in
> > commit 639c1b2625af ("net: mscc: ocelot: Register poll timeout should b=
e
> > wall time not attempts"), this function uses readx_poll_timeout which
> > triggers a lot of lockdep warnings and is also dangerous to use from
> > atomic context, leading to lockups and panics.
> >
> > Steen Hegelund added a poll timeout of 100 ms for checking the MAC
> > table, a duration which is clearly absurd to poll in atomic context.
> > So we need to defer the MAC table access to process context, which we d=
o
> > via a dynamically allocated workqueue which contains all there is to
> > know about the MAC table operation it has to do.
> >
> > Fixes: 639c1b2625af ("net: mscc: ocelot: Register poll timeout should b=
e wall time not attempts")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > ---
> > Changes in v2:
> > - Added Fixes tag (it won't backport that far, but anyway)
> > - Using get_device and put_device to avoid racing with unbind
>
> Does get_device really protect you from unbind? I thought it only
> protects you from .release being called, IOW freeing struct device
> memory..

Possibly.
I ran a bind && unbind loop for a while, and I couldn't trigger any
concurrency.

> More usual way of handling this would be allocating your own workqueue
> and flushing that wq at the right point.

Yeah, well I more or less deliberately lose track of the workqueue as
soon as ocelot_enqueue_mact_action is over, and that is by design. There
is potentially more than one address to offload to the hardware in progress
at the same time, and any sort of serialization in .ndo_set_rx_mode (so
I could add the workqueue to a list of items to cancel on unbind)
would mean
(a) more complicated code
(b) more busy waiting

> >  drivers/net/ethernet/mscc/ocelot_net.c | 83 +++++++++++++++++++++++++-
> >  1 file changed, 80 insertions(+), 3 deletions(-)
>
> This is a little large for a rc7 fix :S

Fine, net-next it is then.

> What's the expected poll time? maybe it's not that bad to busy wait?
> Clearly nobody noticed the issue in 2 years (you mention lockdep so
> not a "real" deadlock) which makes me think the wait can't be that long?

Not too much, but the sleep is there.
Also, all 3 of ocelot/felix/seville are memory-mapped devices. But I
heard from Alex a while ago that he intends to add support for a switch
managed over a slow bus like SPI, and to use the same regmap infrastructure=
.
That would mean that this problem would need to be resolved anyway.

> Also for a reference - there are drivers out there with busy poll
> timeout of seconds :/

Yeah, not sure if that tells me anything. I prefer avoiding that from
atomic context, because our cyclictest numbers are not that great anyway,
the last thing I want is to make them worse.=
