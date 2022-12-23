Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324616553C6
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 20:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbiLWTHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 14:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiLWTHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 14:07:22 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F8D1B9F0
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 11:07:21 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id h21so4363628qta.12
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 11:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HGw9oRroFvPZ2dyQcKWKF0FY4soMbEIhC7lZPLQhPjY=;
        b=HmlyjN0EM9c5k+W/8twiDyNwtL4iIkEk+itfoYVQWrXjlJAflSsOolovl+8prOU0XE
         l3/x47GBmfyqzrLb1Cp1GyaQU9sS4GHbnvznDR+Yx/j6IjI+4xIgzdLttkx2R/RRrQfv
         7cm4SVHqjoc5mTYMdO646JC/I8jyHL7Ryehsc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HGw9oRroFvPZ2dyQcKWKF0FY4soMbEIhC7lZPLQhPjY=;
        b=URucdMWpNake52CNrbvzzxSWsqofivQeqsbeTHo7Hyj61L6m7773roFVkNU6KVlc1O
         BxgHCNbwjiZBpLbLJu/aefXj2gAJ0rDYipB+IuhliSoN20b04JqV8hcX3SJqnm4vCPZ+
         wqx2SDh7MT/ffx0SIpIU/GFAUbOrqCyxvxqV0SBK/HxlaQaUbl461qAw1DTBXNowjNLJ
         yerEOTEEX4FFA8gIZx29ppehu6vOzN4jk1y8OekC0mBc8g8GOtC/H8HIysRr9bUPFfeA
         JZc2X7GuIA+5b7XICPW8jsGOIJER/+0UYL/ROU2omQ+rdMWpTRFsRGGtiOAHB5qAP8Q5
         fG6Q==
X-Gm-Message-State: AFqh2krlIuagRSC0myOkGYmjZ7mF7rS5b/2YK8Wbb+q5CS4ENGBQIXrW
        Hapa0c9b+CGndnxUPKIm4z6Q5lqKklM8oZWG
X-Google-Smtp-Source: AMrXdXssnHyy8Fp0o+9y+7w84N0FzCtXGkEINc0Hyvr/PTIeB9TTasL3xZg+XPBemYjhKC619fY/sg==
X-Received: by 2002:ac8:73c7:0:b0:3a7:f3e7:5149 with SMTP id v7-20020ac873c7000000b003a7f3e75149mr12515652qtp.61.1671822439849;
        Fri, 23 Dec 2022 11:07:19 -0800 (PST)
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com. [209.85.222.178])
        by smtp.gmail.com with ESMTPSA id r12-20020ac8520c000000b0039a55f78792sm2333267qtn.89.2022.12.23.11.07.19
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Dec 2022 11:07:19 -0800 (PST)
Received: by mail-qk1-f178.google.com with SMTP id pa22so2748917qkn.9
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 11:07:19 -0800 (PST)
X-Received: by 2002:a05:620a:1379:b0:6fc:c48b:8eab with SMTP id
 d25-20020a05620a137900b006fcc48b8eabmr347377qkl.216.1671822438709; Fri, 23
 Dec 2022 11:07:18 -0800 (PST)
MIME-Version: 1.0
References: <Y5uprmSmSfYechX2@yury-laptop> <CAHk-=wj_4xsWxLqPvkCV6eOJt7quXS8DyXn3zWw3W94wN=6yig@mail.gmail.com>
In-Reply-To: <CAHk-=wj_4xsWxLqPvkCV6eOJt7quXS8DyXn3zWw3W94wN=6yig@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 23 Dec 2022 11:07:03 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgrzisX2_MCcw3Qqa0J3d7mL14aab9F0JkjGF=VfAk5Ow@mail.gmail.com>
Message-ID: <CAHk-=wgrzisX2_MCcw3Qqa0J3d7mL14aab9F0JkjGF=VfAk5Ow@mail.gmail.com>
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

On Fri, Dec 23, 2022 at 10:44 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Honestly, in this case, I think the logical thing to do is "check that
> the upper bits are the same". The way you do that is probably
> something like
>
>    !((off) ^ ((nbits)-1) & ~(BITS_PER_LONG-1))

Note that while the above is probably correct (but you always need to
double-check my emailed "something like this" code - I literally write
it in the MUA, and I make mistakes too), I'd never want to see that as
part of one big complex macro.

In fact, I think I am missing a set of parentheses, because '&' has a
higher precedence than '^', so the above is actually buggy.

So I'd much rather see something like this

  #define COMPILE_TIME_TRUE(x) (__builtin_constant_p(x) && (x))

  #define bits_in_same_word(x,y) \
        (!(((x)^(y))&~(BITS_PER_LONG-1)))

  #define bitmap_off_in_last_word(nbits,off) \
        bits_in_same_word((nbits)-1,off)

  #define small_const_nbits_off(nbits, off) \
        (__builtin_constant_p(nbits) && (nbits) > 0 && \
         COMPILE_TIME_TRUE(bitmap_off_in_last_word(nbits,off)))

where each step does one thing and one thing only, and you don't have
one complicated thing that is hard to read.

And again, don't take my word blindly for the above.  I *think* the
above may be correct, but there's a "think" and a "may" there.

Plus I'd still like to hear about where the above would actually
matter and make a code generation difference in real life (compared to
just the simple "optimize the single-word bitmap" case).

                Linus
