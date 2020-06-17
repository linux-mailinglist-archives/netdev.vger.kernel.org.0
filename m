Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F5B1FD30B
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgFQRA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgFQRA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 13:00:56 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96841C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 10:00:55 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d66so1427849pfd.6
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 10:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wezbZWMHriNk3aTYO1a5n+7Gq2DNmvyETEfubmof5so=;
        b=BAs+o0u2Ce8R7sOhDJqdYW5p1fzm1rhu3HVGJyOr6TjhM/o+T8Wz+vDd/8v9D/e6MS
         BkkE+pgZQz/0qcU3SWQbOdyQZ1lcBmmEMOwFEy5ywRnavJ038W4gXrwUrwVFtqhWJd3h
         GAyJFO5ND9uvkx1IPOVaH+gQFO1vkUMhp0etVZeIa9vK6KoTdbUoNJOzlT7A2bKkWObq
         p+cyKjtHQY8HdAIp84JIq5punKTi+SeYEG7g1YdIvu4/qBWddxjb9ffghDTqHA4HRSzK
         Tjfy8rhkGHJ6ynfR+BNRsBc5G8Eij6J9JDKYS9ZqPCof3Hi9qozRSwNPCY2h2dYR0nYc
         XK/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wezbZWMHriNk3aTYO1a5n+7Gq2DNmvyETEfubmof5so=;
        b=gXVQSwubViNdgEbVfZtAf/JEhTSwSFmOzpeItDM05q9EGKRdHHda4f6CbkCQunsgM/
         T8SWh74RXQMEg7VRvt+P1KJAxvgMjdytf2FT9q79JHjf/3UrmhQYW9u/OTwbCMct067i
         vCjGiAwXaYaVwh4OWcbWpa+DRQe1DKf2RJB9/p2DpwYy8gb1eIejGNHRNnZW1ITYkXM7
         a4mJc6s1gDpEvxpRGrVbaO7cUM3Ttx8UcPbbRIIyss62n2GvPP8+tbTLkMOptjdE9yqy
         HKHuij8irwudLe668vox6TRqdrVbcOc++JznslEi2HMEA9wuBd26bgfObDzBpX1LZo43
         nV3w==
X-Gm-Message-State: AOAM530DeXGnbVXVF2nhS6bfrUYFt3YJq3vlbbHL9Peal6zkELVtIhXN
        i3zAyEfSq0xyR70Ark6k7OB0UtNW
X-Google-Smtp-Source: ABdhPJwMylyvxdgmDtNrcyqNeT5JubcG2n3aucefqy54470sNhhxoEdY0xLm38s2QMzrtn1q2SnAkA==
X-Received: by 2002:a63:2250:: with SMTP id t16mr7099993pgm.439.1592413244082;
        Wed, 17 Jun 2020 10:00:44 -0700 (PDT)
Received: from martin-VirtualBox.vpn.alcatel-lucent.com ([137.97.149.246])
        by smtp.gmail.com with ESMTPSA id h9sm127838pjs.50.2020.06.17.10.00.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jun 2020 10:00:43 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Martin <martin.varghese@nokia.com>
Subject: [PATCH net v3] bareudp: Fixed multiproto mode configuration
Date:   Wed, 17 Jun 2020 22:30:23 +0530
Message-Id: <1592413223-9098-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin <martin.varghese@nokia.com>

Code to handle multiproto configuration is missing.

Fixes: 4b5f67232d95 ("net: Special handling for IP & MPLS")
Signed-off-by: Martin <martin.varghese@nokia.com>
---
Changes in v2:
     - Initialization of conf structure is removed as that change is included
       in another patch.

Changes in v3:
     - Fixes tag added.

 drivers/net/bareudp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 5d3c691..3dd46cd 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -572,6 +572,9 @@ static int bareudp2info(struct nlattr *data[], struct bareudp_conf *conf,
 	if (data[IFLA_BAREUDP_SRCPORT_MIN])
 		conf->sport_min =  nla_get_u16(data[IFLA_BAREUDP_SRCPORT_MIN]);
 
+	if (data[IFLA_BAREUDP_MULTIPROTO_MODE])
+		conf->multi_proto_mode = true;
+
 	return 0;
 }
 
-- 
1.8.3.1

