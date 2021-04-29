Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8290A36E30F
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 03:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbhD2Bu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 21:50:59 -0400
Received: from mail-dm6nam11on2072.outbound.protection.outlook.com ([40.107.223.72]:56865
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229888AbhD2Bu6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 21:50:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FPw8BbC3ljYN8WtOuWtx6O/sSZYNSWn2Fd0z1Nd6DH2BBDN6d1ULGuWWhhRp+KOdHpwUHr/npj3elu7mpCzeDD/ckMgdFdDNuesrO8CPxd3o464SWyUVaf4qgrlA3SQaMQyVLYjhNavgPp1a19VVxaF0en/bvnhCzWWGg+RWOwfqDFMty1UeHZOYPE/gxyu5EmMA+o06jHIOL7PoDTLnG8FFB93qOe8obyc6P4BEC4leKVhPdGQ75U4mba8/Ox4kx1clv600qO7shdWoX7EWz5MoMMQp/WCHOXDMIdLWI4udBno3My/PpqJqIbbEZdtTM85kUhg+KF73ekQ8gna/Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRSCMehYLVt0GJPszDu20cIu3siEfVnaffa6xmehWfo=;
 b=a7vjwD+H9I0cfy3TbQMtv/wwFO8VICrhyxbVTzJQe/h+VtXdgnOav7vBqMApmejBGNdGLvj1Gzr/MAI1sclMdeoLBxj6DIAAXqZfrR/Wf7JPdLtPTXjmgaTTBOchFkeDo/nDdIAgeVjgBlAJOu+H0Z8ynFpR947bHxwiqynVJRrx29QB7pEpYrHv+qTrAfJEa63qvcVDdkHmRpZAlDmcK/CDcepBwOGNCx+Ao15WPFXBbsPZlkyNBAopq7oq4ozi4ok2LQrnkEo5WNkvW6Sj7gpJSEcjbskeoazNfGOrG0SyaOnYnmiDvM0L2Zs0BI+a3DBeLsmjhDucfIHkNVHZ3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRSCMehYLVt0GJPszDu20cIu3siEfVnaffa6xmehWfo=;
 b=mXTFFPK5bvWbnjnNfoynOJkwpM9B3esjLdp0msHf8Tf38Ofi7ZLScYcQp1s8OOVSDya/DQYMT+s6YoP6S13noTsQs6QPGGwbc6r0CDnmysw+LPl48tlXLt2vvkYdWfOZ1/FoGogXXSMXGxiIYGEV4HPYJU7QpCUzY0C3mC5g+WaWBqLt3CK84CORnvD24bJ92fum1S++Zbaaol6XKPUxl9VbftsmmH76gv+5uZsaD0HnC1OSQTySWiqyyaOawQLOZ7a08aE/ufXKUh3OXgZ0F/1u0cWz+PCR78FqtY1Psyr9NW8Zgg5rzU8OJYvs5uST4aUnMpAN14u38LRDPPoprQ==
Received: from BN9PR03CA0130.namprd03.prod.outlook.com (2603:10b6:408:fe::15)
 by SJ0PR12MB5406.namprd12.prod.outlook.com (2603:10b6:a03:3ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 29 Apr
 2021 01:50:10 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::54) by BN9PR03CA0130.outlook.office365.com
 (2603:10b6:408:fe::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.29 via Frontend
 Transport; Thu, 29 Apr 2021 01:50:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4087.27 via Frontend Transport; Thu, 29 Apr 2021 01:50:10 +0000
Received: from [10.20.22.223] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 29 Apr
 2021 01:50:08 +0000
Subject: Re: [PATCH net 2/3] net/xfrm: Add inner_ipproto into sec_path
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Cc : Steffen Klassert" <steffen.klassert@secunet.com>,
        Raed Salem <raeds@nvidia.com>
References: <20210414232540.138232-1-saeed@kernel.org>
 <20210414232540.138232-3-saeed@kernel.org>
 <20210415100049.7dde542d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Huy Nguyen <huyn@nvidia.com>
Message-ID: <677729b5-baa5-f6fa-c4ee-1d1417e4779a@nvidia.com>
Date:   Wed, 28 Apr 2021 20:50:06 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210415100049.7dde542d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e6c26e3-5914-48d4-e7b9-08d90ab11fbb
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5406:
X-Microsoft-Antispam-PRVS: <SJ0PR12MB54061FC466B1468EFC72D2B8A25F9@SJ0PR12MB5406.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qglm28yrH3+5jVPLiLcUhsdSWWaX7+s3cTcNQlXo+LaOVkRZ+vs9W42ysqtFGu4RAN7oCmcOTQImnBjfapVLU/85Or3+bPyyJY0VybVOmia+jUqQQg3iNQ4McdjM7bAcosSoZ9tyg1jyJvDDXTjz+e2ybe1qNtESY60OG0hEbvtg8AyG2+mSj9UHfATqXQqP6dAu3Xt6wDgh5fcp1xXgI7dKzzWgECx9Mh5St6MKcQXitL4t4LV5ODN+F0J5v03loui5asACq65kSIzxqQmYpmuy5+0pfVf0jSymiWrm/0Miiz60byUqF9CxBi4TK5Cxm7hZIMdjvzNoA+9YYdGmYjJaYLGfcLg6vhie+bGZYkFqtIW9vrusiD5dVInOPOF6bw9BTlZBgydT3I0rM+9HUFlEiJxaZPNWAWFrKY19dwLgORABeIZs8lAmU1CDwOq6C+OYsyiz7iVaGo9WWJumYMAXrl8maaz+M0GcZi9cgJZd2XDs/XrmyUMqosMQTfQO6j2Ma5wvGoDDxY/CBGVjX6MKdtVUwCe/qH8wd7GCFyjSq8ObPqb9y4n/uIvbHUHGtf7FviA3hwEcJ9Z3GNkvUJVvRBv5X5UjlbmKQLGTdL0jC5BIMJjyKLPImLmfukLjbSULjGoNGR55mDHcbbyDQcGjVFyjrQIR4MvHNZ41Vl5n0dgqUioQWuUMWumPYrg7
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(396003)(346002)(46966006)(36840700001)(4744005)(16576012)(2906002)(82310400003)(47076005)(316002)(7636003)(70586007)(36860700001)(356005)(31696002)(54906003)(110136005)(83380400001)(36756003)(478600001)(26005)(5660300002)(336012)(2616005)(70206006)(53546011)(186003)(426003)(82740400003)(8676002)(8936002)(86362001)(31686004)(16526019)(36906005)(107886003)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 01:50:10.5224
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e6c26e3-5914-48d4-e7b9-08d90ab11fbb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5406
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I fixed. Thank you. Saeed will resubmit.

On 4/15/2021 12:00 PM, Jakub Kicinski wrote:
> On Wed, 14 Apr 2021 16:25:39 -0700 Saeed Mahameed wrote:
>> +static void get_inner_ipproto(struct sk_buff *skb, struct sec_path *sp)
>> +{
>> +	const struct ethhdr *eth;
>> +
>> +	if (!skb->inner_protocol)
>> +		return;
>> +
>> +	if (skb->inner_protocol_type == ENCAP_TYPE_IPPROTO) {
>> +		sp->inner_ipproto = skb->inner_protocol;
>> +		return;
>> +	}
>> +
>> +	if (skb->inner_protocol_type != ENCAP_TYPE_ETHER)
>> +		return;
>> +
>> +	eth = (struct ethhdr *)skb_inner_mac_header(skb);
>> +
>> +	switch (eth->h_proto) {
>> +	case ntohs(ETH_P_IPV6):
>> +		sp->inner_ipproto = inner_ipv6_hdr(skb)->nexthdr;
>> +		break;
>> +	case ntohs(ETH_P_IP):
>> +		sp->inner_ipproto = inner_ip_hdr(skb)->protocol;
>> +		break;
>> +	default:
>> +		return;
>> +	}
>> +}
> Bunch of sparse warnings here, please check.
