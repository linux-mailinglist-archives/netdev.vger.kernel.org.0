Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF5E3420B6
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhCSPR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:17:58 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47952 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhCSPRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 11:17:50 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12JFA6KK029837;
        Fri, 19 Mar 2021 08:17:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ROheUioOFT16D2nTSHxrKwvfB//jfsBI4CJlfnAQ1lI=;
 b=ns1Tq+0rXF7/0ZqAhhuqx621BquK1vdqS1Ngl1CaVBoUI2+KyGqLpXwMSUOGdcNaiVrc
 8VrnNpbkk+4poCwar6Ea15WnmNlc4akg6oIOCp8RtKw3EIXv6aBZIW+WluuBkB4iEQhL
 eVac9E44W3WWZLamETcykwU0WEgDrdWXIAQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37bs1wb5pw-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 19 Mar 2021 08:17:26 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 19 Mar 2021 08:17:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HWVDvCF5cq53hvE4vWNerRLHOfnyE5rdpIbjEkvXkEQ/UJpwMQPpVcDtypIZNcRkVr2NMjYopDwhm+qsbe1YgN4UCgI+fvMV4LVMkJlb2R2BaB7VQMClshMB+Myy8/2hpTSlA5nRl1mzYM4ZO9Nx1UDunVilL0CMI5MzX/XoA8PIExT2kU0Ygl+kLjPWpF+1VWhle2N1/ggu5dldIe4nycpZuzmr4wWEhICVBcpNNgRJqJxLupHFrssOQwvXbvOheufw2AAtMd4jWil1ov4+42o8RAtcen2zbSuucoIYO8TOwMtOtqdp4ZrAI4lAfF3g3JqKXRt+px2WFVsLpRrobQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ROheUioOFT16D2nTSHxrKwvfB//jfsBI4CJlfnAQ1lI=;
 b=C8pytvJ/Y56buIKrxVQI/wAtXsnqN/rVUTt6lHjAFSqCXyphIfvWZcO18QD+50A6RyQEVFhrD4eJTaSft9vLBqzQ/rmeMslUBaL/7sPpYK47fuUxXJQ+cficSJqdvnWrMHseivu5UIU4FoqqTBt5p2LWSru4Gm31I6HNjLYHSUuxsXpu/EOeXq4gIffIu7xCy3oJhsERV5hzzkT1C2vLzD43b9Upn/gW39M78ryy/oUrv8bbom1AKeNX9PeqQphIFWzceCtRTxw1wNmvaiO+TT8qeiiUA3EgEO9/Dq4SnMx1pcN1wNJnB6KSTgO4DGgs3m6IXaKNZxbRezs1Mmwrxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: canb.auug.org.au; dkim=none (message not signed)
 header.d=none;canb.auug.org.au; dmarc=none action=none header.from=fb.com;
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com (2603:10b6:4:a1::13)
 by DM5PR15MB1404.namprd15.prod.outlook.com (2603:10b6:3:d3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Fri, 19 Mar
 2021 15:17:21 +0000
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::4877:32f3:c845:d6d3]) by DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::4877:32f3:c845:d6d3%3]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 15:17:20 +0000
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Piotr Krysiuk <piotras@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <20210319111652.474c0939@canb.auug.org.au>
 <CAFzhf4pCdJStzBcveahKYQFHJCKenuT+VZAP+8PWSEQcooKLgQ@mail.gmail.com>
 <4f90ff09-966c-4d86-a3bc-9b52107b6d8a@iogearbox.net>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <70b99c99-ed58-3b05-92c9-3eaa1e18d722@fb.com>
Date:   Fri, 19 Mar 2021 08:17:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
In-Reply-To: <4f90ff09-966c-4d86-a3bc-9b52107b6d8a@iogearbox.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:301a]
X-ClientProxiedBy: SJ0PR13CA0012.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::17) To DM5PR1501MB2055.namprd15.prod.outlook.com
 (2603:10b6:4:a1::13)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::193b] (2620:10d:c090:400::5:301a) by SJ0PR13CA0012.namprd13.prod.outlook.com (2603:10b6:a03:2c0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Fri, 19 Mar 2021 15:17:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4dd18af8-1439-4250-3098-08d8eaea16e0
X-MS-TrafficTypeDiagnostic: DM5PR15MB1404:
X-Microsoft-Antispam-PRVS: <DM5PR15MB1404E7BF1AFC1B2B5F9522ECD3689@DM5PR15MB1404.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oy/hihg2/2eWPfddSkdX128afdxQU/lSV/WJyqAgYUHjErte67t6DbLSwgK87V5VAN352S/LwDE+OkxEyX9l20JtRhHIFlr0zkttge4FcuTAMOYo39x9r4SsiVOCNQHuY1GIzTLdJUdaN+17d0M8KkfSezojEVCYOE0pIB++cxPIv4Gy7ucbfLu154bm1uwTwIkU1WsKA18wu9ZQpZABPQsN17QL3PFceKS2BDZrCoT/1SfeFgz/onByPDeghmK0V+z45b52TSCQkG9DSBReJQyqQ/NTbydSH/zKELohTkeCPFDLJzKVRi+BKK3wRYjrzhLL9jCv1522Av/NMYFs40d+uWc2SbAfXa1ka5711rN9AGfCCjmEWZrzeHKCAFxy975EuZsZhnZEPN1fPHJbFDwAskMDJWW2JPAqtRYYsZFSyav3JRqkfvVD7w70khEHZS4rqU1RMeqMm8ZT2HAX0dzYQgi9YEDGJlK3UVXiztwH744K57soETmnlUA64pvvQSzRvxYPCwX+0MEXd/GySOaUFrjjCwKTSQCy7t753BWBtaUxFgpmMAK6NV8gXm3PnvEvs8aIB+GIo/7XI6xmCDLVZiiU0d/YFkJlKxWXwjiD0rNs4yGlaXkSrFYaa4v41t1f0uvmsQq0vkaj/B3yjdx6EywTxeevEylMVunQ+gMo7fU7qHBdZppZWwhsE6aYNC9y0IEBjskYckDWpaTUsg2U4VIKrdYo8hKpxbs8vpWBMDf8XftKaY0sb4Rvzh4Wr3ncpC5qM6pfSzXcw6QRylXe0BDxyUWmVQEFoL/ZPFo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1501MB2055.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(39860400002)(136003)(346002)(66476007)(66946007)(966005)(16526019)(66556008)(86362001)(6486002)(8936002)(53546011)(2906002)(8676002)(186003)(52116002)(478600001)(2616005)(54906003)(31696002)(110136005)(4326008)(5660300002)(83380400001)(31686004)(36756003)(316002)(38100700001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MEFPc3ROdE15eTdUT0V0RWRpN0pkQVpMSVk3S3RFUXJlWm45Nks0aFlKbVVx?=
 =?utf-8?B?Z0xJU2xLZHlGK0hYcVlNclZmblNsa2pjaEhOdFh1Y3hZZFV4SERPRjIrc3dW?=
 =?utf-8?B?dklpN25tL1MvMElXdG1BeFllNW4vY2hFWHdGSXVHZ21PNWRSaXMyQk9mV0Q0?=
 =?utf-8?B?TXBhY2prWnhwNCtHNTZZcEVDRVl5Y010c1lpNFl0ckY3V1M1emY1TFF6SE5l?=
 =?utf-8?B?aHZwYTFUTzUzSFBvK3JsdjA0QnVZS3JMMk43RWxienI2MVlKVlFaYkhFSGR0?=
 =?utf-8?B?b0h2T2N1SGZEQzRScFUyZ3R2Q1NLcUJRWWxIbTh0UGdiYS9aZmZ5U0dJODRz?=
 =?utf-8?B?UmZORE5sRDdKQm5EdGZNQVI3WXphSzJxbFFPbUxuSWV1Vy9kb2FLbEpzby9q?=
 =?utf-8?B?L2p6b05OdGN2UjZRR0phL05DMG1ubzJ6U2Z4SmtXOXRSTG1nZ2NtSXdrb0pO?=
 =?utf-8?B?cUNTSksydlI0VlY4dUdadCtSbFpzMEJJaG4xN2krU0lvZWRDbE5ZMHBoQ3Qv?=
 =?utf-8?B?M3BOa0dteFdEY29BNmhBU0VYNHNBR25jSEltYVZJZmd4c1lLTHpsTDBxQmhP?=
 =?utf-8?B?MStHaDlaTTh2YTJTcWdjRWNEcmhyTkNDcWgrZEVldXM3SVhaWkJNUFA5ZXNm?=
 =?utf-8?B?Y0lFUEtXOGRyUCt1ZXZHRVBaK3FCSE43c3RicGdrYXlzZ0NIWHNtMW9UdXFH?=
 =?utf-8?B?LzZTbGJhYStvYXo2YnVpQisxSjBvTUs0Vy9VSVR0UnNZc1NTL0tyai8vcDN2?=
 =?utf-8?B?QXJXaTk0SHhYbkN5Sm9DWkZubTkvZk52bXk4aVVNdWRUMjh4eEZXcXMySnVl?=
 =?utf-8?B?Nll1VFFwdHVHQ2VXa1NJK0pOSUdiRE5YYXZ3NGt6ZmRSQkExYWkzUXYzL3Ra?=
 =?utf-8?B?MFErUDk2NzBKYzlaR2xkaktBbDRabEkvVHAzeVNWVC9qdHJFYm9HekpOVHRC?=
 =?utf-8?B?Q3BnWjVBampNdWF0Y2p6OEpLVU9ZU3lNWXBQcjh6Nyt6cUFkNlFSMndwajJm?=
 =?utf-8?B?OE9SeVlJNit6WmlQWUFWQU11Y1VZWVQ1bWJOdGFJZkpqWVpERE5lbnRPeUlk?=
 =?utf-8?B?NG1yL05SZVA3YkY1WHJpd1o5bUVWYXVIYWxVV3N1cjdvN3hoTU04NmdQZ0FE?=
 =?utf-8?B?RnB1YldBSEg0czczdFFhL0dtNDNqaHBoNHpQaG9LRE1kTTF2a1hGUUE0dHFn?=
 =?utf-8?B?bnlwVUJVY0FSTVdLZGx5eDdkZUtheWNJb1psZkczbVZzWUtoNTVoNUptVGJh?=
 =?utf-8?B?bTJyVFloeTJhdEE1T1piS0t5NVBsdVhZMjdUK2lkcmNuVVJzMFRoZWpzSmND?=
 =?utf-8?B?M0VUUmorUDNMQytrWmtiR2sxQ0dOODdhTEZEb0Zxc0w2ek1XZjNoWHZySFNO?=
 =?utf-8?B?Q095U0hOQ0JncGx1RnBDNy9TcHNTL2x1NjZkK1VMdEdNbTdLWUdocEh2ZGxV?=
 =?utf-8?B?RnpQckhuRlV1QVBtWE5RMlBxZ0FFNEQ3KzFWcmU0akZTSXRRYUdEZmp0TU01?=
 =?utf-8?B?UUpwZXNZL3k3TDNNM0lIY3c4YjJXM0M0Ny9vdTZVUUwvYnl5YVZOWXd5YlJz?=
 =?utf-8?B?dGhEY3dLRnE5MG9FS3hEeW9nRUcyOENreTc1VnovRzMwcnlnODBjWWNjckRh?=
 =?utf-8?B?dGFSRUloRmdUdjJCWmxTRExxU0gva29uYmp1UU5SaVk4TEYxOS9KZnkzaWNI?=
 =?utf-8?B?YllIRElnMWM2aTFJdEZmeWcvWXR6bWhZcjNwaU9wdkgzWWwrRXA1eHNwcVhw?=
 =?utf-8?B?ejNINTlzcXYrSUhiRVAyTEZzcFE2NDdISUJZdzJTZkhxSkRYa0c5aG1HbEg2?=
 =?utf-8?B?N0xwQ2RSVHFjYVY2dEx2QT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dd18af8-1439-4250-3098-08d8eaea16e0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1501MB2055.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 15:17:20.8488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pJ1vPlpWcip8XjYY42uRQQWHR7qO9ZPNdCyNhyGW4rzlXlHkCsZSODvtLUHavUJj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1404
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_06:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 priorityscore=1501 adultscore=0 clxscore=1011
 malwarescore=0 impostorscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190108
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/19/21 12:21 AM, Daniel Borkmann wrote:
> On 3/19/21 3:11 AM, Piotr Krysiuk wrote:
>> Hi Daniel,
>>
>> On Fri, Mar 19, 2021 at 12:16 AM Stephen Rothwell <sfr@canb.auug.org.au>
>> wrote:
>>
>>> diff --cc kernel/bpf/verifier.c
>>> index 44e4ec1640f1,f9096b049cd6..000000000000
>>> --- a/kernel/bpf/verifier.c
>>> +++ b/kernel/bpf/verifier.c
>>> @@@ -5876,10 -6056,22 +6060,23 @@@ static int 
>>> retrieve_ptr_limit(const str
>>>                  if (mask_to_left)
>>>                          *ptr_limit = MAX_BPF_STACK + off;
>>>                  else
>>>   -                      *ptr_limit = -off;
>>>   -              return 0;
>>>   +                      *ptr_limit = -off - 1;
>>>   +              return *ptr_limit >= max ? -ERANGE : 0;
>>> +       case PTR_TO_MAP_KEY:
>>> +               /* Currently, this code is not exercised as the only use
>>> +                * is bpf_for_each_map_elem() helper which requires
>>> +                * bpf_capble. The code has been tested manually for
>>> +                * future use.
>>> +                */
>>> +               if (mask_to_left) {
>>> +                       *ptr_limit = ptr_reg->umax_value + ptr_reg->off;
>>> +               } else {
>>> +                       off = ptr_reg->smin_value + ptr_reg->off;
>>> +                       *ptr_limit = ptr_reg->map_ptr->key_size - off;
>>> +               }
>>> +               return 0;
>>>
>>
>> PTR_TO_MAP_VALUE logic above looks like copy-paste of old 
>> PTR_TO_MAP_VALUE
>> code from before "bpf: Fix off-by-one for area size in creating mask to
>> left" and is apparently affected by the same off-by-one, except this time
>> on "key_size" area and not "value_size".
>>
>> This needs to be fixed in the same way as we did with PTR_TO_MAP_VALUE.
>> What is the best way to proceed?
> 
> Hm, not sure why PTR_TO_MAP_KEY was added by 69c087ba6225 in the first 
> place, I
> presume noone expects this to be used from unprivileged as the comment 
> says.
> Resolution should be to remove the PTR_TO_MAP_KEY case entirely from 
> that switch
> until we have an actual user.

Alexei suggested so that we don't forget it in the future if
bpf_capable() requirement is removed.
    https://lore.kernel.org/bpf/c837ae55-2487-2f39-47f6-a18781dc6fcc@fb.com/

I am okay with either way, fix it or remove it.

> 
> Thanks,
> Daniel
