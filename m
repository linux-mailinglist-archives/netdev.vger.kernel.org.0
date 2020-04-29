Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0611BD7D7
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 11:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgD2JDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 05:03:44 -0400
Received: from mail.eaton.com ([192.104.67.6]:10500 "EHLO loutcimsva03.etn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbgD2JDo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 05:03:44 -0400
Received: from loutcimsva03.etn.com (loutcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFE3A8C127;
        Wed, 29 Apr 2020 05:03:42 -0400 (EDT)
Received: from loutcimsva03.etn.com (loutcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8D1F8C117;
        Wed, 29 Apr 2020 05:03:42 -0400 (EDT)
Received: from SIMTCSGWY04.napa.ad.etn.com (simtcsgwy04.napa.ad.etn.com [151.110.126.121])
        by loutcimsva03.etn.com (Postfix) with ESMTPS;
        Wed, 29 Apr 2020 05:03:42 -0400 (EDT)
Received: from SIMTCSHUB05.napa.ad.etn.com (151.110.40.178) by
 SIMTCSGWY04.napa.ad.etn.com (151.110.126.121) with Microsoft SMTP Server
 (TLS) id 14.3.468.0; Wed, 29 Apr 2020 05:03:42 -0400
Received: from USLTCSEXHET02.NAPA.AD.ETN.COM (151.110.240.152) by
 SIMTCSHUB05.napa.ad.etn.com (151.110.40.178) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Wed, 29 Apr 2020 05:03:41 -0400
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.50) by
 hybridmail.eaton.com (151.110.240.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Wed, 29 Apr 2020 05:03:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ck78hT9tG4HDKUCgsE4aY+tF8o1LOepCqMN2W0D8cUGG6b1jnMqfJ5qMteUgpcbDfui9EG+t4oHZWhDxLGzgEiUT+MwslQCSjXqhoUAA+B9figGcCIgY9TZrrLAZIaiqVKLKrGT2DF/WfF7YwbOL7iT8dWCe4udek6b9bn0gEpOEpinZ63dZf8zvM8HI/aD98GLTDJNvo8l8byZjYtzc++OgasGb3bhHI26gsu17kqPMgb0GbIPN9pIX+pxpll+0GAT4dlNn0i8buZpyVT8WWsBB8WdFK3fuyszjMxkRq97quT0xVVW4U3zRRkJxqVZ55X2QYyMOb++8ukiUClqyuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YUfZniawTE68WYT09bD8e+TCyj9gYXjN2MphDHTIKqI=;
 b=QMeBEBbSzRRypd3c8kNPtxwgtHzIhn1q9LxPL5xl+Y2RPHBDWxMFn2Wd1qKgJxWu7m6Ca3/KELt7Ca8sr5aWlXyo/GFJG+TA9GujEmwqsEDhrzhpbvmeKJ/bO/qFsTWFvQncY0O6M0Mvm6wXyScRubK/CpxhZDJlj9nZicpS5Z1S4sk452Tuoio1TXJpPk9z3PKyk9ylX49kphQGvdXkM9OCdY3zy0LJ4byzmarJhFQTR1dVHGlkYgegT+wqq2DKk0f958Q+BVSE+QORcXU0CGcWsMNJD/fDOznblG1yVmpAM2wmfMhuqJpd8qWRPia80FJSeM4ge7XPNrzyX9oxLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YUfZniawTE68WYT09bD8e+TCyj9gYXjN2MphDHTIKqI=;
 b=BaY6hRwds04UNxMmtb2J7V6Bh3NqOh1CuXmXdHKBnCg5lW9no4ls2ZSXUwaS09W9CpO0p35a6noO566qxAc79Z+W0QNiJywynG6O6CQl6Au4bA2xMQd1oDHSsPa/NwqJ3S6MI11nsl2p6KEC61izys3GJNB63uvfzf6kbmBbnhM=
Received: from CH2PR17MB3542.namprd17.prod.outlook.com (2603:10b6:610:40::24)
 by CH2PR17MB4008.namprd17.prod.outlook.com (2603:10b6:610:87::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Wed, 29 Apr
 2020 09:03:39 +0000
Received: from CH2PR17MB3542.namprd17.prod.outlook.com
 ([fe80::684d:3302:3158:502c]) by CH2PR17MB3542.namprd17.prod.outlook.com
 ([fe80::684d:3302:3158:502c%5]) with mapi id 15.20.2937.023; Wed, 29 Apr 2020
 09:03:39 +0000
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
Subject: [PATCH 2/2] Reset PHY in phy_init_hw() before interrupt configuration
Thread-Topic: [PATCH 2/2] Reset PHY in phy_init_hw() before interrupt
 configuration
Thread-Index: AdYeBMj3Elf0T3++RJuJe8w7Jf842w==
Date:   Wed, 29 Apr 2020 09:03:39 +0000
Message-ID: <CH2PR17MB3542BB17A1FA1764ACE3B20EDFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [178.39.126.98]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d388227-e52f-463a-ad9b-08d7ec1c356a
x-ms-traffictypediagnostic: CH2PR17MB4008:
x-ld-processed: d6525c95-b906-431a-b926-e9b51ba43cc4,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR17MB40085AB2E12ACF107EBBC77CDFAD0@CH2PR17MB4008.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 03883BD916
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CrmOFha1xMK9LTePDECshDHvLm0e3HcKdqH9TUin+0CRt48gIv1137hZkf65Er9NNsP4C4oLFkyD4v9lUChzKtmI1/4vfF5WKwrMWznpyIa41Z0CJeYXbkf9IoDAxH3VwK96lvWdqsVgGJwYrSdGZ2ew0RTDrZ5yUlqdaa0h41kBmUugohayfZlf4WJ8t+YjMwnzftIxSY+t2Y3k9yP+vNMyIlb/kwuIP0D23CYHnfqSeE8FLfk+aIH2bEGQThSklbEHyM4QTdv8YfBt2S7wMSM1jPPoGIb8uOijeHFTzn9tgbyFB3gKvDr0NS+e2fZZ+Bwx9301Fwc9fppwoQdjFhZGoR7hHYS73h9IBaR6HtnnNygnUYmd+t1gEvgyoFKrIxaAJ/Q4z08AVwsftYm+Vp7dbcEEoNIxW2/upiVUA93SnyV7w5zk0r7iIT9fNKr40Kjn3J6WYar5yh5JuzKDB0ED3jiUlHh68Q63dqC8FPM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR17MB3542.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(396003)(39850400004)(366004)(136003)(86362001)(52536014)(33656002)(71200400001)(66946007)(7416002)(4326008)(186003)(26005)(2906002)(478600001)(7696005)(55016002)(76116006)(6506007)(5660300002)(9686003)(66476007)(64756008)(8936002)(110136005)(107886003)(316002)(8676002)(66446008)(66556008)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: U9t70zpHQjycdcoy+aKllDERQawkfFEA+0HZ6RHiLiYxvL9rBQdyCAKwaGMkUvWpfXKVVPqFnuKx5KXUxExJsgaTYLnnuD5geplfkiSgWZEKKXhANC5Wv14+W+7HGB1jdK8ZHGLkgc59912HxnaEAOV0DvNKH2C7SIiZQuKZzHG63BqJr8FG+FHVXkEJy48QU84KySmZce9JYtfctmBoW+HEaEIld+8uHx+qMEf2kraL8tRwUOaY3LzKnXD65k+FO4nCJ9maLKH8cl3FuwtXqkez+nvJjPw2xtthXpMbpGloNrryW6jrgZXgd4O3Qu7n9le0E8sVDoix1mK/FnUs1tn/bFudjsT6UnYnjHBkFQcVQSl7ZqqpRSoSlkB1ogz0LFQx+SrlXHlVr0ShHa/eH4HywZr0dzj4/OUZCmFLpJcjy/Z8djoKv5QBLeRmLAqGC+j+LhrUJbQH/FuGaoHBZ3RXsN5zs1PWxySZSsmS0D+2ZrvEg+B7zrad0MjQb3lsH/WfEWKkXsS8Dn29VE6t411dAm5c0XKtD2iLQhFBGzqUFAJD5037+gr6xA57nk31Edy0r/wMFW2ILT24WK51KxTQ2CNR/pLcQs7it2GLuW+auH4f0S0di3AzVkUkgBkeBEwyIOoztkpqrn8i2KK3P00Kh7YvZetjP/3jaftaNapHUuxK2lhrNk4CQ6suxC0LMfJpSwMxreCuVlYrieiiTMa+3LmlozSeJHnzLgE7LnnUFW3FFd4SQZUMIK9TYSpNJEa9RU0y/vIwcEMtgiSuRuO4LwZTnT1bWythw71qiOU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d388227-e52f-463a-ad9b-08d7ec1c356a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 09:03:39.2399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s2hF61E/OKx/r72BaSNbAKiOogF5ZW9WW7OFFpUm5YHPRiowJtGPVUOtiZ6adNLScKs+srJVhXw8CpiVyMJzZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR17MB4008
X-TM-SNTS-SMTP: 48F928E4C192A7FD7F708B34C19024A3C48247BE3C371EF15DF83BDC014125FA2002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.5.0.1020-25384.005
X-TM-AS-Result: No--1.920-10.0-31-10
X-imss-scan-details: No--1.920-10.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.5.1020-25384.005
X-TMASE-Result: 10--1.919900-10.000000
X-TMASE-MatchedRID: VIUqeHku7VUOMO1eHmEbOYmfV7NNMGm+PbO0S2sWaK0N+F513KGyq4YM
        M3r3suSeYT8lhiANBQQuWuaCqkcrH5KzKN+yOsf+h2VzUlo4HVPqobkz1A0A7eZYcdJgScjx8TV
        EmEFAgcR8vXqHTYjzUfaHPjinKdQdvhuvqpOTXIZuh7qwx+D6T0yrwTdxivpzxpBNW09dc0zr7f
        jWKbC0Ra3aC25avUua1iOaOjE6Lab9zlA2W6E9MLWmSdbgUK0wqWaMWrxmYY6bSb+kMVrOUJ6ba
        /D5x6cpwN7kH1WNVDH3FLeZXNZS4PExmMzPfDZv1WtZDlH8+1bSibLwxxFecAHkCPcCMLcofc8D
        ttIwAox9dP4A0mkDuj6ZCvHhvyYW49fAcPW5BfSg0WVPwi7txidY9xGSmXhHBAJ3PG4bPIs3BYn
        /adIFdRZTlkXo2huTi7nUtfDUTO29ztkQ2YRciQ==
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

Fixes: 1b0a83ac04e383e3bed21332962b90710fcf2828 ("net: fec: add phy_reset_a=
fter_clk_enable() support")
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



-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

