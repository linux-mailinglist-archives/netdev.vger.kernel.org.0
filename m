Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00192A11AB
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 00:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgJ3XdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 19:33:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59232 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725446AbgJ3XdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 19:33:10 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09UNNkrp016084;
        Fri, 30 Oct 2020 16:32:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=EpZCBsxsOi0jK2otB3h/H8O2eGQcK11LtjVOER195f8=;
 b=WnigxyMxpFoUDsdgDDj8BwDskRa9+2X7SJgL7dEpVxhNY37cwKm2CehDNZVWLUy1Y+Jk
 9IVsWGFJjxey0qdk828BO0kUxAJ7H6WUwbaLdJtxnQhtQH8KaUYDlYLQJre6paEKb2Xa
 3TK0Q8aN3scXBh1/vjXjhn4gHI9T2pvnEMw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34gpbt22gb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 30 Oct 2020 16:32:56 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 30 Oct 2020 16:32:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obeotBOwoWzjSWzUxLtg+zQIaOS0YR2jeSaHCIGlgxAQgNYeIU16Z5XE6K1VIGVwevfQOcXoT7KKAcSbIgy88IO125+kpWsNUhm6TZ/E0iedEmEDyl5Za/YCqWd79qia27iYO7QtwwaJi7jK5KBZauV9JCp0fhLVNbUdieFpy7DcPz4ADbN4BstQS3WXtpMr8EEBqyTLmdjdJGhksOOjbnrUpiULkR53h6ULjxayjEGOlVaCqq6YLu7a3xL3x34op31uQYgCUwmgMyOht3aVHDAx97gtfuWx8K/hU5GXXNHKespkS5W/JIsDC1ecj9lalo4waalxf+iPsQft/i/Wgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpZCBsxsOi0jK2otB3h/H8O2eGQcK11LtjVOER195f8=;
 b=GT+GyaBkNpmL2s/Xtid4DUqHZL1cw+nhNj0I9a52b9FhTkAh/1hgiY28EOopV3xb7fsfiVQf2PrUJ/iEnK5696T0iclvlUJRAQ7rJ+B+df4rAxAgQwidYeaAXe34DpVu8p7GVERrQ8WQmqEHrAljMdfFsdlFe5Gc3N2MVFcjU9LZ5Ojn0Kc6UkhjkJBdkLMi2Zjo3YLS0U9+FgrUOLQPUvJpx7BQ71HmDnMPVXkMjg13XUVGEa0AYSVDVuxa87Wy9RCgNccPEGKu3H0tzB9LBYlRlAxdEilFwUaDWh1tX3/EMS+103lpgC/2XGXTFPKMicwu8kBoR+lRLIaQBYnalQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpZCBsxsOi0jK2otB3h/H8O2eGQcK11LtjVOER195f8=;
 b=OT5EmA11C1ZTO5z52cbEs2qkLdOVCx6yIW3anww+CBS0WR5x2i9infJPpXeFn6BnjgMzg5LRj31K7c1B1XttmkjyOlUPfy2aUB8n46JWE3ICFJPJz9YX+/yrMowHkpz+sFgXA4hbfnfUqyWhlXq/I3y/M6OZjVacuwFq4LpVjQo=
Received: from BN8PR15MB2995.namprd15.prod.outlook.com (2603:10b6:408:8a::16)
 by BN8PR15MB3042.namprd15.prod.outlook.com (2603:10b6:408:91::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Fri, 30 Oct
 2020 23:32:53 +0000
Received: from BN8PR15MB2995.namprd15.prod.outlook.com
 ([fe80::440:b245:5cf:78c5]) by BN8PR15MB2995.namprd15.prod.outlook.com
 ([fe80::440:b245:5cf:78c5%3]) with mapi id 15.20.3477.035; Fri, 30 Oct 2020
 23:32:53 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 03/11] libbpf: unify and speed up BTF string
 deduplication
Thread-Topic: [PATCH bpf-next 03/11] libbpf: unify and speed up BTF string
 deduplication
Thread-Index: AQHWrY7M50nN44K9RUSYpme3cNWA7amwztoA
Date:   Fri, 30 Oct 2020 23:32:53 +0000
Message-ID: <11A01E1A-FBAC-490C-BFBC-CB7CF7F8E07A@fb.com>
References: <20201029005902.1706310-1-andrii@kernel.org>
 <20201029005902.1706310-4-andrii@kernel.org>
In-Reply-To: <20201029005902.1706310-4-andrii@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c2a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0be75be2-0cc7-408f-196b-08d87d2c1fa5
x-ms-traffictypediagnostic: BN8PR15MB3042:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR15MB3042CE1266C357AD86C6A36EB3150@BN8PR15MB3042.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tH8zGVgi/r1Pj9QqfHa7KoptAjPgCvf0ZBVl/KBOK7NlQfqUEZDwLzeRYQ/q6fpgJz3Kku5Ddj8WzlXc2nhozdf+/6+uDp7QXbKydZe2MGZJGDcj8Bm60oSZu5d+ezgAlUxrDhVytwbqbZJjCTxkTajrhhLiFZsSXqQQOngTUUOqVoQ9tu3BoleSMhXY/47Npa5Oz8/h56Me5r0i9zevBumW1EVsj42DyHa2AXdmfxUtt98ClaWpjtuXHvWke/Jum53PuwtEiwy7DKRie/dRZLjL0YbMniJ0elMg8kQ4Hh3APrrtifVS6xm+124rOq07IpTz0N4a17xC29sjfPnm4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR15MB2995.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39860400002)(136003)(366004)(66556008)(66946007)(66476007)(478600001)(2616005)(66446008)(86362001)(71200400001)(6916009)(186003)(2906002)(64756008)(4326008)(33656002)(83380400001)(316002)(54906003)(36756003)(76116006)(91956017)(6486002)(53546011)(8676002)(6512007)(6506007)(8936002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: lDVRN2iiVxgX0Mtz57hDhHTm3ycMtj1CQfzYgAcb5mthrqdBH308NkE8weXgUYf+eO2nt3ahkXZLyuUrz7xq/wzMqEQjBq9Tk7doBPEIxMDZqi0qrFu9uN2tJaR3YN8k3826tGYpvEToMnrherdtNuyKybI19Rh3YVLwZ0NxqWWc6GScBZ1emQilOgRKGVS5hXFMtPIijzG11v4RugYEIbxxGVemYrQhnuyCyTCuIKIFfaWT+gO57L+CYxe3Rana58Q8iRohhM0UtjTpX6NVbujA0eC5n1b9MJqz7cfmptdki683oRUuNLsEIqqLhZGqt3ZMLqkq0zL0mnMRyYU2bru1hnKAQLZ4yaklBknf9/03DMq2rA53DOBwYoFjeauo8yraVZ0Hs3GkGC+vDK+Id2sBC4+jiNXDTV+S6NWpctx4c/2yhjB0bMSFZJU0+GJf2wD25xsn5uObiFO+D1pADKy96wtP/jxlv/JHgw7qgz3SyC+04k//Tb9hKpPG7QWypczlS43eC9GYg+Xl9/rilYkkNfZIkNL2QFmo2F3oTyvCVCz+LKoFf3KWQ+0sVkF0XdybmpsLXEHnfR+FRhecmfdkAnU8L4pbDQlHJi3Z78tWmGN+Jxohdzy67HV2r8yCpM3eTb+8ztTYEFj2Genb4DgMBZ7QCdBOnWW5qvs3083ERqUIK0Mq16oVQGpwnqo8
Content-Type: text/plain; charset="us-ascii"
Content-ID: <44603A64EA4E26418DB756AEC4B92F3D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR15MB2995.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0be75be2-0cc7-408f-196b-08d87d2c1fa5
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2020 23:32:53.4342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YaHkOUp/HwQN5UNcrkIV/h45/XZfnfGGFQEexJpc6mLbW8BP97dwdUFYuoGPITVWkv++iQfK/LpQ22eBkFlmHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3042
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-30_13:2020-10-30,2020-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300177
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>=20
> From: Andrii Nakryiko <andriin@fb.com>
>=20
> Revamp BTF dedup's string deduplication to match the approach of writable=
 BTF
> string management. This allows to transfer deduplicated strings index bac=
k to
> BTF object after deduplication without expensive extra memory copying and=
 hash
> map re-construction. It also simplifies the code and speeds it up, becaus=
e
> hashmap-based string deduplication is faster than sort + unique approach.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

LGTM, with a couple nitpick below:

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> tools/lib/bpf/btf.c | 265 +++++++++++++++++---------------------------
> 1 file changed, 99 insertions(+), 166 deletions(-)
>=20
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 89fecfe5cb2b..db9331fea672 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -90,6 +90,14 @@ struct btf {
> 	struct hashmap *strs_hash;
> 	/* whether strings are already deduplicated */
> 	bool strs_deduped;
> +	/* extra indirection layer to make strings hashmap work with stable
> +	 * string offsets and ability to transparently choose between
> +	 * btf->strs_data or btf_dedup->strs_data as a source of strings.
> +	 * This is used for BTF strings dedup to transfer deduplicated strings
> +	 * data back to struct btf without re-building strings index.
> +	 */
> +	void **strs_data_ptr;
> +
> 	/* BTF object FD, if loaded into kernel */
> 	int fd;
>=20
> @@ -1363,17 +1371,19 @@ int btf__get_map_kv_tids(const struct btf *btf, c=
onst char *map_name,
>=20
> static size_t strs_hash_fn(const void *key, void *ctx)
> {
> -	struct btf *btf =3D ctx;
> -	const char *str =3D btf->strs_data + (long)key;
> +	const char ***strs_data_ptr =3D ctx;
> +	const char *strs =3D **strs_data_ptr;
> +	const char *str =3D strs + (long)key;

Can we keep using btf as the ctx here? "char ***" hurts my eyes...

[...]

> -	d->btf->hdr->str_len =3D end - start;
> +	/* replace BTF string data and hash with deduped ones */
> +	free(d->btf->strs_data);
> +	hashmap__free(d->btf->strs_hash);
> +	d->btf->strs_data =3D d->strs_data;
> +	d->btf->strs_data_cap =3D d->strs_cap;
> +	d->btf->hdr->str_len =3D d->strs_len;
> +	d->btf->strs_hash =3D d->strs_hash;
> +	/* now point strs_data_ptr back to btf->strs_data */
> +	d->btf->strs_data_ptr =3D &d->btf->strs_data;
> +
> +	d->strs_data =3D d->strs_hash =3D NULL;
> +	d->strs_len =3D d->strs_cap =3D 0;
> 	d->btf->strs_deduped =3D true;
> +	return 0;
> +
> +err_out:
> +	free(d->strs_data);
> +	hashmap__free(d->strs_hash);
> +	d->strs_data =3D d->strs_hash =3D NULL;
> +	d->strs_len =3D d->strs_cap =3D 0;
> +
> +	/* restore strings pointer for existing d->btf->strs_hash back */
> +	d->btf->strs_data_ptr =3D &d->strs_data;

We have quite some duplicated code in err_out vs. succeed_out cases.=20
How about we add a helper function, like

void free_strs_data(struct btf_dedup *d)
{
	free(d->strs_data);
	hashmap__free(d->strs_hash);
	d->strs_data =3D d->strs_hash =3D NULL;
	d->strs_len =3D d->strs_cap =3D 0;=09
}

?=
