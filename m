Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0122192B98
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 15:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbgCYO4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 10:56:30 -0400
Received: from mail-qv1-f65.google.com ([209.85.219.65]:34330 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbgCYO43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 10:56:29 -0400
Received: by mail-qv1-f65.google.com with SMTP id o18so1185684qvf.1
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 07:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EvvQtc8eGvgG2BoB8CIVAjdzfjP2fRXsNdZ6CBVKbLk=;
        b=ddUEV3eHwn/Mk2qKfZalwTMJ4cAA2L0u4VAOXaKhKIjEyymtPy2hePuQchwVsfjnFX
         jVe0yhpHI/afnhW53YWxyCq5shQSt8ExgM0Xod7BVsHd+oB2T66gu+fYbf53e0BQwMiw
         WOvoDvVgX3C3ybxXg0jHdNM8wO08PhUjIqF/WqdyP1nPxGzBnYywxY/zOhuUA+BE88GV
         aLCwMuFZhTXqNtiGw9agZS69jH/g3vsV4X9ZhnJ7my68O3NbNpo039FMq2ndxNYEVr2u
         U0w6J5yJRHLZnfRP+IWx3JlYUi25tmZ2Tq4s1A9suUPt9LW3XYyyGWBSW/arwtzPUNDf
         Zs1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EvvQtc8eGvgG2BoB8CIVAjdzfjP2fRXsNdZ6CBVKbLk=;
        b=mddWt3z2bEpAjYPtjOSVJtlSMvJg1/SgB+2wbFMDGNcLVsdbuVRA11GI0k+6ywXYTe
         rq1Dwedpgi5izhQrhRKtBDD1p3TfuL7eIQNGG1IFikSzCrjC3Jo8ykNWVwfwsjLzdqEy
         qNdKxGOj9NyUjTok2TCi/uklB0rIJjWmG93F+jB1Z8liVKMe+IXRBZqvNuUzqLLmWTMa
         WDUVhjcHVHuiWKmasYtrKgRK0vS/NmUvH+VCzLQkAjHT6KQFYQMr1ce0/aPkMeDAPAFv
         zdzH4t1sfGaNg93HUhSsoUIRAlN8RaIIH72Vu4Ol2gW70E6wv5Wi4vGZ67FxcjwYcXRy
         JOkA==
X-Gm-Message-State: ANhLgQ2APynMpdaibhSlBv3B8T7ih0ghwvIigpRZ0ta/GCgAIEvXoKJL
        IuJoEK/aQ+w7JewYoIGMMAiD1Pef
X-Google-Smtp-Source: ADFU+vsNRBKgCsPDRkzlC37UU2NQEQPIeeBxvqbXeiwJZDVDSLyXJy/UiJ5FPi4BYIYSiVrVS0HJyg==
X-Received: by 2002:ad4:4182:: with SMTP id e2mr3575038qvp.32.1585148188028;
        Wed, 25 Mar 2020 07:56:28 -0700 (PDT)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id y132sm5902382qka.19.2020.03.25.07.56.27
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 07:56:27 -0700 (PDT)
Received: by mail-yb1-f169.google.com with SMTP id g6so1282370ybh.12
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 07:56:27 -0700 (PDT)
X-Received: by 2002:a5b:904:: with SMTP id a4mr6215880ybq.492.1585148186482;
 Wed, 25 Mar 2020 07:56:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200325022321.21944-1-edumazet@google.com> <ace8e72488fbf2473efaed9fc0680886897939ab.camel@redhat.com>
In-Reply-To: <ace8e72488fbf2473efaed9fc0680886897939ab.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 25 Mar 2020 10:55:50 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdO_WBhrRj5PNdXppywDNkMKJ4hLry+3oSvy8mavnxw0g@mail.gmail.com>
Message-ID: <CA+FuTSdO_WBhrRj5PNdXppywDNkMKJ4hLry+3oSvy8mavnxw0g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: use indirect call wrappers for skb_copy_datagram_iter()
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 7:52 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2020-03-24 at 19:23 -0700, Eric Dumazet wrote:
> > TCP recvmsg() calls skb_copy_datagram_iter(), which
> > calls an indirect function (cb pointing to simple_copy_to_iter())
> > for every MSS (fragment) present in the skb.
> >
> > CONFIG_RETPOLINE=y forces a very expensive operation
> > that we can avoid thanks to indirect call wrappers.
> >
> > This patch gives a 13% increase of performance on
> > a single flow, if the bottleneck is the thread reading
> > the TCP socket.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Willem de Bruijn <willemb@google.com>

> > @@ -438,8 +445,9 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
> >
> >                       if (copy > len)
> >                               copy = len;
> > -                     n = cb(vaddr + skb_frag_off(frag) + offset - start,
> > -                            copy, data, to);
> > +                     n = INDIRECT_CALL_1(cb, simple_copy_to_iter,
> > +                                     vaddr + skb_frag_off(frag) + offset - start,
> > +                                     copy, data, to);
> >                       kunmap(page);
> >                       offset += n;
> >                       if (n != copy)
>
> I wondered if we could add a second argument for
> 'csum_and_copy_to_iter', but I guess that is a slower path anyway and
> more datapoint would be needed. The patch LGTM, thanks!
>
> Acked-by: Paolo Abeni <pabeni@redhat.com>

On the UDP front this reminded me of another indirect function call
without indirect call wrapper: getfrag in __ip_append_data.

That is called for each datagram once per linear + once per page. That
said, the noise in my quick RR test was too great to measure any
benefit from the following. Paolo, did you happen to also look at that
when introducing the indirect callers? Seems like it won't hurt to
add.

 static int
 ip_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
@@ -1128,7 +1129,8 @@ static int __ip_append_data(struct sock *sk,
                        }

                        copy = datalen - transhdrlen - fraggap - pagedlen;
-                       if (copy > 0 && getfrag(from, data +
transhdrlen, offset, copy, fraggap, skb) < 0) {
+                       if (copy > 0 &&
+                           INDIRECT_CALL_1(getfrag,
ip_generic_getfrag, from, data + transhdrlen, offset, copy, fraggap,
skb) < 0) {
                                err = -EFAULT;
                                kfree_skb(skb);
                                goto error;
@@ -1170,7 +1172,7 @@ static int __ip_append_data(struct sock *sk,
                        unsigned int off;

                        off = skb->len;
-                       if (getfrag(from, skb_put(skb, copy),
+                       if (INDIRECT_CALL_1(getfrag,
ip_generic_getfrag, from, skb_put(skb, copy),
                                        offset, copy, off, skb) < 0) {
                                __skb_trim(skb, off);
                                err = -EFAULT;
@@ -1195,7 +1197,7 @@ static int __ip_append_data(struct sock *sk,
                                get_page(pfrag->page);
                        }
                        copy = min_t(int, copy, pfrag->size - pfrag->offset);
-                       if (getfrag(from,
+                       if (INDIRECT_CALL_1(getfrag, ip_generic_getfrag, from,
