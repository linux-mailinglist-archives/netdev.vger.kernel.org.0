Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439CC6CDA40
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 15:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjC2NQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 09:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjC2NQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 09:16:21 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12CB26BA;
        Wed, 29 Mar 2023 06:16:17 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id t10so62976096edd.12;
        Wed, 29 Mar 2023 06:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680095776;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DwJSuS4piQ0HvL3T/KfLrqCp6d69uaw8sTU8PI6GsgM=;
        b=oY29iafcZxccEXftwGIHucchBe9ICOpxvmRfOfNuKMYrSKsDEmRZ5mEuMY0RE0ExzF
         8khFSxbQ0T8ZoVvWE8F6cT5X6Agy/k0x6rLp/pP0cSQ6mAA0AW50wf1NEilY7UjjS5jA
         MUexSxVKHzJp2ea2UwWJSVcxoHw7CaqzRL4FDtNMT9LS2FuwvgqSvAOAFlQZbEKC1DQt
         vcGxA9w45RVS6dlRKkxvlrM7TSnjilAi26ImckecdXCCNInnGauI7bdb2ncmv6u+OYiJ
         Ycyh0+xpJlG00utpiNW7Tue+q/aakjlT+ALdUJIdFQps1pZlMcq6jJdHeeNKl8aKuZOB
         pRpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680095776;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DwJSuS4piQ0HvL3T/KfLrqCp6d69uaw8sTU8PI6GsgM=;
        b=IWf5+MSEY4cTp8ef7va00SnumEfTwtaA2vr1EHFKACdEdCeaRHjbJbQLMrRr0raeg+
         S4HL2mQhCs19sNZLpGZVmsrvFuSdKK5miJKk++DkOkOB1jiFP+2fV4clSt7zyaWzpgyq
         T8645gP6uUldptVuVfoH07O+9jYFLFKLTmMp7hdIZJbM/JyBXvM8d5bprjm9fChqIFW4
         wefw/bV1uX5jXDHr41h0/g09p3oOfB28r0hBSrMN8eDPWZYSPcJuttFs/8VOUKrRgwh+
         9BZz37Osdbu0CTWBOAvhzwvSFAmIksBqis/duyC8Xbx8ufIbrBmrW40dVOR7oxNzrvWN
         GOUg==
X-Gm-Message-State: AAQBX9cL50XNkjBhtrHsOyg8K8kokfFRGFPykc4Rh3jQqpxpRrR26S3+
        QwEN1iADtDh6mWMhsG8lKOg=
X-Google-Smtp-Source: AKy350YBH5qAE1fkenQg1U0S5e4LDdNYrwGApTKD39ArcdtBQoAhuP36DflVgKsH9UcWDuS3pH+iqw==
X-Received: by 2002:a17:906:6449:b0:8eb:d3a5:b9f0 with SMTP id l9-20020a170906644900b008ebd3a5b9f0mr19623080ejn.67.1680095776017;
        Wed, 29 Mar 2023 06:16:16 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id c19-20020a170906155300b0093ebc654f78sm6376241ejd.25.2023.03.29.06.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 06:16:15 -0700 (PDT)
Date:   Wed, 29 Mar 2023 16:16:13 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND net-next v4 3/3] net: dsa: rzn1-a5psw: add vlan
 support
Message-ID: <20230329131613.zg4whzzoa4yna7lh@skbuf>
References: <20230324220042.rquucjt7dctn7xno@skbuf>
 <20230314163651.242259-1-clement.leger@bootlin.com>
 <20230314163651.242259-1-clement.leger@bootlin.com>
 <20230314163651.242259-4-clement.leger@bootlin.com>
 <20230314163651.242259-4-clement.leger@bootlin.com>
 <20230314233454.3zcpzhobif475hl2@skbuf>
 <20230315155430.5873cdb6@fixe.home>
 <20230324220042.rquucjt7dctn7xno@skbuf>
 <20230328104429.5d2e475a@fixe.home>
 <20230328104429.5d2e475a@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230328104429.5d2e475a@fixe.home>
 <20230328104429.5d2e475a@fixe.home>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 10:44:29AM +0200, Clément Léger wrote:
> > And, I guess, if BIT(port) is unset in VLAN_IN_MODE_ENA, then untagged
> > packets will not see any hit in the VLAN resolution table.
> > But, if VLAN_IN_MODE_ENA contains BIT(port) and VLAN_IN_MODE is set to,
> > say, TAG_ALWAYS for BIT(port), then all frames (including untagged
> > frames) will get encapsulated in the VLAN from SYSTEM_TAGINFO[port].
> > In that case, the packets will always hit the VLAN resolution table
> > (assuming that the VID from $SYSTEM_TAGINFO[port] was installed there),
> 
> Yes, indeed and when adding a PVID, the documentation states that the
> port must also be a member of the VLAN ID when vlan verification is
> enabled:
> 
> In addition, if VLAN verification is enabled for a port (see Section
> 4.4.5, VLAN_VERIFY — Verify VLAN Domain), the VLAN id used for
> insertion (SYSTEM_TAGINFO[n]) must also be configured in the global
> VLAN resolution table (see Section 4.4.51, VLAN_RES_TABLE[n] — 32 VLAN
> Domain Entries (n = 0..31)), to ensure the switch accepts frames, which
> contain the inserted tag.

Ok. Is VLAN verification also bypassed by the MGMTFWD mechanism of
PATTERN_CTRL, or only the FDB table lookup? Asking for my general
knowledge; I don't think the answer will be useful to the current state
of the driver.

> > There is simply no way this can work if the MAC Address Lookup table is
> > VLAN-unaware. What should have happened is that swp0 should have not
> > been able to find the FDB entry towards swp3, because swp0 is standalone,
> > and swp3 is under a bridge.
> 
> Ok got it !

So after learning about the MGMTFWD action of the pattern matching
engine: the case described above should work. Maybe all hope is not
lost.

Although, small note, MGMTFWD is incompatible with RX filtering (IFF_UNICAST_FLT).
Since you tell the switch to send all traffic received on standalone
ports to the CPU and bypass the MAC table, then you can no longer tell
it which addresses you are interested in seeing, and you cannot use the
MAC table as an accelerator to selectively drop them.

Interesting hardware design, and interesting how the past few years of
changes made to the DSA framework don't seem to help it...

> > Okay. Disabling address learning on standalone ports should help with
> > some use cases, like when all ports are standalone and there is no
> > bridging offload.
> 
> Based on my previous comment, if I remove standalone ports from the
> flooding mask, disable learning on them and if the port is fast aged
> when leaving a bridge, it seems correct to assume this port will never
> receive nor forward packets from other port and also thanks to the
> matching rule we set for standalone ports, it will only send packets to
> CPU port. Based on that I think I can say that the port will be truly
> standalone. This also allows to keep the full 32 VLANs available for
> stadnard operations.

Seems correct.

> > > Does this means I don't have to be extra careful when programming it ?  
> > 
> > Actually, no :) you still do.
> > 
> > What I don't think will work in your current setup of the hardware is this:
> > 
> >  br0  (standalone)
> >   |      |
> >  swp0   swp1
> > 
> > ip link add br0 type bridge vlan_filtering 1 && ip link set br0 up
> > ip link set swp0 master br0 && ip link set swp0 up
> > bridge vlan add dev swp0 vid 100
> > bridge fdb add 00:01:02:03:04:05 dev swp0 master static
> > 
> > and then connect a station to swp1 and send a packet with
> > { MAC DA 00:01:02:03:04:05, VID 100 }. It should only reach the CPU port
> > of the switch, but it also leaks to swp0, am I right?
> 
> Actually, it won't leak to swp0 since, since we enable a specific
> matching rule (MGMTFWD) for the standalone ports which ensure all the
> lookup is bypassed and that the trafic coming from these ports is only
> forwarded to the CPU port (see my comment at the end of this mail).

I agree, this makes sense.

> > I think the UCAST_DEFAULT_MASK/MCAST_DEFAULT_MASK/BCAST_DEFAULT_MASK
> > flooding destination masks are useless, because they are not keyed per
> > source port, but global.
> > 
> > - each port under a bridge which is currently VLAN-unaware should use
> >   the same technique as for standalone ports, which is to set
> >   SYSTEM_TAGINFO[port] to a reserved value, common for all ports under
> >   the same bridge. That value can even be the standalone PVID of the
> >   first port that joined the VLAN-unaware bridge. This way, you would
> >   need to reserve no more than 4 VLANs, and you would keep reusing them
> >   also for VLAN-unaware bridging.
> 
> However I did not thought about this part :) Indeed makes sense and
> allows to use only 4 VLAN at most out of the 32s. By the way, this
> bridge supports only a single bridge due to some registers being common
> to all ports and not per bridge (flooding for instance...).

I searched to see whether it is possible to control the flooding per
VLAN, in the off-chance that we decided to support multiple VLAN-unaware
bridges by allocating one VLAN per bridge. It looks like VLAN_RES_TABLE[n]
doesn't support this. Frames classified to a VLAN which don't hit any
entry in the MAC table are flooded to all ports in that VLAN. Strange!

I think this might be the actual insurmountable reason why the driver
will never get support for multiple bridges. It would be good to even
add a comment about this in the next patch set, so that any Renesas
hardware design engineers who might be reading will take note.

> After thinking about the current mechasnim, let me summarize why I
> think it almost matches what you described in this last paragraph:
> 
> - Port is set to match a specific matching rule which will enforce port
>   to CPU forwarding only based on the MGMTFWD bit of PATTERN_CTRL which
>   states the following: "When set, the frame is forwarded to the
>   management port only (suppressing destination address lookup)"
> 
> This means that for the "port to CPU" path when in standalone mode, we
> are fine. Regarding the other "CPU to port" path only:
> 
> - Learning will be disabled when leaving the bridge. This will allow
>   not to have any new forwarding entries in the MAC lookup table.
> 
> - Port is fast aged which means it won't be targeted for packet
>   forwarding.
> 
> - We remove the port from the flooding mask which means it won't be
>   flooded after being removed from the port.
> 
> Based on that, the port should not be the target of any forward packet
> from the other ports. Note that anyway, even if using per-port VLAN for
> standalone mode, we would also end up needing to disable learning,
> fast-age the port and disable flooding (at least from my understanding
> if we want the port to be truly isolated).
> 
> Tell me if it makes sense.

This makes sense.

However, I still spotted a bug and I don't know where to mention it
better, so I'll mention it here:

a5psw_port_vlan_add()

	if (pvid) {
		a5psw_reg_rmw(a5psw, A5PSW_VLAN_IN_MODE_ENA, BIT(port),
			      BIT(port));
		a5psw_reg_writel(a5psw, A5PSW_SYSTEM_TAGINFO(port), vid);
	}

You don't want a5psw_port_vlan_add() to change VLAN_IN_MODE_ENA, because
port_vlan_add() will be called even for VLAN-unaware bridges, and you
want all traffic to be forwarded as if untagged, and not according to
the PVID. In other words, in a setup like this:

ip link add br0 type bridge vlan_filtering 0 && ip link set br0 up
ip link set swp0 master br0 && ip link set swp0 up
ip link set swp1 master br0 && ip link set swp1 up
bridge vlan del dev swp1 vid 1

forwarding should still take place with no issues, because the entire
VLAN table is bypassed by the software bridge when vlan_filtering=0, and
the hardware accelerator should replicate that behavior.

I suspect that the PVID handling in a5psw_port_vlan_del() is also
incorrect:

	/* Disable PVID if the vid is matching the port one */
	if (vid == a5psw_reg_readl(a5psw, A5PSW_SYSTEM_TAGINFO(port)))
		a5psw_reg_rmw(a5psw, A5PSW_VLAN_IN_MODE_ENA, BIT(port), 0);

VLAN-aware bridge ports without a PVID should drop untagged and VID-0-tagged
packets. However, as per your own comments:

| > What does it mean to disable PVID?
| 
| It means it disable the input tagging of packets with this PVID.
| Incoming packets will not be modified and passed as-is.

so this is not what happens.
