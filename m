Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B351B6A3B
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 02:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgDXAJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 20:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728046AbgDXAJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 20:09:03 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892FEC09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 17:09:03 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x15so3903961pfa.1
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 17:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=if37bc8Wf0UXgYVdHWU4Qs3EVJtjkz/5gKswODLVgIE=;
        b=QV3Bh3JXYsZZjx0J7Zbn/QB5Jn31R/UBu+4fPDAIwZaQobtF0XglcdJymcR1Y95X5P
         RpJOBH7rJ425YI/IyBiBlv5cBMJtHeOFUPKwqz03iaQyn1p8mFXcbUynW33LCi/lcK13
         Mx21VJji4VmFxfDL4uXg7McakzPiD2vzX1aYDVWhDTpEkr8uNl4VDg20G0GRJL3+b2sz
         LJRuHRfqqgzvqEAdqsve6lURULFz/U3Teas2jO7uJwxrQUG79PRvt54OvVbOqHIEsleO
         2ELXOet1uWOKcQjf02bwbohGMFp4YXI76A5ryFOWYfqRjgRCwEtuH6q+jPk40+P5LiTn
         wURg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=if37bc8Wf0UXgYVdHWU4Qs3EVJtjkz/5gKswODLVgIE=;
        b=JPZgTcyxGhQ0f/fp7tapRfgOr/qxGxqSk6TgSuXmdgvCj1Cv1yj+Bsu+0VzJU3nHfa
         HbRbIZzKUM1/Ic1XR5yAHCV2XLdfqOPzVz0V8xT+KB7gqGh+V83gfssj1t7aupAHTZpr
         8tEoOeCrVROfPNWtlpAhTJpVdHDs2YRRWf7wfFoL8blWjcIsHXO5A1N1h/z+sJ4EO7km
         6sZ+o1PiE3WITpH1FRi3fR35a3WyFP7rAU9+nfyxk+UtLXcuw2oY4wJRCHr4DbsFPfbK
         xUmyH8oFbmI+LOjA2FS+l1XhVPRILVFsAy0LmY1XPHzvHVJmZVEXIixs+QC1ChZNsyaX
         jRTw==
X-Gm-Message-State: AGi0PuYakIFgbI9TnBwn0opnOE5PC4s2ldXdetPgsTOYVI8E5WUcWyrT
        ppSBSZlGUwHJ55OHSR7juZs=
X-Google-Smtp-Source: APiQypKkJRyVJvgv9jxJWEDO9i/4UmF15aN8VCtNX/7iitowJ6EwLtkzAGZZw0MxFE+2utwsYo8Lyg==
X-Received: by 2002:a62:5ac2:: with SMTP id o185mr6494613pfb.148.1587686943120;
        Thu, 23 Apr 2020 17:09:03 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.142.146.4])
        by smtp.gmail.com with ESMTPSA id p10sm3836100pff.210.2020.04.23.17.09.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 17:09:02 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, azhou@ovn.org, blp@ovn.org, u9012063@gmail.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v4 5/5] net: openvswitch: use u64 for meter bucket
Date:   Fri, 24 Apr 2020 08:08:06 +0800
Message-Id: <1587686886-16347-6-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587686886-16347-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587686886-16347-1-git-send-email-xiangxia.m.yue@gmail.com>
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
Acked-by: Pravin B Shelar <pshelar@ovn.org>
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
index 61a3ca43cd77..0c33889a8515 100644
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

