Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB851F0DA8
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 20:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbgFGSRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 14:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729899AbgFGSRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 14:17:47 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A0EC061A0E;
        Sun,  7 Jun 2020 11:17:47 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 185so7672502pgb.10;
        Sun, 07 Jun 2020 11:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XpY2kZxCH9QL4oU6+5uZtH7Txj1PiVjiksyugnTLYnE=;
        b=r7P5BYwq7+4EQt/BjCglS4SK9HGTBS3LZrqphI+XieGl9+03aO+MebH6pl+PSWKgVs
         eck0xA987twf9O89rzAE9wvMr9cAanY6YdhzOGKWqRYPMUGQUnJX0Ae4xqHGaKlggZo/
         +5Yv+UwpMRgJ3PP3OpPq3oD6Jq5C0B47km7IrHkIoRIzv8YGC4V3+Y3CATdbcM0addGl
         LM/QsjYkiASDHGxCYaqFW5aSVR7vTxbE2AD7kGXwxTBP4uydY4ESmDzMFPP3V591QZRM
         caCkwV7/3RPuVUhBvryN3rfGFyJcsORL4pgxC8kJ7KkpxbM4O1KXNYxqApUpxAdsAsut
         8u7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XpY2kZxCH9QL4oU6+5uZtH7Txj1PiVjiksyugnTLYnE=;
        b=nYfk85fTxClF/iRvFco4taEt6kPGdPblsGAyEGbahV3DiGN+pD7I6cgWucXuKh1sgg
         XjyyQccwTf5YHWrq5vsO26A8EsOByALtTDLrhZcxZ1fB9/AywH0D7cnNk21Xz2+aaHt6
         lk3rnjK/3dhE2OiIS77HMpMtJRSnrpRQY3joMmzIdw5FS4JybNQVrcO9AHhJvBHIYjo/
         C1xMgDdZ2+KQTWXpzggSffiufc3LcI55S2b2/LH21qulxeWfH/wFKbOtIzRvKCO575CR
         8qYRorebr4A8poQ7HCxo4pwQtznlkN0JghJOSudOLsgETkrcuk/OLzDyDjRWfAtX+OV+
         o8ug==
X-Gm-Message-State: AOAM530oYnXuXd/W8WR5jy2hW23nCj/YT93KYdhTSl5tfabsz2DBhZMi
        fgwk7Dg1PgoNevngMsAUo645UyPv
X-Google-Smtp-Source: ABdhPJwf6LEszzdRudXWWM0O0rl78mVQCV6G89tuBZ27cPQRoRCYpqcXQHXmRpFTZiah7iR/2A+Ixg==
X-Received: by 2002:a63:3c53:: with SMTP id i19mr17135190pgn.147.1591553866341;
        Sun, 07 Jun 2020 11:17:46 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id s11sm4810730pfh.204.2020.06.07.11.17.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2020 11:17:45 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 04/10] ethtool: Add link extended state
To:     Amit Cohen <amitc@mellanox.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        jiri@mellanox.com, idosch@mellanox.com, shuah@kernel.org,
        mkubecek@suse.cz, gustavo@embeddedor.com,
        cforno12@linux.vnet.ibm.com, andrew@lunn.ch,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20200607145945.30559-1-amitc@mellanox.com>
 <20200607145945.30559-5-amitc@mellanox.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <611379f0-b4eb-d3b3-383d-57d6e1373320@gmail.com>
Date:   Sun, 7 Jun 2020 11:17:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200607145945.30559-5-amitc@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/2020 7:59 AM, Amit Cohen wrote:
> Currently, drivers can only tell whether the link is up/down using
> LINKSTATE_GET, but no additional information is given.
> 
> Add attributes to LINKSTATE_GET command in order to allow drivers
> to expose the user more information in addition to link state to ease
> the debug process, for example, reason for link down state.
> 
> Extended state consists of two attributes - ext_state and ext_substate.
> The idea is to avoid 'vendor specific' states in order to prevent
> drivers to use specific ext_state that can be in the future common
> ext_state.
> 
> The substates allows drivers to add more information to the common
> ext_state. For example, vendor can expose 'Autoneg failure' as
> ext_state and add 'No partner detected during force mode' as
> ext_substate.
> 
> If a driver cannot pinpoint the extended state with the substate
> accuracy, it is free to expose only the extended state and omit the
> substate attribute.
> 
> Signed-off-by: Amit Cohen <amitc@mellanox.com>
> Reviewed-by: Petr Machata <petrm@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  include/linux/ethtool.h              | 22 +++++++++
>  include/uapi/linux/ethtool.h         | 70 ++++++++++++++++++++++++++++
>  include/uapi/linux/ethtool_netlink.h |  2 +
>  net/ethtool/linkstate.c              | 40 ++++++++++++++++
>  4 files changed, 134 insertions(+)
> 
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index a23b26eab479..48ec542f4504 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -86,6 +86,22 @@ struct net_device;
>  u32 ethtool_op_get_link(struct net_device *dev);
>  int ethtool_op_get_ts_info(struct net_device *dev, struct ethtool_ts_info *eti);
>  
> +
> +/**
> + * struct ethtool_ext_state_info - link extended state and substate.
> + */
> +struct ethtool_ext_state_info {
> +	enum ethtool_ext_state ext_state;
> +	union {
> +		enum ethtool_ext_substate_autoneg autoneg;
> +		enum ethtool_ext_substate_link_training link_training;
> +		enum ethtool_ext_substate_link_logical_mismatch link_logical_mismatch;
> +		enum ethtool_ext_substate_bad_signal_integrity bad_signal_integrity;
> +		enum ethtool_ext_substate_cable_issue cable_issue;
> +		int __ext_substate;
> +	};
> +};
> +
>  /**
>   * ethtool_rxfh_indir_default - get default value for RX flow hash indirection
>   * @index: Index in RX flow hash indirection table
> @@ -245,6 +261,10 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
>   * @get_link: Report whether physical link is up.  Will only be called if
>   *	the netdev is up.  Should usually be set to ethtool_op_get_link(),
>   *	which uses netif_carrier_ok().
> + * @get_ext_state: Report link extended state. Should set ext_state and
> + *	ext_substate (ext_substate of 0 means ext_substate is unknown,
> + *	do not attach ext_substate attribute to netlink message). If not
> + *	implemented, ext_state and ext_substate will not be sent to userspace.

For consistency with the other link-related operations, I would name
this get_link_ext_state.

>   * @get_eeprom: Read data from the device EEPROM.
>   *	Should fill in the magic field.  Don't need to check len for zero
>   *	or wraparound.  Fill in the data argument with the eeprom values
> @@ -384,6 +404,8 @@ struct ethtool_ops {
>  	void	(*set_msglevel)(struct net_device *, u32);
>  	int	(*nway_reset)(struct net_device *);
>  	u32	(*get_link)(struct net_device *);
> +	int	(*get_ext_state)(struct net_device *,
> +				 struct ethtool_ext_state_info *);
>  	int	(*get_eeprom_len)(struct net_device *);
>  	int	(*get_eeprom)(struct net_device *,
>  			      struct ethtool_eeprom *, u8 *);
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index f4662b3a9e1e..830fa0d6aebe 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -579,6 +579,76 @@ struct ethtool_pauseparam {
>  	__u32	tx_pause;
>  };
>  
> +/**
> + * enum ethtool_ext_state - link extended state
> + */
> +enum ethtool_ext_state {
> +	ETHTOOL_EXT_STATE_AUTONEG_FAILURE,
> +	ETHTOOL_EXT_STATE_LINK_TRAINING_FAILURE,
> +	ETHTOOL_EXT_STATE_LINK_LOGICAL_MISMATCH,
> +	ETHTOOL_EXT_STATE_BAD_SIGNAL_INTEGRITY,
> +	ETHTOOL_EXT_STATE_NO_CABLE,
> +	ETHTOOL_EXT_STATE_CABLE_ISSUE,
> +	ETHTOOL_EXT_STATE_EEPROM_ISSUE,

Does the EEPROM issue would indicate for instance that it was not
possile for the firmware/kernel to determine what transceiver
capabilities are supported from e.g.: a SFP or SFF EEPROM, and therefore
the link state could be down because of that. Is this the idea?

> +	ETHTOOL_EXT_STATE_CALIBRATION_FAILURE,
> +	ETHTOOL_EXT_STATE_POWER_BUDGET_EXCEEDED,
> +	ETHTOOL_EXT_STATE_OVERHEAT,
> +};
> +
> +/**
> + * enum ethtool_ext_substate_autoneg - more information in addition to
> + * ETHTOOL_EXT_STATE_AUTONEG_FAILURE.
> + */
> +enum ethtool_ext_substate_autoneg {
> +	ETHTOOL_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED = 1,
> +	ETHTOOL_EXT_SUBSTATE_AN_ACK_NOT_RECEIVED,
> +	ETHTOOL_EXT_SUBSTATE_AN_NEXT_PAGE_EXCHANGE_FAILED,
> +	ETHTOOL_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED_FORCE_MODE,
> +	ETHTOOL_EXT_SUBSTATE_AN_FEC_MISMATCH_DURING_OVERRIDE,
> +	ETHTOOL_EXT_SUBSTATE_AN_NO_HCD,
> +};
> +
> +/**
> + * enum ethtool_ext_substate_link_training - more information in addition to
> + * ETHTOOL_EXT_STATE_LINK_TRAINING_FAILURE.
> + */
> +enum ethtool_ext_substate_link_training {
> +	ETHTOOL_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED = 1,
> +	ETHTOOL_EXT_SUBSTATE_LT_KR_LINK_INHIBIT_TIMEOUT,
> +	ETHTOOL_EXT_SUBSTATE_LT_KR_LINK_PARTNER_DID_NOT_SET_RECEIVER_READY,
> +	ETHTOOL_EXT_SUBSTATE_LT_REMOTE_FAULT,
> +};

OK, so we leave it to the driver to report link sub-state information
that is relevnt to the supported/avertised link modes, such that for
instance, reporting LT_KR_FRAME_LOCK_NOT_ACQUIRED would not happen if we
were only advertising 1000baseT for instance. That sounds fair.
-- 
Florian
