Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437A645DC28
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 15:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355576AbhKYOUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 09:20:30 -0500
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:40614
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355620AbhKYOS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 09:18:29 -0500
Received: from mussarela.. (201-43-193-232.dsl.telesp.net.br [201.43.193.232])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 77D313F17A;
        Thu, 25 Nov 2021 14:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1637849717;
        bh=SiBGUulA79vrWybdRKVsxSyDIk0Q6E78nZydV62f0cE=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=dy0O+jf1DBlsrCx6W+oJ375J3mAY7xPnglB6g/5Uqb4VZj6fS7fwnv4EiKmk66DmO
         5LZmy+sJz5kA/r4KsEuptiXIqzHBZPaaFpdbIXOiShOvr4YqVZ3t4bGQiFd/PavQkl
         Eqogx8ZPvgpmyiM85WB+2kSlJn+hs9kohFET0R23TLsixNN5/NSOGHM6484r8BFNWc
         BbgU0V0U0L0ZASZBBo31BtYDwGAyiyaBnxD++Cp1HpK7ywHCwmcPjubs9/eGSxk20D
         p+Uyd7Uy+aqLjcMX3D/7OEKu8I4dUHSdoCMR0YRg71nXBY0AHS0aGDTtUnoqmmcN+7
         ZIZGuZZCwDJJw==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, krzysztof.kozlowski@canonical.com,
        bongsu.jeon@samsung.com
Subject: [PATCH] nfc: virtual_ncidev: change default device permissions
Date:   Thu, 25 Nov 2021 11:14:57 -0300
Message-Id: <20211125141457.716921-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Device permissions is S_IALLUGO, with many unnecessary bits. Remove them
and also remove read and write permissions from group and others.

Before the change:
crwsrwsrwt    1 0        0          10, 125 Nov 25 13:59 /dev/virtual_nci

After the change:
crw-------    1 0        0          10, 125 Nov 25 14:05 /dev/virtual_nci

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 drivers/nfc/virtual_ncidev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
index 221fa3bb8705..f577449e4935 100644
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
2.32.0

