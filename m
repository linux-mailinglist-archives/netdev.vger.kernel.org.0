Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30758484931
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 21:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbiADUXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 15:23:14 -0500
Received: from mail-eopbgr60044.outbound.protection.outlook.com ([40.107.6.44]:47075
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232452AbiADUXN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 15:23:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lKgtgHpZhwhecfvJzvhYDzmrPJZDQYudBMqf+LVUCLi9nv6bQBJiOUDlklaFKii1ZPSEyhqUnGMy+1XeymyBPTd0t1DnOs6WW5fApCIPOYk9EwbvwaoCO3pwmuQSJwTMBSzhC33vK3+sQ7KC5LmtyOgbwk9Ff5VfFyPvOICeDPM8uyPCpqc4Mlp13/WTAk4c521CXdfZutGymM8kOHCSJIA0RL265KoDMO/qEtb5kSa0z9ZyhNEtTsYPW+EkDXWQQVK6rKrixrruZ5YleOfccDWtn05KTtZbMFOuewCGgoCUdgz0j3IHxFd11IOl0/yX/V8jD1ywcbhdQKJ0d2cb9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Vex5HHFf2btZShOVM2tXP09JhE2sGBGSj4hUmEeb8g=;
 b=Y68fpdhEnvhwxuuE4zNtT2r52kVliuIe+NeUILjGL8aV+0EgZTrSRvo7VgDiaJLbVhlKVHJ7Pk9SeS9Ewqmz1C9C3XB/NoVkO5MYQaQiuadx0jv7q+XR74/CU7u7kDqj0bikdKVCLhKtr7RW1qUy+EDKc33KjPHa6NOhQw9yDPIf7FQTMPA7eMdBsnymgZA8wuvM3HjOro1U6vyvLeiOIwswmO3241gsTJ+lyRz8hRM+IRQufXakLFUBmsz0JyKRuWchoHbGIM0WEjxy7EIQ2Txz94fQad2uELtjUTFiDphrxQRDJuHxSO3S0WO1VIL11yoGEKg46ucDwMewFOd5Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.70) smtp.rcpttodomain=kernel.org smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Vex5HHFf2btZShOVM2tXP09JhE2sGBGSj4hUmEeb8g=;
 b=ON8vaZN29G8xvWS6z1py7HUxS3ma1NvXNgwuCtZkRiKJEf/75m5cdjJP6/9anviCnDHBQHP+fSSWkLP56e+SLXF3IsK8TZfyBfCn2Q+Kv3IciHpIKy7QuSAfYsGTVd4SjMVhohlYxccxtNLgumTxTO9Zf2gIvpv4ci+HhgFOAb4fJ9FE9GnBhmtv8g/aChuWTeRuEv7sUHkb5hWWVmNG4DFk1hybg/9BPM8llOnX5aEGAmpthCdkuxCb2dxEV9urlpU3gawVXRHbaCbx4uNuRwkqxXLvKTxugyKYiaDwM45hNdaBXqQZRr5YWgRO3ORomo9vosqWEUaH23Xm2wAjBg==
Received: from SV0P279CA0022.NORP279.PROD.OUTLOOK.COM (2603:10a6:f10:12::9) by
 AM7PR10MB3718.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:13a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Tue, 4 Jan
 2022 20:23:11 +0000
Received: from HE1EUR01FT013.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:f10:12:cafe::a8) by SV0P279CA0022.outlook.office365.com
 (2603:10a6:f10:12::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14 via Frontend
 Transport; Tue, 4 Jan 2022 20:23:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.70)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.70 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.70; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.70) by
 HE1EUR01FT013.mail.protection.outlook.com (10.152.0.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4844.14 via Frontend Transport; Tue, 4 Jan 2022 20:23:11 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SJA.ad011.siemens.net (194.138.21.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 4 Jan 2022 21:23:10 +0100
Received: from md1za8fc.ad001.siemens.net (167.87.0.7) by
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 4 Jan 2022 21:23:10 +0100
Date:   Tue, 4 Jan 2022 21:23:08 +0100
From:   Henning Schild <henning.schild@siemens.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Aaron Ma <aaron.ma@canonical.com>, <davem@davemloft.net>,
        <hayeswang@realtek.com>, <tiwai@suse.de>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: usb: r8152: Add MAC passthrough support for more
 Lenovo Docks
Message-ID: <20220104212308.6db977e6@md1za8fc.ad001.siemens.net>
In-Reply-To: <20220104120027.611f8830@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20211116141917.31661-1-aaron.ma@canonical.com>
        <20220104123814.32bf179e@md1za8fc.ad001.siemens.net>
        <20220104065326.2a73f674@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220104180715.7ecb0980@md1za8fc.ad001.siemens.net>
        <601815fe-a10e-fe48-254c-ed2ef1accffc@canonical.com>
        <20220104193455.6b8a21fc@md1za8fc.ad001.siemens.net>
        <20220104120027.611f8830@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.87.0.7]
X-ClientProxiedBy: DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37fade76-a3e1-4800-ccb0-08d9cfc00756
X-MS-TrafficTypeDiagnostic: AM7PR10MB3718:EE_
X-Microsoft-Antispam-PRVS: <AM7PR10MB3718DB884F28D5A631D2B761854A9@AM7PR10MB3718.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YTBvV/2E/He5SUn32gzt7y6TrDfhELhk6aOusYao1Jv3+Evfx0GXlKPhdvIDelYwdyrPb8ItSE+gMDKtJu/po353Jxw/JB9RycIs4zsLQhUemQ3dZ4SOUFKVVE1G8j4Q589VZ9OZT4Q6iEO07GfzjUhRlRiCUt8a7iG+fhbiNrb/7xj7GEuv3kIh/kwPmYKHSVbojFqqJLUlsIJSdzp/P0GGY3Jrpov6X9IfpaT/J5jk0j/+cAB1LHxsiyKQb9MZ7bHp9PvpPTViVXb6fRJECVYl2AG3i1u92lZrD2f9+NfIj/2wRswLozpdal17VFs0amVaqP14ggi1ggr+fo27IiLGGn18HDMMDcp4u1cdfB3mgvwNr2/+miwRhveriA/7PzjS1md2L472Iqt7mFMU8eaKU6LeseC/8AtD5WJWnM0YNBB0YQjRDWpS7QfR6h4FqiV+oLkLABffxW77TPryl8Em/Hwwwh+p3GoZk0OxPfSfdDKtFkJutm/FEvLHsKOYWwZUSX+3Tv8pxWCzszcfMztl9sxMkedKKmxsnvDNukRAYD1QK+x6yKw+SsNT8JPJGMMELgCV90d+hW1yPhlQ2jUxFvF+DWOWs0AohGuT5dMLp3r4bq8zBM2btMow4tPX6+OYNLTTLytxA8IjmXiqDa1WmLbCdZWX5R5QxwYiQeLN90UKIj99ocpzAukaNFQepPiNa99ivHeWxiZnyL8/+KE2co2gQjWEob9ievQYReQHVipxwIBbG/vtjzYqIv1U+ti9vELIR2EpvosEwFSIRw==
X-Forefront-Antispam-Report: CIP:194.138.21.70;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:hybrid.siemens.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700002)(54906003)(7596003)(4326008)(82310400004)(82960400001)(5660300002)(1076003)(2906002)(47076005)(16526019)(26005)(86362001)(83380400001)(7636003)(55016003)(186003)(316002)(9686003)(8936002)(40460700001)(956004)(36860700001)(8676002)(336012)(44832011)(356005)(6916009)(70586007)(7696005)(70206006)(508600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 20:23:11.2497
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37fade76-a3e1-4800-ccb0-08d9cfc00756
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.70];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: HE1EUR01FT013.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR10MB3718
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Tue, 4 Jan 2022 12:00:27 -0800
schrieb Jakub Kicinski <kuba@kernel.org>:

> On Tue, 4 Jan 2022 19:34:55 +0100 Henning Schild wrote:
> > Am Wed, 5 Jan 2022 01:40:42 +0800
> > schrieb Aaron Ma <aaron.ma@canonical.com>:  
> > > Yes, it's expected to be a mess if multiple r8152 are attached to
> > > Lenovo USB-C/TBT docks. The issue had been discussed for several
> > > times in LKML. Either lose this feature or add potential risk for
> > > multiple r8152.
> > > 
> > > The idea is to make the Dock work which only ship with one r8152.
> > > It's really hard to say r8152 is from dock or another plugin one.
> > > 
> > > If revert this patch, then most users with the original shipped
> > > dock may lose this feature. That's the problem this patch try to
> > > fix.    
> > 
> > I understand that. But i would say people can not expect such a crap
> > feature on Linux, or we really need very good reasoning to cause MAC
> > collisions with the real PHY and on top claim ETOOMANY of the
> > dongles.
> > 
> > The other vendors seem to check bits of the "golden" dongle. At
> > least that is how i understand BD/AD/BND_MASK
> > 
> > How about making it a module param and default to off, and dev_warn
> > if BIOS has it turned on. That sounds like a reasonable compromise
> > and whoever turns it on twice probably really wants it. (note that
> > BIOS defaults to on ... so that was never intended by users, and
> > corporate users might not be allowed/able to turn that off)
> > 
> > MACs change ... all the time, people should use radius x509. The
> > request is probably coming from corporate users, and they are all
> > on a zero trust journey and will eventually stop relying on MACs
> > anyways.
> > 
> > And if ubuntu wants to cater by default, there can always be an udev
> > rule or setting that module param to "on".  
> 
> Let's split the problem into the clear regression caused by the patch
> and support of the feature on newer docks. I think we should fix the
> regression ASAP (the patch has also been backported to 5.15, so it's
> going to get more and more widely deployed). Then we can worry about
> the MAC addr copy on newer docks and the feature in a wider context.
> Is there really nothing in the usb info of the r8152 instance to
> indicate that it's part of the dock? Does the device have EEPROM which
> could contain useful info, maybe?

As far as i can tell a simple revert will do the trick. In which case
only "well known" docks will be affected and hopefully do not have any
other r8152 dongles attached.

If a dock does not have its own USB device ID ... like travel adaptors
or plain USB ethernet thingys ... MAC inheritance might be "going too
far". And if a new "active dock" shows up ... its device ID should be
added and matched.

But it is not easy to split up really ... because people might be using
"active" docks from other vendors. Nobody said that i can not use an HP
USB-C thingy for my Lenovo machine or the other way around.
The code currently matches vendor specific ACPI with vendor specific
USB, which creates a kind of nasty vendor lock-in situation for
accessory.

Henning

> > > For now I suggest to disable it in BIOS if you got multiple r8152.
> > > 
> > > Let me try to make some changes to limit this feature in one
> > > r8152.    
> > 
> > Which one? ;) And how to deal with the real NIC once you picked one?
> > Looking forward, please Cc me.  
> 

