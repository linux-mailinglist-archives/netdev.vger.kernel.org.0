Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442E351E2AE
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 02:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445044AbiEGARC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 20:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235557AbiEGARA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 20:17:00 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F0B1A386;
        Fri,  6 May 2022 17:13:16 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246NBXpM003245;
        Fri, 6 May 2022 17:12:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=gXAL2dpE4Ybr1jLFWhI/0/vuzQY+qi9Mmz/MmTB9uR8=;
 b=RGxpQnD5OG1btf53LRZC8j6v0SVyyTqh7xq3ylEAmEzO0eoniQ+UuMPUvxAw6LDa1xNs
 NaulH1dY3YBbb3HeITVv482qoqPl4ryVmNAXzUi2CInbFebzrPpFXIzd8SPGCg/gWh8S
 ZU55X8wTMjAeNFUmMf662Ff7SfaS00U8nkc= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fvs4teppd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 17:12:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVyt/FVNOPhPhjcpp3EsH0yNJzhz03xwlTN3nAQ8l8MJxmCP5dKLiJuMRBMLV4vMOoENDFjrI0SJIz3xMsGRupkAEBQwaTUEkr2pcAC5gXkk78kH8jg9Yxk5Tyv7N4Eb/r+QpOXbo4Ag4MymeSbNY9fVLvWx5jyq58Vt89dp0+bsfKrMWpSKhGkTh+WpGrSpJcSqlwjHQFB2jSTNe13PA9V/ONpzvl1nBwC08WLYYPaEuuGxOsxrClP/P12AScylNbvAaIhIpS4U+iuvZfzjUlLdS1bENx/RsFxMmpnimsQbmdT9QgDYd7igDjHTdbgbUf8TpSR/ke813inCqv1MiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gXAL2dpE4Ybr1jLFWhI/0/vuzQY+qi9Mmz/MmTB9uR8=;
 b=n2cXGyQXE7LOYr4l9PdsKxVMN+Cl4YEi0H8/XNyLhIgfwlEpGwOTIhcu3ft6uPQ+QQ2gKtx+xH8oH8O+potZ7QjyJIiyKkwA6Roxru4z/KPhjDNdQYsHzRE9k5kYUKSzyK7tihG88Nmw3FP5mqPho1yUFjuk0yIpQzgu8j/p8jHumE8DxOrt/EYR6C5c/nRdasaN88/58O/nu0uMf6x3jdhpwNEbIiMzN4xjYgV3bQ2VN2RStC5beitka3WTe2lCyhwxXlfglH/+Y/h46+5s5mb+jtBdhPdQn+jF84R34HQZcDTRQ7WdqtDD3XpzH+smqrgK5ATe4kUBGSq/RvQ0cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SJ0PR15MB4728.namprd15.prod.outlook.com (2603:10b6:a03:37d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Sat, 7 May
 2022 00:12:53 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::5f5:8b2a:4022:c566]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::5f5:8b2a:4022:c566%4]) with mapi id 15.20.5206.027; Sat, 7 May 2022
 00:12:53 +0000
Date:   Fri, 6 May 2022 17:12:50 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v6 05/10] bpf: implement BPF_PROG_QUERY for
 BPF_LSM_CGROUP
Message-ID: <20220507001250.yhisk4otoas7h4gx@kafai-mbp.dhcp.thefacebook.com>
References: <20220429211540.715151-1-sdf@google.com>
 <20220429211540.715151-6-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220429211540.715151-6-sdf@google.com>
X-ClientProxiedBy: SJ0PR03CA0119.namprd03.prod.outlook.com
 (2603:10b6:a03:333::34) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25631b91-708c-4941-a437-08da2fbe541c
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4728:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR15MB47286D05FF53FE85B27F94BDD5C49@SJ0PR15MB4728.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a4aomrBnaUXoXP/CFwoIfutBE+pLpQVxSA9ymkVt6E62uzQy8KPmjgh48jFOQH+a/bTk6eQJvSFVqBpwfGypIzCvOw9jTNfliATCrrMZgLiHMKBekcahsNUhhYXWRdihmRFixwt4+2gVPUc/k47olNiGAo1TEMDOf2RfthP9ANk7E7yF8xhDfSPgNEOW1uEg+wQNMX+8+RpTSWObv48Hc5JWtwggsrBuatxCqxEtzMl4joFR/ramFVz9w3TJ+dnDcf2l/NBEsZMWNXkggBCbqSEshmlL3Uawha/FTl84YJMx2otYAUobnkSfjzRoaecLsd1FThiz1U7dC566BNltzjTmNNTbyQFFSSecMCYD5nsFaqjvWhT9zSa0FV2Kj63ecLbdgrQAyZJMA9RKYEWiv5BHjq8RGhAcRNsOemnKAVgNT3GXmyBG027Nbhxw23jjkK418NZbvyg1AHqCgSmp4caJYBPBinmPAyojfZ6ydJhAuUN2BJVoeX3aG6qk9sdjF8GFUDWb+fpgTKNZv7pkoXKQsSip2Z5RPePO3G9VxFQOIALZj0IMlKCYRL01fYOohqcf2TjlRZt68r/cKeVGA0DAFx2ll0dGX7MUchz6qZaDsAajfpR8qDZ5FPsLvOFGor/7qrOUcEhakb+Drma5iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(508600001)(6916009)(4326008)(316002)(6512007)(9686003)(66476007)(66556008)(66946007)(83380400001)(6506007)(86362001)(8676002)(52116002)(5660300002)(186003)(8936002)(38100700002)(1076003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T9m34Zy0iaIZNoI58vL1m6ySRfZcfxxkzTHu0fDIY5PsqNvY9zGTn3fm7S/W?=
 =?us-ascii?Q?Qppgs2u0GB5/O7xdphy6k2NK5z9WA9JT648w7rjXNFAcVz2FQZQQWM4iXzH+?=
 =?us-ascii?Q?+pVVMtLrGrmVHt8F4fUuynjq280U313RkE9UKhWV/8XG3A7+3SrvrVCSrP0s?=
 =?us-ascii?Q?avcUfWiuGWLSWTc0OqV068RYill3MPeyTs5YgD0BgMFmanxW6CiN1ry8kFhd?=
 =?us-ascii?Q?E2hqBt9aM+efUkMKtWc4MvJqEcYSUQfAypAfCkYgnuagyeolh0q2uHBK5KK8?=
 =?us-ascii?Q?7VGyeLZxlLtJlbia54BOH/zjpCazCbs29bfcophkEZ9JXi5asAlZhDIluAuD?=
 =?us-ascii?Q?hayVs3FYFllpP/aSXmbVf+PA6urf1Zzbdi9MonypX+XVLK7HDQsWGY4mNxFL?=
 =?us-ascii?Q?3NN85uA+9zE73cHDvd/1qdv5UWsDJ2/Cq4XHkq4StFz4EeH3MRqya5tcYLhx?=
 =?us-ascii?Q?mowFylI5Be1XwDeIBQVDjJl7/mSJIENDSnmPDTwr4BWABK/phGPxwsSzAN7F?=
 =?us-ascii?Q?hWSAeRsvZDOt9UZvnNSW6123GZmnwLQfMr+A5TRvjb4R3zkKzIXAV8Rpo+se?=
 =?us-ascii?Q?0gxsBJF/i+jmVkD2Jw6sXKkyMVOdRTf/cYwDGZxInrUWdt6Ni6kA/P3TEQ0O?=
 =?us-ascii?Q?U81rEwfw/DoUuOqJ1ik3b8vq/rl/8B3Y8l5zf0sD1J+bzGStxhJf7IPaLAy7?=
 =?us-ascii?Q?3q9kG6UIWfJs7YHr7UkezS0zpwwFHd1e+hGnEdBwS82cIDcgpfei1AzVEOx/?=
 =?us-ascii?Q?BkZ8CtfRm3SEzAtTXREbSeBQuCJJ9bRAIOpjEc7xmIqvxk3uaRiLpbtqOX5M?=
 =?us-ascii?Q?QjOZYLQ1twXAXiLhnb1NklqOzDLj8XsFOkN6ltu7nMb78y4oVvt2kxHB7apd?=
 =?us-ascii?Q?9dKVXRUUtN1S4pyHpknEuoPA+XLVenY4JqFbu4GSUHkhuM1MBbgEXdi0fwOW?=
 =?us-ascii?Q?84iB/GvFvBeLf+MeZLirWcqCX5TzSjcNK0yHHnxfcdGtttDBZPGgLLANRcM2?=
 =?us-ascii?Q?xh16+viqeeUpLrxLiwyLQx0Bb+Buum7845xBtnQlw8FvU9gxXksGEI0YOPpD?=
 =?us-ascii?Q?8Le58E7kqMZsGHoM/UXXYtVlE2OJDNMsv9b8wT7g1yuPKtghwN65DDd3a6sV?=
 =?us-ascii?Q?jDljXFHVJ4ax069FnmQyEIvojSeiZfaAnMWJnlIemEpOhwhXGaG8T847otfu?=
 =?us-ascii?Q?1YoEz85FDWuNkgb2n6AMNAIWjlGEE3o/edJ1cRKsYzIgmRiCAoxJvW0DZHmT?=
 =?us-ascii?Q?xsLlLVvB9zT6RBChzEXqPmCwdV/9ircJbq8aKsumOdYzCCV3AvOYQofRBezD?=
 =?us-ascii?Q?zzTnwEdxhGyQbr/qaRqeRFqTBTt98GjI3TpCxdGJv9HuYZEaZqNtny0ED8j0?=
 =?us-ascii?Q?Outfsjrfm1/Sw6bI+YamBdlAo5PpqJwOXSMCZh21uZcXfL0VdaCQBpNSmA5v?=
 =?us-ascii?Q?pHI9UC3Cu4IktxMv6o+1lZ/Jr73dS1ZTWLvkxx+hA6Le1VquPN/tOzaNlzfL?=
 =?us-ascii?Q?sGyf/qiwvCw8BU91CxP4wz7aPPtpTOJ9gSuHIS3idsba7IvCjnlbQ5p7b8Dl?=
 =?us-ascii?Q?+3RYodHw1pUe+8sqZ/99RamdxZZmX8h+wUJ2Albg3wncv6LqbbrDqM2ezicx?=
 =?us-ascii?Q?Cvo21HxWBpaUn25ayBQZqwE1IX6YVOqlKarQZUvM7MwYCHuK9uqkmHgAwsyo?=
 =?us-ascii?Q?VGOx8ul6Dy8tez3450g5BoeV7KGRxu7Vp49qQogPJNAGoi8oFP6eEfGcGn0O?=
 =?us-ascii?Q?NlIBi7rwbqDHC3YcVWdp+YkJl6rXrqA=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25631b91-708c-4941-a437-08da2fbe541c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2022 00:12:53.0625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: htBkwP3oB9BF2vlylPNhB2vCyy+8BJeOCL7W5fXcmw9GcwvgZZDG8gR3r2ty2To6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4728
X-Proofpoint-GUID: 6nX2TD47TTqxg-ta_l8nT8Im7LJU7CF-
X-Proofpoint-ORIG-GUID: 6nX2TD47TTqxg-ta_l8nT8Im7LJU7CF-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_07,2022-05-06_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 02:15:35PM -0700, Stanislav Fomichev wrote:
> We have two options:
> 1. Treat all BPF_LSM_CGROUP as the same, regardless of attach_btf_id
> 2. Treat BPF_LSM_CGROUP+attach_btf_id as a separate hook point
> 
> I'm doing (2) here and adding attach_btf_id as a new BPF_PROG_QUERY
> argument. The downside is that it requires iterating over all possible
> bpf_lsm_ hook points in the userspace which might take some time.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/uapi/linux/bpf.h       |  1 +
>  kernel/bpf/cgroup.c            | 43 ++++++++++++++++++++++++----------
>  kernel/bpf/syscall.c           |  3 ++-
>  tools/include/uapi/linux/bpf.h |  1 +
>  tools/lib/bpf/bpf.c            | 42 ++++++++++++++++++++++++++-------
>  tools/lib/bpf/bpf.h            | 15 ++++++++++++
>  tools/lib/bpf/libbpf.map       |  1 +
>  7 files changed, 85 insertions(+), 21 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 112e396bbe65..e38ea0b47b6a 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1431,6 +1431,7 @@ union bpf_attr {
>  		__u32		attach_flags;
>  		__aligned_u64	prog_ids;
>  		__u32		prog_cnt;
> +		__u32		attach_btf_id;	/* for BPF_LSM_CGROUP */
If the downside/concern on (1) is the bpftool cannot show
which bpf_lsm_* hook that a cgroup-lsm is attached to,
how about adding this attach_btf_id to the bpf_prog_info instead.
The bpftool side is getting the bpf_prog_info (e.g. for the name) anyway.

Probably need to rename it to attach_func_btf_id (== prog->aux->attach_btf_id)
and then also add the attach_btf_id (== prog->aux->attach_btf->id) to
bpf_prog_info.

The bpftool then will work mostly the same and no need to iterate btf_vmlinux
to figure out the btf_id for all bpf_lsm_* hooks and no need to worry about
the increasing total number of lsm hooks in the future while
the latter bpftool patch has a static 1024.

If you also agree on (1), for this patch on the kernel side concern,
it needs to return all BPF_LSM_CGROUP progs to the userspace.

Feel free to put the bpf_prog_info modification and bpftool changes as a follow up
patch.  In this same set is also fine.  Suggesting it because this set is
getting long already.
