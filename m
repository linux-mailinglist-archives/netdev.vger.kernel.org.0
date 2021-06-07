Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6663239D80C
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 10:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhFGI7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 04:59:48 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4495 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbhFGI7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 04:59:48 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fz6dR3hJ1zZcBH;
        Mon,  7 Jun 2021 16:55:07 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 7 Jun 2021 16:57:54 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: ipv4: use BUG_ON instead of if condition followed by BUG
Date:   Mon, 7 Jun 2021 17:11:31 +0800
Message-ID: <20210607091131.2766890-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use BUG_ON instead of if condition followed by BUG in inet_set_link_af.

This issue was detected with the help of Coccinelle.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/ipv4/devinet.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 2e35f68da40a..e3e1e8a600ef 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1988,8 +1988,7 @@ static int inet_set_link_af(struct net_device *dev, const struct nlattr *nla,
 	if (!in_dev)
 		return -EAFNOSUPPORT;
 
-	if (nla_parse_nested_deprecated(tb, IFLA_INET_MAX, nla, NULL, NULL) < 0)
-		BUG();
+	BUG_ON(nla_parse_nested_deprecated(tb, IFLA_INET_MAX, nla, NULL, NULL) < 0);
 
 	if (tb[IFLA_INET_CONF]) {
 		nla_for_each_nested(a, tb[IFLA_INET_CONF], rem)
-- 
2.25.1

