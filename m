Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3095B6253DF
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 07:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbiKKGfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 01:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbiKKGev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 01:34:51 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65D431F;
        Thu, 10 Nov 2022 22:34:49 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AALjajm006542;
        Thu, 10 Nov 2022 22:34:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=HHyK/PL8JOKAMxsvFtyX2Ud6tNPjyCGMK76DQBwaUF4=;
 b=iRjuL9Pts20FvgLX/8N6tIaNGv6p/59O+aGg/smmYqAnjQtpE7S+XhCNO0xdgmD3W72A
 g0abWKcsvYENo+eN0KRIqhQcK+qSTOJZGfviNgbdhw4u7VXBSQDpTp86AeMQaLj7RpHm
 gAX9FqCqeP+9hy1F3r+EcpDWBnjxW4yh4HRe7wqLeZaNORkSvUvO0GS8BJVw/HAY5zTH
 qz+NDXs2mKfTRVCJSHaTlT5g6rzeoI6xP3HJzELHENpy9eDM9nLUc6ZmRJL9KlKtzzrS
 kK/Qqf3cXd4jCAWCkwQ7Wwfdwz/Db6ixhX9b4DOENuRjvJH16puJ+Y4nuS8URJ6WLzXA Ew== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3krh8rnwhx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 22:34:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZTXbNGB0wA85RBtb4gXbt/01ltsnnAFNlbugilN2Koj2T73igy0K5dxH2AJ3wSTP4ffwzw9QeI0WOCXMjKA6Z0MAwRSgDoy6sUMtS+0jrW10N2qNLVeHmfMdd3TpOI+IH1m53+2EvCLUXPnWLi5ljpH8kXnPSIbgznUzcXkS4Wl/mRXszMZPrXTgmqXLbM0W9gsDehD4tkb5WNXqJ6DLM5p7CxHCN1muhI80uTT6Pou3HM2I2DUdXtoSmwKOLKcbN81dh80nP0jhvPPY2UrOwnUkr7CZTyz6hzTomRA1SfP/7TN4HS8vk858TRyCVFZPidxL+ER1BW/Coa6i7+lMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HHyK/PL8JOKAMxsvFtyX2Ud6tNPjyCGMK76DQBwaUF4=;
 b=CCv/tO3nblaFYe07bdjCNCJw0W56yyVDkD8SR4xB5fBwJHoBGMi5W7PGKANKf2UyFyzw7rco3sgE3cREeDL39RW5dbeGFBGGpN8tMDuclZ/izoyl84a0FNfGAYzY1moEQxMsLY3CBgS1Gw/+UUgqgKAinov3xzbz0Zh65KDL/rACmeb9Kh1bRVAu7/Uh6Z64vZzG3qqfrpa6dWV6W7Yis8XJlyZ9GsmNnPimmSPkQ/n5zmmvtl1NHNrjNpWaovKkfV/rShP3KT9dKOYrsULOmJuAKHiIivbY0a1SpEGVZZOZsrCllp+z1N40uTw7OtVJJLgMlyG344pBr4I2+FEQvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN6PR15MB1316.namprd15.prod.outlook.com (2603:10b6:404:f2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Fri, 11 Nov
 2022 06:34:30 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::ac66:fb37:a598:8519]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::ac66:fb37:a598:8519%7]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 06:34:30 +0000
Message-ID: <86af974c-a970-863f-53f5-c57ebba9754e@meta.com>
Date:   Thu, 10 Nov 2022 22:34:27 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [1/2 bpf-next] bpf: expose net_device from xdp for metadata
Content-Language: en-US
To:     John Fastabend <john.fastabend@gmail.com>, hawk@kernel.org,
        daniel@iogearbox.net, kuba@kernel.org, davem@davemloft.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, sdf@google.com
References: <20221109215242.1279993-1-john.fastabend@gmail.com>
 <20221109215242.1279993-2-john.fastabend@gmail.com>
 <0697cf41-eaa0-0181-b5c0-7691cb316733@meta.com>
 <636c5f21d82c1_13fe5e208e9@john.notmuch>
 <aeb8688f-7848-84d2-9502-fad400b1dcdc@meta.com>
 <636d82206e7c_154599208b0@john.notmuch>
 <636d853a8d59_15505d20826@john.notmuch>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <636d853a8d59_15505d20826@john.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR03CA0225.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::20) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|BN6PR15MB1316:EE_
X-MS-Office365-Filtering-Correlation-Id: 3639eeee-a502-488d-1429-08dac3aec9a9
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qor9NxDKDhdVRbwBmDklQaMh/904qyGs+J94LQKErsKD2qInkpGbNUKKsFdIK1882fAmGqCiX3VMRyCgiC/ZOXx8fEbc5bCNKcuU5WfbaKQSrzzbGvm/3SEteTzOYvhyAbK0F/l9cAPwjWGNdgsvbysq3yRWCc+lYlnlzw6l/FbVEoqA+OMJSDPfzPURDVNLoobuqvPERGSW/5wNA6xyAc+6mxdHDhgr07TZea5yp1YaSWqd435uFFNuCqCa5E3/E0kBL9eKFshLTz+dl9iEmqzQXZAt8ya0aa6ubU+oX/MfIEH9Oapa51XglECnZCXC3pTeE7ustMRYDd+UCTSoM3hMeislEVTtAQKNcMiEmQR8bUPauYxnSv4b7o2ZViEvIbENCsOEIka99UbHlh8mHGuLfQnKyKY5xWDbgVySSunnEgH7hQRuEQfJY9vQT8Tvvu37oj1e2YAWya6GuahFfjmqa7Nay+sDpMkERPU4m2P39cjpqfFDU3QXOevCFJKficvBDfIDW3A95Fv6GhGFVdiWvn21D/yGdEm+lLe+5EPnO8k+SMVhKmD/AW+CWAc2hf0etXYrfYEwurHxn9l0DKL3OLrtqu/Vp7SUDj7zF/NmmpGcCYLp9K1fnAeBHtTMJP1zf8ekrxEilAFY5mSC2FUrlu7Qt6oV1PIJNql4irmg7BC9v+Mp/NoIVaVUd16cLbjkZQSvS/JcqQyBLwxh9X7trU1Lv913X8mADh6ScQ/SKTL6+7GSIUllbRO3InLbP4zu5xpf8PTFtd4oqCRlai9Z9am9qqBvQVirNqU5kB6YdCylhWzOUE+VTViFuphziba88rnLWQx+XCN+LyPD4UReIJi3ecsHmhGq+JRprktw7LVDGZ31AJw1FwTsqatx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199015)(38100700002)(2906002)(31696002)(41300700001)(966005)(5660300002)(6506007)(86362001)(6666004)(4326008)(6512007)(66556008)(2616005)(478600001)(66946007)(53546011)(6486002)(316002)(8676002)(66476007)(8936002)(83380400001)(36756003)(186003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mk1la09QaXZuVE5sK2Q5UzArb0FwcTRSVm5OZVF2T0NvODYrU29rM0wwY3Fi?=
 =?utf-8?B?ZDg3ZGQ4d1E0NUpTZDBROFYwUmFTWkZ5aGM1Zi83ZE5MUElHQ21aZ3oza0pj?=
 =?utf-8?B?K1JyR2VsbldCSkdTV3o3bGlzaFBUUjVZdW1xaE1kYXhJZ3ZYdkU5cENIdWlP?=
 =?utf-8?B?bGVKZEZJMWxmVitBclp5OGNLNndIRzQwcXlDOXM3dGFtaGdjR1VoSVFBdVN6?=
 =?utf-8?B?Vmk5R3hLMlcveXpMaUhDT2JCQTJGc3ZWdWJGWHUwOEZteXlBaDhNaGdPZFd6?=
 =?utf-8?B?T29naHBZVXBLVlcwZnh1TmJsWDN4SjNOMHVDUFRXS0VmRGNhR0J1eFdMYVVX?=
 =?utf-8?B?Um44SEhhNmpGUzMzd2JoeGhKaG9oenhEMS92VXRqelo2QU5BQ2JXT3JkT2k2?=
 =?utf-8?B?Qlh6UnRrVXpCRG94VTRTWHNmVmxPNUYzTmE1SFhLNHJTTkFkVkVkTkx0OVEv?=
 =?utf-8?B?a2VQSkpVU1ZTU3VuRWNGeXRzbllJZ1pKNkJtL2NTU28vR01TT0V1Qk9WVVl4?=
 =?utf-8?B?YUx1MjRuRk40Mm5EcmFic3dYbkt1ZGhNTCtvNkNLNmZvRHgwalloL3BZVy9w?=
 =?utf-8?B?MFBWSmtLeklZeUZtMWE1c244OHlMMm5JcHRxNWtZdG5IdkE2bEJYNHkxTlRo?=
 =?utf-8?B?TXJiOHhDK0hJL0NsOUx0UDJMMEh0bHBOVWZkNXNOWCtOT0h5b21Yc3BaRk5Y?=
 =?utf-8?B?YXpPTGhUOWVkMldhdi82eWVqQmhEbDBqa1RpK05zM0o0U0VmaWlXTzlSVlBN?=
 =?utf-8?B?U1VYRTNoUWNzbUJwVzBGd3JXZjl0MkQ3YVlxeEc4cUJGQzlIdkg2K043eXFQ?=
 =?utf-8?B?RVovcVVaR2JHSjlNbDZYTFBoS1F3aW9yNm0vQ29ORW9rMW5tdmFiSEVBUkJs?=
 =?utf-8?B?dFBSazFyM3pBb0xGaytubCsxTlUyTjh2Sm1iZXN1anIybHZDUFkxTEpRajRy?=
 =?utf-8?B?ekJVWUt4NVBteWU1c3FvTWFkTVFaV0RnQkV4M1ZNaHovbFZ2RU8vMkpZOVdJ?=
 =?utf-8?B?QnlwaW9RZkExak5VQTZyTm9YQWw1dVp3UTh0b0VqM0VjWGJIaVpiT1dGVWhN?=
 =?utf-8?B?cXU3N29CWDlPRHlmZE9EeitIeDBMb3V4NWhFbk1lYWVkV3dwaCtrc1JZVnBI?=
 =?utf-8?B?Q2hzZ1pyaDBHZ2s1T1hnNC9iU2JjSFdQLzJOQ0YvOVRNQ1RPeDdDTGpaRG5o?=
 =?utf-8?B?ZXdQMDJBVHpqemVrY3NHRnloMys2aVhHYkcvdkxxeGRmQ1M5ZjZlN3RKUFJi?=
 =?utf-8?B?aDZxM3d2bXdtVW9DVFdiT2p4UStDRU8zTGVlbW1BRW5QRGt0eWdaemZ0R1Q2?=
 =?utf-8?B?Uy82U0c0YUZvbzBCQ2NGODJoQ3hkcjY5MUN3eDhCa3prOUhjODhqaVYxRmJs?=
 =?utf-8?B?UEJ6VWlMZEVVQ3RUR0dVL00wRFphMkJIbFlJdzBxaXFDY3hRQ0VVVlFiZHE2?=
 =?utf-8?B?ait2ckx1NXBDcE1WbytNNU9kWkM0OWFtcnRWMTZqSXFyTXo5aTJXNnlvRm5N?=
 =?utf-8?B?b2RXTUQxcmFMaUw5NnQwMTBuOWhVRWVCbFlaajl6NzBBaEtFUWNhYUtOQ0x0?=
 =?utf-8?B?b1dWMjg0RkJUR2xUT0FKM3c1c1dDV2F6T0M0TEpUWkQzMDdXRTBQOUFKemtH?=
 =?utf-8?B?RE5ZVzBDV3J4aFhFTzFMdFRoY1ZtTG51a2g3Z3ZTQlUvdmthU2ZMOElVOWlP?=
 =?utf-8?B?VmdsUmFBTm5XTDFCTFdKVFVRREZsSkIxQzRXYnAwMFJhTExnaVJzUzFmU2FZ?=
 =?utf-8?B?QTd5R0Q2Mm9TZ1V1cEpHNmdSZ1dlbGxXTEdqZ2xzcWFUbmhzRHVjQVc3Ui9u?=
 =?utf-8?B?b1FjRkdpREZETVVWQmJQbVM3NHhVYXpJTEpaTFU1akdueEVSWXpzNjJXazlx?=
 =?utf-8?B?SFVrdHAzVEhIQTAybTZkdy95WnNNMldjTVB0VEFqUndCbnZyTFRvOVRUMWxw?=
 =?utf-8?B?UUhyUFJpYWhETXNnV0xTK1Y0TlJVSlVDbzZzVGxQaXl6NWt4Q2w3eTVza0hG?=
 =?utf-8?B?cEgvWjhTK1FlSzRrMzZ6eUwrckpKcjJGY1VmNzZmV2tXRDhVZlJtYlh2YndH?=
 =?utf-8?B?eHJFc2V2VUtpVHZCS0dybGJIdTNibTdDbTMzcmhDbUFuSFRodkl2cyt6MW5p?=
 =?utf-8?B?cS9Za3Vob1BJZnV3c2dxRlpRM2s3Z3lTVUlpNnJRNDFjaFFFZExGdTJuUUsz?=
 =?utf-8?B?dUE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3639eeee-a502-488d-1429-08dac3aec9a9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 06:34:30.2623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DFabOVGMQSHEuy7Cmi1mp3jacDDNO9pYyey8IvuGDfbX2kH+q58FZ5h+5sPfmcl8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1316
X-Proofpoint-ORIG-GUID: leZlcuE_Y0VMlK4fWLgk_A8wHYk9Vz35
X-Proofpoint-GUID: leZlcuE_Y0VMlK4fWLgk_A8wHYk9Vz35
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_03,2022-11-09_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/10/22 3:11 PM, John Fastabend wrote:
> John Fastabend wrote:
>> Yonghong Song wrote:
>>>
>>>
>>> On 11/9/22 6:17 PM, John Fastabend wrote:
>>>> Yonghong Song wrote:
>>>>>
>>>>>
>>>>> On 11/9/22 1:52 PM, John Fastabend wrote:
>>>>>> Allow xdp progs to read the net_device structure. Its useful to extract
>>>>>> info from the dev itself. Currently, our tracing tooling uses kprobes
>>>>>> to capture statistics and information about running net devices. We use
>>>>>> kprobes instead of other hooks tc/xdp because we need to collect
>>>>>> information about the interface not exposed through the xdp_md structures.
>>>>>> This has some down sides that we want to avoid by moving these into the
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
>>>>>>            dev = ctx->rx_dev;
>>>>>>            net = dev->nd_net.net;
>>>>>>
>>>>>> 	uid.ifindex = dev->ifindex;
>>>>>> 	memcpy(uid.ifname, dev->ifname, NAME);
>>>>>>            if (net)
>>>>>> 		uid.inum = net->ns.inum;
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
>>>>> 	void *bpf_get_kern_ctx(void *)
>>>>> the input parameter needs to be a PTR_TO_CTX and
>>>>> the verifer is able to return the corresponding kernel
>>>>> ctx struct based on program type.
>>>>>
>>>>> The following is really hacked demonstration with
>>>>> some of change coming from my bpf_rcu_read_lock()
>>>>> patch set https://lore.kernel.org/bpf/20221109211944.3213817-1-yhs@fb.com/
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
>>>>           __u32 rx_queue_index;  /* rxq->queue_index  */
>>>>    
>>>>           __u32 egress_ifindex;  /* txq->dev->ifindex */
>>>> +       /* Last xdp_md entry, for new types add directly to xdp_buff and use
>>>> +        * BTF access. Reading this gives BTF access to xdp_buff.
>>>> +        */
>>>> +       __bpf_md_ptr(struct xdp_buff *, self);
>>>>    };
>>>
>>> This would be the first instance to have a kernel internal struct
>>> in a uapi struct. Not sure whether this is a good idea or not.
>>
>> We can use probe_read from some of the socket progs already but
>> sure.
>>
>>>
>>>>    
>>>>    /* DEVMAP map-value layout
>>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>>> index bb0136e7a8e4..547e9576a918 100644
>>>> --- a/net/core/filter.c
>>>> +++ b/net/core/filter.c
>>>> @@ -9808,6 +9808,11 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
>>>>                   *insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
>>>>                                         offsetof(struct net_device, ifindex));
>>>>                   break;
>>>> +       case offsetof(struct xdp_md, self):
>>>> +               *insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, self),
>>>> +                                     si->dst_reg, si->src_reg,
>>>> +                                     offsetof(struct xdp_buff, 0));
>>>> +               break;
>>>>           }
>>>>    
>>>>           return insn - insn_buf;
>>>>
>>>> Actually even that single insn conversion is a bit unnessary because
>>>> should be enough to just change the type to the correct BTF_ID in the
>>>> verifier and omit any instructions. But it wwould be a bit confusing
>>>> for C side. Might be a good use for passing 'cast' info through to
>>>> the verifier as an annotation so it could just do the BTF_ID cast for
>>>> us without any insns.
>>>
>>> We cannot change the context type to BTF_ID style which will be a
>>> uapi violation.
>>
>> I don't think it would be uapi violation if user asks for it
>> by annotating the cast.
>>
>>>
>>> The helper I proposed can be rewritten by verifier as
>>> 	r0 = r1
>>> so we should not have overhead for this.
>>
>> Agree other than reading the bpf asm where its a bit odd.
>>
>>> It cover all program types with known uapi ctx -> kern ctx
>>> conversions. So there is no need to change existing uapi structs.
>>> Also I except that most people probably won't use this kfunc.
>>> The existing uapi fields might already serve most needs.
>>
>> Maybe not sure missing some things we need.
>>
>>>
>>> Internally we have another use case to access some 'struct sock' fields
>>> but the uapi struct only has struct bpf_sock. Currently it is advised
>>> to use bpf_probe_read_kernel(...) to get the needed information.
>>> The proposed helper should help that too without uapi change.
>>
>> Yep.
>>
>> I'm fine doing it with bpf_get_kern_ctx() did you want me to code it
>> the rest of the way up and test it?
>>
>> .John
> 
> Related I think. We also want to get kernel variable net_namespace_list,
> this points to the network namespace lists. Based on above should
> we do something like,
> 
>    void *bpf_get_kern_var(enum var_id);
> 
> then,
> 
>    net_ns_list = bpf_get_kern_var(__btf_net_namesapce_list);
> 
> would get us a ptr to the list? The other thought was to put it in the
> xdp_md but from above seems better idea to get it through helper.

Sounds great. I guess my new proposed bpf_get_kern_btf_id() kfunc could
cover such a use case as well.
