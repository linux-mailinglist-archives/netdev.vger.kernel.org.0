Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A828425275
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 14:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241140AbhJGMGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 08:06:53 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:48180
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231303AbhJGMGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 08:06:40 -0400
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 86B7840006
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 12:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633608285;
        bh=YbQ14jGkFrd5cVE7B20rk9z4X5SjheHPbtlwUglFswg=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=wSDcBwHKTFM+CzcoJxlpQvAX0KC5/B8dJQ/gb/qe7n6tHuTsYTcJg4uGsZLB+dUsu
         8dXSC/6MP0MDgPXS+pNDS95uo+Qv9mAWZqjnOAzkeB9BeDkALD/gO7vFNgfbLqxK85
         ldMRTRd4rTeLnO4RnBHiT+3paHst9gjXgkTHMxOa2uX4d79uG0XlUfVDNHmi2QX7oF
         JuI70Jjf5sMD9ln0t7OyI1X6UfwsuT6usLC1qOCZPv5zPFVac2DSq5h/0vAMyGrWNe
         YDtpPxJt16voBf5zYzyVHy8YDb5PnL05E4Ec24YWHkb1eRFwbeM/n7x3XXCaDCUwDK
         4jxFO85Jc6iRQ==
Received: by mail-pg1-f200.google.com with SMTP id n22-20020a6563d6000000b0029261ffde9bso3289044pgv.22
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 05:04:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YbQ14jGkFrd5cVE7B20rk9z4X5SjheHPbtlwUglFswg=;
        b=fH1WfS05c5D8UgFysEFfd5mUvVQxVimCzoAdOjlfkhXXiNv1FNXWxlqXkjuR9hoVW7
         nVdhko1b5A1p+4UlWsieKkn256pujH60bbxyZ4ouRM3mmUYtoEQXAeV5/O6X3oeIXw/G
         nYsgNnjW2davWF1Fyo6VNZBIlSaqQnKF0ZPZI1sVRWrRxliKAUUWQM66RozJnvZc0aXn
         GCaHqe/XYO4tqxXhunbl0qf4EHyQuW+GY8mtEMuTT/kZFeeKxzbiHkL3XmK9cEFZd2a6
         wVWWBx5l1n7z+sB0NupjZ3romCuepkiPydmluetB8nIJg+OJBMojMwlBBuBRvbeuY0mz
         EEbw==
X-Gm-Message-State: AOAM53008/Pyt/vjUIDmt6ytTPlPsQ4z6seSUxiCpXu6LLTdCa/udzo3
        JA8v+Kl44WqJJH5EbH5WXOQMhNVRmAQiU6AXwxVXLY2ls+MtqRzz/8/70yR0KH3cVoKffGU80ke
        NGnEHleCCt3KCdrVCnJFPNp8rLR5h40bJuA==
X-Received: by 2002:a63:4c5c:: with SMTP id m28mr3027879pgl.67.1633608283527;
        Thu, 07 Oct 2021 05:04:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHiZNAb241oCCwiqFrfpR6uZjW3GKfzxCOUU6/XE4t0x2GIQeJU/6lqla5VAFWAbn+IKTGdg==
X-Received: by 2002:a63:4c5c:: with SMTP id m28mr3027855pgl.67.1633608283272;
        Thu, 07 Oct 2021 05:04:43 -0700 (PDT)
Received: from localhost.localdomain ([69.163.84.166])
        by smtp.gmail.com with ESMTPSA id m2sm24386874pgd.70.2021.10.07.05.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 05:04:42 -0700 (PDT)
From:   Tim Gardner <tim.gardner@canonical.com>
To:     pkushwaha@marvell.com
Cc:     tim.gardner@canonical.com, Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shai Malin <smalin@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2][next] qed: Initialize debug string array
Date:   Thu,  7 Oct 2021 06:04:13 -0600
Message-Id: <20211007120413.8642-1-tim.gardner@canonical.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <MWHPR18MB10712FAF925C572621A5B1EDB2B19@MWHPR18MB1071.namprd18.prod.outlook.com>
References: <MWHPR18MB10712FAF925C572621A5B1EDB2B19@MWHPR18MB1071.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Coverity complains of an uninitialized variable.

CID 120847 (#1 of 1): Uninitialized scalar variable (UNINIT)
3. uninit_use_in_call: Using uninitialized value *sw_platform_str when calling qed_dump_str_param. [show details]
1344        offset += qed_dump_str_param(dump_buf + offset,
1345                                     dump, "sw-platform", sw_platform_str);

Fix this by removing dead code that references sw_platform_str.

Fixes: 6c95dd8f0aa1d ("qed: Update debug related changes")

Cc: Ariel Elior <aelior@marvell.com>
Cc: GR-everest-linux-l2@marvell.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Shai Malin <smalin@marvell.com>
Cc: Omkar Kulkarni <okulkarni@marvell.com>
Cc: Prabhakar Kushwaha <pkushwaha@marvell.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org (open list)
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

v2 - Arrive at the propoer fix per Prabhakar's suggestion.

---
 drivers/net/ethernet/qlogic/qed/qed_debug.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index 6d693ee380f1..f6198b9a1b02 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -1315,7 +1315,6 @@ static u32 qed_dump_common_global_params(struct qed_hwfn *p_hwfn,
 					 u8 num_specific_global_params)
 {
 	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
-	char sw_platform_str[MAX_SW_PLTAFORM_STR_SIZE];
 	u32 offset = 0;
 	u8 num_params;
 
@@ -1341,8 +1340,6 @@ static u32 qed_dump_common_global_params(struct qed_hwfn *p_hwfn,
 				     dump,
 				     "platform",
 				     s_hw_type_defs[dev_data->hw_type].name);
-	offset += qed_dump_str_param(dump_buf + offset,
-				     dump, "sw-platform", sw_platform_str);
 	offset += qed_dump_num_param(dump_buf + offset,
 				     dump, "pci-func", p_hwfn->abs_pf_id);
 	offset += qed_dump_num_param(dump_buf + offset,
-- 
2.33.0

