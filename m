Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96BED39A58D
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 18:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhFCQQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 12:16:27 -0400
Received: from mail-dm6nam08on2069.outbound.protection.outlook.com ([40.107.102.69]:62752
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229597AbhFCQQ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 12:16:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eiZOCMUNMd0ZydIMDHqJS3nQHgdluQqiQYOcMnVXN5iKaETHJNmmnm5dn6+mnrg/NCxkjm6OEuDj2IyoUf0FN6ZmGDbG16QlKgrpSyOIy0OpXNMaorWa3ru7xvd75uswhKMtbiGo+c1esTKsxukJKhRTIXtw3bTVMnaEI1MZfnCAD5D0xm9+/khgNcb5HxZoQ4ZtPvQbefnlB20fRaQiHD5CoUcN2tgTkVzlzD32APi1YMngUj7CHygiRJH8dC7Pnrm8Q6U8JRzZ8wT7Y463qy/IIC3wxBcUlJPNszRj9LiWBoDvNhIvCV5fHimHcftDn9q5nZMKo0u1XipXL9Ikew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fWSwQd92IOwFxL9uuPDkfXTdCJH5srsLuaLkVwEUdw=;
 b=OSOg42UHXY3zE0rEAtXcwee8LuZJpIURUT/4kXNhFSKwtJtJDaIGz6AlADQNvpmHl2F33yDvVBxhH3P1UF7d18wyjoghQ2LOcLzFNFaIhDcMaj3IoDpSnW8a6MhhQrHuA/eqhVtC6Pg9kAoM5y8bfaLIJM5FabpJpu3rDVOdVAXqlChCNSwek5LebPJbPCmyxcOKAxw4ctj9TApIQxGUI4iRCvbw235e12Si0H5rU7VIvWMu49/bbgOFDRBcFlcszVkpeP6G1HEy6R+K1IZ2dMPXeWao32lf0FDnX9I+c3ZGDMJ7RfA8PFyDGo+ndg5eKZ036+maHkoVwoVfbedVsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fWSwQd92IOwFxL9uuPDkfXTdCJH5srsLuaLkVwEUdw=;
 b=ds/a6e+q1DCqSQXOIDD6nKwVHjIcQQ9aT153yeimPfHD5Q1Vj1hRU/JB7IqZdberCfRuXAGD4ChbZY8mZxhj/CbRaDW9tdanYsIczaQONrnA2w429JNjRPBHIOpQy6BfsOygXvY7cWmSuZHoP31BPMywx45uDYNWk8GN41B21JK0NH4gASGcDHmB3k66Y/B5rUWxtNgHD8yvOABJhOpovw5nyCkzEUwEV9LxSvx0uZV0QtA4sq/xWVw03Mp/MPvX7M031SYgEYQeQTLq69e1nyRqQvg3xKIOA4McUUudvcrvoLO5H+04cectG/DpadW2RnKLapT3UTNRHLE09DBLew==
Received: from BN0PR02CA0049.namprd02.prod.outlook.com (2603:10b6:408:e5::24)
 by CH0PR12MB5028.namprd12.prod.outlook.com (2603:10b6:610:e3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Thu, 3 Jun
 2021 16:14:40 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e5:cafe::63) by BN0PR02CA0049.outlook.office365.com
 (2603:10b6:408:e5::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend
 Transport; Thu, 3 Jun 2021 16:14:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 16:14:39 +0000
Received: from [172.27.13.231] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 16:14:37 +0000
Subject: Re: [PATCH iproute2-next v2 1/1] police: Add support for json output
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     <netdev@vger.kernel.org>, Paul Blakey <paulb@nvidia.com>,
        David Ahern <dsahern@gmail.com>
References: <20210603073345.1479732-1-roid@nvidia.com>
 <20210603084957.7f62c467@hermes.local>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <c15b9c71-1c37-a82d-a167-b56eace6a3b0@nvidia.com>
Date:   Thu, 3 Jun 2021 19:14:34 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210603084957.7f62c467@hermes.local>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8aec4fc-4b0e-4753-8307-08d926aab0c2
X-MS-TrafficTypeDiagnostic: CH0PR12MB5028:
X-Microsoft-Antispam-PRVS: <CH0PR12MB50289B6771619FAFCDC535E1B83C9@CH0PR12MB5028.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:269;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZclaP7NAK1D8d3kH0SyCrnH3wfdfb5T7sHi7bk3T1v9UVYj39IIKwvCgLmwfAX8svKruedTjcJnQDRxVVdP3VRVhq1P8Rm2QciTkuvxaTklM/RhMy72uxloKF2A1pH47HWVnNWeRuNOOBPsPBbg9QnEB7A63Mn8QoYcuu2ZEP0frpgiYRiI9e02uRjmlpnBY0e4k7BtK64bKxtSUw0klgJ18wPPPyWEZKk5prtVT+hCfRu7AlRyxAb/moDzqlxrNVDuKgNgEt+Sg/LrHOsSwf5/WFfJE05QZ9gu1EjVDOFiKg7jYSa2UOvnAaSeifMb1Uvm4Is+XnCXf9CTRZmoGSwDUFeS+C62NjdZ3MW98iQ+4Tp+Z6YEYPTUmogkSiUi+eiYCwktCT0Jp9VrK1Y+Oaft5FYLlUUX6hcn235HSr2i7qAc5rGxSsiQqLKlM8NtUEopzYFoyplVXRKTL3qgMU/HMyAGbOHK0GDSHWZ2F3tG6XpkC6Yysyk5YO+oW8sCKRUvwEF/7JAqxHe+JY1/mzq15ks2L3wPCufRpHNCwX2Q4zUZSeipBoLi5klFxsE8ka++mSLKHCZzcPmaYUQje3ftzBt8a8yMhc/RAI21RrBPLPMSYPVTdSo7euSVn/MIcDzmGrL7UKOGSsZuPW41DZuppVSDhXKIJlUWAvh54IUrWt8cfSs6OdpK5sybdExES
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(46966006)(36840700001)(2616005)(426003)(336012)(82310400003)(31686004)(82740400003)(356005)(16526019)(5660300002)(26005)(6666004)(70206006)(478600001)(4326008)(186003)(36860700001)(53546011)(47076005)(36906005)(316002)(54906003)(70586007)(16576012)(7636003)(2906002)(8676002)(8936002)(86362001)(36756003)(6916009)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 16:14:39.9620
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8aec4fc-4b0e-4753-8307-08d926aab0c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5028
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-06-03 6:49 PM, Stephen Hemminger wrote:
> On Thu, 3 Jun 2021 10:33:45 +0300
> Roi Dayan <roid@nvidia.com> wrote:
> 
>>   	if (tb[TCA_POLICE_TBF] == NULL) {
>> -		fprintf(f, "[NULL police tbf]");
>> +		print_string(PRINT_FP, NULL, "%s", "[NULL police tbf]");
>>   		return 0;
>>   	}
>>   #ifndef STOOPID_8BYTE
>>   	if (RTA_PAYLOAD(tb[TCA_POLICE_TBF])  < sizeof(*p)) {
>> -		fprintf(f, "[truncated police tbf]");
>> +		print_string(PRINT_FP, NULL, "%s", "[truncated police tbf]");
> 
> These are errors, and you should just print them to stderr.
> That way if program is using JSON they can see the output on stdout;
> and look for non-structured errors on stderr.
> 

right. thanks. i'll fix it.
I think I looked in m_ct.c example for the print and there it's using
print_string(). so i'll do a commit also to fix it there.

other actions use fprintf() but they print to stdout and not stderr.
i guess those should be fixed as well.

any reason also why the original return is 0? i think it should be -1
also in that case.
