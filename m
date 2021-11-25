Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D55A45D384
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 04:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345667AbhKYDRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 22:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346638AbhKYDPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 22:15:39 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39F9C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 18:54:51 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so5412648pjj.0
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 18:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q01QrqdCZKKNTFQ2v+xhiX3SXj5l3k9p8akmLebGw+Q=;
        b=il9BrOW6giMOO4J8SYEEGeJcoSv66JiTjRDvOs+EPCQwZCdny7KVQWOQdblMO3O6bJ
         CPBUghGqWNVHzufhVrDQFTEFJzo2mC0jmCgL+4EeO6Duo512ZBngvKPgP4vlAesc93uR
         9P7A/itTj6WmhS3MpjO7RQ+wmpgRXURJZqD/4PWZkG/9T4QHhi4f7NOoyzK4tWkLAKIH
         FJGQYT5+JdIfmIgd4C84/ZYJnsk1GFGgtWt34fjvMKyBgSgavK3D6mpxFiHJglnFGtO7
         0u+Kg34eBAcXsbD+SEVN3+CQRkeO5HPR8mlw8oysPwx+x/L4e6eCQjJKKTVE/5ghiz+B
         XNFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q01QrqdCZKKNTFQ2v+xhiX3SXj5l3k9p8akmLebGw+Q=;
        b=XUDec6iIHcrlrOa3IHw3oK2/XPVYFuV6keNoaty7Kqg0GELrWYhChn175Y8r/+fDfg
         sRKDNzBoaQPCFKNao3Y+IRm/nh4STq7PTigThI6jqa1qiGHA9ChHZib6oV5ujEKqX0BT
         v90o0BB7DodcAWgpsXmFQr1HxfGGVdvWlUPDjlD4eovgNMlF4AQrWA78RvkTCtUINdmI
         VBqfhR1Z+N89g9KBoy1tcK1XwNaIwdbgH2WpU4RwyxWR7bao4GWTUukAsmRjaWH1wTx4
         /yDhNuFDWlgR1v+l7vPXN5w56Do//ERrpbBSa7UPNULOhKGfnYOiLgmekAcbjciINqOr
         yXlg==
X-Gm-Message-State: AOAM530bhM6l7UM1HJVmjh5ebEcDxExIcZKKd8B4gk5UYmKXeFQjFUrW
        D74TjTlrWxGXfD/IYjCJ06MflMlMSoTWuQ==
X-Google-Smtp-Source: ABdhPJwYKfJFxNshvdAONtCFsbCW26XaBEWY9xTcBWFXA6Je/WGrijundU56DYG6V4dAVBqLMJJ+9Q==
X-Received: by 2002:a17:90b:1b06:: with SMTP id nu6mr2744832pjb.155.1637808891139;
        Wed, 24 Nov 2021 18:54:51 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id h15sm1136730pfc.134.2021.11.24.18.54.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Nov 2021 18:54:50 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [net-next v2] veth: use ethtool_sprintf instead of snprintf
Date:   Thu, 25 Nov 2021 10:54:44 +0800
Message-Id: <20211125025444.13115-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

use ethtools api ethtool_sprintf to instead of snprintf.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 drivers/net/veth.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 5ca0a899101d..38f6da24f460 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -134,29 +134,22 @@ static void veth_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *inf
 
 static void veth_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 {
-	char *p = (char *)buf;
+	u8 *p = buf;
 	int i, j;
 
 	switch(stringset) {
 	case ETH_SS_STATS:
 		memcpy(p, &ethtool_stats_keys, sizeof(ethtool_stats_keys));
 		p += sizeof(ethtool_stats_keys);
-		for (i = 0; i < dev->real_num_rx_queues; i++) {
-			for (j = 0; j < VETH_RQ_STATS_LEN; j++) {
-				snprintf(p, ETH_GSTRING_LEN,
-					 "rx_queue_%u_%.18s",
-					 i, veth_rq_stats_desc[j].desc);
-				p += ETH_GSTRING_LEN;
-			}
-		}
-		for (i = 0; i < dev->real_num_tx_queues; i++) {
-			for (j = 0; j < VETH_TQ_STATS_LEN; j++) {
-				snprintf(p, ETH_GSTRING_LEN,
-					 "tx_queue_%u_%.18s",
-					 i, veth_tq_stats_desc[j].desc);
-				p += ETH_GSTRING_LEN;
-			}
-		}
+		for (i = 0; i < dev->real_num_rx_queues; i++)
+			for (j = 0; j < VETH_RQ_STATS_LEN; j++)
+				ethtool_sprintf(&p, "rx_queue_%u_%.18s",
+						i, veth_rq_stats_desc[j].desc);
+
+		for (i = 0; i < dev->real_num_tx_queues; i++)
+			for (j = 0; j < VETH_TQ_STATS_LEN; j++)
+				ethtool_sprintf(&p, "tx_queue_%u_%.18s",
+						i, veth_tq_stats_desc[j].desc);
 		break;
 	}
 }
-- 
2.27.0

