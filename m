Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC01827DA4F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 23:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbgI2Vk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 17:40:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62112 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727922AbgI2Vk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 17:40:56 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TLeYkP027690;
        Tue, 29 Sep 2020 14:40:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=LKoYgQR0AglMN+vvAy/PmZAvqkDqK28iU/EJg69X820=;
 b=L2mFpNzKbURlAxAczCbIhooGrgrMKdiMhg5/8xMgnNRp5Anm98tjAJFgnlna6odkC/Eh
 rmedjinD1liog/6nbJ/AQDTGxzCQpOLc+qa1Zhr+l2CMZhqTK+2W/lNfKDL89LYfQzk7
 7RHwHpoudGQxohGLBj7Zvlgxw6a2IVZJAfY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33v3vtu6gw-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 29 Sep 2020 14:40:40 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 14:40:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XbeIXXq9ok52ceIGc6oAPl9hR+Bnj1heIewCc15ZI0U6H4BnU4cQ8+tZn8DkD/SGuRLepxmqkRI00e22QFQ2WdB/h0OJjKybZta/SKuNsP31SxtgbPzgJpTsWt3FercJRlgdmC9sO0U92cs2vb7Olczbf8KKSVDj3I0k47UJ00YqjPwwiyF7TAd7ereWCJEBkKle3Aj5tqU7BPjEeKsG8toXzV1LU92Z+G4zaDfnfmC2uZoQv+RlomRnZI7cEAgLm1fFIGk/k+erqGYWY+evCIpog/oaFfV0rXeGBlTIOnrLPEoowBwkkZ4PLldnTeRdZufOFg7nyhnprkKNemcw3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKoYgQR0AglMN+vvAy/PmZAvqkDqK28iU/EJg69X820=;
 b=FNQoBzvSO0pOKaFkfWT/tYv3gqj48FUCvC2nFs0og1iaxJ4pIbkINcHMFdaT/KV93Ms5DqiBdBxJ84z3DkQM+DcL8HVxkk9n/AS0EBptM8Bq0VHxCP/gv06o0esuu5xgSeKNV9NAS/H8se6/Logd0GrHZJJBvpCv0MMgb2oZTLK1kJBjxyKc3N2pHfUqaAw28Fux9RjCLHe4pnJGDhhuhK63Ws1/nDbAjlGBzAYogqGFlYbMmvCtmLJP4I4xqMo2NkdxeDLjJZmyGx64DpDlqvpkjfyZVW0cfuUkfZAVoQJ8gmUc+vt4cWskUlY1P0raW3IN8zzOkXsbXA7xgNugFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKoYgQR0AglMN+vvAy/PmZAvqkDqK28iU/EJg69X820=;
 b=KMRnArT/6F+0rMG6EqRZNuHkBYFLYQPVLPLfyJ2F4Pf7+5ngdOSbWhtUTxBzsBuAhj0buG+d3daeEi8GRUnwEw0ZKkgTd3sEVfBeKOtgmv8e3X8tzCrUxWq9ZkONjFGnSX6qJwUB0opQwzFFZJXbxKToPURaYr5oPCzcqKZiDT8=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3572.namprd15.prod.outlook.com (2603:10b6:a03:1b2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.28; Tue, 29 Sep
 2020 21:40:32 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 21:40:32 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH v6 bpf-next 1/3] bpf: enable BPF_PROG_TEST_RUN for
 raw_tracepoint
Thread-Topic: [PATCH v6 bpf-next 1/3] bpf: enable BPF_PROG_TEST_RUN for
 raw_tracepoint
Thread-Index: AQHWk34ghCg0Katebk6zon/IbMVmpKl/9HEAgAA24gA=
Date:   Tue, 29 Sep 2020 21:40:32 +0000
Message-ID: <8508B35D-287F-42D3-8D51-9CDE0DCE8656@fb.com>
References: <20200925205432.1777-1-songliubraving@fb.com>
 <20200925205432.1777-2-songliubraving@fb.com>
 <CAADnVQ+ZMOxjUDCdLfwRGPbjG8YV8kHVu2kM1+JzSffJZ9=W_w@mail.gmail.com>
In-Reply-To: <CAADnVQ+ZMOxjUDCdLfwRGPbjG8YV8kHVu2kM1+JzSffJZ9=W_w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90217fc3-7db9-43e1-560f-08d864c04b19
x-ms-traffictypediagnostic: BY5PR15MB3572:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB35724DFFF77F0B38F32B4997B3320@BY5PR15MB3572.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ese4UeeC+bARX6Sf25h1JtI1EUwV6SHWD0Af/DNUyEuBGjn6PuYLPOFhNCzaStiE3pep8mfb4TW7hyOeAOleKfWgua/vj2Ox0idsIpUhGZaCphuSd88Gu2JNXsSgghZdojGOb83qbbcMnSLDXV2sDg0tjJygERt9u4M6yxSYI/Yk7ZdHnbvrZLl+MeYmDY8RXaABGrCm8GrpEn+bc7o9+n4OtlXSM3uN6gh6kV7EVHugxzst6YfSvGkNSJ/ldYKjPGI+OsP0V/D+zM0YGsKmv5bltZVNFcZhJ99dePCgNfp3Rv3y6+0/pRjzCxdioTgeNxcGdjWx4g4VfB7yVxHZ33pVJiw1qzBzu5qPfqweSMSNLqCDOOiey4rIwzR9G48K
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(396003)(346002)(366004)(376002)(66476007)(66946007)(2906002)(66556008)(66446008)(76116006)(186003)(91956017)(64756008)(478600001)(6486002)(6916009)(4326008)(33656002)(36756003)(6506007)(6512007)(2616005)(86362001)(8676002)(83380400001)(316002)(53546011)(54906003)(71200400001)(5660300002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 07g1SOJN3lFneQMg01axpLYQXkz2+S3iivtKSDRC3Yc1j/+AG6YYd/x+SDejcGdjw8toRztZsJZR3zUbBhHqkr+tUN7hNhSemUxsqBOp//lyuh0ej811Z5noBRdrVjr8Rj7l3DstXo4LW4dtnrWitQwzYHa+HzrHv8wBXYyUsTUeeeQLE9aAluHyHERDap0CRIvPHaYSoh0fHO2v/TJo9JWt7Jee5p7BzQITHcULMZuaBfLt5LPo7l5xC75n6rXhqqBtK2aD+iELs10UaVKXIQHOyNljM2lJzGR/m18NG446KwEJbD6YyChTqLI4xBVS/niLiOXSUr9XyX0tLrCTaAFiv9ra064+7sGfFbq6eHxyFD0BXsACLgb6SYBF26m4NOFNAgXtSPGciOOyNRZXB4tqBQZQOpPMW1FSYvkJBn/YgFs/7Btv9HWsj+PlnFAy918tWCVoVaEMZkXjNCzCsfmB4GF6dIB9Bol+0AZ01sj1lbLSqesNMwon3QaI84idPlMvsaxGOiB0UZsQJ/Yn/LxU/9AKnB+2fCTzvy4RWjCjaUU5W/r5/FMXbVu85VlTq1N20pnmgZ5jdCe10SMGqut3b3ZuJSmq8sC34diI3FSwebpxU13L1zNvNNnB+zt2GLreXY8Oup2X0rJVhD13fokRgvD1C9L0/AzbzOQxJ99EV6MPflCK4/nGMu5///o3
Content-Type: text/plain; charset="us-ascii"
Content-ID: <77E720DCA83F634AB9B7BDB5EA91368A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90217fc3-7db9-43e1-560f-08d864c04b19
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2020 21:40:32.7786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uz0DlJQno+uXHgXzHl5LIhObaMLDMvBPeJ/WedruTggsKdzTFoqIP4HCXsmFXUQbEhGVyMU11JUBTK27tnsSYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3572
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_14:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290186
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 29, 2020, at 11:24 AM, Alexei Starovoitov <alexei.starovoitov@gmai=
l.com> wrote:
>=20
> On Fri, Sep 25, 2020 at 1:55 PM Song Liu <songliubraving@fb.com> wrote:
>> +
>> +       if ((kattr->test.flags & BPF_F_TEST_RUN_ON_CPU) =3D=3D 0 ||
>> +           cpu =3D=3D smp_processor_id()) {
>> +               __bpf_prog_test_run_raw_tp(&info);
>=20
> That's broken:
> [   35.874974] BUG: using smp_processor_id() in preemptible [00000000]
> code: new_name/87
> [   35.893983] caller is bpf_prog_test_run_raw_tp+0xd4/0x1b0
> [   35.900124] CPU: 1 PID: 87 Comm: new_name Not tainted 5.9.0-rc6-g615bd=
02bf #1
> [   35.907358] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.10.2-1ubuntu1 04/01/2014
> [   35.916941] Call Trace:
> [   35.919660]  dump_stack+0x77/0x9b
> [   35.923273]  check_preemption_disabled+0xb4/0xc0
> [   35.928376]  bpf_prog_test_run_raw_tp+0xd4/0x1b0
> [   35.933872]  ? selinux_bpf+0xd/0x70
> [   35.937532]  __do_sys_bpf+0x6bb/0x21e0
> [   35.941570]  ? find_held_lock+0x2d/0x90
> [   35.945687]  ? vfs_write+0x150/0x220
> [   35.949586]  do_syscall_64+0x2d/0x40
> [   35.953443]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> Please fix and add debug flags to your .config.

Hmm... I do have most debug flags enabled. But I didn't have CONFIG_PREEMPT=
.=20
I will keep that on..

Thanks,
Song

