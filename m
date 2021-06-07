Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AFC39E372
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbhFGQYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:24:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232369AbhFGQWB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:22:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C81F46191D;
        Mon,  7 Jun 2021 16:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082513;
        bh=IL/Vz4f4SrTgU1DV5ryAUiCb28bM+1h3wnNOHLKW1ZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YtkzHazOBvzAuonhs4yD/i5sHf/ktewLwzGJk0+vZiDiGVIpEhO5PPcFAWhHTxMSI
         cna/3x2MYKrpQcfnDvMUhRXVIHPZmCFhqo65POm71PneVLL0Sptnsc0fwVlTj7cqRZ
         DqrD/5v+9L6KJs/mwzZg1tzyX5fufx8igKw/8G6zsLVqdAPLblBZKNwknraLGsKv26
         vBUTf02HuYEsS1piPYsCCzhIpqIUaDxjAzym5XQr5nKPCBcYVtkQm4afuTLxrDMjkM
         GzZ1cOhMlqqZ5gCd+XGVrxA+LNIloGIm2HEC1zy41oiAS7lJiec3dinU+V/ekyS1V+
         8UaCAiUdTbU5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 19/21] net/x25: Return the correct errno code
Date:   Mon,  7 Jun 2021 12:14:46 -0400
Message-Id: <20210607161448.3584332-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161448.3584332-1-sashal@kernel.org>
References: <20210607161448.3584332-1-sashal@kernel.org>
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
index f43d037ea852..f87002792836 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -551,7 +551,7 @@ static int x25_create(struct net *net, struct socket *sock, int protocol,
 	if (protocol)
 		goto out;
 
-	rc = -ENOBUFS;
+	rc = -ENOMEM;
 	if ((sk = x25_alloc_socket(net, kern)) == NULL)
 		goto out;
 
-- 
2.30.2

