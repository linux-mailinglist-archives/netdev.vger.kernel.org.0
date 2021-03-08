Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2F33313F9
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 18:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhCHRAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 12:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhCHRAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 12:00:31 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C509C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 09:00:31 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id p1so15787449edy.2
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 09:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gkCM64hLJnssfSaaB2j1PAf1LAOO1mtVH71E2ekhHW0=;
        b=DHSIHlMs4WZhsxgyXR1awrMwxd9yJzpLo0j7LSC0/l5tGUWW9hizcfjRgQUsW3u19v
         LEx3sC/JwWPqqRklGd4oFTJTu2RysJgp3lyt9aC6OVoaqBxle+9/RjLP+6eKrZXYaCi+
         cs/t9lBaiO1Z+B7EpPzKjP0H1jtgb1O5jWL0pN0roJ5svJJdL9lKZHuL9LJnHG81SUs3
         nvS97jcKp7D5YdXaWqaPc8nQEwiErzPvZdP48FGBEBCVUIMJop3diLdJjCBis86aocdz
         +pJc9NpFNTH8yKRly6glwyd2xut+mCF8/hwkbOMSgnXb9rhPrrXk0mqyEkjg4g5t3V3g
         HDTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gkCM64hLJnssfSaaB2j1PAf1LAOO1mtVH71E2ekhHW0=;
        b=TvrFwBlyFnVisa7IcQO1dKjgI/0WAG8R3hKipmdgdZAZZr2sCTHAdD/yi1/G8a7wxv
         aSlIiXI1tyAB2RFsvGo6euAEih9CEwbJHM5dRA0y8kFUBPLCI4zmBoWFH1pml7PPqq1T
         tsrhqrBhwuJ0b9PnrY+htVSTBrSq97OhCsyoGOmztmeseEgMIoovZPkKdlo7ArIhyIIH
         C4Bfo3OKktg1ei+/8YfUlDrDKwGq6ZkLCFv4K/Msfl5Ll37cteboBNzSXDCDjH4riaYt
         wWZgMIbS5UQQv1bE+H/5CE42lyOI+DzM1ovtdHNgI7w2y2OqjpoIF/EAwO4tO4ylrNef
         PGMw==
X-Gm-Message-State: AOAM531Z0orRcP684VpGaCl4XPLdwVE9XqUt90i9egkPu30Utxfb1A/9
        +AH7i/ChNp238HLE57zUs4A=
X-Google-Smtp-Source: ABdhPJyyKzYWdE8GY3d5XLEGjveYIdct6qUQS32AsJ+23Fl1Zv7o19x53FmTpWrmpuzHYnL43OHxYw==
X-Received: by 2002:aa7:cf17:: with SMTP id a23mr23840166edy.30.1615222829750;
        Mon, 08 Mar 2021 09:00:29 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id x25sm7321614edv.65.2021.03.08.09.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 09:00:29 -0800 (PST)
Date:   Mon, 8 Mar 2021 19:00:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: dsa: Accept software VLANs for stacked
 interfaces
Message-ID: <20210308170027.jdehraoyntgqkjo4@skbuf>
References: <20210308150405.3694678-1-tobias@waldekranz.com>
 <20210308150405.3694678-2-tobias@waldekranz.com>
 <20210308154446.ceqp56bh65bsarlt@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308154446.ceqp56bh65bsarlt@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 08, 2021 at 05:44:46PM +0200, Vladimir Oltean wrote:
> On Mon, Mar 08, 2021 at 04:04:04PM +0100, Tobias Waldekranz wrote:
> > The dsa_slave_vlan_rx_{add,kill}_vid ndos are required for hardware
> > that can not control VLAN filtering per port, rather it is a device
> > global setting, in order to support VLAN uppers on non-bridged ports.
> > 
> > For hardware that can control VLAN filtering per port, it is perfectly
> > fine to fallback to software VLANs in this scenario. So, make sure
> > that this "error" does not leave the DSA layer as vlan_add_vid does
> > not know the meaning of it.
> > 
> > The blamed commit removed this exemption by not advertising the
> > feature if the driver did not implement VLAN offloading. But as we
> > know see, the assumption that if a driver supports VLAN offloading, it
> > will always use it, does not hold in certain edge cases.
> > 
> > Fixes: 9b236d2a69da ("net: dsa: Advertise the VLAN offload netdev ability only if switch supports it")
> > Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> > ---
> 
> So these NDOs exist for drivers that need the 'rx-vlan-filter: on'
> feature in ethtool -k, which can be due to any of the following reasons:
> 1. vlan_filtering_is_global = true, some ports are under a VLAN-aware
>    bridge while others are standalone (this is what you described)
> 2. Hellcreek. This driver needs it because in standalone mode, it uses
>    unique VLANs per port to ensure separation. For separation of untagged
>    traffic, it uses different PVIDs for each port, and for separation of
>    VLAN-tagged traffic, it never accepts 8021q uppers with the same vid
>    on two ports.
> 3. the ports that are under a VLAN-aware bridge should also set this
>    feature, for 8021q uppers having a VID not claimed by the bridge.
>    In this case, the driver will essentially not even know that the VID
>    is coming from the 8021q layer and not the bridge.
> 
> If a driver does not fall under any of the above 3 categories, there is
> no reason why it should advertise the 'rx-vlan-filter' feature, therefore
> no reason why it should implement these NDOs, and return -EOPNOTSUPP.
> 
> We are essentially saying the same thing, except what I propose is to
> better manage the 'rx-vlan-filter' feature of the DSA net devices. After
> your patches, the network stack still thinks that mv88e6xxx ports in
> standalone mode have VLAN filtering enabled, which they don't. That
> might be confusing. Not only that, but any other driver that is
> VLAN-unaware in standalone mode will similarly have to ignore VLANs
> coming from the 8021q layer, which may add uselessly add to their
> complexity. Let me prepare an alternative patch series and let's see how
> they compare against each other.
> 
> As far as I see, mv88e6xxx needs to treat the VLAN NDOs in case 3 only,
> and DSA will do that without any sort of driver-level awareness. It's
> all the other cases (standalone ports mode) that are bothering you.

So I stopped from sending an alternative solution, because neither mine
nor yours will fix this situation:

ip link add link lan0 name lan0.100 type vlan id 100
ip addr add 192.168.100.1/24 dev lan0.100
ping 192.168.100.2 # should work
ip link add br0 type bridge vlan_filtering 0
ip link set lan0 master br0
ping 192.168.100.2 # should still work
ip link set br0 type bridge vlan_filtering 1
ping 192.168.100.2 # should still work

Basically my point is that you disregard the vlan_vid_add from the
lan0.100 upper now because you think you don't need it, but one day will
come when you will. We've had that problem for a very long while now
with bridge VLANs, and it wasn't even completely solved yet (that's why
ds->configure_vlan_while_not_filtering is still a thing). It's
fundamentally the same with VLANs added by the 8021q layer. I think you
should see what you can do to make mv88e6xxx stop complaining and accept
the VLANs from the 8021q uppers even if they aren't needed right away.
It's a lot easier that way, otherwise you will end up having to replay
them somehow.
