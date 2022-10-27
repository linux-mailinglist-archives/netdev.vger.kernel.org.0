Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25763610159
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 21:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236262AbiJ0TQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 15:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236103AbiJ0TQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 15:16:07 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD305A836;
        Thu, 27 Oct 2022 12:16:06 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-13bd19c3b68so3473497fac.7;
        Thu, 27 Oct 2022 12:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eCsVCuaf2go92u0eYyN6AvJOsvbg6jhQcYiOWielii4=;
        b=R0iWBH+HPjJ0SQdZ84Mt4uYE+Bta4bVdd1ncs9eqbfofJpPePa6XG9quwkgAuVwy0n
         kB2rMYQldd1ASFbzPIjghjc19QKB+Vk6xcyLhtzYrIMNQvXD/77YpqD6RoZjUUukcCjm
         xyG49dB/CLPB1z4W2WwNKBt6boRPtkSTiCNdFuWGWGhenpBeV96nMIUFmI73pjcLv/Jv
         34hU2DEiJa/Qrg6SRcSoXY5w+BZ8/Ug3vUoSbZDO+2POPYkVhIUs5WxTbDTjTP1plMb7
         6JGV1JLbFGJFK6kgHRaaYBhxkbbXAKZTB2A8hq1M5BY6EOHWSfHJp1LalMvxbEM4cPTM
         LKEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eCsVCuaf2go92u0eYyN6AvJOsvbg6jhQcYiOWielii4=;
        b=o6IXg7inFIaaF9M96y4uu8GRbLK9NXULWGPL1gGvfo/gTqV05mCuX7vdVdXuDOYh0D
         tH0VxJDtvoi2hF6WtikfC1mfvpGBZigeUUqBKUxAlyAvBfqj7sDZyRFoAEqI4WbHGUiK
         9PVLH0tKGtH9sYgcPn+n5wjtsknEKCbZn4oFuNWpaWhpCl8fg30UDVi2dYieYFI5Pep9
         vrWiP0K1XvB3RyRxktH9gdMccktwyW8iTUeQzllK9q6vKWt/ryx1Sowio2FwwU6mXkTh
         uQhF78ck5vHMyVv74WlSf/VGskUBMXDYu1A8enzsDuDMyUS6KtjErWTm+DphIOAmjK/f
         d2TA==
X-Gm-Message-State: ACrzQf10eYL24FxQ7eGzxddEjx1slsdUBT7yVc0QRvo1veGYeoNlo5CA
        lgpnDlqeTkjwgG4gBXB/H9ZzZRjKzmEzVmrYz1w=
X-Google-Smtp-Source: AMsMyM7KbsFtvsVIc+R5gFeE/Bsyup166H3kNtBbyj/N9Fb0PKl2TLQArY/Nxb5G1+poimNKiwOW0RK3b4L6fD2AFEA=
X-Received: by 2002:a05:6870:c182:b0:12a:e54e:c6e8 with SMTP id
 h2-20020a056870c18200b0012ae54ec6e8mr6423090oad.207.1666898165661; Thu, 27
 Oct 2022 12:16:05 -0700 (PDT)
MIME-Version: 1.0
References: <20221022180455.never.023-kees@kernel.org> <CA+fCnZcj_Hq1NQv1L2U7+A8quqj+4kA=8A7LwOWz5eYNQFra+A@mail.gmail.com>
 <202210271212.EB69EF1@keescook>
In-Reply-To: <202210271212.EB69EF1@keescook>
From:   Andrey Konovalov <andreyknvl@gmail.com>
Date:   Thu, 27 Oct 2022 21:15:54 +0200
Message-ID: <CA+fCnZeTO_eQjSqysoToKCqUhsXc8jL93TdE8W9Fh+xrbUiFtg@mail.gmail.com>
Subject: Re: [PATCH] mm: Make ksize() a reporting-only function
To:     Kees Cook <keescook@chromium.org>
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

On Thu, Oct 27, 2022 at 9:13 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Oct 27, 2022 at 09:05:45PM +0200, Andrey Konovalov wrote:
> > On Sat, Oct 22, 2022 at 8:08 PM Kees Cook <keescook@chromium.org> wrote:
> > [...]
> > > -/* Check that ksize() makes the whole object accessible. */
> > > +/* Check that ksize() does NOT unpoison whole object. */
> > >  static void ksize_unpoisons_memory(struct kunit *test)
> > >  {
> > >         char *ptr;
> > > @@ -791,15 +791,17 @@ static void ksize_unpoisons_memory(struct kunit *test)
> > >
> > >         ptr = kmalloc(size, GFP_KERNEL);
> > >         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> > > +
> > >         real_size = ksize(ptr);
> > > +       KUNIT_EXPECT_GT(test, real_size, size);
> > >
> > >         OPTIMIZER_HIDE_VAR(ptr);
> > >
> > >         /* This access shouldn't trigger a KASAN report. */
> > > -       ptr[size] = 'x';
> > > +       ptr[size - 1] = 'x';
> > >
> > >         /* This one must. */
> > > -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size]);
> > > +       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size - 1]);
> >
> > How about also accessing ptr[size] here? It would allow for a more
> > precise checking of the in-object redzone.
>
> Sure! Probably both ptr[size] and ptr[real_size -1], yes?

Yes, sounds good. Thank you!
