Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0120FCE24
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfKNSvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:51:35 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43764 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfKNSvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:51:35 -0500
Received: by mail-lj1-f196.google.com with SMTP id y23so7806684ljh.10
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mwiJb9ukuAK15xGqUzxOiik7ccuJILYjvZ5ei9tRX9w=;
        b=wObQzEDbW6CAVmupk8FK9M1som8qxbqMF/29jAmdYTrtAtW3HgZeJodaErxKEnswQO
         uwFCReb+pbl08B/ct/HP+dzymVT+BPV0vUIslBZfaxJUzNVLFDNaLPaIVGGqeS1DcBpy
         rSRPflEyBL0AASRReTSa0do0UHFvN97oCxfedQApAcfis6d85wyMi2aDIRrilswcceuO
         HojH5eT2dN0v4Xd+pp+13qG1Wz4QSnw0AqJa9jXQH8jkQm/rgestC31RKmacUWOGq16F
         tYBPDXmwtRi2xiOyHrjpou0h5o6w53xu3FDU7JjjpzAeax5n2ut/9l8jAXhUd39yQbEJ
         ajLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=mwiJb9ukuAK15xGqUzxOiik7ccuJILYjvZ5ei9tRX9w=;
        b=D9Q7L1YppPtivbsyCrz5cq3X2nMiqPkiqWer/8C60+U+3JsO1WowLzu8oqGNdF+/tI
         HPh/AHxEoHh6Lcg+rgjt7CjqHyuJbXvtJxNf4YE+S/uNWZMEqgp8R76sFetr5d3ZY9Mj
         8h+bw8EsC1MVtOMyzBYyWHf6xYln4U5O1sQa0EWLf6SMGJBV0XErya+M+1ye5S/zLiCW
         9gCpmfCuFYUsE7p7j2ionhwGuCCAuRze0JIAHKZ4RTALJF+wj3vyZP63dpcuAvjXvqrB
         SdSxrRY9zHAbBK3N6ZM2++r9nfquHeFpDkmtI3Z/6mjFf9uRMjXG7XfIDnCF4yfs/EUL
         e6JA==
X-Gm-Message-State: APjAAAWJp+5N6C3BfHNZc7ySQDVaMfCa15xM3yTZZFquGrX4bqJtC+1c
        9+STf5O/Obde0L6AOUDoG6Hj1Q==
X-Google-Smtp-Source: APXvYqynkqfZDsNG9qqA2zJvQCOchnb/fioVhAHufa6iL/WAA9HzX0ocPfM8tK2iicAbQAl0vjPV0w==
X-Received: by 2002:a2e:8613:: with SMTP id a19mr7609939lji.138.1573757491369;
        Thu, 14 Nov 2019 10:51:31 -0800 (PST)
Received: from khorivan (57-201-94-178.pool.ukrtel.net. [178.94.201.57])
        by smtp.gmail.com with ESMTPSA id 3sm2911696lfq.55.2019.11.14.10.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 10:51:29 -0800 (PST)
Date:   Thu, 14 Nov 2019 20:51:26 +0200
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Po Liu <po.liu@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: Re: [v3,net-next, 1/2] enetc: Configure the Time-Aware Scheduler via
 tc-taprio offload
Message-ID: <20191114185125.GA2261@khorivan>
Mail-Followup-To: Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
References: <20191112082823.28998-2-Po.Liu@nxp.com>
 <20191114045833.18064-1-Po.Liu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191114045833.18064-1-Po.Liu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 05:12:30AM +0000, Po Liu wrote:
>ENETC supports in hardware for time-based egress shaping according
>to IEEE 802.1Qbv. This patch implement the Qbv enablement by the
>hardware offload method qdisc tc-taprio method.
>Also update cbdr writeback to up level since control bd ring may
>writeback data to control bd ring.
>
>Signed-off-by: Po Liu <Po.Liu@nxp.com>
>Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
>---
>changes:
>v2:
>- introduce a local define CONFIG_FSL_ENETC_QOS to fix the various
>  configurations will result in link errors.
>  Since the CONFIG_NET_SCH_TAPRIO depends on many Qos configs. Not
>  to use it directly in driver. Add it to CONFIG_FSL_ENETC_QOS depends
>  on list, so only CONFIG_NET_SCH_TAPRIO enabled, user can enable this
>  tsn feature, or else, return not support.
>v3:
>- fix the compiling vf module failure issue:
>  ERROR: "enetc_sched_speed_set" [drivers/net/ethernet/freescale/enetc/fsl-enetc-vf.ko] undefined!
>  ERROR: "enetc_setup_tc_taprio" [drivers/net/ethernet/freescale/enetc/fsl-enetc-vf.ko] undefined!
>- remove defines not used in this patch
>- fix hardware endian issue
>- make the qbv set code more rubust with some error condition may occur.
>
> drivers/net/ethernet/freescale/enetc/Kconfig  |  10 ++
> drivers/net/ethernet/freescale/enetc/Makefile |   2 +
> drivers/net/ethernet/freescale/enetc/enetc.c  |  19 ++-
> drivers/net/ethernet/freescale/enetc/enetc.h  |   7 +
> .../net/ethernet/freescale/enetc/enetc_cbdr.c |   5 +-
> .../net/ethernet/freescale/enetc/enetc_hw.h   |  84 ++++++++---
> .../net/ethernet/freescale/enetc/enetc_qos.c  | 134 ++++++++++++++++++
> 7 files changed, 239 insertions(+), 22 deletions(-)
> create mode 100644 drivers/net/ethernet/freescale/enetc/enetc_qos.c
>
>diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
>index c219587bd334..491659fe3e35 100644
>--- a/drivers/net/ethernet/freescale/enetc/Kconfig
>+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
>@@ -50,3 +50,13 @@ config FSL_ENETC_HW_TIMESTAMPING
> 	  allocation has not been supported and it is too expensive to use
> 	  extended RX BDs if timestamping is not used, this option enables
> 	  extended RX BDs in order to support hardware timestamping.
>+
>+config FSL_ENETC_QOS
>+	bool "ENETC hardware Time-sensitive Network support"
>+	depends on (FSL_ENETC || FSL_ENETC_VF) && NET_SCH_TAPRIO
>+	help
>+	  There are Time-Sensitive Network(TSN) capabilities(802.1Qbv/802.1Qci
>+	  /802.1Qbu etc.) supported by ENETC. These TSN capabilities can be set
>+	  enable/disable from user space via Qos commands(tc). In the kernel
>+	  side, it can be loaded by Qos driver. Currently, it is only support
>+	  taprio(802.1Qbv).
>diff --git a/drivers/net/ethernet/freescale/enetc/Makefile b/drivers/net/ethernet/freescale/enetc/Makefile
>index d200c27c3bf6..d0db33e5b6b7 100644
>--- a/drivers/net/ethernet/freescale/enetc/Makefile
>+++ b/drivers/net/ethernet/freescale/enetc/Makefile
>@@ -5,9 +5,11 @@ common-objs := enetc.o enetc_cbdr.o enetc_ethtool.o
> obj-$(CONFIG_FSL_ENETC) += fsl-enetc.o
> fsl-enetc-y := enetc_pf.o enetc_mdio.o $(common-objs)
> fsl-enetc-$(CONFIG_PCI_IOV) += enetc_msg.o
>+fsl-enetc-$(CONFIG_FSL_ENETC_QOS) += enetc_qos.o
>
> obj-$(CONFIG_FSL_ENETC_VF) += fsl-enetc-vf.o
> fsl-enetc-vf-y := enetc_vf.o $(common-objs)
>+fsl-enetc-vf-$(CONFIG_FSL_ENETC_QOS) += enetc_qos.o
>
> obj-$(CONFIG_FSL_ENETC_MDIO) += fsl-enetc-mdio.o
> fsl-enetc-mdio-y := enetc_pci_mdio.o enetc_mdio.o
>diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
>index 3e8f9819f08c..d58dbc2c4270 100644
>--- a/drivers/net/ethernet/freescale/enetc/enetc.c
>+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
>@@ -1427,8 +1427,7 @@ int enetc_close(struct net_device *ndev)
> 	return 0;
> }
>
>-int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
>-		   void *type_data)
>+int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
> {
> 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
> 	struct tc_mqprio_qopt *mqprio = type_data;
>@@ -1436,9 +1435,6 @@ int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
> 	u8 num_tc;
> 	int i;
>
>-	if (type != TC_SETUP_QDISC_MQPRIO)
>-		return -EOPNOTSUPP;
>-
> 	mqprio->hw = TC_MQPRIO_HW_OFFLOAD_TCS;
> 	num_tc = mqprio->num_tc;
>
>@@ -1483,6 +1479,19 @@ int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
> 	return 0;
> }
>
>+int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
>+		   void *type_data)
>+{
>+	switch (type) {
>+	case TC_SETUP_QDISC_MQPRIO:
>+		return enetc_setup_tc_mqprio(ndev, type_data);
>+	case TC_SETUP_QDISC_TAPRIO:
>+		return enetc_setup_tc_taprio(ndev, type_data);
>+	default:
>+		return -EOPNOTSUPP;
>+	}
>+}
>+
> struct net_device_stats *enetc_get_stats(struct net_device *ndev)
> {
> 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
>diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
>index 541b4e2073fe..8ca2f97050c8 100644
>--- a/drivers/net/ethernet/freescale/enetc/enetc.h
>+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
>@@ -244,3 +244,10 @@ int enetc_set_fs_entry(struct enetc_si *si, struct enetc_cmd_rfse *rfse,
> void enetc_set_rss_key(struct enetc_hw *hw, const u8 *bytes);
> int enetc_get_rss_table(struct enetc_si *si, u32 *table, int count);
> int enetc_set_rss_table(struct enetc_si *si, const u32 *table, int count);
>+int enetc_send_cmd(struct enetc_si *si, struct enetc_cbd *cbd);
>+
>+#ifdef CONFIG_FSL_ENETC_QOS
>+int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data);
>+#else
>+#define enetc_setup_tc_taprio(ndev, type_data) -EOPNOTSUPP
>+#endif
>diff --git a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
>index de466b71bf8f..201cbc362e33 100644
>--- a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
>+++ b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
>@@ -32,7 +32,7 @@ static int enetc_cbd_unused(struct enetc_cbdr *r)
> 		r->bd_count;
> }
>
>-static int enetc_send_cmd(struct enetc_si *si, struct enetc_cbd *cbd)
>+int enetc_send_cmd(struct enetc_si *si, struct enetc_cbd *cbd)
> {
> 	struct enetc_cbdr *ring = &si->cbd_ring;
> 	int timeout = ENETC_CBDR_TIMEOUT;
>@@ -66,6 +66,9 @@ static int enetc_send_cmd(struct enetc_si *si, struct enetc_cbd *cbd)
> 	if (!timeout)
> 		return -EBUSY;
>
>+	/* CBD may writeback data, feedback up level */
>+	*cbd = *dest_cbd;
>+
> 	enetc_clean_cbdr(si);
>
> 	return 0;
>diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
>index 88276299f447..df6b35dc3534 100644
>--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
>+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
>@@ -18,6 +18,7 @@
> #define ENETC_SICTR0	0x18
> #define ENETC_SICTR1	0x1c
> #define ENETC_SIPCAPR0	0x20
>+#define ENETC_SIPCAPR0_QBV	BIT(4)
> #define ENETC_SIPCAPR0_RSS	BIT(8)
> #define ENETC_SIPCAPR1	0x24
> #define ENETC_SITGTGR	0x30
>@@ -440,22 +441,6 @@ union enetc_rx_bd {
> #define EMETC_MAC_ADDR_FILT_RES	3 /* # of reserved entries at the beginning */
> #define ENETC_MAX_NUM_VFS	2
>
>-struct enetc_cbd {
>-	union {
>-		struct {
>-			__le32 addr[2];
>-			__le32 opt[4];
>-		};
>-		__le32 data[6];
>-	};
>-	__le16 index;
>-	__le16 length;
>-	u8 cmd;
>-	u8 cls;
>-	u8 _res;
>-	u8 status_flags;
>-};
>-
> #define ENETC_CBD_FLAGS_SF	BIT(7) /* short format */
> #define ENETC_CBD_STATUS_MASK	0xf
>
>@@ -554,3 +539,70 @@ static inline void enetc_set_bdr_prio(struct enetc_hw *hw, int bdr_idx,
> 	val |= ENETC_TBMR_SET_PRIO(prio);
> 	enetc_txbdr_wr(hw, bdr_idx, ENETC_TBMR, val);
> }
>+
>+enum bdcr_cmd_class {
>+	BDCR_CMD_UNSPEC = 0,
>+	BDCR_CMD_MAC_FILTER,
>+	BDCR_CMD_VLAN_FILTER,
>+	BDCR_CMD_RSS,
>+	BDCR_CMD_RFS,
>+	BDCR_CMD_PORT_GCL,
>+	BDCR_CMD_RECV_CLASSIFIER,
>+	__BDCR_CMD_MAX_LEN,
>+	BDCR_CMD_MAX_LEN = __BDCR_CMD_MAX_LEN - 1,
>+};
>+
>+/* class 5, command 0 */
>+struct tgs_gcl_conf {
>+	u8	atc;	/* init gate value */
>+	u8	res[7];
>+	struct {
>+		u8	res1[4];
>+		__le16	acl_len;
>+		u8	res2[2];
>+	};
>+};
>+
>+/* gate control list entry */
>+struct gce {
>+	__le32	period;
>+	u8	gate;
>+	u8	res[3];
>+};
>+
>+/* tgs_gcl_conf address point to this data space */
>+struct tgs_gcl_data {
>+	__le32		btl;
>+	__le32		bth;
>+	__le32		ct;
>+	__le32		cte;
>+	struct gce	entry[0];
>+};
>+
>+struct enetc_cbd {
>+	union{
>+		struct {
>+			__le32	addr[2];
>+			union {
>+				__le32	opt[4];
>+				struct tgs_gcl_conf	gcl_conf;
>+			};
>+		};	/* Long format */
>+		__le32 data[6];
>+	};
>+	__le16 index;
>+	__le16 length;
>+	u8 cmd;
>+	u8 cls;
>+	u8 _res;
>+	u8 status_flags;
>+};
>+
>+/* port time gating control register */
>+#define ENETC_QBV_PTGCR_OFFSET		0x11a00
>+#define ENETC_QBV_TGE			BIT(31)
>+#define ENETC_QBV_TGPE			BIT(30)
>+
>+/* Port time gating capability register */
>+#define ENETC_QBV_PTGCAPR_OFFSET	0x11a08
>+#define ENETC_QBV_MAX_GCL_LEN_MASK	GENMASK(15, 0)
>diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
>new file mode 100644
>index 000000000000..9ce983c00201
>--- /dev/null
>+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
>@@ -0,0 +1,134 @@
>+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
>+/* Copyright 2019 NXP */
>+
>+#include "enetc.h"
>+
>+#include <net/pkt_sched.h>
>+
>+static u16 enetc_get_max_gcl_len(struct enetc_hw *hw)
>+{
>+	return enetc_rd(hw, ENETC_QBV_PTGCAPR_OFFSET)
>+		& ENETC_QBV_MAX_GCL_LEN_MASK;
>+}
>+
>+static int enetc_setup_taprio(struct net_device *ndev,
>+			      struct tc_taprio_qopt_offload *admin_conf)
>+{
>+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
>+	struct enetc_cbd cbd = {.cmd = 0};
>+	struct tgs_gcl_conf *gcl_config;
>+	struct tgs_gcl_data *gcl_data;
>+	struct gce *gce;
>+	dma_addr_t dma;
>+	u16 data_size;
>+	u16 gcl_len;
>+	u32 tge;
>+	int err;
>+	int i;
>+
>+	if (admin_conf->num_entries > enetc_get_max_gcl_len(&priv->si->hw))
>+		return -EINVAL;
>+	gcl_len = admin_conf->num_entries;
>+
>+	tge = enetc_rd(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET);
>+	if (!admin_conf->enable) {
>+		enetc_wr(&priv->si->hw,
>+			 ENETC_QBV_PTGCR_OFFSET,
>+			 tge & (~ENETC_QBV_TGE));
>+		return 0;
>+	}
>+
>+	if (admin_conf->cycle_time > (u32)~0 ||
>+	    admin_conf->cycle_time_extension > (u32)~0)
>+		return -EINVAL;

U32_MAX?

>+
>+	/* Configure the (administrative) gate control list using the
>+	 * control BD descriptor.
>+	 */
>+	gcl_config = &cbd.gcl_conf;
>+
>+	data_size = struct_size(gcl_data, entry, gcl_len);
>+	gcl_data = kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
>+	if (!gcl_data)
>+		return -ENOMEM;
>+
>+	gce = (struct gce *)(gcl_data + 1);
>+
>+	/* Set all gates open as default */
>+	gcl_config->atc = 0xff;
>+	gcl_config->acl_len = cpu_to_le16(gcl_len);
>+
>+	if (!admin_conf->base_time) {
>+		gcl_data->btl =
>+			cpu_to_le32(enetc_rd(&priv->si->hw, ENETC_SICTR0));
>+		gcl_data->bth =
>+			cpu_to_le32(enetc_rd(&priv->si->hw, ENETC_SICTR1));
>+	} else {
>+		gcl_data->btl =
>+			cpu_to_le32(lower_32_bits(admin_conf->base_time));
>+		gcl_data->bth =
>+			cpu_to_le32(upper_32_bits(admin_conf->base_time));
>+	}
>+
>+	gcl_data->ct = cpu_to_le32(admin_conf->cycle_time);
>+	gcl_data->cte = cpu_to_le32(admin_conf->cycle_time_extension);
>+
>+	for (i = 0; i < gcl_len; i++) {
>+		struct tc_taprio_sched_entry *temp_entry;
>+		struct gce *temp_gce = gce + i;
>+
>+		temp_entry = &admin_conf->entries[i];
>+
>+		temp_gce->gate = (u8)temp_entry->gate_mask;
>+		temp_gce->period = cpu_to_le32(temp_entry->interval);
>+	}
>+
>+	cbd.length = cpu_to_le16(data_size);
>+	cbd.status_flags = 0;
>+
>+	dma = dma_map_single(&priv->si->pdev->dev, gcl_data,
>+			     data_size, DMA_TO_DEVICE);
>+	if (dma_mapping_error(&priv->si->pdev->dev, dma)) {
>+		netdev_err(priv->si->ndev, "DMA mapping failed!\n");
>+		kfree(gcl_data);
>+		return -ENOMEM;
>+	}
>+
>+	cbd.addr[0] = lower_32_bits(dma);
>+	cbd.addr[1] = upper_32_bits(dma);
>+	cbd.cls = BDCR_CMD_PORT_GCL;
>+	cbd.status_flags = 0;
>+
>+	enetc_wr(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET,
>+		 tge & (~ENETC_QBV_TGE));

Sorry, but, please, before sending new version, be sure you understand what
should be changed.

Let's back to IEEE Std 802.1Q

Do you know what means cycle time extension that is programmed here.
And why needed admin and oper configurations, and their base times?

It's needed to not stop active oper configuration (that actually this
function do), so that it's active till new one, that is admin, will
be able to replace it.

If user wants to stop it, and then load new one, he has to do it
himself. But, when some configuration is active - that is OPER at the
moment - and user requests w/o stopping it new configuration in some
new admin base time, the oper stay active till this admin base time,
then dropped in hw.

What this code do, it's in hidden way, stop oper configuration at
the time of configuration and no matter which admit base time is.

That's definitely wrong. Just look how sw version works.
And why all this admin/oper headache exists in IEEE Std 802.1Q
exactly for this reason.

So, if oper configuration exists at the moment of calling taprio
configuration and no way to apply new on in some future time
(admin base time), the code should say to user:

Please, stop prev. oper configuration - then prog new one.

The taprio interface is common and can't be treated differently
depending on hw.

Hope it's clean.

>+
>+	usleep_range(10, 20);
>+
>+	enetc_wr(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET,
>+		 tge | ENETC_QBV_TGE);
>+
>+	err = enetc_send_cmd(priv->si, &cbd);
>+	if (err)
>+		enetc_wr(&priv->si->hw,
>+			 ENETC_QBV_PTGCR_OFFSET,
>+			 tge & (~ENETC_QBV_TGE));
>+
>+	dma_unmap_single(&priv->si->pdev->dev, dma, data_size, DMA_TO_DEVICE);
>+	kfree(gcl_data);
>+
>+	return err;
>+}
>+
>+int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
>+{
>+	struct tc_taprio_qopt_offload *taprio = type_data;
>+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
>+	int i;
>+
>+	for (i = 0; i < priv->num_tx_rings; i++)
>+		enetc_set_bdr_prio(&priv->si->hw,
>+				   priv->tx_ring[i]->index,
>+				   taprio->enable ? i : 0);

Again, you should restore  enetc_set_bdr_prio
if below enetc_setup_taprio() fails.

>+
>+	return enetc_setup_taprio(ndev, taprio);
>+}
>-- 
>2.17.1
>

-- 
Regards,
Ivan Khoronzhuk
