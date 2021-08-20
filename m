Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3C33F27B2
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 09:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238603AbhHTHht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 03:37:49 -0400
Received: from mail-dm3nam07on2044.outbound.protection.outlook.com ([40.107.95.44]:33153
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236223AbhHTHhs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 03:37:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qsrhgt9w8PWj7Xw1lq5Ie0GkQLAu2EKVsxR3sfas24sLEH1d8IfgzDhlGKqvoEJSDVKQkzhvt+cN/kacLwnW9w+7dTK/Gu7n0wIh001eSCTyCGrKd0w8ixcsbzH0YKR/LScu7CsbPjC7l+obfvTb83Ss1ez5NjIV07Pf6LaRGtRhpNfqNGNoYEj8M80c7PL0Xyz3A+rpeO6K1VlEAzAxe5ZE4sB/56V0RHc3vQXcDT9UPtvz50nD/YYH+x0aK/769Jp2NfH8uMFKg72IfKH0AlU+mBeQIDHkzrtzRACTWM38rcJp2mK+mqsHvUcwHHtRqP6pzcG0NfFQ6zvC9saSEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61oS7d/g+KicsFo/E+nO68sylEum9D/TW4lhBjkwoHM=;
 b=KCIFU5e3hNgckdKukE85uTf78B60C0NeEqUwI6igjW0EdHHy0NpLkZ3XWzP3DTDQnA7mwRh1jgEqToLvbIBh620esBO6478zSvN3JWxO6OQ95ig61KCtn/VLh+ojeEUbO/Isl19rJOiTEKSAmfB0euby344CT23k3tFYNhrQVGYznu5Vce6OjRe9o/wyc4Kxsu6FogylCcZ2gDa3yStMdSB+Gb6jZE3bsVgu2j9jAjEe0eTt9q+gqvx+QQlV6Yw6O2rZ+BNB0n8D9tmXd2i9Mfhm64Rn2BplNfQnQExYyCo9KwQC1dxoM9iodHJ7mA+JnZJK58w2m/92pkBOl5MCDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61oS7d/g+KicsFo/E+nO68sylEum9D/TW4lhBjkwoHM=;
 b=bbvj6EqGxcWZx9n+a+CLCZrWuQgQvI31daNO8IawVn+CDjxsKf5CQ3jRqIbPMeILfalvFnbrfP1nmAwfRAHQl4n8Rd3Edsl8wgygv7dyjMTvs9u+s5vLIRvX6NgaIJLxYfkSt8u6CUEQRKkxM2sVFZq5EbwEmoyQxJxK8rBU9T4WYL3ihy+73LCIynsYOR9Wv7e2Zt0zEk8NDRNVzbk9r2mwkxe1Ne5GBEyAHq3ySalnPnaO6HjSj+GKZzjthOpptLd6bBhOYX/XAMFsxw20BXjrVaG7Wbasm2i2DOSgr2cYjLJA1HgTdVH+aTx1AkvUQt0S0ptxnXmX2zf4u8DzlA==
Received: from BN9PR03CA0529.namprd03.prod.outlook.com (2603:10b6:408:131::24)
 by DM6PR12MB2730.namprd12.prod.outlook.com (2603:10b6:5:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Fri, 20 Aug
 2021 07:37:09 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:131:cafe::e) by BN9PR03CA0529.outlook.office365.com
 (2603:10b6:408:131::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Fri, 20 Aug 2021 07:37:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Fri, 20 Aug 2021 07:37:08 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 20 Aug
 2021 00:37:07 -0700
Received: from reg-r-vrt-018-180.nvidia.com (172.20.187.5) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 20 Aug 2021 07:36:46 +0000
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
 <20210819160723.2186424-2-vladimir.oltean@nxp.com>
 <ygnh5yw1pah6.fsf@nvidia.com> <20210819231849.us3hxtszkwbo2nik@skbuf>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        "Taras Chornyi" <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        <UNGLinuxDriver@microchip.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        "Claudiu Manoil" <claudiu.manoil@nxp.com>,
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
In-Reply-To: <20210819231849.us3hxtszkwbo2nik@skbuf>
Date:   Fri, 20 Aug 2021 10:36:41 +0300
Message-ID: <ygnh35r4pnxy.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc24a7f7-5feb-4ea7-f42d-08d963ad510b
X-MS-TrafficTypeDiagnostic: DM6PR12MB2730:
X-Microsoft-Antispam-PRVS: <DM6PR12MB273009D34530F0B8B66FBB13A0C19@DM6PR12MB2730.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 90taKCSyQrMnf5kAD9vKyXE1IzkFs4HPIvM6EEPlfKlHRIPuDLySQ4LhVw8P86jdxJ8Q7wYlFifNkCLDEyY63lS4OcTu+JN79ySktjkvdERqNMJxgiFXg/bKGTb8Y8G/nlsFe9pX+ZI5ikjxW36Q6PyALAGehYPuTT+Xsc1qSqc70BSaqhEy2lE5HgxzJUcZ7BFAPNSRHTPenXiIJiUwMkGlMFAl2f7DdIpnc+Qa3cQqkBJreDpTes0mS0oFcW0L4sn4Dc2guesF4Sfur2JvJstfPer+q2AFwsItKVs93EJtEi3tmdN1cSaJtH6ckLWM/Yt4jKuzgi8EQa8bD6agPLXSlthUBRapAVF/aE/WC2Yi1qzFowqoFFtgiJP4zGw4oFrJr54Ehabb5gN8ku/Xs3cQl5OIOEdKeaN8pgcWVR+1VQlMLl66vOhiZMJ0cf94WH6g+EeR67swHnSACX/Ibi8HLI5XSef/5ln1sG7EGtlBpGwLzXliW9ay4mofY9pfefo4t3C5xU3aiF5OcCL4gmIDNxa+rzDKh87yc0Ioqm36rmPizhuHc3PrI7LfoOrW5NYBQYgd45o+6jcFUae2RfIpPL7Hk/wOFK+vfBfUmIwjAKvWrx+hkPJ5YfnumwTbMWcOwOumbhIZ9etw1lqDxT1W1e9zNcSiARSebWg0a8s+RiOxy5ipwjmIB4ErB47Pi3P2LyH3kl2dsENz8QmjOw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(136003)(376002)(46966006)(36840700001)(2906002)(336012)(7696005)(478600001)(16526019)(186003)(26005)(8936002)(82310400003)(36756003)(2616005)(83380400001)(426003)(316002)(70586007)(47076005)(70206006)(7416002)(7406005)(356005)(4326008)(82740400003)(6666004)(8676002)(54906003)(36860700001)(7636003)(6916009)(86362001)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 07:37:08.7307
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc24a7f7-5feb-4ea7-f42d-08d963ad510b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2730
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 20 Aug 2021 at 02:18, Vladimir Oltean <olteanv@gmail.com> wrote:
> Hi Vlad,
>
> On Thu, Aug 19, 2021 at 09:15:17PM +0300, Vlad Buslov wrote:
>> On Thu 19 Aug 2021 at 19:07, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
>> > index 0c38c2e319be..ea7c3f07f6fe 100644
>> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
>> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
>> > @@ -276,6 +276,55 @@ mlx5_esw_bridge_port_obj_attr_set(struct net_device *dev,
>> >  	return err;
>> >  }
>> >
>> > +static struct mlx5_bridge_switchdev_fdb_work *
>> > +mlx5_esw_bridge_init_switchdev_fdb_work(struct net_device *dev, bool add,
>> > +					struct switchdev_notifier_fdb_info *fdb_info,
>> > +					struct mlx5_esw_bridge_offloads *br_offloads);
>> > +
>> > +static int
>> > +mlx5_esw_bridge_fdb_event(struct net_device *dev, unsigned long event,
>> > +			  struct switchdev_notifier_info *info,
>> > +			  struct mlx5_esw_bridge_offloads *br_offloads)
>> > +{
>> > +	struct switchdev_notifier_fdb_info *fdb_info;
>> > +	struct mlx5_bridge_switchdev_fdb_work *work;
>> > +	struct mlx5_eswitch *esw = br_offloads->esw;
>> > +	u16 vport_num, esw_owner_vhca_id;
>> > +	struct net_device *upper, *rep;
>> > +
>> > +	upper = netdev_master_upper_dev_get_rcu(dev);
>> > +	if (!upper)
>> > +		return 0;
>> > +	if (!netif_is_bridge_master(upper))
>> > +		return 0;
>> > +
>> > +	rep = mlx5_esw_bridge_rep_vport_num_vhca_id_get(dev, esw,
>> > +							&vport_num,
>> > +							&esw_owner_vhca_id);
>> > +	if (!rep)
>> > +		return 0;
>> > +
>> > +	/* only handle the event on peers */
>> > +	if (mlx5_esw_bridge_is_local(dev, rep, esw))
>> > +		return 0;
>>
>> This check is only needed for SWITCHDEV_FDB_DEL_TO_BRIDGE case. Here it
>> breaks the offload.
>
> Very good point, thanks for looking. I copied the entire atomic notifier
> handler and deleted the code which wasn't needed, but I actually took a
> break while converting mlx5, and so I forgot to delete this part when I
> came back.
>
>> > +
>> > +	fdb_info = container_of(info, struct switchdev_notifier_fdb_info, info);
>> > +
>> > +	work = mlx5_esw_bridge_init_switchdev_fdb_work(dev,
>> > +						       event == SWITCHDEV_FDB_ADD_TO_DEVICE,
>> > +						       fdb_info,
>>
>> Here FDB info can already be deallocated[1] since this is now executing
>> asynchronously and races with fdb_rcu_free() that is scheduled to be
>> called after rcu grace period by fdb_delete().
>
> I am incredibly lucky that you caught this, apparently I needed to add
> an msleep(1000) to see it as well.
>
> It is not the struct switchdev_notifier_fdb_info *fdb_info that gets
> freed under RCU. It is fdb_info->addr (the MAC address), since
> switchdev_deferred_enqueue only performs a shallow copy. I will address
> that in v3.
>
>> > @@ -415,9 +470,7 @@ static int mlx5_esw_bridge_switchdev_event(struct notifier_block *nb,
>> >  		/* only handle the event on peers */
>> >  		if (mlx5_esw_bridge_is_local(dev, rep, esw))
>> >  			break;
>>
>> I really like the idea of completely remove the driver wq from FDB
>> handling code, but I'm not yet too familiar with bridge internals to
>> easily determine whether same approach can be applied to
>> SWITCHDEV_FDB_{ADD|DEL}_TO_BRIDGE event after this series is accepted.
>> It seems that all current users already generate these events from
>> blocking context, so would it be a trivial change for me to do in your
>> opinion? That would allow me to get rid of mlx5_esw_bridge_offloads->wq
>> in our driver.
>
> If all callers really are in blocking context (and they do appear to be)
> you can even forgo the switchdev_deferred_enqueue that switchdev_fdb_add_to_device
> does, and just call_switchdev_blocking_notifiers() directly. Then you
> move the bridge handler from br_switchdev_event() to br_switchdev_blocking_event().
> It should be even simpler than this conversion.

Thanks for your advice! I'll start looking into it as soon as this
series is accepted.

