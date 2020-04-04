Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32C4319E7A3
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 22:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgDDUtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 16:49:06 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:49633 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726278AbgDDUtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 16:49:03 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 829445801D4;
        Sat,  4 Apr 2020 16:49:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 04 Apr 2020 16:49:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alistair23.me;
         h=from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=5Z62tta6RewP7
        vFb8pMLmQzZ9HleyuU0GSnH4JaxFcU=; b=fS+sH+WOcuw6FGpl8XeL577h7L68f
        /+IBFRU4sFKsYNTs4deO7XXeeATznXTGegkYzdJQsjmG5V0WYWaw16tD1QU+vK1R
        OOWugORUW9zVW5g53TLn3NQSJdvB9oNnba+WZW5Xi6e3pbXFLIgwO4aiWJ/mzspT
        4MFrMxAedXQAC+kUe1zUnlMTPAk4HiISukvgjTrqIcNWnA41pf6Pv/te0HNx288K
        xzUp9QQ8akvlOIo4TuUe/feiCdxXU+P0g2kg7PwTONtTibwWKWH1F6XmFgO1KYnG
        bwGnEKld4CSfwZSU6nkJnltrz4IMLu1mYDl48ib2cg6SNw4FkSSwaTDrQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=5Z62tta6RewP7vFb8pMLmQzZ9HleyuU0GSnH4JaxFcU=; b=bQIJLvkH
        7WOxpSAWkP92QSRgiOeBcezWjF3AqajGOhLCogI14RZcuKtVfEznpHe4Bt5iuqeh
        dtV1Ea7lgG6IAF30th4jGNGmn4iy3AK6GEFiSjOiPu2IL128zmCZCHhJziKO7Y8r
        Gi+RzBFpC12VD55w4zeXH0gNTOx/VjukANGCllhoPN24bCgHVak01Soc8TTbogSM
        FkiKs5eysC0R6Qdvf+bLpBj/G4wCYZ6RnQX2wS3AElcCcBdTI54ImXYj8/ec7jxx
        vbqvWtp/I9vJki590A1ahf9JHoESHXbaXC/xBSrCjuXBHt0qWs/zhsqS6Jsxt8ap
        QK9P/YT+6sKCnQ==
X-ME-Sender: <xms:vvKIXt3ICXJZ3Ww8bcE_-2xOaAHO6hKS86lVT35n82ibJQxvQusIMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdekgdduheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomheptehlihhsthgrihhrucfhrhgrnhgtihhsuceorghlihhsthgr
    ihhrsegrlhhishhtrghirhdvfedrmhgvqeenucfkphepjeefrdelfedrkeegrddvtdekne
    cuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghlihhs
    thgrihhrsegrlhhishhtrghirhdvfedrmhgv
X-ME-Proxy: <xmx:vvKIXvzj_zaWI2K2VeIoTvIeWebruHjSg5Kke8AUTHcYL-Yod8n-sQ>
    <xmx:vvKIXonTYKKh9Rv0tZ4JBlJtmFTL7T4notcJ46ptAu0rwppiF4rqcQ>
    <xmx:vvKIXrxuvb9OVjW73-Sr4XkNjYekZhgIep4o1ol3GDAFB7l7HQIQZw>
    <xmx:vvKIXlxK7UEtQVUHsHrmQpNVyAGyZyooSrAQB1yXsAWcfpvoWfFmXA>
Received: from alistair-xps-14z.alistair23.me (c-73-93-84-208.hsd1.ca.comcast.net [73.93.84.208])
        by mail.messagingengine.com (Postfix) with ESMTPA id 30521328005E;
        Sat,  4 Apr 2020 16:49:01 -0400 (EDT)
From:   Alistair Francis <alistair@alistair23.me>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, mripard@kernel.org, wens@csie.org
Cc:     anarsoul@gmail.com, devicetree@vger.kernel.org,
        alistair23@gmail.com, linux-arm-kernel@lists.infradead.org,
        Alistair Francis <alistair@alistair23.me>
Subject: [PATCH 2/3] Bluetooth: hci_h5: Add support for binding RTL8723BS with device tree
Date:   Sat,  4 Apr 2020 13:48:49 -0700
Message-Id: <20200404204850.405050-2-alistair@alistair23.me>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200404204850.405050-1-alistair@alistair23.me>
References: <20200404204850.405050-1-alistair@alistair23.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Khoruzhick <anarsoul@gmail.com>

RTL8723BS is often used in ARM boards, so add ability to bind it
using device tree.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Signed-off-by: Alistair Francis <alistair@alistair23.me>
---
 drivers/bluetooth/hci_h5.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index 106c110efe56..6ea6cd73dff4 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -820,6 +820,8 @@ static int h5_serdev_probe(struct serdev_device *serdev)
 			return -ENODEV;
 
 		h5->vnd = (const struct h5_vnd *)data;
+		of_property_read_string(dev.of_node,
+					"firmware-postfix", &h5->id);
 	}
 
 
@@ -1019,6 +1021,8 @@ static const struct of_device_id rtl_bluetooth_of_match[] = {
 	{ .compatible = "realtek,rtl8822cs-bt",
 	  .data = (const void *)&rtl_vnd },
 #endif
+	{ .compatible = "realtek,rtl8822bs-bt",
+	  .data = (const void *)&rtl_vnd },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, rtl_bluetooth_of_match);
-- 
2.25.1

