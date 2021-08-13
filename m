Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888273EB737
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 17:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241000AbhHMPAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 11:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240920AbhHMPAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 11:00:37 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E179C061756
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 08:00:10 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id dj8so7983423edb.2
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 08:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dI0OL75ZDd6qvxHet20KtzBgKETMju9g8K1SgE3M6N0=;
        b=P2UJZm2hzcIeNVyOlO5mFN4pF3gq+JnzhGkW9XxE8KHbLSIohnqzR3b/S2TKmx2yLI
         368ERvOOJ34F7M9EwV8/4IZQofaGhm6rRlan/cy1CbB/n6nGpPQaGTyyHtDjU9lYj55F
         2DAMLTw3Fk2PxmvDZn2aZHxPF1WGk54yVd2NXLS055+9UqegdO1Zq4v9142rNSG0VYx6
         3BoOtU0D1okY9IV9gs3dnZ2A0zNTpqMWJ3v3X4noaDcwo5+F8p0KQmVo8DUzwhfqgOgk
         EPBwbs1IKj725aBLhfJ87NxRB1VyK3NaEuUxREWJ130/v8rxCURGWCQdANoFutyWU5+9
         Q8qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dI0OL75ZDd6qvxHet20KtzBgKETMju9g8K1SgE3M6N0=;
        b=Y/qg/15IZ6WEuEPZ+pB8UAHtyHNFCeYVNIqDgjdYvF4TqEk7cQRBpiPlH4GInHKG1M
         dnXYzo8rFfuW6jcwNtgqajBKSniCYT5tARRvqf4WteTOaMeiRMgLvZmunzap1KRaLTcP
         QG3qKl3p/b1SrOZtdtuASF26DSAwWEqW2Fqiv1MTdJrvTcYSzRjT3zuaJBbwFWM3teSh
         KKkXuEzOqdNyFf1fCIGquDMxN39Eyuy5JPqyFtGbrgmG+LGeAF05yC00Jw7Pg1tAW1k1
         nCoxcoLDZf9EIzyg1h+lEMO8hjFFp9vWK42hyra7EMe9WzyQIpkQn8TEioPGMwgKvUou
         vGxA==
X-Gm-Message-State: AOAM533m75GJmA5o3DM1A/vFfMQdcadQK2O7FEY0vBIuVk1tO7Ecq6X4
        6VLOT1RPhL8MP1zGhtisVD2rQXbPLu/gcksq
X-Google-Smtp-Source: ABdhPJyYifc7+XPWlMVi/7848S4sNcl5ZyARkG/TSdSXEdPB44hSxC6pbR70UhBf0mdQddj4mUJv7Q==
X-Received: by 2002:a50:9b03:: with SMTP id o3mr3555794edi.203.1628866808352;
        Fri, 13 Aug 2021 08:00:08 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id d26sm1015711edp.90.2021.08.13.08.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 08:00:07 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 0/6] net: bridge: mcast: dump querier state
Date:   Fri, 13 Aug 2021 17:59:56 +0300
Message-Id: <20210813150002.673579-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
This set adds the ability to dump the current multicast querier state.
This is extremely useful when debugging multicast issues, we've had
many cases of unexpected queriers causing strange behaviour and mcast
test failures. The first patch changes the querier struct to record
a port device's ifindex instead of a pointer to the port itself so we
can later retrieve it, I chose this way because it's much simpler
and doesn't require us to do querier port ref counting, it is best
effort anyway. Then patch 02 makes the querier address/port updates
consistent via a combination of multicast_lock and seqcount, so readers
can only use seqcount to get a consistent snapshot of address and port.
Patch 03 is a minor cleanup in preparation for the dump support, it
consolidates IPv4 and IPv6 querier selection paths as they share most of
the logic (except address comparisons of course). Finally the last three
patches add the new querier state dumping support, for the bridge's
global multicast context we embed the BRIDGE_QUERIER_xxx attributes
into IFLA_BR_MCAST_QUERIER_STATE and for the per-vlan global mcast
contexts we embed them into BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_STATE.

The structure is:
  [IFLA_BR_MCAST_QUERIER_STATE / BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_STATE]
  `[BRIDGE_QUERIER_IP_ADDRESS] - ip address of the querier
  `[BRIDGE_QUERIER_IP_PORT]    - bridge port ifindex where the querier was
                                 seen (set only if external querier)
  `[BRIDGE_QUERIER_IP_OTHER_TIMER]   -  other querier timeout
  `[BRIDGE_QUERIER_IPV6_ADDRESS] - ip address of the querier
  `[BRIDGE_QUERIER_IPV6_PORT]    - bridge port ifindex where the querier
                                   was seen (set only if external querier)
  `[BRIDGE_QUERIER_IPV6_OTHER_TIMER]   -  other querier timeout

Later we can also add IGMP version of seen queriers and last seen values
from the queries.

Thanks,
 Nik

Nikolay Aleksandrov (6):
  net: bridge: mcast: record querier port device ifindex instead of
    pointer
  net: bridge: mcast: make sure querier port/address updates are
    consistent
  net: bridge: mcast: consolidate querier selection for ipv4 and ipv6
  net: bridge: mcast: dump ipv4 querier state
  net: bridge: mcast: dump ipv6 querier state
  net: bridge: vlan: dump mcast ctx querier state

 include/uapi/linux/if_bridge.h |  14 +++
 include/uapi/linux/if_link.h   |   1 +
 net/bridge/br_multicast.c      | 211 ++++++++++++++++++++++++++-------
 net/bridge/br_netlink.c        |   5 +-
 net/bridge/br_private.h        |   7 +-
 net/bridge/br_vlan_options.c   |   5 +-
 6 files changed, 199 insertions(+), 44 deletions(-)

-- 
2.31.1

