Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02CD62805F9
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 19:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732931AbgJARzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 13:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732795AbgJARzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 13:55:00 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E08C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 10:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=yNARjDj0xPB2pp11Fk8TInddBZm0e3UiMztz1uK27x8=; b=p5TVIQi5SYGZ6FyiM4JfgqqLIz
        ebhgo9b2EC+vNTgKq8e5N4Whi+hfZQ1ipr8ybi9oq/3Tns6OMpJheHXgtvZd8L0yeyH2Tc1kPgeZR
        sfC51kNygsCq4OK1zNk9nXK7s2Vz7F7uXX3UKTw40asO2iQB0+zr1k/itQ+2HmUo8nbJBQJiSAoBB
        f3bikcbCRnrrJ1nkw729Jyya7fPbDEEBtYXYsE6PsHxDGJuX96pHlgDchIPXusMfnAHbPjbiCIltC
        C5OxK0o1Ls6cwia2hkc1INBq+FR4MTsgiOBsZqc6R4vMZ9ZRGsqY3EAWh7qP4LKcnkSt3tANKkYhz
        F6svPzXA==;
Received: from [2601:1c0:6280:3f0::863] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kO2n9-0007Tt-EU; Thu, 01 Oct 2020 17:54:55 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>, Bin Luo <luobin9@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Aviad Krawczyk <aviad.krawczyk@huawei.com>,
        Zhao Chen <zhaochen6@huawei.com>
Subject: [PATCH net] net: hinic: fix DEVLINK build errors
Date:   Thu,  1 Oct 2020 10:54:49 -0700
Message-Id: <20201001175449.3808-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix many (lots deleted here) build errors in hinic by selecting NET_DEVLINK.

ld: drivers/net/ethernet/huawei/hinic/hinic_hw_dev.o: in function `mgmt_watchdog_timeout_event_handler':
hinic_hw_dev.c:(.text+0x30a): undefined reference to `devlink_health_report'
ld: drivers/net/ethernet/huawei/hinic/hinic_devlink.o: in function `hinic_fw_reporter_dump':
hinic_devlink.c:(.text+0x1c): undefined reference to `devlink_fmsg_u32_pair_put'
ld: drivers/net/ethernet/huawei/hinic/hinic_devlink.o: in function `hinic_fw_reporter_dump':
hinic_devlink.c:(.text+0x126): undefined reference to `devlink_fmsg_binary_pair_put'
ld: drivers/net/ethernet/huawei/hinic/hinic_devlink.o: in function `hinic_hw_reporter_dump':
hinic_devlink.c:(.text+0x1ba): undefined reference to `devlink_fmsg_string_pair_put'
ld: hinic_devlink.c:(.text+0x227): undefined reference to `devlink_fmsg_u8_pair_put'
ld: drivers/net/ethernet/huawei/hinic/hinic_devlink.o: in function `hinic_devlink_alloc':
hinic_devlink.c:(.text+0xaee): undefined reference to `devlink_alloc'
ld: drivers/net/ethernet/huawei/hinic/hinic_devlink.o: in function `hinic_devlink_free':
hinic_devlink.c:(.text+0xb04): undefined reference to `devlink_free'
ld: drivers/net/ethernet/huawei/hinic/hinic_devlink.o: in function `hinic_devlink_register':
hinic_devlink.c:(.text+0xb26): undefined reference to `devlink_register'
ld: drivers/net/ethernet/huawei/hinic/hinic_devlink.o: in function `hinic_devlink_unregister':
hinic_devlink.c:(.text+0xb46): undefined reference to `devlink_unregister'
ld: drivers/net/ethernet/huawei/hinic/hinic_devlink.o: in function `hinic_health_reporters_create':
hinic_devlink.c:(.text+0xb75): undefined reference to `devlink_health_reporter_create'
ld: hinic_devlink.c:(.text+0xb95): undefined reference to `devlink_health_reporter_create'
ld: hinic_devlink.c:(.text+0xbac): undefined reference to `devlink_health_reporter_destroy'
ld: drivers/net/ethernet/huawei/hinic/hinic_devlink.o: in function `hinic_health_reporters_destroy':

Fixes: 51ba902a16e6 ("net-next/hinic: Initialize hw interface")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Bin Luo <luobin9@huawei.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Aviad Krawczyk <aviad.krawczyk@huawei.com>
Cc: Zhao Chen <zhaochen6@huawei.com>
---
Found in linux-next but applies to mainline.

 drivers/net/ethernet/huawei/hinic/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20201001.orig/drivers/net/ethernet/huawei/hinic/Kconfig
+++ linux-next-20201001/drivers/net/ethernet/huawei/hinic/Kconfig
@@ -6,6 +6,7 @@
 config HINIC
 	tristate "Huawei Intelligent PCIE Network Interface Card"
 	depends on (PCI_MSI && (X86 || ARM64))
+	select NET_DEVLINK
 	help
 	  This driver supports HiNIC PCIE Ethernet cards.
 	  To compile this driver as part of the kernel, choose Y here.
