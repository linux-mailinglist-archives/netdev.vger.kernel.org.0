Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70AF1300975
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 18:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbhAVQHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 11:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729441AbhAVQGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 11:06:43 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CC1C0613D6;
        Fri, 22 Jan 2021 08:05:59 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id l12so4561572ljc.3;
        Fri, 22 Jan 2021 08:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:in-reply-to:references:date:message-id:mime-version;
        bh=dYnyyDVesC6Z9/jeabSdXpAorVFlaVIqQIB+RhVpm20=;
        b=Pjk8XN0YQxDSUm0xUJqm0sY6ZgUSIKRGcuyScCBDKU62oyPWiFsPlYm0eGDjATy1ux
         Wi0pqVdpZ4UJqGG5jrqJn1C79iqJLS3ff92ZspYcX9f34oAOIpN2MK0Z/zK5loKz4oWr
         ylNlljL+Tp5QHdw7mG0i7dKnff35K15eQXAe66PW0a3yHrW5i+NdWrxNi5WHlLeAJfhp
         PVmXFv1bPnMYS7icgAEdqy5UYwDwmp9Fc7+J8CXxaXOyeeuw5MhtW1mr6CZv05b88chG
         8ZcbCIplVT8XUEq7blupmNhPcBuwf1vFfXK9czYXR+5en2Wlf8Q73jrym1XLEGMGlEEx
         8p3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dYnyyDVesC6Z9/jeabSdXpAorVFlaVIqQIB+RhVpm20=;
        b=Z9msNoygHzUJSBP+9frIt82hL4K2intu54ywLAZMQIrWFhOP0HE7fg0mxnlHqRSQCf
         PNdIk4liAtA8Dp3vk2vpHw0781MyBeDOXqNOA9QquZlO9RTFC4FrSWVMKIABOMQJbtGN
         gLuqyPFtctZuqevk3b5zMMxhTEVtyQwWy0qX2OJ7c5XIt0/wiGRhflkQbUrXmfbk9tl0
         8465/SJBecTa9ErNZYmyrDysa2Qz5rJiBBVSt1pImMfPvCkkpBifU5ODPPl8uqNZS0qY
         c7fSE5GA/MKrUzsUF3JccYWEe6RmIURrM2WpQDErdTA3FzlQOWMVbUgxRKSpVCXKkBlm
         1n6Q==
X-Gm-Message-State: AOAM532RQ49bpcG2t2GIXP3UDA12aANWnz5RDiX7PaqtnWt6b/rKzphI
        03/2LydK9ZHIGhmE1G/Kg2g=
X-Google-Smtp-Source: ABdhPJxBa1WiN/jurrX5CRJ6eaLx6b/Zr+ZK+9s9s6R+83bCQy2uN+hg+wESRQnZBzKPbEdJc33izA==
X-Received: by 2002:a2e:b52c:: with SMTP id z12mr1144667ljm.250.1611331558242;
        Fri, 22 Jan 2021 08:05:58 -0800 (PST)
Received: from luthien (h-82-196-111-206.NA.cust.bahnhof.se. [82.196.111.206])
        by smtp.gmail.com with ESMTPSA id n23sm1027123lji.36.2021.01.22.08.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 08:05:57 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        allan.nielsen@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [RFC PATCH v2] net: bridge: igmp: Extend IGMP query to be per vlan
In-Reply-To: <b54644f6-b559-b13b-adf8-d95f7b2a6885@nvidia.com>
References: <20210112135903.3730765-1-horatiu.vultur@microchip.com> <32bf6a72-6aff-5e36-fb02-333f3c450f49@nvidia.com> <8735z0zyab.fsf@gmail.com> <b54644f6-b559-b13b-adf8-d95f7b2a6885@nvidia.com>
Date:   Fri, 22 Jan 2021 17:05:57 +0100
Message-ID: <87czxxvtwa.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 13:53, Nikolay Aleksandrov <nikolay@nvidia.com> wrote:
> On 16/01/2021 17:39, Joachim Wiberg wrote:
>> We have discussed at length at work if an IGMP snooping implementation
>> really belongs in the bridge, or if it's better suited as a user space
>> daemon?  Similar to what was decided for RSTP/MSTP support, i.e., the
>> bridge only has STP and RSTP/MSTP is handled by mstpd[2].
>> 
>> Most of what's required for a user space implementation is available,
>> but it would've been nice if a single AF_PACKET socket on br0 could be
>> used to catch what brport (ifindex) a query or report comes in on.  As
>> it is now that information is lost/replaced with the ifindex of br0.
>> And then there's the issue of detecting and forwarding to a multicast
>> routing daemon on top of br0.  That br0 is not a brport in the MDB, or
>> that host_joined cannot be set/seen with iproute2 is quite limiting.
>> These issues can of course be addressed, but are they of interest to
>> the community at large?
>> 
>> [1]: https://lore.kernel.org/netdev/20180418120713.GA10742@troglobit/
>> [2]: https://github.com/mstpd/mstpd

Ni Nik,

> I actually had started implementing IGMPv3/MLDv2 as a user-space daemon part of
> FRRouting (since it already has a lot of the required infra to talk to the kernel).
> It also has IGMPv3/MLDv2 support within pimd, so a lot of code can be shared.

Interesting!  Glad to hear other people have had similar ideas :)

> Obviously there are pros and cons to each choice, but I'd be interested to see a
> full user-space implementation. I decided to make the kernel support more complete
> since it already did IGMPv2 and so stopped with the new FRR daemon.

Yeah it's difficult to find the right cut-off for when it'll be more
useful to do it all in userspace.  For us I think it was the combination
of having many VLANs and wanting full querier support, i.e., not having
any multicast router available.  When we had to go dumpster diving for
useful IP address in IGMP queries on higher-level VLAN interfaces.

> If needed I'd be happy to help with the kernel support for a new
> user-space daemon, and also can contribute to the daemon itself if
> time permits.

That's good to know.  I think I'll start breathing life into a small
IGMP-only (for now) userspace daemon and see where it leads.  I need
it both for work and for all the various multicast routing projects
I maintain on my spare time.

Would it be OK to send questions regarding issues interfacing with the
bridge and updates/progress to this list for such a project?

Best regards
 /Joachim
