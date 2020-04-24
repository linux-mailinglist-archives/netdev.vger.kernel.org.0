Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB2E1B7C00
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 18:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbgDXQp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 12:45:56 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42734 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726793AbgDXQpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 12:45:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587746754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yy09tY/ZZlbYrJqIsbNBUE6nQ0igHKGYuqH3QoYuWS0=;
        b=X01z3whh4rxp9G4avbvfMlHBoI28TZcSxyFMgTldvkkkeyePtHcwA7pe+hx05WLavJ7oOT
        m446T5EkiAW6EWbf6pxlH2IKeHGp0AEODBn/oZ0LiedjoqHwJym10dNoBSkA1nMhkWZXbg
        XZ2jMZ+6axMueJE88UkBL8zH2tRsta4=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-6_mfGOm5P0mRXrRNIAgmww-1; Fri, 24 Apr 2020 12:45:52 -0400
X-MC-Unique: 6_mfGOm5P0mRXrRNIAgmww-1
Received: by mail-lj1-f199.google.com with SMTP id p7so2040587ljg.15
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 09:45:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Yy09tY/ZZlbYrJqIsbNBUE6nQ0igHKGYuqH3QoYuWS0=;
        b=ETCwyFyJkDKRsUpX08EzaJH2aWeRd2lZwK8ONlkYTdPEAVVntkEs/ptnpbrIo5YgB2
         TUTpvUqbUd9timCXgvTrHBqOjATcS1zowNyMLHf3sXKzgswHmu8Hfn/eO4t4ytGE/pDS
         LCvocdKDWCtldd9qrZX2sK+6WbkOMvOkcv1lg06/LzGbpNxM/hR+8qTz87u0cLFY/w/K
         IRtzufQo1zl93db9D6oXNtJLxBPGnUh9aBBaH3NGExoTl7rVu+YS+tKikwpWcBXv6+H3
         PHlld3pRjEsii/uNBweA8x5aiAK0U4zflaP6GuNSv77cFMqAWW2W+wCBF4FlnlYurVe6
         ezNQ==
X-Gm-Message-State: AGi0PuZp/5jwtcYolqzbKVCcx/FNM+uqvVTApyW8IJvi4jKl+Q++4nSZ
        eEGszavqiWGCgvxCtYQ+jYBBFWL0Ea/BxJYu0w+MU4nTYpKkHdzuT+DQx3293FwudhBJ/AwLUpi
        BX32+EdSpti394MNG
X-Received: by 2002:a19:d3:: with SMTP id 202mr6769747lfa.24.1587746750830;
        Fri, 24 Apr 2020 09:45:50 -0700 (PDT)
X-Google-Smtp-Source: APiQypIvCEQLkcrKSAwJCFZgQzfgjqKywU4JSqlCnHWOvJ3JNUix5g6gKJnloODQXFxA2oPJy9aVUQ==
X-Received: by 2002:a19:d3:: with SMTP id 202mr6769739lfa.24.1587746750602;
        Fri, 24 Apr 2020 09:45:50 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id v7sm4735362lfq.55.2020.04.24.09.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 09:45:49 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 09AA61814FF; Fri, 24 Apr 2020 18:45:48 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        netdev <netdev@vger.kernel.org>, dev@openvswitch.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: openvswitch: use do_div() for 64-by-32 divisions:
In-Reply-To: <CAMuHMdWVmP04cXEgAkOc9Qdb2Y2xjGd1YEOcMt7ehE70ZwdqjQ@mail.gmail.com>
References: <20200424121051.5056-1-geert@linux-m68k.org> <d2c14a2d-4e7b-d36a-be90-e987b1ea6183@gmail.com> <CAMuHMdWVmP04cXEgAkOc9Qdb2Y2xjGd1YEOcMt7ehE70ZwdqjQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 24 Apr 2020 18:45:47 +0200
Message-ID: <87ftcs3k90.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> Hi Eric,
>
> On Fri, Apr 24, 2020 at 5:05 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> On 4/24/20 5:10 AM, Geert Uytterhoeven wrote:
>> > On 32-bit architectures (e.g. m68k):
>> >
>> >     ERROR: modpost: "__udivdi3" [net/openvswitch/openvswitch.ko] undefined!
>> >     ERROR: modpost: "__divdi3" [net/openvswitch/openvswitch.ko] undefined!
>> >
>> > Fixes: e57358873bb5d6ca ("net: openvswitch: use u64 for meter bucket")
>> > Reported-by: noreply@ellerman.id.au
>> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> > ---
>> >  net/openvswitch/meter.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
>> > index 915f31123f235c03..3498a5ab092ab2b8 100644
>> > --- a/net/openvswitch/meter.c
>> > +++ b/net/openvswitch/meter.c
>> > @@ -393,7 +393,7 @@ static struct dp_meter *dp_meter_create(struct nlattr **a)
>> >                * Start with a full bucket.
>> >                */
>> >               band->bucket = (band->burst_size + band->rate) * 1000ULL;
>> > -             band_max_delta_t = band->bucket / band->rate;
>> > +             band_max_delta_t = do_div(band->bucket, band->rate);
>> >               if (band_max_delta_t > meter->max_delta_t)
>> >                       meter->max_delta_t = band_max_delta_t;
>> >               band++;
>> >
>>
>> This is fascinating... Have you tested this patch ?
>
> Sorry, I should have said this is compile-tested only.
>
>> Please double check what do_div() return value is supposed to be !
>
> I do not have any openvswitch setups, let alone on the poor m68k box.

I think what Eric is referring to is this, from the documentation of
do_div:

 * do_div - returns 2 values: calculate remainder and update new dividend
 * @n: uint64_t dividend (will be updated)
 * @base: uint32_t divisor
 *
 * Summary:
 * ``uint32_t remainder = n % base;``
 * ``n = n / base;``
 *
 * Return: (uint32_t)remainder


Specifically that last part :)

-Toke

