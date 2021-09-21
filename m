Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684204134DA
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 15:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbhIUNxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 09:53:04 -0400
Received: from mga04.intel.com ([192.55.52.120]:45747 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233042AbhIUNxD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 09:53:03 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10113"; a="221472624"
X-IronPort-AV: E=Sophos;i="5.85,311,1624345200"; 
   d="scan'208";a="221472624"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 06:37:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,311,1624345200"; 
   d="scan'208";a="703118058"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga005.fm.intel.com with ESMTP; 21 Sep 2021 06:37:39 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 06:37:38 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 21 Sep 2021 06:37:38 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 21 Sep 2021 06:37:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NeWFK7urKJSNkVXLukOb0cCgUQrY/eD/Ic+6+OMEZFNMiOPloT1fzBc4q/FO0D62OOsSE9KhDPJtxKtF0yDByQ1jLD97LntW83WsUjwCIRbm/Iru6EakGfn17HSoFdfRKez8+t7Zh/WUvzWj79Pangwr4821zpGgAa8oloA4zrjCVe0ycdV02q5Eo+8XsCvHI2CL4CMnC+0zcWDhtNTVWq6LRtyZcrJAEyhhEE0C7Lp1aKNU5hCETG4oyFBm4cavxIyKVf7s55LbQLuHjVjICWo5U3T26SeYmZ+RyCVChi9P2KlArvHbGZHgHDGBHpc/2Amoikk/yTbicfM0m/bI8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=00QlhGbrZt9XITCtuov/DHoL36v41L8gT/F78UZAG3w=;
 b=FxFQNB2Y4oOZfd2eTNyAvQbCVAzJ8kMZcv14f8mla9PquFaGq9wdAEvZHTpZNN5W+W1cAOCNJXfTDD/KNPX89sAgJjwvDaVCuqRxW3O0BFQiNK2VnBbOlQZ53bsnVNd0HpfrcBjPXr+vPDnMlK32XtEleN/5X5eSqEOKY+L74A4K18Tmxlej59JsVpYm6+ep+ATZTXHzZkoislHvS7rsBg1y6g8Ucu9iFAuZIOMPwpbP5/BgygardvDla83vww/qLi/AKRzWAML+3nIxREFRC2yLOcimulXze0SuJkoijm0j53Ql5eZu3g6HI4JOseEBYoNCuwz3Cv8urU/sJoi/pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00QlhGbrZt9XITCtuov/DHoL36v41L8gT/F78UZAG3w=;
 b=G9bfXzocaE8RTqNdxDjBnP6wYhqFwC3jH8VEWqod/uCYw5W2FkCrl+1qVoI6rNbkfDmkLs02bnf4tmSKY9244bZXXjnVct/qRymJLrp920tZumQI5zN2PJwFGVBns8PlbZVEg5bJrD+XLrCtTcTPOATiTEZTAtVTiDvIivAHql8=
Received: from PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5)
 by PH0PR11MB5126.namprd11.prod.outlook.com (2603:10b6:510:3a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 21 Sep
 2021 13:37:37 +0000
Received: from PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221]) by PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221%9]) with mapi id 15.20.4415.029; Tue, 21 Sep 2021
 13:37:37 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Topic: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Index: AQHXoNimVzUXkjuVtUCdGyBU/1Tj8auuk+yAgAAAqyA=
Date:   Tue, 21 Sep 2021 13:37:37 +0000
Message-ID: <PH0PR11MB4951E98FCEC0F1EA230BA1DAEAA19@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20210903151436.529478-1-maciej.machnikowski@intel.com>
 <20210903151436.529478-2-maciej.machnikowski@intel.com>
 <YUnbCzBOPP9hWQ5c@shredder>
In-Reply-To: <YUnbCzBOPP9hWQ5c@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca86f8af-7d59-4782-6c4c-08d97d04f9d5
x-ms-traffictypediagnostic: PH0PR11MB5126:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB5126565408CDAD68F9AFA5DEEAA19@PH0PR11MB5126.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t9KXnjjoo9kPV7agBIlT9akc9HAOK03g0rSYNSnyvHidl/ug2Vrw0ftlQr9K1PwNR3sr131fFtzzq48xfhapAzdlKMtllwITQ6T8RI0O8D7+B1ZhZ7prm4inl4kBQ78S/GVlUYJFAVEWbwVBvHoawDbj8zLqXdGOxwfrBzLAPjc0V8jDmQkJ32BPllWmO7TuZLe+FfOOr619pAdAHtomXgN2f8qc99Jq/IuBXmj5G9YN1Z2dWIsSs2IwmaOQy7giSKQljq6UIIFa50JHip7ykYRN2K4F6H84wGSImANAhjPsONYr+KlJdFtH69SqpFr1+3JneqTI0OnYzKs4DAXF8wYFGDUImev6zYvNVC2t8UhddI6HwZot9AXDDFwKUIshFA5uwToZ3ODCCSmB+f51sk3uxpQsnaO+AH2LyZy+O1ODEyTGaTm6XTi+iW9LgtnvdWhB/XYjtCO3KK/Rt4DDtNZw/ZKbIu9He+Jml6CZZ/e0SUZVnPNAwe4u2K6cL4BthiXlYWHiuEQiCiNSx2+P6m/GrUUPvDtETXWOZoudxkQIBKmeMDrySTv1XaDISoA05gJMBB02ByGdjzmvUFKO/1Cogkt3Y/K64bD9BvViXS7+OX6iJfG6LzlFOnl9NQGnJh/UI9R3PIH2AERVNal3qcyIxA6AAUKviHofHlH8efp+iB/OxLpVVlneQIp1HbDDUEvQaAU1hdiCxoqo6StoTDg5W2dnE+9t1zSQNLV0utkq/S+9vDrYijEtVnMetBrvH8tt8byrHe9+E/Yjp+c2+xkUP+4kpTD2ONW5Ic0HlIQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4951.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(186003)(6916009)(86362001)(66476007)(55016002)(8936002)(966005)(15650500001)(66556008)(52536014)(8676002)(66946007)(38100700002)(6506007)(2906002)(316002)(53546011)(71200400001)(66446008)(122000001)(9686003)(5660300002)(64756008)(7696005)(26005)(508600001)(54906003)(83380400001)(4326008)(76116006)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VNjUkg2X9N5aRz1IdctmoxC+IAA/3Haz2pmwScDcsEX+KOKmoipSQ+2nCL1s?=
 =?us-ascii?Q?/enfaoEIzFAfzEswNGOZoKxpDlq7E2c6wkdkWGhFs2NNiYCN+MJ6f6HQSxAP?=
 =?us-ascii?Q?fBfym/IoEiq0nSfmCWwWAI/oma4fruKFh0c/Ik/Vt3u9vJLvYCFx1n02U1b5?=
 =?us-ascii?Q?SMmeIUEazkC1FV/vgGDCJkzzKJ1jPJ/fLyveJ1Y2drJfmpl87YHnYno2aix4?=
 =?us-ascii?Q?YtSFAZWA+GPV7yt7idx1f/j3WkDgvKQ+hGGwdMBdiq0bZRB96gRryiHnA+pd?=
 =?us-ascii?Q?kMfsxcuMsITxUi79NqMhrZVBIQJYRGfvdKe65oJsfqYKBpW5J3MPpX9Xhcrp?=
 =?us-ascii?Q?vcYHaAGQqBrOzJYdn5eKvxXbtz3UBc0PJBjNp/JD4mqZYwJ2VWybxVIAgoax?=
 =?us-ascii?Q?XdAGK2319nfpegYj/wrPDrld+GfUbzGCuvoNe0KGr7PrkHkREozmxbZof8I3?=
 =?us-ascii?Q?HmhsCTv9iqQ9WHYo4m4D+l0LuFEcfXzUUHMN9Vccntjx9bwNaynaCfcBSlEO?=
 =?us-ascii?Q?OSgI2rPnJAjR4DpDahMLXt0y+thDOt5IweSh/qqHuK5GSo7mLloB07N0u3Y2?=
 =?us-ascii?Q?Rftg4EC+RA/1XHJN7v1OliqfAuf846snKHkOuuDAvqGpYCw2gSOjqHk7xn90?=
 =?us-ascii?Q?giJVP49m6dHipkBrLW5YUg6U9HWvkHWfzq5cwrNSudxYz9F9V0vYzMnmLk0l?=
 =?us-ascii?Q?s5QaTKRUa9Km++owj7MPjJG4A3p5dtei2jFmT4iJv5spEC6h/5e6tV46dQRI?=
 =?us-ascii?Q?o62vd1F7N1WYHjWfbQg6ZYRX4DQCdUJT7bfm5sOA2s7EmN0b9UlFpCUBw4Jh?=
 =?us-ascii?Q?o3APqPbJF4EDsmd25oEghX8KanAOGSVVYTk5pBEE8y+5ptT2peB1J6LEFhYJ?=
 =?us-ascii?Q?BggdLptLZab83ovsAFBLtHabUsJk0AuJHU3mRIOqnNhjyHIWKv2V+iFIzJvf?=
 =?us-ascii?Q?XAJ6itl3vdyNibajdYcBXjQBLDembmWxGDrhyZyafxuTMez7FMv3t+bNs7hA?=
 =?us-ascii?Q?4yMjM0nQl9u4y3nNs/RyxGGX5Dngayhq1IfZAHGSl65axIuGGxi5gYmkMnqN?=
 =?us-ascii?Q?3em4Q+pEs5A4QPz0hrzeS/PCBs9C6fZ9LALSbUTIUzJg2IkbNB8Tj8KVLHpk?=
 =?us-ascii?Q?MW2tqrvEKTfRedvCh3fNZ+rUElU4jGe4/ErlDz4zHZHPK5mU7l+5IKJs4a5t?=
 =?us-ascii?Q?/Im5RSGJSrM2f7Tu8MVs/JhNnHegb4X2uYOZj+7yTfYgyz/dpnH9h1QF3NHq?=
 =?us-ascii?Q?eJYfI84Rzl8+nDdXzB1yY1gwEnJ8x5GlP/XTYTtqUYwfTb9p2MDylcHKxg65?=
 =?us-ascii?Q?j3w=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4951.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca86f8af-7d59-4782-6c4c-08d97d04f9d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2021 13:37:37.3644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Iy9YMzVdj4U98eUU2OtxsEk3UFpT92BCJA6ploF1SUkuaroYCNkuhh9KJLt9GoPCw48Nwim1ZH4rr83fgoKxP1LpCt5Qlw9W05554wijAQ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5126
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ido Schimmel <idosch@idosch.org>
> Sent: Tuesday, September 21, 2021 3:16 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE
> message to get SyncE status
>=20
> On Fri, Sep 03, 2021 at 05:14:35PM +0200, Maciej Machnikowski wrote:
> > diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.=
h
> > index eebd3894fe89..78a8a5af8cd8 100644
> > --- a/include/uapi/linux/if_link.h
> > +++ b/include/uapi/linux/if_link.h
> > @@ -1273,4 +1273,35 @@ enum {
> >
> >  #define IFLA_MCTP_MAX (__IFLA_MCTP_MAX - 1)
> >
> > +/* SyncE section */
> > +
> > +enum if_eec_state {
> > +	IF_EEC_STATE_INVALID =3D 0,
> > +	IF_EEC_STATE_FREERUN,
> > +	IF_EEC_STATE_LOCKACQ,
> > +	IF_EEC_STATE_LOCKREC,
> > +	IF_EEC_STATE_LOCKED,
> > +	IF_EEC_STATE_HOLDOVER,
> > +	IF_EEC_STATE_OPEN_LOOP,
> > +	__IF_EEC_STATE_MAX,
>=20
> Can you document these states? I'm not clear on what LOCKACQ, LOCKREC
> and OPEN_LOOP mean. I also don't see ice using them and it's not really
> a good practice to add new uAPI without any current users.
>=20

I'll fix that enum to use generic states defined in G.781 which are limited=
 to:
- Freerun
- LockedACQ (locked, acquiring holdover memory)
- Locked (locked with holdover acquired)
- Holdover

> From v1 I understand that these states were copied from commit
> 797d3186544f ("ptp: ptp_clockmatrix: Add wait_for_sys_apll_dpll_lock.")
> from Renesas.
>=20
> Figure 11 in the following PDF describes the states, but it seems
> specific to the particular device and probably shouldn't be exposed to
> user space as-is:
> https://www.renesas.com/us/en/document/dst/8a34041-datasheet
>=20
> I have a few questions about this being a per-netdev attribute:
>=20
> 1. My understanding is that in the multi-port adapter you are working
> with you have a single EEC that is used to set the Tx frequency of all
> the ports. Is that correct?

That's correct.
=20
> 2. Assuming the above is correct, is it possible that one port is in
> LOCKED state and another (for some reason) is in HOLDOVER state? If yes,
> then I agree about this being a per-netdev attribute. The interface can
> also be extended with another attribute specifying the HOLDOVER reason.
> For example, netdev being down.

All ports driven by a single EEC will report the same state.

> Regardless, I agree with previous comments made about this belonging in
> ethtool rather than rtnetlink.

Will take a look at it - as it will require support in linuxptp as well.

> > +};
> > +
> > +#define IF_EEC_STATE_MAX	(__IF_EEC_STATE_MAX - 1)
> > +#define EEC_SRC_PORT		(1 << 0) /* recovered clock from the
> port is
> > +					  * currently the source for the EEC
> > +					  */
>=20
> I'm not sure about this one. If we are going to expose this as a
> per-netdev attribute (see more below), any reason it can't be added as
> another state (e.g., IF_EEC_STATE_LOCKED_SRC)?

OK! That's a great idea! Yet we'll need LOCKED_SRC and LOCKED_ACQ_SRC,
but still sounds good.

> IIUC, in the common case of a simple NE the source of the EEC is always
> one of the ports, but in the case of a PRC the source is most likely
> external (e.g., GPS).

True

> If so, I think we need a way to represent the EEC as a separate object
> with the ability to set its source and report it via the same interface.
> I'm unclear on how exactly an external source looks like, but for the
> netdev case maybe something like this:
>=20
> devlink clock show [ dev clock CLOCK ]
> devlink clock set DEV clock CLOCK [ { src_type SRC_TYPE } ]
> SRC_TYPE : =3D { port DEV/PORT_INDEX }

Unfortunately, EEC lives in 2 worlds - it belongs to a netdev (in very simp=
le
deployments the EEC may be a part of the PHY and only allow synchronizing
the TX frequency to a single lane/port), but also can go outside of netdev
and be a boar-wise frequency source.

> The only source type above is 'port' with the ability to set the
> relevant port, but more can be added. Obviously, 'devlink clock show'
> will give you the current source in addition to other information such
> as frequency difference with respect to the input frequency.

We considered devlink interface for configuring the clock/DPLL, but a
new concept was born at the list to add a DPLL subsystem that will
cover more use cases, like a TimeCard.

> Finally, can you share more info about the relation to the PHC? My
> understanding is that one of the primary use cases for SyncE is to drive
> all the PHCs in the network using the same frequency. How do you imagine
> this configuration is going to look like? Can the above interface be
> extended for that?

That would be a configurable parameter/option of the PTP program.
Just like it can check the existence of link on a given port, it'll also be
able to check if we use EEC and it's locked. If it is, and is a source of
PHC frequency - the ptp tool can decide to not apply frequency corrections
to the PHC, just like the ptp4l does when nullf servo is used, but can do t=
hat
dynamically.

> All of the above might be complete nonsense as I'm still trying to wrap
> my head around the subject.

It's certainly not! Thanks for your input!

