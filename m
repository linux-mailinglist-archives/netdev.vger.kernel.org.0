Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8412A2C6DD6
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 01:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732191AbgK0X6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 18:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731483AbgK0X6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 18:58:14 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993C7C0613D1
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 15:58:13 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id j10so7659452lja.5
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 15:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=Ug14Nnle26FHQHHRpadu3ug4LRhnYraXpAzjkVB+kqY=;
        b=1XwiYDMEngK+Q2M4cWLsgft7MEKc2EyExUZ+zlDqqv0M8NVJaYmwhcwhJcR+g07X9K
         FZMQfA5tjMJ1MlELyxdGmRLeXp5eWzYQqEQhlKsvtq0r62Ol25T4NBz50+OYmWTMLlkN
         ln1w4SMsh5DQZwpnd2y7QveSBLo1jOM9VSReyJlUhdmUadPVOCzo7r/TjVKps5Hz727z
         9E8Yl7mkGoiPltdoWFT8KyYz1RTUHOaiVhXqkl3MUsLcgt55l99/9NQgEz+rPuwM6At8
         snH8l4U93mkz2Idsi9JczMUMzivxIL2KxEp8ci5ECSuKlkABC9oyLd3DD7JARlS9FsAX
         EBxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Ug14Nnle26FHQHHRpadu3ug4LRhnYraXpAzjkVB+kqY=;
        b=Hdsd8mLM6WGLtNNw93cieNQFV3hJudOIC5q8riPbEtObT6CSQ8jmORaRAmHTKoaNlA
         JM/OaNRjArrdF4m3uYo5js04cralsTaqrzv76Z8sEs5G1RqKtwCg/XbBcV7UdXmJSsAJ
         ArQmYqnA1mprmLSJMbnsKuUcd/qERoN40cO2lQYGBHjixyg7MQ3dq3R3xMzK83ziED7+
         1pnpF1N0V/36ZAMvqTIDDbiR4PiCs42xeGGPkHOvqm1QlOtFeMMZDzW/461S4bWabP/x
         No4t3N0Bc19upqPlurPHLvYSbqeTPUWLF5U/Pfb5vgJ6xP4Fq66h3/+Bxf4I/RD0D4Af
         RnpA==
X-Gm-Message-State: AOAM5339CuUj/5CnKGsNxU/QXPe6D1Px8ePBJCXNINHXzypYwmPYckTw
        EnByeBEUjK2nwBBP9rTdJx/SJjzxQsb3PrTt
X-Google-Smtp-Source: ABdhPJynUM2f7sJqBWNJrF7vzsn3jyPGl6hQXvYK2U6mQ12VIvgS9At0IQQ0vvlhr1QcnTDJdXNrOQ==
X-Received: by 2002:a2e:89d7:: with SMTP id c23mr4538213ljk.397.1606521492086;
        Fri, 27 Nov 2020 15:58:12 -0800 (PST)
Received: from wkz-x280 (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id g129sm864221lfd.166.2020.11.27.15.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 15:58:11 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     kuba@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [PATCH net] net: dsa: reference count the host mdb addresses
In-Reply-To: <20201015212711.724678-1-vladimir.oltean@nxp.com>
References: <20201015212711.724678-1-vladimir.oltean@nxp.com>
Date:   Sat, 28 Nov 2020 00:58:10 +0100
Message-ID: <87im9q8i99.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 00:27, Vladimir Oltean <vladimir.oltean@nxp.com> wr=
ote:
> Currently any DSA switch that implements the multicast ops (properly,
> that is) gets these errors after just sitting for a while, with at least
> 2 ports bridged:
>
> [  286.013814] mscc_felix 0000:00:00.5 swp3: failed (err=3D-2) to del obj=
ect (id=3D3)
>
> The reason has to do with this piece of code:
>
> 	netdev_for_each_lower_dev(dev, lower_dev, iter)
> 		br_mdb_switchdev_host_port(dev, lower_dev, mp, type);
>
> called from:
>
> br_multicast_group_expired
> -> br_multicast_host_leave
>    -> br_mdb_notify
>       -> br_mdb_switchdev_host
>
> Basically, that code is correct. It tells each switchdev port that the
> host can leave that multicast group. But in the case of DSA, all user
> ports are connected to the host through the same pipe. So, because DSA
> translates a host MDB to a normal MDB on the CPU port, this means that
> when all user ports leave a multicast group, DSA tries to remove it N
> times from the CPU port.
>
> We should be reference-counting these addresses.

That sounds like a good idea. We have run into another issue with the
MDB that maybe could be worked into this changeset. This is what we have
observed on 4.19, but from looking at the source it does not look like
anything has changed with respect to this issue.

The DSA driver handles the addition/removal of router ports by
enabling/disabling multicast flooding to the port in question. On
mv88e6xxx at least, this is only part of the solution. It only takes
care of the unregistered multicast. You also have to iterate through all
_registered_ groups and add the port to the destination vector.

If you do that the na=C3=AFve way, you run in to a secondary problem. Witho=
ut
any caching middle layer, you now have a single bit in the vector that
can be set either because the port is a router port, or because someone
has joined the group, _OR_ both (if the querier moves due to a topology
change for example). So you need a cache of the joined ports for each
group, and the router port vector. That way you can make sure to only
clear the bit if neither the cached group entry nor the router port
vector has the bit set.

If you think it could be useful I could try to rebase our internal
solution on net-next and post it as an RFC. Maybe there are at least
parts that can be used from it.
