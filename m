Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB1C1CAAB8
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 14:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgEHMgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 08:36:20 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35350 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726638AbgEHMgU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 08:36:20 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 529352369CD510014E30;
        Fri,  8 May 2020 20:36:17 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Fri, 8 May 2020 20:36:07 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <trond.myklebust@hammerspace.com>, <anna.schumaker@netapp.com>,
        <bfields@fieldses.org>, <chuck.lever@oracle.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <chenzhou10@huawei.com>
Subject: [PATCH -next] sunrpc: use kmemdup_nul() in gssp_stringify()
Date:   Fri, 8 May 2020 20:40:00 +0800
Message-ID: <20200508124000.170708-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is more efficient to use kmemdup_nul() if the size is known exactly
.

According to doc:
"Note: Use kmemdup_nul() instead if the size is known exactly."

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 net/sunrpc/auth_gss/gss_rpc_upcall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/auth_gss/gss_rpc_upcall.c b/net/sunrpc/auth_gss/gss_rpc_upcall.c
index 0349f455a862..af9c7f43859c 100644
--- a/net/sunrpc/auth_gss/gss_rpc_upcall.c
+++ b/net/sunrpc/auth_gss/gss_rpc_upcall.c
@@ -223,7 +223,7 @@ static int gssp_alloc_receive_pages(struct gssx_arg_accept_sec_context *arg)
 
 static char *gssp_stringify(struct xdr_netobj *netobj)
 {
-	return kstrndup(netobj->data, netobj->len, GFP_KERNEL);
+	return kmemdup_nul(netobj->data, netobj->len, GFP_KERNEL);
 }
 
 static void gssp_hostbased_service(char **principal)
-- 
2.20.1

