Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9844571E9
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 16:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbhKSPqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 10:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235307AbhKSPqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 10:46:37 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13405C061748
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 07:43:36 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso9144339pjb.2
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 07:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=szLwmj+ZzAzD0eKnRu6DSA7HHU0sRZMMWA8P7CsKNZc=;
        b=hZV9OQBwqKsOhnZ3gGQFUWnOoDS84RXEz4w7cVFbBTGGvlWK9V8kTXEBYwvFfbmKkL
         rCKhDUDwphFidEbcNW385LZ6TPyBcEl2PdBdvfnO0gDIu77sCqB38fOrIMmPoBof8Stb
         C2eyU3izAuluWuKANBN+QSD2gQJ2xZKmVosKyfS0bzAZhdmMBVJRwY8gSsnbmoWnkZTA
         uFGTQtLKfQoq1dyKn33b1+v8tveEffqPe9OglUErFp+ztHymUxssHKFEKv7pjCiBIu+F
         jxCYlp/bZhu1bv45HMFaFq6Ee3IlEh43vr/7rAD2kEA1aMLFqiuS803svfTyRnBog9ky
         ZBew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=szLwmj+ZzAzD0eKnRu6DSA7HHU0sRZMMWA8P7CsKNZc=;
        b=g+kAGfprq2gakHlTDqt6beLJQbZH4IG8NZ60FRI8lvGVrOusO7rNV15sG2bYMF7Fe1
         3j9+1mLrvc8RnhQc3z2+nXPyqoVlYGdOZALH82pVmUojnWhe3/iLJLk+IQR4LgHklEkT
         qImQ6MVJfp9v4mSrruAb8Y1++TcaUj1gBoAe087Mf93DbTZgh8id1keAaDrpbIcfir24
         AICTuULHUni9VK7nst2TUL4mTY4z3KbQ0LUIj3o5jQIcHYYfgjarZD3nubUUw0WNp/gY
         GgCAK5PHZBie1sBGn74x816BgbpL5S8F/bpLadyBweK53VWK+xV+N4Uy+/ZBl3Rx4Fb+
         3o9Q==
X-Gm-Message-State: AOAM5308VnDIrQS8ssBXo7tNL8OUEovVfrCHTTSzgGG2W5wL1LQLAt3l
        2TyISDsqHfpQow7do141qKU=
X-Google-Smtp-Source: ABdhPJxM6DfOv0xw6Hm5+MAw2Mg4qi6my6gxblWKSmuYJ0ESgjp6fwDm/G9I1z3O98yq8aaqzZIyEw==
X-Received: by 2002:a17:90b:128e:: with SMTP id fw14mr609158pjb.173.1637336615612;
        Fri, 19 Nov 2021 07:43:35 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:fc03:ed5a:3e05:8b5e])
        by smtp.gmail.com with ESMTPSA id n1sm68242pfj.193.2021.11.19.07.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 07:43:35 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/2] net: annotate accesses to dev->gso_max_{size|segs}
Date:   Fri, 19 Nov 2021 07:43:30 -0800
Message-Id: <20211119154332.4110795-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Generalize use of netif_set_gso_max_{size|segs} helpers and document
lockless reads from sk_setup_caps()

Eric Dumazet (2):
  net: annotate accesses to dev->gso_max_size
  net: annotate accesses to dev->gso_max_segs

 drivers/net/bonding/bond_main.c                      |  2 +-
 drivers/net/ethernet/freescale/fec_main.c            |  2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c           |  2 +-
 drivers/net/ethernet/marvell/mvneta.c                |  2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c      |  2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c |  2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c |  2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c  |  2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c    |  6 +++---
 drivers/net/ethernet/realtek/r8169_main.c            |  8 ++++----
 drivers/net/ethernet/sfc/ef100_nic.c                 |  6 +++---
 drivers/net/ethernet/sfc/efx.c                       |  2 +-
 drivers/net/ethernet/sfc/falcon/efx.c                |  2 +-
 drivers/net/ipvlan/ipvlan_main.c                     |  8 ++++----
 drivers/net/macvlan.c                                |  8 ++++----
 drivers/net/veth.c                                   |  4 ++--
 drivers/net/vxlan.c                                  |  4 ++--
 include/linux/netdevice.h                            | 10 +++++++++-
 net/8021q/vlan.c                                     |  4 ++--
 net/8021q/vlan_dev.c                                 |  4 ++--
 net/bridge/br_if.c                                   |  4 ++--
 net/core/dev.c                                       |  2 +-
 net/core/rtnetlink.c                                 |  4 ++--
 net/core/sock.c                                      |  6 ++++--
 net/sctp/output.c                                    |  2 +-
 25 files changed, 55 insertions(+), 45 deletions(-)

-- 
2.34.0.rc2.393.gf8c9666880-goog

