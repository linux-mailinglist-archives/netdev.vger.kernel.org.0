Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3D748CBC9
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 20:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350140AbiALTW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 14:22:26 -0500
Received: from mail-db8eur05on2043.outbound.protection.outlook.com ([40.107.20.43]:41344
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1350102AbiALTVa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 14:21:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jlguny1MOIPL6+/nEp5OeTipK855uG7fMtKxjInX9hPh/rSCbRu6Wky76eJWjGYKEjNMZxmCMrRFX1GtGu35O9/qJytUFkr5KSq9pLHDox9eVsfS9R4ejoRk/IuGT3mJ9GnsmzLzqb8+cjMbkOJhmCX6oxLtBEZ+HFz3h+NKEQ1Jy5JhgfTc9RE1nwpS1RCw5ZV+fYbhsJUzhvzJ4Gp8a4IxiOo9sssLGGIt+ZvTybzJoZwdHoxAisdJFQksVTYGGfaDIkzzyF35yQ+/Wx8kueOOC5yBQI9jTtIVmSrHkiI7PJ61ibkzCxCjP+vSRyFOeQ1pfMuW2oX2NaVm1fMXLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XnXZryA7vjdtBliDDwM17Lzqyir3ShnwaU2ghrtl2GI=;
 b=LK5ImcE68yEFoUNIKcHxVEU8VtfioL32UvqVP0KIr7dkpHmhVE+G/BkgEnCLAAyKwNNVg/VyI/d9HdWsgnE+xFW1A0/KJBiUWOMrubKFwrj3dxXoqh1FFTeqaIjZbIR3AdpCamzL8swaOzPmqtV/kOVlEp7DoXyIBrSuaJlCrI7C3B5YpGi/v0/GGh8yrUXwdvvPoZWAEDMr9C7PAjZkiWLzBuZF8zofIAo5jCojcxdRcahzFguC5eNMj6kmz6z2npltxIBLTWaa0JYtYzHQUBscp7Mqgby5a/csbctE/Ei8jQPpzmiqNAQh/GipuRTBqJzQKLCi2eiKzlrIQ/wGxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.72) smtp.rcpttodomain=amd.com smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XnXZryA7vjdtBliDDwM17Lzqyir3ShnwaU2ghrtl2GI=;
 b=pjTxna1fTK0vOFRF+i2P9lWGxfSWFyIkGOnGJfvrqaPco63NgNsxq2rKT8GAcaL2x3DUDcCRoADgURrdLbI1A10C+0y5ckuV7C+H2d8OH97S8bvZhRopSPgkT3Pg/YX2VXw9eG8zdcQzlw0oRJJdEW5VEIHt4+COL/FWWPK1ZXPqrBxk4UnxU7u/YYpv0b072h9SloseiwJE2HFhTwz8QbmLdKvn7Ca4f7QS/LmyIqQf0i6zckFXLtVRqlEV0LYnyaGRH2G5NaMwBac6EOl3Bv57KdpghiyUgEZWdPy/MXlSOh5Xoo2LHevIL4wZW3cUR/2iidziUNK/P8p8lOMdvg==
Received: from DB6PR07CA0050.eurprd07.prod.outlook.com (2603:10a6:6:2a::12) by
 AM0PR10MB3524.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:15f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4888.10; Wed, 12 Jan 2022 19:21:28 +0000
Received: from DB5EUR01FT015.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:6:2a:cafe::82) by DB6PR07CA0050.outlook.office365.com
 (2603:10a6:6:2a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10 via Frontend
 Transport; Wed, 12 Jan 2022 19:21:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.72)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.72 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.72; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.72) by
 DB5EUR01FT015.mail.protection.outlook.com (10.152.5.0) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4888.9 via Frontend Transport; Wed, 12 Jan 2022 19:21:28 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SMA.ad011.siemens.net (194.138.21.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 12 Jan 2022 20:21:27 +0100
Received: from md1za8fc.ad001.siemens.net (158.92.8.113) by
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 12 Jan 2022 20:21:26 +0100
Date:   Wed, 12 Jan 2022 20:21:25 +0100
From:   Henning Schild <henning.schild@siemens.com>
To:     "Limonciello, Mario" <mario.limonciello@amd.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        Aaron Ma <aaron.ma@canonical.com>, <linux-usb@vger.kernel.org>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <hayeswang@realtek.com>, <tiwai@suse.de>
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Message-ID: <20220112202125.105d4c58@md1za8fc.ad001.siemens.net>
In-Reply-To: <5411b3a0-7e36-fa75-5c5c-eb2fda9273b1@amd.com>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
        <YdYbZne6pBZzxSxA@lunn.ch>
        <CAAd53p52uGFjbiuOWAA-1dN7mTqQ0KFe9PxWvPL+fjfQb9K5vQ@mail.gmail.com>
        <YdbuXbtc64+Knbhm@lunn.ch>
        <CAAd53p5YnQZ0fDiwwo-q3bNMVFTJSMLcdkUuH-7=OSaRrW954Q@mail.gmail.com>
        <20220106183145.54b057c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAAd53p7egh8G=fPMcua_FTHrA3HA6Dp85FqVhvcSbuO2y8Xz9A@mail.gmail.com>
        <20220110085110.3902b6d4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAAd53p5mSq_bZdsZ=-RweiVLgAYU5+=Uje7TmYtAbBzZ7XCPUA@mail.gmail.com>
        <ec2aaeb0-995e-0259-7eca-892d0c878e19@amd.com>
        <20220111082653.02050070@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <3f258c23-c844-7b48-fffb-2fbf5d6d7475@amd.com>
        <20220111084348.7e897af9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <2b779fef-459f-79bb-4005-db4fd3fd057f@amd.com>
        <20220111090648.511e95e8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <5411b3a0-7e36-fa75-5c5c-eb2fda9273b1@amd.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [158.92.8.113]
X-ClientProxiedBy: DEMCHDC8A1A.ad011.siemens.net (139.25.226.107) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 521c5433-acde-474c-01e5-08d9d600bb66
X-MS-TrafficTypeDiagnostic: AM0PR10MB3524:EE_
X-Microsoft-Antispam-PRVS: <AM0PR10MB35248423C26DB6C274E7B77285529@AM0PR10MB3524.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z2zA/biHvpDfUwrzq5iTPCQFnT5ZYxKeOQW+ZJhxTMphLK6MqqYBygDzY4ZvDIg51PNWmVlwkpZ2GTb3HUDvuKARJwLVGEQEYw//6pTVkyur4RehQthe7JPX0Y79Eo5A4a6zONIl1y05BiSjA31msaTS9QNLSHnd4O2vrLcwq+QWtP2BP7O0tHSx2VNvQA1i8AbzatnFpdDv9J7yaRJqc+etsYjj/fG0yzOFzflYhuvEV61g1dFg/mdULoBskeYSqDLGIejzZBxITl2kC9i+8H8dNywGDop8WPx8bqKbxZsyhZ+ofoA3kxkikpbEu9EBmKBCQeAjqFmqjzuZ4ubr7vPLSr8SzfiZ3be6HBIaIglwNtfvBhH/ElfZ6A7I75MC8OYtwmJVRQFePZVY+/JFAcciESHy22cVaUyWRbcrGiWCHwDkbziIHnPDCmIIjmB8OcKWsc58BvMfSb7wdSAPeKQHjlEO3ZxsEpXPWrFRyUnAx6L9PDzS22FjQzubtIpTEcdIl2oazCxP2WHJq+kQ+Bmka0qMkThQE0cv4xCAK5PVeZNY7rl5Bt+AL/bOMT/r5haSHLhfwd/u7ST1buYLHGrgi+xChy1206T740rb8jwoM7fV0ZURJ5s0JZmwTWU/b4yqv2DupF3MYf5nLbnAtG90wG3IZ6Acq1agD5seIz1ghEwZu5284LEqs9vjKd/4ZKX9A88FAECRFYbwb1pONP84jM9EJAEAaqPij2ThW1TGnZHnP9E6vQRk2oAIR1IvkJQEzrKdqv0hgJJJ/laI4VGHi5dliLyDyhgxRvJEf4M=
X-Forefront-Antispam-Report: CIP:194.138.21.72;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(54906003)(55016003)(83380400001)(356005)(316002)(70586007)(1076003)(336012)(508600001)(70206006)(7696005)(82310400004)(40460700001)(9686003)(16526019)(186003)(4326008)(26005)(53546011)(5660300002)(6916009)(81166007)(82960400001)(8936002)(2906002)(8676002)(956004)(44832011)(86362001)(36860700001)(47076005)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 19:21:28.1285
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 521c5433-acde-474c-01e5-08d9d600bb66
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.72];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR01FT015.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3524
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Tue, 11 Jan 2022 11:10:52 -0600
schrieb "Limonciello, Mario" <mario.limonciello@amd.com>:

> On 1/11/2022 11:06, Jakub Kicinski wrote:
> > On Tue, 11 Jan 2022 10:54:50 -0600 Limonciello, Mario wrote: =20
> >>> Also knowing how those OSes handle the new docks which don't have
> >>> unique device IDs would obviously be great.. =20
> >>
> >> I'm sorry, can you give me some more context on this?  What unique
> >> device IDs? =20
> >=20
> > We used to match the NICs based on their device ID. The USB NICs
> > present in docks had lenovo as manufacturer and a unique device ID.
> > Now reportedly the new docks are using generic realtek IDs so we
> > have no way to differentiate "blessed" dock NICs from random USB
> > dongles, and inheriting the address to all devices with the generic
> > relatek IDs breaks setups with multiple dongles, e.g. Henning's
> > setup. > If we know of a fuse that can be read on new docks that'd
> > put us back in more comfortable position. If we need to execute
> > random heuristics to find the "right NIC" we'd much rather have
> > udev or NetworkManager or some other user space do that according
> > to whatever policy it chooses. =20
>=20
> I agree - this stuff in the kernel isn't supposed to be applying to=20
> anything other than the OEM dongles or docks.  If you can't identify=20
> them they shouldn't be in here.

Not sure we can really get to a proper solution here. The one revert
for Lenovo will solve my very issue. And on top i was lucky enough to
being able to disable pass-thru in the BIOS.

=46rom what the Lenovo vendor docs seem to suggest it is about PXE ...
meaning the BIOS will do the spoofing, how it does that is unclear. Now
an OS can try to keep it up but probably should not try to do anything
on its own ... or do the additional bits in user-space and not the
kernel.

Thinking about PXE we do not just have the kernel, but also multiple
potential bootloaders. All would need to inherit the spoofed MAC from a
potential predecessor having applied spoofing, and support USB and
network ... that is not realistic!

Going back to PXE ... says nothing about OS operation really. Say a
BIOS decides to spoof when booting ... that say nothing on how to deal
with hot-plugged devices which die BIOS did not even see. But we have
code for such hot-plug spoofing in the kernel .. where vendors like
Lenovo talk about PXE (only?)

The whole story seems too complicated and not really explained or
throught through. If the vendors can explain stuff the kernel can
probably cater ... but user-land would still be the better place.

I will not push for more reverts. But more patches in the direction
should be questioned really hard! And even if we get "proper device
matching" we will only cater for "vendor lock-in". It is not clear why
that strange feature will only apply if the dock if from the same
vendor as the laptop. Applying it on all USB NICs is clearly going too
far, that will only work with IT department highlander policies like
"there must only be one NIC".

So from my point it is solved with the one Lenovo-related revert. Any
future pass-thru patches get a NACK and any reverts targeting other
vendors get an ACK. But feel free to Cc me when such things happen in
the future.

regards,
Henning
