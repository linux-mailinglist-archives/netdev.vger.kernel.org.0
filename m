Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1916A4357
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 14:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjB0Nww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 08:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjB0Nwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 08:52:51 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D8B173B;
        Mon, 27 Feb 2023 05:52:49 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id u5so3352714plq.7;
        Mon, 27 Feb 2023 05:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OFdbUl+sYIQgnR7y3RfQ5RiA+9IP39LqLOl/aV9q3zI=;
        b=EFzKKKAkCXggSiJtbusq0EjhbQls/15WMHchEJtsAXtQZv6S8jM2EOzCvxSZmKedLF
         9hC0a2bQRNjcJqTHaJeXS0oRaKpyYPli6Q77Da5dc9MUuLHsaJspvEaJu8Yr9Pfx2GdS
         5Pwwun7dsIiw1dAGpVat1fo4n6mqs8KGujVGZewSP7A0im+2h807SiaEdGJckMwiZreN
         egy5h+84pB0n5uIiPYRxSl+BMJxHDP91ClundBtQQVnNnbZKK+JTw9KqE+DCROPMRlbR
         iF8cQcgq4cO058Y0Jf/12U58OPFTY0V/koRyabAgOuNmTjX4EZf/zOQ81EdJSMLx+Vzn
         wHZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OFdbUl+sYIQgnR7y3RfQ5RiA+9IP39LqLOl/aV9q3zI=;
        b=uFwKNonBAYMg0juuD8TQZOIC13ClTjaW80sTiDQCuRDAi7ZjWo78GJyXpjtAtDs+oy
         f4HBumdSuM7czZqNIaoye/2G6nkjj5ujX8AH2opqv1n4UdRV8u8TnBHStdIjUw9s4pDX
         3wOv4vFRkGJqBR2gL8YrvOpmaYyXbkj/5JgguOlz9KOX3esMVWi+YLcWYQL0dP8TNvbX
         wx6NAaRtvygZOsfGDLXcL+CLsxXXXb5+kIpUUFswoB/tBIkG2QqCuCP3nETcfh+wW/ic
         hg1G7PKFfXvfnCNlPf06Chw+J508MrSV4EgnW598VE6WjYyuqP8rjT3SC2p849giWQVy
         oQ3w==
X-Gm-Message-State: AO0yUKUHadL1iHZMdYZ/eAgVhjSdbhHg4xl//EboG2tX+n4/21Df+/c0
        FGxLcbpeglIRMxfOTJTS8Oo=
X-Google-Smtp-Source: AK7set83IcOdxqMc3dSgY9xvLVXeXFCRBH+C6k4sHnlfwetrp7xrZQdP+3UsQYEDeXn1Sor/ZC4lEg==
X-Received: by 2002:a17:90b:3148:b0:237:c5cc:15bf with SMTP id ip8-20020a17090b314800b00237c5cc15bfmr8389013pjb.13.1677505968711;
        Mon, 27 Feb 2023 05:52:48 -0800 (PST)
Received: from localhost.localdomain ([103.116.245.58])
        by smtp.gmail.com with ESMTPSA id j191-20020a6380c8000000b004fb681ea0e1sm4115425pgd.84.2023.02.27.05.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 05:52:48 -0800 (PST)
From:   void0red <void0red@gmail.com>
To:     lorenzo.bianconi@redhat.com
Cc:     angelogioacchino.delregno@collabora.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, kvalo@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-wireless@vger.kernel.org,
        lorenzo@kernel.org, matthias.bgg@gmail.com, nbd@nbd.name,
        netdev@vger.kernel.org, pabeni@redhat.com, ryder.lee@mediatek.com,
        sean.wang@mediatek.com, shayne.chen@mediatek.com,
        void0red@gmail.com
Subject: [PATCH v2] wifi: mt76: add a check of vzalloc in mt7615_coredump_work
Date:   Mon, 27 Feb 2023 21:52:41 +0800
Message-Id: <20230227135241.947052-1-void0red@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <Y/yxGMvBbMGiehC6@lore-desk>
References: <Y/yxGMvBbMGiehC6@lore-desk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kang Chen <void0red@gmail.com>

vzalloc may fails, dump might be null and will cause
illegal address access later.

Fixes: d2bf7959d9c0 ("mt76: mt7663: introduce coredump support")
Signed-off-by: Kang Chen <void0red@gmail.com>
---
v2 -> v1: add Fixes tag

 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index a95602473..73d84c301 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -2367,6 +2367,9 @@ void mt7615_coredump_work(struct work_struct *work)
 	}
 
 	dump = vzalloc(MT76_CONNAC_COREDUMP_SZ);
+	if (!dump)
+		return;
+
 	data = dump;
 
 	while (true) {
-- 
2.34.1

