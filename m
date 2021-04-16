Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFC7362A35
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 23:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbhDPVYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 17:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344359AbhDPVXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 17:23:54 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D3BC061756
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:23:27 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id p12so20032534pgj.10
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7yIJAENMJue5b5fKtN07FGax+EgoqXKDi+PYwVaRHfs=;
        b=s+Rp1T4qoylixWcADErrg/V06wD/vVsH35XPLqpxWCUsN22Be0rTcwtBBis3MNtMll
         +2axTrvoamiwqE8hBYoP851T3f8DzIFSJ3HZKqFmet6nwb3Og2BceD2AlZupuauqVM/i
         4x3s/yWEA7z3VgIHA+41vNJxPNU+1v6NF8rpDjLIV1W3ejqn13qfG4Aoer1V29UA3KTm
         Mkhtv2RV1SrDcuHXtm5hpXh30DtClCXMYF9Kn2ZY3xgUFOz/Om7DMxUvZPlqnbMv3rHK
         ozVR1vvbNr/RDYtLWJtGlAG8hH5K3jKhtsSuXrGeyqzKw1lUy1YGh2oQ7kQgC1Cp8v1i
         H8fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7yIJAENMJue5b5fKtN07FGax+EgoqXKDi+PYwVaRHfs=;
        b=TAy0hVVBDC9+/vu746eROY1IlbwnIhcgq+7lYRVqyZb9V4Q4enS6Pnt/45utTPetIG
         UU/wPfVUz8Gj1rXEt8v2zeJ0wKeV6pxFXMC4JdlwoQDhfmghoTMR13uR62aYLOr+FY/j
         RXqGg/sd4q2aLei/OqEKamzcZ2pV/A/HtWcTvgSP3nn2OLMCk2pP8/M6g0OZ+KT9KY1+
         48akAi5JArxsXcn1KzZKSd8I4abB6Y5OKwdb32zMqJyqwUEsnCDK+JiPoQeB3glniJqd
         Un+Z5vVyrrhBIWu0OGZQud0uBZ61zEIuathDVb1+9idDyniTUvkpg6B8ke1F8FJDjpgD
         e7xA==
X-Gm-Message-State: AOAM530hmEwtZ4Q55w0KurNMMVt9gQFzUH3o3LVkKsYQ3guqAMXvqUur
        KutlVCSumB2NWZR5kqbslxU=
X-Google-Smtp-Source: ABdhPJyvSdPwRtpxp5lYTRW3thl24IsVJ4qKXQl2Jzhh2N8sT+8quVlInpkbKXEieL3KLE52Va8NJA==
X-Received: by 2002:aa7:814c:0:b029:250:13db:3c6e with SMTP id d12-20020aa7814c0000b029025013db3c6emr9814667pfn.65.1618608206861;
        Fri, 16 Apr 2021 14:23:26 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id t23sm6069132pju.15.2021.04.16.14.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 14:23:26 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 05/10] net: enetc: remove unneeded xdp_do_flush_map()
Date:   Sat, 17 Apr 2021 00:22:20 +0300
Message-Id: <20210416212225.3576792-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416212225.3576792-1-olteanv@gmail.com>
References: <20210416212225.3576792-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

xdp_do_redirect already contains:
-> dev_map_enqueue
   -> __xdp_enqueue
      -> bq_enqueue
         -> bq_xmit_all // if we have more than 16 frames

So the logic from enetc will never be hit, because ENETC_DEFAULT_TX_WORK
is 128.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 469170076efa..c7b940979314 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1324,11 +1324,6 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 				rx_ring->stats.xdp_redirect++;
 			}
 
-			if (unlikely(xdp_redirect_frm_cnt > ENETC_DEFAULT_TX_WORK)) {
-				xdp_do_flush_map();
-				xdp_redirect_frm_cnt = 0;
-			}
-
 			break;
 		default:
 			bpf_warn_invalid_xdp_action(xdp_act);
-- 
2.25.1

