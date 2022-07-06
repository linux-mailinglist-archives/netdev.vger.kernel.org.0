Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF85567C54
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 05:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbiGFDKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 23:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiGFDKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 23:10:39 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB4715FEC
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 20:10:38 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id s13-20020a0568301e0d00b00616ad12fee7so10987131otr.10
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 20:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=roblXUFI4rmHsNuICVZrIAGR7CM9ikQUh0nA4chr0yU=;
        b=ZTXRg1KsfmQy9fLxGuduzeuZjLKGuJ72UaztG6Aruj5nQ+a67YFLoWBqjz222hDx/I
         8J66sv63kvFwlTG2nYgIpmtYyYTVngMl+VHNBPSC1Cudmugz9tHYjs47UEa+eA3krI9G
         SXO8TkWjqckmh/nwlZI2cASFZOvDyo9xaRbBYZRTSswTo6JwfhbhSnrylesRaJZ4x/Ll
         UzDscpwfO2CDlSA0QcFu6AY4+IMILsOBZv3Oe3lY4QqK/urSidxwk1ubuQijThkZ3jhq
         syuA13LeruiXcLkA01sssbE/KsvfCn/XF7RbEE5kERY+ObdB39R02aPbUbRgbRgdCVB0
         AHPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=roblXUFI4rmHsNuICVZrIAGR7CM9ikQUh0nA4chr0yU=;
        b=dVnXUwwwKhE3QurMBwbbAyNGPkYHUAH3ZhSJrRp7IrPjMpXNu3KfjCXF5l8I/oEqCd
         QDKg8Sn0WO0nqGQ0jwzIUgqhGQbcR01aTFEDtCsgJAQOlgdTJPSh1yr6eEQfq+UxZOkX
         oyDeKtxv/b+bwmjQu+tazopEPIzLynNLbOOt44xCTPx1Q3za89/nZrQwShUQrM7/MaAP
         FwLyAPJG4Mffu8sgvaxjtEuW2Zo2ihfdgQHoUb9YesXqQ/pefzBR5v3liLA7SQCTJJmE
         /68mqQZBxAKVoAjIEd3hKlWw8Ng8NHFjlU1hhpJEw5UOWZJw92HNauaxsJqqeO5N50Va
         toog==
X-Gm-Message-State: AJIora9uUxffCiG9FDFdKlW6cvAGPyRw7lCwxoJ+qRl6UgOUWnPZyUAf
        3baBdAfGWvNxd728RecGTyvKFOQTkpxH7/+X5V4=
X-Google-Smtp-Source: AGRyM1u3zmXhYITIIchaI5dBL3di0h8zlCDeYBZsVb9jLx/bgtwVOFpMSsp+rgDOf+cY4eXV4k4pNdoQgayDw8kzThg=
X-Received: by 2002:a05:6830:3149:b0:616:e81f:fe20 with SMTP id
 c9-20020a056830314900b00616e81ffe20mr16943439ots.301.1657077038054; Tue, 05
 Jul 2022 20:10:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220621202240.4182683-1-ssewook@gmail.com> <20220701154413.868096-1-ssewook@gmail.com>
 <7dc20590ff5ab471a6cd94a6cc63bb2459782706.camel@redhat.com>
In-Reply-To: <7dc20590ff5ab471a6cd94a6cc63bb2459782706.camel@redhat.com>
From:   =?UTF-8?B?7ISc7IS47Jqx?= <ssewook@gmail.com>
Date:   Wed, 6 Jul 2022 03:10:27 +0000
Message-ID: <CAM2q-ny=r-U-6n6F+02QON1B8NHJ5TZrrOa7x3CAfkrUtRWnwQ@mail.gmail.com>
Subject: Re: [PATCH v2] net-tcp: Find dst with sk's xfrm policy not ctl_sk
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Sewook Seo <sewookseo@google.com>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sehee Lee <seheele@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Paolo.

 If you are targting net, please add a suitable Fixes: tag.
 > I'm targeting net-next, and will update the subject.

It looks like the cloned policy will be overwrited by later resets and
possibly leaked? nobody calls xfrm_sk_free_policy() on the old policy.
> Is it possible that a later reset overwrites sk_ctl's sk_policy? I though=
t ctl_sk is a percpu variable and it's preempted. Maybe I might miss someth=
ing, please let me know if my understanding is wrong.

Thanks.


2022=EB=85=84 7=EC=9B=94 5=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 8:25, Pa=
olo Abeni <pabeni@redhat.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Hello,
>
> On Fri, 2022-07-01 at 15:44 +0000, Sewook Seo wrote:
> > From: sewookseo <sewookseo@google.com>
> >
> > If we set XFRM security policy by calling setsockopt with option
> > IPV6_XFRM_POLICY, the policy will be stored in 'sock_policy' in 'sock'
> > struct. However tcp_v6_send_response doesn't look up dst_entry with the
> > actual socket but looks up with tcp control socket. This may cause a
> > problem that a RST packet is sent without ESP encryption & peer's TCP
> > socket can't receive it.
> > This patch will make the function look up dest_entry with actual socket=
,
> > if the socket has XFRM policy(sock_policy), so that the TCP response
> > packet via this function can be encrypted, & aligned on the encrypted
> > TCP socket.
> >
> > Tested: We encountered this problem when a TCP socket which is encrypte=
d
> > in ESP transport mode encryption, receives challenge ACK at SYN_SENT
> > state. After receiving challenge ACK, TCP needs to send RST to
> > establish the socket at next SYN try. But the RST was not encrypted &
> > peer TCP socket still remains on ESTABLISHED state.
> > So we verified this with test step as below.
> > [Test step]
> > 1. Making a TCP state mismatch between client(IDLE) & server(ESTABLISHE=
D).
> > 2. Client tries a new connection on the same TCP ports(src & dst).
> > 3. Server will return challenge ACK instead of SYN,ACK.
> > 4. Client will send RST to server to clear the SOCKET.
> > 5. Client will retransmit SYN to server on the same TCP ports.
> > [Expected result]
> > The TCP connection should be established.
> >
> > Effort: net-tcp
>
> This looks like a stray "internal" tag?
>
> > Cc: Maciej =C5=BBenczykowski <maze@google.com>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Steffen Klassert <steffen.klassert@secunet.com>
> > Cc: Sehee Lee <seheele@google.com>
> > Signed-off-by: Sewook Seo <sewookseo@google.com>
>
> Is this targeting -net -or -net-next? IMHO this could land in either
> trees. If you are targting net, please add a suitable Fixes: tag.
>
>
> > ---
> > Changelog since v1:
> > - Remove unnecessary null check of sk at ip_output.c
> >   Narrow down patch scope: sending RST at SYN_SENT state
> >   Remove unnecessay condition to call xfrm_sk_free_policy()
> >   Verified at KASAN build
> >
> >  net/ipv4/ip_output.c | 7 ++++++-
> >  net/ipv4/tcp_ipv4.c  | 5 +++++
> >  net/ipv6/tcp_ipv6.c  | 7 ++++++-
> >  3 files changed, 17 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> > index 00b4bf26fd93..1da430c8fee2 100644
> > --- a/net/ipv4/ip_output.c
> > +++ b/net/ipv4/ip_output.c
> > @@ -1704,7 +1704,12 @@ void ip_send_unicast_reply(struct sock *sk, stru=
ct sk_buff *skb,
> >                          tcp_hdr(skb)->source, tcp_hdr(skb)->dest,
> >                          arg->uid);
> >       security_skb_classify_flow(skb, flowi4_to_flowi_common(&fl4));
> > -     rt =3D ip_route_output_key(net, &fl4);
> > +#ifdef CONFIG_XFRM
> > +     if (sk->sk_policy[XFRM_POLICY_OUT])
> > +             rt =3D ip_route_output_flow(net, &fl4, sk);
> > +     else
> > +#endif
> > +             rt =3D ip_route_output_key(net, &fl4);
> >       if (IS_ERR(rt))
> >               return;
> >
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index fda811a5251f..459669f9e13f 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -819,6 +819,10 @@ static void tcp_v4_send_reset(const struct sock *s=
k, struct sk_buff *skb)
> >               ctl_sk->sk_priority =3D (sk->sk_state =3D=3D TCP_TIME_WAI=
T) ?
> >                                  inet_twsk(sk)->tw_priority : sk->sk_pr=
iority;
> >               transmit_time =3D tcp_transmit_time(sk);
> > +#ifdef CONFIG_XFRM
> > +             if (sk->sk_policy[XFRM_POLICY_OUT] && sk->sk_state =3D=3D=
 TCP_SYN_SENT)
> > +                     xfrm_sk_clone_policy(ctl_sk, sk);
> > +#endif
>
> It looks like the cloned policy will be overwrited by later resets and
> possibly leaked? nobody calls xfrm_sk_free_policy() on the old policy.
>
> Thanks!
>
> Paolo
>
