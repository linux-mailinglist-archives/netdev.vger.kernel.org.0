Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFAB418241
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 15:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245596AbhIYN1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 09:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245566AbhIYN1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 09:27:10 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC637C061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 06:25:35 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id b20so53231004lfv.3
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 06:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BD8hM3ctAjh5GlIjFT5kwn0LQu6zAedelwfN30DStyE=;
        b=S3QN6jBIlqVPIXFj/FX9WnbO0Z1q/fs8vGGVrHKWZ2yIVistJmyK5dkhsxPifw4kdJ
         yeCp1DZ8L4i7d3GRuZ1fciS3D96Q+990huaVPKGIvWptKRwW9TnGCHQBlnZikgfGRa2w
         Dm/58syukCgxHqwjC1pXHPDM2EEhlh+Isd2JjU6HxHLLziHX74cvGcQsrv0RleXBZgn7
         JHd892oi07oxgv5p6yGonERq3NpSq/Y5RxBIgKpVsc2h6Hg0Qn/3sGhbVLlFAH3UfuWt
         58QxhuAdpDG+EkFzJCGRU53v+POeMao4RLLWfyMR/oAhRo7X3up7v5i5Tq9Z+WGL+R8f
         Di/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BD8hM3ctAjh5GlIjFT5kwn0LQu6zAedelwfN30DStyE=;
        b=Pfl+JTmHxPOSZZKOe21MARq/UOwZwNkzpttf5tYsbku6jN0yQvqAb9ahOPYjz8JIGe
         +iQheVEjVi858JSDCbekcOoAhWtjha//Jvqx1YT9yEJbYcovchxg0O3S2VH6Jz4ZXKjw
         UAnUet2kZ6dyJlAxpsxSswGiOHmXF+DCv9vlXXWArBXS71YXHjw9ToVTJQLjRv21QCQP
         ph+naHMDgRRtzEFrvx3yWcYUMgJUY9T1o7ovOKGmQ0tqFjPzfeqJK8s30zzsToLO9HMR
         vbo1jY1CWhm+pu7RV7aA7oLWUrJkB2Oh339nKTcquzWF4yQlOY7DXkYjsK7dMcUeINBn
         0TwQ==
X-Gm-Message-State: AOAM5302CjVzrf1Qy4UwNDfeWKLHUGxkH2nftNIGphphRQWp9DM1hhOB
        7+Pklzjz8oADt6FSAr67s4D90g==
X-Google-Smtp-Source: ABdhPJxkJtFFHt86rCtglBmM+zPtdEtXx/a7X0KVcQKlgXIX7dGxxHXrsE4FRqLg9KO8ocILaa23hA==
X-Received: by 2002:a05:651c:1146:: with SMTP id h6mr16907217ljo.444.1632576333998;
        Sat, 25 Sep 2021 06:25:33 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id y25sm199590ljj.23.2021.09.25.06.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 06:25:33 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH net-next 4/6 v6] net: dsa: rtl8366rb: Fix off-by-one bug
Date:   Sat, 25 Sep 2021 15:23:09 +0200
Message-Id: <20210925132311.2040272-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210925132311.2040272-1-linus.walleij@linaro.org>
References: <20210925132311.2040272-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The max VLAN number with non-4K VLAN activated is 15, and the
range is 0..15. Not 16.

The impact should be low since we by default have 4K VLAN and
thus have 4095 VLANs to play with in this switch. There will
not be a problem unless the code is rewritten to only use
16 VLANs.

Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v5->v6:
- No changes just resending with the rest of the
  patches.
ChangeLog v4->v5:
- Add some more text describing that this is not a critical bug.
- Add Fixes tag
ChangeLog v1->v4:
- New patch for a bug discovered when fixing the other issues.
---
 drivers/net/dsa/rtl8366rb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index 2c66a0c2ee50..6f25ee57069d 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1450,7 +1450,7 @@ static int rtl8366rb_set_mc_index(struct realtek_smi *smi, int port, int index)
 
 static bool rtl8366rb_is_vlan_valid(struct realtek_smi *smi, unsigned int vlan)
 {
-	unsigned int max = RTL8366RB_NUM_VLANS;
+	unsigned int max = RTL8366RB_NUM_VLANS - 1;
 
 	if (smi->vlan4k_enabled)
 		max = RTL8366RB_NUM_VIDS - 1;
-- 
2.31.1

