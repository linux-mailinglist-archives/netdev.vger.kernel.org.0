Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18BE23CEB6
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 20:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgHES7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 14:59:01 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41294 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728064AbgHES4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 14:56:52 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 075IjXjg029042;
        Wed, 5 Aug 2020 11:56:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ojb23IAOxxguz5q50N9JbbSVUEF40wGjJC4zW4kFLSA=;
 b=rln/DElrr+mefMOI1u6BrARF/KqeOFxWpCtSy1rVkkPncJHEFTMhOAeevuxf/9fhwk7O
 PNUTRGv0ajJLTjriFWWcV4BfI34W7eSlbM+u8TpkI056Ki6brKzxPAoQkDJreP/4O3t8
 OVLSFgmCPtg8tR2v3kJ+lP4s0twh0IyQ+Lk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32qy1rh9cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 05 Aug 2020 11:56:28 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 5 Aug 2020 11:56:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=InynK4W9GRqZ7tPRCDw6xKUMbJOkzE90XgmXFZ//Z5s9lHMvuV9Ppk3glqdRJOlEXUCEOnQYpqw7+dcbKmPXEVq6UgMPkV4Hv1C9h4oe/K1xH9u5o20etaZC2MK/i4WgfxPzG+7mjRhJScaxW9YPkDd1xijb2ZtUp3G/58zWMp58+33qNpUHpajTouf68kE3+p+sJtXL+JpRx/t42da53tgCpA7H2WIX00ug55/fzEB3u08vM3A3zKRUVOcQ+E9Syk0MolMmVLVK9Ft+MFknY/gghPJ56jaWBGDCX9z2hz9+z3robAq5rIbRq7emVAiyahP3WS8nByQ55KExj3qf4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ojb23IAOxxguz5q50N9JbbSVUEF40wGjJC4zW4kFLSA=;
 b=TVwQHy9wM7xGtB6xBd/2YvKwh4GA4raXOUedw2wKtfeeTGaLUSm9n9vcwgnW88PMwJZkOmrEt4GkND/w9FXkTbl5BxRMQ/b5VpypMswB3l6gLH8emA9J+9QsDwPfvY0ZIPqmuWdFWGvLeW3RMqW9eW2Tp6UfBqPe8MwdF9ueRpE0rxPZ01mGGKRwMraBMmy/Ik5pRJubPBkVOBDBCHJChUYpVAMaC8xLcfyKMADjHS8HO7j7r8V7tx3p/ICnsYL1HfEXnnOl39bDohQWeR5PabACFU3Cq2sLdFJqkeD39DRwnlJLSncZoQaVQPxdyTbJ9aQdAtCimimDoAAoGzp4+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ojb23IAOxxguz5q50N9JbbSVUEF40wGjJC4zW4kFLSA=;
 b=BMUZmWWONF2SC623o3guEripXUNssHpmPqXnFneMrizZWnlui+3T2bJbxXYFcPFrnXwZ56IBgXuv2ji4NSZqNpziVw9bZijlPA1/Mt8vb0ToL8jP3/W2IGhjP3v7s4SuN1YfCCX5IYK1HgiJOOEOTJzB8zCMbj5fOL1TricK0vo=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2885.namprd15.prod.outlook.com (2603:10b6:a03:f5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.18; Wed, 5 Aug
 2020 18:56:26 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3239.023; Wed, 5 Aug 2020
 18:56:26 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "john fastabend" <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        Daniel Xu <dlxu@fb.com>
Subject: Re: [PATCH bpf-next 5/5] selftests/bpf: add benchmark for uprobe vs.
 user_prog
Thread-Topic: [PATCH bpf-next 5/5] selftests/bpf: add benchmark for uprobe vs.
 user_prog
Thread-Index: AQHWZ+C4z/mDZUCS20yCUvtKcPb5ZakloXcAgAAxPICAAAZdgIACmfGAgABTZwCAADDfgIAA0VOAgAAb4IA=
Date:   Wed, 5 Aug 2020 18:56:26 +0000
Message-ID: <31754A5F-AD12-44D2-B80A-36638684C2CE@fb.com>
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-6-songliubraving@fb.com>
 <CAEf4BzaP4TGF7kcmZRAKsy=oWPpFA6sUGFkctpGz-fPp+YuSOQ@mail.gmail.com>
 <DDCD362E-21D3-46BF-90A6-8F3221CBB54E@fb.com>
 <CAEf4BzY5RYMM6w8wn3qEB3AsuKWv-TMaD5NVFj=YqbCW4DLjqA@mail.gmail.com>
 <7384B583-EE19-4045-AC72-B6FE87C187DD@fb.com>
 <CAEf4BzaiJnCu14AWougmxH80msGdOp4S8ZNmAiexMmtwUM_2Xg@mail.gmail.com>
 <AF9D0E8C-0AA5-4BE4-90F4-946FABAB63FD@fb.com>
 <20200805171639.tsqjmifd7eb3htou@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200805171639.tsqjmifd7eb3htou@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:8f7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7629e68-7da8-4f8b-cf77-08d839714158
x-ms-traffictypediagnostic: BYAPR15MB2885:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2885364AA536B1D7920A13EFB34B0@BYAPR15MB2885.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DlGJ+UMAoMhCxFlhHaCXxDrQwzutA+VenzjpbMoeVIEsAVVOD/ZmpFr4BxLsbx/yALe2GTNAQLMI+I36jNRkn86MH8EFJurKaIepySBmAUq3r7hTnHa5EkkPzxp8WlRDbBrpFa2tXgyot25WhNuiZcGQeYQmxZ9k3imMeau2/ArQL74c1XDlFPzlUq3v5DBCr9P/avDvER+NWG+QK7HkZUfYLcY3QfaWzQZQ5mNKfPGDwFlCZdIMlcsXoBfCFmRq3ykszrAcL5AoWLyMJW8rPPL034hSZHFc/8aI1+u8Wnb8yqTJ/mCdcgFom+xeQ+Q5aJnUo5F4Qkv1xEi15dbqXw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(136003)(346002)(366004)(39860400002)(376002)(66446008)(66556008)(64756008)(478600001)(316002)(33656002)(8676002)(2906002)(83380400001)(6512007)(7416002)(54906003)(4326008)(6506007)(53546011)(71200400001)(86362001)(8936002)(6486002)(36756003)(6916009)(66946007)(2616005)(76116006)(5660300002)(66476007)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: LgxVFci70w2XkcoXeIe4oCiTxDMJTeHr1DhEXztGfuPBlihrArcEkhd7dEzZoIoRSXu23LeQt7F+HOKmGSjGiiwWKF/2zgkeM3ZRyWPAz/0yF7EdmnKKx5HczmsbSRWPiZuK/U9KviMEwYUJf+DuBeyAihNoX6Wp2+zhAQZy2jtLyBmKAoVJPRrHH6sDZ9UkuM82f2nf8hXCP1kyaGEy2mQLcUtTqfK7udohpmiVijE135+SUWtnElHslG9Ojb8nHFXvH4GCV6X6zLeFFHFIQYBHYk5jyb89wav1POTMxLNTBGVtNuyZQW9zGHpUjPC8EPN88HcI76OUFETAg199LaBbZz7fXHgYzabK7O9EdYmX8GRcl+0HLVoPz/KNx8nD4uZ7auI7cjbTonzPp/XH/yuogF0DBGkb1ipNwCbFaR0n0u5/fAe2CatLNd1xjMZSyNs93iJrbO6Fq6lFSZ6h43/OPOqvBEnzZcRk53WJVgZqvXuuVuWY9d+UJc/FMaKSIzgGhHyt1EBoW9dA3qNsbRTgpJtqE5/0Ye80JMmBMbKLXNCv45f6+/DFOIbquWW28vtbGih+MpTBD7HhBlRlupBC6os6qoVhKOsFeok3dV5cbib9fcbaoYibNHXqHdHG7AyBiQz+tZCTQ8dtOZiL8WJl8MSGU2ykWBGnVYFucTU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D68AD05BCA122847AE9571BD170332E7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7629e68-7da8-4f8b-cf77-08d839714158
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2020 18:56:26.2142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KjHBzitC0aO/X4BhUpUjXG4x69PZnfE7GR/8blbuvysutfX528ixqpPH3UAOKdOFTRWypzIdOfZM5BH4DZrQTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2885
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-05_14:2020-08-03,2020-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008050147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 5, 2020, at 10:16 AM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
> On Wed, Aug 05, 2020 at 04:47:30AM +0000, Song Liu wrote:
>>=20
>> Being able to trigger BPF program on a different CPU could enable many
>> use cases and optimizations. The use case I am looking at is to access
>> perf_event and percpu maps on the target CPU. For example:
>> 	0. trigger the program
>> 	1. read perf_event on cpu x;
>> 	2. (optional) check which process is running on cpu x;
>> 	3. add perf_event value to percpu map(s) on cpu x.=20
>=20
> If the whole thing is about doing the above then I don't understand why n=
ew
> prog type is needed.

I was under the (probably wrong) impression that adding prog type is not
that big a deal.=20

> Can prog_test_run support existing BPF_PROG_TYPE_KPROBE?

I haven't looked into all the details, but I bet this is possible.

> "enable many use cases" sounds vague. I don't think folks reading
> the patches can guess those "use cases".
> "Testing existing kprobe bpf progs" would sound more convincing to me.
> If the test_run framework can be extended to trigger kprobe with correct =
pt_regs.
> As part of it test_run would trigger on a given cpu with $ip pointing
> to some test fuction in test_run.c. For local test_run the stack trace
> would include bpf syscall chain. For IPI the stack trace would include
> the corresponding kernel pieces where top is our special test function.
> Sort of like pseudo kprobe where there is no actual kprobe logic,
> since kprobe prog doesn't care about mechanism. It needs correct
> pt_regs only as input context.
> The kprobe prog output (return value) has special meaning though,
> so may be kprobe prog type is not a good fit.
> Something like fentry/fexit may be better, since verifier check_return_co=
de()
> enforces 'return 0'. So their return value is effectively "void".
> Then prog_test_run would need to gain an ability to trigger
> fentry/fexit prog on a given cpu.

Maybe we add a new attach type for BPF_PROG_TYPE_TRACING, which is in=20
parallel with BPF_TRACE_FENTRY and BPF_TRACE_EXIT? Say BPF_TRACE_USER?=20
(Just realized I like this name :-D, it matches USDT...). Then we can=20
enable test_run for most (if not all) tracing programs, including
fentry/fexit.=20

Does this sound like a good plan?

Thanks,
Song



