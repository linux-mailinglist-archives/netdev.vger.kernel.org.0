Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F2F50C985
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 13:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235185AbiDWLQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 07:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiDWLQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 07:16:18 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845CF1A5;
        Sat, 23 Apr 2022 04:13:21 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id x33so18444923lfu.1;
        Sat, 23 Apr 2022 04:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s+t0FFDMv9pg+lukRM7eI+xPhkEdZvz2+ETQzxyAoMQ=;
        b=M4dbVJyZOgaDAaTvEE5t0QwbZz4VYtOwXd6zhq5kS6BK8HKwauujJ+ZZMMyytXCdjx
         TK6iYx0D4oHidZ3JKG8SL+8CExutHPJUylsxed4c9o0U/6fb1Y4SlVFB4/q7qkaLDEEN
         KuSTcyRcZpj7XX5e25Mtl61QDtydvYdeSTF4Kpm/INOVNPFe3VTlGtaAHEcmfY8KTCce
         iSlPPdJ5AjYFoPGYIjp5oaJ5LpY1uPKCF5fSA8HL2frYWvXwwlAh8EVR1+kduwn/iHiT
         /l1j4Akmr1RG8GVncS3I0lAcoARd8dKeXToO2/u7vUu1ML9pHAn7cZ4Q33Jxm1umLgUU
         QZng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s+t0FFDMv9pg+lukRM7eI+xPhkEdZvz2+ETQzxyAoMQ=;
        b=on9fkusjdeW/K54YkiAR+BfhozL+UFM1T4BwbxlHjn0OnLFuugPw+DbrTpHMuaikSu
         9Uksom3VSyljBXV8jC3BPJMMID75muajtXc/8cF8pqvoM3RNOs7q1oFF0ZOcSYJU4OV6
         NLs4rvpuVg/1ObjF+TDcCPOiSXnlPgQPEy5m4BcU9PYF7uEP5x95v6vySV+LF8Pv7qbt
         eXE7G59p51T3I1K/Ez5CdqKl4x3ycA5mBX2BX7mJ+i87K8Ix3vlrSwTzYrwvoi2RcEmc
         x3NCrxEY9TQkmePVNsdTsyOYClDb6ubR0gcmJ1JxSoF3wCsdjtzBmgFMiUjRhqu64GAg
         rJ/Q==
X-Gm-Message-State: AOAM5304+BfZBlH32/rYCws0hDCFQlJHyKw2bQnleZe+wN8zs0S/EQ7+
        tzRxc7noxHAN3up3Tyn/R2o=
X-Google-Smtp-Source: ABdhPJxJXXwiU7Mmy3XFJN3fzFZmrTdJ0wCVjBSZjzo5zeUWIuI0GNL8fQqrbEmph8kRVItGUxLt4w==
X-Received: by 2002:a05:6512:3fa0:b0:44a:f66c:8365 with SMTP id x32-20020a0565123fa000b0044af66c8365mr6415183lfa.152.1650712399853;
        Sat, 23 Apr 2022 04:13:19 -0700 (PDT)
Received: from MiWiFi-R4A-srv.. ([86.57.19.212])
        by smtp.gmail.com with ESMTPSA id m5-20020a196145000000b0047015e19b51sm580301lfk.248.2022.04.23.04.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 04:13:19 -0700 (PDT)
From:   Hamid Zamani <hzamani.cs91@gmail.com>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Soeren Moch <smoch@web.de>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hamid Zamani <hzamani.cs91@gmail.com>
Subject: [PATCH] brcmfmac: use ISO3166 country code and 0 rev as fallback on brcmfmac43602 chips
Date:   Sat, 23 Apr 2022 15:42:37 +0430
Message-Id: <20220423111237.60892-1-hzamani.cs91@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This uses ISO3166 country code and 0 rev on brcmfmac43602 chips.
Without this patch 80 MHz width is not selected on 5 GHz channels.

Commit a21bf90e927f ("brcmfmac: use ISO3166 country code and 0 rev as
fallback on some devices") provides a way to specify chips for using the
fallback case.

Before commit 151a7c12c4fc ("Revert "brcmfmac: use ISO3166 country code
and 0 rev as fallback"") brcmfmac43602 devices works correctly and for
this specific case 80 MHz width is selected.

Signed-off-by: Hamid Zamani <hzamani.cs91@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index f0ad1e23f3c8..360b103fe898 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -7481,6 +7481,7 @@ static bool brmcf_use_iso3166_ccode_fallback(struct brcmf_pub *drvr)
 {
 	switch (drvr->bus_if->chip) {
 	case BRCM_CC_4345_CHIP_ID:
+	case BRCM_CC_43602_CHIP_ID:
 		return true;
 	default:
 		return false;
-- 
2.35.1

