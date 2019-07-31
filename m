Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2117CC2E
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 20:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbfGaSnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 14:43:49 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:34002 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727579AbfGaSnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 14:43:49 -0400
Received: by mail-ua1-f66.google.com with SMTP id c4so553749uad.1
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 11:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=IxiPG5JBpgXwecY148JXK9Fv92oaW5LmjycVe1KRwBI=;
        b=yEyfqXpAJsrTQmLBGgpogw947B2/m7oVOs4a5pE4FyicIoy1vozhuP3A0Y5LegBtzf
         P/HVmh7c3OVqvhM1qDGvGugcth5MIT8RcK0JDjQR+7eTEGxZ4BbhYMmpdIsLI84PKO6r
         qPrjg2s7DcrwYijuXfmJWYTLJkVtza72s2iIWXaR5sxKg0WJOxjJsUD7XU1Vr0dGbrTT
         I5ZQG0Plha6WT1l9t7d6OqPmgZZ9dYSmOqFDjPJ4QOOSEqJ2QGgBYniBYeHj7MAihV0u
         TvXz3fMFoSlumAuROIryRKf2xXkOU34mYMi8RBHMOZtvoUpU3wRN41lpW+xN3J+0F3Tb
         awFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=IxiPG5JBpgXwecY148JXK9Fv92oaW5LmjycVe1KRwBI=;
        b=DOmgs+XDnXbv6f/tVJxE59vlEZo7YCc+qxZEGy9JBZjQo+PC87FCcQbQwGQ+wJ/9av
         AYTHzoJ7SWSODDI0TnyEdxKIeAz61173wvHNtBjkEmVu3QSLGJkCDzN+XMkYZevbX21o
         twNGB88/wEDq9rVHjlIsqTF4+31iYp3Ls62Ati0LIOlYMwKBFE/Zs1m0tkdJXOXn1nyY
         wANeHOAcQMaISdyF0FmqC7zs8L9D+YRoyCdTEYRSiarRolanzgzT17heLPr2ZXuBGjdK
         nAU4Zj5ylPlh5q7aDEubqEpgWpq/9JeVPJ2Lg+//+C6CXoGEoJQxTgtDPnWYR7L4BRlJ
         S6OA==
X-Gm-Message-State: APjAAAVPAsS3KWtlHJm+SomMuIb+2QCg60ZyIAgBlJ4nJyJqJuv/7e3M
        BnO0UwZjFlw6KWuYGifS+Gf8dQ==
X-Google-Smtp-Source: APXvYqw72swVIHYv7i56UH4Ilr/JjjjrXenRJ8ZQnBaZNTT8r4jBGJv8BtwJcsHQEiptza+jzF8C3w==
X-Received: by 2002:ab0:1e09:: with SMTP id m9mr63473391uak.107.1564598628136;
        Wed, 31 Jul 2019 11:43:48 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g207sm21878748vke.12.2019.07.31.11.43.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 11:43:48 -0700 (PDT)
Date:   Wed, 31 Jul 2019 11:43:32 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Boris Pismenny <borisp@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        "davejwatson@fb.com" <davejwatson@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "willemb@google.com" <willemb@google.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "fw@strlen.de" <fw@strlen.de>,
        "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH net-next] net/tls: prevent skb_orphan() from leaking TLS
 plain text with offload
Message-ID: <20190731114332.20e6f31e@cakuba.netronome.com>
In-Reply-To: <c86943db-f098-3ce8-f0d1-4f04ba676d40@mellanox.com>
References: <20190730211258.13748-1-jakub.kicinski@netronome.com>
        <c86943db-f098-3ce8-f0d1-4f04ba676d40@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Jul 2019 13:57:26 +0000, Boris Pismenny wrote:
> > diff --git a/Documentation/networking/tls-offload.rst b/Documentation/networking/tls-offload.rst
> > index 048e5ca44824..2bc3ab5515d8 100644
> > --- a/Documentation/networking/tls-offload.rst
> > +++ b/Documentation/networking/tls-offload.rst
> > @@ -499,15 +499,6 @@ offloads, old connections will remain active after flags are cleared.
> >   Known bugs
> >   ==========
> >   
> > -skb_orphan() leaks clear text
> > ------------------------------
> > -
> > -Currently drivers depend on the :c:member:`sk` member of
> > -:c:type:`struct sk_buff <sk_buff>` to identify segments requiring
> > -encryption. Any operation which removes or does not preserve the socket
> > -association such as :c:func:`skb_orphan` or :c:func:`skb_clone`
> > -will cause the driver to miss the packets and lead to clear text leaks.
> > -
> >   Redirects leak clear text
> >   -------------------------  
> Doesn't this patch cover the redirect case as well?

Ah, good catch! I thought this entry was for socket redirect, which
will be a separate fix, but it seems we don't have an entry for that
one. 

> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index 228db3998e46..90f3f552c789 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -814,6 +814,7 @@ enum sock_flags {
> >   	SOCK_TXTIME,
> >   	SOCK_XDP, /* XDP is attached */
> >   	SOCK_TSTAMP_NEW, /* Indicates 64 bit timestamps always */
> > +	SOCK_CRYPTO_TX_PLAIN_TEXT, /* Generate skbs with decrypted flag set */
> >   };
> >   
> >   #define SK_FLAGS_TIMESTAMP ((1UL << SOCK_TIMESTAMP) | (1UL << SOCK_TIMESTAMPING_RX_SOFTWARE))
> > @@ -2480,8 +2481,26 @@ static inline bool sk_fullsock(const struct sock *sk)
> >   	return (1 << sk->sk_state) & ~(TCPF_TIME_WAIT | TCPF_NEW_SYN_RECV);
> >   }
> >   
> > +static inline void sk_set_tx_crypto(const struct sock *sk, struct sk_buff *skb)
> > +{
> > +#ifdef CONFIG_TLS_DEVICE
> > +	skb->decrypted = sock_flag(sk, SOCK_CRYPTO_TX_PLAIN_TEXT);
> > +#endif
> > +}  
> 
> Have you considered the following alternative to calling 
> sk_set_tx_crypto() - Add a new MSG_DECRYPTE flag that will set the 
> skb->decrypted bit in the do_tcp_sendpages function.
> 
> Then, the rest of the TCP code can propagate this bit from the existing skb.

That'd also work marking the socket as crypto seemed easy enough. I was
planning on using sk_rx_crypto_match() for socket redirect also, so
it'd be symmetrical. Is there a preference for using the internal flags?

> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index f62f0e7e3cdd..dee93eab02fe 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -984,6 +984,7 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
> >   			if (!skb)
> >   				goto wait_for_memory;
> >   
> > +			sk_set_tx_crypto(sk, skb);
> >   			skb_entail(sk, skb);
> >   			copy = size_goal;
> >   		}
> > @@ -993,7 +994,8 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
> >   
> >   		i = skb_shinfo(skb)->nr_frags;
> >   		can_coalesce = skb_can_coalesce(skb, i, page, offset);
> > -		if (!can_coalesce && i >= sysctl_max_skb_frags) {
> > +		if ((!can_coalesce && i >= sysctl_max_skb_frags) ||
> > +		    !sk_tx_crypto_match(sk, skb)) {  
> 
> I see that sk_tx_crypto_match is called only here to handle cases where 
> the socket expected crypto offload, while the skb is not marked 
> decrypted. AFAIU, this should not be possible, because we set the 
> skb->eor bit for the last plaintext skb before sending any traffic that 
> expects crypto offload.

Ack, I missed the tcp_skb_can_collapse_to() above.
