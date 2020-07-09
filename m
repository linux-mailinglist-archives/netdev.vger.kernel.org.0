Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCC121A0AA
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgGINTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:19:45 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:49657 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726831AbgGINTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 09:19:14 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7394F5804D1;
        Thu,  9 Jul 2020 09:19:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 09 Jul 2020 09:19:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=sp9/gXI5Q1LnOn8qX++LPPnmNAnVLgkRr2JDPsTRdQ8=; b=mdhsL6xy
        p95QgBvDdONuBTBU4LV2VSWpmvySjYxv+sQ8n6cR3wUX7LhcTNThxfmTw0QN3ajf
        7rhcIrzJEGhSWhbIM344PZTKU3hrqYkgzVLPCRsyTaeQjkMdDMwPygC09XO8eXqD
        WfCVT3ZZR6ffiGeYJ2AmR7xRPf/Q+mcf8/9YbRlYoUOwj+ahs5YYh7NjBepkxVn7
        Qf4uzCWu9jRZIWXvDXJkBI0rBjVkFj8xtcGarDBwHI9EqRfns9HLFNqcpYMXaGYd
        cNDYqzgdeTvn14Vv/UXhKDufAo8NZLQFtcALTgfdCUyUUWUxzU5rQWi6i9dKEPnm
        C1C25KGtrjvnng==
X-ME-Sender: <xms:TxkHX62W_LzWSHay-tNTJfbAeRXh3rhGNBOT-7J9PSIR-PFBQXLIGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudelgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:TxkHX9GxXZxMCy2QhvsVkmaAtZSg8ia6kr0XvgKPY_6fq326e0ZjKg>
    <xmx:TxkHXy7UsuNqRl_2EkKOWMH0GjeDsK4CzjsD3D-R3-l_A0C0l8Laaw>
    <xmx:TxkHX70XEWENVQMaAZGUvWCyyvyeX19IdSfJzf1x7wmCrnD5_jNZ7Q>
    <xmx:TxkHX19WPKPd16K-IkmenJ1ijDkSuvjGwhnk8mTPyM9g721O2KaZ5w>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5A159328005E;
        Thu,  9 Jul 2020 09:19:07 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, snelson@pensando.io, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 3/9] devlink: Replace devlink_port_attrs_set parameters with a struct
Date:   Thu,  9 Jul 2020 16:18:16 +0300
Message-Id: <20200709131822.542252-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200709131822.542252-1-idosch@idosch.org>
References: <20200709131822.542252-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

Currently, devlink_port_attrs_set accepts a long list of parameters,
that most of them are devlink port's attributes.

Use the devlink_port_attrs struct to replace the relevant parameters.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  9 ++--
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  6 ++-
 .../ethernet/mellanox/mlx5/core/en/devlink.c  | 19 ++++---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 16 +++---
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 11 ++--
 .../net/ethernet/netronome/nfp/nfp_devlink.c  | 11 ++--
 .../ethernet/pensando/ionic/ionic_devlink.c   |  5 +-
 drivers/net/netdevsim/dev.c                   | 10 ++--
 include/net/devlink.h                         | 20 ++++---
 net/core/devlink.c                            | 54 ++++---------------
 net/dsa/dsa2.c                                | 17 +++---
 11 files changed, 82 insertions(+), 96 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 2bd610fafc58..3a854195d5b0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -691,6 +691,7 @@ static void bnxt_dl_params_unregister(struct bnxt *bp)
 
 int bnxt_dl_register(struct bnxt *bp)
 {
+	struct devlink_port_attrs attrs = {};
 	struct devlink *dl;
 	int rc;
 
@@ -719,9 +720,11 @@ int bnxt_dl_register(struct bnxt *bp)
 	if (!BNXT_PF(bp))
 		return 0;
 
-	devlink_port_attrs_set(&bp->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
-			       bp->pf.port_id, false, 0, bp->dsn,
-			       sizeof(bp->dsn));
+	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+	attrs.phys.port_number = bp->pf.port_id;
+	memcpy(attrs.switch_id.id, bp->dsn, sizeof(bp->dsn));
+	attrs.switch_id.id_len = sizeof(bp->dsn);
+	devlink_port_attrs_set(&bp->dl_port, &attrs);
 	rc = devlink_port_register(dl, &bp->dl_port, bp->pf.port_id);
 	if (rc) {
 		netdev_err(bp->dev, "devlink_port_register failed\n");
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 3ea470e8cfa2..43da2dcb0cbc 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -312,6 +312,7 @@ int ice_devlink_create_port(struct ice_pf *pf)
 	struct devlink *devlink = priv_to_devlink(pf);
 	struct ice_vsi *vsi = ice_get_main_vsi(pf);
 	struct device *dev = ice_pf_to_dev(pf);
+	struct devlink_port_attrs attrs = {};
 	int err;
 
 	if (!vsi) {
@@ -319,8 +320,9 @@ int ice_devlink_create_port(struct ice_pf *pf)
 		return -EIO;
 	}
 
-	devlink_port_attrs_set(&pf->devlink_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
-			       pf->hw.pf_id, false, 0, NULL, 0);
+	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+	attrs.phys.port_number = pf->hw.pf_id;
+	devlink_port_attrs_set(&pf->devlink_port, &attrs);
 	err = devlink_port_register(devlink, &pf->devlink_port, pf->hw.pf_id);
 	if (err) {
 		dev_err(dev, "devlink_port_register failed: %d\n", err);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
index f8b2de4b04be..a69c62d72d16 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
@@ -6,17 +6,16 @@
 int mlx5e_devlink_port_register(struct mlx5e_priv *priv)
 {
 	struct devlink *devlink = priv_to_devlink(priv->mdev);
+	struct devlink_port_attrs attrs = {};
 
-	if (mlx5_core_is_pf(priv->mdev))
-		devlink_port_attrs_set(&priv->dl_port,
-				       DEVLINK_PORT_FLAVOUR_PHYSICAL,
-				       PCI_FUNC(priv->mdev->pdev->devfn),
-				       false, 0,
-				       NULL, 0);
-	else
-		devlink_port_attrs_set(&priv->dl_port,
-				       DEVLINK_PORT_FLAVOUR_VIRTUAL,
-				       0, false, 0, NULL, 0);
+	if (mlx5_core_is_pf(priv->mdev)) {
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+		attrs.phys.port_number = PCI_FUNC(priv->mdev->pdev->devfn);
+	} else {
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_VIRTUAL;
+	}
+
+	devlink_port_attrs_set(&priv->dl_port, &attrs);
 
 	return devlink_port_register(devlink, &priv->dl_port, 1);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index ed2430677b12..0a69f10ac30c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1185,6 +1185,7 @@ static int register_devlink_port(struct mlx5_core_dev *dev,
 {
 	struct devlink *devlink = priv_to_devlink(dev);
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
+	struct devlink_port_attrs attrs = {};
 	struct netdev_phys_item_id ppid = {};
 	unsigned int dl_port_index = 0;
 	u16 pfnum;
@@ -1195,19 +1196,16 @@ static int register_devlink_port(struct mlx5_core_dev *dev,
 	mlx5e_rep_get_port_parent_id(rpriv->netdev, &ppid);
 	dl_port_index = mlx5_esw_vport_to_devlink_port_index(dev, rep->vport);
 	pfnum = PCI_FUNC(dev->pdev->devfn);
-
+	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+	attrs.phys.port_number = pfnum;
+	memcpy(attrs.switch_id.id, &ppid.id[0], ppid.id_len);
+	attrs.switch_id.id_len = ppid.id_len;
 	if (rep->vport == MLX5_VPORT_UPLINK)
-		devlink_port_attrs_set(&rpriv->dl_port,
-				       DEVLINK_PORT_FLAVOUR_PHYSICAL,
-				       pfnum, false, 0,
-				       &ppid.id[0], ppid.id_len);
+		devlink_port_attrs_set(&rpriv->dl_port, &attrs);
 	else if (rep->vport == MLX5_VPORT_PF)
-		devlink_port_attrs_pci_pf_set(&rpriv->dl_port,
-					      &ppid.id[0], ppid.id_len,
-					      pfnum);
+		devlink_port_attrs_pci_pf_set(&rpriv->dl_port, pfnum);
 	else if (mlx5_eswitch_is_vf_vport(dev->priv.eswitch, rpriv->rep->vport))
 		devlink_port_attrs_pci_vf_set(&rpriv->dl_port,
-					      &ppid.id[0], ppid.id_len,
 					      pfnum, rep->vport - 1);
 
 	return devlink_port_register(devlink, &rpriv->dl_port, dl_port_index);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index e9ccd333f61d..bbe7358d4ea5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2129,12 +2129,17 @@ static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 	struct mlxsw_core_port *mlxsw_core_port =
 					&mlxsw_core->ports[local_port];
 	struct devlink_port *devlink_port = &mlxsw_core_port->devlink_port;
+	struct devlink_port_attrs attrs = {};
 	int err;
 
+	attrs.split = split;
+	attrs.flavour = flavour;
+	attrs.phys.port_number = port_number;
+	attrs.phys.split_subport_number = split_port_subnumber;
+	memcpy(attrs.switch_id.id, switch_id, switch_id_len);
+	attrs.switch_id.id_len = switch_id_len;
 	mlxsw_core_port->local_port = local_port;
-	devlink_port_attrs_set(devlink_port, flavour, port_number,
-			       split, split_port_subnumber,
-			       switch_id, switch_id_len);
+	devlink_port_attrs_set(devlink_port, &attrs);
 	err = devlink_port_register(devlink, devlink_port, local_port);
 	if (err)
 		memset(mlxsw_core_port, 0, sizeof(*mlxsw_core_port));
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index 07dbf4d72227..71f4e624b3db 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -353,6 +353,7 @@ const struct devlink_ops nfp_devlink_ops = {
 
 int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port)
 {
+	struct devlink_port_attrs attrs = {};
 	struct nfp_eth_table_port eth_port;
 	struct devlink *devlink;
 	const u8 *serial;
@@ -365,10 +366,14 @@ int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port)
 	if (ret)
 		return ret;
 
+	attrs.split = eth_port.is_split;
+	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+	attrs.phys.port_number = eth_port.label_port;
+	attrs.phys.split_subport_number = eth_port.label_subport;
 	serial_len = nfp_cpp_serial(port->app->cpp, &serial);
-	devlink_port_attrs_set(&port->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
-			       eth_port.label_port, eth_port.is_split,
-			       eth_port.label_subport, serial, serial_len);
+	memcpy(attrs.switch_id.id, serial, serial_len);
+	attrs.switch_id.id_len = serial_len;
+	devlink_port_attrs_set(&port->dl_port, &attrs);
 
 	devlink = priv_to_devlink(app->pf);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index 2d590e571133..c4f4fd469fe3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -69,6 +69,7 @@ void ionic_devlink_free(struct ionic *ionic)
 int ionic_devlink_register(struct ionic *ionic)
 {
 	struct devlink *dl = priv_to_devlink(ionic);
+	struct devlink_port_attrs attrs = {};
 	int err;
 
 	err = devlink_register(dl, ionic->dev);
@@ -77,8 +78,8 @@ int ionic_devlink_register(struct ionic *ionic)
 		return err;
 	}
 
-	devlink_port_attrs_set(&ionic->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
-			       0, false, 0, NULL, 0);
+	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+	devlink_port_attrs_set(&ionic->dl_port, &attrs);
 	err = devlink_port_register(dl, &ionic->dl_port, 0);
 	if (err)
 		dev_err(ionic->dev, "devlink_port_register failed: %d\n", err);
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index ec6b6f7818ac..0dc2c66a5d56 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -889,6 +889,7 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
 			       unsigned int port_index)
 {
+	struct devlink_port_attrs attrs = {};
 	struct nsim_dev_port *nsim_dev_port;
 	struct devlink_port *devlink_port;
 	int err;
@@ -899,10 +900,11 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
 	nsim_dev_port->port_index = port_index;
 
 	devlink_port = &nsim_dev_port->devlink_port;
-	devlink_port_attrs_set(devlink_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
-			       port_index + 1, 0, 0,
-			       nsim_dev->switch_id.id,
-			       nsim_dev->switch_id.id_len);
+	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+	attrs.phys.port_number = port_index + 1;
+	memcpy(attrs.switch_id.id, nsim_dev->switch_id.id, nsim_dev->switch_id.id_len);
+	attrs.switch_id.id_len = nsim_dev->switch_id.id_len;
+	devlink_port_attrs_set(devlink_port, &attrs);
 	err = devlink_port_register(priv_to_devlink(nsim_dev), devlink_port,
 				    port_index);
 	if (err)
diff --git a/include/net/devlink.h b/include/net/devlink.h
index de4b5dcdb4a5..8f9db991192d 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -52,7 +52,7 @@ struct devlink_port_phys_attrs {
 			  * A physical port which is visible to the user
 			  * for a given port flavour.
 			  */
-	u32 split_subport_number;
+	u32 split_subport_number; /* If the port is split, this is the number of subport. */
 };
 
 struct devlink_port_pci_pf_attrs {
@@ -64,6 +64,12 @@ struct devlink_port_pci_vf_attrs {
 	u16 vf;	/* Associated PCI VF for of the PCI PF for this port. */
 };
 
+/**
+ * struct devlink_port_attrs - devlink port object
+ * @flavour: flavour of the port
+ * @split: indicates if this is split port
+ * @switch_id: if the port is part of switch, this is buffer with ID, otherwise this is NULL
+ */
 struct devlink_port_attrs {
 	u8 split:1;
 	enum devlink_port_flavour flavour;
@@ -1180,17 +1186,9 @@ void devlink_port_type_ib_set(struct devlink_port *devlink_port,
 			      struct ib_device *ibdev);
 void devlink_port_type_clear(struct devlink_port *devlink_port);
 void devlink_port_attrs_set(struct devlink_port *devlink_port,
-			    enum devlink_port_flavour flavour,
-			    u32 port_number, bool split,
-			    u32 split_subport_number,
-			    const unsigned char *switch_id,
-			    unsigned char switch_id_len);
-void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port,
-				   const unsigned char *switch_id,
-				   unsigned char switch_id_len, u16 pf);
+			    struct devlink_port_attrs *devlink_port_attrs);
+void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u16 pf);
 void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port,
-				   const unsigned char *switch_id,
-				   unsigned char switch_id_len,
 				   u16 pf, u16 vf);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 452b2f8a054e..266936c38357 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7510,9 +7510,7 @@ void devlink_port_type_clear(struct devlink_port *devlink_port)
 EXPORT_SYMBOL_GPL(devlink_port_type_clear);
 
 static int __devlink_port_attrs_set(struct devlink_port *devlink_port,
-				    enum devlink_port_flavour flavour,
-				    const unsigned char *switch_id,
-				    unsigned char switch_id_len)
+				    enum devlink_port_flavour flavour)
 {
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 
@@ -7520,12 +7518,10 @@ static int __devlink_port_attrs_set(struct devlink_port *devlink_port,
 		return -EEXIST;
 	devlink_port->attrs_set = true;
 	attrs->flavour = flavour;
-	if (switch_id) {
+	if (attrs->switch_id.id_len) {
 		devlink_port->switch_port = true;
-		if (WARN_ON(switch_id_len > MAX_PHYS_ITEM_ID_LEN))
-			switch_id_len = MAX_PHYS_ITEM_ID_LEN;
-		memcpy(attrs->switch_id.id, switch_id, switch_id_len);
-		attrs->switch_id.id_len = switch_id_len;
+		if (WARN_ON(attrs->switch_id.id_len > MAX_PHYS_ITEM_ID_LEN))
+			attrs->switch_id.id_len = MAX_PHYS_ITEM_ID_LEN;
 	} else {
 		devlink_port->switch_port = false;
 	}
@@ -7536,33 +7532,17 @@ static int __devlink_port_attrs_set(struct devlink_port *devlink_port,
  *	devlink_port_attrs_set - Set port attributes
  *
  *	@devlink_port: devlink port
- *	@flavour: flavour of the port
- *	@port_number: number of the port that is facing user, for example
- *	              the front panel port number
- *	@split: indicates if this is split port
- *	@split_subport_number: if the port is split, this is the number
- *	                       of subport.
- *	@switch_id: if the port is part of switch, this is buffer with ID,
- *	            otwerwise this is NULL
- *	@switch_id_len: length of the switch_id buffer
+ *	@attrs: devlink port attrs
  */
 void devlink_port_attrs_set(struct devlink_port *devlink_port,
-			    enum devlink_port_flavour flavour,
-			    u32 port_number, bool split,
-			    u32 split_subport_number,
-			    const unsigned char *switch_id,
-			    unsigned char switch_id_len)
+			    struct devlink_port_attrs *attrs)
 {
-	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
 
-	ret = __devlink_port_attrs_set(devlink_port, flavour,
-				       switch_id, switch_id_len);
+	devlink_port->attrs = *attrs;
+	ret = __devlink_port_attrs_set(devlink_port, attrs->flavour);
 	if (ret)
 		return;
-	attrs->split = split;
-	attrs->phys.port_number = port_number;
-	attrs->phys.split_subport_number = split_subport_number;
 }
 EXPORT_SYMBOL_GPL(devlink_port_attrs_set);
 
@@ -7571,20 +7551,14 @@ EXPORT_SYMBOL_GPL(devlink_port_attrs_set);
  *
  *	@devlink_port: devlink port
  *	@pf: associated PF for the devlink port instance
- *	@switch_id: if the port is part of switch, this is buffer with ID,
- *	            otherwise this is NULL
- *	@switch_id_len: length of the switch_id buffer
  */
-void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port,
-				   const unsigned char *switch_id,
-				   unsigned char switch_id_len, u16 pf)
+void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u16 pf)
 {
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
 
 	ret = __devlink_port_attrs_set(devlink_port,
-				       DEVLINK_PORT_FLAVOUR_PCI_PF,
-				       switch_id, switch_id_len);
+				       DEVLINK_PORT_FLAVOUR_PCI_PF);
 	if (ret)
 		return;
 
@@ -7598,21 +7572,15 @@ EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_pf_set);
  *	@devlink_port: devlink port
  *	@pf: associated PF for the devlink port instance
  *	@vf: associated VF of a PF for the devlink port instance
- *	@switch_id: if the port is part of switch, this is buffer with ID,
- *	            otherwise this is NULL
- *	@switch_id_len: length of the switch_id buffer
  */
 void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port,
-				   const unsigned char *switch_id,
-				   unsigned char switch_id_len,
 				   u16 pf, u16 vf)
 {
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
 
 	ret = __devlink_port_attrs_set(devlink_port,
-				       DEVLINK_PORT_FLAVOUR_PCI_VF,
-				       switch_id, switch_id_len);
+				       DEVLINK_PORT_FLAVOUR_PCI_VF);
 	if (ret)
 		return;
 	attrs->pci_vf.pf = pf;
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 076908fdd29b..e055efff390b 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -261,10 +261,15 @@ static int dsa_port_setup(struct dsa_port *dp)
 	struct devlink_port *dlp = &dp->devlink_port;
 	bool dsa_port_link_registered = false;
 	bool devlink_port_registered = false;
+	struct devlink_port_attrs attrs = {};
 	struct devlink *dl = ds->devlink;
 	bool dsa_port_enabled = false;
 	int err = 0;
 
+	attrs.phys.port_number = dp->index;
+	memcpy(attrs.switch_id.id, id, len);
+	attrs.switch_id.id_len = len;
+
 	if (dp->setup)
 		return 0;
 
@@ -274,8 +279,8 @@ static int dsa_port_setup(struct dsa_port *dp)
 		break;
 	case DSA_PORT_TYPE_CPU:
 		memset(dlp, 0, sizeof(*dlp));
-		devlink_port_attrs_set(dlp, DEVLINK_PORT_FLAVOUR_CPU,
-				       dp->index, false, 0, id, len);
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_CPU;
+		devlink_port_attrs_set(dlp, &attrs);
 		err = devlink_port_register(dl, dlp, dp->index);
 		if (err)
 			break;
@@ -294,8 +299,8 @@ static int dsa_port_setup(struct dsa_port *dp)
 		break;
 	case DSA_PORT_TYPE_DSA:
 		memset(dlp, 0, sizeof(*dlp));
-		devlink_port_attrs_set(dlp, DEVLINK_PORT_FLAVOUR_DSA,
-				       dp->index, false, 0, id, len);
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_DSA;
+		devlink_port_attrs_set(dlp, &attrs);
 		err = devlink_port_register(dl, dlp, dp->index);
 		if (err)
 			break;
@@ -314,8 +319,8 @@ static int dsa_port_setup(struct dsa_port *dp)
 		break;
 	case DSA_PORT_TYPE_USER:
 		memset(dlp, 0, sizeof(*dlp));
-		devlink_port_attrs_set(dlp, DEVLINK_PORT_FLAVOUR_PHYSICAL,
-				       dp->index, false, 0, id, len);
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+		devlink_port_attrs_set(dlp, &attrs);
 		err = devlink_port_register(dl, dlp, dp->index);
 		if (err)
 			break;
-- 
2.26.2

