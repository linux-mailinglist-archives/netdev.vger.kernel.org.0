Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6593AD029
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 18:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235715AbhFRQQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 12:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235424AbhFRQQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 12:16:51 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA9EC061574;
        Fri, 18 Jun 2021 09:14:42 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id a11so4468938lfg.11;
        Fri, 18 Jun 2021 09:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T9okz+M2qPAYpLlhHUmFyKIgqTEHlJ9zAXaCBBl6R2o=;
        b=X/TRDAfHqp3Emi7hNQXLhA/9qb+JxRk9Rtl2H3LK43EM2L9YfbVie+MJq+TOUGNFw6
         gf23cC5NcQn2v2Y3OPMGQFi+XeypenTMBZOAN8fG/Tb231Hp1uq5J6/8Le0HiSF+giRa
         bcjepACjH16YQVOqeIPEF7R5+9UAMCUa3+hKmRP5/xnzgYWUypzjoqa/+oHEM98RjHLv
         myGRQixYozdlQjtutZBwBwX9TCYdRNRVCtKDPPELlAaAtxOBQdAPN35jaPEUQ6vx5DZ5
         FQqiw6fVuFlHI2wCUZ867XdECszBSonAO6cfO7hDhiY4wGZsKH9PWm0hUwM39GdBNVnZ
         2KfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T9okz+M2qPAYpLlhHUmFyKIgqTEHlJ9zAXaCBBl6R2o=;
        b=IFULaHh4cs+GNUJQsiumz/UaR0Kq5xhAm3SOcbfZePZZe8cpJnTxLtCIxrirdPpIiT
         k7AkFt1IhU4bgNUDfOALRlsSxfA6N/eZYevdfNdewCu1LQlPNQ2impzeQQQ2B6xjPZR7
         nJoDoUHZ65bAVV54AIRD9uhCGzwA4wvmYLTeshw+lCm7yW2KOh1ouDgd66XbSGaKF4Yu
         QjOptfHuBHdNZ3xezg7sUfHZE6lKUFF/6GKfa4KEnc3Fk8QJO6KBZMjnwxLuV17A9FI2
         e+oTjzvzY5NliTdKqtZI9kKyzBpFf4vsmkLHxE1y6m1i8+rp3Y03gw18C8LTedVGDmXA
         68PA==
X-Gm-Message-State: AOAM533XnVrQ5bDJ5uyj2dpOQIhac7967logO/dY9WeZv4hmS7egGQm3
        ZMKpYTIIIRKHho/LmzXpkk0=
X-Google-Smtp-Source: ABdhPJxJG+NvjpvDGi1JSzcI+V468eSj7LvLu0XhxSejd6slJ6oF4AuurfyYp3vNP69765Xj7qW31Q==
X-Received: by 2002:a05:6512:15a2:: with SMTP id bp34mr3673389lfb.40.1624032880483;
        Fri, 18 Jun 2021 09:14:40 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.24])
        by smtp.gmail.com with ESMTPSA id t1sm947623lfg.252.2021.06.18.09.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 09:14:40 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        michael@walle.cc, abrodkin@synopsys.com, talz@ezchip.com,
        noamc@ezchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH 2/3] net: ethernet: ezchip: remove redundant check
Date:   Fri, 18 Jun 2021 19:14:37 +0300
Message-Id: <38bf1b24e45d652242318803fa746ab27a9def23.1624032669.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1624032669.git.paskripkin@gmail.com>
References: <cover.1624032669.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

err varibale will be set everytime, when code gets
into this path. This check will just slowdown the execution
and that's all.

Fixes: 0dd077093636 ("NET: Add ezchip ethernet driver")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/ethernet/ezchip/nps_enet.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ezchip/nps_enet.c b/drivers/net/ethernet/ezchip/nps_enet.c
index 20d2c2bb26e4..c562a1e83913 100644
--- a/drivers/net/ethernet/ezchip/nps_enet.c
+++ b/drivers/net/ethernet/ezchip/nps_enet.c
@@ -630,8 +630,7 @@ static s32 nps_enet_probe(struct platform_device *pdev)
 out_netif_api:
 	netif_napi_del(&priv->napi);
 out_netdev:
-	if (err)
-		free_netdev(ndev);
+	free_netdev(ndev);
 
 	return err;
 }
-- 
2.32.0

