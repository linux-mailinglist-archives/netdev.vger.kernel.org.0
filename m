Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C12E5A5D86
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiH3H7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiH3H7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:59:10 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B048D1E2A
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:59:08 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id r204-20020a1c44d5000000b003a84b160addso1351646wma.2
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile-fr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Ppu2J88Gu1tHZo2MKLB/WRd5bJ+n6xSgR4rAOhTLsnA=;
        b=5Pp3pKNeYJEF7Fqpj392qseH49Lfywe2hUH5p0Fo39OJD41b5pkx5P76qdnWO508lA
         E/P6YRCAYUDwh8ke6eyUBmNXkLqWF2bYlCFGcj+Nd6qCrtPNfZobk8RPrg4D4yURvP6M
         oCtOlEjHh1IP6DtEROVs5HU95b+ibKMpOBOJ8ftblh+fjv4PBvPoh4OUnd1HUexI5nrv
         wwQLjvj9RJlT4duiocnBZZE/pPrT1OoWhYWDp+JUrYnqGAreQDo+ChJsvxQQlYI9ryel
         JYi1rfp1sUjJyWfNgeQHO/5RVg7unG1+jmDz98LakPl1Rrf0BFpuxUxpnhUvFeRJIt/+
         tibg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Ppu2J88Gu1tHZo2MKLB/WRd5bJ+n6xSgR4rAOhTLsnA=;
        b=X5ok674y2OGSBcx/uLESBiZHxEoleN21tYYRJssKQZtl5Nda1ets0IxXaLw/eWsmCK
         y+YNSoWPMY/+fRWyyaZqtsfNcxSScxyvm/zdpci+Y9GitLGs+Ehi2J2AbmJVR4EU6d1V
         jllFwci6HUzMhEh+zaxvVJ5WkldpyLykjBytjhsrLpb9ltyQFg2zYbFSzgWQIHz3WUZl
         K5HnJmeZKDM1hN8F7cWr44tjN+auYQ5VocZw9oeWNRafYhtDU2CkyBYrfCltlTCL4y47
         LFY2nb38fGtW21IXmi7xQdEoK+4CxxE3JjPaZfrlnmYkIYYy5eVRXOwt0IEKfaIFZlIt
         MOmw==
X-Gm-Message-State: ACgBeo1YYujQ+kdeYSrdqFTE8lmQxr6nyk7ZrpRgDRaqtEmELABsuGDK
        /ehp6yJBHtzBTaFcWccJcnRJpHwy9LweJg==
X-Google-Smtp-Source: AA6agR5RwSjmHLtsVoCUzOH32fEXzpaOWWlBuhkQ3NOpL9Hs59MSLO8/wqhor5aSS2YARbtcVh3k6w==
X-Received: by 2002:a05:600c:1e04:b0:3a5:c83f:76bd with SMTP id ay4-20020a05600c1e0400b003a5c83f76bdmr8906544wmb.191.1661846346652;
        Tue, 30 Aug 2022 00:59:06 -0700 (PDT)
Received: from P-NTS-Evian.home (2a01cb058f8a18001c97b8d1b477d53f.ipv6.abo.wanadoo.fr. [2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f])
        by smtp.gmail.com with ESMTPSA id r21-20020adfa155000000b0022585f6679dsm8980142wrr.106.2022.08.30.00.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 00:59:06 -0700 (PDT)
From:   Romain Naour <romain.naour@smile.fr>
To:     netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net, olteanv@gmail.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        Romain Naour <romain.naour@skf.com>
Subject: [PATCH v2 2/2] net: dsa: microchip: add KSZ9896 to KSZ9477 I2C driver
Date:   Tue, 30 Aug 2022 09:59:00 +0200
Message-Id: <20220830075900.3401750-2-romain.naour@smile.fr>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220830075900.3401750-1-romain.naour@smile.fr>
References: <20220830075900.3401750-1-romain.naour@smile.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Romain Naour <romain.naour@skf.com>

Add support for the KSZ9896 6-port Gigabit Ethernet Switch to the
ksz9477 driver. The KSZ9896 supports both SPI (already in) and I2C.

Signed-off-by: Romain Naour <romain.naour@skf.com>
---
The KSZ9896 support i2c interface, it seems safe to enable as is but
runtime testing is really needed (my KSZ9896 is wired with spi).

v2: remove duplicated SoB line
---
 drivers/net/dsa/microchip/ksz9477_i2c.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index 99966514d444..8fbc122e3384 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -91,6 +91,10 @@ static const struct of_device_id ksz9477_dt_ids[] = {
 		.compatible = "microchip,ksz9477",
 		.data = &ksz_switch_chips[KSZ9477]
 	},
+	{
+		.compatible = "microchip,ksz9896",
+		.data = &ksz_switch_chips[KSZ9896]
+	},
 	{
 		.compatible = "microchip,ksz9897",
 		.data = &ksz_switch_chips[KSZ9897]
-- 
2.34.3

