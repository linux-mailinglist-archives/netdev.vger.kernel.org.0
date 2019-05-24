Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9F92902E
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 06:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731875AbfEXEyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 00:54:15 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46591 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfEXEyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 00:54:15 -0400
Received: by mail-ed1-f66.google.com with SMTP id f37so12391067edb.13;
        Thu, 23 May 2019 21:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uG3LPpXz6HczhaN7aWRgjWXEjlUyPFH9Q9Ci4mtls4c=;
        b=RhchpjZOyc6YOPzzhLiPo8uzy5QDshjjbVUAl/1r0pHwDCT81ap/4dXT5pjxUt8lNA
         obCEhe35IXr1YlvBHPxqrVNPu8XGZ0xNB+ml51goaUAgnvBwIp09n4jwJ6VyvTjlu0pZ
         6XUkcty1O/OhNMrJaQayoBeScyevQA0ZGRTFaiAZpJRoaY39VU2uBDN8NGG+i3cvK87N
         /tsNbnvGjGlhrXjKG7ck5PkM8v/+1CCC8LPr4FPAYSPh0r43IjdPY66x9wpp5xmfRvht
         mhyS1QBWOgnrv7aM2HAmhfi4RZbpLhEKn8y8lb/rLPM4S4DTFffZpt1FezySNME4RHCs
         9biw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uG3LPpXz6HczhaN7aWRgjWXEjlUyPFH9Q9Ci4mtls4c=;
        b=d/EG75l/gNmdfB3QvjeSSx38STsuf1tHFF1QXPjyi9/+gSrliCLgwe330rcXe99Crt
         OY7I9s5iSRCGgbqdA5L4XY9lZFz8GToU4M6dIiXJ2Sw7ORVEbfkGw6fl5r/IewHp0h2l
         VmBu7sAknuh08NXab05/HkcnmGHrQmgRxUmEWnlWDQGtBZSh07Iw8NrVQJef5QIiTO5G
         u/TdiujHYQeJ8aVngM6mcGspNu9oh3U4cAY5UxEzTlUqEMcCfsIRhOVEuOSrzbuhsMFx
         8UCswlySdoeD6bTjJLwJLolHxBdJ3Y8lnimcS55VXJ+vBa1DpI5QvTTOBfjFMZ2cPILb
         8mWw==
X-Gm-Message-State: APjAAAWsIDDKjwnNg6U8/CF09ngsH9Dpn1Bz0KepX1egMWBH30tU8TsY
        Xq49vSmRoNtt1tjlNsQKXCwURTukAaDsNDohxPKrlw==
X-Google-Smtp-Source: APXvYqyVFquGjXhN70UMr779J+DpaHvuoyJcT5E5q7SCuYrvqDrm5fabMf10dubNfnA1j7pgstupffbjFBuG45z+GV8=
X-Received: by 2002:a50:f5d0:: with SMTP id x16mr100271128edm.287.1558673653525;
 Thu, 23 May 2019 21:54:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190523210651.80902-1-fklassen@appneta.com> <20190523210651.80902-2-fklassen@appneta.com>
 <CAF=yD-Jf95De=z_nx9WFkGDa6+nRUqM_1PqGkjwaFPzOe+PfXg@mail.gmail.com> <AE8E0772-7256-4B9C-A990-96930E834AEE@appneta.com>
In-Reply-To: <AE8E0772-7256-4B9C-A990-96930E834AEE@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 24 May 2019 00:53:37 -0400
Message-ID: <CAF=yD-LtAKpND601LQrC1+=iF6spSUXVdUapcsbJdv5FYa=5Jg@mail.gmail.com>
Subject: Re: [PATCH net 1/4] net/udp_gso: Allow TX timestamp with UDP GSO
To:     Fred Klassen <fklassen@appneta.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 9:38 PM Fred Klassen <fklassen@appneta.com> wrote:
>
> > Thanks for the report.
> >
> > Zerocopy notification reference count is managed in skb_segment. That
> > should work.
> >
> > Support for timestamping with the new GSO feature is indeed an
> > oversight. The solution is similar to how TCP associates the timestamp
> > with the right segment in tcp_gso_tstamp.
> >
> > Only, I think we want to transfer the timestamp request to the last
> > datagram, not the first. For send timestamp, the final byte leaving
> > the host is usually more interesting.
>
> TX Timestamping the last packet of a datagram is something that would
> work poorly for our application. We need to measure the time it takes
> for the first bit that is sent until the first bit of the last packet is received.
> Timestaming the last packet of a burst seems somewhat random to me
> and would not be useful. Essentially we would be timestamping a
> random byte in a UDP GSO buffer.
>
> I believe there is a precedence for timestamping the first packet. With
> IPv4 packets, the first packet is timestamped and the remaining fragments
> are not.

Interesting. TCP timestamping takes the opposite choice and does
timestamp the last byte in the sendmsg request.

It sounds like it depends on the workload. Perhaps this then needs to
be configurable with an SOF_.. flag.

Another option would be to return a timestamp for every segment. But
they would all return the same tskey. And it causes different behavior
with and without hardware offload.
