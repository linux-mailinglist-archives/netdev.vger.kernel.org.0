Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A68472F4C
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 15:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbhLMO3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 09:29:13 -0500
Received: from mail-eopbgr140070.outbound.protection.outlook.com ([40.107.14.70]:19926
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239147AbhLMO3L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 09:29:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a5O+oCFC4CfIyFcGH1IMe+BoO4jBiIXQpVpcfcLWzrYc42EWBJ+L8C5+6raxjD6sIOxesigTV7EJ5lipsP0Izoaijb2oUCG70LzfpOAns4FcW2lOBESlLV8gfL8RxDejZYva9c5SP5SOkq9iZhihOgOq4cG1maXPaNZOMXJbz2L7icLphfYDrXm5fHo3IlQwDVSz+sY2/+sb0hhJnhgRSR520Mon/XWABCh3QxnjzVlaDiXopSahxs1HcJ5J8L15RYTSkoC/AnwJAO2TSb4SLOej73awlsa7EuG2IiDipLH9ZlP6cASPIoeinuY5wpDfp2AOtRCkm0sSyVMRUttAmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=smkrO8wHT7DA65aUCr0IV4LcH6FHGckYZw97flywGkw=;
 b=kEUQNHWh2XU+zmQTpoM2eH3VkVNbREjMWuUyD6jVFh5/L3ysiqcxSGT8Xf5qqTP+FoWguUKjGOYmZTEf31+95qxpI/H5rEMRyPcwXh3M2K/H5YYGZW69QrY5haj71wzpa3Cncx9Z7jFO4FiFKItLlAUbd9eHhj2idHPCxLjJ5WMQiPzDJhvYu7IX2r4ud6iatdAf/ugEVBerR/3NZgK1asVVoeokhnEFZKxLRfMYocJNZ8kFq0vomYhaAQoY1TPRii/MrCslhFRqKhec+n1aD1g/gmNTNdVXu+HO7s6XrrNoxp8VQn8kVnknLYb1RHXpHBsFiSrubionkqX8fagxEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=smkrO8wHT7DA65aUCr0IV4LcH6FHGckYZw97flywGkw=;
 b=bxc0dfjaFv4dBGEdaOAkC2od6caFd0yRyHDX4HPHYWwCvtQqAGoWT03PcyeXU/T1vlMosNlU+VYpXZk+7alglofZ08gU442aYlEKKp15xWDHs72wWqBwrS5toghtgqZ2vZ0ULSjnMH1Z87Tpcd9wKTnKGKPS6dMLDjXv+E2xk/Y=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2303.eurprd04.prod.outlook.com (2603:10a6:800:28::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Mon, 13 Dec
 2021 14:29:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.028; Mon, 13 Dec 2021
 14:29:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 6/6] net: lan966x: Add switchdev support
Thread-Topic: [PATCH net-next v3 6/6] net: lan966x: Add switchdev support
Thread-Index: AQHX7OGqma9W7JTLPke3A5iwt0gyh6wqKbcAgAA0OYCABd/MgIAAN0eAgAAMLwCAAACdgA==
Date:   Mon, 13 Dec 2021 14:29:08 +0000
Message-ID: <20211213142907.7s74smjudcecpgik@skbuf>
References: <20211209094615.329379-1-horatiu.vultur@microchip.com>
 <20211209094615.329379-7-horatiu.vultur@microchip.com>
 <20211209133616.2kii2xfz5rioii4o@skbuf>
 <20211209164311.agnofh275znn5t5c@soft-dev3-1.localhost>
 <20211213102529.tzdvekwwngo4zgex@soft-dev3-1.localhost>
 <20211213134319.dp6b3or24pl3p4en@skbuf>
 <20211213142656.tfonhcmmtkelszvf@soft-dev3-1.localhost>
In-Reply-To: <20211213142656.tfonhcmmtkelszvf@soft-dev3-1.localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c77f51cb-f681-4eec-8ede-08d9be44ecb5
x-ms-traffictypediagnostic: VI1PR0401MB2303:EE_
x-microsoft-antispam-prvs: <VI1PR0401MB2303ED6CB8AE51AF33F10D5CE0749@VI1PR0401MB2303.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7fgUz+Qk6piNrTQZ2VhrRZiSZrTuf28v1Jru3cBgJtHdcUcLVflYh1b2IyW1ZwctrkRxybqdvpjD7pY/pm9jl4q0k35FtegW/mO9yB4Z9tAgvpiposj8A2CfCzfDgvgH+Idc6DJrXNPmssfM34uIaAaW7zky+kE7HEOgvqc6FoOcpZLGK5PG5e6OrASHJ0tgKzzHvWnTDpbsVm6UN/meMQddD75oqBDoSk1u4fBo/RrYnI5IglnG3SGOJNIVY9hF2ppHjB2VlYwYJzHuNQCH6QbQivlOACdG0pAsYXuXkMsi4+qH4QUbJw+cSYI0JIdtu9mpny2mKpbYqoZtjYTMWB+06LQW+bzLAp9xxLVJBbwhuRKhHB57UZG9jXcG7lOhsJUt0PUAOWI1JVvOZClZ1CA33vcYDDzjP7LAHmJm1+zTI2zuuFAnYxuIK224FbbPwBMxqjbJqa0EsC2VcFBqmtlz1Q6qcL87JNSpJVi2lrjcuEz6N8Qaj1nbnCgJGSHuQ/wybCR3x0iGovujOY1utBU1ByCx0hGFUpXlF/2ioNUYsJ1J9Jxi4eOJrZ2KkyWvBbuQv/FCewliz9IGwEGIGOEIsAS6RAqOAyKMCIj4huHcXxjlhKi1TZdCEmS6MRMdp7JZC3nFeeVs3lmwlkQn2nGBmzy3gFM3EyIOJ6LJ/g4v09uVRiozWgX7omTaDpz0whXMA8Il5CgrRsFK5drPyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(8936002)(26005)(186003)(6486002)(91956017)(6506007)(4326008)(86362001)(8676002)(7416002)(9686003)(5660300002)(6512007)(33716001)(64756008)(316002)(38070700005)(71200400001)(2906002)(6916009)(66446008)(66476007)(508600001)(54906003)(1076003)(38100700002)(83380400001)(66946007)(44832011)(76116006)(66556008)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1fsw1/tOXA1eVn88X/91oyjOnJNOl7BTSI32N0KohFJZYTii810d6zIj8JKx?=
 =?us-ascii?Q?/HGWLddjCMeJXlrHZ3osF62MG3gC8zjSDFe+2Xx/YFy3x45CbM+gVCZ70JfF?=
 =?us-ascii?Q?BzsZlDaxh0om/cz9DsuI3eLbEQJnBkbx/lHsc0E2XV5vp8PuqbEIwLR+n1Yy?=
 =?us-ascii?Q?fXFQJbCP5/SCX/ZH39cG2f0gvP283YFczLEtT+nox53krmbnsFEeBzoRjazs?=
 =?us-ascii?Q?J3uiW52BCZq/3W3G8vwyaGo8MX9270vjHmZQTsPTGwN3KGbBVxRnJFrXjYco?=
 =?us-ascii?Q?4od6u/+xv7gi5oeB2btniGwQczlJUahRaX5V/fpG1b+ATPlk64162u82ZIWS?=
 =?us-ascii?Q?q527jsns4RlVkYoefdCljkhWgFDUMPbNnW+WoW5hr4BDmnPfxXyti0Px8wE+?=
 =?us-ascii?Q?eMth4CFFLIzgg1gukmyzbbI4eMt5xZvtIPd9eDlZhlY5ncOkvzV0w5q39C+C?=
 =?us-ascii?Q?bwgWjJGu5+Zz1DlR05eo5Ls5qKN5wLf0GJ9SdcTaxWKOAjqD7UYhgWOZ3e1V?=
 =?us-ascii?Q?Klxn5d0FBB5jEfu8RkIDSF7Imzb0Y6wvgEPNxJ+5JrEyRjO0P1y5XSr2qex1?=
 =?us-ascii?Q?sJDI4KL1tYrTJ/EQLKeQKzB162NR0yfHMVk5U25kTNMDHf0ezz6hxRBayWta?=
 =?us-ascii?Q?shqZs4V7008QW6HXT3Lan3/tu9MeySoAx8bGb7Oq3Cp57oqejN52dlYy7J1o?=
 =?us-ascii?Q?xFrck9ibg3uEgtwgnFmePzmX1cxwLXe02bOsi/yvd69EBAfB2qGzKaWTgvLO?=
 =?us-ascii?Q?8r0f4K0IK6XO2NwNxFarojN1MFWkyO1bomq/V51NP7hT3U5kvnq9/HCJMFdj?=
 =?us-ascii?Q?xvqAs95Bl/lBF4agifC8e80doAD4mCNdKbHLMWJGHCa++e81+EtmoXmE13ZD?=
 =?us-ascii?Q?UNf/h0ETyXa3r+d/Xn/1Xa5exI+Qu0oJjhE3xP+HSynSeeoxX/5a9hqgLAUH?=
 =?us-ascii?Q?Iqp+k1jvy+SAbXby8k1xIZdvwvBSo5uI0LsITEV+pw3KqHbfaK/Wre7FZI//?=
 =?us-ascii?Q?WF/WUZlyoYghCrYLG4KUcoM84sSLVPhI3PWdNXO3tPv/9aJH2bWo749YHdMv?=
 =?us-ascii?Q?rrMQ0TvnpM0mF2e2/iU5zDVNNedtCOSD/N+YNpi6Ta6gWGssxo6XjBqQDLm0?=
 =?us-ascii?Q?tRcrsqs8/I1Vfar5ucZfSnHFQO+qnqTVFsuxNgVyLFXiegA7VxgAJZ/vokem?=
 =?us-ascii?Q?abZq9/v/ARmrNhFEn+XyR2Z4LCieJNlQDbgQrLoN8b0YVxz2f2z5nplfq4K8?=
 =?us-ascii?Q?2ZmIHvoJkzdu5Oq0sBpSIZym+w2PI8jv2fUHyGygkM4+ii+ei8LzE+5+wSYt?=
 =?us-ascii?Q?F+O8K0C5Mdp1loFRFi6OcG/D69tj/c/Nps6OGB1qdcMqoxXaiyHBRug0z8Bv?=
 =?us-ascii?Q?FJe1XmULoz77mCRH3wPFjqWqDotrPOmS/jQdWPwLFntaXR3ZvSpkhp/3Tul4?=
 =?us-ascii?Q?sqgD27swkWx2uNntYU9uI3eAcCj8orHwRPMuKFsie/7/+g8b94+pWVSFAex4?=
 =?us-ascii?Q?xfTaK2t8sAPqkt0CRWhFVesFQf2BN6iw6nTB9qeaGNySk6pgXM3cTo+SviIB?=
 =?us-ascii?Q?z60r5lEzWmuHOTAEhIHSqaTqsXfvMwITbzJyaE28Mateyu4Zi9KzFC4rANHo?=
 =?us-ascii?Q?wdLew4h2SRzjkSSINg4SJ+U=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <855A3A3AA8C5B944B92C8C0B3D4202B8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c77f51cb-f681-4eec-8ede-08d9be44ecb5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 14:29:08.6604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r8zNiZCn9AtHDMZXV3+lgU08ipPzeVG9jS688N+6JiTMKiyfIGRzkLDwbNJoh48U3179PHIF4amcnoi9QQwZOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2303
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 03:26:56PM +0100, Horatiu Vultur wrote:
> > They are independent of each other. You deduce the interface on which
> > the notifier was emitted using switchdev_notifier_info_to_dev() and act
> > upon it, if lan966x_netdevice_check() is true. The notifier handling
> > code itself is stateless, all the state is per port / per switch.
> > If you register one notifier handler per switch, lan966x_netdevice_chec=
k()
> > would return true for each notifier handler instance, and you would
> > handle each event twice, would you not?
>=20
> That is correct, I will get the event twice which is a problem in the
> lan966x. The function lan966x_netdevice_check should be per instance, in
> this way each instance can filter the events.
> The reason why I am putting the notifier_block inside lan966x is to be
> able to get to the instance of lan966x even if I get a event that is not
> for lan966x port.

That isn't a problem, every netdevice notifier still sees all events.
DSA intercepts a lot of events which aren't directly emitted for its own
interfaces. You don't gain much by having one more, if anything.

> > notifier handlers should be registered as singletons, like other driver=
s
> > do.
>=20
> It looks like not all the other driver register them as singletone. For
> example: prestera, mlx5, sparx5. (I just have done a git grep for
> register_switchdev_notifier, I have not looked in details at the
> implementation).

Not all driver writers may have realized that it is an issue that needs
to be thought of.=
