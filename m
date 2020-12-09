Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7572D385F
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 02:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgLIBoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 20:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgLIBoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 20:44:38 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946FAC0613CF;
        Tue,  8 Dec 2020 17:43:58 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id m9so183882pgb.4;
        Tue, 08 Dec 2020 17:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xmepJe/1I5EWk/L7H6KF+A+wJ6nL7llNxwdsRgyIQjo=;
        b=OvkmsMlP26Yw86oDDyt2dCuwDGzeNqD8yWSEPnLc5BEwD9IqdR+qBab6e4VqbjMj5T
         fO/fWUdIYQL42P9yeLbftqHnLloyJOCWTKA0Sy4U26arRo0IQZ7LO31B2KOlWE5OHivf
         F8I7F/qycOUzYA4DiFpnTbkb/rRCSRezQj5lXm3NEg/wPGUyYYJp4Ea9KRTEgTWpgFqY
         eYpAOwtxYVZV3xGaddeFME4didth0jlEWcMHrn/cMBNW5AtbXeo0SIREDvC53x7BzGxg
         HHJlBj2GMZ+1XOrkqQXIiFd5pLAsASGwlLjpCYwhspuB5GdztQxmJdUXI5hph2eUftmU
         zFGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xmepJe/1I5EWk/L7H6KF+A+wJ6nL7llNxwdsRgyIQjo=;
        b=siqG4SL/4yPOpF7x2ZxV4upZQ/ehwytrcsBbm9hkXSBjfVeSoFB9Ixpny2kqRxrgTF
         Z4hyDwY/2pV3VFcKrqt8vpjIx5i3lzmMZraOlkyXv5Wm+HH6OqAyL5pmfK2kd3BF0iXj
         xJ7uNtmVxga0sSrVqIFBJ6M+RyvxlvLs/SgrqbsuxkE/VnhiQ5ekMRNsC2hjNWUezY+o
         ZO3/DVCTHgZIOayhWsgJzUSFXxCsZaejvt9f2VeJAmlmp0BBztJ9iR0fG0XKtekPRgWw
         twpLOlcfglzedufOX2VehTqGUPRLwBESvSuqwQPb/QYegi3Db4fVaSz4neue7XvPooY6
         xfSQ==
X-Gm-Message-State: AOAM531JuKFjPX9O2veTrxi76JTGzRFhn0S5x4tUKf73VNDsDK1YIQYU
        ur0rjUeyharKBu+sTJigIOA=
X-Google-Smtp-Source: ABdhPJzzi0egp6KgLAwlwilgrvxNYL1Kl9FGWNehYk7pplga+DwDpMUAhGfK3EH5B8JQ6x/4jMmbyA==
X-Received: by 2002:a63:4648:: with SMTP id v8mr797948pgk.248.1607478238225;
        Tue, 08 Dec 2020 17:43:58 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:ac46:48a7:8096:18f5])
        by smtp.gmail.com with ESMTPSA id b37sm47606pgl.31.2020.12.08.17.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 17:43:57 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v3] net: hdlc_x25: Remove unnecessary skb_reset_network_header calls
Date:   Tue,  8 Dec 2020 17:43:54 -0800
Message-Id: <20201209014354.5263-1-xie.he.0141@gmail.com>
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

2. In x25_data_indication (called by the lapb module after data have
been received), skb_reset_network_header is not necessary before we
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

