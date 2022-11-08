Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6DC6209D3
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 08:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbiKHHA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 02:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232641AbiKHHA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 02:00:57 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3621A396
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 23:00:56 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so17054713pjc.3
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 23:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jR9o9ZJQ/XtceLX51Lo3kkzHJn1O9FPgW4DuTb6MrUA=;
        b=bb1yMd1G6Sp+Hg1OFKP5m6IzyvoulhoZB7DoEN6c/pufmIEMXmZVG7pONI/+XHJcH/
         CdsoEPElU5tzIHEQNxss/ou4jVnGbkEW9Jo4oEJ2qKM+hBhRT6lz9yZsf6WpCMa/1d2O
         nRMEuhFRb8uOEVy0mUognQZzicvvwtQZY+seguw7d41Jwl8JHIZ+0yryNofBD/H7dobl
         TPtnQ9+I68l2U8l5T9KWz+ZP+WVcUX3a4Oon+pDKL3dLiPSA+nCAc53zEdw2MKUWhrOu
         ymg6auLlrw4NtN9le10J4X/qTYOTg6z9J2poYXeu3wR+VMMtxeevYBLUyWptUGpzHKHJ
         fjdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jR9o9ZJQ/XtceLX51Lo3kkzHJn1O9FPgW4DuTb6MrUA=;
        b=n4oCys8MzzyrVx6buQAPOuL/FulymGq37jYrT1otsftu8P1SN8/O6vbUUbltr7yFF+
         wnTz8SLvPOGANBMYfVC1lbZHSWOPJK80EU4/XmTH0dMY8oG4s9XY+6ESJSr9BoIUC37N
         XDQVqM83nvfEDgiw5vOMdzJ0uwOIcu8pGDd8GJk4luhwAKztsMn4OSayVQtyAq8dYoVo
         vWD8JI1Y66tHm5H3zFalyUh0V4NXn0aaV5Ib/wFLHYPxJiBxRPEO80eRKgol1dIvM/Dz
         1v8p2ifgBbd/zEKbohMw7qEiQ168GRdi5L1Y+kRM5yXraxBVeh/JHY5dX1YPtrkk5CCR
         SyZQ==
X-Gm-Message-State: ACrzQf2VIfrhaSRMvb9RKPdBz4cIzXAHSOO6hDYH0MEswZ8d2hEu5Cpb
        xSV+XnuV/FPS0hWMfHGrwGdu8S0ft4g=
X-Google-Smtp-Source: AMsMyM56yhHaaDigedZPqbOd++HnxDjtk0sByO0RENGiKfK9meSh2O/GUnnH0Wjw6G08udLyiniLKw==
X-Received: by 2002:a17:902:9a8b:b0:17a:455:d967 with SMTP id w11-20020a1709029a8b00b0017a0455d967mr53543483plp.52.1667890855575;
        Mon, 07 Nov 2022 23:00:55 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f4-20020a170902e98400b001782aab6318sm6100921plb.68.2022.11.07.23.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 23:00:54 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, Liang Li <liali@redhat.com>
Subject: [PATCHv2 net] bonding: fix ICMPv6 header handling when receiving IPv6 messages
Date:   Tue,  8 Nov 2022 15:00:35 +0800
Message-Id: <20221108070035.177036-1-liuhangbin@gmail.com>
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
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: use skb_header_pointer() to get icmp6hdr as Jay suggested.
---
 drivers/net/bonding/bond_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e84c49bf4d0c..4599cf340201 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3231,12 +3231,16 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
 		       struct slave *slave)
 {
 	struct slave *curr_active_slave, *curr_arp_slave;
-	struct icmp6hdr *hdr = icmp6_hdr(skb);
+	const struct icmp6hdr *hdr, _hdr;
 	struct in6_addr *saddr, *daddr;
 
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

