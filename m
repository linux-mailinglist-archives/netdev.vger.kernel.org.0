Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E552501E61
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 00:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243677AbiDNWc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 18:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347107AbiDNWcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 18:32:32 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62F48E184;
        Thu, 14 Apr 2022 15:30:05 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23EKx1Gt021128;
        Thu, 14 Apr 2022 15:30:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=nBVSiBUIJ2CpGYl264xawWd00Q6j/0qq0SsbfSmNb6s=;
 b=XmMp/B9+vbrO147TRU0Yq+Qmm7v++9PdoENhuQOglE6UX1AMzsTts724DOYHjv0446hU
 NYRyciHfHq7hpZ6GqYbWu6IcTWUsSHQW4RVySHwYQ2OO2XCU28i+MEvDZ1rEO+ZMBZ+v
 IQWbMNKrVspa1Phoad4JWIPvGvS+LM1AMXk= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fe2mysbd9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 15:30:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f8g8RGkMu5Kq/tkCo+9J8yIS57ufuJ0/4Wjcn0Tgq+iI/Jh96hXaHGYZUaWtvlZnIwZo4uLr8yQqqykvAI4B12Whm83IUAtv7rNOE8xLkVxw8Smhg7uPrYeqtsEtmq7QT+wzUdIRZNO+skRa/2qxdC5VFjtliznPE7KUXBWFxIpWzTILyVdlLzfq2AthzztJoKU07peeqmE3ouHBiIWMhOTFhos7pxUwRrYtc/xcBXG8dalgRKr2+MsqHWRitca+J83aBu0Zvb1qhF0gUtj3HA46uHDG6srt4EAXN8cNrUIhHtzOJku1cILPnf9aAdLZBksYLcTnq5cHvU/TqqOWxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nBVSiBUIJ2CpGYl264xawWd00Q6j/0qq0SsbfSmNb6s=;
 b=lrm8rIkZkSfzfsQdVGTWIjHd0F3+M/sUnkzAzB63RHKGG2rGrWS25KiR71/30Q4+A5TF59YMZMOrDIOWXAT8V7cB5/W+D5vL+DNMyCFx/nVMjsOivZfa9bnERutBc+Eu4D9MgKThcD8MS1a7Jg0aOCzuM2j+TBgnHxPDO+7A7pulA7aRt6kVYg0i0N2wMkKPmL8LMzXQW3yMQh39igLQ37QZv5H2Q13LJrqif6jyiuapexTBb5H8pZ4pf28yGWDPGTFxk5tM23WqWCsqwF2x0SdURGC2RRCMXvxocMHSv5JumRvH0YSwgPN6pSkjn+fYx5TUhojxC9TzC0sdqxlXeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM6PR15MB3132.namprd15.prod.outlook.com (2603:10b6:5:13a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 22:30:01 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::20d2:26a2:6cb1:3c4b]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::20d2:26a2:6cb1:3c4b%6]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:30:01 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Liu Jian <liujian56@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sdf@google.com" <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH bpf-next v3 3/3] selftests: bpf: add test for
 skb_load_bytes
Thread-Topic: [PATCH bpf-next v3 3/3] selftests: bpf: add test for
 skb_load_bytes
Thread-Index: AQHYUAeHiYBiLd31Vk2IlCz6UMrtSqzv/ksA
Date:   Thu, 14 Apr 2022 22:30:00 +0000
Message-ID: <E5A724D1-309A-4C5A-AF01-E909AECFDD2B@fb.com>
References: <20220414135902.100914-1-liujian56@huawei.com>
 <20220414135902.100914-4-liujian56@huawei.com>
In-Reply-To: <20220414135902.100914-4-liujian56@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 719c7741-9d03-4c9a-6046-08da1e665066
x-ms-traffictypediagnostic: DM6PR15MB3132:EE_
x-microsoft-antispam-prvs: <DM6PR15MB31325A132D4E1509035651D2B3EF9@DM6PR15MB3132.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PNWoHK7qotV/x3Z/ElzMQUsyvXHT3u6imxSypBuLHw1yeh5Z4Wo+Tg9Y2gxv8R/hQDcq8UbtO1nG9dqwmbfA92sQEH5hLlzlhDqSFxuvDTktOFv3AsX+Cx2n1wvgdsX8weG5AzDYCw4O3an+JNqjgHO72Dk1CQVqwi5YF4RgUErnzvSbS/BUxp0lOG79C9Fw3zUbaSjVKbswyxWD5lC83u9Zd1dDGhkMOdxctwoj3z84lsLagTrLSJSCTT68sZnPya2wRH0ACFb9WJsLXjXg9PTOl1AVwaKH6P5decX9TYFJFX/YP67tDyhsL4hgT0pXJnCNxy6ftLRS5yc3Hv7uF5GgjJo+EDezwu5Grcwqlt7yQHu0hHzVN+PvLgm7xr0FcoqbaGSsqdxjc+HTp7svXCBw2HbJs7O8Iu0yE9fEvNO13jTpyrMYdXvaOt36EqFfvEBJdNSxvJKn48170acL6AVAT/i1d10meCh84l6tWOUExq3BDVZhJYjC4c0ONP+gLx8s9EOy9DMe18+m1UisKyFiFI2cHyKzlNf23uUyRW6tF2o4gH9saXH7d6Awz9Ays6gTtXNxW8YIIqClGDaNj+qeHLg50hmkmr/Q43CdWEHQvwTJ/ci5JbCF833CXoAknrR9CTWlQZD1mSTlFGTR2dxLabBOSo2OV1iqte/wfO3+coHAXVvVJRxc4MI/IFrHUnGi3Ugx3NolopEoC4e6KkOoRtHkbgDChwYakZ4vDdPeRiF1LkVaUDA6tZEbIw59
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66446008)(66476007)(66556008)(7416002)(8936002)(6916009)(316002)(54906003)(76116006)(64756008)(508600001)(66946007)(8676002)(4326008)(91956017)(33656002)(6486002)(122000001)(86362001)(5660300002)(38100700002)(6512007)(2906002)(6506007)(38070700005)(71200400001)(53546011)(186003)(36756003)(2616005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8Q4SsbWy5YCi6Kd8AKlOEnyMy6yQ0Q1gAlcV5XzjHGFZoCSEKRuVomTe1aah?=
 =?us-ascii?Q?LXL0UiHxXyE1F07CHtiY6cxcwQldTHojhiD2Wohvauep5oZCofOgj1Cl+1bQ?=
 =?us-ascii?Q?7TL3NU8lsOth2pttZT3XYW9Jb4xjwvcE2cgPMQrxw6lj2t++J78C92EubZAn?=
 =?us-ascii?Q?7DcnTW3cLHDJl3EuSnqBwx3C+zYYG+uSfN2W96MLgFe0pWJIWdS3SfORpq/b?=
 =?us-ascii?Q?AJWUmPOrXwi5p4eeXH9TKiQqj8rZRmgLZTiYUBx+AoUM33cxvH71x1r1yk7p?=
 =?us-ascii?Q?zvCH3dM1Vy6xwJHcEcSmyF5K7/Twn6JNfcLgjZOGb9xAiUmyZ/ER6XQSxkPV?=
 =?us-ascii?Q?NRwEi5wqHiT+KG1ra/G1MtRJ6JfKcpdXBJondx5H+nG8vObt7JGy0bmHPDPL?=
 =?us-ascii?Q?Z+4PieK+nFOAVmWq1rtax2IfTGR/ScYPdvnM+4bYk/5D8ydu3A7St2iKCdom?=
 =?us-ascii?Q?TBsiS2PpB1+a2sPyazVLjytjegDb6aGiUCi2rFB3WA7b6/eOu6EgrMAPwrSX?=
 =?us-ascii?Q?DRA0BZa/LCUJiRUmU8Mps98J+o1+PSlm4BqVhSi1mjllWaX335oVJLZFAOIn?=
 =?us-ascii?Q?8BlaW/A+LFmH9przNxn3BVu8ej8Eibfqn20kIgTQ4uxvlxkBSSsyUNeasZxx?=
 =?us-ascii?Q?YXJoh4vgK0SxmJgkhHtByzCEooCvkQ12zxfObVp7U2GoZJAZGMxAxrYX0uIr?=
 =?us-ascii?Q?qaA+VQNPKGw1HhAcJ5H1P3cAH4oJZWTxnYWWjz4bR74zvqBEhrY+GpmPvbM3?=
 =?us-ascii?Q?fJg2lewQeYs9nw50iIEU08HqoEL0gxUElXIsAlf8rI2nPsPL3y/ppmJDy1rv?=
 =?us-ascii?Q?dSKNJqBNT/Sb3SZCd+FqKvyX+TIIYltjzIvWsFl6aGlJ0rSbghUm2e3D2+1g?=
 =?us-ascii?Q?cH3gvrA7X7mhEeZd5MY+DtJ05hGx4tbl8IHQmn/lvqEhNDEkaEhLLJvszFpV?=
 =?us-ascii?Q?M5WNjWtNCMY1xnu/WC6G6Nq7Bjz8WJ7U/6zdF1PEkSNuDGbU5H/a0XaT/1zS?=
 =?us-ascii?Q?XESPpvothbsBobLxn0BwbZgRsXhNcjyHM9M0qPN14jSQFVWHZxfrUkSY1A8V?=
 =?us-ascii?Q?2i+IkhbeBQHbJXzyHgSfviDYCirIrGrlPe5hWEreFy24wKa/923PkSygm5Ot?=
 =?us-ascii?Q?djac4HFboibbVH6HIIHMFHyZ6I4MJEWADe13s0isonsw+NEVYxFf7M8behGD?=
 =?us-ascii?Q?AL4ZS1kW8p/adnZmz4vQhmGACLagWwvbfaBzl0+CDgFea6D2iTm5A6F1uGg2?=
 =?us-ascii?Q?WwslHzqJOfxXHxjlix+eoipBqlrHey/q0oZmj4iszN8suyBsqUYEgRlaC2G7?=
 =?us-ascii?Q?WJwdNOpmJFQwK0xY7O7AhrKqj4ycMLUk9Ik0UTlHxDk3owP1TV57lGoCTlR+?=
 =?us-ascii?Q?y7yFdOPZl3ccZZcjSX5+NG/lV2NvvMxMU5bfSSDOkE1GHUXVylBiTs9InNag?=
 =?us-ascii?Q?rzMNfVuUGWVk6auVYwbGwkS1+vXXqRlJleep2DTDJUU71ESS42D3oeGUvNGz?=
 =?us-ascii?Q?k+F128jsIAL0ZD6N3erZ6uV9FL4+ySZk68RzG1qQGMnjezFcc8cS8zK9SMOd?=
 =?us-ascii?Q?t8sWrJwVBs/f/l9L5nUiyWJVN9ADOFPUPQDw9aCjFfWWawA1LSCuoBzhwETx?=
 =?us-ascii?Q?qSWhSrjo7rV502kuJ+y2w1SQ/mgXPgufT9WX+hgu5/v2VNzIvGDVX/WxFaF0?=
 =?us-ascii?Q?OOMNM5TC+HnFD3FaOQGCCm2USDMTQsosbWSsQk9fNc329VjwVi8y/TGzsjVT?=
 =?us-ascii?Q?4jCQX1+NyQJcWlmF0JZB1XVlRf0PO16kOlWCmiBzR4zbN14Ymj2y?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <89F5EF8B25169F408C60295A040C3402@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 719c7741-9d03-4c9a-6046-08da1e665066
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 22:30:01.0106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lUbodFsXtfrch9Je+AYGs1QvQFf3echDujL00qAWO+9h168E92XeWQuXgBlkszTgVA2koCq7J90oNO73q3yWzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3132
X-Proofpoint-GUID: pQ5AfsVz1UyaCXyVQfBL3m8IiCU8TF4F
X-Proofpoint-ORIG-GUID: pQ5AfsVz1UyaCXyVQfBL3m8IiCU8TF4F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_07,2022-04-14_02,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 14, 2022, at 6:59 AM, Liu Jian <liujian56@huawei.com> wrote:
> 
> Use bpf_prog_test_run_opts to test the skb_load_bytes function.
> Tests the behavior when offset is greater than INT_MAX or a normal value.
> 
> Signed-off-by: Liu Jian <liujian56@huawei.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> v2->v3: Change patch prefix to bpf-next. Use ASSERT_* calls
> .../selftests/bpf/prog_tests/skb_load_bytes.c | 45 +++++++++++++++++++
> .../selftests/bpf/progs/skb_load_bytes.c      | 19 ++++++++
> 2 files changed, 64 insertions(+)
> create mode 100644 tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c
> create mode 100644 tools/testing/selftests/bpf/progs/skb_load_bytes.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c b/tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c
> new file mode 100644
> index 000000000000..d7f83c0a40a5
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c
> @@ -0,0 +1,45 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include <network_helpers.h>
> +#include "skb_load_bytes.skel.h"
> +
> +void test_skb_load_bytes(void)
> +{
> +	struct skb_load_bytes *skel;
> +	int err, prog_fd, test_result;
> +	struct __sk_buff skb = { 0 };
> +
> +	LIBBPF_OPTS(bpf_test_run_opts, tattr,
> +		.data_in = &pkt_v4,
> +		.data_size_in = sizeof(pkt_v4),
> +		.ctx_in = &skb,
> +		.ctx_size_in = sizeof(skb),
> +	);
> +
> +	skel = skb_load_bytes__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "skel_open_and_load"))
> +		return;
> +
> +	prog_fd = bpf_program__fd(skel->progs.skb_process);
> +	if (!ASSERT_GE(prog_fd, 0, "prog_fd"))
> +		goto out;
> +
> +	skel->bss->load_offset = (uint32_t)(-1);
> +	err = bpf_prog_test_run_opts(prog_fd, &tattr);
> +	if (!ASSERT_OK(err, "bpf_prog_test_run_opts"))
> +		goto out;
> +	test_result = skel->bss->test_result;
> +	if (!ASSERT_EQ(test_result, -EFAULT, "offset -1"))
> +		goto out;
> +
> +	skel->bss->load_offset = (uint32_t)10;
> +	err = bpf_prog_test_run_opts(prog_fd, &tattr);
> +	if (!ASSERT_OK(err, "bpf_prog_test_run_opts"))
> +		goto out;
> +	test_result = skel->bss->test_result;
> +	if (!ASSERT_EQ(test_result, 0, "offset 10"))
> +		goto out;
> +
> +out:
> +	skb_load_bytes__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/skb_load_bytes.c b/tools/testing/selftests/bpf/progs/skb_load_bytes.c
> new file mode 100644
> index 000000000000..e4252fd973be
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/skb_load_bytes.c
> @@ -0,0 +1,19 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +__u32 load_offset = 0;
> +int test_result = 0;
> +
> +SEC("tc")
> +int skb_process(struct __sk_buff *skb)
> +{
> +	char buf[16];
> +
> +	test_result = bpf_skb_load_bytes(skb, load_offset, buf, 10);
> +
> +	return 0;
> +}
> -- 
> 2.17.1
> 

