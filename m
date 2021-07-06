Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5443BC7EE
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 10:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhGFIjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 04:39:07 -0400
Received: from mail-co1nam11on2086.outbound.protection.outlook.com ([40.107.220.86]:58977
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230356AbhGFIjH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 04:39:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ni9MUXj0lxiD/NJNLbQKFYVe4lbTW8yK8FgksfHeNw44GNNix3CxC3N2QsnTiC06mMG1eoVQCbrXIZZyx3pRUh1BF8BStGKYnMPu5OwIGtA8Y2XQs6TiCpEMmE9RL/QjwWlYFHsJfDf6YGYJH1uwai9jtDxRvXsLRXJgiuzTU/Aq0owsIEM+YEXIJah1ISIU6y51hSJREAZdJ7x44XiRUJ5H2BlxsFRVW6Dwog0e2HMXNTibYLBK73BNBsD7G4gpIG+cGfyF39HVpsq2FTGMxLIrE6SDvj7RZwuzGArGjRq8UTsazDxdSPTYX165r1kBxIjPzEXfb48SlWRjOPKxYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=odW6qTtv8zJ2S5LOmxyJwRtOM+uZQ1zHy0h92FaCz7E=;
 b=fJSOk8qiTUPFm1Ho3xg98dGxgf6izw32XCoZ+pTfRMfJuI5SLnf62ysnB1T1/EpO/Beh/TaBmQDmZYHMPEA5uJqfIKI25S1vVbVNflBYOEL/nHqWuRMcDtZopjmB/LxVgjSsGIFA1ljOdM2I3IEq3YE0Mpq5fXc+pWZS7pmBoUnc8FZv2ABhrWYQKkhoU59UnSrun2Oa5TRIzFU6WFdPOe1Ku1aEk9hLX8BoG3r3IaRDM9ujjrvT1JOiR8QcEhFhuNBgUEkFoJ25LohORNhwRIp8l29Zm7OQxiZJBXZDuflrpjbAkvIRa1SP67QuHZBl6Iptt7GgF8mOd8epmeEjkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=odW6qTtv8zJ2S5LOmxyJwRtOM+uZQ1zHy0h92FaCz7E=;
 b=jmoKbwyS1tKXZyxwyKI7dGcj5cb69UQYsmD4rffNSdDOurSs1kSrrm1p9aruRVQgB+DdPHGfFcEhybUrooHCUIcH9tJwewbAFfoUmknMwLNfGxCjQEkWiA4WjwpsPXcbWlapAry4xJUpHstqgdfwQ2ea5RF4oZsDb4vDDHEmfn+468Dpdn9viWk4Md73JYv2DSsG3v36TcA13TSVKyU9SszmAFGMtLC1l60y6XF9Vo/5BAGXYLEToks2x5+/Ismv2n9ynZZDoVeLG3vzuaEYbD9EQBVdx85X0QLXsdz94oestzFL5e9bQl4kry905Cyfj+nizh1Zwn6ptYud9MlIcA==
Received: from DM5PR15CA0043.namprd15.prod.outlook.com (2603:10b6:4:4b::29) by
 CH2PR12MB4118.namprd12.prod.outlook.com (2603:10b6:610:a4::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.23; Tue, 6 Jul 2021 08:36:27 +0000
Received: from DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4b:cafe::60) by DM5PR15CA0043.outlook.office365.com
 (2603:10b6:4:4b::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend
 Transport; Tue, 6 Jul 2021 08:36:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT028.mail.protection.outlook.com (10.13.173.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4287.22 via Frontend Transport; Tue, 6 Jul 2021 08:36:27 +0000
Received: from [172.27.11.204] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 6 Jul
 2021 08:36:24 +0000
Subject: Re: [PATCH iproute2-next v4 1/1] police: Add support for json output
From:   Roi Dayan <roid@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     <netdev@vger.kernel.org>, Paul Blakey <paulb@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
References: <20210607064408.1668142-1-roid@nvidia.com>
 <20210705092817.45e225d5@hermes.local>
 <3678ebef-39b3-7e00-1ad1-114889aba683@gmail.com>
 <5918cbc9-9569-15fb-6ee6-fea13a7cca2d@nvidia.com>
Message-ID: <618dc534-d4e3-823f-9a7a-fcf5b8d9d7d9@nvidia.com>
Date:   Tue, 6 Jul 2021 11:36:22 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <5918cbc9-9569-15fb-6ee6-fea13a7cca2d@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f66c4ff0-aa32-4c6c-1038-08d940592569
X-MS-TrafficTypeDiagnostic: CH2PR12MB4118:
X-Microsoft-Antispam-PRVS: <CH2PR12MB41180B79D624194ACA284DAEB81B9@CH2PR12MB4118.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QCEJAs/2hgvK2f2q8TKyFHFBWRdaJB1csQ0GFoexrxcchK2hVjZG5pPMquS7KRPCjceXiGzOsSty7L0tG6Paa1WBD/vNbYPYrED8LOAeWXVZvCUoIRXO9dhCfM4F6+zg1k172JxKKNYeNDMkcJBhjDWQNF09b7oYLSqzhVBzP4nmj3Be4xltS4UUf1rsGpd5giCwsEU2WN9K4j1FsXX8y//NqUJndulkZSh0Cxbv+5FNcrO3YPD6l5jOlvsVt9LNdxG3xJGw6fzFh1ebaNH4o9ULfEvy98AHOskjLM2+1Rs166GOk4aErHmDBIviD4femtPCVlBIy6CnkdOxsfu8jW0jYa/TrHpHoZRuuniXOYYIgslZed6nBtxPgM/g7qqhY+9mkosjcvSuSUbBqJQw16l3rB+RMFcVEInenJnWEwtch/XGWyhdr206B7tlL+GSqE5ID5IkOjnwh7Gx8Kb/QewOLKGCgOaQ+llSId9iH1XSVytXV7daUe8NZVBLAZeIKqE8OVJ5Tb4t/WCE3AV/xLnYXjb/5AdScz1vSqLNtJ1HiXOVXeeUO3xG2PBwr0v8zy5HtwmcR81TgjCMsEIF6VkdQCH7K5kCHJRdXIGOr4a8h1PMejOVtzumOKGklCcWIx83GIj+S4uqaYydXyGnXCQC32rogb7yjB7UjlpXKalxrYN9N0fQSuhD4p7wvL6GqT6xCQJ1Yyn3vjwv6cZ+7MWmBvg1ycKjw8Ot0SFuuiY=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(136003)(346002)(46966006)(36840700001)(426003)(16576012)(110136005)(316002)(2906002)(83380400001)(54906003)(4326008)(82740400003)(36906005)(336012)(31686004)(47076005)(82310400003)(8676002)(478600001)(5660300002)(53546011)(31696002)(2616005)(70586007)(356005)(36756003)(186003)(7636003)(16526019)(8936002)(36860700001)(86362001)(70206006)(26005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2021 08:36:27.2535
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f66c4ff0-aa32-4c6c-1038-08d940592569
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-07-06 11:30 AM, Roi Dayan wrote:
> 
> 
> On 2021-07-05 7:30 PM, David Ahern wrote:
>> On 7/5/21 10:28 AM, Stephen Hemminger wrote:
>>> On Mon, 7 Jun 2021 09:44:08 +0300
>>> Roi Dayan <roid@nvidia.com> wrote:
>>>
>>>> -    fprintf(f, " police 0x%x ", p->index);
>>>> +    print_uint(PRINT_ANY, "index", "\t index %u ", p->index);
>>>
>>> Why did output format have to change here? Why not:
>>>
>>>     print_hex(PRINT_ANY, "police", " police %#x", p->index);
>>>
>>
>> it should not have. I caught it in the first version in a review
>> comment; missed it in v4 that was applied.
>>
> 
> Hi,
> 
> I replied to your review in v0 that I wanted to match all the other
> actions output which output as unsigned.
> Since I didn't get another reply I thought its ok to continue and sent
> another version which other changes that were required.
> 
> 

beside the unsigned the json output in all other actions use "index"
as far as I notice.
the action name, e.g. "police", being printed under "kind" also to
match the other actions.
So I wanted the json output for police to match with same keys as
the other actions. at least the keys "kind" and "index" which all
have and not each action use different key.
