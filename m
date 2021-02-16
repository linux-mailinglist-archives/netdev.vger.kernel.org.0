Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411CC31D285
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 23:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhBPWPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 17:15:13 -0500
Received: from mail-eopbgr1400123.outbound.protection.outlook.com ([40.107.140.123]:46624
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230388AbhBPWPL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 17:15:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y70LkNHZnT2W1cX6YHG1RbrzRLWCwjYdD2YVIgEUFV+4ufv4l2dGqUe9bPkV+O8NnJq/TdtYoiMLRrI/jogNHbqyC/1/xd+FKn2SrOcmi0Pn1E4HYqufd0lds7bO/aCOw+MxDopxpvfkUJA3pG07+Pp5pDqfRG5rq8v0/JNIVmNXJk877dXI1enmSC6NmPpzUd43NR6rhEqRZXx824Gtn0gAI+mZqhYHsayoZaSm57BuW4GXIIFRJU3GoBIcShvWaHTOIFht64aqoM4Qxc9xlfNraoMVIjgazxRRZX8QncNsLj8t8Vs6pclb4iERYQ5jgFy+5WjqDzB3IpPv+WiQ3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yb3NgE+rBLk6tEIIhb0XAsbnaXLkd8goU64f1D4tz2Y=;
 b=a1yzVNuO6yLcjbK8zUhexLuaPfQbHchO1khtoTf1Cy2DMI3f6G5n6fwFN395htIbI5KoptVDt4gyrpqHctfFMl8TD6vlsmWeXxGIkpYR7Xe2rBQYeNXAqsdNvHd4AXPzGxaY9P/JvQKBehRJmUiFnMsVmTumYBryl0MQ5nM+CDp+Jp0tHLHf6IPmkG413pD/mCd4vyDNnHvcYleD94H066+E2aOBjL3rHl74/85+ToTFpG8bsRVCRd/MYEdb/JTAriTSgmDK9unX1adgpUkvJsIOhxj4ugNHCQAaLsfvKzGC9ooTsLh3Dc8u7DP0eicT1na4/C/quN2hjg3bd9NgkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yb3NgE+rBLk6tEIIhb0XAsbnaXLkd8goU64f1D4tz2Y=;
 b=FYNzetjLkYVTWcMoZ9u0ZrscEaiJyQIqPDrVKbsBSQD4nBJLwwGRSFmN2orEdYpn0xhxEI8wQEsTAnJw4wy0tROGGTKEJ1n1Okml2GQrbFFdPWSNr1SiabqOTBrI7MNSg/QXhlA0z+LOUlsxyWJLEEaca3SQH7VbLnty/wce/b8=
Received: from OSBPR01MB4773.jpnprd01.prod.outlook.com (2603:1096:604:7a::23)
 by OSZPR01MB6454.jpnprd01.prod.outlook.com (2603:1096:604:f6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Tue, 16 Feb
 2021 22:14:21 +0000
Received: from OSBPR01MB4773.jpnprd01.prod.outlook.com
 ([fe80::1971:336c:e4c0:8c5]) by OSBPR01MB4773.jpnprd01.prod.outlook.com
 ([fe80::1971:336c:e4c0:8c5%3]) with mapi id 15.20.3846.038; Tue, 16 Feb 2021
 22:14:21 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Arnd Bergmann <arnd@kernel.org>
CC:     Derek Kiernan <derek.kiernan@xilinx.com>,
        Dragan Cvetic <dragan.cvetic@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        gregkh <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: RE: [PATCH net-next] misc: Add Renesas Synchronization Management
 Unit (SMU) support
Thread-Topic: [PATCH net-next] misc: Add Renesas Synchronization Management
 Unit (SMU) support
Thread-Index: AQHXACKOoFb+ofRp20OhBYk2S05d7KpS86SAgADGlHCAAIcoAIAAassggABEPICABhmmwIAAPsuAgAAOzaA=
Date:   Tue, 16 Feb 2021 22:14:21 +0000
Message-ID: <OSBPR01MB47739CBDE12E1F3A19649772BA879@OSBPR01MB4773.jpnprd01.prod.outlook.com>
References: <1613012611-8489-1-git-send-email-min.li.xe@renesas.com>
 <CAK8P3a3YhAGEfrvmi4YhhnG_3uWZuQi0ChS=0Cu9c4XCf5oGdw@mail.gmail.com>
 <OSBPR01MB47732017A97D5C911C4528F0BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2KDO4HutsXNJzjmRJTvW1QW4Kt8H7U53_QqpmgvZtd3A@mail.gmail.com>
 <OSBPR01MB4773B22EA094A362DD807F83BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a3k5dAF=X3_NrYAAp5gPJ_uvF3XfmC4rKz0oGTrGRriCw@mail.gmail.com>
 <OSBPR01MB47732AFC03DA8A0DDF626706BA879@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2TeeLfsTNkZPnC3YowdOS=bFM5yYj58crP6F5U9Y_r-Q@mail.gmail.com>
In-Reply-To: <CAK8P3a2TeeLfsTNkZPnC3YowdOS=bFM5yYj58crP6F5U9Y_r-Q@mail.gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [72.140.114.230]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 70b34209-bc6f-487b-901d-08d8d2c83629
x-ms-traffictypediagnostic: OSZPR01MB6454:
x-microsoft-antispam-prvs: <OSZPR01MB6454806595476BD876D28FC5BA879@OSZPR01MB6454.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pnohn18n6U46sY1E3s46ykmk1lgkuezC9B//6zfyV5oYsxGfTyW88z39Ap6qdil4o8AuWsaLMB5KeRnguFk9bJmX0uG287Ag9O5L1aRqylaQ0kySRWMtVL0EnyeWF5F71KA8S1fMHEAe3uCsWd1C8usxSgfBSEhPEwfBWv0SV3tta5N1IHnPtiM3z+Xv5Qnlfk4EHt7oxc16AwpnULo3l9OlKv3Dg850JcEH2lHXT+T3B6qsmHlUFSD1FKTVOsrYgdlQrBKOn4ZUh7yqCw/GO1zZH9XLOihA9bIDYzLXqhCFhn6Z/467NaDtxLcgj/KRbaOfaTE+nyau2rOLU6AyrzcTqppZDS/NaazdKKbcyqSVxms5lpbTuL5QngKVh3bMK+tePBJg8Wq3m4B8Ck1xrktgy/ThMaXH/n8WENzkO9j8ml322rdkQwCQig/G4E3UpiL5IFNZSmVpBWEphx4GBDGWKYkyxwwyXhVhhcQ923lc+CG0lspghiCB8sx31QoqYN5/OuC2aumBobZ4yF9rJY7LhN4+5Bmy7PTZDUZaxzwmT5PeKuvo0FN8ZOfgygorz+lAQn4ZVl0hN+pJMCv6wYMkwyEeFNcY7pGeFqFVruA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSBPR01MB4773.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(376002)(366004)(6506007)(26005)(8676002)(186003)(966005)(33656002)(2906002)(4326008)(55016002)(478600001)(66556008)(9686003)(54906003)(66946007)(5660300002)(66446008)(316002)(64756008)(86362001)(71200400001)(83380400001)(52536014)(8936002)(6916009)(76116006)(7696005)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?FxCaVoK53lLPOQmPcKWS/t9Ja12N2Ulpx2WrjPwqYBm6CoLZ8hBjpsEldfE2?=
 =?us-ascii?Q?xZGj7KycacHl+DR0tSOvidIENuFUyhPV4A3fhk86/sUKqfwatQnd6HMQaYfV?=
 =?us-ascii?Q?rgo4mfexr6ycfrYQFQ/B5RWa48sRzhMLhmdHtk3cKKWL6ZpNNXihlYvtb1d/?=
 =?us-ascii?Q?jqqh+t8KnvPIOzczurCN8l/SOOrl8pNqcLkpCobHujW7/m8RwdhPKI/jRTMZ?=
 =?us-ascii?Q?8BHcz0bgRYqDKqqQmFeoLw3dQ67Krnz/3jLrBeD2J8s/rbeogJ5oc8+07AKJ?=
 =?us-ascii?Q?mCp3pezZWYXMiUn7B1f5PZfTo/FKFtunrYeweCCj91wY0n4KE4XFTFJ1jcFH?=
 =?us-ascii?Q?TU+c/gwgOI2ij/YA/mnP/IyhzY+ILzkqeJPeK9v1KCw/jriONm7AiFK/tNK0?=
 =?us-ascii?Q?2NH0c0xf9CZ6ne49BDG8EF1rHyBC9WDlVsjwDceDiUCS1V+s4BAgYHQP8PAv?=
 =?us-ascii?Q?A/zidkPlCanwJHsOrMBaE1IVuksIlBXTyBsmhGRQ+bXYu3CvRqvcfsVWnwI+?=
 =?us-ascii?Q?8t0BJ4047oWVtgM/VgFVX/Uen3lZyLD10I0fxaNtIn5BNqb5iwk94Ddgc8rL?=
 =?us-ascii?Q?dJDlnsFM23l3t+i36ZzY+OTTkbM8IH3q81KUr/TQG3boKF75qAxF5WNzDXHo?=
 =?us-ascii?Q?j9lMYbR1CNG49r5kiDuoP0NihuxtLbMuBnIzkeCcxR5qfx0YBK+bDQ7Krd6x?=
 =?us-ascii?Q?HOKQCEH035TfUoweH8G/UmJFSRYxmnbZBnWFaH2NFxwRdyhvPGZQq37qdfwh?=
 =?us-ascii?Q?OVw2KuFUIuX9QAEw7y+A1D2A0cvoPgCYIR0vYfhVUO1nq7NkoyDE2NtPsQwC?=
 =?us-ascii?Q?94OEEv0LrW7Wju+YAoXxbgbFhusHOg2N5qv6Gj//OwW+QMz3o6YcSEFHIawI?=
 =?us-ascii?Q?XcLa1hiBQXCxbh4d1DRfrNPgnaexUxmyaEeZnaHDlHKgMHZMxk86MIlUjz5q?=
 =?us-ascii?Q?4LVhT2KvgBiGc9ntMFroP/22L+x3NDksk9n+edhSVBl5/zbI0GGo87q003T0?=
 =?us-ascii?Q?T+167ULNGp5yumeJarpJhuLrNjZdX6+/44GBwuYsZ+9XQ2wzDkbKiZE32/Df?=
 =?us-ascii?Q?DFNctwosS2r3tLceLOwMg+txc/6wgWCx2UmP1Pt1s3qMDMD/9zTeF7/R6CyQ?=
 =?us-ascii?Q?YYTv5sguwVE1hQvUhdAJtdOvW3uuTvzVKCIJw37NLsu9OUGHSSasFLvvlCZA?=
 =?us-ascii?Q?kTytN07EatssBooMcZngpIig7/BPtiz3DS4D37aaI6T1WQYMlzVHScKf18ra?=
 =?us-ascii?Q?WsgzXbdM9+HncF0VdOd/xMYHvxb9QwS+AGipiCrS7MRaT7yMPjMzjCKeQkaQ?=
 =?us-ascii?Q?0utMoG1E0S0aoad8IcysLeqY?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB4773.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70b34209-bc6f-487b-901d-08d8d2c83629
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2021 22:14:21.4682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: opQ9d2sN1qe70I9pI0Cxpj0kMVPGr84GkrrHYMWP6Mu5+83z42Pkgu4TrqdqttmQ88SfEXQM5i7HGdMjomHnEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB6454
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
> I can't help but think you are evading my question I asked. If there is n=
o
> specific action that this pcm4l tool needs to perform, then I'd think we
> should better not provide any interface for it at all.
>=20
> I also found a reference to only closed source software at
> https://www.renesas.com/us/en/software-tool/ptp-clock-manager-linux
> We don't add low-level interfaces to the kernel that are only usable by
> closed-source software.
>=20
> Once you are able to describe the requirements for what pcm4l actually
> needs from the hardware, we can start discussing what a high-level
> interface would look like that can be used to replace the your current
> interface, in a way that would work across vendors and with both pcm4l an=
d
> open-source tools that do the same job.
>=20
>       Arnd

Hi Arnd

This driver is used by pcm4l to access functionalities that cannot be acces=
sed through PHC(ptp hardware clock) interface.

All these functions are kind of specific to Renesas SMU device and I have n=
ever heard other devices offering similar functions

The 3 functions currently provided are (more to be added in the future)

- set combomode

In Telecom Boundary Clock (T-BC) and Telecom Time Slave Clock (T-TSC) appli=
cations per ITU-T G.8275.2, two DPLLs can be used:
one DPLL is configured as a DCO to synthesize PTP clocks, and the other DPL=
L is configured as an EEC(Ethernet Equipment Clock)
to generate physical layer clocks. Combo mode provides physical layer frequ=
ency support from the EEC/SEC to the PTP clock.

- read DPLL's FFO

Read fractional frequency offset (FFO) from a DPLL.=20

For a DPLL channel, a Frequency Control Word (FCW) is used to adjust the fr=
equency output of the DCO. A positive value will
increase the output frequency and a negative one will decrease the output f=
requency.

This function will read FCW first and convert it to FFO.

-read DPLL's state

The DPLLs support four primary operating modes: Free-Run, Locked, Holdover,=
 and DCO. In Free-Run mode the DPLLs synthesize
clocks based on the system clock alone. In Locked mode the DPLLs filter ref=
erence clock jitter with the selected bandwidth. Additionally
in Locked mode, the long-term output frequency accuracy is the same as the =
long-term frequency accuracy of the selected input
reference. In Holdover mode, the DPLL uses frequency data acquired while in=
 Locked mode to generate accurate frequencies when input
references are not available. In DCO mode, the DPLL control loop is opened =
and the DCO can be controlled by a PTP clock recovery
servo running on an external processor to synthesize PTP clocks.

Again, at the bottom, these function are just reading/writing certain regis=
ters through I2C/SPI interface.

I am making this driver to support pcm4l since my my company, Renesas, want=
s to abstract hw details into the kernel. But I can not figure out
how to make this universally applied interface and I find misc is the best =
place to hold driver like this. On the other hand, if you have better ideas=
,
I am all ears.

Min



