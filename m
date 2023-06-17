Return-Path: <netdev+bounces-11812-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFA0A734805
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 21:25:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AC2228102D
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 19:25:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0816BE47;
	Sun, 18 Jun 2023 19:24:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B361ABE46
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 19:24:09 +0000 (UTC)
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3E5E44;
	Sun, 18 Jun 2023 12:24:08 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-31121494630so3064714f8f.3;
        Sun, 18 Jun 2023 12:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687116247; x=1689708247;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XnGtLq47RSbCF72VtOzJ7Ool5zSf+yqusBBJ8SQYN/s=;
        b=ELkiWwvpH1jFwl2apnbhr0fwC1OCRGr3IjlkQTnIJLS8DM+RHXIrr0AwAzY++7zVve
         TzTYdbVquMiAWxZODc/Kq4W19AcjH8xURSQPuBDaUQ8LQrGjvl3zNdd9XzGzeJM+FKeS
         OJhqoUPydDjD1ADSPl99rumO4knlyv2FJuu//NTfdKlL6aYTDq0QirEE8CzxjX52XPWe
         mIdt09gcgzvv7AlLQMi6Tc9DHolDcePOa5L9IjQZRtqveggD7QDrp9b2SPRUkkN459Qa
         X1lVc2Z0ZbMtJuzX14USS8E2amLsZgpo5qEcBFiomFGF1eCBfBQgeiVye/ZyjIidSi+w
         1RVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687116247; x=1689708247;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XnGtLq47RSbCF72VtOzJ7Ool5zSf+yqusBBJ8SQYN/s=;
        b=dYabA/V1W+JueuJAz2kkWMBhfsNDKEYFgdGBJfb4TwD/q2+gk7pS1QmA+qazPm6qZ7
         IlOTMWRq+BWbwCh4AoLATuW6a+7bzYgH3PqSuqExMpSLNYcyHijMRp9a60Vn+TtKNiR1
         YIIlhJjCpV9sV8zlxEslB0to1qf6yK4t3IokZdHS4zx/mWG8XuH2BG9eBrPkNW+CkfDQ
         2A6Ew9mWqJ+80a0uGBXZwaLJUAZ6bUTvYmTJVBtFgWzb2efJvC6cs92DGhDpvGmjE5Sw
         Rsctk5fp4GxUYGC9Kq8OcV53LA2kP5rCa04CuLtoBn/MbO0+uo0YPAI7hLNYwxjl2mNr
         7DiA==
X-Gm-Message-State: AC+VfDw26sx+59OlhDh3PiX0nxWPQbXAkaSi/PPfbeKiuwKCqJ8W7nK4
	UptCZXIbzUe1pa19TVF1TsM=
X-Google-Smtp-Source: ACHHUZ51THCQLy6aCLWiyC//1BkuPREsIDQqL/T4aF7T6yL8yoG2LRrlknyRzAL448mwIytIJRgmGw==
X-Received: by 2002:a5d:4c49:0:b0:307:9702:dfc8 with SMTP id n9-20020a5d4c49000000b003079702dfc8mr6642797wrt.48.1687116246447;
        Sun, 18 Jun 2023 12:24:06 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id h12-20020adffd4c000000b0031130b9b173sm4065871wrs.34.2023.06.18.12.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jun 2023 12:24:05 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Yang Li <yang.lee@linux.alibaba.com>,
	linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [net-next PATCH v4 3/3] leds: trigger: netdev: expose hw_control status via sysfs
Date: Sat, 17 Jun 2023 13:53:55 +0200
Message-Id: <20230617115355.22868-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230617115355.22868-1-ansuelsmth@gmail.com>
References: <20230617115355.22868-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_24_48,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Expose hw_control status via sysfs for the netdev trigger to give
userspace better understanding of the current state of the trigger and
the LED.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 90b682d49998..a550a1895642 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -406,6 +406,16 @@ static ssize_t interval_store(struct device *dev,
 
 static DEVICE_ATTR_RW(interval);
 
+static ssize_t hw_control_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", trigger_data->hw_control);
+}
+
+static DEVICE_ATTR_RO(hw_control);
+
 static struct attribute *netdev_trig_attrs[] = {
 	&dev_attr_device_name.attr,
 	&dev_attr_link.attr,
@@ -417,6 +427,7 @@ static struct attribute *netdev_trig_attrs[] = {
 	&dev_attr_rx.attr,
 	&dev_attr_tx.attr,
 	&dev_attr_interval.attr,
+	&dev_attr_hw_control.attr,
 	NULL
 };
 ATTRIBUTE_GROUPS(netdev_trig);
-- 
2.40.1


