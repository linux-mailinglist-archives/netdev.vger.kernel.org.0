Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B104417D30
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 23:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348665AbhIXVrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 17:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348652AbhIXVqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 17:46:53 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C8CC0613E4;
        Fri, 24 Sep 2021 14:45:15 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id k23-20020a17090a591700b001976d2db364so8551063pji.2;
        Fri, 24 Sep 2021 14:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=epToM7rTUgDt/oPY5JZMe7Kk98e+irfzzBER4/Xpfp4=;
        b=dNDP3CaQeEGsblNafyCxRaIg4lRVSpTrYzue0XIllqggvAnzdlv559QOJO0lvLTtFp
         DDMLhIPUU+JyOBYfjDhzcOEAi38XzXa7FWe7mkiYNoViB2zs40m1giQvfXWWFjAoAVHi
         ERMQA2ZvtsrqhBZRtebFeWZy5ogX+xaKQB9voyxze9P61RIx9oQ6PTd4r2Jjn3c6qKrz
         rYkqQGApSjwgV3HZREPXzkHvdP2FQxVzLZUiB7WBL29M/C8z0/wc2WpRdTMBCwSyH80a
         NLEYpw/qy+Vvng2IBNzVH/hSn8/SXkNBoN/SIucAs2D9DOqrpa5f1RT6jDxrcSPX63zS
         ZXEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=epToM7rTUgDt/oPY5JZMe7Kk98e+irfzzBER4/Xpfp4=;
        b=BLrTHH0rfPrciJm4TMqqlEmcor9fbKdXGcZKXLJ3T0oS+85rqjYZoTiFX9SMaBlCPu
         xv8AF1FRn/wXorZDsf0WwEgX+xdaKKphwVRfdfn7Un+3kDOF4JrlaNBYtftF907zMDcR
         2uBXgzP5BX8+s6H8rJj0zN5+gyLa8V/woeYnXMnb0OpEbv/CU4GuHVKmsI0WC4YP1e9d
         THGtpUVLqQxXRfgNvcalk4wABG+ImtwCD96tApPIu/8c3YbafmKNLVW0vJ10hVZciqy0
         urV1eLGI1//pHFGAl81xE7yw9jAQEfv4hdI+BZZ4xNWiJ00IwdkFrnuLdfrmwMj8WvJC
         qO4A==
X-Gm-Message-State: AOAM530G/H4epDbac6Xvgxv10Rh70UoOmiQm+Lh1ijGHyrIFY9KSVcwH
        wy0jYuQI2VykuPkSRLASX8aKABm9ofm+zw==
X-Google-Smtp-Source: ABdhPJxMxy7rARwSn89e5tP/HM6c8wUUMpshXQGMXqQ/qMpXAyOnYrBp6Qn+w4L9nJqji48KkTj6uQ==
X-Received: by 2002:a17:902:aa02:b0:13a:6c8f:407f with SMTP id be2-20020a170902aa0200b0013a6c8f407fmr11130485plb.59.1632519914540;
        Fri, 24 Sep 2021 14:45:14 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n66sm9842029pfn.142.2021.09.24.14.45.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Sep 2021 14:45:14 -0700 (PDT)
From:   Justin Chen <justinpopo6@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Justin Chen <justinpopo6@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Doug Berger <opendmb@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Chan <michael.chan@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        dri-devel@lists.freedesktop.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK)
Subject: [PATCH net-next 4/5] net: phy: mdio-bcm-unimac: Add asp v2.0 support
Date:   Fri, 24 Sep 2021 14:44:50 -0700
Message-Id: <1632519891-26510-5-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com>
References: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/mdio/mdio-bcm-unimac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/mdio/mdio-bcm-unimac.c b/drivers/net/mdio/mdio-bcm-unimac.c
index bfc9be2..14202a1 100644
--- a/drivers/net/mdio/mdio-bcm-unimac.c
+++ b/drivers/net/mdio/mdio-bcm-unimac.c
@@ -334,6 +334,7 @@ static SIMPLE_DEV_PM_OPS(unimac_mdio_pm_ops,
 			 unimac_mdio_suspend, unimac_mdio_resume);
 
 static const struct of_device_id unimac_mdio_ids[] = {
+	{ .compatible = "brcm,asp-v2.0-mdio", },
 	{ .compatible = "brcm,genet-mdio-v5", },
 	{ .compatible = "brcm,genet-mdio-v4", },
 	{ .compatible = "brcm,genet-mdio-v3", },
-- 
2.7.4

