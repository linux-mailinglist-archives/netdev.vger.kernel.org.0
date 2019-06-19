Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDAD4AFCA
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 04:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbfFSCA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 22:00:59 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:47045 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfFSCA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 22:00:59 -0400
Received: by mail-io1-f67.google.com with SMTP id i10so34366507iol.13;
        Tue, 18 Jun 2019 19:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eZlNqOfQ+cHNdJqkd29lNdR3i4fL4rmWEkZsMWK7znE=;
        b=QNw84ZnE1KiYojVyUU/yiZRtsyrliaoOtKWJfomCUkjAb4lPsdOzr8nFSHca+BKKP5
         k/g9VUI5/H0OCPDdDcYJzKXiDYSl34/pl9sz7yJOANe7Jhp7xnmEufeaEka7cIqxZ7fX
         vPC4kh6m1Zhy7nGsEJDl4RVdMWrkHNC4Q84PXYF7SjVIVB5Gmd8byeBuO8rcGlXyaTk3
         M/WP6fse4B1/mNityUHGYDbdviHeWsPeFe/jl/Z+HwbftY2B5rsX0P+JWzR4HVUpcWUq
         tqf88V3g5sRr+QxZjiv+yIFYOPmzFWvXDqVGq5rgv+OlHwjpxwAp1aRPmHzsx+I/Qzd6
         SDtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eZlNqOfQ+cHNdJqkd29lNdR3i4fL4rmWEkZsMWK7znE=;
        b=lLXcwDRptqfAkG5GllGVjnK/xpxYjWBG0fDLFKRJQfxFEVrl9H21zyFtirtmoYCOIa
         bxM/NWx+hy+2xG+5Xlrg6AdRtg8U7WOewOUor17la6vhmfmvucdYZXezF2bL0OowAffy
         oZGrZ9QZFONADFPxkYno6E7fm364StwOaBRho3TrXIr3vNQoPY7z8sj+7YW3hSxQDkJe
         0Ym5UZ3yHD4tqy8Rbc40MdMParAlVAGV8WliBeSNrZxpEo5UAQHe+NybCpfWCYr3E6YI
         Ou/TV1MVbJ82st4FzFvTjFOnuWd/D+rqGs3xxZBc7K9WdpcSo5QQ1AfVcE5E8AvKKmYB
         gVkA==
X-Gm-Message-State: APjAAAVQH5iYna6t+ECxuan/DNiVR/aevcf4phzmPrcTBRqba9EndNu0
        g2lfmcMUaWN1mtawsAEy76KzcSdXIJvjuDpxXes=
X-Google-Smtp-Source: APXvYqyEiuU+7GuIyt/bjd4AKwc6h3oMsOokWeb7N8r8byr++x8C9goZvFRsvK9H6n9hm+wG6yHtKJZvAKV/uFbzEko=
X-Received: by 2002:a6b:901:: with SMTP id t1mr5924618ioi.42.1560909658419;
 Tue, 18 Jun 2019 19:00:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190618211440.54179-1-mka@chromium.org> <20190618230420.GA84107@archlinux-epyc>
 <20190618232140.GW137143@google.com>
In-Reply-To: <20190618232140.GW137143@google.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 18 Jun 2019 19:00:46 -0700
Message-ID: <CAKgT0UfRxAMFun5fQbqwwppHArUXP=Z_GnVEJ3x2j6ODkD7UPA@mail.gmail.com>
Subject: Re: [PATCH] net/ipv4: fib_trie: Avoid cryptic ternary expressions
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Huckleberry <nhuck@google.com>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 4:22 PM Matthias Kaehlcke <mka@chromium.org> wrote:
>
> On Tue, Jun 18, 2019 at 04:04:20PM -0700, Nathan Chancellor wrote:
> > On Tue, Jun 18, 2019 at 02:14:40PM -0700, Matthias Kaehlcke wrote:
> > > empty_child_inc/dec() use the ternary operator for conditional
> > > operations. The conditions involve the post/pre in/decrement
> > > operator and the operation is only performed when the condition
> > > is *not* true. This is hard to parse for humans, use a regular
> > > 'if' construct instead and perform the in/decrement separately.
> > >
> > > This also fixes two warnings that are emitted about the value
> > > of the ternary expression being unused, when building the kernel
> > > with clang + "kbuild: Remove unnecessary -Wno-unused-value"
> > > (https://lore.kernel.org/patchwork/patch/1089869/):
> > >
> > > CC      net/ipv4/fib_trie.o
> > > net/ipv4/fib_trie.c:351:2: error: expression result unused [-Werror,-Wunused-value]
> > >         ++tn_info(n)->empty_children ? : ++tn_info(n)->full_children;
> > >
> >
> > As an FYI, this is also being fixed in clang:
> >
> > https://bugs.llvm.org/show_bug.cgi?id=42239
> >
> > https://reviews.llvm.org/D63369
>
> Great, thanks!
>
> In this case it was actually useful to get the warning, even though it
> didn't point out the actual bug. I think in general it would be
> preferable to avoid such constructs, even when they are correct. But
> then again, it's the reviewers/maintainers task to avoid unnecessarily
> cryptic code from slipping in, and this just happens to be one instance
> where the compiler could have helped.

So it took me a bit to remember/understand it as well since I haven't
touched the code in over 4 years, however part of that is because the
comment for this code is actually buried down in put_child.
Essentially this is just meant to be an add w/ carry and a sub w/
borrow to address a potential overflow if bits == KEYLENGTH.

If you want you can add:
Fixes: 95f60ea3e99a ("fib_trie: Add collapse() and should_collapse() to resize")
Acked-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
