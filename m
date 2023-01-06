Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A4465F97A
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 03:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjAFCQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 21:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjAFCQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 21:16:17 -0500
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E0E61465
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 18:16:11 -0800 (PST)
X-QQ-mid: bizesmtp69t1672971298tqv57j8y
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 06 Jan 2023 10:14:57 +0800 (CST)
X-QQ-SSF: 01400000000000H0X000000A0000000
X-QQ-FEAT: vLOCICHxEeDWL6CTr9QVQjXHzBCdz0jfDI4CFSe7N2wxpY6IgG3c1E2vcjIoe
        NfE/TLv0yjW7uQrnSVnlD+WK9x3WV3Vb6yDgYI1Bbz3DM8Q/uNgh0u4LqAl4rmRIfxLez05
        EC1I8rhG7uTSJzdWSQUxm0EM6chxP+WL29w1IV6nxQxxPxI0u5uSFkJ+HW9Ptp7jB1quHA7
        CiTIVWaXncEo3+nE7J+n+LIvuGUKK/pftXrtQbsoOh9acSfoVQukzK8Hir5w6ASQ8WnPy+A
        Ke64/sM+nTt3riq4jJ/bOgAUwHLnrb8lxlETGZntJX7dwfqPcO+HxTvu/3ztWPHCBkAfObc
        Pfsb1noE/g/Gei32fY2CL5t8Vn1qYVm6VI3kOD/RTWJYztaFu4JH6r9yKAZCt4wgnS9ZOi1
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v3 5/7] net: wangxun: Rename private structure in libwx
Date:   Fri,  6 Jan 2023 10:11:43 +0800
Message-Id: <20230106021145.2803126-6-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230106021145.2803126-1-jiawenwu@trustnetic.com>
References: <20230106021145.2803126-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to move the total members in struct adapter to struct wx_hw
to keep the code clean, it's a bad name of 'wx_hw' only for hardware.
Rename 'wx_hw' to 'wx', and rename the pointers at use.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 474 +++++++++---------
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |  36 +-
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |  20 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   |  32 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  86 ++--
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |   2 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 104 ++--
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   4 +-
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 104 ++--
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |   2 +-
 10 files changed, 432 insertions(+), 432 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index e04a394ddbe2..148a0496e924 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -10,18 +10,18 @@
 #include "wx_type.h"
 #include "wx_hw.h"
 
-static void wx_intr_disable(struct wx_hw *wxhw, u64 qmask)
+static void wx_intr_disable(struct wx *wx, u64 qmask)
 {
 	u32 mask;
 
 	mask = (qmask & 0xFFFFFFFF);
 	if (mask)
-		wr32(wxhw, WX_PX_IMS(0), mask);
+		wr32(wx, WX_PX_IMS(0), mask);
 
-	if (wxhw->mac.type == wx_mac_sp) {
+	if (wx->mac.type == wx_mac_sp) {
 		mask = (qmask >> 32);
 		if (mask)
-			wr32(wxhw, WX_PX_IMS(1), mask);
+			wr32(wx, WX_PX_IMS(1), mask);
 	}
 }
 
@@ -29,33 +29,33 @@ static void wx_intr_disable(struct wx_hw *wxhw, u64 qmask)
  * 1. to be sector address, when implemented erase sector command
  * 2. to be flash address when implemented read, write flash address
  */
-static int wx_fmgr_cmd_op(struct wx_hw *wxhw, u32 cmd, u32 cmd_addr)
+static int wx_fmgr_cmd_op(struct wx *wx, u32 cmd, u32 cmd_addr)
 {
 	u32 cmd_val = 0, val = 0;
 
 	cmd_val = WX_SPI_CMD_CMD(cmd) |
 		  WX_SPI_CMD_CLK(WX_SPI_CLK_DIV) |
 		  cmd_addr;
-	wr32(wxhw, WX_SPI_CMD, cmd_val);
+	wr32(wx, WX_SPI_CMD, cmd_val);
 
 	return read_poll_timeout(rd32, val, (val & 0x1), 10, 100000,
-				 false, wxhw, WX_SPI_STATUS);
+				 false, wx, WX_SPI_STATUS);
 }
 
-static int wx_flash_read_dword(struct wx_hw *wxhw, u32 addr, u32 *data)
+static int wx_flash_read_dword(struct wx *wx, u32 addr, u32 *data)
 {
 	int ret = 0;
 
-	ret = wx_fmgr_cmd_op(wxhw, WX_SPI_CMD_READ_DWORD, addr);
+	ret = wx_fmgr_cmd_op(wx, WX_SPI_CMD_READ_DWORD, addr);
 	if (ret < 0)
 		return ret;
 
-	*data = rd32(wxhw, WX_SPI_DATA);
+	*data = rd32(wx, WX_SPI_DATA);
 
 	return ret;
 }
 
-int wx_check_flash_load(struct wx_hw *hw, u32 check_bit)
+int wx_check_flash_load(struct wx *hw, u32 check_bit)
 {
 	u32 reg = 0;
 	int err = 0;
@@ -74,15 +74,15 @@ int wx_check_flash_load(struct wx_hw *hw, u32 check_bit)
 }
 EXPORT_SYMBOL(wx_check_flash_load);
 
-void wx_control_hw(struct wx_hw *wxhw, bool drv)
+void wx_control_hw(struct wx *wx, bool drv)
 {
 	if (drv) {
 		/* Let firmware know the driver has taken over */
-		wr32m(wxhw, WX_CFG_PORT_CTL,
+		wr32m(wx, WX_CFG_PORT_CTL,
 		      WX_CFG_PORT_CTL_DRV_LOAD, WX_CFG_PORT_CTL_DRV_LOAD);
 	} else {
 		/* Let firmware take over control of hw */
-		wr32m(wxhw, WX_CFG_PORT_CTL,
+		wr32m(wx, WX_CFG_PORT_CTL,
 		      WX_CFG_PORT_CTL_DRV_LOAD, 0);
 	}
 }
@@ -90,13 +90,13 @@ EXPORT_SYMBOL(wx_control_hw);
 
 /**
  * wx_mng_present - returns 0 when management capability is present
- * @wxhw: pointer to hardware structure
+ * @wx: pointer to hardware structure
  */
-int wx_mng_present(struct wx_hw *wxhw)
+int wx_mng_present(struct wx *wx)
 {
 	u32 fwsm;
 
-	fwsm = rd32(wxhw, WX_MIS_ST);
+	fwsm = rd32(wx, WX_MIS_ST);
 	if (fwsm & WX_MIS_ST_MNG_INIT_DN)
 		return 0;
 	else
@@ -109,40 +109,40 @@ static DEFINE_MUTEX(wx_sw_sync_lock);
 
 /**
  *  wx_release_sw_sync - Release SW semaphore
- *  @wxhw: pointer to hardware structure
+ *  @wx: pointer to hardware structure
  *  @mask: Mask to specify which semaphore to release
  *
  *  Releases the SW semaphore for the specified
  *  function (CSR, PHY0, PHY1, EEPROM, Flash)
  **/
-static void wx_release_sw_sync(struct wx_hw *wxhw, u32 mask)
+static void wx_release_sw_sync(struct wx *wx, u32 mask)
 {
 	mutex_lock(&wx_sw_sync_lock);
-	wr32m(wxhw, WX_MNG_SWFW_SYNC, mask, 0);
+	wr32m(wx, WX_MNG_SWFW_SYNC, mask, 0);
 	mutex_unlock(&wx_sw_sync_lock);
 }
 
 /**
  *  wx_acquire_sw_sync - Acquire SW semaphore
- *  @wxhw: pointer to hardware structure
+ *  @wx: pointer to hardware structure
  *  @mask: Mask to specify which semaphore to acquire
  *
  *  Acquires the SW semaphore for the specified
  *  function (CSR, PHY0, PHY1, EEPROM, Flash)
  **/
-static int wx_acquire_sw_sync(struct wx_hw *wxhw, u32 mask)
+static int wx_acquire_sw_sync(struct wx *wx, u32 mask)
 {
 	u32 sem = 0;
 	int ret = 0;
 
 	mutex_lock(&wx_sw_sync_lock);
 	ret = read_poll_timeout(rd32, sem, !(sem & mask),
-				5000, 2000000, false, wxhw, WX_MNG_SWFW_SYNC);
+				5000, 2000000, false, wx, WX_MNG_SWFW_SYNC);
 	if (!ret) {
 		sem |= mask;
-		wr32(wxhw, WX_MNG_SWFW_SYNC, sem);
+		wr32(wx, WX_MNG_SWFW_SYNC, sem);
 	} else {
-		wx_err(wxhw, "SW Semaphore not granted: 0x%x.\n", sem);
+		wx_err(wx, "SW Semaphore not granted: 0x%x.\n", sem);
 	}
 	mutex_unlock(&wx_sw_sync_lock);
 
@@ -151,7 +151,7 @@ static int wx_acquire_sw_sync(struct wx_hw *wxhw, u32 mask)
 
 /**
  *  wx_host_interface_command - Issue command to manageability block
- *  @wxhw: pointer to the HW structure
+ *  @wx: pointer to the HW structure
  *  @buffer: contains the command to write and where the return status will
  *   be placed
  *  @length: length of buffer, must be multiple of 4 bytes
@@ -163,7 +163,7 @@ static int wx_acquire_sw_sync(struct wx_hw *wxhw, u32 mask)
  *   So we will leave this up to the caller to read back the data
  *   in these cases.
  **/
-int wx_host_interface_command(struct wx_hw *wxhw, u32 *buffer,
+int wx_host_interface_command(struct wx *wx, u32 *buffer,
 			      u32 length, u32 timeout, bool return_data)
 {
 	u32 hdr_size = sizeof(struct wx_hic_hdr);
@@ -173,17 +173,17 @@ int wx_host_interface_command(struct wx_hw *wxhw, u32 *buffer,
 	u16 buf_len;
 
 	if (length == 0 || length > WX_HI_MAX_BLOCK_BYTE_LENGTH) {
-		wx_err(wxhw, "Buffer length failure buffersize=%d.\n", length);
+		wx_err(wx, "Buffer length failure buffersize=%d.\n", length);
 		return -EINVAL;
 	}
 
-	status = wx_acquire_sw_sync(wxhw, WX_MNG_SWFW_SYNC_SW_MB);
+	status = wx_acquire_sw_sync(wx, WX_MNG_SWFW_SYNC_SW_MB);
 	if (status != 0)
 		return status;
 
 	/* Calculate length in DWORDs. We must be DWORD aligned */
 	if ((length % (sizeof(u32))) != 0) {
-		wx_err(wxhw, "Buffer length failure, not aligned to dword");
+		wx_err(wx, "Buffer length failure, not aligned to dword");
 		status = -EINVAL;
 		goto rel_out;
 	}
@@ -194,38 +194,38 @@ int wx_host_interface_command(struct wx_hw *wxhw, u32 *buffer,
 	 * into the ram area.
 	 */
 	for (i = 0; i < dword_len; i++) {
-		wr32a(wxhw, WX_MNG_MBOX, i, (__force u32)cpu_to_le32(buffer[i]));
+		wr32a(wx, WX_MNG_MBOX, i, (__force u32)cpu_to_le32(buffer[i]));
 		/* write flush */
-		buf[i] = rd32a(wxhw, WX_MNG_MBOX, i);
+		buf[i] = rd32a(wx, WX_MNG_MBOX, i);
 	}
 	/* Setting this bit tells the ARC that a new command is pending. */
-	wr32m(wxhw, WX_MNG_MBOX_CTL,
+	wr32m(wx, WX_MNG_MBOX_CTL,
 	      WX_MNG_MBOX_CTL_SWRDY, WX_MNG_MBOX_CTL_SWRDY);
 
 	status = read_poll_timeout(rd32, hicr, hicr & WX_MNG_MBOX_CTL_FWRDY, 1000,
-				   timeout * 1000, false, wxhw, WX_MNG_MBOX_CTL);
+				   timeout * 1000, false, wx, WX_MNG_MBOX_CTL);
 
 	/* Check command completion */
 	if (status) {
-		wx_dbg(wxhw, "Command has failed with no status valid.\n");
+		wx_dbg(wx, "Command has failed with no status valid.\n");
 
-		buf[0] = rd32(wxhw, WX_MNG_MBOX);
+		buf[0] = rd32(wx, WX_MNG_MBOX);
 		if ((buffer[0] & 0xff) != (~buf[0] >> 24)) {
 			status = -EINVAL;
 			goto rel_out;
 		}
 		if ((buf[0] & 0xff0000) >> 16 == 0x80) {
-			wx_dbg(wxhw, "It's unknown cmd.\n");
+			wx_dbg(wx, "It's unknown cmd.\n");
 			status = -EINVAL;
 			goto rel_out;
 		}
 
-		wx_dbg(wxhw, "write value:\n");
+		wx_dbg(wx, "write value:\n");
 		for (i = 0; i < dword_len; i++)
-			wx_dbg(wxhw, "%x ", buffer[i]);
-		wx_dbg(wxhw, "read value:\n");
+			wx_dbg(wx, "%x ", buffer[i]);
+		wx_dbg(wx, "read value:\n");
 		for (i = 0; i < dword_len; i++)
-			wx_dbg(wxhw, "%x ", buf[i]);
+			wx_dbg(wx, "%x ", buf[i]);
 	}
 
 	if (!return_data)
@@ -236,7 +236,7 @@ int wx_host_interface_command(struct wx_hw *wxhw, u32 *buffer,
 
 	/* first pull in the header so we know the buffer length */
 	for (bi = 0; bi < dword_len; bi++) {
-		buffer[bi] = rd32a(wxhw, WX_MNG_MBOX, bi);
+		buffer[bi] = rd32a(wx, WX_MNG_MBOX, bi);
 		le32_to_cpus(&buffer[bi]);
 	}
 
@@ -246,7 +246,7 @@ int wx_host_interface_command(struct wx_hw *wxhw, u32 *buffer,
 		goto rel_out;
 
 	if (length < buf_len + hdr_size) {
-		wx_err(wxhw, "Buffer not large enough for reply message.\n");
+		wx_err(wx, "Buffer not large enough for reply message.\n");
 		status = -EFAULT;
 		goto rel_out;
 	}
@@ -256,12 +256,12 @@ int wx_host_interface_command(struct wx_hw *wxhw, u32 *buffer,
 
 	/* Pull in the rest of the buffer (bi is where we left off) */
 	for (; bi <= dword_len; bi++) {
-		buffer[bi] = rd32a(wxhw, WX_MNG_MBOX, bi);
+		buffer[bi] = rd32a(wx, WX_MNG_MBOX, bi);
 		le32_to_cpus(&buffer[bi]);
 	}
 
 rel_out:
-	wx_release_sw_sync(wxhw, WX_MNG_SWFW_SYNC_SW_MB);
+	wx_release_sw_sync(wx, WX_MNG_SWFW_SYNC_SW_MB);
 	return status;
 }
 EXPORT_SYMBOL(wx_host_interface_command);
@@ -269,13 +269,13 @@ EXPORT_SYMBOL(wx_host_interface_command);
 /**
  *  wx_read_ee_hostif_data - Read EEPROM word using a host interface cmd
  *  assuming that the semaphore is already obtained.
- *  @wxhw: pointer to hardware structure
+ *  @wx: pointer to hardware structure
  *  @offset: offset of  word in the EEPROM to read
  *  @data: word read from the EEPROM
  *
  *  Reads a 16 bit word from the EEPROM using the hostif.
  **/
-static int wx_read_ee_hostif_data(struct wx_hw *wxhw, u16 offset, u16 *data)
+static int wx_read_ee_hostif_data(struct wx *wx, u16 offset, u16 *data)
 {
 	struct wx_hic_read_shadow_ram buffer;
 	int status;
@@ -290,33 +290,33 @@ static int wx_read_ee_hostif_data(struct wx_hw *wxhw, u16 offset, u16 *data)
 	/* one word */
 	buffer.length = (__force u16)cpu_to_be16(sizeof(u16));
 
-	status = wx_host_interface_command(wxhw, (u32 *)&buffer, sizeof(buffer),
+	status = wx_host_interface_command(wx, (u32 *)&buffer, sizeof(buffer),
 					   WX_HI_COMMAND_TIMEOUT, false);
 
 	if (status != 0)
 		return status;
 
-	*data = (u16)rd32a(wxhw, WX_MNG_MBOX, FW_NVM_DATA_OFFSET);
+	*data = (u16)rd32a(wx, WX_MNG_MBOX, FW_NVM_DATA_OFFSET);
 
 	return status;
 }
 
 /**
  *  wx_read_ee_hostif - Read EEPROM word using a host interface cmd
- *  @wxhw: pointer to hardware structure
+ *  @wx: pointer to hardware structure
  *  @offset: offset of  word in the EEPROM to read
  *  @data: word read from the EEPROM
  *
  *  Reads a 16 bit word from the EEPROM using the hostif.
  **/
-int wx_read_ee_hostif(struct wx_hw *wxhw, u16 offset, u16 *data)
+int wx_read_ee_hostif(struct wx *wx, u16 offset, u16 *data)
 {
 	int status = 0;
 
-	status = wx_acquire_sw_sync(wxhw, WX_MNG_SWFW_SYNC_SW_FLASH);
+	status = wx_acquire_sw_sync(wx, WX_MNG_SWFW_SYNC_SW_FLASH);
 	if (status == 0) {
-		status = wx_read_ee_hostif_data(wxhw, offset, data);
-		wx_release_sw_sync(wxhw, WX_MNG_SWFW_SYNC_SW_FLASH);
+		status = wx_read_ee_hostif_data(wx, offset, data);
+		wx_release_sw_sync(wx, WX_MNG_SWFW_SYNC_SW_FLASH);
 	}
 
 	return status;
@@ -325,14 +325,14 @@ EXPORT_SYMBOL(wx_read_ee_hostif);
 
 /**
  *  wx_read_ee_hostif_buffer- Read EEPROM word(s) using hostif
- *  @wxhw: pointer to hardware structure
+ *  @wx: pointer to hardware structure
  *  @offset: offset of  word in the EEPROM to read
  *  @words: number of words
  *  @data: word(s) read from the EEPROM
  *
  *  Reads a 16 bit word(s) from the EEPROM using the hostif.
  **/
-int wx_read_ee_hostif_buffer(struct wx_hw *wxhw,
+int wx_read_ee_hostif_buffer(struct wx *wx,
 			     u16 offset, u16 words, u16 *data)
 {
 	struct wx_hic_read_shadow_ram buffer;
@@ -343,7 +343,7 @@ int wx_read_ee_hostif_buffer(struct wx_hw *wxhw,
 	u32 i;
 
 	/* Take semaphore for the entire operation. */
-	status = wx_acquire_sw_sync(wxhw, WX_MNG_SWFW_SYNC_SW_FLASH);
+	status = wx_acquire_sw_sync(wx, WX_MNG_SWFW_SYNC_SW_FLASH);
 	if (status != 0)
 		return status;
 
@@ -362,20 +362,20 @@ int wx_read_ee_hostif_buffer(struct wx_hw *wxhw,
 		buffer.address = (__force u32)cpu_to_be32((offset + current_word) * 2);
 		buffer.length = (__force u16)cpu_to_be16(words_to_read * 2);
 
-		status = wx_host_interface_command(wxhw, (u32 *)&buffer,
+		status = wx_host_interface_command(wx, (u32 *)&buffer,
 						   sizeof(buffer),
 						   WX_HI_COMMAND_TIMEOUT,
 						   false);
 
 		if (status != 0) {
-			wx_err(wxhw, "Host interface command failed\n");
+			wx_err(wx, "Host interface command failed\n");
 			goto out;
 		}
 
 		for (i = 0; i < words_to_read; i++) {
 			u32 reg = WX_MNG_MBOX + (FW_NVM_DATA_OFFSET << 2) + 2 * i;
 
-			value = rd32(wxhw, reg);
+			value = rd32(wx, reg);
 			data[current_word] = (u16)(value & 0xffff);
 			current_word++;
 			i++;
@@ -389,7 +389,7 @@ int wx_read_ee_hostif_buffer(struct wx_hw *wxhw,
 	}
 
 out:
-	wx_release_sw_sync(wxhw, WX_MNG_SWFW_SYNC_SW_FLASH);
+	wx_release_sw_sync(wx, WX_MNG_SWFW_SYNC_SW_FLASH);
 	return status;
 }
 EXPORT_SYMBOL(wx_read_ee_hostif_buffer);
@@ -417,12 +417,12 @@ static u8 wx_calculate_checksum(u8 *buffer, u32 length)
 
 /**
  *  wx_reset_hostif - send reset cmd to fw
- *  @wxhw: pointer to hardware structure
+ *  @wx: pointer to hardware structure
  *
  *  Sends reset cmd to firmware through the manageability
  *  block.
  **/
-int wx_reset_hostif(struct wx_hw *wxhw)
+int wx_reset_hostif(struct wx *wx)
 {
 	struct wx_hic_reset reset_cmd;
 	int ret_val = 0;
@@ -431,15 +431,15 @@ int wx_reset_hostif(struct wx_hw *wxhw)
 	reset_cmd.hdr.cmd = FW_RESET_CMD;
 	reset_cmd.hdr.buf_len = FW_RESET_LEN;
 	reset_cmd.hdr.cmd_or_resp.cmd_resv = FW_CEM_CMD_RESERVED;
-	reset_cmd.lan_id = wxhw->bus.func;
-	reset_cmd.reset_type = (u16)wxhw->reset_type;
+	reset_cmd.lan_id = wx->bus.func;
+	reset_cmd.reset_type = (u16)wx->reset_type;
 	reset_cmd.hdr.checksum = 0;
 	reset_cmd.hdr.checksum = wx_calculate_checksum((u8 *)&reset_cmd,
 						       (FW_CEM_HDR_LEN +
 							reset_cmd.hdr.buf_len));
 
 	for (i = 0; i <= FW_CEM_MAX_RETRIES; i++) {
-		ret_val = wx_host_interface_command(wxhw, (u32 *)&reset_cmd,
+		ret_val = wx_host_interface_command(wx, (u32 *)&reset_cmd,
 						    sizeof(reset_cmd),
 						    WX_HI_COMMAND_TIMEOUT,
 						    true);
@@ -461,14 +461,14 @@ EXPORT_SYMBOL(wx_reset_hostif);
 
 /**
  *  wx_init_eeprom_params - Initialize EEPROM params
- *  @wxhw: pointer to hardware structure
+ *  @wx: pointer to hardware structure
  *
  *  Initializes the EEPROM parameters wx_eeprom_info within the
  *  wx_hw struct in order to set up EEPROM access.
  **/
-void wx_init_eeprom_params(struct wx_hw *wxhw)
+void wx_init_eeprom_params(struct wx *wx)
 {
-	struct wx_eeprom_info *eeprom = &wxhw->eeprom;
+	struct wx_eeprom_info *eeprom = &wx->eeprom;
 	u16 eeprom_size;
 	u16 data = 0x80;
 
@@ -476,21 +476,21 @@ void wx_init_eeprom_params(struct wx_hw *wxhw)
 		eeprom->semaphore_delay = 10;
 		eeprom->type = wx_eeprom_none;
 
-		if (!(rd32(wxhw, WX_SPI_STATUS) &
+		if (!(rd32(wx, WX_SPI_STATUS) &
 		      WX_SPI_STATUS_FLASH_BYPASS)) {
 			eeprom->type = wx_flash;
 
 			eeprom_size = 4096;
 			eeprom->word_size = eeprom_size >> 1;
 
-			wx_dbg(wxhw, "Eeprom params: type = %d, size = %d\n",
+			wx_dbg(wx, "Eeprom params: type = %d, size = %d\n",
 			       eeprom->type, eeprom->word_size);
 		}
 	}
 
-	if (wxhw->mac.type == wx_mac_sp) {
-		if (wx_read_ee_hostif(wxhw, WX_SW_REGION_PTR, &data)) {
-			wx_err(wxhw, "NVM Read Error\n");
+	if (wx->mac.type == wx_mac_sp) {
+		if (wx_read_ee_hostif(wx, WX_SW_REGION_PTR, &data)) {
+			wx_err(wx, "NVM Read Error\n");
 			return;
 		}
 		data = data >> 1;
@@ -502,22 +502,22 @@ EXPORT_SYMBOL(wx_init_eeprom_params);
 
 /**
  *  wx_get_mac_addr - Generic get MAC address
- *  @wxhw: pointer to hardware structure
+ *  @wx: pointer to hardware structure
  *  @mac_addr: Adapter MAC address
  *
  *  Reads the adapter's MAC address from first Receive Address Register (RAR0)
  *  A reset of the adapter must be performed prior to calling this function
  *  in order for the MAC address to have been loaded from the EEPROM into RAR0
  **/
-void wx_get_mac_addr(struct wx_hw *wxhw, u8 *mac_addr)
+void wx_get_mac_addr(struct wx *wx, u8 *mac_addr)
 {
 	u32 rar_high;
 	u32 rar_low;
 	u16 i;
 
-	wr32(wxhw, WX_PSR_MAC_SWC_IDX, 0);
-	rar_high = rd32(wxhw, WX_PSR_MAC_SWC_AD_H);
-	rar_low = rd32(wxhw, WX_PSR_MAC_SWC_AD_L);
+	wr32(wx, WX_PSR_MAC_SWC_IDX, 0);
+	rar_high = rd32(wx, WX_PSR_MAC_SWC_AD_H);
+	rar_low = rd32(wx, WX_PSR_MAC_SWC_AD_L);
 
 	for (i = 0; i < 2; i++)
 		mac_addr[i] = (u8)(rar_high >> (1 - i) * 8);
@@ -529,7 +529,7 @@ EXPORT_SYMBOL(wx_get_mac_addr);
 
 /**
  *  wx_set_rar - Set Rx address register
- *  @wxhw: pointer to hardware structure
+ *  @wx: pointer to hardware structure
  *  @index: Receive address register to write
  *  @addr: Address to put into receive address register
  *  @pools: VMDq "set" or "pool" index
@@ -537,25 +537,25 @@ EXPORT_SYMBOL(wx_get_mac_addr);
  *
  *  Puts an ethernet address into a receive address register.
  **/
-static int wx_set_rar(struct wx_hw *wxhw, u32 index, u8 *addr, u64 pools,
+static int wx_set_rar(struct wx *wx, u32 index, u8 *addr, u64 pools,
 		      u32 enable_addr)
 {
-	u32 rar_entries = wxhw->mac.num_rar_entries;
+	u32 rar_entries = wx->mac.num_rar_entries;
 	u32 rar_low, rar_high;
 
 	/* Make sure we are using a valid rar index range */
 	if (index >= rar_entries) {
-		wx_err(wxhw, "RAR index %d is out of range.\n", index);
+		wx_err(wx, "RAR index %d is out of range.\n", index);
 		return -EINVAL;
 	}
 
 	/* select the MAC address */
-	wr32(wxhw, WX_PSR_MAC_SWC_IDX, index);
+	wr32(wx, WX_PSR_MAC_SWC_IDX, index);
 
 	/* setup VMDq pool mapping */
-	wr32(wxhw, WX_PSR_MAC_SWC_VM_L, pools & 0xFFFFFFFF);
-	if (wxhw->mac.type == wx_mac_sp)
-		wr32(wxhw, WX_PSR_MAC_SWC_VM_H, pools >> 32);
+	wr32(wx, WX_PSR_MAC_SWC_VM_L, pools & 0xFFFFFFFF);
+	if (wx->mac.type == wx_mac_sp)
+		wr32(wx, WX_PSR_MAC_SWC_VM_H, pools >> 32);
 
 	/* HW expects these in little endian so we reverse the byte
 	 * order from network order (big endian) to little endian
@@ -573,8 +573,8 @@ static int wx_set_rar(struct wx_hw *wxhw, u32 index, u8 *addr, u64 pools,
 	if (enable_addr != 0)
 		rar_high |= WX_PSR_MAC_SWC_AD_H_AV;
 
-	wr32(wxhw, WX_PSR_MAC_SWC_AD_L, rar_low);
-	wr32m(wxhw, WX_PSR_MAC_SWC_AD_H,
+	wr32(wx, WX_PSR_MAC_SWC_AD_L, rar_low);
+	wr32m(wx, WX_PSR_MAC_SWC_AD_H,
 	      (WX_PSR_MAC_SWC_AD_H_AD(~0) |
 	       WX_PSR_MAC_SWC_AD_H_ADTYPE(~0) |
 	       WX_PSR_MAC_SWC_AD_H_AV),
@@ -585,18 +585,18 @@ static int wx_set_rar(struct wx_hw *wxhw, u32 index, u8 *addr, u64 pools,
 
 /**
  *  wx_clear_rar - Remove Rx address register
- *  @wxhw: pointer to hardware structure
+ *  @wx: pointer to hardware structure
  *  @index: Receive address register to write
  *
  *  Clears an ethernet address from a receive address register.
  **/
-static int wx_clear_rar(struct wx_hw *wxhw, u32 index)
+static int wx_clear_rar(struct wx *wx, u32 index)
 {
-	u32 rar_entries = wxhw->mac.num_rar_entries;
+	u32 rar_entries = wx->mac.num_rar_entries;
 
 	/* Make sure we are using a valid rar index range */
 	if (index >= rar_entries) {
-		wx_err(wxhw, "RAR index %d is out of range.\n", index);
+		wx_err(wx, "RAR index %d is out of range.\n", index);
 		return -EINVAL;
 	}
 
@@ -604,13 +604,13 @@ static int wx_clear_rar(struct wx_hw *wxhw, u32 index)
 	 * so save everything except the lower 16 bits that hold part
 	 * of the address and the address valid bit.
 	 */
-	wr32(wxhw, WX_PSR_MAC_SWC_IDX, index);
+	wr32(wx, WX_PSR_MAC_SWC_IDX, index);
 
-	wr32(wxhw, WX_PSR_MAC_SWC_VM_L, 0);
-	wr32(wxhw, WX_PSR_MAC_SWC_VM_H, 0);
+	wr32(wx, WX_PSR_MAC_SWC_VM_L, 0);
+	wr32(wx, WX_PSR_MAC_SWC_VM_H, 0);
 
-	wr32(wxhw, WX_PSR_MAC_SWC_AD_L, 0);
-	wr32m(wxhw, WX_PSR_MAC_SWC_AD_H,
+	wr32(wx, WX_PSR_MAC_SWC_AD_L, 0);
+	wr32m(wx, WX_PSR_MAC_SWC_AD_H,
 	      (WX_PSR_MAC_SWC_AD_H_AD(~0) |
 	       WX_PSR_MAC_SWC_AD_H_ADTYPE(~0) |
 	       WX_PSR_MAC_SWC_AD_H_AV),
@@ -621,60 +621,60 @@ static int wx_clear_rar(struct wx_hw *wxhw, u32 index)
 
 /**
  *  wx_clear_vmdq - Disassociate a VMDq pool index from a rx address
- *  @wxhw: pointer to hardware struct
+ *  @wx: pointer to hardware struct
  *  @rar: receive address register index to disassociate
  *  @vmdq: VMDq pool index to remove from the rar
  **/
-static int wx_clear_vmdq(struct wx_hw *wxhw, u32 rar, u32 __maybe_unused vmdq)
+static int wx_clear_vmdq(struct wx *wx, u32 rar, u32 __maybe_unused vmdq)
 {
-	u32 rar_entries = wxhw->mac.num_rar_entries;
+	u32 rar_entries = wx->mac.num_rar_entries;
 	u32 mpsar_lo, mpsar_hi;
 
 	/* Make sure we are using a valid rar index range */
 	if (rar >= rar_entries) {
-		wx_err(wxhw, "RAR index %d is out of range.\n", rar);
+		wx_err(wx, "RAR index %d is out of range.\n", rar);
 		return -EINVAL;
 	}
 
-	wr32(wxhw, WX_PSR_MAC_SWC_IDX, rar);
-	mpsar_lo = rd32(wxhw, WX_PSR_MAC_SWC_VM_L);
-	mpsar_hi = rd32(wxhw, WX_PSR_MAC_SWC_VM_H);
+	wr32(wx, WX_PSR_MAC_SWC_IDX, rar);
+	mpsar_lo = rd32(wx, WX_PSR_MAC_SWC_VM_L);
+	mpsar_hi = rd32(wx, WX_PSR_MAC_SWC_VM_H);
 
 	if (!mpsar_lo && !mpsar_hi)
 		return 0;
 
 	/* was that the last pool using this rar? */
 	if (mpsar_lo == 0 && mpsar_hi == 0 && rar != 0)
-		wx_clear_rar(wxhw, rar);
+		wx_clear_rar(wx, rar);
 
 	return 0;
 }
 
 /**
  *  wx_init_uta_tables - Initialize the Unicast Table Array
- *  @wxhw: pointer to hardware structure
+ *  @wx: pointer to hardware structure
  **/
-static void wx_init_uta_tables(struct wx_hw *wxhw)
+static void wx_init_uta_tables(struct wx *wx)
 {
 	int i;
 
-	wx_dbg(wxhw, " Clearing UTA\n");
+	wx_dbg(wx, " Clearing UTA\n");
 
 	for (i = 0; i < 128; i++)
-		wr32(wxhw, WX_PSR_UC_TBL(i), 0);
+		wr32(wx, WX_PSR_UC_TBL(i), 0);
 }
 
 /**
  *  wx_init_rx_addrs - Initializes receive address filters.
- *  @wxhw: pointer to hardware structure
+ *  @wx: pointer to hardware structure
  *
  *  Places the MAC address in receive address register 0 and clears the rest
  *  of the receive address registers. Clears the multicast table. Assumes
  *  the receiver is in reset when the routine is called.
  **/
-void wx_init_rx_addrs(struct wx_hw *wxhw)
+void wx_init_rx_addrs(struct wx *wx)
 {
-	u32 rar_entries = wxhw->mac.num_rar_entries;
+	u32 rar_entries = wx->mac.num_rar_entries;
 	u32 psrctl;
 	int i;
 
@@ -682,94 +682,94 @@ void wx_init_rx_addrs(struct wx_hw *wxhw)
 	 * to the permanent address.
 	 * Otherwise, use the permanent address from the eeprom.
 	 */
-	if (!is_valid_ether_addr(wxhw->mac.addr)) {
+	if (!is_valid_ether_addr(wx->mac.addr)) {
 		/* Get the MAC address from the RAR0 for later reference */
-		wx_get_mac_addr(wxhw, wxhw->mac.addr);
-		wx_dbg(wxhw, "Keeping Current RAR0 Addr = %pM\n", wxhw->mac.addr);
+		wx_get_mac_addr(wx, wx->mac.addr);
+		wx_dbg(wx, "Keeping Current RAR0 Addr = %pM\n", wx->mac.addr);
 	} else {
 		/* Setup the receive address. */
-		wx_dbg(wxhw, "Overriding MAC Address in RAR[0]\n");
-		wx_dbg(wxhw, "New MAC Addr = %pM\n", wxhw->mac.addr);
+		wx_dbg(wx, "Overriding MAC Address in RAR[0]\n");
+		wx_dbg(wx, "New MAC Addr = %pM\n", wx->mac.addr);
 
-		wx_set_rar(wxhw, 0, wxhw->mac.addr, 0, WX_PSR_MAC_SWC_AD_H_AV);
+		wx_set_rar(wx, 0, wx->mac.addr, 0, WX_PSR_MAC_SWC_AD_H_AV);
 
-		if (wxhw->mac.type == wx_mac_sp) {
+		if (wx->mac.type == wx_mac_sp) {
 			/* clear VMDq pool/queue selection for RAR 0 */
-			wx_clear_vmdq(wxhw, 0, WX_CLEAR_VMDQ_ALL);
+			wx_clear_vmdq(wx, 0, WX_CLEAR_VMDQ_ALL);
 		}
 	}
 
 	/* Zero out the other receive addresses. */
-	wx_dbg(wxhw, "Clearing RAR[1-%d]\n", rar_entries - 1);
+	wx_dbg(wx, "Clearing RAR[1-%d]\n", rar_entries - 1);
 	for (i = 1; i < rar_entries; i++) {
-		wr32(wxhw, WX_PSR_MAC_SWC_IDX, i);
-		wr32(wxhw, WX_PSR_MAC_SWC_AD_L, 0);
-		wr32(wxhw, WX_PSR_MAC_SWC_AD_H, 0);
+		wr32(wx, WX_PSR_MAC_SWC_IDX, i);
+		wr32(wx, WX_PSR_MAC_SWC_AD_L, 0);
+		wr32(wx, WX_PSR_MAC_SWC_AD_H, 0);
 	}
 
 	/* Clear the MTA */
-	wxhw->addr_ctrl.mta_in_use = 0;
-	psrctl = rd32(wxhw, WX_PSR_CTL);
+	wx->addr_ctrl.mta_in_use = 0;
+	psrctl = rd32(wx, WX_PSR_CTL);
 	psrctl &= ~(WX_PSR_CTL_MO | WX_PSR_CTL_MFE);
-	psrctl |= wxhw->mac.mc_filter_type << WX_PSR_CTL_MO_SHIFT;
-	wr32(wxhw, WX_PSR_CTL, psrctl);
-	wx_dbg(wxhw, " Clearing MTA\n");
-	for (i = 0; i < wxhw->mac.mcft_size; i++)
-		wr32(wxhw, WX_PSR_MC_TBL(i), 0);
+	psrctl |= wx->mac.mc_filter_type << WX_PSR_CTL_MO_SHIFT;
+	wr32(wx, WX_PSR_CTL, psrctl);
+	wx_dbg(wx, " Clearing MTA\n");
+	for (i = 0; i < wx->mac.mcft_size; i++)
+		wr32(wx, WX_PSR_MC_TBL(i), 0);
 
-	wx_init_uta_tables(wxhw);
+	wx_init_uta_tables(wx);
 }
 EXPORT_SYMBOL(wx_init_rx_addrs);
 
-static void wx_sync_mac_table(struct wx_hw *wxhw)
+static void wx_sync_mac_table(struct wx *wx)
 {
 	int i;
 
-	for (i = 0; i < wxhw->mac.num_rar_entries; i++) {
-		if (wxhw->mac_table[i].state & WX_MAC_STATE_MODIFIED) {
-			if (wxhw->mac_table[i].state & WX_MAC_STATE_IN_USE) {
-				wx_set_rar(wxhw, i,
-					   wxhw->mac_table[i].addr,
-					   wxhw->mac_table[i].pools,
+	for (i = 0; i < wx->mac.num_rar_entries; i++) {
+		if (wx->mac_table[i].state & WX_MAC_STATE_MODIFIED) {
+			if (wx->mac_table[i].state & WX_MAC_STATE_IN_USE) {
+				wx_set_rar(wx, i,
+					   wx->mac_table[i].addr,
+					   wx->mac_table[i].pools,
 					   WX_PSR_MAC_SWC_AD_H_AV);
 			} else {
-				wx_clear_rar(wxhw, i);
+				wx_clear_rar(wx, i);
 			}
-			wxhw->mac_table[i].state &= ~(WX_MAC_STATE_MODIFIED);
+			wx->mac_table[i].state &= ~(WX_MAC_STATE_MODIFIED);
 		}
 	}
 }
 
 /* this function destroys the first RAR entry */
-void wx_mac_set_default_filter(struct wx_hw *wxhw, u8 *addr)
+void wx_mac_set_default_filter(struct wx *wx, u8 *addr)
 {
-	memcpy(&wxhw->mac_table[0].addr, addr, ETH_ALEN);
-	wxhw->mac_table[0].pools = 1ULL;
-	wxhw->mac_table[0].state = (WX_MAC_STATE_DEFAULT | WX_MAC_STATE_IN_USE);
-	wx_set_rar(wxhw, 0, wxhw->mac_table[0].addr,
-		   wxhw->mac_table[0].pools,
+	memcpy(&wx->mac_table[0].addr, addr, ETH_ALEN);
+	wx->mac_table[0].pools = 1ULL;
+	wx->mac_table[0].state = (WX_MAC_STATE_DEFAULT | WX_MAC_STATE_IN_USE);
+	wx_set_rar(wx, 0, wx->mac_table[0].addr,
+		   wx->mac_table[0].pools,
 		   WX_PSR_MAC_SWC_AD_H_AV);
 }
 EXPORT_SYMBOL(wx_mac_set_default_filter);
 
-void wx_flush_sw_mac_table(struct wx_hw *wxhw)
+void wx_flush_sw_mac_table(struct wx *wx)
 {
 	u32 i;
 
-	for (i = 0; i < wxhw->mac.num_rar_entries; i++) {
-		if (!(wxhw->mac_table[i].state & WX_MAC_STATE_IN_USE))
+	for (i = 0; i < wx->mac.num_rar_entries; i++) {
+		if (!(wx->mac_table[i].state & WX_MAC_STATE_IN_USE))
 			continue;
 
-		wxhw->mac_table[i].state |= WX_MAC_STATE_MODIFIED;
-		wxhw->mac_table[i].state &= ~WX_MAC_STATE_IN_USE;
-		memset(wxhw->mac_table[i].addr, 0, ETH_ALEN);
-		wxhw->mac_table[i].pools = 0;
+		wx->mac_table[i].state |= WX_MAC_STATE_MODIFIED;
+		wx->mac_table[i].state &= ~WX_MAC_STATE_IN_USE;
+		memset(wx->mac_table[i].addr, 0, ETH_ALEN);
+		wx->mac_table[i].pools = 0;
 	}
-	wx_sync_mac_table(wxhw);
+	wx_sync_mac_table(wx);
 }
 EXPORT_SYMBOL(wx_flush_sw_mac_table);
 
-static int wx_del_mac_filter(struct wx_hw *wxhw, u8 *addr, u16 pool)
+static int wx_del_mac_filter(struct wx *wx, u8 *addr, u16 pool)
 {
 	u32 i;
 
@@ -777,17 +777,17 @@ static int wx_del_mac_filter(struct wx_hw *wxhw, u8 *addr, u16 pool)
 		return -EINVAL;
 
 	/* search table for addr, if found, set to 0 and sync */
-	for (i = 0; i < wxhw->mac.num_rar_entries; i++) {
-		if (!ether_addr_equal(addr, wxhw->mac_table[i].addr))
+	for (i = 0; i < wx->mac.num_rar_entries; i++) {
+		if (!ether_addr_equal(addr, wx->mac_table[i].addr))
 			continue;
 
-		wxhw->mac_table[i].state |= WX_MAC_STATE_MODIFIED;
-		wxhw->mac_table[i].pools &= ~(1ULL << pool);
-		if (!wxhw->mac_table[i].pools) {
-			wxhw->mac_table[i].state &= ~WX_MAC_STATE_IN_USE;
-			memset(wxhw->mac_table[i].addr, 0, ETH_ALEN);
+		wx->mac_table[i].state |= WX_MAC_STATE_MODIFIED;
+		wx->mac_table[i].pools &= ~(1ULL << pool);
+		if (!wx->mac_table[i].pools) {
+			wx->mac_table[i].state &= ~WX_MAC_STATE_IN_USE;
+			memset(wx->mac_table[i].addr, 0, ETH_ALEN);
 		}
-		wx_sync_mac_table(wxhw);
+		wx_sync_mac_table(wx);
 		return 0;
 	}
 	return -ENOMEM;
@@ -802,7 +802,7 @@ static int wx_del_mac_filter(struct wx_hw *wxhw, u8 *addr, u16 pool)
  **/
 int wx_set_mac(struct net_device *netdev, void *p)
 {
-	struct wx_hw *wxhw = container_of(&netdev, struct wx_hw, netdev);
+	struct wx *wx = container_of(&netdev, struct wx, netdev);
 	struct sockaddr *addr = p;
 	int retval;
 
@@ -810,38 +810,38 @@ int wx_set_mac(struct net_device *netdev, void *p)
 	if (retval)
 		return retval;
 
-	wx_del_mac_filter(wxhw, wxhw->mac.addr, 0);
+	wx_del_mac_filter(wx, wx->mac.addr, 0);
 	eth_hw_addr_set(netdev, addr->sa_data);
-	memcpy(wxhw->mac.addr, addr->sa_data, netdev->addr_len);
+	memcpy(wx->mac.addr, addr->sa_data, netdev->addr_len);
 
-	wx_mac_set_default_filter(wxhw, wxhw->mac.addr);
+	wx_mac_set_default_filter(wx, wx->mac.addr);
 
 	return 0;
 }
 EXPORT_SYMBOL(wx_set_mac);
 
-void wx_disable_rx(struct wx_hw *wxhw)
+void wx_disable_rx(struct wx *wx)
 {
 	u32 pfdtxgswc;
 	u32 rxctrl;
 
-	rxctrl = rd32(wxhw, WX_RDB_PB_CTL);
+	rxctrl = rd32(wx, WX_RDB_PB_CTL);
 	if (rxctrl & WX_RDB_PB_CTL_RXEN) {
-		pfdtxgswc = rd32(wxhw, WX_PSR_CTL);
+		pfdtxgswc = rd32(wx, WX_PSR_CTL);
 		if (pfdtxgswc & WX_PSR_CTL_SW_EN) {
 			pfdtxgswc &= ~WX_PSR_CTL_SW_EN;
-			wr32(wxhw, WX_PSR_CTL, pfdtxgswc);
-			wxhw->mac.set_lben = true;
+			wr32(wx, WX_PSR_CTL, pfdtxgswc);
+			wx->mac.set_lben = true;
 		} else {
-			wxhw->mac.set_lben = false;
+			wx->mac.set_lben = false;
 		}
 		rxctrl &= ~WX_RDB_PB_CTL_RXEN;
-		wr32(wxhw, WX_RDB_PB_CTL, rxctrl);
+		wr32(wx, WX_RDB_PB_CTL, rxctrl);
 
-		if (!(((wxhw->subsystem_device_id & WX_NCSI_MASK) == WX_NCSI_SUP) ||
-		      ((wxhw->subsystem_device_id & WX_WOL_MASK) == WX_WOL_SUP))) {
+		if (!(((wx->subsystem_device_id & WX_NCSI_MASK) == WX_NCSI_SUP) ||
+		      ((wx->subsystem_device_id & WX_WOL_MASK) == WX_WOL_SUP))) {
 			/* disable mac receiver */
-			wr32m(wxhw, WX_MAC_RX_CFG,
+			wr32m(wx, WX_MAC_RX_CFG,
 			      WX_MAC_RX_CFG_RE, 0);
 		}
 	}
@@ -850,28 +850,28 @@ EXPORT_SYMBOL(wx_disable_rx);
 
 /**
  *  wx_disable_pcie_master - Disable PCI-express master access
- *  @wxhw: pointer to hardware structure
+ *  @wx: pointer to hardware structure
  *
  *  Disables PCI-Express master access and verifies there are no pending
  *  requests.
  **/
-int wx_disable_pcie_master(struct wx_hw *wxhw)
+int wx_disable_pcie_master(struct wx *wx)
 {
 	int status = 0;
 	u32 val;
 
 	/* Always set this bit to ensure any future transactions are blocked */
-	pci_clear_master(wxhw->pdev);
+	pci_clear_master(wx->pdev);
 
 	/* Exit if master requests are blocked */
-	if (!(rd32(wxhw, WX_PX_TRANSACTION_PENDING)))
+	if (!(rd32(wx, WX_PX_TRANSACTION_PENDING)))
 		return 0;
 
 	/* Poll for master request bit to clear */
 	status = read_poll_timeout(rd32, val, !val, 100, WX_PCI_MASTER_DISABLE_TIMEOUT,
-				   false, wxhw, WX_PX_TRANSACTION_PENDING);
+				   false, wx, WX_PX_TRANSACTION_PENDING);
 	if (status < 0)
-		wx_err(wxhw, "PCIe transaction pending bit did not clear.\n");
+		wx_err(wx, "PCIe transaction pending bit did not clear.\n");
 
 	return status;
 }
@@ -879,106 +879,106 @@ EXPORT_SYMBOL(wx_disable_pcie_master);
 
 /**
  *  wx_stop_adapter - Generic stop Tx/Rx units
- *  @wxhw: pointer to hardware structure
+ *  @wx: pointer to hardware structure
  *
  *  Sets the adapter_stopped flag within wx_hw struct. Clears interrupts,
  *  disables transmit and receive units. The adapter_stopped flag is used by
  *  the shared code and drivers to determine if the adapter is in a stopped
  *  state and should not touch the hardware.
  **/
-int wx_stop_adapter(struct wx_hw *wxhw)
+int wx_stop_adapter(struct wx *wx)
 {
 	u16 i;
 
 	/* Set the adapter_stopped flag so other driver functions stop touching
 	 * the hardware
 	 */
-	wxhw->adapter_stopped = true;
+	wx->adapter_stopped = true;
 
 	/* Disable the receive unit */
-	wx_disable_rx(wxhw);
+	wx_disable_rx(wx);
 
 	/* Set interrupt mask to stop interrupts from being generated */
-	wx_intr_disable(wxhw, WX_INTR_ALL);
+	wx_intr_disable(wx, WX_INTR_ALL);
 
 	/* Clear any pending interrupts, flush previous writes */
-	wr32(wxhw, WX_PX_MISC_IC, 0xffffffff);
-	wr32(wxhw, WX_BME_CTL, 0x3);
+	wr32(wx, WX_PX_MISC_IC, 0xffffffff);
+	wr32(wx, WX_BME_CTL, 0x3);
 
 	/* Disable the transmit unit.  Each queue must be disabled. */
-	for (i = 0; i < wxhw->mac.max_tx_queues; i++) {
-		wr32m(wxhw, WX_PX_TR_CFG(i),
+	for (i = 0; i < wx->mac.max_tx_queues; i++) {
+		wr32m(wx, WX_PX_TR_CFG(i),
 		      WX_PX_TR_CFG_SWFLSH | WX_PX_TR_CFG_ENABLE,
 		      WX_PX_TR_CFG_SWFLSH);
 	}
 
 	/* Disable the receive unit by stopping each queue */
-	for (i = 0; i < wxhw->mac.max_rx_queues; i++) {
-		wr32m(wxhw, WX_PX_RR_CFG(i),
+	for (i = 0; i < wx->mac.max_rx_queues; i++) {
+		wr32m(wx, WX_PX_RR_CFG(i),
 		      WX_PX_RR_CFG_RR_EN, 0);
 	}
 
 	/* flush all queues disables */
-	WX_WRITE_FLUSH(wxhw);
+	WX_WRITE_FLUSH(wx);
 
 	/* Prevent the PCI-E bus from hanging by disabling PCI-E master
 	 * access and verify no pending requests
 	 */
-	return wx_disable_pcie_master(wxhw);
+	return wx_disable_pcie_master(wx);
 }
 EXPORT_SYMBOL(wx_stop_adapter);
 
-void wx_reset_misc(struct wx_hw *wxhw)
+void wx_reset_misc(struct wx *wx)
 {
 	int i;
 
 	/* receive packets that size > 2048 */
-	wr32m(wxhw, WX_MAC_RX_CFG, WX_MAC_RX_CFG_JE, WX_MAC_RX_CFG_JE);
+	wr32m(wx, WX_MAC_RX_CFG, WX_MAC_RX_CFG_JE, WX_MAC_RX_CFG_JE);
 
 	/* clear counters on read */
-	wr32m(wxhw, WX_MMC_CONTROL,
+	wr32m(wx, WX_MMC_CONTROL,
 	      WX_MMC_CONTROL_RSTONRD, WX_MMC_CONTROL_RSTONRD);
 
-	wr32m(wxhw, WX_MAC_RX_FLOW_CTRL,
+	wr32m(wx, WX_MAC_RX_FLOW_CTRL,
 	      WX_MAC_RX_FLOW_CTRL_RFE, WX_MAC_RX_FLOW_CTRL_RFE);
 
-	wr32(wxhw, WX_MAC_PKT_FLT, WX_MAC_PKT_FLT_PR);
+	wr32(wx, WX_MAC_PKT_FLT, WX_MAC_PKT_FLT_PR);
 
-	wr32m(wxhw, WX_MIS_RST_ST,
+	wr32m(wx, WX_MIS_RST_ST,
 	      WX_MIS_RST_ST_RST_INIT, 0x1E00);
 
 	/* errata 4: initialize mng flex tbl and wakeup flex tbl*/
-	wr32(wxhw, WX_PSR_MNG_FLEX_SEL, 0);
+	wr32(wx, WX_PSR_MNG_FLEX_SEL, 0);
 	for (i = 0; i < 16; i++) {
-		wr32(wxhw, WX_PSR_MNG_FLEX_DW_L(i), 0);
-		wr32(wxhw, WX_PSR_MNG_FLEX_DW_H(i), 0);
-		wr32(wxhw, WX_PSR_MNG_FLEX_MSK(i), 0);
+		wr32(wx, WX_PSR_MNG_FLEX_DW_L(i), 0);
+		wr32(wx, WX_PSR_MNG_FLEX_DW_H(i), 0);
+		wr32(wx, WX_PSR_MNG_FLEX_MSK(i), 0);
 	}
-	wr32(wxhw, WX_PSR_LAN_FLEX_SEL, 0);
+	wr32(wx, WX_PSR_LAN_FLEX_SEL, 0);
 	for (i = 0; i < 16; i++) {
-		wr32(wxhw, WX_PSR_LAN_FLEX_DW_L(i), 0);
-		wr32(wxhw, WX_PSR_LAN_FLEX_DW_H(i), 0);
-		wr32(wxhw, WX_PSR_LAN_FLEX_MSK(i), 0);
+		wr32(wx, WX_PSR_LAN_FLEX_DW_L(i), 0);
+		wr32(wx, WX_PSR_LAN_FLEX_DW_H(i), 0);
+		wr32(wx, WX_PSR_LAN_FLEX_MSK(i), 0);
 	}
 
 	/* set pause frame dst mac addr */
-	wr32(wxhw, WX_RDB_PFCMACDAL, 0xC2000001);
-	wr32(wxhw, WX_RDB_PFCMACDAH, 0x0180);
+	wr32(wx, WX_RDB_PFCMACDAL, 0xC2000001);
+	wr32(wx, WX_RDB_PFCMACDAH, 0x0180);
 }
 EXPORT_SYMBOL(wx_reset_misc);
 
 /**
  *  wx_get_pcie_msix_counts - Gets MSI-X vector count
- *  @wxhw: pointer to hardware structure
+ *  @wx: pointer to hardware structure
  *  @msix_count: number of MSI interrupts that can be obtained
  *  @max_msix_count: number of MSI interrupts that mac need
  *
  *  Read PCIe configuration space, and get the MSI-X vector count from
  *  the capabilities table.
  **/
-int wx_get_pcie_msix_counts(struct wx_hw *wxhw, u16 *msix_count, u16 max_msix_count)
+int wx_get_pcie_msix_counts(struct wx *wx, u16 *msix_count, u16 max_msix_count)
 {
-	struct pci_dev *pdev = wxhw->pdev;
+	struct pci_dev *pdev = wx->pdev;
 	struct device *dev = &pdev->dev;
 	int pos;
 
@@ -1002,36 +1002,36 @@ int wx_get_pcie_msix_counts(struct wx_hw *wxhw, u16 *msix_count, u16 max_msix_co
 }
 EXPORT_SYMBOL(wx_get_pcie_msix_counts);
 
-int wx_sw_init(struct wx_hw *wxhw)
+int wx_sw_init(struct wx *wx)
 {
-	struct pci_dev *pdev = wxhw->pdev;
+	struct pci_dev *pdev = wx->pdev;
 	u32 ssid = 0;
 	int err = 0;
 
-	wxhw->vendor_id = pdev->vendor;
-	wxhw->device_id = pdev->device;
-	wxhw->revision_id = pdev->revision;
-	wxhw->oem_svid = pdev->subsystem_vendor;
-	wxhw->oem_ssid = pdev->subsystem_device;
-	wxhw->bus.device = PCI_SLOT(pdev->devfn);
-	wxhw->bus.func = PCI_FUNC(pdev->devfn);
-
-	if (wxhw->oem_svid == PCI_VENDOR_ID_WANGXUN) {
-		wxhw->subsystem_vendor_id = pdev->subsystem_vendor;
-		wxhw->subsystem_device_id = pdev->subsystem_device;
+	wx->vendor_id = pdev->vendor;
+	wx->device_id = pdev->device;
+	wx->revision_id = pdev->revision;
+	wx->oem_svid = pdev->subsystem_vendor;
+	wx->oem_ssid = pdev->subsystem_device;
+	wx->bus.device = PCI_SLOT(pdev->devfn);
+	wx->bus.func = PCI_FUNC(pdev->devfn);
+
+	if (wx->oem_svid == PCI_VENDOR_ID_WANGXUN) {
+		wx->subsystem_vendor_id = pdev->subsystem_vendor;
+		wx->subsystem_device_id = pdev->subsystem_device;
 	} else {
-		err = wx_flash_read_dword(wxhw, 0xfffdc, &ssid);
+		err = wx_flash_read_dword(wx, 0xfffdc, &ssid);
 		if (!err)
-			wxhw->subsystem_device_id = swab16((u16)ssid);
+			wx->subsystem_device_id = swab16((u16)ssid);
 
 		return err;
 	}
 
-	wxhw->mac_table = kcalloc(wxhw->mac.num_rar_entries,
-				  sizeof(struct wx_mac_addr),
-				  GFP_KERNEL);
-	if (!wxhw->mac_table) {
-		wx_err(wxhw, "mac_table allocation failed\n");
+	wx->mac_table = kcalloc(wx->mac.num_rar_entries,
+				sizeof(struct wx_mac_addr),
+				GFP_KERNEL);
+	if (!wx->mac_table) {
+		wx_err(wx, "mac_table allocation failed\n");
 		return -ENOMEM;
 	}
 
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.h b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
index 5ac4ff78fd72..803983546f3a 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
@@ -4,26 +4,26 @@
 #ifndef _WX_HW_H_
 #define _WX_HW_H_
 
-int wx_check_flash_load(struct wx_hw *hw, u32 check_bit);
-void wx_control_hw(struct wx_hw *wxhw, bool drv);
-int wx_mng_present(struct wx_hw *wxhw);
-int wx_host_interface_command(struct wx_hw *wxhw, u32 *buffer,
+int wx_check_flash_load(struct wx *wx, u32 check_bit);
+void wx_control_hw(struct wx *wx, bool drv);
+int wx_mng_present(struct wx *wx);
+int wx_host_interface_command(struct wx *wx, u32 *buffer,
 			      u32 length, u32 timeout, bool return_data);
-int wx_read_ee_hostif(struct wx_hw *wxhw, u16 offset, u16 *data);
-int wx_read_ee_hostif_buffer(struct wx_hw *wxhw,
+int wx_read_ee_hostif(struct wx *wx, u16 offset, u16 *data);
+int wx_read_ee_hostif_buffer(struct wx *wx,
 			     u16 offset, u16 words, u16 *data);
-int wx_reset_hostif(struct wx_hw *wxhw);
-void wx_init_eeprom_params(struct wx_hw *wxhw);
-void wx_get_mac_addr(struct wx_hw *wxhw, u8 *mac_addr);
-void wx_init_rx_addrs(struct wx_hw *wxhw);
-void wx_mac_set_default_filter(struct wx_hw *wxhw, u8 *addr);
-void wx_flush_sw_mac_table(struct wx_hw *wxhw);
+int wx_reset_hostif(struct wx *wx);
+void wx_init_eeprom_params(struct wx *wx);
+void wx_get_mac_addr(struct wx *wx, u8 *mac_addr);
+void wx_init_rx_addrs(struct wx *wx);
+void wx_mac_set_default_filter(struct wx *wx, u8 *addr);
+void wx_flush_sw_mac_table(struct wx *wx);
 int wx_set_mac(struct net_device *netdev, void *p);
-void wx_disable_rx(struct wx_hw *wxhw);
-int wx_disable_pcie_master(struct wx_hw *wxhw);
-int wx_stop_adapter(struct wx_hw *wxhw);
-void wx_reset_misc(struct wx_hw *wxhw);
-int wx_get_pcie_msix_counts(struct wx_hw *wxhw, u16 *msix_count, u16 max_msix_count);
-int wx_sw_init(struct wx_hw *wxhw);
+void wx_disable_rx(struct wx *wx);
+int wx_disable_pcie_master(struct wx *wx);
+int wx_stop_adapter(struct wx *wx);
+void wx_reset_misc(struct wx *wx);
+int wx_get_pcie_msix_counts(struct wx *wx, u16 *msix_count, u16 max_msix_count);
+int wx_sw_init(struct wx *wx);
 
 #endif /* _WX_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index af7fd112aee4..f1231a6d83c6 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -300,7 +300,7 @@ enum wx_reset_type {
 	WX_GLOBAL_RESET
 };
 
-struct wx_hw {
+struct wx {
 	u8 __iomem *hw_addr;
 	struct pci_dev *pdev;
 	struct net_device *netdev;
@@ -331,23 +331,23 @@ struct wx_hw {
 	wr32((a), (reg) + ((off) << 2), (val))
 
 static inline u32
-rd32m(struct wx_hw *wxhw, u32 reg, u32 mask)
+rd32m(struct wx *wx, u32 reg, u32 mask)
 {
 	u32 val;
 
-	val = rd32(wxhw, reg);
+	val = rd32(wx, reg);
 	return val & mask;
 }
 
 static inline void
-wr32m(struct wx_hw *wxhw, u32 reg, u32 mask, u32 field)
+wr32m(struct wx *wx, u32 reg, u32 mask, u32 field)
 {
 	u32 val;
 
-	val = rd32(wxhw, reg);
+	val = rd32(wx, reg);
 	val = ((val & ~mask) | (field & mask));
 
-	wr32(wxhw, reg, val);
+	wr32(wx, reg, val);
 }
 
 /* On some domestic CPU platforms, sometimes IO is not synchronized with
@@ -355,10 +355,10 @@ wr32m(struct wx_hw *wxhw, u32 reg, u32 mask, u32 field)
  */
 #define WX_WRITE_FLUSH(H) rd32(H, WX_MIS_PWR)
 
-#define wx_err(wxhw, fmt, arg...) \
-	dev_err(&(wxhw)->pdev->dev, fmt, ##arg)
+#define wx_err(wx, fmt, arg...) \
+	dev_err(&(wx)->pdev->dev, fmt, ##arg)
 
-#define wx_dbg(wxhw, fmt, arg...) \
-	dev_dbg(&(wxhw)->pdev->dev, fmt, ##arg)
+#define wx_dbg(wx, fmt, arg...) \
+	dev_dbg(&(wx)->pdev->dev, fmt, ##arg)
 
 #endif /* _WX_TYPE_H_ */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
index 6e06a46fe9fa..a0c978767e72 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
@@ -13,7 +13,7 @@
 int ngbe_eeprom_chksum_hostif(struct ngbe_adapter *adapter)
 {
 	struct wx_hic_read_shadow_ram buffer;
-	struct wx_hw *wxhw = &adapter->wxhw;
+	struct wx *wx = &adapter->wx;
 	int status;
 	int tmp;
 
@@ -26,12 +26,12 @@ int ngbe_eeprom_chksum_hostif(struct ngbe_adapter *adapter)
 	/* one word */
 	buffer.length = 0;
 
-	status = wx_host_interface_command(wxhw, (u32 *)&buffer, sizeof(buffer),
+	status = wx_host_interface_command(wx, (u32 *)&buffer, sizeof(buffer),
 					   WX_HI_COMMAND_TIMEOUT, false);
 
 	if (status < 0)
 		return status;
-	tmp = rd32a(wxhw, WX_MNG_MBOX, 1);
+	tmp = rd32a(wx, WX_MNG_MBOX, 1);
 	if (tmp == NGBE_FW_CMD_ST_PASS)
 		return 0;
 	return -EIO;
@@ -39,15 +39,15 @@ int ngbe_eeprom_chksum_hostif(struct ngbe_adapter *adapter)
 
 static int ngbe_reset_misc(struct ngbe_adapter *adapter)
 {
-	struct wx_hw *wxhw = &adapter->wxhw;
+	struct wx *wx = &adapter->wx;
 
-	wx_reset_misc(wxhw);
+	wx_reset_misc(wx);
 	if (adapter->mac_type == ngbe_mac_type_rgmii)
-		wr32(wxhw, NGBE_MDIO_CLAUSE_SELECT, 0xF);
+		wr32(wx, NGBE_MDIO_CLAUSE_SELECT, 0xF);
 	if (adapter->gpio_ctrl) {
 		/* gpio0 is used to power on/off control*/
-		wr32(wxhw, NGBE_GPIO_DDR, 0x1);
-		wr32(wxhw, NGBE_GPIO_DR, NGBE_GPIO_DR_0);
+		wr32(wx, NGBE_GPIO_DDR, 0x1);
+		wr32(wx, NGBE_GPIO_DR, NGBE_GPIO_DR_0);
 	}
 	return 0;
 }
@@ -62,25 +62,25 @@ static int ngbe_reset_misc(struct ngbe_adapter *adapter)
  **/
 int ngbe_reset_hw(struct ngbe_adapter *adapter)
 {
-	struct wx_hw *wxhw = &adapter->wxhw;
+	struct wx *wx = &adapter->wx;
 	int status = 0;
 	u32 reset = 0;
 
 	/* Call adapter stop to disable tx/rx and clear interrupts */
-	status = wx_stop_adapter(wxhw);
+	status = wx_stop_adapter(wx);
 	if (status != 0)
 		return status;
-	reset = WX_MIS_RST_LAN_RST(wxhw->bus.func);
-	wr32(wxhw, WX_MIS_RST, reset | rd32(wxhw, WX_MIS_RST));
+	reset = WX_MIS_RST_LAN_RST(wx->bus.func);
+	wr32(wx, WX_MIS_RST, reset | rd32(wx, WX_MIS_RST));
 	ngbe_reset_misc(adapter);
 
 	/* Store the permanent mac address */
-	wx_get_mac_addr(wxhw, wxhw->mac.perm_addr);
+	wx_get_mac_addr(wx, wx->mac.perm_addr);
 
 	/* reset num_rar_entries to 128 */
-	wxhw->mac.num_rar_entries = NGBE_RAR_ENTRIES;
-	wx_init_rx_addrs(wxhw);
-	pci_set_master(wxhw->pdev);
+	wx->mac.num_rar_entries = NGBE_RAR_ENTRIES;
+	wx_init_rx_addrs(wx);
+	pci_set_master(wx->pdev);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index 2af076489b5e..1b8cff7dccee 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -45,14 +45,14 @@ static const struct pci_device_id ngbe_pci_tbl[] = {
  **/
 static void ngbe_init_type_code(struct ngbe_adapter *adapter)
 {
-	struct wx_hw *wxhw = &adapter->wxhw;
+	struct wx *wx = &adapter->wx;
 	int wol_mask = 0, ncsi_mask = 0;
 	u16 type_mask = 0;
 
-	wxhw->mac.type = wx_mac_em;
-	type_mask = (u16)(wxhw->subsystem_device_id & NGBE_OEM_MASK);
-	ncsi_mask = wxhw->subsystem_device_id & NGBE_NCSI_MASK;
-	wol_mask = wxhw->subsystem_device_id & NGBE_WOL_MASK;
+	wx->mac.type = wx_mac_em;
+	type_mask = (u16)(wx->subsystem_device_id & NGBE_OEM_MASK);
+	ncsi_mask = wx->subsystem_device_id & NGBE_NCSI_MASK;
+	wol_mask = wx->subsystem_device_id & NGBE_WOL_MASK;
 
 	switch (type_mask) {
 	case NGBE_SUBID_M88E1512_SFP:
@@ -134,19 +134,19 @@ static inline int ngbe_init_rss_key(struct ngbe_adapter *adapter)
 static int ngbe_sw_init(struct ngbe_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
-	struct wx_hw *wxhw = &adapter->wxhw;
+	struct wx *wx = &adapter->wx;
 	u16 msix_count = 0;
 	int err = 0;
 
-	wxhw->hw_addr = adapter->io_addr;
-	wxhw->pdev = pdev;
+	wx->hw_addr = adapter->io_addr;
+	wx->pdev = pdev;
 
-	wxhw->mac.num_rar_entries = NGBE_RAR_ENTRIES;
-	wxhw->mac.max_rx_queues = NGBE_MAX_RX_QUEUES;
-	wxhw->mac.max_tx_queues = NGBE_MAX_TX_QUEUES;
+	wx->mac.num_rar_entries = NGBE_RAR_ENTRIES;
+	wx->mac.max_rx_queues = NGBE_MAX_RX_QUEUES;
+	wx->mac.max_tx_queues = NGBE_MAX_TX_QUEUES;
 
 	/* PCI config space info */
-	err = wx_sw_init(wxhw);
+	err = wx_sw_init(wx);
 	if (err < 0) {
 		netif_err(adapter, probe, adapter->netdev,
 			  "Read of internal subsystem device id failed\n");
@@ -158,10 +158,10 @@ static int ngbe_sw_init(struct ngbe_adapter *adapter)
 
 	/* Set common capability flags and settings */
 	adapter->max_q_vectors = NGBE_MAX_MSIX_VECTORS;
-	err = wx_get_pcie_msix_counts(wxhw, &msix_count, NGBE_MAX_MSIX_VECTORS);
+	err = wx_get_pcie_msix_counts(wx, &msix_count, NGBE_MAX_MSIX_VECTORS);
 	if (err)
 		dev_err(&pdev->dev, "Do not support MSI-X\n");
-	wxhw->mac.max_msix_vectors = msix_count;
+	wx->mac.max_msix_vectors = msix_count;
 
 	if (ngbe_init_rss_key(adapter))
 		return -ENOMEM;
@@ -199,9 +199,9 @@ static void ngbe_down(struct ngbe_adapter *adapter)
 static int ngbe_open(struct net_device *netdev)
 {
 	struct ngbe_adapter *adapter = netdev_priv(netdev);
-	struct wx_hw *wxhw = &adapter->wxhw;
+	struct wx *wx = &adapter->wx;
 
-	wx_control_hw(wxhw, true);
+	wx_control_hw(wx, true);
 
 	return 0;
 }
@@ -222,7 +222,7 @@ static int ngbe_close(struct net_device *netdev)
 	struct ngbe_adapter *adapter = netdev_priv(netdev);
 
 	ngbe_down(adapter);
-	wx_control_hw(&adapter->wxhw, false);
+	wx_control_hw(&adapter->wx, false);
 
 	return 0;
 }
@@ -244,7 +244,7 @@ static void ngbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 	if (netif_running(netdev))
 		ngbe_down(adapter);
 	rtnl_unlock();
-	wx_control_hw(&adapter->wxhw, false);
+	wx_control_hw(&adapter->wx, false);
 
 	pci_disable_device(pdev);
 }
@@ -287,7 +287,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 		      const struct pci_device_id __always_unused *ent)
 {
 	struct ngbe_adapter *adapter = NULL;
-	struct wx_hw *wxhw = NULL;
+	struct wx *wx = NULL;
 	struct net_device *netdev;
 	u32 e2rom_cksum_cap = 0;
 	static int func_nums;
@@ -333,8 +333,8 @@ static int ngbe_probe(struct pci_dev *pdev,
 	adapter = netdev_priv(netdev);
 	adapter->netdev = netdev;
 	adapter->pdev = pdev;
-	wxhw = &adapter->wxhw;
-	wxhw->netdev = netdev;
+	wx = &adapter->wx;
+	wx->netdev = netdev;
 	adapter->msg_enable = BIT(3) - 1;
 
 	adapter->io_addr = devm_ioremap(&pdev->dev,
@@ -356,14 +356,14 @@ static int ngbe_probe(struct pci_dev *pdev,
 		goto err_free_mac_table;
 
 	/* check if flash load is done after hw power up */
-	err = wx_check_flash_load(wxhw, NGBE_SPI_ILDR_STATUS_PERST);
+	err = wx_check_flash_load(wx, NGBE_SPI_ILDR_STATUS_PERST);
 	if (err)
 		goto err_free_mac_table;
-	err = wx_check_flash_load(wxhw, NGBE_SPI_ILDR_STATUS_PWRRST);
+	err = wx_check_flash_load(wx, NGBE_SPI_ILDR_STATUS_PWRRST);
 	if (err)
 		goto err_free_mac_table;
 
-	err = wx_mng_present(wxhw);
+	err = wx_mng_present(wx);
 	if (err) {
 		dev_err(&pdev->dev, "Management capability is not present\n");
 		goto err_free_mac_table;
@@ -375,16 +375,16 @@ static int ngbe_probe(struct pci_dev *pdev,
 		goto err_free_mac_table;
 	}
 
-	if (wxhw->bus.func == 0) {
-		wr32(wxhw, NGBE_CALSUM_CAP_STATUS, 0x0);
-		wr32(wxhw, NGBE_EEPROM_VERSION_STORE_REG, 0x0);
+	if (wx->bus.func == 0) {
+		wr32(wx, NGBE_CALSUM_CAP_STATUS, 0x0);
+		wr32(wx, NGBE_EEPROM_VERSION_STORE_REG, 0x0);
 	} else {
-		e2rom_cksum_cap = rd32(wxhw, NGBE_CALSUM_CAP_STATUS);
-		saved_ver = rd32(wxhw, NGBE_EEPROM_VERSION_STORE_REG);
+		e2rom_cksum_cap = rd32(wx, NGBE_CALSUM_CAP_STATUS);
+		saved_ver = rd32(wx, NGBE_EEPROM_VERSION_STORE_REG);
 	}
 
-	wx_init_eeprom_params(wxhw);
-	if (wxhw->bus.func == 0 || e2rom_cksum_cap == 0) {
+	wx_init_eeprom_params(wx);
+	if (wx->bus.func == 0 || e2rom_cksum_cap == 0) {
 		/* make sure the EEPROM is ready */
 		err = ngbe_eeprom_chksum_hostif(adapter);
 		if (err) {
@@ -399,7 +399,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 		adapter->wol = NGBE_PSR_WKUP_CTL_MAG;
 
 	adapter->wol_enabled = !!(adapter->wol);
-	wr32(wxhw, NGBE_PSR_WKUP_CTL, adapter->wol);
+	wr32(wx, NGBE_PSR_WKUP_CTL, adapter->wol);
 
 	device_set_wakeup_enable(&pdev->dev, adapter->wol);
 
@@ -409,19 +409,19 @@ static int ngbe_probe(struct pci_dev *pdev,
 	if (saved_ver) {
 		etrack_id = saved_ver;
 	} else {
-		wx_read_ee_hostif(wxhw,
-				  wxhw->eeprom.sw_region_offset + NGBE_EEPROM_VERSION_H,
+		wx_read_ee_hostif(wx,
+				  wx->eeprom.sw_region_offset + NGBE_EEPROM_VERSION_H,
 				  &e2rom_ver);
 		etrack_id = e2rom_ver << 16;
-		wx_read_ee_hostif(wxhw,
-				  wxhw->eeprom.sw_region_offset + NGBE_EEPROM_VERSION_L,
+		wx_read_ee_hostif(wx,
+				  wx->eeprom.sw_region_offset + NGBE_EEPROM_VERSION_L,
 				  &e2rom_ver);
 		etrack_id |= e2rom_ver;
-		wr32(wxhw, NGBE_EEPROM_VERSION_STORE_REG, etrack_id);
+		wr32(wx, NGBE_EEPROM_VERSION_STORE_REG, etrack_id);
 	}
 
-	eth_hw_addr_set(netdev, wxhw->mac.perm_addr);
-	wx_mac_set_default_filter(wxhw, wxhw->mac.perm_addr);
+	eth_hw_addr_set(netdev, wx->mac.perm_addr);
+	wx_mac_set_default_filter(wx, wx->mac.perm_addr);
 
 	err = register_netdev(netdev);
 	if (err)
@@ -437,9 +437,9 @@ static int ngbe_probe(struct pci_dev *pdev,
 	return 0;
 
 err_register:
-	wx_control_hw(wxhw, false);
+	wx_control_hw(wx, false);
 err_free_mac_table:
-	kfree(wxhw->mac_table);
+	kfree(wx->mac_table);
 err_pci_release_regions:
 	pci_disable_pcie_error_reporting(pdev);
 	pci_release_selected_regions(pdev,
@@ -461,7 +461,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 static void ngbe_remove(struct pci_dev *pdev)
 {
 	struct ngbe_adapter *adapter = pci_get_drvdata(pdev);
-	struct wx_hw *wxhw = &adapter->wxhw;
+	struct wx *wx = &adapter->wx;
 	struct net_device *netdev;
 
 	netdev = adapter->netdev;
@@ -469,7 +469,7 @@ static void ngbe_remove(struct pci_dev *pdev)
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 
-	kfree(wxhw->mac_table);
+	kfree(wx->mac_table);
 	pci_disable_pcie_error_reporting(pdev);
 
 	pci_disable_device(pdev);
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
index 4b6c5006c0c6..a8042524dfa1 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
@@ -154,7 +154,7 @@ struct ngbe_adapter {
 	struct net_device *netdev;
 	struct pci_dev *pdev;
 
-	struct wx_hw wxhw;
+	struct wx wx;
 	struct ngbe_phy_info phy;
 	enum ngbe_mac_type mac_type;
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index a657b579447c..c74c3aaf9c64 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -15,64 +15,64 @@
 
 /**
  *  txgbe_init_thermal_sensor_thresh - Inits thermal sensor thresholds
- *  @wxhw: pointer to hardware structure
+ *  @wx: pointer to hardware structure
  *
  *  Inits the thermal sensor thresholds according to the NVM map
  *  and save off the threshold and location values into mac.thermal_sensor_data
  **/
-static void txgbe_init_thermal_sensor_thresh(struct wx_hw *wxhw)
+static void txgbe_init_thermal_sensor_thresh(struct wx *wx)
 {
-	struct wx_thermal_sensor_data *data = &wxhw->mac.sensor;
+	struct wx_thermal_sensor_data *data = &wx->mac.sensor;
 
 	memset(data, 0, sizeof(struct wx_thermal_sensor_data));
 
 	/* Only support thermal sensors attached to SP physical port 0 */
-	if (wxhw->bus.func)
+	if (wx->bus.func)
 		return;
 
-	wr32(wxhw, TXGBE_TS_CTL, TXGBE_TS_CTL_EVAL_MD);
+	wr32(wx, TXGBE_TS_CTL, TXGBE_TS_CTL_EVAL_MD);
 
-	wr32(wxhw, WX_TS_INT_EN,
+	wr32(wx, WX_TS_INT_EN,
 	     WX_TS_INT_EN_ALARM_INT_EN | WX_TS_INT_EN_DALARM_INT_EN);
-	wr32(wxhw, WX_TS_EN, WX_TS_EN_ENA);
+	wr32(wx, WX_TS_EN, WX_TS_EN_ENA);
 
 	data->alarm_thresh = 100;
-	wr32(wxhw, WX_TS_ALARM_THRE, 677);
+	wr32(wx, WX_TS_ALARM_THRE, 677);
 	data->dalarm_thresh = 90;
-	wr32(wxhw, WX_TS_DALARM_THRE, 614);
+	wr32(wx, WX_TS_DALARM_THRE, 614);
 }
 
 /**
  *  txgbe_read_pba_string - Reads part number string from EEPROM
- *  @wxhw: pointer to hardware structure
+ *  @wx: pointer to hardware structure
  *  @pba_num: stores the part number string from the EEPROM
  *  @pba_num_size: part number string buffer length
  *
  *  Reads the part number string from the EEPROM.
  **/
-int txgbe_read_pba_string(struct wx_hw *wxhw, u8 *pba_num, u32 pba_num_size)
+int txgbe_read_pba_string(struct wx *wx, u8 *pba_num, u32 pba_num_size)
 {
 	u16 pba_ptr, offset, length, data;
 	int ret_val;
 
 	if (!pba_num) {
-		wx_err(wxhw, "PBA string buffer was null\n");
+		wx_err(wx, "PBA string buffer was null\n");
 		return -EINVAL;
 	}
 
-	ret_val = wx_read_ee_hostif(wxhw,
-				    wxhw->eeprom.sw_region_offset + TXGBE_PBANUM0_PTR,
+	ret_val = wx_read_ee_hostif(wx,
+				    wx->eeprom.sw_region_offset + TXGBE_PBANUM0_PTR,
 				    &data);
 	if (ret_val != 0) {
-		wx_err(wxhw, "NVM Read Error\n");
+		wx_err(wx, "NVM Read Error\n");
 		return ret_val;
 	}
 
-	ret_val = wx_read_ee_hostif(wxhw,
-				    wxhw->eeprom.sw_region_offset + TXGBE_PBANUM1_PTR,
+	ret_val = wx_read_ee_hostif(wx,
+				    wx->eeprom.sw_region_offset + TXGBE_PBANUM1_PTR,
 				    &pba_ptr);
 	if (ret_val != 0) {
-		wx_err(wxhw, "NVM Read Error\n");
+		wx_err(wx, "NVM Read Error\n");
 		return ret_val;
 	}
 
@@ -81,11 +81,11 @@ int txgbe_read_pba_string(struct wx_hw *wxhw, u8 *pba_num, u32 pba_num_size)
 	 * and we can decode it into an ascii string
 	 */
 	if (data != TXGBE_PBANUM_PTR_GUARD) {
-		wx_err(wxhw, "NVM PBA number is not stored as string\n");
+		wx_err(wx, "NVM PBA number is not stored as string\n");
 
 		/* we will need 11 characters to store the PBA */
 		if (pba_num_size < 11) {
-			wx_err(wxhw, "PBA string buffer too small\n");
+			wx_err(wx, "PBA string buffer too small\n");
 			return -ENOMEM;
 		}
 
@@ -115,20 +115,20 @@ int txgbe_read_pba_string(struct wx_hw *wxhw, u8 *pba_num, u32 pba_num_size)
 		return 0;
 	}
 
-	ret_val = wx_read_ee_hostif(wxhw, pba_ptr, &length);
+	ret_val = wx_read_ee_hostif(wx, pba_ptr, &length);
 	if (ret_val != 0) {
-		wx_err(wxhw, "NVM Read Error\n");
+		wx_err(wx, "NVM Read Error\n");
 		return ret_val;
 	}
 
 	if (length == 0xFFFF || length == 0) {
-		wx_err(wxhw, "NVM PBA number section invalid length\n");
+		wx_err(wx, "NVM PBA number section invalid length\n");
 		return -EINVAL;
 	}
 
 	/* check if pba_num buffer is big enough */
 	if (pba_num_size  < (((u32)length * 2) - 1)) {
-		wx_err(wxhw, "PBA string buffer too small\n");
+		wx_err(wx, "PBA string buffer too small\n");
 		return -ENOMEM;
 	}
 
@@ -137,9 +137,9 @@ int txgbe_read_pba_string(struct wx_hw *wxhw, u8 *pba_num, u32 pba_num_size)
 	length--;
 
 	for (offset = 0; offset < length; offset++) {
-		ret_val = wx_read_ee_hostif(wxhw, pba_ptr + offset, &data);
+		ret_val = wx_read_ee_hostif(wx, pba_ptr + offset, &data);
 		if (ret_val != 0) {
-			wx_err(wxhw, "NVM Read Error\n");
+			wx_err(wx, "NVM Read Error\n");
 			return ret_val;
 		}
 		pba_num[offset * 2] = (u8)(data >> 8);
@@ -152,12 +152,12 @@ int txgbe_read_pba_string(struct wx_hw *wxhw, u8 *pba_num, u32 pba_num_size)
 
 /**
  *  txgbe_calc_eeprom_checksum - Calculates and returns the checksum
- *  @wxhw: pointer to hardware structure
+ *  @wx: pointer to hardware structure
  *  @checksum: pointer to cheksum
  *
  *  Returns a negative error code on error
  **/
-static int txgbe_calc_eeprom_checksum(struct wx_hw *wxhw, u16 *checksum)
+static int txgbe_calc_eeprom_checksum(struct wx *wx, u16 *checksum)
 {
 	u16 *eeprom_ptrs = NULL;
 	u32 buffer_size = 0;
@@ -166,7 +166,7 @@ static int txgbe_calc_eeprom_checksum(struct wx_hw *wxhw, u16 *checksum)
 	int status;
 	u16 i;
 
-	wx_init_eeprom_params(wxhw);
+	wx_init_eeprom_params(wx);
 
 	if (!buffer) {
 		eeprom_ptrs = kvmalloc_array(TXGBE_EEPROM_LAST_WORD, sizeof(u16),
@@ -174,11 +174,11 @@ static int txgbe_calc_eeprom_checksum(struct wx_hw *wxhw, u16 *checksum)
 		if (!eeprom_ptrs)
 			return -ENOMEM;
 		/* Read pointer area */
-		status = wx_read_ee_hostif_buffer(wxhw, 0,
+		status = wx_read_ee_hostif_buffer(wx, 0,
 						  TXGBE_EEPROM_LAST_WORD,
 						  eeprom_ptrs);
 		if (status != 0) {
-			wx_err(wxhw, "Failed to read EEPROM image\n");
+			wx_err(wx, "Failed to read EEPROM image\n");
 			kvfree(eeprom_ptrs);
 			return status;
 		}
@@ -190,7 +190,7 @@ static int txgbe_calc_eeprom_checksum(struct wx_hw *wxhw, u16 *checksum)
 	}
 
 	for (i = 0; i < TXGBE_EEPROM_LAST_WORD; i++)
-		if (i != wxhw->eeprom.sw_region_offset + TXGBE_EEPROM_CHECKSUM)
+		if (i != wx->eeprom.sw_region_offset + TXGBE_EEPROM_CHECKSUM)
 			*checksum += local_buffer[i];
 
 	if (eeprom_ptrs)
@@ -206,13 +206,13 @@ static int txgbe_calc_eeprom_checksum(struct wx_hw *wxhw, u16 *checksum)
 
 /**
  *  txgbe_validate_eeprom_checksum - Validate EEPROM checksum
- *  @wxhw: pointer to hardware structure
+ *  @wx: pointer to hardware structure
  *  @checksum_val: calculated checksum
  *
  *  Performs checksum calculation and validates the EEPROM checksum.  If the
  *  caller does not need checksum_val, the value can be NULL.
  **/
-int txgbe_validate_eeprom_checksum(struct wx_hw *wxhw, u16 *checksum_val)
+int txgbe_validate_eeprom_checksum(struct wx *wx, u16 *checksum_val)
 {
 	u16 read_checksum = 0;
 	u16 checksum;
@@ -222,18 +222,18 @@ int txgbe_validate_eeprom_checksum(struct wx_hw *wxhw, u16 *checksum_val)
 	 * not continue or we could be in for a very long wait while every
 	 * EEPROM read fails
 	 */
-	status = wx_read_ee_hostif(wxhw, 0, &checksum);
+	status = wx_read_ee_hostif(wx, 0, &checksum);
 	if (status) {
-		wx_err(wxhw, "EEPROM read failed\n");
+		wx_err(wx, "EEPROM read failed\n");
 		return status;
 	}
 
 	checksum = 0;
-	status = txgbe_calc_eeprom_checksum(wxhw, &checksum);
+	status = txgbe_calc_eeprom_checksum(wx, &checksum);
 	if (status != 0)
 		return status;
 
-	status = wx_read_ee_hostif(wxhw, wxhw->eeprom.sw_region_offset +
+	status = wx_read_ee_hostif(wx, wx->eeprom.sw_region_offset +
 				   TXGBE_EEPROM_CHECKSUM, &read_checksum);
 	if (status != 0)
 		return status;
@@ -243,7 +243,7 @@ int txgbe_validate_eeprom_checksum(struct wx_hw *wxhw, u16 *checksum_val)
 	 */
 	if (read_checksum != checksum) {
 		status = -EIO;
-		wx_err(wxhw, "Invalid EEPROM checksum\n");
+		wx_err(wx, "Invalid EEPROM checksum\n");
 	}
 
 	/* If the user cares, return the calculated checksum */
@@ -255,10 +255,10 @@ int txgbe_validate_eeprom_checksum(struct wx_hw *wxhw, u16 *checksum_val)
 
 static void txgbe_reset_misc(struct txgbe_adapter *adapter)
 {
-	struct wx_hw *wxhw = &adapter->wxhw;
+	struct wx *wx = &adapter->wx;
 
-	wx_reset_misc(wxhw);
-	txgbe_init_thermal_sensor_thresh(wxhw);
+	wx_reset_misc(wx);
+	txgbe_init_thermal_sensor_thresh(wx);
 }
 
 /**
@@ -271,37 +271,37 @@ static void txgbe_reset_misc(struct txgbe_adapter *adapter)
  **/
 int txgbe_reset_hw(struct txgbe_adapter *adapter)
 {
-	struct wx_hw *wxhw = &adapter->wxhw;
+	struct wx *wx = &adapter->wx;
 	int status;
 
 	/* Call adapter stop to disable tx/rx and clear interrupts */
-	status = wx_stop_adapter(wxhw);
+	status = wx_stop_adapter(wx);
 	if (status != 0)
 		return status;
 
-	if (!(((wxhw->subsystem_device_id & WX_NCSI_MASK) == WX_NCSI_SUP) ||
-	      ((wxhw->subsystem_device_id & WX_WOL_MASK) == WX_WOL_SUP)))
-		wx_reset_hostif(wxhw);
+	if (!(((wx->subsystem_device_id & WX_NCSI_MASK) == WX_NCSI_SUP) ||
+	      ((wx->subsystem_device_id & WX_WOL_MASK) == WX_WOL_SUP)))
+		wx_reset_hostif(wx);
 
 	usleep_range(10, 100);
 
-	status = wx_check_flash_load(wxhw, TXGBE_SPI_ILDR_STATUS_LAN_SW_RST(wxhw->bus.func));
+	status = wx_check_flash_load(wx, TXGBE_SPI_ILDR_STATUS_LAN_SW_RST(wx->bus.func));
 	if (status != 0)
 		return status;
 
 	txgbe_reset_misc(adapter);
 
 	/* Store the permanent mac address */
-	wx_get_mac_addr(wxhw, wxhw->mac.perm_addr);
+	wx_get_mac_addr(wx, wx->mac.perm_addr);
 
 	/* Store MAC address from RAR0, clear receive address registers, and
 	 * clear the multicast table.  Also reset num_rar_entries to 128,
 	 * since we modify this value when programming the SAN MAC address.
 	 */
-	wxhw->mac.num_rar_entries = TXGBE_SP_RAR_ENTRIES;
-	wx_init_rx_addrs(wxhw);
+	wx->mac.num_rar_entries = TXGBE_SP_RAR_ENTRIES;
+	wx_init_rx_addrs(wx);
 
-	pci_set_master(wxhw->pdev);
+	pci_set_master(wx->pdev);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index bd0cfb22338c..775272642397 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -4,8 +4,8 @@
 #ifndef _TXGBE_HW_H_
 #define _TXGBE_HW_H_
 
-int txgbe_read_pba_string(struct wx_hw *wxhw, u8 *pba_num, u32 pba_num_size);
-int txgbe_validate_eeprom_checksum(struct wx_hw *wxhw, u16 *checksum_val);
+int txgbe_read_pba_string(struct wx *wx, u8 *pba_num, u32 pba_num_size);
+int txgbe_validate_eeprom_checksum(struct wx *wx, u16 *checksum_val);
 int txgbe_reset_hw(struct txgbe_adapter *adapter);
 
 #endif /* _TXGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 55ddb91e1886..85696bde1f43 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -74,15 +74,15 @@ static int txgbe_enumerate_functions(struct txgbe_adapter *adapter)
 
 static void txgbe_up_complete(struct txgbe_adapter *adapter)
 {
-	struct wx_hw *wxhw = &adapter->wxhw;
+	struct wx *wx = &adapter->wx;
 
-	wx_control_hw(wxhw, true);
+	wx_control_hw(wx, true);
 }
 
 static void txgbe_reset(struct txgbe_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
-	struct wx_hw *wxhw = &adapter->wxhw;
+	struct wx *wx = &adapter->wx;
 	u8 old_addr[ETH_ALEN];
 	int err;
 
@@ -91,38 +91,38 @@ static void txgbe_reset(struct txgbe_adapter *adapter)
 		dev_err(&adapter->pdev->dev, "Hardware Error: %d\n", err);
 
 	/* do not flush user set addresses */
-	memcpy(old_addr, &wxhw->mac_table[0].addr, netdev->addr_len);
-	wx_flush_sw_mac_table(wxhw);
-	wx_mac_set_default_filter(wxhw, old_addr);
+	memcpy(old_addr, &wx->mac_table[0].addr, netdev->addr_len);
+	wx_flush_sw_mac_table(wx);
+	wx_mac_set_default_filter(wx, old_addr);
 }
 
 static void txgbe_disable_device(struct txgbe_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
-	struct wx_hw *wxhw = &adapter->wxhw;
+	struct wx *wx = &adapter->wx;
 
-	wx_disable_pcie_master(wxhw);
+	wx_disable_pcie_master(wx);
 	/* disable receives */
-	wx_disable_rx(wxhw);
+	wx_disable_rx(wx);
 
 	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
-	if (wxhw->bus.func < 2)
-		wr32m(wxhw, TXGBE_MIS_PRB_CTL, TXGBE_MIS_PRB_CTL_LAN_UP(wxhw->bus.func), 0);
+	if (wx->bus.func < 2)
+		wr32m(wx, TXGBE_MIS_PRB_CTL, TXGBE_MIS_PRB_CTL_LAN_UP(wx->bus.func), 0);
 	else
 		dev_err(&adapter->pdev->dev,
 			"%s: invalid bus lan id %d\n",
-			__func__, wxhw->bus.func);
+			__func__, wx->bus.func);
 
-	if (!(((wxhw->subsystem_device_id & WX_NCSI_MASK) == WX_NCSI_SUP) ||
-	      ((wxhw->subsystem_device_id & WX_WOL_MASK) == WX_WOL_SUP))) {
+	if (!(((wx->subsystem_device_id & WX_NCSI_MASK) == WX_NCSI_SUP) ||
+	      ((wx->subsystem_device_id & WX_WOL_MASK) == WX_WOL_SUP))) {
 		/* disable mac transmiter */
-		wr32m(wxhw, WX_MAC_TX_CFG, WX_MAC_TX_CFG_TE, 0);
+		wr32m(wx, WX_MAC_TX_CFG, WX_MAC_TX_CFG_TE, 0);
 	}
 
 	/* Disable the Tx DMA engine */
-	wr32m(wxhw, WX_TDM_CTL, WX_TDM_CTL_TE, 0);
+	wr32m(wx, WX_TDM_CTL, WX_TDM_CTL_TE, 0);
 }
 
 static void txgbe_down(struct txgbe_adapter *adapter)
@@ -138,32 +138,32 @@ static void txgbe_down(struct txgbe_adapter *adapter)
 static int txgbe_sw_init(struct txgbe_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
-	struct wx_hw *wxhw = &adapter->wxhw;
+	struct wx *wx = &adapter->wx;
 	int err;
 
-	wxhw->hw_addr = adapter->io_addr;
-	wxhw->pdev = pdev;
+	wx->hw_addr = adapter->io_addr;
+	wx->pdev = pdev;
 
-	wxhw->mac.num_rar_entries = TXGBE_SP_RAR_ENTRIES;
-	wxhw->mac.max_tx_queues = TXGBE_SP_MAX_TX_QUEUES;
-	wxhw->mac.max_rx_queues = TXGBE_SP_MAX_RX_QUEUES;
-	wxhw->mac.mcft_size = TXGBE_SP_MC_TBL_SIZE;
+	wx->mac.num_rar_entries = TXGBE_SP_RAR_ENTRIES;
+	wx->mac.max_tx_queues = TXGBE_SP_MAX_TX_QUEUES;
+	wx->mac.max_rx_queues = TXGBE_SP_MAX_RX_QUEUES;
+	wx->mac.mcft_size = TXGBE_SP_MC_TBL_SIZE;
 
 	/* PCI config space info */
-	err = wx_sw_init(wxhw);
+	err = wx_sw_init(wx);
 	if (err < 0) {
 		netif_err(adapter, probe, adapter->netdev,
 			  "read of internal subsystem device id failed\n");
 		return err;
 	}
 
-	switch (wxhw->device_id) {
+	switch (wx->device_id) {
 	case TXGBE_DEV_ID_SP1000:
 	case TXGBE_DEV_ID_WX1820:
-		wxhw->mac.type = wx_mac_sp;
+		wx->mac.type = wx_mac_sp;
 		break;
 	default:
-		wxhw->mac.type = wx_mac_unknown;
+		wx->mac.type = wx_mac_unknown;
 		break;
 	}
 
@@ -216,7 +216,7 @@ static int txgbe_close(struct net_device *netdev)
 	struct txgbe_adapter *adapter = netdev_priv(netdev);
 
 	txgbe_down(adapter);
-	wx_control_hw(&adapter->wxhw, false);
+	wx_control_hw(&adapter->wx, false);
 
 	return 0;
 }
@@ -225,7 +225,7 @@ static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 {
 	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev = adapter->netdev;
-	struct wx_hw *wxhw = &adapter->wxhw;
+	struct wx *wx = &adapter->wx;
 
 	netif_device_detach(netdev);
 
@@ -234,7 +234,7 @@ static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 		txgbe_close_suspend(adapter);
 	rtnl_unlock();
 
-	wx_control_hw(wxhw, false);
+	wx_control_hw(wx, false);
 
 	pci_disable_device(pdev);
 }
@@ -280,7 +280,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 		       const struct pci_device_id __always_unused *ent)
 {
 	struct txgbe_adapter *adapter = NULL;
-	struct wx_hw *wxhw = NULL;
+	struct wx *wx = NULL;
 	struct net_device *netdev;
 	int err, expected_gts;
 
@@ -327,8 +327,8 @@ static int txgbe_probe(struct pci_dev *pdev,
 	adapter = netdev_priv(netdev);
 	adapter->netdev = netdev;
 	adapter->pdev = pdev;
-	wxhw = &adapter->wxhw;
-	wxhw->netdev = netdev;
+	wx = &adapter->wx;
+	wx->netdev = netdev;
 	adapter->msg_enable = (1 << DEFAULT_DEBUG_LEVEL_SHIFT) - 1;
 
 	adapter->io_addr = devm_ioremap(&pdev->dev,
@@ -347,14 +347,14 @@ static int txgbe_probe(struct pci_dev *pdev,
 		goto err_free_mac_table;
 
 	/* check if flash load is done after hw power up */
-	err = wx_check_flash_load(wxhw, TXGBE_SPI_ILDR_STATUS_PERST);
+	err = wx_check_flash_load(wx, TXGBE_SPI_ILDR_STATUS_PERST);
 	if (err)
 		goto err_free_mac_table;
-	err = wx_check_flash_load(wxhw, TXGBE_SPI_ILDR_STATUS_PWRRST);
+	err = wx_check_flash_load(wx, TXGBE_SPI_ILDR_STATUS_PWRRST);
 	if (err)
 		goto err_free_mac_table;
 
-	err = wx_mng_present(wxhw);
+	err = wx_mng_present(wx);
 	if (err) {
 		dev_err(&pdev->dev, "Management capability is not present\n");
 		goto err_free_mac_table;
@@ -369,36 +369,36 @@ static int txgbe_probe(struct pci_dev *pdev,
 	netdev->features |= NETIF_F_HIGHDMA;
 
 	/* make sure the EEPROM is good */
-	err = txgbe_validate_eeprom_checksum(wxhw, NULL);
+	err = txgbe_validate_eeprom_checksum(wx, NULL);
 	if (err != 0) {
 		dev_err(&pdev->dev, "The EEPROM Checksum Is Not Valid\n");
-		wr32(wxhw, WX_MIS_RST, WX_MIS_RST_SW_RST);
+		wr32(wx, WX_MIS_RST, WX_MIS_RST_SW_RST);
 		err = -EIO;
 		goto err_free_mac_table;
 	}
 
-	eth_hw_addr_set(netdev, wxhw->mac.perm_addr);
-	wx_mac_set_default_filter(wxhw, wxhw->mac.perm_addr);
+	eth_hw_addr_set(netdev, wx->mac.perm_addr);
+	wx_mac_set_default_filter(wx, wx->mac.perm_addr);
 
 	/* Save off EEPROM version number and Option Rom version which
 	 * together make a unique identify for the eeprom
 	 */
-	wx_read_ee_hostif(wxhw,
-			  wxhw->eeprom.sw_region_offset + TXGBE_EEPROM_VERSION_H,
+	wx_read_ee_hostif(wx,
+			  wx->eeprom.sw_region_offset + TXGBE_EEPROM_VERSION_H,
 			  &eeprom_verh);
-	wx_read_ee_hostif(wxhw,
-			  wxhw->eeprom.sw_region_offset + TXGBE_EEPROM_VERSION_L,
+	wx_read_ee_hostif(wx,
+			  wx->eeprom.sw_region_offset + TXGBE_EEPROM_VERSION_L,
 			  &eeprom_verl);
 	etrack_id = (eeprom_verh << 16) | eeprom_verl;
 
-	wx_read_ee_hostif(wxhw,
-			  wxhw->eeprom.sw_region_offset + TXGBE_ISCSI_BOOT_CONFIG,
+	wx_read_ee_hostif(wx,
+			  wx->eeprom.sw_region_offset + TXGBE_ISCSI_BOOT_CONFIG,
 			  &offset);
 
 	/* Make sure offset to SCSI block is valid */
 	if (!(offset == 0x0) && !(offset == 0xffff)) {
-		wx_read_ee_hostif(wxhw, offset + 0x84, &eeprom_cfg_blkh);
-		wx_read_ee_hostif(wxhw, offset + 0x83, &eeprom_cfg_blkl);
+		wx_read_ee_hostif(wx, offset + 0x84, &eeprom_cfg_blkh);
+		wx_read_ee_hostif(wx, offset + 0x83, &eeprom_cfg_blkl);
 
 		/* Only display Option Rom if exist */
 		if (eeprom_cfg_blkl && eeprom_cfg_blkh) {
@@ -439,7 +439,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 		dev_warn(&pdev->dev, "Failed to enumerate PF devices.\n");
 
 	/* First try to read PBA as a string */
-	err = txgbe_read_pba_string(wxhw, part_str, TXGBE_PBANUM_LENGTH);
+	err = txgbe_read_pba_string(wx, part_str, TXGBE_PBANUM_LENGTH);
 	if (err)
 		strncpy(part_str, "Unknown", TXGBE_PBANUM_LENGTH);
 
@@ -448,9 +448,9 @@ static int txgbe_probe(struct pci_dev *pdev,
 	return 0;
 
 err_release_hw:
-	wx_control_hw(wxhw, false);
+	wx_control_hw(wx, false);
 err_free_mac_table:
-	kfree(wxhw->mac_table);
+	kfree(wx->mac_table);
 err_pci_release_regions:
 	pci_disable_pcie_error_reporting(pdev);
 	pci_release_selected_regions(pdev,
@@ -480,7 +480,7 @@ static void txgbe_remove(struct pci_dev *pdev)
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 
-	kfree(adapter->wxhw.mac_table);
+	kfree(adapter->wx.mac_table);
 
 	pci_disable_pcie_error_reporting(pdev);
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index ec8238ef234d..7f7c139c6c94 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -83,7 +83,7 @@ struct txgbe_adapter {
 	/* OS defined structs */
 	struct net_device *netdev;
 	struct pci_dev *pdev;
-	struct wx_hw wxhw;
+	struct wx wx;
 	u16 msg_enable;
 
 	char eeprom_id[32];
-- 
2.27.0

