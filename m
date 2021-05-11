Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9232337B201
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 00:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhEKW6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 18:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhEKW6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 18:58:38 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441EFC061574
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 15:57:31 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id s6so24764153edu.10
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 15:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cATT+OwEQMGEKX5uXvagfinaIEFYachirarjqzYNOow=;
        b=Q45T21hkjgFIUKqGeb6pVNLLCL7TuRLmxFxMBHqlI8az5pd92ws0XyJXLJ7JtCV8vE
         FFOgnu3hVppAOZZ41sTH9HxkaFIPLJHMM5kXimi1U3D/nHaSGdX6B3ks2RjXvoOVRWDj
         tt3cnH83j0///TjqwoOjY0zxo7lv3rwDWKMdmu53ggutVH0QEmvQszcBT2goTozXR4Fz
         jYfAPpPa2B1QCEAGZzRT9yk1XRJuDky/QCNSoJOYGc4hxUiAkF2HlVSMdlNuzxbviUG7
         3FV9kSgJElzINsOjtbmuRofLaQ6d/yNHK+DQyk33i3nrJLAtRw2A0vTqgc859g1lndHI
         NYyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cATT+OwEQMGEKX5uXvagfinaIEFYachirarjqzYNOow=;
        b=DHbCLj9DwmUdLhPYcfSTGr1BOIpDgou/KP7QDHgIT0tVo0H6BJM6svE/yK9lUzRNOA
         GrTgzWA40twj+XJygPHZE04tsa5bPovNluuxLSCDGu/yOwNfM8OPc79HS8UPFg/j4yUx
         8bxwKTTCwhTP6//mGDynZ3gSnbEo1M158dbUEfx3ktl1Mp0Pk862Naam2Lf3v1L1RNrr
         QUZ8zcnq4OCOhFM3xeUwzNAABFbgyF/EffotyyLzQWnOjS1eco8ToojG7rqrCwHCVaAf
         9O7ncY+p0JsiqrEotxCzHFB2A40CwnDay5xxmvZvmv0+3OqN5bQ8lCDCFqT/BHt/Tiaq
         fdyw==
X-Gm-Message-State: AOAM530qh4/aOFX18qewVgq9BT+B+30IOXMTXUrIuvIrQKGqT1xH+I9p
        ZNJwL+PVzoQvTK2yCp4LBVMpefCVym1TEg==
X-Google-Smtp-Source: ABdhPJx9cSX6/N3tO6fgud/MURfEBCZpaAjS2slqyOCgfLSHHlDijq7gAfFwcPtCXp+OoEwtrMPETA==
X-Received: by 2002:a05:6402:2218:: with SMTP id cq24mr22112008edb.213.1620773849609;
        Tue, 11 May 2021 15:57:29 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id u13sm15637742edq.55.2021.05.11.15.57.29
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 15:57:29 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id v12so21669800wrq.6
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 15:57:29 -0700 (PDT)
X-Received: by 2002:a05:6000:188b:: with SMTP id a11mr39621187wri.275.1620773848517;
 Tue, 11 May 2021 15:57:28 -0700 (PDT)
MIME-Version: 1.0
References: <1620085579-5646-1-git-send-email-rsanger@wand.net.nz>
 <CA+FuTSeDTYMZzT3n3tfm9KPCRx_ObWU-HaU4JxZCSCm_8sf2XA@mail.gmail.com>
 <CAN6QFNzj9+Y3W2eYTpHzVVjy_sYN+9d_Sa99HgQ0KgKyNmpeNw@mail.gmail.com>
 <CA+FuTSfE9wW55BbYRWNE1=XYAjG7gKVLLLbfAvB-4F+dL=8gHA@mail.gmail.com>
 <CAN6QFNw9xx0F35RNxDJS-4xbYu4SdU=XND=_dqCkGJgdNj5Hqw@mail.gmail.com>
 <CA+FuTSc=x6bG5O7mveAuNc6EXq3TdiD+nNYYp9rfiZ3frfGziA@mail.gmail.com> <CAN6QFNyHep+UGjM7XpA4akbtvZFNDarVcs3=zZPpYO7RMTJgHg@mail.gmail.com>
In-Reply-To: <CAN6QFNyHep+UGjM7XpA4akbtvZFNDarVcs3=zZPpYO7RMTJgHg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 11 May 2021 18:56:50 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfUAcjOpcopYMpfMGD7FmPkgrMYQnB+GKQYg438YvAxqQ@mail.gmail.com>
Message-ID: <CA+FuTSfUAcjOpcopYMpfMGD7FmPkgrMYQnB+GKQYg438YvAxqQ@mail.gmail.com>
Subject: Re: [PATCH] net: packetmmap: fix only tx timestamp on request
To:     Richard Sanger <rsanger@wand.net.nz>
Cc:     Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 6:11 PM Richard Sanger <rsanger@wand.net.nz> wrote:
>
> I've had a chance to look into this further and have found where the
> timestamp is added. Details are at the end of this message.
>
> On Thu, May 6, 2021 at 1:23 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Wed, May 5, 2021 at 7:42 PM Richard Sanger <rsanger@wand.net.nz> wrote:
> [...]
> > >
> > > I've just verified using printk() that after the call to skb_tx_timestamp(skb)
> > > in veth_xmit() skb->tstamp == 0 as expected.
> > >
> > > However, when skb_tx_timestamp() is called within the packetmmap code path
> > > skb->tstamp holds a valid time.
> >
> > Interesting. I had expected veth_xmit to trigger skb_orphan, which
> > calls the destructor.
> >
> > But this is no longer true as of commit 9c4c325252c5 ("skbuff:
> > preserve sock reference when scrubbing the skb.").
> >
> > As a result, I suppose the skb can enter the next namespace and be
> > timestamped there if receive timestamps are enabled (this is not
> > per-socket).
> >
> > One way to verify, if you can easily recompile a kernel, is to add a
> > WARN_ON_ONCE(1) to tpacket_destruct_skb to see which path led up to
> > queuing the completion notification.
> >
>
> Here's the output of putting a WARN_ON_ONCE(1) statement in
> tpacket_destruct_skb, I don't believe it is related to the problem.

It might be, if this is indeed an llc (ETH_P_802_2) packet that was
inserted with tpacket.

veth calls netif_rx, which enqueues the packet to the percpu queue for
later processing in softirq context using process_backlog.

>
> [   37.249629] RIP: 0010:tpacket_destruct_skb+0x24/0x60
> [...]
> [   37.249659] Call Trace:
> [   37.249661]  <IRQ>
> [   37.249666]  skb_release_head_state+0x44/0x90
> [   37.249680]  skb_release_all+0x13/0x30
> [   37.249684]  kfree_skb+0x2f/0xa0
> [   37.249689]  llc_rcv+0x2e/0x360 [llc]
> [   37.249698]  __netif_receive_skb_one_core+0x8f/0xa0
> [   37.249707]  __netif_receive_skb+0x18/0x60
> [   37.249710]  process_backlog+0xa9/0x160
> [   37.249714]  __napi_poll+0x31/0x140
> [   37.249717]  net_rx_action+0xde/0x210
> [   37.249722]  __do_softirq+0xe0/0x29b
> [   37.249737]  do_softirq+0x66/0x80
> [   37.249747]  </IRQ>
> [   37.249748]  __local_bh_enable_ip+0x50/0x60
> [   37.249751]  __dev_queue_xmit+0x23a/0x6e0
> [   37.249756]  dev_queue_xmit+0x10/0x20
> [   37.249759]  packet_sendmsg+0x6b8/0x1c90
> [   37.249763]  ? __drain_all_pages+0x150/0x1c0
> [   37.249772]  sock_sendmsg+0x65/0x70
> [   37.249778]  __sys_sendto+0x113/0x190
> [   37.249783]  ? handle_mm_fault+0xda/0x2b0
> [   37.249790]  ? exit_to_user_mode_prepare+0x3c/0x1e0
> [   37.249800]  ? do_user_addr_fault+0x1d3/0x640
> [   37.249805]  __x64_sys_sendto+0x29/0x30
> [   37.249809]  do_syscall_64+0x40/0xb0
> [   37.249816]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   37.249820] RIP: 0033:0x7f43950d27ea
>
> [...]
>
> > I think we need to understand exactly what goes on before we apply a
> > patch. It might just be papering over the problem otherwise.
>
> Okay, so the call path that adds the timestamp looks like this:
>
> send() syscall triggers tpacket_snd() which calls the veth_xmit() hander.
> In drivers/net/veth.c veth_xmit() calls veth_forward_skb() which then
> calls netif_rx()/netif_rx_internal() in net/core/dev.c.
> And finally, net_timestamp_check(netdev_tstamp_prequeue, skb) adds
> the timestamp, netdev_tstamp_prequeue defaults to 1.
>
> net_timestamp_check in its current form was added by 588f033075
> ("net: use jump_label for netstamp_needed ")
> In the kernel since 3.3-rc1, so it looks like this issue has been present the
> entire time. Pre-conditions are netstamp_needed_key and
> netdev_tstamp_prequeue, so if either is false, timestamping won't happen
> at this stage in the code.

Thanks. That's as I expected.

We cannot suppress the timestamp assignment by net_timestamp_check, as
it may be expected by the receive process.

I don't immediately see a way to clear/ignore the field in
tpacket_destruct_skb if the field was set from a different network
namespace than the one in which the packet socket inserted the packet.

So your suggested patch to suppress spurious tx timestamps if software
timestamping reporting is not enabled SGTM.


> Here's the call trace of where the timestamp is added
>
> [  251.619538] Call Trace:
> [  251.619550]  netif_rx+0x1b/0x60
> [  251.619556]  veth_xmit+0x19d/0x230 [veth]
> [  251.619563]  netdev_start_xmit+0x4a/0x8b
> [  251.619566]  dev_hard_start_xmit.cold+0xc8/0x1d5
> [  251.619569]  __dev_queue_xmit.cold+0xa3/0x12c
> [  251.619572]  dev_queue_xmit+0x10/0x20
> [  251.619575]  packet_sendmsg+0x6b8/0x1c90
> [  251.619580]  ? __drain_all_pages+0x150/0x1c0
> [  251.619588]  sock_sendmsg+0x65/0x70
> [  251.619594]  __sys_sendto+0x113/0x190
> [  251.619598]  ? handle_mm_fault+0xda/0x2b0
> [  251.619604]  ? exit_to_user_mode_prepare+0x3c/0x1e0
> [  251.619611]  ? do_user_addr_fault+0x1d3/0x640
> [  251.619615]  __x64_sys_sendto+0x29/0x30
> [  251.619618]  do_syscall_64+0x40/0xb0
> [  251.619623]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> This appears to be reasonable, but I don't know what the expected behaviour
> is. Should this timestamp still be cleared before returning the sent skb?
