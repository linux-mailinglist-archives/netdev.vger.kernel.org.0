Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 106A4E0B54
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732416AbfJVSSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 14:18:18 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:35058 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730808AbfJVSSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 14:18:17 -0400
Received: by mail-vs1-f66.google.com with SMTP id k15so3004176vsp.2
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 11:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LKqxM1L9nSD6Lxn49e1wmAIIH5JlsIFviYkSwTkXtJU=;
        b=W9u2c/Q9ZayACiUnGR2WEwtHhtra80eXpSmclJ19V9o4Oysk8D0lVVxyAreJFwHr6v
         /YKF4aGjmL92s6EFmlLaNUPb1jEKHIy6RVi3bkav4509Fuljzae4vIe9LTrle/+LLtqW
         pejkIN0A9tv7RpeFQSV0TDNAn6QQKtkG+NyYsCK8YeCbn14HdhZyiYLSkulfNHR2S1PP
         ZKb83dqAsRHBbhjFOpfC1EQLQ9NrFqPRhVyJ93GRi8yesS5/bK5JemvZM/Bowc/MHtFh
         H/2zmRDG6pzobAU9q7nlGbYBjvjkY/mePFwxtMHVtIkvyCJkR3b2orlNoYsPNNRgoRdv
         Ltnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LKqxM1L9nSD6Lxn49e1wmAIIH5JlsIFviYkSwTkXtJU=;
        b=AaY6YODLS+LoG4m6mUUt9M8TluPNoFbWj78LwBE3j5Kh844hp7f0qVUwzWIk/RguqW
         TxLPmyXoaUAvCiMItiAz7F3yOwiC40cUWjM2sywnAGts/mYr/m5IA7lTt2QnHyRC8f/R
         3rmqRJOYHBlS6nWN+ylSjgdZ8eF8sJ5vqO+UM12tV0ztNFHDteEbf8rj9YKhzQkNhS24
         8iV5Jwk6Owb4fVUwMv+mnq5/jF00HxMA7vCR2J6jge4obP8SxjlpcmP2rRx2yuQOw4t2
         QTfvBuuJFMulEAn5sBc+wCQhbVxbKRv12+iQe1kD7twsPYBxjfzOgpOMkRBpSR6Gvhrt
         LOzQ==
X-Gm-Message-State: APjAAAWwdHFfKVMZxo1Z9UhdyFlbn7AOCQgHQeQ2DdwTRAnMAHGjuBJV
        +NFfMdra80+FTOULckmADovjlKGxhG9qb+aHkA9K3Q==
X-Google-Smtp-Source: APXvYqw315vl2qv1Isg0NqvJh9vzh4pM4bFt32mAaoWQ9RASxQQHsRPaMMTpjimxmwGCFelKttMlfap7vllYqRTmUvU=
X-Received: by 2002:a67:fe18:: with SMTP id l24mr2769298vsr.121.1571768295889;
 Tue, 22 Oct 2019 11:18:15 -0700 (PDT)
MIME-Version: 1.0
References: <1571425340-7082-1-git-send-email-jbaron@akamai.com>
 <CADVnQymUMStN=oReEXGFT24NTUfMdZq_khcjZBTaV5=qW0x8_Q@mail.gmail.com>
 <CAK6E8=et_dMeie07-PHSdVO1i44bVLHcOVh+AMmWQqDpqsuGXQ@mail.gmail.com>
 <bd51b146-52b8-c56b-8efe-0e0cb73ee6c4@akamai.com> <20191021195150.GA7514@MacBook-Pro-64.local>
 <CANn89iJEYWVkS5bw1XtnW7NUP-WjZP1EY4Wzgs9u-VYyy0u-_Q@mail.gmail.com>
 <0841fe66-15a7-418f-4b57-4af6e2d45922@akamai.com> <CADVnQykxoK4JarMN_5Lps8YobTtoJvVstehbCZQ4P3hAGUQ+Uw@mail.gmail.com>
In-Reply-To: <CADVnQykxoK4JarMN_5Lps8YobTtoJvVstehbCZQ4P3hAGUQ+Uw@mail.gmail.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Tue, 22 Oct 2019 11:17:39 -0700
Message-ID: <CAK6E8=eUP9irp3QSZgF7Yd-OT2L2HwNx8SweXDYaGiSz-FJLrQ@mail.gmail.com>
Subject: Re: [net-next] tcp: add TCP_INFO status for failed client TFO
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Jason Baron <jbaron@akamai.com>,
        Eric Dumazet <edumazet@google.com>,
        Christoph Paasch <cpaasch@apple.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 7:14 PM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Mon, Oct 21, 2019 at 5:11 PM Jason Baron <jbaron@akamai.com> wrote:
> >
> >
> >
> > On 10/21/19 4:36 PM, Eric Dumazet wrote:
> > > On Mon, Oct 21, 2019 at 12:53 PM Christoph Paasch <cpaasch@apple.com> wrote:
> > >>
> > >
> > >> Actually, longterm I hope we would be able to get rid of the
> > >> blackhole-detection and fallback heuristics. In a far distant future where
> > >> these middleboxes have been weeded out ;-)
> > >>
> > >> So, do we really want to eternalize this as part of the API in tcp_info ?
> > >>
> > >
> > > A getsockopt() option won't be available for netlink diag (ss command).
> > >
> > > So it all depends on plans to use this FASTOPEN information ?
> > >
> >
> > The original proposal I had 4 states of interest:
> >
> > First, we are interested in knowing when a socket has TFO set but
> > actually requires a retransmit of a non-TFO syn to become established.
> > In this case, we'd be better off not using TFO.
> >
> > A second case is when the server immediately rejects the DATA and just
> > acks the syn (but not the data). Again in that case, we don't want to be
> > sending syn+data.
> >
> > The third case was whether or not we sent a cookie. Perhaps, the server
> > doesn't have TFO enabled in which case, it really doesn't make make
> > sense to enable TFO in the first place. Or if one also controls the
> > server its helpful in understanding if the server is mis-configured. So
> > that was the motivation I had for the original four states that I
> > proposed (final state was a catch-all state).
> >
> > Yuchung suggested dividing the 3rd case into 2 for - no cookie sent
> > because of blackhole or no cookie sent because its not in cache. And
> > then dropping the second state because we already have the
> > TCPI_OPT_SYN_DATA bit. However, the TCPI_OPT_SYN_DATA may not be set
> > because we may fallback in tcp_send_syn_data() due to send failure. So
but sendto would return -1 w/ EINPROGRESS in this case already so the
application shouldn't expect TCPI_OPT_SYN_DATA?


> > I'm inclined to say that the second state is valuable. And since
> > blackhole is already a global thing via MIB, I didn't see a strong need
> > for it. But it sounded like Yuchung had an interest in it, and I'd
> > obviously like a set of states that is generally useful.
>
> I have not kept up with all the proposals in this thread, but would it
> work to include all of the cases proposed in this thread? It seems
> like there are enough bits available in holes in tcp_sock and tcp_info
> to have up to 7 bits of information saved in tcp_sock and exported to
> tcp_info. That seems like more than enough?
I would rather use only at most 2-bits for TFO errors to be
parsimonious on (bloated) tcp sock. I don't mind if the next patch
skip my idea of BH detection.
my experience is reading host global stats for most applications are a
hassle (or sometimes not even feasible). they mostly care about
information of their own sockets.



>
> The pahole tool shows the following small holes in tcp_sock:
>
>         u8                         compressed_ack;       /*  1530     1 */
>
>         /* XXX 1 byte hole, try to pack */
>
>         u32                        chrono_start;         /*  1532     4 */
> ...
>         u8                         bpf_sock_ops_cb_flags; /*  2076     1 */
>
>         /* XXX 3 bytes hole, try to pack */
>
>         u32                        rcv_ooopack;          /*  2080     4 */
>
> ...and the following hole in tcp_info:
>         __u8                       tcpi_delivery_rate_app_limited:1;
> /*     7: 7  1 */
>
>         /* XXX 7 bits hole, try to pack */
>
>         __u32                      tcpi_rto;             /*     8     4 */
>
> cheers,
> neal
