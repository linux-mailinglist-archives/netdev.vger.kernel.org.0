Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877E7614671
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 10:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiKAJOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 05:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiKAJOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 05:14:09 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA16E007
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 02:14:07 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d10so12926418pfh.6
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 02:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Hm8zcUUhzyaxQ1JABK94lAUO58qxW3OnGhKRV2vUjU8=;
        b=przq77UvtAM1z6AYa2km1ssPHmkOP53aMQ/Ofh7DM/W1WRCzwKpWcEoE3PxOiebnsH
         XWA7WNmgRUt4i/kvFJ++zdIQkE3N5Ydh8m+b0147P5ITtBB8BQzYhFyJT1I6pe2bCVXR
         OnO9jlnEtsTSnJO0HVXEV1VaY36vCO9ok69gwpGfdLaDvuM6lF9+10SxFCYC66RqCGep
         g1D4brYBAnBqG390Pj52O/MXh0vy1n2dJLpp7c63zvly3RWgZlsq9hQzs6UJcG20x2/t
         NuNC5OurwMl97KZWAWt95pIHu1ZTJ3vqbDLUHsVy7LVf0K0TJ3dLfvq6PxqrNl2xp79B
         EsMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hm8zcUUhzyaxQ1JABK94lAUO58qxW3OnGhKRV2vUjU8=;
        b=7Xh4DJHUK/SBdewe/ckpe2xkFPrdc5ghJcVCnrSYCf4qncw3rvYPAu1VGoWJn6IYMP
         Bmyu3ZImIoGclwG0qlt0T79QgVADdRbLG/UNLDNqr7A+QRIxPuiQzQdC3DWc/1mCfiQv
         0eiO7XhBILmUE2ngpYJy+ADtNkP7Z97yK6vlg0Xu57LUBhitU7zB9MHBQmCzHy6ILTGR
         PLbn1Fvenqs6ChOEEM1Zj7PUnSgE5LOLQMXH/rizyFhro+zsgDPcLUiRGR/2suHFYcb6
         LJGB088N4xxwjsEHqwFuwFv7kadC/8CT8dD7Qn1Vg0jg+dh96UKl2PPERxtqAXfijOQU
         mETQ==
X-Gm-Message-State: ACrzQf2pPYKGwpqghTy4GJcYFj2iQAqkBt7XIrNiHZmgjMtUHRs3i9NV
        s9awSdhtWJHwM7sdEK2wZRI8i5VczHGG2Q==
X-Google-Smtp-Source: AMsMyM4SXumbjPsN0YyjvT8YH4XoCEuoTkdIqOZLyOclFhFgdv6WR+31bUeKgTOUD8KXL6SsS79DPQ==
X-Received: by 2002:a05:6a00:1687:b0:565:a932:f05a with SMTP id k7-20020a056a00168700b00565a932f05amr2327809pfc.21.1667294046493;
        Tue, 01 Nov 2022 02:14:06 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p12-20020aa79e8c000000b00561d79f1064sm6047875pfq.57.2022.11.01.02.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 02:14:05 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, Liang Li <liali@redhat.com>
Subject: [PATCH net] bonding: fix ICMPv6 header handling when receiving IPv6 messages
Date:   Tue,  1 Nov 2022 17:13:56 +0800
Message-Id: <20221101091356.531160-1-liuhangbin@gmail.com>
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

Some drivers, like bnx2x, will call ipv6_gro_receive() and set skb
IPv6 transport header before bond_handle_frame(). But some other drivers,
like be2net, will not call ipv6_gro_receive() and skb transport header
is not set properly. Thus we can't use icmp6_hdr(skb) to get the icmp6
header directly when dealing with IPv6 messages.

Fix this by checking the skb length manually and getting icmp6 header based
on the IPv6 header offset.

Reported-by: Liang Li <liali@redhat.com>
Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bonding/bond_main.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e84c49bf4d0c..08b5f512f5fb 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3231,12 +3231,23 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
 		       struct slave *slave)
 {
 	struct slave *curr_active_slave, *curr_arp_slave;
-	struct icmp6hdr *hdr = icmp6_hdr(skb);
+	const struct icmp6hdr *icmp6_hdr;
 	struct in6_addr *saddr, *daddr;
+	const struct ipv6hdr *hdr;
+	u16 pkt_len;
+
+	/* Check if the length is enough manually as we can't use pskb_may_pull */
+	hdr = ipv6_hdr(skb);
+	pkt_len = ntohs(hdr->payload_len);
+	if (hdr->nexthdr != NEXTHDR_ICMP || pkt_len < sizeof(*icmp6_hdr) ||
+	    skb_headlen(skb) < sizeof(*hdr) + pkt_len)
+		goto out;
+
+	icmp6_hdr = (const struct icmp6hdr *)(skb->data + sizeof(*hdr));
 
 	if (skb->pkt_type == PACKET_OTHERHOST ||
 	    skb->pkt_type == PACKET_LOOPBACK ||
-	    hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
+	    icmp6_hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
 		goto out;
 
 	saddr = &ipv6_hdr(skb)->saddr;
-- 
2.38.1

