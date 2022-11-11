Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12002625E16
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 16:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbiKKPR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 10:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbiKKPQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 10:16:28 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13481FCE6;
        Fri, 11 Nov 2022 07:15:53 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2AANDgM4019770;
        Fri, 11 Nov 2022 07:15:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=SQlSl51WgYG7oZNFFfPJh2msLJSU0Pka7kNccbLlY9E=;
 b=UUdJrmJjiDOmfGqR7G+A+w3lLiTEnlIfijoXm1BS4Or9xdK9tAxnYUC/hTDN7x8rzh1C
 IxBb3YGTJYSLpd7lvYAEoA65BzG/mZBCH8yTDglrRJsGFRai8KEW+KHNi+aHm50uqEwB
 Itv0jwB4Sj57hdCHmoDIrEJvj/T+BUmqWt6A7wwM3AhRjg2wHoAVm9ej5taawFi77jFs
 lkeYWJ7JZsQSclgOVzyLywiNWm6THt7SAaPdmjDA6mNiI8Vhjfwdo97R/KbXy++ZkmoS
 EwrX7BefvOZH8KRZVPi2Ov3Dki/s0+7EY4X1OSwXWI9tNFcGLXOdyNbBOXo0xEPChYZv lQ== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by m0001303.ppops.net (PPS) with ESMTPS id 3ksasecw8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 07:15:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f4RmpYpUHjXYlSuTXOf7qaNtyqA7JCo8JBZ+y+rppqjuEiqZ2M/N/6DLtZEDMkjgr/EaQ8EPNzMbZtO/clQYfSyPv3h+pxqiJ1GZ275go3tpC/HhknZqI6B3Tr1tGwvIzlpga+yDKlppDo/zBeHSt2CmA65CkRb7pwesdzYedhdcUWMLZxz32K+lfwxfRuNOuSYG31boxgjYOmnN3uecTmBaGQxmPQk0hdLFWmRlWvJtZjH2AG76rEaHvgaq9F5XGeB3zifkfomM5nzq/giUttAjJfMO5o0d820AHXNcPWsncKCnklPfffOL7Vxs1zwbrNB+YlaSnVK/xKz+OxsYXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SQlSl51WgYG7oZNFFfPJh2msLJSU0Pka7kNccbLlY9E=;
 b=U9rGnitby9ST6zeidh26sATKWIh4rc5gFsy6s/BBSquwKkakqcNRnZcJAP19zTQN3HbaZDAYA/2kxRg6hiXQtbH2eqtxDMaDAW4oUAaS6yTD+PALH8kzbdSFSLMzVNCuNHOF4Z4GfPSut6wM5MYnBGp1MFrJ+R6HPTtG0+Q9b2mJJXF1YAotAGYKqzHRS1whI7SysX4cd89UbKueMvX1dglCguvOVDL1q1Qc6n3h73bMuEmYD5iRXyJuIu6y4zPSC2Myy1qgxn6qvHo4HHTkk2z6lRu3gbD9hDEMqYHUiqQ6w9qNR1KKS2BpjDTCJiAbkDx1dnSq9Gfk7MUlAYAYtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM6PR15MB3878.namprd15.prod.outlook.com (2603:10b6:5:2b8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Fri, 11 Nov
 2022 15:15:30 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::ac66:fb37:a598:8519]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::ac66:fb37:a598:8519%7]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 15:15:29 +0000
Message-ID: <8c569ff6-dadc-18a2-69f2-8450c818dafc@meta.com>
Date:   Fri, 11 Nov 2022 07:15:27 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [1/2 bpf-next] bpf: expose net_device from xdp for metadata
Content-Language: en-US
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@kernel.org>,
        hawk@kernel.org, daniel@iogearbox.net, kuba@kernel.org,
        davem@davemloft.net, ast@kernel.org
Cc:     brouer@redhat.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        sdf@google.com
References: <20221109215242.1279993-1-john.fastabend@gmail.com>
 <20221109215242.1279993-2-john.fastabend@gmail.com>
 <0697cf41-eaa0-0181-b5c0-7691cb316733@meta.com>
 <636c5f21d82c1_13fe5e208e9@john.notmuch> <87cz9vyo40.fsf@toke.dk>
 <636d2e8c5a010_145693208c8@john.notmuch>
 <64461cc5-c9b5-1a0e-dc9d-ddb49fc7a5b2@redhat.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <64461cc5-c9b5-1a0e-dc9d-ddb49fc7a5b2@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR05CA0170.namprd05.prod.outlook.com
 (2603:10b6:a03:339::25) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|DM6PR15MB3878:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d83e6d8-e1b4-4285-3c26-08dac3f791de
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZIMwsE34+o0XO2fb3q7a9IzWivUrmFrO9ZYyMC6uqV7TDdKmpQyWsWU/ylNmTinPxbcPc8gt8Wym0TqDmH3KdQfJ5LtFASsVrQ5rEkRtOyz0pNgLXSqG644kndRlmjIT9IIPuHEGpKNNszw8G9IbjtTKwrUksdjhE4eLl2YH8kjOwWU8ikqwV71IiLNg8o0sbE416dtl9uWnbShLp+rdzfrwDWZjjxwZ7a0TrzqEyhWitc3ZFRgYZ08YEmyYXH5B8D1TYg83aEGA7mTJqx7mGpFlgPuNAoaBp0wpTkQoOF1Bqw6KSYQMkrBDTWDOrWisLbCYorTpXzTl7FHXjmXVOMnNh09kc9EK7e6XbKw6BLwcRD3DL5xdljiR+GiXHcEzaHxUPHM7BmKyPnzyTMwWINo68uCSA41Kx+30BL9mw+Zt6HMatjmPpjldOSw0/0X/RHFA8i+8/G9VYpmwx7frgkb5sKhaGcVmMIY6Ooltw9rC8oAkcRJ+vIPOoLKoxxn8pwlYdQFWuVCTnyJR8V7BctgL+DKscOHrWCLD68H58EDKvl2otLvyarfjf7ZCStlenhWr+RW3ighpi+raatpIw9d48PssIf3+/Dzy0gdz4b4nnCh5SYW4dCP540dCLN55JCs474AcZVgAmz/5xWJ9e+V1wMVcb2rj1PrbsnGaeql+fI+3lO+qtrtenS2WWo5YQkNUCrECOMAOzu6xg74Dh4OOZ+2P9lNYBk3LY0FPdPgmLvsorf92zNMkakMeovNGlId9InzYWgPoKWpwWa2zyPKUX7Uze2ZD+/s3e8TdPSdAlNO187RIwmmbB9AB+3k3oeH0Yx45j1QqiYjxkAX9GtZFjB0Q5A4CX1N+5wjPoyw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199015)(31686004)(31696002)(38100700002)(86362001)(6486002)(478600001)(110136005)(966005)(6506007)(53546011)(66574015)(2906002)(316002)(6512007)(66476007)(4326008)(66946007)(66556008)(8676002)(2616005)(41300700001)(36756003)(8936002)(5660300002)(7416002)(186003)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnBXVSszbjlLN3Y2SFE1VVFDV1dYNWZIWGEzVExqY0p0V1BqeXdTRjJ3Umd6?=
 =?utf-8?B?Q0NhQjlLZXpJRTVYanF5UTdSWjZNMUtOQnNZZzRtZ2ZSS1V0YXZERnJVSkRt?=
 =?utf-8?B?Wk92OFpLR0tFNWZKejdaczNwM2J3ZVBqZnRLdVFzNFhlVVBKSlMwYWZNVWhC?=
 =?utf-8?B?WEpBa0k5QnIzUitqaTU4MFo5RjlQR0pxcTdUaG01MzBQbmNiYXFxaXJJSDQ4?=
 =?utf-8?B?dEN1YU9zR2ZGckhvbC9wZ2l0ZUwxMVVuNnpFbDNYSmJvWElKejR0NmNMYU5X?=
 =?utf-8?B?NjRMcCtKU3dtOUZTSnR2RDRrMFNrOThNODZGeWxVRzgzOXpmWE04OG1mYjFt?=
 =?utf-8?B?Rlk0QTU4QXpJZkJjTVhIY3ppYUpLcFNYQ0xpK0x2QlhIZzhreW9wL1JLalB4?=
 =?utf-8?B?UzJBbGhOQ3pZTDlIM0xudnV2MWc2Q0RYTGcyYnBidFkyM3Qwc2pEQWlIU2dq?=
 =?utf-8?B?TFhON1B4dXpWOWI1aWZqTW8zaFZkaEIwa0xUZEFwV1BLZ1lTVmg2emRKZHBm?=
 =?utf-8?B?T1dYZzgrL0c3ZEFSeDBaK1RaelV2Q2RITjY2QmhBbVlaK0x4M3JOUCtYQlFP?=
 =?utf-8?B?VGVUTGlzTE9ldmlKdktXL1VEd1pwMVhJcEVwajFGZU1rUTBPc0ZtVi9yZGox?=
 =?utf-8?B?TFNtd1crMkpQM2RsRDJCRi8wQXQ3aHBmQWd4UkQ4SzBqcnZSeW52MEllYTF2?=
 =?utf-8?B?MnFvdHltK0h1OHVHd3hIQUZKbVMrS2FaQjNtcXBnQ1g3bmgrQnVSeVV6aFgz?=
 =?utf-8?B?b2F6dWVqNUlRS1IzcW1pbEpTTXhBUmoyWlZrcUpvdnZ5a0toOUIvU0h2N3hP?=
 =?utf-8?B?Ri9QWmlLTDd4SzFxbUVDZ2RPdVpWWFM5dzRQNmlmTjNTdTdsTHZwUTJGWmNo?=
 =?utf-8?B?OE1ZOUp0VDI4TTJvRkhpODlXdDRqTmlBODk0NFBUYkVEaUpWcmVWWTJMaVgy?=
 =?utf-8?B?QUdRY0g4U3VLRHFIWlNXa1JqYVdLWnIxYmhwZHNMRmNLdTBrazllV01hb2Nh?=
 =?utf-8?B?anJnOUlCYk10d3d0cXBHZk5rcGpHVHBudHNPeGtRZHR4RjRCTUMxdnYrcXFu?=
 =?utf-8?B?bkUvcDVCczJRdnZuZEdPUzF2Qmd5WmpVeVRJNi9sT0dqT3VoWU9laXFmQlp4?=
 =?utf-8?B?NmhFMXhnMEZDMzRLWThwbTRuRUpkbFJrUFV1MmZ0UWlVUnkxMWFTajZSUHA4?=
 =?utf-8?B?aUNOdXJGZW1RZW9xZ21tdTBvdUwyYk1ZL3NmY2JCT2R1QmFiMDBydVFIanR5?=
 =?utf-8?B?MTZNNFl6RE9jOUpnMUxVQm1ZbE1WY1J4eDFLSnAza3dSL2tLdGU1MEFKMHRQ?=
 =?utf-8?B?bGtYNklucWtkZE1ES1phUlRvRU53TGlDM1VUVUlPUis3b0I2RGxzdStOcHlM?=
 =?utf-8?B?ODEyTC9FcGJxcksrMzlnMWVRL29zbDVGMGMzQUZCZ2E1Z2JabVNGUkk2eXZM?=
 =?utf-8?B?MU5hazY4WXJWRkxIaVJLOVJoY2M5WnRHbG1EMldrK2lBblozdzRhQ29zeThW?=
 =?utf-8?B?ZEtkSXdPZElSUDMyZGoxWXpIMGlpeTdCTnhySlI4b2V4Rml6bEVCY2w3WWtw?=
 =?utf-8?B?ZGdGdHJVVCtGUmZ5bXVhWUpyYSswc3cvdWxjWkFmSjcvMnZHYjVKL0trcnR2?=
 =?utf-8?B?VUhOZ2JqbXhhRC92NkUvS3F1VlM4Zzk0VEQyNHRPNGVyem0zZTNYUFFRSmFN?=
 =?utf-8?B?dnprOTFIR2JjQmRLZkVwQkxoMlYyUUEzbnY0WDNrb1ZZMmEzajBNMzBTbHB3?=
 =?utf-8?B?NFhYZkV1dk9xZkRXUjc2cUt4TUpVMWxUdnNETTRhT3Z1aEM2RXNPZXN3TWE5?=
 =?utf-8?B?NU5oNHZJbXVUaWlaZjB1MUtoVWQvSUtHc1BsMjV6NjNwTWhtdGoxUUFDQlBw?=
 =?utf-8?B?T2NYMnVjWjc3WlppOS8xSDMrOE5Ib0hzdjlGRFk3UkwycTZtSDJIQ3A0ZTFZ?=
 =?utf-8?B?QktCLzdGQTBuMDdROGJWSzFZSkp6c3ZUTXNmWXFQRGY5bUpDUk1rNmNpaWdF?=
 =?utf-8?B?aG5wRHFmRW9QMUhmTy9yOW53aGY1VGcyaGJOSzhUVnZlNEV2a3M5NzFZY0Fu?=
 =?utf-8?B?amN3SFJ4dFplY0IrRWl6TlllLzlNU1oyU2ZiRGZlQlV0alBWeVlndjMybmd6?=
 =?utf-8?B?L0VHMVVVenhUc0pDVDQ4ODlBTkpxakZFVHVpRkZIOVhsQmRJa2xoZWRrcVJI?=
 =?utf-8?B?bmc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d83e6d8-e1b4-4285-3c26-08dac3f791de
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 15:15:29.9351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UfTfZjqMhKn/jPi+mMoy8MiNFkDxf3Lk7VXYlXTV0wvgfYW5D+cWEOdTFKceABwp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3878
X-Proofpoint-GUID: wdT9pFk2vryD8Jvn1ysBXn-zwsqSBUbU
X-Proofpoint-ORIG-GUID: wdT9pFk2vryD8Jvn1ysBXn-zwsqSBUbU
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_08,2022-11-11_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/11/22 2:51 AM, Jesper Dangaard Brouer wrote:
> 
> 
> On 10/11/2022 18.02, John Fastabend wrote:
>> Toke Høiland-Jørgensen wrote:
>>> John Fastabend <john.fastabend@gmail.com> writes:
>>>
>>>> Yonghong Song wrote:
>>>>>
>>>>>
>>>>> On 11/9/22 1:52 PM, John Fastabend wrote:
>>>>>> Allow xdp progs to read the net_device structure. Its useful to 
>>>>>> extract
>>>>>> info from the dev itself. Currently, our tracing tooling uses kprobes
>>>>>> to capture statistics and information about running net devices. 
>>>>>> We use
>>>>>> kprobes instead of other hooks tc/xdp because we need to collect
>>>>>> information about the interface not exposed through the xdp_md 
>>>>>> structures.
>>>>>> This has some down sides that we want to avoid by moving these 
>>>>>> into the
>>>>>> XDP hook itself. First, placing the kprobes in a generic function in
>>>>>> the kernel is after XDP so we miss redirects and such done by the
>>>>>> XDP networking program. And its needless overhead because we are
>>>>>> already paying the cost for calling the XDP program, calling yet
>>>>>> another prog is a waste. Better to do everything in one hook from
>>>>>> performance side.
>>>>>>
>>>>>> Of course we could one-off each one of these fields, but that would
>>>>>> explode the xdp_md struct and then require writing convert_ctx_access
>>>>>> writers for each field. By using BTF we avoid writing field specific
>>>>>> convertion logic, BTF just knows how to read the fields, we don't
>>>>>> have to add many fields to xdp_md, and I don't have to get every
>>>>>> field we will use in the future correct.
>>>>>>
>>>>>> For reference current examples in our code base use the ifindex,
>>>>>> ifname, qdisc stats, net_ns fields, among others. With this
>>>>>> patch we can now do the following,
>>>>>>
>>>>>>           dev = ctx->rx_dev;
>>>>>>           net = dev->nd_net.net;
>>>>>>
>>>>>>     uid.ifindex = dev->ifindex;
>>>>>>     memcpy(uid.ifname, dev->ifname, NAME);
>>>>>>           if (net)
>>>>>>         uid.inum = net->ns.inum;
>>>>>>
>>>>>> to report the name, index and ns.inum which identifies an
>>>>>> interface in our system.
>>>>>
>>>>> In
>>>>> https://lore.kernel.org/bpf/ad15b398-9069-4a0e-48cb-4bb651ec3088@meta.com/
>>>>> Namhyung Kim wanted to access new perf data with a helper.
>>>>> I proposed a helper bpf_get_kern_ctx() which will get
>>>>> the kernel ctx struct from which the actual perf data
>>>>> can be retrieved. The interface looks like
>>>>>     void *bpf_get_kern_ctx(void *)
>>>>> the input parameter needs to be a PTR_TO_CTX and
>>>>> the verifer is able to return the corresponding kernel
>>>>> ctx struct based on program type.
>>>>>
>>>>> The following is really hacked demonstration with
>>>>> some of change coming from my bpf_rcu_read_lock()
>>>>> patch set 
>>>>> https://lore.kernel.org/bpf/20221109211944.3213817-1-yhs@fb.com/
>>>>>
>>>>> I modified your test to utilize the
>>>>> bpf_get_kern_ctx() helper in your test_xdp_md.c.
>>>>>
>>>>> With this single helper, we can cover the above perf
>>>>> data use case and your use case and maybe others
>>>>> to avoid new UAPI changes.
>>>>
>>>> hmm I like the idea of just accessing the xdp_buff directly
>>>> instead of adding more fields. I'm less convinced of the
>>>> kfunc approach. What about a terminating field *self in the
>>>> xdp_md. Then we can use existing convert_ctx_access to make
>>>> it BPF inlined and no verifier changes needed.
>>>>
>>>> Something like this quickly typed up and not compiled, but
>>>> I think shows what I'm thinking.
>>>>
>>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>>> index 94659f6b3395..10ebd90d6677 100644
>>>> --- a/include/uapi/linux/bpf.h
>>>> +++ b/include/uapi/linux/bpf.h
>>>> @@ -6123,6 +6123,10 @@ struct xdp_md {
>>>>          __u32 rx_queue_index;  /* rxq->queue_index  */
>>>>          __u32 egress_ifindex;  /* txq->dev->ifindex */
>>>> +       /* Last xdp_md entry, for new types add directly to xdp_buff 
>>>> and use
>>>> +        * BTF access. Reading this gives BTF access to xdp_buff.
>>>> +        */
>>>> +       __bpf_md_ptr(struct xdp_buff *, self);
>>>>   };
>>>
>>> xdp_md is UAPI; I really don't think it's a good idea to add "unstable"
>>> BTF fields like this to it, that's just going to confuse people. Tying
>>> this to a kfunc for conversion is more consistent with the whole "kfunc
>>> and BTF are its own thing" expectation.
>>
>> hmm from my side self here would be stable. Whats behind it is not,
>> but that seems fine to me.  Doing `ctx->self` feels more natural imo
>> then doing a call. A bunch more work but could do btf casts maybe
>> with annotations. I'm not sure its worth it though because only reason
>> I can think to do this would be for this self reference from ctx.
>>
>>     struct xdp_buff *xdp = __btf (struct xdp_buff *)ctx;
>>
>> C++ has 'this' as well but thats confusing from C side. Could have
>> a common syntax to do 'ctx->this' to get the pointer in BTF
>> format.
>>
>> Maybe see what Yonghong thinks.
>>
>>>
>>> The kfunc doesn't actually have to execute any instructions either, it
>>> can just be collapsed into a type conversion to BTF inside the verifier,
>>> no?
>>
>> Agree either implementation can be made that same underneath its just
>> a style question. I can probably do either but using the ctx keeps
>> the existing machinery to go through is_valid_access and so on.
>>
> 
> What kind of access does the BPF-prog obtain with these different
> proposals, e.g. read-only access to xdp_buff or also write access?

read-only access.

> 
> --Jesper
> 
