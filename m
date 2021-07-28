Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC9C3D949D
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 19:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhG1Rxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 13:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhG1Rxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 13:53:50 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3F6C061765;
        Wed, 28 Jul 2021 10:53:47 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id u9-20020a17090a1f09b029017554809f35so11214970pja.5;
        Wed, 28 Jul 2021 10:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+UFJID3RK8Mvf3O9hNEMzPnkq+/m+AsX5JYEUoSr13k=;
        b=JYdQ5tZKKdcp4RlelLIau9Za74wbrVH+YGbCQCINoGN5L/pd+JA8l0SuJIsus9oWnf
         yoPZiNNvlEXGNO0O1WyvXpMdp8hUUyZHUgy6Elx4DbRshi3HuO+CpEM+RyhoY/NFQV80
         8XGcmoALThMEp1YYbeTH5TspZdHPzGz/82MZyNQNmioaSL/xpvskZVpm/6SmQt0KGXci
         P3Jmi4BqCMjzqkrpxYqs8zJwRHCkn8TlAu+rDxQIcqgVdDYzOhW/lQUu+now/bXGPbCA
         DGiFJNX31RivzZlZA7/YY5dyqhc2WT2/TbiTYofmzDLbeOSFfQX6GM7AgSxSelVI32FG
         VwNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+UFJID3RK8Mvf3O9hNEMzPnkq+/m+AsX5JYEUoSr13k=;
        b=ld7km2n+fhQ9JW0y9MfYVbODphed8tdffRMJgHxgBvqDiHNDHwxNJgRjYgo0rKg3f5
         gz5yc3PgwRk48Gn9wP1jfks3YVw6YZshEaG+97c6JCPqzAo8GKuAsLdJJRXOOzSeagPO
         /n9QCWXMTsyfpHtR9nsfKHptOlt1TAeSi1SmRoE7HNClETnmLBvzgP9Gje3dxRsu4D1a
         Y3vNJc6Cfda2GaUerfULj/0vSbyqrVoFXv5P6sfq9eIvLpOOgLo0f4Gqq01TSTwUWzSf
         /pZDB75WKJNrIQO+lln3kIMXdiKajQuu0oVha9GqbCsu5BWd7sivt2rcitrL/+mGJYtI
         GXfw==
X-Gm-Message-State: AOAM531gCS6+T1Pc4JgO9LUMVlrT3bHtPanZbmWSu5shd9JNESbh/vBy
        h7SkqkOlfzbkRLHqVBe0AqI=
X-Google-Smtp-Source: ABdhPJymE0InCyHTFO2miHWl9+IfFhQc6gc9jInoQiSnQj9jSF+3qp1HQRvIyrL8hUdiQLUh6jkO9A==
X-Received: by 2002:a17:903:2289:b029:12c:5642:c4df with SMTP id b9-20020a1709032289b029012c5642c4dfmr872792plh.23.1627494826812;
        Wed, 28 Jul 2021 10:53:46 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id m19sm647113pfa.135.2021.07.28.10.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 10:53:46 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC net-next 1/2] net: dsa: tag_mtk: skip address learning on transmit to standalone ports
Date:   Thu, 29 Jul 2021 01:53:25 +0800
Message-Id: <20210728175327.1150120-2-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210728175327.1150120-1-dqfext@gmail.com>
References: <20210728175327.1150120-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Consider the following bridge configuration, where bond0 is not
offloaded:

         +-- br0 --+
        / /   |     \
       / /    |      \
      /  |    |     bond0
     /   |    |     /   \
   swp0 swp1 swp2 swp3 swp4
     .        .       .
     .        .       .
     A        B       C

Address learning is enabled on offloaded ports (swp0~2) and the CPU
port, so when client A sends a packet to C, the following will happen:

1. The switch learns that client A can be reached at swp0.
2. The switch probably already knows that client C can be reached at the
   CPU port, so it forwards the packet to the CPU.
3. The bridge core knows client C can be reached at bond0, so it
   forwards the packet back to the switch.
4. The switch learns that client A can be reached at the CPU port.
5. The switch forwards the packet to either swp3 or swp4, according to
   the packet's tag.

That makes client A's MAC address flap between swp0 and the CPU port. If
client B sends a packet to A, it is possible that the packet is
forwarded to the CPU. With offload_fwd_mark = 1, the bridge core won't
forward it back to the switch, resulting in packet loss.

To avoid that, skip address learning on the CPU port when the destination
port is standalone, which can be done by setting the SA_DIS bit of the
MTK tag, if bridge_dev of the destination port is not set.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 net/dsa/tag_mtk.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index cc3ba864ad5b..8c361812e21b 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -15,8 +15,7 @@
 #define MTK_HDR_XMIT_TAGGED_TPID_8100	1
 #define MTK_HDR_XMIT_TAGGED_TPID_88A8	2
 #define MTK_HDR_RECV_SOURCE_PORT_MASK	GENMASK(2, 0)
-#define MTK_HDR_XMIT_DP_BIT_MASK	GENMASK(5, 0)
-#define MTK_HDR_XMIT_SA_DIS		BIT(6)
+#define MTK_HDR_XMIT_SA_DIS_SHIFT	6
 
 static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
@@ -50,7 +49,8 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 	 * whether that's a combined special tag with 802.1Q header.
 	 */
 	mtk_tag[0] = xmit_tpid;
-	mtk_tag[1] = (1 << dp->index) & MTK_HDR_XMIT_DP_BIT_MASK;
+	mtk_tag[1] = BIT(dp->index) |
+		     (!dp->bridge_dev << MTK_HDR_XMIT_SA_DIS_SHIFT);
 
 	/* Tag control information is kept for 802.1Q */
 	if (xmit_tpid == MTK_HDR_XMIT_UNTAGGED) {
-- 
2.25.1

