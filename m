Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76A3390211
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 15:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhEYNW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 09:22:58 -0400
Received: from mail-eopbgr30080.outbound.protection.outlook.com ([40.107.3.80]:17179
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233212AbhEYNWu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 09:22:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aEjZeKIZaSYvclvcMHP9eJ8Gzk9yxHpHVeRFUAcX/Mxitox0bFUd0HRq+ClCL7PM9XgXNlI6pzZUBXim211mzpLoQ9daXoK++nURuc+JS1I1jP4HyMPlgxVuqYClxZpLnJvoeUfHkuk8LqyZ8Xze//jxYl1q4NWXt1okFl1ktxdVz6xjMSvwEy+HC12wt6hHrDxNiJILwb+dIxXjhu3rsOWdiFM2GaayoS+NzqGYCehRRZ2gVjnW7mcfXv/c5N2qzNZF+yjsmzIM+VsXPXUpfed+czxE5LvOGAIEQQBwzXIWHgyz6omH6ywYLUwujjV+y/AYg6Fgjx95f8VqOm1J+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r0HvzM7XEAYyj6JZmqhWZkF8SB+DDbfDWTo4+jlLjfI=;
 b=bmi/ese51ixWn8pFKbpch2x0WUKULELKUXv/2oboHnsLeYnu0mfGpJlPrpA0zjwZI62okRKrFv/JHt+r27z+ApUWksBpo1qaoXVb8UjaXdsUPNDV5vgqDkKmsqBHfk3+fgwXGNBkkUGrgrTb/xy7z0+jUjj0miwpLB2uzwyKAG/tGK3YItab7q7a4tOhTnAVXsa2sVlExPUPtdtRsS596b0HXIizXwtJXVCJj0FVNrN8mlDqv2AVY0ORIJFyIthv45IDC1Bl63imDWgPwUgqeAa646IunX9IE4wL7uPQznSG9YSv9CezdXfbPB5d/j4xlDqrpoG3F/A7ubmJmI3/nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r0HvzM7XEAYyj6JZmqhWZkF8SB+DDbfDWTo4+jlLjfI=;
 b=ePIDLHXa66CT3SQjNGAlJ1vDHuZPoQqSvo4l7q7iXilRKn22SYhYEXqgVHfbrILn4Y44eHXOX8lgdiJ4c3flfuZCh6KX0G51mYZ2jqhdtbMRUC7/dZEjlOivHn21zn0wto/cGgWAX92amcqexZPHxXCt4LBHn5U/mFy7nQ9w7cg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5693.eurprd04.prod.outlook.com (2603:10a6:803:e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Tue, 25 May
 2021 13:21:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 13:21:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 11/13] net: dsa: sja1105: register the MDIO buses
 for 100base-T1 and 100base-TX
Thread-Topic: [PATCH net-next 11/13] net: dsa: sja1105: register the MDIO
 buses for 100base-T1 and 100base-TX
Thread-Index: AQHXUPOx4aLMBMHr9UOu/+AIQB4kIarzdpMAgACg9ICAABcFAIAAATyA
Date:   Tue, 25 May 2021 13:21:17 +0000
Message-ID: <20210525132117.gvjr4zcmpnhcwxyc@skbuf>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-12-olteanv@gmail.com> <YKxecB8aDJ4m5x7R@lunn.ch>
 <20210525115429.6bj4pvmudur3ixyy@skbuf> <YKz4xA3QNIoEv5pp@lunn.ch>
In-Reply-To: <YKz4xA3QNIoEv5pp@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.52.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be5c0a8d-6705-418a-8fc9-08d91f7ffabf
x-ms-traffictypediagnostic: VI1PR04MB5693:
x-microsoft-antispam-prvs: <VI1PR04MB569356FAE1B36AB8A000331BE0259@VI1PR04MB5693.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 468dBfc0t6vyEq8imE3CJjjqHuND+k6wEWo4dJKKFdKq7L6UF/ZasMu23mxSXrTkZeoMTmPOdIsxO1udjfXTsYJ9YI25dVUtsMIC4jFVIz2yUvV5quecuWD0hSupGdtv1/Z57aZai7DxhRgQHGCs3O3RW+XqUnMVjM0VSWIP0bjSo/gMrKu8ZuqkZSYdOASrIP/gWaYNnp3x9xnWbkcl1KyNdGgxMu76Mp9oisr3ht5TErgprLthDvpXnjUXU17/Zs8ALSM3AvGiiIp+HeiYiaSc5tTZ9fAYtQlvVjbMNoIGzVIo2ZW+smGhSVTALeKK9dT+/RaWdtPg7Pu1GW7DvK/VY+KCsws9Nj4mXYkwaOOYL9rfcErC5Tnyn8fY5/y5XM46mcI/pHZAXySxhs+1D/ucjM1wjtJ/uxILLTHOAMa1JJyFRwlD8motDtj4weEycJbJP3AjIIfq0a64pYNL9kbruLnOw49RGIMPGT+zipHUNol88EJU9SAtkrsnvwWyKJSgU563MqbI1f2zeZwkA8xUZflaBc/9sbTX08VUL59tvCg+T790qP/HbIsqiJkUsTMKO0/VHlzb0EyGpPGuA8x4zQ/aHgyJrM1yU/BYHig=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(5660300002)(71200400001)(33716001)(38100700002)(83380400001)(6486002)(122000001)(498600001)(1076003)(86362001)(186003)(2906002)(54906003)(8676002)(6512007)(9686003)(44832011)(6916009)(66556008)(66446008)(66946007)(6506007)(76116006)(4326008)(66476007)(64756008)(8936002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Jdh2lOzy0CiKBe4Bw9XVSvuojDaS8Yzy/ARL8p9gXbPOHtxrxIrZxWm7GWde?=
 =?us-ascii?Q?d/EAIAMl5RK+O/aaYPVaQdap7gwc7wjJoV6LEk4TbLYtpmePYuvTx3pxdAHV?=
 =?us-ascii?Q?p6w7R2UVp6L4zC7MrsBUkmbcd2VmY8b9qI4XaiR7XwceSduHr7HJSY2gjksY?=
 =?us-ascii?Q?stHEnTTypENV36rHl08Sgj508KAK5bcPXA8VYeCdoAPkEyvikqHMCnEalWvZ?=
 =?us-ascii?Q?vgaCH2al6jcA5JoX/jnxGFnI0cLUj/XLsWUW7b8JlbMboP/UWZ4hY9gPwAuh?=
 =?us-ascii?Q?CPfNPi+MlQszPHNcrnJI47i5uIN3yXVdyl7ECZK2dt4Aq7bgpNmg4X3mNpEQ?=
 =?us-ascii?Q?/F4wLBWQISPHArLCx87e1UZ4WxSPLNPuHXA1jELNLUXVeYOBHWKY2/BKPr3t?=
 =?us-ascii?Q?Tun3cCyLUDH1rDCuW8bLj+F3yAWBSu1qJ7tMJ3tQy0R/Z5OUeCeHKhAu5+84?=
 =?us-ascii?Q?aBNCzs1P7I6pn9378cX+xXXELJNAeXpXtiWFqfHnoHAGJrOwYt2T8WWF19uw?=
 =?us-ascii?Q?jrznL7yKZNCFAQ6/YLYvADgfBVE2g5/ANP0thhT2hAnnLTFXYt4sy4KLAmNR?=
 =?us-ascii?Q?12cUIbc4bBbRsFOayzvtAnj92f0utHmEXHyaH0iNvHPtJycEekuLJ8JLDq0m?=
 =?us-ascii?Q?IzZCdf06brmD+5t64MYaPmhC+dVuDdaT2z7DNBm43qo7j2dtbMNx7B33B/al?=
 =?us-ascii?Q?T9HVQxMHYGNjlbWAAfeEjlhMXTQmLWwaPvJUP2QarE1/3DV4JM1yZ/bqnZu0?=
 =?us-ascii?Q?T0PQSs9H2UN7KIexBoSGoTfjqGVCFSzjqnXp3tE7XVnC4gLCG/vJ4xETrPML?=
 =?us-ascii?Q?1ViSpdkaeuv3nEI2QBibg4ojFEi3qMP7ANhTV3U+rk8yXh2I8lRh/Qdh2Gt8?=
 =?us-ascii?Q?nXG8P1UKGZVNfCdLnLsUD4VXN4psT/ywMA9E4KQjv+lpfHtc/HOspiKBubLu?=
 =?us-ascii?Q?ToztvURP+6A4Gz2MoNWeYuZZMTJk+Z6i17AGZZs/dRGrilqkqKsCcdJHe8pn?=
 =?us-ascii?Q?1JTUzb/0emB/Yg9NQSQ4Bd9oygT5j67HXdtFj82molIWZ62JfTOQ2cyuucRn?=
 =?us-ascii?Q?3Fv1IHCfhfcLzjTYNTviHJ0SB0tSlbBhD6XYtT2LhM9830fxt2suCMNVWdU2?=
 =?us-ascii?Q?Ofj95qaZiTjo7OPOyzVy+bRzia9o97sSCuWYwdRjA+Ufd11mIdnNVMKCtIjb?=
 =?us-ascii?Q?pA3wDEPS2lvIXWtYENqGM1L5CarKJO/mxJDZXU7yPbt3nwj4CYgNpUWjG/c1?=
 =?us-ascii?Q?Ouud+Wj6S82WiLyQ63XDZgsZ/khn44udkrAzCKwtCnq52MwHmNLffmlKyXcZ?=
 =?us-ascii?Q?SPc4ODzf2EHgj3AbD2orIIvG?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3E84E8C76C255844BC0AFBEC70C80823@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be5c0a8d-6705-418a-8fc9-08d91f7ffabf
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2021 13:21:17.7132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wMkL7syI1cX6FrK/H7D8GBYp2lcmt2R60LZlmfIs/MgUoNbHxqCp+7OrSnB4LKkbZhlHWpom5iut/2mlgeSboQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 03:16:52PM +0200, Andrew Lunn wrote:
> > > It however sounds like you have the two busses one level deeper?
> > >=20
> > > It would be good if you document this as part of the binding.
> >=20
> > Yes, it looks like this:
> >=20
> > 	ethernet-switch@2 {
> > 		compatible =3D "nxp,sja1110a";
> >=20
> > 		ethernet-ports {
> > 			...
> > 		};
> >=20
> > 		mdio {
> > 			#address-cells =3D <1>;
> > 			#size-cells =3D <0>;
> >=20
> > 			mdio@0 {
> > 				reg =3D <0>;
> > 				compatible =3D "nxp,sja1110-base-t1-mdio";
> > 				#address-cells =3D <1>;
> > 				#size-cells =3D <0>;
> >=20
> > 				sw2_port5_base_t1_phy: ethernet-phy@1 {
> > 					compatible =3D "ethernet-phy-ieee802.3-c45";
> > 					reg =3D <0x1>;
> > 				};
> >=20
> > 				...
> > 			};
> >=20
>=20
> We should run this by Rob.
>=20
> That is probably not the intention of
> Documentation/devicetree/bindings/net/mdio.yaml, it works because of
> additionalProperties: true
>=20
> What meaning does reg have, in mdio@0?

None apart from "not the other MDIO bus".
I haven't run this through the DT validator yet, I am doing that right
now and will copy Rob to the next patch series.
Just to be clear, what is your suggestion for this? I am not a great fan
of 2 internal MDIO buses, but as mentioned, the PHY access procedure is
different for the 100base-TX and the 100base-T1 PHYs.=
