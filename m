Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008CF653327
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 16:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbiLUPZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 10:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiLUPZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 10:25:45 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616ACDC5
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:42 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id s5so22401814edc.12
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e2mkku343U5D/UFeX6GPxNJ2xnofRb9nj6juvn1mIAg=;
        b=UabexA0/CRsCXfwCSv8pNmuh3PvQl3OpCyLgITIz3S7q1+tTnGdqNfTJzjgg62mRcI
         gxE9n6cdka3y/Fh1yel4m+5E5DDpMCTQP+rVgZ9bqfGv+RMwjkgY4jApbfwLX7ls5+B2
         kqPw7ixGW+u4cvthuLYRoGocxctUnOsI+sbyenES+ObkJ304Kb6IfJYVBxoPQjVVeMKJ
         W0tE6IXzzdUGVjolKsHBnZRSJHJePZPQUJAse8fjNQ5ptJvRZ71WNZhq7tBxRmcQ6tMB
         HRsEypzKIgHLmGB+u7B1GUET2xgkfxqfTf0OZC3HY0Pn5Hh5ZyWpYRb9Tg0S8cKLpLIi
         zDcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e2mkku343U5D/UFeX6GPxNJ2xnofRb9nj6juvn1mIAg=;
        b=61mMjXl9WNjrmRx9PCVqmf88t91wsLJZG1K35HeFVS8mLFfMDBO9KHpRjvAdJ+q1pJ
         LMxSZ65l5YHSkX6+l9GR6xwbTSDrt7y7jQkr59D4608eN1b/Uv9err+7aEBBIBnCWxNp
         kcxLow43Ehpx3eu0jowr30OvOwUPV5g8itNvfw6RV/DClnXmGHcq0ZnsK+Ep99VjhZ/r
         Ml9WoHdCVqyTKBTVqBpxHYaiGeVaQbzzXwCLb4mMgkehVqTEpZ6KWavDNq7uCpPXpeOB
         kISd6hijHRmZQryvs/eGHeGP6qGU11hCUbvlRPW68Te58APpGNxhK9SuIKddbnO62M3X
         B5QA==
X-Gm-Message-State: AFqh2koP5RamAbIFnPRSucwRZZ1ErIoWM9AUerzM/rHppbIuHKp9B71Y
        TbLBytN/sE0apPNJD+Lg2UzyAg==
X-Google-Smtp-Source: AMrXdXuWgi9Ls253r6P2zIs/ZhDmWFBRs2hmO7z7cBibYROYhfNI9Zytz5qR/nOtGvuAlnxn/7Lm5Q==
X-Received: by 2002:a05:6402:5285:b0:45c:834b:eb5f with SMTP id en5-20020a056402528500b0045c834beb5fmr2082155edb.42.1671636340912;
        Wed, 21 Dec 2022 07:25:40 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id n19-20020aa7c793000000b0045cf4f72b04sm7105428eds.94.2022.12.21.07.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 07:25:40 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 00/18] can: m_can: Optimizations for m_can/tcan part 2
Date:   Wed, 21 Dec 2022 16:25:19 +0100
Message-Id: <20221221152537.751564-1-msp@baylibre.com>
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

Hi Marc and everyone,

this is the second part now. I know it is the merge window right now but
I am quite sure this won't be merged immediately anyways, so if you have
some time for some comments I would appreciate it. So it is still based
on v6.1-rc8 + the patches that got applied.

I tried to do as small patches as possible so it is easier to
understand. The series changed a lot compared to v1 I sent so I didn't
call it v2. There are a lot of new patches as well.

The series contains a few small fixes and optimizations at the
beginning, then adding coalescing support and at the end removing the
restrictions on the number of parallel transmits in flight.

Note that the last patch 'Implement transmit submission coalescing' does
not perform well for me in a loopback testing setup. However I think it
may work well in normal testcases. I attached this mechanism to the
tx-frames coalescing option, let me know if this is the correct option.

Best,
Markus

part 1:
v1 - https://lore.kernel.org/lkml/20221116205308.2996556-1-msp@baylibre.com
v2 - https://lore.kernel.org/lkml/20221206115728.1056014-1-msp@baylibre.com

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

 drivers/net/can/m_can/m_can.c           | 498 ++++++++++++++++++------
 drivers/net/can/m_can/m_can.h           |  36 +-
 drivers/net/can/m_can/tcan4x5x-core.c   |   5 +
 drivers/net/can/m_can/tcan4x5x-regmap.c |   1 -
 4 files changed, 418 insertions(+), 122 deletions(-)

-- 
2.38.1

