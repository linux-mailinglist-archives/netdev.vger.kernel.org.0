Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 589E7DD62D
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 04:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfJSCZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 22:25:32 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41061 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfJSCZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 22:25:31 -0400
Received: by mail-pl1-f196.google.com with SMTP id t10so3704122plr.8;
        Fri, 18 Oct 2019 19:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pSjFlThG+9eji70eoDwhHSYbzwOeRqvhhwPaCLJ8OT8=;
        b=spKzl0o37sdvis0PVp7oGbG5QStNow7CDKSy4RTHOoDVEBilUb4Eai2lfJ9VZ1T8GQ
         UaCguJKVBzqv4HRmMYkQr+CAvIUglhV/ZjeHJchaoRgsunkg9HryfkzS8F6egRqvtyI9
         7c7UubIMBFd1g41pPFgVZvb7Sw0oGTpJIP6NaCXjIgGNOq8bmtpiS5My5h25W7uOy78P
         bwEqc2bqhASrQPXCOWW91se/wUCP1rFcJiv0B8aAar9XfKHgfW25VCn6SGBywHN06Bq4
         t42kjKgh9yvr9zQuiL26EBOJ5JdwBfuK17P+flVSda80w3rlP3nHtOWBNxHg/oI8GraU
         AqtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pSjFlThG+9eji70eoDwhHSYbzwOeRqvhhwPaCLJ8OT8=;
        b=HgVrPwsjLiGlQeYP4xyCz4snW3sNsaQRPsPnu8teNcOvMfDtY44m2+OyHxBj+JIlTO
         exyXbazy+38Fr+DhOp5CogmUvHTR9U0QbpZSoVkP2Rebhko/wNk3xdjzmT+vLN4quC3r
         qo3Hw6wUBIJaU4RgwJgI2yajfgJSyeQrLRNK7RAXHidWRkVvLYXPCi/wcwqnJaK/jVmX
         fFVAqBcokqkV0v1QNrjhnFYbCUKmWV/ZnsPafO/r7YNJEpX3tQzwoTQEdvsAm7bOY2Iw
         9g1H2+ozK7yjRYbxS0GXR1F//MttE9D1Gj6rqJUZH1BK7ktEW4S/2IxRvMG83tty/4PN
         rIkA==
X-Gm-Message-State: APjAAAVn+5S7chvQjctD3Ipr8H/3dibXaVKOGj0lJAKH1XzZDKTHDo7J
        2UsuErcnBHhfDaRmXls8rsRMTr9S
X-Google-Smtp-Source: APXvYqzB+eqxlDw+kW0HaGgvXZD49GJDLzcEgMX+BE5wOjM4JjOLm/8LCPF0tYRP+mmkavAhYaQEXg==
X-Received: by 2002:a17:902:6acb:: with SMTP id i11mr12542551plt.273.1571451930480;
        Fri, 18 Oct 2019 19:25:30 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:180::6038])
        by smtp.gmail.com with ESMTPSA id k17sm8253109pgh.30.2019.10.18.19.25.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 19:25:29 -0700 (PDT)
Date:   Fri, 18 Oct 2019 19:25:27 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Herbert, Tom" <tom.herbert@intel.com>
Subject: Re: FW: [PATCH bpf-next 2/4] xsk: allow AF_XDP sockets to receive
 packets directly from a queue
Message-ID: <20191019022525.w5xbwkav2cpqkfwi@ast-mbp>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f281517-3785-ce46-65de-e2f78576783b@intel.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 05:45:26PM -0700, Samudrala, Sridhar wrote:
> On 10/18/2019 5:14 PM, Alexei Starovoitov wrote:
> > On Fri, Oct 18, 2019 at 11:40:07AM -0700, Samudrala, Sridhar wrote:
> > > 
> > > Perf report for "AF_XDP default rxdrop" with patched kernel - mitigations ON
> > > ==========================================================================
> > > Samples: 44K of event 'cycles', Event count (approx.): 38532389541
> > > Overhead  Command          Shared Object              Symbol
> > >    15.31%  ksoftirqd/28     [i40e]                     [k] i40e_clean_rx_irq_zc
> > >    10.50%  ksoftirqd/28     bpf_prog_80b55d8a76303785  [k] bpf_prog_80b55d8a76303785
> > >     9.48%  xdpsock          [i40e]                     [k] i40e_clean_rx_irq_zc
> > >     8.62%  xdpsock          xdpsock                    [.] main
> > >     7.11%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_rcv
> > >     5.81%  ksoftirqd/28     [kernel.vmlinux]           [k] xdp_do_redirect
> > >     4.46%  xdpsock          bpf_prog_80b55d8a76303785  [k] bpf_prog_80b55d8a76303785
> > >     3.83%  xdpsock          [kernel.vmlinux]           [k] xsk_rcv
> > 
> > why everything is duplicated?
> > Same code runs in different tasks ?
> 
> Yes. looks like these functions run from both the app(xdpsock) context and ksoftirqd context.
> 
> > 
> > >     2.81%  ksoftirqd/28     [kernel.vmlinux]           [k] bpf_xdp_redirect_map
> > >     2.78%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_map_lookup_elem
> > >     2.44%  xdpsock          [kernel.vmlinux]           [k] xdp_do_redirect
> > >     2.19%  ksoftirqd/28     [kernel.vmlinux]           [k] __xsk_map_redirect
> > >     1.62%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_umem_peek_addr
> > >     1.57%  xdpsock          [kernel.vmlinux]           [k] xsk_umem_peek_addr
> > >     1.32%  ksoftirqd/28     [kernel.vmlinux]           [k] dma_direct_sync_single_for_cpu
> > >     1.28%  xdpsock          [kernel.vmlinux]           [k] bpf_xdp_redirect_map
> > >     1.15%  xdpsock          [kernel.vmlinux]           [k] dma_direct_sync_single_for_device
> > >     1.12%  xdpsock          [kernel.vmlinux]           [k] xsk_map_lookup_elem
> > >     1.06%  xdpsock          [kernel.vmlinux]           [k] __xsk_map_redirect
> > >     0.94%  ksoftirqd/28     [kernel.vmlinux]           [k] dma_direct_sync_single_for_device
> > >     0.75%  ksoftirqd/28     [kernel.vmlinux]           [k] __x86_indirect_thunk_rax
> > >     0.66%  ksoftirqd/28     [i40e]                     [k] i40e_clean_programming_status
> > >     0.64%  ksoftirqd/28     [kernel.vmlinux]           [k] net_rx_action
> > >     0.64%  swapper          [kernel.vmlinux]           [k] intel_idle
> > >     0.62%  ksoftirqd/28     [i40e]                     [k] i40e_napi_poll
> > >     0.57%  xdpsock          [kernel.vmlinux]           [k] dma_direct_sync_single_for_cpu
> > > 
> > > Perf report for "AF_XDP direct rxdrop" with patched kernel - mitigations ON
> > > ==========================================================================
> > > Samples: 46K of event 'cycles', Event count (approx.): 38387018585
> > > Overhead  Command          Shared Object             Symbol
> > >    21.94%  ksoftirqd/28     [i40e]                    [k] i40e_clean_rx_irq_zc
> > >    14.36%  xdpsock          xdpsock                   [.] main
> > >    11.53%  ksoftirqd/28     [kernel.vmlinux]          [k] xsk_rcv
> > >    11.32%  xdpsock          [i40e]                    [k] i40e_clean_rx_irq_zc
> > >     4.02%  xdpsock          [kernel.vmlinux]          [k] xsk_rcv
> > >     2.91%  ksoftirqd/28     [kernel.vmlinux]          [k] xdp_do_redirect
> > >     2.45%  ksoftirqd/28     [kernel.vmlinux]          [k] xsk_umem_peek_addr
> > >     2.19%  xdpsock          [kernel.vmlinux]          [k] xsk_umem_peek_addr
> > >     2.08%  ksoftirqd/28     [kernel.vmlinux]          [k] bpf_direct_xsk
> > >     2.07%  ksoftirqd/28     [kernel.vmlinux]          [k] dma_direct_sync_single_for_cpu
> > >     1.53%  ksoftirqd/28     [kernel.vmlinux]          [k] dma_direct_sync_single_for_device
> > >     1.39%  xdpsock          [kernel.vmlinux]          [k] dma_direct_sync_single_for_device
> > >     1.22%  ksoftirqd/28     [kernel.vmlinux]          [k] xdp_get_xsk_from_qid
> > >     1.12%  ksoftirqd/28     [i40e]                    [k] i40e_clean_programming_status
> > >     0.96%  ksoftirqd/28     [i40e]                    [k] i40e_napi_poll
> > >     0.95%  ksoftirqd/28     [kernel.vmlinux]          [k] net_rx_action
> > >     0.89%  xdpsock          [kernel.vmlinux]          [k] xdp_do_redirect
> > >     0.83%  swapper          [i40e]                    [k] i40e_clean_rx_irq_zc
> > >     0.70%  swapper          [kernel.vmlinux]          [k] intel_idle
> > >     0.66%  xdpsock          [kernel.vmlinux]          [k] dma_direct_sync_single_for_cpu
> > >     0.60%  xdpsock          [kernel.vmlinux]          [k] bpf_direct_xsk
> > >     0.50%  ksoftirqd/28     [kernel.vmlinux]          [k] xsk_umem_discard_addr
> > > 
> > > Based on the perf reports comparing AF_XDP default and direct rxdrop, we can say that
> > > AF_XDP direct rxdrop codepath is avoiding the overhead of going through these functions
> > > 	bpf_prog_xxx
> > >          bpf_xdp_redirect_map
> > > 	xsk_map_lookup_elem
> > >          __xsk_map_redirect
> > > With AF_XDP direct, xsk_rcv() is directly called via bpf_direct_xsk() in xdp_do_redirect()
> > 
> > I don't think you're identifying the overhead correctly.
> > xsk_map_lookup_elem is 1%
> > but bpf_xdp_redirect_map() suppose to call __xsk_map_lookup_elem()
> > which is a different function:
> > ffffffff81493fe0 T __xsk_map_lookup_elem
> > ffffffff81492e80 t xsk_map_lookup_elem
> > 
> > 10% for bpf_prog_80b55d8a76303785 is huge.
> > It's the actual code of the program _without_ any helpers.
> > How does the program actually look?
> 
> It is the xdp program that is loaded via xsk_load_xdp_prog() in tools/lib/bpf/xsk.c
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/lib/bpf/xsk.c#n268

I see. Looks like map_gen_lookup was never implemented for xskmap.
How about adding it first the way array_map_gen_lookup() is implemented?
This will easily give 2x perf gain.

