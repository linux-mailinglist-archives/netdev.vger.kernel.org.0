Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6003C8A4B
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 19:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhGNR7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 13:59:47 -0400
Received: from mail-eopbgr1400130.outbound.protection.outlook.com ([40.107.140.130]:24551
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238430AbhGNR7p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 13:59:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PhTcGqv4dM9ZIHAYYwzfPZUFbAyYsZrno0quYnDfxq6QIS5DNOgFrd76/N9PnYNw7p46T0HWGbSBomfhzicvqjbmc+c1jaoEAhgDciFG3oAj+IAkm/XLK+VfXfJdt8zldYTc/ZVd8H54odKi6xqz2gkDpXyc6ouymsZgW1F0/st8hQLmWsSj0Cc8iBW6vzVbsStIkY21cRf/ob4EcLCLQpHGnGs4mvsZYvHAol8w7/vuCdAivlWxSU0KbAATWEjPD6Fq9fp7oiKdeCnPRPPJIcxO2BamujOsdTshTUIdGwTKqwrpbqzX2PulNKBsUv4lTekkUdftKkWcBp+K3eQEoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hYtQr5BaA3WOSXEhMwU+iqKt5xd9b4cLcm0/LvvRF8=;
 b=l9QRmAzsjE+R2Y3YIchKMfMkZYpV4woeIouad3wvKfU5FTCvD4nXwmAj2T4DLb100exeZyh/1AgzUVSUrubvPRukNk/4aBJCD2GTLk4+blGBqA5AgU0FWYe+4kktuE4/I/hqCFrE8xjeXUNr0jm6YyZslszS4iF0rGc4sQl/tA4zwo/K9QJCC//VxM69hv7iJImCxz67TBeK4MGIDgiobyTj6Fft1JOldnYwVHf1f4pzcrFEII4T6/iZztJxvT0kT2XsprjBQ+ECyK0BeNMDjAQhxiAunJuzXB2xWXn80xBN+SreCHWzOXaM+FJO1qsUrxoiy26wQ4qTC+p2q2MgZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hYtQr5BaA3WOSXEhMwU+iqKt5xd9b4cLcm0/LvvRF8=;
 b=XF5bEsULW3Y+Fv7p1iLjV83oYrnViz/g9cDh5T5TlOv7nqMzycyTHYCWTTlXEcUZCTFCN1dHZRqB7nyR0Oo3aVN1cH3rlxqtQrhgF2OitRMa9AwraTWV5G0q0qGmDAYCcCZpoC+IUGZv0xvB11e6M32XPAqNIlxEsfEjN/LHt7U=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (20.183.20.197) by
 OSZPR01MB6616.jpnprd01.prod.outlook.com (13.101.246.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4331.21; Wed, 14 Jul 2021 17:56:46 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%9]) with mapi id 15.20.4331.021; Wed, 14 Jul 2021
 17:56:46 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH/RFC 2/2] ravb: Add GbEthernet driver support
Thread-Topic: [PATCH/RFC 2/2] ravb: Add GbEthernet driver support
Thread-Index: AQHXeMAjAlRFQ0Sz3UilaOpIkkO4q6tCoagAgAAN46CAAAmLAIAABAYA
Date:   Wed, 14 Jul 2021 17:56:46 +0000
Message-ID: <OS0PR01MB592285AAA88B1BDA84F3C20B86139@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210714145408.4382-1-biju.das.jz@bp.renesas.com>
 <20210714145408.4382-3-biju.das.jz@bp.renesas.com> <YO8KeCg8bQPjI/a5@lunn.ch>
 <OS0PR01MB59225983D7FB35F82213911686139@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <YO8eILdf4orh0ISY@lunn.ch>
In-Reply-To: <YO8eILdf4orh0ISY@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0471814-3083-4b88-a777-08d946f0bf64
x-ms-traffictypediagnostic: OSZPR01MB6616:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSZPR01MB66169A8265CBA13F5CB02B4D86139@OSZPR01MB6616.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /W9sl3Dtmayw0w0hAe16R9QVqkQ5Kf5PpNRb7Ggrm+WKs390dvbdXXiwnJr7BBGratMIZOGnEcN90MApOzLsJU1haHjxCMyy3gyPkwaq5/l+b9Vv6W8qtUNJ8O/viKVKPbYAR2S9hw4L9XLf4KVp6dvzpBIxB3YuSA8+ZO9aYmCxxI6epu04K3CAE2486Q4GdI6oeg4po1lBv5BZjPkUt1qmV5JM1/RGaEEwE4RRAoRO9wnabUEaM1c0q0elHQN+SXnFwb4v1cOZGfsasOaYGDKutBmyq9dJZACVPJ3A7QQSw26cWcy0cl3QA+OwX8PM+4t4qE/B0OPtBWzEK+JSB4EcAqNRMTEoLO0geEKcKqyQ6rvL///UiIbcnE7XiqjLhKZG3v1Zw3hqQ18lBf3gnBkcSvxLOlX/w9o2o/B2FYYs+MHlFTuMo5JHd1rJPErAYbIH1s1BmPy9EXxHW8BeohkIEtPPl3vmyu8IfbJ7driNaf7O4MnHDat8+1R/9rokcFNo0Ej9fc7lMGO4TKmJV4nDH+6hsutOfEbyePy6hEtrDTh+Ydtt1k2XsP32Ct3P1CF7YcF/8zbYxIS9lqwVlCXeJ57PZPFOocmN8Yg6Fo4skkWggbKDDtYC0BSA7iqo3KZhokSGcm18AQKdqd3jZJ9NEIDHnZop3CGr4vmjZ3tGB/fNrTxwAf5pfqoKFa+dwJyI6gzL3Xidfd1+76vc0A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(4636009)(136003)(346002)(396003)(376002)(39850400004)(366004)(76116006)(122000001)(8676002)(6916009)(8936002)(38100700002)(4326008)(54906003)(83380400001)(66446008)(33656002)(7696005)(9686003)(86362001)(2906002)(26005)(186003)(478600001)(66476007)(55016002)(6506007)(66556008)(316002)(64756008)(66946007)(7416002)(5660300002)(107886003)(71200400001)(52536014)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3T/r/tiftqj0opBAasb24vS20nMkMCztiP+33HUJyCIUByICu45aG2uJ99Qx?=
 =?us-ascii?Q?pvHsdj5MLi64syUL1x4xd1PT7ZVlDuHPlm7amwC7UkYZLlsArsrxtVnx+ol0?=
 =?us-ascii?Q?csV9l+97R7ZEu1GDoL/ERUmzA4I8kaNK5c9xkJAM/dF5v2fJ0H1Jnbg/eNes?=
 =?us-ascii?Q?8R7tCP/B97m/qS7gYwjUedSWUs/I/lY+f7KP5f2iF7drXXhYayxDDZAMLO6p?=
 =?us-ascii?Q?XzQNnuvKNlN6HF/Igq4xQ9KwkXbPmCmCltp9qmKj8WRlN5MOjvTRdb9U8Uu2?=
 =?us-ascii?Q?bXnthsDsg2uGZ4PeE90l3nD/e9t0eLB66I3HdLF3bMbmwy/P/Qx3JdICx57e?=
 =?us-ascii?Q?Yev75AfwIEIN69murCtSSzkvXjONTlc26St/bY9pnNEydhQ2V28DBhbqqHWF?=
 =?us-ascii?Q?9q1Acb2zXUO3C8YwQZnbvqVnN8XKzV07Luw/WIn5ZmNvVEqA3G+2BA3y73Tv?=
 =?us-ascii?Q?W6KIHzDqwqVLwvypwcO9EvbI7O6OdbtgG8iZRYkGgfE8nY4A/Riv56PObXCF?=
 =?us-ascii?Q?YF8SK+ktJBgDbrP2Uq0Qysgg4oOoTqrQHkUddxnur7gtm4YBFFcXgso4py6J?=
 =?us-ascii?Q?Y0yhhAtdpvyAwLLQ7TjpiQmZNkF9JjPmdOxAtid7OCIQhGlvJ8tGfghmxJst?=
 =?us-ascii?Q?OJFj3dDodxCIER/7ZRVX0oliGQc0pV2USLXJzem0FDNFg3++2J4hItsysWCg?=
 =?us-ascii?Q?FoTNDuvFPHMQThXn0wk5fS3E05aFY8N3fth3aue/CIYBZa6e3rZjyXHYOn3R?=
 =?us-ascii?Q?Nk8yNN7bz3igkEpV4kUQWCReLVuNvGkdrjSiV8vE6rmThCrzUxr9EOePqPj6?=
 =?us-ascii?Q?IoRhBplzp6D4gtq06g8DWHLoLqCStLDF0w/Mz5lRmZRJuiRlu8RL9wYjM60g?=
 =?us-ascii?Q?HrM92wcOHx1iE2FVGt3oy5ttcQkr7UEiLuMK3HeyrLdALnPaikdN38RtYoHk?=
 =?us-ascii?Q?uq4JJrhLVYQ8B8quPHLrolJ6dfW8fKp8cRpnZRirQp2N7zKzmEEmMxqXPlPS?=
 =?us-ascii?Q?v601b56x9wovW/PxNt7IBADZlBMd5O8uFx7U8nCByjKP22aJbTZBn3smP4BC?=
 =?us-ascii?Q?Wp04oLzKQx3PcOaBXNb1V4c8PTXS51Fcf6+fhfAtqtE+RnL/+idKQj/5ZpL2?=
 =?us-ascii?Q?E+7d5DLL4YnNDmRqvwc99xalcz3B0OFfUGz3ZRtChbwA/E/NaXsR/ymkUMcT?=
 =?us-ascii?Q?F7tNOYgpSwJcVTSt/a9ZCCcz5H+NTFP1O0cUbTmi6HMNm5ZPgEYpKlMCesmP?=
 =?us-ascii?Q?CLTcCA3DaBA91bp78zE4Z1YsNzTMU9ny1o07ohnywk9NkkMyyP8Okuj6F680?=
 =?us-ascii?Q?0KLhcFZgeeHyd2Zbqbq80aUF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0471814-3083-4b88-a777-08d946f0bf64
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2021 17:56:46.5143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sC/m2R9mq1u7JzuFPmvt/0erIEjMYoWSH0sXjMvdjp/J1YrjmFT3xCv4ES2CAjg1+In2NxwM7CTUJL/uYoF6vh+ApLm2AJ2JJlPM5AGmxrQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB6616
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew Lunn,

Thanks for the feedback.

> Subject: Re: [PATCH/RFC 2/2] ravb: Add GbEthernet driver support
>=20
> On Wed, Jul 14, 2021 at 05:01:34PM +0000, Biju Das wrote:
> > Hi Andrew Lunn,
> >
> > Thanks for the feedback.
> >
> > > Subject: Re: [PATCH/RFC 2/2] ravb: Add GbEthernet driver support
> > >
> > > > +	if (priv->phy_interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID) {
> > > > +		ravb_write(ndev, ravb_read(ndev, CXR31)
> > > > +			 | CXR31_SEL_LINK0, CXR31);
> > > > +	} else {
> > > > +		ravb_write(ndev, ravb_read(ndev, CXR31)
> > > > +			 & ~CXR31_SEL_LINK0, CXR31);
> > > > +	}
> > >
> > > You need to be very careful here. What value is passed to the PHY?
> >
> > PHY_INTERFACE_MODE_RGMII is the value passed to PHY.
>=20
> In all four cases? So if DT contains rgmii-txid, or rgmii-rxid, the
> requested delay will not happen in either the MAC or the PHY?

OK, it is my mistake. I specified "rgmii" in DT.=20

Without phy delays (rx and tx) ethernet won't work. Will fix it as "rgmii-i=
d" in dt.

The above register(In-band Status set register) is basically used for selec=
ting the link.

>=20
> In general in Linux, MAC drivers don't add any delays, and request the PH=
Y
> to do it. There are some MAC drivers which do it differently, they add th=
e
> delays, but that is uncommon. So unless you have a good reason not to, i
> would suggest you leave the PHY to do the delays.

OK.=20


Regards,
Biju
