Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF5449E222
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 13:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbiA0MOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 07:14:33 -0500
Received: from mail-bn7nam10on2046.outbound.protection.outlook.com ([40.107.92.46]:45025
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229846AbiA0MOc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 07:14:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EMmqklUtoivC0iAZH13HAfMSR1EssZ5PQIYMrDUI/2/ZPCNMkrSylC3xIxd+ZFmpuR+8pNhpa3qg4J1LleKicG8bJcABE8fwKsjvdFD40Mv2pQRSZhVKGwrkxtu2944jyLzHJkUWcH/yHFT71+PB8eHRd2eqPrt8tQuqyrm8/kt1v9dDXPIWHwXDa2ImxBaPOGox+WUBMFSjrBRkCZPGoejbfE+dzATafIB+ZFF4xichqt6/ZXsfk9umH6sfqwGoKL06kyZHSxCTMzD0l8qfMoKRUQP3Rz3Jr/c3knCBXvTvecSRdmmA9TgvSRV0GOlYWWeaaEJS969EAfr7XDsCQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l1itDGGh3D9URsUOYM5JTw7egYWYZiyAHGAndM8TfDU=;
 b=ICsZHPnvcbmyc+H27mELCVLNRa6rQIuvJhW5DokID4dzDYmUPbERNe4vzTmmviHEEvlGNVJ+XlBx+cP6enpQrouBqY8suaHWlLn4UtQA0Hg5xoKQqfeFrJpKI69scZ1OW6Gc7iQR34YbeXUZLr7Mxr12VQPwU4Fu4Ra3BlNgQQHYlGKcvr+Zwpsc1ar6M/Wj1wRksTKUOQugBX/8ek7awP07zXa4yujTVKnIPtwNV6yyG2/c512Mm83d2vEogjf1+jmsmXKw1dB/5+RwXNJD56qyT/XxZq1BLhepjIUZ7K8qdEwyBavDR+mT0mXVdmJfiUEzICONkSWvvzo5XvcT1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l1itDGGh3D9URsUOYM5JTw7egYWYZiyAHGAndM8TfDU=;
 b=loTniuNLVAI225/fciP8r3GbUYf+h9GkZl7kPq1SB2ZY7rtlilYAFSSGWz04xaYYWDHHqsgkNze6wnjte66h+YIqA6F3aDlf7st70P2Rt9K3KtheMj6aIWcUEZ0APUfNNeWOXQ53E3yquZzWQatvkiNaF1vZQ+dAsnQFIfW3tmMBXxKvvAIWJ3KTm+0+0TBCQyXgc+BsBk2nSfN9lJd/K7M54UZ7fVLts1KwMq/oXp/X5Ty/Qkh8+1JclzphS54G4oYokUhbtBYCrPgGwBeTWXJJgYr8WjGsvXZvRiKGKJN7YhSKK9Bc+C+9xfhFl7tYV2vEnGs49dteEyg4QmUrwA==
Received: from CO2PR04CA0170.namprd04.prod.outlook.com (2603:10b6:104:4::24)
 by BY5PR12MB4131.namprd12.prod.outlook.com (2603:10b6:a03:212::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Thu, 27 Jan
 2022 12:14:26 +0000
Received: from CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:4:cafe::1a) by CO2PR04CA0170.outlook.office365.com
 (2603:10b6:104:4::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Thu, 27 Jan 2022 12:14:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT016.mail.protection.outlook.com (10.13.175.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Thu, 27 Jan 2022 12:14:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 27 Jan
 2022 12:14:24 +0000
Received: from [172.27.12.64] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 27 Jan 2022
 04:14:20 -0800
Message-ID: <e080838e-ea33-7340-716c-f61cd57c32fd@nvidia.com>
Date:   Thu, 27 Jan 2022 14:14:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH RFC net-next 3/5] bonding: add ip6_addr for bond_opt_value
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     <netdev@vger.kernel.org>, Jay Vosburgh <j.vosburgh@gmail.com>,
        "Veaceslav Falico" <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>
References: <20220126073521.1313870-1-liuhangbin@gmail.com>
 <20220126073521.1313870-4-liuhangbin@gmail.com>
 <bc3403db-4380-9d84-b507-babdeb929664@nvidia.com>
 <YfJDm4f2xURqz5v8@Laptop-X1>
 <7501da6a-1956-6fcf-d55e-5a06a15eb0e3@nvidia.com>
 <YfKLgL6qMDEQTS3Y@Laptop-X1>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <YfKLgL6qMDEQTS3Y@Laptop-X1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: drhqmail201.nvidia.com (10.126.190.180) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e35e301e-3f0e-4315-fda0-08d9e18e8f4d
X-MS-TrafficTypeDiagnostic: BY5PR12MB4131:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4131539C45D0DAE7BA3D4847DF219@BY5PR12MB4131.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ACj/Ck5M+NcndYl3PfuVu76Oe2zC9cTnR7nqpACXAAA8Rqc1Rn5k4+XWZzWNO7K1EWuTx9+SRiVOfYCcNzEbe2evPoMISfGR7i6Vim2SRo8OjtHLFAnkE7pHeniuDJ9V8+gFQAU3KQxk6nvuW+cMWlor4VQpku6MlhkMZbnuIurpATa33lSUYGzkYh4sdfODYau3OAHmVHJqutLDyrsGwLJyBRRwpYbdVsYrJlobVpSug3zppmMoT2U3i44gyg25g2BIo/4ufQ8u3Qeuc4sXPnNRftki6zWPSGDRZwRar/cwgDBmkpfr1w/CfPTj1eLl8n0E4V8eP/DGTme1BHn68n5rsuPhBISkILXmlv0SguNKnsDK7TvbOUKnVeFZq9K2PXx09kkBYtuUCGFGydvlwCcp1Q/RKWbyf+kEx6QmHbPRR2E0vjIZB0fjyYCdDzYts6zPLDUvQEdBSl80ipv90XDE3By/Gso2t9zxqTrD7dOn/WylyssJOvEgEWpP2VchZAMcHHscBxvDWogqH6BdnSry9dbupqY9MZmAjhMItyRVbi3wWyBH0pzxqwoS+efxxophov2z2zmBCekgHc5K/Y6cebRBF29ZPP24NlIuhbm2+62Zq9OQWt3H2RhsOZedwX3co+fpZFnlHGeKeuRyrW9L3ppiFVOh4Qnue1JmqBjH0P2lgexJq5XnFl86RzJ5w10essuCtqT112DmzLO2HaqTTqpx2AbTAIuGCLMasKprk1mD6rFpC/ndIabwKVJ8
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(82310400004)(2906002)(47076005)(5660300002)(16576012)(86362001)(16526019)(186003)(26005)(336012)(426003)(316002)(2616005)(6916009)(54906003)(31696002)(4326008)(36756003)(83380400001)(70586007)(70206006)(8676002)(8936002)(6666004)(31686004)(36860700001)(356005)(508600001)(53546011)(81166007)(40460700003)(43740500002)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 12:14:25.4400
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e35e301e-3f0e-4315-fda0-08d9e18e8f4d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4131
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/01/2022 14:09, Hangbin Liu wrote:
> On Thu, Jan 27, 2022 at 10:56:29AM +0200, Nikolay Aleksandrov wrote:
>> You're right in that we shouldn't overload value. My point was that bond_opt_val is supposed to be generic,
>> also it wouldn't work as expected for bond_opt_parse(). Perhaps a better solution would be to add a generic
>> extra storage field and length and initialize them with a helper that copies the needed bytes there. As for
> 
> Not sure if I understand your suggestion correctly. Do you mean add a field
> in bond_opt_value like:
> 
> #define	MAX_LEN	128
> 
> struct bond_opt_value {
>         char *string;
>         u64 value;
>         u32 flags;
>         char extra[MAX_LEN];
> };
> 
> And init it before using?
> 
> or define a char *extra and alloc/init the memory when using it?
> 
> Thanks
> Hangbin
> 

Yeah, something like that so you can pass around larger items in the extra storage, but please
keep it to the minimum e.g. 16 bytes for this case as we have many static bond_opt_values
and pass it around a lot.

>> value in that case you can just set it to 0, since all of this would be used internally the options which
>> support this new extra storage would expect it and should error out if it's missing (wrong/zero length).
>> Maybe something like:
>> static inline void __bond_opt_init(struct bond_opt_value *optval,
>> -				   char *string, u64 value)
>> +				   char *string, u64 value,
>> +				   void *extra, size_t extra_len)
>>
>> with sanity and length checks of course, and:
>> +#define bond_opt_initextra(optval, extra, len) __bond_opt_init(optval, NULL, 0, extra, len)
>>
>> It is similar to your solution, but it can be used by other options to store larger values and
>> it uses the value field as indicator that string shouldn't be parsed.
>>
>> There are other alternatives like using the bond_opt_val flags to denote what has been set instead
>> of using the current struct field checks, but they would cause much more changes that seems
>> unnecessary just for this case.
>>
>> Cheers,
>>  Nik
>>
>>
>>
>>

