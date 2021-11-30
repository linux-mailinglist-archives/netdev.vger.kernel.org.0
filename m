Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF4D463AB6
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243070AbhK3P7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242330AbhK3P7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:59:22 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274BFC061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 07:56:03 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id v203so54044401ybe.6
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 07:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tGm7hrKxQYGOtlSWcLfqDB5yQBnW+xxziphYxmJWypE=;
        b=tjTls+AGTH6tQ+6JuY32k0yReYU6oyWvzJWIOErYvbYHvGuzyZ7xhpZ4+FpNa02hWi
         GAWpij/CrE1gNPiE3Pi1jg+MrLR9z1v8qc1iO5Gv3A0uq3X4WoRXl6CcGWI7XG6fUh3J
         EaPY69WMjqkMOVwXnyiDzXUcpxtYDWSzGM/X60vXCt/W2HIqNTAkVXh9lS16sY8vxKB6
         5kCsymxS3y7YzXGOC+GC2LvC8Qoav3uVpaioZTlIFEhLKkEubhCThI4m3a3LW8rcELEy
         DDSVupucQNYj9wbqOyUUpxiSkIcmgawxMQ+G1BWq8BzD1Pt0fEiH/Pds3n5SSYZaFWBq
         NgKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tGm7hrKxQYGOtlSWcLfqDB5yQBnW+xxziphYxmJWypE=;
        b=UU3PZn7zysVQ9z0kKStnCV1AieGH9kHUzomKtCTBiR87kO4QJooJwxO4rueBuKD1jR
         3ZHZZvFILWGLa7Zpw9OL2GLLJu2JFMg6a4B6XKL9N/5Outu/kl1ug5GxthsbRG310F95
         YNstV+VcWkgE3agGnpS/amBGovtL/o0WZzV31jvEyKjrp922ViKjW+EaOpKx+HSrZby4
         GvrsnsH32wSzCTH71sNFyeEa6pKfuBGllFbw7G37Mejjk+3/7IrBkoIa20Ef6uu/MKt1
         pk0GUSWjntYEb+/YiLW4ka/HP80exyhiEC/MJFLoayWpzJoOz8nCSRrlzOtY3GEpDBgm
         KHVQ==
X-Gm-Message-State: AOAM530lkWAL75FYm9kocmfptK+SCR7ZZ3uZev2/ldts04UKRiYpWkV5
        z82njpoYxNJiaW8BCOB3z+Tvj4zR64bS1RxV+apzgA==
X-Google-Smtp-Source: ABdhPJyEB6BXIvnI4F6N82Esf5zou+hyPxilsfdIYtEyWP4jjQMoHV5EimOvGfqyMKjz0j/Vh3Cr2qFNwEdpdmef3Ek=
X-Received: by 2002:a25:6c6:: with SMTP id 189mr14650953ybg.753.1638287761883;
 Tue, 30 Nov 2021 07:56:01 -0800 (PST)
MIME-Version: 1.0
References: <20211128060102.6504-1-imagedong@tencent.com> <20211129075707.47ab0ffe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADxym3YJwgs1-hYZURUf+K56zTtQmWHbwAvEG27s_w8FwQrkQQ@mail.gmail.com> <20211130072308.76cc711c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211130072308.76cc711c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Nov 2021 07:55:50 -0800
Message-ID: <CANn89i+nQb7GEAhbRKZKaf=wTk1XcepT6whnk3P8qTZxeAHyow@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net: snmp: add statistics for tcp small queue check
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Menglong Dong <menglong8.dong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Menglong Dong <imagedong@tencent.com>,
        Yuchung Cheng <ycheng@google.com>, kuniyu@amazon.co.jp,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 7:23 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 30 Nov 2021 22:36:59 +0800 Menglong Dong wrote:
> > On Mon, Nov 29, 2021 at 11:57 PM Jakub Kicinski <kuba@kernel.org> wrote=
:
> > >
> > > On Sun, 28 Nov 2021 14:01:02 +0800 menglong8.dong@gmail.com wrote:
> > > > Once tcp small queue check failed in tcp_small_queue_check(), the
> > > > throughput of tcp will be limited, and it's hard to distinguish
> > > > whether it is out of tcp congestion control.
> > > >
> > > > Add statistics of LINUX_MIB_TCPSMALLQUEUEFAILURE for this scene.
> > >
> > > Isn't this going to trigger all the time and alarm users because of t=
he
> > > "Failure" in the TCPSmallQueueFailure name?  Isn't it perfectly fine
> > > for TCP to bake full TSQ amount of data and have it paced out onto th=
e
> > > wire? What's your link speed?
> >
> > Well, it's a little complex. In my case, there is a guest in kvm, and v=
irtio_net
> > is used with napi_tx enabled.
> >
> > With napi_tx enabled, skb won't be orphaned after it is passed to virti=
o_net,
> > until it is released. The point is that the sending interrupt of
> > virtio_net will be
> > turned off and the skb can't be released until the next net_rx interrup=
t comes.
> > So, wmem_alloc can't decrease on time, and the bandwidth is limited. Wh=
en
> > this happens, the bandwidth can decrease from 500M to 10M.
> >
> > In fact, this issue of uapi_tx is fixed in this commit:
> > https://lore.kernel.org/lkml/20210719144949.935298466@linuxfoundation.o=
rg/
> >
> > I added this statistics to monitor the sending failure (may be called
> > sending delay)
> > caused by qdisc and net_device. When something happen, maybe users can
> > raise =E2=80=98/proc/sys/net/ipv4/tcp_pacing_ss_ratio=E2=80=99 to get b=
etter bandwidth.
>
> Sounds very second-order and particular to a buggy driver :/
> Let's see what Eric says but I vote revert.

I did some tests yesterday, using one high speed TCP_STREAM (~90Gbit),
and got plenty of increments when using pfifo_fast qdisc.
Yet seed was nominal (bottleneck is the copyout() cost at receiver)

I got few counter increments when qdisc is fq as expected
(because of commit c73e5807e4f6fc6d "tcp: tsq: no longer use
limit_output_bytes for paced flows")


So this new SNMP counter is not a proxy for the kind of problems that a bug=
gy
driver would trigger.

I also suggest we revert this patch.

Thanks !
