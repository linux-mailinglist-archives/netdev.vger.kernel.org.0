Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99A13C5C2E
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 14:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbhGLMcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 08:32:48 -0400
Received: from mail-bn8nam12on2064.outbound.protection.outlook.com ([40.107.237.64]:37888
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230503AbhGLMcr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 08:32:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+tY89ka/1ovfZvzCLhwGEaCccZyCacGG/lSWtYj5dtv57zXMHXsJU1gdvffWkI+fgcJmBR6qkXZNiDshTE3P0+srds6oabv7XCWZFby/zf00SHqhG6XchO+38hW+L0QG+0BvcuJBODvRnHwyWQ6nHcjH6ZWHRPLa3AQVleiCQEmBs0HnxbapIqXYLMRsSpaD3Fb0kyH0p7B1St0gN9DvvujaeGHoQaogSU66oWXOcaQB33EC/tQ5pLgZSwYKcJPnACRDMbOGSFdXYfpmS6IyHgpdacxp2ypb5WTyv+YIbq3Ddt+nMA2nw7LanenOTMEnmTh1cvhgpwx6rd4x+GOSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RWLsBjUzojSIZqvLUN08q//ngkQ1cAKSvr1qDy2xQeY=;
 b=Be+lPQ1KWCX88Sfrs2WfyswutFGLrffz8YxU2tvjJq8mE6GKvrtaiOQzBDakTkl+ApOvU4ZSabjmwXuvlLD/F9NdFfhknbNuQ+ljMaVSp/tlMzVeCCO7SPh2ctAVtsSPfTt4taX0UA0NTSX4MutYJxFjTHYhBCIeaNXGlS3+0QV0+BTusALJTeSJPPGLB9rqBNjvXO1h/oVWzltbP+q5OZDY8aFecqmSemerlVQ5Cba87SaDmDZ9UREg4A2o+R+eGZqxso8spg45fLtR6NZZZNzJFxkUmEpSSWGSkMtZqGuUZcP/VzjIUB49u8hvzb2ipvKWpg3ls+VUDBxzPtV4vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RWLsBjUzojSIZqvLUN08q//ngkQ1cAKSvr1qDy2xQeY=;
 b=ak3YHBt9DcCHlGHfP113w8abRpZ0EaDu4IuiFbawZ2pQ+YZ4SmkdCFcSj6wZMd/otbfgHGbpbXXk/xBMO1ezSR1YZN7dIpFyebNFfGE/2tgGiwJ80Kv1NSJCxEvnp1bYvbUxIeiKLONAe/2WVI6INLrpGVgsM4Dgs370rbGbbZZNL97xZ0DidDl+ZYPTieLPRQFFCXqggV4jg5pvXediGWnW4AhAJWu8HmPa/5uBtBESkrp9Jfe5XRcRfMxzLa5ungZD8lh3ytR4yJWX7YkFejWvMRUtceqJ4ADCXc8yKnkdnMGHvNcIxyn9vehRVWwILkx9n1nMNwmDYZHVhts3jw==
Received: from BN0PR04CA0117.namprd04.prod.outlook.com (2603:10b6:408:ec::32)
 by CY4PR12MB1478.namprd12.prod.outlook.com (2603:10b6:910:10::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Mon, 12 Jul
 2021 12:29:57 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::cd) by BN0PR04CA0117.outlook.office365.com
 (2603:10b6:408:ec::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Mon, 12 Jul 2021 12:29:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 12:29:57 +0000
Received: from [172.27.12.28] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Jul
 2021 12:29:54 +0000
Subject: Re: [PATCH net 1/1] tc-testing: Update police test cases
To:     Jamal Hadi Salim <jhs@mojatatu.com>, <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "Paul Blakey" <paulb@nvidia.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        "Stephen Hemminger" <stephen@networkplumber.org>
References: <20210708080006.3687598-1-roid@nvidia.com>
 <54d152b2-1a0b-fbc5-33db-4d70a9ae61e6@mojatatu.com>
 <1db8c734-bebe-fbe3-100f-f4e5bf50baaf@nvidia.com>
 <f8328b65-c8db-a6ae-2e57-5d1807be4afd@mojatatu.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <259c4c2d-9ef6-9798-e68e-b3f89754b100@nvidia.com>
Date:   Mon, 12 Jul 2021 15:29:52 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f8328b65-c8db-a6ae-2e57-5d1807be4afd@mojatatu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cce3fa3-5b27-4468-5374-08d94530c2b4
X-MS-TrafficTypeDiagnostic: CY4PR12MB1478:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1478D81E22C0EF542E5CD9C8B8159@CY4PR12MB1478.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hPRI5nVzRQ75fQ0gnH1zOr/m9zKnEAjK5rgYUrLtAjSidB8/dnHmt97g7IIpyaV0wA+qnVAikVK14B++OyXd0v8wPYsqutfTM90QiM0uyShBiYH8ubJ1EZh7g3NddXQP56wJR6kON95K42izoFfa1//uf8qNzOtbqBe0qNQeC1+8z1bjUO7QfOiUp16MWq7Eo92JoT/U3mu/HSt8gZkG84fQ0TB0mVgeoKXgf41W7+Tc1jia7fVvIeJmC3ekFtc0GEbZNd8jnKoCVTxoA/tb1CFINAlQ15+9Ef5Kxc6ynMeF9CO5gfeOFPUCnb3vBeskfonIT/7PfN1PhEhvLoLJYKGglu9DuknfcwSrRVbvpdesfCK5sd5fPBuRdiGQ4Dz6hqIUDwcRVUCgjumbGEAwOjrtAqfgPSlFKz6jKQvj0JmBV7+4UvilE/zvxowWRAIuSIjGHj0pXqTj4b+nEuGoRC32CN4X1DMWGH8GZIiIfs9h+EIqZ5gPtClqGFIA1GN2exg1yYfrx9tD1E7AR/WO/89JkzTCbS9hcxQYgU/O9/lJlXx9dueL3Pz8di/7/REr6de3UTBFfpbngfsig0Wzec1Mt+D21cHoXJndIjhxyPSdrCpv5lz6D/eOtvWR0m54PTyeN5Rlz20QpzYOZIyUzA6xNt552LxEmkgtBmUDWed5Ycc2BqT7FP89P7ewU+VPk6VoKLjV4oBHj0I/hF52OWg8bmrmnU1+grPv8OJHWbtzW6nCXAH8S9/fbR4Q9435UqAvBx3SErsaEokz0cCLCg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(396003)(346002)(36840700001)(46966006)(7636003)(36906005)(110136005)(478600001)(16526019)(8936002)(426003)(82740400003)(54906003)(2906002)(316002)(2616005)(336012)(8676002)(4326008)(16576012)(356005)(82310400003)(26005)(31696002)(36860700001)(70586007)(186003)(86362001)(5660300002)(70206006)(53546011)(34020700004)(36756003)(31686004)(47076005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 12:29:57.5061
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cce3fa3-5b27-4468-5374-08d94530c2b4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1478
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-07-08 4:05 PM, Jamal Hadi Salim wrote:
> On 2021-07-08 8:11 a.m., Roi Dayan wrote:
> 
> [..]
>>
>> no. old output doesn't have the string "index" and also output of index
>> is in hex.
>>
>> it is possible to make the old version work by allowing without index
>> and looking for either the unsigned number or hex number/
>>
>> but why do we need the old output to work? could use the "old" version
>> of the test.
> 
> I think that would work if you assume this is only going to run
> on the same kernel. But:
> In this case because output json, which provides a formally parseable
> output, then very likely someone's scripts are dependent on the old
> output out there. So things have to be backward/forward compatible.
> The new output does look better.
> Maybe one approach is to have multiple matchPattern in the tests?
> Davide?
> We will have to deal with support issues when someone says their
> script is broken.
> 
> 
> cheers,
> jamal


this patch should be ignored now.
see "police: Fix normal output back to what it was"
