Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1E34FF0C1
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730505AbfKPPuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:50:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730492AbfKPPuW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:50:22 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9172E20855;
        Sat, 16 Nov 2019 15:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919421;
        bh=w+q6BL0CoPHRaEY79kEP5MAZuqvdmh1WzmsnEEQrdhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FWF5ZH78viL2eZsjspaUY7vW9PcOte73p3xNF3+wKlU05I6ZSKfb+lZEhKXkQNlsa
         BI3KKmTgg4G30/CQ9NXqCji06jisLJBVH9Bs2RNB/yTd/1/EcK7TArnBUjEWolEqsq
         q8PGxa2YQGY8ZLh+AZDngHJBtLiUIabnZMINO/84=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 121/150] wlcore: Fix the return value in case of error in 'wlcore_vendor_cmd_smart_config_start()'
Date:   Sat, 16 Nov 2019 10:46:59 -0500
Message-Id: <20191116154729.9573-121-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 3419348a97bcc256238101129d69b600ceb5cc70 ]

We return 0 unconditionally at the end of
'wlcore_vendor_cmd_smart_config_start()'.
However, 'ret' is set to some error codes in several error handling paths
and we already return some error codes at the beginning of the function.

Return 'ret' instead to propagate the error code.

Fixes: 80ff8063e87c ("wlcore: handle smart config vendor commands")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wlcore/vendor_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/vendor_cmd.c b/drivers/net/wireless/ti/wlcore/vendor_cmd.c
index 5c0bcb1fe1a1f..e75c3cee0252f 100644
--- a/drivers/net/wireless/ti/wlcore/vendor_cmd.c
+++ b/drivers/net/wireless/ti/wlcore/vendor_cmd.c
@@ -66,7 +66,7 @@ wlcore_vendor_cmd_smart_config_start(struct wiphy *wiphy,
 out:
 	mutex_unlock(&wl->mutex);
 
-	return 0;
+	return ret;
 }
 
 static int
-- 
2.20.1

