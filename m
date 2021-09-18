Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE4D4107D4
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 19:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239439AbhIRR2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 13:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236861AbhIRR17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 13:27:59 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BC0C061574
        for <netdev@vger.kernel.org>; Sat, 18 Sep 2021 10:26:35 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id z184-20020a1c7ec1000000b003065f0bc631so12402646wmc.0
        for <netdev@vger.kernel.org>; Sat, 18 Sep 2021 10:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uIXzIXgdUYqhwvmKzpjDhIHlxjzpeck0H6TcPCSjnJI=;
        b=ANbk3iqIPgNL+0qbg4mgInziCUrLhFbxZeEGXHz8X5MCgkOog+F47HfZsfXt4q8kCd
         jNr6OglziA6qLqjldrRYLyvUYHVQBa9xxvbNNVbxcPebuYuo+HKVUk3e7bMQJXy5iEj8
         hoslYoiAhAQrO0Dl00JtMJwlVsQzYl19Gm96M5z/OedRqGcbzhCTiJaPYYAmmyJFpyAj
         kRu1boruvNtuUfsbHWLsGM/Mmh5hFp/QuEGqu+9ztybnD/xZbFV2cCa5opMIJl6GezP7
         GZC66bzevSfYBNEQfU71ZydwooF9wXwQ65VSqGb6m3XmyUEpT42M44olaCQV5JLyDP2v
         lUkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uIXzIXgdUYqhwvmKzpjDhIHlxjzpeck0H6TcPCSjnJI=;
        b=a3XXJlWRxvTPDqm5T1sz/21faUrjrUm26oYQKVanXF2i809gcls/ykHc0NSE3Gx4Cf
         CqVhwqT1llUTnohNtAZumJyN/FZYczEJ2hoN6oFtgPDohQYPZErkwS3yImdFjfdjux3b
         jKHIeVs7H9TeN6PH4WXjJkcMjjVWHIVu2o7aeVA3foW9jAP/fz3mHrxh2J/YEPrc6FCM
         WqsCKI9ELJajEwt6/bow6jGl/DDk++kg2mL4Hjff/ZsHaJ1hh1HSLi4c7tsek7J75e+5
         TO/KDmIyeNBeysAyaOr2zDQyF6Illq6RuuuUX5E7ASQQlCw66soEr/cBcfYeWLNkgFsT
         VsDg==
X-Gm-Message-State: AOAM531jAwGIyvM6Us+x4zfARE+7O6q8lXKRtK1gED4Ayhxd8W7tJv4G
        rlXQYMt4FRJPsKuL2XDWSD0OQ8liZM4=
X-Google-Smtp-Source: ABdhPJyUlFojfO+1k6VeDSrqZtFGfwZHZ2uVzObmGbJZYGmNQNFGyLi74CH1dBQf/ZE2HMNFHa3lmQ==
X-Received: by 2002:a7b:c191:: with SMTP id y17mr16328994wmi.122.1631985993479;
        Sat, 18 Sep 2021 10:26:33 -0700 (PDT)
Received: from debian64.daheim (p200300d5ff45c400d63d7efffebde96e.dip0.t-ipconnect.de. [2003:d5:ff45:c400:d63d:7eff:febd:e96e])
        by smtp.gmail.com with ESMTPSA id d8sm10808738wrv.20.2021.09.18.10.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Sep 2021 10:26:33 -0700 (PDT)
Received: from chuck by debian64.daheim with local (Exim 4.95-RC2)
        (envelope-from <chunkeey@gmail.com>)
        id 1mRe6i-007uub-Hu;
        Sat, 18 Sep 2021 19:26:32 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] net: bgmac-bcma: handle deferred probe error due to mac-address
Date:   Sat, 18 Sep 2021 19:26:32 +0200
Message-Id: <20210918172632.1887059-1-chunkeey@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the inclusion of nvmem into the helper function
of_get_mac_address() by
commit d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
it has been possible to receive a -EPROBE_DEFER return code during boot.
Previously, this resulted in setting a random ethernet address.

This exact issue happened on my Meraki MR32. This is because the nvmem
provider is an EEPROM (at24) which gets instantiated once the module
driver is loaded... which of course happens much later when the
filesystem becomes available.

With this patch, the probe will propagate this error code. The
driver subsystem will reschedule the probe at a later time,
once the nvmem is in place and ready to deliver the requested
mac-address.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/net/ethernet/broadcom/bgmac-bcma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma.c b/drivers/net/ethernet/broadcom/bgmac-bcma.c
index 85fa0ab7201c..9513cfb5ba58 100644
--- a/drivers/net/ethernet/broadcom/bgmac-bcma.c
+++ b/drivers/net/ethernet/broadcom/bgmac-bcma.c
@@ -129,6 +129,8 @@ static int bgmac_probe(struct bcma_device *core)
 	bcma_set_drvdata(core, bgmac);
 
 	err = of_get_mac_address(bgmac->dev->of_node, bgmac->net_dev->dev_addr);
+	if (err == -EPROBE_DEFER)
+		return err;
 
 	/* If no MAC address assigned via device tree, check SPROM */
 	if (err) {
-- 
2.33.0

