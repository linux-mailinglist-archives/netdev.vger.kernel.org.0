Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E55027EDC3
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgI3Psn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:48:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12810 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgI3Psn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 11:48:43 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08UFkNqF003588;
        Wed, 30 Sep 2020 08:48:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=DR4ZtOn4kW7m6qtkGlJ7a7MXYlnFlYugl91QrDmKAL4=;
 b=Ajg3RaiIzSj96+2/Mjg0ijv0l6UQ5cHkEXm1t/kp1/YJcgJ+/sKihC8L91aPkaFckzv/
 nN8dCVKlic9AHiif1/QxhBTXx27emxjiRqKsreLqU4FwNPN2uo88WlTNWAPdLN3pzYE9
 fVsFKTZF4YzaIamTUZ4lY+NmFDQxzHwDJis= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33v6v46hn8-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Sep 2020 08:48:28 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Sep 2020 08:48:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aw7Qusht2ZSGubHDwVedgI1HCFeTKPrGig8b4d2tntpLyVsCN7c73poCJoAlPxFJawyV355WHa4M2o1AjexZUpu4DP3vow9Uwsk7h/QH0CK09XPWbaLtI78Xt2k2w3szum6dm1vVH0PuwOTrRDM1iMLfZ+OmKrd+8l7AHjPREJxhbRC+DyuOu1qzcSr6utWiKx/+meIYPtBOSvo+gecoBn5xfabfJZb5zI5bqBnHpWmLJYyUw/bYkwVf7s5smdLIXQAG03Liv/d4ZR0YxF+0nviKps7+6sjvAIp3sQRLs9bN77o8+Wt7EDhp2qjtFFsFBoI3CM5Y5utvNdHryX1q3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DR4ZtOn4kW7m6qtkGlJ7a7MXYlnFlYugl91QrDmKAL4=;
 b=j1Eg5GCI4OxJDZQq2QY/gv1rRpfqTYMq6Jrmj1JwYt53u9BH3FTgJ77UA18YlJbkYTzaL7RWHYPtJW1CPtmHreRPoYop7S8cOssLWwEBKhgTdosOlkA20aLjbHFvS/rtxB353GYiOVbQeDCycHeDF3UqODaHGMMSdy3hBm0LX9sAWsMcRhoZyR3XhHVl72hzjFi/pwqhfGAuLKq+IZLpB5ShvEsxIXi7IT1ibaAnbGcQTSGiu7KRYHEKJezgln7Xffhd0CYOP8UrDGrMSJG14bCQT28CDj0VMMleI3eo3NUPsPnCqDEDzRQGXxNr8SnrGjygU3D5iUejBujqwK5+IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DR4ZtOn4kW7m6qtkGlJ7a7MXYlnFlYugl91QrDmKAL4=;
 b=ftcuDf1sXEsE0xcJarsx5HiOffcVjd/DdIY27Uv8U1jgy/PSb4uV62I1qQQN1ueSuzP5t3h9m/j9OJkVPfw6qrN+/C09SCLlwUs8Bi/VM5Cmwysd9bCVtBKUz9npD++fNi0btI9LHemBZkDvgpHOLSzwAwib4T0ZohoVlxl1xkk=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2840.namprd15.prod.outlook.com (2603:10b6:a03:b2::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Wed, 30 Sep
 2020 15:48:13 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.029; Wed, 30 Sep 2020
 15:48:13 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@fb.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH v2 bpf-next] bpf: fix raw_tp test run in preempt kernel
Thread-Topic: [PATCH v2 bpf-next] bpf: fix raw_tp test run in preempt kernel
Thread-Index: AQHWlr98m0MK4EXH4EugATXlfwV0VKmAhMUAgAA4WYCAAJQnAIAAA3GA
Date:   Wed, 30 Sep 2020 15:48:13 +0000
Message-ID: <8EFE87FC-84D2-4B63-B057-804A6F9F1F63@fb.com>
References: <20200930002011.521337-1-songliubraving@fb.com>
 <CAADnVQ+jaUfJkD0POaRyrmrLueVP9x-rN8bcN5eEz4XPBk96bw@mail.gmail.com>
 <5684F41E-8748-4CBE-B37F-0E4AADC0A799@fb.com>
 <09b5c318-afb3-2c3a-1b2f-936eb1b9b32b@fb.com>
In-Reply-To: <09b5c318-afb3-2c3a-1b2f-936eb1b9b32b@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 771ad239-dbb3-4ab7-7ae7-08d865583da4
x-ms-traffictypediagnostic: BYAPR15MB2840:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2840A9D284CFBE77BA2409D7B3330@BYAPR15MB2840.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KR/puf/WHrAkwVv+eEyP7u8Z9dFL86TUfFnjE2/5A8sPBXXhlc4z10AUiWzxyDFAgLD5G2MlSAbtGVIEPdt7dnLv3eEqE+UNXg0y5s/jO0dc+cKaC8idhm/l6dWxLPTyvf0DFGprJt2AcRrUzT21Yq2tq03OO/vG+QY9H43ZLfI6DU9oCHjFPqd9Cp82eK22rhJ4OzyHAIF4kNQazsr0WMXC64LSu6W8WQVnei9bEUgIvrcIkxjMxcH+8DDIAKkJRBuHDLYiiuowjDTRrw7Zky2Gx5KzF4YQi2qWaAl9xTWPZWUdNZSSXA8JY06sa2QsxUtAz2n5RR/qM24ojrXa540cA5K+4uHzC0vnAVtfRKhSnEY0f31k/fncVzBvdEXQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(39860400002)(346002)(8936002)(33656002)(54906003)(316002)(478600001)(37006003)(86362001)(5660300002)(66556008)(66476007)(66446008)(66946007)(2906002)(76116006)(64756008)(91956017)(71200400001)(83380400001)(6636002)(8676002)(4326008)(2616005)(6862004)(36756003)(6512007)(6486002)(186003)(53546011)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: cgK91gKUrkhMHa6lCrCAIKDOqKth+KF6vtOiQdMf9gyQHxX7VLFwa0O8I59CIYiRW5wdFpVwf1iEcWaCV5aA+jJGYOYigS51wEyU4E5dCmFArds1pUMmi7w8WechxOjEBXVHVJhotqThxvrtTY2kQ9I6ERqDHdccT31zNHsJnVq+vwPeMyWfywR+fGGHRSAEORoltyg9b3wLXnVel9LKvuSNNq+tqSt3qiZjQTm1FR8Gpe5vNjC+WaBxMFw1hMW4yT6rkbLAIKx1YM4nwM7vvuK7NQi/5FnBRZINOifmWul1Yz8hGefe+qICA0d6bZ1z5Yv/yROzcew82QlqZqqXZgt1K/jFnfDX+GRQn3CzJfyFexLCmNjT4IgnHgG9DdxjbUqsEnEH2Bi383mQOkW9p1mBgNliuhT9y04P+gOrTKGQqOMS4LyucaRzRuQOSqOS4Nw/p8cOGI3Y/dnJhVA22sGggk/TBzRKc3fcYszamb3qcaxxrwyG8pkIUcyUXX8UYXzoqTaiIZbuqMlbELwJ7Dvq9U4xWUltzlm2RnqCpooN7pRHk8nTpbFPQb155f4imQAXEwAlyHqYslxtSco+C/EW/NIqj7UD4pHNofckiC39g228ZNm1wGEkVIuYgakKCTsmHEXEF6Z3i/F8CMMF1lBaCnE+L4pr0xhw5XnIFhG2mVszL0Jo3sP99XcgIYfB
Content-Type: text/plain; charset="us-ascii"
Content-ID: <641FEC7020C17A4D8BEED90BF3DAEEC9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 771ad239-dbb3-4ab7-7ae7-08d865583da4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2020 15:48:13.6833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AJK2XctE8xtzZYrH2kr8Rk2lMLIKMTNagDDiyOM76ituTWdR0W7WXfkhLC1x6nPGQBv1GXlz5cEWbYWPE54X7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2840
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_08:2020-09-30,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 mlxscore=0 impostorscore=0 spamscore=0 bulkscore=0
 clxscore=1015 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009300125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 30, 2020, at 8:35 AM, Alexei Starovoitov <ast@fb.com> wrote:
>=20
> On 9/29/20 11:45 PM, Song Liu wrote:
>>> On Sep 29, 2020, at 8:23 PM, Alexei Starovoitov <alexei.starovoitov@gma=
il.com> wrote:
>>>=20
>>> On Tue, Sep 29, 2020 at 5:20 PM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>> In preempt kernel, BPF_PROG_TEST_RUN on raw_tp triggers:
>>>>=20
>>>> [   35.874974] BUG: using smp_processor_id() in preemptible [00000000]
>>>> code: new_name/87
>>>> [   35.893983] caller is bpf_prog_test_run_raw_tp+0xd4/0x1b0
>>>> [   35.900124] CPU: 1 PID: 87 Comm: new_name Not tainted 5.9.0-rc6-g61=
5bd02bf #1
>>>> [   35.907358] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
>>>> BIOS 1.10.2-1ubuntu1 04/01/2014
>>>> [   35.916941] Call Trace:
>>>> [   35.919660]  dump_stack+0x77/0x9b
>>>> [   35.923273]  check_preemption_disabled+0xb4/0xc0
>>>> [   35.928376]  bpf_prog_test_run_raw_tp+0xd4/0x1b0
>>>> [   35.933872]  ? selinux_bpf+0xd/0x70
>>>> [   35.937532]  __do_sys_bpf+0x6bb/0x21e0
>>>> [   35.941570]  ? find_held_lock+0x2d/0x90
>>>> [   35.945687]  ? vfs_write+0x150/0x220
>>>> [   35.949586]  do_syscall_64+0x2d/0x40
>>>> [   35.953443]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>>=20
>>>> Fix this by calling migrate_disable() before smp_processor_id().
>>>>=20
>>>> Fixes: 1b4d60ec162f ("bpf: Enable BPF_PROG_TEST_RUN for raw_tracepoint=
")
>>>> Reported-by: Alexei Starovoitov <ast@kernel.org>
>>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>>=20
>>>> ---
>>>> Changes v1 =3D> v2:
>>>> 1. Keep rcu_read_lock/unlock() in original places. (Alexei)
>>>> 2. Use get_cpu() instead of smp_processor_id(). (Alexei)
>>>=20
>>> Applying: bpf: fix raw_tp test run in preempt kernel
>>> Using index info to reconstruct a base tree...
>>> error: patch failed: net/bpf/test_run.c:293
>>> error: net/bpf/test_run.c: patch does not apply
>>> error: Did you hand edit your patch?
>> This is so weird. I cannot apply it myself. :(
>> [localhost] g co -b bpf-next-temp
>> Switched to a new branch 'bpf-next-temp'
>> [localhost] g format-patch -b HEAD~1 --subject-prefix "PATCH v3 bpf-next=
"
>> 0001-bpf-fix-raw_tp-test-run-in-preempt-kernel.patch
>=20
> could you try without -b ?

Yes! -b is the problem here.=20

I think the right way to format-patch is to use --ignore-space-at-eol=20
instead of -b.=20

Thanks,
Song=
