Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E204B2C71
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 19:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344969AbiBKSLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 13:11:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343603AbiBKSLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 13:11:43 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58501CEC
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 10:11:41 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id n23so17699787pfo.1
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 10:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lv7R3Q3x9ck0qdDSMJ1QDG0mFqc1t/sArCXuJamGcF8=;
        b=D5sh5y2bf2OVRth5BqevA+RcrVU7pa6p3eN15qgl/Rabx4ao8Z5BCFbkvNOctRAzxb
         RHwl/iEvlPS2igBmD51YHjKpKoGSpp/7L2KBKwZKBYZO4Gv+Opqa4TrjtCdJ2to5FvJZ
         8PIt8AILrPhF0OVvvFA76J5N+trwNRohzywiaayetv4v35aKXc7qKYN1h8UUEbA2A/y7
         Ynw85t02+nH9cp/lh1W645gYVQHr3adUcp8spUpbONzeEjBbSDao3K7fTkLa2CzX2Jmr
         j0MRl4ZMmPqblt1B0EsS6Wq9NYpBqzNS3EA/KgQU2848IJ8YHYaICIObdWmfaYSRwNdX
         kkgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lv7R3Q3x9ck0qdDSMJ1QDG0mFqc1t/sArCXuJamGcF8=;
        b=B3basJcSNjtAsuZr6VAW22JS3nM/WjBLgRZLcJZaPwBNKsE4LesHgwLBH6YJwmEkDu
         9SxxF/KTkNyYBGyUR0mwprK5rgIQVtIyWilN5Y1c+q/GW9nK6/Jj26lLG+edFhWAFSOL
         MgvIZLhvX9MwaBMNKx7t52T91n1Yzs/2Sb/ZLLUeH9C5fqA5ZPaNvQzy3Hts1LW3ZUVU
         U+dEyMqTjTGXyCEcbX4Ol0KsuEAXtO1xHdH9RyfuDXsjPoQ1yWVk97P6qjB3P/mhYQPM
         pPXSyVn/RJc+gX50zrXHK4g+KPOftkNKvX54oKQvTuJu0ZryZ92qEjDzcFcEAQcKnror
         bClA==
X-Gm-Message-State: AOAM532eBvxlSsRhVn/lpbmjKoVbj+Lt0K0Kv4At3xnZlpt/Ot9v0wnZ
        ofUYlEFMqYAs3aNvmCLpC8walaYxOtI=
X-Google-Smtp-Source: ABdhPJy4iOJfyaletV1NaDplEROtrk1bf//u7hBPM6VmeN4bG9yU2aIW74baV/DgMnpmtfMU6i5tnQ==
X-Received: by 2002:a63:c007:: with SMTP id h7mr2383477pgg.422.1644603100697;
        Fri, 11 Feb 2022 10:11:40 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id kb11sm6197079pjb.51.2022.02.11.10.11.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 10:11:40 -0800 (PST)
Subject: Re: [PATCH net-next v2 0/5] Add support for locked bridge ports (for
 802.1X)
To:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>
References: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ef92ed7a-62aa-a5d0-3656-6a918927c239@gmail.com>
Date:   Fri, 11 Feb 2022 10:11:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/22 5:05 AM, Hans Schultz wrote:
> This series starts by adding support for SA filtering to the bridge,
> which is then allowed to be offloaded to switchdev devices. Furthermore
> an offloading implementation is supplied for the mv88e6xxx driver.
> 
> Public Local Area Networks are often deployed such that there is a
> risk of unauthorized or unattended clients getting access to the LAN.
> To prevent such access we introduce SA filtering, such that ports
> designated as secure ports are set in locked mode, so that only
> authorized source MAC addresses are given access by adding them to
> the bridges forwarding database. Incoming packets with source MAC
> addresses that are not in the forwarding database of the bridge are
> discarded. It is then the task of user space daemons to populate the
> bridge's forwarding database with static entries of authorized entities.
> 
> The most common approach is to use the IEEE 802.1X protocol to take
> care of the authorization of allowed users to gain access by opening
> for the source address of the authorized host.
> 
> With the current use of the bridge parameter in hostapd, there is
> a limitation in using this for IEEE 802.1X port authentication. It
> depends on hostapd attaching the port on which it has a successful
> authentication to the bridge, but that only allows for a single
> authentication per port. This patch set allows for the use of
> IEEE 802.1X port authentication in a more general network context with
> multiple 802.1X aware hosts behind a single port as depicted, which is
> a commonly used commercial use-case, as it is only the number of
> available entries in the forwarding database that limits the number of
> authenticated clients.
> 
>       +--------------------------------+
>       |                                |
>       |      Bridge/Authenticator      |
>       |                                |
>       +-------------+------------------+
>        802.1X port  |
>                     |
>                     |
>              +------+-------+
>              |              |
>              |  Hub/Switch  |
>              |              |
>              +-+----------+-+
>                |          |
>             +--+--+    +--+--+
>             |     |    |     |
>     Hosts   |  a  |    |  b  |   . . .
>             |     |    |     |
>             +-----+    +-----+
> 
> The 802.1X standard involves three different components, a Supplicant
> (Host), an Authenticator (Network Access Point) and an Authentication
> Server which is typically a Radius server. This patch set thus enables
> the bridge module together with an authenticator application to serve
> as an Authenticator on designated ports.
> 
> 
> For the bridge to become an IEEE 802.1X Authenticator, a solution using
> hostapd with the bridge driver can be found at
> https://github.com/westermo/hostapd/tree/bridge_driver .
> 
> 
> The relevant components work transparently in relation to if it is the
> bridge module or the offloaded switchcore case that is in use.


It would help for future submissions if you create an union of the
people to copy for *all* patches. What I typically do is:

git format-patch *.patch
./scripts/get_maintainers.pl *.patch > cclist
git send-email *.patch --cc-cmd=cclist.sh
cat cclist.sh
#!/bin/sh
cat $(dirname $0)/cclist

or any smarter way to do that. Now on the actual changes themselves.

It makes sense that we are using the bridge layer to support 802.1x but
this leaves behind the case of standalone ports which people might want
to use. Once we cover the standalone ports there is also a question of
what to do in the case of a regular Ethernet NIC, and whether it can
actually support 802.1x properly given their MAC filtering capabilities
(my guess is that most cannot without breaking communication with other
stations connecting through the same port).

Looking at what Broadcom Roboswitch support, the model you propose
should be working, it makes me wonder if we need to go a bit beyond what
can be configurable besides blocked/not-blocked and have different
levels of strictness. These switches do the following on a per-port
basis you can:

- set the EAP destination MAC address if different than 01:80:C2:00:00:03

- enable EAP frame with destination MAC address specified

- set the EAP block mode:
	0 - disabled
	1 - only the frames with the EAP reserved multicast address will be
forwarded, otherwise frames will be dropped
	3 - only the frames with the EAP reserved multicast address will be
forwarded. Forwarding verifies that each egress port is enabled for EAP
+ BLK_MODE
- set the EAP mode:
	0 - disabled
	2 - extended mode: check MAC SA, port, drop if unknown
	3 - simplified mode: check SA, port, trap to management if SA is unknown

We have a number of vectors that can be used to accept specific MAC SA
addresses.

Then we have a global register that allows us to configure whether we
want to allow ARP, DHCP, BPDU, RMC, RARP or the frames with the
specified destination IP address/masks being specified. I would assume
that the two registers allowing us to specify a destination IP/subnet
might be used to park unauthenticated stations to a "guest" VLAN maybe?

So with that said, it looks like we may not need a method beyond just
setting the port state. In your case, it sounds like you would program
the mv88e6xxx switch's ATU with the MAC addresses learned from the
bridge via the standard FDB learning notification?

In the case of Broadcom switches, I suppose the same should be done,
however instead of programming the main FDB, we would have to program
the multi-port vector when the port is in blocked state. This becomes a
switch driver detail.

I would like other maintainers of switch drivers to chime in to know
whether microchip, Qualcomm/Atheros and Mediatek have similar features
or not.

Does that make sense?

Time to dust off my freeradius settings to test this out, it's been
nearly 15 years since I last did this, time to see if EAP-TTLS or
EAP-PEAP are more streamlined on the client side :)
