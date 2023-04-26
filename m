Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7766EFBF2
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 22:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239906AbjDZUy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 16:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239901AbjDZUy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 16:54:56 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4933F19F
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 13:54:55 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-2f58125b957so6979300f8f.3
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 13:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682542494; x=1685134494;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ztSndFm2Ayvv5+WLFUlzd84XLiS56D3dhlgg/USNjGE=;
        b=SVL2tsuqsvmWMy3Hnun9/iPKHnkXgUXpV8Eulg3e0GGfmk4/oYCmrO4EpZQnh3bCMT
         DyO50DX4vu6VgBvECwkRfWYqxOdV14lkG1y04KC7eg3ltOhH1kWcHdvLfmaBbnR6kmK1
         prWgtp0PjHhiu1JfOMeB4WlBzJKSDOgn+o8knk/ZKutApVC/uU+q24Z7uSHfD4o1AqQk
         HVFOo61BA+K9TLd9A6j7tjidcq6bJ4zAdHoW7N1wzA1zuEpjM6tzBpKO6Ki+8gZ9xm/K
         PIoPkLJYWUSBm1olLSgLbjPLa3ne5bobj7UNwR7IRdLjL6lTTmgNiARhBxNBU/7Rdbz3
         RF4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682542494; x=1685134494;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ztSndFm2Ayvv5+WLFUlzd84XLiS56D3dhlgg/USNjGE=;
        b=HCjvg4o/ZrRsd8DqhNSdsf1sM8cHzLuC5AktD2MDsINdRE85BHHMHBcq9nNmPRsd0T
         D3N9ktVv82r1yemXeEAP0sDzVPBOTur343MwrWHM8lQbhVE39hCfJK8OufSVvgBCYxxe
         coQSUtbeM8OVvk/ubeTHbqJ3nXtuTiF0DL2RHxJimogVFm8hedatuAQ92YTIGHgKZwKR
         +XCXzfWP3/UZnc3RH9m35XmXLZP8RieoVtDo+qc3QRq1pxsfI+PS52+dQpcbHVkpN6ad
         VMSRPXbdcrwLQK70v1Xk3IDDEaZ4SaC6MYevlPW6XUtoFcyoAX5BON2TSBgBwbUpIp4O
         LtTA==
X-Gm-Message-State: AAQBX9ept0VLqAwvKqZnb2+tTEBMKQ5UsDNtXP2SrOX7O2tY4kufmazD
        hPfZSGglwakP2u8laASWUiE=
X-Google-Smtp-Source: AKy350af2tJQ4pyicDT4Hgq0hVW3jiiU3+GVRrqgWXITKd7qB7MibgDtDPSM7TW+mj6ZSM5Ensrxog==
X-Received: by 2002:a5d:49c9:0:b0:2f4:a3ea:65d2 with SMTP id t9-20020a5d49c9000000b002f4a3ea65d2mr16159609wrs.57.1682542493377;
        Wed, 26 Apr 2023 13:54:53 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id l7-20020a5d4bc7000000b002fefe2edb72sm16686670wrt.17.2023.04.26.13.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 13:54:53 -0700 (PDT)
Date:   Wed, 26 Apr 2023 23:54:50 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     DENG Qingfang <dqfext@gmail.com>, Greg Ungerer <gerg@kernel.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, bartel.eerdekens@constell8.be,
        netdev <netdev@vger.kernel.org>
Subject: Re: MT7530 bug, forward broadcast and unknown frames to the correct
 CPU port
Message-ID: <20230426205450.kez5m5jr4xch7hql@skbuf>
References: <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
 <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
 <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 06:22:41PM +0300, Arınç ÜNAL wrote:
> Hey there folks,
> 
> On mt753x_cpu_port_enable() there's code [0] that sets which port to forward
> the broadcast, unknown multicast, and unknown unicast frames to. Since
> mt753x_cpu_port_enable() runs twice when both CPU ports are enabled, port 6
> becomes the port to forward the frames to. But port 5 is the active port, so
> no broadcast frames received from the user ports will be forwarded to port
> 5. This breaks network connectivity when multiple ports are being used as
> CPU ports.
> 
> My testing shows that only after receiving a broadcast ARP frame from port 5
> then forwarding it to the user port, the unicast frames received from that
> user port will be forwarded to port 5. I tested this with ping.
> 
> Forwarding broadcast and unknown unicast frames to the CPU port was done
> with commit 5a30833b9a16 ("net: dsa: mt7530: support MDB and bridge flag
> operations"). I suppose forwarding the broadcast frames only to the CPU port
> is what "disable flooding" here means.

Flooding means forwarding a packet that does not have a precise destination
(its MAC DA is not present in the FDB or MDB). Flooding is done towards
the ports that have flooding enabled.

> 
> It’s a mystery to me how the switch classifies multicast and unicast frames
> as unknown. Bartel's testing showed LLDP frames fall under this category.

What is mysterious exactly? What's not in the FDB/MDB is unknown. And
DSA, unless the requirements from dsa_switch_supports_uc_filtering() and
dsa_switch_supports_mc_filtering() are satisfied, will not program MAC
addresses for host RX filtering to the CPU port(s).

This switch apparently has the option to automatically learn from the MAC SA
of packets injected by software. That option is automatically enabled
unless MTK_HDR_XMIT_SA_DIS is set (which currently it never is).

So when software sends a broadcast ARP frame from port 5, the switch
learns the MAC SA of this packet (which is the software MAC address of
the user port) and it associates it with port 5. So future traffic
destined to the user port's software MAC address now reaches port 5, the
active CPU port (and the real CPU port from DSA's perspective).

Wait 5 minutes for the learned FDB entry to expire, and the problem will
probably be back.

LLDP frames should not obey the same rules. They are sent to the MAC DA
of 01:80:c2:00:00:0e, which is in the link-local multicast address space
(hence the "LL" in the name), and which according to IEEE 802.1Q-2018 is
the "Nearest Bridge group address":

| The Nearest Bridge group address is an address that no conformant TPMR
| component, S-VLAN component, C-VLAN component, or MAC Bridge can
| forward. PDUs transmitted using this destination address, or any of the
| other addresses that appear in all three tables, can therefore travel no
| further than those stations that can be reached via a single individual
| LAN from the originating station. Hence the Nearest Bridge group address
| is also known as the Individual LAN Scope group address.

Removing a packet from the forwarding data plane and delivering it only
to the CPU is known as "trapping", and thus, it is not "flooding".

The MAC SA learning trick will not make port 5 see LLDP frames, since
those are not targeted towards a unicast MAC address which could be
learned.

> 
> Until the driver supports changing the DSA conduit, unknown frames should be
> forwarded to the active CPU port, not the numerically greater one. Any ideas
> how to address this and the "disable flooding" case?

I think I also signaled the reverse problem in the other thread:
https://lore.kernel.org/netdev/20230222193951.rjxgxmopyatyv2t7@skbuf/

Well, the most important step in fixing the problem would be to
politically decide which port should be the active CPU port in the case
of multiple choices, then to start fixing up the bits in the driver that
disagree with that. Having half the code think it's 5 and the other half
think it's 6 surely isn't any good.

There was a discussion in the other thread with Frank that port 6 would
be somehow preferable if both are available, but I haven't seen convincing
enough arguments yet.

> 
> There's also this "set the CPU number" code that runs only for MT7621. I'm
> not sure why this is needed or why it's only needed for MT7621. Greg, could
> you shed some light on this since you added this code with commit
> ddda1ac116c8 ("net: dsa: mt7530: support the 7530 switch on the Mediatek
> MT7621 SoC")?
> 
> There're more things to discuss after supporting changing the DSA conduit,
> such as which CPU port to forward the unknown frames to, when user ports
> under different conduits receive unknown frames. What makes sense to me is,
> if there are multiple CPU ports being used, forward the unknown frames to
> port 6. This is already the case except the code runs twice. If not, set it
> to whatever 'int port' is, which is the default behaviour already.
> 
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/mt7530.c#n1005

I suspect you may not have run sufficient tests. When there are 2 CPU
ports, both of them should be candidates for flooding unknown traffic.
Don't worry, software won't see duplicates, because the user <-> CPU port
affinity setting should restrict forwarding of the flooded frames to a
single CPU port.

You might be confused by several things about this:

	/* Disable flooding by default */
	mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | UNU_FFP_MASK,
		   BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) | UNU_FFP(BIT(port)));

First, the comment. It means to say: "disable flooding on all ports
except for this CPU port".

Then, the fact that it runs twice, unsetting flooding for the first CPU
port (5) and setting it for the second one (6). There should be no
hardware limitation there. Both BIT(5) and BIT(6) could be part of the
flood mask without any problem.

Perhaps the issue is that MT7530_MFC should have been written to all
zeroes as a first step, and then, every mt753x_cpu_port_enable() call
enables flooding to the "int port" argument.

That being said, with trapped packets, software can end up processing
traffic on a conduit interface that didn't originate from a user port
affine to it. Software (DSA) should be fine with it, as long as the
hardware is fine with it too.

The only thing to keep in mind is that the designated CPU port for
trapped packets should always be reselected based on which conduit
interface is up. Maybe lan0's conduit interface is eth0, which is up,
but its trapped packets are handled by eth1 through some previous
configuration, and eth1 went down. You don't want lan0 to lose packets.
