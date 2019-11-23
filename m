Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 501851080CD
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 22:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfKWV33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 16:29:29 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38436 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKWV33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 16:29:29 -0500
Received: by mail-ed1-f67.google.com with SMTP id s10so9101237edi.5
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 13:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7b1oFSwBtIsiWWcUeaXSL0ob1vDgBSAHCpq1F3bkRZg=;
        b=qBTUXMALqrjTNqXTDADXxHauav+7L0HihTUZZraVqWyek5jO14508lJW3NiMxXx2zB
         +7kpAlQbYcJIbnQYVqbczVfYD88t5Ds8WW7cObZvS/zzibGmYYqsGYGfws+id6KWJxb/
         4LaKQ8xcdIu7gZxCVX9xWhVw5Ruus68SNJddHprPXI74+R+5c2Pj+UCtUI421DE/f+Jb
         pR8vJFIps9r7hDiZx+BBFl5AnAumDmTFlw8yA3ky9KbeBCMymjXaDZ/e+HfpwgCHB0Q0
         5bijaBZcJ+YDLepcwQXM6vHQKddlAbKtTLbfn0yH90bDKeKkD3Ut4gZgGaYkHlltJREj
         54UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7b1oFSwBtIsiWWcUeaXSL0ob1vDgBSAHCpq1F3bkRZg=;
        b=Ir891a7CorkK12z1LUPxjRGtSFvK737Lmql47ekLRcypHuAxD2oirJTPa5NK5+Eyh9
         UZeDs86KICZn8b9Q90cCONUAV2dQc2M8TxpkSEWekOMImwxBBIRLLjfp9AxJNT14o8th
         Hz35R4m0bDqSWVvypFL7TxBuF/QSJ3nkLvslaslucgoOWaAiAN0f3yEH1R2B0YM1VexH
         o+q28c/mt0AIFxQQj0n1Uhu835lAMQ28qWVrFpohlY2gJfuBlfIMqNmMYu9L8Vh0H/86
         PaEYm1UgyBY/OBiWcWRHdlSJVgBfG4RJ7WIjoJBeUtf/ac+2rqjI0e8epbEOJPhdcng1
         wxNA==
X-Gm-Message-State: APjAAAWM7YgfPI0WFu7UFhoI8fpW14YBe6Oj0jV19GAa+eH19p3SYp5N
        HaR3CmyoOIR8PFmll2nAFLR+7uSll+0elexyFig=
X-Google-Smtp-Source: APXvYqwX0nKspc+ay7RNe3mwy7+F5ukqUgTdyGuCzdZNW/Ta9DPr6diP57zHo4JwDX/jTmui1vWgiybBcGTcxAebLNs=
X-Received: by 2002:a50:9b10:: with SMTP id o16mr8808681edi.117.1574544567406;
 Sat, 23 Nov 2019 13:29:27 -0800 (PST)
MIME-Version: 1.0
References: <20191123194844.9508-1-olteanv@gmail.com> <20191123194844.9508-2-olteanv@gmail.com>
 <329f394b-9e6c-d3b0-dc3d-5e3707fa8dd7@gmail.com> <CA+h21hpcvGZavmSZK3KEjfKVDt6ySw2Fv42EVfp5HxbZoesSqg@mail.gmail.com>
 <9f344984-ef0c-fc57-d396-48d4c77e1954@gmail.com>
In-Reply-To: <9f344984-ef0c-fc57-d396-48d4c77e1954@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 23 Nov 2019 23:29:16 +0200
Message-ID: <CA+h21hrjCs1Y4XAWhn3mWTMXy=3TE3E5YjpsB6acnTpA6L902A@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: dsa: Configure the MTU for switch ports
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Nov 2019 at 23:14, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 11/23/2019 12:46 PM, Vladimir Oltean wrote:
> >
> > Correct. I was actually held back a bit while looking at Andrew's
> > patch dc0fe7d47f9f ("net: dsa: Set the master device's MTU to account
> > for DSA overheads") where he basically discarded errors, so that's the
> > approach I took too (thinking that some DSA masters would not have ops
> > for changing or reporting the MTU).
> >
> >> I had prepared a patch series with Murali doing nearly the same thing
> >> and targeting Broadcom switches nearly a year ago but since I never got
> >> feedback whether this worked properly for the use case he was after, I
> >> did not submit it since I did not need it personally and found it to be
> >> a nice can of worms.
> >>
> >
> > Nice, do you mind if I take your series instead then?
>
> Not at all, if it works, please go ahead, not sure how hard it is going
> to be to rebase.
>
> >
> >> Another thing that I had not gotten around testing was making sure that
> >> when a slave_dev gets enslaved as a bridge port member, that bridge MTU
> >> normalization would kick in and make sure that if you have say: port 0
> >> configured with MTU 1500 and port 1 configured with MTU 9000, the bridge
> >> would normalize to MTU 1500 as you would expect.
> >>
> >
> > Nope, that doesn't happen by default, at least in my implementation.
> > Is there code in the bridge core for it?
>
> net/bridge/br_if.c::br_mtu_auto_adjust() takes care of adjusting the
> bridge master device's MTU based on the minimum MTU of all ports within
> the bridge, but what it seems to be missing is ensuring that if bridge
> ports are enslaved, and those bridge ports happen to be part of the same
> switch id (similar decision path to setting skb->fwd_offload_mark), then
> the bridge port's MTU should also be auto adjusted. mlxsw also supports
> changing the MTU, so I am surprised this is not something they fixed
> already.
>

But then how would you even change a bridged interface's MTU? Delete
bridge, change MTU of all ports to same value, create bridge again?

> >
> >> https://github.com/ffainelli/linux/commits/dsa-mtu
> >>
> >> This should be a DSA switch fabric notifier IMHO because changing the
> >> MTU on an user port implies changing the MTU on every DSA port in
> >> between plus the CPU port. Your approach here works for the first
> >> upstream port, but not for the ones in between, and there can be more,
> >> as is common with the ZII devel Rev. B and C boards.
> >
> > Yes, correct. Your patch implements notifiers which is definitely
> > good. I don't have a cascaded setup to test yet (my Turris Mox was
> > supposed to arrive but for some reason it was returned to the seller
> > by the shipping company...).
>
> Andrew and Vivien may know whether it is possible to get you a ZII Devel
> rev. B or C since those have 3 switches in the fabric and have
> constituted nice test platforms. Not sure if there is a version with a
> CPU port that is Gigabit capable though.

Well, I've already ordered it again, this time with more expensive
shipping... Hopefully I got their hint right.

> --
> Florian
