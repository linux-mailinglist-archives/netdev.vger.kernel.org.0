Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437B36CC61B
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 17:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbjC1PXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 11:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbjC1PWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 11:22:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9217910433
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 08:21:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EB6A0CE1D9C
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 15:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28101C4339B;
        Tue, 28 Mar 2023 15:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680016808;
        bh=Q3D62lx8qicn0pecfCYWbmmrULlJSy4OuKeKDdThgjE=;
        h=From:To:Cc:Subject:Date:From;
        b=f2fL6W/+3Lgw7g/JJjqKGiL2qiPemwuMwEDB7HbOXW33SjDlIXtF7QG7Sgpq4QGGY
         d+6TM3HZbdXhJFzMUFqByI4XJiDCtQ7Dkv1LTiUkkFwChrWeonXIdFYR/v2QOGivw2
         Bql6bVoLhPSZ90xc0ByeH5mkox1Xzv3GhCkj46nM3+mBYuxg/B3HXPHbneCq6droRM
         cfXcT6nSJMD3MIoIDW8qVZCXHDZwI+D9l/m3345ZbdfVEgR4XseZu7xWjP+21pi1AU
         tsVHNwYtjjQ+ZRtCEUT2BwNOI7WCQUFzemuhtZZ81PCjpqFdmex6h9T+BBesuUzAh+
         tjjXFujukhyDQ==
From:   Simon Horman <horms@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>, Tom Rix <trix@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: ena: removed unused tx_bytes variable
Date:   Tue, 28 Mar 2023 17:19:58 +0200
Message-Id: <20230328151958.410687-1-horms@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang 16.0.0 with W=1 reports:

drivers/net/ethernet/amazon/ena/ena_netdev.c:1901:6: error: variable 'tx_bytes' set but not used [-Werror,-Wunused-but-set-variable]
        u32 tx_bytes = 0;

The variable is not used so remove it.

Signed-off-by: Simon Horman <horms@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index e0588a82c8e5..e6a6efaeb87c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1898,7 +1898,6 @@ static int ena_clean_xdp_irq(struct ena_ring *xdp_ring, u32 budget)
 {
 	u32 total_done = 0;
 	u16 next_to_clean;
-	u32 tx_bytes = 0;
 	int tx_pkts = 0;
 	u16 req_id;
 	int rc;
@@ -1936,7 +1935,6 @@ static int ena_clean_xdp_irq(struct ena_ring *xdp_ring, u32 budget)
 			  "tx_poll: q %d skb %p completed\n", xdp_ring->qid,
 			  xdpf);
 
-		tx_bytes += xdpf->len;
 		tx_pkts++;
 		total_done += tx_info->tx_descs;
 
-- 
2.30.2

