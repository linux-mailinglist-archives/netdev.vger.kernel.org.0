Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24B4B31BAE
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 14:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfFAMHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 08:07:12 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46064 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfFAMHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 08:07:12 -0400
Received: by mail-ed1-f68.google.com with SMTP id f20so19023119edt.12;
        Sat, 01 Jun 2019 05:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v/1dgR8R4KPUnRWOObGMCnhpJN8HCuXuRSPEAAZVh/Q=;
        b=EKAku0AQ4DAoef2v9ZUtlvGNZ6X/c3OuGdNhUZ2ChWlC1VAr8FIZSXHNt6ngj5Rxhh
         KmGyDrXKjJanH2KJz4/qjWLTQ4S+0D8Q4nNyhJ+l0d1a/VAn6aMr84K5FSvfwbKgD8jd
         woi0l3SMDceDhkPg2ljBOwUVkorUaUjWRoBWUYY/9EMpLVyM9lPu/hJO16nuWcpjtgR3
         iYb/Xapcr2QS1tfHzgpLBKiR7ZhmkLlUFyoJzjZVibGGaIs2nE8SIlsrhYYMpVUv5w69
         ZBeLF9vPaiIcWckVyHNIuXJYcxQ93kUuUBpQCrgLaXmAvl85tifY4mlpSrzBO7pEfzPt
         7+ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v/1dgR8R4KPUnRWOObGMCnhpJN8HCuXuRSPEAAZVh/Q=;
        b=f/8W059CdDtYHFx16tfSEmn6+K6QMh1pyq6vnQfCiHnBEzsfFZJHCl2jG5dA2xf0vM
         J9heyhx6m3I+U0UDXpSHVLCin3EHu9lpF3IzyX5qSCkKtHP2z0KHQ2BsazMoA86h1bc8
         he76oMNXsuMZsnHEAPW/TtjPzcecG/0GObikqinHoti0wpHNGvS4m5qc9txpMsjgT5c6
         O3LtmvYRxL4m0B5nwUzaoYFHgWeNvkBeqCpLuI969pi1ZKNJaglOpf7U4anhZqm6iGJ4
         wxHCkil8C1Akt4DDzdyZTec1+rYh67NMvblGNWjhoRUq0xynuiAC6tHG7L/0Hk2ZnSqO
         mcHQ==
X-Gm-Message-State: APjAAAWd8Nl2R5R/Es3OGIJBVxnHoNlOjYL6kvZqwKzr7X4K1RQWu1rB
        3IZUnpIWQhrGdRRkiKS1dNfXrzPvhxHetUsh3Qw=
X-Google-Smtp-Source: APXvYqxJN71xBoJwAufBcKZ3S0D6alWut4d77EFvU604XKgk13n0hgAwW1VgSOIESFZ2W6P5LSbxPZs1ILsBXEfdJo0=
X-Received: by 2002:a17:906:1483:: with SMTP id x3mr13965430ejc.90.1559390830330;
 Sat, 01 Jun 2019 05:07:10 -0700 (PDT)
MIME-Version: 1.0
References: <CA+h21hrBwR4Sow7q0_rS1u2md1M4bSAJt8FO5+VLFiu9UGnvjA@mail.gmail.com>
 <20190531043417.6phscbpmo6krvxam@localhost> <CA+h21hp9DfW3wFy4YbHMU31rBHyrnUTdF4kKwX36h9vHOW2COw@mail.gmail.com>
 <20190531140841.j4f72rlojmaayqr5@localhost> <CA+h21hroywaij3gyO0u6v+GFVO2Fv_dP_a+L3oMGpQH8mQgJ5g@mail.gmail.com>
 <20190531151151.k3a2wdf5f334qmqh@localhost> <CA+h21hpHKbTc8toPZf0iprW1b4v6ErnRaSM=C6vk-GCiXM8NvA@mail.gmail.com>
 <20190531160909.jh43saqvichukv7p@localhost> <CA+h21hpVrVNJTFj4DHHV+zphs2MjyRO-XZsM3D-STra+BYYHtw@mail.gmail.com>
 <CA+h21houLC7TGJYQ28LxiUxyBE7ju2ZiRcUd41aGo_=uAhgVgQ@mail.gmail.com>
 <20190601050714.xylw5noxka7sa4p3@localhost> <CA+h21hr3+vUjS9_m=CtEbFeN9Bgxkg8b-4zuXSMnZXGtfUEOsQ@mail.gmail.com>
In-Reply-To: <CA+h21hr3+vUjS9_m=CtEbFeN9Bgxkg8b-4zuXSMnZXGtfUEOsQ@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 1 Jun 2019 15:06:59 +0300
Message-ID: <CA+h21hpoRFCKJZWxS3QwZO6fUHOd=aZDm2A9iqZ-7V9PxCPWVg@mail.gmail.com>
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

On Sat, 1 Jun 2019 at 13:31, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Sat, 1 Jun 2019 at 08:07, Richard Cochran <richardcochran@gmail.com> wrote:
> >
> > On Fri, May 31, 2019 at 09:12:03PM +0300, Vladimir Oltean wrote:
> > > It won't work unless I make changes to dsa_switch_rcv.
> >
> > Or to the tagging code.
> >
> > > Right now taggers can only return a pointer to the skb, or NULL, case
> > > in which DSA will free it.
> >
> > The tagger can re-write the skb.  Why not reform it into a PTP frame?
> > This clever trick is what the phyter does in hardware.  See dp83640.c.
> >
>
> I think you're missing the point here.
> If I dress the meta frame into a PTP frame (btw is there any
> preferable event message for this purpose?) then sure, I'll make
> dsa_skb_defer_rx_timestamp call my .port_rxtstamp and I can e.g. move
> my state machine there.
> The problem is that in the current DSA structure, I'll still have less
> timestampable frames waiting for a meta frame than meta frames
> themselves. This is because not all frames that the switch takes an RX
> timestamp for will make it to my .port_rxtstamp (in fact that is what
> my .can_timestamp patch changes). I can put the timestampable frame in
> a 1-entry wait queue which I'll deplete upon arrival of the first meta
> frame, but when I get meta frames and the wait queue is empty, it can
> mean multiple things: either DSA didn't care about this timestamp
> (ok), or the timestampable frame got reordered or dropped by the MAC,
> or what have you (not ok). So I can't exclude the possibility that the
> meta frame was holding a relevant timestamp.
> Sure, I can dress the meta frame into whatever the previous
> MAC-trapped frame was (PTP or not) and then I'll have .port_rxtstamp
> function see a 1-to-1 correspondence with meta frames in case
> everything works fine. But then I'll have non-PTP meta frames leaking
> up the stack...
>

Actually maybe this is exactly what you meant and I didn't think it through.
If RX timestamping is enabled, then I can just copy all MAC-trapped
frames to a private skb in a per-driver data structure, and have DSA
drop them.
Then when their meta frame arrives, I can just morph them into what
the previous frame was, just that now I'm also holding the partial
timestamp in skb->cb.
PTP frames will reconstruct the full timestamp without waiting for any
meta (they are the meta), while other MAC-trapped frames (STP etc)
will just carry a meaningless skb->cb when passed up the stack.
In retrospect, it would have been amazing if the switch gave me the
meta frames *before* the actual link-local frames that needed the
timestamp.

Thanks!
-Vladimir

> Regards,
> -Vladimir
>
> > Thanks,
> > Richard
