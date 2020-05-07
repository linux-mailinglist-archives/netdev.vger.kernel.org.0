Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B291C7FBB
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 03:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgEGBKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 21:10:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28386 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727929AbgEGBKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 21:10:06 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0470tWua000933;
        Wed, 6 May 2020 18:09:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=0or9S43lxzuR/+GJKKx/Iu/Ox9+KW+6v1Y0r7qydqNg=;
 b=gH5URWmoKe5VjxIEPwOp3GBCzXlFOGfoQHcIj7TXuocajPa+AoraHfgESwtxmTgo0Iam
 SJegBduHMSnVfInBMLoXu8J2R7AW/9YKq8GoXdRymbQ4lDVxn2Bqxy/U8tbDAR5sxVq0
 ZDlWbRhb69tYt/6hGkvDg+tyNVVvkOGQqI4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30s6cmyw7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 06 May 2020 18:09:52 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 18:09:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHqqJ79isZY7xntjRiTQPyPWIKUOJloDspqkm5h8osmqcz26DBTyGECRt6tyo8pPNfgfdT1XhsynrFmbmni69hryKU5UfXI/rMgEc3hhqp7/Ti2AA2flihOwAIN8kCcJEF+Wwm7RKlwsvx8coXzvU26k7SHiKdzU1MOM6Zz9QmPo664dZJMCgfH2b/9I72cgbRGpNTAfnOQk8rYZnou2qZ8EmDAdsq7wNXFTQrxoRng+ZOcQkpt4xwgh209k8JbKYCPyJ1ZdtX0sGZE4gzgBDLhm7ChB5afUtImT52g3zoH3IGPH1t0QyKwAAoDVVCnWgfZBNTUwY7vh4om9qoTaPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0or9S43lxzuR/+GJKKx/Iu/Ox9+KW+6v1Y0r7qydqNg=;
 b=mcoS43vGgxXKt9G9BIY6Yt5yLeuaM96/O1CmmEZPNliHflgGAOoSM87KVDEpRAH1Eduz0QxKf177yPys9oXKdIZ4eTRZMGMoN6AKwvRbpMDyaSnjHpCfzTR1b8uf0aYcS+8yFOvZspMTka/9x+Uiyck5u8+EmKjulmD6cxJJOD0cqLOIr8zvNbZrB6ghbtr2Hi+H5wMHMyeH4CpJP+C8kBLmhGkIEdGO6r4RnLZcW9yq7lIoeMEjG7lwLT4hPbUPlMULE0s9t9CDLXo+eKhtZsOBruUs8iq6PsXblOe4tHgyarbnwhA6sGnTHGuJcDyGzXRUObHUTnelJxNrbCxzlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0or9S43lxzuR/+GJKKx/Iu/Ox9+KW+6v1Y0r7qydqNg=;
 b=aLDV35b1UJg+S0OC7aUcSpqtxdsvDeOclp55MV1G7DLljinaT/v63Yr9oDCHFkRoB8axlP5I80FzTrXUgJ3/OJNe/JthVwqs4ixIMzbpVAvBFqPqgWKvW6Y5Q3/yqdEvHVqA8ux4u0cB1veX82mAXdJJzgEEY24bewmutORSTUE=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2632.namprd15.prod.outlook.com (2603:10b6:a03:152::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.30; Thu, 7 May
 2020 01:09:45 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.030; Thu, 7 May 2020
 01:09:45 +0000
Subject: Re: [PATCH bpf-next v2 18/20] tools/bpf: selftests: add iterator
 programs for ipv6_route and netlink
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200504062547.2047304-1-yhs@fb.com>
 <20200504062608.2049044-1-yhs@fb.com>
 <CAEf4Bzae=1h4Rky+ojeoaxUR6OHM5Q6OzXFqPrhoOM4D3EYuCA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <318a33ef-4b9e-e25c-f153-c063b87b2c50@fb.com>
Date:   Wed, 6 May 2020 18:09:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4Bzae=1h4Rky+ojeoaxUR6OHM5Q6OzXFqPrhoOM4D3EYuCA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::22) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:573c) by BYAPR05CA0081.namprd05.prod.outlook.com (2603:10b6:a03:e0::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.11 via Frontend Transport; Thu, 7 May 2020 01:09:44 +0000
X-Originating-IP: [2620:10d:c090:400::5:573c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fea58408-4f2e-49fc-054a-08d7f223548d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2632:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2632CD1169258FC411A5F51DD3A50@BYAPR15MB2632.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03965EFC76
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qvrHAYjdK4NVEnhdk8luBNXgL+cyvKdS1NXpUO7L8x1KRy6HGKuzgdhnS/r/jYaptY4luc/f/lG+7VVWFBfw4nXmSefB6dY1fIEXx3X8kR03HlXC5mm566jcJAi3wnAn3E0naKuUCjCkP6XVOTeWJpT31hfrXP3xHjRDdFXp3UCdPqtdh0ys8HK7Vno/UdueeipQNgeVrreSICjNdUFRZsawciqQ+ywIaQj7cp8rGH4RWIHZl0Kf7srZlllFzOf9j5qf0AT87qBtU+6JgVoC0qQP9ibcY/RgBb9lbUCi8Vuhqp3d8aNPbj/vdQXEeZyXRjDmv4w/xrnWLAgqiOkGAIM8ZcJq+0dPUXs5cX+5QdAkSn9/yKKb/qQPEfZ7Ur99tD6PNAtefygZHSIgmFih0TOpbzb5eerN155WAx6PD9qQHJ9spqZ0oJ7/8jDZesP6tsxBSITou7W9rya9HqUcVZA6tqGLySGZeA0Lr2Cmrwnw5l5231BhUMpbmoz0GcZ02jJenl2Q/1j+21mBa5I/Svvxd5G/11yLCdrb8Y5lFBTgGTLTbiIB5sk53RbDSo+W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(376002)(366004)(39860400002)(396003)(346002)(33430700001)(52116002)(6486002)(53546011)(66946007)(5660300002)(6916009)(66556008)(16526019)(31686004)(66476007)(36756003)(186003)(6506007)(4326008)(316002)(86362001)(2616005)(8936002)(31696002)(2906002)(478600001)(33440700001)(54906003)(6512007)(8676002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: dsdu3+NpNlcfqghq1s8o/R9UmDgnnL44/32SdnZLhnNup1tBek1KJuMdnOErX/D+8sUlepZw70PiB4Xu3gaUWBzapETCc+LHjScvvz+8Q4C9qy9bQJEoemtPa6odcowiQ9hqqpG+i5xQWqhvkUuFfYBM8eZTigzvinrZ6e2J5/aDZpdZ1ouvRYB1LpvEQL/FlT93D6cfmZ7XpK4Vz8ZIRdJ85A4U8rk4Q6m32DoDKPyOrZYDty+c7q6nhDzjbRdkhC2dg6+tgH41JwEiz9gqnHtRwHlVMB+SgbUjo0lDRKro+gx27O96aR+Tii32w+QAQskgWNTf7vWyETnZ87I2B59zrLFWR00mMry9kQOFGAoKC2zl+dThL2+ppYuVxEWJdhE0rTxCOMAOtncWrU5u5EB7HSb/JfCP9hYbQT2A4qX+XQeK2tGPeiNKay387B9qbKHJtk6l/DPCb794rLDOyo/mUwU1UXngmhqNv9gWjKj0SD6nzOZN0l5wJ0INjgmfuwcswgvGOK6yQSLugiAt4PeqcB+Xq42K2S2G6j2izrpJEUsnPFmLK4j/Zbu+hTaR7blt8++Cgw/d2a9X18tRagHEp2qVyK3UDZG09MtCvaMwKp7spKQjjUsvAXQB0kC4UMX6VLD0PFRdFbRMBymWfdnjsHumfIjVqW5s1d9LupfmCdBwGpiHBgjaZJQXqV+Vn9aeSYeoXVIE2h0Y07qGNT6V3ZmXPOd7+lKXK4mzxqqCfsu86RlzfO2Ip6NDMvkizpGHbiF7eDvO57C612bdTKGSAgbtBtbQ4ganvsm7iW0DCqKZlPVwoDzvoksx4UDuaemqY4LkPweeUOEmKO79Rw==
X-MS-Exchange-CrossTenant-Network-Message-Id: fea58408-4f2e-49fc-054a-08d7f223548d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2020 01:09:45.6087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3JpnSDwEEQ1OH2C28D7VdB0QXwFeFrvz+2bsl1WD5+hrL4PqjCtnB35seOLu5ix8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2632
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-06_09:2020-05-05,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 phishscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005070004
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/20 11:01 PM, Andrii Nakryiko wrote:
> On Sun, May 3, 2020 at 11:30 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Two bpf programs are added in this patch for netlink and ipv6_route
>> target. On my VM, I am able to achieve identical
>> results compared to /proc/net/netlink and /proc/net/ipv6_route.
>>
>>    $ cat /proc/net/netlink
>>    sk               Eth Pid        Groups   Rmem     Wmem     Dump  Locks    Drops    Inode
>>    000000002c42d58b 0   0          00000000 0        0        0     2        0        7
>>    00000000a4e8b5e1 0   1          00000551 0        0        0     2        0        18719
>>    00000000e1b1c195 4   0          00000000 0        0        0     2        0        16422
>>    000000007e6b29f9 6   0          00000000 0        0        0     2        0        16424
>>    ....
>>    00000000159a170d 15  1862       00000002 0        0        0     2        0        1886
>>    000000009aca4bc9 15  3918224839 00000002 0        0        0     2        0        19076
>>    00000000d0ab31d2 15  1          00000002 0        0        0     2        0        18683
>>    000000008398fb08 16  0          00000000 0        0        0     2        0        27
>>    $ cat /sys/fs/bpf/my_netlink
>>    sk               Eth Pid        Groups   Rmem     Wmem     Dump  Locks    Drops    Inode
>>    000000002c42d58b 0   0          00000000 0        0        0     2        0        7
>>    00000000a4e8b5e1 0   1          00000551 0        0        0     2        0        18719
>>    00000000e1b1c195 4   0          00000000 0        0        0     2        0        16422
>>    000000007e6b29f9 6   0          00000000 0        0        0     2        0        16424
>>    ....
>>    00000000159a170d 15  1862       00000002 0        0        0     2        0        1886
>>    000000009aca4bc9 15  3918224839 00000002 0        0        0     2        0        19076
>>    00000000d0ab31d2 15  1          00000002 0        0        0     2        0        18683
>>    000000008398fb08 16  0          00000000 0        0        0     2        0        27
>>
>>    $ cat /proc/net/ipv6_route
>>    fe800000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000001 00000000 00000001     eth0
>>    00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>>    00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001       lo
>>    fe80000000000000c04b03fffe7827ce 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
>>    ff000000000000000000000000000000 08 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000003 00000000 00000001     eth0
>>    00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>>    $ cat /sys/fs/bpf/my_ipv6_route
>>    fe800000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000001 00000000 00000001     eth0
>>    00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>>    00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001       lo
>>    fe80000000000000c04b03fffe7827ce 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
>>    ff000000000000000000000000000000 08 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000003 00000000 00000001     eth0
>>    00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
> 
> Looks good, but something weird with printf below...
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
>>   .../selftests/bpf/progs/bpf_iter_ipv6_route.c | 63 ++++++++++++++++
>>   .../selftests/bpf/progs/bpf_iter_netlink.c    | 74 +++++++++++++++++++
>>   2 files changed, 137 insertions(+)
>>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
>>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
>>
>> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c b/tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
>> new file mode 100644
>> index 000000000000..0dee4629298f
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
>> @@ -0,0 +1,63 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c) 2020 Facebook */
>> +#include "vmlinux.h"
>> +#include <bpf/bpf_helpers.h>
>> +#include <bpf/bpf_tracing.h>
>> +#include <bpf/bpf_endian.h>
>> +
>> +char _license[] SEC("license") = "GPL";
>> +
>> +extern bool CONFIG_IPV6_SUBTREES __kconfig __weak;
>> +
>> +#define        RTF_GATEWAY             0x0002
>> +#define IFNAMSIZ               16
> 
> nit: these look weirdly unaligned :)
> 
>> +#define fib_nh_gw_family        nh_common.nhc_gw_family
>> +#define fib_nh_gw6              nh_common.nhc_gw.ipv6
>> +#define fib_nh_dev              nh_common.nhc_dev
>> +
> 
> [...]
> 
> 
>> +       dev = fib6_nh->fib_nh_dev;
>> +       if (dev)
>> +               BPF_SEQ_PRINTF(seq, "%08x %08x %08x %08x %8s\n", rt->fib6_metric,
>> +                              rt->fib6_ref.refs.counter, 0, flags, dev->name);
>> +       else
>> +               BPF_SEQ_PRINTF(seq, "%08x %08x %08x %08x %8s\n", rt->fib6_metric,
>> +                              rt->fib6_ref.refs.counter, 0, flags);
> 
> hmm... how does it work? you specify 4 params, but format string
> expects 5. Shouldn't this fail?

Thanks for catching this. Unfortunately, we can only detech this at 
runtime when BPF_SEQ_PRINTF is executed since only then we do 
format/argument checking.

In the above, if I flip condition "if (dev)" to "if (!dev)", the 
BPF_SEQ_PRRINTF will not print anything and returns -EINVAL.

I am wondering whether verifier should do some verification at prog load
time to ensure
   # of args in packed u64 array >= # of format specifier
This should capture this case. Or we just assume users should do 
adequate testing to capture such cases.

Note that this won't affect safety of the program so it is totally
okay for verifier to delay the checking to runtime.

> 
>> +
>> +       return 0;
>> +}
>> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c b/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
>> new file mode 100644
>> index 000000000000..0a85a621a36d
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
>> @@ -0,0 +1,74 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c) 2020 Facebook */
>> +#include "vmlinux.h"
>> +#include <bpf/bpf_helpers.h>
>> +#include <bpf/bpf_tracing.h>
>> +#include <bpf/bpf_endian.h>
>> +
>> +char _license[] SEC("license") = "GPL";
>> +
>> +#define sk_rmem_alloc  sk_backlog.rmem_alloc
>> +#define sk_refcnt      __sk_common.skc_refcnt
>> +
>> +#define offsetof(TYPE, MEMBER)  ((size_t)&((TYPE *)0)->MEMBER)
>> +#define container_of(ptr, type, member)                                \
>> +       ({                                                      \
>> +               void *__mptr = (void *)(ptr);                   \
>> +               ((type *)(__mptr - offsetof(type, member)));    \
>> +       })
> 
> we should probably put offsetof(), offsetofend() and container_of()
> macro into bpf_helpers.h, seems like universal things for kernel
> datastructs :)
> 
> [...]
> 
