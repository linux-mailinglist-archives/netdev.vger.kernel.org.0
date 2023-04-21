Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6158F6EA733
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbjDUJiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjDUJiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:38:10 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D91A5D1;
        Fri, 21 Apr 2023 02:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682069883; x=1713605883;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CSrst+Vq+LYUUJaHQGE41QfUXbCtoWQsmCH4mNAij3Q=;
  b=G+Jfz7KOthhywgsGnLelgSD242NSB6efZbjRt183OxAeQsd8HgG9F535
   Vz8BfKrTLuHGzmULXVDwhdan8rDjgbMosGuilI6BihzvhVqeuV1tpie88
   1ZH/6n6ayXaIbv/xXqHqt8OHiFfJGnZgb6v59y6aITfzjW92tQsJmkxX2
   6nXK1zNC4rd0V59/JvUZ7fu8KHnp7Nbg7Bbvw7yAcyhbSfKugkO0Izbac
   P/maqnGhcDNg269RBW/S5Ntyx+ArxeNRu7VhbYN3LFR67CcmXdSvRUqEc
   jE+k33OasRl0Jh3U/GaZxPkEMNdcKUV2FNylI6zn+BsCMIGH2Q4hkIiFf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="348749853"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="348749853"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 02:38:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="724757021"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="724757021"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 21 Apr 2023 02:38:02 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 02:38:02 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 02:38:01 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 02:38:01 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 02:38:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vl5SwSKFQYtnVTnNglmvgWVrAyRmFP713LIp0HzbY/y6o6rsBmmS8yPVA/IAzHp/NpR/IFcPAaL8FBOXWGcsf+Ae7g8OWaFy7mgwmNp2twWryYcbJeI6F4GCe3g0HFZXTLOUH6T1GylH+t1p2s80BDZP6pIDnmgucycSyTU1y3ngbC6iXga/FVVY73lTBKpu9qnmScscS4iERCSWxYm3EHduT4G9gh0aEhwVMHnNfXxHuV3Ngw9IIjNmJocBye4nxuHBHWJJ52XrRhHj+6nHvDS+bDZ9/t02IU1PqNaafMcnOljtn+Yny1oQ/Fufc3dG0VBP2FLw2n/bDbe9lmMXIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z1rXYSB+WhHBJbRwzFAsDrkCSUT+U+/XvOVjRCdQDlk=;
 b=Tt0dS4chzxCpajJeW3AF6XHt4sWzMNYiNiNIBYL3NhwDaPfzQyMM4YKT2fQj9n/AwYNeD9y+cGg1Bf0F8kKLgiGz2HNM1Hh4zJzLcXuY5Z/4xuou2qCFrreukT/EdOqlXuzz+IgVAvvRFqGBytcUuiavlQK1+42pS7j+2EsYA+8WlI5LmOQfbZM2n0A3tOW3FUQAhDT+7YmiPg0PaucA+Xjo4pY/MOn9yAB9+v4fknxYpKpjz0iiOsuSvhm+Es7Aqu5iquWO6mhPanljdxGIgIqd3fUeXdSB3yP6pigKtbmMBhLY1orZIQbIt1hTFyJyhhY/764jgMSTjewGwA1Daw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 IA1PR11MB6441.namprd11.prod.outlook.com (2603:10b6:208:3aa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 09:37:53 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%3]) with mapi id 15.20.6319.021; Fri, 21 Apr 2023
 09:37:52 +0000
Date:   Fri, 21 Apr 2023 11:37:37 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Kal Cutter Conley <kal.conley@dectris.com>
CC:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 1/3] xsk: Support UMEM chunk_size > PAGE_SIZE
Message-ID: <ZEJZYa8WT6A9VpOJ@boxer>
References: <20230406130205.49996-2-kal.conley@dectris.com>
 <87sfdckgaa.fsf@toke.dk>
 <ZDBEng1KEEG5lOA6@boxer>
 <CAHApi-nuD7iSY7fGPeMYiNf8YX3dG27tJx1=n8b_i=ZQdZGZbw@mail.gmail.com>
 <875ya12phx.fsf@toke.dk>
 <CAHApi-=rMHt7uR8Sw1Vw+MHDrtkyt=jSvTvwz8XKV7SEb01CmQ@mail.gmail.com>
 <87ile011kz.fsf@toke.dk>
 <CAHApi-=ODe-WtJ=m6bycQhKoQxb+kk2Yk9Fx5SgBsWUuWT_u-A@mail.gmail.com>
 <874jpdwl45.fsf@toke.dk>
 <CAHApi-kcaMRPj4mEPs87_4Z6iO5qEpzOOcbVza7vxURqCtpz=Q@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAHApi-kcaMRPj4mEPs87_4Z6iO5qEpzOOcbVza7vxURqCtpz=Q@mail.gmail.com>
X-ClientProxiedBy: FR0P281CA0001.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::6) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|IA1PR11MB6441:EE_
X-MS-Office365-Filtering-Correlation-Id: b938e039-6843-4709-4f2d-08db424c13e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fMmm3sI6hgtUJYJn6U5GglpZvHX1TG9iDHxYk80APxjdKc4kK1FAH9Jy+3GflVrLb7FEN/AtRtxVuJ0F+2SriNyKu3k3d6r8Jzi2dej7xm8S5waKHy4dnCijS1UzG8k1Q2fLl+txa5brvf6Qy49HTgmYJi/Exd9thtlNkrjTe77B9LpJbdCIJrnTh82C7EiKQmpv/ijLZpzbdZNcQV98FJZl9ReoIFX+qq2bvjpJx0pX3CfgL2dq0Az5/yS3HDtqrEX9S3j7sV2pCm9n0bH0wZh8YRP2qY18Yrj01ZhA1DYJi0HUXMgRpwc6k0y1DQtInBhp79tuNIM5oStyhtZ01BIZJpumIwiSRvitwOiAGiEUw6ByY2CqETTLCCKln01dVdlPcJZsBfwKkheCLDMLJ+UfQd9/i2Y0FwVqLSL9n7JsIW2sm6KPdn7eMrgRv3yqdYF/T65tb+/YUUJrBIpLOxkG/Yq+2zSipAV8YNEDdadyuIydc0dafGE/s+E0DGXnnnnf+G49Jc7YeACH3fkvXrIULAPx4r5cVcvi1YR82RmNGIIdJTypIegvla1F/kke
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199021)(33716001)(86362001)(2906002)(66899021)(6486002)(6666004)(186003)(83380400001)(9686003)(6512007)(26005)(6506007)(82960400001)(478600001)(66476007)(6916009)(4326008)(66556008)(66946007)(41300700001)(316002)(38100700002)(7416002)(54906003)(8676002)(5660300002)(8936002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fJ9eu+/A9FZ3Exxdk8wM+YWRHjefelPYgkTSWC/48wScOVCXJc2GLx16m6/s?=
 =?us-ascii?Q?0v5VJNxRN15GyLXEKPtSw+ilkn3m6mQqyBgfBdF66/0UurVAMlPSjmn72VOv?=
 =?us-ascii?Q?Xd8bpxlOuP9rZ7VqdiKhXLZ+xilkT7o3DYzacrNSmzr1R9LnstgKU4nMOSq4?=
 =?us-ascii?Q?r2SGg/4xSjneIzRnNnTIEG/Fa317wPT264Z8P1Dz+qC9fUaxP1WsCcPjbvZU?=
 =?us-ascii?Q?R9IJyGdQmK7OD3fnl2k0TDmeuf4/mAqk/Tx9wc3xQO/ejCVOYi9AmeS/gf0k?=
 =?us-ascii?Q?hfIMvh+NQibFxB/A99ZvWTBGU8tu944uwshL3eI3FB1VZlnOv4Esy0Bh5eKF?=
 =?us-ascii?Q?D/RjUplROQFbThW6EDgza3u1Dcjp4fDqyJiv2crq6FpbWv6pcevplWD3ZgX6?=
 =?us-ascii?Q?17sNboshw8GifrA4JcnAuDZY644HvRS624sdKLQYKbtu9AUymDKYlCPYuTFI?=
 =?us-ascii?Q?3gYXbIaLJtT5YR192EaYvl3M6yYQZWScZkfoB0Ney43m2tr4F1V1Q4AR10PL?=
 =?us-ascii?Q?jytIUbbA7TIuzh4aAIHxMx/lwfpcOfb35X6Ayhew6gunWsOStRY/Ot89OMr5?=
 =?us-ascii?Q?8ca8ZOS9hc6LPKmpip11eCN+MSMkQiRmnKt7ONL0bUPehXlc0y61dMFubkpF?=
 =?us-ascii?Q?qUbpoF6DdJzOMqcX4FYNc4i+No4AyYNBMsAxgdKb2CDgS+YXWPrDsS0UDxKV?=
 =?us-ascii?Q?ia8t+p/rs55A5LDyNY9OJCjgPoSDxlzGUUaRIwpXWen5r3BTQ4w2L6wYfQWH?=
 =?us-ascii?Q?d3zW9jSXi38YQNIe+grklOm0DZYmRaPkHQ0zmL9TOQedHMo8WfciDsGoPabA?=
 =?us-ascii?Q?mJ1H0cF0du1zx9M6B5PmosvCTbU0r0nsDhz0RuRCLZHYmRZWaM0XejxlCS1z?=
 =?us-ascii?Q?5ZVUIP7VHqWLGKzN5rxkFHcMPiQfXz3ggmgzkIv9d6rl4qypYdw2XVBOgUct?=
 =?us-ascii?Q?Z8qkbjEqW7o+PtmyXexFzlNOdxG3RsDbkU1ScupzyQLRq5EtiSW3CxtDx59H?=
 =?us-ascii?Q?JyTtxn99dd043cOAThqyKVZoKbzDPXMP4hgFs+Hhu3eQ9rHLkVkwPAjcGB9e?=
 =?us-ascii?Q?AvS4035Q/8AVsGzSIpmVhDji7kxCwopNlEK102nYXck4HWhIUIf2LYyyAsMu?=
 =?us-ascii?Q?r+iVUVK7LWX+uTkh0wMzCt4MmihKj4nHhY0myeXA6uc5CtKf/3Vc2qluxk+h?=
 =?us-ascii?Q?JqFf3YJjjxau+RSv8pLmLNvStNK8us0xJa4LRfy/YW3iiYtDYnUflLzUMknq?=
 =?us-ascii?Q?MyzhI7oyr63e4KFb7rh5dESlsRyswmOMzucX30LRiym+ZriDuXZHxpLnOXr8?=
 =?us-ascii?Q?HD+Gu1WApQACZFvGd31/xDnVklcEqDvXUoJMmuUE0eq1w2SKbaUeYQy9u1I0?=
 =?us-ascii?Q?gJeR3wRBhC3fpCTRJbYA7rINS9rTrHVvdNH0dRzc7zwXx3pmQaLhmFfHNLyX?=
 =?us-ascii?Q?iqd9D/GKRHIc88fszOYncuimFT4TgM4fvv9jWLq0cqYuuC86oUmlmihxuI9c?=
 =?us-ascii?Q?tVffKbWTdaCOwpGqopmEOd/82cDgS+nAtVS3q4prwJdQ0/TQTzSSslkvh3eV?=
 =?us-ascii?Q?cwdiAY49PduAtry4BYFQWC5Hxt8GDJjQYxZawpztscAGJgvWWmFABZOSB3tm?=
 =?us-ascii?Q?fA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b938e039-6843-4709-4f2d-08db424c13e3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 09:37:52.4294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aJgOK3heeHGAYZqxW9vDqn2h9x3THhtea950ho14gzmgrdN7q5ur8dMb5Ed59UhLTEAGndHG038l2x4437vkbbQAuPvqhYf9bYO1XOXKZgI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6441
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 01:12:00PM +0200, Kal Cutter Conley wrote:

Hi there,

> > >> In addition, presumably when using this mode, the other XDP actions
> > >> (XDP_PASS, XDP_REDIRECT to other targets) would stop working unless we
> > >> add special handling for that in the kernel? We'll definitely need to
> > >> handle that somehow...
> > >
> > > I am not familiar with all the details here. Do you know a reason why
> > > these cases would stop working / why special handling would be needed?
> > > For example, if I have a UMEM that uses hugepages and XDP_PASS is
> > > returned, then the data is just copied into an SKB right? SKBs can
> > > also be created directly from hugepages AFAIK. So I don't understand
> > > what the issue would be. Can someone explain this concern?
> >
> > Well, I was asking :) It may well be that the SKB path just works; did
> > you test this? Pretty sure XDP_REDIRECT to another device won't, though?

for XDP_PASS we have to allocate a new buffer and copy the contents from
current xdp_buff that was backed by xsk_buff_pool and give the current one
back to pool. I am not sure if __napi_alloc_skb() is always capable of
handling len > PAGE_SIZE - i believe there might a particular combination
of settings that allows it, but if not we should have a fallback path that
would iterate over data and copy this to a certain (linear + frags) parts.
This implies non-zero effort that is needed for jumbo frames ZC support.

I can certainly test this out and play with it - maybe this just works, I
didn't check yet. Even if it does, then we need some kind of temporary
mechanism that will forbid loading ZC jumbo frames due to what Toke
brought up.

> >
> 
> I was also asking :-)
> 
> I tested that the SKB path is usable today with this patch.
> Specifically, sending and receiving large jumbo packets with AF_XDP
> and that a non-multi-buffer XDP program could access the whole packet.
> I have not specifically tested XDP_REDIRECT to another device or
> anything with ZC since that is not possible without driver support.
> 
> My feeling is, there wouldn't be non-trivial issues here since this
> patchset changes nothing except allowing the maximum chunk size to be
> larger. The driver either supports larger MTUs with XDP enabled or it
> doesn't. If it doesn't, the frames are dropped anyway. Also, chunk
> size mismatches between two XSKs (e.g. with XDP_REDIRECT) would be
> something supported or not supported irrespective of this patchset.

Here is the comparison between multi-buffer and jumbo frames that I did
for ZC ice driver. Configured MTU was 8192 as this is the frame size for
aligned mode when working with huge pages. I am presenting plain numbers
over here from xdpsock.

Mbuf, packet size = 8192 - XDP_PACKET_HEADROOM
885,705pps - rxdrop frame_size=4096
806,307pps - l2fwd frame_size=4096
877,989pps - rxdrop frame_size=2048
773,331pps - l2fwd frame_size=2048

Jumbo, packet size = 8192 - XDP_PACKET_HEADROOM
893,530pps - rxdrop frame_size=8192
841,860pps - l2fwd frame_size=8192

Kal might say that multi-buffer numbers are imaginary as these patches
were never shown to the public ;) but now that we have extensive test
suite I am fixing some last issues that stand out, so we are asking for
some more patience over here... overall i was expecting that they will be
much worse when compared to jumbo frames, but then again i believe this
implementation is not ideal and can be improved. Nevertheless, jumbo
frames support has its value.
