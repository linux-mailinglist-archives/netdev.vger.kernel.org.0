Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D5A563B62
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 23:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbiGAVFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 17:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiGAVFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 17:05:05 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2126.outbound.protection.outlook.com [40.107.244.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC454F1B0;
        Fri,  1 Jul 2022 14:05:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UGHy4dVvERjHYES+Tp8s1psjUvC8F+qrRfJ3uveAl3kRCsEBNI105vo3xgnEq9gIfzYJEXFdODK4/fvzjhj7IHjEJjpN2UfFSNOomOR9KU27KG9yhQYL0SJG8agMn9+udKLlzBybtlpsNQpof3Y/5rWh0fTSaY6NAALG8+A+AM2j/zDxR+rTp2Fe18/CVD6XMy3JatFvpfn80lB6Ubx8ZtX2OfpG2wPG4DA9l4toevNl5rd51CN/3QGHe4+r/AlyQFIUBTcc9DzNvweEw5jWwSnTES8L17zhOoV4YB2scBIc79VzqD4ys1Ce1QSozQvIHoSWCQVryCvnYjsj07z0Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SfSJJMd3LiDzholXbLtdVILVpy9I9SIHcvcSSUP8mvk=;
 b=bp4ni4rJxpaHAZKwrnRanQCVuQc9bv9uIeKkTCdmivTy+bFc03oMWZJWK5P5soeDmURV83uW5NMmtAasbny67Ey/J/QoWV4dKPI2WPPuM3/Oi3m88JD7hlfPoGCs383j81A5L+ZrKMpUroITU+Z+9VXCd5zzVjFxxP6Gn00UbA2fZ4TycjIDynAat6f3FpjSeCMn6wIUko2E1jBqx69geUn9y76xgreGdL3AbNw6SSPXLoF11oETESS8W4K1YrH3Rg0hXcV5cD3nq5pAPt2C2sxZKdkbcxHLqwbdMoEB2xEejXPK6spWsDSZSagCSF1xHo5sJyqYXn+1JQ4fBtra6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SfSJJMd3LiDzholXbLtdVILVpy9I9SIHcvcSSUP8mvk=;
 b=zt4s4JfgK41/rCNgrNIsEFQutwFFhVLRgTuFk4Js+8GPZC2CZZagEJP0v7sboOih09QRA7bxIuP6vhEOmuuHa2NOX552GalVQhcqyO3z2T/eNAwHpFD3EMxKpvq68lVAognZQrjarxjZpJ5X6+4XQK9GKOTEuSLuckR19HXvTpg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4674.namprd10.prod.outlook.com
 (2603:10b6:303:9c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Fri, 1 Jul
 2022 21:05:01 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Fri, 1 Jul 2022
 21:05:01 +0000
Date:   Fri, 1 Jul 2022 14:04:49 -0700
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
Subject: Re: [PATCH v12 net-next 9/9] mfd: ocelot: add support for the
 vsc7512 chip via spi
Message-ID: <20220701210449.GA3973665@euler>
References: <20220701192609.3970317-1-colin.foster@in-advantage.com>
 <20220701192609.3970317-10-colin.foster@in-advantage.com>
 <CAHp75VcfKS9Y+T5LPRk0SFHJCGarJ2wS2gwii=a+1it03S+_Og@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VcfKS9Y+T5LPRk0SFHJCGarJ2wS2gwii=a+1it03S+_Og@mail.gmail.com>
X-ClientProxiedBy: MW4PR04CA0328.namprd04.prod.outlook.com
 (2603:10b6:303:82::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2b9eee5-74c8-462a-e24d-08da5ba55ca1
X-MS-TrafficTypeDiagnostic: CO1PR10MB4674:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ci0TIj8RaJTGV9xfj6zrDC8ohgwXGGHhfQfltnBN+g13nsxnFiXeQgcdUGcLi1DAmg2sg95nHLskxufFajB4tM/AFr6kY21bKhOK9KkI/XdXJwwnFFMtNDZjTcu8po+8HtzWmnKHy/MIhvgkd/xZHMpDRITx959PSaR/Qa9dNd1PEYf+SRUJENr9/WPO+fwL9CzzS5u883/ZO1/m4ABsELSJMz3HDfropr5R8SQsn8UImPOob5v5Ftodwby7SQxdR27mp8Ny9pnvtvZgyYIy9tDsDBS69JpGRcNGF5Er5Qf9lcKdcDzme1mkdeOmliI0pj23/zO9YUpCtSaU34w8CGLIJkDwyRkEuSJUGPRUs7OqqKeDdpZX2Nu5cw3781IfWa+QYJAuyTSvNN3VzdgFGoX9WoiTVnD2PQT4nvL1uKdzbe11DtrWjt7k2V1f7LoP8KmzDZ8IK8ZhI/wJsbFVxdwJxPcjtVeHzdSh5/iiF6A62iqXC5RTakLpEWqN7t1itrV638FzH3DTFDFDj/5tCSPxCy12ywHh83gCkdlkt1OgNEE0s8sNqkgvEPSoHwkRHcjtHqR11rOBlCy1zQ1l1xEwyrh8AXhzQ7mYK7UuKCO7qMhIxqovtWCMPPlUZzLHGrk5bDte1BOjVMnJXQ9KobcIgzcgHeYnwFa+tvpWhaNcvO+8Hmh7gj6GAUM7uxWA8fZK8GZPCAIY4ssIjzSrMF2OHuQZEcRFdFbiK0qrqfDxvstMayaWTH1Xuc+i7yTxM4y1hlIzVs6oCIxn+JLOLKmiL0IPe79b/vgMWm5M0Xtff7AEhNrFZO+KTYrq8eb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(346002)(396003)(376002)(136003)(39830400003)(186003)(6916009)(107886003)(52116002)(316002)(54906003)(6506007)(44832011)(7416002)(4744005)(38100700002)(53546011)(41300700001)(38350700002)(86362001)(6666004)(2906002)(478600001)(6512007)(6486002)(33656002)(8936002)(66946007)(1076003)(8676002)(4326008)(66476007)(26005)(9686003)(66556008)(33716001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RHgoluMkhYbkE7n2qkUwl1LUmCWYd5VId7u5nQ4TIooBzyjUy+4WOJ90waDI?=
 =?us-ascii?Q?96qwCQC4jUc1eROHEWDeJ/pkCkx7q/jsKc8vO++gra1UvyWnck/9KELJaRkU?=
 =?us-ascii?Q?qaPg0sPf2DN2f6J4h4XGgAFwOldB2mYbhFb5t+PTyAWFjhEz9hzgZeoVVnXI?=
 =?us-ascii?Q?9tLTOy5AX1yNrjTyoQuTvQpLlZYRrpmpuBxxrX4ddlTYQKdz1WtN2+SwwqxA?=
 =?us-ascii?Q?uAZFxMhbGRug0gQqT+j68UGFuvJqfl2C+avmlLKk7XZHEsXuFAg5cD4SZsRo?=
 =?us-ascii?Q?G8a9MtQS6VLaGrj+2mCV4s7K/kcO40EZGqWYrPtTeM63n2k6TIJbelcDtZ4a?=
 =?us-ascii?Q?glTQdxz8XDrl1VtBDWnxrSJAoP4JGwnzTQg1+MYS45pmf2nqN2aXFE+EF9EP?=
 =?us-ascii?Q?htlgpZrXMXcPZZBn9twZfjz8ytq3ZrH+WZbRCyMP2cqwO9Z1s7NRed3BuHh8?=
 =?us-ascii?Q?JksAbAyMrbS2PS44SEPblYqiKM5Wiwc6aF3eFs903HSHVJj6ATmGlXjIP/DS?=
 =?us-ascii?Q?CPFKgy66Bf6GJGuZsdiULO/I5CZa4P6f7kwlgdK1aFLNfROGlNyBHn25rWCb?=
 =?us-ascii?Q?jGXxqoWZRle/+axx9AKlLA4GsFhKq93k0P7ido7wLmKqCycFMDoHoXkm8TbF?=
 =?us-ascii?Q?PgFOQmjwf3YZDB8fc2u6iZOTglyZlR5JVVzF0ylpXkCGoqrp7KkFUrgOQ7aj?=
 =?us-ascii?Q?3moCEwZfEXmGNZqoDjp5OcYm7tS885n61bxy0f3OUslOP94EJX8hjNQar8Z8?=
 =?us-ascii?Q?FcFkoeFxZ1hDPahAC351B2vxSPxWorMZuvVgl9WeTxmQBAFGsFqoKDSVdVT9?=
 =?us-ascii?Q?PNCaVEyqmiXAOp8zRiJOUFYoCpCGgyYaqeeYEEYNrVJarxoCH9BfpqOM2uVT?=
 =?us-ascii?Q?pDsGfKjO1+kslfz0eywjEKZFSxN/597RHkiEz41p+PjQBe03DITO5pyESGnx?=
 =?us-ascii?Q?5bkAYIyeVwZRtJClUmPl/NKLqfQ2rY8l95OWCD143B//r4D53y0sibFskPUu?=
 =?us-ascii?Q?J/k0KQzuicnve7lo9RELvHyOa0vGVBVxLGAE2USqe1+ij7+PC8aIcmKKaJ2K?=
 =?us-ascii?Q?GUr5sa2MOWJSlYsMQRN0CdtJEuSaiSWi1Z7IF9BLldYSwi3rcehXnWCGEAQI?=
 =?us-ascii?Q?YObs/hMajU3FmlcsBh8dvxAnTKthV8C6UzcBYW1JGg+OC22VfCEA5Ckvu7/j?=
 =?us-ascii?Q?WN8VkrjjTsmwq8ujPVQLwFIQLn9tNvZLclTziUrXSEd7mUNE4wgv+Bq+Hamh?=
 =?us-ascii?Q?epq+nYjEWqLgWZ1gCNaZY6TZHbq+lvI8bh1w7bwO1EYqBM7PFY9OtgxvaBF0?=
 =?us-ascii?Q?UH9524cHJTVm3i/ljmCDfUser4sUCL0QXzSQ0u2Qy6Qz5pHquACBQt1iTHJG?=
 =?us-ascii?Q?XZIILhMzlHLsP+tqmAIazTjX+gckeYR4uW7X1+Yo0d4cNHKz2dT0i+uPnv4h?=
 =?us-ascii?Q?CGtZJMtU5zW9DwTvMg2ippTJmGVT8iqEYHjs3O3Ppx6K6DTKt5KyslvDASYX?=
 =?us-ascii?Q?AoIE/6qXZo+pBcsJkYO03yhu5WuiRBFjaPe410TWUACXv6GudhMVpDv+HUrS?=
 =?us-ascii?Q?n4HL7zInZq48N2Ok/HCZM69/XvkUQXaNbG7XBj9nP/QEhWYzx9bDPIeRlJep?=
 =?us-ascii?Q?iaLmnSZ2zxc40q5Mi/d/hO8=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2b9eee5-74c8-462a-e24d-08da5ba55ca1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 21:05:01.0534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sq3MftUaMSgW59RRIzDhXcWvgXC/RojVktzfQxGR1ub9ZZV4/GZMMwGdqpCAmgrYnDuUjmI1fJ2qL0MH/nwjyyFCHJimHh2mcqG5uSym4KI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4674
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 10:38:46PM +0200, Andy Shevchenko wrote:
> On Fri, Jul 1, 2022 at 9:26 PM Colin Foster
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
> > +       static const u8 dummy_buf[16] = {0};
> 
> On stack for DMA?! Hmm...

I'll respond to the rest of your comments as I go through them. But this
one in particular I'll apologize for. Ew. I'll fix that right up!
