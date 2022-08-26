Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3875A20F6
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 08:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240062AbiHZGi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 02:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiHZGiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 02:38:25 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8772D11EA
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 23:38:24 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id l1so775233lfk.8
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 23:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=/YfZzdn5NLQJ5Gu3RhRz5HCjWUiHfyeTmapPWv5i518=;
        b=FXvL8HMaiGUMpXwWDzsUZaG6bimkp7Qtoh5EBuwY5vrRpVuoEmYOX/fvH+joIOEqa3
         c7G85QBubOWcJ4TCIT3qAiFDP60ncm9eqNUHyqn6VyB/v5N2V+izuqDtEh7ibASGMvlS
         h3Sk/G/kShM6a4hHTmbETsB9Jer//QPw28GMESDn71F5KvI214LK+3FsARDaW7s0h4nI
         kH/9NFqT/NocAmmiSpRo2PCJQIf96h0OD8wywpVbiDLg56KPtgEzeGeIxkPBnc5n2WGh
         UNvJxI6jv2zAji1+I7AEab9/64in4h4Zt+peq7HmmILOElFtVF9wjNjEU0a19c9ewT9b
         JjMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=/YfZzdn5NLQJ5Gu3RhRz5HCjWUiHfyeTmapPWv5i518=;
        b=gwB/9zJY2e2eNeVdYZH1dbxYu6z6GnCq5VgTwjNND7VRYB6LQ/ljwecWisBGZEw5C7
         kNWW5m/PxnLQ5WzFzPlTn+K5IUQ0ZmrEb3CsoGKp+1vnyLXPfmWvZsz0M/5IlV3bmscB
         8Q+9Du5CZIMcjlWVCOSW/g5w39OkniV4etYup4dsheaaSsPgYifiDC8h/Yqld0Fd0Eok
         XS4nBOLnj4ZOJSPn2cYZapxvaAIGG5kPJgRKOLgY3Rif3Y9+BIWGae+ZOhy1aY7gGt2W
         I3VbCMHZV5pV1IOGoAPy3nbdtiGHuuNX4bmzIbJt8zeeJN8mGHxfSSa1JY6ztsF2WjrF
         74og==
X-Gm-Message-State: ACgBeo3NiCpZpM27oGXfFGYD9waC1fy4PII48xJHRhRXnUetuFDIwFHN
        Fj4qtH7pNaL3JDBBMvdPk9ohbeSnUfUKzMam4R8=
X-Google-Smtp-Source: AA6agR4/lTUy/pufFuxhUvv2cc8yCMIDfVQyUE4e9WQ3PInxfKbELQYTZGktdTPxIs80wE/gIbP6+A==
X-Received: by 2002:ac2:4f03:0:b0:48b:2179:5249 with SMTP id k3-20020ac24f03000000b0048b21795249mr2362212lfr.356.1661495902802;
        Thu, 25 Aug 2022 23:38:22 -0700 (PDT)
Received: from wse-c0089.westermo.com (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id p6-20020a05651238c600b0048cc076a03dsm253161lft.237.2022.08.25.23.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 23:38:22 -0700 (PDT)
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
Subject: [PATCH net-next v2 0/3] net: dsa: mv88e6xxx: Add RMU support
Date:   Fri, 26 Aug 2022 08:38:13 +0200
Message-Id: <20220826063816.948397-1-mattias.forsblad@gmail.com>
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
This is handled by the Remote Management Unit (RMU).
These frames can contain different payloads:
single switch register read and writes, daisy chained switch
register read and writes, RMON/MIB dump/dump clear and ATU dump.
The dump functions are very costly over MDIO but it's
only a couple of network packets via the RMU.

Next step could be to implement ATU dump.
We've found that the gain to use RMU for single register
read and writes is neglible.

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

Regards,
Mattias Forsblad

Mattias Forsblad (3):
  dsa: Implement RMU layer in DSA
  dsa: mv88e6xxx: Add support for RMU in select switches
  rmon: Use RMU if available

 drivers/net/dsa/mv88e6xxx/Makefile  |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c    |  54 +++++-
 drivers/net/dsa/mv88e6xxx/chip.h    |  20 ++
 drivers/net/dsa/mv88e6xxx/global1.c |  84 +++++++++
 drivers/net/dsa/mv88e6xxx/global1.h |   3 +
 drivers/net/dsa/mv88e6xxx/rmu.c     | 273 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/rmu.h     |  33 ++++
 include/net/dsa.h                   |   7 +
 include/uapi/linux/if_ether.h       |   1 +
 net/dsa/tag_dsa.c                   | 109 ++++++++++-
 10 files changed, 575 insertions(+), 10 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.h

--
2.25.1
