Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A45417FEB
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 08:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347861AbhIYGMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 02:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237935AbhIYGMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 02:12:23 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63093C061571
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 23:10:49 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id me5-20020a17090b17c500b0019af76b7bb4so11236051pjb.2
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 23:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wuACCF5vEklB4kkJ2hqJNe3pMh/csEa6pee8hbcyNJo=;
        b=a6dnyCU47FdIL5fd37eA8nOtOcnBGoq7uVuhNSsszjEwX10rVQJYD9hd+KovdsKy0P
         NpFbsa9wc39Zd9djC8TFcSZ/I5eohnCoNs9X/pUCgcPHcFsOUre/nwoGbjL+DfcR3PPW
         bgEKGGs/N4qErTTdteRswPFrLFsWg8e8TILkxg6ChWJpunX160becW2GYWqQmdxRKyO0
         xHgYr4d6RCwo0SccyfwohJSuVFf6Yg6MkDGFPpcAi37Jnnnr3tXrAkhxdfzqVfewuSbk
         KK59fhHF54qnFnUQP9gcAYukLiJKQmofeHUhEPzcZnajMeg9hNFHe3mzHGn/KxfvrbJ3
         zhcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wuACCF5vEklB4kkJ2hqJNe3pMh/csEa6pee8hbcyNJo=;
        b=hY0bbm+e50JSruO+OHo8DOaqjovdx+XO/havy7R5jc9DC6fza6kovUxrqifQRBxzVs
         trsk6SeSX+0snL6IbsR9Rc9/Hr1JJYa6BNZKO73Q2dELFGBCtO+PveBMTl2gao1hiyh8
         mQe23sNrCJlWQ0tLneGpcf/r6YOIIrOuo2yYs4i5orWa0+1Te1XMqWQSPD0+fpG5fUvE
         tpYTWks8VdZbphFxxzIuBJ8IJD8SlYL3R+pJTWm4XdrneCp9RD2bqJfa4hvR8U58MJzz
         8oNWJNgwsPQTtX+bEsr0iJqCITFaDDEYkW5hd6kcENALFBMUj2IK7N/YfKYOuBrLt4Z9
         DI0w==
X-Gm-Message-State: AOAM531hlTfShSGZTCYqQRHUtXqxD+f69lGokytn9KYUZUYG5WaXbsQR
        mDLOc6WaB84fDKajZ8OVVmI=
X-Google-Smtp-Source: ABdhPJyKPIruMGZJhO7wjKv/OdRLNxAZWnVH4ZszMNBbFviSjTO4IiB4izKju68RPF15T78gCWIPRg==
X-Received: by 2002:a17:90a:19c2:: with SMTP id 2mr3969042pjj.227.1632550248677;
        Fri, 24 Sep 2021 23:10:48 -0700 (PDT)
Received: from localhost.localdomain ([1.234.131.174])
        by smtp.googlemail.com with ESMTPSA id s10sm12948169pjn.38.2021.09.24.23.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 23:10:48 -0700 (PDT)
From:   MichelleJin <shjy180909@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, johannes@sipsolutions.net
Cc:     saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com,
        paulb@nvidia.com, ozsh@nvidia.com, vladbu@nvidia.com,
        lariel@nvidia.com, cmi@nvidia.com, netdev@vger.kernel.org
Subject: [PATCH net-next v3 0/3] check return value of rhashtable_init in mlx5e, ipv6, mac80211.
Date:   Sat, 25 Sep 2021 06:10:34 +0000
Message-Id: <20210925061037.4555-1-shjy180909@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When rhashtable_init() fails, it returns -EINVAL.
However, since error return value of rhashtable_init is not checked,
it can cause use of uninitialized pointers.
So, fix unhandled errors of rhashtable_init.
The three patches are essentially the same logic.

v1->v2:
 - change commit message
 - fix possible memory leaks
v2->v3:
 - split patch into mlx5e, ipv6, mac80211.

MichelleJin (3):
  net/mlx5e: check return value of rhashtable_init
  net: ipv6: check return value of rhashtable_init
  net: mac80211: check return value of rhashtable_init

 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 14 +++++++++++---
 net/ipv6/ila/ila_xlat.c                            |  6 +++++-
 net/ipv6/seg6.c                                    |  6 +++++-
 net/ipv6/seg6_hmac.c                               |  6 +++++-
 net/mac80211/mesh_pathtbl.c                        |  5 ++++-
 5 files changed, 30 insertions(+), 7 deletions(-)

-- 
2.25.1

