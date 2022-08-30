Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A91835A5FA1
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiH3Jjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbiH3JjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:39:19 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558F4E19
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 02:37:46 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id jm11so10537976plb.13
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 02:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=BZHGH07JG7LzGe6FO3SarvawtG5Ndf4tQjX7x6HJQFs=;
        b=PHH+OC92A8EdVgimhiXIqnaD+2AtzEV9sXVMWheH0X0SMM+sH08oyKr+EKCoHbeCmW
         QPL1myM6EVua9USBKVghwPOWIHFJRfWnIinBB8rha5W3jMQ7ATf34Z15EzjAiVXp0GDL
         91TlGPIZrL1DeovbSFKyCMKbnQJTiS/5Rc4RL49hizzJEGpS4E9d1O+M9s8wPnVCcJrH
         SF72UcFs7WRssLhU/NkI2mZd/k7wXqqoHyCEuC9fOBAT/GtLWxmXbeudSo3OGQTGuipn
         BFCrrIwh+QAXXw1fHC7+e5D1ywdwxPjCC3MfJbQYfpABlV5KTk9+cCcfI9DmFG0sYkGx
         HIhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=BZHGH07JG7LzGe6FO3SarvawtG5Ndf4tQjX7x6HJQFs=;
        b=i2yQTqEkX/krV0M58gbGj3g1CdAMUG3wyrwgQu1iftF1+i4TNNU+bmKGvaTZlhvvq0
         0T5rO/jF4S0no7vcKG8EHJe6XgTjmQK2t4K67oVsrU8uRp58/BDFve4PppAR7XmtdA8L
         QGWzC+pixXa/uYuWiDpUkuOAPGiQAIXDwRni7Q1DtozeNOZCSVcn7Er2QXVzlfMFDxun
         ckdmyxLDMeuNvJw4EqZr+EaelkpRTFwoqt4RwmTF+VBhfPZ9pgXFaG3NF3bQJu4BiHxc
         qK82ZwH/Wb4MDDGEbK8h2NIze0ZhOg9LtsYozUNFECvzvyAhfr8vnnD93vwY+kukutvq
         Hl6Q==
X-Gm-Message-State: ACgBeo0Eg3S3YKjcZqhrWLQpAOnO1zrrNRyzYRqj4Wk8KvjojRY0dWdO
        aY1lLbeiR61sC7k3AyIcm3KnTjue/cxJDw==
X-Google-Smtp-Source: AA6agR6sKghfeUfknL2C5ciD1eMbu0Jb0aie6smFasaUMQZPOnbMLNzqQrmF05QzK2PNrNGz6+BZXg==
X-Received: by 2002:a17:90b:14d2:b0:1fb:acff:998 with SMTP id jz18-20020a17090b14d200b001fbacff0998mr23110259pjb.70.1661852265633;
        Tue, 30 Aug 2022 02:37:45 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h187-20020a62dec4000000b0053639773ad8sm8899393pfg.119.2022.08.30.02.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 02:37:45 -0700 (PDT)
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
Subject: [PATCHv2 net 3/3] bonding: accept unsolicited NA message
Date:   Tue, 30 Aug 2022 17:37:22 +0800
Message-Id: <20220830093722.153161-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220830093722.153161-1-liuhangbin@gmail.com>
References: <20220830093722.153161-1-liuhangbin@gmail.com>
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

The unsolicited NA message with all-nodes multicast dest address should
be valid, as this also means the link could reach the target.

Also rename bond_validate_ns() to bond_validate_na().

Reported-by: LiLiang <liali@redhat.com>
Fixes: 5e1eeef69c0f ("bonding: NS target should accept link local address")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bonding/bond_main.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 531c7465bc51..5c2febe94428 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3201,12 +3201,19 @@ static bool bond_has_this_ip6(struct bonding *bond, struct in6_addr *addr)
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
@@ -3249,14 +3256,14 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
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
-- 
2.37.1

