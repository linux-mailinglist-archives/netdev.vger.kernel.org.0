Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CD41D9807
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgESNlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:41:15 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:35527 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728633AbgESNlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:41:14 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 2AFF8581897;
        Tue, 19 May 2020 09:41:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 19 May 2020 09:41:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=dqlWJI4T+sFokDDE/lNlmxzM1yPp3AR5Wws/BGOGKBM=; b=RsgCx2Io
        cFJu9nYE5zdFCmBeysPk0b4vzmXCcUDGeyupZKsWIZNZC+4F2BOiHhS8Nr3fcdBU
        PfbnVoBzPtKb+CHcBOWS18mOiuMzy00msP+0p1lSEs/4DcRpHiq7VRbR5Xz4ScE5
        m8Ow2ZPycYUSO/gZool82EO1E3/lZJImLd2hQ8ljN8gUziUzhxtbXq1IgRm8lNev
        uuA6xrr2z8YsdTa5GBEFkh8ols4eVT14lDGJQy7jiKGfFhgKcwsLpJQ4wUeejvgL
        zqfndCkvYEyK++mJGED22p9+6x0knqD07j1lSrPNAh9RppFErMc6peIqrTmVduR/
        hXlgcDgssrMNpg==
X-ME-Sender: <xms:-OHDXv5wqodxmrCU8uNRmnro_8RuhScY6VsLNqFEDybLpY58wnsZNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtjedgieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:-OHDXk5sNJvMzqj47uSs9JH-mRKs7t27GlgNqHkTiJrtzngq1o0CBQ>
    <xmx:-OHDXmeJ6KGLpHUHsHKxm_DowSXnwA_r8xoOUvcAU8RA3zHINvuXfg>
    <xmx:-OHDXgJ3TB3zHkqo4ukh6-Xm5eTs9KqdFVPu8p2cEGd4DjXnFIN9wA>
    <xmx:-OHDXlzbbtmjmtaFYrfAq3NgCwCMebkdKkTONMMRHcqTb4rI6uMMUg>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 565E2328006A;
        Tue, 19 May 2020 09:41:09 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        michael.chan@broadcom.com, jeffrey.t.kirsher@intel.com,
        saeedm@mellanox.com, leon@kernel.org, snelson@pensando.io,
        drivers@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/3] devlink: Add a new devlink port width attribute and pass to netlink
Date:   Tue, 19 May 2020 16:40:31 +0300
Message-Id: <20200519134032.1006765-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200519134032.1006765-1-idosch@idosch.org>
References: <20200519134032.1006765-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

Add a new devlink port attribute that indicates the port's width.
Drivers are expected to set it via devlink_port_attrs_set(), before
registering the port.

The attribute is not passed to user space in case the width is invalid
(0).

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c    | 2 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c         | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c     | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c           | 2 +-
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c     | 2 +-
 drivers/net/ethernet/pensando/ionic/ionic_devlink.c  | 2 +-
 drivers/net/netdevsim/dev.c                          | 2 +-
 include/net/devlink.h                                | 2 ++
 include/uapi/linux/devlink.h                         | 2 ++
 net/core/devlink.c                                   | 7 +++++++
 net/dsa/dsa2.c                                       | 6 +++---
 12 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index a812beb46325..25d577433dbf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -714,7 +714,7 @@ int bnxt_dl_register(struct bnxt *bp)
 		return 0;
 
 	devlink_port_attrs_set(&bp->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
-			       bp->pf.port_id, false, 0, bp->dsn,
+			       bp->pf.port_id, false, 0, 0, bp->dsn,
 			       sizeof(bp->dsn));
 	rc = devlink_port_register(dl, &bp->dl_port, bp->pf.port_id);
 	if (rc) {
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index c6833944b90a..a46ebeb249b8 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -297,7 +297,7 @@ int ice_devlink_create_port(struct ice_pf *pf)
 	}
 
 	devlink_port_attrs_set(&pf->devlink_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
-			       pf->hw.pf_id, false, 0, NULL, 0);
+			       pf->hw.pf_id, false, 0, 0, NULL, 0);
 	err = devlink_port_register(devlink, &pf->devlink_port, pf->hw.pf_id);
 	if (err) {
 		dev_err(dev, "devlink_port_register failed: %d\n", err);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
index f8b2de4b04be..365f2df6d851 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
@@ -11,12 +11,12 @@ int mlx5e_devlink_port_register(struct mlx5e_priv *priv)
 		devlink_port_attrs_set(&priv->dl_port,
 				       DEVLINK_PORT_FLAVOUR_PHYSICAL,
 				       PCI_FUNC(priv->mdev->pdev->devfn),
-				       false, 0,
+				       false, 0, 0,
 				       NULL, 0);
 	else
 		devlink_port_attrs_set(&priv->dl_port,
 				       DEVLINK_PORT_FLAVOUR_VIRTUAL,
-				       0, false, 0, NULL, 0);
+				       0, false, 0, 0, NULL, 0);
 
 	return devlink_port_register(devlink, &priv->dl_port, 1);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 52351c105627..cf54c88a90d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -2050,7 +2050,7 @@ static int register_devlink_port(struct mlx5_core_dev *dev,
 	if (rep->vport == MLX5_VPORT_UPLINK)
 		devlink_port_attrs_set(&rpriv->dl_port,
 				       DEVLINK_PORT_FLAVOUR_PHYSICAL,
-				       pfnum, false, 0,
+				       pfnum, false, 0, 0,
 				       &ppid.id[0], ppid.id_len);
 	else if (rep->vport == MLX5_VPORT_PF)
 		devlink_port_attrs_pci_pf_set(&rpriv->dl_port,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 8f1ef90c7f5a..df011c1d0712 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2134,7 +2134,7 @@ static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 
 	mlxsw_core_port->local_port = local_port;
 	devlink_port_attrs_set(devlink_port, flavour, port_number,
-			       split, split_port_subnumber,
+			       split, split_port_subnumber, width,
 			       switch_id, switch_id_len);
 	err = devlink_port_register(devlink, devlink_port, local_port);
 	if (err)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index 07dbf4d72227..65ecd0bdc8be 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -368,7 +368,7 @@ int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port)
 	serial_len = nfp_cpp_serial(port->app->cpp, &serial);
 	devlink_port_attrs_set(&port->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
 			       eth_port.label_port, eth_port.is_split,
-			       eth_port.label_subport, serial, serial_len);
+			       eth_port.label_subport, 0, serial, serial_len);
 
 	devlink = priv_to_devlink(app->pf);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index 273c889faaad..a21a10307ecc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -82,7 +82,7 @@ int ionic_devlink_register(struct ionic *ionic)
 		return 0;
 
 	devlink_port_attrs_set(&ionic->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
-			       0, false, 0, NULL, 0);
+			       0, false, 0, 0, NULL, 0);
 	err = devlink_port_register(dl, &ionic->dl_port, 0);
 	if (err)
 		dev_err(ionic->dev, "devlink_port_register failed: %d\n", err);
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 68668a22b9dd..75549640d113 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -893,7 +893,7 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
 
 	devlink_port = &nsim_dev_port->devlink_port;
 	devlink_port_attrs_set(devlink_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
-			       port_index + 1, 0, 0,
+			       port_index + 1, 0, 0, 0,
 			       nsim_dev->switch_id.id,
 			       nsim_dev->switch_id.id_len);
 	err = devlink_port_register(priv_to_devlink(nsim_dev), devlink_port,
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8ffc1b5cd89b..de374d544671 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -68,6 +68,7 @@ struct devlink_port_attrs {
 	u8 set:1,
 	   split:1,
 	   switch_port:1;
+	u32 width;
 	enum devlink_port_flavour flavour;
 	struct netdev_phys_item_id switch_id;
 	union {
@@ -972,6 +973,7 @@ void devlink_port_attrs_set(struct devlink_port *devlink_port,
 			    enum devlink_port_flavour flavour,
 			    u32 port_number, bool split,
 			    u32 split_subport_number,
+			    u32 width,
 			    const unsigned char *switch_id,
 			    unsigned char switch_id_len);
 void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 1ae90e06c06d..69e914e000c4 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -442,6 +442,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_TRAP_POLICER_RATE,			/* u64 */
 	DEVLINK_ATTR_TRAP_POLICER_BURST,		/* u64 */
 
+	DEVLINK_ATTR_PORT_WIDTH,		/* u32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7b76e5fffc10..9887fba60a7a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -526,6 +526,10 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 
 	if (!attrs->set)
 		return 0;
+	if (attrs->width) {
+		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_WIDTH, attrs->width))
+			return -EMSGSIZE;
+	}
 	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_FLAVOUR, attrs->flavour))
 		return -EMSGSIZE;
 	switch (devlink_port->attrs.flavour) {
@@ -7408,6 +7412,7 @@ static int __devlink_port_attrs_set(struct devlink_port *devlink_port,
  *	@split: indicates if this is split port
  *	@split_subport_number: if the port is split, this is the number
  *	                       of subport.
+ *	@width: width of the port. 0 value is not passed to netlink.
  *	@switch_id: if the port is part of switch, this is buffer with ID,
  *	            otwerwise this is NULL
  *	@switch_id_len: length of the switch_id buffer
@@ -7416,6 +7421,7 @@ void devlink_port_attrs_set(struct devlink_port *devlink_port,
 			    enum devlink_port_flavour flavour,
 			    u32 port_number, bool split,
 			    u32 split_subport_number,
+			    u32 width,
 			    const unsigned char *switch_id,
 			    unsigned char switch_id_len)
 {
@@ -7427,6 +7433,7 @@ void devlink_port_attrs_set(struct devlink_port *devlink_port,
 	if (ret)
 		return;
 	attrs->split = split;
+	attrs->width = width;
 	attrs->phys.port_number = port_number;
 	attrs->phys.split_subport_number = split_subport_number;
 }
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 076908fdd29b..5d9322cb5bf3 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -275,7 +275,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 	case DSA_PORT_TYPE_CPU:
 		memset(dlp, 0, sizeof(*dlp));
 		devlink_port_attrs_set(dlp, DEVLINK_PORT_FLAVOUR_CPU,
-				       dp->index, false, 0, id, len);
+				       dp->index, false, 0, 0, id, len);
 		err = devlink_port_register(dl, dlp, dp->index);
 		if (err)
 			break;
@@ -295,7 +295,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 	case DSA_PORT_TYPE_DSA:
 		memset(dlp, 0, sizeof(*dlp));
 		devlink_port_attrs_set(dlp, DEVLINK_PORT_FLAVOUR_DSA,
-				       dp->index, false, 0, id, len);
+				       dp->index, false, 0, 0, id, len);
 		err = devlink_port_register(dl, dlp, dp->index);
 		if (err)
 			break;
@@ -315,7 +315,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 	case DSA_PORT_TYPE_USER:
 		memset(dlp, 0, sizeof(*dlp));
 		devlink_port_attrs_set(dlp, DEVLINK_PORT_FLAVOUR_PHYSICAL,
-				       dp->index, false, 0, id, len);
+				       dp->index, false, 0, 0, id, len);
 		err = devlink_port_register(dl, dlp, dp->index);
 		if (err)
 			break;
-- 
2.26.2

