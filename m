Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 227796EFA7A
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 20:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239069AbjDZSzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 14:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbjDZSzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 14:55:04 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1682086B6;
        Wed, 26 Apr 2023 11:54:56 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-63b5465fc13so5951772b3a.3;
        Wed, 26 Apr 2023 11:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682535295; x=1685127295;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/ltBIeGTYyg79oc/ZiZiDTqh37bCSEcDIezVzdk5HLU=;
        b=YH3upLfK3z4YdSraod17XRacklyLaG5drH5GqlW/GAWaZbl51/j8shNBZ4OYmj4WbW
         mLG8klPqQ3OcGwRTlhj+rc9sq0NFbNkwOcpbXEsuo0z2G1rIiBA/A/sOTDVBbqmq4r7Z
         aod5EEJNNe1+KOqqMVBrAUsVPgiGsJmwjfWO+lLcnWhwRqqRqpOAV1sXd4nRLVLnqB9K
         1zlwa/TYrAzhTmZZygJqpGoWTKunDcPr1lTVVUR7dv+tlMtDwfcpDkw3wGcGhjFcbUSP
         rASIFuuc2Xy3oS79yAw8K9qIIkQ3qMILGXDwGwinEvSobmRR4oSO+SeM88Xx7Xi1c+bR
         eWeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682535295; x=1685127295;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ltBIeGTYyg79oc/ZiZiDTqh37bCSEcDIezVzdk5HLU=;
        b=kZMWhhcHMs1pYVomfKaTdaLhzxOoVmyMOYt9ZcsJn8ldSH4PRHKd9wDycQhrUSv8Kf
         DsV1fbTwh7ROUNMmHxnqwgfibetzof7hjKX8DJKRoDhJmvVNq1RfgGp7j/m41s4/Zyo/
         AHwVkWGqKWwi9QfrwOSPGALjFSqtW8EW5T8ZNLVXJvV659ORJjWZcDiLHKYFEzaUi24h
         AaNVtmKwr+ggNx/ugUcP2zBhApXi52Nr7f39ISTPSHicsEvzTxBG/8udDqY3mHOuCYJr
         V76jkpQ6+TKvhc1StM1RD325DsfoDaAxaW/R0RF78vv3mj7ZOycxEkeKxgVt9j6mcsVR
         9+Ag==
X-Gm-Message-State: AAQBX9f0ix2k7ya7ArpGJXsXr0UFbk8PZRsRS97ffC+MKg6fzZ6tSwJD
        mh4LGAekDhs1WfCYAWczN6AafcF4khnJsw==
X-Google-Smtp-Source: AKy350bSuikIcIqojWr8teMubcHLwpy10Bmo+SkE51TpE3wpfmcxjp9cVN+PRNV31Rq7zLFgDVVYRQ==
X-Received: by 2002:a05:6a00:13aa:b0:637:f447:9916 with SMTP id t42-20020a056a0013aa00b00637f4479916mr31430352pfg.16.1682535295177;
        Wed, 26 Apr 2023 11:54:55 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y72-20020a62644b000000b006372791d708sm11639254pfb.104.2023.04.26.11.54.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Apr 2023 11:54:54 -0700 (PDT)
From:   Justin Chen <justinpopo6@gmail.com>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        bcm-kernel-feedback-list@broadcom.com
Cc:     justinpopo6@gmail.com, justin.chen@broadcom.com,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com
Subject: [PATCH v2 net-next 4/6] net: phy: mdio-bcm-unimac: Add asp v2.0 support
Date:   Wed, 26 Apr 2023 11:54:30 -0700
Message-Id: <1682535272-32249-5-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1682535272-32249-1-git-send-email-justinpopo6@gmail.com>
References: <1682535272-32249-1-git-send-email-justinpopo6@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add mdio compat string for ASP 2.0 ethernet driver.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/mdio/mdio-bcm-unimac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/mdio/mdio-bcm-unimac.c b/drivers/net/mdio/mdio-bcm-unimac.c
index bfc9be23c973..6b26a0803696 100644
--- a/drivers/net/mdio/mdio-bcm-unimac.c
+++ b/drivers/net/mdio/mdio-bcm-unimac.c
@@ -334,6 +334,8 @@ static SIMPLE_DEV_PM_OPS(unimac_mdio_pm_ops,
 			 unimac_mdio_suspend, unimac_mdio_resume);
 
 static const struct of_device_id unimac_mdio_ids[] = {
+	{ .compatible = "brcm,asp-v2.1-mdio", },
+	{ .compatible = "brcm,asp-v2.0-mdio", },
 	{ .compatible = "brcm,genet-mdio-v5", },
 	{ .compatible = "brcm,genet-mdio-v4", },
 	{ .compatible = "brcm,genet-mdio-v3", },
-- 
2.7.4

