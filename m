Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8220D52E09A
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 01:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343633AbiESXeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 19:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236252AbiESXep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 19:34:45 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2EB111BAA;
        Thu, 19 May 2022 16:34:43 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24JKmW5U017185;
        Thu, 19 May 2022 16:34:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=k7y9lwfc1rlFWxxPQQ+PCKMFdGCzq20z3+jh6B8qI7c=;
 b=fvgI9/0WQ7SFxvY4vfmiqqJ4nnYgOMJRuImAEUrJnQlgBj04PPoFcqiHFRI/7FfMpp4F
 6MA3zT1JY+n2r9WIzTFZRihsa25mW4VHmvZkuiz0+hcj13Vs7Jn7IlfV23vFOFICIMB+
 LGyL4fHJkauVo5YyMHn9Bst1k48AZvicfGQ= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g5pj4vbv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 16:34:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UbmZ9keGCPky+a5G/znrDZSLscbWIenHnGXnVjwjiGPSZ8KMo/Y/DXLnHtORFPpRhRofyJxGR34OhwV9DVtAKUyB0mBB+lLeI2x3v2AQLVeylnmE+u82tgP/adQ5nC17BHIF/ceWvSrJ58P9TcFZemxEm0JWCrBl3Gs4y5kvKYWjay9xOu4WXwfeeajTGQoEkf5JSNn55Ir0yRXk5VhoKYvzmvqdYwcj+Wo04sS+SiOaCw7oI90W+vFx8QUvDAgDI1L6FfvG7aV4N/I3DYTYt2lD7mg4BDS6W3HxqcWYtGaZRRk6Vd6xsMWMhotqZyR/R5PS56FfU9+48/+AOTYN3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k7y9lwfc1rlFWxxPQQ+PCKMFdGCzq20z3+jh6B8qI7c=;
 b=j2F4Kts6TOw5FAC88A83QwEcUMwlPIaPdC39x6+5wNcsGB4SNxjOjTKwGfW8FOK/PZfmOKKjcANgUIctroMgJIZZ7u8f6wJGYwQqgW5Exivg/rW2WElxSG4u6b7HrWCiMxAtHUr7IAK/ANLxZAM6xNpzxVd/G3nqvnU7ScRScHBCh0KL4ypIGw+Ep0LnCvb4rR3e24mrY4VdHI9HRw5aCPoLtJhLVhQyunXB4P+68STnyk3MexlfOrxh+Iy2O/xNaz2RjfzeZ425E9x9x+//x1W1QQWwn80tQ4mK2H86VeaTmRX4YhlkwXtUr9s9DRvC822NvZUKEjkjGKbaDkDcRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SJ0PR15MB4172.namprd15.prod.outlook.com (2603:10b6:a03:2ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Thu, 19 May
 2022 23:34:25 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.015; Thu, 19 May 2022
 23:34:25 +0000
Message-ID: <3a732a8d-6e4f-0154-e317-795baa64022d@fb.com>
Date:   Thu, 19 May 2022 16:34:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v7 00/11] bpf: cgroup_sock lsm flavor
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, kpsingh@kernel.org, jakub@cloudflare.com
References: <20220518225531.558008-1-sdf@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220518225531.558008-1-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR03CA0136.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::21) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be3b4b20-470c-4b7d-f657-08da39f01c31
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4172:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4172613727815845833FAF48D3D09@SJ0PR15MB4172.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CGw+V/HH+Etix9xhEzi7eaC0+2911RDLz3wjK3PqRUkerOwy92n/Fj9j7dHHpV20VMxQkkQ6RhI2VrZBO9tKMQimNqc/m36JaDLleeUuzoTgdaBCweIrjW2qAECJz7q5/kH3yiLMpYwAb2IHp1E/zPSLYUE4ZU7oA7qM/grnngwPENyOCLCJx42R9YciVvQKQ2EQTR3NyFUzNazRhfEYiZlTNF3piQSCsDWqc5el+rqwY+NOBYBu2MNlGYMea6pDpF/IuqB6zSFC+Mnshbl2OIx9tw38CuM44Yq/0Tqd+RGWjLLT/2mO+psM7HA89Yc5GlemiUcBQ9kmTsgQsVtyaOW90g0WTh22CC/9fZ/muIl6X7edIOHjUDgqXAeEwIBM7mhCKofxk5YCbuthVZ+FTJTE38jC+ziydurmeO5sC8UaVDXvekOu01qQJzqx4gCgrbmJBZEBCDkT8zHQ0S3FPGTdXPaUvxlLI9rGqO1noLzLPJxf2amJyDjiIVTO8AF9uQQsJg/+/CHWib2dkms8TvicdDrI2lHkdD0r1z12pB/0A5yfTsiMyjVYZjajZpnYL34sBaIUOgz/F8y/TfhLWIAyyeAELdxiAYaKOr7/0mJlf845X5rfAQmCECzo8fGfs9k20Uh6eNjvNIp3/oBnUF6n0QxMcc9UWWAT/AslMLpNY4YHO8bdN51oGebngqN03iLf0vZKL9oLZi8VuOijM7dAWv9e9VB5Fg9aLEOzHUfIuxxSKuO4Qkjdyvitohf6wVUdQTHjrjOoD2SSZaohlq+r+Lp4pqzcl69s1+pFgYrO9TLLf3c2yxe2oRrFCW2z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(4326008)(66946007)(53546011)(5660300002)(38100700002)(52116002)(66556008)(8676002)(66476007)(86362001)(2616005)(8936002)(186003)(2906002)(31696002)(316002)(36756003)(83380400001)(508600001)(6666004)(6512007)(966005)(6486002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEdiR0txKzNiUit4UXFqN1NCcW9HTGJqM3MzSGt2cmtQZVJaeDhPTmxmbjVB?=
 =?utf-8?B?NGRiVk1nK2pRaTlpTFhxSzloRWdlcG9ibjUrd2NoL0dmWHNpZ2N3OWxhd1lr?=
 =?utf-8?B?bTQvcHZnWTl2OXFXYWhEdHBIeU8zc1dENE9kM24zd3V3ZjdCZHhXdHdsR2FY?=
 =?utf-8?B?VWVUanlCMkNnMU12c0VkeWZhVytPWW52Qjd2bGhzZ3M4Q0ozZm1QajYrYjU0?=
 =?utf-8?B?Y2ZWbm5JaXhRT2UzRjB2dGhna2dBbVg3UzJzNEZxZmxTRCtZbkRXUFFFaVM5?=
 =?utf-8?B?UWloWXJFdDFDZlo3MzBjbGpuOGgyRGtPcmI5SzdrcGFTSW9ZYzlmVVVxK1Nx?=
 =?utf-8?B?VVVTZ3hsNG5SWlBDSm5mbEFXUmR0Z2xYSHNlRGJaL1ROa1I1bmJjbTBOeSty?=
 =?utf-8?B?SXFEMmp4b1VKZUNoUVVtdmlid0NEZ2ZhVll2VjRZM2tSZ2UzSlpjRWVFM1JO?=
 =?utf-8?B?REQ5N3hhWVE4RzFGVWhQN3lVUXZmcjF6MHUrQmdVM1ZsK3NFdE5TZHRZVmRj?=
 =?utf-8?B?RkhiaGpobzBoeUZNZzFrZTlMNVJxeFhBUk5LckN0amxVNFpmbi9HcFBRNnZv?=
 =?utf-8?B?SHV2WjlWem41UnBzdFh4WXErd21ZQVJzNEpqTCt5SlRYcjFybWxCYU53bzNP?=
 =?utf-8?B?Qk1DcFJCa01FU0c1TmE5aXlYRzJjMmVPWnZNbHNSTjhzUldNQURMSFdTcXln?=
 =?utf-8?B?NmtUaHlKQkNWbGRSQWpBaDlLaUZYTVRJeWp6VHJlWUdzdnpQNlpJdGlVWmMx?=
 =?utf-8?B?dlFJdlY3dW5pamJFaE4zeEtXTVhzdksrQkVGUHlRalJYSFUyQzJHRGd0Z0RZ?=
 =?utf-8?B?NnBrSVFkS2dTcU9yZFRsbkk0UmV2UThyVmFFWjJwMEJURGFVREN1bW5BUSs1?=
 =?utf-8?B?c1pkRlF4QmlXUWk3ZFVXY2d1NmJSUlFwZGl4NXR0NWF6UzV0M0xwMm1SalJ6?=
 =?utf-8?B?clFBNEtZWSt3VTJjYU96eUtKRHVUN1NFZmprd0dPYzdvU1gxQ3Q0UmtUQTJL?=
 =?utf-8?B?c2kydVJmRHJTU3IyajNLenFpTndNaXZwamx0eDRxZmk4TTZ5dHJJL2Q5WFNR?=
 =?utf-8?B?empjR0QwMHlnYUZ0UTdwTUkrNzMxanRRbkZMZVhFRXZMWFNIVjJjZHlHckpX?=
 =?utf-8?B?dEVialVCbWNhZWxEUENEVmdMU3dlZ3p2QkhJN0hhZmdYdllZMXNRdlNrQ29U?=
 =?utf-8?B?T0RwY0RWK29vdTFQa2lLQ0lTNmZFZmxjVUF4Q0hadWxtcHFOaGdSblF4SFE4?=
 =?utf-8?B?dVQxY1A4UDU2cmRzeEs3dGhjN2NmZWxJNUJVbzdpQ2d6N2hhMk5FTFBjTnNM?=
 =?utf-8?B?eHFCUkphSUFuTG1QZ1Y0Y0grQysyOHNyYURqcjFkSVQ2S3RGRXFmeUw4U1My?=
 =?utf-8?B?ZUVGSnZIUitvZTRCMzg4RStLcTE0SmtDdmM5K2pKTHFWbDdLVWtJVUdxY0dX?=
 =?utf-8?B?UnhLZGVDcWZQWW9neFowQktLZHZpMmZCczhsV2M0MFRzdEhoNXJpKy9sd1ky?=
 =?utf-8?B?Ymg4OXk5OEZhL0twWHAzamRXWElIQ0ZneG4zYXIzMjJKcEN2bFlNMjkwRXZN?=
 =?utf-8?B?SG1rL0VvbDJLRmptWStCVGVkYTJHUkp4L0orNkliNWdiRFF0K1BLOXdqdFRy?=
 =?utf-8?B?blF6a3prL0d3VTZ1NnJkMzJNSTdveGRhVHU5cEJHZ2w2aWdsaFBqZG5MZ0Qw?=
 =?utf-8?B?OXhTbFI3STFrYmEyOTV5Zzg3bkhRa0EyMlI2ZFNMWjlxL2tLd2EzVUVXODRG?=
 =?utf-8?B?d1hWTGs4OVdGYnY5Skl5NG9oWURtalBDSlRNMEQ2cEthaUd4K1I0NkQ2TmJK?=
 =?utf-8?B?OXNUYis3d3dhcXNSblI1aFJGQzN1QVVwY3lXOHZlR0ZITlhSN0FyNGpHMVBY?=
 =?utf-8?B?N0ZiVTVxWVVWUmtNTFA5anJQbFdiMnZjdGYvc3ZHN0cwWlRtUC9MTXZ4NmZx?=
 =?utf-8?B?NTI3SXJaQ3hnWk1FVGNZUlZEWmw1ektGcWFkUG9jNHNreGJ2NDd5Uk40eEtB?=
 =?utf-8?B?eC9yVDB0YWxUL0M3N3g1OVFIU0l4eHpKajFZOU5lVVlFWUNxN0lFRE11b3VK?=
 =?utf-8?B?UmVBZ2kvM3BPOFpzb0ZIM2lnU1dBa1o0aFJJMmJoMXQ4c3FMYkZqQ1RuUUJx?=
 =?utf-8?B?aHJzSWREKzkxRGxlVzJLYnVLSk56Y29YRmx0em90L05EdGRIM1NzKzErc09r?=
 =?utf-8?B?SVhjaTZicVR0MWpLZGhJckFQeGxXQThROEZmbTdFWU5GejRPc3JLNlpWYlM5?=
 =?utf-8?B?Q3FQc0VLRmFyWVhFQjMyam9tVVJvZDlQOVRRL3luSzFtcDdIZmYwbmtOay9C?=
 =?utf-8?B?Wjg0Y24xUmlPa1VvMmwxUm1WU2hCdUJJS0FzdzVJYnk5Z1Q3Rkt4YWl4MFl4?=
 =?utf-8?Q?m9du3FDRVGbKwE9o=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be3b4b20-470c-4b7d-f657-08da39f01c31
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 23:34:25.5879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cERbbAXqVeG+nUlsIcJEJqVAXar8s8a1JCtsKoM8UwJAT5aykYJaFb97l2438Awl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4172
X-Proofpoint-GUID: OiwXzaoCBzYd3tiCmmVdN8st044IwNX2
X-Proofpoint-ORIG-GUID: OiwXzaoCBzYd3tiCmmVdN8st044IwNX2
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
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
> This series implements new lsm flavor for attaching per-cgroup programs to
> existing lsm hooks. The cgroup is taken out of 'current', unless
> the first argument of the hook is 'struct socket'. In this case,
> the cgroup association is taken out of socket. The attachment
> looks like a regular per-cgroup attachment: we add new BPF_LSM_CGROUP
> attach type which, together with attach_btf_id, signals per-cgroup lsm.
> Behind the scenes, we allocate trampoline shim program and
> attach to lsm. This program looks up cgroup from current/socket
> and runs cgroup's effective prog array. The rest of the per-cgroup BPF
> stays the same: hierarchy, local storage, retval conventions
> (return 1 == success).
> 
> Current limitations:
> * haven't considered sleepable bpf; can be extended later on
> * not sure the verifier does the right thing with null checks;
>    see latest selftest for details
> * total of 10 (global) per-cgroup LSM attach points
> 
> Cc: ast@kernel.org
> Cc: daniel@iogearbox.net
> Cc: kafai@fb.com
> Cc: kpsingh@kernel.org
> Cc: jakub@cloudflare.com
> 
> v7:
> - there were a lot of comments last time, hope I didn't forget anything,
>    some of the bigger ones:
>    - Martin: use/extend BTF_SOCK_TYPE_SOCKET
>    - Martin: expose bpf_set_retval
>    - Martin: reject 'return 0' at the verifier for 'void' hooks
>    - Martin: prog_query returns all BPF_LSM_CGROUP, prog_info
>      returns attach_btf_func_id
>    - Andrii: split libbpf changes
>    - Andrii: add field access test to test_progs, not test_verifier (still
>      using asm though)
> - things that I haven't addressed, stating them here explicitly, let
>    me know if some of these are still problematic:
>    1. Andrii: exposing only link-based api: seems like the changes
>       to support non-link-based ones are minimal, couple of lines,
>       so seems like it worth having it?
>    2. Alexei: applying cgroup_atype for all cgroup hooks, not only
>       cgroup lsm: looks a bit harder to apply everywhere that I
>       originally thought; with lsm cgroup, we have a shim_prog pointer where
>       we store cgroup_atype; for non-lsm programs, we don't have a
>       trace program where to store it, so we still need some kind
>       of global table to map from "static" hook to "dynamic" slot.
>       So I'm dropping this "can be easily extended" clause from the
>       description for now. I have converted this whole machinery
>       to an RCU-managed list to remove synchronize_rcu().
> - also note that I had to introduce new bpf_shim_tramp_link and
>    moved refcnt there; we need something to manage new bpf_tramp_link
> 
> v6:
> - remove active count & stats for shim program (Martin KaFai Lau)
> - remove NULL/error check for btf_vmlinux (Martin)
> - don't check cgroup_atype in bpf_cgroup_lsm_shim_release (Martin)
> - use old_prog (instead of passed one) in __cgroup_bpf_detach (Martin)
> - make sure attach_btf_id is the same in __cgroup_bpf_replace (Martin)
> - enable cgroup local storage and test it (Martin)
> - properly implement prog query and add bpftool & tests (Martin)
> - prohibit non-shared cgroup storage mode for BPF_LSM_CGROUP (Martin)
> 
> v5:
> - __cgroup_bpf_run_lsm_socket remove NULL sock/sk checks (Martin KaFai Lau)
> - __cgroup_bpf_run_lsm_{socket,current} s/prog/shim_prog/ (Martin)
> - make sure bpf_lsm_find_cgroup_shim works for hooks without args (Martin)
> - __cgroup_bpf_attach make sure attach_btf_id is the same when replacing (Martin)
> - call bpf_cgroup_lsm_shim_release only for LSM_CGROUP (Martin)
> - drop BPF_LSM_CGROUP from bpf_attach_type_to_tramp (Martin)
> - drop jited check from cgroup_shim_find (Martin)
> - new patch to convert cgroup_bpf to hlist_node (Jakub Sitnicki)
> - new shim flavor for 'struct sock' + list of exceptions (Martin)
> 
> v4:
> - fix build when jit is on but syscall is off
> 
> v3:
> - add BPF_LSM_CGROUP to bpftool
> - use simple int instead of refcnt_t (to avoid use-after-free
>    false positive)
> 
> v2:
> - addressed build bot failures
> 
> Stanislav Fomichev (11):
>    bpf: add bpf_func_t and trampoline helpers
>    bpf: convert cgroup_bpf.progs to hlist
>    bpf: per-cgroup lsm flavor
>    bpf: minimize number of allocated lsm slots per program
>    bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
>    bpf: allow writing to a subset of sock fields from lsm progtype
>    libbpf: implement bpf_prog_query_opts
>    libbpf: add lsm_cgoup_sock type
>    bpftool: implement cgroup tree for BPF_LSM_CGROUP
>    selftests/bpf: lsm_cgroup functional test
>    selftests/bpf: verify lsm_cgroup struct sock access
> 
>   arch/x86/net/bpf_jit_comp.c                   |  24 +-
>   include/linux/bpf-cgroup-defs.h               |  11 +-
>   include/linux/bpf-cgroup.h                    |   9 +-
>   include/linux/bpf.h                           |  36 +-
>   include/linux/bpf_lsm.h                       |   8 +
>   include/linux/btf_ids.h                       |   3 +-
>   include/uapi/linux/bpf.h                      |   6 +
>   kernel/bpf/bpf_lsm.c                          | 103 ++++
>   kernel/bpf/btf.c                              |  11 +
>   kernel/bpf/cgroup.c                           | 487 +++++++++++++++---
>   kernel/bpf/core.c                             |   2 +
>   kernel/bpf/syscall.c                          |  14 +-
>   kernel/bpf/trampoline.c                       | 244 ++++++++-
>   kernel/bpf/verifier.c                         |  31 +-
>   tools/bpf/bpftool/cgroup.c                    |  77 ++-
>   tools/bpf/bpftool/common.c                    |   1 +
>   tools/include/linux/btf_ids.h                 |   4 +-
>   tools/include/uapi/linux/bpf.h                |   6 +
>   tools/lib/bpf/bpf.c                           |  42 +-
>   tools/lib/bpf/bpf.h                           |  15 +
>   tools/lib/bpf/libbpf.c                        |   2 +
>   tools/lib/bpf/libbpf.map                      |   1 +
>   .../selftests/bpf/prog_tests/lsm_cgroup.c     | 346 +++++++++++++
>   .../testing/selftests/bpf/progs/lsm_cgroup.c  | 160 ++++++
>   24 files changed, 1480 insertions(+), 163 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
>   create mode 100644 tools/testing/selftests/bpf/progs/lsm_cgroup.c

There are 4 test failures for test_progs in CI.
 
https://github.com/kernel-patches/bpf/runs/6511113546?check_suite_focus=true
All have error messages like:
     At program exit the register R0 has value (0xffffffff; 0x0) should 
have been in (0x0; 0x1)

Could you take a look?


