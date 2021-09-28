Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D80641A5A8
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 04:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238687AbhI1CvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 22:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238590AbhI1CvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 22:51:03 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B76BC061575;
        Mon, 27 Sep 2021 19:49:24 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id h12so3533163pjj.1;
        Mon, 27 Sep 2021 19:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KdRo+Cz1avyjeJcs19XkK76tvTgy7+yGSf3K2YFwI3k=;
        b=kLTQJAYIMl0IrK3nQxWVQpYrfSV3PxQCCy4GvVBJ8QAQnS4FB7zO1J0YHOkonmCIzv
         OSCA0tMbLlwL/orYYfLfPawiBsUHJUA7XYi52C8PBz8mDjtFMp0j6L2v90Yi0dmZubrn
         izc8d2djOsOqwGAU7xfEdr0JVDQbFGdHngOp61o9+ChQcZDyjRUlfQQtb0PoB7DpYWBE
         CHWvgBObC5YNxQZFAZ2J4mNaGWbHIYesPWl4iefibLEoaXtRlIPFBEKLYwdKjkaw4Oq7
         MkhwTDe8hZ0W+I+pmkn54yyL/WbNIsz0zTIs6RnQ6GjPlOnzwmAHvbLqD6xN5qbCv9nZ
         npKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KdRo+Cz1avyjeJcs19XkK76tvTgy7+yGSf3K2YFwI3k=;
        b=NKHq57i6mE2SW+YScmofW1jM0mvcJflZVxkPkg/FQIKN5U5kK16p/K6+888IyzUWyp
         PmEtCW7kRmlMwa19mm6SHlqiBpAyeV/kaLCw+pz9aykYXx3HUjgcmFk86fkivgTHJpan
         Bp2/6iAscROTEvYUxQ5KrGVza1Uffk6yUVYYz9f+DPugme5DsUa0DB7bAJ4A/vVTl6WE
         XZXkC8ly4fMZCHIhaVTOFYrgW4Kdx0CFojIDA1LRCg0s3phHatQ+pl40lwZ83bBskH6e
         hNWe/EKvMjJkm8uREr80hMyyN6HA8e+9vaxjXRSsffKuMSM2cvgLOsiskMdvLR7NuYHQ
         VVkQ==
X-Gm-Message-State: AOAM5324T56jJGv6xaIrHWmZNpK5jj4yATMXvsYAVx6dQG5pgcgXtwt5
        8fpODgD/bc6xhWLM4tdYcew=
X-Google-Smtp-Source: ABdhPJxZJPG+esLFDCVQRqvSFj9ndW+00MnTobQgt3orU+nxh01t7r8Ots+FQA2ddImNLgPl9dHEYQ==
X-Received: by 2002:a17:902:dcca:b0:13e:4139:8f0f with SMTP id t10-20020a170902dcca00b0013e41398f0fmr2865291pll.65.1632797363938;
        Mon, 27 Sep 2021 19:49:23 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id e1sm21211592pgi.43.2021.09.27.19.49.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 19:49:23 -0700 (PDT)
Subject: Re: [PATCH net-next v1 01/21] devlink: Notify users when objects are
 accessible
To:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>, drivers@pensando.io,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Intel Corporation <linuxwwan@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        Loic Poulain <loic.poulain@linaro.org>,
        Manish Chopra <manishc@marvell.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Satanand Burla <sburla@marvell.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <cover.1632565508.git.leonro@nvidia.com>
 <0f7f201a059b24c96eac837e1f424e2483254e1c.1632565508.git.leonro@nvidia.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <97c1ba9d-52b9-5689-19ab-ad4a82e55ae2@gmail.com>
Date:   Mon, 27 Sep 2021 19:49:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <0f7f201a059b24c96eac837e1f424e2483254e1c.1632565508.git.leonro@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/25/21 4:22 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The devlink core code notified users about add/remove objects without
> relation if this object can be accessible or not. In this patch we unify
> such user visible notifications in one place.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  net/core/devlink.c | 107 +++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 93 insertions(+), 14 deletions(-)
> 
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 3ea33c689790..06edb2f1d21e 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -742,6 +742,7 @@ static void devlink_notify(struct devlink *devlink, enum devlink_command cmd)
>  	int err;
>  
>  	WARN_ON(cmd != DEVLINK_CMD_NEW && cmd != DEVLINK_CMD_DEL);
> +	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
>  
>  	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>  	if (!msg)
> @@ -1040,11 +1041,15 @@ static int devlink_nl_port_fill(struct sk_buff *msg,
>  static void devlink_port_notify(struct devlink_port *devlink_port,
>  				enum devlink_command cmd)
>  {
> +	struct devlink *devlink = devlink_port->devlink;
>  	struct sk_buff *msg;
>  	int err;
>  
>  	WARN_ON(cmd != DEVLINK_CMD_PORT_NEW && cmd != DEVLINK_CMD_PORT_DEL);
>  
> +	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
> +		return;
> +
>  	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>  	if (!msg)
>  		return;
> @@ -1055,18 +1060,19 @@ static void devlink_port_notify(struct devlink_port *devlink_port,
>  		return;
>  	}
>  
> -	genlmsg_multicast_netns(&devlink_nl_family,
> -				devlink_net(devlink_port->devlink), msg, 0,
> -				DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
> +	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink), msg,
> +				0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
>  }
>  
>  static void devlink_rate_notify(struct devlink_rate *devlink_rate,
>  				enum devlink_command cmd)
>  {
> +	struct devlink *devlink = devlink_rate->devlink;
>  	struct sk_buff *msg;
>  	int err;
>  
>  	WARN_ON(cmd != DEVLINK_CMD_RATE_NEW && cmd != DEVLINK_CMD_RATE_DEL);
> +	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));


FYI, this new warning was triggered by syzbot :

WARNING: CPU: 1 PID: 6540 at net/core/devlink.c:5158 devlink_nl_region_notify+0x184/0x1e0 net/core/devlink.c:5158
Modules linked in:
CPU: 1 PID: 6540 Comm: syz-executor.0 Not tainted 5.15.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:devlink_nl_region_notify+0x184/0x1e0 net/core/devlink.c:5158
Code: 38 41 b8 c0 0c 00 00 31 d2 48 89 ee 4c 89 e7 e8 72 1a 26 00 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e e9 01 bd 41 fa e8 fc bc 41 fa <0f> 0b e9 f7 fe ff ff e8 f0 bc 41 fa 0f 0b eb da 4c 89 e7 e8 c4 18
RSP: 0018:ffffc90002d6f658 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801f08d580 RSI: ffffffff87344e94 RDI: 0000000000000003
RBP: ffff88801ee42100 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff87344d8a R11: 0000000000000000 R12: ffff88801c1dc000
R13: 0000000000000000 R14: 000000000000002c R15: ffff88801c1dc070
FS:  0000555555e8e400(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055dd7c590310 CR3: 0000000069a09000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 devlink_region_create+0x39f/0x4c0 net/core/devlink.c:10327
 nsim_dev_dummy_region_init drivers/net/netdevsim/dev.c:481 [inline]
 nsim_dev_probe+0x5f6/0x1150 drivers/net/netdevsim/dev.c:1479
 call_driver_probe drivers/base/dd.c:517 [inline]
 really_probe+0x245/0xcc0 drivers/base/dd.c:596
 __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:751
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:781
 __device_attach_driver+0x20b/0x2f0 drivers/base/dd.c:898
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
 __device_attach+0x228/0x4a0 drivers/base/dd.c:969
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
 device_add+0xc35/0x21b0 drivers/base/core.c:3359
 nsim_bus_dev_new drivers/net/netdevsim/bus.c:435 [inline]
 new_device_store+0x48b/0x770 drivers/net/netdevsim/bus.c:302
 bus_attr_store+0x72/0xa0 drivers/base/bus.c:122
 sysfs_kf_write+0x110/0x160 fs/sysfs/file.c:139
 kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
 call_write_iter include/linux/fs.h:2163 [inline]
 new_sync_write+0x429/0x660 fs/read_write.c:507
 vfs_write+0x7cf/0xae0 fs/read_write.c:594
 ksys_write+0x12d/0x250 fs/read_write.c:647
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f328409d3ef
Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 99 fd ff ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 cc fd ff ff 48
RSP: 002b:00007ffdc6851140 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f328409d3ef
RDX: 0000000000000003 RSI: 00007ffdc6851190 RDI: 0000000000000004
RBP: 0000000000000004 R08: 0000000000000000 R09: 00007ffdc68510e0
R10: 0000000000000000 R11: 0000000000000293 R12: 00007f3284144971
R13: 00007ffdc6851190 R14: 0000000000000000 R15: 00007ffdc6851860

05:42PM


>  
>  	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>  	if (!msg)
> @@ -1078,9 +1084,8 @@ static void devlink_rate_notify(struct devlink_rate *devlink_rate,
>  		return;
>  	}
>  
> -	genlmsg_multicast_netns(&devlink_nl_family,
> -				devlink_net(devlink_rate->devlink), msg, 0,
> -				DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
> +	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink), msg,
> +				0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
>  }
>  
>  static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
> @@ -4150,6 +4155,7 @@ static void __devlink_flash_update_notify(struct devlink *devlink,
>  	WARN_ON(cmd != DEVLINK_CMD_FLASH_UPDATE &&
>  		cmd != DEVLINK_CMD_FLASH_UPDATE_END &&
>  		cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS);
> +	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
>  
>  	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>  	if (!msg)
> @@ -5145,17 +5151,18 @@ static void devlink_nl_region_notify(struct devlink_region *region,
>  				     struct devlink_snapshot *snapshot,
>  				     enum devlink_command cmd)
>  {
> +	struct devlink *devlink = region->devlink;
>  	struct sk_buff *msg;
>  
>  	WARN_ON(cmd != DEVLINK_CMD_REGION_NEW && cmd != DEVLINK_CMD_REGION_DEL);
> +	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
>  
>  	msg = devlink_nl_region_notify_build(region, snapshot, cmd, 0, 0);
>  	if (IS_ERR(msg))
>  		return;
>  
> -	genlmsg_multicast_netns(&devlink_nl_family,
> -				devlink_net(region->devlink), msg, 0,
> -				DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
> +	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink), msg,
> +				0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
>  }
>  
>  /**
> @@ -6920,10 +6927,12 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
>  static void devlink_recover_notify(struct devlink_health_reporter *reporter,
>  				   enum devlink_command cmd)
>  {
> +	struct devlink *devlink = reporter->devlink;
>  	struct sk_buff *msg;
>  	int err;
>  
>  	WARN_ON(cmd != DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
> +	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
>  
>  	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>  	if (!msg)
> @@ -6935,9 +6944,8 @@ static void devlink_recover_notify(struct devlink_health_reporter *reporter,
>  		return;
>  	}
>  
> -	genlmsg_multicast_netns(&devlink_nl_family,
> -				devlink_net(reporter->devlink),
> -				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
> +	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink), msg,
> +				0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
>  }
>  
>  void
> @@ -8955,6 +8963,68 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
>  }
>  EXPORT_SYMBOL_GPL(devlink_alloc_ns);
>  
> +static void
> +devlink_trap_policer_notify(struct devlink *devlink,
> +			    const struct devlink_trap_policer_item *policer_item,
> +			    enum devlink_command cmd);
> +static void
> +devlink_trap_group_notify(struct devlink *devlink,
> +			  const struct devlink_trap_group_item *group_item,
> +			  enum devlink_command cmd);
> +static void devlink_trap_notify(struct devlink *devlink,
> +				const struct devlink_trap_item *trap_item,
> +				enum devlink_command cmd);
> +
> +static void devlink_notify_register(struct devlink *devlink)
> +{
> +	struct devlink_trap_policer_item *policer_item;
> +	struct devlink_trap_group_item *group_item;
> +	struct devlink_trap_item *trap_item;
> +	struct devlink_port *devlink_port;
> +
> +	devlink_notify(devlink, DEVLINK_CMD_NEW);
> +	list_for_each_entry(devlink_port, &devlink->port_list, list)
> +		devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
> +
> +	list_for_each_entry(policer_item, &devlink->trap_policer_list, list)
> +		devlink_trap_policer_notify(devlink, policer_item,
> +					    DEVLINK_CMD_TRAP_POLICER_NEW);
> +
> +	list_for_each_entry(group_item, &devlink->trap_group_list, list)
> +		devlink_trap_group_notify(devlink, group_item,
> +					  DEVLINK_CMD_TRAP_GROUP_NEW);
> +
> +	list_for_each_entry(trap_item, &devlink->trap_list, list)
> +		devlink_trap_notify(devlink, trap_item, DEVLINK_CMD_TRAP_NEW);
> +
> +	devlink_params_publish(devlink);
> +}
> +
> +static void devlink_notify_unregister(struct devlink *devlink)
> +{
> +	struct devlink_trap_policer_item *policer_item;
> +	struct devlink_trap_group_item *group_item;
> +	struct devlink_trap_item *trap_item;
> +	struct devlink_port *devlink_port;
> +
> +	devlink_params_unpublish(devlink);
> +
> +	list_for_each_entry_reverse(trap_item, &devlink->trap_list, list)
> +		devlink_trap_notify(devlink, trap_item, DEVLINK_CMD_TRAP_DEL);
> +
> +	list_for_each_entry_reverse(group_item, &devlink->trap_group_list, list)
> +		devlink_trap_group_notify(devlink, group_item,
> +					  DEVLINK_CMD_TRAP_GROUP_DEL);
> +	list_for_each_entry_reverse(policer_item, &devlink->trap_policer_list,
> +				    list)
> +		devlink_trap_policer_notify(devlink, policer_item,
> +					    DEVLINK_CMD_TRAP_POLICER_DEL);
> +
> +	list_for_each_entry_reverse(devlink_port, &devlink->port_list, list)
> +		devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
> +	devlink_notify(devlink, DEVLINK_CMD_DEL);
> +}
> +
>  /**
>   *	devlink_register - Register devlink instance
>   *
> @@ -8964,7 +9034,7 @@ void devlink_register(struct devlink *devlink)
>  {
>  	mutex_lock(&devlink_mutex);
>  	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
> -	devlink_notify(devlink, DEVLINK_CMD_NEW);
> +	devlink_notify_register(devlink);
>  	mutex_unlock(&devlink_mutex);
>  }
>  EXPORT_SYMBOL_GPL(devlink_register);
> @@ -8982,7 +9052,7 @@ void devlink_unregister(struct devlink *devlink)
>  	mutex_lock(&devlink_mutex);
>  	WARN_ON(devlink_reload_supported(devlink->ops) &&
>  		devlink->reload_enabled);
> -	devlink_notify(devlink, DEVLINK_CMD_DEL);
> +	devlink_notify_unregister(devlink);
>  	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
>  	mutex_unlock(&devlink_mutex);
>  }
> @@ -10086,6 +10156,9 @@ void devlink_params_publish(struct devlink *devlink)
>  {
>  	struct devlink_param_item *param_item;
>  
> +	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
> +		return;
> +
>  	list_for_each_entry(param_item, &devlink->param_list, list) {
>  		if (param_item->published)
>  			continue;
> @@ -10631,6 +10704,8 @@ devlink_trap_group_notify(struct devlink *devlink,
>  
>  	WARN_ON_ONCE(cmd != DEVLINK_CMD_TRAP_GROUP_NEW &&
>  		     cmd != DEVLINK_CMD_TRAP_GROUP_DEL);
> +	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
> +		return;
>  
>  	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>  	if (!msg)
> @@ -10672,6 +10747,8 @@ static void devlink_trap_notify(struct devlink *devlink,
>  
>  	WARN_ON_ONCE(cmd != DEVLINK_CMD_TRAP_NEW &&
>  		     cmd != DEVLINK_CMD_TRAP_DEL);
> +	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
> +		return;
>  
>  	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>  	if (!msg)
> @@ -11053,6 +11130,8 @@ devlink_trap_policer_notify(struct devlink *devlink,
>  
>  	WARN_ON_ONCE(cmd != DEVLINK_CMD_TRAP_POLICER_NEW &&
>  		     cmd != DEVLINK_CMD_TRAP_POLICER_DEL);
> +	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
> +		return;
>  
>  	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>  	if (!msg)
> 
