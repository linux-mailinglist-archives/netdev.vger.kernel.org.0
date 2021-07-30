Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB80D3DB3FE
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 08:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237739AbhG3Gyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 02:54:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38412 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237463AbhG3Gyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 02:54:51 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16U6pQnm022485;
        Thu, 29 Jul 2021 23:54:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=c/oeMI1S74/Re8mJPbugwDkCEfz9doSbXuovc4ZYpNw=;
 b=FtczgN/ETrIp1Hh5XGPTHY+55djQcFogFPj9soUfawj3hwenT5ndnDKEIO6a5+cJ3V9Z
 d+mCUBGn9VCg7V5/ys1rcvDqbp25zb3u02UTxEg5NXuQNNPna9dU0GF+In/37/73aUFO
 v7AvMGDFBjDSrCAqdbD+jHE480ig2KHWmp8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a491c91yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 29 Jul 2021 23:54:32 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Jul 2021 23:54:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCo5UEvsN5AeQ2f90g82LvUHY1ZfJaCABiTHzafxsEe9MCu6gn1QLfTVPMxlIvEvZqHtGA4VUeimoMlIfzjRHcGAesAm2rPU0tAQKvJM4ZOq0a8aFO2JigubyYeQciYtFp5qGeL/w4KtqYYs6yezhhHvDZhUnidv2h7SHV4bgJ1DmdtAwdPP9diHHxxyDKzNVBmR+RVnRUNj4X0hWcDmvCU2BQyLrUFD+nEYvhM2i/+KV98+NVL0PkA5pawNcegkyL1ZJyxlrJ8XMXL0lqantwqIwIndVXo+NuGOCqGWF+T9AtXBkKoDPnlUDtmhfPTdGHeLcc89Bc3t2611Ey4G9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/oeMI1S74/Re8mJPbugwDkCEfz9doSbXuovc4ZYpNw=;
 b=JZuZngxKtbe8q3ioIUt4Qy6V7WVuA8SKvGuh+Ayc5pigkAIbU+hr6qtLN3uUdCqrMHI805d0mBO0B2UCcrFgIFNZKbaI815kdYMGaoB1NDgdt4pG+wmosuv4vugLqEQU/IT+8ScSs/ZL3kqGPAlpS0WtQrgEDL2i70im2XC2nbB/ck+ngxBVuhj5uDlDlhm8OkCWWzyvwKr8cA4WhY8rxu2RYyHNa86cMMlrvTWCd76uoc/h4sCDvr3hYROMJPLZWcmyGbeS5jnhhS+nnBpPNLXloWkbhGe7ds+IZkjwBGX7+lW2Zh94iJ1vvuXbBPHDkqhjgBOUuDMUqRO/38fT7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4386.namprd15.prod.outlook.com (2603:10b6:806:191::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Fri, 30 Jul
 2021 06:54:30 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4373.021; Fri, 30 Jul 2021
 06:54:30 +0000
Subject: Re: [PATCH bpf-next 2/2] selftest/bpf: Implement sample UNIX domain
 socket iterator program.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20210729233645.4869-1-kuniyu@amazon.co.jp>
 <20210729233645.4869-3-kuniyu@amazon.co.jp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <0a16fcbb-1c17-dfe2-24b0-6f1d1e6a91bd@fb.com>
Date:   Thu, 29 Jul 2021 23:54:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210729233645.4869-3-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0042.namprd04.prod.outlook.com
 (2603:10b6:303:6a::17) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1130] (2620:10d:c090:400::5:1fa2) by MW4PR04CA0042.namprd04.prod.outlook.com (2603:10b6:303:6a::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.22 via Frontend Transport; Fri, 30 Jul 2021 06:54:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e49d58ff-9eb1-41e3-8df9-08d95326e119
X-MS-TrafficTypeDiagnostic: SA1PR15MB4386:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB438656732A3D9B1969D7674CD3EC9@SA1PR15MB4386.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:459;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d1FgpImXxwsQ7Nn7gM++oV3zdl5s1bg9AcZ0+QmuJ6PoCh5czB4SW2at/omQz/jBMF1xeE1t66MF1sBluwzVHeoBSiuijkORlIi2dnACxajMDPC3ry8uqXXkJ6ejaRMqLvJ27rP0FNQYEGiJjW0/1NF26hKd+eY/C37Ru1ZEWOakgQspZbYDYakwZS5dm4pC82pDdZrSVLgHxU/2HY6/j2IwfOxCdNPMBi6haP/aEhpIaYHm88UpAMxT+tdIQLmfI0bhPAlDPRC+IQEo/m97u7ka4/xeHkoLd2Umo26tt3/bSu65LmhwIx6d/ekTlKIuM5D2bJ1mESCvoVbC67dYPUKvxlgCmZSYNbu3UxXdwZXgui68baai6nlVfS6OdD+loc7XAh0hlZZvTKJ9cVyMFk8fJ8sGrqnS6F5qBYk+hVgL01cPO4gDZqbBTzcCyk7My38sAx1s0BBq/EYN2wW75l4GL9F2R9+OpZBmJiI3Qn/Rzmqt5/vWqdF9PcpKVRrRfTD1jbnXABpMwVWJyNHpW8ZQHId/gpngDPOWE58E7EQuJMbhJTrBkwlJmvu8hRIAaIdqCFRyaUaQV510y4q+FiVZdLUlZPoiA2rtn2oq3gQE2QMawtVDqn1M95j/zmLAFBUGkf+D9wTrX0m6r9LIhIxwfzIahEKYe9P7y9O9QenmMJ84Ke9pHFXK9QNuaNdlwTp/s570DU2z9a/f6MV/e+sHo+PIitV1ckLWcsK35JT9vO+ZXci1g0yaj/0ov4ua
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(5660300002)(54906003)(110136005)(86362001)(66556008)(66476007)(53546011)(66946007)(31696002)(8936002)(31686004)(478600001)(38100700002)(52116002)(186003)(2616005)(6486002)(4326008)(8676002)(2906002)(7416002)(921005)(83380400001)(316002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmZKbjU1cEo3YjEwRWhHcEdkRDFpVGtzOW5WcnBvVU56TmpnT1lqV3JOcElr?=
 =?utf-8?B?R0ZaMVJCWXBUUG1pUFhUVDN3NmFFUlhkYnFSOWoxVlNlM2VBTUZsako1YTBi?=
 =?utf-8?B?eUZ6aHFvY1dLVm5UZUJaY1ZtZ0ZRVkwySm81VEMzVDhwV3AwcXRWZzAxR1Vk?=
 =?utf-8?B?aURIcXdSQ29Wczk5Q3BWRlZ6SGc3dFpnemJVN2lDSS9mVDllMWw5VlYwTHRQ?=
 =?utf-8?B?NmhJOE5VY2hRaGMzNyt3SnM5RjhzenlOQTIyMjJwWlFSNlY4cHViaVhzN3cz?=
 =?utf-8?B?aUtsOWk4QkhyQU4zT0t5aWRsVXBrS0hYNnBCYkJQUThDdXlQMHFNSCtaVDVY?=
 =?utf-8?B?WFJ3NnI4UWJIK3dFRkp1UWh2eGNxekNXMmh5NXZTc3VLdnQ2RUNKQXE5UWF0?=
 =?utf-8?B?NU5HUHRpa1c4TXpHQTZqQVN2VGgxTXlPclYyelpNaFcwUEtzcTBJRHVEa3Zj?=
 =?utf-8?B?bXd5dUoxaERJOEhWWHNBeTNxSkhqc053V21VbjVFWWVVNmZIR2ZRRG1HNHph?=
 =?utf-8?B?bDIzRGdmaWZFMGQ2WElrUHRLeVVybWZpakltclR5QzdNRms1VGlrWFV1alJx?=
 =?utf-8?B?STB5ZkxnR2dhSU1sY01DYW4rcEtrdE5seTZ3TmNjSU8wTFRaaktCWTBtdUd1?=
 =?utf-8?B?VVNnZE9kMFBNWHc5NzJXVExwN3c5R3ZOVzEyTkg4M1ZHVE10NTFLWmJEait5?=
 =?utf-8?B?T0EvSUZEeDIvYkd4c3VZQ3Q2ZTA1aFJhQ0tRaXRqVDBUZHUwbkYxSWFsczBn?=
 =?utf-8?B?OUVFTE5Kd0dPTG5FaVF5RFV0NXdxTnFzaVpUZEpIR21sQ0M2bjQwK0J4dGxq?=
 =?utf-8?B?M1VPZ3JZRW1CbXBSU25SMmtRREZaZjRROGNlUFdJditVSWxxcG0zZkFGRXBV?=
 =?utf-8?B?aFVyenZVT1R0QVMwLzVjVzN1Z3lJT0xNWkFWeEJ3ZVMrVkwxMmNhdi9hdnor?=
 =?utf-8?B?UXhrRzcxOHd0K1BtNmpCWlEvNmk0eitsVVZIazBDWEpUUnZIWFREWG81Tkxu?=
 =?utf-8?B?OU91d3hzTE5uYVlDZXo3eEY0UEExVjVQcUpKSFJldEpVMEZsUmxXMXNaSjFj?=
 =?utf-8?B?UHYvTVQxVFgrSnN4VU1lNlRnbTdMN0ZUUmk5dUtVN1JoQWxlNDhweURUTXE2?=
 =?utf-8?B?cEpmOWFFK0kzT1lVYlJzK0gxbnFUNldkemNOMVZFbEhGeFJlcVNVS2U0THg5?=
 =?utf-8?B?cnliRzBWNTZoNnpMS0JKTHlzemZyTjBnLzlFTjlkOVNjTnZzbDBORUFzQW1s?=
 =?utf-8?B?NHJGSTZxeDllMHhJWWpqTmpvbDVrN002V1hWa1Rwc3FJcnQ0MlBDT2lMMGtk?=
 =?utf-8?B?L1pTWlVZMUZSdUhXdmt6ZlhzU1J3OEx1RU9KcXFOdUhXQzlCODFXSFpTV2Va?=
 =?utf-8?B?Zy9RSkcrRDBMblQyNGFNSyt5WUxLVjZLYzNkOFNzYkVWTjZnUGhUSDRRUWxy?=
 =?utf-8?B?MksxQVYrS21iK2tFeHhERVVTNk52dVkrb1BmeEN5MGthUTN1elkwUWgydkZu?=
 =?utf-8?B?NHpFeDVDTHV2cHloMSt2RzVlajJRQ3pIdXFhbjRhL1lyWU1ZRitaZUp2Tkx4?=
 =?utf-8?B?bmtFR2pZY04zZnhENzB4NjUrblVjNDJ3ZVI1YTRJbnFoR01jNUoxL3RaZXlS?=
 =?utf-8?B?d1BXZW1wTlRDN1JYcEZRVHNmM3I0ankrTDJ5VDVJeEU5b3J2TTVxSjgwcnU5?=
 =?utf-8?B?RlFBQW1BV280UmpFTThYMm82Z1Bqd2o5cVh3MTZWQnQ5dFpIRDRxY09ua2Jh?=
 =?utf-8?B?dVN1aEc0QVhMYUtKR3NsUXduNlRNUGxOSUdFTmxIMkx1ZWdMUmhVMTRncDRU?=
 =?utf-8?Q?fATeyCAzZvEItQ9epL55Wrl5DgW0E/+FuHhLs=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e49d58ff-9eb1-41e3-8df9-08d95326e119
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 06:54:30.1326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3vPz1P4+aiKxRIEkPb3ts6Ig1w4jXLwMOhB9rOIn04ZeyTedD8kwzcwuX/TGFu1B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4386
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: hqDuK2oi8LRGDTVOBuTq7CJa6ChzKYFu
X-Proofpoint-GUID: hqDuK2oi8LRGDTVOBuTq7CJa6ChzKYFu
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-30_04:2021-07-29,2021-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 malwarescore=0 impostorscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107300041
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/29/21 4:36 PM, Kuniyuki Iwashima wrote:
> If there are no abstract sockets, this prog can output the same result
> compared to /proc/net/unix.
> 
>    # cat /sys/fs/bpf/unix | head -n 2
>    Num       RefCount Protocol Flags    Type St Inode Path
>    ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer
> 
>    # cat /proc/net/unix | head -n 2
>    Num       RefCount Protocol Flags    Type St Inode Path
>    ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>   .../selftests/bpf/prog_tests/bpf_iter.c       | 17 +++++
>   .../selftests/bpf/progs/bpf_iter_unix.c       | 75 +++++++++++++++++++
>   2 files changed, 92 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> index 1f1aade56504..4746bac68d36 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> @@ -13,6 +13,7 @@
>   #include "bpf_iter_tcp6.skel.h"
>   #include "bpf_iter_udp4.skel.h"
>   #include "bpf_iter_udp6.skel.h"
> +#include "bpf_iter_unix.skel.h"
>   #include "bpf_iter_test_kern1.skel.h"
>   #include "bpf_iter_test_kern2.skel.h"
>   #include "bpf_iter_test_kern3.skel.h"
> @@ -313,6 +314,20 @@ static void test_udp6(void)
>   	bpf_iter_udp6__destroy(skel);
>   }
>   
> +static void test_unix(void)
> +{
> +	struct bpf_iter_unix *skel;
> +
> +	skel = bpf_iter_unix__open_and_load();
> +	if (CHECK(!skel, "bpf_iter_unix__open_and_load",
> +		  "skeleton open_and_load failed\n"))
> +		return;
> +
> +	do_dummy_read(skel->progs.dump_unix);
> +
> +	bpf_iter_unix__destroy(skel);
> +}
> +
>   /* The expected string is less than 16 bytes */
>   static int do_read_with_fd(int iter_fd, const char *expected,
>   			   bool read_one_char)
> @@ -1255,6 +1270,8 @@ void test_bpf_iter(void)
>   		test_udp4();
>   	if (test__start_subtest("udp6"))
>   		test_udp6();
> +	if (test__start_subtest("unix"))
> +		test_unix();
>   	if (test__start_subtest("anon"))
>   		test_anon_iter(false);
>   	if (test__start_subtest("anon-read-one-char"))
> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_unix.c b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
> new file mode 100644
> index 000000000000..285ec2f7944d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
> @@ -0,0 +1,75 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright Amazon.com Inc. or its affiliates. */
> +#include "bpf_iter.h"

Could you add bpf_iter__unix to bpf_iter.h similar to bpf_iter__sockmap?
The main purpose is to make test tolerating with old vmlinux.h.

> +#include "bpf_tracing_net.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_endian.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +#define __SO_ACCEPTCON		(1 << 16)
> +#define UNIX_HASH_SIZE		256
> +#define UNIX_ABSTRACT(unix_sk)	(unix_sk->addr->hash < UNIX_HASH_SIZE)

Could you add the above three define's in bpf_tracing_net.h?
We try to keep all these common defines in a common header for
potential reusability.

> +
> +static long sock_i_ino(const struct sock *sk)
> +{
> +	const struct socket *sk_socket = sk->sk_socket;
> +	const struct inode *inode;
> +	unsigned long ino;
> +
> +	if (!sk_socket)
> +		return 0;
> +
> +	inode = &container_of(sk_socket, struct socket_alloc, socket)->vfs_inode;
> +	bpf_probe_read_kernel(&ino, sizeof(ino), &inode->i_ino);
> +	return ino;
> +}
> +
> +SEC("iter/unix")
> +int dump_unix(struct bpf_iter__unix *ctx)
> +{
> +	struct unix_sock *unix_sk = ctx->unix_sk;
> +	struct sock *sk = (struct sock *)unix_sk;
> +	struct seq_file *seq;
> +	__u32 seq_num;
> +
> +	if (!unix_sk)
> +		return 0;
> +
> +	seq = ctx->meta->seq;
> +	seq_num = ctx->meta->seq_num;
> +	if (seq_num == 0)
> +		BPF_SEQ_PRINTF(seq, "Num       RefCount Protocol Flags    "
> +			       "Type St Inode Path\n");
> +
> +	BPF_SEQ_PRINTF(seq, "%pK: %08X %08X %08X %04X %02X %5lu",
> +		       unix_sk,
> +		       sk->sk_refcnt.refs.counter,
> +		       0,
> +		       sk->sk_state == TCP_LISTEN ? __SO_ACCEPTCON : 0,
> +		       sk->sk_type,
> +		       sk->sk_socket ?
> +		       (sk->sk_state == TCP_ESTABLISHED ?
> +			SS_CONNECTED : SS_UNCONNECTED) :
> +		       (sk->sk_state == TCP_ESTABLISHED ?
> +			SS_CONNECTING : SS_DISCONNECTING),
> +		       sock_i_ino(sk));
> +
> +	if (unix_sk->addr) {
> +		if (UNIX_ABSTRACT(unix_sk))
> +			/* Abstract UNIX domain socket can contain '\0' in
> +			 * the path, and it should be escaped.  However, it
> +			 * requires loops and the BPF verifier rejects it.
> +			 * So here, print only the escaped first byte to
> +			 * indicate it is an abstract UNIX domain socket.
> +			 * (See: unix_seq_show() and commit e7947ea770d0d)
> +			 */
> +			BPF_SEQ_PRINTF(seq, " @");
> +		else
> +			BPF_SEQ_PRINTF(seq, " %s", unix_sk->addr->name->sun_path);
> +	}

I looked at af_unix.c, for the above "if (unix_sk->addr) { ... }" code,
the following is the kernel source code,

                 if (u->addr) {  // under unix_table_lock here
                         int i, len;
                         seq_putc(seq, ' ');

                         i = 0;
                         len = u->addr->len - sizeof(short);
                         if (!UNIX_ABSTRACT(s))
                                 len--;
                         else {
                                 seq_putc(seq, '@');
                                 i++;
                         }
                         for ( ; i < len; i++)
                                 seq_putc(seq, u->addr->name->sun_path[i] ?:
                                          '@');
                 }

It does not seem to match bpf program non UNIX_ABSTRACT case.
I am not familiar with unix socket so it would be good if you can 
explain a little more.

For verifier issue with loops, do we have a maximum upper bound for 
u->addr->len? If yes, does bounded loop work?

> +
> +	BPF_SEQ_PRINTF(seq, "\n");
> +
> +	return 0;
> +}
> 
