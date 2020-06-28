Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADB520CA0E
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgF1Txx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbgF1Txt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:53:49 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD15CC03E97E;
        Sun, 28 Jun 2020 12:53:48 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id w6so14532239ejq.6;
        Sun, 28 Jun 2020 12:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GAh3jR68wgJM9kQ3sHQbEk56iwElaVOIR9OPU/4rPds=;
        b=XRdwSXBgrLhj2utqI68nf8GOh4/SkU9hSeBQT+V+0n991mPG73mnDlgaL0RHwSQOIx
         WY84aTP9jlZCgoMS8UzntBhTMtS+xkOsCsdIHsKFVhzU5x9ds47KUYYzprNC3DEDrLz5
         +uNBGpum4mkdbE2rlRCeEI1IoFIvQ88q5NKUxsULntdztZJkvfHKWVd+JzcdBK5vnJGD
         PPtePaxP7WWoZIknYo0WpkJIjQrtkEx0CdWkUqqAmc5tsfPJOd2x1bcSG0JPknJrWr+g
         4NnEtyGn2XqHJfg60ILF2E0ADb6oGGZ4EeXNHj2YWAQKXCNtqkF7+eLmlgEHWygLEqro
         IzGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GAh3jR68wgJM9kQ3sHQbEk56iwElaVOIR9OPU/4rPds=;
        b=Bnr27tl6QduzqTko2Y7U8ZtIzk8J5kBiYTF8PQ+amOJpyH/rHlsQxyIfwJFF0lmHMZ
         mcNghyAbouFDWoncbrZkPaOefa7u9fpw4t7owLJ1jWxXK1WXbU6qTcfZcmt+bCHsQJ0x
         eC4XqXE+7jmElsaMS4vxrqcNpbWkCJ+OqwsgudV79oA5gQ/ryhjPnfbC5MR4QW5Joayl
         5lzDwcnHXx3TEOhBNeV84C5bu70Z/bjwSrAsPspPaFna1zRLNaWRFf+TKdnmf9YNswbs
         CIV1V1XCeesYP6k/NHl5VmMocPA6NZa27zpr6N382CPzlzdlFAcE7/+QhUvspjnlTEXb
         IVbw==
X-Gm-Message-State: AOAM531cGznEcz5oU4aaUmuTYh5GeFPFIdsVJxw1Cn8X86xXe0Y0EtBJ
        qa3yp7GbyVfpJb/JWrLRsVY=
X-Google-Smtp-Source: ABdhPJwGie1cbQx6Vz03PllFxAbz5fc1wX1U1xnNJLGeVBST0inZZLqC6iSWnxJA9AWA9KcgrZz2jw==
X-Received: by 2002:a17:906:c10f:: with SMTP id do15mr11773252ejc.249.1593374027553;
        Sun, 28 Jun 2020 12:53:47 -0700 (PDT)
Received: from localhost.localdomain ([2a02:a03f:b7f9:7600:f145:9a83:6418:5a5c])
        by smtp.gmail.com with ESMTPSA id z8sm15669531eju.106.2020.06.28.12.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:53:47 -0700 (PDT)
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH 05/15] net: aquantia: fix aq_ndev_start_xmit()'s return type
Date:   Sun, 28 Jun 2020 21:53:27 +0200
Message-Id: <20200628195337.75889-6-luc.vanoostenryck@gmail.com>
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
 drivers/net/ethernet/aquantia/atlantic/aq_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 8a1da044e908..6c85005cd2e9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -94,7 +94,7 @@ static int aq_ndev_close(struct net_device *ndev)
 	return err;
 }
 
-static int aq_ndev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t aq_ndev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 
-- 
2.27.0

