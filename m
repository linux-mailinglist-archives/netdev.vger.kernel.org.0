Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DD72C4EEE
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 07:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388093AbgKZGpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 01:45:00 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8530 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732875AbgKZGpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 01:45:00 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ6Petm027453;
        Wed, 25 Nov 2020 22:44:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=VGCRwnmOUCi1SeT4pbtjKI+0F7nOtQdPS5fv5P7tnOg=;
 b=ABU0JU6hNUQQKvXtJrb/ftQLfNllnzSTi7Dc7RI2gLMaBi4iXVSb5AjQ0d7bliV5fkcS
 wEX2U8dOQ298TvxEKCpiRU7up3ebH+KR27gb+M1kCv+w/tqyYFQpVbh31vyzlMTWKGmt
 y1jIP7bbJ61RiampLXYF5tkNBxrKF82NLV8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3525fm8e06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 25 Nov 2020 22:44:39 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 25 Nov 2020 22:44:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UidwUxKs6VejfRVpQAtW0I+9Tguyvv/1iqQ4G8e5DWVOmM2tXXijgr5A46q8Sz0q55/vkWqIe+kE7BH00h4Wdpq1TOZI+9aoBHlrOj7+lty6sLEZy4IZnkX/cUkWb4KHw293fgwB1SvVp7NV7fxzFCUrOPB3frzEz5Ik5NKJ0ZVBQUnKrsAkK46gX+RXATJau4TrBNyNG1u7FNoCA/W/+NIvO5h3F54p1rd8cq0i0Fe4vn84gBX+UHU5kp6vjlSSrBr8uxonnABPgRHw/MsoXVLoDFhZSrXyT+LhN6rxwnP0YJjwq4YzA0BewluTfcHCIJ3lomHD5wwAjzl2n3JKOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VGCRwnmOUCi1SeT4pbtjKI+0F7nOtQdPS5fv5P7tnOg=;
 b=MbyZhIMxT+MMTvABz9H+6i27pVcTReGrUpiwSftxoC7VAdyCSa+70SmZB8p7NxTxgDyKO8umu+F4mmW/Mz62N5zIByKXUQyFrCRguJxV8kqwOIM8hIIrPoCtmsfJgs880neL764dsU0G+ieL4+InrO50btiSXAxOWjJIrzjEB19Y6lpqta+it9j80LdSB5rubuMGDJSGGlI16wOtyTCFpuwp/uxU/7XTJ7rfY43p35GSVHuoUmi2hAquUpKSZi8QfVzblwBxlaRL4dyGn/Xu/7ZuMExItjaFHcK2uqhPNfQWyDMmTNd12vFbfFwGLasoBFPRfCO//TVyx/H+NHKc4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VGCRwnmOUCi1SeT4pbtjKI+0F7nOtQdPS5fv5P7tnOg=;
 b=E307M7ng+jq/PoZvaFDahdmTyGLAWjeBNJ2lGoTaxHrqNbperrhg+ftvBbooYWBnfD3M7oiaTnJU0mVWUiiy0zBIOGe3XLp+iRdEzQkgeymAvDCc6O/Ft+7n2BasAWYtsxdxKxhIre+02iKpFOpupEMJs8cRn9Jz8cTVfnK8+dU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3570.namprd15.prod.outlook.com (2603:10b6:a03:1f9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.25; Thu, 26 Nov
 2020 06:44:37 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3589.029; Thu, 26 Nov 2020
 06:44:37 +0000
Subject: Re: [PATCH bpf-next v3 1/5] selftests/bpf: xsk selftests framework
To:     Weqaar Janjua <weqaar.janjua@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <magnus.karlsson@gmail.com>, <bjorn.topel@intel.com>
CC:     Weqaar Janjua <weqaar.a.janjua@intel.com>, <shuah@kernel.org>,
        <skhan@linuxfoundation.org>, <linux-kselftest@vger.kernel.org>,
        <anders.roxell@linaro.org>, <jonathan.lemon@gmail.com>
References: <20201125183749.13797-1-weqaar.a.janjua@intel.com>
 <20201125183749.13797-2-weqaar.a.janjua@intel.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d8eedbad-7a8e-fd80-5fec-fc53b86e6038@fb.com>
Date:   Wed, 25 Nov 2020 22:44:34 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
In-Reply-To: <20201125183749.13797-2-weqaar.a.janjua@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:e5cb]
X-ClientProxiedBy: MWHPR19CA0014.namprd19.prod.outlook.com
 (2603:10b6:300:d4::24) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::1145] (2620:10d:c090:400::5:e5cb) by MWHPR19CA0014.namprd19.prod.outlook.com (2603:10b6:300:d4::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Thu, 26 Nov 2020 06:44:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4160c18-6428-44b2-1332-08d891d6bdda
X-MS-TrafficTypeDiagnostic: BY5PR15MB3570:
X-Microsoft-Antispam-PRVS: <BY5PR15MB35700F994F408659D0E81D37D3F90@BY5PR15MB3570.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zzqfsBrknvVmSPwKnO7skuYcQ83AKkVZi4OfW17Zzrclao7SaE1yJrFXjg3h8ouC+1Iu6WTRNN8l+d5YcTlpbSjzxcpd8iUKOtMAYbL8QNHnhZEAepQK8xMD1BGDKzjVJ3flLlawNuX+YIJy5rayuoF2FcM4bMe62dWZ3ApSWtI+EkiY+m9JDZItIByvElcvfGtsGvTmYlRSQ/MdFp30vPWlbku266OvG7a6xJXYqQ+z6SEsZ/jJoLJ/r6qQDgT9ZjeGMskD90xUqAqqQ7buwpvzHGfzC+xLDjuWDgOVGf5VvjQzXaNIKeLwxpyGnfqZVfxq2tUnkfTpSSc4Jn12wO2H+p8erZY1sGPSBOjlGQjMBtGIYVoj7LsN7FO1vGIIk8BZx35hcuPA5V8r7IUNNiyBmJvTNS2dU7rs096jg9YIipPerDrwFqJERPzzFxUVGZtpHgeF3o4b2c2zPNGbRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(346002)(376002)(136003)(8936002)(53546011)(31686004)(66476007)(8676002)(478600001)(4326008)(52116002)(83380400001)(66574015)(186003)(86362001)(66946007)(31696002)(36756003)(66556008)(2906002)(7416002)(5660300002)(966005)(6486002)(30864003)(316002)(16526019)(2616005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OHlNNnQrdXhtbkphdWxJaW1wMXYrSWtRRkNBTFhlbmRmMi8xVTNDR3lRdDJp?=
 =?utf-8?B?VjVRRVRMdTBjOUltVDNwYUIxWjJnVTdWbE9EamNZWW8wSU56Q2dGSWdqMnZU?=
 =?utf-8?B?am1ucnlWdVcrMUhhK0UzbG51Wi9HMkFrcTBhZXZTdUowT3FWWnJIT0R2d0Rr?=
 =?utf-8?B?VjU3UVA1TWg3RENIWmw3T25Ya25aSVFjaFVvaUJuWTdWaWRsRk4vSktVZCtn?=
 =?utf-8?B?blA3V3NBNmViM09kTEh2Q28vaDJSYStCTGhXNk5GdERUT1JnT2Z5Q290d2Nh?=
 =?utf-8?B?MzFpeWhLY0U0YWh4L0ZSeFdtNkJVcEZnK2JrRzIvOGNlV05FU0RsaTRlaXU4?=
 =?utf-8?B?MGptNlJJelNSUWYwWGtSVUhMczBXeEVrY3pla3BHWDlieFJORGk1Mk1aZGk2?=
 =?utf-8?B?cHF0WGRUTk12eG1FUFVIbUJvSm02S2kycWcxVzQwdFhFZnpjZ3hGWG9uMVEy?=
 =?utf-8?B?b29vTC9rbkE0TjZqeDlzMXNlcVhwRlQ0aWVxbUhEdm53Vjh4MjdiQmw1SmxG?=
 =?utf-8?B?eTZlZTFtaHNuWXhJQTZLSEszOFI4T3hYeVpLZ011ZVJ2ZmJIL2U4eHQvSlhK?=
 =?utf-8?B?Vm9JTTgrcHRNR0Jtdm9lVzBsKzJlTEVTaTAySGIzVkxLeXNXUytTVHVxMzhl?=
 =?utf-8?B?dVRaUG9RaVJZN0dXbCtJaVZJMHJiSHJmLzdHQk9xZ1U3UzhpNkxudllQUHhS?=
 =?utf-8?B?NTgwL2RrcENIMXRYSXpCbmJreWxDdHdIYThUSy9hOGZ3RHVxWHBDVXQ1WCtn?=
 =?utf-8?B?QVROem1JV1dNQjJkaDc2YXdZZTJKb2FVQ2ZNeXg0VXMyM2E2MmlrMEhJQ25u?=
 =?utf-8?B?OW9ORDh6RjJ2R2orM2ZuUFFJc2tlYW9rNFIveVc0TnloMit4QVBNaEl4QklQ?=
 =?utf-8?B?QzZ4L1d0UWxsVE5TVUVqMThyKzJhVzhqQWVGeXpzeTA3cjVTWVY2WStmZ3lu?=
 =?utf-8?B?eUU1ZzZEQWFOcmpxajhLVE1QOCtuejF1QzRwaGFZcUJNZ2wrbHRmQmRKK04x?=
 =?utf-8?B?cnpIaTJlbzVaNTNIMFhHbUgwcE1vUjhnZzlub2o0YTVIbmdRcmlrODhWR1FS?=
 =?utf-8?B?WE5ETi9ha2FtQlZEVlJDMDNQNmpOKzNMOGQ1QVh0T2MvNk1zSmsvaktsUFNY?=
 =?utf-8?B?NzN3M0lhMGpBSVFiVmxHRXVXRUNmZmNQZTNyZjFIR2ZVUnNUTE9FT1Bsdktl?=
 =?utf-8?B?eC9xWEk4ZGJvVHJTb0VrQnRFOVczcUh1clErMlhVUEtUQ08vK3lsNExMOGl5?=
 =?utf-8?B?dzFLK3RzcmFqOHpOSGo4dm1FczAwKzR6Y3A4N1VqNkJRb3VyMzBVc0h2Zlkw?=
 =?utf-8?B?L2dSaHJldFl2OEJ1YVlRRCt4L3hrdzlWUVdMYkpibzFiazJnSUp5ZmtoMHgw?=
 =?utf-8?B?ZWM4Qko0YzBrQUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b4160c18-6428-44b2-1332-08d891d6bdda
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2020 06:44:36.8678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CxQkty/BF26ymJjFdFPiU4WWRl7vDHsf5QxdqhV7l4w9r9quhGsaCBy2AvEVxKLI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3570
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-26_01:2020-11-26,2020-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 impostorscore=0 clxscore=1015 suspectscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011260037
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/25/20 10:37 AM, Weqaar Janjua wrote:
> This patch adds AF_XDP selftests framework under selftests/bpf.
> 
> Topology:
> ---------
>       -----------           -----------
>       |  xskX   | --------- |  xskY   |
>       -----------     |     -----------
>            |          |          |
>       -----------     |     ----------
>       |  vethX  | --------- |  vethY |
>       -----------   peer    ----------
>            |          |          |
>       namespaceX      |     namespaceY
> 
> Prerequisites setup by script test_xsk.sh:
> 
>     Set up veth interfaces as per the topology shown ^^:
>     * setup two veth interfaces and one namespace
>     ** veth<xxxx> in root namespace
>     ** veth<yyyy> in af_xdp<xxxx> namespace
>     ** namespace af_xdp<xxxx>
>     * create a spec file veth.spec that includes this run-time configuration
>     *** xxxx and yyyy are randomly generated 4 digit numbers used to avoid
>         conflict with any existing interface
>     * tests the veth and xsk layers of the topology
> 
> Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
> ---
>   tools/testing/selftests/bpf/Makefile       |   5 +-
>   tools/testing/selftests/bpf/test_xsk.sh    | 146 +++++++++++++++++++++
>   tools/testing/selftests/bpf/xsk_env.sh     |  11 ++
>   tools/testing/selftests/bpf/xsk_prereqs.sh | 119 +++++++++++++++++
>   4 files changed, 280 insertions(+), 1 deletion(-)
>   create mode 100755 tools/testing/selftests/bpf/test_xsk.sh
>   create mode 100755 tools/testing/selftests/bpf/xsk_env.sh
>   create mode 100755 tools/testing/selftests/bpf/xsk_prereqs.sh
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 3d5940cd110d..596ee5c27906 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -46,7 +46,9 @@ endif
>   
>   TEST_GEN_FILES =
>   TEST_FILES = test_lwt_ip_encap.o \
> -	test_tc_edt.o
> +	test_tc_edt.o \
> +	xsk_prereqs.sh \
> +	xsk_env.sh
>   
>   # Order correspond to 'make run_tests' order
>   TEST_PROGS := test_kmod.sh \
> @@ -70,6 +72,7 @@ TEST_PROGS := test_kmod.sh \
>   	test_bpftool_build.sh \
>   	test_bpftool.sh \
>   	test_bpftool_metadata.sh \
> +	test_xsk.sh
>   
>   TEST_PROGS_EXTENDED := with_addr.sh \
>   	with_tunnels.sh \
> diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
> new file mode 100755
> index 000000000000..1836f2d2f617
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/test_xsk.sh
> @@ -0,0 +1,146 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright(c) 2020 Intel Corporation, Weqaar Janjua <weqaar.a.janjua@intel.com>
> +
> +# AF_XDP selftests based on veth
> +#
> +# End-to-end AF_XDP over Veth test
> +#
> +# Topology:
> +# ---------
> +#      -----------           -----------
> +#      |  xskX   | --------- |  xskY   |
> +#      -----------     |     -----------
> +#           |          |          |
> +#      -----------     |     ----------
> +#      |  vethX  | --------- |  vethY |
> +#      -----------   peer    ----------
> +#           |          |          |
> +#      namespaceX      |     namespaceY
> +#
> +# AF_XDP is an address family optimized for high performance packet processing,
> +# it is XDP’s user-space interface.
> +#
> +# An AF_XDP socket is linked to a single UMEM which is a region of virtual
> +# contiguous memory, divided into equal-sized frames.
> +#
> +# Refer to AF_XDP Kernel Documentation for detailed information:
> +# https://www.kernel.org/doc/html/latest/networking/af_xdp.html
> +#
> +# Prerequisites setup by script:
> +#
> +#   Set up veth interfaces as per the topology shown ^^:
> +#   * setup two veth interfaces and one namespace
> +#   ** veth<xxxx> in root namespace
> +#   ** veth<yyyy> in af_xdp<xxxx> namespace
> +#   ** namespace af_xdp<xxxx>
> +#   * create a spec file veth.spec that includes this run-time configuration
> +#   *** xxxx and yyyy are randomly generated 4 digit numbers used to avoid
> +#       conflict with any existing interface
> +#   * tests the veth and xsk layers of the topology
> +#
> +# Kernel configuration:
> +# ---------------------
> +# See "config" file for recommended kernel config options.
> +#
> +# Turn on XDP sockets and veth support when compiling i.e.
> +# 	Networking support -->
> +# 		Networking options -->
> +# 			[ * ] XDP sockets
> +#
> +# Executing Tests:
> +# ----------------
> +# Must run with CAP_NET_ADMIN capability.
> +#
> +# Run (summary only):
> +#  sudo make summary=1 run_tests
> +#
> +# Run (full color-coded output):
> +#   sudo make colorconsole=1 run_tests
> +#
> +# Run (full output without color-coding):
> +#   sudo make run_tests
> +#
> +# Clean:
> +#  sudo make clean

Can I just run test_xsk.sh at tools/testing/selftests/bpf/ directory?
This will be easier than the above for bpf developers. If it does not 
work, I would like to recommend to make it work.

I did that and there are some test failures.

root@arch-fb-vm1:~/net-next/net-next/tools/testing/selftests/bpf 
./test_xsk.sh
[ 3857.572549] ip (2547) used greatest stack depth: 11864 bytes left 

setting up ve1417: root: 192.168.222.1/30 

setting up ve6185: af_xdp6185: 192.168.222.2/30 

[ 3857.673408] IPv6: ADDRCONF(NETDEV_CHANGE): ve6185: link becomes ready 

Spec file created: veth.spec 

PREREQUISITES: [ PASS ] 

# Interface found: ve1417 

# Interface found: ve6185 

# NS switched: af_xdp6185 

1..1 

# Interface [ve6185] vector [Rx] 

# Interface [ve1417] vector [Tx] 

# Sending 10000 packets on interface ve1417 

not ok 1 ERROR: [worker_pkt_validate] prev_pkt [0], payloadseqnum [0] 

# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0 

SKB NOPOLL: [ FAIL ] 

# Interface found: ve1417 

# Interface found: ve6185 

# NS switched: af_xdp6185 

1..1 

# Interface [ve6185] vector [Rx] 

# Interface [ve1417] vector [Tx] 

# Sending 10000 packets on interface ve1417 

# End-of-tranmission frame received: PASS 

# Received 10000 packets on interface ve6185
ok 1 PASS: SKB POLL
# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
SKB POLL: [ PASS ]
# Interface found: ve1417
# Interface found: ve6185
# NS switched: af_xdp6185
1..1
# Interface [ve6185] vector [Rx]
# Interface [ve1417] vector [Tx]
# Sending 10000 packets on interface ve1417
not ok 1 ERROR: [worker_pkt_validate] prev_pkt [95], payloadseqnum [0]
# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
DRV NOPOLL: [ FAIL ]
# Interface found: ve1417
# Interface found: ve6185
# NS switched: af_xdp6185
1..1
# Interface [ve6185] vector [Rx]
# Interface [ve1417] vector [Tx]
# Sending 10000 packets on interface ve1417
# End-of-tranmission frame received: PASS
# Received 10000 packets on interface ve6185
ok 1 PASS: DRV POLL
# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
DRV POLL: [ PASS ]
# Interface found: ve1417
# Interface found: ve6185
# NS switched: af_xdp6185
1..1
# Creating socket
# Interface [ve6185] vector [Rx]
# Interface [ve1417] vector [Tx]
# Sending 10000 packets on interface ve1417
not ok 1 ERROR: [worker_pkt_validate] prev_pkt [29], payloadseqnum [0]
# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
SKB SOCKET TEARDOWN: [ FAIL ]
# Interface found: ve1417
# Interface found: ve6185
# NS switched: af_xdp6185
1..1
# Creating socket
# Interface [ve6185] vector [Rx]
# Interface [ve1417] vector [Tx]
# Sending 10000 packets on interface ve1417
not ok 1 ERROR: [worker_pkt_validate] prev_pkt [23], payloadseqnum [0]
# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
DRV SOCKET TEARDOWN: [ FAIL ]
# Interface found: ve1417
# Interface found: ve6185
# NS switched: af_xdp6185
1..1
# Creating socket
# Interface [ve6185] vector [Rx]
# Interface [ve1417] vector [Tx]
# Sending 10000 packets on interface ve1417
not ok 1 ERROR: [worker_pkt_validate] prev_pkt [88], payloadseqnum [0]
# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
SKB BIDIRECTIONAL SOCKETS: [ FAIL ]
# Interface found: ve1417
# Interface found: ve6185
# NS switched: af_xdp6185
1..1
# Creating socket
# Interface [ve6185] vector [Rx]
# Interface [ve1417] vector [Tx]
# Sending 10000 packets on interface ve1417
not ok 1 ERROR: [worker_pkt_validate] prev_pkt [1], payloadseqnum [0]
# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
DRV BIDIRECTIONAL SOCKETS: [ FAIL ]
cleaning up...
removing link ve6185
removing ns af_xdp6185
removing spec file: veth.spec
root@arch-fb-vm1:~/net-next/net-next/tools/testing/selftests/bpf

I do have the following
    CONFIG_VETH=y
    CONFIG_XDP_SOCKETS=y

What other configures I am missing?

BTW, I cherry-picked the following pick from bpf tree in this experiment.
   commit e7f4a5919bf66e530e08ff352d9b78ed89574e6b (HEAD -> xsk)
   Author: Björn Töpel <bjorn.topel@intel.com>
   Date:   Mon Nov 23 18:56:00 2020 +0100

       net, xsk: Avoid taking multiple skbuff references

> +
> +. xsk_prereqs.sh
> +
> +TEST_NAME="PREREQUISITES"
> +
> +URANDOM=/dev/urandom
> +[ ! -e "${URANDOM}" ] && { echo "${URANDOM} not found. Skipping tests."; test_exit 1 1; }
> +
> +VETH0_POSTFIX=$(cat ${URANDOM} | tr -dc '0-9' | fold -w 256 | head -n 1 | head --bytes 4)
> +VETH0=ve${VETH0_POSTFIX}
> +VETH1_POSTFIX=$(cat ${URANDOM} | tr -dc '0-9' | fold -w 256 | head -n 1 | head --bytes 4)
> +VETH1=ve${VETH1_POSTFIX}
> +NS1=af_xdp${VETH1_POSTFIX}
> +IPADDR_VETH0=192.168.222.1/30
> +IPADDR_VETH1=192.168.222.2/30
> +MTU=1500
> +
> +setup_vethPairs() {
> +	echo "setting up ${VETH0}: root: ${IPADDR_VETH0}"
> +	ip netns add ${NS1}
> +	ip link add ${VETH0} type veth peer name ${VETH1}
> +	ip addr add dev ${VETH0} ${IPADDR_VETH0}
> +	echo "setting up ${VETH1}: ${NS1}: ${IPADDR_VETH1}"
> +	ip link set ${VETH1} netns ${NS1}
> +	ip netns exec ${NS1} ip addr add dev ${VETH1} ${IPADDR_VETH1}
> +	ip netns exec ${NS1} ip link set ${VETH1} mtu ${MTU}
> +	ip netns exec ${NS1} ip link set ${VETH1} up
> +	ip link set ${VETH0} mtu ${MTU}
> +	ip link set ${VETH0} up
> +}
> +
> +validate_root_exec
> +validate_veth_support ${VETH0}
> +validate_configs
> +setup_vethPairs
> +
> +retval=$?
> +if [ $retval -ne 0 ]; then
> +	test_status $retval "${TEST_NAME}"
> +	cleanup_exit ${VETH0} ${VETH1} ${NS1}
> +	exit $retval
> +fi
> +
> +echo "${VETH0}:${VETH1},${NS1}" > ${SPECFILE}
> +
> +echo "Spec file created: ${SPECFILE}"
> +
> +test_status $retval "${TEST_NAME}"
> +
> +## START TESTS
> +
> +statusList=()
> +
> +### TEST 1
> +TEST_NAME="XSK FRAMEWORK"
> +
> +echo "Switching interfaces [${VETH0}, ${VETH1}] to XDP Generic mode"
> +vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
> +
> +retval=$?
> +if [ $retval -eq 0 ]; then
> +	echo "Switching interfaces [${VETH0}, ${VETH1}] to XDP Native mode"
> +	vethXDPnative ${VETH0} ${VETH1} ${NS1}
> +fi
> +
> +retval=$?
> +test_status $retval "${TEST_NAME}"
> +statusList+=($retval)
> +
> +## END TESTS
> +
> +cleanup_exit ${VETH0} ${VETH1} ${NS1}
> +
> +for _status in "${statusList[@]}"
> +do
> +	if [ $_status -ne 0 ]; then
> +		test_exit $ksft_fail 0
> +	fi
> +done
> +
> +test_exit $ksft_pass 0
> diff --git a/tools/testing/selftests/bpf/xsk_env.sh b/tools/testing/selftests/bpf/xsk_env.sh
> new file mode 100755
> index 000000000000..2c41b4284cae
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/xsk_env.sh
> @@ -0,0 +1,11 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright(c) 2020 Intel Corporation.
> +
> +. xsk_prereqs.sh
> +
> +validate_veth_spec_file
> +
> +VETH0=$(cat ${SPECFILE} | cut -d':' -f 1)
> +VETH1=$(cat ${SPECFILE} | cut -d':' -f 2 | cut -d',' -f 1)
> +NS1=$(cat ${SPECFILE} | cut -d':' -f 2 | cut -d',' -f 2)
> diff --git a/tools/testing/selftests/bpf/xsk_prereqs.sh b/tools/testing/selftests/bpf/xsk_prereqs.sh
> new file mode 100755
> index 000000000000..694c5f5ab5e3
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/xsk_prereqs.sh
> @@ -0,0 +1,119 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright(c) 2020 Intel Corporation.
> +
> +ksft_pass=0
> +ksft_fail=1
> +ksft_xfail=2
> +ksft_xpass=3
> +ksft_skip=4
> +
> +GREEN='\033[0;92m'
> +YELLOW='\033[0;93m'
> +RED='\033[0;31m'
> +NC='\033[0m'
> +STACK_LIM=131072
> +SPECFILE=veth.spec
> +
> +validate_root_exec()
> +{
> +	msg="skip all tests:"
> +	if [ $UID != 0 ]; then
> +		echo $msg must be run as root >&2
> +		test_exit $ksft_fail 2
> +	else
> +		return $ksft_pass
> +	fi
> +}
> +
> +validate_veth_support()
> +{
> +	msg="skip all tests:"
> +	if [ $(ip link add $1 type veth 2>/dev/null; echo $?;) != 0 ]; then
> +		echo $msg veth kernel support not available >&2
> +		test_exit $ksft_skip 1
> +	else
> +		ip link del $1
> +		return $ksft_pass
> +	fi
> +}
> +
> +validate_veth_spec_file()
> +{
> +	if [ ! -f ${SPECFILE} ]; then
> +		test_exit $ksft_skip 1
> +	fi
> +}
> +
> +test_status()
> +{
> +	statusval=$1
> +	if [ -n "${colorconsole+set}" ]; then
> +		if [ $statusval -eq 2 ]; then
> +			echo -e "${YELLOW}$2${NC}: [ ${RED}FAIL${NC} ]"
> +		elif [ $statusval -eq 1 ]; then
> +			echo -e "${YELLOW}$2${NC}: [ ${RED}SKIPPED${NC} ]"
> +		elif [ $statusval -eq 0 ]; then
> +			echo -e "${YELLOW}$2${NC}: [ ${GREEN}PASS${NC} ]"
> +		fi
> +	else
> +		if [ $statusval -eq 2 ]; then
> +			echo -e "$2: [ FAIL ]"
> +		elif [ $statusval -eq 1 ]; then
> +			echo -e "$2: [ SKIPPED ]"
> +		elif [ $statusval -eq 0 ]; then
> +			echo -e "$2: [ PASS ]"
> +		fi
> +	fi
> +}
> +
> +test_exit()
> +{
> +	retval=$1
> +	if [ $2 -ne 0 ]; then
> +		test_status $2 $(basename $0)
> +	fi
> +	exit $retval
> +}
> +
> +clear_configs()
> +{
> +	if [ $(ip netns show | grep $3 &>/dev/null; echo $?;) == 0 ]; then
> +		[ $(ip netns exec $3 ip link show $2 &>/dev/null; echo $?;) == 0 ] &&
> +			{ echo "removing link $2"; ip netns exec $3 ip link del $2; }
> +		echo "removing ns $3"
> +		ip netns del $3
> +	fi
> +	#Once we delete a veth pair node, the entire veth pair is removed,
> +	#this is just to be cautious just incase the NS does not exist then
> +	#veth node inside NS won't get removed so we explicitly remove it
> +	[ $(ip link show $1 &>/dev/null; echo $?;) == 0 ] &&
> +		{ echo "removing link $1"; ip link del $1; }
> +	if [ -f ${SPECFILE} ]; then
> +		echo "removing spec file:" ${SPECFILE}
> +		rm -f ${SPECFILE}
> +	fi
> +}
> +
> +cleanup_exit()
> +{
> +	echo "cleaning up..."
> +	clear_configs $1 $2 $3
> +}
> +
> +validate_configs()
> +{
> +	[ ! $(type -P ip) ] && { echo "'ip' not found. Skipping tests."; test_exit $ksft_skip 1; }
> +}
> +
> +vethXDPgeneric()
> +{
> +	ip link set dev $1 xdpdrv off
> +	ip netns exec $3 ip link set dev $2 xdpdrv off
> +}
> +
> +vethXDPnative()
> +{
> +	ip link set dev $1 xdpgeneric off
> +	ip netns exec $3 ip link set dev $2 xdpgeneric off
> +}
> 
