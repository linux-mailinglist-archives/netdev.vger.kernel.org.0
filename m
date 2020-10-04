Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37096282E64
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 01:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgJDXpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 19:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgJDXpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 19:45:12 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83860C0613CE;
        Sun,  4 Oct 2020 16:45:12 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id 133so2781595ljj.0;
        Sun, 04 Oct 2020 16:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EY4O7+MSjjAGjTzPedj1WJouB44syL6Z3H18b31/iyk=;
        b=pQz+Xj+9OC2dExt2dwD2u/UW/vcrwYnG45xHy+uXIg7WzkfbrlmMKgF+trQ/qF4HrE
         dcsyjfzKW5bez1PY5cTkLdFn4rKhkaohqlTM0uxQZ8l2oDjNdQAVjLSyUNshLFItklBh
         aNAnwfeBXOkVaWUdP6oB7K46pl6fB3GJcrlX0H6kM+pjqf+1e2qkqDiu7+Mvsg2mSpty
         LsZW7gq7PIHdANtWbdaKy4MHftxeL+jrAJ3J9t9UNsu3D32Lw9s64sRL86l+lI0rDpBr
         5H2VEANY6hU92oJTUOrm+TfUpUhMlx63+SMBJx8YvQKXoXRYghsBgOjPjSqQ3IRxpmXX
         0+uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EY4O7+MSjjAGjTzPedj1WJouB44syL6Z3H18b31/iyk=;
        b=DGOc4RWK4u41DUxHTXFSQC1HKMwTRY3lTczQD7dMqVCZTDrlstciNgmxvHlvuHd84I
         JaECbOgRWWJ4YT7VzbaX3ewnkPddSS5hI95Mt+tiXmE434fNU28YnWwxpThY7iuA/rrB
         NJnsMvbbnggm/r9ti5Jq9DB51dWE64dsRA+EThr7hf3VyfQghKxcZhTNQDkhecBkU17B
         ACHeBOcOiT2FY5uHTtleWX66DoQQ84b9WUBu6h5NEIkjrOfd3QPIgLTYK7rWX0j0WxGo
         /PTmmST5QBvP7MtUICgF4YbjrgBtsSGMSSXJDoQx73NSb373JUC8yoPkwvpBuV8GKpYL
         ifFg==
X-Gm-Message-State: AOAM53260GlTt5ONg3k+OtfswPcOtr3MnBT7m5GYbUlzoDvkzIIOzJvw
        tisqRDmvax8z6R35tzV12tY=
X-Google-Smtp-Source: ABdhPJwy/NAElwdDj7MR5Tv158+pXcqfOstzhc1JQvjcl23a4e7TVWTQfFKpdEBrYtuCsHUamkezJQ==
X-Received: by 2002:a2e:80d2:: with SMTP id r18mr3641410ljg.98.1601855111040;
        Sun, 04 Oct 2020 16:45:11 -0700 (PDT)
Received: from localhost.localdomain (h-155-4-221-232.NA.cust.bahnhof.se. [155.4.221.232])
        by smtp.gmail.com with ESMTPSA id y3sm159866ljc.131.2020.10.04.16.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 16:45:10 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Pravin B Shelar <pshelar@ovn.org>, dev@openvswitch.org
Subject: [PATCH net-next v2 2/2] net: openvswitch: Constify static struct genl_small_ops
Date:   Mon,  5 Oct 2020 01:44:17 +0200
Message-Id: <20201004234417.12768-3-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201004234417.12768-1-rikard.falkeborn@gmail.com>
References: <20201004234417.12768-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only usage of these is to assign their address to the small_ops field
in the genl_family struct, which is a const pointer, and applying
ARRAY_SIZE() on them. Make them const to allow the compiler to put them
in read-only memory.

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 net/openvswitch/conntrack.c | 2 +-
 net/openvswitch/meter.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 18af10b7ef0e..e6fe26a9c892 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -2231,7 +2231,7 @@ static int ovs_ct_limit_cmd_get(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
-static struct genl_small_ops ct_limit_genl_ops[] = {
+static const struct genl_small_ops ct_limit_genl_ops[] = {
 	{ .cmd = OVS_CT_LIMIT_CMD_SET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM, /* Requires CAP_NET_ADMIN
diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 50541e874726..8fbefd52af7f 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -672,7 +672,7 @@ bool ovs_meter_execute(struct datapath *dp, struct sk_buff *skb,
 	return false;
 }
 
-static struct genl_small_ops dp_meter_genl_ops[] = {
+static const struct genl_small_ops dp_meter_genl_ops[] = {
 	{ .cmd = OVS_METER_CMD_FEATURES,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = 0,		  /* OK for unprivileged users. */
-- 
2.28.0

