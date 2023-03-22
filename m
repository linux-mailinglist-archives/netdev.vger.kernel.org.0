Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5866C3FAA
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 02:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjCVBWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 21:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjCVBWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 21:22:22 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F80EDBE0
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 18:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679448142; x=1710984142;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Yr7+/uOFp/o7h4pri7De2uyr4KZpfxmvAXOseEQ8OXA=;
  b=B1/0vma7wXypJzAfU6truaLT8RiWwwUj9w8ssGhjx0C+HM1qBYsJnWS3
   XLjPMLoSFLxMeulXkNVDJgau/U1NDWf6PkwoFkl9jQ7RmmQ4pSBQvzBMf
   fa72r3BWnXahQltBlwm9qWr/KG3f2NfPYXRVC74CGQ59C+jKBA2vvz2CJ
   M=;
X-IronPort-AV: E=Sophos;i="5.98,280,1673913600"; 
   d="scan'208";a="196009938"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-e7094f15.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 01:22:21 +0000
Received: from EX19MTAUWA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-e7094f15.us-west-2.amazon.com (Postfix) with ESMTPS id 4CF41415DA;
        Wed, 22 Mar 2023 01:22:21 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.22; Wed, 22 Mar 2023 01:22:19 +0000
Received: from 88665a182662.ant.amazon.com (10.94.217.231) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Wed, 22 Mar 2023 01:22:16 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 0/2] ipv6: Random cleanup for in6addr_any.
Date:   Tue, 21 Mar 2023 18:22:02 -0700
Message-ID: <20230322012204.33157-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.94.217.231]
X-ClientProxiedBy: EX19D041UWA002.ant.amazon.com (10.13.139.121) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch removes in6addr_any alternatives and the second
removes redundant initialisation of a local variable.


Kuniyuki Iwashima (2):
  ipv6: Remove in6addr_any alternatives.
  6lowpan: Remove redundant initialisation of struct in6_addr.

 .../net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c |  5 ++---
 include/net/ip6_fib.h                                 |  9 +++------
 include/trace/events/fib.h                            |  5 ++---
 include/trace/events/fib6.h                           |  5 +----
 net/6lowpan/iphc.c                                    |  2 +-
 net/ethtool/ioctl.c                                   |  9 ++++-----
 net/ipv4/inet_hashtables.c                            | 11 ++++-------
 7 files changed, 17 insertions(+), 29 deletions(-)

-- 
2.30.2

