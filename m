Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A014F5B1E97
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 15:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbiIHNV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 09:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbiIHNVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 09:21:20 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D4975393
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 06:21:15 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id z20so19869453ljq.3
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 06:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=3h16WZvonTrDoGH1mjiFyU6H2O6z0jc4dpDAi9Z27sw=;
        b=U1MWPypd0yVuPBm/Qs/RDWdO7SpATS//Qw0kODjbsF3jhShaWE5vKsDsrp1IITwu01
         75TUWx9rvJn/8BxeZFdd3Sy0yJylOqHiC29DACFclYR29j369pjb4PWAvq7JesxPC3a9
         UGuIiPMod92lq1PELGkR3LiFXpnBlIko4jl19UB2Pak73ptBH+/R7FU9xOVlRs+s8Urd
         CCyrN87E4ZHgTQNGa08OYQLEWtdPacxPCMmoybx7hSkLJQh7HPBTjbNRJPa5sgv5n4kQ
         bml6l05GmyHxBmdpqblA51q1X8WSKFFZ4RBLLI4mmFX9xqEnTQXdsdSFqK2BQ/sLvpb+
         Dp8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=3h16WZvonTrDoGH1mjiFyU6H2O6z0jc4dpDAi9Z27sw=;
        b=3qsfwhPm80Xh6NVDkTGzxOs7RZLx4LxDkSMlkwlnOBdrhlHR1PfMw0Pt/iF0dBLejb
         XRcgMYuSbhWw3jSqgWx5ViWPDDdVbQENkEGUhmOiG/bWvIMMgfqosrEa4d77xFioAj3r
         AzpYHvoUKmFZ+tEeDwFHmD3McPAdG17oSjwR6CRwHhxXRXJMySUIQDDJRlvDxzyZXW49
         mL704gUyqOoHW/aONx4c2T1d63Bw+S46QO+FqEyyk+z+Lnuntwilzu1S5gsWqpJcwxw7
         dXSqhnsdxweHZbvFKXDmZPg0vt++VrKvhlQDtvLkZGs4Z5bexn8CgsVHOgRAyYZL8JyA
         ICHg==
X-Gm-Message-State: ACgBeo3JQ3uAtnuIVwCaPsGIC+Y6JlSVlzBfrEvf7w1AhBvfzqCUOcT+
        JZWbmg/b+ixmslGOGkwss7tiV+zR40/0yRrj
X-Google-Smtp-Source: AA6agR55/COvsHrJ1hmJSaZWq6p+DKq3qMr9ePa2C3TTsKSfisErulLz+os6sHCTQnYOh+7I/DCPPw==
X-Received: by 2002:a2e:a28e:0:b0:25e:734f:38fa with SMTP id k14-20020a2ea28e000000b0025e734f38famr2509809lja.446.1662643273130;
        Thu, 08 Sep 2022 06:21:13 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id j6-20020a056512344600b00498f32ae907sm104837lfr.95.2022.09.08.06.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 06:21:12 -0700 (PDT)
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
Subject: [PATCH net-next v7 0/6] net: dsa: qca8k, mv88e6xxx: rmon: Add RMU support
Date:   Thu,  8 Sep 2022 15:21:03 +0200
Message-Id: <20220908132109.3213080-1-mattias.forsblad@gmail.com>
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
 drivers/net/dsa/mv88e6xxx/global1.c |  64 +++++
 drivers/net/dsa/mv88e6xxx/global1.h |   3 +
 drivers/net/dsa/mv88e6xxx/rmu.c     | 353 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/rmu.h     |  21 ++
 drivers/net/dsa/mv88e6xxx/smi.c     |   3 +
 drivers/net/dsa/qca/qca8k-8xxx.c    |  61 ++---
 include/net/dsa.h                   |  19 ++
 net/dsa/dsa.c                       |  17 ++
 net/dsa/dsa2.c                      |   2 +
 net/dsa/tag_dsa.c                   |  32 ++-
 13 files changed, 607 insertions(+), 63 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.h

-- 
2.25.1

