Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC6E52E178
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344171AbiETBB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiETBB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:01:26 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C9E1BE8E;
        Thu, 19 May 2022 18:01:22 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24JKmX4c030846;
        Thu, 19 May 2022 18:01:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=fqUG95qD0evKqquvbbGgoKElSR52Fevn6LfIJNEYSBY=;
 b=n+7ERVVrF37jb3hcyia+h2na+2jT8olkgY/q2wAVz43yBsl4rBbG3pH8YR1Gm3LuJ68A
 Y4Gg7HPGi4kRYS2zG+C8N8D7AeobpJrnIM1hhc7tWgyEghoaeK3BG6D/J8fvry1lAP/a
 otRdi+bwWKvEkXhQzJvW2+4nMukNq2ZBp64= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g59tbrar2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 18:01:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CX47oany/+eMVy+bPKrqKJFjNgfTZlaoy+T1SK1pBXCIg0gTcSZxcwYkJjeuy2QfBz+/OjMrWDqgXPIVuryCejDPDVQnR4f8Zwh6BiqZKCP4PxxV9SqOEKlFuxdAzmppWv85wVwTLRPnlOXUdlpJOKLcnhEYJ8cx6c8lZEMEU62BUvYKWUtI+GV6lIYDqAwoTbJskA3demnsTLljkmBlptA89RzLtv2q+kQpjxHgqTYLxpUEXuq370apIMXhFdafs5b/lpjlr2RJz9laCUs+l0OOIbjX9tKK3RdVz5Wdoppf5pFXv3hE1x0kohqxxQQ6SEiCZ3uI3UmWa3i2mWu0jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fqUG95qD0evKqquvbbGgoKElSR52Fevn6LfIJNEYSBY=;
 b=XDoz2VQB7BBT56AKfxxXkhYRM62KhMBlVdiRUL0uBFH5WenfbnkqR02RgX9w5vKhi4ObTCNLAa3US/g/Z9nxcMo3bL57W0WPwN0hr1xH01HOE5XygR1crXfqlavLwmA4mmD6Oka6iTtlxlt6aExfV92wHPo6uEGCmmtXtvzE3WCZ4wz3xYceraZeqC54Wc06jx1n9IxcVDsdnTt3hOh8HRJJwFiqNnzjVGn8H0EBRo1iWoGnKSwtNzK2d3SePqbxIVYTzUjUFOmcJRc4BQqRfRbCYBy/Uuh/hYcORYXTI/l5A8kN6C3gbgRgRHOwZyd9JsA9gsfX2dswq4RTRlpaYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MW4PR15MB5134.namprd15.prod.outlook.com (2603:10b6:303:182::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 01:01:01 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.015; Fri, 20 May 2022
 01:01:01 +0000
Message-ID: <36bdf09d-dfb7-6e3e-fb62-bae856c57bc2@fb.com>
Date:   Thu, 19 May 2022 18:00:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v7 03/11] bpf: per-cgroup lsm flavor
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
References: <20220518225531.558008-1-sdf@google.com>
 <20220518225531.558008-4-sdf@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220518225531.558008-4-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0036.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::49) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45f5c5a8-e5be-4da1-cfcc-08da39fc34f9
X-MS-TrafficTypeDiagnostic: MW4PR15MB5134:EE_
X-Microsoft-Antispam-PRVS: <MW4PR15MB5134261C8C6F42429AD60AC8D3D39@MW4PR15MB5134.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l/f2nfPRdLv9NQPEqMbMkaEE+RJsOGdQwlHPw2cf281QwLQ58Nx6t2IdABuwEC/LtN8LkdKM4/mF7Pohw4//SD4OxZOuUnnLfnMgQndJBzLwlVSChypwPxD/MQRvONfjfJV/BlBx5Yecq3DBs9TX66lXQioqgCT8iQrE2w2kfHIijaZbvmSXNm57vSQ00f9kpGS49C7rLOibP8ULKRmBFbLXCN2j8fYVUtr4jdc8V5kG9644W89Si+fq8c+T3XJkGiOt7NQy1qlItEoqaH6yiAOktwudBsPoDsnZ9lwwrlJl5+4AQIJqGWoU3yY7afWgND4vSV/LCzzeCtY3GRsDlrdJrHDtod4cofjtg1KeSbirHr9qIsmeIoxjFgArUgcJGYaHRzsCgbza00ZD25k64REDbAnk0w6h6C0r5gX53QxJSgy5+fgHcRMB5Yn5LcNz6t3fCL+ZVfRdKtnrxdDTby0SVyj0wlWRKWEwENfIs5vwAaDq2PENQhl2K88tHXlgamjhQZ4Mjoq/STTfk7or0u78yhKMFsOMu1hSDDuJmQ3cR7H4OJyuEfJACesyYltFcvSwLdBjyre2n4uyh/zGWf3jz41+Kebh6PYAd3P2jnJklHduVkMoIxqGvRv8Osm6Hfc4hNpJbBwERSXXSeYyJ+DqvIal6aPNAFIUHNU7zl8NZ5aWJhgRB6kTKjBmUZbzOgu8GXejkVbRw7IIpzpEdq9nHjk4GbsswcYU5waoQskZP8/INiPxj8ZYEE/d1nmh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(316002)(86362001)(31696002)(186003)(31686004)(36756003)(66556008)(4326008)(66946007)(66476007)(8676002)(5660300002)(53546011)(6506007)(52116002)(2616005)(8936002)(508600001)(6512007)(38100700002)(2906002)(6486002)(30864003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QmgrNWNQck01YWRSNDRLL1JGYkFMQ3R4aklBdzlIWW5RRU80MXpTZHo0L3Ru?=
 =?utf-8?B?VXhsNWovZk5LVGR3NmJjQ2RRS3ErY2R1YzJyYjNTc1JrNklKWnZsdURZcGtT?=
 =?utf-8?B?N3JhV1JTMlVuTjhBQVdsSGZpMGFZcTlLQ1NRSEtDN2Npb3lFSFNjQk5IZnVw?=
 =?utf-8?B?Yy9TeGFWR2t3Tlk4VkFyb0xyZUpPZTNPUi9HQTc3UEFHZ05SY3VOVDFBSDlR?=
 =?utf-8?B?NWQ0SGNibzI3dmJPS3c3VjNBelVHcWhjcEVxQkU3ZVZVYTR5aFNPRmF0RzRD?=
 =?utf-8?B?c0Z3VzFCNVF5U3lhWkM3cUVQZDJRUjR1UU9LSUh5MTZGdlprb0NFbThTWGRL?=
 =?utf-8?B?Z3JXZWZLTUU4SnRERFE0UnlxWkJlcU9sNGFjUTQ5SWNCd1NTNm9uWXFLYnQx?=
 =?utf-8?B?Z2MxMnNNUmVWaDVOaE1FVXd2TUw3T25hS0FqKzdTc200cm5kbXJkbXJJLzhR?=
 =?utf-8?B?RldqWVJDQTgrYm91bzJlbVZ0c25RRktoSHIzcFhSRnFxVWZ5TFQ1RlFaSHFq?=
 =?utf-8?B?TzZTQkwwYW1lN25YVmFONS9YZ05sNlFaTG5PRmphT0k0aUgzclZnM21FVEJ4?=
 =?utf-8?B?cmVQUlpabnFBTG5XTUQzVk9IbUVOYW9UZFhRdEZaQXRXZ3RCNi9vSUZVVElB?=
 =?utf-8?B?QUVPVmJPbHltTUt2cXZYVjAwQnNYTHNRbVNHeTRGRk1kcFRJdDZqUFliNkla?=
 =?utf-8?B?Y2xqS1loRFQzazdocEJmTjZUNm1lWTl3eHh1K2NJYXZ1MU5LRXRHL2FzRE9K?=
 =?utf-8?B?RTUya3F6VFRQam1mZzM5SFJzY1puSFhzaWxnaFBkU3YvcG92b1d6MU1leTZP?=
 =?utf-8?B?dnpkUzdZZk5iSGxDNHpKQk1wM3BIVWVFWTh6d0tzQzA2Wm16L2xqQ1cxdEtH?=
 =?utf-8?B?d1M2a0NyeHd5Y1dpNjVJb1pBR3ZCWjZmSGU5c1dVMHEySi9tVm85RG9sNFh4?=
 =?utf-8?B?ckthVDJKcTlXVllZNWJ4YjNsODJOTTZPT09ablNUVVVFUFh3WU1BdHNobUZJ?=
 =?utf-8?B?OG5kU3p3WEFKN1hUUjFTZ0JXSjBtbWtzQ3ZDRUs4TVVxMFZEeVorMnBOQmFI?=
 =?utf-8?B?WHdRaTFSL25pUFpGWVNNVHA5Y01ETVdwWWc5TWRydGNhZXgvVFNEYkRraEJM?=
 =?utf-8?B?NnlLbHZzYVJRWUxRNWhEY3J1NFlDbXhEQlljSDRiSU9VekJOWVdqN05aUFQ3?=
 =?utf-8?B?VXRkRVJTNEpyRFk0OXQ1T0V4T09obUVyVDE2T0dVaWtxY2ZjNm9URldQV1pG?=
 =?utf-8?B?Vm5VQ1dNKzVFdWV0eDVlSlN0WUM5b09BckJWM2pXY05kZm9QNmQvcm5DbTZy?=
 =?utf-8?B?YklaVW1Rb3JBeEZaZjgzd3pSYy8zKytSVWtxRjE5T2xqbkNNOFpUTEhZcUVL?=
 =?utf-8?B?L2RpV0xuVU9WS2ZDa2x6NS9BbXF3cURGRDh2TmlPUGZzYVFKQ3llaCtVNzIz?=
 =?utf-8?B?cDIrMml6SnQxaWpYb2wrNEZxZXFlTHhGa05LTnR6WnIwRGt0RUJYWkhGTnJX?=
 =?utf-8?B?VDcrUEZ0eWRwYWdia05aSXhWQ1pId3NxalJnRzBQZm5lcDA0K0FRaUtpRHRM?=
 =?utf-8?B?bVFyaHZRRlhOQ0dDcEV5cmlVaWNWcW9ZN2VGL3gwY1pDb09LVnlQTHFvUVpn?=
 =?utf-8?B?a0o5T0xxMWUreEx2NWhlSDc1c0ZFcVBRcGZ3WWJqTE5wUEJjQm5TVjVWRURX?=
 =?utf-8?B?QWg0ZGhRem5QbHIwOUQ4b0tDRGZBeU5BRG5UcUlhL08rc2EvTDMxalBIdmF3?=
 =?utf-8?B?NGpqVVcvWUJoQW1yNmU1Q004c1A3RlJRVyt5UnhPWG5tcDVUVWNFZWJ0VlM0?=
 =?utf-8?B?Z3BzK1ZpQm5WN01KNmxFZXkxM2lIdTczcFJHelMrYmFTeEtsWGJMbGdyVjRP?=
 =?utf-8?B?b2dMTkc4b3NYeGpiaWRxQStQQXRMQjIvaWFHODhXcnpiZC9UV2lJVisxaGt0?=
 =?utf-8?B?SGd5elVpSnB2ZWd2NWdjZVdTeVNZR3lMV3VDZUVDLzB1V2JHandjSUhvbWRP?=
 =?utf-8?B?aktCN3EzODE0bjNRaXBSbXM0dkxoN3E4NUpiTnVRcUd4WmszQzZLUmhrTURK?=
 =?utf-8?B?UG91b2tWeXhMSlFlT1dxZ2JTWVpsTWdkR0dvaVpZNHF3UGRzYUNlUVJVMnpo?=
 =?utf-8?B?OGV0Sk9HdFBkVUltV2RYdEo4SXg3dG4zcTJKeXM1SGJGNXNCT3laZEpjTWdD?=
 =?utf-8?B?MTNmUzBiR3EvblgycEhSMjRkSks0OUhDRkQxSVJtNk1kNXUvcGsvSzZBQjNG?=
 =?utf-8?B?clBDMWgxaHR1cEcxVHIzZlVxdmZ2YTNsVEhDRXZPc0hjMW02MFNxNXNGSWYx?=
 =?utf-8?B?d1ZUYzk4Wlk1bThWdXpSTFNIZXlBKzRSbHJONFdEUTgrWVNyZE5hejdHeXc2?=
 =?utf-8?Q?RCNl9HMgIm8u7FX8=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45f5c5a8-e5be-4da1-cfcc-08da39fc34f9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 01:01:01.0925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ql5NSTpCzbCZt+NmDj6y6KfRutLlOIfh9AmwpiY+XNYGGTgKhuhf1iuGbR/u1cjp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB5134
X-Proofpoint-ORIG-GUID: -oeeh73_0hTJ_mafS6p8fQ8hhXY5swIb
X-Proofpoint-GUID: -oeeh73_0hTJ_mafS6p8fQ8hhXY5swIb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-19_06,2022-05-19_03,2022-02-23_01
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



On 5/18/22 3:55 PM, Stanislav Fomichev wrote:
> Allow attaching to lsm hooks in the cgroup context.
> 
> Attaching to per-cgroup LSM works exactly like attaching
> to other per-cgroup hooks. New BPF_LSM_CGROUP is added
> to trigger new mode; the actual lsm hook we attach to is
> signaled via existing attach_btf_id.
> 
> For the hooks that have 'struct socket' or 'struct sock' as its first
> argument, we use the cgroup associated with that socket. For the rest,
> we use 'current' cgroup (this is all on default hierarchy == v2 only).
> Note that for some hooks that work on 'struct sock' we still
> take the cgroup from 'current' because some of them work on the socket
> that hasn't been properly initialized yet.
> 
> Behind the scenes, we allocate a shim program that is attached
> to the trampoline and runs cgroup effective BPF programs array.
> This shim has some rudimentary ref counting and can be shared
> between several programs attaching to the same per-cgroup lsm hook.
> 
> Note that this patch bloats cgroup size because we add 211
> cgroup_bpf_attach_type(s) for simplicity sake. This will be
> addressed in the subsequent patch.
> 
> Also note that we only add non-sleepable flavor for now. To enable
> sleepable use-cases, bpf_prog_run_array_cg has to grab trace rcu,
> shim programs have to be freed via trace rcu, cgroup_bpf.effective
> should be also trace-rcu-managed + maybe some other changes that
> I'm not aware of.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>   arch/x86/net/bpf_jit_comp.c     |  24 +++--
>   include/linux/bpf-cgroup-defs.h |   6 ++
>   include/linux/bpf-cgroup.h      |   7 ++
>   include/linux/bpf.h             |  25 +++++
>   include/linux/bpf_lsm.h         |  14 +++
>   include/linux/btf_ids.h         |   3 +-
>   include/uapi/linux/bpf.h        |   1 +
>   kernel/bpf/bpf_lsm.c            |  50 +++++++++
>   kernel/bpf/btf.c                |  11 ++
>   kernel/bpf/cgroup.c             | 181 ++++++++++++++++++++++++++++---
>   kernel/bpf/core.c               |   2 +
>   kernel/bpf/syscall.c            |  10 ++
>   kernel/bpf/trampoline.c         | 184 ++++++++++++++++++++++++++++++++
>   kernel/bpf/verifier.c           |  28 +++++
>   tools/include/linux/btf_ids.h   |   4 +-
>   tools/include/uapi/linux/bpf.h  |   1 +
>   16 files changed, 527 insertions(+), 24 deletions(-)

A few nits below.

> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index a2b6d197c226..5cdebf4312da 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -1765,6 +1765,10 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
>   			   struct bpf_tramp_link *l, int stack_size,
>   			   int run_ctx_off, bool save_ret)
>   {
> +	void (*exit)(struct bpf_prog *prog, u64 start,
> +		     struct bpf_tramp_run_ctx *run_ctx) = __bpf_prog_exit;
> +	u64 (*enter)(struct bpf_prog *prog,
> +		     struct bpf_tramp_run_ctx *run_ctx) = __bpf_prog_enter;
>   	u8 *prog = *pprog;
>   	u8 *jmp_insn;
>   	int ctx_cookie_off = offsetof(struct bpf_tramp_run_ctx, bpf_cookie);
[...]
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index ea3674a415f9..70cf1dad91df 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -768,6 +768,10 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start, struct bpf_tramp_
>   u64 notrace __bpf_prog_enter_sleepable(struct bpf_prog *prog, struct bpf_tramp_run_ctx *run_ctx);
>   void notrace __bpf_prog_exit_sleepable(struct bpf_prog *prog, u64 start,
>   				       struct bpf_tramp_run_ctx *run_ctx);
> +u64 notrace __bpf_prog_enter_lsm_cgroup(struct bpf_prog *prog,
> +					struct bpf_tramp_run_ctx *run_ctx);
> +void notrace __bpf_prog_exit_lsm_cgroup(struct bpf_prog *prog, u64 start,
> +					struct bpf_tramp_run_ctx *run_ctx);
>   void notrace __bpf_tramp_enter(struct bpf_tramp_image *tr);
>   void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr);
>   
> @@ -1035,6 +1039,7 @@ struct bpf_prog_aux {
>   	u64 load_time; /* ns since boottime */
>   	u32 verified_insns;
>   	struct bpf_map *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
> +	int cgroup_atype; /* enum cgroup_bpf_attach_type */

Move cgroup_atype right after verified_insns to fill the existing gap?

>   	char name[BPF_OBJ_NAME_LEN];
>   #ifdef CONFIG_SECURITY
>   	void *security;
> @@ -1107,6 +1112,12 @@ struct bpf_tramp_link {
>   	u64 cookie;
>   };
>   
> +struct bpf_shim_tramp_link {
> +	struct bpf_tramp_link tramp_link;
> +	struct bpf_trampoline *tr;
> +	atomic64_t refcnt;
> +};
> +
>   struct bpf_tracing_link {
>   	struct bpf_tramp_link link;
>   	enum bpf_attach_type attach_type;
> @@ -1185,6 +1196,9 @@ struct bpf_dummy_ops {
>   int bpf_struct_ops_test_run(struct bpf_prog *prog, const union bpf_attr *kattr,
>   			    union bpf_attr __user *uattr);
>   #endif
> +int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
> +				    struct bpf_attach_target_info *tgt_info);
> +void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog);
>   #else
>   static inline const struct bpf_struct_ops *bpf_struct_ops_find(u32 type_id)
>   {
> @@ -1208,6 +1222,14 @@ static inline int bpf_struct_ops_map_sys_lookup_elem(struct bpf_map *map,
>   {
>   	return -EINVAL;
>   }
> +static inline int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
> +						  struct bpf_attach_target_info *tgt_info)
> +{
> +	return -EOPNOTSUPP;
> +}
> +static inline void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog)
> +{
> +}
>   #endif
>   
>   struct bpf_array {
> @@ -2250,6 +2272,8 @@ extern const struct bpf_func_proto bpf_loop_proto;
>   extern const struct bpf_func_proto bpf_strncmp_proto;
>   extern const struct bpf_func_proto bpf_copy_from_user_task_proto;
>   extern const struct bpf_func_proto bpf_kptr_xchg_proto;
> +extern const struct bpf_func_proto bpf_set_retval_proto;
> +extern const struct bpf_func_proto bpf_get_retval_proto;
>   
>   const struct bpf_func_proto *tracing_prog_func_proto(
>     enum bpf_func_id func_id, const struct bpf_prog *prog);
> @@ -2366,6 +2390,7 @@ void *bpf_arch_text_copy(void *dst, void *src, size_t len);
>   
>   struct btf_id_set;
>   bool btf_id_set_contains(const struct btf_id_set *set, u32 id);
> +int btf_id_set_index(const struct btf_id_set *set, u32 id);
>   
>   #define MAX_BPRINTF_VARARGS		12
>   
> diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
> index 479c101546ad..7f0e59f5f9be 100644
> --- a/include/linux/bpf_lsm.h
> +++ b/include/linux/bpf_lsm.h
> @@ -42,6 +42,9 @@ extern const struct bpf_func_proto bpf_inode_storage_get_proto;
>   extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
>   void bpf_inode_storage_free(struct inode *inode);
>   
> +int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
> +int bpf_lsm_hook_idx(u32 btf_id);
> +
>   #else /* !CONFIG_BPF_LSM */
>   
>   static inline bool bpf_lsm_is_sleepable_hook(u32 btf_id)
> @@ -65,6 +68,17 @@ static inline void bpf_inode_storage_free(struct inode *inode)
>   {
>   }
>   
> +static inline int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
> +					   bpf_func_t *bpf_func)
> +{
> +	return -ENOENT;
> +}
> +
> +static inline int bpf_lsm_hook_idx(u32 btf_id)
> +{
> +	return -EINVAL;
> +}
> +
>   #endif /* CONFIG_BPF_LSM */
>   
>   #endif /* _LINUX_BPF_LSM_H */
> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
> index bc5d9cc34e4c..857cc37094da 100644
> --- a/include/linux/btf_ids.h
> +++ b/include/linux/btf_ids.h
> @@ -178,7 +178,8 @@ extern struct btf_id_set name;
>   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)			\
>   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)			\
>   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)			\
> -	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UNIX, unix_sock)
> +	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UNIX, unix_sock)			\
> +	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCKET, socket)
>   
>   enum {
>   #define BTF_SOCK_TYPE(name, str) name,
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 0210f85131b3..b9d2d6de63a7 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -998,6 +998,7 @@ enum bpf_attach_type {
>   	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
>   	BPF_PERF_EVENT,
>   	BPF_TRACE_KPROBE_MULTI,
> +	BPF_LSM_CGROUP,
>   	__MAX_BPF_ATTACH_TYPE
>   };
>   
> diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> index c1351df9f7ee..654c23577ad3 100644
> --- a/kernel/bpf/bpf_lsm.c
> +++ b/kernel/bpf/bpf_lsm.c
> @@ -16,6 +16,7 @@
>   #include <linux/bpf_local_storage.h>
>   #include <linux/btf_ids.h>
>   #include <linux/ima.h>
> +#include <linux/bpf-cgroup.h>
>   
>   /* For every LSM hook that allows attachment of BPF programs, declare a nop
>    * function where a BPF program can be attached.
> @@ -35,6 +36,46 @@ BTF_SET_START(bpf_lsm_hooks)
>   #undef LSM_HOOK
>   BTF_SET_END(bpf_lsm_hooks)
>   
> +/* List of LSM hooks that should operate on 'current' cgroup regardless
> + * of function signature.
> + */
> +BTF_SET_START(bpf_lsm_current_hooks)
> +/* operate on freshly allocated sk without any cgroup association */
> +BTF_ID(func, bpf_lsm_sk_alloc_security)
> +BTF_ID(func, bpf_lsm_sk_free_security)
> +BTF_SET_END(bpf_lsm_current_hooks)
> +
> +int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
> +			     bpf_func_t *bpf_func)
> +{
> +	const struct btf_param *args;
> +
> +	if (btf_type_vlen(prog->aux->attach_func_proto) < 1 ||
> +	    btf_id_set_contains(&bpf_lsm_current_hooks,
> +				prog->aux->attach_btf_id)) {
> +		*bpf_func = __cgroup_bpf_run_lsm_current;
> +		return 0;
> +	}
> +
> +	args = btf_params(prog->aux->attach_func_proto);
> +
> +#ifdef CONFIG_NET
> +	if (args[0].type == btf_sock_ids[BTF_SOCK_TYPE_SOCKET])
> +		*bpf_func = __cgroup_bpf_run_lsm_socket;
> +	else if (args[0].type == btf_sock_ids[BTF_SOCK_TYPE_SOCK])
> +		*bpf_func = __cgroup_bpf_run_lsm_sock;
> +	else
> +#endif
> +		*bpf_func = __cgroup_bpf_run_lsm_current;
> +
> +	return 0;

This function always return 0, change the return type to void?

> +}
> +
> +int bpf_lsm_hook_idx(u32 btf_id)
> +{
> +	return btf_id_set_index(&bpf_lsm_hooks, btf_id);
> +}
> +
>   int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
>   			const struct bpf_prog *prog)
>   {
> @@ -158,6 +199,15 @@ bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   		return prog->aux->sleepable ? &bpf_ima_file_hash_proto : NULL;
>   	case BPF_FUNC_get_attach_cookie:
>   		return bpf_prog_has_trampoline(prog) ? &bpf_get_attach_cookie_proto : NULL;
> +	case BPF_FUNC_get_local_storage:
> +		return prog->expected_attach_type == BPF_LSM_CGROUP ?
> +			&bpf_get_local_storage_proto : NULL;
> +	case BPF_FUNC_set_retval:
> +		return prog->expected_attach_type == BPF_LSM_CGROUP ?
> +			&bpf_set_retval_proto : NULL;
> +	case BPF_FUNC_get_retval:
> +		return prog->expected_attach_type == BPF_LSM_CGROUP ?
> +			&bpf_get_retval_proto : NULL;
>   	default:
>   		return tracing_prog_func_proto(func_id, prog);
>   	}
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 2f0b0440131c..a90f04a8a8ee 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -5248,6 +5248,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>   
>   	if (arg == nr_args) {
>   		switch (prog->expected_attach_type) {
> +		case BPF_LSM_CGROUP:
>   		case BPF_LSM_MAC:
>   		case BPF_TRACE_FEXIT:
>   			/* When LSM programs are attached to void LSM hooks
> @@ -6726,6 +6727,16 @@ static int btf_id_cmp_func(const void *a, const void *b)
>   	return *pa - *pb;
>   }
>   
> +int btf_id_set_index(const struct btf_id_set *set, u32 id)
> +{
> +	const u32 *p;
> +
> +	p = bsearch(&id, set->ids, set->cnt, sizeof(u32), btf_id_cmp_func);
> +	if (!p)
> +		return -1;
> +	return p - set->ids;
> +}
> +
>   bool btf_id_set_contains(const struct btf_id_set *set, u32 id)
>   {
>   	return bsearch(&id, set->ids, set->cnt, sizeof(u32), btf_id_cmp_func) != NULL;
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 134785ab487c..2c356a38f4cf 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -14,6 +14,9 @@
>   #include <linux/string.h>
>   #include <linux/bpf.h>
>   #include <linux/bpf-cgroup.h>
> +#include <linux/btf_ids.h>
> +#include <linux/bpf_lsm.h>
> +#include <linux/bpf_verifier.h>
>   #include <net/sock.h>
>   #include <net/bpf_sk_storage.h>
>   
> @@ -61,6 +64,85 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
>   	return run_ctx.retval;
>   }
>   
> +unsigned int __cgroup_bpf_run_lsm_sock(const void *ctx,
> +				       const struct bpf_insn *insn)
> +{
> +	const struct bpf_prog *shim_prog;
> +	struct sock *sk;
> +	struct cgroup *cgrp;
> +	int ret = 0;
> +	u64 *regs;
> +
> +	regs = (u64 *)ctx;
> +	sk = (void *)(unsigned long)regs[BPF_REG_0];

Maybe just my own opinion. Using BPF_REG_0 as index is a little bit
confusing. Maybe just use '0' to indicate the first parameters.
Maybe change 'regs' to 'params' is also a better choice?
In reality, trampline just passed an array of parameters to
the program. The same for a few places below.

> +	/*shim_prog = container_of(insn, struct bpf_prog, insnsi);*/
> +	shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));

I didn't experiment, but why container_of won't work?

> +
> +	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> +	if (likely(cgrp))
> +		ret = bpf_prog_run_array_cg(&cgrp->bpf,
> +					    shim_prog->aux->cgroup_atype,
> +					    ctx, bpf_prog_run, 0, NULL);
> +	return ret;
> +}
> +
> +unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
> +					 const struct bpf_insn *insn)
> +{
> +	const struct bpf_prog *shim_prog;
> +	struct socket *sock;
> +	struct cgroup *cgrp;
> +	int ret = 0;
> +	u64 *regs;
> +
> +	regs = (u64 *)ctx;
> +	sock = (void *)(unsigned long)regs[BPF_REG_0];
> +	/*shim_prog = container_of(insn, struct bpf_prog, insnsi);*/
> +	shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> +
> +	cgrp = sock_cgroup_ptr(&sock->sk->sk_cgrp_data);
> +	if (likely(cgrp))
> +		ret = bpf_prog_run_array_cg(&cgrp->bpf,
> +					    shim_prog->aux->cgroup_atype,
> +					    ctx, bpf_prog_run, 0, NULL);
> +	return ret;
> +}
> +
> +unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
> +					  const struct bpf_insn *insn)
> +{
> +	const struct bpf_prog *shim_prog;
> +	struct cgroup *cgrp;
> +	int ret = 0;
> +
> +	if (unlikely(!current))
> +		return 0;

I think we don't need this check.

> +
> +	/*shim_prog = container_of(insn, struct bpf_prog, insnsi);*/
> +	shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> +
> +	rcu_read_lock();
> +	cgrp = task_dfl_cgroup(current);
> +	if (likely(cgrp))
> +		ret = bpf_prog_run_array_cg(&cgrp->bpf,
> +					    shim_prog->aux->cgroup_atype,
> +					    ctx, bpf_prog_run, 0, NULL);
> +	rcu_read_unlock();
> +	return ret;
> +}
> +
[...]
