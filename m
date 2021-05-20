Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E206F389CBC
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 06:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhETEi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 00:38:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35346 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229449AbhETEi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 00:38:26 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14K4XenI026933;
        Wed, 19 May 2021 21:36:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=fBMAI8PuV2bQy/RdRzqoJWEuh111ivqKDKWld++mpGc=;
 b=YFdbL6HdeScPMClCQ14+eup8a0dHIRa/0AHmCYn0REjWNiOXTWbOczVw+O2FxEjXzGZt
 5/9XI+83mEvgBkbOMdduWdyf3K81qPlrQeLktsdOlW/VArYF4qtoGRTzX3gU4gKVA5Yb
 +uOhqZ2xTN/Lv44XgUgUvfiwIKl5gTfW6eg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 38n6p2ub4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 May 2021 21:36:48 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 21:36:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCH0zxQeT9RvgPxigWtAWupr89H0wwG1nnx/YGuD22gqOBfPD9O77Tj0gwAFbX8ukAkZ5pyOHsCc3lovXiBGBTjL6rpHcZf+715uDmDjxIjeKtxlcsXamPPlRK86wpNELFn52RB/HLkc432GXoJIU+xT4WvI+5kmEL/kAj7YL9qmZuCXo64hlqGJ//FSkieuV2V5KeoMairmwtwDxaAW9ptjxnzzXUTEJfqCxdTVXiDSr5J4/2lXRZaFP4ZRBPYpTRmpve21dXyj5OTi1iEt6TmARuvJOEtYlDRsd0ve2CfJhICkzYqcrAakHlweHID9Kt4oxOPNFa9XEWwWHjg1Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBMAI8PuV2bQy/RdRzqoJWEuh111ivqKDKWld++mpGc=;
 b=mZ6HTE9/n1732xYlhn0xQ7VP+vXbbChHF576hga5Z5uvpOtNlbjCQQPtK7bmxTtnfM90RlD9QatDnqHdeQvkOh2i51iXTOKIeZm0SMRsL5f/j7BDXar+LU/3Gtgqph0CH9jqiknn13B/AWiXoBsUHugzlc+WmRaKIyD4i/nB3axwKgAV4ATLcEvQjIF0RgNd4TNaX0m2hkoETTOjq5yO8p2emGYyRN9ZxjL77uyCuwb6TeOf4uHB1O5sAlo4DywTkf4NYFXmhEmwQzYdnqV6QOnWUHdl9BXzsExqSUgDd4LBCfV8xVjD/uKIXvMeUFxA3eZbF25MeCHf9XGO6M4kVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2263.namprd15.prod.outlook.com (2603:10b6:a02:87::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Thu, 20 May
 2021 04:36:46 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 04:36:46 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Dmitrii Banshchikov <me@ubique.spb.ru>
CC:     "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, "ast@kernel.org" <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        "Yonghong Song" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next 07/11] bpfilter: Add struct target
Thread-Topic: [PATCH bpf-next 07/11] bpfilter: Add struct target
Thread-Index: AQHXS2+U0kRPfs2C2kKsCTtHyaaCb6rrzJqA
Date:   Thu, 20 May 2021 04:36:46 +0000
Message-ID: <1B747351-8336-45FB-918D-5FC3DA18B47D@fb.com>
References: <20210517225308.720677-1-me@ubique.spb.ru>
 <20210517225308.720677-8-me@ubique.spb.ru>
In-Reply-To: <20210517225308.720677-8-me@ubique.spb.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.80.0.2.43)
authentication-results: ubique.spb.ru; dkim=none (message not signed)
 header.d=none;ubique.spb.ru; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:fa93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a816565-99f2-4bd7-22bf-08d91b48e02e
x-ms-traffictypediagnostic: BYAPR15MB2263:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2263AA52DB09B34E9ED2EE05B32A9@BYAPR15MB2263.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:364;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dj0T6G+cgp9FseWqBP0M2V6XPdntsss2JvvA6E+FLP5RS66TCPm9ARLdkIWVEXbBb7PL8hnzMXpbF99mdB/78Mu7GfXpzq+KihLYmPbukZxvDMD1R/3V+e4Sxh0wV7GV1Qow82ivhBtvlXCXPK1MlF3uDLFIkRw4L80uuvirx+Cgb90MCYrHqwLsy4Hl+Y193gIlv+BqGbHdF2gxphwL/uwRFjLRLqYttnsujrbk/d8WL+7Fyw63mvhmvNhqlXl+yoiMVS56c1olGZ4KOtktFyRYlCuMdL+e21BZ1QgghcidmSTXvxOiX1vs6h162T7tHgWGWH9MzdAZmTvbuHBZCO/1G4xeGIQmhCBzsPCCka/P2hhDeeeNU4H1xt9t20k2tVB04Tg3KVpNbNrA4yjexBouNEUC7sEEakLrulR7jvHqfoHAhoCmR71SZjjf0WSbfDCXhIpYh148AVUNJqnCaHdah3dZDiE9Ft8E46Tk007Pous+f5uFpipOQH4ih46dNa8zG76A8vIohkcgvN97NOBSWjgpZzsupS5ybIgK8TgdZ0FZ7jIY4y1U4YAU9/FkHq+0yuAQP6X19GtIpz6Q9Te26Iq+0SReZ/S9g9UP1DqA4nDDHGZMUsISfTEZawfkaXKPzJoD9vgk8UzawDJBVMzieOe0eACNwzZe7s/UcfA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(186003)(5660300002)(4326008)(478600001)(86362001)(71200400001)(53546011)(6506007)(33656002)(2616005)(122000001)(8936002)(8676002)(6512007)(6916009)(38100700002)(66946007)(2906002)(36756003)(66556008)(66476007)(64756008)(6486002)(66446008)(54906003)(76116006)(91956017)(316002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?JYEt9FCnbZg3FdAnIJQ8NS0KcrG8G+MAS7kNI6lwS0x8dmlwY8et3XcMa8RH?=
 =?us-ascii?Q?lUeXzxjf5wYwCr01YXik/MY4P5vQOw+hVpUoeafki7Kai/qxEkkXUXSpg+Ym?=
 =?us-ascii?Q?kRGshZSrmQvz1LY8M1rxfZZcvi792mIxDaCSbd3/l7qVwua/YLj50884kgOO?=
 =?us-ascii?Q?PHskMjoe6FDLKGKPNteCofS/w5F8OQun+z3Y0qUrkEAjn+zEeHy35xllKsYB?=
 =?us-ascii?Q?dOQc+tVYxYUmch/9fL0T4Ojhl9nzAiAjgbYzg/D8b0IBxTtgRmUKWukevI50?=
 =?us-ascii?Q?jOkFkj9hHRuDHNre/CiOCy1TMbvGrnQ0xTImhJMUBUtKmOE4AHUKGSuhuG/8?=
 =?us-ascii?Q?6JZygjEYfgLLpPMHDLmKNxxIhJlZ70Z+zbh3TzDV6bvpW+YoFW2NjlZ/Kvk2?=
 =?us-ascii?Q?z3BBVFmmAurgE4otqNj/3GkNXXC+7CsqBcVjAc2nZxDKfFoQ3Jm9qOFrsf20?=
 =?us-ascii?Q?kwTqYdyPBSLEa/nrN3u9Y41uayC1le1Fp8tc8dakRALSSMJ2LHU0JYcLSwoy?=
 =?us-ascii?Q?fQmKX75j/UBRHVVcnaab1rQncG1/uzaq0kqY7xvgxBslj0ucfj3reK6R7txE?=
 =?us-ascii?Q?D7j/nxVb4wuWcXwoP9iqegRb7I2SmTSQdpsN3EDtirUWzcGks+HsGpb6Ljst?=
 =?us-ascii?Q?H6JrBHecy3U00FgbYS1n7KwvtfLhG9wEwsfzmHuf8tIcvx4s0oZfpjshYEVS?=
 =?us-ascii?Q?49KdgHHEAXn7OphWkGTTnUlHfGkImS+g3lB8oHBumlkDZIsAKEiadzOCmlvw?=
 =?us-ascii?Q?fH/MeoGjgYND6a36dcHUti2qmpGuM0GwA+3DQx1V0HE7FESIUw7ttYaQWLwv?=
 =?us-ascii?Q?pYUG0hExs4B6CLnnwL7E/OlxwiOviey2Iys2bMTfhTdfPpsTmublP7X0xMQr?=
 =?us-ascii?Q?wlKd0T15MRvXXsOHC7ysyQ50anfcuC45kDPZkeTSCYxuGuaF2HUm/Yi2sEUC?=
 =?us-ascii?Q?f2WQWZWuCmlP6YsDCQbkE696hgF8wzweXOgYSBsJ/lbY0JttvaaOLQuRdYdr?=
 =?us-ascii?Q?+FDr7SXj5TqkKtXJwT/vO4qJXvXBJEJkAfVelM0jyicYp4dSBqrEluxonC58?=
 =?us-ascii?Q?drzCRh+yq298Ax0XJipTmNcKG84whxQI+GbMA7I8tHnN6IIJX1C/RRPs3zs9?=
 =?us-ascii?Q?J8XDNSu34MZVwEsPzOLY5NqaIaoEB8ewwhGG1j7nBbk2KTEXuaCtxoqCFtYw?=
 =?us-ascii?Q?3PIe/bEZHNcDtmu7daXMu/DQK/F8ptczixJJVe5mi07+BwhjhshZsmaeW4eC?=
 =?us-ascii?Q?Ho4m96Fy3GDsf9NWH/brjv4P3PBy4mn9gXCc7u5bmGLPvv27rRVcynaV4+L6?=
 =?us-ascii?Q?q8d6L8oFxU7eUIoF3KRR24ws2a4XcAX6iVt8w9YYpraJs/mr8L/pV4mj+BeX?=
 =?us-ascii?Q?klXpxiw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4B5BE390030D6F4E91030358C429271D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a816565-99f2-4bd7-22bf-08d91b48e02e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2021 04:36:46.1081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AbeHUYy2wL54IMLUSuFTX+zy7l7mz5KQlBHl+sMRptQa2wjYgM0jC4mBTpubZIhCeWEd2mT4DdJeQn2B9nolBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2263
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: ycZmjcZyCXwYglEPelMINYKPKZ3Uo06Y
X-Proofpoint-GUID: ycZmjcZyCXwYglEPelMINYKPKZ3Uo06Y
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_10:2021-05-19,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 suspectscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105200036
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 17, 2021, at 3:53 PM, Dmitrii Banshchikov <me@ubique.spb.ru> wrote=
:
>=20
> struct target_ops defines polymorphic interface for targets. A target
> consists of pointers to struct target_ops and struct xt_entry_target
> which contains a payload for the target's type.
>=20
> All target_ops are kept in map target_ops_map by their name.
>=20
> Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
>=20

[...]

> index 000000000000..6b65241328da
> --- /dev/null
> +++ b/net/bpfilter/target-ops-map.h
> @@ -0,0 +1,49 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2021 Telegram FZ-LLC
> + */
> +
> +#ifndef NET_BPFILTER_TARGET_OPS_MAP_H
> +#define NET_BPFILTER_TARGET_OPS_MAP_H
> +
> +#include "map-common.h"
> +
> +#include <linux/err.h>
> +
> +#include <errno.h>
> +#include <string.h>
> +
> +#include "target.h"
> +
> +struct target_ops_map {
> +	struct hsearch_data index;
> +};

Similar to 06/11, target_ops_map seems unnecessary. Also, do we need to=20
support non-xt targets?=20

> +
> +static inline int create_target_ops_map(struct target_ops_map *map, size=
_t nelem)
> +{
> +	return create_map(&map->index, nelem);
> +}
> +
> +static inline const struct target_ops *target_ops_map_find(struct target=
_ops_map *map,
> +							   const char *name)
> +{
> +	const size_t namelen =3D strnlen(name, BPFILTER_EXTENSION_MAXNAMELEN);
> +
> +	if (namelen < BPFILTER_EXTENSION_MAXNAMELEN)
> +		return map_find(&map->index, name);
> +
> +	return ERR_PTR(-EINVAL);
> +}
> +
> +static inline int target_ops_map_insert(struct target_ops_map *map,
> +					const struct target_ops *target_ops)
> +{
> +	return map_insert(&map->index, target_ops->name, (void *)target_ops);
> +}
> +
> +static inline void free_target_ops_map(struct target_ops_map *map)
> +{
> +	free_map(&map->index);
> +}
> +
> +#endif // NET_BPFILTER_TARGET_OPS_MAP_H
> diff --git a/net/bpfilter/target.c b/net/bpfilter/target.c
> new file mode 100644
> index 000000000000..a18fe477f93c
> --- /dev/null
> +++ b/net/bpfilter/target.c
> @@ -0,0 +1,112 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2021 Telegram FZ-LLC
> + */
> +
> +#define _GNU_SOURCE
> +
> +#include "target.h"
> +
> +#include <linux/err.h>
> +#include <linux/netfilter/x_tables.h>
> +
> +#include <errno.h>
> +#include <string.h>
> +
> +#include "bflog.h"
> +#include "context.h"
> +#include "target-ops-map.h"
> +

Please add some comments about convert_verdict.=20


> +static int convert_verdict(int verdict)
> +{
> +	return -verdict - 1;
> +}
> +
> +static int standard_target_check(struct context *ctx, const struct bpfil=
ter_ipt_target *ipt_target)
> +{
> +	const struct bpfilter_ipt_standard_target *standard_target;
> +
> +	standard_target =3D (const struct bpfilter_ipt_standard_target *)ipt_ta=
rget;
> +
> +	if (standard_target->verdict > 0)
> +		return 0;
> +
> +	if (standard_target->verdict < 0) {
> +		if (standard_target->verdict =3D=3D BPFILTER_RETURN)
> +			return 0;
> +
> +		switch (convert_verdict(standard_target->verdict)) {
> +		case BPFILTER_NF_ACCEPT:
> +		case BPFILTER_NF_DROP:
> +		case BPFILTER_NF_QUEUE:
> +			return 0;
> +		}
> +	}
> +
> +	BFLOG_DEBUG(ctx, "invalid verdict: %d\n", standard_target->verdict);
> +
> +	return -EINVAL;
> +}
> +
> +const struct target_ops standard_target_ops =3D {
> +	.name =3D "",
> +	.revision =3D 0,
> +	.size =3D sizeof(struct xt_standard_target),
> +	.check =3D standard_target_check,
> +};
> +
> +static int error_target_check(struct context *ctx, const struct bpfilter=
_ipt_target *ipt_target)
> +{
> +	const struct bpfilter_ipt_error_target *error_target;
> +	size_t maxlen;
> +
> +	error_target =3D (const struct bpfilter_ipt_error_target *)&ipt_target;
> +	maxlen =3D sizeof(error_target->error_name);
> +	if (strnlen(error_target->error_name, maxlen) =3D=3D maxlen) {
> +		BFLOG_DEBUG(ctx, "cannot check error target: too long errorname\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +const struct target_ops error_target_ops =3D {
> +	.name =3D "ERROR",
> +	.revision =3D 0,
> +	.size =3D sizeof(struct xt_error_target),
> +	.check =3D error_target_check,
> +};
> +
> +int init_target(struct context *ctx, const struct bpfilter_ipt_target *i=
pt_target,
> +		struct target *target)
> +{
> +	const size_t maxlen =3D sizeof(ipt_target->u.user.name);
> +	const struct target_ops *found;
> +	int err;
> +
> +	if (strnlen(ipt_target->u.user.name, maxlen) =3D=3D maxlen) {
> +		BFLOG_DEBUG(ctx, "cannot init target: too long target name\n");
> +		return -EINVAL;
> +	}
> +
> +	found =3D target_ops_map_find(&ctx->target_ops_map, ipt_target->u.user.=
name);
> +	if (IS_ERR(found)) {
> +		BFLOG_DEBUG(ctx, "cannot find target by name: '%s'\n", ipt_target->u.u=
ser.name);
> +		return PTR_ERR(found);
> +	}
> +
> +	if (found->size !=3D ipt_target->u.target_size ||
> +	    found->revision !=3D ipt_target->u.user.revision) {
> +		BFLOG_DEBUG(ctx, "invalid target: '%s'\n", ipt_target->u.user.name);
> +		return -EINVAL;
> +	}
> +
> +	err =3D found->check(ctx, ipt_target);
> +	if (err)
> +		return err;
> +
> +	target->target_ops =3D found;
> +	target->ipt_target =3D ipt_target;
> +
> +	return 0;
> +}
> diff --git a/net/bpfilter/target.h b/net/bpfilter/target.h
> new file mode 100644
> index 000000000000..5d9c4c459c05
> --- /dev/null
> +++ b/net/bpfilter/target.h
> @@ -0,0 +1,34 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2021 Telegram FZ-LLC
> + */
> +
> +#ifndef NET_BPFILTER_TARGET_H
> +#define NET_BPFILTER_TARGET_H
> +
> +#include "../../include/uapi/linux/bpfilter.h"
> +
> +#include <stdint.h>
> +
> +struct context;
> +struct target_ops_map;
> +
> +struct target_ops {
> +	char name[BPFILTER_EXTENSION_MAXNAMELEN];
> +	uint16_t size;

Mis-aligned "size".=20

> +	uint8_t revision;
> +	int (*check)(struct context *ctx, const struct bpfilter_ipt_target *ipt=
_target);
> +};
> +
> +struct target {
> +	const struct target_ops *target_ops;
> +	const struct bpfilter_ipt_target *ipt_target;
> +};
> +
> +extern const struct target_ops standard_target_ops;
> +extern const struct target_ops error_target_ops;
> +
> +int init_target(struct context *ctx, const struct bpfilter_ipt_target *i=
pt_target,
> +		struct target *target);
> +
> +#endif // NET_BPFILTER_TARGET_H
> diff --git a/tools/testing/selftests/bpf/bpfilter/.gitignore b/tools/test=
ing/selftests/bpf/bpfilter/.gitignore
> index e5073231f811..1856d0515f49 100644
> --- a/tools/testing/selftests/bpf/bpfilter/.gitignore
> +++ b/tools/testing/selftests/bpf/bpfilter/.gitignore
> @@ -2,3 +2,4 @@
> test_io
> test_map
> test_match
> +test_target
> diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testin=
g/selftests/bpf/bpfilter/Makefile
> index 362c9a28b88d..78da74b9ee68 100644
> --- a/tools/testing/selftests/bpf/bpfilter/Makefile
> +++ b/tools/testing/selftests/bpf/bpfilter/Makefile
> @@ -11,6 +11,7 @@ CFLAGS +=3D -Wall -g -pthread -I$(TOOLSINCDIR) -I$(APID=
IR) -I$(BPFILTERSRCDIR)
> TEST_GEN_PROGS +=3D test_io
> TEST_GEN_PROGS +=3D test_map
> TEST_GEN_PROGS +=3D test_match
> +TEST_GEN_PROGS +=3D test_target
>=20
> KSFT_KHDR_INSTALL :=3D 1
>=20
> @@ -19,4 +20,6 @@ include ../../lib.mk
> $(OUTPUT)/test_io: test_io.c $(BPFILTERSRCDIR)/io.c
> $(OUTPUT)/test_map: test_map.c $(BPFILTERSRCDIR)/map-common.c
> $(OUTPUT)/test_match: test_match.c $(BPFILTERSRCDIR)/match.c $(BPFILTERSR=
CDIR)/map-common.c \
> -	$(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/bflog.c
> +	$(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/bflog.c $(BPFILTERSRCDIR)=
/target.c
> +$(OUTPUT)/test_target: test_target.c $(BPFILTERSRCDIR)/target.c $(BPFILT=
ERSRCDIR)/map-common.c \
> +	$(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/bflog.c $(BPFILTERSRCDIR)=
/match.c
> diff --git a/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h b/tools=
/testing/selftests/bpf/bpfilter/bpfilter_util.h
> new file mode 100644
> index 000000000000..d82ff86f280e
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
> @@ -0,0 +1,31 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef BPFILTER_UTIL_H
> +#define BPFILTER_UTIL_H
> +
> +#include <linux/bpfilter.h>
> +#include <linux/netfilter/x_tables.h>
> +
> +#include <stdio.h>
> +
> +static inline void init_standard_target(struct xt_standard_target *ipt_t=
arget, int revision,
> +					int verdict)
> +{
> +	snprintf(ipt_target->target.u.user.name, sizeof(ipt_target->target.u.us=
er.name), "%s",
> +		 BPFILTER_STANDARD_TARGET);
> +	ipt_target->target.u.user.revision =3D revision;
> +	ipt_target->target.u.user.target_size =3D sizeof(*ipt_target);
> +	ipt_target->verdict =3D verdict;
> +}
> +
> +static inline void init_error_target(struct xt_error_target *ipt_target,=
 int revision,
> +				     const char *error_name)
> +{
> +	snprintf(ipt_target->target.u.user.name, sizeof(ipt_target->target.u.us=
er.name), "%s",
> +		 BPFILTER_ERROR_TARGET);
> +	ipt_target->target.u.user.revision =3D revision;
> +	ipt_target->target.u.user.target_size =3D sizeof(*ipt_target);
> +	snprintf(ipt_target->errorname, sizeof(ipt_target->errorname), "%s", er=
ror_name);
> +}
> +
> +#endif // BPFILTER_UTIL_H
>=20
[...]
>=20

