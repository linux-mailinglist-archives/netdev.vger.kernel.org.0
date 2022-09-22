Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8C65E6322
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 15:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiIVNFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 09:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiIVNFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 09:05:00 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819315A3FF
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 06:04:58 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bj12so20823385ejb.13
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 06:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=uEOfmRB4crXTZvpdQhiPMLUSAueLcjVVAWtCMAVcIzE=;
        b=el4inStQnu2DGHsiQ2FvI1tQvMDh/LuUmyQJ+meXt5nBzXwsHHirlLY5Gr0iaPC0lP
         A4j5pc80ovAiMfs48Avca7yuNRA66D17B7ILfwuRdUF/ZG1EZjjIkZW1zfk4ogd/de9D
         MTyYIzhd/QjD858exUGLmttOa5cUzzsQN+2WhvqC31p90Iu7VT3jam9tU3CzMOtfVG5z
         Qn9oqZRa18aN+HOiQJphE98ty+V8qbWdKlZVzYvjoaSd6MMIEjGEcCoHGf9lSvnE24sE
         Q6E3fe92LIKZYYQSda8+baaBX7qIezt3IRE7ALu9rRGGApFGG50CDMq/jzot4YPYYA6B
         APuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=uEOfmRB4crXTZvpdQhiPMLUSAueLcjVVAWtCMAVcIzE=;
        b=Sifq1/dac0vn+IvgmAWf+phRpRfBhNVOHznjN5D+Le6ydCQYfpYpq8NPiIECr7SsLr
         vyDQTL4vsOB8wVQilg2HGqnF75N/lHgmxM6URMALCnjHV/fQuXnifAIVx6GyOuJshICD
         FBk4EFVq3qre2QkGrcHgFNnGJ7m921fHVDiP37M1GkswmEecN8+ewoT74Sn5bxRafT06
         VQOLi9Z/VYe8hQQIrlqbZ8qwWr/9wpgkcvf+q4mOlf9huohx75O5jkKLyfmVatpqHEjA
         ZTcfP2jDN+77dga3xEub+i4OfBCVHsqnWHdZhdEEne/G0QupE+wXm6ZS5R/2UjQ7q94w
         0xyg==
X-Gm-Message-State: ACrzQf1MFYzdHWYIHR9IwmNdUr+QpZySXLOw50UbgSE0v6DLnUtI3On/
        r1BrXNLOfch5I8UXneBvnjM=
X-Google-Smtp-Source: AMsMyM7ybSz5BHx/WE2dn1HBhaXfz2VG6DKbgxaRp+qEkDQskVQvm1qCT65s9egCWF66BLEo9Fuz1g==
X-Received: by 2002:a17:907:7f1c:b0:77d:248:c1c3 with SMTP id qf28-20020a1709077f1c00b0077d0248c1c3mr2598308ejc.416.1663851896742;
        Thu, 22 Sep 2022 06:04:56 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id 17-20020a170906219100b0073d53f4e053sm2643848eju.104.2022.09.22.06.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 06:04:55 -0700 (PDT)
Date:   Thu, 22 Sep 2022 16:04:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
Subject: Re: [PATCH net-next v14 5/7] net: dsa: mv88e6xxx: rmu: Add
 functionality to get RMON
Message-ID: <20220922130452.v2yhykduhbpdw3mi@skbuf>
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919224924.yt7nzmr722a62rnl@skbuf>
 <aad1bfa6-e401-2301-2da2-f7d4f9f2798c@gmail.com>
 <20220920131053.24kwiy4hxdovlkxo@skbuf>
 <Yyoqx1+AqMlAqRMx@lunn.ch>
 <20220922114820.hexazc2do5yytsu2@skbuf>
 <YyxY7hLaX0twtThI@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyxY7hLaX0twtThI@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 02:45:34PM +0200, Andrew Lunn wrote:
> > > Doing MIB via RMU is a big gain, but i would also like normal register
> > > read and write to go via RMU, probably with some level of
> > > combining. Multiple writes can be combined into one RMU operation
> > > ending with a read. That should give us an mv88e6xxx_bus_ops which
> > > does RMU, and we can swap the bootstrap MDIO bus_ops for the RMU
> > > bus_ops.
> > 
> > At what level would the combining be done? I think the mv88e6xxx doesn't
> > really make use of bulk operations, C45 MDIO reads with post-increment,
> > that sort of thing. I could be wrong. And at some higher level, the
> > register read/write code should not diverge (too much), even if the
> > operation may be done over Ethernet or MDIO. So we need to find places
> > which actually make useful sense of bulk reads.
> 
> I was thinking within mv88e6xxx_read() and mv88e6xxx_write(). Keep a
> buffer for building requests. Each write call appends the write to the
> buffer and returns 0. A read call gets appended to the buffer and then
> executes the RMU. We probably also need to wrap the reg mutex, so that
> when it is released, any buffered writes get executed. If the RMU
> fails, we have all the information needed to do the same via MDIO.

Ah, so you want to make the mv88e6xxx_reg_unlock() become an implicit
write barrier.

That could work, but the trouble seems to be error propagation.
mv88e6xxx_write() will always return 0, the operation will be delayed
until the unlock, and mv88e6xxx_reg_unlock() does not return an error
code (why would it?).

> > But then, Mattias' code structure becomes inadequate. Currently we
> > serialize mv88e6xxx_master_state_change() with respect to bus accesses
> > via mv88e6xxx_reg_lock(). But if we permit RMU to run in parallel with
> > MDIO, we need a rwlock, such that multiple 'readers' of the conceptual
> > have_rmu() function can run in parallel with each other, and just
> > serialize with the RMU state changes (the 'writers').
> 
> I don't think we can allow RMU to run in parallel to MDIO. The reg
> lock will probably prevent that anyway.

Well, I was thinking the locking could get rearchitected, but it seems
you have bigger plans for it, so it becomes even more engrained in the
driver :)

> > > I am assuming here that RMU is reliable. The QCA8K driver currently
> > > falls back to MDIO if its inband function is attempted but fails.  I
> > > want to stress this part, lots of data packets and see if the RMU
> > > frames get dropped, or delayed too much causing failures.
> > 
> > I don't think you even have to stress it too much. Nothing prevents the
> > user from putting a policer on the DSA master which will randomly drop
> > responses. Or a shaper that will delay requests beyond the timeout.
> 
> That would be a self inflicted problem. But you are correct, we need
> to fall back to MDIO.

Here's one variation which is really not self inflicted. You have a 10G
CPU port, and 1G user ports. You use flow control on the DSA master to
avoid packet loss due to the 10G->1G rate adaptation. So the DSA master
goes periodically through states of TX congestion and holds back frames
until it goes away. This creates latency for packets in the TX queues,
including RMU requests, even if the RMU messages don't go to the
external ports. And even with a high skb->priority, you'd still need PFC
to avoid this problem. This can trip up the timeout timers we have for
RMU responses.

> This is one area we can experiment with. Maybe we can retry the
> operation via RMU a few times? Two retries for MIBs is still going to
> be a lot faster, if successful, compared to all the MDIO transactions
> for all the statistics. We can also add some fall back tracking
> logic. If RMU has failed for N times in a row, stop using it for 60
> seconds, etc. That might be something we can put into the DSA core,
> since it seems like a generic problem.

Or the driver might have a worker which periodically sends the GetID
message and tracks whether the switch responded. Maybe the rescheduling
intervals of that are dynamically adjusted based on feedback from
timeouts or successes of register reads/writes. In any case, now we're
starting to talk about really complex logic. And it's not clear how
effective any of these mechanisms would be against random and sporadic
timeouts rather than persistent issues.
