Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9224E345
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 15:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbfD2NHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 09:07:24 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:36540 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfD2NHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 09:07:23 -0400
Received: by mail-ed1-f68.google.com with SMTP id a8so7000061edx.3
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 06:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l28/1bM9PyrHGjO3UdrXKR0CAiKvukXSI46KTBL+2gc=;
        b=k1wtgufltLeFfha30aDn81H3dTDSzdzUbOQb9u1Oa2q8am9UvbrbfBbQT8CqP7ICED
         tLOO/WvHBYEvYWjqruRBI/4EN238AqlBXUqaHiKLKJZtH2rKOZ8kzIyeiTHI87UNuXD3
         rg60JFJTKHHQrNjntvnHIE2YVb2OZ4wDluh8gMKVSi7TonzxvsnXwR+Jgk8Arx/Wwgq2
         BNcdqc6bOdfu8bDoK8aQeO9ByANTI4ViFlB43Y0Rzki0cEyIYWcdCaHVuMSPHioAqLKJ
         tgu86bvZDDsSKlMEKOp0bSsK3+uKoagjrXu8eYv9yW36bx18gC3K1fKVcq3Bo3DGSAU2
         BfBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l28/1bM9PyrHGjO3UdrXKR0CAiKvukXSI46KTBL+2gc=;
        b=IG990EkCVWoXhQ6IQUuIZIvg5lumos5/FL9fv6K70Vl7NNiuP/4QyLJVKs0Nu0fr81
         198hE+EJoUG7TGVCBAF1TRnjE8hU8Xc5EzH624BQ9IjGNleCQPu8H14Kfob7eoJ1olAk
         5TrbEdVY/u0QpA6AmvcdN8LZYI9wqJ/IE1mG6NsJxlgNDqeq2Vg58ITMTvd8ni8Xj7iM
         Y6aQrtFCw78uipXIneSYBOZiv4e5dipan4WE7RW1wPSOj+0vFi/iKEam7hRPN6OLt45+
         DFYst2a09oXtxQ9aqG7JzWvexQ2cO9uYJLSH/T8hJkciJSvjtkZidq7lF3rEyumYRNq1
         Ur9A==
X-Gm-Message-State: APjAAAWvVm5s1I3wK3wMEFVVmzZhvAO2aBvm1Dvl1DqQ98jSRZ44V3Ug
        OcLkg/2YVaG8rbbRNO9mJadT0yYDP7tcNxYVjhc=
X-Google-Smtp-Source: APXvYqwp6EwoJ+5oiAo1Ikk4cBOfNeMs6EnURncdnnMDQOoZJahZKLWsnbmpG8yg757ssd/Euzxqmj4z3bPhQJkaBeM=
X-Received: by 2002:a17:906:f29a:: with SMTP id gu26mr8620676ejb.148.1556543241860;
 Mon, 29 Apr 2019 06:07:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190426192954.146301-1-willemdebruijn.kernel@gmail.com> <d57c87e402354163a7ed311d6d27aa4f@AcuMS.aculab.com>
In-Reply-To: <d57c87e402354163a7ed311d6d27aa4f@AcuMS.aculab.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 29 Apr 2019 09:06:45 -0400
Message-ID: <CAF=yD-+omQXQO7ue=BkwjVahAFP6YuU5AMTKbC9fBG6qPu6rSw@mail.gmail.com>
Subject: Re: [PATCH net] packet: in recvmsg msg_name return at least sockaddr_ll
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 5:03 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Willem de Bruijn [mailto:willemdebruijn.kernel@gmail.com]
> > Sent: 26 April 2019 20:30
> > Packet send checks that msg_name is at least sizeof sockaddr_ll.
> > Packet recv must return at least this length, so that its output
> > can be passed unmodified to packet send.
> >
> > This ceased to be true since adding support for lladdr longer than
> > sll_addr. Since, the return value uses true address length.
> >
> > Always return at least sizeof sockaddr_ll, even if address length
> > is shorter. Zero the padding bytes.
> >
> > Fixes: 0fb375fb9b93 ("[AF_PACKET]: Allow for > 8 byte hardware addresses.")
> > Suggested-by: David Laight <David.Laight@aculab.com>
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > ---
> >  net/packet/af_packet.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> > index 13301e36b4a28..ca38e75c702e7 100644
> > --- a/net/packet/af_packet.c
> > +++ b/net/packet/af_packet.c
> > @@ -3358,9 +3358,14 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> >                       msg->msg_namelen = sizeof(struct sockaddr_pkt);
> >               } else {
> >                       struct sockaddr_ll *sll = &PACKET_SKB_CB(skb)->sa.ll;
> > -
> >                       msg->msg_namelen = sll->sll_halen +
> >                               offsetof(struct sockaddr_ll, sll_addr);
> > +                     if (msg->msg_namelen < sizeof(struct sockaddr_ll)) {
> > +                             memset(msg->msg_name +
> > +                                    offsetof(struct sockaddr_ll, sll_addr),
> > +                                    0, sizeof(sll->sll_addr));
> > +                             msg->msg_namelen = sizeof(struct sockaddr_ll);
> > +                     }
> >               }
> >               memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa,
> >                      msg->msg_namelen);
>
> That memcpy() carefully overwrites the zeroed bytes.
> You need a separate 'copy_len' that isn't updated (from 18 to 20).

Argh. Thanks!

       if (msg->msg_name) {
+               int copy_len;
+
                /* If the address length field is there to be filled
                 * in, we fill it in now.
                 */
                if (sock->type == SOCK_PACKET) {
                        __sockaddr_check_size(sizeof(struct sockaddr_pkt));
                        msg->msg_namelen = sizeof(struct sockaddr_pkt);
+                       copy_len = msg->msg_namelen;
                } else {
                        struct sockaddr_ll *sll = &PACKET_SKB_CB(skb)->sa.ll;

                        msg->msg_namelen = sll->sll_halen +
                                offsetof(struct sockaddr_ll, sll_addr);
+                       copy_len = msg->msg_namelen;
+                       if (msg->msg_namelen < sizeof(struct sockaddr_ll)) {
+                               memset(msg->msg_name +
+                                      offsetof(struct sockaddr_ll, sll_addr),
+                                      0, sizeof(sll->sll_addr));
+                               msg->msg_namelen = sizeof(struct sockaddr_ll);
+                       }
                }
-               memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa,
-                      msg->msg_namelen);
+               memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa, copy_len);
        }

Can then also change memset to zero only two bytes in the Ethernet case.

+                       if (msg->msg_namelen < sizeof(struct sockaddr_ll)) {
+                               msg->msg_namelen = sizeof(struct sockaddr_ll);
+                               memset(msg->msg_name + copy_len, 0,
+                                      msg->namelen - copy_len);
+                       }
