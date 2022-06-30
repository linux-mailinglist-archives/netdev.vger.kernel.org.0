Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DABE5623F1
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 22:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237115AbiF3UKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 16:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237000AbiF3UKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 16:10:08 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2136.outbound.protection.outlook.com [40.107.212.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DC74579C;
        Thu, 30 Jun 2022 13:09:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EV2cge2DyLp0tBzhX07wONDG3IR2neevKE7P/NWbacM8VmxIvG7ryUmlN5QRY/0KvVDW53TH/zAgo+VKJdZwc7x9ay/N587EstLJC+99FKuBwhGWo+8EKE7qph9KjPNzI6qazlNM83MnZ94lPhIIWbB+JimGoX6vloprLP4fEUGXM3hGm4+IES5uVd5I/SVYtb2hgPMmLd2BaVyW+V1BF7kQLKNvl6kRmuj/zlDsMwyat7DAToZsyS/arPgddMJyNOc8VfPD8kFS1lzntlbfMrjD59Bfgs2lJ7+jZK+Jzj4hPidHo8Ky0Brc3K3KjjdO8vzE+bkJYRUuE4EWFvbryQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ogMWQIYA9pxfw5hVK4YaeHRyGVTF9RxxWXiyTsrtWNs=;
 b=NI5cV5qCT3568TdJV1Dh6RZET0vuDLDRMAee0/bhrPkHvmaO6mjYSOGRxCisURx93d2usby3BJqVCKxMlp+ZNYaW2ru4P84Yr4Y6nLQCbV8bexW8+lU2pEgcjXMqfa9Q2uSEA5W6Gw0w0MHcwghfx6RgBSNEaaQUnZOjMbI775pdn8KhC+iyeSZFF60N+noX8n+BacY1uU3uiOBwJIBDGnObHn0XukQw1w1RdFl+3F+uICfjDuHidwcVBS/kJ6lOn3Z7mt+gwXuBDEjxb0r3eURZM2DASEDjgnL0fV+qWNHldQ6QX4cnvPQm7QwP8fReQiGWzzOMIrP2b/1chulBCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ogMWQIYA9pxfw5hVK4YaeHRyGVTF9RxxWXiyTsrtWNs=;
 b=hvD6f7WbP3kFYiDqYA60BNIKAm5ZU/27LRCrkhdMlon5CpJql2iW7PxcRrary9RZrdGM22E+APvmuMjHWbSLDdGTD5ebsgJentQaNZ0K3HNjm11Y3vOm+j+zwXqWjoGqkbsjSxvfDdohEjTlPiyfA/9E6TvQmgZkqkICJNT4vEg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM8PR10MB5464.namprd10.prod.outlook.com
 (2603:10b6:8:25::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Thu, 30 Jun
 2022 20:09:54 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Thu, 30 Jun 2022
 20:09:54 +0000
Date:   Thu, 30 Jun 2022 13:09:51 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
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
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Arnd Bergmann <arnd@kernel.org>
Subject: Re: [PATCH v11 net-next 1/9] mfd: ocelot: add helper to get regmap
 from a resource
Message-ID: <20220630200951.GB2152027@euler>
References: <20220628172518.GA855398@euler>
 <20220628184659.sel4kfvrm2z6rwx6@skbuf>
 <20220628185638.dpm2w2rfc3xls7xd@skbuf>
 <CAHp75Ve-MF=MafvwYbFvW330-GhZM9VKKUWmSVxUQ4r_8U1mJQ@mail.gmail.com>
 <20220628195654.GE855398@euler>
 <20220629175305.4pugpbmf5ezeemx3@skbuf>
 <20220629203905.GA932353@euler>
 <20220629230805.klgcklovkkunn5cm@skbuf>
 <20220629235435.GA992734@euler>
 <20220630131155.hs7jzehiyw7tpf5f@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630131155.hs7jzehiyw7tpf5f@skbuf>
X-ClientProxiedBy: MW4PR03CA0097.namprd03.prod.outlook.com
 (2603:10b6:303:b7::12) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a5474b3-1703-47c0-fce5-08da5ad47f3f
X-MS-TrafficTypeDiagnostic: DM8PR10MB5464:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kRzouS1JhJeC33P3S+SRs06gUbdBWffymTg16DWy0lB4Gz+tRMrAOHQTHsRcqkwD0fmVClI7Up+D49s0KeFbmXWu37Z9HwgXZPmUhtj9VviK2Pc7T/RgMXve2629+QO027Go8bzUn0QZcTxigcSioyfgkepuj0Kqcmz3GGl6NAorirWrNtuC1/ejQQCOZzIG0fi6MftUzrqPa7B6zoI6sLAUa88oWvuderSpKOaJzQSelU7UZ2Wr8JMaWuluR/P036dZ9LT23rhthESakp/Fo3KVtD183pAyNE0J7SOP5wDm3O55MKQFUjIiLEuPHhRRYv6L2dvNJCs7mU4rptSLWJ0tdS2uxJbi8CYegKgMnJhIA2y5p/5bgyzaYAjw6Q0JHX6XUzL1ehePYqSy+LJkQ4Fma71Q7nmnVif7MC5XfXd248Fi7L9taWFiR2cLXWJ0yYfwNyoBECdAMD5CJIw24d0iEopU0bTTtaOdHZjfIkv3X0LQIks4wUVTbfNlu1nEDmuBf6DT4sFVdBpgFXoKJ8SOLXhnQWRe8W/kDyq0Nmqc0Sw6KOFzM5Lh6roXtComNg3CqcSPqzgu0GXUxRosfMWBP+Sxt29Cp/xEnPyofi1fvcdaKNUUoNPEp53mNXo+iJEsKrrh5WAZRUBZzz8LIxljj8QB5bZB7Prke0g38XujuTI3o+DZWu/P9aIwOXfXzfcHBzJTTe4qlsYnKso0c+OcwByL117fFNIDpZ9e2AU572aPugpfILxJKpKPCSFfl9RjAI+a11+AP5xQrVu/CCkDxAia2e4jT3kLV1elplwdrRadH1v4TuOE7FqsB7QF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(136003)(376002)(366004)(396003)(39830400003)(7416002)(1076003)(83380400001)(186003)(5660300002)(33716001)(8936002)(44832011)(478600001)(26005)(6512007)(6506007)(52116002)(33656002)(6666004)(6486002)(9686003)(316002)(41300700001)(54906003)(6916009)(2906002)(38100700002)(38350700002)(8676002)(66556008)(66946007)(4326008)(66476007)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zVz/DNELVWnmMkQnzfFIUEJ/jQoMH5aIx0I7Bk7ECFwhsvJLNDvrj55qMzdR?=
 =?us-ascii?Q?Kki7KIGQSrJuubWBI66uu5ny7uOdI9d5Z/YiB/IcADB5Vjarm5dh/Vi2shBm?=
 =?us-ascii?Q?Z6eebhnfjt0hsj5PyCd0gDljaKzZwSoIXQmnscNyWmBF13fWYiJZEvM9pt+y?=
 =?us-ascii?Q?RlJQyuF4xGjPo+y/fqG1jApso1E4SdMJWF3yMGsEjLLsvmVFMFLqSJtfFl/l?=
 =?us-ascii?Q?nIMsFufL1Msa3+Bbbmf4aZTg6ERHD4sjMr3au5rFWUIYe6+t3GlOaOiHk108?=
 =?us-ascii?Q?heT6xM5kA7eBebj1MRHclOyDpup//Qqjh75Nib0KSeagSan5aRHKolztWrLu?=
 =?us-ascii?Q?TUL3+zHqd9BNfaX/B57IqNmQ9+hOYfJZjqBzRpi7jrjuToSD0JAH6h0q7loy?=
 =?us-ascii?Q?cANiSafoOIWY7kli+dBTlPtHKEZ/b3GndnFeCvZbJM0rwyXTzQq3QH2zRUOl?=
 =?us-ascii?Q?kSuVr217L6wGDCIJ4fOeTKqzs19my1Ym0i2rm5mPhK+tSiNKYWN8LjvDvTQU?=
 =?us-ascii?Q?O2VyAQoHZMmLHkhtT18oUQLTNvF8R6PPsHmJ30vPwhnTY8ykJHxIXnufmGOj?=
 =?us-ascii?Q?jemh43eZMoB5/KnlCFFzEFJZWnMvMKlry+uhdKZQNjxYHW5g7/dWBjmqyoNP?=
 =?us-ascii?Q?uWEF2M5zrhsMdW9SBl+7WklnUg6n3A0OQlWMtBC0WZPrILM/a5nOKWUle4JB?=
 =?us-ascii?Q?AWdnTaz6x6TURIGaQT77jc2uExDH5SoNAo0C1c2LUtTFPg718RgIwiBuGR1A?=
 =?us-ascii?Q?srg7vz44UNeJtfHd2H1gloTtQxUvoPoKuqwh+JuRcAdx7uCmdtTudl/WBnLL?=
 =?us-ascii?Q?NXpGIu7Et+R0aXviJf05Kvbce5zmYAPa3Z952MHKjmfLPAUdaSJDJsl8Yuen?=
 =?us-ascii?Q?ujXtygm+5SK0zFprUQm5UZxZdCwgxqyyY2P5/mcZLYC2CTY0WQ6dui1l9eig?=
 =?us-ascii?Q?IBtNxMLTX1mSGB6l1bwqXiGFArjG80VQhOd6PsZgBJObGQRW2AxKlwrlNTpc?=
 =?us-ascii?Q?PguhDcZ++Wg4xwerxbRBhGAUoWSA3UkVQSDEMFt1tXyEWFapmkJEKIcgWhQJ?=
 =?us-ascii?Q?YHsGsytigmK7AxU56hsCDKXwRZKa6Y8ZLCOo7dbikKrIeeZ+xq8Hie73lUVk?=
 =?us-ascii?Q?Qr6vb6wUJFDYgWyl/xTD0tfogjehKYH5xv6bdqUypllaUJLElWN34/fy8Nf0?=
 =?us-ascii?Q?MjYzEDqzcXLX+sHkBIK8j2yvRXAYJ3YVlSnZrgAjHQHHCqWqA0xwo8E3gYIu?=
 =?us-ascii?Q?4O75mzgDwkLr0rJDIvSr+o2qbujULDIjbJI3fVHWYGEicfNimVUPi9Ohzp9e?=
 =?us-ascii?Q?4CZ8jg9KklemOKKT9dCI8uOo/RKsuVCRJ8flfqJpJdz3JI15vmgIisZTC8wz?=
 =?us-ascii?Q?hCxBHLac4t7NFxm3ljho/bwZ4mdWbfOaSz3t7ppMAYDd0ax6P8Zsb945jC4G?=
 =?us-ascii?Q?kAOgKqt6DDT+hba+6El6T3J3CQts4FYwVmEsM/kGmuGGK9Iws8srsqNMKNAM?=
 =?us-ascii?Q?2yQ8g+BqoeRcW6mE1yfGdaTaeJeVjCf27IPEemYCqFC8NNv0sQS3oVCrtBeu?=
 =?us-ascii?Q?O0wPwJ6CKmoCqHXBCwp7SOoSbmOQL55+L/Z7rFzDXem80j6SqxsdMqnAMWkt?=
 =?us-ascii?Q?9w=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a5474b3-1703-47c0-fce5-08da5ad47f3f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 20:09:54.3156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w53q5kjVb9jHYS+TY6vPn1aK0TUumM/5n4BbwYTawZiuIfcVHptFNTWzCQM1WceTG2BFnVuQeCTTjacNoTfQ8YDSp08gRFmTpBNTzk+t1hI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR10MB5464
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 01:11:56PM +0000, Vladimir Oltean wrote:
> On Wed, Jun 29, 2022 at 04:54:35PM -0700, Colin Foster wrote:
> > > > In that case, "name" would either be hard-coded to match what is in
> > > > drivers/mfd/ocelot-core.c. The other option is to fall back to
> > > > platform_get_resource(pdev, IORESOURCE_REG, 0), and pass in
> > > > resource->name. I'll be able to deal with that when I try it. (hopefully
> > > > this evening)
> > > 
> > > I'm not exactly clear on what you'd do with the REG resource once you
> > > get it. Assuming you'd get access to the "reg = <0x71070034 0x6c>;"
> > > from the device tree, what next, who's going to set up the SPI regmap
> > > for you?
> > 
> > The REG resource would only get the resource name, while the MFD core
> > driver would set up the regmaps.
> > 
> > e.g. drivers/mfd/ocelot-core.c has (annotated):
> > static const struct resource vsc7512_sgpio_resources[] = {
> >     DEFINE_RES_REG_NAMED(start, size, "gcb_gpio") };
> > 
> > Now, the drivers/pinctrl/pinctrl-ocelot.c expects resource 0 to be the
> > gpio resource, and gets the resource by index.
> > 
> > So for this there seem to be two options:
> > Option 1:
> > drivers/pinctrl/pinctrl-ocelot.c:
> > res = platform_get_resource(pdev, IORESOURCE_REG, 0);
> > map = dev_get_regmap(dev->parent, res->name);
> > 
> > 
> > OR Option 2:
> > include/linux/mfd/ocelot.h has something like:
> > #define GCB_GPIO_REGMAP_NAME "gcb_gpio"
> > 
> > and drivers/pinctrl/pinctrl-ocelot.c skips get_resource and jumps to:
> > map = dev_get_regmap(dev->parent, GCB_GPIO_REGMAP_NAME);
> > 
> > (With error checking, macro reuse, etc.)
> > 
> > 
> > I like option 1, since it then makes ocelot-pinctrl.c have no reliance
> > on include/linux/mfd/ocelot.h. But in both cases, all the regmaps are
> > set up in advance during the start of ocelot_core_init, just before
> > devm_mfd_add_devices is called.
> > 
> > 
> > I should be able to test this all tonight.
> 
> I see what you mean now with the named resources from drivers/mfd/ocelot-core.c.
> I don't particularly like the platform_get_resource(0) option, because
> it's not as obvious/searchable what resource the pinctrl driver is
> asking for.
> 
> I suppose a compromise variant might be to combine the 2 options.
> Put enum ocelot_target in a header included by both drivers/mfd/ocelot-core.c,
> then create a _single_ resource table in the MFD driver, indexed by enum
> ocelot_target:
> 
> static const struct resource vsc7512_resources[TARGET_MAX] = {
> 	[ANA] = DEFINE_RES_REG_NAMED(start, end, "ana"),
> 	...
> };
> 
> then provide the exact same resource table to all children.
> 
> In the pinctrl driver you can then do:
> 	res = platform_get_resource(pdev, IORESOURCE_REG, GPIO);
> 	map = dev_get_regmap(dev->parent, res->name);
> 
> and you get both the benefit of not hardcoding the string twice, and the
> benefit of having some obvious keyword which can be used to link the mfd
> driver to the child driver via grep, for those trying to understand what
> goes on.
> 
> In addition, if there's a single resource table used for all peripherals,
> theoretically you need to modify less code in mfd/ocelot-core.c in case
> one driver or another needs access to one more regmap, if that regmap
> happened to be needed by some other driver already. Plus fewer tables to
> lug around, in general.

Ok... so I haven't yet changed any of the pinctrl / mdio drivers yet,
but I'm liking this:

static inline struct regmap *
ocelot_regmap_from_resource(struct platform_device *pdev, unsigned int index,
                            const struct regmap_config *config)
{
        struct device *dev = &pdev->dev;
        struct resource *res;
        u32 __iomem *regs;

        res = platform_get_resource(pdev, IORESOURCE_MEM, index);
        if (res) {
                regs = devm_ioremap_resource(dev, res);
                if (IS_ERR(regs))
                        return ERR_CAST(regs);
                return devm_regmap_init_mmio(dev, regs, config);
        }

        /*
         * Fall back to using REG and getting the resource from the parent
         * device, which is possible in an MFD configuration
         */
        res = platform_get_resource(pdev, IORESOURCE_REG, index);
        if (!res)
                return ERR_PTR(-ENOENT);

        return (dev_get_regmap(dev->parent, res->name));
}

So now there's no need for #if (CONFIG_MFD_OCELOT) - it can just remain
an inline helper function. And so long as ocelot_core_init does this:

static void ocelot_core_try_add_regmap(struct device *dev,
                                       const struct resource *res)
{
        if (!dev_get_regmap(dev, res->name)) {
                ocelot_spi_init_regmap(dev, res);
        }
}

static void ocelot_core_try_add_regmaps(struct device *dev,
                                        const struct mfd_cell *cell)
{
        int i;

        for (i = 0; i < cell->num_resources; i++) {
                ocelot_core_try_add_regmap(dev, &cell->resources[i]);
        }
}

int ocelot_core_init(struct device *dev)
{
        int i, ndevs;

        ndevs = ARRAY_SIZE(vsc7512_devs);

        for (i = 0; i < ndevs; i++)
                ocelot_core_try_add_regmaps(dev, &vsc7512_devs[i]);

        return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_devs,
                                    ndevs, NULL, 0, NULL);
}
EXPORT_SYMBOL_NS(ocelot_core_init, MFD_OCELOT);

we're good! (sorry about spaces / tabs... I have to up my mutt/vim/tmux
game still)


I like the enum / macro idea for cleanup, but I think that's a different
problem I can address. The main question I have now is this:

The ocelot_regmap_from_resource now has nothing to do with the ocelot
MFD system. It is generic. (If you listen carefully, you might hear me
cheering)

I can keep this in linux/mfd/ocelot.h, but is this actually something
that belongs elsewhere? platform? device? mfd-core?


And yes, I like the idea of changing the driver to
"ocelot_regmap_from_resource(pdev, GPIO, config);" from
"ocelot_regmap_from_resource(pdev, 0, config);"

