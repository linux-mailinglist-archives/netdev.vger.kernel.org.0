Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259515B6BCE
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 12:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiIMKnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 06:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiIMKnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 06:43:35 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735045D130
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 03:43:33 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id y29so13838732ljq.7
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 03:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=Vq8/PRczN4ihZrPt2Pl6kyC/w/jCXjeEmHL3KorHIhk=;
        b=KAQR9CZ3J51t6ZPAn4NYc7kz9681thUB0sAlWXKnyRv2Ih4YkgAhQv/1Gvpnm60u78
         plCKr3DkcKKePytr0/GslAnaCPaJ+qDYY2aDrKtR6IJ9eIfpwV6m9zHCpRrli0NpOLvp
         ES81Rnl0e5Y0BgOWL8yym+WhRu0x8ixtowGtwEkaUQDTAUhu/mF66NyQ5S4G3R4V7kYc
         GhTyxG3XMhxsrepPc+AUddymfWUoLZoE/aLgBUoET3wlryBfbm1W2BwRzylybDoyX7RQ
         mae++Dr/iqSlx/im/tiuYc0BjRg8DhFQ5mU3uBmiozRTyGI6vVhX3kpEKBl60graziCw
         d/sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=Vq8/PRczN4ihZrPt2Pl6kyC/w/jCXjeEmHL3KorHIhk=;
        b=i166TiqHq8aXa7i03A7hQhNVa4B+UI4+2DvC8syAyvdQe+oSY7AWPnq7T1RSx3gMJl
         lv6XRyRtZ6+jM+gEOUXLyEjTYMuY3pUsgxmRG0q1wcWGrDKaSU8yyfNkIQZKDn8LbcM7
         9ghvn3aFkc2dVPFJYezASu+aseZfnSoGXAX3dfue2mhzwoPOMgyVi0LkBs1bXXzPsfrg
         AoqyBBT0FuoE0di4o/ogu1AnqbLmBdCq5p9Pk9ER1H8U92k8ptWtdRfR9+vHqk3moP0s
         Fikd3DGmZnFIOsimhsJEdQ1sNHKHX90+kF2J3e8rg1BL0w8qqJPiKLSjKc+0sN/fiOSE
         bncg==
X-Gm-Message-State: ACgBeo2+tokneSdGJqyLfADWrTq+P67fgxGTqA/7SiQaZsXM07+OUjKT
        Kdtb2AtPBzBQnqk+W5itBDbpSQ76CQ+N2IkZ
X-Google-Smtp-Source: AA6agR5ZPAZTbLM2Yg3XK6ATNM6iVt1VN+UhfzNHytBpuXPBcJay7ZwAB98JB6Jg4kpM/7FZo+fF4g==
X-Received: by 2002:a05:651c:199f:b0:26c:1467:2374 with SMTP id bx31-20020a05651c199f00b0026c14672374mr1335022ljb.63.1663065811405;
        Tue, 13 Sep 2022 03:43:31 -0700 (PDT)
Received: from wse-c0089.westermo.com (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id i2-20020a2ea362000000b0026bf27c7056sm1018946ljn.67.2022.09.13.03.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 03:43:30 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next v10 0/6] net: dsa: qca8k, mv88e6xxx: rmon: Add RMU support
Date:   Tue, 13 Sep 2022 12:43:14 +0200
Message-Id: <20220913104320.471673-1-mattias.forsblad@gmail.com>
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

v5 -> v6:
  - Rewrite of send_wait function to more adhere
    to RPC standards
  - Cleanup of ops handling
  - Move get id to when master device is available.

v6 -> v7:
  - Some minor cleanups.

v7 -> v8:
  - Moved defines to header file.
  - Check RMU response length and return actual
    length received.
  - Added disable/enable helpers for RMU.
  - Fixed some error paths.

v8 -> v9:
  - Naming consistency for parameters/functions.
  - Streamlined completion routines.
  - Moved completion init earlier.
  - Spelling corrected.
  - Moved dsa_tagger_data declaration.
  - Minimal frame2reg decoding in tag_dsa.
  - Fixed return codes.
  - Use convenience functions.
  - Streamlined function parameters.
  - Fixed error path when master device changes
    state.
  - Still verify MAC address (per request of Andrew Lunn)
  - Use skb_get instead of skb_copy
  - Prefix defines and structs correctly.
  - Change types to __beXX.

v9 -> v10:
  - Patchworks feedback fixed.
  
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
 drivers/net/dsa/mv88e6xxx/chip.c    |  70 +++++--
 drivers/net/dsa/mv88e6xxx/chip.h    |  24 +++
 drivers/net/dsa/mv88e6xxx/global1.c |  64 ++++++
 drivers/net/dsa/mv88e6xxx/global1.h |   3 +
 drivers/net/dsa/mv88e6xxx/rmu.c     | 311 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/rmu.h     |  73 +++++++
 drivers/net/dsa/mv88e6xxx/smi.c     |   3 +
 drivers/net/dsa/qca/qca8k-8xxx.c    |  61 ++----
 include/linux/dsa/mv88e6xxx.h       |   6 +
 include/net/dsa.h                   |  11 +
 net/dsa/dsa.c                       |  17 ++
 net/dsa/dsa2.c                      |   2 +
 net/dsa/dsa_priv.h                  |   2 +
 net/dsa/tag_dsa.c                   |  40 +++-
 15 files changed, 624 insertions(+), 64 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.h

-- 
2.25.1

