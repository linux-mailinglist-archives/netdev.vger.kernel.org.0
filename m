Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E526242E1DA
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 21:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbhJNTOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 15:14:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58052 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232392AbhJNTOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 15:14:50 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 19EHvrm3002849;
        Thu, 14 Oct 2021 12:12:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/+DmRnkpHG3cm9ZL3xZZW+KJwNQgI4wcdwPt6NlVTJM=;
 b=C3lR2PQ7i34KfPZ6wA0RCIZbsJU8D+MeB+Yig9GmZ0MAYY5sHuClodcbfUyipdZDYVbz
 0JA4rTb5XGBLWAvo4MBYCwL4D1SSd7RuwT7QePECF70yYqCSJq/D8schuo+7stAe5R3C
 5eDOcTitUTaadxlaL8c/Q43pr1Y9f8CWIqM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3bpqjghy77-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 14 Oct 2021 12:12:44 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 14 Oct 2021 12:12:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WP9Q3mIDm2gGp0mm+U/u2uTz3Mrc8vkubDJsa9snnrChWBPRpnNO7VVkjj+s23y1yIxmy6tEGU53Ri5a3XMfg5ukr0jOketYH4dmamtJqVTjpR5j2Ws2tL4K3Ds4w28EMiEaeIJHPzZ/zz9IVsJ/msw3LxZLI9eVwrWnWJVT+GUJSYtqImWBuqk0MlIXGPjDSrWR6tPxQtVZswsJNGC/9DYr2NiR9v7rSfhpnkMiGNnw6fIJorXIqnfWRcf2M+aGWj8t3VVbTfb9NmgCoLYTL5MRueolxh7UBBk83AEgMqrOqXMTBraLI06Ph/BPs5SwAKpwuJiaQLUjW4skwzcC/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/+DmRnkpHG3cm9ZL3xZZW+KJwNQgI4wcdwPt6NlVTJM=;
 b=QgU7TOdaUkbVjLYq9WXj64HnDfYJd473Y/Ot+Sfo52uOGxLC2QB4CE9ot0/1ZaN/90EuJrzmcNmYpRfId6rtJEiN7hEwEWM/8dXsj8yZvnPnpBDiXPfEIZL9rEHYvmqmgE++VkeeFNhhnD5YQ3zYAtU7V9l4uhO83YGTp0Qbyrzq/yROvymkI5IjuvDunE6pfW9fnhwdFxVbNanBh8cGo/Q9ks5X6NbphF9BTS0LfllknGAl8IfmXldqXHPs/z/SRrCUp9P4Tkvo+pWnCZSysvZ1IjY98Cfb+kU5QMDmen4AefP7L1fGZ0f6Co0mGCGUJqEcWc/XDbvbAYRYL9mr+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5061.namprd15.prod.outlook.com (2603:10b6:806:1dc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Thu, 14 Oct
 2021 19:12:43 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 19:12:43 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 2/8] libbpf: Add typeless ksym support to
 gen_loader
Thread-Topic: [PATCH bpf-next v2 2/8] libbpf: Add typeless ksym support to
 gen_loader
Thread-Index: AQHXwASx++unaISYJEyX6u07mIr+66vStCMAgAAUrICAABYTAA==
Date:   Thu, 14 Oct 2021 19:12:43 +0000
Message-ID: <E1888EEB-5059-4CFF-AE27-E4F5DDEB7581@fb.com>
References: <20211013073348.1611155-1-memxor@gmail.com>
 <20211013073348.1611155-3-memxor@gmail.com>
 <F745CD84-E520-4DCB-B9F1-0C4F0014CBFF@fb.com>
 <20211014175341.eitbn6ujf4zjkrs7@apollo.localdomain>
In-Reply-To: <20211014175341.eitbn6ujf4zjkrs7@apollo.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 232a1c55-568b-42e1-e12f-08d98f46994e
x-ms-traffictypediagnostic: SA1PR15MB5061:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA1PR15MB5061886ED40E47F1AF858C3BB3B89@SA1PR15MB5061.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J33Nxk9M/RCc/UJD7Xl7FARzm+A56sIA06EUsiLuTrNVMk/xV/hdK2gv58Sv56yzI9nD9PBqk2TvXTEZ4Fl05msK5yf/5Os4+lM0DabY3cXF97YXwfo/iqyWgC8TnEvg8P88x8ZlDQQoRdpUlnn1EXc3jSsZ00zwvWaikASrrpYB/i6TxzIdSda9X+hn6M0r1DqcZ1pA1tlcoJ/wb/Hi9gsg5LJO1e/u43OXawz3aPzKpghCHs6j9Ljn6aXLofZOsCoexpiMfqbOpoSg23g4Dhx5M0ybnjUoUUS5QfYoD8rXKuzoij4LezNVbX/JFdsJ/YohIyeBiROy/J3YVnq9kKKZNHKhKfT+oig3mX/FD77vQ4qvPyo6e0qbzsuS3DAPRyP9h2L0s6KSzZVOe+OflWy/+usXUBDgwEJ1o84Rl+UfRgCMOmhPMXcZQqdp45Wjb08t/vRwJo3r7eCR6rULDdqRDDqZG32nppb6MXXxlnz80hksGmAjbxAPIrMdVLGtIZfcap2Y7az8MYmo5CJcVxOznqeUgyMw1c9POnQlQhLrbKHqkngbK3HMEs0yg/yVl0Tavta81R4RhDsh2wJvGd/Cuu0ozf+gh6bXtXJ8K5VgGA0h0DsOmfLOyiYUEfDpApt/83nzEDJyHw7Quy27BrAwhMS9vzadI45ffBvufNW+XnC8jM8EOM0y6xBb74UPRYZH5OGo/POOzqQKLtnewMauyjdl0IZIxGOpzBOR2hXnk2QnrtsaA3z6QK0OJf6z
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(64756008)(66946007)(66556008)(91956017)(76116006)(36756003)(66446008)(66476007)(2906002)(5660300002)(186003)(6512007)(2616005)(83380400001)(71200400001)(8676002)(6486002)(8936002)(38070700005)(86362001)(122000001)(53546011)(38100700002)(508600001)(4326008)(6916009)(316002)(6506007)(33656002)(54906003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?MRoYA17E0JHZ29PbXQyWnGMCSoJXkqozaNOjtZ3w1ZfCFGA1RAHnTsqkAh?=
 =?iso-8859-1?Q?t8oGVsJ39UQYKSO37NWWoEZ4nznEbJzjglaHlIVBz+cxenz9XtQS8U5O3c?=
 =?iso-8859-1?Q?RKW4xWdamFEZ4V41B9CW9LpmMynfYP8xhHgN5gMxrvEDOz3E6cUPcyOzxu?=
 =?iso-8859-1?Q?Jsou+gCFeEKXKZ+26wInuW0mvgjKQfoglyDDf3rsM3mfC6vbHxFeFU9hnx?=
 =?iso-8859-1?Q?EvwwoSSZj0EP0Y3m3CKAuSBZe0TZ8Vozdg4whuE7Msp2h+Ntt+50YrAIxv?=
 =?iso-8859-1?Q?woRmKY7W2+AZda8Il4IZoHLk7RngU1UzwCdDiySM9hIkCssT/KxhSzuEMS?=
 =?iso-8859-1?Q?vKldpLFLxm3qUxAtpAbDXwTOKvobvSK42fx2fLQ7w/ClOLFCe+4fz+W9Ak?=
 =?iso-8859-1?Q?50v38rGlobt8KYG6Nb7iVpVl722kzGnFxqmlott7G3YdgdFxLdz866HpFn?=
 =?iso-8859-1?Q?H7nanwVGSr/IKBa3rIIm1Y9mrmlv3B8d3LQEW6JpjOXr8jJ1AqG3KY7Ndn?=
 =?iso-8859-1?Q?R42kl4b5Ves/UaFLhesFZrhJqtxKTa40fZax3b8tWX/WJa0ttZtEE68k4l?=
 =?iso-8859-1?Q?BdRWkUsz+zDdw8WIg0n+88JtF/EaifEiTgmAE9qI1b0EkEj28pRnTFJhWX?=
 =?iso-8859-1?Q?MZKp30ikl64BRZMG8zQ0FqCqC/1EOpPDi3em+j8kTYSV0yZftLvge++Jxs?=
 =?iso-8859-1?Q?Tk1aHCus0LFeUoTP+FIN2jqIxx3Sd6hTln2+e1cXHzcqRgJXg1GOX0HxSG?=
 =?iso-8859-1?Q?zyFIh5sdsZJo6M5npAopXYwIcvFQuG39vk3pwN0K1deYb1/LCnTBgLVEUa?=
 =?iso-8859-1?Q?C584xyse7L9FTz2+f6EZ4JUvlCWgVQCEI0NKrO36kTwdewp6wD1z2wnysT?=
 =?iso-8859-1?Q?/gx+KYqL1FzN4dH/H2q34tiL+YwWuYXU9gSCd0UMl1zM9OtwScmLEeo44n?=
 =?iso-8859-1?Q?JH/x5DuIBq1CDfYQoAYEDaIHzoLF+WlzsfDyQFsPZFzCfDLIAAgzhtNDWA?=
 =?iso-8859-1?Q?YW8elKVtEIXE1hyYBrjnIZ9NSEyRO8RCzGiYor2mhRgw6djmOMzsgJCj6J?=
 =?iso-8859-1?Q?NrrhvVdP1PcaQ4n8qoCcUhbSgn5weqfo5O7oZgWBfQTknL6m8JSLQ5iHMV?=
 =?iso-8859-1?Q?v9yv1tqh8Xoqn5e/m7ZVM+xkgqWRp6ZrG8p6kFY4rgCUbGI2KtikYqLjoS?=
 =?iso-8859-1?Q?wUcFfrFMfhqxulKP9X9c6voXIgEmtJOcIQPdTJm9C+raH+nBpiPZ6hueto?=
 =?iso-8859-1?Q?3fwLc7C7cEkCGoPRROjCl0x0iCWxdHuGN8Zl8OiFsBakwjzvK7O3Tyy8YV?=
 =?iso-8859-1?Q?SvhbBq87U2r5gbRcMrhjrEhMzw0YAvkM0F4bG/qJ/bd6hqOtcW8I/F0ror?=
 =?iso-8859-1?Q?FKvzROeEqSmJrljpWHqRz79S8XC6bW+IcVoqV0HH6A9n0W6QfDzRc=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <54EC9FBBCC84DD43A6FE39819D7726B4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 232a1c55-568b-42e1-e12f-08d98f46994e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 19:12:43.0992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dwz+PXcJfp/pGce+WSdbbvGwwWMCn4wsjtIbKNyWd3kGokKrUG9EYK6j9Ums/JVypLpCEad2gF59vm5F+FsKYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5061
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 4XU0JP16cAk3q8h8XKWKLBkiKWp8KEGM
X-Proofpoint-ORIG-GUID: 4XU0JP16cAk3q8h8XKWKLBkiKWp8KEGM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-14_10,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 adultscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110140108
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 14, 2021, at 10:53 AM, Kumar Kartikeya Dwivedi <memxor@gmail.com> =
wrote:
>=20
> On Thu, Oct 14, 2021 at 10:09:43PM IST, Song Liu wrote:
>>=20
>>=20
>>> On Oct 13, 2021, at 12:33 AM, Kumar Kartikeya Dwivedi <memxor@gmail.com=
> wrote:
>>>=20
>>> This uses the bpf_kallsyms_lookup_name helper added in previous patches
>>> to relocate typeless ksyms. The return value ENOENT can be ignored, and
>>> the value written to 'res' can be directly stored to the insn, as it is
>>> overwritten to 0 on lookup failure. For repeating symbols, we can simpl=
y
>>> copy the previously populated bpf_insn.
>>>=20
>>> Also, we need to take care to not close fds for typeless ksym_desc, so
>>> reuse the 'off' member's space to add a marker for typeless ksym and us=
e
>>> that to skip them in cleanup_relos.
>>>=20
>>> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>> [...]
>>> }
>>>=20
>>> +/* Expects:
>>> + * BPF_REG_8 - pointer to instruction
>>> + */
>>> +static void emit_relo_ksym_typeless(struct bpf_gen *gen,
>>> +				    struct ksym_relo_desc *relo, int insn)
>>=20
>> This function has quite some duplicated logic as emit_relo_ksym_btf().
>> I guess we can somehow reuse the code here. Say, we pull changes from
>> 3/8 first to handle weak type. Then we extend the function to handle
>> typeless. Would this work?
>>=20
>=20
> Ok, will put both into the same function in the next version. Though the =
part
> between:
>=20
>>> +{
>>> +	struct ksym_desc *kdesc;
>>> +
>>> +	kdesc =3D get_ksym_desc(gen, relo);
>>> +	if (!kdesc)
>>> +		return;
>>> +	/* try to copy from existing ldimm64 insn */
>>> +	if (kdesc->ref > 1) {
>>> +		move_blob2blob(gen, insn + offsetof(struct bpf_insn, imm), 4,
>>> +			       kdesc->insn + offsetof(struct bpf_insn, imm));
>>> +		move_blob2blob(gen, insn + sizeof(struct bpf_insn) + offsetof(struct=
 bpf_insn, imm), 4,
>>> +			       kdesc->insn + sizeof(struct bpf_insn) + offsetof(struct bpf_=
insn, imm));
>=20
> this and ...
>=20
>>> +		goto log;
>>> +	}
>>> +	/* remember insn offset, so we can copy ksym addr later */
>>> +	kdesc->insn =3D insn;
>>> +	/* skip typeless ksym_desc in fd closing loop in cleanup_relos */
>>> +	kdesc->typeless =3D true;
>>> +	emit_bpf_kallsyms_lookup_name(gen, relo);
>>> +	emit(gen, BPF_JMP_IMM(BPF_JEQ, BPF_REG_7, -ENOENT, 1));
>>> +	emit_check_err(gen);
>>> +	/* store lower half of addr into insn[insn_idx].imm */
>>> +	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_9, offsetof(struct bp=
f_insn, imm)));
>>> +	/* store upper half of addr into insn[insn_idx + 1].imm */
>>> +	emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_9, 32));
>>> +	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_9,
>>> +		      sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm)));
>=20
> ... this won't overlap (so it will have to jump into the else branch to c=
lear_src_reg).
>=20
> e.g. it looks something like this:
>=20
> if (kdesc->ref > 1) {
> 	move...
> 	if (!relo->is_typeless)
> 		...
> 		goto clear_src_reg;
> }
> kdesc->insn =3D insn;
> ...
> if (relo->is_typeless) {
> 	...
> } else {
> 	...
> clear_src_reg:
> 	...
> }
>=20
> so it looked better to split into separate functions (maybe we can just m=
ove the
> logging part to common helper? the rest is just duplicating the inital ge=
t and
> move_blob2blob).

Yeah, I can tell it not very clean either way. A common helper might be the=
 best=20
option here.=20

Thanks,
Song

