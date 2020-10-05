Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8707283C97
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 18:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbgJEQdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 12:33:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46318 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726747AbgJEQdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 12:33:22 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 095GUggj031099;
        Mon, 5 Oct 2020 09:33:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=pteZhadzMjoc7cJVEoWVpicWdasEumXZ3AxRVZpJ0eI=;
 b=FOmw0GE+I8w9qvA+9lw9sbwqzOkCZMCR53hR8Su66SvLK7YO5M2UlsakQ2R26uDRzPKs
 J9URQdOKkj+xl2WzK213q15xVxYNHWh6g64ifkyDFcbq0OHfhSguZpGuata2LU6YsaJC
 Nad0OUMUqhvIaaNVpmU8AVrKkFGS71acZBk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 33xmt00bh6-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 05 Oct 2020 09:33:08 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 5 Oct 2020 09:33:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N3vJvVgyzDPbflxQaHjgSpcOP176+/eTWKhZoohhB1FsncdX0MNZj0BIlLlImiUBxuILPjSxwhbNmdZxB1aq6d+BFZ3s2oMWENG+DEt7pPO/fUAK7yv3zssJIEoY3Ot/+f0wC1P/ryFnKb/CqNdX6+0JmKXvJKfmcyjWQETKsnpvwnywI6vCPScWAXzeGBEE7oVDOHZkDUqT00S7jeBz5SMinJN+w3N26wVTNeUkyQrBeZi8JUl/vGQPj5hKK9Elt1kLtUMHkXC1WLQPkKBzsXO6EKj10zSkpr8LxrMCzMwYmAPUvSaamuxcM5BU9PQtbgmtBr/xj+FP7D2ioaCDPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pteZhadzMjoc7cJVEoWVpicWdasEumXZ3AxRVZpJ0eI=;
 b=hB1InkLElTTUfmomLHi6PIvl1CaWul1OqFTxi1ugKWn0keyFKtg6X30XGeMnObpSJ21B0nrwdrVs3ZDV0/jK64mgtDRroOWQ+q33wBtd2ykihIv+jyGxzH5Of83klTaoqSWWaYQ4z/wYsJ5fECUguyqxbb/vK+d3kVj4WluNllR9oAGVgp5xfzmZ/Zm1Jvt923KmAm9wGPKzZLfhGKXNQWlERc3dzKr3rBVgeF9WU2trVUhjbp/FJedNp0EMv3tcLaOl6tsujzMOQx/38NODRSWY94eAmYnq42kV617DSuZddLPk5FLgMuTnAvXp93dcgrmtEy5VDZ+BkCXkToRU+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pteZhadzMjoc7cJVEoWVpicWdasEumXZ3AxRVZpJ0eI=;
 b=RUDQ3tHlqGjQdMd5jeIJ4w9weDNmcBjqZbMgennQGa/277NFGyPEYUSKDfWuXYl2X2tZheTtzo2s7cu4xJ+S5NSnbUT7gHTmXK2VbYecZb0v3onFUEfWNLAgQJywZd5IqGz5pqOLSvyDln9jrNONCYjl5ab0TY5/OieLMX0355U=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB4120.namprd15.prod.outlook.com (2603:10b6:a02:c4::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38; Mon, 5 Oct
 2020 16:33:05 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::5448:b1c1:eb05:b08a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::5448:b1c1:eb05:b08a%7]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 16:33:05 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next] bpf: use raw_spin_trylock() for
 pcpu_freelist_push/pop in NMI
Thread-Topic: [PATCH bpf-next] bpf: use raw_spin_trylock() for
 pcpu_freelist_push/pop in NMI
Thread-Index: AQHWk5kqaReFwgHtnUywV9bl4aYfX6mE+uWAgAAQG4CABBGGgIAAJq0A
Date:   Mon, 5 Oct 2020 16:33:05 +0000
Message-ID: <FB6D914F-2D2D-4259-ADC1-8B1431FBAD6D@fb.com>
References: <20200926000756.893078-1-songliubraving@fb.com>
 <b2be5bfd-4df6-0047-a32a-cd2f93d44555@iogearbox.net>
 <12AC728B-D33F-41FD-AB72-857744639119@fb.com>
 <c5914df4-de3c-8c45-0ed6-10841e41a8e3@iogearbox.net>
In-Reply-To: <c5914df4-de3c-8c45-0ed6-10841e41a8e3@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 70b7a663-8833-4fbb-cbea-08d8694c5622
x-ms-traffictypediagnostic: BYAPR15MB4120:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB412025845B9D734D3C65F2D6B30C0@BYAPR15MB4120.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tp7ZxMpFWVHyqu2KRM7/n+uOBUg9FAdcJRN0DvI/CwgutbYSRbPwZ6Xhjq+8rqitDl0cYy8Po5a4AMAUITzq/s4jHJFM2XEbws+iWvHbFkoY1pU5c06AZnjtpcpNqvJSqfRGJIRkg/YykL7mMlh1q8g1DqIYrE8UCWwv1qMkQ3014HHV6bAHj8kVOurHq7gxFgqx69yH8nVyhrkpc0NwwBxENuKnVy7nqLihmfhgl+3HwtzT812JanabSM1cyRUz4XN1dn04DtPEilsSLKs2wdNwK9ALDeZ24FsFvM0Um/HuUx/zsNxOlkAtRoRK6XXSybTo8NiwQO0omYrc5N7Cwg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(136003)(396003)(346002)(376002)(36756003)(54906003)(91956017)(6916009)(71200400001)(86362001)(6512007)(186003)(8676002)(53546011)(6506007)(33656002)(66556008)(316002)(2906002)(83380400001)(8936002)(4326008)(478600001)(5660300002)(2616005)(6486002)(66446008)(64756008)(66946007)(66476007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ILPRiWtlCMCRCpLFeh317kMFEXnng+D3WoYxhEZ+DpvEXed1Vhp2JmGzlx+aR0e35dHdP3PKqriHIaGGwcXZGTlfKG2YD+eKXS10NeuQhU3PfzeJw4AGeh3fZSYQU3/p6ORIVbyVPesY9lH7IBAWp43ldDUV0KIDO6puzRzUazvvF4fKC9loukfa4WB6HKV/bDYqhrUY94WNlcaiatle++ATIUM7AomgG2Sq5ebLRtIyF9WZDEmdlYClptAcrImy68sFTE3uFyKgC93XcsOjlQjZYnBbGhP2fw9iRl7F/KCJ4WIR4uwh9uuc1z+hiRHL2xLnEh+WAvAp8VA4n0QcLPYfb/9LNJ3dzR0RRQPGpwGhclqjCAT6geAaxwNlHlGNdb9/kEKxn0gaMqoEdXaZ4FHj6zrmvMh1bdTVXLnvcx2THU0DcE4MNmXyo/qXA00YAGjHISJP7plNSbAYx1ePnIQqda5YndkB8NWEZBLb6dE+mlIKL5/pMqgEUenKZlmeSOLOcwLFAyG0g5VsJWFxuL4pFvckQk4UZi4QiGHegMTD2rOHxemq2Sk2Sksuh9p2/5MYP1UZ/v8NGVpZkETGkVIrARp2KqKTPH04Rch69nc9+tMJfGfpDyeT+bLF1R2aOZEmEnpfukWt2yefKT0+iBBvrV+Uly3qCW0wKJsyxnqeJHjfQbpkspLPt6jiWpIr
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8C4586C28F0EFA4EA240FE07F0AD9532@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70b7a663-8833-4fbb-cbea-08d8694c5622
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2020 16:33:05.5767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b120d93rdvkAPMxthPN4LqDSlJgLJlYARm8JAmh10O8RF7Io4FkdZOUP2PMOOeSkGQUXMu3t+ybjay+BB01cuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4120
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-05_12:2020-10-05,2020-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 impostorscore=0 mlxscore=0 spamscore=0 adultscore=0
 clxscore=1015 phishscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2010050121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 5, 2020, at 7:14 AM, Daniel Borkmann <daniel@iogearbox.net> wrote:
>=20
> On 10/3/20 2:06 AM, Song Liu wrote:
>>> On Oct 2, 2020, at 4:09 PM, Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>>> On 9/26/20 2:07 AM, Song Liu wrote:
>>>> Recent improvements in LOCKDEP highlighted a potential A-A deadlock wi=
th
>>>> pcpu_freelist in NMI:
>>>> ./tools/testing/selftests/bpf/test_progs -t stacktrace_build_id_nmi
>>>> [   18.984807] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>> [   18.984807] WARNING: inconsistent lock state
>>>> [   18.984808] 5.9.0-rc6-01771-g1466de1330e1 #2967 Not tainted
>>>> [   18.984809] --------------------------------
>>>> [   18.984809] inconsistent {INITIAL USE} -> {IN-NMI} usage.
>>>> [   18.984810] test_progs/1990 [HC2[2]:SC0[0]:HE0:SE1] takes:
>>>> [   18.984810] ffffe8ffffc219c0 (&head->lock){....}-{2:2}, at:
>>>> __pcpu_freelist_pop+0xe3/0x180
>>>> [   18.984813] {INITIAL USE} state was registered at:
>>>> [   18.984814]   lock_acquire+0x175/0x7c0
>>>> [   18.984814]   _raw_spin_lock+0x2c/0x40
>>>> [   18.984815]   __pcpu_freelist_pop+0xe3/0x180
>>>> [   18.984815]   pcpu_freelist_pop+0x31/0x40
>>>> [   18.984816]   htab_map_alloc+0xbbf/0xf40
>>>> [   18.984816]   __do_sys_bpf+0x5aa/0x3ed0
>>>> [   18.984817]   do_syscall_64+0x2d/0x40
>>>> [   18.984818]   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>> [   18.984818] irq event stamp: 12
>>>> [ ... ]
>>>> [   18.984822] other info that might help us debug this:
>>>> [   18.984823]  Possible unsafe locking scenario:
>>>> [   18.984823]
>>>> [   18.984824]        CPU0
>>>> [   18.984824]        ----
>>>> [   18.984824]   lock(&head->lock);
>>>> [   18.984826]   <Interrupt>
>>>> [   18.984826]     lock(&head->lock);
>>>> [   18.984827]
>>>> [   18.984828]  *** DEADLOCK ***
>>>> [   18.984828]
>>>> [   18.984829] 2 locks held by test_progs/1990:
>>>> [ ... ]
>>>> [   18.984838]  <NMI>
>>>> [   18.984838]  dump_stack+0x9a/0xd0
>>>> [   18.984839]  lock_acquire+0x5c9/0x7c0
>>>> [   18.984839]  ? lock_release+0x6f0/0x6f0
>>>> [   18.984840]  ? __pcpu_freelist_pop+0xe3/0x180
>>>> [   18.984840]  _raw_spin_lock+0x2c/0x40
>>>> [   18.984841]  ? __pcpu_freelist_pop+0xe3/0x180
>>>> [   18.984841]  __pcpu_freelist_pop+0xe3/0x180
>>>> [   18.984842]  pcpu_freelist_pop+0x17/0x40
>>>> [   18.984842]  ? lock_release+0x6f0/0x6f0
>>>> [   18.984843]  __bpf_get_stackid+0x534/0xaf0
>>>> [   18.984843]  bpf_prog_1fd9e30e1438d3c5_oncpu+0x73/0x350
>>>> [   18.984844]  bpf_overflow_handler+0x12f/0x3f0
>>>> This is because pcpu_freelist_head.lock is accessed in both NMI and
>>>> non-NMI context. Fix this issue by using raw_spin_trylock() in NMI.
>>>> For systems with only one cpu, there is a trickier scenario with
>>>> pcpu_freelist_push(): if the only pcpu_freelist_head.lock is already
>>>> locked before NMI, raw_spin_trylock() will never succeed. Unlike,
>>>> _pop(), where we can failover and return NULL, failing _push() will le=
ak
>>>> memory. Fix this issue with an extra list, pcpu_freelist.extralist. Th=
e
>>>> extralist is primarily used to take _push() when raw_spin_trylock()
>>>> failed on all the per cpu lists. It should be empty most of the time.
>>>> The following table summarizes the behavior of pcpu_freelist in NMI
>>>> and non-NMI:
>>>> non-NMI pop(): 	use _lock(); check per cpu lists first;
>>>>                 if all per cpu lists are empty, check extralist;
>>>>                 if extralist is empty, return NULL.
>>>> non-NMI push(): use _lock(); only push to per cpu lists.
>>>> NMI pop():    use _trylock(); check per cpu lists first;
>>>>               if all per cpu lists are locked or empty, check extralis=
t;
>>>>               if extralist is locked or empty, return NULL.
>>>> NMI push():   use _trylock(); check per cpu lists first;
>>>>               if all per cpu lists are locked; try push to extralist;
>>>>               if extralist is also locked, keep trying on per cpu list=
s.
>>>=20
>>> Code looks reasonable to me, is there any practical benefit to keep the
>>> extra list around for >1 CPU case (and not just compile it out)? For
>>> example, we could choose a different back end *_freelist_push/pop()
>>> implementation depending on CONFIG_SMP like ...
>>>=20
>>> ifeq ($(CONFIG_SMP),y)
>>> obj-$(CONFIG_BPF_SYSCALL) +=3D percpu_freelist.o
>>> else
>>> obj-$(CONFIG_BPF_SYSCALL) +=3D onecpu_freelist.o
>>> endif
>>>=20
>>> ... and keep the CONFIG_SMP simplified in that we'd only do the trylock
>>> iteration over CPUs under NMI with pop aborting with NULL in worst case
>>> and push keep looping, whereas for the single CPU case, all the logic
>>> resides in onecpu_freelist.c and it has a simpler two list implementati=
on?
>> Technically, it is possible to have similar deadlock in SMP. For N cpus,
>> there could be N NMI at the same time, and they may block N non-NMI raw
>> spinlock, and then all these NMI push() would spin forever. Of course,
>> this is almost impossible to trigger with a decent N.
>> On the other hand, I feel current code doesn't add too much complexity
>> to SMP case. Maintaining two copies may require more work down the road.
>> If we found current version too complex for SMP, we can do the split in
>> the future.
>> Does this make sense?
>=20
> Hm, makes sense that technically this could happen also on SMP though unl=
ikely;
> in that case however we'd also need to correct the commit description a b=
it since
> it only mentions this on single CPU case (where it will realistically hap=
pen, but
> we should state your above explanation there too so we'll later have full=
 context
> in git history on why it was done this way also for SMP).

Thanks for the feedback. I will revise the commit log and send v2.=20

Song

