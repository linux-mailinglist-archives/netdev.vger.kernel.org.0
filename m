Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC34E488C42
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 21:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236914AbiAIUYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 15:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236912AbiAIUYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 15:24:22 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F9FC06173F;
        Sun,  9 Jan 2022 12:24:21 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id x18-20020a7bc212000000b00347cc83ec07so3763930wmi.4;
        Sun, 09 Jan 2022 12:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3g9xJZUKTdObdxenWeNH8Dlatjv9+QI3Rg198Ffa9ic=;
        b=YaRFtncdj1ROshARCNA9kzbe3I+VsIZ4ciKRGoSzHZZtBKG1DVfOoDwFghnZU3B37w
         6GGYOEDpWilBUD0rFo2qv3ozAIB3x8FAQF6gwwpnqEwhIL3GSaLgbZ4Gdv7ribh6R5h7
         QuzBsROFxqRO0a8gSVKX/wLDHTKAEmvfukIrOjCeMqip0wp2V1H7TCBrxsDiNfVKKPT+
         Sa2TiLxib6EBHCX7/GNUdq2yrPXcHagCwXQ14hFCXIRE9r8NRSVEEeamJkWq1x7kVKdp
         eSw+Y4RIh6bcuCl4AN301/bZkbtSDQVmEsdJ1BQK/IjvMdnuIOuKRuZPYIQUKudLa5TU
         JFsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3g9xJZUKTdObdxenWeNH8Dlatjv9+QI3Rg198Ffa9ic=;
        b=3ykDPGuXgwjebvLvmjEuIGMxW/rQ4FYJQD1xChuegcs+NXY/89PHBCFGBG9oF4xGkx
         Itewo5CbX/Gfdrzz/8E0YfrA9a9pp5b5rR4ZZQB+iO4GBuxCy9RtFr6OQpOBUBfPl+4z
         IdQh/b2I2L5RWL2rZ+IMWiWERmCQ0uzbaLZAbqWk7SuM53s9x83iygxUYtyCgEejamZ3
         zr21Yq/kAylJRPHJa7tHrl1GZrIKGh7tLjFCQ01e2nYEdV+j8JZHQ6zIz1RHzHMyTrOa
         2EzV126TVamnuRGPAYhk+B+VDqCQ7r8lzgIPTUju1GMeJ0wanefHuJ7zyweJchFbc4Kc
         996w==
X-Gm-Message-State: AOAM532jO3qBzrUY+ySltnMYoSZh2iTq91Wq2EH0QVj15sBeZQ6kCGuz
        VRlXfa7cY58ShiePwcuzOBk=
X-Google-Smtp-Source: ABdhPJzRufDB91BfN4hRrQjwHhuExdQzU5ripFMbBfk93hKD1KaWEwMv54woD7BaBc4boJbc86KUOA==
X-Received: by 2002:a7b:c745:: with SMTP id w5mr19538596wmk.96.1641759860152;
        Sun, 09 Jan 2022 12:24:20 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id b13sm4999052wrf.64.2022.01.09.12.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 12:24:19 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nfc: pn544: make array rset_cmd static const
Date:   Sun,  9 Jan 2022 20:24:18 +0000
Message-Id: <20220109202418.50641-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't populate the read-only array rset_cmd on the stack but
instead it static const. Also makes the object code a little smaller.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/nfc/pn544/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 37d26f01986b..62a0f1a010cb 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -188,7 +188,7 @@ do {								\
 static void pn544_hci_i2c_platform_init(struct pn544_i2c_phy *phy)
 {
 	int polarity, retry, ret;
-	char rset_cmd[] = { 0x05, 0xF9, 0x04, 0x00, 0xC3, 0xE5 };
+	static const char rset_cmd[] = { 0x05, 0xF9, 0x04, 0x00, 0xC3, 0xE5 };
 	int count = sizeof(rset_cmd);
 
 	nfc_info(&phy->i2c_dev->dev, "Detecting nfc_en polarity\n");
-- 
2.32.0

