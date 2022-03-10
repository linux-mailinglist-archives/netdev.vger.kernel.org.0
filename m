Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB84E4D4B2E
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 15:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243990AbiCJOcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244309AbiCJO2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:28:46 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84114CE92E;
        Thu, 10 Mar 2022 06:23:43 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id g17so9751084lfh.2;
        Thu, 10 Mar 2022 06:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=1DB/xtUlg/bv2cuDVJn+P6RhKyQoRLt8abFtk957r6s=;
        b=R47rCIiaVpicOQHFE/ayhGe8nzDLNGihYQm16/4lLr5BnZFPhczoq/4SkPQVJjbAk6
         T9QwpPeL9HR93EwbKL/mHtDXm+P4q0Y4FrvFRJhfP8g8UlO6vQK40gr1hG9deQFjHWHo
         BRGAq32r/Qz8W3Rxtde785V9nWskjzNJesjmgCzwRj3d5XR1tTJkaAmgUmUJMVd3YSXU
         NKHqBkTlu8Vec9zHdjobhjiFLPCsHuJ3MbsXkMPmkr2I6vNdPGsf+dYn6wxsCzzkSbWJ
         LbDKEfJ/7PifVqxh52Zg2G537v0ln0q/ebFkdTzNDjJ7FHsOUzVrHU9aM8JHpoXZ60x0
         4fXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=1DB/xtUlg/bv2cuDVJn+P6RhKyQoRLt8abFtk957r6s=;
        b=lThQyyEwAxNjz5UHO0zepDN0+l8O/+xJajehHO8KVVEDi3+/MOaq89E+TX23ED8qxs
         YgT9HNzSsImNRZUGvBGQ3gpgDdWW8uqeqEFnW9pVL0GjCtl+poDF/22dqe7Tbi1wlqOO
         h+6jeyKVKjToXXEMf0fY3K+QeJkXmsgWLZtgDzvfmE2oVXl0brcLNo+K9pBnxJnE4zeN
         T5TRnTiI6tQsGtWsGJQGRTusIeJ3nsdQwROT4pJe64zMDw/ZowdwM0/KizqPN1ZyxOzW
         GeCvbwX4xVyjR8kqelWOn9ymVP1V6hMNwwmcKI97I5vB7gZZtAgK6FINJMleWAi9kWpN
         GnfQ==
X-Gm-Message-State: AOAM532Uf+Cb3mMGiKtAQWm+xQOJg9jO0lLwixEvx4Q+UZY0CMc+t1US
        4tfBTohmJbWvQVptElpBU7U=
X-Google-Smtp-Source: ABdhPJxBHuD4Ir0V/8sdNmCwQKZQxBy55uJMs4YaKnO3j08/Mcfzwgu4Mle7Aab1AR9Lx1DY8y4Eew==
X-Received: by 2002:ac2:554b:0:b0:448:1f2e:59bf with SMTP id l11-20020ac2554b000000b004481f2e59bfmr3274685lfk.500.1646922221365;
        Thu, 10 Mar 2022 06:23:41 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id 10-20020a2e080a000000b00247f82bbc6fsm1088932lji.54.2022.03.10.06.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 06:23:41 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: [PATCH net-next 0/3] Extend locked port feature with FDB locked flag (MAC-Auth/MAB)
Date:   Thu, 10 Mar 2022 15:23:17 +0100
Message-Id: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

This patch set extends the locked port feature for devices
that are behind a locked port, but do not have the ability to
authorize themselves as a supplicant using IEEE 802.1X.
Such devices can be printers, meters or anything related to
fixed installations. Instead of 802.1X authorization, devices
can get access based on their MAC addresses being whitelisted.

For an authorization daemon to detect that a device is trying
to get access through a locked port, the bridge will add the
MAC address of the device to the FDB with a locked flag to it.
Thus the authorization daemon can catch the FDB add event and
check if the MAC address is in the whitelist and if so replace
the FDB entry without the locked flag enabled, and thus open
the port for the device.

This feature is known as MAC-Auth or MAC Authentication Bypass
(MAB) in Cisco terminology, where the full MAB concept involves
additional Cisco infrastructure for authorization. There is no
real authentication process, as the MAC address of the device
is the only input the authorization daemon, in the general
case, has to base the decision if to unlock the port or not.

With this patch set, an implementation of the offloaded case is
supplied for the mv88e6xxx driver. When a packet ingresses on
a locked port, an ATU miss violation event will occur. When
handling such ATU miss violation interrupts, the MAC address of
the device is added to the FDB with a zero destination port
vector (DPV) and the MAC address is communicated through the
switchdev layer to the bridge, so that a FDB entry with the
locked flag enabled can be added.

Hans Schultz (3):
  net: bridge: add fdb flag to extent locked port feature
  net: switchdev: add support for offloading of fdb locked flag
  net: dsa: mv88e6xxx: mac-auth/MAB implementation

 drivers/net/dsa/mv88e6xxx/Makefile            |  1 +
 drivers/net/dsa/mv88e6xxx/chip.c              | 10 +--
 drivers/net/dsa/mv88e6xxx/chip.h              |  5 ++
 drivers/net/dsa/mv88e6xxx/global1.h           |  1 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c       | 29 +++++++-
 .../net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c   | 67 +++++++++++++++++++
 .../net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h   | 20 ++++++
 drivers/net/dsa/mv88e6xxx/port.c              | 11 +++
 drivers/net/dsa/mv88e6xxx/port.h              |  1 +
 include/net/switchdev.h                       |  3 +-
 include/uapi/linux/neighbour.h                |  1 +
 net/bridge/br.c                               |  3 +-
 net/bridge/br_fdb.c                           | 13 +++-
 net/bridge/br_input.c                         | 11 ++-
 net/bridge/br_private.h                       |  5 +-
 15 files changed, 167 insertions(+), 14 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h

-- 
2.30.2

