Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22A96CB2AF
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 01:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbjC0XzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 19:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbjC0XzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 19:55:14 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AA11732
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 16:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679961315; x=1711497315;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+NgRxi6+D5Ng+66lWkfOCdyINcvcG1xdzeAPlBTud+k=;
  b=BsW0oco+GL4aFZIzmLKxQz7Obiz6xUZUZAtDRrFhBl8V7lM2dXSfW6dv
   awZo8uY8NGcQCrFeshnA6qHLSrjuTy6TSrrz4kMmZWpRedmQ1UdgOBgUZ
   XeFz19BNltsZY8mDwKdXPzufUi7f7TkViZkRYgwGBoQ9SYMiDJieHh2Da
   c=;
X-IronPort-AV: E=Sophos;i="5.98,295,1673913600"; 
   d="scan'208";a="198117263"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 23:55:12 +0000
Received: from EX19MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com (Postfix) with ESMTPS id 4C3CF80E31;
        Mon, 27 Mar 2023 23:55:09 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Mon, 27 Mar 2023 23:55:08 +0000
Received: from 88665a182662.ant.amazon.com (10.119.220.254) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 27 Mar 2023 23:55:05 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 0/2] ipv6: Random cleanup for in6addr_any.
Date:   Mon, 27 Mar 2023 16:54:53 -0700
Message-ID: <20230327235455.52990-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.119.220.254]
X-ClientProxiedBy: EX19D046UWA002.ant.amazon.com (10.13.139.39) To
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


Changes:
  v2: Use ipv6_addr_any() in patch 1. (David Ahern)

  v1: https://lore.kernel.org/netdev/20230322012204.33157-1-kuniyu@amazon.com/


Kuniyuki Iwashima (2):
  ipv6: Remove in6addr_any alternatives.
  6lowpan: Remove redundant initialisation.

 .../net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c |  5 ++---
 include/net/ip6_fib.h                                 |  9 +++------
 include/trace/events/fib.h                            |  5 ++---
 include/trace/events/fib6.h                           |  5 +----
 net/6lowpan/iphc.c                                    |  2 +-
 net/ethtool/ioctl.c                                   | 10 +++++-----
 net/ipv4/inet_hashtables.c                            | 11 ++++-------
 7 files changed, 18 insertions(+), 29 deletions(-)

-- 
2.30.2

