Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39B91C662D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 05:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgEFDBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 23:01:03 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55250 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726218AbgEFDBC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 23:01:02 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3C8795AAED89BAE394F0;
        Wed,  6 May 2020 11:01:00 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Wed, 6 May 2020 11:00:53 +0800
From:   Samuel Zou <zou_wei@huawei.com>
To:     <johannes.berg@intel.com>, <emmanuel.grumbach@intel.com>,
        <luciano.coelho@intel.com>, <linuxwifi@intel.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Samuel Zou <zou_wei@huawei.com>
Subject: [PATCH -next] iwlwifi: pcie: Use bitwise instead of arithmetic operator for flags
Date:   Wed, 6 May 2020 11:07:03 +0800
Message-ID: <1588734423-33988-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This silences the following coccinelle warning:

"WARNING: sum of probable bitmasks, consider |"

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Samuel Zou <zou_wei@huawei.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index a0daae0..6d9bf9f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -109,9 +109,9 @@ void iwl_trans_pcie_dump_regs(struct iwl_trans *trans)
 
 	/* Alloc a max size buffer */
 	alloc_size = PCI_ERR_ROOT_ERR_SRC +  4 + PREFIX_LEN;
-	alloc_size = max_t(u32, alloc_size, PCI_DUMP_SIZE + PREFIX_LEN);
-	alloc_size = max_t(u32, alloc_size, PCI_MEM_DUMP_SIZE + PREFIX_LEN);
-	alloc_size = max_t(u32, alloc_size, PCI_PARENT_DUMP_SIZE + PREFIX_LEN);
+	alloc_size = max_t(u32, alloc_size, PCI_DUMP_SIZE | PREFIX_LEN);
+	alloc_size = max_t(u32, alloc_size, PCI_MEM_DUMP_SIZE | PREFIX_LEN);
+	alloc_size = max_t(u32, alloc_size, PCI_PARENT_DUMP_SIZE | PREFIX_LEN);
 
 	buf = kmalloc(alloc_size, GFP_ATOMIC);
 	if (!buf)
-- 
2.6.2

