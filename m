Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717C2362A34
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 23:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344207AbhDPVXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 17:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344347AbhDPVXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 17:23:48 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68922C061574
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:23:21 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id p16so10699452plf.12
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 14:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bIuIwwJxbAm8jJlBJtBotyHQ5pp2KTqgy2d7ZTTl9dY=;
        b=SNtGc78mEI0/gnX5w9w7MYD/ho5xlFC/Ym8GxV0C0PljEkQYeeOCXZ6rhPfbSHdQs7
         4V00LV343DiyVsMJ2EvgyV8iXPnuUUxhrAdxL56DjyAtvOgV5Ji671y82JQmxXQ1e6kd
         3DW2qyCUEJ5dMS+VP6p/nqL7OxNXGYiBfTVepOqId2b8NQ/RtksIRwmsZLttrsyD/PHp
         bU8t1sxYKWT0Tv3ez7q63d/AbKSZAxllHt3fJ2zwZypk7nJlEzgXh7txHmMqarJvWXB9
         Vi9OK7EBmIzQmbdyqTfs4ht3KTLNKHNs9hGMqxanXsenXMh3Yna1kq8hLHmJHUvtdDle
         0Grg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bIuIwwJxbAm8jJlBJtBotyHQ5pp2KTqgy2d7ZTTl9dY=;
        b=j7RFSzAJG8ojFg+coJhqG0nI1aqPvpplByhjEKPrWtEr52Gqd+7SOzvx/44xOEZXaf
         E5YyfXd7QYuvSQrB9g60+bmzCEncYLwuExDYMkD3uIkrxlaZY5sb10OjkIRQMp36v7yH
         iXOPGfw4wS+vdrYQ/aYuY1pQRQQr+diyIoowQskGp4i4EeX478Xjb7yQnUKGTp3V0rj8
         PYq5Mw4S4yhWb/1Qmo7izUa7jRWD0SPDEVjIQONQmBwzaqjpmW2BIijxA9wpt748BRkB
         dInPDnJVN5VUM8ZdRDJIrT5QL5rYyGj8y1R63PlEDZMs5I4PG3aN23yu/a3K01iWUsjN
         ORgA==
X-Gm-Message-State: AOAM530mrz0yq6KCk7szqMBZ6qxiWlPEAwdA0WbpIUFjwLb1F940rvmC
        z3ksLoApngI6l5XkvNQKEhg=
X-Google-Smtp-Source: ABdhPJykCeEp6E/0nbChRKx6RnP8T2nDhaOpTtFjoCiT8uh4ZQ9pf67tkRbNlA96NmOCCplPYUKIFg==
X-Received: by 2002:a17:902:7281:b029:ea:afe2:b356 with SMTP id d1-20020a1709027281b02900eaafe2b356mr11568483pll.16.1618608201024;
        Fri, 16 Apr 2021 14:23:21 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id t23sm6069132pju.15.2021.04.16.14.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 14:23:20 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 04/10] net: enetc: stop XDP NAPI processing when build_skb() fails
Date:   Sat, 17 Apr 2021 00:22:19 +0300
Message-Id: <20210416212225.3576792-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416212225.3576792-1-olteanv@gmail.com>
References: <20210416212225.3576792-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When the code path below fails:

enetc_clean_rx_ring_xdp // XDP_PASS
-> enetc_build_skb
   -> enetc_map_rx_buff_to_skb
      -> build_skb

enetc_clean_rx_ring_xdp will 'break', but that 'break' instruction isn't
strong enough to actually break the NAPI poll loop, just the switch/case
statement for XDP actions. So we increment rx_frm_cnt and go to the next
frames minding our own business.

Instead let's do what the skb NAPI poll function does, and break the
loop now, waiting for the memory pressure to go away. Otherwise the next
calls to build_skb() are likely to fail too.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index c6f984473337..469170076efa 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1275,8 +1275,7 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 					      &i, &cleaned_cnt,
 					      ENETC_RXB_DMA_SIZE_XDP);
 			if (unlikely(!skb))
-				/* Exit the switch/case, not the loop */
-				break;
+				goto out;
 
 			napi_gro_receive(napi, skb);
 			break;
@@ -1338,6 +1337,7 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 		rx_frm_cnt++;
 	}
 
+out:
 	rx_ring->next_to_clean = i;
 
 	rx_ring->stats.packets += rx_frm_cnt;
-- 
2.25.1

