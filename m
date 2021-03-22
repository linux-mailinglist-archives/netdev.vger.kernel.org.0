Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D54C34520E
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhCVVvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:51:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229467AbhCVVv3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 17:51:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D95426191D;
        Mon, 22 Mar 2021 21:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616449888;
        bh=vplW57jdS3sdwY5BYxTl7rROU7sS/6x0YoCPBkEaF7s=;
        h=From:To:Cc:Subject:Date:From;
        b=NFCk5pszFaz6NRayADSr2fVS3LN+m6B5SW1UewBb2lqJngOvQ8go3ziYYlwSZ6/hW
         wfcDgBrl64BQuCRy3cWqPldHbMqmanTm9YQeKuk0d/SAqB3E+Q2EbHtJ+Gitm6J44v
         LeZRod5vnYzD4XMzDtVYeseG7IBxTOQOqq+xPRP1X/FtjaSpqSz+Mur+YFaWzQOlj4
         eIps+pvMmz27xTm/XuIf6ODQI3kj0swcbV5jEh8xCBde/cVIdhNmuYJrMZmN8I2eMZ
         1EnMYr0YWxEqT4eIzwd/4Eg1KmIKpczFSC7WDERFdR0bpfdlN76GSGt0p3qaMr3TbD
         RipEFz6+4ptQA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Gregory Greenman <gregory.greenman@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] iwlwifi: fix old-style-declaration warning
Date:   Mon, 22 Mar 2021 22:51:16 +0100
Message-Id: <20210322215124.1078478-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The correct order is 'static const', not 'const static', as seen from
make W=1:

drivers/net/wireless/intel/iwlwifi/mvm/rfi.c:14:1: error: 'static' is not at beginning of declaration [-Werror=old-style-declaration]

Fixes: 21254908cbe9 ("iwlwifi: mvm: add RFI-M support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c b/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
index 873919048143..4d5a99cbcc9d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
@@ -11,7 +11,7 @@
  * DDR needs frequency in units of 16.666MHz, so provide FW with the
  * frequency values in the adjusted format.
  */
-const static struct iwl_rfi_lut_entry iwl_rfi_table[IWL_RFI_LUT_SIZE] = {
+static const struct iwl_rfi_lut_entry iwl_rfi_table[IWL_RFI_LUT_SIZE] = {
 	/* LPDDR4 */
 
 	/* frequency 3733MHz */
-- 
2.29.2

