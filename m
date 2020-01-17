Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9062140D7B
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 16:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbgAQPKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 10:10:52 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36667 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728512AbgAQPKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 10:10:52 -0500
Received: by mail-pf1-f194.google.com with SMTP id x184so12102505pfb.3;
        Fri, 17 Jan 2020 07:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DesUuflALP+M7Km3HyTVIX1iNswVs/ME2CU4gzFT4Bg=;
        b=DWpBvWGBMlKlVcVxGbxODHWtx994uCyaKuHhJXPGKXe0dvuwCzvW/yIJ93SuOIXiDG
         GBEaabSSZLNcY7B4LCf/yUKKtsvxeVtUDhG2DyC0Z0+16PpUzeerwfDqYfS8gAFgio7Z
         4fh9yBiql1lnwq7tDPBT+XyYUiH0wwZj+Btjc036QRDyfFl9bs9jDMrAhdhEyWQyO8zh
         awk7tB05Lbm12vUCZmPwH9I+/0/fL5is3EkI1yeSumPDOEK0ocqTA7TqGSHRxAeFZ8VH
         CSCc1Q0fBnKaIwkwoDta+nwU6TngMjQoIyiPuOHNG9nMJ1DUsnB8VXRs7ksytmrYUJae
         IE2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DesUuflALP+M7Km3HyTVIX1iNswVs/ME2CU4gzFT4Bg=;
        b=k0PZEQtpv2wS7hw4L6wOWqRzSEbS/uCdkwLuXvefX/FJSWakBAgAeM4Rb27u4RXUgQ
         IwYioySHHYFAQVMmQkJxh6dpONPAooIzKSBsn33esLRH+lSexNE35Wmbm5bYhjxZHyGP
         DXYiOcAjORsTLpOATlJh5qp/aAcMnfl7CpPP4AVs6ZkbGBDKFGM9Z7nNjroNgofnMdOx
         PoUOm/fCdCeVylZue8/N/QSd8WaSrhGDzwyk3+eIL1i5KydKi/NcswcU9i6LjFk4tu7z
         Y3+3NNyiUzgQImzx7qAfyN8Z0r2O4vQ/3N52U16RcvPMQvn7knYac4qkOkjh65taq1uf
         m00Q==
X-Gm-Message-State: APjAAAUOChzuVJ1m/6hB5hDzsXz48VFUHSHzzxBhBWmtwFc7nSIbLns2
        cTXSw/D56Q4Zx+wZGRO+Ab4=
X-Google-Smtp-Source: APXvYqz/UbONNd/ImMYq7DVrn/QXiJMSbUBYaajwrveO1mKgOAMGBMufrQEdkzI2nM0yyNgabqSFjA==
X-Received: by 2002:a63:89c2:: with SMTP id v185mr44627341pgd.135.1579273851867;
        Fri, 17 Jan 2020 07:10:51 -0800 (PST)
Received: from localhost (64.64.229.47.16clouds.com. [64.64.229.47])
        by smtp.gmail.com with ESMTPSA id u13sm7821436pjn.29.2020.01.17.07.10.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 Jan 2020 07:10:51 -0800 (PST)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     alexaundru.ardelean@analog.com, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH] net: phy: adin: fix a warning about msleep
Date:   Fri, 17 Jan 2020 23:10:42 +0800
Message-Id: <20200117151042.28742-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

found a warning by the following command:
./scripts/checkpatch.pl -f drivers/net/phy/adin.c

WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.rst
 #628: FILE: drivers/net/phy/adin.c:628:
+	msleep(10);

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
 drivers/net/phy/adin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index cf5a391c93e6..6de25a2d3a05 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -625,7 +625,7 @@ static int adin_soft_reset(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
-	msleep(10);
+	msleep(20);
 
 	/* If we get a read error something may be wrong */
 	rc = phy_read_mmd(phydev, MDIO_MMD_VEND1,
-- 
2.17.1

