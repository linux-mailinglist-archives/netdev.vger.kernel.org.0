Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5866699E9
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 15:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241761AbjAMOR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 09:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbjAMOPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 09:15:22 -0500
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.214])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4907D5E0AB;
        Fri, 13 Jan 2023 06:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=xF0ls5Fi+t7xMM14q4
        HXHz7GOP+iE/4qyk2/iOPLNhE=; b=lD4nCcmgoA1/p/399zKEXQ77X++jXrL1w0
        L1PE011hyDddhSAKnz2SPaW4DkVMzYX3hv5Kxdd4a4yZLZVoMPfV75XpMu8Iy5UZ
        K1g6/SLFGYnId80dXoKGdmn4xp63UPJWZNvMT9JltvXVmwprb3kWs0WrYsVkge9z
        vYYCSIQbM=
Received: from localhost.localdomain (unknown [114.107.204.148])
        by zwqz-smtp-mta-g4-3 (Coremail) with SMTP id _____wCnAMbRZsFjEoX7AA--.30424S4;
        Fri, 13 Jan 2023 22:13:01 +0800 (CST)
From:   Lizhe <sensor1010@163.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, johannes.berg@intel.com,
        alexander@wetzel-home.de
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lizhe <sensor1010@163.com>
Subject: [PATCH v1] wireless/at76c50x-usb.c : Use devm_kmalloc replaces kmalloc
Date:   Fri, 13 Jan 2023 06:12:31 -0800
Message-Id: <20230113141231.71892-1-sensor1010@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: _____wCnAMbRZsFjEoX7AA--.30424S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrKw1fGF15XF4rWr1fuFyUZFb_yoWfZFc_CF
        4xWrn7JFWUJFs2gry7CrW7ZFySkF1xXF4xua13Kay3Xw12vrWUZrWkZF9xZFZrurWfAFy3
        Ar1DtFy5ZayvgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRWE_NPUUUUU==
X-Originating-IP: [114.107.204.148]
X-CM-SenderInfo: 5vhq20jurqiii6rwjhhfrp/1tbiKA-1q17WLz+AlgAAs3
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use devm_kmalloc replaces kmalloc

Signed-off-by: Lizhe <sensor1010@163.com>
---
 drivers/net/wireless/atmel/at76c50x-usb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
index 009bca34ece3..f486ddb83d46 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -2444,7 +2444,7 @@ static int at76_probe(struct usb_interface *interface,
 
 	udev = usb_get_dev(interface_to_usbdev(interface));
 
-	fwv = kmalloc(sizeof(*fwv), GFP_KERNEL);
+	fwv = devm_kmalloc(sizeof(*fwv), GFP_KERNEL);
 	if (!fwv) {
 		ret = -ENOMEM;
 		goto exit;
@@ -2535,7 +2535,6 @@ static int at76_probe(struct usb_interface *interface,
 		at76_delete_device(priv);
 
 exit:
-	kfree(fwv);
 	if (ret < 0)
 		usb_put_dev(udev);
 	return ret;
-- 
2.17.1

