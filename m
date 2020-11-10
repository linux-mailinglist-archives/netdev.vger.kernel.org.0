Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4352ACF5D
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 07:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732110AbgKJGCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 01:02:44 -0500
Received: from mail-dm6nam08on2071.outbound.protection.outlook.com ([40.107.102.71]:41728
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726467AbgKJGCl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 01:02:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M4UnNe3XvUy/vPd76Jqh3OaAEN9Q/yR1eOGh5DAco4aaNIxx9X64GoAtMulLG0pHH9aPqZaA+ACh8QbnbgmQ3uo4y4ni1DmWr2QAIV5BRU+dfNUkM49ThD10NUSCjXNIOu/E0vULvAgX7BildldxebtZnKvcnXVccrZtOAg6PJugqwytZVK+GqR+pNZZ3qGoyE3ig9bIyj3sShYuSUapw19lcAmcg4eJJmXV2og0eWKfHK4aIcQyI8JvcrTBThMu+3KsyNFEi9ekaNlr4/dg3dvBj9wcArXBIcHTQCIjxzBKFLiLY5aYN61rVLkm7zkIswSGKzzGzI/P0rajTtUrmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAxPC2PvPJ5MB0p82AJULmOtogvhcMD/ozhFTK6JIgI=;
 b=mIbvV344sUn6GTZ0MPAnoDxcsrUikf+remHFytKqYY1noOe7/7iL1YLw4PwskMu2guOt2/8kibBRwFVURJ7q0NSb1KBOCr8SyQ4/jnTr2Gp8Lx0g1ZJYBCoGkcF6R/ARPS9/1toHh950fj0cj76fQWpnBwk9d7okZvU+U4dWCzcTFRTnvBpso5cnELHYtFvGnSN472wumYProKjomprOjDNYQSuhi8bXkwAGFK0bfsmreSnHxTpwpv6JS3mftw9+LqQ6QK6+XmI9nYuxwBLBo0M/bXq6ui1/EXL6422ERikQgd5emeWPZ5oNIeY8ro+q4Dd8DV8Fti5j5uQpCCE9jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAxPC2PvPJ5MB0p82AJULmOtogvhcMD/ozhFTK6JIgI=;
 b=cabDtLB1pYvGV1hcefxIm4U8uYp97GAJ1clKhW1qvwP4WOfbVde787/mvER+EDeRxJAT1O7HP8ap7aWHuyJ0P9KSt3Ps0rUpvHmpjEyztykVbr2on16BuL1B3ho9UA7Modr06xNvIgpbKMEtvQ1ppznw6+llxOOaWdKWxALuIwQ=
Received: from BYAPR02MB5638.namprd02.prod.outlook.com (2603:10b6:a03:9f::18)
 by SJ0PR02MB7133.namprd02.prod.outlook.com (2603:10b6:a03:2a2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Tue, 10 Nov
 2020 06:02:37 +0000
Received: from BYAPR02MB5638.namprd02.prod.outlook.com
 ([fe80::c04a:e001:49fc:9780]) by BYAPR02MB5638.namprd02.prod.outlook.com
 ([fe80::c04a:e001:49fc:9780%4]) with mapi id 15.20.3541.024; Tue, 10 Nov 2020
 06:02:37 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        git <git@xilinx.com>, Shravya Kumbham <shravyak@xilinx.com>
Subject: RE: [PATCH net-next] net: emaclite: Add error handling for
 of_address_ and phy read functions
Thread-Topic: [PATCH net-next] net: emaclite: Add error handling for
 of_address_ and phy read functions
Thread-Index: AQHWseWiNQTJPcLYH02w+4w3GJSlfam9Fn6AgAPOzOA=
Date:   Tue, 10 Nov 2020 06:02:37 +0000
Message-ID: <BYAPR02MB56382AEBE633406AC6A258F1C7E90@BYAPR02MB5638.namprd02.prod.outlook.com>
References: <1604410265-30246-1-git-send-email-radhey.shyam.pandey@xilinx.com>
 <20201107113527.18232c34@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107113527.18232c34@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=xilinx.com;
x-originating-ip: [149.199.50.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 74cc5b0d-e054-423b-97d5-08d8853e39d7
x-ms-traffictypediagnostic: SJ0PR02MB7133:
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR02MB7133BF07BFCE957D01BF5ECCC7E90@SJ0PR02MB7133.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2nZmTtTsnfvrqDpGrKzw2AY8gEzhEA+z2sRkQ6Wq1BQQ1KigfU/cDzCbg/TokIKxGLkVUXSQg8nExYhqYpXOpj+5xIJr0jnErFMxYwT+wYWsP3CkCZBC8bQW5WhY5fnpxEbOfdwR6BC5NTUiOrKm4ZXBoLwBpvT1awX8V4iO4H/mxJH+8v/nNt/pWO5Df4GScjlDr37FeKKerOijMw2X0jjK/HOKJgTv/TBJ7X155eFu+gDJd8G2+RRd1Tkjjh/QuO+a2P8E7TuEKbQHkC+zPfOpfj2Ii9L3wu39qok9Z/6JXNFbwI6b4scf77WKeVr4xzP6h05k3JlA5fqdRwsz+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB5638.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(39860400002)(396003)(66476007)(7696005)(55016002)(4326008)(86362001)(6916009)(64756008)(316002)(66946007)(33656002)(53546011)(76116006)(9686003)(66446008)(66556008)(6506007)(8676002)(478600001)(71200400001)(2906002)(26005)(107886003)(186003)(52536014)(83380400001)(8936002)(54906003)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 3Q4w36ye3Ui9VppxTOC0YU2cPnItRHz6cgcPyZ7spJYdV2lCJNPfod6vBj4P6YIdubD4yyZTHRG5/SngbhAGB4Zb+FGusmb5OTLCFEpqE1fQlmF/Xz2Vc5Qle9FAqGpqrqDaqXuSf/dW4WrCS87WcJS7PrSLDe5X17FBAJ45rZjZm5jfVj7XzD5arvuZHsC1QQs/areRFwoQ2g9/Vq0RXyIFIGwEGP5/iyF1Q6G+GMqrlLCSto4uHPte1bhVqYXZJRrJ5lS/zbYuM1Akw1AO9OGU/xFh+JDjfnLKKHHUzf8cY+n+izX37xsddQk+SRsFFUdebfBXP25rcrUnhww0zEGLK52qmRb6txHxy7NcAhsnLN63/juH1nJIglnR0VVbj095tx3AhcKqwETRlJx70T2PV2+yji54y1hLQmy3/ggRxWXM9z/kr6d7nuxMu0J1BK7c5gVduS/h2JgskPMbOB2COIQ6aTZ6t4QdCGsFtXkBCoumPwY1dUYgqlnYgnRXPdx2mwLXTQ7pX8Ox4gxDmSZWYAAkvT0kZji9mGrUEHYe9nI0qhWSHRnS8goED0rtWLsLGtxgxUew7AeDdDbzbLKhGBnPHZGG6gVH5P8cKX3/m1gxMpw4T1MvDo/a3ftMIORb8FHmJcCwqOK+GaHKeVRODUwlVtnBm7rFseIDOWj4KlSNRCivQKEMQPs9Eq4tbxJpVczz501C30h0sz48ZCohWvwtlhR6OqzsRLxYI6OGuyUWV2cTJ/f+WPWJGry5Y1oQb7lAicGoUIb1913tkSdnQN+RpvqsZKy7690Fzw3DCjCdai52NK2WIBkyo4qOQXZ65qLOOq7FRYfN80WtEzQ+WLqvqm1oUHMC8YScsFKyYUAR7GOZPsAR62UfugcHa0dVIJzTWm33g9twdtRbwA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB5638.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74cc5b0d-e054-423b-97d5-08d8853e39d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2020 06:02:37.6908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qnt/SpY8Ge6Fp/LJHgYwd/3WSdv1V2hycYzFjhj/g8/+00XYbJRX2ehN/ydzevAHXkPmqGhWwcCepYhNXkZfFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Sunday, November 8, 2020 1:05 AM
> To: Radhey Shyam Pandey <radheys@xilinx.com>
> Cc: davem@davemloft.net; Michal Simek <michals@xilinx.com>;
> netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; git <git@xilinx.com>; Shravya Kumbham
> <shravyak@xilinx.com>
> Subject: Re: [PATCH net-next] net: emaclite: Add error handling for
> of_address_ and phy read functions
>=20
> On Tue, 3 Nov 2020 19:01:05 +0530 Radhey Shyam Pandey wrote:
> > From: Shravya Kumbham <shravya.kumbham@xilinx.com>
> >
> > Add ret variable, conditions to check the return value and it's error
> > path for of_address_to_resource() and phy_read() functions.
> >
> > Addresses-Coverity: Event check_return value.
> > Signed-off-by: Shravya Kumbham <shravya.kumbham@xilinx.com>
> > Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
>=20
> Any reason not to apply this to net as a fix?
Yes, it can be applied to net as a fix.=20
>=20
> > diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> > b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> > index 0c26f5b..fc5ccd1 100644
> > --- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> > +++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> > @@ -820,7 +820,7 @@ static int xemaclite_mdio_write(struct mii_bus
> > *bus, int phy_id, int reg,  static int xemaclite_mdio_setup(struct
> > net_local *lp, struct device *dev)  {
> >  	struct mii_bus *bus;
> > -	int rc;
> > +	int rc, ret;
> >  	struct resource res;
> >  	struct device_node *np =3D of_get_parent(lp->phy_node);
> >  	struct device_node *npp;
> > @@ -834,7 +834,13 @@ static int xemaclite_mdio_setup(struct net_local
> *lp, struct device *dev)
> >  	}
> >  	npp =3D of_get_parent(np);
> >
> > -	of_address_to_resource(npp, 0, &res);
> > +	ret =3D of_address_to_resource(npp, 0, &res);
> > +	if (ret) {
> > +		dev_err(dev, "%s resource error!\n",
> > +			dev->of_node->full_name);
> > +		of_node_put(lp->phy_node);
>=20
> I'm always confused by the of_* refcounting. Why do you need to put
> phy_node here, and nowhere else in this function?

Initially, we added of_node_put(phy_node) thinking about this=20
particular coverity change. But agree it has to be added for
all error path i.e better place would be in xemaclite_of_probe()
error label.

>=20
> > +		return ret;
> > +	}
>=20
> >  		/* Restart auto negotiation */
> >  		bmcr =3D phy_read(lp->phy_dev, MII_BMCR);
> > +		if (bmcr < 0) {
> > +			dev_err(&lp->ndev->dev, "phy_read failed\n");
> > +			phy_disconnect(lp->phy_dev);
> > +			lp->phy_dev =3D NULL;
> > +
> > +			return bmcr;
> > +		}
> >  		bmcr |=3D (BMCR_ANENABLE | BMCR_ANRESTART);
> >  		phy_write(lp->phy_dev, MII_BMCR, bmcr);
>=20
> Does it really make much sense to validate the return value of
> phy_read() but not check any errors from phy_write()s?
Error handling was added for phy_read as it was using return value
and reported by coverity. But yes we in a follow-up patch we
can extend error handling for phy_write as well.
=20
