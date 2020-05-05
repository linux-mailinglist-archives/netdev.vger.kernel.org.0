Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3EAB1C6214
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgEEUag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:30:36 -0400
Received: from mail-eopbgr20083.outbound.protection.outlook.com ([40.107.2.83]:3079
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726350AbgEEUaf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 16:30:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DxKnusg7SxJ0ojMbQ7DjCAxv5OJoCEhMTpizHGS5MKNqbqOxlgfY+EWXy77Rxfl8byR4kHETh4tv9KDPc0gFfXC2DOUAi0Sg4AYN3sPr8j0835EIS5t4nypS4lr4SoRVwZjj+4KIY4izWLTawH+PLrnTSL8cubY2FlgVEtDmd0g/CyAe2VxvqX4wRD8iHZiPwHsMrS5BkPbjUpKp1CpkuLf5QHRue6h6hoWSb6YrLMu6EmkZ/B+0bPiwbalFKFUwpeoCJ1yPuqgCtCv+PW/hqxKsK8FlYBe7jqlR1Ada/mEEORyY1BaM63jzA5oIZt613Rv5+Ggs4Xv1Gmb0Jgosvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQcTYS0tvs8l6+Bcw2969g5h6EQJQDTsaiu8DB7+R1w=;
 b=YGIT178uVuDLlxlHG+XbHrQOQMKgMUP1snqvkfilzSMJb1sMLKSzhkFr7Sfj8UUNDW6dbOm7yN2qgYPlbPsVzJ258as3S9BjFuCsw3lSQwk88Eu1pviFRxmDT++cbBO+k0frEhuQF+U0rXuS1GPNIapkoEPiNw7YBi0N+UR9ZRgWiQrQkp2WISQKHXM31f2N8ka1fK2Yjnyadd/COlFBWKN60vsXCp+PKNJvJ8XarTYPw4oIfsK7T+VF1pYmghNeZ48+3tfnPyoE7nETXUKktUnXofLuIx/3K+D5EUyxqeOPzDrL37Oe6qR8n9tIickXS7OO3k+FcCmmT0+iXEnFKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQcTYS0tvs8l6+Bcw2969g5h6EQJQDTsaiu8DB7+R1w=;
 b=guBzv5p57hfbR0XmBhKYVvGOcY309kFqCE1pSPOGomvNAwPEddw8VQWtA9Ct8+Fn1hMluWe/w3zJDICcFQBBrIzjbngDemzBTBhEXztjk+ruVUjbiBLqk+/DGtmOErMhnpximyecYR4wXdffOYbiLFKIKSS1mkfVwVWahbabmmI=
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com (2603:10a6:10:113::21)
 by DB8PR04MB6380.eurprd04.prod.outlook.com (2603:10a6:10:10c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Tue, 5 May
 2020 20:30:29 +0000
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::58e6:c037:d476:da0d]) by DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::58e6:c037:d476:da0d%9]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 20:30:29 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Leo Li <leoyang.li@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Youri Querry <youri.querry_1@nxp.com>
Subject: RE: [PATCH net] soc: fsl: dpio: properly compute the consumer index
Thread-Topic: [PATCH net] soc: fsl: dpio: properly compute the consumer index
Thread-Index: AQHWIxnwftGr9QjI3EaSI/Mop7aGF6iZ8TmAgAAAJpA=
Date:   Tue, 5 May 2020 20:30:29 +0000
Message-ID: <DB8PR04MB682898FB5705B70B1A54A661E0A70@DB8PR04MB6828.eurprd04.prod.outlook.com>
References: <20200505201429.24360-1-ioana.ciornei@nxp.com>
 <VE1PR04MB668714A83CC2EB638BC273208FA70@VE1PR04MB6687.eurprd04.prod.outlook.com>
In-Reply-To: <VE1PR04MB668714A83CC2EB638BC273208FA70@VE1PR04MB6687.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [86.121.118.29]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 75e1389d-085f-48e0-5283-08d7f13326c8
x-ms-traffictypediagnostic: DB8PR04MB6380:|DB8PR04MB6380:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB6380D0BCAA5DF86F944B78C9E0A70@DB8PR04MB6380.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0394259C80
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +Yz8w00UMw6HikZWRrhMzlWMkBjQIuX48zZUre7dNIbMCB+1jMAQQ1xfILOWdf++KLe8VskR6/kriWie+AtFZkKdUbCKx3YS14voElOCsbCINi7eAf/vdHiNkqyHUVUo4wbUeL1DYGkVZOuXJ8eXIWAWzwEdVp+tPX7j99lQKLmwapdEFg9x9jJSw/3jF1V9mxFDaWvrp3x7dCOgObAFL4WTKMPtgUhmBCj+Vf+DMKVFtBlCqSyx9en29iuK/gybo/ZeRGzK9DHBr5IxMlA7SE/14L+K2itsmoqkW1TaTFdqc/BfBL3F0sshjJLsPAaMqlNyPyidYeUb/c82SPPZRAVTaF7+kVzniDkTKRl3xVlBBOP63IM49j0jTLhjHXXGUCHHfRYg3VT8W9XSg2WwQYrGfzCozuQekwCrvM58Hme7CqJDlBY11Id/X9NHjd7P9hxiUki/IlMDrviCxIcLhw0YUTDb3nCPeIpsc1GbW7dHNgox8eOOIm8XxQEz/r1dBNTiRLElBJ6uNu0BQ0YX6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6828.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(366004)(136003)(39840400004)(33430700001)(9686003)(55016002)(33656002)(2906002)(33440700001)(26005)(44832011)(71200400001)(4326008)(52536014)(186003)(53546011)(6506007)(7696005)(478600001)(66556008)(8936002)(8676002)(76116006)(5660300002)(64756008)(66446008)(66476007)(66946007)(86362001)(316002)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: BVN9/JZBaWojuHagAWKgFl5A5aLv0GuFAJX5fyl8H1nx7OiMDONBK+mxs2yKF5Bs8Lw8oy7TRXSVval2OaEzEEMC+JLFmlZVt0LbtZy3w4/TksunpoijgeDrblu/RDdFocyuyjCt7tod69Rwoo65KERj84zChoAVxeSuL57oMtTX15mLwkzS7x1MJy/I/zZaZk6zgNbu5+KlWX7DJYHw3gNZfbC+Rbp7gLkdzIGpo4BLTNj8MoP29dWLZh+f/0JDk4vuRrfNn/Kx4BaVxHCVbCHXOgCRhNUYEbkjfujjBBXwobpRatLXWaSmuNJAq6JmhOdILJ2a1jkMjCSDk/SKKVbKDsUfSlE4Za8wRtbeebUrA+4EE/R35SQU1k4GXVCieavRKp/MEpUC/ta8RI9ZJYPDbOpv4MwSziQPEF8tLw8zAMB35ovm4hbKH8e6otc4TCvIFR+NnSHEjMLbY/92Z3MuS38ma/V70r+IXw1YAtatGben5siIu5DCzvjDMkiDwRIKZ4GIL7HqmoIPQKiKah8DaxV5PiLk0LDZjCXur++OwkGJrPTa97tr9MT540OKJvn/J1PqWtE5OCsx4RLILQomFSfwbmYJM/QkhHD3SZhGRlv9c3djzXnjHmngT/8kEUdYWY4zyM4iXkOldNa7oPbVVbTHumDqhCFiqSr6JYn6jzNEw0zqxyi0GdgTdENNeTqQzqBLEhtTvsY/Du+QmJj9+M1uDYfLuD/d0RcQExMPnonzODq0cSLK8DZ7X/9sDIaq9fhydjM6tFNbmu3XFu/DPMNiB/9jGygKIaCFEgM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75e1389d-085f-48e0-5283-08d7f13326c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2020 20:30:29.1462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mzsmf//4XZ/FaEam/Ev09/OFOHJyKuja85PakWO5OW8YEcAVJhq2hTnVIdR2pyPoc5q5ccaq+VjKRQgXP0OY7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6380
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: RE: [PATCH net] soc: fsl: dpio: properly compute the consumer in=
dex
>=20
>=20
>=20
> > -----Original Message-----
> > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> > Sent: Tuesday, May 5, 2020 3:14 PM
> > To: davem@davemloft.net; netdev@vger.kernel.org; linux-
> > kernel@vger.kernel.org
> > Cc: Youri Querry <youri.querry_1@nxp.com>; Leo Li
> > <leoyang.li@nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>
> > Subject: [PATCH net] soc: fsl: dpio: properly compute the consumer
> > index
> >
> > Mask the consumer index before using it. Without this, we would be
> > writing frame descriptors beyond the ring size supported by the QBMAN b=
lock.
> >
> > Fixes: 3b2abda7d28c ("soc: fsl: dpio: Replace QMAN array mode with
> > ring mode enqueue")
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
>=20
> If you would like it go through net tree.
>=20
> Acked-by: Li Yang <leoyang.li@nxp.com>
>=20
> > ---
> >
> > I am sending this fix through the net tree since the bug manifests
> > itself only on net-next and not the soc trees. This way it would be
> > easier to integrate this sooner rather than later.
>=20
> Since the description of the patch says it fixes a patch included from so=
c tree, it
> is not very clear why this problem only exists on net-next.
>=20

The problem is only observed when we enqueue multiple frame descriptors at =
once, which is happening only with my latest patch set on net-next that add=
s this for the XDP_REDIRECT path.=20

> >
> >  drivers/soc/fsl/dpio/qbman-portal.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/soc/fsl/dpio/qbman-portal.c
> > b/drivers/soc/fsl/dpio/qbman-portal.c
> > index 804b8ba9bf5c..23a1377971f4 100644
> > --- a/drivers/soc/fsl/dpio/qbman-portal.c
> > +++ b/drivers/soc/fsl/dpio/qbman-portal.c
> > @@ -669,6 +669,7 @@ int qbman_swp_enqueue_multiple_direct(struct
> > qbman_swp *s,
> >  		eqcr_ci =3D s->eqcr.ci;
> >  		p =3D s->addr_cena + QBMAN_CENA_SWP_EQCR_CI;
> >  		s->eqcr.ci =3D qbman_read_register(s,
> QBMAN_CINH_SWP_EQCR_CI);
> > +		s->eqcr.ci &=3D full_mask;
> >
> >  		s->eqcr.available =3D qm_cyc_diff(s->eqcr.pi_ring_size,
> >  					eqcr_ci, s->eqcr.ci);
> > --
> > 2.17.1

