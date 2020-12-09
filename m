Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1962D387F
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 02:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgLIB5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 20:57:05 -0500
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:46855
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725940AbgLIB5E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 20:57:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=buMeam9NzNV0wRIRGHG3ClEfT2j38y+wSRKGEOEG4oh2/EAVk5L4slk+HToSINK3Qb44zTHIw5iq//uZ25XQ3Fjcxf88JMfgijVU7OPOuM/CSWM7m3HjqdzErqlvhtjph7g1VLOLGDTkCbD96SOI+w/QPmtGtvdpo9fPL1DKwr3Lh/BVY5tsKyD1Huahsde3VDoA7K1QTiXjx6lmzO3ET8QjhJoGYeVgyDnxACtqV8W2vQoLLf4vVvhqzQzWSpZF/1QNuD3B/D9MKocukKUHW3ADylSx4RqMjHXy92OvpPENNsrA44R4lQo4gYmLthZ9JYntxNUnY9WSdQRX20ORyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mI8c6djPMNA1FjhZP0uBX59UwlYG7WkmX7pu6rD+aA=;
 b=iGrhcdllgUOMSHCw4MigqHdJcVJyuJoKrTzH5zs+pH98G0bJo1dJ85leqLe6U3xPK72u9T3wcjgjhK3/oCqYCz+pRsroR4981eSFzw7NTtgMevC0aen8xUDRfJkbf2X9uSHFdm49LejO3vaRsu6xowdSccfKu1d2s+M7uj7nxWQU0mjBZxQSAyzHDDauLsqdU3Azmg0fK0uvaBocIZI88eJR6MCN6MNMWjfVI4q4mo8W4t/Qa2LP2ltBvulp8CbvDb4Pb+ybEas2tY07nWce0kTuHzX1YfXzN2yZAdsCe+XV17K9JLfIAZ/ooW9/HuvDFaHq54keTg0/61OoGsE8mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mI8c6djPMNA1FjhZP0uBX59UwlYG7WkmX7pu6rD+aA=;
 b=HXGa9HcXWN89zSxmUF1ohGJfJoA0BxYk46MEgmEP1GQiV+s2k6rFaGzgmHtEOpbNvAsMK+YYwT/Z4wgK3Hk/yAjfjc41AnvyyxbZz5tDRmQP5dAVzx/ZP8tUdC8/Tizx8LpuvsRSCXm1ErAIXhQFnxc8tCG+ligvYpczNeeijKU=
Received: from AM6PR04MB5685.eurprd04.prod.outlook.com (2603:10a6:20b:a4::30)
 by AM6PR04MB4726.eurprd04.prod.outlook.com (2603:10a6:20b:2::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Wed, 9 Dec
 2020 01:56:14 +0000
Received: from AM6PR04MB5685.eurprd04.prod.outlook.com
 ([fe80::5a9:9a3e:fa04:8f66]) by AM6PR04MB5685.eurprd04.prod.outlook.com
 ([fe80::5a9:9a3e:fa04:8f66%3]) with mapi id 15.20.3654.013; Wed, 9 Dec 2020
 01:56:14 +0000
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
Subject: Re: [PATCH v3 net-next] net: mscc: ocelot: install MAC addresses in
 .ndo_set_rx_mode from process context
Thread-Topic: [PATCH v3 net-next] net: mscc: ocelot: install MAC addresses in
 .ndo_set_rx_mode from process context
Thread-Index: AQHWyp+kgwXKmgbOi0SfqtB/2FGclqnsaFiAgAGfWoA=
Date:   Wed, 9 Dec 2020 01:56:14 +0000
Message-ID: <20201209015613.b35hn6u4jgd5afb4@skbuf>
References: <20201205004315.143851-1-vladimir.oltean@nxp.com>
 <20201207170937.2bed0b40@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201207170937.2bed0b40@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 36b6e935-ecf7-4bf2-b71f-08d89be59c69
x-ms-traffictypediagnostic: AM6PR04MB4726:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB4726B36DBEDCCFC03A308E72E0CC0@AM6PR04MB4726.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u3OLId8R6y6WZywhurVDL8LqNgbXlPhfR1i5gFgV1EWFyiYMEfjA5ioY0gUi6ATkcbWZc0eZi/3Dyr1lLLC6EOqm16YS8Xm+NTLQEOTJKkH/Cw0ChGQfSqG5/wM/fJfwCO8+q1EZRj+36yBfM5tNGPDwdUkZ7IbRYT7UF4Y2ujjIhD7snlgiAmNr2+zdrpgsMJyE0PJLV+7UomImtztFmfjwkpqkaAC28n8d3q5grprdbHL/JOKuXhpgOg6Huprcd12mSip++spfblYKbnpHPp8H1MYPXgQV0768imrljrWX/BnEoEyAmFYHGLmldDGlrFg1ozm9UGM/58gVbh1fjcUX4xFRJps6ti9NexnmdxP6aoqS1/j9JZBMyGIarKpg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5685.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(366004)(346002)(376002)(66476007)(91956017)(7416002)(76116006)(5660300002)(186003)(83380400001)(6486002)(26005)(6916009)(8936002)(71200400001)(66446008)(64756008)(66946007)(8676002)(66556008)(33716001)(2906002)(6506007)(4326008)(9686003)(86362001)(508600001)(6512007)(1076003)(54906003)(44832011)(142923001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?+iCy/toNHVdUYp38Rcc9ZiwL/nG5A5jXK+CnHuU7EUafgOJflOuu/Bh3+qf9?=
 =?us-ascii?Q?Yr8/ssg4rFMRsBFgabVMiu9ct7Oap3gk4EUHdEV6Lep8NuOptfKPxIIM9CNA?=
 =?us-ascii?Q?SXwMLIatiI+s3TQaqFRiyd/korr8YgE7CALARtbOpmpaBpKrd+LDUKWR6JU7?=
 =?us-ascii?Q?oOkSUI/lHRfdCDVs3oes4nx4KyISa3CeYEBoAMiEI/ECi3yt134ubpvJLWXx?=
 =?us-ascii?Q?djlCN16ISTvdmF/1ctWMFiGdyaqOJrtMADEdB8hqLwyn8HSJyAgvK5VCXhE7?=
 =?us-ascii?Q?UiMM4u2KFInLfUKvIgkZgYPhqXbQ6J+X9cBXeUhyX8+A0aVqBT3Fdw8t+etq?=
 =?us-ascii?Q?ndBkuxOWXK0I+//ckRNOTksPFg0E/VWkHMg3HbhkxIfpil8rKwB9wjinpCc5?=
 =?us-ascii?Q?g9XRt1LXGiKpWAIooVbuew/uNfoJaX6B1A/8tjI50xIsjL6rzJn8/eaabuxY?=
 =?us-ascii?Q?YlaftIcZdfvJMUZlRkZWJApUOsspZ7joLRo5Ci/GKspn3KVfhO6ZSdOAP5Vi?=
 =?us-ascii?Q?R5VWx/X2E2KApvyXndIpQV7CsvLTypB3HfyvYqRzXudOMThFSmAHqAZfLdVl?=
 =?us-ascii?Q?g+5b3H7CaQ8iGqAurzVuvVUG5Ln++mGFdPk4O7JaZ5ZN46Wj1LdsaZyfTdb8?=
 =?us-ascii?Q?pomWS09zFNGOtcCAwp+K03sNnaF9q78B2OANjPEzfdJA37NWelaeOfmNp6lL?=
 =?us-ascii?Q?CARBe+ODEzGxkghJfNvXyyDFHVZcZdnfzP33QrX+ZSQrgiyOvqRdapKizR/m?=
 =?us-ascii?Q?ZCSU6YmBcKrCU3ErV8UDEh97jLpsbWjWXll7pzyHM033SQRG4F1xziNaTfPJ?=
 =?us-ascii?Q?AGzB5MQtQFMn51zQ06PpY/f7Cml/DKSEsQ5V8HRHPfloRYTQ2LtqUEfrPcc0?=
 =?us-ascii?Q?+L22qOIqUMBAcbWNf7FY0Fq47CUVrEk53tGyOY4itM3or4hbZaam3qmyqNAD?=
 =?us-ascii?Q?yTx5nOccf4aSqYTKp7va2lg4FU7VFS76z3CoiB8i146FAM2PGcT0g9eQR246?=
 =?us-ascii?Q?HMCe?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F5045CF9AD39184E82E317F444235F6D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5685.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36b6e935-ecf7-4bf2-b71f-08d89be59c69
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2020 01:56:14.5755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cgL9q42s6Ts4xzJ9Tz9DkIOjbsCSzp1qF9G8o7QVkCNi2FKYpOzLw7+MIr5TA2+Pe1J0Cy+ChLdNWY/B7EoclA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4726
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 05:09:37PM -0800, Jakub Kicinski wrote:
> > +	ocelot->owq =3D alloc_ordered_workqueue("ocelot-owq", WQ_MEM_RECLAIM)=
;
>
> Why MEM_RECLAIM ?

Ok, fine, I admit, I copied it.

After reading the documentation a bit more thoroughly, I am still as
clear about the guidelines as before. The original logic was, I am
allocating a memory area and then freeing it from the work item. So it
must be beneficial for the kernel to want to flush this workqueue during
the memory reclaim process / under memory pressure, because I am doing
no memory allocation, and I am also freeing some memory in fact.

The thing is, there are already a lot of users of WQ_MEM_RECLAIM. Many
outside of the filesystem/block subsystems. Not sure if all of them
misuse it, or how to even tell which one constitutes a correct example
of usage for WQ_MEM_RECLAIM.

> > +	if (!ocelot->owq)
> > +		return -ENOMEM;
>
> I don't think you can pass NULL to destroy_workqueue() so IDK how this
> code does error handling (freeing of ocelot->stats_queue if owq fails).

It doesn't.

> >  	INIT_LIST_HEAD(&ocelot->multicast);
> >  	INIT_LIST_HEAD(&ocelot->pgids);
> >  	ocelot_mact_init(ocelot);
> > @@ -1619,6 +1623,7 @@ void ocelot_deinit(struct ocelot *ocelot)
> >  {
> >  	cancel_delayed_work(&ocelot->stats_work);
> >  	destroy_workqueue(ocelot->stats_queue);
> > +	destroy_workqueue(ocelot->owq);
> >  	mutex_destroy(&ocelot->stats_lock);
> >  }
>
> > +static int ocelot_enqueue_mact_action(struct ocelot *ocelot,
> > +				      const struct ocelot_mact_work_ctx *ctx)
> > +{
> > +	struct ocelot_mact_work_ctx *w =3D kmalloc(sizeof(*w), GFP_ATOMIC);
> > +
> > +	if (!w)
> > +		return -ENOMEM;
> > +
> > +	memcpy(w, ctx, sizeof(*w));
>
> kmemdup()?

Ok.=
