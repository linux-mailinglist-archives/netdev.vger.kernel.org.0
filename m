Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC26280C55
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 04:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387600AbgJBCmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 22:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387485AbgJBCmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 22:42:38 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2861FC0613D0;
        Thu,  1 Oct 2020 19:42:38 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id e18so518518pgd.4;
        Thu, 01 Oct 2020 19:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PVE6dj7KElSm5JHuEzI9VdWXB5S7Zzgg0Ylks3nzGTA=;
        b=QK0odRNw1YbgwIN2z/O6EwmnuAh8zTAPtPAq291jHHuQOIFUnorxxfBeq4hzQDCRE2
         42iJfjCOgnapQ5iZ+7UqEy8dSaK+1AHQACRJNvhO3NKp0xh9m52oHPb7qZ7RSzyhEujr
         WqKOzEeS2MPzVZX7LtPU1zs0GIqsXLOdQnKIApzfhiRHhybyGsxK5rxMH9RAQaVLUdRs
         3stajDvV9shpg358X0Jd80VfQYuouVZ7hGseKiOXaPdrL7vdsg2/yIk2j0eLq/Vh/p15
         I0Einu+IVvI7RYHxW6ZEO5Hi5lCCeQpfTXYrQ2P+LULnOw6J27nce2T1x9l5hTw2rahl
         Y1dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PVE6dj7KElSm5JHuEzI9VdWXB5S7Zzgg0Ylks3nzGTA=;
        b=EBa7w5EZTJmauZ2N6NngkQ6UujNv0Xlru4sxP2mbK4N1v0Hwb4QvC0njShnVKw6VRE
         hEswnAtLFfY6zHkNv6hrdz/J3C5WfTiWjrhVI+UT58PQf2hKhcALdInyZbW9YQH6obdP
         bTzt8jATDBLuT051VdBfJhh2ROKTGRhI5SQ9MusAnyU29ZB69n0oixvPizdX+lVNKb+1
         aARwc2rQrTeJFDWYgQ4tYystO0sKh+Ho3FHwSOmEZn42DLP+TT80+6JjkFo9smkGABLa
         DFm8Gv06N0pvOViQuw4Ep5snMrusMA1MPPlbf1v1L2hrdbyidybd85ro+YM2ygLWA4Tb
         oTIw==
X-Gm-Message-State: AOAM530FlKvnFVzb0WvGzYsmT07gMYy2sp9AZmV3oBx/c001K+WG327C
        ouuDaKAdLCibt6nqRWdtyRfShA7Rg782og==
X-Google-Smtp-Source: ABdhPJyqetfkTbQRqPyc/nUNuil1jXA6b5y3h2eNa3/SPC9H8ZKGRx0e/1xQRczANyJGdbbAbrA/nw==
X-Received: by 2002:a62:7a14:0:b029:13e:d13d:a0f5 with SMTP id v20-20020a627a140000b029013ed13da0f5mr175423pfc.17.1601606557193;
        Thu, 01 Oct 2020 19:42:37 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gt11sm150185pjb.48.2020.10.01.19.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 19:42:36 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        vladimir.oltean@nxp.com, olteanv@gmail.com
Subject: [PATCH net-next 2/4] net: dsa: b53: Set untag_bridge_pvid
Date:   Thu,  1 Oct 2020 19:42:13 -0700
Message-Id: <20201002024215.660240-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201002024215.660240-1-f.fainelli@gmail.com>
References: <20201002024215.660240-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Indicate to the DSA receive path that we need to untage the bridge PVID,
this allows us to remove the dsa_untag_bridge_pvid() calls from
net/dsa/tag_brcm.c.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c |  1 +
 net/dsa/tag_brcm.c               | 15 ++-------------
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 73507cff3bc4..ce18ba0b74eb 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2603,6 +2603,7 @@ struct b53_device *b53_switch_alloc(struct device *base,
 	dev->ops = ops;
 	ds->ops = &b53_switch_ops;
 	ds->configure_vlan_while_not_filtering = true;
+	ds->untag_bridge_pvid = true;
 	dev->vlan_enabled = ds->configure_vlan_while_not_filtering;
 	mutex_init(&dev->reg_mutex);
 	mutex_init(&dev->stats_mutex);
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 69d6b8c597a9..ad72dff8d524 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -152,11 +152,6 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 	/* Remove Broadcom tag and update checksum */
 	skb_pull_rcsum(skb, BRCM_TAG_LEN);
 
-	/* Set the MAC header to where it should point for
-	 * dsa_untag_bridge_pvid() to parse the correct VLAN header.
-	 */
-	skb_set_mac_header(skb, -ETH_HLEN);
-
 	skb->offload_fwd_mark = 1;
 
 	return skb;
@@ -187,7 +182,7 @@ static struct sk_buff *brcm_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 		nskb->data - ETH_HLEN - BRCM_TAG_LEN,
 		2 * ETH_ALEN);
 
-	return dsa_untag_bridge_pvid(nskb);
+	return nskb;
 }
 
 static const struct dsa_device_ops brcm_netdev_ops = {
@@ -214,14 +209,8 @@ static struct sk_buff *brcm_tag_rcv_prepend(struct sk_buff *skb,
 					    struct net_device *dev,
 					    struct packet_type *pt)
 {
-	struct sk_buff *nskb;
-
 	/* tag is prepended to the packet */
-	nskb = brcm_tag_rcv_ll(skb, dev, pt, ETH_HLEN);
-	if (!nskb)
-		return nskb;
-
-	return dsa_untag_bridge_pvid(nskb);
+	return brcm_tag_rcv_ll(skb, dev, pt, ETH_HLEN);
 }
 
 static const struct dsa_device_ops brcm_prepend_netdev_ops = {
-- 
2.25.1

