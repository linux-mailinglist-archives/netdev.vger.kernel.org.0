Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835E855E9E4
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238028AbiF1Qfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236263AbiF1Qep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:34:45 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F158E32057
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:31:50 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id h23so26831376ejj.12
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bs1pDxoqSwxHo6PhPuLte63s3qeUlbVxYb0CgUg+DU4=;
        b=b0U8IUi53H55fQXPVpT7iWqKz2mI5/X9m8w4K55yp+aofkZ+sHFsvMtY/c+YH02gS+
         C87rxW+fRKL1bImKBIRqvxd0JYMhVBSMJ3Vh3xkFvK08bpOK2Hj4TvEgeP+L22sApAOA
         rd0/6qM4ofM/J7pKsV9wkYxdeOO9hqSYmwfaU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bs1pDxoqSwxHo6PhPuLte63s3qeUlbVxYb0CgUg+DU4=;
        b=cNfp290SExVuO8tlyVKGVSSyEYU5g2wxryzqMld5jCc8QXaeIbQ/OrsMgjRBNRvVc7
         iPFgTAswc4rvMPu0G1olI6H0cLpzq6+9fCvP89Jn371Jw/s+1FgedlgOATiIjtzre6bF
         B9/YU89aWZJscQa2ImHZbNX4G8hGAtdChFIYz5wP4h8PWhOHEXDQsJK0Kf/prYTe/xC6
         flYfN+jjnJ1z+r/AdjoKpFoWTG37EdPTT4rEsgRyfhpYFI/oKfDqc0fw7HsNwIgact7E
         Nzy3z5jhumonPbrULrhtmm7oc/nPHGw3s5G1EC79MpyNTih0rai61xwT4pgsjx4qxwaN
         jkZg==
X-Gm-Message-State: AJIora/MjPFM2kVBVdNavkiJg7h2O72E9isblPRKK/YMd2F6wvVhjKjD
        L4yzLifA54JOF6AHvMN6SBXxQDtyMFm9qQ==
X-Google-Smtp-Source: AGRyM1u8k6DgrYmdGpKNDatzVFC7pbSEg6/eS3j6frJXw1YqoEM06/Q9Nd4fEzKvJKZY3sHlHq7cvw==
X-Received: by 2002:a17:906:604f:b0:718:e9e8:9d2a with SMTP id p15-20020a170906604f00b00718e9e89d2amr18166762ejj.315.1656433909538;
        Tue, 28 Jun 2022 09:31:49 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id b20-20020a0564021f1400b0042e15364d14sm9916952edb.8.2022.06.28.09.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 09:31:48 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v5 01/12] can: slcan: use the BIT() helper
Date:   Tue, 28 Jun 2022 18:31:25 +0200
Message-Id: <20220628163137.413025-2-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220628163137.413025-1-dario.binacchi@amarulasolutions.com>
References: <20220628163137.413025-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the BIT() helper instead of an explicit shift.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
---

(no changes since v1)

 drivers/net/can/slcan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 64a3aee8a7da..b37d35c2a23a 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -413,7 +413,7 @@ static int slc_open(struct net_device *dev)
 	if (sl->tty == NULL)
 		return -ENODEV;
 
-	sl->flags &= (1 << SLF_INUSE);
+	sl->flags &= BIT(SLF_INUSE);
 	netif_start_queue(dev);
 	return 0;
 }
-- 
2.32.0

