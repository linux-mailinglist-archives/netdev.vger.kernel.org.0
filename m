Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9532A64E8
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbgKDNON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:14:13 -0500
Received: from mail2.eaton.com ([192.104.67.3]:10400 "EHLO
        simtcimsva04.etn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgKDNOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:14:12 -0500
Received: from simtcimsva04.etn.com (simtcimsva04.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 311F48C0EE;
        Wed,  4 Nov 2020 08:14:11 -0500 (EST)
Received: from simtcimsva04.etn.com (simtcimsva04.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 230AA8C0ED;
        Wed,  4 Nov 2020 08:14:11 -0500 (EST)
Received: from LOUTCSGWY04.napa.ad.etn.com (loutcsgwy04.napa.ad.etn.com [151.110.126.21])
        by simtcimsva04.etn.com (Postfix) with ESMTPS;
        Wed,  4 Nov 2020 08:14:11 -0500 (EST)
Received: from USLTCSHYB01.napa.ad.etn.com (151.110.40.71) by
 LOUTCSGWY04.napa.ad.etn.com (151.110.126.21) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Wed, 4 Nov 2020 08:14:10 -0500
Received: from USLTCSEXHET01.NAPA.AD.ETN.COM (151.110.240.151) by
 USLTCSHYB01.napa.ad.etn.com (151.110.40.71) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Wed, 4 Nov 2020 08:14:10 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by hybridmail.eaton.com (151.110.240.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Wed, 4 Nov 2020 08:13:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gw1Obkg/dcvbU7xthy5dKEjpZHeKvmO9/SyxLy0OTQ8fiGZYgiHm0X7S23gytQOJAsBGbKyeTt6vwqhpq1lp4/4A4n/rQB2OgUh92JOKfyqXvvKFN4xNrB+tkpawnF9rjI+hj0b84L6peKpxHqJpNjSkmsZzMgVXjiRhgRIdF771xUiNqYGZ9dPTcUQ4oblwH3A/fjjGYxQe5qiqyK2lBZpvbys7zPAV6k/yUGdNH5WQ17hllXnTAy97haucLYgv24iy/OISouz2zpsn7kdtrL/XyI9/QeeYVrd9a7aA3DUULUDBfgabOMXuCedIY+MVLa6CfG2sdfsMZ1DZJZC8ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KvJQC+jNe22ek97mWaZfOY1Uu0UIy9K1eoxN3H6ur0M=;
 b=huhqMz0L1fOUKDRSf9e4FIMeLgjZ8LX45jAFdAhXbaMXyhBRoQiJGRWavTTedGCkisq8WOfCZbtcc2/zZPFrlFz/JbQqycREYx3QGFEeF81y9qrZZKEOwPLYoN+yCu1PpfVDr6PhDCPFMiJUagXHUhTD8WZmHo+cM+hp3jENscjImh/sA5sFwlqseu8/Ojf5XjZWLlXpXh6d29Cu6PXA786FvU8Mq0QCIYQHzr+8Vn0+B1uxoxo3DDgzxu82cWq/2vEEhSeGXGlyiuWGQe6lH+MY0e+AzJTrbHVUTTx6EJhcmS9k82lonwtfjWKZHbwxR1D/X6jDCeAJBA3xF8lgPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KvJQC+jNe22ek97mWaZfOY1Uu0UIy9K1eoxN3H6ur0M=;
 b=koJ1Tsxib2l2Tc0MXMdX2VG16IhIEqwH+x4V3yLi+8iuZ4pXQufMUAc0Ii6YgAiHcXz525isV0DFvVRb2I7+mBTEDARKHuUNFT1EI2V1Je9PQDRVBoEZRoRsg9RtyT178eq7jmmcm/oELqjq1Y6ROfoqzCtml5qIF6zX0GedCj0=
Received: from CY4PR1701MB1878.namprd17.prod.outlook.com
 (2603:10b6:910:6d::13) by CY4PR1701MB1719.namprd17.prod.outlook.com
 (2603:10b6:910:69::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Wed, 4 Nov
 2020 13:14:07 +0000
Received: from CY4PR1701MB1878.namprd17.prod.outlook.com
 ([fe80::a5a5:a48b:7577:6b45]) by CY4PR1701MB1878.namprd17.prod.outlook.com
 ([fe80::a5a5:a48b:7577:6b45%6]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 13:14:06 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Marco Felsch <m.felsch@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "Quette, Arnaud" <ArnaudQuette@Eaton.com>
Subject: RE: [EXTERNAL]  Re: [PATCH net 0/4] Restore and fix PHY reset for
 SMSC LAN8720
Thread-Topic: [EXTERNAL]  Re: [PATCH net 0/4] Restore and fix PHY reset for
 SMSC LAN8720
Thread-Index: AdasuCyaTCUfPNScQDqUis8Tkf1v8ABE58AAATXQQVAAAjmYAAAACv0Q
Date:   Wed, 4 Nov 2020 13:14:06 +0000
Message-ID: <CY4PR1701MB1878601405CDE35CBFB0EA52DFEF0@CY4PR1701MB1878.namprd17.prod.outlook.com>
References: <CY4PR1701MB1878B85B9E1C5B4FDCBA2860DF160@CY4PR1701MB1878.namprd17.prod.outlook.com>
 <20201029081626.wtnhctobwvlhmfan@pengutronix.de>
 <CY4PR1701MB187881808BA7836EE5EDFE06DFEF0@CY4PR1701MB1878.namprd17.prod.outlook.com>
 <20201104131104.GV933237@lunn.ch>
In-Reply-To: <20201104131104.GV933237@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 50b29a3d-834a-47ff-a5a0-08d880c38280
x-ms-traffictypediagnostic: CY4PR1701MB1719:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1701MB1719912121950A9D0B3BF012DFEF0@CY4PR1701MB1719.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 41xBP8U89L+boAOIVK66Z34wt1SvPAl05W21tWxwl0reuvBiIPGBJUZA3FVf9t7nCh/HmBURevxAxmIDSMqzF9bcTjd6945KiL9ft+qhdM83z/s82nmhXnGMPiOUiVnXVgO0juoxdf9ltv3g9XyxxXSQN/bN3YIIoA7Z+unMcmlhS86Sbe6tjCXmqnCfhTfE6rlHxRcVQ/aOE0B5LfPM3oi5P+a3LqvEk4JU5hKYM4vHzfZMosBirGb0eb29CDUsgsGUwUL7qypr5RSpw7C1flKM2dlv5pp4btUJtEOCrslxFll1Nsx1THx9VPVeyikr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1701MB1878.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(136003)(346002)(39860400002)(33656002)(186003)(316002)(5660300002)(26005)(2906002)(4326008)(8676002)(83380400001)(76116006)(9686003)(66946007)(107886003)(66446008)(8936002)(54906003)(55016002)(7416002)(66476007)(66556008)(71200400001)(6916009)(52536014)(86362001)(53546011)(64756008)(6506007)(7696005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 39yVmwUGx5deDRUm5ykiSD7QWhIwJ6PA7yzMoa2vdLvMCtfjhivamW5QDfAPGrJr2Hv1urLhx2G/iMqqiiLmRvm7rIBGVDsI7fbZv7A9ArMqLyAY8C5ChJU5BDC4IFMQx6i3tc7XdJqFG0Q3mBvAMnq0VJzt8XmRN2pUhKT2rlKn/JbizGWwxH6MNxT2CRxWhmyjk4BZDuihTtzGWojnVwKeurZWtgNqcBFO6ZiFxMs4ag0cz05ruUvsfdO76jwmaWFfxh+Hs/ACYrcHO/YxmxGZ0chQxkLn1JieH36LJWNugGgnx8IwMDI0sXcK31enfb0bZNv7PwSmHv0gzw1JWZBDEbqwblkKKS+HI2CQtcZcrZNqQNka3UvaRcwEFgjtTqI/h1w2zOJktZLbaPh3XmMZMDfIajTf0WhFh0w5zL67J34w5vKHjkp7r9yfJWUO8HzJiv1T41fVqkWxJGmpb7EflJB9Jz9cxTZoyCtXsYzm1DJNpAfCqT7Zn2eBuJY9fR54nrKcAURMxIEglwRScTpPsox1vooq30Yf0pdh6g3kCajwSpvpum4jk5Hs+Dmi2REYFtwTvNIa2iVwQymLgcXdMZ036sYjsSk3IIOWrx6tteT4KL26L7G2UXpK1VS2ZTmhF7MOfROqtdszNL2rKA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1701MB1878.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50b29a3d-834a-47ff-a5a0-08d880c38280
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2020 13:14:06.8032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zSd+kcgkKNNtwPt5gLBzGjyVsSiBDZM/b4CYcmpBp8uWOsTOlbbei9GRhMTAlbvLTD07knJaznjqPtlwsOBW4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1701MB1719
X-TM-SNTS-SMTP: 44D59E5843AB38965BAF20BD7DAAA1F74EAF1156601521FCA7A6170E69CEA70A2002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25766.007
X-TM-AS-Result: No--16.780-10.0-31-10
X-imss-scan-details: No--16.780-10.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25766.007
X-TMASE-Result: 10--16.780400-10.000000
X-TMASE-MatchedRID: 3TiJSEK0LvkpwNTiG5IsEldOi7IJyXyIypNii+mQKrGqvcIF1TcLYAjJ
        M0WLRMJtsrWE1NucEUBp8kKYU14E2WTCW9kfZBzauwdUMMznEA8BDya2JbH/+if0DxhZHOwya2B
        yQZcfaSe8IpVpDCQoNXzygLIsa/l9r4kIqJlZKuhmPsTq8ee41jLKL6f4fTnRHWtVZN0asThscy
        SwPX3q96sEXVjo16bJY/5MySWMxKrCX9jsK0CBJDdfT4zyWoZSrFP4l9ANsI9psnGGIgWMma6+U
        xOBi85N40xYq6H79DVJSlKpmmVj3cFBoCgEV4LyUPktDdOX0fsCn5QffvZFlSC0GE1e11LhvKK4
        uT/Z8fi8TX7lMO0gYAv27KDI524OHMxD66p2PMIjupy0k4T2ug73P4/aDCIF70ULJJwFphrUZZs
        o3zLrr6sjXQwH/XtFarhRRWLyWzFJI5ZUl647UDM5SNDnT9yzfwO+RRpsStUqtq5d3cxkNQwWxr
        7XDKH8StoN/GFO9P4ACF/Ig7xu/yHGuEJcnnyMU4HnbXEa+rRoFWDUNKR2tQ==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BF

>=20

-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

-----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, November 04, 2020 2:11 PM
> To: Badel, Laurent <LaurentBadel@eaton.com>
> Cc: Marco Felsch <m.felsch@pengutronix.de>; davem@davemloft.net;
> fugang.duan@nxp.com; kuba@kernel.org; Heiner Kallweit
> <hkallweit1@gmail.com>; linux@armlinux.org.uk; p.zabel@pengutronix.de;
> lgirdwood@gmail.com; broonie@kernel.org; robh+dt@kernel.org;
> richard.leitner@skidata.com; netdev@vger.kernel.org;
> devicetree@vger.kernel.org; f.fainelli@gmail.com; Quette, Arnaud
> <ArnaudQuette@Eaton.com>
> Subject: Re: [EXTERNAL] Re: [PATCH net 0/4] Restore and fix PHY reset for
> SMSC LAN8720
>=20
> > > > (ii) This defeats the purpose of a previous commit [2] that
> > > > disabled the ref clock for power saving reasons. If a ref clock
> > > > for the PHY is specified in DT, the SMSC driver will keep it
> > > > always on (confirmed with scope).
> > >
> > > NACK, the clock provider can be any clock. This has nothing to do
> > > with the FEC clocks. The FEC _can_ be used as clock provider.
> >
> > I'm sure you understand this much better than I do. What I can say is
> > that I directly measured the ref clk and found that when I add the
> > clock to the DT the clock stays on forever. Basically it seems like
> > the FEC calls to
> > clk_disable_unprepare() don't work in this case, though I'm not sure
> > about the reason behind this.
>=20
> The reason is easy to explain. The clock API is reference counted. It cou=
nts
> how many times a clock is turned on and off. A clock has to be turned off=
 as
> many times as it was turned on before the hardware actually turns off. So
> you have the FEC turning the clock on during probe, followed by the phy
> turning the clock on. Some time later the FEC turns the clock off for run=
 time
> power saving, but there is still one reference to the clock held by the P=
HY, so
> the hardware is left ticking.
>=20
> 	Andrew

That makes a lot of sense, thanks very much for the explanation.=20
