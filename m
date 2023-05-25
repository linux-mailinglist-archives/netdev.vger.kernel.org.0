Return-Path: <netdev+bounces-5360-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 841DA710EDB
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:57:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EFBF2815C1
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:57:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A512F1C773;
	Thu, 25 May 2023 14:55:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0E619BC1
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:55:08 +0000 (UTC)
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C37F1B6;
	Thu, 25 May 2023 07:55:03 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-309382efe13so1560142f8f.2;
        Thu, 25 May 2023 07:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685026501; x=1687618501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bzjSHLcSLKuyYbnB5oKrxVcxoSmgJOggg+ZfYlmNaGM=;
        b=lPP6ejuyGdUqbdV05DpRufEgFHgzuJGeS64NKLHMuExx8FvbX8ruFT3fTkY41QZeby
         KkXRgU0ApGNMzqxQRCmArJyv4/Mun+oDG6we+ubfPm1p0Tkk27KMjxpQuIFxWpKBZpvn
         L5b7YcVy0FAreEqDA0YJ2Od5NrK3v4DNmGu9pHOfxovHja5WiQxvspAruwrGk+l5Tx/s
         VfT8JQLTrRmicfLSog13cloS+8x3rTx1BgG+m1ohLP7v/+n4yno8zv0029uoAJzunmOT
         L9CCxNZm4ogSyd0i0l0/yaMHHDSTrgTYpVFFs6MnXF4lRhh4OsGmWV/D8knbsHzjj/UN
         iHog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685026501; x=1687618501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bzjSHLcSLKuyYbnB5oKrxVcxoSmgJOggg+ZfYlmNaGM=;
        b=CFfvkST6F1Eno5aKsnPfPIHOXob7b9JrYUlEDnLlIYeOzKO3EE+xDcWEhFreZnF4SB
         SO+J/m76zDpy9uYIwyT/09flJ2quw5wpmVpV6+gl8Lu7m2B7Str9NEatL+Oqqcy/VSUF
         pywC0UMt/qRfcIgUpP4gy59DyS8cetOKMAu4moJpTdpKT7FjCeNV+cJraZYxmUw0ksqJ
         BeKlCVm3yCoJa/Qn99yzOgi6wu770rBnlVHRY5ORWT5n8Z3cc9JEySaAHGReARBW4EFL
         nAImYkLCs18OH7kNstwGLtZAjLE8KUNsGZ4SxSC6YobSSOiX5x8CkpTYfl2iPVrANUp+
         r0qg==
X-Gm-Message-State: AC+VfDyX43eq8kXicpA63V36S2efVJteURjQKC6jR0guF3xNC8vx93RO
	+QJGbuo2dJgyAHh9Bob2RhxLHq0Y5H4=
X-Google-Smtp-Source: ACHHUZ5C8g7q++jNTKBD8izlwn3KaW2UultwaDuld2Mh5yH1lo+swsqkySFSUo38JGoGOI/+EddZkQ==
X-Received: by 2002:a5d:5607:0:b0:309:4289:91ca with SMTP id l7-20020a5d5607000000b00309428991camr2621768wrv.61.1685026500942;
        Thu, 25 May 2023 07:55:00 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id t11-20020a5d49cb000000b0030732d6e104sm2048043wrs.105.2023.05.25.07.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 07:55:00 -0700 (PDT)
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
Subject: [net-next PATCH v2 09/13] leds: trigger: netdev: validate configured netdev
Date: Thu, 25 May 2023 16:53:57 +0200
Message-Id: <20230525145401.27007-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230525145401.27007-1-ansuelsmth@gmail.com>
References: <20230525145401.27007-1-ansuelsmth@gmail.com>
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

From: Andrew Lunn <andrew@lunn.ch>

The netdev which the LED should blink for is configurable in
/sys/class/led/foo/device_name. Ensure when offloading that the
configured netdev is the same as the netdev the LED is associated
with. If it is not, only perform software blinking.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 8d6381415208..5b59441fc415 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -108,6 +108,24 @@ static bool supports_hw_control(struct led_classdev *led_cdev)
 	return !strcmp(led_cdev->hw_control_trigger, led_cdev->trigger->name);
 }
 
+/*
+ * Validate the configured netdev is the same as the one associated with
+ * the LED driver in hw control.
+ */
+static bool validate_net_dev(struct led_classdev *led_cdev,
+			     struct net_device *net_dev)
+{
+	struct device *dev = led_cdev->hw_control_get_device(led_cdev);
+	struct net_device *ndev;
+
+	if (!dev)
+		return false;
+
+	ndev = to_net_dev(dev);
+
+	return ndev == net_dev;
+}
+
 static bool can_hw_control(struct led_netdev_data *trigger_data)
 {
 	unsigned int interval = atomic_read(&trigger_data->interval);
@@ -129,9 +147,11 @@ static bool can_hw_control(struct led_netdev_data *trigger_data)
 	/*
 	 * net_dev must be set with hw control, otherwise no
 	 * blinking can be happening and there is nothing to
-	 * offloaded.
+	 * offloaded. Additionally, for hw control to be
+	 * valid, the configured netdev must be the same as
+	 * netdev associated to the LED.
 	 */
-	if (!trigger_data->net_dev)
+	if (!validate_net_dev(led_cdev, trigger_data->net_dev))
 		return false;
 
 	/* Check if the requested mode is supported */
-- 
2.39.2


