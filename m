Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB625548BA
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiFVLeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 07:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbiFVLeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 07:34:06 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C823B3F9;
        Wed, 22 Jun 2022 04:34:05 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id x6-20020a1c7c06000000b003972dfca96cso8771890wmc.4;
        Wed, 22 Jun 2022 04:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=haqf5GAD+rBGZmKx8o4rvCABso31NnBIfgcGxz1iBNs=;
        b=AWN4YMhKAoutEapQGnWeMke/rKPJlCaCezrIfmxIpkWd396JJxnKIZkHh2B59yrVvq
         utQsmdA1jRNOYDi5Lk/ktS/lUlMWhOg0XaBtqbYbdDQoqxC6GBqxJ6ULmY9NDeEOaMzw
         Yrcy//rngcpVE9SrSd5e/WCHXkAn7U9ywLMemDtgQr6rBh54xiidrf50UPiOWRuotUY1
         Vin4oFYDUDvduOFGjmxgDKhUjs/1hRU+VkbRnxY4W7d0kTFq1q3NSPhW2tPKp+6NhPT7
         Sj5oabOuY+/MKWJiA4DlXgd9MmSG/45VMAC+pEOiUPJVdUIbd1pZ1PNQviBFqj9EeEkz
         CBKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=haqf5GAD+rBGZmKx8o4rvCABso31NnBIfgcGxz1iBNs=;
        b=H6Xp/PHe6SYta0Pa36fFREnkoIr1HGeRoggAqdn0cuYJMYX+7BDeCNwAf4GT1wUpBw
         OrgiBnbs8CNDSZ6nyiHp1I7AG8Z/FaoKDKKaVkVHG/0kqjP+XWMfniGFL1lBU0Wq79yO
         w7K7zKdOn649rEV2Xc+UMZ/5b6LQ1aEz095NbZcaqKT9zANjKLkowq7S/h1wKzlNb6/b
         PKBu+TVGuJ+/PIDtHob79wm+hDNvTU/ftFq4HvOySAtkgU6dVpaQ3qvnEZ7iIUo5N6P3
         OWjUv6J38BrB9dnGsc/urTE3gdzj72vEQXc5bi0aJsfbSlcdrxbUwpceXeqtJTeKgTHt
         yNcw==
X-Gm-Message-State: AOAM5327vSKnKaCbo3wLmtz8IIIuGcvS6s1biUmghAn8io9oTjXS9jMB
        jiXFJ6dvsIpfCIutoJ7zPDs=
X-Google-Smtp-Source: ABdhPJwi79hEQgvXjW2FpgFPTTrDBh6WNF6EFxEzmfTuRlQu3v4bPDHcV5K4z9/nw5GoUjrI8CY/Rg==
X-Received: by 2002:a1c:5444:0:b0:39c:3761:ac37 with SMTP id p4-20020a1c5444000000b0039c3761ac37mr47051687wmi.144.1655897644234;
        Wed, 22 Jun 2022 04:34:04 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id l12-20020a056000022c00b0021a3daef45esm20279297wrz.63.2022.06.22.04.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 04:34:03 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: mac80211: remove redundant pointer bss
Date:   Wed, 22 Jun 2022 12:34:02 +0100
Message-Id: <20220622113402.16969-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.3
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

The pointer bss is being assigned a value that is never read, the
pointer is redundant and can be removed.

Cleans up clang scan-build warning:
drivers/net/wireless/rsi/rsi_91x_hal.c:362:2: warning: Value stored
to 'bss' is never read [deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 40f9a31f9ca7..c61f83a7333b 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -334,7 +334,6 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 		      struct sk_buff *skb)
 {
 	struct rsi_hw *adapter = common->priv;
-	struct ieee80211_bss_conf *bss;
 	struct ieee80211_hdr *wh;
 	struct ieee80211_tx_info *info;
 	struct skb_info *tx_params;
@@ -359,7 +358,6 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 		return status;
 	}
 
-	bss = &info->control.vif->bss_conf;
 	wh = (struct ieee80211_hdr *)&skb->data[header_size];
 	mgmt_desc = (struct rsi_mgmt_desc *)skb->data;
 	xtend_desc = (struct rsi_xtended_desc *)&skb->data[FRAME_DESC_SZ];
-- 
2.35.3

