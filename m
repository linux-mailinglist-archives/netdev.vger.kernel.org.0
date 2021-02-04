Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFBC30F2C3
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235791AbhBDL4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:56:13 -0500
Received: from mail-db8eur05on2052.outbound.protection.outlook.com ([40.107.20.52]:30272
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235683AbhBDL4M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 06:56:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNgsp258JcNE8TjHmTb3+n6PQRJurH2IwlUQu6B21MzClIVhp4gFEhhZyXleClaFcQiUhPUnpwbYo476iBk8dso4u35/sjT+zu2GrB/IV/eWKK7pE7E0Xz3mNYjV1Pcl7BPvK4IGiFvYhe0aj8596BaGLlf2oyNC0uwXYcyCLfc/ihIfbBdHJgKNfIJe0cOo+vUtJHO9YOXZCo99TygwtcFYNpd02JI/OgiePRQn6QnRcx+Wu0oyVT20xAaf2a9ZLGC43hJwXUYvPmh5hi7PK5cNbXFAFrREI2ROxjykI0eyw1NUyBNeafsebN+K3NhlIvr9hAYYrrDO8QrTRuFrYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAPcOo8aD0QuEtZReDDJ1tPt4KVvwEa/D8ONvr1z6F4=;
 b=XxAyJ0XCOS/YeAKDvSb6Tjj7/vFVvMajdidR8KQ7m+umksjUxV+sQSf7szYexX5vj1lJxKMUWDyZxZ5sm7bvU4VVC9a5A5jnVCAhvLlv2mghwn23FlGHJ9M8YktHz/EVEdRLvfl+6dQnNvXxJ0rQur4eXC6HPKfWeWmM5rYcY5xQmKz0uSiHsZg5x973j+y5YZN9dB6Op1EN3bUm5DCs6uiYdo91xik62A9+sqdSYaz6Qflyq6s7KnEOz3wFxR65RLHXz4iDDBUygkO9UAc6qH8cU8ZIVfEL6f2enlpEgt73kqu/BV0vZpDOsis2lRjK/ObGxo85pdDd0tinjjD/Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAPcOo8aD0QuEtZReDDJ1tPt4KVvwEa/D8ONvr1z6F4=;
 b=aUAKURq3LRUOXOeulECRkiQCs8y5f97Nzv1PETPFZINFoRe734noGK/cthNId99xqQFuMYrsR1IO/io3VVCa8pjEpVEACuuS7VPQwaQK1qtpYkKO4+DzWs1eQycQJamraidOV/KpJ01Q/evLFcOgAEPS9oDQ52BsIyGiN6Df8AY=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB6877.eurprd04.prod.outlook.com (2603:10a6:803:131::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Thu, 4 Feb
 2021 11:55:22 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::6ccd:7fa9:bada:4]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::6ccd:7fa9:bada:4%7]) with mapi id 15.20.3805.027; Thu, 4 Feb 2021
 11:55:22 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net 1/3] dpaa_eth: reserve space for the xdp_frame under
 the A050385 erratum
Thread-Topic: [PATCH net 1/3] dpaa_eth: reserve space for the xdp_frame under
 the A050385 erratum
Thread-Index: AQHW+YnPkGf6mDF3HkiJWhcAPxnoRapHsuoAgAAsoxA=
Date:   Thu, 4 Feb 2021 11:55:22 +0000
Message-ID: <VI1PR04MB580752AFF9F191576278FC8CF2B39@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <cover.1612275417.git.camelia.groza@nxp.com>
 <b2e61a1ac55004ecbbe326cd878cd779df22aae8.1612275417.git.camelia.groza@nxp.com>
 <20210204085158.GA2580@ranger.igk.intel.com>
In-Reply-To: <20210204085158.GA2580@ranger.igk.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0104c6b5-98bc-4473-6d55-08d8c903c099
x-ms-traffictypediagnostic: VI1PR04MB6877:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB6877B522E6D6DFCDFEA494D6F2B39@VI1PR04MB6877.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vw9a5S6KUsT6xb9wWZ16e56W1j6NwKxiBEM8OudNcPi7En8rp7z3BSgHIGfYNiST6DstK4hAC3mk5QTisubvXeDVdV7kIvRuJkAzZGN6kFWr39J6LduF0eY1pu7DNzvtx6tF2Ytjslcp6Cu8BE1dEyD7CieM+Ew4i4e9CSNj62nPpVaQWzr+ZNpFSzNzt45lje/os9GuL0a6R1NhvXMMDd/T0lL7P1YuyWjENRuHr1z5l/mEE8kxqJ5ghqSdBMv6v7glyyIhIZ0lPzn9xCBk5b60Zln4llJ1NlgEk8pMOQFVeF0edN9EYIfixZ67nsnqnOZm9NqPkRI7xppnGJe9T7oNBapABa55Qp3pf+zKqNcwuMr6JCGBFcBKFLtSvkuJCCsbMDy9uuL4qHNg/55Zg/rKyPhSs+dbH/KCBVEFkVL8LbxZSoQGW6eXfjU/YpP7YRDczHuB2wiZLLi6/kRof7RhifuBQBSlqxLgXyan3EEe3anCJLJe7/u9Y0Hk9Z2rka9tHURXU5uOzmGYoKLRmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(136003)(376002)(39860400002)(4326008)(53546011)(66446008)(71200400001)(66556008)(186003)(66476007)(6506007)(5660300002)(66946007)(83380400001)(64756008)(76116006)(316002)(54906003)(8936002)(55016002)(52536014)(26005)(33656002)(7696005)(6916009)(2906002)(478600001)(9686003)(8676002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?zI0w8IbEwi3V5yhHpBqCvdYv8AJuwFAz1MTDgbbaDOYF7riUf8wKdX+U0NLu?=
 =?us-ascii?Q?rFbwILWvPkyklNrSiJXvjcti0+XkMN0huSB8mTZxt36hMhcasdh1oiUkjc6R?=
 =?us-ascii?Q?QOLStzRNDpf5PR/h+Tt8K4A1H6LBRB9W3wN2vh/NhFPGrbBHM3gXJzv1rlWG?=
 =?us-ascii?Q?6gu4prrw0EzudpdxVyNvsTnrTB018U/cHRmTj5vhAtmkTo0zGDBGc3ZWfXwf?=
 =?us-ascii?Q?eIvXQeBW/AhI7D6whTYK78At/pUadxnuCjqTMuTlO09zKcAKhUUM9xBfIjd8?=
 =?us-ascii?Q?v0as4FKmoh9/OKjrn/SqEfL2VpW4AOQ+gW16up2hNGY/xglcso4FQ7paHnBP?=
 =?us-ascii?Q?jmALE1VJyJerlrkn88/dDTM9+JosS2BrL6JQLm3MgKdbLzY0Fo7hpjfH1ota?=
 =?us-ascii?Q?6cMhivnJkGIj2oXxnD236XG4FOhspz5OdBNe9EAlMw2BSFds9RZTqoN0XiZV?=
 =?us-ascii?Q?9Lk5ZUdo/NDvpqslO3Z66vM/I+/89XW5cRQTB4fbQ9haudokeO/ScKpxk9A/?=
 =?us-ascii?Q?9fE6YF+08MthGriImQzsMT3gePccCA45GMMcTRsa7bbmzqCew6ih0At0fLRY?=
 =?us-ascii?Q?bwjqr4Lc6+KPN18n2O+JKURuAOzeAMJmcussIg6kHamPN1xqoSOoazKyadfJ?=
 =?us-ascii?Q?KotDeHe8ZH9KsnqSqZir5LsEHjjOFcxXTqt6M/TPTdDME6pFZH2MviVjHas2?=
 =?us-ascii?Q?Gy/Wt6PMbL59OMqltGvsPlfVZaRraxQ1r0g28r1Io3SdW9+Rc+R97g5R9fQR?=
 =?us-ascii?Q?51Y/o1229Gj8Cg6yRz5CR3YrcR8ESQYdj547FM25oTXB742R43fywg7kbkA0?=
 =?us-ascii?Q?g1xTu4+kQXm9gmz6QLiqRq8m2Ec4E2Rfr/ahsnRHtEhu8/LPHUlKOhBLL8UJ?=
 =?us-ascii?Q?xZJ/O3e8fAcbLOwPkAztQujAOMa5n3/1V1zVNzTx2Bkb6xbtchGQRXRILQwi?=
 =?us-ascii?Q?H3ZrnJbCFsAWAuSHPcRNjqgidG0MF+dGST3bDvo6/7EnPH+HCArMkHkZumz2?=
 =?us-ascii?Q?piW1MEbG0iQ/ioHohVFzqy7smPExGZhcbDIKTz718tY6Zxq594X2dlArf5pC?=
 =?us-ascii?Q?CDV/bJRPNcymOZBnHjJgxndDy3xrTc9hUiZr+/eQ6Xjf/M/3f7ZXu9Ie4ZRU?=
 =?us-ascii?Q?YY9VApcdTu7mJOzXS4ynhr7Acx5m6VF3LBm/r2+A9PnRBr2eepZ/8f8yl1+a?=
 =?us-ascii?Q?SmSUG5T/gC7UKmHhwP+eynzEYRTFSuWjtVPmfAyaq0YQg6VnpgUWPLO9vKxd?=
 =?us-ascii?Q?qWfPJ2YnMj9z5UuhX204ke+o8cYnlZzjWlF1avWu+Z/ZuH+EMrcnk2A2CkU5?=
 =?us-ascii?Q?g/g=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0104c6b5-98bc-4473-6d55-08d8c903c099
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 11:55:22.5510
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jRXprn0He6pJfw1dcUjAeZ/l65zixGQeAS3aUaR39FURYV8W8LNNuGAUK9XvcSs0LdqydngReoil9L9+OMi8EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6877
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Sent: Thursday, February 4, 2021 10:52
> To: Camelia Alexandra Groza <camelia.groza@nxp.com>
> Cc: kuba@kernel.org; davem@davemloft.net; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>; netdev@vger.kernel.org
> Subject: Re: [PATCH net 1/3] dpaa_eth: reserve space for the xdp_frame
> under the A050385 erratum
>=20
> On Tue, Feb 02, 2021 at 07:34:42PM +0200, Camelia Groza wrote:
> > When the erratum workaround is triggered, the newly created xdp_frame
> > structure is stored at the start of the newly allocated buffer. Avoid
> > the structure from being overwritten by explicitly reserving enough
> > space in the buffer for storing it.
> >
> > Account for the fact that the structure's size might increase in time b=
y
> > aligning the headroom to DPAA_FD_DATA_ALIGNMENT bytes, thus
> guaranteeing
> > the data's alignment.
> >
> > Fixes: ae680bcbd06a ("dpaa_eth: implement the A050385 erratum
> workaround for XDP")
> > Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> > ---
> >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 17
> +++++++++++++++--
> >  1 file changed, 15 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > index 4360ce4d3fb6..e1d041c35ad9 100644
> > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > @@ -2182,6 +2182,7 @@ static int dpaa_a050385_wa_xdpf(struct
> dpaa_priv *priv,
> >  	struct xdp_frame *new_xdpf, *xdpf =3D *init_xdpf;
> >  	void *new_buff;
> >  	struct page *p;
> > +	int headroom;
> >
> >  	/* Check the data alignment and make sure the headroom is large
> >  	 * enough to store the xdpf backpointer. Use an aligned headroom
> > @@ -2197,19 +2198,31 @@ static int dpaa_a050385_wa_xdpf(struct
> dpaa_priv *priv,
> >  		return 0;
> >  	}
> >
> > +	/* The new xdp_frame is stored in the new buffer. Reserve enough
> space
> > +	 * in the headroom for storing it along with the driver's private
> > +	 * info. The headroom needs to be aligned to
> DPAA_FD_DATA_ALIGNMENT to
> > +	 * guarantee the data's alignment in the buffer.
> > +	 */
> > +	headroom =3D ALIGN(sizeof(*new_xdpf) + priv->tx_headroom,
> > +			 DPAA_FD_DATA_ALIGNMENT);
> > +
> > +	/* Assure the extended headroom and data fit in a one-paged buffer
> */
> > +	if (headroom + xdpf->len > DPAA_BP_RAW_SIZE)
>=20
> This check might make more sense if you would be accounting for
> skb_shared_info as well I suppose, so that you know you'll still provide
> enough tailroom for future xdp multibuf support. Didn't all the previous
> code path make sure that there's a room for that?

Hi Maciej

This function will have to go through large changes anyway once we enable
multibuf support, so making it future-proof isn't a priority.

Instead, I do want to return a valid xdp_frame so I need to guarantee the
tailroom is there, even if we don't access it . I'll send a v2. Thanks.

Camelia
