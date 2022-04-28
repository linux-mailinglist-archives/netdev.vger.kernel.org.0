Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C78F513CF7
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 22:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351541AbiD1VC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 17:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241199AbiD1VC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 17:02:56 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA49CC0E6A;
        Thu, 28 Apr 2022 13:59:40 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJfqkW001368;
        Thu, 28 Apr 2022 13:59:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=AKfrtCJsSsFKxsxypLdorMOUHBDB7k826HnGNUmSABA=;
 b=nAXm+0U8D6RfCgKqZ4SbTBc6FUFpvZr/Zs3Kdu7qCaWyjQOghRFwXyIgauXJE31qrOKb
 +tzsZBOEPloUkCZGY/Ru0Yy9IPnUco0cPBmiTHNv0sn02lLXpFuUezUXqwys9Qe1rI0y
 5iR0lPmcgchV/1D9YFhNcMwo7Vr0t7dfP0U= 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2045.outbound.protection.outlook.com [104.47.74.45])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fqkncx0d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 13:59:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lkTuPJNeO3KYpuV35yqGAno+HIJ5DxHs1PMO6TtJQKJ+Ek7UgissjeQQUyariH7DwtPB3ILWN0O+5+LPCiezI0HWsTFCDRG/yUekQ+EtEpnm652LEmdhS9CnUM/BM1s4HwTFZrVIQwcecz6TPjGdpBPwQdDgxjJlo7o2iQzvwkYSheThpFCF9UBURSP8V02iHAModduhLNqKC6aEGmSoesqehXVxyb6lEJNU1e2Jh9UsfwolJ66zY3nhXsgw5UvcQ6wTgkMvUwuzQI5EoKordPQr5iJ7uSVnO60xkV20UajRat/krczIwfRmZb+EHJoz1iA7gfTgKWb/1V4RqxMJDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AKfrtCJsSsFKxsxypLdorMOUHBDB7k826HnGNUmSABA=;
 b=QZuuI9WCgm96L6wbDIynaG6UAuyCNi1JuwLCn/ZEIjFlRPQM3SsVN+EesF5Vb4nMPASWOBr8rHUzhTs2VZ55kvqAi51qWk9YGephmhVMPX2K0tkhMpNOuhPhvC62A+iz1/QjPpC6Rl2LrwxEnz4ZmesYC6HOZzvJ5VLDfo4f/JGjMP9az5Jk4pA2Q+M+A+QeBDRbEsS0zqJtEOXiYccsWCgqvkIRqoyZjto4nV7dTJC9b6Y/qS8niYhmiqZzI0ENokfRL99/tvYdj6G3iaTrsNkw7jkd81N8H/jDK857ejzoamh27N87uNmgGCOpSuEvx5uTUvXQPCwkWzTjaXqdyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SJ0PR15MB4760.namprd15.prod.outlook.com (2603:10b6:a03:37d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 28 Apr
 2022 20:59:23 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 20:59:22 +0000
Message-ID: <e6ab1b5c-f870-418a-638c-9fdb917a124f@fb.com>
Date:   Thu, 28 Apr 2022 13:59:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH v3 bpf-next 2/2] selftests/bpf: handle batch operations
 for map-in-map bpf-maps
Content-Language: en-US
To:     Takshak Chahande <ctakshak@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     andrii@kernel.org, ast@kernel.org, ndixit@fb.com, kafai@fb.com,
        andriin@fb.com, daniel@iogearbox.net
References: <20220425184149.1173545-1-ctakshak@fb.com>
 <20220425184149.1173545-2-ctakshak@fb.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220425184149.1173545-2-ctakshak@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0077.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::22) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 686b608d-f57e-4bb3-87e5-08da2959f890
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4760:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4760684E0D59957B9D7F91BAD3FD9@SJ0PR15MB4760.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DqpY6h3L6h8D0omGdA870w3UQhKcbHjo3ocoreCYcTopu8dDyL+X+2Nad/UQ80790HpWQ6UDK1c0yz3epxzykkni4leOs68sNiMlsub3giXnQ0Hn925o6or38li47juwJbHwgs6rKLu1WLwrrZPFsHzCmTe/U5rB1PMb8walhfkdgde+4x9Jmu+5dZ+p5IT5dltWuthqPWv6U3qdZw23Qf2uQIqHWiuAXZlu8Yqpxf2eNfws8BV2VfwvuTdks5+ra5nR48o+z2qh2OOCHfDiQuuntrW9pTluYJjLiHnyQdM43AjQc9ZII2C55YEvjDSBfjRZn8i7asP0POBSaevwdiqH5Y6xTlWIqwCmHbMS5N0To2JeE8RNWtnWEqKP7drYB+iKvaIaihdp9otpKOvi7FihrVPwEfAgupZqjKzb6xLQWFGc5CavGVXrAWzaI2JiK13+xw8YCT/z29x8qJMra2+rDx8xEL31gfmB3V1dH0U4jp/ebT3lLRloBnML3PwRQhSoBJCXGVCfVMi3ctcaa2blFFf+Vam3ElVVPzds68n28DmbuhrJypqxHSzwzYdKA/vrCaODE4RHPaOuQoga20uXEaykdBjbLv74GqHkJpZBGLxNPUedOROiYzKnAP7+JlkUIsjfJQb7HXSM8t4splt3Y/1mfln4dpSDfI9BLLQ6gfBJowa7mU5Ab6epelk0RdwUMSbNOkbyAK6lYJXBTwffutQowgp7UIU25cvHm4tXpaDe8L0wBoEsKZYAf6x/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(2906002)(66556008)(5660300002)(36756003)(52116002)(186003)(66476007)(316002)(83380400001)(8676002)(4326008)(8936002)(31686004)(2616005)(86362001)(6486002)(31696002)(508600001)(38100700002)(53546011)(6512007)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TU1HLzRXaDExaFJ0dnE1M0dMSlZhU3BGQkM4U2tIb0Y0blhLbjg5TEJFWC8v?=
 =?utf-8?B?UjJFNXErQVczeDQyNVluUDE4RlJlTisvS093RldhRmRadVZ1c01VQkhtaGIv?=
 =?utf-8?B?QXIyNE0vS29pTUZVOC8xUUJtM0h0c1dPT2s0VDNmQnRCUTAzV3BvVEhCOEMy?=
 =?utf-8?B?NjZtd2k0OHpiSFN0VDd6ZmlVU3o2TTBGVzVSSGtiTFJZMUdIRUR2OGlCSjNn?=
 =?utf-8?B?a0I5NXBLU2JnMXk2SzhMUmxnY2tWQ1E3R01temhrang2d3FsWjhmelRBOHVX?=
 =?utf-8?B?cEN1bTY2cnV6Q1YweVpEeXNiaHk3WEZKS1ZtYTI5RzN0OHJ6SXBjdUVDb3Zv?=
 =?utf-8?B?T09RekZ2c3A4S1QxYS9WWGNuam4zcFVrTXNKOFR4UnJQVGxHM2tETEEzUFNW?=
 =?utf-8?B?SkxpVDJaS2ZYa1YxMTJkVVRFMFpXbGFyN0ZjWjJFekNPaFJZU2czdVRGUnFH?=
 =?utf-8?B?MTg0TFpkODJTZGh3cGZ5aXByVHN4cml3YUNjU3dkNjIyNVoxMkJHc0tNVDM4?=
 =?utf-8?B?RDdyV2taR3BSQVp5UnhPOE0zY25NZDNVWDVzcnc2MEZVYWQ2M0JJOHZsN1By?=
 =?utf-8?B?Ym10MklYTXk1UnhJcmhDSERrdDdqczBOMDJZYW1yazh4eWlUWDBiSFdyTzZE?=
 =?utf-8?B?TXE1TDNpRzUxYjd6TjRWeXl2cTBMdTRDOG45Q1MrQ3RTRU5GRzJlbkpTeW9V?=
 =?utf-8?B?MXgvSHdtTDZ5bTFacDZNajBUM1M2eThVa0J6Wk5VdUNCd2JvMS9hR3ZtVTlZ?=
 =?utf-8?B?Z2M5cXZDejBTbERKVWFNZlc0dmpuRFlXWCtDSkcvZ1VzL09Ld01FeXZQZHEw?=
 =?utf-8?B?UlU4ZjlhQTVwRE1DamZaVG9WVi91cWNkZ3E3Mm5abnRNcmtCcjZLeGRyaW1h?=
 =?utf-8?B?UzB2YUJydkJLa21ZU2s2bFIxOFRmcGFwM0FqOXNCditndzdzb09NaDZqTE1S?=
 =?utf-8?B?NnBvb2VaQUtzNlZ1d1c2M2dLalpXcDNnZUU2VDQ1eXlURkxhZTRaVmFVSCtp?=
 =?utf-8?B?V0pQQzgxQzRlK2cxQW5CQTNHMmJkeERMT0QzSCszSytvLzcxVzA0NU9HaXRz?=
 =?utf-8?B?ajNyZ1JVUDgxbXdHeUpsc3N5QzdPTXlzdDN2a05NUGlIQmEwcGJBeEJKTWVQ?=
 =?utf-8?B?L0lsSFFwOGlFRGxQTFVDK1ZqSityVnozWklhamdIaHQ5b3RicTRKU1Bqc3J0?=
 =?utf-8?B?R2xGbHhkOTZEVEJ0Syt1bFlsVFdQQy94aTZYbTVtSmsydllIYUxRNlVTcFA5?=
 =?utf-8?B?ekk5SnZLa25VVFh6Wk5jMDJaMzgyK01FNitncFR5Q3RjU0pTaUZZOTM4Ukdh?=
 =?utf-8?B?UUJnT0dmMlVFbVV3cW1Sd3ZDTi9FVUxIL0VReGtmeEVKSk4wcVBYSDRMdE83?=
 =?utf-8?B?OVJyZTJHeFVvREdaUWFMWWswcFZKT09SRVFiNXF5QWNreTZqcmhrc0V2OWFa?=
 =?utf-8?B?cEZBMGRLV0NmZ1pQV29Mam55NUhnQUZHNy81NVVDSHZrTGNPMmJ4S1M4MzhT?=
 =?utf-8?B?RDlMaXZ3NTNuSlVhd25WNlFEdzNMNmNuYVBoZkdHaDZnbmdyVkkwN2Y2TlNG?=
 =?utf-8?B?Z3A2enU4bUdnOHFwVTdwQ2FvMkNZTk96MkJBeTlTUEt4Y2lZOHdzNUY1QkxV?=
 =?utf-8?B?SFZhUkxHM2JSN3g3T1B6TnMwMmJnbUMrenpLM1NDVVlwYkF6bU1TVktsdzRk?=
 =?utf-8?B?L0YyYXNhanBqRzQ4MnJpZTB4T2NjNjYwZDN6MnRMSzI0UFBpMW1DakszWEhw?=
 =?utf-8?B?UktROEJBZFU3K3BjU1huS1FCV1lJNHZKQ2p4Tk5RUDRsVzZYcEFZTkVhSGVK?=
 =?utf-8?B?WTlTckhmT1NlOS9zVzZuTm5iVDFzOUwrS0U5bWV0Rm1JSDFZdGxjMisyUno4?=
 =?utf-8?B?ZTBudXlyWnYzZzdiSE50TWMvQi9sa3d1NFRLZEUrS2RMeHUwZkdPczBCOWNZ?=
 =?utf-8?B?VXAyTXBtWGc5bG9pUFlTMzF6WGppT0wwREZIaG8xaExyemlzR1VGeS9mTEFL?=
 =?utf-8?B?VGR2OEJuLzdiamRMMmlCbkVJNzN5NWJIcFNSLzg2NnZ5K28zRUU2RllnaUZL?=
 =?utf-8?B?RzlXczRwendQeERSQjBaSUVxVVZkQnJTMlhoZHg2UCtKZ01rSXl0Ym9JYUpK?=
 =?utf-8?B?RHdocGk4bXRqTmNOUGxUM1dKV2U0Y1hsaEE3a0lKOG92dXRNZTRJL0JobVFY?=
 =?utf-8?B?aVhCWEhZa1Z6N0ZncngrYlBqemFqL3Fma2ZhdndkZHhDQmJGUWl4cFlmYVZ0?=
 =?utf-8?B?WWhmKzBUYmxiUmFSR3dtUzU0a1haZTU1d05LK0U4QlpraUw1NXQ0ZzFNc0NP?=
 =?utf-8?B?Wm1JWC81dlh2RmU5M3cyNnBvM2NJbzVuanJLaWZJK0NpcCtZODRhUEkxV3h1?=
 =?utf-8?Q?Sfsmahhifd5Fq0Xk=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 686b608d-f57e-4bb3-87e5-08da2959f890
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 20:59:22.6958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S4ZIdHd3J8OeS468ORCtGnLPIanGZ9KDqUGe27MfUEULVlYR09fOtoLlechlxeX3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4760
X-Proofpoint-ORIG-GUID: wp9bN9SR64TeIgiLnZdEDB8ZzRGI2KJW
X-Proofpoint-GUID: wp9bN9SR64TeIgiLnZdEDB8ZzRGI2KJW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-28_04,2022-04-28_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/25/22 11:41 AM, Takshak Chahande wrote:
> This patch adds up test cases that handles 4 combinations:
> a) outer map: BPF_MAP_TYPE_ARRAY_OF_MAPS
>     inner maps: BPF_MAP_TYPE_ARRAY and BPF_MAP_TYPE_HASH
> b) outer map: BPF_MAP_TYPE_HASH_OF_MAPS
>     inner maps: BPF_MAP_TYPE_ARRAY and BPF_MAP_TYPE_HASH
> 
> v2->v3:
> - Handled transient ENOSPC correctly, bug was found in BPF CI (Daniel)
> 
> v1->v2:
> - Fixed no format arguments error (Andrii)

Please put the above version changes between
    create mode 100644 
tools/testing/selftests/bpf/map_tests/map_in_map_batch_ops.c
and
    diff --git 
a/tools/testing/selftests/bpf/map_tests/map_in_map_batch_ops.c ...

So they won't appear in the commit message when the patch
is merged. The same for patch #1.

> 
> Signed-off-by: Takshak Chahande <ctakshak@fb.com>

Ack with a few nits below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   .../bpf/map_tests/map_in_map_batch_ops.c      | 239 ++++++++++++++++++
>   1 file changed, 239 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/map_tests/map_in_map_batch_ops.c
> 
> diff --git a/tools/testing/selftests/bpf/map_tests/map_in_map_batch_ops.c b/tools/testing/selftests/bpf/map_tests/map_in_map_batch_ops.c
> new file mode 100644
> index 000000000000..f1eee580ba2e
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/map_tests/map_in_map_batch_ops.c
> @@ -0,0 +1,239 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <stdio.h>
> +#include <errno.h>
> +#include <string.h>
> +#include <unistd.h>
> +
> +#include <bpf/bpf.h>
> +#include <bpf/libbpf.h>
> +
> +#include <test_maps.h>
> +
> +#define OUTER_MAP_ENTRIES 10
> +
> +static __u32 get_map_id_from_fd(int map_fd)
> +{
> +	struct bpf_map_info map_info = {};
> +	uint32_t info_len = sizeof(map_info);
> +	int ret;
> +
> +	ret = bpf_obj_get_info_by_fd(map_fd, &map_info, &info_len);
> +	CHECK(ret < 0, "Finding map info failed", "error:%s\n",
> +	      strerror(errno));
> +
> +	return map_info.id;
> +}
> +
> +/* This creates number of OUTER_MAP_ENTRIES maps that will be stored
> + * in outer map and return the created map_fds
> + */
> +static void create_inner_maps(enum bpf_map_type map_type,
> +			      __u32 *inner_map_fds)
> +{
> +	int map_fd, map_index, ret;
> +	__u32 map_key = 0, map_id;
> +	char map_name[15];
> +
> +	for (map_index = 0; map_index < OUTER_MAP_ENTRIES; map_index++) {
> +		memset(map_name, 0, sizeof(map_name));
> +		sprintf(map_name, "inner_map_fd_%d", map_index);
> +		map_fd = bpf_map_create(map_type, map_name, sizeof(__u32),
> +					sizeof(__u32), 1, NULL);
> +		CHECK(map_fd < 0,
> +		      "inner bpf_map_create() failed",
> +		      "map_type=(%d) map_name(%s), error:%s\n",
> +		      map_type, map_name, strerror(errno));
> +
> +		/* keep track of the inner map fd as it is required
> +		 * to add records in outer map
> +		 */
> +		inner_map_fds[map_index] = map_fd;
> +
> +		/* Add entry into this created map
> +		 * eg: map1 key = 0, value = map1's map id
> +		 *     map2 key = 0, value = map2's map id
> +		 */
> +		map_id = get_map_id_from_fd(map_fd);
> +		ret = bpf_map_update_elem(map_fd, &map_key, &map_id, 0);
> +		CHECK(ret != 0,
> +		      "bpf_map_update_elem failed",
> +		      "map_type=(%d) map_name(%s), error:%s\n",
> +		      map_type, map_name, strerror(errno));
> +	}
> +}
> +
> +static int create_outer_map(enum bpf_map_type map_type, __u32 inner_map_fd)
> +{
> +	int outer_map_fd;
> +

Remove the empty line in the above.

> +	LIBBPF_OPTS(bpf_map_create_opts, attr);

LIBBPF_OPTS is a declaration. So put an empty line here.

> +	attr.inner_map_fd = inner_map_fd;
> +	outer_map_fd = bpf_map_create(map_type, "outer_map", sizeof(__u32),
> +				      sizeof(__u32), OUTER_MAP_ENTRIES,
> +				      &attr);
> +	CHECK(outer_map_fd < 0,
> +	      "outer bpf_map_create()",
> +	      "map_type=(%d), error:%s\n",
> +	      map_type, strerror(errno));
> +
> +	return outer_map_fd;
> +}
> +
> +static void validate_fetch_results(int outer_map_fd, __u32 *inner_map_fds,
> +				   __u32 *fetched_keys, __u32 *fetched_values,
> +				   __u32 max_entries_fetched)
> +{
> +	__u32 inner_map_key, inner_map_value;
> +	int inner_map_fd, entry, err;
> +	__u32 outer_map_value;
> +
> +	for (entry = 0; entry < max_entries_fetched; ++entry) {
> +		outer_map_value = fetched_values[entry];
> +		inner_map_fd = bpf_map_get_fd_by_id(outer_map_value);
> +		CHECK(inner_map_fd < 0,
> +		      "Failed to get inner map fd",
> +		      "from id(%d), error=%s\n",
> +		      outer_map_value, strerror(errno));
> +		err = bpf_map_get_next_key(inner_map_fd, NULL, &inner_map_key);
> +		CHECK(err != 0,
> +		      "Failed to get inner map key",
> +		      "error=%s\n", strerror(errno));
> +
> +		err = bpf_map_lookup_elem(inner_map_fd, &inner_map_key,
> +					  &inner_map_value);
> +		CHECK(err != 0,
> +		      "Failed to get inner map value",
> +		      "for key(%d), error=%s\n",
> +		      inner_map_key, strerror(errno));
> +
> +		/* Actual value validation */
> +		CHECK(outer_map_value != inner_map_value,
> +		      "Failed to validate inner map value",
> +		      "fetched(%d) and lookedup(%d)!\n",
> +		      outer_map_value, inner_map_value);
> +	}
> +}
> +
> +static void fetch_and_validate(int outer_map_fd,
> +			       __u32 *inner_map_fds,
> +			       struct bpf_map_batch_opts *opts,
> +			       __u32 batch_size, bool delete_entries)
> +{
> +	__u32 *fetched_keys, *fetched_values, total_fetched = 0;
> +	__u32 batch_key = 0, fetch_count, step_size;
> +	int err, max_entries = OUTER_MAP_ENTRIES;
> +	__u32 value_size = sizeof(__u32);
> +
> +	/* Total entries needs to be fetched */
> +	fetched_keys = calloc(max_entries, value_size);
> +	fetched_values = calloc(max_entries, value_size);

Just for completeness, should we check whether either of
fetched_keys or fetched_values is NULL or not?

> +
> +	for (step_size = batch_size; step_size <= max_entries; step_size += batch_size) {
> +		fetch_count = step_size;
> +		err = delete_entries
> +		      ? bpf_map_lookup_and_delete_batch(outer_map_fd,
> +				      total_fetched ? &batch_key : NULL,
> +				      &batch_key,
> +				      fetched_keys + total_fetched,
> +				      fetched_values + total_fetched,
> +				      &fetch_count, opts)
> +		      : bpf_map_lookup_batch(outer_map_fd,
> +				      total_fetched ? &batch_key : NULL,
> +				      &batch_key,
> +				      fetched_keys + total_fetched,
> +				      fetched_values + total_fetched,
> +				      &fetch_count, opts);
> +
> +		if (err && errno == ENOSPC) {
> +			/* Fetch again with higher batch size */
> +			total_fetched = 0;
> +			continue;
> +		}
> +
> +		CHECK((err < 0 && (errno != ENOENT)),
> +		      "lookup with steps failed",
> +		      "error: %s\n", strerror(errno));
> +
> +		/* Update the total fetched number */
> +		total_fetched += fetch_count;
> +		if (err)
> +			break;
> +	}
> +
> +	CHECK((total_fetched != max_entries),
> +	      "Unable to fetch expected entries !",
> +	      "total_fetched(%d) and max_entries(%d) error: (%d):%s\n",
> +	      total_fetched, max_entries, errno, strerror(errno));
> +
> +	/* validate the fetched entries */
> +	validate_fetch_results(outer_map_fd, inner_map_fds, fetched_keys,
> +			       fetched_values, total_fetched);
> +	printf("batch_op(%s) is successful with batch_size(%d)\n",
> +		delete_entries ? "LOOKUP_AND_DELETE" : "LOOKUP", batch_size);

indentation issue?

> +
> +	free(fetched_keys);
> +	free(fetched_values);
> +}
> +
> +static void _map_in_map_batch_ops(enum bpf_map_type outer_map_type,
> +				  enum bpf_map_type inner_map_type)
> +{
> +	__u32 *outer_map_keys, *inner_map_fds;
> +	__u32 max_entries = OUTER_MAP_ENTRIES;
> +	__u32 value_size = sizeof(__u32);
> +	int batch_size[2] = {5, 10};
> +	__u32 map_index, op_index;
> +	int outer_map_fd, ret;
> +	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,
> +			    .elem_flags = 0,
> +			    .flags = 0,
> +	);

Do we need this opts, why not just NULL pointer for opts?

> +
> +	outer_map_keys = calloc(max_entries, value_size);
> +	inner_map_fds = calloc(max_entries, value_size);

check whether outer_map_keys or inner_map_fds is NULL or not?

> +	create_inner_maps(inner_map_type, inner_map_fds);
> +
> +	outer_map_fd = create_outer_map(outer_map_type, *inner_map_fds);
> +	/* create outer map keys */
> +	for (map_index = 0; map_index < max_entries; map_index++)
> +		outer_map_keys[map_index] =
> +			((outer_map_type == BPF_MAP_TYPE_ARRAY_OF_MAPS)
> +			 ? 9 : 1000) - map_index;
> +
> +	/* batch operation - map_update */
> +	ret = bpf_map_update_batch(outer_map_fd, outer_map_keys,
> +				   inner_map_fds, &max_entries, &opts);
> +	CHECK(ret != 0,
> +	      "Failed to update the outer map batch ops",
> +	      "error=%s\n", strerror(errno));
> +
> +	/* batch operation - map_lookup */
> +	for (op_index = 0; op_index < 2; ++op_index)
> +		fetch_and_validate(outer_map_fd, inner_map_fds, &opts,
> +				   batch_size[op_index], false);
> +
> +	/* batch operation - map_lookup_delete */
> +	if (outer_map_type == BPF_MAP_TYPE_HASH_OF_MAPS)
> +		fetch_and_validate(outer_map_fd, inner_map_fds, &opts,
> +				   max_entries, true /*delete*/);
> +
> +	free(inner_map_fds);
> +	free(outer_map_keys);
> +}
[...]
