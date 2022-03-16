Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 419C74DB4E5
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344125AbiCPPc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237138AbiCPPc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:32:26 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654EF6CA6F
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:31:10 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id bt26so4384211lfb.3
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QmzaCRQEzSE3TmmXZfq+dOjJqf0v2k+R1xUTopGesFc=;
        b=DeqWik0KgADaiv9peYk0xA4kqCFaZVDEd1KoTgAlUBx9pF6JY7rYjm55mN2dqrYePS
         WHJrgUAleHHQ7/O6d52SCv+t+J887eeuUEM2dkOpvO41PiwX+tVK5Lk1Hp02M3fu1S8H
         hVtLKsYPCjVUyUgssaIKBsFwH0I66pqqTFeyh/6hGxanwpa8JbDcjWuE9OrkZhasuUk+
         DxJy2cyof3nnBmhtNuJ3gnb/A48gSD2I/mTw4TbriVn1xmpb8yNTaqrZQ5lyVcjD8svl
         R+/2vSD5QsaJRFKQqEcgt4IePaIVX+nnz2yJPyTU1RG8m4JTADJujYQK0bgUUEEG/sr6
         smhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QmzaCRQEzSE3TmmXZfq+dOjJqf0v2k+R1xUTopGesFc=;
        b=bK+RL5JIuXoYbVg6aHhxIiw1S/xH1Uc0CLmCaj7hgEEDWv01uKgq1iOVl5L9NYPUNw
         uC8S6xJkqUhNDcetc7uIDWIAOTP/9+zWOJwCKKiQeYPkoR4X2ZSZn8KNjt9RpAvjOpjm
         Mpv9k9USynePm+v5ZUTPiZ8omRHRBbDD+x8PvVvMQ0Tv7aNtPFDqBOUDyvfuxdIGb9Hl
         o+eGrcvhepslhbv/XYR/lqgk3T8lV9kOvnTDiY7x7wj6xN+6jjjEyhNWs2UdDpGldUU6
         7TR215jucEbraY3ad76D/zXIar027CV5gWFRIoi0CltuwDDEF2+dHI9aY719zJMmaIX/
         ydLA==
X-Gm-Message-State: AOAM531GV9aWPFCdYXxmr3sl0tPnDwu7ZxPxhELHJjGc5FpYfF2Zs117
        Yo4KanAiKbboUMDyTygeiTaJ8rHYcaDL8UHS
X-Google-Smtp-Source: ABdhPJykvt+5G9b4CkyHueWaa+pXMOCKksDMSFWwA3KPR1649L1HUTFZDxAhTpYLul3nRRHbUnV1yw==
X-Received: by 2002:ac2:5d42:0:b0:448:696c:fa2d with SMTP id w2-20020ac25d42000000b00448696cfa2dmr135302lfd.548.1647444668291;
        Wed, 16 Mar 2022 08:31:08 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id bu9-20020a056512168900b004489c47d241sm205870lfb.32.2022.03.16.08.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:31:05 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
X-Google-Original-From: Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
Subject: [PATCH v2 net-next 0/5] bridge: dsa: switchdev: mv88e6xxx: Implement bridge flood flags
Date:   Wed, 16 Mar 2022 16:30:54 +0100
Message-Id: <20220316153059.2503153-1-mattias.forsblad+netdev@gmail.com>
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

Greetings,

This series implements new bridge flood flags
{flood,mcast_flood,bcast_flood}
and HW offloading for Marvell mv88e6xxx.

When using a non-VLAN filtering bridge we want to be able to limit
traffic to the CPU port to lessen the CPU load. This is specially
important when we have disabled learning on user ports.

A sample configuration could be something like this:

       br0
      /   \
   swp0   swp1

ip link add dev br0 type bridge stp_state 0 vlan_filtering 0
ip link set swp0 master br0
ip link set swp1 master br0
ip link set swp0 type bridge_slave learning off
ip link set swp1 type bridge_slave learning off
ip link set swp0 up
ip link set swp1 up
ip link set br0 type bridge flood 0 mcast_flood 0 bcast_flood 0
ip link set br0 up

To further explain the reasoning for this please refer to post by
Tobias Waldekranz:
https://lore.kernel.org/netdev/87ilsxo052.fsf@waldekranz.com/

The first part(1,2) of the series implements the flags for the SW bridge
and the second part(3) the DSA infrastructure. Part (4) implements
offloading of this flag to HW for mv88e6xxx, which uses the
port vlan table to restrict the ingress from user ports
to the CPU port when all of the flag is cleared. Part (5) adds
selftests for these flags.

v1 -> v2:
  - Split patch series in a more consistent way (Ido Shimmel)
  - Drop sysfs implementation (Ido, Nikolay Aleksandrov)
  - Change to use the boolopt API (Nikolay)
  - Drop ioctl implementation (Nikolay)
  - Split and rename local_receive to match bridge_slave
    {flood,mcast_flood,bcast_flood} (Ido)
  - Only handle the flags at apropiate places in the hot-path (Ido)
  - Add selftest (Ido)
  
Mattias Forsblad (5):
  switchdev: Add local_receive attribute
  net: bridge: Implement bridge flood flag
  dsa: Handle the flood flag in the DSA layer.
  mv88e6xxx: Offload the flood flag
  selftest: Add bridge flood flag tests

 drivers/net/dsa/mv88e6xxx/chip.c              |  45 ++++-
 include/linux/if_bridge.h                     |   6 +
 include/net/dsa.h                             |   7 +
 include/net/switchdev.h                       |   1 +
 include/uapi/linux/if_bridge.h                |   9 +-
 net/bridge/br.c                               |  46 +++++
 net/bridge/br_device.c                        |   3 +
 net/bridge/br_input.c                         |  23 ++-
 net/bridge/br_private.h                       |   4 +
 net/dsa/dsa_priv.h                            |   2 +
 net/dsa/slave.c                               |  18 ++
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/bridge_flood.sh  | 169 ++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |   8 +
 14 files changed, 335 insertions(+), 7 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_flood.sh

-- 
2.25.1

