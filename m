Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044194F5C7C
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbiDFLi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 07:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbiDFLhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 07:37:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A975777B1;
        Wed,  6 Apr 2022 01:26:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C6C660B62;
        Wed,  6 Apr 2022 08:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DC5C385A8;
        Wed,  6 Apr 2022 08:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649233604;
        bh=yTqbiKtFHf8rCUWDV/6SrW/ck2biprXiZegV3WYrODs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aaIwVoQtJ0CMJk7Huijy4TjOnDyjh0ACrPFbiUobtVY/IYJITiegBHpIHCX32hd3x
         tjEJz9Ow4+gviNTttPoP54GoNrHK6wID3n8HGEEQ+ASLNlYlKvFDIhHyvWZ/6cyiom
         525A/GZktu18wBxRucM0IJv2OGfvr9AMzARIkF3/Saa8W6+Yx56XRhzgqpjSLgMlca
         9ruVvqYQkxboeT9CmgIx3PbZA8qoeqIav6a1LwbS9+A+4i+rJ/fVgRpFn2t1Z9f7Go
         Xfs7UNgCrK9xHxNfT3yegp80tBvi7AkMs9uEeSX2eHyRsLX3Wrd94LWSVYtXnMyy7t
         CMQCBFwtS3J8Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 13/17] net/mlx5: Remove not-needed IPsec config
Date:   Wed,  6 Apr 2022 11:25:48 +0300
Message-Id: <fd14492cbc01a0d51a5bfedde02bcd2154123fde.1649232994.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649232994.git.leonro@nvidia.com>
References: <cover.1649232994.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

In current code, the CONFIG_MLX5_IPSEC and CONFIG_MLX5_EN_IPSEC are
the same. So remove useless indirection.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig    | 16 +---------------
 .../net/ethernet/mellanox/mlx5/core/Makefile   |  4 ++--
 .../mellanox/mlx5/core/accel/ipsec_offload.h   | 18 ++----------------
 include/linux/mlx5/accel.h                     |  4 ++--
 include/linux/mlx5/driver.h                    |  2 +-
 5 files changed, 8 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index e34e64a9ff4a..176883cf2827 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -142,28 +142,14 @@ config MLX5_CORE_IPOIB
 	help
 	  MLX5 IPoIB offloads & acceleration support.
 
-config MLX5_IPSEC
+config MLX5_EN_IPSEC
 	bool "Mellanox Technologies IPsec Connect-X support"
 	depends on MLX5_CORE_EN
 	depends on XFRM_OFFLOAD
 	depends on INET_ESP_OFFLOAD || INET6_ESP_OFFLOAD
 	select MLX5_ACCEL
-	help
-	Build IPsec support for the Connect-X family of network cards by Mellanox
-	Technologies.
-	Note: If you select this option, the mlx5_core driver will include
-	IPsec support for the Connect-X family.
-
-config MLX5_EN_IPSEC
-	bool "IPSec XFRM cryptography-offload acceleration"
-	depends on MLX5_CORE_EN
-	depends on XFRM_OFFLOAD
-	depends on INET_ESP_OFFLOAD || INET6_ESP_OFFLOAD
-	depends on MLX5_IPSEC
 	help
 	  Build support for IPsec cryptography-offload acceleration in the NIC.
-	  Note: Support for hardware with this capability needs to be selected
-	  for this option to become available.
 
 config MLX5_EN_TLS
 	bool "Mellanox Technologies TLS Connect-X support"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index ad852703a3cb..9e715a1056f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -88,13 +88,13 @@ mlx5_core-$(CONFIG_MLX5_CORE_IPOIB) += ipoib/ipoib.o ipoib/ethtool.o ipoib/ipoib
 #
 # Accelerations & FPGA
 #
-mlx5_core-$(CONFIG_MLX5_IPSEC) += accel/ipsec_offload.o
 mlx5_core-$(CONFIG_MLX5_ACCEL) += lib/crypto.o
 
 mlx5_core-$(CONFIG_MLX5_FPGA) += fpga/cmd.o fpga/core.o fpga/conn.o fpga/sdk.o
 
 mlx5_core-$(CONFIG_MLX5_EN_IPSEC) += en_accel/ipsec.o en_accel/ipsec_rxtx.o \
-				     en_accel/ipsec_stats.o en_accel/ipsec_fs.o
+				     en_accel/ipsec_stats.o en_accel/ipsec_fs.o \
+				     accel/ipsec_offload.o
 
 mlx5_core-$(CONFIG_MLX5_EN_TLS) += en_accel/ktls_stats.o \
 				   en_accel/fs_tcp.o en_accel/ktls.o en_accel/ktls_txrx.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h
index 3d13e2c136b1..36e700b596d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h
@@ -7,7 +7,7 @@
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/accel.h>
 
-#ifdef CONFIG_MLX5_IPSEC
+#ifdef CONFIG_MLX5_EN_IPSEC
 
 unsigned int mlx5_accel_ipsec_counters_count(struct mlx5_core_dev *mdev);
 int mlx5_accel_ipsec_counters_read(struct mlx5_core_dev *mdev, u64 *counters,
@@ -42,22 +42,8 @@ struct mlx5_accel_ipsec_ops {
 };
 
 #else
-
-static inline void *
-mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
-				 struct mlx5_accel_esp_xfrm *xfrm,
-				 u32 *sa_handle)
-{
-	return NULL;
-}
-
-static inline void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev,
-						  void *context)
-{
-}
-
 static inline void mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev) {}
 
 static inline void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev) {}
-#endif /* CONFIG_MLX5_IPSEC */
+#endif /* CONFIG_MLX5_EN_IPSEC */
 #endif /* __MLX5_IPSEC_OFFLOAD_H__ */
diff --git a/include/linux/mlx5/accel.h b/include/linux/mlx5/accel.h
index 9145e2d37c0e..73e4d50a9f02 100644
--- a/include/linux/mlx5/accel.h
+++ b/include/linux/mlx5/accel.h
@@ -122,7 +122,7 @@ enum mlx5_accel_ipsec_cap {
 	MLX5_ACCEL_IPSEC_CAP_TX_IV_IS_ESN	= 1 << 7,
 };
 
-#ifdef CONFIG_MLX5_ACCEL
+#ifdef CONFIG_MLX5_EN_IPSEC
 
 u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev);
 
@@ -152,5 +152,5 @@ static inline int
 mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
 			   const struct mlx5_accel_esp_xfrm_attrs *attrs) { return -EOPNOTSUPP; }
 
-#endif /* CONFIG_MLX5_ACCEL */
+#endif /* CONFIG_MLX5_EN_IPSEC */
 #endif /* __MLX5_ACCEL_H__ */
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 9424503eb8d3..5af53c035949 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -778,7 +778,7 @@ struct mlx5_core_dev {
 #ifdef CONFIG_MLX5_FPGA
 	struct mlx5_fpga_device *fpga;
 #endif
-#ifdef CONFIG_MLX5_ACCEL
+#ifdef CONFIG_MLX5_EN_IPSEC
 	const struct mlx5_accel_ipsec_ops *ipsec_ops;
 #endif
 	struct mlx5_clock        clock;
-- 
2.35.1

