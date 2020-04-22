Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F2E1B4B59
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 19:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgDVRKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 13:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726006AbgDVRKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 13:10:36 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FB1C03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 10:10:35 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id c21so363462plz.4
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 10:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0btQwxM09Ht4KdbRO8aLLSWIGBffegGFqzoKttan0Yw=;
        b=pdCsS6B8jIQX4q5MQ1tVjufqLNt4yWdZp37YYAZp8af00vTrQaUEIVqONGv6AXv9dM
         mAlmN/xaJkGGfIyBKZ/dccpB70bXk/47GR7xIp1qA8MzDad4ofVmMrorxLnHWuNHjODM
         +Q0fzeVkZslZ4XrmPLy6siRYjkU6yUu1+AdYMwp6vhduQHTVWQqx6oJ5Gzheew1t60GV
         iczv5FcFtK2iPAuDo/8gfG02EgqSHzEA8FE6hHqc5XlN2YC2tF9iOGsmtDIFiQ0uA5Ro
         2deS2JWKuA2NEsXUY9/MKgrcoJDF2L5KEZVV+v7lyqAAB+1j+97BQXREmGTk2xQQojCf
         KrNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0btQwxM09Ht4KdbRO8aLLSWIGBffegGFqzoKttan0Yw=;
        b=eCpuIFR0hXwRNYhan7ES1mFgl7jFO4v+PcKR179+f7B1Lo4LgPBXG70l01ML98i8Ym
         sVw69Ht698J3TchbrKlikbxqvTIGJNnKSm5ZHLrS3GRkmiGc7muSyKvyLlCGJ2F0SpIk
         FMmM5e4m4X1jWCLNYz87n9MsFo5WINqryrPIEQzqhk5pYk0dJI5Su60R2yavQSk5zSt9
         HxZ4UpLj+/uWnm8ZqkX+K7ETE3XByWPqQlx64dWT4uD2tMVZF99W8zmqZ9xqCCmylIyj
         fRqsVtvdMyFS18exEYG9wXMY6EzD64kdXdtE85OjiloHCCr8qzw0ZbAwnfawossF6s4n
         264w==
X-Gm-Message-State: AGi0Pubm9/WyQWxhYhQgVhAiMZRT5EE6V7MfeKw94OxNc/4JfS032Lcq
        Pvv6InZq5kdi63Vzt6QrVAo=
X-Google-Smtp-Source: APiQypLxcIkocq3hWxSOTGaqrR6ZFCFGto6ZahpuCZzq6IsF1wf74FkU7k+ty+tIkJ1dA68vhs4WIg==
X-Received: by 2002:a17:90a:3441:: with SMTP id o59mr11831924pjb.185.1587575434812;
        Wed, 22 Apr 2020 10:10:34 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.142.146.4])
        by smtp.gmail.com with ESMTPSA id n16sm28549pfq.61.2020.04.22.10.10.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Apr 2020 10:10:34 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, azhou@ovn.org, blp@ovn.org, u9012063@gmail.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v3 5/5] net: openvswitch: use u64 for meter bucket
Date:   Thu, 23 Apr 2020 01:09:00 +0800
Message-Id: <1587575340-6790-6-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587575340-6790-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587575340-6790-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

When setting the meter rate to 4+Gbps, there is an
overflow, the meters don't work as expected.

Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: Andy Zhou <azhou@ovn.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/meter.c | 2 +-
 net/openvswitch/meter.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index e36b464b32a5..915f31123f23 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -392,7 +392,7 @@ static struct dp_meter *dp_meter_create(struct nlattr **a)
 		 *
 		 * Start with a full bucket.
 		 */
-		band->bucket = (band->burst_size + band->rate) * 1000;
+		band->bucket = (band->burst_size + band->rate) * 1000ULL;
 		band_max_delta_t = band->bucket / band->rate;
 		if (band_max_delta_t > meter->max_delta_t)
 			meter->max_delta_t = band_max_delta_t;
diff --git a/net/openvswitch/meter.h b/net/openvswitch/meter.h
index fcde5ee647da..9ca50bfd1142 100644
--- a/net/openvswitch/meter.h
+++ b/net/openvswitch/meter.h
@@ -26,7 +26,7 @@ struct dp_meter_band {
 	u32 type;
 	u32 rate;
 	u32 burst_size;
-	u32 bucket; /* 1/1000 packets, or in bits */
+	u64 bucket; /* 1/1000 packets, or in bits */
 	struct ovs_flow_stats stats;
 };
 
-- 
2.23.0

