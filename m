Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271534A9AAA
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 15:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356488AbiBDOIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 09:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbiBDOIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 09:08:21 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74095C061714;
        Fri,  4 Feb 2022 06:08:21 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id d186so5115110pgc.9;
        Fri, 04 Feb 2022 06:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QjntbCnTDOBz4uQ6Ki+gLkrxg0YoRN4uV3LZcpuWQoo=;
        b=H7IekxwEVxq+t5nWLxSo6enz+8ZETTlR+d5n3pu7FMq5KTNW8FxjXMVLaHCaFD1Q+J
         QrFBI1vn/2URsY/FiDfF2xcKkQXclS+6vz8W+LHYxJxZ7iXL42YHWKvaYpg0CNc+84Eu
         dCYebFGeKTnOZOG7rGmEWJ8Yb9aHf3HHOZweSE2dspedCXP8zxHOB5eloUx+TtdaOK6W
         0nXxlmSGmAeNpZ+edpw7GncJVsBd3pb6Nz85DHcI9aO1wYErI1c3JAvop18HMlkcoI/e
         g0g9DsbE/s0d6jmq2HGXfFrveUFKlMICYq5xO0omXE3/4uXZQwbcvdSCQdqqo6qWuMc4
         YMSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QjntbCnTDOBz4uQ6Ki+gLkrxg0YoRN4uV3LZcpuWQoo=;
        b=pHwu6Mltsv/HFT1S8u/6NQubdeZXwCyZM+OlPe3MkWVLdBAmtazp1yrqrly2CqVW+A
         NVw9ujONluOGB/Xg1a41GGX3UvOUHzd5rthGe/y3TimXatE7mf7hFWkAhDYCj4e7p6yM
         Zw1DnjQ7bd2qp7mCiMflKL+IUhJNu21kMWeP5MoCcqv22t1eRXd/Kl9Qnu5egpB8JbQh
         oFYtizKAmRSAYQlvawEZMXXMhSp0c0DVaZ6PW16FYPIwIHNGnUCtG2u8+tnJAxgiawgm
         wYosPtSjnv7K1EXbvhs6AUa+ng7cyWYt0fancpHOBqaQe0uwsYJmG4wyS4m/fBd+0vg6
         AyBg==
X-Gm-Message-State: AOAM532lUjqkIxMRmYa62Yy7ZF0zr+g6u1dDxTJdwlVKdIu+HhLvl8/V
        KbBxDjzunv+5jzXmWsucncjOS2PRBa2Mbw==
X-Google-Smtp-Source: ABdhPJwEXZik5KPcG7Rctjc91ymhw8t21YN6kFGcERW0JCRbEfao0aLOtzZNqQ4D//zmAUPkNSRFqA==
X-Received: by 2002:a05:6a00:1494:: with SMTP id v20mr3235617pfu.82.1643983700960;
        Fri, 04 Feb 2022 06:08:20 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id z22sm2896597pfe.42.2022.02.04.06.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 06:08:20 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org, dsahern@kernel.org, idosch@idosch.org
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        Menglong Dong <imagedong@tencent.com>
Subject: [PATCH v5 net-next] net: drop_monitor: support drop reason
Date:   Fri,  4 Feb 2022 22:08:13 +0800
Message-Id: <20220204140813.4007173-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()")
drop reason is introduced to the tracepoint of kfree_skb. Therefore,
drop_monitor is able to report the drop reason to users by netlink.

The drop reasons are reported as string to users, which is exactly
the same as what we do when reporting it to ftrace.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v5:
- check if drop reason larger than SKB_DROP_REASON_MAX

v4:
- report drop reasons as string

v3:
- referring to cb->reason and cb->pc directly in
  net_dm_packet_report_fill()

v2:
- get a pointer to struct net_dm_skb_cb instead of local var for
  each field
---
 include/uapi/linux/net_dropmon.h |  1 +
 net/core/drop_monitor.c          | 29 +++++++++++++++++++++++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 66048cc5d7b3..1bbea8f0681e 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -93,6 +93,7 @@ enum net_dm_attr {
 	NET_DM_ATTR_SW_DROPS,			/* flag */
 	NET_DM_ATTR_HW_DROPS,			/* flag */
 	NET_DM_ATTR_FLOW_ACTION_COOKIE,		/* binary */
+	NET_DM_ATTR_REASON,			/* string */
 
 	__NET_DM_ATTR_MAX,
 	NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 7b288a121a41..2d1c8e8dec83 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -48,6 +48,16 @@
 static int trace_state = TRACE_OFF;
 static bool monitor_hw;
 
+#undef EM
+#undef EMe
+
+#define EM(a, b)	[a] = #b,
+#define EMe(a, b)	[a] = #b
+
+static const char *drop_reasons[SKB_DROP_REASON_MAX + 1] = {
+	TRACE_SKB_DROP_REASON
+};
+
 /* net_dm_mutex
  *
  * An overall lock guarding every operation coming from userspace.
@@ -126,6 +136,7 @@ struct net_dm_skb_cb {
 		struct devlink_trap_metadata *hw_metadata;
 		void *pc;
 	};
+	enum skb_drop_reason reason;
 };
 
 #define NET_DM_SKB_CB(__skb) ((struct net_dm_skb_cb *)&((__skb)->cb[0]))
@@ -498,6 +509,7 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 {
 	ktime_t tstamp = ktime_get_real();
 	struct per_cpu_dm_data *data;
+	struct net_dm_skb_cb *cb;
 	struct sk_buff *nskb;
 	unsigned long flags;
 
@@ -508,7 +520,9 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 	if (!nskb)
 		return;
 
-	NET_DM_SKB_CB(nskb)->pc = location;
+	cb = NET_DM_SKB_CB(nskb);
+	cb->reason = reason;
+	cb->pc = location;
 	/* Override the timestamp because we care about the time when the
 	 * packet was dropped.
 	 */
@@ -606,8 +620,9 @@ static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex,
 static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 				     size_t payload_len)
 {
-	u64 pc = (u64)(uintptr_t) NET_DM_SKB_CB(skb)->pc;
+	struct net_dm_skb_cb *cb = NET_DM_SKB_CB(skb);
 	char buf[NET_DM_MAX_SYMBOL_LEN];
+	enum skb_drop_reason reason;
 	struct nlattr *attr;
 	void *hdr;
 	int rc;
@@ -620,10 +635,16 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 	if (nla_put_u16(msg, NET_DM_ATTR_ORIGIN, NET_DM_ORIGIN_SW))
 		goto nla_put_failure;
 
-	if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, pc, NET_DM_ATTR_PAD))
+	if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, (u64)(uintptr_t)cb->pc,
+			      NET_DM_ATTR_PAD))
+		goto nla_put_failure;
+
+	reason = cb->reason;
+	if (reason < SKB_DROP_REASON_MAX &&
+	    nla_put_string(msg, NET_DM_ATTR_REASON, drop_reasons[reason]))
 		goto nla_put_failure;
 
-	snprintf(buf, sizeof(buf), "%pS", NET_DM_SKB_CB(skb)->pc);
+	snprintf(buf, sizeof(buf), "%pS", cb->pc);
 	if (nla_put_string(msg, NET_DM_ATTR_SYMBOL, buf))
 		goto nla_put_failure;
 
-- 
2.34.1

