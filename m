Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6413420A343
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 18:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406465AbgFYQpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 12:45:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55632 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404697AbgFYQpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 12:45:10 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1joUzp-00048R-IT; Thu, 25 Jun 2020 16:45:05 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH][V2] qed: add missing error test for DBG_STATUS_NO_MATCHING_FRAMING_MODE
Date:   Thu, 25 Jun 2020 17:45:05 +0100
Message-Id: <20200625164505.115425-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The error DBG_STATUS_NO_MATCHING_FRAMING_MODE was added to the enum
enum dbg_status however there is a missing corresponding entry for
this in the array s_status_str. This causes an out-of-bounds read when
indexing into the last entry of s_status_str.  Fix this by adding in
the missing entry.

Addresses-Coverity: ("Out-of-bounds read").
Fixes: 2d22bc8354b1 ("qed: FW 8.42.2.0 debug features")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---

V2: use the error message as suggested by Igor Russkikh

---
 drivers/net/ethernet/qlogic/qed/qed_debug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index 57a0dab88431..d9dfaf214f6b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -5569,6 +5569,8 @@ static const char * const s_status_str[] = {
 	/* DBG_STATUS_INVALID_FILTER_TRIGGER_DWORDS */
 	"The filter/trigger constraint dword offsets are not enabled for recording",
 
+	/* DBG_STATUS_NO_MATCHING_FRAMING_MODE */
+	"No matching framing mode found for the enabled blocks/Storms - use less dwords for blocks data",
 
 	/* DBG_STATUS_VFC_READ_ERROR */
 	"Error reading from VFC",
-- 
2.27.0

