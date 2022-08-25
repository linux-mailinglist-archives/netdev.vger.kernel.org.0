Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9C95A1B4E
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243925AbiHYVkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244021AbiHYVkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:40:06 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FC218366
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 14:39:50 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id a4so26210197wrq.1
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 14:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile-fr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=eFl/t2WmB4Cmw4/jeRahU9yA2bOFxQ2lphXK/3SW+TE=;
        b=7RbmvRwuwTMvN0pNxve1OD1nICIm7Cc32BaAyIs+wy0MEDBPqsZ/Z57i5G5sClp7w3
         YJaQvUG6NgwxJxN8AWF3oHsO+gkx6VtOKiLLNp/yFnibzyJIbUx0Vh8/BlTg7HoVEkcR
         RZrFHUi19ed5IOa4KQhNs72jhdInrDGEflUUhFAP+2+0j5VodAPBNYed1MN0TqIW3gdc
         Y7FLY4OAfNPE32YwY8S00crDBzGzKyinSBgLmpMEc5eBbYH4vPmLCYRqgjQo+M66P5sQ
         tKzLPSYhYMO3P+asYTLgvqUqubST6MYhG9HoeYateob+WJ1dE18DLQjwxrL2SRuE/dFe
         mTiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=eFl/t2WmB4Cmw4/jeRahU9yA2bOFxQ2lphXK/3SW+TE=;
        b=MiVwe/vUdmgHFkecQKcQWdN04wlzKxzXfz3EGz9eyoSOO5KZiWkUSMpMJAsOAcoSxt
         H9K4BqsigofbajpfLukKGTeqoiJxLdDEpgCj3bfwd4p74PsZrkioNJbA2qV+GIX29SPJ
         PYlA2L/42l/sm4/s5G3vXMt/azMjBVz3gmamSWa2gs8LYmJ8zIuXxD52XfYcisygAxbX
         MWjY3/mCabcsjjQPEpFR070xefxUc3qIog8y66z/zUd8tYHsslHo6f9kma/1qLk9CvbS
         tHvJpehWq9pO2MtE3mOs2JiaCSSk8WPi0L7fYJ1yFijjokYHUSHy0KVk3oseyXf3/k5s
         Gxzg==
X-Gm-Message-State: ACgBeo156H5YiVyaSmACo6Q9z3QBazrvDVaUjeum7JHt+0VpthnFhmZe
        c+/3kQg7PEtaQVb/6upT14uBHrHDsaOsqA==
X-Google-Smtp-Source: AA6agR594ptqW8OBKnC+ozAn+QaNLffZoOt3T65YH68Q/nAGUgV05i1GmdX2NQdB6SprJROaUwlq8A==
X-Received: by 2002:adf:dd42:0:b0:225:33d0:7d1 with SMTP id u2-20020adfdd42000000b0022533d007d1mr3270890wrm.168.1661463588156;
        Thu, 25 Aug 2022 14:39:48 -0700 (PDT)
Received: from P-NTS-Evian.home (2a01cb058f8a18001c97b8d1b477d53f.ipv6.abo.wanadoo.fr. [2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f])
        by smtp.gmail.com with ESMTPSA id j18-20020a05600c191200b003a5c1e916c8sm14038471wmq.1.2022.08.25.14.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 14:39:47 -0700 (PDT)
From:   Romain Naour <romain.naour@smile.fr>
To:     netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        arun.ramadoss@microchip.com, Romain Naour <romain.naour@skf.com>,
        Romain Naour <romain.naour@smile.fr>
Subject: [PATCH 2/2] net: dsa: microchip: add KSZ9896 to KSZ9477 I2C driver
Date:   Thu, 25 Aug 2022 23:39:43 +0200
Message-Id: <20220825213943.2342050-2-romain.naour@smile.fr>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220825213943.2342050-1-romain.naour@smile.fr>
References: <20220825213943.2342050-1-romain.naour@smile.fr>
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
Signed-off-by: Romain Naour <romain.naour@smile.fr>
---
The KSZ9896 support i2c interface, it seems safe to enable as is but
runtime testing is really needed (my KSZ9896 is wired with spi).
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

