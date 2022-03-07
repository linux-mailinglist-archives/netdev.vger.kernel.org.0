Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F1E4CF02A
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 04:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbiCGD0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 22:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233660AbiCGD0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 22:26:17 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0FD5DE56
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 19:25:24 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id e15so10993156pfv.11
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 19:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=c+RLSIGNA4x5mC+oYvc0NpgJXwmnQqUo0F/3nFUaEyY=;
        b=NlZgPGISR73A3R5o6qW0xp7JZCWIF8bPH2RjmqD3N+bAzGN9JxLMImwHnra/7geXyJ
         mwnBPWLhYDhXA2O5LgaPKELSMzawlgP8o8VOBU6Jj9RqB8r1Z7iafDlWYzaTJ4WvdOfi
         SOYmX0MdvTMs2EB/PylU3bQQqWCnSU4rr0xyXUsnk5oOEHNbZ8B6JXsUHK66opY7oacL
         qfMuFEbr/Y60k3K3+hdT6iVGqeyoY5VR2jrxtpLPIM7UFGU7tDY2dnP9CP0W0M5GDvws
         jDjpKpJvQSzlSM9NzyC7F29YJOInT/z5ZbZ6H2koyUPTALv4lKRP919jTWovWt37b0YV
         LGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=c+RLSIGNA4x5mC+oYvc0NpgJXwmnQqUo0F/3nFUaEyY=;
        b=DwnLHQIi/t4qe6FGDGJqsILpBX7/AHHjxDzJRKuPzCJ5FW/EICtiuMmyLhGKB4lLjm
         EIHMIL5QZLQIzAJysiVfRrgvpQ/KEgXVLL9D56QgvzPpDZZYQxKuXPO/ROXqWcU7ZdCx
         ss+ZBogdsLhxuh009/CZyPrq/zLxJnNXAPgjN3fZ6j0VC2aJNnPcrIgKkFRXEA8ZY338
         w8ZOF2yb1cph3yx0J7CE8lVCk5v4bJA8BrSiM0UN/wTFMuHf1hDfRoSqzS8L23FKp40P
         Jh3mkYAAyxZob/09CdRfn8mIYwCiGyXv7O9/kOsSFgwMcByVFNsIQQu8zZE+tKkDp4SQ
         RsBw==
X-Gm-Message-State: AOAM53021aHZYrcvGqnqn/vH/rZwDjRtD2GNQjsFtrWHcqcJ+YpesM8u
        bsQUloZttPMmeEzlVBms4Qc=
X-Google-Smtp-Source: ABdhPJyVlvI6ry9D/8XOAwcCQuo0jLUiabGmIvtGK56uRvFgo8lf02brH0buJsj2p2cRYuPn822IPg==
X-Received: by 2002:a05:6a00:3024:b0:4f7:946:1164 with SMTP id ay36-20020a056a00302400b004f709461164mr1433909pfb.56.1646623524260;
        Sun, 06 Mar 2022 19:25:24 -0800 (PST)
Received: from meizu.meizu.com ([137.59.103.163])
        by smtp.gmail.com with ESMTPSA id t9-20020a656089000000b00372c36604a7sm10168120pgu.13.2022.03.06.19.25.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Mar 2022 19:25:23 -0800 (PST)
From:   Haowen Bai <baihaowen88@gmail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Haowen Bai <baihaowen88@gmail.com>
Subject: [PATCH] net: stmmac: Use max() instead of doing it manually
Date:   Mon,  7 Mar 2022 11:25:19 +0800
Message-Id: <1646623519-30588-1-git-send-email-baihaowen88@gmail.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following coccicheck warning:
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2806:42-43: WARNING opportunity for max()

Signed-off-by: Haowen Bai <baihaowen88@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 422e322..5989875 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2803,8 +2803,8 @@ static void stmmac_dma_interrupt(struct stmmac_priv *priv)
 {
 	u32 tx_channel_count = priv->plat->tx_queues_to_use;
 	u32 rx_channel_count = priv->plat->rx_queues_to_use;
-	u32 channels_to_check = tx_channel_count > rx_channel_count ?
-				tx_channel_count : rx_channel_count;
+	u32 channels_to_check = max(tx_channel_count, rx_channel_count);
+
 	u32 chan;
 	int status[max_t(u32, MTL_MAX_TX_QUEUES, MTL_MAX_RX_QUEUES)];
 
-- 
2.7.4

