Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E564F281F86
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 02:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbgJCAHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 20:07:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5554 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725283AbgJCAHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 20:07:21 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09304PAC020116;
        Fri, 2 Oct 2020 17:07:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=UIltp7Mu4ZoxDZK7C5sg7e5q4LAtqmMz9Awr1ZQ7M08=;
 b=TJa8Z53/C2FzVIL+Zd4OlScCKOSwF5HpL6g8v0oZdG/lPYf5GhI8ddB239vLUt4sns8v
 NCRVaP4Y3jyeiC3s4+9SkBPqTiRyAsOSm7LnlBwdJ9ocvB9dNNzMkW61LHw7SSkTW2fM
 IGhLiaiPsWKGnhvwiYUjmZL4FZwenkvoIcg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33x6guaqf1-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 02 Oct 2020 17:07:05 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 2 Oct 2020 17:06:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LUqDFTvyIY48IFg6+YkS7glK7+Oo4qed/K4lsG8ebPdWIsbTeJRoCCKyyuOjDhNoLuvy9BU0FW/RKmB/3rtil9HxB24b6c7sJMfr5jJqvzyhOUpENk2C2lILInc+l0k2EJIbo+/oBkYvlpYSbCp4/0vPyXOVYy89thiRovMQW2r0HlopZk0m7SPsX5UlZigPP2PZM8klvALrNm4SVAMB3h0FpHfxhEOBF7C5CRZjcJqVhig+ThW7ZI3UEN2UQEOKa+N1tb+JlNq0P8u7c6ts3e52CDyZZyN+D3NYa8k29Y+yeuhtzk5oSEagCVlXE2TqfbCZmmWF/qgous3aPu+IHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UIltp7Mu4ZoxDZK7C5sg7e5q4LAtqmMz9Awr1ZQ7M08=;
 b=I3FO4NixgBMX9oMhqRES9R+zY1PTZQLh3cvaFdq4U3FsmpDrBRO0jkCnGoDn1bGPXFq8x/wrixnpoVTdFjtlZUg3PvYACwt/wlnP0+wftL3PLG3q9Jxq2U0S3GPwZ55mB7vS5lg0So73sgX7aIDdIg1DJLB/uPWQnfoQUFPvtAWdWtAqZygBmRBf0ihcQHCP/mdxen5puu+5SfiHfIFLqS1PUAgGlgDVM3iYn6EEsLWLw3dvg8nyt4J6Yas0a6LDIMstps4fmP9TdUfqaV4Owm8cBb+VktSNVOnxTNwa2QpKwCv7NxcsYj7OqdSuVkfANVQFaE0hFx0H9Kx22tQEbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UIltp7Mu4ZoxDZK7C5sg7e5q4LAtqmMz9Awr1ZQ7M08=;
 b=DhajyB8wFNr82JWjN/icQ8qWOZMr5t2r3YXCJLJ+SKb9JneeXTSfN90YJbNoUQxQrftERqflxq/V4LnGWAjqPoq7xffbhkv832iVgdPNVoezXtDGECsEbFhmNu2YKyWWbWqu13hOH5ECMP4O1Hsuza30bQGt6IxBIxGE9NrLess=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3620.namprd15.prod.outlook.com (2603:10b6:a03:1f8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Sat, 3 Oct
 2020 00:06:55 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.029; Sat, 3 Oct 2020
 00:06:55 +0000
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
Thread-Index: AQHWk5kqaReFwgHtnUywV9bl4aYfX6mE+uWAgAAQG4A=
Date:   Sat, 3 Oct 2020 00:06:55 +0000
Message-ID: <12AC728B-D33F-41FD-AB72-857744639119@fb.com>
References: <20200926000756.893078-1-songliubraving@fb.com>
 <b2be5bfd-4df6-0047-a32a-cd2f93d44555@iogearbox.net>
In-Reply-To: <b2be5bfd-4df6-0047-a32a-cd2f93d44555@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: acbb0016-a7d6-4554-8f45-08d867303d00
x-ms-traffictypediagnostic: BY5PR15MB3620:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB36207EBA2712A3BB396E24C5B30E0@BY5PR15MB3620.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +EMWr3oI7pLe9r/mqRfz+rmx4C34QSrQiS5eg1A5IGzDWdvbXIzpCILXXRKSAPgu6r2O6pAoMiHZ5P5KRwyXSjKxeG5SKTg9yIPKu2nx2BG+maIZup0MKjUIygaXodiqSgvZk6wd5Y53Umaytz6WDuOuyf4XxYQn/VEhVSIECP2Vi0bLgP7FJtkGf7/ugnmXPWqpFOX+P7QlRLWtcxDsThwnDlEZxiLwWVPcCnTqedXhQXQXkdtrjQ35pjjGqKccVhFCwK2dd5ppMhzk01u4c6LpRbVHamG0qlK2GcvgcXCbDI0xZ1M+UH++BJ1niImn/Krg585sxCyc48bqObKy7A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(396003)(346002)(376002)(8676002)(36756003)(6486002)(86362001)(8936002)(4326008)(53546011)(6506007)(33656002)(6916009)(2906002)(6512007)(316002)(5660300002)(2616005)(83380400001)(54906003)(71200400001)(186003)(66556008)(64756008)(66446008)(66476007)(66946007)(478600001)(91956017)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: bMEnHgz/3CFpBeSF3Q/mOm1Owm/qqkXDpmkpFbbAi0YhjEnDHXM+S30vGs2uQbFFGiYmVJfEWXdleh/M9n97TeNmy9h1f1lWmoNG0wqXzR0InUrnkylxZJCkyiM6HwuGzyNrFZYbidecpupGN/tIGuexNFdRZTY6/wvgFD3RcQU6td0wPCEp/xpVSNEVMEkZQCeca6ZLXvkpo6IaHWk15PWiZmqaJf2wrGoq9+Rg2L7f74QpDfCvS/xpDMtnV7d9QSmyC4DtfU9IWxT2Udghr5vt5fNmr0z4a+JcMtScZnE8BVDhWT+NIbUx/bnMtWTHSYFrOgB5RbE2+qCj1YIxC5Z/sMXt66xW6V0B8mohFMCcMP516Pcpsfa9OeBjRwTXPNo4nKhvn6/lAebEFidEx3MNYZ400iQXYu8InNsNdlldsvWA+CnabKizxAuLcumBEtQ/imnvygN3Dl6PM1jupDeN9sXuo1JoK6TBXKqzWafXv5Ik55P+59JOpd/u0ZrivdsslbzDRq52Zn59Sa+AHNpDnMavZRAat9Ig0fHHNSKztCkr0WFDyGJ0QZDIsqOgEirYt1dHGeasTtW7xIPTgP53gpZXig9nHDB7glFlChl/14FiZ5fAKWevyF/zzfezK0pe7nwQcCrZ3xdxMSAxZHkEmtP3oH1Bx32wpkwq9ExcvDxfSr14NZs3K1pDOAk9
Content-Type: text/plain; charset="us-ascii"
Content-ID: <698F0765261E934F8A87E907DAA0963F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acbb0016-a7d6-4554-8f45-08d867303d00
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2020 00:06:55.2013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vVFJSW9/N73t/MvgKKxRZcJd5EfVC/b2JJ3mcnQLlnVpxJwMmitSgSBlI40DIjrMVxlfr5cDD2170Gsi040HPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3620
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_14:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 clxscore=1015 bulkscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2010020186
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 2, 2020, at 4:09 PM, Daniel Borkmann <daniel@iogearbox.net> wrote:
>=20
> On 9/26/20 2:07 AM, Song Liu wrote:
>> Recent improvements in LOCKDEP highlighted a potential A-A deadlock with
>> pcpu_freelist in NMI:
>> ./tools/testing/selftests/bpf/test_progs -t stacktrace_build_id_nmi
>> [   18.984807] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> [   18.984807] WARNING: inconsistent lock state
>> [   18.984808] 5.9.0-rc6-01771-g1466de1330e1 #2967 Not tainted
>> [   18.984809] --------------------------------
>> [   18.984809] inconsistent {INITIAL USE} -> {IN-NMI} usage.
>> [   18.984810] test_progs/1990 [HC2[2]:SC0[0]:HE0:SE1] takes:
>> [   18.984810] ffffe8ffffc219c0 (&head->lock){....}-{2:2}, at:
>> __pcpu_freelist_pop+0xe3/0x180
>> [   18.984813] {INITIAL USE} state was registered at:
>> [   18.984814]   lock_acquire+0x175/0x7c0
>> [   18.984814]   _raw_spin_lock+0x2c/0x40
>> [   18.984815]   __pcpu_freelist_pop+0xe3/0x180
>> [   18.984815]   pcpu_freelist_pop+0x31/0x40
>> [   18.984816]   htab_map_alloc+0xbbf/0xf40
>> [   18.984816]   __do_sys_bpf+0x5aa/0x3ed0
>> [   18.984817]   do_syscall_64+0x2d/0x40
>> [   18.984818]   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> [   18.984818] irq event stamp: 12
>> [ ... ]
>> [   18.984822] other info that might help us debug this:
>> [   18.984823]  Possible unsafe locking scenario:
>> [   18.984823]
>> [   18.984824]        CPU0
>> [   18.984824]        ----
>> [   18.984824]   lock(&head->lock);
>> [   18.984826]   <Interrupt>
>> [   18.984826]     lock(&head->lock);
>> [   18.984827]
>> [   18.984828]  *** DEADLOCK ***
>> [   18.984828]
>> [   18.984829] 2 locks held by test_progs/1990:
>> [ ... ]
>> [   18.984838]  <NMI>
>> [   18.984838]  dump_stack+0x9a/0xd0
>> [   18.984839]  lock_acquire+0x5c9/0x7c0
>> [   18.984839]  ? lock_release+0x6f0/0x6f0
>> [   18.984840]  ? __pcpu_freelist_pop+0xe3/0x180
>> [   18.984840]  _raw_spin_lock+0x2c/0x40
>> [   18.984841]  ? __pcpu_freelist_pop+0xe3/0x180
>> [   18.984841]  __pcpu_freelist_pop+0xe3/0x180
>> [   18.984842]  pcpu_freelist_pop+0x17/0x40
>> [   18.984842]  ? lock_release+0x6f0/0x6f0
>> [   18.984843]  __bpf_get_stackid+0x534/0xaf0
>> [   18.984843]  bpf_prog_1fd9e30e1438d3c5_oncpu+0x73/0x350
>> [   18.984844]  bpf_overflow_handler+0x12f/0x3f0
>> This is because pcpu_freelist_head.lock is accessed in both NMI and
>> non-NMI context. Fix this issue by using raw_spin_trylock() in NMI.
>> For systems with only one cpu, there is a trickier scenario with
>> pcpu_freelist_push(): if the only pcpu_freelist_head.lock is already
>> locked before NMI, raw_spin_trylock() will never succeed. Unlike,
>> _pop(), where we can failover and return NULL, failing _push() will leak
>> memory. Fix this issue with an extra list, pcpu_freelist.extralist. The
>> extralist is primarily used to take _push() when raw_spin_trylock()
>> failed on all the per cpu lists. It should be empty most of the time.
>> The following table summarizes the behavior of pcpu_freelist in NMI
>> and non-NMI:
>> non-NMI pop(): 	use _lock(); check per cpu lists first;
>>                 if all per cpu lists are empty, check extralist;
>>                 if extralist is empty, return NULL.
>> non-NMI push(): use _lock(); only push to per cpu lists.
>> NMI pop():    use _trylock(); check per cpu lists first;
>>               if all per cpu lists are locked or empty, check extralist;
>>               if extralist is locked or empty, return NULL.
>> NMI push():   use _trylock(); check per cpu lists first;
>>               if all per cpu lists are locked; try push to extralist;
>>               if extralist is also locked, keep trying on per cpu lists.
>=20
> Code looks reasonable to me, is there any practical benefit to keep the
> extra list around for >1 CPU case (and not just compile it out)? For
> example, we could choose a different back end *_freelist_push/pop()
> implementation depending on CONFIG_SMP like ...
>=20
> ifeq ($(CONFIG_SMP),y)
> obj-$(CONFIG_BPF_SYSCALL) +=3D percpu_freelist.o
> else
> obj-$(CONFIG_BPF_SYSCALL) +=3D onecpu_freelist.o
> endif
>=20
> ... and keep the CONFIG_SMP simplified in that we'd only do the trylock
> iteration over CPUs under NMI with pop aborting with NULL in worst case
> and push keep looping, whereas for the single CPU case, all the logic
> resides in onecpu_freelist.c and it has a simpler two list implementation=
?

Technically, it is possible to have similar deadlock in SMP. For N cpus,=20
there could be N NMI at the same time, and they may block N non-NMI raw
spinlock, and then all these NMI push() would spin forever. Of course,=20
this is almost impossible to trigger with a decent N.=20

On the other hand, I feel current code doesn't add too much complexity=20
to SMP case. Maintaining two copies may require more work down the road.=20
If we found current version too complex for SMP, we can do the split in=20
the future.=20

Does this make sense?

Thanks,
Song
