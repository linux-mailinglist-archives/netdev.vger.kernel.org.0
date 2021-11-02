Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D7D44366F
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 20:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhKBTYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 15:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbhKBTYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 15:24:25 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EBBC06120A
        for <netdev@vger.kernel.org>; Tue,  2 Nov 2021 12:21:49 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id p4so179300qkk.0
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 12:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WBuZwnr+5bcLsCP355FoQ/4BAq59hOrIy0vTMjfrBb8=;
        b=ALlpwX4Ukti+ianWKoWCIEQelRKQDPprVmMyF7bY3MLoaTiwrVTK5iB5Dj/dZaHq3W
         KZV8OTzfuS/or+8PvImBgX4G6dn8bORZKLQieLhsR0VakaYdhiVDHPhqE0DAc6DgI3YP
         qOUG2tDX/JOnvl9Fs5gLfeQrOTTSOwWxomvDyz5A1EYf5j/a4RtkxXLXKZ7lUnzZknTT
         5KOSyYc907dONlMc0xlMGtReevrX7GYR1ReSD+XzKCg7O/fxvgDH2qzJ+0nVPEV/GhfQ
         soNobREkXIq9xmUImY+ilfq91wSTK1/k0Vy+HjHldzm/1iR0gqxelWZNN2L5Z0Kc/FGn
         z0VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WBuZwnr+5bcLsCP355FoQ/4BAq59hOrIy0vTMjfrBb8=;
        b=YfNw5L997RwPJsJwUJxdAfbIdgLeSpAaSLe0otMMmLzZIJvWuIOK75S/agNitalBXM
         uRVM/3DzJkOv8APBiqreHkKRC1hg/m2LfUcDj8GXeR+qZJWUbNeVj9UEEq91sSzzk9xW
         0WkryHYYkXSVS0LHpsU0xDcAHEqtDajb3tlMCI2NjWm+IkXkjYiUniScpH3jH4mDeSY4
         Mb7s4wAE2gWYVC+/aIkp/5RTKnobGY3rfNq6lFuVFXjK+ih4A7HxRMLYA6TM969kdB4E
         3Olj7Dg7xBJflXNkXx4TWy5YCp0S6e3GKREmudXq7PX5bA2BKT/auK4oH8oj+nk7j6lY
         ACmA==
X-Gm-Message-State: AOAM533xCa+G4jivWrYwj2yjpWnWt2e7T/iwbM1orY1DYxlgC46USGqA
        FVGEoCju/9Fk/Iu3W77z0MF7g/C0KgKllB1MfXfEDA==
X-Google-Smtp-Source: ABdhPJyx7G/CA9C9oGEYGtlGn8S6R1B/EfiFUabVqEtFBOelrmJNlKgnzA8B8ZHYEjdpYUSsc60JjgULOPpcaJ5ICwM=
X-Received: by 2002:ae9:edc6:: with SMTP id c189mr30616528qkg.183.1635880908773;
 Tue, 02 Nov 2021 12:21:48 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1635784253.git.cdleonard@gmail.com> <6097ec24d87efc55962a1bfac9441132f0fc4206.1635784253.git.cdleonard@gmail.com>
 <CA+HUmGgMAU235hMtTgucVb1GX_Ru83bngHg8-Jvy2g6BA7djsg@mail.gmail.com> <876f0df1-894a-49bb-07dc-1b1137479f3f@gmail.com>
In-Reply-To: <876f0df1-894a-49bb-07dc-1b1137479f3f@gmail.com>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Tue, 2 Nov 2021 12:21:38 -0700
Message-ID: <CA+HUmGguspEHZpH-WB4Qi9+xVpz3x3z3KqQVoQmhEJsn-w2q1w@mail.gmail.com>
Subject: Re: [PATCH v2 11/25] tcp: authopt: Implement Sequence Number Extension
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 2, 2021 at 3:03 AM Leonard Crestez <cdleonard@gmail.com> wrote:
>
> On 11/1/21 9:22 PM, Francesco Ruggeri wrote:
> >> +/* Compute SNE for a specific packet (by seq). */
> >> +static int compute_packet_sne(struct sock *sk, struct tcp_authopt_info *info,
> >> +                             u32 seq, bool input, __be32 *sne)
> >> +{
> >> +       u32 rcv_nxt, snd_nxt;
> >> +
> >> +       // We can't use normal SNE computation before reaching TCP_ESTABLISHED
> >> +       // For TCP_SYN_SENT the dst_isn field is initialized only after we
> >> +       // validate the remote SYN/ACK
> >> +       // For TCP_NEW_SYN_RECV there is no tcp_authopt_info at all
> >> +       if (sk->sk_state == TCP_SYN_SENT ||
> >> +           sk->sk_state == TCP_NEW_SYN_RECV ||
> >> +           sk->sk_state == TCP_LISTEN)
> >> +               return 0;
> >> +
> >
> > In case of TCP_NEW_SYN_RECV, if our SYNACK had sequence number
> > 0xffffffff, we will receive an ACK sequence number of 0, which
> > should have sne = 1.
> >
> > In a somewhat similar corner case, when we receive a SYNACK to
> > our SYN in tcp_rcv_synsent_state_process, if the SYNACK has
> > sequence number 0xffffffff, we set tp->rcv_nxt to 0, and we
> > should set sne to 1.
> >
> > There may be more similar corner cases related to a wraparound
> > during the handshake.
> >
> > Since as you pointed out all we need is "recent" valid <sne, seq>
> > pairs as reference, rather than relying on rcv_sne being paired
> > with tp->rcv_nxt (and similarly for snd_sne and tp->snd_nxt),
> > would it be easier to maintain reference <sne, seq> pairs for send
> > and receive in tcp_authopt_info, appropriately handle the different
> > handshake cases and initialize the pairs, and only then track them
> > in tcp_rcv_nxt_update and tcp_rcv_snd_update?
>
> For TCP_NEW_SYN_RECV there is no struct tcp_authopt_info, only a request
> minisock. I think those are deliberately kept small save resources on
> SYN floods so I'd rather not increase their size.
>
> For all the handshake cases we can just rely on SNE=0 for ISN and we
> already need to keep track of ISNs because they're part of the signature.
>

Exactly. But the current code, when setting rcv_sne and snd_sne,
always compares the sequence number with the <info->rcv_sne, tp->rcv_nxt>
(or <info->snd_sne, tp->snd_nxt>) pair, where info->rcv_sne and
info->snd_sne are initialized to 0 at the time of info creation.
In other words, the code assumes that rcv_sne always corresponds to
tp->rcv_nxt, and snd_sne to tp->snd_nxt. But that may not be true
when info is created, on account of rollovers during a handshake.
So it is not just a matter of what to use for SNE before info is
created and used, but also how SNEs are initialized in info.
That is why I was suggesting of saving valid <sne, seq> pairs
(initialized with <0, ISN>) in tcp_authopt_info rather than just SNEs,
and then always compare seq to those pairs if info is available.
The pairs could then be updated in tcp_rcv_nxt_update and
tcp_snd_una_update.

Regards,
Francesco
