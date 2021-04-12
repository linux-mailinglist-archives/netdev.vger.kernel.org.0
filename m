Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1154435B9E0
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 07:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhDLFhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 01:37:47 -0400
Received: from mail-dm6nam12on2083.outbound.protection.outlook.com ([40.107.243.83]:7855
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229448AbhDLFhq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 01:37:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aFREYCECw0e8QM0EugRbBCMsUBp5qzb/eb3JxkQCQydrP7+w6LWbWqOYtJj355lxPKoVIg+A4rkh/mVQ6ZsVI4KU15S8gMgGkc2QmGP/bGir6zsT7OIcpcayEh4tGj8n0CFogogXGkTGMn5qrUDW+R0f4YETVLXA5WnMANRRLfTC7pV5tOTvCBIBlSQInbQ5AlnO/80A7QseewdzM6mCNSryCWc80uJTsquAvRK7KtbtZ/z19vjYcCE0QKHH35LfCI57VsrLbnN/okQUYqycHHHCReW+rPQwW1KELqUaL7cbPja22X4c1ckhjgifhywbyHsHq5In0E1Npm4qAjZ4Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HyWMggtiuCprit4TgYCubO+2iv3tDIcJ1LNHMmF0wg=;
 b=dozUTVfaA+il/snJWzW2cpWIBQ9u/jePdmzmjMwGw9ZerUSuv9zrD72LYNVdarUAocIjc/c7SKuSQ5Wa50BGiLWp2lZDUrS/CdJas3EjBInfZ5P5T1B583LnerllHSCOWd2amRzv2Acp5w54NvQhwWyRpBcSddDtXpp5Cy6yGumlutvMywj6CpnsNLSNNSr2gfM/mqKF3wmQMLzJ+lB2cyz/Bz7wIAYkq9+7S6P06uUy0QbbIUT2b0tcaIwCqaB4ZGAdmUCQqpkGbdeiBY/EzmYQFBQSN2TrXX/ooag94JYsau5jFXRKhs/HQa6ZDLpQucJ5FmyDF9GdJUBmS+3plA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HyWMggtiuCprit4TgYCubO+2iv3tDIcJ1LNHMmF0wg=;
 b=MbOTBEthr/QEo4a7BjZ8X7KwFmjwJQyRnVf+9iqhLiGjWgyJRNgMikYCjgzrRhG68BAzyQLf463NubSBs1mr/NTqINVPKH65gZjpSfW2i0h5kAQWSL+JI1CMtx4MAo6LuSlEMDl7o6fhEQdiGvYyPFeX7U1Ez67jqrs1eVTCQVQ=
Authentication-Results: brainfault.org; dkim=none (message not signed)
 header.d=none;brainfault.org; dmarc=none action=none
 header.from=synaptics.com;
Received: from BY5PR03MB5345.namprd03.prod.outlook.com (2603:10b6:a03:219::16)
 by SJ0PR03MB6239.namprd03.prod.outlook.com (2603:10b6:a03:3ad::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Mon, 12 Apr
 2021 05:37:27 +0000
Received: from BY5PR03MB5345.namprd03.prod.outlook.com
 ([fe80::8569:341f:4bc6:5b72]) by BY5PR03MB5345.namprd03.prod.outlook.com
 ([fe80::8569:341f:4bc6:5b72%8]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 05:37:27 +0000
Date:   Mon, 12 Apr 2021 13:37:11 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Anup Patel <anup@brainfault.org>
Cc:     Jisheng Zhang <jszhang3@mail.ustc.edu.cn>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        kasan-dev@googlegroups.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v2 1/9] riscv: add __init section marker to some
 functions
Message-ID: <20210412133711.7b625842@xhacker.debian>
In-Reply-To: <CAAhSdy0CgxZj14Jx62CS=gRVzZs9c9NUysWi1iTTZ3BJvAOjPQ@mail.gmail.com>
References: <20210401002442.2fe56b88@xhacker>
        <20210401002518.5cf48e91@xhacker>
        <CAAhSdy0CgxZj14Jx62CS=gRVzZs9c9NUysWi1iTTZ3BJvAOjPQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: SJ0PR13CA0159.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::14) To BY5PR03MB5345.namprd03.prod.outlook.com
 (2603:10b6:a03:219::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by SJ0PR13CA0159.namprd13.prod.outlook.com (2603:10b6:a03:2c7::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.8 via Frontend Transport; Mon, 12 Apr 2021 05:37:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4b3d65e-3f10-4ac8-da1c-08d8fd750e83
X-MS-TrafficTypeDiagnostic: SJ0PR03MB6239:
X-Microsoft-Antispam-PRVS: <SJ0PR03MB62391076B51DF15413E545D6ED709@SJ0PR03MB6239.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3GAciX+Jg7Rqb/SH7ftcrqi9XKo6wTuMWLj8pkq213uxsUyX487RYzB0J1RDhMiwl1SXhGR2aHm3V09+RNuQamXbkurWBGssxgoO+RmUbxJGwvW36BDu9IlIzGe8bMp3TRU05FrxMLiot8wD3m+7BwOKQBjOHESPVV0DfW5aDv4HgZX3xkCEJ7sUivgr9F94lq0s22b0r4TmhEaZOfjpegJ9rP6ou3BTx576cMlatU+00h1s+yL5hAZV4bDMDI27Ihn44Z9+2leyv/1dTS0/+YgsbEXETpmFSCG2HHXTwtHFhZ0Bidv8a4LsL+I39FmvJhAp/IrUVS+R76a7tRXP4Hgj85G2jCDkPh1+pC5Ur0cb3ydjddnLrPkYz701ubWqKo+nveAQFv6dUrp4/CIoWZKS6i/qWxBEE9i2BjhCXUylAJJX0q9DblBCsomoCzKJT4VixnlwVkb7DjlTRZu5fyXtXJwkmkCna4xMtVV3Ka4xnzRgwYEwmaDdHCQOjJDH/FkGLJ22c0JJMhaK33KcnysIgkznf5sR1EuunFno3Dq/rGakPdjFhmS9Jb3VV4CE/O93R8CEMefiOHlHndCc1NN5AfBAdrE/E0B2US2x+0DowXaspX2dfQnSBx5YCyb78fjZlt9/BRwRAFvcRGeQYwSca2d5YglS6p08KoJTuGk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR03MB5345.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39850400004)(396003)(346002)(376002)(136003)(7696005)(52116002)(55016002)(38100700002)(38350700002)(2906002)(316002)(26005)(4326008)(1076003)(6506007)(16526019)(53546011)(9686003)(86362001)(66556008)(186003)(8676002)(6666004)(956004)(66946007)(7416002)(6916009)(66476007)(8936002)(478600001)(54906003)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bLYrPWHF8JJ2Cl+59CWRQovnlUXJ5MKx8TwAMHcnFc3RDO9l0Yi2lRntLzXd?=
 =?us-ascii?Q?qvvXZZaCJmsDbEXDg56iyNpDKORv0lq+BY9hwFqgTO7GPXZi8AtDENdHz4hA?=
 =?us-ascii?Q?TAlTY03dc/Ja+oHQW4nSoafkrxQX9Lmwt4uMmqqW+Jdg9eQdRZ44m083Y1TL?=
 =?us-ascii?Q?qm7Dfe4+r2PFpCsAjZE3V9a9eT5enLiEHj1XlUf6EvWaiSZAH/N5Cd47TmQu?=
 =?us-ascii?Q?4MAPHdlznCghDd74BoSxrBItLSzkvgZwM+besQwK9eTVxdYCt4TTDpo3kQCA?=
 =?us-ascii?Q?2h8UOkVg6QwWWsGVYThYYthoSTr+CVzoJDYFJ2mHcBj5OwPJnHd7c/kum7dX?=
 =?us-ascii?Q?CCQoTlrCZ94h/XU1zq2i36IzTWXpyx1buF/jx9bwC0jMDT9VESImuvHZp7UF?=
 =?us-ascii?Q?FFsWfOZ91ubbL9RtrceYXitDWv3AehsRY2iynwRLHMT+xkeOgdOnxrUxFxTq?=
 =?us-ascii?Q?bMw68Oa90zExVgoAaDkNoVHARJ3mC2nwDZuIGJJgDwOv64ywmrkKK6KUUCW4?=
 =?us-ascii?Q?YZF8pvHb38teciIQDThiaBifzFMnF8A2Ne8tHuQmpOQObpmRl6pozY//P9Pj?=
 =?us-ascii?Q?4QcGxVcYJRP9EiyH+uRfrPY5zD2qBaPCblFHcTajTcKC8bkH4uougsAu2Fev?=
 =?us-ascii?Q?hsuamdFkkMZcyAQQRrXg1eIzy3cGmBkB0FTqOMcJB/oLXILt3ZES6vYObAR4?=
 =?us-ascii?Q?hsesKe3pn0f6goz4xu6VR8YgUJ8RmEzMoxnPCphkT+9thQM2uXuXWrFJ7XJ7?=
 =?us-ascii?Q?ey0+9L2S6cG090TtC62Ry3OMHXfTjA/ah7b8WEOxkYREK/kPzROmQRq44j2T?=
 =?us-ascii?Q?m/QbKPZ4JjotVCVO0TOW+Yg0dIHI1WHo+MTBz65YQFC3mK85Hg9qMdFjHAy7?=
 =?us-ascii?Q?l5thFTEKaztCuyaWmVfRlkOklSr5LcUEEQTTOI29Nv6a2p1uhVZdCEOMDHYo?=
 =?us-ascii?Q?oVRQhQcWgS5Yed1E0ur15xlicaMduxnkiPsDRYS34AxA18g0cxgjKfV7DCbc?=
 =?us-ascii?Q?mZWnoYXVQcdw3FxNTAl4HDtSAyv2+ASP39DJ7j0PJawe4xFKbZz5XP7TOURj?=
 =?us-ascii?Q?apQDJPUeaF1NorlZISlBYsUngzd3R46wiM3ndXKqwxmIH0sSkjV2s0tLQKcV?=
 =?us-ascii?Q?a37uEzjMgbjQX29fp1DLIHi98FBbDMUTpP4Wk3/+0NempLlx4CcTebb14Wzr?=
 =?us-ascii?Q?qyKOq8rkQZ3H7NmrrIi58krQKfzhDikVn9UABRS15XRSCxf/rrWysMCDGviy?=
 =?us-ascii?Q?/J56/BYfU4jYVLFMwq1eN2aTW7zbsy+lflbf7hnllqQciM9BK0MdxoSOVS3C?=
 =?us-ascii?Q?9b184m6F0fnGkG40s5qbQeGZ?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4b3d65e-3f10-4ac8-da1c-08d8fd750e83
X-MS-Exchange-CrossTenant-AuthSource: BY5PR03MB5345.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 05:37:27.1768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NYlbIr71RZ2/13b1wPPqXxEXBPhYgu3cUn/KoPoVLKJrCsribjr1dy9tCnb5b9HzD8P+DwZd+Oz6nPQID8GuZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR03MB6239
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Apr 2021 09:38:02 +0530
Anup Patel <anup@brainfault.org> wrote:


> 
> 
> On Wed, Mar 31, 2021 at 10:00 PM Jisheng Zhang
> <jszhang3@mail.ustc.edu.cn> wrote:
> >
> > From: Jisheng Zhang <jszhang@kernel.org>
> >
> > They are not needed after booting, so mark them as __init to move them
> > to the __init section.
> >
> > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> > ---
> >  arch/riscv/kernel/traps.c  | 2 +-
> >  arch/riscv/mm/init.c       | 6 +++---
> >  arch/riscv/mm/kasan_init.c | 6 +++---
> >  arch/riscv/mm/ptdump.c     | 2 +-
> >  4 files changed, 8 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
> > index 1357abf79570..07fdded10c21 100644
> > --- a/arch/riscv/kernel/traps.c
> > +++ b/arch/riscv/kernel/traps.c
> > @@ -197,6 +197,6 @@ int is_valid_bugaddr(unsigned long pc)
> >  #endif /* CONFIG_GENERIC_BUG */
> >
> >  /* stvec & scratch is already set from head.S */
> > -void trap_init(void)
> > +void __init trap_init(void)
> >  {
> >  }  
> 
> The trap_init() is unused currently so you can drop this change
> and remove trap_init() as a separate patch.

the kernel init/main.c expects a trap_init() implementation in architecture
code. Some architecture's implementation is NULL, similar as riscv, for example,
arm, powerpc and so on. However I think you are right, the trap_init() can be
removed, we need a trivial series to provide a __weak but NULL trap_init()
implementation in init/main.c then remove all NULL implementation from
all arch. I can take the task to do the clean up.

> 
> > diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
> > index 067583ab1bd7..76bf2de8aa59 100644
> > --- a/arch/riscv/mm/init.c
> > +++ b/arch/riscv/mm/init.c
> > @@ -57,7 +57,7 @@ static void __init zone_sizes_init(void)
> >         free_area_init(max_zone_pfns);
> >  }
> >
> > -static void setup_zero_page(void)
> > +static void __init setup_zero_page(void)
> >  {
> >         memset((void *)empty_zero_page, 0, PAGE_SIZE);

I think the zero page is already initialized as "0" because empty_zero_page
sits in .bss section. So this setup_zero_page() function can be removed. I
will send a newer version later.

thanks
