Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39292B2FD1
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 19:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgKNStV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 13:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgKNStU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 13:49:20 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C079CC0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 10:49:18 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id cq7so14524043edb.4
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 10:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+PI5OVIDJu+CjknX988FhblgTcvDRYXND56s4N9BIjo=;
        b=Bv+AsOr9fYkvMQ20uiILZFgwDfkuhkn+p8MWHrFaZ1EdSf3v4ywreeCXGzhgzdcLFM
         UQVTrZWl4c3Db58Ek04bzw7a4lj4EJ9MfRvwmjXA3Byu8aE6zCLEKF6fqbEzeWKb6x0a
         LVZq2w9WBjUUpGIcH4N0KptjUPVAAyGR7Zk3+pfutcjF82yn6mhHLuT37sHamGIk4CUl
         oZwLpItTgBNXIz7P0SsG2qInglMNs8YhktxVlRD0iM9MgBN+yUtrno2TqmkVRMyAS7ob
         lRwbCw9Q/iNuzl/NiBhyW35A4tnoah7Sb9NWsIeQ66LbRdNv3gyGe54zuIdekuhg1CTM
         2oPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+PI5OVIDJu+CjknX988FhblgTcvDRYXND56s4N9BIjo=;
        b=hUKmK9wABAo2U5sSADmTnrMpA5druevvSh9OE5vvZAC/GKSBLqmzlsAbwpbfXVEdJk
         Wmy8iD6r6XRaxk3ZK2FYjOif0G3b3Va48KzSb58K8ROSlTSm52rrY4ojyB5BhCKxiKen
         Ql9z3heh1QdRJ6bsOzYbP4atoEYNq9F9Dn8A520V47aYh+9Xwyp6uFRYSVpbvpwqhYuk
         kzlHdpKQinKkVOVtz+EsuZhtoAay2EqfyEi9lKYDq5ke0ITzrl0Zahz0qts+HMEHsCs5
         XCvhyWZYf+lhCK9LCdzBDkbhzPIuovEL+wqKcq9Jo1osNx+HMwa5XEDWzWy4IxE4ZqqT
         A13g==
X-Gm-Message-State: AOAM530sGAvzBeUZYGqZ2L3G7fvHLkfjSxThAOKN7tnpEV/gr+XUe7IW
        laE28Z/gGoc0GvX6MulV0oIQmWJBQr4=
X-Google-Smtp-Source: ABdhPJz1TtIxy+dDKYBDAw7t5JpWohLZ7dbru5obmhk1p24OpwGYoTliyzHAEg+siuYAS47R92iWGw==
X-Received: by 2002:aa7:d858:: with SMTP id f24mr8259867eds.12.1605379757413;
        Sat, 14 Nov 2020 10:49:17 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id bt16sm7217701ejb.89.2020.11.14.10.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 10:49:16 -0800 (PST)
Date:   Sat, 14 Nov 2020 20:49:15 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Tj (Elloe Linux)" <ml.linux@elloe.vision>
Cc:     netdev@vger.kernel.org, chris.packham@alliedtelesis.co.nz,
        andrew@lunn.ch, f.fainelli@gmail.com, marek.behun@nic.cz,
        vivien.didelot@gmail.com, info <info@turris.cz>
Subject: Re: dsa: mv88e6xxx not receiving IPv6 multicast packets
Message-ID: <20201114184915.fv5hfoobdgqc7uxq@skbuf>
References: <1b6ba265-4651-79d2-9b43-f14e7f6ec19b@alliedtelesis.co.nz>
 <0538958b-44b8-7187-650b-35ce276e9d83@elloe.vision>
 <3390878f-ca70-7714-3f89-c4455309d917@elloe.vision>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3390878f-ca70-7714-3f89-c4455309d917@elloe.vision>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 03:39:28PM +0000, Tj (Elloe Linux) wrote:
> MV88E6085 switch not passing IPv6 multicast packets to CPU.
>
> Seems to be related to interface not being in promiscuous mode.
>
> This issue has been ongoing since at least July 2020. Latest v5.10-rc3
> still suffers the issue on a Turris Mox with mv88e6085. We've not been
> able to reproduce it on the Turris v4.14 stable kernel series so it
> appears to be a regression.
>
> Mox is using Debian 10 Buster.
>
> First identified due to DHCPv6 leases not being renewed on clients being
> served by isc-dhcp-server on the Mox.
>
> Analysis showed the client IPv6 multicast solicit packets were being
> received by the Mox hardware (proved via a mirror port on a managed LAN
> switch) but the CPU was not receiving them (observed using tcpdump).
>
> Further investigation has identified this also affects IPv6 neighbour
> discovery for clients when not using frequent RAs from the Mox.
>
> Currently we've found two reproducible scenarios:
>
> 1) with isc-dhcp-server configured with very short lease times (180
> seconds). After mox reboot (or systemctl restart systemd-networkd)
> clients successfully obtain a lease and a couple of RENEWs (requested
> after 90 seconds) but then all goes silent, Mox OS no longer sees the
> IPv6 multicast RENEW packets and client leases expire.
>
> 2) Immediately after reboot when DHCPv6 renewals are still possible if
> on the Mox we do "tcdump -ni eth1 ip6" and immediately terminate,
> tcpdump takes the interface out of promiscuous mode and IPv6 multicast
> packets immediately cease to be received by the CPU. If we use 'tcpdump
> --no-promiscuous-mode ..." so on termination it doesn't try to take the
> interface out of promiscuous mode IPv6 multicast packets continue to be
> seen by the CPU.
>
> We've been pointed to the mv8e6xxx_dump tool and can capture data but
> not sure what specifically to look for.
>
> We've also added some pr_info() debugging into mvneta to analyse when
> promiscuous mode is enabled or disabled since this seems to be strongly
> related to the issue.
>
> We believe there's a big clue in being able to reset the issue by
> restarting systemd-networkd on the Mox. We've looked for but not found
> any clues or indications of services on the Mox causing this but aren't
> ruling this out.

Is there a simple step-by-step reproducer for the issue, that doesn't
require a lot of configuration? I've got a Mox with the 6190 switch
running net-next and Buildroot that I could try on.
