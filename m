Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F6A244C6C
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 18:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgHNQG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 12:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbgHNQG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 12:06:27 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1447C061384;
        Fri, 14 Aug 2020 09:06:27 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d188so4774049pfd.2;
        Fri, 14 Aug 2020 09:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M9WYMSFCbeF7C9ExAqegyXspvBxyQXIsGOMcSeUJlhg=;
        b=ckxVzYmW6qBd0JVZbHsJjnSLzl9GHV9AWn58gDa+vINwM1uyUvf1wGC00VRaYpSHiM
         Xebb/7YH4bvluR2fxfI8DJDFDy9+FZ8poKaUKkAfyYVGOMdyRYyc+dqAco7FQdi61XUS
         eoBPWBlckrw72LZBDBkdesfWm9eXI8hi5919nhPznwmZrZNUUbQII5gsmR6V3x5sqEAp
         A6LcUlWem8Y568W8ivGsPN4er9eUu/+9WO4V2Sma4wjscU4voVzytodlHww5iYxarAjV
         quNsendJWgcmBxc05/rPIGpiXt7ZqiiK6IbkMp8Fi6cFAhRCIkYdorPO3x4fy8R6mhw+
         8Rkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M9WYMSFCbeF7C9ExAqegyXspvBxyQXIsGOMcSeUJlhg=;
        b=tZfA+2oDu76zdPrrAu0DKLD+ERqwQP7qy+oei9fC9WDyeijEltnQaACe6n1q4LODjp
         DB349L82vWfaCMl8YfAjXKjxEyqCpIZW81+LNI2qJ7JnJ+ea8/o8ac4nZ3s9nicNmXw4
         B0qeYADlHCRyUYOMca/FF/+KQ71vgPtaUSKFYYtAjJ/TaEo/6TmifDAbZiTXKV3VfucR
         46jvQEm8zwr+Z4OY48Wa+B4luw3OhfrMkvWfVVJY8tUE4l0taM+4oYeWu8gFfdxcAJRU
         ZshzTGBHLSBBnJLq4Gx4aZdCEs6uomPuslrHeJAeaTfb4dXl/lL9mTbvarM1gmHj5OsA
         fQxg==
X-Gm-Message-State: AOAM531VUK9wx0enY7z+QIP46+MDDfj6JJrkpZPct0lJE0p0qaX9atoe
        XEFAFPqYGuo4+3rNhSX9vL2khN9TILKNZJ5qzBM=
X-Google-Smtp-Source: ABdhPJzt1deEqWJgPawUZm7NtKgaPyOxzzdwWgxurdy29nvP9UOCpO7sF9V0J+QmVkx+fBdyw4+iDw==
X-Received: by 2002:a63:fd11:: with SMTP id d17mr2174935pgh.272.1597421187050;
        Fri, 14 Aug 2020 09:06:27 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id z77sm10478394pfc.199.2020.08.14.09.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 09:06:26 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC 2/3] staging: qlge: coredump via devlink health reporter
Date:   Sat, 15 Aug 2020 00:06:00 +0800
Message-Id: <20200814160601.901682-3-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200814160601.901682-1-coiby.xu@gmail.com>
References: <20200814160601.901682-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

    $ devlink health dump show DEVICE reporter coredump -p -j
    {
        "Core Registers": {
            "segment": 1,
            "values": [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ]
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
 drivers/staging/qlge/qlge_health.c | 125 +++++++++++++++++++++++++++--
 1 file changed, 119 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/qlge/qlge_health.c b/drivers/staging/qlge/qlge_health.c
index 292f6b1827e1..a146cca6a3dc 100644
--- a/drivers/staging/qlge/qlge_health.c
+++ b/drivers/staging/qlge/qlge_health.c
@@ -1,16 +1,129 @@
 #include "qlge.h"
 #include "qlge_health.h"

-static int
-qlge_reporter_coredump(struct devlink_health_reporter *reporter,
-			struct devlink_fmsg *fmsg, void *priv_ctx,
-			struct netlink_ext_ack *extack)
+static int fill_seg_(struct devlink_fmsg *fmsg,
+		    struct mpi_coredump_segment_header *seg_header,
+		    u32 *reg_data)
 {
-	return 0;
+	int i;
+	int header_size = sizeof(struct mpi_coredump_segment_header);
+	int regs_num = (seg_header->seg_size - header_size) / sizeof(u32);
+	int err;
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
+#define fill_seg(seg_hdr, seg_regs)			       \
+	err = fill_seg_(fmsg, &dump->seg_hdr, dump->seg_regs); \
+	if (err) {					       \
+		kvfree(dump);                                  \
+		return err;				       \
+	}
+
+static int qlge_reporter_coredump(struct devlink_health_reporter *reporter,
+				  struct devlink_fmsg *fmsg, void *priv_ctx,
+				  struct netlink_ext_ack *extack)
+{
+	int err = 0;
+
+	struct qlge_devlink *dev = devlink_health_reporter_priv(reporter);
+	struct ql_adapter *qdev = dev->qdev;
+	struct ql_mpi_coredump *dump = kvmalloc(sizeof(struct ql_mpi_coredump),
+							GFP_KERNEL);
+	if (!dump)
+		return -ENOMEM;
+
+	err = ql_core_dump(qdev, dump);
+	if (err) {
+		kvfree(dump);
+		return err;
+	}
+
+	fill_seg(core_regs_seg_hdr, mpi_core_regs);
+	fill_seg(test_logic_regs_seg_hdr, test_logic_regs);
+	fill_seg(rmii_regs_seg_hdr, rmii_regs);
+	fill_seg(fcmac1_regs_seg_hdr, fcmac1_regs);
+	fill_seg(fcmac2_regs_seg_hdr, fcmac2_regs);
+	fill_seg(fc1_mbx_regs_seg_hdr, fc1_mbx_regs);
+	fill_seg(ide_regs_seg_hdr, ide_regs);
+	fill_seg(nic1_mbx_regs_seg_hdr, nic1_mbx_regs);
+	fill_seg(smbus_regs_seg_hdr, smbus_regs);
+	fill_seg(fc2_mbx_regs_seg_hdr, fc2_mbx_regs);
+	fill_seg(nic2_mbx_regs_seg_hdr, nic2_mbx_regs);
+	fill_seg(i2c_regs_seg_hdr, i2c_regs);
+	fill_seg(memc_regs_seg_hdr, memc_regs);
+	fill_seg(pbus_regs_seg_hdr, pbus_regs);
+	fill_seg(mde_regs_seg_hdr, mde_regs);
+	fill_seg(nic_regs_seg_hdr, nic_regs);
+	fill_seg(nic2_regs_seg_hdr, nic2_regs);
+	fill_seg(xgmac1_seg_hdr, xgmac1);
+	fill_seg(xgmac2_seg_hdr, xgmac2);
+	fill_seg(code_ram_seg_hdr, code_ram);
+	fill_seg(memc_ram_seg_hdr, memc_ram);
+	fill_seg(xaui_an_hdr, serdes_xaui_an);
+	fill_seg(xaui_hss_pcs_hdr, serdes_xaui_hss_pcs);
+	fill_seg(xfi_an_hdr, serdes_xfi_an);
+	fill_seg(xfi_train_hdr, serdes_xfi_train);
+	fill_seg(xfi_hss_pcs_hdr, serdes_xfi_hss_pcs);
+	fill_seg(xfi_hss_tx_hdr, serdes_xfi_hss_tx);
+	fill_seg(xfi_hss_rx_hdr, serdes_xfi_hss_rx);
+	fill_seg(xfi_hss_pll_hdr, serdes_xfi_hss_pll);
+
+	err = fill_seg_(fmsg, &dump->misc_nic_seg_hdr,
+		       (u32 *) &dump->misc_nic_info);
+	if (err) {
+		kvfree(dump);
+		return err;
+	}
+
+	fill_seg(intr_states_seg_hdr, intr_states);
+	fill_seg(cam_entries_seg_hdr, cam_entries);
+	fill_seg(nic_routing_words_seg_hdr, nic_routing_words);
+	fill_seg(ets_seg_hdr, ets);
+	fill_seg(probe_dump_seg_hdr, probe_dump);
+	fill_seg(routing_reg_seg_hdr, routing_regs);
+	fill_seg(mac_prot_reg_seg_hdr, mac_prot_regs);
+	fill_seg(xaui2_an_hdr, serdes2_xaui_an);
+	fill_seg(xaui2_hss_pcs_hdr, serdes2_xaui_hss_pcs);
+	fill_seg(xfi2_an_hdr, serdes2_xfi_an);
+	fill_seg(xfi2_train_hdr, serdes2_xfi_train);
+	fill_seg(xfi2_hss_pcs_hdr, serdes2_xfi_hss_pcs);
+	fill_seg(xfi2_hss_tx_hdr, serdes2_xfi_hss_tx);
+	fill_seg(xfi2_hss_rx_hdr, serdes2_xfi_hss_rx);
+	fill_seg(xfi2_hss_pll_hdr, serdes2_xfi_hss_pll);
+	fill_seg(sem_regs_seg_hdr, sem_regs);
+
+	kvfree(dump);
+	return err;
 }

 static const struct devlink_health_reporter_ops qlge_reporter_ops = {
-		.name = "dummy",
+		.name = "coredump",
 		.dump = qlge_reporter_coredump,
 };

--
2.27.0

