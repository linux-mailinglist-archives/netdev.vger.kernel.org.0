Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B61839EB8C
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 03:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhFHBlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 21:41:36 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3458 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhFHBlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 21:41:35 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FzXs15D0wz6wry;
        Tue,  8 Jun 2021 09:36:37 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 09:39:39 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH v2] net: ipv4: Remove unneed BUG() function
Date:   Tue, 8 Jun 2021 09:53:15 +0800
Message-ID: <20210608015315.3091149-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When 'nla_parse_nested_deprecated' failed, it's no need to
BUG() here, return -EINVAL is ok.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/ipv4/devinet.c  | 2 +-
 net/ipv6/addrconf.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 2e35f68da40a..1c6429c353a9 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1989,7 +1989,7 @@ static int inet_set_link_af(struct net_device *dev, const struct nlattr *nla,
 		return -EAFNOSUPPORT;
 
 	if (nla_parse_nested_deprecated(tb, IFLA_INET_MAX, nla, NULL, NULL) < 0)
-		BUG();
+		return -EINVAL;
 
 	if (tb[IFLA_INET_CONF]) {
 		nla_for_each_nested(a, tb[IFLA_INET_CONF], rem)
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b0ef65eb9bd2..701eb82acd1c 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5827,7 +5827,7 @@ static int inet6_set_link_af(struct net_device *dev, const struct nlattr *nla,
 		return -EAFNOSUPPORT;
 
 	if (nla_parse_nested_deprecated(tb, IFLA_INET6_MAX, nla, NULL, NULL) < 0)
-		BUG();
+		return -EINVAL;
 
 	if (tb[IFLA_INET6_TOKEN]) {
 		err = inet6_set_iftoken(idev, nla_data(tb[IFLA_INET6_TOKEN]),
-- 
2.25.1

