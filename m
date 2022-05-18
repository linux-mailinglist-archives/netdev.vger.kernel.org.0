Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC69F52C49D
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 22:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242641AbiERUkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 16:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242624AbiERUkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 16:40:16 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2D42AE32;
        Wed, 18 May 2022 13:40:15 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IHDctb022079;
        Wed, 18 May 2022 13:39:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=vUk21w+f53Nk1IZo954bz4Fb7I5ETV93Bif9pJc/dnM=;
 b=C3Q4SyQ69XukipBaF5Hr/2TQgAwYSthclbFSPoqrVecPr7pbYPnG/MyzQcpyrt3lcJxh
 u7dMhoni7JdUT9DgxGCcZGQdU6T2DPCypfwUdDZbeiUtOewYo9OGuUsHIHhAmEmO+b5l
 fkymmuKtLbIc0tgDhX/rfp/1fkIrUVNLZL0= 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2047.outbound.protection.outlook.com [104.47.51.47])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4d822wd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 13:39:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fdpy6FAGQSRJUm8bHxJX5Wu/gcrVLTLFn3lOLF6RI9Mp/Q8xwVKYAYP+voa7q80VWViQHmJgLW7eeONF6DPn0LLILUey4FZ/9fFdfHuHUO96ux6iur2Q5KLVcmao9uK5uUQS+DxGq2bIUvuL1OfOD/cRyPbHsGIxBAEvLOWn2Ka8dDnREu4xLvpgbNAQGrvpFi9Ym5e+eG4zmqjw6q9OpQWecXsnC18bj1sLozVHe24GzGwMVTt3HJUMbrW2omDdvVwg4ZJCO3N7us2KNSxDt15sIWuoyYexwzmDlqn5BLibjNMYAb6DmpPQGRCjY9GCArMgsbWVxZ5+xqllfZgTKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vUk21w+f53Nk1IZo954bz4Fb7I5ETV93Bif9pJc/dnM=;
 b=g7hluMoEvBX46f3DI3oKGqT6NSPGYal2Gj+pJiV3AeIdgkPk5nJcR84oa805yq+Zt1rol5hpSTptoh34IKZGFGdPGqZInWj57HtRq5LHkfl7jO6cdJuCsK6HO2S+JfyzuE5FpVUjCQ7dQrisoSTZQxHKzeKtCGKRZfFqwWtI+CuNEiklgvS1S3gPrCOb+GDt0F2gaQfqs5WfUzO9qs6EAAc+6Rabhfasdbwioq4MhTXZsTIRSQI2VqtsUNG0fuiuxEf5ZJRF6+Xd+LDBOEjCXDmmWibMH48XP2S6U87Yoy4/iJhVsTcnopvjTcOd5M+SHlmR9f4yuMQG0p7loEFiyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BY5PR15MB3716.namprd15.prod.outlook.com (2603:10b6:a03:1b4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Wed, 18 May
 2022 20:39:56 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.015; Wed, 18 May 2022
 20:39:56 +0000
Message-ID: <9c0c3e0b-33bc-51a7-7916-7278f14f308e@fb.com>
Date:   Wed, 18 May 2022 13:39:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [External] Re: [PATCH] bpf: avoid grabbing spin_locks of all cpus
 when no free elems
Content-Language: en-US
To:     Feng Zhou <zhoufeng.zf@bytedance.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
References: <20220518062715.27809-1-zhoufeng.zf@bytedance.com>
 <CAADnVQ+x-A87Z9_c+3vuRJOYm=gCOBXmyCJQ64CiCNukHS6FpA@mail.gmail.com>
 <6ae715b3-96b1-2b42-4d1a-5267444d586b@bytedance.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <6ae715b3-96b1-2b42-4d1a-5267444d586b@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CY5PR13CA0001.namprd13.prod.outlook.com (2603:10b6:930::34)
 To SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7102892-754b-4e18-5d2d-08da390e916b
X-MS-TrafficTypeDiagnostic: BY5PR15MB3716:EE_
X-Microsoft-Antispam-PRVS: <BY5PR15MB37161985AAE893895BDD06CBD3D19@BY5PR15MB3716.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FHXYqw9ukGv8iirDxpZB4o7xa+EFIjXVbuxARej5SNpFvlC1YVwDGt7CuesrqcfQMRNgnAumDdPumCADbodSLCGz4xwWYGeA+EKeHIETgR4Qw65Iw4VRB9SiE5V+aPGCn1n+dCRdGgmN3tx4KM3Y2XU6+3I5HM4siHrxchSf6aVwfV9wBkjGsCKhwCttYoOGSl85tkdhV4ZYz2ea3g+PzYIBnNVyqN8XGb+mklqoH61TXarkzythsL0tc6K6tk4LdnsezEhMHgQgkBWxMfYgziYPAlKVb21qbyHdEFQ9JX/9o/GcJgjUA+jH4NTrYUZLHMtkkm7mD3fyV3EOjZnx12dCTHwT0Lnj7g8UOrFx8aH2p9SuMN4K4bI+0UB4cAEh3s0wN1+ZDC7VgPUqpFHQKY6oIJW0Nqeqe29FwGTC+9MdRs66nVP09TSk/qv7ZdPZDG5naoSmMsyjsIwUhjfjLxg4QXKpNssygMQEF260zTMSPJLMF3K4gtDwBaaVqUhdf5a6m4/lL5P1qC5YwJFtatR0S+MJNFekhdGr8WpoLS52pzIenGE89aiGDNzZwLXI30N6DBxgnLptOs4jP3SKkukrXlHt9f+8TyoxsEcR+Dkd+aFh468Fzcb/JBTSmAlB9xXlHUeC3MGkRXnVE/5efiM0c/qDP9ZJOcDoVPVL7sMn5aCvVKEIRVxxNXWo14WrlpQ0X5sxDOyHzhvLXIy3NDc8fkm4krWtgv/OUj/PWxM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(8676002)(4326008)(31696002)(66556008)(66476007)(110136005)(66946007)(2906002)(83380400001)(6512007)(6486002)(316002)(508600001)(31686004)(8936002)(36756003)(5660300002)(7416002)(6506007)(86362001)(38100700002)(53546011)(186003)(6666004)(52116002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RFN1cFJ5cFFYcVUyR1hVVG8xQkVGWXljL1hYRnRRRVYzZ1U5V0N3MmNYYVN1?=
 =?utf-8?B?QWdkalpGRXFrRHNHMGMxRERiczk4cC83NWgzd08vVzhCbTZpUDg5YTEzaUFR?=
 =?utf-8?B?OWlWb012ZS91MUpMZWJCcVArVjk0cXF0TElBUlZZRnB4QURoVWxNaVgzRWF3?=
 =?utf-8?B?MFc5YUZ0N3dpZjR2MzczOVFkTG1IRDlFSnVTMWRnNGlwRFVwYzQ0bDU3NW1D?=
 =?utf-8?B?eFJRZFR0VmpZWjBQLzlqdmtwSFNFQUVoVlcvZ3c0QmRQQllza1Z3NHNLN1d3?=
 =?utf-8?B?RVJ4OVdTSC9YbkpjRjJmQkV2VmlmMWsvVTZyOHliNVdIamlOcGtwNUt5bEx2?=
 =?utf-8?B?ejNJTDJjRERQWFZHKzFiWVNuRWNTNWtxVk5mL3NKckpMUStqdHlWdmJiNWJu?=
 =?utf-8?B?Q0tTdjhuOEg2b3BxSkRhTXJHWFM4UlJrNUZ0aXZvU1MzSFIrR2ErZnhrVlFY?=
 =?utf-8?B?ZnpvRjNrMVZ6clBwTXJEaU0xRDdYaC82MmZhc0c5R21aNllmckFINllFZU5o?=
 =?utf-8?B?VXRmMGNOdk94eU1uZGg0L0d1MDVrRFlQRkVpRHJmamlRTGJ1TWxFeGR3dFF3?=
 =?utf-8?B?dEZRVkF4U2VOVTRSaGtOMHpLbVB5cjg2aUhxYzdLV3BLSzR5aTJEakhMbXVS?=
 =?utf-8?B?b3RYV1h2Vjg5bCt0V1VlUkRtcU1CZ0ZZMFB4WDhjdWVFMUdyWTNjZVBZSm5R?=
 =?utf-8?B?ZGNITjQ2VVNLYlFaaDJSSGNhU3Z1dWJSVnZkdTVsY21LRmhpcWZydCtjZFRJ?=
 =?utf-8?B?aSthaVV5N3VncVRVZE1rRW0rb0pZaEVoNUhiTGRTSS9jUG1kS0pIMFJEQWRK?=
 =?utf-8?B?Z3l5NUZXbUkxZzQ1SC9PZktjL0daemxCSjladWl1VU5wZjVtOWpRSHZlNUVq?=
 =?utf-8?B?SHdPSFFpWXFBdmNQOS9BOXlUOGpTNlMrMmRQQ2NlM2ZHcWphd0pwVnJLbTJG?=
 =?utf-8?B?Q0VHMDJ5VGsySjVJaFdyNHQ1dXNIbGhaQVdlVWppTVQ5cEtFLzM2Q3Vwc2hM?=
 =?utf-8?B?eE9aT0NEY3hEZ2xNRFFFVkJ6UDAxWFVPVGJQTmF2TUYyWXhtYUlEVFhHaEow?=
 =?utf-8?B?dE1mNjR6WDJtMnA3elU1MTU4U28xbmZ2Y0p1NEFXSUtLOTFlVkJzUm5WOC83?=
 =?utf-8?B?c1AxckpZbjJQOUdqQ2lsWXlWS0xWZWxhdTlSR0xwdE9tYjd4eE1EYXpPZUNr?=
 =?utf-8?B?SThJOEIxQ0NNalpQZGcrSU95OSs2UmFVZUE3aGRITXpoL2ozOGQzK1VwOEFj?=
 =?utf-8?B?NTdzNzQ2VzFKMEpzZ0NRQmFrMWRIby82d1J3c0Z5RG1oVGFHZUFRSkR6azNP?=
 =?utf-8?B?eVV0U3kwZWFNaWNwMzBPTVdUb3hoL2hsbWJGTzdOa1NCY3A5TnZ2NjRBV2J2?=
 =?utf-8?B?a3pEQkdnc1FkdWpMZG5MVk8wRlhzMFpRNEJlYVA2dXdVbXFRb3BtbVhVc0lt?=
 =?utf-8?B?QzFGeWd2dXZTaUw1TlRPWTRiYUxIYWtQT2ZzRTY1bjU1bXhiVzV6d21UZ3FM?=
 =?utf-8?B?eFdCUGdlNDZFOXJrMVZ0OGtLMTh4ZU83c1VEQllrOHpHMUNLYmFpUmt3OUJB?=
 =?utf-8?B?dG0xUENPV1E1TDk5RVFzOUd3RGorMW9FNkVtOGlONmt2Z04ydllNekdqTE84?=
 =?utf-8?B?YW1uSE04ZDZ6SS9uTWJISjFvbVBVSzVDbTBEZVBWZ0dRcElSVVhmeTFNTEhT?=
 =?utf-8?B?dmxwbWoyVTIzYTVFTEZMaFRKZjJ6Tys0Q3g0b1BxNUlmUFYrdXY0TmMxT2Jp?=
 =?utf-8?B?V2tNWmJJelc2NmhNT1dkQnkvbHlvQ0xWOGtrM004V0xtY3dCSHprSUFXbVBH?=
 =?utf-8?B?L1AxMGhNTlpJOTNvcHNlR0FMRU5TQkpNVkNNcVdOTlUyU08rdnNvWjZMemky?=
 =?utf-8?B?cU1iaEJCNGIvSXVJL2hNRE5HTjlaUmtGK1FINHpPbnI5L0JrN2c3WE4rM3RX?=
 =?utf-8?B?dC9ZU0szSlhDUjlzNXkwNG9ZYkdoaHAyVXhkODBCNGN2U0lIaCtsWFVPQi9l?=
 =?utf-8?B?emdIQnhwK2pXUWdZZzkvdWlvekNxemNTeldlazEwcG9QVjY1S2l0MytMQTVi?=
 =?utf-8?B?QmpyTDl3dkowUkJIdVR1MFdJTjRwaG5Mck12TytZWVBKd2QwOUhNbkRXQk9y?=
 =?utf-8?B?UlVkVHNLblJzakNSZWhDay9INmRDNE85MS9YUDcrZTNYNGViZ1piMnNoSHAx?=
 =?utf-8?B?Y1FFVXJ0VjFVNzhON05OUGZwbk5ZSWh1YVN0dS9wc1hWN1QvNmZuN25oZDJX?=
 =?utf-8?B?K2JNZW1mNDl3OEVqZGZGaU00N1VCaDF2dDcySm9SYkRuWjFYa2NYcjVHaFZh?=
 =?utf-8?B?ajE4aVNUZmgrZi9VRWl5NU9xRHlKRWpUVEd1bHdkQzJiRlppTlZqTmpqTVZW?=
 =?utf-8?Q?cp3LJ/oFHqNCfp5M=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7102892-754b-4e18-5d2d-08da390e916b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 20:39:55.9498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 99bf46ZfaPj7jMGUXtN8GWqi1Aezz5TnDdqvFq5x+8AOSWGXPeZzhHjQM3y2rpQo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3716
X-Proofpoint-GUID: 8xodYl-gy84rM2COrrbHMqORhDov4CjL
X-Proofpoint-ORIG-GUID: 8xodYl-gy84rM2COrrbHMqORhDov4CjL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/17/22 11:57 PM, Feng Zhou wrote:
> 在 2022/5/18 下午2:32, Alexei Starovoitov 写道:
>> On Tue, May 17, 2022 at 11:27 PM Feng zhou <zhoufeng.zf@bytedance.com> 
>> wrote:
>>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>>
>>> We encountered bad case on big system with 96 CPUs that
>>> alloc_htab_elem() would last for 1ms. The reason is that after the
>>> prealloc hashtab has no free elems, when trying to update, it will still
>>> grab spin_locks of all cpus. If there are multiple update users, the
>>> competition is very serious.
>>>
>>> So this patch add is_empty in pcpu_freelist_head to check freelist
>>> having free or not. If having, grab spin_lock, or check next cpu's
>>> freelist.
>>>
>>> Before patch: hash_map performance
>>> ./map_perf_test 1

could you explain what parameter '1' means here?

>>> 0:hash_map_perf pre-alloc 975345 events per sec
>>> 4:hash_map_perf pre-alloc 855367 events per sec
>>> 12:hash_map_perf pre-alloc 860862 events per sec
>>> 8:hash_map_perf pre-alloc 849561 events per sec
>>> 3:hash_map_perf pre-alloc 849074 events per sec
>>> 6:hash_map_perf pre-alloc 847120 events per sec
>>> 10:hash_map_perf pre-alloc 845047 events per sec
>>> 5:hash_map_perf pre-alloc 841266 events per sec
>>> 14:hash_map_perf pre-alloc 849740 events per sec
>>> 2:hash_map_perf pre-alloc 839598 events per sec
>>> 9:hash_map_perf pre-alloc 838695 events per sec
>>> 11:hash_map_perf pre-alloc 845390 events per sec
>>> 7:hash_map_perf pre-alloc 834865 events per sec
>>> 13:hash_map_perf pre-alloc 842619 events per sec
>>> 1:hash_map_perf pre-alloc 804231 events per sec
>>> 15:hash_map_perf pre-alloc 795314 events per sec
>>>
>>> hash_map the worst: no free
>>> ./map_perf_test 2048
>>> 6:worse hash_map_perf pre-alloc 28628 events per sec
>>> 5:worse hash_map_perf pre-alloc 28553 events per sec
>>> 11:worse hash_map_perf pre-alloc 28543 events per sec
>>> 3:worse hash_map_perf pre-alloc 28444 events per sec
>>> 1:worse hash_map_perf pre-alloc 28418 events per sec
>>> 7:worse hash_map_perf pre-alloc 28427 events per sec
>>> 13:worse hash_map_perf pre-alloc 28330 events per sec
>>> 14:worse hash_map_perf pre-alloc 28263 events per sec
>>> 9:worse hash_map_perf pre-alloc 28211 events per sec
>>> 15:worse hash_map_perf pre-alloc 28193 events per sec
>>> 12:worse hash_map_perf pre-alloc 28190 events per sec
>>> 10:worse hash_map_perf pre-alloc 28129 events per sec
>>> 8:worse hash_map_perf pre-alloc 28116 events per sec
>>> 4:worse hash_map_perf pre-alloc 27906 events per sec
>>> 2:worse hash_map_perf pre-alloc 27801 events per sec
>>> 0:worse hash_map_perf pre-alloc 27416 events per sec
>>> 3:worse hash_map_perf pre-alloc 28188 events per sec
>>>
>>> ftrace trace
>>>
>>> 0)               |  htab_map_update_elem() {
>>> 0)   0.198 us    |    migrate_disable();
>>> 0)               |    _raw_spin_lock_irqsave() {
>>> 0)   0.157 us    |      preempt_count_add();
>>> 0)   0.538 us    |    }
>>> 0)   0.260 us    |    lookup_elem_raw();
>>> 0)               |    alloc_htab_elem() {
>>> 0)               |      __pcpu_freelist_pop() {
>>> 0)               |        _raw_spin_lock() {
>>> 0)   0.152 us    |          preempt_count_add();
>>> 0)   0.352 us    |          native_queued_spin_lock_slowpath();
>>> 0)   1.065 us    |        }
>>>                   |        ...
>>> 0)               |        _raw_spin_unlock() {
>>> 0)   0.254 us    |          preempt_count_sub();
>>> 0)   0.555 us    |        }
>>> 0) + 25.188 us   |      }
>>> 0) + 25.486 us   |    }
>>> 0)               |    _raw_spin_unlock_irqrestore() {
>>> 0)   0.155 us    |      preempt_count_sub();
>>> 0)   0.454 us    |    }
>>> 0)   0.148 us    |    migrate_enable();
>>> 0) + 28.439 us   |  }
>>>
>>> The test machine is 16C, trying to get spin_lock 17 times, in addition
>>> to 16c, there is an extralist.
>> Is this with small max_entries and a large number of cpus?
>>
>> If so, probably better to fix would be to artificially
>> bump max_entries to be 4x of num_cpus.
>> Racy is_empty check still wastes the loop.
> 
> This hash_map worst testcase with 16 CPUs, map's max_entries is 1000.
> 
> This is the test case I constructed, it is to fill the map on purpose, 
> and then
> 
> continue to update, just to reproduce the problem phenomenon.
> 
> The bad case we encountered with 96 CPUs, map's max_entries is 10240.

For such cases, most likely the map is *almost* full. What is the 
performance if we increase map size, e.g., from 10240 to 16K(16192)?
