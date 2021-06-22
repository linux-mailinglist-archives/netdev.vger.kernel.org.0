Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58993B1071
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 01:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhFVXUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 19:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhFVXUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 19:20:02 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB22C061574;
        Tue, 22 Jun 2021 16:17:44 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id q192so767076pfc.7;
        Tue, 22 Jun 2021 16:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=jM6tM7pD1ijEC6hPFMIA17c4K+Lk5fP5IVs4e5rQUBU=;
        b=lJf5GmgYh84tL8ZbqiyUHhMnTXGMNzIYcgEsspu/aoRFBPRNK6ecChnrEgD2Rnu4T/
         Wmi7kRDV+3rtnhyEIG9gKijuRgeIGCTjmc/KbGrLwYu0K0T/1lDNhi+5Tbxp1V1zF2e1
         JdKFh2gpHCT0ht5bW9bmMoDaxvd++H74QieSNO31fYtPoFz8ItIcLpFhsQfbCNJFLn9a
         piVEP/v+bKvzohE2PSh6XhvVi7MiCOlZqi114IiNVDaHJREUxpMrlbbTys9PiajuLAou
         I2xGwbcJJQLRKvg2vR8WozYyxjLheE+HUhxeiZuDEF8Q+J1MZ2JZP0+i6Ct9U1WijShH
         OsVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=jM6tM7pD1ijEC6hPFMIA17c4K+Lk5fP5IVs4e5rQUBU=;
        b=UhA1J8GuIFdNbfCpk7sWGVPtqrXt3Dj89YjcGfzzFnWOCT0XnRy1fMJJ8IaLnGuyHf
         AjjJgqBe46f59FltEQSWzwW01Oy2TDnPv42Sa9bsFK35OnX8tMT0cQ8UVE4OSY9+8Fvs
         JfQdrS7d2ECnqGDtifR3YZeVHOqRbQpw7N3PinUAzn17P4e64E3eLJ7ykRRiiVAd/dov
         snOsAohijq07/JIB7bT9lRtAtxwkd/Hj+99McW1LTdgxIkSRcRP4g+k6iD4LxofyihAi
         TaEi2IQRqgbcPv8ZEC5UnqK5e3SEJCxHS4d/ril0/64Cy4A7g0PVIFiudsyckenOu6Db
         SUkw==
X-Gm-Message-State: AOAM531N36525BwQ/UvfAP5S3c/LG0Tk3YvTajV5Az4/ZSpLt5hynM4E
        jfBmUjWuBcQ6bRarhiwMrFw=
X-Google-Smtp-Source: ABdhPJyjclW1CrtMNdWsh3Kte5fkNuuzo96gzLf0b0s9pRSoKCRpm1QL0eAs/NeYcHcymB9ndrPQlw==
X-Received: by 2002:a62:d451:0:b029:2ff:4da3:5330 with SMTP id u17-20020a62d4510000b02902ff4da35330mr5975880pfl.6.1624403863926;
        Tue, 22 Jun 2021 16:17:43 -0700 (PDT)
Received: from localhost ([2402:3a80:1f84:2ac4:8d6c:3f60:b533:9c7])
        by smtp.gmail.com with ESMTPSA id g3sm3217935pjl.17.2021.06.22.16.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 16:17:43 -0700 (PDT)
Date:   Wed, 23 Jun 2021 04:46:06 +0530
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
Message-ID: <20210622231606.6ak5shta5bknt7lb@apollo>
References: <20210622202835.1151230-1-memxor@gmail.com>
 <20210622202835.1151230-3-memxor@gmail.com>
 <871r8tpnws.fsf@toke.dk>
 <20210622221023.gklikg5yib4ky35m@apollo>
 <87y2b1o7h9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87y2b1o7h9.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 04:03:06AM IST, Toke Høiland-Jørgensen wrote:
> Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:
>
> > On Wed, Jun 23, 2021 at 03:22:51AM IST, Toke Høiland-Jørgensen wrote:
> >> Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:
> >>
> >> > cpumap needs to set, clear, and test the lowest bit in skb pointer in
> >> > various places. To make these checks less noisy, add pointer friendly
> >> > bitop macros that also do some typechecking to sanitize the argument.
> >> >
> >> > These wrap the non-atomic bitops __set_bit, __clear_bit, and test_bit
> >> > but for pointer arguments. Pointer's address has to be passed in and it
> >> > is treated as an unsigned long *, since width and representation of
> >> > pointer and unsigned long match on targets Linux supports. They are
> >> > prefixed with double underscore to indicate lack of atomicity.
> >> >
> >> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> >> > ---
> >> >  include/linux/bitops.h    | 19 +++++++++++++++++++
> >> >  include/linux/typecheck.h | 10 ++++++++++
> >> >  2 files changed, 29 insertions(+)
> >> >
> >> > diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> >> > index 26bf15e6cd35..a9e336b9fa4d 100644
> >> > --- a/include/linux/bitops.h
> >> > +++ b/include/linux/bitops.h
> >> > @@ -4,6 +4,7 @@
> >> >
> >> >  #include <asm/types.h>
> >> >  #include <linux/bits.h>
> >> > +#include <linux/typecheck.h>
> >> >
> >> >  #include <uapi/linux/kernel.h>
> >> >
> >> > @@ -253,6 +254,24 @@ static __always_inline void __assign_bit(long nr, volatile unsigned long *addr,
> >> >  		__clear_bit(nr, addr);
> >> >  }
> >> >
> >> > +#define __ptr_set_bit(nr, addr)                         \
> >> > +	({                                              \
> >> > +		typecheck_pointer(*(addr));             \
> >> > +		__set_bit(nr, (unsigned long *)(addr)); \
> >> > +	})
> >> > +
> >> > +#define __ptr_clear_bit(nr, addr)                         \
> >> > +	({                                                \
> >> > +		typecheck_pointer(*(addr));               \
> >> > +		__clear_bit(nr, (unsigned long *)(addr)); \
> >> > +	})
> >> > +
> >> > +#define __ptr_test_bit(nr, addr)                       \
> >> > +	({                                             \
> >> > +		typecheck_pointer(*(addr));            \
> >> > +		test_bit(nr, (unsigned long *)(addr)); \
> >> > +	})
> >> > +
> >>
> >> Before these were functions that returned the modified values, now they
> >> are macros that modify in-place. Why the change? :)
> >>
> >
> > Given that we're exporting this to all kernel users now, it felt more
> > appropriate to follow the existing convention/argument order for the
> > functions/ops they are wrapping.
>
> I wasn't talking about the order of the arguments; swapping those is
> fine. But before, you had:
>
> static void *__ptr_set_bit(void *ptr, int bit)
>
> with usage (function return is the modified value):
> ret = ptr_ring_produce(rcpu->queue, __ptr_set_bit(skb, 0));
>
> now you have:
> #define __ptr_set_bit(nr, addr)
>
> with usage (modifies argument in-place):
> __ptr_set_bit(0, &skb);
> ret = ptr_ring_produce(rcpu->queue, skb);
>
> why change from function to macro?
>

Earlier it just took the pointer value and returned one with the bit set. I
changed it to work similar to __set_bit.

So such a function modifying in place doesn't allow seeing through what the type
of *addr is, it would have to take void * which would work with any pointer.
It's just a little more safe (so we can be sure casting to unsigned long * is
ok by inspecting the typeof(*addr) ).

> -Toke
>

--
Kartikeya
