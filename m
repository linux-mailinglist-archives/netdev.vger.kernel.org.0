Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E12205544
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 16:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732985AbgFWO4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 10:56:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18334 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732853AbgFWO4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 10:56:54 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NEsUxl026216;
        Tue, 23 Jun 2020 07:56:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=C5ioo7O14/Ay2mw0MUimmpkCkWlkZg+Iv4GkGUf2tno=;
 b=Ca60w2i55LTmAXvEh49G5DGgO6kvrAbJw2yztp4Di6BbOCe9JKf2RjPLUfcY+71uYoxJ
 XxTmB1hM3kLHzCUwaLs1+M61Dg7SmMUfbK0ImpH6RFz4C9dwzXRboM0Zy03orIY1lODi
 /ZBPXejYpJ4qmlH281buqofCbp8AEH+emrE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31uk2089pb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 07:56:41 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 07:56:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bQZNyOW+0kj5RAVMPQsxgj0H1sQrk7ISmWOcJbZirvJV5ESinqTRsU/uLIUGns8aLDyr/CCPFOTc0q6BbUmaukQBBcnj3xPPrvsGBeU3VPbXm0RRO7hmedoELEdAIqlh2Ik0QBJboWU8PZQfX0R9AOEZkos3XrJ32s3j44NySRUMiJW9YwGneyxKNvcdvGZ0ZptuR7X26qorL8LhwVw0FmgvOXiY8p/s48CQE7EY+9/cDy9cEdAgKW45yzk0i3jRXmLj96WiOaKLW+VdGzV95r0ZV8FVWGh3QvCJgnZWrVlXKGkbd6hEzaBQ9EE6J/e3ZvoAd615ruBm8hL6T+sA/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5ioo7O14/Ay2mw0MUimmpkCkWlkZg+Iv4GkGUf2tno=;
 b=YooCMCe768SD1MuIGQOyXHRGinIiLQUCMZk0KE11q6aVPKYdKvXH/wss9Y7yBDTyI3LYEsTwb8qmhHTjnm+cZB7v45ZO8PJ1UlQkmwa9R4zHdlFSCHauzZIwujPZd9vehMdNhHJA3poXx36wSK934+nhToBeGIqC+9+aM5prTRsvelp642S+f2CUVSv7KnqtrJ+obOCecAfuzr//R2nDblA75Z2cdPwQD1TONRFYzYYEyedHR1/HQVRbLmblqTBw1KSIrVHH6QKrTpzj/ujyK4VW5EqHUuO51ImLsGzCPcqQxAzdfk6kt3nHe/6vbI8d1/mrfjgTPGZwq1xvSpQ5ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5ioo7O14/Ay2mw0MUimmpkCkWlkZg+Iv4GkGUf2tno=;
 b=RLMxdOEKZbC1pIanMEbGVgUZOuznDqMCuozdibj7SUnUS0LISDLFGP+VBhqRmK2Jbogk0UxeHYNpsQhg3c5dXtAN3SBOMKGXVin58/gkG3AyLBU7YEnfNUFUaukVcsXrhykXg0ZXcTOL9xLZkGI2vDMunfA9BZs3R+OE8VyscMw=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2950.namprd15.prod.outlook.com (2603:10b6:a03:f6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Tue, 23 Jun
 2020 14:56:37 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 14:56:37 +0000
Subject: Re: [PATCH bpf-next v3 11/15] tools/bpf: refactor some net macros to
 libbpf bpf_tracing_net.h
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20200623003626.3072825-1-yhs@fb.com>
 <20200623003638.3074707-1-yhs@fb.com>
 <CAEf4BzYaEb+2uhQ4MaLAttibTE8HCAbRqFaQjSs-yyx8kxROuA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <1d8d77e5-fc5f-7e8e-8079-419e4dc56082@fb.com>
Date:   Tue, 23 Jun 2020 07:56:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <CAEf4BzYaEb+2uhQ4MaLAttibTE8HCAbRqFaQjSs-yyx8kxROuA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0012.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::25) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1377] (2620:10d:c090:400::5:7789) by BYAPR05CA0012.namprd05.prod.outlook.com (2603:10b6:a03:c0::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.10 via Frontend Transport; Tue, 23 Jun 2020 14:56:36 +0000
X-Originating-IP: [2620:10d:c090:400::5:7789]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33fa6f2d-d88f-4ee2-0fdf-08d81785a0e5
X-MS-TrafficTypeDiagnostic: BYAPR15MB2950:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2950AE0EEB85EA127C28E9D7D3940@BYAPR15MB2950.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KGo+BLV4liZRbrzFrHzobpDdpnZ89c8CdXZ3uiaAcGzAwe6VUrp/bl/o5BnXb4KcPf2MN/+yYGrf45iXksWQzCH6OVz3jNiiJfo6tNi857N0X/HYEbE0lrjH7PKgU0e1lqlUqe9QATV8+4PN31sBuliYS6txVexmm7UhgfBfMCRB+TKXtGDJzzg76Kdx4ey+pRfvlyT8lUd2+SCgDBSl//nEwLILBQg77XzyQ+n/jflsfDdNVB0YP+ANN95NJirqvkeVQn3weyp6vIxummXxKpfwffgbhdCnsuUEDheLuBj9MpgkYj+u+0za5bMNugWjoyfMPMHTw8CH5TeiXZ1kfgJYcZades1bNe2xxNGKevtXz9QCjf1cHvFrZYcjjC8r
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(39860400002)(346002)(136003)(376002)(36756003)(83380400001)(6486002)(16526019)(2616005)(2906002)(6916009)(52116002)(53546011)(186003)(4326008)(31696002)(66556008)(66476007)(316002)(54906003)(86362001)(5660300002)(66946007)(478600001)(8936002)(8676002)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ymVKhj4Xfz1oWiUbRbZI0Te4ZVJKBdUdC9leMqsbClYHWQYJeUnm+nBzipLN4cFK/+XdQf0b2DjL7dp/N4kuDGGvF3bkwwHTpTtnQ0HGPPRQW8DYyU1geaQ4X/nQYd2wV2QM95z9fw0SPYSt9A4LrCIkEV8uOMBEdehRuwehDD1H9vWFbulVK8z66r4waPaRRjoNKvq9A4i2g0+PxcoGW1do+GK3+/St8FUs68hvWcgFo0FeYYStqq4gSVvqLdsXbDeco0bF8MIdsDlB6Wd0YkAAmPIhph6Wm0F3yhmfmAPz5kll/I1gHxU00zQRni8nkZVRpMlei1x2XL1QlkX/yBsEw3Z45+b3XlN5NKCkPJDzQ9sY925mpwJ3O9x1nk79Gj6XKfH9bKDxcMzGfA9IIeQJJpHSDg7eOIsuB78uks9DH6MDbORLkkrptUjY8Mn0KlVAZJrlHRCJKEy0Ti8Ld3toS8qdQVRf+83cO0VGO60b3+kCbqUmU1Xr2nTyfh4N2tLc1oE38gdz2vKfpcy5tQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 33fa6f2d-d88f-4ee2-0fdf-08d81785a0e5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 14:56:37.2159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 379F6jbnFbAWX5nrusSJ8PJGcej5COMF77RShSnpRQlLxgnPtIy692y4k7fYzsIQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2950
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_07:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006120000 definitions=main-2006230117
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/22/20 11:45 PM, Andrii Nakryiko wrote:
> On Mon, Jun 22, 2020 at 5:38 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Refactor bpf_iter_ipv6_route.c and bpf_iter_netlink.c
>> so net macros, originally from various include/linux header
>> files, are moved to a new libbpf installable header file
>> bpf_tracing_net.h. The goal is to improve reuse so
>> networking tracing programs do not need to
>> copy these macros every time they use them.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   tools/lib/bpf/Makefile                           |  1 +
>>   tools/lib/bpf/bpf_tracing_net.h                  | 16 ++++++++++++++++
>>   .../selftests/bpf/progs/bpf_iter_ipv6_route.c    |  7 +------
>>   .../selftests/bpf/progs/bpf_iter_netlink.c       |  4 +---
>>   4 files changed, 19 insertions(+), 9 deletions(-)
>>   create mode 100644 tools/lib/bpf/bpf_tracing_net.h
>>
>> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
>> index bf8ed134cb8a..3d766c80eb78 100644
>> --- a/tools/lib/bpf/Makefile
>> +++ b/tools/lib/bpf/Makefile
>> @@ -257,6 +257,7 @@ install_headers: $(BPF_HELPER_DEFS)
>>                  $(call do_install,bpf_helpers.h,$(prefix)/include/bpf,644); \
>>                  $(call do_install,$(BPF_HELPER_DEFS),$(prefix)/include/bpf,644); \
>>                  $(call do_install,bpf_tracing.h,$(prefix)/include/bpf,644); \
>> +               $(call do_install,bpf_tracing_net.h,$(prefix)/include/bpf,644); \
>>                  $(call do_install,bpf_endian.h,$(prefix)/include/bpf,644); \
>>                  $(call do_install,bpf_core_read.h,$(prefix)/include/bpf,644);
>>
>> diff --git a/tools/lib/bpf/bpf_tracing_net.h b/tools/lib/bpf/bpf_tracing_net.h
>> new file mode 100644
>> index 000000000000..1f38a1098727
>> --- /dev/null
>> +++ b/tools/lib/bpf/bpf_tracing_net.h
>> @@ -0,0 +1,16 @@
>> +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
>> +#ifndef __BPF_TRACING_NET_H__
>> +#define __BPF_TRACING_NET_H__
>> +
>> +#define IFNAMSIZ               16
>> +
>> +#define RTF_GATEWAY            0x0002
>> +
>> +#define fib_nh_dev             nh_common.nhc_dev
>> +#define fib_nh_gw_family       nh_common.nhc_gw_family
>> +#define fib_nh_gw6             nh_common.nhc_gw.ipv6
>> +
>> +#define sk_rmem_alloc          sk_backlog.rmem_alloc
>> +#define sk_refcnt              __sk_common.skc_refcnt
> 
> Question to networking guys. How probable it is for these and similar
> definitions to ever be changed?
> 
> I'm a bit hesitant to make any stability guarantees (which is implied
> by libbpf-provided headers). I don't want us to get into the game of
> trying to maintain this across multiple kernel versions, if they are
> going to be changed.
> 
> Let's for now keep bpf_tracing_net.h under selftests/bpf? It's still
> good to have these definitions, because we can point people to it.

I am using bpf_tracing_net.h name to somehow signal that it may
*potentially* change. But it does have long-time stability issue.
Will move to selftests/bpf then.

> 
>> +
>> +#endif
> 
> [...]
> 
