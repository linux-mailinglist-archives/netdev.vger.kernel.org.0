Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6655AAC2D
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 12:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbiIBKQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 06:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234836AbiIBKQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 06:16:20 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD208D3C9
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 03:16:18 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id c131-20020a1c3589000000b003a84b160addso2349238wma.2
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 03:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile-fr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Ppu2J88Gu1tHZo2MKLB/WRd5bJ+n6xSgR4rAOhTLsnA=;
        b=O93nkjE1jSw70oex0M0lRin5uM4AI7lLibEJgdvgM96cMrlfuj7yYFpX3HsowBPMKH
         9PtSMhq6X6gAoEQdCAykN0cc1geOS7y8KkTgUy2Q+F6J4odf2Gk8EVL0jRq0nqVcsq0N
         PbilKtog6qI51cqomFMVRPSkKOCGRwQxYSYdIjvc9lk5GYwE2EGz+fuYsGNVh7n28cPc
         F1Il/79HAUBccDc2ukZnwM04WlO6GHxAhcDhYVge6a9naH35ogkJ5FoARmFKPSddFFmQ
         WSzk03AjwSBVSP8CkmhqKn2WTHK8Dd1M/5xhXcndpOEKmdIwC8B2zmXJXHf1Wyidka72
         xsbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Ppu2J88Gu1tHZo2MKLB/WRd5bJ+n6xSgR4rAOhTLsnA=;
        b=ibuvs0J7x/UpBbbxNO5IQIawRaFInQ6cr23/lDWdCp4na/55vrgnM9lYg0iGd7Ujxn
         vfWlTFrhXNOu2lvKngro0QOAdgLxyxmnan4hwWvFAhHGtFvu9ee1qA4J+i709dBqsXCA
         lQr7KKt0PcxR/oViL+KNCSKAptJ792BrjHr+PELkGjNTLgJB25kzIBdp5ARzoUTD40Rd
         ngleOHKsrswIDG4h7pZlglUn7X5Tr4oJJEOL0nBNWKJc+UqcCgWk4kw9RoKW7Hz88RU5
         2sOIPQ2XZDdXTTdlic6gACBh+Pg5zpAkVP4Ycx4UqqdfpArAT1MBziKr6AsQ4+qPjsBg
         i8aQ==
X-Gm-Message-State: ACgBeo35icR+DDd5A/zbfQDg7a3CKuf8szW4vcZeBU1RMqOT2f2TyefX
        Wfzvw94suIKdd4CKxG3sfP88He5/1x+ddw==
X-Google-Smtp-Source: AA6agR5kxtkQ08cWtZrB+Hu9P0Zs9Gi+OnLVHsinnbSdXOQ62jUKfN/QX99G9/CWCN7L1c24bjd2ig==
X-Received: by 2002:a05:600c:1c95:b0:3a5:c28a:df3e with SMTP id k21-20020a05600c1c9500b003a5c28adf3emr2355285wms.40.1662113776331;
        Fri, 02 Sep 2022 03:16:16 -0700 (PDT)
Received: from P-NTS-Evian.home (2a01cb058f8a18001c97b8d1b477d53f.ipv6.abo.wanadoo.fr. [2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f])
        by smtp.gmail.com with ESMTPSA id a8-20020adfeec8000000b00226d1821abesm1140913wrp.56.2022.09.02.03.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 03:16:15 -0700 (PDT)
From:   Romain Naour <romain.naour@smile.fr>
To:     netdev@vger.kernel.org
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, olteanv@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        Romain Naour <romain.naour@skf.com>
Subject: [PATCH v3: net-next 2/4] net: dsa: microchip: add KSZ9896 to KSZ9477 I2C driver
Date:   Fri,  2 Sep 2022 12:16:08 +0200
Message-Id: <20220902101610.109646-2-romain.naour@smile.fr>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220902101610.109646-1-romain.naour@smile.fr>
References: <20220902101610.109646-1-romain.naour@smile.fr>
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

