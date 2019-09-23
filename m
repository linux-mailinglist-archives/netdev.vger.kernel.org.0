Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4AEBB488
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 14:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502109AbfIWM4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 08:56:13 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:45782 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437533AbfIWM4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 08:56:12 -0400
Received: by mail-yb1-f195.google.com with SMTP id y6so5394046ybq.12
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 05:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NaASZIylb+5/zgPtOr/LFKocg0G7VQCA2rLDNnrjAVk=;
        b=MNK0hq/PGyr+iueHdatpa8yoEPdHIMur+yz8+ibYV1eUJx5a3km1N+df7laYl/i4hC
         h6nITEUWnEkqS2mJIQcMbpHecxTaoE7nUDIsAF6guYOjGIQpDVAUDehHIDQyDNu3EnE/
         mw+b/EM/0eIh5xO8XMQ50DzlFl6rSDLdSBWzwb99r7ejHlLtH+O36Olp655jdmPiJv0A
         XWX65+yJr83PizHyZpOfumLr4pyzktky+7UJgD/C8d3Kssr29DYmC4eoGpLLIiSEQMkg
         NYl4zwe8HLxbw2cIlkw0OGRnYzkFLGDUF2F38mWLQkpME8esKRWIp7ir2HcDet/ktrWf
         ukrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NaASZIylb+5/zgPtOr/LFKocg0G7VQCA2rLDNnrjAVk=;
        b=VXsUpjpq8N6fcPMmrZiZ/IRf67ucrRdrQOCOViJjB8YH7/Rys8qj9p0lJSl8pzeQVX
         bDkUEZ5oc8ubsBs0t2orbnjRuJVupkRPeWSXRavU+frjGrpUiDdNJnwdSl3lMrMQavUT
         R+cnOQ0VCFMJJz9et50E9DbfQTdMMQGnrBjzm0QCYM3P6sBNLCfuR6bZzWBnI9CJflP5
         ch1MWNG9TDjTCyPdzaVTbLTA6icVgE+PPPkP/MSuyTI5xL7l6KBwxsjLmI+WlJSUYAds
         d4vsH29m5RCEwqpWJ3b/CS7b8t0vHlL7SDFtzmUEBOdUXSJfP2k74+HSvDXLmKe0csa8
         VR4Q==
X-Gm-Message-State: APjAAAVvme5PmjzlIBQfE3zBx18HdJSHKBxO4BmE03UavSCiZjj8X4Z9
        EIx1vTo1TMxOxyf2F1Mm87VXVpQK
X-Google-Smtp-Source: APXvYqzjvZjNzvpPvPNQZTD8C2xPdQrqUDMh7eqhwFSsVd8NzoTw4+Wmmc2E9877PrWmEkiSPbtg8g==
X-Received: by 2002:a25:2383:: with SMTP id j125mr20487794ybj.186.1569243371012;
        Mon, 23 Sep 2019 05:56:11 -0700 (PDT)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id g81sm2524432ywa.46.2019.09.23.05.56.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 05:56:10 -0700 (PDT)
Received: by mail-yb1-f169.google.com with SMTP id m143so5391871ybf.10
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 05:56:10 -0700 (PDT)
X-Received: by 2002:a25:3d44:: with SMTP id k65mr3909082yba.235.1569243369600;
 Mon, 23 Sep 2019 05:56:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190920044905.31759-1-steffen.klassert@secunet.com>
 <20190920044905.31759-2-steffen.klassert@secunet.com> <CA+FuTScee60of_g1Mg7hJnMLu=mjM7w289mj3L4TNZ6WnTkvdA@mail.gmail.com>
In-Reply-To: <CA+FuTScee60of_g1Mg7hJnMLu=mjM7w289mj3L4TNZ6WnTkvdA@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 23 Sep 2019 08:55:33 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdZTLhbpg18zVxMqBAdf2CwQ7qnujQ=UEYKhHK=BULsgA@mail.gmail.com>
Message-ID: <CA+FuTSdZTLhbpg18zVxMqBAdf2CwQ7qnujQ=UEYKhHK=BULsgA@mail.gmail.com>
Subject: Re: [PATCH RFC 1/5] UDP: enable GRO by default.
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 23, 2019 at 8:53 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Fri, Sep 20, 2019 at 12:49 AM Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> >
> > This patch enables UDP GRO regardless if a GRO capable
> > socket is present. With this GRO is done by default
> > for the local input and forwarding path.
> >
> > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> >  struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
> > diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> > index a3908e55ed89..929b12fc7bc5 100644
> > --- a/net/ipv4/udp_offload.c
> > +++ b/net/ipv4/udp_offload.c
> > @@ -401,36 +401,25 @@ static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
> >         return NULL;
> >  }
> >
> > -INDIRECT_CALLABLE_DECLARE(struct sock *udp6_lib_lookup_skb(struct sk_buff *skb,
> > -                                                  __be16 sport, __be16 dport));
> >  struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
> > -                               struct udphdr *uh, udp_lookup_t lookup)
> > +                               struct udphdr *uh, struct sock *sk)
> >  {
> >         struct sk_buff *pp = NULL;
> >         struct sk_buff *p;
> >         struct udphdr *uh2;
> >         unsigned int off = skb_gro_offset(skb);
> >         int flush = 1;
> > -       struct sock *sk;
> >
> > -       rcu_read_lock();
> > -       sk = INDIRECT_CALL_INET(lookup, udp6_lib_lookup_skb,
> > -                               udp4_lib_lookup_skb, skb, uh->source, uh->dest);
> > -       if (!sk)
> > -               goto out_unlock;
> > -
> > -       if (udp_sk(sk)->gro_enabled) {
> > +       if (!sk || !udp_sk(sk)->gro_receive) {
>
> Not critical, but the use of sk->gro_enabled and sk->gro_receive to
> signal whether sockets are willing to accept large packets or are udp
> tunnels, respectively, is subtle and possibly confusing.
>
> Wrappers udp_sock_is_tunnel and udp_sock_accepts_gso could perhaps
> help document the logic a bit.
>
> static inline bool udp_sock_is_tunnel(struct udp_sock *up)
> {
>     return up->gro_receive;
> }
>
> And perhaps only pass a non-zero sk to udp_gro_receive if it is a
> tunnel and thus skips the new default path:
>
> static inline struct sock *sk = udp4_lookup_tunnel(const struct
> sk_buff *skb, __be16 sport, __be16_dport)
> {
>     struct sock *sk;
>
>     if (!static_branch_unlikely(&udp_encap_needed_key))
>       return NULL;
>
>     rcu_read_lock();
>     sk = udp4_lib_lookup_skb(skb, source, dest);
>     rcu_read_unlock();
>
>     return udp_sock_is_tunnel(udp_sk(sk)) ? sk  : NULL;
> }
>
> >                 pp = call_gro_receive(udp_gro_receive_segment, head, skb);
> > -               rcu_read_unlock();
> >                 return pp;
> >         }
>
> Just a suggestion. It may be too verbose as given.

.. and buggy, as it does not even test for NULL sk ;)
