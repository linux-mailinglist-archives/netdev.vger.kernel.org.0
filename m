Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB22F20BCAF
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgFZWiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:38:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21608 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725909AbgFZWiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 18:38:19 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QMaWTc003324;
        Fri, 26 Jun 2020 15:38:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4MxB7Q1uYISQ6Q1XmXDYa03zo9dgcqVTKSQH8eZD8Bo=;
 b=Sn7IT3LHeT6BJGrYcdOusy1oprc4jQ3mEBmQseGJAeqqE419JIrTt5vdBHuSQCXzrWtX
 ZEeEqp0DiK63yGgWMyoVn+CqH/Uf8DrxT+jH3QwRK3j6D8DxdwmntD34TbRF7wIBy7G/
 bH83jep16Dx982LZECJm2pQ6l9JDwS40I5I= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31w3w2nhh8-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 26 Jun 2020 15:38:02 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 15:37:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQqEGQVVdFemwhiqkd9f/rbsgblKhEr1HrvI2Ej9EY7IBp+fQ3lD2FVycX0IAUSJmYpmhFZFYHa7JiKEBWJOrJaTmBtdQfDD9m0oRDTsJd65CQbkGE4kkxN3rIa6bk9fTnWWLKVd4GJxMHnaudlgj1hEAvModJYveqyY6RofgVj6W52kZKdPfspngruCQeuMYG+3RYnuAztHdMiyZAgtWd04g1YcpOJPawIW89HZwChAfSthD7+tM5DQ6VIbGF8HhiTFuTPqsMF9bepTuxA1+qti2JZEwPvL2NK0vIE2P62MQkbW2wi0LvFQJekvkSLcuxldvdbi4oqqgpucrtJVwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4MxB7Q1uYISQ6Q1XmXDYa03zo9dgcqVTKSQH8eZD8Bo=;
 b=e5TexEFk90G7pyOSCxVgdKKRDdcVkEmMB0j2eoBHteTu1CuOEvBFEgWpekAQDkUtlXxPaUtSAlxlcLaqWhmaR2ugCmBiKHIBMkMbUKBIChwjMAhJLLg2h+FqrmebM9QbSxxrrWawBVf1qpDAIgCHaTBCzSz2e+0UlUFTt5HWt4l00s+GNgv4RkeLjTA0HVmWwB6euRkgpsdRJPi5Stq22GJt8e08S8VfS+KBHhcbhXdKWcYR+QRdKGBlzZng4f3p6KytDM+cF3YmImKdFVjhE/cU2JtM79GZzeX7hFuLI0I4qlHMuBvSN71cv2a2eDVM25Du7OFj4T70X7cpqZUZLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4MxB7Q1uYISQ6Q1XmXDYa03zo9dgcqVTKSQH8eZD8Bo=;
 b=VdFdXoipZx6L4LbiMA9ivIG83k3aQITQF711avjB/0UntbE35Hea6m/CsIsLzwwgzuiXig6frbbCGSaJx3HbLSeCiRQlSReyhlzae9WZhf5y/OSgTt40VIzbYU289Ly6dZFYzhiFGZV1J2fNmJ51dB2ev50kCUCSIcnAjWVc1Hc=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2567.namprd15.prod.outlook.com (2603:10b6:a03:151::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Fri, 26 Jun
 2020 22:37:39 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3109.027; Fri, 26 Jun 2020
 22:37:39 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>
Subject: Re: [PATCH v2 bpf-next 2/4] bpf: introduce helper bpf_get_task_stak()
Thread-Topic: [PATCH v2 bpf-next 2/4] bpf: introduce helper
 bpf_get_task_stak()
Thread-Index: AQHWS06r1sTuO7iWZUmEIP/wOjIJvqjrCaUAgAB0hwA=
Date:   Fri, 26 Jun 2020 22:37:38 +0000
Message-ID: <81642975-984F-4C87-8847-D7BF51CADB03@fb.com>
References: <20200626001332.1554603-1-songliubraving@fb.com>
 <20200626001332.1554603-3-songliubraving@fb.com>
 <572bd252-2748-d776-0e7b-eca5302dba76@fb.com>
In-Reply-To: <572bd252-2748-d776-0e7b-eca5302dba76@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
x-originating-ip: [2620:10d:c090:400::5:1a00]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9bf62662-8366-4fb0-2be3-08d81a21880d
x-ms-traffictypediagnostic: BYAPR15MB2567:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2567E51D1288319C8D04477BB3930@BYAPR15MB2567.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VNznR2fBYK8kwZi9E8MBSj4j8gvPg6IFmj39kHB0BUkXl6ckzD6n1gbGIaVNy9dI8pTAmY7SdK0RYjjRhvSoHoX2p6Y/Xp0QvLXvuOGDccpZBaLcwomCfE1pH3HsiCb++EGV0LW3WDlJB53HyDYe4aQQvDkqwgsSOfif5lCxL8EBm83hbncASehFooEHAWwNMPCZ1HoglCC9Q9t47CbqLAFXaoXbW3ySdmD8ShRamaxm9cREpltv4PZSBZb7KVWHsvsjHwzRMP8OgHbtA1aBM2SP8H93XDLEQ8QvGgx2LTJL7Tu42Bdfmaf1dJNswNJ+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(346002)(396003)(366004)(376002)(39860400002)(5660300002)(86362001)(33656002)(316002)(2616005)(478600001)(8676002)(71200400001)(37006003)(6636002)(6862004)(4326008)(6512007)(2906002)(6486002)(8936002)(36756003)(64756008)(53546011)(54906003)(66946007)(66446008)(66556008)(66476007)(186003)(6506007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ztVVleqk+95/YZwZ3ftJut/G17gLwQjKC6S1t9yYqdgw+OM4oHDfbtqC3ugS28b1xbnViJRDCumxgdPRS1j8lsR7dsN9VXGWY/Onuoq9FzyXo7YUKaa+E8Ol4ELrEIcnz3UfUQK/DpTCpTDXzBO5Hff3W01fYdU8CIaW21CBHzPaCnaz1I/Wf2i3q6RuCWCZ72yZbOORjtWf137NFkEOr2RcAZL5nezAe5/UQ2kpIjr3puEBzcybRdglOGNEPHTh7V/NuFEg2hve4y8tokPXsSDqr68pPmrhIs5wpT9CX/qL/02yXTExdC4IdxsXWq5zEsPwGh8pyQ7+haC3FrfAidpMvGBJcxoyT3TngAaHXKmikzKbYb/m/ypdGmieIaWKPAzi2KxL8qF40bR7DFoccPW86z3QWCVyX3yxKDH4B2/xOaNOaXz5AF2Kl6Iscoz9JGf/9vZZBUXY1TgKfK8rEMTXWL/mcFBRY3dNYk8lCGW3Ip6jBkNOd5AO/PYbuDYgV840j7CZRb/Rn7miG2Jl/A==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E54397307E7D3548BA011CF1FACE5270@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bf62662-8366-4fb0-2be3-08d81a21880d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 22:37:38.9633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gl/8xVVr87SgtWb2JL3DcIgDcMFHPtHfU+40vSd2Gq/LGVEa+GqzAF9Qqv5HB+o10EuXlqQlRwze3xIEmxUQog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2567
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_12:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=999 cotscore=-2147483648 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260159
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 26, 2020, at 8:40 AM, Yonghong Song <yhs@fb.com> wrote:
>=20
>=20
>=20
> On 6/25/20 5:13 PM, Song Liu wrote:
>> Introduce helper bpf_get_task_stack(), which dumps stack trace of given
>> task. This is different to bpf_get_stack(), which gets stack track of
>> current task. One potential use case of bpf_get_task_stack() is to call
>> it from bpf_iter__task and dump all /proc/<pid>/stack to a seq_file.
>> bpf_get_task_stack() uses stack_trace_save_tsk() instead of
>> get_perf_callchain() for kernel stack. The benefit of this choice is tha=
t
>> stack_trace_save_tsk() doesn't require changes in arch/. The downside of
>> using stack_trace_save_tsk() is that stack_trace_save_tsk() dumps the
>> stack trace to unsigned long array. For 32-bit systems, we need to
>> translate it to u64 array.
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>=20
[...]
>> +++ b/include/uapi/linux/bpf.h
>> @@ -3252,6 +3252,38 @@ union bpf_attr {
>>   * 		case of **BPF_CSUM_LEVEL_QUERY**, the current skb->csum_level
>>   * 		is returned or the error code -EACCES in case the skb is not
>>   * 		subject to CHECKSUM_UNNECESSARY.
>> + *
>> + * int bpf_get_task_stack(struct task_struct *task, void *buf, u32 size=
, u64 flags)
>=20
> Andrii's recent patch changed the return type to 'long' to align with
> kernel u64 return type for better llvm code generation.
>=20
> Please rebase and you will see the new convention.

Will fix.=20

>=20
>> + *	Description
>>=20

[...]

>>  +static struct perf_callchain_entry *
>> +get_callchain_entry_for_task(struct task_struct *task, u32 init_nr)
>> +{
>> +	struct perf_callchain_entry *entry;
>> +	int rctx;
>> +
>> +	entry =3D get_callchain_entry(&rctx);
>> +
>> +	if (rctx =3D=3D -1)
>> +		return NULL;
>=20
> Is this needed? Should be below !entry enough?

It is needed before Peter's suggestion. After applying Peter's patch,=20
this is no longer needed.=20

Thanks,
Song


