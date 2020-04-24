Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3021F1B6A39
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 02:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgDXAI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 20:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728046AbgDXAI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 20:08:57 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B51EC09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 17:08:57 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id j7so3727576pgj.13
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 17:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IXe+9LopwWCD3B+slewPaY/Avt60n4lB3vL4raMN3g4=;
        b=BPkJ1Boc5TKfvePqYut2uhqmghqz/gX8v1SN8G+3TJM1JdPb2D++FIG55UxGUHdLgL
         aXcQuHAKAieTAPiqGBUvXCDQ/13TtTBU/m0ndtpotLmRHyo91VQlMOnKwv39QRuBfszM
         NhvrQERE1+ZxunfpyhG4tBO0DSytghleGpWGBF5I0mKY7R8kTpx/YCIj8WM040rx1lAm
         f8Dh19qETp6li/ybVsGZfPPad5xRn5cmmH6pWn1RBjIvy6Lh6GXdiH2+CS+r4NpPBU0L
         7zA1vTWrd3YEk4trZzLE5xgu6y9hXSW1Df24ZaJn/gPf+g2DCIshuoU+GNnorK7SmxMh
         1q8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IXe+9LopwWCD3B+slewPaY/Avt60n4lB3vL4raMN3g4=;
        b=Y1cQUEYbYbdQ4p+mkw7KC+H0npGJ/ENCr0CicELUl0jnSYJunYIaCy0MfS+vw6tRns
         LC9JlNJIzrBx4ywdI+O7Ti7OJCOccR67ERO7KjJjQiE6CUYnC7T5JQyZeYxzNRT5sTdN
         kzx7uHKPZ2ipJYkFW+woigoz2JUig/dIQjNxncHjAa3g6qAcYWE8+Hqh/gZbTYYf/f/1
         9v7xLLPg8UpAhK61vD1Zk+/hT0c3q0XdR0QB2bXsKvSyXdJIuBopXGq6wJJUzs5CUGlt
         /RC5DEskrdsqef+qf15F9KWJB/9nWI2ryJaRjxxONCfa9uKXqcm32smuEcDNOQTmbxkL
         J8FQ==
X-Gm-Message-State: AGi0PuaDZKk9etbPsOqp1rhoAQSpJyEWifdfvLGJPSpa4VOSyBBNzkl9
        lgPpq0BzWDn6oT3ObMdzndU=
X-Google-Smtp-Source: APiQypJpgnzafTiYiVmWREbokIBvL7HMZsDf9A1IzGOj2nT3QyHo5Gj/7ZQLdnu339Hmz+KI+cPN9g==
X-Received: by 2002:a63:f30a:: with SMTP id l10mr6471865pgh.372.1587686937161;
        Thu, 23 Apr 2020 17:08:57 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.142.146.4])
        by smtp.gmail.com with ESMTPSA id p10sm3836100pff.210.2020.04.23.17.08.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 17:08:56 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, azhou@ovn.org, blp@ovn.org, u9012063@gmail.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v4 3/5] net: openvswitch: remove the unnecessary check
Date:   Fri, 24 Apr 2020 08:08:04 +0800
Message-Id: <1587686886-16347-4-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587686886-16347-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587686886-16347-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Before invoking the ovs_meter_cmd_reply_stats, "meter"
was checked, so don't check it agin in that function.

Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: Andy Zhou <azhou@ovn.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
---
 net/openvswitch/meter.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 372f4565872d..b7893b0d6423 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -242,12 +242,11 @@ static int ovs_meter_cmd_reply_stats(struct sk_buff *reply, u32 meter_id,
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

