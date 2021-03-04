Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA8432DA84
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 20:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236391AbhCDTmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 14:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbhCDTmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 14:42:38 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DEFC06175F
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 11:41:58 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id m9so29793118ybk.8
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 11:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5inzGOmXl2dPiZFolyIoKS8T3zZi7XEEJyDRvg/FgMU=;
        b=mQJZ+TiQoJMxofvyDf8y0V1KAxptE7bck3MOigBova7TKsuxa/7SMzP5rUGlmZ5/v+
         jbkhyIJNMaKLbJPTV0eG6xOnXFiVCNrejsKZHAPE2KfYwggZAPp6Wo24Vck7RyqR6Dgq
         Pw9gN+FJMpL37exZEKuLBq4y3b7YUxWiIETpqLrZWxeWvqAVDyDrcf57Wdo9cbn0NlzT
         vR3lhJqDr8XPzk5fO7283EHVvrpQm19qphxySeOqBaOx7p/CrGCUarA8GVNPKyC9X++6
         E+/kgUu3UanKx46c63qwFlaUxrPCW4WkkMXmkagjP9ttK5oyZkNYUxXWAQoRW7+MyTSB
         7/Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5inzGOmXl2dPiZFolyIoKS8T3zZi7XEEJyDRvg/FgMU=;
        b=PZx2LvyrER8NIj1OPd1Lj+Zeb7rgaqIr9h/Tu9ABAAOem17OxAu6+adU+AfifxJEM3
         fJGb8Msf4juWGz+Phcs4aK7KchF6XdzgUZRNxy6258XS9qV73PzPRORzWTv8X8lP5EJr
         87pLWXsul2Zodo9KjdpDhzw3sjBiKl5OsFM/5Msz52Z28VDWx+N1G8fvM+qh3U6SweFl
         8uuOlNnrLoZchM1fPRLe3wlW3tbxXpE7dLwx9gSaLyY8m4AO39z45ayaQDOxaQUUjmQW
         ijUwpn9wh5jDlfj+DMzdPOzeFtfTNRcO4G6lqZDSXcf+Tz9Ela8aotCfUscb4xuiiwsC
         0c9A==
X-Gm-Message-State: AOAM532h7zWiTF5R4c+QroNJcIQbKDb92MgsqT35WEP4SB5dQlkrp0JZ
        G5JElypoCw6a+BkeC/xGNIGZ8bpK/pZpI21Qc51zzA==
X-Google-Smtp-Source: ABdhPJzW8jp9ISb/8VaCQHsDqCInWU3PCIZHwBlKHxiEowdWQSsVT/IsXsYfXi3U1ibVa16J/Eoxh5P7qMNb198wskM=
X-Received: by 2002:a25:2307:: with SMTP id j7mr9011516ybj.518.1614886916918;
 Thu, 04 Mar 2021 11:41:56 -0800 (PST)
MIME-Version: 1.0
References: <20210302060753.953931-1-kuba@kernel.org> <CANn89iLaQuCGeWOh7Hp8X9dL09FhPP8Nwj+zV=rhYX7Cq7efpg@mail.gmail.com>
 <CAKgT0UdXiFBW9oDwvsFPe_ZoGveHLGh6RXf55jaL6kOYPEh0Hg@mail.gmail.com>
 <20210303160715.2333d0ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKgT0Ue9w4WBojY94g3kcLaQrVbVk6S-HgsFgLVXoqsY20hwuw@mail.gmail.com>
 <CANn89iL9fBKDQvAM0mTnh_B5ggmsebDBYxM6WAfYgMuD8-vcBw@mail.gmail.com> <20210304110626.1575f7aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210304110626.1575f7aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 4 Mar 2021 20:41:45 +0100
Message-ID: <CANn89i+cXQXP-7ioizFy90Dj-1SfjA0MQfwvDChxVXQ3wbTjFA@mail.gmail.com>
Subject: Re: [PATCH net] net: tcp: don't allocate fast clones for fastopen SYN
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@fb.com>, Neil Spring <ntspring@fb.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 4, 2021 at 8:06 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 4 Mar 2021 13:51:15 +0100 Eric Dumazet wrote:
> > I think we are over thinking this really (especially if the fix needs
> > a change in core networking or drivers)
> >
> > We can reuse TSQ logic to have a chance to recover when the clone is
> > eventually freed.
> > This will be more generic, not only for the SYN+data of FastOpen.
> >
> > Can you please test the following patch ?
>
> #7 - Eric comes up with something much better :)
>
>
> But so far doesn't seem to quite do it, I'm looking but maybe you'll
> know right away (FWIW testing a v5.6 backport but I don't think TSQ
> changed?):
>
> On __tcp_retransmit_skb kretprobe:
>
> ==> Hit TFO case ret:-16 ca_state:0 skb:ffff888fdb4bac00!
>
> First hit:
>         __tcp_retransmit_skb+1
>         tcp_rcv_state_process+2488
>         tcp_v6_do_rcv+405
>         tcp_v6_rcv+2984
>         ip6_protocol_deliver_rcu+180
>         ip6_input_finish+17
>
> Successful hit:
>         __tcp_retransmit_skb+1
>         tcp_retransmit_skb+18
>         tcp_retransmit_timer+716
>         tcp_write_timer_handler+136
>         tcp_write_timer+141
>         call_timer_fn+43
>
>  skb:ffff888fdb4bac00 --- delay:51642us bytes_acked:1


Humm maybe one of the conditions used in tcp_tsq_write() does not hold...

if (tp->lost_out > tp->retrans_out &&
    tp->snd_cwnd > tcp_packets_in_flight(tp)) {
    tcp_mstamp_refresh(tp);
    tcp_xmit_retransmit_queue(sk);
}

Maybe FastOpen case is 'special' and tp->lost_out is wrong.
