Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83905B1C01
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 13:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiIHL6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 07:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiIHL6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 07:58:45 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC32811C7EB
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 04:58:44 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id q21so13093770lfo.0
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 04:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=+eo4JfjB9Ehn0AoFNdQLah3HvVMczQGEOrXYOlb6oS8=;
        b=QSzx+ltL/fW1XSZyi2CU6W+ut1MXlxWWyTKJRKZbqZJuMZlayHVR12mth5e+LqhMRz
         iv2ohMUPh7nKuZJ03HVctx+Gl+T7xTE8A6iCMCW72LA5YdcM2oyU0GMBJ1tH4lugqftH
         /qb4XxlXeR8gcIn4hLtHJo/DHhRobm+5m488hKPlVlQCkrcPxKCd7bvui23sB2KEPg1A
         azWHfA8cMGxjLQp8SgzYAjEJ6XfoFSwSLXHxy8ga3wsK7+xStQI4ZpXWjCrg95bvSs3s
         Yd6k9a9SeDfx8pTbQsPPA0KvyPMGg6hPx5W/ZILkuSyoyGUJG4mrm3cn/1GGW4lF4ZCX
         UfWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=+eo4JfjB9Ehn0AoFNdQLah3HvVMczQGEOrXYOlb6oS8=;
        b=KYCie7pACs5TSmG17mrKXIs/1BnJB5Yp0CBj21UYtpHGbYsbVphE3brqiDdDZbqZo4
         BBgrKPjU3gR0hpGKTJsRzFk9ltM2CX3oswqEw7JsEuptr4bWQTWFZxfvCyMdV7g5uYff
         BmPutkeEjo0GiJjVEH9ScwMw2cCNkw2HbqkdBVnlrp9XrMexSxbpx84LUneHJaE/XttS
         8PF7ExpRUczFoG0TPBv3vMhBoSQphPcbD4lDhfLSIOdsaf72nd2zdBaJS944BwptjYbI
         8aPhqwn1GfQpDqCNPJi/qSmBzzVfumfhXz1qWYXI68ywm+/DWHMYsN8eY5QFaxQRtiDf
         8qWQ==
X-Gm-Message-State: ACgBeo3KPRQw7bmT2OBqTdLCGa1yTFgkmxX596kmMmCijY9xd5HTlqWT
        xGXJTiH8U97n4T+lQxmGu3KLXs+ImdGRQmzU
X-Google-Smtp-Source: AA6agR7PYX4D7j2mshOB2ZnCHI+/G80ocm7QdFmrf44wMZikWg19TCeeT3g09++RKZPvz57L59TGig==
X-Received: by 2002:a05:6512:2807:b0:494:6cc8:d31e with SMTP id cf7-20020a056512280700b004946cc8d31emr2624360lfb.82.1662638322649;
        Thu, 08 Sep 2022 04:58:42 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id s10-20020a2e81ca000000b0026acfbbcb7esm833595ljg.12.2022.09.08.04.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 04:58:42 -0700 (PDT)
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
Subject: [PATCH net-next v6 0/6] net: dsa: qca8k, mv88e6xxx: rmon: Add RMU support
Date:   Thu,  8 Sep 2022 13:58:29 +0200
Message-Id: <20220908115835.3205487-1-mattias.forsblad@gmail.com>
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
 drivers/net/dsa/mv88e6xxx/global1.c |  66 ++++++
 drivers/net/dsa/mv88e6xxx/global1.h |   3 +
 drivers/net/dsa/mv88e6xxx/rmu.c     | 355 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/rmu.h     |  21 ++
 drivers/net/dsa/mv88e6xxx/smi.c     |   3 +
 drivers/net/dsa/qca/qca8k-8xxx.c    |  61 ++---
 include/net/dsa.h                   |  19 ++
 net/dsa/dsa.c                       |  20 ++
 net/dsa/dsa2.c                      |   2 +
 net/dsa/tag_dsa.c                   |  32 ++-
 13 files changed, 614 insertions(+), 63 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.h

-- 
2.25.1

