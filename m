Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39E2573983
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 17:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbiGMPBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 11:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236699AbiGMPBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 11:01:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B3D73F31E
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 08:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657724512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dhuEV8wUOrrbYN+eImzoY0DjP06EvLstMjKANkm4Hzw=;
        b=VceB4pot+GDR18rZBAS9zFs0oe0uThipNbL7qwu6HsQtgvmoRrv1wXe0waQ4AREFzfDOTQ
        8iYP1jvhO/e5i7cIhJC+tDu4azFceS9yr/pme0/D6C8mGXHrar+EEq50H7g6VeIFDVoH1d
        2rJ2hCJyUH34VrIgyopqV3ZHNQuDZMM=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457-8jpr48kJNHSrkEveuROIKg-1; Wed, 13 Jul 2022 11:01:50 -0400
X-MC-Unique: 8jpr48kJNHSrkEveuROIKg-1
Received: by mail-ua1-f72.google.com with SMTP id q74-20020a9f37d0000000b00381f3cac330so3529996uaq.16
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 08:01:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dhuEV8wUOrrbYN+eImzoY0DjP06EvLstMjKANkm4Hzw=;
        b=nmehrJmU4/fWqm5JgiFs1nenKQjoU8lIjjj7h6P/H6ClLWsNFVV+8o0pTaysYa89+6
         e6uA6EwZTUiZbE90zXwXEklwqOuqt8E2y2roO5kfCKzwFt5ivqzQtkuX2MeL8qs+EKkQ
         Q/xMXyHkT/1GL9StHDOFcG58MVl6jO9G3ZKb0X95dtnKGJoUxd7aZQzHbj0dZpVyUIFy
         VVw/lLBXxWxzBweGu9GP+6lRgMrYHYIDCw7RwT1ptgHzJr/F56egERc/bAatzeU0EOTM
         NRTeh4PDgBaZRebkozMTq5Ot6Ri0h0ysD69/6ksxLyrn47E0La1XuXTmP4uO2zRUgn34
         3FIA==
X-Gm-Message-State: AJIora/QBOdGwMrHv5+gTN1e3iaZccZUi+opSZKj25GhFXjpBb4IzHP6
        ykmYGSZIgPGcf9QYPeXoOaAawuf6BOHlZXjee21X4fZMtue11ED/s5TgZOZHa3fIDtnaJHuPs9/
        xturdAW966cryeCZ0DVYsA1BEqpIsN9Ty
X-Received: by 2002:a1f:9194:0:b0:374:957c:72ec with SMTP id t142-20020a1f9194000000b00374957c72ecmr1443141vkd.31.1657724509971;
        Wed, 13 Jul 2022 08:01:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u4uXsxD32IGl4rEs3j/A/CnqOaVmQt8vJAYok/b9l/5loZAJB+HJlHjK1hc+xxAfzNXonAcUXWMn56HVzWElc=
X-Received: by 2002:a1f:9194:0:b0:374:957c:72ec with SMTP id
 t142-20020a1f9194000000b00374957c72ecmr1443109vkd.31.1657724509736; Wed, 13
 Jul 2022 08:01:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220713145854.147356-1-mlombard@redhat.com>
In-Reply-To: <20220713145854.147356-1-mlombard@redhat.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Wed, 13 Jul 2022 17:01:38 +0200
Message-ID: <CAFL455m0UAXwLd78Eh=Vq-H6sQTPdmGAOOt2rOM1XtRqsqH=bQ@mail.gmail.com>
Subject: Re: [PATCH] mm: prevent page_frag_alloc() from corrupting the memory
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?5oSa5qCR?= <chen45464546@163.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

st 13. 7. 2022 v 16:59 odes=C3=ADlatel Maurizio Lombardi
<mlombard@redhat.com> napsal:
>
> A number of drivers call page_frag_alloc() with a
> fragment's size > PAGE_SIZE.
> In low memory conditions, __page_frag_cache_refill() may fail the order 3
> cache allocation and fall back to order 0;
> In this case, the cache will be smaller than the fragment, causing
> memory corruptions.

Oops, I didn't modify the subject, I'm going to resend it.

Maurizio

>
> Prevent this from happening by checking if the newly allocated cache
> is large enough for the fragment; if not, the allocation will fail
> and page_frag_alloc() will return NULL.
>
> V2: do not free the cache page because this could make memory pressure
> even worse, just return NULL.
>
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  mm/page_alloc.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e008a3df0485..b1407254a826 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5617,6 +5617,8 @@ void *page_frag_alloc_align(struct page_frag_cache =
*nc,
>                 /* reset page count bias and offset to start of new frag =
*/
>                 nc->pagecnt_bias =3D PAGE_FRAG_CACHE_MAX_SIZE + 1;
>                 offset =3D size - fragsz;
> +               if (unlikely(offset < 0))
> +                       return NULL;
>         }
>
>         nc->pagecnt_bias--;
> --
> 2.31.1
>

