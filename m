Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862DE450A77
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 18:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbhKORIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 12:08:43 -0500
Received: from mail-bn1nam07on2070.outbound.protection.outlook.com ([40.107.212.70]:42030
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231819AbhKORHr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 12:07:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDJO8C/yHJSnoVVqa5o1/jlpSfVNfMupZk8tLUji6V2FALqmHYaYK8NQgvGUTjq1WWY/Vn6ccXWIEO4nm7mk45pd6yAXskWMdlBLICHk9jwApJlVenNSn8moNZDm5ym2Z+iaYvlQ1mRt7bx02UqburfwOCI0R2b1wfnrr8eSk+WSUpK1KH9XiQ5gC13iy3M7wrNukqoe9+epGYqKk3W7Z0e7/VgOEmnKFknNy3WfuSHVl2q/952rtZYSq4KIaI8E/PTm3P5IqYiy3sGldLGZAQ+aPJZVj2sqk7cBGohrtWmCtUH1ifgJNkfl8ahewWX9mqw/FxAjV9KQudZ2ecAMfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d8D+Y2J95PrBfqZhcBR0SU/7YtP4lZ98vC/G0U6YI0A=;
 b=BEfWCXr4moNrKDNrM+DSv3/3adL+Tr8fVn9gntSESXGtNROG65u/iEPNsqb1CwiNT4J29x/V7pxPbu7OHa/N8hWiHt1VE7qu3uWYrxrCFOZtRGbfkzZ29FTcLmeDNGxnyDhbq9nG+othvXOXcjHEPP4Ddr6o+CuvT1yiDDceFInxjF8r0/yh32GMzd7Bd7SM2RLUKJJ1XYG0EtDXEaYpLOhT+OVJrADtip5186Mgr2vvV/9JBu5E43f6z8UvvXHh6JopFego1xVF472+jvzm6bFh24XcrF9dj4e+UZzNrgghoWSqxaZCyaMmI33yvnheIZ6qxhiI0e/bGyP7VdX/gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8D+Y2J95PrBfqZhcBR0SU/7YtP4lZ98vC/G0U6YI0A=;
 b=bZIOzRmDswUtoHMZGsF+7ve9rIr6tXuAf/DDHw1rKs0GdY2FZGtT7vNf4XjFW77AFnO1vhqL9bfjTa/i553rlF5CAXDMSPLUdg/HJgsk0gYfdNO8WwItV0mkQ5REjJiBNFXoQgFK3KoOIhNvSJ9BDmNTtHLIKzisDsdMIOO977RkVjrz4SF4mYmQrQI+Sl5ZxPtrCYQOMMKr3lU7tDx3x+JkdHqUoaIrvxa8Ft2qjUjFSTGKzaJW3fVGafIzQuBbqVBBaNatHClN9wqoeLBlOrZWlbRPU8vD9nE7+JZaC0ZIFFNSgcKb1+mcAJe+zHnSpMPpykvkMT8SbNJURtTg2Q==
Received: from BN6PR1201CA0010.namprd12.prod.outlook.com
 (2603:10b6:405:4c::20) by DM5PR12MB2581.namprd12.prod.outlook.com
 (2603:10b6:4:b2::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.19; Mon, 15 Nov
 2021 17:04:47 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4c:cafe::dc) by BN6PR1201CA0010.outlook.office365.com
 (2603:10b6:405:4c::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend
 Transport; Mon, 15 Nov 2021 17:04:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Mon, 15 Nov 2021 17:04:47 +0000
Received: from yaviefel (172.20.187.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 15 Nov 2021 17:04:44
 +0000
References: <20211102021218.955277-1-william.xuanziyang@huawei.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jgg@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] net: vlan: fix a UAF in vlan_dev_real_dev()
In-Reply-To: <20211102021218.955277-1-william.xuanziyang@huawei.com>
Date:   Mon, 15 Nov 2021 18:04:42 +0100
Message-ID: <87k0h9bb9x.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 815838a0-65eb-4953-b402-08d9a85a075f
X-MS-TrafficTypeDiagnostic: DM5PR12MB2581:
X-Microsoft-Antispam-PRVS: <DM5PR12MB25813B0529B953721595E34ED6989@DM5PR12MB2581.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SKzBmhuVEUCyyGXXx7hNku3zg5sRwuTPhLITXRkHmu4H8XAlJR24zpn8ifLQu+juDd4Gekg3xd/DOW0ib5QBhdWUvrqY6LVzrzythsAjomixSzACyKFAikI0Mtp/+4ZX9D/ycqEsijHXqnNx34qpbhakt50bJa79Thvmv2DnU6QdE9PUzyjkSfwPmd/FSkdMhzEcMgpEg03+wqcPsNw69FryCdQ1G2BE9sbN7JD0qTODJm195P6BYKaIaqMqP02ZT968TsZdQX2KcMqPd4EpPQWT1duRsXf7uBHBofBRBm2FT7Hghd7Gd5E4aqpmJlY41hHTnY9AKEL8uEfAK85qMYHdTwuXarFZyHOdaLzgy2sDwb6SC+uo/+5vPDhCdW/n2s8AqVVCOWKFHN0u5le/mmZfKLy6EkgOm40t/Y4Go9Pkm9DoA4ul1o6mvXXLKnGTEfIPTXevqPSnEH8sq0DuPfOdTUabaPirFm+oJO+WEzLpdEE3DH4KjCDmI+ObBEHqc1E4oL+aCNpfhUJ4AK9myBqfQcxdHUahZYymuvkXZ99Hw1ivKdBnKNlAGFd9NXDl3RV9poa2RFiXAQptWbIBO57faEOtKELV0LIGF5OhBn488e8rZpvCNvL6nBfWC7uay843K3AzGlKCBJRb3kZ2Sju0TYrMYRRHvi8BDC+M87TiCvRpZaoku15NEsYkjc0n4yMCMVOsu2RxWXQoBBRdXg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(4326008)(26005)(7636003)(5660300002)(82310400003)(426003)(36906005)(54906003)(508600001)(2906002)(316002)(16526019)(2616005)(47076005)(8676002)(336012)(8936002)(186003)(86362001)(70206006)(36860700001)(6916009)(70586007)(356005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 17:04:47.2112
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 815838a0-65eb-4953-b402-08d9a85a075f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2581
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Ziyang Xuan <william.xuanziyang@huawei.com> writes:

> diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
> index 55275ef9a31a..a3a0a5e994f5 100644
> --- a/net/8021q/vlan.c
> +++ b/net/8021q/vlan.c
> @@ -123,9 +123,6 @@ void unregister_vlan_dev(struct net_device *dev, struct list_head *head)
>  	}
>  
>  	vlan_vid_del(real_dev, vlan->vlan_proto, vlan_id);
> -
> -	/* Get rid of the vlan's reference to real_dev */
> -	dev_put(real_dev);
>  }
>  
>  int vlan_check_real_dev(struct net_device *real_dev,
> diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
> index 0c21d1fec852..aeeb5f90417b 100644
> --- a/net/8021q/vlan_dev.c
> +++ b/net/8021q/vlan_dev.c
> @@ -843,6 +843,9 @@ static void vlan_dev_free(struct net_device *dev)
>  
>  	free_percpu(vlan->vlan_pcpu_stats);
>  	vlan->vlan_pcpu_stats = NULL;
> +
> +	/* Get rid of the vlan's reference to real_dev */
> +	dev_put(vlan->real_dev);
>  }
>  
>  void vlan_setup(struct net_device *dev)

This is causing reference counting issues when vetoing is involved.
Consider the following snippet:

    ip link add name bond1 type bond mode 802.3ad
    ip link set dev swp1 master bond1
    ip link add name bond1.100 link bond1 type vlan protocol 802.1ad id 100
    # ^ vetoed, no netdevice created
    ip link del dev bond1

The setup process goes like this: vlan_newlink() calls
register_vlan_dev() calls netdev_upper_dev_link() calls
__netdev_upper_dev_link(), which issues a notifier
NETDEV_PRECHANGEUPPER, which yields a non-zero error,
because a listener vetoed it.

So it unwinds, skipping dev_hold(real_dev), but eventually the VLAN ends
up decreasing reference count of the real_dev. Then when when the bond
netdevice is removed, we get an endless loop of:

    kernel:unregister_netdevice: waiting for bond1 to become free. Usage count = 0 

Moving the dev_hold(real_dev) to always happen even if the
netdev_upper_dev_link() call makes the issue go away.

I'm not sure why this wasn't happening before. After the veto,
register_vlan_dev() follows with a goto out_unregister_netdev, which
calls unregister_netdevice() calls unregister_netdevice_queue(), which
issues a notifier NETDEV_UNREGISTER, which invokes vlan_device_event(),
which calls unregister_vlan_dev(), which used to dev_put(real_dev),
which seems like it should have caused the same issue. Dunno.
