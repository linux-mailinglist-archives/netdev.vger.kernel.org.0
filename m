Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70DFC65713C
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbiL0XdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232616AbiL0XcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:32:03 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC5CE0AF;
        Tue, 27 Dec 2022 15:30:52 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id gh17so35004617ejb.6;
        Tue, 27 Dec 2022 15:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gsQ0bP6BbS+zASV2taW+Oh7StcznrMy09XYCXA0KW+c=;
        b=NvGtg2ABeuuiTlqb5FE0HvyVQ0jFplGTmISwJyB2VnsbuhiblM6W0RIICSKs7m74Cx
         SYl0hzKURLDfTg0yekw3VCxY8TbWw4E3KhfTgHeIBGORJzTbqgPe6aMSgMRAa/2EB0M3
         jT4LJL3dINLOJeSQAWa+TBiJI9YrBJASmHxD3pkbFPFVzNQ6NgUM9MI6uO3pX0TOFnG0
         T7QukZMuX4NL+HZxfJgqfeuC+1pGWiUqY/QP3s3hBeWlYIiqm6ttWad9ndPIL51AMuYl
         WxTVj5njQ4NFWyeuqwS1ZZvUpqk5CcTWuGkvTPCGkBQVHJH7bVh6yU0e9O34i9C/BOK8
         CVYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gsQ0bP6BbS+zASV2taW+Oh7StcznrMy09XYCXA0KW+c=;
        b=0KbfEtg8SyxKDU3Q/3MDYViYHMEGdHXmShvE3KwZi9anuc6Je5k5T26o9vs52hkmgN
         iIh3EYs23WBzGu1NodYdak+HVFzdHJbmfPctm9bszMI3kOLPrl4L5qXFuOPWFxlMuLkq
         eBebU8IanMufT3hZbFODt9oJQQeJDdKK5Ce0D9eUe8r3K1t39Ti9loHGsRXo9T+QEhWT
         10CUfNYqNTyHKyMu6wYIt2iNbEN3vmN6suKC9P5d+YqI8Znz2DWiLcCCyPv5CR8S2ubn
         gWs4r9jGVXlnoEeYGBfsxRJ+u2GghcbibDtzbHnBkBNHjh9IThCywKnjZyZouMcuZOAJ
         rUqA==
X-Gm-Message-State: AFqh2kpBL/KfX3PPwNo1M6w1DnoZ/aqA5XRLneEORjMXwqAP5LD7YwC/
        rr5RHr+OcLCqCJxub3cw7NpNkPBHFK8=
X-Google-Smtp-Source: AMrXdXsMcWgwvN1YMuKb2k+2XZqBjjIy7sgzVZekfewiRxr8Kydi1JdIAinH342GnFDQZYHMPn/ntg==
X-Received: by 2002:a17:907:93c5:b0:7c0:f118:624b with SMTP id cp5-20020a17090793c500b007c0f118624bmr17580205ejc.44.1672183850737;
        Tue, 27 Dec 2022 15:30:50 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c4cf-d900-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c4cf:d900::e63])
        by smtp.googlemail.com with ESMTPSA id r7-20020aa7c147000000b0046cbcc86bdesm6489978edp.7.2022.12.27.15.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:30:50 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Morgan <macroalpha82@gmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [RFC PATCH v1 16/19] rtw88: ps: Increase LEAVE_LPS_TRY_CNT for SDIO based chipsets
Date:   Wed, 28 Dec 2022 00:30:17 +0100
Message-Id: <20221227233020.284266-17-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@gmail.com>

Increase LEAVE_LPS_TRY_CNT to give SDIO based chipsets more time to
enter or leave deep sleep mode. SDIO communication is often slower than
PCIe transfers so extra time is needed.

Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/ps.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/ps.h b/drivers/net/wireless/realtek/rtw88/ps.h
index c194386f6db5..b79bef32b169 100644
--- a/drivers/net/wireless/realtek/rtw88/ps.h
+++ b/drivers/net/wireless/realtek/rtw88/ps.h
@@ -12,7 +12,7 @@
 #define POWER_TX_WAKE		BIT(1)
 #define POWER_MODE_LCLK		BIT(0)
 
-#define LEAVE_LPS_TRY_CNT	5
+#define LEAVE_LPS_TRY_CNT	10
 #define LEAVE_LPS_TIMEOUT	msecs_to_jiffies(100)
 
 int rtw_enter_ips(struct rtw_dev *rtwdev);
-- 
2.39.0

