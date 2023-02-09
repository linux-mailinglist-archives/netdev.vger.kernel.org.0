Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7340B690AB1
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 14:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjBINnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 08:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjBINnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 08:43:05 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD49811142
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 05:42:38 -0800 (PST)
Received: from dggpemm500012.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PCJ0L72rKzJsLP;
        Thu,  9 Feb 2023 21:40:34 +0800 (CST)
Received: from localhost.localdomain (10.175.124.27) by
 dggpemm500012.china.huawei.com (7.185.36.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 9 Feb 2023 21:42:17 +0800
From:   gaoxingwang <gaoxingwang1@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <chenzhen126@huawei.com>,
        <liaichun@huawei.com>, <yanan@huawei.com>
Subject: ipv6:ping ipv6 address on the same host from the loopback
Date:   Thu, 9 Feb 2023 21:42:44 +0800
Message-ID: <20230209134244.3953539-1-gaoxingwang1@huawei.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500012.china.huawei.com (7.185.36.89)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When I ping another ipv6 address on the same host from the loopback interface, it fails.
Is this what was expected? Or should it work successfully like ipv4?

Reproduction:
root@test:~ # ifconfig ens8
ens8: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet6 2008::8  prefixlen 128  scopeid 0x0<global>
        ether 52:54:00:7e:c2:26  txqueuelen 1000  (Ethernet)
        RX packets 59118  bytes 4270977 (4.0 MiB)
        RX errors 0  dropped 8643  overruns 0  frame 0
        TX packets 31  bytes 1882 (1.8 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

root@test:~ # ping -c 3 -I ::1 2008::8
PING 2008::8(2008::8) from ::1 : 56 data bytes

--- 2008::8 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2049ms
