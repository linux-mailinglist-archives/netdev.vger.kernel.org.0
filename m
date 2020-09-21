Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0293A273622
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 01:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgIUXCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 19:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727693AbgIUXCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 19:02:35 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3119CC061755;
        Mon, 21 Sep 2020 16:02:35 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id y4so12505820ljk.8;
        Mon, 21 Sep 2020 16:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7NlX4iHrvgkscvB3gNZr3in7DPqC1ID14flrJZxdlvU=;
        b=gT0wfTTWxlv6pyUMajetLrX5miR4lqmxOfLEScMHqa6qee0meDC/eGwhHHEC3w2tN4
         jkhealsaEdGlF4v7y02YJ/5wVyUxmE6SHImD9jKxoWFi5XgAjFPm/tiS4KUGZRmqBZFL
         YxKSzsZPX3GO6DSIjQEQYjwheiYbMT4kc/OvxiFEW5FOsBdihqsBNhsImANTRUvrn4GE
         ztz5qJb/FIE/MRM+2EY7yekgDGT450eCZoGDDvi+jvTq5eeeO3QTharnY0T0R0KrZXCA
         qj4ylhsJAUXGUAjVzP5qRzgF93a1Py5gx8xgmMb16T0MqudvN+D4+1uwuftY2O5JSGM4
         GDeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7NlX4iHrvgkscvB3gNZr3in7DPqC1ID14flrJZxdlvU=;
        b=LD3ZRXUmiO+wUO9gvYml4QnyI7a6g0qLi5ZdqPBAla9eBoatBn6iEkGDQ6Mq3VLPGH
         TTe6LUs4dhanQvLN3BBBFahGzhkSLmTPQ9FxeXjyCS2IiQzuZ0OPpYwtsIAvtgRPnEsO
         q6zixBskTTe/eYMRzQGcbsaG3ikYQOF3nvtWNA6FAxgOcY8JWMKvYe2KBcRPevnaR/AL
         MZXJj66ohg91f/3VdAPJwL9sPBR0Ffd5myLRLVURNAJCP/RnMvZwJzQ5LxRI4Hx3XiIz
         h2TSXr2ylJybrRCf4VLupDFcMAFqllSx0OjmOUIHSEhdgPkIiQCSIu5tDSYLmUNhLG9K
         gtBg==
X-Gm-Message-State: AOAM5312zAkavLSYzTURdALDGD1GPvCShowPDL1l09cbmErRF/bxRQSj
        Ep8i8kT4Mq1tJJEhTLBH4Gvfow2IX/8nbw==
X-Google-Smtp-Source: ABdhPJxbYj4gSam3bW8M90e+7lHYZ6q4WxSQPFhn29LYjMUoPGgeOpWABcFpeJ8YaJlEEvlFD+6G9A==
X-Received: by 2002:a2e:a588:: with SMTP id m8mr568469ljp.210.1600729353089;
        Mon, 21 Sep 2020 16:02:33 -0700 (PDT)
Received: from localhost.localdomain (h-82-196-111-59.NA.cust.bahnhof.se. [82.196.111.59])
        by smtp.gmail.com with ESMTPSA id l11sm2905624lfk.113.2020.09.21.16.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 16:02:32 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [PATCH net-next] net: hns3: Constify static structs
Date:   Tue, 22 Sep 2020 00:55:17 +0200
Message-Id: <20200921225517.105265-1-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A number of static variables were not modified. Make them const to allow
the compiler to put them in read-only memory. In order to do so,
constify a couple of input pointers as well as some local pointers.
This moves about 35Kb to read-only memory as seen by the output of the
size command.

Before:
   text    data     bss     dec     hex filename
 404938  111534     640  517112   7e3f8 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge.ko

After:
   text    data     bss     dec     hex filename
 439499   76974     640  517113   7e3f9 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge.ko

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     | 10 +++----
 .../hisilicon/hns3/hns3pf/hclge_debugfs.h     | 26 +++++++++----------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 26f6f068b01d..c643c5ab60df 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -8,7 +8,7 @@
 #include "hclge_tm.h"
 #include "hnae3.h"
 
-static struct hclge_dbg_reg_type_info hclge_dbg_reg_info[] = {
+static const struct hclge_dbg_reg_type_info hclge_dbg_reg_info[] = {
 	{ .reg_type = "bios common",
 	  .dfx_msg = &hclge_dbg_bios_common_reg[0],
 	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_bios_common_reg),
@@ -115,14 +115,14 @@ static int hclge_dbg_cmd_send(struct hclge_dev *hdev,
 }
 
 static void hclge_dbg_dump_reg_common(struct hclge_dev *hdev,
-				      struct hclge_dbg_reg_type_info *reg_info,
+				      const struct hclge_dbg_reg_type_info *reg_info,
 				      const char *cmd_buf)
 {
 #define IDX_OFFSET	1
 
 	const char *s = &cmd_buf[strlen(reg_info->reg_type) + IDX_OFFSET];
-	struct hclge_dbg_dfx_message *dfx_message = reg_info->dfx_msg;
-	struct hclge_dbg_reg_common_msg *reg_msg = &reg_info->reg_msg;
+	const struct hclge_dbg_dfx_message *dfx_message = reg_info->dfx_msg;
+	const struct hclge_dbg_reg_common_msg *reg_msg = &reg_info->reg_msg;
 	struct hclge_desc *desc_src;
 	struct hclge_desc *desc;
 	int entries_per_desc;
@@ -399,7 +399,7 @@ static void hclge_dbg_dump_dcb(struct hclge_dev *hdev, const char *cmd_buf)
 
 static void hclge_dbg_dump_reg_cmd(struct hclge_dev *hdev, const char *cmd_buf)
 {
-	struct hclge_dbg_reg_type_info *reg_info;
+	const struct hclge_dbg_reg_type_info *reg_info;
 	bool has_dump = false;
 	int i;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
index 38b79321c4c4..a9066e6ff697 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
@@ -81,13 +81,13 @@ struct hclge_dbg_dfx_message {
 #define HCLGE_DBG_MAC_REG_TYPE_LEN	32
 struct hclge_dbg_reg_type_info {
 	const char *reg_type;
-	struct hclge_dbg_dfx_message *dfx_msg;
+	const struct hclge_dbg_dfx_message *dfx_msg;
 	struct hclge_dbg_reg_common_msg reg_msg;
 };
 
 #pragma pack()
 
-static struct hclge_dbg_dfx_message hclge_dbg_bios_common_reg[] = {
+static const struct hclge_dbg_dfx_message hclge_dbg_bios_common_reg[] = {
 	{false, "Reserved"},
 	{true,	"BP_CPU_STATE"},
 	{true,	"DFX_MSIX_INFO_NIC_0"},
@@ -103,7 +103,7 @@ static struct hclge_dbg_dfx_message hclge_dbg_bios_common_reg[] = {
 	{false, "Reserved"},
 };
 
-static struct hclge_dbg_dfx_message hclge_dbg_ssu_reg_0[] = {
+static const struct hclge_dbg_dfx_message hclge_dbg_ssu_reg_0[] = {
 	{false, "Reserved"},
 	{true,	"SSU_ETS_PORT_STATUS"},
 	{true,	"SSU_ETS_TCG_STATUS"},
@@ -175,7 +175,7 @@ static struct hclge_dbg_dfx_message hclge_dbg_ssu_reg_0[] = {
 	{false, "Reserved"},
 };
 
-static struct hclge_dbg_dfx_message hclge_dbg_ssu_reg_1[] = {
+static const struct hclge_dbg_dfx_message hclge_dbg_ssu_reg_1[] = {
 	{true,	"prt_id"},
 	{true,	"PACKET_TC_CURR_BUFFER_CNT_0"},
 	{true,	"PACKET_TC_CURR_BUFFER_CNT_1"},
@@ -282,7 +282,7 @@ static struct hclge_dbg_dfx_message hclge_dbg_ssu_reg_1[] = {
 	{false, "Reserved"},
 };
 
-static struct hclge_dbg_dfx_message hclge_dbg_ssu_reg_2[] = {
+static const struct hclge_dbg_dfx_message hclge_dbg_ssu_reg_2[] = {
 	{true,	"OQ_INDEX"},
 	{true,	"QUEUE_CNT"},
 	{false, "Reserved"},
@@ -291,7 +291,7 @@ static struct hclge_dbg_dfx_message hclge_dbg_ssu_reg_2[] = {
 	{false, "Reserved"},
 };
 
-static struct hclge_dbg_dfx_message hclge_dbg_igu_egu_reg[] = {
+static const struct hclge_dbg_dfx_message hclge_dbg_igu_egu_reg[] = {
 	{true,	"prt_id"},
 	{true,	"IGU_RX_ERR_PKT"},
 	{true,	"IGU_RX_NO_SOF_PKT"},
@@ -356,7 +356,7 @@ static struct hclge_dbg_dfx_message hclge_dbg_igu_egu_reg[] = {
 	{false,	"Reserved"},
 };
 
-static struct hclge_dbg_dfx_message hclge_dbg_rpu_reg_0[] = {
+static const struct hclge_dbg_dfx_message hclge_dbg_rpu_reg_0[] = {
 	{true, "tc_queue_num"},
 	{true, "FSM_DFX_ST0"},
 	{true, "FSM_DFX_ST1"},
@@ -365,7 +365,7 @@ static struct hclge_dbg_dfx_message hclge_dbg_rpu_reg_0[] = {
 	{true, "BUF_WAIT_TIMEOUT_QID"},
 };
 
-static struct hclge_dbg_dfx_message hclge_dbg_rpu_reg_1[] = {
+static const struct hclge_dbg_dfx_message hclge_dbg_rpu_reg_1[] = {
 	{false, "Reserved"},
 	{true,	"FIFO_DFX_ST0"},
 	{true,	"FIFO_DFX_ST1"},
@@ -381,7 +381,7 @@ static struct hclge_dbg_dfx_message hclge_dbg_rpu_reg_1[] = {
 	{false, "Reserved"},
 };
 
-static struct hclge_dbg_dfx_message hclge_dbg_ncsi_reg[] = {
+static const struct hclge_dbg_dfx_message hclge_dbg_ncsi_reg[] = {
 	{false, "Reserved"},
 	{true,	"NCSI_EGU_TX_FIFO_STS"},
 	{true,	"NCSI_PAUSE_STATUS"},
@@ -453,7 +453,7 @@ static struct hclge_dbg_dfx_message hclge_dbg_ncsi_reg[] = {
 	{true,	"NCSI_MAC_RX_PAUSE_FRAMES"},
 };
 
-static struct hclge_dbg_dfx_message hclge_dbg_rtc_reg[] = {
+static const struct hclge_dbg_dfx_message hclge_dbg_rtc_reg[] = {
 	{false, "Reserved"},
 	{true,	"LGE_IGU_AFIFO_DFX_0"},
 	{true,	"LGE_IGU_AFIFO_DFX_1"},
@@ -483,7 +483,7 @@ static struct hclge_dbg_dfx_message hclge_dbg_rtc_reg[] = {
 	{false, "Reserved"},
 };
 
-static struct hclge_dbg_dfx_message hclge_dbg_ppp_reg[] = {
+static const struct hclge_dbg_dfx_message hclge_dbg_ppp_reg[] = {
 	{false, "Reserved"},
 	{true,	"DROP_FROM_PRT_PKT_CNT"},
 	{true,	"DROP_FROM_HOST_PKT_CNT"},
@@ -639,7 +639,7 @@ static struct hclge_dbg_dfx_message hclge_dbg_ppp_reg[] = {
 	{false, "Reserved"},
 };
 
-static struct hclge_dbg_dfx_message hclge_dbg_rcb_reg[] = {
+static const struct hclge_dbg_dfx_message hclge_dbg_rcb_reg[] = {
 	{false, "Reserved"},
 	{true,	"FSM_DFX_ST0"},
 	{true,	"FSM_DFX_ST1"},
@@ -711,7 +711,7 @@ static struct hclge_dbg_dfx_message hclge_dbg_rcb_reg[] = {
 	{false, "Reserved"},
 };
 
-static struct hclge_dbg_dfx_message hclge_dbg_tqp_reg[] = {
+static const struct hclge_dbg_dfx_message hclge_dbg_tqp_reg[] = {
 	{true, "q_num"},
 	{true, "RCB_CFG_RX_RING_TAIL"},
 	{true, "RCB_CFG_RX_RING_HEAD"},
-- 
2.28.0

