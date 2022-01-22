Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88294496962
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 03:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiAVCU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 21:20:57 -0500
Received: from mail-co1nam11on2137.outbound.protection.outlook.com ([40.107.220.137]:57312
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229689AbiAVCU4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 21:20:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FIBEA6NyY+bW5X5wh1mlTMD0qXcVQ21BUxrv4srVAoTo7GwfHAZ0x9Vyq9Fbu3K93Lp9CpsQPiHoUPdLC6i/z0oyqKUq1WEzHlWi71WnKD+HmZdiJAptFzAV/puoL7BiXsWCmfqoRC9ScFTRIZkxZoV0kakb1uiGDrFbx8YRPXlJelHk3bOgL6ENedlkrzTYDejAi7bppktt+W53JLvAmIqfFRvubAO+kXsTgFKERl4NkRZpZCrCafYkdNOvxMo1QAmCCIEeyqW2sYK+euR4gSsLpmghJzlFJzgvd/CABc6pBpZAIt4ITKAj3wubIdXDWmEkDX41Ew2xne8w4dVSCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SWUCMu79VvW5hZLrHDTVDWivpCE5iuBATCg/OGu2m1U=;
 b=bBHu0o1SpqWaHcDwB0KOkONZd+GDrAQzFUZd65PYRoVHofCH1n5snZ7/WC3wKnD3fvg4EAGGtfmjxqF1VEHTLlkEyB7EuF0Wv2TbnR3WJs/5qe8DwrCRw5fOMlB4yq0+0rsGlNGQddpIFgfX1aStFB2W7yChBeaC1wi5Xj46hjJlum+Rw7WH6XG/11yrpFkMR8VQ4eRK4QLFpNrlThi6OmxdCh7V344/je8QaZGQoBoQdT2GJnfg3aQHBrav7yXA9JpDuTLnVCl0WDCtZjnm5wAO2AxTvWDcwDoUIBgdSahd2ceQ5hzCcWvex2ZjTtPkk7GRXV3FAHQxKpeU/SX6Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWUCMu79VvW5hZLrHDTVDWivpCE5iuBATCg/OGu2m1U=;
 b=Tgb6C/Ys8Atq2QEKAET7i7KO9i4sTgv9GIjkSy69y2qxJ/4xxJrbA9XtZrUud1knZjlPYBzuZQ9ErvQSAFsBUNhlXUYSncQFhjAdiRmVvQZHl2QfEvLTQF1cCuR2gqd2wT9ZsVCO1rOK2HNzMUr9h0rTb5V7gBb6ektByw4Qksc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Sat, 22 Jan
 2022 02:20:54 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4888.014; Sat, 22 Jan 2022
 02:20:54 +0000
Date:   Fri, 21 Jan 2022 18:20:47 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [net RFC v1 1/1] page_pool: fix NULL dereference crash
Message-ID: <20220122022047.GA803138@euler>
References: <20220122005644.802352-1-colin.foster@in-advantage.com>
 <20220122005644.802352-2-colin.foster@in-advantage.com>
 <CAADnVQK8xrQ92+=wm8AoDkC93SEKz3G=CoOnkPgvs=spJk5UZA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQK8xrQ92+=wm8AoDkC93SEKz3G=CoOnkPgvs=spJk5UZA@mail.gmail.com>
X-ClientProxiedBy: MWHPR11CA0024.namprd11.prod.outlook.com
 (2603:10b6:301:1::34) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d42e6f28-234a-45d7-1384-08d9dd4dd100
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB43064775A19FB12CBF592E19A45C9@BY5PR10MB4306.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ST/aotNA++JrjKv567/D9NMOHIi0YGM9MFoyJVYKKjby5vjLMJkLZQP3E3cP+z4hfJme/1CSBqSYMyB7uMI5r0XYCFJdUrzHchWYEzN6KjPZNJXDttprDJTD0RNHP5q6mgX3EImA8DG2WPI71i7V6y02EmjJEinVtXfhwJHCesmZJVrcc5x6ruBoAIPynGPsX8d6IBtI3DERv96DTG+fEEpGc8ZqjeOWbKChBHPKp9kF8YWRBjDuU/O9JPgW2cIH7mMsOXPZcIMdgmL70FzYLCpKHGE+ckSq8XT18Tuwzi3Px86ih/t7mYvB7rJIABegjS7nfU5Mt4wv2xOiJCXERF7zJbV/Jnz82EQb6/Qb+mVAT5L64y7B77UrZnWaj6g4AbO8IQXJpsILgRVSNrYTtMW8jf/ZplJ/juwl8mv6PRD4ybBQ8GqEtK/YiSlMEwtkrsVspoHokd86czS9q4pwBmvSRGhQqEUUofuk/5Vhm787tkj4a94eP/663spY7pp+Yqa7buvQgXF1NGAAE+A0bAVV48NB8vZneEcaCNjL2oE3GaTIcsal/1aSF5AlxiBkaUc5+XjJx6ze/nW8qh6BThJbu8fMC6LxMF+KeSv0v7qOlU6pj6WZchKzRgHRLakjMAkmfo413ZGJ4lEi/IMqaX81afLR3rm18hUxcGbvD3XnTHBJVZnN/2PEAENaEuGBf3vRNCV4MzqcbHkCiUW4ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(376002)(39830400003)(42606007)(136003)(346002)(396003)(366004)(83380400001)(5660300002)(8936002)(26005)(6512007)(9686003)(1076003)(2906002)(86362001)(53546011)(8676002)(38350700002)(54906003)(6666004)(6486002)(38100700002)(33656002)(33716001)(6506007)(508600001)(186003)(52116002)(4326008)(316002)(44832011)(45080400002)(66556008)(66946007)(6916009)(66476007)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s40nO3ntnZnhcDxJguSf2+blpOwQWehqZbvsBfZlBlgxPZDqQwmdnl4sAHks?=
 =?us-ascii?Q?qesEpwcvmc7PNjihgysEHusv6mEBe/ugo15GM+vlZNPiDexiQ0b7ZSfl1dVG?=
 =?us-ascii?Q?ixvRnb3dCIm82g/YZL9+oxxID7u2GCg61Y/HQKsyH6jsUD2idbieTHPhLlpI?=
 =?us-ascii?Q?502HhQb9NwgG9pz/YMjql0r7Ae6eO1UG62eqlTAP6W9qlC3InIf7CSJomvdh?=
 =?us-ascii?Q?xzI0fR5DFj1dCtcf/chutYUHQN9iht4cyMPuiS1TXDpM8i9CjZLbxQDuxEVD?=
 =?us-ascii?Q?pZZ2bEMQa7QHhv4GJjtDhn9oRiTGqV5qjyjualwGfNHFYMS3fVLlIUsBpaA+?=
 =?us-ascii?Q?4btKmsK48X4td9nZR5MnCOiJEvMyVxNTjBZXL7f8SUMvbwYojPcn24z+mw1N?=
 =?us-ascii?Q?2HzZavGMXzC3mo//Ss/AImwS+xPYVKKiKfNcka2hDfCqmVgx1Moj7Ywe6fkP?=
 =?us-ascii?Q?XU8SHL+pyHqh+5rIf2+5DJE4jDsG4LRFnnco7N/xFQmRUMZxMlte2ETYdX/0?=
 =?us-ascii?Q?918tVUDY/r0VXR+BsfLyPcRXkpzZzBXBVPiFBLuAdY57+sXjAZ4NIN67k1Tr?=
 =?us-ascii?Q?TXGoJl23lZyU1zA8wfaSmSgASHYP3xsjDWIdt4wUV9xzCT2wIWe1HjdjwN6B?=
 =?us-ascii?Q?BxMSbidWRYB265XdoCBrYmaG4vEgXfQOnj1Ky2mEe1+g+y/oPfgcRMbZ+wwP?=
 =?us-ascii?Q?Q4Z3rRd1tWjDSHG2outp+FMAmrzbWY2ZwA/BILLN+kEoVuoWYpllwiQPphmV?=
 =?us-ascii?Q?JTVPueELIC8VEYT/vUQxT1jO401A3vUDEjDOoappx6TWssg5k09VBXQk+l8Y?=
 =?us-ascii?Q?GzoQdg1zdmHHlXEBMsZkts7iwPiMy5nxDBl3aAuenOdmlZHBX+INMXae0mAh?=
 =?us-ascii?Q?Ev0hyEFPHiRSaxPMSEBu8mrVhRSIoVZ9ilQe3tyEqsN6S/0xnETjGqzUhykX?=
 =?us-ascii?Q?0xg3H2El9iDmDD/8PghOhWFKDM+J6ACKaxwqXUZ2BAY1ALjwUess7toWeRXI?=
 =?us-ascii?Q?uUN2Wp+WJjVdAJXdC6SHvvEiKwLlg+jLvd6//KOBM8CojhKHtnyYBNCCGcjo?=
 =?us-ascii?Q?8KWMLgst3t7MiVutJnsqL/aYH0qZ3noRIfK4xCZ8K1VBuO33swIWm+q49G/N?=
 =?us-ascii?Q?dGQLW/s/J3x+9vrnUVR9T5eifYm2+C1ZtQMZncDg67BLPW9MFvYf9XFE7pDw?=
 =?us-ascii?Q?iIrOxCyaRL11T6mbby25Z0lmMoINTbyKWLchMWwweTKcDi/FV+rzdtiAbvf3?=
 =?us-ascii?Q?YFTR6fCkUWOfMYa8CL2FuqvseXEtKMgNPzaIbvbmLt/OxpNXd3r1mRfmWXyW?=
 =?us-ascii?Q?96okJ2qAygg7b7yvnU+SCWVHLNEfSKgcr2v+LL7zf4MgeXCcNPoafMF4bK2f?=
 =?us-ascii?Q?VUhnTUtkk8kemm+scAdHVWkrVXMaN1HjyyS2ic+D4X2sWrlk4FZGOv/93zBB?=
 =?us-ascii?Q?HdC2PgwYS4bk8qwp5uxLCP4ETbP9Ka+30PZ++aIHaQy6KllR4ybvBLTlG2lV?=
 =?us-ascii?Q?kSFcZ67osc3uJ5YY/brgJzuaQaaTWikO+1tBAc5PVacWJpG2ezwbevCwP1WK?=
 =?us-ascii?Q?Y6MJU3/DhhkBkfLYxxRwv7BiT+WW6bROvasWY2JVwqPTJI8d43qttXKgeQY2?=
 =?us-ascii?Q?q4e2c2cAdf3iqvHounZIeNc7qPAlCB3Gvjw3tQc1cnEDWm15cCsFSYa+u9qJ?=
 =?us-ascii?Q?XtIuYw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d42e6f28-234a-45d7-1384-08d9dd4dd100
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2022 02:20:54.0330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sH902EZLsI4XDC22Krlz7kMMFcDfDuFwWTxSAGP4ZmHhRXiqPu5/m2AnfL/dvi05KSe8kpoaOU26FZdQNihq2gihmBJPtZtA32wt+K/iBOE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4306
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 05:13:28PM -0800, Alexei Starovoitov wrote:
> On Fri, Jan 21, 2022 at 4:57 PM Colin Foster
> <colin.foster@in-advantage.com> wrote:
> >
> > Check for the existence of page pool params before dereferencing. This can
> > cause crashes in certain conditions.
> 
> In what conditions?
> Out of tree driver?

Hi Alexei,

Thanks for the quick response.

I'm actively working on a DSA driver that is currently out-of-tree, but
trying to get it into mainline. But I'm not convinced that's the
problem...

I'm using a beagelebone black with the cpsw_new driver. There are two
tweaks to that driver: the default vlan port is 10 and 11 so there's no
conflict between cpsw_new and DSA, and the ndev->max_mtu / rx_packet_max
have been increased to 1600 to allow for DSA frames larger than the
standard MTU of 1500.

My focus is on the DSA driver, but the crash happens as soon as I run
"ip link set eth0 up" which is invoking the cpsw_new driver. Therefore I
suspect that the issue is not directly related to the DSA section
(ocelot / felix, much of which uses code that is mainline)

As I suggested, I haven't dug into what is going on around the
page_pool yet. If there is something that is pre-loading memory at 1500
byte intervals and I broke that, that's entirely on me.

[ removes 1600 byte MTU patch and pool patch ]

I can confirm it still crashes when I don't modify the MTU in the
cpsw_new driver... so that doesn't seem to be it. That crash log is
below.


# ip link set eth0 up
[   18.074704] cpsw-switch 4a100000.switch: starting ndev. mode: dual_mac
[   18.174286] SMSC LAN8710/LAN8720 4a101000.mdio:00: attached PHY driver (mii_bus:phy_addr=4a101000.mdio:00, irq=POLL)
[   18.185458] 8<--- cut here ---
[   18.188554] Unable to handle kernel paging request at virtual address c3104440
[   18.195819] [c3104440] *pgd=8300041e(bad)
[   18.199885] Internal error: Oops: 8000000d [#1] SMP ARM
[   18.205148] Modules linked in:
[   18.208233] CPU: 0 PID: 168 Comm: ip Not tainted 5.16.0-05302-g8bd405e6e8a0-dirty #265
[   18.216201] Hardware name: Generic AM33XX (Flattened Device Tree)
[   18.222328] PC is at 0xc3104440
[   18.225500] LR is at __page_pool_alloc_pages_slow+0xbc/0x2e0
[   18.231222] pc : [<c3104440>]    lr : [<c0ee06c8>]    psr: a00b0013
[   18.237523] sp : c3104440  ip : 00000020  fp : c219e580
[   18.242778] r10: c1a04d54  r9 : 00000000  r8 : 00000000
[   18.248032] r7 : c36b9000  r6 : 00000000  r5 : c36b9084  r4 : 00000000
[   18.254595] r3 : c07a399c  r2 : 00000000  r1 : c325784c  r0 : dfa48bc0
[   18.261162] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   18.268343] Control: 10c5387d  Table: 836f0019  DAC: 00000051
[   18.274119] Register r0 information: non-slab/vmalloc memory
[   18.279825] Register r1 information: non-slab/vmalloc memory
[   18.285523] Register r2 information: NULL pointer
[   18.290260] Register r3 information: non-slab/vmalloc memory
[   18.295957] Register r4 information: NULL pointer
[   18.300693] Register r5 information: slab kmalloc-1k start c36b9000 pointer offset 132 size 1024
[   18.309569] Register r6 information: NULL pointer
[   18.314306] Register r7 information: slab kmalloc-1k start c36b9000 pointer offset 0 size 1024
[   18.322999] Register r8 information: NULL pointer
[   18.327736] Register r9 information: NULL pointer
[   18.332473] Register r10 information: non-slab/vmalloc memory
[   18.338257] Register r11 information: slab kmalloc-4k start c219e000 pointer offset 1408 size 4096
[   18.347301] Register r12 information: non-paged memory
[   18.352475] Process ip (pid: 168, stack limit = 0x7eb0d4ab)
[   18.358089] Stack: (0xc3104440 to 0xc3258000)
(too big a stack to show)


I can confirm that it crashes on net-next/master as well:
commit fe8152b38d3a, using the same DTB that defines the cpsw_new port
as the DSA master. Relevant DTS snippet from my in-development driver:

+&spi0 {
+       #address-cells = <1>;
+       #size-cells = <0>;
+       status = "okay";
+
+       ocelot-chip@0 {
+               compatible = "mscc,vsc7512_mfd_spi";
+               spi-max-frequency = <2500000>;
+               reg = <0>;
+
+               ethernet-switch@0 {
+                       compatible = "mscc,vsc7512-ext-switch";
+                       ports {
+                               #address-cells = <1>;
+                               #size-cells = <0>;
+
+                               port@0 {
+                                       reg = <0>;
+                                       label = "cpu";
+                                       status = "okay";
+                                       ethernet = <&mac_sw>;
+                                       phy-handle = <&sw_phy0>;
+                                       phy-mode = "internal";
+                               };


I was hoping for an "oh, if a switch is set up in DSA the page_pool gets
set up this way" type scenario. I fully understand that might not be the
case, and the issue could be in something I'm doing incorrectly - it
certainly wouldn't be the first time.

If this patch doesn't make sense I can look deeper. As mentioned, I'm
working to get this accepted upstream, so I'll have to figure it out one
way or another.

> 
> > Fixes: 35b2e549894b ("page_pool: Add callback to init pages when they are
> > allocated")
> >
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  net/core/page_pool.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index bd62c01a2ec3..641f849c95e7 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -213,7 +213,7 @@ static void page_pool_set_pp_info(struct page_pool *pool,
> >  {
> >         page->pp = pool;
> >         page->pp_magic |= PP_SIGNATURE;
> > -       if (pool->p.init_callback)
> > +       if (pool->p && pool->p.init_callback)
> >                 pool->p.init_callback(page, pool->p.init_arg);
> >  }
> >
> > --
> > 2.25.1
> >
