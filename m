Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27330563B41
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 22:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiGAUih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 16:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiGAUif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 16:38:35 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2126.outbound.protection.outlook.com [40.107.244.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44B2599E1;
        Fri,  1 Jul 2022 13:38:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a+5RlvBVnVwTOEU2z9ezC6DJ30v1tjQP9qQMUGKBJS989onB+xYs6Goo7ns+rDBzAWZjWAxgxDuN4obn/ng8PfwdUM52BizAPwiUhAZbvlnMhzoQv33b8IXf4mtFFpd1/tZGC8UM7PcNoFti6dSaKNP/O4ICYznB4AHzeaMBM01HKiOw+EDK09XOs26H77dww50lp4x/M1bHOUBArbMGPbMNKMVtV6iO67OQVpGv0Ez72FBEXRnyaYNSvDQ6D5FpfKoNC846eWf09Ia5zUxefPw3xCRPD4fjUq1YO1yH+nuaz5mDBe/SJxx8E0gDYq3o9lyZqncv6ZpnoFXa/Uwjhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4gWCCQY5D8olHQqyIeWPVDXX8eryAS3XlSzsGEuQ46U=;
 b=E574NGF+8AlQ4t4Hon5WJI21a+CUkDaf+QLZ8RsBJGFdz5CtiBslYTgl0EUytBPH3mOIua2OE53iAzG3sTV2BcCYqRxnPYRRIv9xgvdontXq+Ozg8eih0Mg0qfpbHzPbQYJD+fZLDVL7E7VURJdEZ01BzDtH7fjL6XW/p0BFcyKxQvEJfwgnkmjn9JNR4Z5qzt+5uO0iXUP1nuKQMUpchOKsurn1EloFHqV6OQwQXsi5okeVZeyGRCeCESRJu19s30850XuJnMws78tImaLOpbSZcssDpouj53d3P7kLRnrAThhfN8rt2kYEGfj7CB8xmY7/PvjfQRSvxVoPcVNXKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gWCCQY5D8olHQqyIeWPVDXX8eryAS3XlSzsGEuQ46U=;
 b=IgyFaGbOv35WpfEj1oOGFPJa7jStmJplZlerbN+U4P1RjJe8b9v5ocMFw5ppwn8jvYXJc2kMU2HAc6I5w7oxWospRZZPOm9f1CDkuNKC2EgfQasqEwoOnVlAshgXlSftgX4sOah0PXUE4mTI6uT+BQ04M5DsAFwKGEMp1WkxxIU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB2443.namprd10.prod.outlook.com
 (2603:10b6:5:b9::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Fri, 1 Jul
 2022 20:38:33 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Fri, 1 Jul 2022
 20:38:33 +0000
Date:   Fri, 1 Jul 2022 13:38:30 -0700
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
Subject: Re: [PATCH v12 net-next 2/9] net: mdio: mscc-miim: add ability to be
 used in a non-mmio configuration
Message-ID: <20220701203830.GC3327062@euler>
References: <20220701192609.3970317-1-colin.foster@in-advantage.com>
 <20220701192609.3970317-3-colin.foster@in-advantage.com>
 <CAHp75VdZwUj7dGQsiWR=M_UgxFz0q669bsdsKq3xAD3Wqv+2dw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VdZwUj7dGQsiWR=M_UgxFz0q669bsdsKq3xAD3Wqv+2dw@mail.gmail.com>
X-ClientProxiedBy: MWHPR12CA0047.namprd12.prod.outlook.com
 (2603:10b6:301:2::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9714371d-522c-4c60-df0e-08da5ba1aa25
X-MS-TrafficTypeDiagnostic: DM6PR10MB2443:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xVjjJJJjF/QAmfi3Ba3RpGIlig9kS8MYvVIbZ9qeKMghppmCrOWTDAdZ70zBA1ETeINOP/mEpWoc5UtmwinxO11Jyfao97082h9HsgyKITy6k7RNYhdyqo9NUQ77FsN0sz+mFtGHyEfIv8n96Etsc8y9oXTDbj1JCRjCuJ/Mu4ioUioWVd4qRpzLh6oAdfEwEbzsbefFSfiX4tB8+BzmmcOUNttPGArsrFD+VTuG8mnMS6l8zEUkmUCKHPhfrocaw//mVRgqih4yo32Vkg9Db3kwk+40y9NsM6EBla5qcziEC1/UGP7wEbUZ7eUe8hHuw14d2yri+dPfci7ki4QPRv7MYo3hhpnpQcDWRW2UO3f9kZ9i0IhvOGcFb20CGz72lYAYF8qC+J63rwpxFw5lZZ7RfLbRS6QcRBXE7lc7ayVh5+pQje4BPgAd7Rxht43PKxQf/R1wMA8lKdH4kdJ4P3vzlcKeslJwYprHHn2jmxNs2EHdq66bN0YMXQoPkVoPJ+qY9fHxS9HoQw06cLsuaBZw1zlPfLM08Dxuis+CzTs3AO+xS4qfHS0Y3QgDdH09tyiQoPSkpszf3y+3WBLHeCW1GqhYpgUOWtqh1ryyik0FXanZKX3POyHamyZJeEh2sDXAixeDxOD0/ux98FXb6bOt09UTmCb1G9DGgHvlMTsykJZxb2cF3d4o6TeXW7GBpfuggWqv2Q/PM+kVgeffGjWI2JDvjrk/ekI/hp9Gfp+25o5B3AON03Wy9Jw7wMF68Z7/TzO6c2YVktgXs1OoODCIm4buWmFd4dTQsP28l4xZYrx1gMLtb67x+MTo9YF0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39830400003)(396003)(376002)(346002)(366004)(136003)(107886003)(33656002)(53546011)(4744005)(66556008)(316002)(66476007)(66946007)(52116002)(8676002)(44832011)(478600001)(6916009)(6512007)(9686003)(1076003)(26005)(186003)(86362001)(4326008)(33716001)(5660300002)(54906003)(6506007)(38350700002)(2906002)(6486002)(7416002)(41300700001)(38100700002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+W08ASzKpRfI6yL5N3BBeK0Fnq7EyAqFH6SwCo6CuLM4XKKymj/ziqxNLoUS?=
 =?us-ascii?Q?3/c+9YmG+FVZ4LbpKfwlzd73knOz4g3J6RfS7QrhjSDHiq01G5+lwV2U/Max?=
 =?us-ascii?Q?lki1ZOyBxudIWRityCXtUVowczbnZuaw5av+3a5nNbq2oNGJtABCLLPtpL5k?=
 =?us-ascii?Q?bWbat0KmogzRpyEJwo6H74n1LS4t0lZEMI/MVAxT1glno0yRuugdjlACMd/s?=
 =?us-ascii?Q?kLefQckxcwo8BGZl7YtyR1qI+b5Wn91B5ok0C53tNDi6gI1rsQ1DLZSMkrmF?=
 =?us-ascii?Q?TGPPxWsRE/NPIs6EOcDERVYoFJ0RZXIUVijA5aA9IqSL731VK17s8GIh0xVV?=
 =?us-ascii?Q?p+F8uWGUkpX4XmiZUTZf6Eo8rT7UrlTlw5Etg7O13I39Cy/1+PbVxAmGMUuf?=
 =?us-ascii?Q?FMK0ScXMzU2sUiCdUCLaHv+PUb1w9psG7VfeUk45FTqOxNIHH8TmZCOdDRyJ?=
 =?us-ascii?Q?AgJdJSgCNSwOUfqNRyiU6xoLD43OfuFJw8r6vXGTzi86d0JUKeagmbr7fp5W?=
 =?us-ascii?Q?fspaeB5Pu//xKscJ1ZWch05zGatfD5igfxC8b0KUkRSIUjmleKAxwueKUgrw?=
 =?us-ascii?Q?R/rrFgJ3HgnBzpkufZenra8RmGYK7h4LMQgqSGrgm+RrYmrnNuHzNf4hLz10?=
 =?us-ascii?Q?2qAS5lDB16p5w0K8kaOnGJOzW+3XQFsGWP0xL2wTW4eR2AadRs3+Vx4/9ffP?=
 =?us-ascii?Q?HR0vzMMtyjlntOTfvi5aFqxXJcuXO8R1JE8BeWCzcdhGJzwGUEEysvSqPxGL?=
 =?us-ascii?Q?l5U17X0K/12quRRBaBrOS5avnl3X1K2A5JMeyLYt4Re0kqhYhmY6TXfhBM3I?=
 =?us-ascii?Q?ojyqkrdQZ6cHynkpYK5Ndjg/Hr9m/LOElC64b86ef2ggsb0NXs46YmQm/LJP?=
 =?us-ascii?Q?PnEWhfuCdgRugxXUG6zLda+HRNVDIGoknyF8G6tS3HRgxg+vQy9XLJKPxv0x?=
 =?us-ascii?Q?J2lyU9wbjgot4kyVYVc4w5MK2rpnv0lPIvH+DBlfKHmXhlUv87J0HYNw3KRp?=
 =?us-ascii?Q?qgnCPeUIAWHXquFOlD2GyqW9UgPQHuJ2JZyGI9buG8OQk2YxgHRKnlx7PdFL?=
 =?us-ascii?Q?3ekbNTYt4f8d4EXbF9oEIgAmUasEyC27rXKgog8bhyjZJkIb1lQ8NBClEh6R?=
 =?us-ascii?Q?EypGY4+zm7+tuGB0sUtj1FRnwX5vR7uG45as3oTbX0yCuBBsgU6JfjNebwEW?=
 =?us-ascii?Q?cMGtw2lIB5rd99ZiXSFVtMNp3Y/7Ue7/igKq77jdt/U6zm9+LQMTAF8I57il?=
 =?us-ascii?Q?GQqHCfZ9AB8ve06H35X+hP/8VY34ZuXeAvumipyWbwS6ArEQE4NcmxZiKJd0?=
 =?us-ascii?Q?lDlKWw94XQR7qwcO3yodNrG7gZDRFZLzHyB+LJDYrcD3F9SbP8NpFyr8zYj4?=
 =?us-ascii?Q?mBAaIoamOJ5jRd0HWgEiEIHEujznf8xP293IMBDmYrHRjSC706mGvojQrnzh?=
 =?us-ascii?Q?wTQagWE4xepatuAflaqNVDLvm1VI0sICwCtyskoxoo2lZrtvPor/UGaipyu8?=
 =?us-ascii?Q?yQcfXNI5kCyXD/qSr7GLBLa8racLgEapFGAZ2jerTOg4U5cSdReB9rhYcczr?=
 =?us-ascii?Q?Y/Uh7HCfwOTL2PDzmlH5nPTedu4/zsxCjN8HAqcF8XrpkC4rIlybAZJ9ND94?=
 =?us-ascii?Q?eHec8hS0r9KISmnKoMQ/BGQ=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9714371d-522c-4c60-df0e-08da5ba1aa25
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 20:38:33.0692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uLiG5z/2yG+Go1e0ZXJuNuKV6y9Y0mtq3Dh0+uBC8LPI96ArDBTkschq/vMtos2MgZf00eiBM6zXWZDu9tAc1TaH7vJu3S0qdz8nqxU4cNc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2443
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 10:24:46PM +0200, Andy Shevchenko wrote:
> On Fri, Jul 1, 2022 at 9:26 PM Colin Foster
> <colin.foster@in-advantage.com> wrote:
> >
> > There are a few Ocelot chips that contain the logic for this bus, but are
> > controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
> > the externally controlled configurations these registers are not
> > memory-mapped.
> >
> > Add support for these non-memory-mapped configurations.
> 
> ...
> 
> > +       phy_regmap = ocelot_regmap_from_resource_optional(pdev, 1,
> > +                                                &mscc_miim_phy_regmap_config);
> > +       if (IS_ERR(phy_regmap)) {
> > +               dev_err(dev, "Unable to create phy register regmap\n");
> > +               return PTR_ERR(phy_regmap);
> 
> return dev_err_probe(...); ?

Thanks. Also the same is in pinctrl-ocelot. Fixing in my tree right now.

> 
> >         }
> 
> -- 
> With Best Regards,
> Andy Shevchenko
