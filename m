Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07A40129EFC
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 09:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbfLXIav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 03:30:51 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58019 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726047AbfLXIav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 03:30:51 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 57F9E2203E;
        Tue, 24 Dec 2019 03:30:50 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 24 Dec 2019 03:30:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=feltvn
        kPILD6mfvJaVnljV6VH5w42oJrra5rPGaKvCU=; b=LCsFy47vGftR1Gx1IDBMPZ
        8vPMRRyZLlhWkI2vGYFJP6ItyHzlbTrTK6xON+M6IBraPxSfPWMuMwp1lYLuP6Yk
        X2l6g8XNRvcKdqAoXWjCPyHjuWmTD6kK8ih/1IWQLgFUSLFg2KASdbFdb1PQ1hMi
        LVEpSKOxNKFIcXB9/lLvq32c75NmZDHLSdbqc9Itjb0wyyMJDxD0DWbMPifcTFjE
        WvunXrRG/7gV2rhb+Qt07IjgP+bF16fj4+DeHKWAohEdi6caF3YA6nqM0W7m4Czw
        2soKKmmFcb6IRFT0z/7yO7czwDDMhO82jshXFRpARggGtF8dY5kIaF6mB98hCGFA
        ==
X-ME-Sender: <xms:t8wBXr19uU3yLqVovEL9kO5dMEnkO5w04WT87lQWWJD0U6KXVHAMUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvuddgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucffohhmrghinh
    epkhgvrhhnvghlrdhorhhgpdgtuhhmuhhluhhsnhgvthifohhrkhhsrdgtohhmpdhgihht
    hhhusgdrtghomhenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:t8wBXj4yft3crf-XWRNvkwYZ_4q7xU0UWq0tqyLcEay2DJpfM_syEw>
    <xmx:t8wBXnUVypgMuvEzNSc1rihTtGqG7eGaF5eMTlBUJpdYvGMlXEPfUg>
    <xmx:t8wBXtPL4_eodR48giN8ZffM1_b2t9WDjNp48FBG9Ho5_fFCvDwD5g>
    <xmx:uswBXjxrngssWKatye2SolxRMZ1aunqTYS2aOMpVyR9qXK1J0_6hYw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id DB88D8005A;
        Tue, 24 Dec 2019 03:30:46 -0500 (EST)
Date:   Tue, 24 Dec 2019 10:30:45 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC 3/3] net: dsa: mv88e6xxx: fix vlan setup
Message-ID: <20191224083045.GA895380@splinter>
References: <20191222192235.GK25745@shell.armlinux.org.uk>
 <E1ij6pq-00084C-47@rmk-PC.armlinux.org.uk>
 <562d2a65-8361-9361-f761-082ace3a77bc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <562d2a65-8361-9361-f761-082ace3a77bc@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 10:02:12AM -0800, Florian Fainelli wrote:
> +Ido,
> 
> On 12/22/2019 11:24 AM, Russell King wrote:
> > DSA assumes that a bridge which has vlan filtering disabled is not
> > vlan aware, and ignores all vlan configuration. However, the kernel
> > software bridge code allows configuration in this state.
> > 
> > This causes the kernel's idea of the bridge vlan state and the
> > hardware state to disagree, so "bridge vlan show" indicates a correct
> > configuration but the hardware lacks all configuration. Even worse,
> > enabling vlan filtering on a DSA bridge immediately blocks all traffic
> > which, given the output of "bridge vlan show", is very confusing.
> > 
> > Provide an option that drivers can set to indicate they want to receive
> > vlan configuration even when vlan filtering is disabled. This is safe
> > for Marvell DSA bridges, which do not look up ingress traffic in the
> > VTU if the port is in 8021Q disabled state. Whether this change is
> > suitable for all DSA bridges is not known.
> 
> s/DSA bridges/DSA switches/ ?
> 
> this is also safe to do with b53 switches in fact this is even desirable
> because VLAN filtering is a global attribute so if you have at least one
> bridge that spans one of your switch ports and that bridge requests
> vlan_filtering=1, you *must* have a valid VID entry for the non-bridged
> ports, or the bridged ports with vlan_filtering=0 otherwise there is no
> default VID entry programmed to ingress the frame. Today this is
> achieved by making sure that the default untagged VID 0 for non bridged
> ports is always programmed at start-up and the switch is always
> configured with VLAN awareness.
> 
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> This ties in with this commit:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2ea7a679ca2abd251c1ec03f20508619707e1749
> 
> which I believe is still correct in the sense that with Linux a bridge
> with vlan_filtering=0 also means that the bridge is not VLAN aware. Ido,
> Jiri, do you disagree?

Hi Florian,

Yes, vlan_filtering=0 means that the bridge is not VLAN aware. It's not
only about filtering at ingress / egress. The man page says "When
disabled, the bridge will not consider the VLAN tag when handling
packets." It also affects the VLAN with which FDB entries are learned
and the VLAN used for FDB lookup.

It is really problematic for switch drivers to properly support the
dynamic toggling of this option. This is why mlxsw forbids this
toggling. Either you create the bridge with VLAN filtering disabled or
enabled. Assuming I'm reading Cumulus documentation correctly, it seems
they enforce the same behavior:

https://docs.cumulusnetworks.com/cumulus-linux/Layer-2/Ethernet-Bridging-VLANs/VLAN-aware-Bridge-Mode/#convert-bridges-between-supported-modes

> This seems to be coming every now and then, so maybe it is time to
> revisit this documentation patch:
> 
> https://github.com/ffainelli/linux/commit/3fe61b1722a3b79d2e317a812c54f3afc902e5b0

Yes, I remember reviewing it. Not sure why you didn't send another
version :)
