Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF621B6A3A
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 02:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbgDXAJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 20:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728046AbgDXAJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 20:09:01 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D25C09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 17:09:00 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id p25so3878004pfn.11
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 17:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Cmy1vOw0+c/YYshZ1hVi1eYwZLLSggt6maHk9MyIK+4=;
        b=JfP6q/PC+qj0NGHzuMR61bAqCriaFb5Dg2lm0BLvywLvGUvLPX7rHVx26PpKzvutg4
         KFFFgW4SRf4ka4SQV0m/NL+7xhNOY2cYZV86iaF1LoDa1n1e41prkD8nRwhmSTYVjqCg
         l4zmPVKTLzgLlAPy9xhW5cYRPEtnCoxm7bjtoiu8fo7mzhU4hSNRd1hv0AgvpaEfHr8z
         F322xTKrRjrzY6fdJdoLs06xjuiKSzyzdFm0/5rs5PamgNNfuzJH8J3GIUB0ICneXi1H
         cEhgrfd42VguSv+q7uDzPeTAfRY8AZ6SjyVolf0SMuOWTxZbC8DXpvi6sGwyZO3zyCj9
         kvfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Cmy1vOw0+c/YYshZ1hVi1eYwZLLSggt6maHk9MyIK+4=;
        b=OQKyBRoxhNRLNr8v1+6Jd7tTqyDvhVqHXfOg0Xas2040/6Gb7/PZa2EsymJscJK5kv
         WATw+gqJ776jdlTkSEVbVqTVqcO51YwTeZmRBA84tPzTZImbBKhkvxPBXknRvmkU/Pou
         3KY3d2SifL9hiRFAYf7sdusiviKvfVZ6bG/dkah7k3OOxA0a+z/HNoKnlqXzddC3nCBH
         xvjPksQaK/ChiDTryTvbWlujAYjE23i70RdNxRwX6M9afiJ15mXHtQkTmyewdLc/m299
         4ubROS5Jk5IvxfUwK1mXeanyruRrC4o7be22tty2pOluFW7IF403SoIXPgSNH9Fec9MU
         NCmg==
X-Gm-Message-State: AGi0Pub1OGa1B2lCM5b8uEbQuw7j2YgRXY8g42rWiOFt5ooIdnrXdl7H
        AfUsqLmLVMH7ctVjEzFjuxVQLAtHdvE=
X-Google-Smtp-Source: APiQypKXdZCK6jujTn3MWS23DnKZV5Ta+Gs3iNHotdfAofw+IL73J9DVYgmMW1PZoS2Nq1L4eIdQzQ==
X-Received: by 2002:a63:b256:: with SMTP id t22mr6071757pgo.92.1587686940093;
        Thu, 23 Apr 2020 17:09:00 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.142.146.4])
        by smtp.gmail.com with ESMTPSA id p10sm3836100pff.210.2020.04.23.17.08.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 17:08:59 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, azhou@ovn.org, blp@ovn.org, u9012063@gmail.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v4 4/5] net: openvswitch: make EINVAL return value more obvious
Date:   Fri, 24 Apr 2020 08:08:05 +0800
Message-Id: <1587686886-16347-5-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587686886-16347-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587686886-16347-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: Andy Zhou <azhou@ovn.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
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

