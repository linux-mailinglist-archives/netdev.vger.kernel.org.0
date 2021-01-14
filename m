Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1257A2F55F8
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729899AbhANAgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 19:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729903AbhANAe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 19:34:56 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3870CC061575;
        Wed, 13 Jan 2021 16:09:53 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id d20so3691290otl.3;
        Wed, 13 Jan 2021 16:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vZV+6JNZ9AMFDA8LKCfNVRXM0e5aK8AvdT2wlgQnc3k=;
        b=q0/tymPT6nywwo4ZK4mafniJnz7/UEhMIXp0D0wJkWPM3A82Hakn9jFHlPW2DTNSAX
         WRa9mg6tdeTc+Vp6hau//5KLiH0ebjVMEvX0tyHYHYAw5mFcsLHpvd3ha/zrqywuRVzW
         GkgKIvXq6xqZQmtvBJZXh6WnMcCc/lJa4gToEWDucKRtd8AaC4HRfVymjwNLPO887q/D
         uX3iFplDliuZYDKGPMHzYb2DPbC2ra9Re/uIxeCPgpqDcAmADBB8r+KWouwaPf6QQHZz
         pLxQ74S53dwq7DWs+yIUNZzur7xwap6iSBCno9xHhunIfSg+LsyGFn+1V83h+Tz6Zent
         /7oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vZV+6JNZ9AMFDA8LKCfNVRXM0e5aK8AvdT2wlgQnc3k=;
        b=fQ+o18jDLdRJvm5qonO2xYH9Xl+Cz3wUwjNF78i5dRENWlTqTZN0fwpxo6DD3R7Em7
         jLIWAZVx9RSVwhOkdmSCqELFj7220LVTNhxXzI9pezaeUR42Eqrd1MzR022wT3d0Pb2b
         d6B+gSvLTzZHS2LgG109UrCxEOs5Lb/0udwCgUGrKMbIu/9tSwp3mjaTws9+6apM9aC3
         NZFRTpuWlmcu5BbdpA9wp6h/ewGd33lvaSaX4ljiQu9x1Wx3l+MgHuNBQBoAkBBdtdkd
         vgoEeG0nVZW7f9xBRt6HsqpulADLKfjzNjF0ZZxHYCSGr7babDQJBLxmV85UJgFne07L
         1rNg==
X-Gm-Message-State: AOAM530JcYZhvp6vEH1/W2+zPjR62SxAZTzXYU1xy7uxvip61NMdcaYv
        BEYNFBpWYUDFYCi7NoSrfS8=
X-Google-Smtp-Source: ABdhPJwHFfDDLFOXeMUgqQeMwRHbMGqZlXkwH2K+H8iTAvFBvQiXnhTfI1m4RHCGobgmq5EO7jFgvQ==
X-Received: by 2002:a9d:d31:: with SMTP id 46mr2808936oti.1.1610582992623;
        Wed, 13 Jan 2021 16:09:52 -0800 (PST)
Received: from localhost.localdomain (99-6-134-177.lightspeed.snmtca.sbcglobal.net. [99.6.134.177])
        by smtp.gmail.com with ESMTPSA id p18sm756575ood.48.2021.01.13.16.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 16:09:52 -0800 (PST)
Date:   Wed, 13 Jan 2021 16:09:49 -0800
From:   Enke Chen <enkechen2020@gmail.com>
To:     Yuchung Cheng <ycheng@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jonathan Maxwell <jmaxwell37@gmail.com>,
        William McCall <william.mccall@gmail.com>
Subject: Re: [PATCH] tcp: fix TCP_USER_TIMEOUT with zero window
Message-ID: <20210114000949.GC3738@localhost.localdomain>
References: <20210113201201.GC2274@localhost.localdomain>
 <CANn89iJh1_fCm93B0w2VAzCLPUTSow85JMBQT3sy=0sALbXhrQ@mail.gmail.com>
 <CAK6E8=d=ct4J-tUOXxE+1og5CfPwaJ=Wd=Bj9pqaVdrOdnAR_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK6E8=d=ct4J-tUOXxE+1og5CfPwaJ=Wd=Bj9pqaVdrOdnAR_g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes, I am convinced :-) Thanks to Eric, Neal and Yuchung for their help.

-- Enke

On Wed, Jan 13, 2021 at 01:20:55PM -0800, Yuchung Cheng wrote:
> On Wed, Jan 13, 2021 at 12:49 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Wed, Jan 13, 2021 at 9:12 PM Enke Chen <enkechen2020@gmail.com> wrote:
> > >
> > > From: Enke Chen <enchen@paloaltonetworks.com>
> > >
> > > The TCP session does not terminate with TCP_USER_TIMEOUT when data
> > > remain untransmitted due to zero window.
> > >
> > > The number of unanswered zero-window probes (tcp_probes_out) is
> > > reset to zero with incoming acks irrespective of the window size,
> > > as described in tcp_probe_timer():
> > >
> > >     RFC 1122 4.2.2.17 requires the sender to stay open indefinitely
> > >     as long as the receiver continues to respond probes. We support
> > >     this by default and reset icsk_probes_out with incoming ACKs.
> > >
> > > This counter, however, is the wrong one to be used in calculating the
> > > duration that the window remains closed and data remain untransmitted.
> > > Thanks to Jonathan Maxwell <jmaxwell37@gmail.com> for diagnosing the
> > > actual issue.
> > >
> > > In this patch a separate counter is introduced to track the number of
> > > zero-window probes that are not answered with any non-zero window ack.
> > > This new counter is used in determining when to abort the session with
> > > TCP_USER_TIMEOUT.
> > >
> >
> > I think one possible issue would be that local congestion (full qdisc)
> > would abort early,
> > because tcp_model_timeout() assumes linear backoff.
> Yes exactly. if ZWPs are dropped due to local congestion, the
> model_timeout computes incorrectly. Therefore having a starting
> timestamp is the surest way b/c it does not assume any specific
> backoff behavior.
> 
> >
> > Neal or Yuchung can further comment on that, it is late for me in France.
> >
> > packetdrill test would be :
> >
> >    0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
> >    +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
> >    +0 bind(3, ..., ...) = 0
> >    +0 listen(3, 1) = 0
> >
> >
> >    +0 < S 0:0(0) win 0 <mss 1460>
> >    +0 > S. 0:0(0) ack 1 <mss 1460>
> >
> >   +.1 < . 1:1(0) ack 1 win 65530
> >    +0 accept(3, ..., ...) = 4
> >
> >    +0 setsockopt(4, SOL_TCP, TCP_USER_TIMEOUT, [3000], 4) = 0
> >    +0 write(4, ..., 24) = 24
> >    +0 > P. 1:25(24) ack 1
> >    +.1 < . 1:1(0) ack 25 win 65530
> >    +0 %{ assert tcpi_probes == 0, tcpi_probes; \
> >          assert tcpi_backoff == 0, tcpi_backoff }%
> >
> > // install a qdisc dropping all packets
> >    +0 `tc qdisc delete dev tun0 root 2>/dev/null ; tc qdisc add dev
> > tun0 root pfifo limit 0`
> >    +0 write(4, ..., 24) = 24
> >    // When qdisc is congested we retry every 500ms therefore in theory
> >    // we'd retry 6 times before hitting 3s timeout. However, since we
> >    // estimate the elapsed time based on exp backoff of actual RTO (300ms),
> >    // we'd bail earlier with only 3 probes.
> >    +2.1 write(4, ..., 24) = -1
> >    +0 %{ assert tcpi_probes == 3, tcpi_probes; \
> >          assert tcpi_backoff == 0, tcpi_backoff }%
> >    +0 close(4) = 0
> >
