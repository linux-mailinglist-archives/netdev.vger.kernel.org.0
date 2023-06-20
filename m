Return-Path: <netdev+bounces-12208-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A29BB736B2B
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:41:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2E161C20B9E
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 11:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FBF714AA6;
	Tue, 20 Jun 2023 11:41:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A77314262
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 11:41:01 +0000 (UTC)
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550ACE71
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:40:59 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-4f867700f36so3872423e87.0
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google; t=1687261256; x=1689853256;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wR3UhI9Px6pcSpLtyKW9Hd7WsxrSJTWg4zx4ad17nMs=;
        b=QRWWnpSCq0KXZlXJwV2+G1Ek0GR0s69ya8kvNoy6iQ3xjs4p3k5ohlA8K+ofWwkGP7
         UpPxtDTYeAI812rYxp/H9dB2RmuyX6NDlC0e7j1aGhQiR/O99SwNLGYrFxpUGWptI/IP
         951fmr88HC1UohE0RBYLWOGL8Rgb17PaaTNCE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687261256; x=1689853256;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wR3UhI9Px6pcSpLtyKW9Hd7WsxrSJTWg4zx4ad17nMs=;
        b=hMtWLa2+CiS4ry/4imXLw/Acb5ZrhciyGCTww7O8q9s4tanyycLWalZjx6xpC9+5Xm
         IZi4gv/T1Xn2ET9N2hnbRiysNreIvxup5oMC4Gr4O7K7yKiRB686/2H4MMwukAbCGbc0
         9qg02PdmH/XARsKaWIpNt65xCi4/xVQlo61EV/B7RyoM1x2tPKlYpvn+T+68woHKE7qx
         7AWJcZ3peFr3999yJKGARxq3ABwpgXEFSVCYkaFXAF+0iC7pQRcDk3Jqho1FFx/O1z+j
         812M8nN+fdSLAI7QxUA8/WgStX2/hacXdIYfSEhADMSK2e2UwwNZ1oV/tT8hnDDlP4Ok
         Cm/Q==
X-Gm-Message-State: AC+VfDxfzLSlffO+6JMTIODmFAeeiwTZKv0H348HChUxyUQ6lSWRV06T
	xldWE6Q/nmQlxoFB34r7gU2mHg==
X-Google-Smtp-Source: ACHHUZ6A7kVJNkFsn+BH2hHUMaLcTITzl7R7pmguVWQ+irWwJN0drVojSM1MHj0yPz84vP6Coc6jbw==
X-Received: by 2002:a19:f201:0:b0:4f7:42de:3a8f with SMTP id q1-20020a19f201000000b004f742de3a8fmr6438174lfh.56.1687261253812;
        Tue, 20 Jun 2023 04:40:53 -0700 (PDT)
Received: from localhost.localdomain ([87.54.42.112])
        by smtp.gmail.com with ESMTPSA id d12-20020ac2544c000000b004f84162e08bsm329879lfn.185.2023.06.20.04.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 04:40:53 -0700 (PDT)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Woojung Huh <woojung.huh@microchip.com>,
	UNGLinuxDriver@microchip.com,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH net-next 0/3] net: dsa: microchip: fix writes to phy registers >= 0x10
Date: Tue, 20 Jun 2023 13:38:51 +0200
Message-Id: <20230620113855.733526-1-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Patch 1 is just a simplification, technically unrelated to the other
two patches. But it would be a bit inconsistent to have the new
ksz_prmw32() introduced in patch 2 use ksz_rmw32() while leaving
ksz_prmw8() as-is.

The actual fix is of course patch 3. I can definitely see some weird
behaviour on our ksz9567 when writing to phy registers 0x1e and 0x1f
(with phytool from userspace), though it does not seem that the effect
is always to write zeroes to the buddy register as the errata sheet
says would be the case. In our case, the switch is connected via i2c;
I hope somebody with other switches and/or the SPI variants can test
this.

Rasmus Villemoes (3):
  net: dsa: microchip: simplify ksz_prmw8()
  net: dsa: microchip: add ksz_prmw32() helper
  net: dsa: microchip: fix writes to phy registers >= 0x10

 drivers/net/dsa/microchip/ksz9477.c    | 18 +++++++++++++++++-
 drivers/net/dsa/microchip/ksz_common.h | 18 ++++++++----------
 2 files changed, 25 insertions(+), 11 deletions(-)

-- 
2.37.2


