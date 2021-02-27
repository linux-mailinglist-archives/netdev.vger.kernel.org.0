Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C198B326DB8
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 17:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhB0QCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 11:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbhB0QCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 11:02:16 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7C3C06174A
        for <netdev@vger.kernel.org>; Sat, 27 Feb 2021 08:01:35 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id p2so14718686edm.12
        for <netdev@vger.kernel.org>; Sat, 27 Feb 2021 08:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gBDmT6R0gSzg2EHhAFG90ZVi1kIGmvAfZL7Zm2nzhUk=;
        b=Q35yFhUdbIOCtZmJ9E4ixEEmqXfRYp4xkS8/aLMwoiufXvLjXmp5rNM9QEk1bl9H9M
         qmb7v2bE1Dlz6s3hdhIH3YiKh9+5zsbBYvXKRcHieY1N9Ab2TDczgObYKmPgByIvVQYd
         359umZCOEB8YTl05eviZLltfOhOruF9lLVrAS7vTxQTyzR2HPYU5YEYQH7IDZo5I09hZ
         WdV7j8EVyz3Pef63P/BeDC92xB7DT63oOXFgNG6IT/KxDQHVc+l+lP5jYqb0nPz6Z+7k
         O26oKChzvhiXPc+7TCGG3lKAdzl2W1I9/1h6ixMSl22B61Yx8NJsjMLCMWrw8nH6yML1
         6Fnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gBDmT6R0gSzg2EHhAFG90ZVi1kIGmvAfZL7Zm2nzhUk=;
        b=ejy7xEH8ro0kxvsA1QMeRXnX5bYQhgsk63z2ezufxZKWk074SdD1FtucW/7QRkEHVx
         cg6lVLcpbqHtnydKHGrrQpsu5HAw1ssYayNPF8uzDLUwtaXZLRM/YZf0P3mWYx1RFrHg
         83ZFBc3JBagps9QESsbSMCwHYtXyauIKDSlpberg3Jt5IaR5/c9IAVb25YLb/fZk63rw
         DimgB/G5xp/ncuN0Zu9uYQgOYIva5iZHbGobfSvYrpf2GrbrKXj6iHf8Y9bxN7XGBI+N
         JoSTae+mL7JCRNL+GV6FJiEc2w85SrK7FBvfAQ+X4GkLBxP0JiFH7hzU87rAKcMscNwD
         /dgA==
X-Gm-Message-State: AOAM5329XOSAFFo4aGuA/0Cf22MRzE3z83pw7w4wpZBUY2blnfbBrTbI
        MLfl6Ey3nIZP3hOp8BpRhGaO6/N6TxE=
X-Google-Smtp-Source: ABdhPJxXNcZ65s9OqWtRZL9Ccl/EkU8Gpv8qzZmypKWiXpNGDnrV0sN1k4fpf+ihdG9SuYUep/x7JA==
X-Received: by 2002:a05:6402:1854:: with SMTP id v20mr8490791edy.56.1614441694264;
        Sat, 27 Feb 2021 08:01:34 -0800 (PST)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id j18sm267276edr.6.2021.02.27.08.01.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Feb 2021 08:01:33 -0800 (PST)
Received: by mail-wm1-f50.google.com with SMTP id u187so7825626wmg.4
        for <netdev@vger.kernel.org>; Sat, 27 Feb 2021 08:01:32 -0800 (PST)
X-Received: by 2002:a7b:c5d6:: with SMTP id n22mr7655535wmk.70.1614441692561;
 Sat, 27 Feb 2021 08:01:32 -0800 (PST)
MIME-Version: 1.0
References: <20210226212248.8300-1-daniel@iogearbox.net>
In-Reply-To: <20210226212248.8300-1-daniel@iogearbox.net>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 27 Feb 2021 11:00:55 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdn3zbynYOvuhLxZ02mmcDoRWQ5vUmBCbAgxeTa2X33YQ@mail.gmail.com>
Message-ID: <CA+FuTSdn3zbynYOvuhLxZ02mmcDoRWQ5vUmBCbAgxeTa2X33YQ@mail.gmail.com>
Subject: Re: [PATCH net] net: Fix gro aggregation for udp encaps with zero csum
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tom Herbert <tom@herbertland.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 4:23 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> We noticed a GRO issue for UDP-based encaps such as vxlan/geneve when the
> csum for the UDP header itself is 0. In that case, GRO aggregation does
> not take place on the phys dev, but instead is deferred to the vxlan/geneve
> driver (see trace below).
>
> The reason is essentially that GRO aggregation bails out in udp_gro_receive()
> for such case when drivers marked the skb with CHECKSUM_UNNECESSARY (ice, i40e,
> others) where for non-zero csums 2abb7cdc0dc8 ("udp: Add support for doing
> checksum unnecessary conversion") promotes those skbs to CHECKSUM_COMPLETE
> and napi context has csum_valid set. This is however not the case for zero
> UDP csum (here: csum_cnt is still 0 and csum_valid continues to be false).
>
> At the same time 57c67ff4bd92 ("udp: additional GRO support") added matches
> on !uh->check ^ !uh2->check as part to determine candidates for aggregation,
> so it certainly is expected to handle zero csums in udp_gro_receive(). The
> purpose of the check added via 662880f44203 ("net: Allow GRO to use and set
> levels of checksum unnecessary") seems to catch bad csum and stop aggregation
> right away.
>
> One way to fix aggregation in the zero case is to only perform the !csum_valid
> check in udp_gro_receive() if uh->check is infact non-zero.
>
> Before:
>
>   [...]
>   swapper     0 [008]   731.946506: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100400 len=1500   (1)
>   swapper     0 [008]   731.946507: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100200 len=1500
>   swapper     0 [008]   731.946507: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101100 len=1500
>   swapper     0 [008]   731.946508: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101700 len=1500
>   swapper     0 [008]   731.946508: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101b00 len=1500
>   swapper     0 [008]   731.946508: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100600 len=1500
>   swapper     0 [008]   731.946508: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100f00 len=1500
>   swapper     0 [008]   731.946509: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100a00 len=1500
>   swapper     0 [008]   731.946516: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100500 len=1500
>   swapper     0 [008]   731.946516: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100700 len=1500
>   swapper     0 [008]   731.946516: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101d00 len=1500   (2)
>   swapper     0 [008]   731.946517: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101000 len=1500
>   swapper     0 [008]   731.946517: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101c00 len=1500
>   swapper     0 [008]   731.946517: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101400 len=1500
>   swapper     0 [008]   731.946518: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100e00 len=1500
>   swapper     0 [008]   731.946518: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101600 len=1500
>   swapper     0 [008]   731.946521: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100800 len=774
>   swapper     0 [008]   731.946530: net:netif_receive_skb: dev=test_vxlan skbaddr=0xffff966497100400 len=14032 (1)
>   swapper     0 [008]   731.946530: net:netif_receive_skb: dev=test_vxlan skbaddr=0xffff966497101d00 len=9112  (2)
>   [...]
>
>   # netperf -H 10.55.10.4 -t TCP_STREAM -l 20
>   MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.55.10.4 () port 0 AF_INET : demo
>   Recv   Send    Send
>   Socket Socket  Message  Elapsed
>   Size   Size    Size     Time     Throughput
>   bytes  bytes   bytes    secs.    10^6bits/sec
>
>    87380  16384  16384    20.01    13129.24
>
> After:
>
>   [...]
>   swapper     0 [026]   521.862641: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff93ab0d479000 len=11286 (1)
>   swapper     0 [026]   521.862643: net:netif_receive_skb: dev=test_vxlan skbaddr=0xffff93ab0d479000 len=11236 (1)
>   swapper     0 [026]   521.862650: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff93ab0d478500 len=2898  (2)
>   swapper     0 [026]   521.862650: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff93ab0d479f00 len=8490  (3)
>   swapper     0 [026]   521.862653: net:netif_receive_skb: dev=test_vxlan skbaddr=0xffff93ab0d478500 len=2848  (2)
>   swapper     0 [026]   521.862653: net:netif_receive_skb: dev=test_vxlan skbaddr=0xffff93ab0d479f00 len=8440  (3)
>   [...]
>
>   # netperf -H 10.55.10.4 -t TCP_STREAM -l 20
>   MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.55.10.4 () port 0 AF_INET : demo
>   Recv   Send    Send
>   Socket Socket  Message  Elapsed
>   Size   Size    Size     Time     Throughput
>   bytes  bytes   bytes    secs.    10^6bits/sec
>
>    87380  16384  16384    20.01    24576.53
>
> Fixes: 57c67ff4bd92 ("udp: additional GRO support")
> Fixes: 662880f44203 ("net: Allow GRO to use and set levels of checksum unnecessary")
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Tom Herbert <tom@herbertland.com>

Makes sense to me.

We cannot do checksum conversion with zero field, but that does not
have to limit coalescing.

CHECKSUM_COMPLETE with a checksum validated by
skb_gro_checksum_validate_zero_check implies csum_valid.

So the test

>             (skb->ip_summed != CHECKSUM_PARTIAL &&
>              NAPI_GRO_CB(skb)->csum_cnt == 0 &&
>              !NAPI_GRO_CB(skb)->csum_valid) ||

Basically matches

- CHECKSUM_NONE
- CHECKSUM_UNNECESSARY which has already used up its valid state on a
prior header
- CHECKSUM_COMPLETE with bad checksum.

This change just refines to not drop for in the first two cases on a
zero checksum field.

Making this explicit in case anyone sees holes in the logic. Else,

Acked-by: Willem de Bruijn <willemb@google.com>
