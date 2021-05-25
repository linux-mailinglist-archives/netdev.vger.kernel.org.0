Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9CB438FD89
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 11:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbhEYJO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 05:14:29 -0400
Received: from mail-eopbgr10070.outbound.protection.outlook.com ([40.107.1.70]:25510
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232056AbhEYJO2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 05:14:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IwKNzxrk9h8C4k6FpaqM6PWiZ67EjWtxN8+YuScEPu/Yvg4HPcbXLZadMysiuA49Kgjnw+WWwWY/4JZQtgs1Bgcopvg2cwT0r5g3nae9GnL/v/ADk2hHBmBzqfo53Q2hIG+knH2vTr3rCiYi2zu3A9jK6Ls7pqRU6xBuOGJKRdMuhxwWBynbDj5dVWIVfihLsKEu14b8+G+UdSxlT/8YujrtV+2sognZN2foAC5oGPsm+N9XNXwR7r4CuWtOPplVm2l2dE2bh7VkmYB0eLFsJTahX7B8wue663+S58th5UU14dNZ9yg8V4AuUqZZyT9k/jKKzyxpQd7po0FQEiqgFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIQ0U7X0M0dl+JB0sMM6YxCj9yJ/oy/Ippt92W3ebTw=;
 b=LjJrKMU+JjopPOQC/OFPKqDyw4ilq4Bxdf8rRvClOE/+GJGVi1diO3wgt6YRIn13SgfNU9FntfQdFMpr1bw0+BVuEvg61MkrsyHwunzVqLK3tbO8V91YFZurdwilOqqDF6I9Ph9OVSFJxkeiDip0I+IMtoSktr5inMkImuIAMjJNkwV8kAiwZTLcx31tOv7R7K9QkBps8ZglI7gvXbCdVAASsW8NXem5MLtB963S3bgysh+aMFpwQohXkRSPITnr7oaKp4c9OewS4FFUc4cdFsvJMFYOnHOPKp97VhxF9p1ar2b15amiQka3BsKHrVNZlcsrKzow0ca0IaGpJ78ItA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIQ0U7X0M0dl+JB0sMM6YxCj9yJ/oy/Ippt92W3ebTw=;
 b=aeVmg7i60fyLAYLmQN+mHR+mO8ksZ12aoEd4vozsPpkjkqSQFZBMmRw7WCXNRjLLSb1Jpr8WQb34AgcYicg9w/30CGag73C+0IJAHJFDyolzH/4zDWvzKGi9LKLty4zuxPGzzrwd0YcB+Zp+3rpweRcKj+kSINjfSTzGRrhupXQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Tue, 25 May
 2021 09:12:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 09:12:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 03/13] net: dsa: sja1105: the 0x1F0000 SGMII
 "base address" is actually MDIO_MMD_VEND2
Thread-Topic: [PATCH net-next 03/13] net: dsa: sja1105: the 0x1F0000 SGMII
 "base address" is actually MDIO_MMD_VEND2
Thread-Index: AQHXUPOtxjgoyqJKA0+HF0tA084zCarzdtKAgABzkYA=
Date:   Tue, 25 May 2021 09:12:56 +0000
Message-ID: <20210525091255.yewlypibydfbux6b@skbuf>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-4-olteanv@gmail.com>
 <65e73b63-2c9b-b847-9221-91f23d2511d3@gmail.com>
In-Reply-To: <65e73b63-2c9b-b847-9221-91f23d2511d3@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.52.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34a2dbcf-4f19-4fac-25e7-08d91f5d48f9
x-ms-traffictypediagnostic: VE1PR04MB7341:
x-microsoft-antispam-prvs: <VE1PR04MB73416B7D1C197C3A412D7888E0259@VE1PR04MB7341.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OJUg7Di/O6EGErl5j686CD/dVY6tXtjxvFegFdL9SZs/yJJYI9cuW5tdKOtOlux4ypQnMS2VYV80K4bZM5VA/CPLY+4WkKpaqdlvqqIO/29LruDAkY/jHqyOZTDvpI9V4x9Muv5Edl2uMeLeZ5hxrHnB5EitQ2eR06b69RrP2DhQktiGAE02JqS8DbjoBpBLdrernSwZkrbYwFtnOiBmQA1uONG5TL/XmRVdqNAvsojOtdqzegNsUM4IrGG3+4tt98faStkICDzokMqZrltRjIbtRXFgU/1ZC9X2ydTOS5n5FZRyrH9035CtJ9L5eP2y9mZ5TfGsRB5V1jDhwrcouGvNUYhYYG1o7wDXt1SJFsL827SCJImRP1fm8yhGPGl5LcB+2ShlZ5+c0sYolQIky439jgB8yXfYtn1qaacXGvzbCAXv2MPL/8ludgTWmtBtk00J6JcP0yVRasIw3q25UltvJMrAiRND7sdQwAXflTwR/cDRfASEzFXDXGmClXqY77T9V09U0MPohjKRcl/jrCg0msUb9GewTH2xIalsbgsHvKJPmO+sp9AyJ2HPXhfhjJdylUsP0+LhC4AjNmUCfiqqICs+nkh2J9UtQyXnx+k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(39860400002)(346002)(366004)(396003)(136003)(5660300002)(66556008)(66476007)(64756008)(66446008)(33716001)(83380400001)(38100700002)(122000001)(66946007)(6916009)(8676002)(54906003)(6506007)(86362001)(9686003)(76116006)(6512007)(2906002)(316002)(53546011)(26005)(71200400001)(6486002)(8936002)(186003)(478600001)(44832011)(4326008)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: MAkSuZ0RJSjK/CWy8hQ05fnHZUq21SnvfnwpwIt3Cwl5dpf4V4S1wa2bt8H3R86gG9jjnBNC7ZPHLukLRdT15QnESdaONJPSF3Wg7oEWnTV/pZSwbZcT7yhm69DuJj4BzTV8gfGvLUUZGeVD7S0oMcUGYb5d3tNMF0SC4ZPiw2p5D+78qO1E/CyGPmydBu94O6Fc6oc3y47xo8e1xSAa8xN/SRIhdU2OWL02+ycJnDYyY4ZgsejjeCJgMy5gPsC+4r49SQ1qBvMpFARAMKJjcIKaSbHhW3O/Dilujk29Itsn2uXl0zZnjCFqC7C+FWEAeVb9tZDYz8/0tk9SSPv43RpX9CDndetS+LDmXLkRwD9RHprcGgyNc45Z51WWjsnyrBuHI7Zcac+xnxq1NCMaZFTH+Et6wz9TNf17Wh1bQ5b5YjzQw8evdFibK/G1feJC8kQiDv9KgrSywtoQiaXXcOEmL+x2bt65FnTcIK/lOqsR/TLv9+D/W0Y4rmaty/8dPRzhEp53sZo7ZxGUj4TXrLBuIRVJ9q2eYJpRKL70f2z+YPQey1IxcDvKOxptQi49sJqjqnPMjE58jVVBe/qG1INCO1vR34CDKCcU7xyeeOFn8Z1TKoK+W5T0lpTzXTv6d6xYb/bf4AtM2fv1gArlR9EywXi3iT7gNV1SnNFOa650aEo323A2B7yI4+1o5ChuyMl5S+vzGjAWSVERjp2nVliHVfwnbvBJUV18/BpBpZHqnhPmP7di9UlgsPEpoz6V
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <91640E3D9B190D419F4F8D9FF778C683@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34a2dbcf-4f19-4fac-25e7-08d91f5d48f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2021 09:12:56.3984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SNpdKEuBdfX9iXeylhq8Q3Wp1fK5wvhTqYPVpOLKvfy10qAFl/9VUnJvTpG/rL6cFDrm76KPxKI3os7K7gxgvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 07:19:17PM -0700, Florian Fainelli wrote:
>=20
>=20
> On 5/24/2021 4:22 PM, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >=20
> > Looking at the SGMII PCS from SJA1110, which is accessed indirectly
> > through a different base address as can be seen in the next patch, it
> > appears odd that the address accessed through indirection still
> > references the base address from the SJA1105S register map (first MDIO
> > register is at 0x1f0000), when it could index the SGMII registers
> > starting from zero.
> >=20
> > Except that the 0x1f0000 is not a base address at all, it seems. It is
> > 0x1f << 16 | 0x0000, and 0x1f is coding for the vendor-specific MMD2.
> > So, it turns out, the Synopsys PCS implements all its registers inside
> > the vendor-specific MMDs 1 and 2 (0x1e and 0x1f). This explains why the
> > PCS has no overlaps (for the other MMDs) with other register regions of
> > the switch (because no other MMDs are implemented).
> >=20
> > Change the code to remove the SGMII "base address" and explicitly encod=
e
> > the MMD for reads/writes. This will become necessary for SJA1110 suppor=
t.
> >=20
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
>=20
> [snip]
> > =20
> > @@ -1905,7 +1904,9 @@ int sja1105_static_config_reload(struct sja1105_p=
rivate *priv,
> >  		mac[i].speed =3D SJA1105_SPEED_AUTO;
> > =20
> >  		if (sja1105_supports_sgmii(priv, i))
> > -			bmcr[i] =3D sja1105_sgmii_read(priv, i, MII_BMCR);
> > +			bmcr[i] =3D sja1105_sgmii_read(priv, i,
> > +						     MDIO_MMD_VEND2,
> > +						     MDIO_CTRL1);
>=20
> This appears different from what you had before?

MDIO_CTRL1 is the clause 45 alias of MII_BMCR, all in all it is still a
cosmetic change in line with the patch's idea of expressing accesses as
clause 45. I didn't replace the "bmcr" variable names because that would
have introduced more noise than I would have liked.=
