Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3503952DAC6
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 19:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242322AbiESRBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 13:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242325AbiESRB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 13:01:29 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA71443E9;
        Thu, 19 May 2022 10:01:27 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24JFGHtp010066;
        Thu, 19 May 2022 10:00:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=NdXMX1tNWTtQzfNtGxvIHyN1F8ME45W7cFbWZnc6U7Q=;
 b=RTlLiHT0+LDyZLMV50UNTHO4A60B2J0NcHpmHa8/3pX3pewp9Pp6DjcMhAz13s6KpAIb
 fPZFt9QvnN9k5ulEaWhmttKpRr9x1ejXtHu2x2dVG0GUT9Iz1T2oHexju4zZ1X6eiiqx
 I8OXFPgpT0urqF/Eq25/82Xz1z22TYfeaOM= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4ey1r2m2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 10:00:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8peIrSdy8ovWr3be3L51ha1FKQwzGbGQqX8KZpawvZ8Mjh5pnfViIDbZ/2bGEImh2c6dRwO3oVusJ5ULV0OytwCYafeSEv8Fcjv17W6XHclvzBCS8yuAI2Iu4Ge5VhFJmBw4cIefMCYgdzhMedSRTZk3WPJ/M5j6trSNOIGu7SWqjfYhXyN4M5sGxeR8/xkZ7+z3gNFfs6TAyPpsBTR0a207vbUW9dQJ7y1rwASyCWIkNR1Im+Qx8u9T6XTvb1K347AB6kxQ27XVENC8TdraVBRRXp+1FF6Lo0BsV6ORLBujiPOfLqonOHMYkBkpkWRW+IV7h1NTX7Ut4nEXSYI2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NdXMX1tNWTtQzfNtGxvIHyN1F8ME45W7cFbWZnc6U7Q=;
 b=ja4zCzJUYFqminlZr089yPOveQwelLdAfDpqdUrxhV5ahDPZejnApBk6ZOeQ/yeS4wb+6DiB4GgzbyPKU4HiNNCfzIlnjvxV45XtEwuNal6lOYP9t2qrpfrPYaXpQiUOrCMrcXjeNNOm/mGrWjl+OmmF6kbi619sbRbomh0hwAczJSuwsJU9cnhiKn8FIA63e0s0x7T1OePhF8b4LjwVUTfwp3hXAtFHz4NcCUnacMqYLB6C391CK87xt/q7gYa5r0g6+m2/UePYskYei0v2VBrXvmybZLRkGGAUQieNDM536xNHSKrztJX4ilcfrjof9XvoR5onC5UaB9U7G6GAMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BYAPR15MB2325.namprd15.prod.outlook.com (2603:10b6:a02:85::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Thu, 19 May
 2022 17:00:47 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.015; Thu, 19 May 2022
 17:00:47 +0000
Message-ID: <ae883471-7177-d7a8-b556-82054e10acb2@fb.com>
Date:   Thu, 19 May 2022 10:00:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH v3 bpf-next 4/5] net: netfilter: add kfunc helper to add a
 new ct entry
Content-Language: en-US
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
References: <cover.1652870182.git.lorenzo@kernel.org>
 <40e7ce4b79c86c46e5fbf22e9cafb51b9172da19.1652870182.git.lorenzo@kernel.org>
 <87y1yy8t6j.fsf@toke.dk> <YoVgZ8OHlF/OpgHq@lore-desk>
 <CAADnVQ+6-cywf0StZ_K0nKSSdXJsZ4S_ZBhGZPHDmKtaL3k9-g@mail.gmail.com>
 <20220518224330.omsokbbhqoe5mc3v@apollo.legion> <87czg994ww.fsf@toke.dk>
 <20220519112342.awe2ttwtnqsz42fw@apollo.legion>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220519112342.awe2ttwtnqsz42fw@apollo.legion>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0191.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::16) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1365c3ba-43bd-4541-112d-08da39b91ee3
X-MS-TrafficTypeDiagnostic: BYAPR15MB2325:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB23251FCCF4BD83BF44D5DB4CD3D09@BYAPR15MB2325.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g/o1FfVAPVQDCzqkEfMTL86k9kDrgYgNIyLYPd/WKDtz1nWBt4yC8pWFxTyhVsm18GxFZcZKxkxjsCqTQRNpKYkJVHNI4746MUC3CwKqh1t/zMigwbttGOzmrul4fkB2Zl1bnkSqN+DnqmKknk29Ejv/ngumSae3ga/3mpKebszdLgJTu9H0zANk0Qp9yJfyWDz6aMA+x/XxZp4dopz82vNFb6iIjjrziz0Tyz3NkTpqc9tK3exAx0eeaRknLna8E1JHBK6hdtfaKIPP86+AP1XyeLWGP2qnhSdTFt1B6d1E2708l82oSsbHoTQkYxMMYM4ovN+FFNvvl+NwuCUysXxi1pfrViUNtjxUfjVNX/8dZFT9ecq6I8EfDkyF80nxa8R6B/UHmgOMCXZaoKo2iCsAeKL6faNPv/Ok7n2ry5uphKW3RwUQHAevyhrRL3F4MlpPUT2fkSZmYL5X98x6U77hlOnpH/iC3om9yw5WrRDE7TfzaceNFAnYH9hbSjndDFqW28QirdBzs4kv+5atjfETarkHsx/cOOMalxZ1u7oYUWL5nTWLVjVOxCgpSLNGQxgtQBtUBp7YzmfXPVQWd76OqTfCleHWffywtKuYdJvXiylRZtOO3SqpjktAjGLf24aCSpXFjOw7hJAU6Qxv9re4A3t3qTWmpRWB9exwlwsToJnnzftE2dPEm2tTLVoABlsdq4pnSUIPbJRUyJry2ibgjQdXtOmqnI1iu4UdCJo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(186003)(7416002)(83380400001)(6506007)(53546011)(6486002)(5660300002)(6512007)(66574015)(2906002)(36756003)(31686004)(508600001)(52116002)(2616005)(31696002)(86362001)(8676002)(66476007)(66556008)(54906003)(66946007)(4326008)(316002)(110136005)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUtUcWVvNEE3bHF0Mms5U3IrNXdRV3hWS2krZkFBTi9DVTRzOFRvL1NmL3dH?=
 =?utf-8?B?ZlYrUEtWQi9XUjJSQlhvUlZMQkxsTm1wdGpxSXhNZUw2VTVJTlVHNWdJdXNK?=
 =?utf-8?B?aHloZFlNZXhDbHh5YVpnSHp5T284b1VLSmFVWWd1Q2htRlFoSzMyWXZCS1kv?=
 =?utf-8?B?VFRFR3Y4MVlPYlBoeHB0RkRhcVRtc2tzSFRQeTZqSytQMkEvZUtFMUV5aU5Q?=
 =?utf-8?B?di9obGE5MnZSN0hUNWc2VnJZUURwb09lajEzbzdxVFlTQU81dEtibEZQSXJ1?=
 =?utf-8?B?VVBFWjZWWStxOTVyR2RDUGVoWHZKWVFhUWFvaFZ1RllwVVgzT1IxZGs3MTB5?=
 =?utf-8?B?MW5adllWSEtrcmZRcGVmL3YvQUhYd20vbGt6ZlZnOElvOEErK3hUblRXZU5M?=
 =?utf-8?B?eWNscG9kcEFtK3VRN2NmbmRRc1Ixc0xXS1pacTVNNkxXdFdsaXNRMitrZk05?=
 =?utf-8?B?aDFWZUxKeDJsSG9jdmtoTGIvVmFMbDVHOTY3V2FGQnlJN3Q4N2tKbkJUNlpl?=
 =?utf-8?B?cGdPYUdBb3dsRUtrR0dpOTRjWnliUXU1cEZLK3k5NW5RRWVadnNXbkRPaE5R?=
 =?utf-8?B?RkhVNkhwWWpodmRyMmEzamZ6cmJ3dTBaQ2RYaU1uSlpCSjR4dSt2QVFubmEz?=
 =?utf-8?B?TXM5NE9VMXhpNHpLdHZ4MENTTnFWZTdHakMxdkllN1ZMWlBuYXhla200by94?=
 =?utf-8?B?ZC9NeEExd3FJNWorQm5mVmcrRXNpZmljTHY0cFpCZnV2cDJ2VXA3V0dLMDRI?=
 =?utf-8?B?cThtSkw4clhoQnRmWER3a0paTGdYZXlKSW1sV2VnY0d0UDlWYm5ZM1FpZm9W?=
 =?utf-8?B?RGNSdmc3Ukw0UU5wYzZSbDJKRDUvWGl1U0ZSdEdsWVZzZjZYWFVja3hjaHA0?=
 =?utf-8?B?Qm5oeG5KRWYvdzFPbVdMaWcwY3lxcFVHa24rdzZTVnpna0JvcDB5Q2daVVZV?=
 =?utf-8?B?VHduTHVBZGhIUFppRlU1SngxQmtZMUVLTHJkenJiNHhiZlljcUhRbFlYNE5J?=
 =?utf-8?B?ejhWSE9aYWRoakh1L3NoNS9DSUxEa3l1MnNWc0hMNloxMndaUG5KQ3NvTzVI?=
 =?utf-8?B?SUdQZ2hldXpLRUtOREpPMm9UOVA2V0k5L0JENC96OUE3UTZ4WFVVTnBNOXRm?=
 =?utf-8?B?SnBSUzg3b1NmN2VuNHNncndNK1E3cGx0RzEwNWhFaVJMbkhJcmNxN3NFZTcw?=
 =?utf-8?B?TmdxN2JZdlY3NTVrQ0JpYlBWUXhjdVVTbVpaazdmVi9UTTRRRzdsTWFNS201?=
 =?utf-8?B?bTRibUtzMVc2c0V2T2NoVC95bllkU3BPUjlrcktUWkE2YVhMZ1NtNEFKU3My?=
 =?utf-8?B?WWtNclVBRmVDeVUyZzUydTY2VFM5RmtpMjdmaGhQM0Z6Z0d3RnpEZEZ0V09C?=
 =?utf-8?B?VmdITnhNbnRUTXVleGVCaWlVVUZRSUlVVkVuck1WNkoyei9FejljQnhWY0Vp?=
 =?utf-8?B?WnhvTnhINmUwL0p1VnYrSkNEUCtERXVPbExEVlBFUVhyU2FWdytvamRUMG5O?=
 =?utf-8?B?YkludUYrdDg3bEZGRXprTW4vcGpndmg2a2lFVzFxbDM4R1NlNEgraVp3K2NM?=
 =?utf-8?B?c0JCSUY0bCs0ZXRseElSM2d5b3lqMlUwbFFTVHdEU054bjdPYVVibUdvb1pl?=
 =?utf-8?B?dGltK2lTaks4b2FIenpsWmhvUlpJdUc1RXFCVENRUFg2TnFyQm14alNKSGRw?=
 =?utf-8?B?TlNOeXljZTBON3NRSXBzNkZJNEVtR3FyOUx1djdJdXlzN2U0ajUzZXZRWmxY?=
 =?utf-8?B?akdJWXdHd08zbjNQZTljL0J1cEtieWduWWl6LzdjK2QrNFVGSjNoUzhlZTJ1?=
 =?utf-8?B?SFdvUVBGWlhFMUMzbDd2RDJaWXo5dHVIOEIxQ1RiREM1YTdUbEpjTnNkUXl4?=
 =?utf-8?B?eHZwVVM2NUFaNE9icE5sOEhKRnBFOW1uWFA2MVlxTVIzR2pQVVRPbE1KTFA4?=
 =?utf-8?B?VlpsTnlPck00VWZXMER6NVZCM2hGeUxPcUtnbnhNVW5PV0d3SHZINk5JS2FT?=
 =?utf-8?B?ekl4TmlaSlBQUjhzNEhRS01HMjRWYVhvTGFQSGpINkxLd1doNFR1UGM0Nno1?=
 =?utf-8?B?bktzZmFKcmh2aC9PeVdKM2ExOFN2dC9WQjZTTWRzUFpyNkM5ekN3SXRRNjR0?=
 =?utf-8?B?THV2T2tCbVM0djRQenlUby84UzEwVFo5dDUwWllrRlMwVEtpMXp0TUgxRlF6?=
 =?utf-8?B?YTRnUG9NazcveGdCMlJvbG5TT1dra3owS3dldmFjZHdVazdVaFczYUpMNjJu?=
 =?utf-8?B?RXZGai9DYnhYTW12Mkl5YlQzVytidDFPZkdKV0NxZHF5VlVza3NNWlBUdmpF?=
 =?utf-8?B?b0NGNjQxQ2FZL01OWnhzUEhRUy8rWmRTWHZDUWJGeTVKaEZsMks1V3lXSkRB?=
 =?utf-8?Q?Q7SggGWGyMfVa1o4=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1365c3ba-43bd-4541-112d-08da39b91ee3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 17:00:47.7839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HC5KnJzINACHdvFvGWES0CBEk5LBjCOB1PYmP073T1iVmcgnKpxnZTA4j6QVctxd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2325
X-Proofpoint-ORIG-GUID: s1zXKZE5rDSwrj1gxWAOx-qZbTwip2kc
X-Proofpoint-GUID: s1zXKZE5rDSwrj1gxWAOx-qZbTwip2kc
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



On 5/19/22 4:23 AM, Kumar Kartikeya Dwivedi wrote:
> On Thu, May 19, 2022 at 04:15:51PM IST, Toke Høiland-Jørgensen wrote:
>> Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:
>>
>>> On Thu, May 19, 2022 at 03:44:58AM IST, Alexei Starovoitov wrote:
>>>> On Wed, May 18, 2022 at 2:09 PM Lorenzo Bianconi
>>>> <lorenzo.bianconi@redhat.com> wrote:
>>>>>
>>>>>> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>>>>>>
>>>>>>> Introduce bpf_xdp_ct_add and bpf_skb_ct_add kfunc helpers in order to
>>>>>>> add a new entry to ct map from an ebpf program.
>>>>>>> Introduce bpf_nf_ct_tuple_parse utility routine.
>>>>>>>
>>>>>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>>>>>> ---
>>>>>>>   net/netfilter/nf_conntrack_bpf.c | 212 +++++++++++++++++++++++++++----
>>>>>>>   1 file changed, 189 insertions(+), 23 deletions(-)
>>>>>>>
>>>>>>> diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
>>>>>>> index a9271418db88..3d31b602fdf1 100644
>>>>>>> --- a/net/netfilter/nf_conntrack_bpf.c
>>>>>>> +++ b/net/netfilter/nf_conntrack_bpf.c
>>>>>>> @@ -55,41 +55,114 @@ enum {
>>>>>>>      NF_BPF_CT_OPTS_SZ = 12,
>>>>>>>   };
>>>>>>>
>>>>>>> -static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
>>>>>>> -                                     struct bpf_sock_tuple *bpf_tuple,
>>>>>>> -                                     u32 tuple_len, u8 protonum,
>>>>>>> -                                     s32 netns_id, u8 *dir)
>>>>>>> +static int bpf_nf_ct_tuple_parse(struct bpf_sock_tuple *bpf_tuple,
>>>>>>> +                            u32 tuple_len, u8 protonum, u8 dir,
>>>>>>> +                            struct nf_conntrack_tuple *tuple)
>>>>>>>   {
>>>>>>> -   struct nf_conntrack_tuple_hash *hash;
>>>>>>> -   struct nf_conntrack_tuple tuple;
>>>>>>> -   struct nf_conn *ct;
>>>>>>> +   union nf_inet_addr *src = dir ? &tuple->dst.u3 : &tuple->src.u3;
>>>>>>> +   union nf_inet_addr *dst = dir ? &tuple->src.u3 : &tuple->dst.u3;
>>>>>>> +   union nf_conntrack_man_proto *sport = dir ? (void *)&tuple->dst.u
>>>>>>> +                                             : &tuple->src.u;
>>>>>>> +   union nf_conntrack_man_proto *dport = dir ? &tuple->src.u
>>>>>>> +                                             : (void *)&tuple->dst.u;
>>>>>>>
>>>>>>>      if (unlikely(protonum != IPPROTO_TCP && protonum != IPPROTO_UDP))
>>>>>>> -           return ERR_PTR(-EPROTO);
>>>>>>> -   if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
>>>>>>> -           return ERR_PTR(-EINVAL);
>>>>>>> +           return -EPROTO;
>>>>>>> +
>>>>>>> +   memset(tuple, 0, sizeof(*tuple));
>>>>>>>
>>>>>>> -   memset(&tuple, 0, sizeof(tuple));
>>>>>>>      switch (tuple_len) {
>>>>>>>      case sizeof(bpf_tuple->ipv4):
>>>>>>> -           tuple.src.l3num = AF_INET;
>>>>>>> -           tuple.src.u3.ip = bpf_tuple->ipv4.saddr;
>>>>>>> -           tuple.src.u.tcp.port = bpf_tuple->ipv4.sport;
>>>>>>> -           tuple.dst.u3.ip = bpf_tuple->ipv4.daddr;
>>>>>>> -           tuple.dst.u.tcp.port = bpf_tuple->ipv4.dport;
>>>>>>> +           tuple->src.l3num = AF_INET;
>>>>>>> +           src->ip = bpf_tuple->ipv4.saddr;
>>>>>>> +           sport->tcp.port = bpf_tuple->ipv4.sport;
>>>>>>> +           dst->ip = bpf_tuple->ipv4.daddr;
>>>>>>> +           dport->tcp.port = bpf_tuple->ipv4.dport;
>>>>>>>              break;
>>>>>>>      case sizeof(bpf_tuple->ipv6):
>>>>>>> -           tuple.src.l3num = AF_INET6;
>>>>>>> -           memcpy(tuple.src.u3.ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
>>>>>>> -           tuple.src.u.tcp.port = bpf_tuple->ipv6.sport;
>>>>>>> -           memcpy(tuple.dst.u3.ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
>>>>>>> -           tuple.dst.u.tcp.port = bpf_tuple->ipv6.dport;
>>>>>>> +           tuple->src.l3num = AF_INET6;
>>>>>>> +           memcpy(src->ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
>>>>>>> +           sport->tcp.port = bpf_tuple->ipv6.sport;
>>>>>>> +           memcpy(dst->ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
>>>>>>> +           dport->tcp.port = bpf_tuple->ipv6.dport;
>>>>>>>              break;
>>>>>>>      default:
>>>>>>> -           return ERR_PTR(-EAFNOSUPPORT);
>>>>>>> +           return -EAFNOSUPPORT;
>>>>>>>      }
>>>>>>> +   tuple->dst.protonum = protonum;
>>>>>>> +   tuple->dst.dir = dir;
>>>>>>> +
>>>>>>> +   return 0;
>>>>>>> +}
>>>>>>>
>>>>>>> -   tuple.dst.protonum = protonum;
>>>>>>> +struct nf_conn *
>>>>>>> +__bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
>>>>>>> +                   u32 tuple_len, u8 protonum, s32 netns_id, u32 timeout)
>>>>>>> +{
>>>>>>> +   struct nf_conntrack_tuple otuple, rtuple;
>>>>>>> +   struct nf_conn *ct;
>>>>>>> +   int err;
>>>>>>> +
>>>>>>> +   if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
>>>>>>> +           return ERR_PTR(-EINVAL);
>>>>>>> +
>>>>>>> +   err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, protonum,
>>>>>>> +                               IP_CT_DIR_ORIGINAL, &otuple);
>>>>>>> +   if (err < 0)
>>>>>>> +           return ERR_PTR(err);
>>>>>>> +
>>>>>>> +   err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, protonum,
>>>>>>> +                               IP_CT_DIR_REPLY, &rtuple);
>>>>>>> +   if (err < 0)
>>>>>>> +           return ERR_PTR(err);
>>>>>>> +
>>>>>>> +   if (netns_id >= 0) {
>>>>>>> +           net = get_net_ns_by_id(net, netns_id);
>>>>>>> +           if (unlikely(!net))
>>>>>>> +                   return ERR_PTR(-ENONET);
>>>>>>> +   }
>>>>>>> +
>>>>>>> +   ct = nf_conntrack_alloc(net, &nf_ct_zone_dflt, &otuple, &rtuple,
>>>>>>> +                           GFP_ATOMIC);
>>>>>>> +   if (IS_ERR(ct))
>>>>>>> +           goto out;
>>>>>>> +
>>>>>>> +   ct->timeout = timeout * HZ + jiffies;
>>>>>>> +   ct->status |= IPS_CONFIRMED;
>>>>>>> +
>>>>>>> +   memset(&ct->proto, 0, sizeof(ct->proto));
>>>>>>> +   if (protonum == IPPROTO_TCP)
>>>>>>> +           ct->proto.tcp.state = TCP_CONNTRACK_ESTABLISHED;
>>>>>>
>>>>>> Hmm, isn't it a bit limiting to hard-code this to ESTABLISHED
>>>>>> connections? Presumably for TCP you'd want to use this when you see a
>>>>>> SYN and then rely on conntrack to help with the subsequent state
>>>>>> tracking for when the SYN-ACK comes back? What's the usecase for
>>>>>> creating an entry in ESTABLISHED state, exactly?
>>>>>
>>>>> I guess we can even add a parameter and pass the state from the caller.
>>>>> I was not sure if it is mandatory.
>>>>
>>>> It's probably cleaner and more flexible to split
>>>> _alloc and _insert into two kfuncs and let bpf
>>>> prog populate ct directly.
>>>
>>> Right, so we can just whitelist a few fields and allow assignments into those.
>>> One small problem is that we should probably only permit this for nf_conn
>>> PTR_TO_BTF_ID obtained from _alloc, and make it rdonly on _insert.
>>>
>>> We can do the rw->ro conversion by taking in ref from alloc, and releasing on
>>> _insert, then returning ref from _insert.
>>
>> Sounds reasonable enough; I guess _insert would also need to
>> sanity-check some of the values to prevent injecting invalid state into
>> the conntrack table.
>>
>>> For the other part, either return a different shadow PTR_TO_BTF_ID
>>> with only the fields that can be set, convert insns for it, and then
>>> on insert return the rdonly PTR_TO_BTF_ID of struct nf_conn, or
>>> otherwise store the source func in the per-register state and use that
>>> to deny BPF_WRITE for normal nf_conn. Thoughts?
>>
>> Hmm, if they're different BTF IDs wouldn't the BPF program have to be
>> aware of this and use two different structs for the pointer storage?
>> That seems a bit awkward from an API PoV?
>>
> 
> You only need to use a different pointer after _alloc and pass it into _insert.
> 
> Like:
> 	struct nf_conn_alloc *nfa = nf_alloc(...);
> 	if (!nfa) { ... }
> 	nfa->status = ...; // gets converted to nf_conn access
> 	nfa->tcp_status = ...; // ditto
> 	struct nf_conn *nf = nf_insert(nfa, ...); // nfa released, nf acquired
> 
> The problem is that if I whitelist it for nf_conn as a whole so that we can
> assign after _alloc, there is no way to prevent BPF_WRITE for nf_conn obtained
> from other functions. We can fix it though by remembering which function a
> pointer came from, then you wouldn't need a different struct. I was just
> soliciting opinions for different options. I am leaning towards not having to
> use a separate struct as well.

Is it possible that we define the signature of nf_insert() as
   const struct nf_conn *nf_insert(...)
so for
   const struct nf_conn *nf = nf_insert(nfa, ...);

if there are any nf->status = ..., the compiler will emit a warning.

Also verifier can know the return value of nf_insert() is read-only
and can prevent value overwrite.

Maybe I missed some context, but the above is based on what
I understood so far.

> 
>> Also, what about updating? For this to be useful with TCP, you'd really
>> want to be able to update the CT state as the connection is going
>> through the handshake state transitions...
>>
> 
> I think updates should be done using dedicated functions, like the timeout
> helper. Whatever synchronization is needed to update the CT can go into that
> function, instead of allowing direct writes after _insert.
> 
>> -Toke
>>
> 
> --
> Kartikeya
