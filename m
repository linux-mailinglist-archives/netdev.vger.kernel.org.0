Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790F9214F07
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 21:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgGETvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 15:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728006AbgGETvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 15:51:31 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E865C061794;
        Sun,  5 Jul 2020 12:51:31 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id q17so16080733pfu.8;
        Sun, 05 Jul 2020 12:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7RJ6rE3+V5FkJZxVb3v+pVHBk2ZYQcboCzbdh+i0x+E=;
        b=rDPbtc8vdEMGwEPSHOV5kjTzILxUmRSxurBdo2x2VNrnCmNg2CA4bK0En8Ox5voIVu
         jflBYMA4ESDAWl5Z5xfAI1Z0QOsgQFDF+9EILJPiVkk7sbSYqF+PGpppNvj28yCpvV1e
         J3uX+qBHX8q98F9wSaUQxa1WzQBoq7FP2jsovR3BMmfkY+GRu6HXMA0LRHtTJuZ1/KPr
         ROQRuXbp4XcX2Cuj7m5cpn9QaxXC/kdiSpQdHsNsHVDwtHf009y0ToxFBFQ+AGfulJJ/
         QWwblLBZYGdcv/RLUYKFXpvuuTg0YzYH0IAVca3Wb435JlEfrsATbmwoSu+6K0pgbVVU
         jATg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7RJ6rE3+V5FkJZxVb3v+pVHBk2ZYQcboCzbdh+i0x+E=;
        b=Vm4WrgtoYuITeKaybUxVTkYxyZ16McvAsD5pCaa6TI5N2OOa1MA2C2qNKjEYmS4non
         2poRfp01eGf8TkxoEDFcJghEodLqnCYhek1t1gw3uT+Wos+2Mdo2elWG5LVjs3gjr5mf
         XpVzSZgASBSHtUX50HCtD2mFhCoqgQeXXYl7djM+d4dUeKuINSgBycQQqW1iMsZPHOML
         4WCoB4la8nxpt6rmpf4Cok4GBlF6Ntyz87uFsS45506/74NzjZFZesMfjj2cYS3MfLB6
         xfZkRM9P9EBXvXaehXBJQnIMERMcNKyY4s13HP1vwHdOtm8c9IBeIAkS0suimO3uHmJi
         Odnw==
X-Gm-Message-State: AOAM532rpKkucXYOWH3VmXFQT9Qw1jCluizsZ/jVaqsY6edevOvpMZtn
        xeyawXE2R4h9YMMHe2hRueY=
X-Google-Smtp-Source: ABdhPJyx/0NFcW6FSUxmSN3DKYwTjkoKbr6mmBjMln0ATSOvaHAugjHxaxi03vs9u8Jiv8C8NEH4gQ==
X-Received: by 2002:a63:4b04:: with SMTP id y4mr37299434pga.158.1593978690666;
        Sun, 05 Jul 2020 12:51:30 -0700 (PDT)
Received: from anarsoul-thinkpad.lan (216-71-213-236.dyn.novuscom.net. [216.71.213.236])
        by smtp.gmail.com with ESMTPSA id g9sm16072879pfm.151.2020.07.05.12.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 12:51:30 -0700 (PDT)
From:   Vasily Khoruzhick <anarsoul@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Ondrej Jirman <megous@megous.com>
Cc:     Vasily Khoruzhick <anarsoul@gmail.com>
Subject: [PATCH 1/3] Bluetooth: Add new quirk for broken local ext features max_page
Date:   Sun,  5 Jul 2020 12:51:08 -0700
Message-Id: <20200705195110.405139-2-anarsoul@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200705195110.405139-1-anarsoul@gmail.com>
References: <20200705195110.405139-1-anarsoul@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some adapters (e.g. RTL8723CS) advertise that they have more than
2 pages for local ext features, but they don't support any features
declared in these pages. RTL8723CS reports max_page = 2 and declares
support for sync train and secure connection, but it responds with
either garbage or with error in status on corresponding commands.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
---
 include/net/bluetooth/hci.h | 7 +++++++
 net/bluetooth/hci_event.c   | 4 +++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 16ab6ce87883..8e4c16210d18 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -227,6 +227,13 @@ enum {
 	 * supported.
 	 */
 	HCI_QUIRK_VALID_LE_STATES,
+
+	/* When this quirk is set, max_page for local extended features
+	 * is set to 1, even if controller reports higher number. Some
+	 * controllers (e.g. RTL8723CS) report more pages, but they
+	 * don't actually support features declared there.
+	 */
+	HCI_QUIRK_BROKEN_LOCAL_EXT_FTR_MAX_PAGE,
 };
 
 /* HCI device flags */
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index cfeaee347db3..df3232828978 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -700,7 +700,9 @@ static void hci_cc_read_local_ext_features(struct hci_dev *hdev,
 	if (rp->status)
 		return;
 
-	if (hdev->max_page < rp->max_page)
+	if (!test_bit(HCI_QUIRK_BROKEN_LOCAL_EXT_FTR_MAX_PAGE,
+		      &hdev->quirks) &&
+	    hdev->max_page < rp->max_page)
 		hdev->max_page = rp->max_page;
 
 	if (rp->page < HCI_MAX_PAGES)
-- 
2.27.0

