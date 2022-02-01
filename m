Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719BD4A625C
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241485AbiBAR1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:27:15 -0500
Received: from mail-sn1anam02on2114.outbound.protection.outlook.com ([40.107.96.114]:56891
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230457AbiBAR1O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 12:27:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXX0AO0vDM9Bwl9HnDo+noWrBkyMGtwQ3nAMZ/3kp7TrQk2M+CdyaLA/uoGKtbY2r8F59zjuzCrbjvQG/MlAwgCC2sK0sfYD/vby2nUrYGI2JR4SgFtOEbkRs4EyEiIRC7v8p0z40c/qsCQ/mHadxvpQMw+iLHjDcKz/o6XLgwCiOX21b5qnaO3KX14AeL06Qx9PmZ/fnRgQTJrUlHiB5AE0OW62fL0qG9YljJiyrKcNIRpSU2KTdQznulNMZfFeublroOqgUq1N5WaL3fLdx5n+YSBufD9uEyL0z5nuElepdrb7+VuJWX5sktPWHWMt7DGigZdYy4qMAYEYau6SbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o7uxp0KQ1QG2T9BBbvEDNLhFjCp5kuoCCBEP2riGugE=;
 b=W/vPnn6WGbUTePEYLIz5a+qg59BeQn3/FFQKdVUoi19Oho35Yp/CNFlPOtj7/YJwLsR7zo+PX7rfA7cchzzhjQXmME1wRvZcTP9mCOR0IJRHGJS4uYVMFq6ICBlMdO+Jhy0cRKitrUx4YxkZ56H5hcmoPLKPZlHt79ZHma9H2/5yvNb7sm0RkhxiIQ83sUs/9MMLwcmCS+WoXMn27L3EflxYNFo3G5BImdlg5nrGqdvQqB5H2q+su/rCKEacQ3LemYMhpazWCUz7KL/R1NRuGgYmpcwi1b+ILpbMVJJVlwO4bJgfyKdorTK0k8r+GzwTo+GlOnaWlQTIOB5pnmCcsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7uxp0KQ1QG2T9BBbvEDNLhFjCp5kuoCCBEP2riGugE=;
 b=dRg8+iOINuT1nwKRu1wVTLB6cME9ixEzgZ2Rksat9U4R7wHOjN1gikqbJNl2Ck+mnh8vk+ctnUCCJMxQGC/I5rdsXuFfXv77sacYzycn/P2TVha87+JBJpHJeM2d00P98J2tGrOC6109UtpDoIcUbdyRslUW8LH1S9gAWHMw6/E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1902.namprd10.prod.outlook.com
 (2603:10b6:300:10d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 1 Feb
 2022 17:27:10 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4930.020; Tue, 1 Feb 2022
 17:27:10 +0000
Date:   Tue, 1 Feb 2022 09:27:07 -0800
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
Message-ID: <20220201172707.GA6990@COLIN-DESKTOP1.localdomain>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
 <20220129220221.2823127-7-colin.foster@in-advantage.com>
 <Yfer/qJmwRdShv4y@google.com>
 <20220131172934.GB28107@COLIN-DESKTOP1.localdomain>
 <Yfji9Yy/VtrVv+Js@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yfji9Yy/VtrVv+Js@google.com>
X-ClientProxiedBy: MW4PR03CA0179.namprd03.prod.outlook.com
 (2603:10b6:303:8d::34) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 464d692b-a07d-43dc-4abf-08d9e5a813e1
X-MS-TrafficTypeDiagnostic: MWHPR10MB1902:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB190231FFA2330CE4DE735E89A4269@MWHPR10MB1902.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9rC4rukfsJmELnYCOrg794ZeEcAiHKBPJl/NpP9Ks++WMk7TYyv/LlMxFH2Ee7PqU4ygOqkogA+c5xdDOmfLZs70AfX9OR00IUmvdw9BI3WL+AR0epyT+A0DfANjpN90Rf229KRvZt59/RHJ5ApVNeipXg+t6wSfFkZtDL5hd2myjuNhVqg6xsX/Jr/nuWKHPTpArCKxT8NJgu9uOf5PQj/bfRvfFr4kMG16IfF04UBnfItokz8uQLgLmL+6xsxfrtcjthgbCjITunkLowOkUXWqTdzVThllCR+JfOvx5cRe5xCl815CiKOVxRt6UGsJV0iXpyWT9+jPo82S0XidTZ1vwXzi7pAwbsWDZunLwF/6kkJo73h3PUZ3qx61OSYna6R1JoYiQCZuRrelZfK5Z6Apfesc6KeDJBKh8pVfQ8s3m53nwde6iVTJYd0K7GHavjNqHHyY/xBE6h7m/VsoT+GQaC/Ip5ck32DTSvhwXaT09j1++KXVYI6vRtRSKV0Yk7s3GpWsvaMGJvcA07heXePv0udXUQu2i7RrX4v46b64i9NwBSgz3SnqfwbxbCrEvFsYtLt88S3xb349ZqudT3KEm2ztKL37nLtKfgDvYtldpfwMSvj6NYWhG4ySH9Gy/3qGCrZ8Tg8+5T3mMqulpl3B3ZU2K7F102om+ffGvr+YaiPfoukGJH5iiLJUKvU7ubZGRhjHZNEStZF56P5u83NXimYMHDZJUBNKM5OHywxQYn8YdQpRhpcWiUBI5ng1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(42606007)(39840400004)(396003)(136003)(366004)(6506007)(6512007)(9686003)(7416002)(5660300002)(52116002)(1076003)(186003)(26005)(44832011)(83380400001)(33656002)(107886003)(30864003)(2906002)(6486002)(86362001)(316002)(66476007)(38100700002)(66556008)(38350700002)(6916009)(54906003)(508600001)(4326008)(6666004)(8676002)(8936002)(66946007)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0tIdUlPdE5BQUtZdG9mLzFWUld1bU80RlNtbzBibUZ5bTNWV0NpUThlcVhk?=
 =?utf-8?B?NDhTMXhSOEtqSEpuQmpZU1JueSt3UDNKeUxMRDBpZll2UnJ4WjZzbk5UMk94?=
 =?utf-8?B?UjBXNGtXaHN1MVV5a2lwMXp4WXlCRW5kN1Y0SXJkRGtwZ1EyT1BhRFpSaU1K?=
 =?utf-8?B?bGk5VERPLzZQa3ZXTENUay8yWmdzbXdmZ1RSdEFWNHJxc0hhZ1pBdUZlSUhZ?=
 =?utf-8?B?S2Zlc1VNUEJGcEJyckxNYzJCc0NIamdWb0ViUmkxa1RSOWduaGoxUmNLRCto?=
 =?utf-8?B?N01HQVdpa0YrbTR5U1I1amd4OWdkYTZUUFR1eTh2MVJzcWN2aHBLRCs0MGhT?=
 =?utf-8?B?eGowaUd4bFRmVzlER0kyYVZKOVYrR0RJVlE3ZExQeEZxK3VZVzlnb09kaWNV?=
 =?utf-8?B?QldtRThpb1NXSExUY0FvcW1ISHNzd0lodE0xcHFaNjJ4WEp4QjBka2JqUEdv?=
 =?utf-8?B?ekVnYWhSN0k4cE92Y3hyM01SblB4MUd0aElXSHV0bm1CaTBmdzdrZ3BNQXIy?=
 =?utf-8?B?L3p6Z1JzNW5ldmhkUFFSUkRaTkZNRXIrazVEZjQxMkRLemRCMld0cEluV3JQ?=
 =?utf-8?B?N3h5cTQ0VHdpS2xmTk1GZTNrZEsrUmhwKzRaM2V0WWNuRUJWWHBpUTlDTExl?=
 =?utf-8?B?NGtIemR2bWc2Y0lVdmdVR1MvME5XS1ZkZlZMeXd1dnNNYUR1RTY0ZFROdFBM?=
 =?utf-8?B?bDhnb0svWWlxbElyZVJ6bG50ano4UUx6dkRRVVZhenFzbmtjRXQzb3FUWllp?=
 =?utf-8?B?ejRNL1luNGwwd1hjL2kxZFlzdzMyQkNhRTBQaUVSaHowWWRZbExUckNWREwr?=
 =?utf-8?B?SzBYTXRpNVUrbnR0Y1Y2cUJIZWRHNzI1S0RVMXFsaU5KcjZHQjZrL2NkeXRQ?=
 =?utf-8?B?RnFJaiswam5jcERpTUwrQlZnUGIwNVRUVE1iTVZXODlhNVJyNTJTS3BwTnJG?=
 =?utf-8?B?cit6U1B2NFdYYzRpY25sUTNPdzJzR3lycDRKWXA1d002bnR0QzFJMlVWQnpI?=
 =?utf-8?B?MEMxZ1pWd2pucFZpMEJGekxrcGJ4Y1prTDRFVXBaQzB1Q2FJYnE2cVBnSmJM?=
 =?utf-8?B?QUVicmJrUXVSbGJxdmNwMDl6S2xaaVVGN2VmUCtDV0pxR3JCOGh6Y3JMdFZT?=
 =?utf-8?B?SmltQTBrekdjV040MmN5eXRDdEEyYzBneUViZ0ttTmFsdDlMREtpZTJ0YlFC?=
 =?utf-8?B?bzJhc0lqZzQ0Rjk4cm1Td1pQNXdTY2E3djJwNjg5azhNQ2VtOG9obzJXTmlr?=
 =?utf-8?B?ODNzMWlrRi9mVnZqY3h6ejB5Y2RXRFBuSk13ZWxhc0JWRG1WY05LSW9xR0Fs?=
 =?utf-8?B?eHBtRGEyMml4ZE13NVJqWE1YejhERDgyVy8vazNIUGhqRkRCOVVDL0VDZU9x?=
 =?utf-8?B?RFUwdklHckhlMWJndnlwMVR6ZG1ITTBxcmQrMkQ0eEZ0NEFodkZxbUJlQ0lM?=
 =?utf-8?B?NUpYZUliVkF0QUtxQnNPcEYybWp0UVNiZW9OZDgwamMwT2w3dlkwMGY2MnYr?=
 =?utf-8?B?OFU1YVZzdUJUeUhBUmk3Rmx2ZkZLTWxBY1hGcEptbWdnc3hFQ2JZT0VDOWdh?=
 =?utf-8?B?U3FRS0VlbHVadjliVTVjZUdTemNUS1lFVHM0TVBnamRXQjF3Vk5IbXY1OFc5?=
 =?utf-8?B?K2pwbDdLVTU5bjAwdG01TEJlUFdic3VxMWQyWmIyZUNmVEdCVk5haG9GQWVZ?=
 =?utf-8?B?N1Uzdjh2YzdEWFZzVE92UkFNd1BMUnlhdS81VmIyeEhqWGhCSGhKcFhnMHhr?=
 =?utf-8?B?V09lVkxMalQ5WU16ZlR5L0VtSHZDYlpoWjNBWlFzaFhhbUpMTjR6bGtBVHZv?=
 =?utf-8?B?L29Wd0ZLQ1lGektkU2t1bkdWbS9DTVdUWWtkQXpPblJpdVMxQngxVTVvV2dU?=
 =?utf-8?B?eWhWUUJoRWFzdVBDSFE2aUhUQkJkQjZ2NGNNWm9Na3RoMjgwbG42dXNWelFC?=
 =?utf-8?B?UmgrTmRPNXk0cE40Q25HcjQ1YUJ1cHNGWTVibU0zVzEyVWZPOFNKOGxxbXJO?=
 =?utf-8?B?MU5DZS92RzMrSEh4RlJUSXFBdWQ5djZrWElsdEN0aDZlbmgzRHJGYjFiTVor?=
 =?utf-8?B?Q3dzTVBIdHFQTTdaakVWYVJKajhTRVZ5eVNqbmxpNkExM0pXOGUxc0JSM1lP?=
 =?utf-8?B?OEV5SmR2K1dsUU9NNU9ZalBOVlJXbVpTTVZtRDlOUWJDTUFIRFYweDZ6c09P?=
 =?utf-8?B?ZjlkVmhDRlZZOU1LZ0pXNDRJTEJDYmdvaitIUDM3aEVWNnNNMXlnSmFjZkZy?=
 =?utf-8?Q?qUP5AZpPgidADJuTWzgvlW8Nwur24GFVIQs+NZMVCM=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 464d692b-a07d-43dc-4abf-08d9e5a813e1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 17:27:10.4808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZG7Bit9whnUzMA/H7CjgKML0keHwabDjCVLc0jheHuXLuJF/LOziKwac8L5KPjGV5qYv8UJg6N79dAuYgokNt1qGKReC9LLGTzygeXUwtWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1902
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Lee,

On Tue, Feb 01, 2022 at 07:36:21AM +0000, Lee Jones wrote:
> On Mon, 31 Jan 2022, Colin Foster wrote:
> 
> > Hi Lee,
> > 
> > Thank you very much for your time / feedback.
> > 
> > On Mon, Jan 31, 2022 at 09:29:34AM +0000, Lee Jones wrote:
> > > On Sat, 29 Jan 2022, Colin Foster wrote:
> > > 
> > > > Create a single SPI MFD ocelot device that manages the SPI bus on the
> > > > external chip and can handle requests for regmaps. This should allow any
> > > > ocelot driver (pinctrl, miim, etc.) to be used externally, provided they
> > > > utilize regmaps.
> > > > 
> > > > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > > > ---
> > > >  drivers/mfd/Kconfig                       |  19 ++
> > > >  drivers/mfd/Makefile                      |   3 +
> > > >  drivers/mfd/ocelot-core.c                 | 165 +++++++++++
> > > >  drivers/mfd/ocelot-spi.c                  | 325 ++++++++++++++++++++++
> > > >  drivers/mfd/ocelot.h                      |  36 +++
> > > 
> > > >  drivers/net/mdio/mdio-mscc-miim.c         |  21 +-
> > > >  drivers/pinctrl/pinctrl-microchip-sgpio.c |  22 +-
> > > >  drivers/pinctrl/pinctrl-ocelot.c          |  29 +-
> > > >  include/soc/mscc/ocelot.h                 |  11 +
> > > 
> > > Please avoid mixing subsystems in patches if at all avoidable.
> > > 
> > > If there are not build time dependencies/breakages, I'd suggest
> > > firstly applying support for this into MFD *then* utilising that
> > > support in subsequent patches.
> > 
> > My last RFC did this, and you had suggested to squash the commits. To
> > clarify, are you suggesting the MFD / Pinctrl get applied in a single
> > patch, then the MIIM get applied in a separate one? Because I had
> > started with what sounds like you're describing - an "empty" MFD with
> > subsequent patches rolling in each subsystem.
> > 
> > Perhaps I misinterpreted your initial feedback.
> 
> I want you to add all device support into the MFD driver at once.
> 
> The associated drivers, the ones that live in other subsystems, should
> be applied as separate patches.  There seldom exist any *build time*
> dependencies between the device side and the driver side.

The sub-devices are modified to use ocelot_get_regmap_from_resource. I
suppose I can add the inline stub function in drivers/mfd/ocelot.h,
which wouldn't break functionality. I'll do that in the next RFC.
Thanks for clarifying!

> 
> > > >  9 files changed, 614 insertions(+), 17 deletions(-)
> > > >  create mode 100644 drivers/mfd/ocelot-core.c
> > > >  create mode 100644 drivers/mfd/ocelot-spi.c
> > > >  create mode 100644 drivers/mfd/ocelot.h
> > > > 
> > > > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > > > index ba0b3eb131f1..57bbf2d11324 100644
> > > > --- a/drivers/mfd/Kconfig
> > > > +++ b/drivers/mfd/Kconfig
> > > > @@ -948,6 +948,25 @@ config MFD_MENF21BMC
> > > >  	  This driver can also be built as a module. If so the module
> > > >  	  will be called menf21bmc.
> > > >  
> > > > +config MFD_OCELOT
> > > > +	tristate "Microsemi Ocelot External Control Support"
> > > 
> > > Please explain exactly what an ECS is in the help below.
> > 
> > I thought I had by way of the second paragraph below. I'm trying to
> > think of what extra information could be of use at this point... 
> > 
> > I could describe how they have internal processors and using this level
> > of control would basically bypass that functionality.
> 
> Yes please.
> 
> Also provide details about what the device actually does.

Got it.

> 
> > > > +static struct regmap *ocelot_devm_regmap_init(struct ocelot_core *core,
> > > > +					      struct device *dev,
> > > > +					      const struct resource *res)
> > > > +{
> > > > +	struct regmap *regmap;
> > > > +
> > > > +	regmap = dev_get_regmap(dev, res->name);
> > > > +	if (!regmap)
> > > > +		regmap = ocelot_spi_devm_get_regmap(core, dev, res);
> > > 
> > > Why are you making SPI specific calls from the Core driver?
> > 
> > This was my interpretation of your initial feedback. It was initially
> > implemented as a config->get_regmap() function pointer so that core
> > didn't need to know anything about ocelot_spi.
> > 
> > If function pointers aren't used, it seems like core would have to know
> > about all possible bus types... Maybe my naming led to some
> > misunderstandings. Specifically I'd used "init_bus" which was intended
> > to be "set up the chip to be able to properly communicate via SPI" but
> > could have been interpreted as "tell the user of this driver that the
> > bus is being initialized by way of a callback"?
> 
> Okay, I see what's happening now.
> 
> Please add a comment to describe why you're calling one helper, what
> failure means in the first instance and what you hope to achieve by
> calling the subsequent one.

Will do.

> 
> > > > +	return regmap;
> > > > +}
> > > > +
> > > > +struct regmap *ocelot_get_regmap_from_resource(struct device *dev,
> > > > +					       const struct resource *res)
> > > > +{
> > > > +	struct ocelot_core *core = dev_get_drvdata(dev);
> > > > +
> > > > +	return ocelot_devm_regmap_init(core, dev, res);
> > > > +}
> > > > +EXPORT_SYMBOL(ocelot_get_regmap_from_resource);
> > > 
> > > Why don't you always call ocelot_devm_regmap_init() with the 'core'
> > > parameter dropped and just do dev_get_drvdata() inside of there?
> > > 
> > > You're passing 'dev' anyway.
> > 
> > This might be an error. I'll look into this, but I changed the intended
> > behavior of this between v5 and v6.
> > 
> > In v5 I had intended to attach all regmaps to the spi_device. This way
> > they could be shared amongst child devices of spi->dev. I think that was
> > a bad design decision on my part, so I abandoned it. If the child
> > devices are to share regmaps, they should explicitly do so by way of
> > syscon, not implicitly by name.
> > 
> > In v6 my intent is to have every regmap be devm-linked to the children.
> > This way the regmap would be destroyed and recreated by rmmod / insmod,
> > of the sub-modules, instead of being kept around the MFD module.
> 
> What's the reason for using an MFD to handle the Regmap(s) if you're
> going to have per-device ones anyway?  Why not handle them in the
> children?

Also addressing the suggestion below:

ocelot_core is the MFD "regmap-giver". It knows how to get a regmap from
Ocelot SPI and hand it to the child.

In order to do this, ocelot_core needs to know information about
ocelot-spi. As you pointed out, there's a cleaner way to do this without
jumping between core, spi, and dev. I agree.

However, the ocelot-spi priv data is tied to ocelot_core->dev. In order
to recover that information, ocelot-core needs to know about a child
device's "dev->parent".

So in v5, I had only used this "core->dev", which eventually burrowed
down into devm_regmap_init().

What this would mean to the user is if they ran "modprobe
ocelot-pinctrl; rmmod ocelot-pinctrl" there would be a debugfs interface
left at /sys/kernel/debug/regmap/spi0.0-gcb_gpio that was created for
ocelot-pinctrl, but abandoned.

I feel like that is incorrect behavior. "rmmod ocelot-pinctrl" should
destroy the regmap, since it is unused. In fact, it would probably break
upon subsequent "modprobe" commands, since it would try to register a
regmap of the same name but to a different device instance.

In order to achieve this, _two_ devices are required to pass around: the
"core->dev" (the same as child->parent) to get all information needed
about SPI, and the "child->dev" to get attached in devm_regmap_init().


As an example: ocelot_core needs a regmap for resetting the chip. It
would call:

ocelot_devm_regmap_init(dev, dev, res);

The first "dev" is used to get core information, the second is used to
in devm_*

A child device like ocelot-pinctrl would use something like:

ocelot_devm_regmap_init(dev->parent, dev, res);


This second "dev" argument wasn't in v5 because I believe I tried to
implicitly share regmaps. That would've led to the stale debugfs
reference I mentioned above, which I think is pretty undesireable.

> 
> > So perhaps to clear this up I should rename "dev" to "child" because it
> > seems that the naming has already gotten too confusing. What I intended
> > to do was:
> > 
> > struct regmap *ocelot_get_regmap_from_resource(struct device *parent,
> > 					       struct device *child,
> > 					       const struct resource *res)
> > {
> > 	struct ocelot_core *core = dev_get_drvdata(parent);
> > 
> > 	return ocelot_devm_regmap_init(core, child, res);
> > }
> > 
> > Or maybe even:
> > struct regmap *ocelot_get_regmap_from_resource(struct device *child,
> > 					       const struct resource *res)
> > {
> > 	struct ocelot_core *core = dev_get_drvdata(child->parent);
> > 
> > 	return ocelot_devm_regmap_init(core, child, res);
> > }
> 
> Or just call:
> 
>   ocelot_devm_regmap_init(core, dev->parent, res);
> 
> ... from the original call-site?
> 
> Or, as I previously suggested:
> 
>   ocelot_devm_regmap_init(dev->parent, res);
> 
> [...]
> 
> > > > +	ret = devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, vsc7512_devs,
> > > 
> > > Why NONE?
> > 
> > I dont know the implication here. Example taken from
> > drivers/mfd/madera-core.c. I imagine PLATFORM_DEVID_AUTO is the correct
> > macro to use here?
> 
> That's why I asked.  Please read-up on the differences and use the
> correct one for your device instead of just blindly copy/pasting from
> other sources. :)

Will do! It is easy to miss these details when everything is new, so
thanks for pointing this out.

> 
> [...]
> 
> > > > +	WARN_ON(!val);
> > > 
> > > Is this possible?
> > 
> > Hmm... I don't know if regmap_read guards against val == NULL. It
> > doesn't look like it does. It is very much a "this should never happen"
> > moment...
> > 
> > I can remove it, or change this to return an error if !val, which is
> > what I probably should have done in the first place. Thoughts?
> 
> Not really.  Just make sure whatever you decide to do is informed.

Understood. I'll look more into it and verify.

> 
> [...]
> 
> > > > -	regs = devm_platform_ioremap_resource(pdev, 0);
> > > > -	if (IS_ERR(regs))
> > > > -		return PTR_ERR(regs);
> > > > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > > +
> > > > +	if (!device_is_mfd(pdev)) {
> > > > +		regs = devm_ioremap_resource(dev, res);
> > > 
> > > What happens if you call this if the device was registered via MFD?
> > 
> > I don't recall if it was your suggestion, but I tried this.
> > devm_ioremap_resource on the MFD triggered a kernel crash. I didn't look
> > much more into things than that, but if trying devm_ioremap_resource and
> > falling back to ocelot_get_regmap_from_resource is the desired path, I
> > can investigate further.
> 
> Yes please.  It should never crash.  That's probably a bug.

Can do.


And thanks again for the feedback! I do really appreciate it.

> 
> -- 
> Lee Jones [李琼斯]
> Principal Technical Lead - Developer Services
> Linaro.org │ Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog
