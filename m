Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBFE47DFAE
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 08:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346887AbhLWHm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 02:42:59 -0500
Received: from mail-dm6nam12on2083.outbound.protection.outlook.com ([40.107.243.83]:32480
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229557AbhLWHm7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 02:42:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXrQ0kUZxzeZg9Dr1dMVAohlrdoDCM8Ox8kIrpSIWpXCZOq6nlKOimfk9ISrL30PAdynP0Nw186imZ0NHVqIR0ZHSpEZK85fjfFEeHRMYpnZxkJLk9Qi0+Ye2WHOgbcn5+0JiuBI60Hgp6+OMpgVNvJuEfJlozqdu079iEejR/6wLo0I0MymLKytuIgejwM2KhMIMZUgsuf430hJpuLL8PK/bNSm3/zCqTf3LlFzqi90Xqs/BF0a++yqwfx+bdEBMRv14s/XYYjlw3FFAd2m/jYThk26FqyglpoWeZyl3+i0K9YrJeKmYtYDFX56F+R2YqSPfw1INca71MZs45b6hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/TQ8ypWdJowcw74MF0/KAtqjsmkhSXiLQiRMn+aGK1c=;
 b=ewn7deQNfn52p2vn8EQU7xRz+t4/D2xsvcRONI+gc0KhzvzGLwsvyubPjYjH1v5TqQ2/uXP4uYp5IrWo4TvXX0q3FrWHXUrzuEk+BbHth3l061BRb7ESgEClyFor837dPYuTRQdPlDxtqqM1DTkutl2nu3F4LOMm6ij+AQzOag0g6B0JBIXxHD2rNMfd5Y6zsC3o0ni61hSvEg8sefuqo4HNgcYO5JyfUysoWjdUmpswGXKTVK0rBm0trRh6B0C617ZBVHc1tdjXHt3JoXJWybNWVdQsVnIJvBvFO+u2HnJO5hqZBpCJZQ7EOUY755wdhIMPZvilVlprCcbGbw0PtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/TQ8ypWdJowcw74MF0/KAtqjsmkhSXiLQiRMn+aGK1c=;
 b=PKXPNhHqq1bYgT3GgG7QzPE39uRdm20tPtYw1q676u87MYqKnUOM1tURsag1Ki72PjGIN/bWNiKgB1ZDMabqsdLZ7FXWE/mFteCdgaAockNbCsTjEDNEgtRcN43iibpL6EcE4BvjWJSr8J22XaghtDXKC4MZKkRr412lGwtKRcoJuTNi2wc+naxypLgKStwYY6kPWpSCtB7fspBS4uFlYP35V7Hbfts4jDt3cZo8AWYz2lk4BfT/PUBiM5o4P4/7DlW900LvdsBJuq8KJcxNrage8WIi8Qfdd0gRD35u3rkxOQoxgnTSQt4+zVFxQ5QL3Ku+OjxUZ7uwezPlHPpb8A==
Received: from MWHPR02CA0020.namprd02.prod.outlook.com (2603:10b6:300:4b::30)
 by DM5PR12MB1722.namprd12.prod.outlook.com (2603:10b6:3:107::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Thu, 23 Dec
 2021 07:42:57 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:4b:cafe::7f) by MWHPR02CA0020.outlook.office365.com
 (2603:10b6:300:4b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19 via Frontend
 Transport; Thu, 23 Dec 2021 07:42:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4823.18 via Frontend Transport; Thu, 23 Dec 2021 07:42:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Dec
 2021 07:42:56 +0000
Received: from [172.27.12.230] (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Wed, 22 Dec 2021
 23:42:52 -0800
Message-ID: <d4dc329f-ffcc-044f-01f7-5db2d0a69d92@nvidia.com>
Date:   Thu, 23 Dec 2021 09:42:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net] net: bridge: fix ioctl old_deviceless bridge argument
Content-Language: en-US
To:     Remi Pommarel <repk@triplefau.lt>, <netdev@vger.kernel.org>
CC:     Roopa Prabhu <roopa@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
References: <20211222191320.17662-1-repk@triplefau.lt>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211222191320.17662-1-repk@triplefau.lt>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d87ce6b1-b276-4aa9-d8b3-08d9c5e7d61f
X-MS-TrafficTypeDiagnostic: DM5PR12MB1722:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB17227674EAD9413E350A83F0DF7E9@DM5PR12MB1722.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G+knnafEDHcj5/33yLCqrPfWmxTujRJhvAZllFu3Gjb8NHmCRH3quioBfvkqkOcfogS6TjCnUjgxks4gPVnV+EKzLCkWyrtmjqyee4uJs8lkHj1BDKrYnAdK29ZtnYNDW00OA/0fWryUDNYI4iwjQmepsJHDBNV9++8feDM6Hq52U4TqC/SS7aSR7ztqbEUSnAsxZJWgNt8yiTFC+zs85nYGBkKsp5SwB+5TfYBu0buFqHMj09EeuQg84V5QBGDBpu2BEjW78gnqUpsetIZKpQd7v3hWBdMPX/NzA7QTtBqI15NdFXJruwwHfVvh1ccr6XbQNBQH8wvECBBJck+lqKfOBTQaYHA5OY3nw6C8JF6ZqOoGtMfa3D6nXgpN6yci4FJ+fZA5gKFbkXi71dR4MA2zAn1BPQL2ldyni3uqu0mf3piyOZuCbSuWOPsbPt3WViuy13HS0eR3l9zLEGIdUMChBjKVmNvHrmfkqaB2kz+p4UqXgunRsdlBZx12TPME/cArDgGOrxpa9BLlmZiLuOntHiq4zyxLB+OH9jr3ZDz/yIDOUjiye8OGn8pRK6yRUnLQZszCT1PBKmAZd7pDVRXY7k55tV0HPvuc95rATLFyH5FwKXBiNmWqdvQnltpk0a9Nu3ZrngFCzPUQweg2jvHGoBgPIGgKBZ1Xqck2BUzSV77faBtopnHzaz36BCe/zRLdBFCvXepWcQhpPb04aRjWXN9bXhVxAW9gULHH6Ivih1y7I+lI73Xs1nc6dH3UvuldIFQBUrZ3EcHoZ4RDQFENGA/Hqt4FP625SZHZi9TEgtYUWSs8lQVKQODNNBYY8ahDEm3eBiiANj3xFyk5cg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(46966006)(36840700001)(82310400004)(2906002)(81166007)(26005)(40460700001)(16576012)(86362001)(53546011)(47076005)(508600001)(70206006)(6666004)(316002)(70586007)(5660300002)(356005)(31686004)(8936002)(83380400001)(54906003)(186003)(31696002)(4326008)(110136005)(36756003)(36860700001)(8676002)(16526019)(2616005)(426003)(336012)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 07:42:56.9070
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d87ce6b1-b276-4aa9-d8b3-08d9c5e7d61f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1722
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/12/2021 21:13, Remi Pommarel wrote:
> Commit 561d8352818f ("bridge: use ndo_siocdevprivate") changed the
> source and destination arguments of copy_{to,from}_user in bridge's
> old_deviceless() from args[1] to uarg breaking SIOC{G,S}IFBR ioctls.
> 
> Commit cbd7ad29a507 ("net: bridge: fix ioctl old_deviceless bridge
> argument") fixed only BRCTL_{ADD,DEL}_BRIDGES commands leaving
> BRCTL_GET_BRIDGES one untouched.
> 
> The fixes BRCTL_GET_BRIDGES as well
> 
> Fixes: 561d8352818f ("bridge: use ndo_siocdevprivate")
> Signed-off-by: Remi Pommarel <repk@triplefau.lt>
> ---
>  net/bridge/br_ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_ioctl.c b/net/bridge/br_ioctl.c
> index db4ab2c2ce18..891cfcf45644 100644
> --- a/net/bridge/br_ioctl.c
> +++ b/net/bridge/br_ioctl.c
> @@ -337,7 +337,7 @@ static int old_deviceless(struct net *net, void __user *uarg)
>  
>  		args[2] = get_bridge_ifindices(net, indices, args[2]);
>  
> -		ret = copy_to_user(uarg, indices,
> +		ret = copy_to_user((void __user *)args[1], indices,
>  				   array_size(args[2], sizeof(int)))
>  			? -EFAULT : args[2];
>  
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

