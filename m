Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A7F453400
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237344AbhKPOX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 09:23:59 -0500
Received: from mail-sn1anam02on2041.outbound.protection.outlook.com ([40.107.96.41]:32866
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237346AbhKPOXh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 09:23:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+jXzQ4tYIdG0Jq7BtwyJ3xFEvWz4UlMtXymXsQNbqUOh/HFyFhcFrOTctXP+q6v11XCjDOVQ0DURL06ZJMP20LzEipYTpD1lzOikz80z4lvm9LONJ3d2whDwE35wOtmutV3pHJAaCsmNjGb7YqaISaPBuAZ6tJrnRPItdxopEy0LuK4Qg8vjyYc/bzzF4KivnScxd8lHbuwwo6PhNlh6mfhHXDDjHULxXPjUtj0GRFh1Vd1eBfI8gzAL1c5uWd6RRxRtqOvyn3uiqJ0Mcp/CvpQIh+KJSAcE1kEiAoFrEHTAeqp8+Okbl4Ji/tZbRvef5fmhXG+X4GojalxVsnQnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bXmC8//JMLvx8t2eNeQgDUoHBXmw2gptYo4ia6G2ggw=;
 b=b4j3Y7Wgv2uNlxdTigIqLm0onEPOP4xGJhFrX8wU0akQRDRMTEXiYEP/MY6RVb07rzMkdnZwlgIlRwMmt97tm+fhNJGNMKr808N7suZdzZTlanDxD4lpJ0J3iAWAcJ4npgl8ZLNUNODhKuWc+AQ1XfZE6rn96DAxgJICKQ/hUQcOJvkherVLoZXIiC9dwKxWe88JELvLqU2N5s3hNd2zN+6yZFUKs7ycpixO4NHvhaF7Vzaw5xdZdLhs9KdFUnTBlueXUqttMrbR02NzPsMY0UsBxeB9mBrAaVW6gUmfyVmzkJklFHYinCJfcdEs5FJcOxrWm/+9TKuWvzzrT/N0tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bXmC8//JMLvx8t2eNeQgDUoHBXmw2gptYo4ia6G2ggw=;
 b=qVg7nF5cLaejK4dbic+xblN7MbW/uvfdUmL6TXwLSonPTxZcRB6rDHH6Ti3GGiJSYTQAvcOwWV761HAyYi0xFQjGGb/a69KOBw65xydYg+V22zXF7DFt3MEyB5k93l9aDuspihqdCvPUjF/NzNJOcVqza8tb5VFHPTWEMb02JiKi3dBA5AhzHAMzUq4ydIWf2maGFHNmpoOnk9imKIlG1P09FwPtdWTEsIVqbRrEqVhIgh2Tlm5NLxwNkJpSCBiBFnolOQb4K787TGFGbL2YY1tS5KM0ivE39uzPixQV8nq3a9QLgCi4tHGisXC0NPaJ4RO32rq3OIDxolXRGkd9DA==
Received: from CO1PR15CA0091.namprd15.prod.outlook.com (2603:10b6:101:21::11)
 by DM5PR12MB1499.namprd12.prod.outlook.com (2603:10b6:4:8::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4690.27; Tue, 16 Nov 2021 14:20:38 +0000
Received: from CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:21:cafe::36) by CO1PR15CA0091.outlook.office365.com
 (2603:10b6:101:21::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16 via Frontend
 Transport; Tue, 16 Nov 2021 14:20:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT057.mail.protection.outlook.com (10.13.174.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Tue, 16 Nov 2021 14:20:37 +0000
Received: from yaviefel (172.20.187.5) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 16 Nov 2021 14:20:33
 +0000
References: <20211102021218.955277-1-william.xuanziyang@huawei.com>
 <87k0h9bb9x.fsf@nvidia.com>
 <20211115094940.138d86dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Petr Machata <petrm@nvidia.com>,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        <davem@davemloft.net>, <jgg@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] net: vlan: fix a UAF in vlan_dev_real_dev()
In-Reply-To: <20211115094940.138d86dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Tue, 16 Nov 2021 15:20:31 +0100
Message-ID: <87czn0tc5s.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33f09d70-4109-40f6-23e3-08d9a90c42be
X-MS-TrafficTypeDiagnostic: DM5PR12MB1499:
X-Microsoft-Antispam-PRVS: <DM5PR12MB14993A51EE91A1453292F585D6999@DM5PR12MB1499.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j7z69R5v92UbzcImvEhKJ/FOBxodCCwoDmenDla9QJY0vxUEvzKLF5akMBtktohjZ5L3yh3EcUnuyDJc5pKoJnbuxgr/jisgsgUU30D9Eb+x1iBAo2akVZQQfOiK6MET1EoljTX7Lc3eEX5YVKmZ/NByKZo5A4gtM+l8AD3tgTlr2Ol3T9jIx0+dQ85DwE+hLG8qNw7nAZC80BRQPE7Awffh1MU/tTN9AZyppxbI85aTNe5zyvo1qhbtrZFxKwGWkmhWrWYaGY6eIbM+9xrw6aZzxsPy7FrXC42ulNYr4rLLQtEgZGHqf7foMzOi7UizXQS9zqcHlYuAopWcbRCZlLtR8//zBRP8jdZ+0BSB0Bvp+8swBGLG5BYIJ7rjIqgYpeLBGzp7meLm1w55fXYHp0Gv5E48n9IbhwMJAhUfUc8NuLrYdFn3cgNKuO/svbPN7P1nZ/IxLOUP7zemaTx50jS/PbTUzXWUh3qmeTa+qTT5o1L4w/MBbAr8QIUC8H+wJqWQn0AiPnygYFOZnSRdiVvelVekvEV3k5b8eQvwO3SaCID455BA3hRf5s/x4HbTsVCNKs9Kvm1NllXy6+5KH9MH7tOlF5mt/eepd2OfIf1GVCSm7MF+ESvHhqhygCIurJFbNMFQrE0FZ12rUb3151JOdUYm4y7UruVvQeI2Byn7T0LZIBw4BS8kVO2FeUBV
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(70206006)(36756003)(2906002)(2616005)(356005)(7636003)(82310400003)(47076005)(336012)(5660300002)(16526019)(186003)(26005)(86362001)(4744005)(508600001)(36860700001)(54906003)(4326008)(8676002)(316002)(8936002)(70586007)(426003)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 14:20:37.2985
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f09d70-4109-40f6-23e3-08d9a90c42be
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1499
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 15 Nov 2021 18:04:42 +0100 Petr Machata wrote:
>
>> I'm not sure why this wasn't happening before. After the veto,
>> register_vlan_dev() follows with a goto out_unregister_netdev, which
>> calls unregister_netdevice() calls unregister_netdevice_queue(), which
>> issues a notifier NETDEV_UNREGISTER, which invokes vlan_device_event(),
>> which calls unregister_vlan_dev(), which used to dev_put(real_dev),
>> which seems like it should have caused the same issue. Dunno.
>
> Does the notifier trigger unregister_vlan_dev()? I thought the notifier
> triggers when lower dev is unregistered.

Right, I misinterpreted this bit:

        vlan_info = rtnl_dereference(dev->vlan_info);
        if (!vlan_info)
                goto out;
