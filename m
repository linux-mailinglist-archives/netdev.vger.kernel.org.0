Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578462DC584
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 18:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbgLPRm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 12:42:26 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14714 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727496AbgLPRm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 12:42:26 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 0BGHRiml015101;
        Wed, 16 Dec 2020 09:41:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=GeKDEfFldPkLPvtdYnR/Pfi5RkZ1sNL+mRAnTA42zfY=;
 b=LZwrGIb2t+btmQVnAiCKNhvb68idZhcD+GSTWrEFokSA2Izmya8ayf5MVierah60Km69
 Y7zm+5kXF4Uvn6JkmqZQ3/D/cQ7FdsNeF1Twl1r29PxYE6adCMlo2dVdqCOI32HxYFNS
 ZHjjccDrmrhd+Rdma1BWkjc3CHpAgSf+1IM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 35f4vk4vm6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Dec 2020 09:41:32 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 16 Dec 2020 09:41:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9REw+yhSmfLUoyOhqsB9TtnnLptnYY0LP1Hv0BAR0We36rmnBYfHOpiR1ym+2fsWKYNVk3es2iNcan3Lb4w8UlkW5GLwwaJ56Sx3JmP0aaoeJbedyg9vw50m8JepOiilkANYExHg3Ee2X4klfeF2q5/neSihaPj6Qczy7oTAOK26BSuZg7lnmgkBDkCXA0ofD3h6uB956rfvREivU/Eij2p/9WbT2LF5AhYN6bIz6c/PXYxn8M8iicYMCNHcC1cLc1vfoWs7f+2e7zO9XPe1vZKtR6W5ZLBePfUHXmWei6XxOo56meuD7qp0EbVxP1Jqf3tLirCpfhCWhbdiFiP8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GeKDEfFldPkLPvtdYnR/Pfi5RkZ1sNL+mRAnTA42zfY=;
 b=m20O53eIiZELcbJyk//GHYMrd0/OWaGiurzJ+nBuIi7hgUOOAZz9AmFLQKWPCCwmEH7R3yMBiTZDBBRrRP6auk0/+7/xxSxvLQzUcvS8jeLskAuuTj1kr+0h7Aw4NqKlUS4fnVfZra9046YYiu84S44ICTSBUJnNwjhhR/H2fi8OweXdPmzEv59t275pJcj9BoYT4RGFV/eroblM5jgsqzJpAFQ+kLPKFc51jNLQSvkrNsm+eHrMOOvYarK3WTUVLoRWYRgLWll8AysOGe9RuvMDyqv3KCPQgmdkU9ke9cK4Os8XWDe+6PqTLIafC7XU0c3sqcqsrVidM2VSXHX8Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GeKDEfFldPkLPvtdYnR/Pfi5RkZ1sNL+mRAnTA42zfY=;
 b=UQGsOdUq+7c0WKGlb/J3mRyA6UTa3E4lEi/cGzdGrocYHEysDMhLKH6SiRzxeHqdp3Mk8b+29kTSNW9V1IVIL6ZHDe0/0ZY5MDwXc2a8zJ0cSxJUsfyQZfr0EaXnI3TWqeqZrHGE5cbUDqLo9r/ipTUJP/3rq4HBpa/t8FI2mGo=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3368.namprd15.prod.outlook.com (2603:10b6:a03:102::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.20; Wed, 16 Dec
 2020 17:41:30 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 17:41:30 +0000
Subject: Re: [PATCH v2 bpf-next 2/4] bpf: allow bpf_d_path in sleepable
 bpf_iter program
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-3-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <fe6aca5b-9af8-a10a-96c1-79f4604aed4e@fb.com>
Date:   Wed, 16 Dec 2020 09:41:28 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <20201215233702.3301881-3-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:4fea]
X-ClientProxiedBy: MWHPR08CA0045.namprd08.prod.outlook.com
 (2603:10b6:300:c0::19) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::12e6] (2620:10d:c090:400::5:4fea) by MWHPR08CA0045.namprd08.prod.outlook.com (2603:10b6:300:c0::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 16 Dec 2020 17:41:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cbfe3a3-7ec5-472f-0184-08d8a1e9d2a4
X-MS-TrafficTypeDiagnostic: BYAPR15MB3368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3368B60DCA67F79A950283C5D3C50@BYAPR15MB3368.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XgKhvyzHQvKC43eMiOc0fsy+MCup3kgTLL65WpDKtwl/yJNxiS3PpyY3pNJawwoP76+lzvsbGrcorb5BxZzkawlafqIZypMtY3SnItHO+aaanajdoSYpMWr8JCCkPsjNKheBcI7QBPYQyf+UXihR9a+tp0LAsRQ8L9KFw0jDpnrvvX5rJh4rPPpCz01BmEA+ngrASsJJOwaHbql28yd1UHYEcpRRT25yNtzmex5oceJsdt8TwddO5lzFEBjfBlhJR5l56NL8tvNRnuRJC3pA+hmZR6U2kQiBi26KmKSMEMV6L+yFf4TVYZWbZ6E3CKn0/VehteRBnMR+irO7ha4tmhNVKq41gpb17Ovq9Oc8TIZNCbEoleBdy73NHqKPbrf+MjZVeIJs7rm9ZMqvOv28mYOiaxR6miLSQWSSih81AjA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(376002)(136003)(366004)(8676002)(53546011)(31696002)(86362001)(478600001)(8936002)(5660300002)(83380400001)(4326008)(2616005)(66946007)(31686004)(66556008)(2906002)(4744005)(66476007)(52116002)(316002)(16526019)(36756003)(186003)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RUltb2tXL0tvbWdaLy9SY2loK3FmQmhwejJHWmRkRnFMZjk0MTVyWmVwb3BJ?=
 =?utf-8?B?UHlyTDhFZS8yRTIxWDd6K29MNlo3em4xeXZPenFBR1Ywblkzb002d0YzZm1W?=
 =?utf-8?B?Nk9DRWk3OVF0NUp1dzZ6ZGVkQUwzYlJ0MGV5TnVVVGJYWUI1QVdjanArY1Bk?=
 =?utf-8?B?ZGJVS3VlVFdWN0R0aVdhYUlObG1mNTJqTkJNUitwQmpkamZvRmxKSmxjUFJs?=
 =?utf-8?B?R1F6djNlbVJSVlpxclNZR2RodzNYSWdPb3BFVDJGOFp5cDZVQ2d0Tytkb2pn?=
 =?utf-8?B?L1dDc3BwTmlYejVPUjJTSE9WM3FlZXlLOXpGV2VQc1JzbFdWWjJkYWNFM3h0?=
 =?utf-8?B?M0k5aGYwWXN6cXAxZGlMSHlCcWZ4R0ZsNmNlTXF4S2x2WGJjWnF3Ym4rR3Nm?=
 =?utf-8?B?dHp3SWtjdzRIQ3R5Z3BINlRtSXZ6dU04ZkRZNWNGekNjTW11c21CMVJDZlZT?=
 =?utf-8?B?K2dtQm5PRGs4dGhiNEFmWEx4blp2VnhuLytRQUJPdzlpT1kwZnF2c2FYdC9k?=
 =?utf-8?B?bEFJS0pJbXVmUGszdkdacW93Y1RIU3FySkFSOEJBY1hscnFQMHB5SkhiZFhP?=
 =?utf-8?B?Q0ZXMTlZNHNDdldKTzRHcW14aVkrZjRGNjQ0RjRVWGxaem9ETTh0dkJJUHEx?=
 =?utf-8?B?YWFjdVp6dkY4MmpXUjZkbzdvZ3A0WEdEZ0FPL0hBQmVnbHZlcG4wem01VmpH?=
 =?utf-8?B?ejk1Y2pqSWRjSFlwQmE5V1grWEFyN2tCM24vYTVaYklmWm5VeThjTlN6WGNv?=
 =?utf-8?B?b0hnNnBTdXhJeE5lMldhekJyaWphVEMyWlJrQmh4QURZTlpkZGhiaGphZHk4?=
 =?utf-8?B?VlExQVk5OEYwY2NVcDRyNTFpbmpuRVZDTWtIRkFQbHVKU20zS1hadHQ4Z3pT?=
 =?utf-8?B?VGw4NU9xck0wOE1QTWZFYmJHU0ZrazdLdmVDMEhLMGlaTVVVRkUvUnU3V3d0?=
 =?utf-8?B?Qk5ENEhKbUFsV2N5QnlWSG8zK0NuNzZTekR1VnYwd2I4czlNWERpRnh0RUF5?=
 =?utf-8?B?c0YyNDFpT0o3ZWJ3dnFSdk81UHFZeFNJZ3I3Ny9LUXI1c3JIUnVoS1ZTUklv?=
 =?utf-8?B?YzR5aEh3Z3VBbTQ2WXR5SnAvWThlTkdiR2t0d29KdmU2Z0xQUThFV056Vjdq?=
 =?utf-8?B?ZzlSR0Z5OUY3V3QrUEc0K3I1d2tyTHdDSGFhRHFnWUZYYStoN1c2N1BobXBq?=
 =?utf-8?B?ZStCeE5LcHpLUmNyeFdvdTdCbDNweU96d050K2FsZ3VYTk1tTGx1U09KUUx6?=
 =?utf-8?B?MnZRRTR5b0lZM3BxS1NqZVpCczBYdnlWTkk1SUV1c3FpUGlzOGIzTjc3OGln?=
 =?utf-8?B?Z3VKWC9kcVBWOEpBc0JZSWN1cDFNSzFVMDVvSEZ5bWQvd05CcHVOQzNLbWFF?=
 =?utf-8?B?RnRUYUN4ZGZYZ0E9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2020 17:41:30.4951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cbfe3a3-7ec5-472f-0184-08d8a1e9d2a4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ADZU+WchEWXFiFRV8jl0SDK619ef2j1WviZLCTJzUI+l2hDjDzFkmrwMdqnOmy8h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3368
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_07:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 adultscore=0
 mlxlogscore=680 malwarescore=0 suspectscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160113
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/15/20 3:37 PM, Song Liu wrote:
> task_file and task_vma iter programs have access to file->f_path. Enable
> bpf_d_path to print paths of these file.
> 
> bpf_iter programs are generally called in sleepable context. However, it
> is still necessary to diffientiate sleepable and non-sleepable bpf_iter
> programs: sleepable programs have access to bpf_d_path; non-sleepable
> programs have access to bpf_spin_lock.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>

Agreed. So far bpf_iter programs all called from process context.

Acked-by: Yonghong Song <yhs@fb.com>
