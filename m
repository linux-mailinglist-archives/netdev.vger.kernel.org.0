Return-Path: <netdev+bounces-5231-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D2B071055C
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 07:38:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3C091C20EAA
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:37:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DEE0881F;
	Thu, 25 May 2023 05:37:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC32E6FBF;
	Thu, 25 May 2023 05:37:54 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7C6D8;
	Wed, 24 May 2023 22:37:52 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34P3S3BT026206;
	Wed, 24 May 2023 22:37:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=SLhUrRatyzmJDBMG4fyWFhqyWzIqbULwv2mAXqpfuzw=;
 b=arrfskI7wFATRZmNuKigz2Rb6jY/GIzUJU3MF/mb6Cqb45cejhLpaQKHILmGvKkZ/6rw
 LAGjV3DaCOWYJNesoHn9uIZzqGZMONZ5kxh4mA/etC1uIazJNPN3AxZbhrV1IafSY3tK
 DE668tMxX8EztTnfxYlFWqlKf29rxJEhZBC99GqJY2Mk4c8zNiVTvLu9Iz55SJHOHahm
 j4pMqL5C67gTC4nmqTfT8Tz1wVyIHh2uSL4JBwoYOZw39KcZjdVvEPpwk2DAwk4AGjrE
 Hb2GIp3WjlNNio9wg+f5TFnLZvTCcj4sM3KvWLEV9GhFOGqaN3FASQR8Fb5p8S+f7Mla yA== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qsystrjsh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 May 2023 22:37:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXaGIVGHbbZL4OnT+FPZXHI5RHWgnqmbsKp8xEK9Rbt1xYBfJogr4fDbcYBzVbTZUHmSIqRVxwKyIYFm2wCl8+mpKhfDx9XXKAimDIng5TakLGMZOToRzAXwRmmZ9fcgBStsSAQIdCrk0zGJcdupddzp7RRlBpdk+HYzZOVNxwpfxLENKvG48Pze63xGpcJegVRBADiX9BBLdxl8OIJyJc9IysDrnfwxbbug6HfbhIv4DeqnskjgiyUXuzZ6EXT+2RWHFOGlGiAfyVpIMf3MP+0a/cTMurJM/uJIrGgVtvUQ4Da4drKLwT8bHXQXVJXC80klQxaQyCV+a8gChSocxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SLhUrRatyzmJDBMG4fyWFhqyWzIqbULwv2mAXqpfuzw=;
 b=nem75E3XbVjGgMHwlAXeIS8Jrp2tp6W6dm3CPgBFwlmJRUnh5HTqu7afLZLOQMgDNg8cMKL0IIh4P8Mpp9f/54K/0Ron/1XDo8jsj4+A8cf6Krm7u9mWfRz0srDF/vLhQZsHWM0zpezqvUd3tl7VkoBWBYtFkksfFsHmDhdRFr5t4gGJV9Baj5/dkhydsX6fL1vL7/z0TkbqmgYThri19k0DA90cC8PC6A2e7ozydiv7rIem4J1QEmwuOFBHv3iy2B/DgfFEoHDT8rKcbnlOqcnBZ+hzEFSiNwT7wX2TRyCr8OMDGwIeK6jM1PjNHUNmoyNoimDH5U4KyVnwN6gqbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN7PR15MB5755.namprd15.prod.outlook.com (2603:10b6:806:349::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Thu, 25 May
 2023 05:37:30 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0%5]) with mapi id 15.20.6433.016; Thu, 25 May 2023
 05:37:29 +0000
Message-ID: <14c985d9-f5eb-e62d-e1a2-9d4c2b651151@meta.com>
Date: Wed, 24 May 2023 22:37:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [bug] kernel: bpf: syscall: a possible sleep-in-atomic bug in
 __bpf_prog_put()
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Teng Qi <starmiku1207184332@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau
 <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
References: <20230516111823.2103536-1-starmiku1207184332@gmail.com>
 <e37c0a65-a3f6-e2e6-c2ad-367db20253a0@meta.com>
 <CALyQVax8X63qekZVhvRTmZFFs+ucPKRkBB7UnRZk6Hu3ggi7Og@mail.gmail.com>
 <57dc6a0e-6ba9-e77c-80ac-6bb0a6e2650a@meta.com>
 <CALyQVazb=D1ejapiFdTnan6JbjFJA2q9ifhSsmF4OC9MDz3oAw@mail.gmail.com>
 <d027cb6b-e32c-36ad-3aba-9a7b1177f89f@meta.com>
 <CALyQVayW7e4FPbaMNNuOmYGYt5pcd47zsx2xVkrekEDaVm7H2g@mail.gmail.com>
 <113dc8c1-0840-9ee3-2840-28246731604c@meta.com>
 <CAADnVQ+5GXu8Q1_awiHExhBB9_LmGrcPTvjQEjQU58pzX3WbQQ@mail.gmail.com>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <CAADnVQ+5GXu8Q1_awiHExhBB9_LmGrcPTvjQEjQU58pzX3WbQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::31) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SN7PR15MB5755:EE_
X-MS-Office365-Filtering-Correlation-Id: f132175e-4c13-4e28-8118-08db5ce2215d
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	H6E7p9lcSedJFXuADkjKVynIGzdilpepya+hwvsWPykVRlo5XW6jnwfMaQdgYAD7zyjKKmu1etN1sPOc/UGV/0DhFQ+cYcpjHj9btW8Ng9SvCFp8y40fzSiasn7hPBh3uupwxuOVFJ9wO3HNf9XK0ZmTnfV6FIPjNQhbaRCy40XPaHtSyWTUTrVIbg7H/rkfwkS3zXgvAH739Xl0dJ+ORUG4VZ8/gDjdLquPOriuNy177bwO2gjTr49A2yMTSxzt8RMF+/vew61jEUV8+rYukfzbS3cHp5CydlbN0CkCi/N4eBivoUlrUDyBSbXYpbEZ7Mqi2huu/W4Vgd9wjoj5iBf1tzsdM1gZctfLL8bb5eVC6QxpwZm3PUMOBPCMQVcgbbB/3OVrV6iTorD+swoZq0hHt5t0pLusm1tT9ZK/ePZUL0xfVPYHyiwernHnSrxthAR1sy4IsrI1BT9cpTPnl37Mu4vNO3m35nC69hUbuT4PXXZzN2RTHCuIeeLcb65ULRp1l3cbRQAhPr+ILKtvireKOLZoXjZQboqrDsdgPG2XJcJHp+ctLmdnjpTL95fuEwLFKuK3bP3+44KhaIPZm+cbaoK1y7YRul8yAPyUAt47xhAgRBkkSANBKK6WPCbw28lbSrn+kdKCyRVRSFocGA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(39860400002)(376002)(366004)(451199021)(6666004)(478600001)(2616005)(83380400001)(86362001)(31696002)(38100700002)(6486002)(6506007)(36756003)(6512007)(186003)(53546011)(41300700001)(8936002)(316002)(8676002)(7416002)(31686004)(5660300002)(2906002)(54906003)(66946007)(66556008)(66476007)(4326008)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?YjNVNEN6MjJwM1RxbjhPTkRxSlFmdWJNazFFTHJpb3B6TktyUzdhd1VLTXFR?=
 =?utf-8?B?YnJWZXJhV3pBMWxFUUhiZVo0UHA0L2tIQXc3cTFHd3BGQjU2ZUIxMVlRajUv?=
 =?utf-8?B?RmJ5OHNHM3IxdGJwRkt3RVVjYWdxaVltOFo2TFNZRU1XaEx2QUVBZlB4eVRK?=
 =?utf-8?B?MUcrbEZPRUMxbDl4bXZjTHBWTFBYK0ZRampBSW9PdkRXelJKVWxqZE9WVFhY?=
 =?utf-8?B?Uy91T2FRcU9xRDczL2JKT21FbnVYRDVsUXBlNGpHaG44NkcrYmNoZWhEb3dS?=
 =?utf-8?B?d2ViakNqSTVTT2VnckFiYURnRE0zYzBzaWhKQXFsNWdGK3dHMjZQcGNJMStt?=
 =?utf-8?B?Z0hLMEZQZ1hvaFdSZjU5MnJic3ZQekpXZHFqc1NiMno2K1Q0UnVJWWNMaWI1?=
 =?utf-8?B?UmdvMSthWGhTdjlPZlFqSUpvelN4UGRtT3h0T1ZlKzNHeUViN21JNVc5Y1JR?=
 =?utf-8?B?Qmwxclg0ZzhiRzVSRXJsbGxNNXZFRWcrb0JNVXlVbE9GUkdTU090WnA3VVpm?=
 =?utf-8?B?VE0rL1BmZEhoWTMwK3ZxbmNodVBlb1k1Z21GY1RFOThnMW5ybGc4QXFwVzFG?=
 =?utf-8?B?WHo1U0pxQkF4a0piZjJPdFhwWUFEcHE4dEt0bERpMENBZWltNjd2OXNlcm9z?=
 =?utf-8?B?ZDZ4TjRhTzBad2lXRnhQZG9rYkVUOTQ2M01lTjFlc1oybm04RkJOL0JmQWo5?=
 =?utf-8?B?V2VkZFJxU0JqNjcyaWM3MGpCVlV4K2c2Yktibmx0T3R1MFhCRmxOandnSU8v?=
 =?utf-8?B?ZERibzVOcmN2amtlVVZMQTNGVHF6ZWdQQ1hIWjZiUnl1MWYreU9GNkdmaUhD?=
 =?utf-8?B?YVJadEFzNndJU3pOZlZ6ME90dWZFNWpJZlJsK1laeDFXVzNUYnRnUXhSdXU4?=
 =?utf-8?B?Q2ZEOVE3M2h4Y0dKSXU4T2loVG43Y1djdjBEWTRpc3dMQmgvd2hXR0NPQkFP?=
 =?utf-8?B?Q1JnaiszalQ1THZPTTk2aTQ1VVk2cmlLSWFjT2I5aUtvLzg5RHp4RlZhMzZa?=
 =?utf-8?B?eitrb0I5WWJBSUNiNitZWmhsSG1qYkxGQW9VU1prckJaNWkyYlMrbnRFbVJn?=
 =?utf-8?B?S2JEOG56dCs4ZVZROGhCK2w3ampHTS9xZHZvZTdDcUZsRTVoM1oxdXVYYWhO?=
 =?utf-8?B?ZGtDb1lmaHV5bnlLdGRjdTg1R2kySDVSV0hQcE5BaHNsUzRydGJ4cUdWOFps?=
 =?utf-8?B?YzJWZVN0SHhwOTJFZ3ppSjFDY2ErMDM2NUR4UkNNdlhpa2Z3TkVyY1lhVkdm?=
 =?utf-8?B?aEJGZVJNMFYvbERUYzhlR3IyWW5FWVlqSUNwcjMxbktmb2hLVHRuQUEyRjdM?=
 =?utf-8?B?Sm9jakZxeTQySEF2T3BmL2tvN2tLRldSNncrQWZZRURkTEU1MmVIUzBkVEp0?=
 =?utf-8?B?WFdwMlpZcXhOaUJ2ZTBpSEtJWlYwQkgyWTJIMVRHSzVwTHZZV2xVRFd0dWhr?=
 =?utf-8?B?ZnpOTWRGTzJ5Y2Y3amFFVEdzeCswZHBoblFNY0NtU3d6dkFzT2s0dFJHZk5M?=
 =?utf-8?B?TngwKytJL0tNNHJMQTVDMkRsMjBORVdtQ21uZlhSZFBZcXYzM0EzQUhCODFq?=
 =?utf-8?B?QVZlS0pSRDdMTTlQZjhPK2t3MitGWnJ0S21UTzdBcWFEWEZiQ3JDWnRsV2N6?=
 =?utf-8?B?SHRoSkE1bmEyc3pITlRjSFBSNWxFbkplLytDNmxDOUg1aGhpWVFIZlp1YmtC?=
 =?utf-8?B?a0V0QkV5QlA4N0syWlRjdEZuZGtYTC9YY01wdzhzWjF5Q3I1Z0c5alZSa1Vp?=
 =?utf-8?B?SkI5eFFuYjBXWHJreEJISDRGYWhXYVN4aFkvLzFpd3FrMFlJYmZYWWJId0hu?=
 =?utf-8?B?bXJ6L0pYbVNwWXN3cUpBNCtpYmNhbTJlR2pHT1l4RC9ma3dQSy8remRFK2Q5?=
 =?utf-8?B?MmNOYjVXVmpDNXMwVlVicE1DMzhOOTA5R1FWL1FweFpMQ3cxMG54bDdmWlRu?=
 =?utf-8?B?R2JGUjhBaEpXTTFnSzg2a2E4d0prbjFRUE9hTXg2ZUNoR2g0dVdsSEZqOGh4?=
 =?utf-8?B?bUVaWEtaYTFtZ3U1YTJhTlBkSFB0OHFSYjdWNVZ6dmtHVkpIb2l4WUxIRGx5?=
 =?utf-8?B?MDlvL044MlhjUW5VMUNEWWdlU1Rtb1NYeTN1R0JYYzc4cG9UbFBNRmZLL0dO?=
 =?utf-8?B?b08rakJuOUFtOGpCbGlTVktsUHQzdXFaOTEwVWFGUlE2bkx4US84MlIzblNF?=
 =?utf-8?B?VWc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f132175e-4c13-4e28-8118-08db5ce2215d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 05:37:29.6528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6bxR//YtOjljW074qAo80KAtZqQO1XBkIVDMuTK0LEsS/Oft2Br7zBiFrHJmW86+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB5755
X-Proofpoint-ORIG-GUID: zaeTx5SstPERQN6PRwZJJxy_0rZ0PMx0
X-Proofpoint-GUID: zaeTx5SstPERQN6PRwZJJxy_0rZ0PMx0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-25_02,2023-05-24_01,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/24/23 12:44 PM, Alexei Starovoitov wrote:
> On Wed, May 24, 2023 at 12:34 PM Yonghong Song <yhs@meta.com> wrote:
>>
>>
>>
>> On 5/24/23 5:42 AM, Teng Qi wrote:
>>> Thank you.
>>>
>>>> We cannot use rcu_read_lock_held() in the 'if' statement. The return
>>>> value rcu_read_lock_held() could be 1 for some configurations regardless
>>>> whether rcu_read_lock() is really held or not. In most cases,
>>>> rcu_read_lock_held() is used in issuing potential warnings.
>>>> Maybe there are other ways to record whether rcu_read_lock() is held or not?
>>>
>>> Sorry. I was not aware of the dependency of configurations of
>>> rcu_read_lock_held().
>>>
>>>> If we cannot resolve rcu_read_lock() presence issue, maybe the condition
>>>> can be !in_interrupt(), so any process-context will go to a workqueue.
>>>
>>> I agree that using !in_interrupt() as a condition is an acceptable solution.
>>
>> This should work although it could be conservative.
>>
>>>
>>>> Alternatively, we could have another solution. We could add another
>>>> function e.g., bpf_prog_put_rcu(), which indicates that bpf_prog_put()
>>>> will be done in rcu context.
>>>
>>> Implementing a new function like bpf_prog_put_rcu() is a solution that involves
>>> more significant changes.
>>
>> Maybe we can change signature of bpf_prog_put instead? Like
>>      void bpf_prog_put(struct bpf_prog *prog, bool in_rcu)
>> and inside bpf_prog_put we can add
>>      WARN_ON_ONCE(in_rcu && !bpf_rcu_lock_held());
> 
> bpf_rcu_lock_held() is used for different cases.

Sorry, I actually mean rcu_read_lock_held() ...

> 
> Here s/in_irq/in_interrupt/ inside bpf_prog_put() is enough
> to address this theoretical issue.

Maybe

                 if (!in_interrupt()) {
                         INIT_WORK(&aux->work, bpf_prog_put_deferred);
                         schedule_work(&aux->work);
                 } else {
                         bpf_prog_put_deferred(&aux->work);
                 }
?

Basically for any process context, use a work queue since
we have no idea whether rcu_read_lock() is held or not.
In process context, is_atmoc() and irqs_disabled() should
already use the work queue.
As we discussed in the above, if in_interrupt() is true,
kvfree seems okay, so can directly call
bpf_prog_put_deferred().
Does this sound reasonable?

