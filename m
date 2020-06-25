Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0E9209950
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 07:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389143AbgFYFKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 01:10:21 -0400
Received: from mail-vi1eur05on2071.outbound.protection.outlook.com ([40.107.21.71]:27905
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726619AbgFYFKV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 01:10:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QREQcekcGTHK3/RCzvCkmpmZvv4pnDDXQpNt1HNzIM0sg93K7OFKpnNfGuMV7+FkOI2idRdY1b34uwAD0uXl/yFgCG988TTA6cpS196WDn3wYJADGrcqrUNJohDajhWTuJT1vKbFwiAD7bnZ56eoZVnf1o4g0Ug56BJSYA6gfs05165Vfjt9qBUuqGa9pjaKH0lkyBOmkOPQbMUV3TTaU0rpD1RCNK5PZym8k9Ags0yVLI4aD1GLeD3BvdBMTK5BB4uLlwDdGc7a6xxWlxE9Ao38Chw7u8MqlHtNnKt/ngh+AcjBxLgbxLbIezZYnhNbYYIFKTNGyFYKqTU0HWckPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iiv8bI0JzMkWM2PVVcQ85yF1XTjlUeEUpAEt2VMhVa4=;
 b=Eg4DMIvVzrxS7MVD36bH3lAgcuZ2GKT0Ct99Gd86AL1/Wfx5VCN3oqF/zGXgvzcIq7UWSPw5P/+9jhT0gZOK5/XFGf+5fYzhsWjRzzoyTaSeKlWKEVzMkM/6XyRFHeunaRdvmUXQpJ21EIm1qSm4bsHL0Z/V5grZgU32kqXJ90WKJpG5yN1w6Y9fXrLypzMEcDhSvYSIsePL0hBNbx6FOWG7HWjQBb70ki11ieahXACQMMIYd5nv+4XK/5/fR2qXyuiCLCBptAQwjN5lF38gzJsefSirsQvtOhwBrT73fYzX0RNXt8A6vliVt7jSX9BxhtP5iqFWTLwjR10fwlnwwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iiv8bI0JzMkWM2PVVcQ85yF1XTjlUeEUpAEt2VMhVa4=;
 b=WzsXxvryeuOexsSp38H65MHXbZt9l7QWEOu3EDZEgpjZlKe4iGGs3fihaohAzLmQzm0avM6ngRJIuGTUoqpXAHYZs3Yqp+DtklQ15wN8xLitNutHZzAfJ0e/DMBrl5lPg8bf4N8P0LvYCGZDPRIDcGIAuuNRLbBr/Eii93jNAJU=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0401MB2415.eurprd04.prod.outlook.com
 (2603:10a6:800:2b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Thu, 25 Jun
 2020 05:10:18 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3131.020; Thu, 25 Jun 2020
 05:10:18 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 3/5] dpaa2-eth: fix condition for number of
 buffer acquire retries
Thread-Topic: [PATCH net-next 3/5] dpaa2-eth: fix condition for number of
 buffer acquire retries
Thread-Index: AQHWSht7cgr6bth0X0uiSvxtknBq3KjogbgAgABG4EA=
Date:   Thu, 25 Jun 2020 05:10:17 +0000
Message-ID: <VI1PR0402MB3871EBD708F02A971E79526FE0920@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200624113421.17360-1-ioana.ciornei@nxp.com>
        <20200624113421.17360-4-ioana.ciornei@nxp.com>
 <20200624175258.2b7806e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200624175258.2b7806e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.56.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7abce361-c5c6-4e74-5ce3-08d818c60d93
x-ms-traffictypediagnostic: VI1PR0401MB2415:
x-microsoft-antispam-prvs: <VI1PR0401MB2415BD76451FE27EE0E31F9BE0920@VI1PR0401MB2415.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0445A82F82
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AZnFhWlkhMWFIn62rkEVF58YKkeYldBrSUSmsYpEr2qTyT0XjS7crWuN2LXq7xzu6iKa09M3MgclOqzBuyyavWIaPKTid8ENTniTrPAQ8dwwdPHFhshmmNsqfJ60Mdvbzl3ECGMTZOp9iqy2swheEEqLsHGL7SEZsmowaegS1J/pIBr0UsfTdrhnE6PjMFiv//XJM9aE7R0yAUg1NxzargY22L48ugwDnxoag8lt1vbbGtq33vM4dljYFeReKxgfVV5q9nlifLphMHVYP3HNuiNFeppcNAwz2Y9zwwfrFmNlmPj+QV/0s68OK3Hn/7gdFeBRyPmutQ6ZrsHwPBAmqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(6916009)(66556008)(186003)(66446008)(66946007)(76116006)(26005)(66476007)(64756008)(7696005)(44832011)(6506007)(316002)(52536014)(54906003)(8676002)(4326008)(8936002)(5660300002)(2906002)(9686003)(55016002)(86362001)(478600001)(4744005)(33656002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 1d261PQ17xYjagH6GFt51k/6wVVs5oi9TP1ZW084axTUsDdl0Lbr56/glJVZ8UrTnoyrh8NC3bkZ2x09H2QIpMdjb/XUFCt3EzjW8Nlu61G1Ob2fLhIrz+Q/iib2o9t6TudS1NAyXrID+uivvL/DHzY8BeXUnRTSCYeL/8EthYuwBTGA3LrWQEoZyvMNQRVKdSi2sg+740vfwXm+iUY53/xa5oJ67JU5sPbPsZVhsRX5fy6ftsgTYIuGbWSGviPV6FdqV908bV3PaHQnxtc4yp/g4tVDkXIlKqbTkKfBF8qJ0L7TZEz5Z88lB3R763eoh6Yn28tfFlXoWsh2pPwfDA3B4/z52XDAHigSehLcHQI8EgZ886rMfrjFmFwhqCohy0kzGY0UjaconDfJKpezB80hI099OpA5z2GmfRszGlTuEmKe4PjOozc3HAI/4v1GN0+Rfw/s8OlzGGvLJS+rSt6vnDPheDRldJw7dQykxW8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7abce361-c5c6-4e74-5ce3-08d818c60d93
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2020 05:10:18.2348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h7hXxXs4myEcpM/vZK++3WK21P2TMA5AvH1jNUYTVeCyCilW+7Fth8JIclgByy6sd3a9cRZOoGrL/Mb5zMImqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2415
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH net-next 3/5] dpaa2-eth: fix condition for number of =
buffer
> acquire retries
>=20
> On Wed, 24 Jun 2020 14:34:19 +0300 Ioana Ciornei wrote:
> > We should keep retrying to acquire buffers through the software
> > portals as long as the function returns -EBUSY and the number of
> > retries is __below__ DPAA2_ETH_SWP_BUSY_RETRIES.
> >
> > Fixes: ef17bd7cc0c8 ("dpaa2-eth: Avoid unbounded while loops")
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
>=20
> Looks like this should be targeting net?

It can go into net but it can also be merged through net-next since the
bug was caught by a static analysis tool, not really seen in
practice just yet.=20
