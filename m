Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03FA74BBC80
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 16:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237250AbiBRPw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 10:52:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbiBRPw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 10:52:58 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493B4C8FB3;
        Fri, 18 Feb 2022 07:52:40 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id o6so4941631ljp.3;
        Fri, 18 Feb 2022 07:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=NOXnbT0tpVRz48yVyNiEYVuR08OrOB6ChAddX+U2Dyg=;
        b=Q7wn7Cojhp72LZWcdYZkPvTN8okK2pY51HB7JK3PTmbgpA3QEIHAGJ45oLn0iPAOF4
         fywkUlO8uruuKZKVhGX7wOLR3QEvXI6BtHNwd+1dAMlPPMeCMvyhhnFOW6nGctAHtGQl
         bJsLhvd94Qy0MG7Ig3AOFpZsdNkh7RkMbRy3Q3L5G0rS8UUrObcpEzImtveVM7AREszh
         QaIgPxJXxqVKwhYed4Lq3+p6JkKvtFSjK+tplUZhlSwQZD8N1gS3IhOo1XmaGg6hJ//p
         irUVkMfieS5I8LPWywcKPc6LYMTeOIHa8HG3y6T976yKTnOR1/LEKLhgPdeAoZrip+/q
         hHXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=NOXnbT0tpVRz48yVyNiEYVuR08OrOB6ChAddX+U2Dyg=;
        b=P68UO07sUBzB6Xopr99yWRN5RdbhWLhDgVPtDy9mVNlWwfY4GtikJhLiHYi/Xs1bK1
         WtspHjySk9H6Mzrzt+z9FhyZpnIy8+ZzohtHTeIMBURuSuPOnig15gALk1LYXwNBI2K+
         XYJAqom5ADqwV9XIRCa60RjmW1k6dE3Dw8MR9pjTjMPnCbETAnUYsZvOcNAG1lYg4a5v
         znUJ0N/RGjipFhIxHDSSWO8hD2jKgsOJl5CIYCTSqyQ9ls1eK2QUjHvlUabvIw4EtnAO
         BU4xXaCZRQOFmuRv2mIt9YmiXKoMN2Igs6E6lIEulNNaAojf2PSZxhKdL+C4XIVtK0tN
         7hBA==
X-Gm-Message-State: AOAM530ji4yXPfOVCzVHSKZ8FKv5capfkULYX+JwlnpPAn2wTrk1PF+q
        PfDZ2Mm5ktFGea7AEW69INa6fm3gIF7NmeQmEwM=
X-Google-Smtp-Source: ABdhPJxhn5cm48yKfZ9eYbWm1cULCmycRvaHWekI3UFoL9S1NcAVCK9NzKmPskiuv94wweFQPHV+JA==
X-Received: by 2002:a2e:9693:0:b0:239:3f32:671f with SMTP id q19-20020a2e9693000000b002393f32671fmr6234463lji.42.1645199558533;
        Fri, 18 Feb 2022 07:52:38 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id v11sm295453lfr.3.2022.02.18.07.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 07:52:37 -0800 (PST)
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
Subject: [PATCH net-next v3 0/5] Add support for locked bridge ports (for 802.1X)
Date:   Fri, 18 Feb 2022 16:51:43 +0100
Message-Id: <20220218155148.2329797-1-schultz.hans+netdev@gmail.com>
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
  net: dsa: Add support for offloaded locked port flag
  net: dsa: mv88e6xxx: Add support for bridge port locked mode
  selftests: forwarding: tests of locked port feature

 drivers/net/dsa/mv88e6xxx/chip.c              |   9 +-
 drivers/net/dsa/mv88e6xxx/port.c              |  33 ++++
 drivers/net/dsa/mv88e6xxx/port.h              |   9 +-
 include/linux/if_bridge.h                     |   1 +
 include/uapi/linux/if_link.h                  |   1 +
 net/bridge/br_input.c                         |  10 +-
 net/bridge/br_netlink.c                       |   6 +-
 net/bridge/br_switchdev.c                     |   2 +-
 net/dsa/port.c                                |   4 +-
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../net/forwarding/bridge_locked_port.sh      | 174 ++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |  16 ++
 12 files changed, 259 insertions(+), 7 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_locked_port.sh

-- 
2.30.2

