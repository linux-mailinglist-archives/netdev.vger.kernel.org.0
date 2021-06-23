Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8223B1888
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhFWLLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:11:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24926 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230036AbhFWLLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:11:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624446544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CZEEymDDfR8efFo43cjUGn36eWEQ3C2e+pjvjw6A7Nw=;
        b=HXjuBPMl/z5iRGSiOcN6HuR3PuYO21ZwUp+BsJrluMM6fLLiB3cemqTl8cL7AO98K9enQE
        ds4jeswUgki+coXeaFHTakVtP89MbFZTnmwC7YfzVk8VU9j/UI7k88dzPdQqtAliX1YVH4
        JlKdOQI7NZ6FJQaumh95UN6LpSYmzHE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-n9SAvHkSPISNxlBFwTChGw-1; Wed, 23 Jun 2021 07:09:03 -0400
X-MC-Unique: n9SAvHkSPISNxlBFwTChGw-1
Received: by mail-ed1-f70.google.com with SMTP id q7-20020aa7cc070000b029038f59dab1c5so1088464edt.23
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 04:09:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=CZEEymDDfR8efFo43cjUGn36eWEQ3C2e+pjvjw6A7Nw=;
        b=eV4iYMdBNq1NHcExhM9J17WFiLek34+zIENfokEqiG97qpCcC8Vg2zC4swcROg7g30
         TL0x1ik2JpQuW18+UD+S0A/65aEdcbv+9Ho4ADoLE5TLxkSHeM0QeugehBAf8bkG7Qfv
         +r+e+lrJIH8Dn2O3McwTAPtGo7h8QcQhiEZPS+kDBz92BiJh8ivhWV+Ccy/IrxjS2fII
         OV8n3cMQLKsh27oq9UUdJ4GfXMsGFeYynPTFyDqXtAKgvremHfiELdYvBSuozkg0hIju
         rDtKE+F1PTxoDjfck07v9GuImUKvOMQybvjgahIrHAEReXUyAEbys8tums47ah5/2x1L
         iaww==
X-Gm-Message-State: AOAM5301Vt34jSAJTEdChzM2Q2q4NafRB7JYStrtW1XpTkLWkeR5EAuQ
        Tb3wy9Q13/Ink3/LENDzgnt/qjHKKhFCpEvkrsiPbKIVxU81n2Vf+BFpy0U475DKI6XrHswH8l+
        YQjznTgO1z+ZuDKlQ
X-Received: by 2002:a17:906:4a96:: with SMTP id x22mr9208765eju.20.1624446542061;
        Wed, 23 Jun 2021 04:09:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2Cr57AO7gmJROrNJhJ4rlKf989GA0vtppZ5bcn49sDufCZrzjdnSdM8Lp4thAa9VkXpiLOQ==
X-Received: by 2002:a17:906:4a96:: with SMTP id x22mr9208740eju.20.1624446541888;
        Wed, 23 Jun 2021 04:09:01 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id g16sm7075151ejh.92.2021.06.23.04.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 04:09:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DF674180737; Wed, 23 Jun 2021 13:09:00 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/5] bitops: add non-atomic bitops for pointers
In-Reply-To: <20210622231606.6ak5shta5bknt7lb@apollo>
References: <20210622202835.1151230-1-memxor@gmail.com>
 <20210622202835.1151230-3-memxor@gmail.com> <871r8tpnws.fsf@toke.dk>
 <20210622221023.gklikg5yib4ky35m@apollo> <87y2b1o7h9.fsf@toke.dk>
 <20210622231606.6ak5shta5bknt7lb@apollo>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 23 Jun 2021 13:09:00 +0200
Message-ID: <87bl7won1v.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> On Wed, Jun 23, 2021 at 04:03:06AM IST, Toke H=C3=B8iland-J=C3=B8rgensen =
wrote:
>> Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:
>>
>> > On Wed, Jun 23, 2021 at 03:22:51AM IST, Toke H=C3=B8iland-J=C3=B8rgens=
en wrote:
>> >> Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:
>> >>
>> >> > cpumap needs to set, clear, and test the lowest bit in skb pointer =
in
>> >> > various places. To make these checks less noisy, add pointer friend=
ly
>> >> > bitop macros that also do some typechecking to sanitize the argumen=
t.
>> >> >
>> >> > These wrap the non-atomic bitops __set_bit, __clear_bit, and test_b=
it
>> >> > but for pointer arguments. Pointer's address has to be passed in an=
d it
>> >> > is treated as an unsigned long *, since width and representation of
>> >> > pointer and unsigned long match on targets Linux supports. They are
>> >> > prefixed with double underscore to indicate lack of atomicity.
>> >> >
>> >> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>> >> > ---
>> >> >  include/linux/bitops.h    | 19 +++++++++++++++++++
>> >> >  include/linux/typecheck.h | 10 ++++++++++
>> >> >  2 files changed, 29 insertions(+)
>> >> >
>> >> > diff --git a/include/linux/bitops.h b/include/linux/bitops.h
>> >> > index 26bf15e6cd35..a9e336b9fa4d 100644
>> >> > --- a/include/linux/bitops.h
>> >> > +++ b/include/linux/bitops.h
>> >> > @@ -4,6 +4,7 @@
>> >> >
>> >> >  #include <asm/types.h>
>> >> >  #include <linux/bits.h>
>> >> > +#include <linux/typecheck.h>
>> >> >
>> >> >  #include <uapi/linux/kernel.h>
>> >> >
>> >> > @@ -253,6 +254,24 @@ static __always_inline void __assign_bit(long =
nr, volatile unsigned long *addr,
>> >> >  		__clear_bit(nr, addr);
>> >> >  }
>> >> >
>> >> > +#define __ptr_set_bit(nr, addr)                         \
>> >> > +	({                                              \
>> >> > +		typecheck_pointer(*(addr));             \
>> >> > +		__set_bit(nr, (unsigned long *)(addr)); \
>> >> > +	})
>> >> > +
>> >> > +#define __ptr_clear_bit(nr, addr)                         \
>> >> > +	({                                                \
>> >> > +		typecheck_pointer(*(addr));               \
>> >> > +		__clear_bit(nr, (unsigned long *)(addr)); \
>> >> > +	})
>> >> > +
>> >> > +#define __ptr_test_bit(nr, addr)                       \
>> >> > +	({                                             \
>> >> > +		typecheck_pointer(*(addr));            \
>> >> > +		test_bit(nr, (unsigned long *)(addr)); \
>> >> > +	})
>> >> > +
>> >>
>> >> Before these were functions that returned the modified values, now th=
ey
>> >> are macros that modify in-place. Why the change? :)
>> >>
>> >
>> > Given that we're exporting this to all kernel users now, it felt more
>> > appropriate to follow the existing convention/argument order for the
>> > functions/ops they are wrapping.
>>
>> I wasn't talking about the order of the arguments; swapping those is
>> fine. But before, you had:
>>
>> static void *__ptr_set_bit(void *ptr, int bit)
>>
>> with usage (function return is the modified value):
>> ret =3D ptr_ring_produce(rcpu->queue, __ptr_set_bit(skb, 0));
>>
>> now you have:
>> #define __ptr_set_bit(nr, addr)
>>
>> with usage (modifies argument in-place):
>> __ptr_set_bit(0, &skb);
>> ret =3D ptr_ring_produce(rcpu->queue, skb);
>>
>> why change from function to macro?
>>
>
> Earlier it just took the pointer value and returned one with the bit set.=
 I
> changed it to work similar to __set_bit.

Hmm, okay, fair enough I suppose there's something to be said for
consistency, even though I personally prefer the function style. Let's
keep it as macros, then :)

-Toke

