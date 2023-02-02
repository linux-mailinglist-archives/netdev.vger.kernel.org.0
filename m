Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3846887FF
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 21:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbjBBUHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 15:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbjBBUHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 15:07:46 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4570583056
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 12:07:37 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id 129so3760855ybb.0
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 12:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xDEYZdI/wrMbO2HOt3MILPHbSid7HbELOPHk0VaQUJA=;
        b=hTXmYLF3wZVdEhrptc9irwVi8hsE39tfWeAIqzgPIuKM5drNXuENAkuzNT8QVc8MH7
         QR9/n5hUb0xvLL4BvJhJonNZEUsImC7hYlipmbWh+8plxbvM9YqFzSIsFwNEBLmBb6I8
         OBTGxBbZXQa3+fMdh63NrswVgX81hjJuMsJi2eGK3mDG5P7uP7KJQD57bgAhOuxhgKoi
         ngl9z+SpElsla82W8qkoIQdx1DQEy/B6p4Vn/Jf7y5s0rAXO0z+nby0i3U/FdpqxOJWL
         D1Gf3ctNGNcehSX2u+7e3cvN+SQNXxmRgsZSW3VmU+gfMq6Pz/6nVyCNuYAjTROvqiLy
         3GeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xDEYZdI/wrMbO2HOt3MILPHbSid7HbELOPHk0VaQUJA=;
        b=XjwDIK7duIFYe/pfFXTjqT/ax8CiIp2Ur4H8g0tLLUtdGv5iidxBgE83kSZQiT/lEy
         leoM0J82I3yQgM5B40Eaukb5hloDRimNsY8SFtzoSG9IheN3YW/nO54JnMfQLbedZebi
         uVW8DVne31+bJhJOyBA4zMREzJ0CITNxzOTP1rlPQ5JVoLZsl6OBb83T+OHUlyQYhlQS
         ep5FS9ffsASlOPg/4x3ljo1W9GHEV56lv8GmsH3e2aV6ICeFqxDY6/UM9er2pORRIvTf
         lFuti2cj/3KMmEoZqfmaCCSKgEB07fN1VxtqdfVNpp0rVd07cc8EvOpKaj/lQNXpmkzP
         ZHhQ==
X-Gm-Message-State: AO0yUKUb4p/juQtKCFdtGfroPq58W5GnziVkaNMFFmev3OGYkXEGTObQ
        50j6hICwFl5Lfr0J63Zo8Hiz7w8R4Z76bfffgSU/hg==
X-Google-Smtp-Source: AK7set9N31p+jiP1eTd0eXvNp9wihTBYhlBvVxY4FXH1nEtcOJFX9jFgcIcJmc0xP5o27N4uwBn/PFIebhq+kOCpblA=
X-Received: by 2002:a25:be8b:0:b0:80b:55ea:1510 with SMTP id
 i11-20020a25be8b000000b0080b55ea1510mr739278ybk.577.1675368456201; Thu, 02
 Feb 2023 12:07:36 -0800 (PST)
MIME-Version: 1.0
References: <20230202185801.4179599-1-edumazet@google.com> <20230202185801.4179599-3-edumazet@google.com>
In-Reply-To: <20230202185801.4179599-3-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Thu, 2 Feb 2023 15:07:00 -0500
Message-ID: <CACSApvbvwd0jMgYK4vYfzxSmvSo1P1Ba2yM0iopxCoPenFqm4Q@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] net: remove osize variable in __alloc_skb()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 2, 2023 at 1:58 PM Eric Dumazet <edumazet@google.com> wrote:
>
> This is a cleanup patch, to prepare following change.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

> ---
>  net/core/skbuff.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index b73de8fb0756c02cf9ba4b7e90854c9c17728463..a82df5289208d69716e60c5c1f201ec3ca50a258 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -533,7 +533,6 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>  {
>         struct kmem_cache *cache;
>         struct sk_buff *skb;
> -       unsigned int osize;
>         bool pfmemalloc;
>         u8 *data;
>
> @@ -559,16 +558,15 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>          * Both skb->head and skb_shared_info are cache line aligned.
>          */
>         size = SKB_HEAD_ALIGN(size);
> -       osize = kmalloc_size_roundup(size);
> -       data = kmalloc_reserve(osize, gfp_mask, node, &pfmemalloc);
> +       size = kmalloc_size_roundup(size);
> +       data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
>         if (unlikely(!data))
>                 goto nodata;
>         /* kmalloc_size_roundup() might give us more room than requested.
>          * Put skb_shared_info exactly at the end of allocated zone,
>          * to allow max possible filling before reallocation.
>          */
> -       size = SKB_WITH_OVERHEAD(osize);
> -       prefetchw(data + size);
> +       prefetchw(data + SKB_WITH_OVERHEAD(size));
>
>         /*
>          * Only clear those fields we need to clear, not those that we will
> @@ -576,7 +574,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>          * the tail pointer in struct sk_buff!
>          */
>         memset(skb, 0, offsetof(struct sk_buff, tail));
> -       __build_skb_around(skb, data, osize);
> +       __build_skb_around(skb, data, size);
>         skb->pfmemalloc = pfmemalloc;
>
>         if (flags & SKB_ALLOC_FCLONE) {
> --
> 2.39.1.456.gfc5497dd1b-goog
>
