Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF84F33DC53
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 19:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239947AbhCPSOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 14:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236066AbhCPSN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 14:13:26 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D20C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 11:13:26 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id lr13so73801775ejb.8
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 11:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p1ixn6gSCSw6mN/hi7S+8kDToFvH/MimcFCtZRBoQTA=;
        b=BiXeL0VOChA8iMcJIPJnpmXzYpOZFxZASprLm7aB8sKnPh+vN3xyAd0k6aMTlrJqW6
         Jk757Kpk9rpMA2uzKF3IwxneoJ7RcRqDJzEwk6D0nHGSn3WZDZzCJfhfXJpJMH6auNM0
         NUdPHnda18TM61w6m8TKqPevJIjtJjp87dXZeSwb0fJWbCACiZC5oYcMIl+p/QReQ6BI
         bEV+Lwodb50VNQDQ/D4mBZpgOVufmqVFZKv4RE3tQQWTRyjrGuZzObIBucobtZcjUwKm
         EEA1V33DeOBFt4BkplzHpgC19kmGS+aj0qliRUYTQVk6b1sCPyhFPVBp98g0JsYCI3G6
         AMhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p1ixn6gSCSw6mN/hi7S+8kDToFvH/MimcFCtZRBoQTA=;
        b=mTI1/RzI9H6RVpz4iltvlD4PlzSwG3k4okQKKfGSufBXx+vl0riLFjyWkpKBEc0nM9
         jaghhvZc+XegMLRk29+OdxqnmitSMJAZ4X/5YhmfcGtb69t0GcTdRdVt5RTzEFeIxevA
         WOhfKebvXVxFu6p1c3bbExxLjDQrDwVYJWjk849fe5RQbi1xVs6BGg91xVpUKhEf2wyC
         lfT/1jLGTd020QggMMRcEB0o/sFbiMJCQAf0vHPdECYE9hZMMRqyxwDKlLz8UkCP3+vk
         PvnSwuWzU4OmyPiisY6Mb+9IJDCrUWwv4HkVSSOAexb755j45pVIDS+xvlpjhS+nhDpx
         KKCw==
X-Gm-Message-State: AOAM532QD+3T8yVZaMqCqtoY5GdJw+eq5ysg9gvNz2rJZI2jQ+xCvTzG
        r8y2n5Q8Kx0iIU9QyqPhQBsmEw==
X-Google-Smtp-Source: ABdhPJyp2oxVymyiL58SwlQA/L8DUIFmBN+28qZSq+b9MDlmTnYa7H99JXhXuMntR8EJy31xR266oQ==
X-Received: by 2002:a17:906:f6ce:: with SMTP id jo14mr31539950ejb.476.1615918404886;
        Tue, 16 Mar 2021 11:13:24 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id e26sm11537778edj.29.2021.03.16.11.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 11:13:24 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net 2/3] nfp: flower: add ipv6 bit to pre_tunnel control message
Date:   Tue, 16 Mar 2021 19:13:09 +0100
Message-Id: <20210316181310.12199-3-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210316181310.12199-1-simon.horman@netronome.com>
References: <20210316181310.12199-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Differentiate between ipv4 and ipv6 flows when configuring the pre_tunnel
table to prevent them trampling each other in the table.

Fixes: 783461604f7e ("nfp: flower: update flow merge code to support IPv6 tunnels")
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 .../ethernet/netronome/nfp/flower/tunnel_conf.c   | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 7248d248f604..d19c02e99114 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -16,8 +16,9 @@
 #define NFP_FL_MAX_ROUTES               32
 
 #define NFP_TUN_PRE_TUN_RULE_LIMIT	32
-#define NFP_TUN_PRE_TUN_RULE_DEL	0x1
-#define NFP_TUN_PRE_TUN_IDX_BIT		0x8
+#define NFP_TUN_PRE_TUN_RULE_DEL	BIT(0)
+#define NFP_TUN_PRE_TUN_IDX_BIT		BIT(3)
+#define NFP_TUN_PRE_TUN_IPV6_BIT	BIT(7)
 
 /**
  * struct nfp_tun_pre_run_rule - rule matched before decap
@@ -1268,6 +1269,7 @@ int nfp_flower_xmit_pre_tun_flow(struct nfp_app *app,
 {
 	struct nfp_flower_priv *app_priv = app->priv;
 	struct nfp_tun_offloaded_mac *mac_entry;
+	struct nfp_flower_meta_tci *key_meta;
 	struct nfp_tun_pre_tun_rule payload;
 	struct net_device *internal_dev;
 	int err;
@@ -1290,6 +1292,15 @@ int nfp_flower_xmit_pre_tun_flow(struct nfp_app *app,
 	if (!mac_entry)
 		return -ENOENT;
 
+	/* Set/clear IPV6 bit. cpu_to_be16() swap will lead to MSB being
+	 * set/clear for port_idx.
+	 */
+	key_meta = (struct nfp_flower_meta_tci *)flow->unmasked_data;
+	if (key_meta->nfp_flow_key_layer & NFP_FLOWER_LAYER_IPV6)
+		mac_entry->index |= NFP_TUN_PRE_TUN_IPV6_BIT;
+	else
+		mac_entry->index &= ~NFP_TUN_PRE_TUN_IPV6_BIT;
+
 	payload.port_idx = cpu_to_be16(mac_entry->index);
 
 	/* Copy mac id and vlan to flow - dev may not exist at delete time. */
-- 
2.20.1

