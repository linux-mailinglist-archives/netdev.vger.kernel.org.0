Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2476C1C3F
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 17:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjCTQnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 12:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbjCTQmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 12:42:47 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3428305D5;
        Mon, 20 Mar 2023 09:37:27 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id v1so4880173wrv.1;
        Mon, 20 Mar 2023 09:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679330242;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3T7Tzzd5lEm/GxpA4sbeFnQPHPZLE6zIwUf9J7U30BA=;
        b=iI5gyvA5ini/SazLq9aqmvi2rvMJwgIQ8lP0jXia07MtAU/7pvNEzG4C7CpvJELwwe
         Gu2GhwjuQMdTt8vG6kgzstQ+FPzKo+9mk/9ZeN862gEsQDmmYMY0Dm+lcCgIg0e6ARK7
         LJl25jjS7Zyr3RkeVfIaIsAlQtobCF7dJxijxmM7MGSbSWx5MEzHTwTlVRcSj5Mu0EoB
         RMyjO14a2TwZ2iS75bOO29lbNEl+PsIuCxQGmZVqZGtuqf+9nZCnyW4HXNjTPT6nzbmv
         pLiK9r2CVTUgJwCjbpvMs05WgUNim8AIRRDasZsPQAew82I88hCiyx0eHn5WmMGQSsHU
         ZiJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679330242;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3T7Tzzd5lEm/GxpA4sbeFnQPHPZLE6zIwUf9J7U30BA=;
        b=CZMM/QQVXz3vjd05K3LlE7gzXfGwCaTcELWMgrKwwJdE51LtxeNdmsnN4+YxyZ3Utm
         ACSRD/Q2gCTVamnCMrXpaxvGDClOXSrXX9l74zTI5BfEG0s1j/ysf3hQPRj5Rep82Qo+
         dRs2QohDGL9JUJcDDkbm2xTcYr63uVdJKfHTGEgPbOdzfh49m1dRfUD/lKkU/xtVPxv0
         0/6XEUJOyl3W43QPz7Tp7kJLFItdO3Bs2n0Oo2cL/4a0Q3qphMHm1r577N68Lj9HjLR8
         90JV+7M6aiiLQInBnaMM4lLUHqLc14xDG+f4nY8XJWrgH6C1MB4DAAjqEjcDibviKGqL
         2svg==
X-Gm-Message-State: AO0yUKW3Rjc5MwpRozUBNrEb+RtUK8ASKi50fJGypuw2gSfiw8HvdB4n
        il/xkxKekH1zdYAa1qoNqEk=
X-Google-Smtp-Source: AK7set/IygVxReaGYDf2tQctk2ECgLUxu5l1ER58VsH9gaR2Tc3jQPLB+e1bp1vo3aLKRTVc/0bseg==
X-Received: by 2002:a5d:6544:0:b0:2d0:8e61:959c with SMTP id z4-20020a5d6544000000b002d08e61959cmr13139151wrv.20.1679330242580;
        Mon, 20 Mar 2023 09:37:22 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id q10-20020adff94a000000b002ca864b807csm9411334wrr.0.2023.03.20.09.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 09:37:22 -0700 (PDT)
Date:   Mon, 20 Mar 2023 17:37:07 +0100
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, alexanderduyck@fb.com,
        richardbgobert@gmail.com, lucien.xin@gmail.com,
        lixiaoyan@google.com, iwienand@redhat.com, leon@kernel.org,
        ye.xingchen@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] gro: optimise redundant parsing of packets
Message-ID: <20230320163703.GA27712@debian>
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
