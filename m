Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABBC93BCD40
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbhGFLVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232976AbhGFLTl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70CC861C96;
        Tue,  6 Jul 2021 11:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570217;
        bh=bEqreD9VTjWWjfTR+aT3nMLJCs0WPTRmFE93Xib2xwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFvGuom2oQJYhBv4XRECnFlh4IFGbKTY25Xv1H+xg5glOf2RuQLcyQENBkKJJqyVO
         Z8rSf+iRDRObP6CWGQ9Y++Z+nXQ7PzY94tPJP2tkNIoBWvlB1z1b8L6t1BxUv3o4j8
         j25kybF/vN7gEkevSb98KaTY3pqeEoUrTpV7sxBTfPbNnDvE121NISQmu1BniIgCiL
         to4gWHhQPC0l9unENgeMj6F00O0QbofaoR6Wv8FLxDSDJx4BogcNKZPK6uZxqNkVoq
         HicM3hkldVxujT/scCCku2EUIj8UBoj5qtjv6qbL16I/OLjuFG3ZYm6Y39Lo16FkXL
         XEjy2r6VUo7Mg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>, Alex Elder <elder@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 125/189] net: ipa: Add missing of_node_put() in ipa_firmware_load()
Date:   Tue,  6 Jul 2021 07:13:05 -0400
Message-Id: <20210706111409.2058071-125-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index 9915603ed10b..c4ad5f20496e 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -529,6 +529,7 @@ static int ipa_firmware_load(struct device *dev)
 	}
 
 	ret = of_address_to_resource(node, 0, &res);
+	of_node_put(node);
 	if (ret) {
 		dev_err(dev, "error %d getting \"memory-region\" resource\n",
 			ret);
-- 
2.30.2

