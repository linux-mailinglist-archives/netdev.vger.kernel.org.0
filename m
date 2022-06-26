Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F65255B136
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 12:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbiFZKf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 06:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232828AbiFZKf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 06:35:56 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E9B1275B;
        Sun, 26 Jun 2022 03:35:52 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id a15so6434461pfv.13;
        Sun, 26 Jun 2022 03:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CT9UzjAprHUqV7ZTg5rA+EnKneUfvjzMy7Q3wVldT2o=;
        b=S9F3gYcdAgALN/i00FyqnFPtw72EX93LhTZjMcfrkZUtXojwUQ9tPv/wzwSjp1qmWk
         TTZufc3+EeKVDchJO/N9kqI6IP9t4OMy+QPy02kqaNxRVAEGoQ2j4oozWseT+euZJaZa
         WwMfRf/17IKfcMeVkaDXkOhBnTNBoRsoUE7587XITamp2UYpa1AiEr4L13IIT1g1jVtu
         +t7ygiWiLTigI7XjxQbVzh7vWEnQDTQAnXTqn9dmF2jnN53kEJuBP0ckSNiB7ZEIs2Uy
         7Ktp5TtzKeM8yuDyBEXY9a/ZzxVFOhxQES4k5HvrEdlf11fajT6MYCXu3CPyxVic1NV5
         UgTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CT9UzjAprHUqV7ZTg5rA+EnKneUfvjzMy7Q3wVldT2o=;
        b=yjJi8i/zG9DO8tW3qjWsPz4wLGQ7izj/kxCqxMgat5QjsrQchI8y5HqTzpEve7tx5r
         3Fyr7AwPPT/KmqSKa9rYo1lRBaNxkKOrnGRZA2X37covPz/2/WuQPQw9dWKFUR/LiaOB
         GpcCTaFek3Nnhb15YPLGzpqviDDxULZ9F+78pn3NG3zoVRrii6yR3QI6EV/0rwOe9JM0
         Leuq/5/x4Q18gpZcjkwoovWuaWNLScNqTdJb658YQ0QZKl14VG05NfuDBVW3gDd6VMs6
         uePBe1xjVTJpufQI27IW/PdMAUSjaHfF4WhTHbIDPCEivOm97SpxZNyORZaUpZikgw3M
         QD4w==
X-Gm-Message-State: AJIora/cqls/PB8EjpNRri0JBFBDk5qeqF+bymeTOwsPmFG+vU6bUvhu
        VJ0h9BLiKYvugObreyhJP0l75TADkaUab6EaJclfng==
X-Google-Smtp-Source: AGRyM1tyxkS+6IBKYS5jpOLHXHR+Grdw0U05dHqC0cQpGPwB5fWT+ckGXL6txKRos0UN3ZQVfZs6tg==
X-Received: by 2002:a63:f91b:0:b0:40d:d291:1555 with SMTP id h27-20020a63f91b000000b0040dd2911555mr3559579pgi.399.1656239752099;
        Sun, 26 Jun 2022 03:35:52 -0700 (PDT)
Received: from ip-172-31-11-128.ap-south-1.compute.internal (ec2-35-154-4-181.ap-south-1.compute.amazonaws.com. [35.154.4.181])
        by smtp.gmail.com with ESMTPSA id n9-20020a635c49000000b0040cf8789851sm4849234pgm.35.2022.06.26.03.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jun 2022 03:35:51 -0700 (PDT)
From:   Praghadeesh T K S <praghadeeshthevendria@gmail.com>
To:     Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     skhan@linuxfoundation.org, praghadeeshtks@zohomail.in,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Praghadeesh T K S <praghadeeshthevendria@gmail.com>
Subject: [PATCH] net: ethernet/nvidia: fix possible condition with no effect
Date:   Sun, 26 Jun 2022 10:35:39 +0000
Message-Id: <20220626103539.80283-1-praghadeeshthevendria@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix Coccinelle bug, removed condition with no effect.

Signed-off-by: Praghadeesh T K S <praghadeeshthevendria@gmail.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 5116bad..8e49cfa 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -3471,9 +3471,6 @@ static int nv_update_linkspeed(struct net_device *dev)
 	} else if (adv_lpa & LPA_10FULL) {
 		newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
 		newdup = 1;
-	} else if (adv_lpa & LPA_10HALF) {
-		newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
-		newdup = 0;
 	} else {
 		newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
 		newdup = 0;
-- 
2.34.1

