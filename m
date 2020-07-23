Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9A622B924
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 00:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgGWWFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 18:05:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23770 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726173AbgGWWFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 18:05:48 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06NM5VoG004325;
        Thu, 23 Jul 2020 15:05:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=lBx5kqifPPbpxvMJV6tSRUO64qQGsJG5IpKYpHoIEDU=;
 b=iK7ahKJQ8cUyHE97UB/0ExdmUAFNLl1ZQRNc7LzQ3jRwPgSo36ipMwPdK5wW3tXxjd+B
 KZhmJx50s65kes5NhryMslisndt/SWj7qV1NGZ1pXdd+iaiUuXUQE2d51YvdsOboCuG3
 lwWRvK/lAVoRYLeYPdEVwiJo2HOgPVs8Coo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32esyuxpts-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Jul 2020 15:05:34 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 23 Jul 2020 15:05:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cG8OeeZEDPs1UK0sEqh3iLtWpGN/N0xGTfjce29KmQzl2aTBXybnfwUjc+sdwh8l1qt2T7YI/v6FTHFDqFHA4HmjtnNWvrlIP2BM20lyaEsBtx+IcFlEHFSFd/SevzTrKsahBofrHrLPAfiBBNQnv7S5HUgoVaUW4i6zFwobZE5pfef1GOUNZtgKRX8cP0y9LgzUPxChbD1tJeqSBUssle4PNkfQUuoUd/39kXowShKgwDnDMkGJTw/wdnNGNmfk91UBtYGgfSoXw95Sx0KSRnKur7xrNi/YbUyNQdK/EoZrOEoTmcIkXo6TYOWiX3z2LCqOpC5JoJrBeSJJGAc25g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBx5kqifPPbpxvMJV6tSRUO64qQGsJG5IpKYpHoIEDU=;
 b=IGaNcTBkit4TLL45twC1CpLLIU8Q5KC/lA558OYK+sWP7WbbZm03NDXEgcQH2uLvJGinorgCn0p1bjEOGPRjTTCmMHFG77i8N+BFKySvZAZN4KCDN8E5lgWxS8t27xpvNnGH71hN64TLTMiTF8C64o3Y3eO9/ulicsq58owAfq4oKkHGtbu0XPERbFZEr0XGtLklToV4Bi40cGsdJinVHTfduRtmsmUhKp5MyHx2BXFRvKw4ATWVcm6aDeIL2DsBKxVteT6t5gr8WSEKCqjmeo8Oc+c+w5NntrG6UWi1Wt25E1n/0YhDRC2laTksgdrjYipfjPo7VB54+FQO2ZSzsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBx5kqifPPbpxvMJV6tSRUO64qQGsJG5IpKYpHoIEDU=;
 b=bilCQYxM0h825PC49ryk0mQvaXHjFROgQC1POeZJjUyL3X8IsLMK5DEEM1xTQjQAJpVyMDRt9h+Og0ImBK5uT7W+fNti31e8GVJKaDxNVQmuhjgWLbxYuoQ39Z8dLbesjbURCRXSymqv+KOQ/c9gjrWn6kLp+2iHxJikGDiIKaI=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2773.namprd15.prod.outlook.com (2603:10b6:a03:150::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Thu, 23 Jul
 2020 22:05:21 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3216.021; Thu, 23 Jul 2020
 22:05:21 +0000
Subject: Re: [PATCH bpf v2 2/2] selftests/bpf: Add test for narrow loads from
 context at an offset
To:     Jakub Sitnicki <jakub@cloudflare.com>, <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20200723095953.1003302-1-jakub@cloudflare.com>
 <20200723095953.1003302-3-jakub@cloudflare.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7ae94398-2581-3cfb-da7e-702852d712a4@fb.com>
Date:   Thu, 23 Jul 2020 15:05:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <20200723095953.1003302-3-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0033.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::46) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1888] (2620:10d:c090:400::5:e13e) by BY5PR16CA0033.namprd16.prod.outlook.com (2603:10b6:a03:1a0::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22 via Frontend Transport; Thu, 23 Jul 2020 22:05:21 +0000
X-Originating-IP: [2620:10d:c090:400::5:e13e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69370afb-e93a-4d0c-084c-08d82f547e15
X-MS-TrafficTypeDiagnostic: BYAPR15MB2773:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2773C2CAE20322017BE1935DD3760@BYAPR15MB2773.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: beCftHvHjPKteDJ6oDVMesFstKYS+r5122IMDVoujIsJJ4vmfvRTQ4TosTQ/h9o3dZioGBkJovC2IqcHUP9bbNjx9S9kg6F02Dl1Mp9tw2J/wI6DyyueqQDMSSDGJZE9IVv8M2ewUGVknYiz7m24gCtXW9F4mKExIIn17K5f7kTPQUDfO0rH3Ee7jZzJcrL7BL2AJumZTGkPqsWD+YW7SqkTBFo53bGVavtvgh3vFemNX+8QDiOKKRZNKiarrKNl797CToWiFvAL9UBzCh18BaoVzEWTReQVEWnQBWivOjXSdjrdDlfzWvrN9G+7+8K5qXpv+QvoRMDgyzgCfHhW8Nk9ATusSaqgdsryCLzuYoXYlFMy/Nj5SFpIJlvTk4i4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(376002)(346002)(39860400002)(136003)(8936002)(316002)(186003)(2616005)(478600001)(8676002)(16526019)(31696002)(66556008)(66476007)(66946007)(54906003)(4326008)(86362001)(2906002)(31686004)(52116002)(36756003)(53546011)(6486002)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 72zsLEBhtSuzBvTSoJDqQJf87lusoSg60ZaYZZ91CPgERF3ai4v+3B+Q+125GExThS9+6TrXhTpi5MC/x1jCiNutW+nnGN51JPC/DRO3I0i63VI7Vzv/9+M/8h+xSomPGIOE6A9UySx+hbFX/+VrdgfGwM5e1NVZLpeQSv2r05p97FfnLB0WLqLHnsSI/oq758X5KX7/fcSpVYsyPsKOdArT66vPoTEBKnRSBnUl0mmvi0yGyipnVU7N41MZO8qZP241zJ7Dd3NiW4v7bdhPm9mhjEygVsI+7gz+ns7+U5K4VWiC1vmbs08Jyu7FYgX6x2tKpbj3YGLsSi26/4FJNbOOhIR2p/LPdtYJXaoyACDtDPSoNBZsGmAqpzFPziYzwUdIlEWNcH2mRiT+KSeRM70xBIxU6QtRZzv0vRzbLLkNvqEM+b3Q34Dk1ZKUAkldwjPiSxRrwab1JsJN5FTtIuejPs/LInY7rb3cT40yMxB9JkPBtWRIcSwPYjIEOK2drWD04/tWUhDv3t+m9YC9Lw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 69370afb-e93a-4d0c-084c-08d82f547e15
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2020 22:05:21.3250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ML53XrtyvUcWocEDSiHVrx4KMV80FiuSpMWU3HvxJJHFt/0Rt645BFLQKkgWFHFS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2773
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_09:2020-07-23,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 suspectscore=0 impostorscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230154
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/23/20 2:59 AM, Jakub Sitnicki wrote:
> Check that narrow loads at various offsets from a context field backed by a
> target field that is smaller in size work as expected. That is target field
> value is loaded only when the offset is less than the target field size.
> While for offsets beyond the target field, the loaded value is zero.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

Ack with minor nit below.
Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   .../selftests/bpf/prog_tests/narrow_load.c    | 84 +++++++++++++++++++
>   .../selftests/bpf/progs/test_narrow_load.c    | 43 ++++++++++
>   2 files changed, 127 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/narrow_load.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_narrow_load.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/narrow_load.c b/tools/testing/selftests/bpf/prog_tests/narrow_load.c
> new file mode 100644
> index 000000000000..6d79d722a66d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/narrow_load.c
> @@ -0,0 +1,84 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +// Copyright (c) 2020 Cloudflare
> +
> +#include "test_progs.h"
> +#include "test_narrow_load.skel.h"
> +
> +static int duration;
> +
> +void run_sk_reuseport_prog(struct bpf_program *reuseport_prog)

static function?

> +{
> +	static const struct timeval timeo = { .tv_sec = 3 };
> +	struct sockaddr_in addr = {
> +		.sin_family = AF_INET,
> +		.sin_port = 0,
> +		.sin_addr.s_addr = htonl(INADDR_LOOPBACK),
> +	};
> +	socklen_t len = sizeof(addr);
> +	int err, fd, prog_fd;
> +	const int one = 1;
> +	char buf = 42;
> +	ssize_t n;
> +
[...]
