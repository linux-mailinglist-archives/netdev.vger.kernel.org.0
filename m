Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1D448182C
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 02:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbhL3BnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 20:43:10 -0500
Received: from mail-dm6nam12on2119.outbound.protection.outlook.com ([40.107.243.119]:43008
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229916AbhL3BnJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 20:43:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1qqyg6ak3hnNXONvBB1nlrEvz4DwoWek+10ZxFCSGSiKKVn2gxfkREJZ+9ftjX+F0iBmcWK172QxppQy4Krr5y6i9CncfLcc+N3U2Qk9jw+yL8e4u/sXx+ZUxL6x3b0CuXCQ4AxQZk4CMXkY322lc4UDvobF3/cz18rIC8QqI4qYhnoEWbBOEkjtUpecwSuWgG0zfICsTck8EQZaEyuPy0zrvb0PYpB2YPxaOdGbQUKWFFwoy3fHSrjZHQV2LNW5kri0jXFYL89vzJI6DQjgeMBQN1/4RVCS5IyTPooT3CZCWaQmtlrb2d79A636PlGVJm9gKwmdKoctRcydvwt9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QNKdRzo1qVFcwPL3fThM/Gi/YvjfjFVzJctpYST2FiI=;
 b=QQvYyAyCMn/2QAkXgf51bHz1iC5GKCCzyIb909m9gvBwweAjuiKAcAAwent1CYnEgDMziRuSOJfxEdoRYN/obxLu7pubpzAtlONY8+3pxr+W6oC67TFC90HA+j+JM5lwiBUfUwIptlkEAgts+0fidv5cKT0LT6R2y/yCHlOg604AY8hVK5lPuHZ2pQ3Jm6q6W/vPXmx+JntlY2qEgvqgxfGswVZFd6r1643ACACd//Jz+Hv1kDj8YvSRDVKolkNPTqkxB+cd/Rd3IHd8DCaQ1RRORecWsy5qV0SY7Ulu4PN2LKZdNSF2+XOGonNa1rvbdyjct5uRBUmAIX3mDNA+Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNKdRzo1qVFcwPL3fThM/Gi/YvjfjFVzJctpYST2FiI=;
 b=o73d/EBP1M2RyIUKzZHEQbP2dG4njMbzzCBLxadu4p2W5zEqtFMFrme2FMPm5sGxJWfGiuwXw//u10AqoCt94oI9jhEUjo/BidOcIxr0qjlJeiAAnPIzzvzTYqy3RaBUB9av8zeE++Ynh2Ns99syQZAa8VWTwaE/IxWlKJ6y7dM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1598.namprd10.prod.outlook.com
 (2603:10b6:300:2a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 30 Dec
 2021 01:43:06 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4844.014; Thu, 30 Dec 2021
 01:43:06 +0000
Date:   Wed, 29 Dec 2021 17:43:00 -0800
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
Message-ID: <20211230014300.GA1347882@euler>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
 <20211218214954.109755-2-colin.foster@in-advantage.com>
 <Ycx9MMc+2ZhgXzvb@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ycx9MMc+2ZhgXzvb@google.com>
X-ClientProxiedBy: MWHPR15CA0031.namprd15.prod.outlook.com
 (2603:10b6:300:ad::17) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79932842-a889-49c8-3e32-08d9cb35b96c
X-MS-TrafficTypeDiagnostic: MWHPR10MB1598:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB15983AE233DD0A63D15DCA6CA4459@MWHPR10MB1598.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d/EUuc7LuPG+tnRG5piBEC264kArjPel7JCl2/jLw185R3ryTmhuoZCIl430VWzwAZ+4nmwKjwQNiWeQM7QAtcK9lt9//rEBTvvtSGMwRl5NHafStmOKTIm2V5HAKQOUhpzv8oj/2oyfORw4yZOh+5Yg3hVbhzmtXOXWpFf3WGVRyf7yXo15heVrHjDAnlcrAal/eSWI55zb9RwLfRytP0i/3DMfABASJF9PpdzwuHx9hzP/OFxSOPAblJmMiGAg43fzNxnF3MKKJM/iDVKkuDSPzrPDR53FQ/LALSNyC/hi7EgmciTcoRLnrNxadOf8zNIrp7wttPS+lgrLGg1wP/PWiVTBB0KFAnwI6iFIc2hriqcHKCzFWPLLmjflywfDM0g+gNJlqvgzgxnXZmAVTXpwFytcKkFlYWNkdJFWTO07ff1kaM3ELIF3/pyPUbrC1PwkDtSh/gaRJgcDdsgzOmTtNcyNHF0oTt89+HSBnhH6vQU+nG8V+VASDyBs15PWqhs0CscxmdL1y0n4mS2FFbwd2jwI8sb4Bkt238fNzYRURalPzYkY6liMH6Lj6wmvkFXtciTci4vWb+GbVrkfkx7iPnZnTi0PXk9zQ/dO+IBfzDaBLpkMyeipcM1FTvWvu70jFdxfbJsZnJuXi+bwMgbp+WvyCMHrNkG2PQ3dCSkzH/QSzhua3cU/2MaR51Mln8XB9MsmH31CeeOdwWTmYRTgLuI2EJjSHJbLLv3l3upk4cHi198a/gNckOyrY121TY4xvEwyQjFW9pYhjCZ0Nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(396003)(136003)(366004)(376002)(346002)(39830400003)(42606007)(54906003)(2906002)(8936002)(86362001)(52116002)(508600001)(8676002)(6916009)(30864003)(966005)(1076003)(26005)(316002)(186003)(4326008)(38100700002)(5660300002)(44832011)(7416002)(38350700002)(6486002)(6666004)(6506007)(66476007)(66556008)(9686003)(6512007)(33716001)(66946007)(83380400001)(33656002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qy9YMjBnMWNlRHVXNVFKbXA3S1c2WnFSOEw1RFFpNTdORnQ1eFg3UlVOa1FO?=
 =?utf-8?B?eW1uU1FvZkRDeDJXQjJuWFd0QkNJK1Y3WEFidzBQaHdSdUVOc2ZvZkVCTXJn?=
 =?utf-8?B?Q0dpZ0wyend2cWU5NFpSQzdjaW1ycmMvK1FrOFVTaGNlUmxvaDJqSUgwaUNC?=
 =?utf-8?B?dEp3QkhtOGN0RnRaMWJQeUhxWG8vUFpWUU1ncDZ6MHJRTFpMOEEyMWl5SnFw?=
 =?utf-8?B?ejV3b0tBNTExb0dCTzdQMEExQkNkVHVoSUVrQ1BEVDdUOGdlUGdvVnlBd1BN?=
 =?utf-8?B?MjVoVDlvb0orWTgwRTZseUpDQVdvd0RENlJTTGlKbUpDM1haSStkNmQ1YWtK?=
 =?utf-8?B?bXJVTFdCTTdKUEdtNHZqa0FrTkJjQ29aRWxYY2RJSVNQN0k4b2tTUnkzSW40?=
 =?utf-8?B?VzNCUExUNWhOU2lacFRrMEw3Y3BPRkh1T0g3Q0FMeno0R2VuaGNRbk83Q0ky?=
 =?utf-8?B?SDhHcWQzT2Izdy9GZzV6YXNzQnptWkpoa3BvQ2hzK3hXY2c3MkhwNzloeGpG?=
 =?utf-8?B?cVFKVDRMZmZvMlJzeng4ZTFxdkd5NHJPZ01OSytPdjRicEo1d01oQ0dVM1ZG?=
 =?utf-8?B?MXc5alR2T04wVU5aa09UeENtZzdINmxrbVdub1YzVHJCdVRsS3M4SE5GM2hZ?=
 =?utf-8?B?b2gycW1ic3lJSVAvMFFZLy9WK3JtREJsczZhYVVVTFlQZDlXS3g1MHJCRzhs?=
 =?utf-8?B?Y1phR2F0a3BLMGNURWwzTmtmMmI4akJ6T1VSajFsUkY0WmMyTCtIcndSNlRi?=
 =?utf-8?B?V2x0ZXljMGVELzU2Wk01SkIyd25kRktwbXVOSFpJcm1rV0JUbUtPWkZKRWxN?=
 =?utf-8?B?VTVONXVScTdLNU1MZ2MyZ1NlNFdqemwyT1d0TEtpZitzRXMzQ3RjN1V2bUpJ?=
 =?utf-8?B?TjhUd1VVNmhZWjdiOWxpdFhMMHJnUnB4UjRNVnhha1I0ckd3N3lETThGN05X?=
 =?utf-8?B?UlF0Qk5kcWJaZzhKWDZLV0JlYnpRVnd1WFVkckNSdDgvcXRMbDBQZlphNExT?=
 =?utf-8?B?eWNNd2RLUTZhU2RpYk1xMXdqU09LT1RXRElNMmNPcklaY3FYL2kvTHZ2QXhR?=
 =?utf-8?B?MWRKVU01eFAwMjlqd3hlZWdqNDFNZDVpdlNEMFRJNXl1UjR5UFZBQ1REUEww?=
 =?utf-8?B?eTVvbVcyamQyN212U1I3WDRncjhCZkhVLzY2OFdKblF4WnJneDJiQnBFODhO?=
 =?utf-8?B?NGlyMC9TT3MvakxLN0UvUVZXcWRlQ0xpb01FYy9jZytRbk1kb0wwOHRVdkl1?=
 =?utf-8?B?TTdpMnhQRWlGWGlLOFE4YWVIcWJPRUFQTDU0cEtUbjdJQXcvRFUxV05aUVF4?=
 =?utf-8?B?RmM2YlZxZzcrdFliSEthRXZBRTdXcTBRYjZ0VitsdldJdzRaSVZaeTh5VEFE?=
 =?utf-8?B?MTVCZUpISEFxZVprOWREajU4aDNSZ09CZm8wQmhzV0IwbUxMcU9iWHZSNmI2?=
 =?utf-8?B?dUpsaFg0Qi9yR3RUME1QQjVITWc1VnNjZ3BIZUhwZzYzd0VLUFdjQ2hwU0Fa?=
 =?utf-8?B?dFl3SThDcXNCRzl2TVNmYk1zek5LRXRHVVNrMDdMbENLVVJIRlZFNVlqa0cx?=
 =?utf-8?B?N1dKcFNJVmJyeEtEZ3J4N3M0Zkd6SUZpQ1lnL045WmVtVUN2TExvYkRFODdZ?=
 =?utf-8?B?RERRYmlDZmdoMXNLVDBCSnBFWXR1ZTh4OHFnNmZqcWwvTUlXNHFzVlA3R0Uz?=
 =?utf-8?B?MUV4T25BWS9KU2RWQlEwNDdPZ1NLNUx3ZFBveGVHZnk4blJrUko5QnFUYi9Q?=
 =?utf-8?B?bVFFQ3pEZDJLUFhXSWRRcUpSSnNpam8renFCZnV4eEdSSE1XTGtuSm1JY3FU?=
 =?utf-8?B?bks4NVFHdVVTMHgrMTdTcldKSHJqekFUVVVrVHcrUDVWUlRHclM0dzFuVWtp?=
 =?utf-8?B?eGhoMSsxYkswdFlzNUtOYUdKenpRcit0Q2R4cm1wT1E2L0IrN29TTExOeUdT?=
 =?utf-8?B?YjBOMExDRDU1dlNoQ1A4S2htK3BlVk5YcXNQZW1USjRHUWs4WmxUTytySkg5?=
 =?utf-8?B?dTZ2T1pzYWh1aktwQnA5eDdQY0lHRHVIMVJGVnhTYnFjNHIvaytUcWk2Wkx6?=
 =?utf-8?B?L0ZlYTVBREVIY2lLU1poMUVLSlVCNG9qekhmT3U5bUM1SXpiMkw5d1JkY29o?=
 =?utf-8?B?aS8zbGRwZzQzMktOdHhMN1VTbmVpSnZReEpHTVhkM2hkR3BvY204OGxneHFk?=
 =?utf-8?B?bk03d3N4azlNUE1aMnFWUVJTNFdhbnVhVXJXTk43SHdTclg5eGNPdldtMEdy?=
 =?utf-8?Q?A1zcCwAuCO1wX4hWO0JyzzDxbbB6fE1ArRhQ6autL0=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79932842-a889-49c8-3e32-08d9cb35b96c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2021 01:43:05.8594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fs6rIV2QzWrLilvDJ92ZQ2WLb4/Xlncn7L9JskHCHOziLO4pda6MvmFSlUH3+WbEOPrH/Zaop6u9qduUEb+SaYdr4i0WriIcTt8XjwhWFWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1598
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 03:22:24PM +0000, Lee Jones wrote:
> On Sat, 18 Dec 2021, Colin Foster wrote:
> 
> > Create a single SPI MFD ocelot device that manages the SPI bus on the
> > external chip and can handle requests for regmaps. This should allow any
> > ocelot driver (pinctrl, miim, etc.) to be used externally, provided they
> > utilize regmaps.

Hi Lee,

Thanks for your feedback.

> 
> We're going to need Mark Brown to have a look at this Regmap implementation.
> 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  drivers/mfd/Kconfig       |  15 ++
> >  drivers/mfd/Makefile      |   3 +
> >  drivers/mfd/ocelot-core.c | 149 +++++++++++++++
> >  drivers/mfd/ocelot-mfd.h  |  19 ++
> 
> Drop the '-mfd' part please.

Done. 

> 
> >  drivers/mfd/ocelot-spi.c  | 374 ++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 560 insertions(+)
> >  create mode 100644 drivers/mfd/ocelot-core.c
> >  create mode 100644 drivers/mfd/ocelot-mfd.h
> >  create mode 100644 drivers/mfd/ocelot-spi.c
> > 
> > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > index 3fb480818599..af76c9780a10 100644
> > --- a/drivers/mfd/Kconfig
> > +++ b/drivers/mfd/Kconfig
> > @@ -954,6 +954,21 @@ config MFD_MENF21BMC
> >  	  This driver can also be built as a module. If so the module
> >  	  will be called menf21bmc.
> >  
> > +config MFD_OCELOT_CORE
> 
> You can drop the "_CORE" part.

Done. The idea here though was taken after the madera driver, since it
seemed fairly recent and does what I expect this Ocelot driver to end up
doing - allow control over either SPI or I2C.

> 
> > +	tristate "Microsemi Ocelot External Control Support"
> > +	select MFD_CORE
> > +	help
> > +	  Say yes here to add support for Ocelot chips (VSC7511, VSC7512,
> > +	  VSC7513, VSC7514) controlled externally.
> 
> Please describe the device in more detail here.
> 
> I'm not sure what an "External Control Support" is.

A second paragraph "All four of these chips can be controlled internally
(MMIO) or externally via SPI, I2C, PCIe. This enables control of these
chips over one or more of these buses"

> 
> > +config MFD_OCELOT_SPI
> > +	tristate "Microsemi Ocelot SPI interface"
> > +	depends on MFD_OCELOT_CORE
> > +	depends on SPI_MASTER
> > +	select REGMAP_SPI
> > +	help
> > +	  Say yes here to add control to the MFD_OCELOT chips via SPI.
> > +
> >  config EZX_PCAP
> >  	bool "Motorola EZXPCAP Support"
> >  	depends on SPI_MASTER
> > diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> > index 0b1b629aef3e..dff83f474fb5 100644
> > --- a/drivers/mfd/Makefile
> > +++ b/drivers/mfd/Makefile
> > @@ -120,6 +120,9 @@ obj-$(CONFIG_MFD_MC13XXX_I2C)	+= mc13xxx-i2c.o
> >  
> >  obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
> >  
> > +obj-$(CONFIG_MFD_OCELOT_CORE)	+= ocelot-core.o
> > +obj-$(CONFIG_MFD_OCELOT_SPI)	+= ocelot-spi.o
> > +
> >  obj-$(CONFIG_EZX_PCAP)		+= ezx-pcap.o
> >  obj-$(CONFIG_MFD_CPCAP)		+= motorola-cpcap.o
> >  
> > diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> > new file mode 100644
> > index 000000000000..a65619a8190b
> > --- /dev/null
> > +++ b/drivers/mfd/ocelot-core.c
> > @@ -0,0 +1,149 @@
> > +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> > +/*
> > + * Copyright 2021 Innovative Advantage Inc.
> 
> Author?
> 
> Short device description?

Added. 

> 
> > + */
> > +
> > +#include <asm/byteorder.h>
> 
> These, if required, usually go at the bottom.

Moved between regmap and ocelot.h

> 
> > +#include <linux/spi/spi.h>
> > +#include <linux/kconfig.h>
> 
> What's this for?

Both were left over from my initial "DSA" implementation that had all
this lumped together. They only belong in ocelot-spi.c, and I didn't
remove them here. Thanks for catching these!

> 
> > +#include <linux/module.h>
> > +#include <linux/regmap.h>
> 
> These should be alphabetical.
> 
> > +#include "ocelot-mfd.h"
> > +
> > +#define REG(reg, offset)	[reg] = offset
> 
> What does this save, really?

Fair point. This was done for consistency with other ocelot
drivers that use the upper bits in the enumeration as a separate index.
Specifically the enumeration in include/soc/mscc/ocelot.h and
drivers/net/ethernet/mscc/vsc7514_regs.c. It has no other benefit than
just that, and I have no problem removing it if that's desired.

> 
> > +enum ocelot_mfd_gcb_regs {
> 
> Please remove the term 'mfd\|MFD' from everywhere.

"ocelot_init" conflicts with a symbol in
drivers/net/ethernet/mscc/ocelot.o, otherwise I belive I got them all
now.

> 
> > +	GCB_SOFT_RST,
> > +	GCB_REG_MAX,
> > +};
> > +
> > +enum ocelot_mfd_gcb_regfields {
> > +	GCB_SOFT_RST_CHIP_RST,
> > +	GCB_REGFIELD_MAX,
> > +};
> > +
> > +static const u32 vsc7512_gcb_regmap[] = {
> > +	REG(GCB_SOFT_RST,	0x0008),
> > +};
> > +
> > +static const struct reg_field vsc7512_mfd_gcb_regfields[GCB_REGFIELD_MAX] = {
> > +	[GCB_SOFT_RST_CHIP_RST] = REG_FIELD(vsc7512_gcb_regmap[GCB_SOFT_RST], 0, 0),
> > +};
> > +
> > +struct ocelot_mfd_core {
> > +	struct ocelot_mfd_config *config;
> > +	struct regmap *gcb_regmap;
> > +	struct regmap_field *gcb_regfields[GCB_REGFIELD_MAX];
> > +};
> 
> Not sure about this at all.
> 
> Which driver did you take your inspiration from?

Mainly drivers/net/dsa/ocelot/* and drivers/net/ethernet/mscc/*.

> 
> > +static const struct resource vsc7512_gcb_resource = {
> > +	.start	= 0x71070000,
> > +	.end	= 0x7107022b,
> 
> No magic numbers please.

I've gotten conflicting feedback on this. Several of the ocelot drivers
(drivers/net/dsa/ocelot/felix_vsc9959.c) have these ranges hard-coded.
Others (Documentation/devicetree/bindings/net/mscc-ocelot.txt) have them
all passed in through the device tree. 

https://lore.kernel.org/netdev/20211126213225.okrskqm26lgprxrk@skbuf/

> 
> > +	.name	= "devcpu_gcb",
> 
> What is a 'devcpu_gcb'?

It matches the datasheet of the CPU's general configuation block.

> 
> > +};
> > +
> > +static int ocelot_mfd_reset(struct ocelot_mfd_core *core)
> > +{
> > +	int ret;
> > +
> > +	dev_info(core->config->dev, "resetting ocelot chip\n");
> 
> These types of calls are not useful in production code.

Removed.

> 
> > +	ret = regmap_field_write(core->gcb_regfields[GCB_SOFT_RST_CHIP_RST], 1);
> 
> No magic numbers please.  I have no idea what this is doing.

I'm not sure how much more verbose it can be... I suppose a define for
"RESET" and "CLEAR" instead of "1" and "0" on that bit. Maybe I'm just
blinded by having stared at this code for the last several months.

> 
> > +	if (ret)
> > +		return ret;
> > +
> > +	/*
> > +	 * Note: This is adapted from the PCIe reset strategy. The manual doesn't
> > +	 * suggest how to do a reset over SPI, and the register strategy isn't
> > +	 * possible.
> > +	 */
> > +	msleep(100);
> > +
> > +	ret = core->config->init_bus(core->config);
> 
> You're not writing a bus.  I doubt you need ops call-backs.

In the case of SPI, the chip needs to be configured both before and
after reset. It sets up the bus for endianness, padding bytes, etc. This
is currently achieved by running "ocelot_spi_init_bus" once during SPI
probe, and once immediately after chip reset.

For other control mediums I doubt this is necessary. Perhaps "init_bus"
is a misnomer in this scenario...

> 
> > +	if (ret)
> > +		return ret;
> > +
> > +	return 0;
> > +}
> > +
> > +void ocelot_mfd_get_resource_name(char *name, const struct resource *res,
> > +				  int size)
> > +{
> > +	if (res->name)
> > +		snprintf(name, size - 1, "ocelot_mfd-%s", res->name);
> > +	else
> > +		snprintf(name, size - 1, "ocelot_mfd@0x%08x", res->start);
> > +}
> > +EXPORT_SYMBOL(ocelot_mfd_get_resource_name);
> 
> What is this used for?
> 
> You should not be hand rolling device resource names like this.
> 
> This sort of code belongs in the bus/class API.
> 
> Please use those instead.

The idea here was to allow shared regmaps across different devices. The
"devcpu_gcb" might be used in two ways - either everyone shares the same
regmap across the "GCB" range, or everyone creates their own. 

This was more useful when the ocelot-core.c had a copy of the 
"devcpu_org" regmap that was shared with ocelot-spi.c. I was able to
remove that, but also feel like the full switch driver (patch 6 of this
set) ocelot-ext should use the same "devcpu_gcb" regmap instance as
ocelot-core does.

Admittedly, there are complications. There should probably be more
checks added to "ocelot_regmap_init" / "get_regmap" to ensure that the
regmap for ocelot_ext exactly matches the existing regmap for
ocelot_core.

There's yet another complexity with these, and I'm not sure what the
answer is. Currently all regmaps are tied to the ocelot_spi device...
ocelot_spi calls devm_regmap_init. So those regmaps hang around if
they're created by a module that has been removed. At least until the
entire MFD module is removed. Maybe there's something I haven't seen yet
where the devres or similar has a reference count. I don't know the best
path forward on this one.

> 
> > +static struct regmap *ocelot_mfd_regmap_init(struct ocelot_mfd_core *core,
> > +					     const struct resource *res)
> > +{
> > +	struct device *dev = core->config->dev;
> > +	struct regmap *regmap;
> > +	char name[32];
> > +
> > +	ocelot_mfd_get_resource_name(name, res, sizeof(name) - 1);
> > +
> > +	regmap = dev_get_regmap(dev, name);
> > +
> > +	if (!regmap)
> > +		regmap = core->config->get_regmap(core->config, res, name);
> > +
> > +	return regmap;
> > +}
> > +
> > +int ocelot_mfd_init(struct ocelot_mfd_config *config)
> > +{
> > +	struct device *dev = config->dev;
> > +	const struct reg_field *regfield;
> > +	struct ocelot_mfd_core *core;
> > +	int i, ret;
> > +
> > +	core = devm_kzalloc(dev, sizeof(struct ocelot_mfd_config), GFP_KERNEL);
> > +	if (!core)
> > +		return -ENOMEM;
> > +
> > +	dev_set_drvdata(dev, core);
> > +
> > +	core->config = config;
> > +
> > +	/* Create regmaps and regfields here */
> > +	core->gcb_regmap = ocelot_mfd_regmap_init(core, &vsc7512_gcb_resource);
> > +	if (!core->gcb_regmap)
> > +		return -ENOMEM;
> > +
> > +	for (i = 0; i < GCB_REGFIELD_MAX; i++) {
> > +		regfield = &vsc7512_mfd_gcb_regfields[i];
> > +		core->gcb_regfields[i] =
> > +			devm_regmap_field_alloc(dev, core->gcb_regmap,
> > +						*regfield);
> > +		if (!core->gcb_regfields[i])
> > +			return -ENOMEM;
> > +	}
> > +
> > +	/* Prepare the chip */
> > +	ret = ocelot_mfd_reset(core);
> > +	if (ret) {
> > +		dev_err(dev, "ocelot mfd reset failed with code %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	/* Create and loop over all child devices here */
> 
> These need to all go in now please.

I'll squash them, as I saw you suggested in your other responses. I
tried to keep them separate, especially since adding ocelot_ext to this
commit (which has no functionality until this one) makes it quite a
large single commit. That's why I went the path I did, which was to roll
them in one at a time.

> 
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(ocelot_mfd_init);
> > +
> > +int ocelot_mfd_remove(struct ocelot_mfd_config *config)
> > +{
> > +	/* Loop over all children and remove them */
> 
> Use devm_* then you won't have to.

Yeah, I was more worried than I needed to be when I wrote that comment.
The only thing called to clean everything up is mfd_remove_devices();

> 
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(ocelot_mfd_remove);
> > +
> > +MODULE_DESCRIPTION("Ocelot Chip MFD driver");
> > +MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
> > +MODULE_LICENSE("GPL v2");
> > diff --git a/drivers/mfd/ocelot-mfd.h b/drivers/mfd/ocelot-mfd.h
> > new file mode 100644
> > index 000000000000..6af8b8c5a316
> > --- /dev/null
> > +++ b/drivers/mfd/ocelot-mfd.h
> > @@ -0,0 +1,19 @@
> > +/* SPDX-License-Identifier: GPL-2.0 OR MIT */
> > +/*
> > + * Copyright 2021 Innovative Advantage Inc.
> > + */
> > +
> > +#include <linux/regmap.h>
> > +
> > +struct ocelot_mfd_config {
> > +	struct device *dev;
> > +	struct regmap *(*get_regmap)(struct ocelot_mfd_config *config,
> > +				     const struct resource *res,
> > +				     const char *name);
> > +	int (*init_bus)(struct ocelot_mfd_config *config);
> 
> Please re-work and delete this 'config' concept.
> 
> See other drivers in this sub-directory for reference.

Do you have a specific example? I had focused on madera for no specific
reason. But I really dislike the idea of throwing all of the structure
definition for the MFD inside of something like
"include/linux/mfd/ocelot/core.h", especially since all the child
drivers (madera-pinctrl, madera-gpio, etc) heavily rely on this struct. 

It seemed to me that without the concept of
"mfd_get_regmap_from_resource" this sort of back-and-forth was actually
necessary.

> 
> > +};
> > +
> > +void ocelot_mfd_get_resource_name(char *name, const struct resource *res,
> > +				  int size);
> > +int ocelot_mfd_init(struct ocelot_mfd_config *config);
> > +int ocelot_mfd_remove(struct ocelot_mfd_config *config);
> > diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
> > new file mode 100644
> > index 000000000000..65ceb68f27af
> > --- /dev/null
> > +++ b/drivers/mfd/ocelot-spi.c
> > @@ -0,0 +1,374 @@
> > +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> > +/*
> > + * Copyright 2021 Innovative Advantage Inc.
> 
> As above.
> 
> > + */
> > +
> > +#include <asm/byteorder.h>
> > +#include <linux/spi/spi.h>
> > +#include <linux/iopoll.h>
> > +#include <linux/kconfig.h>
> > +#include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/regmap.h>
> 
> As above.

Done.

> > +static int ocelot_spi_probe(struct spi_device *spi)
> > +{
> > +	struct ocelot_spi *ocelot_spi;
> > +	struct device *dev;
> > +	char name[32];
> > +	int err;
> > +
> > +	dev = &spi->dev;
> 
> Put this on the declaration line.
> 
> > +	ocelot_spi = devm_kzalloc(dev, sizeof(struct ocelot_spi),
> 
> sizeof(*ocelot_spi)
> 
> > +				      GFP_KERNEL);
> > +
> 
> No '\n'.

Done. I must've changed a variable name and missed this one. Oops.

> 
> > +	if (!ocelot_spi)
> > +		return -ENOMEM;
> > +
> > +	if (spi->max_speed_hz <= 500000) {
> > +		ocelot_spi->spi_padding_bytes = 0;
> > +	} else {
> > +		/*
> > +		 * Calculation taken from the manual for IF_CFGSTAT:IF_CFG. Err
> > +		 * on the side of more padding bytes, as having too few can be
> > +		 * difficult to detect at runtime.
> > +		 */
> > +		ocelot_spi->spi_padding_bytes = 1 +
> > +			(spi->max_speed_hz / 1000000 + 2) / 8;
> 
> Please explain what this means or define the values (or both).

I can certainly elaborate the comment. Searching the manual for the term
"if_cfgstat" will take you right to the equation, and a description of
what padding bytes are, etc. 

> 
> > +	}
> > +
> > +	ocelot_spi->spi = spi;
> 
> Why are you saving this?

This file keeps the regmap_{read,write} implementations, so is needed
for spi_sync() for any regmap. There might be a better way to infer
this... but it seemed pretty nice to have each regmap only carry along
an instance of "ocelot_spi_regmap_context."

> 
> > +	ocelot_spi->map = vsc7512_dev_cpuorg_regmap;
> 
> Why not just set up the regmap here?

I think this was fairly unclear, and that is my fault. I have updated 
the header of this file to better explain its purpose.

Basically ocelot-spi is not much more than an interface by which others
can get regmaps. It handles the low-level protocols (endianness, padding
bytes, address translation...) and leaves everything else to the
children.

So when a VSC7511/7513 comes on line, it will probably need to dish out 5
regmaps for just net ports. If it is a 7512/7514, it would probably need
to dish out 11. If PTP is desired... another regmap. Pinctrl, SGPIO,
MDIO... All those are either separate regmaps, shared regmaps, or 
sub-regmaps. Likely occupying either overlapping or identical regions.

"ocelot-spi" is designed to not care about those features. And
"ocelot-core" really isn't either. It is mostly a conduit to say
"here's your regmap" and be on it's merry way.

> 
> > +	spi->bits_per_word = 8;
> > +
> > +	err = spi_setup(spi);
> > +	if (err < 0) {
> > +		dev_err(&spi->dev, "Error %d initializing SPI\n", err);
> 
> The error code usually comes at the end.
> 
> > +		return err;
> > +	}
> > +
> > +	dev_info(dev, "configured SPI bus for speed %d, rx padding bytes %d\n",
> > +			spi->max_speed_hz, ocelot_spi->spi_padding_bytes);
> 
> When would this be useful?
> 
> Don't we already have debug interfaces to find this out?

Padding bytes, no. If someone were to put a scope on the SPI lines this
message is likely helpful to see what might be going on. The expectation
would be (from memory) 3 address bytes, followed by spi_padding_bytes of 
0x88888888, then the actual data.

That said, I won't lose any sleep if this one gets cut.

> 
> > +	/* Ensure we have devcpu_org regmap before we call ocelot_mfd_init */
> 
> because ...

That isn't clear. I'm fixing the comment.

Children of ocelot_mfd might require the "dev_cpuorg" regmap region. By
having this region named and registered to the device, child devices
don't need to allocate new regmaps, they can benefit from
dev_get_regmap()

> 
> > +	ocelot_mfd_get_resource_name(name, &vsc7512_dev_cpuorg_resource,
> > +				     sizeof(name) - 1);
> 
> This is an ugly interface.  I think it needs to go.

I agree that it is an ugly interface. It is only exposed so that
ocelot_spi can get the same regmap name as ocelot_mfd->children. It
isn't much better than hard-coding the name. But if I give up the idea
that children can share this regmap, I can take away this interface and
have it not be linked to ocelot_mfd.

> 
> > +	/*
> > +	 * Since we created dev, we know there isn't a regmap, so create one
> > +	 * here directly.
> > +	 */
> 
> Sorry, what 'dev'?  When did we create that?

Unclear comment. 

"Since this is a newly probed device, we know it doesn't have a regmap
so a call to dev_get_regmap isn't necessary - just create it"

> 
> > +	ocelot_spi->cpuorg_regmap =
> > +		ocelot_spi_get_regmap(&ocelot_spi->config,
> > +				      &vsc7512_dev_cpuorg_resource, name);
> > +	if (!ocelot_spi->cpuorg_regmap)
> > +		return -ENOMEM;
> > +
> > +	ocelot_spi->config.init_bus = ocelot_spi_init_bus_from_config;
> > +	ocelot_spi->config.get_regmap = ocelot_spi_get_regmap;
> > +	ocelot_spi->config.dev = dev;
> 
> Please remove this API.

I might need to look at this more. But get_regmap is the main purpose of
ocelot-spi, and init_bus is a necessary call for any SPI communication
after a chip reset. Should I2C, or even MMIO be added, it can be done
without modification to ocelot-core.

> 
> > +	spi_set_drvdata(spi, ocelot_spi);
> > +
> > +	/*
> > +	 * The chip must be set up for SPI before it gets initialized and reset.
> > +	 * Do this once here before calling mfd_init
> > +	 */
> > +	err = ocelot_spi_init_bus(ocelot_spi);
> > +	if (err) {
> > +		dev_err(dev, "Error %d initializing Ocelot SPI bus\n", err);
> 
> Doesn't this already print out an error message?

In some cases ocelot_spi_init_bus does. I don't know about whether a
err return from spi_driver->probe does or not.

> 
> > +		return err;
> > +	}
> > +
> > +	err = ocelot_mfd_init(&ocelot_spi->config);
> > +	if (err < 0) {
> > +		dev_err(dev, "Error %d initializing Ocelot MFD\n", err);
> > +		return err;
> > +	}
> > +
> > +	dev_info(&spi->dev, "ocelot spi mfd probed\n");
> 
> Please, remove all of these.

Done

> 
> > +	return 0;
> > +}
> > +
> > +static int ocelot_spi_remove(struct spi_device *spi)
> > +{
> > +	struct ocelot_spi *ocelot_spi;
> > +
> > +	ocelot_spi = spi_get_drvdata(spi);
> > +	devm_kfree(&spi->dev, ocelot_spi);
> 
> Why use devm_* if you're going to free anyway?

Good point. It looks like none of this remove is necessary.

> 
> > +	return 0;
> > +}
> > +
> > +const struct of_device_id ocelot_mfd_of_match[] = {
> > +	{ .compatible = "mscc,vsc7514_mfd_spi" },
> > +	{ .compatible = "mscc,vsc7513_mfd_spi" },
> > +	{ .compatible = "mscc,vsc7512_mfd_spi" },
> > +	{ .compatible = "mscc,vsc7511_mfd_spi" },
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(of, ocelot_mfd_of_match);
> > +
> > +static struct spi_driver ocelot_mfd_spi_driver = {
> > +	.driver = {
> > +		.name = "ocelot_mfd_spi",
> > +		.of_match_table = of_match_ptr(ocelot_mfd_of_match),
> > +	},
> > +	.probe = ocelot_spi_probe,
> > +	.remove = ocelot_spi_remove,
> > +};
> > +module_spi_driver(ocelot_mfd_spi_driver);
> > +
> > +MODULE_DESCRIPTION("Ocelot Chip MFD SPI driver");
> > +MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
> > +MODULE_LICENSE("Dual MIT/GPL");
> 
> -- 
> Lee Jones [李琼斯]
> Senior Technical Lead - Developer Services
> Linaro.org │ Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog
