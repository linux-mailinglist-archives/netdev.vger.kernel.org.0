Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF20532D42
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 17:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238833AbiEXPWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 11:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238823AbiEXPWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 11:22:06 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0E454BC2;
        Tue, 24 May 2022 08:22:03 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id a23so21273600ljd.9;
        Tue, 24 May 2022 08:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=iIwfYVv7fNEx0HicZDp/iynxMZIWTs5X4JU/e8Toj3Q=;
        b=YaH1DgHLdkIdhEkYiJgKlTaJvj4NY2mznzZKESIAkDFw10sVbEHVoiK2zstW/JE8nu
         nRp07bJCs6GvOyurfm4MwvVX1zkyRRlntXwRIot1WglIJROzBtn5sJ9lRAgQd39vCf7H
         q0zswAaje5UcywXY1hwzEXbjPNaQ9WWT5ckeoPlZ4ZE3KnfpGmJep2L2k7lAGcJpT7uO
         0VgE0jnh7gFcc0LzgHgyrg+kXKXRFwFZmKBIkKODmpBHwcjYCjL0a8bxWnmYwFwZHWhT
         Wz0X99R6O2cLOjxYvmWp3ynXDiuJqB5egZ3ShbmqlOMdet2pU2rn8i7MsgLYUqDG/HjT
         jRrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=iIwfYVv7fNEx0HicZDp/iynxMZIWTs5X4JU/e8Toj3Q=;
        b=LJafSphZ+xNmDwnQQ4Fb3Hd/zkMO2TJpjwxYZI69gwWG9gzS/21Pq3asYtyARO5C11
         WED+6mLVdxpdiarSWDCTvwmbZk1KuL98F8DMCSYOXPfbqvQGJjl+MdPcMm4W3jggo2Uw
         s/os1gxiUfuawM8xcVcI/MIeIiK/7NYSE3ENLQFLOp8EcWuBaTKGCMdlSA7VSNVjENV+
         HD5XAqRFtUdm7/2BA+s1KADjEU4CVC+LkS0qUswjuLges2/4zlxQM9G55DHzE7j6tk4P
         tqF0JIR9eP0E6seEcNk+IJYcSfSphcFHmbGU1bE7k++BwkVxFIT1Uos6d0Zo0KhVzfYO
         xN5w==
X-Gm-Message-State: AOAM531M0BhuDxqRb6lHX2T4BkELpi5fzkgSWJDumV17M3RCU4Hy1ctD
        5NezFkMcyc0SWAR21XWee9g=
X-Google-Smtp-Source: ABdhPJxKOf1Z5C8nqRQC4aBKdkYusKDJvRIrXFggpup7JrNlk7rEBE+aZ9ziKk36agciZEwkl2qFOw==
X-Received: by 2002:a2e:22c3:0:b0:253:e5f5:51f6 with SMTP id i186-20020a2e22c3000000b00253e5f551f6mr8645905lji.293.1653405720493;
        Tue, 24 May 2022 08:22:00 -0700 (PDT)
Received: from wse-c0127.westermo.com (2-104-116-184-cable.dk.customer.tdc.net. [2.104.116.184])
        by smtp.gmail.com with ESMTPSA id d22-20020a2e3316000000b00253deeaeb3dsm2441404ljc.131.2022.05.24.08.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 08:21:59 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH V3 net-next 0/4] Extend locked port feature with FDB locked flag (MAC-Auth/MAB)
Date:   Tue, 24 May 2022 17:21:40 +0200
Message-Id: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
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

Hans Schultz (4):
  net: bridge: add fdb flag to extent locked port feature
  net: switchdev: add support for offloading of fdb locked flag
  net: dsa: mv88e6xxx: mac-auth/MAB implementation
  selftests: forwarding: add test of MAC-Auth Bypass to locked port
    tests

 drivers/net/dsa/mv88e6xxx/Makefile            |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c              |  40 ++-
 drivers/net/dsa/mv88e6xxx/chip.h              |   5 +
 drivers/net/dsa/mv88e6xxx/global1.h           |   1 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c       |  35 ++-
 .../net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c   | 249 ++++++++++++++++++
 .../net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h   |  40 +++
 drivers/net/dsa/mv88e6xxx/port.c              |  32 ++-
 drivers/net/dsa/mv88e6xxx/port.h              |   2 +
 include/net/dsa.h                             |   6 +
 include/net/switchdev.h                       |   3 +-
 include/uapi/linux/neighbour.h                |   1 +
 net/bridge/br.c                               |   3 +-
 net/bridge/br_fdb.c                           |  18 +-
 net/bridge/br_if.c                            |   1 +
 net/bridge/br_input.c                         |  11 +-
 net/bridge/br_private.h                       |   9 +-
 .../net/forwarding/bridge_locked_port.sh      |  42 ++-
 18 files changed, 470 insertions(+), 29 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h

-- 
2.30.2

