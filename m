Return-Path: <netdev+bounces-5969-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AB57713B52
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 19:40:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C4EB280ECD
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 17:40:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93728568E;
	Sun, 28 May 2023 17:40:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801402F3D
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 17:40:03 +0000 (UTC)
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2089CA2
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 10:40:02 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-5149429c944so1806070a12.0
        for <netdev@vger.kernel.org>; Sun, 28 May 2023 10:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685295600; x=1687887600;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s7PhvjckEdoa9Nfx+swBWoasfm838pJsydDUFtv9gG8=;
        b=HkHON8zuRlO+6KWq5r9z4YEcO28n2ZRgdVL6XNEoJiP3y0+Hu6DCicX/zO3Wz9Ay0y
         4P+UIqaaEcuEzDmH/Xsh0kwdFX/xyINUSvWG8tW+mS3m3fjljEt5yFMkcsphkw8b1vm0
         Xyqc/yQJcMtEteeCGDsjaCtYm/vdTCacPr3w6IQPpbNt/DyGW9Jjtjj2L8eEUPJLEU3W
         T0jnbGI5vFe56pK6Q8blxw49vGKqDX189jFgOExZMODLEk2Z3bRjl8lDD48k36K6o+Rw
         cDkj67qSnF4pEzlTVJPhmRDqT3kNyGy/rcNurKYSquU0Hh58lrYjYY+cl7dfN+JqrBLc
         CPAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685295600; x=1687887600;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=s7PhvjckEdoa9Nfx+swBWoasfm838pJsydDUFtv9gG8=;
        b=CNdIdcRqEQM/Gjz4OlIEg1A5Jrb3DdiAHAbAht9g8hFQqJ+qUdvKtdpefVQXgh0tW3
         Dc/rnvoZhz2M8oClF/9ZHzk3PaenIRzhp3m5ERUdOnrAvjxNooOsoH3a1KhdT+BOLJs3
         pdqYzhX8bAVO7XJ/8Oc6DB+lGnvQ/PbBlKFFMOdhI6LtQcr1Jr016Wq+L0XnaPqwBsyv
         imr740TvOV3xSC1zilPLckb/QJkn0w/i3DubjmxbT5vlZTMQwoDu2a3arX/f1GceI6BT
         jcJ5c1lkD+SciKzImxZrPeS6wz6WSE+hhfJdyIGPs//OhfJ65EvFuY+Ca5pkxXpkZUVD
         LlPQ==
X-Gm-Message-State: AC+VfDx4Oxinmj++Gj7DkdiN51qBYcDFM1mfRpd+ngR9ASyjCtahJK59
	5DrfhfrDyCx3S/LGNpJPIvw=
X-Google-Smtp-Source: ACHHUZ41sKPXVt/O5di2OqlS+5x7uCSKI5TAh7dCX29oUKq1AN62m7HAd1rVIsxUojBzBaNuOJLhaw==
X-Received: by 2002:a05:6402:1612:b0:50b:d53d:7ceb with SMTP id f18-20020a056402161200b0050bd53d7cebmr4915691edv.40.1685295600396;
        Sun, 28 May 2023 10:40:00 -0700 (PDT)
Received: from ?IPV6:2a01:c22:6f2c:fe00:a151:3e12:d4b2:cf2f? (dynamic-2a01-0c22-6f2c-fe00-a151-3e12-d4b2-cf2f.c22.pool.telefonica.de. [2a01:c22:6f2c:fe00:a151:3e12:d4b2:cf2f])
        by smtp.googlemail.com with ESMTPSA id ca28-20020aa7cd7c000000b0050bc6d0e880sm2157604edb.61.2023.05.28.10.39.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 May 2023 10:40:00 -0700 (PDT)
Message-ID: <f9439c7f-c92c-4c2c-703e-110f96d841b7@gmail.com>
Date: Sun, 28 May 2023 19:39:59 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: don't set sw irq coalescing defaults in case of
 PREEMPT_RT
To: Jakub Kicinski <kuba@kernel.org>, David Miller <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

If PREEMPT_RT is set, then assume that the user focuses on minimum
latency. Therefore don't set sw irq coalescing defaults.
This affects the defaults only, users can override these settings
via sysfs.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/core/dev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b3c13e041..58f71d619 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10568,8 +10568,10 @@ void netdev_sw_irq_coalesce_default_on(struct net_device *dev)
 {
 	WARN_ON(dev->reg_state == NETREG_REGISTERED);
 
-	dev->gro_flush_timeout = 20000;
-	dev->napi_defer_hard_irqs = 1;
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT)) {
+		dev->gro_flush_timeout = 20000;
+		dev->napi_defer_hard_irqs = 1;
+	}
 }
 EXPORT_SYMBOL_GPL(netdev_sw_irq_coalesce_default_on);
 
-- 
2.40.1


