Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D2049D780
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 02:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbiA0BeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 20:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbiA0BeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 20:34:11 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79713C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 17:34:11 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id h14so1193668plf.1
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 17:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dlLWVWHrYJR6rQuFsR27aG7SdKEXnQGF/3pN0GA8jwM=;
        b=LqlEaxdbyOPi3KJK1yg+/kTHkq4P7icL6Hq9g3Ri0BS4Sfeth0Ql55Wmi8xF20RL+d
         5eu4bCkSl2BQYHcuZwB+d+im4Zb9i88oDPOc3OnsBqKkzOQoeBXr8bCPRmbHvZUc+M3N
         Pdx8tZG2z8i387wIzx0LTbPu5LsBBKZwINyWkMx9bA86CN8RfePGRYBsbySYJxAnddgZ
         P+/qrui79YjCqIG8s3GItfLglrQ5LYbupqtWBZu2fIqOsA+uFzI1NDp9WMBT0U8xPv3u
         rDiQgwpw7ttOSLxACnhyzNNqf0IdE29kiH83ikda7fi90Vho58JmLGi/VqFCaPxvtLwE
         j0Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dlLWVWHrYJR6rQuFsR27aG7SdKEXnQGF/3pN0GA8jwM=;
        b=p0ay90CuV0qloOStNutYjUDBJAC2Scarbk/OjPPdzt9TR2k7HDrvQlOhfQSR/lHTXe
         xyeO4+oPShb0lg3FtxBnA8yOJ1McjilKbpim8qb7LhoYJZjGLWBNqBy8e2hFvXHi67jS
         WlR7Nv3f49ei1CtaACBuNK6+6AA1/yBIf5dFGGOBfIBcBMwWqQ5A4BFrmUPe3X/GNygy
         NfI4Pn5sawlt41dJ83w/f2YT/Nn6o9DFJYVvB55XTykWnMD+xyP5HbhPGNiqfQJXk5jC
         +V6cb2eTNzLHofwfukP0+RNR4+urN4RWYNoAj10ed0RQDxUkOlVrAEZkMqGmwYi/Bf2O
         860Q==
X-Gm-Message-State: AOAM530+5GUfisGaQMirEQoCTka1AE6xR3Scy9E4SyyAGampPQRP5DuB
        tSiLJk/eoy5Y/BMJQT8hsOw=
X-Google-Smtp-Source: ABdhPJwJJXxqOL2t08P4MPx69pvS5CgSUByMPMxsz+wtgH0zPQ5tmU78e+wZYWLY58Wc0qEwhJ1ddQ==
X-Received: by 2002:a17:902:a708:: with SMTP id w8mr1618079plq.101.1643247250994;
        Wed, 26 Jan 2022 17:34:10 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:cfcb:2c25:b567:59da])
        by smtp.gmail.com with ESMTPSA id qe12sm4176940pjb.14.2022.01.26.17.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 17:34:10 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net] ipv4: remove sparse error in ip_neigh_gw4()
Date:   Wed, 26 Jan 2022 17:34:04 -0800
Message-Id: <20220127013404.1279313-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

./include/net/route.h:373:48: warning: incorrect type in argument 2 (different base types)
./include/net/route.h:373:48:    expected unsigned int [usertype] key
./include/net/route.h:373:48:    got restricted __be32 [usertype] daddr

Fixes: 5c9f7c1dfc2e ("ipv4: Add helpers for neigh lookup for nexthop")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Ahern <dsahern@gmail.com>
---
 include/net/route.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/route.h b/include/net/route.h
index 4c858dcf1aa8cd1988746e55eb698ad4425fd77b..25404fc2b48374c69081b8c72c2ea1dbbc09ed7f 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -370,7 +370,7 @@ static inline struct neighbour *ip_neigh_gw4(struct net_device *dev,
 {
 	struct neighbour *neigh;
 
-	neigh = __ipv4_neigh_lookup_noref(dev, daddr);
+	neigh = __ipv4_neigh_lookup_noref(dev, (__force u32)daddr);
 	if (unlikely(!neigh))
 		neigh = __neigh_create(&arp_tbl, &daddr, dev, false);
 
-- 
2.35.0.rc0.227.g00780c9af4-goog

