Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD3F193BEF
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 10:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgCZJe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 05:34:57 -0400
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:17646
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726540AbgCZJe4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 05:34:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NicxeHN+5qZNUhYPI95PqPPiSrq5RlgRmZk/CMMMipwgTgGUGaNY1GcePpkwnV18pUIf8oiPZ5vfLpkzACxF1uHCesBMSl1X6oZCss9uV8JhZt2n2+nSxkmL7c9vjjYhzbVRSk+O/+3WaZ4wICvzPc5crfPvCnd368dKRSjbZvOHb3AIdH8Qc+ksCQT/IdOiR4SVUnI7az72cWH39IHT/hBVw1lmM561yW+mR1k9B/URzM1OlzNd9GCJyw7V2bQDlc59DvxtO9+iQJHM4t9IZ23qQgh/XRyN6H3xOejlHhjv6HPU+W/5ZS24PvbnO8RQx7tkyWs8WTASSH/UmxXWIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UfxNIHVLEMtGyqDrFQ5WExruhP6s3/KlC/1nf4TjxhA=;
 b=K/L1+hDejXXQu7sPdy7ktCUE4cem9cbJo5957n005zCgink6aLbIDpe7zyheVPtI2UfXiIkthDsN6nfLjX9DBv/js9OIu73Ty3MULPysurW5IZMkBBIcFy8vbS4sfjkxj9Fsxmj/FOD9Z3aCA/E3hcYdn+jmOHWw3tpnxD3DWAn2t07/hcbsoclH/NlvIUNrqu1uOrDAbDAI+NNagZoEofXv4WBMZJ2ynNCJBQ1prfliCBQwmJK1f4YVvqUU3WxRN/m8JfukKJQVJSTUA6ESEOsYhJgY+HxSedUfUgrWlyNHfzZ8MwZJVztEYGre8yWXzv0uRQHAdn1ttBOW4duDNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UfxNIHVLEMtGyqDrFQ5WExruhP6s3/KlC/1nf4TjxhA=;
 b=j6BSIz+mbhAxWBvI7FWiEKwbTzRBkbHBoNmQpE0Wkq/cwaVjvQKasjzHwuBK2Y6SRoMyO4baD077V8j2R3XBx/kY3PPDaJ74O69+TTkCJCELHcw4HaCQp+vQY/HWBhpFTGURUKqCGhjxWBz3ItZ8K6wAcnebilhbu/s0QOVErUY=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (10.141.174.88) by
 AM7PR04MB7080.eurprd04.prod.outlook.com (52.135.58.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.19; Thu, 26 Mar 2020 09:34:53 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94%2]) with mapi id 15.20.2856.019; Thu, 26 Mar 2020
 09:34:53 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
Thread-Topic: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
Thread-Index: AQHV/qQWBIiKj5A/T0WD8BjMeGVxRqhXvRSAgADnAvCAALTjgIABSqMQ
Date:   Thu, 26 Mar 2020 09:34:52 +0000
Message-ID: <AM7PR04MB68853749A1196B30C917A232F8CF0@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200320103726.32559-1-yangbo.lu@nxp.com>
 <20200320103726.32559-7-yangbo.lu@nxp.com> <20200324130733.GA18149@localhost>
 <AM7PR04MB688500546D0FC4A64F0DA19DF8CE0@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <20200325134147.GB32284@localhost>
In-Reply-To: <20200325134147.GB32284@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0f903f43-6b07-4c06-472c-08d7d168f007
x-ms-traffictypediagnostic: AM7PR04MB7080:|AM7PR04MB7080:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB7080DFE6DE3ECBDD177D0D3EF8CF0@AM7PR04MB7080.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1388;
x-forefront-prvs: 0354B4BED2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(366004)(376002)(396003)(86362001)(7696005)(4326008)(5660300002)(2906002)(55016002)(6916009)(33656002)(52536014)(6506007)(9686003)(53546011)(76116006)(66946007)(316002)(54906003)(26005)(186003)(66556008)(66476007)(66446008)(64756008)(8936002)(478600001)(81156014)(8676002)(81166006)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM7PR04MB7080;H:AM7PR04MB6885.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s3ywO7V+li3Cj1tIhojGN6GKpe4EfIUvz68AaHSpUYzgjCKsJqVlu5JJKWwPt3Ne7wiQJ8XsDgJu5aCizmwqbKOOxpxOQc6vL0kVvAKrN54Zf82Aa5ZH2z+rqnWMRcuV3XLZ2Oy7J4axyfLWx9xyr50oXuHmE6C+2lrezzlBRLQYwHlmqfj2GuQd5kyziQHICSR9+VOxnxDLoseEORdjFq/VZ0YsQxpEgiVuv9LZg0XXP8mRt3OpuqNV5SrJltyfLvIwjH8S+BtYL7udV0u/+7msVKN55uo5ANcPtnp0xKDmzu4xz0DiV6hd8IwyNlcq6cSx8Wbf7vf3pJdPSsNMEwveToqmYgjR4voG27G6wL9cu3CD7W6hR+VsxLJhhnjx4XHIWF9Q58/YLGnF53LoSAt4JZL+zajyXCN4N3A+dsRdt+cLLjrdMZy0AE1Ua5+R
x-ms-exchange-antispam-messagedata: 89RjFlzbDZH7abbyKdQFW6r/B9PSLxWdI7SH2Lv4lokG7xSEXegu8YGsB46x4PyOyrvd8TrL4EEV+HWk1y3ws61tzeiy8OTNYb2sBr5xw4/MToT6xK1ZxhTTUcj1tii42x7NeHKMubM2HNDna9ks1Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f903f43-6b07-4c06-472c-08d7d168f007
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2020 09:34:52.8952
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wQULQH6Ae/O2dU4ZRojuuFi4VV8U9OCN3ILoM+TxCtHti7HDY0hLlc/3e6gpdi1Ewjnx8g+4t3ncxZhgkKSiNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7080
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Wednesday, March 25, 2020 9:42 PM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: linux-kernel@vger.kernel.org; netdev@vger.kernel.org; David S . Mille=
r
> <davem@davemloft.net>; Vladimir Oltean <vladimir.oltean@nxp.com>;
> Claudiu Manoil <claudiu.manoil@nxp.com>; Andrew Lunn <andrew@lunn.ch>;
> Vivien Didelot <vivien.didelot@gmail.com>; Florian Fainelli
> <f.fainelli@gmail.com>; Alexandre Belloni <alexandre.belloni@bootlin.com>=
;
> Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> Subject: Re: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
>=20
> On Wed, Mar 25, 2020 at 03:08:46AM +0000, Y.b. Lu wrote:
>=20
> > The calling should be like this,
> > ptp_set_pinfunc (hold pincfg_mux)
> > ---> ptp_disable_pinfunc
> >    ---> .enable
> >       ---> ptp_find_pin (hold pincfg_mux)
>=20
> I see.  The call
>=20
>     ptp_disable_pinfunc() --> .enable()
>=20
> is really
>=20
>     ptp_disable_pinfunc() --> .enable(on=3D0)
>=20
> or disable.
>=20
> All of the other drivers (except mv88e6xxx which has a bug) avoid the
> deadlock by only calling ptp_find_pin() when invoked by .enable(on=3D1);
>=20
> Of course, that is horrible, and I am going to find a way to fix it.

Thanks a lot.
Do you think it is ok to move protection into ptp_set_pinfunc() to protect =
just pin_config accessing?
ptp_disable_pinfunc() not touching pin_config could be out of protection.
But it seems indeed total ptp_set_pinfunc() should be under protection...

>=20
> For now, maybe you can drop the "programmable pins" feature for your
> driver?  After all, the pins are not programmable.

I still want to confirm, did you mean the deadlock issue? Or you thought th=
e pin supports only PTP_PF_PEROUT in hardware?
I could modify commit messages to indicate the pin supports both PTP_PF_PER=
OUT and PTP_PF_EXTTS, and PTP_PF_EXTTS support will be added in the future.
Thanks a lot.

>=20
> Thanks,
> Richard
