Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDEA177B89
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 17:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbgCCQEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 11:04:30 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39194 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729382AbgCCQEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 11:04:30 -0500
Received: by mail-ed1-f67.google.com with SMTP id m13so5015687edb.6
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 08:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y+m6K//sgC/OF0mXOZtyhByG4QWfHV5eBgckRsLGNbY=;
        b=BrMvvc1o+qTp2xzss31tPGUWvFBKJSelqbxQdEIilRP+ZVsfcBzNFzvqO9u+EdypID
         Zr9Xt56GVvCTpICMoLjK+iHBtvpXu7j58oS8pqQ54uDX6ivB1sn5iVm5PoJbRo4c+Va3
         yavQT/tVJ7Pq+DrG0pATxgQXRZLco1bFqOS+7GJKaBgBrgnw17jTS8ZPSLaKzTnV3cCP
         AJ1x7qHbA/tL2Zq/r1dPNbKW+aBdXp0S89+IswJUSNYFYpGqeEqbnx99k6yadW8RVsIz
         wKiTQob4fb1RNXpm3g5Evjt2IjTvFbvTkvNiANCPYdtEqNwJu896yzq66BNTc0oUKkhq
         phew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y+m6K//sgC/OF0mXOZtyhByG4QWfHV5eBgckRsLGNbY=;
        b=oiY/QaiTDaBzmcVadMF8t43eQapnQ/WFGNamhEWYTpqy/DdrfXMvD5JznWg9bsq96V
         avBUaa7xjV4DT7Duk4PQ5BkNz0JDKcyPRTi8o8w0QRG/wth8hNMTWxtK/qbN4IVZAQRo
         oOfgYwtajT5+JcIpnUMafVRrqEdbqIEPEGVQg47zp61OAyjXpl2tSqDq4lIGUGpd/VMR
         RHGkAsQKAWV8Z1Bpl7373K8nrLs/VfcUiIQb/Z9neYzW7fKkO3xZyBxE/SGW8C250N2k
         W5T+o35sV386OScEF8O+8ARblvu9LRljMo4sMCtpLU5QUWgSFEkk1eMjPIahUxJsTmo1
         ny+Q==
X-Gm-Message-State: ANhLgQ0gpSkD8LnEw9w8fcpAdLnD5yb3rLm4fRWnnCBXvVfVa+8f4Mg+
        Wj3t7w2DRhtRMD4bhSlvXu9kUs4bMP7MSzA2skucQQBU
X-Google-Smtp-Source: ADFU+vtLEHOGpFkZ+CXjRK6Zf/EmGglTV/IW5npSWtOFPCTAvQUV7o3vl8iahJsirWI/00lIgG1RwbuzubkIj56YnaQ=
X-Received: by 2002:aa7:c44e:: with SMTP id n14mr4720618edr.179.1583251467532;
 Tue, 03 Mar 2020 08:04:27 -0800 (PST)
MIME-Version: 1.0
References: <20200229145003.23751-1-olteanv@gmail.com> <20200229145003.23751-3-olteanv@gmail.com>
In-Reply-To: <20200229145003.23751-3-olteanv@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 3 Mar 2020 18:04:16 +0200
Message-ID: <CA+h21hryPYbSUqzEcmHeae5Rknc-TCmBimLjH-M8Fkiv0jqwGA@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 2/2] net: dsa: felix: Allow unknown unicast
 traffic towards the CPU port module
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Feb 2020 at 16:50, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Compared to other DSA switches, in the Ocelot cores, the RX filtering is
> a much more important concern.
>
> Firstly, the primary use case for Ocelot is non-DSA, so there isn't any
> secondary Ethernet MAC [the DSA master's one] to implicitly drop frames
> having a DMAC we are not interested in.  So the switch driver itself
> needs to install FDB entries towards the CPU port module (PGID_CPU) for
> the MAC address of each switch port, in each VLAN installed on the port.
> Every address that is not whitelisted is implicitly dropped. This is in
> order to achieve a behavior similar to N standalone net devices.
>
> Secondly, even in the secondary use case of DSA, such as illustrated by
> Felix with the NPI port mode, that secondary Ethernet MAC is present,
> but its RX filter is bypassed. This is because the DSA tags themselves
> are placed before Ethernet, so the DMAC that the switch ports see is
> not seen by the DSA master too (since it's shifter to the right).
>
> So RX filtering is pretty important. A good RX filter won't bother the
> CPU in case the switch port receives a frame that it's not interested
> in, and there exists no other line of defense.
>
> Ocelot is pretty strict when it comes to RX filtering: non-IP multicast
> and broadcast traffic is allowed to go to the CPU port module, but
> unknown unicast isn't. This means that traffic reception for any other
> MAC addresses than the ones configured on each switch port net device
> won't work. This includes use cases such as macvlan or bridging with a
> non-Ocelot (so-called "foreign") interface. But this seems to be fine
> for the scenarios that the Linux system embedded inside an Ocelot switch
> is intended for - it is simply not interested in unknown unicast
> traffic, as explained in Allan Nielsen's presentation [0].
>
> On the other hand, the Felix DSA switch is integrated in more
> general-purpose Linux systems, so it can't afford to drop that sort of
> traffic in hardware, even if it will end up doing so later, in software.
>
> Actually, unknown unicast means more for Felix than it does for Ocelot.
> Felix doesn't attempt to perform the whitelisting of switch port MAC
> addresses towards PGID_CPU at all, mainly because it is too complicated
> to be feasible: while the MAC addresses are unique in Ocelot, by default
> in DSA all ports are equal and inherited from the DSA master. This adds
> into account the question of reference counting MAC addresses (delayed
> ocelot_mact_forget), not to mention reference counting for the VLAN IDs
> that those MAC addresses are installed in. This reference counting
> should be done in the DSA core, and the fact that it wasn't needed so
> far is due to the fact that the other DSA switches don't have the DSA
> tag placed before Ethernet, so the DSA master is able to whitelist the
> MAC addresses in hardware.
>
> So this means that even regular traffic termination on a Felix switch
> port happens through flooding (because neither Felix nor Ocelot learn
> source MAC addresses from CPU-injected frames).
>
> So far we've explained that whitelisting towards PGID_CPU:
> - helps to reduce the likelihood of spamming the CPU with frames it
>   won't process very far anyway
> - is implemented in the ocelot driver
> - is sufficient for the ocelot use cases
> - is not feasible in DSA
> - breaks use cases in DSA, in the current status (whitelisting enabled
>   but no MAC address whitelisted)
>
> So the proposed patch allows unknown unicast frames to be sent to the
> CPU port module. This is done for the Felix DSA driver only, as Ocelot
> seems to be happy without it.
>
> [0]: https://www.youtube.com/watch?v=B1HhxEcU7Jg
>
> Suggested-by: Allan W. Nielsen <allan.nielsen@microchip.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

I see this patch has "Needs Review / ACK" in patchwork.

There is in fact a tag:

Reviewed-by: Allan W. Nielsen <allan.nielsen@microchip.com>

which I had forgotten to copy over from v2:
https://www.spinics.net/lists/netdev/msg633098.html

Hope there are no particular issues with this approach from DSA perspective.

Thanks,
-Vladimir
