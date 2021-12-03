Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111C7467C20
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 18:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353372AbhLCRDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 12:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382707AbhLCRDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 12:03:06 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C97C061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 08:59:01 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id v138so11104693ybb.8
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 08:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SKrgr4/QRUfvFou9rJRtZQrnb3bU2LhbgcrC85cTs7c=;
        b=b1aBltB5mYFuzHHOLymOYVitbn4OVTlk+u+Ujdp7hPM7K6U+9wYkx1LTTKlgZv8mng
         6rPPhtdh3UotBQPhKaV/TybuasWJkbMhU/kEfT1iVQ+P1u6A9od+WJf4wkOh1JOf2+8z
         osB0inGBB3zCfdguY5ph3FDkPjDJ2NSTsaiXCAJA398aJn6hC64bsO6k6WA2gcWO7/pi
         utZi6YfzoA2CFsKw65FXhC/HZRI8c+T27p8EC9lZ0lJz0L4MKqMPOFimfvDVQFofDLBK
         /nFkSoxNH7oXxAEQsRxVsfIPIlHtGtBKBsYiGf0c6LjdY3vrgY6BzcQeRyXwVAjvS80b
         D2ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SKrgr4/QRUfvFou9rJRtZQrnb3bU2LhbgcrC85cTs7c=;
        b=r73nf5rhfkZKWRqGzV4g7VgvUG/f6RCSklcSM/PI/K7M++Oid6T5u6lfxSvTlnoe1z
         dESyz0Q8IGvrSZPdrg33cRTRBVbRI7k3Zg0qEAUhN4XIjFAriXjQrhPVhM71ckpc4Uy6
         GHvT75D1KRkLRddhcVCCkq/ttytdCcC1yxGzeTzVkEZvsTq/tdaHqZAWbRqWdzpl5/Hb
         OOZoLiYo/E8v717+fa7d9CkhYOoh+uUyzkTxgKGsDLXgYAIsRLVOD3udMo3+j2AczGYk
         1XS7rXWchhfbPyp1eZ2SCDvx4+0NleIVjdCt42zcXJPD3wKz7S4P9k5nzZqkiPitChod
         6MIQ==
X-Gm-Message-State: AOAM530V5/C/BUpUnXxvw2hsb/cW9MD7fTFZOlt1uHmhmGXQvPz/tGN8
        eXn8dFFYjxySIdpIk0i6xovyCX2Q/PGueJb354b9SQ==
X-Google-Smtp-Source: ABdhPJwoFItaxd17vob+tKYt+YjvICMkyxD27hw3N3wBDv5Vq7QKEc8VbIXCFU31Lt1Pl+FB/V58FI5lT77NZrEu+xA=
X-Received: by 2002:a5b:5c3:: with SMTP id w3mr5339059ybp.293.1638550740504;
 Fri, 03 Dec 2021 08:59:00 -0800 (PST)
MIME-Version: 1.0
References: <20211124202446.2917972-1-eric.dumazet@gmail.com>
 <20211124202446.2917972-3-eric.dumazet@gmail.com> <20211202131040.rdxzbfwh2slhftg5@skbuf>
 <CANn89iLW4kwKf0x094epVeCaKhB4GtYgbDwE2=Fp0HnW8UdKzw@mail.gmail.com>
 <20211202162916.ieb2wn35z5h4aubh@skbuf> <CANn89iJEfDL_3C39Gp9eD=yPDqW4MGcVm7AyUBcTVdakS-X2dg@mail.gmail.com>
 <20211202204036.negad3mnrm2gogjd@skbuf> <9eefc224988841c9b1a0b6c6eb3348b8@AcuMS.aculab.com>
 <20211202214009.5hm3diwom4qsbsjd@skbuf> <eb25fee06370430d8cd14e25dff5e653@AcuMS.aculab.com>
 <20211203161429.htqt4vuzd22rlwkf@skbuf> <CANn89iKk=DZEbwAeaborF-Q5pE9=Jahc0TP1_wk59s2eqB0o1A@mail.gmail.com>
 <43cc0ca9a0e14fc995c0c28d31440c15@AcuMS.aculab.com>
In-Reply-To: <43cc0ca9a0e14fc995c0c28d31440c15@AcuMS.aculab.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 3 Dec 2021 08:58:49 -0800
Message-ID: <CANn89i+sANhK4m_JptWgnjXf5VRuSYw6MkLKfS3ut5SbUbrmoQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
To:     David Laight <David.Laight@aculab.com>,
        David Lebrun <dlebrun@google.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 3, 2021 at 8:47 AM David Laight <David.Laight@aculab.com> wrote:
>
> > > Eric, could you please send a patch with this change?
> >
> > Sure, I will do this today, after more testing.
>
> I've just done a quick grep and found two ~csum_partial() in
> include/net/seg6.h.

This is what I already mentioned in this email thread, and the reason
I have CCed David Lebrun.

https://marc.info/?l=linux-netdev&m=163845851801840&w=2

David, can you comment on this ?


> Both are wrong (and completely horrid).
>
> There are also 40 csum_partial(buf, len, 0).
> If all the buffer is zero they'll return zero - invalid.
> They ought to be changed to csum_partial(buf, len, 0xffff).
>

Please point where all zero buffers can be valid in the first place.
