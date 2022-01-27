Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C792649DC27
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 09:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237616AbiA0IDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 03:03:42 -0500
Received: from mail-dm6nam10on2046.outbound.protection.outlook.com ([40.107.93.46]:37985
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229656AbiA0IDl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 03:03:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bGT50wl8PozukrhvTKX827JjZQL0NZKgrMnVWech/A+B8LfH7c2oAYQik7pkx+lDP7YZHQiKpM7HUjgphlhDT6t7XYcGz7+EPcnUfb+8wY13ZVDokD3GJC8+RNNKOBqGYcIVHYXOudivRx4xK2OnTgRiKpMF11n+PAEZSZWzshHQDD5W7o1oGudOgoP0fjEIhv0RFy7jYfH/i7ZzwWe02R9fzpvOig80Vqiwx4C83jNXNmAlpTpcS3OJ/JnOtG/NodKqevD3O9ZLPVcKmJ6GkasgObi4n0lUOy5Pu9EFxHMoiwAQCODyrvpW47OSYRPVRwLNbUSY14Zxk2LjTBGvCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6x3iIGyCGsN68lIF6ed9AghORaspzdJVcLPtIKjcQKI=;
 b=cuxngiT5hdwWE09uxwi5SZSJA3dIpMWAHffxsmKmi42jkBHPAxyNaqm0LDxeEZsre0xT6WmPkp84JHu6hrOY6mIMX+Bc0pZSmo1CXcJiv5ut/ytKHqoqp8/1HSFh7wt7rmXdwp6a6XZr1h87vEgfcDZGvv7HAxGJiTXc0D0vNPG4PoYxbnbcXEuDoU2fYW7mn1kMHcsQdcRyfTwhSMeOXGCXvzZi3FTBHtIlKaKabAe70XBL58IMYXDtgvQvNGJptH8PBedoEQAafWj3GNJVNfgnfl3abI3frpF6CnOWb8LIHnMbG564GPd2ICMxT2nttdbRTvC+2yH/8vdS4A0+BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6x3iIGyCGsN68lIF6ed9AghORaspzdJVcLPtIKjcQKI=;
 b=NpZHsjjJ/5PT5aW0vu8nYH751pAGqZdvQQrrPEBBpGGCUNhvVTQq5zn5jfypzbnNVPjZNYLYixgRBQzuMManpc/DZKk5LUZ2cDG/j2A3/W7gDeHALZIvP0zUV5c3FN5JnzxaEn+pv3q5KvkR4/haQulwdZNgT9E5V1NtJ2v5uK1fBMBeNJK0hlRNWIykegfPTiGh5uOgLbVFOR320gLdyVGjPTdw0Y/u1vk1w1G1y5YalCsTKlZDHMnqiHF/HJN2r4mAlAYy7eq393tCHunTZAIUAEYjnjoJjvF4fuT/+EBQAt4zMSKOixu1whnHMPsfH367u4Jsh53X1Y4DyqpHVA==
Received: from MWHPR15CA0033.namprd15.prod.outlook.com (2603:10b6:300:ad::19)
 by BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Thu, 27 Jan
 2022 08:03:39 +0000
Received: from CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ad:cafe::ee) by MWHPR15CA0033.outlook.office365.com
 (2603:10b6:300:ad::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17 via Frontend
 Transport; Thu, 27 Jan 2022 08:03:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT042.mail.protection.outlook.com (10.13.174.250) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Thu, 27 Jan 2022 08:03:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 27 Jan
 2022 08:03:37 +0000
Received: from [172.27.12.64] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 27 Jan 2022
 00:03:34 -0800
Message-ID: <fc5450f0-5d60-ac5c-03dd-e42507a52465@nvidia.com>
Date:   Thu, 27 Jan 2022 10:03:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] net: bridge: vlan: fix memory leak in __allowed_ingress
Content-Language: en-US
To:     Tim Yi <tim.yi@pica8.com>
CC:     <roopa@nvidia.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>
References: <20220127074953.12632-1-tim.yi@pica8.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220127074953.12632-1-tim.yi@pica8.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: drhqmail201.nvidia.com (10.126.190.180) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 924f644b-26cc-4330-1c18-08d9e16b865e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5144:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5144AC163F0468964C118632DF219@BL1PR12MB5144.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5daQcw/v4+90rVCo+vJCjvVsMKO/cRjdBHz1u3FenHgQLXwSdHMve4ioxJdZCFgzR3TsN+jjKmSkubK5PbGFPpuPUONK/6IvGe0VzdKtkhQ9MMNd+d86TUFMWVKe1M5MlmWU17zHKEjlrSv0oXYVsH1WbHRwGXpDKJ1r3F7tERAOYRXSnD4GOzMFvNquj58iJQi/a3PjarfqIyzKl5ANxl6mqwyAA3T7xTORAvoqt5bTugYzgucW9ZvvaO1kfIlsJmt+nb6H4kT/lRpdR1j/NEA1CRzgiixaxG8kx6aBqRHdJRkR5DbeoKd+mmqIFt/FjGYPvdPnC/m0zWYlxn/5+hkpBq/ZlMJo98Hj6W9twFfCFDmpBP1s/0V+YLmhdhFNA/foQwknlVZUUmF9onS8F3wmZ1wH5lL9RMVWING7ieh0FIEe/8c3/1pBVO99LjdqULfPz7ad2wUmbbnus7atl9ZOxAzMgNzaUwlGVo8e5iybBg4K18POBnbiy9F4mm+uxIBCzsxUhrOdjMbH6I9aKDNSSz4u0NIUlklC3HsvFd6NDMrjtYEjljwT7hAeMs16v4i5cTbks8UpnRh+xh9mXxXqPa4DxjChHjHoc2OoOYhgOpAVA6I0bjKSy3WqssUhSUH6sAd0EQnTQoL94kRVJvlEkEltDUlWI21I4ljx3aRmsb1zpJyj7nbaANuVh7QjUMYA++pwnw/AA9ywaN1E1d9PP4rBMtvfnf9cd5+D3XLK0B2JtXI2OJ4pvFI4/Q+4
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(26005)(426003)(2616005)(16526019)(186003)(8936002)(336012)(70206006)(8676002)(316002)(83380400001)(70586007)(2906002)(31696002)(81166007)(40460700003)(86362001)(31686004)(36756003)(5660300002)(53546011)(82310400004)(47076005)(508600001)(356005)(6916009)(54906003)(16576012)(4326008)(6666004)(36860700001)(43740500002)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 08:03:38.0606
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 924f644b-26cc-4330-1c18-08d9e16b865e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/01/2022 09:49, Tim Yi wrote:
> When using per-vlan state, if vlan snooping and stats are disabled,
> untagged or priority-tagged ingress frame will go to check pvid state.
> If the port state is forwarding and the pvid state is not
> learning/forwarding, untagged or priority-tagged frame will be dropped
> but skb memory is not freed.
> Should free skb when __allowed_ingress returns false.
> 
> Signed-off-by: Tim Yi <tim.yi@pica8.com>
> ---
>  net/bridge/br_vlan.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 84ba456a78cc..88c4297cddee 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -560,10 +560,10 @@ static bool __allowed_ingress(const struct net_bridge *br,
>  		    !br_opt_get(br, BROPT_VLAN_STATS_ENABLED)) {
>  			if (*state == BR_STATE_FORWARDING) {
>  				*state = br_vlan_get_pvid_state(vg);
> -				return br_vlan_state_allowed(*state, true);
> -			} else {
> -				return true;
> +				if (!br_vlan_state_allowed(*state, true))
> +					goto drop;
>  			}
> +			return true;
>  		}
>  	}
>  	v = br_vlan_find(vg, *vid);



Good catch, also should go to stable, here's the appropriate fixes tag.

Fixes: a580c76d534c ("net: bridge: vlan: add per-vlan state")
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

Thanks,
 Nik
