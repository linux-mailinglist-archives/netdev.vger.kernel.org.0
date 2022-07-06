Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23BA8569461
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 23:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbiGFVae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 17:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbiGFVac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 17:30:32 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1D42716C
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 14:30:30 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-10bf634bc50so13916517fac.3
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 14:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XK7acylxZTat65klL96SuyTzYmV29szNnDHSQPRWmdU=;
        b=Ws9P1JOZMvMB9HOwze7uMtDJ3nnonuNX9oU1olYezO8mlFUxwJTt1+OAxr+iCwDEjU
         /mbqdA8hnt+ugEfRO5ZAzTePApJtkNVNmuQblSAm73NKmC4uGm68AzILlqVZXiOLXcDL
         nrXl/j6Ym166CbSWH8Dl/1IPmF8P8xr1MlV7x9vol31hs42Q5ZAtj3xzlJgksR8RgANJ
         1moCPqxZCl1fWIPgklNt2UB0epwBDTlNKApiGzQ1sZrKWdoa0eJlN+4sviWcd/+W8+Qh
         7gq5Fgmc5ZRO4N/5WLg8HeMKwBMS4LMrqwS+4u76wzHElHMS8NYr99Pvr6kpdPubAlys
         dH4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XK7acylxZTat65klL96SuyTzYmV29szNnDHSQPRWmdU=;
        b=N6Sp6d2kYof8ROOwRpn8l8IBQO/p/743H28ugcvXhGbvzzNdx3uqXrPMCIc9E+pqsv
         GpOa9N/KqcEDzobuXczCsJyV6SIQSaCOTKY3jTlcCwP8yjf/N6rZeqGDqUeuEZsRtwar
         Z4FeD7ce2HjLwSBcTSi+nRJJUpH2eQzo+EwXHJ0udIKlF8llEY25y40s9hHAagnZrCOv
         jX1dzLU7rW93E5yeXJtBtXHkdBT+WcxSH5JhYgjRzXo6RyYjsTKFXKa+Bcf4iUXxrsLG
         dEkHTAAqzSqVIgKCcuLaga1ouMQNqHio90TZzLqcdVTgKzYP4Dg+/QfH6Wb1bhod6+3c
         XbKw==
X-Gm-Message-State: AJIora9bSA8L5gjPFEvgZBzmLbz+hm4s36HAMgEBJuP8gHKuIT69P0Vn
        li2Ti1N5dtmh+DmMBOrk5JT+s8j+E1t33uPVxoE=
X-Google-Smtp-Source: AGRyM1vHAkkOO9pBatyR6skMeDBWNtCYvE6Rq14b78xnAxGc+PLrbAjKCst9Wtr4mtayW5xsTJfdVGXP8YYR/7sb9bI=
X-Received: by 2002:a05:6870:2403:b0:10b:f512:a5b4 with SMTP id
 n3-20020a056870240300b0010bf512a5b4mr470109oap.164.1657143030322; Wed, 06 Jul
 2022 14:30:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220621202240.4182683-1-ssewook@gmail.com> <20220706063243.2782818-1-ssewook@gmail.com>
 <CANn89iJiod_=AGbKM=-5cGvDQjUzxLm88Zg6UU2T8Mvj6nAcOQ@mail.gmail.com> <00116bab-22c5-0bce-d82b-a10eb95e7daa@kernel.org>
In-Reply-To: <00116bab-22c5-0bce-d82b-a10eb95e7daa@kernel.org>
From:   =?UTF-8?B?7ISc7IS47Jqx?= <ssewook@gmail.com>
Date:   Wed, 6 Jul 2022 21:30:19 +0000
Message-ID: <CAM2q-nxv826UThgoLgdR2UnyvKOMAej7xHgkKCB96PvbyWkRKg@mail.gmail.com>
Subject: Re: [PATCH v3 net-next] net: Find dst with sk's xfrm policy not ctl_sk
To:     Eric Dumazet <edumazet@google.com>
Cc:     Sewook Seo <sewookseo@google.com>,
        David Ahern <dsahern@kernel.org>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
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

Hi, Eric.

Wow great, all suggestions to remove #ifdef are possible & look much better=
.
I'll amend it.

Thank you.


2022=EB=85=84 7=EC=9B=94 6=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 3:00, Da=
vid Ahern <dsahern@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On 7/6/22 1:19 AM, Eric Dumazet wrote:
> > On Wed, Jul 6, 2022 at 8:34 AM Sewook Seo <ssewook@gmail.com> wrote:
> >>
> >> From: sewookseo <sewookseo@google.com>
> >>
> >> If we set XFRM security policy by calling setsockopt with option
> >> IPV6_XFRM_POLICY, the policy will be stored in 'sock_policy' in 'sock'
> >> struct. However tcp_v6_send_response doesn't look up dst_entry with th=
e
> >> actual socket but looks up with tcp control socket. This may cause a
> >> problem that a RST packet is sent without ESP encryption & peer's TCP
> >> socket can't receive it.
> >> This patch will make the function look up dest_entry with actual socke=
t,
> >> if the socket has XFRM policy(sock_policy), so that the TCP response
> >> packet via this function can be encrypted, & aligned on the encrypted
> >> TCP socket.
> >>
> >> Tested: We encountered this problem when a TCP socket which is encrypt=
ed
> >> in ESP transport mode encryption, receives challenge ACK at SYN_SENT
> >> state. After receiving challenge ACK, TCP needs to send RST to
> >> establish the socket at next SYN try. But the RST was not encrypted &
> >> peer TCP socket still remains on ESTABLISHED state.
> >> So we verified this with test step as below.
> >> [Test step]
> >> 1. Making a TCP state mismatch between client(IDLE) & server(ESTABLISH=
ED).
> >> 2. Client tries a new connection on the same TCP ports(src & dst).
> >> 3. Server will return challenge ACK instead of SYN,ACK.
> >> 4. Client will send RST to server to clear the SOCKET.
> >> 5. Client will retransmit SYN to server on the same TCP ports.
> >> [Expected result]
> >> The TCP connection should be established.
> >>
> >> Effort: net
> >
> > Please remove this Effort: tag, this is not appropriate for upstream pa=
tches.
> >
> >> Cc: Maciej =C5=BBenczykowski <maze@google.com>
> >> Cc: Eric Dumazet <edumazet@google.com>
> >> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> >> Cc: Sehee Lee <seheele@google.com>
> >> Signed-off-by: Sewook Seo <sewookseo@google.com>
> >> ---
> >>  net/ipv4/ip_output.c | 7 ++++++-
> >>  net/ipv4/tcp_ipv4.c  | 5 +++++
> >>  net/ipv6/tcp_ipv6.c  | 7 ++++++-
> >>  3 files changed, 17 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> >> index 00b4bf26fd93..1da430c8fee2 100644
> >> --- a/net/ipv4/ip_output.c
> >> +++ b/net/ipv4/ip_output.c
> >> @@ -1704,7 +1704,12 @@ void ip_send_unicast_reply(struct sock *sk, str=
uct sk_buff *skb,
> >>                            tcp_hdr(skb)->source, tcp_hdr(skb)->dest,
> >>                            arg->uid);
> >>         security_skb_classify_flow(skb, flowi4_to_flowi_common(&fl4));
> >> -       rt =3D ip_route_output_key(net, &fl4);
> >> +#ifdef CONFIG_XFRM
> >> +       if (sk->sk_policy[XFRM_POLICY_OUT])
> >> +               rt =3D ip_route_output_flow(net, &fl4, sk);
> >> +       else
> >> +#endif
> >> +               rt =3D ip_route_output_key(net, &fl4);
> >
> > I really do not like adding more #ifdef
> >
> > What happens if we simply use :
> >
> >       rt =3D ip_route_output_flow(net, &fl4, sk);
> >
>
> That should be fine - and simpler solution.
>
>
> >> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> >> index c72448ba6dc9..8b8819c3d2c2 100644
> >> --- a/net/ipv6/tcp_ipv6.c
> >> +++ b/net/ipv6/tcp_ipv6.c
> >> @@ -952,7 +952,12 @@ static void tcp_v6_send_response(const struct soc=
k *sk, struct sk_buff *skb, u32
> >>          * Underlying function will use this to retrieve the network
> >>          * namespace
> >>          */
> >> -       dst =3D ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NU=
LL);
> >> +#ifdef CONFIG_XFRM
> >> +       if (sk && sk->sk_policy[XFRM_POLICY_OUT] && sk_fullsock(sk))
> >> +               dst =3D ip6_dst_lookup_flow(net, sk, &fl6, NULL);  /* =
Get dst with sk's XFRM policy */
> >> +       else
> >> +#endif
> >> +               dst =3D ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, =
&fl6, NULL);
> >
> > and then:
> >
> >      dst =3D ip6_dst_lookup_flow(net, sk, &fl6, NULL);
>
> same here.
