Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99771AF2D0
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 19:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgDRRZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 13:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgDRRZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 13:25:18 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5BC5C061A0F
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 10:25:17 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u9so2736331pfm.10
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 10:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NZD7sPUFFjYPBotZrtF/iwSJE5qT8YuGHZzRiAQpdP8=;
        b=hWpkdr8c3bmtW1ndwuZwWQSQ7Vvu3M1r+4uh6sHjE/VOfxpUiRkYOI9aaQn3/YvAsI
         zv2ZvaZ6dGS50nwENc5Xb45zkeqNJdMdTBC90QDgdsDrckJh15W5qE9sk5CBW5k7N2xz
         C/up70nSeuTtkyIdNNNuDZztDqIlQx4cfOM4zBHPGZUtI6u/6Bzf5svvPtOd2RCm400r
         mRi6INDPmQQ9PosbquNLlVxLhG1oVg32W3K/a2E7re/WDf+yG7tR7uyoz8okujr5MePg
         fGxWmtVLZ8jiwfWqfy6NGf55htTrRwr2x7IfsESpKAbFX9SPPk8wQanjdAZF2+6fskTq
         yQJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NZD7sPUFFjYPBotZrtF/iwSJE5qT8YuGHZzRiAQpdP8=;
        b=gu+7oyfSIT0bhBpBOqEKHzkRbE5W/Re6L4J3iSPItsdy7sy4dXMJ4lb6WoHQ1quEo0
         7hBHiNETROE2TnEGHNpPbSqWFCPkfL+Si4evVT6t9zbIBDw0iq1ovfCrSW6/p7cLWXXE
         EQg4PJvg4fP8PtKJrYN99gOqcpbzvsyHyxofZdYe9IiuKonIhpEWdL72DweEQw0VWabw
         iDEdTzROqoAHWjZA3LVwnqh3yzv2KiASU/F4BXMpDSNJLoGbmFB80uxcwZof+F1ClNRT
         csQn/9GmkVWk3frhZOjg6ayE+bO2AhqAr2wLO+LqPiAENR+bWnB1ODKxLY9lXs5Xm5qs
         PF7g==
X-Gm-Message-State: AGi0PuYj5vjhz4TulqE2OxBnMA5Cd3hLiydt3KDcak4frN8UVUU1qKBX
        4eJ51dwqaf/0fZaRaQlkXFY=
X-Google-Smtp-Source: APiQypJQ682/okl/xNiQATMwZDCufz73QWapJ5x6dDxCrlj/OV1qeAc2tjP26nFwcapHYGljocz17A==
X-Received: by 2002:aa7:91c8:: with SMTP id z8mr8986183pfa.194.1587230717542;
        Sat, 18 Apr 2020 10:25:17 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([115.171.63.184])
        by smtp.gmail.com with ESMTPSA id s44sm9329251pjc.28.2020.04.18.10.25.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 Apr 2020 10:25:17 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, azhou@ovn.org, blp@ovn.org, u9012063@gmail.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2 3/5] net: openvswitch: remove the unnecessary check
Date:   Thu, 16 Apr 2020 18:17:01 +0800
Message-Id: <1587032223-49460-4-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587032223-49460-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587032223-49460-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Before calling the ovs_meter_cmd_reply_stats, "meter"
is checked, so don't check it agin in that function.

Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: Andy Zhou <azhou@ovn.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/meter.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 1b6776f9c109..f552c64ae8df 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -229,12 +229,11 @@ static int ovs_meter_cmd_reply_stats(struct sk_buff *reply, u32 meter_id,
 	if (nla_put_u32(reply, OVS_METER_ATTR_ID, meter_id))
 		goto error;
 
-	if (!meter)
-		return 0;
-
 	if (nla_put(reply, OVS_METER_ATTR_STATS,
-		    sizeof(struct ovs_flow_stats), &meter->stats) ||
-	    nla_put_u64_64bit(reply, OVS_METER_ATTR_USED, meter->used,
+		    sizeof(struct ovs_flow_stats), &meter->stats))
+		goto error;
+
+	if (nla_put_u64_64bit(reply, OVS_METER_ATTR_USED, meter->used,
 			      OVS_METER_ATTR_PAD))
 		goto error;
 
-- 
2.23.0

