Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB38958B043
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 21:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240760AbiHETSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 15:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238118AbiHETSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 15:18:53 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3345C9E5
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 12:18:52 -0700 (PDT)
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 7572C3F0D7
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 19:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1659727130;
        bh=OSDKJxwzJ6ueB+8LZEp7+zVxhmnAMp6wGzGM0b5M3RM=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=W7eoIdSAMWLunr+fLr01J+4/TiaspE9TMvKJab78MInR0bCwrnP1gv8GX/f8b8rT1
         4yA3YI+Vfh0NyO4OvM8v2/86VQO7SdraNu1dWsne/Ly785ZdL0MuzjYNtyWKUmkiUH
         5jCUdBdnjAhVkZla4Qk6wTuoP06qN0XPiC5C7hbSQsyzldN0a/Vbrhi7yPR7GKbx3A
         6clFp1muN7UGfXLgmbIgK6T4jWi85oKkcfIVngFGllsVKqo/3pu6xGzq60pDjAwk4y
         V+rqsl6x+/5bKlwI4JrTJhj9iPjVJ6Mll21oO8TIbnU/6aHoYD7vCHPnjESDqTmCDd
         Lk8ixSVAqtKRA==
Received: by mail-pg1-f197.google.com with SMTP id 15-20020a63020f000000b0041b578f43f9so1625837pgc.11
        for <netdev@vger.kernel.org>; Fri, 05 Aug 2022 12:18:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=OSDKJxwzJ6ueB+8LZEp7+zVxhmnAMp6wGzGM0b5M3RM=;
        b=J+/eKr00HPBsWCzUrZLhmBO+V/JJ20W1D2oEWqw1i2kRh2UvLY2WKETU9fhNCSGJxB
         tMQfYP0BWSnyud1OagKiL5BLdibb5PGc7+WR2jCyu4/TY61vYrAqEfv059RKnvpfC0Nk
         ji9Qn3DngHechjvhvVFpHzhbImC3OlX27rDa0HWjElpKyHwy+C2bE03FEsWdvfpiOG8f
         Du/YFcOAkI0g7At9GUV7Az0oNVUQ7P2pTAHk5HcgHWTqWH4uqsxCt1LRgI68TBww+im0
         loZDt1wHBHuJ+AUBVfbtlSDrKAyzuqupouFiqsrLQA7mYQx0aDFZSPgjvklHY5GAhfLS
         z2lA==
X-Gm-Message-State: ACgBeo1Ek/YJ1CvELLVmg2wBdZ5j2IMf/ywjmFWVGn6M//oT6wU4MVQJ
        v93Od0KGCpE5/1zhYyc9NaXzZ3k6+P3T3tJ+tyEp1ckvgny4gBAc+P9hqa2Y3P/ckRxl0fYl3HC
        5BGWAR8rf2lZfFRKAKW7OXkEANxhFkT1krg==
X-Received: by 2002:a05:6a00:1644:b0:52e:d72c:aadc with SMTP id m4-20020a056a00164400b0052ed72caadcmr2364664pfc.5.1659727129072;
        Fri, 05 Aug 2022 12:18:49 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5nM3Dh8SaxN151LABkSs0HGBtCpyva8n1+s+C1U28qmBQ55OWLIEvBOgfb/529p7gm874RJw==
X-Received: by 2002:a05:6a00:1644:b0:52e:d72c:aadc with SMTP id m4-20020a056a00164400b0052ed72caadcmr2364636pfc.5.1659727128702;
        Fri, 05 Aug 2022 12:18:48 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902654600b0016a3f9e4865sm3356697pln.148.2022.08.05.12.18.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Aug 2022 12:18:48 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 7E6966118F; Fri,  5 Aug 2022 12:18:47 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 774AE9FA79;
        Fri,  5 Aug 2022 12:18:47 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>
cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        huyd12@chinatelecom.cn
Subject: Re: [PATCH] net:bonding:support balance-alb interface with vlan to bridge
In-reply-to: <20220805074556.70297-1-sunshouxin@chinatelecom.cn>
References: <20220805074556.70297-1-sunshouxin@chinatelecom.cn>
Comments: In-reply-to Sun Shouxin <sunshouxin@chinatelecom.cn>
   message dated "Fri, 05 Aug 2022 00:45:56 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3916.1659727127.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 05 Aug 2022 12:18:47 -0700
Message-ID: <3917.1659727127@famine>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun Shouxin <sunshouxin@chinatelecom.cn> wrote:

>In my test, balance-alb bonding with two slaves eth0 and eth1,
>and then Bond0.150 is created with vlan id attached bond0.
>After adding bond0.150 into one linux bridge, I noted that Bond0,
>bond0.150 and  bridge were assigned to the same MAC as eth0.
>Once bond0.150 receives a packet whose dest IP is bridge's
>and dest MAC is eth1's, the linux bridge cannot process it as expected.
>The patch fix the issue, and diagram as below:
>
>eth1(mac:eth1_mac)--bond0(balance-alb,mac:eth0_mac)--eth0(mac:eth0_mac)
>      		      |
>      		   bond0.150(mac:eth0_mac)
>      		      |
>      	           bridge(ip:br_ip, mac:eth0_mac)--other port

	In principle, since 567b871e5033, the bond alb mode shouldn't be
load balancing incoming traffic for an IP address arriving via a bridge
configured above the bond.

	Looking at it, there's logic in rlb_arp_xmit to exclude the
bridge-over-bond case, but it relies on the MAC of traffic arriving via
the bridge being different from the bond's MAC.  I suspect this is
because 567b871e5033 was intended to manage traffic originating from
other bridge ports, and didn't consider the case of the bridge itself
when the bridge MAC equals the bond MAC.

	The bridge MAC will equal the bond MAC if the bond is the first
port added to the bridge, because the bridge will normally adopt the MAC
of the first port added (unless manually set to something else).

	I think the correct fix here is to update the test in
rlb_arp_xmit to properly exclude all bridge traffic (i.e., handle the
bridge MAC =3D=3D bond MAC case), not to alter the destination MAC address
in incoming traffic.

	-J

>Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>---
> drivers/net/bonding/bond_main.c | 20 ++++++++++++++++++++
> 1 file changed, 20 insertions(+)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index e75acb14d066..6210a9c7ca76 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -1537,9 +1537,11 @@ static rx_handler_result_t bond_handle_frame(struc=
t sk_buff **pskb)
> 	struct sk_buff *skb =3D *pskb;
> 	struct slave *slave;
> 	struct bonding *bond;
>+	struct net_device *vlan;
> 	int (*recv_probe)(const struct sk_buff *, struct bonding *,
> 			  struct slave *);
> 	int ret =3D RX_HANDLER_ANOTHER;
>+	unsigned int headroom;
> =

> 	skb =3D skb_share_check(skb, GFP_ATOMIC);
> 	if (unlikely(!skb))
>@@ -1591,6 +1593,24 @@ static rx_handler_result_t bond_handle_frame(struc=
t sk_buff **pskb)
> 				  bond->dev->addr_len);
> 	}
> =

>+	if (skb_vlan_tag_present(skb)) {
>+		if (BOND_MODE(bond) =3D=3D BOND_MODE_ALB && skb->pkt_type =3D=3D PACKE=
T_HOST) {
>+			vlan =3D __vlan_find_dev_deep_rcu(bond->dev, skb->vlan_proto,
>+							skb_vlan_tag_get(skb) & VLAN_VID_MASK);
>+			if (vlan) {
>+				if (vlan->priv_flags & IFF_BRIDGE_PORT) {
>+					headroom =3D skb->data - skb_mac_header(skb);
>+					if (unlikely(skb_cow_head(skb, headroom))) {
>+						kfree_skb(skb);
>+						return RX_HANDLER_CONSUMED;
>+					}
>+					bond_hw_addr_copy(eth_hdr(skb)->h_dest, vlan->dev_addr,
>+							  vlan->addr_len);
>+				}
>+			}
>+		}
>+	}
>+
> 	return ret;
> }
> =

>-- =

>2.27.0
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
