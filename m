Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4306B5EF11E
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 11:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbiI2JA4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 29 Sep 2022 05:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235070AbiI2JAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 05:00:54 -0400
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A61C126B56;
        Thu, 29 Sep 2022 02:00:53 -0700 (PDT)
Received: by mail-oi1-f182.google.com with SMTP id m130so948069oif.6;
        Thu, 29 Sep 2022 02:00:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Ir+IzupNAXvXvPBkZ1yh/qacu5xVXDJ2KC3L3ZMV+D4=;
        b=EED+KU8eMYhPRbakg8ufk7N7udWD/ajW0taKcnMaub1VgUUEk6pJVhDivnToBjIDFI
         Ii4QoNk4pYr3EVXDi0seakF39cCNV7UWcpTXbkVpyjE2enfVAMsTmn8Iff3bfBE3q5+G
         4jYiOEJaPb4iENUuMm+etMhu8E4F05mWl1qUHgE9DIabskklCZuNGzsA8luMoyNv6PPn
         6Z/AalBN6VZU8RWNIUO6wUP5mAiRuereep444i3efUrI8CVrDXgOYQ/QKFTO2dAzLW5V
         5KYpQss9DxkuKVysmb+te+tPo4ecJsWw0rHH7Qyh7+TDyDGm+cpu1Y/x10PkExBmweTQ
         zO3g==
X-Gm-Message-State: ACrzQf3jeNWP+lf1eYUBdQuOBkGrMyqOPc9rTX4d6jbuwwycQa1EufVP
        7oJ07yldNkV/XT8X9pEjfKl8QWnroUGLsQ==
X-Google-Smtp-Source: AMsMyM5vrNCkseckAA8F+Eoio9F3dk/sAQm6yX/uZ2lAkUbFkJg4rOwOGUF0gV17QHA7TmWXxYAzaQ==
X-Received: by 2002:a05:6808:13c9:b0:350:109d:4916 with SMTP id d9-20020a05680813c900b00350109d4916mr6110929oiw.97.1664442052395;
        Thu, 29 Sep 2022 02:00:52 -0700 (PDT)
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com. [209.85.210.54])
        by smtp.gmail.com with ESMTPSA id cm30-20020a056870b61e00b0012c21a64a76sm3622029oab.24.2022.09.29.02.00.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 02:00:52 -0700 (PDT)
Received: by mail-ot1-f54.google.com with SMTP id f20-20020a9d7b54000000b006574e21f1b6so500473oto.5;
        Thu, 29 Sep 2022 02:00:52 -0700 (PDT)
X-Received: by 2002:a5b:104:0:b0:6b0:429:3fe9 with SMTP id 4-20020a5b0104000000b006b004293fe9mr2016091ybx.543.1664442041163;
 Thu, 29 Sep 2022 02:00:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220923202822.2667581-1-keescook@chromium.org>
 <20220923202822.2667581-2-keescook@chromium.org> <CAMuHMdXK+UN1YVZm9DenuXAM8hZRUZJwp=SXsueP7sWiVU3a9A@mail.gmail.com>
 <202209281011.66DD717D@keescook> <874jwqfuh6.fsf@mpe.ellerman.id.au>
In-Reply-To: <874jwqfuh6.fsf@mpe.ellerman.id.au>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 29 Sep 2022 11:00:28 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVOvs4adSV7G6ucZ8dcr+RxfZOOK=jXeO2tEAaXkv80Xg@mail.gmail.com>
Message-ID: <CAMuHMdVOvs4adSV7G6ucZ8dcr+RxfZOOK=jXeO2tEAaXkv80Xg@mail.gmail.com>
Subject: Re: [PATCH v2 01/16] slab: Remove __malloc attribute from realloc functions
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Kees Cook <keescook@chromium.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Marco Elver <elver@google.com>, linux-mm@kvack.org,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Miguel Ojeda <ojeda@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        dev@openvswitch.org, x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Thu, Sep 29, 2022 at 10:36 AM Michael Ellerman <mpe@ellerman.id.au> wrote:
> Kees Cook <keescook@chromium.org> writes:
> > On Wed, Sep 28, 2022 at 09:26:15AM +0200, Geert Uytterhoeven wrote:
> >> On Fri, Sep 23, 2022 at 10:35 PM Kees Cook <keescook@chromium.org> wrote:
> >> > The __malloc attribute should not be applied to "realloc" functions, as
> >> > the returned pointer may alias the storage of the prior pointer. Instead
> >> > of splitting __malloc from __alloc_size, which would be a huge amount of
> >> > churn, just create __realloc_size for the few cases where it is needed.
> >> >
> >> > Additionally removes the conditional test for __alloc_size__, which is
> >> > always defined now.
> >> >
> >> > Cc: Christoph Lameter <cl@linux.com>
> >> > Cc: Pekka Enberg <penberg@kernel.org>
> >> > Cc: David Rientjes <rientjes@google.com>
> >> > Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >> > Cc: Andrew Morton <akpm@linux-foundation.org>
> >> > Cc: Vlastimil Babka <vbabka@suse.cz>
> >> > Cc: Roman Gushchin <roman.gushchin@linux.dev>
> >> > Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> >> > Cc: Marco Elver <elver@google.com>
> >> > Cc: linux-mm@kvack.org
> >> > Signed-off-by: Kees Cook <keescook@chromium.org>
> >>
> >> Thanks for your patch, which is now commit 63caa04ec60583b1 ("slab:
> >> Remove __malloc attribute from realloc functions") in next-20220927.
> >>
> >> Noreply@ellerman.id.au reported all gcc8-based builds to fail
> >> (e.g. [1], more at [2]):
> >>
> >>     In file included from <command-line>:
> >>     ./include/linux/percpu.h: In function ‘__alloc_reserved_percpu’:
> >>     ././include/linux/compiler_types.h:279:30: error: expected
> >> declaration specifiers before ‘__alloc_size__’
> >>      #define __alloc_size(x, ...) __alloc_size__(x, ## __VA_ARGS__) __malloc
> >>                                   ^~~~~~~~~~~~~~
> >>     ./include/linux/percpu.h:120:74: note: in expansion of macro ‘__alloc_size’
> >>     [...]
> >>
> >> It's building fine with e.g. gcc-9 (which is my usual m68k cross-compiler).
> >> Reverting this commit on next-20220927 fixes the issue.
> >>
> >> [1] http://kisskb.ellerman.id.au/kisskb/buildresult/14803908/
> >> [2] http://kisskb.ellerman.id.au/kisskb/head/1bd8b75fe6adeaa89d02968bdd811ffe708cf839/
> >
> > Eek! Thanks for letting me know. I'm confused about this --
> > __alloc_size__ wasn't optional in compiler_attributes.h -- but obviously
> > I broke something! I'll go figure this out.
>
> This fixes it for me.

Kees submitted a similar patch 20 minutes before:
https://lore.kernel.org/all/20220929081642.1932200-1-keescook@chromium.org

> --- a/include/linux/compiler_types.h
> +++ b/include/linux/compiler_types.h
> @@ -275,8 +275,13 @@ struct ftrace_likely_data {
>   * be performing a _reallocation_, as that may alias the existing pointer.
>   * For these, use __realloc_size().
>   */
> -#define __alloc_size(x, ...)   __alloc_size__(x, ## __VA_ARGS__) __malloc
> -#define __realloc_size(x, ...) __alloc_size__(x, ## __VA_ARGS__)
> +#ifdef __alloc_size__
> +# define __alloc_size(x, ...)  __alloc_size__(x, ## __VA_ARGS__) __malloc
> +# define __realloc_size(x, ...)        __alloc_size__(x, ## __VA_ARGS__)
> +#else
> +# define __alloc_size(x, ...)  __malloc
> +# define __realloc_size(x, ...)
> +#endif
>
>  #ifndef asm_volatile_goto
>  #define asm_volatile_goto(x...) asm goto(x)


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
