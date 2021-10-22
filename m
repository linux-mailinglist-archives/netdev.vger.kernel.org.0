Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABA2437C6F
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 20:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbhJVSJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 14:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbhJVSJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 14:09:03 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB011C061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 11:06:45 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id r2so4003934pgl.10
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 11:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kst33Atxyziwhqg9ncbCIxRcKeHmtIkpqf40LNSwl1I=;
        b=kCNqSInVgfuj9cxD3cp0i2tjS8NTMHA9/MpabODqMYf71e+Ygol2W1JRLe8iw0YMyY
         +SIzQq2pZLEgCQ/x9vZIhyAunxCntEWlSvErEjSByVJ0iAEb65C6/EcbGtL0O0FvxcoP
         fibbNGnB2xxZN7cUI9Eo57Ggoegw2NDsOgdUVLXni2mWUf507VIZEdo0/w8EzBlHTuqn
         znWm5kOTLH68P/BayRqlW91ESM5F/bQuP/xqC20Yi99qkEDoeoPdDw1XCB4gecyDBZYV
         tI031om2v/qM7Uqm15X5vk+at6rhAW+6hs7A9f4OHyeAUagPAjEDRLZubIjio9NJ8rJM
         KzbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kst33Atxyziwhqg9ncbCIxRcKeHmtIkpqf40LNSwl1I=;
        b=CWM8Eeflu0mXgqydVJjkrj0GLc6whG4KfiKlabAH0P9yL7OR0t640x5FhkZUIXhfel
         tYe+Ro8nUVJlBRO87bhTzwNG7rH9PDEOWx/dpCsbEmsCjoLqIeXQK3GybMaT4ZxpfH1Q
         1djCateRYv7Rb1K446tPKgwV4kapRxPmISY9VUmQDZqVBjGbZccr7cqSkquGc6QdEaJQ
         8MbMbY6ttyJ3VS4ZNWg8Z3vWXEHFzKxhT/bcTMylTV8KmpA+xCxvH88Lz5AZCfIyYR7n
         27M/E/KUXblFwfSLj1MgjTZnE2dJ1fB1wDj5PtJal5+ZHBJ/u8lbXnB64Kr0kdjqjD2M
         CN+w==
X-Gm-Message-State: AOAM530jH2aL/PnuCW4CFk8MoSG0GmP70RH8d5ydkoLCu+EOvxl3oqyJ
        5XBN+yT63o57dAbfpf66TIEZSHObEXxAVg==
X-Google-Smtp-Source: ABdhPJys7vCfziMrQkkJUIP6gJh/LAh3WKIPbb58pG6/uTgHwPger4XyyzfzYfS9wlBR++dCkzJYgQ==
X-Received: by 2002:a63:7247:: with SMTP id c7mr908654pgn.365.1634926005075;
        Fri, 22 Oct 2021 11:06:45 -0700 (PDT)
Received: from localhost.localdomain ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id a3sm11912576pfv.174.2021.10.22.11.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 11:06:44 -0700 (PDT)
From:   James Prestwood <prestwoj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     James Prestwood <prestwoj@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Tong Zhu <zhutong@amazon.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH v6 0/3] Make neighbor eviction controllable by userspace
Date:   Fri, 22 Oct 2021 11:00:55 -0700
Message-Id: <20211022180058.1045776-1-prestwoj@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1 -> v2:

 - It was suggested by Daniel Borkmann to extend the neighbor table settings
   rather than adding IPv4/IPv6 options for ARP/NDISC separately. I agree
   this way is much more concise since there is now only one place where the
   option is checked and defined.
 - Moved documentation/code into the same patch
 - Explained in more detail the test scenario and results

v2 -> v3:

 - Renamed 'skip_perm' to 'nocarrier'. The way this parameter is used
   matches this naming.
 - Changed logic to still flush if 'nocarrier' is false.

v3 -> v4:

 - Moved NDTPA_EVICT_NOCARRIER after NDTPA_PAD

v4 -> v5:

 - Went back to the original v1 patchset and changed:
 - Used ANDCONF for IN_DEV macro
 - Got RCU lock prior to __in_dev_get_rcu(). Do note that the logic
   here was extended to handle if __in_dev_get_rcu() fails. If this
   happens the existing behavior should be maintained and set the
   carrier down. I'm unsure if get_rcu() can fail in this context
   though. Similar logic was used for in6_dev_get.
 - Changed ndisc_evict_nocarrier to use a u8, proper handler, and
   set min/max values.

v5 -> v6

 - Added selftests for both sysctl options
 - (arp) Used __in_dev_get_rtnl rather than getting the rcu lock
 - (ndisc) Added in6_dev_put
 - (ndisc) Check 'all' option as well as device specific

Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: Ido Schimmel <idosch@nvidia.com>
Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
Cc: Yajun Deng <yajun.deng@linux.dev>
Cc: Tong Zhu <zhutong@amazon.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni@codeaurora.org>

James Prestwood (3):
  net: arp: introduce arp_evict_nocarrier sysctl parameter
  net: ndisc: introduce ndisc_evict_nocarrier sysctl parameter
  selftests: net: add arp_ndisc_evict_nocarrier

 Documentation/networking/ip-sysctl.rst        |  18 ++
 include/linux/inetdevice.h                    |   2 +
 include/linux/ipv6.h                          |   1 +
 include/uapi/linux/ip.h                       |   1 +
 include/uapi/linux/ipv6.h                     |   1 +
 include/uapi/linux/sysctl.h                   |   1 +
 net/ipv4/arp.c                                |  11 +-
 net/ipv4/devinet.c                            |   4 +
 net/ipv6/addrconf.c                           |  12 ++
 net/ipv6/ndisc.c                              |  12 +-
 .../net/arp_ndisc_evict_nocarrier.sh          | 181 ++++++++++++++++++
 11 files changed, 242 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh

-- 
2.31.1

