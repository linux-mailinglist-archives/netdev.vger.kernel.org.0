Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952D3378D55
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 15:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348083AbhEJMkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 08:40:01 -0400
Received: from mail-eopbgr20071.outbound.protection.outlook.com ([40.107.2.71]:45058
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239682AbhEJMYU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 08:24:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=If1h92y3BETX+cBeybz8+K7iU1+OWYxbv4cPDQ7EgMZBcnfDHQQewKCfQnlZYs/3FKHVTZgSRKLhUb51BEFERGjDZuEDX/0rw5sc7woJu/48qQIzs1etJoUOOrZEj8v8hv45olD1YxKVidExDJYOYhqM3FiCHCvmjrMsAlgTKLGK6dHa3RQrl+nLPeL3whqCUxmN0yU7EG7ZiwJFp+2Kwmr4UEJFAeItVZSWjjuioJ9/ktxkiKj+L/+XhK2CH8MV9HsvgLPwuRvT4Rx+vWb+jmLS6TE78bcmcWNau0cxpLNvXTzCL2gDcA+VnH+dWN/4PtVy+TcI4elV79y8MLeitg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJmBj2mNVze9tbVzKu/ThTR3TPkVH+m4vgGrH6xRfbc=;
 b=OKabiEMZuMvbMS9EickpjJg/XJucUiTbmFD+5jxb4jkCubY/ALCqwM0ewy2A/7a/Gw7u459Q3kwHOKHXzvrsubbA3aj3B2dwa+aUjBfmRfHpqrJdTzENN/fFg+u37y839zaDsVJkrWQi7Klkomkow+a/Rp1xK6IIJdbDCqXHsw9k7vVvh3zHv6k5aEmKgILrgUp8ftgTqb9RY/ZlIwcgML+a3nBTF7wjp6E7Oq+eAuZpQS6fLNf2DaHGp4zls5lHXiPtDgP5IPjjthgm4lXNEBpLXQ0B9w8V1sctk6zKLD1Ql0vPrSb+/aS1MeqjdUxTHf8PHo8sPzHdCc8qlc+RpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJmBj2mNVze9tbVzKu/ThTR3TPkVH+m4vgGrH6xRfbc=;
 b=bnVqEOqO++RFqdA0yBxaYT5/NVzHzKf2ka1jm5mdw2N4IVR32O9TGi+na0We1hf+bJR5JNKdcGOm03M1/Irdhe6FTI8fdIAlxrFp5Zvo2IqD2i2a6DngFKwBegmw6+Ppe0xewpHALnR2r1D3yct8eUabpmAOuhTF6e26pnaGgT4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5693.eurprd04.prod.outlook.com (2603:10a6:803:e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Mon, 10 May
 2021 12:23:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b%7]) with mapi id 15.20.4108.031; Mon, 10 May 2021
 12:23:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: Re: [PATCH net] net: dsa: felix: re-enable TAS guard band mode
Thread-Topic: [PATCH net] net: dsa: felix: re-enable TAS guard band mode
Thread-Index: AQHXRYykSypWYLAzI0SAeT86R5BMnKrco1+A
Date:   Mon, 10 May 2021 12:23:10 +0000
Message-ID: <20210510122309.bilonsjl7sxontdd@skbuf>
References: <20210510110708.11504-1-michael@walle.cc>
In-Reply-To: <20210510110708.11504-1-michael@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [86.127.41.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fce1ed3a-6c07-4954-dd2c-08d913ae5fc3
x-ms-traffictypediagnostic: VI1PR04MB5693:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB569308A9C7158B84A4F14077E0549@VI1PR04MB5693.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:655;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5+R5+DySKCPCxUT2/c3rVC7C6ikdtW/aDSk2p+CyAGVQSA6/8zXZ3/4u19TwWhUGX0Hm9GJ7294L6gzfu65/0uR76UnvxsVrBjYqdAEV8u5oPTl9rd7t9uQ9vohMhWakj9qbmRwXAIRql5WM8rozn6sw3ObwoR0KfKTyzphkC3V4xPm/p5KdH8/sMDEK82L1uCPdknaGofp2AtiC+Li8/J9N12DQRgAEJAZ0NnjKzXZtg9lWlA7xs2JwyBUYSUzCqvgr1I8Wo8Ej4PyhxtHICEvj680d207xkSIxZ/+UlFPQv+ALd8fmRYJWLC6LanS/6pli1JenEJ1EhgB4pUcYLXAV9EpOP7ctLw7J7dAhkZHVK01Ls4988EbOmKZGWpIdcxBJZ7Y4IvY0xADHT8/oMp10qOrqpnPoy+prcKjBQzQL4vIFgZCv3dhKGFiaDhzyEzyhETPELt2GoNfZqydD5cYdIzq07UVdLhOswDE373CbnWrefupSk7YmlAmBr/73TK8cNvb09hR0T93OMjssqk3vnUr/B86LRXs0U9lu89SksN2Ez1vK52FSypoGk/8dPyjQK68+z5t56jDL1XZyQGOyhdTHoF+pHSrH0V5H50fUHUquZ4dGdRQbWj99CvO7Dz4TBuIENx2qLuOfa+SO0L/nUkblf724IOC2fUfN/oiTfGkjkf+PGg9c5Catj3uX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(136003)(376002)(396003)(346002)(39860400002)(33716001)(6506007)(83380400001)(4326008)(122000001)(5660300002)(44832011)(6916009)(38100700002)(86362001)(66446008)(6512007)(66556008)(54906003)(66476007)(316002)(71200400001)(478600001)(64756008)(966005)(66946007)(1076003)(91956017)(76116006)(26005)(9686003)(6486002)(2906002)(8676002)(186003)(7416002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?tKNnzaIh51GEVdSEojrY86VrRKT8+ZlwDJIRPn+zFnfKPY2gOgcWh63dBWFS?=
 =?us-ascii?Q?x/nrPTpN0rL7PAs8FVVDYKaDAW7+BIAXkx90Nc2hl1H9o60hLFJKGga5z8sl?=
 =?us-ascii?Q?dnoO3f9wH3VUg5vlXcm4kMH50UW3yzhHuRUh9JEUX4MaoP6WCbT5x5Ug8G/9?=
 =?us-ascii?Q?yY8ssFaUCNpWBWBKWGI8O0jCs6/wAhI3qzaiCqEF2Jv+BwaMnUFrj42V10xJ?=
 =?us-ascii?Q?lc+fmmRtioQosHLmY2UNRdf4ScKkPbgCBh9N8efnQK4/EJubreLdBUll1FM0?=
 =?us-ascii?Q?5zE5C3pc0nsIvi2JLh3hF4lIR9Uif5LTLVs8isAC6F4UbvLq58HE0vDqQvRC?=
 =?us-ascii?Q?yUdsjywR0omtYz15LkrzpW6voahI+ZW4JXlbfRsFzop4ln5oC+MYrHTqd751?=
 =?us-ascii?Q?V9l8cQomRBCJ4aGZ/7qo1weDEGhz3cYxN7dkMMfJFB3XZCPmTUs51RwtFEQ2?=
 =?us-ascii?Q?q+c6sWfBYwzeeovi4bHjnY7ypKEyqeFNZDacfMSsJvQSV0N6is5K3m5GpWys?=
 =?us-ascii?Q?fcgvFDd8q7AVIpQbexZ+HcpwKd/WIWrpkYgjsMX+Fjv8FHqtaqTuQLLNfpC3?=
 =?us-ascii?Q?lOdUx3FY/1ntDUTgCayN6cN1jT7K33Vm+bMw1GBy0+Fqu7yZ8KmXGZIuX1EQ?=
 =?us-ascii?Q?Ulw7+9hSze6ES3FBeHBMNlG9tbdQCXWXddNlDlSZsUjypL7M+BdnlWkKLlYO?=
 =?us-ascii?Q?faIP4NWBtfugY8Ltym1wK1jsiXEigLcGtVbopsNheQa7r0d+qtMilVN8h+Ud?=
 =?us-ascii?Q?mctXbHIYQVABuKusfO4XuKe2ZF6bp+IawAxN6RNH/pz336xcyIxuJSOsWNWp?=
 =?us-ascii?Q?xnYYzBahD+7sOVfp6Z4uc8JIxqk5p1HrG2l50Di0N024QiPKfWp6A1deTBO1?=
 =?us-ascii?Q?y3rv254qo0yfC3pXufAvGHUFOWYLFCbYCHB+GMcNMjY7yvPp2xsHctHsYIUV?=
 =?us-ascii?Q?F5IZNscAk3UCRIhmDIEPJ+lqpNIpXcuYqucX5T7sYshyeRgMVX3cLT7rnQIW?=
 =?us-ascii?Q?zF3qwO6Nh1vEQ4pb35onX5oKTPfJknu8+IMkn1RMDTDCnie+ATW1h3rquJuz?=
 =?us-ascii?Q?26NKAWbLf+A1VX/bD373mVMoGF6+LlCKsxg6dkYulSNdViWdghaS7bUGbcWy?=
 =?us-ascii?Q?5yAW2hlAv1uSP48rK0NYBPMabHORgs40RxlZHkibWT1YsliPmJSX2xzaFgfA?=
 =?us-ascii?Q?YKOOB+l1nwATMaVcV9U8IzAxAio2YH9SFRfMmOUEGDLdiSwzqsb70qDOiWiI?=
 =?us-ascii?Q?MZ32aJGRSe70qu+bc5QXjmVhIZ7k45gfOBy7mMaZc2ML19Kj4yCGO7MDxVkK?=
 =?us-ascii?Q?8a9LLxjzO5+04KxviiuA0cKa?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BB658B37AD8E6843BB0E31BD0A38B42D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fce1ed3a-6c07-4954-dd2c-08d913ae5fc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2021 12:23:10.0665
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sHOGDJKsua8EomFjou06erJMYDyUu4g99ezio86kVBGpY6l7ePOR/oL6/nb/83fnlLPN1khL1WFgR+lpdajraA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 01:07:08PM +0200, Michael Walle wrote:
> Commit 316bcffe4479 ("net: dsa: felix: disable always guard band bit for
> TAS config") disabled the guard band and broke 802.3Qbv compliance.
>=20
> There are two issues here:
>  (1) Without the guard band the end of the scheduling window could be
>      overrun by a frame in transit.
>  (2) Frames that don't fit into a configured window will still be sent.
>=20
> The reason for both issues is that the switch will schedule the _start_
> of a frame transmission inside the predefined window without taking the
> length of the frame into account. Thus, we'll need the guard band which
> will close the gate early, so that a complete frame can still be sent.
> Revert the commit and add a note.
>=20
> For a lengthy discussion see [1].
>=20
> [1] https://lore.kernel.org/netdev/c7618025da6723418c56a54fe4683bd7@walle=
.cc/
>=20
> Fixes: 316bcffe4479 ("net: dsa: felix: disable always guard band bit for =
TAS config")
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
