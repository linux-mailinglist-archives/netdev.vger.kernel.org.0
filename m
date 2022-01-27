Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E1049DD13
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 09:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238050AbiA0I4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 03:56:40 -0500
Received: from mail-dm6nam10on2079.outbound.protection.outlook.com ([40.107.93.79]:61817
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238069AbiA0I4k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 03:56:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I9ccgg/hMKTyLHen3v60kTmSZR6C5jiymJ06u18xXv8/wAB4tFzX2JIVRG5q2KMFfAKmpA4K/+WMlV1NAq8rn/TPUTJdfwcZ6SR0E0sP/gdmL/8g1MzpiL0+GpIYklhmemT/cJljZLQIy8kZ3kXmzPm5VzESN8x5ucbcRwiw8EmrEvGjn7E2UK4DL0HPxRk+Put1KEBqccpIe0xHn2dUMRW5lHvQF+2arafT50bgISXIiZEmlFl8ViJ916pxittsV3C3Qwiu0FC+WQxOViCqoT0Wsy4ZXbtAvXfhLtGDnV9hd+QvaXtlEeQynlirjA2/72NWyR5hMF3Lf6Gra/rx8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R5UMr3qPcggBchPXvDAGdqGFV+l1AVvSuFJT6uDuj+k=;
 b=EzHeKugKZ5HTYDIvD+n1BYBQEr+zidM8G7Wu0klHlJP1NmE1UbPLJzDW49hnWsJUEHYFJtyqftN926nQ1NrWVsSEfpWMPgmXjdhudW6bt8Bn1LA4OHt0LmO4uofwmv9ja6iTshVP0IL/C8iBKD/n3qV/pxsvRuCn/qweqDSsxG9I7eOwXMGL0B5ycvkZrr2qAQOF1DYQNODGsn7V5i96U42wykjxKjQMO4CwGbnLcwoA0AbCE9BvVHiDtMfY1X6mvbb+dQXJS7fTquDSS30BLkh/KM3yWl9cgz4U33DMfII3l3uKS0QOMs9PoNS1AN2SQHmRZT5+1yCPHhDcyfM7zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5UMr3qPcggBchPXvDAGdqGFV+l1AVvSuFJT6uDuj+k=;
 b=TNInmqen+FtMUYi6n57WCC02x64kwGjydA8+43aMKpLhjvEqEhribEVDbFImi3lcK+n4HKK/BeX4dcUkbZfjM92OLD/AVF82pXJz65/Xn4r0bCH3CpIw4+ogpjbkLNX38THpyvIbZfkMn0OWmlw6IXzlxLpugHh9/mWSb/yxza54wqt6qK5+MH7+1ZORaqbGs0jFST9f7jXh6G8LuEMKm+ioSKKTXJ9ESjG4V6+Xk6j9aVFcywCF0DbBOOjx5J3Rrm191j71AZPtRYRKBeuffuloT6y5mgHevce5yWQZkkjVqAQGNg76GC45HHVGFknhPcyarclzGOfVI6fj17B2/Q==
Received: from BN0PR03CA0011.namprd03.prod.outlook.com (2603:10b6:408:e6::16)
 by CH2PR12MB4182.namprd12.prod.outlook.com (2603:10b6:610:ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 27 Jan
 2022 08:56:38 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::5a) by BN0PR03CA0011.outlook.office365.com
 (2603:10b6:408:e6::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Thu, 27 Jan 2022 08:56:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Thu, 27 Jan 2022 08:56:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 27 Jan
 2022 08:56:37 +0000
Received: from [172.27.12.64] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 27 Jan 2022
 00:56:32 -0800
Message-ID: <7501da6a-1956-6fcf-d55e-5a06a15eb0e3@nvidia.com>
Date:   Thu, 27 Jan 2022 10:56:29 +0200
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
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <YfJDm4f2xURqz5v8@Laptop-X1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: drhqmail203.nvidia.com (10.126.190.182) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2f3e786-954b-4c5f-569a-08d9e172eddb
X-MS-TrafficTypeDiagnostic: CH2PR12MB4182:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB41824998369B170EBAC44C69DF219@CH2PR12MB4182.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rNqOb7iZksBof7de8rsy7A3XztTzZ2p+/7LXqFyWAPk0m/yf2jsmOoF+ubmMJyDoKdgsG4M0femy/DZoiE20n/+byKP8RtpXjBZD6mOO+eKvfiDHP5rtF6Xdhz9TGrEA5i6nHp0bjrIuiXmuJFrPGmGVTlalBafrl+g6+q0WN5/6SE85HypJN9hP2tmNCErmx7b7Jz9fjalTD2Q03JDoPdPSQQTzBFqQBGmroFfZRS5ysEJKB+Aw8L7zrRQFWWfmeztx0ex8Tann2QYavUdr4olHYQ1h9FzrG9oUfKzt/AGMG5lXE9OLVbkcuvzrygFPCnmo0yr6ZNp+5KfWaDrqij7Grnu22w3Wy3hRaNZ4ZzLN4WZUH+B54EDLHLNKy7FXcMg6L82QxFCJRo1F6UHFEzfbI1XzqIorxpqjPYVyBe4fLBOL4OyukJyNR8q9LUBsM6n4ampANPLVaX4qjZ6eMQP6+yJMJalENl1b0Xb2ny6+vJcC5dMtmXkYbjXjQsHu8sHJBYTqcZhVq6Eab+kJX9G/l1lmRd9ORpv7RagIsGzuKJk71Hb0KjUCuTmGSkaTrz29ypPKJNXEmnp1Z3rn/LV8yw8fNr7Fu73GcYXdwakZ9FcCmy//nxv2bIonV0GmTc+7Pkj1+tiec/w17rYSpk7q8qvMejqQtfJd/y1n+0O1tETV2t1Pmyn0U0KheuhFigH1OG+eT6YjseWXGrIy466BmJfobDxk4Edv8OI/F9i+CJCVWoCSplEWrcNyd1Or
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(508600001)(86362001)(2906002)(36860700001)(54906003)(40460700003)(316002)(6916009)(356005)(5660300002)(16576012)(70206006)(70586007)(82310400004)(8936002)(81166007)(8676002)(4326008)(31696002)(83380400001)(36756003)(2616005)(426003)(336012)(31686004)(186003)(16526019)(26005)(47076005)(53546011)(6666004)(36900700001)(43740500002)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 08:56:38.1013
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2f3e786-954b-4c5f-569a-08d9e172eddb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4182
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/01/2022 09:02, Hangbin Liu wrote:
> On Wed, Jan 26, 2022 at 01:35:46PM +0200, Nikolay Aleksandrov wrote:
>>> diff --git a/include/net/bond_options.h b/include/net/bond_options.h
>>> index dd75c071f67e..a9e68e88ff73 100644
>>> --- a/include/net/bond_options.h
>>> +++ b/include/net/bond_options.h
>>> @@ -79,6 +79,7 @@ struct bond_opt_value {
>>>  	char *string;
>>>  	u64 value;
>>>  	u32 flags;
>>> +	struct in6_addr ip6_addr;
>>>  };
>>>  
>>>  struct bonding;
>>> @@ -118,17 +119,20 @@ const struct bond_opt_value *bond_opt_get_val(unsigned int option, u64 val);
>>>   * When value is ULLONG_MAX then string will be used.
>>>   */
>>>  static inline void __bond_opt_init(struct bond_opt_value *optval,
>>> -				   char *string, u64 value)
>>> +				   char *string, u64 value, struct in6_addr *addr)
>>>  {
>>>  	memset(optval, 0, sizeof(*optval));
>>>  	optval->value = ULLONG_MAX;
>>> -	if (value == ULLONG_MAX)
>>> +	if (string)
>>>  		optval->string = string;
>>> +	else if (addr)
>>> +		optval->ip6_addr = *addr;
>>>  	else
>>>  		optval->value = value;
>>>  }
>>> -#define bond_opt_initval(optval, value) __bond_opt_init(optval, NULL, value)
>>> -#define bond_opt_initstr(optval, str) __bond_opt_init(optval, str, ULLONG_MAX)
>>> +#define bond_opt_initval(optval, value) __bond_opt_init(optval, NULL, value, NULL)
>>> +#define bond_opt_initstr(optval, str) __bond_opt_init(optval, str, ULLONG_MAX, NULL)
>>> +#define bond_opt_initaddr(optval, addr) __bond_opt_init(optval, NULL, ULLONG_MAX, addr)
>>>  
>>>  void bond_option_arp_ip_targets_clear(struct bonding *bond);
>>>  
>>
>> Please don't add arbitrary fields to struct bond_opt_value. As the comment above it states:
>> /* This structure is used for storing option values and for passing option
>>  * values when changing an option. The logic when used as an arg is as follows:
>>  * - if string != NULL -> parse it, if the opt is RAW type then return it, else
>>  *   return the parse result
>>  * - if string == NULL -> parse value
>>  */
>>
>> You can use an anonymous union to extend value's size and use the extra room for storage
>> only, that should keep most of the current logic intact.
> 
> Hi Nikolay,
> 
> The current checking for string is (value == ULLONG_MAX). If we use
> a union for IPv6 address and value, what about the address like
> 
> ffff:ffff:ffff:ffff::/64?
> 
> Thanks
> Hangbin

You're right in that we shouldn't overload value. My point was that bond_opt_val is supposed to be generic,
also it wouldn't work as expected for bond_opt_parse(). Perhaps a better solution would be to add a generic
extra storage field and length and initialize them with a helper that copies the needed bytes there. As for
value in that case you can just set it to 0, since all of this would be used internally the options which
support this new extra storage would expect it and should error out if it's missing (wrong/zero length).
Maybe something like:
static inline void __bond_opt_init(struct bond_opt_value *optval,
-				   char *string, u64 value)
+				   char *string, u64 value,
+				   void *extra, size_t extra_len)

with sanity and length checks of course, and:
+#define bond_opt_initextra(optval, extra, len) __bond_opt_init(optval, NULL, 0, extra, len)

It is similar to your solution, but it can be used by other options to store larger values and
it uses the value field as indicator that string shouldn't be parsed.

There are other alternatives like using the bond_opt_val flags to denote what has been set instead
of using the current struct field checks, but they would cause much more changes that seems
unnecessary just for this case.

Cheers,
 Nik




