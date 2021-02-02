Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF38F30CD37
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 21:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbhBBUlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 15:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhBBUk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 15:40:57 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5E2C0613ED;
        Tue,  2 Feb 2021 12:40:17 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id a1so21883273wrq.6;
        Tue, 02 Feb 2021 12:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8aD1EJG8L7ZfKvZv8OiIzpjC2zKu/VqFxWL5/5e+V9I=;
        b=bxgbywt2px9FMutCT/DXUGOHsLcZXBC6lt0jqfjA+B913sjTfaubJKA3G8R6f+hxRB
         XtK8Bj94n1G/o6MBSIWy2KZLPZlzx0lIl8FqSVe5Pw6uPbFeu7js0G9oEzn8tUJQQ7Mf
         t+AhftgDo2d9dxdizZI3KnP+n+v2o0F0UoAFkRzcM8Ir315X28upx3qwXlCja8oCL52J
         ocfDk8dtYPiQCyPf7/eQVPuH03nSJ/oJjpHJaUtJeGXVhfsEzU5goRIjeM0kcN0aTajS
         PM9GuLL5eJ9MZm+8rmytH4tJQSDpDp7WFWElpLcs7nFOqaTY2QTS1Q1rwUFIXbODZZtb
         x6yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8aD1EJG8L7ZfKvZv8OiIzpjC2zKu/VqFxWL5/5e+V9I=;
        b=fKvVKWYnRx1tFbrfXiksNl3tja8CxmIuU1kPoJbV5shwCwPZY3SSpiXROatA1DQ+M1
         km97+mUjSx8JCXlr7zRn15NPgcnJBlMnsogJSj6+aBt4ro0ZoSHF9JNM178xYNaFYkoo
         LwS95KIpHuaA5SurGoXzW7pPjKPeCQnd7kL26KaCCnJMmVjcTSvjHVFNoNLVb1RydYpM
         9nqWagUAzJ2TQ114Bt9C6U8eajC+00+7qt3CGF9KGi4MLnhwAXRwKP58OCeuRhKuKlj9
         fWBwXwutg2/fs99NKxgIdDG7q6MD+uq+9BDxKhanLWNw59fnjBBwiG+S2CxdL+P/O+jn
         Khsg==
X-Gm-Message-State: AOAM532YW1XlEdBMNnP28pO2oLmllEK6KjCMzgBKXTOoj6ht4nZw6fXB
        ErwXFkXE+2eogcfbnIHCZDR8dIRo6x0=
X-Google-Smtp-Source: ABdhPJzXtHa597iQ6dnvhfTsRevLvGslOeT8z+bak4GYZifWLH4IGEhMwCyG2b3tHGxMxTaVgaiM/A==
X-Received: by 2002:a5d:6a85:: with SMTP id s5mr24599752wru.283.1612298415734;
        Tue, 02 Feb 2021 12:40:15 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:e887:ce1a:5d1d:a96e? (p200300ea8f1fad00e887ce1a5d1da96e.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:e887:ce1a:5d1d:a96e])
        by smtp.googlemail.com with ESMTPSA id r15sm33885094wrj.61.2021.02.02.12.40.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 12:40:15 -0800 (PST)
Subject: [PATCH net-next 4/4] cxgb4: remove changing VPD len
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Raju Rangoju <rajur@chelsio.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <b07dc99d-7fd0-48c0-3fc4-89cda90ee5d7@gmail.com>
Message-ID: <0a7ac2c0-8a63-f31c-9fbd-381a8fc59d18@gmail.com>
Date:   Tue, 2 Feb 2021 21:39:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <b07dc99d-7fd0-48c0-3fc4-89cda90ee5d7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the PCI VPD for Chelsio devices from T4 on has been changed and
VPD len is set to PCI_VPD_MAX_SIZE (32K), we don't have to change the
VPD len any longer.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 .../net/ethernet/chelsio/cxgb4/cudbg_entity.h |  1 -
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 21 ++++---------------
 2 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h b/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h
index 876f90e57..02ccb610a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h
@@ -220,7 +220,6 @@ struct cudbg_mps_tcam {
 	u8 reserved[2];
 };
 
-#define CUDBG_VPD_PF_SIZE 0x800
 #define CUDBG_SCFG_VER_ADDR 0x06
 #define CUDBG_SCFG_VER_LEN 4
 #define CUDBG_VPD_VER_ADDR 0x18c7
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
index 75474f810..addac5518 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
@@ -2689,7 +2689,7 @@ int cudbg_collect_vpd_data(struct cudbg_init *pdbg_init,
 	u32 scfg_vers, vpd_vers, fw_vers;
 	struct cudbg_vpd_data *vpd_data;
 	struct vpd_params vpd = { 0 };
-	int rc, ret;
+	int rc;
 
 	rc = t4_get_raw_vpd_params(padap, &vpd);
 	if (rc)
@@ -2699,24 +2699,11 @@ int cudbg_collect_vpd_data(struct cudbg_init *pdbg_init,
 	if (rc)
 		return rc;
 
-	/* Serial Configuration Version is located beyond the PF's vpd size.
-	 * Temporarily give access to entire EEPROM to get it.
-	 */
-	rc = pci_set_vpd_size(padap->pdev, EEPROMVSIZE);
-	if (rc < 0)
-		return rc;
-
-	ret = cudbg_read_vpd_reg(padap, CUDBG_SCFG_VER_ADDR, CUDBG_SCFG_VER_LEN,
-				 &scfg_vers);
-
-	/* Restore back to original PF's vpd size */
-	rc = pci_set_vpd_size(padap->pdev, CUDBG_VPD_PF_SIZE);
-	if (rc < 0)
+	rc = cudbg_read_vpd_reg(padap, CUDBG_SCFG_VER_ADDR, CUDBG_SCFG_VER_LEN,
+				&scfg_vers);
+	if (rc)
 		return rc;
 
-	if (ret)
-		return ret;
-
 	rc = cudbg_read_vpd_reg(padap, CUDBG_VPD_VER_ADDR, CUDBG_VPD_VER_LEN,
 				vpd_str);
 	if (rc)
-- 
2.30.0


