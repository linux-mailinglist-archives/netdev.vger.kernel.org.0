Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3157839E3A7
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbhFGQ1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:27:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232943AbhFGQX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:23:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C471C61946;
        Mon,  7 Jun 2021 16:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082539;
        bh=+p6Ru1HAnt4vdsR80m3zPO30bLQzBT3Pqydpwqgfn60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQXazXEO6t1nKmljZL8u+ekzJbGG2VIK+ObhqHLS2zCpODkdQ5sEt4DKfMf8tPkuU
         7FDmmRMFOAsi8nv+aQHtOtADaNCoicg9G11JtLUzm1IJ9eA3YwgTkkgQCFZsEX+llh
         q3bUJf2Yidk0hqW227PcEGmyCyPQ91T7y7rGlWLl1QhR0wut8fx/5RPuPBlyMDLv56
         ntuDfl/laIThLIyYWLq1eRcXyPfUXIetZG154+VaQTu7RPSsuoQLiAkjsq3UEMDZ/1
         1lsHM7R4GjM7qyW+f8Z7sTWeA9Ac+/GlDK2zTM2PEILa/UNdPSE5+KR5vXALKguXWl
         3BqIXZkjdNdIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 16/18] net/x25: Return the correct errno code
Date:   Mon,  7 Jun 2021 12:15:14 -0400
Message-Id: <20210607161517.3584577-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161517.3584577-1-sashal@kernel.org>
References: <20210607161517.3584577-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit d7736958668c4facc15f421e622ffd718f5be80a ]

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/x25/af_x25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 987e5f8cafbe..fd0a6c6c77b6 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -550,7 +550,7 @@ static int x25_create(struct net *net, struct socket *sock, int protocol,
 	if (protocol)
 		goto out;
 
-	rc = -ENOBUFS;
+	rc = -ENOMEM;
 	if ((sk = x25_alloc_socket(net, kern)) == NULL)
 		goto out;
 
-- 
2.30.2

