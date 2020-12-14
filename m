Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75A62D9378
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 08:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438834AbgLNHC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 02:02:59 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35888 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438679AbgLNHCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 02:02:48 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BE70lSf007884;
        Sun, 13 Dec 2020 23:01:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/yVqd+WaqW9hghXq5ragWGEAJ3AhWkF17b5SNozUHbk=;
 b=rUYRFKQW6iqvGAvtdHAcEXVvGdsxBPNVhcQE65WXpl/V3sGk/U1RzqCgW3nPnUi4juvn
 A5e59m7LFYRyeqs0YENsfYqDj1cgjmap4d8FJk99T+4aBx7KzZEJlRSS3WmA6PQ0buVE
 pfjupUqNXzxM4wTLL4Fg22vU4sbeqz2V/vQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35df0e36qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 13 Dec 2020 23:01:54 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 13 Dec 2020 23:01:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nSxeSdZJhuke66Xjz1KWPH7Onb3iAoaoG21x6KE2cE7DX5b1EwIc7fcOZgvaJfz8Is4zTLfQmy8aXPUzv9v/ZSxb93Imho7+19Qr5EZxYQcbFZF8HdOMpTKYek8OEq4g+TPWz7IyoDUjvEeHWNRA82hioZqVtL2QhBp3r3LDI0jrtQ4nKPC58hLhYniTIuNk9YDaWdHziTyZtk1TNyr/vYUd0Y0GdSWvq2j73az0dBgP8FY3PGC8kQLpysSRbRMQ3InPmT2LaBXaB52zhuk27vNS+PndfQ3ia8E3AKEyp0Ryeu5ybzHDOiEAMEErf8+RIdPbA+Aj7ExxNZKPITQ08Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/yVqd+WaqW9hghXq5ragWGEAJ3AhWkF17b5SNozUHbk=;
 b=OFHiAR0N7j/ls3fOvCfpn30V1m1EklhEmN3CcXJlJujpRkpw497IRrg6aWCpSaE+uaFVlG+jfiyg/lEuwimwQp7rwcM7vmfNTMrAmiBfnz4guTBpUia4fS+dheFYhwBvHg40Y4m2SzTbQTgIoRMeVzjoBocb3wsZMomHCla09E/o2eFq/srfdr2qNmvbbZ2+HcJFPKFjJXdMZad+im0tPKHV0cA2dh/JOuAgN41WELnOrAilx7TqGhJa95O1tUjaA35Ht+XdPfZH8CtprrrRwFxjFvuPjSAGBwOo+UsRaOYQHyEuW3ZJLgwzrOFhm1ahkYgwjf5DCPlrdGGgQXA4Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/yVqd+WaqW9hghXq5ragWGEAJ3AhWkF17b5SNozUHbk=;
 b=YpAhzWTRprwuEaMVz/BSYXXE251J2D4HwdPQ8B/EgMWR0+Y6HQ5ljjlJbNyv9MFzgeALb5Bt6y4XWeyeJu2C4OOkucBvxS7GUA+jqKV6Tc2Yhbx5ULiMIdmtMSFoFlxWKjkI2SDH/IUlVfIGWeqVTYdwTPTAG7ZUwQp8tF/HH0I=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2696.namprd15.prod.outlook.com (2603:10b6:a03:156::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Mon, 14 Dec
 2020 07:01:52 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3654.025; Mon, 14 Dec 2020
 07:01:52 +0000
Subject: Re: [PATCH v2 bpf-next] bpf: increment and use correct thread
 iterator
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     <netdev@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
References: <20201204034302.2123841-1-jonathan.lemon@gmail.com>
 <2b90f131-5cb0-3c67-ea2e-f2c66ad918a7@fb.com>
 <20201204171452.bl4foim6x7nf3vvn@bsd-mbp.dhcp.thefacebook.com>
 <e6e8dd8c-f537-bea8-93ac-4badd3234c85@fb.com>
 <20201211163017.3fjxnuickl2m523m@bsd-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c1d02027-80d4-2d2c-a254-ccd4c7fa2239@fb.com>
Date:   Sun, 13 Dec 2020 23:01:49 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <20201211163017.3fjxnuickl2m523m@bsd-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:c9f6]
X-ClientProxiedBy: SJ0PR05CA0069.namprd05.prod.outlook.com
 (2603:10b6:a03:332::14) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::112b] (2620:10d:c090:400::5:c9f6) by SJ0PR05CA0069.namprd05.prod.outlook.com (2603:10b6:a03:332::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.15 via Frontend Transport; Mon, 14 Dec 2020 07:01:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c912dcc8-3a58-4d09-7548-08d89ffe2277
X-MS-TrafficTypeDiagnostic: BYAPR15MB2696:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2696E130791A1F9441391A9AD3C70@BYAPR15MB2696.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SkqWIjfjUKFN6nJ1FTTkctQtFLTqrO/u+jJPDa2cykXse+zLhq7vuU0FpeuDL7pU0wwqdqCC3Ow1mqdUv8/8ReiuPqobGJVXav00gymI8uoT2pNKWPegje8Jwwa1ilXFN3JADZxmMl9MdQsZd7HkkGQDjjZCA3wrn1FbSYACRlgOiBIB89nkKE3euFttwVQfuQ/5xhn9qQJORcJOUow9nuxVx87T7AYGNcSanYHU0I3l3Jw6fzEvPP+dIGMAbhrQ9LoBFfJtvpKXBqvVdQzPt0GCt3J3cOIYnbvvuh7axG4N6XAqk3ytMXbfwvCLUTKjhFqUA4gl4bKnkgguAE2lGe1e51CJuDD6iXhIASq8CNYLk60mVA/7TG1T4ZI67nlj+GcqcttgwSEuG13qCy0uRDIChrFk/7pmlL1RQ0NYYao=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(346002)(5660300002)(66476007)(4326008)(8676002)(36756003)(66946007)(8936002)(2616005)(508600001)(31696002)(66556008)(186003)(86362001)(2906002)(52116002)(31686004)(53546011)(6486002)(6916009)(83380400001)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MVdnb2dFVmt4dTBLeklyN0c3MEpNaWF3ZTRyNzZteXRNdmE3bCtkbmF0cTBj?=
 =?utf-8?B?RDhCemcyUS9wTWI1Zk9sZXMxWkZxdFIrV2NiQUFuV0ZrUVZmTnB4UW9ucGZv?=
 =?utf-8?B?ZkxXZ0p2NG05R0F4UERrK0NtTEdLbXlibHhBRjdOMElRSzFHUVFIZGRwNE1t?=
 =?utf-8?B?OTB3QVdCSnFkNmhocU9xUWwrS3RxbnphT2hRQTNQYlNsVi9sYmd0UTZLTHB6?=
 =?utf-8?B?T0hHTFpTU3BSZXBROUhSWXoxZlhkY1RIKzdCUVowQVExNVBRb2lkSk5YRHRB?=
 =?utf-8?B?K1FROFdMRmJzSm1nK3JjNllYRFZ2UGpVeDFjTXRjVEtOb2VPT0lzUmtvUHNB?=
 =?utf-8?B?dkVuK2RXUUl1U1NTRGhwRitOK0ZRUkpIVm9Ja0xDUHgyUFhKQzgyNTJGeHdw?=
 =?utf-8?B?YjRndjc5Qy9XY3IzaTIzdUNtbnRjeGIrYndGVEI1Z09xNXgzdWNEN3paejVu?=
 =?utf-8?B?R0NpWHl2akhGSWdIMm1lN2hoMFRZZ1ZkNWRhNXljcUF4WXJ0TE9JaFQ4ckth?=
 =?utf-8?B?R2h0d0hXakJUNG51djRNQnBUTUQ2RUxianlobVBvOC84Y1k5MnNqTkh2SDZS?=
 =?utf-8?B?VUp1MTErRmw4eGJYTXN6Zm9CaVVNRXdvaXU2c3JJTGhvVXZ4VWVDSS9leDVQ?=
 =?utf-8?B?QW0rQmxoVmUxV1lmWklhZHVBdlI5bGFTbHcydVJKeDdqQlNQeDg0bEZjYW5Z?=
 =?utf-8?B?U0V4VFE1MDhvcDYveXFSYit6UnVhTWpJSjlxV2tnMjNMMmp2OGNJbWFMOTdH?=
 =?utf-8?B?V2dobmZVN0laK3F3YjdvVDhkOEtTaGdZR3FCUXdMTDR0TjZ1cEVCK1VUcFZD?=
 =?utf-8?B?bnRFTFVLajlka3I5V2xkQ2dCT1M5Y2JqYlg4U2ZUWTRlQ3V6RHVwWGt5UlBr?=
 =?utf-8?B?S2lFTTZSajYwQnpsNFFtcnE5UzZrWlg1VU5lZjlTV3NRbEtFN0JJRGlOUjRH?=
 =?utf-8?B?ZUxmMEJYdUszTCsvQ0tSbWVHWmszeVhzRFpLMCtack1ROVh4UC9WcytubVNv?=
 =?utf-8?B?NTBSM2VKTmNRTFRSMzU2Y2x6UFc2aFZsYWtwSk15L1R5MGluVDFFZXUrNDc1?=
 =?utf-8?B?Y0k5Q3lqWVBDbytzTFRJdWFFMzJYa1NPaS9FeFZWQmlGaitmbTZoSnV3RmZT?=
 =?utf-8?B?RUszc3g5eHVqMU1lZkpab3pVQ2VmUC9aN09MRWdzRVpld0RhZSt3Z0xDZWhG?=
 =?utf-8?B?bXJCUVArbEp4OW1ZTjRyZTlsM2d1TW1HQkQvU0dydEw5RytSakRISTlMMzRJ?=
 =?utf-8?B?eFYyWW9JYzM3RnE2TE52R3I3ZHpvY1B6Sk1PQm5QcjF1Ync3bloyQUlIWWJW?=
 =?utf-8?B?Q2FxYVJVSVg4d2NveW1lVVcrWFlWNGozWit1UG9HNWxBMkpPdzJRc2hyY0Y3?=
 =?utf-8?B?cGxlM0oxQUdsWXc9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 07:01:52.0339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: c912dcc8-3a58-4d09-7548-08d89ffe2277
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: flSzB07Q3L2GMQLZK3NxkDqg5jGBxjBQRNpLHd2px2PxlydLjU6mRWcj89fWTt8h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2696
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_03:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 spamscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140053
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/11/20 8:30 AM, Jonathan Lemon wrote:
> On Wed, Dec 09, 2020 at 11:02:54AM -0800, Yonghong Song wrote:
>>
>>
>> Maybe you can post v3 of the patch with the above information in the
>> commit description so people can better understand what the problem
>> you are trying to solve here?
>>
>> Also, could you also send to bpf@vger.kernel.org?
> 
> Sure, I can do that.
> 
>>>>> If unable to obtain the file structure for the current task,
>>>>> proceed to the next task number after the one returned from
>>>>> task_seq_get_next(), instead of the next task number from the
>>>>> original iterator.
>>>> This seems a correct change. The current code should still work
>>>> but it may do some redundant/unnecessary work in kernel.
>>>> This only happens when a task does not have any file,
>>>> no sure whether this is the culprit for the problem this
>>>> patch tries to address.
>>>>
>>>>>
>>>>> Use thread_group_leader() instead of comparing tgid vs pid, which
>>>>> might may be racy.
>>>>
>>>> I see
>>>>
>>>> static inline bool thread_group_leader(struct task_struct *p)
>>>> {
>>>>           return p->exit_signal >= 0;
>>>> }
>>>>
>>>> I am not sure whether thread_group_leader(task) is equivalent
>>>> to task->tgid == task->pid or not. Any documentation or explanation?
>>>>
>>>> Could you explain why task->tgid != task->pid in the original
>>>> code could be racy?
>>>
>>> My understanding is that anything which uses pid_t for comparision
>>> in the kernel is incorrect.  Looking at de_thread(), there is a
>>> section which swaps the pid and tids around, but doesn't seem to
>>> change tgid directly.
>>>
>>> There's also this comment in linux/pid.h:
>>>           /*
>>>            * Both old and new leaders may be attached to
>>>            * the same pid in the middle of de_thread().
>>>            */
>>>
>>> So the safest thing to do is use the explicit thread_group_leader()
>>> macro rather than trying to open code things.
>>
>> I did some limited experiments and did not trigger a case where
>> task->tgid != task->pid not agreeing with !thread_group_leader().
>> Will need more tests in the environment to reproduce the warning
>> to confirm whether this is the culprit or not.
> 
> Perhaps, but on the other hand, the splats disappear with this
> patch, so it's doing something right.  If your debug code hasn't
> detected any cases where thread_group_leader() isn't making a
> difference, then there shouldn't be any objections in making the
> replacement, right?  It does make the code easier to understand
> and matches the rest of the kernel.

Agree. Let me do a little more experiments to double check we
did not miss anything with this particular change and will
report back later.

