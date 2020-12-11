Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DB02D7F49
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 20:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393419AbgLKTTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 14:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729958AbgLKTSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 14:18:41 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CFBC0613D6
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 11:18:01 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id i9so10583180ioo.2
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 11:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TpL5j0wxilEj0YGcq7bQWSNpU6rX05pPXbA7fekSIe4=;
        b=JwcbZr45xttGYQbhMTptTMZ/07mDTeri6lf9x9Lk3mqfsgwwv5uS8VaIm5S24E0vat
         zMdC+58pwzqMqUOo4njYD/apdJIgxTKMC//071b1m9fJvSxhgChEVR7YxzK2KCwAuFBo
         PvVaXZ7MadRfhzSsTVDHHzxvcWiJVSXYZMbdJgEfP54thgDOrm43X9pNx1zAHd6uNy4k
         1hswuxH2mSlJNG97ty3W0YyDe/Ink+NTgIXHZUswniaFADSoJkd53aSG6/Qe26aX9/yG
         WVuUzg6xjxrGLbeqD7tTCaiJhJ/Hrhi7pn9jbfhkqHQ/gwfDUrXq4mHWStp1Pqj3nug5
         LNMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TpL5j0wxilEj0YGcq7bQWSNpU6rX05pPXbA7fekSIe4=;
        b=VhK8VJKdrUXG616jHBz2ijJQaBGiJ5O1llAeBdV9ZQfLqay8xBrKiRl6QCVCsqXOAc
         ZEK1F+TnusDpCTcyPvlFQEAfF3LrjA1vNXWc7zpnAXyNWpMzq9C4ZOm+/KEas2Mboj9T
         ktOIr+8tKUmG8nUx8Vg9HLDzg5TkTqQvUR9b0kXHEd34vfulZw2dHt7ofTxGx3tkWRnj
         pTWV2pP4vE49qxPfDDSZBbpCMfeasJV4LdzgvrJQiV2eJ1PEKydf6KWxhjEteOM1n3iN
         aW+wfCOOhK+tBY3cY8Cf3qARDGIZAML/lHVMiG+ToZeNktyDntdEukkeQTfNl0kPZw24
         //pQ==
X-Gm-Message-State: AOAM531XWEHr6FHz2mTb2a5r9BXpkC4qI7F3FIBQOIAssBvoxqUulrGu
        ouYXDpSNAfWbfYhnWV7ZkYU3ceYvMwcekA/13YKN/SZJtDzPoc4aBiE=
X-Google-Smtp-Source: ABdhPJyk7FPEmO/BcL5iIjH1kz1vOVayt3gx5OkWA/XVR/G+5GtrE0NZrh3oznOuRXfKQrU9aATi3hMCQt9+FvV+HuY=
X-Received: by 2002:a6b:d61a:: with SMTP id w26mr16643357ioa.117.1607714280769;
 Fri, 11 Dec 2020 11:18:00 -0800 (PST)
MIME-Version: 1.0
References: <160765171921.6905.7897898635812579754.stgit@localhost.localdomain>
 <CANn89iJ5HnJYv6eWb1jm6rK173DFkp2GRnfvi9vnYwXZPzE4LQ@mail.gmail.com>
 <CAKgT0Uf_q=FgMHd9_wq5Bx8rCC-kS0Qz563rE9dL2hpQ6Evppg@mail.gmail.com>
 <CANn89iJUT6aWm75ZpU_Ggmuqbb+cbLSGj0Bxysu9_wXRgNS8MQ@mail.gmail.com> <CAKgT0Uecuh3mcGRpDAZzzbnQtOusc++H4SXAv2Scd297Ha5AYQ@mail.gmail.com>
In-Reply-To: <CAKgT0Uecuh3mcGRpDAZzzbnQtOusc++H4SXAv2Scd297Ha5AYQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 11 Dec 2020 20:17:49 +0100
Message-ID: <CANn89iKfqKpXgCv_Z4iSt5RpjxYUvkYSoZKF3FZs+Jgev3aDgw@mail.gmail.com>
Subject: Re: [net PATCH] tcp: Mark fastopen SYN packet as lost when receiving ICMP_TOOBIG/ICMP_FRAG_NEEDED
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Yuchung Cheng <ycheng@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        kernel-team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 6:15 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, Dec 11, 2020 at 8:22 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Fri, Dec 11, 2020 at 5:03 PM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> >
> > > That's fine. I can target this for net-next. I had just selected net
> > > since I had considered it a fix, but I suppose it could be considered
> > > a behavioral change.
> >
> > We are very late in the 5.10 cycle, and we never handled ICMP in this
> > state, so net-next is definitely better.
> >
> > Note that RFC 7413 states in 4.1.3 :
> >
> >  The client MUST cache cookies from servers for later Fast Open
> >    connections.  For a multihomed client, the cookies are dependent on
> >    the client and server IP addresses.  Hence, the client should cache
> >    at most one (most recently received) cookie per client and server IP
> >    address pair.
> >
> >    When caching cookies, we recommend that the client also cache the
> >    Maximum Segment Size (MSS) advertised by the server.  The client can
> >    cache the MSS advertised by the server in order to determine the
> >    maximum amount of data that the client can fit in the SYN packet in
> >    subsequent TFO connections.  Caching the server MSS is useful
> >    because, with Fast Open, a client sends data in the SYN packet before
> >    the server announces its MSS in the SYN-ACK packet.  If the client
> >    sends more data in the SYN packet than the server will accept, this
> >    will likely require the client to retransmit some or all of the data.
> >    Hence, caching the server MSS can enhance performance.
> >
> >    Without a cached server MSS, the amount of data in the SYN packet is
> >    limited to the default MSS of 536 bytes for IPv4 [RFC1122] and 1220
> >    bytes for IPv6 [RFC2460].  Even if the client complies with this
> >    limit when sending the SYN, it is known that an IPv4 receiver
> >    advertising an MSS less than 536 bytes can receive a segment larger
> >    than it is expecting.
> >
> >    If the cached MSS is larger than the typical size (1460 bytes for
> >    IPv4 or 1440 bytes for IPv6), then the excess data in the SYN packet
> >    may cause problems that offset the performance benefit of Fast Open.
> >    For example, the unusually large SYN may trigger IP fragmentation and
> >    may confuse firewalls or middleboxes, causing SYN retransmission and
> >    other side effects.  Therefore, the client MAY limit the cached MSS
> >    to 1460 bytes for IPv4 or 1440 for IPv6.
> >
> >
> > Relying on ICMP is fragile, since they can be filtered in some way.
>
> In this case I am not relying on the ICMP, but thought that since I
> have it I should make use of it. WIthout the ICMP we would still just
> be waiting on the retransmit timer.
>
> The problem case has a v6-in-v6 tunnel between the client and the
> endpoint so both ends assume an MTU 1500 and advertise a 1440 MSS
> which works fine until they actually go to send a large packet between
> the two. At that point the tunnel is triggering an ICMP_TOOBIG and the
> endpoint is stalling since the MSS is dropped to 1400, but the SYN and
> data payload were already smaller than that so no retransmits are
> being triggered. This results in TFO being 1s slower than non-TFO
> because of the failure to trigger the retransmit for the frame that
> violated the PMTU. The patch is meant to get the two back into
> comparable times.

Okay... Have you studied why tcp_v4_mtu_reduced() (and IPv6 equivalent)
code does not yet handle the retransmit in TCP_SYN_SENT state ?
