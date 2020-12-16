Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCFC2DC626
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 19:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730060AbgLPSTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 13:19:38 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15314 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730044AbgLPSTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 13:19:38 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BGIFW1Q027508;
        Wed, 16 Dec 2020 10:18:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ttfYTsoxyOjPl+QFx4W/Xmax9VPtchJsdW/AgEvDGQM=;
 b=NLSYnSzzG/ngq9IlzaJdKX9GAhUedmz85J91kCfMok9zRndfxlfKzrbk67bCKy+D7Sde
 kzYhvvzi3KaXV0K30XUNeTXWTya5x6cbuCoZ/lkkVES1Y0zlIqU8chxJE10PBnfhxPZF
 iIn/rbqxU2fgpa7cTSeS6K4EphaVrwFD3rs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35f9ykbm5c-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Dec 2020 10:18:43 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 16 Dec 2020 10:18:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fyz6fvYp7Br1VS0QfX6PZT2Q5n6ASGqqW7YZOwqHXQoTRzFOPGWiUVBkRqkrTAAI6QmuAlRM4brbrW9ePb5DP2qUfTi/BB74+YJGCtuN6wXNqpu3mWKW5ks8nFvfAZ0IX11Yt8oAg6NTDud0Nh4n2nvt6Gwd1KfMVzAkCHc0ojQAIKVVCDAyluvzxl33MbA+Hph7GZVeciU4BkWQbga6Tf6UCiJ3BgZzKmIQU6hDzxycNvK8yKQmPOjPBHCSbqFsFVXN+qRSTk1wnQTV+hK1Bl4TKptFB0tMOKfOKTQQcpOL/bJERjhFP50N5eYVgdiVmfKZHkbTVi+j0ZC97pM2+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ttfYTsoxyOjPl+QFx4W/Xmax9VPtchJsdW/AgEvDGQM=;
 b=NdjcDK6ynnHsbmn/OC24W4VsbZaz9TN3o3Mu5v3gAWyHp5Zvrh54iMHVzPxTE96ubhekst20iTGSegU7gCxcw2RQCVJy/GqZnJKs8W9x+xwHJBlDPmcHutc8oM3P4M6aVNHDt4OAN1q6xBFrgXwP3SuXPXn6rIbOmnm9Nycq3OSTl4kQR99zyBBwQttnoLtmmXFKFG5wp4/s4PS3wqt2y9yGR2VgNCtG2ovhyvB/aThlwGYIUFDhTdOE936A8nelFLSyou0658bgwWTIdQyr20QKmwP6gJz7Y7h/h0rW9qIpDYiYaLZ6VgAjB9a/XYGhgykZsHwMheT/whpb2WgY2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ttfYTsoxyOjPl+QFx4W/Xmax9VPtchJsdW/AgEvDGQM=;
 b=KXKUC0UZajhU/kOvseYG51Ptmbxw/vbkFUL48QfTlgcNt14KuGxwX2T2aM2n0i9ZGEcN+lbaiNSO26XZOuxw95FdaicLdKLljInfpLUbymsoMvV8+aUGns4PY8nf1eMNntSWCBf53xVqi8nxSJLhVOxKzxkHUhLAuFZpKtu0XVs=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2488.namprd15.prod.outlook.com (2603:10b6:a02:90::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.21; Wed, 16 Dec
 2020 18:18:37 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 18:18:37 +0000
Subject: Re: [PATCH v2 bpf-next 4/4] selftests/bpf: add test for
 bpf_iter_task_vma
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-5-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <29e8f249-a23b-3c17-4000-a4075398b669@fb.com>
Date:   Wed, 16 Dec 2020 10:18:16 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <20201215233702.3301881-5-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:4fea]
X-ClientProxiedBy: MW4PR03CA0371.namprd03.prod.outlook.com
 (2603:10b6:303:114::16) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::12e6] (2620:10d:c090:400::5:4fea) by MW4PR03CA0371.namprd03.prod.outlook.com (2603:10b6:303:114::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13 via Frontend Transport; Wed, 16 Dec 2020 18:18:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4dc59b09-7d7b-4ae7-0912-08d8a1ef01be
X-MS-TrafficTypeDiagnostic: BYAPR15MB2488:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2488AEA332404807EDB0F91CD3C50@BYAPR15MB2488.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XyIBs2IdTlVxxuRRfr3GkYiEiGRu70FF9/8WMENab60O7LuLAAzb3Als784oZP2oGSwxlL47fsHL7gHQxQQ9WlYkmcm62t/EyfzIy+WW3i1OfwQSqN6E77HRzBYppfEY7EVRKNPboKgedBxtpz7810xVqUr8i69fa+ya0xwDdeuKPYMm4GF2PVSFMG1Dv+Ciyr3Uvdjb53Kn/sZx+lxyeVWDXBWiWYyX9MhxAok296RWvnHqghlFiBC5SyygvfGjCMvV6+wN4lBsBbD1kYTBto1+2NF2Py9AMPa8/OwCmGgQs8jdoz4QxI8eVpj2tMPRC/5j/9wWU5swzMtGlXkfmVNweOhevQDqrTYpA0Oakx/Qt7v0RIIt45nSLv91VoHu2xO91C+CF0LKDDlof5e7zIq75zTYT3oRqmVf6+axmuI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39860400002)(346002)(366004)(396003)(6666004)(5660300002)(186003)(83380400001)(16526019)(316002)(4326008)(52116002)(8936002)(66556008)(31686004)(2906002)(8676002)(2616005)(6486002)(36756003)(66946007)(86362001)(31696002)(478600001)(66476007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y0x3c3RTTzNueGh4NUNmL3h5QTZGcDIwME1KM1E0M0VRYStwR21icnByckxZ?=
 =?utf-8?B?ZFJOL24wYllBNWFROVcyRDByYkFPc08rNkd2UThBbU9DZ0RZcjZNQnlOT1lV?=
 =?utf-8?B?bUtYUFc0SUJQcUc4NXIvQTA0eDdLd0FnMmFPNEl1bWFQTnFtSnl5TEk4aHJC?=
 =?utf-8?B?L3NmNWxRc2lJTGo5TGJqM1VPRTAzQnIwcWJPL1hEZEhFWUdGcTJzb0ZoWWUy?=
 =?utf-8?B?Y1p4NDNrWTUvR3k0aTJTeVRkWUVDQTUzelhNWFFCRGl3VllkM1VuT1NYUm9R?=
 =?utf-8?B?UW5TS0g1SGg2UTUydWxNbm1naWZZTmoxV2N3S1RUZEx1OS9vWWhqWjdHTU92?=
 =?utf-8?B?TXczNjBiWFoyVDJaMGIrVjZ5Q1RCTkFmQTUyV1pxcmI3TWpOcVVYSnZxaU51?=
 =?utf-8?B?R05EUENha2pXVmZPTksyNGtzQTVXY2J0UmJvZlpidlBTMHo1S1QveU11ZW9Z?=
 =?utf-8?B?eUhudFBwOENyOTc2cnQzcDhoR3g4SHQ5ZmNJdW9jZmFFVUYwSCtiVG1xRW5P?=
 =?utf-8?B?Z0tnclpVdHRqdWRhNHV2UjBqakZpVHFIS0Urc1JYY04waDcrVmRkYTcyTGh1?=
 =?utf-8?B?QThhMFh4Sy8vb2dvc1lkcXVXZW1peHFoMW9zL1IrbDRMeVV0cG5jWmF0R3RE?=
 =?utf-8?B?Rk9ybG9GbGRnTy93QUJjc1piOWx1T2M4ei9SUXRxSEVNK3Q0dCsxRGNWdDhL?=
 =?utf-8?B?TU9WcUU2R0h1djdDd1grcWtUK21vQzJQeVdWTm5CRFQ4eG9BVHZXRWFnTGZO?=
 =?utf-8?B?bEQ0RE9nVWxoS2JWdktjMzM1K2hqaUhDalVPMVhmazZxbXpIajBnczhSK1di?=
 =?utf-8?B?d3ZnZERUSS9jbWFYZTkwVUxBbVJQdFpwRzFjcVdCSkVZS2Uvc1JSN3Rhc2ZG?=
 =?utf-8?B?REpBalpCOUFhekZ0bmhyOGxhbDNuK1pqUnBQZXNva29sZjJRQmh0K2JtelJj?=
 =?utf-8?B?VFBwWFE5NUx3UDlxQ3h2SFhUYXVyc251MncxZWFZTUhkRnUyWGlsdzhzWXpm?=
 =?utf-8?B?NXJubldBZURDaTBnYjUxL3hPekFpbHp4dVkrajFGMTc0cmpSZHNNZHJBL3cz?=
 =?utf-8?B?d08xM1duZUJpWlZ4NGRGMm1EWktqVTVrTFcwYWhQTEZRdWkrc2ZNYUVBTXJs?=
 =?utf-8?B?Tm1oMldrS004b0NZYVhSeDhzZUJSdTJSZGhqUWp6dTJEZG5XZG1maVVLaTd6?=
 =?utf-8?B?elVJUzFndmxrdW9UeDVrZEU2SCswa1duT3hBRU9VTEc1bWxVcFJrTXoyMTlR?=
 =?utf-8?B?aStEdkhlZHhlNDVBdUNRL2NGYmk0dEE0SGFCQlYwbGZtaTRXSkFUMmFKdTJB?=
 =?utf-8?B?Q0VwcWJpb0N3T2c5Z1R6QzJPWUxqRjhrRTFTeWk4N0h1eGM3R1QxbDU1bEtp?=
 =?utf-8?B?L1p1MTIyYlpwZ1E9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2020 18:18:37.0152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dc59b09-7d7b-4ae7-0912-08d8a1ef01be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YUsktYKFADxO9YX9+a3/BUh+lh8KvtIW6LeVnZWOe7Fqhe5J6t2p+zpjPH6Zgm5V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2488
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_07:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 mlxlogscore=999 impostorscore=0 mlxscore=0 adultscore=0 phishscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160116
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/15/20 3:37 PM, Song Liu wrote:
> The test dumps information similar to /proc/pid/maps. The first line of
> the output is compared against the /proc file to make sure they match.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   .../selftests/bpf/prog_tests/bpf_iter.c       | 106 ++++++++++++++++--
>   tools/testing/selftests/bpf/progs/bpf_iter.h  |   9 ++
>   .../selftests/bpf/progs/bpf_iter_task_vma.c   |  55 +++++++++
>   3 files changed, 160 insertions(+), 10 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> index 0e586368948dd..7afd3abae1899 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> @@ -7,6 +7,7 @@
>   #include "bpf_iter_task.skel.h"
>   #include "bpf_iter_task_stack.skel.h"
>   #include "bpf_iter_task_file.skel.h"
> +#include "bpf_iter_task_vma.skel.h"
>   #include "bpf_iter_task_btf.skel.h"
>   #include "bpf_iter_tcp4.skel.h"
>   #include "bpf_iter_tcp6.skel.h"
> @@ -64,6 +65,22 @@ static void do_dummy_read(struct bpf_program *prog)
>   	bpf_link__destroy(link);
>   }
>   
> +static int read_fd_into_buffer(int fd, char *buf, int size)
> +{
> +	int bufleft = size;
> +	int len;
> +
> +	do {
> +		len = read(fd, buf, bufleft);
> +		if (len > 0) {
> +			buf += len;
> +			bufleft -= len;
> +		}
> +	} while (len > 0);
> +
> +	return len;
> +}
> +
>   static void test_ipv6_route(void)
>   {
>   	struct bpf_iter_ipv6_route *skel;
> @@ -177,7 +194,7 @@ static int do_btf_read(struct bpf_iter_task_btf *skel)
>   {
>   	struct bpf_program *prog = skel->progs.dump_task_struct;
>   	struct bpf_iter_task_btf__bss *bss = skel->bss;
> -	int iter_fd = -1, len = 0, bufleft = TASKBUFSZ;
> +	int iter_fd = -1, err;
>   	struct bpf_link *link;
>   	char *buf = taskbuf;
>   	int ret = 0;
> @@ -190,14 +207,7 @@ static int do_btf_read(struct bpf_iter_task_btf *skel)
>   	if (CHECK(iter_fd < 0, "create_iter", "create_iter failed\n"))
>   		goto free_link;
>   
> -	do {
> -		len = read(iter_fd, buf, bufleft);
> -		if (len > 0) {
> -			buf += len;
> -			bufleft -= len;
> -		}
> -	} while (len > 0);
> -
> +	err = read_fd_into_buffer(iter_fd, buf, TASKBUFSZ);
>   	if (bss->skip) {
>   		printf("%s:SKIP:no __builtin_btf_type_id\n", __func__);
>   		ret = 1;
> @@ -205,7 +215,7 @@ static int do_btf_read(struct bpf_iter_task_btf *skel)
>   		goto free_link;
>   	}
>   
> -	if (CHECK(len < 0, "read", "read failed: %s\n", strerror(errno)))
> +	if (CHECK(err < 0, "read", "read failed: %s\n", strerror(errno)))
>   		goto free_link;
>   
>   	CHECK(strstr(taskbuf, "(struct task_struct)") == NULL,
> @@ -1133,6 +1143,80 @@ static void test_buf_neg_offset(void)
>   		bpf_iter_test_kern6__destroy(skel);
>   }
>   
> +#define CMP_BUFFER_SIZE 1024
> +char task_vma_output[CMP_BUFFER_SIZE];
> +char proc_maps_output[CMP_BUFFER_SIZE];

The above two as 'static' variables to avoid potential conflicts
with other selftests?

> +
> +/* remove \0 and \t from str, and only keep the first line */
> +static void str_strip_first_line(char *str)
> +{
> +	char *dst = str, *src = str;
> +
> +	do {
> +		if (*src == ' ' || *src == '\t')
> +			src++;
> +		else
> +			*(dst++) = *(src++);
> +
> +	} while (*src != '\0' && *src != '\n');
> +
> +	*dst = '\0';
> +}
> +
> +static void test_task_vma(void)
> +{
> +	int err, iter_fd = -1, proc_maps_fd = -1;
> +	struct bpf_iter_task_vma *skel;
> +	char maps_path[64];
> +
> +	skel = bpf_iter_task_vma__open();
> +	if (CHECK(!skel, "bpf_iter_task_vma__open", "skeleton open failed\n"))
> +		return;
> +
> +	skel->bss->pid = getpid();
> +
> +	err = bpf_iter_task_vma__load(skel);
> +	if (CHECK(err, "bpf_iter_task_vma__load", "skeleton load failed\n"))
> +		goto out;
> +
> +	do_dummy_read(skel->progs.proc_maps);

This do_dummy_read() is not needed, right?

> +
> +	skel->links.proc_maps = bpf_program__attach_iter(
> +		skel->progs.proc_maps, NULL);
> +
> +	if (CHECK(IS_ERR(skel->links.proc_maps), "bpf_program__attach_iter",
> +		  "attach iterator failed\n"))
> +		goto out;
> +
> +	/* read 1kB from bpf_iter */

Maybe 1kB => CMP_BUFFER_SIZE(1kB)?
so future if people change CMP_BUFFER_SIZE value, then can find here
and adjust properly.

> +	iter_fd = bpf_iter_create(bpf_link__fd(skel->links.proc_maps));
> +	if (CHECK(iter_fd < 0, "create_iter", "create_iter failed\n"))
> +		goto out;
> +	err = read_fd_into_buffer(iter_fd, task_vma_output, CMP_BUFFER_SIZE);
> +	if (CHECK(err < 0, "read_iter_fd", "read_iter_fd failed\n"))
> +		goto out;
> +
> +	/* read 1kB from /proc/pid/maps */
> +	snprintf(maps_path, 64, "/proc/%u/maps", skel->bss->pid);
> +	proc_maps_fd = open(maps_path, O_RDONLY);
> +	if (CHECK(proc_maps_fd < 0, "open_proc_maps", "open_proc_maps failed\n"))
> +		goto out;
> +	err = read_fd_into_buffer(proc_maps_fd, proc_maps_output, CMP_BUFFER_SIZE);
> +	if (CHECK(err < 0, "read_prog_maps_fd", "read_prog_maps_fd failed\n"))
> +		goto out;
> +
> +	/* strip and compare the first line of the two files */
> +	str_strip_first_line(task_vma_output);
> +	str_strip_first_line(proc_maps_output);
> +
> +	CHECK(strcmp(task_vma_output, proc_maps_output), "compare_output",
> +	      "found mismatch\n");
> +out:
> +	close(proc_maps_fd);
> +	close(iter_fd);
> +	bpf_iter_task_vma__destroy(skel);
> +}
> +
>   void test_bpf_iter(void)
>   {
>   	if (test__start_subtest("btf_id_or_null"))
> @@ -1149,6 +1233,8 @@ void test_bpf_iter(void)
>   		test_task_stack();
>   	if (test__start_subtest("task_file"))
>   		test_task_file();
> +	if (test__start_subtest("task_vma"))
> +		test_task_vma();
>   	if (test__start_subtest("task_btf"))
>   		test_task_btf();
>   	if (test__start_subtest("tcp4"))
> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter.h b/tools/testing/selftests/bpf/progs/bpf_iter.h
> index 6a1255465fd6d..4dab0869c4fcb 100644
> --- a/tools/testing/selftests/bpf/progs/bpf_iter.h
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter.h
> @@ -7,6 +7,7 @@
>   #define bpf_iter__netlink bpf_iter__netlink___not_used
>   #define bpf_iter__task bpf_iter__task___not_used
>   #define bpf_iter__task_file bpf_iter__task_file___not_used
> +#define bpf_iter__task_vma bpf_iter__task_vma___not_used
>   #define bpf_iter__tcp bpf_iter__tcp___not_used
>   #define tcp6_sock tcp6_sock___not_used
>   #define bpf_iter__udp bpf_iter__udp___not_used
> @@ -26,6 +27,7 @@
>   #undef bpf_iter__netlink
>   #undef bpf_iter__task
>   #undef bpf_iter__task_file
> +#undef bpf_iter__task_vma
>   #undef bpf_iter__tcp
>   #undef tcp6_sock
>   #undef bpf_iter__udp
> @@ -67,6 +69,13 @@ struct bpf_iter__task_file {
>   	struct file *file;
>   } __attribute__((preserve_access_index));
>   
> +struct bpf_iter__task_vma {
> +	struct bpf_iter_meta *meta;
> +	struct task_struct *task;
> +	struct __vm_area_struct *vma;
> +	struct file *file;
> +} __attribute__((preserve_access_index));

Should we also define __vm_area_struct here since it is not available
in old kernels?

> +
>   struct bpf_iter__bpf_map {
>   	struct bpf_iter_meta *meta;
>   	struct bpf_map *map;
> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c b/tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c
> new file mode 100644
> index 0000000000000..ba87afe01024c
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c
> @@ -0,0 +1,55 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */
> +#include "bpf_iter.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +/* Copied from mm.h */
> +#define VM_READ		0x00000001
> +#define VM_WRITE	0x00000002
> +#define VM_EXEC		0x00000004
> +#define VM_MAYSHARE	0x00000080
> +
> +/* Copied from kdev_t.h */
> +#define MINORBITS	20
> +#define MINORMASK	((1U << MINORBITS) - 1)
> +#define MAJOR(dev)	((unsigned int) ((dev) >> MINORBITS))
> +#define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
> +
> +#define D_PATH_BUF_SIZE 1024
> +char d_path_buf[D_PATH_BUF_SIZE];
> +__u32 pid;

To please llvm10, maybe
   char d_path_buf[D_PATH_BUF_SIZE] = {};
   __u32 pid = 0;

> +
> +SEC("iter.s/task_vma") int proc_maps(struct bpf_iter__task_vma *ctx)
> +{
> +	struct __vm_area_struct *vma = ctx->vma;
> +	struct seq_file *seq = ctx->meta->seq;
> +	struct task_struct *task = ctx->task;
> +	struct file *file = ctx->file;
> +	char perm_str[] = "----";
> +
> +	if (task == (void *)0 || vma == (void *)0 || task->pid != pid)

I suppose kernel already filtered all non-group-leader tasks, so here
we can have task->tgid != pid?

> +		return 0;

Using /proc system, user typically do cat /proc/pid/maps. How can we
have a similar user experience with vma_iter here? One way to do this
is:
    - We still have this bpf program, filtering based on user pid,
    - normal bpftool iter pin command pid the program to say 
/sys/fs/bpf/task_vma
    - since "pid" is in a map, user can use bpftool to update "pid"
      with the target pid.
    - "cat /sys/fs/bpf/task_vma" will work.

One thing here is pid and d_path_buf are global (map) variables, so
if two users are trying to do "cat /sys/fs/bpf/task_vma" at the same
time, there will be interferences and it will not work.

One possible way is during BPF_ITER_CREATE, we duplicate all program
maps. But this is unnecessary as in most cases, the bpf_iter is not
pinned and private to applications.

Any other ideas?


> +
> +	perm_str[0] = (vma->flags & VM_READ) ? 'r' : '-';
> +	perm_str[1] = (vma->flags & VM_WRITE) ? 'w' : '-';
> +	perm_str[2] = (vma->flags & VM_EXEC) ? 'x' : '-';
> +	perm_str[3] = (vma->flags & VM_MAYSHARE) ? 's' : 'p';
> +	BPF_SEQ_PRINTF(seq, "%08llx-%08llx %s ", vma->start, vma->end, perm_str);
> +
> +	if (file) {
> +		__u32 dev = file->f_inode->i_sb->s_dev;
> +
> +		bpf_d_path(&file->f_path, d_path_buf, D_PATH_BUF_SIZE);
> +
> +		BPF_SEQ_PRINTF(seq, "%08llx ", vma->pgoff << 12);
> +		BPF_SEQ_PRINTF(seq, "%02x:%02x %u", MAJOR(dev), MINOR(dev),
> +			       file->f_inode->i_ino);
> +		BPF_SEQ_PRINTF(seq, "\t%s\n", d_path_buf);
> +	} else {
> +		BPF_SEQ_PRINTF(seq, "%08llx 00:00 0\n", 0ULL);
> +	}
> +	return 0;
> +}
> 
