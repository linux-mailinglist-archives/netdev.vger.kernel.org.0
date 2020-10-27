Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B471629CD59
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 02:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgJ1BiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 21:38:18 -0400
Received: from mail2.eaton.com ([192.104.67.3]:10400 "EHLO
        simtcimsva02.etn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1832998AbgJ0XZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 19:25:16 -0400
Received: from simtcimsva02.etn.com (simtcimsva02.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D148E11A09B;
        Tue, 27 Oct 2020 19:25:14 -0400 (EDT)
Received: from simtcimsva02.etn.com (simtcimsva02.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81FAA11A086;
        Tue, 27 Oct 2020 19:25:09 -0400 (EDT)
Received: from LOUTCSGWY04.napa.ad.etn.com (loutcsgwy04.napa.ad.etn.com [151.110.126.21])
        by simtcimsva02.etn.com (Postfix) with ESMTPS;
        Tue, 27 Oct 2020 19:25:05 -0400 (EDT)
Received: from LOUTCSHUB01.napa.ad.etn.com (151.110.40.74) by
 LOUTCSGWY04.napa.ad.etn.com (151.110.126.21) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Tue, 27 Oct 2020 19:25:04 -0400
Received: from USLTCSEXHET01.NAPA.AD.ETN.COM (151.110.240.151) by
 LOUTCSHUB01.napa.ad.etn.com (151.110.40.74) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Tue, 27 Oct 2020 19:25:04 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by hybridmail.eaton.com (151.110.240.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Tue, 27 Oct 2020 19:24:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BKz2X1sjm5E1HccY35BZI7PIB/9hJNVV0/r6gZylbrB71fhx4ypJ1HJ+4pMbGXavQcMUr0OCo205DRY4+0Ab/Ciezuz28ErE1ABXYr7xi1vabyUM7H/W0BsindZgKyUDuBlsw+kCWrfS4nQfaNOg9Qi81wXmljMytgb/ECqY92/SvFZq1DVEVt5K7fDhuILtoXFMw0Kll2qGt1d6hbEnqh4Zdi/1JApV694LA4kUxYLMuGBmC1qzq4Q+aSydJIsPeYcgoNwsDp7/jt9S758cnRiWug01bemfmV+b24b4HsUh7mYKdmPGBjfmqcTl2lZbpo0pJckyjY2HCF9uE6caUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQEpNK43I/RzyGDq0soDxaHlhvUKIQKiMFIUlebGz7U=;
 b=YGbK7W5gzOV8oKbBTbLl/o/rBdaYR0wdEzpfMQcyMpmvm5z6c5gZVWsZvCOAlu5nHJ6w35sZShIM+78zqOGwE2nwkrCYgJjAeox8q0sGBy5F3EqEcdAP4fpLAMNplz2xmwz3UhtU7Cf1QoygPCGWfGFIdXPTQQjNgepG1h2C8kKISl6UYJdugFTgEdW4+MPRTkoBivfJi5jcVOOLwO5x3AQIqaF0tpjz80cJwCPwOVZOmQ8fQM+09TEFruxu7vdNz2md2bRnyyl0+RtO+BmPuAqdgfyANXZHVfGuT3/mFuJbM9i9hZ4uOcQPQWaXKqqQHfEZ+pVPwE15DgqOnAMMRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQEpNK43I/RzyGDq0soDxaHlhvUKIQKiMFIUlebGz7U=;
 b=NAxPcnPvNm2yruG+7kO5tP2vwHhAsREJ4UgKI904a46Qtu7C7DK3B4FsJs29F6xWTRp6iENvrxs2i5SrNYyLHRXOId6oPxlAivGrcnVLc2VnPPk+Dg9E/f44TaYbZFBsz2XIuEkYo6v4gCsqkOeMiDFrnQceKr6F9WSmyUeotvo=
Received: from CY4PR1701MB1878.namprd17.prod.outlook.com
 (2603:10b6:910:6d::13) by CY4PR17MB1256.namprd17.prod.outlook.com
 (2603:10b6:903:8e::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 27 Oct
 2020 23:25:01 +0000
Received: from CY4PR1701MB1878.namprd17.prod.outlook.com
 ([fe80::a5a5:a48b:7577:6b45]) by CY4PR1701MB1878.namprd17.prod.outlook.com
 ([fe80::a5a5:a48b:7577:6b45%6]) with mapi id 15.20.3477.028; Tue, 27 Oct 2020
 23:25:01 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "m.felsch@pengutronix.de" <m.felsch@pengutronix.de>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
CC:     "Quette, Arnaud" <ArnaudQuette@Eaton.com>
Subject: [PATCH net 0/4] Restore and fix PHY reset for SMSC LAN8720
Thread-Topic: [PATCH net 0/4] Restore and fix PHY reset for SMSC LAN8720
Thread-Index: AdasuCyaTCUfPNScQDqUis8Tkf1v8A==
Date:   Tue, 27 Oct 2020 23:25:01 +0000
Message-ID: <CY4PR1701MB1878B85B9E1C5B4FDCBA2860DF160@CY4PR1701MB1878.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 32b8073d-96ff-44cd-63a6-08d87acf872f
x-ms-traffictypediagnostic: CY4PR17MB1256:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR17MB12564CFA6A8894B5A13DF985DF160@CY4PR17MB1256.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TRaOeiPPqhVjtcVV8prf9tlQ+H023yejbINkeReuLz4cAz7idiQuCklwYg07SGPSQgA6J/aE6wY8zvt8Ebsh7gyJjKYK5atJa6EUBoVWQ4ZJKG6bAaTRj6rdhpXTwVxV+nS4o9rOnys/+jb4u4ti6bkw2mJKSBaiEJ/9yH3xFC5dI/tPTKpKNGk9LbESOuNukSOLUAcnhHjD4lT40yeULO4G9ejTK2vMbI8jt37mMouKwuF8PxJXM0x9as+23J9K8rYUxNHjQ9jPGwvtINQ3KSXzafTGf7MNkH5uF7X+dMfX8/SaQ1PwO0/JSZFpRSfW3nND8K3XjpGWFQnX74tWBXLCTGX1VlUqrrT3upyZ5PhkM7hgzfZGVxshH06PyY8E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1701MB1878.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(39850400004)(346002)(366004)(66446008)(76116006)(478600001)(7696005)(33656002)(86362001)(52536014)(66946007)(66556008)(83380400001)(7416002)(64756008)(5660300002)(186003)(110136005)(4326008)(6506007)(66476007)(316002)(8936002)(71200400001)(8676002)(107886003)(55016002)(9686003)(2906002)(26005)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: cL0ae+/YrL9ggBWG0uSahjNrD9FxeALbZ7u85hgitG44cm2dNovligTsYtE9m1TaBfrO3Ihb7fIFF67DW3tL6uSE4SMoYA5bLpwcBIt/FqPJ9TXZu9lZFs8zHYITPHGujlB120F6sVrov8JU3hcZZjtAh3D5Z89wrh1a2z7qlp4V+rtOzp04KyYjYo+i1ixt7liX6B0L/NvmzRZOMJpKJbmobuQ+AGMRxqKNw/MMhDgi0aOw2ICyZP1hvdYABHzug7zXz17Ftj0hs1cdaWgQsqCogJX43RgKTJu0WtzDA2qRxUUi8mI5k+ssm6C2kY1re4woq9y1Qj5nqwnTD3G8LXAce8HvKKHwkxobTwkLzeBLenmTMViPLjjodo0JornghhHgN/TWEZ27R1j82B8SgUeDtjqCvaA1+XZ04YpSOrPYk3wH7pUhjkM6OpXFN28v4hGeR5eLPLDsBA9iGycoxEMgRgA+T8LNGJ6fdjbLslyEC/ctwPALr4EShtO1jKtnylGPcD3OszQQjFhdYFr4iqBULh1wv4d+vQ4UKZhZ3DKAAqZFkpTWQ2tqb6+PQLRPO2UkW3qITUUE9cfacla84nu9A6WXpzN2ldqls2BXGoJlHToEcu14RH/+euXTL7nfEjBBeO786HgcerZEu5I+5Q==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1701MB1878.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32b8073d-96ff-44cd-63a6-08d87acf872f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2020 23:25:01.6574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5fRWcdUv83mq/zK3FtmSahKfiF2oU4aCjCvc2agy6YXgYJQiYnWhzvSdDPBgyvgIWMswwpyNwV9YdoQtAVDGaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR17MB1256
X-TM-SNTS-SMTP: B372A1CFC4CD810F7035AB574B1648659B6AD0B14BA34484A9DC680389DED7BA2002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25752.003
X-TM-AS-Result: No--1.742-10.0-31-10
X-imss-scan-details: No--1.742-10.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25752.003
X-TMASE-Result: 10--1.741800-10.000000
X-TMASE-MatchedRID: BhcknCqDkQeYizZS4XBb35VRzPxemJL0APiR4btCEeYd0WOKRkwsh4JV
        W4oTDi/+jmvHbETf1n9nAwKLgKVGAEP8wYcu6bTegq+cWtkrZSExXH/dlhvLv8AkyHiYDAQbaGR
        LCnKSipX+/nPGlAmfKbFmZolQJCqvTpAZ21pPBYGJUlmL3Uj0mPMMVfCUdzaoSgypjNmDEOuyVb
        9d3WTXx365wCHja8S0ZJVHNW1Xjrx+7Gr2hULRCp2qrRzrhHWq9fvWztwgm5OpUxQxmTD4QmxzJ
        LA9fer3qwRdWOjXpsklnCfhOzHZ4CLSA2Bw59G2LTHwnYOikQ0GchEhVwJY34PLx3vY4vNi4tEY
        aayedIOD8GyWfZ4BMfFEd/KZz2rVlmP4dSOrQfZPs79gcmEg0KKRkGOW2z9yHNJ22Gj+T8PD9iR
        j9LIMxiijdXEGp4FgxIlmjVV6USrf553KJlUviG6HurDH4PpPMC4zO7d4kaOBTfzBFuc88sbQuY
        gvFFjzOelg+pLqPPEnayvpxBMhhFGEd5OSBmbm2oIkXC6Ol0DyRrv+hwfKX3+liOD53f81+gtHj
        7OwNO19R4Ss0oUmJ8R2sbRjZp+3JoF2rcutTrhHbKsQEaUG1edmGT3Unrl0mdWfOAUbGFx1hBEr
        p3pG/UY/vonnIqoPhOEijvod03bfO1l1W46FFU8jxvONzeaafEwSr4v8H0fxemJbhO7ZfZTIXce
        rO/Bu
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFSubject: [PATCH net 0/4] Restore and fix PHY reset for SMSC LAN872=
0

Description:
A recent patchset [1] added support in the SMSC PHY driver for managing
the ref clock and therefore removed the PHY_RST_AFTER_CLK_EN flag for the
LAN8720 chip. The ref clock is passed to the SMSC driver through a new
property "clocks" in the device tree.

There appears to be two potential caveats:
(i) Building kernel 5.9 without updating the DT with the "clocks"
property for SMSC PHY, would break systems previously relying on the PHY
reset workaround (SMSC driver cannot grab the ref clock, so it is still
managed by FEC, but the PHY is not reset because PHY_RST_AFTER_CLK_EN is
not set). This may lead to occasional loss of ethernet connectivity in
these systems, that is difficult to debug.

(ii) This defeats the purpose of a previous commit [2] that disabled the
ref clock for power saving reasons. If a ref clock for the PHY is
specified in DT, the SMSC driver will keep it always on (confirmed with=20
scope). While this removes the need for additional PHY resets (only a=20
single reset is needed after power up), this prevents the FEC from saving
power by disabling the refclk. Since there may be use cases where one is
interested in saving power, keep this option available when no ref clock
is specified for the PHY, by fixing issues with the PHY reset.

Main changes proposed to address this:
(a) Restore PHY_RST_AFTER_CLK_EN for LAN8720, but explicitly clear it if
the SMSC driver succeeds in retrieving the ref clock.
(b) Fix phy_reset_after_clk_enable() to work in interrupt mode, by
re-configuring the PHY registers after reset.

Tests: against net tree 5.9, including allyes/no/modconfig. 10 pieces of
an iMX28-EVK-based board were tested, 3 of which were found to exhibit
issues when the "clocks" property was left unset. Issues were fixed by
the present patchset.

References:
[1] commit d65af21842f8 ("net: phy: smsc: LAN8710/20: remove
    PHY_RST_AFTER_CLK_EN flag")
    commit bedd8d78aba3 ("net: phy: smsc: LAN8710/20: add phy refclk in
    support")
[2] commit e8fcfcd5684a ("net: fec: optimize the clock management to save
    power")

Laurent Badel (5):
  net:phy:smsc: enable PHY_RST_AFTER_CLK_EN if ref clock is not set
  net:phy:smsc: expand documentation of clocks property
  net:phy: add phy_device_reset_status() support
  net:phy: fix phy_reset_after_clk_enable()
  net:phy: add SMSC PHY reset on PM restore

 .../devicetree/bindings/net/smsc-lan87xx.txt  |  3 +-
 drivers/net/phy/mdio_device.c                 | 18 +++++++++++
 drivers/net/phy/phy_device.c                  | 32 +++++++++++++++----
 drivers/net/phy/smsc.c                        |  5 ++-
 include/linux/mdio.h                          |  1 +
 include/linux/phy.h                           |  5 +++
 6 files changed, 55 insertions(+), 9 deletions(-)

--=20
2.17.1



-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

