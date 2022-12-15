Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4955364DEB1
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 17:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiLOQcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 11:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbiLOQbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 11:31:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A327B879;
        Thu, 15 Dec 2022 08:31:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 160A061E61;
        Thu, 15 Dec 2022 16:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2E4C433EF;
        Thu, 15 Dec 2022 16:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671121900;
        bh=gAwB+Fty7Ew2vwNk/+gFvPZ/aMvqgMJxojNhd2obFPk=;
        h=From:To:Cc:Subject:Date:From;
        b=Ad6Tic/c9OuhNFSGaN0ipRjCWQ5gEmHBwzSrL5oizW40pHFZJ5Pw1qPk54qYonN8x
         SH42GkPJG0KrUHsxQBEiv7HDCMMhVa3h5Rtsm4bbXsbZX6xWIHS9LKY8hnP9/VkKVQ
         ZBvMuO9GFoHroiClO3AbfNzys7Z5tNBD+AuT5MrHRUvoFGr8YdYql4ezaN4cKOqWzn
         AKiKUq3oC66S9P9FoA/CuQezAg6lcRiUEhjYMsoT01KcnuPyf7W+s8q6ENPYShhfhu
         p5QXvIeF/EMH0NusScO0b3xG843jmY1Zu0fdxcjm8k8lIzPJowtxdZVLPTXSAjzrFI
         2zC9pClpXmtqQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: mt76: mt7996: select CONFIG_RELAY
Date:   Thu, 15 Dec 2022 17:31:10 +0100
Message-Id: <20221215163133.4152299-1-arnd@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Without CONFIG_RELAY, the driver fails to link:

ERROR: modpost: "relay_flush" [drivers/net/wireless/mediatek/mt76/mt7996/mt7996e.ko] undefined!
ERROR: modpost: "relay_switch_subbuf" [drivers/net/wireless/mediatek/mt76/mt7996/mt7996e.ko] undefined!
ERROR: modpost: "relay_open" [drivers/net/wireless/mediatek/mt76/mt7996/mt7996e.ko] undefined!
ERROR: modpost: "relay_reset" [drivers/net/wireless/mediatek/mt76/mt7996/mt7996e.ko] undefined!
ERROR: modpost: "relay_file_operations" [drivers/net/wireless/mediatek/mt76/mt7996/mt7996e.ko] undefined!

The same change was done in mt7915 for the corresponding copy of the code.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
See-also: 988845c9361a ("mt76: mt7915: add support for passing chip/firmware debug data to user space")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/mediatek/mt76/mt7996/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/Kconfig b/drivers/net/wireless/mediatek/mt76/mt7996/Kconfig
index 5c5fc569e6d5..79fb47a73c91 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/Kconfig
@@ -2,6 +2,7 @@
 config MT7996E
 	tristate "MediaTek MT7996 (PCIe) support"
 	select MT76_CONNAC_LIB
+	select RELAY
 	depends on MAC80211
 	depends on PCI
 	help
-- 
2.35.1

