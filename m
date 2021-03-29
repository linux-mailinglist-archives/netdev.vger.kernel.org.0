Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D236034D1D9
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 15:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhC2NxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 09:53:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14186 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbhC2Nwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 09:52:36 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F8DTt0PTPzmbgJ;
        Mon, 29 Mar 2021 21:49:54 +0800 (CST)
Received: from huawei.com (10.175.103.91) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.498.0; Mon, 29 Mar 2021
 21:52:26 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>
Subject: [PATCH -next] netfilter: nftables: remove unnecessary spin_lock_init()
Date:   Mon, 29 Mar 2021 21:55:41 +0800
Message-ID: <20210329135541.3304940-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The spinlock nf_tables_destroy_list_lock is initialized statically.
It is unnecessary to initialize by spin_lock_init().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/netfilter/nf_tables_api.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fc2526b8bd55..24eeb027a888 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9193,7 +9193,6 @@ static int __init nf_tables_module_init(void)
 {
 	int err;
 
-	spin_lock_init(&nf_tables_destroy_list_lock);
 	err = register_pernet_subsys(&nf_tables_net_ops);
 	if (err < 0)
 		return err;
-- 
2.25.1

