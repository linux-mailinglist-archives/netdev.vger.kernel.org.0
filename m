Return-Path: <netdev+bounces-4523-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E109370D2CD
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:34:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D9231C20CCD
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 861D04A3B;
	Tue, 23 May 2023 04:34:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A25EA8;
	Tue, 23 May 2023 04:34:34 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2A5FA;
	Mon, 22 May 2023 21:34:32 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N27hPk001587;
	Mon, 22 May 2023 21:33:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=EaVCictyd5h6xOvrGl3b43Atvt9v7YxbxsdemM9+y9w=;
 b=dIHvBw+45FTdis+DdTp2W86PiweS0IHnMGT+NtSa4ZKu0cxh7huWlNn4IT5O+V5c6scP
 aMsXSIeEBlEtG8/CPOtfUqnXYAELx8y/HriRLeHD2tJoSoHl80NNfb1DlPPh7VThailD
 KBBqH2BU6W2aGV7DVK5/V/VTydCNSSaaWQpr/2rjVRlubF15NoJdNzyyHiXYUgA8hAj1
 ylsds7/sbX6t8iKnW1SqfG+Jn/7JauAYgFz4icCyYpN7UU+sSRasguDdNhsh3Nx5FESy
 HCMmt4fX3oqZ7fRUfj4QC6pjhKgLOvuZ9q1RW8ayPFxJh6f3UPvetYH0x2LXzNdaZroK 7A== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qrme50q1s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 May 2023 21:33:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eP88p5KDvZX5qcb4ax+k2YK1A3NE96mnYn6sSx0fYX9lj+pG+dSzROjCYZ3+CW0u1BZA4NvMEIRbun98w0zSWhdcE3oVI4jT98x3ynrBHkBpMcxL92jjIdVGS+e+1GyGpzEj/FT/YGdqxLJNs0+YZFraOabO7p8gu9v6Ek7Tuaq12mqRxikJjTWoAfwZO4a/mpd3BqFZJCGcUcoaSrROTKA1k7sQtN+4D+sSFmiNij5PP19QtzwPaplYJvyXzBDjexKYHwxeLMhRfGugN4s61B6UO9VDSgfEFL33AIFViyNZsJv7BUD9pyrFnJJRPtBK60ycbtBCoH+zjn2g+zKbYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EaVCictyd5h6xOvrGl3b43Atvt9v7YxbxsdemM9+y9w=;
 b=K00JVRyktB6OKW9dDsy01TWr2qnByR6s2d5b9l0lUJvCT3enRxRTzFjU8Ydpazhpht1xYSHFf6ouZP293TxFINDMLNZWDt+y8FQheSI2yiKIw/Oo6/r6oIyDtRRhRGJD/aM1zuw+yLL+Khc2wh21TB9Tn10DlKdG8KSOFMozh9ZGTB+c+nhwvY/Bz+c9V1vcFdiXG2aSTy3refU6iPivE37VuiS3I1SAvfO+7MVhWm+/bBZ1BHpEIWfC4PtzI8v7QCg9j2HjZL/U5K8xBbDReTmOQUQtgGiBRUdEeKj55KWFP8hyXNLGCr9PmJ1Lq1HmRgj8VdbD1WK4VMdKFF02jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MW3PR15MB3787.namprd15.prod.outlook.com (2603:10b6:303:4d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 04:33:47 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53%7]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 04:33:46 +0000
Message-ID: <d027cb6b-e32c-36ad-3aba-9a7b1177f89f@meta.com>
Date: Mon, 22 May 2023 21:33:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [bug] kernel: bpf: syscall: a possible sleep-in-atomic bug in
 __bpf_prog_put()
Content-Language: en-US
To: Teng Qi <starmiku1207184332@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230516111823.2103536-1-starmiku1207184332@gmail.com>
 <e37c0a65-a3f6-e2e6-c2ad-367db20253a0@meta.com>
 <CALyQVax8X63qekZVhvRTmZFFs+ucPKRkBB7UnRZk6Hu3ggi7Og@mail.gmail.com>
 <57dc6a0e-6ba9-e77c-80ac-6bb0a6e2650a@meta.com>
 <CALyQVazb=D1ejapiFdTnan6JbjFJA2q9ifhSsmF4OC9MDz3oAw@mail.gmail.com>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <CALyQVazb=D1ejapiFdTnan6JbjFJA2q9ifhSsmF4OC9MDz3oAw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BYAPR06CA0056.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::33) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|MW3PR15MB3787:EE_
X-MS-Office365-Filtering-Correlation-Id: f53bb2cb-32a3-4af1-ce66-08db5b46e5c3
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	oTP3HvT8vZo1pJFAwvObGaf+1jnElZmGA8M9NLLsx3A8syQLww9vTO473CbUkDdbcZpNTUI0PwMvyMmKnXx6DCw2B78MH5R2otO3kyKBE34tFIdwo4mmiZDKe0QynxbwAs1DEECSOgOB53HVAWWWtuA94GyYmNna6K/joHLEO0stK6W3DRyY5TPbcIJ7B0TIANAL8azoWu7KqGWiECF5aMXZbn5/+fYmNtGkbp2sN3zdnRXRojWmUCU/SzKLgZ7Zfj9oedAu51D8yoiHnDQTAFTWy4wv6r7XzzeI6hialifX/QLoZfXULZ/rlqmLm4LG7LFng8LTbQaKGil8ji12DWhRSfmi2eFKxuV+qI3+blSmeyuMxtzFC+37scpGftx4s2PXvPDrQ7IH4pGFCi5H9JmOkjkz4eHLE3HyhbjyE8zL/92AbH6svmsmIqjFRCus1w0EVe4xU9EgqW6XMezquwOnCFwl5sW4BSlemYH7UxqylX0F+2+qqpEfVBSfbdAccBhnDQv3lgWdoy37JIDOXPSZuGhCbHoU3I7TTj126ae1UK5oc/d+v1COQE4HWb4awpCJB/SMN3lOi1lMKoZh/SoI3VFlWye9OTi9nLw2A4QzzQkrzIxmIjTQBamcaDy4iPDfQidQ9X0Yv4njTo8MtQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(451199021)(8936002)(8676002)(5660300002)(7416002)(83380400001)(53546011)(186003)(6512007)(6506007)(2616005)(31696002)(86362001)(38100700002)(41300700001)(6666004)(6486002)(478600001)(66946007)(66556008)(6916009)(66476007)(4326008)(36756003)(316002)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ODBSU3dPZ094RmFhUnE5VDgybTRrWXdtREFYWnFXcXA5a1pJK1FMeUdtMmJ1?=
 =?utf-8?B?NGJBUzVESy9FQXh5NFhrSTBDMFArcjM2L2JrQjcvZ1RMSXhhaTN2OFZWRkxQ?=
 =?utf-8?B?RGZ0SE95bVNUMUpLZ2lPUU9ZQ2dSTTFBcHZpV3E2Vk42emUvK2QrTUEraHZS?=
 =?utf-8?B?TGpIaTBld0xkRnpleXErM09rMHZQOWNyc0lMcGFOaW9YaUJUZ05qT0VVMk1p?=
 =?utf-8?B?RjZGdnNPRlpKaDZJOVg4NHNQNGNYQjVFSHROelIxSUI4TlVoUENtR2hITHZE?=
 =?utf-8?B?aHF3VURNR0hkWVJSOGZQZ28yNHVHMFp6akpnYzgxOUN5dlFaSjl6dWV0Mlls?=
 =?utf-8?B?ZkNyOVczT0J2MWxpRkxsS3ZIbVh6U0ZKNkR1VnM4UkVlY1pkUW1OVXh1a2xW?=
 =?utf-8?B?ZG5VQ2tRM0haQ0F5SmJ3SC8zMzNiaHlGdUIxU1NkaDdzanIxMC8rS3FmU0JO?=
 =?utf-8?B?Uk5FK0hVeFZ2WXZEL1FDTlYrNFlyVUk2c0Q4RkpKdmVFZXg3NHZJTWJ2ZDJk?=
 =?utf-8?B?Ukc5S2lMeEQwU2xWWktKbHNVZjNHNTJRL25IWDlteVh0YXJyL1NueHdHUmY2?=
 =?utf-8?B?YkZYZ3pYN1M4SHZnc3VxMm16OEc4SjU0SkJDc05zKzd6WndoUlE5bzF2Q25X?=
 =?utf-8?B?dFZ5TFU4NXUvdU5YTjRPaFBqRkp1YmQrU0VlQ2VmYnJOdS85OVlYSytDWUli?=
 =?utf-8?B?MHZVeE90ZGpmWlhVY3gyUUhXU3dxSFc1RnQzNmErN2tRdHZuaThIbWkvQnM0?=
 =?utf-8?B?KzhpM1Mwb2U0cStuNGY1Rk91M2JEZyt6OG1CVXZqaWVpNnV0NEk1YWtZcWFj?=
 =?utf-8?B?L1l2SnhPaUZ1N21McmwwSmFTaDZWV3pXeWtOdzdFRkJmdjZvcUZ1alJBMXJt?=
 =?utf-8?B?RkhpUzVmbTRkbTYrczd4Z0dBcmJpeFQ2alZOY3pWd0kva1o0aU9mNGpsaWhI?=
 =?utf-8?B?SVFuTjJKOFN1cmdFZjA3UTZmU1FZMEJjQTBOc0psQTFQRnQydDhkcDFHM2to?=
 =?utf-8?B?OTJQMTdNY3NPL0x0OHEyNzFOMEZZK0Zkb2R3b3RLUFE2MTNwVTNZMEVLSGNz?=
 =?utf-8?B?aWkwWkRMMzR1enhYSWxxY1pmbm1QbkNLaXl1ejBKN1E2R2ZNRWN4Mjdick9k?=
 =?utf-8?B?WVd4a3ByOGVYdGFMRGswMzRtNzhycDFncWdwVWt4a0xHNXF3NnRRMWlGajhj?=
 =?utf-8?B?WGU1TThjM0l3NUFaTEtzbE02QThlQWhoZC9xS3NoTVU2Vld4U3FrQ3hSZENn?=
 =?utf-8?B?NWRPaFlHSmhUQTJZQ05ReDBuYVgwOVMrZkFhTmg1Y1I1c1dKdU9aVytnTFNi?=
 =?utf-8?B?YXo4TU1TZGcyOHd2ZStzSzRMb0I0SVNpNVhhaEFpeEVSYUVYbmg0WGxuUy9E?=
 =?utf-8?B?YUk3R2VCL2VEOUtFOHlDOXJFNldxK3pnbFR5TG5MOUJDUTBZRDNtQS9nZElU?=
 =?utf-8?B?T2tHZGlXOFBrbnFROERhWTRSbVVmSXdBSVZsUDc1RjhYM1IwNzFvaFNKQXI2?=
 =?utf-8?B?SlNBc2hZUStGVlExazk2QkpTZHZIWUFmZkRVOHoraGNZdVBOaXExVFdRYVg2?=
 =?utf-8?B?d1VHUlV2N3FXVlBia1ZNb1FCR2pTUnFkeURTRTAydUJ5Y2E4NXdCaFpGcngz?=
 =?utf-8?B?OW96YjFTbnJwbWl0L2hnbW11bTdPV0taOGlHbWNVYUpON2UwcXg4N1hvc2pp?=
 =?utf-8?B?V1VES0h0YTFXMmMwOHpEV2t0UGI1MDRmWXZqWUNON1ZzdjFZd1BFTXg3T21a?=
 =?utf-8?B?Y0luYzZGcmxPR0hiVnl5eFN6dU5TajJuZTIrUkt3L1F6LzBGZC9zTzNUdHNH?=
 =?utf-8?B?U2hWeXdwTmNsUTg5cmdrWlhIdVZtQUI5bmt1Q0xNdUZiZ1lRK2psMk9uMXZJ?=
 =?utf-8?B?aFJnanJPaS9ubTF1ZTNEZzhZMzZHSy9iSFRKTDlieGhGTGI5QkxYZyttRUFV?=
 =?utf-8?B?MUVLcm9iT09kazFvN0hLRGkvNC8ybjdNTitwYzF1VVd3eHNHbnIrNHZpR0Iy?=
 =?utf-8?B?TGZMMHB0Yk9Qbk1yaWhjZTFhUURCYldacjJIQXkyWmhTVzdXMEdZcWFzaTZT?=
 =?utf-8?B?ZDBDMWU2VVJBTmFtUUVGOVdDOE1KSmdlRkxJVkNOS1ZtS1VpOW1FQ3VCbElR?=
 =?utf-8?B?Zzd1YkZyaUtsL3dzL3JwQ0dmZGl4elhYdEhzQ1l0bFVqT0svMFcvajB6eDAr?=
 =?utf-8?B?TVE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f53bb2cb-32a3-4af1-ce66-08db5b46e5c3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 04:33:46.5913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RHYiJqEVwhkCPlTRBzMZp8TSrBifQt1dAhiAhlsBueR44sqIznSVsSNuAbrIF2Gs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3787
X-Proofpoint-GUID: Uueothdam9oXZJmqrAQiriyd917ObfPE
X-Proofpoint-ORIG-GUID: Uueothdam9oXZJmqrAQiriyd917ObfPE
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_02,2023-05-22_03,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/21/23 6:39 AM, Teng Qi wrote:
> Thank you.
> 
>  > Your above analysis makes sense if indeed that kvfree cannot appear
>  > inside a spin lock region or RCU read lock region. But is it true?
>  > I checked a few code paths in kvfree/kfree. It is either guarded
>  > with local_irq_save/restore or by
>  > spin_lock_irqsave/spin_unlock_
>  > irqrestore, etc. Did I miss
>  > anything? Are you talking about RT kernel here?
> 
> To see the sleepable possibility of kvfree, it is important to analyze the
> following calling stack:
> mm/util.c: 645 kvfree()
> mm/vmalloc.c: 2763 vfree()
> 
> In kvfree(), to call vfree, if the pointer addr points to memory 
> allocated by
> vmalloc(), it calls vfree().
> void kvfree(const void *addr)
> {
>          if (is_vmalloc_addr(addr))
>                  vfree(addr);
>          else
>                  kfree(addr);
> }
> 
> In vfree(), in_interrupt() and might_sleep() need to be considered.
> void vfree(const void *addr)
> {
>          // ...
>          if (unlikely(in_interrupt()))
>          {
>                  vfree_atomic(addr);
>                  return;
>          }
>          // ...
>          might_sleep();
>          // ...
> }

Sorry. I didn't check vfree path. So it does look like that
we need to pay special attention to non interrupt part.

> 
> The vfree() may sleep if in_interrupt() == false. The RCU read lock region
> could have in_interrupt() == false and spin lock region which only disables
> preemption also has in_interrupt() == false. So the kvfree() cannot appear
> inside a spin lock region or RCU read lock region if the pointer addr points
> to memory allocated by vmalloc().
> 
>  > > Therefore, we propose modifying the condition to include
>  > > in_atomic(). Could we
>  > > update the condition as follows: "in_irq() || irqs_disabled() ||
>  > > in_atomic()"?
>  > Thank you! We look forward to your feedback.
> 
> We now think that ‘irqs_disabled() || in_atomic() || 
> rcu_read_lock_held()’ is
> more proper. irqs_disabled() is for irq flag reg, in_atomic() is for
> preempt count and rcu_read_lock_held() is for RCU read lock region.

We cannot use rcu_read_lock_held() in the 'if' statement. The return
value rcu_read_lock_held() could be 1 for some configuraitons regardless
whether rcu_read_lock() is really held or not. In most cases,
rcu_read_lock_held() is used in issuing potential warnings.
Maybe there are other ways to record whether rcu_read_lock() is held or not?

I agree with your that 'irqs_disabled() || in_atomic()' makes sense
since it covers process context local_irq_save() and spin_lock() cases.

If we cannot resolve rcu_read_lock() presence issue, maybe the condition
can be !in_interrupt(), so any process-context will go to a workqueue.

Alternatively, we could have another solution. We could add another
function e.g., bpf_prog_put_rcu(), which indicates that bpf_prog_put()
will be done in rcu context. So if in_interrupt(), do kvfree, otherwise,
put into a workqueue.


> 
> -- Teng Qi
> 
> On Sun, May 21, 2023 at 11:45 AM Yonghong Song <yhs@meta.com 
> <mailto:yhs@meta.com>> wrote:
> 
> 
> 
>     On 5/19/23 7:18 AM, Teng Qi wrote:
>      > Thank you for your response.
>      >  > Looks like you only have suspicion here. Could you find a real
>     violation
>      >  > here where __bpf_prog_put() is called with !in_irq() &&
>      >  > !irqs_disabled(), but inside spin_lock or rcu read lock? I
>     have not seen
>      >  > things like that.
>      >
>      > For the complex conditions to call bpf_prog_put() with 1 refcnt,
>     we have
>      > been
>      > unable to really trigger this atomic violation after trying to
>     construct
>      > test cases manually. But we found that it is possible to show
>     cases with
>      > !in_irq() && !irqs_disabled(), but inside spin_lock or rcu read lock.
>      > For example, even a failed case, one of selftest cases of bpf,
>     netns_cookie,
>      > calls bpf_sock_map_update() and may indirectly call bpf_prog_put()
>      > only inside rcu read lock: The possible call stack is:
>      > net/core/sock_map.c: 615 bpf_sock_map_update()
>      > net/core/sock_map.c: 468 sock_map_update_common()
>      > net/core/sock_map.c:  217 sock_map_link()
>      > kernel/bpf/syscall.c: 2111 bpf_prog_put()
>      >
>      > The files about netns_cookie include
>      > tools/testing/selftests/bpf/progs/netns_cookie_prog.c and
>      > tools/testing/selftests/bpf/prog_tests/netns_cookie.c. We
>     inserted the
>      > following code in
>      > ‘net/core/sock_map.c: 468 sock_map_update_common()’:
>      > static int sock_map_update_common(..)
>      > {
>      >          int inIrq = in_irq();
>      >          int irqsDisabled = irqs_disabled();
>      >          int preemptBits = preempt_count();
>      >          int inAtomic = in_atomic();
>      >          int rcuHeld = rcu_read_lock_held();
>      >          printk("in_irq() %d, irqs_disabled() %d, preempt_count() %d,
>      >            in_atomic() %d, rcu_read_lock_held() %d", inIrq,
>     irqsDisabled,
>      >            preemptBits, inAtomic, rcuHeld);
>      > }
>      >
>      > The output message is as follows:
>      > root@(none):/root/bpf# ./test_progs -t netns_cookie
>      > [  137.639188] in_irq() 0, irqs_disabled() 0, preempt_count() 0,
>      > in_atomic() 0,
>      >          rcu_read_lock_held() 1
>      > #113     netns_cookie:OK
>      > Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
>      >
>      > We notice that there are numerous callers in kernel/, net/ and
>     drivers/,
>      > so we
>      > highly suggest modifying __bpf_prog_put() to address this gap.
>     The gap
>      > exists
>      > because __bpf_prog_put() is only safe under in_irq() ||
>     irqs_disabled()
>      > but not in_atomic() || rcu_read_lock_held(). The following code
>     snippet may
>      > mislead developers into thinking that bpf_prog_put() is safe in all
>      > contexts.
>      > if (in_irq() || irqs_disabled()) {
>      >          INIT_WORK(&aux->work, bpf_prog_put_deferred);
>      >          schedule_work(&aux->work);
>      > } else {
>      >          bpf_prog_put_deferred(&aux->work);
>      > }
>      >
>      > Implicit dependency may lead to issues.
>      >
>      >  > Any problem here?
>      > We mentioned it to demonstrate the possibility of kvfree() being
>      > called by __bpf_prog_put_noref().
>      >
>      > Thanks.
>      > -- Teng Qi
>      >
>      > On Wed, May 17, 2023 at 1:08 AM Yonghong Song <yhs@meta.com
>     <mailto:yhs@meta.com>
>      > <mailto:yhs@meta.com <mailto:yhs@meta.com>>> wrote:
>      >
>      >
>      >
>      >     On 5/16/23 4:18 AM, starmiku1207184332@gmail.com
>     <mailto:starmiku1207184332@gmail.com>
>      >     <mailto:starmiku1207184332@gmail.com
>     <mailto:starmiku1207184332@gmail.com>> wrote:
>      >      > From: Teng Qi <starmiku1207184332@gmail.com
>     <mailto:starmiku1207184332@gmail.com>
>      >     <mailto:starmiku1207184332@gmail.com
>     <mailto:starmiku1207184332@gmail.com>>>
>      >      >
>      >      > Hi, bpf developers,
>      >      >
>      >      > We are developing a static tool to check the matching between
>      >     helpers and the
>      >      > context of hooks. During our analysis, we have discovered some
>      >     important
>      >      > findings that we would like to report.
>      >      >
>      >      > ‘kernel/bpf/syscall.c: 2097 __bpf_prog_put()’ shows that
>     function
>      >      > bpf_prog_put_deferred() won`t be called in the condition of
>      >      > ‘in_irq() || irqs_disabled()’.
>      >      > if (in_irq() || irqs_disabled()) {
>      >      >      INIT_WORK(&aux->work, bpf_prog_put_deferred);
>      >      >      schedule_work(&aux->work);
>      >      > } else {
>      >      >
>      >      >      bpf_prog_put_deferred(&aux->work);
>      >      > }
>      >      >
>      >      > We suspect this condition exists because there might be
>     sleepable
>      >     operations
>      >      > in the callees of the bpf_prog_put_deferred() function:
>      >      > kernel/bpf/syscall.c: 2097 __bpf_prog_put()
>      >      > kernel/bpf/syscall.c: 2084 bpf_prog_put_deferred()
>      >      > kernel/bpf/syscall.c: 2063 __bpf_prog_put_noref()
>      >      > kvfree(prog->aux->jited_linfo);
>      >      > kvfree(prog->aux->linfo);
>      >
>      >     Looks like you only have suspicion here. Could you find a real
>      >     violation
>      >     here where __bpf_prog_put() is called with !in_irq() &&
>      >     !irqs_disabled(), but inside spin_lock or rcu read lock? I
>     have not seen
>      >     things like that.
>      >
>      >      >
>      >      > Additionally, we found that array prog->aux->jited_linfo is
>      >     initialized in
>      >      > ‘kernel/bpf/core.c: 157 bpf_prog_alloc_jited_linfo()’:
>      >      > prog->aux->jited_linfo = kvcalloc(prog->aux->nr_linfo,
>      >      >    sizeof(*prog->aux->jited_linfo),
>     bpf_memcg_flags(GFP_KERNEL |
>      >     __GFP_NOWARN));
>      >
>      >     Any problem here?
>      >
>      >      >
>      >      > Our question is whether the condition 'in_irq() ||
>      >     irqs_disabled() == false' is
>      >      > sufficient for calling 'kvfree'. We are aware that calling
>      >     'kvfree' within the
>      >      > context of a spin lock or an RCU lock is unsafe.
> 
>     Your above analysis makes sense if indeed that kvfree cannot appear
>     inside a spin lock region or RCU read lock region. But is it true?
>     I checked a few code paths in kvfree/kfree. It is either guarded
>     with local_irq_save/restore or by
>     spin_lock_irqsave/spin_unlock_irqrestore, etc. Did I miss
>     anything? Are you talking about RT kernel here?
> 
> 
>      >      >
>      >      > Therefore, we propose modifying the condition to include
>      >     in_atomic(). Could we
>      >      > update the condition as follows: "in_irq() ||
>     irqs_disabled() ||
>      >     in_atomic()"?
>      >      >
>      >      > Thank you! We look forward to your feedback.
>      >      >
>      >      > Signed-off-by: Teng Qi <starmiku1207184332@gmail.com
>     <mailto:starmiku1207184332@gmail.com>
>      >     <mailto:starmiku1207184332@gmail.com
>     <mailto:starmiku1207184332@gmail.com>>>
>      >
> 

