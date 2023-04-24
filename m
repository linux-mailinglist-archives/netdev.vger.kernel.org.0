Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F311B6EC349
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 02:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjDXAee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 20:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjDXAed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 20:34:33 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DE510D7
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 17:34:32 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id 3f1490d57ef6-b992ed878ebso10172198276.0
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 17:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682296471; x=1684888471;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a3CckBqXVGkCTVcmDfTD7j5MAjFBqpCXOhYss3p1vu0=;
        b=XcPR78UzL6/8PpFDqVU60UgfV0zsedOsM0RiFcOLWS2E0xA1m1t2yX2MNC6yDPUnwC
         OKIikf7Oewpc5BnVjBm2gr3XrGk2Nrioe/QFM2UOrdNWSpRJBodx5v9Jw52M/MQyIE/8
         JGCIqrrCKmr9Dq5RGNfrl4rMPvrCGLe5B8PsYC6RKwrp1872NL5YolR7ivxeyCl5huZk
         QOxg5HV10dnE+YImM68BkRgSF9RyETV1ZxFDCGpXEirwPN+JosvrIMFFAkM8flV2jsdB
         igYGsxI3MG+ss4lPZZGiw6zAOy0ruXndWnGmqdf9y7Mtkjh7ojz15h9i9IEDbP7gRyhV
         BMjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682296471; x=1684888471;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a3CckBqXVGkCTVcmDfTD7j5MAjFBqpCXOhYss3p1vu0=;
        b=F5eJcuTQOJA9Pzc1lLA6eCaVyaG/pPBIZM6PVVqJ9OPfAh1v3LHnsHcXs23n2ZT+Bs
         o6mD7lBKOuVlVZNV+pPuQDY5mRzgc70ZnYys+YrH5RLiFuwl8vuFWHOkoTm4P5owYrRF
         DGM0KkTfFyNoCzqA3GLxLiVie3J2JDDYD5MEkBmncGOK4NXfZ+yBm+ttVFBSblG4ouIG
         +ox77niS6ROTpeVIWyrFPOX7vsPiWTFH94PE2CRhBTr845jafMOIqK1R6F0c6AnmRJyn
         1R7g14lqmoUQJ/l4ERrrMRb2kpS+zlVJmuBFkdnxOeGyEDaJkb8Mb0LtcWrOI49BBsRU
         lsYA==
X-Gm-Message-State: AAQBX9cBKdQMV+K7/FSmBSW/yULCPSWiWCQoZoHzFP8s4yruI2Q5O1BW
        dKMg5otuyKkUzJ+n8fbmbUvYc71UnOZqCw==
X-Google-Smtp-Source: AKy350YAw+dud/Ji2NI4L4Ybuf4P7P050SYbEOQSXfqqbkdoVOkSZ5KQpEQ/84es/+QdvoEFRI0fkA==
X-Received: by 2002:a0d:dbcb:0:b0:54f:8636:2152 with SMTP id d194-20020a0ddbcb000000b0054f86362152mr7378912ywe.15.1682296470958;
        Sun, 23 Apr 2023 17:34:30 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:ee97:aa9b:7d0c:f792])
        by smtp.gmail.com with ESMTPSA id s127-20020a815e85000000b0054f8b69889fsm2601583ywb.74.2023.04.23.17.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 17:34:30 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        Palash Oswal <oswalpalash@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [Patch net] sit: update dev->needed_headroom in ipip6_tunnel_bind_dev()
Date:   Sun, 23 Apr 2023 17:34:14 -0700
Message-Id: <20230424003414.630339-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
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

From: Cong Wang <cong.wang@bytedance.com>

When a tunnel device is bound with the underlying device, its
dev->needed_headroom needs to be updated properly. IPv4 tunnels
already do the same in ip_tunnel_bind_dev().

Note, this is targeting for -net and -table, so I'd keep the fix
small. We can refactor and reuse ip_tunnel_bind_dev() for -net-next.

Fixes: 32b8a8e59c9c ("sit: add IPv4 over IPv4 support")
Reported-by: Palash Oswal <oswalpalash@gmail.com>
Link: https://lore.kernel.org/netdev/CAGyP=7fDcSPKu6nttbGwt7RXzE3uyYxLjCSE97J64pRxJP8jPA@mail.gmail.com/
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/ipv6/sit.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 70d81bba5093..3a8f04ba4947 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1096,11 +1096,12 @@ static netdev_tx_t sit_tunnel_xmit(struct sk_buff *skb,
 static void ipip6_tunnel_bind_dev(struct net_device *dev)
 {
 	struct net_device *tdev = NULL;
-	struct ip_tunnel *tunnel;
+	struct ip_tunnel *tunnel = netdev_priv(dev);
 	const struct iphdr *iph;
 	struct flowi4 fl4;
+	int t_hlen = tunnel->hlen + sizeof(struct iphdr);
+	int hlen = LL_MAX_HEADER;
 
-	tunnel = netdev_priv(dev);
 	iph = &tunnel->parms.iph;
 
 	if (iph->daddr) {
@@ -1123,14 +1124,15 @@ static void ipip6_tunnel_bind_dev(struct net_device *dev)
 		tdev = __dev_get_by_index(tunnel->net, tunnel->parms.link);
 
 	if (tdev && !netif_is_l3_master(tdev)) {
-		int t_hlen = tunnel->hlen + sizeof(struct iphdr);
 		int mtu;
 
 		mtu = tdev->mtu - t_hlen;
 		if (mtu < IPV6_MIN_MTU)
 			mtu = IPV6_MIN_MTU;
 		WRITE_ONCE(dev->mtu, mtu);
+		hlen = tdev->hard_header_len + tdev->needed_headroom;
 	}
+	dev->needed_headroom = t_hlen + hlen;
 }
 
 static void ipip6_tunnel_update(struct ip_tunnel *t, struct ip_tunnel_parm *p,
-- 
2.34.1

