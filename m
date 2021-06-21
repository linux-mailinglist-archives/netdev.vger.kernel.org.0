Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D6D3AF374
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbhFUSBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:01:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232667AbhFUR72 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:59:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72D4E61363;
        Mon, 21 Jun 2021 17:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298057;
        bh=T/2KSSokNB8laSgN8M1SC90KRYn39oD9wPyVHRggRS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tFUx/bIqVMcngi4DU2euvBVMUbYV4STTVCskSk1sKGNepfenKaAUbKIg1NdNoxMUO
         vvTRKlHSnHXFssd7IgT7wMkYuBb2cbQDk/69CtdWSCRFYrcjfLvGISt7tOx28uwwnY
         jR3fADpi+3y29OcWu9II/XOahmhaUg4AagzOkAecywPH0UfnqaWi3cxCamJ9DK7n/Q
         KM1N3wdXHq/sONKBfbUyPsQ8M2PmHq2vLWYQ3IdlS1bZh4o1hSeI4kmwmqwsJw4lMJ
         MBpvLzC957DsMZGE51DtVYLMc9gjm42xbjsizPCJC0EFAQ0CcVIizufBL1dhxNv4xC
         u5dm2jeZezQHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/26] net: ipv4: Remove unneed BUG() function
Date:   Mon, 21 Jun 2021 13:53:42 -0400
Message-Id: <20210621175400.735800-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175400.735800-1-sashal@kernel.org>
References: <20210621175400.735800-1-sashal@kernel.org>
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
index a27d034c85cc..603a3495afa6 100644
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
index 52feab2baeee..366c3792b860 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5761,7 +5761,7 @@ static int inet6_set_link_af(struct net_device *dev, const struct nlattr *nla)
 		return -EAFNOSUPPORT;
 
 	if (nla_parse_nested_deprecated(tb, IFLA_INET6_MAX, nla, NULL, NULL) < 0)
-		BUG();
+		return -EINVAL;
 
 	if (tb[IFLA_INET6_TOKEN]) {
 		err = inet6_set_iftoken(idev, nla_data(tb[IFLA_INET6_TOKEN]));
-- 
2.30.2

