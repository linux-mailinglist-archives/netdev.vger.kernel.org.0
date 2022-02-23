Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6571A4C14A6
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 14:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237875AbiBWNtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 08:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbiBWNtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 08:49:22 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A99DAF1F2
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 05:48:54 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id s14so26898216edw.0
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 05:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XJf+uw2jWe1usTwvxxsy/38bR+SenUbt3ZK8Eqd3yps=;
        b=EBgyp+N++TiNNaCIinwgHJthRb6JGy+xks3vk7H9t1qEehx632sFgX6kza5yxBVFXP
         QHKJ2dUBXfMOXrcgbCS0BM9faI2fqB+0AcGnmV7Gdyhujs6jRZ1Gk0gDNTfszGJAstR1
         8Pgmo8TCNgUsp89qhzzslFvOmZP2Hqt5xd74N4ly8H9Fzd7cV824EbMaVrGEJWMn9O3a
         JDPqDwSLzEOrbKQGMee/caSQzUBSIkQbfDEszrfhziC34hZGfrkTBERv7eW5w4Y46Oin
         e5vs+RpqoBAIBWr5nFNePRMg9nVzB+28catrsHnYHXG8HGDz2kjZoHDLVUH+mDqItGT3
         N+0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XJf+uw2jWe1usTwvxxsy/38bR+SenUbt3ZK8Eqd3yps=;
        b=YuaSRJvXCYiYUhvo3d0W1SKlMf/eXrr+9LDncxHzhzquJWEqv6WT3rLHVMKArkyYbo
         7DZiNu7Vvq2kuOzh3m9b0YIPNy+4+sa0APxeDQw+Sx+RsETwiAgRJyb6fsFrrT06W2UN
         jEMUCwHgyspVwgHxi9/uOKV6LAukr1xNP57q7GwJjz4z78huW9fhuxv97xMn0QJf812B
         xWkM+Bnt8AuNLtM62McTj2hsKluHg8Pow3Hj3dhRRypzhoMEwW3HmybpCYjo+ZHJVoFl
         MjGjsdRdmwiN6saGDaNBd+zM7HL1XXzmoZXZeReMMoZvZX6tyb5quXj/TxEpXWk533MC
         1kIQ==
X-Gm-Message-State: AOAM5326MjjIORXqFdGWnU31C7QYQ64GJBdF6A8bL2vOzcS42eRP/LEE
        Jjv1SgJfLKCJgRJbZoJfOD4=
X-Google-Smtp-Source: ABdhPJx8pCA0q3O6NNDh4xbsmz0FhvzuN8RWZPcEh6GatBbGWxg0uT3FT8mfM3Om2OQdlI0GI3uynQ==
X-Received: by 2002:a05:6402:2694:b0:411:f0b1:7f90 with SMTP id w20-20020a056402269400b00411f0b17f90mr32501946edd.398.1645624132829;
        Wed, 23 Feb 2022 05:48:52 -0800 (PST)
Received: from morpheus.home.roving-it.com (3.e.2.0.0.0.0.0.0.0.0.0.0.0.0.0.1.8.6.2.1.1.b.f.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:fb11:2681::2e3])
        by smtp.googlemail.com with ESMTPSA id e18sm11948376edj.85.2022.02.23.05.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 05:48:52 -0800 (PST)
From:   Peter Robinson <pbrobinson@gmail.com>
To:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Cc:     Peter Robinson <pbrobinson@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH v2] net: bcmgenet: Return not supported if we don't have a WoL IRQ
Date:   Wed, 23 Feb 2022 13:48:48 +0000
Message-Id: <20220223134848.3015840-1-pbrobinson@gmail.com>
X-Mailer: git-send-email 2.35.1
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

The ethtool WoL enable function wasn't checking if the device
has the optional WoL IRQ and hence on platforms such as the
Raspberry Pi 4 which had working ethernet prior to the last
fix regressed with the last fix, so also check if we have a
WoL IRQ there and return ENOTSUPP if not.

Fixes: 9deb48b53e7f ("bcmgenet: add WOL IRQ check")
Fixes: 8562056f267d ("net: bcmgenet: request Wake-on-LAN interrupt")
Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Suggested-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
---
Changes since v1:
 - Use EOPNOTSUPP insteal of ENOTSUPP (Jakub Kicinski)

 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index e31a5a397f11..c0fd2d4799a0 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -60,6 +60,10 @@ int bcmgenet_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	if (!device_can_wakeup(kdev))
 		return -ENOTSUPP;
 
+	/* We need a WoL IRQ to enable support, not all HW has one setup */
+	if (priv->wol_irq <= 0)
+		return -EOPNOTSUPP;
+
 	if (wol->wolopts & ~(WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_FILTER))
 		return -EINVAL;
 
-- 
2.35.1

