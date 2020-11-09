Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEBC2AB44C
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 11:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729243AbgKIKEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 05:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728016AbgKIKEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 05:04:02 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16980C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 02:04:02 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id n12so9177590ioc.2
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 02:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=79QUVZRSSk7lYa1JaI31tUrKqJZEnH1ARVLllhGq6P0=;
        b=TCY2RB1yu/2Jpp28cFdFjklXz0UsEwmPGOJul/oeUsQFEqRWLEtlMSBSzu7dXejfhp
         J4VdbjwNefv4VQ/vWDTrGjDtJujbhsfYM4efDxwx9C/6nkmY1uEKVvN4mBR/DEnJ92BK
         rEx0nsNIFSNiPSSX7ASC2TXaulhOXUrYd5XKWNItaxZW5DpA/5h4ZfsuDZZGFX3nrqBK
         +jyNX2QPfB0Dd+LzsGkySzcEcMCQhyFQzefcYq57tYOzP82JbfU3U7JScTymPPRg0SVk
         5t2iolLAIaiFWAL99On+7KgMxR//2QKK3dvSTDOooFrQfJnNwb9ENcZTtEIDyg4zu/pP
         KYfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=79QUVZRSSk7lYa1JaI31tUrKqJZEnH1ARVLllhGq6P0=;
        b=EVuF4icsDe/Q7ROYnx/YNtDUOIOZnzU9f98L8PkD4AHWS5ZVDZiAebX3JAFjgkta5x
         yaX5s3JYd+juH2LhHwsLAAdWWW0twws1Y30f3o8fIjtojT7S1NpMTFhxYaTyf6esu2YA
         ptkF6qdaQZvrsK3TsP4qDWiAPe9Vnj1Kh/2AzEHHQIa1uqEkkjp3f1t36ZDVf7+CcG+O
         wSSNwPVTiOltCOsistsF0LJtX7DXzLuVZWPcbiFtfsl5klFuHTDOHHUYHy6iHpRjHihw
         6psHeXqRG8X6+ry1zKV8aFrmxToSEGaSru2BV9+JeB05CmOigZcAorprzgWIxtrGxLjp
         yRFA==
X-Gm-Message-State: AOAM531/aFNGLdutLadgwtXxLNkxWcbfhPKxJ5rnPkD7QAi278Nhy2KQ
        wpAJeupFKAh7lfXlJuFRqc7LOCfNuexsEZutkHTbKoN1NZdLKw==
X-Google-Smtp-Source: ABdhPJxaRZ2bQGpgRz+6fagxvGqVG3DIq943nryGrBgLPsHfxwPXFTLNPXGa1Zq1h3+/Fm48c2iEfn0gESm7U/imO4o=
X-Received: by 2002:a02:cf28:: with SMTP id s8mr10008698jar.11.1604916241338;
 Mon, 09 Nov 2020 02:04:01 -0800 (PST)
MIME-Version: 1.0
References: <1603850163-4563-1-git-send-email-i@liuyulong.me>
 <1604303803-30660-1-git-send-email-i@liuyulong.me> <20201103130559.0335c353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201107103950.70cf9353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <16803.1604871426@famine>
In-Reply-To: <16803.1604871426@famine>
From:   LIU Yulong <liuyulong.xa@gmail.com>
Date:   Mon, 9 Nov 2020 18:03:50 +0800
Message-ID: <CANp3m6nsYyPeoTqSv_EvUawPAVVsMXr3ek16VGKnzRzejyb2CQ@mail.gmail.com>
Subject: Re: [PATCH v2] net: bonding: alb disable balance for IPv6 multicast
 related mac
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        LIU Yulong <i@liuyulong.me>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes, the 33:33:ff:00:00:01 is just an example, the destination MAC address
can be various. The code of current solution is simple but indeed may need
have more attentions on the real world topologys.

The current solution refers to the action of ARP protocol in IPv4 [1].
While the IPv4 diabled the ARP tx balance, for the IPv6 we disable
the all-nodes multicast [2] (when there are no multicast domain, it
can be considered as all, aka broadcast [3]). But please note, the
MAC "33:33:00:00:00:01" for IPv6 RA (Router Advertisement) destination.

I have an alternative which is to verify the packet type, if it is the
ICMPv6 and the type is 135(Neighbor Solicitation), we disable the tx
balance. A new if-conditon will be added right below the all-nodes
multicast check.

[1] https://github.com/torvalds/linux/blob/master/drivers/net/bonding/bond_alb.c#L1423
[2] https://github.com/torvalds/linux/blob/master/drivers/net/bonding/bond_alb.c#L1431
[3] https://en.wikipedia.org/wiki/Solicited-node_multicast_address

On Mon, Nov 9, 2020 at 5:37 AM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>
> Jakub Kicinski <kuba@kernel.org> wrote:
>
> >On Tue, 3 Nov 2020 13:05:59 -0800 Jakub Kicinski wrote:
> >> On Mon,  2 Nov 2020 15:56:43 +0800 LIU Yulong wrote:
> >> > According to the RFC 2464 [1] the prefix "33:33:xx:xx:xx:xx" is defined to
> >> > construct the multicast destination MAC address for IPv6 multicast traffic.
> >> > The NDP (Neighbor Discovery Protocol for IPv6)[2] will comply with such
> >> > rule. The work steps [6] are:
> >> >   *) Let's assume a destination address of 2001:db8:1:1::1.
> >> >   *) This is mapped into the "Solicited Node Multicast Address" (SNMA)
> >> >      format of ff02::1:ffXX:XXXX.
> >> >   *) The XX:XXXX represent the last 24 bits of the SNMA, and are derived
> >> >      directly from the last 24 bits of the destination address.
> >> >   *) Resulting in a SNMA ff02::1:ff00:0001, or ff02::1:ff00:1.
> >> >   *) This, being a multicast address, can be mapped to a multicast MAC
> >> >      address, using the format 33-33-XX-XX-XX-XX
> >> >   *) Resulting in 33-33-ff-00-00-01.
> >> >   *) This is a MAC address that is only being listened for by nodes
> >> >      sharing the same last 24 bits.
> >> >   *) In other words, while there is a chance for a "address collision",
> >> >      it is a vast improvement over ARP's guaranteed "collision".
> >> > Kernel related code can be found at [3][4][5].
> >>
> >> Please make sure you keep maintainers CCed on your postings, adding bond
> >> maintainers now.
> >
> >Looks like no reviews are coming in, so I had a closer look.
> >
> >It's concerning that we'll disable load balancing for all IPv6 multicast
> >addresses now. AFAIU you're only concerned about 33:33:ff:00:00:01, can
> >we not compare against that?
>
>         It's not fixed as 33:33:ff:00:00:01, that's just the example.
> The first two octets are fixed as 33:33, and the remaining four are
> derived from the SNMA, which in turn comes from the destination IPv6
> address.
>
>         I can't decide if this is genuinely a reasonable change overall,
> or if the described topology is simply untenable in the environment that
> the balance-alb mode creates.  My specific concern is that the alb mode
> will periodically rebalance its TX load, so outgoing traffic will
> migrate from one bond port to another from time to time.  It's unclear
> to me how the described topology that's broken by the multicast traffic
> being TX balanced is not also broken by the alb TX side rebalances.
>
>         -J
>
> >The way the comparison is written now it does a single 64bit comparison
> >per address, so it's the same number of instructions to compare the top
> >two bytes or two full addresses.
>
>
> ---
>         -Jay Vosburgh, jay.vosburgh@canonical.com
