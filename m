Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6735A5ADFE0
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 08:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238468AbiIFGfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 02:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238440AbiIFGe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 02:34:58 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AEB01263A
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 23:34:56 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id z25so15901075lfr.2
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 23:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=8yAZ4Ndbc9hPaKI5qUJI5ZeXC+JGvWpbPC+NrXKmwDE=;
        b=GF0oqjWJx5mN83hoLQoX5jrRF3ABZd/Dj++fLqPHwx4ATv7O3q7H7lVq62D562gk2I
         lIkJS/rP0jeixp2gSA59V4Ooq9cyZDkr1jQ50Jf9CFoY8w+dIDvNxDhE/QI2vjVnejyM
         YlvIQK3FbMz7TzOcGBEyO4IJmijn29oz7vKJ+EMVIh19DzJDmV1OGqm67/+ff3yNX//q
         oSkN49OCsev6+oz0vD8Viiuex7LGua5PTKH1wOIoEqVy6qSs3h5pwy9FNWV9HljmOaLB
         Wp+If9s/hMdjqyJTf1uIezuWnRfFQ+uI9ANrXgpaSf4dHQrJyn840+xS9Y/bqzZ+zeoo
         LaXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=8yAZ4Ndbc9hPaKI5qUJI5ZeXC+JGvWpbPC+NrXKmwDE=;
        b=Ub9vWLbd3OHbbbfHDbjOcUQgRBX5HJBVHvgDsS4EFGCVJMedgWN00bO3eZfnafN1bO
         svs6b/BVK4V8VZJYwGeSVkm0rgeA/8CP0beXZX31whyxlF+KuyCZKD/qE8UZ6g7OHcAb
         GmXb7b7vktbrl1Z2skVLoQ8uKRIIXOL+Wd8RjsWh5zIasuZEJ3H4fl+zRf/6fFyByrNc
         Ly6skyBJ9+Vfp75W15ffTPEoV4nNI4A83+Cj/byvS3R3DKL7+i1Y3FGi69M7wwjehP9r
         NDh9n6PyfsK3STWl74rKbkqYbHyNTv3fMSy7cL+XMxQUsStlF716vDhUpEPdTM5XBL4z
         3Yfg==
X-Gm-Message-State: ACgBeo3VcCFXYGaYcqCktQs4Ar46lcgWi58afYiZKOox8b4O7ZOCPBAg
        LVMIS08MXsr+7pcyMTPtC4VtuZP1g4yoeTRV
X-Google-Smtp-Source: AA6agR5q3OQtSuAjaLVmTYR1OGfxux+UDD4023y7ubP8MrACEzoI1b979LLY6WrUc/R20BKn/WAITA==
X-Received: by 2002:a05:6512:2248:b0:48a:f8f9:3745 with SMTP id i8-20020a056512224800b0048af8f93745mr16175789lfu.256.1662446094494;
        Mon, 05 Sep 2022 23:34:54 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id z12-20020a2e8e8c000000b00261bf4e9f90sm1646924ljk.66.2022.09.05.23.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 23:34:53 -0700 (PDT)
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
Subject: [PATCH net-next v4 0/6] net: dsa: mv88e6xxx: qca8k: rmon: Add RMU support
Date:   Tue,  6 Sep 2022 08:34:44 +0200
Message-Id: <20220906063450.3698671-1-mattias.forsblad@gmail.com>
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
 drivers/net/dsa/mv88e6xxx/global1.c |  76 +++++++
 drivers/net/dsa/mv88e6xxx/global1.h |   3 +
 drivers/net/dsa/mv88e6xxx/rmu.c     | 307 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/rmu.h     |  28 +++
 drivers/net/dsa/qca/qca8k-8xxx.c    |  61 ++----
 include/net/dsa.h                   |  18 ++
 net/dsa/dsa.c                       |  28 +++
 net/dsa/dsa2.c                      |   2 +
 net/dsa/tag_dsa.c                   |  32 ++-
 12 files changed, 588 insertions(+), 62 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.h

-- 
2.25.1

