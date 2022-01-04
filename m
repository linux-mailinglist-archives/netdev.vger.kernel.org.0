Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D1448480B
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 19:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbiADSrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 13:47:55 -0500
Received: from mail-db8eur05on2078.outbound.protection.outlook.com ([40.107.20.78]:32295
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232005AbiADSry (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 13:47:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmotE3YMisW3zCaL+izeteHGQjDHz1copQIjpHBiMoy65zlMG6hw6fEpordV6aKm+s54ibVKcLCriRkM7HO6oNysvDHoJ/7nXr8//VFOGe2yb7A5Slf5zcbK85sMRin/ayTeIRJ0sFrgJF6v1V0tQtFuYQh8OdebXUN0scE62mtwzHHJ5J0UICLeSmxFkj7fSUYVpYO/hnrNvzGsOR3OKSbOYSaeh9eMNaCJ4ay7FnJAR82GjDDgJqxgoalIw2hyonY8VtzKXA8yK5hFBP1YzpdVTEv0TrjvjAkas306CjyoajiQOXlAywKQCMlITrd3iYlJNGO7+jTrhsA1DTA0kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l0rhc9puSvPnrXVfpSaIh+WGYMqTkAtgUC2SvRx7UNU=;
 b=BfyD71j5dTAtUbkMQWkpVgtcfYXJTEdHXeXGAGy/ByqTQCMrAtpcc1rFQmDVwcXJy0Y4BVcndxqEeTTmcTGLuww1SBcr6YqxGtbwjO4e0jd4jBb2pdtd5HUt+xkRmVpZKHVtSDbRDENhAJYKTEaowf01gtEdc2Oh0Czrn8Zj8auWVC8zVUc03spHxrW2zazplZCVfc2GpFhpzitkbAuGIIp/bXasAH1rkXVHNoZAL96W+931JJbO2onll1Z8Sj4T7vtuP0vjVw6JY6jbo1ZglRexDBPkNwSvQkfusW9692NWyQM/FU+UaVPVBVB88cB3WwP2foQwln5iBsYEgmdedQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.72) smtp.rcpttodomain=canonical.com smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0rhc9puSvPnrXVfpSaIh+WGYMqTkAtgUC2SvRx7UNU=;
 b=QMXBfhWE6qjnyH2+Aypt5r6hrHmU79epzwIrMv6DZ8uVYP1GOoAfMuRQa08C8wHTUQ3dXJiCgOdeHB6l+ZVEAUtjm/drrdyztlV8tEinuXRbnMZ91X5rXZGRBsqcfDSXfwToF3eZ47xvg5jQOEmVxbICf1Kb8XrNyR6dgsqoSJNmwRDMxVCjuyWqAm+fHWsrr0+mkPis/j01QDs7Ye+P5m4fPy/nOHwQ8dxkXeru8gS7lKX8cNjZ3OpQKyLozc6jABMlMgUpo9RPNdFQ+Bo/OuFrQOAthB/iF0zsPMGq03l/N8xCQteSYaQBPIESMFwsBujbQrrUm3sUH0/B5S+x6Q==
Received: from SV0P279CA0022.NORP279.PROD.OUTLOOK.COM (2603:10a6:f10:12::9) by
 DB9PR10MB4348.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:229::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4844.15; Tue, 4 Jan 2022 18:47:52 +0000
Received: from HE1EUR01FT027.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:f10:12:cafe::5b) by SV0P279CA0022.outlook.office365.com
 (2603:10a6:f10:12::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14 via Frontend
 Transport; Tue, 4 Jan 2022 18:47:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.72)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.72 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.72; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.72) by
 HE1EUR01FT027.mail.protection.outlook.com (10.152.0.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4844.14 via Frontend Transport; Tue, 4 Jan 2022 18:47:51 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SMA.ad011.siemens.net (194.138.21.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 4 Jan 2022 19:47:51 +0100
Received: from md1za8fc.ad001.siemens.net (158.92.8.107) by
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 4 Jan 2022 19:47:50 +0100
Date:   Tue, 4 Jan 2022 19:47:48 +0100
From:   Henning Schild <henning.schild@siemens.com>
To:     Aaron Ma <aaron.ma@canonical.com>
CC:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>,
        <hayeswang@realtek.com>, <tiwai@suse.de>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: usb: r8152: Add MAC passthrough support for more
 Lenovo Docks
Message-ID: <20220104194748.5f654995@md1za8fc.ad001.siemens.net>
In-Reply-To: <601815fe-a10e-fe48-254c-ed2ef1accffc@canonical.com>
References: <20211116141917.31661-1-aaron.ma@canonical.com>
        <20220104123814.32bf179e@md1za8fc.ad001.siemens.net>
        <20220104065326.2a73f674@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220104180715.7ecb0980@md1za8fc.ad001.siemens.net>
        <601815fe-a10e-fe48-254c-ed2ef1accffc@canonical.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [158.92.8.107]
X-ClientProxiedBy: DEMCHDC89YA.ad011.siemens.net (139.25.226.104) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b4c2ad0-4fb6-408a-f6cc-08d9cfb2b644
X-MS-TrafficTypeDiagnostic: DB9PR10MB4348:EE_
X-Microsoft-Antispam-PRVS: <DB9PR10MB434822514842B8A4AF1CBFCC854A9@DB9PR10MB4348.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GPCQ2Bv/0Oc800BGMqOFng7a00A3S0MsGlpW869x5pDrBOaQkv76ixyMPi+uMaCWqkn7LAw1kfnvr229fb7zbd2vgzM3f9J3zRgdNLOVcbsmS0sYsFjpcVPj9x0fCbKqrRyc3swgxeOKo7vxFs9UZgh3VBDKRUWlOshjqrIZf4UMeKy+Xosi47i7mROd8m80GhwMsSoo+0VvugcL9dMoyvQ9IQUOb8uzJaf5eWRPCBcGYIK8ESv7N7rYCElYJufAyoGwtlfveTepijv5o4fh/mXuY5Jl/6JEE304JLv+Vh6EfCNq1CFoLwpEmZsRpsarCUh7gJNYwKZ4TAL1Tog/gpfLapQWhCzxq6v9TisiCY2yASnkVBmf90IpIMyNy6cZeieRkjC65L+1maZ9WnhdSMtiVJegqYEgB3hKzj40Al6CPKf1lgUyHPkjo200i0eX40L+GcMIDl5aUKhSJzEx5nyZT0NK38N13llJR2s67l9CBilHpmDRkGDX14xdMkQNI6VyR6i75zMtnY60HCcjm8k4kkqMNVFLrcS+uPIioLS5opq3cj3ixMimpG81wyeMQ3tzQ3caKXr49gGeNVy2m+mUyftm/Ijp+5pG2DGzukFY+IUSKPDaemyGf2fasdR+XG7lhakgihkuWxK3Qd/KzjA6OPnnv2JVPZMzyPnlilfAQyXsgab2tMQpzkdpwcq/srlLAPTzi0gjbFjreg/NEQvyKdX0s48TGcNfk4o2qxYYEfFOzquco/YeoBdkKWAY1xpUtVlSAh8yP/q8Fg69WC7WF3Ey6q1GOJmjd/NVrsU=
X-Forefront-Antispam-Report: CIP:194.138.21.72;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(40470700002)(46966006)(8676002)(53546011)(4326008)(47076005)(26005)(54906003)(86362001)(40460700001)(356005)(186003)(1076003)(9686003)(70206006)(956004)(6916009)(83380400001)(336012)(8936002)(5660300002)(316002)(508600001)(36860700001)(2906002)(44832011)(81166007)(16526019)(82310400004)(7696005)(82960400001)(55016003)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 18:47:51.7955
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b4c2ad0-4fb6-408a-f6cc-08d9cfb2b644
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.72];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: HE1EUR01FT027.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR10MB4348
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Wed, 5 Jan 2022 01:40:42 +0800
schrieb Aaron Ma <aaron.ma@canonical.com>:

> On 1/5/22 01:07, Henning Schild wrote:
> > Am Tue, 4 Jan 2022 06:53:26 -0800
> > schrieb Jakub Kicinski <kuba@kernel.org>:
> >   
> >> On Tue, 4 Jan 2022 12:38:14 +0100 Henning Schild wrote:  
> >>> This patch is wrong and taking the MAC inheritance way too far.
> >>> Now any USB Ethernet dongle connected to a Lenovo USB Hub will go
> >>> into inheritance (which is meant for docks).
> >>>
> >>> It means that such dongles plugged directly into the laptop will
> >>> do that, or travel adaptors/hubs which are not "active docks".
> >>>
> >>> I have USB-Ethernet dongles on two desks and both stopped working
> >>> as expected because they took the main MAC, even with it being
> >>> used at the same time. The inheritance should (if at all) only be
> >>> done for clearly identified docks and only for one r8152 instance
> >>> ... not all. Maybe even double checking if that main PHY is
> >>> "plugged" and monitoring it to back off as soon as it is.
> >>>
> >>> With this patch applied users can not use multiple ethernet
> >>> devices anymore ... if some of them are r8152 and connected to
> >>> "Lenovo" ... which is more than likely!
> >>>
> >>> Reverting that patch solved my problem, but i later went to
> >>> disabling that very questionable BIOS feature to disable things
> >>> for good without having to patch my kernel.
> >>>
> >>> I strongly suggest to revert that. And if not please drop the
> >>> defines of  
> >>>> -		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
> >>>> -		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:  
> >>>
> >>> And instead of crapping out with "(unnamed net_device)
> >>> (uninitialized): Invalid header when reading pass-thru MAC addr"
> >>> when the BIOS feature is turned off, one might want to check
> >>> DSDT/WMT1/ITEM/"MACAddressPassThrough" which is my best for asking
> >>> the BIOS if the feature is wanted.  
> >>
> >> Thank you for the report!
> >>
> >> Aaron, will you be able to fix this quickly? 5.16 is about to be
> >> released.  
> > 
> > If you guys agree with a revert and potentially other actions, i
> > would be willing to help. In any case it is not super-urgent since
> > we can maybe agree an regression and push it back into stable
> > kernels.
> > 
> > I first wanted to place the report and see how people would react
> > ... if you guys agree that this is a bug and the inheritance is
> > going "way too far".
> > 
> > But i would only do some repairs on the surface, the feature itself
> > is horrific to say the least and i am very happy with that BIOS
> > switch to ditch it for good. Giving the MAC out is something a dock
> > physically blocking the original PHY could do ... but year ... only
> > once and it might be pretty hard to say which r8152 is built-in
> > from the hub and which is plugged in additionally in that very hub.
> > Not to mention multiple hubs of the same type ... in a nice USB-C
> > chain. 
> 
> Yes, it's expected to be a mess if multiple r8152 are attached to
> Lenovo USB-C/TBT docks. The issue had been discussed for several
> times in LKML. Either lose this feature or add potential risk for
> multiple r8152.
> 
> The idea is to make the Dock work which only ship with one r8152.
> It's really hard to say r8152 is from dock or another plugin one.
> 
> If revert this patch, then most users with the original shipped dock
> may lose this feature. That's the problem this patch try to fix.
> 
> For now I suggest to disable it in BIOS if you got multiple r8152.

I can do that. But as i expect that to be coming from "managed devices"
where IT departments dream that they can identify a machine by its MAC
... those uses likely can not.

So there should maybe be an additional module param, even if it
defaults to "on" as well.

Henning

> Let me try to make some changes to limit this feature in one r8152.
> 
> Aaron
> 
> 
> > MAC spoofing is something NetworkManager and others can take care
> > of, or udev ... doing that in the driver is ... spooky.
> > 
> > regards,
> > Henning  

