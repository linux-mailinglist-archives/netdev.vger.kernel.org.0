Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942E76EFE7D
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242969AbjD0ATP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 20:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242885AbjD0ATJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:19:09 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC13940E1;
        Wed, 26 Apr 2023 17:19:02 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f09b4a1584so53770885e9.2;
        Wed, 26 Apr 2023 17:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682554741; x=1685146741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=usUz5vlQbTcVSoDq5iitXuZZP0qB/F/micaPhHdJRQ4=;
        b=rhvFV/yg6ZRaZnKZM7MPdqK+NrxfCdyeyryRM0A0ga6PbXhRGUD14cj4SnxxqK1dLy
         WlA4KbDfzX855D+EMp5fm2efW7yc+9KjH7dl2xSQIhQjAFYYvFvhsLfzYzD4zM5fllxm
         nN2wF8v6y+76FnCxN6gMf+XTs+mySyY/7M6A7M6DHHjfxjHGR8q28wXOInmqSWca2fIV
         8WBHIfTkIMJMwwts3Ovwo7ovCuP68dQWbkjtvYnvgdlbRGJ/Rhqicps9Ffe7mEYAGm0w
         Fq++HwDl810G+1UEwMcvzgOW88V3F33dXokgIIgt0zcISLmEe9symdxMj6JoatDiDW+I
         ywkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682554741; x=1685146741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=usUz5vlQbTcVSoDq5iitXuZZP0qB/F/micaPhHdJRQ4=;
        b=eAYmMZg44czM4U1bLEB8X8FXpqHDnHoU3XfREVfC8Lbo83qSyW4Jj59uzGuhQ6/hm0
         2qxLtYA3v4cnvz4vDDvihqGczTFRgciZQqqBmxQ816rorIt/azUZ53nN9CzpU1pKD6Fb
         K1ViYVN1+0QnggbT9w2ReefBx+C5/Nn1raSeuNkQpWy97TxRFfeZ7vHzK5EhpBwrP44t
         TPGZYUmLISvZsZuslGyMEgXbD39sDmI/LJKcq7E4utb9upKUYa6iJar8XMCHFztqV8q1
         Wiy3830o/3jguGMcRYFEJQ4GouJpJitVE/vqjAIushtMjs4gtnR1STGXzCbLIhVAQ9zY
         2uaA==
X-Gm-Message-State: AAQBX9eb3Lmc93IvmrXHZmR64M6WTRoKGhGr6tF/EQfJziPE0dP+pV8q
        mS1KYV8cXH7eHd91DmZaO4g=
X-Google-Smtp-Source: AKy350bhRhJTpCjZ0jujDv77toVWCpdHbxLyDIW42UiZwgRtJb1aZu/bMxDwMRrVvGZQ0tUzK2RKhg==
X-Received: by 2002:a7b:c408:0:b0:3f0:9c6c:54a0 with SMTP id k8-20020a7bc408000000b003f09c6c54a0mr14138139wmi.2.1682554740926;
        Wed, 26 Apr 2023 17:19:00 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id r3-20020adfda43000000b003047ae72b14sm8624916wrl.82.2023.04.26.17.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 17:19:00 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Lee Jones <lee@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 07/11] leds: trigger: netdev: reject interval and device store for hw_control
Date:   Thu, 27 Apr 2023 02:15:37 +0200
Message-Id: <20230427001541.18704-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230427001541.18704-1-ansuelsmth@gmail.com>
References: <20230427001541.18704-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reject interval and device store with hw_control enabled. They are
currently not supported and MUST be empty with hw_control enabled.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 28c4465a2584..8cd876647a27 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -124,6 +124,11 @@ static ssize_t device_name_store(struct device *dev,
 
 	mutex_lock(&trigger_data->lock);
 
+	if (trigger_data->hw_control) {
+		size = -EINVAL;
+		goto out;
+	}
+
 	if (trigger_data->net_dev) {
 		dev_put(trigger_data->net_dev);
 		trigger_data->net_dev = NULL;
@@ -145,6 +150,8 @@ static ssize_t device_name_store(struct device *dev,
 	trigger_data->last_activity = 0;
 
 	set_baseline_state(trigger_data);
+
+out:
 	mutex_unlock(&trigger_data->lock);
 
 	return size;
@@ -248,6 +255,13 @@ static ssize_t interval_store(struct device *dev,
 	unsigned long value;
 	int ret;
 
+	mutex_lock(&trigger_data->lock);
+
+	if (trigger_data->hw_control) {
+		size = -EINVAL;
+		goto out;
+	}
+
 	ret = kstrtoul(buf, 0, &value);
 	if (ret)
 		return ret;
@@ -260,6 +274,9 @@ static ssize_t interval_store(struct device *dev,
 		set_baseline_state(trigger_data);	/* resets timer */
 	}
 
+out:
+	mutex_unlock(&trigger_data->lock);
+
 	return size;
 }
 
-- 
2.39.2

