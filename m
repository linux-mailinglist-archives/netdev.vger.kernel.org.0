Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 718A8DD5B4
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 02:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404099AbfJSAO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 20:14:57 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45086 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728453AbfJSAO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 20:14:56 -0400
Received: by mail-pf1-f195.google.com with SMTP id y72so4794235pfb.12;
        Fri, 18 Oct 2019 17:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2p0wvcmy8kPh5h8Q4FHfhvyG+WG0R8zknv0uy5+Q2r8=;
        b=ldTrboT/pTXBFXpp1ihZqV1gJl0NM4BFvcLhy07GTaRLieiACpvUJDQxIvLCTCnHz9
         FLiEXBh8SKxCs17NK1AZm+95rfYJjh9yUGTfwHhvy9/Fz9GtsiDjdSJLgE8514BjXKto
         GunwN62rCDi9XmW6B5a5DtKvh4TabE8KRi4neX0yKriklvvEriqehTQN/wpA5w2RVDQ+
         HSSXa5IOTxJWtaoKeE802g6ZNFCL+W61/ienz0mC8LDuPt1ONkYttXMoC9ubamo3y1Dm
         cvljG+yjZkiiXhwpQMkcx8BE2mtBm0UbEzV7N2bN3QApQdK9fjsngG/p1Ue9vEmPJldQ
         fmgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2p0wvcmy8kPh5h8Q4FHfhvyG+WG0R8zknv0uy5+Q2r8=;
        b=M+YJycgIoBrRHtsf7ybQNduxAk5TdcpEc1eHC0DqPi+hVJb0b6Hx6sMWSxc57niuQe
         sB/AhPalh1HSdvGgIogiVWRnE4xlIvfHg3MNk6qomcrNdC7WEmdgDYs0Zr/RWNF7yLx5
         I86e4fzG9wewxPTrMT8G0TvwihrKPODD6LXtf6scwR7nyDrlsPy/PDWc5oyTnH+d80JH
         6Vno1wYn7tK3BoM/piZFL3lsbEfrmiOZh+L8Acd2O2MXRnwOZCrMFPW3cGv/q1lZV5iX
         TM3Jz/lJvtZyKGJIug7J3IsGsRKYFWs7iWQdP9z3tfc0fjNU+Qb6p2nC33d/jHH/RZYr
         LtWg==
X-Gm-Message-State: APjAAAWVnm4hXp7xjNed2oe+soVtxRrP9OegjjTo50+XYaImSIRzTcM/
        CUus3o3it7Y9R62bNhvsQ+rikui1
X-Google-Smtp-Source: APXvYqyP/tO+DnGtqdFz3JMfzJ86denwfNQF8BBxtUpp1ADePXxfLuSCv+kPlD8NjS11vD3oc9ZhyQ==
X-Received: by 2002:a63:1b41:: with SMTP id b1mr12987185pgm.335.1571444094225;
        Fri, 18 Oct 2019 17:14:54 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:180::6038])
        by smtp.gmail.com with ESMTPSA id l22sm6484749pgj.4.2019.10.18.17.14.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 17:14:53 -0700 (PDT)
Date:   Fri, 18 Oct 2019 17:14:51 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Herbert, Tom" <tom.herbert@intel.com>
Subject: Re: FW: [PATCH bpf-next 2/4] xsk: allow AF_XDP sockets to receive
 packets directly from a queue
Message-ID: <20191019001449.fk3gnhih4nx724pm@ast-mbp>
References: <1570515415-45593-1-git-send-email-sridhar.samudrala@intel.com>
 <1570515415-45593-3-git-send-email-sridhar.samudrala@intel.com>
 <CAADnVQ+XxmvY0cs8MYriMMd7=2TSEm4zCtB+fs2vkwdUY6UgAQ@mail.gmail.com>
 <3ED8E928C4210A4289A677D2FEB48235140134CE@fmsmsx111.amr.corp.intel.com>
 <2bc26acd-170d-634e-c066-71557b2b3e4f@intel.com>
 <CAADnVQ+qq6RLMjh5bB1ugXP5p7vYM2F1fLGFQ2pL=2vhCLiBdA@mail.gmail.com>
 <2032d58c-916f-d26a-db14-bd5ba6ad92b9@intel.com>
 <CAADnVQ+CH1YM52+LfybLS+NK16414Exrvk1QpYOF=HaT4KRaxg@mail.gmail.com>
 <acf69635-5868-f876-f7da-08954d1f690e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acf69635-5868-f876-f7da-08954d1f690e@intel.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 11:40:07AM -0700, Samudrala, Sridhar wrote:
> 
> Perf report for "AF_XDP default rxdrop" with patched kernel - mitigations ON
> ==========================================================================
> Samples: 44K of event 'cycles', Event count (approx.): 38532389541
> Overhead  Command          Shared Object              Symbol
>   15.31%  ksoftirqd/28     [i40e]                     [k] i40e_clean_rx_irq_zc
>   10.50%  ksoftirqd/28     bpf_prog_80b55d8a76303785  [k] bpf_prog_80b55d8a76303785
>    9.48%  xdpsock          [i40e]                     [k] i40e_clean_rx_irq_zc
>    8.62%  xdpsock          xdpsock                    [.] main
>    7.11%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_rcv
>    5.81%  ksoftirqd/28     [kernel.vmlinux]           [k] xdp_do_redirect
>    4.46%  xdpsock          bpf_prog_80b55d8a76303785  [k] bpf_prog_80b55d8a76303785
>    3.83%  xdpsock          [kernel.vmlinux]           [k] xsk_rcv

why everything is duplicated?
Same code runs in different tasks ?

>    2.81%  ksoftirqd/28     [kernel.vmlinux]           [k] bpf_xdp_redirect_map
>    2.78%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_map_lookup_elem
>    2.44%  xdpsock          [kernel.vmlinux]           [k] xdp_do_redirect
>    2.19%  ksoftirqd/28     [kernel.vmlinux]           [k] __xsk_map_redirect
>    1.62%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_umem_peek_addr
>    1.57%  xdpsock          [kernel.vmlinux]           [k] xsk_umem_peek_addr
>    1.32%  ksoftirqd/28     [kernel.vmlinux]           [k] dma_direct_sync_single_for_cpu
>    1.28%  xdpsock          [kernel.vmlinux]           [k] bpf_xdp_redirect_map
>    1.15%  xdpsock          [kernel.vmlinux]           [k] dma_direct_sync_single_for_device
>    1.12%  xdpsock          [kernel.vmlinux]           [k] xsk_map_lookup_elem
>    1.06%  xdpsock          [kernel.vmlinux]           [k] __xsk_map_redirect
>    0.94%  ksoftirqd/28     [kernel.vmlinux]           [k] dma_direct_sync_single_for_device
>    0.75%  ksoftirqd/28     [kernel.vmlinux]           [k] __x86_indirect_thunk_rax
>    0.66%  ksoftirqd/28     [i40e]                     [k] i40e_clean_programming_status
>    0.64%  ksoftirqd/28     [kernel.vmlinux]           [k] net_rx_action
>    0.64%  swapper          [kernel.vmlinux]           [k] intel_idle
>    0.62%  ksoftirqd/28     [i40e]                     [k] i40e_napi_poll
>    0.57%  xdpsock          [kernel.vmlinux]           [k] dma_direct_sync_single_for_cpu
> 
> Perf report for "AF_XDP direct rxdrop" with patched kernel - mitigations ON
> ==========================================================================
> Samples: 46K of event 'cycles', Event count (approx.): 38387018585
> Overhead  Command          Shared Object             Symbol
>   21.94%  ksoftirqd/28     [i40e]                    [k] i40e_clean_rx_irq_zc
>   14.36%  xdpsock          xdpsock                   [.] main
>   11.53%  ksoftirqd/28     [kernel.vmlinux]          [k] xsk_rcv
>   11.32%  xdpsock          [i40e]                    [k] i40e_clean_rx_irq_zc
>    4.02%  xdpsock          [kernel.vmlinux]          [k] xsk_rcv
>    2.91%  ksoftirqd/28     [kernel.vmlinux]          [k] xdp_do_redirect
>    2.45%  ksoftirqd/28     [kernel.vmlinux]          [k] xsk_umem_peek_addr
>    2.19%  xdpsock          [kernel.vmlinux]          [k] xsk_umem_peek_addr
>    2.08%  ksoftirqd/28     [kernel.vmlinux]          [k] bpf_direct_xsk
>    2.07%  ksoftirqd/28     [kernel.vmlinux]          [k] dma_direct_sync_single_for_cpu
>    1.53%  ksoftirqd/28     [kernel.vmlinux]          [k] dma_direct_sync_single_for_device
>    1.39%  xdpsock          [kernel.vmlinux]          [k] dma_direct_sync_single_for_device
>    1.22%  ksoftirqd/28     [kernel.vmlinux]          [k] xdp_get_xsk_from_qid
>    1.12%  ksoftirqd/28     [i40e]                    [k] i40e_clean_programming_status
>    0.96%  ksoftirqd/28     [i40e]                    [k] i40e_napi_poll
>    0.95%  ksoftirqd/28     [kernel.vmlinux]          [k] net_rx_action
>    0.89%  xdpsock          [kernel.vmlinux]          [k] xdp_do_redirect
>    0.83%  swapper          [i40e]                    [k] i40e_clean_rx_irq_zc
>    0.70%  swapper          [kernel.vmlinux]          [k] intel_idle
>    0.66%  xdpsock          [kernel.vmlinux]          [k] dma_direct_sync_single_for_cpu
>    0.60%  xdpsock          [kernel.vmlinux]          [k] bpf_direct_xsk
>    0.50%  ksoftirqd/28     [kernel.vmlinux]          [k] xsk_umem_discard_addr
> 
> Based on the perf reports comparing AF_XDP default and direct rxdrop, we can say that
> AF_XDP direct rxdrop codepath is avoiding the overhead of going through these functions
> 	bpf_prog_xxx
>         bpf_xdp_redirect_map
> 	xsk_map_lookup_elem
>         __xsk_map_redirect
> With AF_XDP direct, xsk_rcv() is directly called via bpf_direct_xsk() in xdp_do_redirect()

I don't think you're identifying the overhead correctly.
xsk_map_lookup_elem is 1%
but bpf_xdp_redirect_map() suppose to call __xsk_map_lookup_elem()
which is a different function:
ffffffff81493fe0 T __xsk_map_lookup_elem
ffffffff81492e80 t xsk_map_lookup_elem

10% for bpf_prog_80b55d8a76303785 is huge.
It's the actual code of the program _without_ any helpers.
How does the program actually look?

