Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71F2362E50
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 09:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235747AbhDQH3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 03:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhDQH3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 03:29:41 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB75C061574;
        Sat, 17 Apr 2021 00:29:13 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id g35so20640473pgg.9;
        Sat, 17 Apr 2021 00:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rh+LLyuUC21RXq9XkEfu7UxePoJYFAfS/R5i3+yiN0Q=;
        b=iVJmcFdZElVJ0EKUFNmO1njWxmViHa4WdBL2LMETXZ5WIpnYw7CfQsYalBwktpcMMy
         gbtBsAUrdBdhZd0tjEziYUD1ep4LwiOr5Q4hxr7QVjA14eiAIeQcylklfyPHGuXr8Vgo
         UrApGFC472p97VeERD+LNJccD1eInp4HAJzfqP68d52DA1V5iXQSZBnu0/4iaVLTNntI
         GyQcd1WPeyZWUGS4Qoiikg1QI4ta35z5rff5FkDAxQYkzCbb85+tuUXbdjxKmqR9Kdma
         4VJNtYnH/5teEg70XsTXmqwqn2tLoDr+VYQhnLpblWE2CubQ27CdG62hx3FQmZi42yVk
         wZqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rh+LLyuUC21RXq9XkEfu7UxePoJYFAfS/R5i3+yiN0Q=;
        b=C/TkKMiyEht5FInvT1ZqybHB6gzMfhqCJvmXXAVuDx0vOyi91fKsfA15Zyi63oGMqe
         jz/Rxcda1O65aRk6kR7bnMgJfQx6KRT/6vGBd/T3UTasZsZqZXdqFpeCoANS0VwLK3dS
         bsa1JOoZZKpHZmDZJWvl5Pf3o84+3ciLkYwdp5DTOnrpAx8inIv8BscD1QpTMuz7xhjD
         1LTtwDks76H+W4GuQ2ZnZSOe64i/7PJj8mS1JXd34ZT9PDKV10s9tzCziJb4TPUygMwU
         bAG5C4tK6OIMBAlKH1ChplQz72E6/cf/32ack1hf3DvKCZB9Pdltu0ICVPqiriLwBGJS
         rtFg==
X-Gm-Message-State: AOAM532Xx9CR4ECE+dgTrPgYCeLUEjRl/8FGpiLKoFJwoulKxtteytI0
        e8OOF55EFXN5f+So78xe28g=
X-Google-Smtp-Source: ABdhPJyX5O5Y7rZAeFbAE5I2m5OdbcRi0PgfKsEPGOCc3ns6NqxQGWMZA08UHuCSwwLHsmiO4OTO5w==
X-Received: by 2002:a65:5b85:: with SMTP id i5mr2406337pgr.269.1618644553283;
        Sat, 17 Apr 2021 00:29:13 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id a7sm6125860pfg.65.2021.04.17.00.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Apr 2021 00:29:12 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Alex Ryabchenko <d3adme4t@gmail.com>
Subject: [PATCH v2 net-next] net: ethernet: mediatek: fix a typo bug in flow offloading
Date:   Sat, 17 Apr 2021 15:29:04 +0800
Message-Id: <20210417072905.207032-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Issue was traffic problems after a while with increased ping times if
flow offload is active. It turns out that key_offset with cookie is
needed in rhashtable_params but was re-assigned to head_offset.
Fix the assignment.

Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
v1 -> v2:
  Refined commit message according to Frank.

 drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 4975106fbc42..f47f319f3ae0 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -43,7 +43,7 @@ struct mtk_flow_entry {
 
 static const struct rhashtable_params mtk_flow_ht_params = {
 	.head_offset = offsetof(struct mtk_flow_entry, node),
-	.head_offset = offsetof(struct mtk_flow_entry, cookie),
+	.key_offset = offsetof(struct mtk_flow_entry, cookie),
 	.key_len = sizeof(unsigned long),
 	.automatic_shrinking = true,
 };
-- 
2.25.1

