Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0931831607D
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 09:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbhBJICL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 03:02:11 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38826 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233277AbhBJICH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 03:02:07 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11A7xQlu019597;
        Wed, 10 Feb 2021 00:00:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ff37MUaybFW+MpvzUs8iBqENuyFc3qs7q5fvsTqsJ3M=;
 b=YG8h/vIvqGGwTl6SnogBmLPON4h9THfJJXo2jVuS7F51X2CAEtFxpVnZvh5Iukl9WtjD
 PXsl4wPbmNc1yY5EPF109xsZUw+lTc90C6kqh8lGav22ELDIARKeTw+uSrjE06bYVHQA
 TCJVay4jx9TZxm1f35S0xGoZtuTf+VSqWMY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36m5um18e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 10 Feb 2021 00:00:09 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 10 Feb 2021 00:00:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TGF4+Jgbb7cV1KX/Zk5879RXMkobsa+obYJZHidgEMgdc8jbh7DdOaMRKQw+L3cK5yazbXQPzCJrN2pS4I3KPLzSdQN4XrCI4GINhU6S1zRAeXUv9I28bHKPUdA373kjl2NLDreCykD04DkPr0zeysgqUIsbb4Jy36FhUW3xTzYRSX9PymaB7GjzlGVIhVa5btBm4qxslbgkrPtoULPY9D+t77eN4tnXFK1D1hkpJz4trep6SIeuEzM9rRzh0isQa0tOvCleqVLAXkhr8ZCwwqip+NbxKr3Zn12836VXmud0Y4X/KAYDWSm2nK7WL5YC8Z7CxcAc22tiynePLqyaiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ff37MUaybFW+MpvzUs8iBqENuyFc3qs7q5fvsTqsJ3M=;
 b=OH2XZ2RNgGqguPfv1nOH7iEoJFcJxNOGz+Mdcw/qpKgjIcyJtXYU4EKOyjuMqcy4Op3KUohOoYsd8vNgw207XLNQ6HiMXvctpcNg3+AR3pTllyCwUiuYrSPMUTars0unCiQVhLz6AZy1U863jXv57sIHvSCXS8o1F8oaiRBLY4L5ZpMBzedWcmYMC9dSLYJklmL1isF7pQu3R2M5/bL3QBBDEMwUP3Xcj6yIyYUw5TSR2dCMXjmsaIsjeZhfOztlxtsvP1DUPCzcgCcNh+scW9SGbJtwpSjGwizkEggsFUW0oNhOWOeRq7IRWKsx21vGNIb3psr89HjqvZVFHV08XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ff37MUaybFW+MpvzUs8iBqENuyFc3qs7q5fvsTqsJ3M=;
 b=KfMMsjVaBuC7xGy+Rno2fEco3xtVEl9hE/DbuLaGbBUDgByRvNuTcFzaSYKawJRhWwxBUWnU9Dek83AyZkH9KuYLQvy+HvqAUSQ5VzVQ8V+Ma815mnJvJEsfI9TJxaDesn7/6oG6tkG3EO7TvKA+81prxMohIVbxuRXIT89C3bo=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3094.namprd15.prod.outlook.com (2603:10b6:a03:ff::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Wed, 10 Feb
 2021 08:00:04 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3763.019; Wed, 10 Feb 2021
 08:00:03 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@fb.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Thread-Topic: [PATCH v5 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Thread-Index: AQHW/m0zn7SokiCS2ku6SkhP+3YCzKpQWLuAgAAKuoCAAFGDgIAAU6UA
Date:   Wed, 10 Feb 2021 08:00:03 +0000
Message-ID: <D2174345-F4A8-4D38-8FB0-9E530D846CD9@fb.com>
References: <20210208225255.3089073-1-songliubraving@fb.com>
 <20210208225255.3089073-2-songliubraving@fb.com>
 <20210209213031.v4wzzka7nth7xzq5@ast-mbp.dhcp.thefacebook.com>
 <6846C89A-5E5F-4093-96EF-85E694E0DA4A@fb.com>
 <0967837f-04c7-4c94-aa28-2b14b5d816df@fb.com>
In-Reply-To: <0967837f-04c7-4c94-aa28-2b14b5d816df@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
x-originating-ip: [2620:10d:c090:400::5:3a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb18832a-34ff-4c42-9590-08d8cd99df72
x-ms-traffictypediagnostic: BYAPR15MB3094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3094DA3FFEC61EDAA6CFB5A7B38D9@BYAPR15MB3094.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rX+R6o41IoskYPQBNTyrikBVNmuo0DeZv950gtZsLyvkXdNOfDxYM6+dRDsdV3WFPjN1MgamT5qaUwWlM+v54C3xtmaEZPlORcFVXucMdXnc2TysRISfha7DCUNGRSsdsi47j2ceZQUTRk/5CXgGoKqXz/QV2yh3NODRQEhOqPH1Irz2JxHm79Di4E2leDw2/FsZqe1jzAtSrlTcBEywfZufVdQFsEKezR5FikeXANx/M2NLbnHp3SIoIM4u96AO8jGacTecGB8CTbEl/GqanMdvkK9+NoB+ot9H7z7589zyC4DJzpJjwOQswTq1Z29M9jKst/j7HSrbF6SSPTx2Qd6Q9fUiEqfJ4Q+2il5RRNB+DqPbENsXROZDM3E1x/MeWIZjQODeaGuCnFmx7iAh7wHXD/Htb6E8T2wKBtc4uvrpGeNwDP4YZ0BkIHXyngVXCnpYfHoJPoddwChvStyXqV91A7O0b3IQJ/vN5pjHFzWojtxCd1QwQHNrGtvRgF4e7ZmhY0yrmjkVjquXIMyyXX6IvocuSQpPSXb4f9qG9jaaBAnBQ9vd4jj/ZBhOs3OMBVcQYX1L483MaYxC3WK7ow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(376002)(136003)(346002)(54906003)(8676002)(37006003)(5660300002)(478600001)(186003)(83380400001)(2616005)(76116006)(64756008)(6486002)(6506007)(6636002)(66556008)(66476007)(33656002)(66446008)(8936002)(4326008)(6512007)(2906002)(66946007)(53546011)(86362001)(71200400001)(6862004)(36756003)(316002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?iPJTWICoOrKwZk+1Zqw6FISPgStpaxqCazKhbCYa23IbxSa5GP2Va0LDeB1z?=
 =?us-ascii?Q?y6aGAaSXQJEfIevWZY+yinUh3xhGSMlVEz6KgjDQqnlKeG9AuYTmjWo6IeRj?=
 =?us-ascii?Q?vnt8d/qi0REyqX+LlKT2FpFVIFi2gsApCWCrL5GlQFJDgSuwwSftvC8cT3f0?=
 =?us-ascii?Q?eEOLuC6gEpmEo3fPoyHtNL26VlNwQYNr+QOtrogo2rNCiKEZlVbkR7K045yF?=
 =?us-ascii?Q?oF7j9gFy45YI1lmcXUjJEl4mJlwBnchwXsnIqGNu8Vdbthv6TQmp3tJcSKBP?=
 =?us-ascii?Q?G8Ux7R8b9E/1PTZX2IWAq+toVgIzvLV+clm2kMTNAK8Klyq2+TdhB3LXi/Ep?=
 =?us-ascii?Q?UyVBm4PqYaSnvqitT0Y8l4iMmA/2+1MMVB9ywzFvRQ7n8zbGP2a83TUpuQIx?=
 =?us-ascii?Q?ZYWGhDRl6gvA1cWgbeE2Ik2WDap0EWkdJpQehAdIBoaNCfMWevOrLvoKn6bi?=
 =?us-ascii?Q?JZnyRwv1s1GZn8tvNCXIHt8QWnKKFQv/IdFAkY5yNwlN4IWz5wCknA0oh2eW?=
 =?us-ascii?Q?tQSS0PwrPeYNZpD3I5W8pJXd8oR7VKMcIs+stIcpGjvRJzvBv+pQay1CHeTy?=
 =?us-ascii?Q?xFI2GZlnxfTwFsqHJKCk6YNVTrkptcCzTGbGHLtf/C93A7Pm8yg5ZFoEwbO1?=
 =?us-ascii?Q?dH/XIzrMOC3Gk8UdkxAfCHvpIh1H0g/2+WazulIFG1r9AQH/R8Rxcj3ZniMu?=
 =?us-ascii?Q?w9ryppcxpps58bhZdaZiSDpSe7jmr6E2nmPtMqx/SLVNy/ICsDnNOUnR9pS4?=
 =?us-ascii?Q?hMZIPK78VLdCafx1L9iR1WPZFCJF6FykR9tr1rjn7LpNeLPqOGraHgONeAFP?=
 =?us-ascii?Q?cs5cRy/5xOiYDOqntG4A2nsjZq7nZ3BG7b5W8/cVXdZxW4N2cXOyKKG8AYW7?=
 =?us-ascii?Q?d1GOU8YfZIRpWa+AzjcLFN2E9PMludPH76iUsGjjnAGto42AAm5oFivHSOSa?=
 =?us-ascii?Q?UunjvwKgUsSi9HhrYmKNbNj5rAK/4vz33k2qWexL9kMURvJuc1GhXfAsHDge?=
 =?us-ascii?Q?W4F764cuCeEVeooumZmPXlFOl0F2/OxVECnYyuw5/tWY+MwFdTCnK3tREWBd?=
 =?us-ascii?Q?Z830aKqTOaYyLBoWx1FDczCDdjmnrGzPAHhZ/S/1RSOs4/dGoWvPbhtmPZNg?=
 =?us-ascii?Q?fym9GHl8PIzNJiPhDLT6CE2Bw8f4wWV5AvAXR+0q3djNjQX+2zSIA/Wf4MOb?=
 =?us-ascii?Q?QOsH34NqFs3cz8xtnS0hNvlrRMq8WoqH/HKqis13ld4N1rkAh4+rYnm5P1b8?=
 =?us-ascii?Q?dH9//1UblUOveFLHVfCHovMcMGL6Em6bga3HfNm2UoAzydd4JbLA7uZZAY9y?=
 =?us-ascii?Q?rYmcyFqoPawzSkAtgB7Kt6f/1pcnQHaZNPPKuInSuyeT28cuvgZKGs6uZveG?=
 =?us-ascii?Q?bb+xmZ4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <656554C739BBF845886337AC7918E050@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb18832a-34ff-4c42-9590-08d8cd99df72
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2021 08:00:03.4134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hfaFlaf3EeXDkGjyQO9pCQ93xpE6IiOtubMeIeiWS5Qq3JcsS7alknVLbyRmmmi3Ny+OTs9LXZYvJpOpoZSSfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3094
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_02:2021-02-09,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 suspectscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100082
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 9, 2021, at 7:00 PM, Alexei Starovoitov <ast@fb.com> wrote:
>=20
> On 2/9/21 2:08 PM, Song Liu wrote:
>>> On Feb 9, 2021, at 1:30 PM, Alexei Starovoitov <alexei.starovoitov@gmai=
l.com> wrote:
>>>=20
>>> On Mon, Feb 08, 2021 at 02:52:52PM -0800, Song Liu wrote:
>>>> Introduce task_vma bpf_iter to print memory information of a process. =
It
>>>> can be used to print customized information similar to /proc/<pid>/map=
s.
>>>>=20
>>>> Current /proc/<pid>/maps and /proc/<pid>/smaps provide information of
>>>> vma's of a process. However, these information are not flexible enough=
 to
>>>> cover all use cases. For example, if a vma cover mixed 2MB pages and 4=
kB
>>>> pages (x86_64), there is no easy way to tell which address ranges are
>>>> backed by 2MB pages. task_vma solves the problem by enabling the user =
to
>>>> generate customize information based on the vma (and vma->vm_mm,
>>>> vma->vm_file, etc.).
>>>>=20
>>>> To access the vma safely in the BPF program, task_vma iterator holds
>>>> target mmap_lock while calling the BPF program. If the mmap_lock is
>>>> contended, task_vma unlocks mmap_lock between iterations to unblock th=
e
>>>> writer(s). This lock contention avoidance mechanism is similar to the =
one
>>>> used in show_smaps_rollup().
>>>>=20
>>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>> ---
>>>> kernel/bpf/task_iter.c | 217 ++++++++++++++++++++++++++++++++++++++++-
>>>> 1 file changed, 216 insertions(+), 1 deletion(-)
>>>>=20
>>>> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
>>>> index 175b7b42bfc46..a0d469f0f481c 100644
>>>> --- a/kernel/bpf/task_iter.c
>>>> +++ b/kernel/bpf/task_iter.c
>>>> @@ -286,9 +286,198 @@ static const struct seq_operations task_file_seq=
_ops =3D {
>>>> 	.show	=3D task_file_seq_show,
>>>> };
>>>>=20
>>>> +struct bpf_iter_seq_task_vma_info {
>>>> +	/* The first field must be struct bpf_iter_seq_task_common.
>>>> +	 * this is assumed by {init, fini}_seq_pidns() callback functions.
>>>> +	 */
>>>> +	struct bpf_iter_seq_task_common common;
>>>> +	struct task_struct *task;
>>>> +	struct vm_area_struct *vma;
>>>> +	u32 tid;
>>>> +	unsigned long prev_vm_start;
>>>> +	unsigned long prev_vm_end;
>>>> +};
>>>> +
>>>> +enum bpf_task_vma_iter_find_op {
>>>> +	task_vma_iter_first_vma,   /* use mm->mmap */
>>>> +	task_vma_iter_next_vma,    /* use curr_vma->vm_next */
>>>> +	task_vma_iter_find_vma,    /* use find_vma() to find next vma */
>>>> +};
>>>> +
>>>> +static struct vm_area_struct *
>>>> +task_vma_seq_get_next(struct bpf_iter_seq_task_vma_info *info)
>>>> +{
>>>> +	struct pid_namespace *ns =3D info->common.ns;
>>>> +	enum bpf_task_vma_iter_find_op op;
>>>> +	struct vm_area_struct *curr_vma;
>>>> +	struct task_struct *curr_task;
>>>> +	u32 curr_tid =3D info->tid;
>>>> +
>>>> +	/* If this function returns a non-NULL vma, it holds a reference to
>>>> +	 * the task_struct, and holds read lock on vma->mm->mmap_lock.
>>>> +	 * If this function returns NULL, it does not hold any reference or
>>>> +	 * lock.
>>>> +	 */
>>>> +	if (info->task) {
>>>> +		curr_task =3D info->task;
>>>> +		curr_vma =3D info->vma;
>>>> +		/* In case of lock contention, drop mmap_lock to unblock
>>>> +		 * the writer.
>>>> +		 */
>>>> +		if (mmap_lock_is_contended(curr_task->mm)) {
>>>> +			info->prev_vm_start =3D curr_vma->vm_start;
>>>> +			info->prev_vm_end =3D curr_vma->vm_end;
>>>> +			op =3D task_vma_iter_find_vma;
>>>> +			mmap_read_unlock(curr_task->mm);
>>>> +			if (mmap_read_lock_killable(curr_task->mm))
>>>> +				goto finish;
>>>=20
>>> in case of contention the vma will be seen by bpf prog again?
>>> It looks like the 4 cases of overlaping vmas (after newly acquired lock=
)
>>> that show_smaps_rollup() is dealing with are not handled here?
>> I am not sure I am following here. The logic below should avoid showing
>> the same vma again:
>>  	curr_vma =3D find_vma(curr_task->mm, info->prev_vm_end - 1);
>> 	if (curr_vma && (curr_vma->vm_start =3D=3D info->prev_vm_start))
>> 		curr_vma =3D curr_vma->vm_next;
>> This logic handles case 1, 2, 3 same as show_smaps_rollup(). For case 4,
>> this logic skips the changed vma (from [prev_vm_start, prev_vm_end] to
>> [prev_vm_start, prev_vm_end + something]); while show_smaps_rollup() wil=
l
>> process the new vma.  I think skipping or processing the new vma are bot=
h
>> correct, as we already processed part of it [prev_vm_start, prev_vm_end]
>> once.
>=20
> Got it. Yeah, if there is a new vma that has extra range after
> prem_vm_end while prev_vm_start(s) are the same, arguably,
> bpf prog shouldn't process the same range again,
> but it will miss the upper part of the range.
> In other words there is no equivalent here to 'start'
> argument that smap_gather_stats has.
> It's fine, but lets document this subtle difference.

Make sense. I will add information in the comment. =20

>=20
>>>=20
>>>> +		} else {
>>>> +			op =3D task_vma_iter_next_vma;
>>>> +		}
>>>> +	} else {
>>>> +again:
>>>> +		curr_task =3D task_seq_get_next(ns, &curr_tid, true);
>>>> +		if (!curr_task) {
>>>> +			info->tid =3D curr_tid + 1;
>>>> +			goto finish;
>>>> +		}
>>>> +
>>>> +		if (curr_tid !=3D info->tid) {
>>>> +			info->tid =3D curr_tid;
>>>> +			op =3D task_vma_iter_first_vma;
>>>> +		} else {
>>>> +			op =3D task_vma_iter_find_vma;
>>>=20
>>> what will happen if there was no contetion on the lock and no seq_stop
>>> when this line was hit and set op =3D find_vma; ?
>>> If I'm reading this correctly prev_vm_start/end could still
>>> belong to some previous task.
>> In that case, we should be in "curr_tid !=3D info->tid" path, no?
>>> My understanding that if read buffer is big the bpf_seq_read()
>>> will keep doing while(space in buffer) {seq->op->show(), seq->op->next(=
);}
>>> and task_vma_seq_get_next() will iterate over all vmas of one task and
>>> will proceed into the next task, but if there was no contention and no =
stop
>>> then prev_vm_end will either be still zero (so find_vma(mm, 0 - 1) will=
 be lucky
>>> and will go into first vma of the new task) or perf_vm_end is some addr=
ess
>>> of some previous task's vma. In this case find_vma may return wrong vma
>>> for the new task.
>>> It seems to me prev_vm_end/start should be set by this task_vma_seq_get=
_next()
>>> function instead of relying on stop callback.
>=20
> Yeah. I misread where the 'op' goes.
> But I think the problem still exists. Consider the loop of
> show;next;show;next;...
> Here it will be: case first_vma; case next_vma; case next_vma;
> Now it goes into new task and 'curr_tid !=3D info->tid',
> so it does op =3D first_vma and info->tid =3D curr_tid.
> But we got unlucky and the process got suspended (with ctrl-z)
> and mmap_read_lock_killable returned eintr.
> The 'if' below will jump to finish.
> It will set info->task =3D NULL
> The process suppose to continue sys_read after resume.
> It will come back here to 'again:', but now it will do 'case find_vma'
> and will search for wrong prev_vm_end.

You are right. We will hit the issue in this case. Let me fix it in=20
the next version.=20

>=20
> Maybe I'm missing something again.
> It's hard for me to follow the code.
> Could you please add diagrams like show_smaps_rollup() does and
> document what happens with all the 'op's.

Will also add more documents here.=20

Thanks,
Song=
