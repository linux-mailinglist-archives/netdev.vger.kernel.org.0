Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24F829DFCE
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404209AbgJ2BEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 21:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728543AbgJ1WGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:06:09 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D13C0613CF;
        Wed, 28 Oct 2020 15:06:08 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id p7so1151611ioo.6;
        Wed, 28 Oct 2020 15:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AMavcgab6f/G1LUhaSL/VnJNMSO60VRuV52F7ID9Z1w=;
        b=EEBx/en4jUjbpcytmaGqmQqZoK88eThP+DK9XrxHaN1SQ97f4DrSYomDP9X0SkW/q0
         0Ber+eFxG+cd5uPhS9kdMvcxwOsNyvUepSmCzF0TsiaP4hVWzXTUgLvgS/dMFSOxyzGk
         16u+I0XQc8qsTHSPvYyz4rHV/3lQF3ThUC3tsDsCPS7dA5Ch0eGbrwSUZZ0hL3TNeOZG
         CN+mzBK34uZp1FOpOIHpgudSrBlFlgzn5ZeXE3KM3F4rVihVfxpyLVG39v8DBIYrtkyE
         jP4hkiJ1Zb4zzHVZo4l6i5dRHdIorBBpHSNi4Xnn8MEx3bY91Z+6rCAstCz6GCl+fxKY
         ymrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AMavcgab6f/G1LUhaSL/VnJNMSO60VRuV52F7ID9Z1w=;
        b=CKpYiUzKGjXL4CxtU6+GaP15fd6Xsqjtz/dqg2P6v2vodl49iA5RdZr4bSTV2cy3iq
         dDGX8FUFw7YMQtmDKOSZqmTLmMMc6SbFohuC0uRg8/dPmhHvjf1BcQSlHvjsyQnGjGFm
         PO/UnaQuUbBrWTzN9BLdxsAKQNQzZ3w7gG3ikuLPaNCy6GuHmgyFhVRSb2Lfmr8qHkKG
         vyPvBQwGayPlrdRRB4rwyd8/xg4a7ir6gcrv9BOCwY1HddWTFv4js6LL8QMRdQRndrjJ
         WDjJCvVJohq3qmvoiFy9Qu615C/JZqc39FQ/l8nKsda9eP/sli9WSfkSz2sDPW81acKZ
         2C9Q==
X-Gm-Message-State: AOAM530SG7VqaJa7OiXisKna++lsnFpXsOKaIaweltNijmCeZU1ZQYhU
        nQtB9MEYCrhWfa5sFo05UoYfxYh0LodR5Nde
X-Google-Smtp-Source: ABdhPJxizRPARCHdEsCXjgrcYCTJx2PzRg4bj6IZWfYbOoEie0tP3vFgu3sgYYebDUS52otqnjvptw==
X-Received: by 2002:a65:62ca:: with SMTP id m10mr6618468pgv.407.1603894962096;
        Wed, 28 Oct 2020 07:22:42 -0700 (PDT)
Received: from k5-sbwpb.flets-east.jp (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id c12sm6293543pgi.14.2020.10.28.07.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 07:22:41 -0700 (PDT)
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
Subject: [PATCH 1/2] mwifiex: fix mwifiex_shutdown_sw() causing sw reset failure
Date:   Wed, 28 Oct 2020 23:21:09 +0900
Message-Id: <20201028142110.18144-2-kitakar@gmail.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201028142110.18144-1-kitakar@gmail.com>
References: <20201028142110.18144-1-kitakar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When FLR is performed but without fw reset for some reasons (e.g. on
Surface devices, fw reset requires another quirk), it fails to reset
properly. You can trigger the issue on such devices via debugfs entry
for reset:

    $ echo 1 | sudo tee /sys/kernel/debug/mwifiex/mlan0/reset

and the resulting dmesg log:

    [   45.740508] mwifiex_pcie 0000:03:00.0: Resetting per request
    [   45.742937] mwifiex_pcie 0000:03:00.0: info: successfully disconnected from [BSSID]: reason code 3
    [   45.744666] mwifiex_pcie 0000:03:00.0: info: shutdown mwifiex...
    [   45.751530] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
    [   45.751539] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
    [   45.771691] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
    [   45.771695] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
    [   45.771697] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
    [   45.771698] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
    [   45.771699] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
    [   45.771701] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
    [   45.771702] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
    [   45.771703] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
    [   45.771704] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
    [   45.771705] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
    [   45.771707] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
    [   45.771708] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
    [   53.099343] mwifiex_pcie 0000:03:00.0: info: trying to associate to '[SSID]' bssid [BSSID]
    [   53.241870] mwifiex_pcie 0000:03:00.0: info: associated to bssid [BSSID] successfully
    [   75.377942] mwifiex_pcie 0000:03:00.0: cmd_wait_q terminated: -110
    [   85.385491] mwifiex_pcie 0000:03:00.0: info: successfully disconnected from [BSSID]: reason code 15
    [   87.539408] mwifiex_pcie 0000:03:00.0: cmd_wait_q terminated: -110
    [   87.539412] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
    [   99.699917] mwifiex_pcie 0000:03:00.0: cmd_wait_q terminated: -110
    [   99.699925] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
    [  111.859802] mwifiex_pcie 0000:03:00.0: cmd_wait_q terminated: -110
    [  111.859808] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
    [...]

When comparing mwifiex_shutdown_sw() with mwifiex_pcie_remove(), it
lacks mwifiex_init_shutdown_fw().

This commit fixes mwifiex_shutdown_sw() by adding the missing
mwifiex_init_shutdown_fw().

Fixes: 4c5dae59d2e9 ("mwifiex: add PCIe function level reset support")
Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 9ba8a8f64976b..6283df5aaaf8b 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1471,6 +1471,8 @@ int mwifiex_shutdown_sw(struct mwifiex_adapter *adapter)
 	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 	mwifiex_deauthenticate(priv, NULL);
 
+	mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
+
 	mwifiex_uninit_sw(adapter);
 	adapter->is_up = false;
 
-- 
2.29.1

