Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DFF1B4B57
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 19:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgDVRK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 13:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726006AbgDVRK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 13:10:27 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD8FC03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 10:10:27 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id hi11so1210978pjb.3
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 10:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eluv4zezmL1gel6eSKXMUm1lI9AKk8jn8T+U8AfBUPw=;
        b=hXAVwJCaoD64Mbjsf6Uh4Y5+jvPcN8GDbaJmCTQVNS15pTATVeN0AyfLx7iM/BtnKo
         e04pG7SOUCVQWhHwzkCcV6wG2+NJ8A1KMM94hsCKWohSDtdLuEf0ViWajob4YJEAsAni
         mMxCkTAZXIHXwiUbOQJU5iG1URu1I7aeq9kdvSy5+Oa92djHC5R7QuLfCzRWu8+FyyOF
         4KCQ6o1k/Ugy7mPzUav3N+ZG5WqbAYOpUhBAQPh9DeM22H7kqu+mpqTOUCFICLYpOio/
         4d9KGAxw+2n8bCWM3yY3f/b1xiESyRYub47Lh5IXfh5oGdpfb6iZsAqU+Svt9UoCGVjf
         nn+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eluv4zezmL1gel6eSKXMUm1lI9AKk8jn8T+U8AfBUPw=;
        b=mP+VC/2d7FuVjWFKeSfxQe8EU8EbVEFgljpDyYb4WETX22yRIJ3s75/oWDaUq6q3CD
         nkaDhlIj520j6oZBOlXn9404DYXkpJ847MJoR6Rj9QPsy/w+f0oa1Lf3WyALZstAdkX0
         VxJq7vvx0C5xK0s+aabySY+CdF5LiYKKAEFWshpYrQLS48rkQ7Y6wk+4RhKLjrzTOujz
         hz5P2x6B07ezi9PS6v6pOoFsL+/UAWkziV071BayPDSLDj9CuYV/vBG7IK0DEbHjsQoZ
         KDnYTfJ06WEUgDZC8mvUQkcqfF44S4H4fL1Bm2boMlB31vOlnciU8LU7g1gGg1unuFXQ
         wnYA==
X-Gm-Message-State: AGi0PuaGA2/KAjB8CQcCwsGN4w+JhiOQ57gT5idtt0Bi03jOFStpKKNS
        xC0KlaXnSsDZ2ScGAcJGaWQ=
X-Google-Smtp-Source: APiQypLXqI32CtLQRwaNMLeqUnnxJpMXi/Apqq3vQkNlpVRtWxz+9ATg9TyyiyLAPdIcnZt4N9x14w==
X-Received: by 2002:a17:902:b592:: with SMTP id a18mr28370566pls.147.1587575426717;
        Wed, 22 Apr 2020 10:10:26 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.142.146.4])
        by smtp.gmail.com with ESMTPSA id n16sm28549pfq.61.2020.04.22.10.10.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Apr 2020 10:10:26 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, azhou@ovn.org, blp@ovn.org, u9012063@gmail.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v3 3/5] net: openvswitch: remove the unnecessary check
Date:   Thu, 23 Apr 2020 01:08:58 +0800
Message-Id: <1587575340-6790-4-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587575340-6790-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587575340-6790-1-git-send-email-xiangxia.m.yue@gmail.com>
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

