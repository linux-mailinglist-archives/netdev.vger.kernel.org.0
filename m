Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424093D9D81
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 08:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbhG2GQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 02:16:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18194 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234019AbhG2GQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 02:16:02 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 16T69GQr028705;
        Wed, 28 Jul 2021 23:15:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ZuIowdJJF7Mx5IZ5I8X4FsN3LrXand4X0W5QZVPY5ow=;
 b=nxXLIhFWdHaVEFTShLvucQOviseaf0Bcrqh3+aE98qmXF/QcAJyVTuLCkK1Ya7yuXePM
 j4VVKGbTU6K3K0L97fiS4g+LbIStZ05xO0LGqrYE708kjrqCkJUFXdr+Mcdq6J64tPB7
 JQrXnaZu3DWdO2oUJOqb+K3fbIMkMteD6Vw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3a37bf5922-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 28 Jul 2021 23:15:45 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 23:15:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cyV/av5ItxilufKjspNYlJt+sojeqgt9ZiYGkNlll0fYbDGudiRzmf+SkWe/ZNz+somhQcQ9h4esWfbyTOo3dTqiGNCxN1tkFtSG5aZsdzCC51Pbh7tmTOEOuyoQbmad2kmJq4RbeDYO4aAzcxqwRMeq6VvDvEkvmn3EsPUyRkHlcFzWN78pEovXmPzTdJbgEnnyLLKk9OqWIu63L/7w0e8vyxLENu2W+kBVNq7iPB5Lb4F++W3R3NwA/JZWAj1KaiDPr2sZCcIlO0GSN6Cb/ZjkvsjYs951Un3iHENfdfFRFDOTzZ/SG1g1WvhtFOGO7ZJTQ1cSJOt2It7FXfmMLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZuIowdJJF7Mx5IZ5I8X4FsN3LrXand4X0W5QZVPY5ow=;
 b=A9vsRDB482Ss83/hLzLMUNSgpdxqd8TlPRY5z4lYIV+Auo213vrCy4lV72YcHk+4pi59vkpzVlTsH0f4F4DBoE3jwBTxmLzAoaFo0rRWxrcr4/vZIrfTIG8Qt/geEBsfszhWoOojQsdziwV0EC4pKUK6TmzoaB7DnhoHbqPeW+vJTQ2x5cm8HP2hFO5xcIv3NQO0UNR4bxzINN4zXUtBX4ihz0HGtLMk5F5pVRCykEV86M5aiQLEj0rOpTbR6Iwtc8UZKBD4gGJ5yV9j50VwSw0P4FVcpb6O7CRr5l2yxYO9gPq85vN5X/za6j5EGOeyVaglpkDA6RVMZg/oWLH/Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4871.namprd15.prod.outlook.com (2603:10b6:806:1d2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Thu, 29 Jul
 2021 06:15:43 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 06:15:42 +0000
Subject: Re: [PATCH bpf-next] selftests/bpf: move netcnt test under test_progs
To:     Stanislav Fomichev <sdf@google.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>
References: <20210728151419.501183-1-sdf@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <eae5801e-8cef-436c-ade6-84f9eea00871@fb.com>
Date:   Wed, 28 Jul 2021 23:15:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210728151419.501183-1-sdf@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR04CA0092.namprd04.prod.outlook.com
 (2603:10b6:104:6::18) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1181] (2620:10d:c090:400::5:d11a) by CO2PR04CA0092.namprd04.prod.outlook.com (2603:10b6:104:6::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Thu, 29 Jul 2021 06:15:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dff4f361-ba42-4785-efa7-08d952584b74
X-MS-TrafficTypeDiagnostic: SA1PR15MB4871:
X-Microsoft-Antispam-PRVS: <SA1PR15MB48716DE7EB46CB8C8E3812ACD3EB9@SA1PR15MB4871.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p3aoUsqlT2JWjUV44z7QgVbsJvh5q1Jiahhz514iJgr/UTDcU58iOc3sxgltkUQWZz2umAFaTRSqwoiSo9sqG4ABWxwmtw5RDikzMRhejFUz9xJhprIPZEaH+j/VJ1kK6HOT5fBZqEmszwZfT4fkmEUw24t80/LrJtZSSTdKrD4fZku4J2237TsFVbJbv8j+rSVeQ0VbRhIA4WvEswIBGCP3MHwF8rFY8DtmyTqr1WFG6Ap7wc8OLAqi8jqfCwzycc8XuFQuKiUP6/P2WofbTVhTIJVgIlfwioAgeYc1Q9/2H4auA4Ad7AMrBjSifA0r7iyT6fkfSEkGBw/9RQHuT+7EMEF4pgazMVLYvGr2v1PHfTq6dzBKSKK+Yd6oJpNt8cqrqLJh2fK5Mwqfz+rradkXkeRFUQxj2zYpPJWCcCyDT8iK6zoAgEvj9BsdnJ3ru5a/3uB9dd3OMUPgPETFVpasVuj517ciF8zuEbgR5lFH0nNsBKI0HMgw5R5prG5aQhw2p94aA5WgMHC4j673dobKvuG/HiJ5Ai2tbc2SejL0Mju06FAXG6sOCqYeo4fJ9Vcwsj7KLSZjm75AmA2/ipf+v0/t05xvQxLyH3gg8xa/5xcw/Ou4KdhwyMdGa/ujgfU8stPao8a7zsYhDt7wpcsek9Ig/4E+HvhruY1z4lRdAe0Av/kZQLLPIDq4NUSW0RvSQaf+9bponP1iCs/ANZIl7vF43prWg16e5sZqRKc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(6486002)(8936002)(66946007)(66476007)(38100700002)(66556008)(4326008)(86362001)(478600001)(2906002)(2616005)(31686004)(53546011)(83380400001)(52116002)(31696002)(186003)(36756003)(8676002)(316002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enZlVktoT0hNcWFTL3hMT3ZhanRncHp1RkU2L0hwY1BFNlJXQlNnay9DbGVV?=
 =?utf-8?B?VmhRekhSSW9hSDF1eVB0VzJpYmEvQVh0dml6STU0cmp6TitYRS9uZktiMlVZ?=
 =?utf-8?B?eXFvVkloY2V5Mk0rSy9iMkJUVDZoQkVLMU85TU52TE4wTEloRC9qR0VXd1Bm?=
 =?utf-8?B?Umc5MWs0RlZUNW1vV0JyLzAyTGFZQnViY3NXZS9kMisxM2JNaEZyUFlCRUVC?=
 =?utf-8?B?SjQ4RTVHTGJRSkZTTGNKVjIvcVVPQlZDemt5T2tDWFFYdDV3czdhblh2MzBl?=
 =?utf-8?B?TWVGWUdzOHBGZkl3MjhRNFA0U1lIejZkNHJLQXRWK0ZES296NUhBckk5Q0pP?=
 =?utf-8?B?SlAvcnNaenhLQ0liV2RKUzlSbkIwT3NMVnRzRTlNTWhmOEIvanVrWTJUVCs2?=
 =?utf-8?B?NHdKamJpM2YwY285b3prSldQcGxoNUU4anpZN3NwSFNuTElhNm1jb1UrbWo5?=
 =?utf-8?B?TjE4Y21VOGVkb05RTkdNS3FGTjVLdmZYK3MyR2MxSzEwUmZmeFRrZmNmanZM?=
 =?utf-8?B?Wk4xbUo5czlFWkZ4QjMyUVNxbjcybVFZOW9Yak1DY09KVzZYbUNETEJDNWlB?=
 =?utf-8?B?M0dkZ0UybVhQMGF6cHR2azlWa25zOTRXaGUrRUE2WjhrL3pyaHd2MzZzUHFa?=
 =?utf-8?B?cjVQeUJ6NTZ1eFpGWkx1QVZmRy9QdmtlSUcwWndYYzMrUll1azdWVGtoVi9I?=
 =?utf-8?B?elJBcjVxUC9wRGFEMVFxTEk1LzZWc3EveVYxMlMxdmRnbk5mUVlMUm5Uby9Q?=
 =?utf-8?B?cko5ei8vL2t3VW1zdGNnUTVHWk0vTE52cXozZlFwRlIxV3lMeU0wSXF5bWRa?=
 =?utf-8?B?aWhNdTExck1wOGxHSkFxYVFZZXRPaGF2L1k4TFFJV0R4NTVoY0dIcHRDc3Ar?=
 =?utf-8?B?UlBYKzJsYTFjYUFLcG53WXVQUnlsaVRKRzRaQVVaSTV0cVQwR1hTMU55c0pT?=
 =?utf-8?B?ajJLVVA0T2N6VlBYa09NU0E2WkR4VFJGZTBiZ0ZHSEZ5cGplakMxTzk5M1JL?=
 =?utf-8?B?MkpJSndJNFkxT05peDdBa0JtZnNoKzg5YmsrcEVvc3JuQmtGRHVpUDA2QVo2?=
 =?utf-8?B?OStrL3VJNUVSUFZFMGRSTjJTRFlHajVZcXQ4RGNuZlRhTjFYYUpWTEMzRUU1?=
 =?utf-8?B?OWhSRzJBWXlzL3ViQXRjWUlDK1ltdmdkam9JaFRSZEhJMTlIL3VVRmNoTWJM?=
 =?utf-8?B?UHFib3JoVCs0NmoxRXV4MmhWQzVBQjZwN2ZFbC9LK3p5L1BCNVB2T2VVclp1?=
 =?utf-8?B?VWhmeHJ5enpveUpqSXBKOHpyUHhIUG5tcXFpZ2ZJbld3VDYvOEJ0RXhybGVo?=
 =?utf-8?B?dlNJTUFmeGFvdUFBSVdabzlQOXk3VkN6K0JubG5lVHVYUGVUSE1zdHlyaWJu?=
 =?utf-8?B?M0VHRkRUTkJpSmhranE3SUdGdDRFSEdERGZvMkFpbm5jamZSSkVncTBITUVp?=
 =?utf-8?B?N2tzak92ZHJMeEN3UFpybG02T2FMSGdRWXpXYkZDRGdnZjNSY29FajRpYVZw?=
 =?utf-8?B?WCtMVUVVdnllUWtaWjMvSTBRWWpob0svQWpIMUM3RTlxcGFhTDNtUjhhWUVZ?=
 =?utf-8?B?S0FWS2cyUkN4N25WMkJ6dlVPeDVkTHJXRERHYkRIczJDOG53LzhLS0QrMnJV?=
 =?utf-8?B?MFlJZjRoeEREaWtnL0RNSDdPWVd6QVd4d2VEc3gwN0FkcG9mUFhYby9uVHgw?=
 =?utf-8?B?QXBaTGc1Tml5ZEViR2Q2Ti9CSjhpellTQ0VHZ3dxeWhiZm5Pb2Zvdkx2MTgv?=
 =?utf-8?B?N1pESG1BczRyNHMrSHJISGdjdVNuUFg2M0QraGVIZHZDZjV4M2VZUWk4dFVj?=
 =?utf-8?Q?6hYyxhYwEKwoVPUGML9UjnEzieXeVGlA+EilU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dff4f361-ba42-4785-efa7-08d952584b74
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 06:15:42.6999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pyalFxxPORXG+Pq4iUxxAl8Pf5ymqgod3L5wETkHQtodXh41dMN2031smF2FJz0b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4871
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: HIJ3M5XgZTNhopmtsiwvIXdfXVxoUd7f
X-Proofpoint-GUID: HIJ3M5XgZTNhopmtsiwvIXdfXVxoUd7f
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_06:2021-07-27,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 phishscore=0
 clxscore=1015 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290042
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/21 8:14 AM, Stanislav Fomichev wrote:
> Rewrite to skel and ASSERT macros as well while we are at it.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Thanks for converting test_netcnt to test_progs.
The patch looks good to me except a couple of minor issues.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   tools/testing/selftests/bpf/Makefile          |   3 +-
>   .../testing/selftests/bpf/prog_tests/netcnt.c |  93 +++++++++++
>   tools/testing/selftests/bpf/test_netcnt.c     | 148 ------------------
>   3 files changed, 94 insertions(+), 150 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/netcnt.c
>   delete mode 100644 tools/testing/selftests/bpf/test_netcnt.c
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index f405b20c1e6c..2a58b7b5aea4 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -38,7 +38,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
>   	test_verifier_log test_dev_cgroup \
>   	test_sock test_sockmap get_cgroup_id_user \
>   	test_cgroup_storage \
> -	test_netcnt test_tcpnotify_user test_sysctl \
> +	test_tcpnotify_user test_sysctl \
>   	test_progs-no_alu32
>   
>   # Also test bpf-gcc, if present
> @@ -197,7 +197,6 @@ $(OUTPUT)/test_sockmap: cgroup_helpers.c
>   $(OUTPUT)/test_tcpnotify_user: cgroup_helpers.c trace_helpers.c
>   $(OUTPUT)/get_cgroup_id_user: cgroup_helpers.c
>   $(OUTPUT)/test_cgroup_storage: cgroup_helpers.c
> -$(OUTPUT)/test_netcnt: cgroup_helpers.c
>   $(OUTPUT)/test_sock_fields: cgroup_helpers.c
>   $(OUTPUT)/test_sysctl: cgroup_helpers.c
>   
> diff --git a/tools/testing/selftests/bpf/prog_tests/netcnt.c b/tools/testing/selftests/bpf/prog_tests/netcnt.c
> new file mode 100644
> index 000000000000..063a40d228b6
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/netcnt.c
> @@ -0,0 +1,93 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <sys/sysinfo.h>
> +#include <test_progs.h>
> +#include "netcnt_prog.skel.h"
> +#include "netcnt_common.h"
> +
> +#define CG_NAME "/netcnt"
> +
> +void test_netcnt(void)
> +{
> +	union percpu_net_cnt *percpu_netcnt = NULL;
> +	struct bpf_cgroup_storage_key key;
> +	int map_fd, percpu_map_fd;
> +	struct netcnt_prog *skel;
> +	unsigned long packets;
> +	union net_cnt netcnt;
> +	unsigned long bytes;
> +	int cpu, nproc;
> +	int cg_fd = -1;
> +
> +	skel = netcnt_prog__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "netcnt_prog__open_and_load"))
> +		return;
> +
> +	nproc = get_nprocs_conf();
> +	percpu_netcnt = malloc(sizeof(*percpu_netcnt) * nproc);
> +	if (!ASSERT_OK_PTR(percpu_netcnt, "malloc(percpu_netcnt)"))
> +		goto err;
> +
> +	cg_fd = test__join_cgroup(CG_NAME);
> +	if (!ASSERT_GE(cg_fd, 0, "test__join_cgroup"))
> +		goto err;
> +
> +	skel->links.bpf_nextcnt =
> +		bpf_program__attach_cgroup(skel->progs.bpf_nextcnt, cg_fd);
> +	if (!ASSERT_OK_PTR(skel->links.bpf_nextcnt,
> +			   "attach_cgroup(bpf_nextcnt)"))
> +		goto err;
> +
> +	if (system("which ping6 &>/dev/null") == 0)
> +		assert(!system("ping6 ::1 -c 10000 -f -q > /dev/null"));
> +	else
> +		assert(!system("ping -6 ::1 -c 10000 -f -q > /dev/null"));
> +
> +	map_fd = bpf_map__fd(skel->maps.netcnt);
> +	if (!ASSERT_GE(map_fd, 0, "bpf_map__fd(netcnt)"))
> +		goto err;

For skeleton, map_fd is always valid and you do not need to check it.

> +
> +	percpu_map_fd = bpf_map__fd(skel->maps.percpu_netcnt);
> +	if (!ASSERT_GE(percpu_map_fd, 0, "bpf_map__fd(percpu_netcnt)"))
> +		goto err;

The same for percpu_map_fd, it is always valid and no need to check it.

> +
> +	if (!ASSERT_OK(bpf_map_get_next_key(map_fd, NULL, &key),
> +		       "bpf_map_get_next_key"))
> +		goto err;
> +
> +	if (!ASSERT_OK(bpf_map_lookup_elem(map_fd, &key, &netcnt),
> +		       "bpf_map_lookup_elem(netcnt)"))
> +		goto err;
> +
[...]
