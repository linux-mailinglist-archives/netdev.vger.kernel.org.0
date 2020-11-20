Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537D42BA3D5
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 08:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgKTHuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 02:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgKTHuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 02:50:08 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEDEC0613CF;
        Thu, 19 Nov 2020 23:50:06 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id q10so7092734pfn.0;
        Thu, 19 Nov 2020 23:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lEfZb4daZScUklBiNuYLi7g4cfVyq/meS+BFrwd1Myo=;
        b=Ba2VXotgppH4nkVR4KQKycDMpluqrRUF+MIUS0NRuTh1919LMjlJSmUD5KkqFsN34W
         C8AKvUR4aziTkR6rUKwdkVmiJV9Ab5bGDHVyIZ7h7ynNd8zncalcQr8rn5tG3v3jTIoW
         hmABTx16qnq91g8/r8akWcmW2qESyms1LyjFBAmQId6WEviCxWPNEaFcUu1/B4ZlNsS+
         h+5ranm4RMSjFSWiUDQ73O5QhoRyzo6NjF3P91P9tPpnNiX8sgxQJ1MkST/Cu9zz55z8
         6667sj0CuYrUKXhNQ+8Oa8LaHcRVipKKB3L3tzyng1kRozvtP9DEbyC5T6exd58ksd/7
         kMPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lEfZb4daZScUklBiNuYLi7g4cfVyq/meS+BFrwd1Myo=;
        b=ZMR35Ipu3XIVlgCqT0PLc65KjNLkdjBJangDIPovylWQS1XhSwVWskjZQUOxM1m74a
         VEmwdFFCZKe1DOs18iNqW8s1FyKKqpAvjNCO45hzwvqoCY64c2KkgKQjvGuW5nDyRxzj
         PEb2APbkl27mapI6DMCp4V1zoQgFNtj3fATtrol8BROkoznofUM0cjDWD71MWRCUzFuY
         RpFa/KucidLzkU6xHlnhymrQ7FWd51CPpmHC74zvxS2tFDh5oifUMyWJVz9muF6GCN6r
         uUstpxSDDkjp0XxZ9AFkmvCm1VIRDEyXjbzGc3bUAFWPm84BPpE5gn0HSpO6EtWSBc1H
         tYOw==
X-Gm-Message-State: AOAM533nPpwTOXwECrEaZJCNOUsNX8XwYz1LoRD9ViPpkpr9JDGdkuAf
        +cj5iyeeExM4U0gKPSL9pg==
X-Google-Smtp-Source: ABdhPJw3ttoEDnNbsCZcHmIudvdVSeUFeCLlz3DW9MtaBD5okjoozVR7QiqGeVQ3J6Sr8+sJtx/BRQ==
X-Received: by 2002:a63:c053:: with SMTP id z19mr15681965pgi.418.1605858606440;
        Thu, 19 Nov 2020 23:50:06 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id v1sm2503851pjs.16.2020.11.19.23.50.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Nov 2020 23:50:05 -0800 (PST)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     ionut@badula.org, kuba@kernel.org, leon@kernel.org,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] net: adaptec: remove dead code in set_vlan_mode
Date:   Fri, 20 Nov 2020 15:50:00 +0800
Message-Id: <1605858600-7096-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The body of the if statement can be executed only when the variable
vlan_count equals to 32, so the condition of the while statement can
not be true and the while statement is dead code. Remove it.

Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 drivers/net/ethernet/adaptec/starfire.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
index 555299737b51..ad27a9fa5e95 100644
--- a/drivers/net/ethernet/adaptec/starfire.c
+++ b/drivers/net/ethernet/adaptec/starfire.c
@@ -1754,14 +1754,9 @@ static u32 set_vlan_mode(struct netdev_private *np)
 		filter_addr += 16;
 		vlan_count++;
 	}
-	if (vlan_count == 32) {
+	if (vlan_count == 32)
 		ret |= PerfectFilterVlan;
-		while (vlan_count < 32) {
-			writew(0, filter_addr);
-			filter_addr += 16;
-			vlan_count++;
-		}
-	}
+
 	return ret;
 }
 #endif /* VLAN_SUPPORT */
-- 
2.20.0

