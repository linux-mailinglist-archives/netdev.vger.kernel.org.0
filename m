Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388DC5B3254
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 10:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbiIIIv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 04:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiIIIvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 04:51:46 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692F14BA54
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 01:51:44 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 9so105984ljr.2
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 01:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=mIEe2RHBaQXXO21sk5xWelV8Zs6bssGhOzr4Z4X7I0o=;
        b=U8yEkNbHt8Bv2HaAcXXOStiPEMpoX1ysubjwyts5VEbfC3q+aLP+Ab/VU5Fhxg4MSP
         OYiFhYvA8EyQ/CdYeevmhFA86ivcBheJGPens+O8jpU3Qn62b1+mbOiSJFz0LfIilb74
         jN6lhR/0v6ncLUi+Di+G5nPM+eCW7DSv2IMCftUYyGDQoaSxr2nHee9/hWQCJm1Na8iy
         q3bpgDGNwCtfTodw1buAXWQmRQQrqmvaiVArpULaRPZXkRrX7nDn8lNAVWmjMOtihyQA
         At6EVl4wISmFh5SctJenBI7sK32yPlcze+eLlt0qvy72DJwT6sLbu0mONRA1eA2/Psag
         qIJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=mIEe2RHBaQXXO21sk5xWelV8Zs6bssGhOzr4Z4X7I0o=;
        b=QFDosYBbFDb8q+0hJtj64tk1N4egkLTHZnr3dUgiOFe0w/j76h3t+Cxqg8+NnyecMy
         Nf9CACGQKAZxjNAvo3pe0lgzJbXHmSdAP+KBlJvRKBWgSRyLV2nU8AGz8o8bek19F2Xp
         gAT247YvZ5lG7NfPlQ9FViyPTw1ucfH0UvTBnVRg1YncQeD1CUJh+kWf0mTgySP5K3az
         G+vM34playX1/hKdsGel2OVozGzeYsPYQnH2EFf6UmmqgxSIw5Y6jWRJ4dvVIguUr/V1
         JTKvi/L3QYFJS3ZpU+FvOI09AV9eUfRlBHLjPOB1KcgmSRJ7OMejGtPg65lWOGkXSpoj
         smeg==
X-Gm-Message-State: ACgBeo1+9GJ9MNYFYflnox64hHnS2dLyVwQSgTy0Qvq8i5x1x1kbfoCz
        pFk+sWh87r8QZi2phdS174OTW0Q+Y96hE6gQ
X-Google-Smtp-Source: AA6agR7BopiDktFzoyBndSCGSfs1qN6xrQ4Y1r5R+ac76GEgeGKU8THKzSIa4zUv4vvPVNq8YLh+uA==
X-Received: by 2002:a05:651c:12ca:b0:261:df67:b76f with SMTP id 10-20020a05651c12ca00b00261df67b76fmr3362308lje.421.1662713502173;
        Fri, 09 Sep 2022 01:51:42 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id q17-20020a05651c055100b00262fae1ffe6sm193956ljp.110.2022.09.09.01.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 01:51:41 -0700 (PDT)
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
Subject: [PATCH net-next v8 0/6] net: dsa: qca8k, mv88e6xxx: rmon: Add RMU support
Date:   Fri,  9 Sep 2022 10:51:32 +0200
Message-Id: <20220909085138.3539952-1-mattias.forsblad@gmail.com>
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
 drivers/net/dsa/mv88e6xxx/chip.c    |  70 ++++--
 drivers/net/dsa/mv88e6xxx/chip.h    |  24 ++
 drivers/net/dsa/mv88e6xxx/global1.c |  64 ++++++
 drivers/net/dsa/mv88e6xxx/global1.h |   3 +
 drivers/net/dsa/mv88e6xxx/rmu.c     | 333 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/rmu.h     |  76 +++++++
 drivers/net/dsa/mv88e6xxx/smi.c     |   3 +
 drivers/net/dsa/qca/qca8k-8xxx.c    |  61 ++---
 include/net/dsa.h                   |  19 ++
 net/dsa/dsa.c                       |  17 ++
 net/dsa/dsa2.c                      |   2 +
 net/dsa/tag_dsa.c                   |  32 ++-
 13 files changed, 642 insertions(+), 63 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.h

-- 
2.25.1

