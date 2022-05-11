Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F316B52339F
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 15:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242976AbiEKNEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 09:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237566AbiEKNEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 09:04:13 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17902232773;
        Wed, 11 May 2022 06:04:11 -0700 (PDT)
Received: from kwepemi100018.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Kyw810DN5zhZ2K;
        Wed, 11 May 2022 21:03:29 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 kwepemi100018.china.huawei.com (7.221.188.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 11 May 2022 21:04:08 +0800
Received: from huawei.com (10.175.113.133) by kwepemm600001.china.huawei.com
 (7.193.23.3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 11 May
 2022 21:04:07 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <trond.myklebust@hammerspace.com>, <bfields@fieldses.org>,
        <anna@kernel.org>, <chuck.lever@oracle.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wanghai38@huawei.com>
Subject: [PATCH 0/3] Refix the socket leak in xs_setup_local()
Date:   Wed, 11 May 2022 21:22:29 +0800
Message-ID: <20220511132232.4030-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch1 and patch2 roll back the wrong solution to fix socket leaks.

Patch3 adds safe teardown mechanism to re-fix socket leaks.

Wang Hai (3):
  Revert "SUNRPC: Ensure gss-proxy connects on setup"
  Revert "Revert "SUNRPC: attempt AF_LOCAL connect on setup""
  SUNRPC: Fix local socket leak in xs_setup_local()

 include/linux/sunrpc/clnt.h          |  1 -
 net/sunrpc/auth_gss/gss_rpc_upcall.c |  2 +-
 net/sunrpc/clnt.c                    |  3 ---
 net/sunrpc/xprtsock.c                | 19 ++++++++++++++++++-
 4 files changed, 19 insertions(+), 6 deletions(-)

-- 
2.17.1

