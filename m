Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66235690A2
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 19:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbiGFRZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 13:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbiGFRZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 13:25:25 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526D426C4;
        Wed,  6 Jul 2022 10:25:25 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id k14so19198962qtm.3;
        Wed, 06 Jul 2022 10:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1fIHeM0uxdp3Ui+/JrmilPOmEWzb9jv+N0EpR7/VxRc=;
        b=mVIEIT75n7lUK4XsLc6iFHXGGcHjcdlejm7mDEKrvBxJbP4Dmd2iQiu1w4THOdW5OF
         z9/YtT3SID/x14cCxMbTSUKF62HmCqxgxLsTqFv1Mpy2AOpFP47q8e7R7A3hofi6Kja+
         Agq7qOKS2ppnYxB8YjeSxWgxvCURRxK3ekJFQkVGPH48zC3h23aeOszjURB3o2rjy/1S
         d7TnjuABiWX4v8PES9on1i2UjuAdlVf/ChV5jQ8LjKNBtvz6D3SpcjCOplvch3KmFeSD
         J1zG5Rb29IKTlZSEemE3TDIkaryqz10kceBVERd6wiPnp6RF3vb6ud+4yXhOJrOCv0pn
         M2Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1fIHeM0uxdp3Ui+/JrmilPOmEWzb9jv+N0EpR7/VxRc=;
        b=yY0sAydlhsfAzhc4uEv5nTNRQb2ti2dtLEGArhLsmuwQPCSIolcEY+pXdhkQDmX76Q
         DVdWh4w0JWyhwJf+iVzbaesA0ow0dvP/5hkdmVtWqe06JE4QefKKmm//15qr6ndFTtfw
         WEq8Ozn3Bx3vn3UT7ePbgBb3bUF+HQTGskwHaUShJ92BZapliIhmKwdzKpjolimgBsZl
         VIr8VDaGL4Jlmks+PnXdgoiAgJNOE1Sjf0yjJYCcKulIaXhdweuXn4RpDNlfC0/OY1/d
         i9ZiDRT8Z5cQgy95055dUelxGa1kkqAxM2vHrkWV0Cq/FIyyp/kwSCj+88hAM16MQdvY
         SKsg==
X-Gm-Message-State: AJIora/9OcHJkbirqGYZ1le2kHVjsgxWafKemCqUtejlV7h4EK0s+r69
        Q+xCtiXW6o52SAxKkhcPfb5R5LGDsNmWuu1anNg=
X-Google-Smtp-Source: AGRyM1vKLScP8qkQUvbwzm7GaCro1+LLJx8oVNci2ZIUn0/1OsswufkaYY1A+4qXMnhkwu+Xyf4FGy7PTZyT3avOO5Y=
X-Received: by 2002:a05:622a:34a:b0:31b:5a46:8783 with SMTP id
 r10-20020a05622a034a00b0031b5a468783mr33409026qtw.326.1657128324338; Wed, 06
 Jul 2022 10:25:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220706160021.10710-1-matthias.may@westermo.com>
In-Reply-To: <20220706160021.10710-1-matthias.may@westermo.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Wed, 6 Jul 2022 20:25:12 +0300
Message-ID: <CAHsH6GsuY1MJzgVV+X8xtt7wkj65bW_7jzBRxtpGQw=Y9EfXjQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] ip_tunnel: allow to inherit from VLAN
 encapsulated IP frames
To:     Matthias May <matthias.may@westermo.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Jul 6, 2022 at 7:54 PM Matthias May <matthias.may@westermo.com> wrote:
>
> The current code allows to inherit the TOS, TTL, DF from the payload
> when skb->protocol is ETH_P_IP or ETH_P_IPV6.
> However when the payload is VLAN encapsulated (e.g because the tunnel
> is of type GRETAP), then this inheriting does not work, because the
> visible skb->protocol is of type ETH_P_8021Q.
>
> Add a check on ETH_P_8021Q and subsequently check the payload protocol.
>
> Signed-off-by: Matthias May <matthias.may@westermo.com>
> ---
> v1 -> v2:
>  - Add support for ETH_P_8021AD as suggested by Jakub Kicinski.
> ---
>  net/ipv4/ip_tunnel.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
>
> diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
> index 94017a8c3994..bdcc0f1e83c8 100644
> --- a/net/ipv4/ip_tunnel.c
> +++ b/net/ipv4/ip_tunnel.c
> @@ -648,6 +648,13 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
>         u8 tos, ttl;
>         __be32 dst;
>         __be16 df;
> +       __be16 *payload_protocol;
> +
> +       if (skb->protocol == htons(ETH_P_8021Q) ||
> +           skb->protocol == htons(ETH_P_8021AD))
> +               payload_protocol = (__be16 *)(skb->head + skb->network_header - 2);
> +       else
> +               payload_protocol = &skb->protocol;

Maybe it's better to use skb_protocol(skb, true) here instead of open
coding the vlan parsing?

Eyal
