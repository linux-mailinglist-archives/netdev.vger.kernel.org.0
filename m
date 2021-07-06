Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4B13BD5C5
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240147AbhGFMYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:24:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236671AbhGFLff (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28B0161E0C;
        Tue,  6 Jul 2021 11:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570642;
        bh=qarjEZJNnjlvLPUP3ffhPcY4y2NFpZUcIFKS3921EC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hmhEMrEPHOv4BPOLsE9Y9YRQ8a6dhDhOr3PLeBcTH71aGZe74OewoiXpTRHigsjwJ
         LGaoR/jZMHTyea/N8Vw0BqcCBD+nM7EmWmceZvGeQ7Q2x4LqQKcUCZWMJyA4uI4qBa
         OoJPfxnB5eECLq/Ju18EwEdZ1xiTscIWJbFOayceWAzdmdROTGF1EGv/pDsUuepS6k
         /fRE+K1tLsYSRfBzjb00JmaYtD6Yrdwie94y9qmGY/+KzgYlRXn3P2SFBGqX3VBBmU
         pdf9ymR8iCawM1oGMBLKBCSHFHhMIv7jty1ghV+GptLDyLumJ+QErIs5s0NtT+drmd
         tn8ux2beIYhvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>, Alex Elder <elder@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 092/137] net: ipa: Add missing of_node_put() in ipa_firmware_load()
Date:   Tue,  6 Jul 2021 07:21:18 -0400
Message-Id: <20210706112203.2062605-92-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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
index cd4d993b0bbb..4162a608a3bf 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -589,6 +589,7 @@ static int ipa_firmware_load(struct device *dev)
 	}
 
 	ret = of_address_to_resource(node, 0, &res);
+	of_node_put(node);
 	if (ret) {
 		dev_err(dev, "error %d getting \"memory-region\" resource\n",
 			ret);
-- 
2.30.2

