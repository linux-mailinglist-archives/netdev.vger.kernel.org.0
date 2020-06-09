Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C981F4747
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 21:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389369AbgFITli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 15:41:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:59910 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389295AbgFITlf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 15:41:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0EA6FAE0F;
        Tue,  9 Jun 2020 19:41:34 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E809160485; Tue,  9 Jun 2020 21:41:29 +0200 (CEST)
Date:   Tue, 9 Jun 2020 21:41:29 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>,
        Amit Cohen <amitc@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: Re: [PATCH v3 1/3] update UAPI header copies
Message-ID: <20200609194129.z2vajkc7i36epcf4@lion.mk-sys.cz>
References: <20200609084718.14110-1-o.rempel@pengutronix.de>
 <20200609084718.14110-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609084718.14110-2-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 10:47:16AM +0200, Oleksij Rempel wrote:
> Update to net-dev:
> dc0f3ed1973 ("net: phy: at803x: add cable diagnostics support for ATH9331 and ATH8032")
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Please rebase this commit (and the whole series - but the other two
patches do not conflict) on current master branch and update from
current kernel master so that we also get the documentation reference
fix from kernel commit 72ef5e52b3f7 ("docs: fix broken references to
text files").

Michal

>  uapi/linux/ethtool.h         |  25 ++-
>  uapi/linux/ethtool_netlink.h | 326 +++++++++++++++++++++++++++++++++++
>  uapi/linux/genetlink.h       |   2 +
>  uapi/linux/if_link.h         |   7 +-
>  uapi/linux/net_tstamp.h      |   6 +
>  uapi/linux/netlink.h         | 103 +++++++++++
>  uapi/linux/rtnetlink.h       |   6 +
>  7 files changed, 471 insertions(+), 4 deletions(-)
> 
> diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
> index d3dcb45..6074caa 100644
> --- a/uapi/linux/ethtool.h
> +++ b/uapi/linux/ethtool.h
> @@ -594,6 +594,9 @@ struct ethtool_pauseparam {
>   * @ETH_SS_LINK_MODES: link mode names
>   * @ETH_SS_MSG_CLASSES: debug message class names
>   * @ETH_SS_WOL_MODES: wake-on-lan modes
> + * @ETH_SS_SOF_TIMESTAMPING: SOF_TIMESTAMPING_* flags
> + * @ETH_SS_TS_TX_TYPES: timestamping Tx types
> + * @ETH_SS_TS_RX_FILTERS: timestamping Rx filters
>   */
>  enum ethtool_stringset {
>  	ETH_SS_TEST		= 0,
> @@ -608,6 +611,9 @@ enum ethtool_stringset {
>  	ETH_SS_LINK_MODES,
>  	ETH_SS_MSG_CLASSES,
>  	ETH_SS_WOL_MODES,
> +	ETH_SS_SOF_TIMESTAMPING,
> +	ETH_SS_TS_TX_TYPES,
> +	ETH_SS_TS_RX_FILTERS,
>  
>  	/* add new constants above here */
>  	ETH_SS_COUNT
> @@ -1521,8 +1527,7 @@ enum ethtool_link_mode_bit_indices {
>  	ETHTOOL_LINK_MODE_400000baseLR8_ER8_FR8_Full_BIT = 71,
>  	ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT	 = 72,
>  	ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT	 = 73,
> -	ETHTOOL_LINK_MODE_FEC_LLRS_BIT                   = 74,
> -
> +	ETHTOOL_LINK_MODE_FEC_LLRS_BIT			 = 74,
>  	/* must be last entry */
>  	__ETHTOOL_LINK_MODE_MASK_NBITS
>  };
> @@ -1659,6 +1664,18 @@ static __inline__ int ethtool_validate_duplex(__u8 duplex)
>  	return 0;
>  }
>  
> +#define MASTER_SLAVE_CFG_UNSUPPORTED		0
> +#define MASTER_SLAVE_CFG_UNKNOWN		1
> +#define MASTER_SLAVE_CFG_MASTER_PREFERRED	2
> +#define MASTER_SLAVE_CFG_SLAVE_PREFERRED	3
> +#define MASTER_SLAVE_CFG_MASTER_FORCE		4
> +#define MASTER_SLAVE_CFG_SLAVE_FORCE		5
> +#define MASTER_SLAVE_STATE_UNSUPPORTED		0
> +#define MASTER_SLAVE_STATE_UNKNOWN		1
> +#define MASTER_SLAVE_STATE_MASTER		2
> +#define MASTER_SLAVE_STATE_SLAVE		3
> +#define MASTER_SLAVE_STATE_ERR			4
> +
>  /* Which connector port. */
>  #define PORT_TP			0x00
>  #define PORT_AUI		0x01
> @@ -1897,7 +1914,9 @@ struct ethtool_link_settings {
>  	__u8	eth_tp_mdix_ctrl;
>  	__s8	link_mode_masks_nwords;
>  	__u8	transceiver;
> -	__u8	reserved1[3];
> +	__u8	master_slave_cfg;
> +	__u8	master_slave_state;
> +	__u8	reserved1[1];
>  	__u32	reserved[7];
>  	__u32	link_mode_masks[0];
>  	/* layout of link_mode_masks fields:
> diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
> index ad6d3a0..051b35b 100644
> --- a/uapi/linux/ethtool_netlink.h
> +++ b/uapi/linux/ethtool_netlink.h
> @@ -24,6 +24,23 @@ enum {
>  	ETHTOOL_MSG_DEBUG_SET,
>  	ETHTOOL_MSG_WOL_GET,
>  	ETHTOOL_MSG_WOL_SET,
> +	ETHTOOL_MSG_FEATURES_GET,
> +	ETHTOOL_MSG_FEATURES_SET,
> +	ETHTOOL_MSG_PRIVFLAGS_GET,
> +	ETHTOOL_MSG_PRIVFLAGS_SET,
> +	ETHTOOL_MSG_RINGS_GET,
> +	ETHTOOL_MSG_RINGS_SET,
> +	ETHTOOL_MSG_CHANNELS_GET,
> +	ETHTOOL_MSG_CHANNELS_SET,
> +	ETHTOOL_MSG_COALESCE_GET,
> +	ETHTOOL_MSG_COALESCE_SET,
> +	ETHTOOL_MSG_PAUSE_GET,
> +	ETHTOOL_MSG_PAUSE_SET,
> +	ETHTOOL_MSG_EEE_GET,
> +	ETHTOOL_MSG_EEE_SET,
> +	ETHTOOL_MSG_TSINFO_GET,
> +	ETHTOOL_MSG_CABLE_TEST_ACT,
> +	ETHTOOL_MSG_CABLE_TEST_TDR_ACT,
>  
>  	/* add new constants above here */
>  	__ETHTOOL_MSG_USER_CNT,
> @@ -43,6 +60,24 @@ enum {
>  	ETHTOOL_MSG_DEBUG_NTF,
>  	ETHTOOL_MSG_WOL_GET_REPLY,
>  	ETHTOOL_MSG_WOL_NTF,
> +	ETHTOOL_MSG_FEATURES_GET_REPLY,
> +	ETHTOOL_MSG_FEATURES_SET_REPLY,
> +	ETHTOOL_MSG_FEATURES_NTF,
> +	ETHTOOL_MSG_PRIVFLAGS_GET_REPLY,
> +	ETHTOOL_MSG_PRIVFLAGS_NTF,
> +	ETHTOOL_MSG_RINGS_GET_REPLY,
> +	ETHTOOL_MSG_RINGS_NTF,
> +	ETHTOOL_MSG_CHANNELS_GET_REPLY,
> +	ETHTOOL_MSG_CHANNELS_NTF,
> +	ETHTOOL_MSG_COALESCE_GET_REPLY,
> +	ETHTOOL_MSG_COALESCE_NTF,
> +	ETHTOOL_MSG_PAUSE_GET_REPLY,
> +	ETHTOOL_MSG_PAUSE_NTF,
> +	ETHTOOL_MSG_EEE_GET_REPLY,
> +	ETHTOOL_MSG_EEE_NTF,
> +	ETHTOOL_MSG_TSINFO_GET_REPLY,
> +	ETHTOOL_MSG_CABLE_TEST_NTF,
> +	ETHTOOL_MSG_CABLE_TEST_TDR_NTF,
>  
>  	/* add new constants above here */
>  	__ETHTOOL_MSG_KERNEL_CNT,
> @@ -185,6 +220,8 @@ enum {
>  	ETHTOOL_A_LINKMODES_PEER,		/* bitset */
>  	ETHTOOL_A_LINKMODES_SPEED,		/* u32 */
>  	ETHTOOL_A_LINKMODES_DUPLEX,		/* u8 */
> +	ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,	/* u8 */
> +	ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,	/* u8 */
>  
>  	/* add new constants above here */
>  	__ETHTOOL_A_LINKMODES_CNT,
> @@ -197,6 +234,8 @@ enum {
>  	ETHTOOL_A_LINKSTATE_UNSPEC,
>  	ETHTOOL_A_LINKSTATE_HEADER,		/* nest - _A_HEADER_* */
>  	ETHTOOL_A_LINKSTATE_LINK,		/* u8 */
> +	ETHTOOL_A_LINKSTATE_SQI,		/* u32 */
> +	ETHTOOL_A_LINKSTATE_SQI_MAX,		/* u32 */
>  
>  	/* add new constants above here */
>  	__ETHTOOL_A_LINKSTATE_CNT,
> @@ -228,6 +267,293 @@ enum {
>  	ETHTOOL_A_WOL_MAX = __ETHTOOL_A_WOL_CNT - 1
>  };
>  
> +/* FEATURES */
> +
> +enum {
> +	ETHTOOL_A_FEATURES_UNSPEC,
> +	ETHTOOL_A_FEATURES_HEADER,			/* nest - _A_HEADER_* */
> +	ETHTOOL_A_FEATURES_HW,				/* bitset */
> +	ETHTOOL_A_FEATURES_WANTED,			/* bitset */
> +	ETHTOOL_A_FEATURES_ACTIVE,			/* bitset */
> +	ETHTOOL_A_FEATURES_NOCHANGE,			/* bitset */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_FEATURES_CNT,
> +	ETHTOOL_A_FEATURES_MAX = __ETHTOOL_A_FEATURES_CNT - 1
> +};
> +
> +/* PRIVFLAGS */
> +
> +enum {
> +	ETHTOOL_A_PRIVFLAGS_UNSPEC,
> +	ETHTOOL_A_PRIVFLAGS_HEADER,			/* nest - _A_HEADER_* */
> +	ETHTOOL_A_PRIVFLAGS_FLAGS,			/* bitset */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_PRIVFLAGS_CNT,
> +	ETHTOOL_A_PRIVFLAGS_MAX = __ETHTOOL_A_PRIVFLAGS_CNT - 1
> +};
> +
> +/* RINGS */
> +
> +enum {
> +	ETHTOOL_A_RINGS_UNSPEC,
> +	ETHTOOL_A_RINGS_HEADER,				/* nest - _A_HEADER_* */
> +	ETHTOOL_A_RINGS_RX_MAX,				/* u32 */
> +	ETHTOOL_A_RINGS_RX_MINI_MAX,			/* u32 */
> +	ETHTOOL_A_RINGS_RX_JUMBO_MAX,			/* u32 */
> +	ETHTOOL_A_RINGS_TX_MAX,				/* u32 */
> +	ETHTOOL_A_RINGS_RX,				/* u32 */
> +	ETHTOOL_A_RINGS_RX_MINI,			/* u32 */
> +	ETHTOOL_A_RINGS_RX_JUMBO,			/* u32 */
> +	ETHTOOL_A_RINGS_TX,				/* u32 */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_RINGS_CNT,
> +	ETHTOOL_A_RINGS_MAX = (__ETHTOOL_A_RINGS_CNT - 1)
> +};
> +
> +/* CHANNELS */
> +
> +enum {
> +	ETHTOOL_A_CHANNELS_UNSPEC,
> +	ETHTOOL_A_CHANNELS_HEADER,			/* nest - _A_HEADER_* */
> +	ETHTOOL_A_CHANNELS_RX_MAX,			/* u32 */
> +	ETHTOOL_A_CHANNELS_TX_MAX,			/* u32 */
> +	ETHTOOL_A_CHANNELS_OTHER_MAX,			/* u32 */
> +	ETHTOOL_A_CHANNELS_COMBINED_MAX,		/* u32 */
> +	ETHTOOL_A_CHANNELS_RX_COUNT,			/* u32 */
> +	ETHTOOL_A_CHANNELS_TX_COUNT,			/* u32 */
> +	ETHTOOL_A_CHANNELS_OTHER_COUNT,			/* u32 */
> +	ETHTOOL_A_CHANNELS_COMBINED_COUNT,		/* u32 */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_CHANNELS_CNT,
> +	ETHTOOL_A_CHANNELS_MAX = (__ETHTOOL_A_CHANNELS_CNT - 1)
> +};
> +
> +/* COALESCE */
> +
> +enum {
> +	ETHTOOL_A_COALESCE_UNSPEC,
> +	ETHTOOL_A_COALESCE_HEADER,			/* nest - _A_HEADER_* */
> +	ETHTOOL_A_COALESCE_RX_USECS,			/* u32 */
> +	ETHTOOL_A_COALESCE_RX_MAX_FRAMES,		/* u32 */
> +	ETHTOOL_A_COALESCE_RX_USECS_IRQ,		/* u32 */
> +	ETHTOOL_A_COALESCE_RX_MAX_FRAMES_IRQ,		/* u32 */
> +	ETHTOOL_A_COALESCE_TX_USECS,			/* u32 */
> +	ETHTOOL_A_COALESCE_TX_MAX_FRAMES,		/* u32 */
> +	ETHTOOL_A_COALESCE_TX_USECS_IRQ,		/* u32 */
> +	ETHTOOL_A_COALESCE_TX_MAX_FRAMES_IRQ,		/* u32 */
> +	ETHTOOL_A_COALESCE_STATS_BLOCK_USECS,		/* u32 */
> +	ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX,		/* u8 */
> +	ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX,		/* u8 */
> +	ETHTOOL_A_COALESCE_PKT_RATE_LOW,		/* u32 */
> +	ETHTOOL_A_COALESCE_RX_USECS_LOW,		/* u32 */
> +	ETHTOOL_A_COALESCE_RX_MAX_FRAMES_LOW,		/* u32 */
> +	ETHTOOL_A_COALESCE_TX_USECS_LOW,		/* u32 */
> +	ETHTOOL_A_COALESCE_TX_MAX_FRAMES_LOW,		/* u32 */
> +	ETHTOOL_A_COALESCE_PKT_RATE_HIGH,		/* u32 */
> +	ETHTOOL_A_COALESCE_RX_USECS_HIGH,		/* u32 */
> +	ETHTOOL_A_COALESCE_RX_MAX_FRAMES_HIGH,		/* u32 */
> +	ETHTOOL_A_COALESCE_TX_USECS_HIGH,		/* u32 */
> +	ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH,		/* u32 */
> +	ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,	/* u32 */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_COALESCE_CNT,
> +	ETHTOOL_A_COALESCE_MAX = (__ETHTOOL_A_COALESCE_CNT - 1)
> +};
> +
> +/* PAUSE */
> +
> +enum {
> +	ETHTOOL_A_PAUSE_UNSPEC,
> +	ETHTOOL_A_PAUSE_HEADER,				/* nest - _A_HEADER_* */
> +	ETHTOOL_A_PAUSE_AUTONEG,			/* u8 */
> +	ETHTOOL_A_PAUSE_RX,				/* u8 */
> +	ETHTOOL_A_PAUSE_TX,				/* u8 */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_PAUSE_CNT,
> +	ETHTOOL_A_PAUSE_MAX = (__ETHTOOL_A_PAUSE_CNT - 1)
> +};
> +
> +/* EEE */
> +
> +enum {
> +	ETHTOOL_A_EEE_UNSPEC,
> +	ETHTOOL_A_EEE_HEADER,				/* nest - _A_HEADER_* */
> +	ETHTOOL_A_EEE_MODES_OURS,			/* bitset */
> +	ETHTOOL_A_EEE_MODES_PEER,			/* bitset */
> +	ETHTOOL_A_EEE_ACTIVE,				/* u8 */
> +	ETHTOOL_A_EEE_ENABLED,				/* u8 */
> +	ETHTOOL_A_EEE_TX_LPI_ENABLED,			/* u8 */
> +	ETHTOOL_A_EEE_TX_LPI_TIMER,			/* u32 */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_EEE_CNT,
> +	ETHTOOL_A_EEE_MAX = (__ETHTOOL_A_EEE_CNT - 1)
> +};
> +
> +/* TSINFO */
> +
> +enum {
> +	ETHTOOL_A_TSINFO_UNSPEC,
> +	ETHTOOL_A_TSINFO_HEADER,			/* nest - _A_HEADER_* */
> +	ETHTOOL_A_TSINFO_TIMESTAMPING,			/* bitset */
> +	ETHTOOL_A_TSINFO_TX_TYPES,			/* bitset */
> +	ETHTOOL_A_TSINFO_RX_FILTERS,			/* bitset */
> +	ETHTOOL_A_TSINFO_PHC_INDEX,			/* u32 */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_TSINFO_CNT,
> +	ETHTOOL_A_TSINFO_MAX = (__ETHTOOL_A_TSINFO_CNT - 1)
> +};
> +
> +/* CABLE TEST */
> +
> +enum {
> +	ETHTOOL_A_CABLE_TEST_UNSPEC,
> +	ETHTOOL_A_CABLE_TEST_HEADER,		/* nest - _A_HEADER_* */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_CABLE_TEST_CNT,
> +	ETHTOOL_A_CABLE_TEST_MAX = __ETHTOOL_A_CABLE_TEST_CNT - 1
> +};
> +
> +/* CABLE TEST NOTIFY */
> +enum {
> +	ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC,
> +	ETHTOOL_A_CABLE_RESULT_CODE_OK,
> +	ETHTOOL_A_CABLE_RESULT_CODE_OPEN,
> +	ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT,
> +	ETHTOOL_A_CABLE_RESULT_CODE_CROSS_SHORT,
> +};
> +
> +enum {
> +	ETHTOOL_A_CABLE_PAIR_A,
> +	ETHTOOL_A_CABLE_PAIR_B,
> +	ETHTOOL_A_CABLE_PAIR_C,
> +	ETHTOOL_A_CABLE_PAIR_D,
> +};
> +
> +enum {
> +	ETHTOOL_A_CABLE_RESULT_UNSPEC,
> +	ETHTOOL_A_CABLE_RESULT_PAIR,		/* u8 ETHTOOL_A_CABLE_PAIR_ */
> +	ETHTOOL_A_CABLE_RESULT_CODE,		/* u8 ETHTOOL_A_CABLE_RESULT_CODE_ */
> +
> +	__ETHTOOL_A_CABLE_RESULT_CNT,
> +	ETHTOOL_A_CABLE_RESULT_MAX = (__ETHTOOL_A_CABLE_RESULT_CNT - 1)
> +};
> +
> +enum {
> +	ETHTOOL_A_CABLE_FAULT_LENGTH_UNSPEC,
> +	ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR,	/* u8 ETHTOOL_A_CABLE_PAIR_ */
> +	ETHTOOL_A_CABLE_FAULT_LENGTH_CM,	/* u32 */
> +
> +	__ETHTOOL_A_CABLE_FAULT_LENGTH_CNT,
> +	ETHTOOL_A_CABLE_FAULT_LENGTH_MAX = (__ETHTOOL_A_CABLE_FAULT_LENGTH_CNT - 1)
> +};
> +
> +enum {
> +	ETHTOOL_A_CABLE_TEST_NTF_STATUS_UNSPEC,
> +	ETHTOOL_A_CABLE_TEST_NTF_STATUS_STARTED,
> +	ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED
> +};
> +
> +enum {
> +	ETHTOOL_A_CABLE_NEST_UNSPEC,
> +	ETHTOOL_A_CABLE_NEST_RESULT,		/* nest - ETHTOOL_A_CABLE_RESULT_ */
> +	ETHTOOL_A_CABLE_NEST_FAULT_LENGTH,	/* nest - ETHTOOL_A_CABLE_FAULT_LENGTH_ */
> +	__ETHTOOL_A_CABLE_NEST_CNT,
> +	ETHTOOL_A_CABLE_NEST_MAX = (__ETHTOOL_A_CABLE_NEST_CNT - 1)
> +};
> +
> +enum {
> +	ETHTOOL_A_CABLE_TEST_NTF_UNSPEC,
> +	ETHTOOL_A_CABLE_TEST_NTF_HEADER,	/* nest - ETHTOOL_A_HEADER_* */
> +	ETHTOOL_A_CABLE_TEST_NTF_STATUS,	/* u8 - _STARTED/_COMPLETE */
> +	ETHTOOL_A_CABLE_TEST_NTF_NEST,		/* nest - of results: */
> +
> +	__ETHTOOL_A_CABLE_TEST_NTF_CNT,
> +	ETHTOOL_A_CABLE_TEST_NTF_MAX = (__ETHTOOL_A_CABLE_TEST_NTF_CNT - 1)
> +};
> +
> +/* CABLE TEST TDR */
> +
> +enum {
> +	ETHTOOL_A_CABLE_TEST_TDR_CFG_UNSPEC,
> +	ETHTOOL_A_CABLE_TEST_TDR_CFG_FIRST,		/* u32 */
> +	ETHTOOL_A_CABLE_TEST_TDR_CFG_LAST,		/* u32 */
> +	ETHTOOL_A_CABLE_TEST_TDR_CFG_STEP,		/* u32 */
> +	ETHTOOL_A_CABLE_TEST_TDR_CFG_PAIR,		/* u8 */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_CABLE_TEST_TDR_CFG_CNT,
> +	ETHTOOL_A_CABLE_TEST_TDR_CFG_MAX = __ETHTOOL_A_CABLE_TEST_TDR_CFG_CNT - 1
> +};
> +
> +enum {
> +	ETHTOOL_A_CABLE_TEST_TDR_UNSPEC,
> +	ETHTOOL_A_CABLE_TEST_TDR_HEADER,	/* nest - _A_HEADER_* */
> +	ETHTOOL_A_CABLE_TEST_TDR_CFG,		/* nest - *_TDR_CFG_* */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_CABLE_TEST_TDR_CNT,
> +	ETHTOOL_A_CABLE_TEST_TDR_MAX = __ETHTOOL_A_CABLE_TEST_TDR_CNT - 1
> +};
> +
> +/* CABLE TEST TDR NOTIFY */
> +
> +enum {
> +	ETHTOOL_A_CABLE_AMPLITUDE_UNSPEC,
> +	ETHTOOL_A_CABLE_AMPLITUDE_PAIR,         /* u8 */
> +	ETHTOOL_A_CABLE_AMPLITUDE_mV,           /* s16 */
> +
> +	__ETHTOOL_A_CABLE_AMPLITUDE_CNT,
> +	ETHTOOL_A_CABLE_AMPLITUDE_MAX = (__ETHTOOL_A_CABLE_AMPLITUDE_CNT - 1)
> +};
> +
> +enum {
> +	ETHTOOL_A_CABLE_PULSE_UNSPEC,
> +	ETHTOOL_A_CABLE_PULSE_mV,		/* s16 */
> +
> +	__ETHTOOL_A_CABLE_PULSE_CNT,
> +	ETHTOOL_A_CABLE_PULSE_MAX = (__ETHTOOL_A_CABLE_PULSE_CNT - 1)
> +};
> +
> +enum {
> +	ETHTOOL_A_CABLE_STEP_UNSPEC,
> +	ETHTOOL_A_CABLE_STEP_FIRST_DISTANCE,	/* u32 */
> +	ETHTOOL_A_CABLE_STEP_LAST_DISTANCE,	/* u32 */
> +	ETHTOOL_A_CABLE_STEP_STEP_DISTANCE,	/* u32 */
> +
> +	__ETHTOOL_A_CABLE_STEP_CNT,
> +	ETHTOOL_A_CABLE_STEP_MAX = (__ETHTOOL_A_CABLE_STEP_CNT - 1)
> +};
> +
> +enum {
> +	ETHTOOL_A_CABLE_TDR_NEST_UNSPEC,
> +	ETHTOOL_A_CABLE_TDR_NEST_STEP,		/* nest - ETHTTOOL_A_CABLE_STEP */
> +	ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE,	/* nest - ETHTOOL_A_CABLE_AMPLITUDE */
> +	ETHTOOL_A_CABLE_TDR_NEST_PULSE,		/* nest - ETHTOOL_A_CABLE_PULSE */
> +
> +	__ETHTOOL_A_CABLE_TDR_NEST_CNT,
> +	ETHTOOL_A_CABLE_TDR_NEST_MAX = (__ETHTOOL_A_CABLE_TDR_NEST_CNT - 1)
> +};
> +
> +enum {
> +	ETHTOOL_A_CABLE_TEST_TDR_NTF_UNSPEC,
> +	ETHTOOL_A_CABLE_TEST_TDR_NTF_HEADER,	/* nest - ETHTOOL_A_HEADER_* */
> +	ETHTOOL_A_CABLE_TEST_TDR_NTF_STATUS,	/* u8 - _STARTED/_COMPLETE */
> +	ETHTOOL_A_CABLE_TEST_TDR_NTF_NEST,	/* nest - of results: */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_CABLE_TEST_TDR_NTF_CNT,
> +	ETHTOOL_A_CABLE_TEST_TDR_NTF_MAX = __ETHTOOL_A_CABLE_TEST_TDR_NTF_CNT - 1
> +};
> +
>  /* generic netlink info */
>  #define ETHTOOL_GENL_NAME "ethtool"
>  #define ETHTOOL_GENL_VERSION 1
> diff --git a/uapi/linux/genetlink.h b/uapi/linux/genetlink.h
> index 1317119..7c6c390 100644
> --- a/uapi/linux/genetlink.h
> +++ b/uapi/linux/genetlink.h
> @@ -48,6 +48,7 @@ enum {
>  	CTRL_CMD_NEWMCAST_GRP,
>  	CTRL_CMD_DELMCAST_GRP,
>  	CTRL_CMD_GETMCAST_GRP, /* unused */
> +	CTRL_CMD_GETPOLICY,
>  	__CTRL_CMD_MAX,
>  };
>  
> @@ -62,6 +63,7 @@ enum {
>  	CTRL_ATTR_MAXATTR,
>  	CTRL_ATTR_OPS,
>  	CTRL_ATTR_MCAST_GROUPS,
> +	CTRL_ATTR_POLICY,
>  	__CTRL_ATTR_MAX,
>  };
>  
> diff --git a/uapi/linux/if_link.h b/uapi/linux/if_link.h
> index cb88bcb..a8901a3 100644
> --- a/uapi/linux/if_link.h
> +++ b/uapi/linux/if_link.h
> @@ -341,6 +341,7 @@ enum {
>  	IFLA_BRPORT_NEIGH_SUPPRESS,
>  	IFLA_BRPORT_ISOLATED,
>  	IFLA_BRPORT_BACKUP_PORT,
> +	IFLA_BRPORT_MRP_RING_OPEN,
>  	__IFLA_BRPORT_MAX
>  };
>  #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
> @@ -461,6 +462,7 @@ enum {
>  	IFLA_MACSEC_REPLAY_PROTECT,
>  	IFLA_MACSEC_VALIDATION,
>  	IFLA_MACSEC_PAD,
> +	IFLA_MACSEC_OFFLOAD,
>  	__IFLA_MACSEC_MAX,
>  };
>  
> @@ -487,6 +489,7 @@ enum macsec_validation_type {
>  enum macsec_offload {
>  	MACSEC_OFFLOAD_OFF = 0,
>  	MACSEC_OFFLOAD_PHY = 1,
> +	MACSEC_OFFLOAD_MAC = 2,
>  	__MACSEC_OFFLOAD_END,
>  	MACSEC_OFFLOAD_MAX = __MACSEC_OFFLOAD_END - 1,
>  };
> @@ -970,11 +973,12 @@ enum {
>  #define XDP_FLAGS_SKB_MODE		(1U << 1)
>  #define XDP_FLAGS_DRV_MODE		(1U << 2)
>  #define XDP_FLAGS_HW_MODE		(1U << 3)
> +#define XDP_FLAGS_REPLACE		(1U << 4)
>  #define XDP_FLAGS_MODES			(XDP_FLAGS_SKB_MODE | \
>  					 XDP_FLAGS_DRV_MODE | \
>  					 XDP_FLAGS_HW_MODE)
>  #define XDP_FLAGS_MASK			(XDP_FLAGS_UPDATE_IF_NOEXIST | \
> -					 XDP_FLAGS_MODES)
> +					 XDP_FLAGS_MODES | XDP_FLAGS_REPLACE)
>  
>  /* These are stored into IFLA_XDP_ATTACHED on dump. */
>  enum {
> @@ -994,6 +998,7 @@ enum {
>  	IFLA_XDP_DRV_PROG_ID,
>  	IFLA_XDP_SKB_PROG_ID,
>  	IFLA_XDP_HW_PROG_ID,
> +	IFLA_XDP_EXPECTED_FD,
>  	__IFLA_XDP_MAX,
>  };
>  
> diff --git a/uapi/linux/net_tstamp.h b/uapi/linux/net_tstamp.h
> index f96e650..7ed0b3d 100644
> --- a/uapi/linux/net_tstamp.h
> +++ b/uapi/linux/net_tstamp.h
> @@ -98,6 +98,9 @@ enum hwtstamp_tx_types {
>  	 * receive a time stamp via the socket error queue.
>  	 */
>  	HWTSTAMP_TX_ONESTEP_P2P,
> +
> +	/* add new constants above here */
> +	__HWTSTAMP_TX_CNT
>  };
>  
>  /* possible values for hwtstamp_config->rx_filter */
> @@ -140,6 +143,9 @@ enum hwtstamp_rx_filters {
>  
>  	/* NTP, UDP, all versions and packet modes */
>  	HWTSTAMP_FILTER_NTP_ALL,
> +
> +	/* add new constants above here */
> +	__HWTSTAMP_FILTER_CNT
>  };
>  
>  /* SCM_TIMESTAMPING_PKTINFO control message */
> diff --git a/uapi/linux/netlink.h b/uapi/linux/netlink.h
> index 2c28d32..695c88e 100644
> --- a/uapi/linux/netlink.h
> +++ b/uapi/linux/netlink.h
> @@ -245,4 +245,107 @@ struct nla_bitfield32 {
>  	__u32 selector;
>  };
>  
> +/*
> + * policy descriptions - it's specific to each family how this is used
> + * Normally, it should be retrieved via a dump inside another attribute
> + * specifying where it applies.
> + */
> +
> +/**
> + * enum netlink_attribute_type - type of an attribute
> + * @NL_ATTR_TYPE_INVALID: unused
> + * @NL_ATTR_TYPE_FLAG: flag attribute (present/not present)
> + * @NL_ATTR_TYPE_U8: 8-bit unsigned attribute
> + * @NL_ATTR_TYPE_U16: 16-bit unsigned attribute
> + * @NL_ATTR_TYPE_U32: 32-bit unsigned attribute
> + * @NL_ATTR_TYPE_U64: 64-bit unsigned attribute
> + * @NL_ATTR_TYPE_S8: 8-bit signed attribute
> + * @NL_ATTR_TYPE_S16: 16-bit signed attribute
> + * @NL_ATTR_TYPE_S32: 32-bit signed attribute
> + * @NL_ATTR_TYPE_S64: 64-bit signed attribute
> + * @NL_ATTR_TYPE_BINARY: binary data, min/max length may be specified
> + * @NL_ATTR_TYPE_STRING: string, min/max length may be specified
> + * @NL_ATTR_TYPE_NUL_STRING: NUL-terminated string,
> + *	min/max length may be specified
> + * @NL_ATTR_TYPE_NESTED: nested, i.e. the content of this attribute
> + *	consists of sub-attributes. The nested policy and maxtype
> + *	inside may be specified.
> + * @NL_ATTR_TYPE_NESTED_ARRAY: nested array, i.e. the content of this
> + *	attribute contains sub-attributes whose type is irrelevant
> + *	(just used to separate the array entries) and each such array
> + *	entry has attributes again, the policy for those inner ones
> + *	and the corresponding maxtype may be specified.
> + * @NL_ATTR_TYPE_BITFIELD32: &struct nla_bitfield32 attribute
> + */
> +enum netlink_attribute_type {
> +	NL_ATTR_TYPE_INVALID,
> +
> +	NL_ATTR_TYPE_FLAG,
> +
> +	NL_ATTR_TYPE_U8,
> +	NL_ATTR_TYPE_U16,
> +	NL_ATTR_TYPE_U32,
> +	NL_ATTR_TYPE_U64,
> +
> +	NL_ATTR_TYPE_S8,
> +	NL_ATTR_TYPE_S16,
> +	NL_ATTR_TYPE_S32,
> +	NL_ATTR_TYPE_S64,
> +
> +	NL_ATTR_TYPE_BINARY,
> +	NL_ATTR_TYPE_STRING,
> +	NL_ATTR_TYPE_NUL_STRING,
> +
> +	NL_ATTR_TYPE_NESTED,
> +	NL_ATTR_TYPE_NESTED_ARRAY,
> +
> +	NL_ATTR_TYPE_BITFIELD32,
> +};
> +
> +/**
> + * enum netlink_policy_type_attr - policy type attributes
> + * @NL_POLICY_TYPE_ATTR_UNSPEC: unused
> + * @NL_POLICY_TYPE_ATTR_TYPE: type of the attribute,
> + *	&enum netlink_attribute_type (U32)
> + * @NL_POLICY_TYPE_ATTR_MIN_VALUE_S: minimum value for signed
> + *	integers (S64)
> + * @NL_POLICY_TYPE_ATTR_MAX_VALUE_S: maximum value for signed
> + *	integers (S64)
> + * @NL_POLICY_TYPE_ATTR_MIN_VALUE_U: minimum value for unsigned
> + *	integers (U64)
> + * @NL_POLICY_TYPE_ATTR_MAX_VALUE_U: maximum value for unsigned
> + *	integers (U64)
> + * @NL_POLICY_TYPE_ATTR_MIN_LENGTH: minimum length for binary
> + *	attributes, no minimum if not given (U32)
> + * @NL_POLICY_TYPE_ATTR_MAX_LENGTH: maximum length for binary
> + *	attributes, no maximum if not given (U32)
> + * @NL_POLICY_TYPE_ATTR_POLICY_IDX: sub policy for nested and
> + *	nested array types (U32)
> + * @NL_POLICY_TYPE_ATTR_POLICY_MAXTYPE: maximum sub policy
> + *	attribute for nested and nested array types, this can
> + *	in theory be < the size of the policy pointed to by
> + *	the index, if limited inside the nesting (U32)
> + * @NL_POLICY_TYPE_ATTR_BITFIELD32_MASK: valid mask for the
> + *	bitfield32 type (U32)
> + * @NL_POLICY_TYPE_ATTR_PAD: pad attribute for 64-bit alignment
> + */
> +enum netlink_policy_type_attr {
> +	NL_POLICY_TYPE_ATTR_UNSPEC,
> +	NL_POLICY_TYPE_ATTR_TYPE,
> +	NL_POLICY_TYPE_ATTR_MIN_VALUE_S,
> +	NL_POLICY_TYPE_ATTR_MAX_VALUE_S,
> +	NL_POLICY_TYPE_ATTR_MIN_VALUE_U,
> +	NL_POLICY_TYPE_ATTR_MAX_VALUE_U,
> +	NL_POLICY_TYPE_ATTR_MIN_LENGTH,
> +	NL_POLICY_TYPE_ATTR_MAX_LENGTH,
> +	NL_POLICY_TYPE_ATTR_POLICY_IDX,
> +	NL_POLICY_TYPE_ATTR_POLICY_MAXTYPE,
> +	NL_POLICY_TYPE_ATTR_BITFIELD32_MASK,
> +	NL_POLICY_TYPE_ATTR_PAD,
> +
> +	/* keep last */
> +	__NL_POLICY_TYPE_ATTR_MAX,
> +	NL_POLICY_TYPE_ATTR_MAX = __NL_POLICY_TYPE_ATTR_MAX - 1
> +};
> +
>  #endif /* __LINUX_NETLINK_H */
> diff --git a/uapi/linux/rtnetlink.h b/uapi/linux/rtnetlink.h
> index 9d802cd..bcb1ba4 100644
> --- a/uapi/linux/rtnetlink.h
> +++ b/uapi/linux/rtnetlink.h
> @@ -609,11 +609,17 @@ enum {
>  	TCA_HW_OFFLOAD,
>  	TCA_INGRESS_BLOCK,
>  	TCA_EGRESS_BLOCK,
> +	TCA_DUMP_FLAGS,
>  	__TCA_MAX
>  };
>  
>  #define TCA_MAX (__TCA_MAX - 1)
>  
> +#define TCA_DUMP_FLAGS_TERSE (1 << 0) /* Means that in dump user gets only basic
> +				       * data necessary to identify the objects
> +				       * (handle, cookie, etc.) and stats.
> +				       */
> +
>  #define TCA_RTA(r)  ((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct tcmsg))))
>  #define TCA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct tcmsg))
>  
> -- 
> 2.27.0
> 
