Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6835E95C29
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 12:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbfHTKS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 06:18:28 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34562 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729378AbfHTKS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 06:18:28 -0400
Received: by mail-ed1-f65.google.com with SMTP id s49so5692260edb.1
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 03:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rMdIuNKulQ5kpGuYnWpzv0fPBvF1nNHem8YlyijlG8Y=;
        b=Q1XAU5roPH+BQAhYLDQt4gFZb4jREx+2gH0F/2bQkfmyHprNGAcsbdI/kMBlGsWlib
         noWmN1/rvx325BenoAZ71HevkEFUGq3ZnsGB9CEzZU3nG2F6SAnoINbbw7ycx+Ufa7tn
         TVAdGeEzKOqvoHlCqauaArohCqqrQqmU3KU1f0FDV+ppM0lFGNS8/MyoHd9gosOU2hyd
         rNk27f3T4Dk4z+OKqNRJB4kqRQBbD1jY/lnDwJE494JFkll1NOQg5SlVn27kQoXUVIYi
         cd6u0XsmfaQ/iAWoJjNUHRUxTgeing8X/sevdTaLnfFnzAIh6hutYhO1IfxH89K5ZqK9
         F3VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rMdIuNKulQ5kpGuYnWpzv0fPBvF1nNHem8YlyijlG8Y=;
        b=rj3WDedJl+NQbwSrY/0QIJbJ05Sjc3ipWjzXORKePhSVsnoR/tKTUA/D+Rp/RupGH0
         5Ap/yibpvP5W+YGAH6829mEnI53V6HaDeEGxQMpv6lYwfpChGEt9AMP81LRVLpPmKTuZ
         qqKGphrmhAkPEWZWCfmE2LkgPjaILkccOUAvCNMgF+2ke+dtll7WYipxHKiMhN+MGZpN
         WscE+jC79TKdvgkfkkv/5fulD03fRaljAVjC0hk3pTTd9QCnQ/dlBGEBwRlGnf+X4i+t
         y6F/zchuFXX1sXfQSRYJmXuU8zUoE0FtKUALuuTukCkHTFgy7LX7/UU41zVla98BCVQX
         OZVA==
X-Gm-Message-State: APjAAAUol4Tx+nu9UCE0Rjll/lkN2mjB4TQXZ+9hqBl19Lfa6insDoS9
        sESMFx7lln9+8wQw8J2R0B5pBUxAft5smxnHq8o=
X-Google-Smtp-Source: APXvYqy9V4h1pAM0UxGjHqw8b2/sFKWdzMtpJddzJRsPPRo+pKTR7e3HyGXq+L6iPlQCZSqaWtUMQ3Y6RxeUF1whKzs=
X-Received: by 2002:a05:6402:124f:: with SMTP id l15mr29801117edw.140.1566296306645;
 Tue, 20 Aug 2019 03:18:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190820000002.9776-1-olteanv@gmail.com> <20190820040443.GB4919@t480s.localdomain>
In-Reply-To: <20190820040443.GB4919@t480s.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 20 Aug 2019 13:18:15 +0300
Message-ID: <CA+h21hqMRG0Ai+KBsft_0uKDSBr4FQaO+tM+sNtm32_ekwdziA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/6] Dynamic toggling of vlan_filtering for
 SJA1105 DSA
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Aug 2019 at 11:04, Vivien Didelot <vivien.didelot@gmail.com> wrote:
>
> On Tue, 20 Aug 2019 02:59:56 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> > This patchset addresses a few limitations in DSA and the bridge core
> > that made it impossible for this sequence of commands to work:
> >
> >   ip link add name br0 type bridge
> >   ip link set dev swp2 master br0
> >   echo 1 > /sys/class/net/br0/bridge/vlan_filtering
> >
> > Only this sequence was previously working:
> >
> >   ip link add name br0 type bridge vlan_filtering 1
> >   ip link set dev swp2 master br0
>
> This is not quite true, these sequences of commands do "work". What I see
> though is that with the first sequence, the PVID 1 won't be programmed in
> the hardware. But the second sequence does program the hardware.
>
> But following bridge members will be correctly programmed with the VLAN
> though. The sequence below programs the hardware with VLAN 1 for swp3 as
> well as CPU and DSA ports, but not for swp2:
>
>     ip link add name br0 type bridge
>     ip link set dev swp2 master br0
>     echo 1 > /sys/class/net/br0/bridge/vlan_filtering
>     ip link set dev swp3 master br0
>
> This is unfortunately also true for any 802.1Q VLANs. For example, only VID
> 43 is programmed with the following sequence, but not VID 1 and VID 42:
>
>     ip link add name br0 type bridge
>     ip link set dev swp2 master br0
>     bridge vlan add dev swp2 vid 42
>     echo 1 > /sys/class/net/br0/bridge/vlan_filtering
>     bridge vlan add dev swp2 vid 43
>
> So I understand that because VLANs are not propagated by DSA to the hardware
> when VLAN filtering is disabled, a port may not be programmed with its
> bridge's default PVID, and this is causing a problem for tag_8021q.
>
> Please reword so that we understand better what is the issue being fixed here.
>

Not exactly, no.
The fact that a port in DSA is not programmed with the bridge's
default_pvid is just a fact.
Right now, letting the bridge install the default_pvid into the ports
even breaks dsa_8021q when enslaving the ports to a vlan_filtering=0
bridge, but that is perhaps only a timing issue and can be resolved in
other ways.

To understand my issue I need to make a side-note.
The sja1105 needs to be reset at runtime for changing some settings. I
am working on a separate patchset that tries to make those switch
resets as seamless as possible. The end goal is to not disrupt
linuxptp (ptp4l, phc2sys) operation when enabling the tc-taprio
offload. That means:
- saving and restoring the PTP time after reset
- preventing switch reset to happen during TX timestamping
- preventing any clock operation on the PTP timer during switch reset
Since toggling vlan_filtering also needs to reset the switch, I am
simply using that as a handy tool to test how seamless the switch
reset is.
But currently, toggling vlan_filtering breaks traffic, due to nobody
restoring the correct (from the bridge's perspective) pvid on the
ports. So I need to fix this to continue the testing.
On the user ports, I can just query the bridge, and that's exactly
what I'm doing.
On the CPU and DSA ports, I can't query the bridge because the bridge
knows nothing about them. And I also can't query the pvid from the DSA
core - it can change it, but not know what it is. So I need to be
proactive and make DSA avoid changing their pvid needlessly.
With this set of changes, the goal was for traffic to 'just work' when
changing the vlan_filtering setting back and forth. This would also
benefit other future users of dsa_8021q.
There is still work to be done. dsa_8021q uses VID range 1024-2559
privately. If the bridge had been using any VLAN in that range during
vlan_filtering=1, then dsa_8021q should also restore that VLAN.
Currently I'm not doing that because I'm still not clear whether it's
just as simple as calling br_vlan_get_info(slave, {rx,tx}_vid,
&vinfo); and adding that back (I don't completely understand the
interaction with the implicit rules on the CPU ports - I am concerned
that if the switch driver sees the VID is already installed on the CPU
port, it will just skip the command).
Ido Schimmel mentioned that static FDB entries with VLAN != PVID need
to be preserved. I am already doing something in that direction there
- in vlan_filtering=0 mode I am switching to shared VLAN learning
mode. This means the switch is ignoring the VLAN from the FDB entries,
and just uses the DMAC for L2 routing. When going back to the
vlan_filtering=1 mode, the VLAN from the static FDB entries goes back
in use. I think that's ok.
There is also stuff that cannot be reasonably expected to be preserved
across switch resets. Learned FDB entries is one thing. Traffic
(including regular, but not management, traffic originated from the
CPU) will be temporarily dropped.

> >
> > On SJA1105, the situation is further complicated by the fact that
> > toggling vlan_filtering is causing a switch reset. However, the hardware
> > state restoration logic is already there in the driver. It is a matter
> > of the layers above which need a few fixups.
> >
> > Also see this discussion thread:
> > https://www.spinics.net/lists/netdev/msg581042.html
> >
> > Patch 1/6 is not functionally related but also related to dsa_8021q
> > handling of VLANs and this is a good opportunity to bring up the subject
> > for discussion.
>
> So please send 1/6 as a separate patch and bring up the discussion there.
>

Ok.

>
> Thanks,
>
>         Vivien

Regards,
-Vladimir
