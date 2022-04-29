Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA035149BF
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 14:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359435AbiD2Mtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 08:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359432AbiD2Mtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 08:49:40 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 92D43972BA;
        Fri, 29 Apr 2022 05:46:21 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app3 (Coremail) with SMTP id cC_KCgCnb3kJ3mtiQdNCAw--.63343S4;
        Fri, 29 Apr 2022 20:46:11 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     krzysztof.kozlowski@linaro.org, kuba@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, alexander.deucher@amd.com,
        broonie@kernel.org, linma@zju.edu.cn,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net v6 2/2] nfc: nfcmrvl: main: reorder destructive operations in nfcmrvl_nci_unregister_dev to avoid bugs
Date:   Fri, 29 Apr 2022 20:45:51 +0800
Message-Id: <efe5eba16137a376e07e713d54cc7ec1eef92d9b.1651235400.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1651235400.git.duoming@zju.edu.cn>
References: <cover.1651235400.git.duoming@zju.edu.cn>
In-Reply-To: <cover.1651235400.git.duoming@zju.edu.cn>
References: <cover.1651235400.git.duoming@zju.edu.cn>
X-CM-TRANSID: cC_KCgCnb3kJ3mtiQdNCAw--.63343S4
X-Coremail-Antispam: 1UD129KBjvJXoWxAFW5Xw43WrWUAw17ZFy7Wrg_yoW5tF47pF
        4rGFy5AF1DKr4FgFWDtF4DAFyruws3CFW5CrW3GryfZrs8tFW8tr1qy3yUXrsrXr4UJayY
        g3W3A348WF4qyFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgAPAVZdtZdzvwAIsh
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are destructive operations such as nfcmrvl_fw_dnld_abort and
gpio_free in nfcmrvl_nci_unregister_dev. The resources such as firmware,
gpio and so on could be destructed while the upper layer functions such as
nfcmrvl_fw_dnld_start and nfcmrvl_nci_recv_frame is executing, which leads
to double-free, use-after-free and null-ptr-deref bugs.

There are three situations that could lead to double-free bugs.

The first situation is shown below:

   (Thread 1)                 |      (Thread 2)
nfcmrvl_fw_dnld_start         |
 ...                          |  nfcmrvl_nci_unregister_dev
 release_firmware()           |   nfcmrvl_fw_dnld_abort
  kfree(fw) //(1)             |    fw_dnld_over
                              |     release_firmware
  ...                         |      kfree(fw) //(2)
                              |     ...

The second situation is shown below:

   (Thread 1)                 |      (Thread 2)
nfcmrvl_fw_dnld_start         |
 ...                          |
 mod_timer                    |
 (wait a time)                |
 fw_dnld_timeout              |  nfcmrvl_nci_unregister_dev
   fw_dnld_over               |   nfcmrvl_fw_dnld_abort
    release_firmware          |    fw_dnld_over
     kfree(fw) //(1)          |     release_firmware
     ...                      |      kfree(fw) //(2)

The third situation is shown below:

       (Thread 1)               |       (Thread 2)
nfcmrvl_nci_recv_frame          |
 if(..->fw_download_in_progress)|
  nfcmrvl_fw_dnld_recv_frame    |
   queue_work                   |
                                |
fw_dnld_rx_work                 | nfcmrvl_nci_unregister_dev
 fw_dnld_over                   |  nfcmrvl_fw_dnld_abort
  release_firmware              |   fw_dnld_over
   kfree(fw) //(1)              |    release_firmware
                                |     kfree(fw) //(2)

The firmware struct is deallocated in position (1) and deallocated
in position (2) again.

The crash trace triggered by POC is like below:

BUG: KASAN: double-free or invalid-free in fw_dnld_over
Call Trace:
  kfree
  fw_dnld_over
  nfcmrvl_nci_unregister_dev
  nci_uart_tty_close
  tty_ldisc_kill
  tty_ldisc_hangup
  __tty_hangup.part.0
  tty_release
  ...

What's more, there are also use-after-free and null-ptr-deref bugs
in nfcmrvl_fw_dnld_start. If we deallocate firmware struct, gpio or
set null to the members of priv->fw_dnld in nfcmrvl_nci_unregister_dev,
then, we dereference firmware, gpio or the members of priv->fw_dnld in
nfcmrvl_fw_dnld_start, the UAF or NPD bugs will happen.

This patch reorders destructive operations after nci_unregister_device
in order to synchronize between cleanup routine and firmware download
routine.

The nci_unregister_device is well synchronized. If the device is
detaching, the firmware download routine will goto error. If firmware
download routine is executing, nci_unregister_device will wait until
firmware download routine is finished.

Fixes: 3194c6870158 ("NFC: nfcmrvl: add firmware download support")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes in v6:
  - Make commit messages more clearer.

 drivers/nfc/nfcmrvl/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcmrvl/main.c b/drivers/nfc/nfcmrvl/main.c
index 2fcf545012b..1a5284de434 100644
--- a/drivers/nfc/nfcmrvl/main.c
+++ b/drivers/nfc/nfcmrvl/main.c
@@ -183,6 +183,7 @@ void nfcmrvl_nci_unregister_dev(struct nfcmrvl_private *priv)
 {
 	struct nci_dev *ndev = priv->ndev;
 
+	nci_unregister_device(ndev);
 	if (priv->ndev->nfc_dev->fw_download_in_progress)
 		nfcmrvl_fw_dnld_abort(priv);
 
@@ -191,7 +192,6 @@ void nfcmrvl_nci_unregister_dev(struct nfcmrvl_private *priv)
 	if (gpio_is_valid(priv->config.reset_n_io))
 		gpio_free(priv->config.reset_n_io);
 
-	nci_unregister_device(ndev);
 	nci_free_device(ndev);
 	kfree(priv);
 }
-- 
2.17.1

