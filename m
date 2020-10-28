Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A3129E1CD
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgJ2CDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbgJ1VsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:48:03 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF23C0613D1;
        Wed, 28 Oct 2020 14:48:03 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id x1so1090952oic.13;
        Wed, 28 Oct 2020 14:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3zaGVF/vRB8F3ZfUMCb7b4cb/WN/x096ZDL+SPEx+Nc=;
        b=PgW57MjBfkv/pDJis6/z8OJ5FjZvPRloQO8Q8OaNappYffXSAsSfkcDzRsKG+GbBTv
         ITudr4QvE9TXbsG2R9Dyja7yX4JRx6RIdXGED3Xf7DHv/y+o3CtpwDlNgxnRLibWgTnl
         x/Qqhog2QHiU4BHKhuO0fjTSJDHPbz4JWsGR8MVcOzityq3d63V9dZhHtx1g4UZbFB1t
         yqPcJvJ83EEABZohcwrrSJO3DdAzlXHS76U344l1XT0RgDeRa8GNVZ4po7UiG3+3qecD
         fzR0ApV2PmWz3PVQueHSCMMBpv6LcAeDjqExX4zkJNIa/ou7auEea+splwDD8DeQK6d7
         GFpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3zaGVF/vRB8F3ZfUMCb7b4cb/WN/x096ZDL+SPEx+Nc=;
        b=gvaD/qOFg2/Ln3dq1K4jSJLzbdix5R3z3YKhkCu4jXE4BLBQLPHrXtLjE8zrUEfUKQ
         Tc2EJ/6gHsVQf2UdQQBTqMbxKrYMh2eSNyzOPk1+ZeQgjBRUqxkiTVxNSJyxuLCjKuYs
         1p8GJGCNnS7EjxEUoZHOgRnHRcM9gwGlWSq/DAC7jsouMU85MZb2/rx2xoUc8WE3SFdL
         gyqDmpQ02eOX9ojWtz7FGDNAF89ckegQ1h7x1AaWF3uRCKHL+zxYSdYeCHdPwDrnu/6Z
         RwmADQgtOpVaEawipsAxjEe1FiHuIe0AkPDyZb9kg/NAnVVmnVX+q+AbGWmmOWpXVEhx
         yjaA==
X-Gm-Message-State: AOAM533W/IEV3KQQE7+vhyvX4LybrtdJM6Kz6rGpuIZjZYtTVKhn/G5A
        ezzuEf4R6KhFlyHOrBgkIBMdsOqJETdRuyK6
X-Google-Smtp-Source: ABdhPJy4xaFFSb67eIdsE6yHQCjXYR1ulDiZ6JWAFabC/3uwCf7CfY4vHIFnetkjx6OwdcANGFeH+w==
X-Received: by 2002:a17:90a:e604:: with SMTP id j4mr6796905pjy.204.1603895135618;
        Wed, 28 Oct 2020 07:25:35 -0700 (PDT)
Received: from k5-sbwpb.flets-east.jp (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id 194sm6227192pfz.182.2020.10.28.07.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 07:25:35 -0700 (PDT)
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
Subject: [PATCH 1/3] mwifiex: disable ps_mode explicitly by default instead
Date:   Wed, 28 Oct 2020 23:24:31 +0900
Message-Id: <20201028142433.18501-2-kitakar@gmail.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201028142433.18501-1-kitakar@gmail.com>
References: <20201028142433.18501-1-kitakar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Microsoft Surface devices (PCIe-88W8897), the ps_mode causes
connection unstable, especially with 5GHz APs. Then, it eventually causes
fw crash.

This commit disables ps_mode by default instead of enabling it.

Required code is extracted from mwifiex_drv_set_power().

Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index d3a968ef21ef9..9b7b52fbc9c45 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -2333,14 +2333,19 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
 			return -1;
 
 		if (priv->bss_type != MWIFIEX_BSS_TYPE_UAP) {
-			/* Enable IEEE PS by default */
-			priv->adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_PSP;
+			/* Disable IEEE PS by default */
+			priv->adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_CAM;
 			ret = mwifiex_send_cmd(priv,
 					       HostCmd_CMD_802_11_PS_MODE_ENH,
-					       EN_AUTO_PS, BITMAP_STA_PS, NULL,
+					       DIS_AUTO_PS, BITMAP_STA_PS, NULL,
 					       true);
 			if (ret)
 				return -1;
+			ret = mwifiex_send_cmd(priv,
+					       HostCmd_CMD_802_11_PS_MODE_ENH,
+					       GET_PS, 0, NULL, false);
+			if (ret)
+				return -1;
 		}
 
 		if (drcs) {
-- 
2.29.1

