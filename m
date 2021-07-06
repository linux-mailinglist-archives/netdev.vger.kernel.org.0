Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14843BD031
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbhGFLcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:32:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235218AbhGFL3q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:29:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB2E461D9B;
        Tue,  6 Jul 2021 11:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570445;
        bh=UcI2nQ0dRPY6zF58aNhzWINc4a8QNy6Vta0vXQPrW2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DXB/1lFgJ0VF5BN/VisDbtJtLee1woAdUDhzdK9NU8w06zVlpQF9sPbBbnjwzd0fW
         ozGZOrl5gvbRcwJSskmHvlgYgQoZacCSgj8e7jFTNLOYxYUK1JsRJtMS3EgyTbDaId
         2h5uJdqoSXO6PbPZZY8rducjEHSkxFPvuNnJ2gr+cOF4TdX9R+0a3N/EqBskLC8jDa
         KkTau5oJf3hT9j4GkfI1cn+lFrd61L+4nbiKLPyk5eUdacGvoGFO7uw7O/HIEeHjBR
         b3ScybNoiCDAx5RSK9iJdGMCteGSisb65gsgj2CRhLtJiG9IXmUWdW/QPCsiWJozbo
         xBVH07jQ8IQcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>, Alex Elder <elder@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 104/160] net: ipa: Add missing of_node_put() in ipa_firmware_load()
Date:   Tue,  6 Jul 2021 07:17:30 -0400
Message-Id: <20210706111827.2060499-104-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit b244163f2c45c12053cb0291c955f892e79ed8a9 ]

This node pointer is returned by of_parse_phandle() with refcount
incremented in this function. of_node_put() on it before exiting
this function.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 97c1b55405cb..ba27bcde901e 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -679,6 +679,7 @@ static int ipa_firmware_load(struct device *dev)
 	}
 
 	ret = of_address_to_resource(node, 0, &res);
+	of_node_put(node);
 	if (ret) {
 		dev_err(dev, "error %d getting \"memory-region\" resource\n",
 			ret);
-- 
2.30.2

