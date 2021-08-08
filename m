Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BDF3E391F
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 07:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhHHFsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 01:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhHHFsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 01:48:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F84C061760;
        Sat,  7 Aug 2021 22:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=OIwUtBzI6xerh1ScveYcE/N7s0JINLJAvmYDzzzUws8=; b=nc0czvcXFDGAR4wVT1YeGxW99+
        bfkJZ646yVaMBv09dgdgAekfc5dEjO0cN2TAlcxWSj0+Ef2ffjXLJ6OR2ku/17B61TaR/sJ+Dxh/A
        4KNJHw4tAWAp4+4yrY0DhNmR5s9viQ+HIONBKXdKOundsMMGW45UVq6bNfT1ikRSFr8lLEMRwpfit
        yrwcbtYoBPSt371S1ZzdjY82FMRJvtsBl7jxmEOUcNSyOGNKz1qRR/w1q8vtmES3O+RdcUVQicitJ
        hYCFvPwsC1KUB/ln3SVGQ/fwqgI3MzoH1Ai7y4y+Y+/ceytJnp7fQsa1ktetEcPmUR287VmzalgHw
        5Ur5+kTA==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mCbfh-00FYG3-Oz; Sun, 08 Aug 2021 05:48:29 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] wireless: iwlwifi: fix build warnings in rfi.c
Date:   Sat,  7 Aug 2021 22:48:22 -0700
Message-Id: <20210808054822.20846-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix one gcc "old-style-declaration" warning and one kernel-doc
warning.

drivers/net/wireless/intel/iwlwifi/mvm/rfi.c:14:1: warning: 'static' is not at beginning of declaration [-Wold-style-declaration]
      14 | const static struct iwl_rfi_lut_entry iwl_rfi_table[IWL_RFI_LUT_SIZE] = {

../drivers/net/wireless/intel/iwlwifi/mvm/rfi.c:11: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * DDR needs frequency in units of 16.666MHz, so provide FW with the

Fixes: 21254908cbe9 ("iwlwifi: mvm: add RFI-M support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Gregory Greenman <gregory.greenman@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20210806.orig/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
+++ linux-next-20210806/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
@@ -7,11 +7,11 @@
 #include "fw/api/commands.h"
 #include "fw/api/phy-ctxt.h"
 
-/**
+/*
  * DDR needs frequency in units of 16.666MHz, so provide FW with the
  * frequency values in the adjusted format.
  */
-const static struct iwl_rfi_lut_entry iwl_rfi_table[IWL_RFI_LUT_SIZE] = {
+static const struct iwl_rfi_lut_entry iwl_rfi_table[IWL_RFI_LUT_SIZE] = {
 	/* LPDDR4 */
 
 	/* frequency 3733MHz */
