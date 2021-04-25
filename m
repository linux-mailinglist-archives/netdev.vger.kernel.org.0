Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39E936A811
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 17:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhDYPxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 11:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhDYPxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 11:53:04 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A2EC061574
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 08:52:24 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id 20so23673088pll.7
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 08:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RNOs0gippc48oI1ljVSqLonFCd5o2axGJZBKtTvPhSc=;
        b=bvDRD6V45T+aam+5saAJ+SuWVFHrBil11q/s2FR4D5/4KC+7XdTT9ycg0X2YAHX77x
         255DPBeqEZuFzM0uaLq3X/uudpcGTOpcag1WF1LE0KBjimAXli0Chwr+5SxiwJxXSWmk
         ifi7wN4XZIK0F8kuzbGk4n1chL7sp7ULLZ50Wgk6mPLwu1q9Q5br9lTOG+Tq4gPgGy+L
         O4WmOgbGYMUw0BY00uRQicDWPxcXLdXk/h3MEGSPiiuUv0LwJZAfmh9PI7nkBmxD8TMD
         z7odcj7Z3zUlSdgaqnDDy0s/eCkooLVLPB7FhlUqp6ucedOaQwOlEUfY1Coada/V+Qyn
         Tngw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RNOs0gippc48oI1ljVSqLonFCd5o2axGJZBKtTvPhSc=;
        b=QDdIF4Sj+cUnUhqgcdMgj3eCec6pJSR2hMT4ZCmeS3SMqys34xQ3Gvwb94rQ+O+hpy
         CXiV0+9nF4atdSVkU52hhiMknwPYTAdM1SFQIFjPKvXeD4OjqaYYppkkzx8jYI+V8o5E
         btpu7wNeI9lQrPDJT7J935oNgzYZEIHcm4VBQkccxL8XDG8GPGVCDFZp/OSqwVK7joNc
         wZrEZg/9Da6F6kapwpDNJ9ImmMkLFC15dK0TYS2Pt5Wr5ShqcqjhYdTyJWD7xM/LPJnd
         TypmwrmihZVA8PZ9xPEt8iodLQFC5mqiK5tNFGt5RHjEcpEtOg1D7pYJo2XUjtEl4qfl
         sOkw==
X-Gm-Message-State: AOAM533COb2XI/yWJ1oi30Q90x/nzgH6eDJD83pC7MDTQXmVlGwDEnXn
        +DPXp2uPyt6rZhsUrd5wriE=
X-Google-Smtp-Source: ABdhPJycM4ArsB2kx45wxdY2QQgAXkUWUUwvsnm+PDVxiSE12qHeRykpDsJa84bzrWXyhQAXHMnVoQ==
X-Received: by 2002:a17:903:310a:b029:ed:2b66:107d with SMTP id w10-20020a170903310ab02900ed2b66107dmr1043549plc.12.1619365944096;
        Sun, 25 Apr 2021 08:52:24 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id v21sm1563936pjg.9.2021.04.25.08.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 08:52:23 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        roopa@nvidia.com, nikolay@nvidia.com, ast@kernel.org,
        andriin@fb.com, daniel@iogearbox.net, weiwan@google.com,
        cong.wang@bytedance.com, bjorn@kernel.org,
        herbert@gondor.apana.org.au, bridge@lists.linux-foundation.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 0/2] Subject: [PATCH net 0/2] net: fix lockdep false positive splat
Date:   Sun, 25 Apr 2021 15:52:05 +0000
Message-Id: <20210425155207.29888-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to fix lockdep false positive splat in multicast part of
the bridge.

When mdb or multicast config is changed, it acquires multicast_lock,
which is a per-interface(bridge) lock.
So, spin_lock_nested() should be used instead of spin_lock() because
interfaces can be recursive.
The spin_lock_nested() needs 'subclass' parameter.

The first patch adds a new helper function, which returns the nest_level
variable under RCU. The nest_level variable can be used as 'subclass'
parameter of spin_lock_nested().
The second patch fix lockdep false positive splat in the bridge multicast
part by using netdev_get_nest_level_rcu().

Taehee Yoo (2):
  net: core: make bond_get_lowest_level_rcu() generic
  net: bridge: fix lockdep multicast_lock false positive splat

 drivers/net/bonding/bond_main.c |  45 +---------
 include/linux/netdevice.h       |   1 +
 net/bridge/br_mdb.c             |  12 +--
 net/bridge/br_multicast.c       | 146 ++++++++++++++++++++------------
 net/bridge/br_multicast_eht.c   |  18 ++--
 net/bridge/br_private.h         |  48 +++++++++++
 net/core/dev.c                  |  44 ++++++++++
 7 files changed, 204 insertions(+), 110 deletions(-)

-- 
2.17.1

