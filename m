Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86CB666D025
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 21:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbjAPUZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 15:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233892AbjAPUZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 15:25:17 -0500
Received: from mx25lb.world4you.com (mx25lb.world4you.com [81.19.149.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDFC26584
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 12:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LefPt6Wy49zl3/VfJcj+2vYE0fQaEZPVXyhfAaD9kfY=; b=qGghdll0vTD208YDRs3rxgdfFA
        jH04xKZCggCfAuBDjM8DL4pkan4P0ocXveRfU5OFNnNQ8/0E8vtrJxJK12fRe8Vl5Pi3uCJeys7E0
        5Gjb17SkowScimTflSNP7AKLV0FgolSfluFjTCEJ+D6Ei2HIyOlOgnTVAQu3MBh+dEMs=;
Received: from 88-117-53-243.adsl.highway.telekom.at ([88.117.53.243] helo=hornet.engleder.at)
        by mx25lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pHW2Z-00018Q-BB; Mon, 16 Jan 2023 21:25:11 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, alexander.duyck@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: [PATCH net-next v5 3/9] tsnep: Do not print DMA mapping error
Date:   Mon, 16 Jan 2023 21:24:52 +0100
Message-Id: <20230116202458.56677-4-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230116202458.56677-1-gerhard@engleder-embedded.com>
References: <20230116202458.56677-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Printing in data path shall be avoided. DMA mapping error is already
counted in stats so printing is not necessary.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 8abe65a8c2f1..d25608e81ad8 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -463,8 +463,6 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 
 		tx->dropped++;
 
-		netdev_err(tx->adapter->netdev, "TX DMA map failed\n");
-
 		return NETDEV_TX_OK;
 	}
 	length = retval;
-- 
2.30.2

