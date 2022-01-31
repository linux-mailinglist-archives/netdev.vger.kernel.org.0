Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8E14A4D3F
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 18:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380965AbiAaR3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 12:29:30 -0500
Received: from mail-mw2nam10on2128.outbound.protection.outlook.com ([40.107.94.128]:20928
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236516AbiAaR31 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 12:29:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oL8dBjjt8NQQCcXZuQxokVT+FW4B3LcmBOCAqzyHTSNus8TDxcdQuKlA/zCmd4dwVJpGy+15GSiziDOtGzblYo3dfZdCeS4ffwsJJVhZkq5VCTGKT3bYoVDHD+6hC80/HPSH3lU0W33uj8v9zT2KsGP9eg8F9aALrmIsZtoiEOln1d5lysI96/mC3xbxuurb24PNMnhxZEN9WwZNu8TI1dYVPx4XEmAyzY3qRpHw6V4DDmzYL8PROCMp1GVLsu0cf6FxbZ1GwoeZUiiQaXQE6l+wOXGp0jC0Qxvvh4Nm2F3GwQLXAm7FfQvF38mEF6nQu45gSSBzIT5vi9cHjoGAvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xT6F293FvOWB/WlgvxTcSm2Hj3xQ002LoA2SNJCmUHk=;
 b=IRPTT/QnQEzNPUvTntWKLWqKqqd0VxstBAPmc2ZzI6/qrYbtHR+4upN9VHYkbGiYU2HRKvguVmBlLvwReOOI7Xw+EscUpP3S6BWQMJILVAtZrUHlKxVcxeKWeUfnc3aN+m2WZSV51iSuQHapIaxAo3BkHnqpckRW5dVuww/klBzV8P/tVWD+sYzylAakdIqzs+4ckFo3AUWwxVt2dy9X4kiaauoNzKIYeeRLugvb2QPO8mL667mGuy1+an3sQ1HzPVjVx0EJlZrdXJGE2RfvnkTgCapR8eJHL3pjMSypDuY6rkZKBfGRWMN6sF5HKcQDKZ7RnTOqTdNDySuGEdIl7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xT6F293FvOWB/WlgvxTcSm2Hj3xQ002LoA2SNJCmUHk=;
 b=yyKb5ZeSlowxJGaZid8zIStlxksZC0r9oIk5Qy0RqDG0EowgfC5wdoRD3AheXZgxuo3hj2ortD/+EooCBA+nQB0/283WEq1fPAAh5EexT3YV5+InMckEh9i/M6fpLHORpqX7r68jrNDNBOu2o7rmKngQ9EaB/VQQlHOh8doveIU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN6PR1001MB2178.namprd10.prod.outlook.com
 (2603:10b6:405:2e::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
 2022 17:29:23 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4930.020; Mon, 31 Jan 2022
 17:29:22 +0000
Date:   Mon, 31 Jan 2022 09:29:34 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
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
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        katie.morris@in-advantage.com
Subject: Re: [RFC v6 net-next 6/9] mfd: ocelot: add support for external mfd
 control over SPI for the VSC7512
Message-ID: <20220131172934.GB28107@COLIN-DESKTOP1.localdomain>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
 <20220129220221.2823127-7-colin.foster@in-advantage.com>
 <Yfer/qJmwRdShv4y@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yfer/qJmwRdShv4y@google.com>
X-ClientProxiedBy: MWHPR20CA0023.namprd20.prod.outlook.com
 (2603:10b6:300:13d::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99f4d1fe-352b-4fb5-c33e-08d9e4df386b
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2178:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1001MB2178408ACDC070FD58566757A4259@BN6PR1001MB2178.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zFVJQ6FMup+lxgQVe0+OfWmD1nYeGsw1gOGgv6EKz1hernSfy5w6crD6/SRDaeZ/NymI4jdGN3v/QFuGPBo0IzdMDLh9hYHOQGFY/y/hEjPdNJUongW36JEf+xkXzar1ux8YGbPX4v2b67VPyCaw/W5XOpe5aUITqcMgfyDEK+ckrJ9Wlsu4D9KLn7H7r8zkr/bMK942tOChSyeKzOOi7VlAovXtajzNL0FWk6XpaxsCA4FJTVlRj94WEtXv8cOwcvSopHF2Xz/blnKtMwhlBKWfdiFwPYu0T34P4QrN5VfZpyiGYSgDSYOO5KS5AZg1/LBhx2KKqT55p5ELp8bJRFml0KvE0+f/uQ7+0dvc4X90TKI9ruemxRk7DLyLXoFJu2NF49w1eFIzfmyilNitJWeGpwk/K2sOFBfE17FixPngE/0n67YmTqRw/tUEaeROOZxssXjd/D7ZH7jQ6C/1xekIqVO7avAHCcNG69vNlnKL80e5PpvDzI0yM1VAxgOWP4mY+iia2RkievsA70vbnjJqTjbZfurQS7OoZaWWmd4RlJXlOxVJLZ/R0+fkQ5sPz0XQ/LOube3RTiIxnfEIyV+VLgqMisH14f3yiVrqBkGRn6LVfBdx3Zby7xVy21noY5dFZpGe3LU2xyOxJ5s2FKQsbqOFCvrY4CTpjRegVz+ufGLVZCbDWFX1B5LsF8xrcjkokkItJl2kInJytgmoZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(42606007)(366004)(39830400003)(376002)(396003)(346002)(26005)(1076003)(186003)(38350700002)(6666004)(6486002)(38100700002)(5660300002)(508600001)(107886003)(9686003)(6506007)(86362001)(6512007)(52116002)(83380400001)(316002)(44832011)(54906003)(8936002)(4326008)(8676002)(66556008)(6916009)(66476007)(2906002)(66946007)(7416002)(33656002)(30864003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlpXUHprdktGZGZnU0MwSkZubysxcWc5cmxWdFI1ZFhPVkVjVkl5eGtodFkr?=
 =?utf-8?B?MEpJbGpWbmZSZ2I0RFZyckxjMm9WaEFDMUp0RWNaaythSFVDRlJqVVB1dkE1?=
 =?utf-8?B?bUdRWGdlUTBpekxWWGVOdFYyY2twdUxGSHAvbU1TVGNTNWhuMS8vVUNKWlRB?=
 =?utf-8?B?dWxWczdiOC9mSGxaY1I2Z1ZzVU15QkQ0dW5VVVZWOEZBb2ZXbS9YTFFYMEVL?=
 =?utf-8?B?M2VzL0lCOXN0czY1TnI4TlVmSGd3R0VhT1p3YmZSeTkrRWVnMlVNWDJBYU5v?=
 =?utf-8?B?YUpWVGRMZ1VOZ0VEU0paM0NuZDdGV2s3MlQ5Q0lLVUI2U3dMbU1IbldwM1JH?=
 =?utf-8?B?djJZL2x5NnA2QTZHRmgwaXhJR0ZsVjZTc2gxZGhnT2R1ZDJqSXFWSHF0ZjFo?=
 =?utf-8?B?M2pVdHBYdEp4eDZkWTY1aWY5Znh5ZzlYbyt5enhJYnpKbW9BZHcyM2gwR0d3?=
 =?utf-8?B?OGVhU0tuNnk4eFFLb1ZpUStYK3ROYXRSeGtVdklmbjhvYktycVdRemRjZ04w?=
 =?utf-8?B?S3JTWmVGYXVDb01hZjgyYWM3NjE4ZG1NbUtrZzFLZ1ZCMFJwTlljdEpnR1ZY?=
 =?utf-8?B?WVpNeXViYUhrVXlhUzl4QmlRck51TGxWUE1XY3k1VW1LZlQxNEZpRzVkWUpW?=
 =?utf-8?B?SGJtbVdRbGVPYmMrbUtzZkVZRzMrN2o1YzNBRnYvSGlQM3Y3YlJ1aDk2bmdq?=
 =?utf-8?B?SHdCbzdWVHM1TjNSN1huSHpsd3J6VnpHNitwU2EvVFF5WllzdUNYVHNNdGxt?=
 =?utf-8?B?QmdvUW5LV0xBUVlXclVhYTVmUG1nelVHWTc3My95aUkyeWdvb0g4SVFzc3Jj?=
 =?utf-8?B?NGZvZ2xjM0tPZStxZkRnVkF3WUVUWnF0cTlXR29kNHNpaTZwNVc0UWNvTXJw?=
 =?utf-8?B?dVRaUi9HK3F5dFFlc0VBOHk5WEFXeHF2eitjblRHS0w4TzM1Y1lZdEpkbGdG?=
 =?utf-8?B?eWxSQzY2Sy94NDh4cmFyZmJZd3UrVTc3Qjk5My9nNXpXZWhjTkorWlI1WEhS?=
 =?utf-8?B?SWxKN2trYlFzWXlsaXlCSXZDUTZmYmx2WUVRRlFrS2gzYXRlOXZVbUVRVVM5?=
 =?utf-8?B?TnVQS3hQZ0MyVFQ3dGxhQjRsVXl6d2N2TVRpUUdDNlNGMGxUQjVVMVFFVmg3?=
 =?utf-8?B?OUlFTWpocGVPSGRVaGF3Y09lQnF3NFF5bWtwcVl2Tk1Ld1pxY2FDOWtoYkYr?=
 =?utf-8?B?KzBvRFJTZ2ZFR05KWnV6VzlkSUg0Wld1QnNYd254MDFJWFNWbndYT0wvd1FT?=
 =?utf-8?B?aUIrY1F3Q0xLTVBsR1FYWldWQnIrb3R1elBKYllvMXV0WkdGN3pLZGxRa29M?=
 =?utf-8?B?VlJGT00yWjhqMi9sUnp5eFEwTi83elJ0dUN0UmJIcGgrNElxQ2hxZTcrV2pV?=
 =?utf-8?B?bmY4bEdNMmFuRDNMRFZHQnJ3RHVEQXJ0NDVRbjBOMUNPV3JVbHFQbi9DbFZm?=
 =?utf-8?B?S0l6SUxweXgwSkJNT0Y1SHVqakhHa3kxWWp2c2xEQnJLTDVKR2IyQ2dDc3JM?=
 =?utf-8?B?OUZFVUtiVDBhdEwzaG44K1Y4MTB5eDlNRFVmdys3UHI3bU5zU0hORDR0YTdQ?=
 =?utf-8?B?STBrY3p4N084WmlvL2llU1Yzdzh3VXlWSWtHZUxPL3V2aG82NVI4VXUyVk9L?=
 =?utf-8?B?OUx0Q1FYZGY4LzFWdE1SRVZvdDBxRUxtM0l0ZkV6QVpnVTlTTyttVURON1Q3?=
 =?utf-8?B?a1Bzd2xyd3lGS0RReFcwRDVUbU5ZZy9kMGZUcGtVNGYrVEhONG9USCt4eXlG?=
 =?utf-8?B?c3VKUUZnUE5WOEIyZHJPRk5BMzZaTERuSG9Za2VITnBXbm0rUWhHSGg5amhu?=
 =?utf-8?B?Y1pjZ0hxNUd3T3N1VW9zQllZVkxQdW1zdkdJaUhhVDkzY2JDZDZqNzZVblBS?=
 =?utf-8?B?S2VINWwwbzJhek5ONjQ3WFJxY2pJRHhQYTNNSlIwdC9qRlNQVG9TNko3dHEw?=
 =?utf-8?B?S0RyUHhZRk0xb00vVVdhcnFBd3NBRjFJeEtHK2VpYTRQSjZ5RTVrZ3JLU1Rs?=
 =?utf-8?B?V3hHZ2lHSkw1aDJ0b1RHa0JrSnJVSzIyeVUvVlJtajBKc0ZlMnhrNXYxTmNz?=
 =?utf-8?B?aG9PbGVDRERnclgxZGVjVGZTa0pZc2hGbTZXMFVndDFPQ2cvZkdKYy8vRjVF?=
 =?utf-8?B?NURHMmJ5bnFvb2FYbVhqTE1jKzZDM21USDJaeEZnMWFCS0phOW5pQVVVNlB2?=
 =?utf-8?B?UmwvSjRKazJUK0JOOWRTQktMdnV5QVhEVDJjbWJOcGM0UjVteU8zN04yajhj?=
 =?utf-8?B?Nm0vaFZSaEtkWlZ3dncvTks2dVdRPT0=?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99f4d1fe-352b-4fb5-c33e-08d9e4df386b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 17:29:22.8655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aobe0CbFM9cJdw7YGWCkNp9twKdbnxvdLv6PPy9DxYQLCM72w2AZGxzoir4GEi0Xun+cHlWKxTSRRnVngjPUq1g4VdC+A9kkIyfWHNvia54=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2178
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lee,

Thank you very much for your time / feedback.

On Mon, Jan 31, 2022 at 09:29:34AM +0000, Lee Jones wrote:
> On Sat, 29 Jan 2022, Colin Foster wrote:
> 
> > Create a single SPI MFD ocelot device that manages the SPI bus on the
> > external chip and can handle requests for regmaps. This should allow any
> > ocelot driver (pinctrl, miim, etc.) to be used externally, provided they
> > utilize regmaps.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  drivers/mfd/Kconfig                       |  19 ++
> >  drivers/mfd/Makefile                      |   3 +
> >  drivers/mfd/ocelot-core.c                 | 165 +++++++++++
> >  drivers/mfd/ocelot-spi.c                  | 325 ++++++++++++++++++++++
> >  drivers/mfd/ocelot.h                      |  36 +++
> 
> >  drivers/net/mdio/mdio-mscc-miim.c         |  21 +-
> >  drivers/pinctrl/pinctrl-microchip-sgpio.c |  22 +-
> >  drivers/pinctrl/pinctrl-ocelot.c          |  29 +-
> >  include/soc/mscc/ocelot.h                 |  11 +
> 
> Please avoid mixing subsystems in patches if at all avoidable.
> 
> If there are not build time dependencies/breakages, I'd suggest
> firstly applying support for this into MFD *then* utilising that
> support in subsequent patches.

My last RFC did this, and you had suggested to squash the commits. To
clarify, are you suggesting the MFD / Pinctrl get applied in a single
patch, then the MIIM get applied in a separate one? Because I had
started with what sounds like you're describing - an "empty" MFD with
subsequent patches rolling in each subsystem.

Perhaps I misinterpreted your initial feedback.

> 
> >  9 files changed, 614 insertions(+), 17 deletions(-)
> >  create mode 100644 drivers/mfd/ocelot-core.c
> >  create mode 100644 drivers/mfd/ocelot-spi.c
> >  create mode 100644 drivers/mfd/ocelot.h
> > 
> > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > index ba0b3eb131f1..57bbf2d11324 100644
> > --- a/drivers/mfd/Kconfig
> > +++ b/drivers/mfd/Kconfig
> > @@ -948,6 +948,25 @@ config MFD_MENF21BMC
> >  	  This driver can also be built as a module. If so the module
> >  	  will be called menf21bmc.
> >  
> > +config MFD_OCELOT
> > +	tristate "Microsemi Ocelot External Control Support"
> 
> Please explain exactly what an ECS is in the help below.

I thought I had by way of the second paragraph below. I'm trying to
think of what extra information could be of use at this point... 

I could describe how they have internal processors and using this level
of control would basically bypass that functionality.

> 
> > +	select MFD_CORE
> > +	help
> > +	  Say yes here to add support for Ocelot chips (VSC7511, VSC7512,
> > +	  VSC7513, VSC7514) controlled externally.
> > +
> > +	  All four of these chips can be controlled internally (MMIO) or
> > +	  externally via SPI, I2C, PCIe. This enables control of these chips
> > +	  over one or more of these buses.
> > +
> > +config MFD_OCELOT_SPI
> > +	tristate "Microsemi Ocelot SPI interface"
> > +	depends on MFD_OCELOT
> > +	depends on SPI_MASTER
> > +	select REGMAP_SPI
> > +	help
> > +	  Say yes here to add control to the MFD_OCELOT chips via SPI.
> > +
> >  config EZX_PCAP
> >  	bool "Motorola EZXPCAP Support"
> >  	depends on SPI_MASTER
> > diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> > index df1ecc4a4c95..12513843067a 100644
> > --- a/drivers/mfd/Makefile
> > +++ b/drivers/mfd/Makefile
> > @@ -120,6 +120,9 @@ obj-$(CONFIG_MFD_MC13XXX_I2C)	+= mc13xxx-i2c.o
> >  
> >  obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
> >  
> > +obj-$(CONFIG_MFD_OCELOT)	+= ocelot-core.o
> > +obj-$(CONFIG_MFD_OCELOT_SPI)	+= ocelot-spi.o
> > +
> 
> These do not look lined-up with the remainder of the file.

I'll fix that. Thanks.

> 
> >  obj-$(CONFIG_EZX_PCAP)		+= ezx-pcap.o
> >  obj-$(CONFIG_MFD_CPCAP)		+= motorola-cpcap.o
> >  
> > diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> > new file mode 100644
> > index 000000000000..590489481b8c
> > --- /dev/null
> > +++ b/drivers/mfd/ocelot-core.c
> > @@ -0,0 +1,165 @@
> > +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> > +/*
> > + * MFD core driver for the Ocelot chip family.
> > + *
> > + * The VSC7511, 7512, 7513, and 7514 can be controlled internally via an
> > + * on-chip MIPS processor, or externally via SPI, I2C, PCIe. This core driver is
> > + * intended to be the bus-agnostic glue between, for example, the SPI bus and
> > + * the MFD children.
> > + *
> > + * Copyright 2021 Innovative Advantage Inc.
> > + *
> > + * Author: Colin Foster <colin.foster@in-advantage.com>
> > + */
> > +
> > +#include <linux/mfd/core.h>
> > +#include <linux/module.h>
> > +#include <linux/regmap.h>
> > +
> > +#include <asm/byteorder.h>
> > +
> > +#include "ocelot.h"
> > +
> > +#define GCB_SOFT_RST (0x0008)
> 
> Why the brackets?
> 
> > +#define SOFT_CHIP_RST (0x1)
> 
> As above.

I'll remove them. No reason in particular. Seemingly the convention for
these types of macros are to use parentheses if there's an operation
involved, but not use them otherwise. Makes sense.

> 
> > +static const struct resource vsc7512_gcb_resource = {
> > +	.start	= 0x71070000,
> > +	.end	= 0x7107022b,
> 
> Please define these somewhere.
> 
> > +	.name	= "devcpu_gcb",
> > +};
> 
> There is a macro you can use for these.
> 
> Grep for "DEFINE_RES_"

Thanks. I didn't know about these. I'll macro these addresses and use
DEFINE_RES.

> 
> > +static int ocelot_reset(struct ocelot_core *core)
> > +{
> > +	int ret;
> > +
> > +	/*
> > +	 * Reset the entire chip here to put it into a completely known state.
> > +	 * Other drivers may want to reset their own subsystems. The register
> > +	 * self-clears, so one write is all that is needed
> > +	 */
> > +	ret = regmap_write(core->gcb_regmap, GCB_SOFT_RST, SOFT_CHIP_RST);
> > +	if (ret)
> > +		return ret;
> > +
> > +	msleep(100);
> > +
> > +	/*
> > +	 * A chip reset will clear the SPI configuration, so it needs to be done
> > +	 * again before we can access any more registers
> > +	 */
> > +	ret = ocelot_spi_initialize(core);
> > +
> > +	return ret;
> > +}
> > +
> > +static struct regmap *ocelot_devm_regmap_init(struct ocelot_core *core,
> > +					      struct device *dev,
> > +					      const struct resource *res)
> > +{
> > +	struct regmap *regmap;
> > +
> > +	regmap = dev_get_regmap(dev, res->name);
> > +	if (!regmap)
> > +		regmap = ocelot_spi_devm_get_regmap(core, dev, res);
> 
> Why are you making SPI specific calls from the Core driver?

This was my interpretation of your initial feedback. It was initially
implemented as a config->get_regmap() function pointer so that core
didn't need to know anything about ocelot_spi.

If function pointers aren't used, it seems like core would have to know
about all possible bus types... Maybe my naming led to some
misunderstandings. Specifically I'd used "init_bus" which was intended
to be "set up the chip to be able to properly communicate via SPI" but
could have been interpreted as "tell the user of this driver that the
bus is being initialized by way of a callback"?

> 
> > +	return regmap;
> > +}
> > +
> > +struct regmap *ocelot_get_regmap_from_resource(struct device *dev,
> > +					       const struct resource *res)
> > +{
> > +	struct ocelot_core *core = dev_get_drvdata(dev);
> > +
> > +	return ocelot_devm_regmap_init(core, dev, res);
> > +}
> > +EXPORT_SYMBOL(ocelot_get_regmap_from_resource);
> 
> Why don't you always call ocelot_devm_regmap_init() with the 'core'
> parameter dropped and just do dev_get_drvdata() inside of there?
> 
> You're passing 'dev' anyway.

This might be an error. I'll look into this, but I changed the intended
behavior of this between v5 and v6.

In v5 I had intended to attach all regmaps to the spi_device. This way
they could be shared amongst child devices of spi->dev. I think that was
a bad design decision on my part, so I abandoned it. If the child
devices are to share regmaps, they should explicitly do so by way of
syscon, not implicitly by name.

In v6 my intent is to have every regmap be devm-linked to the children.
This way the regmap would be destroyed and recreated by rmmod / insmod,
of the sub-modules, instead of being kept around the MFD module.

So perhaps to clear this up I should rename "dev" to "child" because it
seems that the naming has already gotten too confusing. What I intended
to do was:

struct regmap *ocelot_get_regmap_from_resource(struct device *parent,
					       struct device *child,
					       const struct resource *res)
{
	struct ocelot_core *core = dev_get_drvdata(parent);

	return ocelot_devm_regmap_init(core, child, res);
}

Or maybe even:
struct regmap *ocelot_get_regmap_from_resource(struct device *child,
					       const struct resource *res)
{
	struct ocelot_core *core = dev_get_drvdata(child->parent);

	return ocelot_devm_regmap_init(core, child, res);
}

> 
> > +static const struct resource vsc7512_miim1_resources[] = {
> > +	{
> > +		.start = 0x710700c0,
> > +		.end = 0x710700e3,
> > +		.name = "gcb_miim1",
> > +		.flags = IORESOURCE_MEM,
> > +	},
> > +};
> > +
> > +static const struct resource vsc7512_pinctrl_resources[] = {
> > +	{
> > +		.start = 0x71070034,
> > +		.end = 0x7107009f,
> > +		.name = "gcb_gpio",
> > +		.flags = IORESOURCE_MEM,
> > +	},
> > +};
> > +
> > +static const struct resource vsc7512_sgpio_resources[] = {
> > +	{
> > +		.start = 0x710700f8,
> > +		.end = 0x710701f7,
> > +		.name = "gcb_sio",
> > +		.flags = IORESOURCE_MEM,
> > +	},
> > +};
> > +
> > +static const struct mfd_cell vsc7512_devs[] = {
> > +	{
> > +		.name = "pinctrl-ocelot",
> 
> <device>-<sub-device>
> 
> "ocelot-pinctrl"
> 
> > +		.of_compatible = "mscc,ocelot-pinctrl",
> > +		.num_resources = ARRAY_SIZE(vsc7512_pinctrl_resources),
> > +		.resources = vsc7512_pinctrl_resources,
> > +	},
> > +	{
> 
> Same line please.
> 
> > +		.name = "pinctrl-sgpio",
> 
> "ocelot-sgpio"

I'll fix these up. Thanks.

> 
> > +		.of_compatible = "mscc,ocelot-sgpio",
> > +		.num_resources = ARRAY_SIZE(vsc7512_sgpio_resources),
> > +		.resources = vsc7512_sgpio_resources,
> > +	},
> > +	{
> > +		.name = "ocelot-miim1",
> > +		.of_compatible = "mscc,ocelot-miim",
> > +		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
> > +		.resources = vsc7512_miim1_resources,
> > +	},
> > +};
> > +
> > +int ocelot_core_init(struct ocelot_core *core)
> > +{
> > +	struct device *dev = core->dev;
> > +	int ret;
> > +
> > +	dev_set_drvdata(dev, core);
> > +
> > +	core->gcb_regmap = ocelot_devm_regmap_init(core, dev,
> > +						   &vsc7512_gcb_resource);
> > +	if (!core->gcb_regmap)
> 
> And if an error is returned?

Yes, I should be using IS_ERR here. I'll fix it.

> 
> > +		return -ENOMEM;
> > +
> > +	/* Prepare the chip */
> 
> Does it prepare or reset the chip?
> 
> If the former, then the following call is misnamed.
> 
> if the latter, then there is no need for this comment.

I'll clarify in the source. It resets the chip and sets up the bus so
that registers can be accessed.

I agree the comment is unnecessary.

> 
> > +	ret = ocelot_reset(core);
> > +	if (ret) {
> > +		dev_err(dev, "ocelot mfd reset failed with code %d\n", ret);
> 
> Isn't the device called 'ocelot'?  If so, you just repeated yourself.
> 
> "Failed to reset device: %d\n"

Good point. I'll clarify.

> 
> > +		return ret;
> > +	}
> > +
> > +	ret = devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, vsc7512_devs,
> 
> Why NONE?

I dont know the implication here. Example taken from
drivers/mfd/madera-core.c. I imagine PLATFORM_DEVID_AUTO is the correct
macro to use here?

> 
> > +				   ARRAY_SIZE(vsc7512_devs), NULL, 0, NULL);
> > +	if (ret) {
> > +		dev_err(dev, "error adding mfd devices\n");
> 
> "Failed to add sub-devices"
> 
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(ocelot_core_init);
> > +
> > +int ocelot_remove(struct ocelot_core *core)
> > +{
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(ocelot_remove);
> 
> What's the propose of this?

It is useless now that I am using devm_mfd_add_devices. I'll remove.

> 
> > +MODULE_DESCRIPTION("Ocelot Chip MFD driver");
> 
> No such thing as an MFD driver.

Understood. I'll rename and clarify.

> 
> > +MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
> > +MODULE_LICENSE("GPL v2");
> > diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
> > new file mode 100644
> > index 000000000000..1e268a4dfa17
> > --- /dev/null
> > +++ b/drivers/mfd/ocelot-spi.c
> > @@ -0,0 +1,325 @@
> > +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> > +/*
> > + * SPI core driver for the Ocelot chip family.
> > + *
> > + * This driver will handle everything necessary to allow for communication over
> > + * SPI to the VSC7511, VSC7512, VSC7513 and VSC7514 chips. The main functions
> > + * are to prepare the chip's SPI interface for a specific bus speed, and a host
> > + * processor's endianness. This will create and distribute regmaps for any MFD
> > + * children.
> > + *
> > + * Copyright 2021 Innovative Advantage Inc.
> > + *
> > + * Author: Colin Foster <colin.foster@in-advantage.com>
> > + */
> > +
> > +#include <linux/iopoll.h>
> > +#include <linux/kconfig.h>
> > +#include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/regmap.h>
> > +#include <linux/spi/spi.h>
> > +
> > +#include <asm/byteorder.h>
> > +
> > +#include "ocelot.h"
> > +
> > +struct ocelot_spi {
> > +	int spi_padding_bytes;
> > +	struct spi_device *spi;
> > +	struct ocelot_core core;
> > +	struct regmap *cpuorg_regmap;
> > +};
> > +
> > +#define DEV_CPUORG_IF_CTRL	(0x0000)
> > +#define DEV_CPUORG_IF_CFGSTAT	(0x0004)
> > +
> > +static const struct resource vsc7512_dev_cpuorg_resource = {
> > +	.start	= 0x71000000,
> > +	.end	= 0x710002ff,
> > +	.name	= "devcpu_org",
> > +};
> > +
> > +#define VSC7512_BYTE_ORDER_LE 0x00000000
> > +#define VSC7512_BYTE_ORDER_BE 0x81818181
> > +#define VSC7512_BIT_ORDER_MSB 0x00000000
> > +#define VSC7512_BIT_ORDER_LSB 0x42424242
> > +
> > +static struct ocelot_spi *core_to_ocelot_spi(struct ocelot_core *core)
> > +{
> > +	return container_of(core, struct ocelot_spi, core);
> > +}
> 
> See my comments in the header file.
> 
> > +static int ocelot_spi_init_bus(struct ocelot_spi *ocelot_spi)
> > +{
> > +	struct spi_device *spi;
> > +	struct device *dev;
> > +	u32 val, check;
> > +	int err;
> > +
> > +	spi = ocelot_spi->spi;
> > +	dev = &spi->dev;
> > +
> > +#ifdef __LITTLE_ENDIAN
> > +	val = VSC7512_BYTE_ORDER_LE;
> > +#else
> > +	val = VSC7512_BYTE_ORDER_BE;
> > +#endif
> > +
> > +	err = regmap_write(ocelot_spi->cpuorg_regmap, DEV_CPUORG_IF_CTRL, val);
> > +	if (err)
> > +		return err;
> > +
> > +	val = ocelot_spi->spi_padding_bytes;
> > +	err = regmap_write(ocelot_spi->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT,
> > +			   val);
> > +	if (err)
> > +		return err;
> > +
> > +	check = val | 0x02000000;
> 
> Either define or comment magic numbers (I prefer the former).

Ahh yes, I missed this one. My apologies.

> 
> > +	err = regmap_read(ocelot_spi->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT,
> > +			  &val);
> > +	if (err)
> > +		return err;
> 
> Comments needed for what you're actually doing here.

Agreed.

> 
> > +	if (check != val)
> > +		return -ENODEV;
> > +
> > +	return 0;
> > +}
> > +
> > +int ocelot_spi_initialize(struct ocelot_core *core)
> > +{
> > +	struct ocelot_spi *ocelot_spi = core_to_ocelot_spi(core);
> > +
> > +	return ocelot_spi_init_bus(ocelot_spi);
> > +}
> > +EXPORT_SYMBOL(ocelot_spi_initialize);
> 
> See my comments in the header file.
> 
> > +static unsigned int ocelot_spi_translate_address(unsigned int reg)
> > +{
> > +	return cpu_to_be32((reg & 0xffffff) >> 2);
> > +}
> 
> Comment.

Also agree.

> 
> > +struct ocelot_spi_regmap_context {
> > +	u32 base;
> > +	struct ocelot_spi *ocelot_spi;
> > +};
> 
> See my comments in the header file.
> 
> > +static int ocelot_spi_reg_read(void *context, unsigned int reg,
> > +			       unsigned int *val)
> > +{
> > +	struct ocelot_spi_regmap_context *regmap_context = context;
> > +	struct ocelot_spi *ocelot_spi = regmap_context->ocelot_spi;
> > +	struct spi_transfer tx, padding, rx;
> > +	struct spi_message msg;
> > +	struct spi_device *spi;
> > +	unsigned int addr;
> > +	u8 *tx_buf;
> > +
> > +	WARN_ON(!val);
> 
> Is this possible?

Hmm... I don't know if regmap_read guards against val == NULL. It
doesn't look like it does. It is very much a "this should never happen"
moment...

I can remove it, or change this to return an error if !val, which is
what I probably should have done in the first place. Thoughts?

> 
> > +	spi = ocelot_spi->spi;
> > +
> > +	addr = ocelot_spi_translate_address(reg + regmap_context->base);
> > +	tx_buf = (u8 *)&addr;
> > +
> > +	spi_message_init(&msg);
> > +
> > +	memset(&tx, 0, sizeof(struct spi_transfer));
> > +
> > +	/* Ignore the first byte for the 24-bit address */
> > +	tx.tx_buf = &tx_buf[1];
> > +	tx.len = 3;
> > +
> > +	spi_message_add_tail(&tx, &msg);
> > +
> > +	if (ocelot_spi->spi_padding_bytes > 0) {
> > +		u8 dummy_buf[16] = {0};
> > +
> > +		memset(&padding, 0, sizeof(struct spi_transfer));
> > +
> > +		/* Just toggle the clock for padding bytes */
> > +		padding.len = ocelot_spi->spi_padding_bytes;
> > +		padding.tx_buf = dummy_buf;
> > +		padding.dummy_data = 1;
> > +
> > +		spi_message_add_tail(&padding, &msg);
> > +	}
> > +
> > +	memset(&rx, 0, sizeof(struct spi_transfer));
> 
> sizeof(*rx)

Agreed. I'm making this a habit.

> 
> > +	rx.rx_buf = val;
> > +	rx.len = 4;
> > +
> > +	spi_message_add_tail(&rx, &msg);
> > +
> > +	return spi_sync(spi, &msg);
> > +}
> > +
> > +static int ocelot_spi_reg_write(void *context, unsigned int reg,
> > +				unsigned int val)
> > +{
> > +	struct ocelot_spi_regmap_context *regmap_context = context;
> > +	struct ocelot_spi *ocelot_spi = regmap_context->ocelot_spi;
> > +	struct spi_transfer tx[2] = {0};
> > +	struct spi_message msg;
> > +	struct spi_device *spi;
> > +	unsigned int addr;
> > +	u8 *tx_buf;
> > +
> > +	spi = ocelot_spi->spi;
> > +
> > +	addr = ocelot_spi_translate_address(reg + regmap_context->base);
> > +	tx_buf = (u8 *)&addr;
> > +
> > +	spi_message_init(&msg);
> > +
> > +	/* Ignore the first byte for the 24-bit address and set the write bit */
> > +	tx_buf[1] |= BIT(7);
> > +	tx[0].tx_buf = &tx_buf[1];
> > +	tx[0].len = 3;
> > +
> > +	spi_message_add_tail(&tx[0], &msg);
> > +
> > +	memset(&tx[1], 0, sizeof(struct spi_transfer));
> > +	tx[1].tx_buf = &val;
> > +	tx[1].len = 4;
> > +
> > +	spi_message_add_tail(&tx[1], &msg);
> > +
> > +	return spi_sync(spi, &msg);
> > +}
> > +
> > +static const struct regmap_config ocelot_spi_regmap_config = {
> > +	.reg_bits = 24,
> > +	.reg_stride = 4,
> > +	.val_bits = 32,
> > +
> > +	.reg_read = ocelot_spi_reg_read,
> > +	.reg_write = ocelot_spi_reg_write,
> > +
> > +	.max_register = 0xffffffff,
> > +	.use_single_write = true,
> > +	.use_single_read = true,
> > +	.can_multi_write = false,
> > +
> > +	.reg_format_endian = REGMAP_ENDIAN_BIG,
> > +	.val_format_endian = REGMAP_ENDIAN_NATIVE,
> > +};
> > +
> > +struct regmap *
> > +ocelot_spi_devm_get_regmap(struct ocelot_core *core, struct device *dev,
> > +			   const struct resource *res)
> > +{
> > +	struct ocelot_spi *ocelot_spi = core_to_ocelot_spi(core);
> > +	struct ocelot_spi_regmap_context *context;
> > +	struct regmap_config regmap_config;
> > +	struct regmap *regmap;
> > +
> > +	context = devm_kzalloc(dev, sizeof(*context), GFP_KERNEL);
> > +	if (IS_ERR(context))
> > +		return ERR_CAST(context);
> > +
> > +	context->base = res->start;
> > +	context->ocelot_spi = ocelot_spi;
> > +
> > +	memcpy(&regmap_config, &ocelot_spi_regmap_config,
> > +	       sizeof(ocelot_spi_regmap_config));
> > +
> > +	regmap_config.name = res->name;
> > +	regmap_config.max_register = res->end - res->start;
> > +
> > +	regmap = devm_regmap_init(dev, NULL, context, &regmap_config);
> > +	if (IS_ERR(regmap))
> > +		return ERR_CAST(regmap);
> > +
> > +	return regmap;
> > +}
> > +
> > +static int ocelot_spi_probe(struct spi_device *spi)
> > +{
> > +	struct device *dev = &spi->dev;
> > +	struct ocelot_spi *ocelot_spi;
> > +	int err;
> > +
> > +	ocelot_spi = devm_kzalloc(dev, sizeof(*ocelot_spi), GFP_KERNEL);
> > +
> > +	if (!ocelot_spi)
> > +		return -ENOMEM;
> > +
> > +	if (spi->max_speed_hz <= 500000) {
> > +		ocelot_spi->spi_padding_bytes = 0;
> > +	} else {
> > +		/*
> > +		 * Calculation taken from the manual for IF_CFGSTAT:IF_CFG.
> > +		 * Register access time is 1us, so we need to configure and send
> > +		 * out enough padding bytes between the read request and data
> > +		 * transmission that lasts at least 1 microsecond.
> > +		 */
> > +		ocelot_spi->spi_padding_bytes = 1 +
> > +			(spi->max_speed_hz / 1000000 + 2) / 8;
> > +	}
> > +
> > +	ocelot_spi->spi = spi;
> > +
> > +	spi->bits_per_word = 8;
> > +
> > +	err = spi_setup(spi);
> > +	if (err < 0) {
> > +		dev_err(&spi->dev, "Error %d initializing SPI\n", err);
> > +		return err;
> > +	}
> > +
> > +	ocelot_spi->cpuorg_regmap =
> > +		ocelot_spi_devm_get_regmap(&ocelot_spi->core, dev,
> > +					   &vsc7512_dev_cpuorg_resource);
> > +	if (!ocelot_spi->cpuorg_regmap)
> 
> And if an error is returned?

As above, IS_ERR should be used. Thanks for pointing these out.

> 
> > +		return -ENOMEM;
> > +
> > +	ocelot_spi->core.dev = dev;
> > +
> > +	/*
> > +	 * The chip must be set up for SPI before it gets initialized and reset.
> > +	 * This must be done before calling init, and after a chip reset is
> > +	 * performed.
> > +	 */
> > +	err = ocelot_spi_init_bus(ocelot_spi);
> > +	if (err) {
> > +		dev_err(dev, "Error %d initializing Ocelot SPI bus\n", err);
> > +		return err;
> > +	}
> > +
> > +	err = ocelot_core_init(&ocelot_spi->core);
> > +	if (err < 0) {
> > +		dev_err(dev, "Error %d initializing Ocelot MFD\n", err);
> > +		return err;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int ocelot_spi_remove(struct spi_device *spi)
> > +{
> > +	return 0;
> > +}
> > +
> > +const struct of_device_id ocelot_spi_of_match[] = {
> > +	{ .compatible = "mscc,vsc7512_mfd_spi" },
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(of, ocelot_spi_of_match);
> > +
> > +static struct spi_driver ocelot_spi_driver = {
> > +	.driver = {
> > +		.name = "ocelot_mfd_spi",
> > +		.of_match_table = of_match_ptr(ocelot_spi_of_match),
> > +	},
> > +	.probe = ocelot_spi_probe,
> > +	.remove = ocelot_spi_remove,
> > +};
> > +module_spi_driver(ocelot_spi_driver);
> > +
> > +MODULE_DESCRIPTION("Ocelot Chip MFD SPI driver");
> > +MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
> > +MODULE_LICENSE("Dual MIT/GPL");
> > diff --git a/drivers/mfd/ocelot.h b/drivers/mfd/ocelot.h
> > new file mode 100644
> > index 000000000000..8bb2b57002be
> > --- /dev/null
> > +++ b/drivers/mfd/ocelot.h
> > @@ -0,0 +1,36 @@
> > +/* SPDX-License-Identifier: GPL-2.0 OR MIT */
> > +/*
> > + * Copyright 2021 Innovative Advantage Inc.
> > + */
> > +
> > +#include <linux/kconfig.h>
> > +#include <linux/regmap.h>
> > +
> > +struct ocelot_core {
> > +	struct device *dev;
> > +	struct regmap *gcb_regmap;
> > +};
> 
> Please drop this over-complicated 'core' and 'spi' stuff.
> 
> You spend too much effort converting between 'dev', 'core' and 'spi'.
> 
> I suggest you just pass 'dev' around as your key parameter.
> 
> Any additional attributes you *need" to carry around can do in:
> 
>   struct ocelot *ddata;

Understood. I'll take another look and it'll probably clean things up
quite a bit, as you suggest.

> 
> > +void ocelot_get_resource_name(char *name, const struct resource *res,
> > +			      int size);
> > +int ocelot_core_init(struct ocelot_core *core);
> > +int ocelot_remove(struct ocelot_core *core);
> > +
> > +#if IS_ENABLED(CONFIG_MFD_OCELOT_SPI)
> > +struct regmap *ocelot_spi_devm_get_regmap(struct ocelot_core *core,
> > +					  struct device *dev,
> > +					  const struct resource *res);
> > +int ocelot_spi_initialize(struct ocelot_core *core);
> > +#else
> > +static inline struct regmap *ocelot_spi_devm_get_regmap(
> > +		struct ocelot_core *core, struct device *dev,
> > +		const struct resource *res)
> > +{
> > +	return NULL;
> > +}
> > +
> > +static inline int ocelot_spi_initialize(struct ocelot_core *core)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > +#endif
> > diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
> > index 07baf8390744..8e54bde06fd5 100644
> > --- a/drivers/net/mdio/mdio-mscc-miim.c
> > +++ b/drivers/net/mdio/mdio-mscc-miim.c
> > @@ -11,11 +11,13 @@
> >  #include <linux/iopoll.h>
> >  #include <linux/kernel.h>
> >  #include <linux/mdio/mdio-mscc-miim.h>
> > +#include <linux/mfd/core.h>
> >  #include <linux/module.h>
> >  #include <linux/of_mdio.h>
> >  #include <linux/phy.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/regmap.h>
> > +#include <soc/mscc/ocelot.h>
> >  
> >  #define MSCC_MIIM_REG_STATUS		0x0
> >  #define		MSCC_MIIM_STATUS_STAT_PENDING	BIT(2)
> > @@ -230,13 +232,20 @@ static int mscc_miim_probe(struct platform_device *pdev)
> >  	struct mii_bus *bus;
> >  	int ret;
> >  
> > -	regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
> > -	if (IS_ERR(regs)) {
> > -		dev_err(dev, "Unable to map MIIM registers\n");
> > -		return PTR_ERR(regs);
> > -	}
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +
> > +	if (!device_is_mfd(pdev)) {
> > +		regs = devm_ioremap_resource(dev, res);
> > +		if (IS_ERR(regs)) {
> > +			dev_err(dev, "Unable to map MIIM registers\n");
> > +			return PTR_ERR(regs);
> > +		}
> >  
> > -	mii_regmap = devm_regmap_init_mmio(dev, regs, &mscc_miim_regmap_config);
> > +		mii_regmap = devm_regmap_init_mmio(dev, regs,
> > +						   &mscc_miim_regmap_config);
> 
> These tabs look wrong.
> 
> Doesn't checkpatch.pl warn about stuff like this?

It does say to check, yes. I missed that. Apologies.

> > +	} else {
> > +		mii_regmap = ocelot_get_regmap_from_resource(dev->parent, res);
> > +	}
> 
> You need a comment to explain why you're calling both of these.

Agreed. Whether we keep this method or not I'll clarify in all places
where this is used.

> 
> >  	if (IS_ERR(mii_regmap)) {
> >  		dev_err(dev, "Unable to create MIIM regmap\n");
> > diff --git a/drivers/pinctrl/pinctrl-microchip-sgpio.c b/drivers/pinctrl/pinctrl-microchip-sgpio.c
> > index 8db3caf15cf2..53df095b33e0 100644
> > --- a/drivers/pinctrl/pinctrl-microchip-sgpio.c
> > +++ b/drivers/pinctrl/pinctrl-microchip-sgpio.c
> > @@ -12,6 +12,7 @@
> >  #include <linux/clk.h>
> >  #include <linux/gpio/driver.h>
> >  #include <linux/io.h>
> > +#include <linux/mfd/core.h>
> >  #include <linux/mod_devicetable.h>
> >  #include <linux/module.h>
> >  #include <linux/pinctrl/pinmux.h>
> > @@ -19,6 +20,7 @@
> >  #include <linux/property.h>
> >  #include <linux/regmap.h>
> >  #include <linux/reset.h>
> > +#include <soc/mscc/ocelot.h>
> >  
> >  #include "core.h"
> >  #include "pinconf.h"
> > @@ -137,7 +139,9 @@ static inline int sgpio_addr_to_pin(struct sgpio_priv *priv, int port, int bit)
> >  
> >  static inline u32 sgpio_get_addr(struct sgpio_priv *priv, u32 rno, u32 off)
> >  {
> > -	return priv->properties->regoff[rno] + off;
> > +	int stride = regmap_get_reg_stride(priv->regs);
> > +
> > +	return (priv->properties->regoff[rno] + off) * stride;
> >  }
> >  
> >  static u32 sgpio_readl(struct sgpio_priv *priv, u32 rno, u32 off)
> > @@ -818,6 +822,7 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
> >  	struct fwnode_handle *fwnode;
> >  	struct reset_control *reset;
> >  	struct sgpio_priv *priv;
> > +	struct resource *res;
> >  	struct clk *clk;
> >  	u32 __iomem *regs;
> >  	u32 val;
> > @@ -850,11 +855,18 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
> >  		return -EINVAL;
> >  	}
> >  
> > -	regs = devm_platform_ioremap_resource(pdev, 0);
> > -	if (IS_ERR(regs))
> > -		return PTR_ERR(regs);
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +
> > +	if (!device_is_mfd(pdev)) {
> > +		regs = devm_ioremap_resource(dev, res);
> 
> What happens if you call this if the device was registered via MFD?

I don't recall if it was your suggestion, but I tried this.
devm_ioremap_resource on the MFD triggered a kernel crash. I didn't look
much more into things than that, but if trying devm_ioremap_resource and
falling back to ocelot_get_regmap_from_resource is the desired path, I
can investigate further.

> 
> > +		if (IS_ERR(regs))
> > +			return PTR_ERR(regs);
> > +
> > +		priv->regs = devm_regmap_init_mmio(dev, regs, &regmap_config);
> > +	} else {
> > +		priv->regs = ocelot_get_regmap_from_resource(dev->parent, res);
> > +	}
> >  
> > -	priv->regs = devm_regmap_init_mmio(dev, regs, &regmap_config);
> >  	if (IS_ERR(priv->regs))
> >  		return PTR_ERR(priv->regs);
> >  
> > diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
> > index b6ad3ffb4596..d5485c6a0e20 100644
> > --- a/drivers/pinctrl/pinctrl-ocelot.c
> > +++ b/drivers/pinctrl/pinctrl-ocelot.c
> > @@ -10,6 +10,7 @@
> >  #include <linux/gpio/driver.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/io.h>
> > +#include <linux/mfd/core.h>
> >  #include <linux/of_device.h>
> >  #include <linux/of_irq.h>
> >  #include <linux/of_platform.h>
> > @@ -20,6 +21,7 @@
> >  #include <linux/platform_device.h>
> >  #include <linux/regmap.h>
> >  #include <linux/slab.h>
> > +#include <soc/mscc/ocelot.h>
> >  
> >  #include "core.h"
> >  #include "pinconf.h"
> > @@ -1123,6 +1125,9 @@ static int lan966x_pinmux_set_mux(struct pinctrl_dev *pctldev,
> >  	return 0;
> >  }
> >  
> > +#if defined(REG)
> > +#undef REG
> > +#endif
> >  #define REG(r, info, p) ((r) * (info)->stride + (4 * ((p) / 32)))
> >  
> >  static int ocelot_gpio_set_direction(struct pinctrl_dev *pctldev,
> > @@ -1805,6 +1810,7 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
> >  	struct device *dev = &pdev->dev;
> >  	struct ocelot_pinctrl *info;
> >  	struct regmap *pincfg;
> > +	struct resource *res;
> >  	void __iomem *base;
> >  	int ret;
> >  	struct regmap_config regmap_config = {
> > @@ -1819,16 +1825,27 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
> >  
> >  	info->desc = (struct pinctrl_desc *)device_get_match_data(dev);
> >  
> > -	base = devm_ioremap_resource(dev,
> > -			platform_get_resource(pdev, IORESOURCE_MEM, 0));
> > -	if (IS_ERR(base))
> > -		return PTR_ERR(base);
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (IS_ERR(res)) {
> > +		dev_err(dev, "Failed to get resource\n");
> > +		return PTR_ERR(res);
> > +	}
> >  
> >  	info->stride = 1 + (info->desc->npins - 1) / 32;
> >  
> > -	regmap_config.max_register = OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
> > +	if (!device_is_mfd(pdev)) {
> > +		base = devm_ioremap_resource(dev, res);
> > +		if (IS_ERR(base))
> > +			return PTR_ERR(base);
> > +
> > +		regmap_config.max_register =
> > +			OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
> > +
> > +		info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
> > +	} else {
> > +		info->map = ocelot_get_regmap_from_resource(dev->parent, res);
> > +	}
> >  
> > -	info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
> >  	if (IS_ERR(info->map)) {
> >  		dev_err(dev, "Failed to create regmap\n");
> >  		return PTR_ERR(info->map);
> > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> > index 5c3a3597f1d2..70fae9c8b649 100644
> > --- a/include/soc/mscc/ocelot.h
> > +++ b/include/soc/mscc/ocelot.h
> > @@ -969,4 +969,15 @@ ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
> >  }
> >  #endif
> >  
> > +#if IS_ENABLED(CONFIG_MFD_OCELOT)
> > +struct regmap *ocelot_get_regmap_from_resource(struct device *dev,
> > +					       const struct resource *res);
> > +#else
> > +static inline struct regmap *
> > +ocelot_get_regmap_from_resource(struct device *dev, const struct resource *res)
> > +{
> > +	return NULL;
> > +}
> > +#endif
> > +
> >  #endif
> 
> -- 
> Lee Jones [李琼斯]
> Principal Technical Lead - Developer Services
> Linaro.org │ Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog
