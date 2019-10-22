Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B530DFA1D
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 03:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729606AbfJVB2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 21:28:44 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:33985 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727953AbfJVB2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 21:28:44 -0400
Received: by mail-ot1-f66.google.com with SMTP id m19so12792375otp.1
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 18:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NiHjoEj9AcEtTJiyxb5MA+F8jPg+9dT+VL3IQmE7r4Q=;
        b=uhVeTbtguEV3QBbTDCw025vdYR/CipMJK3HKF2/t+8qisZI9WvRDs1gEMi0aV81xe2
         tpwZ8nEJ+XRGwxOfsnk+Z4jfnTvraqyKcjAFaIUz5D+etk0u+ETc6OBiz4SNnidc03e4
         mHqB9MRg0FgJ3Fm/JRbvXa+TqW7LlyqEBAX2OIEylX/KhUNzTlOl8sBREU6Gzab1Q/O9
         iixFms05aMWq+0BdhRgnkh/CMtFgcKSdw31ru4roOKymCAnWaJbiejunLsunzt78P3Cn
         FiGPNK8y56nn/7PQN2Ubr4x7v0HJm/MoS1jiiDsEQRqPAPCsnsQr+/1Ui1FEoWANyIKX
         ZgVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NiHjoEj9AcEtTJiyxb5MA+F8jPg+9dT+VL3IQmE7r4Q=;
        b=jLDK/uSfQAoNFyMGqw3zreMp0yBCzGxFW059BkJdyazIqkMr64EhK2x4HWcG1bmf2Q
         z1wJ3ZhQMx0YPwXBNP/UaYw10NM+0Z0WBUrxnsqBOY4tkGGM7+jJ1cVzhfd60/B9dj79
         fkPnxl1aKi8g+2wJs/fVUhEUgibmYrQ8ovWjxAs4lNLtdvpoouWRUvW2beG/W/6E1Zvb
         WvDPtvOpy+3NqKrRjjOTOsItKjnArakGLyDmjS10ZrYkAgdGC3NAHSk2S09GkmR4yUKB
         bjRQ57IAcFedzQ0bL9baFZ49SLw+0tEhNhd1EuwkqBSsSJHd5+beWwdZhVyJm2J0ja0Y
         QraQ==
X-Gm-Message-State: APjAAAWHMUHHpzhHsskYU1TF9WjHcI2qPPMvcWEbCkLM4oKruBbC1veD
        29+tiTWEM/WjvcyRJ3zDJnZFKg7yzSRjqpLBv0f+UA==
X-Google-Smtp-Source: APXvYqybfn8Nwd6a8d7pTPcaoO0ru5MB2DT7hUvngh0ENPpyfnREQ13XDMI5WY5OgKfECPC38pVAn7yQihyOSYWIkjI=
X-Received: by 2002:a9d:60c9:: with SMTP id b9mr596792otk.255.1571707722777;
 Mon, 21 Oct 2019 18:28:42 -0700 (PDT)
MIME-Version: 1.0
References: <68ad6fb82c0edfb788c7ce1a3bdc851b@codeaurora.org>
 <CADVnQynFeJCpv4irANd8O63ck0ewUq66EDSHHRKdv-zieGZ+UA@mail.gmail.com>
 <f7a0507ce733dd722b1320622dfd1caa@codeaurora.org> <CADVnQy=SDgiFH57MUv5kNHSjD2Vsk+a-UD0yXQKGNGY-XLw5cw@mail.gmail.com>
 <2279a8988c3f37771dda5593b350d014@codeaurora.org> <CADVnQykjfjPNv6F1EtWWvBT0dZFgf1QPDdhNaCX3j3bFCkViwA@mail.gmail.com>
 <f9ae970c12616f61c6152ebe34019e2b@codeaurora.org>
In-Reply-To: <f9ae970c12616f61c6152ebe34019e2b@codeaurora.org>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 21 Oct 2019 21:28:25 -0400
Message-ID: <CADVnQymqKpMh3iRfrdiAYjb+2ejKswk8vaZCY6EW4-3ppDnv_w@mail.gmail.com>
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     Netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 8:04 PM Subash Abhinov Kasiviswanathan
<subashab@codeaurora.org> wrote:
>
> > Interesting! As tcp_input.c summarizes, "packets_out is
> > SND.NXT-SND.UNA counted in packets". In the normal operation of a
> > socket, tp->packets_out should not be 0 if any of those other fields
> > are non-zero.
> >
> > The tcp_write_queue_purge() function sets packets_out to 0:
> >
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/net/ipv4/tcp.c?h=v4.19#n2526
> >
> > So the execution of tcp_write_queue_purge()  before this point is one
> > way for the socket to end up in this weird state.
> >
>
> In one of the instances, the values are tp->snd_nxt = 1016118098,
> tp->snd_una = 1016047820
>
> tp->mss_cache = 1378
>
> I assume the number of outstanding segments should be
> (tp->snd_nxt - tp->snd_una)/tp->mss_cache = 51

That would be a good expectation if all the packets were full-sized.

> tp->packets_out = 0 and tp->sacked_out = 158 in this case.

OK, thanks. It could be that sacked_out is reasonable and some of the
packets were not full-sized. But, as discussed above, typically the
packets_out should not be 0 if sacked_out is non-zero (with at least
the exception of the tcp_write_queue_purge()  case).

> >> > Yes, one guess would be that somehow the skbs in the retransmit queue
> >> > have been freed, but tp->sacked_out is still non-zero and
> >> > tp->highest_sack is still a dangling pointer into one of those freed
> >> > skbs. The tcp_write_queue_purge() function is one function that fees
> >> > the skbs in the retransmit queue and leaves tp->sacked_out as non-zero
> >> > and  tp->highest_sack as a dangling pointer to a freed skb, AFAICT, so
> >> > that's why I'm wondering about that function. I can't think of a
> >> > specific sequence of events that would involve tcp_write_queue_purge()
> >> > and then a socket that's still in FIN-WAIT1. Maybe I'm not being
> >> > creative enough, or maybe that guess is on the wrong track. Would you
> >> > be able to set a new bit in the tcp_sock in tcp_write_queue_purge()
> >> > and log it in your instrumentation point, to see if
> >> > tcp_write_queue_purge()  was called for these connections that cause
> >> > this crash?
>
> I've queued up a build which logs calls to tcp_write_queue_purge and
> clears tp->highest_sack and tp->sacked_out. I will let you know how
> it fares by end of week.

OK, thanks. That should be a useful data point.

cheers,
neal
