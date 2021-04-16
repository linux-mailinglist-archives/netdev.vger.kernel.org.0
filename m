Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C10362A36
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 23:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344323AbhDPVYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 17:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235589AbhDPVX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 17:23:59 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220E3C061760
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:23:33 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id u7so12845581plr.6
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VSU/g57bhcz5yTSfubswru6uuL84VyI3gunzqLKY5Pc=;
        b=seGIZGbEIb3ljGUfghZJnY45KF4hL+sSh9I/H6zxRHgTxM8up6GhdjTHHShV5FwOth
         JyGU7kgDgmUExa7nmmrpdv+NwHEZeHWFvkZTcCuzimcGf/WWXYl7jEvX9K7MKvFrVGoM
         HM83ritFiXYqGFPtsDoL2+zOY9hVK4oRgcKD7wAO2b4z4RCVO30aF+j9nASEm3eD9+y5
         G1PcLLxTwamD0FZvJGdNFTSAuFqC8SHT4So9NGB6VkPrbCvPtqITfiU4Szly8Mzk5uHd
         jDGteVrzO5Wbj/stJ/PnIxrOOiC/todGCu6rXiFLiiMxIBDgbgnTz7hTUaNqgeQjKNPX
         V22A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VSU/g57bhcz5yTSfubswru6uuL84VyI3gunzqLKY5Pc=;
        b=op+jZy42XMgqcqLTHyapFtG11luVfIHigSGFNaaZ9GZaJWrtAnHfOdA2updx2TybKG
         Or0zlRzzMS9z/qZzg3z/V94j756eFSaKyAvlEIBvAv3L9QWZlw/UnSIylHUOzjvMI8YC
         mkozw5CgRonlVOLr7naLgosfahv7Z61cC9fP1Hd0wDufpAmjhCtPMumxPCQmstCW0Vrk
         bLRLYpdmmJRIDSVJZH5DazaQQXW376sxru0YU8wX/mHMO0iyKgKLWUU6EVxOoPwTFuKw
         QeqxVA35oIwgA4hrEi4l55CpYSLfqwB/8afZ87MTmrDFJ29RXeHvMDROsKRrwKbsjHBN
         JKnQ==
X-Gm-Message-State: AOAM532IM/aOgn9AuNFsb+IStyjDvN28Xtqi76hGD4Prfa2wsTnyNHcE
        679IgBp5aW7c61tHQ9Gpq08=
X-Google-Smtp-Source: ABdhPJzi6uSVGic6TgCU/T/hRYCjuCr1Js3z3jeK9wUI1m+397MVRgQXtUKT6t2L26JuWFYTI++pJA==
X-Received: by 2002:a17:90b:ed8:: with SMTP id gz24mr11357183pjb.98.1618608212728;
        Fri, 16 Apr 2021 14:23:32 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id t23sm6069132pju.15.2021.04.16.14.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 14:23:32 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 06/10] net: enetc: increase TX ring size
Date:   Sat, 17 Apr 2021 00:22:21 +0300
Message-Id: <20210416212225.3576792-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416212225.3576792-1-olteanv@gmail.com>
References: <20210416212225.3576792-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Now that commit d6a2829e82cf ("net: enetc: increase RX ring default
size") has increased the RX ring size, it is quite easy to congest the
TX rings when the traffic is predominantly XDP_TX, as the RX ring is
quite a bit larger than the TX one.

Since we bit the bullet and did the expensive thing already (larger RX
rings consume more memory pages), it seems quite foolish to keep the TX
rings small. So make them equally sized with TX.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index d52717bc73c7..6f818e33e03b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -79,7 +79,7 @@ struct enetc_xdp_data {
 };
 
 #define ENETC_RX_RING_DEFAULT_SIZE	2048
-#define ENETC_TX_RING_DEFAULT_SIZE	256
+#define ENETC_TX_RING_DEFAULT_SIZE	2048
 #define ENETC_DEFAULT_TX_WORK		(ENETC_TX_RING_DEFAULT_SIZE / 2)
 
 struct enetc_bdr {
-- 
2.25.1

