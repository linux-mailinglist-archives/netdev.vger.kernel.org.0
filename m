Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500C93AF27A
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhFURyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:54:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231801AbhFURye (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:54:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39FA561245;
        Mon, 21 Jun 2021 17:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297939;
        bh=z8eva5ncGyArZ1Cou+EQgQVkiY6HiDJ2aUxVhQNwkss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZIe2o49WBdx7Ohu15WbGol+HwW8Dlt80cFfUZaDXU1HWz/ginanRNdAlvlORSSDv
         9WpF0G0yTEfkF8J29xjH9O85toUsBUL+tS37w7YrN6JgYVXHx7aieMBmuFJP5FPd+/
         hXWAYuh9Yz9j3Lb5rGjRzjx2iD9bozbHw1FpDF0OhY0gu+FVdTZ8TAwNGsJ2GlTo17
         p3+fZLHPF5ojq0yVxlcpqQKOKhaT+e+1fGUKt/9e4gIFZ/H68PxAZjsRducsTIMD1G
         KPzKa9s/aIlaw6+InseWMDbJ8g1Lry75Yu13yAZUhrfv+X4tlBc4BsrJDU70Bm1Z9Q
         RfQ8MS7rBxr6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 13/39] net: ipv4: Remove unneed BUG() function
Date:   Mon, 21 Jun 2021 13:51:29 -0400
Message-Id: <20210621175156.735062-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit 5ac6b198d7e312bd10ebe7d58c64690dc59cc49a ]

When 'nla_parse_nested_deprecated' failed, it's no need to
BUG() here, return -EINVAL is ok.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index a9e53f5942fa..eab0a46983c0 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5822,7 +5822,7 @@ static int inet6_set_link_af(struct net_device *dev, const struct nlattr *nla,
 		return -EAFNOSUPPORT;
 
 	if (nla_parse_nested_deprecated(tb, IFLA_INET6_MAX, nla, NULL, NULL) < 0)
-		BUG();
+		return -EINVAL;
 
 	if (tb[IFLA_INET6_TOKEN]) {
 		err = inet6_set_iftoken(idev, nla_data(tb[IFLA_INET6_TOKEN]),
-- 
2.30.2

