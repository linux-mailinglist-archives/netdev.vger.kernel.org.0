Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E787D596EA1
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 14:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239502AbiHQMjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 08:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239261AbiHQMjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 08:39:47 -0400
Received: from zg8tmja5ljk3lje4ms43mwaa.icoremail.net (zg8tmja5ljk3lje4ms43mwaa.icoremail.net [209.97.181.73])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 3E31C28E39;
        Wed, 17 Aug 2022 05:39:42 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [106.117.76.235])
        by mail-app2 (Coremail) with SMTP id by_KCgBnbvZx4fxiKwT3Ag--.45860S3;
        Wed, 17 Aug 2022 20:39:25 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     briannorris@chromium.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, johannes@sipsolutions.net,
        gregkh@linuxfoundation.org, rafael@kernel.org,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH v7 1/2] devcoredump: remove the useless gfp_t parameter in dev_coredumpv and dev_coredumpm
Date:   Wed, 17 Aug 2022 20:39:12 +0800
Message-Id: <b861ce56ba555109a67f85a146a785a69f0a3c95.1660739276.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1660739276.git.duoming@zju.edu.cn>
References: <cover.1660739276.git.duoming@zju.edu.cn>
In-Reply-To: <cover.1660739276.git.duoming@zju.edu.cn>
References: <cover.1660739276.git.duoming@zju.edu.cn>
X-CM-TRANSID: by_KCgBnbvZx4fxiKwT3Ag--.45860S3
X-Coremail-Antispam: 1UD129KBjvAXoWfZr13XFy8GFy5Ar4rtw4DXFb_yoW8uFW8Jo
        WftrsxCa45Ar40yr93Gr1xCFy3XFnrJrnxAr45AFZ8WFZF9F1q9F15X3W3Z3ZYqw1rKw4f
        A342q3Z8Cr4Yk34fn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UjIYCTnIWjp_UUUOr7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20EY4v20xva
        j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r18M28IrcIa0x
        kI8VCY1x0267AKxVW8JVW5JwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84AC
        jcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr
        1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1l
        e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
        8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
        jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0x
        kIwI1lc2xSY4AK67AK6ryUMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4U
        MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67
        AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z2
        80aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI
        43ZEXa7VUUhF4tUUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgwFAVZdtbEgdgAdsO
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dev_coredumpv() and dev_coredumpm() could not be used in atomic
context, because they call kvasprintf_const() and kstrdup() with
GFP_KERNEL parameter. The process is shown below:

dev_coredumpv(.., gfp_t gfp)
  dev_coredumpm(.., gfp_t gfp)
    dev_set_name
      kobject_set_name_vargs
        kvasprintf_const(GFP_KERNEL, ...); //may sleep
          kstrdup(s, GFP_KERNEL); //may sleep

This patch removes gfp_t parameter of dev_coredumpv() and dev_coredumpm()
and changes the gfp_t parameter of kzalloc() in dev_coredumpm() to
GFP_KERNEL in order to show they could not be used in atomic context.

Fixes: 833c95456a70 ("device coredump: add new device coredump class")
Reviewed-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes in v7:
  - Remove gfp_t flag in amdgpu device.

 drivers/base/devcoredump.c                       | 16 ++++++----------
 drivers/bluetooth/btmrvl_sdio.c                  |  2 +-
 drivers/bluetooth/hci_qca.c                      |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c       |  2 +-
 drivers/gpu/drm/etnaviv/etnaviv_dump.c           |  2 +-
 drivers/gpu/drm/msm/disp/msm_disp_snapshot.c     |  4 ++--
 drivers/gpu/drm/msm/msm_gpu.c                    |  4 ++--
 drivers/media/platform/qcom/venus/core.c         |  2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c   |  2 +-
 drivers/net/wireless/ath/ath10k/coredump.c       |  2 +-
 .../net/wireless/ath/wil6210/wil_crash_dump.c    |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/debug.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c      |  6 ++----
 drivers/net/wireless/marvell/mwifiex/main.c      |  3 +--
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c  |  3 +--
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c  |  3 +--
 drivers/net/wireless/realtek/rtw88/main.c        |  2 +-
 drivers/net/wireless/realtek/rtw89/ser.c         |  2 +-
 drivers/remoteproc/qcom_q6v5_mss.c               |  2 +-
 drivers/remoteproc/remoteproc_coredump.c         |  8 ++++----
 include/drm/drm_print.h                          |  2 +-
 include/linux/devcoredump.h                      | 13 ++++++-------
 sound/soc/intel/avs/apl.c                        |  2 +-
 sound/soc/intel/avs/skl.c                        |  2 +-
 sound/soc/intel/catpt/dsp.c                      |  2 +-
 25 files changed, 41 insertions(+), 51 deletions(-)

diff --git a/drivers/base/devcoredump.c b/drivers/base/devcoredump.c
index f4d794d6bb8..8535f0bd5df 100644
--- a/drivers/base/devcoredump.c
+++ b/drivers/base/devcoredump.c
@@ -173,15 +173,13 @@ static void devcd_freev(void *data)
  * @dev: the struct device for the crashed device
  * @data: vmalloc data containing the device coredump
  * @datalen: length of the data
- * @gfp: allocation flags
  *
  * This function takes ownership of the vmalloc'ed data and will free
  * it when it is no longer used. See dev_coredumpm() for more information.
  */
-void dev_coredumpv(struct device *dev, void *data, size_t datalen,
-		   gfp_t gfp)
+void dev_coredumpv(struct device *dev, void *data, size_t datalen)
 {
-	dev_coredumpm(dev, NULL, data, datalen, gfp, devcd_readv, devcd_freev);
+	dev_coredumpm(dev, NULL, data, datalen, devcd_readv, devcd_freev);
 }
 EXPORT_SYMBOL_GPL(dev_coredumpv);
 
@@ -236,7 +234,6 @@ static ssize_t devcd_read_from_sgtable(char *buffer, loff_t offset,
  * @owner: the module that contains the read/free functions, use %THIS_MODULE
  * @data: data cookie for the @read/@free functions
  * @datalen: length of the data
- * @gfp: allocation flags
  * @read: function to read from the given buffer
  * @free: function to free the given buffer
  *
@@ -246,7 +243,7 @@ static ssize_t devcd_read_from_sgtable(char *buffer, loff_t offset,
  * function will be called to free the data.
  */
 void dev_coredumpm(struct device *dev, struct module *owner,
-		   void *data, size_t datalen, gfp_t gfp,
+		   void *data, size_t datalen,
 		   ssize_t (*read)(char *buffer, loff_t offset, size_t count,
 				   void *data, size_t datalen),
 		   void (*free)(void *data))
@@ -268,7 +265,7 @@ void dev_coredumpm(struct device *dev, struct module *owner,
 	if (!try_module_get(owner))
 		goto free;
 
-	devcd = kzalloc(sizeof(*devcd), gfp);
+	devcd = kzalloc(sizeof(*devcd), GFP_KERNEL);
 	if (!devcd)
 		goto put_module;
 
@@ -318,7 +315,6 @@ EXPORT_SYMBOL_GPL(dev_coredumpm);
  * @dev: the struct device for the crashed device
  * @table: the dump data
  * @datalen: length of the data
- * @gfp: allocation flags
  *
  * Creates a new device coredump for the given device. If a previous one hasn't
  * been read yet, the new coredump is discarded. The data lifetime is determined
@@ -326,9 +322,9 @@ EXPORT_SYMBOL_GPL(dev_coredumpm);
  * it will free the data.
  */
 void dev_coredumpsg(struct device *dev, struct scatterlist *table,
-		    size_t datalen, gfp_t gfp)
+		    size_t datalen)
 {
-	dev_coredumpm(dev, NULL, table, datalen, gfp, devcd_read_from_sgtable,
+	dev_coredumpm(dev, NULL, table, datalen, devcd_read_from_sgtable,
 		      devcd_free_sgtable);
 }
 EXPORT_SYMBOL_GPL(dev_coredumpsg);
diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index ba057ebfda5..ab1b93b27ff 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -1502,7 +1502,7 @@ static void btmrvl_sdio_coredump(struct device *dev)
 	/* fw_dump_data will be free in device coredump release function
 	 * after 5 min
 	 */
-	dev_coredumpv(&card->func->dev, fw_dump_data, fw_dump_len, GFP_KERNEL);
+	dev_coredumpv(&card->func->dev, fw_dump_data, fw_dump_len);
 	BT_INFO("== btmrvl firmware dump to /sys/class/devcoredump end");
 }
 
diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 8df11016fd5..95a97b38082 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1120,7 +1120,7 @@ static void qca_controller_memdump(struct work_struct *work)
 				    qca_memdump->ram_dump_size);
 			memdump_buf = qca_memdump->memdump_buf_head;
 			dev_coredumpv(&hu->serdev->dev, memdump_buf,
-				      qca_memdump->received_dump, GFP_KERNEL);
+				      qca_memdump->received_dump);
 			cancel_delayed_work(&qca->ctrl_memdump_timeout);
 			kfree(qca->qca_memdump);
 			qca->qca_memdump = NULL;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index c4a6fe3070b..e1a5cd48ace 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4726,7 +4726,7 @@ static void amdgpu_reset_capture_coredumpm(struct amdgpu_device *adev)
 	struct drm_device *dev = adev_to_drm(adev);
 
 	ktime_get_ts64(&adev->reset_time);
-	dev_coredumpm(dev->dev, THIS_MODULE, adev, 0, GFP_KERNEL,
+	dev_coredumpm(dev->dev, THIS_MODULE, adev, 0,
 		      amdgpu_devcoredump_read, amdgpu_devcoredump_free);
 }
 #endif
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_dump.c b/drivers/gpu/drm/etnaviv/etnaviv_dump.c
index f418e0b7577..519fcb234b3 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_dump.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_dump.c
@@ -225,5 +225,5 @@ void etnaviv_core_dump(struct etnaviv_gem_submit *submit)
 
 	etnaviv_core_dump_header(&iter, ETDUMP_BUF_END, iter.data);
 
-	dev_coredumpv(gpu->dev, iter.start, iter.data - iter.start, GFP_KERNEL);
+	dev_coredumpv(gpu->dev, iter.start, iter.data - iter.start);
 }
diff --git a/drivers/gpu/drm/msm/disp/msm_disp_snapshot.c b/drivers/gpu/drm/msm/disp/msm_disp_snapshot.c
index e75b97127c0..f057d294c30 100644
--- a/drivers/gpu/drm/msm/disp/msm_disp_snapshot.c
+++ b/drivers/gpu/drm/msm/disp/msm_disp_snapshot.c
@@ -74,8 +74,8 @@ static void _msm_disp_snapshot_work(struct kthread_work *work)
 	 * If there is a codedump pending for the device, the dev_coredumpm()
 	 * will also free new coredump state.
 	 */
-	dev_coredumpm(disp_state->dev, THIS_MODULE, disp_state, 0, GFP_KERNEL,
-			disp_devcoredump_read, msm_disp_state_free);
+	dev_coredumpm(disp_state->dev, THIS_MODULE, disp_state, 0,
+		      disp_devcoredump_read, msm_disp_state_free);
 }
 
 void msm_disp_snapshot_state(struct drm_device *drm_dev)
diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index c2bfcf3f1f4..c10e5d25a17 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -295,8 +295,8 @@ static void msm_gpu_crashstate_capture(struct msm_gpu *gpu,
 	gpu->crashstate = state;
 
 	/* FIXME: Release the crashstate if this errors out? */
-	dev_coredumpm(gpu->dev->dev, THIS_MODULE, gpu, 0, GFP_KERNEL,
-		msm_gpu_devcoredump_read, msm_gpu_devcoredump_free);
+	dev_coredumpm(gpu->dev->dev, THIS_MODULE, gpu, 0,
+		      msm_gpu_devcoredump_read, msm_gpu_devcoredump_free);
 }
 #else
 static void msm_gpu_crashstate_capture(struct msm_gpu *gpu,
diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 990a1519f96..8f7df02dbff 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -49,7 +49,7 @@ static void venus_coredump(struct venus_core *core)
 
 	memcpy(data, mem_va, mem_size);
 	memunmap(mem_va);
-	dev_coredumpv(dev, data, mem_size, GFP_KERNEL);
+	dev_coredumpv(dev, data, mem_size);
 }
 
 static void venus_event_notify(struct venus_core *core, u32 event)
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c
index 004eaf96262..a9dfa9ef7a8 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c
@@ -281,5 +281,5 @@ void mcp251xfd_dump(const struct mcp251xfd_priv *priv)
 	mcp251xfd_dump_end(priv, &iter);
 
 	dev_coredumpv(&priv->spi->dev, iter.start,
-		      iter.data - iter.start, GFP_KERNEL);
+		      iter.data - iter.start);
 }
diff --git a/drivers/net/wireless/ath/ath10k/coredump.c b/drivers/net/wireless/ath/ath10k/coredump.c
index fe6b6f97a91..dc923706992 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.c
+++ b/drivers/net/wireless/ath/ath10k/coredump.c
@@ -1607,7 +1607,7 @@ int ath10k_coredump_submit(struct ath10k *ar)
 		return -ENODATA;
 	}
 
-	dev_coredumpv(ar->dev, dump, le32_to_cpu(dump->len), GFP_KERNEL);
+	dev_coredumpv(ar->dev, dump, le32_to_cpu(dump->len));
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/wil6210/wil_crash_dump.c b/drivers/net/wireless/ath/wil6210/wil_crash_dump.c
index 89c12cb2aaa..79299609dd6 100644
--- a/drivers/net/wireless/ath/wil6210/wil_crash_dump.c
+++ b/drivers/net/wireless/ath/wil6210/wil_crash_dump.c
@@ -117,6 +117,6 @@ void wil_fw_core_dump(struct wil6210_priv *wil)
 	/* fw_dump_data will be free in device coredump release function
 	 * after 5 min
 	 */
-	dev_coredumpv(wil_to_dev(wil), fw_dump_data, fw_dump_size, GFP_KERNEL);
+	dev_coredumpv(wil_to_dev(wil), fw_dump_data, fw_dump_size);
 	wil_info(wil, "fw core dumped, size %d bytes\n", fw_dump_size);
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
index eecf8a38d94..87f3652ef3b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
@@ -37,7 +37,7 @@ int brcmf_debug_create_memdump(struct brcmf_bus *bus, const void *data,
 		return err;
 	}
 
-	dev_coredumpv(bus->dev, dump, len + ramsize, GFP_KERNEL);
+	dev_coredumpv(bus->dev, dump, len + ramsize);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index abf49022edb..f2f7cf494a8 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2601,8 +2601,7 @@ static void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 					     fw_error_dump.trans_ptr->data,
 					     fw_error_dump.trans_ptr->len,
 					     fw_error_dump.fwrt_len);
-		dev_coredumpsg(fwrt->trans->dev, sg_dump_data, file_len,
-			       GFP_KERNEL);
+		dev_coredumpsg(fwrt->trans->dev, sg_dump_data, file_len);
 	}
 	vfree(fw_error_dump.fwrt_ptr);
 	vfree(fw_error_dump.trans_ptr);
@@ -2647,8 +2646,7 @@ static void iwl_fw_error_ini_dump(struct iwl_fw_runtime *fwrt,
 					     entry->data, entry->size, offs);
 			offs += entry->size;
 		}
-		dev_coredumpsg(fwrt->trans->dev, sg_dump_data, file_len,
-			       GFP_KERNEL);
+		dev_coredumpsg(fwrt->trans->dev, sg_dump_data, file_len);
 	}
 	iwl_dump_ini_list_free(&dump_list);
 }
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index da2e6557e68..9cadd07bb79 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1103,8 +1103,7 @@ void mwifiex_upload_device_dump(struct mwifiex_adapter *adapter)
 	 */
 	mwifiex_dbg(adapter, MSG,
 		    "== mwifiex dump information to /sys/class/devcoredump start\n");
-	dev_coredumpv(adapter->dev, adapter->devdump_data, adapter->devdump_len,
-		      GFP_KERNEL);
+	dev_coredumpv(adapter->dev, adapter->devdump_data, adapter->devdump_len);
 	mwifiex_dbg(adapter, MSG,
 		    "== mwifiex dump information to /sys/class/devcoredump end\n");
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index ad6c7d632ee..002472b4e63 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -2376,6 +2376,5 @@ void mt7615_coredump_work(struct work_struct *work)
 
 		dev_kfree_skb(skb);
 	}
-	dev_coredumpv(dev->mt76.dev, dump, MT76_CONNAC_COREDUMP_SZ,
-		      GFP_KERNEL);
+	dev_coredumpv(dev->mt76.dev, dump, MT76_CONNAC_COREDUMP_SZ);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 47f0aa81ab0..ff764b7eafa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -986,8 +986,7 @@ void mt7921_coredump_work(struct work_struct *work)
 	}
 
 	if (dump)
-		dev_coredumpv(dev->mt76.dev, dump, MT76_CONNAC_COREDUMP_SZ,
-			      GFP_KERNEL);
+		dev_coredumpv(dev->mt76.dev, dump, MT76_CONNAC_COREDUMP_SZ);
 
 	mt7921_reset(&dev->mt76);
 }
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 76dc9da88f6..25178ed0a0f 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -414,7 +414,7 @@ static void rtw_fwcd_dump(struct rtw_dev *rtwdev)
 	 * framework. Note that a new dump will be discarded if a previous one
 	 * hasn't been released yet.
 	 */
-	dev_coredumpv(rtwdev->dev, desc->data, desc->size, GFP_KERNEL);
+	dev_coredumpv(rtwdev->dev, desc->data, desc->size);
 }
 
 static void rtw_fwcd_free(struct rtw_dev *rtwdev, bool free_self)
diff --git a/drivers/net/wireless/realtek/rtw89/ser.c b/drivers/net/wireless/realtek/rtw89/ser.c
index 726223f25dc..1a77b7c874b 100644
--- a/drivers/net/wireless/realtek/rtw89/ser.c
+++ b/drivers/net/wireless/realtek/rtw89/ser.c
@@ -127,7 +127,7 @@ static void rtw89_ser_cd_send(struct rtw89_dev *rtwdev,
 	 * will be discarded if a previous one hasn't been released by
 	 * framework yet.
 	 */
-	dev_coredumpv(rtwdev->dev, buf, sizeof(*buf), GFP_KERNEL);
+	dev_coredumpv(rtwdev->dev, buf, sizeof(*buf));
 }
 
 static void rtw89_ser_cd_free(struct rtw89_dev *rtwdev,
diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index fddb63cffee..d09e2f4f2f3 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -598,7 +598,7 @@ static void q6v5_dump_mba_logs(struct q6v5 *qproc)
 	data = vmalloc(MBA_LOG_SIZE);
 	if (data) {
 		memcpy(data, mba_region, MBA_LOG_SIZE);
-		dev_coredumpv(&rproc->dev, data, MBA_LOG_SIZE, GFP_KERNEL);
+		dev_coredumpv(&rproc->dev, data, MBA_LOG_SIZE);
 	}
 	memunmap(mba_region);
 }
diff --git a/drivers/remoteproc/remoteproc_coredump.c b/drivers/remoteproc/remoteproc_coredump.c
index 4b093420d98..cd55c2abd22 100644
--- a/drivers/remoteproc/remoteproc_coredump.c
+++ b/drivers/remoteproc/remoteproc_coredump.c
@@ -309,7 +309,7 @@ void rproc_coredump(struct rproc *rproc)
 		phdr += elf_size_of_phdr(class);
 	}
 	if (dump_conf == RPROC_COREDUMP_ENABLED) {
-		dev_coredumpv(&rproc->dev, data, data_size, GFP_KERNEL);
+		dev_coredumpv(&rproc->dev, data, data_size);
 		return;
 	}
 
@@ -318,7 +318,7 @@ void rproc_coredump(struct rproc *rproc)
 	dump_state.header = data;
 	init_completion(&dump_state.dump_done);
 
-	dev_coredumpm(&rproc->dev, NULL, &dump_state, data_size, GFP_KERNEL,
+	dev_coredumpm(&rproc->dev, NULL, &dump_state, data_size,
 		      rproc_coredump_read, rproc_coredump_free);
 
 	/*
@@ -449,7 +449,7 @@ void rproc_coredump_using_sections(struct rproc *rproc)
 	}
 
 	if (dump_conf == RPROC_COREDUMP_ENABLED) {
-		dev_coredumpv(&rproc->dev, data, data_size, GFP_KERNEL);
+		dev_coredumpv(&rproc->dev, data, data_size);
 		return;
 	}
 
@@ -458,7 +458,7 @@ void rproc_coredump_using_sections(struct rproc *rproc)
 	dump_state.header = data;
 	init_completion(&dump_state.dump_done);
 
-	dev_coredumpm(&rproc->dev, NULL, &dump_state, data_size, GFP_KERNEL,
+	dev_coredumpm(&rproc->dev, NULL, &dump_state, data_size,
 		      rproc_coredump_read, rproc_coredump_free);
 
 	/* Wait until the dump is read and free is called. Data is freed
diff --git a/include/drm/drm_print.h b/include/drm/drm_print.h
index 22fabdeed29..b41850366bc 100644
--- a/include/drm/drm_print.h
+++ b/include/drm/drm_print.h
@@ -162,7 +162,7 @@ struct drm_print_iterator {
  *	void makecoredump(...)
  *	{
  *		...
- *		dev_coredumpm(dev, THIS_MODULE, data, 0, GFP_KERNEL,
+ *		dev_coredumpm(dev, THIS_MODULE, data, 0,
  *			coredump_read, ...)
  *	}
  *
diff --git a/include/linux/devcoredump.h b/include/linux/devcoredump.h
index c008169ed2c..c7d840d824c 100644
--- a/include/linux/devcoredump.h
+++ b/include/linux/devcoredump.h
@@ -52,27 +52,26 @@ static inline void _devcd_free_sgtable(struct scatterlist *table)
 
 
 #ifdef CONFIG_DEV_COREDUMP
-void dev_coredumpv(struct device *dev, void *data, size_t datalen,
-		   gfp_t gfp);
+void dev_coredumpv(struct device *dev, void *data, size_t datalen);
 
 void dev_coredumpm(struct device *dev, struct module *owner,
-		   void *data, size_t datalen, gfp_t gfp,
+		   void *data, size_t datalen,
 		   ssize_t (*read)(char *buffer, loff_t offset, size_t count,
 				   void *data, size_t datalen),
 		   void (*free)(void *data));
 
 void dev_coredumpsg(struct device *dev, struct scatterlist *table,
-		    size_t datalen, gfp_t gfp);
+		    size_t datalen);
 #else
 static inline void dev_coredumpv(struct device *dev, void *data,
-				 size_t datalen, gfp_t gfp)
+				 size_t datalen)
 {
 	vfree(data);
 }
 
 static inline void
 dev_coredumpm(struct device *dev, struct module *owner,
-	      void *data, size_t datalen, gfp_t gfp,
+	      void *data, size_t datalen,
 	      ssize_t (*read)(char *buffer, loff_t offset, size_t count,
 			      void *data, size_t datalen),
 	      void (*free)(void *data))
@@ -81,7 +80,7 @@ dev_coredumpm(struct device *dev, struct module *owner,
 }
 
 static inline void dev_coredumpsg(struct device *dev, struct scatterlist *table,
-				  size_t datalen, gfp_t gfp)
+				  size_t datalen)
 {
 	_devcd_free_sgtable(table);
 }
diff --git a/sound/soc/intel/avs/apl.c b/sound/soc/intel/avs/apl.c
index b8e2b23c9f6..1ff57f1a483 100644
--- a/sound/soc/intel/avs/apl.c
+++ b/sound/soc/intel/avs/apl.c
@@ -164,7 +164,7 @@ static int apl_coredump(struct avs_dev *adev, union avs_notify_msg *msg)
 	} while (offset < msg->ext.coredump.stack_dump_size);
 
 exit:
-	dev_coredumpv(adev->dev, dump, dump_size, GFP_KERNEL);
+	dev_coredumpv(adev->dev, dump, dump_size);
 
 	return 0;
 }
diff --git a/sound/soc/intel/avs/skl.c b/sound/soc/intel/avs/skl.c
index bda5ec7510f..3413162768d 100644
--- a/sound/soc/intel/avs/skl.c
+++ b/sound/soc/intel/avs/skl.c
@@ -88,7 +88,7 @@ static int skl_coredump(struct avs_dev *adev, union avs_notify_msg *msg)
 		return -ENOMEM;
 
 	memcpy_fromio(dump, avs_sram_addr(adev, AVS_FW_REGS_WINDOW), AVS_FW_REGS_SIZE);
-	dev_coredumpv(adev->dev, dump, AVS_FW_REGS_SIZE, GFP_KERNEL);
+	dev_coredumpv(adev->dev, dump, AVS_FW_REGS_SIZE);
 
 	return 0;
 }
diff --git a/sound/soc/intel/catpt/dsp.c b/sound/soc/intel/catpt/dsp.c
index 346bec00030..d2afe9ff1e3 100644
--- a/sound/soc/intel/catpt/dsp.c
+++ b/sound/soc/intel/catpt/dsp.c
@@ -539,7 +539,7 @@ int catpt_coredump(struct catpt_dev *cdev)
 		pos += CATPT_DMA_REGS_SIZE;
 	}
 
-	dev_coredumpv(cdev->dev, dump, dump_size, GFP_KERNEL);
+	dev_coredumpv(cdev->dev, dump, dump_size);
 
 	return 0;
 }
-- 
2.17.1

