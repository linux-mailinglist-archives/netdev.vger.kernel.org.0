Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597C331114C
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 20:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbhBERxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 12:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233390AbhBERtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 12:49:05 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA38FC06178C;
        Fri,  5 Feb 2021 11:30:48 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id v15so8947588wrx.4;
        Fri, 05 Feb 2021 11:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XrFiGb4s98X8FFWeanrSHmTuST16C6ouipnGlKmt0Hk=;
        b=bgHYb32YstYIHcrPptYiIA4Y0YMRkTcRTvt8VvsBpGi/fJgrvP927ZBv+p2ga3j3Nq
         GjQawqle76fC+iM8D+PlmcjXFdvQTMIeCzWNhdX242tWt5KHwwZzJQ5/+QXfqtDWx6/V
         0rRaCUvWzZ8G5C5gXL6lgydPSjzC2DLfDMBq0bOR3o2PB2B3TVQxd7lP7K/+uzsxFUGd
         hWvnQAQDrZXRcMNe+nHknuRIpC48u/llBf254ef2ZQyBj4l3nHhWMw31IAMRvsfLoxpe
         GX5TgLqKK37hNgy1H2MR1DHLUdxiav7OpRrV7AU+ZBG4mWyR0PUdBvyw+wwsf5oyuiMo
         Y79w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XrFiGb4s98X8FFWeanrSHmTuST16C6ouipnGlKmt0Hk=;
        b=li+R+1ZNP4NWFdyDhplsBY9z/Pq4zmO5kAeQ138LJdQIJ7dIvywfEyozrY35zKVTBZ
         QkE+nUvneWKrwpkFkLIOzJkl74U5bQhTpplWBdZ4MCkjVXiBMw4NRQ1pialCk4tmD7s4
         fdN6fQ+ojScEFFUsYg8SM1jmV1P3UJApEOQNQJ5YPXvoEAttEpNg+ZB5tcJ7NS0x5f/v
         VdWXk+Xif1iXSz0IRyEWiJ3D/bMragYvCUhAUXjW6inr4tXiD/mxw/TxwIYo5cFOai4r
         eeH9zul0kJcaehFJaWtr1nF23i/7g2fX4oVw14Y1bPw+GE9CKpWtUYkoeglsiGM49QmV
         fNvQ==
X-Gm-Message-State: AOAM5321w4U8S/7RC+iX4fzfwCwTf8y/B/VLFBFGuMO3cyRDml5kjYcQ
        tNkRqhHiJxXCa2cPZw8q6fmkPZr1AstFGg==
X-Google-Smtp-Source: ABdhPJxjpv7UVXJixjrpqYanv+ZmjNv5tgtJlrQQXXti5YUIdcqf10okJetJTeoYLucFqvspOfZVkA==
X-Received: by 2002:a5d:4204:: with SMTP id n4mr6860605wrq.196.1612553447331;
        Fri, 05 Feb 2021 11:30:47 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:11de:46a1:319f:d28? (p200300ea8f1fad0011de46a1319f0d28.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:11de:46a1:319f:d28])
        by smtp.googlemail.com with ESMTPSA id d3sm13854121wrp.79.2021.02.05.11.30.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 11:30:46 -0800 (PST)
Subject: [PATCH resend net-next v2 3/3] cxgb4: remove changing VPD len
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Raju Rangoju <rajur@chelsio.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <6658af1a-88fc-1389-0126-77201b4af2b3@gmail.com>
Message-ID: <782626be-d8e8-e7a6-849f-552941d3f924@gmail.com>
Date:   Fri, 5 Feb 2021 20:30:30 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <6658af1a-88fc-1389-0126-77201b4af2b3@gmail.com>
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



