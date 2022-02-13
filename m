Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD1B4B3CEA
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 19:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237808AbiBMSob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 13:44:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbiBMSoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 13:44:30 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5FB57B21
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 10:44:24 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id b9so2312990lfv.7
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 10:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=jaVitoBNZIdGXsOl6MZ6OYgG7+dvdc5ciKbSDYsvSKs=;
        b=AA6Je9n9ddhQ9plxLdNAzlaRyB3XuaB4WVhctuih6pjMtcLo/5bmAes8umx0puMrMW
         Y6xYpJMdw5qJOf6/rAfhCkiO5fZn8Ii0NOUs5KUrXbLBbQzQcLYH6NjyocCmWaT35m4C
         WTbDoyGFudwuxzreLBgABEtxnTpuq1NTSAH0yFOp6QYeBR+GaC+pbI2512Dik3TvStQe
         T1rhpo9oWMr9aCXlYWJ/qtfXKg57VxxrwmVwLXMib92dRwrddCp0roX+ZdHM70qAdUbe
         7rstnv4+S2od8wTiuGrN7yGMgQun+3zpUJ+ydjuSMKce+qaCGn3X7y4mLM9xOmaooQoY
         33Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=jaVitoBNZIdGXsOl6MZ6OYgG7+dvdc5ciKbSDYsvSKs=;
        b=DukSXC0GLASJpYI8hIjYRuV45ER7wUFSSw+/KQ/v/z2RXRYsIwCPl82pxR/UiahOmC
         8x9FkcnBGWmt9MLZQYAvNS2zRoa+kTaLeyP2r1DgVqgdzheYeplGVWcJfUudLfWgtHbe
         Ntjx5AdoVqhBmMvYFPOxs827MAFXBRssRk3SQosfC6Wkv9JKNd6InDA8nw1FLI2G5bTH
         JIV7o8tWOyoF+zLaKYvnOSV/VuurMSjvZ2MWYV4jhOZN2pXqoVFzBuT6NBnwAxQljeA/
         cHd/u+7sCjdhmtJGHgz+s329LfZGd3K5uLr75lfGMx+1MXbkDsvLTLHz2vBd/z44Pv+T
         siwg==
X-Gm-Message-State: AOAM530ijA3VX74nlX7lZvdKf0jpJeFd6+XPFF29qLIUIzL2QUHxN5Ta
        +govlcQELIWTNVeBN1D3gkku+g==
X-Google-Smtp-Source: ABdhPJzlrQ23iMQyJ7qSMIsdfDcOjmChk1AmEog1+O6VThLltQPk2eB6ErYcup8UsHf8I2S5+TgpLw==
X-Received: by 2002:a05:6512:234b:: with SMTP id p11mr5393778lfu.175.1644777862408;
        Sun, 13 Feb 2022 10:44:22 -0800 (PST)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id h19sm1140453ljq.22.2022.02.13.10.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Feb 2022 10:44:21 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>
Subject: Re: [PATCH net-next v2 0/5] Add support for locked bridge ports
 (for 802.1X)
In-Reply-To: <ef92ed7a-62aa-a5d0-3656-6a918927c239@gmail.com>
References: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
 <ef92ed7a-62aa-a5d0-3656-6a918927c239@gmail.com>
Date:   Sun, 13 Feb 2022 19:44:20 +0100
Message-ID: <87pmnqa9ob.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 10:11, Florian Fainelli <f.fainelli@gmail.com> wrote:
> It makes sense that we are using the bridge layer to support 802.1x but
> this leaves behind the case of standalone ports which people might want
> to use. Once we cover the standalone ports there is also a question of
> what to do in the case of a regular Ethernet NIC, and whether it can
> actually support 802.1x properly given their MAC filtering capabilities
> (my guess is that most cannot without breaking communication with other
> stations connecting through the same port).

The only interface I can think of that would be generic enough to
support all cases is TC offloading. I.e. you could program a matchall
rule drop rule, and then later insert exceptions for authenticated
clients before the drop rule.

It feels awfully cumbersome for drivers to have to figure this out
though.

> Looking at what Broadcom Roboswitch support, the model you propose
> should be working, it makes me wonder if we need to go a bit beyond what
> can be configurable besides blocked/not-blocked and have different
> levels of strictness. These switches do the following on a per-port
> basis you can:
>
> - set the EAP destination MAC address if different than 01:80:C2:00:00:03
>
> - enable EAP frame with destination MAC address specified
>
> - set the EAP block mode:
> 	0 - disabled
> 	1 - only the frames with the EAP reserved multicast address will be
> forwarded, otherwise frames will be dropped
> 	3 - only the frames with the EAP reserved multicast address will be
> forwarded. Forwarding verifies that each egress port is enabled for EAP
> + BLK_MODE
> - set the EAP mode:
> 	0 - disabled
> 	2 - extended mode: check MAC SA, port, drop if unknown
> 	3 - simplified mode: check SA, port, trap to management if SA is unknown
>
> We have a number of vectors that can be used to accept specific MAC SA
> addresses.
>
> Then we have a global register that allows us to configure whether we
> want to allow ARP, DHCP, BPDU, RMC, RARP or the frames with the
> specified destination IP address/masks being specified. I would assume
> that the two registers allowing us to specify a destination IP/subnet
> might be used to park unauthenticated stations to a "guest" VLAN maybe?
>
> So with that said, it looks like we may not need a method beyond just
> setting the port state. In your case, it sounds like you would program
> the mv88e6xxx switch's ATU with the MAC addresses learned from the
> bridge via the standard FDB learning notification?

The idea is that hostapd (or whatever authenticator daemon you're
running) would do the equivalent of:

    bridge fdb add <sa-of-station> [vid X] dev <port> permanent

(Vladimir can correct the flags that I have undoubtedly gotten wrong,
but you get the idea :))

Would this approach not work on a Roboswitch?

In the future, we also want to support things like MAB (mac
authentication bypass), i.e. allowing for some vetting of legacy
devices. This is a bit more complicated, because it requires a
notification from the HW about which exact address that was seen.

Our idea is to add a flag to FDB entries ("locked"), that would indicate
that a dynamic entry has been learned on a locked port. The entry must
therefore never be used to forward traffic. Its addition to the FDB will
trigger an event though, which can be noticed by a daemon that can
perform the necessary verifications. If the station is allowed, the
deamon will clear the locked flag on the FDB entry, allowing forwarding.

In a software setting, this entry will be added by the bridge when a new
SA is detected on a locked port. For switchdevs, the drivers could use
the existing way of notifying the bridge of new entries that it has
learned, except that the locked flag would be set on the entry.

So on Roboswitch, for example, I imagine you could:

- Use EAP mode 3 to trap the frames to the CPU
- Add a hardware FDB entry with a null-destination to block any further
  traps for that SA.
- Generate a locked FDB entry notification to the bridge (and by
  extension to userspace).

This will let you enforce policies like "only allow stations with OUI
02:de:ad on swp3".

> In the case of Broadcom switches, I suppose the same should be done,
> however instead of programming the main FDB, we would have to program
> the multi-port vector when the port is in blocked state. This becomes a
> switch driver detail.
>
> I would like other maintainers of switch drivers to chime in to know
> whether microchip, Qualcomm/Atheros and Mediatek have similar features
> or not.
>
> Does that make sense?
>
> Time to dust off my freeradius settings to test this out, it's been
> nearly 15 years since I last did this, time to see if EAP-TTLS or
> EAP-PEAP are more streamlined on the client side :)
