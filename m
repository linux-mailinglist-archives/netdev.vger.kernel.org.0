Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B94129D99D
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389888AbgJ1W6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389674AbgJ1W4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:56:36 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04DCC0613CF;
        Wed, 28 Oct 2020 15:56:35 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id h5so497641vsp.3;
        Wed, 28 Oct 2020 15:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1W1egpqxhCc2vFNc2hQUMgNWODq/0zt9Ds07G4ofZII=;
        b=L860scfczkA9wSqGF8yPqs+4WiGw0DM+CJZwafcORwp5SbVMjWFeMq9JVXbLPg2lBV
         Nid9jh7a/25hDSME6FajktPu2YumoQlg0etsK8T1nAPno57fImnqS1L4uQZFIpa+ugkE
         2ff83pu/V2XZ6aEtpzTu/k7VuSkqnJh8WxotME6RYiznbtL8ui5SbhYp1+TMhUk+bgrF
         LXePUR/BJ4RICmjwsgKuQPaZSGhOyBhHVOqKiwoCCt2UdlydAzUTGVNzMXEWNMknsrXG
         bzuqU3bUiW9g+uzC8D/AFev1KdPzfFRr1REUicJa80+naRpG7POHETI8mAHvA53V6+Y3
         1B6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1W1egpqxhCc2vFNc2hQUMgNWODq/0zt9Ds07G4ofZII=;
        b=E8kjsypGoE22B4KZ6g4w831gKx8pKHbpS2CzZKQty+49vcviNvdYAPZFBPJNwnTnFH
         IQp/tXEB/E8mNljTOwZg9gYMIOMEmz8UNmyyF4fL/jaImXlgw/JfTCdLizTkXRhlQJ8k
         TmXg1g/+06OzOwhhg0GUT4RtCv82WSRZ1eYC7hYNLuLCfs7LggGJsfY/Xw3EJiW8wGO/
         PDJ87P6LGZFaP1TY35G/LqLqDeqs3zOxHPr7NSXJSCLhJjuKCZeLCK5gvLNjUOUfaHoc
         ZnRcm4V5wkl0Zuo3hSo2b7yOORjhoLShH9dQ5/qQ6OkAYqjBjR0/lumB4Zcx34yqLQju
         SbYA==
X-Gm-Message-State: AOAM532xY4v55JYvamy0ikW7ZDwhxNRwp4F5pViB3Wr0UnkIjtIVOoOw
        F25dKBbJl/nqljVH2WZ9G9bHTVuxBDYjiPeD
X-Google-Smtp-Source: ABdhPJwMlV2jZahCPDR0hvozOQvyxC0uu6I4J/KblhnoJWL3KQonuUYAWQkVHMyNCSGBX5ls1W99Ug==
X-Received: by 2002:aa7:970f:0:b029:161:ee2d:bb9b with SMTP id a15-20020aa7970f0000b0290161ee2dbb9bmr7492181pfg.63.1603895224531;
        Wed, 28 Oct 2020 07:27:04 -0700 (PDT)
Received: from k5-sbwpb.flets-east.jp (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id jy19sm5311663pjb.9.2020.10.28.07.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 07:27:04 -0700 (PDT)
From:   Tsuchiya Yuto <kitakar@gmail.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl,
        Tsuchiya Yuto <kitakar@gmail.com>
Subject: [PATCH] mwifiex: pcie: add enable_device_dump module parameter
Date:   Wed, 28 Oct 2020 23:26:25 +0900
Message-Id: <20201028142625.18642-1-kitakar@gmail.com>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devicve_dump may take a little bit long time and users may want to
disable the dump for daily usage.

This commit adds a new module parameter enable_device_dump and disables
the device_dump by default.

Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 6a10ff0377a24..8254e06fb22ce 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -33,6 +33,11 @@
 
 static struct mwifiex_if_ops pcie_ops;
 
+static bool enable_device_dump;
+module_param(enable_device_dump, bool, 0644);
+MODULE_PARM_DESC(enable_device_dump,
+		 "enable device_dump (default: disabled)");
+
 static const struct mwifiex_pcie_card_reg mwifiex_reg_8766 = {
 	.cmd_addr_lo = PCIE_SCRATCH_0_REG,
 	.cmd_addr_hi = PCIE_SCRATCH_1_REG,
@@ -2938,6 +2943,12 @@ static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
 
 static void mwifiex_pcie_device_dump_work(struct mwifiex_adapter *adapter)
 {
+	if (!enable_device_dump) {
+		mwifiex_dbg(adapter, MSG,
+			    "device_dump is disabled by module parameter\n");
+		return;
+	}
+
 	adapter->devdump_data = vzalloc(MWIFIEX_FW_DUMP_SIZE);
 	if (!adapter->devdump_data) {
 		mwifiex_dbg(adapter, ERROR,
-- 
2.29.1

