Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAEC65FD404
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 07:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiJMFBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 01:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJMFBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 01:01:00 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26D210326E
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 22:00:59 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id pq16so961463pjb.2
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 22:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vo2vClF0viTyEV9dF3uXEQmi9DD+bFYaARDbiE673FY=;
        b=bcFJXUHNzbEqQLUtO/5UnkbVjmKzQ+mDYMt0K89Rc/1Of0EdHQYXnHCqgkNNy81BNE
         oZIBtnrnC9bZElluyBGBIRbZ2qzyqcR2OBCaHR80lxcIc43dp7ZP/yJGfwymLvJy+055
         PsY5LMoboAg0kSIcjgPrzZdaTBSv5fTyyQHdns8R4q2gF74J+/jVUNisidxiZtABwJcW
         A0OUqscxtNJzlSvWhb6YQ4W/aljdSUvafmjZ5vvBFhIcXmA2IsNrDw/W3MeIeufgJ+pc
         xLq+YSWhCqEoG2BZH1gs5I9DF5kYTGCLmKueUHxDh1X79DeNaf/x7pp2rQsiyhk0iU6P
         azUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vo2vClF0viTyEV9dF3uXEQmi9DD+bFYaARDbiE673FY=;
        b=JqzCYEHq1crrzqjWQkcxcxQly9gB+UpwQLKfByYxzqGdC6JKp0vAcKUPipgExXjaVL
         dFA7BH/qkTYIQ4+hJXDlOh/3I+j5A4WBZrd0JJwA6xqI9wVX7+eXdbiLm16d6aommWky
         3NrCKaNCEC+tGUfC1Qlulp6V5oqQpy/BlC5HQ7IZHdLaLUhCay8Btg4mpAvdwxfrFUeE
         gri8eyeuh7z35TwVEZLkAxx2DQDzqtNQDRTVGVgp1iG7dm5vfw/tizeoG0IvBRzQXfMH
         h0sDtDcPJ3iheglPntsOQmRZAZIE1pqZtSM3qe3PuK4jhJY9GU91JzbfZ08eh4Pdwuz4
         JgxA==
X-Gm-Message-State: ACrzQf2Ef6okd3Bcn4RnD5S28GyqCWLOvotXAS/Y23KL7bkj3R31b99r
        4+BFzR+L3L+p/3OyRgW6VPtgyQ==
X-Google-Smtp-Source: AMsMyM7prQsv8d89ELhZC16iF907vgbbEkzq/tHxl8hNDtEPOBmor31gzGC8wSwsOIsGn0Nx+m3iVg==
X-Received: by 2002:a17:90b:1806:b0:20d:3256:38 with SMTP id lw6-20020a17090b180600b0020d32560038mr8847987pjb.94.1665637259078;
        Wed, 12 Oct 2022 22:00:59 -0700 (PDT)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id v22-20020a17090abb9600b0020bfd6586c6sm2278518pjr.7.2022.10.12.22.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 22:00:58 -0700 (PDT)
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH] e1000e: Fix TX dispatch condition
Date:   Thu, 13 Oct 2022 14:00:44 +0900
Message-Id: <20221013050044.11862-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

e1000_xmit_frame is expected to stop the queue and dispatch frames to
hardware if there is not sufficient space for the next frame in the
buffer, but sometimes it failed to do so because the estimated maxmium
size of frame was wrong. As the consequence, the later invocation of
e1000_xmit_frame failed with NETDEV_TX_BUSY, and the frame in the buffer
remained forever, resulting in a watchdog failure.

This change fixes the estimated size by making it match with the
condition for NETDEV_TX_BUSY. Apparently, the old estimation failed to
account for the following lines which determines the space requirement
for not causing NETDEV_TX_BUSY:
>	/* reserve a descriptor for the offload context */
>	if ((mss) || (skb->ip_summed == CHECKSUM_PARTIAL))
>		count++;
>	count++;
>
>	count += DIV_ROUND_UP(len, adapter->tx_fifo_limit);

This issue was found with http-stress02 test included in Linux Test
Project 20220930.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 321f2a95ae3a..da113f5011e9 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5936,9 +5936,9 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 		e1000_tx_queue(tx_ring, tx_flags, count);
 		/* Make sure there is space in the ring for the next send. */
 		e1000_maybe_stop_tx(tx_ring,
-				    (MAX_SKB_FRAGS *
+				    ((MAX_SKB_FRAGS + 1) *
 				     DIV_ROUND_UP(PAGE_SIZE,
-						  adapter->tx_fifo_limit) + 2));
+						  adapter->tx_fifo_limit) + 4));
 
 		if (!netdev_xmit_more() ||
 		    netif_xmit_stopped(netdev_get_tx_queue(netdev, 0))) {
-- 
2.37.3

