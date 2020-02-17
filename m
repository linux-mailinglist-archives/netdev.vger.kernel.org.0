Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79610160859
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 03:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgBQCwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 21:52:31 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50498 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726269AbgBQCwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 21:52:30 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 01H2olO5024586;
        Sun, 16 Feb 2020 18:52:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ktsVcn29adyZK8/JOjZtxGKqJq0uoTPwdp62603/WWA=;
 b=F1yQH7FGRaCry6dp/zva+mT+fyziV6WNVjdYfCI4HjO7qVzAcp+A3aX4fzVnjU2ICAx6
 jdXC5QoTRYJb/xlG93mT3YO+Af/NcJcyg1Q/oEMRJmRZXNMoYYoHE1V8sO8E8xiHF6mP
 jAL247n4D71brhy3iCujsG8VJATTpYdU4tA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 2y6d15d4tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 16 Feb 2020 18:52:16 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sun, 16 Feb 2020 18:52:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bsMp9MulsVAQGQoFKro/eA2QwiuyX27gKF2/ow1mOvCU84Pzwa1VDPHyhJOFpSZw/1rRYOfl7pZjda1Czq6dEPGGrrIsA7W96H4+1V055Clv5Mw3oKwgHDd6y4few+1MbMI3LI+Sit6D5Yb2CH/HHGU5kzc0E2R3lnuk15bn9LFcQjrs9qTb7cvUQUnRp8pEF0VbyfunDFO7Nn63eNwYTxYoPdQEwLC99hOZMw3wvw8l4q8BCa0w630y76+qy1b7VlAiFW5F9K9BvL3adNG2VChbRqwDwl7C7MgwgKzKv3X1BkdYyF80qBaV1CP6DcWQMz7zxZ2YZb7Bx7c0chxykg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ktsVcn29adyZK8/JOjZtxGKqJq0uoTPwdp62603/WWA=;
 b=iw2MCtlkj+Ual8hDFdPsr0/+WlikiZBVPKhKV/ZrX/KdUbRVCxfRvHzmjmM3tUsev2ykCsYa/BSF1pJ5tRvMyFHFDXHXAIkzaOuNBItN4CMEWZTTivYBAajC9R9trxTklUeg6IE2hKRX9IbSD9wBGw84O3qGzYkbUDA3s2yFZ/0Nc8v7U/wHNXjpB9MIaV6WIC83MsxUgE0P6DaglvPxuySJuClCkpuas2iqi6MSJQ+DM76bWUIUoDn0ynrxKJzUwm0nmau2JU+IENWBbBuZSkj2hwAHFoqd5ifgDJ8LWo4AIg4tM6aDRy1Wf5wcrzHLP+B317swws7KeLkhjVF2JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ktsVcn29adyZK8/JOjZtxGKqJq0uoTPwdp62603/WWA=;
 b=I3sNPUi8SZLpy96zjstV2mvnF+sXRWmHnIZcxA0PZZz7QNX/K0gHXmcQ1ElIyd82UWcAllS9GxjSjzCi7/6CTToDZ3sho5VXOVoaJesjGtPW5JpgQZzHWbi57Ea1DTC68dndmioHBA1JOjCzTboB3RNMqhko2d4MwUXYFAu+hWA=
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com (52.132.153.155) by
 MW2PR1501MB2156.namprd15.prod.outlook.com (52.132.150.152) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.23; Mon, 17 Feb 2020 02:51:59 +0000
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::492d:3e00:17dc:6b30]) by MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::492d:3e00:17dc:6b30%7]) with mapi id 15.20.2707.034; Mon, 17 Feb 2020
 02:51:59 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [RFC bpf-next 3/4] bpftool: introduce "prog profile" command
Thread-Topic: [RFC bpf-next 3/4] bpftool: introduce "prog profile" command
Thread-Index: AQHV4rD13dwh4/0hXUSMa6ZitJFaYKgbbO4AgANH4gA=
Date:   Mon, 17 Feb 2020 02:51:59 +0000
Message-ID: <2AC53E92-FC90-4133-9BCF-5BE627A5B3A2@fb.com>
References: <20200213210115.1455809-1-songliubraving@fb.com>
 <20200213210115.1455809-4-songliubraving@fb.com>
 <20200215004500.gs3ylstfo3aksfbp@ast-mbp>
In-Reply-To: <20200215004500.gs3ylstfo3aksfbp@ast-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:3efc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 495799ca-1997-4c2d-b29b-08d7b3545bca
x-ms-traffictypediagnostic: MW2PR1501MB2156:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR1501MB21561366F99411E77E817673B3160@MW2PR1501MB2156.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0316567485
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(396003)(376002)(346002)(199004)(189003)(6916009)(81156014)(8936002)(81166006)(86362001)(8676002)(478600001)(71200400001)(4326008)(33656002)(6486002)(36756003)(6512007)(2906002)(76116006)(5660300002)(66946007)(53546011)(2616005)(6506007)(186003)(54906003)(66476007)(64756008)(66556008)(66446008)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2156;H:MW2PR1501MB2171.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7CaYpwuN7abb5GmH8l0JCxz0KfidgtFkW9pYBxdv7lZOJVv/sryQ0PeaBFurdFyti8dHr/B27+ubhbkSz4u3uchDxuOlsolcSOHlZ6UDMKcUJWcg+umgwU9JBXfelAzXfruPzp3Iq71yghWFeDNWWLe/SmrWZ+p9Y8R1uNKqb6CZYs8xmTrPbt4mch3PWwkCZk9sCXljBCRmNpcQ8ZtIxV8jhOEztPjXzqagoeFUoekQLwBJPbkAw6B9KoF9Pqw8Eq2TA2++BQpO7kjS3OW7qyJ05hsoxWjuOnXVjg6MV02qU5HN6+FYUM5UnGqeQszZ7rcsYGcmMXPgDu8J3VYKfs7oB3DxVatAA3+MprFKzD5wxEPUQZnB7S2h3tkvISJFf44uqjDbp+qzSbngVuK88ibZNj/H5IY17L9FHW+AJ8mkwWK61NVdAev/D9ZKaoVp
x-ms-exchange-antispam-messagedata: 89ZsAYPcEF2r7wmG3XMjsH/Y6YCYtDMEU4C+MVgHmPZCuAr8R+MoRgWUMgJ8KM3/QoU97pzdDDY7t2hIeXYnCjbMGeeeq5pNK81L3vtmyBw7dLSjD9NVBLnLGblaiUDafZTlHAjtq2RavovQesdjus53Yl+k7sTJvUJZoeD7b8EhfqqF3Eis/MWCKrRBQxd9
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E599C6F523369848BDE7FDB82FE1EA26@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 495799ca-1997-4c2d-b29b-08d7b3545bca
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2020 02:51:59.3100
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DVIdC3Nwwb9ThHrxj1tqqtGWplZa9Ncan+FC7NhxoalX5mw5d2PWJs0ib7L6Qaig9c+pZETTkYU0vnIV7FcbAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2156
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_01:2020-02-14,2020-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0 bulkscore=0
 clxscore=1015 malwarescore=0 spamscore=0 priorityscore=1501 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002170022
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 14, 2020, at 4:45 PM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
> On Thu, Feb 13, 2020 at 01:01:14PM -0800, Song Liu wrote:
>> With fentry/fexit programs, it is possible to profile BPF program with
>> hardware counters. Introduce bpftool "prog profile", which measures key
>> metrics of a BPF program.
>>=20
>> bpftool prog profile command creates per-cpu perf events. Then it attach=
es
>> fentry/fexit programs to the target BPF program. The fentry program save=
s
>> perf event value to a map. The fexit program reads the perf event again,
>> and calculates the difference, which is the instructions/cycles used by
>> the target program.
>>=20
>> Example input and output:
>>=20
>>  ./bpftool prog profile 20 id 810 cycles instructions
>>  cycles: duration 20 run_cnt 1368 miss_cnt 665
>>          counter 503377 enabled 668202 running 351857
>>  instructions: duration 20 run_cnt 1368 miss_cnt 707
>>          counter 398625 enabled 502330 running 272014
>>=20
>> This command measures cycles and instructions for BPF program with id
>> 810 for 20 seconds. The program has triggered 1368 times. cycles was not
>> measured in 665 out of these runs, because of perf event multiplexing
>> (some perf commands are running in the background). In these runs, the B=
PF
>> program consumed 503377 cycles. The perf_event enabled and running time
>> are 668202 and 351857 respectively.
>=20
> if (diff.enabled > diff.running) increment miss_cnt.
> Why show this to users?
> I think 'miss_cnt' the users will interpret as data is bogus,
> but it only means that the counter was multiplexed.
> The data is still accurate, no?

We (or the user) need to be careful to get all the math correct:

For # of run per second, we need total count;
For cycles per run, we need non-miss-count (total_count - miss_cnt).=20

So miss_cnt is useful for some users.=20

One thing tricky here is that different events in the same session may=20
have different miss_cnt. I just realized that we can probably avoid most=20
of such cases, and only take samples when all the counters are counting.=20

> This condition will probably be hit fairly often, no?

This really depends on the system. Data center servers usually have a=20
few perf_event running 24/7. We are more likely to hit multiplexing on
these systems.=20

>=20
>> tools/bpf/bpftool/profiler.skel.h         | 820 ++++++++++++++++++++++
>=20
> I think bpftool needs to be build twice to avoid this.
>=20
> Could you change the output format to be 'perf stat' like:
>         55,766.51 msec task-clock                #    0.996 CPUs utilized
>             4,891      context-switches          #    0.088 K/sec
>                31      cpu-migrations            #    0.001 K/sec
>         1,806,065      page-faults               #    0.032 M/sec
>   166,819,295,451      cycles                    #    2.991 GHz          =
            (50.12%)
>   251,115,795,764      instructions              #    1.51  insn per cycl=
e           (50.10%)

Will try this in next version.=20

>=20
> Also printing 'duration' is unnecessary. The user specified it at the com=
mand
> line and it doesn't need to be reported back to the user.
> Can you also make it optional? Until users Ctrl-C's bpftool ?

Yes, I plan to add the Ctrl-C approach. Even with a duration, user can stil=
l=20
hit Ctrl-C and get partial results. I guess, we should show the duration fo=
r=20
when user Ctrl-C?

> So it may look like:
> $ ./bpftool prog profile id 810 cycles instructions
>             1,368      run_cnt
>           503,377      cycles
>           398,625      instructions         # 0.79 insn per cycle
>=20
> Computing additional things like 'insn per cycle' do help humans to
> pay attention the issue. Like <1 ipc is not great and the next step
> would be to profile this program for cache misses.

Yes, instruction per cycle is useful. Let me add that.=20

