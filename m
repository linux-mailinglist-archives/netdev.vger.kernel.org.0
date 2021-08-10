Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E860F3E7C37
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 17:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243095AbhHJPaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 11:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241952AbhHJPaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 11:30:09 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08E8C0613C1
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:29:46 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id k29so14055763wrd.7
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S0ul/Cv2dQbKe/+VkzJwYP8SRzCc6gtnQ2xRNVtkMc0=;
        b=c//x2Wu8QQjep3b73PCrWSfxZQ4GrQCYCM06KdY08LzlRD/XXci3LlNWeGqEOJmS2a
         +mUcT6qH0Jv3LRXfhTajKHw9GpWyALwuw3574Au0s9zFhmfPgXJmEw4owWVU5F6sxzmz
         eQpq00UxnUs0BshzQkq0LL66Im4uYfBrU4ugfnnnSb7EH3hHJtNF0yaLw6lO21ExS9nM
         v+V+McMSquZdlMC1k11Zc2kiXHkSbAKxi2YH31QfsnKqSLDovj6foEfsDXuVXeWiwy/a
         wDZGUPTFP2EYp7EF65lITb0JsetISqOOSztIgA6rYZ88JJr7z35vfZsE3l68bp9ZyNBV
         boAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S0ul/Cv2dQbKe/+VkzJwYP8SRzCc6gtnQ2xRNVtkMc0=;
        b=K9EcrVD+vXTrO31nAHPEoT1T5+uHC56aImiS/j7/2OTeA53oIn4DydbFHXrm3KN/pM
         vgGD8PCY+cRK64wT1ZrQfJLJVA6hAViuPR8KnW+f2bT1iBlPelCaa0d0i54razFW1JpD
         pIO3ieMejNsQ3XHYD8A48b7eHsWFc55S9Pf5J3EjPDW3mJg/SvJReYBwlfz9ZA9Di+eh
         hWsGR4Bvq5ViJUtq4/71plNPSLfC+ojb7IRq7b0yASdZDnv5Y8XcxLKXrTEq64/7ziRN
         byErqcneLFvaySa2cItRV71NTNWwhCw/T74V07QJEwOyceJpQK8RIX56JOPNio/wZXTP
         FvRw==
X-Gm-Message-State: AOAM533GwPjroChBmErM1L08ZJPv0UOqV6SYGB1SdIYZNnX6zVY79Ewi
        pDa6V6SpvJRb4iHQ3gV5dsIeXUAVGKgQKzKI
X-Google-Smtp-Source: ABdhPJwt5tU6h5qM+B9hAAY8Txkmu/QgNuWbdUNcoOIjHqe1aDR/pK4wSNMIpFaYeAVUj5TZRsIBGg==
X-Received: by 2002:a05:6000:1201:: with SMTP id e1mr31339841wrx.379.1628609385148;
        Tue, 10 Aug 2021 08:29:45 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f15sm22848219wrp.12.2021.08.10.08.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 08:29:44 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 00/15] net: bridge: vlan: add global mcast options
Date:   Tue, 10 Aug 2021 18:29:18 +0300
Message-Id: <20210810152933.178325-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
This is the first follow-up set after the support for per-vlan multicast
contexts which extends global vlan options to support bridge's multicast
config per-vlan, it enables user-space to change and dump the already
existing bridge vlan multicast context options. The global option patches
(01 - 09 and 12-13) follow a similar pattern of changing current mcast
functions to take multicast context instead of a port/bridge directly.
Option equality checks have been added for dumping vlan range compression.
The last 2 patches extend the mcast router dump support so it can be
re-used when dumping vlan config.

patches 01 - 09: add support for various mcast options
patches 10 - 11: prepare for per-vlan querier control
patches 12 - 13: add support for querier control and router control
patches 14 - 15: add support for dumping per-vlan router ports

Next patch-sets:
 - per-port/vlan router option config
 - iproute2 support for all new vlan options
 - selftests

Thanks,
 Nik


Nikolay Aleksandrov (15):
  net: bridge: vlan: add support for mcast igmp/mld version global
    options
  net: bridge: vlan: add support for mcast last member count global
    option
  net: bridge: vlan: add support for mcast startup query count global
    option
  net: bridge: vlan: add support for mcast last member interval global
    option
  net: bridge: vlan: add support for mcast membership interval global
    option
  net: bridge: vlan: add support for mcast querier interval global
    option
  net: bridge: vlan: add support for mcast query interval global option
  net: bridge: vlan: add support for mcast query response interval
    global option
  net: bridge: vlan: add support for mcast startup query interval global
    option
  net: bridge: mcast: move querier state to the multicast context
  net: bridge: mcast: querier and query state affect only current
    context type
  net: bridge: vlan: add support for mcast querier global option
  net: bridge: vlan: add support for mcast router global option
  net: bridge: mcast: use the proper multicast context when dumping
    router ports
  net: bridge: vlan: use br_rports_fill_info() to export mcast router
    ports

 include/uapi/linux/if_bridge.h |  14 +++
 net/bridge/br_mdb.c            |  60 ++++++-----
 net/bridge/br_multicast.c      |  71 +++++++------
 net/bridge/br_netlink.c        |  14 ++-
 net/bridge/br_private.h        |  78 ++++++++++++--
 net/bridge/br_sysfs_br.c       |  10 +-
 net/bridge/br_vlan_options.c   | 186 ++++++++++++++++++++++++++++++++-
 7 files changed, 354 insertions(+), 79 deletions(-)

-- 
2.31.1

