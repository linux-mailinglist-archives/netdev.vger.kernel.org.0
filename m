Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07DA63B648
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 01:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbiK2AG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 19:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234873AbiK2AG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 19:06:26 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB433D929;
        Mon, 28 Nov 2022 16:06:12 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id z17so7299945pff.1;
        Mon, 28 Nov 2022 16:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gUrBlJDnCrtn7BBxDo72KZexgb/EEh0EJDjNmyNn2HM=;
        b=YwascfYzqRz8uYMZpO8fkPgQABQOJzc9Eb0zhmeuuHTO4Ppq/OP2AlhHan51iA61gc
         +U+94qwLFYSq2frIVWETGKjhpSNDdjTkp6ldCKprhG69cHojQ1pR0eIj4oScY7EzSdC7
         SdF71uPgTTF9kN9MhSg8t7GBcH39UvepGpSFgNBN+Vw9vX3FQSOi6CnCw2JEkA1q8P/G
         o1G0oePBi+d2rWtNAkDcpBbWaCiT1MB6GFcSJWrH4iAS0BMIXVehDqWZAYiTzWwTvSn5
         0RgJZ/Cz25BbOWD9q69UhpEh6wz9AC8JfuBflnh4KiFlJa9jtNLc1vme43ZZYap91BWB
         KpCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gUrBlJDnCrtn7BBxDo72KZexgb/EEh0EJDjNmyNn2HM=;
        b=IvMY95rXQ6eL856lzMedf1wfgCN/1fBgjq/YmAKBDFxQl0B4/Cfr9W/51u0MI4Xm25
         1tk/zO/YaVhQsngkh0TqUpueKFLFt3yfmUbV46vVElS7Y1PvdfI26GtBzvFlemcsJh2s
         /Nq0DDFvEC9NuczRTqwmIka1QMgYcFca0q6X6RQQHAlW5iopqxQDOG+4H0ZAauIMaxPv
         zinnHoDPbZxUmfdEtK0j7LFIE70eyDdusg0fsqZLqOWWJpn7mETK7dLIzoDD5IyXFGvD
         DUtB7nsiKrIUpfUQjJj8nP8YQlmfNFmpI52MfiQMoA3Fmsu4QKQDa3xG6/B9WhowBqB+
         Pflw==
X-Gm-Message-State: ANoB5plOYzb2G1ToKmScH+DAgzKMxkwafHlW5/OVp28GNm2tnEpgqIbx
        PovGYPs7bfAy77Z5lUmyCdI=
X-Google-Smtp-Source: AA0mqf42OGq2JsuWdRInUysWGJQeKAMHoC9XGUsp+VvrX9kJQFoi4qeJb/2aPBjD5Py6tNwjBSz+NQ==
X-Received: by 2002:a63:f214:0:b0:477:f449:3644 with SMTP id v20-20020a63f214000000b00477f4493644mr13257604pgh.484.1669680372030;
        Mon, 28 Nov 2022 16:06:12 -0800 (PST)
Received: from XH22050090-L.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.gmail.com with ESMTPSA id r2-20020aa79ec2000000b00572198393c2sm8588147pfq.194.2022.11.28.16.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 16:06:11 -0800 (PST)
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
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH net-next v5 1/4] net: devlink: let the core report the driver name instead of the drivers
Date:   Tue, 29 Nov 2022 09:05:47 +0900
Message-Id: <20221129000550.3833570-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221129000550.3833570-1-mailhol.vincent@wanadoo.fr>
References: <20221129000550.3833570-1-mailhol.vincent@wanadoo.fr>
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

nla_put() does not check if an attribute already exists and
unconditionally reserves new space [1]. To avoid attribute
duplication, clean-up all the drivers which are currently reporting
the driver name in their callback.

[1] __nla_put from lib/nlattr.c
Link: https://elixir.bootlin.com/linux/v6.0/source/lib/nlattr.c#L993

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Tested-by: Ido Schimmel <idosch@nvidia.com> # mlxsw
---
 .../crypto/marvell/octeontx2/otx2_cpt_devlink.c |  4 ----
 drivers/net/dsa/hirschmann/hellcreek.c          |  5 -----
 drivers/net/dsa/mv88e6xxx/devlink.c             |  5 -----
 drivers/net/dsa/sja1105/sja1105_devlink.c       | 12 +++---------
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c   |  4 ----
 .../freescale/dpaa2/dpaa2-eth-devlink.c         | 11 +----------
 .../ethernet/fungible/funeth/funeth_devlink.c   |  2 +-
 .../hisilicon/hns3/hns3pf/hclge_devlink.c       |  5 -----
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c     |  5 -----
 drivers/net/ethernet/intel/ice/ice_devlink.c    |  6 ------
 .../ethernet/marvell/octeontx2/af/rvu_devlink.c |  2 +-
 .../marvell/octeontx2/nic/otx2_devlink.c        |  9 +--------
 .../marvell/prestera/prestera_devlink.c         |  5 -----
 .../net/ethernet/mellanox/mlx5/core/devlink.c   |  4 ----
 drivers/net/ethernet/mellanox/mlxsw/core.c      |  5 -----
 .../net/ethernet/netronome/nfp/nfp_devlink.c    |  4 ----
 .../net/ethernet/pensando/ionic/ionic_devlink.c |  4 ----
 drivers/net/ethernet/qlogic/qed/qed_devlink.c   |  4 ----
 drivers/net/netdevsim/dev.c                     |  3 ---
 drivers/ptp/ptp_ocp.c                           |  4 ----
 net/core/devlink.c                              | 17 +++++++++++++++++
 21 files changed, 24 insertions(+), 96 deletions(-)

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
diff --git a/net/core/devlink.c b/net/core/devlink.c
index cea154ddce7a..6478135d9ba1 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6749,11 +6749,24 @@ int devlink_info_version_running_put_ext(struct devlink_info_req *req,
 }
 EXPORT_SYMBOL_GPL(devlink_info_version_running_put_ext);
 
+static int devlink_nl_driver_info_get(struct device_driver *drv,
+				      struct devlink_info_req *req)
+{
+	if (!drv)
+		return 0;
+
+	if (drv->name[0])
+		return devlink_info_driver_name_put(req, drv->name);
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
@@ -6771,6 +6784,10 @@ devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
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

