Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB99A3BDDB7
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 21:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbhGFTFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 15:05:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47085 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230071AbhGFTFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 15:05:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625598179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9Lk9Kfk84chjbcpn4yvjoxXk3G79oQoKjU19hCGyHSo=;
        b=GMdfBX+KTacc/dptT5e8B8T2jHsd5mlADuuIRWgOzCl5b/P3rqbXbGU4XPEvdttSmFmB8f
        KkwQyFxyA5eNdLvWLsgk/r3ON3eI0lo3GXTt7qnkl2ei9XjacawVrkruW22qAMnYP8v8LD
        CpsIw3LVs83Rcxzt0bQGsE4kl1kCd34=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-uGsJ5AuRML-HroMNhH0RGg-1; Tue, 06 Jul 2021 15:02:57 -0400
X-MC-Unique: uGsJ5AuRML-HroMNhH0RGg-1
Received: by mail-wr1-f69.google.com with SMTP id a4-20020adffb840000b02901304c660e75so17487wrr.19
        for <netdev@vger.kernel.org>; Tue, 06 Jul 2021 12:02:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9Lk9Kfk84chjbcpn4yvjoxXk3G79oQoKjU19hCGyHSo=;
        b=YgTrJRH3gTiPG3nBnFmAmfyN3JxO6v/9kvPSssYoPvJlBHuWQnEX6qsYSpgp/uVQkS
         zNmA08c6dAml00okdRIlNthz/36+BKncFsWU2Y1uFoFn3X/5vhXiS+cP5ENtJ+4AlpEO
         jBrlbzhTpKOYkQHBlahBlNgopNHWT219ZS3ySKp2w2BYO6Swov/QiOX603qYIwuxh49O
         2ixJKVe8wFQxDPsWNFlxCbHfvLqPCtbNkdG4g8LCEIwIH321Cd1vdwtpsF5WTsX9kvg6
         vLaiwRtaYNFXkNt6ySk5X1N0VEvF5ZhgRFCUUbwzGEJOIu9PA+aHCV4JpiAVpcVeASXd
         lLtA==
X-Gm-Message-State: AOAM531xlusEzJZDAphSkdY+/HeLHOsMags3iRfXIy3Z3hNbjnMXjZz5
        Mywg8dCJ1+v+aT3ZDvfiCErHuddP/AwmwX3ky0TUcoXHDePD7b0G9vrCr8fAyQNzvLZ6iKrO8eD
        mZQJP/Bp6Y56Yd7jy
X-Received: by 2002:a7b:c00a:: with SMTP id c10mr2457192wmb.100.1625598176591;
        Tue, 06 Jul 2021 12:02:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwud28qzvkdnFpGCZnBx7SvUSo1zTc4i2O1M99srhBvNdSDVSu7FPdtYwnNpi4vBDzTacauOg==
X-Received: by 2002:a7b:c00a:: with SMTP id c10mr2457162wmb.100.1625598176291;
        Tue, 06 Jul 2021 12:02:56 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id z25sm11977762wmi.48.2021.07.06.12.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 12:02:55 -0700 (PDT)
Date:   Tue, 6 Jul 2021 21:02:53 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] selftests: forwarding: Test redirecting gre
 or ipip packets to Ethernet
Message-ID: <20210706190253.GA23236@pc-32.home>
References: <cover.1625056665.git.gnault@redhat.com>
 <0a4e63cd3cde3c71cfc422a7f0f5e9bc76c0c1f5.1625056665.git.gnault@redhat.com>
 <YN1Wxm0mOFFhbuTl@shredder>
 <20210701145943.GA3933@pc-32.home>
 <1932a3af-2fdd-229a-e5f5-6b1ef95361e1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1932a3af-2fdd-229a-e5f5-6b1ef95361e1@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 09:38:44AM -0600, David Ahern wrote:
> On 7/1/21 8:59 AM, Guillaume Nault wrote:
> > I first tried to write this selftest using VRFs, but there were some
> > problems that made me switch to namespaces (I don't remember precisely
> > which ones, probably virtual tunnel devices in collect_md mode).
> 
> if you hit a problem with the test not working, send me the test script
> and I will take a look.

So I've looked again at what it'd take to make a VRF-based selftest.
The problem is that we currently can't create collect_md tunnel
interfaces in different VRFs, if the VRFs are part of the same netns.

Most tunnels explicitely refuse to create a collect_md device if
another one already exists in the netns, no matter the rest of the
tunnel parameters. This is the behaviour of ip_gre, ipip, ip6_gre and
ip6_tunnel.

Then there's sit, which allows the creation of the second collect_md
device in the other VRF. However, iproute2 doesn't set the
IFLA_IPTUN_LINK attribute when it creates an external device, so it
can't set up such a configuration.

Bareudp simply doesn't support VRF.

Finally, vxlan allows devices with different IFLA_VXLAN_LINK attributes
to be created, but only when VXLAN_F_IPV6_LINKLOCAL is set. Removing
the VXLAN_F_IPV6_LINKLOCAL test at the end of vxlan_config_validate()
is enough to make two VXLAN-GPE devices work in a multi-VRF setup:

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3767,8 +3767,7 @@ static int vxlan_config_validate(struct net *src_net, struct vxlan_config *conf,
 		    (conf->flags & (VXLAN_F_RCV_FLAGS | VXLAN_F_IPV6)))
 			continue;
 
-		if ((conf->flags & VXLAN_F_IPV6_LINKLOCAL) &&
-		    tmp->cfg.remote_ifindex != conf->remote_ifindex)
+		if (tmp->cfg.remote_ifindex != conf->remote_ifindex)
 			continue;
 
 		NL_SET_ERR_MSG(extack,

Here's an example of what a full selftests looks like using VXLAN-GPE.
Without the patch above, creating the second vxlan interface fails
(EEXIST).

#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

NUM_NETIFS=6

source lib.sh

VETH_H1_RTA=${NETIFS[p1]}
VETH_RTA_H1=${NETIFS[p2]}
VETH_RTA_RTB=${NETIFS[p3]}
VETH_RTB_RTA=${NETIFS[p4]}
VETH_RTB_H2=${NETIFS[p5]}
VETH_H2_RTB=${NETIFS[p6]}

MAC_H1_RTA=$(mac_get "${VETH_H1_RTA}")
MAC_RTA_H1=$(mac_get "${VETH_RTA_H1}")
MAC_RTB_H2=$(mac_get "${VETH_RTB_H2}")
MAC_H2_RTB=$(mac_get "${VETH_H2_RTB}")

VRF_H1="vrf-h1"
VRF_RTA="vrf-rta"
VRF_RTB="vrf-rtb"
VRF_H2="vrf-h2"

# Set up a chain of 4 VRFs connected with the veth interfaces:
#   H1 <-> RTA <-> RTB <-> H2
setup_base_net()
{
	# Initialise VRFs

	vrf_prepare

	for VRF in "${VRF_H1}" "${VRF_RTA}" "${VRF_RTB}" "${VRF_H2}"; do
		vrf_create "${VRF}"
		ip link set dev "${VRF}" up
	done

	# Assign each veth to its VRF

	__simple_if_init "${VETH_H1_RTA}" "${VRF_H1}"

	__simple_if_init "${VETH_RTA_H1}" "${VRF_RTA}"
	__simple_if_init "${VETH_RTA_RTB}" "${VRF_RTA}"

	__simple_if_init "${VETH_RTB_RTA}" "${VRF_RTB}"
	__simple_if_init "${VETH_RTB_H2}" "${VRF_RTB}"

	__simple_if_init "${VETH_H2_RTB}" "${VRF_H2}"

	# Let each veth communicate with its peer

	ip address add dev "${VETH_H1_RTA}" 192.0.2.0x1a peer 192.0.2.0xa1/32
	ip address add dev "${VETH_RTA_H1}" 192.0.2.0xa1 peer 192.0.2.0x1a/32

	ip address add dev "${VETH_RTA_RTB}" 192.0.2.0xab peer 192.0.2.0xba/32
	ip address add dev "${VETH_RTB_RTA}" 192.0.2.0xba peer 192.0.2.0xab/32

	ip address add dev "${VETH_RTB_H2}" 192.0.2.0xb2 peer 192.0.2.0x2b/32
	ip address add dev "${VETH_H2_RTB}" 192.0.2.0x2b peer 192.0.2.0xb2/32

	# Define host IPs for H1 and H2 and route them through RTA and RTB.
	# Don't set up routing inside RTA and RTB yet.

	ip address add 198.51.100.1/32 dev "${VETH_H1_RTA}"
	ip address add 198.51.100.2/32 dev "${VETH_H2_RTB}"

	ip route add 198.51.100.2/32 src 198.51.100.1 via 192.0.2.0xa1	\
		vrf "${VRF_H1}"
	ip route add 198.51.100.1/32 src 198.51.100.2 via 192.0.2.0xb2	\
		vrf "${VRF_H2}"
}

# Route H1 and H2 host IPs inside RTA and RTB using VXLAN-GPE encapsulation.
setup_vxlan_gpe()
{
	# Create an external VXLAN-GPE device in the intermediate VRFs

	ip link add name tunnel-rta up type vxlan	\
		dev "${VRF_RTA}" gpe external
	ip link add name tunnel-rtb up type vxlan	\
		dev "${VRF_RTB}" gpe external

	# Forward packets received from the end hosts through the tunnels

	tc qdisc add dev "${VETH_RTA_H1}" ingress
	tc filter add dev "${VETH_RTA_H1}" ingress		\
		protocol ipv4 flower dst_ip 198.51.100.2	\
		action tunnel_key set src_ip 192.0.2.0xab	\
			dst_ip 192.0.2.0xba id 10		\
		action mirred egress redirect dev tunnel-rta

	tc qdisc add dev "${VETH_RTB_H2}" ingress
	tc filter add dev "${VETH_RTB_H2}" ingress		\
		protocol ipv4 flower dst_ip 198.51.100.1	\
		action tunnel_key set src_ip 192.0.2.0xba	\
			dst_ip 192.0.2.0xab id 10		\
		action mirred egress redirect dev tunnel-rtb

	# Decapsulate packets received from the tunnels and send them to the
	# end hosts

	tc qdisc add dev tunnel-rta ingress
	tc filter add dev tunnel-rta ingress matchall			\
		action vlan push_eth dst_mac "${MAC_H1_RTA}"		\
			src_mac "${MAC_RTA_H1}"				\
		action mirred egress redirect dev "${VETH_RTA_H1}"

	tc qdisc add dev tunnel-rtb ingress
	tc filter add dev tunnel-rtb ingress matchall			\
		action vlan push_eth dst_mac "${MAC_H2_RTB}"		\
			src_mac "${MAC_RTB_H2}"				\
		action mirred egress redirect dev "${VETH_RTB_H2}"
}

setup_base_net
setup_vxlan_gpe

ip vrf exec "${VRF_H1}" ping 198.51.100.2

