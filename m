Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE4C4B9E74
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 12:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238753AbiBQLR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 06:17:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiBQLR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 06:17:27 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07F6E6852;
        Thu, 17 Feb 2022 03:17:12 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id t21so8989962edd.3;
        Thu, 17 Feb 2022 03:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=iAwAjreqNN5/7jHoMpNX4jUGyuVnstEZXc1OH4l/j5c=;
        b=lhfiVoPGt3+tB4No4NSpDLJVtciSQlPV5dhT6LQwEVEkTbfoBfpWpipBM68JyTi6t9
         UGwunu7m7G8CG4rD1mShcJckdIK+j5JT7wYesflHzswfLiueGHrkB5LDf18Y01lV56/Y
         GwNFhcSD2BCQoMKkTB3wJA/Vpz+h3hawYljGyHstx1bHle8qH7hEq6sSFKI4bJxcU3Oj
         +2eQKenpeRZMpk7CgVIKSGO8qHSyQOaxdky2U8yTw6Fp05Y8k5BYMrM1MiSiyKZxhmww
         wXX6YvTL49y5U7+SMzn3mLu0O3W+UtEP2ckobvRMOvOvG9goMKwFaRqrHrsKWYgXxsGL
         WkVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=iAwAjreqNN5/7jHoMpNX4jUGyuVnstEZXc1OH4l/j5c=;
        b=ZyU4H/C7kPnwxxdyqYluO+KePwfUKeuUQJtxbB3/TnjIQd2F4h2KQO6Byvm/XTKGUG
         B+bRAJ1aSlQCZMLC1Q+w/9j5CMbXJAVeQPUpFZS3z+rYYMfI5JtbcgxWi3/pZdRDTjID
         HbvYXqo9WM9oybM+sSU05VFBb0+m6PQMxf2wcFH3NztqiRXPz2llpTdktjYxqm3g3yE/
         qrcGyZMiAmPCoFiy2U8sO8lukqptYS5blre0KmtcO7QNHB4o4GiwV0c9/NRYc1GCkGkc
         w5QB+RtH33uaNFAHZKISQal3KA9ZqoqWqjiCOtTbOn+Q2wEP/D5GPzAwyuL5w/zY/Rj3
         6YTQ==
X-Gm-Message-State: AOAM533IYNFyuN/ZH3U1AXCgStr68HNxddwxRay3da7GxSfWxVxTHrTM
        KzFeJKjO7sb7S1IoJu+i2xk=
X-Google-Smtp-Source: ABdhPJz2scZzsYUbLdn8Zpj6keBiRjktQyQ00Bi93ld531lh2q8vzox/EPcsGbmiw98xj8i70Bz6jw==
X-Received: by 2002:a05:6402:51ca:b0:410:a0d1:c6e9 with SMTP id r10-20020a05640251ca00b00410a0d1c6e9mr2078396edd.200.1645096631004;
        Thu, 17 Feb 2022 03:17:11 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id h21sm2966464edt.26.2022.02.17.03.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 03:17:10 -0800 (PST)
Date:   Thu, 17 Feb 2022 13:17:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] net: dsa: realtek: rtl8365mb: serialize
 indirect PHY register access
Message-ID: <20220217111709.x5g6alnhz3njo4t2@skbuf>
References: <20220216160500.2341255-1-alvin@pqrs.dk>
 <20220216160500.2341255-3-alvin@pqrs.dk>
 <20220216233906.5dh67olhgfz7ji6o@skbuf>
 <874k4yrlcj.fsf@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <874k4yrlcj.fsf@bang-olufsen.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 07:41:32AM +0000, Alvin Šipraga wrote:
> Vladimir Oltean <olteanv@gmail.com> writes:
> 
> > On Wed, Feb 16, 2022 at 05:05:00PM +0100, Alvin Šipraga wrote:
> >> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> >> 
> >> Realtek switches in the rtl8365mb family can access the PHY registers of
> >> the internal PHYs via the switch registers. This method is called
> >> indirect access. At a high level, the indirect PHY register access
> >> method involves reading and writing some special switch registers in a
> >> particular sequence. This works for both SMI and MDIO connected
> >> switches.
> >> 
> >> Currently the rtl8365mb driver does not take any care to serialize the
> >> aforementioned access to the switch registers. In particular, it is
> >> permitted for other driver code to access other switch registers while
> >> the indirect PHY register access is ongoing. Locking is only done at the
> >> regmap level. This, however, is a bug: concurrent register access, even
> >> to unrelated switch registers, risks corrupting the PHY register value
> >> read back via the indirect access method described above.
> >> 
> >> Arınç reported that the switch sometimes returns nonsense data when
> >> reading the PHY registers. In particular, a value of 0 causes the
> >> kernel's PHY subsystem to think that the link is down, but since most
> >> reads return correct data, the link then flip-flops between up and down
> >> over a period of time.
> >> 
> >> The aforementioned bug can be readily observed by:
> >> 
> >>  1. Enabling ftrace events for regmap and mdio
> >>  2. Polling BSMR PHY register for a connected port;
> >>     it should always read the same (e.g. 0x79ed)
> >>  3. Wait for step 2 to give a different value
> >> 
> >> Example command for step 2:
> >> 
> >>     while true; do phytool read swp2/2/0x01; done
> >> 
> >> On my i.MX8MM, the above steps will yield a bogus value for the BSMR PHY
> >> register within a matter of seconds. The interleaved register access it
> >> then evident in the trace log:
> >> 
> >>  kworker/3:4-70      [003] .......  1927.139849: regmap_reg_write: ethernet-switch reg=1004 val=bd
> >>      phytool-16816   [002] .......  1927.139979: regmap_reg_read: ethernet-switch reg=1f01 val=0
> >>  kworker/3:4-70      [003] .......  1927.140381: regmap_reg_read: ethernet-switch reg=1005 val=0
> >>      phytool-16816   [002] .......  1927.140468: regmap_reg_read: ethernet-switch reg=1d15 val=a69
> >>  kworker/3:4-70      [003] .......  1927.140864: regmap_reg_read: ethernet-switch reg=1003 val=0
> >>      phytool-16816   [002] .......  1927.140955: regmap_reg_write: ethernet-switch reg=1f02 val=2041
> >>  kworker/3:4-70      [003] .......  1927.141390: regmap_reg_read: ethernet-switch reg=1002 val=0
> >>      phytool-16816   [002] .......  1927.141479: regmap_reg_write: ethernet-switch reg=1f00 val=1
> >>  kworker/3:4-70      [003] .......  1927.142311: regmap_reg_write: ethernet-switch reg=1004 val=be
> >>      phytool-16816   [002] .......  1927.142410: regmap_reg_read: ethernet-switch reg=1f01 val=0
> >>  kworker/3:4-70      [003] .......  1927.142534: regmap_reg_read: ethernet-switch reg=1005 val=0
> >>      phytool-16816   [002] .......  1927.142618: regmap_reg_read: ethernet-switch reg=1f04 val=0
> >>      phytool-16816   [002] .......  1927.142641: mdio_access: SMI-0 read  phy:0x02 reg:0x01 val:0x0000 <- ?!
> >>  kworker/3:4-70      [003] .......  1927.143037: regmap_reg_read: ethernet-switch reg=1001 val=0
> >>  kworker/3:4-70      [003] .......  1927.143133: regmap_reg_read: ethernet-switch reg=1000 val=2d89
> >>  kworker/3:4-70      [003] .......  1927.143213: regmap_reg_write: ethernet-switch reg=1004 val=be
> >>  kworker/3:4-70      [003] .......  1927.143291: regmap_reg_read: ethernet-switch reg=1005 val=0
> >>  kworker/3:4-70      [003] .......  1927.143368: regmap_reg_read: ethernet-switch reg=1003 val=0
> >>  kworker/3:4-70      [003] .......  1927.143443: regmap_reg_read: ethernet-switch reg=1002 val=6
> >> 
> >> The kworker here is polling MIB counters for stats, as evidenced by the
> >> register 0x1004 that we are writing to (RTL8365MB_MIB_ADDRESS_REG). This
> >> polling is performed every 3 seconds, but is just one example of such
> >> unsynchronized access.
> >> 
> >> Further investigation reveals the underlying problem: if we read from an
> >> arbitrary register A and this read coincides with the indirect access
> >> method in rtl8365mb_phy_ocp_read, then the final read from
> >> RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG will always return the value in
> >> register A. The value read back can be readily poisoned by repeatedly
> >> reading back the value of another register A via debugfs in a busy loop
> >> via the dd utility or similar.
> >> 
> >> This issue appears to be unique to the indirect PHY register access
> >> pattern. In particular, it does not seem to impact similar sequential
> >> register operations such MIB counter access.
> >> 
> >> To fix this problem, one must guard against exactly the scenario seen in
> >> the above trace. In particular, other parts of the driver using the
> >> regmap API must not be permitted to access the switch registers until
> >> the PHY register access is complete. Fix this by using the newly
> >> introduced "nolock" regmap in all PHY-related functions, and by aquiring
> >> the regmap mutex at the top level of the PHY register access callbacks.
> >> Although no issue has been observed with PHY register _writes_, this
> >> change also serializes the indirect access method there. This is done
> >> purely as a matter of convenience.
> >> 
> >> Fixes: 4af2950c50c8 ("net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC")
> >> Link: https://lore.kernel.org/netdev/CAJq09z5FCgG-+jVT7uxh1a-0CiiFsoKoHYsAWJtiKwv7LXKofQ@mail.gmail.com/
> >> Reported-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> >> Reported-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> >> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> >> ---
> >
> > This implementation where the indirect PHY access blocks out every other
> > register read and write is only justified if you can prove that you can
> > stuff just about any unrelated register read or write before
> > RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG, and this, in and of itself,
> > will poison what gets read back from RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG.
> 
> I (at least treied to) state that clearly here:
> 
> >> Further investigation reveals the underlying problem: if we read from an
> >> arbitrary register A and this read coincides with the indirect access
> >> method in rtl8365mb_phy_ocp_read, then the final read from
> >> RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG will always return the value in
> >> register A. The value read back can be readily poisoned by repeatedly
> >> reading back the value of another register A via debugfs in a busy loop
> >> via the dd utility or similar.
> 
> That is, I used regmap debugfs to spam reads of switch registers like,
> for example, this one:
> 
> #define RTL8365MB_CFG0_MAX_LEN_REG	0x088C
> 
> ... which controls the MTU of the switch. This is something we set up
> just once to be 0x600 and then it is never touched again. Now in the
> above example, let A = 0x088C. Spamming the read of A phytool command
> described above, I would expect to read a value 0x79c9 out of my BSMR
> PHY register with phytool. But in cases where the read of switch
> register A coincides with the indirect access procedure, I end up
> reading back 0x600 from the PHY register. This is specifically because
> the read of A (=0x600) then poisons the value in
> RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG (should be 0x79c9, but is
> 0x600).

Yes, well, that was a bit handwavy, you didn't mention any other
specific register, you just stated a rule which appeared to be inferred
from little evidence.

> > rtl8365mb_mib_counter_read() doesn't seem like a particularly good
> > example to prove this, since it appears to be an indirect access
> > procedure as well. Single register reads or writes would be ideal, like
> > RTL8365MB_CPU_CTRL_REG, artificially inserted into strategic places.
> > Ideally you wouldn't even have a DSA or MDIO or PHY driver running.
> 
> I hope it is clear from my above explanation that I did show this, if
> you agree that RTL8365MB_CFG0_MAX_LEN_REG is just as arbitrary as
> RTL8365MB_CPU_CTRL_REG.
> 
> What I meant to say here:
> 
> >> This issue appears to be unique to the indirect PHY register access
> >> pattern. In particular, it does not seem to impact similar sequential
> >> register operations such MIB counter access.
> 
> ... about MIB counter access (which is also indirect as you point out),
> is that it does _not_ suffer from the above problem. The way I checked
> this was with ethtool -S, while again spamming regmap_read of an
> unrelated switch register like CPU_CTRL or CFG0_MAX_LEN. In this case
> the counter values always seem sane, and I can't detect the poisoned
> value getting read back (like 0x600 in the above example).
> 
> > Just a simple kernel module with access to the regmap, and try to read
> > something known, like the PHY ID of one of the internal PHYs, via an
> > open-coded function. Then add extra regmap accesses and see what
> > corrupts the indirect PHY access procedure.
> 
> The switch is generally idle and I did my testing with the periodic MIB
> counter disabled, so I think what you describe is not far off from what
> I did. The only difference is that the switch was already configured and
> switching packets. I used ftrace events to verify the phenomenon.
> 
> If you are still not persuaded, just write me back here, and I will go
> ahead and implement such a test module. But it seems like you
> misunderstood my initial commit message, so perhaps I just need to
> rephrase it?

If the problem you've identified is correct, then this simple test
module would yield the exact same result, yet would eliminate beyond any
doubt the timing and other circumstantial factors, and you could also
do better testing of the PHY write sequence, and MIB counter reads.
And if simply inserting a stray register access in the middle of the PHY
read procedure doesn't produce the same result, this would be new
information. It shouldn't even be too hard to do.

> > Are Realtek aware of this and do they confirm the issue? Sounds like
> > erratum material to me, and a pretty severe one, at that. Alternatively,
> > we may simply not be understanding the hardware architecture, like for
> > example the fact that MIB indirect access and PHY indirect access may
> > share some common bus and must be sequential w.r.t. each other.
> 
> The thing is that Realtek's vendor driver takes a common lock around
> every public API call. One of those APIs is "read phy register" and
> there it will take a lock around the whole procedure. At the same time
> it will also take the same lock for something like "read switch MTU" or
> "read CPU tag position", etc. So I don't believe their driver will
> suffer from this issue.
> 
> In any case it was on my list to write them a mail about this, so let's
> see what they say.
> 
> Kind regards,
> Alvin

I have little to no problem with the workaround you've implemented, it's
just that extraordinary claims require extraordinary proof. Having a
standalone kernel module that can deterministically and not statistically
reproduce the bug would go a long way.
