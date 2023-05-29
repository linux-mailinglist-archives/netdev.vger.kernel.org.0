Return-Path: <netdev+bounces-6146-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6454C714E83
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 18:36:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96EB2280FDA
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:36:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 270D3D30B;
	Mon, 29 May 2023 16:34:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C82FDDDF
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 16:34:52 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B055B2;
	Mon, 29 May 2023 09:34:50 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f6d3f83d0cso36417315e9.2;
        Mon, 29 May 2023 09:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685378089; x=1687970089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IlQrvGRD4ZHltBpv2SQtNiv0lfrM6U3jabiv2fdlEjA=;
        b=DtHAc0glKUPrO98buFtsgCTz1Ie8aLDtveoXlqHpy4/v/pzDmV6NkXceOfvN2VkKJO
         Mzlc6eKDDreLC9/+0Klduzktr30qbdTdYjpLA6b/rpcTluYntiEhyO0pX8otblRuioJK
         e39c9hD4rORHrGO4IhsWDGn4p1+bGbOzmtiBfxnuywI9eUiZkKO80S5gleEdSnt+qmED
         Xd/o8iF/f8TgMtkhdnG/s5eFksnFMGOPHBlG9y3SEdgP9Kfug33ktmKDKIGN+0zhowYZ
         E1g2czs++O2e+XgfIG6G1bFZ+QZpOvRgZ/9oEC0pdwJxPftpAIIaR6KRzJujsufgu0bX
         DyIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685378089; x=1687970089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IlQrvGRD4ZHltBpv2SQtNiv0lfrM6U3jabiv2fdlEjA=;
        b=MWzqKmbOiWFBaA14h1wNDITl/ZiMp+082HMNCEU7rCnHbxjKvo8uvDdAU8ZkcOuFhF
         BBmTieuoLAuPibM8sWCqeO5jrpRxoNOstSrIS8ijYR+PwcZPXG2IU3XLtn2t+J9LARzj
         +ian8QOnHkannScAtSoPMOSdp9Dl6/Kxs27XEOY0kflqJUR0maz3k7Dm3OX6FVDnEKdM
         QTrz7FS+pAhhP0ad+mUXvRJcRu4G0vw2/7fUFMzKNSLzmC+T4Jp5uZxly9LGDVVfYvzF
         ZzGtCdnYY4tzu8FX5BZypp4eo5UJc3iCqPy8ZPBsvMfdneyi0VYc2mKlebj3wHl9DBZ4
         IVvw==
X-Gm-Message-State: AC+VfDwRawo7OFOA+mjjrs9SPHYaNvsSCoao2eiBR/jIrszuMRfWHqTT
	NvDNl5OinFpCoKCBWqGHeUc=
X-Google-Smtp-Source: ACHHUZ641zKVt+dvxchLwmAXeTl3o99OfbAJcCRE4+hN+GQzUQzNx2B0Z3gWlYjxdlQlll5hmeYOkA==
X-Received: by 2002:a05:600c:d5:b0:3f5:ce2:9c82 with SMTP id u21-20020a05600c00d500b003f50ce29c82mr10531066wmm.32.1685378088594;
        Mon, 29 May 2023 09:34:48 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id h14-20020a5d6e0e000000b002ff2c39d072sm417513wrz.104.2023.05.29.09.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 09:34:48 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	linux-leds@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [net-next PATCH v4 06/13] leds: trigger: netdev: add basic check for hw control support
Date: Mon, 29 May 2023 18:32:36 +0200
Message-Id: <20230529163243.9555-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230529163243.9555-1-ansuelsmth@gmail.com>
References: <20230529163243.9555-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add basic check for hw control support. Check if the required API are
defined and check if the defined trigger supported in hw control for the
LED driver match netdev.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/leds/trigger/ledtrig-netdev.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index e1f3cedd5d57..2101cbbda707 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -92,8 +92,22 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 	}
 }
 
+static bool supports_hw_control(struct led_classdev *led_cdev)
+{
+	if (!led_cdev->hw_control_get || !led_cdev->hw_control_set ||
+	    !led_cdev->hw_control_is_supported)
+		return false;
+
+	return !strcmp(led_cdev->hw_control_trigger, led_cdev->trigger->name);
+}
+
 static bool can_hw_control(struct led_netdev_data *trigger_data)
 {
+	struct led_classdev *led_cdev = trigger_data->led_cdev;
+
+	if (!supports_hw_control(led_cdev))
+		return false;
+
 	return false;
 }
 
-- 
2.39.2


