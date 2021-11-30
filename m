Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3566463805
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 15:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243614AbhK3O5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 09:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242760AbhK3Ozj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:55:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B2FC0613F3;
        Tue, 30 Nov 2021 06:50:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EFEDB81A4C;
        Tue, 30 Nov 2021 14:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122F0C58331;
        Tue, 30 Nov 2021 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283811;
        bh=68lwD7AXrArorUZBnx8gko0iW4+ZgxoCm4b5khye80Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y459HPUYm6jc8kw0swKbvtkQq7ZFE/hCPKMQsaKt6yfnPHEXjO2kQBRVmsI/brg8O
         KIefQaKE2sm1JYsCU9bJmTbkw8jk4MfVz9GrkXD3u1rxZZIdramMqIuOU/HY3XjLVY
         wH280P0bw1t0qNMc6bJSYfaSQBQtUWKtWhs7a4i3Jks3NupEABOzGSoB9i8+D8TdmO
         KLgzPuGggOmnCUuyBHgKGU231ehZe4ocZPagUUwmp73XxsZKCQcq/KLMCHAilA6u54
         psoamHNl/7+toXor36xjqMRZp/V7vxZxJlNJMAkoJD+18/wSZOre7TYbUbswSjdtSv
         a/ZiR89zdS5Uw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 63/68] nfc: virtual_ncidev: change default device permissions
Date:   Tue, 30 Nov 2021 09:46:59 -0500
Message-Id: <20211130144707.944580-63-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

[ Upstream commit c26381f97e2a7df43826150dc7d4c207bd6794a5 ]

Device permissions is S_IALLUGO, with many unnecessary bits. Remove them
and also remove read and write permissions from group and others.

Before the change:
crwsrwsrwt    1 0        0          10, 125 Nov 25 13:59 /dev/virtual_nci

After the change:
crw-------    1 0        0          10, 125 Nov 25 14:05 /dev/virtual_nci

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Bongsu Jeon <bongsu.jeon@samsung.com>
Link: https://lore.kernel.org/r/20211125141457.716921-1-cascardo@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/virtual_ncidev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
index 221fa3bb8705e..f577449e49350 100644
--- a/drivers/nfc/virtual_ncidev.c
+++ b/drivers/nfc/virtual_ncidev.c
@@ -202,7 +202,7 @@ static int __init virtual_ncidev_init(void)
 	miscdev.minor = MISC_DYNAMIC_MINOR;
 	miscdev.name = "virtual_nci";
 	miscdev.fops = &virtual_ncidev_fops;
-	miscdev.mode = S_IALLUGO;
+	miscdev.mode = 0600;
 
 	return misc_register(&miscdev);
 }
-- 
2.33.0

