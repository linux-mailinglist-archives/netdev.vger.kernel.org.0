Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD02344CD2
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhCVRIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbhCVRHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 13:07:54 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22805C061762
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 10:07:54 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id g8so15301944lfv.12
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 10:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=3DoZwa5x+3AmTQG1D9ca3y+5ISDftdNt6INufB/gADo=;
        b=H0Ywt+r41tHc2qfoU18LLna2Wm9Dsmc9/z/YqBiKjdcy6o/k51jIFYxSJV/VEg+ETY
         PltU2ohqNu/rMEbfG9p1akmItBxPp9PSMpuGOLGcx/eqpHxJN6JbfYGL4gRcIwOSQ52h
         we7FpuGtvd6QAq2DNv5rq1Srh06m0HGb/SIaYKuk29Bzq25ChMOlEJZoix4lASJmaKbU
         Op6lRr+pJwJDMiBf5gapsDdtyD7jnc+fSiKKTlnL1RBExU0XoC6kPnz1ZsOOnV/xqQLF
         PzucskiN2yxzUk7GcyJHMFGV0LZWXNwCcaSH31UYMpiekb7dqv6+8PwBrg//fkSxwbiP
         RsiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=3DoZwa5x+3AmTQG1D9ca3y+5ISDftdNt6INufB/gADo=;
        b=PO2blpEQyByO9ykeuaTF8zlhz1QdPc7WHjrQDwe4a3PuRd5+tiwr4frMFq/gaeGUVC
         ZNWAfdBANsYf/ibOKVWoEvY0F2C1pbIpVr2OiDCDy+TYGJRJVBCMg2FHAz5bSl+wkRxD
         egdOTiDdKdei7tv7ULj40z5v4ByeP5ooNQx3Wi1mnC6N6xp5WDif+cq9oXp/zslBwmYS
         xz/MiVNb31NyNurhfm0PTEGpzCWG3GKT986oBNIUEGs925pzggjBu9ZHSBTaM9zWugnR
         gJteMlIzT8sSh0jbHOigo4NbjI2/RjWUreef+v8WMz7bLUfWZsFcJ3GggKCeV/lSjvtt
         tUnA==
X-Gm-Message-State: AOAM532qVNgLiUoTUcgS/YLfEpCCncTlISWcw/dCm4AEty40Jw7wOX6I
        ZFNgN/ARE9pqWcrNSOFNw1XjGw==
X-Google-Smtp-Source: ABdhPJzTmbhqot8hiZviyTd/P8TwxH05WWTd1+hWif5o8JathO6VRyWaKqzBAFK2ca6XO7pkCmtFCQ==
X-Received: by 2002:ac2:51b4:: with SMTP id f20mr183621lfk.509.1616432872417;
        Mon, 22 Mar 2021 10:07:52 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y17sm1615698lfb.132.2021.03.22.10.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 10:07:52 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 net-next 09/16] net: dsa: replay port and local fdb entries when joining the bridge
In-Reply-To: <20210322161955.c3slrmbtofswrqiz@skbuf>
References: <20210318231829.3892920-1-olteanv@gmail.com> <20210318231829.3892920-10-olteanv@gmail.com> <87wntzmbva.fsf@waldekranz.com> <20210322161955.c3slrmbtofswrqiz@skbuf>
Date:   Mon, 22 Mar 2021 18:07:51 +0100
Message-ID: <87o8fbm80o.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 18:19, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Mar 22, 2021 at 04:44:41PM +0100, Tobias Waldekranz wrote:
>> I do not know if it is a problem or not, more of an observation: This is
>> not guaranteed to be an exact replay of the events that the bridge port
>> (i.e. bond0 or whatever) has received since, in fdb_insert, we exit
>> early when adding local entries if that address is already in the
>> database.
>> 
>> Do we have to guard against this somehow? Or maybe we should consider
>> the current behavior a bug and make sure to always send the event in the
>> first place?
>
> I don't really understand what you're saying.
> fdb_insert has:
>
> 	fdb = br_fdb_find(br, addr, vid);
> 	if (fdb) {
> 		/* it is okay to have multiple ports with same
> 		 * address, just use the first one.
> 		 */
> 		if (test_bit(BR_FDB_LOCAL, &fdb->flags))
> 			return 0;
> 		br_warn(br, "adding interface %s with same address as a received packet (addr:%pM, vlan:%u)\n",
> 		       source ? source->dev->name : br->dev->name, addr, vid);
> 		fdb_delete(br, fdb, true);
> 	}
>
> 	fdb = fdb_create(br, source, addr, vid,
> 			 BIT(BR_FDB_LOCAL) | BIT(BR_FDB_STATIC));
>
> Basically, if the {addr, vid} pair already exists in the fdb, and it
> points to a local entry, fdb_create is bypassed.
>
> Whereas my br_fdb_replay() function iterates over br->fdb_list, which is
> exactly where fdb_create() also lays its eggs. That is to say, unless
> I'm missing something, that duplicate local FDB entries that skipped the
> fdb_create() call in fdb_insert() because they were for already-existing
> local FDB entries will also be skipped by br_fdb_replay(), because it
> iterates over a br->fdb_list which contains unique local addresses.
> Where am I wrong?

No you are right. I was thinking back to my attempt of offloading local
addresses and I distinctly remembered that local addresses could be
added without a notification being sent.

But that is not what is happening. It is just already inserted on
another port. So the notification would reach DSA, or not, depending on
ordering the of events. But there will be no discrepancy between that
and the replay.
