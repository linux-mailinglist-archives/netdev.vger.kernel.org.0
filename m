Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02801443FFD
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 11:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbhKCKcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 06:32:54 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:37352 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbhKCKcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 06:32:53 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7F1401FD3E;
        Wed,  3 Nov 2021 10:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635935416; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4CixbcA1fcKFlHfpXgPsuz/rR6R/cO1Mxmys3G5q3kE=;
        b=n5rPLREGulIXODoMKmCEM1hjwTnA34oUlMj+qIsQPk4F4IEd7Axim+tapvJj24AE1lkw3e
        tF4gVzdqRAfMftj2xX6CD/qBdJzurzbWV41RrGCktcfdAQoTDbNWgX9nq2oRzd5rV2//NS
        Qd4N1OJ0GrfqwCBkiM+2EXBbBZpwxcQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635935416;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4CixbcA1fcKFlHfpXgPsuz/rR6R/cO1Mxmys3G5q3kE=;
        b=LSiYf8/8ga9b577bMKWhLwHXavR3eg4xu420k/FZSJflBU1puU5AoAtRYdYEMQtHQjXopA
        UAjT999VpjMJ7YAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B364D13CE7;
        Wed,  3 Nov 2021 10:30:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id XabYKLdkgmGVFAAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Wed, 03 Nov 2021 10:30:15 +0000
Subject: Re: [PATCH net v2] net: marvell: prestera: fix hw structure laid out
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>, kuba@kernel.org,
        andrew@lunn.ch
Cc:     mickeyr@marvell.com, serhiy.pshyk@plvision.eu,
        taras.chornyi@plvision.eu, Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vadym Kochan <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1635933244-6553-1-git-send-email-volodymyr.mytnyk@plvision.eu>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <800dcc0c-0aba-9fef-deaf-faf41b79aa01@suse.de>
Date:   Wed, 3 Nov 2021 13:30:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1635933244-6553-1-git-send-email-volodymyr.mytnyk@plvision.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/3/21 12:54 PM, Volodymyr Mytnyk пишет:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
> 
> - fix structure laid out discussed in:
>      [PATCH net-next v4] net: marvell: prestera: add firmware v4.0 support
>      https://www.spinics.net/lists/kernel/msg4127689.html
> 
> - fix review comments discussed in:
>      [PATCH] [-next] net: marvell: prestera: Add explicit padding
>      https://www.spinics.net/lists/kernel/msg4130293.html
> 
> - fix patchwork issues
> - rebase on net master
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: bb5dbf2cc64d ("net: marvell: prestera: add firmware v4.0 support")
> Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
> ---
>   .../ethernet/marvell/prestera/prestera_ethtool.c   |   3 +-
>   .../net/ethernet/marvell/prestera/prestera_hw.c    | 129 +++++++++++----------
>   .../net/ethernet/marvell/prestera/prestera_main.c  |   6 +-
>   .../net/ethernet/marvell/prestera/prestera_pci.c   |   3 +-
>   4 files changed, 75 insertions(+), 66 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
> index 6011454dba71..40d5b89573bb 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
> @@ -499,7 +499,8 @@ static void prestera_port_mdix_get(struct ethtool_link_ksettings *ecmd,
>   {
>   	struct prestera_port_phy_state *state = &port->state_phy;
>   
> -	if (prestera_hw_port_phy_mode_get(port, &state->mdix, NULL, NULL, NULL)) {
> +	if (prestera_hw_port_phy_mode_get(port,
> +					  &state->mdix, NULL, NULL, NULL)) {
>   		netdev_warn(port->dev, "MDIX params get failed");
>   		state->mdix = ETH_TP_MDI_INVALID;
>   	}
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> index 4f5f52dcdd9d..fb0f17c9352f 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> @@ -180,109 +180,113 @@ struct prestera_msg_common_resp {
>   	struct prestera_msg_ret ret;
>   };
>   
> -union prestera_msg_switch_param {
> -	u8 mac[ETH_ALEN];
> -	__le32 ageing_timeout_ms;
> -} __packed;
> -
>   struct prestera_msg_switch_attr_req {
>   	struct prestera_msg_cmd cmd;
>   	__le32 attr;
> -	union prestera_msg_switch_param param;
> -	u8 pad[2];
> +	union {
> +		__le32 ageing_timeout_ms;
> +		struct {
> +			u8 mac[ETH_ALEN];
> +			u8 __pad[2];
> +		};
> +	} param;
>   };
>   
>   struct prestera_msg_switch_init_resp {
>   	struct prestera_msg_ret ret;
>   	__le32 port_count;
>   	__le32 mtu_max;
> -	u8  switch_id;
> -	u8  lag_max;
> -	u8  lag_member_max;
>   	__le32 size_tbl_router_nexthop;
> -} __packed __aligned(4);
> +	u8 switch_id;
> +	u8 lag_max;
> +	u8 lag_member_max;
> +};
>   
>   struct prestera_msg_event_port_param {
>   	union {
>   		struct {
> -			u8 oper;
>   			__le32 mode;
>   			__le32 speed;
> +			u8 oper;
>   			u8 duplex;
>   			u8 fc;
>   			u8 fec;
> -		} __packed mac;
> +		} mac;
>   		struct {
> -			u8 mdix;
>   			__le64 lmode_bmap;
> +			u8 mdix;
>   			u8 fc;
> +			u8 __pad[2];
>   		} __packed phy;
>   	} __packed;
> -} __packed __aligned(4);
> +} __packed;
>   
>   struct prestera_msg_port_cap_param {
>   	__le64 link_mode;
> -	u8  type;
> -	u8  fec;
> -	u8  fc;
> -	u8  transceiver;
> -};
> +	u8 type;
> +	u8 fec;
> +	u8 fc;
> +	u8 transceiver;
> +} __packed;
>   
>   struct prestera_msg_port_flood_param {
>   	u8 type;
>   	u8 enable;
> -};
> +	u8 __pad[2];
> +} __packed;
>   
>   union prestera_msg_port_param {
> +	__le32 mtu;
> +	__le32 speed;
> +	__le32 link_mode;
>   	u8 admin_state;
>   	u8 oper_state;
> -	__le32 mtu;
>   	u8 mac[ETH_ALEN];
>   	u8 accept_frm_type;
> -	__le32 speed;
>   	u8 learning;
>   	u8 flood;
> -	__le32 link_mode;
>   	u8 type;
>   	u8 duplex;
>   	u8 fec;
>   	u8 fc;
> -
>   	union {
>   		struct {
> -			u8 admin:1;
> +			u8 admin;
>   			u8 fc;
>   			u8 ap_enable;
> +			u8 __reserved;
>   			union {
>   				struct {
>   					__le32 mode;
> -					u8  inband:1;
>   					__le32 speed;
> -					u8  duplex;
> -					u8  fec;
> -					u8  fec_supp;
> -				} __packed reg_mode;
> +					u8 inband;
> +					u8 duplex;
> +					u8 fec;
> +					u8 fec_supp;
> +				} reg_mode;
>   				struct {
>   					__le32 mode;
>   					__le32 speed;
> -					u8  fec;
> -					u8  fec_supp;
> -				} __packed ap_modes[PRESTERA_AP_PORT_MAX];
> -			} __packed;
> -		} __packed mac;
> +					u8 fec;
> +					u8 fec_supp;
> +					u8 __pad[2];
> +				} ap_modes[PRESTERA_AP_PORT_MAX];
> +			};
> +		} mac;
>   		struct {
> -			u8 admin:1;
> -			u8 adv_enable;
>   			__le64 modes;
>   			__le32 mode;
> +			u8 admin;
> +			u8 adv_enable;
>   			u8 mdix;
> -		} __packed phy;
> +			u8 __pad;
> +		} phy;
>   	} __packed link;
>   
>   	struct prestera_msg_port_cap_param cap;
>   	struct prestera_msg_port_flood_param flood_ext;
>   	struct prestera_msg_event_port_param link_evt;
> -} __packed;
> +};
>   
>   struct prestera_msg_port_attr_req {
>   	struct prestera_msg_cmd cmd;
> @@ -290,14 +294,12 @@ struct prestera_msg_port_attr_req {
>   	__le32 port;
>   	__le32 dev;
>   	union prestera_msg_port_param param;
> -} __packed __aligned(4);
> -
> +};
>   
>   struct prestera_msg_port_attr_resp {
>   	struct prestera_msg_ret ret;
>   	union prestera_msg_port_param param;
> -} __packed __aligned(4);
> -
> +};
>   
>   struct prestera_msg_port_stats_resp {
>   	struct prestera_msg_ret ret;
> @@ -322,13 +324,13 @@ struct prestera_msg_vlan_req {
>   	__le32 port;
>   	__le32 dev;
>   	__le16 vid;
> -	u8  is_member;
> -	u8  is_tagged;
> +	u8 is_member;
> +	u8 is_tagged;
>   };
>   
>   struct prestera_msg_fdb_req {
>   	struct prestera_msg_cmd cmd;
> -	u8 dest_type;
> +	__le32 flush_mode;
>   	union {
>   		struct {
>   			__le32 port;
> @@ -336,11 +338,12 @@ struct prestera_msg_fdb_req {
>   		};
>   		__le16 lag_id;
>   	} dest;
> -	u8  mac[ETH_ALEN];
>   	__le16 vid;
> -	u8  dynamic;
> -	__le32 flush_mode;
> -} __packed __aligned(4);
> +	u8 dest_type;
> +	u8 dynamic;
> +	u8 mac[ETH_ALEN];
> +	u8 __pad[2];
> +};
>   
>   struct prestera_msg_bridge_req {
>   	struct prestera_msg_cmd cmd;
> @@ -383,7 +386,7 @@ struct prestera_msg_acl_match {
>   		struct {
>   			u8 key[ETH_ALEN];
>   			u8 mask[ETH_ALEN];
> -		} __packed mac;
> +		} mac;
>   	} keymask;
>   };
>   
> @@ -446,7 +449,8 @@ struct prestera_msg_stp_req {
>   	__le32 port;
>   	__le32 dev;
>   	__le16 vid;
> -	u8  state;
> +	u8 state;
> +	u8 __pad;
>   };
>   
>   struct prestera_msg_rxtx_req {
> @@ -497,21 +501,21 @@ union prestera_msg_event_fdb_param {
>   
>   struct prestera_msg_event_fdb {
>   	struct prestera_msg_event id;
> -	u8 dest_type;
> +	__le32 vid;
>   	union {
>   		__le32 port_id;
>   		__le16 lag_id;
>   	} dest;
> -	__le32 vid;
>   	union prestera_msg_event_fdb_param param;
> -} __packed __aligned(4);
> +	u8 dest_type;
> +};
>   
> -static inline void prestera_hw_build_tests(void)
> +static void prestera_hw_build_tests(void)
>   {
>   	/* check requests */
>   	BUILD_BUG_ON(sizeof(struct prestera_msg_common_req) != 4);
>   	BUILD_BUG_ON(sizeof(struct prestera_msg_switch_attr_req) != 16);
> -	BUILD_BUG_ON(sizeof(struct prestera_msg_port_attr_req) != 120);
> +	BUILD_BUG_ON(sizeof(struct prestera_msg_port_attr_req) != 140);
>   	BUILD_BUG_ON(sizeof(struct prestera_msg_port_info_req) != 8);
>   	BUILD_BUG_ON(sizeof(struct prestera_msg_vlan_req) != 16);
>   	BUILD_BUG_ON(sizeof(struct prestera_msg_fdb_req) != 28);
> @@ -528,7 +532,7 @@ static inline void prestera_hw_build_tests(void)
>   	/* check responses */
>   	BUILD_BUG_ON(sizeof(struct prestera_msg_common_resp) != 8);
>   	BUILD_BUG_ON(sizeof(struct prestera_msg_switch_init_resp) != 24);
> -	BUILD_BUG_ON(sizeof(struct prestera_msg_port_attr_resp) != 112);
> +	BUILD_BUG_ON(sizeof(struct prestera_msg_port_attr_resp) != 132);
>   	BUILD_BUG_ON(sizeof(struct prestera_msg_port_stats_resp) != 248);
>   	BUILD_BUG_ON(sizeof(struct prestera_msg_port_info_resp) != 20);
>   	BUILD_BUG_ON(sizeof(struct prestera_msg_bridge_resp) != 12);
> @@ -561,9 +565,9 @@ static int __prestera_cmd_ret(struct prestera_switch *sw,
>   	if (err)
>   		return err;
>   
> -	if (__le32_to_cpu(ret->cmd.type) != PRESTERA_CMD_TYPE_ACK)
> +	if (ret->cmd.type != __cpu_to_le32(PRESTERA_CMD_TYPE_ACK))
>   		return -EBADE;
> -	if (__le32_to_cpu(ret->status) != PRESTERA_CMD_ACK_OK)
> +	if (ret->status != __cpu_to_le32(PRESTERA_CMD_ACK_OK))
>   		return -EINVAL;
>   
>   	return 0;
> @@ -1356,7 +1360,8 @@ int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed)
>   int prestera_hw_port_autoneg_restart(struct prestera_port *port)
>   {
>   	struct prestera_msg_port_attr_req req = {
> -		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_PHY_AUTONEG_RESTART),
> +		.attr =
> +		    __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_PHY_AUTONEG_RESTART),

All the newline changes are unrelated to the structure layout chnages.
Send them as a separate patch.


>   		.port = __cpu_to_le32(port->hw_id),
>   		.dev = __cpu_to_le32(port->dev_id),
>   	};
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> index 625b40149fac..4369a3ffad45 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> @@ -405,7 +405,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
>   
>   	err = prestera_port_cfg_mac_write(port, &cfg_mac);
>   	if (err) {
> -		dev_err(prestera_dev(sw), "Failed to set port(%u) mac mode\n", id);
> +		dev_err(prestera_dev(sw),
> +			"Failed to set port(%u) mac mode\n", id);
>   		goto err_port_init;
>   	}
>   
> @@ -418,7 +419,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
>   						    false, 0, 0,
>   						    port->cfg_phy.mdix);
>   		if (err) {
> -			dev_err(prestera_dev(sw), "Failed to set port(%u) phy mode\n", id);
> +			dev_err(prestera_dev(sw),
> +				"Failed to set port(%u) phy mode\n", id);
>   			goto err_port_init;
>   		}
>   	}
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> index 5d4d410b07c8..461259b3655a 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> @@ -411,7 +411,8 @@ static int prestera_fw_cmd_send(struct prestera_fw *fw, int qid,
>   		goto cmd_exit;
>   	}
>   
> -	memcpy_fromio(out_msg, prestera_fw_cmdq_buf(fw, qid) + in_size, ret_size);
> +	memcpy_fromio(out_msg,
> +		      prestera_fw_cmdq_buf(fw, qid) + in_size, ret_size);
>   
>   cmd_exit:
>   	prestera_fw_write(fw, PRESTERA_CMDQ_REQ_CTL_REG(qid),
> 
