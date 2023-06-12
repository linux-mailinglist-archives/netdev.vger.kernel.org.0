Return-Path: <netdev+bounces-9981-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D27F72B8C2
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:39:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 636161C20ADE
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 07:39:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C788D300;
	Mon, 12 Jun 2023 07:39:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51686D2FD
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:39:26 +0000 (UTC)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7AD3CE
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 00:38:43 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-516a008e495so8252611a12.1
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 00:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686555273; x=1689147273;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w+Qi8JTAYiLDVqnRPgJbhci7OK6Vh1X6mg5NofF+Ffg=;
        b=rFJQZhz3idBJGb/x5JeqWq8f4yLrmoThyOJEaVKgKnFgPRTT15k+B5I0ibbjBVFFNi
         R+XCZs+0KREVa+68y2TtizG5h36f8wy0mx7bhL6GH/0QiIjN+FiiMJ8Ox9rj004M5XmI
         rQCQ4b+N4jQn3fdHhTd/ly0UWOSTse4QunCRoJCn171FdTfmpZ5ZT8f7cnTIa+WbLQMq
         D09vIbljaXkjsJE3Uz9WUUNjM8bnkbuenwSbZ1ycKhSxRXwBOLtb++ckbNpFqeFI95N4
         E2fIf6ww4o8vbR4vMAriYdjpf/2SvqEGtw0PclTJx+cgRqYB5C0nV3O8B4OPUupZxrLa
         Pm9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686555273; x=1689147273;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w+Qi8JTAYiLDVqnRPgJbhci7OK6Vh1X6mg5NofF+Ffg=;
        b=ezB1fGSLBa8NicZ6dQs93zFtrYJ6YKI96vOWPlfbO8KpSyuzdkm6/xKribhB46FooQ
         iEzCTcSuVWN6BOf4NxW07NKUOZIeme2djPoQ6HzZCxqf9NzTEESzYravK8d6h0B0Xor9
         q9WbPELoTOMFyMVp/99p6LEcqP8GX87QD4C2PmhWf5sDHatrGFB/DCFksq4ErPNIXX9g
         gBe67Xb6EnEaq0Zkb3702iFIk9+m7yk7nZjypACSLixyMag0mGkk671ldx/QqilPod7s
         kXLqbbkN3qlNwZ1/RLd6BgCdpoGd46hLMRLE9Fzt/65CV2p7rnzK7dDHbMm9ufdasxRz
         TkAw==
X-Gm-Message-State: AC+VfDzsjMgu/ming08nrPhQXnQrODf5YZnTz2tl6Gv6EZPJ5qHYlPKo
	wR68raSz/e6LbShmsCYRBNvZ8w1sWQYJN+TSpOY=
X-Google-Smtp-Source: ACHHUZ7o8sqiMBOcVwAWkcIW5b3yD5lxoIbzeQr0yV6BoqSehrk0Rwwz+R5qoAip8C55vGsL/exYZw==
X-Received: by 2002:a7b:c7da:0:b0:3f7:a20a:561d with SMTP id z26-20020a7bc7da000000b003f7a20a561dmr7027654wmk.8.1686554460503;
        Mon, 12 Jun 2023 00:21:00 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id x19-20020a1c7c13000000b003f7aad8c160sm10401419wmc.11.2023.06.12.00.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 00:20:59 -0700 (PDT)
Date: Mon, 12 Jun 2023 10:20:55 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Pavel Machek <pavel@ucw.cz>, netdev@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH net-XXX] net: dsa: qca8k: uninitialized variable in
 hw_control_get()
Message-ID: <5dff3719-f827-45b6-a0d3-a00efed1099b@moroto.mountain>
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
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The caller, netdev_trig_activate(), passes an uninitialized value for
*rules.  This function sets bits to one but it doesn't zero out any
bits so there is a potential for uninitialized data to be used.
Zero out the *rules at the start of the function.

Fixes: e0256648c831 ("net: dsa: qca8k: implement hw_control ops")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/net/dsa/qca/qca8k-leds.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/qca/qca8k-leds.c b/drivers/net/dsa/qca/qca8k-leds.c
index 6f02029b454b..772478156e4e 100644
--- a/drivers/net/dsa/qca/qca8k-leds.c
+++ b/drivers/net/dsa/qca/qca8k-leds.c
@@ -304,6 +304,8 @@ qca8k_cled_hw_control_get(struct led_classdev *ldev, unsigned long *rules)
 	u32 val;
 	int ret;
 
+	*rules = 0;
+
 	/* With hw control not active return err */
 	if (!qca8k_cled_hw_control_status(ldev))
 		return -EINVAL;
-- 
2.39.2


