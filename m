Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92261BDB42
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 14:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgD2MAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 08:00:15 -0400
Received: from mail2.eaton.com ([192.104.67.3]:10500 "EHLO
        simtcimsva02.etn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgD2MAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 08:00:14 -0400
Received: from simtcimsva02.etn.com (simtcimsva02.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12E3C11A0F8;
        Wed, 29 Apr 2020 08:00:13 -0400 (EDT)
Received: from simtcimsva02.etn.com (simtcimsva02.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05D9111A173;
        Wed, 29 Apr 2020 08:00:13 -0400 (EDT)
Received: from SIMTCSGWY01.napa.ad.etn.com (simtcsgwy01.napa.ad.etn.com [151.110.126.183])
        by simtcimsva02.etn.com (Postfix) with ESMTPS;
        Wed, 29 Apr 2020 08:00:12 -0400 (EDT)
Received: from LOUTCSHUB03.napa.ad.etn.com (151.110.40.76) by
 SIMTCSGWY01.napa.ad.etn.com (151.110.126.183) with Microsoft SMTP Server
 (TLS) id 14.3.468.0; Wed, 29 Apr 2020 08:00:12 -0400
Received: from USLTCSEXHET02.NAPA.AD.ETN.COM (151.110.240.152) by
 LOUTCSHUB03.napa.ad.etn.com (151.110.40.76) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Wed, 29 Apr 2020 08:00:11 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by hybridmail.eaton.com (151.110.240.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Wed, 29 Apr 2020 07:59:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j77plxIxL8QcjNDW8acu75JWQdsR+RXyP+2HHxcn04TieXDwhB7wjSseXxiUi8cwsnPx4/TpyaZLCvdHEMZ6W1gaq3kqs4AiQXgz6wiKZTYvCMZd95K7Ypqy3QeWoN1nB9GK6nNlCRP6P8inOPI2S7ZEyTcXDX90HnelwJFC6jA+avE9FinqVarjBIHYzYxLBdv8eBmk3JMDS4r2J2LzEy7lizOXQTuZ/GHwuhNo4VtbtBgLkpzcbdcvihuR1D7SehpIgcvECo85o3mhuFWJVLcOrwy7Rw95lATPdS/exMIyFzA4fQBplvYJZ35gf9QzxtR6+m4lXDc9TndG20HJtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58FLL8IiPvjRvhj/JppcvraPtbktlWQsrYn0tOuaSro=;
 b=b3K6JM9yA6bvXXM0yfLcCOQRIQ9xt7NI5Qd4T3dp9jlFVLg7dV6OnABIZdV7+G7vwAvzAJt/V+vI1+cjUlICbRod7jBN3RLPU75Y/s0+cgEF/kxIjNav2uYYtpxpNQWjo5bSjYLKodRNiYtQ0o34PimWTSWOzHLv+9MyTTLWOPekTwoQ2QEqZ4yMki/8DZZdDgyXuFaqDj6SA9X2uqNAl7nyY6PUBLbDVx/FW3a/rWZWc+FUtZDFsfWKcKsKLIOnJuGrmsLdhNYXhxbjDXDm0IvhTjpCr+cUKcp3/qS1kQMtDsCTr0k1bpu5DG1rCt7/9I0CjdnTaaxb31ZgmE3Zxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58FLL8IiPvjRvhj/JppcvraPtbktlWQsrYn0tOuaSro=;
 b=qSFtKTrQVZfvGohGJfd9Wiria9VkjT+IMGEs03rNo3iCFE/yzglYGEBreJ2Z1hVoAFsSNrgT3QPNGvypxUXXL02ZRk0+OFe0+GSVy5vHLYcTYi3wyjYrcaVHl/Xl3n7o09Srb0gKCMTPnihRMt04KRQ1U+DoybyaZJhw3AfJ2cs=
Received: from CH2PR17MB3542.namprd17.prod.outlook.com (2603:10b6:610:40::24)
 by CH2PR17MB3831.namprd17.prod.outlook.com (2603:10b6:610:87::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 12:00:10 +0000
Received: from CH2PR17MB3542.namprd17.prod.outlook.com
 ([fe80::684d:3302:3158:502c]) by CH2PR17MB3542.namprd17.prod.outlook.com
 ([fe80::684d:3302:3158:502c%5]) with mapi id 15.20.2937.023; Wed, 29 Apr 2020
 12:00:10 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "alexander.levin@microsoft.com" <alexander.levin@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "Quette, Arnaud" <ArnaudQuette@Eaton.com>
Subject: RE: [PATCH 2/2] Reset PHY in phy_init_hw() before interrupt
 configuration
Thread-Topic: [PATCH 2/2] Reset PHY in phy_init_hw() before interrupt
 configuration
Thread-Index: AdYeBMj3Elf0T3++RJuJe8w7Jf842wAGM5Rg
Date:   Wed, 29 Apr 2020 12:00:10 +0000
Message-ID: <CH2PR17MB3542969A2C3545C58E000928DFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
References: <CH2PR17MB3542BB17A1FA1764ACE3B20EDFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
In-Reply-To: <CH2PR17MB3542BB17A1FA1764ACE3B20EDFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [178.39.126.98]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6f3faa4-99b8-4d27-4773-08d7ec34de1d
x-ms-traffictypediagnostic: CH2PR17MB3831:
x-ld-processed: d6525c95-b906-431a-b926-e9b51ba43cc4,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR17MB3831D0555C1841059076B53CDFAD0@CH2PR17MB3831.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 03883BD916
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR17MB3542.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(376002)(136003)(366004)(346002)(86362001)(8676002)(26005)(8936002)(186003)(107886003)(4326008)(52536014)(2940100002)(66946007)(66476007)(66556008)(64756008)(7696005)(66446008)(55016002)(9686003)(6506007)(53546011)(76116006)(478600001)(7416002)(45080400002)(33656002)(2906002)(5660300002)(316002)(71200400001)(110136005)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ESJXeMqt+/mVWnaA9pBn4zB5RIaoBJGeG1JsrNN2HVKG9EDEYaW3a5nX26wWnhh5mRACAJuVBxqLyIO6RD7auFAG4ph/Zy/+2pqldPD0GGeRiS0FKVfEZYUAI6v96LDWO80rbqZMiou1Ch7IdPtdGJFLPzRESaVkMfuNYFCg/xQgAnaQVxJr/nfN0Ltc2LONuF7ORwSfAiW3PWm+wAekW8xfKOwLmu1Oc0yxIcQxWNDWv4lNMqvEf5wnkJuqpB5THz8jCBuywo08YAVQ7ov55P5ZrmdlTm8rxJ/wnlsIZo//KRPVLp2YP1CvpilKwTYdTYObHHuoGF/pFNm0j+NztmA15/EgT4tVMIIsmJAuvlaZokzsw9h1HEi7x+2K4K1XiAN5hPn2mybvFEtuqqnToBNegtfsdZEwEfGxK/HM/jVMvPJVtNcXMq6El1oFKh+/Yug9ehwH4+2689uKl+k30Z/hgMFy8sUcUDL+lDBtA6s=
x-ms-exchange-antispam-messagedata: jiJY+ihp2EtnahXAPi/5sJpWxkw+4Wns5sWS+Ez9DwRUQ6kRTDVh86Mmzx3+JATDIbmqZw0Mm+P/82DfOCE2+bAXt+Qupr7ZoYkpXVsoWiAhORImSX4e+MeTzl6Qq+vIBNVICsjmb0aWBormRPuOfyVViyJQcxpJfCODerEqXGjsiNoJzk+7dH77yU9G22TSuCBnpTKSgwrnIv8uIRCchn0ORBSaanxAQIBeD7qoqnDf+r9OkgHte+bGDOncPE9GyW/npKQPfoWeFFdUOuv2ByoioFFWo/iLWpIM5GgbADNaeUN9tunpW3KBlAJ28oWrEMmYGMFGYgDy4kC3DWIbNNKYzQDl+V2LdriNB8conI7m1Lx3lPUBC62jBS478iXtLk7EzlPbENvtvsnB2GwBly8BYCztqBs8VEgB3bZM+fiZITS8iGtcTVnu0CPFTfXCY09y/ysHFZWxIkaG/LII5fHxS+2PRTRAQsEc0FPY1FcZtFcAON0QhAuMj8XiaIJu85KnpGNR6CunZ5ZDOV0dJI0qCl2Vxhv8Dl9Bq79IyZNMBYEVrdZbU933rtIN3QIsUg48VnOOKtn96Xw6UDCoqhRSkS05a87haSpCvAVr8hGD8atC9yN5LAMMcBUk+mz5NwDslqh0a4fe+Yys3w35a22YksvriKjMTEhgulyM069r1MuU++rC3wtyfo+gBWZ2WMQlm5J5E3n1Rp0j4XE1Mzq8ty8lFOMDqhamx6b5WTfpfA8r0Gz9I8DSqMarTFM+ze27ZiHQfscJXo65jBxBm1dEb7MY1+tMFKtGPB1fYeY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a6f3faa4-99b8-4d27-4773-08d7ec34de1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 12:00:10.4300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XFzRsPMiauROYSErA2I9LXqnurkILbv69OJgmsa732jRKGoa9wAqfkoHq5m9F3OSM0OepogjRxOvlt4Rl7elOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR17MB3831
X-TM-SNTS-SMTP: 69A72EC2FD24ACF2B54720B6ED2183DCE8625EB0298109D399523719C2054DE12002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.5.0.1020-25384.007
X-TM-AS-Result: No--10.742-10.0-31-10
X-imss-scan-details: No--10.742-10.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.5.1020-25384.007
X-TMASE-Result: 10--10.741500-10.000000
X-TMASE-MatchedRID: qDftgE+/1EYOMO1eHmEbOe5i6weAmSDKNQB4EQzdUmOhEEjLknSXwD6z
        eSLHcZq1eBU1sygo3NUlPPpH1Z74wvSCkSozt+9hMIxbvM3AVoiZ2scyRQcer7xgMf9QE2ebOnR
        FDX9soFwwQ7kdQ4mkwPtzbcy7Mpnqx1/NuoFDMxS7B1QwzOcQDzVfUuzvrtymG6hk8rmULu4i0v
        wztBGjFyZ8pVBm6qwUj0IvV7jlqDgaPpT4qyAWbnpRh12Siy9rS/qn/PJIggWqvcIF1TcLYAjJM
        0WLRMJtsrWE1NucEUAdbIlcN0IM0/s9SDPkW26p9u1rQ4BgXPK2wZcpnqYK8nCkx0U8Rozjnptr
        8PnHpylAjzdPjuttgK/dq3PF0Qgr3QfwsVk0Ubv+efAnnZBiL5K13zeQcKlRthS9uvYuBrXEPFy
        1lHUAh3DsB9Fjn3+1b69SUQXKVcBi/iTYISQ9VvkiJkH3mkHFeH00G4LN/+oh5RCp7TztFrdzRi
        DqTditFaxeWnCS8ZslvSAWyC3OneOqYLXF09N1er9w8HVXph0=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFDescription: this patch adds a reset of the PHY in phy_init_hw()=20
for PHY drivers bearing the PHY_RST_AFTER_CLK_EN flag.

Rationale: due to the PHY reset reverting the interrupt mask to default,=20
it is necessary to either perform the reset before PHY configuration,=20
or re-configure the PHY after reset. This patch implements the former
as it is simpler and more generic.=20

Fixes: 1b0a83ac04e3 ("net: fec: add phy_reset_after_clk_enable() support")
Signed-off-by: Laurent Badel <laurentbadel@eaton.com>

---
 drivers/net/phy/phy_device.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 28e3c5c0e..2cc511364 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1082,8 +1082,11 @@ int phy_init_hw(struct phy_device *phydev)
 {
 	int ret =3D 0;
=20
-	/* Deassert the reset signal */
-	phy_device_reset(phydev, 0);
+	/* Deassert the reset signal
+	 * If the PHY needs a reset, do it now
+	 */
+	if (!phy_reset_after_clk_enable(phydev))
+		phy_device_reset(phydev, 0);
=20
 	if (!phydev->drv)
 		return 0;
--=20
2.17.1


>=20

-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

-----Original Message-----
> From: Badel, Laurent
> Sent: Wednesday, April 29, 2020 11:04 AM
> To: 'fugang.duan@nxp.com' <fugang.duan@nxp.com>;
> 'netdev@vger.kernel.org' <netdev@vger.kernel.org>; 'andrew@lunn.ch'
> <andrew@lunn.ch>; 'f.fainelli@gmail.com' <f.fainelli@gmail.com>;
> 'hkallweit1@gmail.com' <hkallweit1@gmail.com>; 'linux@armlinux.org.uk'
> <linux@armlinux.org.uk>; 'richard.leitner@skidata.com'
> <richard.leitner@skidata.com>; 'davem@davemloft.net'
> <davem@davemloft.net>; 'alexander.levin@microsoft.com'
> <alexander.levin@microsoft.com>; 'gregkh@linuxfoundation.org'
> <gregkh@linuxfoundation.org>
> Cc: Quette, Arnaud <ArnaudQuette@Eaton.com>
> Subject: [PATCH 2/2] Reset PHY in phy_init_hw() before interrupt
> configuration
>=20
> Description: this patch adds a reset of the PHY in phy_init_hw() for PHY
> drivers bearing the PHY_RST_AFTER_CLK_EN flag.
>=20
> Rationale: due to the PHY reset reverting the interrupt mask to default, =
it is
> necessary to either perform the reset before PHY configuration, or re-
> configure the PHY after reset. This patch implements the former as it is
> simpler and more generic.
>=20
> Fixes: 1b0a83ac04e383e3bed21332962b90710fcf2828 ("net: fec: add
> phy_reset_after_clk_enable() support")
> Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
>=20
> ---
>  drivers/net/phy/phy_device.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 28e3c5c0e..2cc511364 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1082,8 +1082,11 @@ int phy_init_hw(struct phy_device *phydev)  {
>  	int ret =3D 0;
>=20
> -	/* Deassert the reset signal */
> -	phy_device_reset(phydev, 0);
> +	/* Deassert the reset signal
> +	 * If the PHY needs a reset, do it now
> +	 */
> +	if (!phy_reset_after_clk_enable(phydev))
> +		phy_device_reset(phydev, 0);
>=20
>  	if (!phydev->drv)
>  		return 0;
> --
> 2.17.1

