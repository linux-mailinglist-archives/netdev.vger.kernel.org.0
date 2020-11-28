Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383F92C73BD
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387584AbgK1Vty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733046AbgK1TFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 14:05:09 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCABC02B8F3
        for <netdev@vger.kernel.org>; Sat, 28 Nov 2020 01:34:17 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id l11so10510547lfg.0
        for <netdev@vger.kernel.org>; Sat, 28 Nov 2020 01:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=R/4uwe4eXQ5U3D6fZgJpfHdmGuVrF1tsoStCaEWc9nQ=;
        b=gss7Ip4Iro9vrucaSW8vA2mDV7ZwzlK1r5s/+mwrg9Jve929nBDtZRIr3RLuoHadA3
         VCNo/uPbjLymjcu22b7Kbss9z1BFEDqMTeP+xhEtP8J1DfWSHZ9gH21QXcKXFn8cji8i
         SKN76RhMQW5Ck9OLFBvpwCkaaX43C5Km04L3rmgINcFOMWidXSzMEe1f3GVMGDY9jcui
         ZUhtup9m5eoFS0BtOJLFSPCB+h1EBsrZvzsaFICvV7+NEnp6aqonj7g2woOl/XEKc2zC
         yAfUhFH8ojal1i0pN2L1UJs/SZO5O0Z4OgaDBEpwipd7Ii74K5q40baKQW94mWuPxjLZ
         laVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=R/4uwe4eXQ5U3D6fZgJpfHdmGuVrF1tsoStCaEWc9nQ=;
        b=d8rAepyzdKL+iEfDdUBzf/+teyLe6KaMElJKNDRjYong3ZU3fZYV/sPWbUWYEUBTRi
         S/CHQ0kMVfirHjH01S5pyUa+FVgnTLsXOmdAsoZruaJceePEidfFk+ZLhxdVCMRwMPcF
         NuEPGKAZaQ0X1PQQha8F8QC3JXa8iUTLvrFGNMm054YhKzhmnxE4b7/YOqEAuaRBdncM
         tzsbisznZLhQXzRc/JahVxuFQwh8H/DYU1X9J2ZYI50wLywlN6OP/YeUZg2GhX6wp5xR
         CHhKGzsnvgGHq+S1Tw73Lkajm71KuRoO1a3jjNY/4/nO0qDuf2laiWiofkt7QqFVxrrS
         dAQg==
X-Gm-Message-State: AOAM532iMW+CBbz3qN7haYUkjVBkjBl5t/SpXlVRAhcE/IVIJDnsAlZC
        XxwQ488QhlsyHji9fKrOlreAIg==
X-Google-Smtp-Source: ABdhPJw4T+BWHmYhz88V/ldaDRIY1ehFSRQsuvHkurD+c84fHvcnlTpixBQBI42AUuXfWW4h5/8JAA==
X-Received: by 2002:ac2:48b2:: with SMTP id u18mr5171918lfg.313.1606556055258;
        Sat, 28 Nov 2020 01:34:15 -0800 (PST)
Received: from wkz-x280 (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id l17sm1002387lfg.205.2020.11.28.01.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 01:34:14 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba\@kernel.org" <kuba@kernel.org>,
        "andrew\@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli\@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot\@gmail.com" <vivien.didelot@gmail.com>
Subject: Re: [PATCH net] net: dsa: reference count the host mdb addresses
In-Reply-To: <20201128002717.buvgy3unu6af5ejj@skbuf>
References: <20201015212711.724678-1-vladimir.oltean@nxp.com> <87im9q8i99.fsf@waldekranz.com> <20201128002717.buvgy3unu6af5ejj@skbuf>
Date:   Sat, 28 Nov 2020 10:34:13 +0100
Message-ID: <87ft4t965m.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 28, 2020 at 00:27, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> On Sat, Nov 28, 2020 at 12:58:10AM +0100, Tobias Waldekranz wrote:
>> That sounds like a good idea. We have run into another issue with the
>> MDB that maybe could be worked into this changeset. This is what we have
>> observed on 4.19, but from looking at the source it does not look like
>> anything has changed with respect to this issue.
>>
>> The DSA driver handles the addition/removal of router ports by
>> enabling/disabling multicast flooding to the port in question. On
>> mv88e6xxx at least, this is only part of the solution. It only takes
>> care of the unregistered multicast. You also have to iterate through all
>> _registered_ groups and add the port to the destination vector.
>
> And this observation is based on what? Based on this paragraph from RFC4541?

Well in all honesty, it is mostly based on information from a colleague
of mine who knows the ins and outs of all these RFCs.

> 2.1.2.  Data Forwarding Rules
>
>    1) Packets with a destination IP address outside 224.0.0.X which are
>       not IGMP should be forwarded according to group-based port
>       membership tables and must also be forwarded on router ports.

...but yes, that paragraph does not leave a lot of wiggle room :)

> Let me ask you a different question. Why would DSA be in charge of
> updating the MDB records, and not the bridge? Or why DSA and not the end
> driver? Ignore my patch. I'm just trying to understand what you're
> saying. Why precisely DSA, the mid layer? I don't know, this is new
> information to me, I'm still digesting it.

The bridge has all the necessary information for sure. But it has a
different model with a separate list of router ports. Then in
br_multicast_flood you simply forward to the union of the group entry
and the router ports. It is not the bridge's fault that our hardware
does not have a separate bitmask for router ports. Some hardware may
very well have it.

I guess we could create internal APIs to the bridge to retrieve the
information though. There is already `bool br_multicast_router(dev)`, so
we should only need to add `bool br_multicast_member(dev, group, vid)`.

Assuming that those were available we should be able to solve it either
at the DSA or the driver layer. I seem to recall some issue that forced
us to place the cache at the dst level, but I would have to go through
the implementation to figure out what that issue was.
