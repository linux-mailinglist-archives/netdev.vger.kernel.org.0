Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E99F61AE
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 22:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfKIV5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 16:57:03 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34965 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbfKIV5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 16:57:03 -0500
Received: by mail-ed1-f68.google.com with SMTP id r16so8997571edq.2;
        Sat, 09 Nov 2019 13:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8zojunifusLfr1jEnEqSjmYR20WZ1fEsNzo7A4tHyP4=;
        b=uAilhEvmsunwlRYaO8NewWUlIBVMw9lqI/EQoAycrXedwuMCAqhuSLshlMW/1fGKbA
         C9EzYTZSNQA+3MoUraoCugy+J5rvKXP5Q90uJ3IiZpH58io+0eLHHVVq5d7at6ypub1d
         flbu6krRuXsXKgzvMqB6u78dkyVAQZP5K1aU9YVbfkG2P9Z++3tTisQ2Q3u9LhX6yHco
         cu5+EOglOgLAPV0bV7eljtIeZRF9Bdb5enl/yynRw7r2ELYl8xJ7aaAFcqyEOty+hwAc
         58LEmr/ASPEqdgz1Avh6qqdUJpVg6sLB/bmkaeZ9m53/OBY8kdX8S1TCjtI1emBvYL0T
         Py/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8zojunifusLfr1jEnEqSjmYR20WZ1fEsNzo7A4tHyP4=;
        b=RBHRaV43Gw6FQjxAfSUNFVIKgF3Uf7UQuHQxgbOjdOG+y/SZiKKVNceDiydUgCqnd2
         D0VCHI3hos0nbhC1dun5NfXgVGZbVyKsLfkZKfV3r4jSjU/1Sdi2FBHn7tAYh0csLLdz
         gUeDukTFny7ad4vKJ+fYbhKd3B6Q0+4AJZxW2YJwjp7JRcgZaJfZWMSeTRxjKZAtJJVl
         xJetbn7N+bn+d8R2ovrlT28BqBH0O2k4XFxzc+J9OJ+THjRUrYSUJKokpYl//3T2L45B
         xc9s9KkX0hDlezlr+bTpzrmmiKYyEyB0tzWvfn+rLB+hEzdLQxu43QttNDpDlS4vFMGx
         h0CQ==
X-Gm-Message-State: APjAAAXVUGyIpTeE+JhqBaOV/PMsMoiHJWKA8fb8hE20LL4wcP6Ld2Gr
        kZkkbT0AwSc/BIMciZfG9eCfmce2YqACr4+Ms1A=
X-Google-Smtp-Source: APXvYqzN0POuwv56LXfez+H6xjZkYp5GeQpjPOMQc4iIa4vxocTm7F9V1LtTp49CZtcIduerqAiinNINZ7IzqarUkHk=
X-Received: by 2002:a17:906:3450:: with SMTP id d16mr3032396ejb.216.1573336620802;
 Sat, 09 Nov 2019 13:57:00 -0800 (PST)
MIME-Version: 1.0
References: <20191109105642.30700-1-olteanv@gmail.com> <20191109150953.GJ22978@lunn.ch>
 <CA+h21hoqkE2D03BHrFeU+STbK8pStRRFu+x7+9j2nwFf+EHJNg@mail.gmail.com>
 <393335751.FoSYQk3TTC@kongar> <20191109210549.GB12999@lunn.ch> <CA+h21hqU2bW82Q5jReEhsP6fhLTEgpcXuyU3EsdKFOgNrogoTQ@mail.gmail.com>
In-Reply-To: <CA+h21hqU2bW82Q5jReEhsP6fhLTEgpcXuyU3EsdKFOgNrogoTQ@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 9 Nov 2019 23:56:49 +0200
Message-ID: <CA+h21hpGvqLa_1DKXSWCZtP_LKtVQZsvQCTdWK_svyzjMSdZbg@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: ls1021a-tsn: Use interrupts for the SGMII PHYs
To:     Andrew Lunn <andrew@lunn.ch>,
        Alexander Stein <alexander.stein@mailbox.org>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, leoyang.li@nxp.com,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 Nov 2019 at 23:37, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Sat, 9 Nov 2019 at 23:05, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Sat, Nov 09, 2019 at 08:52:54PM +0100, Alexander Stein wrote:
> > >  On Saturday, November 9, 2019, 4:21:51 PM CET Vladimir Oltean wrote:
> > > > On 09/11/2019, Andrew Lunn <andrew@lunn.ch> wrote:
> > > > > On Sat, Nov 09, 2019 at 12:56:42PM +0200, Vladimir Oltean wrote:
> > > > >> On the LS1021A-TSN board, the 2 Atheros AR8031 PHYs for eth0 and eth1
> > > > >> have interrupt lines connected to the shared IRQ2_B LS1021A pin.
> > > > >>
> > > > >> The interrupts are active low, but the GICv2 controller does not support
> > > > >> active-low and falling-edge interrupts, so the only mode it can be
> > > > >> configured in is rising-edge.
> > > > >
> > > > > Hi Vladimir
> > > > >
> > > > > So how does this work? The rising edge would occur after the interrupt
> > > > > handler has completed? What triggers the interrupt handler?
> > > > >
> > > > >   Andrew
> > > > >
> > > >
> > > > Hi Andrew,
> > > >
> > > > I hope I am not terribly confused about this. I thought I am telling
> > > > the interrupt controller to raise an IRQ as a result of the
> > > > low-to-high transition of the electrical signal. Experimentation sure
> > > > seems to agree with me. So the IRQ is generated immediately _after_
> > > > the PHY has left the line in open drain and it got pulled up to Vdd.
> > >
> >
> > > It is correct GIC only supports raising edge and active-high. The
> > > IRQ[0:5] on ls1021a are a bit special though.  They not directly
> > > connected to GIC, but there is an optional inverter, enabled by
> > > default.
> >
> > Ah, O.K. So configuring for a rising edge is actually giving a falling
> > edge. Which is why it works.
> >
> > Actually supporting this correctly is going a cause some pain. I
> > wonder how many DT files currently say rising/active high, when in
> > fact falling/active low is actually being used? And when the IRQ
> > controller really does support active low and falling, things brake?
> >
> > Vladimir, since this is a shared interrupt, you really should use
> > active low here. Maybe the first step is to get control of the
> > inverter, and define a DT binding which is not going to break
> > backwards compatibility. And then wire up this interrupt.
> >
> >           Andrew
>
> Oh, ok, this is what you mean, thanks Alexander for the clarification.
> This sure escalated quickly and is going to keep me busy for a while.
>
> -Vladimir

Sorry, I'm still a bit in shock, since this hit me in the face from
nowhere, so I hadn't followed the entire history when I sent the above
email.
It looks after all that Kurt and Rasmus have picked this up again and
that the latest patch set is from 2 days ago, I'll take a look at
that...
https://lwn.net/Articles/804103/

Thanks,
-Vladimir
