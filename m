Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7AF57CC7D
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 21:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729886AbfGaTIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 15:08:17 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46424 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbfGaTIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 15:08:17 -0400
Received: by mail-ed1-f68.google.com with SMTP id d4so66786901edr.13
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 12:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3SxWjACIDWjy2kZPugWAeoKbit4LgM+rwBGOms1xL04=;
        b=vRzgqOIugS3yUECVs7i4m8aYfsQSTtff5EFxlvm59J1tY9jS7zFScDqMcBW3q0l7Yf
         6WJOpihBdACTtni3NJXQwQqwSzEJ2As9geMIWs5TEgCpTcTOhj1OOGULBO8P+T77v/U2
         pcTN4eOAtBu6nNug+ZgXgkhhrJgFuZdyMJXNO3MZfSgFsUvs5rdjX28e0VNvvBu8JKFv
         DFCZ97WmJ0ZWH751Idz268EfAsP6ySymVhyH6avm/C4WpEIf8yFz9KE/qzX+xjHkFQiG
         UfdiUxfe5Z3LoXLIuB/MZ8Wp+wdBRUDA0yts7EEQGDKNNtTCJQc71VQn30tGiz/GjLW6
         zdUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3SxWjACIDWjy2kZPugWAeoKbit4LgM+rwBGOms1xL04=;
        b=BC6J/hoZC5qkHtyiARPM919746wSOuRNiADlxTOR5GaHpv8TOtKhODfa64CmmKpR5z
         hUMt7LOujE7M9YUNPvE+lGN9eq3tZfTPX+HKXwgSpQ2Vq7TUTysKLMLgVE3JgfGJv8HT
         JAhnfqCzQQoDePcSyMtR7OSmoJ3hm/gf6Ja3ATIZ/ykeyBqFMUEdxJPsf4WjxWwkrbVu
         Vc10ls6GtbmL7m4Sc1Nho40+joShiECk6OFkH/IEQDpwZV0yAVxPbIB1bc3RtYiZr+ZB
         PTnHHHnziyBmNRckuKGSzEtGMinUJA7H3SAYPbdmmJ6N3kSKBYu700sljw3j4oPxL5fs
         /zGg==
X-Gm-Message-State: APjAAAX/NrxkikU1dSBo9LvRCKMnkOQozNkcUJj//RqLGGWEJCB0MDAS
        10AGEwAv+xU5hS4FjUxDcvLJ3Z3xiOhFhEqCKj8=
X-Google-Smtp-Source: APXvYqxEn72/U9TOHcVDesXZxKzlXh9IvgJb1NvRa6rVjqXz4Nqdb5XE4mYyteum8UpGa+/UdqXEzjgOfCU0IaIDVDA=
X-Received: by 2002:a50:9153:: with SMTP id f19mr110680280eda.70.1564600095481;
 Wed, 31 Jul 2019 12:08:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190730211258.13748-1-jakub.kicinski@netronome.com>
 <CA+FuTSdN41z5PVfyT5Z-ApnKQ9CYcDSnr4VGZnsgA-iAEK12Ow@mail.gmail.com> <20190731111213.35237adc@cakuba.netronome.com>
In-Reply-To: <20190731111213.35237adc@cakuba.netronome.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 31 Jul 2019 15:07:39 -0400
Message-ID: <CAF=yD-+1jUkwXxyOyiH6qwheLTDNQupS_qg+Ra4WbtSogXp4nQ@mail.gmail.com>
Subject: Re: [oss-drivers] Re: [PATCH net-next] net/tls: prevent skb_orphan()
 from leaking TLS plain text with offload
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        oss-drivers@netronome.com, Eric Dumazet <edumazet@google.com>,
        borisp@mellanox.com, aviadye@mellanox.com, davejwatson@fb.com,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 2:12 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Wed, 31 Jul 2019 11:57:10 -0400, Willem de Bruijn wrote:
> > On Tue, Jul 30, 2019 at 5:13 PM Jakub Kicinski wrote:
> > > sk_validate_xmit_skb() and drivers depend on the sk member of
> > > struct sk_buff to identify segments requiring encryption.
> > > Any operation which removes or does not preserve the original TLS
> > > socket such as skb_orphan() or skb_clone() will cause clear text
> > > leaks.
> > >
> > > Make the TCP socket underlying an offloaded TLS connection
> > > mark all skbs as decrypted, if TLS TX is in offload mode.
> > > Then in sk_validate_xmit_skb() catch skbs which have no socket
> > > (or a socket with no validation) and decrypted flag set.
> > >
> > > Note that CONFIG_SOCK_VALIDATE_XMIT, CONFIG_TLS_DEVICE and
> > > sk->sk_validate_xmit_skb are slightly interchangeable right now,
> > > they all imply TLS offload. The new checks are guarded by
> > > CONFIG_TLS_DEVICE because that's the option guarding the
> > > sk_buff->decrypted member.
> > >
> > > Second, smaller issue with orphaning is that it breaks
> > > the guarantee that packets will be delivered to device
> > > queues in-order. All TLS offload drivers depend on that
> > > scheduling property. This means skb_orphan_partial()'s
> > > trick of preserving partial socket references will cause
> > > issues in the drivers. We need a full orphan, and as a
> > > result netem delay/throttling will cause all TLS offload
> > > skbs to be dropped.
> > >
> > > Reusing the sk_buff->decrypted flag also protects from
> > > leaking clear text when incoming, decrypted skb is redirected
> > > (e.g. by TC).
> > >
> > > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>
> > > diff --git a/net/core/sock.c b/net/core/sock.c
> > > index d57b0cc995a0..b0c10b518e65 100644
> > > --- a/net/core/sock.c
> > > +++ b/net/core/sock.c
> > > @@ -1992,6 +1992,22 @@ void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
> > >  }
> > >  EXPORT_SYMBOL(skb_set_owner_w);
> > >
> > > +static bool can_skb_orphan_partial(const struct sk_buff *skb)
> > > +{
> > > +#ifdef CONFIG_TLS_DEVICE
> > > +       /* Drivers depend on in-order delivery for crypto offload,
> > > +        * partial orphan breaks out-of-order-OK logic.
> > > +        */
> > > +       if (skb->decrypted)
> > > +               return false;
> > > +#endif
> > > +#ifdef CONFIG_INET
> > > +       if (skb->destructor == tcp_wfree)
> > > +               return true;
> > > +#endif
> > > +       return skb->destructor == sock_wfree;
> > > +}
> > > +
> >
> > Just insert the skb->decrypted check into skb_orphan_partial for less
> > code churn?
>
> Okie.. skb_orphan_partial() is a little ugly but will do.
>
> > I also think that this is an independent concern from leaking plain
> > text, so perhaps could be a separate patch.

Just a suggestion and very much depending on how much uglier it
becomes otherwise ;)

> Do you mean the out-of-order stuff is a separate concern?
>
> It is, I had them separate at the first try, but GSO code looks at
> the destructor and IIRC only copies the socket if its still tcp_wfree.
> If we let partial orphan be we have to do temporary hairy stuff in
> tcp_gso_segment(). It's easier to just deal with partial orphan here.

Okay, sounds good.
