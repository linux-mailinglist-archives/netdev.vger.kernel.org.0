Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 074A1284FF
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 19:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387396AbfEWReC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 13:34:02 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:36941 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730904AbfEWReC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 13:34:02 -0400
Received: by mail-yb1-f193.google.com with SMTP id z12so2583856ybr.4
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 10:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f5KppckN56sMdYhz8xvqsrI+Y0WLZHTGOGk/50MNd+Y=;
        b=mUJcuguNcVjaPgObFwmvI4CASe+SqsrXOE/B7sLjKhhEMtRDMJV+koFUZVYD96M/Yj
         /9llkbG6zcopYRxNVJC8AGJN54Th2oX87pxFftG5XsfPiq7ALnYqhs9R0wV0+aGC8AJw
         yPoKgZ+KKHeKfIRk5GyMfkiUSongR5B7vxdFMvVgIuY+pCXwbhRNJ2vHM2mQ0q4qEqhr
         uEUuL/mSzUbmfoHju1bHoBaDPz7tVWtgl7ywoq3YWsv0uBVEpeeaH+2xWo1/ti25L9x1
         wZ6gedra3/EXc1Uv8wB7o9N0+LhKgvXfsxbC6FXRZ9Ae7LgJQldTKwp3vGTAnPdv5ToE
         6n1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f5KppckN56sMdYhz8xvqsrI+Y0WLZHTGOGk/50MNd+Y=;
        b=aq1t1Wz89Y7RHyerYkHhDt7LND6iQah8/Zco4QG7grDiUONkQstWAmg9VIty5Mlx4T
         HvYogiI6zz4GzyWtwQgxbL/KGDngUhD6sVynBktTCKN32+mWJ2WiiB6RVBEmbwivS5GV
         r1s9Dd6yJZghFQ7ZQoXzuR+p2TQFDAC5+uk9Zp345B5Cd4Fl/zzdMihT7QZUq36ahNd1
         jEqrhIuotsIGPzX9XpNugJaFCu3IhHCaObBXrKIDKWjaPDvzDbE2WvEzX3ODkmKs9Mj1
         AaZ2GhbK5bK3jrz1b7kVRveJde6wJqvUuxd/ALNUX4ay/Cl222GH3Rw8G682JifDVl5Q
         nFRA==
X-Gm-Message-State: APjAAAXhDNF2m5sWgomcaq9on1CEKoAPVovNVTNE0YhLNu7xzO+sTTQF
        qjEgmMUVVApWjkWYDhjuJTSmsXvc
X-Google-Smtp-Source: APXvYqyQkFbY7XkCT3D3gmwsvJ6jLoSZaaELR8/WuDqKwKc8gukoGa2lX5gTxsO8TddNp0TLRZMJ2Q==
X-Received: by 2002:a25:1144:: with SMTP id 65mr45027701ybr.142.1558632840442;
        Thu, 23 May 2019 10:34:00 -0700 (PDT)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id l192sm7425321ywl.107.2019.05.23.10.33.59
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 10:33:59 -0700 (PDT)
Received: by mail-yb1-f176.google.com with SMTP id a3so2578248ybr.6
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 10:33:59 -0700 (PDT)
X-Received: by 2002:a25:ed02:: with SMTP id k2mr14578195ybh.125.1558632838656;
 Thu, 23 May 2019 10:33:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190523164507.50208-1-willemb@google.com> <1c4e190f-5f9c-be8e-a560-9aef7f483bb4@gmail.com>
In-Reply-To: <1c4e190f-5f9c-be8e-a560-9aef7f483bb4@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 23 May 2019 13:33:22 -0400
X-Gmail-Original-Message-ID: <CA+FuTSd11kyWjQ9V+TfgCEutzAFCheL=POq7kL0chkObcdk05Q@mail.gmail.com>
Message-ID: <CA+FuTSd11kyWjQ9V+TfgCEutzAFCheL=POq7kL0chkObcdk05Q@mail.gmail.com>
Subject: Re: [PATCH net-next] selftests/net: SO_TXTIME with ETF and FQ
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 1:06 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 5/23/19 9:45 AM, Willem de Bruijn wrote:
> > The SO_TXTIME API enables packet tranmission with delayed delivery.
> > This is currently supported by the ETF and FQ packet schedulers.
> >
> > Evaluate the interface with both schedulers. Install the scheduler
> > and send a variety of packets streams: without delay, with one
> > delayed packet, with multiple ordered delays and with reordering.
> > Verify that packets are released by the scheduler in expected order.
> >
> > The ETF qdisc requires a timestamp in the future on every packet. It
> > needs a delay on the qdisc else the packet is dropped on dequeue for
> > having a delivery time in the past. The test value is experimentally
> > derived. ETF requires clock_id CLOCK_TAI. It checks this base and
> > drops for non-conformance.
> >
> > The FQ qdisc expects clock_id CLOCK_MONOTONIC, the base used by TCP
> > as of commit fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC").
> > Within a flow there is an expecation of ordered delivery, as shown by
> > delivery times of test 4. The FQ qdisc does not require all packets to
> > have timestamps and does not drop for non-conformance.
> >
> > The large (msec) delays are chosen to avoid flakiness.
> >
> >       Output:
> >
> >       SO_TXTIME ipv6 clock monolithic
>
> s/monolithic/monotonic/

Oops. That's actually fixed in the latest version, just not in the
commit message. I'll send a v2 just to update that. Thanks Eric.

Having some trouble with git send-email and gmail today, hence the
email from my google.com account, too.



>
> >       payload:a delay:33 expected:0 (us)
> >
> >       SO_TXTIME ipv4 clock monolithic
> >       payload:a delay:44 expected:0 (us)
> >
> >       SO_TXTIME ipv6 clock monolithic
> >       payload:a delay:10049 expected:10000 (us)
> >
> >       SO_TXTIME ipv4 clock monolithic
> >       payload:a delay:10105 expected:10000 (us)
>
>
> Thanks for the test Willem.
>
> Acked-by: Eric Dumazet <edumazet@google.com>
>
