Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61233849F7
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 12:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbfHGKni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 06:43:38 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42153 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726860AbfHGKni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 06:43:38 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A005521FB5;
        Wed,  7 Aug 2019 06:43:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 07 Aug 2019 06:43:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=YKM0YBuRhbZFkhuAb
        siOfTSMNeb7FVTycDpD1KoHcnU=; b=PHT8qhZy/NFrhIosgBs5SzL5+Et0d12YM
        4RRK6D+tFff+COfi8QlBCaJ7LxxWoXlctGTcQfTO3SDhCsXxA0Y/bNLOnwxgQHyN
        SBuAkmYdMIkjI59zUkrs0S8CWFZTp9eipsdaL5fwj7AOFReSOgzpDNpHmO9ZzAUF
        IiMy7tSnOEi0QjtMvDZbISy1OetjOZKd66FaN5hhrEBz8Rl7N9eyEEewKKEleozg
        76OU09+lE3Y10HRErIrjUZLuoNETkH/Pty1UBPoZkMQLFY94T9f9wbXycFl+z80M
        rHEnQ9Y9NCcSIXjUqYSN2t0hr5nm2u080EpW3evvx6eh5GWj9vvsw==
X-ME-Sender: <xms:WKtKXfDUa8ufafu9FMd1Wnvv76Du3fQJdZMd21nB_v0MDoXykVplgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudduvddgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:WKtKXU9u4AYsySf9435DKQ1cvjdOMer4asMF-aAzGAjENcWpvu1pkQ>
    <xmx:WKtKXbr2qFe0e9I6yvaDoEaT_ORCNnjPwV8yF8y3hyBAeqKYpcQD4g>
    <xmx:WKtKXWGcvhNlVyfq1d0ah5Li5kQIHPmFt_Oixkkj-ddRiaZWrk-6xA>
    <xmx:WKtKXYhAF4lcXnWtZFWTn43mll_ifAiMbZ_EOHgMwEXwKUeP6gFG-g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id EF4C3380090;
        Wed,  7 Aug 2019 06:43:34 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next] mlxsw: spectrum: Extend to support Spectrum-3 ASIC
Date:   Wed,  7 Aug 2019 13:42:31 +0300
Message-Id: <20190807104231.16085-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Extend existing driver for Spectrum and Spectrum-2 ASICs
to support Spectrum-3 ASIC as well.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/Kconfig   |  6 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.h     |  1 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 55 +++++++++++++++++++
 3 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/Kconfig b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
index 06c80343d9ed..f458fd1ce9f8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
@@ -71,7 +71,7 @@ config MLXSW_SWITCHX2
 	  module will be called mlxsw_switchx2.
 
 config MLXSW_SPECTRUM
-	tristate "Mellanox Technologies Spectrum support"
+	tristate "Mellanox Technologies Spectrum family support"
 	depends on MLXSW_CORE && MLXSW_PCI && NET_SWITCHDEV && VLAN_8021Q
 	depends on PSAMPLE || PSAMPLE=n
 	depends on BRIDGE || BRIDGE=n
@@ -87,8 +87,8 @@ config MLXSW_SPECTRUM
 	select NET_PTP_CLASSIFY if PTP_1588_CLOCK
 	default m
 	---help---
-	  This driver supports Mellanox Technologies Spectrum Ethernet
-	  Switch ASICs.
+	  This driver supports Mellanox Technologies
+	  Spectrum/Spectrum-2/Spectrum-3 Ethernet Switch ASICs.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called mlxsw_spectrum.
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.h b/drivers/net/ethernet/mellanox/mlxsw/pci.h
index 946339e13eb9..5b1323645a5d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.h
@@ -9,6 +9,7 @@
 #define PCI_DEVICE_ID_MELLANOX_SWITCHX2		0xc738
 #define PCI_DEVICE_ID_MELLANOX_SPECTRUM		0xcb84
 #define PCI_DEVICE_ID_MELLANOX_SPECTRUM2	0xcf6c
+#define PCI_DEVICE_ID_MELLANOX_SPECTRUM3	0xcf70
 #define PCI_DEVICE_ID_MELLANOX_SWITCHIB		0xcb20
 #define PCI_DEVICE_ID_MELLANOX_SWITCHIB2	0xcf08
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 5a8e94c0a95a..389861ece418 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -65,6 +65,7 @@ static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
 
 static const char mlxsw_sp1_driver_name[] = "mlxsw_spectrum";
 static const char mlxsw_sp2_driver_name[] = "mlxsw_spectrum2";
+static const char mlxsw_sp3_driver_name[] = "mlxsw_spectrum3";
 static const char mlxsw_sp_driver_version[] = "1.0";
 
 static const unsigned char mlxsw_sp1_mac_mask[ETH_ALEN] = {
@@ -5290,6 +5291,35 @@ static struct mlxsw_driver mlxsw_sp2_driver = {
 	.res_query_enabled		= true,
 };
 
+static struct mlxsw_driver mlxsw_sp3_driver = {
+	.kind				= mlxsw_sp3_driver_name,
+	.priv_size			= sizeof(struct mlxsw_sp),
+	.init				= mlxsw_sp2_init,
+	.fini				= mlxsw_sp_fini,
+	.basic_trap_groups_set		= mlxsw_sp_basic_trap_groups_set,
+	.port_split			= mlxsw_sp_port_split,
+	.port_unsplit			= mlxsw_sp_port_unsplit,
+	.sb_pool_get			= mlxsw_sp_sb_pool_get,
+	.sb_pool_set			= mlxsw_sp_sb_pool_set,
+	.sb_port_pool_get		= mlxsw_sp_sb_port_pool_get,
+	.sb_port_pool_set		= mlxsw_sp_sb_port_pool_set,
+	.sb_tc_pool_bind_get		= mlxsw_sp_sb_tc_pool_bind_get,
+	.sb_tc_pool_bind_set		= mlxsw_sp_sb_tc_pool_bind_set,
+	.sb_occ_snapshot		= mlxsw_sp_sb_occ_snapshot,
+	.sb_occ_max_clear		= mlxsw_sp_sb_occ_max_clear,
+	.sb_occ_port_pool_get		= mlxsw_sp_sb_occ_port_pool_get,
+	.sb_occ_tc_port_bind_get	= mlxsw_sp_sb_occ_tc_port_bind_get,
+	.flash_update			= mlxsw_sp_flash_update,
+	.txhdr_construct		= mlxsw_sp_txhdr_construct,
+	.resources_register		= mlxsw_sp2_resources_register,
+	.params_register		= mlxsw_sp2_params_register,
+	.params_unregister		= mlxsw_sp2_params_unregister,
+	.ptp_transmitted		= mlxsw_sp_ptp_transmitted,
+	.txhdr_len			= MLXSW_TXHDR_LEN,
+	.profile			= &mlxsw_sp2_config_profile,
+	.res_query_enabled		= true,
+};
+
 bool mlxsw_sp_port_dev_check(const struct net_device *dev)
 {
 	return dev->netdev_ops == &mlxsw_sp_port_netdev_ops;
@@ -6324,6 +6354,16 @@ static struct pci_driver mlxsw_sp2_pci_driver = {
 	.id_table = mlxsw_sp2_pci_id_table,
 };
 
+static const struct pci_device_id mlxsw_sp3_pci_id_table[] = {
+	{PCI_VDEVICE(MELLANOX, PCI_DEVICE_ID_MELLANOX_SPECTRUM3), 0},
+	{0, },
+};
+
+static struct pci_driver mlxsw_sp3_pci_driver = {
+	.name = mlxsw_sp3_driver_name,
+	.id_table = mlxsw_sp3_pci_id_table,
+};
+
 static int __init mlxsw_sp_module_init(void)
 {
 	int err;
@@ -6339,6 +6379,10 @@ static int __init mlxsw_sp_module_init(void)
 	if (err)
 		goto err_sp2_core_driver_register;
 
+	err = mlxsw_core_driver_register(&mlxsw_sp3_driver);
+	if (err)
+		goto err_sp3_core_driver_register;
+
 	err = mlxsw_pci_driver_register(&mlxsw_sp1_pci_driver);
 	if (err)
 		goto err_sp1_pci_driver_register;
@@ -6347,11 +6391,19 @@ static int __init mlxsw_sp_module_init(void)
 	if (err)
 		goto err_sp2_pci_driver_register;
 
+	err = mlxsw_pci_driver_register(&mlxsw_sp3_pci_driver);
+	if (err)
+		goto err_sp3_pci_driver_register;
+
 	return 0;
 
+err_sp3_pci_driver_register:
+	mlxsw_pci_driver_unregister(&mlxsw_sp2_pci_driver);
 err_sp2_pci_driver_register:
 	mlxsw_pci_driver_unregister(&mlxsw_sp1_pci_driver);
 err_sp1_pci_driver_register:
+	mlxsw_core_driver_unregister(&mlxsw_sp3_driver);
+err_sp3_core_driver_register:
 	mlxsw_core_driver_unregister(&mlxsw_sp2_driver);
 err_sp2_core_driver_register:
 	mlxsw_core_driver_unregister(&mlxsw_sp1_driver);
@@ -6363,8 +6415,10 @@ static int __init mlxsw_sp_module_init(void)
 
 static void __exit mlxsw_sp_module_exit(void)
 {
+	mlxsw_pci_driver_unregister(&mlxsw_sp3_pci_driver);
 	mlxsw_pci_driver_unregister(&mlxsw_sp2_pci_driver);
 	mlxsw_pci_driver_unregister(&mlxsw_sp1_pci_driver);
+	mlxsw_core_driver_unregister(&mlxsw_sp3_driver);
 	mlxsw_core_driver_unregister(&mlxsw_sp2_driver);
 	mlxsw_core_driver_unregister(&mlxsw_sp1_driver);
 	unregister_inet6addr_validator_notifier(&mlxsw_sp_inet6addr_valid_nb);
@@ -6379,4 +6433,5 @@ MODULE_AUTHOR("Jiri Pirko <jiri@mellanox.com>");
 MODULE_DESCRIPTION("Mellanox Spectrum driver");
 MODULE_DEVICE_TABLE(pci, mlxsw_sp1_pci_id_table);
 MODULE_DEVICE_TABLE(pci, mlxsw_sp2_pci_id_table);
+MODULE_DEVICE_TABLE(pci, mlxsw_sp3_pci_id_table);
 MODULE_FIRMWARE(MLXSW_SP1_FW_FILENAME);
-- 
2.21.0

