Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E736698ED
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 14:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241010AbjAMNoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 08:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240277AbjAMNmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 08:42:40 -0500
Received: from m12.mail.163.com (m12.mail.163.com [123.126.96.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0714F249;
        Fri, 13 Jan 2023 05:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=5R8MW5PsrFpUHW2/Qs
        o1Ea/UZDqrP1AU/pa+y91SHfc=; b=i34dA0h1bYou2dmJ0i8xL4wac/UEIJTh2c
        ZrR19AzAxyKn1dyPwzDxUEyxRltsoWTQ3FROg6F5klG+LYAXg6Te6ntK8IuWyAgy
        +pjS/OgbcKFwTelRZiI8PFZJ7shsndqYDeSUD2pBXfmcs8wcoz6DIlenHdNfjwd8
        TLT+SYQCc=
Received: from localhost.localdomain (unknown [114.107.204.148])
        by smtp20 (Coremail) with SMTP id H91pCgDnZMAKXsFj1Gk1AQ--.2429S4;
        Fri, 13 Jan 2023 21:35:46 +0800 (CST)
From:   Lizhe <sensor1010@163.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, johannes.berg@intel.com,
        alexander@wetzel-home.de
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lizhe <sensor1010@163.com>
Subject: [PATCH v1] wireless/at76c50x-usb.c : Use devm_kzalloc replaces kmalloc
Date:   Fri, 13 Jan 2023 05:35:03 -0800
Message-Id: <20230113133503.58336-1-sensor1010@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: H91pCgDnZMAKXsFj1Gk1AQ--.2429S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrWkXF4DCFWxJr43tw43Jrb_yoWfZFc_uF
        4Igrn7JFWUJFs2gry7Cr47ZFySkF1xXFn7uanxKay3uw12vrW8ZrZ5ZFyavFZrurWfAFy3
        Ar1DtFy5ZayvgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRXtxfUUUUUU==
X-Originating-IP: [114.107.204.148]
X-CM-SenderInfo: 5vhq20jurqiii6rwjhhfrp/1tbiSBT1q1+FgsklaAABsf
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use devm_kzalloc replaces kamlloc

Signed-off-by: Lizhe <sensor1010@163.com>
---
 drivers/net/wireless/atmel/at76c50x-usb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
index 009bca34ece3..ebd8ef525557 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -2444,7 +2444,7 @@ static int at76_probe(struct usb_interface *interface,
 
 	udev = usb_get_dev(interface_to_usbdev(interface));
 
-	fwv = kmalloc(sizeof(*fwv), GFP_KERNEL);
+	fwv = devm_kzalloc(sizeof(*fwv), GFP_KERNEL);
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

