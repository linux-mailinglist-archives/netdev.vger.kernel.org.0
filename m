Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD35398B17
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 15:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhFBNyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 09:54:41 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2853 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhFBNyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 09:54:40 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fw9Ms1VjgzWq0R;
        Wed,  2 Jun 2021 21:48:09 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 21:52:51 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <ms@dev.tdt.de>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-x25@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net/x25: Return the correct errno code
Date:   Wed, 2 Jun 2021 22:06:30 +0800
Message-ID: <20210602140630.486073-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/x25/af_x25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 44d6566dd23e..1816899499ce 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -536,7 +536,7 @@ static int x25_create(struct net *net, struct socket *sock, int protocol,
 	if (protocol)
 		goto out;
 
-	rc = -ENOBUFS;
+	rc = -ENOMEM;
 	if ((sk = x25_alloc_socket(net, kern)) == NULL)
 		goto out;
 
-- 
2.25.1

