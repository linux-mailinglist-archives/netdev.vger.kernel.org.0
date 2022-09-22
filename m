Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEB65E61B4
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 13:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbiIVLsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 07:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbiIVLs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 07:48:28 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3E8CE0B
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 04:48:25 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id sb3so20397609ejb.9
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 04:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=/5VbOX6VjKEY3uXpOh3x1WlojWZNRRsEdYikBPAvXXw=;
        b=h2v6/ols/E3KjJXCnxKsB+LEy37nTAZMvD/OJcz0z1fhU9fp400LFaczt1ReiDGsM6
         eqNKmghOD6oE+w+GW7jRsq65RwaLOKD+U4By9OJKSa/LLesGeNRcgTBPMl+8UjwQiKT2
         OaUAjzkp9dLPdJb2BPvjW6S7vv788zPFXwG4p5NOyp3nGVxuOJ3tmcOKUVlVBKaqK+Qf
         DojL6DlFjp29TxJee1RHLNFC2LSigoehdzR53PBoZkNXfHUB81eh/diJabAb+KQVhZH1
         dQPQ94T5yjyiWUWnhERqTRWRjSaGnVHotvxZRoYrJGsCEnpmfQsG45TcLQHfYpYrPD7S
         NNMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=/5VbOX6VjKEY3uXpOh3x1WlojWZNRRsEdYikBPAvXXw=;
        b=V/8SzR44ZtesmwFgW2Cx8JfQLEFiJ4mHswJzhnJRRQ3Sia/8pBlKi8OfjNvHA1/G92
         vNGxFkd8jr82uvoGrd6gSLh8pvPRPR/Swh+5PiD0qAqZn/uVw+Y5W2AtbLa1cZnImRqb
         p6ymK1mI7FTY9zXWAOVuxV15x3wh5f8T0vLTfoKAtMwtCA5zUEOEiZE1RF5OAxcUskCS
         xsloU3cH5mRyLKcgrOT8HB5rm/yZ9vMTp7RCiBtx6fEogLUAol1oeoHA0wBN+/qgd9Sz
         Wx9bMXTgOKA9XtRxZmWxJtiIUn1j0xzcgoqzF1wjzw6fd61ZSyqv1wiiCu32YGwFuzin
         E3Rg==
X-Gm-Message-State: ACrzQf1WaDcsbMbAqDFhlviCaQ3Pgwv/ATFEQOOoxfCK+rlWJ+vr/UJO
        fXnmr31yb8K0WvyAqpnrTr0=
X-Google-Smtp-Source: AMsMyM6zuqvPAyAdbpq5i17CePp5f1bMrWLgioiNRRmXO89LiGu5v3uP6lBsj5WUYSiORwaoPj8tfw==
X-Received: by 2002:a17:907:1c92:b0:781:f9b2:2bed with SMTP id nb18-20020a1709071c9200b00781f9b22bedmr2395524ejc.47.1663847304052;
        Thu, 22 Sep 2022 04:48:24 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id f5-20020a056402004500b0044f1e64e9f4sm3440000edu.17.2022.09.22.04.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 04:48:22 -0700 (PDT)
Date:   Thu, 22 Sep 2022 14:48:20 +0300
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
Message-ID: <20220922114820.hexazc2do5yytsu2@skbuf>
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919224924.yt7nzmr722a62rnl@skbuf>
 <aad1bfa6-e401-2301-2da2-f7d4f9f2798c@gmail.com>
 <20220920131053.24kwiy4hxdovlkxo@skbuf>
 <Yyoqx1+AqMlAqRMx@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yyoqx1+AqMlAqRMx@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 11:04:07PM +0200, Andrew Lunn wrote:
> On Tue, Sep 20, 2022 at 04:10:53PM +0300, Vladimir Oltean wrote:
> > On Tue, Sep 20, 2022 at 02:26:22PM +0200, Mattias Forsblad wrote:
> > > This whole shebang was a suggestion from Andrew. I had a solution with
> > > mv88e6xxx_rmu_available in mv88e6xxx_get_ethtool_stats which he wasn't fond of.
> > > The mv88e6xxx_bus_ops is declared const and how am I to change the get_rmon
> > > member? I'm not really sure on how to solve this in a better way?
> > > Suggestions any? Maybe I've misunderstood his suggestion.
> > 
> > Can you point me to the beginning of that exact suggestion? I've removed
> > everything older than v10 from my inbox, since the flow of patches was
> > preventing me from seeing other emails.
> 
> What i want to do is avoid code like:
> 
>      if (have_rmu())
>      	foo()
>      else
> 	bar()
> 
> There is nothing common in the MDIO MIB code and the RMU MIB code,
> just the table of statistics. When we get to dumping the ATU, i also
> expect there will be little in common between the MDIO and the RMU
> functions.

Sorry, I don't understand what it is about "if (have_rmu()) foo() else bar()"
that you don't like. Isn't the indirection via bus_ops the exact same
thing, but expressed as an indirect function call rather than an if/else?

Or is it that the if/else structure precludes the calling of bar() when
foo() fails? The bus_ops will suffer from the same problem.

> Doing MIB via RMU is a big gain, but i would also like normal register
> read and write to go via RMU, probably with some level of
> combining. Multiple writes can be combined into one RMU operation
> ending with a read. That should give us an mv88e6xxx_bus_ops which
> does RMU, and we can swap the bootstrap MDIO bus_ops for the RMU
> bus_ops.

At what level would the combining be done? I think the mv88e6xxx doesn't
really make use of bulk operations, C45 MDIO reads with post-increment,
that sort of thing. I could be wrong. And at some higher level, the
register read/write code should not diverge (too much), even if the
operation may be done over Ethernet or MDIO. So we need to find places
which actually make useful sense of bulk reads.

> But how do we mix RMU MIB and ATU dumps into this? My idea was to make
> them additional members of mv88e6xxx_bus_ops. The MDIO bus_ops
> structures would end up call the mv88e6xxx_ops method for MIB or
> ATU. The rmu bus_ops and directly call an RMU function to do it.
> 
> What is messy at the moment is that we don't have register read/write
> via RMU, so we have some horrible hybrid. We should probably just
> implement simple read and write, without combining, so we can skip
> this hybrid.

I see in the manual that there are some registers which aren't
available or not recommended over RMU, for example the PHY registers if
the PPU is disabled, or phylink methods for the upstream facing ports.
There are also less obvious things, like accessing the PTP clock
gettime(). This will surely change the delay characteristic that phc2sys
sees, I'm not sure if for the better or for the worse, but the SMI code
at least had some tuning made to it, so people might care. So bottom
line, I'm not sure whether we do enough to prevent these pitfalls by
simply creating blanket replacements for all register reads/writes and
not inspecting whether the code is fine after we do that.

On the other hand, having RMU operations might also bring subtle
benefits to phc2sys. I think there were some issues with the PTP code
having trouble getting MDIO bus access (because of bridge fdb dumps or
some other things happening in the background). This may also be an
opportunity to have parallel access to independent IP blocks within the
switch, one goes through MDIO and the other through Ethernet.

But then, Mattias' code structure becomes inadequate. Currently we
serialize mv88e6xxx_master_state_change() with respect to bus accesses
via mv88e6xxx_reg_lock(). But if we permit RMU to run in parallel with
MDIO, we need a rwlock, such that multiple 'readers' of the conceptual
have_rmu() function can run in parallel with each other, and just
serialize with the RMU state changes (the 'writers').

> I am assuming here that RMU is reliable. The QCA8K driver currently
> falls back to MDIO if its inband function is attempted but fails.  I
> want to stress this part, lots of data packets and see if the RMU
> frames get dropped, or delayed too much causing failures.

I don't think you even have to stress it too much. Nothing prevents the
user from putting a policer on the DSA master which will randomly drop
responses. Or a shaper that will delay requests beyond the timeout.

> If we do see
> failures, is a couple of retires enough? Or do we need to fallback to
> MDIO which should always work? If we do need to fallback, this
> structure is not going to work too well.

Consider our previous discussion about the switchdev prepare/commit
transactional structure, where the commit stage is not supposed to fail
even if it writes to hardware. You said that the writes are supposed to
be reliable, or else. Either they all work or none do. Not sure how that
is going to hold up with a transport such as Ethernet which has such a
wide arsenal of foot guns. I think that leaving the MDIO fallback in is
inevitable.

In terms of retries, I'm not sure. With the qca8k code structure:

	if (have_rmu()) {
		ret = foo();
		if (ret == 0)
			return 0;
	}

	return bar();

we won't have retries for the _current_ operation, but all further
operations will still try to use Ethernet first. So here, it seems to me
that the timeout needs to be tuned such that everything does not grind
down to a halt even if we have a lossy Ethernet channel.

Otherwise, we need to build some more (perhaps too advanced) logic. Have
"if (have_rmu() && rmu_works())", periodically re-check if RMU works
after a failure, etc.
