Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406AE2F5B6F
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 08:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbhANHjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 02:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbhANHju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 02:39:50 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A700C061575;
        Wed, 13 Jan 2021 23:39:10 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id p15so2536153pjv.3;
        Wed, 13 Jan 2021 23:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rvhN3aTOzOTNxmpEYBaHxzDtDQoYpqXFe9XFc5qQrWE=;
        b=lCW+6BXLhHMFxXrw2vK6Q1m+1DarAnxVhOlHkbv6uaFq9tgf9saTz5Awr4KJDepPLb
         YOQcZ9v72o2yID1Psc4Uwu/15Aw4yTjN/TtoYT/EBpyjFoJrH0QyN/tw6AXKwdu+6SPq
         co7XQKyj48/MbU4MuA/FVjn44AFfALRqYLMSNxllbHbmYxc3kKw0dXMPG1uL8vA5prfr
         Lth17oqjNKo+lJDpmtpGlVQHHqvY699MuRZ2s1o6hKlKuVu3rGMBKdb85PEHou8Uu1gH
         ECq5HfC1IQW1n18DPx2t55B5J9q2CgykbB1/t8RA6ZIlZzksNJ7U6tmOUIQfVdXpRiyA
         9NyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rvhN3aTOzOTNxmpEYBaHxzDtDQoYpqXFe9XFc5qQrWE=;
        b=q6brNPV7eeBk/wT+YEUefQS742tRxS/FyckHFdaFZLzNDpfNHL4xoUHZsEHiXlUO37
         4V3d3cC4e7ARn713/ofUN+Wt0j+ff7uq/x6IhfN+RVZmsk/vBBPhT9XayKYL8XI04KlV
         hlMiMKC6k/ryVCIAqtsqz1p7BZZ6KRcs0//4QQpQE2BD8q/6vi4eFtqyE5h5l3mkNrWm
         s/6JHI6R/Kg5f3/CUbphy7T1EFWM+HNFTnQ0V5xGmgXc+j/qVqvORD36rcamYyWWFHlk
         zRRGKrtAYvkKZTz47GaN1KyMBWrllAxBwV3yy3jQcvppp2sFPj56JFelR1Dmgtyp56fM
         Z1nQ==
X-Gm-Message-State: AOAM532QCvDh8/8CD2LcpRhoSW84ibiKXf6t8FYzqGjd5YAYY5QTPQrK
        p23mIBFPI24dFRc+dRGkEro=
X-Google-Smtp-Source: ABdhPJxQ+CI11qO3Num/6lJE3aFajiF+8R2MaYCcqcSyKN5jxKoIsla22SVNQj8Nr7dFseiJ03IQ9w==
X-Received: by 2002:a17:90a:c798:: with SMTP id gn24mr3645400pjb.49.1610609950251;
        Wed, 13 Jan 2021 23:39:10 -0800 (PST)
Received: from localhost.localdomain ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id r67sm4221109pfc.82.2021.01.13.23.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 23:39:09 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH net-next] net: tap: use eth_type_vlan in tap_get_user
Date:   Wed, 13 Jan 2021 23:37:18 -0800
Message-Id: <20210114073718.5972-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

Replace the check for ETH_P_8021Q and ETH_P_8021AD in
tap_get_user with eth_type_vlan.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 drivers/net/tap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 3c652c8ac5ba..cf9197fe3bb6 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -713,8 +713,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	skb_probe_transport_header(skb);
 
 	/* Move network header to the right position for VLAN tagged packets */
-	if ((skb->protocol == htons(ETH_P_8021Q) ||
-	     skb->protocol == htons(ETH_P_8021AD)) &&
+	if (eth_type_vlan(skb->protocol) &&
 	    __vlan_get_protocol(skb, skb->protocol, &depth) != 0)
 		skb_set_network_header(skb, depth);
 
-- 
2.25.1

