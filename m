Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1815039E220
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbhFGQPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:15:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231704AbhFGQOr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AAE561246;
        Mon,  7 Jun 2021 16:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082375;
        bh=AsN4evvrBe7Rx1ndBTLCA/QWPG7HrdqRBqmP3/aBpR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WVvMxMPytJzXERXOlMbBJAZzn5VAnIF81sA2ftxEdYAv0rNaYntiwvAuQNEfgA9kl
         RezWVQej5kFnW9TxEWUAiujyI2P2W1KR48cZkMoTEQopmEyTi0xCfqsuHi0+DaGYEJ
         BzIYuji9IvsJGTAtZdqxFgkA+VpigTi4IhBm8JiAl0PdT2t73ooNc1+D0EzX+5bNSf
         MJtLccb5ZqYwOppO7j3VB9QfCRR4CijQtYhbob67QPhWTXHeMuk/HNb5AJQam5YB9h
         QkiWsRpG0w51tuc7GHs6+/UzzjcW9Fl+3qBMkODTxKt1ZDOfx1TPH/ljaRM14u/RTD
         lQrRhQ9cXSVPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 32/49] ethernet: myri10ge: Fix missing error code in myri10ge_probe()
Date:   Mon,  7 Jun 2021 12:11:58 -0400
Message-Id: <20210607161215.3583176-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
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
index c84c8bf2bc20..fc99ad8e4a38 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -3815,6 +3815,7 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_err(&pdev->dev,
 			"invalid sram_size %dB or board span %ldB\n",
 			mgp->sram_size, mgp->board_span);
+		status = -EINVAL;
 		goto abort_with_ioremap;
 	}
 	memcpy_fromio(mgp->eeprom_strings,
-- 
2.30.2

