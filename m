Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44E647B488
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 21:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhLTUsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 15:48:38 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:43798
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229545AbhLTUsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 15:48:38 -0500
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 1FBD73FFE5
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 20:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1640033309;
        bh=CylAiDcMKCHAAC8ueNcVTekyeto0IoqUMHSzLnhZjac=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=F048ZRYRjhB1i5uP8DyeaSXARwEG9OjBieEbCtW+HDKrBhYnWlWI9x9WNY1UJSAAR
         pJ1T0ZlK/U/bnoIMfA8GRGYQ5lUByr1zoRa83puBa3IyweSxMrWAJEUyferjGxuHPs
         qfaS8yviZEoKqfUwS3o4pDn9WoNEPZ4WcB1oqHndERtqJuON4ta9vveHgT/wN6e9C5
         xWuac3wqnxeaVVeKfn0XXbl+OydvCKb6/OkG4IrDhwqTrc9gGoRIv4J00PUjonn51L
         31twV5UlbwEFfXVIBchwhK30oQXHCdPWm6ZVU2E2XX+rWbKKwfj2X8tcd9ZB817IND
         mk/WgFjTJ1gjA==
Received: by mail-pf1-f197.google.com with SMTP id i3-20020a628703000000b004ba462357d6so4359948pfe.23
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 12:48:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=CylAiDcMKCHAAC8ueNcVTekyeto0IoqUMHSzLnhZjac=;
        b=cqfRTAErbN7qHoPsUWKCfcRUT57z5w5mK/4Np+66j2Or/5xOHoQPn+kU7U9kRrecSZ
         Cg2hAbVxJXG6bP0KeO8MfbS/0SfCiT1wDp4BF6hhOKF8EbnxHvaPwIz/KnNjORI+jFac
         R1uH/0U+ms7tadRb350sKC1KrQhHu8UzY7mYuapYqUnJCNhbARY7B9haZHvXp546ZYIg
         a67kV/1+rFLZFoYzAADPzj/X4BKDHEZb4f02dWeODaSZswqt8Orsyl1Va0KMT6KEcghR
         a0/GAnWE1zbkoiUViVcupdh2Vc0SzpJW7zB3Xi4m5lcHc399Ugb9N+epcVVpAqmj2ptg
         InSQ==
X-Gm-Message-State: AOAM532Ujg7YYmC22ypyYcZTzA/d9jFiJKVjXvN6aH8mUSeM4gAX3+fq
        jrodNrSie69zsal6UKUmFF1SLhNpewtkq4RjRm2ZXUKYuUT+loWVfNnEYuhnuumuFs3hckOAhSo
        OUtiTAgyu828YOIg/6JT3C6jisIXw4UGrUw==
X-Received: by 2002:a63:1166:: with SMTP id 38mr16319050pgr.368.1640033307610;
        Mon, 20 Dec 2021 12:48:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwWXKIlRW85bc7t4CizzKbVzxzW8+0o3YcSARQH4dMBeOxRRg7dcHblg9qgDF9SoMJq8ha7zg==
X-Received: by 2002:a63:1166:: with SMTP id 38mr16319030pgr.368.1640033307304;
        Mon, 20 Dec 2021 12:48:27 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id ls7sm272012pjb.11.2021.12.20.12.48.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Dec 2021 12:48:26 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 7DD825FDEE; Mon, 20 Dec 2021 12:48:26 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 75B3EA0B22;
        Mon, 20 Dec 2021 12:48:26 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>
cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
Subject: Re: [PATCH v4] net: bonding: Add support for IPV6 ns/na to balance-alb mode
In-reply-to: <20211220152455.37413-1-sunshouxin@chinatelecom.cn>
References: <20211220152455.37413-1-sunshouxin@chinatelecom.cn>
Comments: In-reply-to Sun Shouxin <sunshouxin@chinatelecom.cn>
   message dated "Mon, 20 Dec 2021 10:24:55 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <31772.1640033306.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 20 Dec 2021 12:48:26 -0800
Message-ID: <31773.1640033306@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun Shouxin <sunshouxin@chinatelecom.cn> wrote:

>Since ipv6 neighbor solicitation and advertisement messages
>isn't handled gracefully in bonding6 driver, we can see packet
>drop due to inconsistency bewteen mac address in the option
>message and source MAC .
>
>Another examples is ipv6 neighbor solicitation and advertisement
>messages from VM via tap attached to host brighe, the src mac
>mighe be changed through balance-alb mode, but it is not synced
>with Link-layer address in the option message.
>
>The patch implements bond6's tx handle for ipv6 neighbor
>solicitation and advertisement messages.
>
>                        Border-Leaf
>                        /        \
>                       /          \
>                    Tunnel1    Tunnel2
>                     /              \
>                    /                \
>                  Leaf-1--Tunnel3--Leaf-2
>                    \                /
>                     \              /
>                      \            /
>                       \          /
>                       NIC1    NIC2
>                         \      /
>                          server
>
>We can see in our lab the Border-Leaf receives occasionally
>a NA packet which is assigned to NIC1 mac in ND/NS option
>message, but actaully send out via NIC2 mac due to tx-alb,
>as a result, it will cause inconsistency between MAC table
>and ND Table in Border-Leaf, i.e, NIC1 =3D Tunnel2 in ND table
>and  NIC1 =3D Tunnel1 in mac table.
>
>And then, Border-Leaf starts to forward packet destinated
>to the Server, it will only check the ND table entry in some
>switch to encapsulate the destination MAC of the message as
>NIC1 MAC, and then send it out from Tunnel2 by ND table.
>Then, Leaf-2 receives the packet, it notices the destination
>MAC of message is NIC1 MAC and should forword it to Tunne1
>by Tunnel3.

	Should the above state "forward it to Leaf-1 by Tunnel3", not
"to Tunnel1"?  Presumably Leaf-1 would then forward a packet with NIC1
MAC destination directly to NIC1.  You mention VXLAN split horizon
below, but I'm unclear on exactly why that results in a failure to
forward vs selecting a suboptimal path.

	My overall concern here is that this is a complex solution for a
very specific configuration, and I'm not sure exactly which piece is
doing something wrong (i.e., is Border-Leaf correct in selecting
Tunnel2?).

	And, further, this topology is outside the scope of what the tlb
/ alb modes were designed around (which was interfacing with a single
switch, not a distributed switch topology as shown above); alb's inbound
load balancing in particular wasn't set up for IPv6 (it only modifies
ARPs to assign peers to specific bonding interfaces).  That's not to say
that we can't fix up the IPv6 support, but I don't want to eventually
have a collection of band-aids for specific corner cases.

	Also, on thinking about it, I'm unsure why the tlb mode would
not exhibit the same issue, since you're not altering the alb inbound
load balancer (the "tailored ARP per peer" logic), just the regular
transmit side, which is largely the same for tlb.  Have you tested
balance-tlb mode?

	Lastly, Eric's question about not altering the original skb
isn't explictly addressed that I can see (although it seems Eric was
concerned about received packets, and this is modifying packets being
transmitted).  The code looks like it shouldn't modify NS/NA packets
that are being forwarded through the bond (the bond_slave_has_mac_rx
test), but is it possible for a locally originating NS/NA to be a clone?

	-J

>However, this traffic forward will be failure due to split
>horizon of VxLAN tunnels.
>
>Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>Reported-by: kernel test robot <lkp@intel.com>
>Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>---
> drivers/net/bonding/bond_alb.c | 132 +++++++++++++++++++++++++++++++++
> 1 file changed, 132 insertions(+)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_al=
b.c
>index 533e476988f2..e8d6d1f2f540 100644
>--- a/drivers/net/bonding/bond_alb.c
>+++ b/drivers/net/bonding/bond_alb.c
>@@ -22,6 +22,7 @@
> #include <asm/byteorder.h>
> #include <net/bonding.h>
> #include <net/bond_alb.h>
>+#include <net/ndisc.h>
> =

> static const u8 mac_v6_allmcast[ETH_ALEN + 2] __long_aligned =3D {
> 	0x33, 0x33, 0x00, 0x00, 0x00, 0x01
>@@ -1269,6 +1270,120 @@ static int alb_set_mac_address(struct bonding *bo=
nd, void *addr)
> 	return res;
> }
> =

>+/*determine if the packet is NA or NS*/
>+static bool alb_determine_nd(struct icmp6hdr *hdr)
>+{
>+	if (hdr->icmp6_type =3D=3D NDISC_NEIGHBOUR_ADVERTISEMENT ||
>+	    hdr->icmp6_type =3D=3D NDISC_NEIGHBOUR_SOLICITATION) {
>+		return true;
>+	}
>+
>+	return false;
>+}
>+
>+static void alb_change_nd_option(struct sk_buff *skb, void *data)
>+{
>+	struct nd_msg *msg =3D (struct nd_msg *)skb_transport_header(skb);
>+	struct nd_opt_hdr *nd_opt =3D (struct nd_opt_hdr *)msg->opt;
>+	struct net_device *dev =3D skb->dev;
>+	struct icmp6hdr *icmp6h =3D icmp6_hdr(skb);
>+	struct ipv6hdr *ip6hdr =3D ipv6_hdr(skb);
>+	u8 *lladdr =3D NULL;
>+	u32 ndoptlen =3D skb_tail_pointer(skb) - (skb_transport_header(skb) +
>+				offsetof(struct nd_msg, opt));
>+
>+	while (ndoptlen) {
>+		int l;
>+
>+		switch (nd_opt->nd_opt_type) {
>+		case ND_OPT_SOURCE_LL_ADDR:
>+		case ND_OPT_TARGET_LL_ADDR:
>+			lladdr =3D ndisc_opt_addr_data(nd_opt, dev);
>+			break;
>+
>+		default:
>+			lladdr =3D NULL;
>+			break;
>+		}
>+
>+		l =3D nd_opt->nd_opt_len << 3;
>+
>+		if (ndoptlen < l || l =3D=3D 0)
>+			return;
>+
>+		if (lladdr) {
>+			memcpy(lladdr, data, dev->addr_len);
>+			icmp6h->icmp6_cksum =3D 0;
>+
>+			icmp6h->icmp6_cksum =3D csum_ipv6_magic(&ip6hdr->saddr,
>+							      &ip6hdr->daddr,
>+						ntohs(ip6hdr->payload_len),
>+						IPPROTO_ICMPV6,
>+						csum_partial(icmp6h,
>+							     ntohs(ip6hdr->payload_len), 0));
>+			return;
>+		}
>+		ndoptlen -=3D l;
>+		nd_opt =3D ((void *)nd_opt) + l;
>+	}
>+}
>+
>+static u8 *alb_get_lladdr(struct sk_buff *skb)
>+{
>+	struct nd_msg *msg =3D (struct nd_msg *)skb_transport_header(skb);
>+	struct nd_opt_hdr *nd_opt =3D (struct nd_opt_hdr *)msg->opt;
>+	struct net_device *dev =3D skb->dev;
>+	u8 *lladdr =3D NULL;
>+	u32 ndoptlen =3D skb_tail_pointer(skb) - (skb_transport_header(skb) +
>+				offsetof(struct nd_msg, opt));
>+
>+	while (ndoptlen) {
>+		int l;
>+
>+		switch (nd_opt->nd_opt_type) {
>+		case ND_OPT_SOURCE_LL_ADDR:
>+		case ND_OPT_TARGET_LL_ADDR:
>+			lladdr =3D ndisc_opt_addr_data(nd_opt, dev);
>+			break;
>+
>+		default:
>+			break;
>+		}
>+
>+		l =3D nd_opt->nd_opt_len << 3;
>+
>+		if (ndoptlen < l || l =3D=3D 0)
>+			return NULL;
>+
>+		if (lladdr)
>+			return lladdr;
>+
>+		ndoptlen -=3D l;
>+		nd_opt =3D ((void *)nd_opt) + l;
>+	}
>+
>+	return lladdr;
>+}
>+
>+static void alb_set_nd_option(struct sk_buff *skb, struct bonding *bond,
>+			      struct slave *tx_slave)
>+{
>+	struct ipv6hdr *ip6hdr;
>+	struct icmp6hdr *hdr;
>+
>+	if (skb->protocol =3D=3D htons(ETH_P_IPV6)) {
>+		if (tx_slave && tx_slave !=3D
>+		    rcu_access_pointer(bond->curr_active_slave)) {
>+			ip6hdr =3D ipv6_hdr(skb);
>+			if (ip6hdr->nexthdr =3D=3D IPPROTO_ICMPV6) {
>+				hdr =3D icmp6_hdr(skb);
>+				if (alb_determine_nd(hdr))
>+					alb_change_nd_option(skb, tx_slave->dev->dev_addr);
>+			}
>+		}
>+	}
>+}
>+
> /************************ exported alb functions ***********************=
*/
> =

> int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
>@@ -1415,6 +1530,7 @@ struct slave *bond_xmit_alb_slave_get(struct bondin=
g *bond,
> 	}
> 	case ETH_P_IPV6: {
> 		const struct ipv6hdr *ip6hdr;
>+		struct icmp6hdr *hdr;
> =

> 		/* IPv6 doesn't really use broadcast mac address, but leave
> 		 * that here just in case.
>@@ -1446,6 +1562,21 @@ struct slave *bond_xmit_alb_slave_get(struct bondi=
ng *bond,
> 			break;
> 		}
> =

>+		if (ip6hdr->nexthdr =3D=3D IPPROTO_ICMPV6) {
>+			hdr =3D icmp6_hdr(skb);
>+			if (alb_determine_nd(hdr)) {
>+				u8 *lladdr;
>+
>+				lladdr =3D alb_get_lladdr(skb);
>+				if (lladdr) {
>+					if (!bond_slave_has_mac_rx(bond, lladdr)) {
>+						do_tx_balance =3D false;
>+						break;
>+					}
>+				}
>+			}
>+		}
>+
> 		hash_start =3D (char *)&ip6hdr->daddr;
> 		hash_size =3D sizeof(ip6hdr->daddr);
> 		break;
>@@ -1489,6 +1620,7 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, stru=
ct net_device *bond_dev)
> 	struct slave *tx_slave =3D NULL;
> =

> 	tx_slave =3D bond_xmit_alb_slave_get(bond, skb);
>+	alb_set_nd_option(skb, bond, tx_slave);
> 	return bond_do_alb_xmit(skb, bond, tx_slave);
> }
> =

>
>base-commit: a7904a538933c525096ca2ccde1e60d0ee62c08e
>-- =

>2.27.0
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
