Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DBB496340
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379600AbiAUQ46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379114AbiAUQ4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 11:56:19 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC483C06175B;
        Fri, 21 Jan 2022 08:55:10 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id bx18so14350749oib.7;
        Fri, 21 Jan 2022 08:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LECfU6cLXmTWAFEkOmILc0YJMNkX9LftVPNv4hejlLw=;
        b=X1kgsEpBLZffAa6n2Zpdp3hS5eepWNOv7/NvBFCUrLPcDJE7Bb4iovVZguI/81N2Va
         T9Izj9GCrpLlmiY3jAP7FHD32lbBBoDVYU9aFaII3Ci3mdxhCfgw18C5xGs6nhGcF1jA
         OB9NWxVkn+zp78jd4frB+zrngn5WDc4SokFNup+Uv+Cl+NtmNhMjTjTKDrLiztSE5swy
         kGcXylufL7Yg/0WuuFfpyI2wuIj6KLRC8oB27XMpp845Ykq7ovO8++bP0Mzlv8pSuFP6
         QbpB8wwGNDPXycyEZV6d7lpuxftlO15tpuQ1t6nz/b2l4Yz02AUn4DgS7fqHEA6g9urH
         yYPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LECfU6cLXmTWAFEkOmILc0YJMNkX9LftVPNv4hejlLw=;
        b=Xwxs0LT0kKh0cvNKWzDoiRLlpLt2MbZUY77hFn/bVQ0IEQ3dldS6TknoPDnZrQbxsR
         31ezKaA8CyirypwkfqJnT0Vz1PaNnpMQNuANEx4aun3SaQOVFDUxdXSBAPPKuT1iOslg
         xhbnN8yb2+erFuDsens1NHqIjIhTEbEqIMoJ9fCD8TWstkYZiVvjkC02uiJL1AVpb6GZ
         Z63gWclAp3Ueo2raRxl7DR+KWJx1VjoKgk9A1qIRgcucmuJeJ7BB+EwM25TVhjxaV20e
         MkLJHN14MZVZgA+eSuwmynLbWwQDr020h5Feuccku+JEqrAZKj3GoxCmjukjH9svM+ul
         Q4Fg==
X-Gm-Message-State: AOAM532xs3Sb4Xz3Q5HWxC5kfESFyGOqHdtW6yHgFxu+wHxNP0D4fZb8
        YFPxWWnybFkI7imPjb+ZZvg=
X-Google-Smtp-Source: ABdhPJwnMTm/HRYkycV0dhiJ7DZNarIXvBbprClF5tkRMIbPP/TqgF6weELN4MPUKaK2ZtRzAyN7JQ==
X-Received: by 2002:a05:6808:f13:: with SMTP id m19mr1242656oiw.123.1642784109992;
        Fri, 21 Jan 2022 08:55:09 -0800 (PST)
Received: from thinkpad.localdomain ([2804:14d:5cd1:5d03:cf72:4317:3105:f6e5])
        by smtp.gmail.com with ESMTPSA id y8sm1089271oou.23.2022.01.21.08.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 08:55:09 -0800 (PST)
From:   Luiz Sampaio <sampaio.ime@gmail.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Luiz Sampaio <sampaio.ime@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 15/31] net: wireless: atmel: changing LED_* from enum led_brightness to actual value
Date:   Fri, 21 Jan 2022 13:54:20 -0300
Message-Id: <20220121165436.30956-16-sampaio.ime@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220121165436.30956-1-sampaio.ime@gmail.com>
References: <20220121165436.30956-1-sampaio.ime@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The enum led_brightness, which contains the declaration of LED_OFF,
LED_ON, LED_HALF and LED_FULL is obsolete, as the led class now supports
max_brightness.
---
 drivers/net/wireless/atmel/at76c50x-usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
index 7582761c61e2..3847c59b9672 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -523,10 +523,10 @@ static void at76_ledtrig_tx_timerfunc(struct timer_list *unused)
 
 	if (tx_lastactivity != tx_activity) {
 		tx_lastactivity = tx_activity;
-		led_trigger_event(ledtrig_tx, LED_FULL);
+		led_trigger_event(ledtrig_tx, 255);
 		mod_timer(&ledtrig_tx_timer, jiffies + HZ / 4);
 	} else
-		led_trigger_event(ledtrig_tx, LED_OFF);
+		led_trigger_event(ledtrig_tx, 0);
 }
 
 static void at76_ledtrig_tx_activity(void)
-- 
2.34.1

