Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56263A0C5F
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 08:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbhFIG01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 02:26:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28950 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229724AbhFIG00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 02:26:26 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15968M2Z004354;
        Tue, 8 Jun 2021 23:24:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=KuvGCYlA9SuITty0DJR7Usj9C3ztwkKag9fC4BFzvnQ=;
 b=XaKK/AFSwGBCzLmdcasdOQ7w2TUvemheRTNDNv4XdKKsyTsWd1MPHuK+u16WlMxgAI54
 LRADdJ1nrD2FoWkhHBn4FKY2GXLKnRMLoLiRolJb6xnw2n4E1nyOX2Yt0EMqSHvzwUKe
 /DGcMh4NhgQxTChzeJCDExxJ4wSEYGJZbfM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 391mx0uy34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 08 Jun 2021 23:24:17 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 23:24:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W3RZNYRdegmWPufDWy03aSEIdwrMyywmjXxVa0GbLIl5Jo0sFmUcwSAuDXYj6hgiAFl4g8XIgQ5TJjFKEvCq8NT9zqudSpr/NvCshzNw4QC63MCpN/1DZ29twu6tBqB3dusWc7zulYl90d46LQnsNUn+VfTeG0yZdTjZl0e5smG2az2N/BBUjCSWp4QWcNYw8dWd/ReK1UgE85fyPPdXAaq3QQqLpCjCxmxKjY6hc+6D9UZ2Y1Y97fnTijEX4FnkFV8cU/O9uWvqIbt/1RMG2EuM1CQc8YkEz5gP3SL6FqLROAhAr5YHaBpyxACdoGIp7YP9CNXPvXyjtcFilItRXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KuvGCYlA9SuITty0DJR7Usj9C3ztwkKag9fC4BFzvnQ=;
 b=aSI2eIJ59xhBsnKorR3Enmg/uARgtsRuQGhCMFzbB60E0Ts1HS4nX4jq09ed6OdeyJlLjsmQ0kDYULW4Ui+2bCO262ucuFq/ojbhj7zv54nVvNykC8ptJv5e7KYwQ1KFxd7R2Po/IUPiTjfilgjckuaQ10HIxV9M9l1+cjZT14/lwRHko6/92wGFNzlv9oFr8FFTuZ4w4XTBQdgN1aPvfji5IDSYGQQFHHLQjCnl0bXF6l46WRZ9CTUGwlgTBceKzBxXBPYHxsa92+d6MIJE4csHGXufrJd/sfxjkwwTZc/hQDXbb0hp7fApFsee+EGrGwqlkJHa1ZCxpykt/4rZZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3968.namprd15.prod.outlook.com (2603:10b6:806:8d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 9 Jun
 2021 06:24:15 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 06:24:14 +0000
Subject: Re: [PATCH bpf 0/2] bpf fix for mixed tail calls and subprograms
To:     John Fastabend <john.fastabend@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andriin@fb.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <maciej.fijalkowski@intel.com>
References: <162318053542.323820.3719766457956848570.stgit@john-XPS-13-9370>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <588e062e-f1aa-6bc5-8011-380be7bf1176@fb.com>
Date:   Tue, 8 Jun 2021 23:24:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <162318053542.323820.3719766457956848570.stgit@john-XPS-13-9370>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bb78]
X-ClientProxiedBy: MW4PR04CA0109.namprd04.prod.outlook.com
 (2603:10b6:303:83::24) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::11dd] (2620:10d:c090:400::5:bb78) by MW4PR04CA0109.namprd04.prod.outlook.com (2603:10b6:303:83::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 9 Jun 2021 06:24:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcb74db4-fb76-4bde-32fc-08d92b0f341a
X-MS-TrafficTypeDiagnostic: SA0PR15MB3968:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB39684B4FDD6B12C93E29FEF1D3369@SA0PR15MB3968.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VYsdjhlxEQ7rOpNwfFL2g4XdVTe6zsD9ZATn3gI81RhrROTFxxz2T9muZWDAMrqi/0ZqsAmRCGhSKpQbOUzdJnqbajhtzf9hslT1iZ6WdmYALbMFVq2vQavAtqi05zmN5INwCA1bocSRNaqa2Z9LLV1kLZEjnf+SCAVM+L2f/wZpweWHcUkquLq+zozWKRxm9FB5l4UcfrnEJdj1La87hLIVA5vsLE0hRbcoePe+OT9GQB3GGfRBcFzG4mEdMv6H9Td+psKikgTJd1spvw2XgULLoJqq0rpm7BOOqSv496YwBjRxXNq0Vih98iiPa9z2mHuMqt0S3PMwhzi2cnY5GLTP+tqYDJWMDYCyfaAd5rhZuIKhq4drWIzH31cvvpjMeiv4f1E18jDMR2xWKHIq4ortN8NPv/qT3Hdt8w+kJNUh5IAslyUF1VYX6+FN/QN5jvjE4lNZbgmlaRpBxCInDTcxWuMlfq6iXsWs2oGt+SBWB8ykYUpyUJlTSFhmb2Af1Gk2zUDXt6THe45orNVXKY5zdbYjCXvKj5063ZizblIN6LrqqBzK99qN3D0q8UrKK85VhF5lwfEUHeWDtNXYbu8W1j9EZcs2P+mfZWJNGTz/FZfznsMi5miGtIO0A2IaSGqQNzh+y1OoF2G/7tKerVXI8/OgxSrkNOn/ysL7kl5J+eBQXznC/WfbEL2PKCFd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(366004)(39860400002)(346002)(8936002)(38100700002)(53546011)(6486002)(6636002)(52116002)(2906002)(5660300002)(66476007)(66946007)(36756003)(66556008)(186003)(16526019)(478600001)(86362001)(83380400001)(31686004)(4744005)(4326008)(6666004)(31696002)(2616005)(8676002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXFNTlNxWHVKVkZHOW1TVUJFOVlGMWxndmttc3M0N2lPWi95aEtFRHJ6azZQ?=
 =?utf-8?B?M3pRMnhkM3d0ZEcyRnl4bFBic2k0Sk4yaWRuVENUcUh3UDdaSGxTVTFScGNs?=
 =?utf-8?B?emJIWFI1WkdqMG9zRk54em8xbnVjMXRLYjA0YjJDOU5IUWFKWVk0Z0l3eDR4?=
 =?utf-8?B?eHl6MGs3S1FqMU0xZXM3Z3B2ODV6aW9iQWtyS3BtTlBRUDJDTlZ2Vk9odHA0?=
 =?utf-8?B?REVWUTVFd1c2Q3RZV0FnaEIvL3BnSDdES0dRa3FXVjluTVhJZEQ4OC9ESFc4?=
 =?utf-8?B?a09XcVBrclpBSUFqbk93NGFyY2thVlNUaTRNUmh3UVYrLysvdlh2d0I0alFl?=
 =?utf-8?B?UmIrUmhBL09XTVFaQkdVck11V1FLQytGK3lmMmhELzlKK0dZc3cwTnV6QVJ1?=
 =?utf-8?B?MDJzNGdOdW95OXJ2WldKZEJZSm9MVXdDb0FIWkcwL3ZhcURsSnZGbW9oZE1L?=
 =?utf-8?B?WWJHeWI3WXJlRjhMaG5DSDZ1Z01tMnpzcHhxWkNUb3BhT0JrSHBIc0FOWmNq?=
 =?utf-8?B?QldyMzZzMmx5Q0l0ZlRqbnQ0clB5UGJRU2dmZVpBR2Izd0xxYmRITXJPa1ZI?=
 =?utf-8?B?d0EzelpNd0JENWU1VFRlYVNCUmxEQnZHU3Fad0F6RGtNbXVGYlFRN1ZFVXJX?=
 =?utf-8?B?ODh3WWkwRlMrSWw2ZTBVL25FRU9ZRlhMaDdqb0NXSzBVNXJkR2xXSk5mNWEr?=
 =?utf-8?B?RG1aNFo4VjJLTkVaUmNGQ1pCcGdkellTNGVNSWNnQTZqL1A1UGhTNlppclV3?=
 =?utf-8?B?WTNEUWEzTm9QSUZHcVlpYitQTFZmN3JKbVcyc2FJMG90alVVSEJMUUJZTGEz?=
 =?utf-8?B?RUUranFsbWdPRTVFUUEwVU9oMHcrWHVvbUs5Z1pXOGRaSGkvRzhUbTkxTWRk?=
 =?utf-8?B?SDRIT3lUdjZvS1A5QUVLQkdkdXNKSVZJWmJCUzI3bnNjaTNZazVzK1ZyZDUr?=
 =?utf-8?B?ZEczVC9CbmlkVndOQm11MW93eUl2Q3hQa0k4WlAxdU1hUVQvVWVLWGp5MFV0?=
 =?utf-8?B?dVVXNlNNcnAwZXVrRTdVNWZyT1l1L1dOQWRCUS9uWlBGQkZscWhKR3loQlo0?=
 =?utf-8?B?b2YzUTlyd1hzS1dhU3VTazVENkVlQlF2YnBmMEtpclR6QUxuWndzNFY1ejJm?=
 =?utf-8?B?MUNULzZsWnI0TTZXMVM2UU9aTVAxMEZkazBGOXh2WkI4MDB5c3plVCsyYVBQ?=
 =?utf-8?B?YVhHYnZoWVBCMHp1b3N2Z2kydnlITUpPV1cxc1QzUW0yU2ZCNkV5dEVIQ2Uy?=
 =?utf-8?B?N1hsZlArS3FyUW1xUlpWU2lpYWx0Z2hXcFQ4VVlRL0NsTHg3Y0NGcjN3YkhS?=
 =?utf-8?B?RHFLcnEwQlJZNzdER1liRGpSTFlNbmpyMGpWMnp3WW9DRS9DSGpRbm44VEpq?=
 =?utf-8?B?d0NKZkplZ2MxZ2JLd1RHYkZ3NTBMUjNkYi9PWWZOV1AvbWVJbnZaVVlSRDJO?=
 =?utf-8?B?M0xMalBjbGN5dHdIZTIwTStQRjJYK1dRTExOUUxqU1F3eVBoLytlRjExeWhB?=
 =?utf-8?B?TGd3RWd3a0p6dllsbTdiUFZ6NDlqNHpXZktVUHJIU1Bmb0d2VndpbkNtWnFz?=
 =?utf-8?B?cUJXdnVmeVc1dGQ5VytKQ1VjVkJpUW5sSGxYNXdkbDNBTXZQTkFMS2tISTNB?=
 =?utf-8?B?YW5RSzI1TnFRVXZaQlIxajlEV1V4V1FsRCtwQ0lSakhKVk1ZYmJuMG9SQzlI?=
 =?utf-8?B?aXlQMmRQQXBHV1BYejZoQTNjZVlUa0tVWHdnZzdkSGRadExMQWE2bGlmTjdU?=
 =?utf-8?B?LzJZUmdRM3ZhaEl3L3VscmQ4U2ZDZDBwcTl4ZHNQWEJIcVJSMlF3NnhmeU5J?=
 =?utf-8?Q?68MD3ShlK83lEyARhlQMjY6Wog4p9ss1W9i3s=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bcb74db4-fb76-4bde-32fc-08d92b0f341a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 06:24:14.9361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bZG9Zb/5Nw2ungoqHLyhIjevqMizdWOHIjmfhtswWp3vmWgRI3dDPi8UayKK05J1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3968
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: h2SeUGZvJYRfsNswE0H0dwsr3GpCEamK
X-Proofpoint-ORIG-GUID: h2SeUGZvJYRfsNswE0H0dwsr3GpCEamK
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-09_04:2021-06-04,2021-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 spamscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106090021
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/8/21 12:29 PM, John Fastabend wrote:
> We recently tried to use mixed programs that have both tail calls and
> subprograms, but it needs the attached fix. Also added a small test
> addition that will cause the failure without the fix.
> 
> Thanks,
> John
> 
> ---
> 
> John Fastabend (2):
>        bpf: Fix null ptr deref with mixed tail calls and subprogs
>        bpf: selftest to verify mixing bpf2bpf calls and tailcalls with insn patch
> 
> 
>   .../selftests/bpf/progs/tailcall_bpf2bpf4.c     | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)

Don't know what happens. Apparently, the first patch made changes
in kernel/bpf/verifier.c, but it didn't show up in the above.

> 
> --
> 
