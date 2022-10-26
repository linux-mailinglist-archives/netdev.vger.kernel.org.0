Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6684560E1D3
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiJZNQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233553AbiJZNQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:16:39 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653F2FBCE3;
        Wed, 26 Oct 2022 06:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1666790198; x=1698326198;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SRwTQYbpVvOnRI/9yYdfDenFSOi+/pq0o+qF8j6kob0=;
  b=HoxWjvyny8MdVcXXdvjr6w+tSwgUssAuGosWdy88MS1PDD+YtxuKcvlU
   FgTZiKAm9liDl/KebIuPbzm780OA0QnLrJj+MQ8CPZaJvw/nPQzzHdyDo
   2FgqxaGZuIYhwQ7vYpiYWsO4C2evMkzTWInflFKt9Q7vYc42XvMXvMvTM
   cAM0oVahNhmHs7VzZMSTKbb4riclWlfEdlwiQ0bsIxx2DZMQYaPNN+w+7
   01zosYcTQ20DZFvGUXCBb2DnQydjlIegBwkZozDOA/mgtjcsqnlgpYHI3
   XS8jO3IbV4U9KEkgHFKVqSzv03nMkunTZ4HztT9PuZbN7q9wEyYy1eUqt
   g==;
X-IronPort-AV: E=Sophos;i="5.95,214,1661810400"; 
   d="scan'208";a="26988475"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 26 Oct 2022 15:16:32 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Wed, 26 Oct 2022 15:16:32 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Wed, 26 Oct 2022 15:16:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1666790192; x=1698326192;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SRwTQYbpVvOnRI/9yYdfDenFSOi+/pq0o+qF8j6kob0=;
  b=j1X5H7FAr2SH0mJ26PJql0RcBcn9Vccbb0IRzTX7JzwzWWr6nBCWk/1G
   slozYqPRIzy0G+OHhTVMVhtDSE7zBtSHUpvTiRbEGXiqRVQ7q/SzG/r89
   7JQaAoqIdKppaqxcFppFgobICZWSSA+yeYzsWZrqy95o3bJ2cenJ+BzoW
   tVoEkVWViuYcq5CHeZgmM7TV6/g/rT3owz/RliOWDSjY2PdlR4dazbsMh
   FgcQ2Nkb9eNrKEQrbZR1Zco025Sumxkzj//8UdazOofEURhSyH3r9b/Rx
   LzFQyTtef+4Q1U9F3vRejFr2ZFA980asb9mWoXnGfBmPx+dW+D3Q2L7NN
   A==;
X-IronPort-AV: E=Sophos;i="5.95,214,1661810400"; 
   d="scan'208";a="26988474"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 26 Oct 2022 15:16:32 +0200
Received: from localhost.localdomain (SCHIFFERM-M2.tq-net.de [10.121.49.14])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 1F789280056;
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
Subject: [RFC 4/5] bluetooth: hci_mrvl: add support for SD8987
Date:   Wed, 26 Oct 2022 15:15:33 +0200
Message-Id: <aec48a97736bf95c1caaaed0a6f23c07568639ce.1666786471.git.matthias.schiffer@ew.tq-group.com>
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

Do not load any firmwares, and instead expect the firmware to be
initialized by the WLAN driver.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
---
 drivers/bluetooth/hci_mrvl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/hci_mrvl.c b/drivers/bluetooth/hci_mrvl.c
index 5d191687a34a..b7d764e6010f 100644
--- a/drivers/bluetooth/hci_mrvl.c
+++ b/drivers/bluetooth/hci_mrvl.c
@@ -44,6 +44,8 @@ static const struct mrvl_driver_info mrvl_driver_info_8897 = {
 	.firmware = "mrvl/uart8897_bt.bin",
 };
 
+static const struct mrvl_driver_info mrvl_driver_info_8987 = {};
+
 /* Fallback for non-OF instances */
 static const struct mrvl_driver_info *const mrvl_driver_info_default =
 	&mrvl_driver_info_8897;
@@ -452,6 +454,7 @@ static void mrvl_serdev_remove(struct serdev_device *serdev)
 #ifdef CONFIG_OF
 static const struct of_device_id mrvl_bluetooth_of_match[] = {
 	{ .compatible = "mrvl,88w8897", .data = &mrvl_driver_info_8897 },
+	{ .compatible = "marvell,sd8987-bt", .data = &mrvl_driver_info_8987 },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, mrvl_bluetooth_of_match);
-- 
2.25.1

