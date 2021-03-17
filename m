Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B6C33FB49
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 23:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhCQWc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 18:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhCQWck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 18:32:40 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96608C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 15:32:39 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id a1so5177306ljp.2
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 15:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=gDMz0wq2RhJlWg1bok1h1MQxwPJnYBDibWmIkvsnVV0=;
        b=J/KGuS+hCjklRqq/KYBICvC59EYpBgwjfsIEsauSb2Jv87bIitexx4FjSeMYTBY5rY
         loBGjrdsT5+cMbpjhUH9SoSuqk2bxLY7/Gq5i8pnsPOBZ9HOujBPeAqIc1PMRa3bkQhc
         uE/3kXtxp7JVETlSM8MOCtiJJtxoHEPTqZlwzrdSduA73KBZO1Syrx80IdMlAoW2AGPD
         s6qjqymQNmYrdaiDNPTE0NgqQONJmfn4Phvx5JidDkVr05+qYx8wCD3HC+RT6giMzmGf
         BiJbpT5RwMtamQKg4W6BDVALvM9Cls9j8HbIAwL5yYIe623dfM/lZgLwunOqFYWxP3QA
         Gf2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=gDMz0wq2RhJlWg1bok1h1MQxwPJnYBDibWmIkvsnVV0=;
        b=DT+saJQrB+rMWujaID/WoWHcFKHmxSz+mtC6Om80gXOO6F4P1AC0XJeki/TetsTUIW
         mx4DRoBZvHxEHrWljV5nrwc6N3WZ3v0kt8oKnrOb0oJOj0mDxMN01bZwsaxTZcj5/XzS
         biM7M0xx4ZgrK4MurwrC+seAAIBrCqgMFWx0SgAz8t3/X3PgOw7iEJO5D1m3AKesg3sY
         4N8CBouOEQ8l4EETuhmarPn+ItWmrynmrJfbAfLj0kb30UwPGmu1DjeaQJ4Sep2Y+mxM
         xGO+PYF5XP98A31dAu02WFb/dpFE3tTFbGsP0jr+aMOQdjTbHIduHSfMfdlGEt/GR44g
         TClw==
X-Gm-Message-State: AOAM531xlGl1itztWIoAUpFKLD9R8dZ40P6+rKSZFVlDrd1Rr/aPaaKs
        TxLa0FWucQKfZaBFkF9+69FENPfB67Scr0o1
X-Google-Smtp-Source: ABdhPJxa0XpjNVnfSktTszR3Ckw44GV2b3YdMsBROrgP7nhb34IVmHKxhGpfB7OyrVLbKgBE/bVJIw==
X-Received: by 2002:a2e:a545:: with SMTP id e5mr3767308ljn.134.1616020357835;
        Wed, 17 Mar 2021 15:32:37 -0700 (PDT)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id h6sm12222lfd.77.2021.03.17.15.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 15:32:37 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] net: dsa: mv88e6xxx: Offload bridge learning flag
In-Reply-To: <20210317192929.qviweve6acjzrjcq@skbuf>
References: <20210315211400.2805330-1-tobias@waldekranz.com> <20210315211400.2805330-5-tobias@waldekranz.com> <20210317141224.ssll7nt64lqym3wg@skbuf> <87k0q5obz9.fsf@waldekranz.com> <20210317192929.qviweve6acjzrjcq@skbuf>
Date:   Wed, 17 Mar 2021 23:32:36 +0100
Message-ID: <87h7l9o1h7.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 21:29, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Mar 17, 2021 at 07:45:46PM +0100, Tobias Waldekranz wrote:
>> On Wed, Mar 17, 2021 at 16:12, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > On Mon, Mar 15, 2021 at 10:13:59PM +0100, Tobias Waldekranz wrote:
>> >> +	if (flags.mask & BR_LEARNING) {
>> >> +		u16 pav = (flags.val & BR_LEARNING) ? (1 << port) : 0;
>> >> +
>> >> +		err = mv88e6xxx_port_set_assoc_vector(chip, port, pav);
>> >> +		if (err)
>> >> +			goto out;
>> >> +	}
>> >> +
>> >
>> > If flags.val & BR_LEARNING is off, could you please call
>> > mv88e6xxx_port_fast_age too? This ensures that existing ATU entries that
>> > were automatically learned are purged.
>> 
>> This opened up another can of worms.
>> 
>> It turns out that the hardware is incapable of fast aging a LAG.
>
> You sound pretty definitive about it, do you know why?

The big note saying "Entries associated with a LAG cannot be moved or
removed using these commands" was the first clue :)

This is pure speculation on my part.

In the first iterations of this family of devices (before it was bought
by Marvell), cross-chip LAGs where not supported. You would simply set
multiple bits in the PAV for all LAG members to associate stations with
the LAG. In that scenario you can fast-age a LAG by fast-aging each
individual port.

Later, cross-chip LAGs where added, and enough support was bolted on to
the ATU to support automatic learning, but not enough to support
fast-aging.

>> I can see two workarounds. Both are awful in their own special ways:
>> 
>> 1. Iterate over all entries of all FIDs in the ATU, removing all
>>    matching dynamic entries. This will accomplish the same thing, but it
>>    is a very expensive operation, and having that in the control path of
>>    STP does not feel quite right.
>
> When does it ever feel right? :)
>
> I think of it like a faster 'bridge fdb' command (since 'bridge fdb'
> traverses the ATU super inefficiently, it dumps the whole table for each
> port).
>
> On my system with 24 mv88e6xxx ports, 'time bridge fdb' takes around 34
> seconds. So that means a 'slow age' will take around 1.4 seconds for a
> single LAG.

Well, it also scales linearly with the number of active entries in the
ATU. Here are some times for "bridge fdb" on my system with a single
6390X:

Entries    Time
      1   0.17s
     10   0.48s
    100   3.20s
    200   6.24s
   1000  31.82s

(I used trafgen to generate broadcasts with random SAs)

Then you have to consider that you are not simply walking the ATU, you
also have to write back entries whenever you come across one attached to
the LAG you are fast-aging.

> On the other hand, on my system with 7 sja1105 ports, I have no choice
> but to do slow ageing - the hardware simply doesn't have the concept of
> 'fast ageing'. There, 'time bridge fdb' returns 1.781s, so I expect a
> slow age would take around 0.25 seconds. Of course I'm not happy about
> it, but I think I'll bite the bullet.
>
>> 2. Flushing all dynamic entries in the entire ATU. Fast, but obviously
>>    results in a period of lots of flooded packets.
>
> This one seems like an overreaction to me. Would that even solve the
> problem? Couly you destroy and re-create the trunk?

It would make sure that no entries lingered on the port in question,
absolutely. Unfortunately that would also be true for all other ports :)

Adding/removing a LAG in hardware has no connection to ATU entries
unfortunately.

>> Any opinion on which approach you think would hurt less? Or, even
>> better, if there is a third way that I have missed.
>> 
>> For this series I am leaning towards making mv88e6xxx_port_fast_age a
>> no-op for LAG ports. We could then come back to this problem when we add
>> other LAG-related FDB operations like static FDB entries. Acceptable?
>
> Yeah, I guess that's fair.

Great. I will try to put together a v2 tomorrow.
