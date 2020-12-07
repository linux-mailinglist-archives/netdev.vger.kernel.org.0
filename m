Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3AD2D15BA
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgLGQNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:13:04 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11878 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbgLGQNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 11:13:04 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B7G7uuL025241;
        Mon, 7 Dec 2020 08:12:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=V8RySeb1Qn2XQ7UPL40o6Z8B7bz/6BpNDPHcrrAStgQ=;
 b=fz0W2Llm+A/pV40nTdFGkp5P9P/lreUJTKKHaOaMUKGUc74P5fuEmpoWpjFdnJ2JvXw6
 nWOljssRDVTroWXpMwDico0r2llkTSP2HObIQHtmln6CzaxDYydVpUgzV6KkTKKrjcRt
 bOl2bC1GfaI6QWqsSZZIwFPqbd4mNhr/8pg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 358u5aq20d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Dec 2020 08:12:10 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 08:12:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZgEjW1P1ELAPX6XpmjGM6Ak0kZMVY1CBjGtZvs1dBQ9qXNuwUtTKArvDA7aYURBHRFU4LPDCP6gxCRts7sqEgFPCHPyycy1/2Xn3h16gDoVczpkvyGZXv7vt0MlXu6rzssxFY+pqFR48iZlwcmii8Mv3WOFn94JzzNDGp4cINOLzJEJlBNd8OokBG63JBzgj7zEmi3UXzbxhbQiTCM8V9NxSQmmdWlSX5FP/635+NkXq7Xi7XbF2DHvASaancVcGDkx/CSHkccZR5WppnFOsn86Ew1JCZ/tJ+ymXlw80sxPPUZUDXS7LPamL78RPok8xc8HDdWF8w5CYW1hJ+xWMqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V8RySeb1Qn2XQ7UPL40o6Z8B7bz/6BpNDPHcrrAStgQ=;
 b=oEzBL3+4U+Uf7Dprl6dO0R3c0f9cO75nJcT8tK6eP4NV1ncm0/zFXnr9ZOAx33kOTfb++A2WMq+8IGo/3BR3LldS/SfdopeIpuvvMKjEds9Jcbw38xox588s9Gb3akqoPcQiUPxI6XRMJsIOP1RI+kJs9sJjTP9zb2a5HeqLNNVka5XaeohxbjOeupzwS1SyNQaedYJI8T+NPrpiaOjjwYsq2w8OmBZv5tBVM19bKwio5kGT/bcVzvwcGLj5v6Nu9oA52/ZfrdFzpagOYerLgKb1B9UusffCBTZ7P6PYsqMgEAePPzk3x2c58PKICSjZ78ZHghsD715QYs5VaG3k4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V8RySeb1Qn2XQ7UPL40o6Z8B7bz/6BpNDPHcrrAStgQ=;
 b=StyVIoQjeo5muqvYlJIsUfjxZH1PoqDFLLHPO/ZPZo06HuCvcIFOIhtcU7bXWoEx/MUsdkwa2kxRIa7hjEVK9Wl23GSZylGOGibLsg6lwB6pBDFNaNGOlzXBzObbhcxOSz8dnRtNjDpS/6dKd+NQxWHoyAFP3cDSUZhjppqSDdo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2568.namprd15.prod.outlook.com (2603:10b6:a03:14c::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Mon, 7 Dec
 2020 16:12:08 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3632.021; Mon, 7 Dec 2020
 16:12:08 +0000
Subject: Re: [PATCH] bpf: propagate __user annotations properly
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        <kernel-janitors@vger.kernel.org>
References: <20201207123720.19111-1-lukas.bulwahn@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <480e9a0f-0a27-aec2-e8c6-a73b46069ba8@fb.com>
Date:   Mon, 7 Dec 2020 08:12:05 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <20201207123720.19111-1-lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:ca62]
X-ClientProxiedBy: MW3PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:303:2b::27) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::113f] (2620:10d:c090:400::5:ca62) by MW3PR05CA0022.namprd05.prod.outlook.com (2603:10b6:303:2b::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.8 via Frontend Transport; Mon, 7 Dec 2020 16:12:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c216e4e-d2ba-4c3b-858b-08d89acad8ca
X-MS-TrafficTypeDiagnostic: BYAPR15MB2568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB256803AC48B156211EA843A0D3CE0@BYAPR15MB2568.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lwQWuIWsIFFoePnVwqpgioKGoS+FJpLM3xRfn7lgc7X94HlUZSmgc9OuJsyq0CZXobrcdG9eyPhEiI+OvRyCYwP+TiXb5JMpI45rAaoEMOFD22qzhtFmtrTiz7T6vyqhrj5MAe4PfXqVV0nBl8GhE3TAmuSvFcx+SlZ6mxC4dcssAzLXR+2pBSAzqPTncco/y2pwXT+xX7PbFmbBosY7L6GMNy6yRmB2BchVbXBUFTb9+0FNA1zF6Nk8ij8PWU5EdYep6ZrAt3aZtLAzu08IqqWhAJh1Py3tdYdY8M3g84jMxWay1G/o2jBBUMoUu5Yj8msdGcovC7cMo+6sqq/oFhbLidZaXEge0Ooj6dKjL63i4yQdfekc7Dovp/jbbINySoAS8JKMEP/ECysq/E22VBAK+dwfYM6/6BMeB7Fc82s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(39860400002)(366004)(136003)(5660300002)(2616005)(66946007)(16526019)(53546011)(66476007)(8936002)(6486002)(7416002)(2906002)(31696002)(66556008)(52116002)(54906003)(36756003)(478600001)(4326008)(186003)(31686004)(8676002)(110136005)(316002)(83380400001)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bVMyZmN1U2ZBL0U1SVUvcjd4WnBOWjlwNE5IbnhEb3hZZklLWWZVbEdaTG9Z?=
 =?utf-8?B?UnZoMzRoSU1qcXZtT2w3VmRyUHhoWG1icStuREw2S3k5ZUgrWllxazgzNGZG?=
 =?utf-8?B?L0JCekZCNFRIZzBPelozTWhwZVhEMldOWGhNdUNSUzZYSXV4a0xQMEpQOEYx?=
 =?utf-8?B?cWFseUlVb25teHVJMUxQc1UxQmlxTHBJZy9EdkJCMi9DbTNUTzhjZWZNVnVM?=
 =?utf-8?B?ZE4vWmV5bGlsc1VvUmdiWTVqUnhpTVpnT1BsdUo0a2FJZk4xbExMZjFHSVdL?=
 =?utf-8?B?TEVKS3V2bFNpa3lGZ2dnWnJCVnlaYUFYYWV2ditLcnprcTY3ckFrT0Y2SVo5?=
 =?utf-8?B?S3NWekxldGZrUkpIRlF6V0N3OGdxV0pwbjdva3lYbVZXUzd6WmthVmtiWDU5?=
 =?utf-8?B?Zi9qY00xMWFjZG9TbUk1VnRFd0FVYWlnMlV1T0llckFuK0lUUGlhRXIrR0Rz?=
 =?utf-8?B?WlZmZ05GRUVtWjZvTjBqVEdxcG9tcjZTTmhDWDUrUFVYQmpWRjFtMW1YVU90?=
 =?utf-8?B?S21jUXJEYUN6M0ZoUXdqMWtyQzN0OFZNVDJGUlNVSWFwNjdybWlMTmZOcmhF?=
 =?utf-8?B?K3hic1l3VHRuYkVzdVFQdVB4cUNaaWNrb083eXpyKzhFSXJFcE5lQlBGTlk5?=
 =?utf-8?B?eVE0emxPQTd5QThGWDZtUmtmMSt5QWlLR1VWWmc1QjJyNmJ6OXcwRHUvMUVp?=
 =?utf-8?B?dFY2ZXorQ29WMlRraTdjaVdiVnpmeDBCQ1hvVjFwVEU2aVRpbHRWNkZsODJm?=
 =?utf-8?B?Z0lzK2h2M2ZNd3hTUFowOTJKQzVORGpLTWNHVUloZ3c0OWl3ZnhzTVdDK3V6?=
 =?utf-8?B?QjR4a0xzYmJVNm1kNWV6OHhJNkFLSHl0NGJBRXo2R285c2NobUZQdnd1cTUz?=
 =?utf-8?B?R2ZNaHZWUHlZbnZLVmErbnFETDhSaE1ZMkdYWEVmNFdvelVkRmQ0M1FQL1NS?=
 =?utf-8?B?bTFNRXpUc0tnS1Y5TE4wQlpRb29JazFleW90ZTR1VlBRNlphZVUrSHZHUFE2?=
 =?utf-8?B?LzJwU2Q0c1NCbEgwWlEvYTc4S3VnOENPZVMzOC91QVIwTEFVZHlKYmh3STN0?=
 =?utf-8?B?QTdmTFhpTXF5VTdTY0lQczFUZnhCSlNtSHhWYlBoWnhHb3FaVGUxV3o5a3J1?=
 =?utf-8?B?QlpHemtRYXU5aDRycjNjSDFML0p3VW5hcGhkelI1SHdnN0dUMXhRdFRrelFY?=
 =?utf-8?B?UHVaQWdYUlpuajZYeXd5czVVaDRZbFhYMi81eVRGRTNWRkFSbmFZNkJUVEZT?=
 =?utf-8?B?ZjV5RG16SWpLSzl0a2lQcFlUdVowTlNzUGJuVzFMREJEVUJBYTlkRmI5L0hT?=
 =?utf-8?B?Z0hGQ3FOUmI5a2ZMVkt5ZnI4RlA2czcwL1daYllNQ3loMVhlRm9OQS9mS012?=
 =?utf-8?B?ZXcyWHhSd1pHNFE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 16:12:08.2928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c216e4e-d2ba-4c3b-858b-08d89acad8ca
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VfgL+Do2v1/0Lw/ecmm0DKVvYTE6lOlkXqZss8CA+qBxQ81F1wXFl6GLGYamRANa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2568
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_11:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 adultscore=0 mlxlogscore=864 bulkscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070103
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/7/20 4:37 AM, Lukas Bulwahn wrote:
> __htab_map_lookup_and_delete_batch() stores a user pointer in the local
> variable ubatch and uses that in copy_{from,to}_user(), but ubatch misses a
> __user annotation.
> 
> So, sparse warns in the various assignments and uses of ubatch:
> 
>    kernel/bpf/hashtab.c:1415:24: warning: incorrect type in initializer
>      (different address spaces)
>    kernel/bpf/hashtab.c:1415:24:    expected void *ubatch
>    kernel/bpf/hashtab.c:1415:24:    got void [noderef] __user *
> 
>    kernel/bpf/hashtab.c:1444:46: warning: incorrect type in argument 2
>      (different address spaces)
>    kernel/bpf/hashtab.c:1444:46:    expected void const [noderef] __user *from
>    kernel/bpf/hashtab.c:1444:46:    got void *ubatch
> 
>    kernel/bpf/hashtab.c:1608:16: warning: incorrect type in assignment
>      (different address spaces)
>    kernel/bpf/hashtab.c:1608:16:    expected void *ubatch
>    kernel/bpf/hashtab.c:1608:16:    got void [noderef] __user *
> 
>    kernel/bpf/hashtab.c:1609:26: warning: incorrect type in argument 1
>      (different address spaces)
>    kernel/bpf/hashtab.c:1609:26:    expected void [noderef] __user *to
>    kernel/bpf/hashtab.c:1609:26:    got void *ubatch
> 
> Add the __user annotation to repair this chain of propagating __user
> annotations in __htab_map_lookup_and_delete_batch().

Add fix tag?

Fixes: 057996380a42 ("bpf: Add batch ops to all htab bpf map")

> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Thanks for the fix. LGTM. I guess either bpf or bpf-next tree is fine
since this is not a correctness issue.

Acked-by: Yonghong Song <yhs@fb.com>
