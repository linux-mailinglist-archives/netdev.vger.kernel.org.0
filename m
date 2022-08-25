Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF0D5A07C6
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 06:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiHYENm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 00:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiHYENk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 00:13:40 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5B39DF80
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 21:13:37 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id z187so18471717pfb.12
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 21:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=C8F+e+HBXHYo3t+48VkV/Wvcm90jIx9LOPCmfbl4YdE=;
        b=C68xev/dfjX1nUE+cLKp91iRHUow4+i0HcgRZSd1n9Im1kprJCAat7daBXJl+BHFF5
         QxPEoAnUxHYZ+RK1VhVt47D2OmHp8A5Zjue4U58qeUmFyb0gXZoQgc/zjOQMLbojp7oG
         /Q9pz9SvKCzQBJ+Nu++xe6U8CY1iSwhK5vCXhH0ZvgplYCwcu2BcWuv3l/PQnwNPfpdK
         JyGZCgw4uwwEBNw7sqvQE6wMOBosy25XXwR94dKNPo30BNd1bsYcANxd6dbpCejjqfBY
         1TUxUoNzgyocZ24JgzxGFGTRWII52g2edJ4Kz7L2SlsR3TXm5kVpZQBywuLze6mHa1AX
         dt9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=C8F+e+HBXHYo3t+48VkV/Wvcm90jIx9LOPCmfbl4YdE=;
        b=q3H2YhrL80PATkxVv+YnwlAhE6b2o35AqLRhet6JdVU9/0znZa6mtk8Oxr//dZhyA/
         IUqvRuarkUlGHoU1ZXdnRTT3wQhFa3geOKiibZfzhn+qDsBgQhzK6wUf5QJnjnxmy6XS
         lWMDmNml29OOCRYVdrhYD2vgZTPG8XWvRbTcub4JPBBJV9zjbMD2t5MguQc3ZLQ0Iu40
         yNM573VjPmx3dSoYV5ZcGQqnUqGXY9VyXGeIGe55fDtstFOTdoOJ4hnO7NZ+EpApZ2og
         m5/0sX3obs+oDa7jxJe+Ijh1PsC+iRQWWs7Tnwu2fpdad6OV5nxO70kq2YKTsG6Cfocp
         WLmg==
X-Gm-Message-State: ACgBeo390ufHxz43XCuHZrG65/du9qLOwqRis9US8GS3FW5peQsE0UnL
        +MielyNf40B7Q5HOy5mShjfrheDd/f0=
X-Google-Smtp-Source: AA6agR5VWbAY2TPcyU8mNepG7zYgLjOXVLWWVK4/94AmKimnd8HnrxyIcUKBoAQwL2cRFP3gsex0vA==
X-Received: by 2002:a63:504:0:b0:42a:aaf6:5fc4 with SMTP id 4-20020a630504000000b0042aaaf65fc4mr1708691pgf.369.1661400816586;
        Wed, 24 Aug 2022 21:13:36 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 123-20020a620681000000b0052d417039c2sm13881416pfg.133.2022.08.24.21.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 21:13:36 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, LiLiang <liali@redhat.com>
Subject: [PATCH net] bonding: fix lladdr finding and confirmation
Date:   Thu, 25 Aug 2022 12:13:27 +0800
Message-Id: <20220825041327.608748-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.1
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

There are 3 issues when setting lladdr as bonding IPv6 target

1. On the send side. When ns_ip6_target was set, the ipv6_dev_get_saddr()
   will be called to get available src addr and send IPv6 neighbor solicit
   message.

   If the target is global address, ipv6_dev_get_saddr() will get any
   available src address. But if the target is link local address,
   ipv6_dev_get_saddr() will only get available address from out interace,
   i.e. the corresponding bond interface.

   But before bond interface up, all the address is tentative, while
   ipv6_dev_get_saddr() will ignore tentative address. This makes we can't
   find available link local src address, then bond_ns_send() will not be
   called and no NS message was sent. Thus no NA message received and bond
   interface will keep in down state.

   Fix this by sending NS with unspecified address if there is no available
   source address.

2. On the receive side. The slave was set down before enslave to bond.
   This makes slaves remove mcast address 33:33:00:00:00:01( The IPv6
   maddr ff02::1 is kept even when the interface down). When bond set
   slave up, the ipv6_mc_up() was not called due to commit c2edacf80e15
   ("bonding / ipv6: no addrconf for slaves separately from master").
   This makes the slave interface never add the all node mcast address
   33:33:00:00:00:01. So there is no way to accept unsolicited NA with
   dest ff02::1.

   Fix this by adding all node mcast address 33:33:00:00:00:01 back when
   the slave interface up.

3. On the validating side. The NA message with all-nodes multicast dest
   address should also be valid.

   Also rename bond_validate_ns() to bond_validate_na().

Reported-by: LiLiang <liali@redhat.com>
Fixes: 5e1eeef69c0f ("bonding: NS target should accept link local address")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bonding/bond_main.c | 20 +++++++++++++++-----
 net/ipv6/addrconf.c             |  7 +++++--
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 2f4da2c13c0a..5c2febe94428 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3167,6 +3167,9 @@ static void bond_ns_send_all(struct bonding *bond, struct slave *slave)
 found:
 		if (!ipv6_dev_get_saddr(dev_net(dst->dev), dst->dev, &targets[i], 0, &saddr))
 			bond_ns_send(slave, &targets[i], &saddr, tags);
+		else
+			bond_ns_send(slave, &targets[i], &in6addr_any, tags);
+
 		dst_release(dst);
 		kfree(tags);
 	}
@@ -3198,12 +3201,19 @@ static bool bond_has_this_ip6(struct bonding *bond, struct in6_addr *addr)
 	return ret;
 }
 
-static void bond_validate_ns(struct bonding *bond, struct slave *slave,
+static void bond_validate_na(struct bonding *bond, struct slave *slave,
 			     struct in6_addr *saddr, struct in6_addr *daddr)
 {
 	int i;
 
-	if (ipv6_addr_any(saddr) || !bond_has_this_ip6(bond, daddr)) {
+	/* Ignore NAs that:
+	 * 1. Source address is unspecified address.
+	 * 2. Dest address is neither all-nodes multicast address nor
+	 *    exist on bond interface.
+	 */
+	if (ipv6_addr_any(saddr) ||
+	    (!ipv6_addr_equal(daddr, &in6addr_linklocal_allnodes) &&
+	     !bond_has_this_ip6(bond, daddr))) {
 		slave_dbg(bond->dev, slave->dev, "%s: sip %pI6c tip %pI6c not found\n",
 			  __func__, saddr, daddr);
 		return;
@@ -3246,14 +3256,14 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
 	 * see bond_arp_rcv().
 	 */
 	if (bond_is_active_slave(slave))
-		bond_validate_ns(bond, slave, saddr, daddr);
+		bond_validate_na(bond, slave, saddr, daddr);
 	else if (curr_active_slave &&
 		 time_after(slave_last_rx(bond, curr_active_slave),
 			    curr_active_slave->last_link_up))
-		bond_validate_ns(bond, slave, saddr, daddr);
+		bond_validate_na(bond, slave, saddr, daddr);
 	else if (curr_arp_slave &&
 		 bond_time_in_interval(bond, slave_last_tx(curr_arp_slave), 1))
-		bond_validate_ns(bond, slave, saddr, daddr);
+		bond_validate_na(bond, slave, saddr, daddr);
 
 out:
 	return RX_HANDLER_ANOTHER;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index e15f64f22fa8..77750b6327e7 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3557,11 +3557,14 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 		fallthrough;
 	case NETDEV_UP:
 	case NETDEV_CHANGE:
-		if (dev->flags & IFF_SLAVE)
+		if (idev && idev->cnf.disable_ipv6)
 			break;
 
-		if (idev && idev->cnf.disable_ipv6)
+		if (dev->flags & IFF_SLAVE) {
+			if (event == NETDEV_UP && !IS_ERR_OR_NULL(idev))
+				ipv6_mc_up(idev);
 			break;
+		}
 
 		if (event == NETDEV_UP) {
 			/* restore routes for permanent addresses */
-- 
2.37.1

