Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074A46EC3BE
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 04:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjDXCnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 22:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDXCnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 22:43:47 -0400
Received: from hust.edu.cn (mail.hust.edu.cn [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A4F114;
        Sun, 23 Apr 2023 19:43:45 -0700 (PDT)
Received: from dd-virtual-machine.localdomain ([60.247.94.10])
        (user=u202110722@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 33O2fgfs005788-33O2fgft005788
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Mon, 24 Apr 2023 10:42:03 +0800
From:   Jianuo Kuang <u202110722@hust.edu.cn>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Thierry Escande <thierry.escande@collabora.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc:     hust-os-kernel-patches@googlegroups.com,
        Jianuo Kuang <u202110722@hust.edu.cn>,
        Dongliang Mu <dzm91@hust.edu.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: nfc: nfcsim: remove return value check of `dev_dir`
Date:   Mon, 24 Apr 2023 10:41:40 +0800
Message-Id: <20230424024140.34607-1-u202110722@hust.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: u202110722@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch complains that:
nfcsim_debugfs_init_dev() warn: 'dev_dir' is an error pointer or valid

According to the documentation of the debugfs_create_dir() function,
there is no need to check the return value of this function.
Just delete the dead code.

Fixes: f9ac6273e5b8 ("NFC: nfcsim: Add support for sysfs control entry")
Signed-off-by: Jianuo Kuang <u202110722@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
---
 drivers/nfc/nfcsim.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/nfc/nfcsim.c b/drivers/nfc/nfcsim.c
index 85bf8d586c70..44eeb17ae48d 100644
--- a/drivers/nfc/nfcsim.c
+++ b/drivers/nfc/nfcsim.c
@@ -367,11 +367,6 @@ static void nfcsim_debugfs_init_dev(struct nfcsim *dev)
 	}
 
 	dev_dir = debugfs_create_dir(devname, nfcsim_debugfs_root);
-	if (!dev_dir) {
-		NFCSIM_ERR(dev, "Could not create debugfs entries for nfc%d\n",
-			   idx);
-		return;
-	}
 
 	debugfs_create_u8("dropframe", 0664, dev_dir, &dev->dropframe);
 }
-- 
2.25.1

