Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6ED82F8A8A
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbhAPBm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbhAPBmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:42:55 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E76C061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:42:15 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id s26so15899946lfc.8
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=LokvxhZvGiEug/wEE6RQkpd36BMHBgVZOQFHN6xloGo=;
        b=SMgeXyY50aLC3mp1zUh+9iTtgEbcr9Ujhy/X2snTOdveXsW3ajoIPkOy2uSehfXq8+
         hW1K4elQ72IpSB6pNjT1eK3SSWtoK/molyVyg5mL/e7YfOKmHAlqNl81gkAvq2GDkXTh
         okg40b+G8uDEVMuqp7FXHD8UuFe4THjY9qH/cPhlHwD8UYIMY/ncrL1LXhEtDrAM5EQz
         CcrlRvVCJJLbyOIbSDgvcfba+aCwYmPHxO7t2uq9jWyPXBufYlLqLYywDFN5vSITrS3+
         UDTU8CjeVzWD7nJxMESVPvopoqP4mxTU1rqr8wzFm75UHLUbw9p04zlp04abI+F1e7Xz
         lOxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=LokvxhZvGiEug/wEE6RQkpd36BMHBgVZOQFHN6xloGo=;
        b=HfnEt9Z5jKVV5Ena0pjjpJm+xTJ3yXTKhJVrnM7aBD9mJVAYZCN0NoJPQLB5Q8rBO5
         SQDpnpbugCL/yhvzO/GvTiprcHLGp/nGBnUe8DdtRPehXASOuOGSLff2Ma+ymmDihpMi
         P+Zbrf64ePJUOYa5IJl1NL0G1OUAizrrGiBEeP0kXJs+Vdpwt66F1UsiI/7OpPoZ/KgC
         i6WCndjq4dZXkRlxFvaZFqv+10GT3/9RZ+p71Rf6AwAlu+VylfzAQ+edH68i/A7MbqPQ
         GV6wP55fjjf4HSnhQa/GicYQp4c3HMEM03TY/ZWroJy6XXknGH8TQQ+Qw7FOY91upsWS
         meXg==
X-Gm-Message-State: AOAM532Ih3YoZXbxQ4+NudJOj8HgSV7QWEgyQE9gaqeQROxNYdze4REP
        lCJFFJSUtcXu60SRb9KFXHsOSQ==
X-Google-Smtp-Source: ABdhPJzoZQFC92UzxtcVxLyGmxkMY1A41G4AARvJiKqAwPFHsSUVZHH0wwiv+Va8s1kM79vB6wGVMw==
X-Received: by 2002:ac2:5145:: with SMTP id q5mr6258033lfd.626.1610761333721;
        Fri, 15 Jan 2021 17:42:13 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id v10sm958325lji.130.2021.01.15.17.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:42:13 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Network Development <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: commit 4c7ea3c0791e (net: dsa: mv88e6xxx: disable SA learning for DSA and CPU ports)
In-Reply-To: <6106e3d5-31fc-388e-d4ac-c84ac0746a72@prevas.dk>
References: <6106e3d5-31fc-388e-d4ac-c84ac0746a72@prevas.dk>
Date:   Sat, 16 Jan 2021 02:42:12 +0100
Message-ID: <87h7nhlksr.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 14:49, Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
> Hi
>
> I've noticed something rather odd with my mv88e6250, which led me to the
> commit in the subject.
>
> First, the MAC address of the master device never seems to get learned
> (at least according to "mv88e6xxx_dump --atu"), so all packets destined
> for the machine gets flooded out all ports - which I can verify with
> wireshark. That is, I have three machines
>
> A --- B --- C
>
> with B being the board with an embedded mv88e6250, A pinging B, and C
> running wireshark - and it shows lots of "ping request (no response
> found)". Same if B pings A; the responses from A also get to C.
>
> But this is somewhat to be expected; automatic learning has been
> disabled by commit 4c7ea3c0791e (later commits have change the logic
> around there somewhat, but the end result is the same: the PAV for the
> cpu port being clear), and I can't find anywhere in the code which would
> manually add the master device's address to the ATU.
>
> However: Even when I do
>
> -	if (dsa_is_cpu_port(ds, port))
> +	if (dsa_is_cpu_port(ds, port) && 0)
>
> and verify with "mv88e6xxx_dump --ports" that the CPU port now has the
> expected value in port offset 0x0b:
>
> 0b 0001 0002 0004 0008 0010 0020 0040
>
> (it's port 5, i.e. the 0020 value), I still see the above behaviour -
> the master device's address doesn't get learned (nor does some garbage
> address appear in the ATU), and the unicast packets are still forwarded
> out all ports. So I must be missing something else.

The thing you are missing is that all packets from the CPU are sent with
FROM_CPU tags. SA learning is not performed on these as it intended for
control traffic.

Ideally, bulk traffic would be sent with a FORWARD tag. But there is
currently no way for the DSA tagger to discriminate the bulk data from
control traffic. And changing that is no small task.

In the mean time we could extend Vladimir's (added to CC) work on
assisted CPU port learning to include the local bridge addresses. You
pushed me to take a first stab at this :) Please have a look at this
series:

https://lore.kernel.org/netdev/20210116012515.3152-1-tobias@waldekranz.com/

> Finally, I'm wondering how the tagging could get in the way of learning
> the right address, given that the tag is inserted after the DA and SA.

Yes, but the CPU port is configured in DSA mode, so the switch will use
the tag command (FROM_CPU) to determine if learning should be done or
not.

> ====
>
> But this is all just some odd observations; the traffic does seem to
> work, though sending all unicast traffic to all neighbours seems to be a
> waste of bandwidth.
>
> What I'm _really_ trying to do is to get my mv88e6250 to participate in
> an MRP ring, which AFAICT will require that the master device's MAC gets
> added as a static entry in the ATU: Otherwise, when the ring goes from
> open to closed, I've seen the switch wrongly learn the node's own mac
> address as being in the direction of one of the normal ports, which
> obviously breaks all traffic. So if the topology is
>
>    M
>  /   \
> C1 *** C2
>
> with the link between C1 and C2 being broken, both M-C1 and M-C2 links
> are in forwarding (hence learning) state, so when the C1-C2 link gets
> reestablished, it will take at least one received test packet for M to
> decide to put one of the ports in blocking state - by which time the
> damage is done, and the ATU now has a broken entry for M's own mac address.

Well the static entry for the bridge MAC should be installed with the
aforementioned series applied. So that should not be an issue.

My guess is that MRP will still not work though, as you will probably
need the ability to trap certain groups to the CPU (management
entries). I.e. some MRP PDUs must be allowed to ingress on blocked
ports, no?
