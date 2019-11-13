Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4EAFFA18C
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 02:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729933AbfKMB6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:58:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:51548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729877AbfKMB6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:58:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F1A32245A;
        Wed, 13 Nov 2019 01:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610282;
        bh=54L7zZCQNF70dbdU0EblUtAgWZSXmhYJn0NofEvp4Y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KvR2Zf/7pIUw8f0K2nAkxMkX3rcWZXjg18qK4sV4oseGnGQ0LC5yMBfAPm/sfO1Ue
         vIslvkOGgYb4ODmV/W7tjGNsou1HNXgKhjvZxhWYcqSYlnI1iiS+PDzsL8dzN07ZE7
         5ARuOEsHTLWZj/Y1q3dCOZUL9JDKeIYRR1b1Ll0k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 061/115] qtnfmac: pass sgi rate info flag to wireless core
Date:   Tue, 12 Nov 2019 20:55:28 -0500
Message-Id: <20191113015622.11592-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[ Upstream commit d5657b709e2a92a0e581109010765d1d485580df ]

SGI should be passed to wireless core as a part of rate structure.
Otherwise wireless core performs incorrect rate calculation when
SGI is enabled in hardware but not reported to host.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 4206886b110ce..ed087bbc6f631 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -485,6 +485,9 @@ qtnf_sta_info_parse_rate(struct rate_info *rate_dst,
 		rate_dst->flags |= RATE_INFO_FLAGS_MCS;
 	else if (rate_src->flags & QLINK_STA_INFO_RATE_FLAG_VHT_MCS)
 		rate_dst->flags |= RATE_INFO_FLAGS_VHT_MCS;
+
+	if (rate_src->flags & QLINK_STA_INFO_RATE_FLAG_SHORT_GI)
+		rate_dst->flags |= RATE_INFO_FLAGS_SHORT_GI;
 }
 
 static void
-- 
2.20.1

