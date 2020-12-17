Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449F42DCAAE
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 02:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgLQBwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 20:52:19 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42876 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726571AbgLQBwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 20:52:19 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BH1h68g009636;
        Wed, 16 Dec 2020 17:51:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=CvTezpA/eGO1c3cEXocGcrUSPoufMptza7SuCaba0rA=;
 b=gSGTyr7W1bObePVVxhcLTWAzke8+w6IlfAL+OLKpshF/ZUNPrdlQkpsLlafOhQogpRl3
 uPJv5fcCCiQIcz1nyD/IbTYHkQc02YtK0jwoiLhx3YQPsltvVODaAxuSofeV/5F57Htv
 Yfn7N1pkyNVmedC2bPCtGKVliiAJSHVinhE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35fpcwansf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Dec 2020 17:51:22 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 16 Dec 2020 17:51:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsexrg4FHYhqam7tLuop/46bVupKiDuJXJ6Z7W3GwpH3eLovj4yM1CO7U6ohV9D3+BZH4dqsZcQMFtkWkFN1yafr7ezViSr/HnMKFxkWKdGZnncHlETdTsTKxA7tmoNvFgEt3Ix7o7QB8KLbLyWWfFRc9tQUWgLJGIZttSVfBqzMtHzV5QsH/quqxHwl+oFw3iy3ToQpjgV5Kwt4F5Rm4fV9yv54g7zlFePMYbrOaYY/M+aaSob3R2Z5Sejaq2CCNNbfbTffTpid/vxseYFkEEE4IpE7DqZS4wkqwRtRWwvAMoCljgPVfecEhulA1glMSMutaYKtv7OHz/RLTAb2MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CvTezpA/eGO1c3cEXocGcrUSPoufMptza7SuCaba0rA=;
 b=R5Yx7iQZRWwnrrtjhfJ/lKq/D3ifdn7UqOMFA4GLIV0X5MLF2gbXxG/VZkMlj1w2CNCHQlvwuqh8Vay/0H1z6DCYfXNsY/BsI3Amv2IBtFcDR+Y1k25R8ZVXhJXvhDZbNAfNIPWgvN+5SQBv9Me32Nd9ePohe3idBYsegj+qdkaAa7eK7pHy5StV2N8G0AXjOTEUFv667PYtn8vbLhB8eRB4sqNm6fOyj3kfWdhlUDDuIhyvsfZcGY2CKTTy+TQoc1DoZUfkz/ugRU3cmL4VXj+FLyFY0VH9Sh5sqHdFQSATOWOMvpfBEflZuP4yeD1s4/R2TAewk4AOCLEw+A12lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CvTezpA/eGO1c3cEXocGcrUSPoufMptza7SuCaba0rA=;
 b=QVcERWTXYgRESY6iOzCdExlco+6kaTtJY1cyT04tEWo+U6Ohj1rYKkcdFVWjGdw8CnC8ZmYDqKJpAUU+lAEBieL/w3c7XA4ABKl4YAuRycq2ecgfKNfjdPRO6MwAuRuA9By/nZI9zOOMAYIal6QR9Dk80zmb7iSRuE3RJghWCYM=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3366.namprd15.prod.outlook.com (2603:10b6:a03:10d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.19; Thu, 17 Dec
 2020 01:51:13 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3654.025; Thu, 17 Dec 2020
 01:51:13 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        "KP Singh" <kpsingh@chromium.org>, Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Thread-Topic: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Thread-Index: AQHW0zs42cd9AcJBNEyi77fZmX7Jx6n6cmAAgAAVWwA=
Date:   Thu, 17 Dec 2020 01:51:13 +0000
Message-ID: <CE22B399-1CA1-460E-9A74-74B44CCF675E@fb.com>
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-2-songliubraving@fb.com>
 <CAEf4BzYNAd7V=EevVYiz48+q=UjNnRBzfQFA4tTYCX8a9Wfu7A@mail.gmail.com>
In-Reply-To: <CAEf4BzYNAd7V=EevVYiz48+q=UjNnRBzfQFA4tTYCX8a9Wfu7A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c091:480::1:e346]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b5a0c40-b7a8-46a8-abe0-08d8a22e3c1c
x-ms-traffictypediagnostic: BYAPR15MB3366:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3366DA3CBFEE4E70A3926FA9B3C40@BYAPR15MB3366.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gFGKNHRsSord6waUxRwD3qU9tLCBVoR320MV3NnZiObkhsUqDjX7GPzTLXwEYTLucagI8/zzOdbGAV5mduDZWRiISqKURL54hi9/cgM44LkYwjZ15rjDuGaAUSw7AtorLAley5D9xxjzFUV+qPN/dOnIjy7Jng2r2KuwSkJRkXk1Bs73r9pL6BhJmj2NaCWR40AyKJli5gfJeBQhSl+2DsKZzSi6ECbMBJaBS7PseMjUC66SwpF6eVXlsK7B86mH3TLVkB6gPJSW+ZAzSC9d+6OGmbKA2nEu7LnAUtmTr6KZYJhkyWcfkVagJGeuLCbDFO3qBUBpTP5x9txY8qmPcy2uAgD+0qjbGMmJb6DaHpdawNvcZjF9aujjAGDSDtFt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(39860400002)(136003)(396003)(71200400001)(8936002)(64756008)(316002)(6916009)(6506007)(6486002)(54906003)(2906002)(5660300002)(86362001)(8676002)(6512007)(53546011)(83380400001)(66946007)(91956017)(66446008)(186003)(4326008)(478600001)(2616005)(66476007)(33656002)(76116006)(66556008)(36756003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?qJpP8Q6CMPyiM6sHBTP5uDe57lj/CckJ5W6ZFUPu3bjX/Qw7ljbBJQYs/WVS?=
 =?us-ascii?Q?PbR8fwhH5bqrqI0/4dN2RUUnsmkvcpViXC2VPriIIGJw/jvVa1KKW7Gb4HU8?=
 =?us-ascii?Q?yKfzoE4+GwV1GgPC3rDBXwRaBTGyc7OAqeKoZReN0Hr0xZoZlW7u09FE3aWn?=
 =?us-ascii?Q?Iib7MEy3Mq6ExwqnhTp64AZYoXXp8HHMI+sKffckxTsnLNw0MIu/Kgdiz1Ho?=
 =?us-ascii?Q?FJKP2lr7VRYluPD3WNvUwC0i8uY8ihjifqoK3EpM2IirHk5aUS00qZRYG0zU?=
 =?us-ascii?Q?sdBFNndoJvxcYulPJm2jtETPd8AxbpMiuMKRvxCYbTPZWPD5p0mzWbmIQ9Qx?=
 =?us-ascii?Q?DQj8MH/nZy5CUqYe3rGVAdcjEPAu32UoxRaCQyxXOhHA8Lvc0Uv3FB0h6vyp?=
 =?us-ascii?Q?ddgEIhgBTOsmLrv3+zZaGj9QufebONTPNijbuQJuDLbN0SaaHgWMzDTkVMa4?=
 =?us-ascii?Q?jlCqZ1OabwbAfdhw/BmxTmPGN7iP4xSubp7MSOvyrq61f0uBo/fSN04jBNKU?=
 =?us-ascii?Q?8+ekx+CvUvwroBkUmV0l0ngzz4Ur80nkm1XBSSSfQoo8ZQ0y9Jk1YtkgEtsM?=
 =?us-ascii?Q?sPB8VUYgB8RF3VcqfU7IQHByGZg5gso4N7cyJgXBmAJ5y7KFB6yzZlFUXKMu?=
 =?us-ascii?Q?amfRpSEjbWHFseL2hLCCH37Oq9S9qB644NSTQ0mTn/se/kjh3YEdsQS0mt2X?=
 =?us-ascii?Q?irSEXd/vXDrjwCrtSFCcKJN455en9sRSVjVIZzXkXtZ1Z7Slt/6cstA0V7OS?=
 =?us-ascii?Q?hDXxNoX0CjpXjP16euQzqtlnc27Q56QjjCuK4zjPqByl2dflvGIoFEzTNSZw?=
 =?us-ascii?Q?EOGnlVOFEWRyGae+Af5X4Y+xnNPy1nQgXdGuy41DrZpnZwdrdz6h4/ON9S2W?=
 =?us-ascii?Q?k6lCRKBQ6BP8uk5HAGh+E2Cw0HUJSCFp6Ilf/H/YQUOnOYmmW4ZpOiFflJhk?=
 =?us-ascii?Q?0UMEs62OSuOCaLCplOv5kju+qUGOr206hEu5hKIWKxhM4hP48iTgAKCbCtIz?=
 =?us-ascii?Q?bI8jlqGtxaE1Hw3rLVYJXwAcUUdPMvJpGNQfMTOs9YnPi1Q=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2A60E2DA72A0BA428F8C2FF5D8758831@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b5a0c40-b7a8-46a8-abe0-08d8a22e3c1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2020 01:51:13.2533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ps1akh23H9O1TQaak+ykF+KN5LvJhT+mtrYc/uJFm4gLVrC9fHV7NjotSORCtj1dfwD3YaKW5EWAwy+i+Af+AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3366
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_12:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012170010
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 16, 2020, at 4:34 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Tue, Dec 15, 2020 at 3:37 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> Introduce task_vma bpf_iter to print memory information of a process. It
>> can be used to print customized information similar to /proc/<pid>/maps.
>>=20
>> task_vma iterator releases mmap_lock before calling the BPF program.
>> Therefore, we cannot pass vm_area_struct directly to the BPF program. A
>> new __vm_area_struct is introduced to keep key information of a vma. On
>> each iteration, task_vma gathers information in __vm_area_struct and
>> passes it to the BPF program.
>>=20
>> If the vma maps to a file, task_vma also holds a reference to the file
>> while calling the BPF program.
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> include/linux/bpf.h    |   2 +-
>> kernel/bpf/task_iter.c | 205 ++++++++++++++++++++++++++++++++++++++++-
>> 2 files changed, 205 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 07cb5d15e7439..49dd1e29c8118 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -1325,7 +1325,7 @@ enum bpf_iter_feature {
>>        BPF_ITER_RESCHED        =3D BIT(0),
>> };
>>=20
>> -#define BPF_ITER_CTX_ARG_MAX 2
>> +#define BPF_ITER_CTX_ARG_MAX 3
>> struct bpf_iter_reg {
>>        const char *target;
>>        bpf_iter_attach_target_t attach_target;
>> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
>> index 0458a40edf10a..15a066b442f75 100644
>> --- a/kernel/bpf/task_iter.c
>> +++ b/kernel/bpf/task_iter.c
>> @@ -304,9 +304,183 @@ static const struct seq_operations task_file_seq_o=
ps =3D {
>>        .show   =3D task_file_seq_show,
>> };
>>=20
>> +/*
>> + * Key information from vm_area_struct. We need this because we cannot
>> + * assume the vm_area_struct is still valid after each iteration.
>> + */
>> +struct __vm_area_struct {
>> +       __u64 start;
>> +       __u64 end;
>> +       __u64 flags;
>> +       __u64 pgoff;
>=20
> I'd keep the original names of the fields (vm_start, vm_end, etc).

I thought about the names. Unlike the kernel fs/mm code, where there
are many different start/end/offset/flags, the prefix doesn't seem to=20
be helpful in the BPF programs. In fact, it is probably easier for=20
the developers to differentiate __vm_area_struct->start and=20
vm_area_struct->vm_start.

Also, we have bpf_iter__task_vma->file, which is the same as=20
vm_area_struct->vm_file. If we prefix __vm_area_struct members, it=20
will be a little weird to name it either "vm_file" or "file".

Given these reasons, I decided to not have vm_ prefix. Does this make
sense?=20

> But
> there are some more fields which seem useful, like vm_page_prot,
> vm_mm, etc.

vm_page_prot doesn't really provide extra information than vm_flags.=20
Please refer to mm/mmap.c vm_get_page_prot().=20

We have the vm_mm in task->mm, so no need to add it to __vm_area_struct.

>=20
> It's quite unfortunate, actually, that bpf_iter program doesn't get
> access to the real vm_area_struct, because it won't be able to do much
> beyond using fields that we pre-defined here. E.g., there could be
> interesting things to do with vm_mm, but unfortunately it won't be
> possible.
>=20
> Is there any way to still provide access to the original
> vm_area_struct and let BPF programs use BTF magic to follow all those
> pointers (like vm_mm) safely?

We hold a reference to task, and the task holds a reference to task->mm,
so we can safely probe_read information in mm_struct, like the page=20
table.=20

Thanks,
Song

