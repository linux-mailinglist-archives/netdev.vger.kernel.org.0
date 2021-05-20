Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66209389CB3
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 06:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbhETE2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 00:28:15 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55104 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229436AbhETE2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 00:28:14 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14K4MqR2018990;
        Wed, 19 May 2021 21:26:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=bYlS6jxtsrzHZorXuw+4dHfR2Brt0DxIRZyyIq5P11o=;
 b=S9nYnmUYWnINUnV8ecsVOU0bhnMD8fDJdQO5dT8nm/eY4aL3khhrcP31ibU2WirG2NLq
 Z9e+zxmhm/+p5D9W0uIy/Budjl5E3DN/2PaysqktcmL63Xgi5Y5r2lIc4rl12JZFjfbT
 0IN4QrRjptdhGnoiyS2oQswjI4RPFwAGlWU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38n979j9pf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 May 2021 21:26:37 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 21:26:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jW2U2MAkX4ifXslYCj34RGhdcIhgqDSyGL3yZmXrKiUnohjI5/YnVVwNKSUG8lGZaYknTZ22R3lXPKYGHVp0SQvz9OBPBHFy5AR1fIksBBZj+bc856wU99edxgvyHQD0HAZu0NWrDjeLyeJEl7JiyxEqfnM8ZarJcD+OLLxmIUTo4PggSVnlhHs1JFKpR8nc7KqDtFADT0IDxKAFzZvt9tYIoLjmFwhr9H5gPltzWs59+CZ1prcWttXpQO7AHLKggjup3tzNgVxRvB/qdqLQRlrsEYDmFwp2/0d7rRCrAHikHfXECJxutpNyU9QS2dek9nGWlLg9msq15GaYFlQm3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bYlS6jxtsrzHZorXuw+4dHfR2Brt0DxIRZyyIq5P11o=;
 b=M6UNpzUBP5TRInj/twZZnzC4SSHnw9l9xbd9VqgCQhsbsZFC784mNr86ybA33R00lXIh/uVX8RYrdNwJMTCijLYBdqbdGyHGCESx7ifG1MRYbGL2F4UfuoQ7MAZzLT8/t0AdjNAUr2gNsIi6KfywfdCaHoNHPBvECn3mxIo5nRR9huFlm5RLQ/4zcUuXVI33BtEsG9z0h22CktoZStg4JKFt0rWPJUNJtbp5Ps7HccMXITxzt2Xdvl/nTM1B41i3wyoGCRMya1m1brXjg+SthY/OBi9g9t9bAeJD2yrT4K6vOFgDsqIuIJ33Tfq0AdGT6XN1wF7ia/pbcOjBv5OCbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2583.namprd15.prod.outlook.com (2603:10b6:a03:156::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Thu, 20 May
 2021 04:26:28 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 04:26:28 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Dmitrii Banshchikov <me@ubique.spb.ru>
CC:     "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>, Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next 06/11] bpfilter: Add struct match
Thread-Topic: [PATCH bpf-next 06/11] bpfilter: Add struct match
Thread-Index: AQHXS2+JHHyJ2nZ17kaLv51q7Vetp6rrybgA
Date:   Thu, 20 May 2021 04:26:28 +0000
Message-ID: <F674F162-FBC0-4F2C-B8A1-BCDD015FFA3F@fb.com>
References: <20210517225308.720677-1-me@ubique.spb.ru>
 <20210517225308.720677-7-me@ubique.spb.ru>
In-Reply-To: <20210517225308.720677-7-me@ubique.spb.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.80.0.2.43)
authentication-results: ubique.spb.ru; dkim=none (message not signed)
 header.d=none;ubique.spb.ru; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:fa93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60faa0c2-80e5-4786-a38b-08d91b476ff2
x-ms-traffictypediagnostic: BYAPR15MB2583:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2583462742D3B5F4C7EFEEC5B32A9@BYAPR15MB2583.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:538;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LIONnMAqo0ewNYzKuizY83w6pPfiL+muIUUULssGML3y9oPkYJSkICCCNSU4/bwWfz4qRQoJtjhQzQqFCVEXvbo4ClR9y12pvPG3CUOiWBLuYSEWtOUJT3GMCl7yl+Yl0I61VCkcyikLYcYucDXtO1xhxCM+DRyOop/qddQwk796HjC+YROrpRVwvIaE5hZtCR8ECEn8n6WM8nWYFgQhhwydPO/Yb1NFin//rS8/Nb7lDivqC7y1qvq09RGM5YYRNdKbG+d2gbMgYohuDnIKvJXAGbAJEdPJJvbjRiikLdD2vjbWQpLoMPHKWNAaTkHk9ulf42JcOe5FSP3cw7YZv+fJONAt1LYvbuacUYV2CI2pYLtgbHASdt+RVDIdp6TNcKiP2YYWDzFlMaWuYffaY3eLEnlDNTnC0W/rpjmsPtqBZrZzCgK0mmHvGDDqPMz9LoCshH1+vtUk+G7CDdM589wrnrjnZ1mxfnScU8rmXBybq7dhxdi9lQGZfKy8gczpKC7fCBKeMGQjtGou7Qg9qr6W5miTyzpCAzZWa2suDxxwfeseSYxV0oEwshc2T0quNfeRpx/A4aDLD4ZQR07Zf/WJjNvlP5wVJHQU7ul8cEXmy4PhRBiVY5Cl5fFKc2rXoKNLpLRXMn+K5J1zBRoudaGisG+agdoLHt+Ui9GEU2A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(346002)(366004)(376002)(136003)(4326008)(122000001)(8936002)(6916009)(36756003)(6486002)(86362001)(5660300002)(38100700002)(54906003)(66946007)(186003)(33656002)(71200400001)(478600001)(316002)(6512007)(66476007)(2906002)(91956017)(2616005)(6506007)(8676002)(53546011)(76116006)(66446008)(66556008)(64756008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?9tnXI/Y/jBTl778eiLF17hWkwW1se9jmW7LJPR7AdlbPdBd95sYTfxXHchFV?=
 =?us-ascii?Q?Gqyy893hZuX0po5WhcMZHY+T73okQq/N60PLQPBErviT1Q8JOCXTeHIq+oXX?=
 =?us-ascii?Q?RnCFsp/P4nvCoeTu68t5nRUAY3+GQADJzL/+cqH7wwzX9qa/AWXziZUjLaQ1?=
 =?us-ascii?Q?dezieQtNQlQC7wVuWI+ivRZtWnWiu84M5IrmhGJdMrYxTbaHkKAIBlBVaifw?=
 =?us-ascii?Q?KEJsGmD620deR9XC+RuDSqXlbJoC6uJdfOr6b6hYtaZZVfeftVdKo1pKD3yu?=
 =?us-ascii?Q?8CcgJ3woWiRJccQGoBxc/ikl1FTdPwFxUF1HRLCHmdYqUL8sFDUFjAkXPYRX?=
 =?us-ascii?Q?PRBlvJDz47x9PzK/Hea0WtIfhedz0sK0DLCQBvOkq5SRApo2ptMsBms28iNg?=
 =?us-ascii?Q?mU+N65HwUsF3IRW83vYWpHiPQLRK0GzZwnq7oNJmxSj9ikk0nHkTMfhhL/QL?=
 =?us-ascii?Q?oEmqwUFWs6hxslIhlTZViwGZkSw/LIKdzmIs+85eHNvlyz1r5TpKz4DERqfJ?=
 =?us-ascii?Q?wrxZ3Q5WzcPHvcS80dPZ5Xj0Je3BW9zRHqOqq21p7CmpWnrl7UeKGvGN0ESf?=
 =?us-ascii?Q?Umt1CUtlDRu+jvkMtbdrw4aaT4yf1LktOqzoRA/6ckjVokA2bVTLtuA7xEIg?=
 =?us-ascii?Q?AYfBIChEi2rZt1jEur8WraKWNQ/x1NZmzRpW9ZTorc4QVcDhMEQKlznXWzn8?=
 =?us-ascii?Q?H50iT8lVds6TJsKW+LwWfmclmOFR12iIlzAm1MXIhFR9mCxdcoxOqJoQzs8T?=
 =?us-ascii?Q?mXEYYkBXD12jcwil3iJKLHxLpPVNk2cZEE2wEz754S2vLCtSFvlX8aOiXV4Q?=
 =?us-ascii?Q?JjK+Vl/Rhps/hlpf0moHpF85jo7AmkmZ0GE6q0kTrgNEXou5nGPRJCjlj7zl?=
 =?us-ascii?Q?XE0p9lpwb9nEBMvjQ/yxyyCk4PBTx5mNv6duEGcdwlxo3ifAQB/G0RdDyoJM?=
 =?us-ascii?Q?NVx6phMc/cca5RfS+4/RsGISgu+OB1Xu6ilSFLNlhRSemlArg9I9rUqhB5Ci?=
 =?us-ascii?Q?zPJ3BaCsIeG6GdDqg94YhgSzaAgw7vIY0fOuKtHmx4dIwFe7vEq3rB47IJ9G?=
 =?us-ascii?Q?xmstQnnOAieFa0eF8thmUvyQaq2L+St5hOrBHZJW2UQM6tKn2OhXWwBJ84wP?=
 =?us-ascii?Q?y2ziAZi5Cb03SwVctVFTMJPoa7RsmshRWiklJmcLSkdUMKb3frNl0CqOezJh?=
 =?us-ascii?Q?B9xJWH6SxJGZDr0Um34EfOZwHEPk0C7jbS1GEl9jPkBQNxz191wQ6A6LyDmY?=
 =?us-ascii?Q?B16KPzO6IBiluhHFnoOTWrNoD0zfTCRpQPwajRLlXskq6xbrRvF+7H01px7V?=
 =?us-ascii?Q?4gckSs1MVCfKNrsqoW+hcZdFYb9GRpjOORfKoU7XTbbREHR94CcIfI8ulMuB?=
 =?us-ascii?Q?OLzJgyU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <847E0353B94DA74480EA9A03E5A23E99@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60faa0c2-80e5-4786-a38b-08d91b476ff2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2021 04:26:28.3167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dxN8YrHRAp1SfvAGMIFWFuC6+T+y/JHzAyTGSurWba+b0e0pfb4bs5R/YOXnrhs1iS1yPB8+OsAmVB4elyQU2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2583
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: ll4DfXq_ySFn06kODJDDFVW0MxA1qfTM
X-Proofpoint-GUID: ll4DfXq_ySFn06kODJDDFVW0MxA1qfTM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_10:2021-05-19,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 suspectscore=0 clxscore=1011 priorityscore=1501 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200034
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 17, 2021, at 3:53 PM, Dmitrii Banshchikov <me@ubique.spb.ru> wrote=
:
>=20
> struct match_ops defines polymorphic interface for matches. A match
> consists of pointers to struct match_ops and struct xt_entry_match which
> contains a payload for the match's type.
>=20
> All match_ops are kept in map match_ops_map by their name.
>=20
> Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
>=20
[...]

> diff --git a/net/bpfilter/match-ops-map.h b/net/bpfilter/match-ops-map.h
> new file mode 100644
> index 000000000000..0ff57f2d8da8
> --- /dev/null
> +++ b/net/bpfilter/match-ops-map.h
> @@ -0,0 +1,48 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2021 Telegram FZ-LLC
> + */
> +
> +#ifndef NET_BPFILTER_MATCH_OPS_MAP_H
> +#define NET_BPFILTER_MATCH_OPS_MAP_H
> +
> +#include "map-common.h"
> +
> +#include <linux/err.h>
> +
> +#include <errno.h>
> +#include <string.h>
> +
> +#include "match.h"
> +
> +struct match_ops_map {
> +	struct hsearch_data index;
> +};

Do we plan to extend match_ops_map? Otherwise, we can just use=20
hsearch_data in struct context.=20

> +
> +static inline int create_match_ops_map(struct match_ops_map *map, size_t=
 nelem)
> +{
> +	return create_map(&map->index, nelem);
> +}
> +
> +static inline const struct match_ops *match_ops_map_find(struct match_op=
s_map *map,
> +							 const char *name)
> +{
> +	const size_t namelen =3D strnlen(name, BPFILTER_EXTENSION_MAXNAMELEN);
> +
> +	if (namelen < BPFILTER_EXTENSION_MAXNAMELEN)
> +		return map_find(&map->index, name);
> +
> +	return ERR_PTR(-EINVAL);
> +}
> +
> +static inline int match_ops_map_insert(struct match_ops_map *map, const =
struct match_ops *match_ops)
> +{
> +	return map_insert(&map->index, match_ops->name, (void *)match_ops);
> +}
> +
> +static inline void free_match_ops_map(struct match_ops_map *map)
> +{
> +	free_map(&map->index);
> +}
> +
> +#endif // NET_BPFILTER_MATCT_OPS_MAP_H
> diff --git a/net/bpfilter/match.c b/net/bpfilter/match.c
> new file mode 100644
> index 000000000000..aeca1b93cd2d
> --- /dev/null
> +++ b/net/bpfilter/match.c
> @@ -0,0 +1,73 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2021 Telegram FZ-LLC
> + */
> +
> +#define _GNU_SOURCE
> +
> +#include "match.h"
> +
> +#include <linux/err.h>
> +#include <linux/netfilter/xt_tcpudp.h>

Besides xt_ filters, do we plan to support others? If so, we probably=20
want separate files for each of them.=20

> +
> +#include <errno.h>
> +#include <string.h>
> +
> +#include "bflog.h"
> +#include "context.h"
> +#include "match-ops-map.h"
> +
> +#define BPFILTER_ALIGN(__X) __ALIGN_KERNEL(__X, __alignof__(__u64))
> +#define MATCH_SIZE(type) (sizeof(struct bpfilter_ipt_match) + BPFILTER_A=
LIGN(sizeof(type)))
> +
> +static int udp_match_check(struct context *ctx, const struct bpfilter_ip=
t_match *ipt_match)
> +{
> +	const struct xt_udp *udp;
> +
> +	udp =3D (const struct xt_udp *)&ipt_match->data;
> +
> +	if (udp->invflags & XT_UDP_INV_MASK) {
> +		BFLOG_DEBUG(ctx, "cannot check match 'udp': invalid flags\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +const struct match_ops udp_match_ops =3D { .name =3D "udp",

And maybe we should name this one "xt_udp"?=20

> +					 .size =3D MATCH_SIZE(struct xt_udp),
> +					 .revision =3D 0,
> +					 .check =3D udp_match_check };
> +
> +int init_match(struct context *ctx, const struct bpfilter_ipt_match *ipt=
_match, struct match *match)
> +{
> +	const size_t maxlen =3D sizeof(ipt_match->u.user.name);
> +	const struct match_ops *found;
> +	int err;
> +
> +	if (strnlen(ipt_match->u.user.name, maxlen) =3D=3D maxlen) {
> +		BFLOG_DEBUG(ctx, "cannot init match: too long match name\n");
> +		return -EINVAL;
> +	}
> +
> +	found =3D match_ops_map_find(&ctx->match_ops_map, ipt_match->u.user.nam=
e);
> +	if (IS_ERR(found)) {
> +		BFLOG_DEBUG(ctx, "cannot find match by name: '%s'\n", ipt_match->u.use=
r.name);
> +		return PTR_ERR(found);
> +	}
> +
> +	if (found->size !=3D ipt_match->u.match_size ||
> +	    found->revision !=3D ipt_match->u.user.revision) {
> +		BFLOG_DEBUG(ctx, "invalid match: '%s'\n", ipt_match->u.user.name);
> +		return -EINVAL;
> +	}
> +
> +	err =3D found->check(ctx, ipt_match);
> +	if (err)
> +		return err;
> +
> +	match->match_ops =3D found;
> +	match->ipt_match =3D ipt_match;
> +
> +	return 0;
> +}
> diff --git a/net/bpfilter/match.h b/net/bpfilter/match.h
> new file mode 100644
> index 000000000000..79b7c87016d4
> --- /dev/null
> +++ b/net/bpfilter/match.h
> @@ -0,0 +1,34 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2021 Telegram FZ-LLC
> + */
> +
> +#ifndef NET_BPFILTER_MATCH_H
> +#define NET_BPFILTER_MATCH_H
> +
> +#include "../../include/uapi/linux/bpfilter.h"
> +
> +#include <stdint.h>
> +
> +struct bpfilter_ipt_match;
> +struct context;
> +struct match_ops_map;
> +
> +struct match_ops {
> +	char name[BPFILTER_EXTENSION_MAXNAMELEN];

BPFILTER_EXTENSION_MAXNAMELEN is 29, so "size" below is mis-aligned. I gues=
s
we can swap size and revision.=20

> +	uint16_t size;
> +	uint8_t revision;
> +	int (*check)(struct context *ctx, const struct bpfilter_ipt_match *ipt_=
match);
> +};
> +
> +extern const struct match_ops udp_match_ops;
> +
> +struct match {
> +	const struct match_ops *match_ops;
> +	const struct bpfilter_ipt_match *ipt_match;
> +};

[...]

