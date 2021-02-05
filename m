Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD33311142
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 20:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbhBERv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 12:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbhBERtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 12:49:01 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454B2C06178B;
        Fri,  5 Feb 2021 11:30:45 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id t142so4727695wmt.1;
        Fri, 05 Feb 2021 11:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wxlenn/Tv/yLURp6IteuVrvWieBU43C0FAD9g2/etSo=;
        b=Z1hOhXliAerhhhmmqbssJjtibOWCfZ9z8qgzR5E/2L6Mn9BHJPyVYpv1p2Nw+PH1U/
         odlmfMnijZ1WuMlFHNGFbTwRDHY9hERIbHHdmqCuO/sRrTIWF+uW+se2WyB9zu+IxEHW
         Y0tA6kMied/QFO2y0l8c2j2dDixpHNqlYh7I1puxvxtzevifafZ6YrKL2whZh7e3fWEK
         7+y6wRjbN6CGsw1OaazesGCyKc6zIVXAK+2zMtr8RR1w0WDuK+jVbDmO2hono0BiQhnF
         F8tbl/oEmFoR2Rd0G/dBXt5P+HUuxQcTZwMjGgQFlHc5zjxAY2Up0Abgh5NMfT9TXsCN
         oIuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wxlenn/Tv/yLURp6IteuVrvWieBU43C0FAD9g2/etSo=;
        b=pszfv9MRkBf2xqXGxQenqNu/X8w1g8nfaImbFcbNys2hatFK1H4tRSt3V2xA0emCNh
         JOmgjOYwhvPA9XfJcHKeFiqA9zh3mdMsiyf298CcfVZ+4U3kRwRvcBBkWbga6a+JnaWO
         plTCyam+uunfQPTZ9SEB+wsD++K1Mus99d9Bx2vZ8+33JuC9Z/FyQs3fJXMtGNs/Px8y
         flojuJEzvmz1fwkL7aLaJE/e4kYkg0Qx6TD1rjztyWWM+ZjYRjkfFnre/oqaiGJcPKza
         eirHWthS8EHE+Hrr2SEWiLBAeIdwrgi8FiFltAvPTI8B7OHXBxVz5lAG/EGMOrXByySB
         s74w==
X-Gm-Message-State: AOAM5314KzzqsHCQqo0MSK0TgP34KY1BO9uEKoYqWuynkiURtw00Z5zP
        BcIEYc62A77/i91sqA2sD7pKYeyhERBJHQ==
X-Google-Smtp-Source: ABdhPJzncY0EuSqGZ6rXLfzFOF8pRlKs6s9GECJoG3UMdAsGMPzG9SYt3+lm37zFmYsPeJE0fSulrg==
X-Received: by 2002:a7b:cf33:: with SMTP id m19mr4848954wmg.53.1612553443819;
        Fri, 05 Feb 2021 11:30:43 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:11de:46a1:319f:d28? (p200300ea8f1fad0011de46a1319f0d28.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:11de:46a1:319f:d28])
        by smtp.googlemail.com with ESMTPSA id u10sm9206451wmj.40.2021.02.05.11.30.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 11:30:43 -0800 (PST)
Subject: [PATCH resend net-next v2 2/3] PCI/VPD: Change Chelsio T4 quirk to
 provide access to full virtual address space
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Raju Rangoju <rajur@chelsio.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <6658af1a-88fc-1389-0126-77201b4af2b3@gmail.com>
Message-ID: <6bf6319f-acaa-c114-d10b-cb9b7d469968@gmail.com>
Date:   Fri, 5 Feb 2021 20:29:45 +0100
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

cxgb4 uses the full VPD address space for accessing its EEPROM (with some
mapping, see t4_eeprom_ptov()). In cudbg_collect_vpd_data() it sets the
VPD len to 32K (PCI_VPD_MAX_SIZE), and then back to 2K (CUDBG_VPD_PF_SIZE).
Having official (structured) and inofficial (unstructured) VPD data
violates the PCI spec, let's set VPD len according to all data that can be
accessed via PCI VPD access, no matter of its structure.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/pci/vpd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/vpd.c b/drivers/pci/vpd.c
index 7915d10f9..06a7954d0 100644
--- a/drivers/pci/vpd.c
+++ b/drivers/pci/vpd.c
@@ -633,9 +633,8 @@ static void quirk_chelsio_extend_vpd(struct pci_dev *dev)
 	/*
 	 * If this is a T3-based adapter, there's a 1KB VPD area at offset
 	 * 0xc00 which contains the preferred VPD values.  If this is a T4 or
-	 * later based adapter, the special VPD is at offset 0x400 for the
-	 * Physical Functions (the SR-IOV Virtual Functions have no VPD
-	 * Capabilities).  The PCI VPD Access core routines will normally
+	 * later based adapter, provide access to the full virtual EEPROM
+	 * address space. The PCI VPD Access core routines will normally
 	 * compute the size of the VPD by parsing the VPD Data Structure at
 	 * offset 0x000.  This will result in silent failures when attempting
 	 * to accesses these other VPD areas which are beyond those computed
@@ -644,7 +643,7 @@ static void quirk_chelsio_extend_vpd(struct pci_dev *dev)
 	if (chip == 0x0 && prod >= 0x20)
 		pci_set_vpd_size(dev, 8192);
 	else if (chip >= 0x4 && func < 0x8)
-		pci_set_vpd_size(dev, 2048);
+		pci_set_vpd_size(dev, PCI_VPD_MAX_SIZE);
 }
 
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CHELSIO, PCI_ANY_ID,
-- 
2.30.0



