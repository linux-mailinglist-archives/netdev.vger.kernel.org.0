Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD6C3F1FBC
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 20:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbhHSSQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 14:16:15 -0400
Received: from mail-bn8nam08on2076.outbound.protection.outlook.com ([40.107.100.76]:1058
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234651AbhHSSQK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 14:16:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hNad90BkWzsT437LJV0SWkymskMj8a1tNMJaKDskOHBMffLhO3vEb1Inuj/dM/NnmzPeZbSRDmMRoceVh41H79G2B56epGnWlPzXBMbyt4kFkex4cDEizPOR+5FtkrWOAVQe81Ifm+PjWhIBrpLh06F5FCz7b6qWd4QQ86Fzm6ygf/gfdXZj/R8pnQVE1Ccy/eXigW+6cbKt+hE7CzRk4UW9aPxhZyECCu7XJL5rXp0E9GoEQDDe/2rUGgpMFPdkH23VxAMpYtRGMDPePPI5iEFbbrG/QiKgETUBSGzMUZzAUIhh/X7+clE9hSpnF4jLYgBJAMdN6aHPJGbi0AH+hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESULh6Tc9zE4vvMgLpOEf1OzdD6pnPnwf6oHxl2jUzQ=;
 b=GHASyFwdFSksKCM5HWlOv320zTz4ZN8O1OsNIHJqpJbWLOpiN846tITzqD0TmOsLpZ2X5BPQXDnEsUrKjCs7wU/mrpcmiCyqYx/gdBbYkB+iwW5BmbXto1jYoPwxqGhI+8t6q/LBLMt6UwVNas1cnTC42SxafZpb/G6Vn8YUK4q3critN41KClyo0Ub0W0zWhU4ng4hsp3D3PslhUwr2re8XQgNSByjBMfSYYzZxDv5amMBuxmIBX5fjvJJaY2Eu1l34tG6yrRH1iK4ZFPV/VuoTCOg4ezjnvO9rifP2r6PsXQo46g1ENWz6aQ1RagxwhmBMqGHoe8rr06/qL9NA5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESULh6Tc9zE4vvMgLpOEf1OzdD6pnPnwf6oHxl2jUzQ=;
 b=hwvTqnFxGbl3d+yj0KGyKGlYMjC6K5qQDE3W0GzItaGDqbmAlaRQjNoROBSvwhkP5V9UNUrSEN1Xmlk2Z6YgMML+SUir/t2/PDOfPskhx5zBqVG+hD5REdcznKZi5d7uaAxWTaTH4/pi1p/cy75li3Y8LuJbAMOhKQaMcR8yKQVe3/J+tGreBiW7pBMFxB7lURrA0djnMrc29ThAVXCq3o1TaeEtXdunkgUpRqItbM7uFraayEJrbx8p0JLDxi3Jwh6BCS3SzJKxZvIjEiyZS+04VQ0c+/LMUkkzQaLuuJEA7BLbUrSt6OKADgffL8l0iS2oebyb47ccAjlYvCiNnw==
Received: from DM3PR08CA0017.namprd08.prod.outlook.com (2603:10b6:0:52::27) by
 BL1PR12MB5318.namprd12.prod.outlook.com (2603:10b6:208:31d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Thu, 19 Aug
 2021 18:15:31 +0000
Received: from DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:52:cafe::1c) by DM3PR08CA0017.outlook.office365.com
 (2603:10b6:0:52::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Thu, 19 Aug 2021 18:15:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT003.mail.protection.outlook.com (10.13.173.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 18:15:31 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 19 Aug
 2021 18:15:29 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.187.5) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 19 Aug 2021 18:15:20 +0000
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
 <20210819160723.2186424-2-vladimir.oltean@nxp.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        "Nikolay Aleksandrov" <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "Ido Schimmel" <idosch@nvidia.com>, <UNGLinuxDriver@microchip.com>,
        "Grygorii Strashko" <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        "DENG Qingfang" <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Hauke Mehrtens" <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "Sean Wang" <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "Jesse Brandeburg" <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v2 net-next 1/5] net: switchdev: move
 SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE to the blocking notifier chain
In-Reply-To: <20210819160723.2186424-2-vladimir.oltean@nxp.com>
Date:   Thu, 19 Aug 2021 21:15:17 +0300
Message-ID: <ygnh5yw1pah6.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e3ef948-0842-4229-29d8-08d9633d5499
X-MS-TrafficTypeDiagnostic: BL1PR12MB5318:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5318BC94358EB6DEA6AD9FABA0C09@BL1PR12MB5318.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LyQkEV663h+j585kgMouXrhi+sRqIT4NAI0R76tUlIPXsHXlyJCJC7zoIO6fvHZNHnMcEDSKdhMiHzYzuFT+kGk2Y7cB+rZ+TEL4flvxmaa9hN4ahokt/iKvq/YbGRYaG6FRglEOqYP8oUL/5yvO0y6s7FaFY1tglXCepRy6Gxo9ClLZAb/FiAvuX1V8HkfVirPMYC7rTS+9SqdrzwOCWCgR9jkwKHuhzcGGbC6FnjHEu60Z0oJQCtHFBheeZvCkHwmzF8iBWhdaK21fCqBv5yf0hZnqdrk6C1rYrGfWXQ1jpVNuk7Fepe56Up1rbE1v3S6fE7MA/4VnBQVsBlQpHRrxEcvPPNt0Y9qtEnVQA5HCk34iB93/azAEbR2R63BceXH/MzD4hot9YjXITZ1I61+FvUFoPfyPMNoMtoqqEKolmUa6fSqhm//Q/t2cB3JVR7+ypENQy4u+85o6g2uMSxqpumVWFFTEA3xTGOnibNRypwhR6gr1Cg0xjy9vK3of7wefy1oJK6SJaR9TFJ8LSuQmFotWoM3fFZrzqJBjzMj/twUexIUmJg4SIwRPokgSjphcphVIVBrNZLmcQTXyFXNFPb6afpbk2l14r8Urm6ZRTbpphbQtL/1Nf/1sAluf603L57Q+7XW71pKq2m7sFy+lz2vHq42i4VFLjHQgKr68MwIM9QfL7OV/sByojXi0B1MELZtUfRIyCBpaGL0Y9Q==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(83380400001)(47076005)(508600001)(316002)(7406005)(54906003)(6666004)(2906002)(5660300002)(7416002)(8936002)(7696005)(8676002)(30864003)(2616005)(26005)(4326008)(186003)(6916009)(16526019)(356005)(336012)(426003)(7636003)(36860700001)(82310400003)(36756003)(86362001)(70206006)(70586007)(579004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 18:15:31.0915
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e3ef948-0842-4229-29d8-08d9633d5499
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5318
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 19 Aug 2021 at 19:07, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> Currently, br_switchdev_fdb_notify() uses call_switchdev_notifiers (and
> br_fdb_replay() open-codes the same thing). This means that drivers
> handle the SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE events on the atomic
> switchdev notifier block.
>
> Most existing switchdev drivers either talk to firmware, or to a device
> over a bus where the I/O is sleepable (SPI, I2C, MDIO etc). So there
> exists an (anti)pattern where drivers make a sleepable context for
> offloading the given FDB entry by registering an ordered workqueue and
> scheduling work items on it, and doing all the work from there.
>
> The problem is the inherent limitation that this design imposes upon
> what a switchdev driver can do with those FDB entries.
>
> For example, a switchdev driver might want to perform FDB isolation,
> i.e. associate each FDB entry with the bridge it belongs to. Maybe the
> driver associates each bridge with a number, allocating that number when
> the first port of the driver joins that bridge, and freeing it when the
> last port leaves it.
>
> And this is where the problem is. When user space deletes a bridge and
> all the ports leave, the bridge will notify us of the deletion of all
> FDB entries in atomic context, and switchdev drivers will schedule their
> private work items on their private workqueue.
>
> The FDB entry deletion notifications will succeed, the bridge will then
> finish deleting itself, but the switchdev work items have not run yet.
> When they will eventually get scheduled, the aforementioned association
> between the bridge_dev and a number will have already been broken by the
> switchdev driver. All ports are standalone now, the bridge is a foreign
> interface!
>
> One might say "why don't you cache all your associations while you're
> still in the atomic context and they're still valid, pass them by value
> through your switchdev_work and work with the cached values as opposed
> to the current ones?"
>
> This option smells of poor design, because instead of fixing a central
> problem, we add tens of lateral workarounds to avoid it. It should be
> easier to use switchdev, not harder, and we should look at the common
> patterns which lead to code duplication and eliminate them.
>
> In this case, we must notice that
> (a) switchdev already has the concept of notifiers emitted from the fast
>     path that are still processed by drivers from blocking context. This
>     is accomplished through the SWITCHDEV_F_DEFER flag which is used by
>     e.g. SWITCHDEV_OBJ_ID_HOST_MDB.
> (b) the bridge del_nbp() function already calls switchdev_deferred_process().
>     So if we could hook into that, we could have a chance that the
>     bridge simply waits for our FDB entry offloading procedure to finish
>     before it calls netdev_upper_dev_unlink() - which is almost
>     immediately afterwards, and also when switchdev drivers typically
>     break their stateful associations between the bridge upper and
>     private data.
>
> So it is in fact possible to use switchdev's generic
> switchdev_deferred_enqueue mechanism to get a sleepable callback, and
> from there we can call_switchdev_blocking_notifiers().
>
> In the case of br_fdb_replay(), the only code path is from
> switchdev_bridge_port_offload(), which is already in blocking context.
> So we don't need to go through switchdev_deferred_enqueue, and we can
> just call the blocking notifier block directly.
>
> To preserve the same behavior as before, all drivers need to have their
> SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handlers moved from their switchdev
> atomic notifier blocks to the blocking ones. This patch attempts to make
> that trivial movement. Note that now they might schedule a work item for
> nothing (since they are now called from a work item themselves), but I
> don't have the energy or hardware to test all of them, so this will have
> to do.
>
> Note that previously, we were under rcu_read_lock() but now we're not.
> I have eyeballed the drivers that make any sort of RCU assumption and
> for the most part, enclosed them between a private pair of
> rcu_read_lock() and rcu_read_unlock(). The exception is
> qeth_l2_switchdev_event, for which adding the rcu_read_lock and properly
> calling rcu_read_unlock from all places that return would result in more
> churn than what I am about to do. This function had an apparently bogus
> comment "Called under rtnl_lock", but to me this is not quite possible,
> since this is the handler function from register_switchdev_notifier
> which is on an atomic chain. But anyway, after the rework we _are_ under
> rtnl_mutex, so just drop the _rcu from the functions used by the qeth
> driver.
>
> The RCU protection can be dropped from the other drivers when they are
> reworked to stop scheduling.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

[...]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
> index 0c38c2e319be..ea7c3f07f6fe 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
> @@ -276,6 +276,55 @@ mlx5_esw_bridge_port_obj_attr_set(struct net_device *dev,
>  	return err;
>  }
>  
> +static struct mlx5_bridge_switchdev_fdb_work *
> +mlx5_esw_bridge_init_switchdev_fdb_work(struct net_device *dev, bool add,
> +					struct switchdev_notifier_fdb_info *fdb_info,
> +					struct mlx5_esw_bridge_offloads *br_offloads);
> +
> +static int
> +mlx5_esw_bridge_fdb_event(struct net_device *dev, unsigned long event,
> +			  struct switchdev_notifier_info *info,
> +			  struct mlx5_esw_bridge_offloads *br_offloads)
> +{
> +	struct switchdev_notifier_fdb_info *fdb_info;
> +	struct mlx5_bridge_switchdev_fdb_work *work;
> +	struct mlx5_eswitch *esw = br_offloads->esw;
> +	u16 vport_num, esw_owner_vhca_id;
> +	struct net_device *upper, *rep;
> +
> +	upper = netdev_master_upper_dev_get_rcu(dev);
> +	if (!upper)
> +		return 0;
> +	if (!netif_is_bridge_master(upper))
> +		return 0;
> +
> +	rep = mlx5_esw_bridge_rep_vport_num_vhca_id_get(dev, esw,
> +							&vport_num,
> +							&esw_owner_vhca_id);
> +	if (!rep)
> +		return 0;
> +
> +	/* only handle the event on peers */
> +	if (mlx5_esw_bridge_is_local(dev, rep, esw))
> +		return 0;

This check is only needed for SWITCHDEV_FDB_DEL_TO_BRIDGE case. Here it
breaks the offload.

> +
> +	fdb_info = container_of(info, struct switchdev_notifier_fdb_info, info);
> +
> +	work = mlx5_esw_bridge_init_switchdev_fdb_work(dev,
> +						       event == SWITCHDEV_FDB_ADD_TO_DEVICE,
> +						       fdb_info,

Here FDB info can already be deallocated[1] since this is now executing
asynchronously and races with fdb_rcu_free() that is scheduled to be
called after rcu grace period by fdb_delete().

> +						       br_offloads);
> +	if (IS_ERR(work)) {
> +		WARN_ONCE(1, "Failed to init switchdev work, err=%ld",
> +			  PTR_ERR(work));
> +		return PTR_ERR(work);
> +	}
> +
> +	queue_work(br_offloads->wq, &work->work);
> +
> +	return 0;
> +}
> +
>  static int mlx5_esw_bridge_event_blocking(struct notifier_block *nb,
>  					  unsigned long event, void *ptr)
>  {
> @@ -295,6 +344,12 @@ static int mlx5_esw_bridge_event_blocking(struct notifier_block *nb,
>  	case SWITCHDEV_PORT_ATTR_SET:
>  		err = mlx5_esw_bridge_port_obj_attr_set(dev, ptr, br_offloads);
>  		break;
> +	case SWITCHDEV_FDB_ADD_TO_DEVICE:
> +	case SWITCHDEV_FDB_DEL_TO_DEVICE:
> +		rcu_read_lock();
> +		err = mlx5_esw_bridge_fdb_event(dev, event, ptr, br_offloads);
> +		rcu_read_unlock();
> +		break;
>  	default:
>  		err = 0;
>  	}
> @@ -415,9 +470,7 @@ static int mlx5_esw_bridge_switchdev_event(struct notifier_block *nb,
>  		/* only handle the event on peers */
>  		if (mlx5_esw_bridge_is_local(dev, rep, esw))
>  			break;

I really like the idea of completely remove the driver wq from FDB
handling code, but I'm not yet too familiar with bridge internals to
easily determine whether same approach can be applied to
SWITCHDEV_FDB_{ADD|DEL}_TO_BRIDGE event after this series is accepted.
It seems that all current users already generate these events from
blocking context, so would it be a trivial change for me to do in your
opinion? That would allow me to get rid of mlx5_esw_bridge_offloads->wq
in our driver.

> -		fallthrough;
> -	case SWITCHDEV_FDB_ADD_TO_DEVICE:
> -	case SWITCHDEV_FDB_DEL_TO_DEVICE:
> +
>  		fdb_info = container_of(info,
>  					struct switchdev_notifier_fdb_info,
>  					info);

[...]

[1]:
[  579.633363] ==================================================================                                              
[  579.634922] BUG: KASAN: use-after-free in mlx5_esw_bridge_init_switchdev_fdb_work+0x363/0x400 [mlx5_core]            
[  579.636969] Read of size 4 at addr ffff888130175d90 by task ip/7454                                                         
                                                                                                                               
[  579.638898] CPU: 0 PID: 7454 Comm: ip Not tainted 5.14.0-rc5+ #7                                                            
[  579.640549] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[  579.643617] Call Trace:                                                                                                     
[  579.644444]  dump_stack_lvl+0x46/0x5a                                                                                
[  579.645568]  print_address_description.constprop.0+0x1f/0x140                                                               
[  579.647195]  ? mlx5_esw_bridge_init_switchdev_fdb_work+0x363/0x400 [mlx5_core]                                              
[  579.649365]  ? mlx5_esw_bridge_init_switchdev_fdb_work+0x363/0x400 [mlx5_core]                                              
[  579.651203]  kasan_report.cold+0x83/0xdf                                                                             
[  579.652035]  ? mlx5_esw_bridge_init_switchdev_fdb_work+0x363/0x400 [mlx5_core]                                              
[  579.653570]  mlx5_esw_bridge_init_switchdev_fdb_work+0x363/0x400 [mlx5_core]                                                
[  579.655005]  mlx5_esw_bridge_event_blocking+0x346/0x610 [mlx5_core]                                                         
[  579.656328]  ? mlx5_esw_bridge_port_obj_attr_set+0x320/0x320 [mlx5_core]                                                    
[  579.657708]  ? rwsem_mark_wake+0x7e0/0x7e0                                                                                  
[  579.658599]  ? rwsem_down_read_slowpath+0x142/0xad0                                                                         
[  579.659653]  blocking_notifier_call_chain+0xdb/0x130                                                                 
[  579.660724]  ? switchdev_fdb_add_deferred+0x1b0/0x1b0                                                                       
[  579.661813]  switchdev_fdb_del_deferred+0x10c/0x1b0                                                                         
[  579.662871]  ? switchdev_fdb_add_deferred+0x1b0/0x1b0                                                                       
[  579.663964]  ? _raw_spin_lock+0xd0/0xd0                                                                              
[  579.664825]  ? switchdev_deferred_process+0x175/0x290                                                                
[  579.665912]  ? kfree+0xa8/0x420                                                                                      
[  579.666656]  switchdev_deferred_process+0x12f/0x290                                                                         
[  579.667715]  del_nbp+0x35c/0xcb0 [bridge]                                                                            
[  579.668623]  br_dev_delete+0x8d/0x190 [bridge]                                                                       
[  579.669609]  rtnl_dellink+0x2cb/0x9b0                                                                                
[  579.670456]  ? unwind_next_frame+0x11fb/0x1a40                                                                       
[  579.671431]  ? rtnl_bridge_getlink+0x650/0x650                                                                              
[  579.672403]  ? deref_stack_reg+0xe6/0x160                                                                            
[  579.673291]  ? unwind_next_frame+0x11fb/0x1a40                                                                              
[  579.674273]  ? arch_stack_walk+0x9e/0xf0                                                                             
[  579.675152]  ? mutex_lock+0xa1/0xf0                                                                                         
[  579.675947]  ? __mutex_lock_slowpath+0x10/0x10                                                                              
[  579.676922]  rtnetlink_rcv_msg+0x359/0x9a0                                                                                  
[  579.677838]  ? rtnl_calcit.isra.0+0x2b0/0x2b0                                                                        
[  579.678795]  ? ___sys_sendmsg+0xd8/0x160                                                                                    
[  579.679669]  ? __sys_sendmsg+0xb7/0x140                                                                              
[  579.680532]  ? do_syscall_64+0x3b/0x90                                                                               
[  579.681426]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae                                                              
[  579.682540]  ? kasan_save_stack+0x32/0x40                                                                            
[  579.683429]  ? kasan_save_stack+0x1b/0x40                                                                            
[  579.684321]  ? kasan_record_aux_stack+0xa3/0xb0                                                                      
[  579.685308]  ? task_work_add+0x3a/0x130                                                                              
[  579.686168]  ? fput_many.part.0+0x8c/0x110                                                                           
[  579.687071]  ? path_openat+0x1e02/0x3960                                                                                    
[  579.687944]  ? do_filp_open+0x19e/0x3e0
[  579.699734]  ? do_sys_openat2+0x122/0x360                                                                            
[  579.700627]  ? __x64_sys_openat+0x120/0x1d0                                                                          
[  579.701548]  ? do_syscall_64+0x3b/0x90                                                                               
[  579.702350]  netlink_rcv_skb+0x120/0x350                                                                             
[  579.703180]  ? rtnl_calcit.isra.0+0x2b0/0x2b0                                                                        
[  579.704084]  ? netlink_ack+0x9c0/0x9c0                                                                               
[  579.704880]  ? netlink_deliver_tap+0x7f/0x8f0                                                                        
[  579.705777]  ? _copy_from_iter+0x277/0xdb0                                                                           
[  579.706641]  netlink_unicast+0x4c6/0x7a0                                                                             
[  579.707470]  ? netlink_attachskb+0x750/0x750                                                                         
[  579.708352]  ? __build_skb_around+0x1f9/0x2b0                                                                        
[  579.709250]  ? __check_object_size+0x23e/0x300                                                                       
[  579.710171]  netlink_sendmsg+0x70a/0xbf0                                                                             
[  579.711045]  ? netlink_unicast+0x7a0/0x7a0                                                                           
[  579.711951]  ? __import_iovec+0x51/0x610                                                                             
[  579.712825]  ? netlink_unicast+0x7a0/0x7a0                                                                           
[  579.713736]  sock_sendmsg+0xe4/0x110                                                                                 
[  579.714555]  ____sys_sendmsg+0x5cf/0x7d0                                                                             
[  579.715429]  ? kernel_sendmsg+0x30/0x30                                                                              
[  579.716292]  ? __ia32_sys_recvmmsg+0x210/0x210                                                                       
[  579.717265]  ? trace_event_raw_event_mmap_lock_released+0x240/0x240                                                  
[  579.718566]  ? lru_cache_add+0x17d/0x2a0                                                                             
[  579.719440]  ? wp_page_copy+0x87c/0x1370                                                                             
[  579.720315]  ___sys_sendmsg+0xd8/0x160                                                                               
[  579.721156]  ? sendmsg_copy_msghdr+0x110/0x110                                                                       
[  579.722142]  ? do_wp_page+0x1d1/0xf50                                                                                
[  579.722970]  ? __handle_mm_fault+0x1c96/0x3390                                                                       
[  579.723943]  ? vm_iomap_memory+0x170/0x170                                                                           
[  579.724855]  ? __fget_light+0x51/0x220                                                                               
[  579.725696]  __sys_sendmsg+0xb7/0x140                                                                                
[  579.726526]  ? __sys_sendmsg_sock+0x20/0x20                                                                          
[  579.727450]  ? copy_page_range+0x14c0/0x2a40                                                                         
[  579.728389]  do_syscall_64+0x3b/0x90                                                                                 
[  579.729199]  entry_SYSCALL_64_after_hwframe+0x44/0xae                                                                
[  579.730285] RIP: 0033:0x7feb5f746c17                                                                                 
[  579.731099] Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 
[  579.734799] RSP: 002b:00007fff12a9e948 EFLAGS: 00000246 ORIG_RAX: 000000000000002e                                   
[  579.736403] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007feb5f746c17                                        
[  579.737857] RDX: 0000000000000000 RSI: 00007fff12a9e9b0 RDI: 0000000000000003                                        
[  579.739316] RBP: 00000000611e94b8 R08: 0000000000000001 R09: 0000000000403578                                        
[  579.740770] R10: 00007feb5f8948b0 R11: 0000000000000246 R12: 0000000000000001                                        
[  579.742226] R13: 00007fff12a9f060 R14: 0000000000000000 R15: 000000000048e520                                        
                                                                                                                        
[  579.744115] Allocated by task 0:                                                                                     
[  579.744872]  kasan_save_stack+0x1b/0x40                                                                              
[  579.745730]  __kasan_slab_alloc+0x61/0x80                                                                            
[  579.746623]  kmem_cache_alloc+0x14c/0x2f0
[  579.747515]  fdb_create+0x32/0xc30 [bridge]                                                                           
[  579.748450]  br_fdb_update+0x301/0x730 [bridge]                                                                      
[  579.749444]  br_handle_frame_finish+0x5f7/0x1690 [bridge]                                                             
[  579.750611]  br_handle_frame+0x55f/0x910 [bridge]                                                                     
[  579.751647]  __netif_receive_skb_core+0xfc3/0x2a10                                                                    
[  579.752680]  __netif_receive_skb_list_core+0x2ef/0x900                                                                
[  579.753777]  netif_receive_skb_list_internal+0x5f4/0xc60                                                              
[  579.754933]  napi_complete_done+0x188/0x5d0                                                                          
[  579.755856]  mlx5e_napi_poll+0x2bc/0x1680 [mlx5_core]                                                                 
[  579.757014]  __napi_poll+0xa1/0x420                                                                                   
[  579.757808]  net_rx_action+0x2c4/0x950                                                                                
[  579.758655]  __do_softirq+0x1a0/0x57f                                                                                
                                                                                                                         
[  579.759918] Freed by task 0:                                                                                          
[  579.760600]  kasan_save_stack+0x1b/0x40                                                                               
[  579.761464]  kasan_set_track+0x1c/0x30                                                                                
[  579.762321]  kasan_set_free_info+0x20/0x30                                                                            
[  579.763225]  __kasan_slab_free+0xeb/0x120                                                                             
[  579.764115]  kmem_cache_free+0x82/0x3f0                                                                              
[  579.764978]  rcu_do_batch+0x32f/0xba0                                                                                 
[  579.765802]  rcu_core+0x4c4/0x910                                                                                     
[  579.766560]  __do_softirq+0x1a0/0x57f                                                                                 
                                                                                                                        
[  579.767804] Last potentially related work creation:                                                                  
[  579.768820]  kasan_save_stack+0x1b/0x40                                                                              
[  579.769660]  kasan_record_aux_stack+0xa3/0xb0                                                                         
[  579.770599]  call_rcu+0xe3/0x1230                                                                                    
[  579.771367]  br_fdb_delete_by_port+0x1d7/0x270 [bridge]                                                              
[  579.772468]  br_stp_disable_port+0x150/0x180 [bridge]                                                                
[  579.773541]  del_nbp+0x11e/0xcb0 [bridge]                                                                            
[  579.774435]  br_dev_delete+0x8d/0x190 [bridge]                                                                        
[  579.775391]  rtnl_dellink+0x2cb/0x9b0                                                                                
[  579.776218]  rtnetlink_rcv_msg+0x359/0x9a0                                                                            
[  579.777123]  netlink_rcv_skb+0x120/0x350                                                                             
[  579.778035]  netlink_unicast+0x4c6/0x7a0                                                                              
[  579.778904]  netlink_sendmsg+0x70a/0xbf0                                                                              
[  579.779777]  sock_sendmsg+0xe4/0x110                                                                                  
[  579.780589]  ____sys_sendmsg+0x5cf/0x7d0                                                                             
[  579.781462]  ___sys_sendmsg+0xd8/0x160                                                                                
[  579.782315]  __sys_sendmsg+0xb7/0x140                                                                                
[  579.783144]  do_syscall_64+0x3b/0x90                                                                                 
[  579.783959]  entry_SYSCALL_64_after_hwframe+0x44/0xae                                                                
                                                                                                                        
[  579.785467] The buggy address belongs to the object at ffff888130175d80                                              
                which belongs to the cache bridge_fdb_cache of size 128                                                 
[  579.788085] The buggy address is located 16 bytes inside of                                                          
                128-byte region [ffff888130175d80, ffff888130175e00)                                                    
[  579.790432] The buggy address belongs to the page:                                                                    
[  579.791461] page:0000000044cdd676 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888130175cc0 pfn:0x130175
[  579.795093] raw: 0017ffffc0000200 0000000000000000 dead000000000122 ffff88811ea56140                                        
[  579.796733] raw: ffff888130175cc0 0000000080150009 00000001ffffffff 0000000000000000                                        
[  579.798380] page dumped because: kasan: bad access detected                                                                 
                                                                                                                               
[  579.799984] Memory state around the buggy address:                                                                          
[  579.801019]  ffff888130175c80: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb                                       
[  579.802566]  ffff888130175d00: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc                                              
[  579.804107] >ffff888130175d80: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb                                              
[  579.805654]                          ^                                                                                      
[  579.806488]  ffff888130175e00: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb                                       
[  579.807945]  ffff888130175e80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc                                              
[  579.809398] ==================================================================                                              
[  579.810865] Disabling lock debugging due to kernel taint                                                                    
[  579.811956] ==================================================================                                              
[  579.813429] BUG: KASAN: use-after-free in mlx5_esw_bridge_init_switchdev_fdb_work+0x339/0x400 [mlx5_core]                   
[  579.815432] Read of size 2 at addr ffff888130175d94 by task ip/7454                                                         
                                                                                                                        
[  579.817174] CPU: 0 PID: 7454 Comm: ip Tainted: G    B             5.14.0-rc5+ #7                                            
[  579.818758] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[  579.821035] Call Trace:                                                                                                     
[  579.821649]  dump_stack_lvl+0x46/0x5a                                                                                
[  579.822492]  print_address_description.constprop.0+0x1f/0x140                                                        
[  579.823706]  ? mlx5_esw_bridge_init_switchdev_fdb_work+0x339/0x400 [mlx5_core]                                       
[  579.825317]  ? mlx5_esw_bridge_init_switchdev_fdb_work+0x339/0x400 [mlx5_core]                                              
[  579.826845]  kasan_report.cold+0x83/0xdf                                                                             
[  579.827674]  ? mlx5_esw_bridge_init_switchdev_fdb_work+0x339/0x400 [mlx5_core]                                       
[  579.829202]  mlx5_esw_bridge_init_switchdev_fdb_work+0x339/0x400 [mlx5_core]                                         
[  579.830638]  mlx5_esw_bridge_event_blocking+0x346/0x610 [mlx5_core]                                                  
[  579.831933]  ? mlx5_esw_bridge_port_obj_attr_set+0x320/0x320 [mlx5_core]                                                    
[  579.833308]  ? rwsem_mark_wake+0x7e0/0x7e0                                                                           
[  579.834219]  ? rwsem_down_read_slowpath+0x142/0xad0                                                                         
[  579.835271]  blocking_notifier_call_chain+0xdb/0x130                                                                 
[  579.836345]  ? switchdev_fdb_add_deferred+0x1b0/0x1b0                                                                       
[  579.837427]  switchdev_fdb_del_deferred+0x10c/0x1b0                                                                         
[  579.838484]  ? switchdev_fdb_add_deferred+0x1b0/0x1b0                                                                       
[  579.839577]  ? _raw_spin_lock+0xd0/0xd0                                                                              
[  579.840439]  ? switchdev_deferred_process+0x175/0x290                                                                       
[  579.841518]  ? kfree+0xa8/0x420                                                                                      
[  579.842256]  switchdev_deferred_process+0x12f/0x290                                                                  
[  579.843317]  del_nbp+0x35c/0xcb0 [bridge]                                                                            
[  579.844228]  br_dev_delete+0x8d/0x190 [bridge]                                                                       
[  579.845212]  rtnl_dellink+0x2cb/0x9b0                                                                                
[  579.846045]  ? unwind_next_frame+0x11fb/0x1a40                                                                       
[  579.847023]  ? rtnl_bridge_getlink+0x650/0x650                                                                       
[  579.847994]  ? deref_stack_reg+0xe6/0x160                                                                            
[  579.848879]  ? unwind_next_frame+0x11fb/0x1a40                                                                              
[  579.849850]  ? arch_stack_walk+0x9e/0xf0
[  579.850731]  ? mutex_lock+0xa1/0xf0                                  
[  579.851530]  ? __mutex_lock_slowpath+0x10/0x10                       
[  579.852499]  rtnetlink_rcv_msg+0x359/0x9a0                           
[  579.853406]  ? rtnl_calcit.isra.0+0x2b0/0x2b0                        
[  579.854399]  ? ___sys_sendmsg+0xd8/0x160                             
[  579.855275]  ? __sys_sendmsg+0xb7/0x140                              
[  579.856135]  ? do_syscall_64+0x3b/0x90                               
[  579.856984]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae              
[  579.858101]  ? kasan_save_stack+0x32/0x40                            
[  579.858995]  ? kasan_save_stack+0x1b/0x40                            
[  579.859887]  ? kasan_record_aux_stack+0xa3/0xb0                      
[  579.860878]  ? task_work_add+0x3a/0x130                              
[  579.861751]  ? fput_many.part.0+0x8c/0x110                           
[  579.862677]  ? path_openat+0x1e02/0x3960                             
[  579.863551]  ? do_filp_open+0x19e/0x3e0                              
[  579.864413]  ? do_sys_openat2+0x122/0x360                            
[  579.865303]  ? __x64_sys_openat+0x120/0x1d0                          
[  579.877159]  ? do_syscall_64+0x3b/0x90                               
[  579.878007]  netlink_rcv_skb+0x120/0x350                             
[  579.878834]  ? rtnl_calcit.isra.0+0x2b0/0x2b0                        
[  579.879733]  ? netlink_ack+0x9c0/0x9c0                               
[  579.880534]  ? netlink_deliver_tap+0x7f/0x8f0                        
[  579.881429]  ? _copy_from_iter+0x277/0xdb0                           
[  579.882291]  netlink_unicast+0x4c6/0x7a0                             
[  579.883122]  ? netlink_attachskb+0x750/0x750                         
[  579.884010]  ? __build_skb_around+0x1f9/0x2b0                        
[  579.884906]  ? __check_object_size+0x23e/0x300                       
[  579.885819]  netlink_sendmsg+0x70a/0xbf0                             
[  579.886654]  ? netlink_unicast+0x7a0/0x7a0                           
[  579.887565]  ? __import_iovec+0x51/0x610                             
[  579.888440]  ? netlink_unicast+0x7a0/0x7a0                           
[  579.889344]  sock_sendmsg+0xe4/0x110                                 
[  579.890163]  ____sys_sendmsg+0x5cf/0x7d0                             
[  579.891047]  ? kernel_sendmsg+0x30/0x30                              
[  579.891908]  ? __ia32_sys_recvmmsg+0x210/0x210                       
[  579.892884]  ? trace_event_raw_event_mmap_lock_released+0x240/0x240  
[  579.894198]  ? lru_cache_add+0x17d/0x2a0                             
[  579.895084]  ? wp_page_copy+0x87c/0x1370                             
[  579.895960]  ___sys_sendmsg+0xd8/0x160                               
[  579.896803]  ? sendmsg_copy_msghdr+0x110/0x110                       
[  579.897744]  ? do_wp_page+0x1d1/0xf50                                
[  579.898537]  ? __handle_mm_fault+0x1c96/0x3390                       
[  579.899450]  ? vm_iomap_memory+0x170/0x170                           
[  579.900313]  ? __fget_light+0x51/0x220                               
[  579.901114]  __sys_sendmsg+0xb7/0x140                                
[  579.901898]  ? __sys_sendmsg_sock+0x20/0x20                          
[  579.902774]  ? copy_page_range+0x14c0/0x2a40                         
[  579.903666]  do_syscall_64+0x3b/0x90
[  579.904440]  entry_SYSCALL_64_after_hwframe+0x44/0xae                                                                
[  579.905461] RIP: 0033:0x7feb5f746c17                                                                                  
[  579.906237] Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 7
[  579.909720] RSP: 002b:00007fff12a9e948 EFLAGS: 00000246 ORIG_RAX: 000000000000002e                                    
[  579.911339] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007feb5f746c17                                         
[  579.912803] RDX: 0000000000000000 RSI: 00007fff12a9e9b0 RDI: 0000000000000003                                         
[  579.914271] RBP: 00000000611e94b8 R08: 0000000000000001 R09: 0000000000403578                                        
[  579.915737] R10: 00007feb5f8948b0 R11: 0000000000000246 R12: 0000000000000001                                         
[  579.917200] R13: 00007fff12a9f060 R14: 0000000000000000 R15: 000000000048e520                                         
                                                                                                                         
[  579.919112] Allocated by task 0:                                                                                     
[  579.919861]  kasan_save_stack+0x1b/0x40                                                                               
[  579.920740]  __kasan_slab_alloc+0x61/0x80                                                                             
[  579.921636]  kmem_cache_alloc+0x14c/0x2f0                                                                             
[  579.922537]  fdb_create+0x32/0xc30 [bridge]                                                                           
[  579.923470]  br_fdb_update+0x301/0x730 [bridge]                                                                       
[  579.924463]  br_handle_frame_finish+0x5f7/0x1690 [bridge]                                                             
[  579.925613]  br_handle_frame+0x55f/0x910 [bridge]                                                                    
[  579.926644]  __netif_receive_skb_core+0xfc3/0x2a10                                                                    
[  579.927675]  __netif_receive_skb_list_core+0x2ef/0x900                                                                
[  579.928773]  netif_receive_skb_list_internal+0x5f4/0xc60                                                              
[  579.929896]  napi_complete_done+0x188/0x5d0                                                                          
[  579.930828]  mlx5e_napi_poll+0x2bc/0x1680 [mlx5_core]                                                                
[  579.931985]  __napi_poll+0xa1/0x420                                                                                  
[  579.932785]  net_rx_action+0x2c4/0x950                                                                                
[  579.933633]  __do_softirq+0x1a0/0x57f                                                                                
                                                                                                                        
[  579.934896] Freed by task 0:                                                                                         
[  579.935586]  kasan_save_stack+0x1b/0x40                                                                              
[  579.936443]  kasan_set_track+0x1c/0x30                                                                                
[  579.937285]  kasan_set_free_info+0x20/0x30                                                                           
[  579.938199]  __kasan_slab_free+0xeb/0x120                                                                             
[  579.939087]  kmem_cache_free+0x82/0x3f0                                                                              
[  579.939945]  rcu_do_batch+0x32f/0xba0                                                                                 
[  579.940777]  rcu_core+0x4c4/0x910                                                                                     
[  579.941542]  __do_softirq+0x1a0/0x57f                                                                                 
                                                                                                                        
[  579.942806] Last potentially related work creation:                                                                   
[  579.943855]  kasan_save_stack+0x1b/0x40                                                                              
[  579.944710]  kasan_record_aux_stack+0xa3/0xb0                                                                        
[  579.945664]  call_rcu+0xe3/0x1230                                                                                    
[  579.946430]  br_fdb_delete_by_port+0x1d7/0x270 [bridge]                                                              
[  579.947557]  br_stp_disable_port+0x150/0x180 [bridge]                                                                
[  579.948649]  del_nbp+0x11e/0xcb0 [bridge]                                                                            
[  579.949552]  br_dev_delete+0x8d/0x190 [bridge]                                                                       
[  579.950536]  rtnl_dellink+0x2cb/0x9b0                                                                                
[  579.951365]  rtnetlink_rcv_msg+0x359/0x9a0                                                                            
[  579.952267]  netlink_rcv_skb+0x120/0x350
[  579.953145]  netlink_unicast+0x4c6/0x7a0                                                                             
[  579.954029]  netlink_sendmsg+0x70a/0xbf0                                                                              
[  579.954897]  sock_sendmsg+0xe4/0x110                                                                                  
[  579.955707]  ____sys_sendmsg+0x5cf/0x7d0                                                                              
[  579.956584]  ___sys_sendmsg+0xd8/0x160                                                                                
[  579.957427]  __sys_sendmsg+0xb7/0x140                                                                                 
[  579.958254]  do_syscall_64+0x3b/0x90                                                                                 
[  579.959069]  entry_SYSCALL_64_after_hwframe+0x44/0xae                                                                 
                                                                                                                         
[  579.960584] The buggy address belongs to the object at ffff888130175d80                                               
                which belongs to the cache bridge_fdb_cache of size 128                                                 
[  579.963194] The buggy address is located 20 bytes inside of                                                           
                128-byte region [ffff888130175d80, ffff888130175e00)                                                     
[  579.965550] The buggy address belongs to the page:                                                                    
[  579.966596] page:0000000044cdd676 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888130175cc0 pfn:0x130175
[  579.968774] flags: 0x17ffffc0000200(slab|node=0|zone=2|lastcpupid=0x1fffff)                                           
[  579.970212] raw: 0017ffffc0000200 0000000000000000 dead000000000122 ffff88811ea56140                                  
[  579.971860] raw: ffff888130175cc0 0000000080150009 00000001ffffffff 0000000000000000                                 
[  579.973495] page dumped because: kasan: bad access detected                                                           
                                                                                                                         
[  579.975112] Memory state around the buggy address:                                                                    
[  579.976140]  ffff888130175c80: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb                                       
[  579.977693]  ffff888130175d00: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc                                       
[  579.979241] >ffff888130175d80: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb                                       
[  579.980789]                          ^                                                                                
[  579.981632]  ffff888130175e00: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb                                       
[  579.983183]  ffff888130175e80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc                                       
[  579.984724] ==================================================================                                       
