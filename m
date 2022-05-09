Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A73520225
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 18:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238900AbiEIQS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 12:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238861AbiEIQSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 12:18:53 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2103.outbound.protection.outlook.com [40.107.237.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461E62716CF;
        Mon,  9 May 2022 09:14:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L8wQI8v6EXPyw8E/hbPU4QJw1b9KpgcIKqpLdYIxYNpb0s64f9bxEoM0G10ROyuOiV7/2XbeP3Hu8BrVAetlW5jkOM3lriOeBimG/agSJh4EbE1MzOguFWRnKKseojx3wUzxBPtVXCab8Zln25BMWTz9F+ulrSBpXKwh9uqp+Lf9r2c8akxuwZzJKsM1m50JOItoPGXUNbqZsPL4AzxubUEE8b87NLrNQVud7CL2LJDrZBR1SyKc+aFufYEEFI8R8tgN7VGa2IT7pyDXt6hTwhSho80+hwbYfbz+KPS7EDtcX94sGqsBijagce9/EOtjVtTzgKpfuz6a+rGdDeyI7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C0oiSYO2EOI9Z2ZxJG+n2OfjZEnxWSNQwDJ/KkNZr4k=;
 b=McoplYS3sT4yqIm3tMf6TVax60efU1QsAPJbrWKHNXr00AYJ5hFxZy8w5ZxwEiRSV9+HEUG5TlOmuhUkxg8ZoE0RcD873SjnDMxMrKtYCJ1WbhXv0xSRhRrEb6R8rlbCb2oMLPdrtB4pdbWi4pCpWuS+eIvjC+EAKNT+1KEnnTdFJQOzALbL+XLiP5khBya6f32hYNuD0ZBANomt8xl/HZUaDryesRCOj/9fFglciAXYsLOizXhaops+mHKDw49VM2opLCnclyPlOcrGi8SR3LTZtqPV+vJ1m3pkk4Ny2qZ0GUI6wfbFsCEfJ8SPQkMnSMH8/NH7U8DpwekXkPrJYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C0oiSYO2EOI9Z2ZxJG+n2OfjZEnxWSNQwDJ/KkNZr4k=;
 b=zMlaK1Iijgzgu0BlA+OgZb5tLXkr8R78EpBg3bqHyJyIPAszEIDelBdZSICWe1j80RAsRsivvrUSmLFmtNLzCLH7cwGTp4VfD2BWbgzzXNa1ilIr8FThVOSHJgG4Kfiaan8yRiIlRSHQ3G4Tjhd8dl73fbSYlzXQDkkwXlPsOL8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB5239.namprd10.prod.outlook.com
 (2603:10b6:408:12d::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 9 May
 2022 16:14:56 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Mon, 9 May 2022
 16:14:56 +0000
Date:   Mon, 9 May 2022 16:15:00 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, Terry Bowman <terry.bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [RFC v8 net-next 08/16] mfd: ocelot: add support for the vsc7512
 chip via spi
Message-ID: <20220509231500.GB895@COLIN-DESKTOP1.localdomain>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-9-colin.foster@in-advantage.com>
 <CAHp75VdnFSP9-D=O3h5L80O19xK7ct6ax6kXGfHEiKe9niktYA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VdnFSP9-D=O3h5L80O19xK7ct6ax6kXGfHEiKe9niktYA@mail.gmail.com>
X-ClientProxiedBy: MW4PR04CA0304.namprd04.prod.outlook.com
 (2603:10b6:303:82::9) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8b56db9-0689-4ca5-c3ea-08da31d70ed0
X-MS-TrafficTypeDiagnostic: BN0PR10MB5239:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB523976FABB858DBF78D90DCBA4C69@BN0PR10MB5239.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YYUl1wzCVl8kq1IsfCtlyOj9ZK770GwfZN8wLhrWQywZiumc+AAZEFKOkhW3hbgSk+i4aq1qm9EHK+Sb6a3CIjWS76hoywPzClfPdMEqjDmnLdi+ysF6AurUgfUgdg3+G6C+tHXEdbRBAWRXFL1EZWiJ03Xt5yz7yLtwkHB3QotgTcT/CIVc2wl8oiRPVD7KcswxAq3JYMuBavJQkH5LGyv/UuMaHixrL5j5Uj3Kcf2krBOJTyLt+naXFz65EqDfBii/62oAzPT1UbrE1CYxXeD7cn47Nd9OgGRQOWAbmdgMLwvUFkr+OQYPKwVQaXCF5E+s93YQMvw+nZgeaCP2jtX48cRxfUXJPLK+F0xXCARqyLTCoSjvyod104ni1/0M+FhqqgV88XQiHgeVyqC2LNCm3pxRSZATA/3JXlKdotxtR66L+zt2sk4+C+CNt/Gp1IJyBFaKaAD1yxASX9biwtOn/3OIzjLv1gn8p1beWtdqDphQuepLliw2IGkj9Ulpg4o9yDjaJlJY8BRAUlxhX4OW7cOZfO6RMGJD6Ds0ZRAmtJ//14C2nGDbH8nFqvECU3LiG8o3/uJaKbf8sDLKfzYRs+FcHiIMYJmrtLhxfWUrz2TZoowWMCvGH5DQB3M4+LO+QadhIch1b7bJjc9+NH9Rs15ymttNElwTmmJqSwO3AQR3rDf682GMl7f4VObx6imcJNIjDq8Qgh6Phtlsrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(376002)(39830400003)(346002)(396003)(366004)(6486002)(66476007)(316002)(66946007)(66556008)(508600001)(44832011)(9686003)(6512007)(6666004)(2906002)(52116002)(186003)(54906003)(8676002)(4326008)(6916009)(26005)(38100700002)(86362001)(33656002)(38350700002)(8936002)(83380400001)(6506007)(7416002)(1076003)(5660300002)(53546011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RVMdDiUihIGYj3s9VbcDsfsoesdkNFCsU67MwNW1+6HVT5q7nH9RkslTO1W5?=
 =?us-ascii?Q?TnxA+RHkdJ0/PluZAq1nW6fZ0CtZ9Mac+LmyOqvNn2z3uhN/MckE15Rr2jxd?=
 =?us-ascii?Q?AN6mDf5qOi0+uMtXayVm5ZVbPicsuKmBdgZJV301wlQKf0BW9iumylXd/Y4y?=
 =?us-ascii?Q?DD1nDiTaEm8+ZRVZCRffULEPnTsKwiCIUjoC+yINjV1TfRrgGy9GvHTkO+mn?=
 =?us-ascii?Q?7I0znIRjzCR09AxUF+u151MuGSXru/tISsoRKtqs1B5fDrOlstpdpaO6G2s2?=
 =?us-ascii?Q?+Gf5o8sPiQwbCuNaNTqIG0wyROxdWay0pTKkJas6NaE5sDLlVf8tQBbDufiQ?=
 =?us-ascii?Q?W//lAOBbQNpuZTOok4h0SKeOjotHlavgvGqdi/W3HuOqe3Tj+54YcVsv/Tk5?=
 =?us-ascii?Q?4n0Oy0/7DKcCffwTtCyrvLHuncyChNw8jlkYn3K47LpzZwXzxZ2HdY/hP9of?=
 =?us-ascii?Q?skstV1QQyVi1TKrDECxFzFfMqYWgxVmO2VXPRNoOmWO6E8TddwG+lhFKx/wS?=
 =?us-ascii?Q?DQ+cwRpWaeJlRga22XNXatj1HizDXnu5AglNBVF3qY1bnlKZp1QSX00xiXNG?=
 =?us-ascii?Q?CjY03Uk0NKTOdi4EFWqGu/XTFYHO3SD1Xy05bdN3bGjedNLKjLAdtsWpsJYH?=
 =?us-ascii?Q?eoU/bsicg0WF29AEhmYMaSzXUzcQuFoq4jis3Ot471Ym9gB1lF+zDymhOJV6?=
 =?us-ascii?Q?j4lvtlfqubT7sFD/mHpd5gO6Yyr3zmBPq1EReZQbobo0cmsutu8KnpLAU9yB?=
 =?us-ascii?Q?KhgLSgbjBSvr8EToIB8ESxl0cgW9IydA3Hoq5Kv+1ZYPrAxX1T0gMVXv0agp?=
 =?us-ascii?Q?K6zB5fio1Aya1eUwgm1cjuWuQojeHKbPxL6/yBfeIKzr4cKLgHdITF50yrDn?=
 =?us-ascii?Q?P9j1Ss9FGNcdlBH60T18kFI3Ghxv2DMILvl8Bhyc/iGuN1APi2eEWp4WVYnm?=
 =?us-ascii?Q?b+H/MsbPvMjIa0rKxVfFvl11z5tuv6+fM54g/iDGOMSqA9Fynt/mtCIeaDfx?=
 =?us-ascii?Q?SqUFmEV6z4+DHPYePtKda6YduRLOMcK6CZLelh4QdqNtnofl9dlZVR46WmvE?=
 =?us-ascii?Q?eVqjLRv11+2v2OMcN5xAkT92i8ZTAzRPjupCohcGbB5BZzYyxo0sGrfNc8p5?=
 =?us-ascii?Q?dPAHw1oj9VaJqLnUHT8dLRXS1QeaaiYoWim3wvUku/h+njjOn+mxUWnSLzmp?=
 =?us-ascii?Q?VaYGbLQrN726xKd3zI2rN30BTtqIiySpYCBJfqYL8c4q7FMyHFrPMoGPdORm?=
 =?us-ascii?Q?9ICxrlaykKUVn6U2eDWPr8/dTNeJc1L5JcOrhEJolyGtsMQRUJOEouAQAd6o?=
 =?us-ascii?Q?4TlB4m13kXOXr3zrYBXextN8FBzkozYq/ZuCom9Qfp+aAu+CgU0jVUpCa8+q?=
 =?us-ascii?Q?HfLwxoThUDDFh9yZI038a4OXb15z+Llv37nCTvgB/VsLtT8Sx4SZT0rckF3Z?=
 =?us-ascii?Q?WJOY0vcBGDOmbTI9rFdyoYzvBPoAhe+xQQw0plCAAzGoIiHDl+khMXxDc/XE?=
 =?us-ascii?Q?8nfOTSagyePDv7YnYnglGuVk2IsTr+EGSYu4BwfAmAE8EBsuoH1MfUiS2Wvs?=
 =?us-ascii?Q?W06tci64OUcSrav4db5B2cBm1Up/sZHIUCgS7LzT+Pc7pvboZfOh1XM758+p?=
 =?us-ascii?Q?ZMYK2Sl+T91EVG1QDCIhtc2KhzzPIVzJX9Tva2PwNLvFnpbKA0t7pCxQGDpH?=
 =?us-ascii?Q?Vu9UpskkXf5T3+yFjDv28Mvgn6Db7T2ujhUwdDPex9PNLtBPC31+TfQm93An?=
 =?us-ascii?Q?8gMtLOdL460qe5y1dm2FrGDKzycn5s2BZ3t1pMMZPgmc7HA7y5HK?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8b56db9-0689-4ca5-c3ea-08da31d70ed0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 16:14:56.4982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jiMWXrOokJ5QEKKHS90wDHxZlSa1n8ORuQMtaLObQ5RdCHEWldHIB/3FvoM1pweFyr+vCm5F0n87getAJ0cDIi0GiRncOh7xU/CE+/I8jbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5239
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

Thanks for all the feedback (on this and the other patches). They all
seem straightforward for me to implement. 

On Mon, May 09, 2022 at 11:02:42AM +0200, Andy Shevchenko wrote:
> On Sun, May 8, 2022 at 8:53 PM Colin Foster
> <colin.foster@in-advantage.com> wrote:
> >
> > The VSC7512 is a networking chip that contains several peripherals. Many of
> > these peripherals are currently supported by the VSC7513 and VSC7514 chips,
> > but those run on an internal CPU. The VSC7512 lacks this CPU, and must be
> > controlled externally.
> >
> > Utilize the existing drivers by referencing the chip as an MFD. Add support
> > for the two MDIO buses, the internal phys, pinctrl, and serial GPIO.
> 
> ...
> 
> > +         If unsure, say N
> 
> Seems like an abrupt sentence.

It seems to match a common theme in Kconfigs (1149 hits)... although
I notice they all have a '.' at the end, which I'll add.

> 
> ...
> 
> > +EXPORT_SYMBOL(ocelot_chip_reset);
> 
> Please, switch to the namespace (_NS) variant of the exported-imported
> symbols for these drivers.
> 
> ...
> 
> > +int ocelot_core_init(struct device *dev)
> > +{
> > +       int ret;
> > +
> > +       ret = devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_devs,
> > +                                  ARRAY_SIZE(vsc7512_devs), NULL, 0, NULL);
> > +       if (ret) {
> > +               dev_err(dev, "Failed to add sub-devices: %d\n", ret);
> > +               return ret;
> > +       }
> > +
> > +       return 0;
> 
> Isn't it simple
> 
>   return devm_mfd_add_devices(...);
> 
> ?
> 
> > +}
> 
> ...
> 
> > +#include <linux/of.h>
> 
> Do you really use this? (See also below).
> 
> ...
> 
> > +#define VSC7512_CPUORG_RES_START       0x71000000
> > +#define VSC7512_CPUORG_RES_SIZE                0x2ff
> 
> Doesn't look right.
> I'm expecting to see 0x300 here and -1 where it's needed in the code.

I see what you're saying. I can do that. Also, this number is larger
than it needs to be - the max defined register in this block is 0x34.
Thanks for pointing this out!

> 
> ...
> 
> > +static const struct regmap_config ocelot_spi_regmap_config = {
> > +       .reg_bits = 24,
> > +       .reg_stride = 4,
> > +       .reg_downshift = 2,
> > +       .val_bits = 32,
> > +
> > +       .write_flag_mask = 0x80,
> 
> > +       .max_register = 0xffffffff,
> 
> Is it for real?! Have you considered what happens if someone actually
> tries to read all these registers (and for the record it's not a
> theoretical case, since the user may do it via debugfs)?

You had me worried for a second there. This is a useless assignment,
since the max_register gets calculated when the regmap is actually
initialized, based on the struct resoruce. I'll remove this.

> 
> > +       .use_single_write = true,
> > +       .can_multi_write = false,
> > +
> > +       .reg_format_endian = REGMAP_ENDIAN_BIG,
> > +       .val_format_endian = REGMAP_ENDIAN_NATIVE,
> > +};
> 
> ...
> 
> > +       if (ddata->spi_padding_bytes > 0) {
> 
> ' > 0' part is redundant.
> 
> > +               memset(&padding, 0, sizeof(padding));
> > +
> > +               padding.len = ddata->spi_padding_bytes;
> > +               padding.tx_buf = dummy_buf;
> > +               padding.dummy_data = 1;
> > +
> > +               spi_message_add_tail(&padding, &msg);
> > +       }
> 
> ...
> 
> > +       memcpy(&regmap_config, &ocelot_spi_regmap_config,
> > +              sizeof(ocelot_spi_regmap_config));
> 
> sizeof(regmap_config) is a bit safer (in case somebody changes the
> types of the src and dst).
> 
> ...
> 
> > +       err = spi_setup(spi);
> > +       if (err < 0) {
> > +               dev_err(&spi->dev, "Error %d initializing SPI\n", err);
> > +               return err;
> 
> return dev_err_probe(...);
> 
> > +       }
> ...
> 
> > +       ddata->cpuorg_regmap =
> > +               ocelot_spi_devm_init_regmap(dev, dev,
> > +                                           &vsc7512_dev_cpuorg_resource);
> 
> It's easier to read when it's a longer line. At least the last two can
> be on one line.
> 
> ...
> 
> > +       ddata->gcb_regmap = ocelot_spi_devm_init_regmap(dev, dev,
> > +                                                       &vsc7512_gcb_resource);
> 
> Do you have different cases for two first parameters? If not, drop duplication.

Yes. The thought here is the first "dev" is everything needed to
communicate with the chip. SPI bus, frequency, padding, etc.

The second "dev" is child device, to which the regmap gets
devm-attached. That should allow modules of the child devices to be
loaded / unloaded.

> 
> ...
> 
> > +       if (err) {
> > +               dev_err(dev, "Error %d initializing Ocelot SPI bus\n", err);
> > +               return err;
> 
> return dev_err_probe(...);
> 
> And everywhere else where it's appropriate.
> 
> > +       }
> 
> ...
> 
> > +const struct of_device_id ocelot_spi_of_match[] = {
> > +       { .compatible = "mscc,vsc7512_mfd_spi" },
> > +       { },
> 
> No comma for terminator entry.
> 
> > +};
> 
> ...
> 
> > +               .of_match_table = of_match_ptr(ocelot_spi_of_match),
> 
> of_match_ptr() is rather harmful than useful. We have a lot of
> compiler warnings due to misuse of this. Besides that it prevents to
> use driver in non-OF environments (if it is / will be the case).

I used drivers/mfd/madera* as my template, since it seemed the closest
to what I was trying to achieve. Are you saying just to omit the
of_match_ptr wrapper (like in drivers/mfd/sprd-sc27xx-spi.c?)

> 
> ...
> 
> > +/*
> > + * Copyright 2021 Innovative Advantage Inc.
> > + */
> 
> One line.
> 
> ...
> 
> > +#include <linux/regmap.h>
> 
> I don't see the users of this. Use forward declarations (many of them
> are actually missed).
> 
> Also, seems kconfig.h, err.h and errno.h missed.

Thanks for pointing this out. I'll check these.

> 
> > +#include <asm/byteorder.h>
> 
> > +struct ocelot_ddata {
> > +       struct device *dev;
> > +       struct regmap *gcb_regmap;
> > +       struct regmap *cpuorg_regmap;
> > +       int spi_padding_bytes;
> > +       struct spi_device *spi;
> > +};
> 
> ...
> 
> > +#if IS_ENABLED(CONFIG_MFD_OCELOT)
> > +struct regmap *ocelot_init_regmap_from_resource(struct device *child,
> > +                                               const struct resource *res);
> > +#else
> >  static inline struct regmap *
> >  ocelot_init_regmap_from_resource(struct device *child,
> >                                  const struct resource *res)
> >  {
> >         return ERR_PTR(-EOPNOTSUPP);
> >  }
> 
> -- 
> With Best Regards,
> Andy Shevchenko
