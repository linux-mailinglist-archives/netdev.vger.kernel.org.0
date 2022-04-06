Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B67D4F5F66
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbiDFNLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbiDFNKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:10:48 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786645F16A7
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 02:45:06 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2eb680211d9so19739117b3.9
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 02:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AYk2K8p4M8LRF6wod5uxXAsTY05Rg73C2Em9cYJy5MY=;
        b=X+/7DsU1IoX3NNnyTeN03N1fOnVV52P3iEwI+4F08DapnVAqLX+p3Yl3c8THw8L/07
         D3Cl0C9d9Yh4L/LXnM2yDlt5KTc0Yu1klg3iFi53PhpH6Y9QnwTbxn0M3Jq4AiltkJYY
         od0afbB490MVunfNInkUsQBSkyBvy1nXVBokFW5SJ0e0ghuxDVuhlvUrszvLiR8ybKxw
         iuER+bcSHn9uq5fNWWIb4XnpWYsiCFjtbBC2k1ABJ5H9MYGRevEZHc404DvTkPv/mWcA
         ne232tBlG+wHbtrx6jNVqchCe0YwNRT/YtUyHjkcq7+pQS35sfg5AcavQcKpKalNyUht
         FA/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AYk2K8p4M8LRF6wod5uxXAsTY05Rg73C2Em9cYJy5MY=;
        b=ME8GtkAk5mpr6MZaGFYP0hIA/Rch/2Zw42QHDBybbLOoRdQfm0G5h4yhRkg7RAnmmd
         uYvlbvYSjZck7BuJksroDnu4k4EFK3gzLWN9de6AxtVFbqwoFJANagOmpUeEEWbOCgLA
         nUMiSW921uAEJ1wUHbJPQg1NaiuhZCdCLH7ZuRj9y2gWqktLIAMd/45qQDvp3kxilHfZ
         y+VpyEEkBcjVpKGafR6px/DTCRFPUobOaDJWoX13hgjAKv2T01Utw2vYbvVou6LjB6wQ
         /FkGNcnhx5+HDCEwGcYSZRjUqIoX/L/8N5Vxyp7e8GToFaI1eHtx31VYLxx/6cmYkhFP
         kpIA==
X-Gm-Message-State: AOAM533dr2oaWjYyh46Uoea/4oJiL6F/CGNVeFkO4KTK6UtM0bRNI9Mx
        IDDzHRgmslhHCZtm3/29/tvgfOGF8TlTR+XomvBR2oiqN86CbQ==
X-Google-Smtp-Source: ABdhPJyHOutm7IhSUrxlB647bn71rPS4eTq2fmD+Yj4SebC/S5FaIwxlKX6mZqmjFLIilB3AfcgOPTCGtPnb4TISV/s=
X-Received: by 2002:a81:4f87:0:b0:2e5:dc8f:b4e with SMTP id
 d129-20020a814f87000000b002e5dc8f0b4emr5798434ywb.467.1649238282025; Wed, 06
 Apr 2022 02:44:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1648981570.git.asml.silence@gmail.com>
In-Reply-To: <cover.1648981570.git.asml.silence@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 6 Apr 2022 02:44:30 -0700
Message-ID: <CANn89iL0anmfcX1v1NqOQ6xi2VfY7CmiUwav0jNbz6GuSjUspQ@mail.gmail.com>
Subject: Re: [RFC net-next 00/27] net and/or udp optimisations
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 3, 2022 at 6:08 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> A mix of various net optimisations, which were mostly discovered during UDP
> testing. Benchmarked with an io_uring test using 16B UDP/IPv6 over dummy netdev:
> 2090K vs 2229K tx/s, +6.6%, or in a 4-8% range if not averaging across reboots.
>
> 1-3 removes extra atomics and barriers from sock_wfree() mainly benefitting UDP.
> 4-7 cleans up some zerocopy helpers
> 8-16 do inlining of ipv6 and generic net pathes
> 17 is a small nice performance improvement for TCP zerocopy
> 18-27 refactors UDP to shed some more overhead
>

Please send a smaller series first.

About inlining everything around, make sure to include performance
numbers only for the inline parts.
We can inline everything and make the kernel 4 x time bigger.
Synthetic benchmarks will still show improvements but in overall, we
add icache cost that is going to hurt latencies.
I vote that you focus on the other parts first.

Thank you.

> Pavel Begunkov (27):
>   sock: deduplicate ->sk_wmem_alloc check
>   sock: optimise sock_def_write_space send refcounting
>   sock: optimise sock_def_write_space barriers
>   skbuff: drop zero check from skb_zcopy_set
>   skbuff: drop null check from skb_zcopy
>   net: xen: set zc flags only when there is ubuf
>   skbuff: introduce skb_is_zcopy()
>   skbuff: optimise alloc_skb_with_frags()
>   net: inline sock_alloc_send_skb
>   net: inline part of skb_csum_hwoffload_help
>   net: inline skb_zerocopy_iter_dgram
>   ipv6: inline ip6_local_out()
>   ipv6: help __ip6_finish_output() inlining
>   ipv6: refactor ip6_finish_output2()
>   net: inline dev_queue_xmit()
>   ipv6: partially inline fl6_update_dst()
>   tcp: optimise skb_zerocopy_iter_stream()
>   net: optimise ipcm6 cookie init
>   udp/ipv6: refactor udpv6_sendmsg udplite checks
>   udp/ipv6: move pending section of udpv6_sendmsg
>   udp/ipv6: prioritise the ip6 path over ip4 checks
>   udp/ipv6: optimise udpv6_sendmsg() daddr checks
>   udp/ipv6: optimise out daddr reassignment
>   udp/ipv6: clean up udpv6_sendmsg's saddr init
>   ipv6: refactor opts push in __ip6_make_skb()
>   ipv6: improve opt-less __ip6_make_skb()
>   ipv6: clean up ip6_setup_cork
>
>  drivers/net/xen-netback/interface.c |   3 +-
>  include/linux/netdevice.h           |  27 ++++-
>  include/linux/skbuff.h              | 102 +++++++++++++-----
>  include/net/ipv6.h                  |  37 ++++---
>  include/net/sock.h                  |  10 +-
>  net/core/datagram.c                 |   2 -
>  net/core/datagram.h                 |  15 ---
>  net/core/dev.c                      |  28 ++---
>  net/core/skbuff.c                   |  59 ++++-------
>  net/core/sock.c                     |  50 +++++++--
>  net/ipv4/ip_output.c                |  10 +-
>  net/ipv4/tcp.c                      |   5 +-
>  net/ipv6/datagram.c                 |   4 +-
>  net/ipv6/exthdrs.c                  |  15 ++-
>  net/ipv6/ip6_output.c               |  88 ++++++++--------
>  net/ipv6/output_core.c              |  12 ---
>  net/ipv6/raw.c                      |   8 +-
>  net/ipv6/udp.c                      | 158 +++++++++++++---------------
>  net/l2tp/l2tp_ip6.c                 |   8 +-
>  19 files changed, 339 insertions(+), 302 deletions(-)
>  delete mode 100644 net/core/datagram.h
>
> --
> 2.35.1
>
