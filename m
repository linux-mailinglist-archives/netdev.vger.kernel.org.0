Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C9620586A
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 19:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733084AbgFWRUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 13:20:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2366 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732408AbgFWRUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 13:20:24 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NHK0Pg010432;
        Tue, 23 Jun 2020 10:20:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=E5BQl1FtVVKxU+yv7mPMHISIHlFeAPJxTyruufUR+uI=;
 b=m85XEe7HFZhVDsoFwO06FMsfyKcLsQJwKP6xXBDVcHjVLwGyh73RzHnNlTmMVvTegX+S
 WNuYcz2wriDK8C621tFPnQ5tULeW58/JmUTpQMuZjhrEkviR9O7PjjGrWba9nHG+D1b0
 IAlCoJKvZbWmsFSro3w5d/GvcHK5JPBSIwY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31uk1qs2f4-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 10:20:10 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 10:20:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WnnIAWOHjvS1ny7t/aJ39ad99dU4ghuGQawxk5hjxYm1oxSiwFVctMzXc+KSOoLJU7Za1IjdRt2nmDYiRo/whwxb1kFlc59Chjq2kzEpY4XPKZFg7xN7lCDR92aYNC8vtO6iKuAjvdjPzLBvA172Fz8RIXmOrbzjnlKiJ4LFI6QBHoPyPiXWjVXiIsWyls2WaOdlRKkViXr7aKDv+9+PSTuhGx2JG1pf8R2Mt7+0fTeQfnxlCQ4pnX3hhmk6x3A+r/jDmct0MbKXOPSyZbpQ4GdCM/WdkVOIpW/IbQwqfpwUP1SeNgDA2FFIXDtepCMKCf5aPela2GcN1jUfwTZMOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E5BQl1FtVVKxU+yv7mPMHISIHlFeAPJxTyruufUR+uI=;
 b=EcxzBCx3ANrCIVCxOVfWfdZk4IpTXhq5TF/GVSUL39bgSsrVpImWc3sWdTQgqgWIZ0/bQNOfc6ov/1ANFJSi2xTRgVQ1Ny29zck+t8QXVz/p11G+LxRa9kQ1PF1PJLDqtLFvi6vypzPbtTbnwIrRMogkSuBOh76WeDqYLWRTpfeuRmHASzal/m0efgGkAFfgbIYcfzczL3uaft3cjHaIx5/bhdPEgoxuTLWEzm+q3qH12Xmg+Uu5wSuUB7AXB4PPG9p/q23QCps2TVCvoJdqbKE2Zx0MyKTO7pOAE6/9qjf6tOX432ioHKw1DhVp/+ieXEuCvunS5MHVS6C3U6Rfgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E5BQl1FtVVKxU+yv7mPMHISIHlFeAPJxTyruufUR+uI=;
 b=hx3T3BZftvKMEPYdR7586EL0hPALjwEVnW3cbeg0v4WiwadNYAHX1l6y/oiQzU7sB2ZEgWaPNujkxjjITwrYLUNVdGFdOeGgBOBFcWXD/JeHsaP6BdXSB4OlTV1TonvWjSOwXxBVG1vSs2fXtfShxdQNhJixGcVwPWzY2kRb7+I=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2376.namprd15.prod.outlook.com (2603:10b6:a02:8c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.24; Tue, 23 Jun
 2020 17:19:59 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 17:19:59 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next 1/3] bpf: introduce helper
 bpf_get_task_stack_trace()
Thread-Topic: [PATCH bpf-next 1/3] bpf: introduce helper
 bpf_get_task_stack_trace()
Thread-Index: AQHWSS0VOUl6AqeRSEG9pyL6IiSf06jmUeUAgAAgygA=
Date:   Tue, 23 Jun 2020 17:19:59 +0000
Message-ID: <A03ACC17-280E-4ED6-AFC2-6D1321392093@fb.com>
References: <20200623070802.2310018-1-songliubraving@fb.com>
 <20200623070802.2310018-2-songliubraving@fb.com>
 <a50decc5-df68-0b6d-3449-41c5fb07330a@iogearbox.net>
In-Reply-To: <a50decc5-df68-0b6d-3449-41c5fb07330a@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:d062]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d76d6a66-1c43-422b-6948-08d81799a887
x-ms-traffictypediagnostic: BYAPR15MB2376:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB23761A2DAAA85F92DE9915F0B3940@BYAPR15MB2376.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: omA+cJw2TH7P3KRlyeJRTO5Ma7cXrYaU8wbUdVKFj1cPrvBBZ6QSP2HOEEnyY764hfRYGvx444Jgkovl13L5uSG1t7Hpz2+GlAPvWnBZSQnUV2GdyyxHTkPe+0UY0dicpx0kIKl47i/RqUWUQGLhjAYC/RBFoZ3oDQKbfrGQuD/8mNqQBDyR/C0g61EZTFzkd8YGDd6kSN8lgCCPsww9ZfQEEBrmg8EozkcYhuUBKHJql2WtedSmPzbhlTv29UC8sbi+AoIyVlx9Kpa2KfwzZa8nzZeh8THZKDhQZybQ5BQtqcGGKHM0+vZH08PU/w44
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39860400002)(396003)(346002)(376002)(366004)(478600001)(186003)(5660300002)(36756003)(8936002)(83380400001)(8676002)(2616005)(316002)(2906002)(6512007)(4326008)(33656002)(6506007)(76116006)(53546011)(66476007)(66556008)(64756008)(66446008)(66946007)(54906003)(6486002)(6916009)(71200400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: GK6sJuRLNt3CvExSBrQj2wfKRbIJwh6cuociFTRkgvbRXLaNcuiVye4wOnkXEy0H3QnAaSKGW19ppBQQdQIY2CXp/0HVhfdxXHw5XXo4mXwc7mknZSQWSN+884FBs0g7DZyAf3WmURoZggvsVxcxdHWoHJglpZJoywJnavDQiVa+LawRFOdUFn6JpB7VufMwSXN3VxxmfxGS9FPmAWrb+LhD+y4pUunnvhJLm8jpmGSyhICJKrY2UcoiZaVZ1R0EiJydJ9h5KwSg44HowDKFKugWxUZCHriojPc5FWig+R33CRbzSS3SfqVtxb/1mo1xa/aEFqxmB+M1pi/pSI/thDp2quONmCRcj49euVckDh8rMjeREKrrUgCyiCupCGULsRHh34DHTWrf/p6LIR4YFU1GouA0hRaBn7M9vx0o/hpTOMH2uLHDyrLT+/GXTjKG/5Cw2rsew8zcsIj8vKG+O+4fmRxEBa4qHHlW/QkMDJECqG9NgZqz4XypRmfv3hPqSqpE9/wwAScAQHTeFQbEgg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21DF1E83E8ACAD47889B54C65F10225A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d76d6a66-1c43-422b-6948-08d81799a887
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 17:19:59.5858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cZEmo6W50qIx10JDUZn4x1e5D4IqbNum3lmkaRvqvcUK5to/L0dLSRJeB1T6VzSmt3BR4suetkQB3lpqWXr9lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2376
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_11:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 adultscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006120000 definitions=main-2006230123
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 23, 2020, at 8:22 AM, Daniel Borkmann <daniel@iogearbox.net> wrote=
:
>=20
> On 6/23/20 9:08 AM, Song Liu wrote:
>> This helper can be used with bpf_iter__task to dump all /proc/*/stack to
>> a seq_file.
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>>  include/uapi/linux/bpf.h       | 10 +++++++++-
>>  kernel/trace/bpf_trace.c       | 21 +++++++++++++++++++++
>>  scripts/bpf_helpers_doc.py     |  2 ++
>>  tools/include/uapi/linux/bpf.h | 10 +++++++++-
>>  4 files changed, 41 insertions(+), 2 deletions(-)
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 19684813faaed..a30416b822fe3 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -3252,6 +3252,13 @@ union bpf_attr {
>>   * 		case of **BPF_CSUM_LEVEL_QUERY**, the current skb->csum_level
>>   * 		is returned or the error code -EACCES in case the skb is not
>>   * 		subject to CHECKSUM_UNNECESSARY.
>> + *
>> + * int bpf_get_task_stack_trace(struct task_struct *task, void *entries=
, u32 size)
>> + *	Description
>> + *		Save a task stack trace into array *entries*. This is a wrapper
>> + *		over stack_trace_save_tsk().
>> + *	Return
>> + *		Number of trace entries stored.
>>   */
>>  #define __BPF_FUNC_MAPPER(FN)		\
>>  	FN(unspec),			\
>> @@ -3389,7 +3396,8 @@ union bpf_attr {
>>  	FN(ringbuf_submit),		\
>>  	FN(ringbuf_discard),		\
>>  	FN(ringbuf_query),		\
>> -	FN(csum_level),
>> +	FN(csum_level),			\
>> +	FN(get_task_stack_trace),
>>  /* integer value in 'imm' field of BPF_CALL instruction selects which h=
elper
>>   * function eBPF program intends to call
>> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
>> index e729c9e587a07..2c13bcb5c2bce 100644
>> --- a/kernel/trace/bpf_trace.c
>> +++ b/kernel/trace/bpf_trace.c
>> @@ -1488,6 +1488,23 @@ static const struct bpf_func_proto bpf_get_stack_=
proto_raw_tp =3D {
>>  	.arg4_type	=3D ARG_ANYTHING,
>>  };
>> +BPF_CALL_3(bpf_get_task_stack_trace, struct task_struct *, task,
>> +	   void *, entries, u32, size)
>> +{
>> +	return stack_trace_save_tsk(task, (unsigned long *)entries, size, 0);
>=20
> nit: cast not needed.

Will fix.=20

>=20
>> +}
>> +
>> +static int bpf_get_task_stack_trace_btf_ids[5];
>> +static const struct bpf_func_proto bpf_get_task_stack_trace_proto =3D {
>> +	.func		=3D bpf_get_task_stack_trace,
>> +	.gpl_only	=3D true,
>> +	.ret_type	=3D RET_INTEGER,
>> +	.arg1_type	=3D ARG_PTR_TO_BTF_ID,
>> +	.arg2_type	=3D ARG_PTR_TO_MEM,
>> +	.arg3_type	=3D ARG_CONST_SIZE_OR_ZERO,
>=20
> Is there a use-case to pass in entries =3D=3D NULL + size =3D=3D 0?

Not really. Will fix.=20


>=20
>> +	.btf_id		=3D bpf_get_task_stack_trace_btf_ids,
>> +};
>> +

