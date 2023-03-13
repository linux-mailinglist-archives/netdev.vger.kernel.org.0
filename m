Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7ECC6B7D67
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjCMQ0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjCMQ0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:26:11 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0421F360AB;
        Mon, 13 Mar 2023 09:26:10 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id j19-20020a05600c191300b003eb3e1eb0caso11339642wmq.1;
        Mon, 13 Mar 2023 09:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678724768;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PTS3TvsaI19NjFQi3zg5TWV9y2d9pm99dtScZ0oVUQo=;
        b=MuzLAXw50lYgGq40JnV3ctiw64T+L0DmnFMGIUr74EXpJ1c1Cf92k88ATt63trzuD4
         3Ts1bfT5aOCpk2r5lG9G55Nz96/L82e8oeWcRvgxxN8fcC8Z8X3fulaDW0wt/aF2nivK
         89mWOw2EWXhZ4s6Vb4bECSLNN3Y9RaY8qYGFtmet92jDu5uU6Lkdm0ozclknqq6jJsj1
         dbQ2EJgrmk81ru5lKHHG3L/9yXCQpaKq9QlREw6gCH1ILdqSvm7j+/Zdz0gZou0R606G
         r1Q81R2Jk6b64LP6Z4wAPdqtsw6soJ4qdT4GFWLMWnXxPMfornvexuQDSla2ptsk16wb
         EIkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678724768;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PTS3TvsaI19NjFQi3zg5TWV9y2d9pm99dtScZ0oVUQo=;
        b=x415K3jtkhazseO4ecpOtI30qatxvkXasc+IFK+hwvg+tu0V3PDj6f54vZ5PD3xwc2
         Ooj8WJGpccmY+IoEC66Y32l4c3BuVfOWteJnv+qiPKRZwDKc/GIkgH71GnkIYcIDIPV4
         e8kiSkJsvLwlUkLCaEJe2ldDvauF7TPxUzSDJEzLhxkEEiWzspHZqHpZTbxaSpO3ZSxE
         VZH/n7rBffjsY77VELQRc1Z/a4JROlq/Srcz4v6jLuZYZQEapNNCU62x0XKluG8Zq8Wl
         lFqNiu4zLQcYpqiW1yghVRfsXh6j1Xx+SfL6wFQpMJrmPJKg9+7/Qpv2/Dx2o/ASkaFt
         VUQQ==
X-Gm-Message-State: AO0yUKUEmDmRkr9OhfWnn72BSBU2ojskFXGT8Nx2/lKJ30KZfVVXJGfv
        etJ5Y0foWzPNI5SXscvBDV0=
X-Google-Smtp-Source: AK7set8wDucz4hPvGRBd6pLsS8FtDu1eAKAN6WORwSdEAt/PlxgAMfgosxlY/7X6SbGrmESuVNo6rQ==
X-Received: by 2002:a05:600c:19cf:b0:3eb:3cc9:9f85 with SMTP id u15-20020a05600c19cf00b003eb3cc99f85mr12199068wmq.26.1678724768377;
        Mon, 13 Mar 2023 09:26:08 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id ja9-20020a05600c556900b003ed29f4e45esm282700wmb.0.2023.03.13.09.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 09:26:08 -0700 (PDT)
Date:   Mon, 13 Mar 2023 17:25:34 +0100
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, alexanderduyck@fb.com,
        richardbgobert@gmail.com, lucien.xin@gmail.com,
        lixiaoyan@google.com, iwienand@redhat.com, leon@kernel.org,
        ye.xingchen@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] gro: optimise redundant parsing of packets
Message-ID: <20230313162520.GA17199@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the IPv6 extension headers are parsed twice: first in
ipv6_gro_receive, and then again in ipv6_gro_complete.

By using the new ->transport_proto and ->network_proto fields, and also
storing the size of the network header, we can avoid parsing a second time
during the gro complete phase.

The first commit frees up space in the GRO CB. The second commit reduces
the redundant parsing during the complete phase, using the freed CB space.

In addition, the second commit contains a fix for a potential future
problem in BIG TCP, which is detailed in the commit message itself.

Performance tests for TCP stream over IPv6 with extension headers
demonstrate rx improvement of ~0.7%.

For the benchmarks, I used 100Gbit NIC mlx5 single-core (power management
off), turboboost off.

Typical IPv6 traffic (zero extension headers):

    for i in {1..5}; do netperf -t TCP_STREAM -H 2001:db8:2:2::2 -l 90 | tail -1; done
    # before
    131072  16384  16384    90.00    16391.20
    131072  16384  16384    90.00    16403.50
    131072  16384  16384    90.00    16403.30
    131072  16384  16384    90.00    16397.84
    131072  16384  16384    90.00    16398.00

    # after
    131072  16384  16384    90.00    16399.85
    131072  16384  16384    90.00    16392.37
    131072  16384  16384    90.00    16403.06
    131072  16384  16384    90.00    16406.97
    131072  16384  16384    90.00    16406.09

IPv6 over IPv6 traffic:

    for i in {1..5}; do netperf -t TCP_STREAM -H 4001:db8:2:2::2 -l 90 | tail -1; done
    # before
    131072  16384  16384    90.00    14791.61
    131072  16384  16384    90.00    14791.66
    131072  16384  16384    90.00    14783.47
    131072  16384  16384    90.00    14810.17
    131072  16384  16384    90.00    14806.15

    # after
    131072  16384  16384    90.00    14793.49
    131072  16384  16384    90.00    14816.10
    131072  16384  16384    90.00    14818.41
    131072  16384  16384    90.00    14780.35
    131072  16384  16384    90.00    14800.48

IPv6 traffic with varying extension headers:

    for i in {1..5}; do netperf -t TCP_STREAM -H 2001:db8:2:2::2 -l 90 | tail -1; done
    # before
    131072  16384  16384    90.00    14812.37
    131072  16384  16384    90.00    14813.04
    131072  16384  16384    90.00    14802.54
    131072  16384  16384    90.00    14804.06
    131072  16384  16384    90.00    14819.08

    # after
    131072  16384  16384    90.00    14927.11
    131072  16384  16384    90.00    14910.45
    131072  16384  16384    90.00    14917.36
    131072  16384  16384    90.00    14916.53
    131072  16384  16384    90.00    14928.88

Richard Gobert (2):
  gro: decrease size of CB
  gro: optimise redundant parsing of packets

 include/net/gro.h      | 33 ++++++++++++++++++++++++---------
 net/core/gro.c         | 18 +++++++++++-------
 net/ethernet/eth.c     | 14 +++++++++++---
 net/ipv6/ip6_offload.c | 20 +++++++++++++++-----
 4 files changed, 61 insertions(+), 24 deletions(-)

-- 
2.36.1
