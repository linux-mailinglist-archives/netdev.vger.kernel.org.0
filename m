Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777DB67BB02
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 20:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbjAYTvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 14:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235327AbjAYTvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 14:51:08 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA0A2ED61
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 11:51:04 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id nd31so34833ejc.8
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 11:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zCu9ReBp8rsUO7BPnJkennx1RK9hssnXuHiiktJzKeY=;
        b=t0nV3aR/PpIjUcTvkuLzezyONXZoGiYlCSyzddvcFBdl1eRAIwg6doXK+FpyXwM7ps
         q/FAjrEdff4IjIwjZfezT1VIyxIH/vTDHxvDT10L+c5Y0DNAlq8L3rKQ17ot0EGAeHWC
         LuHJkj26o0qYMm85yao9HuvfDsMBOdX1ESIaZ0I8iJtk+NNHzR6qZWU3lvMgJ3kAmXa6
         gneikFnIHIiiuFBeZRRPxQxmDRGLYecZjkMQ89NMK1G3f6VsyMGegGhbVE3vmL1I2uUW
         1tA7AaJI0EEBkdOpLVkkz+G8JHnWDuSq9qoDGCxs6K+mt0hTzwv+/SXK/Bj+yVLSHrvP
         T6gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zCu9ReBp8rsUO7BPnJkennx1RK9hssnXuHiiktJzKeY=;
        b=0xIbyYSNkKy1+AVobCuOevgQcbkm5fTKbqovkqrlqTGtUm8qPqhbl4WdHOdFCJZXgP
         /A9p42DrHP82QuRC/s3tCfpwt2YczvnHmRO+F/YcVDsoPLpYjRQKp2/3UL8OgwUQljgM
         pbVm4jRcGFJXcppfg/fHfkFLG8gqtyGxd3+S5tiGaIlk2JKJZdLvfaJGRY/lEcxFWkby
         yy071GCZiAsy4YiTJ9E/A9Mzi34Re0nL+ov5lcRkhrJW6S+gFLnIYBc3Pg8U6GS6vgfy
         LXPHhT6dMiKcZCkOLdXEol+zZBZvyye6ICvp27ZLzWjcS5dtcT+KrDJBsVx1dh/e1eCN
         +UYA==
X-Gm-Message-State: AFqh2kru9iejsXLAsVR6EkmRztgDuUOky71GFBxh+cahRLQB/23LKIfp
        jqLHyal04PqUlZiuSnwoVQUhcw==
X-Google-Smtp-Source: AMrXdXv15kHa1dGmlL79wyog14d50xdg7+O1i+O7wOxn7Vzp9LxrmOLhHmtM/BEYVKhhwJFvIsK8Hg==
X-Received: by 2002:a17:907:1dcd:b0:877:6288:eff2 with SMTP id og13-20020a1709071dcd00b008776288eff2mr28762238ejc.75.1674676264497;
        Wed, 25 Jan 2023 11:51:04 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a247:815f:ef74:e427:628a:752c])
        by smtp.gmail.com with ESMTPSA id s15-20020a170906454f00b00872c0bccab2sm2778830ejq.35.2023.01.25.11.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 11:51:04 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH v2 00/18] can: m_can: Optimizations for m_can/tcan part 2
Date:   Wed, 25 Jan 2023 20:50:41 +0100
Message-Id: <20230125195059.630377-1-msp@baylibre.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc and everyone,

second version part 2, I fixed the bug I noticed for integrated m_can
devices. The accounting was wrong or missing for these. I don't have the
integrated hardware myself so any testing is appreciated (I only have
the tcan device to test the mcan driver). Also v2 rebases on top of
v6.2-rc5.

The series implements many small and bigger throughput improvements and
adds rx/tx coalescing at the end.

Best,
Markus

Changes in v2:
- Rebased on v6.2-rc5
- Fixed missing/broken accounting for non peripheral m_can devices.

part 1:
v1 - https://lore.kernel.org/lkml/20221116205308.2996556-1-msp@baylibre.com
v2 - https://lore.kernel.org/lkml/20221206115728.1056014-1-msp@baylibre.com

part 2:
v1 - https://lore.kernel.org/lkml/20221221152537.751564-1-msp@baylibre.com

Markus Schneider-Pargmann (18):
  can: tcan4x5x: Remove reserved register 0x814 from writable table
  can: tcan4x5x: Check size of mram configuration
  can: m_can: Remove repeated check for is_peripheral
  can: m_can: Always acknowledge all interrupts
  can: m_can: Remove double interrupt enable
  can: m_can: Disable unused interrupts
  can: m_can: Keep interrupts enabled during peripheral read
  can: m_can: Write transmit header and data in one transaction
  can: m_can: Implement receive coalescing
  can: m_can: Implement transmit coalescing
  can: m_can: Add rx coalescing ethtool support
  can: m_can: Add tx coalescing ethtool support
  can: m_can: Cache tx putidx
  can: m_can: Use the workqueue as queue
  can: m_can: Introduce a tx_fifo_in_flight counter
  can: m_can: Use tx_fifo_in_flight for netif_queue control
  can: m_can: Implement BQL
  can: m_can: Implement transmit submission coalescing

 drivers/net/can/m_can/m_can.c           | 514 ++++++++++++++++++------
 drivers/net/can/m_can/m_can.h           |  36 +-
 drivers/net/can/m_can/tcan4x5x-core.c   |   5 +
 drivers/net/can/m_can/tcan4x5x-regmap.c |   1 -
 4 files changed, 432 insertions(+), 124 deletions(-)

-- 
2.39.0

