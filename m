Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4A172D6C
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbfGXL0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:26:42 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34415 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfGXL0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:26:42 -0400
Received: by mail-pf1-f193.google.com with SMTP id b13so20811629pfo.1;
        Wed, 24 Jul 2019 04:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NkTkmAcxOQ0Fl0it4Vs2qb/p1d6OGSSMxUOlTEi7Wjk=;
        b=nQKBteVj/h+CiU3H4ztVVMHva744Ubl1vdSjt6TY5wRtQPtlHv7PPjS04zphNpYmoA
         QlnL1u0XuWNCRZ2Ir9fVlaEHje1DohhrvE5oj/0x8kBMp7gbsFV2D2G6xI1OkDh+e5aS
         9vpJ++sA9K9x2fq7dz198+WZ+x6JT6qK4ZUUrl6e5F+rQE9sDyC7VzMZ0D+SIf2fXmxd
         YsSwUkLUIdrOIMB6Xsz1hFjHbTTy71D5JXmc6O8f/+WN2U1IsiGa8xfF6WinzJAT2vv4
         +SHn5m28ZHMykRccMPrvepL1Ln2ZNYNHTA33uSQk/n/JNqdJP+iRniec1xKYT1QQFyd/
         9F8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NkTkmAcxOQ0Fl0it4Vs2qb/p1d6OGSSMxUOlTEi7Wjk=;
        b=p7GW7c9o6yQi8IynYjVNbSdyYAiZOMfO4YFfPrtX0UZx8fIx0wVM8BAOsZp1pm2JD+
         oDTLSPp7t0nGIiQh2iB3JhuqPDoJogXkFdWgAVHi5LSiV2gX9P5cAO3JRMzZ6uITCDR5
         l/JLRkyVAIzRh5QITRPQPN5A5JGg3Y8ZGnw+zml2yMcC2sjXaUvBnOuFtflTADL/AUFC
         XmA0By7lTr0rcEG9YqNKEBcwQIqbvWF3BCh3JucP7uz/uhp1v0i3HIZKEXfkZF5RJoXu
         G+Fcwdzfsy5PoKRxt3puaGt8KNMWyXfA9WtlIiFrMEEpcHji6sQsSpmx6oxA3M9WXcNl
         wPLg==
X-Gm-Message-State: APjAAAVcwR5YT3k114AFptrYkLnk1Aap4f7PWMaaFYOUqDay4HyOES1N
        zaCmEZaCl2MJvb/+3i8nmAM=
X-Google-Smtp-Source: APXvYqykMiIlwgbbo3B9oqMoHfk5hlux3OzdCgb3SX2ZLFWK/Yr2t/kccNOoWeLuvWOJJRQScygtPg==
X-Received: by 2002:a17:90a:a00d:: with SMTP id q13mr85740343pjp.80.1563967601334;
        Wed, 24 Jul 2019 04:26:41 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id a3sm54801431pje.3.2019.07.24.04.26.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 04:26:40 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net-next 01/10] net: marvell: Use dev_get_drvdata where possible
Date:   Wed, 24 Jul 2019 19:26:34 +0800
Message-Id: <20190724112634.13130-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using to_pci_dev + pci_get_drvdata,
use dev_get_drvdata to make code simpler.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/marvell/skge.c | 6 ++----
 drivers/net/ethernet/marvell/sky2.c | 3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 9ac854c2b371..06dffee81e02 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -4078,8 +4078,7 @@ static void skge_remove(struct pci_dev *pdev)
 #ifdef CONFIG_PM_SLEEP
 static int skge_suspend(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct skge_hw *hw  = pci_get_drvdata(pdev);
+	struct skge_hw *hw  = dev_get_drvdata(dev);
 	int i;
 
 	if (!hw)
@@ -4103,8 +4102,7 @@ static int skge_suspend(struct device *dev)
 
 static int skge_resume(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct skge_hw *hw  = pci_get_drvdata(pdev);
+	struct skge_hw *hw  = dev_get_drvdata(dev);
 	int i, err;
 
 	if (!hw)
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index f518312ffe69..762fe0821923 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -5160,8 +5160,7 @@ static void sky2_remove(struct pci_dev *pdev)
 
 static int sky2_suspend(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct sky2_hw *hw = pci_get_drvdata(pdev);
+	struct sky2_hw *hw = dev_get_drvdata(dev);
 	int i;
 
 	if (!hw)
-- 
2.20.1

