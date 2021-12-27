Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C1D480492
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 21:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbhL0UgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 15:36:15 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:32986
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232925AbhL0UgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 15:36:15 -0500
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id BFEE43FFD5
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 20:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1640637373;
        bh=XCiswBVMjHZ39BDgPe7qmfPltHLShKXYf1hnSv3sa44=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=NQlgG0o3Vl58U0WUhDlG7zfQNL7waJhzRAEh3Lweim9BVurD0R4AsaAJVn9arLrXM
         LTo74x+Lwuev8gUdIgTodG22siUS3rJnQWprynVhNFSYClCClBPcwR75brV1f+N2c8
         8gDkSeBgEJW9ybCf1nvHdNZyXNuzdyIIhWu6AZSmr2klzht4xW8A1+84ikCMU/9+fw
         R59GM8ZJ+JCthivvybRxgEWIj0McJH8ZQUdtercr5jta/EaFFXZYFq5iSc2HnUioEu
         L/Gs2ul4BR6UHtnQjzs7BltHXQ5o8/iehXkwJi99+j2YkpaBGvAXEzKBV7AXQK9C0E
         rECSY6CZCB1Bg==
Received: by mail-pf1-f198.google.com with SMTP id j125-20020a62c583000000b004baed10680bso9074576pfg.2
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 12:36:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=XCiswBVMjHZ39BDgPe7qmfPltHLShKXYf1hnSv3sa44=;
        b=MGhNKIotN5nKD4md6OADEn2JtpW9x0O3Xz9vowj7ID45lIn1//39CyGTbTe+6E+VBU
         Yd4t2YoJvmmhbSzvT1kiITvlHKFXs+w/tCZrMhyUrBaZm92NYnNWomiTw/+hmFHLe+46
         N1qBJWHuw/Nhd3X4eSy19eeXYvJvu0J+UGQWHDoNoejii32WiW4fCyGFU/iFGSXUpxDY
         LME6c0rhYXIObaA4+5UnpazY9sTqVBaI0Yuac0lAQY1LyY5LnSYMltVGW0aBXWWKYrKX
         NndcydHmE2FnsV1SDStNuMIh/qNmVs5eFStQSmnxqInopu/Dj+veVW+PMyYT1+0vTCFr
         WgEw==
X-Gm-Message-State: AOAM531JW3WaBaTtdKusARSbHnAkCYL7501TjsHZqVop3nSmotBXYjel
        N+n+hKPHmRaeA9FSGGiYcn9L4irgwjtt3JJ2R7wJ6qcdHGAjzZgbcg2iGAu4F4KmIuAP/ZfvgK9
        xEZlWP/S1WJZ3Zt8+HOMqOIpI9XWl0EnT+g==
X-Received: by 2002:a17:902:f783:b0:148:a2f7:9d6a with SMTP id q3-20020a170902f78300b00148a2f79d6amr19062903pln.137.1640637372161;
        Mon, 27 Dec 2021 12:36:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyij8Q4kXCN9ycwCFlkaX6xpsv5a2mhOQUKEbxQXAR0HNaWOtOyIPc8yorgk8fqhV4XiKnrzw==
X-Received: by 2002:a17:902:f783:b0:148:a2f7:9d6a with SMTP id q3-20020a170902f78300b00148a2f79d6amr19062879pln.137.1640637371791;
        Mon, 27 Dec 2021 12:36:11 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id v133sm15410458pfc.172.2021.12.27.12.36.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Dec 2021 12:36:11 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 07CE36093D; Mon, 27 Dec 2021 12:36:10 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 00184A0B22;
        Mon, 27 Dec 2021 12:36:10 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>
cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
Subject: Re: [PATCH v5] net: bonding: Add support for IPV6 ns/na to balance-alb/balance-tlb mode
In-reply-to: <20211224142512.44182-1-sunshouxin@chinatelecom.cn>
References: <20211224142512.44182-1-sunshouxin@chinatelecom.cn>
Comments: In-reply-to Sun Shouxin <sunshouxin@chinatelecom.cn>
   message dated "Fri, 24 Dec 2021 09:25:12 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <24896.1640637370.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 27 Dec 2021 12:36:10 -0800
Message-ID: <24897.1640637370@famine>
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

	I'm not sure what you've changed here for v5 as there's no
changelog, but I believe the observed problems to be a transmit side
effect (i.e., it is induced by the balance-tlb mode balancing of
outgoing traffic).  As such, the tlb side will rebalance all of the
traffic every ten seconds, so any MAC ND_OPT_*_LL_ADDR option
assignments in the outgoing NS/NA datagrams will only be valid for that
length of time, correct?

	The topology diagram and example that you've removed from the
commit log with v5 said, in part, that the issue arose because the
LL_ADDR option MAC didn't match the actual source MAC.  Since tlb mode
can reshuffle the flows every ten seconds, how did the proposed solution
work reliably?

	In any event, my real question is whether simply disabling tlb
balancing for NS/NA datagrams will resolve the observed issues (i.e.,
have bond_xmit_tlb_slave_get return NULL for IPv6 NS/NA datagrams).
Doing so will cause all NS/NA traffic to egress through the active
interface.  There's already a test in your logic to check for the
tx_slave !=3D bond->curr_active_slave, so presumably everything works
correctly if the NS/NA goes out on the curr_active_slave.  If the "edit
NS/NA datagrams" solution works even in the face of rebalance of
traffic, then would simply assigning all NS/NA traffic to the
curr_active_slave eliminate the problem?

	-J

>Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>Reported-by: kernel test robot <lkp@intel.com>
>Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>---
> drivers/net/bonding/bond_alb.c | 149 +++++++++++++++++++++++++++++++++
> 1 file changed, 149 insertions(+)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_al=
b.c
>index 533e476988f2..485e4863a365 100644
>--- a/drivers/net/bonding/bond_alb.c
>+++ b/drivers/net/bonding/bond_alb.c
>@@ -22,6 +22,8 @@
> #include <asm/byteorder.h>
> #include <net/bonding.h>
> #include <net/bond_alb.h>
>+#include <net/ndisc.h>
>+#include <net/ip6_checksum.h>
> =

> static const u8 mac_v6_allmcast[ETH_ALEN + 2] __long_aligned =3D {
> 	0x33, 0x33, 0x00, 0x00, 0x00, 0x01
>@@ -1269,6 +1271,137 @@ static int alb_set_mac_address(struct bonding *bo=
nd, void *addr)
> 	return res;
> }
> =

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
> /************************ exported alb functions ***********************=
*/
> =

> int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
>@@ -1350,6 +1483,9 @@ struct slave *bond_xmit_tlb_slave_get(struct bondin=
g *bond,
> 		switch (skb->protocol) {
> 		case htons(ETH_P_IP):
> 		case htons(ETH_P_IPV6):
>+			if (alb_determine_nd(skb, bond))
>+				break;
>+
> 			hash_index =3D bond_xmit_hash(bond, skb);
> 			if (bond->params.tlb_dynamic_lb) {
> 				tx_slave =3D tlb_choose_channel(bond,
>@@ -1446,6 +1582,18 @@ struct slave *bond_xmit_alb_slave_get(struct bondi=
ng *bond,
> 			break;
> 		}
> =

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
>@@ -1489,6 +1637,7 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, stru=
ct net_device *bond_dev)
> 	struct slave *tx_slave =3D NULL;
> =

> 	tx_slave =3D bond_xmit_alb_slave_get(bond, skb);
>+	alb_set_nd_option(skb, bond, tx_slave);
> 	return bond_do_alb_xmit(skb, bond, tx_slave);
> }
> =

>
>base-commit: 7a29b11da9651ef6a970e2f6bfd276f053aeb06a
>-- =

>2.27.0
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
