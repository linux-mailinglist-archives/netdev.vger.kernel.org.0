Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B10927636D
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 23:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgIWV7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 17:59:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7690 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726466AbgIWV7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 17:59:53 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08NLxXwt030789;
        Wed, 23 Sep 2020 14:59:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=obLEx+4qOQkZEJrBOT+ooVbV3mKVhCMOMlvkExNHhBo=;
 b=StKrn5ce7aDUsugHUNtd/1CPRhxJ8qVK4Fg6+rAt04XSQ81ILJz5j0GIA9ITek0dWLCE
 5yxvzJw26kWyDBx8FpT5sW0s0+pucjun6tuIpjsI5w5CQVt6sIBrqnxNSr6C+41bSOW4
 FbJDlTvW1/BrgC2B+nnM2YPf/5S2NNFlEtQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp3xbf0-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 23 Sep 2020 14:59:38 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 14:59:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I0eDD71BX3xie6ZbWfRFDH+21RA9zgMHTC/6rijcB/Eq+1BTC9G8gIN+0i4pei8bsznnAuM5LZ2RJIi//C1if7Ftj7FjzXaWE4WCxx9QZqi/Fcw+9hizcLosiDEtq8COi6tcxMtxpht7Yg6NBg3HEOu4gObxSVNajFJN2bkidFrweGYfNT7RI4Afv/FeFGq20eZSdbDM91H5V7HXeUv8SVaDaEcUJXLbiqDdSKzyv+uvCEzxNg+qK5GrtSOqS3jgsPfPnAaZvyzZM6jcyAncifI0tEO0rWj/PB3W7yFhbYNBjKvpkvTEFxWCdzaMVDEJGEV5Db0A+Wn4o8g+twytGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=obLEx+4qOQkZEJrBOT+ooVbV3mKVhCMOMlvkExNHhBo=;
 b=OFXSSILiZ98euY6Xmzj3D4zMG7/0SRj1KNQSHTiwq6QCyeElA28xIDwPWOXUouGdTQejJVjQzbd8z9dkCIQxqx/UOK7G1se4uz5KtNpRhxLNDL/meM6tHC6yO+vYh1hbKSea1PTT3uqNkLyCDzlUSjZEZUL13K3DiUz1Bd1r1zBbj+fczN3Anq5eKwsa7eS/CZ2naCGO2nbh2KQohsz0uplet9wjmyoZ67P3TU+vEzgtqTDywHOLbkFhE6/TZz+TctUjHo5ixlJRbfaD3vnHcLLklsFCDohRRwB+YhtA4BgwV4N/wuAKi8UMuS5OL7Cy9lKj0FRkZjzttDgGG7IcOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=obLEx+4qOQkZEJrBOT+ooVbV3mKVhCMOMlvkExNHhBo=;
 b=P3FgeycbgWra11S91g5I8HbkEHF0YZOV6yE2PC3Z95KQR9/5SizLRTo2gnuHIzeSlXGCvEi/7cCeiKCKfPTe9RIcHAFaYftsrY5JTPXad+nSmmhNm8JtctQYEOXgMUyCIL3k2pa0mP1Rq8VNOhBo+H5/pUNkfHyTBJaSryd+o9w=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2455.namprd15.prod.outlook.com (2603:10b6:a02:90::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Wed, 23 Sep
 2020 21:59:28 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 21:59:28 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: enable BPF_PROG_TEST_RUN for
 raw_tracepoint
Thread-Topic: [PATCH v2 bpf-next 1/3] bpf: enable BPF_PROG_TEST_RUN for
 raw_tracepoint
Thread-Index: AQHWkcoua2ypH6DniUOuKUgrf87R6Kl2ngEAgAAoBQA=
Date:   Wed, 23 Sep 2020 21:59:28 +0000
Message-ID: <4B132A14-3E2E-4755-90A3-C886EF94AB38@fb.com>
References: <20200923165401.2284447-1-songliubraving@fb.com>
 <20200923165401.2284447-2-songliubraving@fb.com>
 <CAEf4BzYfnhtZN9d6x2BnvktZk_BL=H6gfSxS_qeVTR5_QJAWqA@mail.gmail.com>
In-Reply-To: <CAEf4BzYfnhtZN9d6x2BnvktZk_BL=H6gfSxS_qeVTR5_QJAWqA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 250503a0-a9e8-46c9-baab-08d8600bf17b
x-ms-traffictypediagnostic: BYAPR15MB2455:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB245556131AC0AD59F07022A9B3380@BYAPR15MB2455.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aspTmFYZMmLWRKtW6AJmILTlvIqNhoGL9gutbKGlBGHpadxIdWdrCwqzqsJVh+5fn7rOKRbppvEvgp+IBSrKwiise4DOdoK7tqjhh5gwgTsWp/x8qg+RNucT536TLDEM38IlMqsFrUVHbNcB+7tf58WDQP8gsXxzDgTY7wD1cx/w05ZLCZ9AGgIYDy6I1nPct25V4BVEv/LiNGA+phCGf7KnOmJ9WByDKX1nTzCVMHItj+sy+Bu94MOjAlhT5mBNe6nAqttEx78ivwA1cw6uFN9mWs+GCbDyWmkVCqUrLUeSdZN2FdkQ20qNZwog+IU1I17jo0dsLDHNtQTqw0d9kQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(366004)(39860400002)(136003)(86362001)(66446008)(186003)(316002)(64756008)(66476007)(53546011)(8936002)(71200400001)(2616005)(6506007)(66556008)(6916009)(54906003)(478600001)(2906002)(83380400001)(91956017)(33656002)(36756003)(76116006)(8676002)(4326008)(5660300002)(6512007)(66946007)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: XzwdAtyRo03N35SjAvdw/AVcaBWQwqXAPY38dtjqkqwQ4O8Rb1IEPkbobcSELpl7Jyb+Wt7o1N7S/PQUyiklCJCFmjva2DRcwYo5U08UqvlcedIbvTMXPAucoGFelLM5Jsp1EShDz50CIAfMMKpbxCnST5XS9F/dL3JC4g84YATXT5ofMZW3lF+tbgzzUwSbKmBTicQO594cO6ptk8+PkcjqWLBb7oUZUf2xJplQTBcU993N2X01UmqWaNK+S9tfRwiZFxHqjO5JF4lwKdEmFtli47WSzZAXAj2+rx6qiWnemKkizm/cXbIa/y6FdURG6PmrGO/nHB50MnsxaD7HtFcrsWRcZN3DPPQmlUPIPcp5Ny1DfxuOaTw9XfHFmyUF323nkIMU+7+U/stg6inmUh4FYiLZcISOnP1C+Kcvwy4vhXnD3ZZAdzy0apNHLxR+b+m3xJ1YCA/LcoGvecDCW/q0ggIhRraVNFVZX1oFM5Trl0J6Pj7rLMTLjirrn0u/EZ5F1jj+mbAuliAVRtT/hhiA4kISoo0kR5KicHWwrBMwB1CVqI9ttDpaZAaANjYRLKyF1yCp2/6iVxVaClGFlgfchf5Cq9RrkTpzELBkoaqHzGZertDmrjHlNoESe52TRfKwYVTHeXRS5v6uMXgxjKGpDdeUMgNvPanLAN9TnNu48RuusR6rWVHClojtX/0I
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E831D05C3B320349B6449BF3465063EE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 250503a0-a9e8-46c9-baab-08d8600bf17b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 21:59:28.3940
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ASMgXLsgYRljXeWNh8NKV0Yms3iNBcEfQI5/7mcEueijTYCD+bveQm6K/t+XGPCrcMR6eWecGckIvDkv+Jp3ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2455
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_19:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230165
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 23, 2020, at 12:36 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Wed, Sep 23, 2020 at 9:54 AM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> Add .test_run for raw_tracepoint. Also, introduce a new feature that run=
s
>> the target program on a specific CPU. This is achieved by a new flag in
>> bpf_attr.test, cpu_plus. For compatibility, cpu_plus =3D=3D 0 means run =
the
>> program on current cpu, cpu_plus > 0 means run the program on cpu with i=
d
>> (cpu_plus - 1). This feature is needed for BPF programs that handle
>> perf_event and other percpu resources, as the program can access these
>> resource locally.
>>=20
>> Acked-by: John Fastabend <john.fastabend@gmail.com>
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> include/linux/bpf.h            |  3 ++
>> include/uapi/linux/bpf.h       |  5 ++
>> kernel/bpf/syscall.c           |  2 +-
>> kernel/trace/bpf_trace.c       |  1 +
>> net/bpf/test_run.c             | 88 ++++++++++++++++++++++++++++++++++
>> tools/include/uapi/linux/bpf.h |  5 ++
>> 6 files changed, 103 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index d7c5a6ed87e30..23758c282eb4b 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -1376,6 +1376,9 @@ int bpf_prog_test_run_tracing(struct bpf_prog *pro=
g,
>> int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
>>                                     const union bpf_attr *kattr,
>>                                     union bpf_attr __user *uattr);
>> +int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
>> +                            const union bpf_attr *kattr,
>> +                            union bpf_attr __user *uattr);
>> bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>>                    const struct bpf_prog *prog,
>>                    struct bpf_insn_access_aux *info);
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index a22812561064a..89acf41913e70 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -566,6 +566,11 @@ union bpf_attr {
>>                                                 */
>>                __aligned_u64   ctx_in;
>>                __aligned_u64   ctx_out;
>> +               __u32           cpu_plus;       /* run this program on c=
pu
>> +                                                * (cpu_plus - 1).
>> +                                                * If cpu_plus =3D=3D 0,=
 run on
>> +                                                * current cpu.
>> +                                                */
>=20
> the "_plus" part of the name is so confusing, just as off-by-one
> semantics.. Why not do what we do with BPF_PROG_ATTACH? I.e., we have
> flags field, and if the specific bit is set then we use extra field's
> value. In this case, you'd have:
>=20
> __u32 flags;
> __u32 cpu; /* naturally 0-based */
>=20
> cpu indexing will be natural without any offsets, and you'll have
> something like BPF_PROG_TEST_CPU flag, that needs to be specified.
> This will work well with backward/forward compatibility. If you need a
> special "current CPU" mode, you can achieve that by not specifying
> BPF_PROG_TEST_CPU flag, or we can designate (__u32)-1 as a special
> "current CPU" value.
>=20
> WDYT?

Yes, we can add a flag here. If there was already a flags field in
bpf_attr.test, I would have gone that way in the first place.=20

Thanks,
Song=
