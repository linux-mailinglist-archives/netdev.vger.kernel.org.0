Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F1D4D0AC2
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 23:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343665AbiCGWOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 17:14:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343673AbiCGWOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 17:14:47 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8F3580C3;
        Mon,  7 Mar 2022 14:13:51 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id u10so23906845wra.9;
        Mon, 07 Mar 2022 14:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S4KRc2JPrzXRUzhnhouVf6rWLnTNsy7QJgg90N+SFgg=;
        b=OJtwXtXx5Eannq7k//Jp5ML1sR9bjgU0QhTwDhoiYjGHJzvyWMKCjsL6808BvtzLX7
         MsCm1kwWhic6uQ2XcyfXFmqa0/UI0qPdcdwqiu3Q+jCCsbmRv4pdtgatzOZ3qkBkDdSK
         M62qT+tJqC7J/4A91+1QBiosBt66dMVGT0lNc/NBJ1QO3wKDdUm22UbmqOh0+EX/3CMg
         IdtfFVzSgrYJyZhXrzvjRa3RD7MyWNiAW0yQlzWHxhPsuxFrUjIxz1ubrg8oRy1hlURO
         yLJTC9J4X9bIXlj3+yRkucOed8eOecV5OfSJdP2xpJpveTN8hFSgJFJvtKMTDOkZfXUQ
         kdMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S4KRc2JPrzXRUzhnhouVf6rWLnTNsy7QJgg90N+SFgg=;
        b=edQ1riKNDLM3hSPhHy1mq15+WYXnAO6sPO3l4wHGo+TMgCWXNmR/FP8rNo3bm08JTW
         49nwtms0eMumoaImm2zsO44TYzBCrVyl7/LS/9uHBdTQHoJuneqrovtZUT0VUBSuWrt4
         E/fvXeQ0GTcqTV6xLJb60O22Kn6VhP25VLzIwZlvWHxAiiArfvl3I9BajDtDTsmTEoou
         +T879qGFHKl2Fnjyesqu8H0hg9fAYdp0uMzj4hQrWKisH92rQuHjhu86LLa8qnw3agXf
         BVuZ0zpR0EOI7bas7eiOl9jO+9V/GYLiqxBadZcQ0GYND5Ekli91Dc6oTHBIljtHMll1
         9sFA==
X-Gm-Message-State: AOAM530Afh5s2UNz7nPdBfpcpVyIuYAbPhxulX1H11fP3pN3RwuI0OXe
        gexncZO+mx22ICa45+lgjG0=
X-Google-Smtp-Source: ABdhPJxuX46N8YfLziPqQK5LGqqqEsE4uEjlh6AByOvMMDk5DZJk92B96+DWQv3THo8a6V4GBZOjJg==
X-Received: by 2002:adf:eb4d:0:b0:1ed:c1f7:a951 with SMTP id u13-20020adfeb4d000000b001edc1f7a951mr9484235wrn.454.1646691230225;
        Mon, 07 Mar 2022 14:13:50 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id n4-20020a056000170400b001f1fefa429bsm2741564wrc.8.2022.03.07.14.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 14:13:49 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Taras Chornyi <tchornyi@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: prestera: acl: make read-only array client_map static const
Date:   Mon,  7 Mar 2022 22:13:49 +0000
Message-Id: <20220307221349.164585-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

Don't populate the read-only array client_map  on the stack but
instead make it static const. Also makes the object code a little
smaller.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_acl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
index e4af8a503277..47c899c08951 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
@@ -91,7 +91,7 @@ static const struct rhashtable_params __prestera_acl_rule_entry_ht_params = {
 
 int prestera_acl_chain_to_client(u32 chain_index, u32 *client)
 {
-	u32 client_map[] = {
+	static const u32 client_map[] = {
 		PRESTERA_HW_COUNTER_CLIENT_LOOKUP_0,
 		PRESTERA_HW_COUNTER_CLIENT_LOOKUP_1,
 		PRESTERA_HW_COUNTER_CLIENT_LOOKUP_2
-- 
2.35.1

