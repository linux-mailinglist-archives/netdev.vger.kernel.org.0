Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31301AF2D1
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 19:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgDRRZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 13:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgDRRZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 13:25:21 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EC6C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 10:25:21 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t16so2254921plo.7
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 10:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bH74zxtX/vcy0zyG68W3c+H7KPCmC8DmyViHStZiUyI=;
        b=mquaNX+cax7RUE+nYsAkCjJg0m0fEP4YdSWvffS/L5goMkclezk1Froc9KjABWxbVm
         LLWkBRveofV1yty+sk47EqkcJCmlkiBViXeFBZJB5SHVD2sQFOcxzNdaPXbo+7ohX31v
         LvZ49E15hQ24DL3l+44cthlKWXVm1r3IHahvZDBSmAX8I4k4d+DusTZagJFZiGJa/UO/
         cV/dnJEs2Wm8aZRsRbK9uCUMBPjSloVlzpCDftdna8cPGQSEW7O1Xc3LYbxHK7DK8pcb
         PWmsZVBhblPyuZa4rrY1FDKWfMCldQg4Y4Af+hTaJQ5NvBG/aIniQXkNr8bCJZ5q5D2l
         o0dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bH74zxtX/vcy0zyG68W3c+H7KPCmC8DmyViHStZiUyI=;
        b=aF0neqRvGlX7PCzTgeJNVzMUWtblHoE8eFkZ4v7KJVb+UqoSqOWDUZhqkeEc49lOK7
         Xxgj/EvBUliHQfO42iquaaUT2DKMdX6g1Mibs0ddzAuf6FXySnGFCls4BJTuRraH6uwD
         upzFzRtjasJI7/3wsn/hHoRZS+4OZUOSKxfGQj+S4CqdSuvG4nwKII7tGe9HZEwtiXw9
         qAD7L2K6kxu2DeTzpMHu2E56CIQC9f7ZEh4CNtUHr4TKCJsaOWThYcxQv/N4C+dfVxJ5
         5sikw0cb93BiRfc7YB0IJldhfzbd3SXwlOm7PSPChgUNhVrSqOafcaLU+gnTIhwNtN15
         6oQQ==
X-Gm-Message-State: AGi0Pub2bmrMs1eNhXNROB7d4H0CamojV02sX3sYCxQutKp8o2CKr/9Z
        1MT7/MO70vbTzhoI9P/WiQg=
X-Google-Smtp-Source: APiQypJimfkLFhVELRhCAqMfnd2DIwLKYjh3RBNKgBDeePTYAcuqkI3It8sOxIH/3aiMqryuWLr5jw==
X-Received: by 2002:a17:90a:fc89:: with SMTP id ci9mr4543928pjb.140.1587230720637;
        Sat, 18 Apr 2020 10:25:20 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([115.171.63.184])
        by smtp.gmail.com with ESMTPSA id s44sm9329251pjc.28.2020.04.18.10.25.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 Apr 2020 10:25:20 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, azhou@ovn.org, blp@ovn.org, u9012063@gmail.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2 4/5] net: openvswitch: make EINVAL return value more obvious
Date:   Thu, 16 Apr 2020 18:17:02 +0800
Message-Id: <1587032223-49460-5-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587032223-49460-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587032223-49460-1-git-send-email-xiangxia.m.yue@gmail.com>
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
index f552c64ae8df..77fe39cf4f18 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -390,9 +390,8 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
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

