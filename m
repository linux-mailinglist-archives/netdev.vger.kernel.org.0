Return-Path: <netdev+bounces-5881-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A55BD713474
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 13:31:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60858281898
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 11:31:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B348911CAC;
	Sat, 27 May 2023 11:29:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A913511CA1
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 11:29:26 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4540C124;
	Sat, 27 May 2023 04:29:23 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f6e4554453so11240475e9.3;
        Sat, 27 May 2023 04:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685186962; x=1687778962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9HiOL7lEFVgjMaEJrcmVlJpY1uQMDGELzriKpZXWbcM=;
        b=aOrW7o/W6hFBEZhqXwl4wHAvgp9au7WiULHRilZP3Q2xTYOZXVCsfnJtUSMDULCdhZ
         wS0bl+5AwKCS3Ij4UhZHZr2r5bWkFsq5j6WHJtOyJ3p4QKEHdqFXaxmPo+O6tycDvf9G
         7V/6pSpzPBgJOc8Z3zpvAWm5iQ40CrorrnwA/LvI8bFsBKx/u0jPL9xv2pIAGWizjXX2
         VQppOBgLTzwH3ScwWOvvFFR24VPQtLYAls76cUloxJCYlUGdQ7hl9gAs/wzQH031LwtO
         I4mYQ8e9buVjU1DD0lUzaGHZtz6ZZtn0HuxTZCdOvp28KkuhORcD2HkfuTvWFWf6iYZK
         HaXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685186962; x=1687778962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9HiOL7lEFVgjMaEJrcmVlJpY1uQMDGELzriKpZXWbcM=;
        b=Y8PFSfYPH22KeOaNfqHFTDMnCNrV5owbBHk8RhBLZ/GDikeOwiHtayDiwscglKnwmv
         vjuIOTvd30yajHPAALxk37wclTLO5p3zg2nvIxqYm0H74P6/FZy6ErM08/PuiPijXhS1
         yO54lf3UUKB+TIu+hXKMzoCCTvmS8AhT2oNtfHhZDVyJLi4LzDqunFw0X0UIFA8NdtyO
         aZ9jbx6ajEKGh8b3ge11XzsuPiz9fYYmLJj84a77TmPERiJM7UBANrfSVhvZT31ps55C
         KIndHhZBH+FjrQ72T8c6/vCKdO5rf1zvskM5Uo5nz1NIJMuZqIscwyrPfID4YLAQb7CE
         ihsA==
X-Gm-Message-State: AC+VfDwASpHCl/vSsllf1McAVX/Riufh9Zr6ImeZadY8RDZcIJtUuIGt
	Z9Q60udpQkdXe4S81sC9W2w=
X-Google-Smtp-Source: ACHHUZ43haHLT1VQPLx8RjLuJVgl+/TPgdU/L/CT5L2PRDJ5Aj8MhWYqBbx1RqbtoGUVysE4syfKxg==
X-Received: by 2002:a05:600c:d2:b0:3f6:536:a4b2 with SMTP id u18-20020a05600c00d200b003f60536a4b2mr3400538wmm.27.1685186961649;
        Sat, 27 May 2023 04:29:21 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id q13-20020a7bce8d000000b003f43f82001asm11711000wmj.31.2023.05.27.04.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 04:29:21 -0700 (PDT)
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
Subject: [net-next PATCH v3 06/13] leds: trigger: netdev: add basic check for hw control support
Date: Sat, 27 May 2023 13:28:47 +0200
Message-Id: <20230527112854.2366-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230527112854.2366-1-ansuelsmth@gmail.com>
References: <20230527112854.2366-1-ansuelsmth@gmail.com>
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


