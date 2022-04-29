Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CABE5149BE
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 14:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359448AbiD2Mtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 08:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359428AbiD2Mtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 08:49:40 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BEC3C97292;
        Fri, 29 Apr 2022 05:46:20 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app3 (Coremail) with SMTP id cC_KCgCnb3kJ3mtiQdNCAw--.63343S3;
        Fri, 29 Apr 2022 20:46:09 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     krzysztof.kozlowski@linaro.org, kuba@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, alexander.deucher@amd.com,
        broonie@kernel.org, linma@zju.edu.cn,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net v6 1/2] nfc: replace improper check device_is_registered() in netlink related functions
Date:   Fri, 29 Apr 2022 20:45:50 +0800
Message-Id: <13fc7da008ae0f18afed52059529142cfd640821.1651235400.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1651235400.git.duoming@zju.edu.cn>
References: <cover.1651235400.git.duoming@zju.edu.cn>
In-Reply-To: <cover.1651235400.git.duoming@zju.edu.cn>
References: <cover.1651235400.git.duoming@zju.edu.cn>
X-CM-TRANSID: cC_KCgCnb3kJ3mtiQdNCAw--.63343S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuF1fZr17Jw4fKF1kKr4Durg_yoWrtr4Upa
        4rKasakr4xWr1UWr4qqw4UCFy09r10qw4rury8GFy7KrZ3Xa4rtF1ftryxAa48t39xAayY
        qrWUJw48Wr4ruFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvG1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
        6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28I
        cxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJV
        W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
        1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
        IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
        x4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa
        73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgAPAVZdtZdzvwAGsv
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device_is_registered() in nfc core is used to check whether
nfc device is registered in netlink related functions such as
nfc_fw_download(), nfc_dev_up() and so on. Although device_is_registered()
is protected by device_lock, there is still a race condition between
device_del() and device_is_registered(). The root cause is that
kobject_del() in device_del() is not protected by device_lock.

   (cleanup task)         |     (netlink task)
                          |
nfc_unregister_device     | nfc_fw_download
 device_del               |  device_lock
  ...                     |   if (!device_is_registered)//(1)
  kobject_del//(2)        |   ...
 ...                      |  device_unlock

The device_is_registered() returns the value of state_in_sysfs and
the state_in_sysfs is set to zero in kobject_del(). If we pass check in
position (1), then set zero in position (2). As a result, the check
in position (1) is useless.

This patch uses bool variable instead of device_is_registered() to judge
whether the nfc device is registered, which is well synchronized.

Fixes: 3e256b8f8dfa ("NFC: add nfc subsystem core")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes in v6:
  - Replace dev_register flag in v5 to shutting_down flag.

 net/nfc/core.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/net/nfc/core.c b/net/nfc/core.c
index dc7a2404efd..5b286e1e0a6 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -38,7 +38,7 @@ int nfc_fw_download(struct nfc_dev *dev, const char *firmware_name)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -94,7 +94,7 @@ int nfc_dev_up(struct nfc_dev *dev)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -142,7 +142,7 @@ int nfc_dev_down(struct nfc_dev *dev)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -207,7 +207,7 @@ int nfc_start_poll(struct nfc_dev *dev, u32 im_protocols, u32 tm_protocols)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -246,7 +246,7 @@ int nfc_stop_poll(struct nfc_dev *dev)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -291,7 +291,7 @@ int nfc_dep_link_up(struct nfc_dev *dev, int target_index, u8 comm_mode)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -335,7 +335,7 @@ int nfc_dep_link_down(struct nfc_dev *dev)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -401,7 +401,7 @@ int nfc_activate_target(struct nfc_dev *dev, u32 target_idx, u32 protocol)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -448,7 +448,7 @@ int nfc_deactivate_target(struct nfc_dev *dev, u32 target_idx, u8 mode)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -495,7 +495,7 @@ int nfc_data_exchange(struct nfc_dev *dev, u32 target_idx, struct sk_buff *skb,
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		kfree_skb(skb);
 		goto error;
@@ -552,7 +552,7 @@ int nfc_enable_se(struct nfc_dev *dev, u32 se_idx)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -601,7 +601,7 @@ int nfc_disable_se(struct nfc_dev *dev, u32 se_idx)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -1134,6 +1134,7 @@ int nfc_register_device(struct nfc_dev *dev)
 			dev->rfkill = NULL;
 		}
 	}
+	dev->shutting_down = false;
 	device_unlock(&dev->dev);
 
 	rc = nfc_genl_device_added(dev);
@@ -1166,12 +1167,10 @@ void nfc_unregister_device(struct nfc_dev *dev)
 		rfkill_unregister(dev->rfkill);
 		rfkill_destroy(dev->rfkill);
 	}
+	dev->shutting_down = true;
 	device_unlock(&dev->dev);
 
 	if (dev->ops->check_presence) {
-		device_lock(&dev->dev);
-		dev->shutting_down = true;
-		device_unlock(&dev->dev);
 		del_timer_sync(&dev->check_pres_timer);
 		cancel_work_sync(&dev->check_pres_work);
 	}
-- 
2.17.1

