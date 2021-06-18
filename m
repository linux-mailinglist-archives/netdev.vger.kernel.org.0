Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7C33AC509
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 09:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhFRHe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 03:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhFRHe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 03:34:26 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2D5C061574;
        Fri, 18 Jun 2021 00:32:16 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id c15so4159167pls.13;
        Fri, 18 Jun 2021 00:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ouXRST2uuN1MN3jv2GbJUfCSAjNeJqySOQmdiaj/CsI=;
        b=oTJVtnlKfLtFIzbXUk1jKp9ZOsLoWqoTwNUdq97gps/nuvkxIeb2FeQb225o9QXeJr
         HRC04baoezwZFK1JmDYPCkkHhQzQ76ShQmQABMQ7DNti6YNKFJDtDzGNB/TeBsdX35bi
         ev1Pt0o8dpTNG9mvcMiaUig7O0MjEUxddWSWNXNswNzOtshcHh9O80hNRzIuHq/L6yBq
         lBVTDeXOToLkXngT4K2KWJlQu5bL+ozgQ2wTdWwdGXZa1wh2e6IaZRW/ZHOXoc7FRcp7
         4YqJryPxRj/tHcaLe3G5gb6PGc1fCVorjJ5e1uRK8/0nBVzja1nXEjQ89W7h0QnKJrWd
         4k1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ouXRST2uuN1MN3jv2GbJUfCSAjNeJqySOQmdiaj/CsI=;
        b=l8bbBmkCe5uSO1N+s+zRcY9oU88+ovfIZiICVwyqMMmfEdbr1rctpkaKqFBzm8YLsS
         EuKgI+YsuNDxGJiO1t9T6u9WQzOFsU6/YKPEgistpkuNnligN58xKBPdLvKqww26LOBq
         H0XYD1Bzj1zn73pkoH3EQZqRtrWnBYcQy+kZK/6J8emalG5idAZViCo8PycWqw7DXFFn
         xa0x6Z/30LdlOSlClUabF6mgs29F0P2puGROzDG3R3Jv5KFHlV/AARDq+SDJ2hBELijM
         jFVv3tr4SA7AHK9Wc9E36+BV2/EDAspAI6+U8PyIykCb6BDIL939bOLgMqv4OwJwlrF6
         rwxQ==
X-Gm-Message-State: AOAM530NJTPus+Hhf7VrBMfqeqrgZwBkerGTrKQztD50/MIZxaj8I1MK
        P+kqCxXFZkTfuo6q2Mzd/wA=
X-Google-Smtp-Source: ABdhPJwdBtTD8VqGkPlCQS15+55Y5B0F5zgSQ+RSu00QETmSJV5T3cY+2OYH30Up204rLLatVuANbg==
X-Received: by 2002:a17:902:fe0a:b029:11d:81c9:3adf with SMTP id g10-20020a170902fe0ab029011d81c93adfmr3488573plj.0.1624001535634;
        Fri, 18 Jun 2021 00:32:15 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.42])
        by smtp.gmail.com with ESMTPSA id p1sm6938295pfn.212.2021.06.18.00.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 00:32:15 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: caif: modify the label out_err to out
Date:   Fri, 18 Jun 2021 15:32:04 +0800
Message-Id: <20210618073205.3318788-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify the label out_err to out to avoid the meanless kfree.

Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 net/caif/cfcnfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/caif/cfcnfg.c b/net/caif/cfcnfg.c
index cac30e676ac9..23267c8db7c4 100644
--- a/net/caif/cfcnfg.c
+++ b/net/caif/cfcnfg.c
@@ -480,7 +480,7 @@ cfcnfg_add_phy_layer(struct cfcnfg *cnfg,
 	phyinfo = kzalloc(sizeof(struct cfcnfg_phyinfo), GFP_ATOMIC);
 	if (!phyinfo) {
 		res = -ENOMEM;
-		goto out_err;
+		goto out;
 	}
 
 	phy_layer->id = phyid;
-- 
2.25.1

