Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C101459D37
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 08:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbhKWH6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 02:58:20 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37043 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234274AbhKWH6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 02:58:18 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id C70535C026F;
        Tue, 23 Nov 2021 02:55:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 23 Nov 2021 02:55:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=G2fDSTi8Y5YijL+aNRLRCNm3MgTAuqda6ArM5G1CI5c=; b=Dmf/qZ/w
        9bRI7/JNv2vedfVXmzpttiiwWguC0qYRf95ol+OoGWNRX79D735mhQuZ3WUq3IgK
        bH5GFHJRUUjqcbyauSayBO29h9Hvad9un1ixA6ySXlcUkfT2zehCUQcEqwWKKn5E
        G6PN0r0UmtAYFks3Tm1yUkdabTDpaJ3gN8j31pJzaLdGZBihaWgzCVpHwr1JMYDf
        A/EV6WxjIbFp8FMqRZkqDDCxwyff/sMTBsnJGxSBWU/hkaVhhRokWbML61qsHS2Y
        Wd3FsuSayB9Zh+gSVqZoxNbZg7v73g7R094SRP8muUAGH12q9y6q8JnRnkmN5grj
        U+Kx3uRJAUB2TQ==
X-ME-Sender: <xms:Xp6cYQh3v3powAXV4t3bE9YSpjagImUjeQ_H8LNNgCQOGAR35420pg>
    <xme:Xp6cYZD6zDtUv5XTtDMVBHm8i4cBYOAZm2ix9spzGfp51iQJp69IvJMjWIr2DTQtn
    35HEvwZzaREF8I>
X-ME-Received: <xmr:Xp6cYYFnhHN2jZTifEF-srJ-8J9nbZbLN8bFk-EmvV5qDs-R6aJUawgJeudnghIKmccz6xxXytHWQSCSi7AnjIbgeJPw3UXkEdOm2QN3OiQPxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeehgddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvheelhfeugefhheduieevieeuffegkeeivddvhfffffdttdfhhfeuteelueff
    veenucffohhmrghinhepmhgrihhlqdgrrhgthhhivhgvrdgtohhmpdhkvghrnhgvlhdroh
    hrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehi
    ughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Xp6cYRRkLbKUJT5w7BNfm8E9mQ925HyU-OIpet0Iqr-JT3BXgtEJiA>
    <xmx:Xp6cYdxY8XtQSkjUNxKZ8Zyu0VZ9tmhwFyTp7B3EQ73TdY-Hqb0Rnw>
    <xmx:Xp6cYf4ZT89241QsShrjjPpAxY0gnhOCOMjO909wfXuLtfSTxGWZhQ>
    <xmx:Xp6cYQrZ9zlgcu6XSTppI3RuYib2iIKfAhw5gN_jTjdiiIdgIo5RVw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Nov 2021 02:55:08 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Danielle Ratson <danieller@nvidia.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/2] mlxsw: pci: Add shutdown method in PCI driver
Date:   Tue, 23 Nov 2021 09:54:47 +0200
Message-Id: <20211123075447.3083579-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211123075447.3083579-1-idosch@idosch.org>
References: <20211123075447.3083579-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

On an arm64 platform with the Spectrum ASIC, after loading and executing
a new kernel via kexec, the following trace [1] is observed. This seems
to be caused by the fact that the device is not properly shutdown before
executing the new kernel.

Fix this by implementing a shutdown method which mirrors the remove
method, as recommended by the kexec maintainer [2][3].

[1]
BUG: Bad page state in process devlink pfn:22f73d
page:fffffe00089dcf40 refcount:-1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0x2ffff00000000000()
raw: 2ffff00000000000 0000000000000000 ffffffff089d0201 0000000000000000
raw: 0000000000000000 0000000000000000 ffffffffffffffff 0000000000000000
page dumped because: nonzero _refcount
Modules linked in:
CPU: 1 PID: 16346 Comm: devlink Tainted: G B 5.8.0-rc6-custom-273020-gac6b365b1bf5 #44
Hardware name: Marvell Armada 7040 TX4810M (DT)
Call trace:
 dump_backtrace+0x0/0x1d0
 show_stack+0x1c/0x28
 dump_stack+0xbc/0x118
 bad_page+0xcc/0xf8
 check_free_page_bad+0x80/0x88
 __free_pages_ok+0x3f8/0x418
 __free_pages+0x38/0x60
 kmem_freepages+0x200/0x2a8
 slab_destroy+0x28/0x68
 slabs_destroy+0x60/0x90
 ___cache_free+0x1b4/0x358
 kfree+0xc0/0x1d0
 skb_free_head+0x2c/0x38
 skb_release_data+0x110/0x1a0
 skb_release_all+0x2c/0x38
 consume_skb+0x38/0x130
 __dev_kfree_skb_any+0x44/0x50
 mlxsw_pci_rdq_fini+0x8c/0xb0
 mlxsw_pci_queue_fini.isra.0+0x28/0x58
 mlxsw_pci_queue_group_fini+0x58/0x88
 mlxsw_pci_aqs_fini+0x2c/0x60
 mlxsw_pci_fini+0x34/0x50
 mlxsw_core_bus_device_unregister+0x104/0x1d0
 mlxsw_devlink_core_bus_device_reload_down+0x2c/0x48
 devlink_reload+0x44/0x158
 devlink_nl_cmd_reload+0x270/0x290
 genl_rcv_msg+0x188/0x2f0
 netlink_rcv_skb+0x5c/0x118
 genl_rcv+0x3c/0x50
 netlink_unicast+0x1bc/0x278
 netlink_sendmsg+0x194/0x390
 __sys_sendto+0xe0/0x158
 __arm64_sys_sendto+0x2c/0x38
 el0_svc_common.constprop.0+0x70/0x168
 do_el0_svc+0x28/0x88
 el0_sync_handler+0x88/0x190
 el0_sync+0x140/0x180

[2]
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1195432.html

[3]
https://patchwork.kernel.org/project/linux-scsi/patch/20170212214920.28866-1-anton@ozlabs.org/#20116693

Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index a15c95a10bae..cd3331a077bb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1973,6 +1973,7 @@ int mlxsw_pci_driver_register(struct pci_driver *pci_driver)
 {
 	pci_driver->probe = mlxsw_pci_probe;
 	pci_driver->remove = mlxsw_pci_remove;
+	pci_driver->shutdown = mlxsw_pci_remove;
 	return pci_register_driver(pci_driver);
 }
 EXPORT_SYMBOL(mlxsw_pci_driver_register);
-- 
2.31.1

