Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567A8485A55
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 21:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbiAEU5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 15:57:23 -0500
Received: from mail-db8eur05on2073.outbound.protection.outlook.com ([40.107.20.73]:16352
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231742AbiAEU5T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 15:57:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLm5kW2sG34343d0rRPA1uzTjNRssj8Byb+GOtabqlPcdbUrM9QaUAKqLyTagGvdswsXcfT2AkI/1FTKLlNbkbYyxoD3+KWGwHlImhGMJDChG/S573/+U0Ul58b6zv8RdAEJbaPhUd7U2PM4EM/1ylZvC9xhYq41p6d7DdsSz0r2BfADCVKNJn6S9Io1NJklfF5xTR91Y4EXX07oJ3FR78e41OKF9Zbxx5G5Rsb91cnTcDnGhZLLKYSZkpn13fZQbTisLNORwmKmcpZPVlLbQOIy5/tyIE/dx/oQk2wgUJDRn0O87PQKI90lVw/OG39qts2edbV+pBunHgjczXiZaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bbwa08gtwzEM+VNXhsO6XO8spozRmjPw8fst0aFLrf0=;
 b=atQtBI+J7xvdPHfycLlB2FC4WtxSNKrUo+D6TPPm4xTSmId0vwuERqJ/MWkNJOn7zsxM+koUn1IxwU0sv4gw0PgiKsNQA9uE43GSmlx4GVIUMgSwE59qvH+jtODMSRxw7Aa6fa0o2uwNkculuxmz+FYQ4ECO+oY2CwVTPk5OHqlnhigWFByz6bA/78+Rob6/VyfmmRobyy0PRG3XTlxP125lwDbDApCDGmUJJcLycSs1Aw7BYLIjx0trzydr+lG+hO7qYC1xZBGhrtq9uTfLXat66BKEwldCPr0ocDJhkmHB2cVvWRStT5O7hzffF2vt6mI97etsfYcYf671hHKarw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.73) smtp.rcpttodomain=gmail.com smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bbwa08gtwzEM+VNXhsO6XO8spozRmjPw8fst0aFLrf0=;
 b=Ol8Jcvj8MK/NtwpvC8Y+ExnuVrEF+YVyisqHvLbeRTq16f3lOq5OIbXar1WsNo9P6CEcUfKIlFeaeAwLo2z3K7BeWfihmSLcP6ykO5OSG8qtNF+KVvg0cXRKs1ACSwVvyCkAm5h1ngCKugBQ+vPtSAZpW6ACeo2olWkzRsSQ2nCrBczTZ8Bu+O/Gs4aodpwUqi3m5+HmAEgPf6n7L4ZDN4cOMIBgIGTVkULK+DZm3Bpr3jLyb3tL/bcVO4IQD3fprTbKfXX3N8P2XivDa17vGOAXepuqLomo2MlX34G1nk/B8gqVverLsmI7aaWkMZQBrQkcl0j16cWUcPE6w9Fr5w==
Received: from OL1P279CA0060.NORP279.PROD.OUTLOOK.COM (2603:10a6:e10:15::11)
 by VI1PR10MB3215.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:12f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 5 Jan
 2022 20:57:15 +0000
Received: from HE1EUR01FT004.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:e10:15:cafe::bd) by OL1P279CA0060.outlook.office365.com
 (2603:10a6:e10:15::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7 via Frontend
 Transport; Wed, 5 Jan 2022 20:57:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.73)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.73 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.73; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.73) by
 HE1EUR01FT004.mail.protection.outlook.com (10.152.1.233) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4867.7 via Frontend Transport; Wed, 5 Jan 2022 20:57:14 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SNA.ad011.siemens.net (194.138.21.73) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 21:57:13 +0100
Received: from md1za8fc.ad001.siemens.net (158.92.8.107) by
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 21:57:13 +0100
Date:   Wed, 5 Jan 2022 21:57:08 +0100
From:   Henning Schild <henning.schild@siemens.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Aaron Ma <aaron.ma@canonical.com>, <kuba@kernel.org>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <hayeswang@realtek.com>, <tiwai@suse.de>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        David Chen <david.chen7@dell.com>,
        "Mario Limonciello" <mario_limonciello@dell.com>
Subject: Re: [PATCH] net: usb: r8152: Check used MAC passthrough address
Message-ID: <20220105215708.056faa1f@md1za8fc.ad001.siemens.net>
In-Reply-To: <32b9e331-2c1d-6a7d-ca38-57cec50b240c@gmail.com>
References: <20220105061747.7104-1-aaron.ma@canonical.com>
        <20220105082355.79d44349@md1za8fc.ad001.siemens.net>
        <20220105083238.4278d331@md1za8fc.ad001.siemens.net>
        <e71f3dfd-5f17-6cdc-8f1b-9b5ad15ca793@canonical.com>
        <20220105085525.31873db2@md1za8fc.ad001.siemens.net>
        <fc72ca69-9043-dc46-6548-dbc3c4d40289@canonical.com>
        <20220105093218.283c9538@md1za8fc.ad001.siemens.net>
        <ba9f12b7-872f-8974-8865-9a2de539e09a@canonical.com>
        <32b9e331-2c1d-6a7d-ca38-57cec50b240c@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [158.92.8.107]
X-ClientProxiedBy: DEMCHDC8A1A.ad011.siemens.net (139.25.226.107) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7989b1a2-e9df-43e0-1e5c-08d9d08df3af
X-MS-TrafficTypeDiagnostic: VI1PR10MB3215:EE_
X-Microsoft-Antispam-PRVS: <VI1PR10MB3215FFC600C3E1B2C4E3172B854B9@VI1PR10MB3215.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9rsmjvyysTQZ5vRWVnWRFCIXYsTpdzNCy3qit6mKplB+P/s1EdOjr6ReX1GWSKfDI0Kj742eRhY4BrtMtKOtk00BAeFEyGhAnXYXeSuGwEte+QvENChVVS3baS2iHb1zwbJIFDFcdTXqnwneZ+2SQy2KvEQ8qDaVrOWDjJY+T1oxME08WQRhwF1DYZXXbkpUuZIYpRY5UTvqB0jm3nRgAaClGEoty045AER/SPS0VBr2kwEDfKcbrFfzvROL0NorpMsWCtiiUAkMEAXFH2EyZmWFG5ygCR6inCfo4Iwmv/f9l/fiWmFlEfP9GNx8FgGauXpF7Brq97iavqcmWAaZF+DZXZp/sZ8D/yzQAzQh8EnsUZF9wXYWXTrXuX2+UNaQcsXLZQVGMgJ/XsAVTNCLHKfrVZO/M8sKKpuPuZlJUGBP/ptEwYAfmepyW/ac4GUolCmp7nR5cDHVRKUNq8opurZLrjJaT1eTOB4S6Y/MgkJ4Dv31C0OHY+NqnPh8diSwZAB/geoHxVNFOk4rdXDebyDglZsImx9/jDzRlN1FElMjNH/1dGqBJPB253wqU0AVg7FhAzIBI738YLaYyWalnkguYTFLDfSYjMmT/MSmu1JemDCwy3epo83a3gFgYDzg2h0b5+FJrOzlH8y52qrvlqhwZcYvlwWP3xaf15MCuxb8WF2u8IYEjEwnJkjsosvFJ0tSnpB2fuTzR/rQd9wcjLta1IeeOQTDBoTDE10ncTWTLXUZ0MTbPWqBp8UkukycjC0sMZUXlt4EK1GXayRy6x+N6INZsVjyn5EcC7nQqC4=
X-Forefront-Antispam-Report: CIP:194.138.21.73;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(40470700002)(46966006)(54906003)(82960400001)(8936002)(70586007)(508600001)(4326008)(26005)(7416002)(2906002)(70206006)(186003)(6916009)(1076003)(83380400001)(16526019)(356005)(336012)(8676002)(81166007)(47076005)(5660300002)(86362001)(956004)(53546011)(82310400004)(36860700001)(40460700001)(55016003)(44832011)(9686003)(6666004)(316002)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 20:57:14.6160
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7989b1a2-e9df-43e0-1e5c-08d9d08df3af
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.73];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: HE1EUR01FT004.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB3215
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Wed, 5 Jan 2022 11:55:06 -0800
schrieb Florian Fainelli <f.fainelli@gmail.com>:

> On 1/5/22 12:37 AM, Aaron Ma wrote:
> >=20
> >=20
> > On 1/5/22 16:32, Henning Schild wrote: =20
> >> Am Wed, 5 Jan 2022 16:01:24 +0800
> >> schrieb Aaron Ma <aaron.ma@canonical.com>:
> >> =20
> >>> On 1/5/22 15:55, Henning Schild wrote: =20
> >>>> Am Wed, 5 Jan 2022 15:38:51 +0800
> >>>> schrieb Aaron Ma <aaron.ma@canonical.com>:
> >>>> =C2=A0=C2=A0 =20
> >>>>> On 1/5/22 15:32, Henning Schild wrote: =20
> >>>>>> Am Wed, 5 Jan 2022 08:23:55 +0100
> >>>>>> schrieb Henning Schild <henning.schild@siemens.com>:
> >>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =20
> >>>>>>> Hi Aaron,
> >>>>>>>
> >>>>>>> if this or something similar goes in, please add another
> >>>>>>> patch to remove the left-over defines.
> >>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0  =20
> >>>>>
> >>>>> Sure, I will do it.
> >>>>> =C2=A0 =20
> >>>>>>> Am Wed,=C2=A0 5 Jan 2022 14:17:47 +0800
> >>>>>>> schrieb Aaron Ma <aaron.ma@canonical.com>:
> >>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 =20
> >>>>>>>> When plugin multiple r8152 ethernet dongles to Lenovo Docks
> >>>>>>>> or USB hub, MAC passthrough address from BIOS should be
> >>>>>>>> checked if it had been used to avoid using on other dongles.
> >>>>>>>>
> >>>>>>>> Currently builtin r8152 on Dock still can't be identified.
> >>>>>>>> First detected r8152 will use the MAC passthrough address.
> >>>>>>>>
> >>>>>>>> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> >>>>>>>> ---
> >>>>>>>> =C2=A0=C2=A0=C2=A0 drivers/net/usb/r8152.c | 10 ++++++++++
> >>>>>>>> =C2=A0=C2=A0=C2=A0 1 file changed, 10 insertions(+)
> >>>>>>>>
> >>>>>>>> diff --git a/drivers/net/usb/r8152.c
> >>>>>>>> b/drivers/net/usb/r8152.c index f9877a3e83ac..77f11b3f847b
> >>>>>>>> 100644 --- a/drivers/net/usb/r8152.c
> >>>>>>>> +++ b/drivers/net/usb/r8152.c
> >>>>>>>> @@ -1605,6 +1605,7 @@ static int
> >>>>>>>> vendor_mac_passthru_addr_read(struct r8152 *tp, struct
> >>>>>>>> sockaddr *sa) char *mac_obj_name; acpi_object_type
> >>>>>>>> mac_obj_type; int mac_strlen;
> >>>>>>>> +=C2=A0=C2=A0=C2=A0 struct net_device *ndev;
> >>>>>>>> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (tp->lenovo_macpassthru) {
> >>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 mac_obj_name =3D "\\MACA";
> >>>>>>>> @@ -1662,6 +1663,15 @@ static int
> >>>>>>>> vendor_mac_passthru_addr_read(struct r8152 *tp, struct
> >>>>>>>> sockaddr *sa) ret =3D -EINVAL; goto amacout;
> >>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >>>>>>>> +=C2=A0=C2=A0=C2=A0 rcu_read_lock();
> >>>>>>>> +=C2=A0=C2=A0=C2=A0 for_each_netdev_rcu(&init_net, ndev) {
> >>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (strncmp(buf, nde=
v->dev_addr, 6) =3D=3D 0) {
> >>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 rcu_read_unlock();
> >>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 goto amacout; =20
> >>>>>>>
> >>>>>>> Since the original PCI netdev will always be there, that would
> >>>>>>> disable inheritance would it not?
> >>>>>>> I guess a strncmp(MODULE_NAME, info->driver,
> >>>>>>> strlen(MODULE_NAME)) is needed as well.
> >>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0  =20
> >>>>>
> >>>>> PCI ethernet could be a builtin one on dock since there will be
> >>>>> TBT4 dock. =20
> >>>>
> >>>> In my X280 there is a PCI device in the laptop, always there. And
> >>>> its MAC is the one found in ACPI. Did not try but i think for
> >>>> such devices there would never be inheritance even if one wanted
> >>>> and used a Lenovo dock that is supposed to do it.
> >>>> =C2=A0=C2=A0  =20
> >>>
> >>> There will more TBT4 docks in market, the new ethernet is just the
> >>> same as PCI device, connected by thunderbolt.
> >>>
> >>> For exmaple, connect a TBT4 dock which uses i225 pcie base
> >>> ethernet, then connect another TBT3 dock which uses r8152.
> >>> If skip PCI check, then i225 and r8152 will use the same MAC. =20
> >>
> >> In current 5.15 i have that sort of collision already. All r8152s
> >> will happily grab the MAC of the I219. In fact i have only ever
> >> seen it with one r8152 at a time but while the I219 was actively
> >> in use. While this patch will probably solve that, i bet it would
> >> defeat MAC pass-thru altogether. Even when turned on in the BIOS.
> >> Or does that iterator take "up"/"down" state into consideration?
> >> But even if, the I219 could become "up" any time later.
> >> =20
> >=20
> > No, that's different, I219 got MAC from their own space.
> > MAC passthrough got MAC from ACPI "\MACA".
> >  =20
> >> These collisions are simply bound to happen and probably very hard
> >> to avoid once you have set your mind on allowing pass-thru in the
> >> first place. Not sure whether that even has potential to disturb
> >> network equipment like switches.
> >> =20
> >=20
> > After check MAC address, it will be more safe. =20
>=20
> Sorry to just do a drive by review here, but why is passing through
> the MAC a kernel problem and not something that you punt to
> user-space entirely?

Agreed and several other people seem to feel the same way about
pass-thru not deserving a place in the kernel.

This all dates back to 34ee32c9a5696247be405bb0c21f3d1fc6cb5729
and some other patches that came later

9647722befbedcd6735e00655ffec392c05f0c56
c286909fe5458f69e533c845b757fd2c35064d26
8e29d23e28ee7fb995a00c1ca7e1a4caf5070b12
9c27369f4a1393452c17e8708c1b0beb8ac59501

Maybe other drivers are affected as well.

All of the patches should probably be reverted. If people care enough
they can try and get it into udev.

All patches put policy into the kernel, do weird ACPI lookups and cause
MAC conflicts with NICs that might be up and running. And will claim too
many r8512 devices in case there are multiple.

I propose to revert all of this or maybe add a module param (which
should probably default to "off") just to give people a way to preserve
their hacks.

If the BIOS did spoof we could try to keep that, but spoofing in the OS
(at least in the kernel) sound very wrong and caused me to start the
whole discussion after all my r8521 dongles all of a sudden had the
same (already busy) MAC when moving to v5.15. That was on a Lenovo
laptop but i am pretty sure Dell and HP would be affected as well.

When using another NIC you get another MAC, it is that simple. If that
causes issues with DHCP/PXE deal with it. A MAC does not id a machine,
maybe x509 radius does. Not a kernel story!

Henning
