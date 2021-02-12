Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAC7319809
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 02:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhBLBmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 20:42:43 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45714 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229469AbhBLBml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 20:42:41 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11C1eMNf012494;
        Thu, 11 Feb 2021 17:41:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=lcGCtLYwd7g99O3Iqpf5ZmbOKJs9KxWEW5KCk7SGFEg=;
 b=Ps0MqtgEDDwfz+kRK3kAt+gJFA8jYrQzHFkEblO0MoES6q+OaPnyyrGt9ODReQYLQzEY
 bInjIH6qD0R+MpQaNgRL8Uf+yxguJjLZH5lChYRhaPegRJFh/+sRcI/3fmo1d6pcdIZQ
 QPZc6g62E33hWaOOj98TgUNV9h/vVMwnYNw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36mh2u2hmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 11 Feb 2021 17:41:44 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 11 Feb 2021 17:41:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=alugvi4fKT80AZwR8pe+cTfbQ9P/+aZ/sf00OfeaHT7FQHVBj3NPZPZlVWfSXzv8ip/2aAKsw4Ho+vrmZeyvR7xNi6+bGZis0FG9XUEt8rOPUgd/hAlw1Fj5r5iiTNCkBWc3KfHsNkuwcS27PuSXvu3r2/MLVn47ReB47z6nBAcYlAeix/7ULdxp9MCHj3zm0SDErs3nc+S+nuJnQrtKnaKErixIirYpjwhDt28hBOH8HtzH5OMfjcz2f8YTFQLnn7AJQXgO8QZ+XTZrtXpFZD1IuEx6D6aRyAlnAYQbqj1mM6XczKvIV8CspEVq2HPP7a2RPu3hHrib41cRg0teKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lcGCtLYwd7g99O3Iqpf5ZmbOKJs9KxWEW5KCk7SGFEg=;
 b=dKIH7BVvSReZOPbgIQ3f52MMYeaxBqYNCRE95eevidOACzCYqPcld/+cRPCvWoddMOhssVthQ9Ta8SRMJ/ZDuRTNMLO/KhiK7ZGoPKOPOPExHm9U104ciBBq2+sbNu9pT3KBw45BbL4mAR36f5mrM48cDjpUwywIheYEsS9nNU2lrn/sRh/3wi0mh80KeszcUFQlLKpKlLf8jKpbKW/8wA7XOhwPskNYFhGjCuWT+wve5QIUNjzoUj7kU5cLYPOMZ+sTlQZAoIMLM6w+GZuKYHlEslBgsnBHY/nlfsQbpVAGGvia4Jh/RV4y/poBj47QmQF4o+IGBOcc+hJculIYyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2456.namprd15.prod.outlook.com (2603:10b6:a02:82::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Fri, 12 Feb
 2021 01:41:39 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3763.019; Fri, 12 Feb 2021
 01:41:39 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     Alexei Starovoitov <ast@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Thread-Topic: [PATCH v5 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Thread-Index: AQHW/m0zn7SokiCS2ku6SkhP+3YCzKpQWLuAgAAKuoCAAFGDgIABT80AgAG+yQA=
Date:   Fri, 12 Feb 2021 01:41:39 +0000
Message-ID: <D15D961F-A414-45AF-93EB-D76FB6744CBD@fb.com>
References: <20210208225255.3089073-1-songliubraving@fb.com>
 <20210208225255.3089073-2-songliubraving@fb.com>
 <20210209213031.v4wzzka7nth7xzq5@ast-mbp.dhcp.thefacebook.com>
 <6846C89A-5E5F-4093-96EF-85E694E0DA4A@fb.com>
 <0967837f-04c7-4c94-aa28-2b14b5d816df@fb.com>
 <fa4801f7-c31b-9518-4092-144391c715a2@fb.com>
In-Reply-To: <fa4801f7-c31b-9518-4092-144391c715a2@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
x-originating-ip: [2620:10d:c090:400::5:3a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc6598f6-a864-40c6-f3a6-08d8cef757c0
x-ms-traffictypediagnostic: BYAPR15MB2456:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB24569383318F1582FEE8CD7EB38B9@BYAPR15MB2456.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K7QRfTRD8VZoX7PAgeXAb3yJSYnpLY3hYpXQFuXyvBdZRsIBIS86ZgdUafFZg/5nEfYPaTcjBBA6hkHdH6lo7pXSnWeMqYLbDirccnlGRkG5RxLjdtJW6OB9YJzH8Pvpi0kj/qh2NqzSmKMO5hVuWHWoyU1FmPxmS/Sf9EXoj76Wh/wTd5Y/Jd690hSSUOg9q/4pKz7UgD2XmduUb1zK+AELAVazABA03Kb//ws/CjK7H9IWNzlBZHM9PsEpqw+XJE2DF9xpgji4HLX1/SNMI0/igjXg9EA4urPjDJMZkCd8beXA/vZQcnWO9dEkSLwB7VdXtpDw98u2NpkMoWK/xzmslSygD8FsOoRP0yTZSUqxyCr47cOzanMZKTC/5GHnNxTH+NGX9hyk+GKGDKJag8deoQBwydM1ZByZK0uRYBz32LtKNlfPhDOtAfJ2nSq1W6lV5bqIszSZTgA0dm32mIMtT7JJdX7oHWrCFikncAmZfs06EZMdh2OlgosyCBhcaJoQ9rDLbpBih/3zjxmekOtfnOqcjKPvv+2AWi69ozABoEFI/5fn6DJ1KLMv7p0GQbsmT/KGfnHE4St8MSQn/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(136003)(346002)(366004)(5660300002)(86362001)(186003)(478600001)(76116006)(83380400001)(2616005)(6512007)(8936002)(6486002)(37006003)(36756003)(91956017)(66946007)(316002)(53546011)(8676002)(6862004)(2906002)(71200400001)(4326008)(33656002)(66446008)(6506007)(66556008)(66476007)(54906003)(6636002)(64756008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?CqoEQUSD9G8fFKu9r32sZxXY+kVatsEeGjvNKArm5X2+d0lts1HWgYNOU/Fv?=
 =?us-ascii?Q?lIAtxEO1Du7GaTF01RxVuhGjqOJ0Df07jrPQ6sTnbHt9Fcx+TSfmEb9VHzZ5?=
 =?us-ascii?Q?woe10dtJjNU2cbIA8SGGTIr4Cwp8W5fqCR/4+xUyZf1UTgjP7krDMKWwM1ka?=
 =?us-ascii?Q?tCxfWD+iejUqtqYyQr2EFzFMpN39yTFgwwL3d/JWktsPQy2/Bwo3kSr6/6Sk?=
 =?us-ascii?Q?J9jyTd5PYlSHBqHqmn1/LVnIu5tGAseWfxRGrkPkXkxIKe37TJ7NpmmeBJor?=
 =?us-ascii?Q?cSO+B0TckuLJaQ5ehQL141B6VqZQZfQpiXF6AhLy6FTq8KNrovrHswOqPWIT?=
 =?us-ascii?Q?EHUjGgms/ZAQk9FXiJCEv4La16LM/4cD4EoipK5YXaqi4+QFhInzev51zdjU?=
 =?us-ascii?Q?321+6bs7aKx/DMpH6O22z8zxtikbBVeEbAQi7hXZNAkvAveqaFcpypcQM+CT?=
 =?us-ascii?Q?dyGVW6cMDoDjwat2nDtUPMNh4BzdpOArTr86SCqhbam7zpHXw28AQ6kkYhC+?=
 =?us-ascii?Q?L31FKn9YHeEhWX5zMWFXvISBtHdwb1J7g/IZEDEb2AKSCDBcwJNIy+epIRiO?=
 =?us-ascii?Q?lAM1GbJP04+V1nyVegMIhWrbptN6+j0Ld0B2T4B3kp+11TowHSQI2ZzG6O7v?=
 =?us-ascii?Q?R1jLnV5tyRcRbdUIozLv9sk7/R3Jvvhikb9y0RjwE0j9BYMK8oqzc5d5Rmah?=
 =?us-ascii?Q?MS2+UyMWQ/PKUD2mOEBd+ge5DgVHbzUh6q368gsv4fCdSAJpKbDX861MIwGk?=
 =?us-ascii?Q?OAWyNsdmy4P58hrWoVefhaL0lBG5c7epBKjVIGk3nIjnnHtQQVV90g3IzcrZ?=
 =?us-ascii?Q?r+Q1LZ2LtkStPSn4GNYnDxn0I47CxVNygLIuyL32xQZEHtQpVerrSG1kJyi4?=
 =?us-ascii?Q?BG+8FuHjC5zvdEfGVgDDXYcu6xdKT6WA6UyrfNH60JRzy73m6TNAXTC4deHf?=
 =?us-ascii?Q?aBljXALwcjNQch5bG5NTATKELhwMLRLS7XM5QU0akk+HXv2mhJO9wlA9LHcH?=
 =?us-ascii?Q?VOOPISgODOnKjFdmUgxHYRAaxFP9CRyLHXZI5AYFLXtryjbbpQh0g0VUfOv5?=
 =?us-ascii?Q?G8m+jXz4suanNeUbdu4yYQkHGrLakzwAQ2SG/e5W+zf5vCH6dXpJkFK/6bNh?=
 =?us-ascii?Q?YyuUBy3otRX/HIao9r6L5U4gAjJrnGwfmywGyN5XHdTbyp9XqCkQ18uvNTzL?=
 =?us-ascii?Q?yTqbouLfkxR14diEvTSYotjmikm221VkfrvsY8p1njnP2mUal/OREg9A/WZn?=
 =?us-ascii?Q?/exKS6bl2M08wERu7AU2ThqVn4nA9KA43ao8PDztZLMaPbTn8KcvWuMvKMTl?=
 =?us-ascii?Q?ViWCYexOpBW9t5j64j+vq2QVxpWA3y0v1287akQcOc0QOf2IFDx0cfXyKNwa?=
 =?us-ascii?Q?F8sW9kk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9CD53508A3AB8C4D9111FDF0F8B91E5A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc6598f6-a864-40c6-f3a6-08d8cef757c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2021 01:41:39.7042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LsjnBT28Auw7cHW7HdT36+LAF0Bg4hsOhLPTR0xDg5sNy1lwSDieGx9Iar4oz5JaUyoIe2KoPLQpVSHZKa3Jfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2456
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_07:2021-02-11,2021-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 phishscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120009
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 10, 2021, at 3:02 PM, Yonghong Song <yhs@fb.com> wrote:
>=20
>=20
>=20
> On 2/9/21 7:00 PM, Alexei Starovoitov wrote:
>> On 2/9/21 2:08 PM, Song Liu wrote:
>>>=20
>>>=20
>>>> On Feb 9, 2021, at 1:30 PM, Alexei Starovoitov <alexei.starovoitov@gma=
il.com> wrote:
>>>>=20
>>>> On Mon, Feb 08, 2021 at 02:52:52PM -0800, Song Liu wrote:
>>>>> Introduce task_vma bpf_iter to print memory information of a process.=
 It
>>>>> can be used to print customized information similar to /proc/<pid>/ma=
ps.
>>>>>=20
>>>>> Current /proc/<pid>/maps and /proc/<pid>/smaps provide information of
>>>>> vma's of a process. However, these information are not flexible enoug=
h to
>>>>> cover all use cases. For example, if a vma cover mixed 2MB pages and =
4kB
>>>>> pages (x86_64), there is no easy way to tell which address ranges are
>>>>> backed by 2MB pages. task_vma solves the problem by enabling the user=
 to
>>>>> generate customize information based on the vma (and vma->vm_mm,
>>>>> vma->vm_file, etc.).
>>>>>=20
>>>>> To access the vma safely in the BPF program, task_vma iterator holds
>>>>> target mmap_lock while calling the BPF program. If the mmap_lock is
>>>>> contended, task_vma unlocks mmap_lock between iterations to unblock t=
he
>>>>> writer(s). This lock contention avoidance mechanism is similar to the=
 one
>>>>> used in show_smaps_rollup().
>>>>>=20
>>>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>>> ---
>>>>> kernel/bpf/task_iter.c | 217 ++++++++++++++++++++++++++++++++++++++++=
-
>>>>> 1 file changed, 216 insertions(+), 1 deletion(-)
>>>>>=20
>>>>> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
>>>>> index 175b7b42bfc46..a0d469f0f481c 100644
>>>>> --- a/kernel/bpf/task_iter.c
>>>>> +++ b/kernel/bpf/task_iter.c
>>>>> @@ -286,9 +286,198 @@ static const struct seq_operations task_file_se=
q_ops =3D {
>>>>>     .show    =3D task_file_seq_show,
>>>>> };
>>>>>=20
>>>>> +struct bpf_iter_seq_task_vma_info {
>>>>> +    /* The first field must be struct bpf_iter_seq_task_common.
>>>>> +     * this is assumed by {init, fini}_seq_pidns() callback function=
s.
>>>>> +     */
>>>>> +    struct bpf_iter_seq_task_common common;
>>>>> +    struct task_struct *task;
>>>>> +    struct vm_area_struct *vma;
>>>>> +    u32 tid;
>>>>> +    unsigned long prev_vm_start;
>>>>> +    unsigned long prev_vm_end;
>>>>> +};
>>>>> +
>>>>> +enum bpf_task_vma_iter_find_op {
>>>>> +    task_vma_iter_first_vma,   /* use mm->mmap */
>>>>> +    task_vma_iter_next_vma,    /* use curr_vma->vm_next */
>>>>> +    task_vma_iter_find_vma,    /* use find_vma() to find next vma */
>>>>> +};
>>>>> +
>>>>> +static struct vm_area_struct *
>>>>> +task_vma_seq_get_next(struct bpf_iter_seq_task_vma_info *info)
>>>>> +{
>>>>> +    struct pid_namespace *ns =3D info->common.ns;
>>>>> +    enum bpf_task_vma_iter_find_op op;
>>>>> +    struct vm_area_struct *curr_vma;
>>>>> +    struct task_struct *curr_task;
>>>>> +    u32 curr_tid =3D info->tid;
>>>>> +
>>>>> +    /* If this function returns a non-NULL vma, it holds a reference=
 to
>>>>> +     * the task_struct, and holds read lock on vma->mm->mmap_lock.
>>>>> +     * If this function returns NULL, it does not hold any reference=
 or
>>>>> +     * lock.
>>>>> +     */
>>>>> +    if (info->task) {
>>>>> +        curr_task =3D info->task;
>>>>> +        curr_vma =3D info->vma;
>>>>> +        /* In case of lock contention, drop mmap_lock to unblock
>>>>> +         * the writer.
>>>>> +         */
>>>>> +        if (mmap_lock_is_contended(curr_task->mm)) {
>>>>> +            info->prev_vm_start =3D curr_vma->vm_start;
>>>>> +            info->prev_vm_end =3D curr_vma->vm_end;
>>>>> +            op =3D task_vma_iter_find_vma;
>>>>> +            mmap_read_unlock(curr_task->mm);
>>>>> +            if (mmap_read_lock_killable(curr_task->mm))
>>>>> +                goto finish;
>>>>=20
>>>> in case of contention the vma will be seen by bpf prog again?
>>>> It looks like the 4 cases of overlaping vmas (after newly acquired loc=
k)
>>>> that show_smaps_rollup() is dealing with are not handled here?
>>>=20
>>> I am not sure I am following here. The logic below should avoid showing
>>> the same vma again:
>>>     curr_vma =3D find_vma(curr_task->mm, info->prev_vm_end - 1);
>>>     if (curr_vma && (curr_vma->vm_start =3D=3D info->prev_vm_start))
>>>         curr_vma =3D curr_vma->vm_next;
>>>=20
>>> This logic handles case 1, 2, 3 same as show_smaps_rollup(). For case 4=
,
>>> this logic skips the changed vma (from [prev_vm_start, prev_vm_end] to
>>> [prev_vm_start, prev_vm_end + something]); while show_smaps_rollup() wi=
ll
>>> process the new vma.  I think skipping or processing the new vma are bo=
th
>>> correct, as we already processed part of it [prev_vm_start, prev_vm_end=
]
>>> once.
>> Got it. Yeah, if there is a new vma that has extra range after
>> prem_vm_end while prev_vm_start(s) are the same, arguably,
>> bpf prog shouldn't process the same range again,
>> but it will miss the upper part of the range.
>> In other words there is no equivalent here to 'start'
>> argument that smap_gather_stats has.
>> It's fine, but lets document this subtle difference.
>>>>=20
>>>>> +        } else {
>>>>> +            op =3D task_vma_iter_next_vma;
>>>>> +        }
>>>>> +    } else {
>>>>> +again:
>>>>> +        curr_task =3D task_seq_get_next(ns, &curr_tid, true);
>>>>> +        if (!curr_task) {
>>>>> +            info->tid =3D curr_tid + 1;
>>>>> +            goto finish;
>>>>> +        }
>>>>> +
>>>>> +        if (curr_tid !=3D info->tid) {
>>>>> +            info->tid =3D curr_tid;
>>>>> +            op =3D task_vma_iter_first_vma;
>>>>> +        } else {
>>>>> +            op =3D task_vma_iter_find_vma;
>>>>=20
>>>> what will happen if there was no contetion on the lock and no seq_stop
>>>> when this line was hit and set op =3D find_vma; ?
>>>> If I'm reading this correctly prev_vm_start/end could still
>>>> belong to some previous task.
>>>=20
>>> In that case, we should be in "curr_tid !=3D info->tid" path, no?
>>>=20
>>>> My understanding that if read buffer is big the bpf_seq_read()
>>>> will keep doing while(space in buffer) {seq->op->show(), seq->op->next=
();}
>>>> and task_vma_seq_get_next() will iterate over all vmas of one task and
>>>> will proceed into the next task, but if there was no contention and no=
 stop
>>>> then prev_vm_end will either be still zero (so find_vma(mm, 0 - 1) wil=
l be lucky
>>>> and will go into first vma of the new task) or perf_vm_end is some add=
ress
>>>> of some previous task's vma. In this case find_vma may return wrong vm=
a
>>>> for the new task.
>>>> It seems to me prev_vm_end/start should be set by this task_vma_seq_ge=
t_next()
>>>> function instead of relying on stop callback.
>> Yeah. I misread where the 'op' goes.
>> But I think the problem still exists. Consider the loop of
>> show;next;show;next;...
>> Here it will be: case first_vma; case next_vma; case next_vma;
>> Now it goes into new task and 'curr_tid !=3D info->tid',
>> so it does op =3D first_vma and info->tid =3D curr_tid.
>> But we got unlucky and the process got suspended (with ctrl-z)
>> and mmap_read_lock_killable returned eintr.
>> The 'if' below will jump to finish.
>> It will set info->task =3D NULL
>> The process suppose to continue sys_read after resume.
>> It will come back here to 'again:', but now it will do 'case find_vma'
>> and will search for wrong prev_vm_end.
>=20
> Thanks for catching this. I have discussed with Song about return value
> for mmap_read_lock_killable(). We only considered ctrl-c case but
> did not realize ctrl-z case :-(

Actually, we don't need to handle the ctrl-z case. Ctrl-z (or kill -STOP)=20
will not cause mmap_read_lock_killable() to return -EINTR. I also confirmed=
=20
this in the experiments. Something like the following will occasionally=20
trigger mmap_read_lock_killable() to return -EINTR,

  cat /sys/fs/bpf/task_vma & sleep 0.0001 ; kill $!

while the following (using kill -STOP) will not:

  cat /sys/fs/bpf/task_vma & sleep 0.0001 ; kill -STOP $!

Thanks,
Song

>=20
> Song, you can return a ERR_PTR(-EAGAIN) here. This ERR_PTR will be
> available to your seq_ops->stop() function as well so you can handle
> properly there too.
>=20
>> Maybe I'm missing something again.
>> It's hard for me to follow the code.
>> Could you please add diagrams like show_smaps_rollup() does and
>> document what happens with all the 'op's.
> [...]

