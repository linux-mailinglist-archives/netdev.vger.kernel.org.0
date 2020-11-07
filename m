Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051412AA202
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 02:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgKGB2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 20:28:05 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52126 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727129AbgKGB2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 20:28:05 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A71OpJp013186;
        Fri, 6 Nov 2020 17:27:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=L6n60Z8KNtShaBheCby6fZXpeFCLJadFXQiTXK2pf/U=;
 b=oZFBxljRNFSs6UKBxf+hvkqqsnVBj+QjoZSDQLwoC8kmzjqz7wLxnNw58C3wGcb/nmZU
 LXxs2pbSQM0e0R5r8bfY54lD0VID8n0JTamqK4UB/FM3gMx8Z26oEKamo2vx/d7qkAtX
 7nhHBqHRZoY0IGqAz38Oo69NWRz+xiTmpC4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34mr9bfeh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 06 Nov 2020 17:27:47 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 6 Nov 2020 17:27:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i6Cb7MAQbeuRWR3FSiWBEdpAeuSEqWAdhZNU3ZkliUruNv7x3lrpZCavNDkwXpl5tfcyrELJsB1amgQSPv++uxeaH3AtXW+Ksucg6g9N39IH4qq1RK76JZQ7QpNuvwqkK/DhA81/y08VlA3bhcU4UFQL2u9l0ve54FgSTnrOqFp+J/G9HxDC0zn7LrOpOAPI9huLx3+TbUabZ7kLoVQt8dgXUA86+kl8pQybY9eWryaxrYi9IeDqFFYcxBZPvM7XD972qKlFbWd/4N36wsDHC1NX8/otynGfjjQTlkgG1KeXrbIVJR3XPURlq7WTDCdvOPQAJugesFZkSP46VuyRkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6n60Z8KNtShaBheCby6fZXpeFCLJadFXQiTXK2pf/U=;
 b=gPwwtr1cTRQy2CLEqJSHyC0a0Nao7Yaad3Gn43ICEBWzZO7Sn1k0UfHODR+JfEax/YfQQ8DKF4bYJAUlHGwLrAXdtAOsExG06gCl2b2I7Mrk2EelPeviyoLNhoXjZBCbuUk+aLJMe24KLgxCodtzrOurYXiVNm3OQBgAvryM1QoNswN93FOkbFv4eNFrma7hnw6GxRUOMQ9Pt5j3fhLD4g1jJKMJu0JYHAeAYTrfzLIr8BgwpORj/3BTGwn9SmOYYkrVZfK/G1j9tuE0HjHUUDLiVHaBs+yWGPlWleA6ZW6hfPEJoM0Yb0VL0TlrZJ/FivGRhO0RRRUv44RHci5dRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6n60Z8KNtShaBheCby6fZXpeFCLJadFXQiTXK2pf/U=;
 b=DGWYodJDwiZUhnqOiecHm7dPAg4CSD8E3C8BjKLf7avZ6HBOZmrsGvNZu4ihhq/J4FnmFjuDptY3ZptIaneOWvuu8OQUZ645CPiTEbb5ojj1l7wfbpCRtdpA9MDWQosvAEva/OzMj+hZXb6fLhRK+3ENGNnu/bY0z2d1M5VbaJs=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3713.namprd15.prod.outlook.com (2603:10b6:a03:1f8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Sat, 7 Nov
 2020 01:27:41 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.030; Sat, 7 Nov 2020
 01:27:41 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 bpf-next 1/5] bpf: add in-kernel split BTF support
Thread-Topic: [PATCH v2 bpf-next 1/5] bpf: add in-kernel split BTF support
Thread-Index: AQHWtJFbvugjqI1ENU6MqzyHA3nlY6m74ToA
Date:   Sat, 7 Nov 2020 01:27:41 +0000
Message-ID: <712CED9D-91E3-4CF1-AAFC-3E970582D06D@fb.com>
References: <20201106230228.2202-1-andrii@kernel.org>
 <20201106230228.2202-2-andrii@kernel.org>
In-Reply-To: <20201106230228.2202-2-andrii@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:ca49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81fff83d-165c-4457-4f8c-08d882bc5222
x-ms-traffictypediagnostic: BY5PR15MB3713:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB3713032D8B1B05777DF636F0B3EC0@BY5PR15MB3713.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r8TzrZpuu5pCQJsJ0mZ7yObDPcPuVydsPFlC1gm0iq5SJpS3Hzh/ETWVo2ZQZzJQwHGJiN8h63xT436dU7ou2F5qsjozEun+SzMp77seDc7Ve8n4SOdpr5wvh56i80B+QcQEcH/Fl1O+wycRbYeIuOx7KVgSuyrQnMFn2AKW/niMLxcenVZP4uKJzamiqwMumLA9uQMh7a6uLj8YeNgPj5ceQ2SMJ/cnI6PbfIQUPBWM5YlrrthJP8mN0r80vuBfMP8ZJM8yXmrw5eAyTJQPlOV+A4Miqo7r6I2fYOOtuIQEG4AQCK3MjSW+zZrQtzlr+/hfGhS5Tfx6siV2a9ZwcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(366004)(39860400002)(376002)(6486002)(66946007)(66446008)(33656002)(66476007)(6512007)(5660300002)(6916009)(53546011)(2906002)(36756003)(91956017)(76116006)(4326008)(64756008)(186003)(8676002)(66556008)(6506007)(83380400001)(86362001)(8936002)(316002)(2616005)(71200400001)(54906003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: MeKq0Ji0tv+fN0J6BaUddl5B95FVm0irPZTQ9HBerFsmiykxSbbdKt+bvAwLBmcOSvM/Zh3zx9aK7/Kcq3eMB4fKbCHzl771IgpxdEtSok9dvHmGIwg3g7K5u56XTIiIALbTBhK55k0qaYcHZYvMGPONxPuJAmT5rZeFDfRbCYgoSgT4aMKUNkcqoLksGVl+v8lKFq0SRfUtbGfu+33oEdqtafBCkAe2I6IE+Qd4km3VzOJG2Bqt0cuCf9Fa5lWv5YDuI0YibUZZi8CItRkIt9W361Cqiyhc1Jpij0WSrE8+sugODmpSK5z5EWQXFE4GXw6e5kle4GF5XPqweQvBbLVfWfpYP9dLEWNMeXn53hf+C0opdjArYzRDMocQdVu0BcunXOLkTSpvuX45ddsRHUPvt3svgBHGcTtSwLGXclXwbPNJGL8NRjjtjJHxp+GVo8rj2Sv4t8fRFfngypGxwwyGtO+fjfua13xXjYNqc+Ef5fJ33S8ndnjDDtosubX9sAd/af2UxK4l6yftzbdLNI5BEfrzGOQWXMOfJQkr4rq+9HmP8RFG8/TSGHOtQjZ9GMz1lN7dfo6t9QhPFUSxLI/t0aWmmN1BGXyS0UvhYN7oaCYpakamKHHcWQzocJrjoCDDAqFl1k4ODHu+CwZ3S8eDeq39Z/qkLDFKz2Lv5u9fLQZlmjCg7VMKvbF3kMi3
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5F8835E5381BF94D99BC38F893165B70@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81fff83d-165c-4457-4f8c-08d882bc5222
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2020 01:27:41.4968
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pXRhJaf2BvBeYLNAUdRyjQuWQrtM4U1DxCtLYRp/TPxR0z4bPv7oRmLoWPZhrxZMk5z1l7dx6ndVJ5x1lVdpFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3713
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_06:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 clxscore=1011 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 mlxscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011070006
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 6, 2020, at 3:02 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>=20
> Adjust in-kernel BTF implementation to support a split BTF mode of operat=
ion.
> Changes are mostly mirroring libbpf split BTF changes, with the exception=
 of
> start_id being 0 for in-kernel implementation due to simpler read-only mo=
de.
>=20
> Otherwise, for split BTF logic, most of the logic of jumping to base BTF,
> where necessary, is encapsulated in few helper functions. Type numbering =
and
> string offset in a split BTF are logically continuing where base BTF ends=
, so
> most of the high-level logic is kept without changes.
>=20
> Type verification and size resolution is only doing an added resolution o=
f new
> split BTF types and relies on already cached size and type resolution res=
ults
> in the base BTF.
>=20
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

[...]

>=20
> @@ -600,8 +618,15 @@ static const struct btf_kind_operations *btf_type_op=
s(const struct btf_type *t)
>=20
> static bool btf_name_offset_valid(const struct btf *btf, u32 offset)
> {
> -	return BTF_STR_OFFSET_VALID(offset) &&
> -		offset < btf->hdr.str_len;
> +	if (!BTF_STR_OFFSET_VALID(offset))
> +		return false;
> +again:
> +	if (offset < btf->start_str_off) {
> +		btf =3D btf->base_btf;
> +		goto again;

Can we do a while loop instead of "goto again;"?

> +	}
> +	offset -=3D btf->start_str_off;
> +	return offset < btf->hdr.str_len;
> }
>=20
> static bool __btf_name_char_ok(char c, bool first, bool dot_ok)
> @@ -615,10 +640,25 @@ static bool __btf_name_char_ok(char c, bool first, =
bool dot_ok)
> 	return true;
> }
>=20
> +static const char *btf_str_by_offset(const struct btf *btf, u32 offset)
> +{
> +again:
> +	if (offset < btf->start_str_off) {
> +		btf =3D btf->base_btf;
> +		goto again;
> +	}

Maybe add a btf_find_base_btf(btf, offset) helper for this logic?

> +
> +	offset -=3D btf->start_str_off;
> +	if (offset < btf->hdr.str_len)
> +		return &btf->strings[offset];
> +
> +	return NULL;
> +}
> +

[...]

> }
>=20
> const char *btf_name_by_offset(const struct btf *btf, u32 offset)
> {
> -	if (offset < btf->hdr.str_len)
> -		return &btf->strings[offset];
> -
> -	return NULL;
> +	return btf_str_by_offset(btf, offset);
> }

IIUC, btf_str_by_offset() and btf_name_by_offset() are identical. Can we
just keep btf_name_by_offset()?

>=20
> const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id)
> {
> -	if (type_id > btf->nr_types)
> -		return NULL;
> +again:
> +	if (type_id < btf->start_id) {
> +		btf =3D btf->base_btf;
> +		goto again;
> +	}

ditto, goto again..

[...]


