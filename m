Return-Path: <netdev+bounces-12080-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DBD5735EBA
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 22:48:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CEBD41C20A17
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 20:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD91514AB6;
	Mon, 19 Jun 2023 20:47:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B299514AB5
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 20:47:27 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D57F1A3;
	Mon, 19 Jun 2023 13:47:24 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-31272fcedf6so1056097f8f.2;
        Mon, 19 Jun 2023 13:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687207643; x=1689799643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ccjdX+IZqQAhgyk6xPOcJY+ngvdDgr2cEw+3he/cnkM=;
        b=jHYqsvXA6NiTfeCcqKVcOiRIKTt+m2BZuSNb260ylv7/IACNKLfLYiqzemybP73R7r
         E/cN0oKUQtbleX04sIgx0XWdlndkVtGIgOtq1JGz3fBggnfoZzhCzPobJVyvq78WBhi3
         Jv5wWJaHtzIVPu98JdDMdLI7YpEwnmQ2fb+TzOU/533Ypi+Kh40R9a0BcOEuH+k/tyzk
         lKdHnqhkGNit4/GxpXJgLxQ9Bqh3oIY5iLMPn0DUmvdd4c4EtqssVw0tDoDaIGZHumqe
         LJvTUul00cc/6PGucXfyjJtbtveK2sex0Z8cZsyyD9IROs71j3KltUJxgSdzBn22EkKs
         jr/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687207643; x=1689799643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ccjdX+IZqQAhgyk6xPOcJY+ngvdDgr2cEw+3he/cnkM=;
        b=iQ4iNkmWuXmo/LfzyjT2dcexZcd2rNabGJAFYaVzqMYi1cEGT0pXJHw1pfvRG0/LCq
         k98plSkvUiFIrGOs7W4+H+K6gN2xPOP7xIJjzkzqVJ8G5EQZvzeNhAyEM+MGTm0BasRF
         HN1Qnhh8/THdGO5b+R5sLgotIpdndqdyc1pPZ5tsDDNx/MYRY5YuMJPm1ELC+w4RyJM1
         FUt/2+iR8k0YYv3e5UnFvJXRNU3G3g/vDWYb70K1Juvmw7hw+C1HxGAHThFI8FGDld8q
         HdDfD0icU1zsQx6suYs2bUIl0EkOutT7a7H98O8VouhWACW7P/smfn3nG1bCAc5JkkFS
         rvYg==
X-Gm-Message-State: AC+VfDwdv37asNIHY5OMtI/GguNBczFe0hEcD4udRqvE7hIAp5qKx3ur
	1x8sxJZKasgYLoU1EYStvWg=
X-Google-Smtp-Source: ACHHUZ64PxnAcEzdZjOfMT3Y8G3sRivHC3/PtHnSoZZboPqURSJbMXFV1kZVfApV5qyJ3bG0U8iyuQ==
X-Received: by 2002:a5d:6292:0:b0:30f:cf67:564e with SMTP id k18-20020a5d6292000000b0030fcf67564emr7527330wru.62.1687207642690;
        Mon, 19 Jun 2023 13:47:22 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id k10-20020adff5ca000000b0030ae87bd3e3sm434043wrp.18.2023.06.19.13.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 13:47:22 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Christian Marangi <ansuelsmth@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [net-next PATCH v5 3/3] leds: trigger: netdev: expose hw_control status via sysfs
Date: Mon, 19 Jun 2023 22:47:00 +0200
Message-Id: <20230619204700.6665-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230619204700.6665-1-ansuelsmth@gmail.com>
References: <20230619204700.6665-1-ansuelsmth@gmail.com>
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

Expose hw_control status via sysfs for the netdev trigger to give
userspace better understanding of the current state of the trigger and
the LED.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/leds/trigger/ledtrig-netdev.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 2c1c9e95860e..32b66703068a 100644
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


