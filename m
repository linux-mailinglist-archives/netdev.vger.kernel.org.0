Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8D654C1008
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 11:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237964AbiBWKRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 05:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233112AbiBWKRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 05:17:46 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C4840E59;
        Wed, 23 Feb 2022 02:17:17 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id p20so15479299ljo.0;
        Wed, 23 Feb 2022 02:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=VHfLSHEUp8KFCoSMOat+t/9h+kqq+wol9Ucvkw0K0Ko=;
        b=k1DlUK+usCMRnP3C9A4Um65d39JlmyImGuUf8kGcxM0n6R0i8bPlGb6nd63eZNQ7xI
         fSBiKr1ZKRVzRHMQTNxQjLl8Lgc21OCi5SVutYxnjauOicHe+rURiTHS5vfFl+oobaQ2
         c40kJBYPe+h9El3Kl8DdWID3B2zSwWE2dWa16FfjySkniGme8aLxeQY71plvWQnrV/ud
         dqHCfO63qmPXXuJh9WF8AQ9z6Umyeu8+QFJOcSEr1XP5VuaXlgT6pxQvmW7tP/zJUMBz
         gAka2nCqILuvDUA8E21NMHr0klvc8Bmmd4OnBraKu9nf4zgQfP44pcL8sCvwzXBBuVLi
         cFzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=VHfLSHEUp8KFCoSMOat+t/9h+kqq+wol9Ucvkw0K0Ko=;
        b=Yzl1uIYvW+g9hZtmYUqOR0//Nb27VC+b0txd0KXMD67gKnZBUGzUZ8q6Dh3nw65iM9
         km/yD7ZqFH7PS17MnprOOGniFGzSMEo/tec2ARRQjYHyMweWKZrNI9IWY2RPQp1lRLQJ
         IpOedqDidi0NB9pGDfKL2T+QbLxNa2GRCjxDVPFqGnpPto2OG3/7sIXAK0W7i2Eg5+98
         Si4JIphnLa3soBKm7Q+Jovpm1+aphJMXrWhDRtUnbKGnD1R+Y4RJVW/kj1ARGduodT7L
         nD3OO5Q7Q2XdPX5bG9gvLTv2T4YpK/LqOyn6zgUCM3PZ5RBFxD1U00Xz+gCjaGGICDks
         OcEA==
X-Gm-Message-State: AOAM530IZUyP4Kp+VeoVXIveeVgGhC6Qrm96eLNyYJvrBR4IiS/5+EK7
        gk7Ti5k5E/WxkeyGDhUVm10=
X-Google-Smtp-Source: ABdhPJzWeC6l92IEmzs6ZrdOX53TDB7MrYZGYy+pM2qk9SFWWT556NiUE9DjgCSebqQ2rv2/1JGtBA==
X-Received: by 2002:a2e:bc17:0:b0:246:32b7:464 with SMTP id b23-20020a2ebc17000000b0024632b70464mr13473270ljf.506.1645611435483;
        Wed, 23 Feb 2022 02:17:15 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id d5sm1613102lfs.307.2022.02.23.02.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 02:17:14 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next v5 0/5] Add support for locked bridge ports (for 802.1X)
Date:   Wed, 23 Feb 2022 11:16:45 +0100
Message-Id: <20220223101650.1212814-1-schultz.hans+netdev@gmail.com>
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

This series starts by adding support for SA filtering to the bridge,
which is then allowed to be offloaded to switchdev devices. Furthermore
an offloading implementation is supplied for the mv88e6xxx driver.

Public Local Area Networks are often deployed such that there is a
risk of unauthorized or unattended clients getting access to the LAN.
To prevent such access we introduce SA filtering, such that ports
designated as secure ports are set in locked mode, so that only
authorized source MAC addresses are given access by adding them to
the bridges forwarding database. Incoming packets with source MAC
addresses that are not in the forwarding database of the bridge are
discarded. It is then the task of user space daemons to populate the
bridge's forwarding database with static entries of authorized entities.

The most common approach is to use the IEEE 802.1X protocol to take
care of the authorization of allowed users to gain access by opening
for the source address of the authorized host.

With the current use of the bridge parameter in hostapd, there is
a limitation in using this for IEEE 802.1X port authentication. It
depends on hostapd attaching the port on which it has a successful
authentication to the bridge, but that only allows for a single
authentication per port. This patch set allows for the use of
IEEE 802.1X port authentication in a more general network context with
multiple 802.1X aware hosts behind a single port as depicted, which is
a commonly used commercial use-case, as it is only the number of
available entries in the forwarding database that limits the number of
authenticated clients.

      +--------------------------------+
      |                                |
      |      Bridge/Authenticator      |
      |                                |
      +-------------+------------------+
       802.1X port  |
                    |
                    |
             +------+-------+
             |              |
             |  Hub/Switch  |
             |              |
             +-+----------+-+
               |          |
            +--+--+    +--+--+
            |     |    |     |
    Hosts   |  a  |    |  b  |   . . .
            |     |    |     |
            +-----+    +-----+

The 802.1X standard involves three different components, a Supplicant
(Host), an Authenticator (Network Access Point) and an Authentication
Server which is typically a Radius server. This patch set thus enables
the bridge module together with an authenticator application to serve
as an Authenticator on designated ports.


For the bridge to become an IEEE 802.1X Authenticator, a solution using
hostapd with the bridge driver can be found at
https://github.com/westermo/hostapd/tree/bridge_driver .


The relevant components work transparently in relation to if it is the
bridge module or the offloaded switchcore case that is in use.

Hans Schultz (5):
  net: bridge: Add support for bridge port in locked mode
  net: bridge: Add support for offloading of locked port flag
  net: dsa: Include BR_PORT_LOCKED in the list of synced brport flags
  net: dsa: mv88e6xxx: Add support for bridge port locked mode
  selftests: forwarding: tests of locked port feature

 drivers/net/dsa/mv88e6xxx/chip.c              |   9 +-
 drivers/net/dsa/mv88e6xxx/port.c              |  29 +++
 drivers/net/dsa/mv88e6xxx/port.h              |   9 +-
 include/linux/if_bridge.h                     |   1 +
 include/uapi/linux/if_link.h                  |   1 +
 net/bridge/br_input.c                         |  11 +-
 net/bridge/br_netlink.c                       |   6 +-
 net/bridge/br_switchdev.c                     |   2 +-
 net/dsa/port.c                                |   4 +-
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../net/forwarding/bridge_locked_port.sh      | 180 ++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |   8 +
 12 files changed, 254 insertions(+), 7 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_locked_port.sh

-- 
2.30.2

