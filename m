Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E29D452E47
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 10:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhKPJqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 04:46:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50837 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233421AbhKPJq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 04:46:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637055810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L1s/8avlyjIK/RZyIzsfVH2lVWGKC4EiFg87yujcKIY=;
        b=D34mzdCT+X+5nCsmeJW5vpaUHLgtnhhMq/2Rq5Bwi1fMHIEVqj0S0oUwmgMOK1yzanMIIi
        O/pL82ZP1W0n2ag55dfX924RnMLzO9lBW8LARSXlMeO2dZqc+ZeM26RXLAwZiOfmkIrvv8
        wEx8VYZwGDVX6wo4g8mBz+h2ydD7NmU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-ka-wVJ0DND-SFPKrzQ1ClA-1; Tue, 16 Nov 2021 04:43:29 -0500
X-MC-Unique: ka-wVJ0DND-SFPKrzQ1ClA-1
Received: by mail-ed1-f71.google.com with SMTP id i9-20020a508709000000b003dd4b55a3caso16705075edb.19
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 01:43:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=L1s/8avlyjIK/RZyIzsfVH2lVWGKC4EiFg87yujcKIY=;
        b=qSDSSHArXWRWmhQ+WRmNiAFEzSk+ay4R4ccRHXTZ+sGJkpgUCEG8QrNs3hCJ3+KFov
         uwSquykLlbgW20Y4ghzTCdjAdWxiZL52OdUOMEExqbkO7y5W9qXmkitFmbwARu5uLhUA
         /oOEYQ+gpQQ9Pegi54O9U6oyVI6jFdUhhowXvnOlu99G4hd9YcnmvmqaoGyZMMtaI5lb
         9UYOKba3ltucSaYFA4YSJoQrayNGiu3+8MWzxaCVrLIWWtlULMKSXV6PAzEyxyMDyTcO
         TwiuoA02rcEyFhhhuoGDcsdDxDGsoMcfxKnthpzr/2LM1KoevAHnJbCPOz0Nc0F/QGbw
         XTMQ==
X-Gm-Message-State: AOAM533i4Kuy3bDOXillYT7WPZgBF8zyt1KkvWqxRx/X27hJoOwug+om
        NKcNElB16vs0D3LgBQKLltIRdF0qiuQqtweDEAH3iug8YunPCHLnVvrtRojsAsv04sr7lvAuSL7
        2f7iLjNx1buQ4hH4+
X-Received: by 2002:a17:907:3f83:: with SMTP id hr3mr7987660ejc.555.1637055807951;
        Tue, 16 Nov 2021 01:43:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxT1Xyih7x3vnLG449T65Qwgm2mYwTpox/TXQxvi2emu1FwTdcBcEU3IgKM9rOmpVo7QwHRwg==
X-Received: by 2002:a17:907:3f83:: with SMTP id hr3mr7987619ejc.555.1637055807719;
        Tue, 16 Nov 2021 01:43:27 -0800 (PST)
Received: from [192.168.2.13] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id h10sm6759903edj.1.2021.11.16.01.43.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 01:43:27 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <5a121fc4-fb6c-c70b-d674-9bf13c325b64@redhat.com>
Date:   Tue, 16 Nov 2021 10:43:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, toke@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        maciej.fijalkowski@intel.com
Subject: Re: [RFC PATCH bpf-next 0/8] XDP_REDIRECT_XSK and Batched AF_XDP Rx
Content-Language: en-US
To:     Ciara Loftus <ciara.loftus@intel.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211116073742.7941-1-ciara.loftus@intel.com>
In-Reply-To: <20211116073742.7941-1-ciara.loftus@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16/11/2021 08.37, Ciara Loftus wrote:
> The common case for AF_XDP sockets (xsks) is creating a single xsk on a queue for sending and
> receiving frames as this is analogous to HW packet steering through RSS and other classification
> methods in the NIC. AF_XDP uses the xdp redirect infrastructure to direct packets to the socket. It
> was designed for the much more complicated case of DEVMAP xdp_redirects which directs traffic to
> another netdev and thus potentially another driver. In the xsk redirect case, by skipping the
> unnecessary parts of this common code we can significantly improve performance and pave the way
> for batching in the driver. This RFC proposes one such way to simplify the infrastructure which
> yields a 27% increase in throughput and a decrease in cycles per packet of 24 cycles [1]. The goal
> of this RFC is to start a discussion on how best to simplify the single-socket datapath while
> providing one method as an example.
> 
> Current approach:
> 1. XSK pointer: an xsk is created and a handle to the xsk is stored in the XSKMAP.
> 2. XDP program: bpf_redirect_map helper triggers the XSKMAP lookup which stores the result (handle
> to the xsk) and the map type (XSKMAP) in the percpu bpf_redirect_info struct. The XDP_REDIRECT
> action is returned.
> 3. XDP_REDIRECT handling called by the driver: the map type (XSKMAP) is read from the
> bpf_redirect_info which selects the xsk_map_redirect path. The xsk pointer is retrieved from the
> bpf_redirect_info and the XDP descriptor is pushed to the xsk's Rx ring. The socket is added to a
> list for flushing later.
> 4. xdp_do_flush: iterate through the lists of all maps that can be used for redirect (CPUMAP,
> DEVMAP and XSKMAP). When XSKMAP is flushed, go through all xsks that had any traffic redirected to
> them and bump the Rx ring head pointer(s).
> 
> For the end goal of submitting the descriptor to the Rx ring and bumping the head pointer of that
> ring, only some of these steps are needed. The rest is overhead. The bpf_redirect_map
> infrastructure is needed for all other redirect operations, but is not necessary when redirecting
> to a single AF_XDP socket. And similarly, flushing the list for every map type in step 4 is not
> necessary when only one socket needs to be flushed.
> 
> Proposed approach:
> 1. XSK pointer: an xsk is created and a handle to the xsk is stored both in the XSKMAP and also the
> netdev_rx_queue struct.
> 2. XDP program: new bpf_redirect_xsk helper returns XDP_REDIRECT_XSK.
> 3. XDP_REDIRECT_XSK handling called by the driver: the xsk pointer is retrieved from the
> netdev_rx_queue struct and the XDP descriptor is pushed to the xsk's Rx ring.
> 4. xsk_flush: fetch the handle from the netdev_rx_queue and flush the xsk.
> 
> This fast path is triggered on XDP_REDIRECT_XSK if:
>    (i) AF_XDP socket SW Rx ring configured
>   (ii) Exactly one xsk attached to the queue
> If any of these conditions are not met, fall back to the same behavior as the original approach:
> xdp_redirect_map. This is handled under-the-hood in the new bpf_xdp_redirect_xsk helper so the user
> does not need to be aware of these conditions.
> 
> Batching:
> With this new approach it is possible to optimize the driver by submitting a batch of descriptors
> to the Rx ring in Step 3 of the new approach by simply verifying that the action returned from
> every program run of each packet in a batch equals XDP_REDIRECT_XSK. That's because with this
> action we know the socket to redirect to will be the same for each packet in the batch. This is
> not possible with XDP_REDIRECT because the xsk pointer is stored in the bpf_redirect_info and not
> guaranteed to be the same for every packet in a batch.
> 
> [1] Performance:
> The benchmarks were performed on VM running a 2.4GHz Ice Lake host with an i40e device passed
> through. The xdpsock app was run on a single core with busy polling and configured in 'rxonly' mode.
> ./xdpsock -i <iface> -r -B
> The improvement in throughput when using the new bpf helper and XDP action was measured at ~13% for
> scalar processing, with reduction in cycles per packet of ~13. A further ~14% improvement in
> throughput and reduction of ~11 cycles per packet was measured when the batched i40e driver path
> was used, for a total improvement of ~27% in throughput and reduction of ~24 cycles per packet.
> 
> Other approaches considered:
> Two other approaches were considered. The advantage of both being that neither involved introducing
> a new XDP action. The first alternative approach considered was to create a new map type
> BPF_MAP_TYPE_XSKMAP_DIRECT. When the XDP_REDIRECT action was returned, this map type could be
> checked and used as an indicator to skip the map lookup and use the netdev_rx_queue xsk instead.
> The second approach considered was similar and involved using a new bpf_redirect_info flag which
> could be used in a similar fashion.
> While both approaches yielded a performance improvement they were measured at about half of what
> was measured for the approach outlined in this RFC. It seems using bpf_redirect_info is too
> expensive.

I think it was Bjørn that discovered that accessing the per CPU 
bpf_redirect_info struct have an overhead of approx 2 ns (times 2.4GHz 
~4.8 cycles).  Your reduction in cycles per packet was ~13, where ~4.8 
seem to be large.

The code access this_cpu_ptr(&bpf_redirect_info) two times.
One time in the BPF-helper redirect call and second in xdp_do_redirect.
(Hint xdp_redirect_map end-up calling __bpf_xdp_redirect_map)

Thus, it seems (as you say), the bpf_redirect_info approach is too 
expensive.  May be should look at storing bpf_redirect_info in a place 
that doesn't requires the this_cpu_ptr() lookup... or cache the lookup 
per NAPI cycle.
Have you tried this?


> Also, centralised processing of XDP actions was investigated. This would involve porting all drivers
> to a common interface for handling XDP actions which would greatly simplify the work involved in
> adding support for new XDP actions such as XDP_REDIRECT_XSK. However it was deemed at this point to
> be more complex than adding support for the new action to every driver. Should this series be
> considered worth pursuing for a proper patch set, the intention would be to update each driver
> individually.

I'm fine with adding a new helper, but I don't like introducing a new 
XDP_REDIRECT_XSK action, which requires updating ALL the drivers.

With XDP_REDIRECT infra we beleived we didn't need to add more 
XDP-action code to drivers, as we multiplex/add new features by 
extending the bpf_redirect_info.
In this extreme performance case, it seems the this_cpu_ptr "lookup" of 
bpf_redirect_info is the performance issue itself.

Could you experiement with different approaches that modify 
xdp_do_redirect() to handle if new helper bpf_redirect_xsk was called, 
prior to this_cpu_ptr() call.
(Thus, avoiding to introduce a new XDP-action).

> Thank you to Magnus Karlsson and Maciej Fijalkowski for several suggestions and insight provided.
> 
> TODO:
> * Add selftest(s)
> * Add support for all copy and zero copy drivers
> * Libxdp support
> 
> The series applies on commit e5043894b21f ("bpftool: Use libbpf_get_error() to check error")
> 
> Thanks,
> Ciara
> 
> Ciara Loftus (8):
>    xsk: add struct xdp_sock to netdev_rx_queue
>    bpf: add bpf_redirect_xsk helper and XDP_REDIRECT_XSK action
>    xsk: handle XDP_REDIRECT_XSK and expose xsk_rcv/flush
>    i40e: handle the XDP_REDIRECT_XSK action
>    xsk: implement a batched version of xsk_rcv
>    i40e: isolate descriptor processing in separate function
>    i40e: introduce batched XDP rx descriptor processing
>    libbpf: use bpf_redirect_xsk in the default program
> 
>   drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  13 +-
>   .../ethernet/intel/i40e/i40e_txrx_common.h    |   1 +
>   drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 285 +++++++++++++++---
>   include/linux/netdevice.h                     |   2 +
>   include/net/xdp_sock_drv.h                    |  49 +++
>   include/net/xsk_buff_pool.h                   |  22 ++
>   include/uapi/linux/bpf.h                      |  13 +
>   kernel/bpf/verifier.c                         |   7 +-
>   net/core/dev.c                                |  14 +
>   net/core/filter.c                             |  26 ++
>   net/xdp/xsk.c                                 |  69 ++++-
>   net/xdp/xsk_queue.h                           |  31 ++
>   tools/include/uapi/linux/bpf.h                |  13 +
>   tools/lib/bpf/xsk.c                           |  50 ++-
>   14 files changed, 551 insertions(+), 44 deletions(-)
> 

