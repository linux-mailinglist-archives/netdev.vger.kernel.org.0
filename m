Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F0D36C1B2
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 11:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbhD0J2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 05:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhD0J2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 05:28:44 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A272C061574
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 02:28:01 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ja3so12665196ejc.9
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 02:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bkXVbfyTzXslA6g8B5OHGeF3+6CBeq2YX/4rC8qa19M=;
        b=Nhby/PJRRYrkOwRNFKttFii8O1vc9ei/3JlKQ2bwF5Y6XeZHALmjymmaP317VN5G+d
         Cih5qW2WFckUGsDsfZfMvkiLfpzCNwL7ahWC0f2OYyqS+FZ1omo/7e8xLQeG5jlklhIf
         mVerd8x0YI8eTSxl6QndVfhQ2ZBE1FDHVyfuIa2HKdqFzwWtqDBR/Fa60arNYX784l/L
         A1f6d4E38XG2PNdcKJG6m6IdEqSu/7zL+9cuCw0rImSr1KboCe4QftUi2Wk5Ac8y1qnR
         bdxsztqyhFOrgs4/zOSOVejeuhMsjQWk7r7ZPrToT8mwzN0dMsJlqdcqdHRIgTQol1Dv
         6mPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bkXVbfyTzXslA6g8B5OHGeF3+6CBeq2YX/4rC8qa19M=;
        b=AD+VIr3TFUJwH97+nicdEpntfizXOzlaCMA4Ta+FCw2RtwxZgSU5vTMC1pTVVCbRtE
         ZMvUen2zG5L0FmLIBwXhOV0gfq5WPp6omk5cmiWUUaVeD3PyOASX4e+ziXqSHDLRXYqP
         F/4wP2mGrW1n6SK9aX+2aVLV6yvoeF8VeTWz7kbEbfvK8yXCFjbjN8mvK8IJApkBosTW
         H1l3QVRrsezuiJmtARsWKE9a5jyX0qY2ssEV68qynwpFrK/hOEohgx+ATmo6fPkHrX2R
         6fPMaFuPXNN3pWUZM5YzNLHqoVs2W82eh+iohD4g73aydQjLwkH/ygkTy6koIDUPRtlD
         c/aQ==
X-Gm-Message-State: AOAM530mnKQOTsPMd3dF4BxA0j7ABrxzKkCS7iuBEkuriFVF/ca1Xaj3
        Q3s2YjDKpEoUn2I/hOTQ14w=
X-Google-Smtp-Source: ABdhPJxMhJ8WplTaT8Lhahz/CkgupAh/QXq3Z+ozGRWAW5RjyejZ9FworIqcheBWxLqlIYVFxyLhEQ==
X-Received: by 2002:a17:906:415b:: with SMTP id l27mr22510621ejk.19.1619515680022;
        Tue, 27 Apr 2021 02:28:00 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id lb18sm13020804ejc.6.2021.04.27.02.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 02:27:59 -0700 (PDT)
Date:   Tue, 27 Apr 2021 12:27:58 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, roopa@nvidia.com,
        nikolay@nvidia.com, jiri@resnulli.us, idosch@idosch.org,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 5/9] net: dsa: Track port PVIDs
Message-ID: <20210427092758.uejhxl7ahuulf34m@skbuf>
References: <20210426170411.1789186-1-tobias@waldekranz.com>
 <20210426170411.1789186-6-tobias@waldekranz.com>
 <20210426194026.3sr22rqyf2srrwtq@skbuf>
 <877dkoq09r.fsf@waldekranz.com>
 <20210426202800.y4hfurf5k3hrbvqf@skbuf>
 <8735vcoztz.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735vcoztz.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 11:12:56AM +0200, Tobias Waldekranz wrote:
> On Mon, Apr 26, 2021 at 23:28, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Mon, Apr 26, 2021 at 10:05:52PM +0200, Tobias Waldekranz wrote:
> >> On Mon, Apr 26, 2021 at 22:40, Vladimir Oltean <olteanv@gmail.com> wrote:
> >> > Hi Tobias,
> >> >
> >> > On Mon, Apr 26, 2021 at 07:04:07PM +0200, Tobias Waldekranz wrote:
> >> >> In some scenarios a tagger must know which VLAN to assign to a packet,
> >> >> even if the packet is set to egress untagged. Since the VLAN
> >> >> information in the skb will be removed by the bridge in this case,
> >> >> track each port's PVID such that the VID of an outgoing frame can
> >> >> always be determined.
> >> >> 
> >> >> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> >> >> ---
> >> >
> >> > Let me give you this real-life example:
> >> >
> >> > #!/bin/bash
> >> >
> >> > ip link add br0 type bridge vlan_filtering 1
> >> > for eth in eth0 eth1 swp2 swp3 swp4 swp5; do
> >> > 	ip link set $eth up
> >> > 	ip link set $eth master br0
> >> > done
> >> > ip link set br0 up
> >> >
> >> > bridge vlan add dev eth0 vid 100 pvid untagged
> >> > bridge vlan del dev swp2 vid 1
> >> > bridge vlan del dev swp3 vid 1
> >> > bridge vlan add dev swp2 vid 100
> >> > bridge vlan add dev swp3 vid 100 untagged
> >> >
> >> > reproducible on the NXP LS1021A-TSN board.
> >> > The bridge receives an untagged packet on eth0 and floods it.
> >> > It should reach swp2 and swp3, and be tagged on swp2, and untagged on
> >> > swp3 respectively.
> >> >
> >> > With your idea of sending untagged frames towards the port's pvid,
> >> > wouldn't we be leaking this packet to VLAN 1, therefore towards ports
> >> > swp4 and swp5, and the real destination ports would not get this packet?
> >> 
> >> I am not sure I follow. The bridge would never send the packet to
> >> swp{4,5} because should_deliver() rejects them (as usual). So it could
> >> only be sent either to swp2 or swp3. In the case that swp3 is first in
> >> the bridge's port list, it would be sent untagged, but the PVID would be
> >> 100 and the flooding would thus be limited to swp{2,3}.
> >
> > Sorry, _I_ don't understand.
> >
> > When you say that the PVID is 100, whose PVID is it, exactly? Is it the
> > pvid of the source port (aka eth0 in this example)? That's not what I
> > see, I see the pvid of the egress port (the Marvell device)...
> 
> I meant the PVID of swp3.
> 
> In summary: This series incorrectly assumes that a port's PVID always
> corresponds to the VID that should be assigned to untagged packets on
> egress. This is wrong because PVID only specifies which VID to assign
> packets to on ingress, it says nothing about policy on egress. Multiple
> VIDs can also be configured to egress untagged on a given port. The VID
> must thus be sent along with each packet in order for the driver to be
> able to assign it to the correct VID.
> 
> > So to reiterate: when you transmit a packet towards your hardware switch
> > which has br0 inside the sb_dev, how does the switch know in which VLAN
> > to forward that packet? As far as I am aware, when the bridge had
> > received the packet as untagged on eth0, it did not insert VLAN 100 into
> > the skb itself, so the bridge VLAN information is lost when delivering
> > the frame to the egress net device. Am I wrong?
> 
> VID 100 is inserted into skb->vlan_tci on ingress from eth0, in
> br_vlan.c/__allowed_ingress. It is then cleared again in
> br_vlan.c/br_handle_vlan if the egress port (swp3 in our example) is set
> to egress the VID untagged.
> 
> The last step only clears skb->vlan_present though, the actual VID
> information still resides in skb->vlan_tci. I tried just removing 5/9
> from this series, and then sourced the VID from skb->vlan_tci for
> untagged packets. It works like a charm! I think this is the way
> forward.
> 
> The question is if we need another bit of information to signal that
> skb->vlan_tci contains valid information, but the packet should still be
> considered untagged? This could also be used on Rx to carry priority
> (PCP) information to the bridge.

My expectation is that when you do this forwarding offload thing, the
bridge passes the classified VLAN down to the port driver, encoded
inside the accel_priv alongside the sb_dev somehow.
