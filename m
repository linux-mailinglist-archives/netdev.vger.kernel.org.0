Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442B849C437
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237717AbiAZHXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiAZHXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:23:21 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0856DC06161C;
        Tue, 25 Jan 2022 23:23:20 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id h12so22458685pjq.3;
        Tue, 25 Jan 2022 23:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8z8QaPzSpYleEBkb/3BW1hePTgzB2h/wRA/Ef7uJuSQ=;
        b=MAFclsnfDcCr0FlzF9arMxcarozNUtuK2GFdTbelSb7Wkrit6g+KTuDNq9rdY9yCn/
         8++JLr87o3SKB3jPC/s/Gyj7e8RAy3SMFa+ukm78x5gsUs+SS5trFyNK5LwcIcWarjzD
         tboNUACtPRZMaKtJ6UdX1jVmkLi/Kae5MKoa6FZ0RYmsOwTo3W8h+lMyVnYXwMyH2y4a
         BZII28i7KghfPYhZMy2lenrGsNGYzZhKBa4g1QkWY4fVPF38nx7mq3uXuYTrYsx+gKhK
         IUxfNwf+xusB9uGIxEteT61p3ZCDBbVIOfU0MZ8yNGjbw1STde1z9932YW6+i3rTSTbz
         JWQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8z8QaPzSpYleEBkb/3BW1hePTgzB2h/wRA/Ef7uJuSQ=;
        b=ig9GD6yJ8GdfrfKVGcC9aWpASHDmG0LZQdUyPbS68zXZ9mJEmAf624YFxKIvPvUNEV
         MYl0xKGeLwrq7arZrKe2TJf2jG/BvvDszjSqQsDkUa5YExW/2rfjPI5/tcf+dNlXUkdN
         y8EnhhQI0Y1RP/0snxw8kGFYkwkKIk8kFKdD4Lxf9qR8nGfvQtnHa/OXu3sSPBvkGnkE
         wZUUFe0Q+ompv5cgscKbm5ByDZGnAfEJOvlS+VotfbxMdIfT2HQiT/ybeBr41TpfsVz8
         m3a7aT8JnWCM6g8c9wMV6C3qujQ1iWJS2TMthfQXmUFNNfhTeTa7c7szI92LIq9hEn+1
         T8Zg==
X-Gm-Message-State: AOAM531rEUpRBZrSxVwEJmO2JYqgJJLo2WdVJA9LtgUF26mhks8eQUKs
        ppE1SvS3UxgZFu6+Q6/OU11Ob7MszSk=
X-Google-Smtp-Source: ABdhPJxmdCDH1bkuwdkyi7FVRgTPEkNEGS4N9qOcrJAkIwBH3ql00NGu2M455/W+Rx/9K6Kdx2El4A==
X-Received: by 2002:a17:902:e552:b0:149:b7bf:9b42 with SMTP id n18-20020a170902e55200b00149b7bf9b42mr21223022plf.70.1643181800405;
        Tue, 25 Jan 2022 23:23:20 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id l21sm1061884pfu.120.2022.01.25.23.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 23:23:19 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dsahern@kernel.org,
        rostedt@goodmis.org, Menglong Dong <imagedong@tencent.com>
Subject: [PATCH v2 net-next] net: drop_monitor: support drop reason
Date:   Wed, 26 Jan 2022 15:23:06 +0800
Message-Id: <20220126072306.3218272-1-imagedong@tencent.com>
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

For now, the number of drop reason is passed to users ( seems it's
a little troublesome to pass the drop reason as string ). Therefore,
users can do some customized description of the reason.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- get a pointer to struct net_dm_skb_cb instead of local var for
  each field
---
 include/uapi/linux/net_dropmon.h |  1 +
 net/core/drop_monitor.c          | 16 ++++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 66048cc5d7b3..b2815166dbc2 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -93,6 +93,7 @@ enum net_dm_attr {
 	NET_DM_ATTR_SW_DROPS,			/* flag */
 	NET_DM_ATTR_HW_DROPS,			/* flag */
 	NET_DM_ATTR_FLOW_ACTION_COOKIE,		/* binary */
+	NET_DM_ATTR_REASON,			/* u32 */
 
 	__NET_DM_ATTR_MAX,
 	NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 7b288a121a41..b5d8e19ccc1d 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -126,6 +126,7 @@ struct net_dm_skb_cb {
 		struct devlink_trap_metadata *hw_metadata;
 		void *pc;
 	};
+	enum skb_drop_reason reason;
 };
 
 #define NET_DM_SKB_CB(__skb) ((struct net_dm_skb_cb *)&((__skb)->cb[0]))
@@ -498,6 +499,7 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 {
 	ktime_t tstamp = ktime_get_real();
 	struct per_cpu_dm_data *data;
+	struct net_dm_skb_cb *cb;
 	struct sk_buff *nskb;
 	unsigned long flags;
 
@@ -508,7 +510,9 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 	if (!nskb)
 		return;
 
-	NET_DM_SKB_CB(nskb)->pc = location;
+	cb = NET_DM_SKB_CB(nskb);
+	cb->reason = reason;
+	cb->pc = location;
 	/* Override the timestamp because we care about the time when the
 	 * packet was dropped.
 	 */
@@ -606,12 +610,17 @@ static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex,
 static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 				     size_t payload_len)
 {
-	u64 pc = (u64)(uintptr_t) NET_DM_SKB_CB(skb)->pc;
+	struct net_dm_skb_cb *cb = NET_DM_SKB_CB(skb);
 	char buf[NET_DM_MAX_SYMBOL_LEN];
+	enum skb_drop_reason reason;
 	struct nlattr *attr;
 	void *hdr;
+	u64 pc;
 	int rc;
 
+	pc = (u64)(uintptr_t)cb->pc;
+	reason = cb->reason;
+
 	hdr = genlmsg_put(msg, 0, 0, &net_drop_monitor_family, 0,
 			  NET_DM_CMD_PACKET_ALERT);
 	if (!hdr)
@@ -623,6 +632,9 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 	if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, pc, NET_DM_ATTR_PAD))
 		goto nla_put_failure;
 
+	if (nla_put_u32(msg, NET_DM_ATTR_REASON, reason))
+		goto nla_put_failure;
+
 	snprintf(buf, sizeof(buf), "%pS", NET_DM_SKB_CB(skb)->pc);
 	if (nla_put_string(msg, NET_DM_ATTR_SYMBOL, buf))
 		goto nla_put_failure;
-- 
2.34.1

