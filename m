Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6201D38EA
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 20:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgENSKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 14:10:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26654 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726075AbgENSKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 14:10:54 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04EIAHDX004248;
        Thu, 14 May 2020 11:10:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=sTUU4xhSqx1+sEHn+PWqd2n7CkKCgLN5txs2L4Anmms=;
 b=VcstSkwYZv7m5F7+Qn+etjVIrgLaWkdpG9SQF3xhnofSKyKAMDiGUajjf63/uzKBzf8s
 c+SgP7IGWDugPdn7S/AAOPMdocfpZ+3OZFr6PvnwMavId47+7wNP56jbVFbe+nFtgM4z
 oqdbNT/8WADpAzr+QEbsgKu0l3UW23TX3UU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3100xhd1rt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 14 May 2020 11:10:37 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 14 May 2020 11:10:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QsqtX2v7U+XqY3e6syMUd+Bsz4/57v9+eVz+UvepWBuSZnRgYTRVoSQQ0wlPLYjLSJAf3PrUy9WTdIe0x3UQiMB6T/wizZA4CHPQcC4O8EHW85Flcn5eXE51oQCG/nhwWno0QaQsCWJr7zbqrTkgQ7c16iOM1wIl0vdzEiB8u1BgQ6dDHzXtRDybojio43OYJLpOmi49ZVJ1gPeooCYIjSNi9pCblQrGZEA1lKdjt4J8nb1iV6P3HQSy3x2YJKT82n85tiuLhXFzIoHFE9s4iZ2YCJCOs6fcTZjtRyvNn0JNXjhZWwHl1RKy+gmfBOs7V8Minjv85wrZl5iH0d2aXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sTUU4xhSqx1+sEHn+PWqd2n7CkKCgLN5txs2L4Anmms=;
 b=OrF0xAMEjolMbUfLdsccWLcEq3BZuSOsAT+Qxst1J4a6LhyfhpgFBkxbeWvLbzIPOeuWBvZoGbhIl5awKxiCaAawnZLsGYowXnrag9zMcHMd4UDXmIM1hM5oMopROKA78UIqA9CHHR+tghKJ6UhVcvoY1fyqerk25TOahdVrkjAetPaNSiRcnOzmXfHjBdWtKXGXTK/fHtyLRrxjKV2w6EQpFd7qpE/N1QQJS3+z2pqhBcp/O9EyrZqianzDpqMxMwGPT6SDCZbzfAynLlHf6etxHiAkTDzjCO/ZVbDOuNZZFWkvJ+xFGoMx4j2POhrD8SF41qWJBnoc/vxR3TR2zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sTUU4xhSqx1+sEHn+PWqd2n7CkKCgLN5txs2L4Anmms=;
 b=jQwntLOQ+k0M63VrjPQo8DsGDtQtdLrjvw0fuk4DTGAHaMG+/uxDSP/zEnvN0zE4SpW1Jx3jqUYYVRf2l5AkF3gdltq4jTX0gsVxHtjgFUnfnAqkr18z/G9bHGPN4tOiD4F+wvin1dL8ez7qka4Cd9NMs1HG8EKMeGP0YCH5fyk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3318.namprd15.prod.outlook.com (2603:10b6:a03:106::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26; Thu, 14 May
 2020 18:10:34 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3000.022; Thu, 14 May 2020
 18:10:34 +0000
Subject: Re: [PATCH bpf 3/3] bpf: restrict bpf_trace_printk()'s %s usage and
 add %psK, %psU specifier
To:     Daniel Borkmann <daniel@iogearbox.net>, <ast@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <torvalds@linux-foundation.org>, <mhiramat@kernel.org>,
        <brendan.d.gregg@gmail.com>, <hch@lst.de>,
        <john.fastabend@gmail.com>
References: <20200514161607.9212-1-daniel@iogearbox.net>
 <20200514161607.9212-4-daniel@iogearbox.net>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <34e9da6e-1f1e-30c2-5863-55f7d8506eb8@fb.com>
Date:   Thu, 14 May 2020 11:10:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200514161607.9212-4-daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0064.namprd07.prod.outlook.com
 (2603:10b6:a03:60::41) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:3bff) by BYAPR07CA0064.namprd07.prod.outlook.com (2603:10b6:a03:60::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Thu, 14 May 2020 18:10:33 +0000
X-Originating-IP: [2620:10d:c090:400::5:3bff]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1968a440-44bc-4237-a923-08d7f8321884
X-MS-TrafficTypeDiagnostic: BYAPR15MB3318:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3318B008B219ADBA8D66BDD7D3BC0@BYAPR15MB3318.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:108;
X-Forefront-PRVS: 040359335D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cGU9w0BD3V4PqmLvEGVazAYSnUdXby5JQcMXPHXfNiuubBjIjOo9a+bJ0sPqBcpB/fPIgoTlSJTuHsNn6nFPAAKlbd6wrVyGtk39wRygGB3VRkE/81nE5IYk46utXA+qvFAuX32owuY5Jg3lrDKNnC4Ij2rCDHxsPKDuq+/UDBOTi0thpmORB7xZ3f/TJUAoTJ4rFb+NqBE7gPvzjoFX7uYp98QexsL2E0FBdtBbRiH0+qORTeDJhddlOiFCoapmxAvaf0MkLnUSc5NuLnnIq4/DINVbBn2rpauYkTPtnz0qJemAdXHgG/CIdhVgzerJqR8C+D3gTnUcnKTj4F0n6+yBSx+9vyPXtoCJbyG48uBeVCxwhZ9Tsy8U5DFckJRhUZ/DehbZRpTtWIyJheWDJ7FOBn8CkJus4vibLiJ1uf8Jrzo3IO27HGz8F6d7JE6sry3B1RQ+mt2++vsHrI3ljfonlIAi0631mcM3tx9afmm4KTHU+lQMQCjeSoA9COLkV+Yn1wmIZlNa+XnaMUG7OzsT7oyyBtMiJJrfM1ZzWa7ySSKe7EgTuP1wdbt9DsEeeD1szsWil1LVUGgTL5PQJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(396003)(376002)(39860400002)(366004)(136003)(8676002)(6486002)(66476007)(66946007)(2616005)(66556008)(31696002)(2906002)(316002)(31686004)(4326008)(6512007)(478600001)(966005)(8936002)(52116002)(16526019)(5660300002)(36756003)(186003)(86362001)(53546011)(6506007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 44HQWrHHg+Gb5++CcZRq4l75/V0y0TQWEaMBSGjRak3id3L5NMT5hyMyxteY23OCpC7kmvfgn6WjDwuy7y6rJFN5BDHdqzV4rdSuNUzm1/rH+1garwER5WSCtO0DYD4Z00l8i9NL63wg6FD3NdlQ+24oQpyqZ7XGE1Bt5uVYksPAtmAhBgXdmjqnoqCNfs3vJkoq679bC6/+nwof20LKANzLCoSy90ZVQgBnryBKp681rkg9gQZAcnAr5Xk5aiwE5kuIn+g1jl/1NJYeiT0cLJaRTc+hOWYVnjVqSBfsJ88xxO8WULeJp+afaDBfror8HsWet9zY/OBsY3bSpeLcuVj9dsI9qlyvg6YsosoIUkxzySUih7ll0hLbzpn0KFTzkSAPTCrEyUVB0I+2v4/SD9utWnnvXoyP7W5rfwF/YnPUZJQxduUvnt+rOZVHKXtznvPUXQv/LFl4K4YtunkTIYwerdl/IYeb7pmH2JoM1K/YfCWH1kZg/rJqcnnBxgLbW+nYLOAEvPxPArKmL5PNDg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1968a440-44bc-4237-a923-08d7f8321884
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2020 18:10:34.1383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VX0nkghR9UmsCjPpdbwoH6aTN/92gpraHp/eLEys6UY+qChJXahqyibLzocB+sn5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3318
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_06:2020-05-14,2020-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 cotscore=-2147483648
 mlxscore=0 priorityscore=1501 adultscore=0 impostorscore=0 malwarescore=0
 spamscore=0 clxscore=1015 suspectscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005140161
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/14/20 9:16 AM, Daniel Borkmann wrote:
> Usage of plain %s conversion specifier in bpf_trace_printk() suffers from the
> very same issue as bpf_probe_read{,str}() helpers, that is, it is broken on
> archs with overlapping address ranges.
> 
> While the helpers have been addressed through work in 6ae08ae3dea2 ("bpf: Add
> probe_read_{user, kernel} and probe_read_{user, kernel}_str helpers"), we need
> an option for bpf_trace_printk() as well to fix it.
> 
> Similarly as with the helpers, force users to make an explicit choice by adding
> %psK and %psU specifier to bpf_trace_printk() which will then pick the corresponding
> strncpy_from_unsafe*() variant to perform the access under KERNEL_DS or USER_DS.

In bpf_trace_printk(), we only print strings.

In bpf-next bpf_iter bpf_seq_printf() helper, introduced by
commit 492e639f0c22 ("bpf: Add bpf_seq_printf and bpf_seq_write 
helpers"), print strings and ip addresses %p{i,I}{4,6}.

Alan in
https://lore.kernel.org/bpf/alpine.LRH.2.21.2005141738050.23867@localhost/T
proposed BTF based type printing with a new format specifier
%pT, which potentially will be used in bpf_trace_printk() and 
bpf_seq_printf().

In the future, we may want to support more %p<...> format in these 
helpers. I am wondering whether we can have generic way so we only need 
to change lib/vsprintf.c once.

Maybe using %pk<...> to specify the kernel address and %pu<...> to
specify user address space. In the above example, we will have
%pks, %pus, %pki4 or %pui4, etc. Does this make sense?

> 
> Existing %s for legacy users is still kept working for archs where it is not
> broken and therefore gated through CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE.
> 
> Fixes: 8d3b7dce8622 ("bpf: add support for %s specifier to bpf_trace_printk()")
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Reported-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Brendan Gregg <brendan.d.gregg@gmail.com>
> Cc: Christoph Hellwig <hch@lst.de>
> ---
>   Documentation/core-api/printk-formats.rst | 14 ++++
>   kernel/trace/bpf_trace.c                  | 92 +++++++++++++++--------
>   lib/vsprintf.c                            |  7 +-
>   3 files changed, 81 insertions(+), 32 deletions(-)
> 
> diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
> index 8ebe46b1af39..76b5f4f265cb 100644
> --- a/Documentation/core-api/printk-formats.rst
> +++ b/Documentation/core-api/printk-formats.rst
> @@ -112,6 +112,20 @@ used when printing stack backtraces. The specifier takes into
>   consideration the effect of compiler optimisations which may occur
>   when tail-calls are used and marked with the noreturn GCC attribute.
>   
> +Probed Strings from BPF
> +-----------------------
> +
> +::
> +
> +	%psK	kernel_string
> +	%psU	user_string
> +
> +The ``sK`` and ``sU`` specifiers are used for printing a string from probed
> +memory. From regular vsnprintf(), they are equivalent to ``%s``, however,
> +when used out of BPF's bpf_trace_printk() it reads a string of up to 64 bytes
> +in memory without faulting. For ``K`` specifier, the string is probed out of
> +kernel memory whereas for ``U`` specifier, it is probed out of user memory.
> +
>   Kernel Pointers
>   ---------------
>   
[...]
