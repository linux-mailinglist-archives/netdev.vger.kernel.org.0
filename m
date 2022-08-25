Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A661D5A0C8B
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 11:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239976AbiHYJ0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 05:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239950AbiHYJ0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 05:26:41 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A126C127
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 02:26:39 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id u24so13257855lji.0
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 02:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=T9ekehgC8ShYaRqPl/CmP2JYQ1kWyZP0QxKS/Gpxjq0=;
        b=l62xLFWty4hzpUJp8Hf9adr7Job36E99Exqr44tyf9v6IYzoevfH1ilQc+NU6Gztyo
         5DED8bItmfirkq0rfU5T50yy+xUstH78CVHvTftNcRTrnPxiJEvbO3GJE0z+DbAzbc17
         wIwQyRFRN36aGqn1/pZUZUwiU5hptDvQtYGN+Mq4MIawqV0c7prX6dKZKJ3Ew5ayfBvF
         k4qRJKpWVIvGCSzQS3UgEOhAJSXLYRr8eH3lcOs7iucU2I8G0SfNBZWTzW3vSJcBi/73
         poeSKv5jovhkGtYrsaSKBaFmAeR0mh8pl6094uleOH9RSHlF21nDVbcZA9rCy7yzeAbD
         krnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=T9ekehgC8ShYaRqPl/CmP2JYQ1kWyZP0QxKS/Gpxjq0=;
        b=wiYYeikRyPBPNjtiw3gGRBUjxHwHAlqqqm4oC1G62AQ07yUG/14u25DqW9DpQtelWS
         ZvV0OIMsTAfhXpAwgvk6IqE2LIw9yCXl2lMlrPqzMgIssUaCAT6HLWaYV3X55MKEYj8Y
         GmARypKhdy2QQMOvsDqesoHFr3qESZLVnOo6bcUxGpD50czzVYmIhNpf0KdRgMQJneyu
         Mp/yoiTFKXFlYVHpPK7zhRbqlij7XRPySbCk6q5EQCHyAMWov7XmiB5NaHZ7cXWgNcEs
         HV/ENLFhscfX9BGDOmMY9J67YXaJLJ+2pxHMmTVCNcC+jhb8DMsE3tmiqCqJpZV6pZx5
         6t8A==
X-Gm-Message-State: ACgBeo2kFGOtUBLcEg3hORceH9Mowol1TxM1FtnXV728ph0865sP53a5
        clefwZGdw/EXBaxojT9F+0rVQdSl8oPqsdgLmNQ=
X-Google-Smtp-Source: AA6agR5snsT9//hS/+slyGSz8JXPhqsegWe5gbiDUc63iI1M/84zqU/CWejGYtS3BVDOgplR3BeFFQ==
X-Received: by 2002:a05:651c:12cb:b0:25b:fa3f:c3f with SMTP id 11-20020a05651c12cb00b0025bfa3f0c3fmr881463lje.364.1661419596998;
        Thu, 25 Aug 2022 02:26:36 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id p9-20020a2eba09000000b0025df5f38da8sm429740lja.119.2022.08.25.02.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 02:26:36 -0700 (PDT)
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
Subject: [PATCH net-next v1 0/3] net: dsa: Add RMU support
Date:   Thu, 25 Aug 2022 11:26:26 +0200
Message-Id: <20220825092629.236131-1-mattias.forsblad@gmail.com>
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
We've found that the gain to use RMU for single
register read and writes is neglible.

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
 drivers/net/dsa/mv88e6xxx/rmu.c     | 276 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/rmu.h     |  33 ++++
 include/net/dsa.h                   |   7 +
 include/uapi/linux/if_ether.h       |   1 +
 net/dsa/tag_dsa.c                   | 109 ++++++++++-
 10 files changed, 578 insertions(+), 10 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.h

--
2.25.1
