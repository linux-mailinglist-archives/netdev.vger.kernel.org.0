Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9E08FB690
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 18:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfKMRsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 12:48:09 -0500
Received: from mail-ed1-f47.google.com ([209.85.208.47]:45712 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfKMRsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 12:48:08 -0500
Received: by mail-ed1-f47.google.com with SMTP id b5so2565501eds.12
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 09:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=456bcQjEvXeW7l592fw/efzt1WDifEcQv/t51a2XAVk=;
        b=tgqNHvp5FozwnU4cA+9KtbaUJFMIh72Vzf8g8cmqfUeYfGN3M92HgwIE0DRJoN3h39
         8fJb979WEUbn8CQLlb75jmfdskaFd+v782VAoJqJaI3raUhjcv3u2GKlxo8PQnUtA7py
         CAd1OI6o1EMBC3SbYkGfc2HAar3Dcnm+JlLYqPWFM0fGoXgl87BxK+n7+V6TvwN9wDlX
         vOaa93QP+X3oSAGPtLFLQc/H1ZsIlvJRYT0PnbrrWrpaU7f4Zu1dDIZ7OnWst18jR/AO
         tl7SqbNqDWR7OuvOmVK+We3epy3JPbH4wbieJxqG+9Y9YBIWGRnYHZWWHYktMUZWUBqg
         NR2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=456bcQjEvXeW7l592fw/efzt1WDifEcQv/t51a2XAVk=;
        b=VneoLlWvCcMfbtsyYwZgPnDCi2JVk+bDTxEOpuB3Vqy7+9zbsO7EIJiP0u+2LWnlH9
         3fsnPeZLPdLWq25/vt6pbX0Il7J+aecm0Mcl3X5HOARi109Scp1Zg9X/sOGBB2sXU71o
         N3Vl4q+c+JDWoQkf61SF3PC8fHrpnvNxzpAUY5gGMkkWsRAWuJb3hdXBZUdozlD7ZulU
         RmQdjoNNoRs0ZfaxMmYe9EfuJA6CAj9z9OFXJWC1hOuwWuViNyIxLKmswKqnNpPPri1h
         bl/TyVun9Wg5Ddlw53lWjGUvZfk9AgcpWfJzvTo9bdO2B8yjEEuBNOF46JRwYmGMPMNR
         +rRw==
X-Gm-Message-State: APjAAAVTDHT2Fvo0ZAZZgbWRIj3fx8c+UIT4ZUSHUjYYyke5e/ZROe5n
        FXXO6OHEa+UDaMqKT+D6+v5SJVfNxhXKrBV1Y4A=
X-Google-Smtp-Source: APXvYqxOUtQDm00VkmggMzTk8BQupVwAasVIOG9mnVMUfroi7s24fsQDM6cNK6X2FZqrjNBKK6M2Ynm4Y8dOLwPmo74=
X-Received: by 2002:a17:906:594a:: with SMTP id g10mr3125824ejr.164.1573667285943;
 Wed, 13 Nov 2019 09:48:05 -0800 (PST)
MIME-Version: 1.0
References: <CA+h21hqte1sOefqVXKvSQ6N7WoTU3BH7qKpq3C7pieaqSB6AFg@mail.gmail.com>
 <20191113165300.GC27785@lunn.ch>
In-Reply-To: <20191113165300.GC27785@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 13 Nov 2019 19:47:54 +0200
Message-ID: <CA+h21hqLoRFpgcRHOciAFPSTzQQ1U5-k-yE=dq-LTwjaa2dY7Q@mail.gmail.com>
Subject: Re: Offloading DSA taggers to hardware
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, 13 Nov 2019 at 18:53, Andrew Lunn <andrew@lunn.ch> wrote:
>
> Hi Vladimir
>
> I've not seen any hardware that can do this. There is an
> Atheros/Qualcom integrated SoC/Switch where the 'header' is actually
> just a field in the transmit/receive descriptor. There is an out of
> tree driver for it, and the tag driver is very minimal. But clearly
> this only works for integrated systems.
>

What is this Atheros SoC?
It is funny that the topic reminded you of it. Your line of reasoning
probably was: "Atheros pushed this idea so far that they omitted the
DSA frame tag altogether for their own CPU port/DSA master". Which
means that even if they try to use this "offloaded DSA tagger"
abstraction, it would slightly violate the main idea of an offload,
which is the fact that it's optional. What do you think?

> The other 'smart' features i've seen in NICs with respect to DSA is
> being able to do hardware checksums. Freescale FEC for example cannot
> figure out where the IP header is, because of the DSA header, and so
> cannot calculate IP/TCP/UDP checksums. Marvell, and i expect some
> other vendors of both MAC and switch devices, know about these
> headers, and can do checksumming.
>

Of course there are many more benefits that derive from more complete
frame parsing as well, for some reason my mind just stopped at QoS
when I wrote this email.

> I'm not even sure there are any NICs which can do GSO or LRO when
> there is a DSA header involved.
>
> In the direction CPU to switch, i think many of the QoS issues are
> higher up the stack. By the time the tagger is involved, all the queue
> discipline stuff has been done, and it really is time to send the
> frame. In the 'post buffer bloat world', the NICs hardware queue
> should be small, so QoS is not so relevant once you reach the TX
> queue. The real QoS issue i guess is that the slave interfaces have no
> idea they are sharing resources at the lowest level. So a high
> priority frames from slave 1 are not differentiated from best effort
> frames from slave 2. If we were serious about improving QoS, we need a
> meta scheduler across the slaves feeding the master interface in a QoS
> aware way.
>

Qdiscs on the DSA master are a good discussion to be had, but this
wasn't the main thing I wanted to bring up here.

> In the other direction, how much is the NIC really looking at QoS
> information on the receive path? Are you thinking RPS? I'm not sure
> any of the NICs commonly used today with DSA are actually multi-queue
> and do RPS.
>

Actually both DSA master drivers I've been using so far (gianfar,
enetc) register a number of RX queues equal to the number of cores. It
is possible to add ethtool --config-nfc rules to steer certain
priority traffic to its own CPU, but the keys need to be masked
according to where the QoS field in the DSA frame tag overlaps with
what the DSA master thinks it's looking at, aka DMAC, SMAC, EtherType,
etc. It's not pretty.

> Another aspect here might be, what Linux is doing with DSA is probably
> well past the silicon vendors expected use cases. None of the 'vendor
> crap' drivers i've seen for these SOHO class switches have the level
> of integration we have in Linux. We are pushing the limits of the
> host/switch interfaces much more then vendors do, and so silicon
> vendors are not so aware of the limits in these areas? But DSA is
> being successful, vendors are taking more notice of it, and maybe with
> time, the host/switch interface will improve. NICs might start
> supporting GSO/LRO when there is a DSA header involved? Multi-queue
> NICs become more popular in this class of hardware and RPS knows how
> to handle DSA headers. But my guess would be, it will be for a Marvell
> NIC paired with a Marvell Switch, Broadcom NIC paired with a Broadcom
> switch, etc. I doubt there will be cross vendor support.

...Atheros with Atheros... :)

Yes, that's kind of the angle I'm coming from, basically trying to
understand what a correct abstraction from Linux's perspective would
look like, and what is considered too much "tribalism". The DSA model
is attractive even for an integrated system because there is more
modularity in the design, but there are some clear optimizations that
can be made when the master+switch recipe is tightly controlled.

>
>         Andrew

Thanks,
-Vladimir
