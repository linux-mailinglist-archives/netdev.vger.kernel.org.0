Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFCF656B40D
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 10:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237448AbiGHIHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 04:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237307AbiGHIHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 04:07:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB4AA8048F
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 01:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657267637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HLYylxtBEzg+YALLvd9LbEGO9M2fLeX5WQLfMpASEEo=;
        b=TEvgv/BaQZ8HKDL8ZbMlrl3AN2DjAN9B6fxZ9irmsH/mR42Lc68FTluRptGh/ZYgD1RceI
        GbH7RuIoaDMcBA3NC5pZsmWNcwWCj09JijL8Fk8aZi2wAwDaV/vC+qYtb8YpO4ogZxoWOT
        dwp55styo6mkHk4IARm5XgdUL/bn6qA=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-ifSgg-i-OWC7u6l0L9GS6g-1; Fri, 08 Jul 2022 04:07:04 -0400
X-MC-Unique: ifSgg-i-OWC7u6l0L9GS6g-1
Received: by mail-ua1-f70.google.com with SMTP id b10-20020ab0238a000000b0037efa0a4ba0so6146651uan.11
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 01:07:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HLYylxtBEzg+YALLvd9LbEGO9M2fLeX5WQLfMpASEEo=;
        b=FUiwtAkQWIWTogiiKDeqqXxTFvDfiIjbByNSkoWEirf3kxBYiHa4k+FbLkX4+BeQug
         kDCdoVRIaDx7XKQXBFlmfmbHeQMIIDg4vNGQPGoaELMV7Ks5v3RFaThs6SHXQSM/VcEr
         R+J1HokauuDjafvL8tU4+dq5hy5FXL0PIPLgEdA+kTqq1XD08VGAU/JLPZ3u/WQOkFLb
         xIjDz99q7L+woG8YNQ0dQtIr1kuz2o1i2Xvvz6Vxgv+Dg7Z6HBAF57a1k/M7Sf5lC/vK
         P1Uu6ep0LEuQE50wvUgQNCpIa0SPJhjhuxWYtdDEfKScYGsb15hyMQ4H85V78/g4WUAX
         vqcw==
X-Gm-Message-State: AJIora/pTyJFzvvX9D+kZQvb5qdXMGEQWO63Hrc3SZTbci+XlYH7w73b
        fi5bD++1MvFwn5l3+vQfKZes2CATGRhuAqSU2lRj63vruFxdfOlKji4rvrgZoEBbX7AIi2rzqKT
        KDdoebm20AdlLQJr1eFE6kSn5/XQoXx2T
X-Received: by 2002:a67:c894:0:b0:324:c5da:a9b5 with SMTP id v20-20020a67c894000000b00324c5daa9b5mr806347vsk.33.1657267624146;
        Fri, 08 Jul 2022 01:07:04 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vtSsw27PcDf3CxP61G0rXLMhfXJ7efh8iTUreeYkPunA27DUyKMkZxBK+PdSsgScu9YO7PPUz6YnRJa2vV24Y=
X-Received: by 2002:a67:c894:0:b0:324:c5da:a9b5 with SMTP id
 v20-20020a67c894000000b00324c5daa9b5mr806338vsk.33.1657267623936; Fri, 08 Jul
 2022 01:07:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220531081412.22db88cc@kernel.org> <1654011382-2453-1-git-send-email-chen45464546@163.com>
 <20220531084704.480133fa@kernel.org> <CAKgT0UfQsbAzsJ1e__irHY2xBRevpB9m=FBYDis3C1fMua+Zag@mail.gmail.com>
 <3498989.c69f.1811f41186e.Coremail.chen45464546@163.com>
In-Reply-To: <3498989.c69f.1811f41186e.Coremail.chen45464546@163.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Fri, 8 Jul 2022 10:06:53 +0200
Message-ID: <CAFL455=ZcU_fyM9kiuZUJeVmRv9Jx_FmURcweCrTXheRoKkSqg@mail.gmail.com>
Subject: Re: Re: [PATCH v2] mm: page_frag: Warn_on when frag_alloc size is
 bigger than PAGE_SIZE
To:     =?UTF-8?B?5oSa5qCR?= <chen45464546@163.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

st 1. 6. 2022 v 14:49 odes=C3=ADlatel =E6=84=9A=E6=A0=91 <chen45464546@163.=
com> napsal:
> Can we just add code to the relatively slow path to capture the mistake
> before it lead to memory corruption?
> Like:
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e6f211d..ac60a97 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5580,6 +5580,7 @@ void *page_frag_alloc_align(struct page_frag_cache =
*nc,
>                 /* reset page count bias and offset to start of new frag =
*/
>                 nc->pagecnt_bias =3D PAGE_FRAG_CACHE_MAX_SIZE + 1;
>                 offset =3D size - fragsz;
> +               BUG_ON(offset < 0);
>         }
>

Personally, I'm not really convinced this is the best solution.
The next time a driver abuses  the page_frag_alloc() interface, the
bug may go unnoticed for a long time...
until a server in production runs into OOM and crashes because it hits
the BUG_ON().

And why should the kernel panic? It's perfectly able to handle this
condition by failing
the allocation and returning NULL, and printing a warning maybe.

Maurizio

