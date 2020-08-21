Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579A124CEBC
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgHUHQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727924AbgHUHQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:16:51 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D114C061385
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:16:50 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id p14so841901wmg.1
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N1bhLDUXvtdeSm6PSIZz1clgOfaqp/a7uehQHo3mKwQ=;
        b=dOF9eX+cnBkt+vblkLaKLQ/ySdyNM/hFjTCSdfr/3tqGDHs4c/zOLLc8vSEu3tTJUs
         AoKyTdkdnlSI/xbG5tn43nOiBPISP3JJYLpsk91k/VXVc92S/q/qQYUJBcWlgJY+55QD
         JGsieiDnJidmB+ZgJMm91qIiYZbRJ5JB0VQNP+KG5iIDhQw0czDMEZbYZAVoGGAqr/+4
         HfBc3mzl0WE/BRZAMG0KY3ER7la1IwXnNa8ZCXXpi3unBeXUxLDuxzwcxxvj8B+zTwfx
         zIznuYZGCKOTBopg/JGNVr0SjfTt0GDTOjaO4sX+9gcWKRRfNRyRvMVnRvzp/Q6/zj5g
         cyjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N1bhLDUXvtdeSm6PSIZz1clgOfaqp/a7uehQHo3mKwQ=;
        b=XN0Z5TSidj1GFMQghwB1V5jkwMjc7qaA24ADLyGDq6ZQx2rbnhCGm1qp1pq3JCJ7si
         NNeqDq7YCLyImNKo4db/j0R5IdysrEC1KUzIKfukEGtPW0peVX9IbOmATM/Amvj6Xx/b
         +uZg9k2QeNiYq54akp7G3ALiarRKBG8/+lKcySM6RYwivxjJnFczcrPCsSl1A32AK1sr
         i1YCyZYJek9V9Z4YkpVHvPrp2Vvjwd5JYkNhYfsJylSIfsAx0UIN0eWx9bbG0AuSS/d0
         iERBZejB1ZSBt+NjvLi6+EDnhxZXyJ4yzESGqPQtQrbJy2U0sOyXWnIuO5avegjiPH4F
         GiVA==
X-Gm-Message-State: AOAM533f9ESzyjh+4imb2+op8ekw0NBEETc9ey85YBJ1Qn7rAhY5vPtZ
        rSK3Kll5MOiQwp3ovLTw05N1+rkzmDZMYg==
X-Google-Smtp-Source: ABdhPJxZYaC1ZRNMbmuMi7BrebhQsaNHHC4tTiAhACOZQr79nCv1VpFqCqQI+FCvkQQ0bxFs/4O4Nw==
X-Received: by 2002:a7b:c765:: with SMTP id x5mr1633608wmk.14.1597994209007;
        Fri, 21 Aug 2020 00:16:49 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:16:48 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
Subject: [PATCH 01/32] wireless: marvell: mwifiex: sdio: Move 'static const struct's into their own header file
Date:   Fri, 21 Aug 2020 08:16:13 +0100
Message-Id: <20200821071644.109970-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only include these tables in the 1 source file they are used.

Fixes hundreds of W=1 warnings!

Fixes the following W=1 kernel build warning(s):

 In file included from drivers/net/wireless/marvell/mwifiex/main.h:59,
 from drivers/net/wireless/marvell/mwifiex/main.c:22:
 drivers/net/wireless/marvell/mwifiex/sdio.h:705:41: warning: ‘mwifiex_sdio_sd8801’ defined but not used [-Wunused-const-variable=]
 705 | static const struct mwifiex_sdio_device mwifiex_sdio_sd8801 = {
 | ^~~~~~~~~~~~~~~~~~~

 NB: There were 100's of these - snipped for brevity.

Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
Cc: Xinming Hu <huxinming820@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../wireless/marvell/mwifiex/sdio-tables.h    | 451 ++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/sdio.c   |   1 +
 drivers/net/wireless/marvell/mwifiex/sdio.h   | 427 -----------------
 3 files changed, 452 insertions(+), 427 deletions(-)
 create mode 100644 drivers/net/wireless/marvell/mwifiex/sdio-tables.h

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio-tables.h b/drivers/net/wireless/marvell/mwifiex/sdio-tables.h
new file mode 100644
index 0000000000000..e40425965a84b
--- /dev/null
+++ b/drivers/net/wireless/marvell/mwifiex/sdio-tables.h
@@ -0,0 +1,451 @@
+/*
+ * NXP Wireless LAN device driver: SDIO specific definitions
+ *
+ * Copyright 2011-2020 NXP
+ *
+ * This software file (the "File") is distributed by NXP
+ * under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#ifndef	_MWIFIEX_SDIO_TABLES_H
+#define	_MWIFIEX_SDIO_TABLES_H
+
+#include "sdio.h"
+
+static const struct mwifiex_sdio_card_reg mwifiex_reg_sd87xx = {
+	.start_rd_port = 1,
+	.start_wr_port = 1,
+	.base_0_reg = 0x0040,
+	.base_1_reg = 0x0041,
+	.poll_reg = 0x30,
+	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK,
+	.host_int_rsr_reg = 0x1,
+	.host_int_mask_reg = 0x02,
+	.host_int_status_reg = 0x03,
+	.status_reg_0 = 0x60,
+	.status_reg_1 = 0x61,
+	.sdio_int_mask = 0x3f,
+	.data_port_mask = 0x0000fffe,
+	.io_port_0_reg = 0x78,
+	.io_port_1_reg = 0x79,
+	.io_port_2_reg = 0x7A,
+	.max_mp_regs = 64,
+	.rd_bitmap_l = 0x04,
+	.rd_bitmap_u = 0x05,
+	.wr_bitmap_l = 0x06,
+	.wr_bitmap_u = 0x07,
+	.rd_len_p0_l = 0x08,
+	.rd_len_p0_u = 0x09,
+	.card_misc_cfg_reg = 0x6c,
+	.func1_dump_reg_start = 0x0,
+	.func1_dump_reg_end = 0x9,
+	.func1_scratch_reg = 0x60,
+	.func1_spec_reg_num = 5,
+	.func1_spec_reg_table = {0x28, 0x30, 0x34, 0x38, 0x3c},
+};
+
+static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8897 = {
+	.start_rd_port = 0,
+	.start_wr_port = 0,
+	.base_0_reg = 0x60,
+	.base_1_reg = 0x61,
+	.poll_reg = 0x50,
+	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
+			CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
+	.host_int_rsr_reg = 0x1,
+	.host_int_status_reg = 0x03,
+	.host_int_mask_reg = 0x02,
+	.status_reg_0 = 0xc0,
+	.status_reg_1 = 0xc1,
+	.sdio_int_mask = 0xff,
+	.data_port_mask = 0xffffffff,
+	.io_port_0_reg = 0xD8,
+	.io_port_1_reg = 0xD9,
+	.io_port_2_reg = 0xDA,
+	.max_mp_regs = 184,
+	.rd_bitmap_l = 0x04,
+	.rd_bitmap_u = 0x05,
+	.rd_bitmap_1l = 0x06,
+	.rd_bitmap_1u = 0x07,
+	.wr_bitmap_l = 0x08,
+	.wr_bitmap_u = 0x09,
+	.wr_bitmap_1l = 0x0a,
+	.wr_bitmap_1u = 0x0b,
+	.rd_len_p0_l = 0x0c,
+	.rd_len_p0_u = 0x0d,
+	.card_misc_cfg_reg = 0xcc,
+	.card_cfg_2_1_reg = 0xcd,
+	.cmd_rd_len_0 = 0xb4,
+	.cmd_rd_len_1 = 0xb5,
+	.cmd_rd_len_2 = 0xb6,
+	.cmd_rd_len_3 = 0xb7,
+	.cmd_cfg_0 = 0xb8,
+	.cmd_cfg_1 = 0xb9,
+	.cmd_cfg_2 = 0xba,
+	.cmd_cfg_3 = 0xbb,
+	.fw_dump_host_ready = 0xee,
+	.fw_dump_ctrl = 0xe2,
+	.fw_dump_start = 0xe3,
+	.fw_dump_end = 0xea,
+	.func1_dump_reg_start = 0x0,
+	.func1_dump_reg_end = 0xb,
+	.func1_scratch_reg = 0xc0,
+	.func1_spec_reg_num = 8,
+	.func1_spec_reg_table = {0x4C, 0x50, 0x54, 0x55, 0x58,
+				 0x59, 0x5c, 0x5d},
+};
+
+static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8977 = {
+	.start_rd_port = 0,
+	.start_wr_port = 0,
+	.base_0_reg = 0xF8,
+	.base_1_reg = 0xF9,
+	.poll_reg = 0x5C,
+	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
+		CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
+	.host_int_rsr_reg = 0x4,
+	.host_int_status_reg = 0x0C,
+	.host_int_mask_reg = 0x08,
+	.status_reg_0 = 0xE8,
+	.status_reg_1 = 0xE9,
+	.sdio_int_mask = 0xff,
+	.data_port_mask = 0xffffffff,
+	.io_port_0_reg = 0xE4,
+	.io_port_1_reg = 0xE5,
+	.io_port_2_reg = 0xE6,
+	.max_mp_regs = 196,
+	.rd_bitmap_l = 0x10,
+	.rd_bitmap_u = 0x11,
+	.rd_bitmap_1l = 0x12,
+	.rd_bitmap_1u = 0x13,
+	.wr_bitmap_l = 0x14,
+	.wr_bitmap_u = 0x15,
+	.wr_bitmap_1l = 0x16,
+	.wr_bitmap_1u = 0x17,
+	.rd_len_p0_l = 0x18,
+	.rd_len_p0_u = 0x19,
+	.card_misc_cfg_reg = 0xd8,
+	.card_cfg_2_1_reg = 0xd9,
+	.cmd_rd_len_0 = 0xc0,
+	.cmd_rd_len_1 = 0xc1,
+	.cmd_rd_len_2 = 0xc2,
+	.cmd_rd_len_3 = 0xc3,
+	.cmd_cfg_0 = 0xc4,
+	.cmd_cfg_1 = 0xc5,
+	.cmd_cfg_2 = 0xc6,
+	.cmd_cfg_3 = 0xc7,
+	.fw_dump_host_ready = 0xcc,
+	.fw_dump_ctrl = 0xf0,
+	.fw_dump_start = 0xf1,
+	.fw_dump_end = 0xf8,
+	.func1_dump_reg_start = 0x10,
+	.func1_dump_reg_end = 0x17,
+	.func1_scratch_reg = 0xe8,
+	.func1_spec_reg_num = 13,
+	.func1_spec_reg_table = {0x08, 0x58, 0x5C, 0x5D,
+				 0x60, 0x61, 0x62, 0x64,
+				 0x65, 0x66, 0x68, 0x69,
+				 0x6a},
+};
+
+static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8997 = {
+	.start_rd_port = 0,
+	.start_wr_port = 0,
+	.base_0_reg = 0xF8,
+	.base_1_reg = 0xF9,
+	.poll_reg = 0x5C,
+	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
+			CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
+	.host_int_rsr_reg = 0x4,
+	.host_int_status_reg = 0x0C,
+	.host_int_mask_reg = 0x08,
+	.status_reg_0 = 0xE8,
+	.status_reg_1 = 0xE9,
+	.sdio_int_mask = 0xff,
+	.data_port_mask = 0xffffffff,
+	.io_port_0_reg = 0xE4,
+	.io_port_1_reg = 0xE5,
+	.io_port_2_reg = 0xE6,
+	.max_mp_regs = 196,
+	.rd_bitmap_l = 0x10,
+	.rd_bitmap_u = 0x11,
+	.rd_bitmap_1l = 0x12,
+	.rd_bitmap_1u = 0x13,
+	.wr_bitmap_l = 0x14,
+	.wr_bitmap_u = 0x15,
+	.wr_bitmap_1l = 0x16,
+	.wr_bitmap_1u = 0x17,
+	.rd_len_p0_l = 0x18,
+	.rd_len_p0_u = 0x19,
+	.card_misc_cfg_reg = 0xd8,
+	.card_cfg_2_1_reg = 0xd9,
+	.cmd_rd_len_0 = 0xc0,
+	.cmd_rd_len_1 = 0xc1,
+	.cmd_rd_len_2 = 0xc2,
+	.cmd_rd_len_3 = 0xc3,
+	.cmd_cfg_0 = 0xc4,
+	.cmd_cfg_1 = 0xc5,
+	.cmd_cfg_2 = 0xc6,
+	.cmd_cfg_3 = 0xc7,
+	.fw_dump_host_ready = 0xcc,
+	.fw_dump_ctrl = 0xf0,
+	.fw_dump_start = 0xf1,
+	.fw_dump_end = 0xf8,
+	.func1_dump_reg_start = 0x10,
+	.func1_dump_reg_end = 0x17,
+	.func1_scratch_reg = 0xe8,
+	.func1_spec_reg_num = 13,
+	.func1_spec_reg_table = {0x08, 0x58, 0x5C, 0x5D,
+				 0x60, 0x61, 0x62, 0x64,
+				 0x65, 0x66, 0x68, 0x69,
+				 0x6a},
+};
+
+static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8887 = {
+	.start_rd_port = 0,
+	.start_wr_port = 0,
+	.base_0_reg = 0x6C,
+	.base_1_reg = 0x6D,
+	.poll_reg = 0x5C,
+	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
+			CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
+	.host_int_rsr_reg = 0x4,
+	.host_int_status_reg = 0x0C,
+	.host_int_mask_reg = 0x08,
+	.status_reg_0 = 0x90,
+	.status_reg_1 = 0x91,
+	.sdio_int_mask = 0xff,
+	.data_port_mask = 0xffffffff,
+	.io_port_0_reg = 0xE4,
+	.io_port_1_reg = 0xE5,
+	.io_port_2_reg = 0xE6,
+	.max_mp_regs = 196,
+	.rd_bitmap_l = 0x10,
+	.rd_bitmap_u = 0x11,
+	.rd_bitmap_1l = 0x12,
+	.rd_bitmap_1u = 0x13,
+	.wr_bitmap_l = 0x14,
+	.wr_bitmap_u = 0x15,
+	.wr_bitmap_1l = 0x16,
+	.wr_bitmap_1u = 0x17,
+	.rd_len_p0_l = 0x18,
+	.rd_len_p0_u = 0x19,
+	.card_misc_cfg_reg = 0xd8,
+	.card_cfg_2_1_reg = 0xd9,
+	.cmd_rd_len_0 = 0xc0,
+	.cmd_rd_len_1 = 0xc1,
+	.cmd_rd_len_2 = 0xc2,
+	.cmd_rd_len_3 = 0xc3,
+	.cmd_cfg_0 = 0xc4,
+	.cmd_cfg_1 = 0xc5,
+	.cmd_cfg_2 = 0xc6,
+	.cmd_cfg_3 = 0xc7,
+	.func1_dump_reg_start = 0x10,
+	.func1_dump_reg_end = 0x17,
+	.func1_scratch_reg = 0x90,
+	.func1_spec_reg_num = 13,
+	.func1_spec_reg_table = {0x08, 0x58, 0x5C, 0x5D, 0x60,
+				 0x61, 0x62, 0x64, 0x65, 0x66,
+				 0x68, 0x69, 0x6a},
+};
+
+static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8987 = {
+	.start_rd_port = 0,
+	.start_wr_port = 0,
+	.base_0_reg = 0xF8,
+	.base_1_reg = 0xF9,
+	.poll_reg = 0x5C,
+	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
+			CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
+	.host_int_rsr_reg = 0x4,
+	.host_int_status_reg = 0x0C,
+	.host_int_mask_reg = 0x08,
+	.status_reg_0 = 0xE8,
+	.status_reg_1 = 0xE9,
+	.sdio_int_mask = 0xff,
+	.data_port_mask = 0xffffffff,
+	.io_port_0_reg = 0xE4,
+	.io_port_1_reg = 0xE5,
+	.io_port_2_reg = 0xE6,
+	.max_mp_regs = 196,
+	.rd_bitmap_l = 0x10,
+	.rd_bitmap_u = 0x11,
+	.rd_bitmap_1l = 0x12,
+	.rd_bitmap_1u = 0x13,
+	.wr_bitmap_l = 0x14,
+	.wr_bitmap_u = 0x15,
+	.wr_bitmap_1l = 0x16,
+	.wr_bitmap_1u = 0x17,
+	.rd_len_p0_l = 0x18,
+	.rd_len_p0_u = 0x19,
+	.card_misc_cfg_reg = 0xd8,
+	.card_cfg_2_1_reg = 0xd9,
+	.cmd_rd_len_0 = 0xc0,
+	.cmd_rd_len_1 = 0xc1,
+	.cmd_rd_len_2 = 0xc2,
+	.cmd_rd_len_3 = 0xc3,
+	.cmd_cfg_0 = 0xc4,
+	.cmd_cfg_1 = 0xc5,
+	.cmd_cfg_2 = 0xc6,
+	.cmd_cfg_3 = 0xc7,
+	.fw_dump_host_ready = 0xcc,
+	.fw_dump_ctrl = 0xf9,
+	.fw_dump_start = 0xf1,
+	.fw_dump_end = 0xf8,
+	.func1_dump_reg_start = 0x10,
+	.func1_dump_reg_end = 0x17,
+	.func1_scratch_reg = 0xE8,
+	.func1_spec_reg_num = 13,
+	.func1_spec_reg_table = {0x08, 0x58, 0x5C, 0x5D, 0x60,
+				 0x61, 0x62, 0x64, 0x65, 0x66,
+				 0x68, 0x69, 0x6a},
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8786 = {
+	.firmware = SD8786_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd87xx,
+	.max_ports = 16,
+	.mp_agg_pkt_limit = 8,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.supports_sdio_new_mode = false,
+	.has_control_mask = true,
+	.can_dump_fw = false,
+	.can_auto_tdls = false,
+	.can_ext_scan = false,
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8787 = {
+	.firmware = SD8787_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd87xx,
+	.max_ports = 16,
+	.mp_agg_pkt_limit = 8,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.supports_sdio_new_mode = false,
+	.has_control_mask = true,
+	.can_dump_fw = false,
+	.can_auto_tdls = false,
+	.can_ext_scan = true,
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8797 = {
+	.firmware = SD8797_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd87xx,
+	.max_ports = 16,
+	.mp_agg_pkt_limit = 8,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.supports_sdio_new_mode = false,
+	.has_control_mask = true,
+	.can_dump_fw = false,
+	.can_auto_tdls = false,
+	.can_ext_scan = true,
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
+	.firmware = SD8897_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd8897,
+	.max_ports = 32,
+	.mp_agg_pkt_limit = 16,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.supports_sdio_new_mode = true,
+	.has_control_mask = false,
+	.can_dump_fw = true,
+	.can_auto_tdls = false,
+	.can_ext_scan = true,
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8977 = {
+	.firmware = SD8977_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd8977,
+	.max_ports = 32,
+	.mp_agg_pkt_limit = 16,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.supports_sdio_new_mode = true,
+	.has_control_mask = false,
+	.can_dump_fw = true,
+	.fw_dump_enh = true,
+	.can_auto_tdls = false,
+	.can_ext_scan = true,
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8997 = {
+	.firmware = SD8997_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd8997,
+	.max_ports = 32,
+	.mp_agg_pkt_limit = 16,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.supports_sdio_new_mode = true,
+	.has_control_mask = false,
+	.can_dump_fw = true,
+	.fw_dump_enh = true,
+	.can_auto_tdls = false,
+	.can_ext_scan = true,
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8887 = {
+	.firmware = SD8887_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd8887,
+	.max_ports = 32,
+	.mp_agg_pkt_limit = 16,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
+	.supports_sdio_new_mode = true,
+	.has_control_mask = false,
+	.can_dump_fw = false,
+	.can_auto_tdls = true,
+	.can_ext_scan = true,
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8987 = {
+	.firmware = SD8987_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd8987,
+	.max_ports = 32,
+	.mp_agg_pkt_limit = 16,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.supports_sdio_new_mode = true,
+	.has_control_mask = false,
+	.can_dump_fw = true,
+	.fw_dump_enh = true,
+	.can_auto_tdls = true,
+	.can_ext_scan = true,
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8801 = {
+	.firmware = SD8801_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd87xx,
+	.max_ports = 16,
+	.mp_agg_pkt_limit = 8,
+	.supports_sdio_new_mode = false,
+	.has_control_mask = true,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.can_dump_fw = false,
+	.can_auto_tdls = false,
+	.can_ext_scan = true,
+};
+#endif /* _MWIFIEX_SDIO_TABLES_H */
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index a042965962a2d..112903076b715 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -27,6 +27,7 @@
 #include "wmm.h"
 #include "11n.h"
 #include "sdio.h"
+#include "sdio-tables.h"
 
 
 #define SDIO_VERSION	"1.0"
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.h b/drivers/net/wireless/marvell/mwifiex/sdio.h
index 8b476b007c5e2..dec534a6ddb17 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.h
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.h
@@ -290,433 +290,6 @@ struct mwifiex_sdio_device {
 	bool can_ext_scan;
 };
 
-static const struct mwifiex_sdio_card_reg mwifiex_reg_sd87xx = {
-	.start_rd_port = 1,
-	.start_wr_port = 1,
-	.base_0_reg = 0x0040,
-	.base_1_reg = 0x0041,
-	.poll_reg = 0x30,
-	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK,
-	.host_int_rsr_reg = 0x1,
-	.host_int_mask_reg = 0x02,
-	.host_int_status_reg = 0x03,
-	.status_reg_0 = 0x60,
-	.status_reg_1 = 0x61,
-	.sdio_int_mask = 0x3f,
-	.data_port_mask = 0x0000fffe,
-	.io_port_0_reg = 0x78,
-	.io_port_1_reg = 0x79,
-	.io_port_2_reg = 0x7A,
-	.max_mp_regs = 64,
-	.rd_bitmap_l = 0x04,
-	.rd_bitmap_u = 0x05,
-	.wr_bitmap_l = 0x06,
-	.wr_bitmap_u = 0x07,
-	.rd_len_p0_l = 0x08,
-	.rd_len_p0_u = 0x09,
-	.card_misc_cfg_reg = 0x6c,
-	.func1_dump_reg_start = 0x0,
-	.func1_dump_reg_end = 0x9,
-	.func1_scratch_reg = 0x60,
-	.func1_spec_reg_num = 5,
-	.func1_spec_reg_table = {0x28, 0x30, 0x34, 0x38, 0x3c},
-};
-
-static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8897 = {
-	.start_rd_port = 0,
-	.start_wr_port = 0,
-	.base_0_reg = 0x60,
-	.base_1_reg = 0x61,
-	.poll_reg = 0x50,
-	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
-			CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
-	.host_int_rsr_reg = 0x1,
-	.host_int_status_reg = 0x03,
-	.host_int_mask_reg = 0x02,
-	.status_reg_0 = 0xc0,
-	.status_reg_1 = 0xc1,
-	.sdio_int_mask = 0xff,
-	.data_port_mask = 0xffffffff,
-	.io_port_0_reg = 0xD8,
-	.io_port_1_reg = 0xD9,
-	.io_port_2_reg = 0xDA,
-	.max_mp_regs = 184,
-	.rd_bitmap_l = 0x04,
-	.rd_bitmap_u = 0x05,
-	.rd_bitmap_1l = 0x06,
-	.rd_bitmap_1u = 0x07,
-	.wr_bitmap_l = 0x08,
-	.wr_bitmap_u = 0x09,
-	.wr_bitmap_1l = 0x0a,
-	.wr_bitmap_1u = 0x0b,
-	.rd_len_p0_l = 0x0c,
-	.rd_len_p0_u = 0x0d,
-	.card_misc_cfg_reg = 0xcc,
-	.card_cfg_2_1_reg = 0xcd,
-	.cmd_rd_len_0 = 0xb4,
-	.cmd_rd_len_1 = 0xb5,
-	.cmd_rd_len_2 = 0xb6,
-	.cmd_rd_len_3 = 0xb7,
-	.cmd_cfg_0 = 0xb8,
-	.cmd_cfg_1 = 0xb9,
-	.cmd_cfg_2 = 0xba,
-	.cmd_cfg_3 = 0xbb,
-	.fw_dump_host_ready = 0xee,
-	.fw_dump_ctrl = 0xe2,
-	.fw_dump_start = 0xe3,
-	.fw_dump_end = 0xea,
-	.func1_dump_reg_start = 0x0,
-	.func1_dump_reg_end = 0xb,
-	.func1_scratch_reg = 0xc0,
-	.func1_spec_reg_num = 8,
-	.func1_spec_reg_table = {0x4C, 0x50, 0x54, 0x55, 0x58,
-				 0x59, 0x5c, 0x5d},
-};
-
-static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8977 = {
-	.start_rd_port = 0,
-	.start_wr_port = 0,
-	.base_0_reg = 0xF8,
-	.base_1_reg = 0xF9,
-	.poll_reg = 0x5C,
-	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
-		CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
-	.host_int_rsr_reg = 0x4,
-	.host_int_status_reg = 0x0C,
-	.host_int_mask_reg = 0x08,
-	.status_reg_0 = 0xE8,
-	.status_reg_1 = 0xE9,
-	.sdio_int_mask = 0xff,
-	.data_port_mask = 0xffffffff,
-	.io_port_0_reg = 0xE4,
-	.io_port_1_reg = 0xE5,
-	.io_port_2_reg = 0xE6,
-	.max_mp_regs = 196,
-	.rd_bitmap_l = 0x10,
-	.rd_bitmap_u = 0x11,
-	.rd_bitmap_1l = 0x12,
-	.rd_bitmap_1u = 0x13,
-	.wr_bitmap_l = 0x14,
-	.wr_bitmap_u = 0x15,
-	.wr_bitmap_1l = 0x16,
-	.wr_bitmap_1u = 0x17,
-	.rd_len_p0_l = 0x18,
-	.rd_len_p0_u = 0x19,
-	.card_misc_cfg_reg = 0xd8,
-	.card_cfg_2_1_reg = 0xd9,
-	.cmd_rd_len_0 = 0xc0,
-	.cmd_rd_len_1 = 0xc1,
-	.cmd_rd_len_2 = 0xc2,
-	.cmd_rd_len_3 = 0xc3,
-	.cmd_cfg_0 = 0xc4,
-	.cmd_cfg_1 = 0xc5,
-	.cmd_cfg_2 = 0xc6,
-	.cmd_cfg_3 = 0xc7,
-	.fw_dump_host_ready = 0xcc,
-	.fw_dump_ctrl = 0xf0,
-	.fw_dump_start = 0xf1,
-	.fw_dump_end = 0xf8,
-	.func1_dump_reg_start = 0x10,
-	.func1_dump_reg_end = 0x17,
-	.func1_scratch_reg = 0xe8,
-	.func1_spec_reg_num = 13,
-	.func1_spec_reg_table = {0x08, 0x58, 0x5C, 0x5D,
-				 0x60, 0x61, 0x62, 0x64,
-				 0x65, 0x66, 0x68, 0x69,
-				 0x6a},
-};
-
-static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8997 = {
-	.start_rd_port = 0,
-	.start_wr_port = 0,
-	.base_0_reg = 0xF8,
-	.base_1_reg = 0xF9,
-	.poll_reg = 0x5C,
-	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
-			CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
-	.host_int_rsr_reg = 0x4,
-	.host_int_status_reg = 0x0C,
-	.host_int_mask_reg = 0x08,
-	.status_reg_0 = 0xE8,
-	.status_reg_1 = 0xE9,
-	.sdio_int_mask = 0xff,
-	.data_port_mask = 0xffffffff,
-	.io_port_0_reg = 0xE4,
-	.io_port_1_reg = 0xE5,
-	.io_port_2_reg = 0xE6,
-	.max_mp_regs = 196,
-	.rd_bitmap_l = 0x10,
-	.rd_bitmap_u = 0x11,
-	.rd_bitmap_1l = 0x12,
-	.rd_bitmap_1u = 0x13,
-	.wr_bitmap_l = 0x14,
-	.wr_bitmap_u = 0x15,
-	.wr_bitmap_1l = 0x16,
-	.wr_bitmap_1u = 0x17,
-	.rd_len_p0_l = 0x18,
-	.rd_len_p0_u = 0x19,
-	.card_misc_cfg_reg = 0xd8,
-	.card_cfg_2_1_reg = 0xd9,
-	.cmd_rd_len_0 = 0xc0,
-	.cmd_rd_len_1 = 0xc1,
-	.cmd_rd_len_2 = 0xc2,
-	.cmd_rd_len_3 = 0xc3,
-	.cmd_cfg_0 = 0xc4,
-	.cmd_cfg_1 = 0xc5,
-	.cmd_cfg_2 = 0xc6,
-	.cmd_cfg_3 = 0xc7,
-	.fw_dump_host_ready = 0xcc,
-	.fw_dump_ctrl = 0xf0,
-	.fw_dump_start = 0xf1,
-	.fw_dump_end = 0xf8,
-	.func1_dump_reg_start = 0x10,
-	.func1_dump_reg_end = 0x17,
-	.func1_scratch_reg = 0xe8,
-	.func1_spec_reg_num = 13,
-	.func1_spec_reg_table = {0x08, 0x58, 0x5C, 0x5D,
-				 0x60, 0x61, 0x62, 0x64,
-				 0x65, 0x66, 0x68, 0x69,
-				 0x6a},
-};
-
-static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8887 = {
-	.start_rd_port = 0,
-	.start_wr_port = 0,
-	.base_0_reg = 0x6C,
-	.base_1_reg = 0x6D,
-	.poll_reg = 0x5C,
-	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
-			CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
-	.host_int_rsr_reg = 0x4,
-	.host_int_status_reg = 0x0C,
-	.host_int_mask_reg = 0x08,
-	.status_reg_0 = 0x90,
-	.status_reg_1 = 0x91,
-	.sdio_int_mask = 0xff,
-	.data_port_mask = 0xffffffff,
-	.io_port_0_reg = 0xE4,
-	.io_port_1_reg = 0xE5,
-	.io_port_2_reg = 0xE6,
-	.max_mp_regs = 196,
-	.rd_bitmap_l = 0x10,
-	.rd_bitmap_u = 0x11,
-	.rd_bitmap_1l = 0x12,
-	.rd_bitmap_1u = 0x13,
-	.wr_bitmap_l = 0x14,
-	.wr_bitmap_u = 0x15,
-	.wr_bitmap_1l = 0x16,
-	.wr_bitmap_1u = 0x17,
-	.rd_len_p0_l = 0x18,
-	.rd_len_p0_u = 0x19,
-	.card_misc_cfg_reg = 0xd8,
-	.card_cfg_2_1_reg = 0xd9,
-	.cmd_rd_len_0 = 0xc0,
-	.cmd_rd_len_1 = 0xc1,
-	.cmd_rd_len_2 = 0xc2,
-	.cmd_rd_len_3 = 0xc3,
-	.cmd_cfg_0 = 0xc4,
-	.cmd_cfg_1 = 0xc5,
-	.cmd_cfg_2 = 0xc6,
-	.cmd_cfg_3 = 0xc7,
-	.func1_dump_reg_start = 0x10,
-	.func1_dump_reg_end = 0x17,
-	.func1_scratch_reg = 0x90,
-	.func1_spec_reg_num = 13,
-	.func1_spec_reg_table = {0x08, 0x58, 0x5C, 0x5D, 0x60,
-				 0x61, 0x62, 0x64, 0x65, 0x66,
-				 0x68, 0x69, 0x6a},
-};
-
-static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8987 = {
-	.start_rd_port = 0,
-	.start_wr_port = 0,
-	.base_0_reg = 0xF8,
-	.base_1_reg = 0xF9,
-	.poll_reg = 0x5C,
-	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
-			CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
-	.host_int_rsr_reg = 0x4,
-	.host_int_status_reg = 0x0C,
-	.host_int_mask_reg = 0x08,
-	.status_reg_0 = 0xE8,
-	.status_reg_1 = 0xE9,
-	.sdio_int_mask = 0xff,
-	.data_port_mask = 0xffffffff,
-	.io_port_0_reg = 0xE4,
-	.io_port_1_reg = 0xE5,
-	.io_port_2_reg = 0xE6,
-	.max_mp_regs = 196,
-	.rd_bitmap_l = 0x10,
-	.rd_bitmap_u = 0x11,
-	.rd_bitmap_1l = 0x12,
-	.rd_bitmap_1u = 0x13,
-	.wr_bitmap_l = 0x14,
-	.wr_bitmap_u = 0x15,
-	.wr_bitmap_1l = 0x16,
-	.wr_bitmap_1u = 0x17,
-	.rd_len_p0_l = 0x18,
-	.rd_len_p0_u = 0x19,
-	.card_misc_cfg_reg = 0xd8,
-	.card_cfg_2_1_reg = 0xd9,
-	.cmd_rd_len_0 = 0xc0,
-	.cmd_rd_len_1 = 0xc1,
-	.cmd_rd_len_2 = 0xc2,
-	.cmd_rd_len_3 = 0xc3,
-	.cmd_cfg_0 = 0xc4,
-	.cmd_cfg_1 = 0xc5,
-	.cmd_cfg_2 = 0xc6,
-	.cmd_cfg_3 = 0xc7,
-	.fw_dump_host_ready = 0xcc,
-	.fw_dump_ctrl = 0xf9,
-	.fw_dump_start = 0xf1,
-	.fw_dump_end = 0xf8,
-	.func1_dump_reg_start = 0x10,
-	.func1_dump_reg_end = 0x17,
-	.func1_scratch_reg = 0xE8,
-	.func1_spec_reg_num = 13,
-	.func1_spec_reg_table = {0x08, 0x58, 0x5C, 0x5D, 0x60,
-				 0x61, 0x62, 0x64, 0x65, 0x66,
-				 0x68, 0x69, 0x6a},
-};
-
-static const struct mwifiex_sdio_device mwifiex_sdio_sd8786 = {
-	.firmware = SD8786_DEFAULT_FW_NAME,
-	.reg = &mwifiex_reg_sd87xx,
-	.max_ports = 16,
-	.mp_agg_pkt_limit = 8,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
-	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
-	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
-	.supports_sdio_new_mode = false,
-	.has_control_mask = true,
-	.can_dump_fw = false,
-	.can_auto_tdls = false,
-	.can_ext_scan = false,
-};
-
-static const struct mwifiex_sdio_device mwifiex_sdio_sd8787 = {
-	.firmware = SD8787_DEFAULT_FW_NAME,
-	.reg = &mwifiex_reg_sd87xx,
-	.max_ports = 16,
-	.mp_agg_pkt_limit = 8,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
-	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
-	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
-	.supports_sdio_new_mode = false,
-	.has_control_mask = true,
-	.can_dump_fw = false,
-	.can_auto_tdls = false,
-	.can_ext_scan = true,
-};
-
-static const struct mwifiex_sdio_device mwifiex_sdio_sd8797 = {
-	.firmware = SD8797_DEFAULT_FW_NAME,
-	.reg = &mwifiex_reg_sd87xx,
-	.max_ports = 16,
-	.mp_agg_pkt_limit = 8,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
-	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
-	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
-	.supports_sdio_new_mode = false,
-	.has_control_mask = true,
-	.can_dump_fw = false,
-	.can_auto_tdls = false,
-	.can_ext_scan = true,
-};
-
-static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
-	.firmware = SD8897_DEFAULT_FW_NAME,
-	.reg = &mwifiex_reg_sd8897,
-	.max_ports = 32,
-	.mp_agg_pkt_limit = 16,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
-	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
-	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
-	.supports_sdio_new_mode = true,
-	.has_control_mask = false,
-	.can_dump_fw = true,
-	.can_auto_tdls = false,
-	.can_ext_scan = true,
-};
-
-static const struct mwifiex_sdio_device mwifiex_sdio_sd8977 = {
-	.firmware = SD8977_DEFAULT_FW_NAME,
-	.reg = &mwifiex_reg_sd8977,
-	.max_ports = 32,
-	.mp_agg_pkt_limit = 16,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
-	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
-	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
-	.supports_sdio_new_mode = true,
-	.has_control_mask = false,
-	.can_dump_fw = true,
-	.fw_dump_enh = true,
-	.can_auto_tdls = false,
-	.can_ext_scan = true,
-};
-
-static const struct mwifiex_sdio_device mwifiex_sdio_sd8997 = {
-	.firmware = SD8997_DEFAULT_FW_NAME,
-	.reg = &mwifiex_reg_sd8997,
-	.max_ports = 32,
-	.mp_agg_pkt_limit = 16,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
-	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
-	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
-	.supports_sdio_new_mode = true,
-	.has_control_mask = false,
-	.can_dump_fw = true,
-	.fw_dump_enh = true,
-	.can_auto_tdls = false,
-	.can_ext_scan = true,
-};
-
-static const struct mwifiex_sdio_device mwifiex_sdio_sd8887 = {
-	.firmware = SD8887_DEFAULT_FW_NAME,
-	.reg = &mwifiex_reg_sd8887,
-	.max_ports = 32,
-	.mp_agg_pkt_limit = 16,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
-	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
-	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
-	.supports_sdio_new_mode = true,
-	.has_control_mask = false,
-	.can_dump_fw = false,
-	.can_auto_tdls = true,
-	.can_ext_scan = true,
-};
-
-static const struct mwifiex_sdio_device mwifiex_sdio_sd8987 = {
-	.firmware = SD8987_DEFAULT_FW_NAME,
-	.reg = &mwifiex_reg_sd8987,
-	.max_ports = 32,
-	.mp_agg_pkt_limit = 16,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
-	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
-	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
-	.supports_sdio_new_mode = true,
-	.has_control_mask = false,
-	.can_dump_fw = true,
-	.fw_dump_enh = true,
-	.can_auto_tdls = true,
-	.can_ext_scan = true,
-};
-
-static const struct mwifiex_sdio_device mwifiex_sdio_sd8801 = {
-	.firmware = SD8801_DEFAULT_FW_NAME,
-	.reg = &mwifiex_reg_sd87xx,
-	.max_ports = 16,
-	.mp_agg_pkt_limit = 8,
-	.supports_sdio_new_mode = false,
-	.has_control_mask = true,
-	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
-	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
-	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
-	.can_dump_fw = false,
-	.can_auto_tdls = false,
-	.can_ext_scan = true,
-};
-
 /*
  * .cmdrsp_complete handler
  */
-- 
2.25.1

