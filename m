Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30EAD32DB13
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 21:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235818AbhCDUTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 15:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233659AbhCDUTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 15:19:08 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA22DC061574
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 12:18:27 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id u75so29873399ybi.10
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 12:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/YGTxSeylyfK5q/lJFMBK2jBXTYj4eOQz8iCi9WasRg=;
        b=X9SJB9gfaKtT5syXqBiao6Ncew1KOa/vC8X2JZZ1sPAaSqDiwYERbvx/PNPgCnumuo
         3Mp9Xy/cppF5GS6FlOeaAcb/++5zGTtxVjzB/epl0F9NLfDbyrh7LLDb8yCRZMc1Ef3U
         Rezj7+cJ1Idevj0zfYgjNGJh2En7U/0vsRcRO6W9oAaagOJaFlTvsGHYGTNAJ8OZ1lDd
         4cCyjlIOAz+7C3cdNIaagJE0mzGZyla/zRfAFyvVd3g4QSzB60hd5w0+OvUolDphbu05
         KSKptYmKf8S6bxXt/I5xryk7OOVseIStN5z3eOsxcxfSDDVL7eHcEOgTAjElVgB0PmMN
         A7ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/YGTxSeylyfK5q/lJFMBK2jBXTYj4eOQz8iCi9WasRg=;
        b=GOvRpmlRRbWGc72ZJbG7gp+7oSBBmkUOVml3Ih3yfgk2Uh1zfYGCfLKx0opCxBy2Cx
         b+sCu1MILctf3eWe9DpOrmVazwT0n7QKmWl0Wwf6aTMliVgieI/dvXjkswidHrA1M/Yi
         selugpaesVGGIecKIXdtBdbxJaZzLk39/bJ0F5dHyQqeGShmD9jpxtEfE1keqAXQayFR
         yqfpOHJqpvL0MdmuZKt6uAlB9CeRVw8gkiMP2AygedT18BDGpf8TN+WBnk6ek8P5bdjR
         wXBBuJYedIE49BO++0ELccunaHicwcZ5xvzGfZDW/pd7qR9LZS7kIzePZhy2WpdL8A54
         /QLA==
X-Gm-Message-State: AOAM533O1zvfi90l50oY7p63vOcs+7rOGPje9s3+tJfiGWtQG1NyEiQG
        hQptpk0GMrC+Hc9hAZUHqh6SLVb8L8EKXgdmIpx6kw==
X-Google-Smtp-Source: ABdhPJw/ywiRsqvi7Dy/hWtwv6D8bEelPU+nj+Ap8lqy9NmvKg9BkpB/O8HA64sx6gRxwgGidkr3NGTM2HDDx1xgpe8=
X-Received: by 2002:a25:ccc5:: with SMTP id l188mr9077487ybf.253.1614889106853;
 Thu, 04 Mar 2021 12:18:26 -0800 (PST)
MIME-Version: 1.0
References: <20210302060753.953931-1-kuba@kernel.org> <CANn89iLaQuCGeWOh7Hp8X9dL09FhPP8Nwj+zV=rhYX7Cq7efpg@mail.gmail.com>
 <CAKgT0UdXiFBW9oDwvsFPe_ZoGveHLGh6RXf55jaL6kOYPEh0Hg@mail.gmail.com>
 <20210303160715.2333d0ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKgT0Ue9w4WBojY94g3kcLaQrVbVk6S-HgsFgLVXoqsY20hwuw@mail.gmail.com>
 <CANn89iL9fBKDQvAM0mTnh_B5ggmsebDBYxM6WAfYgMuD8-vcBw@mail.gmail.com>
 <20210304110626.1575f7aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CANn89i+cXQXP-7ioizFy90Dj-1SfjA0MQfwvDChxVXQ3wbTjFA@mail.gmail.com>
In-Reply-To: <CANn89i+cXQXP-7ioizFy90Dj-1SfjA0MQfwvDChxVXQ3wbTjFA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 4 Mar 2021 21:18:15 +0100
Message-ID: <CANn89i+hrgC042kvyLUQwk8PgXNM4woeQGEF+jn16hd6XCGRPg@mail.gmail.com>
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

On Thu, Mar 4, 2021 at 8:41 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Mar 4, 2021 at 8:06 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 4 Mar 2021 13:51:15 +0100 Eric Dumazet wrote:
> > > I think we are over thinking this really (especially if the fix needs
> > > a change in core networking or drivers)
> > >
> > > We can reuse TSQ logic to have a chance to recover when the clone is
> > > eventually freed.
> > > This will be more generic, not only for the SYN+data of FastOpen.
> > >
> > > Can you please test the following patch ?
> >
> > #7 - Eric comes up with something much better :)
> >
> >
> > But so far doesn't seem to quite do it, I'm looking but maybe you'll
> > know right away (FWIW testing a v5.6 backport but I don't think TSQ
> > changed?):
> >
> > On __tcp_retransmit_skb kretprobe:
> >
> > ==> Hit TFO case ret:-16 ca_state:0 skb:ffff888fdb4bac00!
> >
> > First hit:
> >         __tcp_retransmit_skb+1
> >         tcp_rcv_state_process+2488
> >         tcp_v6_do_rcv+405
> >         tcp_v6_rcv+2984
> >         ip6_protocol_deliver_rcu+180
> >         ip6_input_finish+17
> >
> > Successful hit:
> >         __tcp_retransmit_skb+1
> >         tcp_retransmit_skb+18
> >         tcp_retransmit_timer+716
> >         tcp_write_timer_handler+136
> >         tcp_write_timer+141
> >         call_timer_fn+43
> >
> >  skb:ffff888fdb4bac00 --- delay:51642us bytes_acked:1
>
>
> Humm maybe one of the conditions used in tcp_tsq_write() does not hold...
>
> if (tp->lost_out > tp->retrans_out &&
>     tp->snd_cwnd > tcp_packets_in_flight(tp)) {
>     tcp_mstamp_refresh(tp);
>     tcp_xmit_retransmit_queue(sk);
> }
>
> Maybe FastOpen case is 'special' and tp->lost_out is wrong.

It would be nice if tun driver would have the ability to delay TX
completions by N usecs,
so that packetdrill tests could be used.

It is probably not too hard to add such a feature.
