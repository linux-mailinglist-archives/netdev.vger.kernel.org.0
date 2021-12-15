Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A494C475738
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 12:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241927AbhLOLBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 06:01:46 -0500
Received: from mail-gv0che01on2122.outbound.protection.outlook.com ([40.107.23.122]:42081
        "EHLO CHE01-GV0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241878AbhLOLBn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 06:01:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AfglxGkaYOsK7AyrihhF83ix9yy5c/arisHiS1y70eDOvwQgS/Yu4c4GwLltk+Sa+WnKWGC8nbT6VCGPZ/HTy3RQLZt/f/OOGScTyWDKA9KF0FWBEItw2s4SXQZKCJ9v91RgywGBPB6nCIDMZ1xoxtf+I8pv1QfAl5Oe3AHlbAxJsI5isgQ+dcAbRbd9r/dQNWJCg569Rr/fLSHP4EDalTYa8Luyz6Q9PFeQzoruLyKI89Ns0rV5PHIIilCzhr2NNwREMk/0TKRlRXM0mYcYceFLCRx1U332F24gjyOQ/yKZvrrXyLLHSdFRgPCzH6KfFNg6AbJTemS17F7LFA4jug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mSh/iezWuJLPLZlle81tkR2K98RobqnNuXjQ3U5t/Ag=;
 b=e5x7niVSRUMYiqGXinXSltIddjqyk8JL9cB1ps7e2sXNpdWTye/FbYrMZ/dz8hfuklBZtj765v0GCqHd6dTG+vkPqX9q9m8M/dX+giS739gGHyp6ICgm82AVyXM/ecx4BOdJetyhGImyBnC6yn38Yu8WPbPqFLDRbnToPBTEo6cIsjSqjU6mknNuSWVh0TlLVom8CpRgP/RjerbR53k9PhBzUB87xGoR8nBCKAngfl7jyrwQ4RYE5APebqHTOU0uLBOCXDuWZMP1tf5ZROsoKduQNybASZAykNDkrRTErn4KjAQR0w2PY00EYn24D9Pg3u93WvVPcNs/SfVWxS/51g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mSh/iezWuJLPLZlle81tkR2K98RobqnNuXjQ3U5t/Ag=;
 b=M97foljGPl3wfT9g9pfwT7PoEDDbPibCz0TD1nTKeENNNMl20HWz/ysr1W/tunrmlCTCu1yXjjv8lyaMLyFb9WF7GWz91RfiZ0S6l/qkCKTjChg2yEigg33ivaRS6W9Qx0+tV8q4caJj5GLiQH8Z4WgOrG/a8iQ37kL/F7BPKng=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3d::11)
 by ZR0P278MB0348.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:37::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Wed, 15 Dec
 2021 11:01:40 +0000
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0]) by ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0%2]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 11:01:40 +0000
Date:   Wed, 15 Dec 2021 12:01:39 +0100
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        netdev@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: fec: reset phy on resume after power-up
Message-ID: <20211215110139.GA64001@francesco-nb.int.toradex.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB679570A356B655A5D6BFE818E6769@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YbnDc/snmb1WYVCt@shell.armlinux.org.uk>
 <Ybm3NDeq96TSjh+k@lunn.ch>
X-ClientProxiedBy: AS9PR06CA0216.eurprd06.prod.outlook.com
 (2603:10a6:20b:45e::30) To ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:3d::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17788432-b52b-4c0f-773b-08d9bfba45da
X-MS-TrafficTypeDiagnostic: ZR0P278MB0348:EE_
X-Microsoft-Antispam-PRVS: <ZR0P278MB0348E34E9DEC0B526072A83FE2769@ZR0P278MB0348.CHEP278.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dAh+yRgUPuUshKfbGbOUr9V5CShxzQZd4x4NaDDSlrVmTeSyYuzsBQ9zvBY2Q95cxqyJpt+8vd05iFZYF/T18ssj+UALmR4bp2SkY4/4uA4CPRSqLxO19RIID2/rF2jgeoz4DDPzneP4X8qh4A3U6Mk6niTypQL/mazbRlhxzxV/pslpLGFLmaoYJPi80PbXHQg8whd1db3lyMYN9B3XI7lv2bd/eRgJOos0HqxovlZpafluW8ocDxxXMBQGc21QdYnQv8uUvWxgkru/cN8o9mk91K+QrR6hqLPU9E6464RGJP8P9Nl+Siqc9obkkW1J+CGvajGJHCBCsmLj46bOvOVLxXe4ZyS3Ic6u37j+845I2c5gojRWddb+K61Vni72I16GMNaYitZg/jjAIJADJs7nvxW7HszhG15no+4RLsywzZmgTN7/DYREYwKa6OiKOEU+WKOcwJqcAlP4HUpKvj/3MEcIOfKV9FtB4XIb7vfyYp40NhjOkrZTpM9Z8oY9ZO+yAvS2zGCxqpaZPQrexRRa3dUDICI0atgYFO8GI507AiAwHwelEJrikR9+jMPqHXFWSrQ/cF2ihG7Vwa7fsQM9BKR1mCwSsUGSS9Wl59LWt5k8SrBrbUsplaSiAXIFlAeax0Joq/o3oQkF5Qgven9PrK4AZoQhsgS3pQr2u2pw8KAvAGb0TC1U9gJYPuGytF5AEl3N1B7Yp7PpzPQWqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(39840400004)(376002)(396003)(136003)(346002)(6486002)(86362001)(66476007)(54906003)(316002)(33656002)(4326008)(5660300002)(66556008)(110136005)(6512007)(8936002)(44832011)(83380400001)(38100700002)(38350700002)(26005)(52116002)(1076003)(186003)(6506007)(2906002)(8676002)(508600001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jXmHLV9zglTTwiJhaz0mNzY8Q5Lhh7GVVMjQzrl3FfliHrCvvxccd4nMcYYA?=
 =?us-ascii?Q?gspClqJfc0A+mendeUo16IvyavgUfcrgwgCLKHii8TPczi9F3jO1vy2I/ArO?=
 =?us-ascii?Q?WTrSAOK0MrY7RYD+aqglouqcArwksM34u1olF4kZ7nwD54R/blm8HSqMRhCe?=
 =?us-ascii?Q?WT0Fmp7bbOJ2fi+2U89U9kWYHrmUZbKOPTny/96xu2MeY5TNz/8d4LsWk/2r?=
 =?us-ascii?Q?3+dUmIOpIBGhtYlx9yZgHNMPDgUqnj7gpw9cpkrkffK0LWgYR+s5mPaKLcWe?=
 =?us-ascii?Q?nTd/j9ZDtiq+LYJDiF+L9r1YvCmxNTI8GAaWk1n1lBMsSEtsr0Tkk4VTZkxD?=
 =?us-ascii?Q?ez9AcFGaH/PHhoVzQTTsyHG7VCyyRepRX1d/qK/vMt2ODuv3gk9R+lYR5LvN?=
 =?us-ascii?Q?svGEIxNR/Ncd6LH8LZc6m2izM2oNCDiAb1UZmPgAA8SLB2Xnf2TfyI9L1uIk?=
 =?us-ascii?Q?TsFxntx650ppAVmJUcqMNzXekgYLHvFSJnVvm7dkSj+OUgHq66JXVR55hPBu?=
 =?us-ascii?Q?4PPwu0ti+6bNIUMtEja2wG+DTTuntsl9W84RdL0rQ0Hc/eoYi8Doq4TvLAB9?=
 =?us-ascii?Q?3mqi34CiAv20kgtKsUMTEoG3dYW0hBVl5JViUPlNBpdegmfyDmxsPlgj9+kC?=
 =?us-ascii?Q?quex695Zl5mEHYI26jStPhF2desezrrlBwY/3cGZwZRykuLa1Y5FYn2dUE1q?=
 =?us-ascii?Q?EXlb0bZlfUajjvILLrcFyuz5pvZ6+a8xUC7OEYWtw+5JN7ojFJvOoh7oW1qU?=
 =?us-ascii?Q?JF1Qjgb9573JIoPl3k9bncx0pOxXO0pZOqcYFhV++Lh7oO8AeYtz1hCXYaUd?=
 =?us-ascii?Q?XutZmcRsIl2EPcxpTructdpPF0AscaXyBK2EFTmfmkRDDaBBTQYf113cSYhf?=
 =?us-ascii?Q?6U6l34sXqroOR9PZ83gWLJFVhE8DwQ7qVnfg11mEJ0Mg6GlGQ35AJRBZDCrX?=
 =?us-ascii?Q?h4qQW3o8KUDt+hpC1qQrEn5egXP77A8v0LVEnkxUsjZJBQ7u9RUjbaFTKa/d?=
 =?us-ascii?Q?aIBZjmClLEGwHe1IY3zZtFNGWoY4OYEiO6SFwYWhTAHrslurClmPqT1N2UW+?=
 =?us-ascii?Q?FNGNI//UlIgXii4CnYDcSVnxJD0PxJUS33sMDLuttMcFipESK4ds/qgkNtFW?=
 =?us-ascii?Q?gNxC+rYq4c+1yz9ILQBib0zo9UYo6wUJe5pQbsdjsl/6k4DrJlEcf3v8AbpB?=
 =?us-ascii?Q?ZbVu82LHRCOwsg2USZQgt+As6c/T9GbPZqJf4dhl89dWjvhc/SL/XEL5cWfX?=
 =?us-ascii?Q?1cx3micTXr+sx8ip3Pte8o4V06BSUAv4AJChlDj+kHoXL8MYiiTLdF+Z0uid?=
 =?us-ascii?Q?Ll2SVDQ1FJo0R6TL2H3r4TQ4zo9xKNsrlK/htSIKpxahgfV37BjB1R++BffJ?=
 =?us-ascii?Q?E6zlhOiyjXTU19oxEPrn7j8jx+CBy/qb8uFFoZf+bDD+fdTfK0eX/wm0RHpK?=
 =?us-ascii?Q?h7IyesOqqJ8mbMC5I9khbtb4vmplOseq43KiWxjfvwt8ehNOXpaWW/OHUCbE?=
 =?us-ascii?Q?B2uikLkp/8gIxnfvLaSaSmLble8subdOYAdyXIyoJlyC6ZZW6ovtEyYVroDu?=
 =?us-ascii?Q?9lCCuyoza+xwdr2etf7VonImqClVgO4IXSB+2KyqtV65aHy2gN8eV21rmeEi?=
 =?us-ascii?Q?DO1NfeznxbbWI06/sELQDk0YAfpez30CxRbmrr8u9G0ao0vm1w2hoLQpMoWW?=
 =?us-ascii?Q?9Hlc2cibs+PHaiOsz9lcDVS/r1k=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17788432-b52b-4c0f-773b-08d9bfba45da
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 11:01:40.7170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZwxQdcFhwlyUfTF7AgHvCOJWgZivTVEl9nuJFTwN2Y/PW2AS/EX9xXCZLPF5+nRoSnn+9QgmSRSanIJgheZTqYR81Hx3cc89uUWyhBKFWvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0348
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 10:36:52AM +0100, Andrew Lunn wrote:
> On Tue, Dec 14, 2021 at 11:35:48PM +0100, Francesco Dolcini wrote:
> > Hello Andrew,
> > 
> > On Tue, Dec 14, 2021 at 07:54:54PM +0100, Andrew Lunn wrote:
> > > What i don't particularly like about this is that the MAC driver is
> > > doing it. Meaning if this PHY is used with any other MAC, the same
> > > code needs adding there.
> > This is exactly the same case as phy_reset_after_clk_enable() [1][2], to
> > me it does not look that bad.
> > 
> > > So maybe in the phy driver, add a suspend handler, which asserts the
> > > reset. This call here will take it out of reset, so applying the reset
> > > you need?
> > Asserting the reset in the phylib in suspend path is a bad idea, in the
> > general case in which the PHY is powered in suspend the
> > power-consumption is likely to be higher if the device is in reset
> > compared to software power-down using the BMCR register (at least for
> > the PHY datasheet I checked).
> 
> Maybe i don't understand your hardware.
> 
> You have a regulator providing power of the PHY.
> 
> You have a reset, i guess a GPIO, connected to the reset pin of the
> PHY.
> 
> What you could do is:
> 
> PHY driver suspend handler does a phy_device_reset(ndev->phydev, 1)
> to put the PHY into reset.
> 
> MAC driver disables the regulator.
> 
> Power consumption should now be 0, since it does not have any power.
> 
> On resume, the MAC enables the regulator. At this point, the PHY gets
> power, but is still held in reset. It is now consuming power, but not
> doing anything. The MAC calls phy_hw_init(), which calls
> phy_device_reset(ndev->phydev, 0), taking the PHY out of reset.
> 
> Hopefully, this release from reset is enough to make the PHY work.
This is all correct and will solve the issue, however ...

The problem I see is that nor the phylib nor the PHY driver is aware
that the PHY was powered down, if we unconditionally assert the reset in
the suspend callback in the PHY driver/lib this will affect in a bad
case the most common use case in which we keep the PHY powered in
suspend.

We would have to move the regulator in the PHY driver (phy/micrel.c) to
do it properly.

The reason is that the power consumption in reset is higher in reset
compared to the normal PHY software power down.

This will create a power consumption regression for lot of users.

Doing this into the FEC driver would not have this issue, since we know
if we have a regulator (I guess you saw my one line patch for it).


On Wed, Dec 15, 2021 at 10:29:07AM +0000, Russell King (Oracle) wrote:
> Here's another question which no one seems to have considered. If the
> PHY power source can be controlled, why doesn't the firmware describe
> the power supply for the PHY, and why doesn't the PHY driver control
> the PHY power source? Why is that in the SoC network driver?
Legacy/historical reasons ...

In the first RFC patch for this issue this was mentioned by Philippe,
but than the discussion went into another direction.

As I wrote above if we handle both reset/regulator in the PHY driver it
should work, just a little bit tricky because phy/micrel.c handle a
whole family of phys.


On Wed, Dec 15, 2021 at 10:25:14AM +0000, Joakim Zhang wrote:
> As I mentioned before, both mac and phylib have not taken PHY reset
> into consideration during system suspend/resume scenario. As Andrew
> suggested, you could move this into phy driver suspend function, this
> is a corner case. One point I don't understand, why do you reject to
> assert reset signal during system suspended? 
See my answer to Andrew above, in short asserting the reset without
disabling the regulator will create a regression on the power
consumption.

Any agreement on how to move forward?

 1. add phy_reset_after_power_on() and call it from FEC driver (current
 patchset)
 2. assert phy reset in FEC driver suspend (one line patch from me in
 this thread)
 3. move regulator to phy/micrel.c and assert reset in the phy driver resume
 callback
 4. ?

?

Francesco

