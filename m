Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E842D3817
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 02:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgLIBIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 20:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgLIBIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 20:08:43 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59732C0613CF;
        Tue,  8 Dec 2020 17:08:03 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id t8so356471pfg.8;
        Tue, 08 Dec 2020 17:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FVaaFvhma/LtEAgKTLdfxnHOJeqm88SA5H4iaroEpmA=;
        b=pHv4Lz0bvbALDlTuzU3DzO1yRj45wGco2lMyBbQcVGGneEc4ltghcPwzhj4k57Qnsz
         yUWDsqtAVbeUyWs5zUlsloiCsdz9QTwvCPRURsGGhq1qoelXXARmcEWIrtc4pLMKx+zY
         g4gqHg6D9173SsOYDA+EPkiuv65RTXZYurNxpMyb+dKdNoqCTyIQXOGbQ9EGwXamY8Sv
         Oc0jNISmPDN+3dfJbhy5S4Maz/YNNxDVfh1gTxE+hz4p3b+R0GdTpWx82Eupg8oDSeze
         hRJ+K0JyMCORbYoG0qW/0htHNH7OCowGTCRnizbLWCXirZwUqpi7N6qAJKy0ajWL+0iI
         YuSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FVaaFvhma/LtEAgKTLdfxnHOJeqm88SA5H4iaroEpmA=;
        b=EZisswWcozkpsHYtVl0aS8e47MXZmDtioO5GKGXnAmnnmHeB2vngBtjtfUY2HE/hK1
         tJtQkCY8ocW3ien3Hx+4a35gAcbABy5QPPZ2gekAGSdf0lk5UrdolH1udQqXxiqN+hpn
         w4vSwo9PcYda7Mr/eP9WwzhoScP8Lm5JG5DO3oEI2abwipbG209910/KfqE2F2xcN6le
         1GmSt8yF/FBEmrrmvjVj1hT04kIbI9jGBgqqu0h7uL0Y2TNt6Bs36vliKrj1IM2qBREv
         ZiAlp0OZmoP3BQ0OjFCZ4BCT+RS1Dd6GC801v7HPKh80mN8vjSid1LADXG9AeZRB/I9R
         3oSA==
X-Gm-Message-State: AOAM530bItwcwmS8+7V7lR/tHjNtlyLVSgkBB4ZJSZvPBPWMq0kHJHde
        TxpbZZUBrDBVwhCbpvJlPlQ=
X-Google-Smtp-Source: ABdhPJwCQd+avrsd3DtcFKdSpMlr/Nc+tBhs6yqerolExTUh+1sp/IE4LFM4FXI3mibasPl6pVmdoQ==
X-Received: by 2002:a17:90b:1c0d:: with SMTP id oc13mr209715pjb.113.1607476082915;
        Tue, 08 Dec 2020 17:08:02 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:ac46:48a7:8096:18f5])
        by smtp.gmail.com with ESMTPSA id az19sm112702pjb.24.2020.12.08.17.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 17:08:02 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next] net: hdlc_x25: Remove unnecessary skb_reset_network_header calls
Date:   Tue,  8 Dec 2020 17:07:58 -0800
Message-Id: <20201209010758.3408-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. In x25_xmit, skb_reset_network_header is not necessary before we call
lapb_data_request. The lapb module doesn't need skb->network_header.
So there is no need to set skb->network_header before calling
lapb_data_request.

2. In x25_data_indication (called by the lapb module after it has
processed the skb), skb_reset_network_header is not necessary before we
call netif_rx. After we call netif_rx, the code in net/core/dev.c will
call skb_reset_network_header before handing the skb to upper layers
(in __netif_receive_skb_core, called by __netif_receive_skb_one_core,
called by __netif_receive_skb, called by process_backlog). So we don't
need to call skb_reset_network_header by ourselves.

Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_x25.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index f52b9fed0593..bb164805804e 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -77,7 +77,6 @@ static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
 	}
 
 	skb_push(skb, 1);
-	skb_reset_network_header(skb);
 
 	ptr  = skb->data;
 	*ptr = X25_IFACE_DATA;
@@ -118,7 +117,6 @@ static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 	switch (skb->data[0]) {
 	case X25_IFACE_DATA:	/* Data to be transmitted */
 		skb_pull(skb, 1);
-		skb_reset_network_header(skb);
 		if ((result = lapb_data_request(dev, skb)) != LAPB_OK)
 			dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
-- 
2.27.0

