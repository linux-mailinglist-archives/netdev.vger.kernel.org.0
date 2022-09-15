Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9CC5B9D74
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 16:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiIOOiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 10:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbiIOOib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 10:38:31 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A967B8B2F2
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 07:37:07 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id o2so28537501lfc.10
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 07:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=T5/1E62lEQ0sD/aomm3Hc18OHm1DsEh5NFOMgzVOSQ8=;
        b=XTDzi8sATshs+SPgJkBEXZDp6STqsDuWEv8pIZuT3j4rjqtKXTGk3XqKxbN2hJiQ4V
         3zW/AkC5vvkD2D45rv4cGmpt7T9rotMNvjwbg330MLVr8Gr6rQLNR/uXw8LiJV4x9VoX
         TJOunsPAzCb3vVAgJGtLSNV8gB4FZ4ssdSTcLhNt5c8rU+5aoHZfdbu9pZHdmAdPmHiX
         LPWaV/8M0UpyN8WQNhjk78G3S1WWISOL8JGIk52daYcuNzOSOIm+pJSHazbMaWvuiMm9
         b8emcJzeS7tcGwh+JL/h2UYId9Zepnyxw8zsM5Hp42BsQUB5sS+/yaHaM8yiipZ++B8j
         5GuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=T5/1E62lEQ0sD/aomm3Hc18OHm1DsEh5NFOMgzVOSQ8=;
        b=560WTa4uK/GFsK3wyVf0qfpaQDo1SJbUWyChqA8fdgno1qaJ34kfnX6kvt+fEHvEwx
         mZfp1dvva/ODgBn4UdURmf/0oAyDLP8SqqXHZuClpcw30rpLL0dP8tMPntcrj/5hjioY
         oPl0KB6IxuEG1hMsp1gbZPZ+wF2jlOz7DaUakJ1TwlQ+xSB7eVGML3DHwjvxcH3PONFx
         E65rJOSx1w8NRfXS0pMotOKscBmt6o8oVABVsAGQ+L+g5QIQIeG1IgsLMjCJaQyG8svG
         z1RhLCP8rsgw5OLVj87S3aM0ioubeuG2uPur3vLLJsg63kVcD1LQt1VxRy3wyR3Mym7J
         C8GA==
X-Gm-Message-State: ACrzQf1JYJh77f0rZXmCoOJx03xTWxtyvOUyOsn5EcbJ9PblH5gANvM9
        8PkHVDoVA/G0D6rUaplgGCoMho4Xccd1g+c5
X-Google-Smtp-Source: AMsMyM7Ln+w4Obje8a3635vAnj9mWOxYa8uxTAj/DbgYhrh37EvtJMle2SxomkVO76mJyKx9LersPw==
X-Received: by 2002:ac2:4c47:0:b0:499:9ada:8616 with SMTP id o7-20020ac24c47000000b004999ada8616mr72658lfk.377.1663252624865;
        Thu, 15 Sep 2022 07:37:04 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id x15-20020ac259cf000000b004984ab5956dsm2995794lfn.202.2022.09.15.07.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 07:37:04 -0700 (PDT)
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
Subject: [PATCH net-next v12 0/6] net: dsa: qca8k, mv88e6xxx: rmon: Add RMU support
Date:   Thu, 15 Sep 2022 16:36:52 +0200
Message-Id: <20220915143658.3377139-1-mattias.forsblad@gmail.com>
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
 drivers/net/dsa/mv88e6xxx/chip.c    | 214 ++++++++++++-------
 drivers/net/dsa/mv88e6xxx/chip.h    |  25 +++
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
 15 files changed, 712 insertions(+), 121 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.h

-- 
2.25.1

