Return-Path: <netdev+bounces-5882-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A25B713475
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 13:31:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C5AC1C20FBB
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 11:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F119E11CB7;
	Sat, 27 May 2023 11:29:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D6D11CB1
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 11:29:26 +0000 (UTC)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D657125;
	Sat, 27 May 2023 04:29:24 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f6ef9a928fso8566775e9.3;
        Sat, 27 May 2023 04:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685186963; x=1687778963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AMFIVEMdnhDK+r9aZC4DEh7b5Mu4DnfdJk/ks7MSEOs=;
        b=oFS8fXqtG7ZzSuNm/074P17qC0dmFGT4gs+MWNTauiCXW3DHK1fzFIR1FAT74pZgmf
         Ci/P+tr5R9RLoMHNe56yI/7JKswjwBn17I8HtrBhkQCDPOJ7XTPO2uDj/Z7rcJAlvsLn
         CjNlTI7pN5oGJtmhASWQU/EXUZMe88XOpOG/itu2v7+NHUL7C/zLvcXLeP2iXTmMqnl4
         Y3TYquVnsoS2cZtxt5QQihphNZpsYzqYrCp3RUAQgsfGoc43Eftrf8nF9sE/799zmBRD
         Yh4EEip0MJh4gLKrc4ryCj3yX3P9eYVyPWkIryv+tTMcwYrimzzoUtqyD1VJVpOuarko
         j3Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685186963; x=1687778963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AMFIVEMdnhDK+r9aZC4DEh7b5Mu4DnfdJk/ks7MSEOs=;
        b=gos0rUCHJ1vQmIPoRaxYcpHAPPHO/rArNFvcDiY5BlyY/6uSSDZepUP8jRCm1x6hzw
         /vVMIIfYrRe0OrnGaB5QPPwawc/9YQvG97+HHkZqBFLM+VwQNQj520ZxanPjy9/lDQEA
         QbmV8Doqtg/0UlQepSr/MOlVLjOSJSuZ72Dj3rU79/En1481A72XKuROnt+pkW3EgZ1H
         yHQw2D9KvDYLFWH/Mi/WQvwSB9d/5KcmyAIZOHNySRZGiArj9kjC1EsJeRaB0qC11PUJ
         OxXG78v1Vk2zIh65XWOou0NozMc56KJ7HaRfF2wQAYeCPiIJ/OFcN40OJdbjYsbImdIo
         PQSg==
X-Gm-Message-State: AC+VfDwozvlxskTVhyG0SaANwKw497Ig8UourYxRA/lPaS5JDvTWk4BP
	jYX36cjhkzYa0BxWlPG+Ekk=
X-Google-Smtp-Source: ACHHUZ4R4Z0admEnxkOxbdFIsjOFf2n29cgaZ0FjPhx7IlY+1Jrxi6DivoP338TZYARWn9TzhP14uw==
X-Received: by 2002:adf:e30c:0:b0:2f7:e3aa:677a with SMTP id b12-20020adfe30c000000b002f7e3aa677amr3535704wrj.46.1685186962745;
        Sat, 27 May 2023 04:29:22 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id q13-20020a7bce8d000000b003f43f82001asm11711000wmj.31.2023.05.27.04.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 04:29:22 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	linux-leds@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [net-next PATCH v3 07/13] leds: trigger: netdev: reject interval store for hw_control
Date: Sat, 27 May 2023 13:28:48 +0200
Message-Id: <20230527112854.2366-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230527112854.2366-1-ansuelsmth@gmail.com>
References: <20230527112854.2366-1-ansuelsmth@gmail.com>
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

Reject interval store with hw_control enabled. It's are currently not
supported and MUST be set to the default value with hw control enabled.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 2101cbbda707..cb2ec33abc4e 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -265,6 +265,9 @@ static ssize_t interval_store(struct device *dev,
 	unsigned long value;
 	int ret;
 
+	if (trigger_data->hw_control)
+		return -EINVAL;
+
 	ret = kstrtoul(buf, 0, &value);
 	if (ret)
 		return ret;
-- 
2.39.2


