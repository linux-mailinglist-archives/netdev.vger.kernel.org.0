Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92D2418DF2
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 05:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbhI0Dgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 23:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbhI0Dgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 23:36:47 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B4AC061570;
        Sun, 26 Sep 2021 20:35:10 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id d13-20020a17090ad3cd00b0019e746f7bd4so9066918pjw.0;
        Sun, 26 Sep 2021 20:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xJ8/f7J07TrLJL5jvwHsvtwj9CrW3RcVBkgRN85Urbg=;
        b=JqGb1fDHwgiz42ZSzz+HOGCtEeMbx7afYtQyeMYzS+mcxfQ7SmxqKFtYBhNzIkoYFj
         +o+pqR4NKMvYaZc8VTIk38hIXdO32M5ZnHm5vnXgbKzE6JP+Tdg6QxFisl9kcrz0daQt
         hPXCIuCDGcNCtdiYZZj8KEzw45mziI3lTwW7C2CCS7Qi/3c0m1xj+E79sjJROPrcI5YV
         2MRALAv8smB3u+rT2NSjKM0JLF0/TZyDv6lmD8BmS2VGG34IhFvjGgpcOS3qmh8BVDNx
         12Q06XvNCoimmU8YzsY73pIEMj9a+bhqkgfLKTqVgjWKZN/E6szlq/40xL9utMA6hTGd
         R2wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xJ8/f7J07TrLJL5jvwHsvtwj9CrW3RcVBkgRN85Urbg=;
        b=q1aGqkRGvTuFHBn1pLBXkMi8nEsmC+KvdkxP94GGhxaJo2Ee43W58N6Ebw2a0DPCM1
         opLfokcrtD1m2q3pFiLbaXwAawDPh5aPJG1ulfQHVDu4+nhhAuasRDqKBkwgSf2xnnnf
         klvwq7jwq6eU+rykfam8GgHdvOwIZebIfH698RfXczWsNMtPSl8vriyvG2+LR4oYfsyD
         bQNrm9rg1KxRMI1+YDVN7OjIKWYmDSvIUpNQM0encvq7Wf7feVCoQu7JA3XuCSSbpAhW
         xYEZJTb4qh8ZTkq99bMUOs/P7A6t1AlT7E53iWvG0cU20eiFCantV2VFxlUkX5j2rYsP
         IotA==
X-Gm-Message-State: AOAM530NcZkN5GaB5lr3I0x4EfMQaLR28bnh7cTevh84ISNxNygNswhk
        wV0+Cosin/OulqWtN8EoEPE=
X-Google-Smtp-Source: ABdhPJzSplPkVJaCaXl+ZYVxi9p88xznm/FXpA2KQ/REwcmXoJP9STconydDNSae7+e060xpPpE3VQ==
X-Received: by 2002:a17:903:1d2:b0:13d:c967:c14 with SMTP id e18-20020a17090301d200b0013dc9670c14mr20473445plh.52.1632713709756;
        Sun, 26 Sep 2021 20:35:09 -0700 (PDT)
Received: from localhost.localdomain ([210.99.160.97])
        by smtp.googlemail.com with ESMTPSA id r206sm1404320pfc.218.2021.09.26.20.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 20:35:09 -0700 (PDT)
From:   MichelleJin <shjy180909@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, johannes@sipsolutions.net
Cc:     saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com,
        paulb@nvidia.com, ozsh@nvidia.com, lariel@nvidia.com,
        cmi@nvidia.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH net-next v4 0/3] check return value of rhashtable_init in mlx5e, ipv6, mac80211
Date:   Mon, 27 Sep 2021 03:34:54 +0000
Message-Id: <20210927033457.1020967-1-shjy180909@gmail.com>
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
 - split patch into mlx5e, ipv6, mac80211
v3->v4:
 - fix newly created warnings due to patches in net/ipv6/seg6.c


MichelleJin (3):
  net/mlx5e: check return value of rhashtable_init
  net: ipv6: check return value of rhashtable_init
  net: mac80211: check return value of rhashtable_init

 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 14 +++++++++++---
 net/ipv6/ila/ila_xlat.c                            |  6 +++++-
 net/ipv6/seg6.c                                    |  8 ++++++--
 net/ipv6/seg6_hmac.c                               |  4 +---
 net/mac80211/mesh_pathtbl.c                        |  5 ++++-
 5 files changed, 27 insertions(+), 10 deletions(-)

-- 
2.25.1

