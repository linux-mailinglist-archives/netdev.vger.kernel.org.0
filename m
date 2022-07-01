Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E97F563B30
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 22:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbiGAUfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 16:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiGAUfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 16:35:01 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2106.outbound.protection.outlook.com [40.107.95.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3041915A21;
        Fri,  1 Jul 2022 13:35:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMq7C9LWIS4riJ9RBiSoUlt70xe49Jm6BavzeVO9z/fQMfu8Kv3DyiSKe6ZhLn1ejW/R8pZJYnrm7Chzi8Ds22hEikr1fHFdhVPIFPyLn6dWUr0p8LqZc3s51IUkXFtLHVlacfF+CwvsTtvC84F9Qgrqlf6qjRhpLa50LysEw24V4CFj+oo6rDlhkpPeW50YbyK+s1t6Pd4w8SdbZuxp88aYqL67L+MhxYAsC0KsFASFNZhhiwmJD63HiVZxC9KcL07nZ/s5h7KFbmIqv4Syfu4zUAfRUWvORKqDW52A85NNqbH2liSE7VYHgvxDhPQby3AKg1HqMr5DnOT/fvoxTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OkrFtdDaAb5B0nL0J4wiijgaxv3ztp5Vy75S7Edem/k=;
 b=AZI1LG9ko1dj7zMsIq3yRh2f3mUdAsElnh9ID3QL3fvwNUzdUqBviwHf7QyXSa3CpCGd80RcqGVjZpN42Fke8LuA4bs4Q9MDVbG93dkipi0BTdBkQrBeMWCshLoB2C6iy2ozQEjLzzSPeKYFgsdUsBp1CxLcL3byxB0E6Y3AgIh+0KG1SjAO06bWEJaplIynHTPf8mon64EFW65DSr4fCYIVPMEkFgqXnnny+cmvnyyQi6Ot2fLwM4LBo+UOVA/TY2yjPk3n6MAZH4ev2W1j1jbsG/RVh79Y5vpS7/6bxOLivWZDPzSeHHmsAUfsaKKiPyQOSsgIAgxUoUv5UILyjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OkrFtdDaAb5B0nL0J4wiijgaxv3ztp5Vy75S7Edem/k=;
 b=kloUixqXsOEEIa6ZAKTQdSKCEXpS4W0aYBPWF+BygN62egnoCAW55FGppBmILcMQOTa155gdmXRevemUBt8g97UWBjK6FyvOovdADuY6PV3xk9OK1QAUiXQwkL15gXcvm2TYY6wLTBEAGSzmPhWWlMh70EbP9yPB8oNWlxWf0Ew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB2443.namprd10.prod.outlook.com
 (2603:10b6:5:b9::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Fri, 1 Jul
 2022 20:34:57 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Fri, 1 Jul 2022
 20:34:57 +0000
Date:   Fri, 1 Jul 2022 13:34:53 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        katie.morris@in-advantage.com
Subject: Re: [PATCH v12 net-next 1/9] mfd: ocelot: add helper to get regmap
 from a resource
Message-ID: <20220701203453.GB3327062@euler>
References: <20220701192609.3970317-1-colin.foster@in-advantage.com>
 <20220701192609.3970317-2-colin.foster@in-advantage.com>
 <CAHp75Vf0FPrUPK8F=9gMuZPUsuTbSO+AB3zfh1=uAKu6L2eemA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vf0FPrUPK8F=9gMuZPUsuTbSO+AB3zfh1=uAKu6L2eemA@mail.gmail.com>
X-ClientProxiedBy: BYAPR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::22) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 480e68f1-e74d-4f1f-60f2-08da5ba129a2
X-MS-TrafficTypeDiagnostic: DM6PR10MB2443:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3sbmdvX02eI/DGgygNUCwmMtuUdHPp2tbDYmT87ijw5tFXGbYcylE4yhBAYaTZM0AWOuEjv6H8dn1yoNYfjyUivPEbukDH7GzaBxh/v3SqveAGU7OW1vx763jm7gqg42t8cHWX3lCVdar9/K3vWoWNf42n1rY5vkHjMqqZZm3lGfju/HCTW68H9gTXVu869CoP+fb/xGdqAYP3E27cyAKU/Nw/KouB6wR2ea6iSLazLVJsHTkD2YHHUcWXlpSaDrDI46MRrodDTcN3XrwGSrPbXfyA+5E4+/Y8wx/jEKXfpEijEik/ER68AE+Jm6tIu3Qdky5dQdZ2vLSskR13YchEP9ZCI4HkbfnI+p1z3NCY58O1zd/62Sj2CTSnheX1PT95yMMLCBp8oX0/NhJlIENKZwuUugbUXrZ91lMbEF6IwFUi7+KVaocoyjcGTlrrgVkAY7tUpuT1zekbQSJEPiFKIgJG9NndgMUwvN/5A82YBGH8lKdtxXWT+xCenEDQLrgkBIflmLzlQ3gN/yYFrLYP45KA/MAM7aM9bt7dENLuuisnPNG8Y2OGwWOzoT9cFvgLNfu8/JSESVqkK5LCl5/8AFcMM5how99GMWTWDl8jEefDJd8W7uiNxSonTvUCLYzkWJizL1dogi+TuS5rVC3WtiRHCuyblB2vm/nJ/2C57TrtAEGnUpdGkGTFrMw+aor1iDfJHcY03BLGbKJ9edsCLDBMnF+/NZFgQMWkdhuTVZo8IibGk9FY+EhN96QU32AL3J1irQWX0e+2E10xnGOgb9IxgV5PVj3+06c06Smqw/b4TomtL2CAf/EsuJt1mRM6584aljkfPothZh0oUdqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39840400004)(396003)(376002)(346002)(366004)(136003)(107886003)(33656002)(53546011)(66556008)(316002)(66476007)(66946007)(52116002)(8676002)(44832011)(478600001)(6916009)(6512007)(9686003)(1076003)(6666004)(26005)(186003)(86362001)(4326008)(33716001)(5660300002)(54906003)(6506007)(38350700002)(2906002)(6486002)(966005)(83380400001)(7416002)(41300700001)(38100700002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RVDe8P7pQF7uM0oqc0T51AdNvFp5wx7E1RMZcYHWPtFDOVykcPJnJgO3NMKm?=
 =?us-ascii?Q?rmnLCh40nW1dLS+zPOwErNtBez39glyYueFwu5bKkfxy9fQHDdN0ZIq7FirL?=
 =?us-ascii?Q?HfA1DtQJfwz1idZQIdPBXksG6O83qB9wGxngjGtM5Yrg5S9v48thXDEgRVjQ?=
 =?us-ascii?Q?6s85GqdTqcvNPKoHgvuVmt2J81ofRuO+lDrFAFga0aneYDeksl0hNC4u/ALF?=
 =?us-ascii?Q?6QeFQR0DoWmrm6TVlLTJgEiy7MvzKXR4iKE9zLRJed6iRK482EYxbEhLJ8BQ?=
 =?us-ascii?Q?rNxn/a55v7CMPXcj751coeon2MRVmdezbCWWxPD4D6GIoXeycoUQhbjXWGX8?=
 =?us-ascii?Q?3PIIr99xvnc42BZYpZCxXexhr3j3qsHFf4x3guy2imVpGT9ceb0N1SR3D/UH?=
 =?us-ascii?Q?Jf/EvAsJOXlVmCk/BkIjOtvUwUbVjpzUao5ouMXA76g2/fMzeT2x+gEX9SSS?=
 =?us-ascii?Q?AKUG5c1bsPJrjs1/QJub+Iuk/dRrKxiqlb+DI0On4YhFSjdd9KHdrsMlGod6?=
 =?us-ascii?Q?LGmSE5HrBzxOMAXQv4pKODcyGLPhYbPN2Zl0ueSTJeHL+dhbzhdl0bXIaD38?=
 =?us-ascii?Q?RQaN+BTer37aoHcUfRnrUk7whEsrexFrFYvHOPsJTWh9SoYGXa+u5yBDVEe7?=
 =?us-ascii?Q?qQgLjDM+1zuZ/228k3iL18IUkoocZFmiI2qZoh02mQzUTDb/O6mB89g1Q5N5?=
 =?us-ascii?Q?FNa/FYp68T2jmJaWyxrK5j5elNgYcSvtd2Ld3fgamVrCk9sRXMLxuZKJQ4O8?=
 =?us-ascii?Q?6xu9wvXb95JrChXoQyOZ3b92GkEwryOT7ZMK2+AVT4wxGrBfK2g/Xf3lVixC?=
 =?us-ascii?Q?hj7jKfoqDhg+W6u2C3Ci7S6lQg37XmT8C1OW6Gx4DKOUT49KWpkf/Woy6m2b?=
 =?us-ascii?Q?njDfUgQPEx56WsttsGrUpD/mOSDOrDIi27YmHtuuwYmaxlZQbY3suttfTDQ7?=
 =?us-ascii?Q?jMbftdBbkEWYvgXSS5WfoArA2m59JqxjxK9mDn3jn1Qsb6XTqul3sfyZfwG4?=
 =?us-ascii?Q?nzQFSpwcq5l0T5coCESUo5A2Fu4JTWAmkXuM7z+tP5icwoOdMbK49gsfDzji?=
 =?us-ascii?Q?3loVgzV2KbDR4HtHtdvjl3yMuqUiBH/4Sr+K2YkEU8p6XgGgwgAfu1AwZIal?=
 =?us-ascii?Q?qIASD3JmngVW0cmzKS6P7EjceOcndbaOPaBBUfw1bxvKHOCCtPS9ELrYSIWX?=
 =?us-ascii?Q?1ehlfW6Bfm/56mandOBAeVGycl2+nv0Sj3Cy+jpzw25VkS8OzQBFjx2Q2GCj?=
 =?us-ascii?Q?dbBxQqKzWnBAmumdyU2bHMonxNealhnqbWJ3jYfNvQD/c+Vj7iHYrwhfC5Ic?=
 =?us-ascii?Q?KLUDpZ6Zu72q3foLTZxAB3one6mG0FqJvre/cN3Gb4VJ9GBm3+pkr9iUREyH?=
 =?us-ascii?Q?Qdh79Dhjx8LDrLwUObYwonoqQhrOlFW9bibK9Xj89I6UVi4Nq9NmDmAhDdWi?=
 =?us-ascii?Q?ocC3Kum2EtvNDIzwxm+HNrrUz1RGjKzAN0iJSvIrKC+wsrxjve306UWgK6Rk?=
 =?us-ascii?Q?YcCfRQKXlXgDo18H+RQ1grOgd2abMOIFyRR7SK1oGgIEC1Ra7nAEQRG9Aw+X?=
 =?us-ascii?Q?edyHjLpCPuWJbbREhez0puFqZiBaOW1EcTne2ryepTOLuySho6zFGF7/FgiC?=
 =?us-ascii?Q?lCmbOsKF/DIM/GdXawASRAk=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 480e68f1-e74d-4f1f-60f2-08da5ba129a2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 20:34:57.5059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YgxIFG4BUmvQaBm2u2RfxyButkuwugy4s32AvpZI2ZNjXfRCMHDxUGOQQj9TP2ShyTaxkjUWx5EuMbfAibGLCNhkic9bbXBhafW9bLAVQts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2443
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 10:23:36PM +0200, Andy Shevchenko wrote:
> On Fri, Jul 1, 2022 at 9:26 PM Colin Foster
> <colin.foster@in-advantage.com> wrote:
> >
> > Several ocelot-related modules are designed for MMIO / regmaps. As such,
> > they often use a combination of devm_platform_get_and_ioremap_resource and
> > devm_regmap_init_mmio.
> >
> > Operating in an MFD might be different, in that it could be memory mapped,
> > or it could be SPI, I2C... In these cases a fallback to use IORESOURCE_REG
> > instead of IORESOURCE_MEM becomes necessary.
> >
> > When this happens, there's redundant logic that needs to be implemented in
> > every driver. In order to avoid this redundancy, utilize a single function
> > that, if the MFD scenario is enabled, will perform this fallback logic.
> 
> ...
> 
> > +       res = platform_get_resource(pdev, IORESOURCE_MEM, index);
> > +       if (res) {
> > +               regs = devm_ioremap_resource(dev, res);
> > +               if (IS_ERR(regs))
> > +                       return ERR_CAST(regs);
> 
> Why can't it be devm_platform_get_and_ioremap_resource() here?

It can... but it invokes prints of "invalid resource" during
initialization.

Here it was implied that I should break the function call out:
https://patchwork.kernel.org/project/netdevbpf/patch/20220628081709.829811-2-colin.foster@in-advantage.com/#24917551

> 
>   regs = devm_platform_get_and_ioremap_resource();
>   if (res) {
>     if (IS_ERR(regs))
>       return ERR_CAST();
>    return ...
>   }
> 
> > +               return devm_regmap_init_mmio(dev, regs, config);
> > +       }
> 
> ...
> 
> > +       return (map) ? map : ERR_PTR(-ENOENT);
> 
> Too many parentheses.
> 
> Also you may use short form of ternary operator:
> 
>        return map ?: ERR_PTR(-ENOENT);

Agreed, and I didn't know about that operator. When Vladimir suggested
it I thought it was a typo. I should've known better.

> 
> -- 
> With Best Regards,
> Andy Shevchenko
