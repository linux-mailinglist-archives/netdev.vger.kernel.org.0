Return-Path: <netdev+bounces-5354-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BDBE710ED1
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:56:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 475BA281317
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFD8B182D0;
	Thu, 25 May 2023 14:54:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E480F182C8
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:54:57 +0000 (UTC)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D67E19A;
	Thu, 25 May 2023 07:54:56 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-309553c5417so2182781f8f.2;
        Thu, 25 May 2023 07:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685026494; x=1687618494;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MgugxQZ+bMvGGxcEF4OyoNgsowC99irm6wJEB6lkhic=;
        b=jwrCSAKy7iZ9UPxpT/b8WHG4OXncdijOovtoR+94BKAZHN8hcwBZfnmvWeyC1bq10X
         eMsavHmidOJozl7XbGDg480/ueANtV+5WVCJt7sX+ZIIVJsEeqvu7k318JypjUSGRfyi
         63gmG6Sc1QmoByGFZ7vv8lPOEFU6nvx/0NvJO9HeLd1gfZZCldEPBIKtFdLVW8dbqoy8
         TjBOfnewvFV322koPdoIwRCw4tB6RySI/cUKPLV3uOi9bNsI64Ax8viC1NLz9EVcGSEk
         o1AfhZzUzL/jU8jUXH1w+QQbMiYKz1N05QafNGy1HEFQzJkmlynlXobDYNwt7XOfF953
         fsyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685026494; x=1687618494;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MgugxQZ+bMvGGxcEF4OyoNgsowC99irm6wJEB6lkhic=;
        b=L9uiy+FFaBUWOOYWNCu+LxIBPELVx7wQxegJ9ktv7a6shBwBQP25tXH1NA0+zZM151
         Pdw8I7X2FvNdfpnvsN5c5eFLq5IFHwsfeNF7TX2nH8r1BsdfRaEL3ZlwTGhgu7Z/Aq20
         u5+eG4MGbIPRmjh7vGomXgax9V6/kP23LposalQbM744cfL/7BbKKsE7BfhnezGB8fTo
         nIKlDs+K6AW1R2krWwGb1XDB0cnDuAOWKmylVl+T/fshSedEpqSx4viLUJ/xHaiKtA9b
         WyAUmqRljISXBbrSg7NGpVrH0HT7hSNcUOLtBGkLJshs5RPseBOgTTz+NuKwxvUse+Z6
         1mbg==
X-Gm-Message-State: AC+VfDxNGEzttim01VAVQFVlX8Ml5aGF6fFyueAE2vvzSdA4XkMnBJLk
	Jjduu1RB24Q6KWDdR6zWM50=
X-Google-Smtp-Source: ACHHUZ6S1LeC8p+a6GWwe9ZYi5apUgvlxyfjWWX+Ppr6VGCV7UW60L4rPYI+7OGs8FOV2CLUJTgfCA==
X-Received: by 2002:adf:f2ca:0:b0:306:36b5:8ada with SMTP id d10-20020adff2ca000000b0030636b58adamr2761281wrp.29.1685026494299;
        Thu, 25 May 2023 07:54:54 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id t11-20020a5d49cb000000b0030732d6e104sm2048043wrs.105.2023.05.25.07.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 07:54:53 -0700 (PDT)
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
Subject: [net-next PATCH v2 03/13] Documentation: leds: leds-class: Document new Hardware driven LEDs APIs
Date: Thu, 25 May 2023 16:53:51 +0200
Message-Id: <20230525145401.27007-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230525145401.27007-1-ansuelsmth@gmail.com>
References: <20230525145401.27007-1-ansuelsmth@gmail.com>
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

Document new Hardware driven LEDs APIs.

Some LEDs can be programmed to be driven by hardware. This is not
limited to blink but also to turn off or on autonomously.
To support this feature, a LED needs to implement various additional
ops and needs to declare specific support for the supported triggers.

Add documentation for each required value and API to make hw control
possible and implementable by both LEDs and triggers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 Documentation/leds/leds-class.rst | 80 +++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
index cd155ead8703..3d7874c18982 100644
--- a/Documentation/leds/leds-class.rst
+++ b/Documentation/leds/leds-class.rst
@@ -169,6 +169,86 @@ Setting the brightness to zero with brightness_set() callback function
 should completely turn off the LED and cancel the previously programmed
 hardware blinking function, if any.
 
+Hardware driven LEDs
+====================
+
+Some LEDs can be programmed to be driven by hardware. This is not
+limited to blink but also to turn off or on autonomously.
+To support this feature, a LED needs to implement various additional
+ops and needs to declare specific support for the supported triggers.
+
+With hw control we refer to the LED driven by hardware.
+
+LED driver must define the following value to support hw control:
+
+    - hw_control_trigger:
+               unique trigger name supported by the LED in hw control
+               mode.
+
+LED driver must implement the following API to support hw control:
+    - hw_control_is_supported:
+                check if the flags passed by the supported trigger can
+                be parsed and activate hw control on the LED.
+
+                Return 0 if the passed flags mask is supported and
+                can be set with hw_control_set().
+
+                If the passed flags mask is not supported -EOPNOTSUPP
+                must be returned, the LED trigger will use software
+                fallback in this case.
+
+                Return a negative error in case of any other error like
+                device not ready or timeouts.
+
+     - hw_control_set:
+                activate hw control. LED driver will use the provided
+                flags passed from the supported trigger, parse them to
+                a set of mode and setup the LED to be driven by hardware
+                following the requested modes.
+
+                Set LED_OFF via the brightness_set to deactivate hw control.
+
+                Return 0 on success, a negative error number on flags apply
+                fail.
+
+    - hw_control_get:
+                get active modes from a LED already in hw control, parse
+                them and set in flags the current active flags for the
+                supported trigger.
+
+                Return 0 on success, a negative error number on failing
+                parsing the initial mode.
+                Error from this function is NOT FATAL as the device may
+                be in a not supported initial state by the attached LED
+                trigger.
+
+    - hw_control_get_device:
+                return the device associated with the LED driver in
+                hw control. A trigger might use this to match the
+                returned device from this function with a configured
+                device for the trigger as the source for blinking
+                events and correctly enable hw control.
+                (example a netdev trigger configured to blink for a
+                particular dev match the returned dev from get_device
+                to set hw control)
+
+                Return a device or NULL if nothing is currently attached.
+
+LED driver can activate additional modes by default to workaround the
+impossibility of supporting each different mode on the supported trigger.
+Example are hardcoding the blink speed to a set interval, enable special
+feature like bypassing blink if some requirements are not met.
+
+A trigger should first check if the hw control API are supported by the LED
+driver and check if the trigger is supported to verify if hw control is possible,
+use hw_control_is_supported to check if the flags are supported and only at
+the end use hw_control_set to activate hw control.
+
+A trigger can use hw_control_get to check if a LED is already in hw control
+and init their flags.
+
+When the LED is in hw control, no software blink is possible and doing so
+will effectively disable hw control.
 
 Known Issues
 ============
-- 
2.39.2


