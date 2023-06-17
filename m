Return-Path: <netdev+bounces-11809-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F11887347FC
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 21:24:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC752281003
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 19:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2018D9445;
	Sun, 18 Jun 2023 19:24:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137F01FD1
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 19:24:06 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691CCFC;
	Sun, 18 Jun 2023 12:24:05 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-30adc51b65cso2677464f8f.0;
        Sun, 18 Jun 2023 12:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687116244; x=1689708244;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=MgtexUEGrgjvYhEdRHaEOKyKO3yC+i0FtmJ8yuwDDUk=;
        b=ZTUEfNFnsN3qCpA6c5F/hubR6UpGpjGoV+qI2yERWYINBgSNgzb4XHWD44vsFA1BZk
         l+Cx6ZJBL6600ujRWVN1xAnVo2A+m0eRo+5aAO+CM3YskeDafWTKLwSnXa4GXcjo7lUy
         vx8D8uW3+lB0Yyl8UF3KJAhrGZqbcktSClCBxHFCFwU07ehOEqrguW21O6nN6XvEjSS/
         Ql5eaxrmK8ntUt37lRLwHGRr0M/LkeNNo5jFgikl/qAZk+Rj+YlsdE+1ufdyrowuRpsh
         xjTwCwFC/c/hsc/S65m/+rK5Hl9d056CrgyIqNgFhgQzfCg4UN4SGloWcsiUX48PK+DY
         atQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687116244; x=1689708244;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MgtexUEGrgjvYhEdRHaEOKyKO3yC+i0FtmJ8yuwDDUk=;
        b=OsMp0Kty0sspW/+/tOYfKiPfuprqO4HewHv8uWWT6miISBAIQtd9017P732UjInjQZ
         Bkw7HCraM1pvgI/pN2dWwSSEZMua8T4IeVvcE85wnGBMdQmGI76xS41WnplJOs/7+3Mo
         wDn/P2qEmPaxdq3eFCKTmAix7ZFILaULWut1to440wmpScTEYJogfisl17TloYnpoTQl
         9oLWjodZMSw/kfgfS6MFGdjbuKc9VKqYVotsevn54H5NE4JDZicYv5TUtCd+Gp1oRXD9
         nWmjxjPP0Rqyc3DB37KfVolQqxfY8t8OPkHG9WhV2YGT2GPYkKBpVYCRZX10VMoieWae
         jm/A==
X-Gm-Message-State: AC+VfDxHa0T/fBU8Pu9s9dIvV/bqq95jlc9vqCJxAFWA4vRquII4Eokc
	u8ThfK1RBVFlGqRP3NTZiFUvO47TI/o=
X-Google-Smtp-Source: ACHHUZ7pwONzFmtcmz1F18q4sV4gBeRYMEhRRQPEtQTJ3iqYcF6tF8svPUWezfkKvaxKBpVktj+16Q==
X-Received: by 2002:adf:fa06:0:b0:30f:bdc5:c150 with SMTP id m6-20020adffa06000000b0030fbdc5c150mr7986343wrr.33.1687116243467;
        Sun, 18 Jun 2023 12:24:03 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id h12-20020adffd4c000000b0031130b9b173sm4065871wrs.34.2023.06.18.12.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jun 2023 12:24:03 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Yang Li <yang.lee@linux.alibaba.com>,
	linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [net-next PATCH v4 0/3] leds: trigger: netdev: add additional modes
Date: Sat, 17 Jun 2023 13:53:52 +0200
Message-Id: <20230617115355.22868-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_24_48,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is a continue of [1]. It was decided to take a more gradual
approach to implement LEDs support for switch and phy starting with
basic support and then implementing the hw control part when we have all
the prereq done.

This should be the final part for the netdev trigger.
I added net-next tag and added netdev mailing list since I was informed
that this should be merged with netdev branch.

We collect some info around and we found a good set of modes that are
common in almost all the PHY and Switch.

These modes are:
- Modes for dedicated link speed(10, 100, 1000 mbps). Additional mode
  can be added later following this example.
- Modes for half and full duplex.

The original idea was to add hw control only modes.
While the concept makes sense in practice it would results in lots of 
additional code and extra check to make sure we are setting correct modes.

With the suggestion from Andrew it was pointed out that using the ethtool
APIs we can actually get the current link speed and duplex and this
effectively removed the problem of having hw control only modes since we
can fallback to software.

Since these modes are supported by software, we can skip providing an
user for this in the LED driver to support hw control for these new modes
(that will come right after this is merged) and prevent this to be another
multi subsystem series.

For link speed and duplex we use ethtool APIs.

To call ethtool APIs, rtnl lock is needed but this can be skipped on
handling netdev events as the lock is already held.

[1] https://lore.kernel.org/lkml/20230216013230.22978-1-ansuelsmth@gmail.com/

Changes v4:
- Add net-next tag
- Add additional patch to expose hw_control via sysfs
- CC netdev mailing list
Changes v3:
- Add Andrew review tag
- Use SPEED_UNKNOWN to init link_speed
- Fix using HALF_DUPLEX as duplex init and use DUPLEX_UNKNOWN instead
Changes v2:
- Drop ACTIVITY patch as it can be handled internally in the LED driver
- Reduce duplicate code and move the link state to a dedicated helper

Christian Marangi (3):
  leds: trigger: netdev: add additional specific link speed mode
  leds: trigger: netdev: add additional specific link duplex mode
  leds: trigger: netdev: expose hw_control status via sysfs

 drivers/leds/trigger/ledtrig-netdev.c | 114 +++++++++++++++++++++++---
 include/linux/leds.h                  |   5 ++
 2 files changed, 109 insertions(+), 10 deletions(-)

-- 
2.40.1


