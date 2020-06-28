Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE7E20CA2C
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgF1TzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgF1Txw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:53:52 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4C2C03E97A;
        Sun, 28 Jun 2020 12:53:51 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id n26so572106ejx.0;
        Sun, 28 Jun 2020 12:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KlpGrzTCtPyJoyfux6M/d6BlwBAgvNAg2N/TTZv9fjk=;
        b=seGq1gmrt9AzoVsFCmfZ7S5lWRBAl3VS49TDZajFf9B0dJX9NjmRChfUT+z47wqRu3
         uIZcCL5uTHaIdi4UgP9neNZc+PXnR/6+hSVP2a+Or/e7JkMkdB02xHQi/13Z03vtKuN3
         Q7wiuFvEnRBqsyO+ZLU7dp9XhQZijdC4C3JQMhLhFAm33J00izIz0WwMqUOv1FuRmhL1
         p2hwuY3TDyvF/PoUY6E80YLmP25vrBH/zvWrJStTE2T/kinb3f4fwy+uHFBJV1JcXQmT
         dpK8M3/sXFYlV93xuWpS6imopewlPdWg4QBJ2FqFytW6yj/1/99KorvNK3ZAAOyrJnye
         3mYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KlpGrzTCtPyJoyfux6M/d6BlwBAgvNAg2N/TTZv9fjk=;
        b=Qk1zHg+H4ACU9xB0Hv3Krc87HcwiLgDihASE9RtZWNQkz0kar37vLvfXLJz6KqCHdZ
         575N1pvxH7e4WZeF7igPtcEPh0bbsiN1km0uVk5Gp+NP/2psbizgv9KTwv1dQyijMxvD
         nDGOcV6/ZKdxbihBDfw0XudQfhyFEH6gunC6ei9Gq4i7y/P/UwQ+c8GTRNz2K6pJldtF
         X8aURpSV3+4crTO0duzclJMRvHE7iM8BvLqaGBkXw4nyHM96gFB1c7gKMRAbYCcgxF+n
         wxdHxYO3m3ny2089wf0od93dCMrlGJHFwMCVVFDlCT+tS/+jbQ0REdBGXuOjeGbE17X9
         lnWA==
X-Gm-Message-State: AOAM533oGbWBigdMY/imbHejnxHp4cz/WLSB+nQ3fBhyxJ3qi1ZuvZJl
        DW+2uImuM3xxrNQV8Jpo7ps=
X-Google-Smtp-Source: ABdhPJwlR//gaLh8JyjwPvM+UdpLSeqvOCq/GYuFnWc7AEJprsGbJx/eZkxD37vOA10zDvGRkImzNQ==
X-Received: by 2002:a17:906:7ac9:: with SMTP id k9mr10790029ejo.489.1593374030628;
        Sun, 28 Jun 2020 12:53:50 -0700 (PDT)
Received: from localhost.localdomain ([2a02:a03f:b7f9:7600:f145:9a83:6418:5a5c])
        by smtp.gmail.com with ESMTPSA id z8sm15669531eju.106.2020.06.28.12.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:53:50 -0700 (PDT)
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH 07/15] net: nb8800: fix nb8800_xmit()'s return type
Date:   Sun, 28 Jun 2020 21:53:29 +0200
Message-Id: <20200628195337.75889-8-luc.vanoostenryck@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200628195337.75889-1-luc.vanoostenryck@gmail.com>
References: <20200628195337.75889-1-luc.vanoostenryck@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, but the implementation in this
driver returns an 'int'.

Fix this by returning 'netdev_tx_t' in this driver too.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 drivers/net/ethernet/aurora/nb8800.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aurora/nb8800.c b/drivers/net/ethernet/aurora/nb8800.c
index bc273e0db7ff..5b20185cbd62 100644
--- a/drivers/net/ethernet/aurora/nb8800.c
+++ b/drivers/net/ethernet/aurora/nb8800.c
@@ -384,7 +384,7 @@ static void nb8800_tx_dma_start_irq(struct net_device *dev)
 	spin_unlock(&priv->tx_lock);
 }
 
-static int nb8800_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t nb8800_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct nb8800_priv *priv = netdev_priv(dev);
 	struct nb8800_tx_desc *txd;
-- 
2.27.0

