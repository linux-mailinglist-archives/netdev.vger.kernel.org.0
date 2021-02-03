Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBEFC30E2A7
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 19:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbhBCSiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 13:38:14 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41922 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232349AbhBCSiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 13:38:06 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 113IaGpQ002702;
        Wed, 3 Feb 2021 10:37:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=fh3L5wbt5fj6JBHNLmGntVidc0e0/EW1dfHmJGkYmME=;
 b=aWmgb0PNgjKqcY0tQCA59ggB943VD5khOmHSrLKyOGfIkJEIvLtFLqFTNyjkZBG5y78w
 AHBoRQl/dIfp7wynhcvJX8N5BuD5s7oAtqs2MB51c/iNuI720Dh56M2NvsTXCm2+ZI7Z
 46lfJs1CP1qk9a7xy1BSEuLH+meTvP3UGrE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36fj01cf70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 03 Feb 2021 10:37:11 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 3 Feb 2021 10:37:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOSD0o1nMlGYxKi+u3bzSeMLsiyb3O5QdsRZl+SvQiK8I+vfVDn3pb2rYVPyAXlqv7DXzMdrBehBunvq0ISUdOt8ayPbXy+5G0WIyqpMrP+F8n/w4k9CHEjit8Ei4bWJw16c2c1qBhpNeFbCJXVY7p3mswuzBwuIopNutcigPMnjGff9uQNR0wXw/4C5aHWt+9kVw6hPWcP/kHhopvVX1yEPOntWmqYNaSz3aoJd70W4Sh8EuG5Y4toXQgeFYDnBuwVF+//XXnr2CebT0g4xYoUUUSVtr7uvwrQWD2eOtzaEEBufmHO3mFju96fC4vEh6r5kTGsjC9d/7+tPfZth5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fh3L5wbt5fj6JBHNLmGntVidc0e0/EW1dfHmJGkYmME=;
 b=GaqHVmgFSqUTCuM4/WbpsPLbmHN/sHL/1bwI8BpjWE7ULE16xAZUmPwTkp8071WIPz+f3eaNjo1f/EK5TsbvBVikLt8FY6ScuTTYSNzoj8n+xORq6I7Fj//5gaVdFXP5Yh9W0gWR7ifyJ1dSV0iMM7AVDAq0Nk+zNAl5/1t873ay5FC4tp9Xtv60gwRmGgBFht8O2B2/6mVOwBC5uF8KsQjGQmPKKvgFKbaHwq/fmwRlPhW3GidmqjZsA5q4PtvVItKgW6QMwpeVapaSLOFLg63AF1DhbjHedttqtx3QY3L2+odgkdrUAU0e7JKVYqzWS+y9onldzXthpd19BoaJPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fh3L5wbt5fj6JBHNLmGntVidc0e0/EW1dfHmJGkYmME=;
 b=iIOtoqynGuGpqq/8DqfmEH+zFMMguZWoNVZpINfEiXD/cO0Rl0q20hms4iC2O3StIM9LX95103rbqReMwsyTHyyo7ikiVbF/UlJuSBAlHbNYz/PyDvgd6S6lvTC2YBjQQiTLMvFNwbQ5V6ncANCx0PvoXwj/kzpzdhp+tV2nd/k=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3569.namprd15.prod.outlook.com (2603:10b6:a03:1ff::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Wed, 3 Feb
 2021 18:37:06 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3763.019; Wed, 3 Feb 2021
 18:37:06 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] bpf: Emit explicit NULL pointer checks for
 PROBE_LDX instructions.
Thread-Topic: [PATCH bpf-next] bpf: Emit explicit NULL pointer checks for
 PROBE_LDX instructions.
Thread-Index: AQHW+SXQtvupKOqI8UORYGsvttx/VqpFnI4AgAAXFYCAAREzAA==
Date:   Wed, 3 Feb 2021 18:37:06 +0000
Message-ID: <5E2A13A1-7F78-4830-871B-694892119EA3@fb.com>
References: <20210202053837.95909-1-alexei.starovoitov@gmail.com>
 <A746402C-245A-4FF1-AB54-585537EEBA9B@fb.com>
 <20210203021915.5cfdrt3wwmskopuw@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210203021915.5cfdrt3wwmskopuw@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c091:480::1:aa49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df5adb83-3d16-4ceb-18a1-08d8c872b531
x-ms-traffictypediagnostic: BY5PR15MB3569:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB3569D85FC4F5F67CB0E167B7B3B49@BY5PR15MB3569.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0eXj7Dr17wz2pXXHbIqBlT9zriffYWZuh9llKu0Wto8d109zCkt1UrbkGX9OqGGZsmRt5LKhokWaaWX6LR0vYo5KEbVWJbv2iKX/a4O7596NtTvsNmHbVPw8yuyv+FaKeviax/fkGg68f/7uuvZPsAX0laz7Ih8lpcuW34uqpipmMT/2o2ccbMOmmGkJcAQdxu4FyaNZ2H30608DwC/l8iix4iWZW1wivgb2iJOaC8gvswlMX/CRbpI+rVg0bKJmAY2+mqnprtfW2Dez8Kzx/QHHnxt3PSD8hpKLtbc9L2rDqXTKnxpBu346tYNE1ahzpGVUTLkp+bRvANGScozPeInw4crqJiAzPd3zbFljI4E9o8XBIUKBDCJl4atDtr9N+COFfJvfwFDq+UpEktaZDO9DDtEYfS+sYcfWF0M5U8aCzuHqH1vjNmjYxwtyjZfW90xqOHeQO5SXPmLcILYnDoiBM//Lv8PzuwuD6HfqGw6WA28ihkRYvPTH4HXvC6iOCcUQJJUhNzXwq80Js9TzrGyqVCmR6x4x1YsUpNMM667hsohoWRRGNUjOiLNeeodHn7li4hPQA5Bp/J7EZ8Br8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(136003)(396003)(376002)(6916009)(66446008)(33656002)(66476007)(66556008)(64756008)(53546011)(54906003)(6506007)(6486002)(86362001)(5660300002)(4326008)(316002)(76116006)(2906002)(91956017)(2616005)(71200400001)(36756003)(478600001)(66946007)(8936002)(186003)(8676002)(6512007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?FQDJfX87B7xALZMssExndSwi50k1JUKif9Wr+9akfXclriFV3kN9UvS1tgUi?=
 =?us-ascii?Q?C2STXG5oifWfXnZqQt1Nl2OEe+029WhOWwOTfHm+I6gB4T1KeJCSPui7F0r0?=
 =?us-ascii?Q?noTChkB/atP+yu7mqr16SQndEuNWIDnarx0F8p6dWf9Oms8t18FoI7/U3jTM?=
 =?us-ascii?Q?2bb6AWeDAs2/wTiOme7afMHQaG3EaOagfZUInmN9d31LP9MEAZzWXLzekoz4?=
 =?us-ascii?Q?2uRTxuAUZNDu3+BkjW4iaxR25qZHen8extO0CZNGFSABVv/2pA7P4oyWR1yq?=
 =?us-ascii?Q?E6dbkenZULBrF45d7Ma0s6bP66b/yZRBI+HUKbbiRZoH1+rmgn7inPVhZLiG?=
 =?us-ascii?Q?Xpjdbq276WcGGzWcy3uf86rtfsbBZ6YL9qWL7/kP/RgtAtDDVc7YLSRpLeLm?=
 =?us-ascii?Q?7UFaEDmGXJhPjeHHJiH1/1xF/C+JA8xz+muEMGnAmiOu31TuPlWWQTslA2dU?=
 =?us-ascii?Q?jvTpBV2mK6NGHVEhzWPlBUpSFIZ+EOLMw00D+1hskMy12V+SsUsbwjve3J/n?=
 =?us-ascii?Q?In+L6vFAk1d+1ZaabEU7ahKFSDR+QFX+0t/vOURxw3jRhlzR9klaSPvRnWDm?=
 =?us-ascii?Q?ubhyPTLZomYWO4CAlLl8Nqsw/c23+7OQYcPwcsCgjvCygBM5MnRcNBrbLmBZ?=
 =?us-ascii?Q?y0W0ElYX/y/+7Y0bsxHh133o3BWpxUi8Orsbbv/Fphs/MHhEmFndIElm7M0f?=
 =?us-ascii?Q?VzfzMtE8uY9+Lfb39JwdAgElfeuVqkspW7S/BMhb8H/BL/d6y2Uga+GkdIsX?=
 =?us-ascii?Q?AI/ZUebp4A+phv5DWS5ueBX4rdAalBghKI3Gi1v+g4M60cWT6tTijNCAIJwZ?=
 =?us-ascii?Q?e7b6X9i8aVYk17mh6pq+eA9tZBhPi+tHKMjzYfquorGv0LL36IzDPjfv/mWq?=
 =?us-ascii?Q?9DAionQXMB3IPsd4e6nEzqD+KsbXOyno0/5n20xt9tVgwzMB/gHglkf8ijyE?=
 =?us-ascii?Q?YD2Vk1pChXEq8zTn/Zo2uDRZHe5N0KBOp/sLEax0Ow4zlDNt2xmt6cUKK2iO?=
 =?us-ascii?Q?POKwZbJvr5J7QJ3lkKEoXYJ2tZnZxtG7+6p60PeV49LjUlxkaG6vVPNVP/61?=
 =?us-ascii?Q?P/0EUU17xatJAAwjVyWYIKZPv/Q0oFNI1FId/YHd0iIBpbSXNVl4xzSfT7pG?=
 =?us-ascii?Q?E7yE9cxJFJR3q4ur6Dygi1qryG28Chz+soIaB37CQkNqFZlRpTDdajQZEVO/?=
 =?us-ascii?Q?bR8MCUJvjAkYl/0WStEgW1PHWMg+P2gpurM9llwb/5nqXdx2wdCSr8dr7wYp?=
 =?us-ascii?Q?eeR8BfgoX7YnGBYEvSQIgppYcIwbhk6hslxxCjf4lIDl/DdjR8CkCMRvL53+?=
 =?us-ascii?Q?D0PvA5nmWOvWGFAdNx7wmEMpLGarJfAiZt3GJlGmXTE3b68MVoxEkyGakjuu?=
 =?us-ascii?Q?wuKTGZ4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C675F9229221334296FE214A72FC606E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df5adb83-3d16-4ceb-18a1-08d8c872b531
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2021 18:37:06.3036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: srzJ2hl/hTDBAYIQeoqI06Gc9vqzsC6mLJ9vzPNL00XXqWXCdYK81qPxA7d8dhNGfHb1wHSM5qJA34BtwSVCXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3569
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-03_07:2021-02-03,2021-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 suspectscore=0 clxscore=1015 priorityscore=1501 mlxscore=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030109
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 2, 2021, at 6:19 PM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:
>=20
> On Wed, Feb 03, 2021 at 12:56:39AM +0000, Song Liu wrote:
>>=20
>>=20
>>> On Feb 1, 2021, at 9:38 PM, Alexei Starovoitov <alexei.starovoitov@gmai=
l.com> wrote:
>>>=20
>>> From: Alexei Starovoitov <ast@kernel.org>
>>>=20
>>> PTR_TO_BTF_ID registers contain either kernel pointer or NULL.
>>> Emit the NULL check explicitly by JIT instead of going into
>>> do_user_addr_fault() on NULL deference.
>>>=20
>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>>> ---
>>> arch/x86/net/bpf_jit_comp.c | 19 +++++++++++++++++++
>>> 1 file changed, 19 insertions(+)
>>>=20
>>> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
>>> index b7a2911bda77..a3dc3bd154ac 100644
>>> --- a/arch/x86/net/bpf_jit_comp.c
>>> +++ b/arch/x86/net/bpf_jit_comp.c
>>> @@ -930,6 +930,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *a=
ddrs, u8 *image,
>>> 		u32 dst_reg =3D insn->dst_reg;
>>> 		u32 src_reg =3D insn->src_reg;
>>> 		u8 b2 =3D 0, b3 =3D 0;
>>> +		u8 *start_of_ldx;
>>> 		s64 jmp_offset;
>>> 		u8 jmp_cond;
>>> 		u8 *func;
>>> @@ -1278,12 +1279,30 @@ st:			if (is_imm8(insn->off))
>>> 		case BPF_LDX | BPF_PROBE_MEM | BPF_W:
>>> 		case BPF_LDX | BPF_MEM | BPF_DW:
>>> 		case BPF_LDX | BPF_PROBE_MEM | BPF_DW:
>>> +			if (BPF_MODE(insn->code) =3D=3D BPF_PROBE_MEM) {
>>> +				/* test src_reg, src_reg */
>>> +				maybe_emit_mod(&prog, src_reg, src_reg, true); /* always 1 byte */
>>> +				EMIT2(0x85, add_2reg(0xC0, src_reg, src_reg));
>>> +				/* jne start_of_ldx */
>>> +				EMIT2(X86_JNE, 0);
>>> +				/* xor dst_reg, dst_reg */
>>> +				emit_mov_imm32(&prog, false, dst_reg, 0);
>>> +				/* jmp byte_after_ldx */
>>> +				EMIT2(0xEB, 0);
>>> +
>>> +				/* populate jmp_offset for JNE above */
>>> +				temp[4] =3D prog - temp - 5 /* sizeof(test + jne) */;
>>=20
>> IIUC, this case only happens for i =3D=3D 1 in the loop? If so, can we u=
se temp[5(?)]=20
>> instead of start_of_ldx?
>=20
> I don't understand the question, but let me try anyway :)
> temp is a buffer for single instruction.
> prog=3Dtemp; for every loop iteration (not only i =3D=3D 1)

Thanks for the explanation. I misunderstood how we use prog in the loop.=20

> temp[4] is second byte in JNE instruction as the comment says.
> temp[5] is a byte after JNE. It's a first byte of XOR.
> That XOR is variable length instruction.=20
> Hence while emitting JNE we don't know the target offset in JNE and just =
use 0.
> So temp[4] assignment populates with actual offset, since now we know the=
 size
> of XOR.

And after reading emit_ldx() more carefully, I agree that introducing=20
start_of_ldx would simplify the logic here.=20

Acked-by: Song Liu <songliubraving@fb.com>

