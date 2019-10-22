Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9F56E0CBD
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 21:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387979AbfJVTqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 15:46:11 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:40869 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfJVTqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 15:46:11 -0400
Received: by mail-ua1-f66.google.com with SMTP id i13so5283744uaq.7
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 12:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PP4Wjl8S+mqP+H/3L35+WrcCmWzUPLqZp8f/iDp0IV8=;
        b=b18EUPzKdSlaY2sZlfAj/9KIeeVe1yMMjzFEUlJIU22xjX4dma3rhgmnXkK6aCCKsX
         PVT3DC7FfP7e4VDaYPUVE6aqDnB5qvX2yXP9/pQVa5qjoqo7xR7N+hecrsDViJBP/2MP
         geuFOBsyKqSNgqyWgXXfWrYKBqsJhDSaHPWX2PjfLh5IGUtd3dnKa/UsEb61A+DVLKMs
         BN32yznH6PaweJav6DP7rYeMwpe7iWRZM3FFo2bsfUdyKX0MW2FXFi2HSao5+ykUN8uL
         CRlaFsn5+uHrgy5oyfIW2mfTarYDMJ5F1iSUnLmlnzqIAcD00fWTAWKc9RQNXdsBLG8d
         wuFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PP4Wjl8S+mqP+H/3L35+WrcCmWzUPLqZp8f/iDp0IV8=;
        b=GD7i0DgJgpfCaKPd35Z7iho5rjST51H61XvmfFuGuIwtwJ6qGxSVLUYxPxplPM5kzx
         fv7OKaLhOmLdIdJ6mJU+kCzY0ajIMQvaH8Fe1wPhsAUOAX1C4mSBEAJUpjMXWSctuS9t
         rMAh057H7lkBWS2wMXs4KK7XQqg9suCtjN5kCvVKowJ9GsrUcUAdz1uNECPvz1NMkT7O
         P3teTkuCbHEW+hgeNiB+0TzlyhxulltwEWwExf5WtHMcs+JpOSI1Q+cfE2i8FEXXxnsA
         95lt52RCq07ar9MqxrUtfNU2fMfI3AJ9SFmcEaemVtKCpV3fh8HKov9XFUiwO7ZQC+wK
         jvZQ==
X-Gm-Message-State: APjAAAWakq3UZ46KxhsIZa1w/38TFBuC67D5KL7SBgfXj/4325HsoIRv
        /yXjX80jl3YWeIq0KTI1FkncXt+4Yoi8A39VBjHCRGoy
X-Google-Smtp-Source: APXvYqwepmKAprE0CmC5W9Lzazv+HjRM/2r/eCYwW6fWD2zR0J0NFZOt7q2oDje8LU4FWxAHA2Q8pNYDl11wT6CU5mY=
X-Received: by 2002:ab0:7107:: with SMTP id x7mr3060617uan.87.1571773569337;
 Tue, 22 Oct 2019 12:46:09 -0700 (PDT)
MIME-Version: 1.0
References: <1571425340-7082-1-git-send-email-jbaron@akamai.com>
 <CADVnQymUMStN=oReEXGFT24NTUfMdZq_khcjZBTaV5=qW0x8_Q@mail.gmail.com>
 <CAK6E8=et_dMeie07-PHSdVO1i44bVLHcOVh+AMmWQqDpqsuGXQ@mail.gmail.com>
 <bd51b146-52b8-c56b-8efe-0e0cb73ee6c4@akamai.com> <20191021195150.GA7514@MacBook-Pro-64.local>
 <CANn89iJEYWVkS5bw1XtnW7NUP-WjZP1EY4Wzgs9u-VYyy0u-_Q@mail.gmail.com>
 <0841fe66-15a7-418f-4b57-4af6e2d45922@akamai.com> <CADVnQykxoK4JarMN_5Lps8YobTtoJvVstehbCZQ4P3hAGUQ+Uw@mail.gmail.com>
 <CAK6E8=eUP9irp3QSZgF7Yd-OT2L2HwNx8SweXDYaGiSz-FJLrQ@mail.gmail.com> <2166c3ff-e08d-e89d-4753-01c8bd2d9505@akamai.com>
In-Reply-To: <2166c3ff-e08d-e89d-4753-01c8bd2d9505@akamai.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Tue, 22 Oct 2019 12:45:32 -0700
Message-ID: <CAK6E8=esVgr0y1EFUFBt34PAJpQ-norzogRRxskjtfRoC92RKg@mail.gmail.com>
Subject: Re: [net-next] tcp: add TCP_INFO status for failed client TFO
To:     Jason Baron <jbaron@akamai.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Christoph Paasch <cpaasch@apple.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 12:34 PM Jason Baron <jbaron@akamai.com> wrote:
>
>
>
> On 10/22/19 2:17 PM, Yuchung Cheng wrote:
> > On Mon, Oct 21, 2019 at 7:14 PM Neal Cardwell <ncardwell@google.com> wrote:
> >>
> >> On Mon, Oct 21, 2019 at 5:11 PM Jason Baron <jbaron@akamai.com> wrote:
> >>>
> >>>
> >>>
> >>> On 10/21/19 4:36 PM, Eric Dumazet wrote:
> >>>> On Mon, Oct 21, 2019 at 12:53 PM Christoph Paasch <cpaasch@apple.com> wrote:
> >>>>>
> >>>>
> >>>>> Actually, longterm I hope we would be able to get rid of the
> >>>>> blackhole-detection and fallback heuristics. In a far distant future where
> >>>>> these middleboxes have been weeded out ;-)
> >>>>>
> >>>>> So, do we really want to eternalize this as part of the API in tcp_info ?
> >>>>>
> >>>>
> >>>> A getsockopt() option won't be available for netlink diag (ss command).
> >>>>
> >>>> So it all depends on plans to use this FASTOPEN information ?
> >>>>
> >>>
> >>> The original proposal I had 4 states of interest:
> >>>
> >>> First, we are interested in knowing when a socket has TFO set but
> >>> actually requires a retransmit of a non-TFO syn to become established.
> >>> In this case, we'd be better off not using TFO.
> >>>
> >>> A second case is when the server immediately rejects the DATA and just
> >>> acks the syn (but not the data). Again in that case, we don't want to be
> >>> sending syn+data.
> >>>
> >>> The third case was whether or not we sent a cookie. Perhaps, the server
> >>> doesn't have TFO enabled in which case, it really doesn't make make
> >>> sense to enable TFO in the first place. Or if one also controls the
> >>> server its helpful in understanding if the server is mis-configured. So
> >>> that was the motivation I had for the original four states that I
> >>> proposed (final state was a catch-all state).
> >>>
> >>> Yuchung suggested dividing the 3rd case into 2 for - no cookie sent
> >>> because of blackhole or no cookie sent because its not in cache. And
> >>> then dropping the second state because we already have the
> >>> TCPI_OPT_SYN_DATA bit. However, the TCPI_OPT_SYN_DATA may not be set
> >>> because we may fallback in tcp_send_syn_data() due to send failure. So
> > but sendto would return -1 w/ EINPROGRESS in this case already so the
> > application shouldn't expect TCPI_OPT_SYN_DATA?
>
> Ok, but let's say the sk_stream_alloc_skb() fails in
> tcp_send_syn_data(), in that case we aren't going to send a TFO cookie
> (just a regular syn). The user isn't going to get any error and would
> expect TCPI_OPT_SYN_DATA. Now, TCPI_OPT_SYN_DATA wouldn't be set but we
> can't assume then that a SYN+data was sent and the SYN_ACK didn't cover
> the data part. Instead, the reason for failure is really -ENOMEM, which
> in the proposed states would fall into TFO_STATUS_UNSPEC, but it does
> mean that I think we shouldn't have a TFO_DATA_NOT_ACKED state otherwise
> we can't differentiate the two.
>
> >
> >
> >>> I'm inclined to say that the second state is valuable. And since
> >>> blackhole is already a global thing via MIB, I didn't see a strong need
> >>> for it. But it sounded like Yuchung had an interest in it, and I'd
> >>> obviously like a set of states that is generally useful.
> >>
> >> I have not kept up with all the proposals in this thread, but would it
> >> work to include all of the cases proposed in this thread? It seems
> >> like there are enough bits available in holes in tcp_sock and tcp_info
> >> to have up to 7 bits of information saved in tcp_sock and exported to
> >> tcp_info. That seems like more than enough?
> > I would rather use only at most 2-bits for TFO errors to be
> > parsimonious on (bloated) tcp sock. I don't mind if the next patch
> > skip my idea of BH detection.
> > my experience is reading host global stats for most applications are a
> > hassle (or sometimes not even feasible). they mostly care about
> > information of their own sockets.
>
> hmmm, if you are ok without having the BH failure state which Christoph
> also pushed back on a bit, but we still only want 2 bits as you
> suggested how about:
>
> 1) TFO_STATUS_UNSPEC - includes black hole state and other failures
> 2) TFO_COOKIE_UNAVAILABLE - we don't have a cookie in the cache
> 3) TFO_DATA_NOT_ACKED - syn+data sent but no ack for data part
> 4) TFO_SYN_RETRANSMITTED - same as 3 but at least 1 additional syn sent
sounds good to me. thanks
>
> Thanks,
>
> -Jason
