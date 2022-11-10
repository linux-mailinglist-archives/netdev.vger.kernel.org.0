Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8031962479F
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 17:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbiKJQxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 11:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiKJQxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 11:53:43 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B75AE48;
        Thu, 10 Nov 2022 08:53:42 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AA4xENG007140;
        Thu, 10 Nov 2022 08:53:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=bERNP+NKm04jC1lUpEW5OkPxqNEsOyqrvQkkVEUlrnU=;
 b=ImgYIC/ZcMdCnyF+QwI9P6wbn+u9e6ovazMxLDDtZPYu25qbxnvALKT6TbGWsCmuGMSu
 eQtw/skJpXEs6SOZMO6qaufzaFuXjMUOqy1lnHi+kbCnjLEYraYuRtSrYmNITCW2ToG1
 yWfzBsZrNpe90XZSxZjnL7D3HBUPeT7aIfBwjeAk7O4nk1KnVnUO+43Ze5+cXXdkDSBj
 +M59j2a05smBuMLa4g4qpfpte4KxO/JLxRsEMdLlOkw233a71P4dMDjjJQTVNEB3/p6Q
 fTnfjKJ5bFBGEBDXrLIhEagYrYIbGEwwMT2TCZSiU5Z6A1CG1I8K8Qy8UyUqY+AAUjol mg== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3krnrhe81q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 08:53:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a5A5yKhwfzXbGEULomOgQe3/R/V49ub8udtpqHcMjbYEkKzJOCCKgr9v0jgi/MjKTEbAUAiu07e27+Lo9uMsI7f5C+6qoxSb0TbR9Hy/AbRvLCuTkk9S2caEOfvteynBJpTjN+DbfHrv3pGePiltQcvO4pUJ5Msx7tuxKSHej8QB7wQqr8vz9elceJYL0xGXHLtAGY4INR6KlvMLIde/TkTIdRFa1jG48ge3p+zhSkyLBuItjU1aBBMmsiC9GRRXQ3DxyDBH1OwCs2oUMPlt4j6X1EmGSrLX/W7T7iifvSjXH6lWRpttvQQwSWDqaqZLqJWhcHDMuNKqP7sgDv8H9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bERNP+NKm04jC1lUpEW5OkPxqNEsOyqrvQkkVEUlrnU=;
 b=Rp91cqHaXVchOMJQ/mVFZVs1NLoOHZLkeZ457Ml8wnQk09NAuPejZv8Tkt42BzBBLwO1nr846U+gnOdPn9u1hI14jP6kejIaMCJal3BZ0/FdWn4JfF1LbJ/7g5D2aH7ssmZLrgLcZtJ4Pmewz4f/SI8/KVxM6i1N8s3WCBg49bL5HewwvcTtVCDNmOgY73j57k7XtlTxGSNeuuvq+pAcQRzKDiCV7WZ3NQp+Jc6hv2h1ogMXch63c093Pwt3Dr7+bg5yABBq3lLqj074rNOpKsej4umqeEqLtVPDBs8v10shDzzM/Ptlgpjo45t7EMrWh+xtTFrhJzEvThnJHy5J5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4418.namprd15.prod.outlook.com (2603:10b6:806:195::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 16:53:23 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::1f2:1491:9990:c8e3]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::1f2:1491:9990:c8e3%4]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 16:53:22 +0000
Message-ID: <9ba5a3ae-73fa-27a4-e438-492a15e2ca0a@meta.com>
Date:   Thu, 10 Nov 2022 08:53:19 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [1/2 bpf-next] bpf: expose net_device from xdp for metadata
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, hawk@kernel.org,
        daniel@iogearbox.net, kuba@kernel.org, davem@davemloft.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, sdf@google.com
References: <20221109215242.1279993-1-john.fastabend@gmail.com>
 <20221109215242.1279993-2-john.fastabend@gmail.com>
 <0697cf41-eaa0-0181-b5c0-7691cb316733@meta.com>
 <636c5f21d82c1_13fe5e208e9@john.notmuch> <87cz9vyo40.fsf@toke.dk>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <87cz9vyo40.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BN8PR07CA0013.namprd07.prod.outlook.com
 (2603:10b6:408:ac::26) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SA1PR15MB4418:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c4eaaf1-8568-4a02-9a26-08dac33c13f5
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LTTimtvdt6g9sDcvjSodZifPlah8btzbxpw7F0+RQKH95uUdMHW2jBSZVZD8QgB07TOyQjADBZPf8/dtFuLopsr57QXpNg46iHboKvbIuLzu8BpQBKINCPpl4BJa4GIFU3nIDDnVdtFaRF9VRt4qs3K2JEr9/1yQU18zLEFofgzqUiKL/EoRf06kEagXqTBo1uYuOE3N2St/jgUBEKZIIP/b35yjtK80+yLLgQvr6Skspushxhhvpj5GZYk3BeFMSxLuRAWNiI8xJ8SfEMydlKe+DgWS2gZIgs0Yz72nHwBALCVuhgk1oqGLf39hMZZLB+2Pyphgxxy70JH6Z3RdCQRu805ZfUDFd6El0UK+JLbJrm5T/1ACrvWFOeOSVNbTezvuNUpoilBqKWLKoT559RUroGHpv8yEO77KPnYL93jwmJH6l4fTN6BGchfoQZV7vh9RC81ZVFzJfWHVrTl5p7qWkF+5h0EvxNY5GD9Y5LwucBNY/l7RlhRJok+aavoaZyZrWn7Vg0JvywYCvSAiDqg0bKv4S6y3GcP1wt/uC4cK0yZMJOLFqyj+sYcqnMQAVkMFTyUJ7F4vs0kx3Glq+VY9/4wyhHYr2fCjozvlDaAiQA6nVz+yW3xp1wY7ykH1WfKbkmyWRlQingdo2mz5NISgllbbbwkOXzttJ9onCW4qtXEK1j+48aJrBQwVoxj1oXMVY3s7fBJenrP0+mPRepJQ5opK6OrVruN2ecJb2FIA+PDNl3N6dDrXLVe6kNP/Cl5BuKGuJnSPGx4F3cdVtBzriRHEjytfcpGtL/X1T3HX5TGh/HhImy+zgAh9MYdxEu2oscYr4dO223JDGiBASpfmlTfLdiUaseVVkejjG7B0DPwORrxmL7VKAI2LoakM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(376002)(39860400002)(366004)(451199015)(316002)(110136005)(2616005)(41300700001)(5660300002)(7416002)(186003)(2906002)(66574015)(8936002)(6506007)(53546011)(4326008)(6512007)(31696002)(66476007)(66946007)(66556008)(8676002)(36756003)(86362001)(31686004)(478600001)(6486002)(966005)(83380400001)(38100700002)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEVoMTJKMytlOVhDZ0xEeXJOendiMUxybEVjc3J4Z29iUkhvaGg1cW03RjRk?=
 =?utf-8?B?Y0lueFNteTdncnlDS1J6d1VqanVJOTFYWFFjaWhtTmlONnY0Rm5FYTlxSFpw?=
 =?utf-8?B?dkxBWVkyUEZPVXJyNjhFNW1BdlAveDF2dHJ4cGxPZmUvY1hiY3RtUzRBaEk1?=
 =?utf-8?B?dHJ6M3BmNi9DTnZiU3k1Q0FNSmZLOVNnMnV2QUdPZmMxclVSTDFlamw1SkZB?=
 =?utf-8?B?SlNneG44blNwbWozaFNZUncyRW9YU2JHa3VoSEtwWlVTSW5OaHNGeUNmVWJR?=
 =?utf-8?B?R0NzbGhLSjZjM1VCK1YxVFJ0UzNNcnRVSW11SU9jbmdhOFJ5Ulp5OWJZM1hv?=
 =?utf-8?B?eEd1WnRCY0R2VXhacStlRGtwVHRVTHRtdmNyZnJSVUY4aXlhejljZ0IzeUZX?=
 =?utf-8?B?bUxZTE0wK1UzeG9RbjQ4OTdwTnhSY3hFNXJ5OTVQRGEwRmJLaXhjc09ZZWZV?=
 =?utf-8?B?YU8xa2sxaE9QYWVGSmFGZmlab0JzcVBYN3JraGNhRW9vVXYvTlJEOVdGZ2lU?=
 =?utf-8?B?RFh3b3YwQlc2YmZwcncwTHJ0cUp4S1dhZHdxcElqamVwb0xtaXRCUjhiU0hK?=
 =?utf-8?B?V0c2UER0ZTltbjVkMFA3YjBOZm4zcUJGUnE5elhJa2FEb2JHRTJCbWZvUzJE?=
 =?utf-8?B?Q1NGWWNQdFNCdGVnNUtLTmppR3Fab25RRWhFcG9LWGx3bCttb3dSNWt5L1NR?=
 =?utf-8?B?OTdYTG5vNzRnWHR1QWgxaVVsKzNLQ2dMVlZTSFFSLzE1bTZjK1RrRkptcWM5?=
 =?utf-8?B?dTRLcFhUVGR5S0JFTUI5RDVpMG1aSVFPaXp4SHlmc3lqcHZRYnpmNHlkdDIz?=
 =?utf-8?B?bmZJUXdoQ1dEZElVSHpMVWhwR1Z5UGplWnEvVnBXc0xBckVWT3RtTjBsV2pL?=
 =?utf-8?B?QmNvRExsQVZ2bmRHL3ZiNEppYlhoUzZYM3ZPUzIrQjJBRGkvS2tvcWhUbndn?=
 =?utf-8?B?Y285UEhMUmxEQWVML2tBRy9ScEc1Wll1WGwxZ20ydU1GSjRSeUM5MC9JTkgx?=
 =?utf-8?B?UmlWVVYrVlk4bXhQTzlHd3hLWGZreDBrbWR4M0tkWHNEZDVMbXFKeFV0bkNR?=
 =?utf-8?B?WkJNRDhNUGpDcTN4ZVRhQWtScGRPeEQrRmcyMnZ5UVlqQ1pMMjEzWXh3bXFO?=
 =?utf-8?B?UlhXZnp1Mk82VFRPOXhvNHRRWEc4N0dsbUFoM1NhZ05XU0I1NERWZ2g1Yy9i?=
 =?utf-8?B?NXFydTdEZUliY3I0K09memZPT1pMejk0WitFNnc3ODZMNHFmemIyVHFYdVBl?=
 =?utf-8?B?WUtoVElKZXZ2THNTWnl6cnhmbzdPZ2lsM0FjSmMxc1BqN0FTekdlajJhbVFv?=
 =?utf-8?B?dWdCNnFBMEQrY3ZPaG5ndFFQNXhSZFJNRWM4dVFCdVovS1RzUHZoT0E5bnRo?=
 =?utf-8?B?K0dleGFQL2l0QWttSGV5QnpxRFkrWW53YXVvamRIWXZkSVEvRis5WFNibHQx?=
 =?utf-8?B?dmtiT1JDcHdkOWl1NXVNdTZ1NUt6eDJPemQ0VjRzTHE0RG9vMEE5ZC9FQW0y?=
 =?utf-8?B?czhacWxZam11ZkQxQ1JueEhRRHc5TTVWWnVpVFR5dWF1ZU1OeGxDcW45Uncx?=
 =?utf-8?B?c2hQeWlqUTJRbUJqOXQydEduNTJPZWluYjBOY0RpRjlsalR1cktpSmg0dDcy?=
 =?utf-8?B?Z3FmNEpEZEJnNVZHaldzODVob09OUnh2WHhCN0crQWpEcUhEVGRlM1gxRlZO?=
 =?utf-8?B?UkF0alVHTG9PSDZPYml1Vm5mN0Vpek53cnFoOXl1RVVCcGIzVnU1WjIyTzhn?=
 =?utf-8?B?YytNcUdrczNTQkgrZTZ0b256cnRzZmpKNHFJMCtEU1Z5V2kvWDFjY2J3MzI5?=
 =?utf-8?B?NHJ6ZU1FV2IvQ3d5ZmxmSkt1aHhtY09Ba2MvM1ZxTlFlY2N0YkdhOWpUbFFh?=
 =?utf-8?B?Mi8weDVHVEpHOHJWSkFVTlpBdWFNYkpzbUpaMlhRaVlFTkh3VWtWTnk3akhN?=
 =?utf-8?B?MCtadFNUK3ZBQ05UYjRtanpTcDVxck1yZjc2UERKTmtkbDA2K1FCdVVhenJG?=
 =?utf-8?B?MFZ3a3JUb0d3c04rSFhSWTFnejBGOEMwNWRWbU45dmF2emw5SDNnVTkyRUMr?=
 =?utf-8?B?VjVYT055RER6UjY3ZGpkamJRSDg3TGlkVWNEUzdQbkVFV2RvQm1UNXNxWjVD?=
 =?utf-8?B?czBiSWJiaGhXalcvMFRzVytvaVNkNVU1QjlMazAzQmpMUFY4SW1TZXFPczUz?=
 =?utf-8?B?SUE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c4eaaf1-8568-4a02-9a26-08dac33c13f5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 16:53:22.7600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Je1rCdZXbR0yxVaXehakcpiJzUgGuusTMT4bOQezga0j5h04GQiUgC4IxyH11Bk/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4418
X-Proofpoint-GUID: og25n3wXZqnXeyo1RAP1MnwOclveLXZg
X-Proofpoint-ORIG-GUID: og25n3wXZqnXeyo1RAP1MnwOclveLXZg
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_11,2022-11-09_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/10/22 4:45 AM, Toke Høiland-Jørgensen wrote:
> John Fastabend <john.fastabend@gmail.com> writes:
> 
>> Yonghong Song wrote:
>>>
>>>
>>> On 11/9/22 1:52 PM, John Fastabend wrote:
>>>> Allow xdp progs to read the net_device structure. Its useful to extract
>>>> info from the dev itself. Currently, our tracing tooling uses kprobes
>>>> to capture statistics and information about running net devices. We use
>>>> kprobes instead of other hooks tc/xdp because we need to collect
>>>> information about the interface not exposed through the xdp_md structures.
>>>> This has some down sides that we want to avoid by moving these into the
>>>> XDP hook itself. First, placing the kprobes in a generic function in
>>>> the kernel is after XDP so we miss redirects and such done by the
>>>> XDP networking program. And its needless overhead because we are
>>>> already paying the cost for calling the XDP program, calling yet
>>>> another prog is a waste. Better to do everything in one hook from
>>>> performance side.
>>>>
>>>> Of course we could one-off each one of these fields, but that would
>>>> explode the xdp_md struct and then require writing convert_ctx_access
>>>> writers for each field. By using BTF we avoid writing field specific
>>>> convertion logic, BTF just knows how to read the fields, we don't
>>>> have to add many fields to xdp_md, and I don't have to get every
>>>> field we will use in the future correct.
>>>>
>>>> For reference current examples in our code base use the ifindex,
>>>> ifname, qdisc stats, net_ns fields, among others. With this
>>>> patch we can now do the following,
>>>>
>>>>           dev = ctx->rx_dev;
>>>>           net = dev->nd_net.net;
>>>>
>>>> 	uid.ifindex = dev->ifindex;
>>>> 	memcpy(uid.ifname, dev->ifname, NAME);
>>>>           if (net)
>>>> 		uid.inum = net->ns.inum;
>>>>
>>>> to report the name, index and ns.inum which identifies an
>>>> interface in our system.
>>>
>>> In
>>> https://lore.kernel.org/bpf/ad15b398-9069-4a0e-48cb-4bb651ec3088@meta.com/
>>> Namhyung Kim wanted to access new perf data with a helper.
>>> I proposed a helper bpf_get_kern_ctx() which will get
>>> the kernel ctx struct from which the actual perf data
>>> can be retrieved. The interface looks like
>>> 	void *bpf_get_kern_ctx(void *)
>>> the input parameter needs to be a PTR_TO_CTX and
>>> the verifer is able to return the corresponding kernel
>>> ctx struct based on program type.
>>>
>>> The following is really hacked demonstration with
>>> some of change coming from my bpf_rcu_read_lock()
>>> patch set https://lore.kernel.org/bpf/20221109211944.3213817-1-yhs@fb.com/
>>>
>>> I modified your test to utilize the
>>> bpf_get_kern_ctx() helper in your test_xdp_md.c.
>>>
>>> With this single helper, we can cover the above perf
>>> data use case and your use case and maybe others
>>> to avoid new UAPI changes.
>>
>> hmm I like the idea of just accessing the xdp_buff directly
>> instead of adding more fields. I'm less convinced of the
>> kfunc approach. What about a terminating field *self in the
>> xdp_md. Then we can use existing convert_ctx_access to make
>> it BPF inlined and no verifier changes needed.
>>
>> Something like this quickly typed up and not compiled, but
>> I think shows what I'm thinking.
>>
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 94659f6b3395..10ebd90d6677 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -6123,6 +6123,10 @@ struct xdp_md {
>>          __u32 rx_queue_index;  /* rxq->queue_index  */
>>   
>>          __u32 egress_ifindex;  /* txq->dev->ifindex */
>> +       /* Last xdp_md entry, for new types add directly to xdp_buff and use
>> +        * BTF access. Reading this gives BTF access to xdp_buff.
>> +        */
>> +       __bpf_md_ptr(struct xdp_buff *, self);
>>   };
> 
> xdp_md is UAPI; I really don't think it's a good idea to add "unstable"
> BTF fields like this to it, that's just going to confuse people. Tying
> this to a kfunc for conversion is more consistent with the whole "kfunc
> and BTF are its own thing" expectation.
> 
> The kfunc doesn't actually have to execute any instructions either, it
> can just be collapsed into a type conversion to BTF inside the verifier,
> no?

The kfunc execution can be replaced with a register move like
	r0 = r1  /* r1 is the ctx */
	/* r0 is the kctx */

> 
> -Toke
