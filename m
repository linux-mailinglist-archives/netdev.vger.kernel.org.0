Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13B8578448
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 15:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235493AbiGRNu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 09:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiGRNuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 09:50:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BE31C26AEF
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 06:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658152253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4BCVM5Y1TUNST7laSoOUsYzA69zl5+oV0vJFLfHEP9Y=;
        b=CBE2Ua0j/du0usC9FGfX8h+FgJbYL1VuqwJBKVNxD9kH+P70ukpW/kGwktohhppwXJBQND
        8GElENs02roZ5DTgSXypIvUIiUhCVvwefgW/g4A9lkpqjMQ2Jg28eyXQxafPmZuDDEPJfX
        oPwq2ezmRxWMLzbh8OSWXIoT9JprQQg=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-Inr-9I6RNry-ViuRTwTmOg-1; Mon, 18 Jul 2022 09:50:52 -0400
X-MC-Unique: Inr-9I6RNry-ViuRTwTmOg-1
Received: by mail-vk1-f199.google.com with SMTP id b85-20020a1f1b58000000b00374e93c2d96so780829vkb.8
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 06:50:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4BCVM5Y1TUNST7laSoOUsYzA69zl5+oV0vJFLfHEP9Y=;
        b=IHxN5FoSz8bpoxG0lzOxxP3Dy8ZezgMS7RWyq/hAHftuCP/icz7sa656gQs7rYGD5S
         Z68og+eISq67Lru99d2DXfGrwez2Lmm8TleClZz9ilWTUmay9bUVSQqMzaJZ2nEm5Fdo
         tldNHiiD2vCJbXbbC2Vtjli52yL8RGJxELGnvx9aryOKHt+uXsLRTAawJ7rVuLoVXH3L
         ELpoQBKLxvReorBvXsgfXIbBUDxxg5r//mPO1a+D0PA34fy5+lTpEb5ANe/pdDYBG2KG
         k6AzRcKMB+ZItwEs91VVfcylmJ3XJPixpsk+c8JVGshqwWVdBS8FKrRh3UuGc9Qfzcxp
         eDOQ==
X-Gm-Message-State: AJIora8hwQOS0iczHOtH7Y9qS9/SeoffyArRhoUw5AtR95A+Aprwk/zh
        48GZG2J4//Ok+WpgFrX2ChhBzID4N+e1JZ0DhIJaOQy4c/YnrCmaDkPYNDB3jBR2mMExH1fxjGB
        GrdxlLxf2o9GuEATWU/rRBh42ZHhZjBmM
X-Received: by 2002:a05:6102:346:b0:357:79f5:63ae with SMTP id e6-20020a056102034600b0035779f563aemr9672751vsa.40.1658152252226;
        Mon, 18 Jul 2022 06:50:52 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sgbUR94wPuXBZzUmzxCn3XWmRF1dK3R0CKv/4UZnqZBKYECuZ4sLNg43x33SuOCYvWn7NSHakhNpWzDy7YC6c=
X-Received: by 2002:a05:6102:346:b0:357:79f5:63ae with SMTP id
 e6-20020a056102034600b0035779f563aemr9672738vsa.40.1658152251972; Mon, 18 Jul
 2022 06:50:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220715125013.247085-1-mlombard@redhat.com> <5a469c5a.8b85.1821171d9de.Coremail.chen45464546@163.com>
In-Reply-To: <5a469c5a.8b85.1821171d9de.Coremail.chen45464546@163.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Mon, 18 Jul 2022 15:50:41 +0200
Message-ID: <CAFL455nnc04q8TohH+Qbv36Bo3=KKxMWr=diK_F5Ds5K-h5etw@mail.gmail.com>
Subject: Re: [PATCH V3] mm: prevent page_frag_alloc() from corrupting the memory
To:     Chen Lin <chen45464546@163.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

po 18. 7. 2022 v 15:14 odes=C3=ADlatel Chen Lin <chen45464546@163.com> naps=
al:
> ----------------------------------------
> If we can accept adding a branch to this process, why not add it at the b=
eginning like below?
> The below changes are also more in line with the definition of "page frag=
ment",
> which i mean the above changes may make the allocation of more than one p=
age successful.
>
> index 7a28f7d..9d09ea5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5551,6 +5551,8 @@ void *page_frag_alloc_align(struct page_frag_cache =
*nc,
>
>         offset =3D nc->offset - fragsz;
>         if (unlikely(offset < 0)) {
> +               if (unlikely(fragsz > PAGE_SIZE))
> +                       return NULL;
>                 page =3D virt_to_page(nc->va);
>
>                 if (!page_ref_sub_and_test(page, nc->pagecnt_bias))
>

This will make *all* page_frag_alloc() calls with fragsz > PAGE_SIZE
fail, so it will
basically break all those drivers that are relying on the current behaviour=
.
With my patch it will return NULL only if the cache isn't big enough.

Maurizio.

