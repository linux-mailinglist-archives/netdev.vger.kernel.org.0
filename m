Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B396447504A
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 02:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238786AbhLOBF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 20:05:56 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:41444 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233232AbhLOBFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 20:05:44 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BEMSvpi007071;
        Wed, 15 Dec 2021 01:05:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=gUwHy0mAcOXiZBnYx3uISsvzbt/itf1sm7uaBTsSJb4=;
 b=ZSgX34pQLvXFK45WHgrKwCg9KGDcBELTHLi819BwsBk+mXO5uotSw91/eI8aExvzoVi8
 qdJSq9mC/o2ee1mnvIqRbu0W+AbfWRrKHErC6xjTa5esIVueCrp0hyufGQ0YbpyjEogo
 KWb8LUJCp8xyY7jQ1dqv6fWX8gVuKmIz216stAgEiosgrPLZ6ZlRG1/Ui8nJLzX23m0W
 nwXNFpbjHuhgCoCVtCE+EA9z44M62e8zvJkZB+CU4NNhtHXyVVl8OmZ7Wgp9O7bg0Cc1
 pE+Ix8OpBvF3kOGFDdmGhn3jPzw4vEEB1HNAdigbXhUb9HzuZWxf303M9ObEg4yH7Dol Xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx2nfdfy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 01:05:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BF122FZ109679;
        Wed, 15 Dec 2021 01:05:38 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3030.oracle.com with ESMTP id 3cvh3ya5c6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 01:05:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ek31M4FOZUQ36ajwLvpoBSJPOoUJ12UbXNeD4XINuL83CO5x1smzVzGWq+zXCatPYzSynh945P12H3fKYxSu2IbR3ekTicT2LSalEBmbQNNT7S8lqlfcsl0W1GJp3TK1QDyfmKVWUg5jip73kfUaIxvMx+v3GEJr1IjAHdwr0nCxQGM8FGzaNRiUgz8PS4Hfdo45s74PpOgOo4hMHOBgVAoDqo9JlCb4sOYSSN5Zww4aulhdoXyNeoATj4vSmHydcbmdaW7XKzZcJCt2hHKdJxwnHI7CD1FLYap7H5B0ekNwTVlCqyGZVx2degbKx+PZtpgzklbfXj7QXXPUA31fmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gUwHy0mAcOXiZBnYx3uISsvzbt/itf1sm7uaBTsSJb4=;
 b=gZSdIvwmU2rExsm3e60f+Xh7ODkAk+cNUw2MsI3YVuL7VSvLmHEQmwf9Sq1xZr+JxGdRwicRoKsVkPokhbOP7h+ljwMhT1yxx5roxn9fvP1sMt1k+4qriJ/O0zspC+ew1PEHpK8pP6OtndkFbXGnlwkpssMt3szmXa9tNiKpNcVVt+DZzz0IU7T6iFgvZNFq7ccqQ5WQnovhKUzknmJSdE2cXTAnwipuKCIv1SPx8r9Kbf+oC+Yc3bj6djyNUj0b/GXsy++4wDyrNlzfYKRKsb3w1aDtRQTy1ArpuX9RdRDjQ2Kq0tQmX1XfoOHSEBp/diyhhS0EsKrO+J1qmVTLfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gUwHy0mAcOXiZBnYx3uISsvzbt/itf1sm7uaBTsSJb4=;
 b=kHo+4UR5FZxStgXSM+nqBYvQFwgTjGVVK8zTXtGICy/MqrT7EdPZDc/7VzaJrVIYllmwrFUYP5MWQ8tQJHi4odMfQyNHgPtfCo2x85SSEBECcXFUlEB37aY/rU7CnUH/lgv4KwKCu7D9eqcat4dHQlCzO6R1DJqoHCUpusv8KLg=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by SJ0PR10MB4461.namprd10.prod.outlook.com (2603:10b6:a03:2d8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Wed, 15 Dec
 2021 01:05:35 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::7c7e:4a5e:24e0:309d]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::7c7e:4a5e:24e0:309d%3]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 01:05:35 +0000
Message-ID: <4fc43d0f-da9e-ce16-1f26-9f0225239b75@oracle.com>
Date:   Tue, 14 Dec 2021 17:05:32 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: vdpa legacy guest support (was Re: [PATCH] vdpa/mlx5:
 set_features should allow reset to zero)
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org>
 <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
 <20210228163031-mutt-send-email-mst@kernel.org>
 <2cb51a6d-afa0-7cd1-d6f2-6b153186eaca@redhat.com>
 <20210302043419-mutt-send-email-mst@kernel.org>
 <178f8ea7-cebd-0e81-3dc7-10a058d22c07@redhat.com>
 <c9a0932f-a6d7-a9df-38ba-97e50f70c2b2@oracle.com>
 <20211212042311-mutt-send-email-mst@kernel.org>
 <ba9df703-29af-98a9-c554-f303ff045398@oracle.com>
 <20211214000245-mutt-send-email-mst@kernel.org>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20211214000245-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::46) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f69d72dd-54c1-4235-1653-08d9bf670042
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4461:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4461A0F02957F9A50EC3738EB1769@SJ0PR10MB4461.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VQA7YsanEl9e1VbRA+V9KzL4GJjyZ1Wm6sZ4I01UzjHrfaD8dMjWu4jxO4LybtIftK9JAEc7VQhAEKXiAEE7w6YakjtdFUHyXHsOebK2+TpVvfACnB4CTEmlBokj0fChGaQWddEGud7e6HdF9R9nP0mx0Td/1hwiC13Cech5Wq8hYzfWsQMtzuFRv1FFUw+dJvcxsK3E0cV0T7txPdHkSnMWQ0bh1V9VLFD+VflvretkDkWF5nvTyFXtQej9ET6fwsegQEVD1NoZrqwdZkRgjyj8Ezlj8/yD0co2ukZS70xB96Ygeo/e1ye5stJSZe0eanuRdxEL8eaN8b0qujuvKdOBWJzOxS9dssgL1jZk1HEJ8xdMwPJfTuhQefdeUAhBxFDjtTXkWvIBGqziHNnHdUuWOp+er3yG6/RU/9y5C0TMbUd/RwHzfAq+IKp1BAHlL5LvKH3D/5T5PACy0xZnK3GlW31YFfKMWlASC42O4NdnM04PvBsbzQSluW/qA////CMuxtBF14uq7rZFeE7LF6u9NpWEMTcc0Q4p686qgyqug9n1IBz9z+D9rDgSy2VixEqSZoJlHCwkrARWO+5h+vlQL+fNs5gfAK+RlgEJnJEXpBI9lMph0bDi/4ZC8AKRx6BASBIzOxNwrkI0Bc58EBSN56PstO9nWXaO7nyBN42Zw8npIyTMPbL2xyRBLmuwlk7ArmeLUiE0e3dPGWg03hQsTVzy5wWdQ+HzLYa3+e5zN1x9XfXXaE1Utksx3vhQGPTjbiDX8bgsfQPtaJQ2GrGobBnPZ1KhUSHllJ1ukGuCUTL2CDPCX8WhpHV+7h9P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(38100700002)(53546011)(5660300002)(316002)(31686004)(6486002)(2906002)(36916002)(86362001)(31696002)(2616005)(186003)(6506007)(508600001)(6666004)(6512007)(966005)(8676002)(66476007)(66556008)(66946007)(6916009)(26005)(4326008)(83380400001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a1l2TGxNQk40Ylk4aWo4YTg1ZHVjc3dZRVNLRkJUYU5qdi9ubGFhS0pMRmZ2?=
 =?utf-8?B?dmVqMjZOS3JUcHVjMSt3VEZ2STlUR2NiMVZ3c1hxZXFGYldjL0JzZVVRd3Vm?=
 =?utf-8?B?Rk9TTFdZNmQ1aTQzUklrNEg0ZVJOLytSNzVjYUxXNmZraTlTMEFjNHUxWDNv?=
 =?utf-8?B?TG04Wld3ZmMrMklxdit3K3NxM0Qvb3JOVTgxU2s0V3hraVh6MFZLM3o0ZUJt?=
 =?utf-8?B?QnRzOXdUejhBSmVIcDZjVDBieTUxQXpYY0NTREdDSlh6TFBQSG02QkhaL2Iw?=
 =?utf-8?B?T2IwZW5vQTVHcFJuMTdqTlE4UXFlTzRSTmFUdFpwcXh6TGsvN2FjTzBkbldM?=
 =?utf-8?B?QXJqQTFWT3paSVNpOWtPUm1DT0xrbzhRTGxVWmd1bEYzSzY2d0JqUk5zMTM0?=
 =?utf-8?B?aUdaTDcvSGNOeHZhZUdSZHRpVVN2a1lnMmJ0U28wVXhUSStHUGhwZTBLVXVM?=
 =?utf-8?B?ZXFDUFdJc1NDWWpDWkRya2ZERmloejJpTzZmYW5jUTN2SVNUZm8xSVI2QmVu?=
 =?utf-8?B?U3NxZEYwUEVIMTFDMUlxNTFiallBSjVCVGdWaVc3TktQaXJwN2Y4TEhFOTh1?=
 =?utf-8?B?Q2FSaDNlVy9IQ2xJUlF6UXg5L2xwUjFwVVd0NWtqZW5KaDhhWkw3ZmpmNzlJ?=
 =?utf-8?B?dkRTaXhhS2dqUVVCS0UrV294NVlPUWhvYi9KdE0zQWdaK1BVRjN3NjlmTGsv?=
 =?utf-8?B?THA2QUhKcFlCRmxGcTFzU3pRNUlIQVo3UFNDOW9pV0h4N0UwaktJSTZOdGQx?=
 =?utf-8?B?cC80SkhJZ1NDLzlXcHF4T210SE9mNmdzWDZtRG1oNGpzUVZINmVnRW4zT3o0?=
 =?utf-8?B?VXFHeHA3NjZNRHFycXlKZ3RaWUdGOTZVeE12NWwySWNKMk1aUEFIeFd5dFNa?=
 =?utf-8?B?dFZzYTFkYWFwMnY4ck92QyswMGU5UG52Vno3bGxxdVVSRHNabm9KcjhRVzc0?=
 =?utf-8?B?SFpOL1JnNFBJKzJZOHpJM3p1aHRCMnd1bWxpNUF2UWFnM2kwV01RVTJHUXF2?=
 =?utf-8?B?V1FoeW9QVnYreVRUQlJGVmZTV2NxcUdhTk1pRHNpRG5lcmYzdk52UHdJRzdW?=
 =?utf-8?B?MFZxZVA5L3BBWVpoL3ZOZStSVzdaSk1QbzFoQ0t0VzUxVndLaVFRc1B3eWpB?=
 =?utf-8?B?MWZlbktRb01PZlk5R1ZFUHY0YmVWclAxdEFSUjE4QTZYODFrUVJXNHJVYWpv?=
 =?utf-8?B?eE4yak85NzdYeGZ3d0RBRkxjVGNCL2dJd1RnWnJkNXNKTnl6TTVRSWxocjRI?=
 =?utf-8?B?dHhFNzFudTFuVThUbm9Qdi80bmtOWWNTdC8ybDdGejRramZieE40V21kbTkw?=
 =?utf-8?B?d1k1ZDE4RlZybzBudGRBVWFBYlpxZkpKK240N0lHR3lRMTREZ2daTGs2Y2FN?=
 =?utf-8?B?Rkl4N0V6WkZVVEwyaFBzR1BDWmVhNFBxNGNqV3VpWHJMeDBoY0dIOUo5Y3VT?=
 =?utf-8?B?REladlVJVWQyVXYyQkpQN3EvQ2lkTmNBZHhZNHhHbVZIeXJ4SE9uMUtnUkdk?=
 =?utf-8?B?SzFhMm1sV0NvVW84bC9NdXZjdUhhOFdtMEtyR29lQVBQcjhhalMzWXJST1Ex?=
 =?utf-8?B?MlMweG53MkRKWGppeEFCdVExQTFnU1pBV1M0Rk56bVB4K2pqRU9EL1AyUWFW?=
 =?utf-8?B?cjNyWXJFR0s1NVFhaHUxdnJOMHN6eG1HN0xXSTdUanhvVXYwZ3c4SFEwNU12?=
 =?utf-8?B?ZTdyWkVBM0ZBQVo3SzMyb1dudVd2SXQwV2VkOXpFUDRjdEN2L25hRFhHTE5F?=
 =?utf-8?B?OWQ4R2lRd3dLeXNOcVFUWFl1MG1ockN5NE8vRGlpaVI2Vzk1TkV3UnNlSzBt?=
 =?utf-8?B?Uk9obEwxS2R4Q3RQUGJSa3oxd2plTkxIZVNqeXg5cGRWL2ljV2NTd1ZnNERN?=
 =?utf-8?B?RldQbk1HbXhBdURKRWwwcElpTG1JV3Ayc2tHWXB0MlltNytPN2tuYVl2dlBB?=
 =?utf-8?B?ZkovME1MUEdsZjkzNEhyU3lCOUVpT0R3T0Z1RlpoYU1LdWtMRTd2cVE5cFp2?=
 =?utf-8?B?RUNWTENNSFlySXhYVkVvdktVOEtSbHM1NFoyZFByYTJWOWRkWE40S3RrcHhz?=
 =?utf-8?B?NTRjeENDZFZvaXdVQmNMczBZaXdGVFlFcDFodVlXV2VaV1pDN3lGaGl0L04v?=
 =?utf-8?B?THNUOHptcnY3VEErdFg3NE5oU2hKSHRCOHJneWRTMU82cTY4NTQzTlFsZ3p1?=
 =?utf-8?Q?yk2fDpv3R8JwvA90FJ5ekMc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f69d72dd-54c1-4235-1653-08d9bf670042
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 01:05:35.8066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3mzmrbg8xEf+7QZUdEniet7f9Y1xs3iZb78TFKUNTYzHEsPhA0FjI7HPnKdGEJSBZzXIU8drf/KBpxFtirKQaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4461
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10198 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112150004
X-Proofpoint-ORIG-GUID: 9-KGYoexQmnsISzNiSltgXvLsvjlMz-y
X-Proofpoint-GUID: 9-KGYoexQmnsISzNiSltgXvLsvjlMz-y
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/13/2021 9:06 PM, Michael S. Tsirkin wrote:
> On Mon, Dec 13, 2021 at 05:59:45PM -0800, Si-Wei Liu wrote:
>>
>> On 12/12/2021 1:26 AM, Michael S. Tsirkin wrote:
>>> On Fri, Dec 10, 2021 at 05:44:15PM -0800, Si-Wei Liu wrote:
>>>> Sorry for reviving this ancient thread. I was kinda lost for the conclusion
>>>> it ended up with. I have the following questions,
>>>>
>>>> 1. legacy guest support: from the past conversations it doesn't seem the
>>>> support will be completely dropped from the table, is my understanding
>>>> correct? Actually we're interested in supporting virtio v0.95 guest for x86,
>>>> which is backed by the spec at
>>>> https://urldefense.com/v3/__https://ozlabs.org/*rusty/virtio-spec/virtio-0.9.5.pdf__;fg!!ACWV5N9M2RV99hQ!dTKmzJwwRsFM7BtSuTDu1cNly5n4XCotH0WYmidzGqHSXt40i7ZU43UcNg7GYxZg$ . Though I'm not sure
>>>> if there's request/need to support wilder legacy virtio versions earlier
>>>> beyond.
>>> I personally feel it's less work to add in kernel than try to
>>> work around it in userspace. Jason feels differently.
>>> Maybe post the patches and this will prove to Jason it's not
>>> too terrible?
>> I suppose if the vdpa vendor does support 0.95 in the datapath and ring
>> layout level and is limited to x86 only, there should be easy way out.
> Note a subtle difference: what matters is that guest, not host is x86.
> Matters for emulators which might reorder memory accesses.
> I guess this enforcement belongs in QEMU then?
Right, I mean to get started, the initial guest driver support and the 
corresponding QEMU support for transitional vdpa backend can be limited 
to x86 guest/host only. Since the config space is emulated in QEMU, I 
suppose it's not hard to enforce in QEMU. QEMU can drive GET_LEGACY, 
GET_ENDIAN et al ioctls in advance to get the capability from the 
individual vendor driver. For that, we need another negotiation protocol 
similar to vhost_user's protocol_features between the vdpa kernel and 
QEMU, way before the guest driver is ever probed and its feature 
negotiation kicks in. Not sure we need a GET_MEMORY_ORDER ioctl call 
from the device, but we can assume weak ordering for legacy at this 
point (x86 only)?

>
>> I
>> checked with Eli and other Mellanox/NVDIA folks for hardware/firmware level
>> 0.95 support, it seems all the ingredient had been there already dated back
>> to the DPDK days. The only major thing limiting is in the vDPA software that
>> the current vdpa core has the assumption around VIRTIO_F_ACCESS_PLATFORM for
>> a few DMA setup ops, which is virtio 1.0 only.
>>
>>>> 2. suppose some form of legacy guest support needs to be there, how do we
>>>> deal with the bogus assumption below in vdpa_get_config() in the short term?
>>>> It looks one of the intuitive fix is to move the vdpa_set_features call out
>>>> of vdpa_get_config() to vdpa_set_config().
>>>>
>>>>           /*
>>>>            * Config accesses aren't supposed to trigger before features are
>>>> set.
>>>>            * If it does happen we assume a legacy guest.
>>>>            */
>>>>           if (!vdev->features_valid)
>>>>                   vdpa_set_features(vdev, 0);
>>>>           ops->get_config(vdev, offset, buf, len);
>>>>
>>>> I can post a patch to fix 2) if there's consensus already reached.
>>>>
>>>> Thanks,
>>>> -Siwei
>>> I'm not sure how important it is to change that.
>>> In any case it only affects transitional devices, right?
>>> Legacy only should not care ...
>> Yes I'd like to distinguish legacy driver (suppose it is 0.95) against the
>> modern one in a transitional device model rather than being legacy only.
>> That way a v0.95 and v1.0 supporting vdpa parent can support both types of
>> guests without having to reconfigure. Or are you suggesting limit to legacy
>> only at the time of vdpa creation would simplify the implementation a lot?
>>
>> Thanks,
>> -Siwei
>
> I don't know for sure. Take a look at the work Halil was doing
> to try and support transitional devices with BE guests.
Hmmm, we can have those endianness ioctls defined but the initial QEMU 
implementation can be started to support x86 guest/host with little 
endian and weak memory ordering first. The real trick is to detect 
legacy guest - I am not sure if it's feasible to shift all the legacy 
detection work to QEMU, or the kernel has to be part of the detection 
(e.g. the kick before DRIVER_OK thing we have to duplicate the tracking 
effort in QEMU) as well. Let me take a further look and get back.

Meanwhile, I'll check internally to see if a legacy only model would 
work. Thanks.

Thanks,
-Siwei


>
>
>>>> On 3/2/2021 2:53 AM, Jason Wang wrote:
>>>>> On 2021/3/2 5:47 下午, Michael S. Tsirkin wrote:
>>>>>> On Mon, Mar 01, 2021 at 11:56:50AM +0800, Jason Wang wrote:
>>>>>>> On 2021/3/1 5:34 上午, Michael S. Tsirkin wrote:
>>>>>>>> On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
>>>>>>>>>> Detecting it isn't enough though, we will need a new ioctl to notify
>>>>>>>>>> the kernel that it's a legacy guest. Ugh :(
>>>>>>>>> Well, although I think adding an ioctl is doable, may I
>>>>>>>>> know what the use
>>>>>>>>> case there will be for kernel to leverage such info
>>>>>>>>> directly? Is there a
>>>>>>>>> case QEMU can't do with dedicate ioctls later if there's indeed
>>>>>>>>> differentiation (legacy v.s. modern) needed?
>>>>>>>> BTW a good API could be
>>>>>>>>
>>>>>>>> #define VHOST_SET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
>>>>>>>> #define VHOST_GET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
>>>>>>>>
>>>>>>>> we did it per vring but maybe that was a mistake ...
>>>>>>> Actually, I wonder whether it's good time to just not support
>>>>>>> legacy driver
>>>>>>> for vDPA. Consider:
>>>>>>>
>>>>>>> 1) It's definition is no-normative
>>>>>>> 2) A lot of budren of codes
>>>>>>>
>>>>>>> So qemu can still present the legacy device since the config
>>>>>>> space or other
>>>>>>> stuffs that is presented by vhost-vDPA is not expected to be
>>>>>>> accessed by
>>>>>>> guest directly. Qemu can do the endian conversion when necessary
>>>>>>> in this
>>>>>>> case?
>>>>>>>
>>>>>>> Thanks
>>>>>>>
>>>>>> Overall I would be fine with this approach but we need to avoid breaking
>>>>>> working userspace, qemu releases with vdpa support are out there and
>>>>>> seem to work for people. Any changes need to take that into account
>>>>>> and document compatibility concerns.
>>>>> Agree, let me check.
>>>>>
>>>>>
>>>>>>     I note that any hardware
>>>>>> implementation is already broken for legacy except on platforms with
>>>>>> strong ordering which might be helpful in reducing the scope.
>>>>> Yes.
>>>>>
>>>>> Thanks
>>>>>
>>>>>

