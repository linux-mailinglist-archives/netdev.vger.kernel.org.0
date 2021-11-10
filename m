Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4CA44CC4F
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 23:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbhKJWRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 17:17:35 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54550 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234279AbhKJWOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 17:14:23 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AALQ4nf001167;
        Wed, 10 Nov 2021 14:11:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=IV7ANJNYfUvOWd2+2o+UYCJZzwsc8PgUj3o0E2J/OcE=;
 b=di2QOcZyfqzjeLprsLrjBgJUruJrgHy3FhinaRFuPpaeuUg0Z+uqF/xWx9XVX/Utwz7j
 Et2YMxE2UzG7DvLidHagv1Ki9y0JqaEJkJMhCW05hTIgTBY34etMJD+4DDmCkWSM4I4p
 3URCAVL++BIAEAEJCNJHPvNBhDwFzZ3P99k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3c8n6w0y6g-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 10 Nov 2021 14:11:34 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 10 Nov 2021 14:11:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hPq8xZtp2XmSpM8fAH61XB+Uelct460FcHzqXO4TnKHQK4PGbJ4gBOwTTybNn+Us4K0dklI2JAP6Nim+9M/2w189NVQXrQdD7WULXMlK51voUov/Y3255uKiXgZr0RKzD5awXQjVPYlEAuT4cAqfldjys+V/1bq4FNUh1hwwxl/bSdLwW6YjDLizWkvdbfKCe/n4CiGf3rFX77o1Ff5xwNRC48QuFaG3Jh5LXn3QCFi+DI0Mxh/XkhQSj8pbM35mAl4Redd0uERj1aqC2ylFU11UQ5fGdVtTQG0odrnzrUg6lpdXwzJAgKLsmFCbc+s3rWOXX3dPg+aYdki9aJom4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IV7ANJNYfUvOWd2+2o+UYCJZzwsc8PgUj3o0E2J/OcE=;
 b=OK2d1SXNVl1xLI6lCPuvgXePdx08vUc5vEytLpWN2a8b/RrPR5+jz6p1Z5aB3V//X3Llj9TAaZGZtTsKCW9XGL5LbplA2okbA7w/SfsYNh3I7ARqsTUruu03pRuzRDoMHTAogmGG7wEgso61g66Za0sNJhqWZ4WZRGzRBHYuFYq58OtisCexd//sC9ROs1KbfZZpYUam51aUCiY9qLW/CHXm1dauMysXQ184eeAmcBm+lJzYf3oLWzl6SnnisS7N9hAcStrMCiE8uWhC0a30+wUkTHInTFLX1W6n2OzEE7m9qOHL7zdvpk1PNeVw6CBF2J8E+eC2VRPj59nrOJN4IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0PR15MB5117.namprd15.prod.outlook.com (2603:10b6:510:c4::8)
 by PH0PR15MB5118.namprd15.prod.outlook.com (2603:10b6:510:c6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Wed, 10 Nov
 2021 22:11:18 +0000
Received: from PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::3102:269:96e6:379c]) by PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::3102:269:96e6:379c%9]) with mapi id 15.20.4669.016; Wed, 10 Nov 2021
 22:11:18 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "syzbot+e0d81ec552a21d9071aa@syzkaller.appspotmail.com" 
        <syzbot+e0d81ec552a21d9071aa@syzkaller.appspotmail.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH bpf-next] bpf: extend BTF_ID_LIST_GLOBAL with parameter
 for number of IDs
Thread-Topic: [PATCH bpf-next] bpf: extend BTF_ID_LIST_GLOBAL with parameter
 for number of IDs
Thread-Index: AQHX1lq3iI8AbMTPnku0RGtvGKCV9qv9UJiAgAACdQA=
Date:   Wed, 10 Nov 2021 22:11:18 +0000
Message-ID: <E3649A44-D11F-426A-A65D-ED40AA3B0214@fb.com>
References: <20211110174442.619398-1-songliubraving@fb.com>
 <CAADnVQK5nHGnC_9+m0q__AdhSxuHtE5Uh98epw2JEdjOCP343Q@mail.gmail.com>
In-Reply-To: <CAADnVQK5nHGnC_9+m0q__AdhSxuHtE5Uh98epw2JEdjOCP343Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9cae12b0-46c0-4466-efc2-08d9a497051b
x-ms-traffictypediagnostic: PH0PR15MB5118:
x-microsoft-antispam-prvs: <PH0PR15MB5118ECDB68CA3577D88597C9B3939@PH0PR15MB5118.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HKhkNC9YIBbvw0rZvcZo1UtCGQEMu6wIsU/rXPp73JN5+clmVs0n7HNhOQUjE9sg2cuPZmnMiw4YvA3xyHdJesvU2swoDjoizAs5dtwiaXZAnJjcpdFIXdn7L/DZtQctFieIRFaBGysxstgcYIPZFmV1vzkxVeDTAXae/7q7ZWWCoAyyk2UV3p2zmcUkPgaQJ3bEnXQqUTL7VlRmjLS5Rk2Iu8hUA9VEZl4vQB8EfcKAYwm8AssAv8PgIq95z6PpHEHAVygtB4p/UVIkbKcLJjneorxHs0P7xDYgalccrQhVK0o5ksfB8IYzHtu78jbUlKm5qpV8y3FYiPID5ZADrcPD8MmNLzhU5FNGE1KNgCcrauWYPHgyS+N5fLUUlb1v6wLLAIUukOx94ZOW1uqcGsfojmSkpbvSubFjo/xXPdFVxfXIGaOmN2Npjgq4syXxiuC/I/WKsh++3iLVB7fyNgE88QCUYn10vhAv8OhFc/5ebLnJh9wR++qteKRqaj/0IieYUhswB4isytx0InuUwZn9EOh7xqX1a/z8+iAIzwJ+69AwMzPFIpOInrUFHjbLQuHs1AF2n3Wa+x812daK+btl1d+f6wZT4Ln+Gv4vRVggqgdWJmD93Y2Oc/bqEMFq3yYecIXqoN10mYu0Jqn+fa5edElyJcZsBySk/48XzHxbcYYTSFXmI4LF01Hg+qLL7QTSITSMnuunyS6mdcMZSNyP8Ra+Obf1nII4IcD6B5mdfSky4lioNmuLn5BKoseZ43RbwwROLHF43DrBpsnIWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB5117.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(508600001)(2906002)(8676002)(186003)(54906003)(76116006)(66556008)(36756003)(66446008)(4326008)(122000001)(86362001)(6916009)(6506007)(38100700002)(8936002)(38070700005)(5660300002)(66476007)(66946007)(6512007)(33656002)(6486002)(91956017)(4744005)(64756008)(316002)(2616005)(71200400001)(21314003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?I7izcZ4rH4ZUm+eLOpesvnVrHPvXw6wY3kK+E7vEkl4xUwkyyBBeX2K3MJBh?=
 =?us-ascii?Q?t9XH2wuPxLDwMnaYNUH/mLcIBSiq3i2FOhCQ7tyFVEqrKLA7gIW5GX4W3D1z?=
 =?us-ascii?Q?b/ispp2f5OesKiurYcFe7LzUGz/T1SK88TOxgsNSJWaSxN21RMFRU0eYqTIs?=
 =?us-ascii?Q?Ld0YLq/gdj0uNfyH98HBwLuHXFgXOqHRsY3I0eFJlHsbncOZyPSob2I4aVGG?=
 =?us-ascii?Q?TTptA3uCSLUvFdJjOA4rWIGwzTya5v/KwoXoHyFSVSMj71MtxF9K1am3e5qL?=
 =?us-ascii?Q?YaDexFF9wE6+Tp7szlSy6ru8xQtjZZjPjrQnZBbsp8S1OE4CBl1bMLKQQxoO?=
 =?us-ascii?Q?88++Ofx0No4vLCxSt81n45Lg3FBZWD0Nmipgy69jla1C0FaAVefiGkpJec38?=
 =?us-ascii?Q?4WlTOBoGpsTCXfCkWuWANW3CTzSwymc/GiUyUrEBqkvU/n1q8DfUdU6odDNy?=
 =?us-ascii?Q?ysA4luEK+10ufmZkMl/6CKmmT/koSViCuJXP0SmvlmqWhwDW2BCZWuLB//Mh?=
 =?us-ascii?Q?rCSkqlEBr/LH7q34gU0yp13f3W0/9stUW6W8lx70Z1c1Xw5WMrVtQtuZnUyO?=
 =?us-ascii?Q?HjhnI02tMI8UYHQyuWDnsE99PHOx7QjFqVPfxuCCWlnaKdsrSJmAKo0QJg6D?=
 =?us-ascii?Q?NugGhC+VNV2cqhp01oW7jfwCj3OfnEstxZN4H0Lm7qG4maAuo5Nudra4xiTZ?=
 =?us-ascii?Q?oOjyk5lm1Kp50qtHX8ho1IWt36Rsev4OrGp/w5WdZl8prGtatJCICYyaFWa7?=
 =?us-ascii?Q?Q9Rca0cO9OUppBedrpu8BlLogHQgFhDY8hM66YhCd+g8VTxofQe15aHgBDyI?=
 =?us-ascii?Q?J/F5D8qMBwpC7o+EiECv08X/V/j3D8G+QiFCat5wQKNpA5KVvEh81MWLb/ex?=
 =?us-ascii?Q?+3duAO81OEKnAXJcI+mWoBr4bX4kJnud/3u1TAEMrSgmEFIGUJdQKX/CcVd9?=
 =?us-ascii?Q?DfNZvZQ2A33zOt3BBS4nXEZCTWm/KxF/RCMEBC1NxeXdXASL1nOIGvkCgSd5?=
 =?us-ascii?Q?HBvPwet1m8bTnqEsYCoEqKZoPlG0XzEEp/hZH4FhApKjZhJur28yl32ZC/HI?=
 =?us-ascii?Q?7KoF9fLlAB6XpPM5jWLBWFAjNQCxMTJDVmbSof7KuNJDoUC7SJy+tjlvUQpd?=
 =?us-ascii?Q?s95qrdLtyNPaatqfiBIhwIJDjFQLe+ne1apL2SsFQbHCq6ufd8NOPz72B/XR?=
 =?us-ascii?Q?Yc2AanMqRvy4Jy6PYvndfGAcPXBrh7u7CKItk/3ppMaRnn1SvAbAK3jnGEof?=
 =?us-ascii?Q?LWtoe63YVoxLR2j6jogXa8a4wRt8qISxf/C36nTKKIYFnSddF/juoWKQsaDV?=
 =?us-ascii?Q?EoB6XYUDalnnRi4JjxLzMnbdDUC/edjV8Ipns0cuRBo+4slobKTPsTNaLbwF?=
 =?us-ascii?Q?r2bLWuJKS8B4Hifh1TAz4WA5FNhla/Fzn33fTomlagyXfYtGiN/575woeGfW?=
 =?us-ascii?Q?rFw0oYyxKvQU1LNp6yS9pghrN5kOvAqPmJWYlD24obRvmDelK3zDJ9CgXAFP?=
 =?us-ascii?Q?/wR2Syk7dJDnqsuprcTCKzF0Mffwgm/pcJT0MEOlPZ1QKQQE0LFBTTzd6bX7?=
 =?us-ascii?Q?W1wNBGAiRQc0uVyQMp+qoB7jbt//X4Lc3pwckUM724DkDX4FtWDnQJrBNRSh?=
 =?us-ascii?Q?Sce6QyRTT2Y5aRPQD9lHoJL2xZEKZ8jrtp364i8ciwY+avsZqZUh3fvJtK98?=
 =?us-ascii?Q?VH5ezg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0345FCA81594DE448799353ECE60574E@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB5117.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cae12b0-46c0-4466-efc2-08d9a497051b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2021 22:11:18.1732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8EZ33TT0Fn/kyPJXqfmsWmHdDiwFfYPNlNP89hy1DYW3Slvjm6NodvaVmxaTJ/2wIStiVaY/4PGHi0xECf0Jnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5118
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: wBu7mlZvZ8QBCRotcr4-9DIh9u_zsgtq
X-Proofpoint-ORIG-GUID: wBu7mlZvZ8QBCRotcr4-9DIh9u_zsgtq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-10_14,2021-11-08_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 spamscore=0 clxscore=1015 mlxscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111100106
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 10, 2021, at 2:02 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> On Wed, Nov 10, 2021 at 9:47 AM Song Liu <songliubraving@fb.com> wrote:
>> 
>> -#ifdef CONFIG_DEBUG_INFO_BTF
>> -BTF_ID_LIST_GLOBAL(btf_sock_ids)
>> +BTF_ID_LIST_GLOBAL(btf_sock_ids, MAX_BTF_SOCK_TYPE)
>> #define BTF_SOCK_TYPE(name, type) BTF_ID(struct, type)
>> BTF_SOCK_TYPE_xxx
>> #undef BTF_SOCK_TYPE
>> -#else
>> -u32 btf_sock_ids[MAX_BTF_SOCK_TYPE];
>> -#endif
> 
> If we're trying to future proof it I think it would be better
> to combine it with MAX_BTF_SOCK_TYPE and BTF_SOCK_TYPE_xxx macro.
> (or have another macro that is tracing specific).
> That will help avoid cryptic btf_task_struct_ids[0|1|2]
> references in the code.

Yeah, this makes sense. 

I am taking time off for tomorrow and Friday, so I probably won't 
have time to implement this before 5.16-rc1. How about we ship 
this fix as-is, and improve it later?

Thanks,
Song
