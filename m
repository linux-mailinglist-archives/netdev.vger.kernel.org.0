Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA74362A31
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 23:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344280AbhDPVXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 17:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344323AbhDPVXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 17:23:31 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADA7C061574
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:23:03 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id z22-20020a17090a0156b029014d4056663fso15307928pje.0
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+V8KqyA+rMMJYCjLMa+OXZ90t3ixKrulpx3+F+JwT4A=;
        b=uccIZRtDPPH+v0cTPWp/saGG3YTEyv8+OKaB5v8prkNV0OR3DNqY/XlLKsT3RsJyNU
         B1cjL8Iqx2QpQpvJ6fruqzxHlRQYWIqDLDarYhC2ba+e35ySrfMXK3tTcbd3k6Fa0rmn
         Sj1TnJjlNkSNODs4JudDULoE+S7ChP851QMVQWI3LEn/VR47iCeCtEYTJsz8rbi1i5aX
         F4P9YaWEmC6wo7d/V60Vcqu+KZ0MiaczAgZ8fwHgqGZNVKR6Ma/0LVt987MP2l10TVgA
         XL0n23HlGXm5E8cpQVzqJfdUu68nA91bCbZQlB6dZa+IJo7y18pYvhVesxBRf/kDQ63I
         4/Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+V8KqyA+rMMJYCjLMa+OXZ90t3ixKrulpx3+F+JwT4A=;
        b=VaGHjeZW/JjfHQM4pU1aVavFVn9qUWwPkDj1eefQ8ChKZyXc4cWGxHUUy5QyS3/cMC
         Be4MeL7iJWJIrVF58EB+YMWLzInztSzOhDasZBxeDKdrKyJHK0NYMzNafcjqH9fWwpvG
         dElS1U7b5K1LHlNpkJFhaaZVKOdAq+HacVGoFu1vo45dDZk2Ts2K1fL5kBbLWS8DyXVl
         iWi3kHhVJ+Bmr40pC+J0bTzAons0fZJbaF9OwnmrFJuEKT5vlMo4Q1Bqju69tzY2sD3V
         0oXSsbv4TdeISmKvDb/qSmhiu4NnxYvuAgQbNM+qz9xDiDp9t6iTPO9dhJQ+iJefUOGp
         gKRA==
X-Gm-Message-State: AOAM531N4zxR+xo1rsVZJJDCb9nF3QZEmM+Vt6C9GWK+j0AdN/yq8CLK
        3RjdzHL23FZnvlLfPPxeZv4=
X-Google-Smtp-Source: ABdhPJyRtWbWA/FfVOkz9T9ySQ/3t6Nc4uBUaWIX+guK893x4EQwlJouAjfBpuRNweyD0Fr9r+FD/w==
X-Received: by 2002:a17:90a:e28b:: with SMTP id d11mr11851099pjz.53.1618608183436;
        Fri, 16 Apr 2021 14:23:03 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id t23sm6069132pju.15.2021.04.16.14.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 14:23:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 01/10] net: enetc: remove redundant clearing of skb/xdp_frame pointer in TX conf path
Date:   Sat, 17 Apr 2021 00:22:16 +0300
Message-Id: <20210416212225.3576792-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416212225.3576792-1-olteanv@gmail.com>
References: <20210416212225.3576792-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Later in enetc_clean_tx_ring we have:

		/* Scrub the swbd here so we don't have to do that
		 * when we reuse it during xmit
		 */
		memset(tx_swbd, 0, sizeof(*tx_swbd));

So these assignments are unnecessary.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 9a726085841d..c7f3c6e691a1 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -544,7 +544,6 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 
 		if (xdp_frame) {
 			xdp_return_frame(xdp_frame);
-			tx_swbd->xdp_frame = NULL;
 		} else if (skb) {
 			if (unlikely(tx_swbd->skb->cb[0] &
 				     ENETC_F_TX_ONESTEP_SYNC_TSTAMP)) {
@@ -558,7 +557,6 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 				do_twostep_tstamp = false;
 			}
 			napi_consume_skb(skb, napi_budget);
-			tx_swbd->skb = NULL;
 		}
 
 		tx_byte_cnt += tx_swbd->len;
-- 
2.25.1

