Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39884205986
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 19:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733214AbgFWRls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 13:41:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27222 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387939AbgFWRlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 13:41:13 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NHexTI010489;
        Tue, 23 Jun 2020 10:40:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=aRp90P9TFAhOaKaFzC0NQFKwSoHdzNSZc8lFM9xh0Dc=;
 b=ElCv1KB8jeRm28kppK74PjwuGjG7UO3Mex4zyvu6sxKsKfL87yNlINJJt3mmOidCZ9IE
 +mwa/hyoiW1HSjyERQirAa5POsEjFofFUao95NhYxJ4fSwezBN4gmu3POvJaTQ1ecfe9
 HbEYzsGj1/SsaOReVfmb/9UdTULixliNgFE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31uk3ch4xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 10:40:58 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 10:40:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDTLtV312DcviLP/xLtXCPWbfC6jBzvUMz3yU97o/M6pv1Jt0SfVc38hQu3byYGww+Kqc3POBpy5++v+Tzrfk65OdEyxJ+8UYvld2fEkG0QEhncxvFKoQpP3bIxteaouXwXf1BYvuyUYKpOFhAAZfqTet2b37Q6SBVMgUVo11DxZRxbs0F5wGucQ/yoihVifyUqrJWBBgKH+xnxRqxTQd18XVL5I4nkEIH2h6dzAggeU/vLz78g/ovM8RUp35cbEcHMjGyMPwQ3cw2znFvLeqjMDhr57rjs4UjTWljHLEEhstNmjJK7XhU8HmSg5J+IHFMO/nyaVMFdf/VPMQRItMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRp90P9TFAhOaKaFzC0NQFKwSoHdzNSZc8lFM9xh0Dc=;
 b=af6PHf9ifWxJNd4oCFXO6BFwYFRPNGpngKov0C67ISxn53zxRzFldTf1KpGyFqliIdkMUbux+LBIFwhHUqtWeydbq3mKgo0n8Ob6L/MUrzEy2ddobsuVeVQQTIrHKbV5ZaAMYmqlKiKu3G3jHNT0+InqoD/hr9aS7glSrMkAotTfetTl4yGVj5Wg4WY0yGyvslSAXTxkLZGkdQQM9ShjVlV5y7Lrwdl1447SlY/YexrPAsRtcXHEcirXafnKcHIm8kz2XNbDgcncW1yTyRkKld8NDAyqdq9N9xZzSB7qj25neYMdtz8o/umpTChx0O4+hEQ0BaprIQZP/dO/WIs/Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRp90P9TFAhOaKaFzC0NQFKwSoHdzNSZc8lFM9xh0Dc=;
 b=gTbLBTGC37cL5zKgEIaEWwMkopXu12qzxtqeDD0rT96ync9ByEz403+tI6UQmYz5/LIYvHKuOCsosX9CkEOKF+M5CyWMYimAWnK5UOqV6BgLGNv9sVizE5Xdy8BzX8gqwXO/gdmzKAhaOgVlZv0gTBFMPZTD3/5Dk31OeJhS9EU=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3253.namprd15.prod.outlook.com (2603:10b6:a03:104::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Tue, 23 Jun
 2020 17:40:36 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 17:40:36 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next 1/3] bpf: introduce helper
 bpf_get_task_stack_trace()
Thread-Topic: [PATCH bpf-next 1/3] bpf: introduce helper
 bpf_get_task_stack_trace()
Thread-Index: AQHWSS0VOUl6AqeRSEG9pyL6IiSf06jmUOoAgAAcCQCAAAuAAA==
Date:   Tue, 23 Jun 2020 17:40:36 +0000
Message-ID: <C0EBD4AF-C9D4-41AE-9F18-57D4097B7DE2@fb.com>
References: <20200623070802.2310018-1-songliubraving@fb.com>
 <20200623070802.2310018-2-songliubraving@fb.com>
 <CAADnVQJxinR1fY69hf_rLShdbi947DjGXAH+55eZQDTtm4VBRg@mail.gmail.com>
 <FF92494E-D1EB-4B84-9D2F-8CD43FEAB164@fb.com>
In-Reply-To: <FF92494E-D1EB-4B84-9D2F-8CD43FEAB164@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:d062]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 42ead549-039a-46d5-e6ba-08d8179c89d7
x-ms-traffictypediagnostic: BYAPR15MB3253:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB32538EF7DD4F7B8AB1F2BACBB3940@BYAPR15MB3253.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4ykJW9mv6zBXnwfuNS/+meGgjTjkacvOCc+bA6agvop3vGFCaLPCVqUQg3JGwLfCwBV4ITdChipOhU3NLJ/7NbhsSaboBpXVEMDG82PEqlrJ+BDVzaWwabsMbk8FcoF3QQ0TnT+tISJNsey61VUEfKOgnXq/0FcNkwBUPFOTxB+W1vDcNVgAZPrGnCfDQh2lPLKfeCMoGQ34Lr+j7KlHhqAMnqZnDaZKhsm9lBEho/nnSmiw0GvHGfs/nDlH0LB9OLgoScFMJhMPcO1iJfuHTyRh8icExEliFg+I3BGN1wLAEhQHUMGMqz6LgUbVWtx2teFiJEkYmcxdxZ5PzvfzbQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(396003)(376002)(39860400002)(366004)(86362001)(2616005)(33656002)(6486002)(8936002)(66946007)(478600001)(4326008)(66476007)(76116006)(66556008)(83380400001)(64756008)(66446008)(2906002)(6512007)(5660300002)(316002)(36756003)(186003)(6506007)(53546011)(54906003)(8676002)(6916009)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: kiROEZAp9s7LO5xODPDfcARnhqddMvwprMN2QRLJs49EdoCATipVduzNQ1zbIj21x6/3MzeiiTflVC/HTAbBYXHbUebQHo1tVxWdV2kzTrn4+huXXehSO7A3Wc3RZrx5X9PurMRBDyOWYY3sJpfkfAMZTQIX+5d1ppZWqLLL4ykchXBt2X0HsT/x9csToPzgOLEvYAthxGAonzc0spuUY5pcIZl8PnT6DRE3yWMh+NXtPEU+HGXr0UfrDtll2NWrw+2JtOI+iUgXbK0kFZFYoQDVgDo2wZ+Zw/oFzOq5kFXjuzqCphazoCdIqdrOrMcGLvuiBvJ7UkEyAeqg2Q02y66wfXMrtvQetJeGlsMFXxjsPATvg2lpTsTRNd1b0I0l7imxGD8OHVaPBu3DWUiKonbygxaUMBYjtz181qbazZE1HGrMF96pxuEfmiYMDWkCIO3M6OyX5seYnUBAQ63v/gE0q9nrYLLguLVBN7O8vuP7seu4JqNXLFigyoRyIB+iAQ49gu9VE2WIXezr846hUQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <283A8D3DB651054FB9DDA8049EE3901F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 42ead549-039a-46d5-e6ba-08d8179c89d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 17:40:36.7120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MSJxjwHRTwrVY9wuvdvuZMUuVp7xUEl2SmhM9p57s90VcMxqDaIQt4ezCjn7OMwnHQ48kEoglmXYXrva9OBgsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3253
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_11:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 suspectscore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 adultscore=0 spamscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006120000 definitions=main-2006230124
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 23, 2020, at 9:59 AM, Song Liu <songliubraving@fb.com> wrote:
>=20
>=20
>=20
>> On Jun 23, 2020, at 8:19 AM, Alexei Starovoitov <alexei.starovoitov@gmai=
l.com> wrote:
>>=20
>> On Tue, Jun 23, 2020 at 12:08 AM Song Liu <songliubraving@fb.com> wrote:
>>>=20
>=20
> [...]
>=20
>>>=20
>>> +BPF_CALL_3(bpf_get_task_stack_trace, struct task_struct *, task,
>>> +          void *, entries, u32, size)
>>> +{
>>> +       return stack_trace_save_tsk(task, (unsigned long *)entries, siz=
e, 0);
>>> +}
>>> +
>>> +static int bpf_get_task_stack_trace_btf_ids[5];
>>> +static const struct bpf_func_proto bpf_get_task_stack_trace_proto =3D =
{
>>> +       .func           =3D bpf_get_task_stack_trace,
>>> +       .gpl_only       =3D true,
>>=20
>> why?
>=20
> Actually, I am not sure when we should use gpl_only =3D true.=20
>=20
>>=20
>>> +       .ret_type       =3D RET_INTEGER,
>>> +       .arg1_type      =3D ARG_PTR_TO_BTF_ID,
>>> +       .arg2_type      =3D ARG_PTR_TO_MEM,
>>> +       .arg3_type      =3D ARG_CONST_SIZE_OR_ZERO,
>>=20
>> OR_ZERO ? why?
>=20
> Will fix.=20
>=20
>>=20
>>> +       .btf_id         =3D bpf_get_task_stack_trace_btf_ids,
>>> +};
>>> +
>>> static const struct bpf_func_proto *
>>> raw_tp_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog =
*prog)
>>> {
>>> @@ -1521,6 +1538,10 @@ tracing_prog_func_proto(enum bpf_func_id func_id=
, const struct bpf_prog *prog)
>>>               return prog->expected_attach_type =3D=3D BPF_TRACE_ITER ?
>>>                      &bpf_seq_write_proto :
>>>                      NULL;
>>> +       case BPF_FUNC_get_task_stack_trace:
>>> +               return prog->expected_attach_type =3D=3D BPF_TRACE_ITER=
 ?
>>> +                       &bpf_get_task_stack_trace_proto :
>>=20
>> why limit to iter only?
>=20
> I guess it is also useful for other types. Maybe move to bpf_tracing_func=
_proto()?
>=20
>>=20
>>> + *
>>> + * int bpf_get_task_stack_trace(struct task_struct *task, void *entrie=
s, u32 size)
>>> + *     Description
>>> + *             Save a task stack trace into array *entries*. This is a=
 wrapper
>>> + *             over stack_trace_save_tsk().
>>=20
>> size is not documented and looks wrong.
>> the verifier checks it in bytes, but it's consumed as number of u32s.
>=20
> I am not 100% sure, but verifier seems check it correctly. And I think it=
 is consumed
> as u64s?

I was wrong. Verifier checks as bytes. Will fix.=20

Song=
