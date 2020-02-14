Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFAA15E41F
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393371AbgBNQZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:25:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393368AbgBNQZL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:25:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DCCE247C8;
        Fri, 14 Feb 2020 16:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697511;
        bh=GOe/Q8d9pnM7OTay7ZXq8JIEleloYnDKCFv4IzHU8VM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e6BgdH6VgqjwmIiz+7XN1MckCsM9eZUOslKxHsGgp715ZTOBeR+t6CBzcFfFX9MN6
         8xNdsE3hF9LCV5WsYgPGq1CcZ2JvzxmIrKGZNt6Q5uWiLX94dE1hos2SsrPc2pFvT2
         dgb2e87R2eXp3DZ5iPUhWEUhrcyvzSuPbt+lmEyw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mao Wenan <maowenan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 037/100] NFC: port100: Convert cpu_to_le16(le16_to_cpu(E1) + E2) to use le16_add_cpu().
Date:   Fri, 14 Feb 2020 11:23:21 -0500
Message-Id: <20200214162425.21071-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162425.21071-1-sashal@kernel.org>
References: <20200214162425.21071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>

[ Upstream commit 718eae277e62a26e5862eb72a830b5e0fe37b04a ]

Convert cpu_to_le16(le16_to_cpu(frame->datalen) + len) to
use le16_add_cpu(), which is more concise and does the same thing.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Mao Wenan <maowenan@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/port100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index 87d5099967040..3ffbed72adf75 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -545,7 +545,7 @@ static void port100_tx_update_payload_len(void *_frame, int len)
 {
 	struct port100_frame *frame = _frame;
 
-	frame->datalen = cpu_to_le16(le16_to_cpu(frame->datalen) + len);
+	le16_add_cpu(&frame->datalen, len);
 }
 
 static bool port100_rx_frame_is_valid(void *_frame)
-- 
2.20.1

