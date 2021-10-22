Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF2C437DEC
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 21:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbhJVTLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 15:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234385AbhJVTKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 15:10:15 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29EFCC06122A
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 12:07:57 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id k28so5323786uaa.10
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 12:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fgWUN1OHIjWI5OogyhzfNZuXVbM0hj9vSLCcEyotJYk=;
        b=h+lDyHxQWwa+Cz67u9amJcXlBGLLi3a0jkZ+k05NXACIu422/T+5kCozYvnSfNc/rO
         iJNZz3MjgMrcAnwkaChCQpbwk/UF7AusCvkTYVQytrbW9pVnlSGnzZFC+PxPMNRjTGXI
         wvg07/34R8/5F+nWDyY3t3042imx3FLu4AJB+VBNU5m8xpJvEKYUkgnQ4LyMtDw9p/jY
         Ss+4UMadfVkN4n0WPg4yD9O/jeFqPzuBcikE7bfr1r73VveX+weTmzPEcyWtkla02gbE
         k6WnUNa3mnVWQdbBS5KBWY1+kklyZkdsTEf9u5MDCjcpBufpNktLQSXW/s3bXG9PIuLg
         oxfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fgWUN1OHIjWI5OogyhzfNZuXVbM0hj9vSLCcEyotJYk=;
        b=Co5YgcuN2c+vjqWaqaTkMRP83duTAXyVypvxrVXJb16zfLB4aSIkeGstsPMBB9SHaW
         lP56s/MPZUkSUZYzimf3ZF4UF6kfGRTyRMaVKF9f9/P3xhZWN98iUzurlzNZ1GZOoObD
         dzVEus0/xS2xKoAfgZOVQmGmMwAIlToHht5AiNtIO2kR4iduatrXsq8/zkgHV7bfKvOQ
         aG5iKukln4HyqJcFYFK6YYY600CAIlzRIDI1//Qk5OXrDSHiIna9RoEI3yz+UBtYyD9d
         V/pva4t53U0aeYDqPyTWvFxo6JARH1zLnGrog39fnd2t8tSBA79b3oRZ5oEIZ0rOr4wv
         8VlQ==
X-Gm-Message-State: AOAM531rkWJVHWfiVJZrUbl2VfB/KYVi3Adt/bRXGnJsU1xJPGIZ/s75
        zcRskud1fxEuyr5SYrC86E2erRp1njI=
X-Google-Smtp-Source: ABdhPJwkAd7yg8Y8xEc39fyubd6G2VS0P5/mqY0cpgnTExYpws6NBPp97PuVUd7i082j4Geeb8TU8Q==
X-Received: by 2002:a67:d785:: with SMTP id q5mr2019210vsj.32.1634929676162;
        Fri, 22 Oct 2021 12:07:56 -0700 (PDT)
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com. [209.85.222.41])
        by smtp.gmail.com with ESMTPSA id i17sm311913vko.37.2021.10.22.12.07.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 12:07:55 -0700 (PDT)
Received: by mail-ua1-f41.google.com with SMTP id f3so9592933uap.6
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 12:07:55 -0700 (PDT)
X-Received: by 2002:a67:d504:: with SMTP id l4mr2476330vsj.42.1634929675256;
 Fri, 22 Oct 2021 12:07:55 -0700 (PDT)
MIME-Version: 1.0
References: <20211019114441.1943131-1-cyril.strejc@skoda.cz>
In-Reply-To: <20211019114441.1943131-1-cyril.strejc@skoda.cz>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 22 Oct 2021 15:07:18 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdqS2gpdoXcyo3URn5A=yYCuW55b=grFkmiMbX2hzXcfg@mail.gmail.com>
Message-ID: <CA+FuTSdqS2gpdoXcyo3URn5A=yYCuW55b=grFkmiMbX2hzXcfg@mail.gmail.com>
Subject: Re: [PATCH] net: multicast: calculate csum of looped-back and
 forwarded packets
To:     Cyril Strejc <cyril.strejc@skoda.cz>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 7:46 AM Cyril Strejc <cyril.strejc@skoda.cz> wrote:
>
> During a testing of an user-space application which transmits UDP
> multicast datagrams and utilizes multicast routing to send the UDP
> datagrams out of defined network interfaces, I've found a multicast
> router does not fill-in UDP checksum into locally produced, looped-back
> and forwarded UDP datagrams, if an original output NIC the datagrams
> are sent to has UDP TX checksum offload enabled.
>
> The datagrams are sent malformed out of the NIC the datagrams have been
> forwarded to.
>
> It is because:
>
> 1. If TX checksum offload is enabled on an output NIC, UDP checksum
>    is not calculated by kernel and is not filled into skb data.
>
> 2. dev_loopback_xmit(), which is called solely by
>    ip_mc_finish_output(), sets skb->ip_summed = CHECKSUM_UNNECESSARY
>    unconditionally.
>
> 3. Since 35fc92a9 ("[NET]: Allow forwarding of ip_summed except
>    CHECKSUM_COMPLETE"), the ip_summed value is preserved during
>    forwarding.
>
> 4. If ip_summed != CHECKSUM_PARTIAL, checksum is not calculated during
>    a packet egress.
>
> We could fix this as follows:
>
> 1. Not set CHECKSUM_UNNECESSARY in dev_loopback_xmit(), because it
>    is just not true.

I think this is the right approach. The receive path has to be able to
handle packets looped from the transmit path with CHECKSUM_PARTIAL
set.

> 2. I assume, the original idea behind setting CHECKSUM_UNNECESSARY in
>    dev_loopback_xmit() is to prevent checksum validation of looped-back
>    local multicast packets. We can adjust
>    __skb_checksum_validate_needed() to handle this as the special case.
>
> Signed-off-by: Cyril Strejc <cyril.strejc@skoda.cz>
> ---
>  include/linux/skbuff.h | 4 +++-
>  net/core/dev.c         | 1 -
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 841e2f0f5240..95aa0014c3d6 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -4048,7 +4048,9 @@ static inline bool __skb_checksum_validate_needed(struct sk_buff *skb,
>                                                   bool zero_okay,
>                                                   __sum16 check)
>  {
> -       if (skb_csum_unnecessary(skb) || (zero_okay && !check)) {
> +       if (skb_csum_unnecessary(skb) ||
> +           (zero_okay && !check) ||
> +           skb->pkt_type == PACKET_LOOPBACK) {

This should not be needed, as skb_csum_unnecessary already handles
CHECKSUM_PARTIAL?

        return ((skb->ip_summed == CHECKSUM_UNNECESSARY) ||
                skb->csum_valid ||
                (skb->ip_summed == CHECKSUM_PARTIAL &&
                 skb_checksum_start_offset(skb) >= 0));

>                 skb->csum_valid = 1;
>                 __skb_decr_checksum_unnecessary(skb);
>                 return false;
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 7ee9fecd3aff..ba4a0994d97b 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3906,7 +3906,6 @@ int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
>         skb_reset_mac_header(skb);
>         __skb_pull(skb, skb_network_offset(skb));
>         skb->pkt_type = PACKET_LOOPBACK;
> -       skb->ip_summed = CHECKSUM_UNNECESSARY;
>         WARN_ON(!skb_dst(skb));
>         skb_dst_force(skb);
>         netif_rx_ni(skb);
> --
> 2.25.1
>
