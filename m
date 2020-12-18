Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353292DE788
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 17:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731636AbgLRQjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 11:39:46 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34048 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731549AbgLRQjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 11:39:45 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BIGZlmd002902;
        Fri, 18 Dec 2020 08:38:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=988+ewyB1SH2uOFJVBQP5D+EamFmAmQ4hUo7pEbROhM=;
 b=Pmfgj/yH2pg+XOVpWCKhNQE7GfaCkhlOH8HA1PkrP1AnPClziLNEcpeSIk6P7TVIfzDv
 nuqBBGF/uHPl6i6feB5Atd7USf67jUJ311Sqg/gCU05keY28284VkdPZKLlAoXlnmP6S
 DjaAuQlsJOnyY2z608PFHouwkT11vEF2at8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35gwa88y08-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 18 Dec 2020 08:38:50 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 18 Dec 2020 08:38:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EjpByq0+gf/xX5drLtlkpdPjp8kbnTsAtpBiq15xbzOM9icbgrnwz+Fg+9YjxLW7Iscw5i/muir08ONk4ptWGZkkwC15z/weKVBUNg68OL7ZM/7rLNDmonP9cShps+YPa/Jd764zMUBZCyci5NR0+HoZDe3dMK4K2ZuFAuRO/uWojiTQHBJReLpwbkLbXcZq+usf3St57eHRe082UUSzO5/fZw/uiChngD+DPh+uzWmZtIqUSfrlBsa+1XV44JUDYp/300wmBeBw9AXDHjtLTrWzDdv8I98fDySe+apugKcuKN0+9aXJ78ok7QRCABqls3CbCOS9DKixnZd+6uMbxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=988+ewyB1SH2uOFJVBQP5D+EamFmAmQ4hUo7pEbROhM=;
 b=PUJYcYis8za2XpB3LfvnN4R1Ba+/UGnmJDP9L8Hy3YvpaufkaOVE5RLwrzKTteIulN3y++4+Cfw8ouzxjqfGmWQ9WjrPT8OCfZFhZlbQEUKxpARIBMtBGsfR8oSr6O0uzP721GaBwnqlp3M7m+ExbXCuumvK+1UeSslEJtJzDybHjmg8UmyY8MuJXrZtHygkey0nHJocVwQCgzSsAQjNXpe6mmuvIjnMkXhPQo/oWTxJjj8UVs8gmC8uPv7Qbs9+xA8pdVk8Xx7qK2MK/Y8pZlJQZyhatfpjTzsJofa4dPNxYmiix0TIThK8KrYc9VV0xFgO0pvNN8hh52Dytd7BJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=988+ewyB1SH2uOFJVBQP5D+EamFmAmQ4hUo7pEbROhM=;
 b=VVQ9CCq6eIFISy0e6yXR1TReieWtk4mflfvVjMx5M/FxSgTxxaZicEp+pmrPl4oqROWG2ieLLUf9EEVt4CbygUR1mVNxTcPh0v2yYOV17QicRWnzD2NxhoK7cUe5LcR5wPcc6xhs/W4XoJx1KareTawXzY/0nucsaY5g6+Mg7gs=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3572.namprd15.prod.outlook.com (2603:10b6:a03:1b2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Fri, 18 Dec
 2020 16:38:43 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3676.025; Fri, 18 Dec 2020
 16:38:43 +0000
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <songliubraving@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-2-songliubraving@fb.com>
 <20201217190308.insbsxpf6ujapbs3@ast-mbp>
 <C4D9D25A-C3DD-4081-9EAD-B7A5B6B74F45@fb.com>
 <20201218023444.i6hmdi3bp5vgxou2@ast-mbp>
 <D964C66B-2C25-4C3D-AFDE-E600364A721C@fb.com>
 <CAADnVQJyTVgnsDx6bJ1t-Diib9r+fiph9Ax-d97qSMvU3iKcRw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <231d0521-62a7-427b-5351-359092e73dde@fb.com>
Date:   Fri, 18 Dec 2020 08:38:39 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <CAADnVQJyTVgnsDx6bJ1t-Diib9r+fiph9Ax-d97qSMvU3iKcRw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:8460]
X-ClientProxiedBy: MW4PR03CA0331.namprd03.prod.outlook.com
 (2603:10b6:303:dc::6) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::119f] (2620:10d:c090:400::5:8460) by MW4PR03CA0331.namprd03.prod.outlook.com (2603:10b6:303:dc::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 18 Dec 2020 16:38:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47a1db68-8d2e-41f4-2fe3-08d8a37361f7
X-MS-TrafficTypeDiagnostic: BY5PR15MB3572:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB35725B860463D32955C8607AD3C30@BY5PR15MB3572.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: voOkCbR6z0uRV8CzFTqonGIV2iRJPX6Q6DlYbV5SYnvXb5aIbRZxh7xB7VlIsoP2FHpZLBdfOpL3C4Wm3KfFmb4hMorIiLVG02bXK8n9Uhjgz8q+0OOovYcUOOoAm4fg0VJtWLpmN6c4s5U1KnHD/Y7jJG5NYeIit/1c4CTYLGI8bWg3wLpeuEUb0E7tE9YTbprbD1l6N6MHoN3453rvhsi1IwZqtVB8vvw0GMlL8nE+VB264EwOr92tqLDzSuHvFhojUFzPNSaNNy6JypOT5EH+ROLyiJPCJiXld8YiLfLIq1cXKSpk1eRFxP2EPpcXtpNGQS293kV9sI1Kc7t8hSGIMXe2KJuDDgsFPB6ru3lhWYg+DLhzgyVTTDCbIkFcEpEr2Qwd3PwHAUxXhru69w6BkJXE6tVYZR/39L0TqFAGAO0TP7u9cN8oCmOgKrAH0T6dYYSXmrycUstOq0kxjHAu1I+LjffVwuigl3ah4uk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(346002)(136003)(376002)(4326008)(83380400001)(8676002)(2616005)(110136005)(316002)(53546011)(31686004)(6486002)(66946007)(54906003)(186003)(16526019)(8936002)(36756003)(86362001)(478600001)(52116002)(66476007)(66556008)(5660300002)(6636002)(2906002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eWN6bXJYelVEVDFuRjlLMFRVZ0FIdDVIS2g2YkxhY1IvRXVqOXdIQTBCWkpT?=
 =?utf-8?B?NVRHTmo0OTBYb3VlRExteG00YVRKb3pHQXVPS2YyNld2b3YrSzRQeXNTNlox?=
 =?utf-8?B?cnEyeit5V1VwdzdyYlYzZjdPSnpLYXlJMHoxNXJIK2lFMUpMNXpGeXBlZTVj?=
 =?utf-8?B?QVJkc0JCWUZoM1BnNVFkeCtDUU5ORExtNkZvYWw2NUcyR3k2OHU0OEFpMksw?=
 =?utf-8?B?TWVGR2ZzN2JJak1TMUhoazF4eXp3eUFxdUJBTEtlWHBHYmRKRlVxbVhVREcw?=
 =?utf-8?B?TC9tL2p6aXhwSzRsTE1kSk41Qm9uUXJMNjdGeFI1UkZNTTRPRm1KN2svNytN?=
 =?utf-8?B?eG5oVThuZ002c3hvSWk5OUpFTGtIcks3R0d5L0lDTEJPL1JZbzFWenZ5YkZI?=
 =?utf-8?B?RjVOYm56aFpzU1BySEhscVpwZTcxRFg3SEhnOXF3VHcweEkvU2FJOXJBcld3?=
 =?utf-8?B?NHdQMEVyeHlwanZjSjA2eGtFL0M5QVhhVm5QVmFtQldJTW9RUzhwYmd4QmtJ?=
 =?utf-8?B?Rlh2VEx6WEJvcW1Ed2RqeDdFTDZLVXRxekN5MGNTUUg1QXd4eER3K1BSYWs3?=
 =?utf-8?B?eElxeVNjTEpMc2xjblJmME5GQ1N2VHdrS3JUczNxaFpOMkNTSElubG1tb0tv?=
 =?utf-8?B?amszWXB4L3VYa0pEeENiQnJFWDR3L2tWLzB3bDR3Y01SUE14a242TFV0dkp6?=
 =?utf-8?B?ZHU4Kzg3TFRRMzQ5OVowaDZRMW5OZFRzREJsSzVLU0EyUzFrT3h0VVZySGt0?=
 =?utf-8?B?cVFXcERrQ2RnUUxuU2IvNEpyZ1dwM0l3SzFxUXMvV2JERjUxRUtuNWZOK2s2?=
 =?utf-8?B?NmhiT2ZUL2lKSXQ3emlCeUl4SGtJWmF4OWVlWDF5cVRWMW1OK1NTRnVUY3Vs?=
 =?utf-8?B?cHlvWm8ydVRKb2hJTXdaOCtINlZYaXFWWHlZVmptSkxKMldYRkx3bUR4ZU0x?=
 =?utf-8?B?d0tNL3UwVE5KWXNyT0RwL1ZJRHRMb2Zka0ZKWUhJNmhyS2NRd3M3MHo5QnBZ?=
 =?utf-8?B?Z3hZbTUyMGc2MHVDN2d6clpidE52MzFhbHZwcEdEZUxxRlVJVUJWZWV6ellt?=
 =?utf-8?B?ZDhuc0tkRWk3aEJQRGU1Qm1yQTBIbGZueC9CK0RVczNURHI5a0JMVER4MUZx?=
 =?utf-8?B?ZHVFNGpQd0p1U3k3bE95UFI0NVpvV1hNdUpKVEt4RzB0UTdJMTlkdGxRaVJQ?=
 =?utf-8?B?T3JFYUlGbVEyQ1JmczlPMmdoNjl6TWJnUFJWNmk4emFNN0N3VkhQNmNYL3Er?=
 =?utf-8?B?KzRNZC8vakxHWENzTlFhVXk5THkxYTJDdnlJcnVEakprYmErZHdyUEtxNXc3?=
 =?utf-8?B?d2VtOTd0OVNXZjJROEhpRll2VUgyc09OZjhKQkVVUTBrekVGbk94dk9JK2xG?=
 =?utf-8?B?cnh4V1daS2w2eXc9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 16:38:43.1632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 47a1db68-8d2e-41f4-2fe3-08d8a37361f7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uhHTh41e4e6IqZ06Z7AUh7gTkv9esKLIvbiY31/e1J8Yy/k+ZJ/RR6KdfEib3Fmo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3572
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_10:2020-12-18,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 impostorscore=0 clxscore=1015 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180114
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/17/20 9:23 PM, Alexei Starovoitov wrote:
> On Thu, Dec 17, 2020 at 8:33 PM Song Liu <songliubraving@fb.com> wrote:
>>>
>>> ahh. I missed that. Makes sense.
>>> vm_file needs to be accurate, but vm_area_struct should be accessed as ptr_to_btf_id.
>>
>> Passing pointer of vm_area_struct into BPF will be tricky. For example, shall we
>> allow the user to access vma->vm_file? IIUC, with ptr_to_btf_id the verifier will
>> allow access of vma->vm_file as a valid pointer to struct file. However, since the
>> vma might be freed, vma->vm_file could point to random data.
> 
> I don't think so. The proposed patch will do get_file() on it.
> There is actually no need to assign it into a different variable.
> Accessing it via vma->vm_file is safe and cleaner.

I did not check the code but do you have scenarios where vma is freed 
but old vma->vm_file is not freed due to reference counting, but
freed vma area is reused so vma->vm_file could be garbage?

> 
>>>> [1] ff9f47f6f00c ("mm: proc: smaps_rollup: do not stall write attempts on mmap_lock")
>>>
>>> Thanks for this link. With "if (mmap_lock_is_contended())" check it should work indeed.
>>
>> To make sure we are on the same page: I am using slightly different mechanism in
>> task_vma_iter, which doesn't require checking mmap_lock_is_contended(). In the
>> smaps_rollup case, the code only unlock mmap_sem when the lock is contended. In
>> task_iter, we always unlock mmap_sem between two iterations. This is because we
>> don't want to hold mmap_sem while calling the BPF program, which may sleep (calling
>> bpf_d_path).
> 
> That part is clear. I had to look into mmap_read_lock_killable() implementation
> to realize that it's checking for lock_is_contended after acquiring
> and releasing
> if there is a contention. So it's the same behavior at the end.
> 
