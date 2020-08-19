Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3FD324974F
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgHSH27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbgHSHZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:25:10 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51862C06136D
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:27 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id r15so10540937wrp.13
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4rLwtBvMkow5I5GDEjyJuOU5JzSfmTUQSvGDHlfWV2k=;
        b=p2YS8erqOU/gjRtz4iVLLaMMKfXmVFvrRVi+3sc8ekfq/H7rh07Ky8kWW8qm0xOl7H
         gICMIUqThUQIq3Aj/P84e9220rP4seaClfp6TMWzMKTx9I2Ety6ePlpWYYv/utFTZsu1
         f2/fvNKQsuhAz2wlvL7xLEdinCCwVSsBIgKuCbEhIC7LAQAIFGEZi70S8Rdrn96JDPUK
         f9hnU3tzZ923q8b5VmYM+HniJ0SpwLYOmE+L+Fbo/pgx6qnGENDwbVdr+zRlE/ilG9bN
         SuntGeq2+BPuuCZAszBdrXBYL7/mzh8XwphBNHQCuRc9i0ANcXv3Xhp1njCVJTMkztza
         Mieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4rLwtBvMkow5I5GDEjyJuOU5JzSfmTUQSvGDHlfWV2k=;
        b=OyK6d5l8dRSpbmwFDayN79MGD2Q1QQsnbOmX9jZi435pC3v/8bvLVRrzN6tc94QowK
         ry0/6RvIasX3UBKBcUGv9L+Q6nUeH9pU33vHv8uv0EfLSvTNPrZ3Cp0umybxhXT7t07L
         cqbcgsB/0EJeeuJ3TzSauBreuiFZ/ymtfbfy25hkvgxDl+lbN0nKV9DBDI14698hg8RP
         LhDIID9LVxi4eSrQbVF4j2ZahmVCaLzjwediuRRuMLMxWYYDltC4zo8mUO6o06tzdWbc
         Zl9xjag9TiW5SbHgzuaDngQNKZ+Kk1vK19By8Bnh6i0tZb6uOpp85UkPEIza28gDgW7Y
         Uq3Q==
X-Gm-Message-State: AOAM533jbxLuGQVKNCSIICYebAnVoF6Q1GcboE9V0OdPN+sjJl5gaoG0
        1jAwohaTkAr1sadhRCj8nwL2Nw==
X-Google-Smtp-Source: ABdhPJzXBn1IXHXSUSbWLBLOHC10XUr5FZWPQa6flhRI76F8vknBKoswuQD38N8iOhXv4eE0P0x7Og==
X-Received: by 2002:adf:bc4b:: with SMTP id a11mr22292936wrh.381.1597821865954;
        Wed, 19 Aug 2020 00:24:25 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id c145sm3795808wmd.7.2020.08.19.00.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 00:24:25 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Subject: [PATCH 17/28] wireless: rsi: rsi_91x_main: Fix misnamed function parameter 'rx_pkt'
Date:   Wed, 19 Aug 2020 08:23:51 +0100
Message-Id: <20200819072402.3085022-18-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819072402.3085022-1-lee.jones@linaro.org>
References: <20200819072402.3085022-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/rsi/rsi_91x_main.c:157: warning: Function parameter or member 'rx_pkt' not described in 'rsi_read_pkt'
 drivers/net/wireless/rsi/rsi_91x_main.c:157: warning: Excess function parameter 'rcv_pkt' description in 'rsi_read_pkt'

Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/rsi/rsi_91x_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 576f51f9b4a7e..9a3d2439a8e7a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -148,7 +148,7 @@ static struct sk_buff *rsi_prepare_skb(struct rsi_common *common,
 /**
  * rsi_read_pkt() - This function reads frames from the card.
  * @common: Pointer to the driver private structure.
- * @rcv_pkt: Received pkt.
+ * @rx_pkt: Received pkt.
  * @rcv_pkt_len: Received pkt length. In case of USB it is 0.
  *
  * Return: 0 on success, -1 on failure.
-- 
2.25.1

