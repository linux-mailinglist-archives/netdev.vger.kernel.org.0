Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5902F8247
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 18:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731856AbhAOR2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 12:28:04 -0500
Received: from mail2.eaton.com ([192.104.67.3]:10400 "EHLO mail2.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbhAOR2D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 12:28:03 -0500
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jan 2021 12:28:03 EST
Received: from mail2.eaton.com (simtcimsva04.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 810518C0CB;
        Fri, 15 Jan 2021 12:19:46 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1610731186;
        bh=QuYdqKG82rlVJgUlvqNS+ohVvr9/Hg3JrYkrZA9DJzE=; h=From:To:Date;
        b=QLiOHgJVCFxzfvlkQk805cWW8thEuc/Fd9GJnbQokWH9Hn3lEZxkGAax1+GWs1Scm
         81oZQ0hlZbopBylpbqj1dD+bu2p75UoeODaQCK+FEhm3BkayhJBeP0WQi4gT5SBvQu
         1TeBKVjTQ36/0TcYfJr2Z11JQyF93MRy6E17IscmSZEFq2tF9wVZKBTPVaVHk8/AoZ
         143v1KDr8i1/aB9dMtNUo9m1j8LkvHKDJHf9QzYOuom/bF09o351Dy6qDmScAkTSpI
         GJRmCanQHxl9Lger4ZUwMDtvGJcECiwK4fr2Fro1ULdJMEhmgMgu2q5bvhgKFuW+SF
         tdoH4Omcl6PoQ==
Received: from mail2.eaton.com (simtcimsva04.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 670768C089;
        Fri, 15 Jan 2021 12:19:46 -0500 (EST)
Received: from SIMTCSGWY03.napa.ad.etn.com (simtcsgwy03.napa.ad.etn.com [151.110.126.189])
        by mail2.eaton.com (Postfix) with ESMTPS;
        Fri, 15 Jan 2021 12:19:46 -0500 (EST)
Received: from SIMTCSHUB01.napa.ad.etn.com (151.110.40.174) by
 SIMTCSGWY03.napa.ad.etn.com (151.110.126.189) with Microsoft SMTP Server
 (TLS) id 14.3.487.0; Fri, 15 Jan 2021 12:19:45 -0500
Received: from USSTCSEXHET01.NAPA.AD.ETN.COM (151.110.240.153) by
 SIMTCSHUB01.napa.ad.etn.com (151.110.40.174) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 15 Jan 2021 12:19:45 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by hybridmail.eaton.com (151.110.240.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Fri, 15 Jan 2021 12:19:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BIm4xStNXyDF80rW8j9qaRR81SACXWBabwNa78qyYvDLm5idOaHdxSWaw+Z6DcWeCkPu0ZYiVeuXpUV5KFOXa/AqInv7fGa1+q3Oa68jxWb2kPmrp9/USThU0CE1sY0tLuNY2CftDRriOuTUbyOAGIAZaNb3B/51xFi2VhWBhtJIuAUELICfqawUP031gRvJ3XmRRxTwTTmODHB3TnxY9tUwt0FVpZ0R8quuZh4E2gzWF1xoWyG0C4yG+HiP2S610MCRUjqesSBycgSkodZk+BDrh+SkxWud4FdrLau0h7nxawI3bfQ+hH9uEyM7AaKHK33936PLsVSqCz669TxG7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YSdB6KxO6thCuMnVvjygJLgYrTq3Dt3H0ZrIB3Hg6ZM=;
 b=DXwlxLW6+vpIgcKhlc0krE9wsGOGVOZ9PekV9fVSSJ32Bw5kbgztZrwdUj51huzV66ruKPSh8S2f1ffh/foHSB60BN+GVF5FdDJh2uVIoFrgaQ9ME1rsuj0QtyXPiqdI/5i2ph7SOvjTlEqslkx4FUEQNUAQkKNazUqzTpFK/plW91C9hrSYuAcTujTXompSnViDLUSCo5ei2oQT+YTJ84uij4frGLN6wYSiB6dogI0eGeLs+UrbY4VCFxH2rHpuiSL38w0/KOS/9bZbPIRuxRXnkwhjJW2r2d2jJnZWD6JPdoVcOQrmVXzKY8uNKu8wPyM4OtuLlvnYfHg/fpEz1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YSdB6KxO6thCuMnVvjygJLgYrTq3Dt3H0ZrIB3Hg6ZM=;
 b=rZHxp8SKT+5c/Aa9DgHo/ac1P4RXtle8oWgeF1K1+z8wA1oigSVM23/tXnlKz/mOHbyHI9Md0snQwEipS3BihPkkMGaPbX7VmAAzN5+mD08jzEY0CSKG7/RTW2p0yT4D/B2ihbvv8hQy9wTR2G3p+k+h6xIyWFLZfU3d+P1Jngo=
Received: from MW4PR17MB4243.namprd17.prod.outlook.com (2603:10b6:303:71::6)
 by MWHPR17MB0991.namprd17.prod.outlook.com (2603:10b6:300:9e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Fri, 15 Jan
 2021 17:19:42 +0000
Received: from MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30]) by MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30%7]) with mapi id 15.20.3763.012; Fri, 15 Jan 2021
 17:19:40 +0000
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
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "marex@denx.de" <marex@denx.de>
Subject: Subject: [PATCH v3 net-next 0/4] net:phy: Fix LAN87xx external reset
Thread-Topic: Subject: [PATCH v3 net-next 0/4] net:phy: Fix LAN87xx external
 reset
Thread-Index: AdbrYlJ9lIFRoNXFQCGzpMmC2Op2Pg==
Date:   Fri, 15 Jan 2021 17:19:40 +0000
Message-ID: <MW4PR17MB4243A17EE8C434AE3DCAEAF4DFA70@MW4PR17MB4243.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a1ca0e8-9b70-46a5-88a1-08d8b979be31
x-ms-traffictypediagnostic: MWHPR17MB0991:
x-microsoft-antispam-prvs: <MWHPR17MB0991546AE91A92C3DB26E79EDFA70@MWHPR17MB0991.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A4S3JXFGvibS/ASAImEIi2zlMsJ+fuTFod51eCDa7ymfghCOcDOVG7gU8L1riBJwlYqPzHiAk9w9B8kBb10krxFyNQzGyBuOrbb2xWG865KGsvs/O0OKxar/VM+wvP1cWYrLN0NQ9ETdep8jfrRSRmIDR8MGLEU5Tmn4e5j31+lrVw4Uk9Im09x5LX7QvuGFcqtjFmFn4K1jKPzpaKDj4EqOUrPUpvw4XOLnP35gvvOrKbLauWE8mGdWPY2A9ZDmaXjdPyBJbaoAEBONj+lMrjib+Yu0R3W29iOTmQ8yrxP5Nsh14uflhsDgP5pbHDoniD2H/prAHkwucvSeE3iQep7hoO+Ttc/+bPFJX3HGdpLfs8Ig2UrQ+Y6WUE8/CC5SVUSLJjGIxak5J3Rz5iOyf9PTMQ6QSjcEL992EB1pbQeATp8bRnbUNevcPRB4g1QR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR17MB4243.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(346002)(136003)(39860400002)(76116006)(478600001)(86362001)(66556008)(64756008)(66476007)(66946007)(55016002)(66446008)(5660300002)(7416002)(110136005)(9686003)(2906002)(83380400001)(7696005)(316002)(33656002)(52536014)(921005)(26005)(8936002)(186003)(71200400001)(8676002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?hJ5JafAkZCbg7quxae1vcL+SncDj8NDIf4suKDbooGi9onoOTyrLRFV53p8j?=
 =?us-ascii?Q?ucqtr37rpm1nNglr2LdelXh/PcNMvRoqJZWfCTp6+PqiIGLHeNDKwmZQ7wcE?=
 =?us-ascii?Q?7XRBLVBbrstHZtT5JZ+DrnnIUHoZZJSw5QfoOtdNX9lICJ0rr5Dc9IJ1xJqz?=
 =?us-ascii?Q?ecKddAVkZTMTNl1n1FxTdwsAvop6psQSx5IGDKwjrtoe0w+k39s0Eor8ehJv?=
 =?us-ascii?Q?S+TNN2awNqqix39He/vgP+wGIUiOC3hHqmbWCc8d8vB/N3w6KP0ZUUb9fGZE?=
 =?us-ascii?Q?0m9XSya2GZXLlGsq4BD6v86GAphxeC71WbtNC4GwLKWuXiHAd/1EQZTt3Cgp?=
 =?us-ascii?Q?GqiqZZ+0RK00LxM6nq/f7uCG8YyOAfbso9mGO/MVJ2qw54iM7sTlXhdj7u13?=
 =?us-ascii?Q?iJhfAIy2ix+2bvndlBfzeHaX6/ycmSqmXwnrhTb2EeQM1ckcJx1Xt3JiJIbF?=
 =?us-ascii?Q?BDIK+l2f7ONx6wHOKTT1SxZQiH52c5sQQGOWFE9X547A2oosWPMq5m8UKk1x?=
 =?us-ascii?Q?ky4D2bCrL6jpbxSUidSkG64+wglH2JuuYJFzbVwi7CBtv2WuRmXbSOPwcIGf?=
 =?us-ascii?Q?GfOY3bwbj5PSfDHM2txmXc4XbCF7BG7oX878myYRnh392iTDX+/jRnoAWG1G?=
 =?us-ascii?Q?7SxgEQ0zVo46TrmG9GUztGMTeGC2Jxpu2Eyhq8MV97ziyHk28H6WClc+UJCb?=
 =?us-ascii?Q?+Qn9ZBg7rC1W7ezFSXZgvEfdmFoTjmjnH2pF3x4zLoxVu1z3jLkER+zxsQHd?=
 =?us-ascii?Q?mIhx/YW78Rp1xWPDZcsJRPkZuDf9VB1bgcLXjBdP3baven77wvdGeconjcLS?=
 =?us-ascii?Q?h/uck6YMawDd2Qo5xypqtSaLnDlQ73ME0Xv8BA7aRlFQO9ZNljyzWdKQP3rN?=
 =?us-ascii?Q?H+Dg2s5DxLwdF/IrtjX3ME5qMoRgd9/bpGMmU1+PC2y+Fzzhf1RUV0E9ky3a?=
 =?us-ascii?Q?kpJZzAaP/K4b/HFDdiQCv8I0uhSU3kOWVNJfGEJ6Rus=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR17MB4243.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a1ca0e8-9b70-46a5-88a1-08d8b979be31
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2021 17:19:40.4839
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 01cEqxXeidv6HcAbH6g9ooO3AaH7e50c3zkljHWLSjBTvd54gfstQGNssIQlY/5j5yNTzhdQxQ2fzfHustbdog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR17MB0991
X-TM-SNTS-SMTP: 8563DF15C57AA2B0A6F8022B56B740374498CE455BDFABF4347CA2168673FB012002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25914.001
X-TM-AS-Result: No-2.019-7.0-31-10
X-imss-scan-details: No-2.019-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25914.001
X-TMASE-Result: 10-2.019100-10.000000
X-TMASE-MatchedRID: GNFHl0IKSqmYizZS4XBb34vqrlGw2G/kMI2NtA9qrmIda1Vk3RqxOAnf
        5JZh+MGVW9oUHABU5913bK+a09DXi8J9YYPRw7TqIwk7p1qp3JZITFAcgVBxK+ZAlRR6AIJ7pTM
        fRy1HRznLaFXAfbtwNor2Q2H10K5KtPeV72UUGU8JaVZHbbd1ri9eSYpU2Ct+IZ5kqZm//eWQLC
        DnKuiAgedRkWB60/F/D5rpUQLVm0FmdUzfNFdOwUhSUqTPfB+ZOHhqIXe4IzasHCH3SeE3CcxAw
        z/u+fT4d9m/hd4OMhirqJHnxm19ii8e+PWnrZW8j0drvddoWERqYquCrLrVwgAheUymmndf1Kk3
        WJawO3GmsbPDvBTBpnip4VRjaN9bmDp+HsqIdAh08zy97KsgJqm9/6ObPjnD4wPKnwkMVn1Sj90
        2t3M5P4oLmLF/tZ7GkRqZRu8iKdN0YtjF30CyAk95wQijrwBLJAiIU8AC7ozyf40vOg6Tw1N0uD
        yypm5V9XJZEbpTIOwfUYgX+mnChzfa6I248QZMLGDmqzfHOB/2X2nyY2WSCcAkyHiYDAQbblsbM
        XlEtupH0m/3viEjzKsYZXSBnFHJcExcPM4F1gLY8CtSlWSg/JpnDiJt8Xy4fmBSyEqHyB+1EqVe
        Qo7DiZkMh5BGOrxiOnwr3a5BMV8LEx+quc3j9y8s/ULwMh46lhpPdwv1Z0prvf5eVgMu7NGVQrn
        ZJqIeMqqNAwlLCF1eZyq6655uiHpYutjENC/lEhGH3CRdKUVMtkHpT9ho+qFjroW+ne0h6BSsoH
        Gi6wXbpsq+MnNpYyMAqEP8MqAnHLucZD5uGderm7DrUlmNkL6hIaKfExp0wrbXMGDYqV+FR9Hau
        8GO7nSz6XreSIanJSuHNdI7iyNJnzbCPPcBumGZuNsRpJ7ZTPoWsi97tUbGIcPohCqo+UnltO8Q
        hfg4MVfXaIKKzLGk98YZFvIVLBEzdh3D4mdtLr3kj3gYm08HH3J2uF6L8XQWaIbnjyDJVkIsYwV
        z6UgRzIoVBoe7FWcjFnImzvyS
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFDescription:=20
External PHY reset from the FEC driver was introduced in commit [1] to=20
mitigate an issue with iMX SoCs and LAN87xx PHYs. The issue occurs=20
because the FEC driver turns off the reference clock for power saving=20
reasons [2], which doesn't work out well with LAN87xx PHYs which require=20
a running REF_CLK during the power-up sequence. As a result, the PHYs=20
occasionnally (and unpredictably) fail to establish a stable link and
require a hardware reset to work reliably.

As previously noted [3] the solution in [1] integrates poorly with the
PHY abstraction layer, and it also performs many unnecessary resets. This
patch series suggests a simpler solution to this problem, namely to hold
the PHY in reset during the time between the PHY driver probe and the first
opening of the FEC driver.

To illustrate why this is sufficient, below is a representation of the PHY
RST and REF_CLK status at relevant time points (note that RST signal is
active-low for LAN8710/20):

 1. During system boot when the PHY is probed:
 RST    111111111111111111111000001111111111111
 CLK    000011111111111111111111111111111000000
 REF_CLK is enabled during fec_probe(), and there is a short reset pulse
 due to mdiobus_register_gpiod() which calls gpiod_get_optional() with
 the GPIOD_OUT_LOW which sets the initial value to 0. The reset is
 de-asserted by phy_device_register() shortly after.  After that, the PHY
 runs without clock until the FEC is opened, which causes issues.

 2. At first opening of the FEC:
 RST    111111111111111111111111111100000111111
 CLK    000000000011111111111111111111111111111
 After REF_CLK is enabled, phy_reset_after_clk_enable() causes a
 short reset pulse. Reset is needed here because the PHY was running=20
 without clock before.=20
  =20
 3. At closing of the FEC driver:
 RST    111110000000000000000000000000000000000                =20
 CLK    111111111111000000000000000000000000000
 FEC first disconnects the PHY, which asserts the reset, and then=20
 disables the clock.
  =20
 4. At subsequent openings of the FEC:
 RST    000000000000000011111111111110000011111                 =20
 CLK    000000000011111111111111111111111111111
 FEC first enables the clock, then connects to the PHY which releases=20
 the reset. Here the second reset pulse (phy_reset_after_clk_enable())=20
 is unnecessary, because REF_CLK is already running when the reset is=20
 first deasserted.=20
 =20
This illustrates that the only place where the extra reset pulse is=20
actually needed, is at the first opening of the FEC driver, and the reason
it is needed in the first place, is because the PHY has been running=20
without clock after it was probed.=20

Extensive testing with LAN8720 confirmed that the REF_CLK can be disabled
without problems as long as the PHY is either in reset or in power-down=20
mode (which is relevant for suspend-to-ram as well). Therefore, instead=20
of relying on extra calls to phy_reset_after_clk_enable(), the issue=20
addressed by commit [1] can be simply fixed by keeping the PHY in reset=20
when exiting from phy_probe(). In this way the PHY will always be in reset
or power-down whenever the REF_CLK is turned off.

This should not cause issues, since as per the PAL documentation any=20
driver that has business with the PHY should at least call phy_attach(),=20
which will deassert the reset in due time. Therefore this fix probably=20
works equally well for any PHY, but out of caution the patch uses the=20
existing PHY_RST_AFTER_CLK_EN driver flag (which it renames), to implement
the fix only for LAN8710/20/40 PHYs.

Previous versions:
This is the 3rd version of the series;  below is a short description of
the previous versions.

v1:=20
The solution in [1] has the unfortunate side-effect of breaking the PHY=20
interrupt system due to the hardware reset erasing the interrupt mask of
the PHY. Patch series v1 suggested performing the extra reset before the=20
PHY is configured, by moving the call to phy_reset_after_clk_enable() from
the FEC into phy_init_hw() instead. The patch was re-examinated after=20
finding an issue during resume from suspend, where the PHY also seemed to
require a hardware reset to work properly.=20
Further investigation showed that this is in fact due to another
peculiarity of the LAN87xx, which also erase their interrupt mask upon=20
software reset (which is done by phy_init_hw() on resuming from=20
suspend-to-ram), and is thus a separate issue that will be addressed in=20
a separate patch.=20

v2:
During this time the kernel had moved on and 2 new commits rendered the v1
fix unnecessary:=20
  [3] allows the extra PHY reset to still be performed from the FEC, but=20
  before the interrupt mask is configured, thereby fixing the above=20
  interrupt mask issue.
  [4] allows LAN87xx to take control of the REF_CLK directly, preventing
  the FEC from disabling it and thus circumventing the entire REF_CLK=20
  issue.
Patch v2 proposed to fix 2 potential issues with the solution from [4],=20
namely that (i) failing to set the PHY "clocks" DT property would silently=
=20
break the system (because FEC succeeds in disabling the REF_CLK, yet the=20
extra reset has been removed), and (ii) keeping the REF_CLK enabled
defeated the power-saving purpose of commit [2].

The present patch fixes (i), and leaves it up to the user to use the=20
power-friendly clock management of [2] (leave the DT clocks property=20
unset), or keep the REF_CLK always enabled (set the clocks property).=20
It also simplifies the code by removing all calls to=20
phy_reset_after_clk_enable() and related code, and the function
phy_reset_after_clk_enable() altogether. =20

Tests: against net-next (5.11-rc3) with LAN8720 and LAN8742 and iMX283=20
SoC. Unfortunately unable to test LAN8740 which has a different form=20
factor.

References:
[1] commit 1b0a83ac04e3 ("net: fec: add phy_reset_after_clk_enable()
    support")
[2] commit e8fcfcd5684a ("net: fec: optimize the clock management to save
    power")
[3] commit 64a632da538a ("net: fec: Fix phy_device lookup for=20
    phy_reset_after_clk_enable()")
[4] commit bedd8d78aba3 ("net: phy: smsc: LAN8710/20: add phy refclk in
    support")

Laurent Badel (4):
  Remove PHY reset in fec_main.c
  Remove phy_reset_after_clk_enable()
  Rename PHY_RST_AFTER_CLK_EN to PHY_RST_AFTER_PROBE
  Add PHY reset after probe for PHYs with PHY_RST_AFTER_PROBE flag=20

 drivers/net/ethernet/freescale/fec_main.c | 40 -----------------------
 drivers/net/phy/phy_device.c              | 26 +--------------
 drivers/net/phy/smsc.c                    |  4 +--
 include/linux/phy.h                       |  3 +-
 4 files changed, 4 insertions(+), 69 deletions(-)

--=20
2.17.1



-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

