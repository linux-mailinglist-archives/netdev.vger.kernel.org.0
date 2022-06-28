Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4012A55EEC8
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbiF1UF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 16:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235680AbiF1UFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 16:05:08 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2135.outbound.protection.outlook.com [40.107.94.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925AE38BC9;
        Tue, 28 Jun 2022 12:57:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dH3v8GUl/s9tjZlz2VrMaK17oxPeUhLHxiM9wmnnBpzVWXJ1Q/2IrI8pkoBbR0LPXMHu2DfMGG0b2xKa/bpgnbY6kx3mIh0JlzEB2b0B3jTeiUqY7/KAkia/mBfQFvQjK2CeDxZ/QASPltvkJZrOmqqcsaf83ulQzUb4NQA30cowiNw+eR7LtsgRTeuISoKcNa3pmseP2fFS13qSJtOA7d4EFm4dKC7/YH5pKf2rZngFq3y2n7jJRgzJnpYF6yBOr2drqk2IW6TYOcMxQOtiTDzDi5vOKHOEq+eOyoytYEFAnPoJ0W9il2cXFqNyFbJ1w75ZKKzBjx7wWQfbSu7lbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k2bMEBiH0py5WJBJXmLDaFbc0pWz6ybSSUENuWSuisw=;
 b=a+WRpwRr6L+qzq0rmhGkaKi+g/6SZ97grTNSw5HJ1gA1mJ+fy3dwQ/kKQ+9+cuo7uKGtLVpzyQS0oA9jq/k/0eU1nIucj/haWHhkbtzsbGn/WIY0HoQqYfZRX5eIGGBM4cA64S/gX4v78ioQt3xodrT0E/v3lWx0hl/eQ4N4iQb8y6GkvSs037J4L+XxVicdb/qwZe5LfDxK9byaIA+BGlQTNdoQPUBqZEgGeMEBf9E6FOwf0TH0iqUWdnvyq1n855McnLRH++AGSbsNf2erChjxtNHx52BpG+g5kaUosIF1QCwZMiik5/iLScfPQPoftbF/JFocJzjrV45rUckocw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k2bMEBiH0py5WJBJXmLDaFbc0pWz6ybSSUENuWSuisw=;
 b=wEL30JWjqC5PhLVyUQc21O4ckG314JS5omt7VGvSYeCLqj3AhNhtewd/LJaFbvAwFy5Fd0kyUIZpUoB6xKMcIetiw9BE8UGyW+6ErufHInfMBdC4oXw+84SWsL9Wg74CtGLvhrKImmBpIDOLhxEAYGnvkOGefbzh3P4X43v/jMc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SN4PR10MB5558.namprd10.prod.outlook.com
 (2603:10b6:806:201::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 19:56:58 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 19:56:58 +0000
Date:   Tue, 28 Jun 2022 12:56:54 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
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
Message-ID: <20220628195654.GE855398@euler>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
 <20220628081709.829811-2-colin.foster@in-advantage.com>
 <20220628160809.marto7t6k24lneau@skbuf>
 <20220628172518.GA855398@euler>
 <20220628184659.sel4kfvrm2z6rwx6@skbuf>
 <20220628185638.dpm2w2rfc3xls7xd@skbuf>
 <CAHp75Ve-MF=MafvwYbFvW330-GhZM9VKKUWmSVxUQ4r_8U1mJQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Ve-MF=MafvwYbFvW330-GhZM9VKKUWmSVxUQ4r_8U1mJQ@mail.gmail.com>
X-ClientProxiedBy: SJ0PR03CA0341.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::16) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a06343ff-7637-40e8-4a63-08da59405c0d
X-MS-TrafficTypeDiagnostic: SN4PR10MB5558:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D5ONm9P4zqYTradX4dvFC7GpNY4JpHUNO5kGT+51VvPNpdlP7BHHDHr3dsenZj4eXKp+PhOb1SFMuzuy4IBa3esS5SwMHqpSa7f5oKS9Mrskx4/PADq0Fy4M077mqeZ2PF4OzEvIweGDiL9rOILGlsx6kdCGloULHs/MGa4zX41aP//0ZDOqaT6y+fbG21wm4NSgfu0thlbi2SDYuiOJRo4DtEXISumb7k3ihMq5aWoNI66wxsRuH7d67GBXj/h88VkCbnQc/gV5gtVHZbuq0CVeWJJYWjWrtoBC4tFB124dRKIJbef8afFj7EtXpaFngxtMKX2zF8Id0nJ7jAhZvGVZvIH7tQWUBpiBw1BtWLGZng3MKVGoUR0zcgBzDQx5OLlvhgJCvkxom+a3pGNFNEbnVP/15B2ts/A18qqv4f0q35uDxZ7+//ra2ehQ7X4LdlHecmJJAGpiC30GYLZukUhce/k+zMsNkXoGgLwftfDDfP1Uz9lAV232Qu4Cm5uXuLjTylBZ29rZYe3o+4ziWeFbeWmpG3FYFRbwzkslTbDcoOhXrvvAO8Yp/kxqFPb4RQLQLb53lmrLHeqyrltI1IR4r5Yo6z60s9tCUvr00RZUqRFwrv2eu1jumVlomtzxwEG5SLU50053l9PhdAapCf6hlCP9dtHftj/oPmQcmFEWka0G5UI4pPMf5W7gx2gOMRZf5nKO2N8X/Uma7gRDJ+2Sr2P2jD3znNgSokpaXBCUDFG2K7CjM76RZ+/GabW6KXnSk1sRv9ZO0wSNgU/FFsqN4aRUM8lcnXHg+vQNWKw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(39840400004)(376002)(136003)(366004)(346002)(9686003)(6512007)(41300700001)(44832011)(7416002)(52116002)(54906003)(53546011)(6486002)(83380400001)(6506007)(478600001)(26005)(1076003)(2906002)(6666004)(186003)(66476007)(8676002)(66556008)(66946007)(5660300002)(316002)(8936002)(38100700002)(4326008)(38350700002)(6916009)(33716001)(33656002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pItpBvqWhxs5tCuOMgqjowoU2jgRaFgdZyJs+MRGHkTLu3TjVKUdZaqozkm6?=
 =?us-ascii?Q?3nx471mvUO8g1zoiooNzrCHyn2EVk5KwCCgoQp5JLFgBkw3x9PimUpsNQ9rN?=
 =?us-ascii?Q?YZdFBFlenXkexqKK66yGc+gHsg9ewbLRiZeDB+mrFm9gPIbf3syvPaLdP4Kx?=
 =?us-ascii?Q?+2tOaU/I/BKUpUTT/GMZPEWwz6NBTiuynoNdoZXERQ7y/WVhgFFe01xU4j5P?=
 =?us-ascii?Q?w6ZCJRf47ZOnQUf2N5Ubjdvhv8oyJsqWflLptFFHV8J0JrKz6zfkkDeBB0iI?=
 =?us-ascii?Q?JBP5UFNi7+ZzSq4erGMLS9XrX75Nu05iA4Q938z3t1jUJqzoSYXzH5TLxcVF?=
 =?us-ascii?Q?Hah20ajoAx1YmWJ6coqZ1Ur7h9NMh/LpcluDCaPdPhYU41oyZaNzCsu53h9F?=
 =?us-ascii?Q?eVNwkIWtWwS/LtcE948QT68UfpgvfzpZWMxaM8BjgFZ91DMMPK1k1fl+eYSy?=
 =?us-ascii?Q?ZWqjkQEa+p/sUHBp030WVz6a2qbIExU/lbaWUSubXHq0sGasfRVFMs4hkQcW?=
 =?us-ascii?Q?julm0RUWAPqWR4kq7b1qQ7IEoA4zCZSHyYmvLtAmFhN3j2DkompCbfRQZbvl?=
 =?us-ascii?Q?7ASJgaTHjov5oQs0M2wtI3C7QHI+gDOmoEo12bg1RZISjpyMEQvesXL8L6Xw?=
 =?us-ascii?Q?DuifE5v6tTN+IxXi2FCuBe5ueCWgtTapfJTd4XmPAnfjDWobaLAKw12r49h/?=
 =?us-ascii?Q?W5LfleJXg/XqkH24EOaOqIeYyKGLJubTDQaGiJQNy6D28ISlQ4ZChK85lHkD?=
 =?us-ascii?Q?wtXNJia0O+ejfNs53jF1h6Ra/H2t9nyIxpAerC15PU8K2yhdLC524310Vx0z?=
 =?us-ascii?Q?TPduR8syBUmTlafRADfpVA/1FKCiScRwhlJ9r5KQTPJq3K6MuP27GBEcDCAJ?=
 =?us-ascii?Q?nhzuW78+rOHmFSRL2B03obUi5VcEus+5HJuQE0Do6WpQ6wmZ/awYCfA1EIY6?=
 =?us-ascii?Q?jpvwtoeVVr1E9ucMCWMWy0jlDpp0xyedrfta+9bsqKhWQkuB/Gp9BaWAs1zp?=
 =?us-ascii?Q?JFeVZ0LISi6fiFpY3L8qXBVMv9A/QqRLtjL3tevU5uua/O4PN0GzAB4i7K3O?=
 =?us-ascii?Q?9t3Sq8/xq9NXsiVDv2mKV0xK8wNdk5ojC/NSmo2zRQ9iVz+Hc/GdQrA8Zqwy?=
 =?us-ascii?Q?YZjGS3iaSOUbIVC0/T+9SH0ngUnqGDr65xk35pChBEJfK5empzGj5+OcWz6f?=
 =?us-ascii?Q?QrvUZudds2I9FgKVz4PmtbgL4DqkDqjjMJVetPLJIkyo8eT2uOwej6+TFcp2?=
 =?us-ascii?Q?NOt7B1B3769yZd2mlt1rgKrwb4RrKm0U2iD1PMBXEw/+3NvgGHeLWE7HbBBF?=
 =?us-ascii?Q?mflXm6bBWL1SBhrJcwBQCob11gjhIgQQAXjd2T1OntYGxaxNvI42RvzBfDjH?=
 =?us-ascii?Q?NBDN4KPab9Jm47yAWHfckamEGHDvIR/zbSTLaSy8xyojMk+MdQY/cQH9xBCV?=
 =?us-ascii?Q?FIwDxXgONXBppTXVUTNolgdVCv8KHjhiBS/KxqQaTtGUcL22k5aeFhYKU1Qn?=
 =?us-ascii?Q?RLl15SFzqWSDaWtCnqnY6ksNhS66uUiwtA1r1DIo69v1kOpE1DoX4sg7SnO3?=
 =?us-ascii?Q?G8zXuThN7TNeEBnoKqgQlcfPe12RXcfVww06mcZ1nGVUVltQrJ9pTCgD6uIq?=
 =?us-ascii?Q?f3uryL7lI1FtCC4xlfb2js4=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a06343ff-7637-40e8-4a63-08da59405c0d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 19:56:58.6312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XEQAt6ApoH5nSe6eKnDgo/myn5/Es9S+ODIv1Tm5El8DmYtmdzWeQGfoc/2/rlQxwlf9Nk0b1zfNxHEQLyKrWXxVWG/BN6hS+issSFtdMD8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5558
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 09:04:21PM +0200, Andy Shevchenko wrote:
> On Tue, Jun 28, 2022 at 8:56 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> >
> > On Tue, Jun 28, 2022 at 09:46:59PM +0300, Vladimir Oltean wrote:
> > > I searched for 5 minutes or so, and I noticed regmap_attach_dev() and
> > > dev_get_regmap(), maybe those could be of help?
> >
> > ah, I see I haven't really brought anything of value to the table,
> > dev_get_regmap() was discussed around v1 or so. I'll read the
> > discussions again in a couple of hours to remember what was wrong with
> > it such that you aren't using it anymore.
> 
> It would be nice if you can comment after here to clarify that.
> Because in another series (not related to this anyhow) somebody
> insisted to use dev_get_regmap().

To add some info: The main issue at that time was "how do I get a spi
regmap instead of an mmio regmap from the device". V1 was very early,
and was before I knew about the pinctrl / mdio drivers that were to
come, so that led to the existing MFD implementation.

I came across the IORESOURCE_REG, which seems to be created for exactly
this purpose. Seemingly I'm pretty unique though, since IORESOURCE_REG
doesn't get used much compared to IORESOURCE_MEM.

Though I'll revisit this again. The switch portion of this driver (no
longer included in this patch set) is actually quite different from the
rest of the MFD in how it allocates regmaps, and that might have been
a major contributor at the time. So maybe I dismissed it at the time,
but it actually makes sense for the MFD portion now.

> 
> -- 
> With Best Regards,
> Andy Shevchenko
