Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BF331593D
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 23:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbhBIWQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 17:16:28 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62808 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233918AbhBIWKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 17:10:02 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 119M4a3u008814;
        Tue, 9 Feb 2021 14:09:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=my4VnMMrMym76/1RV/1cYi9gKcAnz4hKdnw6/Zg53tE=;
 b=Bekdh8+j5fDdH6SMhlA+ZP/UGxH3vrKos9BNTF8TORYFqLlk28w/fy+DdJApH9n+Nj5A
 viG9OWG3lZRErKno2jQ9CZ6NJ4SxS2ttTM4oxZbzhaL84aE7HvQjlb5AncIAd/Xczsgn
 lPryVx7Xslh7fO0XFrJR4ho/79g6nzZKz18= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36jbnp5x89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 09 Feb 2021 14:09:04 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 9 Feb 2021 14:09:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KMsSzsm3P9iIoDDb6vneeJrxwFYs/lN+Ad8E4PaTFu/FAvhvmSMBaGmcnxPdCc1e/bBdLZhpeJJccximmFdv/im0QL1/nqxH/TLq+27GcuVzqV1FtrcXRQ7og5tp0a3/0UfY6kEFXKU6AH7wW0YyteuDNSMAWNql3YYdqk0H+mCl1VSqpeBTAIYb2IP/fwFqlpEZELjTx1X76eE3LZ3i8CXdzwuXGS5giC/GUE9fB0YynIdfPESLuTSM1UyeW8++/fTTr2TQYfpYG8iCNRipFagbEB+64rQnmdxaHsGYky5y/U7m2H0r+wBEEhyw6pwK0klBwt5uWekXBUDuaz5jaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=my4VnMMrMym76/1RV/1cYi9gKcAnz4hKdnw6/Zg53tE=;
 b=ocZEygY4z4+vUHR8Zb+PAXQJo2a6pHxTPFTIto4l3DaOjpYfwc+S25tZ4e4wF3hRukAvXhlk0SGQ43mchQKOMawB+4femno72kHZJkyc/zloipV4WbFBJKLeU7WPsNPBI5zPRRiYzcCojarwn/2sUqadZEl9fEXYVu8Eps3SO22dQI7Aagy3WyiXe+EhM8MVXP4ZsKrHbsxGsXrKh5V137qkiOtT4d9r2IEZNRWxzC048TaBERusHm0pXLL72/3YTqE5hXqsJpDzWcKTqrSImJCcS0it2tspey5Md7hQho66/bvAU3rp7cDYaF4WJVR4kch8RmhS4Wxqyqyj9upNwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=my4VnMMrMym76/1RV/1cYi9gKcAnz4hKdnw6/Zg53tE=;
 b=CTr7ahXBhiRNc8M9ABfCBdUT3pd3kCK2t3aFPn+qyRj1ELxpmy2d/1RouxH5x7+9Jl1u2PUbj6JjjnkCsy+CTEaOSSp85zeydAkUkMFJ8Otg/Pf125Kl0T823C5wWTU4napRnfK2LqzHsBrJ+zQyFon7UukR1midIKxottZqTHY=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2566.namprd15.prod.outlook.com (2603:10b6:a03:150::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Tue, 9 Feb
 2021 22:08:56 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3763.019; Tue, 9 Feb 2021
 22:08:56 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Thread-Topic: [PATCH v5 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Thread-Index: AQHW/m0zn7SokiCS2ku6SkhP+3YCzKpQWLuAgAAKuoA=
Date:   Tue, 9 Feb 2021 22:08:56 +0000
Message-ID: <6846C89A-5E5F-4093-96EF-85E694E0DA4A@fb.com>
References: <20210208225255.3089073-1-songliubraving@fb.com>
 <20210208225255.3089073-2-songliubraving@fb.com>
 <20210209213031.v4wzzka7nth7xzq5@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210209213031.v4wzzka7nth7xzq5@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:3a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5276a11f-687e-4ddf-f837-08d8cd474ba3
x-ms-traffictypediagnostic: BYAPR15MB2566:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2566BF27ED1989E721FF8541B38E9@BYAPR15MB2566.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q4fLm2PoVZw4nfcosutCiT0M1yaz10SmXyW7GjvChrbGSIzf+WwTAjPqWOC4R5QaO8de59N+SfYhba/B/Ivqgr+59wvxIiRG5Z4OVkbE33WAC2Q11re3K78OYZZv5Rz9ijsXSdo78+ZbRV+XCpwK/C9fI3uQyueFgJvBTH+BXvNMfSWRtPYG+z+4HPfeaw9cn0/2xqGBdADvH8w4yvUr+KL9Kw7cSLs6h3xtvOB6ZCPcSv5r2ekUYU+xbHXTjnmfoPqI5hZc1IYiMBLeW42OO9vOUo7SahkbYc0m13oJeuBKeaGxRR+nn49d0ixLNWETns8RFPPIxc8nUK/BtivCcLxwRaQGxfnBO6fLNX31LSPPM/CHIuQCQvC5AuDAHqLVT6rzXdjbO0C1i92WJUixcoSRsWZD9Cfa4FtS8cpa2dBHkex8vPlN10PWGOFurLQRUs9ryuS8TcOcvz12X2envqqybUOG9+VsdM4TxFzxp3i+tqvLvOmvDOFPReU2cpgpzsxcqULyehBlia43BSEprAP1Tvjumn+clWWB4Xwj3BQV0JpWr1Od2tafnrDnAMX1ZcGDK4DMYyVXNEzMjVRrTw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(39860400002)(346002)(396003)(91956017)(64756008)(66556008)(76116006)(36756003)(66476007)(83380400001)(6916009)(66446008)(2906002)(6486002)(5660300002)(66946007)(6512007)(71200400001)(478600001)(6506007)(4326008)(54906003)(186003)(33656002)(8676002)(316002)(86362001)(53546011)(8936002)(2616005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?T7uajgxth/h3fBGbazENk000Lcq9bYfOVszvjDL6fbiD/JGHKuwfE4mL/YIo?=
 =?us-ascii?Q?pMay55e0PDS4U/oDLVDsS/q40kyfUZo+kSxlDNrT7/apGDGW275MDU8eJYJX?=
 =?us-ascii?Q?PC9ReGydr4BN1UP0KlNrh8wQfOgi2dVTWJlVP0FaFcmGSMH98Wn9K8R4Bbnt?=
 =?us-ascii?Q?Lq+A0Gf5Tuj9nBfqvWe4lg9o4CgFNMzk+hadsooLcoZbIlTiPpXdCXfv29kh?=
 =?us-ascii?Q?UaclwjNFoIpSUp2Mtjjxcr2L+dgOl7Yp10q1vczWQrHAGTs5+mh7F0KNbOdF?=
 =?us-ascii?Q?IqZfPKDGbfv+PejfMxfIt8CQZPXG6yYpSdNpLdpJyxLCEa0BKP6EFLVAAbaO?=
 =?us-ascii?Q?AGxmu0ETCH2JKPUS45vOKO/p+poDGDVPExUo2tD5r2c2tvCbszmzbUjIJdLK?=
 =?us-ascii?Q?dLjZaM8GGhC/bpAq7YZok91iObghHzth8T7nJZ6rTHF9Ed6tjLd6neDqAWe+?=
 =?us-ascii?Q?SM/bKS1+/KLjvgI1gaLQSFGhu/Dl29LDD1PtW/Zm0ZvVvGFgEtpbA+JsGSTz?=
 =?us-ascii?Q?X0yxDu0PnEYgIg5I27BY3bxTIdP5HM+bNCxjkYKQNLKlvkq1vY8bd/ahPPS+?=
 =?us-ascii?Q?J6clApjnDZi8pk6wOI0nKKSJ2kmL5QQK/ANSdtK1gOGa6rYfwsNz/2nDpao7?=
 =?us-ascii?Q?Wq2JpblUSerLuiCcfTRAtfwQmKGDtrIF6GnI9QOwfWmrgfveXcoOo9Cu0V3S?=
 =?us-ascii?Q?KSHyi2behfGaYo36bwyjJxGI0bGY462bwBMVHkYCUcypgR6nBf/E6g6/uJ+B?=
 =?us-ascii?Q?PxlGBMU47iS125SOhBqpgjH5D6xDGtnoe6mJ+kiSkkROHZIrf3QVCYb//RsJ?=
 =?us-ascii?Q?LSkN03rAJiinDLe7xEfKLnUUVxB+xId8HP18zfkgwU4ERGIEi3I1EoKK4F8E?=
 =?us-ascii?Q?XV2aNQrXOnSHFCs/9Khs1+asS/HvM3yBvKoFFzk0nuEV4kSQYe8Lp/sJRXzj?=
 =?us-ascii?Q?ta4H7SEGf37rWgswcVPO+3CMQuOlOX1XH71IM1d+8R73ceach+8Ru56RcOT7?=
 =?us-ascii?Q?83NCaBQ4coWMZKgQi0FolDSnpgMji6V0HtmhD+APyWprS9gfvxDVafoCDhRT?=
 =?us-ascii?Q?DL1r4ryNpu6lq8CXrMowNuoA1q8Mxge2INjAMIEwlmnq9rdDDaAW+6E7qyPY?=
 =?us-ascii?Q?zb1pE4YssO3TiGqsIR7KL8pTJzpDpokMjwY7NgWGV44J4Dw8SDA7bmUUmCIb?=
 =?us-ascii?Q?Fjt6sec1vbVBOqAWoKH9t9tbZRr/96DOuJWLtBr8NOrcU/cH/l4uOIB4uwAs?=
 =?us-ascii?Q?LOefB36AvPnpyLysI/zxA87FQUycW4TDNpX8u/Nr7HRdrob/yybJMBq1yq8r?=
 =?us-ascii?Q?SUp9HEVu5DVPZ2d7fG+iMQ4fZO13TGV1LjuQzkdrk+6rY13+2ukjGGBnD3H1?=
 =?us-ascii?Q?eAo/VAs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AE3D593C3976F24BBFD7E4B7789221A8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5276a11f-687e-4ddf-f837-08d8cd474ba3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2021 22:08:56.6875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rSCX77xKo5ZdVOBQ99Q3F2vXDwYREm5v/CbP/ZGegmMiWLVMMj2avd9pQykEc5gMdHEligyR4vBhcLO8jQOC5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2566
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_08:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090112
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 9, 2021, at 1:30 PM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:
>=20
> On Mon, Feb 08, 2021 at 02:52:52PM -0800, Song Liu wrote:
>> Introduce task_vma bpf_iter to print memory information of a process. It
>> can be used to print customized information similar to /proc/<pid>/maps.
>>=20
>> Current /proc/<pid>/maps and /proc/<pid>/smaps provide information of
>> vma's of a process. However, these information are not flexible enough t=
o
>> cover all use cases. For example, if a vma cover mixed 2MB pages and 4kB
>> pages (x86_64), there is no easy way to tell which address ranges are
>> backed by 2MB pages. task_vma solves the problem by enabling the user to
>> generate customize information based on the vma (and vma->vm_mm,
>> vma->vm_file, etc.).
>>=20
>> To access the vma safely in the BPF program, task_vma iterator holds
>> target mmap_lock while calling the BPF program. If the mmap_lock is
>> contended, task_vma unlocks mmap_lock between iterations to unblock the
>> writer(s). This lock contention avoidance mechanism is similar to the on=
e
>> used in show_smaps_rollup().
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> kernel/bpf/task_iter.c | 217 ++++++++++++++++++++++++++++++++++++++++-
>> 1 file changed, 216 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
>> index 175b7b42bfc46..a0d469f0f481c 100644
>> --- a/kernel/bpf/task_iter.c
>> +++ b/kernel/bpf/task_iter.c
>> @@ -286,9 +286,198 @@ static const struct seq_operations task_file_seq_o=
ps =3D {
>> 	.show	=3D task_file_seq_show,
>> };
>>=20
>> +struct bpf_iter_seq_task_vma_info {
>> +	/* The first field must be struct bpf_iter_seq_task_common.
>> +	 * this is assumed by {init, fini}_seq_pidns() callback functions.
>> +	 */
>> +	struct bpf_iter_seq_task_common common;
>> +	struct task_struct *task;
>> +	struct vm_area_struct *vma;
>> +	u32 tid;
>> +	unsigned long prev_vm_start;
>> +	unsigned long prev_vm_end;
>> +};
>> +
>> +enum bpf_task_vma_iter_find_op {
>> +	task_vma_iter_first_vma,   /* use mm->mmap */
>> +	task_vma_iter_next_vma,    /* use curr_vma->vm_next */
>> +	task_vma_iter_find_vma,    /* use find_vma() to find next vma */
>> +};
>> +
>> +static struct vm_area_struct *
>> +task_vma_seq_get_next(struct bpf_iter_seq_task_vma_info *info)
>> +{
>> +	struct pid_namespace *ns =3D info->common.ns;
>> +	enum bpf_task_vma_iter_find_op op;
>> +	struct vm_area_struct *curr_vma;
>> +	struct task_struct *curr_task;
>> +	u32 curr_tid =3D info->tid;
>> +
>> +	/* If this function returns a non-NULL vma, it holds a reference to
>> +	 * the task_struct, and holds read lock on vma->mm->mmap_lock.
>> +	 * If this function returns NULL, it does not hold any reference or
>> +	 * lock.
>> +	 */
>> +	if (info->task) {
>> +		curr_task =3D info->task;
>> +		curr_vma =3D info->vma;
>> +		/* In case of lock contention, drop mmap_lock to unblock
>> +		 * the writer.
>> +		 */
>> +		if (mmap_lock_is_contended(curr_task->mm)) {
>> +			info->prev_vm_start =3D curr_vma->vm_start;
>> +			info->prev_vm_end =3D curr_vma->vm_end;
>> +			op =3D task_vma_iter_find_vma;
>> +			mmap_read_unlock(curr_task->mm);
>> +			if (mmap_read_lock_killable(curr_task->mm))
>> +				goto finish;
>=20
> in case of contention the vma will be seen by bpf prog again?
> It looks like the 4 cases of overlaping vmas (after newly acquired lock)
> that show_smaps_rollup() is dealing with are not handled here?

I am not sure I am following here. The logic below should avoid showing=20
the same vma again:
=20
	curr_vma =3D find_vma(curr_task->mm, info->prev_vm_end - 1);
	if (curr_vma && (curr_vma->vm_start =3D=3D info->prev_vm_start))
		curr_vma =3D curr_vma->vm_next;

This logic handles case 1, 2, 3 same as show_smaps_rollup(). For case 4,=20
this logic skips the changed vma (from [prev_vm_start, prev_vm_end] to=20
[prev_vm_start, prev_vm_end + something]); while show_smaps_rollup() will
process the new vma.  I think skipping or processing the new vma are both=20
correct, as we already processed part of it [prev_vm_start, prev_vm_end]=20
once.=20

>=20
>> +		} else {
>> +			op =3D task_vma_iter_next_vma;
>> +		}
>> +	} else {
>> +again:
>> +		curr_task =3D task_seq_get_next(ns, &curr_tid, true);
>> +		if (!curr_task) {
>> +			info->tid =3D curr_tid + 1;
>> +			goto finish;
>> +		}
>> +
>> +		if (curr_tid !=3D info->tid) {
>> +			info->tid =3D curr_tid;
>> +			op =3D task_vma_iter_first_vma;
>> +		} else {
>> +			op =3D task_vma_iter_find_vma;
>=20
> what will happen if there was no contetion on the lock and no seq_stop
> when this line was hit and set op =3D find_vma; ?
> If I'm reading this correctly prev_vm_start/end could still
> belong to some previous task.

In that case, we should be in "curr_tid !=3D info->tid" path, no?=20

> My understanding that if read buffer is big the bpf_seq_read()
> will keep doing while(space in buffer) {seq->op->show(), seq->op->next();=
}
> and task_vma_seq_get_next() will iterate over all vmas of one task and
> will proceed into the next task, but if there was no contention and no st=
op
> then prev_vm_end will either be still zero (so find_vma(mm, 0 - 1) will b=
e lucky
> and will go into first vma of the new task) or perf_vm_end is some addres=
s
> of some previous task's vma. In this case find_vma may return wrong vma
> for the new task.
> It seems to me prev_vm_end/start should be set by this task_vma_seq_get_n=
ext()
> function instead of relying on stop callback.
>=20
>> +		}
>> +
>> +		if (!curr_task->mm)
>> +			goto next_task;
>> +
>> +		if (mmap_read_lock_killable(curr_task->mm))
>> +			goto finish;
>> +	}
>> +
>> +	switch (op) {
>> +	case task_vma_iter_first_vma:
>> +		curr_vma =3D curr_task->mm->mmap;
>> +		break;
>> +	case task_vma_iter_next_vma:
>> +		curr_vma =3D curr_vma->vm_next;
>> +		break;
>> +	case task_vma_iter_find_vma:
>> +		/* We dropped mmap_lock so it is necessary to use find_vma
>> +		 * to find the next vma. This is similar to the  mechanism
>> +		 * in show_smaps_rollup().
>> +		 */
>> +		curr_vma =3D find_vma(curr_task->mm, info->prev_vm_end - 1);
>> +
>> +		if (curr_vma && (curr_vma->vm_start =3D=3D info->prev_vm_start))
>> +			curr_vma =3D curr_vma->vm_next;
>> +		break;
>> +	}
>> +	if (!curr_vma) {
>> +		mmap_read_unlock(curr_task->mm);
>> +		goto next_task;
>> +	}
>> +	info->task =3D curr_task;
>> +	info->vma =3D curr_vma;
>> +	return curr_vma;
>> +
>> +next_task:
>> +	put_task_struct(curr_task);
>> +	info->task =3D NULL;
>> +	curr_tid++;
>> +	goto again;
>> +
>> +finish:
>> +	if (curr_task)
>> +		put_task_struct(curr_task);
>> +	info->task =3D NULL;
>> +	info->vma =3D NULL;
>> +	return NULL;
>> +}

[...]

