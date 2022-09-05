Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55A75AD3AB
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 15:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237504AbiIENTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 09:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237502AbiIENTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 09:19:24 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01BABF7
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 06:19:22 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id q7so13118355lfu.5
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 06:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=J32qWZvUNqjw3r9Vcy6J95uFH1l8K45wpNU02jpK7q4=;
        b=JpyyR/CKOrR05MOE/nSLkKZvez4JyQg1EiTrg54Woqpgmn97B5mAzVUWFVlojk9+mF
         K1/S6pOXcvmZARO04ksRq7lgJiyYqXz0o/SerOWug/1LOkd80RxqAFE4NKe10D5I+llm
         YylOi5YSucN3Y0VETdn+dSG1vEpD9mLyZMC0Lp6kdluOImWx48w0b10FkT5K13V3JZpS
         bqlO4b09Kc8PuCwAVb7IggWf8orAwuqcmxBQPksOe6LiMSzw891mviBUWxluUFganglJ
         ajzDX4wuMPvPepPCayFwiHHrUzTGy53HeKHFjtwgLffE9H1HwXEPIsSkYUlrdlFOMolt
         3a7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=J32qWZvUNqjw3r9Vcy6J95uFH1l8K45wpNU02jpK7q4=;
        b=YQQPlKNvx0SnG0PRDsaBMaQfnmqok5sUFS3mAfXZX6/cxjkEGhYFOUFurFJIFIe1NR
         +RHx+i9EzNzvVpJz4DLVKXQOL0fXmkBMZXxtqtohbpPpnz1+1Px/oYIbSpYf12uD0D1J
         AN6aBpMDcQllqvoHKmT1R1Hg1eOUAR1H8obwgP+vdiDJ/V8T49vQT/KZoNJeUczhOACb
         ueFhpRh2QxuzO79F1W54ZFlxM1K1PUwMGySNNRe/yBz/Q4MMogrV7aVf4vV9rZWhMqPc
         EF2ldXR9PFwlxdKGzj7/3RH1LMVsDAeCUJ6uxvLordyz3BctGkSBValJsTD3F8YcpLfl
         xnJg==
X-Gm-Message-State: ACgBeo0WgFpb/nklNWCVTUOffXTDvSol1KuDUIzOu37cRvnXjPR8n3+M
        9e5uJdSXamWVvX3WFy4OfgHMxKYeaddRj80V
X-Google-Smtp-Source: AA6agR5753iiVFpA1lqsuGxgVO/i9EHRc73tusl3FzPhpxoKC9Ag5jo/r+oD90k7v7jnD2HaSBlpgw==
X-Received: by 2002:a19:654d:0:b0:492:f132:7963 with SMTP id c13-20020a19654d000000b00492f1327963mr16470492lfj.578.1662383960843;
        Mon, 05 Sep 2022 06:19:20 -0700 (PDT)
Received: from wse-c0089.westermo.com (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id u14-20020a05651220ce00b004947fcf0c0bsm1183565lfr.281.2022.09.05.06.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 06:19:20 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next v3 0/2] net: dsa: mv88e6xxx: qca8k: Add RMU support
Date:   Mon,  5 Sep 2022 15:19:15 +0200
Message-Id: <20220905131917.3643193-1-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Marvell SOHO switches have the ability to receive and transmit
Remote Management Frames (Frame2Reg) to the CPU through the
attached network interface.
This is handled by the Remote Management Unit (RMU).
These frames can contain different payloads:
single switch register read and writes, daisy chained switch
register read and writes, RMON/MIB dump/dump clear and ATU dump.
The dump functions are very costly over MDIO but it's
only a couple of network packets via the RMU.

Next step could be to implement ATU dump.
We've found that the gain to use RMU for single register
read and writes is neglible.

qca8k
=====
There's a newly introduced convenience function for sending
and waiting for frames. Changes have been made for the qca8k
driver to use this. Please test for regressions.

RFC -> v1:
  - Track master interface availability.
  - Validate destination MAC for incoming frames.
  - Rate limit outputs.
  - Cleanup setup function validating upstream port on switch.
  - Fix return values when setting up RMU.
  - Prefix defines correctly.
  - Fix aligned accesses.
  - Validate that switch exists for incoming frames.
  - Split RMON stats function.

v1 -> v2:
  - Remove unused variable.

v2 -> v3:
  - Rewrite after feedback. Use tagger_data to handle
    frames more like qca8k.
  - qca8k: Change to use convenience functions introduced.
    Requesting test of this.
  
Regards,
Mattias Forsblad

Mattias Forsblad (2):
  net: dsa: mv88e6xxx: Add functionality for handling RMU frames.
  net: qca8k: Use convenience function for sending frames.

 drivers/net/dsa/mv88e6xxx/Makefile  |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c    |  73 +++++--
 drivers/net/dsa/mv88e6xxx/chip.h    |  21 ++
 drivers/net/dsa/mv88e6xxx/global1.c |  76 +++++++
 drivers/net/dsa/mv88e6xxx/global1.h |   3 +
 drivers/net/dsa/mv88e6xxx/rmu.c     | 310 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/rmu.h     |  28 +++
 drivers/net/dsa/qca/qca8k-8xxx.c    |  61 ++----
 include/net/dsa.h                   |  20 +-
 net/dsa/dsa.c                       |  28 +++
 net/dsa/dsa2.c                      |   2 +
 net/dsa/tag_dsa.c                   |  32 ++-
 12 files changed, 592 insertions(+), 63 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.h

-- 
2.25.1

