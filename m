Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91EB854A32D
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 02:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbiFNAmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 20:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbiFNAmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 20:42:39 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63B92AC8;
        Mon, 13 Jun 2022 17:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655167358; x=1686703358;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=MVvW267+1CxI3DhRHiOaVGAbL4b2sj8gVPrDDaf1aCo=;
  b=l67e/hQ6aOQVEtcWCRAY5BPnYAwFLLCurulHnkMMkXkEbKP8wfDzq8Uz
   jE5IWk0YPXfT89XY51cy2P2GsPfh2FbpViGDEkDqa8lu2yOc3dAbbfkcu
   CzPx9bVtoJOv64jdDGybifZH4Fes5zATL1iai4/JTJUxf94jCFgZaOB8M
   qwVeLIBh3E4j6cpwwekOBhBJHn08wDmQeqPgsAfs4fePa3gosCNgy2h1r
   Was8IEglT4l2EpvjyaGN8ykFOBBcy9z17w04y67Ds5YSiF15XM/BY8Jdg
   jJslHxeQlWURauIoCNNOb8Y6OE93CW+IrkkEWWrIawh9CtHxNixixv1VS
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="258288039"
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="258288039"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 17:42:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="588110886"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.138])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jun 2022 17:42:35 -0700
Date:   Tue, 14 Jun 2022 08:42:34 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Willy Tarreau <w@1wt.eu>, Moshe Kol <moshe.kol@mail.huji.ac.il>,
        fengwei.yin@intel.com, kernel test robot <oliver.sang@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, lkp@lists.01.org,
        kbuild test robot <lkp@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>, zhengjun.xing@linux.intel.com
Subject: Re: [tcp] e926147618: stress-ng.icmp-flood.ops_per_sec -8.7%
 regression
Message-ID: <20220614004234.GA51079@shbuild999.sh.intel.com>
References: <20220608060802.GA22428@xsang-OptiPlex-9020>
 <20220608064822.GC7547@1wt.eu>
 <CACi_AuAr70bDB79zg9aAF1rD7e1qGgFwCGCAPYtS-zCp_zA0iw@mail.gmail.com>
 <20220608073441.GE7547@1wt.eu>
 <20220613020943.GD75244@shbuild999.sh.intel.com>
 <CANn89i+9Vq7Kiusp1jJBLgGMprb=psrVaWwz5u4F3dunw2vR3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89i+9Vq7Kiusp1jJBLgGMprb=psrVaWwz5u4F3dunw2vR3Q@mail.gmail.com>
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 13, 2022 at 10:10:57AM -0700, Eric Dumazet wrote:
> On Sun, Jun 12, 2022 at 7:09 PM Feng Tang <feng.tang@intel.com> wrote:
> >
> > Hi,
> >
> > On Wed, Jun 08, 2022 at 09:34:41AM +0200, Willy Tarreau wrote:
> > > On Wed, Jun 08, 2022 at 10:26:12AM +0300, Moshe Kol wrote:
> > > > Hmm, How is the ICMP flood stress test related to TCP connections?
> > >
> > > To me it's not directly related, unless the test pre-establishes many
> > > connections, or is affected in a way or another by a larger memory
> > > allocation of this part.
> >
> > Fengwei and I discussed and thought this could be a data alignment
> > related case, that one module's data alignment change affects other
> > modules' alignment, and we had a patch for detecting similar cases [1]
> >
> > After some debugging, this could be related with the bss section
> > alignment changes, that if we forced all module's bss section to be
> > 4KB aligned, then the stress-ng icmp-flood case will have almost no
> > performance difference for the 2 commits:
> >
> > 10025135            +0.8%   10105711 ±  2%  stress-ng.icmp-flood.ops_per_sec
> >
> > The debug patch is:
> >
> > diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> > index 7fda7f27e7620..7eb626b98620c 100644
> > --- a/arch/x86/kernel/vmlinux.lds.S
> > +++ b/arch/x86/kernel/vmlinux.lds.S
> > @@ -378,7 +378,9 @@ SECTIONS
> >
> >         /* BSS */
> >         . = ALIGN(PAGE_SIZE);
> > -       .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
> > +       .bss : AT(ADDR(.bss) - LOAD_OFFSET)
> > +       SUBALIGN(PAGE_SIZE)
> > +       {
> >                 __bss_start = .;
> >                 *(.bss..page_aligned)
> >                 . = ALIGN(PAGE_SIZE);
> >
> > The 'table_perturb[]' used to be in bss section, and with the commit
> > of moving it to runtime allocation, other data structures following it
> > in the .bss section will get affected accordingly.
> >
> 
> As the 'regression' is seen with ICMP workload, can you please share with us
> the symbols close to icmp_global (without your align patch)

Here are the info for the 2 commits (kernels for the original reprot):

$ egrep -8 "icmp_global$" System.map-5.18.0-rc4-00242-gca7af0402550
ffffffff837adc00 b tcp_cong_list_lock
ffffffff837adc08 b tcpmhash_entries
ffffffff837adc10 b fastopen_seqlock
ffffffff837adc18 b tcp_metrics_lock
ffffffff837adc1c b tcp_ulp_list_lock
ffffffff837adc20 B raw_v4_hashinfo
ffffffff837ae440 B udp_encap_needed_key
ffffffff837ae480 B udp_memory_allocated
ffffffff837ae488 b icmp_global
ffffffff837ae4a0 b inet_addr_lst
ffffffff837aeca0 b inetsw_lock
ffffffff837aecc0 b inetsw
ffffffff837aed80 b fib_info_devhash
ffffffff837af580 b fib_info_cnt
ffffffff837af584 b fib_info_hash_bits
ffffffff837af588 b fib_info_hash_size
ffffffff837af590 b fib_info_laddrhash

$ egrep -8 "icmp_global$" System.map-5.18.0-rc4-00243-ge9261476184b
ffffffff837ad800 b tcp_cong_list_lock
ffffffff837ad808 b tcpmhash_entries
ffffffff837ad810 b fastopen_seqlock
ffffffff837ad818 b tcp_metrics_lock
ffffffff837ad81c b tcp_ulp_list_lock
ffffffff837ad820 B raw_v4_hashinfo
ffffffff837ae040 B udp_encap_needed_key
ffffffff837ae080 B udp_memory_allocated
ffffffff837ae088 b icmp_global
ffffffff837ae0a0 b inet_addr_lst
ffffffff837ae8a0 b inetsw_lock
ffffffff837ae8c0 b inetsw
ffffffff837ae980 b fib_info_devhash
ffffffff837af180 b fib_info_cnt
ffffffff837af184 b fib_info_hash_bits
ffffffff837af188 b fib_info_hash_size
ffffffff837af190 b fib_info_laddrhash

From above we can see some symbols are offseted of 0x400 (1KB),
like icmp_global or fib_xxx, as the 'table_perturb' used to be
1KB long in bss section.

> I suspect we should move icmp_global to a dedicated cache line.
> 
> $ nm -v vmlinux|egrep -8 "icmp_global$"
> ffffffff835bc490 b tcp_cong_list_lock
> ffffffff835bc494 b fastopen_seqlock
> ffffffff835bc49c b tcp_metrics_lock
> ffffffff835bc4a0 b tcpmhash_entries
> ffffffff835bc4a4 b tcp_ulp_list_lock
> ffffffff835bc4a8 B raw_v4_hashinfo
> ffffffff835bccc0 B udp_memory_allocated      << Note sure why it is
> not already in a dedicated cache line>>

IIUC, 0x....C0 means it is already cacheline aligned?


> ffffffff835bccc8 B udp_encap_needed_key
> ffffffff835bccd8 b icmp_global                               <<<HERE>>
> ffffffff835bccf0 b inet_addr_lst
> ffffffff835bd4f0 b inetsw_lock
> ffffffff835bd500 b inetsw
> ffffffff835bd5b0 b fib_info_lock
> ffffffff835bd5b4 b fib_info_cnt
> ffffffff835bd5b8 b fib_info_hash_size
> ffffffff835bd5c0 b fib_info_hash
> ffffffff835bd5c8 b fib_info_laddrhash

Fengwei found that from the perf-profile info of report, there are
quite difference around ping table handling.

     43.72            +4.1       47.81 ±  2% icmp_rcv.ip_protocol_deliver_rcu.ip_local_deliver_finish.__netif_receive_skb_one_core.process_backlog
     17.10 ±  7%      +6.0       23.10 ±  6%ping_rcv.icmp_rcv.ip_protocol_deliver_rcu.ip_local_deliver_finish.__netif_receive_skb_one_core
     17.05 ±  7%      +6.0       23.06 ±  6%ping_lookup.ping_rcv.icmp_rcv.ip_protocol_deliver_rcu.ip_local_deliver_finish

And the "ping_table[]" also sits in bss section and got affected:

  Before: 
  ffffffff837af600 b ping_table

  After:
  ffffffff837af200 b ping_table

The cacheline alignment is not changed, and I suspect it cause some
TLB changes.

Thanks,
Feng
