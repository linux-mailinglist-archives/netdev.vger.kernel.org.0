Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176FA27E19D
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 08:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgI3GqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 02:46:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28594 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725320AbgI3GqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 02:46:06 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08U6jkJQ030978;
        Tue, 29 Sep 2020 23:45:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=1IM9XQ9GTouz1fNRDwjOnlFpUZXLScwrQruexYeMAY4=;
 b=mx/z47ElKWA1nZH3J5T38XHUEYT2FCPwRO5815eIF7241KkfV4y7l4JG0cTxIfraRRnC
 0j7QgC1iWusM2QkecpIqxCm1hOQcueJtxrTJf3XdM1jGnfT9DHkgS/Zn2js6kUzbIpFz
 uD79zD5kT/nsvr+wtXqhGtQP0GsA4aI3rfo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33t35n9htp-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 29 Sep 2020 23:45:49 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 23:45:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzqHSsyI9aQ4t/ZErxx3nUuiCx/E7oST7qqVUg1kSi0HYwTK9Na4hhrgDcOKg8qDsWbWYu32ABKyuvkvuWIJG4B2/Am4iPemlwJU7L0N5dgBSb6RZENvegMr6de3cOJujZ8tIR1eEzQR9ttsgt8IHcFV5vv4/FN4qLqw2t4EIvELAerRxOzTSAqYl9iNgWivs6wLfiFpkCKOd3qXEpLvO/sRP2WuZd525tMuvku0UnJTelLGV3LhP222ebQfF+YOsmT0UxJPETeA/o499iX+kufv9vY6A+afyxcFHrYdvl3aiQ8gzJg6Kn8Emq8NkwQ6ymffJ5U/mP5MoWmWErl67w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1IM9XQ9GTouz1fNRDwjOnlFpUZXLScwrQruexYeMAY4=;
 b=EVb7n5HdYOK3nUl/DzwtjiVX48QlwHIrTed+jUXVUSWEQxLa6EC+7KTwsddT8gRGLWInWjQHhZiDxKxSVTb2ToShXWlY0/AxjMoUXmcfVjyuBlxKzJNNcUsVbxEEAQStJswNknMLGi4n79g2cXfOTNPoUMvhXcE3BA6HYk8rVpAsqK+mpa+kMSOYI3qSedRfiEfvivTaVwAKFi8w/7ZYetqvn1p1kvvGrd91KWaFZerrepzlvXpjGY8m7d9xoFDfRTTbZ93d7F5EUmcejGUfqq/WSNessHRxDRw+OzRkHOOMLCj0vlmJ6dG7rlBRPwsm5b51gPF57yG38zSZ3/Q+sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1IM9XQ9GTouz1fNRDwjOnlFpUZXLScwrQruexYeMAY4=;
 b=MptR6Aax5LQUxhs2ZFf8wr60isRRe+tqeiqMgAxwvGYknomRX2rBSVUe66JOxoJnJzlfrp0mDcblD4G6gSGgW1ESvQdBrpsJ3vtTWiXUuwlQLc3zLvtY5UwPVF2KkhTTd+FMVQA2x+NmS4DP9pV6dmqMwcHRR3KKuWF91aTJsS8=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2952.namprd15.prod.outlook.com (2603:10b6:a03:f9::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Wed, 30 Sep
 2020 06:45:41 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.029; Wed, 30 Sep 2020
 06:45:41 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH v2 bpf-next] bpf: fix raw_tp test run in preempt kernel
Thread-Topic: [PATCH v2 bpf-next] bpf: fix raw_tp test run in preempt kernel
Thread-Index: AQHWlr98m0MK4EXH4EugATXlfwV0VKmAhMUAgAA4WYA=
Date:   Wed, 30 Sep 2020 06:45:40 +0000
Message-ID: <5684F41E-8748-4CBE-B37F-0E4AADC0A799@fb.com>
References: <20200930002011.521337-1-songliubraving@fb.com>
 <CAADnVQ+jaUfJkD0POaRyrmrLueVP9x-rN8bcN5eEz4XPBk96bw@mail.gmail.com>
In-Reply-To: <CAADnVQ+jaUfJkD0POaRyrmrLueVP9x-rN8bcN5eEz4XPBk96bw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92ef6db9-ce51-4ecf-548a-08d8650c72ac
x-ms-traffictypediagnostic: BYAPR15MB2952:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB29529C7938964043E4D6FA6BB3330@BYAPR15MB2952.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VrDTgOIz0kTiRB8FM9aN7y2bRseos+B7Jei61DXgGts4nlz7pIZuQzgMEdgH0WdquTc39nOWqxxgk7wav8Nq0hFpUp7017klT3URBBc7V5z2iIYqMnf+rBJswlB4rOnLIMG2C4ebx1b0LlZiFSmZ8y8z+QHTdRR3Sa2TnnNrtV2rpDUURe7FyXLbEp5kIdu6728s1+03itETOmlkwddCG+mRvugMYlAfBfkk4in/k9gbI7gzFT2AuYif9bHmZutOoe3o/FyWC6Utt1yOzkbylCJb0c1e5Vj1YJIxi+6+vIjQpehZRZzNKkoWFFgRtCuZZt+sS0gqZ8nhL5xus+iEqJiGKDkWDkCwn2mjQcYcLpVkUuhFPDupyUSgrcs6IEIDWXE8rqtJocEqR/PoLeCjhUEn5T8o6+IylBFAbgc8TacCfy/jst8rRlfGXpoxG81N0eqauB3qmR3ZVHr0GEzPkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(396003)(136003)(366004)(316002)(54906003)(6486002)(4326008)(66946007)(5660300002)(2616005)(478600001)(71200400001)(91956017)(66446008)(64756008)(66556008)(66476007)(76116006)(53546011)(6512007)(186003)(6506007)(8676002)(2906002)(966005)(36756003)(8936002)(6916009)(86362001)(83380400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: VwuLk6h3AC95DSgnldARAuQyUC18A3qSbJ7bqZsRSxTiH5Hh9hhF6iGtzXOHhTx1MDiHRYtjQ905qXB9nC7eCrM8dBz6ZMljcslxR/a4/6P+wVeOL6TcbDFTfFWpaiXw2V+kilQTWvt8oeGXI1iR8roEo0Uq81DJ+KL0N5iAnWxAC2gOaQ3nSZoTT9KdKot0S6hsgdNDlmU2w4SEkRGefSEAKVGBzw/tOlwqPKnR4hFlcC1EYrFeJHk8+TE/05XraIY4dA3Nc+/Lzl5sA92rhk9f37YuEIToEED86uLHjfELuh+qh8PLowX35ldxfq6BIzsqHmb2XW1oGj+2Q7VsD91gtWZwkxfXjqDz90f7PvWp/UTBC0woilvCChm2BMx4szJZ8gACNBgDLGlv65sGoUNPxm2o1IG9dI4laZ/bPZYlHIRQ9ONwSW2XCtQ7awX4hN2Fc+caB/au5Ru29qtfG7bcAPbnvcar6H4cAOByly9y2jJvrHyAFvRAgGTH9ZnzoX931Qk8IKLxmMcEm+D624mORG463NL2OGVygEsmfSlNuEc31Z8xBN3HHo8D4hePHEYS152LvaYVyHmZFaEoaMnBmAunZ6uFxo4qtqVqKxM/26utC24Rbf8YGfGkzx4ssmA8VoHZHOdbCq6ImVGy0qaDpFe81UeZBK272W3GkhYMfa5OQlyzBmXWpF3SS/HK
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0D33667557473E48BA5D4EB58116C6E4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92ef6db9-ce51-4ecf-548a-08d8650c72ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2020 06:45:40.9135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uNE2kBNGXIkKDd2jdnBeNFDCGe42ym+RquI0GSugtcYxKIISvLav4h7bf0lGlYsRgU5Qq9hCbbPMDTfrUQP2sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2952
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_03:2020-09-29,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 phishscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300053
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 29, 2020, at 8:23 PM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
> On Tue, Sep 29, 2020 at 5:20 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> In preempt kernel, BPF_PROG_TEST_RUN on raw_tp triggers:
>>=20
>> [   35.874974] BUG: using smp_processor_id() in preemptible [00000000]
>> code: new_name/87
>> [   35.893983] caller is bpf_prog_test_run_raw_tp+0xd4/0x1b0
>> [   35.900124] CPU: 1 PID: 87 Comm: new_name Not tainted 5.9.0-rc6-g615b=
d02bf #1
>> [   35.907358] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
>> BIOS 1.10.2-1ubuntu1 04/01/2014
>> [   35.916941] Call Trace:
>> [   35.919660]  dump_stack+0x77/0x9b
>> [   35.923273]  check_preemption_disabled+0xb4/0xc0
>> [   35.928376]  bpf_prog_test_run_raw_tp+0xd4/0x1b0
>> [   35.933872]  ? selinux_bpf+0xd/0x70
>> [   35.937532]  __do_sys_bpf+0x6bb/0x21e0
>> [   35.941570]  ? find_held_lock+0x2d/0x90
>> [   35.945687]  ? vfs_write+0x150/0x220
>> [   35.949586]  do_syscall_64+0x2d/0x40
>> [   35.953443]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>=20
>> Fix this by calling migrate_disable() before smp_processor_id().
>>=20
>> Fixes: 1b4d60ec162f ("bpf: Enable BPF_PROG_TEST_RUN for raw_tracepoint")
>> Reported-by: Alexei Starovoitov <ast@kernel.org>
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>=20
>> ---
>> Changes v1 =3D> v2:
>> 1. Keep rcu_read_lock/unlock() in original places. (Alexei)
>> 2. Use get_cpu() instead of smp_processor_id(). (Alexei)
>=20
> Applying: bpf: fix raw_tp test run in preempt kernel
> Using index info to reconstruct a base tree...
> error: patch failed: net/bpf/test_run.c:293
> error: net/bpf/test_run.c: patch does not apply
> error: Did you hand edit your patch?

This is so weird. I cannot apply it myself. :(

[localhost] g co -b bpf-next-temp
Switched to a new branch 'bpf-next-temp'

[localhost] g format-patch -b HEAD~1 --subject-prefix "PATCH v3 bpf-next"
0001-bpf-fix-raw_tp-test-run-in-preempt-kernel.patch

[localhost] g reset --hard HEAD~1
HEAD is now at b0efc216f5779 libbpf: Compile in PIC mode only for shared li=
brary case

[localhost] g am 0001-bpf-fix-raw_tp-test-run-in-preempt-kernel.patch
Applying: bpf: fix raw_tp test run in preempt kernel
error: patch failed: net/bpf/test_run.c:293
error: net/bpf/test_run.c: patch does not apply
Patch failed at 0001 bpf: fix raw_tp test run in preempt kernel
hint: Use 'git am --show-current-patch' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

Any hint on how to fix this? Alternatively, could you please pull the=20
change from=20

   https://git.kernel.org/pub/scm/linux/kernel/git/song/linux.git  raw_tp_p=
reempt_fix

Thanks,
Song=
