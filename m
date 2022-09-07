Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2AA55AFD8A
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiIGHai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiIGHaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:30:03 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FF13AE56
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 00:29:56 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id bq23so21063787lfb.7
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 00:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=zswrSGfAfSwQr7TVDnWSPJLx++66pscWUAc91FYxSrI=;
        b=Wp1UsSa/v74yp7nAUKayC3h3KfyzAT5PL5WMbBQuUqnvEBoXqM3dxYf+ypDH/3JDc7
         ONxIR0jlCDDlqRLO8nXYYBjHJouFEAk5W5X5hBpF3BaS4MSgvfCUHCVC1G3mPTqkIK92
         Oe8rOqYpraonn5+2WufegKVEh8oJ0sQgZpiMjtIkHVihobdD40xFHfKIJ9ezlV/dOsDF
         aCQ6/mNhJd5bE5GG5vuQk0fXnHr32m9fyGUshKXVIVvP+noeNciAm59z9rHSsSI7VdpT
         Bt1hQlPmjMR2RAtFPc1K9NZFerG5pccsVEOh+mqmSCKwfDb50paFtfmQWMtlOe7/w084
         6mIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=zswrSGfAfSwQr7TVDnWSPJLx++66pscWUAc91FYxSrI=;
        b=FBgdPxIHiM9/yvVKQTs0wR4+1suzCx4POI02XXLv5JTwThmWohqhql4gAv5Y+2YjfC
         WX7BYkyBFfjamrhTtcirN1m1VAveYx/bRmF6INqlNBd/dvAgX23oR39zkMNInoJyEjfe
         0KNEMp5SBpqlL8t1lve86YA9M8JgpGtEoEgdGyhS1gL0bClPKfzbmEMCpM+BPD6ppW31
         YjZ5SzKgYkAaqhj94ebmH4hXjWZlYei1Vgt6KpXqLd9oqxBv6ILxKfyXSZgoTExr41kZ
         5ZrezRax4XWi7R+7J7ffPWmU+LjcQlcnDXRcdFYMyjhal1bHNNcIF7TLpeZDz1HyI9bU
         V1Ew==
X-Gm-Message-State: ACgBeo0ZELOx/VSJsL7RppD6XVOTMqN9U+AJmG6tUcFw/PmE5btJIePl
        bKkvfYRmgkyB3gnhdiJDriOaLmXkJ7B3NHQl
X-Google-Smtp-Source: AA6agR6Obg7PmlAdpGJ8vUROEUiCDExOPyHVs/uixvSOqeBreA6FEkBmEyM1X+IKYYo8/OdPUCUwtg==
X-Received: by 2002:a05:6512:3992:b0:48b:3f6c:9222 with SMTP id j18-20020a056512399200b0048b3f6c9222mr633348lfu.561.1662535794560;
        Wed, 07 Sep 2022 00:29:54 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id w3-20020ac25983000000b0048a83336343sm2275507lfn.252.2022.09.07.00.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 00:29:54 -0700 (PDT)
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
Subject: [PATCH net-next v5 0/6] net: dsa: qca8k, mv88e6xxx: rmon: Add RMU support
Date:   Wed,  7 Sep 2022 09:29:44 +0200
Message-Id: <20220907072950.2329571-1-mattias.forsblad@gmail.com>
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
This is handled by the Remote Management Unit (RMU) in the switch
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
    
v3 -> v4:
  - Separated patches more granular.

v4 -> v5:
  - Some small fixes after feedback.
  
Regards,
Mattias Forsblad

Mattias Forsblad (6):
  net: dsa: mv88e6xxx: Add RMU enable for select switches.
  net: dsa: Add convenience functions for frame handling
  net: dsa: Introduce dsa tagger data operation.
  net: dsa: mv88e6xxxx: Add RMU functionality.
  net: dsa: mv88e6xxx: rmon: Use RMU for reading RMON data
  net: dsa: qca8k: Use new convenience functions

 drivers/net/dsa/mv88e6xxx/Makefile  |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c    |  73 +++++--
 drivers/net/dsa/mv88e6xxx/chip.h    |  21 ++
 drivers/net/dsa/mv88e6xxx/global1.c |  66 ++++++
 drivers/net/dsa/mv88e6xxx/global1.h |   3 +
 drivers/net/dsa/mv88e6xxx/rmu.c     | 309 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/rmu.h     |  28 +++
 drivers/net/dsa/qca/qca8k-8xxx.c    |  61 ++----
 include/net/dsa.h                   |  19 ++
 net/dsa/dsa.c                       |  20 ++
 net/dsa/dsa2.c                      |   2 +
 net/dsa/tag_dsa.c                   |  32 ++-
 12 files changed, 573 insertions(+), 62 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.h

-- 
2.25.1

