Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F69F352ED1
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 19:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234984AbhDBR5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 13:57:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57318 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229553AbhDBR5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 13:57:52 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 132Hu8wB030275;
        Fri, 2 Apr 2021 10:57:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=vgHUggGATnrPI5GNO+XZkY+0qfhGEYFpLQ9lnVzUfGg=;
 b=fan4qY+9w6ho8OSLMNFNm+VhmXPsTtA/xtcsmrESdXz7q7k3k6qvTlHwWvV74LT6xugL
 TB6GaNaTDCju5yIw2B7qPtz23y792erad8XV9DfTYJXwsYha5YVZqnv70U6DoT1YotLD
 Ddrfm56+lu1tpLY9cp7IrgZHz6d+FHuYep8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 37p026b2c8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 02 Apr 2021 10:57:36 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 2 Apr 2021 10:57:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B5h6APSiNwt3rni/L1Eir2oMy5GFvDz+AQBr6E7K6CqhkmJxRhWVx8h/2PHmqyMLQuAq2jyR1XcOFcC0c7+dDm3QFZmsMLYohbArmpOzNGt/KnNbJIY6ktHFwN8g9c333H71G+SUkzNIQNV5s4HR+JKp3TI8ol6fcmhndc8Ad/Qqr9iLkt/dPByx2tOgBQzU6SLriFc7+Z3HFkfd76LbjYMcyPKTCiA6ksI0jH5V6rQfRVB2RYPgxcJp2fi679F5gFYr2y8jbfPhQctT9LDkOixEkuLn1oPR6wH4AWosEs7GgfZY1aW0t1mdJx0BpClihZ37LtFyiUHSR95qeZnsgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vgHUggGATnrPI5GNO+XZkY+0qfhGEYFpLQ9lnVzUfGg=;
 b=XYAqU6ef0cmsADhUq4p+NtTmHEoStwwI7gPnUf2RI2CLu8MvEGuip1U2fCPzqC+R6Q+zC5Jam0MHn5L5OE8A1U/ZF3LiPWNlo8fg++/iMhvVMfGGIR9d9YuhiUvqL6v6Wk68iVkU2HQc6ANK7ZNtSIZdSMjUFqZnvBzwfmMaa270K6qAuqc1IG7vWRyCpDLrG4R4L4HL/6AJNrHFsP8YkGw+fkXYRm9qZMXSjdguh0pf/Eamjf8gfNqvLrzhTK7YPGSqQuEqe9ZzvuxVw1oUleFkEwfl17jvQNirnpMYfOwaxZR2ybYnIZZd3heR6bQBEFp1BAteQiAXLoKd2rq2yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2693.namprd15.prod.outlook.com (2603:10b6:a03:155::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Fri, 2 Apr
 2021 17:57:33 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.039; Fri, 2 Apr 2021
 17:57:33 +0000
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
Thread-Index: AQHXJq9GCj74A7YdlUumCh5fgR8tjaqfNeUAgAC1hACAAC9hgIABZM4AgAAGWAA=
Date:   Fri, 2 Apr 2021 17:57:33 +0000
Message-ID: <93BBD473-7E1C-4A6E-8BB7-12E63D4799E8@fb.com>
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <B42B247A-4D0B-4DE9-B4D3-0C452472532D@fb.com>
 <CAM_iQpW-cuiYsPsu4mYZxZ1Oixffu2pV1TFg1c+eg9XT3wWwPQ@mail.gmail.com>
 <E0D5B076-A726-4845-8F12-640BAA853525@fb.com>
 <CAM_iQpWdO7efdcA2ovDsOF9XLhWJGgd6Be5qq0=xLphVBRE_Gw@mail.gmail.com>
In-Reply-To: <CAM_iQpWdO7efdcA2ovDsOF9XLhWJGgd6Be5qq0=xLphVBRE_Gw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:d190]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7e1b459-04bb-4b35-71c5-08d8f600cae7
x-ms-traffictypediagnostic: BYAPR15MB2693:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB269379C6A695629DEBE32948B37A9@BYAPR15MB2693.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3hOIqGpzZU90nCh/s4kFGkID/LENSC29O8C8wUGK27mJJgwjylYnh0Zmp9yONIlME/TiQ+9zDwSDCSY50t0pZFdexL9cSDYXI5DstIjvb1Rm8Bh0g2RMiJy4r1V8N3U2kgVBt8tyivzdTxOiSFut9l4K7pcp4S7jDyIIlZw6DtdZQ16ce1BpP1YDc14jyKzKkM4TTluain3DanxbZ6UWb4q0oshQI4PzNH5thhpMywhLu4rMw2w6ilYkklI6de1lRb2fDYcO9MkXER7UFbuxAjCEJ+pUdyWSjGVjup5Qe9JitTHsI8Xd7zDbrtBrLWFzccdo94IdaTmLSiubtuVI0VWX9a5J6fKIRTixfXCH5jKZbgiMyb3h7q82S6JJoDEgfxuVKT8hpv3t+sonhdJM6a4vqu4Ee4qlv1u0fMRiq2k0J6vp5zgV5v9YSJtlcrZL62NnpfgQJkZHYB1N2HiSOXEPLJucRBxkAAS+SGo5QKsW9UFRX2K0Au6oS1bL6c2v94pWCJFqwxvo+JFWqXg/BaLcOMhc2GKZ5nORB2+ZXWC+7wHWXyRsfR6eotTvJdUiBRmpiv0q1uIQCdYTHnGrYKxZ6P4n1QkvmJ940Q8Ub6O9nsKoTXDsa7UuaGITMHyoWeV4hwsIY2A/3dGraBY/qxC234fqeCRHLOs0IR13QCwf3sQfggv7RY8RaPTHpC5l
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(346002)(136003)(376002)(76116006)(66556008)(66946007)(36756003)(91956017)(66476007)(83380400001)(6506007)(2906002)(8936002)(38100700001)(8676002)(2616005)(6486002)(64756008)(66446008)(33656002)(6916009)(5660300002)(478600001)(4326008)(86362001)(6512007)(7416002)(54906003)(186003)(316002)(71200400001)(53546011)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?JLuUptXQM85hbwpUxZdhEiJ6yzwQthLWZeK1aq/LN9akUO6RIVdNvqZRz97x?=
 =?us-ascii?Q?kwBkq/Ajp77q/KQ1vRbqMnJLR+04MH8o1E5dqVAGT/6zLV1KenR9ShIlsx0G?=
 =?us-ascii?Q?KdIebVlInfHEg7hLsplY/F+TCFxLNxcftqQVIm+CuSRFM0TbyH98CtXqeLA8?=
 =?us-ascii?Q?LJOpZUKGzND/vGupzGba+6O6Gf2VfiK5EuXU5/5JShoweBIGbjaMc96XF+3u?=
 =?us-ascii?Q?iJL5HEOGCQkqd44+yVH0rC1T0MY5CqgKxGR+7g6NkG713QjzRz6ufzHLwY9d?=
 =?us-ascii?Q?ZciMDzwopHd4O1iSbv9gyeFPeu3tU+aWjPdVnlupoyndl7cNMWRi2+nkjk6x?=
 =?us-ascii?Q?bUNxCoDIKKSiF4kg7vF6FE5/x3FQJQovCBdgHp2PSbwYQUocIgEvU/KiFdIs?=
 =?us-ascii?Q?aGWbIvXRdFtLiefFBIgu0K6/H5vGE8TE3To/N4mCL+DUk3wn7ni/oVENrXZL?=
 =?us-ascii?Q?xtnP019pOauhE8L9ez4eGqCdGYpDiRwOtwBCZdvjFf5+e8VaxlNQFQvz+NsE?=
 =?us-ascii?Q?RK2JkFFiyTDRAhzGrQDmMZqtlrF28P4n4kPvV/km7qLUW/D/ezG+B4eLF3vg?=
 =?us-ascii?Q?ssYIMcaluHzcQ7Lx/QmpC9zHyYsxvuDyueIBiHQlCms0SoEuA98GGIBq7cDH?=
 =?us-ascii?Q?Zyc4MB/c3unvnojUc7D+UuVogdAGLVBaqBZrr/ClNzvRQL7povB0oJS4+7ri?=
 =?us-ascii?Q?1taHFqdSYqH1wcB5CWHcMmDCFy3Yvp3ln2h7Dl+iV7aA2VLoo/4c+hJIZaox?=
 =?us-ascii?Q?kTivNqQKgBy33l3L7/9YriFsuH1BI9FGTdA+I+nY/S2c6+rl79uQFLS8YpX/?=
 =?us-ascii?Q?/t50dEjpnFncVLZHXbrBVyUWdFvq6W9PxIrDVE1DRJELO3xspELdq1QIgpQZ?=
 =?us-ascii?Q?Q27uJGlymIdsQBify9ickFUOlrfpVoP7RLNMspbE/gb3+niqKyiopB6q4ccE?=
 =?us-ascii?Q?aX+xlXWQFGTSXBSWmAWIlzrqqMaBa6UNXO5xpMWVqFWZCYtVVeJkfnpKjh1f?=
 =?us-ascii?Q?2xDZ6/oawjtvk0mbqP66ju3dVtbvcvaHrQajujUpYPDnzU+gfA68fH/Pi6rq?=
 =?us-ascii?Q?ps4qGDlCvwrX034f5lRbSQ8xnzifeobDYlOd8H+7IZ8YhZvBvl7ZK9trjD2e?=
 =?us-ascii?Q?+7OuSscs8iK0H9u9BUQCSntnVfm6GmfwHQjEOttQFwPG2sfRJ3wpHlUeU+l8?=
 =?us-ascii?Q?L70EAk+WaXcLnXqTJvkM1GbyJi+H3mZ6AGZOfc5M5LkzGL/SCF02xYXiSRd9?=
 =?us-ascii?Q?IIl9WDJmhlglw4AQZnCxXLSosfFFifVrs4e0vrE1w7cpVFQUdUbNE9SSmV20?=
 =?us-ascii?Q?GlqakN0z035sLjZBd4eGLv6dCUM5kLDzjJeLX44OjlsTQkDKZIEYWEYHHLdd?=
 =?us-ascii?Q?PibNICU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E5421ACBAD7AE44D9FE531D536EFB1C4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7e1b459-04bb-4b35-71c5-08d8f600cae7
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2021 17:57:33.6444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yBQ6bX3xWGzo91jB93td4m6JPRHzClaoqQ4ljSGvl3MCkVx0/u8KPFdGhafkXHbTmwN9tRjs8ErKsqKur9RJ4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2693
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: BSch-8UTkxSWcAQj6jbOcCoj25TWEDxi
X-Proofpoint-ORIG-GUID: BSch-8UTkxSWcAQj6jbOcCoj25TWEDxi
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-02_12:2021-04-01,2021-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104020125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 2, 2021, at 10:34 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>=20
> On Thu, Apr 1, 2021 at 1:17 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Apr 1, 2021, at 10:28 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote=
:
>>>=20
>>> On Wed, Mar 31, 2021 at 11:38 PM Song Liu <songliubraving@fb.com> wrote=
:
>>>>=20
>>>>=20
>>>>=20
>>>>> On Mar 31, 2021, at 9:26 PM, Cong Wang <xiyou.wangcong@gmail.com> wro=
te:
>>>>>=20
>>>>> From: Cong Wang <cong.wang@bytedance.com>
>>>>>=20
>>>>> (This patch is still in early stage and obviously incomplete. I am se=
nding
>>>>> it out to get some high-level feedbacks. Please kindly ignore any cod=
ing
>>>>> details for now and focus on the design.)
>>>>=20
>>>> Could you please explain the use case of the timer? Is it the same as
>>>> earlier proposal of BPF_MAP_TYPE_TIMEOUT_HASH?
>>>>=20
>>>> Assuming that is the case, I guess the use case is to assign an expire
>>>> time for each element in a hash map; and periodically remove expired
>>>> element from the map.
>>>>=20
>>>> If this is still correct, my next question is: how does this compare
>>>> against a user space timer? Will the user space timer be too slow?
>>>=20
>>> Yes, as I explained in timeout hashmap patchset, doing it in user-space
>>> would require a lot of syscalls (without batching) or copying (with bat=
ching).
>>> I will add the explanation here, in case people miss why we need a time=
r.
>>=20
>> How about we use a user space timer to trigger a BPF program (e.g. use
>> BPF_PROG_TEST_RUN on a raw_tp program); then, in the BPF program, we can
>> use bpf_for_each_map_elem and bpf_map_delete_elem to scan and update the
>> map? With this approach, we only need one syscall per period.
>=20
> Interesting, I didn't know we can explicitly trigger a BPF program runnin=
g
> from user-space. Is it for testing purposes only?

This is not only for testing. We will use this in perf (starting in 5.13).

/* currently in Arnaldo's tree, tools/perf/util/bpf_counter.c: */

/* trigger the leader program on a cpu */
static int bperf_trigger_reading(int prog_fd, int cpu)
{
        DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
                            .ctx_in =3D NULL,
                            .ctx_size_in =3D 0,
                            .flags =3D BPF_F_TEST_RUN_ON_CPU,
                            .cpu =3D cpu,
                            .retval =3D 0,
                );

        return bpf_prog_test_run_opts(prog_fd, &opts);
}

test_run also passes return value (retval) back to user space, so we and=20
adjust the timer interval based on retval.

Also, test_run can trigger the program on a specific cpu. This might be=20
useful with percpu map (BPF_MAP_TYPE_PERCPU_HASH, etc.).=20

Thanks,
Song

