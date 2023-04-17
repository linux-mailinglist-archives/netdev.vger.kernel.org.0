Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D6C6E3F07
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 07:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjDQFgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 01:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjDQFfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 01:35:51 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F943ABF;
        Sun, 16 Apr 2023 22:35:25 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f1728c2a57so6381485e9.0;
        Sun, 16 Apr 2023 22:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681709715; x=1684301715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0e4uRaWAQyHxwieyMxBaO10QAQykFdja3vBvufQ1//o=;
        b=arPrerh03Cfr+LaZMVQvDsbz7h/wiCQbver2WOGJDPYu2OYH9xslfh6nk9/l13jF9t
         y+pIvadhfBf96xTgckvjKvN5vbWZAEO5pSEJiqdLFeUK5asRXCAKH1ZYxIjkijUkbTEd
         wMM+k4ic/peV8rZw3tasamRS2+4CtVFL313fihHwRcf1utRy9G/uJrDkpZ242SRyXccD
         Z8KFlyAyfKREgLIK7+QvxQZWc9YirJycIsGb+fflHYOYsYzAXdl8kJtALtvNvuNYwkim
         UBOMw7ctzY+i4yCOpQfPzDRIQgX7FaD7YTZ2DU+6AqBfyEhkAtb0i1TbInRYf/jxquW6
         /hqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681709715; x=1684301715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0e4uRaWAQyHxwieyMxBaO10QAQykFdja3vBvufQ1//o=;
        b=DzaUoQI+EHqznC/wgzsqp6KbhvMoLuNyLMitVxDYEvu3NrTgTkOiCMy1gjjWz61TAB
         n/46qSDaiTdbYin0EgDZCO1aANXpUBY7g3g005eVsRaTchRCC+K4o+BPFh2gvYD+d6BL
         ls7aa84vk9kHX7JrpPr7KnePWp2GJDw0L2+pR5C1SkepVlzK+un+h29LB7TR6i74yPE3
         I0lgnnI+wUrMrDv8VRkYyu1Ai9PdPb2fdn47sLXnoYanAbxmanhNcdjBiLdnfCzwLg33
         GvUuCTiKa1WbCDaLsnuEKZE91ItJjTUEeccFLxXwjShOIZRZGGnezzvaiaPsYWd9qH5N
         5qOw==
X-Gm-Message-State: AAQBX9fi7wwFO2i8yvUMhX4u7Gz2sslrCy432cwiNQDUEDuxwOlZdD2e
        VrB+vdOQxZ0M75WQKevYraY=
X-Google-Smtp-Source: AKy350Y/y+yBXJ1SNMuib1E7sPl+isK7sikQM6OepDGZ96gSue8wKTd635aSI5dWwZctAzUWYWivuw==
X-Received: by 2002:a5d:6e86:0:b0:2ef:b1ea:eae0 with SMTP id k6-20020a5d6e86000000b002efb1eaeae0mr3781527wrz.71.1681709715104;
        Sun, 16 Apr 2023 22:35:15 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id w16-20020a5d6810000000b002e5ff05765esm9632493wru.73.2023.04.16.22.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 22:35:14 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     f.fainelli@gmail.com, jonas.gorski@gmail.com, nbd@nbd.name,
        toke@toke.dk, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        chunkeey@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH v2 2/2] ath9k: of_init: add endian check
Date:   Mon, 17 Apr 2023 07:35:09 +0200
Message-Id: <20230417053509.4808-3-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230417053509.4808-1-noltari@gmail.com>
References: <20230417053509.4808-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

BCM63xx (Big Endian MIPS) devices store the calibration data in MTD
partitions but it needs to be swapped in order to work, otherwise it fails:
ath9k 0000:00:01.0: enabling device (0000 -> 0002)
ath: phy0: Ignoring endianness difference in EEPROM magic bytes.
ath: phy0: Bad EEPROM VER 0x0001 or REV 0x00e0
ath: phy0: Unable to initialize hardware; initialization status: -22
ath9k 0000:00:01.0: Failed to initialize device
ath9k: probe of 0000:00:01.0 failed with error -22

For compatibility with current devices the AH_NO_EEP_SWAP flag will be
activated only when qca,endian-check isn't present in the device tree.
This is because some devices have the magic values swapped but not the actual
EEPROM data, so activating the flag for those devices will break them.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 4f00400c7ffb..abde953aec61 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -615,7 +615,6 @@ static int ath9k_nvmem_request_eeprom(struct ath_softc *sc)
 
 	ah->nvmem_blob_len = len;
 	ah->ah_flags &= ~AH_USE_EEPROM;
-	ah->ah_flags |= AH_NO_EEP_SWAP;
 
 	return 0;
 }
@@ -688,9 +687,11 @@ static int ath9k_of_init(struct ath_softc *sc)
 			return ret;
 
 		ah->ah_flags &= ~AH_USE_EEPROM;
-		ah->ah_flags |= AH_NO_EEP_SWAP;
 	}
 
+	if (!of_property_read_bool(np, "qca,endian-check"))
+		ah->ah_flags |= AH_NO_EEP_SWAP;
+
 	of_get_mac_address(np, common->macaddr);
 
 	return 0;
-- 
2.30.2

