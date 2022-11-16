Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D59962CB8B
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbiKPUyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238581AbiKPUxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:53:43 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64FBB16
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:24 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id f7so28454097edc.6
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CYWMMUbBw93RRaB82Tv6rmjWQ7OjIXTvTPik8qxDxCo=;
        b=rTDy/jgYPCRzE6NdKcp1p40vLzuwCFilt4GMZ2KgsYOwc3AeCM+94KSaGrZKLYKxFG
         opmzxtk5xRCS5WSeC565gaVF4DdshwC1HSRqklfwYr7WJ+S0owa0wHj3IbmeF8U1T4i7
         6RiyePLsWNqDFSqXEFhJCNuyBMF6k4Yb7ur9DPggsh6q8H5JA4FmNPH5NuR0vw5ngGgX
         EpYPw123nxWG7VbD4qJmqj19F3NVD0pF4BS+TSEKNlxF5l8N1f3xyN6mpRnn/CsSlGp6
         3rLhBMS8WxVlXUhSQSd6FVwmIqlHmbypQP6abng742u05WM1o/YX6VCFz2FMNznvbHgS
         ybZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CYWMMUbBw93RRaB82Tv6rmjWQ7OjIXTvTPik8qxDxCo=;
        b=jvxP3v97A6MWnLXosA1iV8szcs1aaSJbgkMnN5+ZUYJSb8UivYAvkv+GAdpofedCm0
         ZSKKgOuVBMsomTTLpcrze2wyKtjT88N3bpOkQPBVZnvDDjEHHqfoHYgeg2esoJxRzInF
         66DtaFj5ICC77LDq4OTwVOiFKXnewOM1QHs4DI4TPnq1lHy6qWjO87tCbcsE+upQtfkh
         YBzljNZaWadxRccuO4psiv+cUW/V9trrY1JnLNktIsOymCqZH2Z0kWwOp/MnDyT8/Md3
         CZPubEFApy2xR95WdzW5aGC5UTOGw36VAyCamZB2hs6gyaAP1i0wYkyXDRcmMHvTTCtK
         +ubQ==
X-Gm-Message-State: ANoB5pkyIecHNCPb5evHgHDOJHHudu7cLWRC+hl/AjDMlVXPrXoCgwRz
        ys9J0SJGmXYvmQmnHmPeAls32LNFxv4RwQ==
X-Google-Smtp-Source: AA0mqf5GghMPuf8/49SrUqtwUrDtiDsBaRv1sxhvM2kqZAgVR5XZuviSvJwLzzJB0XDNHiDQmj6t4A==
X-Received: by 2002:a05:6402:f8d:b0:461:8f21:5f12 with SMTP id eh13-20020a0564020f8d00b004618f215f12mr20896599edb.54.1668632003246;
        Wed, 16 Nov 2022 12:53:23 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4090:a244:804b:353b:565:addf:3aa7])
        by smtp.gmail.com with ESMTPSA id kv17-20020a17090778d100b007aece68483csm6782828ejc.193.2022.11.16.12.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 12:53:22 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 00/15] can: m_can: Optimizations for tcan and peripheral chips
Date:   Wed, 16 Nov 2022 21:52:53 +0100
Message-Id: <20221116205308.2996556-1-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this series is aimed at optimizing the driver code for tcan chips and
more generally for peripheral m_can chips.

I did different things to improve the performance:
- Reduce the number of SPI transfers.
- Reduce the number of interrupts.
- Enable use of FIFOs.

I am working with a tcan4550 in loopback mode attached to a beaglebone
black. I am currently working on optimizing the receive path as well
which will be submitted in another series once it is done.

Best,
Markus

Markus Schneider-Pargmann (15):
  can: m_can: Eliminate double read of TXFQS in tx_handler
  can: m_can: Wakeup net queue once tx was issued
  can: m_can: Cache tx putidx and transmits in flight
  can: m_can: Use transmit event FIFO watermark level interrupt
  can: m_can: Disable unused interrupts
  can: m_can: Avoid reading irqstatus twice
  can: m_can: Read register PSR only on error
  can: m_can: Count TXE FIFO getidx in the driver
  can: m_can: Count read getindex in the driver
  can: m_can: Batch acknowledge rx fifo
  can: m_can: Batch acknowledge transmit events
  can: tcan4x5x: Remove invalid write in clear_interrupts
  can: tcan4x5x: Fix use of register error status mask
  can: tcan4x5x: Fix register range of first block
  can: tcan4x5x: Specify separate read/write ranges

 drivers/net/can/m_can/m_can.c           | 140 +++++++++++++++---------
 drivers/net/can/m_can/m_can.h           |   5 +
 drivers/net/can/m_can/tcan4x5x-core.c   |  19 ++--
 drivers/net/can/m_can/tcan4x5x-regmap.c |  45 ++++++--
 4 files changed, 141 insertions(+), 68 deletions(-)


base-commit: 094226ad94f471a9f19e8f8e7140a09c2625abaa
prerequisite-patch-id: e9df6751d43bb0d1e3b8938d7e93bc1cfa22cef2
prerequisite-patch-id: dad9ec37af766bcafe54cb156f896267a0f47fe1
prerequisite-patch-id: f4e6f1a213a31df2741a5fa3baa87aa45ef6707a
-- 
2.38.1

