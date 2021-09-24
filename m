Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22332417394
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 14:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344790AbhIXM7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 08:59:08 -0400
Received: from mail-vi1eur05on2073.outbound.protection.outlook.com ([40.107.21.73]:28128
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345092AbhIXMz6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 08:55:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WxXY5FkbP6NhvrZywN+NZHPb/GpM6rUjt0WT2ePSNKn/BQYICvBI11TYX7DGdb+AW58twOjIDppBjdlC8He4ecFjaHqXqBWkJPjDscMYzkEj/fLo6y7rwzmbX0OlHYlGBmbJ7a3rk7JM3+xgfkFNC/nOtJ0t9GV3OfeBg7aMW3PymVnLv+Mign55j7ZX6mCHT/5J16HZcIJ/0ekX1HAcF16yoP7cXmI6FSkG7qy4AeavKPHwOQjPOqeVjURxqSMXVVc1ihxLQiPQTwVixqtgVczbp9iVBHdKGAUCymna/SxzOObgN+VaPYeMlw1bf8J7NmZacApj8no1XjHJI3xN2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zOej+wuf8GEGAnlLSHpHQumAr2ll6GyuJlZ9kvJMuo0=;
 b=fe401KUXSRnHoQoYdk1Y73rdfd/Mbz46vE1mZ2GdRDLm/c9DBDcHnVngp5mz0dSjtbgsFmHtjBTjT8jS7SW4e5xF1sN4RsndvWhIH3AZaPiQOK2S/x2ngaEisxZPa1mFwQydGsGNtme0krMHJSZHCZDksZY1hAohy8krILeffyeYTWr0z0lP+VDFGjqLM91MurejL5HjkkSd+h5dyY/H1VWOIRfAt1/3WMOEd0xUqMGA5PYCffsh4+0ctNA0QhU1zZ+G6tqwXAtM1kRFEwvEnmnea6vXq/iFgk32gvqcyBJqg97fMi5JSinb/SbObSS4afEfCyLWwQayydFZhjmyvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOej+wuf8GEGAnlLSHpHQumAr2ll6GyuJlZ9kvJMuo0=;
 b=CkQxLM5dw4dRWpPVB0e5Wy5dltH5k7XIDH38VMmHSDQKOUB5w1BhmVnykC5ZBveGk1GTpXWsP1zHxRG2YGOu9nNVSJ4XhVTqQ51kWwMrID0LJSTUW/JZjAym/c+bQeKvBdvC1k5pP79q/EJhmmqBkicjD5pu4qP7iSPwCdoEnjM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5133.eurprd04.prod.outlook.com (2603:10a6:803:5a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Fri, 24 Sep
 2021 12:54:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.021; Fri, 24 Sep 2021
 12:54:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net] net: dsa: felix: break at first CPU port during init
 and teardown
Thread-Topic: [PATCH net] net: dsa: felix: break at first CPU port during init
 and teardown
Thread-Index: AQHXsJfQXuK6y2Ibd0qZLMveKc3p6quzJWaA
Date:   Fri, 24 Sep 2021 12:54:22 +0000
Message-ID: <20210924125421.qqm5pqwrupwkkjro@skbuf>
References: <20210923162641.3047568-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210923162641.3047568-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a2546710-74d3-4107-96ce-08d97f5a6e85
x-ms-traffictypediagnostic: VI1PR04MB5133:
x-microsoft-antispam-prvs: <VI1PR04MB51339D17F68EB6D25E0D99F4E0A49@VI1PR04MB5133.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NClt93znJrRfDZ4Qa1fqokyxCESU17zRICze2n2c+oFjtas3elimWTrZFPjU6oPv05RnNAQiy9wLremup271O8fjyYJJgELo1DsQPsh5S4+Gq75hVrr0SXE7S8BciBG56AibXqEcCrrKoBm6unWsk3hx3Q70vyGfaFunnnMG+o2u61FKs6/MkDBeiOkXYWf3g4T8wCSDcY1WBYu8kWiFYUC8P4rVVihLeEshHJFiN4lNQOITYJaAJE7mfQu0GBqQ71oWYIIxeJ8bAIyEghgeDdnjMzdcA3FhIfDr4tXx4Sw8RBGEZxWRbj8qKbivPiR1q3z4V0LFmEQCeR7cY9wGsVhdPeGhSoXT+Sci1E7+g3RadsDih7g5XjqMoIq0Fgf9QAGgOEonGZBY98aYO6kr0ikAE8LWM0zEJN1rb75ixFe2jAF5qKLQLBMzuj3V3klLrDfdZ4VFeRZ1Z8ZaU62Mkprg55UE8/3EBEHcutjQtDTc3Nejs5eoNfMYQ6wITY1QPquwuSyzMF2fuzM4vPGbJhE5Lqwucw/DcOSRIu9g2hs3gI1UrYoYOv0Y/kHdd4XRDz5WUzbKXX1a0iHk5F7Lo9BXeNxKYbsoq3ABdgg6whNZNnKTR1BzgLY3dWgeycKyBye0frhwzNKT48YMcD7CEIPZ0dWZFR6aGTCJpwpkbCHhH4z6D0UNlSqkiBvugBlIbAuDKX/U63ffDXD6IVG5SA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(5660300002)(33716001)(186003)(1076003)(2906002)(38100700002)(71200400001)(38070700005)(83380400001)(6506007)(8676002)(66556008)(4326008)(66446008)(508600001)(6486002)(8936002)(64756008)(66476007)(76116006)(54906003)(26005)(122000001)(6512007)(9686003)(316002)(66946007)(91956017)(44832011)(86362001)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XNMNA8BVxF1FvTSJ26xvSUCNwNGHQsxId/uQAUleI8gmbjauNzw0p45SeVhU?=
 =?us-ascii?Q?LFiLwFBitx680+dQGTOdOt/OBefTFZeRYtAFmHV1PKyh+MFHoU7Yd8Tc+O+i?=
 =?us-ascii?Q?BCvCLH4tIZ72SSE+WoGXgz4d2yhOctAwzK4PunY4eSr9Ibm2pL3pQMdOtlj6?=
 =?us-ascii?Q?Z6pEYNbZqYTEesv4T69VwAeMzhIVLGH5hSCPQAZMhnH9JmYYPe/jBO0IK0bh?=
 =?us-ascii?Q?K0KLcGJLh7meYzMipUenOOZwbKLnEEtWJXcG0/18vCHlCmLHpCz+tXPdttF4?=
 =?us-ascii?Q?rr1yL11asjlED0tivavuLTxXBks/FAfAupSkkzrdt+1ExLudDeuo7JUzfEpK?=
 =?us-ascii?Q?cD+IpQDCRgs9URViMLnGyWePU9doS8Sl+ke7i7GxW4In6aedeYzl9/dIenKc?=
 =?us-ascii?Q?pjO7X6GUWxbBazJtY9E3LRTFLqhAVA9oePRSHrw6hG6BUfhXyQk88tJUh/MT?=
 =?us-ascii?Q?GWXeZdsToLCKriO4g5O7YgOHvBDCipcUDFdPerDR1Isu6X4//CGucZeG7pWe?=
 =?us-ascii?Q?7icRklgDLt2gg+3tU0FmvqWpel7RdsUiMySxf+cNBJ8PdN6pOEbGdnqNF0Bt?=
 =?us-ascii?Q?+1KAexTN65OT4hmjzGJvLyZeGn1OB8KHOj+yi6inKOg3vp8C4h1LrqrnMrV6?=
 =?us-ascii?Q?suw80jOid+OWXcXQ2ByRiMLv2A0Zh338QUHV+tJZfT8n/XN2hmIeyUrBIuU9?=
 =?us-ascii?Q?tMLQ6un+IVZdaSYMoJg3w4NZy+TVfSMSE15l+nqx1kT4u24VrSca1zMzkotR?=
 =?us-ascii?Q?NRjTACbaPNiahSujWbBkJDcwNuDLO8qnQ99RhJNIQRxfNDrR9wK97q5CPkZz?=
 =?us-ascii?Q?0fLvctB5xp818jPPhXad2jRJp495QdMPJcKYsCivizwW079hOAbYQLYiJC9c?=
 =?us-ascii?Q?RiLJFhoRVi2UQ5FwtBiVq5+6X3m0WINLZ/pjxUea+c1TxaQWZc+FdZclfHY4?=
 =?us-ascii?Q?6tZ0viTjJxOv6KdJAx+gdaGvyaOoXIBJ+p5mFnAM7gKZopzXcIJfPxrkly0s?=
 =?us-ascii?Q?NuafyUDkwT0OhNT5rkUcPkH/fU2yeEN2J40LrwdkiRj+4xMi2MuU15IUFuhq?=
 =?us-ascii?Q?J/ARA5AnNsFAqUw6javPskzGG+5u/1/QMylBhTw4W4pnyZnqYJSJ+QYgsOGN?=
 =?us-ascii?Q?fivPM8vTIl23W9Zag4/yT5Yux0EGQH1nBHRJnCUD5SD25VbS/ApmsuxrIiSP?=
 =?us-ascii?Q?ilr5pDBgbsb71XAjKfytBbBm8tjpAEjK8Oeq/HiM2pKmpxf8Sq9WGGxpW3Xp?=
 =?us-ascii?Q?fQpxtI/irNw5M9XL6JvbZuozN2JM2YqCVAejFFrqH3XRermHvOQPMwT5Al9o?=
 =?us-ascii?Q?9j7fPuRU6A8zHveh3MUBcZ8q?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3B561841A5610B4C9C7BE49B9B26F555@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2546710-74d3-4107-96ce-08d97f5a6e85
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2021 12:54:22.6679
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YtJMpT8DSiZQm0ixwBTB2JLE1Svcp9dB9f9sF2i2ZVxkq/nv/7wVdG+6di+iUSqfHWiKRDXilmwF/rCX3VwWFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 07:26:41PM +0300, Vladimir Oltean wrote:
> The NXP LS1028A switch has two Ethernet ports towards the CPU, but only
> one of them is capable of acting as an NPI port at a time (inject and
> extract packets using DSA tags).
>=20
> However, using the alternative ocelot-8021q tagging protocol, it should
> be possible to use both CPU ports symmetrically, but for that we need to
> mark both ports in the device tree as DSA masters.
>=20
> In the process of doing that, it can be seen that traffic to/from the
> network stack gets broken, and this is because the Felix driver iterates
> through all DSA CPU ports and configures them as NPI ports. But since
> there can only be a single NPI port, we effectively end up in a
> situation where DSA thinks the default CPU port is the first one, but
> the hardware port configured to be an NPI is the last one.
>=20
> I would like to treat this as a bug, because if the updated device trees
> are going to start circulating, it would be really good for existing
> kernels to support them, too.
>=20
> Fixes: adb3dccf090b ("net: dsa: felix: convert to the new .change_tag_pro=
tocol DSA API")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

I will send a v2 for this patch, please discard.=
