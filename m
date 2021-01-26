Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AFF304106
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 15:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391105AbhAZOz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 09:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389908AbhAZJgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 04:36:22 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D505C06174A
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 01:35:40 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id l9so22022928ejx.3
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 01:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=73ciu6eFOPHbqo4MJgjXh4/QYZ5M67T1wK+DASmK9NE=;
        b=DaguywYnXaB5G+/wUWtHvNyDG1c1zijWNwRMBQDCYCF62OfhAdXJOnm+M7+Alsq7Lu
         +UYRLmbfdv2rr92dPElP66Em4P6ykmydnfyuWxSwffY/iWRIYQ61Tt98d0dDjdEO70Z0
         h44GqX/EmP0wFQgmZNs4oD3W4NnmUBuK+mAi/Af2zR00chDU3nsi/k3FHJ16Qa1QJ/6e
         OGRrfpUEXHRvd9z0kxW8Vtu933kts++nwlOtfgQ9jj/rbD6IXvFMjckirvKiM8OTYhPT
         OhV7JWJ0lmC/nuNdvosxOqQizxr3Ao8IyrEdgf0huBgXuFSQnAosKyDxyKywWkSQ5zoU
         9+cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=73ciu6eFOPHbqo4MJgjXh4/QYZ5M67T1wK+DASmK9NE=;
        b=kM5KdphT4MPCiqte/738ASO9A91mXJDc0PAvWUIjlluvCaWjjH/RqXE3oqmKTbZiA+
         ULmbS+Bu+84HhqscrSNXRyqydwoty2vQENfs04qCF1Ve1aEQi3dUgMTIKbxvsbwOxDqC
         haLA8jDsHQVC+DP0+3f65i08IbFL/CmhzneUPxRHxBpo7nFux1AbqxgVZVzueG9ROliU
         tawTRwNUDKIUGw1WW1Z32/rcwGp6MyLEwHtgXfJTGmAZqCMH3aiMz705AZrijd3O3Fv3
         msJ0RlHUi6zQs/bsstbpJLwMHlqAqxjXpUeXpUF2R5TY9EUHzxiy/1LwIrYnxVYHF3Fn
         QPlw==
X-Gm-Message-State: AOAM5315L/evkKLAqTIFVIs28rtSNtzLdPKrACgs1cg4FZXt4aUwW2cE
        uRqTGtwoK8KRZhP5W7gApWUZKvOkEFbJL9/8sJc=
X-Google-Smtp-Source: ABdhPJwKrQ51Nwha2VtS4aMgCuEL82xY1akX4Z4zmNsNYZEiQfggxfFJ1qUfY7Cel/HEuFVth6zzOw==
X-Received: by 2002:a17:906:7253:: with SMTP id n19mr2896364ejk.543.1611653738662;
        Tue, 26 Jan 2021 01:35:38 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id u2sm9512360ejb.65.2021.01.26.01.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 01:35:38 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next v2 0/2] net: bridge: multicast: per-port EHT hosts limit
Date:   Tue, 26 Jan 2021 11:35:31 +0200
Message-Id: <20210126093533.441338-1-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
This set adds a simple configurable per-port EHT tracked hosts limit.
Patch 01 adds a default limit of 512 tracked hosts per-port, since the EHT
changes are still only in net-next that shouldn't be a problem. Then
patch 02 adds the ability to configure and retrieve the hosts limit
and to retrieve the current number of tracked hosts per port.
Let's be on the safe side and limit the number of tracked hosts by
default while allowing the user to increase that limit if needed.

v2: patch 2: move br_multicast_eht_set_hosts_limit() to br_multicast_eht.c,
             no functional change

Thanks,
 Nik

Nikolay Aleksandrov (2):
  net: bridge: multicast: add per-port EHT hosts limit
  net: bridge: multicast: make tracked EHT hosts limit configurable

 include/uapi/linux/if_link.h      |  2 ++
 net/bridge/br_multicast.c         |  1 +
 net/bridge/br_multicast_eht.c     | 22 ++++++++++++++++++++++
 net/bridge/br_netlink.c           | 19 ++++++++++++++++++-
 net/bridge/br_private.h           |  2 ++
 net/bridge/br_private_mcast_eht.h | 28 ++++++++++++++++++++++++++++
 net/bridge/br_sysfs_if.c          | 26 ++++++++++++++++++++++++++
 net/core/rtnetlink.c              |  2 +-
 8 files changed, 100 insertions(+), 2 deletions(-)

-- 
2.29.2

