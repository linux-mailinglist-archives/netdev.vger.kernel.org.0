Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC003F37FF
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 04:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240896AbhHUCJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 22:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbhHUCJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 22:09:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BF0C061575;
        Fri, 20 Aug 2021 19:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=mcAGd4syBQmVvuYw/FXr91ofwKpJKCgF/Cq6zrQxiU0=; b=3WAo4n4liJuDkp4HI1U0WWfYzx
        WtJl1xf3E2gRSEflLuAI2lKmQTO0XBYfTy/2PTpeTpRNvTBuN0Jsnphq+VsilmVL2quUHug/gTuC3
        efyxNmKyv2GPNJBgh1EOZhYTNpB4wYD+xlxFI7HQx9GahzUQxwbQIfI/KD7cu8i+cN5P5pDlL5FhM
        w8MLtGlOiRZEkBsZn6Ef6rDW0GCiSf1PFJ78/iUgakH8L34/w3qhhPL08MXBbv0wFwTT1VxdFgYzL
        SeY7Op85StOgCrIaSQx9lo1i9UwCOplHpqD9WIXi3FRnHa0asgNsQ9/pIlAgRsM1j35TT6DwDzCg1
        EK2vc9PA==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mHGRS-00CNDA-II; Sat, 21 Aug 2021 02:09:02 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH -net] wireless: iwlwifi: fix printk format warnings in uefi.c
Date:   Fri, 20 Aug 2021 19:09:01 -0700
Message-Id: <20210821020901.25901-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel test robot reports printk format warnings in uefi.c, so
correct them.

../drivers/net/wireless/intel/iwlwifi/fw/uefi.c: In function 'iwl_uefi_get_pnvm':
../drivers/net/wireless/intel/iwlwifi/fw/uefi.c:52:30: warning: format '%zd' expects argument of type 'signed size_t', but argument 7 has type 'long unsigned int' [-Wformat=]
   52 |                              "PNVM UEFI variable not found %d (len %zd)\n",
      |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   53 |                              err, package_size);
      |                                   ~~~~~~~~~~~~
      |                                   |
      |                                   long unsigned int
../drivers/net/wireless/intel/iwlwifi/fw/uefi.c:59:29: warning: format '%zd' expects argument of type 'signed size_t', but argument 6 has type 'long unsigned int' [-Wformat=]
   59 |         IWL_DEBUG_FW(trans, "Read PNVM from UEFI with size %zd\n", package_size);
      |                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  ~~~~~~~~~~~~
      |                                                                    |
      |                                                                    long unsigned int

Fixes: 84c3c9952afb ("iwlwifi: move UEFI code to a separate file")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: linux-wireless@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20210820.orig/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ linux-next-20210820/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -49,14 +49,14 @@ void *iwl_uefi_get_pnvm(struct iwl_trans
 	err = efivar_entry_get(pnvm_efivar, NULL, &package_size, data);
 	if (err) {
 		IWL_DEBUG_FW(trans,
-			     "PNVM UEFI variable not found %d (len %zd)\n",
+			     "PNVM UEFI variable not found %d (len %lu)\n",
 			     err, package_size);
 		kfree(data);
 		data = ERR_PTR(err);
 		goto out;
 	}
 
-	IWL_DEBUG_FW(trans, "Read PNVM from UEFI with size %zd\n", package_size);
+	IWL_DEBUG_FW(trans, "Read PNVM from UEFI with size %lu\n", package_size);
 	*len = package_size;
 
 out:
