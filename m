Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A07B60E1D2
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbiJZNQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233773AbiJZNQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:16:39 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD51F87085;
        Wed, 26 Oct 2022 06:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1666790198; x=1698326198;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AQ8LdJdDckBueGG5Er3mqgTunJL51UlKkWeBI9xQaPo=;
  b=HbIMkZp2KQJcQVlQ0Pn8Rb57+XdijlvGGZBVFdyJIqaUR2jA7CI7w5Zi
   PPoF44RIe1qYK5IVNT/jF3HfLXVNpPFjQF2x7cvTtjCuqiux25O0IpQDQ
   sHkBkoNxGsJhpTJUADbNTf4Mh5f5v/jOnHgIT4WVT/2BsQT8ahwyuOeSc
   7Q1xLCyg/1vnDuD6AvFfn8J+sk/7WOzP4i0wvhEGGaMlQcd/OrVmMerXG
   aTASRtuOQwUMSIzQnAK0AfWHBNBjO863jgxs8wObYFdKD7yPfqbHjByQJ
   M/J3aohSCQVaSRf46pJl/FSE5xqt5JFlifct/1D8KSlXm/2YMxnMsSuCv
   A==;
X-IronPort-AV: E=Sophos;i="5.95,214,1661810400"; 
   d="scan'208";a="26988477"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 26 Oct 2022 15:16:32 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Wed, 26 Oct 2022 15:16:32 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Wed, 26 Oct 2022 15:16:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1666790193; x=1698326193;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AQ8LdJdDckBueGG5Er3mqgTunJL51UlKkWeBI9xQaPo=;
  b=IZJ5D2z0IFL2KfFH0KlWWd6DscaAybMlc+Xfp/WLHFG06VCHJWaGD0f9
   N/E+eXFVu8JdwIVL+e10Zgc1DqIO4gyJG058StZpr+KPW+wy+R7/K7C3y
   3IxHQVJo9eDn6IoWveWT1XpGtqVtzmKBSL8S3a4iXYD/nC9fkCh7QZPDP
   gqsBFKtgfFC++Jdw4Ga0fBan0UxpDmtMKJKywfsbdQlF+LLLW0oQh8yrH
   ah4Ot4sq9viLDrpE+UkF1Xs8eX/ZXIPsf+1TCe9THdlZ/3Rd5HWYJdSlh
   WNYtKOPNgz7DNXOORhThSPVsJDM8Ys4s/IwQrnAF0TxHbxOPHgaRu8P4X
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,214,1661810400"; 
   d="scan'208";a="26988476"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 26 Oct 2022 15:16:32 +0200
Received: from localhost.localdomain (SCHIFFERM-M2.tq-net.de [10.121.49.14])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 78F70280072;
        Wed, 26 Oct 2022 15:16:31 +0200 (CEST)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux@ew.tq-group.com,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [RFC 5/5] bluetooth: hci_mrvl: allow waiting for firmware load using notify-device
Date:   Wed, 26 Oct 2022 15:15:34 +0200
Message-Id: <fa9cdbe5906fdcfcb37dbe682f3f46ce4b2e1b73.1666786471.git.matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1666786471.git.matthias.schiffer@ew.tq-group.com>
References: <cover.1666786471.git.matthias.schiffer@ew.tq-group.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
---
 drivers/bluetooth/hci_mrvl.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/bluetooth/hci_mrvl.c b/drivers/bluetooth/hci_mrvl.c
index b7d764e6010f..dc55053574a9 100644
--- a/drivers/bluetooth/hci_mrvl.c
+++ b/drivers/bluetooth/hci_mrvl.c
@@ -12,6 +12,7 @@
 #include <linux/skbuff.h>
 #include <linux/firmware.h>
 #include <linux/module.h>
+#include <linux/notify-device.h>
 #include <linux/tty.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -433,9 +434,25 @@ static int mrvl_serdev_probe(struct serdev_device *serdev)
 		return -ENOMEM;
 
 	if (IS_ENABLED(CONFIG_OF)) {
+		struct device_node *firmware_ready_node;
+		struct device *firmware_ready;
+
 		mrvldev->info = of_device_get_match_data(&serdev->dev);
 		if (!mrvldev->info)
 			return -ENODEV;
+
+		firmware_ready_node = of_parse_phandle(serdev->dev.of_node,
+						       "firmware-ready", 0);
+		if (firmware_ready_node) {
+			firmware_ready =
+				notify_device_find_by_of_node(firmware_ready_node);
+			if (!firmware_ready)
+				return -EPROBE_DEFER;
+			if (IS_ERR(firmware_ready))
+				return PTR_ERR(firmware_ready);
+			put_device(firmware_ready);
+		}
+
 	}
 
 	mrvldev->hu.serdev = serdev;
-- 
2.25.1

