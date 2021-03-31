Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBE93507DF
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 22:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236487AbhCaUJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236397AbhCaUJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 16:09:20 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5CDC061574;
        Wed, 31 Mar 2021 13:09:19 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id w3so31958985ejc.4;
        Wed, 31 Mar 2021 13:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YDYM5IcD4Re3JLEPXhD3YUxrHnmifCPM/Hta5XlLd2Y=;
        b=oobSI1gL4nqIQcV9WzqNoGmjuBni/DHXsFTMZ3WI5jnKiMIetHU4X/FV3JtY9x3NDc
         0Mv4oywvpF6suX6qYNafbMdjzNvonWK/vYA4kv/fW6PRLDiFS8I/oRv65+XSndZRvgVe
         //pTbFxbT/bwxtfqVtdW3WN2NGWsi7Ss3AK68cGz/fbWR3Q1+rUF597FPhyHEBYOzdL2
         2uWVlZsqewejEDmFbOamFAEkCksbHUKUtyLTFdSlyPS+/fZXD1H+frqUBQSn1Yc7HZv8
         z7Y3nCQn9+0T0YN3QJOyzcwi15tIDEaGDtAhUoJQ6wvAQ6Ws7f+CHb997GFMqW6EKK/0
         BQ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YDYM5IcD4Re3JLEPXhD3YUxrHnmifCPM/Hta5XlLd2Y=;
        b=LqLkdqLbfpis65mas7ACdssav1YxoFFVQIJ3lu7egFKCw9heKdWHmUvXOOsGH/u8I7
         KbNf7zvYVkYkLExl1mKaIYsb3o7hE0Dw+lxSX+oP8MTUTwkoJBI95tSyX7ppH78BSwCC
         m3CHBmA5tvKwQqfg/04DorS6p+SB0svXbXciV/Bq6I6+0twmVLFj5B8WeTBTGQ5oGoH9
         66ohCpketAztUwx5FntpWbJ5zt/Ll94NRarifzaHlpWFKjdGbCqZ1iHKJjO/NadgQI2X
         pHWCHHaQEUoU+rgHANLIi3BzB4yyrPouP2mENS7W3h8KHSIZ5YYAMkj+3kBgw6pLeAFa
         ssVg==
X-Gm-Message-State: AOAM533YNXhseNKhmhWKRLPvN6kXineaUJOsMIOZQ3cYje4WrHEfxOxU
        QAbfR/6l+ayBh1RgcluEu3E=
X-Google-Smtp-Source: ABdhPJzF49ILummIdYctzGId5AjDp3kRO4kgPpqUTfWMmxuLxsD2nCPY9PENn2T4iMZnlasS7C06LQ==
X-Received: by 2002:a17:906:4dce:: with SMTP id f14mr5392198ejw.349.1617221358459;
        Wed, 31 Mar 2021 13:09:18 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r19sm1691305ejr.55.2021.03.31.13.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 13:09:18 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 4/9] net: enetc: clean the TX software BD on the TX confirmation path
Date:   Wed, 31 Mar 2021 23:08:52 +0300
Message-Id: <20210331200857.3274425-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331200857.3274425-1-olteanv@gmail.com>
References: <20210331200857.3274425-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

With the future introduction of some new fields into enetc_tx_swbd such
as is_xdp_tx, is_xdp_redirect etc, we need not only to set these bits
to true from the XDP_TX/XDP_REDIRECT code path, but also to false from
the old code paths.

This is because TX software buffer descriptors are kept in a ring that
is shadow of the hardware TX ring, so these structures keep getting
reused, and there is always the possibility that when a software BD is
reused (after we ran a full circle through the TX ring), the old user of
the tx_swbd had set is_xdp_tx = true, and now we are sending a regular
skb, which would need to set is_xdp_tx = false.

To be minimally invasive to the old code paths, let's just scrub the
software TX BD in the TX confirmation path (enetc_clean_tx_ring), once
we know that nobody uses this software TX BD (tx_ring->next_to_clean
hasn't yet been updated, and the TX paths check enetc_bd_unused which
tells them if there's any more space in the TX ring for a new enqueue).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 37d2d142a744..ade05518b496 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -344,6 +344,10 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 		}
 
 		tx_byte_cnt += tx_swbd->len;
+		/* Scrub the swbd here so we don't have to do that
+		 * when we reuse it during xmit
+		 */
+		memset(tx_swbd, 0, sizeof(*tx_swbd));
 
 		bds_to_clean--;
 		tx_swbd++;
-- 
2.25.1

