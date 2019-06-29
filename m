Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9D55AC21
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 17:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfF2PRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 11:17:24 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46621 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbfF2PRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 11:17:21 -0400
Received: by mail-pl1-f193.google.com with SMTP id e5so4862679pls.13
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 08:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DdBOZMQMte7/vATnhsSg3hrI6/ByC93aZW5utxGWmMI=;
        b=fqDkHSt55Wcoc3uqCkqE9omzH926FJQ4PD42yPQJa37qRn7XuzEdrRBc1Dsx6HZPRo
         Y2DtPaDZsuSawYwJ3B7X0LrFL7wJ4JJOP6GKOFmS4DPAXrdkhm6Qp/pA/9/BHH+FbrKn
         bfvMEkK1AQTuazr2NPc/El+lTPhZUOUcZI88k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DdBOZMQMte7/vATnhsSg3hrI6/ByC93aZW5utxGWmMI=;
        b=oJ0NKinHb5FRpvZ1I1itaLrXjNMe+qDOpVvOJh/fUjBBWLHXzNsSc9rvI/Mnf709La
         Gt/3Y1HflUe+j+i63Hk4veAL8i5KsxM7/QWwaosS2q57/pQLJuPHZE9fbPvQggtY8WWP
         gsQ1/m5DugVdF/bMTU+T8mmrDbGIii3r4PLTv2CDB1cprUvX1Q1BNdoviKdQD2z+qYEt
         tp0LoWfU0Z1kLMYN//byCCE8Gvi1kJCTSns7QoFsbTSJWxsQAcw3sJ9n67zTRX3DsX32
         xENKqdi5SRTGjwWlF1i147rnc7Y4e3nDQKqBezypcrTIs59FEJ9mrqR9sU9r78kl3KLu
         gVqg==
X-Gm-Message-State: APjAAAVglskkq/plRwJHtvv+m+LBPRfllce0ajvD8fha9oQm57A+NsA+
        wDOvf/yFFAAqWLhrjiDV8RbHD+lAyHQ=
X-Google-Smtp-Source: APXvYqzH63Tu9mWIgxSbcvnzi4hZ9eWCvdByF95JYhS4XRpYlZZVmfnl4K0BrPvi0Ogmxoxw3iWtAQ==
X-Received: by 2002:a17:902:2ba7:: with SMTP id l36mr17945795plb.334.1561821441080;
        Sat, 29 Jun 2019 08:17:21 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z14sm5048233pgs.79.2019.06.29.08.17.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jun 2019 08:17:20 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 5/5] bnxt_en: Suppress error messages when querying DSCP DCB capabilities.
Date:   Sat, 29 Jun 2019 11:16:48 -0400
Message-Id: <1561821408-17418-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1561821408-17418-1-git-send-email-michael.chan@broadcom.com>
References: <1561821408-17418-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some firmware versions do not support this so use the silent variant
to send the message to firmware to suppress the harmless error.  This
error message is unnecessarily alarming the user.

Fixes: afdc8a84844a ("bnxt_en: Add DCBNL DSCP application protocol support.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
index 7077515..07301cb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
@@ -396,7 +396,7 @@ static int bnxt_hwrm_queue_dscp_qcaps(struct bnxt *bp)
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_QUEUE_DSCP_QCAPS, -1, -1);
 	mutex_lock(&bp->hwrm_cmd_lock);
-	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	rc = _hwrm_send_message_silent(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (!rc) {
 		bp->max_dscp_value = (1 << resp->num_dscp_bits) - 1;
 		if (bp->max_dscp_value < 0x3f)
-- 
2.5.1

