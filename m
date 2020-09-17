Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7662D26D13B
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 04:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgIQCd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 22:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgIQCdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 22:33:04 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7124AC06174A;
        Wed, 16 Sep 2020 19:25:27 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id j7so288796plk.11;
        Wed, 16 Sep 2020 19:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UMh2zjZi2urh+dyVn3Ppcopx/FNue09rKnN2uM18EnU=;
        b=bQpGQIUVmgGfuPpuci/amVAMFGggayq1pQHbH88QtDbCikoHa2bGA2CFoTPR7en7PP
         wRCdYevBMRIZsrDHBbzPR/4nuZryC4jIOsrohmRZlHw9NmON/5sXHRnWsMO2gLsa5oSN
         DohNZG2zNGYkRMGlV0fgi2nbEHsLVyUXCFi37mF+fMS5OndQ12HueflcVQal2DyXUqhs
         j7jLG/Mk/bpyVnNHRoHyOV+D5dcjJpq5UenUFSZlNG0xcRkUfXvvLbwBxKWgMpT+imsr
         j+cW/jlTwQumTyZ/0CEXhD/fM3gbshrUDchEMxRjDrjSadS0Y8mvzs+47JwSIJfL84yt
         Dtyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UMh2zjZi2urh+dyVn3Ppcopx/FNue09rKnN2uM18EnU=;
        b=Hj6RFpDd+qPEJsGcR2siKwrUMTJoqZGBkL/XzqiWv+2B3qZXCgkcQEi2Ay+2JoQ/EJ
         v/C4EFhWtWO5x/GHdm6eAb9on7ulwtiOKDY/pgjagTUPSpDaWIJy8jV0xEKTmhEXS4Ul
         OKm2iOzEhXTUdzuoCNunF7wf0q/g2CEINIBgr9b9t/rUmo/Inz73wm1QUuCgmZGUHQsQ
         zCIRLtN6e1mnAmmlvUg3qvHN89pv5chKUEL5Yzb75pRrSjNfqG6JQVJQkBOMLsZd2D+1
         X9Ja7FDygNk6zujTEz5YugW52rYXPOCZSXGkHj06igpyXfw7HkAoYQfUX/q3RSxmWOcg
         tsPQ==
X-Gm-Message-State: AOAM530VAcVFQ8vbN1/ZaxHb/bxq+wx2iYXrKJPBMR7NQ1uQyUnkvKEf
        HPi2L4FDgjjMyhRihUWpK+Nmh3dBYyAhucq0Cuw=
X-Google-Smtp-Source: ABdhPJzFe7q0kIaFdt8uKsrWfv22Krb1nKzPIMjyRtzN7UP5Tf0X27YBOjQ8NN22YVA7+u5BYz0zXQ==
X-Received: by 2002:a17:902:6ac6:b029:cf:85a7:8373 with SMTP id i6-20020a1709026ac6b02900cf85a78373mr26440053plt.2.1600309526746;
        Wed, 16 Sep 2020 19:25:26 -0700 (PDT)
Received: from localhost.localdomain ([47.242.8.30])
        by smtp.gmail.com with ESMTPSA id w203sm18286372pfc.97.2020.09.16.19.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 19:25:26 -0700 (PDT)
From:   Herrington <hankinsea@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hankinsea@gmail.com
Subject: [PATCH] ptp: mark symbols static where possible
Date:   Thu, 17 Sep 2020 10:25:08 +0800
Message-Id: <20200917022508.9732-1-hankinsea@gmail.com>
X-Mailer: git-send-email 2.18.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We get 1 warning when building kernel with W=1:
drivers/ptp/ptp_pch.c:182:5: warning: no previous prototype for ‘pch_ch_control_read’ [-Wmissing-prototypes]
 u32 pch_ch_control_read(struct pci_dev *pdev)
drivers/ptp/ptp_pch.c:193:6: warning: no previous prototype for ‘pch_ch_control_write’ [-Wmissing-prototypes]
 void pch_ch_control_write(struct pci_dev *pdev, u32 val)
drivers/ptp/ptp_pch.c:201:5: warning: no previous prototype for ‘pch_ch_event_read’ [-Wmissing-prototypes]
 u32 pch_ch_event_read(struct pci_dev *pdev)
drivers/ptp/ptp_pch.c:212:6: warning: no previous prototype for ‘pch_ch_event_write’ [-Wmissing-prototypes]
 void pch_ch_event_write(struct pci_dev *pdev, u32 val)
drivers/ptp/ptp_pch.c:220:5: warning: no previous prototype for ‘pch_src_uuid_lo_read’ [-Wmissing-prototypes]
 u32 pch_src_uuid_lo_read(struct pci_dev *pdev)
drivers/ptp/ptp_pch.c:231:5: warning: no previous prototype for ‘pch_src_uuid_hi_read’ [-Wmissing-prototypes]
 u32 pch_src_uuid_hi_read(struct pci_dev *pdev)
drivers/ptp/ptp_pch.c:242:5: warning: no previous prototype for ‘pch_rx_snap_read’ [-Wmissing-prototypes]
 u64 pch_rx_snap_read(struct pci_dev *pdev)
drivers/ptp/ptp_pch.c:259:5: warning: no previous prototype for ‘pch_tx_snap_read’ [-Wmissing-prototypes]
 u64 pch_tx_snap_read(struct pci_dev *pdev)
drivers/ptp/ptp_pch.c:300:5: warning: no previous prototype for ‘pch_set_station_address’ [-Wmissing-prototypes]
 int pch_set_station_address(u8 *addr, struct pci_dev *pdev)

Signed-off-by: Herrington <hankinsea@gmail.com>
---
 drivers/ptp/ptp_pch.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index ce10ecd41ba0..8db2d1893577 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -179,7 +179,7 @@ static inline void pch_block_reset(struct pch_dev *chip)
 	iowrite32(val, (&chip->regs->control));
 }
 
-u32 pch_ch_control_read(struct pci_dev *pdev)
+static u32 pch_ch_control_read(struct pci_dev *pdev)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
 	u32 val;
@@ -190,7 +190,7 @@ u32 pch_ch_control_read(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(pch_ch_control_read);
 
-void pch_ch_control_write(struct pci_dev *pdev, u32 val)
+static void pch_ch_control_write(struct pci_dev *pdev, u32 val)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
 
@@ -198,7 +198,7 @@ void pch_ch_control_write(struct pci_dev *pdev, u32 val)
 }
 EXPORT_SYMBOL(pch_ch_control_write);
 
-u32 pch_ch_event_read(struct pci_dev *pdev)
+static u32 pch_ch_event_read(struct pci_dev *pdev)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
 	u32 val;
@@ -209,7 +209,7 @@ u32 pch_ch_event_read(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(pch_ch_event_read);
 
-void pch_ch_event_write(struct pci_dev *pdev, u32 val)
+static void pch_ch_event_write(struct pci_dev *pdev, u32 val)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
 
@@ -217,7 +217,7 @@ void pch_ch_event_write(struct pci_dev *pdev, u32 val)
 }
 EXPORT_SYMBOL(pch_ch_event_write);
 
-u32 pch_src_uuid_lo_read(struct pci_dev *pdev)
+static u32 pch_src_uuid_lo_read(struct pci_dev *pdev)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
 	u32 val;
@@ -228,7 +228,7 @@ u32 pch_src_uuid_lo_read(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(pch_src_uuid_lo_read);
 
-u32 pch_src_uuid_hi_read(struct pci_dev *pdev)
+static u32 pch_src_uuid_hi_read(struct pci_dev *pdev)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
 	u32 val;
@@ -239,7 +239,7 @@ u32 pch_src_uuid_hi_read(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(pch_src_uuid_hi_read);
 
-u64 pch_rx_snap_read(struct pci_dev *pdev)
+static u64 pch_rx_snap_read(struct pci_dev *pdev)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
 	u64 ns;
@@ -256,7 +256,7 @@ u64 pch_rx_snap_read(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(pch_rx_snap_read);
 
-u64 pch_tx_snap_read(struct pci_dev *pdev)
+static u64 pch_tx_snap_read(struct pci_dev *pdev)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
 	u64 ns;
@@ -297,7 +297,7 @@ static void pch_reset(struct pch_dev *chip)
  *				    traffic on the  ethernet interface
  * @addr:	dress which contain the column separated address to be used.
  */
-int pch_set_station_address(u8 *addr, struct pci_dev *pdev)
+static int pch_set_station_address(u8 *addr, struct pci_dev *pdev)
 {
 	s32 i;
 	struct pch_dev *chip = pci_get_drvdata(pdev);
-- 
2.18.1

