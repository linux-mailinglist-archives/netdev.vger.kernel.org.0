Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81181301E5A
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 20:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbhAXTJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 14:09:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49443 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726222AbhAXTJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 14:09:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611515295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BObjur6w5Zyn1iSvTdoLrwThuMrSePyOuptlnRaBSlQ=;
        b=Qb6EUNcsPenzvyMw6SSIX0M4/z/7Fjphl2PJMblu4BtI/xxNVVFzH/uzMehsV4M6Ayc/9x
        gQVNwazVC06B9NA4UjppJspH/WeGiSHGARgr2qnmoU45r+xC3y2e60eaTij87+VcNKNps+
        uesJpMDNPsJuIHMYeMGDqN0eFaCgMUg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-bPRF2wL1OV6TcgnAXDlwTA-1; Sun, 24 Jan 2021 14:08:13 -0500
X-MC-Unique: bPRF2wL1OV6TcgnAXDlwTA-1
Received: by mail-qv1-f70.google.com with SMTP id l3so3616993qvz.12
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 11:08:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BObjur6w5Zyn1iSvTdoLrwThuMrSePyOuptlnRaBSlQ=;
        b=KoUkXZg+bKMipY9y8yKF2sA6/OYNrjL1NAwot2NLiSJ04eM5d+vRJVZLgozJDaFm8J
         jeSL6mpeNvP0EA8gs+q13ZbLAq/ZtA3LuXCS/0tV3SI0Jvyqpfsje7Nyhy7dv9ZMhTp3
         ++ILiRml9CUWLmHedQu/CvC6ynDBTy9/FXcOWSUaFjQi6YO81yl2wCOtRb9lteI6aC0i
         abDy3gGn31OJ2gu5qEWUOVHN0ZhHpg2egBDC/HeuD20x81DiqvdekeqTbijOgdEYHQlc
         IQvpQIMMOqc1E8rTJn5Mtw/6h34j84wlSDaGZ/1k/ANTuTVUtZcNQ5D6eCNnHm+B52i6
         hDqA==
X-Gm-Message-State: AOAM530IIF+zOStXaKaFavHINxG+bkCbxjkBcdYavDoCjDNJZFWYZZHe
        J4ZJAMEZxwQwtXikWrYlNJ/NaUImFVmabpAIH3Ba2KdDkdqc05Fd7/O/lnTDaUVBYOYEfB0Nkgf
        V2Fh5bxOUa1NsZRs0
X-Received: by 2002:a37:a34f:: with SMTP id m76mr2283306qke.89.1611515293125;
        Sun, 24 Jan 2021 11:08:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxieGe00q6W3nNVZzjzXXukregAstLEMA0R4TytIKTfozNtBu6iJHMnLbESe6ZwJ6U65F7Cxw==
X-Received: by 2002:a37:a34f:: with SMTP id m76mr2283292qke.89.1611515292916;
        Sun, 24 Jan 2021 11:08:12 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id v8sm10038052qtq.80.2021.01.24.11.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jan 2021 11:08:12 -0800 (PST)
From:   trix@redhat.com
To:     davem@davemloft.net, kuba@kernel.org, maheshb@google.com,
        edumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] ipvlan: remove h from printk format specifier
Date:   Sun, 24 Jan 2021 11:08:04 -0800
Message-Id: <20210124190804.1964580-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

This change fixes the checkpatch warning described in this commit
commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of
  unnecessary %h[xudi] and %hh[xudi]")

Standard integer promotion is already done and %hx and %hhx is useless
so do not encourage the use of %hh[xudi] or %h[xudi].

Cleanup output to use __func__ over explicit function strings.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ipvlan/ipvlan_core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index 8801d093135c..6cd50106e611 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -651,8 +651,7 @@ int ipvlan_queue_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	/* Should not reach here */
-	WARN_ONCE(true, "ipvlan_queue_xmit() called for mode = [%hx]\n",
-			  port->mode);
+	WARN_ONCE(true, "%s called for mode = [%x]\n", __func__, port->mode);
 out:
 	kfree_skb(skb);
 	return NET_XMIT_DROP;
@@ -749,8 +748,7 @@ rx_handler_result_t ipvlan_handle_frame(struct sk_buff **pskb)
 	}
 
 	/* Should not reach here */
-	WARN_ONCE(true, "ipvlan_handle_frame() called for mode = [%hx]\n",
-			  port->mode);
+	WARN_ONCE(true, "%s called for mode = [%x]\n", __func__, port->mode);
 	kfree_skb(skb);
 	return RX_HANDLER_CONSUMED;
 }
-- 
2.27.0

