Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE804920A3
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 08:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236156AbiARH4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 02:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiARH4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 02:56:24 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5D4C061574;
        Mon, 17 Jan 2022 23:56:24 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id j85so21953146qke.2;
        Mon, 17 Jan 2022 23:56:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YDrGiU196Cd9X8NedR8qiHnQqpD4VsHuZ/+ks4ADMfE=;
        b=IZSIgNQ3HYbniwJOBLBGsLjGM/wwnlUFolM73KuBptdCrL9GQsG5l7c/b6u6ov4y/h
         zuw4lPhduwq3ra657cYq3JQ/B9bZNAHEJjmJoHmcr7leG/R/Uz0Xb8EZa4gFx2987FLX
         uEbiz7uvKA4p0cBp5hav32zkgsfJjlJXVWlHWh2eVycWYoFehmdfPMMom+uAiLz5AEpH
         PsKnAHO9++DQQnwwHAtz27FVywk+jE9jNLmRb4c6jJksGvm6Y6pOGbPYEPRQHo1x8vCE
         Zk3xORsa4fSWXbuvCKC/4YH95HUB92jxSkna2OBezRoxJXN4xNqKbzWK/eCWpf0FgFuf
         ep4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YDrGiU196Cd9X8NedR8qiHnQqpD4VsHuZ/+ks4ADMfE=;
        b=udfU3KfgyU+R+EYOqCkR84XdWt9TTmaFKigUInceGSLavCodiedtftvtqrYwzhOBQa
         rGbnANihUdeT/PzqDzeaBYFoK6Awvzv/FyQgE0hgXp4lPnidP3QX3zL/ElOD4KFITGv6
         ETHQ//uHrVapYTtJ4j86hI14aMNYFx8uQAoqxDcqZrXp5JttSsLGt71qC7fydhxLM/AW
         nRYD1hXapUCAYBPfqZK6uFrLsU/+xwc7Y+JzuqOlByfETFBNXUyNoDbj+m8FQMjKywBu
         z0qjhpFo/acqDEA1CG6UwvldsJUXDgNUrGbyZefvrU2biEGSby0TwTtb7GzOc1llTGb5
         NKKg==
X-Gm-Message-State: AOAM533q78fXyxsNNdCyIVO1YBhjYya6y56UlEEYkoj0PWu5whlVzeuV
        P5VEcH3CgdwlOrZ4WE64Qwc=
X-Google-Smtp-Source: ABdhPJy98/C2E2hSiMU++8nC4c0o0fitdU4AHLvYdR5zYFJbYUASSJfXeRvjEKrDErOahfdA3VEtFA==
X-Received: by 2002:a37:a948:: with SMTP id s69mr11193415qke.570.1642492583697;
        Mon, 17 Jan 2022 23:56:23 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id a16sm10274335qta.13.2022.01.17.23.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 23:56:23 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     ecree.xilinx@gmail.com
Cc:     habetsm.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, CGEL ZTE <cgel.zte@gmail.com>
Subject: [PATCH] sfc/ef10: remove unneeded rc variable
Date:   Tue, 18 Jan 2022 07:56:16 +0000
Message-Id: <20220118075616.925855-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Return value from efx_mcdi_rpc() directly instead
of taking this in another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
---
 drivers/net/ethernet/sfc/ef10.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index cf366ed2557c..991758292b7c 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -3627,7 +3627,6 @@ static int efx_ef10_rx_disable_timestamping(struct efx_channel *channel,
 					    bool temp)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_PTP_IN_TIME_EVENT_UNSUBSCRIBE_LEN);
-	int rc;
 
 	if (channel->sync_events_state == SYNC_EVENTS_DISABLED ||
 	    (temp && channel->sync_events_state == SYNC_EVENTS_QUIESCENT))
@@ -3646,10 +3645,8 @@ static int efx_ef10_rx_disable_timestamping(struct efx_channel *channel,
 	MCDI_SET_DWORD(inbuf, PTP_IN_TIME_EVENT_UNSUBSCRIBE_QUEUE,
 		       channel->channel);
 
-	rc = efx_mcdi_rpc(channel->efx, MC_CMD_PTP,
+	return efx_mcdi_rpc(channel->efx, MC_CMD_PTP,
 			  inbuf, sizeof(inbuf), NULL, 0, NULL);
-
-	return rc;
 }
 
 static int efx_ef10_ptp_set_ts_sync_events(struct efx_nic *efx, bool en,
-- 
2.25.1

