Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB3348A472
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 01:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243127AbiAKAcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 19:32:55 -0500
Received: from mail-mw2nam12on2113.outbound.protection.outlook.com ([40.107.244.113]:9600
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242941AbiAKAcy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 19:32:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W89K8XuTMcT3ztDZnRDgMKF94oCmeQuPQp5ACJrUE9mRFBsyLJI4c5mcnXWx9KROSOECVnPPOY05pZOGqu+ZoI6bOzm2gYdyNBieMG/nQ4CcNtBU+3L7WtC2XbiAEkYuKTL1vQweq9ezemuaFT9NWGjWetUqRrHqzUyJ7RLhmfPQ8nUzstlBl1BPLM2VlYraEWwhnrwF+FGOeN3b66AJgTKnlosR91T+66q7UvpC1RIzgNoTQoO33nXtyIwC6lFnSID1QEAYewppZntCZmoff6Cl+YzOpUqpQ7tclLZK1eY0dLPn5nLJQFF8wcgK68+1aHFhr9VIVuDDybwMQ3n8zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KoOGQllhhmzxdfwfnla7IALnBb9fGA3DXfNNNCRQMwQ=;
 b=Cr9hpsNGnucaDXvQhWBXvPk7rKAMWUS2tixozYMmHXn/lZPsqeyj0KFIC18BZ+XgOZpazimDPjZ2hwdbwoQfLakfqQiW2bys8w+r5rymWNjz1aE4cP06id39uMim0mM+oI9KoYU5UjLiNPdzuOJwKFHYBrSedChhUD5zvpUSXwmQANJUKWzIUnJkeEad+UCdjcaGQg7rMgFsiueJadEefEitzZ1hWO5K3BZgG8uY0gpWsVmG6DuTncC/c3nmonePQ2QMLDTHBuvdZwa/I2iL3rBz1mKamXzLL7Dni9INPh4pIc+dvDvK6LQy9iH2LqQK9VOydnycPt0T1WY3C/r5Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KoOGQllhhmzxdfwfnla7IALnBb9fGA3DXfNNNCRQMwQ=;
 b=NwRDGpEsqBWc1Af0CxWYiaTrzKuaZ09fl9n1RHY/YllQ1UXNnBvZb03RyVwNx9M4yhXqGofa4i674WgzjsX6jOD75PMga4EelPRsuZzEGU57ipQsIk28Y0BS2LcozWWFzlZMIz8H8FDvrJ7ZV+y7jnIAx/MmvAQ+FWKp4TsUqi0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1854.namprd10.prod.outlook.com
 (2603:10b6:300:10b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Tue, 11 Jan
 2022 00:32:51 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4867.011; Tue, 11 Jan 2022
 00:32:51 +0000
Date:   Mon, 10 Jan 2022 16:33:06 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     broonie@kernel.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC v5 net-next 01/13] mfd: ocelot: add support for external
 mfd control over SPI for the VSC7512
Message-ID: <20220111003306.GA27854@COLIN-DESKTOP1.localdomain>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
 <20211218214954.109755-2-colin.foster@in-advantage.com>
 <Ycx9MMc+2ZhgXzvb@google.com>
 <20211230014300.GA1347882@euler>
 <Ydwju35sN9QJqJ/P@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ydwju35sN9QJqJ/P@google.com>
X-ClientProxiedBy: CO2PR06CA0060.namprd06.prod.outlook.com
 (2603:10b6:104:3::18) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13690a68-273b-4e39-eebb-08d9d499e626
X-MS-TrafficTypeDiagnostic: MWHPR10MB1854:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB185456B3C225C22A2833692DA4519@MWHPR10MB1854.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X9fTlLuwsJvwDTM1smphUhw6OmRcpQ4RdhcZKYKJUdvwMfwLkevXmj+cniMm1RK87+7roq/ZORyNe3SwJtg9MKq9H6K50IEhYfc2WHW8FiEqsbe/1WGIr29yfbk0Ov1UPej3GLNPm7sOlahRAAjqQtxLNLdXAx06ecXPaRiYUExRwnDSDNNGYOJ+VhSM88r1cZLYrOmx5uqowjmfAWIDn634jb2ypZkR23x1VJ/a8ZQI3kWKusxhqOc1R+q50ShcCHgjX/d94sgPWomN2n1cXmh1DHMs9YX5QlSVeFZd/voiZuhBX+5YHL8g+yNSpeR4rlX+SyGCrVuyHPes8eE11MXUC4JdeSXvr4BBiqtVcjyX/gD8zMdFKXiZ2l+3Z4Xpq7jvooqKqMm4fwiLJv00Tkppdh33V7s1TnMx8LjBGmX+oowZLtjibhHe7t9aomuDYx9mcw9sJHZ6/dhge/hgPGqMeC11/nV5EPgq8AU+tXFbnwtZglPSdC0cTYi1cM8M7Ou+cUl3wCeIPML1WFaX5XmFUNtYTVNA6GnnhKMZ8ebV6ZmFPh3DwsD7WROAnz/0lhPEdoDoB/viBcQiFa4XmqG4WP8QCxF2zZtsp+o5YEKrOEc7IfGUpmnsNYtk1LuOqjnUrPSsEWKe9y7j7XbNVmwaAcqvzmL1xPOLBvQofA8JlHu7o0q/MioLXlVTp7W7K68vFS8Qy1Ifp1o+RX8CZ4u2AsNHu0JKdREocCmp/r9dicUqxjKXq9RuqayMVHh47qAi5NYJe3nMqM5bCh6by/CeOZYzzxJOFlHG5X191Lw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(39830400003)(366004)(42606007)(376002)(1076003)(7416002)(4326008)(33656002)(66946007)(5660300002)(8936002)(6486002)(30864003)(6666004)(66476007)(66556008)(8676002)(966005)(316002)(44832011)(26005)(52116002)(6916009)(38100700002)(2906002)(38350700002)(86362001)(9686003)(6506007)(6512007)(508600001)(186003)(54906003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QUZzdTdaQXVqNjVneTVjQVNvak45OTh1Skc1WjVmQ2xRclQxUmFWWldtUUVH?=
 =?utf-8?B?dkVNZmpWazlOb01LYmVFN1RsbkpiOTh5dkdFdk55M2lreTZlMFJRUmx1Rllp?=
 =?utf-8?B?UStmQXhFMUlNV1ZTOVpudDVyRXlWbEdlUVRld1FIb0ZjTWNNZHdpTE91L09G?=
 =?utf-8?B?UGI5LzM3R29mWDhqM3ZtSmd0K3lkUFZzRnpOT2lHMldpWkVMMTFxL2hIaUZH?=
 =?utf-8?B?b3F0VDFSc0xFNUVuVEJnVzZZanIyZWZ3Z3FlSHozNi8xQVcxQXZvK2oyOUUx?=
 =?utf-8?B?ZC9NRzFvSXhZSWE2NzJhZ1R5T3RNOExPbWdmaGtRc3JVUFZhcmJjZ092NnZO?=
 =?utf-8?B?TXgxVm5DMWg5ZitPaTllMnNpcForVkViRysvWk1RNlJod25rYktKT1gwSGdB?=
 =?utf-8?B?RXc2aUJnblFsdkExSk1QL3Z1ZXgvRXp2eWdSRk5kNENSS0JiVWp4WEpDM3BI?=
 =?utf-8?B?Q0VxY3lvcGk0RFhGbFVBdjhGd2FrYmw3SGhaWDBhZ243ZWV2QWp5dUdEQWJO?=
 =?utf-8?B?ZE0zYjlybjh6b0cvMHdwWUxLTjFSVXE3OHVGVnMzenRMQ3dUdjdvOTkzcGlY?=
 =?utf-8?B?VUxuUElKcFV6ZVJQdm9pTWlQWVYrVXg1dFV0dWUvVTBnYlIzSy8vUjBZNEZ1?=
 =?utf-8?B?ZW14S2V3UEM5ckNINi80RXJWODZ2b0RZQml5NkNQU2Z6SUlLNkFHQXJGNVNT?=
 =?utf-8?B?OUxFMFhtSGRCNEQ0THlJYnNiQ0lweG5KWnZVV2pHeE1BVm5vY1dQUERLMm82?=
 =?utf-8?B?THQrWFV2Z3BZeHIzczdST2lEcnZXb2QyY01UeUY1OEl4emd3a0k1Tk9hU2ds?=
 =?utf-8?B?TTR4bXBTWEhOZjJvOGxXYUN4T2dycTJYbnJjU2NFMUpwOEpZNVVpZis1ZnZZ?=
 =?utf-8?B?ZjFTRmNROXZ6cmQrL2E1S1VFdGFBYjNoMlQ4cExteXFiQzhJSGp2bUswaEpo?=
 =?utf-8?B?WkhqaUdNL1RYMXdBTDNxMEJqSzhBMmdEdm9DSEpCY2ZKVEJsVzRsTXJzWnNH?=
 =?utf-8?B?dUlpMnhLK1NPQXpMaVlNMVZENWRhUllFeHpkS3NuMUw1b0pkUWdkaGQ1RFVK?=
 =?utf-8?B?YWNWVXU4SmpIZGEyZDREdWlHTG0wUjFpRUFkeUdZZU1QK1poUUFGN1N2dlVo?=
 =?utf-8?B?Vi9SMEU3VUlqaThveFlCUldudHpjSDBXWHk1WU1mUlc0cTRob3MrTUx3VG5S?=
 =?utf-8?B?c0lXbFRpR2J1TTJFWENhcFFwNktUenlRZGhxN2Q3Ti92WW9FbGh5SU9ibWh6?=
 =?utf-8?B?NGRXQ1l2bGNIRmNUS0VQTkdZRFE4Z29CNCtLcitrcnFUN0dvRytVSm5HMS9C?=
 =?utf-8?B?MmxUT2xRei8zK05nMFhSQmxiRHRmYjdIYUVLaE1xYWNRalFoa05aOENmN0VR?=
 =?utf-8?B?QVo0SjJJTyt4NVJWUEZ5L0lhV3Z0aXB4bGpHUU1GUFZoeEVSdldPdmdPYkRt?=
 =?utf-8?B?RzhOa2RzZlNRNHo3dEVPczFKRjluOVhveHVZb05heU1QQXQ2K2JGNzJIQTNC?=
 =?utf-8?B?UUY4Qm5RQlhzVThBM2Z2SkN0a1g4MnBYb0tGM1A4R1RyTVlHNm9NZTVhY00y?=
 =?utf-8?B?QkRwSzVzaXhXSm9YY0QwRmw5ejZGWklWZ0tjWDhsRHlLVExJUnJaNWdxNllQ?=
 =?utf-8?B?c2MzU2VOUTA5OFpPcmNhSDBqY3o1TlBacFRsRUdyenZ3Qk9qdFFPNVR2TW9G?=
 =?utf-8?B?eGprUlpzRUp6cDJqVFVJQXV5aEJYb1c0SXdQOHF2MnR4K1RGZFlZWWlwbUhC?=
 =?utf-8?B?RzZUa2xwc01OK2dEYXpybGIxM3IwNElxTWt0UWszTDRWQW91SWZIVWQvbjhT?=
 =?utf-8?B?US9YeW56L1lCcWZtUG9QSlpqcjhnZ2FvTVJldlA0NDNrbWRDdFFLUGRBWGJi?=
 =?utf-8?B?cERaSW4yd2pjQVVZN0VCQVhDNWFIcWZEMDU3Y0JxYUU1Qi8relhOZ25ZdjlK?=
 =?utf-8?B?N0tNeVZtakVBcFI3WWlPdWdGMGFDRkJ5TURYUFhsMFh3NEhCdzBNQ0IxY3ZK?=
 =?utf-8?B?VFh6bzdlTmR4OEkxNGZXS3BOeUwwVW5YZXNoaVBHV0FFb1gzUmQ2Vmd6K2hy?=
 =?utf-8?B?V3VVZEFGQzR0dEFEVGNYeXNOZ1A1bFd4OVovL3IxNkwxTDBmN0dNUTNlcG4z?=
 =?utf-8?B?YWNuY085Uy90blNPV2FnUk53cU1CM081ZTdqeUdlNC9SWXdkZjlrKzNmcTV5?=
 =?utf-8?B?bG5DQ3FDcXNrU2Y1NnkzaXAyWGJMbkVac21CWUxxZ0UrT3dtdlNWTmtJODZM?=
 =?utf-8?B?RFVIcnpTNk1XaHRzRFUrd3M5VVFBPT0=?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13690a68-273b-4e39-eebb-08d9d499e626
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 00:32:50.9156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jjN7duPdjEnTpoZUwkrk/kwXY1P3PYF8fYnFMyEIq4UdZvAKgCaKJaHqlsqkNaRFYbt7Dui9X3zI629NnJZYV5gjKovTAhSUkgt7HsASFLc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lee,

Thank you for all your feedback. I expect to create another RFC in the
next week or two with all the changes you suggest.

On Mon, Jan 10, 2022 at 12:16:59PM +0000, Lee Jones wrote:
> On Wed, 29 Dec 2021, Colin Foster wrote:
> > On Wed, Dec 29, 2021 at 03:22:24PM +0000, Lee Jones wrote:
> 
> [...]
> 
> > > > +	tristate "Microsemi Ocelot External Control Support"
> > > > +	select MFD_CORE
> > > > +	help
> > > > +	  Say yes here to add support for Ocelot chips (VSC7511, VSC7512,
> > > > +	  VSC7513, VSC7514) controlled externally.
> > > 
> > > Please describe the device in more detail here.
> > > 
> > > I'm not sure what an "External Control Support" is.
> > 
> > A second paragraph "All four of these chips can be controlled internally
> > (MMIO) or externally via SPI, I2C, PCIe. This enables control of these
> > chips over one or more of these buses"
> 
> Where?  Or do you mean that you'll add one?

I meant I added one. Sorry that wasn't clear.

> 
> > > Please remove the term 'mfd\|MFD' from everywhere.
> > 
> > "ocelot_init" conflicts with a symbol in
> > drivers/net/ethernet/mscc/ocelot.o, otherwise I belive I got them all
> > now.
> 
> Then rename the other one.  Or call this one 'core', or something.

I'll add "core" or something to this one.

> 
> > > > +struct ocelot_mfd_core {
> > > > +	struct ocelot_mfd_config *config;
> > > > +	struct regmap *gcb_regmap;
> > > > +	struct regmap_field *gcb_regfields[GCB_REGFIELD_MAX];
> > > > +};
> > > 
> > > Not sure about this at all.
> > > 
> > > Which driver did you take your inspiration from?
> > 
> > Mainly drivers/net/dsa/ocelot/* and drivers/net/ethernet/mscc/*.
> 
> I doubt you need it.  Please try to remove it.

Fair point. I'll remove it here.

> 
> > > > +static const struct resource vsc7512_gcb_resource = {
> > > > +	.start	= 0x71070000,
> > > > +	.end	= 0x7107022b,
> > > 
> > > No magic numbers please.
> > 
> > I've gotten conflicting feedback on this. Several of the ocelot drivers
> > (drivers/net/dsa/ocelot/felix_vsc9959.c) have these ranges hard-coded.
> > Others (Documentation/devicetree/bindings/net/mscc-ocelot.txt) have them
> > all passed in through the device tree. 
> > 
> > https://lore.kernel.org/netdev/20211126213225.okrskqm26lgprxrk@skbuf/
> 
> Ref or quote?
> 
> I'm not brain grepping it searching for what you might be referring to.
> 
> I'm not sure what you're trying to say here.  I'm asking you to define
> this numbers please.

I'll define the numbers as you suggest.


The quote I was referring to is this:

> The last option I haven't put much consideration toward would be to
> move some of the decision making to the device tree. The main ocelot
> driver appears to leave a lot of these addresses out. For instance
> Documentation/devicetree/bindings/pinctrl/mscc,ocelot-pinctrl.txt.
> That added DT complexity could remove needs for lines like this:
> > > +              ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK],
> But that would probably impose DT changes on Seville and Felix, which
> is the last thing I want to do.

The thing with putting the targets in the device tree is that you're
inflicting yourself unnecessary pain. Take a look at
Documentation/devicetree/bindings/net/mscc-ocelot.txt, and notice that
they mark the "ptp" target as optional because it wasn't needed when
they first published the device tree, and now they need to maintain
compatibility with those old blobs.

> 
> > > > +	.name	= "devcpu_gcb",
> > > 
> > > What is a 'devcpu_gcb'?
> > 
> > It matches the datasheet of the CPU's general configuation block.
> 
> Please could you quote that part for me?

Hmm... I'm not sure exactly what you mean by this.

https://ww1.microchip.com/downloads/en/DeviceDoc/VMDS-10489.pdf

There are 64 instances of "DEVCPU_GCB" in the main datasheet. 
Chapter 6 of this PDF has an attached PDF around the phrase "Information
about the registers for this product is available in the attached file"

Section 2.3 of that attached PDF is dedicated entirely to DEVCPU_GCB 
registers. Table 1 defines that register block starting at 0x71070000.
The entry from that table is
| DEVCPU_GCB | 0x71070000 | General configuration block. | Page 63 |
This document has 175 references to the phrase "DEVCPU_GCB".

> 
> > > > +	ret = regmap_field_write(core->gcb_regfields[GCB_SOFT_RST_CHIP_RST], 1);
> > > 
> > > No magic numbers please.  I have no idea what this is doing.
> > 
> > I'm not sure how much more verbose it can be... I suppose a define for
> > "RESET" and "CLEAR" instead of "1" and "0" on that bit. Maybe I'm just
> > blinded by having stared at this code for the last several months.
> 
> Yes please.  '1' could mean anything.
> 
> 'CLEAR' is just as opaque.
> 
> What actually happens when you clear that register bit?

Agreed. I'll fix this.

> 
> > > 
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > > +	/*
> > > > +	 * Note: This is adapted from the PCIe reset strategy. The manual doesn't
> > > > +	 * suggest how to do a reset over SPI, and the register strategy isn't
> > > > +	 * possible.
> > > > +	 */
> > > > +	msleep(100);
> > > > +
> > > > +	ret = core->config->init_bus(core->config);
> > > 
> > > You're not writing a bus.  I doubt you need ops call-backs.
> > 
> > In the case of SPI, the chip needs to be configured both before and
> > after reset. It sets up the bus for endianness, padding bytes, etc. This
> > is currently achieved by running "ocelot_spi_init_bus" once during SPI
> > probe, and once immediately after chip reset.
> > 
> > For other control mediums I doubt this is necessary. Perhaps "init_bus"
> > is a misnomer in this scenario...
> 
> Please find a clearer way to do this without function pointers.

Understood.

> 
> > > > +void ocelot_mfd_get_resource_name(char *name, const struct resource *res,
> > > > +				  int size)
> > > > +{
> > > > +	if (res->name)
> > > > +		snprintf(name, size - 1, "ocelot_mfd-%s", res->name);
> > > > +	else
> > > > +		snprintf(name, size - 1, "ocelot_mfd@0x%08x", res->start);
> > > > +}
> > > > +EXPORT_SYMBOL(ocelot_mfd_get_resource_name);
> > > 
> > > What is this used for?
> > > 
> > > You should not be hand rolling device resource names like this.
> > > 
> > > This sort of code belongs in the bus/class API.
> > > 
> > > Please use those instead.
> > 
> > The idea here was to allow shared regmaps across different devices. The
> > "devcpu_gcb" might be used in two ways - either everyone shares the same
> > regmap across the "GCB" range, or everyone creates their own. 
> > 
> > This was more useful when the ocelot-core.c had a copy of the 
> > "devcpu_org" regmap that was shared with ocelot-spi.c. I was able to
> > remove that, but also feel like the full switch driver (patch 6 of this
> > set) ocelot-ext should use the same "devcpu_gcb" regmap instance as
> > ocelot-core does.
> > 
> > Admittedly, there are complications. There should probably be more
> > checks added to "ocelot_regmap_init" / "get_regmap" to ensure that the
> > regmap for ocelot_ext exactly matches the existing regmap for
> > ocelot_core.
> > 
> > There's yet another complexity with these, and I'm not sure what the
> > answer is. Currently all regmaps are tied to the ocelot_spi device...
> > ocelot_spi calls devm_regmap_init. So those regmaps hang around if
> > they're created by a module that has been removed. At least until the
> > entire MFD module is removed. Maybe there's something I haven't seen yet
> > where the devres or similar has a reference count. I don't know the best
> > path forward on this one.
> 
> Why are you worrying about creating them 2 different ways?
> 
> If it's possible for them to all create and use their own regmaps,
> what's preventing you from just do that all the time?

There isn't really any worry, there just might be efficiencies to be
had if two children share the same regmap. But so long as any regmap is
created with unique names, there's no reason multiple regmaps can't
overlap the same regions. In those cases, maybe syscon would be the best
thing to implement if it becomes needed.

I have nothing against making every child regmap be unique if that's the
desire.

> 
> > > > +	/* Create and loop over all child devices here */
> > > 
> > > These need to all go in now please.
> > 
> > I'll squash them, as I saw you suggested in your other responses. I
> > tried to keep them separate, especially since adding ocelot_ext to this
> > commit (which has no functionality until this one) makes it quite a
> > large single commit. That's why I went the path I did, which was to roll
> > them in one at a time.
> 
> This is not an MFD until they are present.

Sounds good. I'll squash before the next RFC.

> 
> > > > +int ocelot_mfd_remove(struct ocelot_mfd_config *config)
> > > > +{
> > > > +	/* Loop over all children and remove them */
> > > 
> > > Use devm_* then you won't have to.
> > 
> > Yeah, I was more worried than I needed to be when I wrote that comment.
> > The only thing called to clean everything up is mfd_remove_devices();
> 
> Use devm_mfd_add_devices(), then you don't have to.
> 
> [...]

Ooh. Thanks!

> 
> > > > +#include <linux/regmap.h>
> > > > +
> > > > +struct ocelot_mfd_config {
> > > > +	struct device *dev;
> > > > +	struct regmap *(*get_regmap)(struct ocelot_mfd_config *config,
> > > > +				     const struct resource *res,
> > > > +				     const char *name);
> > > > +	int (*init_bus)(struct ocelot_mfd_config *config);
> > > 
> > > Please re-work and delete this 'config' concept.
> > > 
> > > See other drivers in this sub-directory for reference.
> > 
> > Do you have a specific example? I had focused on madera for no specific
> > reason. But I really dislike the idea of throwing all of the structure
> > definition for the MFD inside of something like
> > "include/linux/mfd/ocelot/core.h", especially since all the child
> > drivers (madera-pinctrl, madera-gpio, etc) heavily rely on this struct. 
> > 
> > It seemed to me that without the concept of
> > "mfd_get_regmap_from_resource" this sort of back-and-forth was actually
> > necessary.
> 
> Things like regmaps are usually passed in via driver_data or
> platform_data.  Almost anything is better than call-backs.
> 
> [...]

I'll work to clean this up for the next RFC.

> 
> > > > +	if (!ocelot_spi)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	if (spi->max_speed_hz <= 500000) {
> > > > +		ocelot_spi->spi_padding_bytes = 0;
> > > > +	} else {
> > > > +		/*
> > > > +		 * Calculation taken from the manual for IF_CFGSTAT:IF_CFG. Err
> > > > +		 * on the side of more padding bytes, as having too few can be
> > > > +		 * difficult to detect at runtime.
> > > > +		 */
> > > > +		ocelot_spi->spi_padding_bytes = 1 +
> > > > +			(spi->max_speed_hz / 1000000 + 2) / 8;
> > > 
> > > Please explain what this means or define the values (or both).
> > 
> > I can certainly elaborate the comment. Searching the manual for the term
> > "if_cfgstat" will take you right to the equation, and a description of
> > what padding bytes are, etc. 
> 
> You shouldn't insist for your readers to RTFM.
> 
> If the code doesn't read well or is overly complicated, change it.
> 
> If the complexity is required, document it in comments.

Understood. I'll elaborate.

> 
> > > > +	ocelot_spi->spi = spi;
> > > 
> > > Why are you saving this?
> > 
> > This file keeps the regmap_{read,write} implementations, so is needed
> > for spi_sync() for any regmap. There might be a better way to infer
> > this... but it seemed pretty nice to have each regmap only carry along
> > an instance of "ocelot_spi_regmap_context."
> 
> I still need Mark to look at your Regmap implementation.

Thank you. And again, I appreciate all the feedback.

> 
> -- 
> Lee Jones [李琼斯]
> Principal Technical Lead - Developer Services
> Linaro.org │ Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog
