Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083A946F4D0
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 21:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbhLIU0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 15:26:12 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:50746
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231863AbhLIU0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 15:26:11 -0500
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 00A7B40192
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 20:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639081356;
        bh=QSaDlwPQa+etFy6inXXoS8oO15+5wX7jcjihnRHIGlc=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=FE+M2zEmQNxlQwPlBkMdkri+Cyz4lvxaUGZP1SL8F4xrLYyi/TgHToey66ov19kSa
         aqjtrWkctO5JwKxnjWF9qT3dYDwF1phl0pjqLdN5d7dz5AnldwRmaYQ5pjDcqSAhPF
         KNN7/KNeA1XusezFJR4a7Z9aRy9sqks0Y/eAgn48PklPkBLfEGCHXbbZClukQS2oiS
         46oaQg7TXGIViP6hkkgSC5g0oSnQKEsbRGf1HN1LTZsTVQ/xOTjlf9B7tQDG42CMTm
         Ab4+z5gFNXzkQ9d2iaDSaf9t8ptmV5EcK6zf0JLjnMhWzCi7Jv2Fhv45hYM13H9hDe
         uxBpT+1ARKDYg==
Received: by mail-pj1-f72.google.com with SMTP id pg9-20020a17090b1e0900b001a689204b52so6711369pjb.0
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 12:22:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=QSaDlwPQa+etFy6inXXoS8oO15+5wX7jcjihnRHIGlc=;
        b=CaVacOb08e+fzavR+xA8rV6m+cqolcaxGDBHkux2Ks7Gxn6NK2QUGY71bVHK+P4v+2
         S7hpL4dEbdMa9YPDTUurT0VHAGA1fc8yJ+T3StQuB5gj9AOB+fpFKS9iHCc7JKkGxL6A
         vpyJNi09I0YtIbP9IeV7oMde/+nIk2U7VXQnai9OoLB5EcqadaiM0LWhcy5YUAVCj4LC
         OV0u6UwEgQvYQsiuGtGlDaNeu23SiuiZ5D7dZ1jFlFHCgGO573pb3S8+msKh7Rzv8LMW
         Zhw4P831AmXPoGnt2KB0cOYQObkBMIUubmLZXUNk7PVf7FGxUcZnojrwQgT0yN7cg+kb
         UUtQ==
X-Gm-Message-State: AOAM531VLzOGbpIP3fabgKZQEfsD1OgzyE1zffoRiqBgcO2yu7DcDCQW
        dmSPOaEXWb0+yZqbdtplmMysyvo1RYZtfXOPHDxPBI23LQ+7KqQGpCzp3dFLm6wEsZhUJNGQvxN
        AM8pZzkFn+T2PIW5LsqRTW+OwuRWI1blJCQ==
X-Received: by 2002:a63:b60e:: with SMTP id j14mr35811768pgf.554.1639081354522;
        Thu, 09 Dec 2021 12:22:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxHnEmgcNB7WvuzU1Wy9KLBWzXG15lFfIiE+Fo7Cq/SZ2xr14LF8O14jN+HIoTgnDnYtUgI2w==
X-Received: by 2002:a63:b60e:: with SMTP id j14mr35811750pgf.554.1639081354219;
        Thu, 09 Dec 2021 12:22:34 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id y8sm549165pfi.56.2021.12.09.12.22.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Dec 2021 12:22:33 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 69F636093D; Thu,  9 Dec 2021 12:22:33 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 63D3CA0B22;
        Thu,  9 Dec 2021 12:22:33 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>
cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
Subject: Re: [PATCH] net: bonding: Add support for IPV6 ns/na
In-reply-to: <1639032622-28098-1-git-send-email-sunshouxin@chinatelecom.cn>
References: <1639032622-28098-1-git-send-email-sunshouxin@chinatelecom.cn>
Comments: In-reply-to Sun Shouxin <sunshouxin@chinatelecom.cn>
   message dated "Thu, 09 Dec 2021 14:50:22 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27831.1639081353.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 09 Dec 2021 12:22:33 -0800
Message-ID: <27832.1639081353@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun Shouxin <sunshouxin@chinatelecom.cn> wrote:

>Since ipv6 neighbor solicitation and advertisement messages
>isn't handled gracefully in bonding6 driver, we can see packet
>drop due to inconsistency bewteen mac address in the option
>message and source MAC .

	Could you provide a specific example where this occurs?

>Another examples is ipv6 neighbor solicitation and advertisement
>messages from VM via tap attached to host brighe, the src mac
>mighe be changed through balance-alb mode, but it is not synced
>with Link-layer address in the option message.

	What happens if the MAC assignment changes because alb does a
rebalance?

>The patch implements bond6's tx handle for ipv6 neighbor
>solicitation and advertisement messages.

	A few additional minor comments below.

>Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>---
> drivers/net/bonding/bond_alb.c | 127 +++++++++++++++++++++++++++++++++++=
++++++
> 1 file changed, 127 insertions(+)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_al=
b.c
>index 2ec8e01..01566ba 100644
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
>@@ -1269,6 +1270,112 @@ static int alb_set_mac_address(struct bonding *bo=
nd, void *addr)
> 	return res;
> }
> =

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
>+		break;
>+		}
>+
>+		l =3D nd_opt->nd_opt_len << 3;
>+
>+		if (ndoptlen < l || l =3D=3D 0)
>+			return;
>+
>+		if (lladdr) {
>+			memcpy(lladdr, data, dev->addr_len);
>+			lladdr =3D NULL;
>+			icmp6h->icmp6_cksum =3D 0;
>+
>+			icmp6h->icmp6_cksum =3D csum_ipv6_magic(&ip6hdr->saddr,
>+							      &ip6hdr->daddr,
>+						ntohs(ip6hdr->payload_len),
>+						IPPROTO_ICMPV6,
>+						csum_partial(icmp6h,
>+							     ntohs(ip6hdr->payload_len), 0));
>+			lladdr =3D NULL;

	"lladdr =3D NULL" could be in the default: case, above, instead of
being done here (and it's here twice).

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
>+			return lladdr;
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
>+
>+	if (tx_slave && tx_slave !=3D rcu_access_pointer(bond->curr_active_slav=
e)) {
>+		if (ntohs(skb->protocol) =3D=3D ETH_P_IPV6) {

	Nit: use "skb->protocol =3D=3D htons(ETH_P_IPV6)" as the compiler
should optimize the htons() of a constant.  Also, you may want to
consider reordering the tests here, as IPv6 NA/NS traffic is likely to
be the vast minority.

>+			ip6hdr =3D ipv6_hdr(skb);
>+			if (ip6hdr->nexthdr =3D=3D IPPROTO_ICMPV6) {
>+				hdr =3D icmp6_hdr(skb);
>+				if (hdr->icmp6_type =3D=3D
>+				    NDISC_NEIGHBOUR_ADVERTISEMENT ||
>+				     hdr->icmp6_type =3D=3D
>+				     NDISC_NEIGHBOUR_SOLICITATION) {

	This construct appears twice, perhaps it deserves its own
boolean-return function?

	-J

>+					alb_change_nd_option(skb, tx_slave->dev->dev_addr);
>+				}
>+			}
>+		}
>+	}
>+}
>+
> /************************ exported alb functions ***********************=
*/
> =

> int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
>@@ -1415,6 +1522,7 @@ struct slave *bond_xmit_alb_slave_get(struct bondin=
g *bond,
> 	}
> 	case ETH_P_IPV6: {
> 		const struct ipv6hdr *ip6hdr;
>+		struct icmp6hdr *hdr =3D NULL;
> =

> 		/* IPv6 doesn't really use broadcast mac address, but leave
> 		 * that here just in case.
>@@ -1446,6 +1554,24 @@ struct slave *bond_xmit_alb_slave_get(struct bondi=
ng *bond,
> 			break;
> 		}
> =

>+		if (ip6hdr->nexthdr =3D=3D IPPROTO_ICMPV6) {
>+			hdr =3D icmp6_hdr(skb);
>+			if (hdr->icmp6_type =3D=3D
>+			    NDISC_NEIGHBOUR_ADVERTISEMENT ||
>+			    hdr->icmp6_type =3D=3D
>+			    NDISC_NEIGHBOUR_SOLICITATION) {
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
>@@ -1489,6 +1615,7 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, stru=
ct net_device *bond_dev)
> 	struct slave *tx_slave =3D NULL;
> =

> 	tx_slave =3D bond_xmit_alb_slave_get(bond, skb);
>+	alb_set_nd_option(skb, bond, tx_slave);
> 	return bond_do_alb_xmit(skb, bond, tx_slave);
> }
> =

>-- =

>1.8.3.1
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
