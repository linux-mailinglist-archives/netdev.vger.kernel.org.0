Return-Path: <netdev+bounces-9977-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E066972B8A0
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:29:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 229F01C20B0A
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 07:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 238CED302;
	Mon, 12 Jun 2023 07:29:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153FFD2EE
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:29:29 +0000 (UTC)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCDF198D
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 00:24:29 -0700 (PDT)
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-3f7ff69824dso24568615e9.1
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 00:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686554460; x=1689146460;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w+Qi8JTAYiLDVqnRPgJbhci7OK6Vh1X6mg5NofF+Ffg=;
        b=Ln86Lgv65apUtlFy+wfManekSW80FSeJ0LU9sC1t0nGuwAWuIOAefgavBkbVyIW5d9
         uyxlxMPOsTatPczS5fs6TE8YABYzgVmuY1ztDdPO1CScB1/jU6gpWZ+BgQ1fJ8ixQux/
         R3e8FsZy1uTV3Xfia/6h1bCBUZvrTclIG255WYR6MWbtyX3WN1oJImdv54lwbFii/BgK
         3kvJLKsWBapBoALUKMCXbfKIglfT+klr5+fxpujXW3AUI7+69hTDhuE8slzdfCEB+l/H
         frBeHQvjf6wcksyrHsCNOA98YvP7w4fwMgjcaeDnWEhLRv0SWRWVoA96ymlJ4mHWI48f
         Wxeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686554460; x=1689146460;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w+Qi8JTAYiLDVqnRPgJbhci7OK6Vh1X6mg5NofF+Ffg=;
        b=d/1COmg0lWMmU+qpvXMeHSRdyMu76mCrxLuzq0oZH+NcAVNK32dcTUDzX++Y6FuiNT
         CZHqD4iGX4zZHZKRNSekxpNeO2h4qxASwGrR7hupEKY16Sb46fxgVGycxQOqbMQxwEuA
         cfRQYVaqP8UxfRohqL3k8z4PiBEX6WAw/7JDU1oRdiv+R7j75cqkgn2fZ8qOfjnx1a/l
         iAa70Si9SAXQiTknSGCDTO1gX2fIbO+9M3yCzpKUd2J+a9BKwDMk97+/r/W+8+IEMw8m
         BuaUr1hU9UwfCo/u2efDT5vaPbynz/uSYW2FrdlG7n93mGU8AyW//L5DXC6LzJipMgVd
         SPKw==
X-Gm-Message-State: AC+VfDxVCc6mnm5yHsUM5TQKvgFlIlescST871xGg+o1HO3vWrQkjADi
	hvfGJjKDyFMl7XtPtmYCCSU8lQ==
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


