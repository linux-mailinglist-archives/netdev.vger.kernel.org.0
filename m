Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F48520B95
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 04:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234687AbiEJDB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 23:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiEJDBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 23:01:55 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2133.outbound.protection.outlook.com [40.107.243.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910491C12EA;
        Mon,  9 May 2022 19:57:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9qoID4lqW0g3vwVEoJd5kIB7JEzJckWGec7yDmdPPm3vEJrjZ9Er+9+45sRx9TAeILdOFjnQDMtwl2tP+1s57n6J2lGBY6paIjERblr7bSPzPfGQ1DmbiqaMuMRwiqQhEnhsRorw6aZCqzYShLBWWR9s5mj795Ivq9GGVQTZXnTSg+3JGz+MQu0NFXzaarSTIa32Iogfa3VoPalotWGvEAPiD/301+OS7XKGmYhw2f4uhXoF70fx/gw8ozgY6DbTbkIQ95vERi8+R7I7opGqHI67yz3O6mL2+OMR277jvcuHAnbxOXq+SnqzSYPY2MJOtfBoeji6ShldSOZ/ZLJDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UenfZOUxYn04bROii2WAw2KsCl/K9Ll/HH031XBre9c=;
 b=YSM18+FBbawLwl9CdogH1wb9seO9c97eFkddg/naHE5l/WOrYh9zRU5/0MB8Oo4/LVLF8bID2JJH0ovYPo8cQNrat1z1KnWyn+nrsP9eaPTY0Ri3UVnk5mUPKQb5oh76Kzt4ySoO8QlyULCLs4+5Ep1eylAhGKn9nJ+eoruzJ5JtbS9tE9eoqvzEtsvHmWJxtgLvtxB33xZ2hyMrPIE1D4DqUyBebevmtHw5InfW5bL5/csaI3bduMFptTlUPi0q5VNzT1Kpy9GPtlAPPOKQv1AFnS0gid/g8titJlavwDA6cLHOyWpWS674ytljaq25TzbGokjb8dT+Q+MsulE5og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UenfZOUxYn04bROii2WAw2KsCl/K9Ll/HH031XBre9c=;
 b=j52OOHfcniH5p2lrtOLZ7rLP6iRH3W2hdqUjJ5gw1jtXb3UjDtVUFtl9EfHhKfYB27JYSt2AiDVSVk3JrRpSUyiW8b24l+I/+cNqt+cZ+Rs5zJYnKdl8RlXB+fUz+WPs7ExJUBzH0FjXVKdRoL7E1/XeJSlYVBPR6ilaYyAx3Jc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN6PR10MB1396.namprd10.prod.outlook.com
 (2603:10b6:404:44::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 02:57:55 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Tue, 10 May 2022
 02:57:55 +0000
Date:   Mon, 9 May 2022 19:57:48 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
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
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [RFC v8 net-next 00/16] add support for VSC7512 control over SPI
Message-ID: <20220510025748.GA2316428@euler>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220509171304.hfh5rbynt4qtr6m4@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509171304.hfh5rbynt4qtr6m4@skbuf>
X-ClientProxiedBy: BYAPR08CA0007.namprd08.prod.outlook.com
 (2603:10b6:a03:100::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d0fe5ad-fd1b-4af2-747b-08da3230e15b
X-MS-TrafficTypeDiagnostic: BN6PR10MB1396:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1396BE32969A310DA6E21777A4C99@BN6PR10MB1396.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 33qoI8UR3ybqIdHS0LdYPaxtSq9wGFkfO6M55ZISJ0UNU+CCvUbJtB6zX8BOelxsh8MXnHEfPyfrXDvnc/dnN+pH32OlJY1tOBkA5Ljandct5XlnnCiNx/6LJwfqAC7Kx4vPvF6WSfCoGTceQMkRGvkA6kwWeVJUfrCIbJEIEs3Fv9ga0FIll2S/nlLb8fS068U4nZteTslUnl5qMKsrnf4YPldFmJvpWx2voxSAzDKGkqadwC3ydJKeYp5+Y6P2X2Vx6Dh+MfF0tYvOSwCo0GDaYzlglJfHJFBsUwqqD+BKafuIesbMJBpIRvd4P69dl7mqkxHD1A+/3+WyVN9QhVt0X3354mlAccND9U6cp/eyjAERDrf7LGuIvaouy8miE4Qn/5+OwGuBfRZ+v2oi5zJ5aIt5cKIwMRi1uUZsQb0RiCYk3LRsD+eBZjfX6tvtwshEPhc6Y3rDz05GqeRA0qWec2X9jRrl/rjT9W+Sy4T0hDyCMPx1wVOeQNZPi30ieOeDx71m2wHR/G/+Zx4py12bj7pClK1K6DIuw5ochkVXe0MlQSpzjIF2BjqCtMgM+6EjKWEYwnTIm6qZ6zgyOOXoVm1wicTGCybYLAOhYtuzcd3MHn1VhkRdhBw1aAgUCQk9MQARgouxVgE9mbdUka3ukyL7dc6f2RgiA8ZgEuPCnJ6NUwaCXgCyh+QbNPXgsFMRpGDoPZvwgJSzf//oPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(396003)(136003)(39830400003)(346002)(366004)(376002)(8676002)(83380400001)(33716001)(4326008)(8936002)(9686003)(33656002)(186003)(6512007)(7416002)(66476007)(66556008)(1076003)(66946007)(5660300002)(26005)(44832011)(6916009)(6506007)(52116002)(508600001)(54906003)(2906002)(38350700002)(38100700002)(316002)(6666004)(6486002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xnYaX+0TxtNODZnOTg6EChk8TyPWIgAC0wdXAk8ZB/PGYv6WjwXb6ODAndjD?=
 =?us-ascii?Q?4N88AJXf/eGrhdhNQMMIiOX9QOuAaGbyk3sFr/SoYu5ZJF1kal28EQpyxg2h?=
 =?us-ascii?Q?Tqs9FNqDoq7FaYPL5L60r9vEGWvdiQqgfCQweJHOZoGBP8dpOgfEM3O9V7S1?=
 =?us-ascii?Q?JG8Ffou/MNDY2X881PPFvRbIC9ZHrxvEq5wPr+YOJ054l/eMeMawfr5H1KG+?=
 =?us-ascii?Q?souHYJMrGvepZ3HrAUUEHwkxUcVDAeXSF4n5TaQZx4bYszX89DE7tmK5JZGP?=
 =?us-ascii?Q?I0Mkt6VMQwp12z+ccTI6G4lXbpxMFKq31FpAivvGHN9AQqKgd7fpAykNy5sa?=
 =?us-ascii?Q?5jpV4h4hMlIp6V1U4uus11AGeuVmGIbO9cxF5Qp7wNYQ1jq1nI/tdKWaVV5l?=
 =?us-ascii?Q?dr/OmnbO5Z6sPwHJ4yFxj/J68BVZIEdkgC8JVzaVWWMk7jt9RmfMBJh0esmB?=
 =?us-ascii?Q?BU39xRUf37He/rynF2JXXXPegsvI5pizoFA7W6h+TzKltzqKCRVrW0RVCo3m?=
 =?us-ascii?Q?aeinqfnVFr9NJAq+RlrtEgf1Wv/DbpJEVAdGS2iPdqs7oKIXrGiZURa44dsY?=
 =?us-ascii?Q?dEqyRccf8sykMfHYoSmMdPpMZ6/qrU1opyuY8aPU93ljT9Nzyw/IxQvuOkZG?=
 =?us-ascii?Q?IswpzCv/ao3JQ2dNCMAuafeQrPjobPHhb3WfnqNO2lwOLZqrNST6aDoKGgKA?=
 =?us-ascii?Q?q8LhO97KZZpL4TUWk7znnMwRg66N+8kRKWCU7n4hJ4fSSBWVdSftI7f8C9Pn?=
 =?us-ascii?Q?ZrFgkQiyqZKRZx/udtU4ntRG3cuO9rR5ihvhe3CNiwJjo5VXB5rqu3m+eT2m?=
 =?us-ascii?Q?4QkLL14igPGi2TpOe+cnBBSazJNvuCy0gVXkjv1gQgUaK4qSycfnFUgHjXCP?=
 =?us-ascii?Q?VX9wHIRCL/+oG3T3/KYmZInJ/lyge6MdLY124hBxJa1t5pebfid9fKG3gn09?=
 =?us-ascii?Q?ocZfRzlir/IxrEPBuXuZp+jLrWH0lPZVqGRVxSIUj2Knk5TNKOCVyIwt5umM?=
 =?us-ascii?Q?SQfrljzJZUsOfzIKBnBQxU88CeJNkV9atK2GntLXQtRX1BwZuX0iIfiQ5aZG?=
 =?us-ascii?Q?6aSHBS5W2IW0ptY8/v3/lZ3xPVaHdpnae28saY2XfTmXPvw2idjSL3jwPP64?=
 =?us-ascii?Q?tarsY+WkRUgDFFRcJAEEhpWlEyr9TcPB+gmsi2YMgaAoxMuqgcEGOAbu3ew7?=
 =?us-ascii?Q?9ZsoAQydanfOXQ2O39VEy3HjNv0Yhc0L95NIe3h3Ccr1AW7QnC7rBoSkTrra?=
 =?us-ascii?Q?o/Evd4DmEKUwSawB2Eoi+MWiBSVfrOs10ElSM8waqguF3EE8pLxDGyzYvDcy?=
 =?us-ascii?Q?yfgYwLLUa/+/P8R7n2DxJXALliGA6XnOjGwfT6YyvxJjPPC7MmCVAljnxcbJ?=
 =?us-ascii?Q?unuh5IksfNw2haZicvjfa7Asj1DrnZz3s+6JDmRReQ+e/pgc+Z3uWQ24JaVb?=
 =?us-ascii?Q?bWs3UXpzDr8s5x3SKIT8Xs0sYr+H+W0zQ8+40LXfumI97HNPEteKyTLs8QUN?=
 =?us-ascii?Q?Rc9lLuZEALolbnHkJncJHbyBX03oFJJIgmQh7g2M1ULzvSl5k07+hFjN4M2w?=
 =?us-ascii?Q?PJkEzMplTtgme0h84zOdBbwfAJDyqq+y7ExYSX/auA1ezye8clAB8UgEnFME?=
 =?us-ascii?Q?qmM3VrWJZEth+ObsEj9Tabl0M7wpGEwQI4e7tkzl8bpBcfKr1ZGc9+Bw0qc/?=
 =?us-ascii?Q?0Z54+BB8MgEzD6DN3n28JJJMKAYSXh5wPF3WGGi1IVqdm1WygH6ZX7mERK3J?=
 =?us-ascii?Q?D+d30xxg1WhT1W17Y+MdDLyQU+ALK2JPhwYm7EDrwgqEyeMYhx9b?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d0fe5ad-fd1b-4af2-747b-08da3230e15b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 02:57:54.9532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +3egBC7svIkRJF/nTM0w09YKrdueP3aoHtbgW5XE9tJLwNxaFsN8trwUuXDC2q8ku4+OSweFQ7LEVVcpZ7vT8uw3oJmjz9wUA2OT/GvVO9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1396
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 05:13:05PM +0000, Vladimir Oltean wrote:
> Hi Colin,
> 
> On Sun, May 08, 2022 at 11:52:57AM -0700, Colin Foster wrote:
> 
> Why does this get printed, if you put a dump_stack() in of_dma_configure_id()?

Below. I'm one of the only users of IORESOURCE_REG, from what I can
tell... Not sure if that's any consolation.

> 
> > [    2.835718] pinctrl-ocelot ocelot-pinctrl.0.auto: invalid resource
> > [    2.842717] gpiochip_find_base: found new base at 2026
> > [    2.842774] gpio gpiochip4: (ocelot-gpio): created GPIO range 0->21 ==> ocelot-pinctrl.0.auto PIN 0->21
> > [    2.845693] gpio gpiochip4: (ocelot-gpio): added GPIO chardev (254:4)
> > [    2.845828] gpio gpiochip4: registered GPIOs 2026 to 2047 on ocelot-gpio
> > [    2.845855] pinctrl-ocelot ocelot-pinctrl.0.auto: driver registered
> > [    2.855925] pinctrl-microchip-sgpio ocelot-sgpio.1.auto: DMA mask not set
> > [    2.863089] pinctrl-microchip-sgpio ocelot-sgpio.1.auto: invalid resource
> > [    2.870801] gpiochip_find_base: found new base at 1962
> > [    2.871528] gpio_stub_drv gpiochip5: (ocelot-sgpio.1.auto-input): added GPIO chardev (254:5)
> > [    2.871666] gpio_stub_drv gpiochip5: registered GPIOs 1962 to 2025 on ocelot-sgpio.1.auto-input
> > [    2.872364] gpiochip_find_base: found new base at 1898
> > [    2.873244] gpio_stub_drv gpiochip6: (ocelot-sgpio.1.auto-output): added GPIO chardev (254:6)
> > [    2.873354] gpio_stub_drv gpiochip6: registered GPIOs 1898 to 1961 on ocelot-sgpio.1.auto-output
> > [    2.881148] mscc-miim ocelot-miim0.2.auto: DMA mask not set

[   16.699517] CPU: 0 PID: 7 Comm: kworker/u2:0 Not tainted 5.18.0-rc5-01315-g0a0ea78e3a79-dirty #632
[   16.708574] Hardware name: Generic AM33XX (Flattened Device Tree)
[   16.714704] Workqueue: events_unbound deferred_probe_work_func
[   16.720608] Backtrace: 
[   16.723071]  dump_backtrace from show_stack+0x20/0x24
[   16.728179]  r7:c31bcc10 r6:00000000 r5:c1647b38 r4:a0000013
[   16.733863]  show_stack from dump_stack_lvl+0x60/0x78
[   16.738954]  dump_stack_lvl from dump_stack+0x18/0x1c
[   16.744040]  r7:c31bcc10 r6:c31bcc10 r5:c31bcc10 r4:00000000
[   16.749724]  dump_stack from of_dma_configure_id+0x48/0x314
[   16.755335]  of_dma_configure_id from platform_dma_configure+0x2c/0x38
[   16.761911]  r10:df9bf424 r9:df9bf424 r8:00000069 r7:c31bcc10 r6:c1bbac5c r5:c31bcc10
[   16.769777]  r4:00000000
[   16.772320]  platform_dma_configure from really_probe+0x78/0x298

platform_dma_configure gets called because...

[   16.778360]  really_probe from __driver_probe_device+0x94/0xf4
[   16.784230]  r7:c31bcc10 r6:c31bcc10 r5:c1bbac5c r4:c31bcc10
[   16.789913]  __driver_probe_device from driver_probe_device+0x44/0xe0
[   16.796391]  r5:c1c51f28 r4:c1c51f24
[   16.799980]  driver_probe_device from __device_attach_driver+0x9c/0xc4
[   16.806548]  r9:df9bf424 r8:c1b9c728 r7:c1c51ef8 r6:c31bcc10 r5:e002191c r4:c1bbac5c
[   16.814326]  __device_attach_driver from bus_for_each_drv+0x94/0xe4
[   16.820635]  r7:c1c51ef8 r6:c0a012e4 r5:e002191c r4:00000000
[   16.826319]  bus_for_each_drv from __device_attach+0x104/0x170
[   16.832190]  r6:00000001 r5:c31bcc54 r4:c31bcc10
[   16.836827]  __device_attach from device_initial_probe+0x1c/0x20
[   16.842871]  r6:c31bcc10 r5:c1b9ccd0 r4:c31bcc10
[   16.847507]  device_initial_probe from bus_probe_device+0x94/0x9c
[   16.853637]  bus_probe_device from device_add+0x3ec/0x8b4
[   16.859073]  r7:c1c51ef8 r6:c31b9c00 r5:00000000 r4:c31bcc10
[   16.864756]  device_add from platform_device_add+0x100/0x210
[   16.870455]  r10:c1a21744 r9:c1a21724 r8:c31bcc10 r7:00000002 r6:c31bcc00 r5:c3201aa0
[   16.878320]  r4:00000002
[   16.880864]  platform_device_add from mfd_add_devices+0x308/0x62c

platform_device_add sets up pdev->bus = &platform_bus_type;

That assignment looks to date back to the before times... Now you have
me curious. And a little scared :-)

[   16.887008]  r10:00000000 r9:00000000 r8:00000000 r7:00000002 r6:c31bcc00 r5:c3201a40
[   16.894875]  r4:c12be398 r3:00000000
[   16.898465]  mfd_add_devices from devm_mfd_add_devices+0x80/0xc0
[   16.904514]  r10:df9be9bc r9:df9be9bc r8:00000005 r7:c12be2e8 r6:fffffffe r5:c31b9c00
[   16.912381]  r4:c31ecc40
[   16.914924]  devm_mfd_add_devices from ocelot_core_init+0x40/0x6c
[   16.921058]  r8:00000065 r7:c31b9c00 r6:c31ec9c0 r5:00000000 r4:c31b9c00
[   16.927790]  ocelot_core_init from ocelot_spi_probe+0xf4/0x188
[   16.933662]  r5:00000000 r4:c31b9c00
[   16.937251]  ocelot_spi_probe from spi_probe+0x94/0xb8
[   16.942434]  r7:c31b9c00 r6:c1b9fc60 r5:c31b9c00 r4:00000000
[   16.948118]  spi_probe from really_probe+0x110/0x298
[   16.953116]  r7:c31b9c00 r6:c1b9fc70 r5:c31b9c00 r4:00000000
[   16.958800]  really_probe from __driver_probe_device+0x94/0xf4
[   16.964669]  r7:c31b9c00 r6:c31b9c00 r5:c1b9fc70 r4:c31b9c00
[   16.970354]  __driver_probe_device from driver_probe_device+0x44/0xe0
[   16.976832]  r5:c1c51f28 r4:c1c51f24
[   16.980422]  driver_probe_device from __device_attach_driver+0x9c/0xc4
[   16.986991]  r9:df9be9bc r8:c1b9c728 r7:c1c51ef8 r6:c31b9c00 r5:e0021bc4 r4:c1b9fc70
[   16.994768]  __device_attach_driver from bus_for_each_drv+0x94/0xe4
[   17.001077]  r7:c1c51ef8 r6:c0a012e4 r5:e0021bc4 r4:00000000
[   17.006762]  bus_for_each_drv from __device_attach+0x104/0x170
[   17.012632]  r6:00000001 r5:c31b9c44 r4:c31b9c00
[   17.017269]  __device_attach from device_initial_probe+0x1c/0x20
[   17.023311]  r6:c31b9c00 r5:c1bb0a50 r4:c31b9c00
[   17.027948]  device_initial_probe from bus_probe_device+0x94/0x9c
[   17.034077]  bus_probe_device from device_add+0x3ec/0x8b4
[   17.039513]  r7:c1c51ef8 r6:c31b9800 r5:00000000 r4:c31b9c00
[   17.045197]  device_add from __spi_add_device+0x7c/0x10c
[   17.050550]  r10:c1c53844 r9:c30ec810 r8:00000001 r7:c30ec810 r6:c31b9800 r5:c31b9c00
[   17.058415]  r4:00000000
[   17.060959]  __spi_add_device from spi_add_device+0x48/0x78
[   17.066568]  r7:00000000 r6:c31b9800 r5:c31b9c00 r4:c31b9a1c
[   17.072252]  spi_add_device from of_register_spi_device+0x258/0x390
[   17.078556]  r5:df9be9a0 r4:c31b9c00
[   17.082147]  of_register_spi_device from spi_register_controller+0x26c/0x6d8
[   17.089239]  r8:c17105c0 r7:df9bea04 r6:df9be9a0 r5:00000000 r4:c31b9800
[   17.095970]  spi_register_controller from devm_spi_register_controller+0x24/0x60
[   17.103412]  r10:c1c53844 r9:c31e9584 r8:c31b9800 r7:c31b9800 r6:c30ec810 r5:c31b9800
[   17.111278]  r4:c31b9bc0
[   17.113822]  devm_spi_register_controller from omap2_mcspi_probe+0x4c8/0x574
[   17.120924]  r7:c31b9800 r6:00000000 r5:c30ec940 r4:c31b9bc0
[   17.126608]  omap2_mcspi_probe from platform_probe+0x6c/0xc8
[   17.132308]  r10:c1bf0f80 r9:c202f00d r8:00000065 r7:c30ec810 r6:c1bb1d00 r5:c30ec810
[   17.140174]  r4:00000000
[   17.142717]  platform_probe from really_probe+0x110/0x298
[   17.148151]  r7:c30ec810 r6:c1bb1d00 r5:c30ec810 r4:00000000
[   17.153835]  really_probe from __driver_probe_device+0x94/0xf4
[   17.159704]  r7:c30ec810 r6:c30ec810 r5:c1bb1d00 r4:c30ec810
[   17.165387]  __driver_probe_device from driver_probe_device+0x44/0xe0
[   17.171865]  r5:c1c51f28 r4:c1c51f24
[   17.175455]  driver_probe_device from __device_attach_driver+0x9c/0xc4
[   17.182023]  r9:c202f00d r8:c1b9ca1c r7:00000000 r6:c30ec810 r5:e0021e84 r4:c1bb1d00
[   17.189800]  __device_attach_driver from bus_for_each_drv+0x94/0xe4
[   17.196108]  r7:00000000 r6:c0a012e4 r5:e0021e84 r4:00000000
[   17.201792]  bus_for_each_drv from __device_attach+0x104/0x170
[   17.207661]  r6:00000001 r5:c30ec854 r4:c30ec810
[   17.212299]  __device_attach from device_initial_probe+0x1c/0x20
[   17.218342]  r6:c30ec810 r5:c1b9ccd0 r4:c30ec810
[   17.222979]  device_initial_probe from bus_probe_device+0x94/0x9c
[   17.229109]  bus_probe_device from deferred_probe_work_func+0x8c/0xb8
[   17.235594]  r7:00000000 r6:c1b9ca30 r5:c1b9ca1c r4:c30ec810
[   17.241277]  deferred_probe_work_func from process_one_work+0x1e0/0x53c
[   17.247950]  r9:c202f00d r8:00000000 r7:c202f000 r6:c2020a00 r5:c2156500 r4:c1b9ca5c
[   17.255728]  process_one_work from worker_thread+0x238/0x4fc
[   17.261428]  r10:c2020a00 r9:00000088 r8:c1a03d00 r7:c2020a1c r6:c2156518 r5:c2020a00
[   17.269293]  r4:c2156500
[   17.271836]  worker_thread from kthread+0x108/0x138
[   17.276757]  r10:00000000 r9:e0009e4c r8:c2160cc0 r7:c21a6a80 r6:c2156500 r5:c036aac8
[   17.284624]  r4:c2160900
[   17.287168]  kthread from ret_from_fork+0x14/0x2c
[   17.291904] Exception stack(0xe0021fb0 to 0xe0021ff8)
[   17.296982] 1fa0:                                     00000000 00000000 00000000 00000000
[   17.305202] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   17.313420] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[   17.320069]  r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c037341c r4:c2160900
[   17.328184] mscc-miim ocelot-miim0.2.auto: DMA mask not set
