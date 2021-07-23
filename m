Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEB43D4305
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 00:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbhGWV7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 17:59:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32526 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231954AbhGWV7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 17:59:49 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16NMaDa2006214;
        Fri, 23 Jul 2021 15:39:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=vaeLa+LZvZIxB9iFfnpmO860AlzUs+TE9Zk1V5GDelc=;
 b=dlzVKASt5isw163MjPWIeSY/5TFXaHLQN3HzCieSxZmb1vMCtvh9DnG9TptvZmzXRLi0
 SrHtD2r4jsjRXRXgHS71tFsf2g2l99KpUGV8NG6HjC/R1OGYOuRe+GMGwjCmFKVBlpwe
 91i13VypHwb6OKicAGMCH60po3LHXrZBYqE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a06n580yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Jul 2021 15:39:45 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Jul 2021 15:39:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BTlWoybwlHFCcYU5cC/qWR+LE6GsoAil5c4wx5UjU7M17QVZWFD/QoxnhCRWPx/u+yK9YHLOSV4kc8dIdQvy1Ux5AcrhGVYC4vKz7izoyekjV6wmvXzIu+ifDB3USPJiHwBagfEPt5jZoc+uNWuJK4xt7PqFcq0mqHeXk/W9TuNjFh+Z0I0QIYIEPQ97ahX0KZOCTby+8z1Bc5Q/vfm3rb0U+XZ0Mm1Pc9SAOYKKsq21qBOwYtiI/9/MhqJGmGxh4CLQasf4tYwKPC540Mu11UtCtMz74N7zswvqjDiWZWuBItCBtpIRccYxtJZikQDej3AKDP4A7ym9n1uexseU2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vaeLa+LZvZIxB9iFfnpmO860AlzUs+TE9Zk1V5GDelc=;
 b=h4DFOVRGloL/T+voCrq5az5NLsMCyeAO5re7MjiTfGqi1KN22TyWft1mNItZHBOC9HTTrZswW+9m/Cv0o3oWzXcYOF+MI5FHobhYk6uKyfMoBwKozzRD1hd8FJn8OnPjT+0d9qN712Hyh0S7xFsAJHBNJzrIP22PwjRAk4L1QB+IZRmruiFlkZNQrRNzFCLigzx5SaLyTyYN5vne7zJHHt5rJivWF6KreUgKnSRTdUqw6w7Y0tLoBkrL6t1vgy8aRLFSeKEi1bLhuENDAxvPNXbozGi/Xi1a9/HO9ICXFH5s2HAl78ZIjsFJGb7am9Kq0cTkAB/AGLpWLReaTg2zCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4823.namprd15.prod.outlook.com (2603:10b6:806:1e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Fri, 23 Jul
 2021 22:39:44 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f%9]) with mapi id 15.20.4352.029; Fri, 23 Jul 2021
 22:39:44 +0000
Date:   Fri, 23 Jul 2021 15:39:39 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>
Subject: Re: [PATCH bpf-next] bpf: increase supported cgroup storage value
 size
Message-ID: <20210723223939.fr45rzktocvg5usw@kafai-mbp.dhcp.thefacebook.com>
References: <20210723002747.3668098-1-sdf@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210723002747.3668098-1-sdf@google.com>
X-ClientProxiedBy: MWHPR2201CA0041.namprd22.prod.outlook.com
 (2603:10b6:301:16::15) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:c3f4) by MWHPR2201CA0041.namprd22.prod.outlook.com (2603:10b6:301:16::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Fri, 23 Jul 2021 22:39:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55735223-fb24-4f08-4946-08d94e2ac432
X-MS-TrafficTypeDiagnostic: SA1PR15MB4823:
X-Microsoft-Antispam-PRVS: <SA1PR15MB4823D37BF416CEB17E85E56AD5E59@SA1PR15MB4823.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /rXMsOhKi7t75tDUQiAC9QkJqdPrREDBRRybcjz0A1OfFChne8PaZ4etVV9RmZVhYUZGwxxpPjA2+LDdJUsVBoeZv2TXRBQ8jeks0nbC6Vr0hVqYmLZZF0jUgGKQkhW1Nq7Qp9He9Pum2ow7GpKlTblP5qZJokeaDmLYHtFPWfAfwpNmgA0Z8ftAnbpBd7olYH/4/nMng+sU92nSTYr34V1b1MB4Aeoewz9nfupyey2HFynjMoPm66a5/+/RY3r60G+8YW+MilYGB6liJ6Y2b2E+XLVvIM3ps5m97pvsfhvEYuzbxID8JsNokiL/ex7MFIEbYMvCCwCDvlJlYuXwm8gSCe77zPDLawjj4CQp8KOX9vkZByhKkQXt2w7uABn1uc6XVI08k7UUAsRnFSucB3Bf0Mxvr9iNTiZggnc0Y8cwIqo/iupTmtk5mj6/T/Ec1b0jNTcVEKV/82fWBfcXEzaTl8+0USgNtKMbN2bU9iujiZDWBtTdbzjkE4eiwuFPZjgbftMCmahGRZt1VDB9xtKiJy/guzUqQdDLZ7GalTdsqLRnGtK2MuY/kt+wUFqOHPzOVsjjD5bppzUMg6DGBnJbT3p5DhtQkhmAzBiW7jeAveYLngP+sbi4/dLXgIp2cNv6m3W0VLO+1XZ/mWajSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(136003)(396003)(376002)(7696005)(66476007)(8936002)(66946007)(52116002)(6506007)(186003)(8676002)(1076003)(478600001)(4326008)(66556008)(83380400001)(2906002)(6916009)(5660300002)(9686003)(55016002)(6666004)(86362001)(316002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?INYKlUWP0dOOor2KyuhHL1lbjXM7Vry3xFfsd7ZSm2YTgf9L+bBn9y6rUnfM?=
 =?us-ascii?Q?Bou62oS8bnx/vGrCs4+JWBW3gFSMXtv2MvKiFslpPuYKuDkAGUdK0kzsqyBM?=
 =?us-ascii?Q?lNnI4ELX+aBB5arOB+i/ntAQWym0Oxli6LFkw5sxazJRBoRpC+J+uIFJw4OJ?=
 =?us-ascii?Q?mQZd02KP3OWDPAQ4F7Q4HVtLLYJJDovwfSXRNkkpC0YRXbZGA4eDqAQYw+f5?=
 =?us-ascii?Q?4AcRq0p1uARibtMxEi4HIWpA3+ZXa2zjNHqgzEObqdovqSOxTM2El5KvMawA?=
 =?us-ascii?Q?ZOOoyY+AaJc8vX1vvkhhlvdpkfNHoxj5qWPqxD7TKee8hQXPtC740R3VGCnK?=
 =?us-ascii?Q?90G9lA84KwBx3mvGoMbfkQXER63AFsLjOlbDRaV4uQBwCYi6GXv/PoosMobE?=
 =?us-ascii?Q?L8e2loPtcmWPsX47vkvzV5D+jNtn8a+k/UuZtuauK7YeZH7XGy1Mer9ADQAD?=
 =?us-ascii?Q?LGicgPUoeEh7RuHoZ4lX3TEZopwaj/PxfugfX+wJgElxdwpZEGR8UKR+YKr7?=
 =?us-ascii?Q?UYTHBxA+ujxIYeGdwBOnsBQnS56oSii/lsGTbggyhCVXzVgvzg9lbHtRrHhc?=
 =?us-ascii?Q?w0lbETCKj25VxP/JRxbyAd34kj1GKkDgjf2/oBf+rxpZkK6rqIRLHGS/H+Ig?=
 =?us-ascii?Q?799hbmJlTHYRLak6StnvJ0fLL23l0SLah2hdqt8cihTVW8OmGf4ZWO+7uld/?=
 =?us-ascii?Q?x40J9blrO7/8H0Nq09qugENM3Vb5mr5NPG7mdsSNVhRex5sDavP2zURGU22d?=
 =?us-ascii?Q?J5tTuKk5yP4gO8YSOiPqvQNd6Srg7lRJk5DiAxWyfyvUNDksv7CQugFPf2bo?=
 =?us-ascii?Q?E/MZ1H/Jnc/XbtIo+GOOtKol9gR+4U1hETD0i5n1LIRCDXYARsah/vB81kIZ?=
 =?us-ascii?Q?0BTsF5SThrLFmVPIzXSL71mNyjG1vMFtBuao4ey9tOKrRE0aqBDVu9uSsmKF?=
 =?us-ascii?Q?LZS2yIxuPJlhm8/xEKICCpbatAJI8x4iI50ExPszdNvfO/mCxY0cLhez49OW?=
 =?us-ascii?Q?984BZVMf1kVy6fMMO6uB4kbce6JHydwLVyI7kz3K7cblMIH2J5zC9qThtv3q?=
 =?us-ascii?Q?qo+KJZS9pN6TC3194m7/yvkZomCAwrPoKamM2pMQHtJu14GkrdAcMLXLqsPp?=
 =?us-ascii?Q?0DBC+vSb8TqidhFG5DJRVHU2r04qDzkFbEoO1ECb66B9n0A0YR4ykhtvAd8G?=
 =?us-ascii?Q?Cqh9Hf+WAPv/YrxAJUQK8LYHTRmrai2h0j4r79c5OyV5eXmHJ0Q8R57DzJuO?=
 =?us-ascii?Q?JYKilrx1ObS8nhuVAIPF8Xsbkabn45JybTef5e1zScKm5zhMG1EMvSW1gGoU?=
 =?us-ascii?Q?PE9pAmQbcS4yUuoy6uRmImkfa2rKEtdoKtldhVdNj+4mLg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 55735223-fb24-4f08-4946-08d94e2ac432
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2021 22:39:43.9546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vh2KbG7qKlvSQr6cDT7g0dOeZXD1rf/n8xPiiSBkXJJ/shotSeR1VzVZcm3CkttM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4823
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: RXwjlHKXeyZpzeVN_HCazPm_lFnANhFm
X-Proofpoint-ORIG-GUID: RXwjlHKXeyZpzeVN_HCazPm_lFnANhFm
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-23_13:2021-07-23,2021-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1011
 priorityscore=1501 impostorscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107230136
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 05:27:47PM -0700, Stanislav Fomichev wrote:
> Current max cgroup storage value size is 4k (PAGE_SIZE). The other local
> storages accept up to 64k (BPF_LOCAL_STORAGE_MAX_VALUE_SIZE). Let's align
> max cgroup value size with the other storages.
> 
> For percpu, the max is 32k (PCPU_MIN_UNIT_SIZE) because percpu
> allocator is not happy about larger values.
> 
> netcnt test is extended to exercise those maximum values
> (non-percpu max size is close to, but not real max).
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  kernel/bpf/local_storage.c                    | 12 +++++-
>  tools/testing/selftests/bpf/netcnt_common.h   | 38 +++++++++++++++----
>  .../testing/selftests/bpf/progs/netcnt_prog.c | 29 +++++++-------
>  tools/testing/selftests/bpf/test_netcnt.c     | 25 +++++++-----
>  4 files changed, 73 insertions(+), 31 deletions(-)
> 
> diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
> index 7ed2a14dc0de..a276da74c20a 100644
> --- a/kernel/bpf/local_storage.c
> +++ b/kernel/bpf/local_storage.c
> @@ -1,6 +1,7 @@
>  //SPDX-License-Identifier: GPL-2.0
>  #include <linux/bpf-cgroup.h>
>  #include <linux/bpf.h>
> +#include <linux/bpf_local_storage.h>
>  #include <linux/btf.h>
>  #include <linux/bug.h>
>  #include <linux/filter.h>
> @@ -284,8 +285,17 @@ static int cgroup_storage_get_next_key(struct bpf_map *_map, void *key,
>  static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
>  {
>  	int numa_node = bpf_map_attr_numa_node(attr);
> +	__u32 max_value_size = PCPU_MIN_UNIT_SIZE;
>  	struct bpf_cgroup_storage_map *map;
>  
> +	/* percpu is bound by PCPU_MIN_UNIT_SIZE, non-percu
> +	 * is the same as other local storages.
> +	 */
> +	if (attr->map_type == BPF_MAP_TYPE_CGROUP_STORAGE)
> +		max_value_size = BPF_LOCAL_STORAGE_MAX_VALUE_SIZE;
> +
> +	BUILD_BUG_ON(PCPU_MIN_UNIT_SIZE > BPF_LOCAL_STORAGE_MAX_VALUE_SIZE);
If PCPU_MIN_UNIT_SIZE did become larger, I assume it would be bounded by
BPF_LOCAL_STORAGE_MAX_VALUE_SIZE again?

Instead of BUILD_BUG_ON, how about a min_t here:

	if (attr->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE)
		max_value_size = min_t(__u32,
					BPF_LOCAL_STORAGE_MAX_VALUE_SIZE,
					PCPU_MIN_UNIT_SIZE);
