Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD292486A9
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 16:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgHROE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 10:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbgHROE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 10:04:57 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6B2C061389;
        Tue, 18 Aug 2020 07:04:56 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id 9so16336567wmj.5;
        Tue, 18 Aug 2020 07:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6x1Ak2P3rV0lY04CxHSGtOsvo0mLh15m+1LZrs0+dgI=;
        b=aiKEvHMqkueSWM03yfT17ZRgLqjY2GdNq8EoKA3Sd6Bk5TE9LVFEPPqSgwg5H9IeZ8
         pP02JXt0qzGw//wJAa/ZJd0oE89Bye8xofEc7UrTauDtg4t3oFTRVekkcJRuYaWEAIZ6
         NZvug9L+YfJCvhnzqxT99Kf3Tky9mRIxhKNHJlU+bbmbVc5F7hoqKna3h7513ORDuTBD
         sVerRDRfMxezHwwVq1PoV+v6LjYnSCHl4fu12HP99KdWQVKAZw3geEtE95+OOIr5ZnaJ
         HF0EvwijMDu+ZaHHYncZGHgO+ZaKZp1wBH8gAm7aanVmHF+k8OF0c/vCoKcuVo2Q+4zN
         5Gmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6x1Ak2P3rV0lY04CxHSGtOsvo0mLh15m+1LZrs0+dgI=;
        b=iK/I5oFrcMdbZwabBiUe8O0qe6Jitlj5BZ+tqgiCQaQofVsQam9JUbaQpNkP4gFxDy
         pHPcUJMmetRKS1OCtedIcJKx1vrlIvvSt9owVNMgd3m8aKWUsbQEEh2meRaISHXKUPcK
         hjsMA/SBnCvf4oWBPFhDiGZfjdUcWR2ukQvlfuuyLf7V718PQxY2dJ2l5JsiTCVwOosT
         8Kh0YFy3bDnawHVR4K/elcL9B5XsVeLawgoK0at5eHaEKZV2ASUVKcuFFgrlTScwRFlt
         gjamW5TKOX+LJ9ec6Hshu6zwrBYzMRljKrO9riGlHeExTegOLb51dyzkD3iEIBB1FMG/
         9cyQ==
X-Gm-Message-State: AOAM532a2H21AuE7AW++WxAr76c9PHoyg8nPCwde86qh7ncRuZplg2kl
        drQvOF8baOVpArBpwMfW1OS1P0fopOE3yxo0m94=
X-Google-Smtp-Source: ABdhPJyVEkaR2gT8OnMJWFLL+UQECo20ochAdHklbD8V2jvT8bdtXvpJ4NDdcX90QarezriwZAu5a/eI4F9N3sfxge0=
X-Received: by 2002:a1c:3b89:: with SMTP id i131mr133157wma.30.1597759495288;
 Tue, 18 Aug 2020 07:04:55 -0700 (PDT)
MIME-Version: 1.0
References: <1594967062-20674-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1594967062-20674-1-git-send-email-lirongqing@baidu.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 18 Aug 2020 16:04:43 +0200
Message-ID: <CAJ+HfNi2B+2KYP9A7yCfFUhfUBd=sFPeuGbNZMjhNSdq3GEpMg@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH 0/2] intel/xdp fixes for fliping rx buffer
To:     Li RongQing <lirongqing@baidu.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Piotr <piotr.raczynski@intel.com>,
        Maciej <maciej.machnikowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jul 2020 at 08:24, Li RongQing <lirongqing@baidu.com> wrote:
>
> This fixes ice/i40e/ixgbe/ixgbevf_rx_buffer_flip in
> copy mode xdp that can lead to data corruption.
>
> I split two patches, since i40e/xgbe/ixgbevf supports xsk
> receiving from 4.18, put their fixes in a patch
>

Li, sorry for the looong latency. I took a looong vacation. :-P

Thanks for taking a look at this, but I believe this is not a bug.

The Intel Ethernet drivers (obviously non-zerocopy AF_XDP -- "good ol'
XDP") use a page reuse algorithm.

Basic idea is that a page is allocated from the page allocator
(i40e_alloc_mapped_page()). The refcount is increased to
USHRT_MAX. The page is split into two chunks (simplified). If there's
one user of the page, the page can be reused (flipped). If not, a new
page needs to be allocated (with the large refcount).

So, the idea is that usually the page can be reused (flipped), and the
page only needs to be "put" not "get" since the refcount was initally
bumped to a large value.

All frames (except XDP_DROP which can be reused directly) "die" via
page_frag_free() which decreases the page refcount, and frees the page
if the refcount is zero.

Let's take some scenarios as examples:

1. A frame is received in "vanilla" XDP (MEM_TYPE_PAGE_SHARED), and
   the XDP program verdict is XDP_TX. The frame will be placed on the
   HW Tx ring, and freed* (async) in i40e_clean_tx_irq:
        /* free the skb/XDP data */
        if (ring_is_xdp(tx_ring))
            xdp_return_frame(tx_buf->xdpf); // calls page_frag_free()

2. A frame is passed to the stack, eventually it's freed* via
   skb_free_frag().

3. A frame is passed to an AF_XDP socket. The data is copied to the
   socket data area, and the frame is directly freed*.

Not the * by the freed. Actually freeing here means calling
page_frag_free(), which means decreasing the refcount. The page reuse
algorithm makes sure that the buffers are not stale.

The only difference from XDP_TX and XDP_DIRECT to dev/cpumaps,
compared to AF_XDP sockets is that the latter calls page_frag_free()
directly, whereas the other does it asynchronous from the Tx clean up
phase.

Let me know if it's still not clear, but the bottom line is that none
of these patches are needed.


Thanks!
Bj=C3=B6rn


> Li RongQing (2):
>   xdp: i40e: ixgbe: ixgbevf: not flip rx buffer for copy mode xdp
>   ice/xdp: not adjust rx buffer for copy mode xdp
>
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c       | 5 ++++-
>  drivers/net/ethernet/intel/ice/ice_txrx.c         | 5 ++++-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     | 5 ++++-
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 5 ++++-
>  include/net/xdp.h                                 | 3 +++
>  net/xdp/xsk.c                                     | 4 +++-
>  6 files changed, 22 insertions(+), 5 deletions(-)
>
> --
> 2.16.2
>
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
