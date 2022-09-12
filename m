Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E843A5B5949
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 13:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiILL3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 07:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiILL3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 07:29:03 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B912A24E
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 04:29:02 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id f9so13589529lfr.3
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 04:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=YT55JpVvjwUC2dv/uV7bRDwoqFbA6WahpDDl+cLEfYI=;
        b=Tni9ezJzW5lDTrpPoe9mTZiI/elTy0XbSd30/ucVr0TFNV2dAdJWvrtl3PHK/nPuxm
         dIAS2YZt4IjjFmVewEkHo865aGQZLiQChJewKq//gXVZ1VwrIuLBG0lZMHwUK7jXlKpt
         /iRv46khmR7tFztH5l679bBQhA9TGWSP/bh8Ft85d+jEPd+5O1KFvsZgA+sKNgj/qlXv
         pTsQY2exMUhdttG2TSnARQSJl6T4uY3QEuOS+0woChfb7z9Y54Dghjcm1AL15etUJz6F
         XwB2rdjHQ+S+IQtkANmPx2pUcx1vVllRD1LtX4cUHgj+O0nFKXm2VMnV5lm9R3/zedN6
         kWwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=YT55JpVvjwUC2dv/uV7bRDwoqFbA6WahpDDl+cLEfYI=;
        b=BqYlL9oL2FxMG6mvEUCLb1LZ43onaFip1UNlgQaLG2HTwxD9lQ7e817uMWfbqqbPVF
         fNYgDEpFfNooGdBpHKq9M9Jh93IU6y3O4/1VGNCvQz+bF2pEUbIFw23LF5pEtsx5o8Hk
         uxwkOvuh6lj5vdSWsVKPjhVH3i/bxIxPxxYM9MN7FAnhpudMvRIZgV0r2taPwNNu88An
         uZSnMSwDYI9zLJ3gHentCjSrbfRRrHV0eT6KjTALE3A3gj+HYuiCMKwmQojb1YU23N8R
         WX2ZrvofOVo2G/xy9HoYPH4u+Bl/Bue6GIWMYZMccuYEGnquDxAu7zWA3a8cdV0hLy2w
         fWJw==
X-Gm-Message-State: ACgBeo27ByT/cYkgJ/6GkqJf6pQ8QILtgy0PNYy3dn084iV0vcXXfQzy
        GZCsoBCalN2UGWFONV1NtUc5Qjjq5HSBbTHd
X-Google-Smtp-Source: AA6agR6oHh2Ak0iswJzMz5r2p/xF90brRMzQ++Th5jRO+SCcYP3CXHSS0tTXqmLjVtiO8HKKqudmmA==
X-Received: by 2002:a19:651e:0:b0:497:aaa5:44c with SMTP id z30-20020a19651e000000b00497aaa5044cmr7641978lfb.280.1662982139974;
        Mon, 12 Sep 2022 04:28:59 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id i14-20020a2e808e000000b0026acf2ae007sm1043269ljg.89.2022.09.12.04.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 04:28:59 -0700 (PDT)
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
Subject: [PATCH net-next v9 0/6] net: dsa: qca8k, mv88e6xxx: rmon: Add RMU support
Date:   Mon, 12 Sep 2022 13:28:49 +0200
Message-Id: <20220912112855.339804-1-mattias.forsblad@gmail.com>
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
  - Change types to __beXX
  
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
 drivers/net/dsa/mv88e6xxx/rmu.c     | 309 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/rmu.h     |  75 +++++++
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

