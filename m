Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC341622162
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 02:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiKIBnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 20:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbiKIBlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 20:41:32 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72E668AD9
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 17:40:25 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id k15so15371527pfg.2
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 17:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9ZWqTaX09OZilKeys/FZHi9MP/SKn/peXP/E92qOkSU=;
        b=T671QRy3vHfhlPTfK1kOMXfLz2rnhmclJ5ZeKDgRF0qq3HZap+RQHqW9qcNdj8hnM4
         f4wsDm+jha2vd8DjEfvZlwIqPCQrLMcwwy0JhuS8C/aCWtbIXUxVAikrQibRNUFH/oc7
         xeFb4kEa7cms939SZINnIeZH27EHBA1asWYDErU6gkEg5HgdTNlO4mpz53S6mulix7HE
         kpL7KL1thURNw3IiruWn3IDuJHNuGQV7mAz6AQJvbdGz/LCuuHTFqSE1d4B2FdguPzuU
         JIwBMPSVH8bHTaPgfLy1GzWY+08YZ99dcggPaa3AcNLvS/0wru8vV49ETBVNy7k+vaqL
         ek7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9ZWqTaX09OZilKeys/FZHi9MP/SKn/peXP/E92qOkSU=;
        b=FpZtUcjVDAcZjfJ1EPAS7qg4aBxf/+9SfbDHX7JWX0zi2BZUSabK3j80O3IrddmETB
         QRqLytJTqxJHplz3Jr96x472L9OVhtDDHUZmtcM2RUSGagVyCe/KZd8wX3aHeGWENnBv
         U0cc6hzQW5OcDkxzWnqgk8EwQyfJy2FuBg2Oyo/gRHpqLPeaVmunmu0PydNqKnN5Ip7+
         LIIHKmN3JkLEaQZGMgASS79ohNpiT4d5H2Y12PO+5UoJT/AKKBpQSClWdG5H5qGvcp2e
         0xpufv0wQtE8d0E5MMIb8zn1w7MuKXLFon2Py1S3QF+C8akHIYcRwUEfgc2JbTpSZ/7s
         H9zw==
X-Gm-Message-State: ACrzQf0P/M7xNA1ElN7xBLaJLo3Ud9kpBJG+COBvXi2+GchnY2bejLMy
        U1FkneMgCmIoe5zAlHrPUGBVd551bCBAkg==
X-Google-Smtp-Source: AMsMyM4SaMwTzDr2Q0Mvdqpzdw198U7dSPq/UQaMAkGz2QY9evBI8J74TNxkTbVeKRdUSKBFQCK62A==
X-Received: by 2002:a65:5582:0:b0:46f:6321:1b44 with SMTP id j2-20020a655582000000b0046f63211b44mr48978244pgs.462.1667958025047;
        Tue, 08 Nov 2022 17:40:25 -0800 (PST)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y3-20020a17090a1f4300b002135fdfa995sm8593579pjy.25.2022.11.08.17.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 17:40:24 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Liang Li <liali@redhat.com>, David Ahern <dsahern@kernel.org>
Subject: [PATCHv3 net] bonding: fix ICMPv6 header handling when receiving IPv6 messages
Date:   Wed,  9 Nov 2022 09:40:18 +0800
Message-Id: <20221109014018.312181-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we get icmp6hdr via function icmp6_hdr(), which needs the skb
transport header to be set first. But there is no rule to ask driver set
transport header before netif_receive_skb() and bond_handle_frame(). So
we will not able to get correct icmp6hdr on some drivers.

Fix this by checking the skb length manually and getting icmp6 header based
on the IPv6 header offset.

Reported-by: Liang Li <liali@redhat.com>
Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
Acked-by: Jonathan Toppins <jtoppins@redhat.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v3: fix _hdr parameter warning reported by kernel test robot
v2: use skb_header_pointer() to get icmp6hdr as Jay suggested.
---
 drivers/net/bonding/bond_main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e84c49bf4d0c..2c6356232668 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3231,12 +3231,17 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
 		       struct slave *slave)
 {
 	struct slave *curr_active_slave, *curr_arp_slave;
-	struct icmp6hdr *hdr = icmp6_hdr(skb);
 	struct in6_addr *saddr, *daddr;
+	const struct icmp6hdr *hdr;
+	struct icmp6hdr _hdr;
 
 	if (skb->pkt_type == PACKET_OTHERHOST ||
 	    skb->pkt_type == PACKET_LOOPBACK ||
-	    hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
+	    ipv6_hdr(skb)->nexthdr != NEXTHDR_ICMP)
+		goto out;
+
+	hdr = skb_header_pointer(skb, sizeof(struct ipv6hdr), sizeof(_hdr), &_hdr);
+	if (!hdr || hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
 		goto out;
 
 	saddr = &ipv6_hdr(skb)->saddr;
-- 
2.38.1

