Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9774BD5B0
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 07:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344795AbiBUFzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 00:55:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344796AbiBUFzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 00:55:42 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8403D5133F
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 21:55:20 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id qe15so14144674pjb.3
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 21:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jKsdS0Q+KxMxQcDFSUzldQEKhocLBHQRYT/z+4OmJnw=;
        b=q2SVUQaWozpG4gRF2QGN7vk2D874x1uegINuIM0ddWxQEVBJNU7IGJGfB4FE1ZqRM+
         egLq1PMNlX16VYTsOAZ1GdTm5X45275rGJUy4e14mcoQPAJybPIYcxfXVCEtEMP6sRL4
         UenIHGSkdMiqinuvK06AvmsyQnHyTbiqcD86kgDrM5FHHBE55cA7mjKHw1lIXkxXL0dR
         PzEgLeFOBLWFrh3+UHg7s3nC3HEoEn+jJp5WoVBv9lTToal/n3dczY9CRbnjpJjrh5CS
         jvrcxcSXZoMveMk4QoDpWFq9Sp3HbT07NQZkrUr6Qyzfv+Kq9rqV6tMfiQyq77VlOT/x
         7wyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jKsdS0Q+KxMxQcDFSUzldQEKhocLBHQRYT/z+4OmJnw=;
        b=kgQ+Z0GveIGohPH7FRC6NGjaAT/QYRcAOHnWTm75Zrt1rbzruXEP3GTEkygUGmexZk
         7p8oWwZ8K0gvi895SjQ5UoG+0vz9kMIUOCbsS7QgD68PzNf4T+iUCJRr6+QZWxYR83oT
         XwSn2bsB6eNlfnCttYwralINPmQNSG83JJKEgN1svJEEiaSMRlKwx3Un6VM3l6zd7Ajq
         L/GLuGNfPhEnILkMa9ygFvPyZIhLfOYCJiSbjIha6+deYY5ccNC78tGSfdGlu7wygTwj
         Y76UgArKGlTssy4FurKJ604rmptP1RnOJ1cs53KOpUqeUbf1VA0+OWIN3opng4rb6uSY
         ksCw==
X-Gm-Message-State: AOAM532D/QIMbk5ZVgmlAjeOgD7lvjVtZQrs6SpBU53YYk7nphXPjyZO
        UrTac12hwB5qzL9bYMb7CSsiQIeRxDA=
X-Google-Smtp-Source: ABdhPJyT2pe2c6G/TTwSxCoMo6fIlCMQPQbgXdAOUlEcLCHkidlk/2rs4bpD/cO8yeNEOgxuf0l3fA==
X-Received: by 2002:a17:90b:4a85:b0:1b9:d80d:bff with SMTP id lp5-20020a17090b4a8500b001b9d80d0bffmr24204796pjb.67.1645422919828;
        Sun, 20 Feb 2022 21:55:19 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s15sm17359767pgn.30.2022.02.20.21.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 21:55:19 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net-next 2/5] Bonding: split bond_handle_vlan from bond_arp_send
Date:   Mon, 21 Feb 2022 13:54:54 +0800
Message-Id: <20220221055458.18790-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220221055458.18790-1-liuhangbin@gmail.com>
References: <20220221055458.18790-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function bond_handle_vlan() is split from bond_arp_send() for later
IPv6 usage.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bonding/bond_main.c | 58 +++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 57d182c9f7d5..ca8613d0f947 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2793,31 +2793,15 @@ static bool bond_has_this_ip(struct bonding *bond, __be32 ip)
 	return ret;
 }
 
-/* We go to the (large) trouble of VLAN tagging ARP frames because
- * switches in VLAN mode (especially if ports are configured as
- * "native" to a VLAN) might not pass non-tagged frames.
- */
-static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
-			  __be32 src_ip, struct bond_vlan_tag *tags)
+static bool bond_handle_vlan(struct slave *slave, struct bond_vlan_tag *tags,
+			     struct sk_buff *skb)
 {
-	struct sk_buff *skb;
-	struct bond_vlan_tag *outer_tag = tags;
-	struct net_device *slave_dev = slave->dev;
 	struct net_device *bond_dev = slave->bond->dev;
-
-	slave_dbg(bond_dev, slave_dev, "arp %d on slave: dst %pI4 src %pI4\n",
-		  arp_op, &dest_ip, &src_ip);
-
-	skb = arp_create(arp_op, ETH_P_ARP, dest_ip, slave_dev, src_ip,
-			 NULL, slave_dev->dev_addr, NULL);
-
-	if (!skb) {
-		net_err_ratelimited("ARP packet allocation failed\n");
-		return;
-	}
+	struct net_device *slave_dev = slave->dev;
+	struct bond_vlan_tag *outer_tag = tags;
 
 	if (!tags || tags->vlan_proto == VLAN_N_VID)
-		goto xmit;
+		return true;
 
 	tags++;
 
@@ -2834,7 +2818,7 @@ static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
 						tags->vlan_id);
 		if (!skb) {
 			net_err_ratelimited("failed to insert inner VLAN tag\n");
-			return;
+			return false;
 		}
 
 		tags++;
@@ -2847,8 +2831,34 @@ static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
 				       outer_tag->vlan_id);
 	}
 
-xmit:
-	arp_xmit(skb);
+	return true;
+}
+
+/* We go to the (large) trouble of VLAN tagging ARP frames because
+ * switches in VLAN mode (especially if ports are configured as
+ * "native" to a VLAN) might not pass non-tagged frames.
+ */
+static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
+			  __be32 src_ip, struct bond_vlan_tag *tags)
+{
+	struct net_device *bond_dev = slave->bond->dev;
+	struct net_device *slave_dev = slave->dev;
+	struct sk_buff *skb;
+
+	slave_dbg(bond_dev, slave_dev, "arp %d on slave: dst %pI4 src %pI4\n",
+		  arp_op, &dest_ip, &src_ip);
+
+	skb = arp_create(arp_op, ETH_P_ARP, dest_ip, slave_dev, src_ip,
+			 NULL, slave_dev->dev_addr, NULL);
+
+	if (!skb) {
+		net_err_ratelimited("ARP packet allocation failed\n");
+		return;
+	}
+
+	if (bond_handle_vlan(slave, tags, skb))
+		arp_xmit(skb);
+	return;
 }
 
 /* Validate the device path between the @start_dev and the @end_dev.
-- 
2.31.1

