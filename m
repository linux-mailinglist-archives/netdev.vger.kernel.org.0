Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6023E54F0B0
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 07:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380161AbiFQFnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 01:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379953AbiFQFnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 01:43:11 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D7CB7D4;
        Thu, 16 Jun 2022 22:43:09 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GMYjT0032602;
        Thu, 16 Jun 2022 22:42:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=K7WiTS4mj2Osgfx8QRin74ndzaJx3gIoyhrUYGszoXk=;
 b=H0S0L90IjXN8iiLsKELWT71PGk0fkBdUKxbF1YhRmXDRy8GZCd7zOGVmJw0YZWsn0H/+
 se1QEi8Edxoa/HfaaJcnY1Old1OKeCQsP96YnWhQ8aa+MnrNYZl5y6Uzg4sE1CKPIODT
 zbYw4rv8USRz2hdTOCvUzCG1SeAAvZXj2IU= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gr3tr5yxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 22:42:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcxthszvx3un8c2CTveUz/JunDC+JJRShLhHiXwdWKe1nzRtpk3HzEu/yhBq3CVDYrk8cNTv46KMEPf/b4ct4sHth9UFdRMafqfEjlN5f3muqjpCQWXotXTXvETjnSvkZ1yg2D/TssSRRZxnMsEBL6KjCuTXa2SRGp1NtDmBqGDsjD0Wt/RAoGAfOeSZQwQ5f1AvYc3EGXI5gPZHXXEbSU52kMwjM5aVQIlx0fvPudvm7Yf+/KlNoqq2+X3XSzNS9z7FmtOeNoqE8K1pCh45udAWPOYFkdnhKUrQ5paqDqSZjR0vh/0m3XUPCwGVkCMfgJ+3uFJK+IVE+ydmhbLK8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K7WiTS4mj2Osgfx8QRin74ndzaJx3gIoyhrUYGszoXk=;
 b=n9gRXEqZol5r0pPUqnWleYzzDRh+rY8Nuqr5Wmck4WOgXWfp0s9fd8qHTRti/lT5d2X0u0zMGxdBMuytDmZHW1OimB3mUJmueCRQUIGYFzOR47trzaDf0EE/onYtGXf1v+OjibLbg1dmOYTgJdJnUCzgYYX56IlQrwEC5YpCSrlxyDnUl3juXXHOo1v9SpmoP42N4Q4+8w5FtYtJGFxAjlmOBV/ycR0cDNFeH6zN3MY/Mc1QNlYvL1rJp1O8+ZPuiSvUo5zkOBSurFjms8jdrtNeji0MvVxbJd6qq6rcm6uLk00xibX1XmqTtiaFYjReo0kwNUizooYj4MeECjn5qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by DM5PR15MB1497.namprd15.prod.outlook.com (2603:10b6:3:d3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 05:42:52 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%7]) with mapi id 15.20.5353.015; Fri, 17 Jun 2022
 05:42:52 +0000
Date:   Thu, 16 Jun 2022 22:42:49 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v9 06/10] bpf: expose bpf_{g,s}etsockopt to lsm
 cgroup
Message-ID: <20220617054249.iedbzuakyzg67o75@kafai-mbp>
References: <20220610165803.2860154-1-sdf@google.com>
 <20220610165803.2860154-7-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610165803.2860154-7-sdf@google.com>
X-ClientProxiedBy: BYAPR07CA0019.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::32) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7928088-6ad6-4cfa-d276-08da5024382e
X-MS-TrafficTypeDiagnostic: DM5PR15MB1497:EE_
X-Microsoft-Antispam-PRVS: <DM5PR15MB1497033B794478C3181D4258D5AF9@DM5PR15MB1497.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SQTUFsLeueo+7O/FX+hf6yMaTOVsetMbM5qmZzY9ks8CypvvKk/zYEzwYDHNfoE8NrSWkYwv88hhROgUZmQskOS2IC6Ne0dz4BIGBjAG6RSxfvwf2Qf+gcJxrCUM6hWlkVXjSKiSEpQ+/99QQX3H9r65elmLqPXkiJ8g4nvT2usx/pbrHIkJ+pHc9ZrDCELg02LLmd3Vb/7pDjVsf6uRaMEc042k97Xd95iq3Piq5glMwRx3B/zyT2DfLMgcAwJGQJMsaSFOEFHBfQD0Oh/pfiSYWX5cqdzk0zWWTLeV24cVJvC+h8FdZtSKnBZrl/gnKenufjejO2wREcW2ofX+g6C8N7aXse9oxsQl+1VBvOx+OwRNgw8WH2XA37KkuCCBek8pPH3BSBJMNpzi7cg2ZhhfzyCcQ3/ffvjjPdmO06XMvYS4PiXTFUH/MiUWdWr6PS+OJcO2rU51f2UMAUZHGJZHN/Lsqx9wiYpFTJ6YjNEFHrR7cIdzZAPuSsacM9aN5tCysoTuDNjkAiIJH4cYkKiz2hbpQXjNp8oThhL/qKCalKO+W1TWVdoUolo7CgUCYM/iFXCxt0cqdCamzK/t+lF/GvU06ErewlcgwQ0d3o/JNSvq36aTGne7zj8fxdgo+ELLUsPKKLgUneapRlI9cQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(9686003)(6512007)(4326008)(8676002)(66556008)(66476007)(66946007)(186003)(2906002)(83380400001)(86362001)(6916009)(316002)(52116002)(8936002)(1076003)(38100700002)(6486002)(6506007)(33716001)(5660300002)(498600001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9kgqWDAtUID+Cokvn53VnoS+585PGL3FgdkjduqEm52UmEMZA37ZiejRgTi1?=
 =?us-ascii?Q?VMPz8u8FQBEYmSrtrv1uuAZ9G3jv2lR9y9xBYSVMWgWAurOXEoftObKhjcPm?=
 =?us-ascii?Q?3RMrb0Et7+wyrXrvzD8yqUTJNdfmCJuK2i1PEElLZvkQJc6cGls7r51IJluJ?=
 =?us-ascii?Q?id1jWHM+ifcbMg26HRmkcPuKNfsbaIMbPsMP94SFYYsfsYp2hAVlbcP1mGX7?=
 =?us-ascii?Q?qHq/5dEtUzrA0yNnVwSx8ZCYsgXd8QNegtSoKxkA7/3nRp4I1zTrL7jn7Bw6?=
 =?us-ascii?Q?DBOdd0OYomJR07rSCVaj6qXSJ2lAquwivwwtDQCuEBqJdi2Lg5CSx7jabfE3?=
 =?us-ascii?Q?aO4U4PRqKfY8o1plBVVg5/szyJG3RADi+qpu2C3Od4BHbYSxYpCuZ/VCPkn8?=
 =?us-ascii?Q?SEp9LT55FkY+FGp9Cpi5x5Fk1BkhVze9jTPgcd/lyz8oDt6sh+N0zlrTkfJl?=
 =?us-ascii?Q?WMwsMD7eVG5OdTARHqOhwJxOeA64CkvNQzDmcf7V/bdLht6I9ftAOfP9RrIS?=
 =?us-ascii?Q?MiozSXBiQpprcEJQWQ+drzubtKJp3ypewcSs7KcQXTYwVEZIarzT2pgExvH0?=
 =?us-ascii?Q?L7tzfrkLKBNB9FWkB9mQbhVVGauSKTaCcJojzx7u0sStMVZhYEFWlv8WcYUx?=
 =?us-ascii?Q?0lU11wjUW4ssaKz5YuaVwy4NZ6DnZAssGVMCOT/9km8FtQhPlc7LUTdEkflq?=
 =?us-ascii?Q?7JNJR3A5RsEY1A6hy3jIITzrQwRqsjAvdcIvO5L4FaO/nA/KRLN1damX/njN?=
 =?us-ascii?Q?lPtIuXgoFEUPdPQ/QakrDbo0NvAZ+jwyTEEW0jw4SDb8U9Ccs8ubDbzNv3Se?=
 =?us-ascii?Q?wyEBIyAo8nWrLLkqXGg9uMKAWHewNL32O/vLi4rQtkeTE5GBqO57K2lxyGqB?=
 =?us-ascii?Q?I/LJK0L6bdRK/3+XL7b/sBV+NBZE05s/J/spI9Ujcbuta2nVYoRu0OoaoyVn?=
 =?us-ascii?Q?cwEz9LAVTIesL+3G8SV/mv5egXYVDBNB3+CjL2iI3mkjxuGj1nBMNhEIcTic?=
 =?us-ascii?Q?ubRlSg7N60EX/zxRA/puYRPJoZhovezNGa5tajfIrvUtD3+i/s+bcXmbueep?=
 =?us-ascii?Q?pNK5JS9YFjjMt2TlLTbdnfKkCaSRpwye1NA7v4MJgBOGNvqu7ZE88BxQ6kV2?=
 =?us-ascii?Q?wxvF4JH1iyCHrOL1yCzwJzOQmPFkqgbFak/aSsiVUrP0hOpgh7WW8+dwKoQg?=
 =?us-ascii?Q?6rRqCJIuKD2PjRG9EfyjGHhqlM7tiIqeM9Cz5F5oZJ90ng1+vK6F+FrIWV96?=
 =?us-ascii?Q?zSElAhkZpGrIKhWm+B3XBUt47h1dXrPUmPb2p9AYSDVzMsx4pYRORVqBtU2q?=
 =?us-ascii?Q?mjfb72T30w5eb3sG3LtuVsz4th43wwoQSMaTDdEsaijPQemaJ7ArIhvhPsk5?=
 =?us-ascii?Q?rV8AKekDFDq5BaKL1g8Ohc6YNRuycicvufKDt4bUOsxgJaIL3B6xHtkap3jA?=
 =?us-ascii?Q?Uaa4ApP/2w9xXrpNSy0tE+T7/pxhrX5/HavnkGHJQVKcgbXF+2ZXRrDkpTlg?=
 =?us-ascii?Q?+j/HKQVCgXF9fDt+LJgzpVVNwvHh7SlYzjP2liT9pCinV+nZjQWDSkF1Fvmj?=
 =?us-ascii?Q?1MwiS0ZaU7NHp+8f4PChtEcuervIz32ViorjpU7h3SZnfXrieUJB0TrvggQ2?=
 =?us-ascii?Q?i980BmyQX4LnTuK32dt0xB40Z7qpYwyH1vcs19X6L1P2/xyKbbE/MJiqiNN6?=
 =?us-ascii?Q?J7o9IISTGaywpYMDgjQQowf2bdsoQv/2aTVt6KKU5mmc71sClze9xJhcZh9Z?=
 =?us-ascii?Q?PwLZLlcje5CSYnEuOdi7aqnUenh6VoM=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7928088-6ad6-4cfa-d276-08da5024382e
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 05:42:51.9701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nuilwkarm6VUonppZh6kL1hHoZT3kSnxobPxbH00nQRYg8F7B+syiRjCD/dtiBeD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1497
X-Proofpoint-ORIG-GUID: rbuc-fvgp00vWCcnic975SZrYmSQj_yJ
X-Proofpoint-GUID: rbuc-fvgp00vWCcnic975SZrYmSQj_yJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-17_04,2022-06-16_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 09:57:59AM -0700, Stanislav Fomichev wrote:
> I don't see how to make it nice without introducing btf id lists
> for the hooks where these helpers are allowed. Some LSM hooks
> work on the locked sockets, some are triggering early and
> don't grab any locks, so have two lists for now:
> 
> 1. LSM hooks which trigger under socket lock - minority of the hooks,
>    but ideal case for us, we can expose existing BTF-based helpers
> 2. LSM hooks which trigger without socket lock, but they trigger
>    early in the socket creation path where it should be safe to
>    do setsockopt without any locks
> 3. The rest are prohibited. I'm thinking that this use-case might
>    be a good gateway to sleeping lsm cgroup hooks in the future.
>    We can either expose lock/unlock operations (and add tracking
>    to the verifier) or have another set of bpf_setsockopt
>    wrapper that grab the locks and might sleep.
Another possibility is to acquire/release the sk lock in
__bpf_prog_{enter,exit}_lsm_cgroup().  However, it will unnecessarily
acquire it even the prog is not doing any get/setsockopt.
It probably can make some checking to avoid the lock...etc. :/

sleepable bpf-prog is a cleaner way out.  From a quick look,
cgroup_storage is not safe for sleepable bpf-prog.
All other BPF_MAP_TYPE_{SK,INODE,TASK}_STORAGE is already
safe once their common infra in bpf_local_storage.c was made
sleepable-safe.

> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/linux/bpf.h  |  2 ++
>  kernel/bpf/bpf_lsm.c | 40 +++++++++++++++++++++++++++++
>  net/core/filter.c    | 60 ++++++++++++++++++++++++++++++++++++++------
>  3 files changed, 95 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 503f28fa66d2..c0a269269882 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -2282,6 +2282,8 @@ extern const struct bpf_func_proto bpf_for_each_map_elem_proto;
>  extern const struct bpf_func_proto bpf_btf_find_by_name_kind_proto;
>  extern const struct bpf_func_proto bpf_sk_setsockopt_proto;
>  extern const struct bpf_func_proto bpf_sk_getsockopt_proto;
> +extern const struct bpf_func_proto bpf_unlocked_sk_setsockopt_proto;
> +extern const struct bpf_func_proto bpf_unlocked_sk_getsockopt_proto;
>  extern const struct bpf_func_proto bpf_kallsyms_lookup_name_proto;
>  extern const struct bpf_func_proto bpf_find_vma_proto;
>  extern const struct bpf_func_proto bpf_loop_proto;
> diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> index 83aa431dd52e..52b6e3067986 100644
> --- a/kernel/bpf/bpf_lsm.c
> +++ b/kernel/bpf/bpf_lsm.c
> @@ -45,6 +45,26 @@ BTF_ID(func, bpf_lsm_sk_alloc_security)
>  BTF_ID(func, bpf_lsm_sk_free_security)
>  BTF_SET_END(bpf_lsm_current_hooks)
>  
> +/* List of LSM hooks that trigger while the socket is properly locked.
> + */
> +BTF_SET_START(bpf_lsm_locked_sockopt_hooks)
> +BTF_ID(func, bpf_lsm_socket_sock_rcv_skb)
> +BTF_ID(func, bpf_lsm_sk_clone_security)
From looking how security_sk_clone() is used at sock_copy(),
it has two sk args, one is listen sk and one is the clone.
I think both of them are not locked.

The bpf_lsm_inet_csk_clone below should be enough to
do setsockopt in the new clone?

> +BTF_ID(func, bpf_lsm_sock_graft)
> +BTF_ID(func, bpf_lsm_inet_csk_clone)
> +BTF_ID(func, bpf_lsm_inet_conn_established)
> +BTF_ID(func, bpf_lsm_sctp_bind_connect)
I didn't look at this one, so I can't comment.
Do you have a use case?

> +BTF_SET_END(bpf_lsm_locked_sockopt_hooks)
> +
> +/* List of LSM hooks that trigger while the socket is _not_ locked,
> + * but it's ok to call bpf_{g,s}etsockopt because the socket is still
> + * in the early init phase.
> + */
> +BTF_SET_START(bpf_lsm_unlocked_sockopt_hooks)
> +BTF_ID(func, bpf_lsm_socket_post_create)
> +BTF_ID(func, bpf_lsm_socket_socketpair)
> +BTF_SET_END(bpf_lsm_unlocked_sockopt_hooks)
> +
