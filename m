Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CF7417FE6
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 08:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347860AbhIYGHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 02:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbhIYGHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 02:07:42 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA90C061571
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 23:06:08 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id lp9-20020a17090b4a8900b0019ea2b54b61so1839792pjb.1
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 23:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wuACCF5vEklB4kkJ2hqJNe3pMh/csEa6pee8hbcyNJo=;
        b=UZA/i16zreEjA3sYvbViKmwkmCTuuq0ezMjae03s7RBPGjkXLMJGQba8Sf4t1R/ZTx
         e+6jHOakTUGIqFtWWaOlpUwjszWx8PE4Q8X7vWS5Yhxw84uaVXqrqViTBp7+BiBN+Nhm
         dirHcEyfqcqbsmY1HtrZE7xEFEaMGsM78w8goeTTOf//Tyk1Igll2llHsSiM6Eirg2sJ
         5B6zCvugz6a6aNhpfIVvA1QHBxXoynwKr6pUCfZYdbWJsGKtBOOgEd6G0ANbdnKdwFPe
         fUWlmu79BTbSQinJmy4TlGp2DbfUrdnpRpFOviS2ZQbm5OfjdNC4ilDRdiVNPydq9Ktl
         HGhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wuACCF5vEklB4kkJ2hqJNe3pMh/csEa6pee8hbcyNJo=;
        b=ADL2vSYiuqz4qA7U4HKeJvux98xtStw41vav38i0NUO8xV3GcLp0pKw4a+ogS4e9ZS
         MCod6RM4kdCQP2esMSJV6HHiVLjq5NoSq3sVp51bGkoFLwDkWbY7ktJoILoXXJ0SIBjC
         uLMTP5OOaoTm8yWBZYTZERwx920WVvcw6XlTpjBzUUHrDuXMgF2TNei3GmhgMgp5C1+c
         2I/s9j0nlrdt04yyU45PY3eBXY9/vUZL2nlmLa32UrC1z+f+LvrRo/DOmqcF6dxmx2sU
         +96zw/687aVhtUUZfnmMx4sl3ICzmgvx9QD8w7oF3aG3AurYuyUQMgWAiKC8Ep6lTLJB
         iwkg==
X-Gm-Message-State: AOAM533gDj1elqdhapJ23bUdkEw+RZqWWv6J+zX3sBzB2MtYfkO549Nh
        wiHMl0oPS3331dbhbcASVSM=
X-Google-Smtp-Source: ABdhPJwq2x91Wmhmt3IlP+UyAaZXLSqpD03wGBVihhjp0WuQLJdtg+ZjIWzMAHwW1d1oxZDRaQGYLg==
X-Received: by 2002:a17:902:7e8a:b0:13d:95e2:d9c2 with SMTP id z10-20020a1709027e8a00b0013d95e2d9c2mr12459485pla.8.1632549966060;
        Fri, 24 Sep 2021 23:06:06 -0700 (PDT)
Received: from localhost.localdomain ([1.234.131.174])
        by smtp.googlemail.com with ESMTPSA id 26sm13650587pgx.72.2021.09.24.23.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 23:06:05 -0700 (PDT)
From:   MichelleJin <shjy180909@gmail.com>
To:     avem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, johannes@sipsolutions.net
Cc:     saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com,
        paulb@nvidia.com, ozsh@nvidia.com, vladbu@nvidia.com,
        lariel@nvidia.com, cmi@nvidia.com, netdev@vger.kernel.org
Subject: [PATCH net-next v3 0/3] check return value of rhashtable_init in mlx5e, ipv6, mac80211.
Date:   Sat, 25 Sep 2021 06:05:06 +0000
Message-Id: <20210925060509.4297-1-shjy180909@gmail.com>
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

