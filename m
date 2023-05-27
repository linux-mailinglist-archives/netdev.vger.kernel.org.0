Return-Path: <netdev+bounces-5879-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 801B0713472
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 13:30:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 189F3281839
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 11:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 282D811C97;
	Sat, 27 May 2023 11:29:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCD3F9D6
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 11:29:25 +0000 (UTC)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA02EC;
	Sat, 27 May 2023 04:29:21 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f6e13940daso17602775e9.0;
        Sat, 27 May 2023 04:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685186959; x=1687778959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v7RZChTfO9Ux9viKPzKi7S1xLwMfKhuE6t9va88Kj50=;
        b=iN6MZBh3bwnGbc/rVTFMLjWGBVZYD40/7LBWCiGdf3EgrxXSR0FXg7N+P3V3UmgXXU
         XtBnf4Gb+DN/QlYPBwdvMZPb3SFpMJEjriX3ERsRHUpc1XzwFWMdRWEcgNsN/xWQcGBx
         x+xQtiR4FvmzXm7yvhOPbr8ZiVF47kJdFfVqQ7lGtOvQGOl95BpBWVMd51o3o61d8/2Q
         BWM42jj7IZFxWK++cx53Fm2KR9Y3Q7vC1VmcsEYRkZmy9tAkuWfj9UPoGZAg/F5srzkY
         rYic2cUHW+utChLenD7t5WMewxGXigZLWHGD0lvQocIsPV8Ypl0bBdpPbEn/9MWLvg+l
         hAlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685186959; x=1687778959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v7RZChTfO9Ux9viKPzKi7S1xLwMfKhuE6t9va88Kj50=;
        b=fvuNh5O4myFSadwA7N8eMWspKgdQbvwWmHLwm5IzfqoeRq3US8Yo9AYdF98tyP3q2y
         F89+JiV1qwI2NhFLPoM+6vcVTpdKF36KEyEujIMBigOiyHVEExNhpW0j5bYB+/Nkgss/
         Squs8ILzU5CNeth2hnrvPbe1MIpxOicU2vcYPl5LBvJueD3xZQ6D8IAcqBvzzUx8TNA6
         Iin+KqCkHDnSEmSCO9MYherkmp/7aK3rT4F+tBvoWVd2ULivQd/lWZlAiaDqAOEM+F4H
         +mBCifkAhxf0dFKlBu+mKLzioAHy5qH3zRClQEH3vdxEVuC4KSRMsWx5APf8nh/GkkO4
         /csg==
X-Gm-Message-State: AC+VfDzDul8lnfcWCIxOYxNaJyZSbPWuKF6rLE6WWgmmCbiNvgfVxVp1
	ta4PRcQHYyaBeIRoIGn26A4=
X-Google-Smtp-Source: ACHHUZ4udMvx+fzP447XANUJFeyP1f8M3T1T0wrGajT8JUCwePayM+xyaPaxx+/8+NnlkjPwXrEPTA==
X-Received: by 2002:a05:600c:ac8:b0:3f4:16bc:bd19 with SMTP id c8-20020a05600c0ac800b003f416bcbd19mr4382139wmr.23.1685186959537;
        Sat, 27 May 2023 04:29:19 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id q13-20020a7bce8d000000b003f43f82001asm11711000wmj.31.2023.05.27.04.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 04:29:19 -0700 (PDT)
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
Subject: [net-next PATCH v3 04/13] leds: trigger: netdev: refactor code setting device name
Date: Sat, 27 May 2023 13:28:45 +0200
Message-Id: <20230527112854.2366-5-ansuelsmth@gmail.com>
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

From: Andrew Lunn <andrew@lunn.ch>

Move the code into a helper, ready for it to be called at
other times. No intended behaviour change.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 29 ++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 305eb543ba84..c93ac3bc85a6 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -104,15 +104,9 @@ static ssize_t device_name_show(struct device *dev,
 	return len;
 }
 
-static ssize_t device_name_store(struct device *dev,
-				 struct device_attribute *attr, const char *buf,
-				 size_t size)
+static int set_device_name(struct led_netdev_data *trigger_data,
+			   const char *name, size_t size)
 {
-	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
-
-	if (size >= IFNAMSIZ)
-		return -EINVAL;
-
 	cancel_delayed_work_sync(&trigger_data->work);
 
 	mutex_lock(&trigger_data->lock);
@@ -122,7 +116,7 @@ static ssize_t device_name_store(struct device *dev,
 		trigger_data->net_dev = NULL;
 	}
 
-	memcpy(trigger_data->device_name, buf, size);
+	memcpy(trigger_data->device_name, name, size);
 	trigger_data->device_name[size] = 0;
 	if (size > 0 && trigger_data->device_name[size - 1] == '\n')
 		trigger_data->device_name[size - 1] = 0;
@@ -140,6 +134,23 @@ static ssize_t device_name_store(struct device *dev,
 	set_baseline_state(trigger_data);
 	mutex_unlock(&trigger_data->lock);
 
+	return 0;
+}
+
+static ssize_t device_name_store(struct device *dev,
+				 struct device_attribute *attr, const char *buf,
+				 size_t size)
+{
+	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
+	int ret;
+
+	if (size >= IFNAMSIZ)
+		return -EINVAL;
+
+	ret = set_device_name(trigger_data, buf, size);
+
+	if (ret < 0)
+		return ret;
 	return size;
 }
 
-- 
2.39.2


