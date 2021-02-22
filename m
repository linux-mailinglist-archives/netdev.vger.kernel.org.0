Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10E1321348
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 10:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhBVJmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 04:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbhBVJm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 04:42:27 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0174C061574
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 01:41:46 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id o82so12887829wme.1
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 01:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+He7lR/QL7iSbm3u0/i4ks4Lr6FJ+ApjTm3INBRKeu8=;
        b=KRbzsymt+s8JijZlasajHTv0dqj05YrL7SXdS532yYB3A53SCHRDGxJqQXx1c0ib6S
         Nl7hdVnRUDqzrlkyeEENK/n10qT+aSe4AxnBJ3fR++aH/rmzE2U5IPNvsqPxxj3mH0ml
         EyL8UFu5EAG8tj0kjml1rb4SJRUSxdAui9yWaxfw78PZKrTWvpn1qvnAmlZzhdjlm/Ga
         FTB9zWg7dAzRczy+J1JKe9iKJnY8kVAbNGYJI0DKJN16ohp6Ma5rncM7AxDayzYom3Hh
         s4jl+LMNPEqXBOIDKFduvMm8xBNK6hjofNKVpJP5y/I+q+LffqDTgcIH61NT9Pxm6tvP
         7GuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+He7lR/QL7iSbm3u0/i4ks4Lr6FJ+ApjTm3INBRKeu8=;
        b=qQV6fo+tP+fHKtlndGyHZetexJSB4wKZIlpE0y1mZ5AfkBhCYgS2J60FSdFYZtN6oj
         7rpqYL4s0Ovg4V5t8XQMqDTvw9a4r+soBAUA1pn3C1XmioVQohU0FY43Tul4NhL9xCwR
         apEM7nUWspCvNu1WOnHBO9wEV4hW2zhgjp0Ly2YvuIcd6DNrHmSopaqDSCJHGcTh/an0
         f7yxPBOKiqoq0YL2ixKLBoDKSLz87YC8zDpIRwmubVLFs0jNOv59TBJJMPDrpYtjXWjx
         2/cO3W8V1lLpcJKtG3DUU6Voj/hkDImBZkb9yQ/w+U0TQancuNEal47IO+9hdwJOJFd0
         xBOw==
X-Gm-Message-State: AOAM532eiNUghny2TytceQZi8pvVYpYzWu7rU6eUtsa2NHylzfjJrbPo
        ooYiJAUH4ETv2nyeaVdopuBv2NoYnjA=
X-Google-Smtp-Source: ABdhPJxxH58Lda2jTaKrArhopSag5uU0lB5i0IjdA62Lowk1xqPFr2Y1VSuEDDohQPXu4zUuU1lQgg==
X-Received: by 2002:a05:600c:19cf:: with SMTP id u15mr19293742wmq.139.1613986905575;
        Mon, 22 Feb 2021 01:41:45 -0800 (PST)
Received: from [192.168.1.101] ([37.171.239.209])
        by smtp.gmail.com with ESMTPSA id v9sm24026037wrn.86.2021.02.22.01.41.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 01:41:45 -0800 (PST)
Subject: Re: [PATCH net-next v4 3/8] ethtool: Get link mode in use instead of
 speed and duplex parameters
To:     Danielle Ratson <danieller@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com
References: <20210202180612.325099-1-danieller@nvidia.com>
 <20210202180612.325099-4-danieller@nvidia.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <672f3968-fb26-3af5-de23-219ea9411765@gmail.com>
Date:   Mon, 22 Feb 2021 10:41:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210202180612.325099-4-danieller@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/2/21 7:06 PM, Danielle Ratson wrote:
> Currently, when user space queries the link's parameters, as speed and
> duplex, each parameter is passed from the driver to ethtool.
> 
> Instead, get the link mode bit in use, and derive each of the parameters
> from it in ethtool.
> 
> Signed-off-by: Danielle Ratson <danieller@nvidia.com>
> ---
> 
> Notes:
>     v3:
>     	* Remove 'ETHTOOL_A_LINKMODES_LINK_MODE' from Documentation since
>     	  it is not used.
>     	* Remove LINK_MODE_UNKNOWN from uapi.
>     	* Remove an unnecessary loop.
>     	* Move link_mode_info and link_mode_params to common file.
>     	* Move the speed, duplex and lanes derivation to the wrapper
>     	  __ethtool_get_link_ksettings().
> 
>  include/linux/ethtool.h |   1 +
>  net/ethtool/common.c    | 147 +++++++++++++++++++++++++++++++++++++
>  net/ethtool/common.h    |   7 ++
>  net/ethtool/ioctl.c     |  18 ++++-
>  net/ethtool/linkmodes.c | 157 +---------------------------------------
>  5 files changed, 174 insertions(+), 156 deletions(-)
> 
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index 1ab13c5dfb2f..ec4cd3921c67 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -129,6 +129,7 @@ struct ethtool_link_ksettings {
>  		__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising);
>  	} link_modes;
>  	u32	lanes;
> +	enum ethtool_link_mode_bit_indices link_mode;

Some drivers blindly use ethtool_link_ksettings without
knowing a new field has been added.

(See below)

>  };
>  
>  /**
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index 181220101a6e..835b9bba3e7e 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -198,6 +198,153 @@ const char link_mode_names[][ETH_GSTRING_LEN] = {
>  };
>  static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
>  
> +#define __LINK_MODE_LANES_CR		1
> +#define __LINK_MODE_LANES_CR2		2
> +#define __LINK_MODE_LANES_CR4		4
> +#define __LINK_MODE_LANES_CR8		8
> +#define __LINK_MODE_LANES_DR		1
> +#define __LINK_MODE_LANES_DR2		2
> +#define __LINK_MODE_LANES_DR4		4
> +#define __LINK_MODE_LANES_DR8		8
> +#define __LINK_MODE_LANES_KR		1
> +#define __LINK_MODE_LANES_KR2		2
> +#define __LINK_MODE_LANES_KR4		4
> +#define __LINK_MODE_LANES_KR8		8
> +#define __LINK_MODE_LANES_SR		1
> +#define __LINK_MODE_LANES_SR2		2
> +#define __LINK_MODE_LANES_SR4		4
> +#define __LINK_MODE_LANES_SR8		8
> +#define __LINK_MODE_LANES_ER		1
> +#define __LINK_MODE_LANES_KX		1
> +#define __LINK_MODE_LANES_KX4		4
> +#define __LINK_MODE_LANES_LR		1
> +#define __LINK_MODE_LANES_LR4		4
> +#define __LINK_MODE_LANES_LR4_ER4	4
> +#define __LINK_MODE_LANES_LR_ER_FR	1
> +#define __LINK_MODE_LANES_LR2_ER2_FR2	2
> +#define __LINK_MODE_LANES_LR4_ER4_FR4	4
> +#define __LINK_MODE_LANES_LR8_ER8_FR8	8
> +#define __LINK_MODE_LANES_LRM		1
> +#define __LINK_MODE_LANES_MLD2		2
> +#define __LINK_MODE_LANES_T		1
> +#define __LINK_MODE_LANES_T1		1
> +#define __LINK_MODE_LANES_X		1
> +#define __LINK_MODE_LANES_FX		1
> +
> +#define __DEFINE_LINK_MODE_PARAMS(_speed, _type, _duplex)	\
> +	[ETHTOOL_LINK_MODE(_speed, _type, _duplex)] = {		\
> +		.speed  = SPEED_ ## _speed, \
> +		.lanes  = __LINK_MODE_LANES_ ## _type, \
> +		.duplex	= __DUPLEX_ ## _duplex \
> +	}
> +#define __DUPLEX_Half DUPLEX_HALF
> +#define __DUPLEX_Full DUPLEX_FULL
> +#define __DEFINE_SPECIAL_MODE_PARAMS(_mode) \
> +	[ETHTOOL_LINK_MODE_ ## _mode ## _BIT] = { \
> +		.speed	= SPEED_UNKNOWN, \
> +		.lanes	= 0, \
> +		.duplex	= DUPLEX_UNKNOWN, \
> +	}
> +
> +const struct link_mode_info link_mode_params[] = {
> +	__DEFINE_LINK_MODE_PARAMS(10, T, Half),
> +	__DEFINE_LINK_MODE_PARAMS(10, T, Full),
> +	__DEFINE_LINK_MODE_PARAMS(100, T, Half),
> +	__DEFINE_LINK_MODE_PARAMS(100, T, Full),
> +	__DEFINE_LINK_MODE_PARAMS(1000, T, Half),
> +	__DEFINE_LINK_MODE_PARAMS(1000, T, Full),
> +	__DEFINE_SPECIAL_MODE_PARAMS(Autoneg),
> +	__DEFINE_SPECIAL_MODE_PARAMS(TP),
> +	__DEFINE_SPECIAL_MODE_PARAMS(AUI),
> +	__DEFINE_SPECIAL_MODE_PARAMS(MII),
> +	__DEFINE_SPECIAL_MODE_PARAMS(FIBRE),
> +	__DEFINE_SPECIAL_MODE_PARAMS(BNC),
> +	__DEFINE_LINK_MODE_PARAMS(10000, T, Full),
> +	__DEFINE_SPECIAL_MODE_PARAMS(Pause),
> +	__DEFINE_SPECIAL_MODE_PARAMS(Asym_Pause),
> +	__DEFINE_LINK_MODE_PARAMS(2500, X, Full),
> +	__DEFINE_SPECIAL_MODE_PARAMS(Backplane),
> +	__DEFINE_LINK_MODE_PARAMS(1000, KX, Full),
> +	__DEFINE_LINK_MODE_PARAMS(10000, KX4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(10000, KR, Full),
> +	[ETHTOOL_LINK_MODE_10000baseR_FEC_BIT] = {
> +		.speed	= SPEED_10000,
> +		.duplex = DUPLEX_FULL,
> +	},
> +	__DEFINE_LINK_MODE_PARAMS(20000, MLD2, Full),
> +	__DEFINE_LINK_MODE_PARAMS(20000, KR2, Full),
> +	__DEFINE_LINK_MODE_PARAMS(40000, KR4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(40000, CR4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(40000, SR4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(40000, LR4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(56000, KR4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(56000, CR4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(56000, SR4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(56000, LR4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(25000, CR, Full),
> +	__DEFINE_LINK_MODE_PARAMS(25000, KR, Full),
> +	__DEFINE_LINK_MODE_PARAMS(25000, SR, Full),
> +	__DEFINE_LINK_MODE_PARAMS(50000, CR2, Full),
> +	__DEFINE_LINK_MODE_PARAMS(50000, KR2, Full),
> +	__DEFINE_LINK_MODE_PARAMS(100000, KR4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(100000, SR4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(100000, CR4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(100000, LR4_ER4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(50000, SR2, Full),
> +	__DEFINE_LINK_MODE_PARAMS(1000, X, Full),
> +	__DEFINE_LINK_MODE_PARAMS(10000, CR, Full),
> +	__DEFINE_LINK_MODE_PARAMS(10000, SR, Full),
> +	__DEFINE_LINK_MODE_PARAMS(10000, LR, Full),
> +	__DEFINE_LINK_MODE_PARAMS(10000, LRM, Full),
> +	__DEFINE_LINK_MODE_PARAMS(10000, ER, Full),
> +	__DEFINE_LINK_MODE_PARAMS(2500, T, Full),
> +	__DEFINE_LINK_MODE_PARAMS(5000, T, Full),
> +	__DEFINE_SPECIAL_MODE_PARAMS(FEC_NONE),
> +	__DEFINE_SPECIAL_MODE_PARAMS(FEC_RS),
> +	__DEFINE_SPECIAL_MODE_PARAMS(FEC_BASER),
> +	__DEFINE_LINK_MODE_PARAMS(50000, KR, Full),
> +	__DEFINE_LINK_MODE_PARAMS(50000, SR, Full),
> +	__DEFINE_LINK_MODE_PARAMS(50000, CR, Full),
> +	__DEFINE_LINK_MODE_PARAMS(50000, LR_ER_FR, Full),
> +	__DEFINE_LINK_MODE_PARAMS(50000, DR, Full),
> +	__DEFINE_LINK_MODE_PARAMS(100000, KR2, Full),
> +	__DEFINE_LINK_MODE_PARAMS(100000, SR2, Full),
> +	__DEFINE_LINK_MODE_PARAMS(100000, CR2, Full),
> +	__DEFINE_LINK_MODE_PARAMS(100000, LR2_ER2_FR2, Full),
> +	__DEFINE_LINK_MODE_PARAMS(100000, DR2, Full),
> +	__DEFINE_LINK_MODE_PARAMS(200000, KR4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(200000, SR4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(200000, LR4_ER4_FR4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(200000, DR4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(200000, CR4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(100, T1, Full),
> +	__DEFINE_LINK_MODE_PARAMS(1000, T1, Full),
> +	__DEFINE_LINK_MODE_PARAMS(400000, KR8, Full),
> +	__DEFINE_LINK_MODE_PARAMS(400000, SR8, Full),
> +	__DEFINE_LINK_MODE_PARAMS(400000, LR8_ER8_FR8, Full),
> +	__DEFINE_LINK_MODE_PARAMS(400000, DR8, Full),
> +	__DEFINE_LINK_MODE_PARAMS(400000, CR8, Full),
> +	__DEFINE_SPECIAL_MODE_PARAMS(FEC_LLRS),
> +	__DEFINE_LINK_MODE_PARAMS(100000, KR, Full),
> +	__DEFINE_LINK_MODE_PARAMS(100000, SR, Full),
> +	__DEFINE_LINK_MODE_PARAMS(100000, LR_ER_FR, Full),
> +	__DEFINE_LINK_MODE_PARAMS(100000, DR, Full),
> +	__DEFINE_LINK_MODE_PARAMS(100000, CR, Full),
> +	__DEFINE_LINK_MODE_PARAMS(200000, KR2, Full),
> +	__DEFINE_LINK_MODE_PARAMS(200000, SR2, Full),
> +	__DEFINE_LINK_MODE_PARAMS(200000, LR2_ER2_FR2, Full),
> +	__DEFINE_LINK_MODE_PARAMS(200000, DR2, Full),
> +	__DEFINE_LINK_MODE_PARAMS(200000, CR2, Full),
> +	__DEFINE_LINK_MODE_PARAMS(400000, KR4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(400000, SR4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(400000, LR4_ER4_FR4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(400000, DR4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(400000, CR4, Full),
> +	__DEFINE_LINK_MODE_PARAMS(100, FX, Half),
> +	__DEFINE_LINK_MODE_PARAMS(100, FX, Full),
> +};
> +static_assert(ARRAY_SIZE(link_mode_params) == __ETHTOOL_LINK_MODE_MASK_NBITS);
> +
>  const char netif_msg_class_names[][ETH_GSTRING_LEN] = {
>  	[NETIF_MSG_DRV_BIT]		= "drv",
>  	[NETIF_MSG_PROBE_BIT]		= "probe",
> diff --git a/net/ethtool/common.h b/net/ethtool/common.h
> index 3d9251c95a8b..a9d071248698 100644
> --- a/net/ethtool/common.h
> +++ b/net/ethtool/common.h
> @@ -14,6 +14,12 @@
>  
>  #define __SOF_TIMESTAMPING_CNT (const_ilog2(SOF_TIMESTAMPING_LAST) + 1)
>  
> +struct link_mode_info {
> +	int				speed;
> +	u8				lanes;
> +	u8				duplex;
> +};
> +
>  extern const char
>  netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN];
>  extern const char
> @@ -23,6 +29,7 @@ tunable_strings[__ETHTOOL_TUNABLE_COUNT][ETH_GSTRING_LEN];
>  extern const char
>  phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN];
>  extern const char link_mode_names[][ETH_GSTRING_LEN];
> +extern const struct link_mode_info link_mode_params[];
>  extern const char netif_msg_class_names[][ETH_GSTRING_LEN];
>  extern const char wol_mode_names[][ETH_GSTRING_LEN];
>  extern const char sof_timestamping_names[][ETH_GSTRING_LEN];
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index 771688e1b0da..24783b71c584 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -426,13 +426,29 @@ struct ethtool_link_usettings {
>  int __ethtool_get_link_ksettings(struct net_device *dev,
>  				 struct ethtool_link_ksettings *link_ksettings)
>  {
> +	const struct link_mode_info *link_info;
> +	int err;
> +
>  	ASSERT_RTNL();
>  
>  	if (!dev->ethtool_ops->get_link_ksettings)
>  		return -EOPNOTSUPP;
>  
>  	memset(link_ksettings, 0, sizeof(*link_ksettings));
> -	return dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
> +
> +	link_ksettings->link_mode = -1;
> +	err = dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
> +	if (err)
> +		return err;

If a driver like drivers/net/tun.c does a complete

memcpy(cmd, &tun->link_ksettings, sizeof(*cmd)); 

then the link_ksettings->link_mode is overwritten with possible
garbage data.

> +
> +	if (link_ksettings->link_mode != -1) {
> +		link_info = &link_mode_params[link_ksettings->link_mode];
> +		link_ksettings->base.speed = link_info->speed;
> +		link_ksettings->lanes = link_info->lanes;
> +		link_ksettings->base.duplex = link_info->duplex;
> +	}
> +
> +	return 0;


general protection fault, probably for non-canonical address 0xdffffc00f14cc32c: 0000 [#1] PREEMPT SMP KASAN
KASAN: probably user-memory-access in range [0x000000078a661960-0x000000078a661967]
CPU: 0 PID: 8452 Comm: syz-executor360 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__ethtool_get_link_ksettings+0x1a3/0x3a0 net/ethtool/ioctl.c:446
Code: b7 3e fa 83 fd ff 0f 84 30 01 00 00 e8 16 b0 3e fa 48 8d 3c ed 60 d5 69 8a 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 b9
RSP: 0018:ffffc900019df7a0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888026136008 RCX: 0000000000000000
RDX: 00000000f14cc32c RSI: ffffffff873439ca RDI: 000000078a661960
RBP: 00000000ffff8880 R08: 00000000ffffffff R09: ffff88802613606f
R10: ffffffff873439bc R11: 0000000000000000 R12: 0000000000000000
R13: ffff88802613606c R14: ffff888011d0c210 R15: ffff888011d0c210
FS:  0000000000749300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004b60f0 CR3: 00000000185c2000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 linkinfo_prepare_data+0xfd/0x280 net/ethtool/linkinfo.c:37
 ethnl_default_notify+0x1dc/0x630 net/ethtool/netlink.c:586
 ethtool_notify+0xbd/0x1f0 net/ethtool/netlink.c:656
 ethtool_set_link_ksettings+0x277/0x330 net/ethtool/ioctl.c:620
 dev_ethtool+0x2b35/0x45d0 net/ethtool/ioctl.c:2842
 dev_ioctl+0x463/0xb70 net/core/dev_ioctl.c:440
 sock_do_ioctl+0x148/0x2d0 net/socket.c:1060
 sock_ioctl+0x477/0x6a0 net/socket.c:1177
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440c79
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe7a6e6fc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000440c79
RDX: 0000000020000380 RSI: 0000000000008946 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000f0b5ff R09: 0000000000f0b5ff
R10: 0000000000f0b5ff R11: 0000000000000246 R12: 00000000000109be
R13: 00007ffe7a6e6ff0 R14: 00007ffe7a6e6fe0 R15: 00007ffe7a6e6fd4
Modules linked in:
---[ end trace 881142e6c455c35b ]---
RIP: 0010:__ethtool_get_link_ksettings+0x1a3/0x3a0 net/ethtool/ioctl.c:446
Code: b7 3e fa 83 fd ff 0f 84 30 01 00 00 e8 16 b0 3e fa 48 8d 3c ed 60 d5 69 8a 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 b9
RSP: 0018:ffffc900019df7a0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888026136008 RCX: 0000000000000000
RDX: 00000000f14cc32c RSI: ffffffff873439ca RDI: 000000078a661960
RBP: 00000000ffff8880 R08: 00000000ffffffff R09: ffff88802613606f
R10: ffffffff873439bc R11: 0000000000000000 R12: 0000000000000000
R13: ffff88802613606c R14: ffff888011d0c210 R15: ffff888011d0c210
FS:  0000000000749300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4f9803d058 CR3: 00000000185c2000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000


