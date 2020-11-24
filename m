Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219312C2E19
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 18:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403923AbgKXRKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 12:10:37 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27024 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390714AbgKXRKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 12:10:36 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHACco002532;
        Tue, 24 Nov 2020 09:10:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=jcGUK30O5Z3rUvsvfTCa41GkvuE+Q3Rdl1JUOtjQ2+c=;
 b=VJ+R1/Gx7Ou2DYqOR0KPwZBc02KEJ71CTulNTmc+W6Awr47R1Po3TqZNDQRJcR/vS9i4
 8e5SG3XqPb0ZqMYMP7wqkfhx0nMC9mts3i1bzcOznBxnCk8QCbrTnmxL0ZPhrNFtFwQI
 ePg8Xkrdi6RdRj6V2UeBl+05Fv6uiLmqJeY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34yk902me1-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 24 Nov 2020 09:10:20 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 24 Nov 2020 09:10:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mtBi/CSeSpQCc2yqjI1LsglrwDqx+nSIPvLGeIpuxkr2u8xUKZLmwRMEglpe3xMks0XoOaV5JoEwSzzNURPXAwSOgpqJqa2ASEkUwBUOf0Pfn/+6KiQvECcnq9YoHwwElvTfOLcbiEpfN/NwFMSWGzzs7H4IXnJQZ6m0iKvkvWO21zeYksmjmFxc1gXJ9aK26JYTQoApyW7+Tmx+mY0lHhjt4eeJUcIlckGndcYJj04PlRmWgjQoTdEERSupqzicU6jztRqZKBqFaI7nusDY4ybhn6kzl7mDDcbzzqCBjP8URlkmHSr9pGScqKMGEl09sV/ksi6z+EK2lUkHSXQMqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcGUK30O5Z3rUvsvfTCa41GkvuE+Q3Rdl1JUOtjQ2+c=;
 b=JnNP1n4zOvoL7lythBOoUkOpLhirSi7JdA+AxNZqV5pzw0in+u+KxG1CHVt6jD2ayNllbdiym1e0XzYHOwBuPoDj+3c+AirUWvBNMDjYeMAJ2TTA8iLBG2GCAQxMpHUfDY5A8N0B4S/lR6VhLqW3/Ocl9Qr01gCvQbcFHLcgClg2GlPve3f9nGIRFMbOAvnIBh1lLsHTbB6/ZCQNNouivZyP/ft8JHlPT+KK2dWpU2nypKSAhukKc/ogSnd5sCzWbmJPCw0q91I+sdR1NlEqP/RuDstyPg7eMkuM74cZSR4uhG9bahUC+J4O9NbnBNP0ABSLPnuorQ9WIG0l7cibjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcGUK30O5Z3rUvsvfTCa41GkvuE+Q3Rdl1JUOtjQ2+c=;
 b=TY9bMbxmacKzHeA3jtRbursBtP2ABGpG6sqPcUObXk3iS11doAtcaR56CQHQ3T7Gk8nesqxTe36brPA8svvbVGlS/Ag05q2Sxk30BUC40yaHvR1rFaq8TKQ8aNaySjsv7JyxNKePrlwgdrLluMh0GZEBfXXIITclFgEdiotkSPA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3048.namprd15.prod.outlook.com (2603:10b6:a03:fc::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Tue, 24 Nov
 2020 17:10:01 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3589.029; Tue, 24 Nov 2020
 17:10:01 +0000
Subject: Re: [PATCH bpf-next v2 5/5] selftests/bpf: xsk selftests -
 Bi-directional Sockets - SKB, DRV
To:     Weqaar Janjua <weqaar.janjua@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <ast@kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Weqaar Janjua <weqaar.a.janjua@intel.com>, <shuah@kernel.org>,
        <skhan@linuxfoundation.org>, <linux-kselftest@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        <jonathan.lemon@gmail.com>
References: <20201120130026.19029-1-weqaar.a.janjua@intel.com>
 <20201120130026.19029-6-weqaar.a.janjua@intel.com>
 <86e3a9e4-a375-1281-07bf-6b04781bb02f@fb.com>
 <CAPLEeBY_p_0QsZeqvrr0P+uf1jkL_eFGgawc=KD6Rkuh_177NA@mail.gmail.com>
 <CAPLEeBYMy3N0D9XT6zO9HPrZfSua4_KpnTh4fY8JyFJ6JickZA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ebfb17fa-39e0-5810-f1a6-20c6804172c8@fb.com>
Date:   Tue, 24 Nov 2020 09:09:58 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
In-Reply-To: <CAPLEeBYMy3N0D9XT6zO9HPrZfSua4_KpnTh4fY8JyFJ6JickZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:4987]
X-ClientProxiedBy: MW4PR03CA0140.namprd03.prod.outlook.com
 (2603:10b6:303:8c::25) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::10b2] (2620:10d:c090:400::5:4987) by MW4PR03CA0140.namprd03.prod.outlook.com (2603:10b6:303:8c::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Tue, 24 Nov 2020 17:10:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b550a8ec-fa4c-4886-8531-08d8909bc767
X-MS-TrafficTypeDiagnostic: BYAPR15MB3048:
X-Microsoft-Antispam-PRVS: <BYAPR15MB304838A9BEEF3E16C9E39376D3FB0@BYAPR15MB3048.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mNPnYbxaQiypU7hIwb+KsvTu05WwE/z0+TxtG5uOoAwoLD7WA8Wz0lgPrnRTXfJFqp7/x8auJBzCNn7Q79SBj8L3VBeinknCsGp0d20EeoGjWFqi5DPwzGgkvd4DVCtlJYcA4BZy5pK/Xk2v4M8CWfqK0h1Ow7EFqibEx4QDQUM6ywI9JNF9z7z//hJOF3gRApXJNYIbL0R282oHxZmapLNk0Eg1a/6dFebCIYqBnA0tkq1VzUk09UfZFLwku6BNbwpa/NhzdiQ/Cw623suKkh0UCk5CfOltO4RRVDT5Y5q9UHSnSy9EzkBeDNw72UmtkSGqUMARRu/rkSTnlh7J1aaY1/gX7y+2YiPcUcqbyKDD7rom4QZqRrQAk/ZHhwXf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(136003)(376002)(396003)(5660300002)(2616005)(8676002)(36756003)(186003)(2906002)(31696002)(86362001)(7416002)(52116002)(16526019)(4326008)(83380400001)(6486002)(53546011)(6916009)(316002)(66946007)(54906003)(66556008)(31686004)(66476007)(8936002)(478600001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S1owOVVNK1lVWEFNaE8vb2ZGZ3JNK3lLTkZqY2Y0WmN5NDFwNzBEdVFlOWY5?=
 =?utf-8?B?MHNsaGdWejlnTjJva3dpTVBZQ3BySXdTb2RWZmFKZ1hWdm5DLy9iWlkxUGJE?=
 =?utf-8?B?M3N2WUFraCs1Njg2K1lwa1c5WFRPdjBabUJ2QVpISmpwbkdtRFRHdGJjdlBO?=
 =?utf-8?B?Z2JGSnRoY3lqWWtkeWVCcmhvclNGYk5nRGFVVEVzbFRDbldYeHlCWVd0eDc4?=
 =?utf-8?B?NHp0eHd6eW9qS3YvZ21QWnY4V0ZPQU13UFhNUWUrWWRWU29GNUl0YzlhT3Vo?=
 =?utf-8?B?VFBURStJL3Y0YkpmWkJHblI0MVExblNyZExCdmpsZzBDbVZuaTZSYy9pTEVh?=
 =?utf-8?B?SFZKc0hUUitYbTBEZFVEQlVCSVIxckZsMVdYbU9wOUJMUktTZFY1L2RkYXho?=
 =?utf-8?B?QzMyZ0xheXc5VVRRSlJXNEpoak1lN3laSXQrNXRuQzRaTG9CVUNJeDZVSS9S?=
 =?utf-8?B?SEQyYmsza2N6aG1aanBzaGFIZFdPS3FwbkVSWkVYaUQvU0d0amVtV3Fqbndt?=
 =?utf-8?B?blNtUEY0QjFSaXBOOElQVVhXT3lINzhybC8wdGZJODdLL2hCd2Y3MHNPMElX?=
 =?utf-8?B?TytzcGhhbDhwOVF6STVVYmdzWWMzUDhMQ00vUFRzdVRWMENiR1VsckF0YWJx?=
 =?utf-8?B?NEc4djAxenhnQjNsd1o2SVhzVDI1TUNxK3pPUFFzNEhLQ2lNbFRnVVJmZStL?=
 =?utf-8?B?TVQ1dFEvVlF0eUNkZ0Z1S0VlWUtmVEMwNGpVaE83K0dURVhMbDRQazBhZ3BL?=
 =?utf-8?B?MXdvZ0pDa0ZtWFRnVmtHVnhzVmJMWHNzUjJRek5DMzc0TUN5czM5UWFVbTla?=
 =?utf-8?B?V1Y0dStEYkhIbk9UWTZSRXBqeVBWNUJleW44WW1PTjYzRzdGanAzeVZyZjBN?=
 =?utf-8?B?aFpwV2duNklWUHJxRlhMOEgrV0JaWlAramk2eG9yQSswSU1ubzNETWhGdy9G?=
 =?utf-8?B?czZ6dWJPTXo0L2tDcXVhcTJHd3JNbnFJcjZDM25HODhuY3ZjUW94eHh2U09K?=
 =?utf-8?B?WkFjUVZXUS9BYS9qbTMxOU04RTRhTWlkQW9hRXpvakhpd05QUk55ZTFGVzJh?=
 =?utf-8?B?WThaWmR2LzQwL2k3b1ErZEVqUTg5SkdWdXJob1ZQUFJXZUdWWktBalhWNkda?=
 =?utf-8?B?NFBDSjZ6anM1dkdyVHVRSzllQjh1bVRDN2lqcUNaVHdMTzBOaUptYWRKSzJv?=
 =?utf-8?B?MzVISzlnMmQxZVBDbG5HY3JNTFhUVUlFQlRoYys0dTZQMzk5S1VjMENHNWNi?=
 =?utf-8?B?ZnRGVndMSWdoUFZiZmRoMmExMmV3WE93VkRnNFIzczlRb2U5eTZFeUlIbGhX?=
 =?utf-8?B?ZCtBTGN5Zk5vblVSbk04VUlBS1J2TTdVa1dKR1ZLMjFzL3ZWSURHcDN1N3dD?=
 =?utf-8?B?MHNpcDF2VHA4bmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b550a8ec-fa4c-4886-8531-08d8909bc767
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2020 17:10:01.4205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a/1TQesSwxe0aEhhsiCXI5DOXyoO1cF9vqB9y8nrUy13ToOfHXioUWwKgpdwdZ4P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3048
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_05:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240105
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/24/20 7:11 AM, Weqaar Janjua wrote:
> On Sat, 21 Nov 2020 at 20:14, Weqaar Janjua <weqaar.janjua@gmail.com> wrote:
>>
>> On Fri, 20 Nov 2020 at 20:45, Yonghong Song <yhs@fb.com> wrote:
>>>
>>>
>>>
>>> On 11/20/20 5:00 AM, Weqaar Janjua wrote:
>>>> Adds following tests:
>>>>
>>>> 1. AF_XDP SKB mode
>>>>      d. Bi-directional Sockets
>>>>         Configure sockets as bi-directional tx/rx sockets, sets up fill
>>>>         and completion rings on each socket, tx/rx in both directions.
>>>>         Only nopoll mode is used
>>>>
>>>> 2. AF_XDP DRV/Native mode
>>>>      d. Bi-directional Sockets
>>>>      * Only copy mode is supported because veth does not currently support
>>>>        zero-copy mode
>>>>
>>>> Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
>>>> ---
>>>>    tools/testing/selftests/bpf/Makefile          |   4 +-
>>>>    .../bpf/test_xsk_drv_bidirectional.sh         |  23 ++++
>>>>    .../selftests/bpf/test_xsk_drv_teardown.sh    |   3 -
>>>>    .../bpf/test_xsk_skb_bidirectional.sh         |  20 ++++
>>>>    tools/testing/selftests/bpf/xdpxceiver.c      | 100 +++++++++++++-----
>>>>    tools/testing/selftests/bpf/xdpxceiver.h      |   4 +
>>>>    6 files changed, 126 insertions(+), 28 deletions(-)
>>>>    create mode 100755 tools/testing/selftests/bpf/test_xsk_drv_bidirectional.sh
>>>>    create mode 100755 tools/testing/selftests/bpf/test_xsk_skb_bidirectional.sh
>>>>
>>>> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
>>>> index 515b29d321d7..258bd72812e0 100644
>>>> --- a/tools/testing/selftests/bpf/Makefile
>>>> +++ b/tools/testing/selftests/bpf/Makefile
>>>> @@ -78,7 +78,9 @@ TEST_PROGS := test_kmod.sh \
>>>>        test_xsk_drv_nopoll.sh \
>>>>        test_xsk_drv_poll.sh \
>>>>        test_xsk_skb_teardown.sh \
>>>> -     test_xsk_drv_teardown.sh
>>>> +     test_xsk_drv_teardown.sh \
>>>> +     test_xsk_skb_bidirectional.sh \
>>>> +     test_xsk_drv_bidirectional.sh
>>>>
>>>>    TEST_PROGS_EXTENDED := with_addr.sh \
>>>>        with_tunnels.sh \
>>>> diff --git a/tools/testing/selftests/bpf/test_xsk_drv_bidirectional.sh b/tools/testing/selftests/bpf/test_xsk_drv_bidirectional.sh
>>>> new file mode 100755
>>>> index 000000000000..d3a7e2934d83
>>>> --- /dev/null
>>>> +++ b/tools/testing/selftests/bpf/test_xsk_drv_bidirectional.sh
>>>> @@ -0,0 +1,23 @@
>>>> +#!/bin/bash
>>>> +# SPDX-License-Identifier: GPL-2.0
>>>> +# Copyright(c) 2020 Intel Corporation.
>>>> +
>>>> +# See test_xsk_prerequisites.sh for detailed information on tests
>>>> +
>>>> +. xsk_prereqs.sh
>>>> +. xsk_env.sh
>>>> +
>>>> +TEST_NAME="DRV BIDIRECTIONAL SOCKETS"
>>>> +
>>>> +vethXDPnative ${VETH0} ${VETH1} ${NS1}
>>>> +
>>>> +params=("-N" "-B")
>>>> +execxdpxceiver params
>>>> +
>>>> +retval=$?
>>>> +test_status $retval "${TEST_NAME}"
>>>> +
>>>> +# Must be called in the last test to execute
>>>> +cleanup_exit ${VETH0} ${VETH1} ${NS1}
>>>
>>> This also makes hard to run tests as users will not know this unless
>>> they are familiar with the details of the tests.
>>>
>>> How about you have another scripts test_xsk.sh which includes all these
>>> individual tests and pull the above cleanup_exit into test_xsk.sh?
>>> User just need to run test_xsk.sh will be able to run all tests you
>>> implemented here.
>>>
>> This works, test_xsk_* >> test_xsk.sh, will ship out as v3.
>>
> An issue with merging all tests in a single test_xsk.sh is reporting
> number of test failures, with this approach a single test status is
> printed by kselftest:
> 
> # PREREQUISITES: [ PASS ]
> # SKB NOPOLL: [ FAIL ]
> # SKB POLL: [ PASS ]
> ok 1 selftests: xsk-patch2: test_xsk.sh
> 
> This is due to the fact Makefile has one TEST_PROGS = test_xsk.sh
> (thus kselftest considers it one test?), where in the original
> approach all tests have separate TEST_PROGS .sh which makes reporting
> match each test and status. This can be a problem for automation.
> 
> An alternative would be to exit each test with failure status but then
> the tests will stop execution at the failed test without executing the
> rest of xsk tests, which we probably wouldn't want.
> 
> Suggestions please?

I think it is okay to put everything xsk related to one test.
If later on the test becomes more complex, you can have
test_xsk_<1>.sh test_xsk_<2>.sh etc. But each .sh should be able to
run independently without any particular order.

You can have subtests inside the .sh file. See test_offload.py as
an example. You do not need to exit after one subtest fails, you can 
continue to run the next one. currently test_offload.py
may exit when some subtest failed, but I think you don't have to.

> 
>>>> +
>>>> +test_exit $retval 0
>>>> diff --git a/tools/testing/selftests/bpf/test_xsk_drv_teardown.sh b/tools/testing/selftests/bpf/test_xsk_drv_teardown.sh
>>> [...]
