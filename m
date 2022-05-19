Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D23652DA84
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 18:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241725AbiESQpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 12:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbiESQpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 12:45:43 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B828095;
        Thu, 19 May 2022 09:45:42 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24JFG9Kk014619;
        Thu, 19 May 2022 09:45:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=DIZgqqj6mr9C/+jBVLdKdCC+It0hJhCQSJzwY6nZvGQ=;
 b=OY7jR2hwR5+eW8RRZfU58Um5QB4ck6/m4pTDHqbjbs1MKpnErwpQssssAItzRdRppozq
 82LnKoD22vU9akO7YTpKS8VpHR5VCU+OUZPzb3Npj4EAjyAwpds/Ix+U4GxaHVvzmZZS
 pslxr6hnpP/2JQtvxGIUvEQCzml8egvRv0A= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4ck0s84f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 09:45:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YMAUSnKeL4tugj4/svhrNPlg80PlTBomtqU/lB+AEVJLYHlG9eDA5zMxWCnyNH7sEZC2nmbufrRRTw/4nh1M4b/UsUVyYXcRgWVbGIQRnb2gJAk1zwX0Z7LDyJDpV+HSQvzgNPOaV743zPaW5INxHkBQLwavokCayiX3oUDA3o+4Gv4uJ+yc/PCgeN5/hvMN6pWF7EinPaMlKorND7Le0DfA3gOnfDLe91jPrZI6jCUNPu7ZNrDE/DMLk85VmO3856QuIa2B9d5Sk91PzY/7tEESyDNhBOG/4qTdJZP1nE4zHWsHOdm16vdmzmtxv7sHFAA19RPgaHWDcNeQghR9Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DIZgqqj6mr9C/+jBVLdKdCC+It0hJhCQSJzwY6nZvGQ=;
 b=JMDbrpuIlxB20Ddi8FPp0r4QnnwbFoSSw2zKNwaXdRvAwcXY7Ik9BS47qN9xBowZZDkU+i7zJ0AFjs7or4zlEJSAaieOb5PT2PlnSwE4ohhy7awHYtxwzKcfqeTa6rqon8oum0lEjxhpqZDnPzUHDgqB4N/sdhYbnHoHbs3oytdWDBpD/dxEvr3xVwZGInspC5Nye4k3oWRIhjHYOuD6v0xReUjCWQajHXJpvLtX4n472st4M9p7S3WLs/m3MDFME2b9WzWBo5oCLGqLe5TLOAUbPmk9hnlBZqbXBGZvj6QBWNw9aSvcPhybghB81o7iLPlxTbY/10PzCqxC4aK+dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM5PR15MB1932.namprd15.prod.outlook.com (2603:10b6:4:55::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.16; Thu, 19 May 2022 16:45:24 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.015; Thu, 19 May 2022
 16:45:24 +0000
Message-ID: <0f904395-350d-5ee7-152e-93d104742e98@fb.com>
Date:   Thu, 19 May 2022 09:45:21 -0700
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
 <9c0c3e0b-33bc-51a7-7916-7278f14f308e@fb.com>
 <380fa11e-f15d-da1a-51f7-70e14ed58ffc@bytedance.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <380fa11e-f15d-da1a-51f7-70e14ed58ffc@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::14) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f49fbc37-03cb-4ecc-44ca-08da39b6f847
X-MS-TrafficTypeDiagnostic: DM5PR15MB1932:EE_
X-Microsoft-Antispam-PRVS: <DM5PR15MB19322831C74E149E9549B680D3D09@DM5PR15MB1932.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z4eYAQ2eUoPTgzjjioa2YU2n6L7Opp6WeD+lztrhdHjymt6AZC0wPbJTSuhCXKVZPZ3buZJcnnoe3Znj8n/oc6LWxFRZ5Zw6xMIe0oNg9Lj/NCGrHGwpsog31ynMLphuPg8xOkir7u9aSaHUtmknBw4ax3Lg1M9hXIFV/Y/HEcEPOgBQ4/ohMK6lOTm+9wuu+SUqlKOPI2k+oGmFrC6awxkydQJEj+rmixz0xVA63W1zPAv+Wva92LcdmzSjV88C0sWeS1GYwN0aYbPnkJXYiyKfcPFTqjUFM61TyAHjIKtDFoLiVXIxYNgO7Wmu74s4oe0WpajIqxM537WBiJbgrs7nT95jKV8FvSFWqwFT7aLWw6d3mwD62Sg5ynoLmkoH5twAgaDrEbDZ3bLtX+/mBgASdxuH6kfONRWwdSHfpxXpPJoDCJ6ZBuu/f5CgkTpCrQvgh6a2v5bFNLtqwPi+Oc5otSivRiB2luIujL8RDtxdQ+D5GnfE/IBTFOvkG0H/T0MT5DbT9YH6pcOow7WGQquMHtv8IEiyzTlgFi7SZVDyoc83GK1AUXFSoFCYE0FTE9EPp/GAZAvCczEafv43Ig1ohRzsulWCNb2BbaVooczy7jrhaQOI4thrbf9Vmi2XUXXzeEkKwGSn03mEXSGyspEBAmCq+xfZ/WbxqKi9mt7Zgsz7Y/EM/ciER0yD6B8f58cHfAF8NRSi/p1fgkHILYLQH80oE10rM8H4bBc8NB4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31696002)(8676002)(66556008)(7416002)(8936002)(66476007)(4326008)(5660300002)(38100700002)(86362001)(2906002)(110136005)(36756003)(66946007)(186003)(54906003)(6666004)(316002)(6512007)(508600001)(6486002)(52116002)(6506007)(2616005)(83380400001)(31686004)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXFYUGJhNm5ObEswQWlxYXhVRHJ1RkVpRG5rR3ZpclFrdklrMEsvWGVQS1Rh?=
 =?utf-8?B?VjRTVml3TURyaCtSemlWZlp0VHFoMkkzdGVGQklLQzJDME93ZXdxbVErb0d1?=
 =?utf-8?B?QmhZdVlWTXVmYjR6aUtsT3dCd1RXOWp0Z21CeWxjdTVGVjFqTUI2MjMyUGR1?=
 =?utf-8?B?RDZLeFBNTzJsMk9sbFBzMXNMV1kxbmd6Wk5GSEFJRjlxWUxtaDdSdkJqRVI0?=
 =?utf-8?B?SU1HOTlYSXJKZEVzTDJyVEpQOTFJaW85T3RyVEFnaDBtQXVVNk1scGlrQzhZ?=
 =?utf-8?B?VVEvdWE1UllXUUZOT0FycGpHSEUwQ2E3c1JDakdieUZ1VXdyVmx0bVBaNHg1?=
 =?utf-8?B?WktUa1FXUERuUndOZGpmSy9meFE3dDVwRWNkQ0JUbktqNktORVFLa05yZnJB?=
 =?utf-8?B?RlBJdmxBVzhVOEp0bjZHcEV3VTYxUVdWaUlodVVHcDlEa25rczZYRVlvYzEr?=
 =?utf-8?B?VFFVT25PNWVWbStMQTNLZGRWYkw4UnJzTzVKYnF3eUZqQWo2UEVNaUhoMTNN?=
 =?utf-8?B?UFBtS0lYVGl5eThTcDRQc2tUVFEwOUkxS1BRdk83YkRvZ0FSbFN4Zk1vRlh0?=
 =?utf-8?B?QTUxLzg5QXgrK0Jjam9YQkFUeXRMVkl4azFIcThHWDNoYmFweUlWN2lTUXpi?=
 =?utf-8?B?Ukg4Q01MY3o3NFBBSjZwVTh0YTh1aDRpVHZremZNcXI1OFZRQkQ2d2ZnS1Jm?=
 =?utf-8?B?MWt0M1JrZTR5MlBRMFBKdjBjTEtvRnZjVTA2cTQrQTBHbEc3TWdCQm9USFoy?=
 =?utf-8?B?Nmw2N29mUndpVFBlUGxhRjEyREp3MWF2eDhhc0svTlY3VnhOd0FQU1F0aGto?=
 =?utf-8?B?a2V5ZzNZaXFFL2Y3YS90YUt6ejZyVmlkZGpRVlpmS1FVb3A2aS95UEJ3cVFO?=
 =?utf-8?B?RFdRWkkvSW42Q0hrQmpJa1BrZVJxVHQvdGkxMlpqK1c3cnQ4eXJyK2lxREJo?=
 =?utf-8?B?TnkvUVovaTd6YzBHVDJqY3N5U3ZIaGRJV3pCL3Q1WlAwTHBhYlVuQ0RGc203?=
 =?utf-8?B?VE9nTHBoa1NXTnR0OVJDcjdKbTBBa2FsSHhjVmtZcVJ1a01rUUhFZ1VOSUdK?=
 =?utf-8?B?Q2NmK0s1VE8zdDdzdFI4TEZ3Z08zM0tBQkhyUjgvdHlhRHBKbWk3d2N2d1Rq?=
 =?utf-8?B?N09TczdCMEliK0FlZVdMUzV3Q2N0UWdlcmg1dUZPYlZSamtSWHZQcDhDeWt4?=
 =?utf-8?B?eW53anNzVDFPRjAwWEticm0zWU1JNTJXbXl2TllzZFJxZlZUR25pbUpjZEZo?=
 =?utf-8?B?L1BBa3JRdHYxVVdjOFZXZUxIVWNPSmR4UUNVdkJxamZSVCtuOGYySSthNzg0?=
 =?utf-8?B?ZTBPQjZreWd3eW1WTldtZGE5Qi9WUE42QzRSWVN1TFlNb2J3eFcyUEZoSHNB?=
 =?utf-8?B?V2lHMUpQeTNjQzBseEppTXdnM2I3WVNiUkpnakRmbkVPTEpmejcycHM1aThK?=
 =?utf-8?B?TXhPYWdpVmxQVHE4eVlQOXpseHpBN0F2dWh2TjNmcWJUYjd0WlBWTkY3RTBa?=
 =?utf-8?B?bnJPa01rbTE2eWdFaGMzeitLUWhMMUkxNXRVV292NTdib3BLZWV6UktiZTVs?=
 =?utf-8?B?Sk9jMitPa09BTElmVEs0blIrbDM3WjRudVNMSnpFbUx0bzZXTVpFNUpoV1BP?=
 =?utf-8?B?dlFCQmEzVGx4K0dUSGErZzY5NUJiU3hRcUFnYTN5Z3hoWDVvYTI5alRTU3c2?=
 =?utf-8?B?SEJGWERKejBHeEVnL1RYejRNdHFmSTNXM094b2x3Sm9aS2ZoYlNSU1RQZ0Fj?=
 =?utf-8?B?RXFzRzRqLzJ3KzJJWi9KYVI1b3dQbEd0TXh1VnM3bHJuNTM5dHZ0cnZVdW93?=
 =?utf-8?B?eVFXcmEydUZoOTE2YzluTGxrQlBydWxXWi95M2JWNmZCbk1ZaC9MWXJaUXFj?=
 =?utf-8?B?NjNOQXkyZTFSMUpLeW4vK0RWM2xHV1lyTEovOXlJcXA2QmxjdjlZbUhiTVhX?=
 =?utf-8?B?YndKaUFXc2ZOcEhKbW9KVWIrVUlqbVk3ZGlDWnR3T3V0U2hxYldKd3Q5a1BR?=
 =?utf-8?B?SnJJQjdSSVBYVGxPL3Q4akJRUXpmNklMWGlIb0QxUTFuM095ZktqaUhQdDZX?=
 =?utf-8?B?VUdrZkVram05QWFaWlV6dFBDUHVnV3BBQk8vV2g4Mi9ORVdndnR2RUhpRmxx?=
 =?utf-8?B?bEJiR2JLYjNXMitoK3pYNExweEloZ3Zrc3lyMHNmWlh1MDBiM1UrSWx3a3Ey?=
 =?utf-8?B?NmpOOTdxSElrLzRHVnR1cGtYZzl4ZzFUSTNYL3JFNG5WVE1jeTZGSVhldk4v?=
 =?utf-8?B?NWJseGw1Tmx1ZEI5aWUrQ3JSc0FSZFd3VzBCNVpwcEhTdVhqQ2VvS3NBSUUw?=
 =?utf-8?B?TTdsSGYwMUZMaDQraTRYdW5qWnM2WTA5aDNsS1VJSHdIT1BRbEFPSjZCM2pG?=
 =?utf-8?Q?HcyGZuzw8kBoEVbg=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f49fbc37-03cb-4ecc-44ca-08da39b6f847
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 16:45:24.0160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hVa3h8sEY8sJaTKbdJ8gzBZY5g6qTpzi4GxZp0CbQpalj0ZRg8YmqoTZlTtECuIV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1932
X-Proofpoint-GUID: vBIB075y-84RjfD3qIok4FMFUrOTFr1J
X-Proofpoint-ORIG-GUID: vBIB075y-84RjfD3qIok4FMFUrOTFr1J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-19_05,2022-05-19_03,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/18/22 8:12 PM, Feng Zhou wrote:
> 在 2022/5/19 上午4:39, Yonghong Song 写道:
>>
>>
>> On 5/17/22 11:57 PM, Feng Zhou wrote:
>>> 在 2022/5/18 下午2:32, Alexei Starovoitov 写道:
>>>> On Tue, May 17, 2022 at 11:27 PM Feng zhou 
>>>> <zhoufeng.zf@bytedance.com> wrote:
>>>>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>>>>
>>>>> We encountered bad case on big system with 96 CPUs that
>>>>> alloc_htab_elem() would last for 1ms. The reason is that after the
>>>>> prealloc hashtab has no free elems, when trying to update, it will 
>>>>> still
>>>>> grab spin_locks of all cpus. If there are multiple update users, the
>>>>> competition is very serious.
>>>>>
>>>>> So this patch add is_empty in pcpu_freelist_head to check freelist
>>>>> having free or not. If having, grab spin_lock, or check next cpu's
>>>>> freelist.
>>>>>
>>>>> Before patch: hash_map performance
>>>>> ./map_perf_test 1
>>
>> could you explain what parameter '1' means here?
> 
> This code is here:
> samples/bpf/map_perf_test_user.c
> samples/bpf/map_perf_test_kern.c
> parameter '1' means testcase flag, test hash_map's performance
> parameter '2048' means test hash_map's performance when free=0.
> testcase flag '2048' is added by myself to reproduce the problem 
> phenomenon.
> 
>>
>>>>> 0:hash_map_perf pre-alloc 975345 events per sec
>>>>> 4:hash_map_perf pre-alloc 855367 events per sec
>>>>> 12:hash_map_perf pre-alloc 860862 events per sec
>>>>> 8:hash_map_perf pre-alloc 849561 events per sec
>>>>> 3:hash_map_perf pre-alloc 849074 events per sec
>>>>> 6:hash_map_perf pre-alloc 847120 events per sec
>>>>> 10:hash_map_perf pre-alloc 845047 events per sec
>>>>> 5:hash_map_perf pre-alloc 841266 events per sec
>>>>> 14:hash_map_perf pre-alloc 849740 events per sec
>>>>> 2:hash_map_perf pre-alloc 839598 events per sec
>>>>> 9:hash_map_perf pre-alloc 838695 events per sec
>>>>> 11:hash_map_perf pre-alloc 845390 events per sec
>>>>> 7:hash_map_perf pre-alloc 834865 events per sec
>>>>> 13:hash_map_perf pre-alloc 842619 events per sec
>>>>> 1:hash_map_perf pre-alloc 804231 events per sec
>>>>> 15:hash_map_perf pre-alloc 795314 events per sec
>>>>>
>>>>> hash_map the worst: no free
>>>>> ./map_perf_test 2048
>>>>> 6:worse hash_map_perf pre-alloc 28628 events per sec
>>>>> 5:worse hash_map_perf pre-alloc 28553 events per sec
>>>>> 11:worse hash_map_perf pre-alloc 28543 events per sec
>>>>> 3:worse hash_map_perf pre-alloc 28444 events per sec
>>>>> 1:worse hash_map_perf pre-alloc 28418 events per sec
>>>>> 7:worse hash_map_perf pre-alloc 28427 events per sec
>>>>> 13:worse hash_map_perf pre-alloc 28330 events per sec
>>>>> 14:worse hash_map_perf pre-alloc 28263 events per sec
>>>>> 9:worse hash_map_perf pre-alloc 28211 events per sec
>>>>> 15:worse hash_map_perf pre-alloc 28193 events per sec
>>>>> 12:worse hash_map_perf pre-alloc 28190 events per sec
>>>>> 10:worse hash_map_perf pre-alloc 28129 events per sec
>>>>> 8:worse hash_map_perf pre-alloc 28116 events per sec
>>>>> 4:worse hash_map_perf pre-alloc 27906 events per sec
>>>>> 2:worse hash_map_perf pre-alloc 27801 events per sec
>>>>> 0:worse hash_map_perf pre-alloc 27416 events per sec
>>>>> 3:worse hash_map_perf pre-alloc 28188 events per sec
>>>>>
>>>>> ftrace trace
>>>>>
>>>>> 0)               |  htab_map_update_elem() {
>>>>> 0)   0.198 us    |    migrate_disable();
>>>>> 0)               |    _raw_spin_lock_irqsave() {
>>>>> 0)   0.157 us    |      preempt_count_add();
>>>>> 0)   0.538 us    |    }
>>>>> 0)   0.260 us    |    lookup_elem_raw();
>>>>> 0)               |    alloc_htab_elem() {
>>>>> 0)               |      __pcpu_freelist_pop() {
>>>>> 0)               |        _raw_spin_lock() {
>>>>> 0)   0.152 us    |          preempt_count_add();
>>>>> 0)   0.352 us    | native_queued_spin_lock_slowpath();
>>>>> 0)   1.065 us    |        }
>>>>>                   |        ...
>>>>> 0)               |        _raw_spin_unlock() {
>>>>> 0)   0.254 us    |          preempt_count_sub();
>>>>> 0)   0.555 us    |        }
>>>>> 0) + 25.188 us   |      }
>>>>> 0) + 25.486 us   |    }
>>>>> 0)               |    _raw_spin_unlock_irqrestore() {
>>>>> 0)   0.155 us    |      preempt_count_sub();
>>>>> 0)   0.454 us    |    }
>>>>> 0)   0.148 us    |    migrate_enable();
>>>>> 0) + 28.439 us   |  }
>>>>>
>>>>> The test machine is 16C, trying to get spin_lock 17 times, in addition
>>>>> to 16c, there is an extralist.
>>>> Is this with small max_entries and a large number of cpus?
>>>>
>>>> If so, probably better to fix would be to artificially
>>>> bump max_entries to be 4x of num_cpus.
>>>> Racy is_empty check still wastes the loop.
>>>
>>> This hash_map worst testcase with 16 CPUs, map's max_entries is 1000.
>>>
>>> This is the test case I constructed, it is to fill the map on 
>>> purpose, and then
>>>
>>> continue to update, just to reproduce the problem phenomenon.
>>>
>>> The bad case we encountered with 96 CPUs, map's max_entries is 10240.
>>
>> For such cases, most likely the map is *almost* full. What is the 
>> performance if we increase map size, e.g., from 10240 to 16K(16192)?
> 
> Yes, increasing max_entries can temporarily solve this problem, but when 
> 16k is used up,
> it will still encounter this problem. This patch is to try to fix this 
> corner case.

Okay, if I understand correctly, in your use case, you have lots of 
different keys and your intention is NOT to capture all the keys in
the hash table. So given a hash table, it is possible that the hash
will become full even if you increase the hashtable size.

Maybe you will occasionally delete some keys which will free some
space but the space will be quickly occupied by the new updates.

For such cases, yes, check whether the free list is empty or not
before taking the lock should be helpful. But I am wondering
what is the rationale behind your use case.
