Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2538D47976C
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 00:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhLQXJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 18:09:30 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:48042
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230011AbhLQXJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 18:09:28 -0500
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 9D94B3F1F0
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 23:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639782567;
        bh=ys1YmTbxI/0qMuoKgusLiKRMBeOqTdLDNhDUoLhs2AQ=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=Y/j8fZVAuGv3nPZfRhKVryft83tRmb8gcaPWKw0Rt0iNfWuyoKWxgBMpakkcbIIAk
         WHcfLF+pKM5yF02Q1cxWjBt8q/5PXWr6f/wLKGYLNqXO3wVV04yr2NgTiMXbgwbbOc
         9bMwlqrGWFvvTKD4c23CvVX7bHCralanHYHseNm5XWDk5o4wgsdSnZZsBlYEDbdzTo
         sV6BrC1KJGl3LCEeujeSCGfFeTk4nEo07+Xbp9RXsV0lY3K6HFNhNNza9c2ipK/kKz
         dWHLQB8ra4TzH6+q7uaaWVl4MKsgG6TA/LM0jUSO8XbvBePKLJApCD+KJKVvXb+Yh1
         dIx937Nlday6A==
Received: by mail-pl1-f198.google.com with SMTP id u7-20020a170902e5c700b00148d23ac88aso1585241plf.6
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 15:09:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=ys1YmTbxI/0qMuoKgusLiKRMBeOqTdLDNhDUoLhs2AQ=;
        b=XUDzeCqy1Ibe5dhBedVMQSYl/VDqLKiA6TqmxCCl9/yXNETD9khIe5eIB5JYUhVgAZ
         RtqnVgf7iGUao/VFTOv3olG6tEAOKEAZ++MZRouDUXNb0qjG5jd+CEp8qTfj+tgFly18
         RxvI/QVXFYhKPF5VpbyKoctFwYXPjoJhXDF6TcbI2LA1fGZ58EhQXH+XZr8U55tdwCF/
         zRuYUakjwpLUWx+w+jdTjP3jV0EUhGla3ORgoW4j2uMupgp1SuiaTC/AbEimYH2U2QS3
         fxJNoGviQ5/U02OxMxcdM6Is45WqqpyV9jKaKZAyBfzysbS8QQnWLH24xr1w+8DPDXcI
         ExUw==
X-Gm-Message-State: AOAM530t5MiqtkqEk1MLle0/bHXVtZwYSULTyJIv3JT81txqz54DXfFD
        ekqyZaOtugar9uvHmhWCUyKAnPpwMod6SZFqURGHjj/wgBkL2/wK4ih8pC9VkaAY3NoXHPMMjM/
        +NEtIrDAsL5st8JFSugRI7uI/oO3SE39AiQ==
X-Received: by 2002:a65:6717:: with SMTP id u23mr4791540pgf.547.1639782566243;
        Fri, 17 Dec 2021 15:09:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxk++2lSSOix2GM5XmHtqJPzeNGH5KGfD+pMIcg++duLGKrm4NUYpJzgGIdvlEOTvtkTxOXHQ==
X-Received: by 2002:a65:6717:: with SMTP id u23mr4791529pgf.547.1639782565975;
        Fri, 17 Dec 2021 15:09:25 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id lr3sm13433279pjb.34.2021.12.17.15.09.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Dec 2021 15:09:25 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 1E9FF60DD1; Fri, 17 Dec 2021 15:09:25 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 193EFA0B22;
        Fri, 17 Dec 2021 15:09:25 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>
cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
Subject: Re: [PATCH v3] net: bonding: Add support for IPV6 ns/na
In-reply-to: <20211217164829.31388-1-sunshouxin@chinatelecom.cn>
References: <20211217164829.31388-1-sunshouxin@chinatelecom.cn>
Comments: In-reply-to Sun Shouxin <sunshouxin@chinatelecom.cn>
   message dated "Fri, 17 Dec 2021 11:48:29 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15943.1639782565.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 17 Dec 2021 15:09:25 -0800
Message-ID: <15944.1639782565@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	For clarity, please add "to balance-alb mode" to the Subject.

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
>                        \      /
>                        server
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
>
>However, this traffic forward will be failure due to split
>horizon of VxLAN tunnels.

	I believe I understand what problem you're trying to solve here,
but the solution seems to be incomplete, as (from our prior discussion)
a rebalance event for balance-alb will apparently induce the same
problem.  Granted, those do not occur frequently (only when interfaces
are added to the bond, or an interface link state changes), but have you
tested what happens if NIC1 or NIC2 (or in a situation with more than
two interfaces) undergoes a link state change?

>Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>Reviewed-by: Jay Vosburgh<jay.vosburgh@canonical.com>

	I did not include this signoff tag in my prior message.  Please
do not include such tags unless explicitly provided by the relevant
person.  Discussion on the mailing list is not equivalent to providing
the tag; please review Documentation/process/submitting-patches.rst.

>Reviewed-by: Eric Dumazet<eric.dumazet@gmail.com>
>Reported-by: kernel test robot <lkp@intel.com>
>Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>---
> drivers/net/bonding/bond_alb.c | 131 +++++++++++++++++++++++++++++++++
> 1 file changed, 131 insertions(+)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_al=
b.c
>index 533e476988f2..b14017364594 100644
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
>@@ -1269,6 +1270,119 @@ static int alb_set_mac_address(struct bonding *bo=
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
>+		lladdr =3D ndisc_opt_addr_data(nd_opt, dev);
>+		break;
>+
>+		default:
>+		lladdr =3D NULL;
>+		break;
>+		}

	The above block is indented incorrectly (the "lladdr" and
"break" lines should be further in).

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
>+		}
>+		ndoptlen -=3D l;
>+		nd_opt =3D ((void *)nd_opt) + l;

	If I'm reading RFC 4861 section 4.4 correctly, a Neighbor
Advertisement will only have ND_OPT_TARGET_LL_ADDR, and a Neighbor
Solicitation will only have ND_OPT_SOURCE_LL_ADDR.  Assuming that's a
correct reading, can the above break out of the loop after processing
the first TARGET or SOURCE option seen?

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
>+	struct icmp6hdr *hdr =3D NULL;

	hdr does not need to be initialized, as it's always assigned to
before being inspected.

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
>@@ -1415,6 +1529,7 @@ struct slave *bond_xmit_alb_slave_get(struct bondin=
g *bond,
> 	}
> 	case ETH_P_IPV6: {
> 		const struct ipv6hdr *ip6hdr;
>+		struct icmp6hdr *hdr =3D NULL;

	As above, hdr does not need to be initialized.

	-J

> 		/* IPv6 doesn't really use broadcast mac address, but leave
> 		 * that here just in case.
>@@ -1446,6 +1561,21 @@ struct slave *bond_xmit_alb_slave_get(struct bondi=
ng *bond,
> 			break;
> 		}
> =

>+		if (ip6hdr->nexthdr =3D=3D IPPROTO_ICMPV6) {
>+			hdr =3D icmp6_hdr(skb);
>+			if (alb_determine_nd(hdr)) {
>+				u8 *lladdr =3D NULL;
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
>@@ -1489,6 +1619,7 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, stru=
ct net_device *bond_dev)
> 	struct slave *tx_slave =3D NULL;
> =

> 	tx_slave =3D bond_xmit_alb_slave_get(bond, skb);
>+	alb_set_nd_option(skb, bond, tx_slave);
> 	return bond_do_alb_xmit(skb, bond, tx_slave);
> }
> =

>
>base-commit: 6441998e2e37131b0a4c310af9156d79d3351c16
>-- =

>2.34.1
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
