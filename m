Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC356EDFCF
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 11:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbjDYJ5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 05:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjDYJ5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 05:57:39 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0D6C15B;
        Tue, 25 Apr 2023 02:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682416657; x=1713952657;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DALW662Gclyn9dYy/dn/bAlBAp3cpASSDbbwppPFWqo=;
  b=Fmfjt86lUssuSk1CFoADIZ0lQZ7fLonkVn9owvTi6VJJMKUR2BbJSfFe
   zJhejr0F5sUZTdJjJ7AQERloeHS26LZz0Z2TTr+G+jLeOjT91Mt+jk3yv
   V4dEJI+gUVAEnAcIdCB3TkSKBNBSEBPdq3cLKvkBVRzffBBBCVxnyy3f6
   Nxy5drkaLC+cbAYCscSoC4xPRldWD9NCDC967FjXJyv9a+k2zkXl2GtL7
   jkPXvM9xK9jPL5fjZGlHXv3Qi6xland3j0vdgDowEruvQtByr0cP+NyH9
   rtr8akI5uVi6zpk57ACmVsVzuaEYENKdHyk25Xv6weYd7KZIKhd/KdtV3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="327023595"
X-IronPort-AV: E=Sophos;i="5.99,225,1677571200"; 
   d="scan'208";a="327023595"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 02:57:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="696118773"
X-IronPort-AV: E=Sophos;i="5.99,225,1677571200"; 
   d="scan'208";a="696118773"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 25 Apr 2023 02:57:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 25 Apr 2023 02:57:37 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 25 Apr 2023 02:57:37 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 25 Apr 2023 02:57:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wch4GwQ/z/tg68Z4yYzSMKslOLdMEepeX0Ih+2pmWdQhvA9LXCI/707w9tD/BAg0aRCttaD6BfTvmethMYZq5D/B+bRJVEqchqD42jpRjFam3Irv2dFtaTRl6K3FuFmGPQgnxeIHdp2yIUFzJokUFp3H6UTj+exIp7KKd++PQ6NhSytZxbW3RS95rSBYkMqsS/na7UU0ECzPWm5suEf1nzje8xYOP1q1GLVbJcEw++px81fRdvBTkF3/N7446MAn4V3SGn9t2NVNev3yb8Z59nXiTsFR3bWIY5Fswi4ihYcb3+jD01hwKcKVioo9u1Ls5OkHa3UEDOlhRH4MOlrutw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9h3afZwfW4n7H1yC+vseqk7mLlMQ2hhL7IE4vpRh/bo=;
 b=d+TUSJKu9TxAXW2PSFVJoZZ4KXWdOZM3l2cmFRquS2bvDDAlo2cePr3jZdEXK6oFKcYpFPTvWJChoeY7xdOtdf8ZIK48s/Pnu2ozzKsHuNLmQZMA2HOEi/PkFjpbVIz4a9zp4ffvuPU7NszqTIVcqQDLD9RjKeDSSwdu+X9YoAlEm4xMkipcbm8Ec5rmtXbStfHQ7m5kKIK2kH8TMhhIUYGXWR61tm90OXTP/iS+H0Eo2O2YmtNQ/yP5ExNd2hj3wKEZ9tk6ruqXZhqUC6CgnQu9PFNegs9RRyOq0lpzgXQ76PgAGaFKsvlw5luKIaoJu2pkWsgKOtVs7yj8lk2Bnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CH0PR11MB5252.namprd11.prod.outlook.com (2603:10b6:610:e3::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.34; Tue, 25 Apr 2023 09:57:10 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%3]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 09:57:10 +0000
Date:   Tue, 25 Apr 2023 11:56:57 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Kal Cutter Conley <kal.conley@dectris.com>
CC:     John Fastabend <john.fastabend@gmail.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xsk: Use pool->dma_pages to check for DMA
Message-ID: <ZEej6ZJVAgzRueyA@boxer>
References: <20230423075335.92597-1-kal.conley@dectris.com>
 <6446d34f9568_338f220872@john.notmuch>
 <CAHApi-=Vr4VARgoDNB1T906gfDNB5L5_U24zE=ZHQi+qd__e8w@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAHApi-=Vr4VARgoDNB1T906gfDNB5L5_U24zE=ZHQi+qd__e8w@mail.gmail.com>
X-ClientProxiedBy: FR0P281CA0191.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::14) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CH0PR11MB5252:EE_
X-MS-Office365-Filtering-Correlation-Id: bad466d7-0571-4937-c729-08db45736f49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lAc3jyFAG+m5dKq87MlrYeVkBYdbnTigcgKXQrBWzjNTCkVWn2AUwsoXJgjVpkNeMeSWxxWbS5Vm97t8j5pGb1ijjvTqfb/FMFH3lMyt8IU7A2c6l4p6roLghaSRVODFSjLuVO1jheaRrAUeXze87z/EBENdv26iXG3HsczPlOiSGYNsuA7jIMO48fJLd5NxymqP25iNXJocX4Gu8Y7jnrlQa/eYZFOgjIy8IOpXrjrUapd9GPkmfrfhPA4Lq6xSiQCCYM2k8RDA6w6IOtkdsIXosUtkg56798UkHUtWOiSCcA6S/bQ4mo1Uzb+Juozehk1LGMBvIaUg7ive9iRQG+jeskOHcBIa4IZJi5gbW+y6PRidu22Jg+SoiM02Zxta9EG1j3Wt3Cp/s334oZpCANzvLhyfp1cY5S55KDBticdbOmaGTiy0g/SFxeM6IZuf6xfCipase9NbjCjuppahzUlDb6VIbpTx1l9+ck9X5m1id9yUdV0PePLqjPw1zKi1mgsNqZivS34RTMREtBFVK8lCenFdfS1DVGu5znGlbaw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(366004)(376002)(396003)(39860400002)(346002)(451199021)(82960400001)(316002)(44832011)(6916009)(4326008)(38100700002)(41300700001)(5660300002)(7416002)(8936002)(8676002)(33716001)(86362001)(2906002)(66476007)(66556008)(966005)(6486002)(6666004)(6512007)(6506007)(26005)(9686003)(478600001)(83380400001)(186003)(54906003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5+nrMytWkROLezeC7oxUFcgOtVNottTQgH8CkLAf1tsidTDqxVV9ugNcm/XI?=
 =?us-ascii?Q?LHLuaeRvvSQlhobP2+JY1PR9UukAYGPTDSDX9nUImZtLeQMFKMYBNFt31jQ4?=
 =?us-ascii?Q?c2GTHW1ftBqvPqCAG2nkLGOuG12NoJvZNR8BIgSLpbDhk5TbAzBZogTq1Zhx?=
 =?us-ascii?Q?rPlxjQ39Tp6JZO7K0X1hgEnJP1g9LMNuN+c8v1wBmfJ2terACGx6GGMLUQib?=
 =?us-ascii?Q?Fxf60TnHPgNVfCoOKDtsGQ+afSS1wYWRwxanBqOHXHyrEDoP5chdOMRAfww3?=
 =?us-ascii?Q?5UJ8Pgo0wdVuVQLNgCS3APBRuzW2SXmhp3mWeCdyDXdzZOyj61ATw8hmQVQS?=
 =?us-ascii?Q?EXB3hQyJwtBYDTzUcStm4lS7AEzFeO9yB8X7mCg+z0dM8X3GjL3K2WitVOeP?=
 =?us-ascii?Q?6m2EU3QD63Tr/zkC6h8nXFOCnsutHweYFGBAl6sVfXAP6zkhFx/U+Q58BK0J?=
 =?us-ascii?Q?1xN7pawvNwVv9gLBWuWC3OgfYSCqT3kpoCSfchB86HL/69FRfWCGQtlcyBOP?=
 =?us-ascii?Q?slGkle81yhh7lWIJSZ33RZAH/TqCfzrIpGMoYl7RQbWX8kFA72tTqzOKCcVR?=
 =?us-ascii?Q?JcSf2N0QdU3sF+R7k60b20cHYr1YCjClb+EmRyeFZLSRLpSlx/RpM6mfko2n?=
 =?us-ascii?Q?KgxuB2NZyPf1KkTlzxf9wV/9jlb+HUeTyc3L4Qk0UgTbWGwvSPNyGRUQSZWX?=
 =?us-ascii?Q?2TtpDvC4UK2zdwpAT88ox8N913N+a6YVr0ViVqbXzsqMY9tzjUUfPLIdbRNN?=
 =?us-ascii?Q?Xxa+T+jvclMvRMf5mg3terxG8v+UkLMWVGYr5KjdsPJ5Y6PwYyLN2PpsfrrN?=
 =?us-ascii?Q?l+nIScEx66EKumV2KSvpAxVwkxQ+09ws79B2hOZu0NDWEbKt5rFBGKXzbd30?=
 =?us-ascii?Q?O4FVmHqz83Uk5fToT66R7HQiRawH09wFsPgcCGMwoc87CP6AqRw6O5M00C8H?=
 =?us-ascii?Q?Ru30wETh9LTunWTezP2slGoCtw/jO8jkxe/KrAjjbWjr1Xvp86uM5FjC00/5?=
 =?us-ascii?Q?qqtVu8I6sFzGt6AcSjL9wClkLPN+o/UmrY7FjM8cH81Ek5gc7vUkrOeyxK2v?=
 =?us-ascii?Q?qJ5tP9dXIaxuvdEP+fzyun+k+rwm3MOeBXC+uy/PcE5MNIc74GXAsn0RnOEZ?=
 =?us-ascii?Q?uZfg3s/ixsPQ2TXWI9RT+ONphelpCGXhqcvRzbFZNDi3nbN768KjBGJ34qYX?=
 =?us-ascii?Q?cXCX+FATI9cPDXZTRMXPe9oJwoDa6RR3Ve3g94y2nTdbaeBSRlAC7JZp1p8b?=
 =?us-ascii?Q?DRnBpzYmRRFTL1EJu4LQEr2YA5gEYGlIGeDQ1pairGuwIZe/e5Qg3qBQVC5W?=
 =?us-ascii?Q?KmpnZXCzjPo4OUvefvNaMIXlAHRRHPha2jnKuxEaMPrcBYF9qXKPUfc7YTuo?=
 =?us-ascii?Q?d7Y4CNXD3roLkZiuEcZ80notYf1Mkel/QXv4pk+1/MztQ2Yt8kwYpmqtN7X+?=
 =?us-ascii?Q?OzVuHh4OJbAa9h4F8xh28CK4T8FmS+3nq2qo8iOVT178+NULsja4+882e8yr?=
 =?us-ascii?Q?d+3Nr1xZKhbW8TP+ZUEiYh3/BHxYERFrdA2NrYCIQTyPVnnzgo0mYQWeryvJ?=
 =?us-ascii?Q?oKNz7TSLECombi30327gU/+ielezLkph4eaKk6wo3qNwK6O0J12lPEEjaUqR?=
 =?us-ascii?Q?Bg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bad466d7-0571-4937-c729-08db45736f49
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 09:57:09.6441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fWu2OvvBjCKrYPgJAagaZ4eAx57Jf/JH9dC6vDcCpL1MnBZsJW5Yn7N1qeBlmSRz4fMnNA9NBWgssZ/zTVLSKYfvzSgVN9nVl/BVr4FPt60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5252
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 12:52:53AM +0200, Kal Cutter Conley wrote:

Hey again!

> > > Compare pool->dma_pages instead of pool->dma_pages_cnt to check for an
> > > active DMA mapping. pool->dma_pages needs to be read anyway to access
> > > the map so this compiles to more efficient code.
> >
> > Was it noticable in some sort of performance test?
> 
> This patch is part of the patchset found at
> https://lore.kernel.org/all/20230412162114.19389-3-kal.conley@dectris.com/
> which is being actively discussed and needs to be resubmitted anyway
> because of a conflict. While the discussion continues, I am submitting
> this patch by itself because I think it's an improvement on its own
> (regardless of what happens with the rest of the linked patchset). On
> one system, I measured a performance regression of 2-3% with xdpsock
> and the linked changes without the current patch. With the current
> patch, the performance regression was no longer observed.

Okay, 2-3% but with what settings? rxdrop for unaligned mode? what chunk
size etc? We need this kind of info, "compiles to more efficient code"
from original commit message is too generic and speculative to me. 2-3% of
perf diff against specific xdpsock setup is real improvement and is a
strong argument for getting this patch as-is, by its own.

> 
> > > diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> > > index d318c769b445..a8d7b8a3688a 100644
> > > --- a/include/net/xsk_buff_pool.h
> > > +++ b/include/net/xsk_buff_pool.h
> > > @@ -180,7 +180,7 @@ static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
> > >       if (likely(!cross_pg))
> > >               return false;
> > >
> > > -     return pool->dma_pages_cnt &&
> > > +     return pool->dma_pages &&
> > >              !(pool->dma_pages[addr >> PAGE_SHIFT] & XSK_NEXT_PG_CONTIG_MASK);
> > >  }
> 
> I would consider the above code part of the "fast path". It may be
> executed approximately once per frame in unaligned mode.
> 
> > This seems to be used in the setup/tear-down paths so your optimizing
> > a control side. Is there a fast path with this code? I walked the
> > ice driver. If its just setup code we should do whatever is more
> > readable.
> 
> It is not only used in setup/tear-down paths (see above).
> Additionally, I believe the code is also _more_ readable with this
> patch applied. In particular, this patch reduces cognitive complexity
> since people (and compilers) reading the code don't need to
> additionally think about pool->dma_pages_cnt.

John was referring to xp_dma_unmap() with the comment above which indeed
is a teardown path, so probably this doesn't matter from performance
perspective and you could avoid this chunk from your patch.

> 
> > Both the _alloc_ cases read neighboring free_heads_cnt so your saving a load I guess?
> > This is so deep into micro-optimizing I'm curious if you could measure it?
> 
> It is saving a load which also reduces code size. This will affect
> other decisions such as what to inline. Also in the linked patchset,
> dma_pages and dma_pages_cnt do not share a cache line (on x86_64).

Yes I believe that the with your patch on unaligned mode by touching the
dma_pages you're warming the relevant cache line for your setup.

> 
> >
> > >               } else {
> > >                       xskb = &pool->heads[xp_aligned_extract_idx(pool, addr)];
> >
> > I'm not actually against optimizing but maybe another idea. Why do we have to
> > check at all? Seems if the DMA has been disabled/unmapped the driver shouldn't
> > be trying to call xsk_buff_alloc_batch? Then you can just drop the 'if' check.
> >
> > It feels to me the drivers shouldn't even be calling this after unmapping
> > the dma. WDYT?
> 
> Many of these code paths are used both for ZC and copy modes. You
> might be right that this particular case is only used with DMA.

Map/unmap is when you do ZC, copy/skb mode work without these internal dma
mappings.
