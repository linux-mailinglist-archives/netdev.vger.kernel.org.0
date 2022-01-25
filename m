Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9F349AA50
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 05:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1325204AbiAYDgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 22:36:16 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:45690
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S3415604AbiAYBsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 20:48:24 -0500
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 388BF4000F
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 01:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1643073026;
        bh=Jnvhvo1jsZTo8cImpcuimvx90PJ5WAbukMF8k5/vBTc=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=BHOCujKDPiYHCvpv3Sq++TpQfeTPTomfeLNJq8+Gs+B1NMmlRVl4E4sVPBSYr/3Od
         GV5aH5ddG+7tDL8eczhapcZ6XVFepkXvzGoE3/XGpzV4RwivPp/gyCPUqR+mzVlCLU
         AL5YaKo6ZP84ycqLtrfVat/exbZD5JYk0ZDHIiTJDcTJ4LKrawvfdguba0oHzdtWHu
         ZWhB4heLjncdYVmP08c2oQqeEcN4FQiSmYUxTzqr3C3sr7hBmpJ3c0bFv0QDxF4aTq
         86sLhn+RU+r8XLSqW5buzjFOV7x8kfC9pzkv3Q8Y7OSfcOu7FnfdoGET3ItYPxmcmU
         ORpUr4dum2JjQ==
Received: by mail-pj1-f69.google.com with SMTP id m2-20020a17090ade0200b001b51cbdfd9eso8666484pjv.6
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 17:10:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=Jnvhvo1jsZTo8cImpcuimvx90PJ5WAbukMF8k5/vBTc=;
        b=rmvAz7CmFuTu2slKqJMdZ13OqzTHwHWPAFWWVw+/qaNY/+Bna4uPVWw7GPh1IQ7EXu
         g/2vBCqSnGMmVqyprCDuJBnieLu/tcP23nVtxu5q398WKS5UJm3AKVRafylg+7CbRihI
         3MF9osfX2dd+wOzavfdDaxYCAPUk5fV+Fv99Ru8xif/eJls5v/+tr6iSib9OLxIMvCid
         0y7/5FJFAXfE1oTPfeG8jKwe1p5fzxDpz9cTu3BrKuwyU+Yu67+XeG57PBzVJdqgAUZJ
         DzqYDsVLgTQGELbyH8SNAbnHGoRh9Zj3YyOMQSQHCQk5Z/A1oh8MApxvC/CcZqhAgJiO
         PaQA==
X-Gm-Message-State: AOAM53038zl5vkZ6v+MX3qqb4Vqll01ZJorgRJEu8kM2gjeQcNPDAwQx
        Nw+4fB2yWzqe4s6Ydz+PbSuCcIXGw+qPvdHsMdk/6cLNHEslgScM9u5DaD8Umebe99wh8GhpX1i
        ZcZJo01SfR6ZC94ktwBInpax/V6lL1SQcJA==
X-Received: by 2002:a17:90b:108c:: with SMTP id gj12mr964770pjb.231.1643073024541;
        Mon, 24 Jan 2022 17:10:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzlU7IPR5r67U1VByD/vbSM2V3iIzFxlz326cIfadJ93vbjeIP3PWi1mrllDh3JLfTtOPwblw==
X-Received: by 2002:a17:90b:108c:: with SMTP id gj12mr964749pjb.231.1643073024294;
        Mon, 24 Jan 2022 17:10:24 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id m1sm76945pfk.202.2022.01.24.17.10.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jan 2022 17:10:23 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 6885B60DD1; Mon, 24 Jan 2022 17:10:23 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 60F79A0B22;
        Mon, 24 Jan 2022 17:10:23 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>
cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, nikolay@nvidia.com,
        huyd12@chinatelecom.cn
Subject: Re: [PATCH v8] net: bonding: Add support for IPV6 ns/na to balance-alb/balance-tlb mode
In-reply-to: <20220125002954.94405-1-sunshouxin@chinatelecom.cn>
References: <20220125002954.94405-1-sunshouxin@chinatelecom.cn>
Comments: In-reply-to Sun Shouxin <sunshouxin@chinatelecom.cn>
   message dated "Mon, 24 Jan 2022 19:29:54 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <26802.1643073023.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 24 Jan 2022 17:10:23 -0800
Message-ID: <26803.1643073023@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun Shouxin <sunshouxin@chinatelecom.cn> wrote:

>Since ipv6 neighbor solicitation and advertisement messages
>isn't handled gracefully in bond6 driver, we can see packet
>drop due to inconsistency between mac address in the option
>message and source MAC .
>
>Another examples is ipv6 neighbor solicitation and advertisement
>messages from VM via tap attached to host bridge, the src mac
>might be changed through balance-alb mode, but it is not synced
>with Link-layer address in the option message.
>
>The patch implements bond6's tx handle for ipv6 neighbor
>solicitation and advertisement messages.
>
>Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
>Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>---
> drivers/net/bonding/bond_alb.c | 37 +++++++++++++++++++++++++++++++++-
> 1 file changed, 36 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_al=
b.c
>index 533e476988f2..d4d8670643e9 100644
>--- a/drivers/net/bonding/bond_alb.c
>+++ b/drivers/net/bonding/bond_alb.c
>@@ -1269,6 +1269,34 @@ static int alb_set_mac_address(struct bonding *bon=
d, void *addr)
> 	return res;
> }
> =

>+/* determine if the packet is NA or NS */
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
>+static bool alb_determine_nd(struct sk_buff *skb, struct bonding *bond)
>+{
>+	struct ipv6hdr *ip6hdr;
>+	struct icmp6hdr *hdr;
>+
>+	ip6hdr =3D ipv6_hdr(skb);
>+	if (ip6hdr->nexthdr =3D=3D IPPROTO_ICMPV6) {
>+		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr) + sizeof(struct icmp6hd=
r)))
>+			return true;
>+
>+		hdr =3D icmp6_hdr(skb);
>+		return __alb_determine_nd(hdr);
>+	}
>+
>+	return false;
>+}
>+
> /************************ exported alb functions ***********************=
*/
> =

> int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
>@@ -1348,8 +1376,10 @@ struct slave *bond_xmit_tlb_slave_get(struct bondi=
ng *bond,
> 	/* Do not TX balance any multicast or broadcast */
> 	if (!is_multicast_ether_addr(eth_data->h_dest)) {
> 		switch (skb->protocol) {
>-		case htons(ETH_P_IP):
> 		case htons(ETH_P_IPV6):
>+			if (alb_determine_nd(skb, bond))
>+				break;

	I missed this before, but the new expectation is to have a
"fallthrough;" statement when intentionally falling through to the next
case.  See include/linux/compiler_attributes.h.

	That nit aside, this still looks fine to me.

	-J

>+		case htons(ETH_P_IP):
> 			hash_index =3D bond_xmit_hash(bond, skb);
> 			if (bond->params.tlb_dynamic_lb) {
> 				tx_slave =3D tlb_choose_channel(bond,
>@@ -1446,6 +1476,11 @@ struct slave *bond_xmit_alb_slave_get(struct bondi=
ng *bond,
> 			break;
> 		}
> =

>+		if (alb_determine_nd(skb, bond)) {
>+			do_tx_balance =3D false;
>+			break;
>+		}
>+
> 		hash_start =3D (char *)&ip6hdr->daddr;
> 		hash_size =3D sizeof(ip6hdr->daddr);
> 		break;
>
>base-commit: dd81e1c7d5fb126e5fbc5c9e334d7b3ec29a16a0
>-- =

>2.27.0
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
