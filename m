Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315724706A5
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240583AbhLJRGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:06:21 -0500
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:46284
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244345AbhLJRGU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 12:06:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lofpnNKvLI+5XHYLFTYS/4xjVTNxJE4Ixda3srEYkHEDW1KrNCX9InS64HxhDFzdG62ZBykgDWx47+m4UqGbACjZ8BPRC8JKCNP/6SuEQG6kAqVd7CIrkVxKV+L9AcfcTSWk2VDGuLkkmDYeyP4vSGkjg6DOOIhVnb9BRSc0GOwMxFj0dDfJpEctLJMXpmgDMardjPhJ/+9MKAEbYOsFYI6CQsDxiWl8xfVTAyo1gdoHJnNUOD0EaSGZG13Jg1/8eo6U0GTtftZfxhKM/pJE+UoN1nZKhPV5x/KLusF1p2e3sXOVvFOXrP0dzxb4J+w+MXJKA9Rhoylt7pUPq1nxog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8iGBTRpRwgSyGPq3bQRAaeQSic62NsKy5ft5yt7WIxI=;
 b=nSTSJrzdRHROfu5rwqW5/THnvjRoozfD1ulHa/uJ5nNCOVz7wwwSc8rV/7iuHziWGEL2x/EdYxs9qxHJRsftQhik5/rYFTuJ+GBBbWv1N3XzS0rZjLmfl4GU5c+PIfd39DYfYazRF8uqVqmk5RDOLJr88d8w94hVUa/tVRjitEY6EhPPSkarkIhbMNxtxJYlmf8qrbdFvXoExBSdeJQgBu8YsbiEKO/iRdbwI3pUXSCEUbB50D68JHgqF5YOLVPZ3vs3F2UkhRuhJBivd0kBekSNbCEfI0OtaWAKZLxTEgazSxZUbSOLzrWrMtGETy/TMTeBRUxU916Wu1tCA3n8UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8iGBTRpRwgSyGPq3bQRAaeQSic62NsKy5ft5yt7WIxI=;
 b=bzpI18NXKv6QgDHONuLi6Z3m0A0wIbvPe7/QrW8WfqYmOZD5trrX1K0qiGD0MVxuXh918xYzoYvF4M+tR+Mqkt6a9FzboA6H1fhfKpzFFLlHYz1XHU5Pq4IInFzo1N/oovc42l8kCwnIEhsfoukWMl1In8if9jkBYeLq8G0TvJM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2864.eurprd04.prod.outlook.com (2603:10a6:800:b7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14; Fri, 10 Dec
 2021 17:02:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.026; Fri, 10 Dec 2021
 17:02:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH v2 net-next 0/4] DSA master state tracking
Thread-Topic: [RFC PATCH v2 net-next 0/4] DSA master state tracking
Thread-Index: AQHX7SPAys/vPXh1a06w39SkUSlBS6wrFFcAgADg3gA=
Date:   Fri, 10 Dec 2021 17:02:42 +0000
Message-ID: <20211210170242.bckpdm2qa6lchbde@skbuf>
References: <20211209173927.4179375-1-vladimir.oltean@nxp.com>
 <61b2cb93.1c69fb81.2192a.3ef3@mx.google.com>
In-Reply-To: <61b2cb93.1c69fb81.2192a.3ef3@mx.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a87c109-25d9-4b89-735e-08d9bbfee178
x-ms-traffictypediagnostic: VI1PR0402MB2864:EE_
x-microsoft-antispam-prvs: <VI1PR0402MB28649E5FEC559806393D5326E0719@VI1PR0402MB2864.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1sACODyAVElgBKTamCrvHu6CaRrQrVoQSbDEEeYGoJg3g3hn6AdDLlmGow0oH8k1Iw0F4HSL+H4ocLKjcDZU+GOPBhxAJYqgkMtQbwlC8J6V6RXPbKmcG2MlYCj28Fs4+OiHGblMgrLJLtHVW5BQH3Byog+nBNoXkvVg3UY5blFMjaaQx5FCouksyVr/KmErvQMCM/WUr4Z8F8GmVNcA2TCKjvX/Sh/u2DVYUZPglGkyBluk9PTCDxxDzs5gFxsTOEAMkw/MTqe7Cg+pO5zdYJoOhx84NXp7Sh0T2QOnsrNSuTMbQE7AQ6Q/vFVJaS4gfGp7ltI/q5kPyx6uyezwomkgpsnC30Ascd/0Buq1O6vGUAbcezWvD9bUcHIak/1Jr2KNeXTyluGjBWqmaUFYuyZBtZnUF9/LudzHKTi0zzZsdK/N1/bYl2clfY25bKvf1ATIwmDwA7FZR4AlHoPW03H9v0mm67zRXxjzZxdCmvqk/azSez3vom+RQCOnljMsD+FAjWixmtU2WdrIt8pQrgLRNNKiNMNbMWDnnNovPJunHJcA2P9i5v5eJZJ9jHFEeWmOpoAnuAbMh6WGaAg1InUbt9SRvgr+W9hU0d3oUz+6ZUyqvxWempW1hB33ampkZ5XxXvrDTRDNuzCMnc4AF3kGyXv7USAOihVm3KQc6xrOuA3Rl+93kHleFi8jQDE5bOooVG6+GAFygKglTteLBo2Zsak0FNGSLAAZHZWN8swBBQnSrX02OWSjZb0OJSBK9ZebGmof2utBoRcQJpfgmip0z8iRKFaf1IcLgxnpudw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(122000001)(2906002)(76116006)(38070700005)(38100700002)(5660300002)(508600001)(83380400001)(33716001)(1076003)(6512007)(8676002)(9686003)(186003)(26005)(316002)(4326008)(66556008)(66476007)(66946007)(6916009)(966005)(64756008)(6506007)(66446008)(6486002)(86362001)(71200400001)(8936002)(54906003)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Pir2wNCG/EGOELq8iGzQSPb2toi00xBIEmDp2cuo3cVsxmordK0TyoiIZ/BV?=
 =?us-ascii?Q?j7byupO1XKBpoqPARznRexyQvLkxy6suVy4onTyRniMFaggtqjSrvumICh+T?=
 =?us-ascii?Q?xOWW+yNfPhz+Kk+4hC+j+j8NnCJsRUhO/CnbaK8UkcsMzrgdNxScoXdsEDF0?=
 =?us-ascii?Q?jcwW2ZwO3LommTHs7Ep9sbKUW5AVznlzOBomEy6/6VO/3zhEXm5dvuFBoyhP?=
 =?us-ascii?Q?Xf7OHhhlHZoWRPIkvnaRPZWNIN8RbDAuwuRO1A93Ch8Kc850WucO1PAoE91/?=
 =?us-ascii?Q?hNowIkbP/mIdTWx18izQorWyF5FwbbvTwWq97+ALCRy5/a4YlOewBjk8txUx?=
 =?us-ascii?Q?gXGBKX6sMYjQE+nuRm5x/b+HY6FdL0ljBfga70Mc/63/OCnerQZqvMt0yfBg?=
 =?us-ascii?Q?+w82vpLRIpAA2GUZFhN9wKsN+JA3w8t5NGSEtbmGDbDqtMgrLfQL2xOmX5/0?=
 =?us-ascii?Q?Z/lUfNmtHeU3u5X2BbI8uqVjhB/0StY1rqblYwhZkNFvXwfxxOR4Cv7hJv5i?=
 =?us-ascii?Q?jRDDKjJ3CsKUbSI204CVTp/pgJygJzAIejl1T7mpu8TgRM5mVvyo9FT39m8Y?=
 =?us-ascii?Q?Bxu5wgbGjq881ONCSQnOx2pef2YJP9mEMDb3bPvJzfsR8K0fjJaMgT1p/Ut+?=
 =?us-ascii?Q?WP1ZUpZyzTOUQ4ZBafOq0kQd+D9+H+TX2Ex69hU/TkFtkxsOpymq/1v/47wZ?=
 =?us-ascii?Q?4cGIIf9RLhmgAanAz6mR1AQ9WaNKzafLjpHebFOys8ZA6iZSmQUhn2jNWyNl?=
 =?us-ascii?Q?gJW2NSSyW0GA6aFbeWSGk92iqdiGxX0MrO9oPOl8QaSwXBxK+OIXHBNZrKT4?=
 =?us-ascii?Q?0C7nxsKcfWh3CV+u6KBaJYXW7fQpKsB6ffP722AbWoLMjU3PTNs1WXNMO5ap?=
 =?us-ascii?Q?XinHYspqXl4o9j4qkg3BomVo8a2lGiHywYtvYroAEbR8CuQlD7RPT0IoN8ix?=
 =?us-ascii?Q?7uqG88nh50PPKINkDCAF6Wi8G/D10imUgTNs66UaonIOBJsEhiYYYuOPX9Id?=
 =?us-ascii?Q?kB0iZI3vpECcMh4EP6A0sitM5hXX/+v0487Keq2rl6BDmLXroOfO/KVPf4C4?=
 =?us-ascii?Q?3x7UDIugpenx/DbaE6AIoyNGpDg30wkvAM4Czhz6zO7VR4M8/rBR3+NMDbSO?=
 =?us-ascii?Q?M0BxQ9jTh+ojzlL9L7HmcdupUJNh5OC3KP/CeBmjh39jA8xMkcldOth94pu9?=
 =?us-ascii?Q?S4Vsf+G8IOv3jpmY8vmOL00z8Y4dyICQppb7nIPL6Wp1nrZvNTZQ2QudSwwb?=
 =?us-ascii?Q?c1bW5X4qleQjzN5zChBFRnWdTzUIXdor+B8JFdcsofG+UygcNaia0P5VCD0B?=
 =?us-ascii?Q?4opHoOo3GMN/QEiehBuOnATyN/y5TI4HYsblQ3hOND2Afe2WP8vIRW3gLRsW?=
 =?us-ascii?Q?Q54u97yJIhbrmVNdomAnNdY86VMl4m++LJ0mNmPEt0tlc+8Ry8KPXRO/V4bX?=
 =?us-ascii?Q?i5LcFB88eBgga1aLFegmCivoR8nP84dtyYdZCjcjv8fPYBNm7mFuwISdK53R?=
 =?us-ascii?Q?L3pzCI4UWM08wWqYA/P3YfVSBvHW2sIyNLtiTpWr4pA0+3maeSCh2AfwtVTV?=
 =?us-ascii?Q?3GVGRvZvXdi9dviM4QIF/66qx0LSxbKgtUVkWYZiOUBhOFi40Gjl3F/Go+vK?=
 =?us-ascii?Q?xkzpAwdO4KOnTdkhUEsSF0I=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C3060E3F6DACB4428399A1ACC77117DA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a87c109-25d9-4b89-735e-08d9bbfee178
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 17:02:42.6928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v6Ok5YryfoR4Yae36Wn3R2SN4J0WJ/TxGTDIJ8Pkp7ujEMHcQIGHffsGFe/bSXzuUFapGOXeAzWs4H2tdBqYyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2864
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 04:37:52AM +0100, Ansuel Smith wrote:
> On Thu, Dec 09, 2021 at 07:39:23PM +0200, Vladimir Oltean wrote:
> > This patch set is provided solely for review purposes (therefore not to
> > be applied anywhere) and for Ansuel to test whether they resolve the
> > slowdown reported here:
> > https://patchwork.kernel.org/project/netdevbpf/cover/20211207145942.744=
4-1-ansuelsmth@gmail.com/
> >=20
> > The patches posted here are mainly to offer a consistent
> > "master_state_change" chain of events to switches, without duplicates,
> > and always starting with operational=3Dtrue and ending with
> > operational=3Dfalse. This way, drivers should know when they can perfor=
m
> > Ethernet-based register access, and need not care about more than that.
> >=20
> > Changes in v2:
> > - dropped some useless patches
> > - also check master operstate.
> >=20
> > Vladimir Oltean (4):
> >   net: dsa: provide switch operations for tracking the master state
> >   net: dsa: stop updating master MTU from master.c
> >   net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
> >   net: dsa: replay master state events in
> >     dsa_tree_{setup,teardown}_master
> >=20
> >  include/net/dsa.h  | 11 +++++++
> >  net/dsa/dsa2.c     | 80 +++++++++++++++++++++++++++++++++++++++++++---
> >  net/dsa/dsa_priv.h | 13 ++++++++
> >  net/dsa/master.c   | 29 ++---------------
> >  net/dsa/slave.c    | 27 ++++++++++++++++
> >  net/dsa/switch.c   | 15 +++++++++
> >  6 files changed, 145 insertions(+), 30 deletions(-)
> >=20
> > --=20
> > 2.25.1
> >=20
>=20
> Hi, I tested this v2 and I still have 2 ethernet mdio failing on init.
> I don't think we have other way to track this. Am I wrong?
>=20
> All works correctly with this and promisc_on_master.
> If you have other test, feel free to send me other stuff to test.
>=20
> (I'm starting to think the fail is caused by some delay that the switch
> require to actually start accepting packet or from the reinit? But I'm
> not sure... don't know if you notice something from the pcap)

I've opened the pcap just now. The Ethernet MDIO packets are
non-standard. When the DSA master receives them, it expects the first 6
octets to be the MAC DA, because that's the format of an Ethernet frame.
But the packets have this other format, according to your own writing:

/* Specific define for in-band MDIO read/write with Ethernet packet */
#define QCA_HDR_MDIO_SEQ_LEN           4 /* 4 byte for the seq */
#define QCA_HDR_MDIO_COMMAND_LEN       4 /* 4 byte for the command */
#define QCA_HDR_MDIO_DATA1_LEN         4 /* First 4 byte for the mdio data =
*/
#define QCA_HDR_MDIO_HEADER_LEN        (QCA_HDR_MDIO_SEQ_LEN + \
                                       QCA_HDR_MDIO_COMMAND_LEN + \
                                       QCA_HDR_MDIO_DATA1_LEN)

#define QCA_HDR_MDIO_DATA2_LEN         12 /* Other 12 byte for the mdio dat=
a */
#define QCA_HDR_MDIO_PADDING_LEN       34 /* Padding to reach the min Ether=
net packet */

The first 6 octets change like crazy in your pcap. Definitely can't add
that to the RX filter of the DSA master.

So yes, promisc_on_master is precisely what you need, it exists for
situations like this.

Considering this, I guess it works?=
