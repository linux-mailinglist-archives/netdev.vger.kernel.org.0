Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A0126F5C5
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 08:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgIRGKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 02:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIRGKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 02:10:21 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A709CC06174A;
        Thu, 17 Sep 2020 23:10:21 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id c3so2440501plz.5;
        Thu, 17 Sep 2020 23:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9IFI2q/VcKdQGp4crDlbzIC5tqBlL4St+qrZycUxeYs=;
        b=aIR5llw70fCUiD7uHZ781qkd9KP4WZTZtpREs+ujQ/LDLcxh7o0INagEns1n0QvcfG
         DhZqeB0Bh9W8GS4Uqm2zRAycWY912xl3/PIalkIWTWTbfdIYnD5Q6xJ4rMKb7DYH0FIK
         KtERAMizBePMZt/DVOV9vfEvePqjwM98QFMUC+m50T9wWLyf4lyezRzg4gHgW6BDmt4r
         UllIr/kZpVmyfTXf/My4Iwhs3fvMMGLql2+rh5k7ou6zKL7aJSojITHaeAwXMLhr+9kC
         HhOnqwK58Q/rKm3aVRHLPYv39kMqe6WrtWjZeTfBSjfDFBYRE4Yg+4G3/6SLsWz3L0x9
         5Tgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9IFI2q/VcKdQGp4crDlbzIC5tqBlL4St+qrZycUxeYs=;
        b=EF0qtFbrEVXuWO4rQaRSw0lduP9DJQ29lj32KViVX2sIb7hPPHlZk+p/q9vTpLORxo
         pAPvlqK4bEPNsusShADc1+JtRsdefpYxV2jY1vrm5MngvnHPFE6HZVZWjk4ReaZ3sT3b
         UkU8FBgGkKSD9SZGNEgFjqs+FQZcIGRxulZU8fSRWSDetJFUb7E2BfdTC7C7KFW2ZAPx
         QZkVTwCzjp8BFzYyY2CesFH+pGTpo/YUm96n1W4LwGVabjPikQNJdbeCWGktdElD1hpH
         8KaujnrvtkW87+/ZCkHhl9FoJXABOolYWVyGXAy+KcxEGzs8r1lpImas+nVnz1rlbAiV
         GMAw==
X-Gm-Message-State: AOAM5329rfF3CsTL3yLNFp6+KQHE/QfK8LvOJPEe4zE5pE9/aQtPtDHi
        QTPrazTRiap+qDvMXHnognei+ZPHw1JGfA==
X-Google-Smtp-Source: ABdhPJzyNwGruKAMrcYMv/tCoFWdxXkf2MOmruTB0KeYDlQ9fA0QGv+6zSKmWsXyRvyPKdroNbJzoA==
X-Received: by 2002:a17:90a:744f:: with SMTP id o15mr12332948pjk.216.1600409421308;
        Thu, 17 Sep 2020 23:10:21 -0700 (PDT)
Received: from localhost.localdomain ([47.242.129.156])
        by smtp.gmail.com with ESMTPSA id a15sm1778966pfi.119.2020.09.17.23.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 23:10:20 -0700 (PDT)
From:   Herrington <hankinsea@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hankinsea@gmail.com
Subject: [PATCH v2] ptp: mark symbols static where possible
Date:   Fri, 18 Sep 2020 14:10:13 +0800
Message-Id: <20200918061013.2034-1-hankinsea@gmail.com>
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
 drivers/ptp/ptp_pch.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index ce10ecd41ba0..70eee68e8dfc 100644
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
@@ -190,6 +190,7 @@ u32 pch_ch_control_read(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(pch_ch_control_read);
 
+void pch_ch_control_write(struct pci_dev *pdev, u32 val);
 void pch_ch_control_write(struct pci_dev *pdev, u32 val)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
@@ -198,6 +199,7 @@ void pch_ch_control_write(struct pci_dev *pdev, u32 val)
 }
 EXPORT_SYMBOL(pch_ch_control_write);
 
+u32 pch_ch_event_read(struct pci_dev *pdev);
 u32 pch_ch_event_read(struct pci_dev *pdev)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
@@ -209,6 +211,7 @@ u32 pch_ch_event_read(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(pch_ch_event_read);
 
+void pch_ch_event_write(struct pci_dev *pdev, u32 val);
 void pch_ch_event_write(struct pci_dev *pdev, u32 val)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
@@ -217,6 +220,7 @@ void pch_ch_event_write(struct pci_dev *pdev, u32 val)
 }
 EXPORT_SYMBOL(pch_ch_event_write);
 
+u32 pch_src_uuid_lo_read(struct pci_dev *pdev);
 u32 pch_src_uuid_lo_read(struct pci_dev *pdev)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
@@ -228,6 +232,7 @@ u32 pch_src_uuid_lo_read(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(pch_src_uuid_lo_read);
 
+u32 pch_src_uuid_hi_read(struct pci_dev *pdev);
 u32 pch_src_uuid_hi_read(struct pci_dev *pdev)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
@@ -239,6 +244,7 @@ u32 pch_src_uuid_hi_read(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(pch_src_uuid_hi_read);
 
+u64 pch_rx_snap_read(struct pci_dev *pdev);
 u64 pch_rx_snap_read(struct pci_dev *pdev)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
@@ -256,6 +262,7 @@ u64 pch_rx_snap_read(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(pch_rx_snap_read);
 
+u64 pch_tx_snap_read(struct pci_dev *pdev);
 u64 pch_tx_snap_read(struct pci_dev *pdev)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
@@ -297,6 +304,7 @@ static void pch_reset(struct pch_dev *chip)
  *				    traffic on the  ethernet interface
  * @addr:	dress which contain the column separated address to be used.
  */
+int pch_set_station_address(u8 *addr, struct pci_dev *pdev);
 int pch_set_station_address(u8 *addr, struct pci_dev *pdev)
 {
 	s32 i;
-- 
2.18.1

