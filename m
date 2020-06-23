Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AC5205817
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 18:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732909AbgFWQ7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 12:59:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19626 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728916AbgFWQ7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 12:59:44 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NGovxQ032296;
        Tue, 23 Jun 2020 09:59:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=+8G6DIOIPfOUl8GfXxhobUtXqXWObNu4M2i4VEFb5KU=;
 b=IrXlD6cdh49uVSXNe9Rw1GOGU8LzxcO+3J3S9T2bRlDF1t61QUHA+RKLk/bNjXLHswga
 xf2KWPqdDrDTOHtsVQvVIFasmKfTldyPCmUDWbnoL65UUu6AWzzuCOof8Mp9H+79VGlq
 D+fpRr+SGNj+/Quvi4nPLyJxnaQp9kd7qGg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31uk3cgwn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 09:59:29 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 09:59:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bv4Xt7z6eoIPUnqGvnL6B0N+6Dr1qSVZo7U0Wvj2zg19DmAm0MoJ/g1/LqRsJb6HY7MbFLHWxIn4FAXN/CXbz9NUDG5MBGnk2pf1LV7r5IamEqFFfxjsjFgOkboEAxjWnnOULBtKLroY5npc+Ny5ey3zbyK73nh/9eQlLMeN2EqM9NZ5yVQob+JVZulIelS6f8bOhaLSiUjfT/di/gJLArfYcZVflTrsYCcJ7uEzA8RQs8Q4lqKrgjAJ5mF2Exupw3zPDLc7tCoFsvLmKwpwnmKbgg0ioLm1V+dm6XF+ckz0qOm/GNcfMtL3PhSPN+OyU33c940+Gbd8YfyHYsEgHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8G6DIOIPfOUl8GfXxhobUtXqXWObNu4M2i4VEFb5KU=;
 b=KeZLjgJO+DKUfSCblBEeLbr2NToxAxPt94sf66QpIyaWJYYDDiSOE106o7qXuR8pY7ndSeK53n1X/UZglsrgQljiTNzKdyHNCa+td7DhGJ4oX2hjmkDy9ugFz2TeOIU3xaBsKPir6DpTEdZ46R5OKG4QaniEjdPSR4WoEqxWZeeDp/9oediRh1hmVuXgOSIDpCvKuT4Zon9iIdcm8A+9FfQI7xWNEIf8lGHHrZAOipOchB2qtSNQ821YJlvqXfdStFuw46W7HmHrFUgYZIlmfYeLNgGFsWYJOKBZ3lvY2VJg7dqTsTfTvyhf+KAm6KOXbjDibUOk9gUdwgtJndPXiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8G6DIOIPfOUl8GfXxhobUtXqXWObNu4M2i4VEFb5KU=;
 b=F15hpho/TFX288DgrnbbyQf/S1ehM6BtoZLzr0UssrUUcLMgkQl4P5ecYgNw7+esGFHmm1krbgPsSEdYPZIzdHKfWNdpotwRKgQbnmOValUP2zreCsCISFiYmTAdqhmjBS4qAHG4SlgkrMLs9QxLaOWRa3Ys3gMdVm0lMJtBWgY=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3461.namprd15.prod.outlook.com (2603:10b6:a03:109::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Tue, 23 Jun
 2020 16:59:27 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 16:59:27 +0000
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
Thread-Index: AQHWSS0VOUl6AqeRSEG9pyL6IiSf06jmUOoAgAAcCQA=
Date:   Tue, 23 Jun 2020 16:59:27 +0000
Message-ID: <FF92494E-D1EB-4B84-9D2F-8CD43FEAB164@fb.com>
References: <20200623070802.2310018-1-songliubraving@fb.com>
 <20200623070802.2310018-2-songliubraving@fb.com>
 <CAADnVQJxinR1fY69hf_rLShdbi947DjGXAH+55eZQDTtm4VBRg@mail.gmail.com>
In-Reply-To: <CAADnVQJxinR1fY69hf_rLShdbi947DjGXAH+55eZQDTtm4VBRg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:d062]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f633d802-9433-4ac1-9058-08d81796c9f2
x-ms-traffictypediagnostic: BYAPR15MB3461:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3461444769DC07610301A5E3B3940@BYAPR15MB3461.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w4naRFQltOvYjPALr+jNWncG0eMP7FFD0grgHIjJEKO53IXqVdKCO3kryjE4ZarYImm8Cyws1iP27Z5d7y0GN1tM2Cjwn6zSn1FEgyFgrI+6mLd/2JtYSuv+8HoIEBYkCwtSgQf426z+tpqNXYwo1V29kh4Aj3203U8/ow8kvK6ARj3CMoNQFsDWJStHigBZvNKl454UBTTH4SExoB8LFs8zMUF45Y8d+IgI/2c2N0uMHhf5Msljdz8RvB8aFmjp9nLtqHZMJIMJZRQqTvymbPXoFyiIldcFo/xuX7LCzWoyQbJHCOmsQaeeGxmfOVGxMmTKj7X2BI+O3XIPxDwGxg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(346002)(39860400002)(396003)(376002)(366004)(316002)(4326008)(478600001)(6512007)(83380400001)(5660300002)(2906002)(86362001)(2616005)(36756003)(54906003)(6486002)(53546011)(6506007)(71200400001)(186003)(6916009)(33656002)(66946007)(66476007)(76116006)(8936002)(8676002)(66556008)(66446008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: cquLbCDM/G/mbZlLAPZiCRFDWEf0Wgnf8BZhw3PW/FimgKiEYtcQTK3FzObFlJFMht/YqrPmRNh63XjRemA3m/4SQyVO+Km3eIVFU3tJnPqEXkjh/IE3I+KSlNseqD4jTsISi1OIU669kLT/6uRUCJgUmABUPKQ3IxjFuOvKzI9QFNhJTXX8HF3Kcs7Nwch0ng1lhisZSk8InP5V+scU5wc9zoKybblbhyOXMbnkbGOuDfjiOWgKU/nruU1faigP2t8UM/bGFQjC7W3tkAt+dVohsoLU2Sc2rpSZfn61L1CW4gnwC0r945LJ2NSTQJprMwwP4YTgUlHCh6xqxc/4Sp8aqmHUNIcvmazvs9IZ8qeuOLFO0kpTdYAG8ZM00CWguzVeAnxNpbKhNAuGscAZjJVeM7iOXNdL5raNxBRPJE+WxFVOybd5QrO6lRJnuf1Ok4ggsF7fmxQog9Ximh3CNLTo6DoGjpG80SyYswplVzFyuzxurTQB2qm+Ipjxhtx/gdXb8tBLRlgDBoWjqNhFFQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <086A530C4809BF4AAEBE21B729C5D505@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f633d802-9433-4ac1-9058-08d81796c9f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 16:59:27.1736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0JmHSZK1L43D1/8Bn78SPtZyU/JkV9RKdLck6FcIhPvo8zlUEwXXaAPg2L108SxppbuZu9KcE8GHczJ/ym9xgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3461
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_11:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 suspectscore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 adultscore=0 spamscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006120000 definitions=main-2006230122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 23, 2020, at 8:19 AM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
> On Tue, Jun 23, 2020 at 12:08 AM Song Liu <songliubraving@fb.com> wrote:
>>=20

[...]

>>=20
>> +BPF_CALL_3(bpf_get_task_stack_trace, struct task_struct *, task,
>> +          void *, entries, u32, size)
>> +{
>> +       return stack_trace_save_tsk(task, (unsigned long *)entries, size=
, 0);
>> +}
>> +
>> +static int bpf_get_task_stack_trace_btf_ids[5];
>> +static const struct bpf_func_proto bpf_get_task_stack_trace_proto =3D {
>> +       .func           =3D bpf_get_task_stack_trace,
>> +       .gpl_only       =3D true,
>=20
> why?

Actually, I am not sure when we should use gpl_only =3D true.=20

>=20
>> +       .ret_type       =3D RET_INTEGER,
>> +       .arg1_type      =3D ARG_PTR_TO_BTF_ID,
>> +       .arg2_type      =3D ARG_PTR_TO_MEM,
>> +       .arg3_type      =3D ARG_CONST_SIZE_OR_ZERO,
>=20
> OR_ZERO ? why?

Will fix.=20

>=20
>> +       .btf_id         =3D bpf_get_task_stack_trace_btf_ids,
>> +};
>> +
>> static const struct bpf_func_proto *
>> raw_tp_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *=
prog)
>> {
>> @@ -1521,6 +1538,10 @@ tracing_prog_func_proto(enum bpf_func_id func_id,=
 const struct bpf_prog *prog)
>>                return prog->expected_attach_type =3D=3D BPF_TRACE_ITER ?
>>                       &bpf_seq_write_proto :
>>                       NULL;
>> +       case BPF_FUNC_get_task_stack_trace:
>> +               return prog->expected_attach_type =3D=3D BPF_TRACE_ITER =
?
>> +                       &bpf_get_task_stack_trace_proto :
>=20
> why limit to iter only?

I guess it is also useful for other types. Maybe move to bpf_tracing_func_p=
roto()?

>=20
>> + *
>> + * int bpf_get_task_stack_trace(struct task_struct *task, void *entries=
, u32 size)
>> + *     Description
>> + *             Save a task stack trace into array *entries*. This is a =
wrapper
>> + *             over stack_trace_save_tsk().
>=20
> size is not documented and looks wrong.
> the verifier checks it in bytes, but it's consumed as number of u32s.

I am not 100% sure, but verifier seems check it correctly. And I think it i=
s consumed
as u64s?

Thanks,
Song

