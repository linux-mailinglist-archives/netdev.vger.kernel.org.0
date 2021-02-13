Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8470B31AE01
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 21:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhBMUon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 15:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhBMUom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 15:44:42 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39239C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 12:44:02 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id t5so3819876eds.12
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 12:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=00HR02QfPycPr0ik/2vPNbCbJiNB7z4GSq+zUjslhsw=;
        b=FYpUHD+pcIPtPfLHogrK0AKenuXc1vpZRmTaeH3VxLdFerBvV7SmcmJl6BssVpfBGu
         nL0wxAlMuyEMDjdQVaZbq+o76TSaW+HV0sycya3xNcb35pi1tPTnr9X7Bx2Wgu+AQGWS
         aqFzdqIC9HVQSFJnvOBY6bA9x8VfoEoy5AW5dXwSkxhqAVX7zfDTkaOm2hDp7fVn2sQq
         L5IlFgbkOVnz7CXmn1J73LKYk7exketRNFHH5IXyY4D51JZ3sdtvHXRwGiSRqoITtvBG
         wgZWPxGiYWr1lg5AKDQ8xxQDnU1hFPanSq6IGjl1WLeKji3J87ChyrGCIctrRG6j0J02
         FXSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=00HR02QfPycPr0ik/2vPNbCbJiNB7z4GSq+zUjslhsw=;
        b=TRjAdT0mAHkzZHyMDU50qmuPtvHEPS3xU7RZWaxf1wfEZg5RHjQBMNqnX3Oq3EhHcG
         tGCJADGuucNZcEGVPcvzOwP9C1GizVho0IsfkS/1YWhLVAcB/BD9rxTgbLe4DQQCprEp
         q8MbmXzVfoUQi+fHrXbq6akRnolfN2QN6Z+BBH+RWx5mcHgJAxNb0hZ/0Sa5fdtvAtQm
         VfgB1avCmdXrmA/bSGN76/pr9M5ZMTupn5O23DFemUlPB+hcmMhJ4cNviPuyj0bH411S
         kQC1KaDewJoCD+Ui7w2zLxDk+WfZ2tthbN9H8PbWsEG09b6y5D9YFilyw8uyTYzB2AOb
         mN1w==
X-Gm-Message-State: AOAM530t0GEKqPZUn65wGiAUixwQn9RmggpJIK4NZYUK2blM12/VKEDT
        AigvHJcBPQFdUKNuisdG7M0=
X-Google-Smtp-Source: ABdhPJyXsCRTMKqJaRTvsqnXZWBSaNtUgGDAhZbTZDs1AT+pv0B6HveBazZuDJOvRj3app6gh2k+qw==
X-Received: by 2002:a05:6402:61a:: with SMTP id n26mr8854801edv.51.1613249040738;
        Sat, 13 Feb 2021 12:44:00 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id p6sm2363937ejw.79.2021.02.13.12.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 12:44:00 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Subject: [PATCH net-next 0/5] Propagate extack for switchdev VLANs from DSA
Date:   Sat, 13 Feb 2021 22:43:14 +0200
Message-Id: <20210213204319.1226170-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series moves the restriction messages printed by the DSA core, and
by some individual device drivers, into the netlink extended ack
structure, to be communicated to user space where possible, or still
printed to the kernel log from the bridge layer.

Vladimir Oltean (5):
  net: bridge: remove __br_vlan_filter_toggle
  net: bridge: propagate extack through store_bridge_parm
  net: bridge: propagate extack through switchdev_port_attr_set
  net: dsa: propagate extack to .port_vlan_add
  net: dsa: propagate extack to .port_vlan_filtering

 drivers/net/dsa/b53/b53_common.c          |   6 +-
 drivers/net/dsa/b53/b53_priv.h            |   6 +-
 drivers/net/dsa/bcm_sf2_cfp.c             |   2 +-
 drivers/net/dsa/dsa_loop.c                |   6 +-
 drivers/net/dsa/hirschmann/hellcreek.c    |  15 +-
 drivers/net/dsa/lantiq_gswip.c            |  22 ++-
 drivers/net/dsa/microchip/ksz8795.c       |   6 +-
 drivers/net/dsa/microchip/ksz9477.c       |  10 +-
 drivers/net/dsa/mt7530.c                  |   7 +-
 drivers/net/dsa/mv88e6xxx/chip.c          |   6 +-
 drivers/net/dsa/ocelot/felix.c            |   6 +-
 drivers/net/dsa/qca8k.c                   |   6 +-
 drivers/net/dsa/realtek-smi-core.h        |   7 +-
 drivers/net/dsa/rtl8366.c                 |  14 +-
 drivers/net/dsa/sja1105/sja1105.h         |   3 +-
 drivers/net/dsa/sja1105/sja1105_devlink.c |   2 +-
 drivers/net/dsa/sja1105/sja1105_main.c    |  15 +-
 include/net/dsa.h                         |   6 +-
 include/net/switchdev.h                   |   3 +-
 net/bridge/br_mrp_switchdev.c             |   4 +-
 net/bridge/br_multicast.c                 |   6 +-
 net/bridge/br_netlink.c                   |   4 +-
 net/bridge/br_private.h                   |  17 ++-
 net/bridge/br_stp.c                       |   4 +-
 net/bridge/br_switchdev.c                 |   6 +-
 net/bridge/br_sysfs_br.c                  | 166 +++++++++++++++++-----
 net/bridge/br_vlan.c                      |  29 ++--
 net/dsa/dsa_priv.h                        |   7 +-
 net/dsa/port.c                            |  22 +--
 net/dsa/slave.c                           |  28 ++--
 net/dsa/switch.c                          |   9 +-
 net/switchdev/switchdev.c                 |  19 ++-
 32 files changed, 319 insertions(+), 150 deletions(-)

-- 
2.25.1

