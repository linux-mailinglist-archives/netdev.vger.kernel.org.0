Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CF6390051
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 13:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbhEYLvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 07:51:41 -0400
Received: from mail-eopbgr60042.outbound.protection.outlook.com ([40.107.6.42]:57469
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231304AbhEYLvk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 07:51:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIGUSNLSVxHH0axtar74w1OJh37Oq44MGazPJCxT0ECVU8x2RcpPmW3iler8NmiD5VMIc30t0pJpohhG1ZJnZkR+6lIRKcnCXoiOBCtxlaP9a7pojECBVbewWxn/LZPq/bWya5B2ZnesWsA9ZgGbGOquvmQPkXP3mhrXpMTPvvk7ODlQ11XAslI5qAOZ+cE0/m7gC/huFbIlmu2ta+aNnhNC8LLeWlRGPed+cIn5OH8MWSIH3gWGf2j6phdzM0vY0lDU+SZzA3NM74lRsGPIJ8lyo7Fi5P8m4vnJZQOA5MxExdSTaOOfXWztwiD5QPs18m7qzRbRKqRxr9Tm84r8tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RL+zWnKwx6vgvfE1MKDfaAwnOG3/3Y2H4GyYC8Fgp14=;
 b=mEZfrMFQlU1k7TiINzuXn4V1ixRYhW5si/gDtc5jx18PG4Hp8gqlRsSH5Y1ocZXgzf/jwY+f4EJUIfpHzgGbjNU1H+hUQGwS+jhfKBshZm+R04JUuG3I7l2Qp+3mmKrWfiLTQBDVqSclV28PwOQN5DOY9NNXrB097dYEchN0fpnDmSgOIswYgiekVjeeR0zntMtNjOJJFmqSHafbqgZEbuapsDpukER3qDicfRoETpM4eTCkGCoo5M3Giu95LqcRpSEg2rH+HKc9fr+wN6O7zf2OsmmzYgfgtBLZDWbv0H/rPYV53p/imk+OvAGzMXIdF1SCqOdXYKa8COGlV1EeCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RL+zWnKwx6vgvfE1MKDfaAwnOG3/3Y2H4GyYC8Fgp14=;
 b=NDf4X5C7bP1UofSA+XcH+bttHa3IrSI61SAnaoe2D8h4WnYaPHqaj6LO3gNY60movSnpIpnQHNEMAM/Cmv2fyv3CkcSlEkqSMOMVWazrB+PKvannO9EGB9nfV91RsCpupmRQ5GvvwDoJLxiqTIFP3JzLr8PtXUKdpW0Nq4FMF3c=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3072.eurprd04.prod.outlook.com (2603:10a6:802:b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 11:50:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 11:50:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 12/13] net: dsa: sja1105: expose the SGMII PCS as
 an mdio_device
Thread-Topic: [PATCH net-next 12/13] net: dsa: sja1105: expose the SGMII PCS
 as an mdio_device
Thread-Index: AQHXUPOxktLj1+qKOU+1ciCDFrBMIKrze1mAgACa9oA=
Date:   Tue, 25 May 2021 11:50:08 +0000
Message-ID: <20210525115007.ntp52e4vutybb7lq@skbuf>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-13-olteanv@gmail.com>
 <5c287794-1f47-ad79-0a60-2eeec8469a5f@gmail.com>
In-Reply-To: <5c287794-1f47-ad79-0a60-2eeec8469a5f@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.52.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9826447c-516b-4000-15f2-08d91f733ed3
x-ms-traffictypediagnostic: VI1PR04MB3072:
x-microsoft-antispam-prvs: <VI1PR04MB3072F8EE2A916FD9E40E380DE0259@VI1PR04MB3072.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Muwonlrpd9pnybIo1KJ3b19g4eCDwT9wM6NIZaIgknPQkQ/5RMikZ4l9JYD9QPBU4zMLX7KUxSk64DXaM/dcJSPl/sQfqebsgiHqzXRTQLy8znyCtd7K1kCGzeyAKU3DntaaA/ZlTheaPUq0a4USr6Wzm5+QDt+lhbhmSk71nfga2Ih1zqu13AAOPv+7fbnmL5VQSM4FawBSO8EFDh+NIXhmDfaLxT7LmMrTawSuoActyzqnK/A7K7vnScx51ROvOJe9y8KxVhlDCkqWjHcJ/Ns+4wkMNBmN1hy7iCT74XwYl6o+J8hileLaqtvzE9j41S45ew8poJXOAJ9lSY0D5VwjhN3+6I4ICH7FunS/oiPb76AIDdonUjC5H38EIrxrh06URNq5aWowovRJZab5lZDGEwdHxSzaCoCunOH0rvFJMGKGfAG5/cn7uqaUmYjGRfpxdeXkr8nTM1EtFP2HC20Eo7gurGWDLx8SX1/gpPFRaKJlqRyoTxy5HPjXhot9G99pa/xJMEOcNHvcwVN/pJpiYYz4e7U1elmCqhNqDIBDFQ1l6wyqdnNWco/8UY/z7U21ezEPj3YfFvp9tP07NthIbQ5WyGGa3zSPhG0QAS4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(38100700002)(86362001)(64756008)(66476007)(2906002)(66556008)(66446008)(66946007)(498600001)(6506007)(76116006)(44832011)(186003)(6486002)(5660300002)(1076003)(8676002)(122000001)(53546011)(54906003)(83380400001)(8936002)(9686003)(33716001)(6916009)(71200400001)(26005)(4326008)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?eUCxy7qxL2uzx4LiGOoKnueCFGYCRSWOmpZVNVLioLnTi3nwBsONHaq+82cl?=
 =?us-ascii?Q?QIY1DmGur9E36bV4VwKR4Bl+/ZHGPYCOTcFlPeHwwmqcsq0Y2pnOWhlw2BwJ?=
 =?us-ascii?Q?Tb6smr618zHv/3t5ugTwHn8B5kriXUgWkOz8jR3P+YEzjNtJ5xOrrPFmiDgr?=
 =?us-ascii?Q?jAjAQqXhQfW9p+5psXxsZj44ydB/R9IoAEzQSvvj+IUwb6VWzzJokQHQVZUh?=
 =?us-ascii?Q?d7GlXrEIRXjxDEOU6HnxeRgFotlwkq8ZNDdw8ErWhX96srxcFudnOc8+OKxf?=
 =?us-ascii?Q?l1hmNhve0reiNZOJ/hPPKBFRo4maXEb2uByv6JjSNP/OA90La4zUObxVMi9k?=
 =?us-ascii?Q?r/70wOVJqAcG0baBSvr6W2yvC+QOhbSqpX6GS0/WTh+7ZsJJbhAFOhobq1xE?=
 =?us-ascii?Q?gFCfkBEg1cL/cOo9z2EpCxaSOwWuUEy/Swo0FY90LxzwfzQ9KxNW/UbV7oXG?=
 =?us-ascii?Q?GDnlcm7vClCZPSrJwjUoXXNN64LhWcq8eUyYDxpWaoaHaF9aQluv7udA+UT9?=
 =?us-ascii?Q?xZs4HjU1EwxVD3s0hmOVNiqWDTSJx7CTnVfYapVhzn+ikmuabBJysc7+55ui?=
 =?us-ascii?Q?HGVn9oDPER9WO8T25inkTWFJQ/4A9NboNTDfHE929HM4ZzvYEbX37hx+zLat?=
 =?us-ascii?Q?PDcyFm2rG7o/eBiueYIcCiLnYp1yNoBvzWtzRKrd/e6RoKtwSZKVdlGjIYwM?=
 =?us-ascii?Q?v+LFX/BTpQb+XXQULKnL0PP/AFczOJ311gW1lbDeBudZtji2s62qXBDbWmyL?=
 =?us-ascii?Q?THB+wY/lOv1M4MykoGe0AUPV1UpTtkTe9/OG03vgnECSmXBM3K1Zw9eAVIGB?=
 =?us-ascii?Q?C7eGcSpxfD5QoSVBACBW9PW0FJV+T2tmhirqnwL5E4nQ6F6MmjULQMVKAVts?=
 =?us-ascii?Q?oIa3VXvfhqVdvMt9WMbkhN32nOjFINMeMTfYDE5AevSnfQcsX33YwWdIM0er?=
 =?us-ascii?Q?3j+qk5WBZr+8xF92qtelB+xFV5qUaA8OIIphBAa39koxA8YVVJYu0Jstj9Df?=
 =?us-ascii?Q?/LzzRAbSirLnjom+WH/7oIer3s6WEmJ6fEv4Iy8F4+A2FEXSEiDhyGW+X7PQ?=
 =?us-ascii?Q?yNMHaQPocnf9CQY4R3SwTL8jWpZDoIOAsWVn+tL1F+aeJqyi1HvqzxZYtvg2?=
 =?us-ascii?Q?xOssX9aaPDiPBqDQiIVh8QhjIhZo0IzVvqdLLCC//hBW+XdIpUBw2N8B3ulX?=
 =?us-ascii?Q?FK7p78NLsIFUpDxQ2FmsZ34dR3sfRFQ1A6hwVp2rui+ukzTIjODJXAkQIfSH?=
 =?us-ascii?Q?yrV3N4I/QNeXGAG63R/LhYiYNO0W2FKD0PlQz5TE24T6fUnSu78v5JUTS5hf?=
 =?us-ascii?Q?s7qklVWnB+7XyCDGCmw6jp2l?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0ABBFCB622080742AC8860D28386FA40@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9826447c-516b-4000-15f2-08d91f733ed3
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2021 11:50:08.4057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8xwpaEEtrr7poferiH8XCKf4rPeDeTyopD/+1t/VHnJpMQB2vMIA+vUGcI5HKY2LapmJqS8PjBld5vkHB/eKyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3072
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 07:35:29PM -0700, Florian Fainelli wrote:
>=20
>=20
> On 5/24/2021 4:22 PM, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >=20
> > The SJA1110 has up to 4 PCSes for SGMII/2500base-x, and they have a
> > different access procedure compared to the SJA1105. Since both have a
> > register layout reminiscent of clause 45, the chosen abstraction to hid=
e
> > this difference away was to implement an internal MDIO bus for the PCS,
> > and to use a high-level set of procedures called sja1105_pcs_read and
> > sja1105_pcs_write.
> >=20
> > Since we touch all PCS accessors again, now it is a good time to check
> > for error codes from the hardware access as well. We can't propagate th=
e
> > errors very far due to phylink returning void for mac_config and
> > mac_link_up, but at least we print them to the console.
> >=20
> > The SGMII PCS of the SJA1110 is not functional at this point, it needs =
a
> > different initialization sequence compared to SJA1105. That will be don=
e
> > by the next patch.
> >=20
> > Cc: Russell King <linux@armlinux.org.uk>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
>=20
> [snip]
>=20
> > +
> > +int sja1110_pcs_mdio_read(struct mii_bus *bus, int phy, int reg)
> > +{
> > +	struct sja1105_mdio_private *mdio_priv =3D bus->priv;
> > +	struct sja1105_private *priv =3D mdio_priv->priv;
> > +	const struct sja1105_regs *regs =3D priv->info->regs;
> > +	int offset, bank;
> > +	u64 addr;
> > +	u32 tmp;
> > +	u16 mmd;
> > +	int rc;
> > +
> > +	if (!(reg & MII_ADDR_C45))
> > +		return -EINVAL;
> > +
> > +	/* This addressing scheme reserves register 0xff for the bank address
> > +	 * register, so that can never be addressed.
> > +	 */
> > +	if (WARN_ON(offset =3D=3D 0xff))
> > +		return -ENODEV;
>=20
> offset is not initialized here, did you mean to do this after it gets
> initialized? And likewise in sja1110_pcs_mdio_write()?

Yikes, you're right, I fiddled around too much with this and I left it
broken, it seems.=
