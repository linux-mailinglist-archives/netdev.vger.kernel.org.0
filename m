Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44757DFB82
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 04:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730750AbfJVCOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 22:14:11 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34648 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730625AbfJVCOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 22:14:11 -0400
Received: by mail-ot1-f65.google.com with SMTP id m19so12861359otp.1
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 19:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r/rmC+XtQiQ6qlkQurZvC9z87SszXCjHzsP9uF7RHdo=;
        b=VSR5X0QmMHBTfWaz2qB7lHfX66tRAeGnOiU0017iJ19i9ipxmiqPgvPj0b10Nhap+g
         VZLQVR7Ptp8qSr1evudNRnTwN+z56szGEB9yaRREAOA0dp8OpaEL2HtCiXRSolO9oKb/
         nf70gA1Inb46s6vREiw3LiqS5ZINfIhsZz5B9/qR4dJg7U1xKXEPGghzMnf7VyR9YjNE
         PpbuNlE4QYVEOEw5jaQrKuWG+7f0g/Ro/yBoKzDPhdTQL50QqI0GNuEtxsDGHR0Z3Pwl
         5Mtpk12HDyZnb5Qe0G2iMd6p1qBvgXaO1C/+rE7qJmd7XP4rBn+/VDUuMaDtXH1QW2dA
         nRKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r/rmC+XtQiQ6qlkQurZvC9z87SszXCjHzsP9uF7RHdo=;
        b=cBkyvGIj6nylAWnDwLl10mkNIuyBSKtOyMN0W6LfVho2zDEnUkyRtPb4VNZgt2AV0f
         1i4HaH2uBnQhxM9B2a0hkpC3iLoi7JFBT0LV/UJ9itWOYaClAzubjBPQAce1pVMqFM21
         lrQKzDN1QZ0me/kwGsqFXLdYyNOscrZbDfplfWwq9jUGzjgz+OD6lC5flAk77IVON3Ms
         vnZ5mNBwAu/0+4jk7r9GqeXxFjaFv/DKFdKi5Y7XNDaUSYpP1ue6uRyiV2CEM27SuzYU
         t2SxtlUfaAkcKk0p9LWW8lNqS8d/AyXRiEgy5o2vl1gu9LNJNoxcIDScnfgFyeLifXJV
         G0SQ==
X-Gm-Message-State: APjAAAUsEQ7a5ue41uPmwIDl9v4m5claPUVetTm92dHZ+tJzymxzdQPx
        TYNioTqgPJFpWZqXKKWn/VBqrGX0Gtya/5iilYuyxA==
X-Google-Smtp-Source: APXvYqxDXSWJw5yyfx7DPyUmUQnuAFJ90uOkRT3Cn9nQUupCqsn4DFnGozjfTDQSxWepoD2Rs7Q9BAJNQTzjDSuLKtk=
X-Received: by 2002:a9d:60c9:: with SMTP id b9mr699973otk.255.1571710449567;
 Mon, 21 Oct 2019 19:14:09 -0700 (PDT)
MIME-Version: 1.0
References: <1571425340-7082-1-git-send-email-jbaron@akamai.com>
 <CADVnQymUMStN=oReEXGFT24NTUfMdZq_khcjZBTaV5=qW0x8_Q@mail.gmail.com>
 <CAK6E8=et_dMeie07-PHSdVO1i44bVLHcOVh+AMmWQqDpqsuGXQ@mail.gmail.com>
 <bd51b146-52b8-c56b-8efe-0e0cb73ee6c4@akamai.com> <20191021195150.GA7514@MacBook-Pro-64.local>
 <CANn89iJEYWVkS5bw1XtnW7NUP-WjZP1EY4Wzgs9u-VYyy0u-_Q@mail.gmail.com> <0841fe66-15a7-418f-4b57-4af6e2d45922@akamai.com>
In-Reply-To: <0841fe66-15a7-418f-4b57-4af6e2d45922@akamai.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 21 Oct 2019 22:13:52 -0400
Message-ID: <CADVnQykxoK4JarMN_5Lps8YobTtoJvVstehbCZQ4P3hAGUQ+Uw@mail.gmail.com>
Subject: Re: [net-next] tcp: add TCP_INFO status for failed client TFO
To:     Jason Baron <jbaron@akamai.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Yuchung Cheng <ycheng@google.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 5:11 PM Jason Baron <jbaron@akamai.com> wrote:
>
>
>
> On 10/21/19 4:36 PM, Eric Dumazet wrote:
> > On Mon, Oct 21, 2019 at 12:53 PM Christoph Paasch <cpaasch@apple.com> wrote:
> >>
> >
> >> Actually, longterm I hope we would be able to get rid of the
> >> blackhole-detection and fallback heuristics. In a far distant future where
> >> these middleboxes have been weeded out ;-)
> >>
> >> So, do we really want to eternalize this as part of the API in tcp_info ?
> >>
> >
> > A getsockopt() option won't be available for netlink diag (ss command).
> >
> > So it all depends on plans to use this FASTOPEN information ?
> >
>
> The original proposal I had 4 states of interest:
>
> First, we are interested in knowing when a socket has TFO set but
> actually requires a retransmit of a non-TFO syn to become established.
> In this case, we'd be better off not using TFO.
>
> A second case is when the server immediately rejects the DATA and just
> acks the syn (but not the data). Again in that case, we don't want to be
> sending syn+data.
>
> The third case was whether or not we sent a cookie. Perhaps, the server
> doesn't have TFO enabled in which case, it really doesn't make make
> sense to enable TFO in the first place. Or if one also controls the
> server its helpful in understanding if the server is mis-configured. So
> that was the motivation I had for the original four states that I
> proposed (final state was a catch-all state).
>
> Yuchung suggested dividing the 3rd case into 2 for - no cookie sent
> because of blackhole or no cookie sent because its not in cache. And
> then dropping the second state because we already have the
> TCPI_OPT_SYN_DATA bit. However, the TCPI_OPT_SYN_DATA may not be set
> because we may fallback in tcp_send_syn_data() due to send failure. So
> I'm inclined to say that the second state is valuable. And since
> blackhole is already a global thing via MIB, I didn't see a strong need
> for it. But it sounded like Yuchung had an interest in it, and I'd
> obviously like a set of states that is generally useful.

I have not kept up with all the proposals in this thread, but would it
work to include all of the cases proposed in this thread? It seems
like there are enough bits available in holes in tcp_sock and tcp_info
to have up to 7 bits of information saved in tcp_sock and exported to
tcp_info. That seems like more than enough?

The pahole tool shows the following small holes in tcp_sock:

        u8                         compressed_ack;       /*  1530     1 */

        /* XXX 1 byte hole, try to pack */

        u32                        chrono_start;         /*  1532     4 */
...
        u8                         bpf_sock_ops_cb_flags; /*  2076     1 */

        /* XXX 3 bytes hole, try to pack */

        u32                        rcv_ooopack;          /*  2080     4 */

...and the following hole in tcp_info:
        __u8                       tcpi_delivery_rate_app_limited:1;
/*     7: 7  1 */

        /* XXX 7 bits hole, try to pack */

        __u32                      tcpi_rto;             /*     8     4 */

cheers,
neal
