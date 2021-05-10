Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E5A3792F0
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 17:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhEJPpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 11:45:40 -0400
Received: from mail-bn8nam11on2078.outbound.protection.outlook.com ([40.107.236.78]:5857
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230383AbhEJPpi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 11:45:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kK4sqvLEJcbFBLM8z7JZJZcu6pXQPexXSd+ttap8E7adLqtx5q3hjjvB5vgWZx9QSjn4+X9mYjJB4sTf2LLyUB7zFQ1a62GKDuQ/bGGyjClWa0ae5vmnStHYXgfUIf33vu1qWAzdF9xx+JbT7EqwkLmp9Bfkmhs6Frq9cJpOxpwLjiz7HE9WbUyjXAJDZRTd16RxTUHW1518ktlkyLucMyOC0L7KxQlywmzT+gmUUwvEXiDCjhmNLjzkGR8HeHQ1qpGjAIWfJUED3Of97iApXJoMFJHIGyc7rxxlebxW3KKvOPgQs484e2DBmVi0MuzjpvuiDRoGVQBo9rODxbD1bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PY17iLIFSJTn+MMQUXbNaXm7CyWuNCiU9dsC20wQly4=;
 b=bZ/8AB6VxUlUTRPW061Qda3VJtf4FuNWLtQP5gzQKPe1ciEscgIOUcOIKIprxIxhCQeMvYgRc2i03SzVYxsvSfAtGUOPuT6l7Xl51NYuHvOLV9MXm4syRHtGpBd6vwkKdDaCS4ox/NIxLwDwGRLCDi8W6zdfnKZXqRjkO2Z1Hfdc5xC+4o29nSi/L4BVVX0qLboXBvcg9UgaSoEatA/+MfuTV2ijYqnIJ04g2xV2YeIzDOBxOI+im/5Nmw2e2cOuZ5/h4zz1kEKxHrK98l0ixXeFyI8voLV6C/YcxcMijvhSs+2DYrNGiGqIhqAvhuYT5+li9BwozJVPEHop8wAGGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PY17iLIFSJTn+MMQUXbNaXm7CyWuNCiU9dsC20wQly4=;
 b=ubPIzCBkbuqTvQe280QqadG00RT69e5EQtzXNzJpEZAQ0Dg/zwi4AIHTalwrEsfO1KlzG7MQP+dMAeafU3oLs3em9iAUYdbFeJXKcgFcfSo1cyo1v5ycV67WYH77wqyB4oaFmrCg6kC/Wwe4/UgxI/3vZEAn8KWwj6k1gjGGUli9VI8KOc/6t0WaViUYSJe0R9q8wjCquHqMjGVzymTVN2Q2lcpR0ZeTZKKHQURZ/n1pcDZlaWwbSb7w8dlHnNSLXfSR0k0nLEz+2GeBlimSmHAmr8gjQdUXoh8qdfdhY2Ef+Hjrlh3R18aS4fwp1+Wtx+TShFCddqVfW1KmalfD3Q==
Received: from MW4PR03CA0074.namprd03.prod.outlook.com (2603:10b6:303:b6::19)
 by MW2PR12MB2539.namprd12.prod.outlook.com (2603:10b6:907:9::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Mon, 10 May
 2021 15:44:31 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::86) by MW4PR03CA0074.outlook.office365.com
 (2603:10b6:303:b6::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Mon, 10 May 2021 15:44:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4108.25 via Frontend Transport; Mon, 10 May 2021 15:44:31 +0000
Received: from [10.80.2.154] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 10 May
 2021 15:44:28 +0000
Subject: Re: ethtool features: tx-udp_tnl-csum-segmentation and
 tx-udp_tnl-segmentation
To:     Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>
CC:     Tariq Toukan <tariqt@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
        "Maria Pasechnik" <mariap@nvidia.com>
References: <c4cd5df8-2a16-6c31-8a13-4d36b51ba13b@nvidia.com>
 <77f09431-d80f-e9d0-7e08-3ab7bf4680d8@gmail.com>
From:   Aya Levin <ayal@nvidia.com>
Message-ID: <9b6f1499-db56-9c87-8407-09e4daa5f15e@nvidia.com>
Date:   Mon, 10 May 2021 18:44:03 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <77f09431-d80f-e9d0-7e08-3ab7bf4680d8@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b7cab2e-2908-41ba-2b72-08d913ca80e5
X-MS-TrafficTypeDiagnostic: MW2PR12MB2539:
X-Microsoft-Antispam-PRVS: <MW2PR12MB25391403D27778E8BF9922CABD549@MW2PR12MB2539.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h2XuQnHEkNgz/CckUggO6McNGFh7tw9BLdN4BImOf8aqMa4j6h0WKef1BrSUXNV1DnEd38c5+5EGxqyGSg4rn6Tf/vOMqqZo2gWoy3nIrmSfgw86XwlS/gXY+x6AlevZxyzg3rSzVXB2zuEMUnFsb18vvDbEAO/wzN+/td/w+jwFQ1vq69M4EmU1sr0bM+/SsMbXF8om5bPpbqXX8vUl4lVhtJjyJlD/DjcssRy7s3go85p7xodY9XJL1nHtpBZBMApF8pHtRcmQNChFriQKn0mgZdZP0JpLp1XAgrXxCmxwDlfC21Xb0jlyaL8o+g9VrEvDVVxeKNwCqWAKOqZwHKSaUiToLyK5tKC6IrYi6GKRMjJN2V5/W4WEm2/bIErFOuTojR6o9+7vLR5QZCM1usQe/LbeuDWf7dnlPVVeSQzWnblGxGXeU3XzpQK8MlCMHEGo5O+qGxW49nHBH+3VKX+tF35Q9yi92WKRbAJlk9OiQAkiHm322K/bNJWgsiWhBg/qBC9rPnuCbyHpcXg1Kew23Rmh/nTj8CEmfPafhoDrCq4qbRjJ38UHk5EUdOKBKII8QG+287Jp1+FGNjt0SorjFO3+ODPgYXbiErDtAxlB5IFwlVL/p5gGwiN2Hc4EkHDpkqbkI8AUC7TDo2qF/tWTcKY3IJN3ab807KnsGiwpj6oBI+Wm932K7RLpwheu
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(376002)(136003)(36840700001)(46966006)(2616005)(426003)(110136005)(82310400003)(82740400003)(26005)(7636003)(356005)(316002)(4326008)(8676002)(16576012)(36860700001)(36906005)(478600001)(54906003)(70206006)(2906002)(6636002)(83380400001)(8936002)(47076005)(107886003)(53546011)(6666004)(36756003)(86362001)(5660300002)(336012)(16526019)(186003)(31686004)(31696002)(70586007)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 15:44:31.5300
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b7cab2e-2908-41ba-2b72-08d913ca80e5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2539
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks a lot for your response!

On 4/29/2021 5:49 PM, Edward Cree wrote:
> On 29/04/2021 10:16, Aya Levin wrote:
>> I see a strange behavior when toggling feature flags:
>> (1) tx-udp_tnl-csum-segmentation
>> (2) tx-udp_tnl-segmentation
> ...
>> What is the role of each feature flag?
> IIRC, tx-udp_tnl-segmentation controls whether to do TSO on packets that don't
>   have an outer checksum to offload, whereas tx-udp_tnl-csum-segmentation controls
>   the same for packets that _do_ need outer checksum offload.  The difference
>   being whether gso_type is SKB_GSO_UDP_TUNNEL or SKB_GSO_UDP_TUNNEL_CSUM.
Digging further in the code I see that the driver may allow/block inner 
checksum offload by set/unset NETIF_F_HW_CSUM to hw_enc_features at 
driver's load.
I couldn't find a control - is this expected?
> 
> To a first approximation there's one feature flag for each SKB_GSO_* bit, and if
>   an skb's gso_type requires a feature that's not enabled on the device, the core
>   will segment that skb in software before handing it to the driver.
> 
> Documentation/networking/segmentation-offloads.rst may also be useful to read if
>   you haven't already.
> 
> (And note that the kernel's favourite way for hardware to behave is to instead
>   provide GSO_PARTIAL offload / tx-gso-partial, rather than doing protocol-
>   ossified offloads for specific kinds of tunnels.)
> 
> -ed
> 
