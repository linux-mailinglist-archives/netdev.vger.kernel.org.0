Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F386B6553B5
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 19:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbiLWSo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 13:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbiLWSo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 13:44:26 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C42A1CB2B
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 10:44:25 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id jr11so4344273qtb.7
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 10:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ISSNi5g8+83vFNG4zUWTK5It3MNE4YXnaRha+djQqBw=;
        b=XK7m6VhqBikWWDV2oOx6FkNGmZccdzxHEeN94hRuIrM5cJItYJ5Nyuph1fb1LDQXYV
         fr/dPlX9rIKq3/rIoVy1E7VXbGiRbsPj9ylXuxCqVqviueaV8OWtW6SwqWYDIK7Dky5h
         4sHL0aBImzrysKfCzxWKiX2MlyfRQtl8Ph+vg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ISSNi5g8+83vFNG4zUWTK5It3MNE4YXnaRha+djQqBw=;
        b=BlsgiR1qSd5x+OkrXwU+9uDrpdUakKcvpByv9vjLms5nObbTdGGYK84uqYH7vTDH5J
         pfz72PMoMPr/hCDcbZEa8X7h2ZPamp13T9erYPNJ5KFlPHSzSiN9z+15ipL/Er5k3bHm
         F9aVQQnUNbPKQUpRzkeLFOpxlwW3KeevxqmEaSfSzJX2UuZmGqhPrQbQW7DBNBx/j36O
         raE9DqcpYIn2EeNz9zBiEB3Lsg1nUYzYBHsWffcjEJKfbQV/ZvGEihFotPcSgVCADJBS
         Bhw4s6eTAgahegZdH/SNzSjJqyVSHIPxiYYRCeNtxD8U2Y8AlGzr9lZHEO1lTHljjXka
         o2gA==
X-Gm-Message-State: AFqh2koXqb4EAqfmdCNf07EdkV+mcv7w5cxANi4WkBqRJ161MOa8uUib
        R5CEweXIWd7oK2kPVn07Zh38YuQZylO01j/Z
X-Google-Smtp-Source: AMrXdXvfMb4wVdJvYPGcKU//xFlBUl5HulQvOt0hToj/R7Afufu8EvZ0X7Kik8V11AKuUG9ZQ4JJ8Q==
X-Received: by 2002:a05:622a:509f:b0:3a9:81f0:d8e2 with SMTP id fp31-20020a05622a509f00b003a981f0d8e2mr19674342qtb.60.1671821064283;
        Fri, 23 Dec 2022 10:44:24 -0800 (PST)
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com. [209.85.160.171])
        by smtp.gmail.com with ESMTPSA id s24-20020ac87598000000b003a7f1e16649sm2356131qtq.42.2022.12.23.10.44.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Dec 2022 10:44:23 -0800 (PST)
Received: by mail-qt1-f171.google.com with SMTP id x11so4319138qtv.13
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 10:44:23 -0800 (PST)
X-Received: by 2002:a05:622a:5daa:b0:3a7:ef7b:6aa5 with SMTP id
 fu42-20020a05622a5daa00b003a7ef7b6aa5mr301991qtb.436.1671821062915; Fri, 23
 Dec 2022 10:44:22 -0800 (PST)
MIME-Version: 1.0
References: <Y5uprmSmSfYechX2@yury-laptop>
In-Reply-To: <Y5uprmSmSfYechX2@yury-laptop>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 23 Dec 2022 10:44:07 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj_4xsWxLqPvkCV6eOJt7quXS8DyXn3zWw3W94wN=6yig@mail.gmail.com>
Message-ID: <CAHk-=wj_4xsWxLqPvkCV6eOJt7quXS8DyXn3zWw3W94wN=6yig@mail.gmail.com>
Subject: Re: [GIT PULL] bitmap changes for v6.2-rc1
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Tariq Toukan <tariqt@nvidia.com>,
        Valentin Schneider <vschneid@redhat.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 3:11 PM Yury Norov <yury.norov@gmail.com> wrote:
>
> Please pull bitmap patches for v6.2. They spent in -next for more than
> a week without any issues. The branch consists of:

So I've been holding off on this because these bitmap pulls have
always scared me, and I wanted to have the time to actually look
through them in detail before pulling.

I'm back home, over the travel chaos, and while I have other pulls
pending, they seem to be benign fixes so I started looking at this.

And when looking at it, I did indeed finx what I think is a
fundamental arithmetic bug.

That small_const_nbits_off() is simply buggy.

Try this:

        small_const_nbits_off(64,-1);

and see it return true.

The thing is, doing divides in C is something you need to be very
careful about, because they do *not* behave nicely with signed values.
They do the "mathematically intuitive" thing of truncating towards
zero, but when you are talking about bit ranges like this, that is
*NOT* what you want.

The comment is fairly good, but it just doesn't match the code.

If you want to check that 'nbits-1' and 'off' are in the same word,
you simply should not use division at all. Sure, it would work, if you
verify that they are both non-negative, but the fact is, even then
it's just wrong, wrong, wrong. You want a shift operation or a masking
operation.

Honestly, in this case, I think the logical thing to do is "check that
the upper bits are the same". The way you do that is probably
something like

   !((off) ^ ((nbits)-1) & ~(BITS_PER_LONG-1))

which doesn't have the fundamental bug that the divide version has.

So anyway, I won't be pulling this. I appreciate that you are trying
to micro-optimize the bitop functions, but this is not the first time
your pull requests have made me worried and caused me to not pull.
This is such basic functionality that I really need these pull
requests to be less worrisome.

In other words, not only don't I want to see these kinds of bugs -
please make sure that there isn't anythign that looks even *remotely*
scary. The micro-optimizations had better be *so* obvious and so well
thought through that I not only don't find bugs in them, I don't even
get nervous about finding bugs.

Side note: that whole small_const_nbits_off() thing could be possibly
improved in other ways. It's actually unnecessarily strict (if it was
correct, that is): we don't really require 'off' to be constant, what
we *do* want is

 - "nbits > off" needs to be a compile-time true constant

 - that "off is in the same word as nbits-1" also needs to be a
compile-time true constant.

and the compiler could determine both of those to be the case even if
'off' itself isn't a constant, if there is code around it that
verifies it.

For example, if you have code like this:

        off = a & 7;
        n = find_next_bit(bitmap, 64, off);

then the compiler could still see that it's that "last word only"
case, even though 'off' isn't actually a constant value.

So you could try using a helper macro like

   #define COMPILE_TIME_TRUE(x) (__builtin_constant_p(x) && (x))

to handle those kinds of things. But again - the code needs to be
OBVIOUSLY CORRECT. Make me feel those warm and fuzzies about it
because it's so obviously safe and correct.

That said, I see your test-cases for your micro-optimizations, but I'd
also like to see references to where it actually improves real code.

I know for a fact that 'small_const_nbits()' actually triggers in real
life. I don't see that your 'small_const_nbits_off()' would trigger in
real life in any situation that isn't already covered by
'small_const_nbits()'.

So convince me not only that the optimizations are obviously correct,
but also that they actually matter.

                Linus
