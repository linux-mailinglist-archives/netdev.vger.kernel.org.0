Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633FD4AC8AD
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 19:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbiBGSgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 13:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235781AbiBGSeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 13:34:19 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D723AC0401D9;
        Mon,  7 Feb 2022 10:34:18 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 217H9Y10025613;
        Mon, 7 Feb 2022 10:33:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=WB5t/Jzvq+bzciRnP9RyGGFEhWenEodUJlNBeaSyLFw=;
 b=nwWz5NGeKZ4idz3nySzMmrae8ihr5v7Dmw3ZCZsKdgc6i/z21JZS2DcLrzKJDoFyxZC/
 b7G71SjdY73LYK8W3slE+JbTQZ3MoxUR2Cp1r8LRQnGvVCeXmukoY+Y6vDktmFl8Yj0/
 VuFmua9lr2DEpBoCkSRjKML/xqpXXh9Z8PE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e2xd5v2rp-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Feb 2022 10:33:50 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Feb 2022 10:33:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bs7asiN5XaQvpvLMSKz4TkVoQFQT62C/J2dMF1XFgPVX+4imhEcarH85cwcNA7h6lJXeaM+M/gyuI/7nKkifTsZqLjcPjmJ6NJHJKAZy6Hc30g67hsE5xUfvEAAaJ9lkPU2VBZjOmM6Gz6WmhzK/9LJxLrf/dzYeu+5NqgSbsxjFO+qVcXxCmXmKqdMx2hzs+p/2K+hR680x+QHOdniZqDQUBasY72yhMHdsRtgIHDO6RjF3MdSb3Fl/Un4G7Vm6yQ0dyTn2mT3ASdMXfAyqhwbrV297IOKSBYIf/sAf6aKcjgMpy44f5WtIoZKvqxE4f5w3kvsntQBTxBG7vV5GcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WB5t/Jzvq+bzciRnP9RyGGFEhWenEodUJlNBeaSyLFw=;
 b=EpUqQNRTZ1DePywCgOoa01A3DjKBB0i9vYMy9rap90eOonsu2bNRtZJ/m+f0i2MHntfJngcghZ3j38nnC953MKNlWCxn5o6UN9ireAcaMlhefwauTaf5EwaNTYzZ6NEsnq0czY/uYnbRdu/9RPwrG6uhLbI3y5vTptFQ7kX9Ng+9oxXT05vjZOxh3GFEfBKWVBZrkVubYYwB2hMGnbmcQJBOKvPlldwRVu4Dz3lYKQxpr6hMJXdhfh4jWthBnZ5e9KVrAr2OGvO2e/e233RcgIIw8V1FG3j+cEwy4mmXYmw/6loKQF4b1WqfEuKJIhfZXq20ZzdxXnU8JTn9OpgQAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM5PR15MB1865.namprd15.prod.outlook.com (2603:10b6:4:4e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Mon, 7 Feb
 2022 18:33:46 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0%6]) with mapi id 15.20.4951.019; Mon, 7 Feb 2022
 18:33:46 +0000
Message-ID: <585256c2-318f-3895-8175-e7d7cbe1cd4f@fb.com>
Date:   Mon, 7 Feb 2022 10:33:43 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next v4 2/2] selftests/bpf: check whether s32 is
 sufficient for kfunc offset
Content-Language: en-US
To:     Hou Tao <hotforest@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>
References: <20220206043107.18549-1-houtao1@huawei.com>
 <20220206043107.18549-3-houtao1@huawei.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220206043107.18549-3-houtao1@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR11CA0037.namprd11.prod.outlook.com
 (2603:10b6:300:115::23) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 502671bd-d975-4ecf-dd0c-08d9ea68606e
X-MS-TrafficTypeDiagnostic: DM5PR15MB1865:EE_
X-Microsoft-Antispam-PRVS: <DM5PR15MB18651396ADDDCCCDBE974D9BD32C9@DM5PR15MB1865.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eZFxYoMFDYzgbB+AxoaeyX4TUzC3ylCFezIcbV7GfcEmGQTzkHALdwghsSlBkPOKJLABRyZ2j5S7HUinvRsaJCOD6w/V9P8pOGeHKRbq5aVx5HKu3f5W9Y8vzo+ozXJ2pobh6AeRGiWgQ8kER0Q9M0umaigF91SQ6TFO7rUzuID4WOjUverUWui1tS7PEnh8X+Xk4wJW4SE6qDIOpP3Wr0dFP5wlZgm/tl4NGPZZ1mIPN+PPxjUW9onUeEvely9ysmFkRDOmCyNh/5/QC/H4c8hS+Q4tqOgafIgV19NV9fuFkfO2lCf2xNQwOQlywsWbf7UKJINOYAozscXX1FK/CYxW2R4BUexvND8YXbrQ1gM9vBgdC+pJv8NWNiMOpF+KUQVvVossDo3y1vEJJkkHWsjWvSOJoyjoDvFsR8jBM2oTeADq8WyQfPtBrgvODe4GSi09a3lbqMdOru5pTgskye6vrsL2t/ms4FEfSpUOP9ZGmVsmdvdr90gDjcF1haFx4Kagkjjm1qby2uOt3tuv8mazsMCboJ4PL2Uo66nS3wOuBoNnHcRtnZ8kSOudYDgXZ0JRjHuSfeFjTdqsLL+zdV15kbXZr5IMdna8ugzyTKuSg+duNO3dR+DWnYk60oATT41SYKL5ga3XKN5ZbdRjPLpaySxffy3vkt3cgtQRXM+IHnQIGTIYK8KA8dDAk9n9tStmG84yy3NcYYBmUoIozGdpJAYmp+StWzo3HXW7ebmNd0tr7sRYGU1oNhPMazP6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31696002)(5660300002)(66476007)(6666004)(66946007)(8936002)(66556008)(6512007)(4326008)(6506007)(8676002)(7416002)(36756003)(53546011)(52116002)(31686004)(6486002)(508600001)(110136005)(2616005)(86362001)(2906002)(38100700002)(186003)(316002)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NjlRWnVGYnJTYTY5TDlHUXNCVzJWaTFTZ2lGVVlOREpnV3BpTkRvcFVscGZ5?=
 =?utf-8?B?Vk4waGs4ODZYbW9yYVk3U0FVbGoyRDdvTnVsRDB0amR3dVM3UEhOeFJ0Yzkx?=
 =?utf-8?B?TVBNYkxjWnhLR2V3M0UvTG1OdExMVkRXWW5sUnVnZWd0T2x2TnU3alU3RkRx?=
 =?utf-8?B?Nnd3UkFQbkw4QmEvcHNwT2M1NWk5cU9wbktyZmxSUWRCSkJWcXM1UThYdkdr?=
 =?utf-8?B?N3RLUVRXcW1iYjVFT2VxbjNKczRKTk5vdE4zYnNHc3RMYkdrWUR3RDhzMnMv?=
 =?utf-8?B?NHNaU01tS0djaEZCRnZMU2FRM2xZcHYrUzlmR1NHR05aR3NYelFyaXVONlFK?=
 =?utf-8?B?cEx3WFVPNVNQd0V1eVNMY01XM1BtV1dzaE9vMlU0WW1ZU3FOalFUZHB2VE5k?=
 =?utf-8?B?dHJFNm1tN25URngvZTlzOHgzay90bDh2WHptZVBrdUM4T1cyWmZBN2djYWh3?=
 =?utf-8?B?bXJRNWpkaTduMkhvRFJhVW5za3JEaGlFRGp3NlpNRDVuTjBnOWtmdGxyeGky?=
 =?utf-8?B?RndIME9oSVRCSVVudHB0NWZ3Y2NkdjhlL2lUbE5aRDhJWWVWL2NLQzRyZE1q?=
 =?utf-8?B?UXJmbDI2Z0gvemtmcldicS94cHlJK1Y1ODFFUnVQME1CbW9La0pTcUNSQ0tS?=
 =?utf-8?B?MlpGRURFci9Rc040R0Z2c29uRGhteVIveEZCc3pJUjIzelRscTJXZnV6Mk5v?=
 =?utf-8?B?SnJEcjdDWW5KSUhveDdCTmpPci9EYXdOR0ZUOTVJdm13SmNzS2JINVVtMU1C?=
 =?utf-8?B?b1Y1VXJoS2FkV3NXSW1ORUpDWUlUUStCb3VrRHJDWEU1cjZrNFpKUHgzZk5M?=
 =?utf-8?B?TEppSXQxeW9yMTUwSUoxZ2M5b3RnWStpN0d6YW0rQ1NlVmJEd09OaVZSc2pP?=
 =?utf-8?B?eWJJdU1FdmRad1pFY1Rsbm9zNEZrNzlzM29IK1JBTlFBdndTbHhVS0doTkN3?=
 =?utf-8?B?S0c2MDlvQndQRmZUTkJBRmhOQldQR1RzQm5RUzYyWWRFdk5XdjZHdTYyQWYz?=
 =?utf-8?B?K1VSRXcvVU5YQWdPaWV3NldUbnAxK3k1alNnV3hRZkMvRkNaYjhyU0ZnRzJL?=
 =?utf-8?B?a0szVVlHTnA0YUpwNTl1dUZkajVMYVNKUVIrZWpLalhCamNoS3NXR1BaSmlF?=
 =?utf-8?B?THl6VkU2bUhiZmZTdmZ3RDA3TExzSUVneENnSnhHSTF3Y3ZrZk9DRDM1M25F?=
 =?utf-8?B?ODVEN2IzeTJ2UktnM1Bvb0JPV3p5TFVaeUVKd0lVNms0RHdEWFNoN0NwNFFZ?=
 =?utf-8?B?S3BTaVNOaUNGRVFHeWxJSkRvU1hwRFVLZFVVTGV3L1dreldjTXdPc3oxdmhL?=
 =?utf-8?B?UUtsYk5zVlByU1l1YU4vOExIM2dxSU5xT3lPYzJEU0JzK3lyNzZwVmJNR3hy?=
 =?utf-8?B?YUwvWjVZY1I0SDV4SnlreTNIazNGS1FyeU9kN1NJRjVVV1JMZkljWDFxZUJp?=
 =?utf-8?B?alMxQWE3eGlBemhOeXpjc3Q0RGl0TGNOcHhMQ2ZWQ3pWZ09TSnRhUzJ1djFH?=
 =?utf-8?B?WmR0eUlRZElRYU5ZeXA5TndJS1dPVDJuL1UzU21Ra25BN1VYRWZaT0I2L3BT?=
 =?utf-8?B?NGdJWkJDY1NLMnZETlU4QTIzNzVLL0Z3bmFnUDZnd0gzY0ZYSnNNTW53N2lC?=
 =?utf-8?B?N09ucW1NbFladStBc3FsUXZkTjlxK3RnbFNBNFo1UHFWelFwN0N5eng1R2NC?=
 =?utf-8?B?SUt2WUNYZUREekFjSVowV2RVZUdjbTc4YzVRMThiUjhSbG1iSERBMGpuMjJN?=
 =?utf-8?B?OFY2SlQyc2VlVnBBWXBpemNZTStlQ2FpZTNGYi9qZlVGZiswOCs4NzgvaHZY?=
 =?utf-8?B?aTNiN2RqQVp1RGpJT0RIQ3lvK3FUd25CQWNFOW9PcHJ3b0ZzQmZNbEI1NFIx?=
 =?utf-8?B?a2l6NWxqSXdyeldSTlFrMG9YQUxPa1lNc1pPblZzVVd5b0J5cm9JNkpoNFh0?=
 =?utf-8?B?cVdCNGs2OHhCZG9xeW1VSEFlZFJSSC9uZkJSakJISnZMQUl4Qnl2cGNOVjZH?=
 =?utf-8?B?bi84THRROVd6Zk55N01lL0ZwWG9pTzFMUm4yNVY5aTlQUFkwS2pxNTZTWnNV?=
 =?utf-8?B?SE8waFJqMHhNM2MvOFRxdDczY2ZxSTk3N2lweHJvRWcvMVJSVTF2UURlVEdp?=
 =?utf-8?B?L0Z2V1piYlNoN2FiNklVeTloR2lxWUhXdmF0QzNRVjBQbStDR2FSaTVIT2VG?=
 =?utf-8?B?Wmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 502671bd-d975-4ecf-dd0c-08d9ea68606e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 18:33:46.6418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tWGK67imCYqJu1+ZOMnDnqg6rUJp46+1KQH2EojSadSOcTqeCCSzjlcj8ZPxXT8E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1865
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 7PP2Hqe-75udI4InSpz-Yc0HqXEC3Dz2
X-Proofpoint-ORIG-GUID: 7PP2Hqe-75udI4InSpz-Yc0HqXEC3Dz2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 phishscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 clxscore=1015 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070113
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/5/22 8:31 PM, Hou Tao wrote:
> In add_kfunc_call(), bpf_kfunc_desc->imm with type s32 is used to
> represent the offset of called kfunc from __bpf_call_base, so
> add a test to ensure that the offset will not be overflowed.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>   .../selftests/bpf/prog_tests/ksyms_module.c   | 42 +++++++++++++++++++
>   1 file changed, 42 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
> index a1ebac70ec29..8055fbbf720b 100644
> --- a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
> +++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
> @@ -3,9 +3,49 @@
>   
>   #include <test_progs.h>
>   #include <network_helpers.h>
> +#include <trace_helpers.h>
>   #include "test_ksyms_module.lskel.h"
>   #include "test_ksyms_module.skel.h"
>   
> +/*
> + * Check whether or not s32 in bpf_kfunc_desc is sufficient
> + * to represent the offset between bpf_testmod_test_mod_kfunc
> + * and __bpf_call_base.
> + */
> +static void test_ksyms_module_valid_offset(void)
> +{
> +	struct test_ksyms_module *skel;
> +	unsigned long long kfunc_addr;
> +	unsigned long long base_addr;
> +	long long actual_offset;
> +	int used_offset;
> +	int err;
> +
> +	if (!env.has_testmod) {
> +		test__skip();
> +		return;
> +	}
> +
> +	/* Ensure kfunc call is supported */
> +	skel = test_ksyms_module__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "test_ksyms_module__open"))
> +		return;
> +
> +	err = kallsyms_find("bpf_testmod_test_mod_kfunc", &kfunc_addr);
> +	if (!ASSERT_OK(err, "find kfunc addr"))
> +		goto cleanup;
> +
> +	err = kallsyms_find("__bpf_call_base", &base_addr);
> +	if (!ASSERT_OK(err, "find base addr"))
> +		goto cleanup;
> +
> +	used_offset = kfunc_addr - base_addr;
> +	actual_offset = kfunc_addr - base_addr;
> +	ASSERT_EQ((long long)used_offset, actual_offset, "kfunc offset overflowed");

I am a little bit confused about motivation here. Maybe I missed 
something. If we indeed have kfunc offset overflow,
should kernel verifier just reject the program? Specially,
we should make the above test_ksyms_module__open_and_load()
fail?

> +cleanup:
> +	test_ksyms_module__destroy(skel);
> +}
> +
>   static void test_ksyms_module_lskel(void)
>   {
>   	struct test_ksyms_module_lskel *skel;
> @@ -62,6 +102,8 @@ static void test_ksyms_module_libbpf(void)
>   
>   void test_ksyms_module(void)
>   {
> +	if (test__start_subtest("valid_offset"))
> +		test_ksyms_module_valid_offset();
>   	if (test__start_subtest("lskel"))
>   		test_ksyms_module_lskel();
>   	if (test__start_subtest("libbpf"))
