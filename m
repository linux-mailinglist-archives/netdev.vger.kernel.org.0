Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3622DDB30
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 23:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732004AbgLQWJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 17:09:34 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22158 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731867AbgLQWJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 17:09:34 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BHM441I011265;
        Thu, 17 Dec 2020 14:08:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=sCDUijTCsqkyKpUdgtmhl1iL1+g9U36P/cjXXJf7Xl4=;
 b=ddE50OcYXSJrHw9bAPGf8tFjsPdYYyPew3wkfW563GnlC14/QkTSXqk1uW/BFz7bUFsx
 aBhgyhUlX8v2AUmYPQugNixPwAnC6t0iURjFyHg8WErqTD9pxDQRrg9qcghU9qR18qk5
 taRLlU8AJcrGSwjriDuEmLIVBzmuF/oRQzw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35fn0sg9b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 17 Dec 2020 14:08:38 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 17 Dec 2020 14:08:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8WaoWZgPKy4pPkCuCLjcsp2AHAxx5d4Iq26Y6nXI1yunD8DUIk6Mcq5EjmmXCGUr2BPqY+HPdZdy9zRxi9eIYDZRO5F5JIK0zcAjR3Cgx+3uUcxcJbiIJ5Dm5ypj0SNUfxopFB23Vf4A738h3Z1zQrkdihizKvsalugpWfaRHhAQZAcQ50D62/BowCLJ2dMRibPe23FxdPsgJdUsJCssXnZORoTQ4rnS6xick5Dk/KSAm7czLR7SDq5PuOEDD4GOAFRoth2K+oA2ZZHM9738xWFDTV17Csx71CKMpKanrYgReXsErN0iNfooZ/6mAOB0uF8n1gGRkdW68EloH9XvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCDUijTCsqkyKpUdgtmhl1iL1+g9U36P/cjXXJf7Xl4=;
 b=nPQMoUSVjA2wl2+viE+MDW4W3i8JoYa9tzGangWnoNHjWZL0vwL/bKZuAj6UebS+MFoNnMwafL1GTRI1q2nhqIqHI1Ogp1uuUZQH1KTGg53vy3w/czC5r9SIMOZImqsOpB3/0MxD4MlNoAkMLywq3JuWH9h+exDzhHZrquVIwJZgeUh7ksBjvnPkIHhL7ilHSvEOZJn//2+4cDRyDFQmxGP6dLRWJnN3N7MsLftQ8I6xBURkI+F/J+66shovVvcwRfClBuH7nG0eWgW+YZ/evdCTlrCPxogMGy4ZDTbZo2h0IWgdv3WcdIBXXZN+R64Z6/ml0Cz4zTs+2EUAP8Mh4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCDUijTCsqkyKpUdgtmhl1iL1+g9U36P/cjXXJf7Xl4=;
 b=GZnMjpUJpZUuBaHg5Zsc5gIrFZclHeKHGflAjuKRZBydV+mb0WGVIT6vd1Z3u7UR+uAFfXdUJxN9M7AGYSU2gk17G8Bdso7dELsmpexWWXINq/VrJAj498IYQd1hJPuNQRRNA5Om/2OXcWUkMRtUy5gDeQtRDDwr4ZLvG7N469E=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3208.namprd15.prod.outlook.com (2603:10b6:a03:10c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.15; Thu, 17 Dec
 2020 22:08:31 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3654.025; Thu, 17 Dec 2020
 22:08:31 +0000
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
Thread-Index: AQHW0zs42cd9AcJBNEyi77fZmX7Jx6n7qAwAgAAzywA=
Date:   Thu, 17 Dec 2020 22:08:31 +0000
Message-ID: <C4D9D25A-C3DD-4081-9EAD-B7A5B6B74F45@fb.com>
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-2-songliubraving@fb.com>
 <20201217190308.insbsxpf6ujapbs3@ast-mbp>
In-Reply-To: <20201217190308.insbsxpf6ujapbs3@ast-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:eed7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74141d26-fa30-4e75-769c-08d8a2d84a3d
x-ms-traffictypediagnostic: BYAPR15MB3208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3208D43CAAAB3134135E9F67B3C40@BYAPR15MB3208.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4ESrQ1735m71z1ki8GlKK+dLCi7/pEYngxof4s2ExXngHNlc9VNFSqNOEFG+DfUL6WbWEFuXdhxEDXUvprDBBPzsTtt3YFoiagOBfKnXeYLAImnObG/B9s64SKwhj/AUllM5r7h6BOWN/Gx1NW9MsD+x1Okhd1KHUyGr7H+EM4Zy3lBc66/NNun1SqXBV/5lT6ZQ2pzyJn+lXpqADLMjTgDZjc1pZCr88Bs7S+Ugm/qzedwWk4aUmJAoPaIq6Imtcl45drOQHujnwj5X0oEIRxCwhMMgZMy+Zz5Dpn/79mr1NQ24wTAKhZauC4Nkz6iCqVjIMlC7LmymxWpW0jCxMoBQKFOOwUJ+zNRGxWajvQaho1V7oSNzj1FduQLjBknO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(136003)(39860400002)(346002)(36756003)(316002)(186003)(53546011)(71200400001)(6512007)(86362001)(6916009)(64756008)(6506007)(2906002)(66556008)(478600001)(33656002)(83380400001)(54906003)(6486002)(66946007)(91956017)(66476007)(8936002)(76116006)(2616005)(8676002)(5660300002)(66446008)(4326008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Dvz3wmRxg3yfSg5Cw7lY0CgBWk9vGmH9YI/UxE0kSVSfTCjaAutxobTTbeRI?=
 =?us-ascii?Q?94WZ4aL7mK32UWAk+2Evl5i2NGVuNuYQAWQQswSzxUq56ysAd1c1csxKVnmB?=
 =?us-ascii?Q?F2l7RYKse3HVK19sNaUwLRAL/YzJ44LVjsHryjjNeWCy0zicLXXLcH8J2hI6?=
 =?us-ascii?Q?ZPcx5cJutcqyaxMkKrZDDj2nenvCcYl+YLWFCLebSDOKpXkdYM6tjqVZ8btk?=
 =?us-ascii?Q?agA+ZjBVCc6hODaEP+teIL74bQZ0uGxfJHCGei0k4/7Ie6sgK+t+uJU9RH1l?=
 =?us-ascii?Q?U1rXrOddTDMCc2l3PEhGIiaN0R5xs+u6j/qbFIaCbeaYL+2iHUcHzmI/wQIR?=
 =?us-ascii?Q?1Kx25W4Pa56GDftqSpJbzX89ubnRjlQ2pJSCq9bhiECHpY6iFiTz8TfKxD+V?=
 =?us-ascii?Q?0K+oIOMtS6Pszf9fmIe4j3KtR0SjtFjdR6XQvw36IxOYqePISPFroOzR5qf5?=
 =?us-ascii?Q?y/XEf1/tQYuJ1zg3awHk42EQtRgSnAYMNXyqiQ27Qd01txrI18WVYziG+PGe?=
 =?us-ascii?Q?nQer1HGYPgjN3NQQfTEoDSSaegXrZRUA7GkZkng1Ads9Zlu5si+bWSySq848?=
 =?us-ascii?Q?eNUSosOKxM+8HlcRC0TTFvK9FaDMaQ0LLfhu8glE1KX2GwLb7+IZ9CRTQwyh?=
 =?us-ascii?Q?x2d96J7nHh1W+wFluL/4tGu2uSrQB3ilXxASNqjWfDPalpNodHGWoQ7EvSVl?=
 =?us-ascii?Q?9C1eoUieumJnpo43vWQNuzxve4a0Dpaw2epeFnWNxjO5E/Yhn7Vack4F6FWL?=
 =?us-ascii?Q?P+AUQOnEOnooqB71TgUb88fPfEDAyD8PMCjgdzs5ZzkTs/RRclfJe1inzTfK?=
 =?us-ascii?Q?Xzs7XJt5FLTu35gAmdL92A6gOW0Abqv7hv206fy2Yu80l5HSce/ZRNvR6nMX?=
 =?us-ascii?Q?nf1mA1yzBuuzLMnJEEA+41Ijejkd3UArjDcop2bFhs9qOlnoup6ZNubERBkb?=
 =?us-ascii?Q?iUtOkJSfAartI8vFgjKPyGExjATz30m/kPZtE4JfUztqPlXIkxGbSqS+mdk2?=
 =?us-ascii?Q?GlTJ01r58euX33AqH5DSolnvvTV9bsf0TWv7po+e2WVh7ZA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17FC10C8C2CDC045AA51794C4167E3EE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74141d26-fa30-4e75-769c-08d8a2d84a3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2020 22:08:31.4773
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QYl2nELyxcsG2wt8F7D2iXX2sZ1/IwizI+wzgi0opUsw0idh3V6IKr3QYP7v1Zmv+tUREf6ncDLu5rLr8SONxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3208
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_14:2020-12-17,2020-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 spamscore=0
 adultscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=938 priorityscore=1501 malwarescore=0 suspectscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170144
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 17, 2020, at 11:03 AM, Alexei Starovoitov <alexei.starovoitov@gmai=
l.com> wrote:
>=20
> On Tue, Dec 15, 2020 at 03:36:59PM -0800, Song Liu wrote:
>> +/*
>> + * Key information from vm_area_struct. We need this because we cannot
>> + * assume the vm_area_struct is still valid after each iteration.
>> + */
>> +struct __vm_area_struct {
>> +	__u64 start;
>> +	__u64 end;
>> +	__u64 flags;
>> +	__u64 pgoff;
>> +};
>=20
> Where it's inside .c or exposed in uapi/bpf.h it will become uapi
> if it's used this way. Let's switch to arbitrary BTF-based access instead=
.
>=20
>> +static struct __vm_area_struct *
>> +task_vma_seq_get_next(struct bpf_iter_seq_task_vma_info *info)
>> +{
>> +	struct pid_namespace *ns =3D info->common.ns;
>> +	struct task_struct *curr_task;
>> +	struct vm_area_struct *vma;
>> +	u32 curr_tid =3D info->tid;
>> +	bool new_task =3D false;
>> +
>> +	/* If this function returns a non-NULL __vm_area_struct, it held
>> +	 * a reference to the task_struct. If info->file is non-NULL, it
>> +	 * also holds a reference to the file. If this function returns
>> +	 * NULL, it does not hold any reference.
>> +	 */
>> +again:
>> +	if (info->task) {
>> +		curr_task =3D info->task;
>> +	} else {
>> +		curr_task =3D task_seq_get_next(ns, &curr_tid, true);
>> +		if (!curr_task) {
>> +			info->task =3D NULL;
>> +			info->tid++;
>> +			return NULL;
>> +		}
>> +
>> +		if (curr_tid !=3D info->tid) {
>> +			info->tid =3D curr_tid;
>> +			new_task =3D true;
>> +		}
>> +
>> +		if (!curr_task->mm)
>> +			goto next_task;
>> +		info->task =3D curr_task;
>> +	}
>> +
>> +	mmap_read_lock(curr_task->mm);
>=20
> That will hurt. /proc readers do that and it causes all sorts
> of production issues. We cannot take this lock.
> There is no need to take it.
> Switch the whole thing to probe_read style walking.
> And reimplement find_vma with probe_read while omitting vmacache.
> It will be short rbtree walk.
> bpf prog doesn't need to see a stable struct. It will read it through ptr=
_to_btf_id
> which will use probe_read equivalent underneath.

rw_semaphore is designed to avoid write starvation, so read_lock should not=
 cause
problem unless the lock was taken for extended period. [1] was a recent fix=
 that=20
avoids /proc issue by releasing mmap_lock between iterations. We are using =
similar
mechanism here. BTW: I changed this to mmap_read_lock_killable() in the nex=
t version.=20

On the other hand, we need a valid vm_file pointer for bpf_d_path. So walki=
ng the=20
rbtree without taking any lock would not work. We can avoid taking the lock=
 when=20
some SPF like mechanism merged (hopefully soonish).=20

Did I miss anything?=20

We can improve bpf_iter with some mechanism to specify which task to iterat=
e, so=20
that we don't have to iterate through all tasks when the user only want to =
inspect=20
vmas in one task.=20

Thanks,
Song

[1] ff9f47f6f00c ("mm: proc: smaps_rollup: do not stall write attempts on m=
map_lock")

