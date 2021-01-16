Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EF62F8E09
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 18:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbhAPRNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 12:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728342AbhAPRKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 12:10:39 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A278FC061359;
        Sat, 16 Jan 2021 07:39:26 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id u21so13657879lja.0;
        Sat, 16 Jan 2021 07:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:in-reply-to:references:date:message-id:mime-version;
        bh=z4leNzWR0o9Do22EpCpfCpRtm41HhzuAfaYRCquNCR0=;
        b=MCsW6wEKTxnKAuSRQO8c9OUoSTbZEBU5HojfvG84uvdpK1ANEYTa542H6s1mjmnJHn
         q9ervHHEO0uI6GLw8vV2XJq40dLAaPQO37MRMXJ5fYhoVQlZ9ZRM2O2lLj+wYeUaCNzz
         +QgiJ7DiPKuqFUOkkPNyPdKncBRC4gNPpxDqsEYT+hTS+h97HF/HNWZS8eq4nsaXk3DQ
         VzJlHjCOA2g9zalXA8yuqZRfqPndj7f9lMg1obaho6juf4TjgkbSt57qTSycTQFJjQf8
         yfAD3zCXL3vKLBPpxttr1ENT46a/sX4ObuMlXolAvBzTIEOZRqmt+Y4llaicDp+2k2fi
         DTcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=z4leNzWR0o9Do22EpCpfCpRtm41HhzuAfaYRCquNCR0=;
        b=cD9a49P1QKXxK1mKmiuC4rUziRv3VEUZnpCSZNukEoymUgtRu/MoZqfvc87Wkz27PD
         mOCa0oTvbBccN5fniLuuDDr1fVwwHpY1chgb6GB8i00MjMmy9M60/U96rpM0N0SsBIXd
         l8M9iCsBx2l2LEdvKueR+cFn2Moa7HTgT2IvmW+IZCUeIw0vasRcdTnejpl6UMsWIPdA
         QJPAJ7Eym+DQO1Ou3P0iE7AqKfGGjkO7yVoUF2K+v4EPIm1BRgz9bwuGYdHPgolsXgxA
         IdGRqG3NC5oz2reJe+QtfX6wfmgCVBY+WWI5b4o26bQriFesfzK5gbqDx2ujYPhvoAI4
         uwlg==
X-Gm-Message-State: AOAM530+ENwmH81iGfmvA4SLjzQ7DI83Z/bX0fyU1Y4lw68d+09sKwNJ
        Bxy1vbE1CUTQG4HhUjkTOmQ=
X-Google-Smtp-Source: ABdhPJxx1xzvcIFNiwWt0AzCy5JT5eeXxNuv9NvuyRx9/+Douelol9Omv6JDLentiHIJzcM7QBwS0w==
X-Received: by 2002:a05:651c:1304:: with SMTP id u4mr7847774lja.146.1610811565188;
        Sat, 16 Jan 2021 07:39:25 -0800 (PST)
Received: from luthien (h-82-196-111-206.NA.cust.bahnhof.se. [82.196.111.206])
        by smtp.gmail.com with ESMTPSA id g27sm1142499ljl.82.2021.01.16.07.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 07:39:24 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        allan.nielsen@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [RFC PATCH v2] net: bridge: igmp: Extend IGMP query to be per vlan
In-Reply-To: <32bf6a72-6aff-5e36-fb02-333f3c450f49@nvidia.com>
References: <20210112135903.3730765-1-horatiu.vultur@microchip.com> <32bf6a72-6aff-5e36-fb02-333f3c450f49@nvidia.com>
Date:   Sat, 16 Jan 2021 16:39:24 +0100
Message-ID: <8735z0zyab.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 14:15, Nikolay Aleksandrov <nikolay@nvidia.com> wrote:
> On 12/01/2021 15:59, Horatiu Vultur wrote:
>> Based on the comments of the previous version, we started to work on a
>> new version, so it would be possible to enable/disable queries per vlan.
>> [snip]
>> We were wondering if this what you had in mind when you proposed to have
>> this per vlan? Or we are completely off? Or we should fix some of the
>> issues that I mentioned, before you can see more clearly the direction?
> No, unfortunately not even close. We already have per-port per-vlan and global per-vlan
> contexts which are also linked together for each vlan, those must be used for any vlan
> configuration and state. The problem is that you'd have to mix igmp and vlan code and
> those two live under two different kconfig options, and worse rely on different locks, so
> extra care must be taken.
> [snip]
> If you don't need this asap, I'll probably get to it in two months
> after EHT and the new bridge flush api, even we are still carrying an out-of-tree patch
> for this which someone (not from cumulus) tried to upstream a few years back, but it also has
> wrong design in general. :)

Hi,

very interesting thread this!  I believe I may be the one who posted the
patch[1] a few years ago, and I fully agree with Nik here.  We developed
the basic concepts further at Westermo, but it's been really difficult
to get it stable.

We have discussed at length at work if an IGMP snooping implementation
really belongs in the bridge, or if it's better suited as a user space
daemon?  Similar to what was decided for RSTP/MSTP support, i.e., the
bridge only has STP and RSTP/MSTP is handled by mstpd[2].

Most of what's required for a user space implementation is available,
but it would've been nice if a single AF_PACKET socket on br0 could be
used to catch what brport (ifindex) a query or report comes in on.  As
it is now that information is lost/replaced with the ifindex of br0.
And then there's the issue of detecting and forwarding to a multicast
routing daemon on top of br0.  That br0 is not a brport in the MDB, or
that host_joined cannot be set/seen with iproute2 is quite limiting.
These issues can of course be addressed, but are they of interest to
the community at large?


Best regards
 /Joachim

[1]: https://lore.kernel.org/netdev/20180418120713.GA10742@troglobit/
[2]: https://github.com/mstpd/mstpd
