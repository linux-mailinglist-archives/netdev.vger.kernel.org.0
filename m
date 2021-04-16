Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4777362A38
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 23:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344388AbhDPVYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 17:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344383AbhDPVYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 17:24:11 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DC1C06175F
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:23:44 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id p67so14224404pfp.10
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d6wQXcTlOKY4WvS+BhBP+DZHP7vls4Ke105vdWlaVbY=;
        b=kM4tcKGj8sHqgZ9LyR5h9Kbt7hGslyZAoXBh/Gs9owg+nlNBhPcEFj0mos8iSYaUyj
         7NT80k5oHDmUB3dWPCf/blNWBgjnr60FUY9k/4mFFNnz0rcnjkbEgn3h/LzQFATeojpk
         KFvRorluNEDeYxYynJlG6YfHoR9s/e+eyu+eO8uoqLl+FlpneN/y2DpNAdU34WIUZWgT
         sW6Lx93cPSTjdbN2v+P1m6cNLla6xbfXtQWhAb8U4R3FoYQLwJ5uq3e/RUWrvbVbouM1
         5jcPuqBLMwXGsqDLW7huSyb9m1OGFrmyoIWQOm5KZlXJnd1nKKFMaULh31A9IPj2PvgM
         spCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d6wQXcTlOKY4WvS+BhBP+DZHP7vls4Ke105vdWlaVbY=;
        b=WOvvZD3Mir8wtlAK1TiMcYXzI0OYPiWKuS3knzviIXo5huwDKWTxvC/w9pTQbD3Nev
         7SPHHp5mpxUkWSnp6H7Tt8NmLCbSMpk58sbgXEYgHz/KhsS6OAXD6NDAPACJB67EYL/D
         aKWVW1MUIDJjW0hW/koNsTpeH4znGl/5cec3b8RxoFpHruqo6qjo37TIOZa+ZQUhaQAp
         pKRRvwTx/szwGvBq9SObjNH0YydvIeXnDK4DAGLxKYXF7h1R0/UGC+AvjYqBYgMXq9B4
         1nZUf5gI19rZoje8yUx1ne3Wx2jmiMxL1jOkxlrtuSQKq+iVQyrYOwisMmdO32IgHISZ
         G+IQ==
X-Gm-Message-State: AOAM532o4BBmnjfh+8dH52Gjhr/3J8ZQvZ3UQnpMISQRRMnGpHBDQpmT
        aIqMR3ERVH92pfkIsXmMyyg=
X-Google-Smtp-Source: ABdhPJyL3P9jw53Md/LSQDdL4zzDhnFmc3UNZfqXZvFjLIai/yRz5DaLr0cuXXs4cY9BSp+0y6clpQ==
X-Received: by 2002:aa7:88d4:0:b029:24e:93bf:f472 with SMTP id k20-20020aa788d40000b029024e93bff472mr9537106pff.8.1618608224571;
        Fri, 16 Apr 2021 14:23:44 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id t23sm6069132pju.15.2021.04.16.14.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 14:23:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 08/10] net: enetc: handle the invalid XDP action the same way as XDP_DROP
Date:   Sat, 17 Apr 2021 00:22:23 +0300
Message-Id: <20210416212225.3576792-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416212225.3576792-1-olteanv@gmail.com>
References: <20210416212225.3576792-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When the XDP program returns an invalid action, we should free the RX
buffer.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 56190d861bb9..0b84d4a74889 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1282,6 +1282,9 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 		xdp_act = bpf_prog_run_xdp(prog, &xdp_buff);
 
 		switch (xdp_act) {
+		default:
+			bpf_warn_invalid_xdp_action(xdp_act);
+			fallthrough;
 		case XDP_ABORTED:
 			trace_xdp_exception(rx_ring->ndev, prog, xdp_act);
 			fallthrough;
@@ -1346,10 +1349,6 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 				xdp_redirect_frm_cnt++;
 				rx_ring->stats.xdp_redirect++;
 			}
-
-			break;
-		default:
-			bpf_warn_invalid_xdp_action(xdp_act);
 		}
 
 		rx_frm_cnt++;
-- 
2.25.1

