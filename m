Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BAE484A95
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 23:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235362AbiADWUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 17:20:39 -0500
Received: from mail-eopbgr60067.outbound.protection.outlook.com ([40.107.6.67]:31974
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232763AbiADWUj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 17:20:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MYlRnb5jw/I/y+FySX8zGPEi8TLU6onTULOLYshFEjG8qww+oBGltVNjyzJGbHtctdV/uC6rMVFwRNkyUFSphEqPLEY6QW89o8b4XZ+CjSEm+XTXD4BdIMArSXb67dviHuGY+zPh2g2mvE5q629xIv7OnmacXlcgzt0Uz/CIGeqeLMxhSu5yE3WepwOmCzVjJCIHwl4kXOvwKArmdugRNH9Dw56f2noH5QPNOs6X9kLuckzf+aFHjWOQgeiPfNIS880g5KPrLILY1vCgk4BYuu6noZtWSiyqkHwxZmyKu8D8xM0HegkmJFamoMiXUhQmdFfkocbdrRGatBEcXPrVrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6m1vVB+n8m43vyiotjX+/WgYqkMeVUusqaiQntWjd8Q=;
 b=BeaBlpFj5CUlWlfj72ysu1j7Ho4WZBh0SjbmSCk428TIAE8PrG6uaF+S6jKBKJi5LgLjF82J1KU4VMvJ7dryCieV6Bbzr9k0gAIUJiLnOJfSFoFzALZ5wmvOCOz3mn5sWRNj2XT0yan20JDRjyZbYLVqSDWa7ab1AYnsW5H0IplywQtUbptk3ob4JktJbsg0Iw5bLhnS1VU4MFAn89W+Uw8FQ8noIcvnjTJz2PfcPbdeohXRYGoxnxhU+6zz7I+l1Aabw08BosfThpgVTaFbDIINIDfJUWc4zDM6Zl1MzYFIcXCD3koHdSbeN0u4AxVTFT7vNxadKaSRpEEAYNYAKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6m1vVB+n8m43vyiotjX+/WgYqkMeVUusqaiQntWjd8Q=;
 b=fxRSAqqcKE33u/1VNGs071iSTkCSeOuIuVhPKVS6mSfYZwFc3jG98TDkB1rjTnjA84zlZTsnCoirTveOTTNNdYgspO2UThwnDAtZ++78b5GzqfI/aGSvijUP5KgFOQOt2tNRcBclUq3TMC9MGuqRSW6fh2yd5yshlpAmhNjoHII=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6704.eurprd04.prod.outlook.com (2603:10a6:803:128::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Tue, 4 Jan
 2022 22:20:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 22:20:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     George McCollister <george.mccollister@gmail.com>
CC:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 08/15] net: dsa: remove cross-chip support for
 HSR
Thread-Topic: [PATCH net-next 08/15] net: dsa: remove cross-chip support for
 HSR
Thread-Index: AQHYAY6N+A/E8jNalEmx1OrGraIKsaxTatIAgAAEqAA=
Date:   Tue, 4 Jan 2022 22:20:36 +0000
Message-ID: <20220104222036.giuz2kip33zfr6a6@skbuf>
References: <20220104171413.2293847-1-vladimir.oltean@nxp.com>
 <20220104171413.2293847-9-vladimir.oltean@nxp.com>
 <CAFSKS=N-31qNir6xmj1u2ZR2qjERiqg5qyEtsRebc0ihjr5FRg@mail.gmail.com>
In-Reply-To: <CAFSKS=N-31qNir6xmj1u2ZR2qjERiqg5qyEtsRebc0ihjr5FRg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8abcc04-ce0c-4c8a-ad7c-08d9cfd06ec9
x-ms-traffictypediagnostic: VE1PR04MB6704:EE_
x-microsoft-antispam-prvs: <VE1PR04MB67042047D1692A9D847C5FE1E04A9@VE1PR04MB6704.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 76AnunTX2FTaXU1VSlOB+siafqqLM0P4Xm7xDxl9oLPmgaaB7eKVHS49CbA7uvbqU9AMNo/WOzH8kP7tu0boK/20NbnREC2FZJ9lGZ8Hc7gfL8u5CjPQIUmO0J+Mb4TgY9Vemd87JTZI6HW+SOgD2qxAhXxpknh4KE4GCeYXEV32nWN7sjZhXpCmM5IkRZuLgIohLECTnHvolywXQxzKlp0Xj1kW6t+uO36JvNShZjzd/dsKnJyAY3GOriG6RwfmyU+1db5tKW8pfa8XYCzsbZZ94aXceoTjXL1jk/2sWCUXQwxg+kFMqjPWXvUzM0Q0IxBai8iYmxEX097Ge4HJ0CxizRW3oVTGXS11toagAix05IPeg7vpX01u5I39d2JeQJN6QSIWG7EpJszqpF2LoLJv8U8HHZ0QNdoMrohNUubQpo4yke5v0J+3/mOiRBzCgHAsBfc8UAQliHVT3NQdNkJqtKRBH6DQTKYe/mwcQGnyNx/uDq0LbcVWaTgMJu/8gMvELrRYD0PlgkiXUds1NO49OfJEoQfrRZlUhqyyHFb1B9IgbKqk0gxI5hmW/4qj2F0kAI1gwWDzah0acok8/pVXj+DE3cTskTsi04FdniAQpDa5rsCKUKY41t2v9PngI8F/aP3WbeboaKHGCfy9hbYMS21A0uETlR/jSzfxzw87ZGJqEAQf/GnBSKAgP3kEf4PMJ/wixGgCbkvyPRwlSQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(8936002)(1076003)(54906003)(6916009)(66446008)(86362001)(38100700002)(33716001)(38070700005)(316002)(122000001)(8676002)(83380400001)(508600001)(53546011)(5660300002)(64756008)(4326008)(186003)(44832011)(26005)(76116006)(71200400001)(9686003)(6512007)(66946007)(6486002)(66556008)(2906002)(6506007)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hQAmXEY1jshuKpsTEbVwo3uzs/iIhwwDoa4ZmBlz84vRf1xzpQtqmMIcQKIq?=
 =?us-ascii?Q?Tq71Uxn1OfT+SalyVTHKAFuXhEFQocT6ZqeEMVQEwhq52ddv6IHM7TYj5G3o?=
 =?us-ascii?Q?xBVwmmQSqogdQJ6gS4TRbwPhI86zhQCdzRLZgAIer8+PhRUB1eMXSRqOK1VO?=
 =?us-ascii?Q?OzuKh9EqxLX9QUhZfwkcIQDXilUIS2npXtLrxlssCLqEJT0Ua6fE4YZ+HD3e?=
 =?us-ascii?Q?QyF3z/2RsH2OZxtJ/n2erKMKAo6stAZWcWSgQBBxUskfsqFglzEb+rzPmCKN?=
 =?us-ascii?Q?YCuEyR2tYz8GvZLF37cC6kCLwycMNpRfWTdfcZIIv+OSk1wU+RMS8/+Y3DSB?=
 =?us-ascii?Q?oiEsiiO+0iklVzd7+I/cNyUwCGr2IZoXm1dY+mAwc8pxRqtEkfI5uQHLqyAc?=
 =?us-ascii?Q?Vex67eXB6LG8SVwRUWJPoD2e9RAx1XKBTGnR5Dh640gKOB8Q2dMJAIajztcq?=
 =?us-ascii?Q?i29RwnpVcjOl46xb5Will8Vg4yx4HM2d8llBJ63Sg3jDjpnZ3c1Bt6LD7+H6?=
 =?us-ascii?Q?CSwBMKZORiMZPZkcxEEpExhRSewJF8Mgw1siakeoNYHGQJq6OfQesgurLvgq?=
 =?us-ascii?Q?T1KdOJrAaQm0vt7NtXN87tB0AdBzksxeXCG0FWdEQrnRgCbPyNS8wlPgi0ql?=
 =?us-ascii?Q?FLr0i75ANGmU21Mr0E32i2ykvfUxO7T16IAfb8zAVEaDPbAGfiwy07VNAsz+?=
 =?us-ascii?Q?4wtVeZ9AMddTLfUJnmda3Qe0xag/2RQgjnEcsYAzSuDlbLVYAeBHmAvWx7AP?=
 =?us-ascii?Q?mQaRcyPu4fZ69/z6ZH0B4ErthPOvHYfdqJQYaX9uGC3ZSJtZfjk9lg0nS0/e?=
 =?us-ascii?Q?eajZNS1R4IT8XPOa+3cSJjZP8k7VvTtSmWWU6uz3a7+LhJ3va42a8iNoJvWG?=
 =?us-ascii?Q?pidjP33Ze1IWttu7Z1ZiT1x75Q1Ye68IBzS1KUZHIVz51unyrXUZIgHXGxnA?=
 =?us-ascii?Q?uzLL/KeBObN9E45nj1YoMSOtZGgWkSlXKU4yE0c5yCrYjRenoweBs35jDrWu?=
 =?us-ascii?Q?tbHx+6yA2xZEhyRcqV0I6CSSPw6TVMtQ18WyamfsQXOhDG1psz+A81icp8C7?=
 =?us-ascii?Q?Dqkk3Kj6KBZIHmqM/2GEILXZR30jW7XPvLYiJx8XCU/u0Ty46DbCtNRSDeXl?=
 =?us-ascii?Q?vtJ5VCuwSxGYX0zTiAGwGkYuhnDwp+8r14vNxUbgCQciTJsuLWE+BovLmCi2?=
 =?us-ascii?Q?+LcQbyiMSUBzi1FxfiOISl7aiEdITFyJG2HL09vlfQES59XsHOKxOsto+Y8l?=
 =?us-ascii?Q?UqVUO7i2cg4G1z/EqchnRCE1QCN4jLkgsI2l1FxH8D/e85LebRK1gbFnPgpU?=
 =?us-ascii?Q?ue95bn+K7YeKgLbNPU1pmkyx6GFaSNbb2IWCVq5/kEt+6MXLEE3D4vs8JOFh?=
 =?us-ascii?Q?Mm2Bq8Bg9SRTAgkFihsDuX0ShhqeNXglIe/CWjGuC+ikVjhVLh8bEFClGrHi?=
 =?us-ascii?Q?vwMOr0ZCOWT8oB/gBHeOzBZA5kfRCS/XYYPYJOdldMqZZ2OEXyqFU7Ors4+3?=
 =?us-ascii?Q?BUn236wgD26iUn78q1jWNIhY66+gy7d4pAcFNNyB68/zAX7NJ32WsxyVnsD+?=
 =?us-ascii?Q?Nw7+BadPye3HR5R+5G4H2vxiLTQyAd7f/GxXXX90XQuzqrPnxBLRh2FtkSRn?=
 =?us-ascii?Q?s/Ia6qf7yWKboKhysKzGb/Y=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <104C6ACD1AC2CE4A925FC312C66BD6DF@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8abcc04-ce0c-4c8a-ad7c-08d9cfd06ec9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2022 22:20:36.7400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: srd/X2ab2Dd/2/qOv/xwCaWFSP9Bvf6rm5LkPAlFZwFQ/WsVUvi+xbcUOMKP8CzuFjbH/OT8GHDqPn8+aK3z/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6704
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 04:03:56PM -0600, George McCollister wrote:
> On Tue, Jan 4, 2022 at 11:14 AM Vladimir Oltean <vladimir.oltean@nxp.com>=
 wrote:
> >
> > The cross-chip notifiers for HSR are bypass operations, meaning that
> > even though all switches in a tree are notified, only the switch
> > specified in the info structure is targeted.
> >
> > We can eliminate the unnecessary complexity by deleting the cross-chip
> > notifier logic and calling the ds->ops straight from port.c.
> >
> > Cc: George McCollister <george.mccollister@gmail.com>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  net/dsa/dsa_priv.h |  2 --
> >  net/dsa/port.c     | 20 ++++++--------------
> >  net/dsa/switch.c   | 24 ------------------------
> >  3 files changed, 6 insertions(+), 40 deletions(-)
> >
> > diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> > index 54c23479b9ba..b3386d408fc6 100644
> > --- a/net/dsa/dsa_priv.h
> > +++ b/net/dsa/dsa_priv.h
> > @@ -25,8 +25,6 @@ enum {
> >         DSA_NOTIFIER_FDB_DEL,
> >         DSA_NOTIFIER_HOST_FDB_ADD,
> >         DSA_NOTIFIER_HOST_FDB_DEL,
> > -       DSA_NOTIFIER_HSR_JOIN,
> > -       DSA_NOTIFIER_HSR_LEAVE,
> >         DSA_NOTIFIER_LAG_CHANGE,
> >         DSA_NOTIFIER_LAG_JOIN,
> >         DSA_NOTIFIER_LAG_LEAVE,
> > diff --git a/net/dsa/port.c b/net/dsa/port.c
> > index 5c72f890c6a2..9e7c421c47b9 100644
> > --- a/net/dsa/port.c
> > +++ b/net/dsa/port.c
> > @@ -1317,16 +1317,12 @@ EXPORT_SYMBOL_GPL(dsa_port_get_phy_sset_count);
> >
> >  int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr)
> >  {
> > -       struct dsa_notifier_hsr_info info =3D {
> > -               .sw_index =3D dp->ds->index,
> > -               .port =3D dp->index,
> > -               .hsr =3D hsr,
> > -       };
> > +       struct dsa_switch *ds =3D dp->ds;
> >         int err;
> >
> >         dp->hsr_dev =3D hsr;
> >
> > -       err =3D dsa_port_notify(dp, DSA_NOTIFIER_HSR_JOIN, &info);
> > +       err =3D ds->ops->port_hsr_join(ds, dp->index, hsr);
> >         if (err)
> >                 dp->hsr_dev =3D NULL;
> >
> > @@ -1335,20 +1331,16 @@ int dsa_port_hsr_join(struct dsa_port *dp, stru=
ct net_device *hsr)
> >
> >  void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr)
> >  {
> > -       struct dsa_notifier_hsr_info info =3D {
> > -               .sw_index =3D dp->ds->index,
> > -               .port =3D dp->index,
> > -               .hsr =3D hsr,
> > -       };
> > +       struct dsa_switch *ds =3D dp->ds;
> >         int err;
> >
> >         dp->hsr_dev =3D NULL;
> >
> > -       err =3D dsa_port_notify(dp, DSA_NOTIFIER_HSR_LEAVE, &info);
> > +       err =3D ds->ops->port_hsr_leave(ds, dp->index, hsr);
> >         if (err)
> >                 dev_err(dp->ds->dev,
> > -                       "port %d failed to notify DSA_NOTIFIER_HSR_LEAV=
E: %pe\n",
> > -                       dp->index, ERR_PTR(err));
> > +                       "port %d failed to leave HSR %s: %pe\n",
> > +                       dp->index, hsr->name, ERR_PTR(err));
> >  }
> >
> >  int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool bro=
adcast)
> > diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> > index a164ec02b4e9..e3c7d2627a61 100644
> > --- a/net/dsa/switch.c
> > +++ b/net/dsa/switch.c
> > @@ -437,24 +437,6 @@ static int dsa_switch_fdb_del(struct dsa_switch *d=
s,
> >         return dsa_port_do_fdb_del(dp, info->addr, info->vid);
> >  }
> >
> > -static int dsa_switch_hsr_join(struct dsa_switch *ds,
> > -                              struct dsa_notifier_hsr_info *info)
> > -{
> > -       if (ds->index =3D=3D info->sw_index && ds->ops->port_hsr_join)
> > -               return ds->ops->port_hsr_join(ds, info->port, info->hsr=
);
> > -
> > -       return -EOPNOTSUPP;
> > -}
> > -
> > -static int dsa_switch_hsr_leave(struct dsa_switch *ds,
> > -                               struct dsa_notifier_hsr_info *info)
> > -{
> > -       if (ds->index =3D=3D info->sw_index && ds->ops->port_hsr_leave)
> > -               return ds->ops->port_hsr_leave(ds, info->port, info->hs=
r);
> > -
> > -       return -EOPNOTSUPP;
> > -}
> > -
> >  static int dsa_switch_lag_change(struct dsa_switch *ds,
> >                                  struct dsa_notifier_lag_info *info)
> >  {
> > @@ -729,12 +711,6 @@ static int dsa_switch_event(struct notifier_block =
*nb,
> >         case DSA_NOTIFIER_HOST_FDB_DEL:
> >                 err =3D dsa_switch_host_fdb_del(ds, info);
> >                 break;
> > -       case DSA_NOTIFIER_HSR_JOIN:
> > -               err =3D dsa_switch_hsr_join(ds, info);
> > -               break;
> > -       case DSA_NOTIFIER_HSR_LEAVE:
> > -               err =3D dsa_switch_hsr_leave(ds, info);
> > -               break;
> >         case DSA_NOTIFIER_LAG_CHANGE:
> >                 err =3D dsa_switch_lag_change(ds, info);
> >                 break;
> > --
> > 2.25.1
> >
>=20
> Looks good.
>=20
> Reviewed-by: George McCollister <george.mccollister@gmail.com>

The irony is that the check for the presence of ds->ops->port_hsr_join
and ds->ops->port_hsr_leave vanished. So this is broken, we'd get a NULL
pointer dereference now instead of -EOPNOTSUPP. Sorry for the noise.
I'll add this to the list of things to change when I resend.=
