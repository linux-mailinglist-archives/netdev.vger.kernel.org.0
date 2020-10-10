Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF31E28A49A
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729814AbgJJXxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 19:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbgJJXxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 19:53:00 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E890C0613D0;
        Sat, 10 Oct 2020 16:53:00 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u19so14089258ion.3;
        Sat, 10 Oct 2020 16:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=9lGM+Re0Ub7caVpxLPeNO+zI3MM0mRL4Q0MdJTYkacM=;
        b=i+y6to2vyhB4CttsaMJifXch7YKW/8h3m5ATBZsBTk56EU7AbTdRnyberK+yfguPGK
         ciubDMutopoN+bs+WPmHiwvFX4dORWXen+pYPJ2CAqmiZKkbeih0X16InnSYIpc2dh72
         uTLxpOT9VaE8YFz31OZHJzne0YJfsy9WkmlM8VjySAf4YhyVETAUh4TBWbSixsPl2Jjt
         V7ZZbfDsKCajI+gTRsB5GkqXrsp51i2JAgEUwtpPD6Xb/j5M4z38U9IyWpDe4t8z2YvL
         CzTi4kwCl/lCOYg1gmmy0tlpcMg8AbHlIZD9SWq6v2Yq8Vt71G4rGkzaTeMTSSROHxdp
         FnIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=9lGM+Re0Ub7caVpxLPeNO+zI3MM0mRL4Q0MdJTYkacM=;
        b=AMeHJwen/rGNOvitspYJ56L5tMaNaQasy01YXir0mE/iwkTaoc+c+HKBrlquoGcCMx
         YAYKh+BysE5kxxMxHfRs4Nxftfqi9uOsAS7HO6HtHcWpud7AERgbklUP2GaH1RYY+PUZ
         TGXYzq0vi2zNCVJdMzQpbw39eFvvAmuqnV7ECqxrfr9teBYUUb260u9eLRnvd+8CenOX
         a+7qDy2Z8GuGBq74dNlKIByIgvy0X/aUZOY65ZbM3cyAoNPqCUdRnx9dclW4t0LF4sns
         7iaIbHRCc781I/d/ID/FLbBV+7gTkBd6/vQQIpl6hx7jaAzbZ9ymhosn/ALGX5PAQk5/
         Zt/g==
X-Gm-Message-State: AOAM530GeOV6m5IvODjQr1AYLvRTpDMei4LmiaoXtoIvzl3iBq+1ayem
        KiA7sQahqmr5QOjufT1wbo8=
X-Google-Smtp-Source: ABdhPJxp6xlUhN/+aMCa1o+nktTeydfnpAQ9EAFEmyMxZoMa18QOmAg43JdXvKfkxCQ4T2KN2DosSw==
X-Received: by 2002:a05:6638:2ad:: with SMTP id d13mr13702796jaq.89.1602373978784;
        Sat, 10 Oct 2020 16:52:58 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 126sm3355253ilc.14.2020.10.10.16.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 16:52:57 -0700 (PDT)
Date:   Sat, 10 Oct 2020 16:52:48 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        eyal.birger@gmail.com
Message-ID: <5f824950d4b24_1867f20894@john-XPS-13-9370.notmuch>
In-Reply-To: <20201010093212.374d1e68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
 <20201009093319.6140b322@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <5f80ccca63d9_ed74208f8@john-XPS-13-9370.notmuch>
 <20201009160010.4b299ac3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201010124402.606f2d37@carbon>
 <20201010093212.374d1e68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [PATCH bpf-next V3 0/6] bpf: New approach for BPF MTU handling
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Sat, 10 Oct 2020 12:44:02 +0200 Jesper Dangaard Brouer wrote:
> > > > > We will not be sprinkling validation checks across the drivers because
> > > > > some reconfiguration path may occasionally yield a bad packet, or it's
> > > > > hard to do something right with BPF.      
> > > > 
> > > > This is a driver bug then. As it stands today drivers may get hit with
> > > > skb with MTU greater than set MTU as best I can tell.    
> > > 
> > > You're talking about taking it from "maybe this can happen, but will
> > > still be at most jumbo" to "it's going to be very easy to trigger and
> > > length may be > MAX_U16".  
> > 
> > It is interesting that a misbehaving BPF program can easily trigger this.
> > Next week, I will looking writing such a BPF-prog and then test it on
> > the hardware I have avail in my testlab.
> 
> FWIW I took a quick swing at testing it with the HW I have and it did
> exactly what hardware should do. The TX unit entered an error state 
> and then the driver detected that and reset it a few seconds later.

Ths seems like the right thing to do in my opinion. If the
stack gives the NIC garbage entering error state and reset
sounds expected. Thanks for actually trying it by the way.

We might have come to different conclusions though from my side
the conclusion is, good nothing horrible happened no MTU check needed.
If the user spews garbage at the nic from the BPF program great it
gets dropped and causes the driver/nic to punish you a bit by staying
hung. Fix your BPF program.

Now if the nic hangs and doesn't ever come back I would care. But,
we have watchdog logic for this.

I don't really feel like we need to guard bad BPF programs from
doing dumb things, setting MTU in this case, but other things might
be nested vlans that wont fly, overwriting checksums, corrupting
mac headers, etc.

> 
> Hardware is almost always designed to behave like that. If some NIC
> actually cleanly drops over sized TX frames, I'd bet it's done in FW,
> or some other software piece.

Agree.

> 
> There was also a statement earlier in the thread that we can put a large
> frame on the wire and "let the switch drop it". I don't believe
> that's possible either (as I mentioned previously BPF could generate
> frames above jumbo size). My phy knowledge is very rudimentary and

I think that was something I said, what I meant is if the hardware
sent a jumbo frame to a switch with a 1500MRU set I would expect
the receiver to drop it. On the hardware side I would guess the
error is it doesn't fit in the receive buffer. I think if you sent
a very large frame, something much larger than 9k (without TSO), the
sender itself will hang or abort and reset just like above.

From what I've seen mostly the maximum receive frame size mirrors
the MTU because no one has an explicit MRU to configure.

> rusty but from what I heard Ethernet PHYs have a hard design limit on
> the length of a frame they can put of a wire (or pull from it), because
> of symbol encoding, electrical charges on the wire etc. reasons. There
> needs to be a bunch of idle symbols every now and then. And obviously
> if one actually manages to get a longer frame to the PHY it will fault,
> see above.

Yes, I've seen this before on some hardware.

> 
> > > > Generally I expect drivers use MTU to configure RX buffers not sure
> > > > how it is going to be used on TX side? Any examples? I just poked
> > > > around through the driver source to see and seems to confirm its
> > > > primarily for RX side configuration with some drivers throwing the
> > > > event down to the firmware for something that I can't see in the code?    
> > > 
> > > Right, but that could just be because nobody expects to get over sized
> > > frames from the stack.
> > > 
> > > We actively encourage drivers to remove paranoid checks. It's really
> > > not going to be a great experience for driver authors where they need
> > > to consult a list of things they should and shouldn't check.
> > > 
> > > If we want to do this, the driver interface must most definitely say 
> > > MRU and not MTU.  
> > 
> > What is MRU?
> 
> Max Receive Unit, Jesse and others have been talking about how we 
> should separate the TX config from RX config for drivers. Right now
> drivers configure RX filters based on the max transmission unit, 
> which is weird, and nobody is sure whether that's actually desired.

Agree. But, its a reasonable default I think. An explicit MRU would
be a nice addition.

> 
> > > > I'm not suggestiong sprinkling validation checks across the drivers.
> > > > I'm suggesting if the drivers hang we fix them.    
> > > 
> > > We both know the level of testing drivers get, it's unlikely this will
> > > be validated. It's packet of death waiting to happen. 
> > > 

We could write some selftests for driver writers to run? I think any
selftests we could provide would be welcome.

 ./test_bpf_driver eth0
  Test large frame
  Test small frame
  Test corrupted checksum
  ...

> > > And all this for what? Saving 2 cycles on a branch that will almost
> > > never be taken?  

2 cycles here and 2 cycles there .... plus complexity to think about
it. Eventually it all adds up. At the risk of entering bike shedding
territory maybe.

> > 
> > I do think it is risky not to do this simple MTU check in net-core.  I
> > also believe the overhead is very very low.  Hint, I'm basically just
> > moving the MTU check from one place to another.  (And last patch in
> > patchset is an optimization that inlines and save cycles when doing
> > these kind of MTU checks).
