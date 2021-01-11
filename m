Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CF72F0E94
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 09:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbhAKIz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 03:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728061AbhAKIz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 03:55:57 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEE8C061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 00:55:17 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id x13so16192769oto.8
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 00:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r3+4ea1T0PKlqhS8IXaS+xftv/9SxAE/Ihj1vdkKG7s=;
        b=WjrwdmAd//D3+94x+1f9EiUZBrwnvoUx2Lk3gv1yhtYpbEeINDjFnLMZiipBHx1m4a
         IVkxER6FXoaKwfya3FMQgq0SQdU3RK6zpPLb1fEX9N+l3QwgET5VTEvakuqimeSPmK75
         GZUkbdiB1nQGNZMMWC5nrgd8at/8tZ+i8IZV1fTw4Y8xPAqZZSKgbhVk592UbFpiRXHj
         pBQHi0T5TECBotIiirnB4Uw2kE3YI97BV7GirRltkQXS1+Q+oK6SmUpHP8HiEA//mTR2
         NN4Bz/KNzGieoxVN6obo6T9j1OW0rV/OQOTmW5V5QnbnLKhc8vlL8zZpHz2fR0zy+/dp
         LiFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r3+4ea1T0PKlqhS8IXaS+xftv/9SxAE/Ihj1vdkKG7s=;
        b=JbSMFGldSD3qJ7lss+yO0xRbCuwt+CYo4luBMaSEu4RcCy/qg9Ii0ow7tG2CRFb9kD
         Uvd79aWD/02cZECiJvqHyWeK9gaGD9LX1csl435C4ISYSzpJ9uThVOKGMToYm5wj218Q
         cCRpnKCYcmPeE0DXaNvzIfPjko/s7X5wdSYM8X7urHllWsrC0JbjU0eJXkipO39FjUcs
         FXKXkAE3ssCN0RZeAImlBwIE/gtORaV5gJs/b5+OYBm/YNgiJ6TkzV7jEtr9Y04ZPWEj
         bQgAZkW8n5dbgoiPYLWO2O9hvAKgVyoNbIGkn5GFCnF+dIHfn0+R++yGk2N2/arU6qr3
         5QIA==
X-Gm-Message-State: AOAM5300H11KZ0BeIDbCkKNagdvli0LtvpGAbJTr4QYEoGtNSW8PyJeL
        YSTtlBrCVu/EYyqVMzAk16/ldYGB3KD1T4QMgvkURD+U+Gk=
X-Google-Smtp-Source: ABdhPJxt2l0jP8I6AgfnjzZs+XrSWx+j2uy1bveCVUjwKVabRfjJCrCU3G+Oe0YRl8DGvQ+MR+4bDVGPX5JdtPlIXhg=
X-Received: by 2002:a05:6830:19ca:: with SMTP id p10mr10393840otp.233.1610355316686;
 Mon, 11 Jan 2021 00:55:16 -0800 (PST)
MIME-Version: 1.0
References: <000000000000b4862805b54ef573@google.com> <X8kLG5D+j4rT6L7A@elver.google.com>
 <CANn89iJWD5oXPLgtY47umTgo3gCGBaoy+XJfXnw1ecES_EXkCw@mail.gmail.com>
 <CANpmjNOaWbGJQ5Y=qC3cA31-R-Jy4Fbe+p=OBG5O2Amz8dLtLA@mail.gmail.com>
 <CANn89iKWf1EVZUuAHup+5ndhxvOqGopq53=vZ9yeok=DnRjggg@mail.gmail.com>
 <X8kjPIrLJUd8uQIX@elver.google.com> <af884a0e-5d4d-f71b-4821-b430ac196240@gmail.com>
 <CANpmjNNDKm_ObRnO_b3gH6wDYjb6_ex-KhZA5q5BRzEMgo+0xg@mail.gmail.com>
 <X9DHa2OG6lewtfPQ@elver.google.com> <X9JR/J6dMMOy1obu@elver.google.com>
 <CANn89i+2mAu_srdvefKLDY23HvrbOG1aMfj5uwvk6tYZ9uBtMA@mail.gmail.com>
 <CANpmjNMdgX1H=ztDH5cpmmZJ3duL4M8Vn9Ty-XzNpsrhx0h4sA@mail.gmail.com>
 <CANpmjNPdK3rRF5eJM5uZ-8wJDp_8TF1P3jOvAo8kqu4YDDJtGQ@mail.gmail.com> <CANn89iJeS+WBB7=OvrRE1pbdYtxx4Oe7MYN3vCefZj3gO8AoYg@mail.gmail.com>
In-Reply-To: <CANn89iJeS+WBB7=OvrRE1pbdYtxx4Oe7MYN3vCefZj3gO8AoYg@mail.gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Mon, 11 Jan 2021 09:55:05 +0100
Message-ID: <CANpmjNOA5Rhmpi0tONk3gWp-S1cm8HErCxjQL-+wH88V=DpRRg@mail.gmail.com>
Subject: Re: WARNING in sk_stream_kill_queues (5)
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Jann Horn <jannh@google.com>, Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 at 11:47, Eric Dumazet <edumazet@google.com> wrote:
> On Mon, Dec 14, 2020 at 11:09 AM Marco Elver <elver@google.com> wrote:
> > On Thu, 10 Dec 2020 at 20:01, Marco Elver <elver@google.com> wrote:
> > > On Thu, 10 Dec 2020 at 18:14, Eric Dumazet <edumazet@google.com> wrote:
> > > > On Thu, Dec 10, 2020 at 5:51 PM Marco Elver <elver@google.com> wrote:
[...]
> > > Either option is fine, as long as it avoids this problem in future.
> > > Hopefully it can be fixed for 5.11.
> > >
> > > > (All TCP skbs in output path have the same allocation size for skb->head)
> > > >
> > > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > > index e578544b2cc7110ec2f6bcf4c29d93e4b4b1ad14..798b51eeeaa4fbed65d41d9eab207dbbf438dab3
> > > > 100644
> > > > --- a/net/core/skbuff.c
> > > > +++ b/net/core/skbuff.c
> > > > @@ -3270,7 +3270,14 @@ EXPORT_SYMBOL(skb_split);
> > > >   */
> > > >  static int skb_prepare_for_shift(struct sk_buff *skb)
> > > >  {
> > > > -       return skb_cloned(skb) && pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
> > > > +       unsigned int ret = 0, save;
> > > > +
> > > > +       if (skb_cloned(skb)) {
> > > > +               save = skb->truesize;
> > > > +               ret = pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
> > > > +               skb->truesize = save;
> > > > +       }
> > > > +       return ret;
> > > >  }
> > >
> > > FWIW,
> > >
> > >     Tested-by: Marco Elver <elver@google.com>
> >
> > Has this patch, or similar, already been sent?
>
>
> Not yet, we have few weeks left before 5.11 is released ;)

Ping. Though KFENCE has been dropped from 5.11, just a reminder so we
get this fixed for 5.12.

Thanks,
-- Marco
