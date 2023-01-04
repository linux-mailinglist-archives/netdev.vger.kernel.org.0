Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E42E65DD00
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 20:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240215AbjADTlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 14:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240181AbjADTlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 14:41:42 -0500
Received: from mx14lb.world4you.com (mx14lb.world4you.com [81.19.149.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F20D221
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 11:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5ZXc1vSgoMvdLWFA8cOaHd9PGQ254zilJ1DKdg4h4Vw=; b=OwKslNPI5g3IRu3fXmfpk2u9RQ
        Tn/0Q9YxMjgVAZ14EB036GhXX0PC7SrSWWVj73HQUX01YqV0WBoXNLB71uxJ+QGS5nOjEExBWX+TD
        wZmvg6H2izQD6+d3nWHpnrBJYSXlORmZBN6+zF2Xs/sgNuCwz5S2elxulR1/K38dC+Y4=;
Received: from 88-117-53-17.adsl.highway.telekom.at ([88.117.53.17] helo=hornet.engleder.at)
        by mx14lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pD9dr-0003c2-Ir; Wed, 04 Jan 2023 20:41:39 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v3 2/9] tsnep: Do not print DMA mapping error
Date:   Wed,  4 Jan 2023 20:41:25 +0100
Message-Id: <20230104194132.24637-3-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230104194132.24637-1-gerhard@engleder-embedded.com>
References: <20230104194132.24637-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Printing in data path shall be avoided. DMA mapping error is already
counted in stats so printing is not necessary.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 7cc5e2407809..0d40728dcfca 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -469,8 +469,6 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 
 		spin_unlock_bh(&tx->lock);
 
-		netdev_err(tx->adapter->netdev, "TX DMA map failed\n");
-
 		return NETDEV_TX_OK;
 	}
 	length = retval;
-- 
2.30.2

