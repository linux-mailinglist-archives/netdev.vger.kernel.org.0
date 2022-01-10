Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F45A48A012
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 20:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242832AbiAJTYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 14:24:13 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:35788
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232564AbiAJTYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 14:24:10 -0500
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 6085D3F1EE
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 19:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1641842639;
        bh=/x4BwbJXQXLJRm03XVEr4qTREb+ROpht6m9DGtNyW0I=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=ekTjczxTFX8STwfja3lChdkZQln6xz+OVqOkUr2QnvvKb8gPFcpIlhI4x7W++3DSq
         UrEisfpcbkgBazqlDxMoTwBm6ldPidmDveQ5y2SdRXeVwxx2/bgBIFtK1/ER85qg/F
         uGdFHxgYOuqmVGxmtJhM5Jr9eFeGQtNko2Tvy86lg00R1L1YPWwhpUQXqOeLMJEARL
         qqJxYdo3wcNIyY62lUKcQGE2Bw2+8OrQhAEKZubSbPpHe81oK/DgxRXQEH89Js/2el
         vPpSUC0VDk9Vgch77YarM8FsUG60pt4w2Ri1BUex+T9OOUa+1dfE3DnKzgJn+nAA04
         e/lWl3rpO72AA==
Received: by mail-pj1-f72.google.com with SMTP id e16-20020a17090a119000b001b28f7b2a3bso12342898pja.8
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 11:23:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-transfer-encoding:date:message-id;
        bh=/x4BwbJXQXLJRm03XVEr4qTREb+ROpht6m9DGtNyW0I=;
        b=HUPgdRVYY6yq8ls+rCAhVK4tQJrJeOTYKnG288GvZoWgAoHYlawRknC6YkiA6me/FD
         11AwUZ4CSJnftVs7vhsF+07dyXIm3QUXs0bmU+ERageS/VfEijW/zOhd0uee2OYFNXk7
         T9A5XwJeQ6PKRV9QEIzRep+7x2FX31u8ke/daaoiZfw2icpWWaIYDB4XVFvLEU8f5Ijf
         Vltu1FmmwH+h9M4HM4ylE0wjnuVKvBf+3a3xWXPuoRQYmfrYK8D8yQ+0ryvJv9qflD7l
         tMUhmDphCbsD/hAA/B57UKUBFWExx1KkDZPcxYbcwsSAKYarpBiC7Sti5n+iPlWNRyas
         kwvg==
X-Gm-Message-State: AOAM533/Ry4nbmYwrL3fh5t28QVrfOmBTAoaxaenKYAtQtSjiL0fbGAk
        6DjOOSWNbQfnKHvNOOpUzDzTVycz5thRgRX3vLbGIWVe8+p8tg4rRNOijoe/TyWpFdtUwTLDRUM
        RtUKNH3bAGczAi35uCRHGeeAzKxniZOugCg==
X-Received: by 2002:a17:90b:4c07:: with SMTP id na7mr31691339pjb.229.1641842637805;
        Mon, 10 Jan 2022 11:23:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxQI3bD4Kg1iwoOop78VURo+KxEWZUaIGOUNFVFGq+uQSmUpS7L9HisZNtMY03TPiTb7Lr+rw==
X-Received: by 2002:a17:90b:4c07:: with SMTP id na7mr31691317pjb.229.1641842637474;
        Mon, 10 Jan 2022 11:23:57 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id f12sm7866131pfe.127.2022.01.10.11.23.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jan 2022 11:23:56 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 25B995FDEE; Mon, 10 Jan 2022 11:23:56 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 1EC51A0B22;
        Mon, 10 Jan 2022 11:23:56 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>
cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
Subject: Re: [RESEND PATCH v5] net: bonding: Add support for IPV6 ns/na to balance-alb/balance-tlb mode
In-reply-to: <20220110090410.70176-1-sunshouxin@chinatelecom.cn>
References: <20220110090410.70176-1-sunshouxin@chinatelecom.cn>
Comments: In-reply-to Sun Shouxin <sunshouxin@chinatelecom.cn>
   message dated "Mon, 10 Jan 2022 04:04:10 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 10 Jan 2022 11:23:56 -0800
Message-ID: <11285.1641842636@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	I'm getting back to this after the holiday break, and have some
follow up from our prior discussions that I'll paste in below.

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

>> 	I'm not sure what you've changed here for v5 as there's no
>> changelog, but I believe the observed problems to be a transmit side
>> effect (i.e., it is induced by the balance-tlb mode balancing of
>> outgoing traffic).  As such, the tlb side will rebalance all of the
>> traffic every ten seconds, so any MAC ND_OPT_*_LL_ADDR option
>> assignments in the outgoing NS/NA datagrams will only be valid for that
>> length of time, correct?
>
>Yes,=C2=A0 MAC ND_OPT_*_LL_ADDR option assignments in the outgoing NS/NA
>datagrams will only be valid for that length of time ,and then,
>it will be inconsistensy in the next ten seconds.

	So, presumably then the original issue (with the topology
diagram that's now omitted) can recur 10 seconds later (after a TLB
rebalance)?  If so, I don't understand why this patch is an improvement.

>> 	In any event, my real question is whether simply disabling tlb
>> balancing for NS/NA datagrams will resolve the observed issues (i.e.,
>> have bond_xmit_tlb_slave_get return NULL for IPv6 NS/NA datagrams).
>> Doing so will cause all NS/NA traffic to egress through the active
>> interface.  There's already a test in your logic to check for the
>> tx_slave !=3D bond->curr_active_slave, so presumably everything works
>> correctly if the NS/NA goes out on the curr_active_slave.  If the "edit
>> NS/NA datagrams" solution works even in the face of rebalance of
>> traffic, then would simply assigning all NS/NA traffic to the
>> curr_active_slave eliminate the problem?
>
>Yes, assigning all Ns/Na traffic to the curr_active_slave can resolve the
>difference between mac in the Ns/Na options with the source mac.
>But this makes the rlb doesn't work in the alb mode,
>one interface with bond6 will not receive any ingress packets.
>It is mismatch Bond6 specification.

	Does assigning all NS/NA to the curr_active_slave avoid the
inconsistency when a TLB side rebalance occurs?  I believe it should,
but want to confirm.

	As for the RLB functionality (i.e., the balance-alb remote to
local load balance), that is not implemented for IPv6 and this patch is
not providing an implementation of the RLB logic for IPv6, so I'm
unclear why you expect it to work, or what the "mismatch Bond6
specification" is.

	To be clear, implementing RLB for IPv6 would include what this
patch is doing (adjusting the content of NS/NA datagrams), but a
complete implementation requires additional logic that isn't here, e.g.,
adding IPv6 logic to the RLB rebalance code, connecting NS/NA
manipulation to rlb_choose_channel(), and likely other things that don't
come immediately to mind.

	In summary, it sounds to me like the actual bug originally
reported (with the now-omitted diagram) would be resolved by assigning
NS/NA datagrams to the curr_active_slave, and supporting RLB for IPv6 is
a larger project than what's provided by this patch.  Am I understanding
correctly?

	-J

>Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>Reported-by: kernel test robot <lkp@intel.com>
>Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>---
> drivers/net/bonding/bond_alb.c | 149 +++++++++++++++++++++++++++++++++
> 1 file changed, 149 insertions(+)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb=
.c
>index 533e476988f2..485e4863a365 100644
>--- a/drivers/net/bonding/bond_alb.c
>+++ b/drivers/net/bonding/bond_alb.c
>@@ -22,6 +22,8 @@
> #include <asm/byteorder.h>
> #include <net/bonding.h>
> #include <net/bond_alb.h>
>+#include <net/ndisc.h>
>+#include <net/ip6_checksum.h>
>=20
> static const u8 mac_v6_allmcast[ETH_ALEN + 2] __long_aligned =3D {
> 	0x33, 0x33, 0x00, 0x00, 0x00, 0x01
>@@ -1269,6 +1271,137 @@ static int alb_set_mac_address(struct bonding *bon=
d, void *addr)
> 	return res;
> }
>=20
>+/*determine if the packet is NA or NS*/
>+static bool __alb_determine_nd(struct icmp6hdr *hdr)
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
>+				if (__alb_determine_nd(hdr))
>+					alb_change_nd_option(skb, tx_slave->dev->dev_addr);
>+			}
>+		}
>+	}
>+}
>+
>+static bool alb_determine_nd(struct sk_buff *skb, struct bonding *bond)
>+{
>+	struct ipv6hdr *ip6hdr;
>+	struct icmp6hdr *hdr;
>+
>+	if (skb->protocol =3D=3D htons(ETH_P_IPV6)) {
>+		ip6hdr =3D ipv6_hdr(skb);
>+		if (ip6hdr->nexthdr =3D=3D IPPROTO_ICMPV6) {
>+			hdr =3D icmp6_hdr(skb);
>+			if (__alb_determine_nd(hdr))
>+				return true;
>+		}
>+	}
>+
>+	return false;
>+}
>+
> /************************ exported alb functions ************************/
>=20
> int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
>@@ -1350,6 +1483,9 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding=
 *bond,
> 		switch (skb->protocol) {
> 		case htons(ETH_P_IP):
> 		case htons(ETH_P_IPV6):
>+			if (alb_determine_nd(skb, bond))
>+				break;
>+
> 			hash_index =3D bond_xmit_hash(bond, skb);
> 			if (bond->params.tlb_dynamic_lb) {
> 				tx_slave =3D tlb_choose_channel(bond,
>@@ -1446,6 +1582,18 @@ struct slave *bond_xmit_alb_slave_get(struct bondin=
g *bond,
> 			break;
> 		}
>=20
>+		if (alb_determine_nd(skb, bond)) {
>+			u8 *lladdr;
>+
>+			lladdr =3D alb_get_lladdr(skb);
>+			if (lladdr) {
>+				if (!bond_slave_has_mac_rx(bond, lladdr)) {
>+					do_tx_balance =3D false;
>+					break;
>+				}
>+			}
>+		}
>+
> 		hash_start =3D (char *)&ip6hdr->daddr;
> 		hash_size =3D sizeof(ip6hdr->daddr);
> 		break;
>@@ -1489,6 +1637,7 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struc=
t net_device *bond_dev)
> 	struct slave *tx_slave =3D NULL;
>=20
> 	tx_slave =3D bond_xmit_alb_slave_get(bond, skb);
>+	alb_set_nd_option(skb, bond, tx_slave);
> 	return bond_do_alb_xmit(skb, bond, tx_slave);
> }
>=20
>
>base-commit: 7a29b11da9651ef6a970e2f6bfd276f053aeb06a
>--=20
>2.27.0
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
