Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E557F391A
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 21:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfKGUCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 15:02:04 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39933 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfKGUCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 15:02:04 -0500
Received: by mail-lj1-f196.google.com with SMTP id p18so3668100ljc.6
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 12:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sWK1iMgmuXL7Tb2eplZGx/oC/uSa+BZBKZskoo3wBq0=;
        b=MF2FHnqwNpUU1MM46hHcSNiI6UcalrGXvlUZZJVBIEDtW3mJ/3BnVsPCaQRozU6h/D
         SzbLKGbfe3Y9im4AX468u9BQakpwU1En4z3SEZJPh3JGItTTaScDLLub68CTsu0a40L1
         mnbkcSOyESoO9UabUIb3+z6zWPWxkUNy1KTMZ4ru3NIAx0qjddLKybg4qVb8OAqjVPnw
         sSMdWzo+eTj8Fjt8DyimLKrsLowsAI+GWR0nAyxjdH1sUTYW6NlimklxiBM1+a4S6qbN
         ++HoFBULs4/iDx8ql7MrWNeTdRLTDkg21S9uMLSgQzu1GYNqxp0wI1YD3FqYjZpld6z4
         mYqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sWK1iMgmuXL7Tb2eplZGx/oC/uSa+BZBKZskoo3wBq0=;
        b=NXFWjP9KnZ3Jptnkez619N339fu+pvK2yGTK96Rh1LF1XN76uR+620C5dnpWlMFLnO
         xfF4qFRU9UWjnfT9q6mElQRcUpRcmtfeNRbdfSH3DugUAC74jEnIVPwJYhXoSxvBr6vT
         5aEwiY/BeT/04P0mwCD3GaJ7aaKUhOaOsVCjgxRU7+A4iX9rNEnt8cRgwgYrK7kR2WRR
         viOdNoju/hK4q/8I7Pcfz/LO5SOhftK8VNZLm+BwY0AlN7a3PJaMeqvFuVwl04PKnLwm
         bQXTrZDzUwhVGLZLxRJqXH0JNovLVWt/2b9e4hm2B1Qs5ZxQFX8oiLAA/lwXKlqaVOUZ
         oBMg==
X-Gm-Message-State: APjAAAVcWHD3cYGaSn1UjhZZlLpArUSd+AI74i2YPYAREZDQKlAt5iV/
        joa/uQRexTzWE/EMr29tm/SCqw==
X-Google-Smtp-Source: APXvYqwJ/Pg+KQ4mZ6nX3AZSLmAL8hvpA11PJ6SvYUc0Eu5WEKaB8sAbOB3LnatyRaGfe++ocp5aqg==
X-Received: by 2002:a05:651c:326:: with SMTP id b6mr3807356ljp.119.1573156922048;
        Thu, 07 Nov 2019 12:02:02 -0800 (PST)
Received: from localhost.localdomain (57-201-94-178.pool.ukrtel.net. [178.94.201.57])
        by smtp.gmail.com with ESMTPSA id q24sm1259746ljm.76.2019.11.07.12.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 12:02:01 -0800 (PST)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     davem@davemloft.net, grygorii.strashko@ti.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH net-next] ethernet: ti: cpts: use ktime_get_real_ns helper
Date:   Thu,  7 Nov 2019 22:01:58 +0200
Message-Id: <20191107200158.25978-1-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update on more short variant for getting real clock in ns.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 drivers/net/ethernet/ti/cpts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 61136428e2c0..729ce09dded9 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -459,7 +459,7 @@ int cpts_register(struct cpts *cpts)
 	cpts_write32(cpts, CPTS_EN, control);
 	cpts_write32(cpts, TS_PEND_EN, int_enable);
 
-	timecounter_init(&cpts->tc, &cpts->cc, ktime_to_ns(ktime_get_real()));
+	timecounter_init(&cpts->tc, &cpts->cc, ktime_get_real_ns());
 
 	cpts->clock = ptp_clock_register(&cpts->info, cpts->dev);
 	if (IS_ERR(cpts->clock)) {
-- 
2.20.1

