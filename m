Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECB32C6D99
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 00:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731555AbgK0XUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 18:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730733AbgK0XTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 18:19:15 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCB2C0613D1
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 15:19:12 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id y7so7561661lji.8
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 15:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=YyxtZyY3olhrOmvyYsMKySk4ypeDQAr5pIX4lSkcNDE=;
        b=iheLnBaXKPANQfqCB0wuGDuHx2tzMoMQ/mNKTrDN6ji8op1mxVyL80+Pw6n9nM1Spt
         MECHLQR5Plb8vIPlWk0Kb7uW8REGZY/yI3rleW+/wIf5uIwVaLnLX5tCZcCd2TKwCGLm
         jYk6IOtqYXhW+GilExzyIhbwi6VcsxiyNC5RWtfpi3T5SuIfesoclWR92otJAl2JChf+
         KJSkdNFdvnlSsy31bI2GIoLskQv+1+OLFtueZkPMY5OjN/aZvb9lvRQTuByTXiD+mNnd
         s8aEIqexvXF762NFV+5QGtNZVD1v+3vlkRXcDY+RoJa93SMt/8qVn3Pl9d+gHWGTp1tp
         lHRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YyxtZyY3olhrOmvyYsMKySk4ypeDQAr5pIX4lSkcNDE=;
        b=nM+23aTPGWpvXXTCMorZMmvQJ1IOwpid5V2sbPVcUcX9yD5/0paycG3b0KCqxBVrfK
         BWUS7MTCaj/q35nctu/yN6cRymErsOpJx/Nyw39cNFXous/vyc8Tm9SbwJMOrSDS9iMN
         tyuqZgBLiwAz5My3rRveizKJKXTTrNriAG7rGqmoUZwrPx646ow5jMo2Lz1TsR2AzY6R
         pjzwR71t/FTSs3kVn+YUAvLGbMM2xcv52tseGuFQXR1epKniH+Dc8RWYrSbB70FVGQeu
         0L6+0edyfAUUmsl3Bt2p9yEGcSa41HNM2F9FkW6aLNTt7km89kl5J/PEIUXvTuIiGm66
         lwgQ==
X-Gm-Message-State: AOAM531LxxYambJIQCbe4s98mR/EfG0ydghXklw50oBQFsSmy8Jdxt64
        QnEySGUwurKuLJnGjIRDQbYv15G5cS4QZKqy
X-Google-Smtp-Source: ABdhPJzODd2v3HbX4L02+lzXSjHsX2rkNaQj9n571vljMqmTIud078z9jwn4/uU26kLGrgMFNnOE1Q==
X-Received: by 2002:a2e:8989:: with SMTP id c9mr4291594lji.26.1606519150458;
        Fri, 27 Nov 2020 15:19:10 -0800 (PST)
Received: from wkz-x280 (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id p15sm861381lfc.37.2020.11.27.15.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 15:19:09 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, olteanv@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201127162818.GT2073444@lunn.ch>
References: <20201119144508.29468-1-tobias@waldekranz.com> <20201119144508.29468-3-tobias@waldekranz.com> <20201120003009.GW1804098@lunn.ch> <5e2d23da-7107-e45e-0ab3-72269d7b6b24@gmail.com> <20201120133050.GF1804098@lunn.ch> <87v9dr925a.fsf@waldekranz.com> <20201126225753.GP2075216@lunn.ch> <87r1of88dp.fsf@waldekranz.com> <20201127162818.GT2073444@lunn.ch>
Date:   Sat, 28 Nov 2020 00:19:08 +0100
Message-ID: <87lfem8k2b.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 17:28, Andrew Lunn <andrew@lunn.ch> wrote:
>> This is a digression, but I really do not get this shift from using
>> BUG()s to WARN()s in the kernel when you detect a violated invariant. It
>> smells of "On Error Resume Next" to me.
>
> A WARN() gives you a chance to actually use the machine to collect
> logs, the kernel dump, etc. You might be able to sync the filesystems,

I completely agree that collecting the logs is very important. But I
think there are ways of solving that problem that works for both BUG()
and WARN(), e.g. pstore or mtdoops.

> reducing the damage to the disks.  With BUG(), the machine is

Well, you are betting that whatever bug you just discovered has not
affected the VFS in any way, causing you to sync back bad data to the
disk. I would rather take a hard reboot and rely on the filesystem's
journal to bring it up in a consistent state.

> dead. You cannot interact with it, all you have to go on, is what you
> can see on the disk, or what you might have logged on the serial
> console.

I guess we are coming at this problem from different angles. For me it
is not OK to just leave the device in limp-mode until an administrator
can inspect it and perform a reboot, as that can take weeks in some
cases. I would much rather have a hard reboot, bring the system back to
a fully operational state, detect the panic during the next boot,
prepare a debug tarball with the pstore data, and signal an alarm of
some kind.

Agree to disagree? :)

>> We have to handle EWHATEVER correctly, no? I do not get what is so
>> special about ENOMEM.
>
> Nothing is particularly special about it. But looking at the current
> code base the only other error we can get is probably ETIMEDOUT from
> an MDIO read/write. But if that happens, there is probably no real
> recovery. You have no idea what state the switch is in, and all other
> MDIO calls are likely to fail in the same way.
>
>> How would a call to kmalloc have any impact on the stack? (Barring
>> exotic bugs in the allocator that would allow the heap to intrude on
>> stack memory) Or am I misunderstanding what you mean by "the stack"?
>
> I mean the network stack, top to bottom. Say we have a few vlan
> interfaces, on top of the bridge, on top of a LAG, on top of DSA, on
> top of IP over avian carriers. When setting up a LAG, what else has
> happened by the time you get your ENOMEM? What notifications have
> already happened, which some other layer has acted upon? It is not
> just LAG inside DSA which needs to unwind, it is all the actions which
> have been triggered so far.
>
> The initial design of switchdev was transactions. First there was a
> prepare call, where you validated the requested action is possible,
> and allocate resources needed, but don't actually do it. This prepare
> call is allowed to fail. Then there is a second call to actually do
> it, and that call is not allowed to fail. This structure avoids most
> of the complexity of the unwind, just free up some resources. If you
> never had to allocate the resources in the first place, better still.

OK I think I finally see what you are saying. Sorry it took me this
long. I do not mean to be difficult, I just want to understand.

How about this:

- Add a `lags_max` field to `struct dsa_switch` to let each driver
  define the maximum number supported by the hardware. By default this
  would be zero, which would mean that LAG offloading is not supported.

- In dsa_tree_setup we allocate a static array of the minimum supported
  number across the entire tree.

- When joining a new LAG, we ensure that a slot is available in
  NETDEV_PRECHANGEUPPER, avoiding the issue you are describing.

- In NETDEV_CHANGEUPPER, we actually mark it as busy and start using it.
