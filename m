Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B4A437FD7
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 23:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbhJVVQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 17:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233750AbhJVVQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 17:16:13 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576A7C061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 14:13:55 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id n11-20020a17090a2bcb00b001a1e7a0a6a6so2950291pje.0
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 14:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/Mh1yeBhw36umITZdGWz1cSmTEJW6XBCvPJo3SZ2sUk=;
        b=ZCBKBDd45PK0tzVG1BFRY8wDw3gmCoops8wN8xAJqmZFJS0sOaA92O6dQzQyMbtib9
         i2u+Qno1cNtMSO1tPDZOogLEtzPhaksMpOiQU4zRJLq1HzoN3cvWT+H+S//2YDZ66eiT
         +KUyuUKNMVTquy9nBbbtQ07MsJrdXf8B4Et/ChzbhWmpmE+f8K4TVgNQLxsH8rRJyiWd
         en695GACQSVZKBdvcMbQPassmAWJRaIHpkaZ9OemRuXMUlMdn551n+a3oS2J5ywAOFMC
         mquBE9NufCIf9y9cyDVOjfgkx3V5YhgQkdcq68E9OnkHB4tk59yrMJvn003z2bMdtUYO
         HxeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/Mh1yeBhw36umITZdGWz1cSmTEJW6XBCvPJo3SZ2sUk=;
        b=5PxP2ncOd3RtQze64OvKeb1KjB3aDDgjL2dVl49dx6bVaH6fVbvD4KbmjWpqBE3ULs
         QesdCwiDXfpYW1i4giNhZ/Sn3Qq+fNTMJ03GX9UWCb15xj0spznmFHd771dF7lUI55z1
         IQtwAPqfD34H7Wl5LsROu26MaqnOYZ+ueWNzKXYgXnWk5omuweguUIPazRWm+Nwj4yVU
         E2CQV6yj9qmMw6e2jdUc1hF//tPQw91dbgSZYE91j6a3faMDA56AXXMvexuH3lJONway
         mWeq0r+eLqQw2JMIZFVTbLstx2ADqsQiSxkjb+Us470spbFwLjTTKjfT1l7PqKN4A3Ic
         3tGg==
X-Gm-Message-State: AOAM532fiQdqHSLjuaBXEKDlHrrlUvV5BuJ83efBijXAXxec/7cownuv
        1LZ2wyp+iV4RN9zjkvedB0DAUrq2meYmKg==
X-Google-Smtp-Source: ABdhPJw5rC1bceLA4Luy8nvxoUC3afzbJMbk2I5fycCCN4Dc+zHhtrwQHA1d7oY9e5mGOueui0qvUQ==
X-Received: by 2002:a17:90b:164b:: with SMTP id il11mr17646289pjb.98.1634937234475;
        Fri, 22 Oct 2021 14:13:54 -0700 (PDT)
Received: from localhost.localdomain ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id k3sm13684899pjg.43.2021.10.22.14.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 14:13:53 -0700 (PDT)
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
Subject: [PATCH v7 0/3] Make neighbor eviction controllable by userspace
Date:   Fri, 22 Oct 2021 14:08:15 -0700
Message-Id: <20211022210818.1088742-1-prestwoj@gmail.com>
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

v6 -> v7

 - Corrected logic checking all and netdev option

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

