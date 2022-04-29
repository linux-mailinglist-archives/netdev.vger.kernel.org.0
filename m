Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30969514020
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 03:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348514AbiD2BSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 21:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353809AbiD2BSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 21:18:22 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71547296;
        Thu, 28 Apr 2022 18:15:02 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app4 (Coremail) with SMTP id cS_KCgAnDkX6O2tidX4EAg--.28704S3;
        Fri, 29 Apr 2022 09:14:51 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org, kuba@kernel.org,
        krzysztof.kozlowski@linaro.org, gregkh@linuxfoundation.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        alexander.deucher@amd.com, akpm@linux-foundation.org,
        broonie@kernel.org, netdev@vger.kernel.org, linma@zju.edu.cn,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net v5 1/2] nfc: replace improper check device_is_registered() in netlink related functions
Date:   Fri, 29 Apr 2022 09:14:32 +0800
Message-Id: <33a282a82c18f942f1f5f9ee0ffcb16c2c7b0ece.1651194245.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1651194245.git.duoming@zju.edu.cn>
References: <cover.1651194245.git.duoming@zju.edu.cn>
In-Reply-To: <cover.1651194245.git.duoming@zju.edu.cn>
References: <cover.1651194245.git.duoming@zju.edu.cn>
X-CM-TRANSID: cS_KCgAnDkX6O2tidX4EAg--.28704S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuF1fZr17Jw4fKF1kKr4Durg_yoWrKFyUp3
        WrGas5tr4xWr4Uur4DXFWjga4j9r4xtw4rury0yry7KrZ3JFyrtr4ftFyxJay7t39xAF13
        XrWUJw48Wr4rZF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvm1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IY
        c2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
        z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
        UI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgIOAVZdtZdEXAA5sH
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
Changes in v5:
  - Replace device_is_registered() to bool variable.

 include/net/nfc/nfc.h |  1 +
 net/nfc/core.c        | 26 ++++++++++++++------------
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 5dee575fbe8..7bb4ccb1830 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -167,6 +167,7 @@ struct nfc_dev {
 	int n_targets;
 	int targets_generation;
 	struct device dev;
+	bool dev_register;
 	bool dev_up;
 	bool fw_download_in_progress;
 	u8 rf_mode;
diff --git a/net/nfc/core.c b/net/nfc/core.c
index dc7a2404efd..52147da2286 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -38,7 +38,7 @@ int nfc_fw_download(struct nfc_dev *dev, const char *firmware_name)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (!dev->dev_register) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -94,7 +94,7 @@ int nfc_dev_up(struct nfc_dev *dev)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (!dev->dev_register) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -142,7 +142,7 @@ int nfc_dev_down(struct nfc_dev *dev)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (!dev->dev_register) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -207,7 +207,7 @@ int nfc_start_poll(struct nfc_dev *dev, u32 im_protocols, u32 tm_protocols)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (!dev->dev_register) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -246,7 +246,7 @@ int nfc_stop_poll(struct nfc_dev *dev)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (!dev->dev_register) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -291,7 +291,7 @@ int nfc_dep_link_up(struct nfc_dev *dev, int target_index, u8 comm_mode)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (!dev->dev_register) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -335,7 +335,7 @@ int nfc_dep_link_down(struct nfc_dev *dev)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (!dev->dev_register) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -401,7 +401,7 @@ int nfc_activate_target(struct nfc_dev *dev, u32 target_idx, u32 protocol)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (!dev->dev_register) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -448,7 +448,7 @@ int nfc_deactivate_target(struct nfc_dev *dev, u32 target_idx, u8 mode)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (!dev->dev_register) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -495,7 +495,7 @@ int nfc_data_exchange(struct nfc_dev *dev, u32 target_idx, struct sk_buff *skb,
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (!dev->dev_register) {
 		rc = -ENODEV;
 		kfree_skb(skb);
 		goto error;
@@ -552,7 +552,7 @@ int nfc_enable_se(struct nfc_dev *dev, u32 se_idx)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (!dev->dev_register) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -601,7 +601,7 @@ int nfc_disable_se(struct nfc_dev *dev, u32 se_idx)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (!dev->dev_register) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -1134,6 +1134,7 @@ int nfc_register_device(struct nfc_dev *dev)
 			dev->rfkill = NULL;
 		}
 	}
+	dev->dev_register = true;
 	device_unlock(&dev->dev);
 
 	rc = nfc_genl_device_added(dev);
@@ -1166,6 +1167,7 @@ void nfc_unregister_device(struct nfc_dev *dev)
 		rfkill_unregister(dev->rfkill);
 		rfkill_destroy(dev->rfkill);
 	}
+	dev->dev_register = false;
 	device_unlock(&dev->dev);
 
 	if (dev->ops->check_presence) {
-- 
2.17.1

