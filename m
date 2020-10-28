Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D4629D588
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbgJ1WEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729957AbgJ1WEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:04:46 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE977C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:04:44 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id y12so677558wrp.6
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=fAcPad46L4kOhBmr4o0LSEsfVA8k03ItTmQQQyQ5i9M=;
        b=avpu/FdOSE7jE/OeyOasGcNFelcErjBaQn2uMRBMj7CX/RNtrOQSncgAEjNTP41ITQ
         XvoxPfqPiWqjm0yVivECw+htOPCeRwRbvQRGiViQE0jFm92+rbzecvE+91S2Z8NpFB3m
         m6MtJtkekG/kZh+4a88GpWjczuhpnhzPnmL2Pyp19XSFjVsUr4oyAiofL8R8KREf2gms
         CPW9CVRPu0o3Gu7PMbIoJXO1x8h31u0oA20ZLsz6PUh/W3duFJrpR83MjO/tTJYj6hO9
         fb13I7+pFDLwCAtGUBxIKWZow0nhXdEkyCC/5JA0jxyt/lc1I4kUmdd0exsSiGeEURbC
         Z+cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=fAcPad46L4kOhBmr4o0LSEsfVA8k03ItTmQQQyQ5i9M=;
        b=kWzQdW8fiy8Qj2lpK6NNL5riK2Yl8sp+etsRnuh39GKRMA7XoerrJQFPF0dRHEvGXQ
         5FvmF5EfrHz5OtBHhx7Qrz3LuTvnDdVWAdHHOR4Frq0aVuYXk8uw6oIpf56GnRzAJv9T
         okEmITWr65geAmt3i6x+S7TSkVnAEZnDSNhi56wYZi/hV68ZURcTTKwVO/Tc5ab6HZt0
         jBaNtnS0ioturL3TOkgPlcwsLrhXcwQZCiXcPeAeuMfHIWCtKohm08BQIlnhzJh1E8X/
         uZJi9VWl4hDcgTWxonjEYrP0t5DiwokzWauyWcwhjq09MNIaxr1XoPjt91idydG1ENa8
         HbDg==
X-Gm-Message-State: AOAM5329BbJoHsTgUEwpFThknE6fjZeVutiG/bQeCwpnpEN1JTkM+Er9
        BbCqD0KjkqLsvPw/5gTXqnahkWQMBDS3gmDS
X-Google-Smtp-Source: ABdhPJwhWOCw5Uko/bXcagqfkukrIvlEgaoTa/kRm/OWDDI0QLdyRx76ntVAM16mfG8P3Tcw3r1CuQ==
X-Received: by 2002:ac2:4903:: with SMTP id n3mr1632135lfi.490.1603844836537;
        Tue, 27 Oct 2020 17:27:16 -0700 (PDT)
Received: from wkz-x280 (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id 134sm291962lfn.157.2020.10.27.17.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 17:27:15 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Marek Behun <marek.behun@nic.cz>,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
In-Reply-To: <20201027223205.bhwb7sl33cnr5glq@skbuf>
References: <20201027105117.23052-1-tobias@waldekranz.com> <20201027160530.11fc42db@nic.cz> <20201027152330.GF878328@lunn.ch> <87k0vbv84z.fsf@waldekranz.com> <20201027190034.utk3kkywc54zuxfn@skbuf> <87blgnv4rt.fsf@waldekranz.com> <20201027200220.3ai2lcyrxkvmd2f4@skbuf> <878sbrv19i.fsf@waldekranz.com> <20201027223205.bhwb7sl33cnr5glq@skbuf>
Date:   Wed, 28 Oct 2020 01:27:14 +0100
Message-ID: <875z6vurdp.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 00:32, Vladimir Oltean <olteanv@gmail.com> wrote:
> And this all happens because for FROM_CPU packets, the hardware is
> configured in mv88e6xxx_devmap_setup to deliver all packets with a
> non-local switch ID towards the same "routing" port, right?

Precisely.

> Whereas for FORWARD frames, the destination port for non-local switch ID
> will not be established based on mv88e6xxx_devmap_setup, but based on
> FDB lookup of {DMAC, VID}. In the second case above, this is the only
> way for your hardware that the FDB could select the LAG as the
> destination based on the FDB. Then, the hash code would be determined
> from the packet, and the appropriate egress port within the LAG would be
> selected.

That's it!

> What do you mean? skb->offload_fwd_mark? Or are you still talking about
> its TX-side equivalent here, which is what we've been talking about in
> these past few mails? If so, I'm confused by you calling it "offload
> forwarding of packets", I was expecting a description more in the lines
> of "offload flooding of packets coming from host" or something like
> that.

I'm still talking about the TX-equivalent. I chose my words carefully
because it is not _only_ for flooding, although that is the main
benefit.

If I've understood the basics of macvlan offloading correctly, it uses
the ndo_dfwd_add/del_station ops to ask the lower device if it can
offload transmissions on behalf of the macvlan device. If the lower is
capable, the macvlan code will use dev_queue_xmit_accel to specify that
the skb is being forwarded from a "subordinate" device. For a bridge,
that would mean "forward this packet to the relevant ports, given the
current configuration".

This is just one possible approach though.

>> In the case of mv88e6xxx that would kill two birds with one stone -
>> great! In other cases you might have to have the DSA subsystem listen to
>> new neighbors appearing on the bridge and sync those to hardware or
>> something. Hopefully someone working with that kind of hardware can
>> solve that problem.
>
> If by "neighbors" you mean that you bridge a DSA swp0 with an e1000
> eth0, then that is not going to be enough. The CPU port of swp0 will
> need to learn not eth0's MAC address, but in fact the MAC address of all
> stations that might be connected to eth0. There might even be a network
> switch connected to eth0, not just a directly connected link partner.
> So there are potentially many MAC addresses to be learnt, and all are
> unknown off-hand.

Yep, hence the "technically possible, but hard" remark I made earlier :)

> I admit I haven't actually looked at implementing this, but I would
> expect that what needs to be done is that the local (master) FDB of the
> bridge (which would get populated on the RX side of the "foreign
> interface" through software learning) would need to get offloaded in its
> entirety towards all switchdev ports, via a new switchdev "host FDB"
> object or something of that kind (where a "host FDB" entry offloaded on
> a port would mean "see this {DMAC, VID} pair? send it to the CPU").
>
> With your FORWARD frames life-hack you can eschew all of that, good for
> you. I was just speculatively hoping you might be interested in tackling
> the hard way.

Being able to set host FDB entries like we can for host MDB is useful
for other things as well, so I might very well be willing to do it.

> Anyway, this discussion has started mixing up basic stuff (like
> resolving your source address learning issue on the CPU port, when
> bridged with a foreign interface) with advanced / optimization stuff
> (LAG, offload flooding from host), the only commonality appearing to be
> a need for FORWARD frames. Can you even believe we are still commenting
> on a series about something as mundane as link aggregation on DSA user
> ports? At least I can't. I'll go off and start reviewing your patches,
> before we manage to lose everybody along the way.

Agreed, we went deep down the rabbit hole! This might not have been the
most natural place for these discussions, but it was fun nonetheless :)
