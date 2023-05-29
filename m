Return-Path: <netdev+bounces-6147-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1C65714E87
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 18:37:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 480431C20A41
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEAD7107A1;
	Mon, 29 May 2023 16:34:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DA410798
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 16:34:52 +0000 (UTC)
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553CFBE;
	Mon, 29 May 2023 09:34:51 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-307d20548adso2072948f8f.0;
        Mon, 29 May 2023 09:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685378090; x=1687970090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qJiU1ASrfZmceZZC4eiSm3WS0QnApUvAsP7UJRGu7Co=;
        b=UjQM7+YVLYGHnFZmtl/O4wixpGGuV4XHFoBoRyt/AzXo7TB3AlLZllQ3lAmg5vvdjM
         lP9O4FSGU01rRKZoJKXVm35XZ3a2J0SLckVlrn0OkM2Lkgbt/n5uo5irMbeTzxs9N0S9
         Naxwttn4fMCd/Ae6hajUXEoTW0T+D78DTz6Vv9b6RpzqahwaR7qfi/uShNcqeoqLY5pv
         P2R3LtbpwGk2cPjAhf1hU8aLHJn9X/aNpmurRFPVzWP8ENs4N7UsFjUa/qoH2wC+uhST
         9LjWLupMmeXsqO5THE9xJKhxvO7H1TzVZ/sM3qCHWmiucMJAh8BR0i4e8YEmgFvKNWrQ
         ZNUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685378090; x=1687970090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qJiU1ASrfZmceZZC4eiSm3WS0QnApUvAsP7UJRGu7Co=;
        b=TkMDyD1MYDLAxcUFx/suj9sAWsmfBe41bptt+B58/JDHyyMWyO3THAWTb+cvu6NBlQ
         9hdvyxw4bAhXDuXJdTMoZhhFWTOvhQQWtj8yxrghaCZIYMRo9VgpzLK5mQfrdXUJ7hZv
         GQW0HHm9SUf9I7AAvngF0IEb744QgQ3ZiG0RGChoabylFfFsvMfVibAdzNxsPdz+GQsN
         i9UvG6X6GPjwNWXTojTurnd/RzgcyqIUJfnOQWbJVLCWVm0Ik1rkUO4f7TlcjlaWKgTo
         2Ct4X65rerm9i++FZvMSpl5bnUMHxOWHuOjgRxtqmxwXUssCwYpFg+ksGYrEdIWVKYqR
         oMdQ==
X-Gm-Message-State: AC+VfDzMLRMRxiuIok7TQInFXog34Ea+hKloQ/ioRc5x27ZKGybIfq63
	Mzm9MwS9enHaOSmAuNSOH6E=
X-Google-Smtp-Source: ACHHUZ6LmavkNiuiaw1OkB4/vaYueucZlXesPwBKXihMiuOc7iNu5z7Z2kZWXDxxwCB+REryY4N+AQ==
X-Received: by 2002:adf:df12:0:b0:306:2f8e:d259 with SMTP id y18-20020adfdf12000000b003062f8ed259mr7569897wrl.57.1685378089652;
        Mon, 29 May 2023 09:34:49 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id h14-20020a5d6e0e000000b002ff2c39d072sm417513wrz.104.2023.05.29.09.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 09:34:49 -0700 (PDT)
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
Subject: [net-next PATCH v4 07/13] leds: trigger: netdev: reject interval store for hw_control
Date: Mon, 29 May 2023 18:32:37 +0200
Message-Id: <20230529163243.9555-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230529163243.9555-1-ansuelsmth@gmail.com>
References: <20230529163243.9555-1-ansuelsmth@gmail.com>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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


