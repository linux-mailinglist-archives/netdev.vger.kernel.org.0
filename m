Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0E4423BD0
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 12:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238141AbhJFK5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 06:57:25 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:56812
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231240AbhJFK5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 06:57:23 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 16B823FFE5;
        Wed,  6 Oct 2021 10:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633517730;
        bh=8iImzst3oOFXm9Ridza0PRSEBpaLF5YlJ5ZO5d+yCY0=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=eVGkOwC/tJzoy7QmH2ZnvQG/p4Wv1R6BDazR8DhPxXur8GhKxFh5IYb4bjUC6nTHE
         l3PpoHoIgwufhajOGbxSBzmVT7YOGCCHV3LtqCfSkPqdZaa6JMjlWeptir81ksbg8q
         7okq/Y0A3XbAUwgRIw3Le6GbuZmWfqSAtLQ1GKsvedYBqLMZS/MYLHcHoPrxyFc1eN
         7s7SwDq19Z5rW5N78M5f24T2cxR5I31fsDPOubH/Q5L7i/kP5PoKgAnrkasTrVsX/j
         AQvEjTtPTq5CZo40v/duepkPStREF9a87GcwwxGyu8U3wt5gXW4LxtSNMKOuYB2QmQ
         MGleUrP35rXSg==
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Anilkumar Kolli <akolli@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ath11k: Remove redundant assignment to variable fw_size
Date:   Wed,  6 Oct 2021 11:55:29 +0100
Message-Id: <20211006105529.1011239-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variable fw_size is being assigned a value that is never read and
being re-assigned a new value in the next statement. The assignment
is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Fixes: 336e7b53c82f ("ath11k: clean up BDF download functions")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 8c615bc788ca..fa73118de6db 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -2135,7 +2135,6 @@ static int ath11k_qmi_load_bdf_qmi(struct ath11k_base *ab)
 
 	ath11k_dbg(ab, ATH11K_DBG_QMI, "qmi bdf_type %d\n", bdf_type);
 
-	fw_size = bd.len;
 	fw_size = min_t(u32, ab->hw_params.fw.board_size, bd.len);
 
 	ret = ath11k_qmi_load_file_target_mem(ab, bd.data, fw_size, bdf_type);
-- 
2.32.0

