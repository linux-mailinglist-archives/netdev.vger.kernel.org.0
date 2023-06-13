Return-Path: <netdev+bounces-10296-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8655B72DA1C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 08:47:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B97CE1C20C3A
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 06:47:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8137B1844;
	Tue, 13 Jun 2023 06:47:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CC73FF5
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 06:47:12 +0000 (UTC)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE941BC9
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 23:47:01 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f735259fa0so52682665e9.1
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 23:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686638819; x=1689230819;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=02cZUxsOqGfZ8lXmchHjzAFGxYbEcf/VDvBL7ckHl/M=;
        b=hKm0C1CuMJaIu2eNk6rIDpUz1RWQ/iGh9mP7XAV/Qht00URUaHpXipQXWiXvxvxQ10
         jc1Hm2Ewm9nsGigWSZ4P7mjQNRH606pxCpTGwkHFQ9+1tCEge7+8nUmnl5Sd9Ra7r7xq
         YpVPe/OPAIkKEfcWGUR4VPYS5D4pf6kB5g0Bwtgz831JXhToLyyfY6fDsQUPzaZTY0Pm
         PDYGSEk/qV3XPF97oPZUD3EDOmpUbIYpjU0dnXiIhtTPpOZeMiNqgUnSVoddTRAhk+rM
         bBEuW4yf1lm/ZMz0yb4IfOLXRCQUzhdt1aYcM0aEMVDEkFIyZ+rYrFk+E93zjGRehG+3
         sr+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686638819; x=1689230819;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=02cZUxsOqGfZ8lXmchHjzAFGxYbEcf/VDvBL7ckHl/M=;
        b=fPrIhTcDnXcVUNQ3lwkg+Ae9ncK7BMrf2fXjp2XyWiqxomcYBWB+mvjekZFeOAx+87
         3Y7LTPdAWEKROSn1ZrOyj3/JmpVfAshnyHePIbUdGxk1XZZ9vrmDkXBDlSRYl4G9ppYS
         iFyzqN1ed7cth3AsffoYg8ulUY8tLHbzYDj5q8oR2wgmDhhNeMPF08RP6MbdhU4sCqcq
         fc4OLVIm2AWoIrgSZbQB1FV2U18CsrLPftbd9uKP3Wb0dnvdtJQCN6Y3+F5kBE8bdKXf
         pCVR82o4e9D7Bujtzc+OJhusgUOR8R3dy1BQyNiUp8qxjjPwacTkvq3S0EnPuln70ePc
         uOsQ==
X-Gm-Message-State: AC+VfDxgwgSrFCERQmr1LVMtTGjov8e3dsYOANwJWIspd45d3K3NiVcr
	xxEa3somvVShFmrndPHkgvUb1A==
X-Google-Smtp-Source: ACHHUZ7jLXGNINNFmi15PwujwvIU2N90t+1cq56bMQ/WiVjOp1HKtrySJyLsof5kHSHuUy2YkGQ3YA==
X-Received: by 2002:a7b:c349:0:b0:3f7:408e:b89b with SMTP id l9-20020a7bc349000000b003f7408eb89bmr9070856wmj.33.1686638819250;
        Mon, 12 Jun 2023 23:46:59 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id 11-20020a05600c228b00b003f7361ca753sm13326057wmf.24.2023.06.12.23.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 23:46:57 -0700 (PDT)
Date: Tue, 13 Jun 2023 09:46:53 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>, linux-leds@vger.kernel.org,
	kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 led] leds: trigger: netdev: uninitialized variable in
 netdev_trig_activate()
Message-ID: <6fbb3819-a348-4cc3-a1d0-951ca1c380d6@moroto.mountain>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The qca8k_cled_hw_control_get() function which implements ->hw_control_get
sets the appropriate bits but does not clear them.  This leads to an
uninitialized variable bug.  Fix this by setting mode to zero at the
start.

Fixes: e0256648c831 ("net: dsa: qca8k: implement hw_control ops")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
v2: In the original patch I fixed qca8k_cled_hw_control_get() instead
so that patch went to netdev instead of to the led subsystem.
https://lore.kernel.org/all/5dff3719-f827-45b6-a0d3-a00efed1099b@moroto.mountain/
Fixing it here is a more reliable way to do it.

 drivers/leds/trigger/ledtrig-netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index b0a6f2749552..2311dae7f070 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -445,7 +445,7 @@ static void netdev_trig_work(struct work_struct *work)
 static int netdev_trig_activate(struct led_classdev *led_cdev)
 {
 	struct led_netdev_data *trigger_data;
-	unsigned long mode;
+	unsigned long mode = 0;
 	struct device *dev;
 	int rc;
 
-- 
2.39.2


