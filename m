Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4902070E2
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 12:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388551AbgFXKNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 06:13:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56628 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388095AbgFXKNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 06:13:08 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jo2Os-0002ez-BZ; Wed, 24 Jun 2020 10:13:02 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] qed: add missing error test for DBG_STATUS_NO_MATCHING_FRAMING_MODE
Date:   Wed, 24 Jun 2020 11:13:02 +0100
Message-Id: <20200624101302.8316-1-colin.king@canonical.com>
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
 drivers/net/ethernet/qlogic/qed/qed_debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index 57a0dab88431..81e8fbe4a05b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -5568,7 +5568,8 @@ static const char * const s_status_str[] = {
 
 	/* DBG_STATUS_INVALID_FILTER_TRIGGER_DWORDS */
 	"The filter/trigger constraint dword offsets are not enabled for recording",
-
+	/* DBG_STATUS_NO_MATCHING_FRAMING_MODE */
+	"No matching framing mode",
 
 	/* DBG_STATUS_VFC_READ_ERROR */
 	"Error reading from VFC",
-- 
2.27.0

