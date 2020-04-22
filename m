Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7631B4B58
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 19:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgDVRKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 13:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726006AbgDVRKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 13:10:33 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647D7C03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 10:10:32 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t40so1264938pjb.3
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 10:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mH66Ea15LXw26LpJ/hQiww3C+2O8hSYIJQXfPxYx/Gk=;
        b=Q6tWPCAUxN4nNd/duSzLnzzsdHoGQKDwdKzkBiPJYOy8/JFN7BCGRqtOQ1qTCNN09c
         fOcEgZHNn0NW6Ahon6oTTPkwMV6a4ppLiiDGwM3f02D9s1Xq5VeLJoGJECuvIA48GeoC
         syCSGD8Cbxgq3NRdWLSARccn4t7Bgrw5M2Cqh6pLDwntbCyxXdhFtf9TE32o+SpSq0ic
         /el+j9xnLlolJh7NW8H1G5olDDIjH2fi3y3YPYBYUCXYBlkwx8h8iqAk51bDSC1l6Hdu
         KekgeefqtXbKwxiH8pSn01FQohKa9DVRh7wn9ij0LX+rvBQVmMS1kIIhneYQIBAr7vx/
         pzNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mH66Ea15LXw26LpJ/hQiww3C+2O8hSYIJQXfPxYx/Gk=;
        b=iIZgJDUJRMyL152jIsIlbMbDeT1CSqc2nmCoRXd9lQWqfCIwJRvDBXbHt0j1Hw1vbI
         sbqw+JrlVUSnTESmR49Q4TDS3UPpZ79WvJkHkKUAXS5ZsDYFidP525J+KjjXsnYqPVBj
         1I0VER2nhAh2oeWJeyMqs5Q22cianCe6qR5Uuo4iN1cqHdlHjyb5NmY+T0KeF0SUnJxB
         dycGWSU1OjOEqXINsBusY8IQz7wDqwF00Vnm1POZFg/OrEcbRQVtYGUSzJ8M/vfx88YM
         5MidBbHCele3AuWlmobYySRNUQkR71kG3IM9mn+Xxr5BTcFEmrTTuwVboI3Jepc0tMd3
         0+Pg==
X-Gm-Message-State: AGi0PuaUIK5V9T1RJYAR4PCKm/VMOCxnv7ugRSCD1YZHOV97hGh2be14
        AfhbCZz73yuOP+YwyQbuhQmUJKCqROs=
X-Google-Smtp-Source: APiQypLciaslyIjNLIZ2YASAAdrjZqkdsW81VcnzbPFswl/3SN5o5qe2hmLIB8+77yPYYko0GED2Qg==
X-Received: by 2002:a17:902:ed03:: with SMTP id b3mr26090330pld.247.1587575432014;
        Wed, 22 Apr 2020 10:10:32 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.142.146.4])
        by smtp.gmail.com with ESMTPSA id n16sm28549pfq.61.2020.04.22.10.10.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Apr 2020 10:10:31 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, azhou@ovn.org, blp@ovn.org, u9012063@gmail.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v3 4/5] net: openvswitch: make EINVAL return value more obvious
Date:   Thu, 23 Apr 2020 01:08:59 +0800
Message-Id: <1587575340-6790-5-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587575340-6790-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587575340-6790-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: Andy Zhou <azhou@ovn.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/meter.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index b7893b0d6423..e36b464b32a5 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -419,9 +419,8 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
 	u32 meter_id;
 	bool failed;
 
-	if (!a[OVS_METER_ATTR_ID]) {
-		return -ENODEV;
-	}
+	if (!a[OVS_METER_ATTR_ID])
+		return -EINVAL;
 
 	meter = dp_meter_create(a);
 	if (IS_ERR_OR_NULL(meter))
-- 
2.23.0

