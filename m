Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456303710B7
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 06:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbhECDwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 23:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbhECDwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 23:52:34 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC6CC06174A;
        Sun,  2 May 2021 20:51:42 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id i13so3272893pfu.2;
        Sun, 02 May 2021 20:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7feMP8+so5V8FZrRsSAtejhq6PG5VmVbxe8usn2Evug=;
        b=XpGTdOLuAlJOU5IblpMmbw/HGEIO0YWgdSO6uzjYuJ2nKkrgYxbYfcDaRyNDL+vNqO
         wRJVbdWqwCPJs6XVVcFpnBrjOapWXpLPXrFKngVCUSrgvpUjGbz1oZzMKgxmZouKC9Ef
         ydj71uHjJh2bXi9ftopYGYPiSU/PXe/2UqVqtF2kyLbKNgtbyzk5bYevciP3gbRABemU
         DVJ49KwMxLijuOO1v9F1JOzrfCXBqAYFV/ND6L1lC36EiTUsnny55/qWB3Cy195jaQ8J
         DGib60aJlYN2w/GqcyqzcPM7BpzfjJqXvutXUbWaeL4Vh3oGjOAp6Y3qEWHDN3Wdrb/S
         UoDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7feMP8+so5V8FZrRsSAtejhq6PG5VmVbxe8usn2Evug=;
        b=RIDLlGet6xwMxLl916fLM6Z3SAbpaBlgthvhQj6QdpsEQRWMShsE+o+y6KHOgvkz1P
         jx+rizEoUrkp7ydLQ0H5KeNlYzlWWg1yYifUR1dZST+1AY9QGnEli2GUpGSX/UkQtU0U
         uJ/QFawEJrojWoMkEk59DZJ2XjYYbAYJp17/GtE9UT6NVV2CnqG8Z0lt8P9qG8FOO5Sx
         LCZAlfoWBLm7jackWyjyEDHAELtzn9XLBhW7Z5lVsckdF/x/VuQRSf0t9eKmvYi7+3g2
         TSv5CYfl3TorHtY6d5qbgK5UUsafpfRN+yCSJoFpMGl6Z8Z4dOePza7XEB45RTkBlYWS
         O3mA==
X-Gm-Message-State: AOAM532ixVJkSO9B++m+obkmJqdKKaBU4H8OpdTvC6D8mSJUv+sTlbVQ
        fEDPxSCdqShRqAdHGXDOosg=
X-Google-Smtp-Source: ABdhPJw6HRmTrMvlW1q7yxkdnmz5EGkuQuCz/z8Vwcv86URiphig35f7yGfOnMAAXySe6xulpjHQ/w==
X-Received: by 2002:a63:500a:: with SMTP id e10mr16335630pgb.242.1620013900797;
        Sun, 02 May 2021 20:51:40 -0700 (PDT)
Received: from shane-XPS-13-9380.attlocal.net ([2600:1700:4ca1:ade0:3a:4810:e38c:9b3])
        by smtp.gmail.com with ESMTPSA id c129sm7868437pfb.141.2021.05.02.20.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 20:51:40 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Krzysztof Halasa <khc@pm.waw.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net] Revert "drivers/net/wan/hdlc_fr: Fix a double free in pvc_xmit"
Date:   Sun,  2 May 2021 20:51:36 -0700
Message-Id: <20210503035136.22063-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 1b479fb80160
("drivers/net/wan/hdlc_fr: Fix a double free in pvc_xmit").

1. This commit is incorrect. "__skb_pad" will NOT free the skb on
failure when its "free_on_error" parameter is "false".

2. This commit claims to fix my commit. But it didn't CC me??

Fixes: 1b479fb80160 ("drivers/net/wan/hdlc_fr: Fix a double free in pvc_xmit")
Cc: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 4d9dc7d15908..0720f5f92caa 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -415,7 +415,7 @@ static netdev_tx_t pvc_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		if (pad > 0) { /* Pad the frame with zeros */
 			if (__skb_pad(skb, pad, false))
-				goto out;
+				goto drop;
 			skb_put(skb, pad);
 		}
 	}
@@ -448,9 +448,8 @@ static netdev_tx_t pvc_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 
 drop:
-	kfree_skb(skb);
-out:
 	dev->stats.tx_dropped++;
+	kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
 
-- 
2.27.0

