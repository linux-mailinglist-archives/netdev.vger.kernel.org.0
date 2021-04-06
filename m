Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0437F354CA6
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 08:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237421AbhDFGSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 02:18:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24248 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236986AbhDFGSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 02:18:20 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1366FQ5N022505;
        Mon, 5 Apr 2021 23:17:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=03Tp/xLr4ihyugksM3v4eJOPvTuhVSrPYXmCiOvWKEM=;
 b=KGgRRJwZBuhAC2hwSK+/nUXX4imexwh9MIi+hAvH7l/pBw3tPrE8M2uD9lx3gCpE4Woy
 gg2W6FnUy8vT/7FXqGuSPg2J1NdQtI1Ue0QYZZVKIcDdx0s5NGUhCvizVEip7Prgr33l
 ChvwHaQV1mNvyOhKicZFaDTnsLH8lJdmOsk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37r5bcbhax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 05 Apr 2021 23:17:59 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Apr 2021 23:17:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8Pi0ERbLka+vG3ZlVjYPRgurR70JYXOLG8O5chM3StQbP3hae4jKmXxAj13UfashwWg5gAfcAcMlwF8j01dmgusnn6kJk5Qfbh4D+h/ujNzapAT4E0USynuVotdUo1CV3gtsQtUFlgE5irRGt8yr9tAzEG1S/CSy/WWuJcIp1Xe7n1DvS+HiL+QHlfZIHiV4ftDws+qMZvL9FGCG7iMQKQstfwN1JIfvY3Mc23f+VZL+v2q0G9LhUfWo+Eo32qm5aIDFkId0DLOd/sor6f34mjJaTfuFCH2WkYujCMf7uP9DruW7hkMd0BNwLAWz3pZnNjJuYEudI5ORRWK3Xz2TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03Tp/xLr4ihyugksM3v4eJOPvTuhVSrPYXmCiOvWKEM=;
 b=Jyn4hsqUE1wglkJOWAVPC/BOFIh9ztc/H++E0krddUsTlMSwgNgEU7er2c9Ac40t51AzhN6a0jyjN9yQexmCC6Zrxf2HBaQ61Sw+4rWolGcxsdCjIrUe+GdfCVDLVZxse9C747BWSsnvfhvqnhA2hE9BLO7iXsnM8ERl8ZV6h2U1lRBI9wmEmEstRhH9BrpN95EZTZ7DcjTxK4DnRMstp3DtDJsiqfaBnOxEooI6F4Sk4Btl67c238fYwFNtpZ+jdgZ17215+TaJ3P6LK0OtpLsnEiiUkpv3h6cEykEUfQwpRmBaQ5g4iWaM1QpN+9uvcGP61N04orEjpN/d1wN1zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2821.namprd15.prod.outlook.com (2603:10b6:a03:15d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Tue, 6 Apr
 2021 06:17:55 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.039; Tue, 6 Apr 2021
 06:17:55 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>,
        "duanxiongchun@bytedance.com" <duanxiongchun@bytedance.com>,
        "wangdongdong.6@bytedance.com" <wangdongdong.6@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        "Cong Wang" <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin Lau" <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
Thread-Topic: [RFC Patch bpf-next] bpf: introduce bpf timer
Thread-Index: AQHXJq9GCj74A7YdlUumCh5fgR8tjaqfNeUAgAC1hACAAC9hgIABZM4AgAAGWACAABPLgIAACd2AgAAUn4CAACsBAIAEvAoAgAAV7QCAAASQAIAAUgmA
Date:   Tue, 6 Apr 2021 06:17:55 +0000
Message-ID: <45B3E744-000D-4958-89C0-A5E83959CD4A@fb.com>
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <B42B247A-4D0B-4DE9-B4D3-0C452472532D@fb.com>
 <CAM_iQpW-cuiYsPsu4mYZxZ1Oixffu2pV1TFg1c+eg9XT3wWwPQ@mail.gmail.com>
 <E0D5B076-A726-4845-8F12-640BAA853525@fb.com>
 <CAM_iQpWdO7efdcA2ovDsOF9XLhWJGgd6Be5qq0=xLphVBRE_Gw@mail.gmail.com>
 <93BBD473-7E1C-4A6E-8BB7-12E63D4799E8@fb.com>
 <CAM_iQpXEuxwQvT9FNqDa7y5kNpknA4xMNo_973ncy3iYaF-NTA@mail.gmail.com>
 <390A7E97-6A9A-48E4-A0B0-D1B9F5EB3308@fb.com>
 <CAM_iQpVZdju0KhTV1_jQYjad4p++hNAfikH5FsaOCZrcGFFDYA@mail.gmail.com>
 <93C90E13-4439-4467-811C-C6E410B1816D@fb.com>
 <CAM_iQpXrnXU85J=fa5+QjRqgo_evGfkfLU9_-aVdoyM_DJU2nA@mail.gmail.com>
 <DCAF6E05-7690-4B1D-B2AD-633B58E8985F@fb.com>
 <CAM_iQpW+=-RsxfYU_fWm+=9MSr6EzCvKwUayH3FyaPpopAtpWQ@mail.gmail.com>
In-Reply-To: <CAM_iQpW+=-RsxfYU_fWm+=9MSr6EzCvKwUayH3FyaPpopAtpWQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:57e2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff56cd22-7220-49b3-dcbc-08d8f8c3b760
x-ms-traffictypediagnostic: BYAPR15MB2821:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB28218C4EC9B27D8975311A11B3769@BYAPR15MB2821.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JoAovxOTX6vGBVArUIeyhv0NNYh6+A3QwTAxESfkl2klEow3YVYiSDG4glVporMPt6byEMUrwuZpr2yvsGsGBeI54VEG5u9xtSH/1MzYZRPYwAJZbjv9ov8G6sF8Nk73VLGBUTRl7yk6sDqd3EngsTlxB3UrpwXGRfnh3WJeLlbDKNMMtsQCTVxIclx/IkmjefUbDkot5GTbcBC26FThaQ0OClKsbdt3z8ikcF0xYYbWWXeqsCTzL7QQBnlIf1zKMU9dzuNs7GdnehQivxTIP/dHvXdRIjtG2aEjLx9usBfbiFApH4d2mLI5bvlM8uPF6q1koIG1rJ03pDgdMWe/Od1f07lNrGm0VMuj/0oNwIoi5kkgUTKXH5hUS0067+5v8+uqFriAr/WvTUmKM+zC8VxS0ROQXVIPtGJUpA6NCEnXHmUojq8G3qQgJSY/H5y0UVPfgHR7mlgSX07HTstSr6MtShFtMTFUyfHpEWhOqjFCnocNDA+S2SlttxN1TIR42NH651DZc+MEp3BXo9MvdtSoHR5d02xmZiyPlsDUFDR8qCeeDdNOc5t3kki0cPn2tgX6EYyOAiJEApYywuJgUJdXbgamNWqkoBqxmNVz1pizcCTTkCxkZV/Sh74At+crQ/GTci2kT+OHc1GLnOtBxoNntk4KvBaAqUiN8gdA0cJGzC7V2avsLJC9T7Ha2VjIaN9dLPHKxIq6fnVpRM1iow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(136003)(346002)(396003)(8676002)(478600001)(54906003)(6486002)(66556008)(7416002)(4326008)(6512007)(36756003)(71200400001)(91956017)(64756008)(86362001)(53546011)(33656002)(66446008)(66946007)(2906002)(8936002)(6916009)(66476007)(316002)(83380400001)(186003)(6506007)(76116006)(5660300002)(38100700001)(2616005)(21314003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?2ucPVBN7Qdt34TLOinjD8U3gsf4LK3GDJwF1wGsmPJB95a5PW5Q2orFx1m6M?=
 =?us-ascii?Q?4Hf2XE7yYwD5RRfkexmWYPiEts1dMFG3LOltgb1jPFVnpC6RR/QoUyAn7RxA?=
 =?us-ascii?Q?IgB+F957kPwAqHcYVj0b7CB9tSZYfW+0qHy7x1HyKpdZliIlA2OBQQN95HEp?=
 =?us-ascii?Q?K2hBB/OeunlzMGSr2PU1/Kb+zmy27cSubVv65qxh/HjI+zt6z/zCyxRGnrRo?=
 =?us-ascii?Q?YoMRssG/IFly0VlaECDviPilNjM55Tn3cWV/hnP8cN9vRXeYlbo5HAAyMcEc?=
 =?us-ascii?Q?dvQ2D1MkTFCaY2+od5FL43XLaM2zu6w/r67doVVwyfJR0Ekm1p1h8J1sk7Tj?=
 =?us-ascii?Q?1+AhpZ0nXx9objN0MNa5jCAQZnRGweIlUjG4il9yrbqgzB36z4P21rDAlYvv?=
 =?us-ascii?Q?bbfRaxh/EIbbtTQzBdz6ifHptnLotEV4crZozpCdoTr1FN25AFSqbRAeekE2?=
 =?us-ascii?Q?WcUeXi+o5rb55YayE7isN7gXG8pOoKspI/9+MUJzlGO7YZbwX2CLnCJB34Yr?=
 =?us-ascii?Q?lDizAbpw7CuTW/0VyGsnrx0X+gL1pQOKKaGo7YPsN/65/HqlHO+Jx23b6J90?=
 =?us-ascii?Q?kmELn4T+CRu1ToYEe48sxIkEgGMGz/PMpWzbKJat9UUkMhL0YbDuxsiR9HI9?=
 =?us-ascii?Q?DAaFbrRR3KeUKuVfWC7sKOQvid61It1HyAPiNxlLtnXpKz1XC4wstK+62Q85?=
 =?us-ascii?Q?LDMPwJ9ptvPF5uZTgmdAX5Z6nj836Rrohc6LXer7KFQgYFtJh3ISNqKBe4Uw?=
 =?us-ascii?Q?5oaz812E1Nw9ntdYOMlp0JDfZ5CN3yMlNkKS7vnDXcTFxEVIPWEKiIhFE4u1?=
 =?us-ascii?Q?huo51A5lXXREzDFCTOValsNmZ0+TGSLSaJ/zfEcyNOugxFWwWpqxeV/ahn3d?=
 =?us-ascii?Q?9W9d/PZoOAQ3d+bMjNIkteL8GSBw+bnSNdSrikmuLLPBA2aOHXa9unqiErso?=
 =?us-ascii?Q?bI5ZAtFTEGI5DpFJh4bENylahSxhyU64pLO/tvo+fsziRcLxKYgF8z9ICsWw?=
 =?us-ascii?Q?2aiLu2grnA4OdM4sPGNQSJpWNvIyj1gnt0cNK5x1yGtTOBXjonWu5CHgEDjX?=
 =?us-ascii?Q?rXOlYZiXnuPr8RrEaqtKHpdb/q30Hm9BtBONSxsaNlwi8Qc8aBKIPE1BCOkq?=
 =?us-ascii?Q?ARhh87baiwHNZRKH8DY+DdmfCt4jkiM5Tbiq/lXeXkDvAYCfAPyZCe1uttgl?=
 =?us-ascii?Q?j3iWGueYVEPtnj2zBM9W17R+aZ4KC5Cr+J+LojQ9aF2qKx69x7l50v16sche?=
 =?us-ascii?Q?b80ZEtwkVTEk8TWbVmCTFWR2pX4pknAv2ZmdJnlD/FpYYpxZJcKiqKHLdd9E?=
 =?us-ascii?Q?pHtpf09z+4DNZffk8BY3H5AuI+MrUGAolraJM6koh7G/UqCvH0DMIjJWY2PG?=
 =?us-ascii?Q?ZKIbaMQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <90AA39D273B8F644930E0728230BE183@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff56cd22-7220-49b3-dcbc-08d8f8c3b760
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2021 06:17:55.0675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zmZoVUPE/kLcoLjLsrZnYwfWXVcZsVVH4oUplqpAUe5AbZYmbXBMHFjubM1jXHOl3JUJQxrXxw6E8OQSmRp3MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2821
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 6uqOv9HBtxyPT4jIkumTqTLvwSKOl23T
X-Proofpoint-ORIG-GUID: 6uqOv9HBtxyPT4jIkumTqTLvwSKOl23T
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_01:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 malwarescore=0 bulkscore=0 impostorscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060044
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 5, 2021, at 6:24 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>=20
> On Mon, Apr 5, 2021 at 6:08 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Apr 5, 2021, at 4:49 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>>=20
>>> On Fri, Apr 2, 2021 at 4:31 PM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>>=20
>>>>=20
>>>>> On Apr 2, 2021, at 1:57 PM, Cong Wang <xiyou.wangcong@gmail.com> wrot=
e:
>>>>>=20
>>>>> Ideally I even prefer to create timers in kernel-space too, but as I =
already
>>>>> explained, this seems impossible to me.
>>>>=20
>>>> Would hrtimer (include/linux/hrtimer.h) work?
>>>=20
>>> By impossible, I meant it is impossible (to me) to take a refcnt to the=
 callback
>>> prog if we create the timer in kernel-space. So, hrtimer is the same in=
 this
>>> perspective.
>>>=20
>>> Thanks.
>>=20
>> I guess I am not following 100%. Here is what I would propose:
>>=20
>> We only introduce a new program type BPF_PROG_TYPE_TIMER. No new map typ=
e.
>> The new program will trigger based on a timer, and the program can someh=
ow
>> control the period of the timer (for example, via return value).
>=20
> Like we already discussed, with this approach the "timer" itself is not
> visible to kernel, that is, only manageable in user-space. Or do you disa=
gree?

Do you mean we need mechanisms to control the timer, like stop the timer,=20
trigger the timer immediately, etc.? And we need these mechanisms in kernel=
?
And by "in kernel-space" I assume you mean from BPF programs.=20

If these are correct, how about something like:

1. A new program BPF_PROG_TYPE_TIMER, which by default will trigger on a ti=
mer.=20
   Note that, the timer here is embedded in the program. So all the operati=
ons
   are on the program.=20
2. Allow adding such BPF_PROG_TYPE_TIMER programs to a map of type=20
   BPF_MAP_TYPE_PROG_ARRAY.=20
3. Some new helpers that access the program via the BPF_MAP_TYPE_PROG_ARRAY=
 map.=20
   Actually, maybe we can reuse existing bpf_tail_call().=20

The BPF program and map will look like:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D 8< =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
struct data_elem {
	__u64 expiration;
	/* other data */
};=20

struct {
	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
	__uint(max_entries, 256);
	__type(key, __u32);
	__type(value, struct data_elem);
} data_map SEC(".maps");

struct {
	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
	__uint(max_entries, 256);
	__type(key, __u32);
	__type(value, __u64);
} timer_prog_map SEC(".maps");

static __u64
check_expired_elem(struct bpf_map *map, __u32 *key, __u64 *val,
                 int *data)
{
	u64 expires =3D *val;

	if (expires < bpf_jiffies64()) {
		bpf_map_delete_elem(map, key);
		*data++;
	}
 return 0;
}

SEC("timer")
int clean_up_timer(void)
{
	int count;

	bpf_for_each_map_elem(&data_map, check_expired_elem, &count, 0);
	if (count)
 		return 0; // not re-arm this timer
 	else
 		return 10; // reschedule this timer after 10 jiffies
}

SEC("tp_btf/XXX")
int another_trigger(void)
{
	if (some_condition)
		bpf_tail_call(NULL, &timer_prog_map, idx);
	return 0;
}

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D 8< =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Would something like this work for contract?

Thanks,
Song

>=20
>>=20
>> With this approach, the user simply can create multiple timer programs a=
nd
>> hold the fd for them. And these programs trigger up to timer expiration.
>=20
> Sure, this is precisely why I moved timer creation to user-space to solve
> the refcnt issue. ;)
>=20
>>=20
>> Does this make sense?
>=20
> Yes, except kernel-space code can't see it. If you look at the timeout ma=
p
> I had, you will see something like this:
>=20
> val =3D lookup(map, key);
> if (val && val->expires < now)
>   rearm_timer(&timer); // the timer periodically scans the hashmap
>=20
> For conntrack, this is obviously in kernel-space. The point of the code i=
s to
> flush all expired items as soon as possible without doing explicit deleti=
ons
> which are obviously expensive for the fast path.
>=20
> Thanks.

