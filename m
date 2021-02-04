Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A1A3100C6
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 00:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhBDXeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 18:34:25 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14580 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229976AbhBDXeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 18:34:23 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 114NEISh018203;
        Thu, 4 Feb 2021 15:33:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=H0y8Djd1TGaOIsjPfvGSGu+Zz0lSmGS/UMLsTDj2R2E=;
 b=pqDfsvTh9y21Y8BhfgwfxaR8Bbz4Vc7fQ64xLlL8zqI5eQpQezvpwlBuCD2B2gLbzRuB
 f9KeQIwfuAs3SpUcBD8xTjgbKg5vXeaMPQ+1q/JDcnbFSIX9cC2Nd73v5qfeMGcLF7tb
 JWLUdFSE8ljFMbkxHwmxj/r0HU8at5U8aYw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36fvyd1kb5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 04 Feb 2021 15:33:18 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 4 Feb 2021 15:33:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUU3XYF5/DecenhUZJrUzQNrsfaX6JwuZC9p7NkjPqCC5tJUdYAU5if4Tkxw+ZR3Jn50Db/KrSPM9213q5ITPVZ6drpz5zVq5TQrQQlfIMYgudFy/LD5NVUBCv/ulyrtvBjMqNBi3Qek2trG/j2O5NfSZeU7Q+fmkpXUp43ZSA2xRKkBHBa6XRlgFwJSjEAi/UNofLxQ4FCxEnN2udKIwgJFpH8eIV9cJ8mlX9+ijHd9Qnl0/+mGbZFHHaCqip/nZ+++0p18Q9HNABcJg8ScotWt7QSS+VapkIZPsMLV0F8wgGGt4aDeuMzLMpiSohcLAxiCJi5yC0nknweJHyV9JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H0y8Djd1TGaOIsjPfvGSGu+Zz0lSmGS/UMLsTDj2R2E=;
 b=Cw5IFzg0f3eIr4DzMo+ACei2yC996bvUU0C/3yuUy5L9U2ig5wtYU6rFo4eoXlImanyNRAI5otI+2t3Van9WOvJRwq5U+O6WUhQ1OngZe0T/5Nkif/heLWdr0sDvFMbfI4d0XpkYrktFdXgvqZUFKftHUF3Ia7O3Y/gQpLTwiO/w6Hz8vJv6XpYfb7SOt6JvdjJA6WYMri50mngXTzDTJDsDSzhc7X2Dz0Gf86p7eImHKD0tatbtqRWntOU2yMP3p7db2/qT2wWTVjmJDlu+uM3S+EAtaGUo3eFA0TWhaJOFms3m6pN5OOy003YQL9X+UVE5+0CJqUq0Qmqrev0kAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H0y8Djd1TGaOIsjPfvGSGu+Zz0lSmGS/UMLsTDj2R2E=;
 b=JjK/7xhIPmES6gRKzQhyw5o8PisOKqZidQoWZgx61bH2VDBDkFLUb1F8u3q32VqEQBtXRMGsLi86fw63OSKxXQORWfp4r/z2YJt/OMT4pIvZIarTJpNP9GADBaiiZ7oHDC7Jx6n6beOj4VdfQVpp1y98YH9yGYWTsv+ROjbGWKA=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2838.namprd15.prod.outlook.com (2603:10b6:a03:b4::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19; Thu, 4 Feb
 2021 23:33:09 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3763.019; Thu, 4 Feb 2021
 23:33:09 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jiri Olsa <jolsa@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Martin Lau" <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] tools/resolve_btfids: Build libbpf and
 libsubcmd in separate directories
Thread-Topic: [PATCH bpf-next 1/4] tools/resolve_btfids: Build libbpf and
 libsubcmd in separate directories
Thread-Index: AQHW+ztTcRSjOC657E2P+KoC+1mF2apIpbeA
Date:   Thu, 4 Feb 2021 23:33:08 +0000
Message-ID: <4EA9EEEC-ABCE-41E3-9405-D75B60BF44AD@fb.com>
References: <20210129134855.195810-1-jolsa@redhat.com>
 <20210204211825.588160-1-jolsa@kernel.org>
 <20210204211825.588160-2-jolsa@kernel.org>
In-Reply-To: <20210204211825.588160-2-jolsa@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c091:480::1:aa49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7cace225-50c5-4769-3d49-08d8c9653b0c
x-ms-traffictypediagnostic: BYAPR15MB2838:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB28380A2302D2B5DDB53641C8B3B39@BYAPR15MB2838.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dQZG8Oe0WYrW6F6jjiDjMKQ4e4OCYciJBeiFvAdPmPI+IhZfkpBV8l6vBetJr0jLYu2cjqV5uA1W6BhdYgVv2XrWr/fupgHUCv9MNCKIBrfWOh711Huwjg4bX+5+TNsMfXv+sJSkHpGZHYMOjv/Y0B22AVZ0Rnh4uSgfPUH8x333QKYdgZOTCUtGuUyA2tCEldp1/LBr4N52F4hvtLEuyqT37suK3cTvTZRNEcGtz9J7PHEsF2fCiwCHHPv/czfOLUtfPh7oh2M10dIjolSyv27J9zm6Bve/z4cm2Ean/2toR16PbAXfpKezem6IKkGxCOyjtmFXyA+y9VHagXMJ5949tJZUrqK+HUQvs27JM4asXXzSf9OY7P55KYBaiXb4Ej2W/fMleepfvm167jinOdCqoUDjMQfXA5uNX93fmPFLQmSDpZLjuKjZEI8EbhfDDc2QI5e1jf2Pue3aDyr4jJRqtHps5gBwTpBAzDs7t2hg53tWcdDQeVmnwLY1MwvQREbAMbznZZ84wSXp9wQJovkFPqfAs5yhOOcc82jIL87PCPtbeKl/Zp0oGmsaf0emDBz14FktufbobfSAqOcbCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39860400002)(376002)(136003)(366004)(5660300002)(2906002)(2616005)(8676002)(4744005)(6916009)(33656002)(8936002)(7416002)(6486002)(91956017)(66446008)(76116006)(86362001)(71200400001)(6506007)(36756003)(53546011)(316002)(66556008)(64756008)(478600001)(66476007)(4326008)(54906003)(6512007)(186003)(66946007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?juFWICrsEaQFMgzG9vx0aLYPeuhjoqa3I57RlLHsfJyz7va3mzw7vHJVXsjo?=
 =?us-ascii?Q?JnWTSdC2Mp2Z4RwFqOHKECNxj+OKwBL1AB7KIrHzEZiI6FvrnhfyB4qLY7Sd?=
 =?us-ascii?Q?sDwGRbgA1LytzWgrlNC7D3RvOVEDBdOHvzDYcHv1gTJwr4s6Ba65txhC2cg2?=
 =?us-ascii?Q?lyS51WZCNVaT6gvWVQo5eCha2y1dhJv8nE0q+CL08fE8yN6bGE9Asqel4A2x?=
 =?us-ascii?Q?4T237FnuwkROHk2wXSqoaGNPmc8BG3e8e1HZUJuL9kcfdRWgHHxRONa954xL?=
 =?us-ascii?Q?ufRFqJgUZLnRA9JH6ZWtpJ9uA9CqD3WPlmiz+xlQJPs+UaC6GECOKKONnlsv?=
 =?us-ascii?Q?nDDpXoEn0ujlSaBo009S5w8LnrWeCOmKnK58KMPc4AFERZOADF3wLC84+eQs?=
 =?us-ascii?Q?nNoY/rvdXe6jZZsJ0ylcyOQUQtXzgxfMd9IfUgQP0c1mUuly4yFujyBHLZeo?=
 =?us-ascii?Q?ma3ptefahFFS8ZhJcESBvEBI9/ph23mvrlcEr0fRHftk0om2awPpnwTLXIjg?=
 =?us-ascii?Q?Co9BaFK06nWDqlh3kQHPRn/8H5Ya8NOTI9PdjfpXS2bx+wkFi1U8ZkT4M1NP?=
 =?us-ascii?Q?IUQJ+NA0xDgE9J10syHPiPviHFWX8XeJ1M5EYTin5Qb6A5CS/kzB+vp+h0YM?=
 =?us-ascii?Q?BHx+k6kviI1vFTvNYgwB+pXSUU7TFqohTg0KuUYV7DpfuZ5SsPXRB5Lv47iY?=
 =?us-ascii?Q?yhziWdiIHhViwg+yTv1EU9g5UFd9H9GI5ulxlJKW4aGD7OtI6JjCtZEQdJqY?=
 =?us-ascii?Q?I7FYwX/JHSoekHLWXykscN+1tpq8NzhynRXuRCK9v1R7hreodaqs6wdx/NZT?=
 =?us-ascii?Q?BjgEJadje3tNdDRePFQJQCmj2VhwyBDbr0Y6n4OFMAMGTNi+ga4IGTcDHDYa?=
 =?us-ascii?Q?luNw1v6bo8BnCUOyn2G7WjXzG0++wtroEbQaBdpZEZ9+sGYXim14deYZBSoZ?=
 =?us-ascii?Q?tYows6TBl8VBv91MtTBrOLPS7pUX6A0BCTeqWWnV5VCc5waYSfVltSXZwYuz?=
 =?us-ascii?Q?yW9wiMpDh/VKyaDbjdaFZfT/FUL8Ss9Ryi7gIlHCDebQqbFm9pkJXBMZm+f2?=
 =?us-ascii?Q?qSoVFg2lGKvEMYMq+fQwWmEBJ9eR+yRhmQdo12G+U1B5ZhOqUuVifb7rtLKt?=
 =?us-ascii?Q?0tQTsoDECgUWZXmyspmmFfRjUfZFT9wTjW4DwufGzmknGcmgP0yiwxIjUoqu?=
 =?us-ascii?Q?PoWuj6s5X1uI+MKlPtfpmiCWYhOTGuGdLEFMG2aqmTU2ND5iEv/TmQIXjpbZ?=
 =?us-ascii?Q?y8X4NCdHjz0/5vIj/eJIxcQ9CQB5VXb6o7qOfg/yJX6mFcm3A+lP9sUaSujz?=
 =?us-ascii?Q?IdUBCtPYACJ3WXlSfqgWR6zRr5blVPQ0doXQrl5AS3Nv7L8DSpJ60BfAHub1?=
 =?us-ascii?Q?ed5TZfw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DAAF4978B9AB7F4195457CFD49AB124E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cace225-50c5-4769-3d49-08d8c9653b0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 23:33:09.1633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dVlf8TTxFauR/9WYezcLNEAqsVzz028w48Qho8Sd3zqkx0e4jurgJqOHKv3ybHcW/3oPPUcl3eqPCedWzOFv9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2838
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-04_13:2021-02-04,2021-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 clxscore=1011 phishscore=0 spamscore=0 mlxlogscore=698
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040143
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 4, 2021, at 1:18 PM, Jiri Olsa <jolsa@kernel.org> wrote:
>=20
> Setting up separate build directories for libbpf and libpsubcmd,
> so it's separated from other objects and we don't get them mixed
> in the future.
>=20
> It also simplifies cleaning, which is now simple rm -rf.
>=20
> Also there's no need for FEATURE-DUMP.libbpf and bpf_helper_defs.h
> files in .gitignore anymore.
>=20
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>


Acked-by: Song Liu <songliubraving@fb.com>

[...]
