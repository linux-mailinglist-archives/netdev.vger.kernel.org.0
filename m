Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603DF6B9831
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 15:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbjCNOmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 10:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbjCNOmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 10:42:06 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D584483178;
        Tue, 14 Mar 2023 07:41:50 -0700 (PDT)
Received: from dggpemm500012.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Pbbmk061mzrT1w;
        Tue, 14 Mar 2023 22:40:54 +0800 (CST)
Received: from localhost.localdomain (10.175.124.27) by
 dggpemm500012.china.huawei.com (7.185.36.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 22:41:46 +0800
From:   gaoxingwang <gaoxingwang1@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>
CC:     <pabeni@redhat.com>, <shuah@kernel.org>, <liaichun@huawei.com>,
        <yanan@huawei.com>
Subject: ipv4:the same route is added repeatedly
Date:   Tue, 14 Mar 2023 22:41:59 +0800
Message-ID: <20230314144159.2354729-1-gaoxingwang1@huawei.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500012.china.huawei.com (7.185.36.89)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When i add default route in /etc/sysconfig/static-routes, and then restart network service, it appears to add two same default route:
[root@localhost ~]# ip r
default via 9.82.0.1 dev eth0 
default via 9.82.0.1 dev eth0 

The static-routes file contents are as follows:
any net 0.0.0.0 netmask 0.0.0.0 gw 110.1.62.1

This problem seems to be related to patch f96a3d7455(ipv4: Fix incorrect route flushing when source address is deleted). When I revert this patch, the problem gets fixed.
Is that a known issue?
