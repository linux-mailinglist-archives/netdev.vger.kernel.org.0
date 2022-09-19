Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E655BCA48
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 13:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiISLJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 07:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiISLIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 07:08:55 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F789E026
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 04:08:53 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id a10so566006ljq.0
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 04:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=RqxraZp/Uxqy/Ck6oOeEssZJkuqAVMLOaTdVizO/iOs=;
        b=eS4VgI2EZomsXcMunoudIrqxlCs5BrYpeW9meWrTcq6WzvcwJONOs+p74NGtmC1meP
         OdYvfRTZywha716+35cweviCE7WLH+Lb/gFTsedLH6913ew/AxqncNSql5X6eQh8ER2q
         Z2yFlHa6xpussf+hroIjwRHeEKVrFLGJB6Xms9GcUhCARMoI1Jl4pHMDt9EWAfo4FZkx
         L7/iBMT9IX+iFmGV8R8xC+C81vGXDlQf3zIj0VDjH1q3kjIkZrWwalH8LA6WhmJfemML
         BfLb3NTu4u9GUo5kSYdPLzARS2wbvBT5QO0FAM1JRIGKwzv5IOQf3uW/CkMCNip/OuIP
         4R9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=RqxraZp/Uxqy/Ck6oOeEssZJkuqAVMLOaTdVizO/iOs=;
        b=FpH4/vGV1FJ/57MU7zpnnrGXbHuFUdsv3lXMlMo6LISqsO+2KoVyIdVYd7n0Dni721
         JJJ7yU4dEf08n/WFReTlgtEwHs1RXHesK8dBigQ1wS2K212FXl+Xb4R2em2u44JrqM8w
         wa/5/z4myLGwrnoiqDDCzPe0BCOetRP+rRuTMpy6q6mnHzrWPnqOWUKdknydmTrhnwcr
         xONezF03Qj8qoVhpHAwzG6IwSnIa0yeXy46y3HsVggcQMzi9Xi35/xwq0OvqwZTCj4aQ
         CKdtF0TSUujC1dP63T2tvAl1C/J2KXYgdawPvfw/H1kG9DA4FA77h3mbyAA95QCu6tjL
         eqRA==
X-Gm-Message-State: ACrzQf2Hk8qs1eu50DDtnT75T1G42LdITGLQC5lrhs3m7Y48stXrRNsY
        JL9cIJvnOXDTo7zBHweX1nyPF4kmUgn+LQ==
X-Google-Smtp-Source: AMsMyM40MVPDTfuwtdtnVKxEH+HGXB0M47xmCqbSkoWRmYYN+hLcrRcA1Pzx8U569lK7DzF82h8+hQ==
X-Received: by 2002:a05:651c:114b:b0:25b:e13b:6900 with SMTP id h11-20020a05651c114b00b0025be13b6900mr4697543ljo.462.1663585731276;
        Mon, 19 Sep 2022 04:08:51 -0700 (PDT)
Received: from wse-c0089.westermo.com (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id t13-20020a05651c204d00b00266d3f689e1sm4879261ljo.43.2022.09.19.04.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 04:08:50 -0700 (PDT)
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
Subject: [PATCH net-next v14 0/7] net: dsa: qca8k, mv88e6xxx: rmon: Add RMU support
Date:   Mon, 19 Sep 2022 13:08:40 +0200
Message-Id: <20220919110847.744712-1-mattias.forsblad@gmail.com>
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

v13 -> v14:
  - Fix feedback on qca8k. 80 char line length.
  - Pass response data to RMON decoding routine.
  - Remove unused function.
  - Split patch.
  
Regards,
Mattias Forsblad

Mattias Forsblad (7):
  net: dsa: mv88e6xxx: Add RMU enable for select switches.
  net: dsa: Add convenience functions for frame handling
  net: dsa: Introduce dsa tagger data operation.
  net: dsa: mv88e6xxxx: Add RMU functionality.
  net: dsa: mv88e6xxx: rmu: Add functionality to get RMON
  net: dsa: mv88e6xxx: rmon: Use RMU for reading RMON data
  net: dsa: qca8k: Use new convenience functions

 drivers/net/dsa/mv88e6xxx/Makefile  |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c    | 120 ++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h    |  26 +++
 drivers/net/dsa/mv88e6xxx/global1.c |  64 ++++++
 drivers/net/dsa/mv88e6xxx/global1.h |   3 +
 drivers/net/dsa/mv88e6xxx/rmu.c     | 316 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/rmu.h     |  73 +++++++
 drivers/net/dsa/mv88e6xxx/smi.c     |   3 +
 drivers/net/dsa/qca/qca8k-8xxx.c    |  68 +++---
 include/linux/dsa/mv88e6xxx.h       |   6 +
 include/net/dsa.h                   |  11 +
 net/dsa/dsa.c                       |  17 ++
 net/dsa/dsa2.c                      |   2 +
 net/dsa/dsa_priv.h                  |   2 +
 net/dsa/tag_dsa.c                   |  40 +++-
 15 files changed, 693 insertions(+), 59 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.h

-- 
2.25.1

