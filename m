Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A2D2D89E2
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 21:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406755AbgLLUEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 15:04:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbgLLUEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 15:04:12 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738FFC0613CF;
        Sat, 12 Dec 2020 12:03:32 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id t8so13041981iov.8;
        Sat, 12 Dec 2020 12:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l1e51TBql86/tWlgFsD87ATQCAIhMQKzMSGnsK3zS6U=;
        b=pgmXqmJ3DJh0O3lCt6GhQqyzvw9vOlYkRjCiYsbw6rgrbNHPrs4xFOzboDAv/xTYEj
         EDM6TZ9Okwp9XMxLxSqyy1fHPXXFxuLdNvpO10gWpSohrmZyltrD1YmGXGCabqGL+xOl
         a9qSLmQBfMaekIXvkYwoVUUHysfSLsK1uWPuNI+w5qbBuNL9Vh0/N27sSJ0ohszRXN0z
         bFuinSOsF25QAUL1xsUTtqd74bt2biK4bbwlQGKbr8Koe0EBt7WAj+Wu5mx0iieJlhOd
         ZIk9rmQ7sxK1owu1EIxtjgRpUdp78XzIKgs61wfRMVYy2b5P97r4wGKYYxnTORtfAOXZ
         BVNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l1e51TBql86/tWlgFsD87ATQCAIhMQKzMSGnsK3zS6U=;
        b=Ld0SArtZwdvDVpCqoAFMOWT/wu7ji6zeVnuW7+KytCVVPImLEKNfiCC8Od0af38L0c
         guV+RwPM+s9432lgm0EQVD6+E1h80Gl8SDPS+f9xHPzrV4DMGNejBjKoq0LNEzG4IAH3
         joZW4lHvg7jjvGKADZtIq4sgenuJSrBrwaNNm8rFe2r9Sd+B9q47FuHpDHBmBceoTf1t
         axlxqNf/VjG4tAS0D0326WA0IVu0EQBgdMvy0Lgnj6lYo6J7tbW/HlHLATVBdI/9ybxZ
         93DPf0OD8m1UCBuzVtP5Yyeqx/qGiojNozjD90eclY59KkSYLAADObEJlSxvqNvtkRPa
         l/vw==
X-Gm-Message-State: AOAM530pkFa2szMz88RIzrwVrZpypBp5O2CuhfpPWuVC+DMAb/Nfv272
        4eRW8BSL02KRIwEUIt3M8/jHWuR/3CQyXpmekCc=
X-Google-Smtp-Source: ABdhPJwEntPezSfEwDNqsm+/AfWrG+huGtYjfh6d72pqVMy0jLhUWD0E0Xc8hD9w8WipL9WSfFqLY9GyeYPEOxMSeTQ=
X-Received: by 2002:a5d:9a82:: with SMTP id c2mr8212898iom.38.1607803411052;
 Sat, 12 Dec 2020 12:03:31 -0800 (PST)
MIME-Version: 1.0
References: <160773649920.2387.14668844101686155199.stgit@localhost.localdomain>
 <CAK6E8=c4LpxcaF3Mr1T9BtkD5SPK1eoK_hGOMNa6C9a4fpFQNg@mail.gmail.com>
 <CAKgT0UcS2s+gnYz0nvfpia5R+H7hSSVS4GGKOkkfyuz60zJpQQ@mail.gmail.com> <CAK6E8=c3c8uK8zGA9QS3cTLh59N6n=e_71a0BbQK7UfaPJqkSA@mail.gmail.com>
In-Reply-To: <CAK6E8=c3c8uK8zGA9QS3cTLh59N6n=e_71a0BbQK7UfaPJqkSA@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sat, 12 Dec 2020 12:03:20 -0800
Message-ID: <CAKgT0UdgS+_iaX19-+M2h_y4EQXgHyjoe9H2r0iuVApgsW8UGw@mail.gmail.com>
Subject: Re: [net-next PATCH] tcp: Add logic to check for SYN w/ data in tcp_simple_retransmit
To:     Yuchung Cheng <ycheng@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Martin Lau <kafai@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 12, 2020 at 11:07 AM Yuchung Cheng <ycheng@google.com> wrote:
>
> On Sat, Dec 12, 2020 at 11:01 AM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Sat, Dec 12, 2020 at 10:34 AM Yuchung Cheng <ycheng@google.com> wrote:
> > >
> > > On Fri, Dec 11, 2020 at 5:28 PM Alexander Duyck
> > > <alexander.duyck@gmail.com> wrote:
> > > >
> > > > From: Alexander Duyck <alexanderduyck@fb.com>
> > > >
> > > > There are cases where a fastopen SYN may trigger either a ICMP_TOOBIG
> > > > message in the case of IPv6 or a fragmentation request in the case of
> > > > IPv4. This results in the socket stalling for a second or more as it does
> > > > not respond to the message by retransmitting the SYN frame.
> > > >
> > > > Normally a SYN frame should not be able to trigger a ICMP_TOOBIG or
> > > > ICMP_FRAG_NEEDED however in the case of fastopen we can have a frame that
> > > > makes use of the entire MSS. In the case of fastopen it does, and an
> > > > additional complication is that the retransmit queue doesn't contain the
> > > > original frames. As a result when tcp_simple_retransmit is called and
> > > > walks the list of frames in the queue it may not mark the frames as lost
> > > > because both the SYN and the data packet each individually are smaller than
> > > > the MSS size after the adjustment. This results in the socket being stalled
> > > > until the retransmit timer kicks in and forces the SYN frame out again
> > > > without the data attached.
> > > >
> > > > In order to resolve this we can generate our best estimate for the original
> > > > packet size by detecting the fastopen SYN frame and then adding the
> > > > overhead for MAX_TCP_OPTION_SPACE and verifying if the SYN w/ data would
> > > > have exceeded the MSS. If so we can mark the frame as lost and retransmit
> > > > it.
> > > >
> > > > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> > > > ---
> > > >  net/ipv4/tcp_input.c |   30 +++++++++++++++++++++++++++---
> > > >  1 file changed, 27 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > > > index 9e8a6c1aa019..79375b58de84 100644
> > > > --- a/net/ipv4/tcp_input.c
> > > > +++ b/net/ipv4/tcp_input.c
> > > > @@ -2686,11 +2686,35 @@ static void tcp_mtup_probe_success(struct sock *sk)
> > > >  void tcp_simple_retransmit(struct sock *sk)
> > > >  {
> > > >         const struct inet_connection_sock *icsk = inet_csk(sk);
> > > > +       struct sk_buff *skb = tcp_rtx_queue_head(sk);
> > > >         struct tcp_sock *tp = tcp_sk(sk);
> > > > -       struct sk_buff *skb;
> > > > -       unsigned int mss = tcp_current_mss(sk);
> > > > +       unsigned int mss;
> > > > +
> > > > +       /* A fastopen SYN request is stored as two separate packets within
> > > > +        * the retransmit queue, this is done by tcp_send_syn_data().
> > > > +        * As a result simply checking the MSS of the frames in the queue
> > > > +        * will not work for the SYN packet. So instead we must make a best
> > > > +        * effort attempt by validating the data frame with the mss size
> > > > +        * that would be computed now by tcp_send_syn_data and comparing
> > > > +        * that against the data frame that would have been included with
> > > > +        * the SYN.
> > > > +        */
> > > > +       if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_SYN && tp->syn_data) {
> > > > +               struct sk_buff *syn_data = skb_rb_next(skb);
> > > > +
> > > > +               mss = tcp_mtu_to_mss(sk, icsk->icsk_pmtu_cookie) +
> > > > +                     tp->tcp_header_len - sizeof(struct tcphdr) -
> > > > +                     MAX_TCP_OPTION_SPACE;
> > > nice comment! The original syn_data mss needs to be inferred which is
> > > a hassle to get right. my sense is path-mtu issue is enough to warrant
> > > they are lost.
> > > I suggest simply mark syn & its data lost if tcp_simple_retransmit is
> > > called during TFO handshake, i.e.
> > >
> > > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > > index 62f7aabc7920..7f0c4f2947eb 100644
> > > --- a/net/ipv4/tcp_input.c
> > > +++ b/net/ipv4/tcp_input.c
> > > @@ -2864,7 +2864,8 @@ void tcp_simple_retransmit(struct sock *sk)
> > >         unsigned int mss = tcp_current_mss(sk);
> > >
> > >         skb_rbtree_walk(skb, &sk->tcp_rtx_queue) {
> > > -               if (tcp_skb_seglen(skb) > mss)
> > > +               if (tcp_skb_seglen(skb) > mss ||
> > > +                   (tp->syn_data && sk->sk_state == TCP_SYN_SENT))
> > >                         tcp_mark_skb_lost(sk, skb);
> > >         }
> > >
> > > We have a TFO packetdrill test that verifies my suggested fix should
> > > trigger an immediate retransmit vs 1s wait.
> >
> > Okay, I will go that route, although I will still probably make one
> > minor cleanup. Instead of testing for syn_data and state per packet I
> > will probably keep the bit where I overwrite mss since it is only used
> > in the loop. What I can do is switch it from unsigned int to int since
> > technically tcp_current_mss and tcp_skb_seglen are both a signed int
> > anyway. Then I can just set mss to -1 in the syn_data && TCP_SYN_SENT
> > case. That way all of the frames in the ring should fail the check
> > while only having to add one initial check outside the loop.
> sounds good. I thought about that too but decided it's normally just
> two skbs and not worth the hassle.
>
> btw I thought about negatively caching this event to disable TFO
> completely afterward, but I assume it's not needed as the ICMP error
> should correct the route mtu hence future TFO should be fine. If
> that's not the case we might want to consider disable TFO to avoid
> this future "TFO->ICMP->SYN-retry" repetition.

At least in my testing there are no further occurrences after the
first. Basically the first one hits and then all the follow-on
requests use the correct MSS based on the cached path MTU. As such
there isn't any penalty to leaving the feature enabled as over the
course of several transactions it still provides more benefit than
harm.
