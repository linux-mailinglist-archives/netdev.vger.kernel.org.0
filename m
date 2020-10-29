Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADB629F393
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 18:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgJ2Rpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 13:45:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56464 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727964AbgJ2Rpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 13:45:41 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09THesLf014520;
        Thu, 29 Oct 2020 10:45:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7wVtQGaRqT+dMe+ph9UuWoewSIDaRsljnZo1MCw7Axk=;
 b=HgFzDecu5yseo0wCbIrvawUr2a69R7iSld087DKwqI3nWk60a+s71oR2NqZmCqj6SRva
 PPKiBytO2M4TY9kCv09u5gCbkuwrflSFJ37BcEDgx7DWIAzarP9XHxxsj+qXu8ldRgdf
 RqoNME4xeubutLZW7ZtDTVOrzmd+wL7g414= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34f7a6rrsc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 29 Oct 2020 10:45:21 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 29 Oct 2020 10:45:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fmHW/6kF/bep97OSV2zuH1HpsfcOgF0GspwSl7gBFWUR75qEo9aaOlQpula04jLWzg6nijvAH3+3KTHHFSsBFP/Nq1KGLAzlkUvmJdrmvgiXXVeSXL/yOVgkoCeNblqQdH/Ww+Bh4W5rgcu4GtRbEPV8aqhwZGo7gw/ojBUbLYX9Vl/JYTY3QegYXsWnn1WB+B6euYxNvf9IMwzWIdmbNR5uTbPAMpN1Jkww/7928ORKGMTW/K4J0YCW0xUhuFy8t5bsPzF+MxIFaXd/09S+3Owp4gzhR4S1f8vqtt+r2n5PrWUcLQHpNFYy41jG7IfWxAs7O/K86+7tyRU0KqQC+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wVtQGaRqT+dMe+ph9UuWoewSIDaRsljnZo1MCw7Axk=;
 b=Z4vVy72wXxyYqkk0dio2WpjanAtqFGr5ObnUuNM3LjzHGO6mLB6oYnwHnACm+ARijPKwaoVjvFsnl7MvGedXA3aK+4vWVLjsqwoEFn4l/L0dW7M5h1pZEMKDKWTaQw943A2Z+++r3qO5EczVRePtg/xERTPlaWHm8CYFgLoggPhvAXWLZo6O+adhO2JB+lbnN6mhdNj8kX020C45Oh0wqqcrKEDF6R/l76pmckf60ogKhlUeJ9Lcb/P1EfdGJNlSavM7GGbQh4sj+kWvKC2HXqdbE1zG66xsPZgmZ3s3qAQpO2reds59FQe9EldXaar16ygoC923p7dnoaNDEbxCcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wVtQGaRqT+dMe+ph9UuWoewSIDaRsljnZo1MCw7Axk=;
 b=fRPqU4FeYvnCzynxFYOmy2xmV+EYwN6l2T4Ouxsvy7Ob2w8lGvalNjSCtm6sCTcVl5pTzD0mITJes3rCh4i9WG3x3YpjRtOIPpnQU6yjGxwfm8O22BXVkS9dH/71ra1q5/O+XykT2d5sFoThBXAv/hcGuTJ68OOJPP1SVfrp4lw=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2726.namprd15.prod.outlook.com (2603:10b6:a03:157::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 29 Oct
 2020 17:45:14 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.027; Thu, 29 Oct 2020
 17:45:14 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Ian Rogers <irogers@google.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libbpf hashmap: Fix undefined behavior in hash_bits
Thread-Topic: [PATCH] libbpf hashmap: Fix undefined behavior in hash_bits
Thread-Index: AQHWrg3tjprFy4LddUi1ivGW9wO6rqmu2mWA
Date:   Thu, 29 Oct 2020 17:45:14 +0000
Message-ID: <497F86C5-BD00-4C38-BD87-C6EFB92D1088@fb.com>
References: <20201029160938.154084-1-irogers@google.com>
In-Reply-To: <20201029160938.154084-1-irogers@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:9fb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 603015af-6abe-4dac-6608-08d87c326442
x-ms-traffictypediagnostic: BYAPR15MB2726:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2726D9AC10E34159D738976AB3140@BYAPR15MB2726.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5ke7IgHHTtVryJkRMMFFn5Fv/km2FnRwyIab5+eTxOfl2oTCmZjM8h6iumqjGzl3vlE7o06M/3QrI1gYHCz3+YsbTrF5OekN2XoWP5tr/j0x3RFJDaYNsCoIZJYqyAC3Z+i79zEMqQn/SQH2953Vve52JqWgw3KJdQbpuf8RDKkc9E3mbmDwntyTSpat+/cB3kvt+Psdq7Yodqg/xKCe7RxzSaRJ5DGh9eg65cj9TMVTYox7Q20nZb1m/EnUPPgKbfqQrYHDVkcj+LGef8agtZsYv8hY5t0vmlUcffaHR2eU7adQFPs52FA9tPfAYb6gVqdsQi631tnGBO17O/gmmxr/s/Ti024avQqd6IErcJUufEHmudmM8tVihrQZ6aH858c3ognn4lFUCnIfR79hSQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(39860400002)(346002)(396003)(71200400001)(478600001)(64756008)(8676002)(4326008)(66946007)(66556008)(316002)(66476007)(54906003)(966005)(2616005)(186003)(53546011)(5660300002)(2906002)(66446008)(76116006)(6506007)(36756003)(6486002)(8936002)(86362001)(83380400001)(33656002)(6916009)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: PVwujb+YL0NnLvPwKhK68T+6+Tv6R+C3XZPrsI2P2BRJHSeWWaZFaJvnYAAoAN6GJ+rJ3EfDPMh7La2uWxVylry5124yetBlKWThhHSrQU2g5tQAixn3oK26cLfExA03V7j0ZRYS3ESD0oaRolxhQY9f/YmhDQyfQ+D8UBVAhGeXxoeVvjwLqviDDedhvOHv1SjJdqVOMgMPJslG8He96b61NIlEL02uxMDv07oqHpFYZcAziy7l5yVZMKcR/QCYpeWfs6sq61iqcI7rgvIpry9ROajSkOxoBHbcVdiDvsCESCgAfsGQPI8BMxPNTCbv2wUavHAfxIf7/uyR+TpQ7JOnMzw/kFERZeuNl+2u6NcTohl0N0L72q29N8yC4c7Eqt1UTzTW1P8ZXWExNoNLHBqZMqbNATC23Knbx7vqzRwCWNmcfHJoTdBAdSyQb05NAeyFziDT7jPL56L23v4J+2/Fd7Cig/VcenTST85Ra4knTFOTrjJlZ6+zbOuMTdE6C1+DRNMQW2Ay7jGmt03vp2SaqROLMT8e3gHHsNnWpkuuDR1VF67BiHCIsYgGkNHhNoAdLYIXHXOPcba6Yhy8MZX5Op1H1e+aQGZRR7VXcooerax15bWCh7SzY5ndAztSoKfafw52F+YroVo0xO9clCuSfGLPmFFx7zLsxquQWoM=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A721E4E0FAB0344EB41E1F7B834AB9A0@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 603015af-6abe-4dac-6608-08d87c326442
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2020 17:45:14.3358
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /t3Ylasq+/YecZFl/SbPJt0CtjFRCDJAJQQnfcM7V4+xtNImH05FtRg//o9tvUVvdpk0LxrSgM29oLV2xWLcMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2726
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-29_11:2020-10-29,2020-10-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 phishscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1011 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010290123
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 29, 2020, at 9:09 AM, Ian Rogers <irogers@google.com> wrote:
>=20
> If bits is 0, the case when the map is empty, then the >> is the size of
> the register which is undefined behavior - on x86 it is the same as a
> shift by 0. Fix by handling the 0 case explicitly when running with
> address sanitizer.
>=20
> A variant of this patch was posted previously as:
> https://lore.kernel.org/lkml/20200508063954.256593-1-irogers@google.com/
>=20
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
> tools/lib/bpf/hashmap.h | 14 ++++++++++++++
> 1 file changed, 14 insertions(+)
>=20
> diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
> index d9b385fe808c..27d0556527d3 100644
> --- a/tools/lib/bpf/hashmap.h
> +++ b/tools/lib/bpf/hashmap.h
> @@ -12,9 +12,23 @@
> #include <stddef.h>
> #include <limits.h>
>=20
> +#ifdef __has_feature
> +#define HAVE_FEATURE(f) __has_feature(f)
> +#else
> +#define HAVE_FEATURE(f) 0
> +#endif
> +
> static inline size_t hash_bits(size_t h, int bits)
> {
> 	/* shuffle bits and return requested number of upper bits */
> +#if defined(ADDRESS_SANITIZER) || HAVE_FEATURE(address_sanitizer)

I am not very familiar with these features. Is address sanitizer same
as undefined behavior sanitizer (mentioned in previous version)?

> +	/*
> +	 * If the requested bits =3D=3D 0 avoid undefined behavior from a
> +	 * greater-than bit width shift right (aka invalid-shift-exponent).
> +	 */
> +	if (bits =3D=3D 0)
> +		return -1;

Shall we return 0 or -1 (0xffffffff) here?=20

Also, we have HASHMAP_MIN_CAP_BITS =3D=3D 2. Shall we just make sure we
never feed bits =3D=3D 0 into hash_bits()?

Thanks,
Song


> +#endif
> #if (__SIZEOF_SIZE_T__ =3D=3D __SIZEOF_LONG_LONG__)
> 	/* LP64 case */
> 	return (h * 11400714819323198485llu) >> (__SIZEOF_LONG_LONG__ * 8 - bits=
);
> --=20
> 2.29.1.341.ge80a0c044ae-goog
>=20

