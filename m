Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8084D6E8926
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 06:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbjDTEj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 00:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjDTEj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 00:39:58 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF49740D7;
        Wed, 19 Apr 2023 21:39:56 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Q24bQ3ZDczSt6F;
        Thu, 20 Apr 2023 12:35:46 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 12:39:53 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <kuniyu@amazon.com>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH 6.1 0/3] inet6: Backport complete patchset for inet6_destroy_sock() call modificatioin
Date:   Thu, 20 Apr 2023 12:39:46 +0800
Message-ID: <cover.1681954729.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

6.1 LTS has backported commit ca43ccf41224 ("dccp/tcp: Avoid negative
sk_forward_alloc by ipv6_pinfo.pktoptions.") and commit 62ec33b44e0f ("net:
Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues()."),
but these are incomplete. There are some patches that have not been
backported including key pre-patch commit b5fc29233d28 ("inet6: Remove
inet6_destroy_sock() in sk->sk_prot->destroy().").

Backport complete patchset for inet6_destroy_sock() call modificatioin.

Kuniyuki Iwashima (3):
  inet6: Remove inet6_destroy_sock() in sk->sk_prot->destroy().
  dccp: Call inet6_destroy_sock() via sk->sk_destruct().
  sctp: Call inet6_destroy_sock() via sk->sk_destruct().

 net/dccp/dccp.h      |  1 +
 net/dccp/ipv6.c      | 15 ++++++++-------
 net/dccp/proto.c     |  8 +++++++-
 net/ipv6/af_inet6.c  |  1 +
 net/ipv6/ping.c      |  6 ------
 net/ipv6/raw.c       |  2 --
 net/ipv6/tcp_ipv6.c  |  8 +-------
 net/ipv6/udp.c       |  2 --
 net/l2tp/l2tp_ip6.c  |  2 --
 net/mptcp/protocol.c |  7 -------
 net/sctp/socket.c    | 29 +++++++++++++++++++++--------
 11 files changed, 39 insertions(+), 42 deletions(-)

-- 
2.25.1

