Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA06485204
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 12:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239805AbiAELv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 06:51:28 -0500
Received: from mail-db8eur05on2066.outbound.protection.outlook.com ([40.107.20.66]:14977
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239785AbiAELv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 06:51:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4XdT0GxJCs8kz1Afgfo2wwMdPBpEBNf97624gfygWRqmT2OYVruOuPRcAgjnpNuSkjtlAoQ6Fo6piUZV7zfNnHiya4ryIJVV5oFRTUt8isEOcsNVyl9UCF2GcmkvYlKEtNZk3SJcOlemHR2F0tGCiXT03g7ytSdpYQBr383eqnmj+gixHVP4/fzjRUuyDxG34SnwQZx7ItXGkoHluqP1zURdpqquTlliA9rffcmoSqPSsqaldPWg/EkyiP0HYoSA/LfXihybx0oc8cBvSmqHcYKxB1nz6kSgSBLosUgRXYpJVG3182DB0+c5AFl08tyIkh8TCo473XtbQMEewcTPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oASN5rukwNdS5QkcB7Ur6XgSv2cWJa+S2Rm0rsuXrgw=;
 b=kQ59YJJGYfKaqflpTUohPUVJrnEYXkgqTY1Ijdllw80y2zMhPVdv3rnxWyxoUHgJ5mj4KCnjnzFX2ELOqYvceghvUbkvo1UZhXM54JCxZx2PRiH+lWNPA3uyyUcBDL8JqpRd6diF1w7SO6RTqOHnppi5klRJTWiYXf7PQ1hJj/5F1D+2rpJkmDgDQ0zL3NHgmwdqOOntsWg8BMN0WV8dDGPA00355/8pURqISq5YdnN/sqtPbXu+stEXi2+fbyjmCDOwDt6Yh91QOqr711bNOUbwz5Fz9Lamo1l1t5WLfbp7c4ujjio6oambi5NbPPIT4cpqFbPWyXuw1P5oxmihfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oASN5rukwNdS5QkcB7Ur6XgSv2cWJa+S2Rm0rsuXrgw=;
 b=DjZ+hr8pLRh4sZaAlP2WDrZjpPbp653nAJpSgwcliBHaSTFFIebjvYbA+kCKEjSmoHen2ZdYSOJCcqKPkgCi+iWTfcnCBocO9PJ6s/2tGdPOwohQJomMyrXB77Gp3027b+pkgx1JXw5clPJHTBsuIcW8hVSeLLCSUjLJZIDj89g=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6944.eurprd04.prod.outlook.com (2603:10a6:803:133::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 5 Jan
 2022 11:51:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 11:51:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 07/15] net: dsa: remove cross-chip support for
 MRP
Thread-Topic: [PATCH net-next 07/15] net: dsa: remove cross-chip support for
 MRP
Thread-Index: AQHYAY6M/xSLlzSbzE2hfzwfGj62raxUM2kAgAAemAA=
Date:   Wed, 5 Jan 2022 11:51:23 +0000
Message-ID: <20220105115122.im4mjibimd7vq7ou@skbuf>
References: <20220104171413.2293847-1-vladimir.oltean@nxp.com>
 <20220104171413.2293847-8-vladimir.oltean@nxp.com>
 <20220105100152.cnu3zcjmqp6vizer@soft-dev3-1.localhost>
In-Reply-To: <20220105100152.cnu3zcjmqp6vizer@soft-dev3-1.localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 127653a2-681f-403b-a59b-08d9d041b2b2
x-ms-traffictypediagnostic: VI1PR04MB6944:EE_
x-microsoft-antispam-prvs: <VI1PR04MB69440567DB8072CA245F90C2E04B9@VI1PR04MB6944.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +cyEDYnLa3dpBFlyn1mJLykfdmIdRQjYpj3CwreCfedZVtGytJgsnGrdh8xshgs/SvRLa+AtGmzgLC2eCtm4Fxi5syEWUnpXoMx4Llp7a6evLLaGR1b0zv/XbJ0lQb1NjTbc8njsW445Dqkpglk3sAVluJV+0/VwBqFDmcstu+duU/C26UurF3au+ShEYeVfxQlY1AJ3Qc1Tl0Wcx0KfGZ8Ul0upWAUE8vu24niK3mBD4Y/f95zW4XI6L64eOBY559QW9lIzzB16pfl+mwHDrk1maXaGlAAywu1Af73T4IUSSUhOn09HOCeljAEKlS392AvVp0iPonFWmfWz9EhtwIU2ih64jGqQGVyr3Fxzi/+3NiQxpLNIA3kYXTdO1jTSlrhLloe3issp5jEwzmQvEf2+BsKq5zZ9Nm0F8MKe/tRIRTKi3u4sQJWXEGagLkmWFkSryTQE0qdNq4bgdEhX2JdjnOTnDfOX1hqafSeDA9mt7SAVcovQYEe4LSQ9Hjmx8Moi+R2ci6iZEU2cBErtMqmdc5kpYbp5vt35JeNEvuAJOn6VlB5Y2AF2B/Ro8PqMwC0TG6AKJ98C0rO5vTdg66vbT/XvBTIcb9jNjyA+DDKWpSgmje8lbK2DlBXaks/hcqVVF+aLW6KxLk3AW499nCxprrX45lkBRxzJOPBsydD0B+OnCBeFenKWDd3pcaH+EZ4a5HwO/cVRfwNfB0W2LA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(38070700005)(8936002)(8676002)(71200400001)(6916009)(1076003)(54906003)(508600001)(33716001)(316002)(4326008)(91956017)(2906002)(66446008)(9686003)(76116006)(5660300002)(66476007)(186003)(66556008)(38100700002)(83380400001)(66946007)(26005)(6506007)(64756008)(6512007)(6486002)(122000001)(44832011)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fjjrQU57d4CcMSEAcqzmKvc21C1ttvmeA/C+q+IlcDhJXwU3YsS6f5BI3JEN?=
 =?us-ascii?Q?0dCqSifkueCLkdn/XBGWTzMhtPha7VwurGl5AsESY58FmKXMT1VIGMwBR4jX?=
 =?us-ascii?Q?3OZ9Oat3ldZ5JFLaHldb7m9dxEsG5pNJw3RKFKdEnCiU2em3peTgKV8LE+Zw?=
 =?us-ascii?Q?+AzmUnQnPU7joWdJIGEHn1dO61QsdavHgfeCAxp8epQJybd0LcvufXKODJk0?=
 =?us-ascii?Q?K6IKMdDwc6wyHQoMY/WS7jRU/efyXAjJufNNF5UMHIrWs76yD3kuITDc7se7?=
 =?us-ascii?Q?JU7ZjpNQ3q5hXlaCzGKA5B0WouT43z+HGaOQdH1uODgI2GBambIx99jBIa60?=
 =?us-ascii?Q?fA6viFL/iTmPd8V/KuWO1H/FpjkIlQjtzh6dr92FMUoFricXZtRKeWnLb2WS?=
 =?us-ascii?Q?SMVjrYAMjvdJv+1OPIsq+sB7qMU9I9yeGmYTOBDocqowBob+fhMs/pO+m2rc?=
 =?us-ascii?Q?rsa8vuuyBVK/5P4uuAQokuTtoDqTIgrdMAyZml4Oi2ggRyal4OZNa3tUU8nv?=
 =?us-ascii?Q?YMNk+cHA3MJh284bvZsm8Ps+JB6Jiuvk6cygB4gT4gllWrVpiJzSVWOGLl6h?=
 =?us-ascii?Q?ZDZ885oJR1NMEpjzY6CiHWtV2DMrPxXOPW2FK4EepwLetFPtyx925V9GwlXJ?=
 =?us-ascii?Q?EkqmSi1WKPMDadyBHlENHJJ1N7ijX6xO08CYdE1mlC5RKCFZzl49nRUHZIex?=
 =?us-ascii?Q?Jug4WC0/ukwpSvDdJgqY++pbpNi5K59xWIfwvXh7XtZG+D5ofSK0g08TxFDi?=
 =?us-ascii?Q?up30kLyloy4zN7lNyieZeb90w6mDpKdFm9kabt86bY+45k60X5YSdqMFxVYn?=
 =?us-ascii?Q?k/2weBHtv13KDE5zDgaPY77ov3fU/Si5fmVnrz3Un2kS1Ynubw+qmrwWC3Wo?=
 =?us-ascii?Q?+0zfAgE8d2noCORqzNL9NUH0Lz3nK/yN8lc+FwdgzcmSODBFkDjvrz1wMAdL?=
 =?us-ascii?Q?0wquu1TNKkgr+u7bG3pswoJVY/iGJXPKo+Ys10egEyGMt+DxcssWGwxwccsC?=
 =?us-ascii?Q?dT/w/ejhVybxAEjMkhs+9ldcApydE1ldb3QBebZPCfZxDBEXVjj79zZA2Wgw?=
 =?us-ascii?Q?moDafybPkVy6x7SjNirums3fOWiHLXUV/XEeBZUyQOYIttRmVJDmL4Mz5Fhk?=
 =?us-ascii?Q?bU4LbnDsDGC4RVBxMY7TzOLNdbUyLmquXACrTKVUQfYr2cY2PbTG7pfcfecC?=
 =?us-ascii?Q?zF+zf8Oi2o6AiUnl8f/SDwp0oQb+V8CLVxG4Tv+UZV/owevhvYBefcTP+F1H?=
 =?us-ascii?Q?ST3U7y9psZk06V7/bgefjvkYuY0LND93S3vZxYCCIKGcq3xcjRoZAqbn5QZs?=
 =?us-ascii?Q?2VC//5gvGRNHQ3dgU6st+Ayt4019vxevnh9v3pJb6Wv+//Akvwb838R/arG3?=
 =?us-ascii?Q?jUH+JJlmdtKEUw9GH9BAYYcxdcMZD40W4m3UVzJLkdOkBFnHnxPB97Do3fy9?=
 =?us-ascii?Q?wnu4govR3z8SuQUVJ59CFskm5CUDT88ESz5n1EppiYkf1SjL92yfDINH76wa?=
 =?us-ascii?Q?TDJnP155cJOTTqQQL0COVHp3/7pUCG6KvKymOeJokUN4boR3UshbDkXvxdXo?=
 =?us-ascii?Q?NiJqVRua2Sd/sU27hi/OWjsirjgmphsgfGEeDqfNopaMqZf/WqfZwtSWY/7h?=
 =?us-ascii?Q?+dB+mRPBgR1ZjAs3M7jxiXo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A4D972F087E5AB45B5A37603DACB411F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 127653a2-681f-403b-a59b-08d9d041b2b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2022 11:51:23.6952
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lDcMdhrVbnv1IjlEzx9/4UGcGbG+q9yM8ukpHjYSqVJ3lCXlzmvRah1k41IeREeTmL4BpTuKjMWjQj1tiCmwPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6944
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 11:01:52AM +0100, Horatiu Vultur wrote:
> The 01/04/2022 19:14, Vladimir Oltean wrote:
> >=20
> > The cross-chip notifiers for MRP are bypass operations, meaning that
> > even though all switches in a tree are notified, only the switch
> > specified in the info structure is targeted.
> >=20
> > We can eliminate the unnecessary complexity by deleting the cross-chip
> > notifier logic and calling the ds->ops straight from port.c.
>=20
> It looks like structs dsa_notifier_mrp_info and
> dsa_notifier_mrp_ring_role_info are not used anywhere anymore. So they
> should also be deleted.

Well spotted, thanks.

> >=20
> > Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  net/dsa/dsa_priv.h |  4 ---
> >  net/dsa/port.c     | 44 +++++++++++++++----------------
> >  net/dsa/switch.c   | 64 ----------------------------------------------
> >  3 files changed, 20 insertions(+), 92 deletions(-)
> >=20
> > diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> > index b5ae21f172a8..54c23479b9ba 100644
> > --- a/net/dsa/dsa_priv.h
> > +++ b/net/dsa/dsa_priv.h
> > @@ -40,10 +40,6 @@ enum {
> >         DSA_NOTIFIER_TAG_PROTO,
> >         DSA_NOTIFIER_TAG_PROTO_CONNECT,
> >         DSA_NOTIFIER_TAG_PROTO_DISCONNECT,
> > -       DSA_NOTIFIER_MRP_ADD,
> > -       DSA_NOTIFIER_MRP_DEL,
> > -       DSA_NOTIFIER_MRP_ADD_RING_ROLE,
> > -       DSA_NOTIFIER_MRP_DEL_RING_ROLE,
> >         DSA_NOTIFIER_TAG_8021Q_VLAN_ADD,
> >         DSA_NOTIFIER_TAG_8021Q_VLAN_DEL,
> >  };
> > diff --git a/net/dsa/port.c b/net/dsa/port.c
> > index 05677e016982..5c72f890c6a2 100644
> > --- a/net/dsa/port.c
> > +++ b/net/dsa/port.c
> > @@ -907,49 +907,45 @@ int dsa_port_vlan_del(struct dsa_port *dp,
> >  int dsa_port_mrp_add(const struct dsa_port *dp,
> >                      const struct switchdev_obj_mrp *mrp)
> >  {
> > -       struct dsa_notifier_mrp_info info =3D {
> > -               .sw_index =3D dp->ds->index,
> > -               .port =3D dp->index,
> > -               .mrp =3D mrp,
> > -       };
> > +       struct dsa_switch *ds =3D dp->ds;
> > +
> > +       if (!ds->ops->port_mrp_add)
> > +               return -EOPNOTSUPP;
> >=20
> > -       return dsa_port_notify(dp, DSA_NOTIFIER_MRP_ADD, &info);
> > +       return ds->ops->port_mrp_add(ds, dp->index, mrp);
> >  }
> >=20
> >  int dsa_port_mrp_del(const struct dsa_port *dp,
> >                      const struct switchdev_obj_mrp *mrp)
> >  {
> > -       struct dsa_notifier_mrp_info info =3D {
> > -               .sw_index =3D dp->ds->index,
> > -               .port =3D dp->index,
> > -               .mrp =3D mrp,
> > -       };
> > +       struct dsa_switch *ds =3D dp->ds;
> > +
> > +       if (!ds->ops->port_mrp_del)
> > +               return -EOPNOTSUPP;
> >=20
> > -       return dsa_port_notify(dp, DSA_NOTIFIER_MRP_DEL, &info);
> > +       return ds->ops->port_mrp_del(ds, dp->index, mrp);
> >  }
> >=20
> >  int dsa_port_mrp_add_ring_role(const struct dsa_port *dp,
> >                                const struct switchdev_obj_ring_role_mrp=
 *mrp)
> >  {
> > -       struct dsa_notifier_mrp_ring_role_info info =3D {
> > -               .sw_index =3D dp->ds->index,
> > -               .port =3D dp->index,
> > -               .mrp =3D mrp,
> > -       };
> > +       struct dsa_switch *ds =3D dp->ds;
> > +
> > +       if (!ds->ops->port_mrp_add)
> > +               return -EOPNOTSUPP;
> >=20
> > -       return dsa_port_notify(dp, DSA_NOTIFIER_MRP_ADD_RING_ROLE, &inf=
o);
> > +       return ds->ops->port_mrp_add_ring_role(ds, dp->index, mrp);
> >  }
> >=20
> >  int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
> >                                const struct switchdev_obj_ring_role_mrp=
 *mrp)
> >  {
> > -       struct dsa_notifier_mrp_ring_role_info info =3D {
> > -               .sw_index =3D dp->ds->index,
> > -               .port =3D dp->index,
> > -               .mrp =3D mrp,
> > -       };
> > +       struct dsa_switch *ds =3D dp->ds;
> > +
> > +       if (!ds->ops->port_mrp_del)
> > +               return -EOPNOTSUPP;
> >=20
> > -       return dsa_port_notify(dp, DSA_NOTIFIER_MRP_DEL_RING_ROLE, &inf=
o);
> > +       return ds->ops->port_mrp_del_ring_role(ds, dp->index, mrp);
> >  }
> >=20
> >  void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
> > diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> > index 393f2d8a860a..a164ec02b4e9 100644
> > --- a/net/dsa/switch.c
> > +++ b/net/dsa/switch.c
> > @@ -701,58 +701,6 @@ dsa_switch_disconnect_tag_proto(struct dsa_switch =
*ds,
> >         return 0;
> >  }
> >=20
> > -static int dsa_switch_mrp_add(struct dsa_switch *ds,
> > -                             struct dsa_notifier_mrp_info *info)
> > -{
> > -       if (!ds->ops->port_mrp_add)
> > -               return -EOPNOTSUPP;
> > -
> > -       if (ds->index =3D=3D info->sw_index)
> > -               return ds->ops->port_mrp_add(ds, info->port, info->mrp)=
;
> > -
> > -       return 0;
> > -}
> > -
> > -static int dsa_switch_mrp_del(struct dsa_switch *ds,
> > -                             struct dsa_notifier_mrp_info *info)
> > -{
> > -       if (!ds->ops->port_mrp_del)
> > -               return -EOPNOTSUPP;
> > -
> > -       if (ds->index =3D=3D info->sw_index)
> > -               return ds->ops->port_mrp_del(ds, info->port, info->mrp)=
;
> > -
> > -       return 0;
> > -}
> > -
> > -static int
> > -dsa_switch_mrp_add_ring_role(struct dsa_switch *ds,
> > -                            struct dsa_notifier_mrp_ring_role_info *in=
fo)
> > -{
> > -       if (!ds->ops->port_mrp_add)
> > -               return -EOPNOTSUPP;
> > -
> > -       if (ds->index =3D=3D info->sw_index)
> > -               return ds->ops->port_mrp_add_ring_role(ds, info->port,
> > -                                                      info->mrp);
> > -
> > -       return 0;
> > -}
> > -
> > -static int
> > -dsa_switch_mrp_del_ring_role(struct dsa_switch *ds,
> > -                            struct dsa_notifier_mrp_ring_role_info *in=
fo)
> > -{
> > -       if (!ds->ops->port_mrp_del)
> > -               return -EOPNOTSUPP;

Upon further self-review I found a bug here and in dsa_switch_mrp_add_ring_=
role,
that the incorrect function pointer is checked. If a driver implements
ds->ops->port_mrp_del but not ds->ops->port_mrp_del_ring_role, this will
cause a NULL pointer dereference. I'll submit a separate patch to
net-next for this (it's a bug but an inconsequential one, since there
isn't any DSA driver in that situation).

> > -
> > -       if (ds->index =3D=3D info->sw_index)
> > -               return ds->ops->port_mrp_del_ring_role(ds, info->port,
> > -                                                      info->mrp);
> > -
> > -       return 0;
> > -}
> > -
> >  static int dsa_switch_event(struct notifier_block *nb,
> >                             unsigned long event, void *info)
> >  {
> > @@ -826,18 +774,6 @@ static int dsa_switch_event(struct notifier_block =
*nb,
> >         case DSA_NOTIFIER_TAG_PROTO_DISCONNECT:
> >                 err =3D dsa_switch_disconnect_tag_proto(ds, info);
> >                 break;
> > -       case DSA_NOTIFIER_MRP_ADD:
> > -               err =3D dsa_switch_mrp_add(ds, info);
> > -               break;
> > -       case DSA_NOTIFIER_MRP_DEL:
> > -               err =3D dsa_switch_mrp_del(ds, info);
> > -               break;
> > -       case DSA_NOTIFIER_MRP_ADD_RING_ROLE:
> > -               err =3D dsa_switch_mrp_add_ring_role(ds, info);
> > -               break;
> > -       case DSA_NOTIFIER_MRP_DEL_RING_ROLE:
> > -               err =3D dsa_switch_mrp_del_ring_role(ds, info);
> > -               break;
> >         case DSA_NOTIFIER_TAG_8021Q_VLAN_ADD:
> >                 err =3D dsa_switch_tag_8021q_vlan_add(ds, info);
> >                 break;
> > --
> > 2.25.1
> >=20
>=20
> --=20
> /Horatiu=
