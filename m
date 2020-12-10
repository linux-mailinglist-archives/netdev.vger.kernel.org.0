Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91D92D5814
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 11:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgLJKSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 05:18:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbgLJKSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 05:18:50 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC72C0613CF
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 02:18:09 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id q8so6019382ljc.12
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 02:18:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Rvdg4hJ7+GP5Vdnh1hQ5+85zB3D89d3ykhe2T+SC1Z0=;
        b=xGkt0om4bJqBJ8j+28VgqR6HDCIFCy81+UcdBK7NJ1VzhLCq8kDkIw3G6cPWF7vofN
         cp5u4ZE1tMjWIqlkKL8RpeiC0Os1YtWTLk02JU0RMpr2t949+U9RU3V6fOW5gLfSsa8z
         9ij9NAkqVhqS1HhIAjLHOoDkWtEdWKsdwjnBM3+FX+kQVQofPXOITN0ZTxbGwmBni+QT
         w1O8X+eIvzVYRotM3csxSHH7yJDaFDA3ry8a1iXAE5ISE4LEQO7Cxk6gFoFwVg4Xlo1T
         GXJXFnmUnuGCADIvOK+gAFEMj2CI1LXdzS/IQOHR3sa6M0j4XUDt5qjXhpbGUBjDIoln
         4JTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Rvdg4hJ7+GP5Vdnh1hQ5+85zB3D89d3ykhe2T+SC1Z0=;
        b=a02aS7oaKLsdEXLOM/cVm75Dx98Wjd/NEs/XplhM0qwa5Tu9IBvM+9pKVcIF5S8p/0
         WQRax8x2/VoMtO5YBvuEd013l5APCqMwvbJMJlk0C6OTVuTND7/6umljK4BZjhJZ3xor
         OPFdCXNFcmoih885WCr2nQ7u9rklgDmfDbAM1pZ6/3nDf+Axr/r8cE/Jp9emFjXY15s8
         2F96Vu2i0OnbKSz9T0RT6zIB94xi3VDAE3wMZ3J5xkAPrSkdOk0jMhKBsd+p1/HLNuPO
         gqhKV5R1cbzfavHnOfar1Wu/CwIOJmLmXPvKlnmfwJ9arDMhGJWAN3P17u0p3x8LvaM9
         7FDQ==
X-Gm-Message-State: AOAM530AbLoXj/bzz5B3NeBc2T8cgU+1Dqa+mpXBtK6XbHy0THAmi6zh
        tSCL/GPfEUpPJieMalAf4iie9yeQqoALYooS
X-Google-Smtp-Source: ABdhPJzfh8K2sOGSZZ7fNzHn7bqZzRq9D8sMFQ40WZgM50FDh8ml6QK6N6/DYe65y1CszPI+KnTRsw==
X-Received: by 2002:a2e:b006:: with SMTP id y6mr2795964ljk.366.1607595487806;
        Thu, 10 Dec 2020 02:18:07 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id g8sm464543lfb.223.2020.12.10.02.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 02:18:06 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201209222103.zsisvbqaa7i2rl7k@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-3-tobias@waldekranz.com> <20201208112350.kuvlaxqto37igczk@skbuf> <87mtyo5n40.fsf@waldekranz.com> <20201208163751.4c73gkdmy4byv3rp@skbuf> <87k0tr5q98.fsf@waldekranz.com> <20201209105326.boulnhj5hoaooppz@skbuf> <87eejz5asi.fsf@waldekranz.com> <20201209160440.evuv26c7cnkqdb22@skbuf> <878sa663m2.fsf@waldekranz.com> <20201209222103.zsisvbqaa7i2rl7k@skbuf>
Date:   Thu, 10 Dec 2020 11:18:06 +0100
Message-ID: <875z5a55i9.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 00:21, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Dec 09, 2020 at 11:01:25PM +0100, Tobias Waldekranz wrote:
>> It is not the Fibonacci sequence or anything, it is an integer in the
>> range 0..num_lags-1. I realize that some hardware probably allocate IDs
>> from some shared (and thus possibly non-contiguous) pool. Maybe ocelot
>> works like that. But it seems reasonable to think that at least some
>> other drivers could make use of a linear range.
>
> In the ocelot RFC patches that I've sent to the list yesterday, you
> could see that the ports within the same bond must have the same logical
> port ID (as opposed to regular mode, when each port has a logical ID
> equal to its physical ID, i.e. swp0 -> 0, swp1 -> 1, etc). We can't use
> the contiguous LAG ID assignment that you do in DSA, because maybe we
> have swp1 and swp2 in a bond, and the LAG ID you give that bond is 0.
> But if we assign logical port ID 0 to physical ports 1 and 2, then we
> end up also bonding with swp0... So what is done in ocelot is that the
> LAG ID is derived from the index of the first port that is part of the
> bond, and the logical port IDs are all assigned to that value. It's
> really simple when you think about it. It would have probably been the
> same for Marvell too if it weren't for that cross-chip thing.
>
> If I were to take a look at Florian's b53-bond branch, I do see that
> Broadcom switches also expect a contiguous range of LAG IDs:
> https://github.com/ffainelli/linux/tree/b53-bond
>
> So ok, maybe ocelot is in the minority. Not an issue. If you add that
> lookup table in the DSA layer, then you could get your linear "LAG ID"
> by searching through it using the struct net_device *bond as key.
> Drivers which don't need this linear array will just not use it.

Great, I can work with that.

>> > I think that there is a low practical risk that the assumption will not
>> > hold true basically forever. But I also see why you might like your
>> > approach more. Maybe Vivien, Andrew, Florian could also chime in and we
>> > can see if struct dsa_lag "bothers" anybody else except me (bothers in
>> > the sense that it's an unnecessary complication to hold in DSA). We
>> > could, of course, also take the middle ground, which would be to keep
>> > the 16-entry array of bonding net_device pointers in DSA, and you could
>> > still call your dsa_lag_dev_by_id() and pretend it's generic, and that
>> > would just look up that table. Even with this middle ground, we are
>> > getting rid of the port lists and of the reference counting, which is
>> > still a welcome simplification in my book.
>>
>> Yeah I agree that we can trim it down to just the array. Going beyond
>> that point, i.e. doing something like how sja1105 works, is more painful
>> but possible if Andrew can live with it.
>
> I did not get the reference to sja1105 here. That does not support
> bonding offload, but does work properly with software bridging thanks to
> your patches.

Yeah sorry, I should have explained that better.

I meant in the sense that it shares information between the tagger and
the driver (struct sja1105_tagger_data).
