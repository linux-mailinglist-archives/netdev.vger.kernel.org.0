Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC3F352FE7
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 21:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236406AbhDBTp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 15:45:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31068 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231577AbhDBTpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 15:45:25 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 132JeADv031293;
        Fri, 2 Apr 2021 12:45:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=6ftpB+eaa/jnldkbmn++pAPxvmzriTZMSwXIBS9keTc=;
 b=pelAeU8jMn3K+H/NkRWworBZhUhIF3Y00Km2FO7JOc/bVzl7hO0DRaO5AOXFjSCJcx/V
 OAu9vZ774prWHJImyEKr6OUNyZ4O4W2dUTxs+r/7OPsQC9BFkzp82U3KlGgYDgb/34CK
 gR9CrEe6XKnVr1mZ66HoUZrC2s4/CIl/MTk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 37p026bnud-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 02 Apr 2021 12:45:09 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 2 Apr 2021 12:43:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=let6LzfNTmxiWR+brsZq66J8gxqaD12htsvYebBHY9+piHoZmjD08pmSAm1MnwdCR8kwJPXxs9n2Qr0R05wrNeCX4tDVmcNWVek1QakvsqseSl6L+p3GTwAqyFP1QMamn7F8ZM+zbcYcitdM10hOkBI8cXREulKywKyxYPI/3PIFz6tTAs4YCr3p3QIkCp0aFqYOtffTVXKn4DBPyd4IWtVpJYBT9++1B1b5dHyBDPOwHiGOc1ivjQuG9iV9Stjb9EvdwinjrltyuY7JWJ9USNLKjprqwEGSEGV+ovpWlz61dMK9I6Ix8uFiSaiK6Pc8ZEwpYdtypfWLPQasyfKQyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ftpB+eaa/jnldkbmn++pAPxvmzriTZMSwXIBS9keTc=;
 b=QBsLLS7eTr8UtfSZuwsD3NgQo9uMmh29SaKEmLpgzu+vTwGUU8zVgoRngwtC/6dDuEXr41Ct2prXh1obPr+OhVnMa2GkKmGuXnFbPBvwETpAp66asZLgvNKj2hhujwMjXLDUVoms/V2D3+MrNpP9v1BGlbjrn5x6Sp/+nLicK/UZJfzS0XuFLLdt24/tGWCN528Qw+hq/BVij4pCskuQgyHRFZSZDdoG/Usyz7zvfLASHWT+tejmo2e7pXY76WR0ssAIQy7jWkTu+XKDGWLuIjGWfDSQ1AEeEkVSvYCtZDV/0B5D+UIMi8SJENzbmbtK7K4g22EVM7m4X9YHolXjIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3046.namprd15.prod.outlook.com (2603:10b6:a03:fa::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Fri, 2 Apr
 2021 19:43:42 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.039; Fri, 2 Apr 2021
 19:43:42 +0000
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
Thread-Index: AQHXJq9GCj74A7YdlUumCh5fgR8tjaqfNeUAgAC1hACAAC9hgIABZM4AgAAGWACAABPLgIAACd2A
Date:   Fri, 2 Apr 2021 19:43:42 +0000
Message-ID: <390A7E97-6A9A-48E4-A0B0-D1B9F5EB3308@fb.com>
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <B42B247A-4D0B-4DE9-B4D3-0C452472532D@fb.com>
 <CAM_iQpW-cuiYsPsu4mYZxZ1Oixffu2pV1TFg1c+eg9XT3wWwPQ@mail.gmail.com>
 <E0D5B076-A726-4845-8F12-640BAA853525@fb.com>
 <CAM_iQpWdO7efdcA2ovDsOF9XLhWJGgd6Be5qq0=xLphVBRE_Gw@mail.gmail.com>
 <93BBD473-7E1C-4A6E-8BB7-12E63D4799E8@fb.com>
 <CAM_iQpXEuxwQvT9FNqDa7y5kNpknA4xMNo_973ncy3iYaF-NTA@mail.gmail.com>
In-Reply-To: <CAM_iQpXEuxwQvT9FNqDa7y5kNpknA4xMNo_973ncy3iYaF-NTA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:d190]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a47d2176-aa8e-4a03-4917-08d8f60f9ebd
x-ms-traffictypediagnostic: BYAPR15MB3046:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3046C8B376CFBD7CA4ABD87EB37A9@BYAPR15MB3046.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 33RnhXL8qrw1urO1dfe5UPwDw4IKkKhqF9E4moFAHkAu6zDamogwl7vVE7WnG2ZF7owc5WQ8fegY531ou7P4HodJw5hahyz42Lu05JZZPmkVI2oL9gBkX+pX/4HdZW6Zh/a7+aRuJFDfewMTiA8Jb3KGh6QM878IwodFyvtdA9O6uikNtAczN2pFMyH4UaemMChhk2/PZZZFdvG0RnM2EBM72hXD4yrTJ/biHiYV6hpZ/RmOM3VSRCPc/WZv/qG/HS4hq1Tzk6djWYzuyQmyfgxbYEYf0o+e0qMZFB4hzanxmQV/5kFDz0CID7HLFQJ66adwusTR23ugDUwSlsgOAtTXaRAl2QfW6wrIKTh16T2Qg+Q2eyxsIYP9+PsU3elolT76Tk30fo0rvQSbz5lztsmbHE5H3tnj/dxz89eo+HHlOtnf2XRVIGtHKE8GVxuuJgFTF0nQEsrMyOwtcOMsdPMD0bM4m8N7r6C8z+3d2KABwfx8zNKQ4DzIfYsHi0okyaFpkNAwPcozy2Yt3r53/zhlCiH8qq9r3cPdn8XfmaiSpy28NLcaWItlTZYCFNpoH6cRre/jxKRDbST31sX29Aq7xELOemi1YMby2YrDY9Li/PHtzoYnxda63TtEf2tUaCifhuNdk4Ijlk5bEKxk3oIi6d8PTad4yFmH8sUGe0FFZZEy7SeyADENaLCmjEbj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(346002)(396003)(39860400002)(76116006)(316002)(6916009)(7416002)(53546011)(5660300002)(186003)(6486002)(71200400001)(2616005)(66446008)(83380400001)(2906002)(6512007)(38100700001)(86362001)(66556008)(478600001)(91956017)(36756003)(66946007)(8676002)(33656002)(4326008)(54906003)(66476007)(64756008)(8936002)(6506007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?egdLu8PppqD2YFOKTYML+BBV6RwWWCsxikw2G7ArSACIYGkzTDLr3AOCSXqT?=
 =?us-ascii?Q?jrF6mlixXFALUyQdWUOhmqgpA7f4uJwxUMt32A2D8EnTCjFUn8x44E2p0sJy?=
 =?us-ascii?Q?S0Vq1QSwk756HyBwo0q9soWBB80m06z/i3wtfCYn9nMeHH+4cB9Yt7FuRf5z?=
 =?us-ascii?Q?uI6V1wujqwcgpseERsWWA2e7Q+PoAU/ArgtNsliVqjQkXy6/GpwG3gkyvSKj?=
 =?us-ascii?Q?6zEYleRAN8Ur6FWtLxT+H8bmVrfKq18cJg1SE4kT4xcTAjHQkR4fvvA/0VoS?=
 =?us-ascii?Q?TBp5znOoJqa8mjMo5Gb8mfEIduSeCILwuu2nMGHG8hoU5+l16hQq76NhCSsJ?=
 =?us-ascii?Q?tAluKAtThYFzXENp/WZ7rxDEbTXz25Lu3rgbEbJKIGRCiql60EeZkjOIsXWB?=
 =?us-ascii?Q?H3kE5Wv9N8fJIO7LBjn7gGdD2XDwJ764poU1fjc4NAoNmc9GarjLj2KNuDbS?=
 =?us-ascii?Q?wtwE9xYqIe8d/i+CY0zAR7sm2TXMMTVv9Dv9c4trm4hoZLVe/Y2HjRoa69E9?=
 =?us-ascii?Q?l4bmvLvoEp7vms/GmhJih2xcBUI816VegI3/zGSFPDbT51x7UMeiwV5pghsl?=
 =?us-ascii?Q?K281QgSaSFgaeArUZD04W+LToAfVNxAQqEsyJ1ZNloPKYw6EIywnkkelXorM?=
 =?us-ascii?Q?JmumCUBKvJ+chBDdpzmsJYnj+UOxMyI4udOGestDiTVWopgZW9JNxDJueXz9?=
 =?us-ascii?Q?E8Jr8WYrM6FgiY22Y/ElkmrjDZhzmzUZ6JOmqB3s9y/6Rt4N99ovm9gUWQVk?=
 =?us-ascii?Q?YBDU7yTyx1b49n6iDB4aKHe9jUVqQvB3F6oiBZvRzw78bIilImyDQFhxDb7l?=
 =?us-ascii?Q?DRmcR3/TNbX0rw0NKMlymo+VqzIdHGok7WuPgzVIjg2yDb8GVRnJsPvy8786?=
 =?us-ascii?Q?hQVdpSXd8hhl95XZF/C+Ruupx8AoJSnzuCqcDPsuXE/RMOuXkdhGx7ELzQOJ?=
 =?us-ascii?Q?Q+ywxtylymoE9j9GldpDM5gccNiqCpV+EFEkM/dSEMRHVZrDsNklgPh7tMbF?=
 =?us-ascii?Q?FNaM6plBrjZgZOF3RKQcuCFc6xZDUaS0vG6bjqFx1m4jlpNzDSRGH5IBstMC?=
 =?us-ascii?Q?chF6E2rYYymSVvxDyEkjev/LLrhUluJJbKOEhTTkYmbfsyKjCxSqdxFouzUF?=
 =?us-ascii?Q?Bo+p97ItPu45eE/BazYRICMM/BeIu3auRo0O0ehzvzpiw2VNLJSShelM2QM9?=
 =?us-ascii?Q?u11brpfwdcBL+8rbVWRAU8KJ6bq1rgQLa/jkeaWuGKfbZX//M6i4ImtOBICc?=
 =?us-ascii?Q?/pvB/Aspnkb1dza5jgh+pEJc0mfBw+aAIiYBIW7JRugG/r/ZpYtXwOKhFHRO?=
 =?us-ascii?Q?VJwYyBmhW87DHo+b1uwngMzoH34s7xflckdmIHBOSDJOmNyTDSdWAEFwN4Co?=
 =?us-ascii?Q?GxpLSgk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0593576E62107149987F450274C87C6E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a47d2176-aa8e-4a03-4917-08d8f60f9ebd
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2021 19:43:42.0463
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JZZlBWXB7KgKANgwmBduaQxowvX4nFFPgTEiJe6NHiwqoKfDICSdHYefrnBIubmyG7VPYW+Fu4D9a4ZjEO9aaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3046
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 5kkyxxNUSgrY860yG-GkGuHBTkz1fKVY
X-Proofpoint-ORIG-GUID: 5kkyxxNUSgrY860yG-GkGuHBTkz1fKVY
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-02_14:2021-04-01,2021-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104020133
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 2, 2021, at 12:08 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>=20
> On Fri, Apr 2, 2021 at 10:57 AM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Apr 2, 2021, at 10:34 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote=
:
>>>=20
>>> On Thu, Apr 1, 2021 at 1:17 PM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>>=20
>>>>=20
>>>>> On Apr 1, 2021, at 10:28 AM, Cong Wang <xiyou.wangcong@gmail.com> wro=
te:
>>>>>=20
>>>>> On Wed, Mar 31, 2021 at 11:38 PM Song Liu <songliubraving@fb.com> wro=
te:
>>>>>>=20
>>>>>>=20
>>>>>>=20
>>>>>>> On Mar 31, 2021, at 9:26 PM, Cong Wang <xiyou.wangcong@gmail.com> w=
rote:
>>>>>>>=20
>>>>>>> From: Cong Wang <cong.wang@bytedance.com>
>>>>>>>=20
>>>>>>> (This patch is still in early stage and obviously incomplete. I am =
sending
>>>>>>> it out to get some high-level feedbacks. Please kindly ignore any c=
oding
>>>>>>> details for now and focus on the design.)
>>>>>>=20
>>>>>> Could you please explain the use case of the timer? Is it the same a=
s
>>>>>> earlier proposal of BPF_MAP_TYPE_TIMEOUT_HASH?
>>>>>>=20
>>>>>> Assuming that is the case, I guess the use case is to assign an expi=
re
>>>>>> time for each element in a hash map; and periodically remove expired
>>>>>> element from the map.
>>>>>>=20
>>>>>> If this is still correct, my next question is: how does this compare
>>>>>> against a user space timer? Will the user space timer be too slow?
>>>>>=20
>>>>> Yes, as I explained in timeout hashmap patchset, doing it in user-spa=
ce
>>>>> would require a lot of syscalls (without batching) or copying (with b=
atching).
>>>>> I will add the explanation here, in case people miss why we need a ti=
mer.
>>>>=20
>>>> How about we use a user space timer to trigger a BPF program (e.g. use
>>>> BPF_PROG_TEST_RUN on a raw_tp program); then, in the BPF program, we c=
an
>>>> use bpf_for_each_map_elem and bpf_map_delete_elem to scan and update t=
he
>>>> map? With this approach, we only need one syscall per period.
>>>=20
>>> Interesting, I didn't know we can explicitly trigger a BPF program runn=
ing
>>> from user-space. Is it for testing purposes only?
>>=20
>> This is not only for testing. We will use this in perf (starting in 5.13=
).
>>=20
>> /* currently in Arnaldo's tree, tools/perf/util/bpf_counter.c: */
>>=20
>> /* trigger the leader program on a cpu */
>> static int bperf_trigger_reading(int prog_fd, int cpu)
>> {
>>        DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
>>                            .ctx_in =3D NULL,
>>                            .ctx_size_in =3D 0,
>>                            .flags =3D BPF_F_TEST_RUN_ON_CPU,
>>                            .cpu =3D cpu,
>>                            .retval =3D 0,
>>                );
>>=20
>>        return bpf_prog_test_run_opts(prog_fd, &opts);
>> }
>>=20
>> test_run also passes return value (retval) back to user space, so we and
>> adjust the timer interval based on retval.
>=20
> This is really odd, every name here contains a "test" but it is not for t=
esting
> purposes. You probably need to rename/alias it. ;)
>=20
> So, with this we have to get a user-space daemon running just to keep
> this "timer" alive. If I want to run it every 1ms, it means I have to iss=
ue
> a syscall BPF_PROG_TEST_RUN every 1ms. Even with a timer fd, we
> still need poll() and timerfd_settime(). This is a considerable overhead
> for just a single timer.

sys_bpf() takes about 0.5us. I would expect poll() and timerfd_settime() to=
=20
be slightly faster. So the overhead is less than 0.2% of a single core=20
(0.5us x 3 / 1ms). Do we need many counters for conntrack?

>=20
> With current design, user-space can just exit after installing the timer,
> either it can adjust itself or other eBPF code can adjust it, so the per
> timer overhead is the same as a kernel timer.

I guess we still need to hold a fd to the prog/map? Alternatively, we can=20
pin the prog/map, but then the user need to clean it up.=20

>=20
> The visibility to other BPF code is important for the conntrack case,
> because each time we get an expired item during a lookup, we may
> want to schedule the GC timer to run sooner. At least this would give
> users more freedom to decide when to reschedule the timer.

Do we plan to share the timer program among multiple processes (which can=20
start and terminate in arbitrary orders)? If that is the case, I can imagin=
e
a timer program is better than a user space timer.=20

Thanks,
Song=20

