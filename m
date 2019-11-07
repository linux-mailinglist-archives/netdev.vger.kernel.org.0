Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66E64F3C01
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfKGXNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:13:34 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41938 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727070AbfKGXNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:13:34 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7NA4C7018174;
        Thu, 7 Nov 2019 15:13:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Jp+usn6UazsdoXRawSL+huKXes0luzebwyA/RuUZPy4=;
 b=GFuyEzCpAfs0s37EKtQLxuPSWombQoNKgpOw6+QIhTKJlGskx+7r1mq5rxDk0strovX4
 C/xEAGZO5JK8D4n98Qrc1rJvKjvtJDBVhJQoTHkn9pCF+mZk39gPcGtfXhOFbF/Hc3v7
 uK1w7JKJoRlpspBwX/5QGbzDOvlBjWGKW+A= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41u0r0jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 15:13:18 -0800
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 7 Nov 2019 15:13:17 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 7 Nov 2019 15:13:17 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 15:13:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lb3lEdYw8Em0uljABZwkSxmjsfpgJZ/bJ84cOnK1fEslVCkG8B3MDk9qsa2XIXwO61cGd0o45mVOIK9S13zl28LUZMW0/QbT/8WgR3DdJOSEs5UxO28efnK0gMq6RNKutCZHVqHE2w9z30oyB827i4DeYER6Wa7XMyPASJIbb1PeUb2UiKEg4UIbsxFBD1ePEcGJY603NHLWV2HoBYSc6USmbximN7GlidzWARydiVPQ3w30SfRTG417Zekr5q72w/PHkWpe7LOGOPHgzey2PON5Lx7/xLSsNo4n90uQNK+PjqldTE85cMxeQAuMCL1ZjdZALyapjyqQXK+MkLEHFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jp+usn6UazsdoXRawSL+huKXes0luzebwyA/RuUZPy4=;
 b=TxGqX49cemMmyuvIK0bfL25oWK5QVwFyHWtE36HIdXubS7ue2/jWBRIl4BCKq4oi8pKhL5rPrt9yK4TAepS3pDiU+UXbcSihQNHa0SpiIEoDJ+qej0A6Y0iD892xMt5wlDzGswILTEziWvOWdHY22M1+s41wxB7dxSHhumpgRPRAUqeNCmT2vlGYCqljZ6x3Rhjte5JCGl/XeixwIBKJzOYOWKNaFp6QkXbfb4Rg+ZhyAIGRQfrg2tWwL3G8BJuKj8urDph2cGW4RPYcqy84wflfYHvRMBWqGC7geRC+PaEIOUK+sfxoMxipoO1R4a89keB8PxKmseuf4s2wZqqnUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jp+usn6UazsdoXRawSL+huKXes0luzebwyA/RuUZPy4=;
 b=f75UQqTzdywRb7DpRNa+A1mqZhw1Etyi0nUCahB+Qsv6W4K3gvG0KKvzGK3BB7MgRDN/y0ur5rJcdpT+8meA8zbabnOHZC4eUGVP8J6MLcpS9XWhDNe2Pwo6vgXVCxeqOOjVF29EBlPqozlQiMYLQcGaVlvAPzpDKDqYxUftCCY=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1776.namprd15.prod.outlook.com (10.174.96.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Thu, 7 Nov 2019 23:13:15 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 23:13:15 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 04/17] libbpf: Add support to attach to
 fentry/fexit tracing progs
Thread-Topic: [PATCH v2 bpf-next 04/17] libbpf: Add support to attach to
 fentry/fexit tracing progs
Thread-Index: AQHVlS7jYVIzh19QiEmCQVoPVUOiDaeAUXgAgAAEd4CAAAGQgA==
Date:   Thu, 7 Nov 2019 23:13:15 +0000
Message-ID: <0C3973CD-34FC-458B-9085-B0415D83049F@fb.com>
References: <20191107054644.1285697-1-ast@kernel.org>
 <20191107054644.1285697-5-ast@kernel.org>
 <693CECA2-5588-43AD-9AC9-CF5AF30C4589@fb.com>
 <20191107230738.u33hnfzahccurob3@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191107230738.u33hnfzahccurob3@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::1:11cf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7899aab1-2ec7-412e-175a-08d763d811ab
x-ms-traffictypediagnostic: MWHPR15MB1776:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB177607D5B13602E887B2B0BFB3780@MWHPR15MB1776.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(39860400002)(376002)(396003)(366004)(199004)(189003)(51914003)(476003)(7736002)(2616005)(486006)(256004)(4326008)(50226002)(5024004)(66946007)(76116006)(66556008)(71200400001)(46003)(66476007)(64756008)(33656002)(66446008)(8936002)(81156014)(446003)(86362001)(478600001)(81166006)(71190400001)(8676002)(11346002)(76176011)(54906003)(316002)(102836004)(305945005)(229853002)(36756003)(5660300002)(6506007)(14454004)(53546011)(2906002)(6436002)(6116002)(6246003)(6916009)(99286004)(186003)(6512007)(25786009)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1776;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a6zyvvbpFYnQ0rqQXRqVzinbqf5Zk1bHFYk0Ldj2x4OSTbEaqoNarSvNLSGHpTwqcpwjkASl/J3pvgPUJSlzetuRgxpz7y618DDw4btd44Vmfk6Q8wSIgNdCJ43fQCVSt/ZhSWhm6+yMaCTiYVvr9XXBjXhNIbfaIg99kao/VJshkgK+9dGM4lBCPeHnJbiY5mLy1X+V2OKgjW8CAf+jOkzS23VUHb/L4rijw7iHnXhuMvaYdAJmFilU0kuRvFsagcRs7j+VyiV9MvFRGulAg0HUBcmSC15mVjAInii/GPGpEUZJdaENPJueCyh0hZxa03VdAgaBTIO25SYZ6xGRn260/MA+QqEE0m8Cduli7p3z3ZaD3Jb6LwWPYSZiGB4F+FaP0YKTFCXtN9XD26MMXnF+rMpjAlXuBUXD6JrdgZkjGjkE1MaNY9phQv2F5vkq
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BFC1E37204494447845368718DB346C7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7899aab1-2ec7-412e-175a-08d763d811ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 23:13:15.4316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8D+T1k9P+vrJ6PCrwiloGHq4FqacIzaFV99Cf95JIoxba3HYPdYzMMHg+A5bzNRbjfMq6rfgrk6E17wbpUj8Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1776
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 bulkscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 impostorscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070213
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 7, 2019, at 3:07 PM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:
>=20
> On Thu, Nov 07, 2019 at 10:51:41PM +0000, Song Liu wrote:
>>=20
>>=20
>>> On Nov 6, 2019, at 9:46 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>>>=20
>>> Teach libbpf to recognize tracing programs types and attach them to
>>> fentry/fexit.
>>>=20
>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>>=20
>> Acked-by: Song Liu <songliubraving@fb.com>
>>=20
>> With nit below:
>>=20
>>> ---
>>> tools/include/uapi/linux/bpf.h |  2 ++
>>> tools/lib/bpf/libbpf.c         | 61 +++++++++++++++++++++++++++++-----
>>> tools/lib/bpf/libbpf.h         |  5 +++
>>> tools/lib/bpf/libbpf.map       |  2 ++
>>> 4 files changed, 61 insertions(+), 9 deletions(-)
>>>=20
>>=20
>> [...]
>>=20
>>>=20
>>> /* Accessors of bpf_program */
>>> struct bpf_program;
>>> @@ -248,6 +251,8 @@ LIBBPF_API struct bpf_link *
>>> bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
>>> 				   const char *tp_name);
>>>=20
>>> +LIBBPF_API struct bpf_link *
>>> +bpf_program__attach_trace(struct bpf_program *prog);
>>> struct bpf_insn;
>>=20
>> attach_trace is not very clear. I guess we cannot call it=20
>> attach_ftrace? Maybe we call it attach_fentry and attach_fexit
>> (two names pointing to same function)?=20
>=20
> bpf_program__attach_trace() can attach all BPF_PROG_TYPE_TRACING.
> Which today are:
>        BPF_TRACE_RAW_TP,
>        BPF_TRACE_FENTRY,
>        BPF_TRACE_FEXIT,
> There will be more BPF_TRACE_* enum bpf_attach_type in the future.
> I considered naming it bpf_program__attach_tracing(), but it's uglier
> and longer.

I see. Thanks for the explanation.=20

Song


