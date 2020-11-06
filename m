Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CE82A9FAA
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 22:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgKFV7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 16:59:08 -0500
Received: from mail-vi1eur05on2061.outbound.protection.outlook.com ([40.107.21.61]:49356
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728558AbgKFV7H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 16:59:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1NpSiINb17wAssPPVQOewTe20yJo4BXqqdWKLXas+GN6f2j2gU+x6+yzbkezIQZ7tssExsbAYphZ48BVeeJ5LZzoFuDzoPiErelzuHyXLeHImaLLBGseCo7PlY8QAgKaUYK08LyXVo4kX2Q0RiVugPve4C6Sv7WB7as4z8yrCK4vdlWXEpTOInm17TJgKP101vkBfx8ub8IvDqfa4T7NP7M40o85uyJ62gaZ4SAyOnpizsLoiZoghkj98qkzkC/N2OU/GzJNtykEOqjwCVF2BX2P/jbABlXV67DV+9VAcKfs3srxv4pjr22fgxl4DntHStwfhu4IDjH2Js35S3tTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DcihyPxgP5lYRLMgXYpTzPnjcew3p8qFPOKrPCY3Mic=;
 b=j4esiky0Hb/mNMEIb1TNiP2uwWBXvWnrXLkqYFVhSQ2jl4ovyP3A1EALOAFW7r/MtvdLScAyKgEzLB6AWVRasSRSQkx+s2ZvPB/qqNWcZLrwNs5d4zWOKfZRHXsnY9txpm6xpZPsh6DbZ/Gqovaa6/XOSlJKPdKrllvuB0x53tTlgXxr/XUNnk5C6w58TptacKfFlc07/rEe2s+jQNKTx4BXsK08GPeZ0lraHzA5S9znnRplSafJnU2BT1OjRgSePASaybegQbw428QDx12xNYDXHQOPbyr1TxgO8MDsX+sFdnv1FZpLPR5BZEmPtnZlOy0QuoY+OC1G6If/NP/3+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DcihyPxgP5lYRLMgXYpTzPnjcew3p8qFPOKrPCY3Mic=;
 b=OBx+NW6xsJUNidoud0/i6edGcCMc49FTzYpQZpdId07ElxRvXJy8pVN+0/giYpcwh2Lfj94bCjfz1j0ZIb93fcpGX5CcL/bryMsmh6uD3m5NNfS6QAs0lNThow93OMBGAmRH2A2fOW60lMS7Pib/L1VzO2TnYNs1ycDA5h2+7ng=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR04MB4277.eurprd04.prod.outlook.com (2603:10a6:209:41::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 6 Nov
 2020 21:59:04 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7824:9405:cb7:4f71]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7824:9405:cb7:4f71%4]) with mapi id 15.20.3499.032; Fri, 6 Nov 2020
 21:59:04 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Yu Kuai <yukuai3@huawei.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Florinel Iordache <florinel.iordache@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yi.zhang@huawei.com" <yi.zhang@huawei.com>
Subject: RE: [PATCH V2] fsl/fman: add missing put_devcie() call in
 fman_port_probe()
Thread-Topic: [PATCH V2] fsl/fman: add missing put_devcie() call in
 fman_port_probe()
Thread-Index: AQHWsdM4ySWiJD1cZESqG0elQpwlnKm4wxMAgALpWfA=
Date:   Fri, 6 Nov 2020 21:59:04 +0000
Message-ID: <AM6PR04MB3976F81086B9D212C98F7E35ECED0@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20201031105418.2304011-1-yukuai3@huawei.com>
        <20201103112323.1077040-1-yukuai3@huawei.com>
 <20201104173120.0c72d1b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201104173120.0c72d1b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [82.76.227.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d7cbf627-8e11-4110-5280-08d8829f2d25
x-ms-traffictypediagnostic: AM6PR04MB4277:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB42772CA889AB58BCCE883F87ADED0@AM6PR04MB4277.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VQYbZjw6h9qQ4F+D+RwpG4WKqcmFr7nGGPiiD8fBZEiZsSpF4vTR3daPT1dIYnlCzVjmeqb12g5DHciF/fxW0dOeFkObSGVOHtg17TltWKZLTgvuEXwXsUkYKZbLXce0TzeHDXAet0PQB5lM7EXljuHOOewImBz4O5/GGZf6OivBvUy0xOPI8imDFDRn6+hYaoBv6fUhO2PXF+OrowtrwzD6xEFd8H9DFVRl7cqUqEJrDgioODb0ayGLvuMnm1eXsi2u2XBsAPooRjgfN9D62wSyHMtIpXJ/sTVrImUZvyGcXoSsD9ZUPuK9wNfkufMl7udp7/DaIrPyP10h7O2Niw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(396003)(376002)(136003)(346002)(5660300002)(478600001)(53546011)(6506007)(52536014)(8936002)(33656002)(7696005)(4326008)(71200400001)(55016002)(6916009)(9686003)(86362001)(8676002)(2906002)(66446008)(66946007)(64756008)(26005)(66556008)(54906003)(316002)(66476007)(76116006)(186003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: i8M/773ZavzvHO+9956iPVBue5IofQ8gqxVVfFx1Nc7ajZ4asBkQB21s8auvmd2QBvw8u21tTLYzyTIhuuHyFa25xK/Dco7mA4MKyvCl8DZqh3no6uo8OmPrB7nLSvu/1GfNCmrvha6Y1Xy/Y9z93pPffERvI/+ckZKfxuHZlYCCz6vn9/HX8bt/FaHrKohpQzLGtYNPIczBSS0Xp/9Q2VbHHTqfKuQkz5LcoY52PkwOdo0+Z9H8ygqTP2025c4yFw/hJhSyH4VxUFo8ljeVWFukXHTzLIt9FsuhidfQkRYgnquo8tSqwAX6eFK3HWgaT+JLYUR/mK0i066dyj7WzdxdRHEtG0kFxPtXj3gvyYBL3kJ6/Ys0pRJFANX9OyppHKU0uehFamZA7jL84NE0zq+Xt/NaB20YUHmXy1B94XCiURTUZ3xxz3o0QilusKa39oqmnMahfeVyxsQMc1ea9gId2HCPZrO+A65weK7asZsMJ6LrXEKjOylZRnTg3lKuX7XaUtJ4KjwFmK992ekpEmq8ZYW8O4p6CsPWZFm0xDFaBTZotESSKjriMGpHH9I4oyyBsmBEO9BHicLsGLQA5SpCY/c4UgU76FufgDeNkL5JHfboespS6XNlipzbxTnfCaXIpkR2j+3n1g4ozmEj0A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7cbf627-8e11-4110-5280-08d8829f2d25
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2020 21:59:04.0897
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XLk+HWGBM5Pk5oWhzQjThDEKAvFAeQb0+D90G9JzWbPATFrw5mW5qvaPqxQM/MoFNacY+JZeSgB+ABSLRuBiOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4277
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: 05 November 2020 03:31
> To: Yu Kuai <yukuai3@huawei.com>
> Cc: Madalin Bucur <madalin.bucur@nxp.com>; davem@davemloft.net; Florinel
> Iordache <florinel.iordache@nxp.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; yi.zhang@huawei.com
> Subject: Re: [PATCH V2] fsl/fman: add missing put_devcie() call in
> fman_port_probe()
>=20
> On Tue, 3 Nov 2020 19:23:23 +0800 Yu Kuai wrote:
> > --- a/drivers/net/ethernet/freescale/fman/fman_port.c
> > +++ b/drivers/net/ethernet/freescale/fman/fman_port.c
> > @@ -1792,20 +1792,21 @@ static int fman_port_probe(struct
> platform_device *of_dev)
> >  	if (!fm_node) {
> >  		dev_err(port->dev, "%s: of_get_parent() failed\n", __func__);
> >  		err =3D -ENODEV;
> > -		goto return_err;
> > +		goto free_port;
> >  	}
> >
> > +	of_node_put(port_node);
> >  	fm_pdev =3D of_find_device_by_node(fm_node);
> >  	of_node_put(fm_node);
> >  	if (!fm_pdev) {
> >  		err =3D -EINVAL;
> > -		goto return_err;
> > +		goto free_port;
> >  	}
>=20
> This is not right either. I just asked you fix up the order of the
> error path, not move the of_node_put() in the body of the function.
>=20
> Now you're releasing the reference on the object and still use it after.

If you manage to put together a v3, please also address the typo in the
subject (put_devcie).

Madalin
