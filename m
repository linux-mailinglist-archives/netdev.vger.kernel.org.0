Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D1063BD50
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbiK2Jww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbiK2Jwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:52:47 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE4CEA9;
        Tue, 29 Nov 2022 01:52:35 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id w79so13186653pfc.2;
        Tue, 29 Nov 2022 01:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5SaV6Yh7JZ0VQ83NKLzcYmEfWgY+MSLdkTRa6efG4FU=;
        b=buroPP19N69zXF+zpk0k72VoJ9NXWituZ+9dkti40CvUhPHrIivTYJtdMT6x4ebS/Z
         bAy6k2kdEs/rBjjcOkSqp2FmSOo87cruEtO8UON5uu3xjxiEgo+A9VnuxnMNT+z0XN2W
         gW6XVx13BrffUTdcnjZtMIIum/dxEA/oLuWntWn+TGUg2MH64mddwrjqT+ZEFhnf9rss
         S+uay2Q75VQFpB9dkEt6MBVQmUwEujzc4sOaOUUyz0jemGQ4+q9Hu+xELImEce5hTnST
         OjWU17idAWu3BsswbkghUnLej1RlGnowb/Rh+tPQbNENm15UdSUhES6OaU02P2h9pXK8
         HW+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5SaV6Yh7JZ0VQ83NKLzcYmEfWgY+MSLdkTRa6efG4FU=;
        b=wcSYjBtzAjnxM9ke73HwS8QTt80cWR6ZLKotLj3qoE7gOJdtG+jnCTjqVgXMliPZRU
         jbb+HsPeLVxtNHj2lY9mLqMm8Y7W+gEdJBWpeHT714Y6zptZXkp3tV3IQkeAD+nF0lXA
         Zz90K2As/8hldZia8MtxB8F/01baHBEhJ3u/kTecT6+tVRy9Ds8SWo8WfWhAssWi0srW
         vGPGO45qOb7mbTLO8hRANtdHHFOIPMWZ/PnWjKZZOpTbuoOyw/W1HpGtBbs13+xlLIiY
         p1+mbc8VbQTXG/ODwc9GptlQijyvNqxWm7qS8TmPSG8CFJtxuAPLuvbWK+L0sEz6LC03
         ibjw==
X-Gm-Message-State: ANoB5pnEzhEDBxy6KdkWyH9XDtYgEzNqBNdxCFpXLz2p2wXEsK8GbZNS
        tYTu79MKoLfOMC0JG50VHsc=
X-Google-Smtp-Source: AA0mqf4NfdK/EvWsLLIaNmJbEBhzX7YBwqMlCpRgta2Yx/Lo208biMRmp/YMIe2DykSoYWFJMr8znA==
X-Received: by 2002:a65:4c42:0:b0:477:f872:8b6 with SMTP id l2-20020a654c42000000b00477f87208b6mr14255393pgr.457.1669715554908;
        Tue, 29 Nov 2022 01:52:34 -0800 (PST)
Received: from XH22050090-L.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.gmail.com with ESMTPSA id mv15-20020a17090b198f00b0021937b2118bsm941346pjb.54.2022.11.29.01.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 01:52:34 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Shannon Nelson <snelson@pensando.io>, drivers@pensando.io,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Shalom Toledo <shalomt@mellanox.com>,
        linux-crypto@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, oss-drivers@corigine.com,
        Jiri Pirko <jiri@mellanox.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Shijith Thotton <sthotton@marvell.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next v6 1/3] net: devlink: let the core report the driver name instead of the drivers
Date:   Tue, 29 Nov 2022 18:51:38 +0900
Message-Id: <20221129095140.3913303-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221129095140.3913303-1-mailhol.vincent@wanadoo.fr>
References: <20221129095140.3913303-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver name is available in device_driver::name. Right now,
drivers still have to report this piece of information themselves in
their devlink_ops::info_get callback function.

In order to factorize code, make devlink_nl_info_fill() add the driver
name attribute.

Now that the core sets the driver name attribute, drivers are not
supposed to call devlink_info_driver_name_put() anymore. Remove
devlink_info_driver_name_put() and clean-up all the drivers using this
function in their callback.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Tested-by: Ido Schimmel <idosch@nvidia.com> # mlxsw
Reviewed-by: Jacob Keller  <jacob.e.keller@intel.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../marvell/octeontx2/otx2_cpt_devlink.c      |  4 ---
 drivers/net/dsa/hirschmann/hellcreek.c        |  5 ----
 drivers/net/dsa/mv88e6xxx/devlink.c           |  5 ----
 drivers/net/dsa/sja1105/sja1105_devlink.c     | 12 +++------
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  4 ---
 .../freescale/dpaa2/dpaa2-eth-devlink.c       | 11 +-------
 .../ethernet/fungible/funeth/funeth_devlink.c |  2 +-
 .../hisilicon/hns3/hns3pf/hclge_devlink.c     |  5 ----
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |  5 ----
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  6 -----
 .../marvell/octeontx2/af/rvu_devlink.c        |  2 +-
 .../marvell/octeontx2/nic/otx2_devlink.c      |  9 +------
 .../marvell/prestera/prestera_devlink.c       |  5 ----
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  4 ---
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  5 ----
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  4 ---
 .../ethernet/pensando/ionic/ionic_devlink.c   |  4 ---
 drivers/net/ethernet/qlogic/qed/qed_devlink.c |  4 ---
 drivers/net/netdevsim/dev.c                   |  3 ---
 drivers/ptp/ptp_ocp.c                         |  4 ---
 include/net/devlink.h                         |  2 --
 net/core/devlink.c                            | 26 +++++++++++++------
 22 files changed, 25 insertions(+), 106 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c b/drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c
index 7503f6b18ac5..a2aba0b0d68a 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c
@@ -76,10 +76,6 @@ static int otx2_cpt_devlink_info_get(struct devlink *dl,
 	struct otx2_cptpf_dev *cptpf = cpt_dl->cptpf;
 	int err;
 
-	err = devlink_info_driver_name_put(req, "rvu_cptpf");
-	if (err)
-		return err;
-
 	err = otx2_cpt_dl_info_firmware_version_put(req, cptpf->eng_grps.grp,
 						    "fw.ae", OTX2_CPT_AE_TYPES);
 	if (err)
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 951f7935c872..595a548bb0a8 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1176,11 +1176,6 @@ static int hellcreek_devlink_info_get(struct dsa_switch *ds,
 				      struct netlink_ext_ack *extack)
 {
 	struct hellcreek *hellcreek = ds->priv;
-	int ret;
-
-	ret = devlink_info_driver_name_put(req, "hellcreek");
-	if (ret)
-		return ret;
 
 	return devlink_info_version_fixed_put(req,
 					      DEVLINK_INFO_VERSION_GENERIC_ASIC_ID,
diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6xxx/devlink.c
index 1266eabee086..a08dab75e0c0 100644
--- a/drivers/net/dsa/mv88e6xxx/devlink.c
+++ b/drivers/net/dsa/mv88e6xxx/devlink.c
@@ -821,11 +821,6 @@ int mv88e6xxx_devlink_info_get(struct dsa_switch *ds,
 			       struct netlink_ext_ack *extack)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
-	int err;
-
-	err = devlink_info_driver_name_put(req, "mv88e6xxx");
-	if (err)
-		return err;
 
 	return devlink_info_version_fixed_put(req,
 					      DEVLINK_INFO_VERSION_GENERIC_ASIC_ID,
diff --git a/drivers/net/dsa/sja1105/sja1105_devlink.c b/drivers/net/dsa/sja1105/sja1105_devlink.c
index 10c6fea1227f..da532614f34a 100644
--- a/drivers/net/dsa/sja1105/sja1105_devlink.c
+++ b/drivers/net/dsa/sja1105/sja1105_devlink.c
@@ -120,16 +120,10 @@ int sja1105_devlink_info_get(struct dsa_switch *ds,
 			     struct netlink_ext_ack *extack)
 {
 	struct sja1105_private *priv = ds->priv;
-	int rc;
-
-	rc = devlink_info_driver_name_put(req, "sja1105");
-	if (rc)
-		return rc;
 
-	rc = devlink_info_version_fixed_put(req,
-					    DEVLINK_INFO_VERSION_GENERIC_ASIC_ID,
-					    priv->info->name);
-	return rc;
+	return devlink_info_version_fixed_put(req,
+					      DEVLINK_INFO_VERSION_GENERIC_ASIC_ID,
+					      priv->info->name);
 }
 
 int sja1105_devlink_setup(struct dsa_switch *ds)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 8a6f788f6294..26913dc816d3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -892,10 +892,6 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	u32 ver = 0;
 	int rc;
 
-	rc = devlink_info_driver_name_put(req, DRV_MODULE_NAME);
-	if (rc)
-		return rc;
-
 	if (BNXT_PF(bp) && (bp->flags & BNXT_FLAG_DSN_VALID)) {
 		sprintf(buf, "%02X-%02X-%02X-%02X-%02X-%02X-%02X-%02X",
 			bp->dsn[7], bp->dsn[6], bp->dsn[5], bp->dsn[4],
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
index 5c6dd3029e2f..76f808d38066 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
@@ -37,18 +37,9 @@ static int dpaa2_eth_dl_info_get(struct devlink *devlink,
 	struct dpaa2_eth_devlink_priv *dl_priv = devlink_priv(devlink);
 	struct dpaa2_eth_priv *priv = dl_priv->dpaa2_priv;
 	char buf[10];
-	int err;
-
-	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
-	if (err)
-		return err;
 
 	scnprintf(buf, 10, "%d.%d", priv->dpni_ver_major, priv->dpni_ver_minor);
-	err = devlink_info_version_running_put(req, "dpni", buf);
-	if (err)
-		return err;
-
-	return 0;
+	return devlink_info_version_running_put(req, "dpni", buf);
 }
 
 static struct dpaa2_eth_trap_item *
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_devlink.c b/drivers/net/ethernet/fungible/funeth/funeth_devlink.c
index d50c222948b4..6668375edff6 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_devlink.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_devlink.c
@@ -6,7 +6,7 @@
 static int fun_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			   struct netlink_ext_ack *extack)
 {
-	return devlink_info_driver_name_put(req, KBUILD_MODNAME);
+	return 0;
 }
 
 static const struct devlink_ops fun_dl_ops = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
index 4c441e6a5082..3d3b69605423 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
@@ -13,11 +13,6 @@ static int hclge_devlink_info_get(struct devlink *devlink,
 	struct hclge_devlink_priv *priv = devlink_priv(devlink);
 	char version_str[HCLGE_DEVLINK_FW_STRING_LEN];
 	struct hclge_dev *hdev = priv->hdev;
-	int ret;
-
-	ret = devlink_info_driver_name_put(req, KBUILD_MODNAME);
-	if (ret)
-		return ret;
 
 	snprintf(version_str, sizeof(version_str), "%lu.%lu.%lu.%lu",
 		 hnae3_get_field(hdev->fw_version, HNAE3_FW_VERSION_BYTE3_MASK,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
index fdc19868b818..a6c3c5e8f0ab 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
@@ -13,11 +13,6 @@ static int hclgevf_devlink_info_get(struct devlink *devlink,
 	struct hclgevf_devlink_priv *priv = devlink_priv(devlink);
 	char version_str[HCLGEVF_DEVLINK_FW_STRING_LEN];
 	struct hclgevf_dev *hdev = priv->hdev;
-	int ret;
-
-	ret = devlink_info_driver_name_put(req, KBUILD_MODNAME);
-	if (ret)
-		return ret;
 
 	snprintf(version_str, sizeof(version_str), "%lu.%lu.%lu.%lu",
 		 hnae3_get_field(hdev->fw_version, HNAE3_FW_VERSION_BYTE3_MASK,
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 1d638216484d..ba74977e75dc 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -311,12 +311,6 @@ static int ice_devlink_info_get(struct devlink *devlink,
 		}
 	}
 
-	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
-	if (err) {
-		NL_SET_ERR_MSG_MOD(extack, "Unable to set driver name");
-		goto out_free_ctx;
-	}
-
 	ice_info_get_dsn(pf, ctx);
 
 	err = devlink_info_serial_number_put(req, ctx->buf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 88dee589cb21..f15439d26d21 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -1550,7 +1550,7 @@ static int rvu_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 static int rvu_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 				struct netlink_ext_ack *extack)
 {
-	return devlink_info_driver_name_put(req, DRV_NAME);
+	return 0;
 }
 
 static const struct devlink_ops rvu_devlink_ops = {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
index 777a27047c8e..5cc6416cf1a6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
@@ -77,18 +77,11 @@ static const struct devlink_param otx2_dl_params[] = {
 			     otx2_dl_mcam_count_validate),
 };
 
-/* Devlink OPs */
 static int otx2_devlink_info_get(struct devlink *devlink,
 				 struct devlink_info_req *req,
 				 struct netlink_ext_ack *extack)
 {
-	struct otx2_devlink *otx2_dl = devlink_priv(devlink);
-	struct otx2_nic *pfvf = otx2_dl->pfvf;
-
-	if (is_otx2_vf(pfvf->pcifunc))
-		return devlink_info_driver_name_put(req, "rvu_nicvf");
-
-	return devlink_info_driver_name_put(req, "rvu_nicpf");
+	return 0;
 }
 
 static const struct devlink_ops otx2_devlink_ops = {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
index 84ad05c9f12d..2a4c9df4eb79 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
@@ -355,11 +355,6 @@ static int prestera_dl_info_get(struct devlink *dl,
 {
 	struct prestera_switch *sw = devlink_priv(dl);
 	char buf[16];
-	int err;
-
-	err = devlink_info_driver_name_put(req, PRESTERA_DRV_NAME);
-	if (err)
-		return err;
 
 	snprintf(buf, sizeof(buf), "%d.%d.%d",
 		 sw->dev->fw_rev.maj,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index cc2ae427dcb0..751bc4a9edcf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -46,10 +46,6 @@ mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 	u32 running_fw, stored_fw;
 	int err;
 
-	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
-	if (err)
-		return err;
-
 	err = devlink_info_version_fixed_put(req, "fw.psid", dev->board_id);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index a83f6bc30072..a0a06e2eff82 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1459,11 +1459,6 @@ mlxsw_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 	char buf[32];
 	int err;
 
-	err = devlink_info_driver_name_put(req,
-					   mlxsw_core->bus_info->device_kind);
-	if (err)
-		return err;
-
 	mlxsw_reg_mgir_pack(mgir_pl);
 	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mgir), mgir_pl);
 	if (err)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index 8bfd48d50ef0..4c601ff09cd3 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -239,10 +239,6 @@ nfp_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 	char *buf = NULL;
 	int err;
 
-	err = devlink_info_driver_name_put(req, "nfp");
-	if (err)
-		return err;
-
 	vendor = nfp_hwinfo_lookup(pf->hwinfo, "assembly.vendor");
 	part = nfp_hwinfo_lookup(pf->hwinfo, "assembly.partno");
 	sn = nfp_hwinfo_lookup(pf->hwinfo, "assembly.serial");
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index 567f778433e2..e6ff757895ab 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -26,10 +26,6 @@ static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	char buf[16];
 	int err = 0;
 
-	err = devlink_info_driver_name_put(req, IONIC_DRV_NAME);
-	if (err)
-		return err;
-
 	err = devlink_info_version_running_put(req,
 					       DEVLINK_INFO_VERSION_GENERIC_FW,
 					       idev->dev_info.fw_version);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
index 6bb4e165b592..922c47797af6 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
@@ -162,10 +162,6 @@ static int qed_devlink_info_get(struct devlink *devlink,
 
 	dev_info = &cdev->common_dev_info;
 
-	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
-	if (err)
-		return err;
-
 	memcpy(buf, cdev->hwfns[0].hw_info.part_num, sizeof(cdev->hwfns[0].hw_info.part_num));
 	buf[sizeof(cdev->hwfns[0].hw_info.part_num)] = 0;
 
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index e14686594a71..b962fc8e1397 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -994,9 +994,6 @@ static int nsim_dev_info_get(struct devlink *devlink,
 {
 	int err;
 
-	err = devlink_info_driver_name_put(req, DRV_NAME);
-	if (err)
-		return err;
 	err = devlink_info_version_stored_put_ext(req, "fw.mgmt", "10.20.30",
 						  DEVLINK_INFO_VERSION_TYPE_COMPONENT);
 	if (err)
diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 154d58cbd9ce..4bbaccd543ad 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1647,10 +1647,6 @@ ptp_ocp_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 	char buf[32];
 	int err;
 
-	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
-	if (err)
-		return err;
-
 	fw_image = bp->fw_loader ? "loader" : "fw";
 	sprintf(buf, "%d.%d", bp->fw_tag, bp->fw_version);
 	err = devlink_info_version_running_put(req, fw_image, buf);
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 074a79b8933f..52d5fb67e9b8 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1746,8 +1746,6 @@ int devlink_region_snapshot_create(struct devlink_region *region,
 				   u8 *data, u32 snapshot_id);
 int devlink_info_serial_number_put(struct devlink_info_req *req,
 				   const char *sn);
-int devlink_info_driver_name_put(struct devlink_info_req *req,
-				 const char *name);
 int devlink_info_board_serial_number_put(struct devlink_info_req *req,
 					 const char *bsn);
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index cea154ddce7a..3babc16eeb6b 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6633,14 +6633,6 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	return err;
 }
 
-int devlink_info_driver_name_put(struct devlink_info_req *req, const char *name)
-{
-	if (!req->msg)
-		return 0;
-	return nla_put_string(req->msg, DEVLINK_ATTR_INFO_DRIVER_NAME, name);
-}
-EXPORT_SYMBOL_GPL(devlink_info_driver_name_put);
-
 int devlink_info_serial_number_put(struct devlink_info_req *req, const char *sn)
 {
 	if (!req->msg)
@@ -6749,11 +6741,25 @@ int devlink_info_version_running_put_ext(struct devlink_info_req *req,
 }
 EXPORT_SYMBOL_GPL(devlink_info_version_running_put_ext);
 
+static int devlink_nl_driver_info_get(struct device_driver *drv,
+				      struct devlink_info_req *req)
+{
+	if (!drv)
+		return 0;
+
+	if (drv->name[0])
+		return nla_put_string(req->msg, DEVLINK_ATTR_INFO_DRIVER_NAME,
+				      drv->name);
+
+	return 0;
+}
+
 static int
 devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
 		     enum devlink_command cmd, u32 portid,
 		     u32 seq, int flags, struct netlink_ext_ack *extack)
 {
+	struct device *dev = devlink_to_dev(devlink);
 	struct devlink_info_req req = {};
 	void *hdr;
 	int err;
@@ -6771,6 +6777,10 @@ devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (err)
 		goto err_cancel_msg;
 
+	err = devlink_nl_driver_info_get(dev->driver, &req);
+	if (err)
+		goto err_cancel_msg;
+
 	genlmsg_end(msg, hdr);
 	return 0;
 
-- 
2.25.1

