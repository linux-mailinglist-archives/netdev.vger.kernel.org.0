Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA0539E365
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbhFGQXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232273AbhFGQVc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:21:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0FFB61626;
        Mon,  7 Jun 2021 16:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082504;
        bh=Cw4UaKHcG/ggN9nNPKsrQpMa1gOSUyjhbRfKSlwnzcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OWSxH6W4N40W+YoK3IZVEuP3kGeBxr92IKuleUxSJdzDXLhOsXnoTZUz7bKlLwJPS
         rOI/OU+RPe++ND/eKKazIZORr81uavwAK2lblBDDVlVaDGTcjxb1FxTEXVwZyb2iW8
         A/Rdw9c6QjmYjGKMQVro1es4kHQG2L6szKiQX+3ehcAWf9FCuMS0k5m9MsHWvWEB0o
         00Xm/fh2joMdAOjgGJ+9VMI1aCrRQqOQEQ6vbLa8cBZpJ5h+D/rGMX5QiR5ER0ALKM
         toJhu1f61Ln9eJc/Y9eX7zeNz8IkHSIm92xnC4NYM4KKH97CXKrnQtNMLMVzQaxGA/
         XZrZbwNkdxCIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 12/21] ethernet: myri10ge: Fix missing error code in myri10ge_probe()
Date:   Mon,  7 Jun 2021 12:14:39 -0400
Message-Id: <20210607161448.3584332-12-sashal@kernel.org>
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
index 6789eed78ff7..3bc570c46f81 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -3853,6 +3853,7 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_err(&pdev->dev,
 			"invalid sram_size %dB or board span %ldB\n",
 			mgp->sram_size, mgp->board_span);
+		status = -EINVAL;
 		goto abort_with_ioremap;
 	}
 	memcpy_fromio(mgp->eeprom_strings,
-- 
2.30.2

