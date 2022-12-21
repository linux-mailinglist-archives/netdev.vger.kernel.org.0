Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6876653333
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 16:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbiLUP0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 10:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234636AbiLUPZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 10:25:49 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2EF55F49
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:46 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id d14so22402526edj.11
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XEakEc2TumUj9I0JFZxAmMNH6yQlNW3F3xhK6BoUg1I=;
        b=Svm6uGAgnyBswNXuAPBjKuldylKpri2MOc825zRx/pJ/eJTZj57gSwKEb/ss79pB5U
         e/zJuDh0q2Vzhlx+gtpvX5N7eyndyiprjLqxkQC04/c0ogjoQJpO7/wKOa9aPwBP902l
         UIbSSEJ0rfvtkY9ZbiyIkfDlhCM/WH5k1ihWXfA7IKV/AcpLgyPcSWwSdMrGItqJwd9W
         zFBW8qlu+6IpWm8KXv6rzYOKimpr46si9/0zZUegISClGo9TyensAKIdblDapwZe3TEF
         2pRPWpV2EYeuEacnUkGVJLUBsrphRoIw2YxJvFH6LzktA/jmlVFmOc7ZDlp8q7kC994q
         3TAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XEakEc2TumUj9I0JFZxAmMNH6yQlNW3F3xhK6BoUg1I=;
        b=YDNeo3/SaH+qEW8w52HEqCQou6EWNpmO8+Fw51IGw3xQWkQBVnHQPSuHEc+CjXzLpa
         j9lsTW0oM0YlzLZFRXGLw95pvSS6hd/kubI79F2awi4Z0IdXVL9jDh0wCl8EDTAqBUyf
         V+rZu8Ifsiz2FN5qKnnfDskQbzOfKD9Ul5IU4pKqXOrSW+44w7rjVulAXBuZ9MY4eNDJ
         XHc2ZtHN1c+n6VsIN8KC0Qjtw+g68Ja4OHgSwFQnwIHCoNbsP43kDOS8nbfNdyamCdYN
         p/V/v2LSorVk5WFVlOB9J0wjOVyzAJfnGoc/xJfZzkwIaJMNaUXBsVJggAi4Cw7qqgjL
         DIAg==
X-Gm-Message-State: AFqh2kryvJ0GzkD/BfPadDAk2qXxeYbvD1ZKrnEmUAboBMHXEG8wKv+5
        gEJv51FoLefKf8kScBdk6moFjg==
X-Google-Smtp-Source: AMrXdXuvkYCh+U8P1IRU52/jffdmviOD4IwwzippVDhfDVHUOMlTAOi5gALUE08yf5qdt71veiP55w==
X-Received: by 2002:a05:6402:240d:b0:46d:731f:d726 with SMTP id t13-20020a056402240d00b0046d731fd726mr2088485eda.22.1671636345373;
        Wed, 21 Dec 2022 07:25:45 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id n19-20020aa7c793000000b0045cf4f72b04sm7105428eds.94.2022.12.21.07.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 07:25:45 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 05/18] can: m_can: Remove double interrupt enable
Date:   Wed, 21 Dec 2022 16:25:24 +0100
Message-Id: <20221221152537.751564-6-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221221152537.751564-1-msp@baylibre.com>
References: <20221221152537.751564-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Interrupts are enabled a few lines further down as well. Remove this
second call to enable all interrupts.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 4b387403a7c7..a76465016e17 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1347,7 +1347,6 @@ static void m_can_chip_config(struct net_device *dev)
 	m_can_write(cdev, M_CAN_TEST, test);
 
 	/* Enable interrupts */
-	m_can_write(cdev, M_CAN_IR, IR_ALL_INT);
 	if (!(cdev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING))
 		if (cdev->version == 30)
 			m_can_write(cdev, M_CAN_IE, IR_ALL_INT &
-- 
2.38.1

