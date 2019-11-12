Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77701F8C12
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 10:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfKLJld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 04:41:33 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38669 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbfKLJlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 04:41:32 -0500
Received: by mail-wm1-f67.google.com with SMTP id z19so2169086wmk.3
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 01:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7SC3cwNC36/yzzYx745O3RgsQy1MTxOlBr6JFHn5ogM=;
        b=BjNhMGVWxzsveoy0bLRQOb8bkpv5rfK4moSOjmSblC+fqVTPl8iyxaDtLmTXIboLhV
         PoQHN9y6j1jIpiiG3pFWrIHBndl3MDBsWYUer/tLtnAfHYj2fRL7WIeAqqPyRJBjKEuh
         i6KyaGxJ2Ve+84Ju9tdM/NEX1VHEBiaCpWwrX5HN2h4qG8G/otFlaaeP2EujvJHcrdJ8
         C5FXKhct/VmlEuQrVo1irXWiHH5CqiibJCAe1inqnXgXdrQrTnRqozIc8uTQpSUrLVkF
         DttJPuATZlAM7l6lJNjqBRmXXXODwc7ZSkjDixvixbyomojQ2GvPDTPVWHaehIoW+emv
         2cdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7SC3cwNC36/yzzYx745O3RgsQy1MTxOlBr6JFHn5ogM=;
        b=hDeNzJzk8zWfN1WEeUYFfmMBcnt3PBph1WRwvcW6YvEY6AZ+EfXTz7x8sbeb2K7LcL
         hyxK2z03MYxDbO4k7YvPVM8WTfQN2ZSaU7q4t/ARTk/aWA/fedrMhJ68p42nJ91FiIdS
         Dw2FOtEexziHvjp/uyEOiuO60c37Ks2CNbS8gs8exgn4Ho/2lzkRjMo/ksGTlSbxY5bj
         7xzKDhbizSZiM/whY3ExTf+Z4kzv/oWCc2s1Goc11vu4Ny1S0bWlo/zrxno2bT2aOMKO
         jukFAOV26uDJgxNIV6W+ZfKaClcghpsLJPu3hz+DAJOn325N/XC2ieYV0VjdaO3Nz0zf
         nkMg==
X-Gm-Message-State: APjAAAX20C9VOz71Ajc0ke2V7rPBZwwz8ekOn49JgHvWIXB23zFKbXo8
        A17sz2WOV48Ic8TT8EbcYFXdrbYesYM=
X-Google-Smtp-Source: APXvYqy1wrL8iStGJpH8s5olXudKIPeTmsw3gH5vtEPmUIdLiLtzE5ytMOSzm9LsOS5Z3Tqozs2eZg==
X-Received: by 2002:a1c:4046:: with SMTP id n67mr3014661wma.2.1573551690132;
        Tue, 12 Nov 2019 01:41:30 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id j3sm17229384wrs.70.2019.11.12.01.41.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Nov 2019 01:41:29 -0800 (PST)
Date:   Tue, 12 Nov 2019 10:41:29 +0100
From:   Simon Horman <simon.horman@netronome.com>
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
Subject: Re: [net-next, 1/2] enetc: Configure the Time-Aware Scheduler via
 tc-taprio offload
Message-ID: <20191112094128.mbfil74gfdnkxigh@netronome.com>
References: <20191111042715.13444-1-Po.Liu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111042715.13444-1-Po.Liu@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 04:41:26AM +0000, Po Liu wrote:
> ENETC supports in hardware for time-based egress shaping according
> to IEEE 802.1Qbv. This patch implement the Qbv enablement by the
> hardware offload method qdisc tc-taprio method.
> Also update cbdr writeback to up level since control bd ring may
> writeback data to control bd ring.
> 
> Signed-off-by: Po Liu <Po.Liu@nxp.com>
> Singed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> ---
>  drivers/net/ethernet/freescale/enetc/Makefile |   1 +
>  drivers/net/ethernet/freescale/enetc/enetc.c  |  19 ++-
>  drivers/net/ethernet/freescale/enetc/enetc.h  |   2 +
>  .../net/ethernet/freescale/enetc/enetc_cbdr.c |   5 +-
>  .../net/ethernet/freescale/enetc/enetc_hw.h   | 150 ++++++++++++++++--
>  .../net/ethernet/freescale/enetc/enetc_qos.c  | 130 +++++++++++++++
>  6 files changed, 285 insertions(+), 22 deletions(-)
>  create mode 100644 drivers/net/ethernet/freescale/enetc/enetc_qos.c
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/Makefile b/drivers/net/ethernet/freescale/enetc/Makefile
> index d200c27c3bf6..389f722efc43 100644
> --- a/drivers/net/ethernet/freescale/enetc/Makefile
> +++ b/drivers/net/ethernet/freescale/enetc/Makefile
> @@ -5,6 +5,7 @@ common-objs := enetc.o enetc_cbdr.o enetc_ethtool.o
>  obj-$(CONFIG_FSL_ENETC) += fsl-enetc.o
>  fsl-enetc-y := enetc_pf.o enetc_mdio.o $(common-objs)
>  fsl-enetc-$(CONFIG_PCI_IOV) += enetc_msg.o
> +fsl-enetc-$(CONFIG_NET_SCH_TAPRIO) += enetc_qos.o
>  
>  obj-$(CONFIG_FSL_ENETC_VF) += fsl-enetc-vf.o
>  fsl-enetc-vf-y := enetc_vf.o $(common-objs)
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
> index 3e8f9819f08c..d58dbc2c4270 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc.c
> @@ -1427,8 +1427,7 @@ int enetc_close(struct net_device *ndev)
>  	return 0;
>  }
>  
> -int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
> -		   void *type_data)
> +int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
>  {
>  	struct enetc_ndev_priv *priv = netdev_priv(ndev);
>  	struct tc_mqprio_qopt *mqprio = type_data;
> @@ -1436,9 +1435,6 @@ int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
>  	u8 num_tc;
>  	int i;
>  
> -	if (type != TC_SETUP_QDISC_MQPRIO)
> -		return -EOPNOTSUPP;
> -
>  	mqprio->hw = TC_MQPRIO_HW_OFFLOAD_TCS;
>  	num_tc = mqprio->num_tc;
>  
> @@ -1483,6 +1479,19 @@ int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
>  	return 0;
>  }
>  
> +int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
> +		   void *type_data)
> +{
> +	switch (type) {
> +	case TC_SETUP_QDISC_MQPRIO:
> +		return enetc_setup_tc_mqprio(ndev, type_data);
> +	case TC_SETUP_QDISC_TAPRIO:
> +		return enetc_setup_tc_taprio(ndev, type_data);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
>  struct net_device_stats *enetc_get_stats(struct net_device *ndev)
>  {
>  	struct enetc_ndev_priv *priv = netdev_priv(ndev);
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
> index 541b4e2073fe..8676631041d5 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc.h
> +++ b/drivers/net/ethernet/freescale/enetc/enetc.h
> @@ -244,3 +244,5 @@ int enetc_set_fs_entry(struct enetc_si *si, struct enetc_cmd_rfse *rfse,
>  void enetc_set_rss_key(struct enetc_hw *hw, const u8 *bytes);
>  int enetc_get_rss_table(struct enetc_si *si, u32 *table, int count);
>  int enetc_set_rss_table(struct enetc_si *si, const u32 *table, int count);
> +int enetc_send_cmd(struct enetc_si *si, struct enetc_cbd *cbd);
> +int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data);
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
> index de466b71bf8f..201cbc362e33 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
> @@ -32,7 +32,7 @@ static int enetc_cbd_unused(struct enetc_cbdr *r)
>  		r->bd_count;
>  }
>  
> -static int enetc_send_cmd(struct enetc_si *si, struct enetc_cbd *cbd)
> +int enetc_send_cmd(struct enetc_si *si, struct enetc_cbd *cbd)
>  {
>  	struct enetc_cbdr *ring = &si->cbd_ring;
>  	int timeout = ENETC_CBDR_TIMEOUT;
> @@ -66,6 +66,9 @@ static int enetc_send_cmd(struct enetc_si *si, struct enetc_cbd *cbd)
>  	if (!timeout)
>  		return -EBUSY;
>  
> +	/* CBD may writeback data, feedback up level */
> +	*cbd = *dest_cbd;
> +
>  	enetc_clean_cbdr(si);
>  
>  	return 0;
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> index 88276299f447..75a7c0f1f8ce 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> @@ -18,6 +18,7 @@
>  #define ENETC_SICTR0	0x18
>  #define ENETC_SICTR1	0x1c
>  #define ENETC_SIPCAPR0	0x20
> +#define ENETC_SIPCAPR0_QBV	BIT(4)
>  #define ENETC_SIPCAPR0_RSS	BIT(8)
>  #define ENETC_SIPCAPR1	0x24
>  #define ENETC_SITGTGR	0x30
> @@ -148,6 +149,12 @@ enum enetc_bdr_type {TX, RX};
>  #define ENETC_PORT_BASE		0x10000
>  #define ENETC_PMR		0x0000
>  #define ENETC_PMR_EN	GENMASK(18, 16)
> +#define ENETC_PMR_PSPEED_MASK GENMASK(11, 8)
> +#define ENETC_PMR_PSPEED_10M 0x000
> +#define ENETC_PMR_PSPEED_100M 0x100
> +#define ENETC_PMR_PSPEED_1000M 0x200
> +#define ENETC_PMR_PSPEED_2500M 0x400

Perhaps BIT() is appropriate here.

The changes above to enetc_hw.h are not used until the following patch,
perhaps it would be better if they were part of that patch.

> +
>  #define ENETC_PSR		0x0004 /* RO */
>  #define ENETC_PSIPMR		0x0018
>  #define ENETC_PSIPMR_SET_UP(n)	BIT(n) /* n = SI index */
> @@ -440,22 +447,6 @@ union enetc_rx_bd {
>  #define EMETC_MAC_ADDR_FILT_RES	3 /* # of reserved entries at the beginning */
>  #define ENETC_MAX_NUM_VFS	2
>  
> -struct enetc_cbd {
> -	union {
> -		struct {
> -			__le32 addr[2];
> -			__le32 opt[4];
> -		};
> -		__le32 data[6];
> -	};
> -	__le16 index;
> -	__le16 length;
> -	u8 cmd;
> -	u8 cls;
> -	u8 _res;
> -	u8 status_flags;
> -};
> -
>  #define ENETC_CBD_FLAGS_SF	BIT(7) /* short format */
>  #define ENETC_CBD_STATUS_MASK	0xf
>  
> @@ -554,3 +545,130 @@ static inline void enetc_set_bdr_prio(struct enetc_hw *hw, int bdr_idx,
>  	val |= ENETC_TBMR_SET_PRIO(prio);
>  	enetc_txbdr_wr(hw, bdr_idx, ENETC_TBMR, val);
>  }
> +
> +enum bdcr_cmd_class {
> +	BDCR_CMD_UNSPEC = 0,
> +	BDCR_CMD_MAC_FILTER,
> +	BDCR_CMD_VLAN_FILTER,
> +	BDCR_CMD_RSS,
> +	BDCR_CMD_RFS,
> +	BDCR_CMD_PORT_GCL,
> +	BDCR_CMD_RECV_CLASSIFIER,
> +	__BDCR_CMD_MAX_LEN,
> +	BDCR_CMD_MAX_LEN = __BDCR_CMD_MAX_LEN - 1,
> +};
> +
> +/* class 5, command 0 */
> +struct tgs_gcl_conf {
> +	u8	atc;	/* init gate value */
> +	u8	res[7];
> +	union {
> +		struct {
> +			u8	res1[4];
> +			__le16	acl_len;

Given that u* types are used in this structure I think le16 would
be more appropriate than __le16.

> +			u8	res2[2];
> +		};
> +		struct {
> +			u32 cctl;
> +			u32 ccth;
> +		};

I'm a little surprised to see host endian values in a structure
that appears to be written to hardware. Is this intentional?

Also, these fields do not seem to be used in this patch-set.
Is that also intentional?

> +	};
> +};
> +
> +#define ENETC_CBDR_SGL_IOMEN	BIT(0)
> +#define ENETC_CBDR_SGL_IPVEN	BIT(3)
> +#define ENETC_CBDR_SGL_GTST	BIT(4)
> +#define ENETC_CBDR_SGL_IPV_MASK 0xe

Perhaps GENMASK() is appropriate here and elsewhere for generating masks.

> +
> +/* gate control list entry */
> +struct gce {
> +	u32	period;

Likewise, I'm a little surprised to see host-byte order data to
be written to HW. And below too. Though as I've noted below,
some of these values are used to store le32 data, so it seems
that the types are incorrect.

> +	u8	gate;
> +	u8	res[3];
> +};
> +
> +/* tgs_gcl_conf address point to this data space */
> +struct tgs_gcl_data {
> +	u32	btl;
> +	u32	bth;
> +	u32	ct;
> +	u32	cte;
> +};
> +
> +/* class 5, command 1 */
> +struct tgs_gcl_query {
> +		u8	res[12];
> +		union {
> +			struct {
> +				__le16	acl_len; /* admin list length */
> +				__le16	ocl_len; /* operation list length */
> +			};
> +			struct {
> +				u16 admin_list_len;
> +				u16 oper_list_len;

	Again, is it intentional that these are a) host-byte order and
	b) unused?

> +			};
> +		};
> +};
> +
> +/* tgs_gcl_query command response data format */
> +struct tgs_gcl_resp {
> +	u32 abtl;	/* base time */
> +	u32 abth;
> +	u32 act;	/* cycle time */
> +	u32 acte;	/* cycle time extend */
> +	u32 cctl;	/* config change time */
> +	u32 ccth;
> +	u32 obtl;	/* operation base time */
> +	u32 obth;
> +	u32 oct;	/* operation cycle time */
> +	u32 octe;	/* operation cycle time extend */
> +	u32 ccel;	/* config change error */
> +	u32 cceh;
> +};

This structure seems unused in this patchset.

> +
> +struct enetc_cbd {
> +	union{
> +		struct {
> +			__le32	addr[2];
> +			union {
> +				__le32	opt[4];
> +				struct tgs_gcl_conf	gcl_conf;
> +				struct tgs_gcl_query	gcl_query;
> +			};
> +		};	/* Long format */
> +		__le32 data[6];
> +	};
> +	__le16 index;
> +	__le16 length;
> +	u8 cmd;
> +	u8 cls;
> +	u8 _res;
> +	u8 status_flags;
> +};
> +
> +#define ENETC_PTCFPR(n)		(0x1910 + (n) * 4) /* n = [0 ..7] */
> +#define ENETC_FPE		BIT(31)
> +
> +/* Port capability register 0 */
> +#define ENETC_PCAPR0_PSFPM	BIT(10)
> +#define ENETC_PCAPR0_PSFP	BIT(9)
> +#define ENETC_PCAPR0_TSN	BIT(4)
> +#define ENETC_PCAPR0_QBU	BIT(3)
> +
> +/* port time gating control register */
> +#define ENETC_QBV_PTGCR_OFFSET		0x11a00
> +#define ENETC_QBV_TGE			0x80000000
> +#define ENETC_QBV_TGPE			BIT(30)
> +#define ENETC_QBV_TGDROP_DISABLE	BIT(29)
> +
> +/* Port time gating capability register */
> +#define ENETC_QBV_PTGCAPR_OFFSET	0x11a08
> +#define ENETC_QBV_MAX_GCL_LEN_MASK	0xffff
> +
> +/* Port time gating admin gate list status register */
> +#define ENETC_QBV_PTGAGLSR_OFFSET	0x11a10
> +#define ENETC_QBV_CFG_PEND_MASK	0x00000002
> +
> +#define ENETC_TGLSTR			0xa200
> +#define ENETC_TGS_MIN_DIS_MASK		0x80000000
> +#define ENETC_MIN_LOOKAHEAD_MASK	0xffff
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> new file mode 100644
> index 000000000000..036bb39c7a0b
> --- /dev/null
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> @@ -0,0 +1,130 @@
> +// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
> +/* Copyright 2019 NXP */
> +
> +#include "enetc.h"
> +
> +#include <net/pkt_sched.h>
> +
> +static u16 enetc_get_max_gcl_len(struct enetc_hw *hw)
> +{
> +	return enetc_rd(hw, ENETC_QBV_PTGCAPR_OFFSET)
> +		& ENETC_QBV_MAX_GCL_LEN_MASK;
> +}
> +
> +static int enetc_setup_taprio(struct net_device *ndev,
> +			      struct tc_taprio_qopt_offload *admin_conf)
> +{
> +	struct enetc_ndev_priv *priv = netdev_priv(ndev);
> +	struct enetc_cbd cbd = {.cmd = 0};
> +	struct tgs_gcl_conf *gcl_config;
> +	struct tgs_gcl_data *gcl_data;
> +	struct gce *gce;
> +	dma_addr_t dma;
> +	u16 data_size;
> +	u16 gcl_len;
> +	u32 temp;
> +	int i;
> +
> +	gcl_len = admin_conf->num_entries;
> +	if (gcl_len > enetc_get_max_gcl_len(&priv->si->hw))
> +		return -EINVAL;
> +
> +	if (admin_conf->enable) {
> +		enetc_wr(&priv->si->hw,
> +			 ENETC_QBV_PTGCR_OFFSET,
> +			 temp & (~ENETC_QBV_TGE));

The enetc_wr() call seems to be common to both arms of the condition.
If so perhaps it could be move outside of the condition.

> +		usleep_range(10, 20);
> +		enetc_wr(&priv->si->hw,
> +			 ENETC_QBV_PTGCR_OFFSET,
> +			 temp | ENETC_QBV_TGE);
> +	} else {
> +		enetc_wr(&priv->si->hw,
> +			 ENETC_QBV_PTGCR_OFFSET,
> +			 temp & (~ENETC_QBV_TGE));
> +		return 0;
> +	}
> +
> +	/* Configure the (administrative) gate control list using the
> +	 * control BD descriptor.
> +	 */
> +	gcl_config = &cbd.gcl_conf;
> +
> +	data_size = sizeof(struct tgs_gcl_data) + gcl_len * sizeof(struct gce);

I think struct_size() can be used here.

> +
> +	gcl_data = kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
> +	if (!gcl_data)
> +		return -ENOMEM;
> +
> +	gce = (struct gce *)(gcl_data + 1);
> +
> +	/* Since no initial state config in taprio, set gates open as default.
> +	 */
> +	gcl_config->atc = 0xff;
> +	gcl_config->acl_len = cpu_to_le16(gcl_len);
> +
> +	if (!admin_conf->base_time) {
> +		gcl_data->btl =
> +			cpu_to_le32(enetc_rd(&priv->si->hw, ENETC_SICTR0));
> +		gcl_data->bth =
> +			cpu_to_le32(enetc_rd(&priv->si->hw, ENETC_SICTR1));
> +	} else {
> +		gcl_data->btl =
> +			cpu_to_le32(lower_32_bits(admin_conf->base_time));
> +		gcl_data->bth =
> +			cpu_to_le32(upper_32_bits(admin_conf->base_time));
> +	}

It looks like the types of the btl and bth fields are u32.
Perhaps they should be le32?

Please consider running sparse over this code to check for any endian
problems.

> +
> +	gcl_data->ct = cpu_to_le32(admin_conf->cycle_time);
> +	gcl_data->cte = cpu_to_le32(admin_conf->cycle_time_extension);
> +
> +	for (i = 0; i < gcl_len; i++) {
> +		struct tc_taprio_sched_entry *temp_entry;
> +		struct gce *temp_gce = gce + i;
> +
> +		temp_entry = &admin_conf->entries[i];
> +
> +		temp_gce->gate = cpu_to_le32(temp_entry->gate_mask);

	Gate is a u8 followed by 3 reserved bytes.
	Perhaps there needs to be some bounds checking on
	the value stored there given that the source is 32bits wide.

	Also, its not clear to me that the above logic, which I assume
	takes the last significant byte of a 32bit value, works on
	big endian systems as the 32bit value is always little endian.

> +		temp_gce->period = cpu_to_le32(temp_entry->interval);

	It looks like the types of the gate field is u32.
	Perhaps it should be le32?

> +	}
> +
> +	cbd.length = cpu_to_le16(data_size);
> +	cbd.status_flags = 0;
> +
> +	dma = dma_map_single(&priv->si->pdev->dev, gcl_data,
> +			     data_size, DMA_TO_DEVICE);
> +	if (dma_mapping_error(&priv->si->pdev->dev, dma)) {
> +		netdev_err(priv->si->ndev, "DMA mapping failed!\n");
> +		kfree(gcl_data);
> +		return -ENOMEM;
> +	}
> +
> +	cbd.addr[0] = lower_32_bits(dma);
> +	cbd.addr[1] = upper_32_bits(dma);
> +	cbd.cls = BDCR_CMD_PORT_GCL;
> +
> +	/* Updated by ENETC on completion of the configuration
> +	 * command. A zero value indicates success.
> +	 */
> +	cbd.status_flags = 0;
> +
> +	enetc_send_cmd(priv->si, &cbd);
> +
> +	dma_unmap_single(&priv->si->pdev->dev, dma, data_size, DMA_TO_DEVICE);
> +	kfree(gcl_data);
> +
> +	return 0;
> +}
> +
> +int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
> +{
> +	struct tc_taprio_qopt_offload *taprio = type_data;
> +	struct enetc_ndev_priv *priv = netdev_priv(ndev);
> +	int i;
> +
> +	for (i = 0; i < priv->num_tx_rings; i++)
> +		enetc_set_bdr_prio(&priv->si->hw,
> +				   priv->tx_ring[i]->index,
> +				   taprio->enable ? i : 0);
> +
> +	return enetc_setup_taprio(ndev, taprio);
> +}
> -- 
> 2.17.1
> 
