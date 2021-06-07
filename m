Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E188D39E28F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhFGQRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:17:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231975AbhFGQQM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:16:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 704E761453;
        Mon,  7 Jun 2021 16:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082427;
        bh=AsN4evvrBe7Rx1ndBTLCA/QWPG7HrdqRBqmP3/aBpR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCP59j3RmVMmtYfasA/bPVOr8DtN7GGzKtDDcyNbXWnk3DZn9d82u2EDsjI+Sf6bC
         SfqsUhLacKXuSQyEzmbqaZmbpHyhOZCTLv6yOQtenE2oG88BPfXJBXAuIGdStxsBVB
         J7DwkOiE0r4U7IEX/WgvZyIY35Yr1IScXmYs7AHtockBZxwFoyk56ZJsp4VxKmW1d7
         42KGXU5meqdRZQeWZZcHx38go9zXWDtPl0/ChVDEzKX7BbXTNnKKaCI5tDFGtP3YSG
         XdvoxcbwyqInJh7dj6HHfmMo3BK/R9YQ7oAfnBzLrC4L7D8NW3NhvQyzmVhDGqKOlV
         ZIB0a4jCm2kPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 22/39] ethernet: myri10ge: Fix missing error code in myri10ge_probe()
Date:   Mon,  7 Jun 2021 12:13:01 -0400
Message-Id: <20210607161318.3583636-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161318.3583636-1-sashal@kernel.org>
References: <20210607161318.3583636-1-sashal@kernel.org>
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

