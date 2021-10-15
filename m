Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B6942FB67
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 20:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241493AbhJOSu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 14:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238011AbhJOSu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 14:50:58 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D99C061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 11:48:52 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id oa4so7831268pjb.2
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 11:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rjEFrhh/t2hOLhZwKmiy5Ypq4MphA14kdkQr4doTAT4=;
        b=HDfKTHrKcmGGfz9NFdMaOOsKj8ujx+M4MuKgGpmbvnqqg1oSmcgmRknrJADTJJ3qSO
         EdmOn4NTy3nbv2yBHSv0HUXgFIieJHVUVjU6fJhy1U/A2CeVKn3+G2Oa7mpx7tbitaOy
         2Q2NVf4miySqmdApjHbgBLE9mNdo6q5u+iGxeBwZ5LsSyTY7lr+Hg/xktV0zfQ+PIJh1
         7W5DGzN4grB8/lmIBGtd/mcwbgH2XiL6RWjYIGmpHfXRkNZde2or5LyqkanKPXTBmurM
         oo+f98NrWKUqalF2pp6HKvP1KcIAot+eslELtZmPUz07p6im7svi5fuxgKtDqP4uZyk6
         hmgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rjEFrhh/t2hOLhZwKmiy5Ypq4MphA14kdkQr4doTAT4=;
        b=MME4F2ZD3lKhSDda+oKTbsdqCz8IGq0Dz/4y//FgANpUtglle5ftuPDdI2ZMvwB+rX
         G8k/50EwCWJmbEGehqsgaavJ5Ojvs5ygxRny10R3fKivrkrFY1mS3EIVipJG39FIfz+K
         d6ZIxibiC467ujp+5P2YuAo5eEcRnY31pUjQu41mjGav3RIHafeUPfJFhaoG1UUof3mi
         PL76uvwMtmdmkYVMdsQ7reSeIjO0l0G//MiEkBUdklg2OzQspQbgSmLo/D9noNUC4BXt
         kN6ctM0mu7wUhiC74Ba5ezp4cxKCBXzQ6gyl3ZSHwJPxyI5ksM6onOEJrohvY5/01I+i
         7ugQ==
X-Gm-Message-State: AOAM533SotKJuov/tr6LbY2aDT+GHBzwJ7UdVLtoYkAo8RgIep1htSUH
        u6M26A8in4jTu9wSCmkrVPlIQLOKLhs2QA==
X-Google-Smtp-Source: ABdhPJzvMOO/gtEhS6MJ17Juu40Nef8I7c4d0Qh5m0PpD9uyetR4LQTNMZDypXkCDSJJsX4Mgs0L2Q==
X-Received: by 2002:a17:902:dacb:b0:13e:f6c3:57dd with SMTP id q11-20020a170902dacb00b0013ef6c357ddmr12348673plx.45.1634323731598;
        Fri, 15 Oct 2021 11:48:51 -0700 (PDT)
Received: from localhost.localdomain ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id bp19sm5431357pjb.46.2021.10.15.11.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 11:48:51 -0700 (PDT)
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
        Chinmay Agarwal <chinagar@codeaurora.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Tong Zhu <zhutong@amazon.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH v2 0/1] Make neighbor eviction controllable by userspace
Date:   Fri, 15 Oct 2021 11:43:20 -0700
Message-Id: <20211015184321.245408-1-prestwoj@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was suggested by Daniel Borkmann to extend the neighbor table settings
rather than adding IPv4/IPv6 options for ARP/NDISC separately. I agree
this way is much more concise since there is now only one place where the
option is checked and defined.

v1 -> v2
 - Moved documentation/code into the same patch
 - Explained in more detail the test scenario and results

James Prestwood (1):
  net: neighbour: introduce EVICT_NOCARRIER table option

 Documentation/networking/ip-sysctl.rst |  9 +++++++++
 include/net/neighbour.h                |  5 +++--
 include/uapi/linux/neighbour.h         |  1 +
 net/core/neighbour.c                   | 12 ++++++++++--
 net/ipv4/arp.c                         |  1 +
 net/ipv6/ndisc.c                       |  1 +
 6 files changed, 25 insertions(+), 4 deletions(-)

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
Cc: Chinmay Agarwal <chinagar@codeaurora.org>
Cc: Yajun Deng <yajun.deng@linux.dev>
Cc: Tong Zhu <zhutong@amazon.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni@codeaurora.org>

-- 
2.31.1

