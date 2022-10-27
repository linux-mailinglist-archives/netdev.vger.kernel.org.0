Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8235B610141
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 21:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236230AbiJ0TNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 15:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235744AbiJ0TNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 15:13:23 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF9170E56
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 12:13:22 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id i3so2565073pfc.11
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 12:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KRy9sqvf0ZM2bZpgrnftqxmIbppdN+rJl6H1sXbtcEA=;
        b=ePBvbYsqqxinV1869tyLVSPuexY7f5oFCO4bFBrZ0zRyJ8fAIYv6HyDImZpOI7sDK4
         wV01b3ApWa7HxYPZmSq7Y80QJ8waTqfMmGkATXW/AodfcPzYcSL2X9iXgY+1T73b5Ysl
         7tELmVPx85ac64Og2sYczqg5VmOjiPDZGHsIc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KRy9sqvf0ZM2bZpgrnftqxmIbppdN+rJl6H1sXbtcEA=;
        b=k3Ur9adjB0vKP/Oo8B7HoOlBqusw6q9a0nyN/gG2u3DyIbg2ycXihOPJhBiz3bwKKe
         N+SYqmmteWTUNRwWzLwHjXNd6TaX9NuEfD4Yp4CFtijLilEpv/UD1JevYTfOokC6fii0
         8fJK1NYep9NldtMqRYO28zNx7Dpev2z7k9Ezv///qBMsz4sDv7qZbEqnO3Hlp8/om5O5
         VM62wyW32TZHnoaKVTohgpFD+nM90OZRnB9jQy3ncGPl7X/0tmXBaL7j988OdBGro/pm
         UxJLOEAE1dLmbgHfUxYfYe3TOSTGokz4EWZO7n8VfP4Ia+u8TGRpv6cFn5BxUCHrwnOK
         2JKQ==
X-Gm-Message-State: ACrzQf2+H3DoHUnAmrVhj6X+nbc42H0fk2CvJzJD0qYxLD5Z/Xm+B7oI
        vjFJD+zQC2Uc/3bODOJG0P69Bw==
X-Google-Smtp-Source: AMsMyM4innxfNZAzhGWL/DpqnIwUOYEYiApzjV6DBWLPdx0UZXtA4mdOwut8gE2N2aGulndGyPlvSA==
X-Received: by 2002:a63:7909:0:b0:458:1ba6:ec80 with SMTP id u9-20020a637909000000b004581ba6ec80mr44062420pgc.414.1666898002301;
        Thu, 27 Oct 2022 12:13:22 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q10-20020a170903204a00b00176e6f553efsm1525222pla.84.2022.10.27.12.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 12:13:21 -0700 (PDT)
Date:   Thu, 27 Oct 2022 12:13:20 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Andrey Konovalov <andreyknvl@gmail.com>
Cc:     Christoph Lameter <cl@linux.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        linux-mm@kvack.org, kasan-dev@googlegroups.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] mm: Make ksize() a reporting-only function
Message-ID: <202210271212.EB69EF1@keescook>
References: <20221022180455.never.023-kees@kernel.org>
 <CA+fCnZcj_Hq1NQv1L2U7+A8quqj+4kA=8A7LwOWz5eYNQFra+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+fCnZcj_Hq1NQv1L2U7+A8quqj+4kA=8A7LwOWz5eYNQFra+A@mail.gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 09:05:45PM +0200, Andrey Konovalov wrote:
> On Sat, Oct 22, 2022 at 8:08 PM Kees Cook <keescook@chromium.org> wrote:
> [...]
> > -/* Check that ksize() makes the whole object accessible. */
> > +/* Check that ksize() does NOT unpoison whole object. */
> >  static void ksize_unpoisons_memory(struct kunit *test)
> >  {
> >         char *ptr;
> > @@ -791,15 +791,17 @@ static void ksize_unpoisons_memory(struct kunit *test)
> >
> >         ptr = kmalloc(size, GFP_KERNEL);
> >         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> > +
> >         real_size = ksize(ptr);
> > +       KUNIT_EXPECT_GT(test, real_size, size);
> >
> >         OPTIMIZER_HIDE_VAR(ptr);
> >
> >         /* This access shouldn't trigger a KASAN report. */
> > -       ptr[size] = 'x';
> > +       ptr[size - 1] = 'x';
> >
> >         /* This one must. */
> > -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size]);
> > +       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size - 1]);
> 
> How about also accessing ptr[size] here? It would allow for a more
> precise checking of the in-object redzone.

Sure! Probably both ptr[size] and ptr[real_size -1], yes?

-- 
Kees Cook
