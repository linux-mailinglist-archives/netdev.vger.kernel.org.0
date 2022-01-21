Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171B549635F
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381935AbiAUQ5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379407AbiAUQ4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 11:56:48 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC585C06173D;
        Fri, 21 Jan 2022 08:55:17 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id q16-20020a4a3010000000b002dde2463e66so3486305oof.9;
        Fri, 21 Jan 2022 08:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IVOAJ94pJepIbpbSfUfz/TwG9KdmwHk/Cvcx+UDJ5T4=;
        b=pIOKSl0EpHvfWhlFljlxDebl+wxZ1lCxG5dYv20Sp2Zkx6SU2GmaD5OaTmH+Wo2MfF
         6Orxsa9dl/d5YlGtUQn6m1HOLOyIOSAO6qQVimJLB+W9GPbjzEk3FMHa3mjDGT2Truk2
         HsYXLEUl+oAYX+Lhq0g7gMYFELX7rOAWTZ/7Vw+kRPKCGUSe6S1JAJJpTkwSMkulTlDD
         Czl00JsRrGhseMk1qAXTK76Q8Sm099C/heQTp05HF2pjEgsnc7ldOiQAYgikA4F7crlq
         NLqhs+rqc1W0D+hQnJSBgspyxs+2VXk+cyq5GA+2lFsNPL2oXE97+Sz4RS6P9fLxw73R
         4aSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IVOAJ94pJepIbpbSfUfz/TwG9KdmwHk/Cvcx+UDJ5T4=;
        b=qzQ4LB6X/oDw/RZKK9L7FX0tpLwsDHpUxtGYOqEyiNCxJt/cvOP2E+qoiZrJUwAkPq
         OUcYzjqtfM/2be1OqScRzKbaPfFqO90LnusCXYW9i1NA1+XLkZRyDxPu30vYI9drchbh
         doVe2/DG0rxZ4ZPZcsVsP2YnFDXtnSK7k48t249qUxVTKlOeNaVW3Dnm0gBJcvdfnZhp
         iFuvA46JIo6akCw4Em/b5lxJo4OvRek35bvDVIbByDqHSe900QxiHxbjpPtunmmURhAS
         VDfzOOOXXedrLx423w+Xkzz6vGozZC5vgMi6/lKuFlBl1kyVQ9sCXUxtGUzS7+izxMvO
         7ndg==
X-Gm-Message-State: AOAM530y+c6e2XHLH/33b6pMKsu/dv75CnD5+HyriRt7NIt7rX2L31/1
        FN4RzsAcaH8oOAzZb+ekvOYJ/qPGBCE=
X-Google-Smtp-Source: ABdhPJz8GHk+7q5boe5b4Wu0fQHWY4WMc/PaCje5B6GeKDz/SFWL8Lj2dH6TwrxPxJylQDn8286Vrg==
X-Received: by 2002:a4a:d184:: with SMTP id j4mr3108067oor.20.1642784117119;
        Fri, 21 Jan 2022 08:55:17 -0800 (PST)
Received: from thinkpad.localdomain ([2804:14d:5cd1:5d03:cf72:4317:3105:f6e5])
        by smtp.gmail.com with ESMTPSA id y8sm1089271oou.23.2022.01.21.08.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 08:55:16 -0800 (PST)
From:   Luiz Sampaio <sampaio.ime@gmail.com>
To:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Luiz Sampaio <sampaio.ime@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 17/31] net: intersil: changing LED_* from enum led_brightness to actual value
Date:   Fri, 21 Jan 2022 13:54:22 -0300
Message-Id: <20220121165436.30956-18-sampaio.ime@gmail.com>
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
 drivers/net/wireless/intersil/p54/led.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/p54/led.c b/drivers/net/wireless/intersil/p54/led.c
index 4bc77010f9c1..c5966b32416e 100644
--- a/drivers/net/wireless/intersil/p54/led.c
+++ b/drivers/net/wireless/intersil/p54/led.c
@@ -43,7 +43,7 @@ static void p54_update_leds(struct work_struct *work)
 			if (tmp < blink_delay)
 				blink_delay = tmp;
 
-			if (priv->leds[i].led_dev.brightness == LED_OFF)
+			if (priv->leds[i].led_dev.brightness == 0)
 				rerun = true;
 
 			priv->leds[i].toggled =
-- 
2.34.1

