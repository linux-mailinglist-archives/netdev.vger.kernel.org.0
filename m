Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9729F4571EC
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 16:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235398AbhKSPql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 10:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235876AbhKSPqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 10:46:40 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A462C061574
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 07:43:39 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so11282799pjc.4
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 07:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PieBrqdFGb34KqALGGCVjc4oJrXzZ5ulDToon098vNs=;
        b=h2dhjazRo9/Nykk1sZ8LkspW5qvW9YemD9Br2oX5nCD8Jg8qL7DybdYxyoE5SDhbGX
         koWM6Ap0amkIg2YoX1xd0T/+MrgdFE72RHRVwuaXhVbx9GcOlDZ97J4hCwDNuwFfs2YW
         6IIeZm4xqisn7l+zvus9dUDNUthDjPIy8bcFGHaJT4cBKOPf7DHW7vBJGKeeTcGyzJyq
         pK7jvK6sWufaNWCjY2hnka99YAC/pijrELhIIHjkKWRubCUMn9fhsRmHJIxrgNna2+bg
         +V/vGXwGOWd5wZ2CHMSUqOkF7vGxxqaAk5qzgDRvG/ZhErA8e1Q39a9S0BAXwjCOjbI7
         fcOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PieBrqdFGb34KqALGGCVjc4oJrXzZ5ulDToon098vNs=;
        b=7FOWTHOJt0SwKqdzW3jMSjjelB/9AQZ2rJw2IFOUNF7YplkY/nkVaBMFi6hlyhHkWv
         +eAFqjpKAL+VPtl+coKLA3bulb8SRX/ABP4VejlWffxyYungXTHoCtnkykORhP+98cGK
         WRu+hsvSx60CxTY+TIpWVXTwgwMtEXKU8gado/GdYHtBarctM8mn1NcNNdX1dT1HDbw1
         mgHQtm/bbRj1dMw5ydLoU3UL572DUK4UVay2Tq8z6aE8ViLpdfGXCImW566h8qdb36ku
         xGa9dIhfmZT77GZAECw6pV4s9W5E5IoOI+dytodP2Nqd8xIaWuyj6DLKfQ0mSWpp/xAr
         tkZQ==
X-Gm-Message-State: AOAM533U+g0maFnYCynICFmoDnyuSjd0FiUdb6mT0pkVnw2gQDPyABfr
        rMQuvMGqkG1bNVGOgsPC0Ks=
X-Google-Smtp-Source: ABdhPJwQTUoQEAyrenF6DHzE9qSnsDaBlgphSYJy9vgH2KNPq51xNNRRDTiuR8I8o/h//i4jHdeBxw==
X-Received: by 2002:a17:902:7005:b0:142:4452:25de with SMTP id y5-20020a170902700500b00142445225demr78126386plk.3.1637336618568;
        Fri, 19 Nov 2021 07:43:38 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:fc03:ed5a:3e05:8b5e])
        by smtp.gmail.com with ESMTPSA id n1sm68242pfj.193.2021.11.19.07.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 07:43:38 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/2] net: annotate accesses to dev->gso_max_segs
Date:   Fri, 19 Nov 2021 07:43:32 -0800
Message-Id: <20211119154332.4110795-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211119154332.4110795-1-eric.dumazet@gmail.com>
References: <20211119154332.4110795-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

dev->gso_max_segs is written under RTNL protection, or when the device is
not yet visible, but is read locklessly.

Add netif_set_gso_max_segs() helper.

Add the READ_ONCE()/WRITE_ONCE() pairs, and use netif_set_gso_max_segs()
where we can to better document what is going on.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/bonding/bond_main.c                      | 2 +-
 drivers/net/ethernet/freescale/fec_main.c            | 2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c           | 2 +-
 drivers/net/ethernet/marvell/mvneta.c                | 2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c      | 2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c  | 2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c    | 4 ++--
 drivers/net/ethernet/realtek/r8169_main.c            | 4 ++--
 drivers/net/ethernet/sfc/ef100_nic.c                 | 4 ++--
 drivers/net/ethernet/sfc/efx.c                       | 2 +-
 drivers/net/ethernet/sfc/falcon/efx.c                | 2 +-
 drivers/net/ipvlan/ipvlan_main.c                     | 4 ++--
 drivers/net/macvlan.c                                | 4 ++--
 drivers/net/veth.c                                   | 2 +-
 drivers/net/vxlan.c                                  | 2 +-
 include/linux/netdevice.h                            | 7 +++++++
 net/8021q/vlan.c                                     | 2 +-
 net/8021q/vlan_dev.c                                 | 2 +-
 net/bridge/br_if.c                                   | 2 +-
 net/core/dev.c                                       | 2 +-
 net/core/rtnetlink.c                                 | 4 ++--
 net/core/sock.c                                      | 3 ++-
 24 files changed, 37 insertions(+), 29 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index ff8da720a33a79fd357b32c480c4773e775f9b27..cf73eacdda9152802bc5e8306364951c591149e5 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1460,7 +1460,7 @@ static void bond_compute_features(struct bonding *bond)
 	bond_dev->hw_enc_features |= xfrm_features;
 #endif /* CONFIG_XFRM_OFFLOAD */
 	bond_dev->mpls_features = mpls_features;
-	bond_dev->gso_max_segs = gso_max_segs;
+	netif_set_gso_max_segs(bond_dev, gso_max_segs);
 	netif_set_gso_max_size(bond_dev, gso_max_size);
 
 	bond_dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index bc418b910999fc5821cf6917097435c9316745ed..f38e70692514e663795fd021aa35da68c33b8529 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3558,7 +3558,7 @@ static int fec_enet_init(struct net_device *ndev)
 		ndev->features |= NETIF_F_HW_VLAN_CTAG_RX;
 
 	if (fep->quirks & FEC_QUIRK_HAS_CSUM) {
-		ndev->gso_max_segs = FEC_MAX_TSO_SEGS;
+		netif_set_gso_max_segs(ndev, FEC_MAX_TSO_SEGS);
 
 		/* enable hw accelerator */
 		ndev->features |= (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index bb14fa2241a36ef3653050e74265cc0bd94e5929..2e8bc1810dd655afd7440b1e0b88e214b58d0609 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -3197,7 +3197,7 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 	dev->hw_features = dev->features;
 
 	dev->priv_flags |= IFF_UNICAST_FLT;
-	dev->gso_max_segs = MV643XX_MAX_TSO_SEGS;
+	netif_set_gso_max_segs(dev, MV643XX_MAX_TSO_SEGS);
 
 	/* MTU range: 64 - 9500 */
 	dev->min_mtu = 64;
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 67a64417788000cdcf52ff6eae820693d9858421..cdb2148994a230095e49c4d72c0585eb53b0ea54 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5329,7 +5329,7 @@ static int mvneta_probe(struct platform_device *pdev)
 	dev->hw_features |= dev->features;
 	dev->vlan_features |= dev->features;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
-	dev->gso_max_segs = MVNETA_MAX_TSO_SEGS;
+	netif_set_gso_max_segs(dev, MVNETA_MAX_TSO_SEGS);
 
 	/* MTU range: 68 - 9676 */
 	dev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index df6c793f4b1b04eb1f812ce2a3a82a39cde0f68b..52b5a0263cb1111840458901305a4f84895ed087 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6851,7 +6851,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 		mvpp2_set_hw_csum(port, port->pool_long->id);
 
 	dev->vlan_features |= features;
-	dev->gso_max_segs = MVPP2_MAX_TSO_SEGS;
+	netif_set_gso_max_segs(dev, MVPP2_MAX_TSO_SEGS);
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
 	/* MTU range: 68 - 9704 */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 1e0d0c9c1dac3ae69ab74521015cf6b396a2607a..1333edf1c361c57bd5c97dce77bb7e9cd28d650b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2741,7 +2741,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	netdev->hw_features |= NETIF_F_LOOPBACK | NETIF_F_RXALL;
 
-	netdev->gso_max_segs = OTX2_MAX_GSO_SEGS;
+	netif_set_gso_max_segs(netdev, OTX2_MAX_GSO_SEGS);
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
 
 	netdev->netdev_ops = &otx2_netdev_ops;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 78944ad3492ff0a6cc698883826fab1e3488686f..254bebffe8c1e914ddc1140f1c219e97768c5970 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -663,7 +663,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	netdev->hw_features |= NETIF_F_NTUPLE;
 	netdev->hw_features |= NETIF_F_RXALL;
 
-	netdev->gso_max_segs = OTX2_MAX_GSO_SEGS;
+	netif_set_gso_max_segs(netdev, OTX2_MAX_GSO_SEGS);
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
 
 	netdev->netdev_ops = &otx2vf_netdev_ops;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 850bfdf83d0a435f5e5b05664f43982382a6f93a..6e38da4ad554c31e401ef23dd83f4bdb60bf7068 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -4097,7 +4097,7 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	netdev->min_mtu = ETH_MIN_MTU;
 	netdev->max_mtu = nn->max_mtu;
 
-	netdev->gso_max_segs = NFP_NET_LSO_MAX_SEGS;
+	netif_set_gso_max_segs(netdev, NFP_NET_LSO_MAX_SEGS);
 
 	netif_carrier_off(netdev);
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 927ddbdf650b05b6334ccfa366feab94c59ab664..181ac8e789a3fd3945245116e28d0fbb577d63d6 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -287,7 +287,7 @@ nfp_repr_transfer_features(struct net_device *netdev, struct net_device *lower)
 		return;
 
 	netif_set_gso_max_size(netdev, lower->gso_max_size);
-	netdev->gso_max_segs = lower->gso_max_segs;
+	netif_set_gso_max_segs(netdev, lower->gso_max_segs);
 
 	netdev_update_features(netdev);
 }
@@ -381,7 +381,7 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 
 	/* Advertise but disable TSO by default. */
 	netdev->features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
-	netdev->gso_max_segs = NFP_NET_LSO_MAX_SEGS;
+	netif_set_gso_max_segs(netdev, NFP_NET_LSO_MAX_SEGS);
 
 	netdev->priv_flags |= IFF_NO_QUEUE | IFF_DISABLE_NETPOLL;
 	netdev->features |= NETIF_F_LLTX;
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 5c40af2b0f818e5e89ad9b5304aa830c65cb014d..aeea80dbc3db104693e5ea7ab8224d070dc5ee66 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5389,11 +5389,11 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rtl_chip_supports_csum_v2(tp)) {
 		dev->hw_features |= NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6;
 		netif_set_gso_max_size(dev, RTL_GSO_MAX_SIZE_V2);
-		dev->gso_max_segs = RTL_GSO_MAX_SEGS_V2;
+		netif_set_gso_max_segs(dev, RTL_GSO_MAX_SEGS_V2);
 	} else {
 		dev->hw_features |= NETIF_F_SG | NETIF_F_TSO;
 		netif_set_gso_max_size(dev, RTL_GSO_MAX_SIZE_V1);
-		dev->gso_max_segs = RTL_GSO_MAX_SEGS_V1;
+		netif_set_gso_max_segs(dev, RTL_GSO_MAX_SEGS_V1);
 	}
 
 	dev->hw_features |= NETIF_F_RXALL;
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index d9015a77a6b8f0862519774a974592dbaea7b150..5a6fed33a1d7ae778b2a475ed0c406499d9f123e 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -997,7 +997,7 @@ static int ef100_process_design_param(struct efx_nic *efx,
 		return 0;
 	case ESE_EF100_DP_GZ_TSO_MAX_PAYLOAD_NUM_SEGS:
 		nic_data->tso_max_payload_num_segs = min_t(u64, reader->value, 0xffff);
-		efx->net_dev->gso_max_segs = nic_data->tso_max_payload_num_segs;
+		netif_set_gso_max_segs(efx->net_dev, nic_data->tso_max_payload_num_segs);
 		return 0;
 	case ESE_EF100_DP_GZ_TSO_MAX_NUM_FRAMES:
 		nic_data->tso_max_frames = min_t(u64, reader->value, 0xffff);
@@ -1122,7 +1122,7 @@ static int ef100_probe_main(struct efx_nic *efx)
 	nic_data->tso_max_frames = ESE_EF100_DP_GZ_TSO_MAX_NUM_FRAMES_DEFAULT;
 	nic_data->tso_max_payload_num_segs = ESE_EF100_DP_GZ_TSO_MAX_PAYLOAD_NUM_SEGS_DEFAULT;
 	nic_data->tso_max_payload_len = ESE_EF100_DP_GZ_TSO_MAX_PAYLOAD_LEN_DEFAULT;
-	net_dev->gso_max_segs = ESE_EF100_DP_GZ_TSO_MAX_HDR_NUM_SEGS_DEFAULT;
+	netif_set_gso_max_segs(net_dev, ESE_EF100_DP_GZ_TSO_MAX_HDR_NUM_SEGS_DEFAULT);
 	/* Read design parameters */
 	rc = ef100_check_design_params(efx);
 	if (rc) {
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 6960a2fe2b53d8be996c1b25da06126540b7bd31..a8c252e2b2521967d067b525c68891f002481ce8 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -709,7 +709,7 @@ static int efx_register_netdev(struct efx_nic *efx)
 	if (efx_nic_rev(efx) >= EFX_REV_HUNT_A0)
 		net_dev->priv_flags |= IFF_UNICAST_FLT;
 	net_dev->ethtool_ops = &efx_ethtool_ops;
-	net_dev->gso_max_segs = EFX_TSO_MAX_SEGS;
+	netif_set_gso_max_segs(net_dev, EFX_TSO_MAX_SEGS);
 	net_dev->min_mtu = EFX_MIN_MTU;
 	net_dev->max_mtu = EFX_MAX_MTU;
 
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 314c9c69eb0e940de66b80657606bb19fd8737d7..60c595ef75896cc7c7b3e9b0751cc08e1a8d2b7d 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2267,7 +2267,7 @@ static int ef4_register_netdev(struct ef4_nic *efx)
 	net_dev->irq = efx->pci_dev->irq;
 	net_dev->netdev_ops = &ef4_netdev_ops;
 	net_dev->ethtool_ops = &ef4_ethtool_ops;
-	net_dev->gso_max_segs = EF4_TSO_MAX_SEGS;
+	netif_set_gso_max_segs(net_dev, EF4_TSO_MAX_SEGS);
 	net_dev->min_mtu = EF4_MIN_MTU;
 	net_dev->max_mtu = EF4_MAX_MTU;
 
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 0ba63eccefa5ac31fb4f8ee7f5f8a62f750ad4df..20da0b2bd246cc3000d44d126c87cfc6fa5ad99f 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -141,7 +141,7 @@ static int ipvlan_init(struct net_device *dev)
 	dev->vlan_features |= IPVLAN_ALWAYS_ON_OFLOADS;
 	dev->hw_enc_features |= dev->features;
 	netif_set_gso_max_size(dev, phy_dev->gso_max_size);
-	dev->gso_max_segs = phy_dev->gso_max_segs;
+	netif_set_gso_max_segs(dev, phy_dev->gso_max_segs);
 	dev->hard_header_len = phy_dev->hard_header_len;
 
 	netdev_lockdep_set_classes(dev);
@@ -764,7 +764,7 @@ static int ipvlan_device_event(struct notifier_block *unused,
 	case NETDEV_FEAT_CHANGE:
 		list_for_each_entry(ipvlan, &port->ipvlans, pnode) {
 			netif_set_gso_max_size(ipvlan->dev, dev->gso_max_size);
-			ipvlan->dev->gso_max_segs = dev->gso_max_segs;
+			netif_set_gso_max_segs(ipvlan->dev, dev->gso_max_segs);
 			netdev_update_features(ipvlan->dev);
 		}
 		break;
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 506e9559df80d5e405e7e186aab08f5f02499f0a..75b453acd77863bf376bcf6329f75f62deccefd4 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -901,7 +901,7 @@ static int macvlan_init(struct net_device *dev)
 	dev->vlan_features	|= ALWAYS_ON_OFFLOADS;
 	dev->hw_enc_features    |= dev->features;
 	netif_set_gso_max_size(dev, lowerdev->gso_max_size);
-	dev->gso_max_segs	= lowerdev->gso_max_segs;
+	netif_set_gso_max_segs(dev, lowerdev->gso_max_segs);
 	dev->hard_header_len	= lowerdev->hard_header_len;
 	macvlan_set_lockdep_class(dev);
 
@@ -1749,7 +1749,7 @@ static int macvlan_device_event(struct notifier_block *unused,
 	case NETDEV_FEAT_CHANGE:
 		list_for_each_entry(vlan, &port->vlans, list) {
 			netif_set_gso_max_size(vlan->dev, dev->gso_max_size);
-			vlan->dev->gso_max_segs = dev->gso_max_segs;
+			netif_set_gso_max_segs(vlan->dev, dev->gso_max_segs);
 			netdev_update_features(vlan->dev);
 		}
 		break;
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index f2f66fb293fd474bfc5b54594b33f925228b8e47..5ca0a899101d400008d94c2841f408b3714faf27 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1690,7 +1690,7 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
 		peer->ifindex = ifmp->ifi_index;
 
 	netif_set_gso_max_size(peer, dev->gso_max_size);
-	peer->gso_max_segs = dev->gso_max_segs;
+	netif_set_gso_max_segs(peer, dev->gso_max_segs);
 
 	err = register_netdevice(peer);
 	put_net(net);
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index df4f1712be9529aba9372515dc27beac93fd83b4..82bd794fceb371252ace510857e78689d34725c6 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3812,7 +3812,7 @@ static void vxlan_config_apply(struct net_device *dev,
 		dst->remote_ifindex = conf->remote_ifindex;
 
 		netif_set_gso_max_size(dev, lowerdev->gso_max_size);
-		dev->gso_max_segs = lowerdev->gso_max_segs;
+		netif_set_gso_max_segs(dev, lowerdev->gso_max_segs);
 
 		needed_headroom = lowerdev->hard_header_len;
 		needed_headroom += lowerdev->needed_headroom;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 19011318d3cd5e40343761a5699ef64623134688..c50cca84626ab5d84d00cf37486f02561ffdf367 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4734,6 +4734,13 @@ static inline void netif_set_gso_max_size(struct net_device *dev,
 	WRITE_ONCE(dev->gso_max_size, size);
 }
 
+static inline void netif_set_gso_max_segs(struct net_device *dev,
+					  unsigned int segs)
+{
+	/* dev->gso_max_segs is read locklessly from sk_setup_caps() */
+	WRITE_ONCE(dev->gso_max_segs, segs);
+}
+
 static inline void skb_gso_error_unwind(struct sk_buff *skb, __be16 protocol,
 					int pulled_hlen, u16 mac_offset,
 					int mac_len)
diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 34c0ffa81e5f163a620a48121baeb7b68bc3721a..0c00200c9cb2d88eedd03033b2d838610301c6ba 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -323,7 +323,7 @@ static void vlan_transfer_features(struct net_device *dev,
 	struct vlan_dev_priv *vlan = vlan_dev_priv(vlandev);
 
 	netif_set_gso_max_size(vlandev, dev->gso_max_size);
-	vlandev->gso_max_segs = dev->gso_max_segs;
+	netif_set_gso_max_segs(vlandev, dev->gso_max_segs);
 
 	if (vlan_hw_offload_capable(dev->features, vlan->vlan_proto))
 		vlandev->hard_header_len = dev->hard_header_len;
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 208f6845f6dd59f1f67e202e5401370d020cba2d..e9499a7c19fe00b3fd61b97a3066a47139f391ad 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -574,7 +574,7 @@ static int vlan_dev_init(struct net_device *dev)
 
 	dev->features |= dev->hw_features | NETIF_F_LLTX;
 	netif_set_gso_max_size(dev, real_dev->gso_max_size);
-	dev->gso_max_segs = real_dev->gso_max_segs;
+	netif_set_gso_max_segs(dev, real_dev->gso_max_segs);
 	if (dev->features & NETIF_F_VLAN_FEATURES)
 		netdev_warn(real_dev, "VLAN features are set incorrectly.  Q-in-Q configurations may not work correctly.\n");
 
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index d3e1c2276551c27bf9f0f19121cb6ef7b6869b0a..3915832a03c25e22ae2215ee93dceb0f8e5b5cc4 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -526,7 +526,7 @@ static void br_set_gso_limits(struct net_bridge *br)
 		gso_max_segs = min(gso_max_segs, p->dev->gso_max_segs);
 	}
 	netif_set_gso_max_size(br->dev, gso_max_size);
-	br->dev->gso_max_segs = gso_max_segs;
+	netif_set_gso_max_segs(br->dev, gso_max_segs);
 }
 
 /*
diff --git a/net/core/dev.c b/net/core/dev.c
index 92c9258cbf28556e68f9112343f5ebc98b2c163b..88f58d3669a1befa282ad096a5823ba9869c560e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3395,7 +3395,7 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 {
 	u16 gso_segs = skb_shinfo(skb)->gso_segs;
 
-	if (gso_segs > dev->gso_max_segs)
+	if (gso_segs > READ_ONCE(dev->gso_max_segs))
 		return features & ~NETIF_F_GSO_MASK;
 
 	if (!skb_shinfo(skb)->gso_type) {
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 2af8aeeadadf0acb2fa9f8febfa96c11b94e3a8c..fd030e02f16d119b83177312d10df3372f02b758 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2768,7 +2768,7 @@ static int do_setlink(const struct sk_buff *skb,
 		}
 
 		if (dev->gso_max_segs ^ max_segs) {
-			dev->gso_max_segs = max_segs;
+			netif_set_gso_max_segs(dev, max_segs);
 			status |= DO_SETLINK_MODIFIED;
 		}
 	}
@@ -3222,7 +3222,7 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 	if (tb[IFLA_GSO_MAX_SIZE])
 		netif_set_gso_max_size(dev, nla_get_u32(tb[IFLA_GSO_MAX_SIZE]));
 	if (tb[IFLA_GSO_MAX_SEGS])
-		dev->gso_max_segs = nla_get_u32(tb[IFLA_GSO_MAX_SEGS]);
+		netif_set_gso_max_segs(dev, nla_get_u32(tb[IFLA_GSO_MAX_SEGS]));
 
 	return dev;
 }
diff --git a/net/core/sock.c b/net/core/sock.c
index 4418e2a07c3412535413b94f11480ff6da7f3df3..31a2b79c9b3809fa7ac53ebd17bd253e1a7d6129 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2259,7 +2259,8 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_size() */
 			sk->sk_gso_max_size = READ_ONCE(dst->dev->gso_max_size);
-			max_segs = max_t(u32, dst->dev->gso_max_segs, 1);
+			/* pairs with the WRITE_ONCE() in netif_set_gso_max_segs() */
+			max_segs = max_t(u32, READ_ONCE(dst->dev->gso_max_segs), 1);
 		}
 	}
 	sk->sk_gso_max_segs = max_segs;
-- 
2.34.0.rc2.393.gf8c9666880-goog

