Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6DF46639E1
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 08:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbjAJHZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 02:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbjAJHYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 02:24:50 -0500
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1F04916A;
        Mon,  9 Jan 2023 23:24:49 -0800 (PST)
Received: by mail-oo1-xc2b.google.com with SMTP id o5-20020a4a2c05000000b004ac6ea6c75dso3014851ooo.8;
        Mon, 09 Jan 2023 23:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m+2ACMdQxffLsUo20nRc4xTyrL+eaCgWjSTc/1CsdOQ=;
        b=XRR6nsQUhHUq5EWmW9gKJaqOb3Hw5ym3IfYXgAx3Hhz43jET+NowDKZMakX2/YA72p
         qc6Z5Ak88H53tITWK4RX1Gis6dTvn7iz7raH+4etVxzdrudEoVvTz3BkUwiJ+ptP3EfI
         z2vTLsTXVVkas+5AJ8YnrL+g+CG8gNgQghYO0p18bxCaIE2qroUgZNqanOQdGUQQc146
         V0cNby3QobNVWqkMmyr7W6/Ow7MBOQH8Et0/kf3ZQE3fButZ2k6R+kLKms37r7FHltG5
         BliqZwyx1ni+ADrna7vw/HLKAqjcKvEPdwTmujNffw1kPQMYkcl9u2pCS6BAxZ8DEYhm
         k9WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m+2ACMdQxffLsUo20nRc4xTyrL+eaCgWjSTc/1CsdOQ=;
        b=iuzyMpx+9b91Xg13Afxypg/0CaBHjqfkVsNiznXoo3U1IR6Gajbyo59nvJtbPf75/L
         Wv1pqI7fDXCWXGq8qecV00xz5HMStkbo6lKJEVT1ibPqu5QuacVJsK5E1GwXYGhuoDGA
         hKPtUkWHjOWVPXAac+m/SXx0z4iEOcSxbGOjAg3Kx7RxLV8DiyOgrOL+N4+ju3Sw3izr
         lYU5NiurIwIh3OkUCi9KpCsEvqJkMtUqLT4erHwH/ITFPm0911G8n7MkW2Cs9FGwotQx
         sZXBKXNirWpEYe4SRH+Ypq/iTvwE7lU+n7nOKi/F2MRsTajGW/GUxkn59fP+X2wP00MV
         +YjQ==
X-Gm-Message-State: AFqh2kpPEoLES/9fJekPK1IBQxdDKxHlVxPaugfkrRrLVtkXNsCOplxi
        6UJ6UiVYugwxiJ5Esygt5RQ=
X-Google-Smtp-Source: AMrXdXsjiarDbClht+wd14wjZF+Uko0aLrKPE/1Rp1wlWzb6I5vS908nYgRT77Ec6689eDHFBWCALA==
X-Received: by 2002:a4a:83c6:0:b0:4a5:4335:100c with SMTP id r6-20020a4a83c6000000b004a54335100cmr27709247oog.7.1673335488326;
        Mon, 09 Jan 2023 23:24:48 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id n125-20020a4a5383000000b004ce5d00de73sm5316261oob.46.2023.01.09.23.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 23:24:47 -0800 (PST)
Date:   Mon, 9 Jan 2023 23:24:46 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Tariq Toukan <tariqt@nvidia.com>,
        Valentin Schneider <vschneid@redhat.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [GIT PULL] bitmap changes for v6.2-rc1
Message-ID: <Y70SvsOZnzV1UPXf@yury-laptop>
References: <Y5uprmSmSfYechX2@yury-laptop>
 <CAHk-=wj_4xsWxLqPvkCV6eOJt7quXS8DyXn3zWw3W94wN=6yig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj_4xsWxLqPvkCV6eOJt7quXS8DyXn3zWw3W94wN=6yig@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 23, 2022 at 10:44:07AM -0800, Linus Torvalds wrote:
> On Thu, Dec 15, 2022 at 3:11 PM Yury Norov <yury.norov@gmail.com> wrote:
> >
> > Please pull bitmap patches for v6.2. They spent in -next for more than
> > a week without any issues. The branch consists of:
> 
> So I've been holding off on this because these bitmap pulls have
> always scared me, and I wanted to have the time to actually look
> through them in detail before pulling.
> 
> I'm back home, over the travel chaos, and while I have other pulls
> pending, they seem to be benign fixes so I started looking at this.
> 
> And when looking at it, I did indeed finx what I think is a
> fundamental arithmetic bug.
> 
> That small_const_nbits_off() is simply buggy.
> 
> Try this:
> 
>         small_const_nbits_off(64,-1);
> 
> and see it return true.

Hi Linus,

Sorry for a delayed reply.

small_const_nbits{_off} is used only for bitmap and find_bit functions
where both offset and size are unsigned types. -1 there will turn into
UINT_MAX or ULONG_MAX, and small_const_nbits_off(64, -1) returns false.

The bitops.h functions (set_bit et all) also use unsigned type for nr.
Negative offsets are not used in bit operations from very basic level.

Notice that '(nbits) > 0' part in small_const_nbits() is there to exclude
0, not negative numbers.

So, support for negative offset/size looks irrelevant for all existing
users of small_const(). I doubt there'll be new non-bitmap users for
the macro anytime soon.

small_const_nbits() and proposed small_const_nbits_off() are in fact
very bitmap-related macros. 'Small' in this context refers to a
single-word bitmap. 0 is definitely a small and constant number, but
small_const_nbits(0) will return false - only because inline versions
of bitmap functions don't handle 0 correctly.

I think, small_const_nbits confuses because it sounds too generic and
is located in a very generic place. There's a historical reason for
that.

Originally, the macro was hosted in include/linux/bitmap.h and at that
time find.h was in include/asm-generic/bitops/. In commit 586eaebea5988
(lib: extend the scope of small_const_nbits() macro) I moved the macro
to include/asm-generic/bitsperlong.h to optimize find_bit functions too.

After that, working on other parts I found that having bitmap.h and
find.h in different include paths is a permanent headache due to things
like circular dependencies, and moved find.h to include/linux, where it
should be. And even made it an internal header for bitmap.h. But didn't
move small_const_nbits(). Looks like I have to move it to somewhere in
include/linux/bitops.h.

[...]
 
> So convince me not only that the optimizations are obviously correct,
> but also that they actually matter.

There're no existing users for small_const_nbits_off(). I've been
reworking bitmap_find_free_region(), added a pile of tests and
found that some quite trivial cases are not inlined, for example
find_next_bit(addr, 128, 124).

Let's ignore this patch unless we'll have real users.


Regarding the rest of the series. Can you please take a look? It includes
an optimization for CPUs allocations. With quite a simple rework of
cpumask_local_spread() we are gaining measurable and significant
improvement for many subsystems on NUMA machines.

Tariq measured impact of NUMA-based locality on networking in his
environment, and from his commit message:

    Performance tests:
    
    TCP multi-stream, using 16 iperf3 instances pinned to 16 cores (with aRFS on).
    Active cores: 64,65,72,73,80,81,88,89,96,97,104,105,112,113,120,121
    
    +-------------------------+-----------+------------------+------------------+
    |                         | BW (Gbps) | TX side CPU util | RX side CPU util |
    +-------------------------+-----------+------------------+------------------+
    | Baseline                | 52.3      | 6.4 %            | 17.9 %           |
    +-------------------------+-----------+------------------+------------------+
    | Applied on TX side only | 52.6      | 5.2 %            | 18.5 %           |
    +-------------------------+-----------+------------------+------------------+
    | Applied on RX side only | 94.9      | 11.9 %           | 27.2 %           |
    +-------------------------+-----------+------------------+------------------+
    | Applied on both sides   | 95.1      | 8.4 %            | 27.3 %           |
    +-------------------------+-----------+------------------+------------------+
    
    Bottleneck in RX side is released, reached linerate (~1.8x speedup).
    ~30% less cpu util on TX.

We'd really like to have this work in next kernel release.

Thanks,
Yury
