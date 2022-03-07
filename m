Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE0F4D0B1B
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 23:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343755AbiCGWd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 17:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbiCGWd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 17:33:26 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CE4DEA9;
        Mon,  7 Mar 2022 14:32:29 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id j17so25675010wrc.0;
        Mon, 07 Mar 2022 14:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DwDl1ku4FUR5Ozi9oblunGojtzeBv0vdXYXme8GlGQY=;
        b=IUNi9+FI52U0cv+PUG+qweTy8nwwW48D9CMfQGeCE47bUPz2LBvDbUVxBiZIrEeLAz
         Y7sR06LdemXXT5m4g8hKzaOmFxiEUXwB8mkmWjomvZzIB5RuCLTX5yLhDZQMGeoSXCin
         qJB0nfLdQ3d1uj7JiN5obuaX9OQ1qVHZbtgdqnQVUiC7yIBS5VZSnVjpuDh4gtkSQFH5
         wX2ZM8E5srFPFwF+lcgJabZ3d7dspb7oltIkZ0ljVyFShpj4vm+IGO/KrfaLGkXZiTQO
         SZ4mWbwAP0XXMQ5KLIqe0izjLvsNdT1Jb3g0pZH8nxYtsfj1ISua+a+kyK4tgcubjtt7
         6PmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DwDl1ku4FUR5Ozi9oblunGojtzeBv0vdXYXme8GlGQY=;
        b=B3oaGj/E1F0kzWUQ/0AHW8cxfWz8/pzzMfdQhsjbz2Ea5+haR20O0e+9KV1joG/KjO
         ByqzLLVvIrmii12lhQWDC4mKMn0qgsrDk+YLaHDsNjaroqqNfHTooQq4n2L5qRX6/Iz5
         3fikP+EN3MkIXX0RdRibk1+40ACYufERAPuXX2lcfb8rsgNtKQUqN+3/xPL7Df5iX2LT
         ZpmD4cMb97jz5BEHIduy2gWmgAi91buPJPYkE4uPOBRTgCSNXdoEepJM1Luxa78tPLDk
         hRDlgwpsEAVciN9spBeFKBQG4672voNlBsLX+ke5q+LHZ1cuY0hhhKQ8sJZxZPviCOwB
         +K7A==
X-Gm-Message-State: AOAM533bN/dxD8dh1sZiTnsJp+jH+m5ypXBOZ0WGqXU7fKSC0QO0Aplc
        /JGiJXnh2PLP5iLaVICvzlw=
X-Google-Smtp-Source: ABdhPJxNaqxuh9UAePJwBUcDhV11+dIihM3RKCeeagx9+lhDMIFNlTBCNlLdHLPx6C1jU9UeY9Qe+Q==
X-Received: by 2002:a05:6000:2c5:b0:1f0:6657:5601 with SMTP id o5-20020a05600002c500b001f066575601mr10178060wry.629.1646692348638;
        Mon, 07 Mar 2022 14:32:28 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id p12-20020a056000018c00b001f079518150sm9132760wrx.93.2022.03.07.14.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 14:32:28 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] brcmfmac: make the read-only array pktflags static const
Date:   Mon,  7 Mar 2022 22:32:27 +0000
Message-Id: <20220307223227.165963-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't populate the read-only array pktflags on the stack but
instead make it static const. Also makes the object code a little
smaller.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index b2fb9fcacdc9..f0ad1e23f3c8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -4623,7 +4623,7 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 
 s32 brcmf_vif_clear_mgmt_ies(struct brcmf_cfg80211_vif *vif)
 {
-	s32 pktflags[] = {
+	static const s32 pktflags[] = {
 		BRCMF_VNDR_IE_PRBREQ_FLAG,
 		BRCMF_VNDR_IE_PRBRSP_FLAG,
 		BRCMF_VNDR_IE_BEACON_FLAG
-- 
2.35.1

