Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11EFE1BA3B9
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 14:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgD0Mkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 08:40:42 -0400
Received: from mail-eopbgr40044.outbound.protection.outlook.com ([40.107.4.44]:35759
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726721AbgD0Mkl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 08:40:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+FinykHzVnUz7zk2xAT+wFuvxD3/SXBnty1ka3Glifab+rucT+yf9gTGHJFDzlPGYNeK12jmjiwcy+XdV9+kG4iXqsy6fzRsnvplWTrM+9Ujp+2uX3vM5zzaAiTeTWSiYH3sZznvlB6pcOPfZOIQDOeZV6opKNvgxuEFImR1yC5XfMvE9khQM2AoVXVMoFESHEtrlVFPdM1WhyrwbRVuhkB44lF9NtmmQgKqmh/blYyFyTn8FMDu4J49d6S7xUY5Mi6OmyNpnaw05Cd0oR1rolomNNM+nW3OAwgBa1fX+u/U8pRaV0tG2oLv3SqVZKsCdAZWZS2D6YFFBmlN08Suw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/jCdYPyeKMHiy6duiNLFZ4VRpajMIPJ5FCERAtoLnCo=;
 b=j20RcT+ug1wx3APLQoUyvq5qF+j1bhvEO6qF5N2t6dvknKFn7MzPmjzDWmrqaAZiJxgTVzvVVwN0KxgOWkMDFeEwvt0tLNboTC4uoR9+3RuLCMUc7aZ8eXpTAgU4PJ0IzeKi74p8SpcpyLvuub/1dcyXu49qBIKpX5x/i4vcZ5FjiNtCFW2CsSEjsTHY6o8tAVnTfmBsNdbZDJjstoGsBxLHx7Kb+WnWrM2N22Hto4ktKfZNYX6jeGzfrEUpCdFq4el3qX+DIED97UMxwg8xelmY/QAvXMHz6gLMKk0nYd0y0AVWrvITI6wI96cBsq/GGPiUxWCaHJK6qK/JBvLHUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/jCdYPyeKMHiy6duiNLFZ4VRpajMIPJ5FCERAtoLnCo=;
 b=phJH+qaV9IFFc3F7eF+A9e054MrPpDX1IjhymU57hg6YS5avWCs/93ASCWNDDoEszgHZFECuIUMxc5JuALCv7Wd4CAeNHEs21MnM2kNqldzxeqT07qGx8uFdwNt7eW0m4OQUm6+YA0Abf99NZ9C7IX+edskMVhaW8V35CKJ+kls=
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB7027.eurprd04.prod.outlook.com (2603:10a6:208:191::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 12:40:37 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860%2]) with mapi id 15.20.2937.020; Mon, 27 Apr 2020
 12:40:37 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: RE: Re: [PATCH net-next v2 6/9] net: phy: add backplane kr driver
 support
Thread-Topic: Re: [PATCH net-next v2 6/9] net: phy: add backplane kr driver
 support
Thread-Index: AdYchlLdOcGMcLhKS+m3uu2Z+Q+2Zw==
Date:   Mon, 27 Apr 2020 12:40:37 +0000
Message-ID: <AM0PR04MB54432C98E0CD7FF5B155F446FBAF0@AM0PR04MB5443.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
x-originating-ip: [89.136.167.85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6ebcaccd-c0c3-4b14-9c7d-08d7eaa83023
x-ms-traffictypediagnostic: AM0PR04MB7027:|AM0PR04MB7027:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB702709101D9B98364597C509FBAF0@AM0PR04MB7027.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0386B406AA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(66446008)(76116006)(81156014)(5660300002)(7416002)(6916009)(9686003)(478600001)(54906003)(71200400001)(66556008)(66946007)(64756008)(55016002)(66476007)(186003)(33656002)(26005)(6506007)(86362001)(316002)(7696005)(44832011)(4326008)(8936002)(52536014)(2906002)(8676002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VgF415qD2bu5QdlkoezBj/h7qKiK6/zCw+ozGX0PSEL8GeFRxmz/YVPZ5DR5KS85WVpT7488HGve8ACg9/Apsu1L4m0iRS6vWnmRD4nB850HDQiQYlYW5Lw7poI8/pExlA0/a/FhFn6yZj0sdLrJ9mW13H9YUbaf1c2qobAt0JAyU48palCBhza4jbnKKHZlLG03OkSI0deGFPFXfp1495x0GCEPnwcvY0B+zxxcLOyz/I0AbStP9Ep9mFRLXr/YEwbEht/O3iG2QxfDtcjQWnx32oN5qmORLc3S09TkfAxir9f5Oa3Oc6Wjw+Lr7ENfw5Lrs+ynU+nPca1FCqLC/OIRaCsg8aboVd5groGkftHbuaEIuVzEqRXbxRor5b4G6cI80vqCHxQwlNPO0jMPG6MA5X+th548Ow8d9PfNyOPm2inGOIRGYRvgqTEIKJHK
x-ms-exchange-antispam-messagedata: i6j2Ja8hZHJvQrjrSGMZv++ZUqJkvGFySDSVQOgryDH77i1NA5w3p6R+934UvcYztoHvQy9wZb5q7pOQOTxEZ8mq3ExL8+1jkzrKX9T8GogTlgHsq5BQPiWMVYz7nsfZQfu4xiIRpJ8hWW2/fmaAB5sMv6aFuARVRLWluX+Fn48+2jij150uvkYfxKnfWdltoWCAJ1FqpRU9SCixgtZS85Yj9WHWf3wLEj0bnMGa16T8yAVOEzX/4Oz9eF2aw0k3V/9aTTftvtvmeJfsrNIzzDAQ8iLBJt59F67g7v865f3jBpTQDE7FF+jM2g7fSSHRtQ7PJkAyg5/3ht1WrckTBW5YC8jAzFPpJlRnyY5stuUxb9ffgNp55yowO2m9+c67uRj7AKtN/rNU+lUKycbSvNI4nRtp+8JAKb7rMC7R4775R/ot/0qJ4Q/x2bswB2Orx18/hKoXKH7RXBdGx2oIeB3ZP7SHqK9fQtHgqijAfPYa7vX3dtsR6mXndVMp8dKye2deYWEG6WuMDP1J0KE+FSQS6PWMTVlfsrV2gNMMRVkVjF4HVTHbcc/BAYkE6WRUdm8qHMiRqeJSi/P3xU81UcIhmwlpM8GWGUq/hy8Yi6olG6Wvv5jWIUtSxj7aveNt657MCMY6GG0Aw681HJFy2J3L+EzKzyq7EL6XtBA+hFF4bdEQxHulU10NgNtkMzqGzxe0UZf3Hv8Gpig2RRxH93j4s2PvG4CihbtH0MGJQrRYB2vqWb4Bz9ucydzBrtkynRFoi7OFza4qBRzVBsx7H2ein4Zp9EXJUD9VNeY5CtU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ebcaccd-c0c3-4b14-9c7d-08d7eaa83023
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2020 12:40:37.7710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +zgwpDVkCj1kKlfABq50fvhlSZDXytNOBJAkC9eUZviYcodjumIYpd1rd38js+FtfKZGV7r1rFVf8p4VQrDFZ2XIxTqdWywoUm9KC90c2sU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7027
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +/* Backplane mutex between all KR PHY threads */ static struct mutex
> > +backplane_lock;
>=20
>=20
> > +/* Read AN Link Status */
> > +static int is_an_link_up(struct phy_device *phydev) {
> > +     struct backplane_device *bpdev =3D phydev->priv;
> > +     int ret, val =3D 0;
> > +
> > +     mutex_lock(&bpdev->bpphy_lock);
>=20
> Last time i asked the question about how this mutex and the phy mutex int=
eract.
> I don't remember seeing an answer.
>=20
>           Andrew

Hi Andrew,
Yes, your question was:
<<How does this mutex interact with phydev->lock? It appears both are tryin=
g to do the same thing, serialise access to the PHY hardware.>>
The answer is: yes, you are right, they both are protecting the critical se=
ction related to accessing the PHY hardware for a particular PHY.
As you can see the backplane device (bpdev) has associated one phy_device (=
phydev) so  bpdev->bpphy_lock and phydev->lock are equivalent.
Normally your assumption is correct: backplane driver should use the same p=
hydev->lock but there is the following problem:
Backplane driver needs to protect all accesses to a PHY hardware including =
the ones coming from backplane scheduled workqueues for all lanes within a =
PHY.
But phydev->lock is already acquired for a phy_device (from phy.c) before e=
ach phy_driver callback is called (e.g.: config_aneg, suspend, ...)
So if I would use phydev->lock instead of bpdev->bpphy_lock then this would=
 result in a deadlock when it is called from phy_driver callbacks.
However a possible solution would be to remove all these locks using bpphy_=
lock and use instead only one phydev->lock in backplane kr state machine: (=
bp_kr_state_machine).
But this solution will result in poorer performance, the training total dur=
ation will increase because only one single lane can enter the training pro=
cedure at a time therefore it would be possible for multi-lane phy training=
 to ultimately fail because training is not finished in under 500ms. So I w=
anted to avoid this loss of training performance.
Yet another possible solution would be to keep the locks where they are, at=
 the lowest level exactly at phy_read/write_mmd calls, in order to allow la=
nes training running in parallel, but use instead the phydev->lock as would=
 be normal to be and according to your suggestion.
But in this case I must avoid the deadlock I mentioned above by differentia=
ting between the calls coming from phy_driver callbacks where the phydev->l=
ock is already acquired for this phy_device by the phy framework so the mut=
ex should be skipped in this case and the calls coming from anywhere else (=
for example from backplane kr state machine) when the phydev->lock was not =
already acquired for this phy_device and the mutex must be used.
If you agree with this latest solution then I can implement it in next vers=
ion by using a flag in backplane_device called: 'phy_mutex_already_acquired=
' or 'skip_phy_mutex' which must be set in all backplane phy_driver callbac=
ks and will be used to skip the locks on phydev->lock used at phy_read/writ=
e_mmd calls in these cases.

I'm sorry I have not answered this question the first time when you asked i=
t.
Florin.
