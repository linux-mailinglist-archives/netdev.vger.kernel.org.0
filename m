Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A24B3D4A38
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 23:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhGXVHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 17:07:44 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:43790
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229756AbhGXVHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 17:07:42 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id F0F003F34A
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 21:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627163291;
        bh=Cafb+vZCXBE2r3BRcaIZ4Rw/4xen96i9AebcqjRz32w=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=ETov9SBDlfzMSbiFrBOkupRwtJuQl263c69IASFeJ0RlqiOcblqkBgL6KMXEcQrIF
         xFF2FurwjxSmqwV2UlowiyMt5vWQ+pEhBTAJaKVqzszYl8WKWo7dl/8DTk87YeVYex
         TwjjkO5iLiIRy5O86hBxFXN23zZe0kI9jle7/CCwGakkF0G3vB2vm7d6NBEVcnN+Rk
         li84F5RcBZi2W71p4hFhJ9pZZgMEBtZWKTet8SOtq0eMWej8wquIpA3uXCT5GNWqxW
         8TXFxdy4VhBIqH8dVS/yaFRW1NiLK07/r6yQ8T4kiqYRd0AhSF9e5NmOpEfGjEuUIV
         nmCRrUDuijlWg==
Received: by mail-ed1-f69.google.com with SMTP id c20-20020a0564021014b029039994f9cab9so2756869edu.22
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 14:48:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cafb+vZCXBE2r3BRcaIZ4Rw/4xen96i9AebcqjRz32w=;
        b=ruu1RZrAhzYi7GKoTkGGiQMIMX4W0wA0IxW0YAe3OTcVivZaOpZKdng6BHnJPLULvc
         yjxsbFHt91LJe5M4eJcx0nVu/C63u/0uXUSeCy9htEHWeSe8Zc8qCg+WtCGC55qldGEN
         zMi9ePyUolcY73hT733H3rXAp2AOsTgPkrff+ByDR/xLwaNxJXN21rx5HIR3AIy2M0WC
         RHt67CJa49aYPa1HYJagxPt5gOzkgc2yMCteuX2S2th90Y0cbtG7jAdRPSvzhw4z3IuQ
         kMCBPed0WriEXd45ZT9l6+mK18uNHxKC2c2RWX23BcFBDiAN1AdbMzLaPz3bciAhtS8D
         cHcQ==
X-Gm-Message-State: AOAM53276AWS826CLvf1NTKHwJ0ehdFG8xom1tdn4kgPq+xL08E8aQ3C
        lweqSFPchq4tKzFuyjJXySu8xT38tOsoZuXpsK/KUOqBhz0MD62chm9oohN61OSE7VYA6yf5Ky4
        bweFvc29C1v7AD61oX4cpTMPF+szJS2SJtg==
X-Received: by 2002:a05:6402:1a3c:: with SMTP id be28mr13064451edb.15.1627163289663;
        Sat, 24 Jul 2021 14:48:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFUM58aGKaHxO58kMsTBI7SVyFqHtKLuVZn+D1yBUPCbhbairNSRS8WTZxryZ7vHJNqJ3THg==
X-Received: by 2002:a05:6402:1a3c:: with SMTP id be28mr13064438edb.15.1627163289515;
        Sat, 24 Jul 2021 14:48:09 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id j5sm8383005edv.10.2021.07.24.14.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jul 2021 14:48:09 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 02/12] nfc: constify nci_ops
Date:   Sat, 24 Jul 2021 23:47:33 +0200
Message-Id: <20210724214743.121884-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210724214743.121884-1-krzysztof.kozlowski@canonical.com>
References: <20210724214743.121884-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The struct nci_ops is modified by NFC core in only one case:
nci_allocate_device() receives too many proprietary commands (prop_ops)
to configure.  This is a build time known constrain, so a graceful
handling of such case is not necessary.

Instead, fail the nci_allocate_device() and add BUILD_BUG_ON() to places
which set these.

This allows to constify the struct nci_ops (consisting of function
pointers) for correctness and safety.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/fdp/fdp.c        | 3 ++-
 drivers/nfc/nfcmrvl/main.c   | 2 +-
 drivers/nfc/nxp-nci/core.c   | 2 +-
 drivers/nfc/st-nci/core.c    | 3 ++-
 drivers/nfc/virtual_ncidev.c | 2 +-
 include/net/nfc/nci_core.h   | 4 ++--
 net/nfc/nci/core.c           | 5 ++---
 7 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index 528745862738..73f51848a693 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -675,7 +675,7 @@ static struct nci_driver_ops fdp_prop_ops[] = {
 	},
 };
 
-static struct nci_ops nci_ops = {
+static const struct nci_ops nci_ops = {
 	.open = fdp_nci_open,
 	.close = fdp_nci_close,
 	.send = fdp_nci_send,
@@ -718,6 +718,7 @@ int fdp_nci_probe(struct fdp_i2c_phy *phy, struct nfc_phy_ops *phy_ops,
 		    NFC_PROTO_NFC_DEP_MASK |
 		    NFC_PROTO_ISO15693_MASK;
 
+	BUILD_BUG_ON(ARRAY_SIZE(fdp_prop_ops) > NCI_MAX_PROPRIETARY_CMD);
 	ndev = nci_allocate_device(&nci_ops, protocols, tx_headroom,
 				   tx_tailroom);
 	if (!ndev) {
diff --git a/drivers/nfc/nfcmrvl/main.c b/drivers/nfc/nfcmrvl/main.c
index a4620b480c4f..6e9e7ce8792c 100644
--- a/drivers/nfc/nfcmrvl/main.c
+++ b/drivers/nfc/nfcmrvl/main.c
@@ -81,7 +81,7 @@ static int nfcmrvl_nci_fw_download(struct nci_dev *ndev,
 	return nfcmrvl_fw_dnld_start(ndev, firmware_name);
 }
 
-static struct nci_ops nfcmrvl_nci_ops = {
+static const struct nci_ops nfcmrvl_nci_ops = {
 	.open = nfcmrvl_nci_open,
 	.close = nfcmrvl_nci_close,
 	.send = nfcmrvl_nci_send,
diff --git a/drivers/nfc/nxp-nci/core.c b/drivers/nfc/nxp-nci/core.c
index 2b0c7232e91f..518e2afb43a8 100644
--- a/drivers/nfc/nxp-nci/core.c
+++ b/drivers/nfc/nxp-nci/core.c
@@ -83,7 +83,7 @@ static int nxp_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 	return r;
 }
 
-static struct nci_ops nxp_nci_ops = {
+static const struct nci_ops nxp_nci_ops = {
 	.open = nxp_nci_open,
 	.close = nxp_nci_close,
 	.send = nxp_nci_send,
diff --git a/drivers/nfc/st-nci/core.c b/drivers/nfc/st-nci/core.c
index 110ff1281e5f..f6fce34a77da 100644
--- a/drivers/nfc/st-nci/core.c
+++ b/drivers/nfc/st-nci/core.c
@@ -94,7 +94,7 @@ static struct nci_driver_ops st_nci_prop_ops[] = {
 	},
 };
 
-static struct nci_ops st_nci_ops = {
+static const struct nci_ops st_nci_ops = {
 	.init = st_nci_init,
 	.open = st_nci_open,
 	.close = st_nci_close,
@@ -131,6 +131,7 @@ int st_nci_probe(struct llt_ndlc *ndlc, int phy_headroom,
 		| NFC_PROTO_ISO15693_MASK
 		| NFC_PROTO_NFC_DEP_MASK;
 
+	BUILD_BUG_ON(ARRAY_SIZE(st_nci_prop_ops) > NCI_MAX_PROPRIETARY_CMD);
 	ndlc->ndev = nci_allocate_device(&st_nci_ops, protocols,
 					phy_headroom, phy_tailroom);
 	if (!ndlc->ndev) {
diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
index f73ee0bf3593..b914ab2c2109 100644
--- a/drivers/nfc/virtual_ncidev.c
+++ b/drivers/nfc/virtual_ncidev.c
@@ -65,7 +65,7 @@ static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 	return 0;
 }
 
-static struct nci_ops virtual_nci_ops = {
+static const struct nci_ops virtual_nci_ops = {
 	.open = virtual_nci_open,
 	.close = virtual_nci_close,
 	.send = virtual_nci_send
diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index bf573eca07ca..5dae7e2cbc49 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -194,7 +194,7 @@ struct nci_hci_dev {
 /* NCI Core structures */
 struct nci_dev {
 	struct nfc_dev		*nfc_dev;
-	struct nci_ops		*ops;
+	const struct nci_ops	*ops;
 	struct nci_hci_dev	*hci_dev;
 
 	int			tx_headroom;
@@ -267,7 +267,7 @@ struct nci_dev {
 };
 
 /* ----- NCI Devices ----- */
-struct nci_dev *nci_allocate_device(struct nci_ops *ops,
+struct nci_dev *nci_allocate_device(const struct nci_ops *ops,
 				    __u32 supported_protocols,
 				    int tx_headroom,
 				    int tx_tailroom);
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 09967b836361..a7d26f2791b0 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1129,7 +1129,7 @@ static struct nfc_ops nci_nfc_ops = {
  * @tx_headroom: Reserved space at beginning of skb
  * @tx_tailroom: Reserved space at end of skb
  */
-struct nci_dev *nci_allocate_device(struct nci_ops *ops,
+struct nci_dev *nci_allocate_device(const struct nci_ops *ops,
 				    __u32 supported_protocols,
 				    int tx_headroom, int tx_tailroom)
 {
@@ -1152,8 +1152,7 @@ struct nci_dev *nci_allocate_device(struct nci_ops *ops,
 	if (ops->n_prop_ops > NCI_MAX_PROPRIETARY_CMD) {
 		pr_err("Too many proprietary commands: %zd\n",
 		       ops->n_prop_ops);
-		ops->prop_ops = NULL;
-		ops->n_prop_ops = 0;
+		goto free_nci;
 	}
 
 	ndev->tx_headroom = tx_headroom;
-- 
2.27.0

