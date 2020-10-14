Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521AB28DF36
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 12:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388209AbgJNKno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 06:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729729AbgJNKne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 06:43:34 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A00C0613D2;
        Wed, 14 Oct 2020 03:43:33 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id o9so1529453plx.10;
        Wed, 14 Oct 2020 03:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qIgU8Plb5Hs46cFWHX9Gbtdd89uW5HBlBB0rZ1YZFlg=;
        b=sed0cA5GJzQVFFxJrrUlxVNNrQL7JVk/2PDFawxTg7W7vZA9xbiBn3gZO48cwpVcqO
         pvCd8v+o1eGzyMJFWGWTx4bXKkROcotiWyzAzPcztVaH/CjLhaBua+9L3YIycnfCd0X8
         Qn4nroqgSejm/to27vVOHccyF64rvyIm0VAw78wiMrMyZnWzJkkN0CQPWkgIJ3PWrHTq
         52CuP/doyCEFOQIKR25fN89oH5yER27mSCuxIuvx/g+zV2+pRGXOhzwDdIkPon6wC7zq
         XL4FwgJ3z3bSu3hF60fzspC5TLI5Tq8rnDFYaAA8KTFjm8MTqLmK15p8Ek53ace0T+zo
         uUOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qIgU8Plb5Hs46cFWHX9Gbtdd89uW5HBlBB0rZ1YZFlg=;
        b=BtK5m0eX8Y6lhBpPDiujmqJRjvT8LMAmNhad5DG6mrAMauflYtehgkhAy21l+JS4uj
         4erhyypH5yFOnJ50M1EJWWQX8hCgCZROc2pkqpZeOz8EZWs4tgSwOxsMmLCpIjHAXTrU
         H7VnNIWJnbNvFyYlb2fIrQDkTP9xz78xaspIOgL+PaQLbi4OkZ2yHsBTNR1il36Vi67x
         yDD20k1A377qw9Y6IjsXpCntkluO7KKOOytI1w5tGPzoyjC81C/2qGIh/J1i+ItreCEA
         CaQacmZQdLUykAck/HMk/g7EoQBB/UiBcyGuYwofraVeQ0fmAVDcloVloj2MX8aykxKQ
         nGZg==
X-Gm-Message-State: AOAM532aGqyMWj5PQLNuftdQSthLCh4AUBGiWi5KGsX4OnGhVNU5af6A
        KLZJ33Surht05/kPBKE7ibc=
X-Google-Smtp-Source: ABdhPJyEXvzgUfT3YSJriY5rR1QEp4asxteO8MpeOSa+DQzMg1Qf1j35iMp8l2HeCTND5MdwKDIOMg==
X-Received: by 2002:a17:902:778e:b029:d2:8046:efe2 with SMTP id o14-20020a170902778eb02900d28046efe2mr3693851pll.44.1602672213426;
        Wed, 14 Oct 2020 03:43:33 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id c15sm3100887pgg.77.2020.10.14.03.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 03:43:33 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 3/7] staging: qlge: coredump via devlink health reporter
Date:   Wed, 14 Oct 2020 18:43:02 +0800
Message-Id: <20201014104306.63756-4-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201014104306.63756-1-coiby.xu@gmail.com>
References: <20201014104306.63756-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

    $ devlink health dump show DEVICE reporter coredump -p -j
    {
        "Core Registers": {
            "segment": 1,
            "values": [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ]
        },
        "Test Logic Regs": {
            "segment": 2,
            "values": [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ]
        },
        "RMII Registers": {
            "segment": 3,
            "values": [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ]
        },
        ...
        "Sem Registers": {
            "segment": 50,
            "values": [ 0,0,0,0 ]
        }
    }

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/qlge_devlink.c | 130 ++++++++++++++++++++++++++--
 1 file changed, 124 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/qlge/qlge_devlink.c b/drivers/staging/qlge/qlge_devlink.c
index d9c71f45211f..b75ec5bff26a 100644
--- a/drivers/staging/qlge/qlge_devlink.c
+++ b/drivers/staging/qlge/qlge_devlink.c
@@ -2,16 +2,134 @@
 #include "qlge.h"
 #include "qlge_devlink.h"
 
-static int
-qlge_reporter_coredump(struct devlink_health_reporter *reporter,
-		       struct devlink_fmsg *fmsg, void *priv_ctx,
-		       struct netlink_ext_ack *extack)
+static int qlge_fill_seg_(struct devlink_fmsg *fmsg,
+			  struct mpi_coredump_segment_header *seg_header,
+			  u32 *reg_data)
 {
-	return 0;
+	int regs_num = (seg_header->seg_size
+			- sizeof(struct mpi_coredump_segment_header)) / sizeof(u32);
+	int err;
+	int i;
+
+	err = devlink_fmsg_pair_nest_start(fmsg, seg_header->description);
+	if (err)
+		return err;
+	err = devlink_fmsg_obj_nest_start(fmsg);
+	if (err)
+		return err;
+	err = devlink_fmsg_u32_pair_put(fmsg, "segment", seg_header->seg_num);
+	if (err)
+		return err;
+	err = devlink_fmsg_arr_pair_nest_start(fmsg, "values");
+	if (err)
+		return err;
+	for (i = 0; i < regs_num; i++) {
+		err = devlink_fmsg_u32_put(fmsg, *reg_data);
+		if (err)
+			return err;
+		reg_data++;
+	}
+	err = devlink_fmsg_obj_nest_end(fmsg);
+	if (err)
+		return err;
+	err = devlink_fmsg_arr_pair_nest_end(fmsg);
+	if (err)
+		return err;
+	err = devlink_fmsg_pair_nest_end(fmsg);
+	return err;
+}
+
+#define FILL_SEG(seg_hdr, seg_regs)			                    \
+	do {                                                                \
+		err = qlge_fill_seg_(fmsg, &dump->seg_hdr, dump->seg_regs); \
+		if (err) {					            \
+			kvfree(dump);                                       \
+			return err;				            \
+		}                                                           \
+	} while (0)
+
+static int qlge_reporter_coredump(struct devlink_health_reporter *reporter,
+				  struct devlink_fmsg *fmsg, void *priv_ctx,
+				  struct netlink_ext_ack *extack)
+{
+	int err = 0;
+
+	struct qlge_adapter *qdev = devlink_health_reporter_priv(reporter);
+	struct qlge_mpi_coredump *dump;
+
+	if (!netif_running(qdev->ndev))
+		return 0;
+
+	dump = kvmalloc(sizeof(*dump), GFP_KERNEL);
+	if (!dump)
+		return -ENOMEM;
+
+	err = qlge_core_dump(qdev, dump);
+	if (err) {
+		kvfree(dump);
+		return err;
+	}
+
+	FILL_SEG(core_regs_seg_hdr, mpi_core_regs);
+	FILL_SEG(test_logic_regs_seg_hdr, test_logic_regs);
+	FILL_SEG(rmii_regs_seg_hdr, rmii_regs);
+	FILL_SEG(fcmac1_regs_seg_hdr, fcmac1_regs);
+	FILL_SEG(fcmac2_regs_seg_hdr, fcmac2_regs);
+	FILL_SEG(fc1_mbx_regs_seg_hdr, fc1_mbx_regs);
+	FILL_SEG(ide_regs_seg_hdr, ide_regs);
+	FILL_SEG(nic1_mbx_regs_seg_hdr, nic1_mbx_regs);
+	FILL_SEG(smbus_regs_seg_hdr, smbus_regs);
+	FILL_SEG(fc2_mbx_regs_seg_hdr, fc2_mbx_regs);
+	FILL_SEG(nic2_mbx_regs_seg_hdr, nic2_mbx_regs);
+	FILL_SEG(i2c_regs_seg_hdr, i2c_regs);
+	FILL_SEG(memc_regs_seg_hdr, memc_regs);
+	FILL_SEG(pbus_regs_seg_hdr, pbus_regs);
+	FILL_SEG(mde_regs_seg_hdr, mde_regs);
+	FILL_SEG(nic_regs_seg_hdr, nic_regs);
+	FILL_SEG(nic2_regs_seg_hdr, nic2_regs);
+	FILL_SEG(xgmac1_seg_hdr, xgmac1);
+	FILL_SEG(xgmac2_seg_hdr, xgmac2);
+	FILL_SEG(code_ram_seg_hdr, code_ram);
+	FILL_SEG(memc_ram_seg_hdr, memc_ram);
+	FILL_SEG(xaui_an_hdr, serdes_xaui_an);
+	FILL_SEG(xaui_hss_pcs_hdr, serdes_xaui_hss_pcs);
+	FILL_SEG(xfi_an_hdr, serdes_xfi_an);
+	FILL_SEG(xfi_train_hdr, serdes_xfi_train);
+	FILL_SEG(xfi_hss_pcs_hdr, serdes_xfi_hss_pcs);
+	FILL_SEG(xfi_hss_tx_hdr, serdes_xfi_hss_tx);
+	FILL_SEG(xfi_hss_rx_hdr, serdes_xfi_hss_rx);
+	FILL_SEG(xfi_hss_pll_hdr, serdes_xfi_hss_pll);
+
+	err = qlge_fill_seg_(fmsg, &dump->misc_nic_seg_hdr,
+			     (u32 *)&dump->misc_nic_info);
+	if (err) {
+		kvfree(dump);
+		return err;
+	}
+
+	FILL_SEG(intr_states_seg_hdr, intr_states);
+	FILL_SEG(cam_entries_seg_hdr, cam_entries);
+	FILL_SEG(nic_routing_words_seg_hdr, nic_routing_words);
+	FILL_SEG(ets_seg_hdr, ets);
+	FILL_SEG(probe_dump_seg_hdr, probe_dump);
+	FILL_SEG(routing_reg_seg_hdr, routing_regs);
+	FILL_SEG(mac_prot_reg_seg_hdr, mac_prot_regs);
+	FILL_SEG(xaui2_an_hdr, serdes2_xaui_an);
+	FILL_SEG(xaui2_hss_pcs_hdr, serdes2_xaui_hss_pcs);
+	FILL_SEG(xfi2_an_hdr, serdes2_xfi_an);
+	FILL_SEG(xfi2_train_hdr, serdes2_xfi_train);
+	FILL_SEG(xfi2_hss_pcs_hdr, serdes2_xfi_hss_pcs);
+	FILL_SEG(xfi2_hss_tx_hdr, serdes2_xfi_hss_tx);
+	FILL_SEG(xfi2_hss_rx_hdr, serdes2_xfi_hss_rx);
+	FILL_SEG(xfi2_hss_pll_hdr, serdes2_xfi_hss_pll);
+	FILL_SEG(sem_regs_seg_hdr, sem_regs);
+
+	kvfree(dump);
+	return err;
 }
 
 static const struct devlink_health_reporter_ops qlge_reporter_ops = {
-	.name = "dummy",
+	.name = "coredump",
 	.dump = qlge_reporter_coredump,
 };
 
-- 
2.28.0

