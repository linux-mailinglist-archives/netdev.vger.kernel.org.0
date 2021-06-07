Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FE139E3C0
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbhFGQ1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:27:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:32772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233839AbhFGQYj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:24:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D1F36194F;
        Mon,  7 Jun 2021 16:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082558;
        bh=HwkUWxdB04+3z1cNU4FKIS3SuMuWux3wDGdui7mJktI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWwedStbzdI3eskJUKzeRIaHb/fer+bmO1FXNhFEHM2nqq8HAWnRRnhIpF7AtfPkY
         Rb6YV35WnQBQjzsG8LSkKjSEmfwSWmb0GSZuztvvpw5ktpBYnQbVA/qJIMHy9ff2lS
         JjKB85Tj+O8KZQueTvfYZ89SOHC1ym/L+M1ALh+e/Ksw/IZciBhIXEEbdgFoA8Klrw
         T1tklgPr8x0vf75scTNp7S7Vq1LioUv4lYs3s0hUXVCAnchaWdm6PqfY4a3ia7+8Hy
         eiFoZB8lskT6U2epmdULT88AHgjZCTN60Xt+sJG4rDExaVJg8pEEfrb5df2KEbjCVm
         VktUi7UARkJDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/15] ethernet: myri10ge: Fix missing error code in myri10ge_probe()
Date:   Mon,  7 Jun 2021 12:15:38 -0400
Message-Id: <20210607161543.3584778-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161543.3584778-1-sashal@kernel.org>
References: <20210607161543.3584778-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit f336d0b93ae978f12c5e27199f828da89b91e56a ]

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'status'.

Eliminate the follow smatch warning:

drivers/net/ethernet/myricom/myri10ge/myri10ge.c:3818 myri10ge_probe()
warn: missing error code 'status'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 02ec326cb129..5eeba263b5f8 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -4050,6 +4050,7 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_err(&pdev->dev,
 			"invalid sram_size %dB or board span %ldB\n",
 			mgp->sram_size, mgp->board_span);
+		status = -EINVAL;
 		goto abort_with_ioremap;
 	}
 	memcpy_fromio(mgp->eeprom_strings,
-- 
2.30.2

