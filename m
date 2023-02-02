Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E09D6887FB
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 21:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjBBUGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 15:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbjBBUGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 15:06:54 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68A074C19
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 12:06:53 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id d132so3709138ybb.5
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 12:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mHQvIeUMGfUs/L2ldFD35zZVNpJ7Jjl1WFzw/DjcsIk=;
        b=ThrBCSjIh90nSTWtaRrRR0al0PZ5x1Zr145xD2UDVk5E7dANm4TO88azJadnfwVymp
         OPVN9byyJa1lV4mEOx/6USjdwR3XY/L8A7G+apatllzo6kur7fGGw0TBVnSpDJDAfoCr
         lzfa6XxR16eoX4Osc8KajdZBD6TdR0cwJ3l40vVRjUD2Fjid2PV1wUASpB5WatRXjdUB
         SWypOr2+k6UHdlQnaQaHKAJ3vDdNJP74udkPdTF8oR/DasgulWUW1LTXGEjwM+EHvwqk
         zRFSQ8dPOzu+++r/zbujtiiSowrvyds8TNbvpgyrDGGFam3xkBLmFl8n6Z7FS6E0ARHw
         5IVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mHQvIeUMGfUs/L2ldFD35zZVNpJ7Jjl1WFzw/DjcsIk=;
        b=m08ar9Uk2tuIWVs/PncaaUvscXgW87VbunebosX/Hqa4w96ccotgzDTJHd7CVLkUyk
         bXYiC2VkPaCM0ZCRNPbZuo5d6yJ2o7kKtlxuRazZkd6gIk4qIRVwNrOB2pjZ0FXV+uLk
         rca1CaDqFBSmbvJj4ewV60R/pg1DAmyC+hTfiq+gBzb4eJd/FgcyBoEjU+eH05LQwkHR
         BD5AH++YK5AorzUpA1XAQQ6HoPWkYax+kdmUR1Ebt1bm1Qb44jNxywJnbDdXm6Vm7+xW
         nk8r5L/9KWdAOG5z6187FP6CxSMODOgwmplJBGxHNKgfUzp20nnBZp+sVZUC1yZxdu3r
         rj2w==
X-Gm-Message-State: AO0yUKVGxSdYdMR1d5bIHx5P8FyqsMneMYpRuhf+SISXmAcqWPpeD9JI
        u6mfJcJl0iq6d+vfOKhbR9kyAjdc27l8OKL3a8QrYA==
X-Google-Smtp-Source: AK7set/Ap3LBu52x6St3VCoVOyg/775lfXhxOGfH1agE4tq0EIw5LkV3dWnujTWLjinIsCgZHto9yfky41JdZ67sSpo=
X-Received: by 2002:a25:230e:0:b0:707:3f66:a611 with SMTP id
 j14-20020a25230e000000b007073f66a611mr1236195ybj.216.1675368412764; Thu, 02
 Feb 2023 12:06:52 -0800 (PST)
MIME-Version: 1.0
References: <20230202185801.4179599-1-edumazet@google.com> <20230202185801.4179599-2-edumazet@google.com>
In-Reply-To: <20230202185801.4179599-2-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Thu, 2 Feb 2023 15:06:16 -0500
Message-ID: <CACSApva-KiggMGcmZL9JT7qWD5rRb0AS-rjy-wrH2j28ZKc39w@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4] net: add SKB_HEAD_ALIGN() helper
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
> We have many places using this expression:
>
>  SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
>
> Use of SKB_HEAD_ALIGN() will allow to clean them.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

> ---
>  include/linux/skbuff.h |  8 ++++++++
>  net/core/skbuff.c      | 18 ++++++------------
>  2 files changed, 14 insertions(+), 12 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 5ba12185f43e311e37c9045763c3ee0efc274f2a..f2141b7e3940cee060e8443dbaa147b843eb43a0 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -255,6 +255,14 @@
>  #define SKB_DATA_ALIGN(X)      ALIGN(X, SMP_CACHE_BYTES)
>  #define SKB_WITH_OVERHEAD(X)   \
>         ((X) - SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
> +
> +/* For X bytes available in skb->head, what is the minimal
> + * allocation needed, knowing struct skb_shared_info needs
> + * to be aligned.
> + */
> +#define SKB_HEAD_ALIGN(X) (SKB_DATA_ALIGN(X) + \
> +       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
> +
>  #define SKB_MAX_ORDER(X, ORDER) \
>         SKB_WITH_OVERHEAD((PAGE_SIZE << (ORDER)) - (X))
>  #define SKB_MAX_HEAD(X)                (SKB_MAX_ORDER((X), 0))
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index bb79b4cb89db344d23609f93b2bcca5103f1e92d..b73de8fb0756c02cf9ba4b7e90854c9c17728463 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -558,8 +558,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>          * aligned memory blocks, unless SLUB/SLAB debug is enabled.
>          * Both skb->head and skb_shared_info are cache line aligned.
>          */
> -       size = SKB_DATA_ALIGN(size);
> -       size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +       size = SKB_HEAD_ALIGN(size);
>         osize = kmalloc_size_roundup(size);
>         data = kmalloc_reserve(osize, gfp_mask, node, &pfmemalloc);
>         if (unlikely(!data))
> @@ -632,8 +631,7 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int len,
>                 goto skb_success;
>         }
>
> -       len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> -       len = SKB_DATA_ALIGN(len);
> +       len = SKB_HEAD_ALIGN(len);
>
>         if (sk_memalloc_socks())
>                 gfp_mask |= __GFP_MEMALLOC;
> @@ -732,8 +730,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
>                 data = page_frag_alloc_1k(&nc->page_small, gfp_mask);
>                 pfmemalloc = NAPI_SMALL_PAGE_PFMEMALLOC(nc->page_small);
>         } else {
> -               len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> -               len = SKB_DATA_ALIGN(len);
> +               len = SKB_HEAD_ALIGN(len);
>
>                 data = page_frag_alloc(&nc->page, len, gfp_mask);
>                 pfmemalloc = nc->page.pfmemalloc;
> @@ -1936,8 +1933,7 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
>         if (skb_pfmemalloc(skb))
>                 gfp_mask |= __GFP_MEMALLOC;
>
> -       size = SKB_DATA_ALIGN(size);
> -       size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +       size = SKB_HEAD_ALIGN(size);
>         size = kmalloc_size_roundup(size);
>         data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
>         if (!data)
> @@ -6288,8 +6284,7 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
>         if (skb_pfmemalloc(skb))
>                 gfp_mask |= __GFP_MEMALLOC;
>
> -       size = SKB_DATA_ALIGN(size);
> -       size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +       size = SKB_HEAD_ALIGN(size);
>         size = kmalloc_size_roundup(size);
>         data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
>         if (!data)
> @@ -6407,8 +6402,7 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
>         if (skb_pfmemalloc(skb))
>                 gfp_mask |= __GFP_MEMALLOC;
>
> -       size = SKB_DATA_ALIGN(size);
> -       size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +       size = SKB_HEAD_ALIGN(size);
>         size = kmalloc_size_roundup(size);
>         data = kmalloc_reserve(size, gfp_mask, NUMA_NO_NODE, NULL);
>         if (!data)
> --
> 2.39.1.456.gfc5497dd1b-goog
>
