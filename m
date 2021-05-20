Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307D238A95B
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 13:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbhETLBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 07:01:14 -0400
Received: from mail-sn1anam02on2083.outbound.protection.outlook.com ([40.107.96.83]:29735
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239405AbhETK7R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 06:59:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MRxxBKAEf+sBc8JekGzAoOACWoKEF7sjRkm+Wb/33mjWyNN7J4+2tyoaTuNJ5H9H/Zarf6ulk88RPONDVsj8qWXfRs4bRhGQvM9V6Ujl4djumunmRV0BPkPzKOcoAJ4UJRNpYRKtrOfiwVVSRh8nUldESK5L+jCmNyDVQneg/GWi/1lsWwRdngqzEfFBFX+sfO5RonK+KfkvxMTuEog3pH58MJlPZ7KRzAQ5fXwLT6G9wLVSmnigrigmQKTa5DO2wo4bP7WdAcyFn+01Z+I3EgxsnK66pxLgaY5l3x2DX0mk4ugMHZF3/Dmp9PTL6YFk3+1AMPAp5roN0RY7pkXqrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WFPcRL2VTy5CTOsKWfkOEJoP9HrqMTuwvWpIzrmcqhY=;
 b=d/rjPcjNMZvtg6BXkUdQox5RZ1Wv623rdgF92P0XhAVxM9xDCM50H7iQ/vUVMczWiv1hiV+z5ETR+laDkDO0F4VM8Y+2fe7S4j+IGch6lj2Zw5+Ceb3swKdk3+BKxmvQFxr7xeJaVAWdrQyXQII5W/4hpHjVN3qIvjB0G84HO9KHkTOYRvGpKfbJcwc5XdjJ9oHEVGGQaixjg1RXBTNo9qygl+2W5lfAZZaxNOi+BUKhss+qsDNGUxy22XRlOF6O3/qJk2FO5fZ5ZdEX8t4nEraPsNChlOi7Eqj1+l4qkW7Ti/NsxuZVJllJcTHVkatcrvzIg47Ku7F8P2n2eCM6jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WFPcRL2VTy5CTOsKWfkOEJoP9HrqMTuwvWpIzrmcqhY=;
 b=KqNTWbnukqAy8lq0OyW762kW5UUQU+gyPOASevBvpOFl3gYg7AiLzQyC0z7okcGjon2Yk3FePzhtiVHm28OfGUjoRAlUAOq3XGmmjMdmTyp8o1Q2BTY6oirz4rRx/RqA4mDO/074x4BV8vddPCiuqAHtABTKROfSRzjnB7WSdInAvHuFaWXBTV8buj6JeROS8rqjhvJiIGTHyDpym9K6IcjOAoyCFSw8y22fi9qHGTpT1TY8yFWNdfCenrQQzwmnFr9mL538o0HYKWD22x2GK7iP452ft3I6qUS254m/FwxHCJmb/+fTJeOlggBlAgToxxZGtgO4+6+cBcmXWx5asA==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB2942.namprd12.prod.outlook.com (2603:10b6:208:108::27)
 by MN2PR12MB3088.namprd12.prod.outlook.com (2603:10b6:208:c4::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Thu, 20 May
 2021 10:57:50 +0000
Received: from MN2PR12MB2942.namprd12.prod.outlook.com
 ([fe80::c151:1117:48cf:f074]) by MN2PR12MB2942.namprd12.prod.outlook.com
 ([fe80::c151:1117:48cf:f074%7]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 10:57:50 +0000
Subject: Re: [PATCH iproute2-next 0/2] ] tc: Add missing ct_state flags
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com
References: <20210518155231.38359-1-lariel@nvidia.com>
 <CALnP8ZYUsuBRpMZzU=F0711RVZmwGRvLBEk09aM6MKDhAGrMFQ@mail.gmail.com>
From:   Ariel Levkovich <lariel@nvidia.com>
Message-ID: <32e2a0ac-1102-3fd1-6094-052bd58415fe@nvidia.com>
Date:   Thu, 20 May 2021 13:57:43 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
In-Reply-To: <CALnP8ZYUsuBRpMZzU=F0711RVZmwGRvLBEk09aM6MKDhAGrMFQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [193.47.165.251]
X-ClientProxiedBy: PR3P195CA0026.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:102:b6::31) To MN2PR12MB2942.namprd12.prod.outlook.com
 (2603:10b6:208:108::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.27.14.155] (193.47.165.251) by PR3P195CA0026.EURP195.PROD.OUTLOOK.COM (2603:10a6:102:b6::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Thu, 20 May 2021 10:57:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c122885f-6e7e-40dd-fd59-08d91b7e1c0a
X-MS-TrafficTypeDiagnostic: MN2PR12MB3088:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB308848EC9BD58BD3250A7C81B72A9@MN2PR12MB3088.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cvy5+nh8ckShZcG1llpmM7EOK/1GerM03KcT/Q3m3P23YGSBKyXHXzXmL8YS13knwiQQUtnfvSP7sXKsriCmYHEZfGblej9xTt3EPSjckJkcZfEOBs2IEMuF3f8sJMKVBdJeDbrIqeppbm1/QKcPjo4pX17VOvxG9+oUAsntWOOlBj8rU9CxKvzVdnFgLrqekNW/ZE+6uLjH5JY493cBlzL3uIburxj1TAyYNXXzSFvCRn4OJfOZ7otIeYF/D2N6GR4pIPf7o0UlE9X1Wy3QbmKwylsALNMk4QcuDD0jDD3jB6FOYsCVukQyn5J1g2qJDQ8OeDepptwDoobOiX102xHLf9LUmSeFckIKl8szRwtb6jX0KYRrKD+vJpF/xPOVBT0Exie3NR19hwWX81az4MNJ41s97WkxxW01oQq82n0qLZ9wWLYLOdn7oCg4V3/jkGdgNAvzY5/bCGs4UHr8PZRBYtmFiS8BFcbOg5g+JBQU2iHwgUBeGM5cHlP4ABP/tooR0X0NEIJimt6BTCaUTLQL02H5qNbJuDCRyA2kxinru2cD5xZel+so/6PllmwEEaPdNDv4S5u+qoAawzmpCGUOBByRziPtA9tLRqdnXW3EEvaTUHshkW8P7y42VC55b/rtBN5wz9vdBZWNQC1IBKmX6T9IbkzQzgGRUTX6OSVTgyeOQ04rfwHTWI1w0SX+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB2942.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(8676002)(8936002)(316002)(6666004)(36756003)(2616005)(31696002)(956004)(26005)(5660300002)(4326008)(86362001)(6486002)(186003)(6916009)(16576012)(38100700002)(2906002)(4744005)(66946007)(53546011)(478600001)(16526019)(66556008)(66476007)(107886003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VHh6Z3RMakltckE4bGd3WTVpNXFqMzVHaHFLR0pEMlhHeTJBd2VkWncwMHJu?=
 =?utf-8?B?T2VKcmR1a1N1Tk9WazllN3JOMHVPSFFCSk14cWlCbFZodUcrTG5veFM2dy90?=
 =?utf-8?B?cTZYT3pYcWd6QjRYK3VpcTBzcWt5NmxDZVFianNFbG5CYklVVzI2SEhZVi8w?=
 =?utf-8?B?OUMwMTVIMnpmTnFRc052TXBtc21XajM2ajZ0WHhoelBqakJnRXNiTi9EZlIz?=
 =?utf-8?B?SnZEN3dMcjFSL1B5TS9Kc0g1MDJBU0R5dUdJMTFwNGhvOVdudzRsQkcrQW03?=
 =?utf-8?B?V2U1NEYwdFBtaWVMQndZdjBheUtRYkFXZW5DUlR6OGlqd3hYbFJwc1RiUEFp?=
 =?utf-8?B?SzdiRWFzZG1pSlNKQXdnMWNlVkt1Y2h4dzF1VXRDNi9PMndsYm81alBycnBK?=
 =?utf-8?B?ODBpR3hQNmNyQkdDa2tmcWlBMFZ2Ti9rbWtuSzRzQ1ZJUnkwaGxzRGptMTcz?=
 =?utf-8?B?ZVl1b0t5MitFallpN0hsTlNtREdnUjVDOXBOYkhvUmtrQkNTM09VRVhzSUNJ?=
 =?utf-8?B?YVFmbTBGYzltdjBLLzJaZlZmR2gxT285dWx0T1NxYzU4K2pqdnlZQmFYZFY4?=
 =?utf-8?B?T1RnU0pjWjZEeWJveGVyMmdJUkt3WmVFOVczOVlFeHhiOHFSVEYwUTJ5Rmw0?=
 =?utf-8?B?UURmSHdWMFVVOHY0OCs3NjhDbHFrNmY3dVdvVFQxZElXYVhZU1JRU1A5MGhX?=
 =?utf-8?B?WEpIcHF0Nm45eW82NWZpSmRqbE1aTU1NVGFSTmJDc21zdXR4NmpxZTJkL0dX?=
 =?utf-8?B?SWxuZ1ArLzBwS3FncHNFRW4rOWkrSlRzN1hLTnNrTytZT3Y4VG1TMnE0RkZj?=
 =?utf-8?B?WHZFRDVsYkxXMG5sbml0VUVJbDZNTnZKMkFZYzFvS21INXAwWVlxTVpmeTZF?=
 =?utf-8?B?V1pvRDBqbmJDOXdtTEFIWFpTZHJjU1czbkxuMlJDVlhTZE9oeUNhYU4yMlN2?=
 =?utf-8?B?UTlEbktnaDN4dDJvNVdtdzRFRnVPZHVVYmdPNGtucGhGYnRTbjJyV3FJejgy?=
 =?utf-8?B?bFJNRzEveEE1M2w2WFpuV04xdjg4dHY3UnU5NnBQdUgvV1YzQWRkT0d4Mk9W?=
 =?utf-8?B?VUpFd0xhWlRBa0dkNUswaHJNR3FMeEowcW5VNkRnZ1JvRlhUaEI3bWxJTGh1?=
 =?utf-8?B?bzF5dFpQMTVWci9GK2RXTW9JUjAxSXp3b2xpTGxkUjRPWklsSW1vbkViNk53?=
 =?utf-8?B?dktmQ3NncmwydEVWalVUd1c3cEN1VWFSR3RZeVdMUSt1SlJHUlhNTlBVNStI?=
 =?utf-8?B?UnlHNWZmV2duR3F2aUcyMm1DUkxlNmJRUFlRLzF3Nit2OEc1QURQaU1hUTVN?=
 =?utf-8?B?TnpBNEZxQzhqZVRHdjIzUG5QdkFnRFZUUXNlK3JKbDNOSjIyUzhrVVd6SGtU?=
 =?utf-8?B?cnJZdmtNc1dqUm4yTmJPWDNkWVI1cEpXdDJaSTNuSERKL3lCM2dqeUw5RDhu?=
 =?utf-8?B?TTVEaHZONURnNzh4cHMxTnVtVEp6ajlrT0J5WlhBZVF2OTlsZ3lwcEdwSEda?=
 =?utf-8?B?WnhyZWJmV2NSNmZieFZwTmxDL21vOGczQk1RTVQ1Wkowc3ZXRndxQVVDMlpQ?=
 =?utf-8?B?VVYxc3R0TnJnWkE2b2xNQnNrR2pIcDF5SWt1YmdGMVppczBpcTNsVWhKTXBm?=
 =?utf-8?B?WHUwRlI5ODd2QmkyLzZSSThzamdwbGhkREw2NlRaM1dwdFEvanV1aEVCdGFs?=
 =?utf-8?B?b1UydDRSS2hkbVpZNWJWZXdGcVFuZS80bFRDRjMwbU5lZlJVd0gxSEZWcDVY?=
 =?utf-8?Q?q4z4JB1KJYTdPHFEUkiZbYSObQtXY6SUifjbwyU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c122885f-6e7e-40dd-fd59-08d91b7e1c0a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB2942.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 10:57:50.1476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z9VhpRpZdhIrMlaM8jU/d+4TABONQL6j9MG/wd5FhQ/l97Qc9hZ2Y7Lqw7BvGNFS6hrWWIofvjhVDi7in2gSSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/20/21 4:15 AM, Marcelo Ricardo Leitner wrote:
> On Tue, May 18, 2021 at 06:52:29PM +0300, Ariel Levkovich wrote:
>> This short series is:
>>
> Is it me or this series didn't get to netdev@?
> I can't find it in patchwork nor lore archives.
>
Neither do I. Not sure what happened.

Should I just send it again?

