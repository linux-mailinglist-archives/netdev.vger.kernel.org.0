Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1857D598E35
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345785AbiHRUlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345577AbiHRUlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:41:12 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2120.outbound.protection.outlook.com [40.107.212.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9089BD31CC;
        Thu, 18 Aug 2022 13:41:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rr6aZ/TEIiMAHZgKKfxb2WmILTSptzOmrzxzA2V1jJXOJD0oarHrwypLmW+8FizIiG/OWZP+0d9Cy59LWU+yL424wcARHHt3m6IeyXjnPmbjELbBgrHRu897dbCZLgb9zYuxK+zBNpq9yStajFsHcaI4H1t/9o3flajNVK+4VAo07wDtfDiGM8Q7sFY0NZOaXoj86fjcW2zVyqVjqReQ1S48OdC7ba+ojG8XgVjVrIWnuqFaQPrJTdLeEzabU8WOqsuxbJ+cB/AOvgVy2q9guRT2WRlteSvihHyArsNCyd9/DIHMeihZcB3UATV/0WmpVeQ4tFQ8FglM/BjzTm9hcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=obBHN/CS59ZnGmfVx+/aaKlWZ3rFIwyIUciJ1wFabyg=;
 b=M30mzx6J6qTj0wShFOCvFX8f7QPrH7fnydaZMMlZ6Q4IRc2+H/OiMbczu9/S7aGNkVBLWt7JMm2PNT9J2VcU2LpK/KOQTkm+kp5+1im6YsXrblc4FkLHpIhyTZ6gL8nekCMMVwxWuSmgSBCvzhxPevbW9S0GhUv5u7PmHKKrhXu8JPKk3XHFWip9HdBDN1eTXCojBj0ghOYLOdd4oF0ESmBhVdIbQn6ANyk36VjxRDomWoyFTd/E5Reg0XXajfZFWsQhoI9d4TBE+cDqZbYbF5T7kYMAzezoZCnIQyOv0DfKUmUYngqxeUHlxzode+ybk/IyTdnjWZKaf/scPk2Zmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=obBHN/CS59ZnGmfVx+/aaKlWZ3rFIwyIUciJ1wFabyg=;
 b=RQBdmVf5QnhGf3en5VBYbYR2d3z52nVJkDosuSRfdnWBWGPQb3/puYg/FjCBXPCNyQ+k1gy0Vopv/XxIWTW6YYLcV+033OE1wBKiKbUsnIOqv9GHLWb2dFeGYHGl57ZAzyVW7+ZMSaQjtPaQQs7k3d/nPLOYVXhPM0/n6Q/eyoE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB5216.namprd10.prod.outlook.com
 (2603:10b6:5:38e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Thu, 18 Aug
 2022 20:41:00 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5504.027; Thu, 18 Aug 2022
 20:41:00 +0000
Date:   Thu, 18 Aug 2022 13:40:56 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        katie.morris@in-advantage.com,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [PATCH v16 mfd 8/8] mfd: ocelot: add support for the vsc7512
 chip via spi
Message-ID: <Yv6j2Lkt40BPXjzO@colin-ia-desktop>
References: <20220815005553.1450359-1-colin.foster@in-advantage.com>
 <20220815005553.1450359-9-colin.foster@in-advantage.com>
 <YvpV4cvwE0IQOax7@euler>
 <YvpZoIN+5htY9Z1o@shredder>
 <CAHp75VeH_Gx4t+FSqH4LrTHNcwqGxDxRUF26kj3A=CopS=XkgQ@mail.gmail.com>
 <Yvu1qvslHI9HIqKh@colin-ia-desktop>
 <CAHp75VdvcwivSkGe-CF94ohn3VxFq-vtjMSXfM4Q2ZX2MXskZQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VdvcwivSkGe-CF94ohn3VxFq-vtjMSXfM4Q2ZX2MXskZQ@mail.gmail.com>
X-ClientProxiedBy: MW4PR03CA0159.namprd03.prod.outlook.com
 (2603:10b6:303:8d::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be002afc-2808-4f22-dc98-08da8159f600
X-MS-TrafficTypeDiagnostic: DS7PR10MB5216:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yjshlNCYgmRphava8Ef/LdCffZofHwVTXMZ7b+gWol+39MVXvaBQTx35Humpg6/g/EeVdhA/swsFd5REEcLQ8Q9Metatu0YthYCxsoaSf3V5v7yWgXSa0BTlWZbLc8wuFyLxigrcDDb01CsxONRXtMGEF+MpyrdXJr7X/7+ahZpjGTa9VM2BEy1hxG/vfnsFC/dNjW0nuSuL9N38oQxMv6/1ml0WWkAYDneyhcWcC+TVw2SaFPBWZgjH8XFDJODD90WryU5f/uKKJLSxaAyM6FnqytAEfcE1tKuWK+ZodQZkDeQnwqTm4Y18EOAO9FVmNc/PA+wvbBWhQdgNB+Ae5PSbxWy2qEtaUStVhRCcYKijwJZu1BewijfqGEgdlfw4zL6Gsw83EYF0gwt+vcWRQLMG18B0UTTdQ3bOD22yTYNdGDls6Ho23u374oK+e7NVKiRzbkihnd8gCzzlSSdIA+J1FvS3rCL6VlonyF/4Q9eH1tkxmA8I7w1G9fSq/Jd/hpuY+guuEtS/5uP0J119eqw99UJEDN+hjz6sgWqB1uRLYdcMDDaJLDVQNF877Y/pJClJ0RCH+agXZvMwcXPdcY/Jhfs676pIrtJhswdWCCkdhixqofLbJF1i1h6aQdWiW7e0cBiZG2NUR+TdAyE5tvVqNE/pZGF7PyQNjPaPx+S/9KHq6zk109hXSe+jjHa2Gwbsud/LKZ3trNH6ukH2Dg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(346002)(376002)(39830400003)(366004)(396003)(478600001)(6512007)(53546011)(6506007)(41300700001)(54906003)(6666004)(9686003)(66476007)(26005)(2906002)(4744005)(33716001)(8676002)(86362001)(66556008)(6916009)(316002)(6486002)(5660300002)(38100700002)(7416002)(44832011)(8936002)(4326008)(186003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cQHlEmZURdSdR1Ykuhsj4TARALftZbrQl9k0XUlYFrzmvqow+OgEIeHxlJsq?=
 =?us-ascii?Q?E/+PH2dZjdWRwlOtsZ3eFKGRDZSvXE/JL2wvoxEQClrA4pC+5S0IfOdoE3vN?=
 =?us-ascii?Q?24E+ItmGh2JmodUbbjXpsu7ahh4wOpGwhfg4OYCAaG/TNakfBwCfDywfvFYc?=
 =?us-ascii?Q?OTHNHN4TeXcob8dLVzuU1vtXHjSsJt7w/2R+KCfuKSlpR7FAALAC9F7yAHov?=
 =?us-ascii?Q?Cl0ijqn9VPMUhwAPLqsdENELHWvq+f9Uu8pHD12twJfq0FRMRZGyf6Yv3O+o?=
 =?us-ascii?Q?ihLJHr4FCVvA9QVfjW/yXv9dyumOjzZ2YAwj0r5zU962A6sQ17YlDQ24alQR?=
 =?us-ascii?Q?TljIRs96+P+yrcNqiGy28dMSGYzD7niOUL0nHFKLoy98yl+2QG8X8QhSbaa+?=
 =?us-ascii?Q?ZpTmNPP0v2TdNFR9a+raK9XT/nkXIHnc1z/UN1a4Aj6Poqy6YYizn9b0InVn?=
 =?us-ascii?Q?SP49w7Mwf7uZGn9kL/5bkKFGps/jz8xyNveDtCDJxOR0ttASJl5hjaPcQO0f?=
 =?us-ascii?Q?fmdpSD7drgfreRx0AOMAt96IKdlqKGe7oi/aygv7R5ia8P5M6CZZKYShT+mB?=
 =?us-ascii?Q?2g19WspoMKiyMsRZZAWbwLla+aHCiCs4QE/72Rdxz5CNFET39Jlrt7ZQd2Xw?=
 =?us-ascii?Q?6qVjLuX6li1OHmrsJo3aJX4NbLfDmSp/vh0OmoAVdSuAWloPV3lPJr0baL7S?=
 =?us-ascii?Q?0QG3TCN+4l1EHDvPegcYYzOJzGv/hjKbaTRqvRTg15qJ9U+MwH7k2EPUV3Cg?=
 =?us-ascii?Q?rdxk6Z9AWkvg+9n2sSISk3kXX+j19MN3r+yNrDQSOlxPEOU/wx6gVWTHOvLm?=
 =?us-ascii?Q?uxetNEKT8y3I5MpEEz13hEDHKYExH+j0v2xjIrc5QQX2WhFu+iZMXG4p36db?=
 =?us-ascii?Q?NxiYrmYhwJznmk52XLbVPfKKVHcRl5o1WCXZXxGZ9ckyb+QaeJsu4CifgGtS?=
 =?us-ascii?Q?rDA3vH0IMP/hbFmiqYpkhhAEPpg8ocwCjbDpZjPmJzMScM+xap1iKF9sG/Z5?=
 =?us-ascii?Q?uOQGTugZaczmz9YGrzXBPT29BNpGxNQM7/anjUJJDKHC+X7WiiJqywYUGPfX?=
 =?us-ascii?Q?DnpUV5EjbUKVgwOq4kEcS6504+tk9YbP26pNaJFdY3/pdYVbwpZvkkBIFZbA?=
 =?us-ascii?Q?qmY54lFuxH061tGZB7IASEKcYVwcLD4DU6rDEwxcyJNpWo4AE0ORnK10kepY?=
 =?us-ascii?Q?j62TMXWVeefMaJFN9AWoUT4ZqZeWyGXgQcuzCqqWxlS+CzJPT09XJ6R1GWvl?=
 =?us-ascii?Q?gOCZIvZoBivLceUnXdNe4Kk3A0bbZMM4UiOPz3QphViXXa+8AOh77ff8qps3?=
 =?us-ascii?Q?kmd84VltNDn4QRQJwYc4pNoXY6serg1iaBdFr55zK7OUmbYkLrZ1ylLtXChe?=
 =?us-ascii?Q?R5GP/8SoPMEtNbYdxy922s5IePAb2Ko7NUcQArPPFRaRx1n9P373isdUSQwP?=
 =?us-ascii?Q?Nv0cT5bQ/gg8fK+PxR+Sy1phXERT2IGV5LdoEOGG3eOGCKyPRBQd6IAwkq3x?=
 =?us-ascii?Q?szDG+LOD8SI7xv5h/fHq3O3fgsGqWWS+/QK/zR8hAe0qQkbLbv4A3H62kTM3?=
 =?us-ascii?Q?BVNzXgZtg2fpAQmbWnqVr+SUqSdiCrXwCmt1WoW8/a0U60pQgyZwOltsh5XE?=
 =?us-ascii?Q?Wg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be002afc-2808-4f22-dc98-08da8159f600
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 20:41:00.7857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HadZFhb6vq0x8U4A+iWjLEZyRKogVe2CZ/ERhVVBJr41KX1iHjPjiH7srQ50GOgBL0MCWLo7Mmquf5NKJJ3jaz40WLwm/c8BATLbXcWIZsU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5216
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 10:26:12PM +0300, Andy Shevchenko wrote:
> On Tue, Aug 16, 2022 at 6:20 PM Colin Foster
> <colin.foster@in-advantage.com> wrote:
> >
> > Do you think this is a false positive / unrelated to this patch? Or do
> > you think this is a true error that I did wrong? I haven't been around
> > for too many releases, so I'm not sure if this is common after an -rc1.
> 
> It's a sparse issue and Debian maintainer for sparse is not updating
> it for some reasons...

K. I'll ignore for now and plan to re-submit next week (with Lee's
correct email address) unless I hear otherwise.

Thanks!

> 
> -- 
> With Best Regards,
> Andy Shevchenko
