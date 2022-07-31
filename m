Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468B4586074
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 20:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbiGaSyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 14:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiGaSyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 14:54:04 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D437959A
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 11:54:03 -0700 (PDT)
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 9AADC3F132
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 18:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1659293638;
        bh=/rZ7X7U9pAcikcOZ3yO+Va8q0N3iXaXBpH/KAHn48gg=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=r0VNVAYinjHSmTUHNQdWlMyYpwMUTJi1LFNs89bKbAx/3Fkz4bdcY14370Htu0CR/
         ryQXpP2J0cl5jF5Wo34BVY/SSopncCco/GiHTv5z+aoXZD+TYy4nP+29lTeywKWqj3
         BSaImTloBmVw912Cb+H9wheTaQX129GwzCRvVrv2jDZdpokszD7a+yi6ox3I60s76q
         hasYdKUJn1RdTJMJS5CxRr0Lr4aM25wqqfOE4S3rJQnRyJsePdi5zASKQKmpIoee5N
         Y0kozkdg9mFzxolepXfb+eVPxiq/WXtOlHVHcKajCvv2r/bRvYJLmjf0P6Pb2HNQpw
         8g2RUwaQyTSww==
Received: by mail-pl1-f200.google.com with SMTP id l11-20020a170902f68b00b0016ee1c2c0deso1298591plg.2
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 11:53:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=/rZ7X7U9pAcikcOZ3yO+Va8q0N3iXaXBpH/KAHn48gg=;
        b=KPsLJt4eKTP7GKu9KZrOBTd9gaRHS/RprUCa+PKr94lJobXLmUoWu0OEfBY/5LcGrT
         udnJiGKzXoQHkkZsMei2Vo/fIeBsgX6S554ZnnnB50SP8F6rgbHWmbiwh0Z9gVbZ4f/Z
         tOSmp2SXONCdOIZXcal/uUlBLcKfWXiHiKXEAAl5RPkRsFkGyGtcxu6JKlnrV99aRGHP
         CXK949MoSmbb1snPM73/0vErNE9FLNm+ZJ9wBu1rOPx5g13W7bYPKRYO1bwt4rjPC7SO
         33wVQ5znhOGhXiuRCe+q8EJNw0H9Is+U7JbewP2m1KqnqQ7ipvRxVsUQ1AUEN3zPYDiI
         0Ysg==
X-Gm-Message-State: ACgBeo3hZu4YGbErSXGe32iBA8upw80dF2tGQrswz+sdTLBBMeE029fV
        UZMWZs+0G8hkRrAsDx5GjwlBwOvV/doAUyHYbKpYdh6U9S7xwV7dN+PUGoH0wqIINfELTsoc2a6
        aVibZtni2l3OuuxAIuIBN5XEIvpzmMt8FIA==
X-Received: by 2002:a17:902:ce92:b0:16d:d2a9:43af with SMTP id f18-20020a170902ce9200b0016dd2a943afmr12266962plg.23.1659293636444;
        Sun, 31 Jul 2022 11:53:56 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6Qa/pF2WCpnjQQcoKjK2SEPyYR+PsFEeDQRSKoOd+UcR/IXPPrqPDWlvX2mYwLKntc77akaQ==
X-Received: by 2002:a17:902:ce92:b0:16d:d2a9:43af with SMTP id f18-20020a170902ce9200b0016dd2a943afmr12266948plg.23.1659293636157;
        Sun, 31 Jul 2022 11:53:56 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id t5-20020a625f05000000b0052ceaba7411sm799328pfb.125.2022.07.31.11.53.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 31 Jul 2022 11:53:55 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 49E4261193; Sun, 31 Jul 2022 11:53:55 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 4250C9FA79;
        Sun, 31 Jul 2022 11:53:55 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH v3 net 1/4] net: bonding: replace dev_trans_start() with the jiffies of the last ARP/NS
In-reply-to: <20220731124108.2810233-2-vladimir.oltean@nxp.com>
References: <20220731124108.2810233-1-vladimir.oltean@nxp.com> <20220731124108.2810233-2-vladimir.oltean@nxp.com>
Comments: In-reply-to Vladimir Oltean <vladimir.oltean@nxp.com>
   message dated "Sun, 31 Jul 2022 15:41:05 +0300."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1546.1659293635.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Sun, 31 Jul 2022 11:53:55 -0700
Message-ID: <1547.1659293635@famine>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

>The bonding driver piggybacks on time stamps kept by the network stack
>for the purpose of the netdev TX watchdog, and this is problematic
>because it does not work with NETIF_F_LLTX devices.
>
>It is hard to say why the driver looks at dev_trans_start() of the
>slave->dev, considering that this is updated even by non-ARP/NS probes
>sent by us, and even by traffic not sent by us at all (for example PTP
>on physical slave devices). ARP monitoring in active-backup mode appears
>to still work even if we track only the last TX time of actual ARP
>probes.

	Because it's the closest it can get to "have we sent an ARP,"
really.  The issue with LLTX is relatively new (the bonding driver has
worked this way for longer than I've been involved, so I don't know what
the original design decisions were).

	FWIW, I've been working with the following, which is closer in
spirit to what Jakub and I discussed previously (i.e., inspecting the
device stats for virtual devices, relying on dev_trans_start for
physical devices with ndo_tx_timeout).

	This WIP includes one unrelated change: including the ifindex in
the route lookup; that would be a separate patch if it ends up being
submitted (it handles the edge case of a route on an interface other
than the bond matching before the bond itself).

	-J

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_ma=
in.c
index e75acb14d066..507ff5d50585 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -339,6 +339,36 @@ static bool bond_xdp_check(struct bonding *bond)
 	}
 }
 =

+static void bond_poll_tx_packets(struct slave *slave)
+{
+	struct net_device *dev =3D slave->dev;
+	struct rtnl_link_stats64 stats;
+
+	dev_get_stats(dev, &stats);
+	if (stats.tx_packets !=3D slave->last_tx_packets) {
+		slave->last_tx_change =3D jiffies;
+		slave->last_tx_packets =3D stats.tx_packets;
+	}
+}
+
+/* Determine time of last transmit for slave.
+ *
+ * For device drivers that maintain trans_start (presumed to be any devic=
e
+ * that implements an ndo_tx_timeout), use dev_trans_start.  For other
+ * devices (typically virtual devices), inspect interface statistics for
+ * recent change to tx_packets.
+ */
+static unsigned long bond_dev_trans_start(struct slave *slave)
+{
+	struct net_device *dev =3D slave->dev;
+
+	if (dev->netdev_ops->ndo_tx_timeout)
+		return dev_trans_start(dev);
+
+	bond_poll_tx_packets(slave);
+	return slave->last_tx_change;
+}
+
 /*---------------------------------- VLAN -------------------------------=
----*/
 =

 /* In the following 2 functions, bond_vlan_rx_add_vid and bond_vlan_rx_ki=
ll_vid,
@@ -2943,7 +2973,7 @@ static void bond_arp_send_all(struct bonding *bond, =
struct slave *slave)
 =

 		/* Find out through which dev should the packet go */
 		rt =3D ip_route_output(dev_net(bond->dev), targets[i], 0,
-				     RTO_ONLINK, 0);
+				     RTO_ONLINK, bond->dev->ifindex);
 		if (IS_ERR(rt)) {
 			/* there's no route to target - try to send arp
 			 * probe to generate any traffic (arp_validate=3D0)
@@ -3075,7 +3105,7 @@ static int bond_arp_rcv(const struct sk_buff *skb, s=
truct bonding *bond,
 		bond_validate_arp(bond, slave, tip, sip);
 	else if (curr_arp_slave && (arp->ar_op =3D=3D htons(ARPOP_REPLY)) &&
 		 bond_time_in_interval(bond,
-				       dev_trans_start(curr_arp_slave->dev), 1))
+				       bond_dev_trans_start(curr_arp_slave), 1))
 		bond_validate_arp(bond, slave, sip, tip);
 =

 out_unlock:
@@ -3247,7 +3277,7 @@ static int bond_na_rcv(const struct sk_buff *skb, st=
ruct bonding *bond,
 		bond_validate_ns(bond, slave, saddr, daddr);
 	else if (curr_arp_slave &&
 		 bond_time_in_interval(bond,
-				       dev_trans_start(curr_arp_slave->dev), 1))
+				       bond_dev_trans_start(curr_arp_slave), 1))
 		bond_validate_ns(bond, slave, saddr, daddr);
 =

 out:
@@ -3335,7 +3365,7 @@ static void bond_loadbalance_arp_mon(struct bonding =
*bond)
 	 *       so it can wait
 	 */
 	bond_for_each_slave_rcu(bond, slave, iter) {
-		unsigned long trans_start =3D dev_trans_start(slave->dev);
+		unsigned long trans_start =3D bond_dev_trans_start(slave);
 =

 		bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
 =

@@ -3482,7 +3512,6 @@ static int bond_ab_arp_inspect(struct bonding *bond)
 		 * - (more than missed_max*delta since receive AND
 		 *    the bond has an IP address)
 		 */
-		trans_start =3D dev_trans_start(slave->dev);
 		if (bond_is_active_slave(slave) &&
 		    (!bond_time_in_interval(bond, trans_start, bond->params.missed_max)=
 ||
 		     !bond_time_in_interval(bond, last_rx, bond->params.missed_max))) {
@@ -3511,7 +3540,7 @@ static void bond_ab_arp_commit(struct bonding *bond)
 			continue;
 =

 		case BOND_LINK_UP:
-			trans_start =3D dev_trans_start(slave->dev);
+			trans_start =3D bond_dev_trans_start(slave);
 			if (rtnl_dereference(bond->curr_active_slave) !=3D slave ||
 			    (!rtnl_dereference(bond->curr_active_slave) &&
 			     bond_time_in_interval(bond, trans_start, 1))) {
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 6e78d657aa05..6449fe755e8a 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -165,6 +165,8 @@ struct slave {
 	unsigned long last_link_up;
 	unsigned long last_rx;
 	unsigned long target_last_arp_rx[BOND_MAX_ARP_TARGETS];
+	unsigned long last_tx_packets;
+	unsigned long last_tx_change;
 	s8     link;		/* one of BOND_LINK_XXXX */
 	s8     link_new_state;	/* one of BOND_LINK_XXXX */
 	u8     backup:1,   /* indicates backup slave. Value corresponds with

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
