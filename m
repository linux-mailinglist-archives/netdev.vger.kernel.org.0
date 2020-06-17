Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4651FC544
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 06:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgFQEbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 00:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgFQEbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 00:31:48 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC947C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 21:31:47 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ga6so406835pjb.1
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 21:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0mjT1MJypGer4uJ9EAYwHqaOMGHx76A+XByV8fHG+qI=;
        b=t1abTrQ9FE7azuJUZfnTwdNqUlqNQxeouR/XpRO4wwgEY+MwPU4TkulOPG+Bc49J6P
         xqYaH8+yfuiKONQiClKhOCIUSVA2Np/P+rGhiCT3M6JrFx1rkAEo7LaFLkaYG7+gbRML
         ePIt4DVFVQefMdJJCT9j17Mj148A7ynfvqTyeVdqyAOuL2t9wK5OY4+URmNietcnrtkA
         YyIZEn1J6tMcuMU+SePcORsFEaSrjmcBQPtjvaR2jI3YuTI04Nf3xgI0xutaqSNYsXtw
         JwukXHpwMmfamc12ageaEK2CFYy7bGL+U7G7zQf0RF0iqZ/tkXLj3pbWNnVB6SdKpp2w
         51+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0mjT1MJypGer4uJ9EAYwHqaOMGHx76A+XByV8fHG+qI=;
        b=dciKp5YFJ4q7u3evCRPhLdsrg0X2vyjBVh9tcbg8/Ue4RXwReafjIKxQXD4H/lR/OF
         ypqPWYVPqsdgJ/xSRUksLo4vGolpU16UjJ4ZmR8IyMM+ACl74D1wfTHtivXw4/WCFTml
         /VN15tm5ox65sessLdZFkHjyfvVoMA56/2Mlk5Cbe5ijWuaYw/gIjzUGfIlH6tRMNymb
         9GiBkNVCrnUDMWR4TlhwNjKt8/r2Y1RJWMrN9Xy530bckR6nwcQ4e7UN8MtnugudpPcJ
         HP6AYVMx/z6X2DbncV9qoQcf5nGZdPzJnD42zzoQcW8SOH2CuZREvPbZEvMs/hagGMIi
         Fyag==
X-Gm-Message-State: AOAM531JcCi0BSbPcFeD4qDF/WG/fYWqPrjmrqIRAs3Y8EuZd3Gn7axi
        DKZv1yZHP6ppHpSWsssM+X58lDaz
X-Google-Smtp-Source: ABdhPJyUqH/M0/kUwSWrW/zOcs3s/dFlnZnBrrI1nxvhnTjfdl0bx5IzLPVkIvJpaJqTrt0iYZHMdg==
X-Received: by 2002:a17:902:988e:: with SMTP id s14mr4802521plp.142.1592368307157;
        Tue, 16 Jun 2020 21:31:47 -0700 (PDT)
Received: from martin-VirtualBox.vpn.alcatel-lucent.com ([137.97.141.128])
        by smtp.gmail.com with ESMTPSA id 5sm18789404pfc.143.2020.06.16.21.31.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jun 2020 21:31:46 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Martin <martin.varghese@nokia.com>
Subject: [PATCH net v2] bareudp: Fixed multiproto mode configuration
Date:   Wed, 17 Jun 2020 10:01:39 +0530
Message-Id: <1592368299-8428-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin <martin.varghese@nokia.com>

Code to handle multiproto configuration is missing.

Signed-off-by: Martin <martin.varghese@nokia.com>
---
Changes in v2:
     - Initialization of conf structure is removed as that change is included
       in another patch.

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

