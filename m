Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD2A22A2BE
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730153AbgGVW6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgGVW6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 18:58:52 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977E6C0619DC;
        Wed, 22 Jul 2020 15:58:51 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id f12so4235256eja.9;
        Wed, 22 Jul 2020 15:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GeyuJAq2Ee6JuyxFY1udlGW2zzmyn23uQocNW0VtTD8=;
        b=IOJzfHT53iwUNn/wgLRW2GaQFGrviODURnIcE4W884Nk5F3hZfGHJ6J7j02NAM2Yqr
         b0ayDW4M//p534DILrtOKJh6AUuSKtnBDAyR/rmHfPa8hDr6Yg3mJT+KEHyBrZyOb8Tz
         CLPwMIQDwmwjh1axasI6RHnkLHpHYE0gsrKYfo/Z5FwgoXHTdDgSWF0w6ZFcS79upyG4
         JUcQoc+XdF74OlO7laWLpl9iffBSGKnfWfAVRyzWFaAdg/FLtnYbwn5BSaHwlbOEOHqG
         YaPNAz06vbU9CihJGNeOSFhPXw8xPvNvWYS4pyEEKeOdMTomH+7Mg+6uJdb6Pl5FZ4Y6
         T3bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GeyuJAq2Ee6JuyxFY1udlGW2zzmyn23uQocNW0VtTD8=;
        b=fYq6hyJ3PFef9lNK2CsZPw9hkPlasBWj10DbaZcaP0byfy66TSMmnTgiye0QDTdtBN
         CURzZj1OmZZjQ/dLzvE6wyLzEC8Z6xwCiGFRgDpe5/bqkXY6B6GFv16zO5rjqRKChwJY
         eqCRCRgeftkm9ZDzki3lTJKJunJRXYu8Gb3LMzWx9rTf7dtLsMHp2KircQM1vLfmOeqe
         e7qt+R9gxEL7prEtkboDKVvEdkHHqgxDhwJ4Pp4xJCjEBlJn47bPnGQSwcNFV+1B1hq1
         oH6Rvi3Fhe7xAhXZsJ/HXF0tEPQOPmzAMdGiM7FtStoxEH7X6+oINDSgWJdgjSomP0CZ
         zzSA==
X-Gm-Message-State: AOAM531xJG/KNCt88uS3g30t2X+jx/Rf3dqTVCavJO0nXOgEqyjF2tvO
        R5WBdFpyZ2TFCamTM5lkVHk=
X-Google-Smtp-Source: ABdhPJwGr/SYpELv2Sz9/cU7nM97V9MhLV/YzpgSG+Tqxra54AFuTmhtudfhYHE3Wt+Fp3B2evkbGw==
X-Received: by 2002:a17:906:c285:: with SMTP id r5mr1684222ejz.153.1595458730038;
        Wed, 22 Jul 2020 15:58:50 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id s18sm717489ejm.16.2020.07.22.15.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 15:58:49 -0700 (PDT)
Date:   Thu, 23 Jul 2020 01:58:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jonathan McDowell <noodles@earth.li>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Matthew Hagan <mnhagan88@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] net: dsa: qca8k: Add 802.1q VLAN support
Message-ID: <20200722225847.ssuxebcwr3fr5fh7@skbuf>
References: <20200721171624.GK23489@earth.li>
 <1bf941f5-fdb3-3d9b-627a-a0464787b0ab@gmail.com>
 <20200722193850.GM23489@earth.li>
 <77c136d0-c183-ebb5-5954-647e08c8ec18@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77c136d0-c183-ebb5-5954-647e08c8ec18@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 03:36:38PM -0700, Florian Fainelli wrote:
> On 7/22/20 12:38 PM, Jonathan McDowell wrote:
> > On Tue, Jul 21, 2020 at 10:26:07AM -0700, Florian Fainelli wrote:
> >> On 7/21/20 10:16 AM, Jonathan McDowell wrote:
> >>> This adds full 802.1q VLAN support to the qca8k, allowing the use of
> >>> vlan_filtering and more complicated bridging setups than allowed by
> >>> basic port VLAN support.
> >>>
> >>> Tested with a number of untagged ports with separate VLANs and then a
> >>> trunk port with all the VLANs tagged on it.
> >>
> >> This looks good to me at first glance, at least not seeing obvious
> >> issue, however below are a few questions:
> > 
> > Thanks for the comments.
> > 
> >> - vid == 0 appears to be unsupported according to your port_vlan_prepare
> >> callback, is this really the case, or is it more a case of VID 0 should
> >> be pvid untagged, which is what dsa_slave_vlan_rx_add_vid() would
> >> attempt to program
> > 
> > I don't quite follow you here. VID 0 doesn't appear to be supported by
> > the hardware (and several other DSA drivers don't seem to like it
> > either), hence the check; I'm not clear if there's something alternate I
> > should be doing in that case instead?
> 
> Is it really that the hardware does not support it, or is it that it was
> not tried or poorly handled before? If the switch supports programming
> the VID 0 entry as PVID egress untagged, which is what
> dsa_slave_vlan_rx_add_vid() requests, then this is great, because you
> have almost nothing to do.
> 
> If not, what you are doing is definitively okay, because you have a
> port_bridge_join that ensures that the port matrix gets configured
> correctly for bridging, if that was not supported we would be in trouble.

Things added by dsa_slave_vlan_rx_add_vid() are definitely not "pvid
untagged", they are installed with flags=0 which means "non-pvid,
egress-tagged", aka a simple vlan with tagged ingress and egress.

The case of VLAN 0 is special because according to 802.1Q it is "not a
VLAN", but simply a way to transmit the other stuff in a VLAN header,
namely a class of service (VLAN PCP). The VLAN ID should not be used for
segregation of forwarding domains, should not be assigned as port-based
VLAN to untagged traffic (from what I recall from the 802.1Q standard)
and should always be sent as egress-tagged.

The purpose of the code in the 8021q module that is adding VLAN 0 to our
RX filter is clear:

commit ad1afb00393915a51c21b1ae8704562bf036855f
Author: Pedro Garcia <pedro.netdev@dondevamos.com>
Date:   Sun Jul 18 15:38:44 2010 -0700

    vlan_dev: VLAN 0 should be treated as "no vlan tag" (802.1p packet)

    - Without the 8021q module loaded in the kernel, all 802.1p packets
    (VLAN 0 but QoS tagging) are silently discarded (as expected, as
    the protocol is not loaded).

    - Without this patch in 8021q module, these packets are forwarded to
    the module, but they are discarded also if VLAN 0 is not configured,
    which should not be the default behaviour, as VLAN 0 is not really
    a VLANed packet but a 802.1p packet. Defining VLAN 0 makes it almost
    impossible to communicate with mixed 802.1p and non 802.1p devices on
    the same network due to arp table issues.

    - Changed logic to skip vlan specific code in vlan_skb_recv if VLAN
    is 0 and we have not defined a VLAN with ID 0, but we accept the
    packet with the encapsulated proto and pass it later to netif_rx.

    - In the vlan device event handler, added some logic to add VLAN 0
    to HW filter in devices that support it (this prevented any traffic
    in VLAN 0 to reach the stack in e1000e with HW filter under 2.6.35,
    and probably also with other HW filtered cards, so we fix it here).

    - In the vlan unregister logic, prevent the elimination of VLAN 0
    in devices with HW filter.

    - The default behaviour is to ignore the VLAN 0 tagging and accept
    the packet as if it was not tagged, but we can still define a
    VLAN 0 if desired (so it is backwards compatible).

    Signed-off-by: Pedro Garcia <pedro.netdev@dondevamos.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

So maybe it's worth checking what is your switch's behavior with regard
to VLAN 0. If it already does what's supposed to, then you might just as
well stop fighting the system and silently accept the configuration
while not doing anything.  As Russell implied, the bridge can't add a
VLAN of 0. It is just the 8021q module that does it.  The fact that we
have the same callbacks being used for both in DSA is merely an artefact
of implementation.

> 
> > 
> >> - since we have a qca8k_port_bridge_join() callback which programs the
> >> port lookup control register, putting all ports by default in VID==1
> >> does not break per-port isolation between non-bridged and bridged ports,
> >> right?
> > 
> > VLAN_MODE_NONE (set when we don't have VLAN filtering enabled)
> > configures us for port filtering, ignoring the VLAN info, so I think
> > we're good here.
> 
> OK, good, so just to be sure, there is no cross talk between non-bridged
> ports and bridged ports even when VLAN filtering is not enabled on the
> bridge, right?
> -- 
> Florian

Thanks,
-Vladimir
