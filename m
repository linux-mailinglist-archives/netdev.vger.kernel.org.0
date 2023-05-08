Return-Path: <netdev+bounces-982-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B38326FBB54
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 01:18:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EFB51C20A9F
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 23:18:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 959BF11CA2;
	Mon,  8 May 2023 23:18:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886A2DDA9
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 23:18:01 +0000 (UTC)
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8466555B2;
	Mon,  8 May 2023 16:18:00 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-6439e6f5a33so2694570b3a.2;
        Mon, 08 May 2023 16:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683587879; x=1686179879;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=untJNAyHEtCOqPSu4bMCDqJTO16k2riA5x50pJ7uqas=;
        b=ONpAAB48NLP2jniOxsNfwNbyMLbswMoj8u8jV/XbEicERzgcaetI0bUKXkn7UnebiZ
         KWwYzoNQ8j5v8bSs7SfXmEqXFEfS7kvOhF9M3CGrnPcYTLXjS9D6abng/Hqr8pWLVQbD
         /sAi0CTbkunO1sJdYlxN0VU0OR67ru3Z5jhepnhCik4NT/8FNDeIX3ecAlH8XOrsHElI
         pLzliNG+8Pzn1FNEanEwD8b7YOeR9ZEfXlVdDlEbghzBdeJSLtHq8oWjQxHjuD/9Mgei
         fwbTMJGRQImVySxIlq+P2n/lH6fa/ys2nHJ0ahUDMFXsG8bTmQIryH0i7KODY8rMB7ZP
         A+cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683587879; x=1686179879;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=untJNAyHEtCOqPSu4bMCDqJTO16k2riA5x50pJ7uqas=;
        b=F5vvY5rM1cqIz/B/BxmdBMN+vMASipLXBPZP6CMc7SrwgeHT4Lc4REYxavhX4yqd41
         Kw9XCCKyrNfCzE9vvFSEe/JhqS7543zhD3/Pbz4Z3PKTlrbgBEJcD4pUTctJQQV68vm5
         rr3f6jIjm6+i8xiPSXPxsa3CIhH0sbUwCvbSpYd0l2sH40nYvICDAhsfCSLWZosN2ic2
         p5d7pWN1pkiJKkC9+8vtwt7TOb1xsU98q4/FNhBqF3n9dCf5pZaKrpLKgKJfODd49Qpt
         aMpsleQ8bQEtDcniJVOFguoiXkrRB0e+22iYEOp5uTC1MyXS9XCPmnIUpSwC7fnkKLf9
         5vRQ==
X-Gm-Message-State: AC+VfDyQI+2U/ZjMFPYF/0uyne03I0oFVWQt8NSz0Xan3MrLvhhQMtWb
	S0cZMxXgQ6/1+rR5aMQStlXHESBC87o=
X-Google-Smtp-Source: ACHHUZ74EFWLSS3SWATY5OUE1psn/mGdFJ+7q6+IMcPzlOluXuKlfuueWJMV6MlDO/N6tkz5NZFJOQ==
X-Received: by 2002:a05:6a00:1496:b0:643:857d:879a with SMTP id v22-20020a056a00149600b00643857d879amr17311223pfu.24.1683587879397;
        Mon, 08 May 2023 16:17:59 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f17-20020aa78b11000000b00642ea56f06fsm531922pfd.0.2023.05.08.16.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 16:17:58 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: phy: bcm7xx: Correct read from expansion register
Date: Mon,  8 May 2023 16:17:49 -0700
Message-Id: <20230508231749.1681169-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Since the driver works in the "legacy" addressing mode, we need to write
to the expansion register (0x17) with bits 11:8 set to 0xf to properly
select the expansion register passed as argument.

Fixes: f68d08c437f9 ("net: phy: bcm7xxx: Add EPHY entry for 72165")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/bcm-phy-lib.h | 5 +++++
 drivers/net/phy/bcm7xxx.c     | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/bcm-phy-lib.h b/drivers/net/phy/bcm-phy-lib.h
index 9902fb182099..729db441797a 100644
--- a/drivers/net/phy/bcm-phy-lib.h
+++ b/drivers/net/phy/bcm-phy-lib.h
@@ -40,6 +40,11 @@ static inline int bcm_phy_write_exp_sel(struct phy_device *phydev,
 	return bcm_phy_write_exp(phydev, reg | MII_BCM54XX_EXP_SEL_ER, val);
 }
 
+static inline int bcm_phy_read_exp_sel(struct phy_device *phydev, u16 reg)
+{
+	return bcm_phy_read_exp(phydev, reg | MII_BCM54XX_EXP_SEL_ER);
+}
+
 int bcm54xx_auxctl_write(struct phy_device *phydev, u16 regnum, u16 val);
 int bcm54xx_auxctl_read(struct phy_device *phydev, u16 regnum);
 
diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index 06be71ecd2f8..f8c17a253f8b 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -486,7 +486,7 @@ static int bcm7xxx_16nm_ephy_afe_config(struct phy_device *phydev)
 	bcm_phy_write_misc(phydev, 0x0038, 0x0002, 0xede0);
 
 	/* Read CORE_EXPA9 */
-	tmp = bcm_phy_read_exp(phydev, 0x00a9);
+	tmp = bcm_phy_read_exp_sel(phydev, 0x00a9);
 	/* CORE_EXPA9[6:1] is rcalcode[5:0] */
 	rcalcode = (tmp & 0x7e) / 2;
 	/* Correct RCAL code + 1 is -1% rprogr, LP: +16 */
-- 
2.34.1


