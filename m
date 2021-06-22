Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876A83B0FE8
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 00:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhFVWOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 18:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhFVWOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 18:14:18 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7312C061574;
        Tue, 22 Jun 2021 15:12:01 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id b5-20020a17090a9905b029016fc06f6c5bso48991pjp.5;
        Tue, 22 Jun 2021 15:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=o2+VzVFtZ+UMwAfruQN2pudbe49gznHm93bCfuGWgbc=;
        b=X1HiiK2YqvtL1YCXciwJTNj//apGtv4IcKMGn44BWuPjyM+Yqq23K546XihLY7gxPM
         JDfqlLg6Sq7rXdPh6NpjOIhAr43cR5rFVqsOFPI/HeQEwBkarpOfmhLezGol0RCBe0K8
         KKuBWKDkaiSx44Po4QxCsBGYKfBen3W5Na9AZvlImaBMshQZ2PfNH2fRmBxJ9KTxZRRF
         TNzXsAB+VKoiTPwgA0pJHBR4VB3FfBOs7ngBGNBbAuOJnJjEdRoogbIxtAKkLcl3gg7b
         o0YHvY9nYjcUiOynmtRs/W0u6IR7H384KCKUQMso9WhQdZFr8zpbi8mSPYnprupvtiJp
         n4YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=o2+VzVFtZ+UMwAfruQN2pudbe49gznHm93bCfuGWgbc=;
        b=pxqGyzT5K8S+JdP8G7uAtBmw+y09eMGrEEh4Q32hI/abmOfaVHwM8ZKotl92O0H17A
         lgGH41n6tjuqqhOmuX6mLfFhQnjqJD841u06PTa3CVIGRVEu4BTDDqmYKXPSPBnZu5RK
         EZwlpiXD6fRbeiwNdG+O9nlf3IXMkfg4/8XUSkXepaBBgSExFbLhY5UAhgOKXh1utZ8W
         kF+cjKjeQpYuXSidtkiYjJdz1BfX42tgjW0qL5in/zqPLsdx/OLwP3RbtPe4sol4eN+D
         qD+ZmNHjFmK1wAr1IBCV4puPFsFa2tGP5EhFxtcstW/1bAc917y7jEaHqDMIAQu0akHW
         QxGQ==
X-Gm-Message-State: AOAM533KOpXihOonrLFEs5GcAyOQ/3goqXGV12B5g0lgtS03Gn4tz5eR
        woxabuzVnyU5zbbL87oQt88=
X-Google-Smtp-Source: ABdhPJyqCPntkPwr/qpCGUbtyT26iUYX3iGWhaCYr0dKkcvaqsqI6NShBr9LhYkeUTRT8fJFlWziQA==
X-Received: by 2002:a17:90a:5a08:: with SMTP id b8mr6149586pjd.228.1624399921180;
        Tue, 22 Jun 2021 15:12:01 -0700 (PDT)
Received: from localhost ([2402:3a80:1f84:2ac4:8d6c:3f60:b533:9c7])
        by smtp.gmail.com with ESMTPSA id jz10sm3275268pjb.4.2021.06.22.15.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 15:12:00 -0700 (PDT)
Date:   Wed, 23 Jun 2021 03:40:23 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/5] bitops: add non-atomic bitops for
 pointers
Message-ID: <20210622221023.gklikg5yib4ky35m@apollo>
References: <20210622202835.1151230-1-memxor@gmail.com>
 <20210622202835.1151230-3-memxor@gmail.com>
 <871r8tpnws.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <871r8tpnws.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 03:22:51AM IST, Toke Høiland-Jørgensen wrote:
> Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:
>
> > cpumap needs to set, clear, and test the lowest bit in skb pointer in
> > various places. To make these checks less noisy, add pointer friendly
> > bitop macros that also do some typechecking to sanitize the argument.
> >
> > These wrap the non-atomic bitops __set_bit, __clear_bit, and test_bit
> > but for pointer arguments. Pointer's address has to be passed in and it
> > is treated as an unsigned long *, since width and representation of
> > pointer and unsigned long match on targets Linux supports. They are
> > prefixed with double underscore to indicate lack of atomicity.
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  include/linux/bitops.h    | 19 +++++++++++++++++++
> >  include/linux/typecheck.h | 10 ++++++++++
> >  2 files changed, 29 insertions(+)
> >
> > diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> > index 26bf15e6cd35..a9e336b9fa4d 100644
> > --- a/include/linux/bitops.h
> > +++ b/include/linux/bitops.h
> > @@ -4,6 +4,7 @@
> >
> >  #include <asm/types.h>
> >  #include <linux/bits.h>
> > +#include <linux/typecheck.h>
> >
> >  #include <uapi/linux/kernel.h>
> >
> > @@ -253,6 +254,24 @@ static __always_inline void __assign_bit(long nr, volatile unsigned long *addr,
> >  		__clear_bit(nr, addr);
> >  }
> >
> > +#define __ptr_set_bit(nr, addr)                         \
> > +	({                                              \
> > +		typecheck_pointer(*(addr));             \
> > +		__set_bit(nr, (unsigned long *)(addr)); \
> > +	})
> > +
> > +#define __ptr_clear_bit(nr, addr)                         \
> > +	({                                                \
> > +		typecheck_pointer(*(addr));               \
> > +		__clear_bit(nr, (unsigned long *)(addr)); \
> > +	})
> > +
> > +#define __ptr_test_bit(nr, addr)                       \
> > +	({                                             \
> > +		typecheck_pointer(*(addr));            \
> > +		test_bit(nr, (unsigned long *)(addr)); \
> > +	})
> > +
>
> Before these were functions that returned the modified values, now they
> are macros that modify in-place. Why the change? :)
>

Given that we're exporting this to all kernel users now, it felt more
appropriate to follow the existing convention/argument order for the
functions/ops they are wrapping.

I really have no preference here though...

> -Toke
>

--
Kartikeya
