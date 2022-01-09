Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455A4488A9B
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 17:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235179AbiAIQhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 11:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiAIQhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 11:37:10 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B583C06173F
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 08:37:09 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id t19so8677228pfg.9
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 08:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=fSLiuTIUPx0yzHqqCkYdjCnxwHzQQljPS330G9n4jBM=;
        b=IeoH86C0CuaM2oOLhkDbZv6HyHcI/eg6F3fR66tgA9m6oQU5FsHeVyA6HpovNeqrYd
         519fHhysfVhxE7+E0UVLStKObFxisHAnvY/Ui/40EcR7yEmxWpSgHKrURiN3O1mOkumH
         pDNuan9515B1lrEyZpua9p6WU02xtzRe14TcrhzyPVfXaDGEdRIPztjZPE50kbPXlEpr
         yn9b4E2V7NM87ZxL1YrhVUohtPa1Qj5pwLgf6/Mr55k4lGqPrcvSqQA14WqlOOEw9Kwf
         +vJwJuKKLapWZpaLuzrNVwsz+79Cx9+7w5B0lNDWeGdfxDHuDKuUcuDZA64ownRVyDDi
         Bi4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fSLiuTIUPx0yzHqqCkYdjCnxwHzQQljPS330G9n4jBM=;
        b=JfDpJKDl0YL1cBqwg47YgwhNMrkNQbhs+Z55tZ8tTH58rut+EbsuSuW8alrdxIhZLI
         c907ESYV5ZufbCgK/mI3KCUUxhSoqeXt9rwtYREmCKFmWvj0HLo4Du6KvJ/HMFKZCZqL
         pRvIkujepMmc7XBrP5H+Lh2p2aj0P3b4lk2nBsaSlw+HDKmlI51pmbOVjeWuApLOD5Vf
         60pCjwGVO9NeHx2HfY0D9SiD/qL3Km0SalNcF82cMj8qqto3R/oIF4yfJo/3Q1t209o+
         ZRzPk2BAZuPuebSv2q0c+h2Sg849fe2SP2h1aiHMb7TyXtGPPoc3Re2zIGNYQYFEPZXz
         A6zA==
X-Gm-Message-State: AOAM530+dL/q6XGgxUCjfqe2CVNkpVaXccGAgV1CQPVppugBhssRy4c0
        cU28Dv/6ataC8m48eWGVtro=
X-Google-Smtp-Source: ABdhPJwQh1oolWnF04uoMd4rD362P90FBAwAmZZ1H73AKWxWXiLDXq2UibIZ/tSnv3kuR3A5gT/S+Q==
X-Received: by 2002:a05:6a00:1484:b0:4bb:86a:c061 with SMTP id v4-20020a056a00148400b004bb086ac061mr71840056pfu.36.1641746228416;
        Sun, 09 Jan 2022 08:37:08 -0800 (PST)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id z14sm4246465pfh.73.2022.01.09.08.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 08:37:07 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net] amt: fix wrong return type of amt_send_membership_update()
Date:   Sun,  9 Jan 2022 16:37:02 +0000
Message-Id: <20220109163702.6331-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

amt_send_membership_update() would return -1 but it's return type is bool.
So, it should be used TRUE instead of -1.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/amt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index b732ee9a50ef..d3a9dda6c728 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -1106,7 +1106,7 @@ static bool amt_send_membership_query(struct amt_dev *amt,
 	rt = ip_route_output_key(amt->net, &fl4);
 	if (IS_ERR(rt)) {
 		netdev_dbg(amt->dev, "no route to %pI4\n", &tunnel->ip4);
-		return -1;
+		return true;
 	}
 
 	amtmq		= skb_push(skb, sizeof(*amtmq));
-- 
2.17.1

