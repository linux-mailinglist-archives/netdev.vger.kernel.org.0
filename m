Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE10428FABC
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 23:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731395AbgJOVkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 17:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgJOVkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 17:40:02 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3896C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 14:40:01 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id s2so139276vks.13
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 14:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lub4zB17xVRPAdPXAMOQDpe5vm63XnWv1jQj4CLOnlk=;
        b=G9C52u9cJP92WVB2M6b+/YDGCcpCwFgQC59mlcMo4I9+JmGN15FUbzHkgG/muyQ5m5
         oRs4xcGtDQjUO4wIipBggfPUWxDBXUu1NxD0pHNyMz3iNmlyOIyWP7si97X27gpx3Yjf
         b1PaNUhviOS4fhskpjFb9spPdDNTWiv8GxXIKy0+mQ4TnIilv1BMP1wDtdKnwHGsAy5j
         X8EjwafttoyZtLYdMTE3DBjz9NKxK4DfvmS/Mtx6g/g+Ock1PPmLc2a4IAvrL76oIZl1
         TgGA3NGb2rsmnMHiqogY2sqORYkAHidSy0nhZUpDV+Kj6EgUbqD6c2Je5Wu0KVdfRhC0
         mvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lub4zB17xVRPAdPXAMOQDpe5vm63XnWv1jQj4CLOnlk=;
        b=K4qHcskyDgNUCRATMrz8C5CX18Rf7G6PoXQ3jCe5zGUETiibe+VjsUbDOxlyhQSe+t
         cHup5uqgncOpBQ3jmLRaH7/lxna4VoCUPwDtujZziZ/TkpsdV4A86/36jrdsAlkmKl0t
         WQu2A1eO5bgfwvDE6fWpIk765J3r3Tja6IyevmDRj9IzECp9Oi5giMtrS/pw3JC7qjg0
         +SM+K6HCkrFARjmfGUo2KgBYce/bXrMTBL3yfJrd8MlzlPG0BIpu5XavjUYyc/w4xmKB
         GFpu5F7MC3tNtWvkFgaGQMC4Fv1qwQ6AMTuaG3xFlmlVL9YtxLNfqD+ZKOymWt9Htivt
         aL2A==
X-Gm-Message-State: AOAM531P/2SLA6VPW7CeuE4bAu4CpupxDgI+td2ZpvvIZKH5OCzprXYm
        OY9nsWKJVCk4O+FqBz4Mnavk+2csU+aN33SDV0o89IxKnBg=
X-Google-Smtp-Source: ABdhPJwC11n7Xmcbn2Ae4qmJIuk7OfMeRJ09SNGScXyWWt4AmdKDf6ccTl/dkPzcK+8mSMbhZVdVJPfnSkfxfYwKstQ=
X-Received: by 2002:a1f:6082:: with SMTP id u124mr300381vkb.19.1602798000550;
 Thu, 15 Oct 2020 14:40:00 -0700 (PDT)
MIME-Version: 1.0
References: <87eelz4abk.fsf@marvin.dmesg.gr> <CADVnQym6OPVRcJ6PdR3hjN5Krcn0pugshdLZsrnzNQe1c52HXA@mail.gmail.com>
In-Reply-To: <CADVnQym6OPVRcJ6PdR3hjN5Krcn0pugshdLZsrnzNQe1c52HXA@mail.gmail.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Thu, 15 Oct 2020 14:39:24 -0700
Message-ID: <CAK6E8=fCwjP47DvSj4YQQ6xn25bVBN_1mFtrBwOJPYU6jXVcgQ@mail.gmail.com>
Subject: Re: TCP sender stuck in persist despite peer advertising non-zero window
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Apollon Oikonomopoulos <apoikos@dmesg.gr>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 1:22 PM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Thu, Oct 15, 2020 at 2:31 PM Apollon Oikonomopoulos <apoikos@dmesg.gr> wrote:
> >
> > Hi,
> >
> > I'm trying to debug a (possible) TCP issue we have been encountering
> > sporadically during the past couple of years. Currently we're running
> > 4.9.144, but we've been observing this since at least 3.16.
> >
> > Tl;DR: I believe we are seeing a case where snd_wl1 fails to be properly
> > updated, leading to inability to recover from a TCP persist state and
> > would appreciate some help debugging this.
>
> Thanks for the detailed report and diagnosis. I think we may need a
> fix something like the following patch below.
>
> Eric/Yuchung/Soheil, what do you think?
wow hard to believe how old this bug can be. The patch looks good but
can Apollon verify this patch fix the issue?

>
> commit 42b37c72aa73aaabd0c01b8c05c2205236279021
> Author: Neal Cardwell <ncardwell@google.com>
> Date:   Thu Oct 15 16:06:11 2020 -0400
>
>     tcp: fix to update snd_wl1 in bulk receiver fast path
>
>     In the header prediction fast path for a bulk data receiver, if no
>     data is newly acknowledged then we do not call tcp_ack() and do not
>     call tcp_ack_update_window(). This means that a bulk receiver that
>     receives large amounts of data can have the incoming sequence numbers
>     wrap, so that the check in tcp_may_update_window fails:
>        after(ack_seq, tp->snd_wl1)
>
>     The fix is to update snd_wl1 in the header prediction fast path for a
>     bulk data receiver, so that it keeps up and does not see wrapping
>     problems.
>
>     Signed-off-by: Neal Cardwell <ncardwell@google.com>
>     Reported-By: Apollon Oikonomopoulos <apoikos@dmesg.gr>
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index b1ce2054291d..75be97f6a7da 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -5766,6 +5766,8 @@ void tcp_rcv_established(struct sock *sk, struct
> sk_buff *skb)
>                                 tcp_data_snd_check(sk);
>                                 if (!inet_csk_ack_scheduled(sk))
>                                         goto no_ack;
> +                       } else {
> +                               tcp_update_wl(tp, TCP_SKB_CB(skb)->seq);
>                         }
>
>                         __tcp_ack_snd_check(sk, 0);
>
> neal
