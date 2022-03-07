Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8EA04CF02D
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 04:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbiCGD2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 22:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234571AbiCGD22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 22:28:28 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D378F388B
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 19:27:35 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id gj15-20020a17090b108f00b001bef86c67c1so12797665pjb.3
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 19:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=QZxaEy7qHVPbNJa4qNbqDpfZunDqkw0YogYlV50GSVA=;
        b=qSU/0tBxVFo3s2Z4G33pFBsifpKnxkgjSwiBiIDNPw9AcNKQiRd5YLXagaBMfOeP/D
         q+MuyeHHJATLdm+QBSjP5wNztkSq6keHySHg4d+U2myaPv0p/cxzhSUbw2145ePJFl6h
         3EIaAYTXi1NZ8HEk7FlKjX4nRqm5s9y3qIcKYXdqdMpcycO1lxMZsFn9/efbOif+ELZL
         vP2sPJD9I0L/ccHhS0K7YVbhaTftOt8YuXWRaj/3Wt03rvSeTnxkPUT/XEe+/hd3JxGr
         W6XU8k+OMi1zb7lDjyusmaf4yX3ayio/Nr8PTffE8O01zicJFduDzvdaghEhg+99nZTK
         ZCOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QZxaEy7qHVPbNJa4qNbqDpfZunDqkw0YogYlV50GSVA=;
        b=LObxAcyugT9x7t/iMz/U5RBY5LIfATRx97lAhNNv82JOcPkcWHBPGtZoFRoGCDzjkH
         g9LC1JuUnHLQzIbAywqkvqQ3cXpzBhq8KSNhQplVWFtfKe4sn44ZSPw+lYvYtrg24qku
         pbIqhlAeMWMslTnuU+vhDHPlmSV/zf9pQcJAI3S1OcEZhbPsS3wKZH9/nznJV1TgFx2t
         e8MVP+e+WkOm5WMBB9m4QPRdiLSiayKD2lWEF58P8jpzTt9p5nb3DgX4ftaU2VWAcgTB
         RVVoJMYBRBWqNWGj+HpmXt5X7FJboslCueGF0sWk8DL+wW2/XOxE8CIYmYc6dRoBhzOy
         daqg==
X-Gm-Message-State: AOAM5315etSM4bg+WAWyozG9khbuzGDhNJPz0LDsSsodCBgTPN2/Svmj
        TY3Sa1AdC5VWgxOYZtS5120=
X-Google-Smtp-Source: ABdhPJyj6OoQkPO69a8yCpKa/Bd1tLPRkWUKfqnZzWeHHzVo4aD1S2o9e706aJ+x/YSjXIOZj9Mt3g==
X-Received: by 2002:a17:902:db0c:b0:151:ef4e:4d99 with SMTP id m12-20020a170902db0c00b00151ef4e4d99mr1625124plx.36.1646623655415;
        Sun, 06 Mar 2022 19:27:35 -0800 (PST)
Received: from meizu.meizu.com ([137.59.103.163])
        by smtp.gmail.com with ESMTPSA id o19-20020a056a0015d300b004f6e4dc74b5sm4867618pfu.92.2022.03.06.19.27.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Mar 2022 19:27:35 -0800 (PST)
From:   Haowen Bai <baihaowen88@gmail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Haowen Bai <baihaowen88@gmail.com>
Subject: [PATCH v2] net: stmmac: Use max() instead of doing it manually
Date:   Mon,  7 Mar 2022 11:27:31 +0800
Message-Id: <1646623651-31198-1-git-send-email-baihaowen88@gmail.com>
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
 	u32 chan;
 	int status[max_t(u32, MTL_MAX_TX_QUEUES, MTL_MAX_RX_QUEUES)];
 
-- 
2.7.4

