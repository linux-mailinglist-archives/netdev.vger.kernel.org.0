Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87EA2FA6EA
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406442AbhARRAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:00:23 -0500
Received: from mail.eaton.com ([192.104.67.6]:10500 "EHLO mail.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406113AbhARRAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 12:00:11 -0500
Received: from mail.eaton.com (simtcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCBB9A4160;
        Mon, 18 Jan 2021 11:59:08 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1610989148;
        bh=50pzr3NvN1HqnbzNezMyFIC/UOWTZC8bu+LXS2XycGc=; h=From:To:Date;
        b=Xxsh41nuhujIobxjfpPBwahau2NMhCSA+I3j+7ZBhApt18LL3h3pHVOOjJcD/E+Bx
         bjjgFb7oL3ojrSfOOparl+uY8npBgq493bCDv6EwKbdV3e8zBka/HoXtsRMAatXidq
         p4IB06eR21kwgE3dOgQF1U2NGZELc5bEbYPN+V2byEmCy0KQVnXk8Ka0Ia4JKZMhnK
         O4vKA6W9G2/SESS7aa4BKuwpkEGo+8eWz7V91GD2AYm8PUVB66RBgeqWOsDJuCEZ/f
         mhNnQfavyl9KprC4Mk583UTtZUo1VOrgTz9RQ9oStZE1idBQsqqgKXcCyp3Ppghbx7
         NdFWU0DtEp/mQ==
Received: from mail.eaton.com (simtcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD0E8A40EB;
        Mon, 18 Jan 2021 11:59:08 -0500 (EST)
Received: from LOUTCSGWY03.napa.ad.etn.com (loutcsgwy03.napa.ad.etn.com [151.110.126.89])
        by mail.eaton.com (Postfix) with ESMTPS;
        Mon, 18 Jan 2021 11:59:08 -0500 (EST)
Received: from LOUTCSHUB03.napa.ad.etn.com (151.110.40.76) by
 LOUTCSGWY03.napa.ad.etn.com (151.110.126.89) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 18 Jan 2021 11:59:08 -0500
Received: from USLTCSEXHET01.NAPA.AD.ETN.COM (151.110.240.151) by
 LOUTCSHUB03.napa.ad.etn.com (151.110.40.76) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 18 Jan 2021 11:59:07 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 hybridmail.eaton.com (151.110.240.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Mon, 18 Jan 2021 11:58:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k/fZhWrQic2NuDsXIhi3fRB3YthN/WlSs5wi9Q2ojQOOXsNo7kcNnRqHDIqzmgjvC7vAfCxD6jIjFSR8YllGiEkisjY0LQQllvn7UwQcmdly66eFc6vtO6BoacXuarAtlFOZktma3Op006BfSy3++JmIvZdQs2OZcyaGrpRh3pp4iYpbOV/Ug4WyJFaX5e7zGd9oey6hXO4IfVpuEKPmmPHuM7vLNxgGIOZ2SQUOxco0fE+BpJGMYUy60wruk5VAenlEKM6AmOjB+ALWjMtb1BLfvagArzKmSiFODNkKRUEfKXbTto0wqpgQySmXE/YIlRGAWFdZZPIuzJIJm32NTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0vw1ky3cL40am8Sg3bzaeJwDR13AVD+F/8u3vYJcssA=;
 b=m/69Ygot0IezRSbA0Oopy6lESTUT5NhwTNnzwFGRWspL+/SfLATCLciC2bQ7JrbaeypTrnDSpEWd792uI7kNIF0oewB459FAevg6eILfdI35A4o9GRYDQzkIvnrtCs9iIuhA37GSY4qCYlT1ZI/Q94/3l3bRX2nqqKjffxAbI4FSGG/Qp3+LInd3LnhLN1Z2criIqYbPlCiz3z63ihn2TbRXtV4O7D2rAo9K3Yvh+zMwDTFGZBCE0t8VKM74MhBgRkV4c9C7gTCfsEV9TbhIVGShgOcJbDteftgVkHordEteiWa2suo1sqvo6LRDdol32qfEAeidNA20MNglgqWJyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0vw1ky3cL40am8Sg3bzaeJwDR13AVD+F/8u3vYJcssA=;
 b=BOGtTjA/y4mE1v7qKjrjhlGKP0GCg6ToauJiVQ7bO7V/ndjiJWRCnU367HbXKLencKsHb8TRcGkkLc2UbbemKIe/Z9Etunw4KUgdaocW/uvdW8u96cGnRgjpn5CZW4j4ivPS6PH4ZgvxElMptdTEMQlL5pxENd9ic2MCJ8WSt+0=
Received: from MW4PR17MB4243.namprd17.prod.outlook.com (2603:10b6:303:71::6)
 by MWHPR1701MB1743.namprd17.prod.outlook.com (2603:10b6:301:1b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Mon, 18 Jan
 2021 16:59:06 +0000
Received: from MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30]) by MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30%7]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 16:59:06 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "m.felsch@pengutronix.de" <m.felsch@pengutronix.de>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "marex@denx.de" <marex@denx.de>
Subject: [PATCH v4 net-next 2/5] net: phy: Hold SMSC LAN87xx in reset after
 probe
Thread-Topic: [PATCH v4 net-next 2/5] net: phy: Hold SMSC LAN87xx in reset
 after probe
Thread-Index: AdbtuznPVsTwlPJmR16Sc0oUUdSmEg==
Date:   Mon, 18 Jan 2021 16:59:06 +0000
Message-ID: <MW4PR17MB42434377E041B7B429002679DFA40@MW4PR17MB4243.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb658e68-712a-41c2-3628-08d8bbd25ddc
x-ms-traffictypediagnostic: MWHPR1701MB1743:
x-microsoft-antispam-prvs: <MWHPR1701MB174369106A85724D7BFFD137DFA40@MWHPR1701MB1743.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fcaeJAYTd2R5u67L2v8Adus6ikUwAhjZcLnWnfRVl9LmpOrTBRnxHU9zE0PdugQtx5b1LGsWAYr8G4H56ZuU/2+SnS/sll5ZM66TWiRmMFUoDADwi7te0E+3wyEdv+huS4YLXQpkDcfLPAV79Eqt36Ugx94FQuRrzlLtCdlV4kk6M3Y2ph2bSvTlX9tf6wzq8YD1tD3nueuwZ7tSW0kXXPP3GUte+5kX2fmdrWRpKsMHJp1OcON7n9bKdkQLs0kG17XqY1H/FHckXiiZ37Ahi370PcVwY7KC1gQJE4sVmQhiOeBqBixH74vIWfT1fBhU00xN7r8aU4AVwNaaHMjrlmZx1Cgxfr2FDOsv+8jjiXTgh+SKylAVcMTnHr4vWZbcgDxTGp5PmR+JwiwofNn5BYX74qWD+qJDWh/u+C6TDDWGtMldlzi+licF9U95sMrkZOAzyPmjX03TTauQk/iQAKvh3RN43C7aWx7b6rJioL8/KCIwdGvi/3DfXDYT9tvQIPQpUPa+TM9ZvpEFSR29BJU23ziyEF3jtDwd3Ir1G4isHPq6wVXOFJigQFOuS9b5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR17MB4243.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(376002)(346002)(396003)(52536014)(478600001)(26005)(83380400001)(76116006)(316002)(6506007)(7416002)(66946007)(8936002)(64756008)(66446008)(86362001)(110136005)(7696005)(66556008)(2906002)(33656002)(4744005)(55016002)(8676002)(5660300002)(71200400001)(921005)(186003)(66476007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?cYwQs7zigd0ndtQFHsYhjR5Rx0awpNqh8msBPnbQ0GpAqfCs2fu9KIaL/ifM?=
 =?us-ascii?Q?u9PmOn8HHQXg+730vPjqGGnP4G0Jy5B8ZPTIjoVUabbtNcevJMeSOIbSv2UW?=
 =?us-ascii?Q?v1ADyscdTSyX3KfLx6LpLfzajHXBsdfByRyme4JAAofPIqSuSuQ8t0Wj+tek?=
 =?us-ascii?Q?Kx/De8JSxlFCC1Mca6nGzohbjk9MkhP1Gb0sqR0kEVmi5/UqGjeyHvV3UW8R?=
 =?us-ascii?Q?KNlBKNbGXCzgZ946Yyjd2j8CT+eWTkSfpj7Sh8bvIv7TyWIsuzR9tEi1kdDU?=
 =?us-ascii?Q?kksh5PcWud1Z+NB+pnz65f9Uy/nm5m+0ZaxoKons/4OAuRt86C7Go+N78yQg?=
 =?us-ascii?Q?/0+AGUrWdR1JLOMitomVI3hJyvNw2RFBScM3pKpkewT+ZKROrV7II3YMr+up?=
 =?us-ascii?Q?6YgLMMfrBzIYlwLIxX71a51raRjhLQZLbHlDFdVLIP7h5fEHuWl8+AIJDEnu?=
 =?us-ascii?Q?JcGd5d3fXAWjp1VIwxzYdAE7yufVO8Q38mjpGW1y7khgByFBrjf1Oh3xSNAx?=
 =?us-ascii?Q?kX1Mq1De222QNCGxQKzzAn6qQjGR6U3cJq1arvwugFbyVUU1rPtB5UVNGxc4?=
 =?us-ascii?Q?i7IOE0WUA5Lud9Isnix9pgHQZbjpmtGjmNqyEwRfaYJknjo0o4FKp5SF9pds?=
 =?us-ascii?Q?41t+i1ocYA4RAL0RbFSKEBumEI5TjFOAvcIyP6AGO2k5afbRlK8Bdj7Jqbuk?=
 =?us-ascii?Q?sd7I0ohEXdEGraDvlaFkThhrt4ruYuqcB0NgDpMe1QtftMF/iFlu09gdOec9?=
 =?us-ascii?Q?1NAx79jcfufqqtIdQLhetnqEQjh8EPjuyCiANtPZLz/QKZrZtfxHlm9tJ+0g?=
 =?us-ascii?Q?aVAPcaa6Palykc/Xyex2dne9BNBpkIF7qrLFxs8ZBQw9ICOSaiLhSUrtYvTW?=
 =?us-ascii?Q?GVi87sd8mGfh1diOppYPgU/FP1zoWl0WD1bkJntWWPhfxeZitSoWDb5qZ4ZO?=
 =?us-ascii?Q?ENnLesWGyIr9A1ZHMDLTiAq2+ecXFXq3xet+bVei1wk=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR17MB4243.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb658e68-712a-41c2-3628-08d8bbd25ddc
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2021 16:59:06.4407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wY0in9Hod0LhabXsW+BYzzqkw7ZpMogjW68AxTh3c22+C4VGeM0sNtXTiJrw+rIqalwI8XPqs3DAk122r3ve0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1701MB1743
X-TM-SNTS-SMTP: DE6D9DE0C9D8760EDA636EEB9A7D654160CD0BEA871B6B5A44D07F538702B37C2002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25920.001
X-TM-AS-Result: No--0.010-7.0-31-10
X-imss-scan-details: No--0.010-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25920.001
X-TMASE-Result: 10--0.009700-10.000000
X-TMASE-MatchedRID: GHERv/ZpjLCYizZS4XBb39WxbZgaqhS0XGjQf7uckKvAJMh4mAwEG0/T
        IrLQ9Peu+PIDJm8nMt1aoQEg7IZiKbVdhtJxXnUIfJy8LojR0khLXPA26IG0hN9RlPzeVuQQhqJ
        xi9IzezKQ4SVxasmmgbBn8A2CciYo5UcZtwNsCrrQLWxBF9DMQcRB0bsfrpPInxMyeYT53Rlfao
        i0dn8goZ2FenkioMKX44eVa6C0ZL+WD7iOR/+e63W7afUcWEvSZTySX+fwtHmRFiPtO8NyA6YyO
        rYo4xNXNOHSYPHmjb3eloC7shIVXg6WpWKKS2rRYyaijWogO/2wdIS8KlDAH1Zca9RSYo/b
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFAssert PHY reset at the end of phy_probe(), for PHYs bearing the
PHY_RST_AFTER_PROBE flag. For FEC-based devices this ensures that PHYs are
always in reset or power-down whenever the REF_CLK is turned off.

Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
---
 drivers/net/phy/phy_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8447e56ba572..bbf794f0935a 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2926,7 +2926,7 @@ static int phy_probe(struct device *dev)
=20
 out:
 	/* Assert the reset signal */
-	if (err)
+	if (err || phydev->drv->flags & PHY_RST_AFTER_PROBE)
 		phy_device_reset(phydev, 1);
=20
 	mutex_unlock(&phydev->lock);
--=20
2.17.1



-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

