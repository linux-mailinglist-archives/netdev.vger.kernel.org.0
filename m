Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0DFA3F2C5B
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 14:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238215AbhHTMoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 08:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237828AbhHTMoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 08:44:37 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04022C061575
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 05:44:00 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id e21so4096666ejz.12
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 05:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=giNz4IMQJBWP9MPpTNJl9KipRoS+mbRRhgoflH2MLuc=;
        b=baP/p1y6Id5GHg2j6wuQaaDBno0KZNyeB8YQbfZfByrzqp2iDkVPPFJka/xKkwp6Ag
         aGZzfxyIp3KjAIO6i2amosQy9oMzzO6cZ/XpnAfM9XhfGnjrXrhP13cHMDhE/ykRLsp/
         YIo/ILPY1HLFobWrtZZVYTL6oo3MJ08TJFuHddGwRXpuqbkKOM9V2p9UWExW8WF9jpRm
         CtPAXg6WY2PuBM8wCsuZ7Xd79qf9a1eOojUkZNx/D7LLGXsAfVzq397ono6XHCkVj5o0
         h5kIjd8cj3tBVoNtGWXmqzwvgs9JGm3vZqgrfM6V5yHZfjwHMTUmLNsLzVYpaC2UPyh8
         rmeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=giNz4IMQJBWP9MPpTNJl9KipRoS+mbRRhgoflH2MLuc=;
        b=t4EYcQnw8r+0kiEBsirs+71CRi52tbpjrGxI6XmrvVXnK72uOlF1FiaDoCpQzuUHmq
         tLFZcl/6fbJF7CVT2yU+a8c3YOrOd4jSJU2vO5KWkMdgy2EP1JaQjOFOD3ebHg2Jh13J
         HKvAt7i2XHjwLxRyQuVIxfUtRTHgDP4Lg6oafT2uQHjEH8pzUpXvEVQykLWfysHn0vA4
         DN3uCxtDYJBmROy84v/V11w8B3UFf4M7dJ9AFiVRXq6c/tkF+goqmTo6Jnh9ZuKx5ng1
         Tjr7SvMJ4rHUgSYzHUhct1WaE3KP+iMNYytsego+zJNtPWzMmX8BvcyfnGZ70taibqmB
         Mkpw==
X-Gm-Message-State: AOAM530NrSw3+UUnjPwaG5Exfbp6lXPpkHHD2dGwWWv5tuE19VbZfmKS
        D7IM9YMLv+tS8z/H3D59JZYd3Co4XR2IXsbe
X-Google-Smtp-Source: ABdhPJy9j8l2nWFIqj7zYdTJX4V77CWERzGmn2AXcVp2St4jibRZZvLcXL7siAbc0Js3vGS7sLuZAA==
X-Received: by 2002:a17:907:b07:: with SMTP id h7mr20616242ejl.406.1629463438243;
        Fri, 20 Aug 2021 05:43:58 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id ci19sm676627ejc.109.2021.08.20.05.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 05:43:57 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 0/2] net: bridge: mcast: add support for port/vlan router control
Date:   Fri, 20 Aug 2021 15:42:53 +0300
Message-Id: <20210820124255.1465672-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
This small set adds control over port/vlan mcast router config.
Initially I had added host vlan entry router control via vlan's global
options but that is really unnecessary and we can use a single per-vlan
option to control it both for port/vlan and host/vlan entries. Since
it's all still in net-next we can convert BRIDGE_VLANDB_GOPTS_MCAST_ROUTER
to BRIDGE_VLANDB_ENTRY_MCAST_ROUTER and use it for both. That makes much
more sense and is easier for user-space. Patch 01 prepares the port
router function to be used with port mcast context instead of port and
then patch 02 converts the global vlan mcast router option to per-vlan
mcast router option which directly gives us both host/vlan and port/vlan
mcast router control without any additional changes.

This way we get the following coherent syntax:
 [ port/vlan mcast router]
 $ bridge vlan set vid 100 dev ens20 mcast_router 2

 [ bridge/vlan mcast router ]
 $ bridge vlan set vid 100 dev bridge mcast_router 2
instead of:
 $ bridge vlan set vid 100 dev bridge mcast_router 1 global

The mcast_router should not be regarded as a global option, it controls
the port/vlan and bridge/vlan mcast router behaviour.

This is the last set needed for the initial per-vlan mcast support.
Next patch-sets:
 - iproute2 support
 - selftests

Thanks,
 Nik

Nikolay Aleksandrov (2):
  net: bridge: mcast: br_multicast_set_port_router takes multicast
    context as argument
  net: bridge: vlan: convert mcast router global opt to per-vlan entry

 include/uapi/linux/if_bridge.h |  2 +-
 net/bridge/br_multicast.c      | 24 ++++++++++++----
 net/bridge/br_netlink.c        |  3 +-
 net/bridge/br_private.h        | 18 +++++++++++-
 net/bridge/br_sysfs_if.c       |  2 +-
 net/bridge/br_vlan.c           |  1 +
 net/bridge/br_vlan_options.c   | 51 ++++++++++++++++++++++------------
 7 files changed, 74 insertions(+), 27 deletions(-)

-- 
2.31.1

