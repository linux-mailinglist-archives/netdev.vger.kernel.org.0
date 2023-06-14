Return-Path: <netdev+bounces-10609-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D2BE72F55E
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:04:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F6FE1C20CAA
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 07:04:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC198A53;
	Wed, 14 Jun 2023 07:04:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08C67F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 07:04:07 +0000 (UTC)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A595819A5
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 00:04:05 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f78a32266bso4050745e9.3
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 00:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686726244; x=1689318244;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dqIK+JrRD/w1Gt88Di+paTgCGEYvpSh0GC+h6+bW3yw=;
        b=iCwy9RDb84tB4kdaKWth75H7OmawV3HZ4X8FhNc+nYNfBbl/NigevNY/cmxfdscO0/
         fWJemgiaosp8IDhkT1QFQ3X3IYVZX0YwkqV3NwXl37UlyxA0FuiADy8+ecyuDFgFz6nk
         16CcxdUdY4+zxFszfXkIcovxD6xSspKN5w69rcVQTmVkYIyynXMLSoUm0oPr7NxSDt/C
         wh7UwBq7F78RofgfuiAP19lEm2Qgk6mbTIKf74/M23O1W+cvGc5Vo3PIYrxH5FwLhuH+
         TFOLfgS2mE4VbygkDAhE4HEeuKDRZYQUekm4flyfOoA+KxExoXZO8V7Uy58Z3wyapbVK
         Ay8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686726244; x=1689318244;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dqIK+JrRD/w1Gt88Di+paTgCGEYvpSh0GC+h6+bW3yw=;
        b=k2cyb8MlJLVpCIfrJiNb+9jILJFOZk/rYo1kVW28sfMjepCt8XQvcsL1uNNLPJNzI+
         Z4P7ECFW+YyvBqn+HgJp334Q8DGLEOCC/LrvHYXrGQQek12cD/KjZx0hrBMoSzBEW05L
         D4HAis/kK++HfmSPyTqYxrsBbpsQkDHd8oCDAIop7cdBeBTZobaDoo3GwZ2p9tMOPnbA
         n4VZBY+RK8GEKT3FwzcwEPB1OOhEt4nl21Yhe7kMFUdt5q1yY6oA03g2PhBAFHC7LroC
         e9mX46TMqcwHwT6kDAVvWbK1sEP4OASztT8dZRcVwjclywQgvLB78kT+4ONgBAuHv/vy
         GZ5Q==
X-Gm-Message-State: AC+VfDyyPTy1NuKvrzD7aSE3GJ7hhXKJ+2iDjYcZ49FGz/RilIPVq1l4
	BProSAbf/QjdTSRXXnuwO5jjDp1aT1KB+M756zw=
X-Google-Smtp-Source: ACHHUZ6oGuWWPlZXUkigPMZkc4obcChtgd4nGGd8losWL+Kf8Mic51FCYSQDA7U2hPFcoyYH0McUmg==
X-Received: by 2002:a1c:ed06:0:b0:3f7:f584:5796 with SMTP id l6-20020a1ced06000000b003f7f5845796mr11528366wmh.2.1686726244098;
        Wed, 14 Jun 2023 00:04:04 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id k15-20020a7bc40f000000b003f7f1b3aff1sm16475105wmi.26.2023.06.14.00.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 00:04:02 -0700 (PDT)
Date: Wed, 14 Jun 2023 10:03:59 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Pavel Machek <pavel@ucw.cz>, netdev@vger.kernel.org,
	Lee Jones <lee@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>, linux-leds@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH v2 net-next resend] leds: trigger: netdev: uninitialized
 variable in netdev_trig_activate()
Message-ID: <ZIlmX/ClDXwxQncL@kadam>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Resending because this actually goes through net-next and not the led
subsystem.

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

