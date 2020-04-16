Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8C31AF2D2
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 19:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgDRRZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 13:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgDRRZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 13:25:25 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D27BC061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 10:25:24 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a32so2600548pje.5
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 10:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WNcZccmCQBPkTnugJ9tCHONY29qm/KtuqMXhsDw6FZo=;
        b=ciDrcUtbtR3lIv31N2AKe13hftAZKYBOjPo/FevQIgefXXJjVhdH/I1NmpKDr4FUIq
         CER+vjyVTi1jZOIuTAR1jgftXHvSFXKNry28tbbH46bqKkGaAPUKqDOE9OFzEX//nS4l
         pR3s4827PieMEgCqeBj/9g8Iz0lr6ANvpZzCkP/HwZTVlQQOq2SL/1Zd+lALoE0LXg7y
         7Z7IfeekJuLwhUzh/JzlXphV4206KUlU6qUVZ0PL7wBOmOtLph2TtbTp8DYUnROy8RGE
         DqWSTFyjjMsviLJGUdtuEEuLzIfu0x9lvUh9m6HYicWleNeJXH5wUPZPEtYdxsjMICjP
         Wx8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WNcZccmCQBPkTnugJ9tCHONY29qm/KtuqMXhsDw6FZo=;
        b=Tv9o4/LayIa0vOlwmKLWKExme8ezIyn7JupGQxViyoQvcNh0bjAj5PZ+q/txqkQi77
         maxhyqZF5WAyN0OcYYZy4Vds9ERaZn4xMUBwTLB6l34ZpgxrDvPUeXo1jea7zMZ4WTq2
         gN4pWZIkPTI737zDrb9tSv6nyXy62SPyIr5WmGm76DOydgbRqNhEfLaqLTgX92wUT9Jn
         d6OnCoS5KbFmY2t9hrKpKnhoHSDtyR4/qhbUHZ1Vg0Dko4/exwA2+tKbyZxfuHzxy/Mq
         laHqTWGzgjzQhoXRVxs52Oiq0uoIoimMBaiUtRZP2WoMVNvALh2zPypQZk8YU/OjuN44
         +OPg==
X-Gm-Message-State: AGi0PuZrrKRJbcB3L6mfaLiZlP2CBDxTVdmPXHFB1HEkhWewmw/RgZBn
        RUaGbxZwG27DPGwINjLF6CQ=
X-Google-Smtp-Source: APiQypIhTVD9yTw22L4NrAR3lKHrIBMOtPzkxc+dy1A3+3xUnHClO+8wtMf4opXynpRevT/R1Fg8+A==
X-Received: by 2002:a17:90a:2ac7:: with SMTP id i7mr11513109pjg.130.1587230724248;
        Sat, 18 Apr 2020 10:25:24 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([115.171.63.184])
        by smtp.gmail.com with ESMTPSA id s44sm9329251pjc.28.2020.04.18.10.25.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 Apr 2020 10:25:23 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, azhou@ovn.org, blp@ovn.org, u9012063@gmail.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2 5/5] net: openvswitch: use u64 for meter bucket
Date:   Thu, 16 Apr 2020 18:17:03 +0800
Message-Id: <1587032223-49460-6-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587032223-49460-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587032223-49460-1-git-send-email-xiangxia.m.yue@gmail.com>
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
index 77fe39cf4f18..51cfe8a52b5a 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -364,7 +364,7 @@ static struct dp_meter *dp_meter_create(struct nlattr **a)
 		 *
 		 * Start with a full bucket.
 		 */
-		band->bucket = (band->burst_size + band->rate) * 1000;
+		band->bucket = (band->burst_size + band->rate) * 1000ULL;
 		band_max_delta_t = band->bucket / band->rate;
 		if (band_max_delta_t > meter->max_delta_t)
 			meter->max_delta_t = band_max_delta_t;
diff --git a/net/openvswitch/meter.h b/net/openvswitch/meter.h
index cdfc6b9dbd42..b1a50d988e59 100644
--- a/net/openvswitch/meter.h
+++ b/net/openvswitch/meter.h
@@ -25,7 +25,7 @@ struct dp_meter_band {
 	u32 type;
 	u32 rate;
 	u32 burst_size;
-	u32 bucket; /* 1/1000 packets, or in bits */
+	u64 bucket; /* 1/1000 packets, or in bits */
 	struct ovs_flow_stats stats;
 };
 
-- 
2.23.0

