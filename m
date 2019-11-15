Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9A0DFD302
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 03:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfKOCcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 21:32:11 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46483 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbfKOCcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 21:32:10 -0500
Received: by mail-pl1-f195.google.com with SMTP id l4so3590426plt.13;
        Thu, 14 Nov 2019 18:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fttiw/oDs0Uq/UnWiexTFTxknwV5NhGvclqPw1ctNSU=;
        b=HJDRQGwiWTXXahopW3SPScUyfWClkXLkzhOMG+QqK5jZByeQfh2vI1DxspRH7/DRWU
         +qdS/AIqHnPA7hx26YkxeazCQeXxCF2IXaeDf69MDsULoP+dmIyueLysDK28M8G1taYq
         SgnyFmHlULD4/xx56TDNVD5U+JH2/qkquWYHLNvicyUbc2SPndcWFah8JxMz+fLwBlbj
         Je2U8vvRtE0YygnIAAchhCS84v6e3yRKoQGAno1diVGzapVLUHviod28rr7KioVrVjdt
         AcYYit7rKve6odhXePpnEWvhEN7xh9TLAPAO2EA/jsykn+6PL3I61C0UQr0YQmFUchKi
         XlYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fttiw/oDs0Uq/UnWiexTFTxknwV5NhGvclqPw1ctNSU=;
        b=aUJn8xnt+GlTRHbLNeffth1IgiZlESOJd5uc7c3ooIAfIyTzUKAQdh/KF8OcChSzfp
         Kul2255mL1efCC6DI7OvuKB5FTZCPzGrFBiwButjO664M5+dxd6ZmM2Iey6PCmUaf3wy
         Nuy0M0rEanKKKUYLTwAOD7f7xvKEFoivaev0VKE72KcuTvNH2SWtFYiwuzazRdtV+jwE
         tVIygLeUTNiOefIfYOylCDLN8hYgk+TQgXvVfkRxLOIj+VfwC7q8J6EP3HK2ufGL50aT
         UzqY5nfLVYAS6MS1Nhvu8AEqTXLcIjSZ9MDaLkIiWvW5B8H31CyO4I2u1Ly3z819Lzp9
         irUQ==
X-Gm-Message-State: APjAAAW4QqyH09FRROq4BNQZhPPNfOs6FgIiMajnO9vEI4VUV4+Ko+X6
        dgM16udKkU5cHbWR+lSK73w=
X-Google-Smtp-Source: APXvYqw5ylN3GmwZ9XCb7MShZDLrbWVcOxet3FjwxUvO1N+H10zg72dbh/XJTvtrQvZtGVwhA7YNUg==
X-Received: by 2002:a17:902:7444:: with SMTP id e4mr12548883plt.48.1573785130116;
        Thu, 14 Nov 2019 18:32:10 -0800 (PST)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id a16sm7691223pfc.56.2019.11.14.18.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 18:32:09 -0800 (PST)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] net: macb: add missed tasklet_kill
Date:   Fri, 15 Nov 2019 10:32:01 +0800
Message-Id: <20191115023201.7188-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver forgets to kill tasklet in remove.
Add the call to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 1e1b774e1953..2ec416098fa3 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4383,6 +4383,7 @@ static int macb_remove(struct platform_device *pdev)
 
 	if (dev) {
 		bp = netdev_priv(dev);
+		tasklet_kill(&bp->hresp_err_tasklet);
 		if (dev->phydev)
 			phy_disconnect(dev->phydev);
 		mdiobus_unregister(bp->mii_bus);
-- 
2.24.0

