Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FDC2DDDB7
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 05:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732146AbgLREeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 23:34:14 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16466 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726798AbgLREeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 23:34:14 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BI4UeCv011667;
        Thu, 17 Dec 2020 20:33:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=rE1J+3n4YB+j6p8s+vlmXfj1mHwl9vMXLb1D2JORAW4=;
 b=Gb41eAD8+bcHvI1AoPgEqkKN475My6NMdiN4BrlARfW0JoDH0GvYHVdGzqkuRb8NAuc+
 fmIV041evDgDpO8uMrrH6Z9LdVd79yvX0NhJ65SkAc0bVQv9BGCDwZrrJ1la1AE4/j5f
 LTJ5aLluyDyhWAeV+VQ3ZWTYx8PjDnhxpw4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35ftgnyf7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 17 Dec 2020 20:33:13 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 17 Dec 2020 20:33:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I9WZN5pyroPUgntT8JR9PsZllxhO+1+dIe1IP3cJJrhlTrdvl1tEPffnbZ6e/JR8y9lgH2Dc1yVrOnswubSqmIqZ6WXJ8MfNasC1oA/5nmqzikrufD28gD6xOCZj+MLKWt4fibOevxSZagH9IfV/rnCpUhtKWh7+LhYp4nxBMl4YUFXhzXL1wycOjUUmmo1so2+J9O8a4PH2XLn9ppB5Woa5HSmqSPPnbSbwzGQhyuaNqCbeHmILnk3eb6+ruVBKjuQKnJgT9dGiJBrAQ8WTEUBhezRggUXMj3mrTQz2oU2t21StIajjHA7KvgJCYUILKrlrQ83ao81J4up72991sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rE1J+3n4YB+j6p8s+vlmXfj1mHwl9vMXLb1D2JORAW4=;
 b=FxZLEm+wNDu5qfKjQax7/uFaQt5e8JzvPP3JtjbPliOCz3hPAkCr5YMQtyS8CaUEyUtRNxKJUVIXLnwxVcPJ1QUctwmFTsN8VTBfyEgGqbdq2Zql4BuHpHeQSo9EFMg/IOISF0r7r/SB2puTYq2PAaOEEZ0HpNAb58LDPyH6jCJ6+u/2rbFp1ax2wTOLBE54I2s/2OLe7IPVBdeG5g9mQAdV/6YDJiRed4ExeuHYBaCo2uiEQfDc0QVy3OLL5X8TQBvq8zgIMKbF+NA3/JVSzxgWBInBN7xqSC1orxeSB+dbx/23ayP16cavqqNait90buG63b3BRMbJODU9fYQEEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rE1J+3n4YB+j6p8s+vlmXfj1mHwl9vMXLb1D2JORAW4=;
 b=cPLc/2NVox1TOt24CNLhuci+jpJR79II4/iAc0lVU3btSyR4eM5g8XWM7c1EDdIo03cWE0mCuBS0h3Z7va6g686GJaXJhseYv8g4viBwblbM2jjS/U4vu2U+8Z2qU6n6J6iwNvHq0kqSJKkwlk4VBAN9oXK+utdwCx8T6YfqIOs=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2455.namprd15.prod.outlook.com (2603:10b6:a02:90::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.20; Fri, 18 Dec
 2020 04:33:11 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3654.025; Fri, 18 Dec 2020
 04:33:11 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Thread-Topic: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Thread-Index: AQHW0zs42cd9AcJBNEyi77fZmX7Jx6n7qAwAgAAzywCAAEpiAIAAIRcA
Date:   Fri, 18 Dec 2020 04:33:11 +0000
Message-ID: <D964C66B-2C25-4C3D-AFDE-E600364A721C@fb.com>
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-2-songliubraving@fb.com>
 <20201217190308.insbsxpf6ujapbs3@ast-mbp>
 <C4D9D25A-C3DD-4081-9EAD-B7A5B6B74F45@fb.com>
 <20201218023444.i6hmdi3bp5vgxou2@ast-mbp>
In-Reply-To: <20201218023444.i6hmdi3bp5vgxou2@ast-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:eed7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 345a3861-bd4f-479c-ee16-08d8a30e06f7
x-ms-traffictypediagnostic: BYAPR15MB2455:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2455A95328401F7383AAFEA5B3C30@BYAPR15MB2455.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yLT8bjETvPdy6ryI8/lm+fav5GDIk344Y8hRYIgPJb2nMTbn5unudK9MDXq3A2tfvuIAcSBW7GYG8IoH9occpiTx5Gm7VGw9d8aj8UzcdL6K7zz3KrnY0MrJ18t0aQg2868eSk3cvM9MT70Wog1PKqE8/9Yt3CK6rKRKUjnXGpoi8FEjK6x1qau8fqseL8ALLR4CpB8ktjCm/3Dch3F/X1tPy/qtB4xgAP9zmxVMW4ph3LTX2l++N5B5f7052p5kRwT0w1T9mg1OuHN+cgW40/g8gMnqmQZmd+hkYSH/Hbl1aFUvw4barfsdy1vMaERMitpJg+NJnISI3k7y+YYOmsauTeOPHRzcPI0ulg27VcspquTr9KaelBgyvFEWxmUk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(136003)(39860400002)(346002)(186003)(54906003)(53546011)(8676002)(316002)(71200400001)(66556008)(5660300002)(36756003)(66446008)(33656002)(86362001)(8936002)(6506007)(76116006)(6916009)(66476007)(91956017)(2906002)(64756008)(2616005)(478600001)(83380400001)(66946007)(4326008)(6486002)(6512007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?KWakjcqREmiVzOZp08HQmem4gkfhByqQak4ccYiVLM0TZKLVuOSRBuZhUP5t?=
 =?us-ascii?Q?wmTJ0I30gzVz3zKOPs/4FnBdNZjDc0P6iNtQzWDryoX/+PkPuJ1sDTTgUn+R?=
 =?us-ascii?Q?1L9S/cso6Lyl8IsRIJVe6uEVyUavxgXTbfXDAwaxteh4ebyf8Cgm54A7IOsj?=
 =?us-ascii?Q?GPLT/GrIKmEl86QQlQUewIVerxojtyIqcbtNLBROgH0oryeI7sd7v5Tmze1h?=
 =?us-ascii?Q?SJGXKlotm1SmbwEB6ShyQWcTtzbYIW9cr2Q/oKsiJmMwsnq3DCq7u5RGO2l1?=
 =?us-ascii?Q?lhZV2u5m94nyFnqKBtWXhXxivBVdE87QzT6OhEBfgH+fV6CUelDBNYTAPK8M?=
 =?us-ascii?Q?dGgIkfSxDE/DVouSn5alsdNM992ZWgsqPYFc6O+dQFrLI1FQ5rfn+MX+j8Xz?=
 =?us-ascii?Q?lQtSq/KJRls0OM/0nDmvOGr+uyfw1B58fD6kMCtvR7HUL2AuzRyIWwSHZkk0?=
 =?us-ascii?Q?chaSK1szT0FA+ERfseN/otMWBSTukggQJIryTq5Ng+HDAgfXSJ42lTumwDLZ?=
 =?us-ascii?Q?v45dtr422DJxxytLtYkvJUST9NPTZ5i0tWW6hOXbjUdVGko9Vw4OQHqL82n+?=
 =?us-ascii?Q?CcOq+Dz5bpS+kv7FA9MuZ4cRIvTdwSbGwwMN45FsB74jck2M4Qqv9F3JDiab?=
 =?us-ascii?Q?2znWJ9u32d34/BjvpS8k+g7vERb9AHHKUs0N471zFfe+Hl9c2W9gsa6Br4Wy?=
 =?us-ascii?Q?MsYYGQz/a7eYqrsB2C6I3J1bFpILGiatB8BJbYbQLUXBwJys+d2vLcPAvji9?=
 =?us-ascii?Q?kvvBDuhS/Xrlop9BXs1HTCW790m62P60/tT15g7BlFTxNK1JGx6rBg3ebxg1?=
 =?us-ascii?Q?ZWPjERKWU0J86nzZPzY8oMK/YFr8ocr7dEMbyn+ojH65KGw+J4jyWnp5DooN?=
 =?us-ascii?Q?EEp4jb1v8pj5+Gq5h6teeEML30WyxELw1jLeSVy1CSKnJ49HiB1LythJ681A?=
 =?us-ascii?Q?W2+6fQvgplhlCsFSOT8lCkJ+Y3rasfSvRwZCdlk21R89JA46pLu3uZP1Ztd3?=
 =?us-ascii?Q?4gdgEA1IHVUgjanslax+ougcUj+FBxSeQcyB9PauGcQ2dHU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EFF619B0331E4C46A27F854C506D7298@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 345a3861-bd4f-479c-ee16-08d8a30e06f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2020 04:33:11.3757
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jtw6efqY3pb+d+tW/jIBUzkOtfMOn26SG/jTLBp9Docl7/4nxNbEtVCUHHrmv8l0PKbBJH+etORmwuwAIqZUcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2455
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_03:2020-12-17,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 malwarescore=0 priorityscore=1501 clxscore=1011 bulkscore=0 mlxscore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180031
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 17, 2020, at 6:34 PM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
> On Thu, Dec 17, 2020 at 10:08:31PM +0000, Song Liu wrote:
>>=20
>>=20
>>> On Dec 17, 2020, at 11:03 AM, Alexei Starovoitov <alexei.starovoitov@gm=
ail.com> wrote:
>>>=20
>>> On Tue, Dec 15, 2020 at 03:36:59PM -0800, Song Liu wrote:
>>>> +/*
>>>> + * Key information from vm_area_struct. We need this because we canno=
t
>>>> + * assume the vm_area_struct is still valid after each iteration.
>>>> + */
>>>> +struct __vm_area_struct {
>>>> +	__u64 start;
>>>> +	__u64 end;
>>>> +	__u64 flags;
>>>> +	__u64 pgoff;
>>>> +};
>>>=20
>>> Where it's inside .c or exposed in uapi/bpf.h it will become uapi
>>> if it's used this way. Let's switch to arbitrary BTF-based access inste=
ad.
>>>=20
>>>> +static struct __vm_area_struct *
>>>> +task_vma_seq_get_next(struct bpf_iter_seq_task_vma_info *info)
>>>> +{
>>>> +	struct pid_namespace *ns =3D info->common.ns;
>>>> +	struct task_struct *curr_task;
>>>> +	struct vm_area_struct *vma;
>>>> +	u32 curr_tid =3D info->tid;
>>>> +	bool new_task =3D false;
>>>> +
>>>> +	/* If this function returns a non-NULL __vm_area_struct, it held
>>>> +	 * a reference to the task_struct. If info->file is non-NULL, it
>>>> +	 * also holds a reference to the file. If this function returns
>>>> +	 * NULL, it does not hold any reference.
>>>> +	 */
>>>> +again:
>>>> +	if (info->task) {
>>>> +		curr_task =3D info->task;
>>>> +	} else {
>>>> +		curr_task =3D task_seq_get_next(ns, &curr_tid, true);
>>>> +		if (!curr_task) {
>>>> +			info->task =3D NULL;
>>>> +			info->tid++;
>>>> +			return NULL;
>>>> +		}
>>>> +
>>>> +		if (curr_tid !=3D info->tid) {
>>>> +			info->tid =3D curr_tid;
>>>> +			new_task =3D true;
>>>> +		}
>>>> +
>>>> +		if (!curr_task->mm)
>>>> +			goto next_task;
>>>> +		info->task =3D curr_task;
>>>> +	}
>>>> +
>>>> +	mmap_read_lock(curr_task->mm);
>>>=20
>>> That will hurt. /proc readers do that and it causes all sorts
>>> of production issues. We cannot take this lock.
>>> There is no need to take it.
>>> Switch the whole thing to probe_read style walking.
>>> And reimplement find_vma with probe_read while omitting vmacache.
>>> It will be short rbtree walk.
>>> bpf prog doesn't need to see a stable struct. It will read it through p=
tr_to_btf_id
>>> which will use probe_read equivalent underneath.
>>=20
>> rw_semaphore is designed to avoid write starvation, so read_lock should =
not cause
>> problem unless the lock was taken for extended period. [1] was a recent =
fix that=20
>> avoids /proc issue by releasing mmap_lock between iterations. We are usi=
ng similar
>> mechanism here. BTW: I changed this to mmap_read_lock_killable() in the =
next version.=20
>>=20
>> On the other hand, we need a valid vm_file pointer for bpf_d_path. So wa=
lking the=20
>=20
> ahh. I missed that. Makes sense.
> vm_file needs to be accurate, but vm_area_struct should be accessed as pt=
r_to_btf_id.

Passing pointer of vm_area_struct into BPF will be tricky. For example, sha=
ll we=20
allow the user to access vma->vm_file? IIUC, with ptr_to_btf_id the verifie=
r will
allow access of vma->vm_file as a valid pointer to struct file. However, si=
nce the
vma might be freed, vma->vm_file could point to random data.=20

>=20
>> rbtree without taking any lock would not work. We can avoid taking the l=
ock when=20
>> some SPF like mechanism merged (hopefully soonish).=20
>>=20
>> Did I miss anything?=20
>>=20
>> We can improve bpf_iter with some mechanism to specify which task to ite=
rate, so=20
>> that we don't have to iterate through all tasks when the user only want =
to inspect=20
>> vmas in one task.=20
>=20
> yes. let's figure out how to make it parametrizable.
> map_iter runs only for given map_fd.
> Maybe vma_iter should run only for given pidfd?
> I think all_task_all_vmas iter is nice to have, but we don't really need =
it?
>=20
>> Thanks,
>> Song
>>=20
>> [1] ff9f47f6f00c ("mm: proc: smaps_rollup: do not stall write attempts o=
n mmap_lock")
>=20
> Thanks for this link. With "if (mmap_lock_is_contended())" check it shoul=
d work indeed.

To make sure we are on the same page: I am using slightly different mechani=
sm in=20
task_vma_iter, which doesn't require checking mmap_lock_is_contended(). In =
the=20
smaps_rollup case, the code only unlock mmap_sem when the lock is contended=
. In=20
task_iter, we always unlock mmap_sem between two iterations. This is becaus=
e we=20
don't want to hold mmap_sem while calling the BPF program, which may sleep =
(calling
bpf_d_path).=20

Thanks,
Song


