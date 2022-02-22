Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5014BF954
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 14:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbiBVN3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 08:29:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiBVN3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 08:29:50 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4EAB996AC;
        Tue, 22 Feb 2022 05:29:22 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id t14so19514909ljh.8;
        Tue, 22 Feb 2022 05:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=VHfLSHEUp8KFCoSMOat+t/9h+kqq+wol9Ucvkw0K0Ko=;
        b=el49x+sn8P8oo55vRYxMrzV9h6912Vs30PpYWE8XEE5Rg+Hbs6HMyLY17n57nDsZ7O
         aoqx1c9OHaZ+Io5wS879xBafzK7c3Nf0tDkUmGyZL/zAGoHi75UCpa8k6+houBXp1q4V
         oFKaIFEQ1XZjaAI9XSfYbL/ejqEd9A3NgguMLlye8h++oKStvlezt2WHfREbhW9tu78h
         TOmJy3YMPDou7kHbHKL01G6PML1X6EUBiyYiH69UE2IfX89VoVAYcQg3lIcVJ2eK9Xgr
         MRsKNi1LEy5RTLMHVHqNe/dArG8PdYs/+741BQpMPmFGCW6ZciZRDkhPEpznBW+slsoA
         /Ong==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=VHfLSHEUp8KFCoSMOat+t/9h+kqq+wol9Ucvkw0K0Ko=;
        b=zoEVKeKQdim4yat5jgr8gskzAaN3GhdlI2zwxu1a3Y02JeVBb9dZSEHWdhufyHsGwL
         ADBeyUZ2aDziOXH7Z/3s1/gbqAP5Ta2lql7VKhkWSkuFaScWzc5BE8vK1EiyHCyudk1F
         TC/edOc2xsGXbQ9TOK/9iLzITI9fpoya1Y5zCqKbBE9rgL4VSrD55+2HXl4lzaGbZNQm
         mlRDPgS9/f6R3v2o8XvL3hDEMi3DnJSHvQLJ2K+zgV7StwtxhRyIRPcczHSdmAkqCbtV
         53YpcVL2v+gMRA85McZI3yrITW0foROl/gD0vGacGFWlyZ9tdYsoLlI4r08p7sh8qNA6
         SF4g==
X-Gm-Message-State: AOAM531bdnAZugdaKMqYdbTOtc3rO8y7ysUkwltcJrk6b0PYz8nwW3z/
        LecK6GIgIjKMBsMHJXGstDs=
X-Google-Smtp-Source: ABdhPJxlMGmaG+tjtwWeeYytkr79toeqRMRJY7lpZtYdhn6zv6UTQAyG41KqbPEYkrroWlEL+S63rA==
X-Received: by 2002:a2e:a270:0:b0:245:f51f:354 with SMTP id k16-20020a2ea270000000b00245f51f0354mr18263908ljm.497.1645536560909;
        Tue, 22 Feb 2022 05:29:20 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id e22sm1703685ljb.17.2022.02.22.05.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 05:29:20 -0800 (PST)
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
Subject: [PATCH net-next v4 0/5] Add support for locked bridge ports (for 802.1X)
Date:   Tue, 22 Feb 2022 14:28:13 +0100
Message-Id: <20220222132818.1180786-1-schultz.hans+netdev@gmail.com>
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

