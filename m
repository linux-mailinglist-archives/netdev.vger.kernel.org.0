Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 771A4588FF
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfF0RoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:44:10 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34913 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfF0RoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:44:07 -0400
Received: by mail-pl1-f195.google.com with SMTP id w24so1686746plp.2;
        Thu, 27 Jun 2019 10:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=l9lSV6b1ipoXEd8WKJZw54y2LcR9Ww5Z/zUwt9y3Dvc=;
        b=kZoUqFcyjJwLpQIyLIf/9ykIHAeZ0vMBfUW75BfZMqMC+MLZGTDX+2Njm81xFWisUs
         jA2Ss2K/eoNGiU3M6ZuqJ6CFZJs4derwXXkZm3DkgpQQWI55M0S9IHXbQtaz5Qo6XzU1
         yayU4bKIBAGEQHPVpdG76r9awHMxig/lQbKrdbFwIND9Iu4+2JRdqw7QrLGR9QRL9S7M
         FXCucjtVCGlH7yvkaqkp8fpll5OqqTwY2zo6Tzmn6KGuiSZ5UrfkdF2j3W04rT0szCt9
         F8Bwg/iw0SH7/vDWXkc4YCnMg4hfYuk/aZPUzsi/v9moecgC2xzbfGniJeAi3l7JVoPd
         27Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=l9lSV6b1ipoXEd8WKJZw54y2LcR9Ww5Z/zUwt9y3Dvc=;
        b=Kp8G1UJD1vtcXcFk2qtIPp5bsxaaWDPMcI3RYLlco2Z1gNgVrCpdrL95EnNoNAfLIg
         opSnJ4H4uZKx+RA/nldF9nkwF/wXO+44by4OOb+ORC0CHpV24XRomKH461bPxi7haXnG
         SP6s5m4S+IhrtuMVEu/ZNZg116szGD2L+o48l9hkuMToQIqYbq/K9Kp3ltPjJn128B2l
         2nxSYa5Rk2QjiMc7GR+FY0CDRqgLPrh9Yio/9V2EulFiQn3xOkRNCjpytmO3n2ZD/uoX
         5D1I9oRZcDeHS/SaXvKrSnM6QHSRvyR074Zefapw+TtI2P3w79bpM+UTypEiTYCXfx+f
         0eRQ==
X-Gm-Message-State: APjAAAVr1Zpxh+pJbFJ6s1Jj+tSZZSxu6+0qJ2lYHoKeJ1XvFujyTFuG
        y9Rc5G/pMtGkxXpe2RJ5f+Evg3eoBzteMg==
X-Google-Smtp-Source: APXvYqy141o2pCSFcghigVTcTQcDjL/zFPXsG/bCSBrXgxM8vjcT7tJtWdmX17niHVUMqnfRsf2h0g==
X-Received: by 2002:a17:902:121:: with SMTP id 30mr5804893plb.314.1561657446272;
        Thu, 27 Jun 2019 10:44:06 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id j16sm5096105pjz.31.2019.06.27.10.44.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:44:05 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Jon Mason <jdmason@kudzu.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 83/87] ethernet: neterion: remove memset after pci_alloc_persistent
Date:   Fri, 28 Jun 2019 01:43:59 +0800
Message-Id: <20190627174359.5307-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pci_alloc_persistent calls dma_alloc_coherent directly.
In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/ethernet/neterion/s2io.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 3b2ae1a21678..e0b2bf327905 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -747,7 +747,6 @@ static int init_shared_mem(struct s2io_nic *nic)
 				return -ENOMEM;
 			}
 			mem_allocated += size;
-			memset(tmp_v_addr, 0, size);
 
 			size = sizeof(struct rxd_info) *
 				rxd_count[nic->rxd_mode];
-- 
2.11.0

