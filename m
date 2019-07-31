Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0CE47CB9D
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 20:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbfGaSMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 14:12:30 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38974 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727723AbfGaSM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 14:12:29 -0400
Received: by mail-qk1-f193.google.com with SMTP id w190so49923383qkc.6
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 11:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=opJCMVmYYyfdmu8hXBlLsOgXE8xalFUlA5qwyk0wKXs=;
        b=ZtOMUJ2d0H6KovWa3Loui4/Djr/QwatTIG10qFNBeB5sX7Ic4yvetRuUmlnO9CZYQh
         n64EckavLOdbQY4mRJ3a4KDLlRR6PS28ndlT3HmPVN32QNkMtkDkF1jlCREF8epxgDBP
         Oa/Bn+bcmLp3Vk+ai1/cAbfyQBDRlBjNLZJCGyfw6esVX/EhPH5IKDAMtRGiw4/NZjyW
         AwbvykoKZy61vqPdTnsHgFlrla1cgeVcWGglIQAdCcBSnMD+mXLyZagHyYFaEQoNwZkS
         M5YCw1MGcxxdHpvwN36D+ruzlbRLfdz/6caTTq7fn7h9WUekXXGCjQZMBzGwlHNGyRR1
         +guA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=opJCMVmYYyfdmu8hXBlLsOgXE8xalFUlA5qwyk0wKXs=;
        b=MJZp8HZXfyZqHJaxJCZ6ss1wU0LMpKVbJq/iwLsBa+rR4vb1CX70kL5auCeDXbUQA3
         A1B1u4L0p+b8dHSCTxdoFpfxPfxvBeY8T7kbfN1EXQPjQc1fYcrfqDtHcs1w38a3gYdV
         pxlfJCw7VL3lLyQdnbNlbkhxRqMUnS1y05ZiXVmZdUXrlqYeF/2BcOjUGzlm3QJugp94
         vHQX9+CgDE3+SfyT11trQtcNg22ZLGSX/D8XaXbKZ6ePNybcjoKdLkVG+6gtPucdvK25
         A1ZX/5fQ59m9AxEyfb5sIHofichI5ukkLKJHKOElVkMjEuTA9hwUGWKUc1CJjOiS0qGk
         A1hA==
X-Gm-Message-State: APjAAAXsADcbGKM7iqDWPOWY1jCTFyBXk2Ber0nzdh66QgzUtgaEzqdo
        XIz5nvh9B7g31itev2z2mCoMWKzINzM=
X-Google-Smtp-Source: APXvYqzrVIw6puIILKmLnKGO55KT1z+s04RjDgYtKwV+ookB9I9DC73bBxb/2XAqZx637dJ0RUx48w==
X-Received: by 2002:a37:bd7:: with SMTP id 206mr82384485qkl.440.1564596748722;
        Wed, 31 Jul 2019 11:12:28 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 39sm37897544qts.41.2019.07.31.11.12.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 11:12:28 -0700 (PDT)
Date:   Wed, 31 Jul 2019 11:12:13 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        oss-drivers@netronome.com, Eric Dumazet <edumazet@google.com>,
        borisp@mellanox.com, aviadye@mellanox.com, davejwatson@fb.com,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [oss-drivers] Re: [PATCH net-next] net/tls: prevent
 skb_orphan() from leaking TLS plain text with offload
Message-ID: <20190731111213.35237adc@cakuba.netronome.com>
In-Reply-To: <CA+FuTSdN41z5PVfyT5Z-ApnKQ9CYcDSnr4VGZnsgA-iAEK12Ow@mail.gmail.com>
References: <20190730211258.13748-1-jakub.kicinski@netronome.com>
        <CA+FuTSdN41z5PVfyT5Z-ApnKQ9CYcDSnr4VGZnsgA-iAEK12Ow@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Jul 2019 11:57:10 -0400, Willem de Bruijn wrote:
> On Tue, Jul 30, 2019 at 5:13 PM Jakub Kicinski wrote:
> > sk_validate_xmit_skb() and drivers depend on the sk member of
> > struct sk_buff to identify segments requiring encryption.
> > Any operation which removes or does not preserve the original TLS
> > socket such as skb_orphan() or skb_clone() will cause clear text
> > leaks.
> >
> > Make the TCP socket underlying an offloaded TLS connection
> > mark all skbs as decrypted, if TLS TX is in offload mode.
> > Then in sk_validate_xmit_skb() catch skbs which have no socket
> > (or a socket with no validation) and decrypted flag set.
> >
> > Note that CONFIG_SOCK_VALIDATE_XMIT, CONFIG_TLS_DEVICE and
> > sk->sk_validate_xmit_skb are slightly interchangeable right now,
> > they all imply TLS offload. The new checks are guarded by
> > CONFIG_TLS_DEVICE because that's the option guarding the
> > sk_buff->decrypted member.
> >
> > Second, smaller issue with orphaning is that it breaks
> > the guarantee that packets will be delivered to device
> > queues in-order. All TLS offload drivers depend on that
> > scheduling property. This means skb_orphan_partial()'s
> > trick of preserving partial socket references will cause
> > issues in the drivers. We need a full orphan, and as a
> > result netem delay/throttling will cause all TLS offload
> > skbs to be dropped.
> >
> > Reusing the sk_buff->decrypted flag also protects from
> > leaking clear text when incoming, decrypted skb is redirected
> > (e.g. by TC).
> >
> > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index d57b0cc995a0..b0c10b518e65 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -1992,6 +1992,22 @@ void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
> >  }
> >  EXPORT_SYMBOL(skb_set_owner_w);
> >
> > +static bool can_skb_orphan_partial(const struct sk_buff *skb)
> > +{
> > +#ifdef CONFIG_TLS_DEVICE
> > +       /* Drivers depend on in-order delivery for crypto offload,
> > +        * partial orphan breaks out-of-order-OK logic.
> > +        */
> > +       if (skb->decrypted)
> > +               return false;
> > +#endif
> > +#ifdef CONFIG_INET
> > +       if (skb->destructor == tcp_wfree)
> > +               return true;
> > +#endif
> > +       return skb->destructor == sock_wfree;
> > +}
> > +  
> 
> Just insert the skb->decrypted check into skb_orphan_partial for less
> code churn?

Okie.. skb_orphan_partial() is a little ugly but will do.

> I also think that this is an independent concern from leaking plain
> text, so perhaps could be a separate patch.

Do you mean the out-of-order stuff is a separate concern?

It is, I had them separate at the first try, but GSO code looks at
the destructor and IIRC only copies the socket if its still tcp_wfree.
If we let partial orphan be we have to do temporary hairy stuff in
tcp_gso_segment(). It's easier to just deal with partial orphan here.
