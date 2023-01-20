Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01BF56752F6
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 12:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjATLFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 06:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjATLFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 06:05:18 -0500
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5EB23C79
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 03:05:17 -0800 (PST)
Received: by mail-ua1-x92f.google.com with SMTP id j1so1265233uan.1
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 03:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1jYIJWLs9QCq84CWLVp1YUpueMsxtYqSBrgVdPAML2s=;
        b=iHlPNW+HuprcT0GEJ9m5jhoIpBkuPWrzXjQm/vv+tO+KV0hPZBCvH1PGlHCzU9ZcxX
         hPChPbzkosdQXdv2uykLGbrFZf86dT9KBP6tGfZSdjKLUCRKCugOkM/9uIpJwRTuM9Vy
         xNLBm3qf616DDJZpfDfPd56Nx835Ewip1+pDAK8n/zfPXFsKm2gohG9Fwr00tvo5bo2y
         e2o3crQOWKqxKlkZGVuaLgs8zEXw8m3Ol3rbI9mxpiT24FV5a+XErWfRW1erFIAI6B6H
         rWDm/u4YgFgZdSZN+aJDaZYpO9xMMCtcFu6hH2elc3Qrrpqe6+PDEMZaElLOpsu0fjul
         9/Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1jYIJWLs9QCq84CWLVp1YUpueMsxtYqSBrgVdPAML2s=;
        b=zW/MKM0Mt/VD8IicDBlcGZbJOJJmDVbThIFWkGPC0A60MVI8I8/ZNYr8dgHObVDmsQ
         Y+1/4D9fYaVt+w/u0chQ86kjQ+wB6CMR/at4JGkWks8x6TfHIP43i191S1TKZxLO/UvO
         xvCKQM1IwYTUS/8XfgkwKrWzfZVeU+IikbKxtQvLIEuqP9ftCJH0OC5Z8pviY4qpUjQL
         x5bFTRSxpv6jr63IvIomRuI4VyCKIhJkaRfbnDzn3B0Pz4DwqpzkFdPTZHcSSpRmsdVR
         nGjndnhfI5xAAXaOYdVIXkZ+ilDotHhaJgX7aHCk0qCZSxHiyDyeQ+SIRu+hI2Bqd7Ix
         FpGQ==
X-Gm-Message-State: AFqh2ko8NoVWMsFb+sMfemTdYZN6bnzm9lTZRET7LM02r7KQQ3yKkwdm
        SXVCGSw145JdwaEAuSFgQLmL5OzRpKy4dhz/Sss=
X-Google-Smtp-Source: AMrXdXu6M+emxxdmQfV2TAMJ6IJhTpPod0VZ48VxhbBCvCxy+byI+COoi/ZuFgqL4FIGWhl8322Eel2rmkmwtMxzxNU=
X-Received: by 2002:ab0:14f0:0:b0:5e6:9cc2:a7b1 with SMTP id
 f45-20020ab014f0000000b005e69cc2a7b1mr1721751uae.3.1674212716302; Fri, 20 Jan
 2023 03:05:16 -0800 (PST)
MIME-Version: 1.0
References: <6dfd03c5fa0afb99f255f4a35772df19e33880db.1674156645.git.antony.antony@secunet.com>
In-Reply-To: <6dfd03c5fa0afb99f255f4a35772df19e33880db.1674156645.git.antony.antony@secunet.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Fri, 20 Jan 2023 13:05:04 +0200
Message-ID: <CAHsH6GtgcffudgDzyTv8f8CZC13ZKMeU886DLHuuj0Tu73Ppfg@mail.gmail.com>
Subject: Re: [PATCH 1/3] xfrm: Use the XFRM_GRO to indicate a GRO call on input.
To:     antony.antony@secunet.com
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Jan 19, 2023 at 9:59 PM Antony Antony <antony.antony@secunet.com> wrote:
>
> From: Steffen Klassert <steffen.klassert@secunet.com>
>
> This is needed to support GRO for ESP in UDP encapsulation.
>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Antony Antony <antony.antony@secunet.com>
> ---
>  net/ipv4/esp4_offload.c |  2 +-
>  net/ipv6/esp6_offload.c |  2 +-
>  net/xfrm/xfrm_input.c   | 75 +++++++++++++++++++++++------------------
>  3 files changed, 44 insertions(+), 35 deletions(-)
>
> diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
> index 3969fa805679..77bb01032667 100644
> --- a/net/ipv4/esp4_offload.c
> +++ b/net/ipv4/esp4_offload.c
> @@ -76,7 +76,7 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
>
>         /* We don't need to handle errors from xfrm_input, it does all
>          * the error handling and frees the resources on error. */
> -       xfrm_input(skb, IPPROTO_ESP, spi, -2);
> +       xfrm_input(skb, IPPROTO_ESP, spi, 0);
>
>         return ERR_PTR(-EINPROGRESS);
>  out_reset:
> diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
> index 75c02992c520..ee5f5abdb503 100644
> --- a/net/ipv6/esp6_offload.c
> +++ b/net/ipv6/esp6_offload.c
> @@ -103,7 +103,7 @@ static struct sk_buff *esp6_gro_receive(struct list_head *head,
>
>         /* We don't need to handle errors from xfrm_input, it does all
>          * the error handling and frees the resources on error. */
> -       xfrm_input(skb, IPPROTO_ESP, spi, -2);
> +       xfrm_input(skb, IPPROTO_ESP, spi, 0);
>
>         return ERR_PTR(-EINPROGRESS);
>  out_reset:
> diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
> index c06e54a10540..ffd62ad58207 100644
> --- a/net/xfrm/xfrm_input.c
> +++ b/net/xfrm/xfrm_input.c
> @@ -458,6 +458,35 @@ static int xfrm_inner_mode_input(struct xfrm_state *x,
>         return -EOPNOTSUPP;
>  }
>
> +static int xfrm_input_check_offload(struct net *net, struct sk_buff *skb,
> +                                   struct xfrm_state *x,
> +                                   struct xfrm_offload *xo)
> +{
> +       if (!(xo->status & CRYPTO_SUCCESS)) {
> +               if (xo->status &
> +                   (CRYPTO_TRANSPORT_AH_AUTH_FAILED |
> +                    CRYPTO_TRANSPORT_ESP_AUTH_FAILED |
> +                    CRYPTO_TUNNEL_AH_AUTH_FAILED |
> +                    CRYPTO_TUNNEL_ESP_AUTH_FAILED)) {
> +                       xfrm_audit_state_icvfail(x, skb,
> +                                                x->type->proto);
> +                       x->stats.integrity_failed++;
> +                       XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEPROTOERROR);
> +                       return -EINVAL;
> +               }
> +
> +               if (xo->status & CRYPTO_INVALID_PROTOCOL) {
> +                       XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEPROTOERROR);
> +                       return -EINVAL;
> +               }
> +
> +               XFRM_INC_STATS(net, LINUX_MIB_XFRMINBUFFERERROR);
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
>  int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
>  {
>         const struct xfrm_state_afinfo *afinfo;
> @@ -477,7 +506,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
>         struct xfrm_offload *xo = xfrm_offload(skb);
>         struct sec_path *sp;
>
> -       if (encap_type < 0) {
> +       if (encap_type < 0 || (xo && xo->flags & XFRM_GRO)) {
>                 x = xfrm_input_state(skb);
>
>                 if (unlikely(x->km.state != XFRM_STATE_VALID)) {
> @@ -495,46 +524,26 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
>                 family = x->outer_mode.family;
>
>                 /* An encap_type of -1 indicates async resumption. */
> -               if (encap_type == -1) {
> +               if (encap_type  < 0) {

Why is this specific line change needed? I see that now -2 is not sent
anymore, so how is this related?
If it is needed, maybe the comment above also needs updating?

nit, a cover letter would've been handy so that the series could be
fetched as a whole.

Eyal.
