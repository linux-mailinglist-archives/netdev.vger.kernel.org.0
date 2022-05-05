Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204C051C182
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380282AbiEEN72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380276AbiEEN7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:59:17 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F071EEDE;
        Thu,  5 May 2022 06:55:37 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id g23so5294141edy.13;
        Thu, 05 May 2022 06:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W4OY/JvmasUugHSn3rUmXaSkS514QXA0AsYyOrhfQQg=;
        b=H8Ao8D+HKPoqzvyk98XDDUx5ZI7tA1FociIFIuzl17MmQWY+/ne9onYEyJ0AYfrm6M
         WBl8sG1lg7rLJT+ffPgm8+ERj97fPvTeSbCsqbV/h6YlsCvpNUU/SH7E4nWQHwQU8Y0H
         fQhXJQemxVsnGX6dt0rvSKqm47LDBgg9ByAAs+3RMv0Ot3YFjq3hLRfsG2DPniS3t4tp
         WhEqGTIecb+TAtoJ4goXvh/SbiMP9gwzm/uIIgPQNy116BtfzSDWWjEaRdRfeoc2C1Te
         o5Mry/99pzA8YkYpAYviJKCNP97gqiItOI+NtsW6Ppnw9ndyiGrdPcpP2ZSxG1ufiQh+
         +Aig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W4OY/JvmasUugHSn3rUmXaSkS514QXA0AsYyOrhfQQg=;
        b=tDfJn+YuPVgaAmVyWZe9n82wFVcEnDpCX+it73cjRR17en3oTWOZxUDwkMsuX0NESr
         vBqTx11eaPig5HP1RTIk5G4L2yquAqR9eUhhFzcARqAHYv9yd2FGxQNcglOMId3ZLW0Q
         +XeYpk8Tc36nE0pzDebJPbYbT0FV+1ixP8zoph7p119lUu1ALbMS3l8vNjAO8k8UCnij
         qcbS4KWDQNs07qsomy26s2SeupEUEotGIc0Wl58LuvLm8fzV5PViPbqYcxUuZTy1Ez6j
         6LZIK2o+vtkLWIx2Ki55TKerJXMss/7GuvByNtl2TOh1I8NGK7vBWhBibEJ1xIR3ZP9o
         SzvQ==
X-Gm-Message-State: AOAM530JLQeWaONohBV7JkkCV9V9eMw0VEgNIJxxMIhcmfhLaP9woxPb
        vgTkNMxActh+OshNjWGWXKQ=
X-Google-Smtp-Source: ABdhPJxZtO2nEF1yJ6MjoitOsoR6NiKa4vbJTd4fTbtfyjCPOSo9zQI9bOEoP434SL7qulITdqNiPQ==
X-Received: by 2002:a05:6402:2741:b0:41f:69dc:9bcd with SMTP id z1-20020a056402274100b0041f69dc9bcdmr30258922edd.239.1651758936244;
        Thu, 05 May 2022 06:55:36 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id e15-20020a50e44f000000b0042617ba63c7sm877949edm.81.2022.05.05.06.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 06:55:35 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Pavel Machek <pavel@ucw.cz>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, ansuelsmth@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        John Crispin <john@phrozen.org>, linux-doc@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH RESEND PoC] leds: trigger: netdev: support DT "trigger-sources" property
Date:   Thu,  5 May 2022 15:55:12 +0200
Message-Id: <20220505135512.3486-6-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220505135512.3486-1-zajec5@gmail.com>
References: <20220505135512.3486-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Parse "trigger-sources", find referenced netdev & use it as default
trigger source.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
This is a proof on concept, please don't apply this patch. I'll rework
this on top of Ansuel's netdev trigger refactoring once it gets accepted
----
 drivers/leds/trigger/ledtrig-netdev.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index d5e774d83021..c036a3671773 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -20,6 +20,8 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/of.h>
+#include <linux/of_net.h>
 #include <linux/spinlock.h>
 #include <linux/timer.h>
 #include "../leds.h"
@@ -389,6 +391,28 @@ static void netdev_trig_work(struct work_struct *work)
 			(atomic_read(&trigger_data->interval)*2));
 }
 
+static void netdev_trig_of_init(struct led_classdev *led_cdev)
+{
+	struct device *dev = led_cdev->dev;
+	struct device_node *np = dev->of_node;
+	struct of_phandle_args args;
+	struct net_device *netdev;
+	int err;
+
+	err = of_parse_phandle_with_args(np, "trigger-sources", "#trigger-source-cells", 0, &args);
+	if (err || WARN_ON(!args.np)) {
+		dev_err(dev, "Failed to get trigger source phandle: %d\n", err);
+		return;
+	}
+
+	netdev = of_find_net_device_by_node(args.np);
+	if (netdev) {
+		device_name_store(dev, NULL, netdev->name, strlen(netdev->name) + 1);
+	}
+
+	of_node_put(args.np);
+}
+
 static int netdev_trig_activate(struct led_classdev *led_cdev)
 {
 	struct led_netdev_data *trigger_data;
@@ -415,6 +439,8 @@ static int netdev_trig_activate(struct led_classdev *led_cdev)
 
 	led_set_trigger_data(led_cdev, trigger_data);
 
+	netdev_trig_of_init(led_cdev);
+
 	rc = register_netdevice_notifier(&trigger_data->notifier);
 	if (rc)
 		kfree(trigger_data);
-- 
2.34.1

