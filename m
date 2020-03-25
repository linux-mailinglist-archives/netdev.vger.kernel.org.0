Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB0FC19323B
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 21:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgCYU7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 16:59:04 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:34641 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727253AbgCYU7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 16:59:03 -0400
Received: by mail-qv1-f68.google.com with SMTP id o18so1869185qvf.1
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 13:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H5IsZP6t10V6sjESTiOYWRaMgPFf4+IS45LYdq0AKJQ=;
        b=q83i3F3K31l9NUOGhr5Pvnxw9GfOUNf9hRJYHvmkSXUBRiXCLTmcODCLOZyNNr+qCk
         kSWQKEZzFcKSIp9gUdTFDHy9fHj+RnOtpfAYgqSfQ4xoVZltEprqd1ZlzntUs+MZ8f8D
         dJh11x27ESL12BhIDf7cj0/dQQ9WXg0CGjQuKSeWjJ2gUF53grnJ5eRLt2BAA3LQN5Bf
         i250qgNH2GK9hCiJba+dwNNac6ji19exybrwXZhytpizoklN31V9XTNwXyUlTjhCdYpU
         WMR2sLsWoyp4qAzIKIP7Jcvl1vXtN5UsXj1hhXP5DcNTgSsnfU6u/mRSdMaApqCG3+UA
         xWZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H5IsZP6t10V6sjESTiOYWRaMgPFf4+IS45LYdq0AKJQ=;
        b=Pxm9jWE+EGRv5SaZsZIbW41vUADlsiJ0ZIIhOZU4ppZBGYF3mx2u0ule1d6OyXsXFT
         HVLE+PMPCv+8YjxdTkCHlFSI5Y2Adib86QrQJ0MvNYdlTLD3cxI3j2AOpgOGApavcLff
         ZHhZGN21dZjoH8c4NxTgU1DDRq2q6tPGb/uX1U8eRsU4n0rbF/HN3Q7wFUCYTkR3IeWr
         WQqGHrgGd/V6KNuwMr7xvY6cpqdlj4CGqX4poJq+FdAZKmDSkXRl5/S2VIBQybCoY8F7
         aqvYIFiCcaCUkRa8dbNn75yi1NrZjwRCVKFcNGLBvEaKq6cv6NsvwKqV4erjQINKwXBS
         z6nQ==
X-Gm-Message-State: ANhLgQ0nHLt4Lstb6e8aMJQqh2Tht9dzELTLYAjVVXe0yUwmljtFniwh
        YXXqXc/jiTjPadyEF4sBuAqmF3U4
X-Google-Smtp-Source: ADFU+vtVVws52JoUfUK3Mm4TaH0Jp2LdBo/pHFjfgs9q+UV6iQkTn5xjcrX3Ufu87AMSkDbSfJxCCA==
X-Received: by 2002:ad4:4dc5:: with SMTP id cw5mr5069558qvb.109.1585169942737;
        Wed, 25 Mar 2020 13:59:02 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id s195sm17877qke.25.2020.03.25.13.59.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 13:59:02 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id i4so2012940ybl.3
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 13:59:01 -0700 (PDT)
X-Received: by 2002:a25:4904:: with SMTP id w4mr8870283yba.441.1585169941303;
 Wed, 25 Mar 2020 13:59:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200325022321.21944-1-edumazet@google.com> <ace8e72488fbf2473efaed9fc0680886897939ab.camel@redhat.com>
 <CA+FuTSdO_WBhrRj5PNdXppywDNkMKJ4hLry+3oSvy8mavnxw0g@mail.gmail.com> <2b5f096a143f4dea9c9a2896913d8ca79688b00f.camel@redhat.com>
In-Reply-To: <2b5f096a143f4dea9c9a2896913d8ca79688b00f.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 25 Mar 2020 16:58:24 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe307uhufBxf78X0qf+v+0Asqv90UGMVKs9ztwy5ALcPg@mail.gmail.com>
Message-ID: <CA+FuTSe307uhufBxf78X0qf+v+0Asqv90UGMVKs9ztwy5ALcPg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: use indirect call wrappers for skb_copy_datagram_iter()
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 12:00 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Wed, 2020-03-25 at 10:55 -0400, Willem de Bruijn wrote:
> > On the UDP front this reminded me of another indirect function call
> > without indirect call wrapper: getfrag in __ip_append_data.
> >
> > That is called for each datagram once per linear + once per page. That
> > said, the noise in my quick RR test was too great to measure any
> > benefit from the following.
>
> Why an RR test ?
>
> I think you should be able to measure some raw tput improvement with
> large UDP GSO write towards a blackhole dst/or dropping ingress pkts
> with XDP (just to be sure the bottle-neck is on the sender side).

Thanks for the suggestion. I ran a send-only udpgso_bench_tx test
to a dummy device with NETIF_F_GSO_UDP_L4.

    ip link add dummy0 type dummy
    ip link set dev dummy0 mtu 1500
    ip link set dev dummy0 up
    ip addr add 10.0.0.1/24 dev dummy0
    perf stat -- ./udpgso_bench_tx -C 1 -4 -D 10.0.0.2 -l 5 -S 0

By default, this generates only 3 getfrag calls per sendmsg, due to
sk_page_frag_refill generating 32KB compound pages.

When disabling compound pages by setting sysctl
net.core.high_order_alloc_disable , this increased to 17 getfrag calls
per sendmsg.

Even then any benefit appears to be in the noise. Both reported
10900-11700 MB/s.

The effect of that sysctl, and thus compound pages, was much larger
than I expected. With that disabled, I observed 16500-18100 MBps.

In summary, this particular indirect call does not appear worthwhile.
