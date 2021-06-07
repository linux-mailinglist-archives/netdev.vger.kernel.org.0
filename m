Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8899A39D45D
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 07:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhFGFaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 01:30:11 -0400
Received: from mail-bn7nam10on2064.outbound.protection.outlook.com ([40.107.92.64]:6977
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229436AbhFGFaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 01:30:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BePW5FN26sbC8lDkJd8UOarvUJB7UNWd/dAU9fnP5ltXiUq3Ai+6Sb7vK6UEixUK9GX0O3cvUaFXi0wlzjnxk6ErHCW8nxXc0pr9U6g8p5y0FnD3cPMSdwfyHHCSr3EwYk1xKXSMVCUGMMOUKU3W8uJFMHOiIMPXvo2KC/wdaTucVGB8ymC/9ijJvQodTLrrflzTxXoA5aLzO6fZKNrqnR1Lazp6rXWsVCGYerTvFAoPbY7JzuZ3gPchN2g8G9ZzApxEpGwh+6OIcwvjsQNn0TjEDF2ZdQJ0y/4Ge2QkbZK4oOgSGyHeWM6Kd2bOZ/AOYtID6kGxMnK7wYZVRAu9Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yMsv8NF1eAMSWbRao3Kv0Ar5/5AXTVDynJUWkxhWXYY=;
 b=euJHTjwBAawltNwlFdPEMzEAN5CYtCOhR9+YXcqmL4pn+GMqR6ioeEFSbsTHOKipSUlqv9ynaoz/rtir4M1Dxoqafim/znHD5dLZc06BsN9JPlbug/qUc9aDG+40pubvvPSDxc0fKHRIhWqYmPng6iZV4QVkYMuK+lpssZmrDpD9+qkLsGhewJGwvnzaY4lUiifZ2A83fk2Fvs/Zc+t/nqVF4ic4fM47OFCOuIfsWnLF7Q/xOc2j7VxtEPzfZ4FTJ4wcytHuQwTGLeAQGMLoVSCT3hbO0rbbiFGbBCQkompE6HcA+KNg8MSbZB0zgE8QwitS+hcF84w3HaIGRcbffA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yMsv8NF1eAMSWbRao3Kv0Ar5/5AXTVDynJUWkxhWXYY=;
 b=HbsGzcCx7f8ivy0RhZ2jtxyn+rfetYTQFbj07gVQrRH6kjcuTz1oVqAAtXPNAjjEp6cJBFVHG5bjK8fDubR1u6yyxxKQGXAfVCr7B96u2yj3tiKSAcMlyBcWCNEvja3vrcv483Zp/Kd4ifvViPtcoY3WZhJm3buiWLGJ4/VQr940OT6+qMemBtGlHjcV8tpw4SKnUGjy6DPlVxqCZnGzGvzKyMsnjHLVYGG3KhfBAFc3FPYw/kHVxIMprNEyT2Uw94X8IeIQ9x3zKRmKTB1L+efr0igDX9KtVGULDsYPLRYumZuf1zUJqHBVJXSDn5KoeBQPqIGgFll52wUEr3vApA==
Received: from MWHPR07CA0019.namprd07.prod.outlook.com (2603:10b6:300:116::29)
 by DM6PR12MB4354.namprd12.prod.outlook.com (2603:10b6:5:28f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Mon, 7 Jun
 2021 05:28:18 +0000
Received: from CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:116:cafe::f7) by MWHPR07CA0019.outlook.office365.com
 (2603:10b6:300:116::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend
 Transport; Mon, 7 Jun 2021 05:28:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT031.mail.protection.outlook.com (10.13.174.118) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Mon, 7 Jun 2021 05:28:18 +0000
Received: from [172.27.0.75] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Jun
 2021 05:28:15 +0000
Subject: Re: [PATCH net] ethtool: Fix NULL pointer dereference during module
 EEPROM dump
To:     Ido Schimmel <idosch@idosch.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mkubecek@suse.cz>,
        <vladyslavt@nvidia.com>, <andrew@lunn.ch>, <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
References: <20210606142422.1589376-1-idosch@idosch.org>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <9fddace5-09a2-6cc1-30c7-3f31ce9e2ceb@nvidia.com>
Date:   Mon, 7 Jun 2021 08:28:12 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210606142422.1589376-1-idosch@idosch.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65256b43-e2f2-4c74-c3ce-08d929750ebe
X-MS-TrafficTypeDiagnostic: DM6PR12MB4354:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4354C18D9B8BE6C2FC7CBDCED4389@DM6PR12MB4354.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y1c5LswzoX6vVPy21pMXu+nIxhv2g5KksCt+W6g2wP/v5yeF73l+RyxXITc2GooxaQddki+b7mbr4D8e09H5h5vvGIcuFgkO4ZIQv00MMGoyPCFmYTUalriKlVIMRS1v5+JQHbbBdIb20rdn28Oti8vqv/byDYJ4M7ZCZEtg/z4VHfAJeCK7NVq8i9mN+hIU71Tn2MT7Zjw6NcuRKYaSELXFZfns0FtK5XR3vfRg9SerIqvujg7vKCqoFAQXoYfXRmoz47MHUf8E3kjYkzNM/dbPisNDtQIb2o7zUVVH1H2oOQP38g5VHR59vAzvWGsOPEE5MH+NGW5AaqpVUMXvLya5iDQI0L34pUSzq3pX/QHcW0w/8mB7FE8y3vbjj3RVEp6ZxN+wqB/5qk974sxL5ZkurAx3exkSEtVSw3IPLgpVzKYZlxr3Juob9bTD3Bry4/EozwITnjV7kqFCqY/6KdTb0ACoj3gn8EIa/y2H3RT4jUMtNdsyUp/3RPJedd8HOcKsbP3hUUIGMNW144wKPYtuZ1WJBcpgaZV82W16QgBjhTAO431VkgpyUQxM8QRa1qTKDlD6PYLjzETvLvAJAGNR8TfBwZe44DvPFOz5lgOvXvzLT2wNLBE+qdv+Hi7h3KsVzMRD31qscHurnyMTS5tglHaKUO1DieyHquU8tnBeHn0bNuRgMIh94ZMG4cd3
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(136003)(346002)(36840700001)(46966006)(186003)(16526019)(2616005)(26005)(426003)(47076005)(70206006)(70586007)(8676002)(316002)(16576012)(110136005)(54906003)(2906002)(53546011)(4326008)(36906005)(478600001)(6666004)(336012)(36860700001)(31696002)(356005)(107886003)(82740400003)(5660300002)(7636003)(86362001)(31686004)(82310400003)(83380400001)(36756003)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 05:28:18.3778
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65256b43-e2f2-4c74-c3ce-08d929750ebe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4354
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/6/2021 5:24 PM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
>
> When get_module_eeprom_by_page() is not implemented by the driver, NULL
> pointer dereference can occur [1].
>
> Fix by testing if get_module_eeprom_by_page() is implemented instead of
> get_module_info().
>
> [1]
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   [...]
>   CPU: 0 PID: 251 Comm: ethtool Not tainted 5.13.0-rc3-custom-00940-g3822d0670c9d #989
>   Call Trace:
>    eeprom_prepare_data+0x101/0x2d0
>    ethnl_default_doit+0xc2/0x290
>    genl_family_rcv_msg_doit+0xdc/0x140
>    genl_rcv_msg+0xd7/0x1d0
>    netlink_rcv_skb+0x49/0xf0
>    genl_rcv+0x1f/0x30
>    netlink_unicast+0x1f6/0x2c0
>    netlink_sendmsg+0x1f9/0x400
>    __sys_sendto+0xe1/0x130
>    __x64_sys_sendto+0x1b/0x20
>    do_syscall_64+0x3a/0x70
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Fixes: c97a31f66ebc ("ethtool: wire in generic SFP module access")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>   net/ethtool/eeprom.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
> index 2a6733a6449a..5d38e90895ac 100644
> --- a/net/ethtool/eeprom.c
> +++ b/net/ethtool/eeprom.c
> @@ -95,7 +95,7 @@ static int get_module_eeprom_by_page(struct net_device *dev,
>          if (dev->sfp_bus)
>                  return sfp_get_module_eeprom_by_page(dev->sfp_bus, page_data, extack);
>
> -       if (ops->get_module_info)
> +       if (ops->get_module_eeprom_by_page)
>                  return ops->get_module_eeprom_by_page(dev, page_data, extack);
>
>          return -EOPNOTSUPP;
> --
> 2.31.1


Acked-by: Moshe Shemesh <moshe@nvidia.com>

