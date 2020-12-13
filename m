Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226322D8AB8
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 01:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439930AbgLMAPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 19:15:09 -0500
Received: from mail-am6eur05on2080.outbound.protection.outlook.com ([40.107.22.80]:50016
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726267AbgLMAPJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 19:15:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWzwVP30zW0l6vELX88kcD+6kkODsmfZUmpkxOETJ6EYdPyE1rmhnzRmvZC6I5x4zy5LKcHMk0hIw19h/7o5NUszdWJzngC5odNjPC1tJRD3TnW7nFq9UiDk+6YPVHdTR0EFFoqK5fCStL2M0WkyieMy/+cGDMuFWb2pkegpyted3ysmMCEIG5xoW6H73ZnwpRj3S82kaRgwcwVn9NQvSXUvpjGrY5HreicGHpNfsPkxV38cqwJBRYbmhF1NBQl9HcOLBQuZpmHsAEAPGDJwZ/+gXjrSN++C19KI7OIH53YVZjDfUT8rxeWXv7Kv2bFBUaVFWyZ6rKRY0MlsiY1vvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0K9GRnirmqq9sjWSde4XEdzHxGt5buoyQdqed+/CY2E=;
 b=kKZV2WOUvOHsIk6DUgPxoFN/9xLD+V7a7Cu4PhmWnBUhyavJx9UFl6vucyTKz1u/VS6xF1p5u72qIUxuZPWpavlGI1KlJ/ZsoJFocQBS8MT+sExgMw4DCepJHA9+JITqYssXH7AKV3s2VqYfWKc6iJ3dvSrHktqG0ATFpji6UzB7f54vhGi4OfK9xHTnhArulNKioqcV/h6e7QDH1IeGOT7TInMfTtmz37CzrBv0K3VAYICAVV+86X4OTVILLHd3q5oEaN/RuO3Q5Zb8oWwp2q8c+9RhSSKDa6VqDAPmdGtjKfWuZc7BmV5duht6GaN0LmRZZW/H2WoB29PF76/GLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0K9GRnirmqq9sjWSde4XEdzHxGt5buoyQdqed+/CY2E=;
 b=E0vYMq0lNOH1qZVBCKW/RhWHVJDXmJGMfyKv5VOvj/gdwJip0pBDhVhig1Tw3uP6ZAE9BQOHKvYS3cbIWFcbBzTmJw+TKHWn4hEaAWj8S/9zEJxThYHHkXKVDgYlmcQBGi2qTgj8Q5cbxPijRtxI/LEkufwFHTuI+zo3bzNQiYA=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7327.eurprd04.prod.outlook.com (2603:10a6:800:1ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Sun, 13 Dec
 2020 00:14:20 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sun, 13 Dec 2020
 00:14:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v3 net-next] net: dsa: reference count the host mdb
 addresses
Thread-Topic: [PATCH v3 net-next] net: dsa: reference count the host mdb
 addresses
Thread-Index: AQHW0MbaD+Wb9ZfykEuALlETOMXISKn0BJWAgAADbwCAAB64gIAAAYEA
Date:   Sun, 13 Dec 2020 00:14:19 +0000
Message-ID: <20201213001418.ygofxyfmm7d273fe@skbuf>
References: <20201212203901.351331-1-vladimir.oltean@nxp.com>
 <20201212220641.GA2781095@lunn.ch> <20201212221858.audzhrku3i3p2nqf@skbuf>
 <20201213000855.GA2786309@lunn.ch>
In-Reply-To: <20201213000855.GA2786309@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: abc87fb8-b86b-4e8a-b4e6-08d89efc0972
x-ms-traffictypediagnostic: VE1PR04MB7327:
x-microsoft-antispam-prvs: <VE1PR04MB7327F81721DA94D2A95F3F41E0C80@VE1PR04MB7327.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D4wH0og7EjDAyfd/dkJCrhhQbP2H1zg7NkkcZgrTcFeGJ4nc/jM7SuCQnEFRVk+/jU3ZxT/J25FA3TrWPMmWQJYDNxocLCNl//GrCbmSHSmv7M0b5SwYZ3SV1SvqKZqJCAlR9czlOTQXjK47apbsNM+di2fD85L0DhkjkFGVeHdXfrAW1mYUT7zFM0eeas6tizDqqr0aa7y9ZirTow/vCSOIIB0/1OYJnrUaRAoptBrxZefmUIDQvRdk7YSVD/CIxMqGsTCb8152doAKGBbJc5MuP0M5HigPQQsIiy9bu81Ol2c9kQV+ZDl6NHtPqowqP5+G0c1OElfi3E7CE9sLFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(39850400004)(346002)(366004)(396003)(136003)(376002)(44832011)(26005)(478600001)(8936002)(6486002)(6512007)(64756008)(186003)(83380400001)(33716001)(8676002)(316002)(66946007)(66446008)(4326008)(66556008)(9686003)(54906003)(86362001)(2906002)(5660300002)(76116006)(66476007)(1076003)(71200400001)(6916009)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?rRQc556UKiS5mpKXS/h0AuICEQbvLduKLLTsvHQfApm9sKbJKglLHR1Ev7On?=
 =?us-ascii?Q?8wd5qXrbr+ekuElULG8XS74D11jaSuAn2Bv/Yg6QqwsR0Q/2IQn8+XEq040V?=
 =?us-ascii?Q?CYhntS/5hafTaXi8Wo06Fo6gEegXIE42kV0TShsQ63H/5Pw/bdHDgd0mGPwo?=
 =?us-ascii?Q?ktSI5XPubix8BbNGAm9UoH+/cvYFjtslqqOjEfbo4tCMdkWMl10Y2tSYhtOh?=
 =?us-ascii?Q?VXregv58WnzpySP6+OA9SAURT1LvjhGmQ5gyo75Ub64PQQjV9S2NLkDizwLh?=
 =?us-ascii?Q?3vTzeEy1b5K76MnFwNZV0Lui1ONnnwV/VfFN1l4eAvPodCscQ/z8k0qJI2c2?=
 =?us-ascii?Q?p9vqjEoclBIiERDr/LYdGCd/Gt+sUPVRg0cBhinJWGvBBxxXg24Zr81blcOd?=
 =?us-ascii?Q?8n/RdWj6ReURit3l+0PUB6N3EntSrWzukY+D/b+q08yA8dGYhaScld6zl+mG?=
 =?us-ascii?Q?nIR/swXGHcw1Yt6ALrgG5mQnTNrLLAzaQ0k+D0ICRSst017xbogRHZ0iyJAP?=
 =?us-ascii?Q?A79KsxUYeSN3jPCbY8Y712TCfq4K1gTdY27Lrw/60FW5ZgO8ZSIpcY0Ruvnc?=
 =?us-ascii?Q?31E2Q0+mdfqRAsYXMU9HCqFshpyQeYw6CSm87pd9JBlI3hlyRBYFYXC3Inq/?=
 =?us-ascii?Q?Gwm4/q0Hs8DuQgGkqpou3j18Sfx59tgp8Q/0R8mOdnExrpgfvcXUIPoU8QIK?=
 =?us-ascii?Q?iwoaf3D5CtlAM3+NshIq4AdHUnniS3g2kyuqQIicFnCn+WZZfQZKDbRroVkW?=
 =?us-ascii?Q?sFvobYdf4tXk1JDB4OttHYYRuAy10zZUc32RAUepbT/uE61BptA4J05Hf4dx?=
 =?us-ascii?Q?1HcZbB3ozdUT1pERtqnYVArVxmKVBATtei/+sIQHcVdd/c6sQg7QFuaAXNa0?=
 =?us-ascii?Q?PY3UIcftGA3s5eZYlgzevG13Q8kHlhlk0DZBSTADQSAHcZB8rO/szVvL6OoJ?=
 =?us-ascii?Q?N7n1lnTN8e6EIqcOHk6INEHN2XslEL92DD+H8MWCYcrqHyW4TZ69jLkZ2fnc?=
 =?us-ascii?Q?j90R?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5B8879B002111E40B4049A444AAC337B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abc87fb8-b86b-4e8a-b4e6-08d89efc0972
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2020 00:14:19.7386
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YsQQCG7ztFmddMCjoVmqy5ltPe+nBY+wzS7Z07eKwEigHbywzp/9lF++INUBYYuKCMK2/etDLOrhio1gDVRhQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7327
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 01:08:55AM +0100, Andrew Lunn wrote:
> > > And you need some way to cleanup the allocated memory when the commit
> > > never happens because some other layer has said No!
> >
> > So this would be a fatal problem with the switchdev transactional model
> > if I am not misunderstanding it. On one hand there's this nice, bubbly
> > idea that you should preallocate memory in the prepare phase, so that
> > there's one reason less to fail at commit time. But on the other hand,
> > if "the commit phase might never happen" is even a remove possibility,
> > all of that goes to trash - how are you even supposed to free the
> > preallocated memory.
>
> It can definitely happen, that commit is never called:
>
> static int switchdev_port_obj_add_now(struct net_device *dev,
>                                       const struct switchdev_obj *obj,
>                                       struct netlink_ext_ack *extack)
> {
>
>        /* Phase I: prepare for obj add. Driver/device should fail
>          * here if there are going to be issues in the commit phase,
>          * such as lack of resources or support.  The driver/device
>          * should reserve resources needed for the commit phase here,
>          * but should not commit the obj.
>          */
>
>         trans.ph_prepare =3D true;
>         err =3D switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
>                                         dev, obj, &trans, extack);
>         if (err)
>                 return err;
>
>         /* Phase II: commit obj add.  This cannot fail as a fault
>          * of driver/device.  If it does, it's a bug in the driver/device
>          * because the driver said everythings was OK in phase I.
>          */
>
>         trans.ph_prepare =3D false;
>         err =3D switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
>                                         dev, obj, &trans, extack);
>         WARN(err, "%s: Commit of object (id=3D%d) failed.\n", dev->name, =
obj->id);
>
>         return err;
>
> So if any notifier returns an error during prepare, the commit is
> never called.
>
> So the memory you allocated and added to the list may never get
> used. Its refcount stays zero.  Which is why i suggested making the
> MDB remove call do a general garbage collect. It is not perfect, the
> cleanup could be deferred a long time, but is should get removed
> eventually.

What would the garbage collection look like?=
