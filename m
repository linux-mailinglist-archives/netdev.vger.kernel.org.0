Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E9A5B80ED
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 07:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiINFau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 01:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiINFas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 01:30:48 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6705061D7A
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 22:30:46 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id r12so15310044ljg.10
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 22:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=rSkoxcBHDHvpvb/ofSqzGk/NAewsextL5YpXL/CAlnI=;
        b=BCY8BQ3RHnsNixgn1+TNRao0CijNLCyTeEfbGCWWQC9k1g7Xk512QCsa3HqADhDrGl
         kZvfWMW/yAoD6fYXTT6Kf/KhOaD3J8iO9GUAlahnzQOjdz5wr5aiXwggAFZfBpjsQ+WG
         yT16AA9G3XOmE0GD6zGnINztOp6qwMcBUHUcGII+ZfmRfwlTgZE9+ilAFgpq2HToF0bv
         FoxXGnNEwJzSSU5MLwAMrxhhmhAz7d3bsXiALdNroZQcXP2jAdLWFbhlHl7GjAdLBtUi
         HvUggjh0BL4MCd4YB2uwEcpazoCChGyDda56PsXF63y8SZ1vZAmFDMVlX9+e14ucY2KX
         rzHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=rSkoxcBHDHvpvb/ofSqzGk/NAewsextL5YpXL/CAlnI=;
        b=u4DJcjL6fZSpCrkVHOZwNJCJ0NuIMQa+vTo29Mqw2Ix+PI9m6IzyR3xWhT2Lr5v+gr
         OGzwC7zevOYkiPuyLjLMmOIzS5BnPBJeMnZTHP6Xv5a+wle6tvKu8I1mZ4BT5HKugJSM
         Cl92TuVsYJ7B95gxlZjOwihLCg8oKIBUWi57rPs0mZ4ga+YUeOOOgFGv5BPlNBmMJbJ1
         MwmMDqkSzwZN4QJPtbeb/cWAxVs6NyYjpEzM8gybmUvGnKn8zUTou4yDI2aV6B1BZLMo
         2DVUTJNJf3JltQ8lBar49iKOpMu0eG9YSYUOAfFS0UptQGoiV/81aoovAPtK/KfM8yuC
         lbWw==
X-Gm-Message-State: ACgBeo3EUWtq6oEFLrfG5kzH9/wpim4Rm5J6xJdzINvOmtN1JfXGu75T
        1OGp/v3V1jz936rqOMKehGrHKlF/TPmghsp6
X-Google-Smtp-Source: AA6agR4v8VZHfQF0XSSpajz/TeFmCoK7bJeYcw3HMlqgcTkbiY3wwf93r9XS1vd8sHo/I8DiWbBUZQ==
X-Received: by 2002:a2e:940f:0:b0:261:b9ca:6207 with SMTP id i15-20020a2e940f000000b00261b9ca6207mr10553716ljh.192.1663133444417;
        Tue, 13 Sep 2022 22:30:44 -0700 (PDT)
Received: from wse-c0089.westermo.com (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id f16-20020a05651c03d000b0026c297a9e11sm53814ljp.133.2022.09.13.22.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 22:30:43 -0700 (PDT)
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
Subject: [PATCH net-next v11 0/6] net: dsa: qca8k, mv88e6xxx: rmon: Add RMU support
Date:   Wed, 14 Sep 2022 07:30:35 +0200
Message-Id: <20220914053041.1615876-1-mattias.forsblad@gmail.com>
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

v10 -> v11:
  - Fixed sparse warnings.

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

