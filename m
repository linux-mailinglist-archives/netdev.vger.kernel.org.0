Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A51969ED50
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 04:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbjBVDLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 22:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbjBVDLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 22:11:30 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B3C2CFCA;
        Tue, 21 Feb 2023 19:11:26 -0800 (PST)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PM1Pn040vzrSLb;
        Wed, 22 Feb 2023 11:10:52 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500015.china.huawei.com
 (7.221.188.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Wed, 22 Feb
 2023 11:11:23 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net,v3,0/2] Fix a fib6 info notification bug
Date:   Wed, 22 Feb 2023 12:20:49 +0800
Message-ID: <20230222042051.325307-1-luwei32@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set fixes a length calculation bug in fib6 info notification
and adds two testcases.

The test reult is listed as follows:

before the fix patch:

Fib6 info length calculation in route notify test
    TEST: ipv6 route add notify                      [FAIL]

Fib4 info length calculation in route notify test
    TEST: ipv4 route add notify                      [ OK ]

after the fix patch:

Fib6 info length calculation in route notify test
    TEST: ipv6 route add notify                      [ OK ]

Fib4 info length calculation in route notify test
    TEST: ipv4 route add notify                      [ OK ]

Lu Wei (2):
  ipv6: Add lwtunnel encap size of all siblings in nexthop calculation
  selftests: fib_tests: Add test cases for IPv4/IPv6 in route notify

 net/ipv6/route.c                         | 11 +--
 tools/testing/selftests/net/fib_tests.sh | 97 +++++++++++++++++++++++-
 2 files changed, 102 insertions(+), 6 deletions(-)

-- 
2.31.1

