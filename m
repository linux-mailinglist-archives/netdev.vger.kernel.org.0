Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF6A41612F
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 16:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241729AbhIWOkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241697AbhIWOkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 10:40:52 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EACFC061756
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 07:39:20 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id u8so26907945lff.9
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 07:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0mlMVaXOoaza4zpEQf4QOGWruwL5/rJrTk1sWJXn9w0=;
        b=SLumwzLRNExEFLu9sMs6Cof2q8CRLTDwZU/FIgVtUo2+K8A3mI/o+NU+qD4r3rbluR
         Ps41M/jUqoHkRq2SJk4voYsm/E61AysDXoqtSxAQNeZ2mVmS81NNZv4UN+EGdVPs4sSu
         MEneDnBWHrxkbV6XqXeskpY+RCGTElSeJO1sO6cTWIO5BGy28fTEUTK7DzoPLdxKyo92
         0/bAhp66MLMmKsaYlrP0Zl6WxaTMQ2j8M3aH4KHc/jK5grHjrWv1nEzWGG7koVhcy/Ud
         GL9hTlyg60V2isIkaw+z3UWtBn+lDWKn1b05Cwn8ogFVWtUdqWGScyQEr7XiInwM4cAz
         Ij6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0mlMVaXOoaza4zpEQf4QOGWruwL5/rJrTk1sWJXn9w0=;
        b=A4LwetEC57j0KzHVTA2rG/Ws0oL/1LBmVrkmXX6Vom+7fsFCU73Xp0QJMgFv5iGDqT
         SeT1Zfo+yo8GHJawwWdxoDTm6kVM1FgWtMEOAHnaxvAiaWRT1MUrXrhxVU2E1cuw2yEf
         yojxO/UDW4B6Filp9tWZdN01/zHdFsiEpdedhMY/bSAPbjQ6AcKSBn4DGAEAHbx385Oz
         CPStGtiMgBe2cIXFAGW27qW6MbTB03IP6afMVYazrujRa9qcyhT3wdzBIuJ+z5ERHyHU
         93QDZ+WCSv3NMiI8xPAQBCyhGlJJViF2ezbvKsU9ti/aiDbcGmvjp/AWVYMzEGyWQUTA
         9h1A==
X-Gm-Message-State: AOAM531DCtZQ5AqDEeqVvOuE+PqhkmwMYwSX+5mICIsCQUALQCoy3uKd
        kwz/XwehI6o+jFdxQ0rQybSF4ySASvJ1EzCV
X-Google-Smtp-Source: ABdhPJzD1FPkiqvrK8s+G5qLEgUnZEmweTx2/tIRg9JKgc6hWY5ZxQJBv5CyTf+F41BtAiyCcnYclg==
X-Received: by 2002:a05:6512:1189:: with SMTP id g9mr4452916lfr.661.1632407957225;
        Thu, 23 Sep 2021 07:39:17 -0700 (PDT)
Received: from localhost.localdomain (88-112-130-172.elisa-laajakaista.fi. [88.112.130.172])
        by smtp.gmail.com with ESMTPSA id s4sm601513ljp.115.2021.09.23.07.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 07:39:16 -0700 (PDT)
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Julien Wajsberg <felash@gmail.com>
Subject: [PATCH v2] iwlwifi: pcie: add configuration of a Wi-Fi adapter on Dell XPS 15
Date:   Thu, 23 Sep 2021 17:38:40 +0300
Message-Id: <20210923143840.2226042-1-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a Killer AX1650 2x2 Wi-Fi 6 and Bluetooth 5.1 wireless adapter
found on Dell XPS 15 (9510) laptop, its configuration was present on
Linux v5.7, however accidentally it has been removed from the list of
supported devices, let's add it back.

The problem is manifested on driver initialization:

  Intel(R) Wireless WiFi driver for Linux
  iwlwifi 0000:00:14.3: enabling device (0000 -> 0002)
  iwlwifi: No config found for PCI dev 43f0/1651, rev=0x354, rfid=0x10a100
  iwlwifi: probe of 0000:00:14.3 failed with error -22

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=213939
Fixes: 3f910a25839b ("iwlwifi: pcie: convert all AX101 devices to the device tables")
Cc: Julien Wajsberg <felash@gmail.com>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
---
Changes from v1 to v2:
* moved the added lines in a way to preserve a numerical order by devid.

 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 61b2797a34a8..3744c5e76519 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -547,6 +547,8 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 	IWL_DEV_INFO(0x43F0, 0x0074, iwl_ax201_cfg_qu_hr, NULL),
 	IWL_DEV_INFO(0x43F0, 0x0078, iwl_ax201_cfg_qu_hr, NULL),
 	IWL_DEV_INFO(0x43F0, 0x007C, iwl_ax201_cfg_qu_hr, NULL),
+	IWL_DEV_INFO(0x43F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0, NULL),
+	IWL_DEV_INFO(0x43F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0, NULL),
 	IWL_DEV_INFO(0x43F0, 0x2074, iwl_ax201_cfg_qu_hr, NULL),
 	IWL_DEV_INFO(0x43F0, 0x4070, iwl_ax201_cfg_qu_hr, NULL),
 	IWL_DEV_INFO(0xA0F0, 0x0070, iwl_ax201_cfg_qu_hr, NULL),
-- 
2.33.0

