Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D6026F5B3
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 08:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgIRGGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 02:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgIRGGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 02:06:35 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCED2C06174A;
        Thu, 17 Sep 2020 23:06:35 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id f2so2849619pgd.3;
        Thu, 17 Sep 2020 23:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9IFI2q/VcKdQGp4crDlbzIC5tqBlL4St+qrZycUxeYs=;
        b=CYrbE2c6FkdAXnOE4bvLfoUfh7aUoL/IeIy7ivLodJCoXnx7fZsFzc30SD8g9H5vce
         FdisasNvFxhmJjcH3yzzf6QEbsBbJau8Tj8VCTr7vPScRJ7S7sVv4NlFjVBIOpgnvBoA
         CIQnu2OMZ2/gEc/F+cI4iUZMp/Q6Wgi7hytrDXvpnSsTP15FUPlntJnG0JCbSOvJZ+yh
         GjCEH9nc4v2hIWC/oVlNGTLwx4+vKK2YAtXs5hCUkpkQSr1ouc+F2avwCJ/hA5G282Md
         3bZj/zIz6/j/CZPAaTHOh1doGRUFq4ejziJ6PqknaXK1i6LJnaQDtby/+nyleoGNeXFo
         oCfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9IFI2q/VcKdQGp4crDlbzIC5tqBlL4St+qrZycUxeYs=;
        b=jelyYJHAMTWYO7jOFchWODbmVx6wYfd4lsc7/w9IreXKeagqJj8r3EoakemZ0Lec0k
         yaOodEiEzqaswp5zNEjOvu+ap0uFsDnJuLER7/0aBh9BZ4GjN1Z280m2NArb5JGQozRI
         E4jL0DtA/DM+OVEBrO4Vu/z/m+4Q5Jqkyh92mc5Z8CrUn//zWHzHo4E8Zp1RoW3FNigU
         M3Wu0e8MdKPGBxCOZMn+iRkosRLI0W/x9K0aZp0MQij5VCVUjxht4qX0yA1hNE0IL07o
         2RZbZOS1XzwVJrd/Q2w9MHsv8xpv8UW+JGDwqHUHrDMKbQWPC6qNN+fCoHS1YrUJGQRQ
         Kmew==
X-Gm-Message-State: AOAM532i2uI6t1dYBdX0cMwZV1/iN7xKwg4ffyUyzLPTTIcrLtvkzjLM
        2mn6b8NL797LeouSLm0eLNI=
X-Google-Smtp-Source: ABdhPJz+tLJIDGwGDR6rzW1gHPMSK6DUMjSndI15swpaNkFj6SdwuJPnxt4PcmGsitmAuSog6diRgw==
X-Received: by 2002:aa7:941a:0:b029:142:2501:35d1 with SMTP id x26-20020aa7941a0000b0290142250135d1mr14257831pfo.49.1600409195331;
        Thu, 17 Sep 2020 23:06:35 -0700 (PDT)
Received: from localhost.localdomain ([47.242.129.156])
        by smtp.gmail.com with ESMTPSA id l79sm1737273pfd.210.2020.09.17.23.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 23:06:34 -0700 (PDT)
From:   Herrington <hankinsea@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hankinsea@gmail.com
Subject: [PATCH] [PATCH v2]ptp: mark symbols static where possible
Date:   Fri, 18 Sep 2020 14:05:50 +0800
Message-Id: <20200918060550.1904-1-hankinsea@gmail.com>
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

