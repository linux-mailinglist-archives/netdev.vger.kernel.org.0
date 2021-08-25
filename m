Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF563F70C6
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 09:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238114AbhHYH65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 03:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236851AbhHYH64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 03:58:56 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7F7C061757;
        Wed, 25 Aug 2021 00:58:10 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id g184so3767190pgc.6;
        Wed, 25 Aug 2021 00:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZevlXcRX1mLRN8VJnMgngspMrQzEt7/oEUDuBn/jrjo=;
        b=BKJTcHRKXJyc0iKCxsAXaJz/45m393r0douvVuZDlmP61AFQQMy4NyoM4EEjy8UmmN
         jgCjApxTuXCaQrZ0InByFIsv3zgD27FCaUGdGchtrFOLzLrGNt4ke1WADPFMNQlNY9Qi
         Oym9z/BSTXeg3b7B5WPNZsqqLZ1kkSZlHMamk1kjE+GsvxDF0nP2uSBWF2nVanwRRWho
         THRF0+NTS3iHkSqvV51hGI+07GZkLGW0h6jJDO7p19aQc3TuFRTPfKnBcbXUqUNsmiXT
         OYGJYWhABEfjo/a5siVBL17tJn8CW8JvmGO0TbPX9uBSeAInB7skbGI0+/0lpxPwSjK8
         RqPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZevlXcRX1mLRN8VJnMgngspMrQzEt7/oEUDuBn/jrjo=;
        b=Un6aSsxc6jyq+bZUmIDoh4caSKSaFtFAsGQv6nHEsuNLH7AToTPI8lRfQ9m/7j/U2n
         RSEwTJoZKLCqwObHOV6onhFVTfxD1OkFAyuA+KE/1PyJPKOtCWsOThoTNVAPSoxJxi0H
         Q7Rgsl0RTC9hYgEi+FIeKjt7cCUCiMs8dZ1jB8HNi9505csUYlm8nZPgk1joWptvvrOl
         A6Aa2cdSD7/WWXDk3V22BzhPgzcSBEibqOevnXXtII6dhKkF0sDknPg5l8E5jkjiWCle
         SvTFQEKIeB67Dep37ujUnrgeZF0ap8adOelRWBHTXWtcf7ItYmp3goI+u0E9/JjDgtV+
         fa2A==
X-Gm-Message-State: AOAM5318WLtP60wRRbJJqd3IpPP02AOWchEtVMvhiHPSH7+C7HtnLVb7
        PKuYfgiBSmL2e5CuBHUlPX1nEkqPzZ6MAMKTTFU=
X-Google-Smtp-Source: ABdhPJzr0alM2qztIxHb4xt1NHnWEnaCaalXwsg5eGwDD+j0HJfcMfU87A/SzaK2Nu+XjNLgvjHdxGvaZ+nzsYyMLO8=
X-Received: by 2002:a62:7b48:0:b0:3ee:de1f:18a9 with SMTP id
 w69-20020a627b48000000b003eede1f18a9mr4239251pfc.73.1629878289977; Wed, 25
 Aug 2021 00:58:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210819120004.34392-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20210819120004.34392-1-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 25 Aug 2021 09:57:59 +0200
Message-ID: <CAJ8uoz0Hisa+f9S3DbeTzjPbmVTAfeQAc1KJ-AASUmnWtjkMhw@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH v7 intel-next 0/9] XDP_TX improvements
 for ice
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Jussi Maki <joamaki@gmail.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 2:15 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> I didn't realize that on v6 I didn't have CONFIG_NET_SWITCHDEV option
> set in the kernel config. I removed ice_eswitch_remap_ring but didn't
> adjust the q_vector's ring pointer to the new Rx/Tx union.
>
> Hope that it's the last time of embarrassment :)
>
> v6->v7:
> * fix compilation issues when CONFIG_NET_SWITCHDEV=y
>
> v5->v6:
> * rebase set on Tony's dev-queue
> * adjust switchdev code to ring split
> * compile with W=1 C=2 and fix outstanding kdoc issues
>
> v4->v5:
> * fix issues pointed by lkp; variables used for updating ring stats
>   could be un-inited
> * s/ice_ring/ice_rx_ring; it looks now symmetric given that we have
>   ice_tx_ring struct dedicated for Tx ring
> * go through the code and use ice_for_each_* macros; it was spotted by
>   Brett that there was a place around that code that this set is
>   touching that was not using the ice_for_each_txq. Turned out that there
>   were more such places
> * take care of coalesce related code; carry the info about type of ring
>   container in ice_ring_container
> * pull out getting rid of @ring_active onto separate patch, as suggested
>   by Brett
>
> v3->v4:
> * fix lkp issues;
>
> v2->v3:
> * improve XDP_TX in a proper way
> * split ice_ring
> * propagate XDP ring pointer to Rx ring
>
> v1->v2:
> * try to improve XDP_TX processing
>
> v6 : https://lore.kernel.org/bpf/20210818135916.25007-1-maciej.fijalkowski@intel.com/
> v5 : https://lore.kernel.org/bpf/20210818075256.GA16780@ranger.igk.intel.com/
> v4 : https://lore.kernel.org/bpf/20210806095539.34423-1-maciej.fijalkowski@intel.com/
> v3 : https://lore.kernel.org/bpf/20210805230046.28715-1-maciej.fijalkowski@intel.com/
> v2 : https://lore.kernel.org/bpf/20210705164338.58313-1-maciej.fijalkowski@intel.com/
> v1 : https://lore.kernel.org/bpf/20210601113236.42651-1-maciej.fijalkowski@intel.com/
>
> Thanks!
> Maciej

Good work Maciej! This patch set really helps with performance and ease of use.

FWIW for patches 1, 2, 4 - 9:

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

I do not feel comfortable acking patch #3 since it is touching
something that is used by the whole driver. I think this patch should
be acked by the ice driver maintainers themselves, Jesse and Tony (I
believe).

/Magnus

> Maciej Fijalkowski (9):
>   ice: remove ring_active from ice_ring
>   ice: move ice_container_type onto ice_ring_container
>   ice: split ice_ring onto Tx/Rx separate structs
>   ice: unify xdp_rings accesses
>   ice: do not create xdp_frame on XDP_TX
>   ice: propagate xdp_ring onto rx_ring
>   ice: optimize XDP_TX workloads
>   ice: introduce XDP_TX fallback path
>   ice: make use of ice_for_each_* macros
>
>  drivers/net/ethernet/intel/ice/ice.h          |  41 +++-
>  drivers/net/ethernet/intel/ice/ice_arfs.c     |   2 +-
>  drivers/net/ethernet/intel/ice/ice_base.c     |  59 +++---
>  drivers/net/ethernet/intel/ice/ice_base.h     |   8 +-
>  drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   9 +-
>  drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |  10 +-
>  drivers/net/ethernet/intel/ice/ice_eswitch.c  |  35 ++--
>  drivers/net/ethernet/intel/ice/ice_eswitch.h  |   4 +-
>  drivers/net/ethernet/intel/ice/ice_ethtool.c  |  95 +++++----
>  drivers/net/ethernet/intel/ice/ice_lib.c      |  92 +++++----
>  drivers/net/ethernet/intel/ice/ice_lib.h      |   6 +-
>  drivers/net/ethernet/intel/ice/ice_main.c     | 145 +++++++++-----
>  drivers/net/ethernet/intel/ice/ice_ptp.c      |   2 +-
>  drivers/net/ethernet/intel/ice/ice_ptp.h      |   4 +-
>  drivers/net/ethernet/intel/ice/ice_trace.h    |  28 +--
>  drivers/net/ethernet/intel/ice/ice_txrx.c     | 183 +++++++++++-------
>  drivers/net/ethernet/intel/ice/ice_txrx.h     | 126 +++++++-----
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  98 ++++++++--
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  14 +-
>  .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   2 +-
>  drivers/net/ethernet/intel/ice/ice_xsk.c      |  70 ++++---
>  drivers/net/ethernet/intel/ice/ice_xsk.h      |  20 +-
>  22 files changed, 629 insertions(+), 424 deletions(-)
>
> --
> 2.20.1
>
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
