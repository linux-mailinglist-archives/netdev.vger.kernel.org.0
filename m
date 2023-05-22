Return-Path: <netdev+bounces-4422-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4739770CAA4
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 22:16:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19E8B1C20BA7
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:16:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5303C174C0;
	Mon, 22 May 2023 20:16:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA4C171D9
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 20:16:14 +0000 (UTC)
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E85103
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 13:16:08 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-64d24df4852so2675317b3a.2
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 13:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684786568; x=1687378568;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4dPtmg5X50IbEGol6g+YAgJkQef4b58RO59XWcUgorg=;
        b=hPjdkASzYIsx0p8hrlSuFKe8o7qdR7ipfagUqTtdrSVpEtUZLUZQUUtbNuj9t93pSA
         Lu2ABcElHtLHt8poTYEwFZ04J7OgNdFnP5qDTAvC4EwQ1B4yCTwKnKjubF1ErX/k0Rc1
         G7KKRm2iteSpaL43rdcZqWvM3OSq/a2AGGHYXa89qHYCuhOSHwwN2A64i03UKFIy97s7
         QlchHmEL3HZP/nAmzSY+ekbVOnZ0WC3ZQMxSo87G8kKJ1GNB4eekwsui/e4yweReP1yG
         i8PtdKQc2CWGePpdnam2U9PYu+xDh+e8c7RMZHPve2CSMhmZvfzsRjSZuYi/zTJ39ZGj
         j0vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684786568; x=1687378568;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4dPtmg5X50IbEGol6g+YAgJkQef4b58RO59XWcUgorg=;
        b=QV7Vbz8CNVridYhSYPVRlflo33NZqjJhlMVgBb18nXB6Ar5S7ykrHqG6jLEIF61YKV
         /XOw97/rQn0GBCRCzamnO9rRNu8to4YGP1R51A5GalFamNWhDWcbzyN0NxtkkMxkYUus
         xl+Ekxk+UfBseaq4tBiA9eGRA54uD+UD9n53P8sIPav9zS2/IEY3/ymt6K8jLwDJm5C9
         22pw0ZEAwHt/BJ0a8rEOWIQm7cky3RDC+VbpZ2YhQ9A2UOutKzFPk0D/NQop22TVd8EV
         iVjLEae5LStk3CLJVV1aNiW5klBBfvS0eshtHQW25sH3siQlZdqwe5zviB7s+pjtQLFI
         1cWQ==
X-Gm-Message-State: AC+VfDz5nlM7J7B35YOORs8WUF/Ldl9hht3gfLLzC6Oi4741soBu6nlX
	SuKO4TQqM6AjyOTU8YfZc3puTLGzWFgc2Wkkjohr8nQx9BH3vk4MzZE7/D9SrV8BxQthvEXH8Wr
	XOIiWqqQN9++ESanVKMhrDkloWmLJxPOO2QUFZWoqB60X5U+Y8/tHJMW4HcmWn2UUxYzZgg==
X-Google-Smtp-Source: ACHHUZ6EOT1T2ILKDMPYGIRnl0qcq2zYb2chmsiu8tDMQsELxKeQitliR8wah07/tutAgRaoFO/bVonUgd1+3XI=
X-Received: from ziweixiao.sea.corp.google.com ([2620:15c:100:202:91f7:1c4f:a4eb:30d2])
 (user=ziweixiao job=sendgmr) by 2002:a05:6a00:2d02:b0:643:ae47:9bc0 with SMTP
 id fa2-20020a056a002d0200b00643ae479bc0mr5192312pfb.3.1684786567922; Mon, 22
 May 2023 13:16:07 -0700 (PDT)
Date: Mon, 22 May 2023 13:15:52 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230522201552.3585421-1-ziweixiao@google.com>
Subject: [PATCH net-next] gve: Support IPv6 Big TCP on DQ
From: Ziwei Xiao <ziweixiao@google.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, kuba@kernel.org, Coco Li <lixiaoyan@google.com>, 
	Ziwei Xiao <ziweixiao@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Coco Li <lixiaoyan@google.com>

Add support for using IPv6 Big TCP on DQ which can handle large TSO/GRO
packets. See https://lwn.net/Articles/895398/. This can improve the
throughput and CPU usage.

Perf test result:
ip -d link show $DEV
gso_max_size 185000 gso_max_segs 65535 tso_max_size 262143 tso_max_segs 65535 gro_max_size 185000

For performance, tested with neper using 9k MTU on hardware that supports 200Gb/s line rate.

In single streams when line rate is not saturated, we expect throughput improvements.
When the networking is performing at line rate, we expect cpu usage improvements.

Tcp_stream (unidirectional stream test, T=thread, F=flow):
skb=180kb, T=1, F=1, no zerocopy: throughput average=64576.88 Mb/s, sender stime=8.3, receiver stime=10.68
skb=64kb,  T=1, F=1, no zerocopy: throughput average=64862.54 Mb/s, sender stime=9.96, receiver stime=12.67
skb=180kb, T=1, F=1, yes zerocopy:  throughput average=146604.97 Mb/s, sender stime=10.61, receiver stime=5.52
skb=64kb,  T=1, F=1, yes zerocopy:  throughput average=131357.78 Mb/s, sender stime=12.11, receiver stime=12.25

skb=180kb, T=20, F=100, no zerocopy:  throughput average=182411.37 Mb/s, sender stime=41.62, receiver stime=79.4
skb=64kb,  T=20, F=100, no zerocopy:  throughput average=182892.02 Mb/s, sender stime=57.39, receiver stime=72.69
skb=180kb, T=20, F=100, yes zerocopy: throughput average=182337.65 Mb/s, sender stime=27.94, receiver stime=39.7
skb=64kb,  T=20, F=100, yes zerocopy: throughput average=182144.20 Mb/s, sender stime=47.06, receiver stime=39.01

Signed-off-by: Ziwei Xiao <ziweixiao@google.com>
Signed-off-by: Coco Li <lixiaoyan@google.com>
---
 drivers/net/ethernet/google/gve/gve_main.c   | 5 +++++
 drivers/net/ethernet/google/gve/gve_tx_dqo.c | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index caa00c72aeeb..8fb70db63b8b 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -31,6 +31,7 @@
 
 // Minimum amount of time between queue kicks in msec (10 seconds)
 #define MIN_TX_TIMEOUT_GAP (1000 * 10)
+#define DQO_TX_MAX	0x3FFFF
 
 const char gve_version_str[] = GVE_VERSION;
 static const char gve_version_prefix[] = GVE_VERSION_PREFIX;
@@ -2047,6 +2048,10 @@ static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
 		goto err;
 	}
 
+	/* Big TCP is only supported on DQ*/
+	if (!gve_is_gqi(priv))
+		netif_set_tso_max_size(priv->dev, DQO_TX_MAX);
+
 	priv->num_registered_pages = 0;
 	priv->rx_copybreak = GVE_DEFAULT_RX_COPYBREAK;
 	/* gvnic has one Notification Block per MSI-x vector, except for the
diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index b76143bfd594..3c09e66ba1ab 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -8,6 +8,7 @@
 #include "gve_adminq.h"
 #include "gve_utils.h"
 #include "gve_dqo.h"
+#include <net/ip.h>
 #include <linux/tcp.h>
 #include <linux/slab.h>
 #include <linux/skbuff.h>
@@ -646,6 +647,9 @@ static int gve_try_tx_skb(struct gve_priv *priv, struct gve_tx_ring *tx,
 			goto drop;
 		}
 
+		if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
+			goto drop;
+
 		num_buffer_descs = gve_num_buffer_descs_needed(skb);
 	} else {
 		num_buffer_descs = gve_num_buffer_descs_needed(skb);
-- 
2.40.1.698.g37aff9b760-goog


