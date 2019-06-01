Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB72831B3D
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 12:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfFAKbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 06:31:47 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39517 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfFAKbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 06:31:47 -0400
Received: by mail-ed1-f68.google.com with SMTP id e24so18798417edq.6;
        Sat, 01 Jun 2019 03:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jmzu/4f2VSybe0QBfOp4nNczJtPbQGeo/AKVN1JR9ts=;
        b=lq2dtFvFprYJYo/nLc5JBQ+xRtuz5Ob5ac30+8sE6xnhBOhMxH0KNHY1maBw2WpZHg
         QMoidWuFUQ8ZeRmkE2SUPcxtRI8G/FVz88Kt9aWLSWREuksiGaCJqovin8HEIN4CpsYB
         rz6xP608rnn4CbCXCNNnmpVnj8RFgwLUsxEZAZ16kLuGow1LTXP3uzGharu+nEd2r287
         zxzhYD57rEcX81csJG16YXbBHm0UKe5Y9hLoK/cnpxceF8ZN3TyTmM6jpBTRpPQ9noMp
         I4HOjuJUD10KXwA9KxZyZigFv9zk+rZEjBvCfWONbVgZ6nsAwJuHz6Xu6Mn/kNi8Biau
         T9Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jmzu/4f2VSybe0QBfOp4nNczJtPbQGeo/AKVN1JR9ts=;
        b=HAx2NiB4N0SqPrRJfZR1lmFaX/8P7HBoeHzkaA0yIfsGsnxs7axUQ3MgK6CgISow1N
         b6EC+gLCHcaS1YKUljUzT7kAjTG66ahuhzYCuIP7PaANH+ZdiVSRyjvCzXgJfS3U5VDB
         rIarM99QzFR8KvcNaqvVQW7blv/dMeEXKrqLoRy651OvNkr5S1l1/4h+qfgDbZUlyn/h
         luI+CfdL+rzLPEBDFkU/uMSpgajo9u0LQYZ57TH6tZK4qFu0BqnDawkd9KW+RhltYLcz
         SPogwqwtyxnu4rcMYNA+LNMWGwgGPRSil7hG8LYUXY9e0tpvx2NvImEPq/VAnlm5ojBb
         a8wg==
X-Gm-Message-State: APjAAAUOXJGUDlFn+5kv83I7NdMqdXkBFKEsFYgC7EsbaRG3nPKfoWu9
        tBZUfSeV0xaYPhUkODr1aO5+nYQ0UH/EF1d2QjXPm12gM+0=
X-Google-Smtp-Source: APXvYqxqLzqYj6AhQWHLo3YvdnTGsH5oDxKIkaDeZKOGWEgzvXTlACG85hQl6WqY7GpYr4Vs2SOANeLANsn6v2JL3E0=
X-Received: by 2002:aa7:d30a:: with SMTP id p10mr3269396edq.123.1559385105419;
 Sat, 01 Jun 2019 03:31:45 -0700 (PDT)
MIME-Version: 1.0
References: <CA+h21hrBwR4Sow7q0_rS1u2md1M4bSAJt8FO5+VLFiu9UGnvjA@mail.gmail.com>
 <20190531043417.6phscbpmo6krvxam@localhost> <CA+h21hp9DfW3wFy4YbHMU31rBHyrnUTdF4kKwX36h9vHOW2COw@mail.gmail.com>
 <20190531140841.j4f72rlojmaayqr5@localhost> <CA+h21hroywaij3gyO0u6v+GFVO2Fv_dP_a+L3oMGpQH8mQgJ5g@mail.gmail.com>
 <20190531151151.k3a2wdf5f334qmqh@localhost> <CA+h21hpHKbTc8toPZf0iprW1b4v6ErnRaSM=C6vk-GCiXM8NvA@mail.gmail.com>
 <20190531160909.jh43saqvichukv7p@localhost> <CA+h21hpVrVNJTFj4DHHV+zphs2MjyRO-XZsM3D-STra+BYYHtw@mail.gmail.com>
 <CA+h21houLC7TGJYQ28LxiUxyBE7ju2ZiRcUd41aGo_=uAhgVgQ@mail.gmail.com> <20190601050714.xylw5noxka7sa4p3@localhost>
In-Reply-To: <20190601050714.xylw5noxka7sa4p3@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 1 Jun 2019 13:31:34 +0300
Message-ID: <CA+h21hr3+vUjS9_m=CtEbFeN9Bgxkg8b-4zuXSMnZXGtfUEOsQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] PTP support for the SJA1105 DSA driver
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Jun 2019 at 08:07, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Fri, May 31, 2019 at 09:12:03PM +0300, Vladimir Oltean wrote:
> > It won't work unless I make changes to dsa_switch_rcv.
>
> Or to the tagging code.
>
> > Right now taggers can only return a pointer to the skb, or NULL, case
> > in which DSA will free it.
>
> The tagger can re-write the skb.  Why not reform it into a PTP frame?
> This clever trick is what the phyter does in hardware.  See dp83640.c.
>

I think you're missing the point here.
If I dress the meta frame into a PTP frame (btw is there any
preferable event message for this purpose?) then sure, I'll make
dsa_skb_defer_rx_timestamp call my .port_rxtstamp and I can e.g. move
my state machine there.
The problem is that in the current DSA structure, I'll still have less
timestampable frames waiting for a meta frame than meta frames
themselves. This is because not all frames that the switch takes an RX
timestamp for will make it to my .port_rxtstamp (in fact that is what
my .can_timestamp patch changes). I can put the timestampable frame in
a 1-entry wait queue which I'll deplete upon arrival of the first meta
frame, but when I get meta frames and the wait queue is empty, it can
mean multiple things: either DSA didn't care about this timestamp
(ok), or the timestampable frame got reordered or dropped by the MAC,
or what have you (not ok). So I can't exclude the possibility that the
meta frame was holding a relevant timestamp.
Sure, I can dress the meta frame into whatever the previous
MAC-trapped frame was (PTP or not) and then I'll have .port_rxtstamp
function see a 1-to-1 correspondence with meta frames in case
everything works fine. But then I'll have non-PTP meta frames leaking
up the stack...

Regards,
-Vladimir

> Thanks,
> Richard
