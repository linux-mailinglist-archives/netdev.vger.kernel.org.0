Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1EB25BAD3A
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 14:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiIPMTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 08:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbiIPMSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 08:18:34 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9D7B14C4
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 05:18:25 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id h3so17381950lja.1
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 05:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=10y3u29WDrDWXWOxLocDUKzS5xyleA2JnhGmVGe0iYg=;
        b=KndDd/PbfGEswtBB0kHDnj6iztnW8v/sGauCfbq7LR7omJXFJk4RBw+8TaQFKp25KF
         w/4vTAXzEW5lC1QEyNqNgW3CjQbqr97Acdz87F8fulURY83GfUt0+3zJxl8bWEkAxYwy
         YiSUdof7bAywgVUK2bVlaF/jyOin0hfTviqgHvNb1c6d9lMl7EUXxI1HJEFLZI4RTZgJ
         nkkRMZf7mic6OeFAOm0GrgR2jqBEsWlU5MSZYD4VgPixynAa7M2uO12SjgkNn1Gz6tH4
         yA1yZCwN0n9EbePQAHszv2tPt9mjHvUbzZ4cRKBBdIBontnnC1COzrhJa0geku5yLQ91
         gPrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=10y3u29WDrDWXWOxLocDUKzS5xyleA2JnhGmVGe0iYg=;
        b=3z+48N04mZlSGZOj1yP0cCSigHahozjEXG6t7P2W7S2jfXfAuyAgK1eMkqIDhdg9Lu
         u2B+EES7eJw9SwxwKO47/yjjWU1mgZUIR4v8So4dxC9qNOb5LxfWiKCCabd5JslEJNbF
         1dtim1p+wuzcw26dDJ+V351ZFjBXjdMKiBbE7aFWpgqJUVAYZosJEabNZWKaC3VwpAGc
         z4v1t1oW7qhGJtfV4ebXuXUB3xbKynZn9SZlufk89IrTEYKNYnVltOmqZLojyCMxm0w4
         mgDOG77F9j/HJJUJp/mrdfI0cEcZG/E1zGDx8A5krymawnbS7xJf2CZdEhVEfJz+DYSK
         kqwQ==
X-Gm-Message-State: ACrzQf33ZZfld6XIkp7f9jheVDKObjSS8nwbnceaxKBvztPwPkdMklNy
        dSybOxql+xMdinbuMmWlYzuRoPnl2N7j+UF2PAU=
X-Google-Smtp-Source: AMsMyM6/7VV2E8njDTJbzK53P5FZVVC4+B5m5sgB3NNcVe8NADNxgMPwBPC8DRYoKiUKoo1PmWSR0Q==
X-Received: by 2002:a2e:a887:0:b0:26a:871b:a16d with SMTP id m7-20020a2ea887000000b0026a871ba16dmr1472494ljq.482.1663330703122;
        Fri, 16 Sep 2022 05:18:23 -0700 (PDT)
Received: from wse-c0089.westermo.com (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id h6-20020a0565123c8600b0049f5358062dsm313824lfv.98.2022.09.16.05.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 05:18:22 -0700 (PDT)
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
        ansuelsmth@gmail.com, Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next v13 0/6] net: dsa: qca8k, mv88e6xxx: rmon: Add RMU support
Date:   Fri, 16 Sep 2022 14:18:11 +0200
Message-Id: <20220916121817.4061532-1-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

v11 -> v12:
  - Split mv88e6xxx_stats_get_stats into separate
    functions, one for RMU and one for legacy
    access.

v12 -> v13:
  - Expose all RMON counters via RMU.

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
 drivers/net/dsa/mv88e6xxx/chip.c    | 117 +++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h    |  31 +++
 drivers/net/dsa/mv88e6xxx/global1.c |  64 ++++++
 drivers/net/dsa/mv88e6xxx/global1.h |   3 +
 drivers/net/dsa/mv88e6xxx/rmu.c     | 320 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/rmu.h     |  73 +++++++
 drivers/net/dsa/mv88e6xxx/smi.c     |   3 +
 drivers/net/dsa/qca/qca8k-8xxx.c    |  61 ++----
 include/linux/dsa/mv88e6xxx.h       |   6 +
 include/net/dsa.h                   |  11 +
 net/dsa/dsa.c                       |  17 ++
 net/dsa/dsa2.c                      |   2 +
 net/dsa/dsa_priv.h                  |   2 +
 net/dsa/tag_dsa.c                   |  40 +++-
 15 files changed, 692 insertions(+), 59 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.h

-- 
2.25.1

