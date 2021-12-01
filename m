Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B864644BD
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 03:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345767AbhLACKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 21:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhLACKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 21:10:36 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D58CC061574;
        Tue, 30 Nov 2021 18:07:16 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id e3so94936088edu.4;
        Tue, 30 Nov 2021 18:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Q7bk1j8rvvz4uX2mN5YTRCJvGLhiNi4/73IzBOFoXW0=;
        b=A4xlL+3rYGcmuXegQvpIDum21gdq4IDGk+pbzzHFYUBErJK5DekZ2cp4JvVpO39vJc
         zlLXuzh0xUsHylKuEeyPCCfwIYDlTJ8Lvi2LWp28An3Z6zTspFm0/HTBdaRfLzpztkbu
         q/lGEvmjX6RCUJZ715TbOVSehvxt2GqVHrNuKIpihyKjGWpTCFVCPTmSf4/QLbN994+Q
         mfM/UYFu4ptKnmaU0tQ9usR3qPqD14KGpfOzwJkyIrj0xWLRkC0kvFS3Ed/EfqtD8ROu
         1znr9u/9rvB8kcKkCFoTuI4aKB4RZ8wngyOK4LpJbR78bVAMf0rPh/TJ4ViatnpGmdZK
         155w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Q7bk1j8rvvz4uX2mN5YTRCJvGLhiNi4/73IzBOFoXW0=;
        b=jwGGfm/eXLkvqzCg4vF3bRF39sISlgQNR0TiebVcoJwaAAvg3oztBEXDla4bJzRkhP
         B8hH4QUII7Ij6I6rLrRmFOKZti/1N27f73zMHORp9NXJR+KyZrOFFXz+u5Udl0QMQJ3j
         tbepmC9JKxLluaKY6hp/u5QE3uVY+JF+HCOq9moAE2LbA7DRLfPagW+vhXIdELSWH1Dm
         bJlmhc53jXk0nHjIfXgZGBx8Q2u6sxtRXHKdl/zkrxMDbWCYJibIWdhgN/+VVtrE2suU
         cOvinlnoc0KxS7hVdWYUUnuW0Z65LZql8adQOLAT9qQoGb2MomU9MtiJfaV7avU9SYG2
         0cPw==
X-Gm-Message-State: AOAM531gyp99d894p1ZUpnlJiRLPNLgYbY7iiFnbackw9NW1b0Y5+54F
        Sf5LGYdDxnRMLyRIt54KZZt+G1meMA955oaJ2Tg=
X-Google-Smtp-Source: ABdhPJxT8kpUrFn2N5X0PEOSEXPokcaAu3GDNzgtjaogU54uKaCqUZ3etLAq0lDLDqaOo5And2DwgcPziNbOaDHojkM=
X-Received: by 2002:a17:907:2d0e:: with SMTP id gs14mr3473337ejc.249.1638324434619;
 Tue, 30 Nov 2021 18:07:14 -0800 (PST)
MIME-Version: 1.0
References: <20211128060102.6504-1-imagedong@tencent.com> <20211129075707.47ab0ffe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADxym3YJwgs1-hYZURUf+K56zTtQmWHbwAvEG27s_w8FwQrkQQ@mail.gmail.com>
 <20211130072308.76cc711c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CANn89i+nQb7GEAhbRKZKaf=wTk1XcepT6whnk3P8qTZxeAHyow@mail.gmail.com>
In-Reply-To: <CANn89i+nQb7GEAhbRKZKaf=wTk1XcepT6whnk3P8qTZxeAHyow@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 1 Dec 2021 10:05:05 +0800
Message-ID: <CADxym3bQ5OJCn_HDqctRrsAaHpnKw6HVnYMRbsWv37Z7R9+Tjg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net: snmp: add statistics for tcp small queue check
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
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

On Tue, Nov 30, 2021 at 11:56 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Nov 30, 2021 at 7:23 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 30 Nov 2021 22:36:59 +0800 Menglong Dong wrote:
> > > On Mon, Nov 29, 2021 at 11:57 PM Jakub Kicinski <kuba@kernel.org> wro=
te:
> > > >
> > > > On Sun, 28 Nov 2021 14:01:02 +0800 menglong8.dong@gmail.com wrote:
> > > > > Once tcp small queue check failed in tcp_small_queue_check(), the
> > > > > throughput of tcp will be limited, and it's hard to distinguish
> > > > > whether it is out of tcp congestion control.
> > > > >
> > > > > Add statistics of LINUX_MIB_TCPSMALLQUEUEFAILURE for this scene.
> > > >
> > > > Isn't this going to trigger all the time and alarm users because of=
 the
> > > > "Failure" in the TCPSmallQueueFailure name?  Isn't it perfectly fin=
e
> > > > for TCP to bake full TSQ amount of data and have it paced out onto =
the
> > > > wire? What's your link speed?
> > >
> > > Well, it's a little complex. In my case, there is a guest in kvm, and=
 virtio_net
> > > is used with napi_tx enabled.
> > >
> > > With napi_tx enabled, skb won't be orphaned after it is passed to vir=
tio_net,
> > > until it is released. The point is that the sending interrupt of
> > > virtio_net will be
> > > turned off and the skb can't be released until the next net_rx interr=
upt comes.
> > > So, wmem_alloc can't decrease on time, and the bandwidth is limited. =
When
> > > this happens, the bandwidth can decrease from 500M to 10M.
> > >
> > > In fact, this issue of uapi_tx is fixed in this commit:
> > > https://lore.kernel.org/lkml/20210719144949.935298466@linuxfoundation=
.org/
> > >
> > > I added this statistics to monitor the sending failure (may be called
> > > sending delay)
> > > caused by qdisc and net_device. When something happen, maybe users ca=
n
> > > raise =E2=80=98/proc/sys/net/ipv4/tcp_pacing_ss_ratio=E2=80=99 to get=
 better bandwidth.
> >
> > Sounds very second-order and particular to a buggy driver :/
> > Let's see what Eric says but I vote revert.
>
> I did some tests yesterday, using one high speed TCP_STREAM (~90Gbit),
> and got plenty of increments when using pfifo_fast qdisc.
> Yet seed was nominal (bottleneck is the copyout() cost at receiver)
>
> I got few counter increments when qdisc is fq as expected
> (because of commit c73e5807e4f6fc6d "tcp: tsq: no longer use
> limit_output_bytes for paced flows")
>
>
> So this new SNMP counter is not a proxy for the kind of problems that a b=
uggy
> driver would trigger.
>
> I also suggest we revert this patch.

Seems this SNMP is indeed not suitable....I vote to revert too.

=EF=BC=88Seems Jakub already do the revert, thanks~)

In fact, I'm a little curious that this patch is applied directly. I
used to receive
emails with the message 'applied'.

>
> Thanks !
