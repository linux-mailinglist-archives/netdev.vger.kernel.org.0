Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFB04DC704
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 16:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442863AbfJROMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 10:12:41 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36308 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438273AbfJROMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 10:12:40 -0400
Received: by mail-ed1-f65.google.com with SMTP id h2so4684474edn.3;
        Fri, 18 Oct 2019 07:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RNsj5jTfJ3hdsySZjKTzG7SlPINZMvawdIUWtL5XXTo=;
        b=EkQBnCoi81yxBfICYUPAlaKGCFHnwqIk1ME52nUQROrIwAmBQinshdjHmn2eSp69KO
         Gy749HP3OdidnhaEZRofwAL7mYA6y5fgvXgSBTH234QeRkiIqiwmsTTrWm2CJhff4tWG
         JGvV13xdOk+o1CP85UZIzUFiKBGDjhryHuW4Xz7Q6wth5j2EdVROqWk93rQtI8IdeaYb
         3RkXh+HcDeB4AdGW6adSyUGZNa6uVgh4693/rTZRQ8pmZYB8g2O5sdMU738xHqE1iWzM
         Di/9R7SuysIV8z8F+L23GGoYo2DpAv9VBFXuQ0VSs35MWrFuE7S7W7ncqMXxO7FGrsXj
         Ou1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RNsj5jTfJ3hdsySZjKTzG7SlPINZMvawdIUWtL5XXTo=;
        b=avdS40dYRtm5FdXR6HImoVZmXtLCLPrijvFH5Mwd55+TzTuY3NeZwnG/I7npWznpvl
         /eTvcg/qJMdWBrgfsI9jXnv0ktSIilWmkiuO5g2t5U6opP4gI50sHiTZaqZlUkUJqyV0
         AJRzFTCkKf66qCoixdIIxdtG2x9vDr2BWF8WrcYx4nEb2bIOtOCfV4yaeKG1xps7coP5
         NEsmETOMOqoMLyhK6PmTCTAsQpGjG8LKZ+86N87hrwtkXwnX2kFkLGKZjcevo2zq/ziZ
         ZBfypKfoPbIf5jAezDkRv2Kcl5QszBgn7Ndfy94W4fgUiR0PHtaJkC4Vfe1WQNDTC2Lm
         iJpw==
X-Gm-Message-State: APjAAAVqiNM77KPAMo+zmm0wTc9ouy7E1NTuGL869g2MLcTqD0LF8/Fv
        bAhp9mYvOGHdR8LYbXi5qbgtarLlTugWnc31Pho=
X-Google-Smtp-Source: APXvYqwuwXnBrkvzcxEV09GnwLjInzn3HJzH3eydAD0eNnMlx6beLBIBh3gdAb5+w/RBkZBsh6y97Lfds+jJM1MBYyg=
X-Received: by 2002:a17:906:1fc8:: with SMTP id e8mr8916756ejt.86.1571407956660;
 Fri, 18 Oct 2019 07:12:36 -0700 (PDT)
MIME-Version: 1.0
References: <20191015224953.24199-1-f.fainelli@gmail.com> <20191015224953.24199-3-f.fainelli@gmail.com>
 <4feb3979-1d59-4ad3-b2f1-90d82cfbdf54@gmail.com> <c4244c9a-28cb-7e37-684d-64e6cdc89b67@gmail.com>
 <CA+h21hrLHe2n0OxJyCKTU0r7mSB1zK9ggP1-1TCednFN_0rXfg@mail.gmail.com>
 <20191018130121.GK4780@lunn.ch> <CA+h21hoPrwcgz-q=UROAu0PC=6JbKtbdPhJtZg5ge32_2xJ3TQ@mail.gmail.com>
 <20191018132316.GI25745@shell.armlinux.org.uk> <CA+h21hqVZ=LF3bQGtqFh4uMu6AhNFcrwQuUcEH-Fc1VrWku-eg@mail.gmail.com>
 <20191018135411.GJ25745@shell.armlinux.org.uk>
In-Reply-To: <20191018135411.GJ25745@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 18 Oct 2019 17:12:25 +0300
Message-ID: <CA+h21hrqRtxWp1c-8F-9qPPsYxA_w_B_131DRayLBd8xjpOzPg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: phy: Add ability to debug RGMII connections
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, cphealy@gmail.com,
        Jose Abreu <joabreu@synopsys.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 at 16:54, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Fri, Oct 18, 2019 at 04:37:55PM +0300, Vladimir Oltean wrote:
> > On Fri, 18 Oct 2019 at 16:23, Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Fri, Oct 18, 2019 at 04:09:30PM +0300, Vladimir Oltean wrote:
> > > > Hi Andrew,
> > > >
> > > > On Fri, 18 Oct 2019 at 16:01, Andrew Lunn <andrew@lunn.ch> wrote:
> > > > >
> > > > > > Well, that's the tricky part. You're sending a frame out, with no
> > > > > > guarantee you'll get the same frame back in. So I'm not sure that any
> > > > > > identifiers put inside the frame will survive.
> > > > > > How do the tests pan out for you? Do you actually get to trigger this
> > > > > > check? As I mentioned, my NIC drops the frames with bad FCS.
> > > > >
> > > > > My experience is, the NIC drops the frame and increments some the
> > > > > counter about bad FCS. I do very occasionally see a frame delivered,
> > > > > but i guess that is 1/65536 where the FCS just happens to be good by
> > > > > accident. So i think some other algorithm should be used which is
> > > > > unlikely to be good when the FCS is accidentally good, or just check
> > > > > the contents of the packet, you know what is should contain.
> > > > >
> > > > > Are there any NICs which don't do hardware FCS? Is that something we
> > > > > realistically need to consider?
> > > > >
> > > > > > Yes, but remember, nobody guarantees that a frame with DMAC
> > > > > > ff:ff:ff:ff:ff:ff on egress will still have it on its way back. Again,
> > > > > > this all depends on how you plan to manage the rx-all ethtool feature.
> > > > >
> > > > > Humm. Never heard that before. Are you saying some NICs rewrite the
> > > > > DMAN?
> > > > >
> > > >
> > > > I'm just trying to understand the circumstances under which this
> > > > kernel thread makes sense.
> > > > Checking for FCS validity means that the intention was to enable the
> > > > reception of frames with bad FCS.
> > > > Bad FCS after bad RGMII setup/hold times doesn't mean there's a small
> > > > guy in there who rewrites the checksum. It means that frame octets get
> > > > garbled. All octets are just as likely to get garbled, including the
> > > > SFD, preamble, DMAC, etc.
> > > > All I'm saying is that, if the intention of the patch is to actually
> > > > process the FCS of frames before and after, then it should actually
> > > > put the interface in promiscuous mode, so that frames with a
> > > > non-garbled SFD and preamble can still be received, even though their
> > > > DMAC was the one that got garbled.
> > >
> > > Isn't the point of this to see which RGMII setting results in a working
> > > setup?
> > >
> > > So, is it not true that what we're after is receiving a _correct_ frame
> > > that corresponds to the frame that was sent out?
> > >
> >
> > Only true if the MAC does not drop bad frames by itself. Then the FCS
> > check in the kernel thread is superfluous.
>
> If a MAC driver doesn't drop bad frames, then surely it's buggy, since
> there isn't (afaik) a way of marking a received skb with a FCS error.
> Therefore, forwarding frames with bad FCS into the Linux networking
> stack will allow the reception of bad frames as if they were good.
>
> All the network drivers I've looked at (and written), when encountering
> a packet with an error, update the statistic counters and drop the
> errored packet.
>
> Do you know of any that don't?
>

I don't think you are following the big picture of what I am saying. I
was trying to follow Florian's intention (first make sure I understand
it) and suggest that the FCS checking code in the patch he submitted
is not doing what it was intended to. I am getting apparent FCS
mismatches reported by the program, when I know full well that the MAC
I am testing on would have dropped those frames were they really
invalid.
We aren't saying anything in contradiction.

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

Thanks,
-Vladimir
