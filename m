Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2215C5762D
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbfF0Afn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:35:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728279AbfF0AfX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:35:23 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17B2A217F9;
        Thu, 27 Jun 2019 00:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595722;
        bh=g5ONFjRf9THI8f6AlcdxfoRRB6Ticf5wHSm5ZKcwvuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPUbzcmnmVAAUYKPdWOhFyIrN9d5BXamDyRU7iU4jzId/CgxQxOMpzja2AXeNp0fd
         84tPbfcb+G0r27T+UIgnIk6L96aJm2jTN7pyp73yuvQJBLpy50ApttSzgZLbZshJz0
         KKNpVvqJY+1SxWrf67kj7Kiyf8vvZXx2cpbvfZ7g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 92/95] net: dsa: mv88e6xxx: fix shift of FID bits in mv88e6185_g1_vtu_loadpurge()
Date:   Wed, 26 Jun 2019 20:30:17 -0400
Message-Id: <20190627003021.19867-92-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

[ Upstream commit 48620e341659f6e4b978ec229f6944dabe6df709 ]

The comment is correct, but the code ends up moving the bits four
places too far, into the VTUOp field.

Fixes: 11ea809f1a74 (net: dsa: mv88e6xxx: support 256 databases)
Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/global1_vtu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global1_vtu.c b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
index 058326924f3e..7a6667e0b9f9 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_vtu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
@@ -419,7 +419,7 @@ int mv88e6185_g1_vtu_loadpurge(struct mv88e6xxx_chip *chip,
 		 * VTU DBNum[7:4] are located in VTU Operation 11:8
 		 */
 		op |= entry->fid & 0x000f;
-		op |= (entry->fid & 0x00f0) << 8;
+		op |= (entry->fid & 0x00f0) << 4;
 	}
 
 	return mv88e6xxx_g1_vtu_op(chip, op);
-- 
2.20.1

