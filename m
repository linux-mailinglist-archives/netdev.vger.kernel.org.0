Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1363169B273
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 19:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjBQSlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 13:41:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjBQSll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 13:41:41 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2A63C2F;
        Fri, 17 Feb 2023 10:41:40 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d7so2368458plh.6;
        Fri, 17 Feb 2023 10:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JzlLtDg8M3UQOkK65vvzaRQLZYQsseOb8j91wy1coBQ=;
        b=anSFtD12yeDibKm7pDZx3YLNXkB5D49n8CAs1qTayhrZ3VKhHYFQU9ipMoBmaD3Q7o
         mhOkEh7FMPybcby9eSFFIxjihtRwUBz4a5BQMu6kSXPF6DMN1k9Em2qvnZrmGl4dmDNL
         Dc3Uv+7GQdFlwp/QE3BvKBJvTDHUYRhtMsdj1ICcd8mEF0+x43o1WZeTcUoGqbVaAD3M
         Bji2zl5emISFIrNM9Q81nSQFz1T3UtVufjQ1zpR2hGe6T+xYEaNnMsIoKsBDAchSlD3m
         Nl09YW/a82CyA2ciqu3E5L49F8Zlqu6+1r1VJnxlK/Dd3BBIR2DCMnWGtIY4ANFP4wtN
         y3JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JzlLtDg8M3UQOkK65vvzaRQLZYQsseOb8j91wy1coBQ=;
        b=SRklPdcp0yZKCQNllXRf9I8mZkY4p40giYjJKnFFL+RlYvAugSkIjhuBq0BUySpyZX
         utkUxppU8JK7/8im323Bh1gaEqTfxcyVIndEhX4HUQoaiDRR3SdGOmXSvUo5GDQaFGd4
         qVNLSkQZpr2xi7G6iaMipkss70rjUttNWDZknHtoSG8HcXEc3TEUB7WJnBPeTGWin+3m
         Emx6ygDYkVGEf8SrK1kiiVJXlQvYC6BsYDg0DpYWe4vbWhTqqim1SslfCzOLvw58yFun
         tgM5T7kDO+3VseMZ4v7r+oIPzk+O4tBTWuZuAH4Zts9+iL7JckDA4DDp023LAfQZQp+Y
         0tqQ==
X-Gm-Message-State: AO0yUKWX6fm3w4ClppRrvZYLeZno+YKdQ6V2RErYQ1cfsCVySGtcdG4b
        CiCM2rwWyP0OZWc4C9Mw0Ere7wl1a5MgsQ==
X-Google-Smtp-Source: AK7set+TJzozdBQPiNFtEm1sQJCDDxNmrbwzgQ5oiHVLEoPrrb7CA1gikXhEs8WEINsWA6fxDJfknQ==
X-Received: by 2002:a05:6a20:728c:b0:bf:488a:1da8 with SMTP id o12-20020a056a20728c00b000bf488a1da8mr9188939pzk.3.1676659299048;
        Fri, 17 Feb 2023 10:41:39 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f10-20020a63de0a000000b004fc1e4751d5sm2528175pgg.35.2023.02.17.10.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 10:41:38 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: bcmgenet: Support wake-up from s2idle
Date:   Fri, 17 Feb 2023 10:34:14 -0800
Message-Id: <20230217183415.3300158-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we suspend into s2idle we also need to enable the interrupt line
that generates the MPD and HFB interrupts towards the host CPU interrupt
controller (typically the ARM GIC or MIPS L1) to make it exit s2idle.

When we suspend into other modes such as "standby" or "mem" we engage a
power management state machine which will gate off the CPU L1 controller
(priv->irq0) and ungate the side band wake-up interrupt (priv->wol_irq).
It is safe to have both enabled as wake-up sources because they are
mutually exclusive given any suspend mode.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index f55d9d9c01a8..3a4b6cb7b7b9 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -77,14 +77,18 @@ int bcmgenet_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	if (wol->wolopts) {
 		device_set_wakeup_enable(kdev, 1);
 		/* Avoid unbalanced enable_irq_wake calls */
-		if (priv->wol_irq_disabled)
+		if (priv->wol_irq_disabled) {
 			enable_irq_wake(priv->wol_irq);
+			enable_irq_wake(priv->irq0);
+		}
 		priv->wol_irq_disabled = false;
 	} else {
 		device_set_wakeup_enable(kdev, 0);
 		/* Avoid unbalanced disable_irq_wake calls */
-		if (!priv->wol_irq_disabled)
+		if (!priv->wol_irq_disabled) {
 			disable_irq_wake(priv->wol_irq);
+			disable_irq_wake(priv->irq0);
+		}
 		priv->wol_irq_disabled = true;
 	}
 
-- 
2.34.1

