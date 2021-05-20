Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA95338B565
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 19:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235115AbhETRqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 13:46:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11112 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231752AbhETRqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 13:46:19 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 14KHWLKW005193;
        Thu, 20 May 2021 10:44:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7F7cRuMuHAoYF6Lt1/buSmLf1eJMSY18rTWsRtPlNjE=;
 b=M1nrvdFLt8qAZfM6pQjxW9vtZeBB1X5BPKOzBNF/NXtJ/htblnQ90P8JbGyfnJQXY1x2
 dd7L9c4AAEhkQ80jtCFg/uF3tqk/SGP5Tn/aMZiuIejDGTb62nR33MeI1j9/RdqeI5aQ
 ls4pRhbCP/2NJilhCdZSNrSxtARRJaCw9cw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 38mt4tu61d-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 May 2021 10:44:41 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:44:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dNeq+Jg5TJLq+L6AflHVWRfxjyGMAixmWuB/HRnsKhqr8J1baNARlghIhfXGNgLqkR4TKKEzkW5aZDg6AI+Fj8hosRN44hwboOvHFgAkoRZe/VilFQ3W+8pgbFSJyqOserEICHhIwQgGS6LhtmteYi4AvUm/gndf6gXLvuh9XbAkwW5tW+Y3ftWdyc9VnoBKAeBYkZzluQGKpdi0AGpTThOMZ3VNUVoCDHqxQCWKMEVxTqzmJu7XAM7QPg0dMRbEJXjTO4hyrSjTSNoNSHh+WcZD0Ql3s/RvJ06ZQgJL5VLhIh8o51+xc2Fc1oHZPEM9eYMDdp5RrvwirRwnmLl2qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7F7cRuMuHAoYF6Lt1/buSmLf1eJMSY18rTWsRtPlNjE=;
 b=iN/NiQvqZKmZOi9UuXxIctH89vqz7d1jijQ60Wh4Ma7/dOQADRFunIgrf9h6lZaDgz314bChpQGiaq2oJzTySkW3QN4gpUiZL/p6QPHfL53VcmRKhVe9d9I0BUritiIZn+rHPnJt3JVRn5R88YPWcF+uVhiCKkAkUGuyR+VQTNfsoSEthDCxLEwvgmU0mmaglGqkqBOL2FJayTC9QW5ZYj9GpGuqqU1IvceX0qhWveAMG1aXZt23Du/Iokd39rvO3SGmgJKdVL9bSDBFKohEzhVpN9CD+C2oXeQ2M0L0RAnrNJZGS3Ch7/bShG6W2Rz5HHV3up6H6kJUCgJd9VwYQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4233.namprd15.prod.outlook.com (2603:10b6:a03:2ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Thu, 20 May
 2021 17:44:38 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 17:44:38 +0000
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
Thread-Index: AQHXS2+JHHyJ2nZ17kaLv51q7Vetp6rrybgAgAAzu4CAAKtIgA==
Date:   Thu, 20 May 2021 17:44:37 +0000
Message-ID: <CB97A458-90FA-46AF-96C2-6FB3F9139570@fb.com>
References: <20210517225308.720677-1-me@ubique.spb.ru>
 <20210517225308.720677-7-me@ubique.spb.ru>
 <F674F162-FBC0-4F2C-B8A1-BCDD015FFA3F@fb.com>
 <20210520073135.bpdtlbryvbp2olkf@amnesia>
In-Reply-To: <20210520073135.bpdtlbryvbp2olkf@amnesia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.80.0.2.43)
authentication-results: ubique.spb.ru; dkim=none (message not signed)
 header.d=none;ubique.spb.ru; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:fa93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3a1eb86-0897-4ef9-5668-08d91bb6f072
x-ms-traffictypediagnostic: SJ0PR15MB4233:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR15MB423372DDFC6F12930F1B8109B32A9@SJ0PR15MB4233.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A6kxY1bvH3DCkGFbiPN8eNPJeUBZNKDKjcuKSwHKXtb3NOiaS5q0IPp4NGJhwkXBP3bRrwX1nnXNj2I9Ord8yQri8CMYRzCP5YQYvc89MrN+7eznYAGCxdEsKRcE1mEVnobVrjVoB12MYH+LeFYOCxfymsdnlJkqZwEkQ4yHWR8bh92a+5s6pOTjo5rA47/6arRjmc0LHVLSV1e9A7355v8oJh8awYpsvXl2DXv3POWviSSC9hJ8/ob4qCNlMYEPChi+FKwaRviApwlBVvmvZZBZsSBfNYyxganBwAWYM+PukFCgvsEBYoKz/L5kq9eeQkXZLaPQCWNgpbUB5XtpcyLTkHx6enrefuQlYrVzCope/HZiuC9+9XM5DUkJfSr4LTXLlZxIR9/59N3qEpQQZqLejWg7R0ImViDElz3Nqippcz0io2mv2QLVAhRkkERU06A7pyNPdovvKgQFmOk7+0EbnR+T6Tjb18V7TyuTILooiV3DhNaM7aUUkFfQzpqS6DNFZ6bPa0OLmJ1vrNAJg27vQSBRaIsJFoLTda7KNSL3gWBTsCuS9YhRXQK7k8kNJgUWDr0B3Qhf4LQsNEMBluCj5mPerqP8jArJDp9VA6jB1c1RfweG7FY+YmFGuoziKEYB1rxutpCd1rwx6PUtpDKFZFKYtAhmv0uQ04dA6As=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(38100700002)(6506007)(122000001)(53546011)(86362001)(91956017)(478600001)(64756008)(2616005)(2906002)(66946007)(36756003)(66476007)(76116006)(66556008)(66446008)(8676002)(6916009)(8936002)(6512007)(54906003)(33656002)(316002)(5660300002)(6486002)(4326008)(186003)(71200400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?rTfaNQ+J8H//CJe6GhYk6J7Ai91BeCG5SPVTDtA7AJJwGl2rlBwh+oF7AL3y?=
 =?us-ascii?Q?CKKVNJAvLzLOgxjMfzVRH3yOSm7E1Uq+bXeHV9zMBzYkY4DDXvnZVTUCngRC?=
 =?us-ascii?Q?YeOUNS9DPHDQ0tXldcl5YlDkHj2sjPhn8Lum0kNQKKrkkCm4Z15jdla1MfTK?=
 =?us-ascii?Q?8S4CsSjMm0cefQW0xPet8lB9ylXMkRd6j+2CytTh0Z5LVp4MZLUsL9Q+9uHv?=
 =?us-ascii?Q?ztMP3ObkCqBHbqDnxSGVcqIhvQhPiHnXH8aV5/pT5lTdODZTNWFmZy/1nmnR?=
 =?us-ascii?Q?hHE5dDw5l4K+KI0yFHQwcO/0gDQMk4j46XLgykrMXWe3HQXG1giBSeSeviBn?=
 =?us-ascii?Q?b4/imtZmvZ6YaDKrrnwvwbiG0iPvrF2v1BNRMAZ2LH1Aee1684asDrKWEF4I?=
 =?us-ascii?Q?173hBsdq4ucnD/+T5szqRRPcqLu1JzdSKL65QnAsjZiWgpLXc6UCgQE364Fo?=
 =?us-ascii?Q?J6+ZK3gOKYnwalROk6kvwrSU/WIOsbXws8poJLcbz5GunDlJH6is9KtR6MJE?=
 =?us-ascii?Q?H6slWcXedF8ONnxu6Q9X6Yybi2ZZVs1+6+VYNWVF2iITqtApr3wJ3UfqMpme?=
 =?us-ascii?Q?yjqyy44Ba2DUBIO17TVxq8MVJkhEsaBJ0HeL7+A1eF01amgH1KksvBmGwSCW?=
 =?us-ascii?Q?lmPZXpa2MqyIJaQYrSAzJVU8aUC+kvtXvtqELIaJ8072UJvSc9yQKuZQyQ2c?=
 =?us-ascii?Q?wN2/X9uKMsNd7BHRbkuzce5ne5cSRJ4A9aQWt84w9sE9i7Fu895NtkAXvX8S?=
 =?us-ascii?Q?ANuVFvbIKJmwadbk7m5Lfz+/dox//T0xOrRMpB3YC6WdugTPwp5h5mSqb+aF?=
 =?us-ascii?Q?DIu0QNG2XBu0+2zGonOpA8qMkBrk1FBJ5GskffjnEcx1a/3IS5gIsyr9LUvW?=
 =?us-ascii?Q?qRtohsZ+nAysM0KVA9f0xcJHHlSB5jPCNl052r4TgMZj0Sp/LFv0vOmywbYY?=
 =?us-ascii?Q?KGSOr+mhehX9ETAmfjgLcJwBSRqFRwp2mgS4QOoDH0iJpuDqLdmedxuOc2Y5?=
 =?us-ascii?Q?2K0DiK1U6ln/hYU9S1KkR1eCN5I1aPrl4gVJNBfPQ1OxHaIsC1zf6XxfH/aN?=
 =?us-ascii?Q?27jcRe8tuqWBbWubtV+bDDWif2oYGtAFbUCu7l/m9HSeRiuQCkQjkzdoZSp1?=
 =?us-ascii?Q?mqSbLoc2X5K5ucRg9dVG0g/C7nPLDejLUc5LcYCSIP03pndWynlqGY2VwvqW?=
 =?us-ascii?Q?7ONTxfl3MtoJ8Ao+E5zD2MviR6SwE/rts47cBySO4JUEAX35l+A2uyvIZVuW?=
 =?us-ascii?Q?LgQnaSB4xV2bsA1y/n+GxWS0gniJB/LKIIxU6V0QGMFBEw/N57TAf825e6Zf?=
 =?us-ascii?Q?qwEmvo1eU6Y3A18ep8Ca2nEKiJ+ls327gMAwz+lQqnALHQ6xpOOgZAQjYtwL?=
 =?us-ascii?Q?hu8gMUc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <119968FE5790A54991F40A7DBCF0356A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3a1eb86-0897-4ef9-5668-08d91bb6f072
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2021 17:44:37.9959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N0v6fRLcSACRziH7D8Ih5ctQLRd9kPBV0DOx+hVFaPVjBvqjcTc1Ph2e0Cjb1UDWlJav6dIwBqtXabw9kNgKUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4233
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: q7aPtbB4W-c8lmX8VaqFWDWOI_xnfRQ3
X-Proofpoint-GUID: q7aPtbB4W-c8lmX8VaqFWDWOI_xnfRQ3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-20_04:2021-05-20,2021-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 clxscore=1015 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200110
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 20, 2021, at 12:31 AM, Dmitrii Banshchikov <me@ubique.spb.ru> wrot=
e:
>=20
> On Thu, May 20, 2021 at 04:26:28AM +0000, Song Liu wrote:
>>=20
>>=20
>>> On May 17, 2021, at 3:53 PM, Dmitrii Banshchikov <me@ubique.spb.ru> wro=
te:
>>>=20
>>> struct match_ops defines polymorphic interface for matches. A match
>>> consists of pointers to struct match_ops and struct xt_entry_match whic=
h
>>> contains a payload for the match's type.
>>>=20
>>> All match_ops are kept in map match_ops_map by their name.
>>>=20
>>> Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
>>>=20
>> [...]
>>=20
>>> diff --git a/net/bpfilter/match-ops-map.h b/net/bpfilter/match-ops-map.=
h
>>> new file mode 100644
>>> index 000000000000..0ff57f2d8da8
>>> --- /dev/null
>>> +++ b/net/bpfilter/match-ops-map.h
>>> @@ -0,0 +1,48 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>> +/*
>>> + * Copyright (c) 2021 Telegram FZ-LLC
>>> + */
>>> +
>>> +#ifndef NET_BPFILTER_MATCH_OPS_MAP_H
>>> +#define NET_BPFILTER_MATCH_OPS_MAP_H
>>> +
>>> +#include "map-common.h"
>>> +
>>> +#include <linux/err.h>
>>> +
>>> +#include <errno.h>
>>> +#include <string.h>
>>> +
>>> +#include "match.h"
>>> +
>>> +struct match_ops_map {
>>> +	struct hsearch_data index;
>>> +};
>>=20
>> Do we plan to extend match_ops_map? Otherwise, we can just use=20
>> hsearch_data in struct context.=20
>=20
> Agreed.
>=20
>>=20
>>> +
>>> +static inline int create_match_ops_map(struct match_ops_map *map, size=
_t nelem)
>>> +{
>>> +	return create_map(&map->index, nelem);
>>> +}
>>> +
>>> +static inline const struct match_ops *match_ops_map_find(struct match_=
ops_map *map,
>>> +							 const char *name)
>>> +{
>>> +	const size_t namelen =3D strnlen(name, BPFILTER_EXTENSION_MAXNAMELEN)=
;
>>> +
>>> +	if (namelen < BPFILTER_EXTENSION_MAXNAMELEN)
>>> +		return map_find(&map->index, name);
>>> +
>>> +	return ERR_PTR(-EINVAL);
>>> +}
>>> +
>>> +static inline int match_ops_map_insert(struct match_ops_map *map, cons=
t struct match_ops *match_ops)
>>> +{
>>> +	return map_insert(&map->index, match_ops->name, (void *)match_ops);
>>> +}
>>> +
>>> +static inline void free_match_ops_map(struct match_ops_map *map)
>>> +{
>>> +	free_map(&map->index);
>>> +}
>>> +
>>> +#endif // NET_BPFILTER_MATCT_OPS_MAP_H
>>> diff --git a/net/bpfilter/match.c b/net/bpfilter/match.c
>>> new file mode 100644
>>> index 000000000000..aeca1b93cd2d
>>> --- /dev/null
>>> +++ b/net/bpfilter/match.c
>>> @@ -0,0 +1,73 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/*
>>> + * Copyright (c) 2021 Telegram FZ-LLC
>>> + */
>>> +
>>> +#define _GNU_SOURCE
>>> +
>>> +#include "match.h"
>>> +
>>> +#include <linux/err.h>
>>> +#include <linux/netfilter/xt_tcpudp.h>
>>=20
>> Besides xt_ filters, do we plan to support others? If so, we probably=20
>> want separate files for each of them.=20
>=20
> Do you mean nft filters?
> They use nfilter API and currently we cannot hook into it - so
> probably eventually.
>=20

The comment was mostly about how we name variables/marcos. If we plan to=20
support more than xt_ matches, we should prefix variables properly.=20

Song


