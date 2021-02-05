Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336783114E3
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbhBEWRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbhBEOcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:32:16 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B1FC061222;
        Fri,  5 Feb 2021 08:09:19 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id c6so9422269ede.0;
        Fri, 05 Feb 2021 08:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XrFiGb4s98X8FFWeanrSHmTuST16C6ouipnGlKmt0Hk=;
        b=TeA04exmhdK8CwkVcVfIrvYN8A/vC8+PT4oCJhQv/Hkz5dLDaEaGJlEO6X4ZY52qu3
         DjQwH2+IwZgc/QTJgSSdT6OuOww8SAoioHrPJwvanB7V+XQgv9528+dogteXJaO+02Jw
         5rBLv3iFBcY3INfCZvD+OAhsDTfM7/iFMjDTPNd5bdvxFF7lfZDFsAwOiX1bjiZiDQex
         IMHhY3XeXztkTMlZWRhGEIAJ/IGcWryX0qvW5vTsEp+72V4yX22baKLGglRjm6DJM1oQ
         tar2TT3ner5KYYAsoMOUMvAv3Yv0ZT75sLSQDLm7mbJHGV3XIgo7PowFxo/C/RqyH+xs
         QPpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XrFiGb4s98X8FFWeanrSHmTuST16C6ouipnGlKmt0Hk=;
        b=hdKynnhGTpzg8Av5e9+7Aq3ZugNO4nQERvOf8ur2Cayx2yAR59CwjfbWQbfLAtm3MA
         oFCftN1ouY660ZkF6uA5cczgxgWyWCjRTtjMJytv0/NNRsKxIogBwPfbuiHy8SXgX3jN
         akpBXul6iUwKYQuwqWEGLUPCtMb2VV9txZqiFd1X5Rf+/ltgUblkDTOSEnHmAMAxDSqF
         b//oEYgX7fPYXXxuYy5lWK5Zk+Y5w3CtFS2hJ5Ns3q7Z+DxJEYl2NgPf8vGS+DXo8Njt
         qLeWjzpLiU9/0vwIurzk95a6Q1IwgB4cDEuXcIac27u34q8KfURoFLcYNe+652R3OFIm
         jVLw==
X-Gm-Message-State: AOAM530u8XGTYQtWraEUd9qLg7AeWC6chsr21vf/mVi2w3LUXGYe0PEy
        /ZoU3OiDrQ2l+W0o7Oh/sGuEafE4hPZQfw==
X-Google-Smtp-Source: ABdhPJyRiNFjoyAZIP4kvF/mH6laIlKd/ow9c7yk++Q4WoxsGDAMaKmRuj+6vRJPyr3xz0txYPaU4w==
X-Received: by 2002:a5d:5111:: with SMTP id s17mr5270890wrt.331.1612535256274;
        Fri, 05 Feb 2021 06:27:36 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:9118:8653:7e7:879e? (p200300ea8f1fad009118865307e7879e.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:9118:8653:7e7:879e])
        by smtp.googlemail.com with ESMTPSA id j7sm13275057wrp.72.2021.02.05.06.27.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 06:27:35 -0800 (PST)
Subject: [PATCH net-next v2 3/3] cxgb4: remove changing VPD len
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Raju Rangoju <rajur@chelsio.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <8edfa4ae-1e78-249d-14fb-0e44a2c51864@gmail.com>
Message-ID: <90961c36-b345-5a7c-5ae8-c7c2311b56a8@gmail.com>
Date:   Fri, 5 Feb 2021 15:27:32 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <8edfa4ae-1e78-249d-14fb-0e44a2c51864@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the PCI VPD for Chelsio devices from T4 has been changed and VPD
len is set to PCI_VPD_MAX_SIZE (32K), we don't have to change the VPD len
any longer.

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


