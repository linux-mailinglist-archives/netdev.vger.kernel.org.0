Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C68443D76
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 07:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbhKCHAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 03:00:03 -0400
Received: from mail-dm6nam10on2061.outbound.protection.outlook.com ([40.107.93.61]:23777
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230152AbhKCHAC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 03:00:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NoQsr+vbrsQIWngXtGTnDYLMIjxEEQbXNxYqUGFy7zZtGE+LGYyt8Y8r3k43iQIQsO/Gr86MXKYq6/ersu8iwsV11zGMJsKvE66SQmktEhjr9VZchifCjlw5r/iBE8fvh6U8jXhq0yJ4m5P5qah1jmUcrved7ZAWkGCN0H2cVg21siZEloeCDPC5PbeJlNTSseSPP6oBeXsqnsTWLLa4EjPWfjuzD0xD7BHKt0GgNblz5ztwShxf1Qty3MA1V2FU6i82sAC3LZ24mMXLh72Es5viOOmmpsmnO0FbwQpyQsybJqTne5jRV6GVzz9Ok707trGK5RpioHr0UEKiyepkdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yBffSAS47GT8HR16F4JG+uNhQlmOrk2AH84uob0Z4rA=;
 b=Nj5U1HKwSdHGtzXGLq0J2SWNYFMo/4f+hghXbR3lndfojCcXHEK//fIRNIYAJWpJzffDDv7GGFV5mnhRFLrQLbbn8+GcCREyxGcFTIx1iXfN6OChDTaFtHi0Q12TNVnzSr0Il71AXmwJL64ELyQe/ujzDDAEcJSwxgo1lZnEQNHOUsD/Xkt2PxXmKPhM5o6Cb1TWqXo7n4zmwIr62azFO5xzgWmft8ewMCzGon1BlR+nXeKAXzjsY8FSeKI1pej059m7GmuxeD9QZMAxJALAz01pNXhg07RFplW0Xu2qWOtCqlr0x/TGG/ZbwCpg1LJ0mTHN/bVrmm6bvY8yPUGH3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yBffSAS47GT8HR16F4JG+uNhQlmOrk2AH84uob0Z4rA=;
 b=oclo3uP4VPoCbYLzCYbCG7CCb9Eh+mL6YRO0YFO7PnK+8PkhWFK9zCWHIeG0DYt7USyi5VHIME6VLUVVzACD3yUcbEHyFPbCD0d0SipfrAzp4Jv70knk6vvkDMbvfadSnRZjS+0eIjLv5afrAbTDrGzb/btjZ9AfLrGS7hymUFTVclevxg5qEDOcdIjkIHCdMFSFjTUXvrjvwxO7Ulm0tdxAeJoByV9Fgj6UegXfeijxFgROWx/CNaE9i24/PJeSEbUskBlJqwe20wxfcayeNXlhd2NkRCzVYtfH4ulyG5CLKChd/Vssw22PQQcBzC91NGJcvJ1VVovwdiuWtusqkw==
Received: from MWHPR1401CA0021.namprd14.prod.outlook.com
 (2603:10b6:301:4b::31) by BL0PR12MB2339.namprd12.prod.outlook.com
 (2603:10b6:207:4e::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Wed, 3 Nov
 2021 06:57:24 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::34) by MWHPR1401CA0021.outlook.office365.com
 (2603:10b6:301:4b::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend
 Transport; Wed, 3 Nov 2021 06:57:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4669.10 via Frontend Transport; Wed, 3 Nov 2021 06:57:24 +0000
Received: from [172.27.1.16] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 3 Nov
 2021 06:57:18 +0000
Message-ID: <bb52fc1b-4e95-bc5e-6aa9-82b9b35967cf@nvidia.com>
Date:   Wed, 3 Nov 2021 08:57:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:94.0) Gecko/20100101
 Thunderbird/94.0
Subject: Re: [PATCH] net/mlx5:using swap() instead of tmp variable
Content-Language: en-US
To:     Yihao Han <hanyihao@vivo.com>, Saeed Mahameed <saeedm@nvidia.com>,
        "Leon Romanovsky" <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Paul Blakey <paulb@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <kernel@vivo.com>
References: <20211103062111.3286-1-hanyihao@vivo.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20211103062111.3286-1-hanyihao@vivo.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86dbf45c-e21c-4d23-344f-08d99e9730ca
X-MS-TrafficTypeDiagnostic: BL0PR12MB2339:
X-Microsoft-Antispam-PRVS: <BL0PR12MB23390AC7D9797FFEEE3AA159B88C9@BL0PR12MB2339.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:281;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3fKLC4LaNlVR95/yM/eS1NqpmvrF4cRwKMIdUW5POIKW1U85N/lOTWp9ynw6k0ttB9ymMc2wX1PJ62ECeizKSlVGigaWzqyniAMcS4/bLrXnhZp4qWWvJY/RDrqKROZWyBU8nP1TwkZO9XQJ3JELW7jIIZFy2lVRQ+WCZBANudXQFqF6E9FYEdilqZe+m8D4ikerLNVKLWfCeYDQUPPsFnX66YX163X2QeM+YO5kDSG/2p+edFNsQwg7DostnUHhjCoCPJU5DgloIxRRQpmjXILeJhIgf9iQhBT/EYFMsup3T7+XPeDJo88Gcpa8Vr0fhjQz1izgew+v85GY4zQztxGXxzHtg3Jg1iWIroVT+mZy1V2ogqJIJn7WgYP+5z0IPc4LXQh1LLFO4WVNxSLzAyWeUCAfQS38jPjce+DIVPZRyFqlVw+Z58vuT7P5ISjJwN5zAmcrfREn2lfWeTZ5x3w0sVcOfBiiGaIdmYrwg37fc59uk5C6DfWc3KA+sdTzjMDRgXT7txsOYfAC7mUa6gOObxCbwggNAHAZrj49FAFkEwwxHbarDToqr5wPvCtTroJjvnSTrYKSeeU30OLpIR5Bc0Mhq+Rn06duQVGlZMArzP7NOWPnK3c6SRbwQ/LnvWXtBvqRxCWK3OwAwBi5u7GJ2x9R6/bWbOiJW6dU59byoUK056XzYrKXN8M1Inn6jldKuNzNzxKlTT6Dl5Dv+QWrSgXOqFbHWIoyYSLawIdf6lNsr+A7223Ct+/NrhAg
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(8676002)(47076005)(426003)(5660300002)(316002)(508600001)(921005)(36756003)(36906005)(31696002)(31686004)(4326008)(2616005)(6666004)(16576012)(86362001)(83380400001)(7636003)(26005)(8936002)(53546011)(186003)(82310400003)(16526019)(110136005)(2906002)(356005)(70586007)(36860700001)(336012)(70206006)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 06:57:24.4244
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86dbf45c-e21c-4d23-344f-08d99e9730ca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2339
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-11-03 8:21 AM, Yihao Han wrote:
> swap() was used instead of the tmp variable to swap values
> 
> Signed-off-by: Yihao Han <hanyihao@vivo.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> index 740cd6f088b8..d4b4f32603f2 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> @@ -907,12 +907,9 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
>   	struct mlx5_ct_tuple rev_tuple = entry->tuple;
>   	struct mlx5_ct_counter *shared_counter;
>   	struct mlx5_ct_entry *rev_entry;
> -	__be16 tmp_port;
>   
>   	/* get the reversed tuple */
> -	tmp_port = rev_tuple.port.src;
> -	rev_tuple.port.src = rev_tuple.port.dst;
> -	rev_tuple.port.dst = tmp_port;
> +	swap(rev_tuple.port.src, rev_tuple.port.dst);
>   
>   	if (rev_tuple.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
>   		__be32 tmp_addr = rev_tuple.ip.src_v4;
> 


just small comment on the title.
missing a space in the commit title after the colon.
I also think the prefix should be "net/mlx5e: CT, ..."

Reviewed-by: Roi Dayan <roid@nvidia.com>
