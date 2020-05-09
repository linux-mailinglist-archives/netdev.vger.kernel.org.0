Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4A91CBDBB
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 07:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgEIF1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 01:27:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17428 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725795AbgEIF1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 01:27:12 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0495PqwW030933;
        Fri, 8 May 2020 22:27:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=tPsqFZnVl03Beov1sBufQQ5KlFhtdZfZ47hvSuRMw0w=;
 b=Zazxgbw7nsdrq3Yu8CPPEHBZCyLrmt4JM1ic5wNYMNdk6o07aWjl3wUFtJCp90tuQi1l
 44MalofJz1m8g+VJzJ6eiVIPNglg8JeyEjD6WgBBu7whZ2/G0mqlIB0SVqVFeQj+ve06
 jrF2hSyktXSP4SCxqhXtiY9irEQY8Hpw1Cg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30wet4a5rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 May 2020 22:27:00 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 8 May 2020 22:26:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AX1lSOEwQlnfymeeCxu1a1J/+tgCFkEo8Guri5v3cXMR7e3AVmMOCHVjVwa402/0dou0lDsmcX9zths/jpHOORea5nzYtfn+O/TKn2aRkAWZGcA6VKDpFm2DuE8N1DM5d0zC2iReRIJ4T5l5lMCFn3G/wkRVXw6TQsvEpsAQazR84b5seBieRhVhA++gw0DuclZJ9Jpp4umn+SvUjQLQ/YJdlGy3uBAf9T36gvonNEeEpIXcNxTtKw6c+2zuBtb91JNLvuCb7gZEiVxg9gh5A06E3OtFTgf36J7QQVNecIztlHotO9eRon01rBVwdoUidA0cwubk5n6gQA1u4uyXsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tPsqFZnVl03Beov1sBufQQ5KlFhtdZfZ47hvSuRMw0w=;
 b=oWS9NO5amHNUiNnO8FKlLIuXUx1YecK8nUHdKJCdYtzcX9qjDnnK492ATXKRZDTH/hJ9J8HlNEpCHwxepXKYcUMUYh92F25ZeJ98YcB1EwvJcGi/+KhK3M/bLLpIg+UShzGybTc+xhyCkKgZ2wzAXVgFboPnjzmOlh0034VhLR2SYTSal4GzcHylkq0suXHPFt1GGkC1gB6rCqca7CzLrhGF90PIsvnkHr1+5cAV8PYtfZo/ewLRKEUzVhLgtrSA0r7QWtJOwjRBbzUp8tcbeIcXm/VmTuZpKZmDAOA7GliQvkD4Z2TkwQ0a+zYCdE2isCZsyeocV6vyJXyUsM1D5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tPsqFZnVl03Beov1sBufQQ5KlFhtdZfZ47hvSuRMw0w=;
 b=MbGPzKOtAtsrL+jWpt8u79JuIsqxtcXynzo8F25l0X2fmTtJ1/u7EOoJ8ILEovEgJli5zsobhhrZ5PRXaIOXR+PKKdtdtxoX6OAUkcFRergbK81rYB6qsCqw/4BKBRmqeIihM/D8G1hG1xm/JlYbBWHSmP/XniPqQZh9inslrE8=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3288.namprd15.prod.outlook.com (2603:10b6:a03:108::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.33; Sat, 9 May
 2020 05:26:52 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.035; Sat, 9 May 2020
 05:26:52 +0000
Subject: Re: [PATCH bpf-next v3 18/21] tools/bpftool: add bpf_iter support for
 bptool
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200507053915.1542140-1-yhs@fb.com>
 <20200507053936.1545284-1-yhs@fb.com>
 <CAEf4Bzb1VJj5gWvL0Jiip8P9KhSfT6seCRH8N7Q49Fw3_jNOGQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <1ea0a61f-5400-0bb7-c063-0e2adf18a6bc@fb.com>
Date:   Fri, 8 May 2020 22:26:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <CAEf4Bzb1VJj5gWvL0Jiip8P9KhSfT6seCRH8N7Q49Fw3_jNOGQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0023.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::33) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:a70f) by BY5PR04CA0023.namprd04.prod.outlook.com (2603:10b6:a03:1d0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Sat, 9 May 2020 05:26:51 +0000
X-Originating-IP: [2620:10d:c090:400::5:a70f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a92987e-b4ad-4a33-2a40-08d7f3d9946e
X-MS-TrafficTypeDiagnostic: BYAPR15MB3288:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3288575DFEDA40A612A9981FD3A30@BYAPR15MB3288.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BqYnjS255XV+go1QkJR1In72Sv7XfdkfjWMvodxSlGg8ThXoiUuQ3pHUHkLRLLdN137TKYnrRSn/nwazzhXOEaSGA3UARqCJJjh9P+d/wwPNvKKNwVO/zXcAnXSdK0k7P6J2Us41dFzcU1jXWuMr5kft2YVf780rYSJPf/KPIVDfNfgUb1OiLqRdLEN1w+gdXZbnFEXu3EukZySx5BEExfipK09GNHfdiO8GphB+0vEQ83x8CnNhbyCoaDJhdPQrNeexI5ZQahtKi2YnN7tzHDJa5yVS4Sr1s5xcnnvL4jySIh7TaqIKZITbPd4mrvcCWbBUAj6+AAvJaYaWOMJQeoacwPFeTIFHSY2MQIVfa/j5fb6NKQpj4nALlgQPNXuGHeUIhK6OdXQZWhtINSRCMWqpkSl6KLZALuzdCTY3706kNs5hufvvy7kIBN/4d3Evqy0trpaheoidCvy5QaKekeqxj3MggFeXpsgaNCClMFB9rjnkQ1aFZeKvkoofZx5R1hTII/zTYwgmRE6hqkqkWPACKcNAzRbrtdNqvUuF/Yrl8fWiTRMs5dR0ztmTyuRk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(39860400002)(136003)(366004)(346002)(33430700001)(316002)(8676002)(36756003)(6512007)(5660300002)(86362001)(6486002)(54906003)(2906002)(52116002)(66476007)(66556008)(6916009)(186003)(478600001)(31696002)(16526019)(33440700001)(6506007)(2616005)(53546011)(66946007)(31686004)(8936002)(4326008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: HkU2IGh8OYSVvaRwk3wYQNdhNDny8zf8VsgKC3MXTmq6x8iSSq8L7yltTX0JRAEOzZd389iCY+1GVCxVJHgAFDntmPuQfKGFsC8ODP0HHnlGw/Zn357HU3mSRWTiBJTHvHSLdmq5MmQctxw/ztRmFkU63/g2nXUU/HsVX9b/4KJUM6maJUfbRa4d0XTvG3BspRD84AABuue0ILD1dAs7fM028KO1a0a8RGzsEr6G9VlU02b8xDjk+azaPlsKFvoOf9wCsrBv/JRTRHZ4v+ajN8zAsNCgy278AG/HtvyQh/F4nWTlehKpH/Ui1NFp+7RAUSx1LWrFlZS8o9H2bmfukxJXyAp+lJp9Mo3RhL1bSe+lGDKiKlU+loW6EUVZD0iIeJ7Dl2+pTw39F5aqnl2n/yVO3uEmjB2vkdjm1YoNpWSMcUZ5iQZ5LzlYWdzEV/FAacjKcDzvJHyb++zU8d93jVgmUOqpU5qQPycbIO6F7tqaYOqARWs78UVSkHKAXPM3OEMOD71wBBT8BSAO8BASmA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a92987e-b4ad-4a33-2a40-08d7f3d9946e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 05:26:52.2423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qfvTUA8yITXl0c75O6z0qI9y7vnR21DUwCy9UHUWNXeCQWV8DSDCIeOrMNvTrE/T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3288
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_01:2020-05-08,2020-05-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090049
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/8/20 12:51 PM, Andrii Nakryiko wrote:
> On Wed, May 6, 2020 at 10:40 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Currently, only one command is supported
>>    bpftool iter pin <bpf_prog.o> <path>
>>
>> It will pin the trace/iter bpf program in
>> the object file <bpf_prog.o> to the <path>
>> where <path> should be on a bpffs mount.
>>
>> For example,
>>    $ bpftool iter pin ./bpf_iter_ipv6_route.o \
>>      /sys/fs/bpf/my_route
>> User can then do a `cat` to print out the results:
>>    $ cat /sys/fs/bpf/my_route
>>      fe800000000000000000000000000000 40 00000000000000000000000000000000 ...
>>      00000000000000000000000000000000 00 00000000000000000000000000000000 ...
>>      00000000000000000000000000000001 80 00000000000000000000000000000000 ...
>>      fe800000000000008c0162fffebdfd57 80 00000000000000000000000000000000 ...
>>      ff000000000000000000000000000000 08 00000000000000000000000000000000 ...
>>      00000000000000000000000000000000 00 00000000000000000000000000000000 ...
>>
>> The implementation for ipv6_route iterator is in one of subsequent
>> patches.
>>
>> This patch also added BPF_LINK_TYPE_ITER to link query.
>>
>> In the future, we may add additional parameters to pin command
>> by parameterizing the bpf iterator. For example, a map_id or pid
>> may be added to let bpf program only traverses a single map or task,
>> similar to kernel seq_file single_open().
>>
>> We may also add introspection command for targets/iterators by
>> leveraging the bpf_iter itself.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   .../bpftool/Documentation/bpftool-iter.rst    | 83 ++++++++++++++++++
>>   tools/bpf/bpftool/bash-completion/bpftool     | 13 +++
>>   tools/bpf/bpftool/iter.c                      | 84 +++++++++++++++++++
>>   tools/bpf/bpftool/link.c                      |  1 +
>>   tools/bpf/bpftool/main.c                      |  3 +-
>>   tools/bpf/bpftool/main.h                      |  1 +
>>   6 files changed, 184 insertions(+), 1 deletion(-)
>>   create mode 100644 tools/bpf/bpftool/Documentation/bpftool-iter.rst
>>   create mode 100644 tools/bpf/bpftool/iter.c
>>
> 
> [...]
> 
>> diff --git a/tools/bpf/bpftool/iter.c b/tools/bpf/bpftool/iter.c
>> new file mode 100644
>> index 000000000000..a8fb1349c103
>> --- /dev/null
>> +++ b/tools/bpf/bpftool/iter.c
>> @@ -0,0 +1,84 @@
>> +// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +// Copyright (C) 2020 Facebook
>> +
>> +#define _GNU_SOURCE
>> +#include <linux/err.h>
>> +#include <bpf/libbpf.h>
>> +
>> +#include "main.h"
>> +
>> +static int do_pin(int argc, char **argv)
>> +{
>> +       const char *objfile, *path;
>> +       struct bpf_program *prog;
>> +       struct bpf_object *obj;
>> +       struct bpf_link *link;
>> +       int err;
>> +
>> +       if (!REQ_ARGS(2))
>> +               usage();
>> +
>> +       objfile = GET_ARG();
>> +       path = GET_ARG();
>> +
>> +       obj = bpf_object__open(objfile);
>> +       if (IS_ERR_OR_NULL(obj)) {
> 
> nit: can't be NULL

Ack. Will change.

> 
>> +               p_err("can't open objfile %s", objfile);
>> +               return -1;
>> +       }
>> +
>> +       err = bpf_object__load(obj);
>> +       if (err) {
>> +               p_err("can't load objfile %s", objfile);
>> +               goto close_obj;
>> +       }
>> +
>> +       prog = bpf_program__next(NULL, obj);
> 
> check for null and printf error? Crashing is not good.

Make sense. Will change.

> 
>> +       link = bpf_program__attach_iter(prog, NULL);
>> +       if (IS_ERR(link)) {
>> +               err = PTR_ERR(link);
>> +               p_err("attach_iter failed for program %s",
>> +                     bpf_program__name(prog));
>> +               goto close_obj;
>> +       }
>> +
>> +       err = mount_bpffs_for_pin(path);
>> +       if (err)
>> +               goto close_link;
>> +
>> +       err = bpf_link__pin(link, path);
>> +       if (err) {
>> +               p_err("pin_iter failed for program %s to path %s",
>> +                     bpf_program__name(prog), path);
>> +               goto close_link;
>> +       }
>> +
>> +close_link:
>> +       bpf_link__disconnect(link);
> 
> this is wrong, just destroy()

Will change.

> 
>> +       bpf_link__destroy(link);
>> +close_obj:
>> +       bpf_object__close(obj);
>> +       return err;
>> +}
>> +
> 
> [...]
> 
