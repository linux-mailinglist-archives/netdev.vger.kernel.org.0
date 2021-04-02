Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A00353187
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 01:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235626AbhDBXbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 19:31:47 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22358 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234161AbhDBXbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 19:31:46 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 132NUKS4023239;
        Fri, 2 Apr 2021 16:31:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/AmXCPS1NqlmpEkrOfTPVUr5TQfNM3v7bz+SCfHTxM0=;
 b=f0u6atJ3PvyGUCLgIvw6/+vN7RyprgNLClDb2HbXliQlyJciF6EIqdXI86xFd6CW2VZ6
 uezb10aP2Iwi6hB411wBdfBsjsMHLIPOkrDuTI34TCUHHE5J2SsYZSoP2s1/KaDoNfCA
 wwkCC+qjqUkG5rHyNGrmEcApo0MdF2LyOSs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 37p026cx5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 02 Apr 2021 16:31:29 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 2 Apr 2021 16:31:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENPrSBerJlAaaY2Zi9eOBw0V6P78dUsJPyggltizGI21drOkIGoMWiZoH3pS1Sd+fR/2+AKKlokN/kUx6dDaU0j3wDJLtsDncn853ClzM5NJ5zihuMxVMzl2YtwG0Fg8Gaao1IRCCEkphNd0e1Fby2HQud9AD9pB5GHZIHXRjJ61uqofkXjixSvF+9L+pLprjjehzUAO2vXXYMWz6dPY0+fsxfzBKBiwXT3yYooO3YFMUs+3OEZG25/Da+FaXHZzJiEk+84OKns0Bi03fCFsq8Lboe3kmYBC3UY+q+WmMxkm3mFrlzkVgESUnEcLbQB/M6DhDSeRZS4W0OgUKPwLwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/AmXCPS1NqlmpEkrOfTPVUr5TQfNM3v7bz+SCfHTxM0=;
 b=WVrGY0+DFOqrTnOu5MkkgC28pBKb1BvAHaNaILvuH3R6axgKvkl5x9AIN6/BEMwok7/Tn5mCqSY0UPeNkp3lrm6r12W0/HftCKghNMI0W7tSb6oHyTnyMMGoY9hXXPZIjjCldvStofKd4bArqkiXiNxWdWyZcuW7bZvJM9FQNiMbrv6thqYsKER0cc3uEjSqkNFmZ9LOGs+s2VN+Rntp7/n8/g6bU3vRGH6V1K+KHoqx2LvesH+IgQR5r3L4mQmdk/M0Dl147JUJxcPoxFPBIP0jJeEzPaf37qst4/HW0n1/ACs4403pVUPDkypuuMVq3crBws0z1IzJpL1iseMBWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2568.namprd15.prod.outlook.com (2603:10b6:a03:14c::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 2 Apr
 2021 23:31:26 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.039; Fri, 2 Apr 2021
 23:31:26 +0000
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
Thread-Index: AQHXJq9GCj74A7YdlUumCh5fgR8tjaqfNeUAgAC1hACAAC9hgIABZM4AgAAGWACAABPLgIAACd2AgAAUn4CAACsBAA==
Date:   Fri, 2 Apr 2021 23:31:25 +0000
Message-ID: <93C90E13-4439-4467-811C-C6E410B1816D@fb.com>
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <B42B247A-4D0B-4DE9-B4D3-0C452472532D@fb.com>
 <CAM_iQpW-cuiYsPsu4mYZxZ1Oixffu2pV1TFg1c+eg9XT3wWwPQ@mail.gmail.com>
 <E0D5B076-A726-4845-8F12-640BAA853525@fb.com>
 <CAM_iQpWdO7efdcA2ovDsOF9XLhWJGgd6Be5qq0=xLphVBRE_Gw@mail.gmail.com>
 <93BBD473-7E1C-4A6E-8BB7-12E63D4799E8@fb.com>
 <CAM_iQpXEuxwQvT9FNqDa7y5kNpknA4xMNo_973ncy3iYaF-NTA@mail.gmail.com>
 <390A7E97-6A9A-48E4-A0B0-D1B9F5EB3308@fb.com>
 <CAM_iQpVZdju0KhTV1_jQYjad4p++hNAfikH5FsaOCZrcGFFDYA@mail.gmail.com>
In-Reply-To: <CAM_iQpVZdju0KhTV1_jQYjad4p++hNAfikH5FsaOCZrcGFFDYA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:d190]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 599ad96a-a7a8-4807-db8f-08d8f62f6f17
x-ms-traffictypediagnostic: BYAPR15MB2568:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2568E4A9DAA54600EF729EA1B37A9@BYAPR15MB2568.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zZ5roO0y1vxEc/zHiPntU/+8tyy6Alj6ppktClWpfSSpcnpniDm1I/16RhTmR/J17bxZ9VIvB0IDmSb2KSgx9urnSn6vrUbtODehleo4r4CrIruFfyCdnNSEg6xOHt3T0EysSyg6e/bN5+ZcxvjDMDPyfgbYtMDKwMUkpi+35NzUjq8eVbPld5Dyk0tTgWpRpwC5888eJ9kqwd3IVo4QQmYlXWTMy1ozgVkFwNnLiHUMSTjmoVP6qCTFGQjta05jWDG0+51XjOo7Y4OhMZeILjmgeFjOZWwf/sRobqSZb+df8sSqOPBJkA+e8fmmbrezPrvpMq/YJdL4Hlqpk+D05Ll0oJVexJMOIs5wwQn94Q+oxoMPgbl7Ba4veX6HyevqkYKODkLB/+f5TN0qgxYuIONQdR4pdzRxTR2Ae2JIgAkjXnTltFX3IKyLYE0/A5bwFQb6WHRToM1obQQcJJeGWscRBwNhpMO8xCOjkGXwYs8VCDTrgZPR8V5MNLnpsXOsmcIxn/lZwnqXAhpMLCWjf9UWA57pDBAmrNzioTk8LHSVFZiyFLNtbtHV6yGNwhhn37+jLVs9YCWw4Nvpl+DqfcIre9+xj34aGEacR4AZvKTlxTYTgug+Qvq9pcZX2vXE0jcKqb0JPIxiP28EC7oBJU6Vba66t+FvCop+JD7p3G68lnGvnstI8gqyVyxBqmmX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39860400002)(2906002)(83380400001)(6916009)(2616005)(33656002)(478600001)(7416002)(5660300002)(316002)(8936002)(54906003)(66556008)(8676002)(71200400001)(186003)(66446008)(38100700001)(86362001)(36756003)(6512007)(4326008)(64756008)(91956017)(76116006)(66946007)(66476007)(6486002)(6506007)(53546011)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?uMjozcVOM7H/ke3OSpf7rgBAn768mO3J3u64h8mdwJyBEV2JnJWV+kJq3txS?=
 =?us-ascii?Q?1dAisAn1UCuUYRY5wE4VIcTYHSz+oQdvWTvfSv61E3VyUPymiCNrQok9HCv/?=
 =?us-ascii?Q?WA0951GJOJPob2OuVcXJr34oLUX36oUpchw27DLPXzFXu6W2PCHlbwd96yps?=
 =?us-ascii?Q?i9tMj5S5KM22WI/rz7+2SB45kVWJXzGFbfsu59s2L8aby/5fy7IEPLgM6Ylc?=
 =?us-ascii?Q?xeLF7Tf8vBzbN/mnUTGqKpx4vSD4hAyxoVwf3H8TGpueZ15N5CnHAvmIyoFk?=
 =?us-ascii?Q?brFlaYAF0tbHhHf6Lmmmhk93KjkYNy6nUxnTLcbXGtTDULxIMR9Tr0ch7J6q?=
 =?us-ascii?Q?Jy+4fSs3SqEFOb9tkUAJqpcFotZ++5E5lngHiQGuObwVquR2JGbyS4OTCUcF?=
 =?us-ascii?Q?aAmYQtfU4De/NQRXG+8jMWfZibnr3JP/rIzi06nvVH0rOF8WfY0eElr0c9p7?=
 =?us-ascii?Q?gKIZDNJtf/C1G1fB6TtslC0WuH/C0UnSfJw6yRQxD4lLoEavyIemeMKkRDjp?=
 =?us-ascii?Q?G8FDwbeh1bccJMLOP0SIM0HHGablQLyA7oom1Uofj1cI4kfhFSZdePHhIl2g?=
 =?us-ascii?Q?ojKUIGn4QXq/VNHgc0l/7sczMnaIZgtQ0BqTr8rM1XpfAVL03r9gNXVEhxhk?=
 =?us-ascii?Q?6puaTLfukTUrc1k2Llu8ZN9M6niFJ6hV9LFMrpwdyxamA+CHZscj3PvIgIYc?=
 =?us-ascii?Q?sU2f8jCDSYq+cao0AtAcIb2C083hYAVDKA4pW8TjQ7GelMN7YGmoAsRgBrQw?=
 =?us-ascii?Q?N07CnFqHzscZqz9XfoiYCcEzT9nj0cEse2L1pfdBFDaduekcDovmXUUb4RyA?=
 =?us-ascii?Q?Cx0uYuqdg3sCFvd1gYyQlb1Gmyiys6PZzNi1QD9qZ34WeLkiYCLOBOEgJbTf?=
 =?us-ascii?Q?2/vfDQnbTRDpJiYAezBsx50BswtiZzFAquzxwoIiTZAXMj6rSIPGVxnzPVpp?=
 =?us-ascii?Q?tQjXs6ZxBEpgtxdqgnTHJvmfvNSNgoL6X6S9CVzyo2AY2gyxI6r8uxRhnmWJ?=
 =?us-ascii?Q?HVYrPxv4bkfn56ppsg7EsAdvO2zFma5IVILj2L0/GteEldbePVUXjO+d0WMn?=
 =?us-ascii?Q?TqEPsfVhodpzbwqIQ4qAo1eKYk211LfD44tgb1tygtWkQkCWtWc0hw/ES6Ii?=
 =?us-ascii?Q?SVtnnY7ktXrgE7V0iZ38RP16N2/jJi6tEySNjqvamuyn6scw0X+cwFHk7s/0?=
 =?us-ascii?Q?qwyG7ch+R95rzDYqN8BtmdSDPOBQuMphEXP0GqyWC25XjWmuquIwwYmC3yi1?=
 =?us-ascii?Q?QBwyk6pYO9S56kU8sopA5GY55xjx/AfKN+Dt8NAomHWD3j8eTpQNTmwqYCvp?=
 =?us-ascii?Q?0Qm4RyQQgGR4vc4qBSOlNJAgjRtk1FsD1w2mLhS6BbbMfokyQB8WQCg+JTxo?=
 =?us-ascii?Q?yIDbTGY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CCF7202D993D1840A5B568419F1A2033@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 599ad96a-a7a8-4807-db8f-08d8f62f6f17
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2021 23:31:25.9336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UE5Bax76a9A8iVpIXbL5tyHjnMgg3XTHirQ4aosQKsXFdeiy4+Zb6kzYewzpxipP35sPw/w+LyxsfKwZmBAdaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2568
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: AZmI7vyt7cV9tb5TYek1kgUPwTUrZkdl
X-Proofpoint-ORIG-GUID: AZmI7vyt7cV9tb5TYek1kgUPwTUrZkdl
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-02_16:2021-04-01,2021-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104020158
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 2, 2021, at 1:57 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>=20
> On Fri, Apr 2, 2021 at 12:45 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Apr 2, 2021, at 12:08 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote=
:
>>>=20
>>> On Fri, Apr 2, 2021 at 10:57 AM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>>=20
>>>>=20
>>>>> On Apr 2, 2021, at 10:34 AM, Cong Wang <xiyou.wangcong@gmail.com> wro=
te:
>>>>>=20
>>>>> On Thu, Apr 1, 2021 at 1:17 PM Song Liu <songliubraving@fb.com> wrote=
:
>>>>>>=20
>>>>>>=20
>>>>>>=20
>>>>>>> On Apr 1, 2021, at 10:28 AM, Cong Wang <xiyou.wangcong@gmail.com> w=
rote:
>>>>>>>=20
>>>>>>> On Wed, Mar 31, 2021 at 11:38 PM Song Liu <songliubraving@fb.com> w=
rote:
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>>> On Mar 31, 2021, at 9:26 PM, Cong Wang <xiyou.wangcong@gmail.com>=
 wrote:
>>>>>>>>>=20
>>>>>>>>> From: Cong Wang <cong.wang@bytedance.com>
>>>>>>>>>=20
>>>>>>>>> (This patch is still in early stage and obviously incomplete. I a=
m sending
>>>>>>>>> it out to get some high-level feedbacks. Please kindly ignore any=
 coding
>>>>>>>>> details for now and focus on the design.)
>>>>>>>>=20
>>>>>>>> Could you please explain the use case of the timer? Is it the same=
 as
>>>>>>>> earlier proposal of BPF_MAP_TYPE_TIMEOUT_HASH?
>>>>>>>>=20
>>>>>>>> Assuming that is the case, I guess the use case is to assign an ex=
pire
>>>>>>>> time for each element in a hash map; and periodically remove expir=
ed
>>>>>>>> element from the map.
>>>>>>>>=20
>>>>>>>> If this is still correct, my next question is: how does this compa=
re
>>>>>>>> against a user space timer? Will the user space timer be too slow?
>>>>>>>=20
>>>>>>> Yes, as I explained in timeout hashmap patchset, doing it in user-s=
pace
>>>>>>> would require a lot of syscalls (without batching) or copying (with=
 batching).
>>>>>>> I will add the explanation here, in case people miss why we need a =
timer.
>>>>>>=20
>>>>>> How about we use a user space timer to trigger a BPF program (e.g. u=
se
>>>>>> BPF_PROG_TEST_RUN on a raw_tp program); then, in the BPF program, we=
 can
>>>>>> use bpf_for_each_map_elem and bpf_map_delete_elem to scan and update=
 the
>>>>>> map? With this approach, we only need one syscall per period.
>>>>>=20
>>>>> Interesting, I didn't know we can explicitly trigger a BPF program ru=
nning
>>>>> from user-space. Is it for testing purposes only?
>>>>=20
>>>> This is not only for testing. We will use this in perf (starting in 5.=
13).
>>>>=20
>>>> /* currently in Arnaldo's tree, tools/perf/util/bpf_counter.c: */
>>>>=20
>>>> /* trigger the leader program on a cpu */
>>>> static int bperf_trigger_reading(int prog_fd, int cpu)
>>>> {
>>>>       DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
>>>>                           .ctx_in =3D NULL,
>>>>                           .ctx_size_in =3D 0,
>>>>                           .flags =3D BPF_F_TEST_RUN_ON_CPU,
>>>>                           .cpu =3D cpu,
>>>>                           .retval =3D 0,
>>>>               );
>>>>=20
>>>>       return bpf_prog_test_run_opts(prog_fd, &opts);
>>>> }
>>>>=20
>>>> test_run also passes return value (retval) back to user space, so we a=
nd
>>>> adjust the timer interval based on retval.
>>>=20
>>> This is really odd, every name here contains a "test" but it is not for=
 testing
>>> purposes. You probably need to rename/alias it. ;)
>>>=20
>>> So, with this we have to get a user-space daemon running just to keep
>>> this "timer" alive. If I want to run it every 1ms, it means I have to i=
ssue
>>> a syscall BPF_PROG_TEST_RUN every 1ms. Even with a timer fd, we
>>> still need poll() and timerfd_settime(). This is a considerable overhea=
d
>>> for just a single timer.
>>=20
>> sys_bpf() takes about 0.5us. I would expect poll() and timerfd_settime()=
 to
>> be slightly faster. So the overhead is less than 0.2% of a single core
>> (0.5us x 3 / 1ms). Do we need many counters for conntrack?
>=20
> This is just for one timer. The whole system may end up with many timers
> when we have more and more eBPF programs. So managing the timers
> in the use-space would be a problem too someday, clearly one daemon
> per-timer does not scale.

If we do need many timers, I agree that it doesn't make sense to create=20
a thread for each of them.=20

A less-flexible alternative is to create a perf_event of "cpu-clock" and=20
attach BPF program to it. It is not easy to adjust the interval, I guess.

>=20
>>=20
>>>=20
>>> With current design, user-space can just exit after installing the time=
r,
>>> either it can adjust itself or other eBPF code can adjust it, so the pe=
r
>>> timer overhead is the same as a kernel timer.
>>=20
>> I guess we still need to hold a fd to the prog/map? Alternatively, we ca=
n
>> pin the prog/map, but then the user need to clean it up.
>=20
> Yes, but I don't see how holding a fd could bring any overhead after
> initial setup.
>>=20
>>>=20
>>> The visibility to other BPF code is important for the conntrack case,
>>> because each time we get an expired item during a lookup, we may
>>> want to schedule the GC timer to run sooner. At least this would give
>>> users more freedom to decide when to reschedule the timer.
>>=20
>> Do we plan to share the timer program among multiple processes (which ca=
n
>> start and terminate in arbitrary orders)? If that is the case, I can ima=
gine
>> a timer program is better than a user space timer.
>=20
> I mean I want other eBPF program to manage the timers in kernel-space,
> as conntrack is mostly in kernel-space. If the timer is only manageable
> in user-space, it would seriously limit its use case.
>=20
> Ideally I even prefer to create timers in kernel-space too, but as I alre=
ady
> explained, this seems impossible to me.

Would hrtimer (include/linux/hrtimer.h) work?=20

Thanks,
Song





