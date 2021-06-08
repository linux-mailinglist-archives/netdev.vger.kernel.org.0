Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD5039FC42
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 18:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbhFHQWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 12:22:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64670 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230222AbhFHQW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 12:22:28 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 158G7lQ0007274;
        Tue, 8 Jun 2021 09:20:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=hlNC9F/ux2UWsAFTteDPd+efNUrrxygvPWC/8qpbgGo=;
 b=kxODGIZ8vpZ5WRMcf1MdcLMiSHPGfNRJlp2gDcMbvyAuFN4IJCsX5RCwine42a2FlkVw
 7iIV+FsLZSR6y1bWX3lTlUTMuMQ8maScGrz/jIxEL2CcXq40M9HRHNMq0+W+ZCyqX2Ca
 mtEWzIil6eVg9eJ2nK/RnYyDdBWsZH94ss4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 391rhyp7rx-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 08 Jun 2021 09:20:19 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 09:20:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WF9aBrw30DJJATMRv9D1XDlsHsWrGGL3cD7bIpnLYH9aR8iPar+CVJGgWGaH4phLsnTHI2Uzx/wI+AJYK26jDtHfyDgUevVWxV+SGzEus2tpfmNuQLy8IsxlPjmVxEqNZmHWCV4FohIDfoEeyzRaMtE8G+pJ9+U47ny0DNMt1wsJNgEfv58bFwV0h7c1KlayeDkURHVAXmc9Efv86XDsUNB+A9x/+vK9X4CuFFxVqgjwcbU18jwG3a7fGjQDQgfdor2ElRAV6ay/vmEltz7VhNILiOZcW03eL7HrJTcOeuY8t4UTOWXIOrF/3aER0M6g60aCeVFpZ7X4zg9VKwsSjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hlNC9F/ux2UWsAFTteDPd+efNUrrxygvPWC/8qpbgGo=;
 b=UtTmgZED9jJTiEpZK8PZOAybSfT5CPAqf2xj+RkRz5CBB/8IsPwR9n6oQEOI8QHpbuQJnPJqMuZlUS2iB8bEcPHxm8tGJDGk5UF6gNBDPRkEbHrKMjfD3jPfuqXcYUBEiT7uc88Rq8vRhrB8IVDeWSnFLDlmXKWb0hGCXUWtSlBMb2ICrUEeW+Kf9P59NdrtF+K/SdMlwyDi6ft8HNGAeaEy5UqediBr/Rc81AnWGQlOWn9QMUOQ4V8PPcj07o4hqdI38kMTWVos/88RNdqNB6TdOQ2cHE5SQXz+WoNt82h5VxCWcziQx1aTqnjI6rZQKXXc5m6Ck1oH8l02M4LGUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR1501MB2160.namprd15.prod.outlook.com (2603:10b6:805:9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Tue, 8 Jun
 2021 16:20:16 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 16:20:16 +0000
Subject: Re: [PATCH bpf-next v1 03/10] tools: Add bpfilter usermode helper
 header
To:     Dmitrii Banshchikov <me@ubique.spb.ru>, <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <davem@davemloft.net>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <netdev@vger.kernel.org>, <rdna@fb.com>
References: <20210603101425.560384-1-me@ubique.spb.ru>
 <20210603101425.560384-4-me@ubique.spb.ru>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <6cced642-6342-4711-9f04-636e6903d60b@fb.com>
Date:   Tue, 8 Jun 2021 09:20:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210603101425.560384-4-me@ubique.spb.ru>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:1fdb]
X-ClientProxiedBy: BYAPR01CA0003.prod.exchangelabs.com (2603:10b6:a02:80::16)
 To SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::108b] (2620:10d:c090:400::5:1fdb) by BYAPR01CA0003.prod.exchangelabs.com (2603:10b6:a02:80::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Tue, 8 Jun 2021 16:20:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ded641c0-5d97-4480-d090-08d92a994cd1
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2160:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR1501MB21601A45CE43D91C4965D9F9D3379@SN6PR1501MB2160.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:326;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u/j3odFspGmEgudJBpOfbW1AA7UJCiCq0lfJo80RSAWb+casPirXMKJIkhz/MVer+NyL+4HNnT5bUp6zOXgn1DU2McEXNupBwRov1WkZ9xZvUCBdEasI9xM6vb0kb4nQ3oJU7OTheiE9+wavYqrRX7uJhF+jxGmmyS3ddAm0qLMVCrhN0C2DMJDjEUA1cgqv5Y9BzugliEOOzvqn9omkV1xxjzVspOHLxMETyaL5ELHbrQfTuHw3IzPjR8nf6Ohcin6MHsXBzEgxmiZQdWKm71rKJOl/4ISG6vJrSgjPMtHb+rZCee6WiZj2EGTsoaL+0ts+LKGRkOe6stLnOJpu6u8eHcLEjuq2EVrp/ltZcfJzGwaYV9U1bXUCSleN6TQYDKwhhq510eEtxLchMADUVNWkS5x+GvHRLG585b9pzvAk4nhzXpc3yGX3XlQPyXIg1ttSFMgmL4j2dOKVACmpxNgUf1a7X4U8A+Vb4KwBIR4oDDspWUwXAuDYBcxN/wfgAULUja9SHiQBH9KEHk27EHjRXEyrdY09c5TuxugGyfmP7N+prh8gZR7H1kTtSrgOtRH6W0XUR4hcbSNyMHaW9Vogs8pCtckz7wI6bPaVU74Wn89q6YuyUHxeVOW4gYfV9GAfT6Unm5f3kyZ4TUSEQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(36756003)(66946007)(86362001)(66556008)(66476007)(316002)(6486002)(6666004)(186003)(38100700002)(31686004)(83380400001)(16526019)(2906002)(52116002)(5660300002)(31696002)(53546011)(8676002)(8936002)(4326008)(2616005)(478600001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SDY2MGdsbGloMW4wYXdJU1hWc3ZaNUFuazNKNmlRaHNORDlNZHdZSjJwR2N0?=
 =?utf-8?B?dmJIci82RWM3dk0vOWZ0eU41S1RZOHB4U3dsSldTQVZBVlgzNUFzZTdWWU4r?=
 =?utf-8?B?alZmSHJYOGZBNzFlODROclRIUkppdEFNVTFka2ZOOUFyYWl6Ym1zWElqdkV6?=
 =?utf-8?B?NjhUNmdOVS9IV08vR2phazlYK0FQU2R4N3E3L1hZbGxVZFUzRkxPTkUrazZr?=
 =?utf-8?B?WnpRS2ZpWjBsZVEyM3pFb1hyUkFadUk3dFIxL1ZZTExudjVKdXBYMmRaRzg0?=
 =?utf-8?B?NzVKOTMzNFJRNUdDNk52K04vMEhTK0VmUGgwekgyL0lwTDZqRnhCZmlvT0Rk?=
 =?utf-8?B?NW5CVXdjRVF4SmZUeEwxZkJiU2lxZDJGQWJrUTVZZzlYY3lDaW5KcGhuSkpx?=
 =?utf-8?B?TDNwVG9jcE5IbUgxRE1VUGI0bmlVaFBwRElkcHc4dFIwZFhVRkpSL01BWUJj?=
 =?utf-8?B?azhIaTNYQkNFSXljTnVhK2dwbENVak9ZMWJxWC9vc1dEVGpNanF0MkJTTWJj?=
 =?utf-8?B?MldTYkRmajRzd2dxdTk4K2xCd3RCdTdhU01sSG1oeU5zaWx1S2ZjcWp2REQx?=
 =?utf-8?B?Z0NsMVZ0c1crdEhjN1ZOSEV3ZDZrdUlITFpkeXk4eUI0V0xxMlVxZkpwVjJx?=
 =?utf-8?B?T0ZybWZVSW82bk9hbVBIYjdndUdRb3ZsSkZBaldDMmplRU9RZDNiSzZ2ZWJQ?=
 =?utf-8?B?bi9xRmxuYTlnK003YW9wbkFaRFBaQkFodlhoaDZIWTRKa1dkZndNbDVOL01F?=
 =?utf-8?B?V0FlZG5yRGpjb3BaQm9ISjc0ZDlaMlpTU0U4SWM1Ukt2NHhUMjlSeTVmQ3U3?=
 =?utf-8?B?cElzdjlkNXpXSElKNDNGUnA1QWxUNExjcFJzN0JPNlhxMFdGalorTmI5Vnpl?=
 =?utf-8?B?dVdrY1Q0VkdjK2xMV2dSQlZUTUNleFNtM2lHbEpvS0RGR2VYTWpQVTlyQ3By?=
 =?utf-8?B?MXVZYUhvcVYzREZFS1lZejdHQXkwUUFFdnE2QUpodkoyRzdNVDRZaCtEb2tQ?=
 =?utf-8?B?ZXozSHN4ZVRFZ3FPMWt1NkZHSFJnOW4ySm55TXpKNUJUak1HVnJWdUdzbjll?=
 =?utf-8?B?dERSZllBdnU3T1NLZ2wvWUEvcTZHRFM2Y295Q0pGUmtFandyQXQwZ1B0K0ox?=
 =?utf-8?B?UWlaeU9GV3owZ1E1Q1IrTC96MWwrSm5ZVzVXSEJmSlB3NkVGb1VVMkVlOEE0?=
 =?utf-8?B?dW4wQ2dsS3k1UmhYa3E3bXlTMGNFNTdHb21weWt6aW14TXlQZUtzeWUyUUZo?=
 =?utf-8?B?LzVkZjV3a2dOZFo3VEgrc0JES1pITm1rM0thcUttaXB5LzRabjNsdXlIMk8r?=
 =?utf-8?B?bE1TVVR4VEhBVHlxd01CQlZsc0Fwblg1U21BbGZQb091RG1CRnQ4WWp0U0RM?=
 =?utf-8?B?a052aTVhT3F2di9kY0tOQXJLanFvdUJWU3VCdWl2dEsxRWtQZlBERXVPYkwz?=
 =?utf-8?B?L21UelFGVmZ0a3VtQnpkWFRWSU1DZ0wwT1pSRVo3QTlOTTdHdlhTOTJKS2R0?=
 =?utf-8?B?L1IrWkt3RzBHSHFEVVUyRTZWeWFpeVUxVlR6Z0lETnd2UzkyZzhoUENOMXJN?=
 =?utf-8?B?NHFlRzRmTzNJWkJ4TmVPLzlzZ3pkK2l5anNHSUNnMm1COFo0SjVmY0wrVUpP?=
 =?utf-8?B?UUowWDRFTEUwY0o0SVNkNTJCUS8zUnBpMTJHUDZYOEpsMm04T2FSbXFZQ0RX?=
 =?utf-8?B?OUs1OUNhUE5JT2xUUUNPSkZoMlgxbkRQUCtoUENkOWJKMVBTcGZoTndiNzUx?=
 =?utf-8?B?aDdXNFV4ajNVY3A0RHZha09KVEJFdnA1RmtUK2I0cEhXNVp2YkJsam9WYXNp?=
 =?utf-8?B?ZnJ2dzJLV2FjZnJ4emYxUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ded641c0-5d97-4480-d090-08d92a994cd1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 16:20:15.9216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ubbiv6Fz3ZFuu4syO6RW5bS753aqc/GHWQl5QZ2F84BN2OaHwS3BDWDeOs2qF1QH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2160
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 1UoGZ_hNusJTLscJkvP9jAOw80NTe8HD
X-Proofpoint-ORIG-GUID: 1UoGZ_hNusJTLscJkvP9jAOw80NTe8HD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-08_11:2021-06-04,2021-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106080104
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/3/21 3:14 AM, Dmitrii Banshchikov wrote:
> The header will be used in bpfilter usermode helper test infrastructure.
> 
> Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
> ---
>   tools/include/uapi/linux/bpfilter.h | 179 ++++++++++++++++++++++++++++
>   1 file changed, 179 insertions(+)
>   create mode 100644 tools/include/uapi/linux/bpfilter.h
> 
> diff --git a/tools/include/uapi/linux/bpfilter.h b/tools/include/uapi/linux/bpfilter.h
> new file mode 100644
> index 000000000000..8b49d81f81c8
> --- /dev/null
> +++ b/tools/include/uapi/linux/bpfilter.h
> @@ -0,0 +1,179 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI_LINUX_BPFILTER_H
> +#define _UAPI_LINUX_BPFILTER_H
> +
> +#include <linux/if.h>
> +#include <linux/const.h>
> +
> +#define BPFILTER_FUNCTION_MAXNAMELEN    30
> +#define BPFILTER_EXTENSION_MAXNAMELEN   29
> +
> +#define BPFILTER_STANDARD_TARGET        ""
> +#define BPFILTER_ERROR_TARGET           "ERROR"
> +
> +
> +#define BPFILTER_ALIGN(__X) __ALIGN_KERNEL(__X, __alignof__(__u64))

The difference between include/uapi/linux/bpfilter.h and
tools/include/uapi/linux/bpfilter.h is the above "define".
Can we put the above define in include/uapi/linux/bpfilter.h as well
so in the commit message we can say tools/include/uapi/linux/bpfilter.h
is a copy of include/uapi/linux/bpfilter.h?

> +
> +enum {
> +	BPFILTER_IPT_SO_SET_REPLACE = 64,
> +	BPFILTER_IPT_SO_SET_ADD_COUNTERS = 65,
> +	BPFILTER_IPT_SET_MAX,
> +};
> +
[...]
