Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC72FEFE2
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731667AbfKPQBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:01:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728768AbfKPPxI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:53:08 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FB4920871;
        Sat, 16 Nov 2019 15:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919587;
        bh=eGI2FMmDfPDYoCg1ZCjAMD3yPyrwIpkZXMOAqPWr9GM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hK4ZViaSTS5zqoAUcfTkpmw3U0LpuMsnFJb5zuRkuQJRTX4r9S4Ebl4sppkEFu40c
         Je6vXiFHYudYOzCkGzwZUcAGxsKEcyIaK7bUTRVwuyWKMGSWeQmsLssa44MM8LhHNv
         rrFCe99jY+oS+MCaJhSv5gG+CrEZivEtJe7G7MWw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 78/99] wlcore: Fix the return value in case of error in 'wlcore_vendor_cmd_smart_config_start()'
Date:   Sat, 16 Nov 2019 10:50:41 -0500
Message-Id: <20191116155103.10971-78-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
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
index fd4e9ba176c9b..332a3a5c1c900 100644
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

