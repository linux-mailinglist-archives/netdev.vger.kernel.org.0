Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F50745E8F5
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 09:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353685AbhKZIHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 03:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346525AbhKZIFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 03:05:23 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F5EC061574;
        Fri, 26 Nov 2021 00:02:08 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso7473097pjb.2;
        Fri, 26 Nov 2021 00:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XzJnyLoKoL2r9pDH+TfKJ6Ptns8brv9wzjSrYeFUJRY=;
        b=jYJZELPktFDX7CAoqTDsvJJLwcNzfbMrmElOJUr1wILVd3TKfNK9SZRHu6MReoeKzX
         /xNnRvvMsmBCTVXsTz0Lh6qogczs0HrsLC9QTWkqPTzeax6bqmTisblUwI2vOc14olut
         YZfoeuGCgOeDGY4RTJhzVx5Btag+g6ZO32+rEQ0Bc9cAk/pWJCHk8aWXybqa8gGj8qBc
         NwOTsOjhhTV8KWOYIOm7HmFFqxOysUS/Y6GL0hIqyn2uKRiza7SXB5ePY+gL6EvJiRmS
         S596D4sN38VUDzi5TfDZ/qWH3aOMjYePRr1l/gEMjXrfXeOEg3ekHoETIuUOEtQCEvls
         PKIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XzJnyLoKoL2r9pDH+TfKJ6Ptns8brv9wzjSrYeFUJRY=;
        b=OkMeh8lOVHfI0tcT8zqX9Kz/u4BiSOllKG33AylV5AIbKsyl5iCVL6SXE/8P2T3yhY
         yPc3kViJN8bJgNGtb/ZLPCkzvUdX960+DnEgPqye0hnNMSjzFliiO8eJOssl0ZcMPmO2
         6xeuvW86o0jdhF6/7thjtF5RwKWrxdPKBIWIkoyXswuC5cxzJbkNV6+PHwcwOG5QZOKZ
         1mnsT4YjTG241ByWdvOgrEe7FmBj+RZCXUzSEPFawcKwHmG/VODXlI2zlG4pmIceBkvK
         tjpaaOey9VkGwC8HcP5mp/27xjoOC3kl+GAXB0qlU/gHQ59FumUHhSe+qezeW/pL5zjX
         OpFg==
X-Gm-Message-State: AOAM530mxa0NxTBjfn4qwEoUZ5L5oAQeHBIGl80BFMIAob2GtNQfrGdL
        0br4YsO0kXcSJ26y30o64qg=
X-Google-Smtp-Source: ABdhPJyEIio+8d028r9zLBU0pWPVjuBfThCeUykJYzCCPF1yuy0UCnKT6HniyuVMlUo9f3fCyvvY3A==
X-Received: by 2002:a17:902:ecc7:b0:141:e920:3b4c with SMTP id a7-20020a170902ecc700b00141e9203b4cmr36931831plh.64.1637913728169;
        Fri, 26 Nov 2021 00:02:08 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id h128sm5589315pfg.212.2021.11.26.00.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 00:02:07 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     nbd@nbd.name
Cc:     lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, deren.wu@mediatek.com,
        deng.changcheng@zte.com.cn, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] mt76: mt7921: fix boolreturn.cocci warning
Date:   Fri, 26 Nov 2021 08:02:01 +0000
Message-Id: <20211126080201.75259-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

./drivers/net/wireless/mediatek/mt76/mt7921/sdio_mac.c: 223: 8-9: WARNING:
return of 0/1 in function 'mt7921s_tx_status_data' with return type bool

Return statements in functions returning bool should use true/false
instead of 1/0.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 drivers/net/wireless/mediatek/mt76/mt7921/sdio_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/sdio_mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/sdio_mac.c
index 137f86a6dbf8..be17ce3ff06e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/sdio_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/sdio_mac.c
@@ -216,5 +216,5 @@ bool mt7921s_tx_status_data(struct mt76_dev *mdev, u8 *update)
 	mt7921_mac_sta_poll(dev);
 	mt7921_mutex_release(dev);
 
-	return 0;
+	return false;
 }
-- 
2.25.1

