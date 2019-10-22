Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35C43E0C35
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 21:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732517AbfJVTGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 15:06:21 -0400
Received: from mga17.intel.com ([192.55.52.151]:58836 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730186AbfJVTGU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 15:06:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 12:06:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,217,1569308400"; 
   d="scan'208";a="196537830"
Received: from unknown (HELO [10.241.228.168]) ([10.241.228.168])
  by fmsmga008.fm.intel.com with ESMTP; 22 Oct 2019 12:06:19 -0700
Subject: Re: [Intel-wired-lan] FW: [PATCH bpf-next 2/4] xsk: allow AF_XDP
 sockets to receive packets directly from a queue
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Herbert, Tom" <tom.herbert@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
References: <1570515415-45593-3-git-send-email-sridhar.samudrala@intel.com>
 <CAADnVQ+XxmvY0cs8MYriMMd7=2TSEm4zCtB+fs2vkwdUY6UgAQ@mail.gmail.com>
 <3ED8E928C4210A4289A677D2FEB48235140134CE@fmsmsx111.amr.corp.intel.com>
 <2bc26acd-170d-634e-c066-71557b2b3e4f@intel.com>
 <CAADnVQ+qq6RLMjh5bB1ugXP5p7vYM2F1fLGFQ2pL=2vhCLiBdA@mail.gmail.com>
 <2032d58c-916f-d26a-db14-bd5ba6ad92b9@intel.com>
 <CAADnVQ+CH1YM52+LfybLS+NK16414Exrvk1QpYOF=HaT4KRaxg@mail.gmail.com>
 <acf69635-5868-f876-f7da-08954d1f690e@intel.com>
 <20191019001449.fk3gnhih4nx724pm@ast-mbp>
 <6f281517-3785-ce46-65de-e2f78576783b@intel.com>
 <20191019022525.w5xbwkav2cpqkfwi@ast-mbp> <877e4zd8py.fsf@toke.dk>
 <CAJ+HfNj07FwmU2GGpUYw56PRwu4pHyHNSkbCOogbMB5zB2QqWA@mail.gmail.com>
 <7642a460-9ba3-d9f7-6cf8-aac45c7eef0d@intel.com>
 <CAADnVQ+jiEO+jnFR-G=xG=zz7UOSBieZbc1NN=sSnAwvPaJjUQ@mail.gmail.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <8956a643-0163-5345-34fa-3566762a2b7d@intel.com>
Date:   Tue, 22 Oct 2019 12:06:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+jiEO+jnFR-G=xG=zz7UOSBieZbc1NN=sSnAwvPaJjUQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/2019 3:34 PM, Alexei Starovoitov wrote:
> On Mon, Oct 21, 2019 at 1:10 PM Samudrala, Sridhar
> <sridhar.samudrala@intel.com> wrote:
>>
>> On 10/20/2019 10:12 AM, Björn Töpel wrote:
>>> On Sun, 20 Oct 2019 at 12:15, Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>>>
>>>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>>>
>>>>> On Fri, Oct 18, 2019 at 05:45:26PM -0700, Samudrala, Sridhar wrote:
>>>>>> On 10/18/2019 5:14 PM, Alexei Starovoitov wrote:
>>>>>>> On Fri, Oct 18, 2019 at 11:40:07AM -0700, Samudrala, Sridhar wrote:
>>>>>>>>
>>>>>>>> Perf report for "AF_XDP default rxdrop" with patched kernel - mitigations ON
>>>>>>>> ==========================================================================
>>>>>>>> Samples: 44K of event 'cycles', Event count (approx.): 38532389541
>>>>>>>> Overhead  Command          Shared Object              Symbol
>>>>>>>>      15.31%  ksoftirqd/28     [i40e]                     [k] i40e_clean_rx_irq_zc
>>>>>>>>      10.50%  ksoftirqd/28     bpf_prog_80b55d8a76303785  [k] bpf_prog_80b55d8a76303785
>>>>>>>>       9.48%  xdpsock          [i40e]                     [k] i40e_clean_rx_irq_zc
>>>>>>>>       8.62%  xdpsock          xdpsock                    [.] main
>>>>>>>>       7.11%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_rcv
>>>>>>>>       5.81%  ksoftirqd/28     [kernel.vmlinux]           [k] xdp_do_redirect
>>>>>>>>       4.46%  xdpsock          bpf_prog_80b55d8a76303785  [k] bpf_prog_80b55d8a76303785
>>>>>>>>       3.83%  xdpsock          [kernel.vmlinux]           [k] xsk_rcv
>>>>>>>
>>>>>>> why everything is duplicated?
>>>>>>> Same code runs in different tasks ?
>>>>>>
>>>>>> Yes. looks like these functions run from both the app(xdpsock) context and ksoftirqd context.
>>>>>>
>>>>>>>
>>>>>>>>       2.81%  ksoftirqd/28     [kernel.vmlinux]           [k] bpf_xdp_redirect_map
>>>>>>>>       2.78%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_map_lookup_elem
>>>>>>>>       2.44%  xdpsock          [kernel.vmlinux]           [k] xdp_do_redirect
>>>>>>>>       2.19%  ksoftirqd/28     [kernel.vmlinux]           [k] __xsk_map_redirect
>>>>>>>>       1.62%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_umem_peek_addr
>>>>>>>>       1.57%  xdpsock          [kernel.vmlinux]           [k] xsk_umem_peek_addr
>>>>>>>>       1.32%  ksoftirqd/28     [kernel.vmlinux]           [k] dma_direct_sync_single_for_cpu
>>>>>>>>       1.28%  xdpsock          [kernel.vmlinux]           [k] bpf_xdp_redirect_map
>>>>>>>>       1.15%  xdpsock          [kernel.vmlinux]           [k] dma_direct_sync_single_for_device
>>>>>>>>       1.12%  xdpsock          [kernel.vmlinux]           [k] xsk_map_lookup_elem
>>>>>>>>       1.06%  xdpsock          [kernel.vmlinux]           [k] __xsk_map_redirect
>>>>>>>>       0.94%  ksoftirqd/28     [kernel.vmlinux]           [k] dma_direct_sync_single_for_device
>>>>>>>>       0.75%  ksoftirqd/28     [kernel.vmlinux]           [k] __x86_indirect_thunk_rax
>>>>>>>>       0.66%  ksoftirqd/28     [i40e]                     [k] i40e_clean_programming_status
>>>>>>>>       0.64%  ksoftirqd/28     [kernel.vmlinux]           [k] net_rx_action
>>>>>>>>       0.64%  swapper          [kernel.vmlinux]           [k] intel_idle
>>>>>>>>       0.62%  ksoftirqd/28     [i40e]                     [k] i40e_napi_poll
>>>>>>>>       0.57%  xdpsock          [kernel.vmlinux]           [k] dma_direct_sync_single_for_cpu
>>>>>>>>
>>>>>>>> Perf report for "AF_XDP direct rxdrop" with patched kernel - mitigations ON
>>>>>>>> ==========================================================================
>>>>>>>> Samples: 46K of event 'cycles', Event count (approx.): 38387018585
>>>>>>>> Overhead  Command          Shared Object             Symbol
>>>>>>>>      21.94%  ksoftirqd/28     [i40e]                    [k] i40e_clean_rx_irq_zc
>>>>>>>>      14.36%  xdpsock          xdpsock                   [.] main
>>>>>>>>      11.53%  ksoftirqd/28     [kernel.vmlinux]          [k] xsk_rcv
>>>>>>>>      11.32%  xdpsock          [i40e]                    [k] i40e_clean_rx_irq_zc
>>>>>>>>       4.02%  xdpsock          [kernel.vmlinux]          [k] xsk_rcv
>>>>>>>>       2.91%  ksoftirqd/28     [kernel.vmlinux]          [k] xdp_do_redirect
>>>>>>>>       2.45%  ksoftirqd/28     [kernel.vmlinux]          [k] xsk_umem_peek_addr
>>>>>>>>       2.19%  xdpsock          [kernel.vmlinux]          [k] xsk_umem_peek_addr
>>>>>>>>       2.08%  ksoftirqd/28     [kernel.vmlinux]          [k] bpf_direct_xsk
>>>>>>>>       2.07%  ksoftirqd/28     [kernel.vmlinux]          [k] dma_direct_sync_single_for_cpu
>>>>>>>>       1.53%  ksoftirqd/28     [kernel.vmlinux]          [k] dma_direct_sync_single_for_device
>>>>>>>>       1.39%  xdpsock          [kernel.vmlinux]          [k] dma_direct_sync_single_for_device
>>>>>>>>       1.22%  ksoftirqd/28     [kernel.vmlinux]          [k] xdp_get_xsk_from_qid
>>>>>>>>       1.12%  ksoftirqd/28     [i40e]                    [k] i40e_clean_programming_status
>>>>>>>>       0.96%  ksoftirqd/28     [i40e]                    [k] i40e_napi_poll
>>>>>>>>       0.95%  ksoftirqd/28     [kernel.vmlinux]          [k] net_rx_action
>>>>>>>>       0.89%  xdpsock          [kernel.vmlinux]          [k] xdp_do_redirect
>>>>>>>>       0.83%  swapper          [i40e]                    [k] i40e_clean_rx_irq_zc
>>>>>>>>       0.70%  swapper          [kernel.vmlinux]          [k] intel_idle
>>>>>>>>       0.66%  xdpsock          [kernel.vmlinux]          [k] dma_direct_sync_single_for_cpu
>>>>>>>>       0.60%  xdpsock          [kernel.vmlinux]          [k] bpf_direct_xsk
>>>>>>>>       0.50%  ksoftirqd/28     [kernel.vmlinux]          [k] xsk_umem_discard_addr
>>>>>>>>
>>>>>>>> Based on the perf reports comparing AF_XDP default and direct rxdrop, we can say that
>>>>>>>> AF_XDP direct rxdrop codepath is avoiding the overhead of going through these functions
>>>>>>>>    bpf_prog_xxx
>>>>>>>>            bpf_xdp_redirect_map
>>>>>>>>    xsk_map_lookup_elem
>>>>>>>>            __xsk_map_redirect
>>>>>>>> With AF_XDP direct, xsk_rcv() is directly called via bpf_direct_xsk() in xdp_do_redirect()
>>>>>>>
>>>>>>> I don't think you're identifying the overhead correctly.
>>>>>>> xsk_map_lookup_elem is 1%
>>>>>>> but bpf_xdp_redirect_map() suppose to call __xsk_map_lookup_elem()
>>>>>>> which is a different function:
>>>>>>> ffffffff81493fe0 T __xsk_map_lookup_elem
>>>>>>> ffffffff81492e80 t xsk_map_lookup_elem
>>>>>>>
>>>>>>> 10% for bpf_prog_80b55d8a76303785 is huge.
>>>>>>> It's the actual code of the program _without_ any helpers.
>>>>>>> How does the program actually look?
>>>>>>
>>>>>> It is the xdp program that is loaded via xsk_load_xdp_prog() in tools/lib/bpf/xsk.c
>>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/lib/bpf/xsk.c#n268
>>>>>
>>>>> I see. Looks like map_gen_lookup was never implemented for xskmap.
>>>>> How about adding it first the way array_map_gen_lookup() is implemented?
>>>>> This will easily give 2x perf gain.
>>>>
>>>> I guess we should implement this for devmaps as well now that we allow
>>>> lookups into those.
>>>>
>>>> However, in this particular example, the lookup from BPF is not actually
>>>> needed, since bpf_redirect_map() will return a configurable error value
>>>> when the map lookup fails (for exactly this use case).
>>>>
>>>> So replacing:
>>>>
>>>> if (bpf_map_lookup_elem(&xsks_map, &index))
>>>>       return bpf_redirect_map(&xsks_map, index, 0);
>>>>
>>>> with simply
>>>>
>>>> return bpf_redirect_map(&xsks_map, index, XDP_PASS);
>>>>
>>>> would save the call to xsk_map_lookup_elem().
>>>>
>>>
>>> Thanks for the reminder! I just submitted a patch. Still, doing the
>>> map_gen_lookup()  for xsk/devmaps still makes sense!
>>>
>>
>> I tried Bjorn's patch that avoids the lookups in the BPF prog.
>> https://lore.kernel.org/netdev/20191021105938.11820-1-bjorn.topel@gmail.com/
>>
>> With this patch I am also seeing around 3-4% increase in xdpsock rxdrop performance and
>> the perf report looks like this.
>>
>> Samples: 44K of event 'cycles', Event count (approx.): 38749965204
>> Overhead  Command          Shared Object              Symbol
>>     16.06%  ksoftirqd/28     [i40e]                     [k] i40e_clean_rx_irq_zc
>>     10.18%  ksoftirqd/28     bpf_prog_3c8251c7e0fef8db  [k] bpf_prog_3c8251c7e0fef8db
>>     10.15%  xdpsock          [i40e]                     [k] i40e_clean_rx_irq_zc
>>     10.06%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_rcv
>>      7.45%  xdpsock          xdpsock                    [.] main
>>      5.76%  ksoftirqd/28     [kernel.vmlinux]           [k] xdp_do_redirect
>>      4.51%  xdpsock          bpf_prog_3c8251c7e0fef8db  [k] bpf_prog_3c8251c7e0fef8db
>>      3.67%  xdpsock          [kernel.vmlinux]           [k] xsk_rcv
>>      3.06%  ksoftirqd/28     [kernel.vmlinux]           [k] bpf_xdp_redirect_map
>>      2.34%  ksoftirqd/28     [kernel.vmlinux]           [k] __xsk_map_redirect
>>      2.33%  xdpsock          [kernel.vmlinux]           [k] xdp_do_redirect
>>      1.69%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_umem_peek_addr
>>      1.69%  xdpsock          [kernel.vmlinux]           [k] xsk_umem_peek_addr
>>      1.42%  ksoftirqd/28     [kernel.vmlinux]           [k] dma_direct_sync_single_for_cpu
>>      1.19%  xdpsock          [kernel.vmlinux]           [k] bpf_xdp_redirect_map
>>      1.13%  xdpsock          [kernel.vmlinux]           [k] dma_direct_sync_single_for_device
>>      0.95%  ksoftirqd/28     [kernel.vmlinux]           [k] dma_direct_sync_single_for_device
>>      0.92%  swapper          [kernel.vmlinux]           [k] intel_idle
>>      0.92%  xdpsock          [kernel.vmlinux]           [k] __xsk_map_redirect
>>      0.80%  ksoftirqd/28     [kernel.vmlinux]           [k] __x86_indirect_thunk_rax
>>      0.73%  ksoftirqd/28     [i40e]                     [k] i40e_clean_programming_status
>>      0.71%  ksoftirqd/28     [kernel.vmlinux]           [k] __xsk_map_lookup_elem
>>      0.63%  ksoftirqd/28     [kernel.vmlinux]           [k] net_rx_action
>>      0.62%  ksoftirqd/28     [i40e]                     [k] i40e_napi_poll
>>      0.58%  xdpsock          [kernel.vmlinux]           [k] dma_direct_sync_single_for_cpu
>>
>> So with this patch applied, direct receive performance improvement comes down from 46% to 42%.
>> I think it is still substantial enough to provide an option to allow direct receive for
>> certain use cases. If it is OK, i can re-spin and submit the patches on top of the latest bpf-next
> 
> I think it's too early to consider such drastic approach.
> The run-time performance of XDP program should be the same as C code.
> Something fishy in these numbers, since spending 10% cpu in few loads
> and single call to bpf_xdp_redirect_map() just not right.

OK. Here is another data point that shows the perf report with the same test but CPU mitigations
turned OFF. Here bpf_prog overhead goes down from almost (10.18 + 4.51)% to (3.23 + 1.44%).

   21.40%  ksoftirqd/28     [i40e]                     [k] i40e_clean_rx_irq_zc
   14.13%  xdpsock          [i40e]                     [k] i40e_clean_rx_irq_zc
    8.33%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_rcv
    6.09%  ksoftirqd/28     [kernel.vmlinux]           [k] xdp_do_redirect
    5.19%  xdpsock          xdpsock                    [.] main
    3.48%  ksoftirqd/28     [kernel.vmlinux]           [k] bpf_xdp_redirect_map
    3.23%  ksoftirqd/28     bpf_prog_3c8251c7e0fef8db  [k] bpf_prog_3c8251c7e0fef8db
    3.06%  ksoftirqd/28     [kernel.vmlinux]           [k] __xsk_map_redirect
    2.72%  xdpsock          [kernel.vmlinux]           [k] xdp_do_redirect
    2.27%  xdpsock          [kernel.vmlinux]           [k] xsk_rcv
    2.10%  xdpsock          [kernel.vmlinux]           [k] xsk_umem_peek_addr
    2.09%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_umem_peek_addr
    1.89%  ksoftirqd/28     [kernel.vmlinux]           [k] dma_direct_sync_single_for_cpu
    1.44%  xdpsock          bpf_prog_3c8251c7e0fef8db  [k] bpf_prog_3c8251c7e0fef8db
    1.36%  xdpsock          [kernel.vmlinux]           [k] bpf_xdp_redirect_map
    1.31%  ksoftirqd/28     [kernel.vmlinux]           [k] dma_direct_sync_single_for_device
    1.30%  xdpsock          [kernel.vmlinux]           [k] __xsk_map_redirect
    1.23%  xdpsock          [kernel.vmlinux]           [k] dma_direct_sync_single_for_device
    0.97%  ksoftirqd/28     [kernel.vmlinux]           [k] __xsk_map_lookup_elem
    0.90%  ksoftirqd/28     [i40e]                     [k] i40e_clean_programming_status
    0.81%  xdpsock          [kernel.vmlinux]           [k] dma_direct_sync_single_for_cpu
    0.76%  swapper          [i40e]                     [k] i40e_clean_rx_irq_zc
    0.75%  swapper          [kernel.vmlinux]           [k] intel_idle
    0.59%  ksoftirqd/28     [kernel.vmlinux]           [k] net_rx_action

So a major component of the bpf_prog overhead seems to be due to the CPU vulnerability mitigations.
The other component is the bpf_xdp_redirect_map() codepath.

Let me know if it helps to collect any other data that should further help with the perf analysis.

