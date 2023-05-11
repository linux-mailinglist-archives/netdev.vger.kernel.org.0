Return-Path: <netdev+bounces-1915-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 560FC6FF84F
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 19:21:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6EC521C20C93
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:21:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53C178F58;
	Thu, 11 May 2023 17:21:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EB58F50
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 17:21:19 +0000 (UTC)
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4241626AD;
	Thu, 11 May 2023 10:21:16 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id 6a1803df08f44-61b79b9f45bso80048176d6.3;
        Thu, 11 May 2023 10:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683825675; x=1686417675;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DsHfsvncB2Dyg2euoMr83ZHCM4P0ZmQheB+9N6AzNcg=;
        b=JPzqRMsH0Y3UjTQalZ3j3xJGbXfA2CQHOMu0QKMw2b8kzT3TAJUcKBuxM1BNPsoJMs
         IupQoupJvWVSMuKB8DsRkhn/RqnGoTxW/BkOfPJzzOSW9dhJC6V8/HOW+Uww6Bqm+/+2
         k9zGP/YDAul/t+llqLmHfhA5x79DD1/pJQesqHFMrpsyWkCqjRsbSHZeOVIQhu6jXsQA
         ZG7gGLaeh1C3RoHx8Z802Hyy8lBV0FLdHly4TLbTGTb1EvHahABKg9xaue68SJEh/OAS
         UanxwA62cPGy7gDJNL7bVaP+boeTvSHFrMGbVQ5mzzmYgatRW4rNnuTkVDxWAffNeymw
         Gx9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683825675; x=1686417675;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DsHfsvncB2Dyg2euoMr83ZHCM4P0ZmQheB+9N6AzNcg=;
        b=TRFNXdR9cwvhacLBk+0KEjZUpWKHwoS3PNDzREr5ccu0DCneqNqvnsM7dJI+OK9YDz
         85CDH/SG2vDrjkhU3Br3ynpO3X3SB6Yyc6cyvCV9wTcWAHfLyXTpXD4vxShB+1HqsBJs
         /J4F6QoneCqdhJmTVhjujWOpwoifW6SyU1Ou9ppPaCeWaoC6bhZowLoN6/4Km8LSDmNK
         GzbjEO9jwg26mUQDL/FHW77s+M4IZPVj4IlGFWew2ZYb9yX6FhgPA9yQTY8imJMS/KnB
         D0PVckZf+tvh00vxOOwO28rPUwexScFBySa0OecxK4lDNeRz886jw6qRGuU12EYRd6R3
         AHIg==
X-Gm-Message-State: AC+VfDyIWV84a42xhXIhKFxkupXkZvot1IJqrcNGAOm5MUnYlya1c4yh
	5cH3hiS+NBvQi64YkecpQpiouIZmcg0=
X-Google-Smtp-Source: ACHHUZ5XnvzgjnvU6xNffa62Ov3AwaHnJ84ljiVIdWyiG3gkAZvzAXJ7hwaoSkR4lHijV/sm1WsXrw==
X-Received: by 2002:a05:6214:408:b0:619:3665:7ef8 with SMTP id z8-20020a056214040800b0061936657ef8mr36846808qvx.26.1683825674865;
        Thu, 11 May 2023 10:21:14 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j7-20020a0ce007000000b0062168714c8fsm462822qvk.120.2023.05.11.10.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 10:21:14 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Doug Berger <opendmb@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Peter Geis <pgwipeout@gmail.com>,
	Frank <Frank.Sae@motor-comm.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v3 0/3] Support for Wake-on-LAN for Broadcom PHYs
Date: Thu, 11 May 2023 10:21:07 -0700
Message-Id: <20230511172110.2243275-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
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

This patch series adds support for Wake-on-LAN to the Broadcom PHY
driver. Specifically the BCM54210E/B50212E are capable of supporting
Wake-on-LAN using an external pin typically wired up to a system's GPIO.

These PHY operate a programmable Ethernet MAC destination address
comparator which will fire up an interrupt whenever a match is received.
Because of that, it was necessary to introduce patch #1 which allows the
PHY driver's ->suspend() routine to be called unconditionally. This is
necessary in our case because we need a hook point into the device
suspend/resume flow to enable the wake-up interrupt as late as possible.

Patch #2 adds support for the Broadcom PHY library and driver for
Wake-on-LAN proper with the WAKE_UCAST, WAKE_MCAST, WAKE_BCAST,
WAKE_MAGIC and WAKE_MAGICSECURE. Note that WAKE_FILTER is supportable,
however this will require further discussions and be submitted as a RFC
series later on.

Patch #3 updates the GENET driver to defer to the PHY for Wake-on-LAN if
the PHY supports it, thus allowing the MAC to be powered down to
conserve power.

Changes in v3:

- collected Reviewed-by tags
- explicitly use return 0 in bcm54xx_phy_probe() (Paolo)

Changes in v2:

- introduce PHY_ALWAYS_CALL_SUSPEND and only have the Broadcom PHY
  driver set this flag to minimize changes to the suspend flow to only
  drivers that need it

- corrected possibly uninitialized variable in bcm54xx_set_wakeup_irq
  (Simon)

Florian Fainelli (3):
  net: phy: Allow drivers to always call into ->suspend()
  net: phy: broadcom: Add support for Wake-on-LAN
  net: bcmgenet: Add support for PHY-based Wake-on-LAN

 .../ethernet/broadcom/genet/bcmgenet_wol.c    |  14 ++
 drivers/net/phy/bcm-phy-lib.c                 | 212 ++++++++++++++++++
 drivers/net/phy/bcm-phy-lib.h                 |   5 +
 drivers/net/phy/broadcom.c                    | 126 ++++++++++-
 drivers/net/phy/phy_device.c                  |   5 +-
 include/linux/brcmphy.h                       |  55 +++++
 include/linux/phy.h                           |   4 +
 7 files changed, 416 insertions(+), 5 deletions(-)

-- 
2.34.1


