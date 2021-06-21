Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55CD23AF321
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbhFUR7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:59:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232889AbhFUR4M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:56:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 301AD6138C;
        Mon, 21 Jun 2021 17:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297998;
        bh=tWHLgKCSspw/p3ROZiuTVcoKpkDiADFWqlPIp8tLqAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c63P9XQl9hjcC8pU5LfLNyFVbYI8jn98aP3YPqc20dD5A8F+9wnOR+ZzTmRLXQB0u
         r+Vh7yzAaF4Rlz4M/L2/zDzyDN7Hday0TvYxpnCeYeuE2ScHQNX6Zim0JXGxs6IrqU
         MyVEmzYUf+FzTpUkt48uKvMRXSsMevM3yhbuQhVMYJLSKP9GLrHvqjB7QRAR2XFT7H
         9nXjgJDGthGMKqFcOZmXJgg3BYhdbrIVQn8C8w4agnFvfFIu6gqLShEqWYJwAomrV6
         0HnYZyaEc49YubxaVVDPn0gtuRgKZ3ABtZjLaMS51zFhOVA/49q5nvBNe/IJEEvMxM
         Jjsidrffdfxdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 12/35] net: ipv4: Remove unneed BUG() function
Date:   Mon, 21 Jun 2021 13:52:37 -0400
Message-Id: <20210621175300.735437-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175300.735437-1-sashal@kernel.org>
References: <20210621175300.735437-1-sashal@kernel.org>
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
index 123a6d39438f..7c1859777429 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1989,7 +1989,7 @@ static int inet_set_link_af(struct net_device *dev, const struct nlattr *nla)
 		return -EAFNOSUPPORT;
 
 	if (nla_parse_nested_deprecated(tb, IFLA_INET_MAX, nla, NULL, NULL) < 0)
-		BUG();
+		return -EINVAL;
 
 	if (tb[IFLA_INET_CONF]) {
 		nla_for_each_nested(a, tb[IFLA_INET_CONF], rem)
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 4c881f5d9080..884d430e23cb 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5799,7 +5799,7 @@ static int inet6_set_link_af(struct net_device *dev, const struct nlattr *nla)
 		return -EAFNOSUPPORT;
 
 	if (nla_parse_nested_deprecated(tb, IFLA_INET6_MAX, nla, NULL, NULL) < 0)
-		BUG();
+		return -EINVAL;
 
 	if (tb[IFLA_INET6_TOKEN]) {
 		err = inet6_set_iftoken(idev, nla_data(tb[IFLA_INET6_TOKEN]));
-- 
2.30.2

