Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154325439BD
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbiFHQzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243517AbiFHQxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:53:20 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85C23C6B3B
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:51:26 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id h23so31557036ejj.12
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 09:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bs1pDxoqSwxHo6PhPuLte63s3qeUlbVxYb0CgUg+DU4=;
        b=f/RB/AADgG9sZPdH/FFOUOjP3DRCdWgEZkMCyF3Wrbhsdq21HPvBLY80JKH5KLQWx+
         6+x2um026CENOu0ajA+XBYLhJLbisgS+YtX6v51vRcba0N7G26i7I9TbyL5yV4qN/TeT
         depNj9mKPpvaNLgnb9VQwzA2JB3OKiiEM8vU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bs1pDxoqSwxHo6PhPuLte63s3qeUlbVxYb0CgUg+DU4=;
        b=erWffE4MILa3lEJfyvDeO4XHMqCWmilewDpH1hGdlxrST94E65fLNGg063e3X9izvD
         mn5Berx2C2lnw/E8gKZipTM/lETs4Fi5fcLeEp1qXKi9w7ywgfVQhFTq5tPslyCKKQ6E
         EzQNRS8L8QsfJ4i2qzENv5h2i8tzEqQqg8Zyt4M00f4Nl9CnehBL2W1NwaO01UMr479+
         GW5Yn/DaaWMK1NJLk7ebS+gflpZQXze686M4TeSpALyhAwvIrpx3/DddSzhzH8swWuC4
         kADX7hUOu53J8UMxn5sA5epAyS7TXzrXm97efXOChEvvmOUr0Y0u6k3FKSOjqo6ube2k
         cwEA==
X-Gm-Message-State: AOAM533DRlbVX1/BLYPQ2KCnJaUuapTjF9Tg5qa2dx/ALR22bO6fPbPB
        GvqVHhbHP38k+T7sBm5cxOOViw==
X-Google-Smtp-Source: ABdhPJxs+KHSiIY16R/4F/cW1agfC4LfsUa/2oSVYolckwJQXrxz201mbFu3QGgcEOO+6n5FaSJTKA==
X-Received: by 2002:a17:907:3d8a:b0:70e:6b1:b004 with SMTP id he10-20020a1709073d8a00b0070e06b1b004mr27556484ejc.61.1654707085258;
        Wed, 08 Jun 2022 09:51:25 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id c22-20020a17090654d600b0070587f81bcfsm9569071ejp.19.2022.06.08.09.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:51:24 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 01/13] can: slcan: use the BIT() helper
Date:   Wed,  8 Jun 2022 18:51:04 +0200
Message-Id: <20220608165116.1575390-2-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220608165116.1575390-1-dario.binacchi@amarulasolutions.com>
References: <20220608165116.1575390-1-dario.binacchi@amarulasolutions.com>
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

