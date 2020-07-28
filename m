Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16396230268
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 08:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgG1GL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 02:11:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27844 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726407AbgG1GL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 02:11:57 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06S6A760010007;
        Mon, 27 Jul 2020 23:11:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=JAEBT4DeFTJJp4SAa7DKz5Y7Sd3AyBOZqjEh739OSVA=;
 b=f7W+MZS+zCFRTXaP9wlTq5cI4UXfC1RyShrzBl2lCL0xadr1pbFU09+ExhIM8RyzKpZy
 rfV1C2G+bYfuczHOW3YMBVrFnvb4C6gInxD2rEvT5qEkjS53v/V92nbBM8faE5HHj0c2
 E1ptUgXedlf5PNSPXdiOst1WVGvIWOQt4hY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 32gg7xts4e-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 27 Jul 2020 23:11:42 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 23:11:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NxBpU3XaFfkCxl38/4+e6Mg/zz5kc5TKXnr2WuAuDh0tG8RN2CkGeV4z5Ov89QgI3pYBbmMEFeKSg8J9oy+YKw4Iut71LOQNN7LXUE9lcAbFIQ9w51NCu4cE1vPJrUSNx0clW4toW7WJ3UKa5H+SyBNZt/xOD32DgS4fl3XJn/QwsIj0iyCpE5wSWd7NclgR5pPsKxFKlCncHOBpa7/kY+eH4HiYue8Z0MZGMZHinY1aBAlACazECxGfFTCtcZdxD2VMs4Qcg99pV3yetd7u7SKPra8Y9nDXkFvfNZuOARrHwjsyna1kgORdvfOpcNK5dyKALTk0rVN4GZ+37K2PiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAEBT4DeFTJJp4SAa7DKz5Y7Sd3AyBOZqjEh739OSVA=;
 b=CymVNgleEYXAyTmrAD7ovkFKJVW8xDfPR7aGttIwUAJkXk4Qdb7j8im1YaiBU1doRqw68LyZmN0++QdFp1KnPmtReaqJqQq+CzE6sEoxsWw/fx9I1P/+lQ8WHkGens/f5X1t7bWIedrXVsfzI8A+l9nUMGfYs8GHUXA1/GFuRxvQh2yNfljqRDBBb+DYF7PIpicxeOxaRWoqOTV/ygc1SBtHoUcvqhh7f05DWSRv03PiLw3ixUg5r9oLXYWyzNgBQyo4X6L1H4ZvxHHJci27ybMuPWLmNM+khycE+fe/RGnHwuCl1K8wMobJd9svJ7OcPd5mJYdSah2LjBQHWlSlkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAEBT4DeFTJJp4SAa7DKz5Y7Sd3AyBOZqjEh739OSVA=;
 b=lReO2LoMuRK0/DjBsWXdFGlF5twwen9bTxxjSTtIk9ca799uYKDEF0eLV26udMBEK7uVb5/P5lWVA+ZyfecBvwQn+tTfdzPhSyYWIkK4aRXcvYVUEwmYvex7wKkJFGSdnb0W/tXIZSpU5onLLumoU8BMsyKswiyyGrlBdz9rceY=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3046.namprd15.prod.outlook.com (2603:10b6:a03:fa::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Tue, 28 Jul
 2020 06:11:17 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 06:11:16 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Roman Gushchin <guro@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 32/35] bpf: selftests: delete bpf_rlimit.h
Thread-Topic: [PATCH bpf-next v2 32/35] bpf: selftests: delete bpf_rlimit.h
Thread-Index: AQHWZEZCJ8RCuONiBk2bTp6gKFH2SqkcggeAgAABOgA=
Date:   Tue, 28 Jul 2020 06:11:16 +0000
Message-ID: <C739D492-23E2-4823-8A9A-81BF00FD450E@fb.com>
References: <20200727184506.2279656-1-guro@fb.com>
 <20200727184506.2279656-33-guro@fb.com>
 <CAEf4BzbCzEOKx2GMOcp6CTxBBN+BRAY-Z_mCJ26hoSto956KBQ@mail.gmail.com>
In-Reply-To: <CAEf4BzbCzEOKx2GMOcp6CTxBBN+BRAY-Z_mCJ26hoSto956KBQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:395d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d19bde36-3b03-45c5-acb9-08d832bd09db
x-ms-traffictypediagnostic: BYAPR15MB3046:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB30466E7A8FDB4CBC87A92ACDB3730@BYAPR15MB3046.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zhAWJa8qgCn7lZ7ZzlmJ5KBpFVmuofceW6dzYlEO8y2KSYo7FT/pLDAJsYXc6CcrHEAJtBV6Cf5WRfjn4WHSOa6NKVKrFaA10H+vUg9hsy6j1P7/I4J9XsR6NrGJf1ycMco40WBChwkdwNQL905ordrvFgdDAS99M7FK/OvzcUlqcbNCWj0wMdBy+Jmm9wb2OqPIz30B8lmCcw9w22p5pxaYtHzoV3S+bV5bTOM9SSpK3v9ImpoYFuSJBqi6OqElRLcrcio2X19KLz6lc8xOkml15SoEUcRgkzbZT0R0U3aKPuo/9mPuTVvWhSj+IY1HdLPFEub8efnsLHsO2ReVYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(366004)(136003)(346002)(396003)(39860400002)(83380400001)(66946007)(64756008)(8936002)(66446008)(66476007)(66556008)(2906002)(76116006)(6512007)(8676002)(186003)(478600001)(53546011)(2616005)(316002)(6486002)(6506007)(36756003)(86362001)(71200400001)(5660300002)(6916009)(4326008)(33656002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 5i6joeKpVqaAoAB91rq8NdzsknukQdy6OYDV/NJBmg07oYIbOaQBulQf3jXqyhTn0w/9GXv9opHYYBqR63c78bhb9P9sNzD+qJPhpyy8Qb2kEBp8x8QEj7Uosp9b2/lPi8PVkctXfNXU93FgUV5BNqaG2hqTfEwXcS3s0ftUqO8FgFTQhanI2liHB3izs5GjPIyVylNGMkcm8ATXZTWa0GAVSin8kLS2CfPDybfdyjOwPkcxvOtj/egu2zIJH+8flzNnxD4kNEfdOzYNy4lrF6NlrfNTud/RnFvlbbgLR5a43dFlB+GWbKhc4KJ9hf9DySekTmGxC7v9+QYowJhXEFCIovwdhto7DsZrQMVtgvm8UxZifIjfDOUzbJ5xJV4EKgRubQG4H9JqWGFeuhC/i3MLZ10tK5F0u85/RV/p7zLAEDg2OowTpiI8kbIyZ3apQ444g0rwGloCt3O9AjvAyUtQpwyZQIRA1mZEWkvJhiMMTt+D8eBiae1lgzYcZnfXa9p88d/Ck+D6LhHJOa/JJQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E8760BD57A70A14CB1C63BE14E681951@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d19bde36-3b03-45c5-acb9-08d832bd09db
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2020 06:11:16.6395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 15DhWErW0ndH86a1M7/SfQet7xB7dDa7Ssl6D6OUsleSxskZ9yqfg64jZe019yLtp7RHyClkaEGGjr1urz+5gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3046
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-28_01:2020-07-27,2020-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 adultscore=0 phishscore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007280048
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 27, 2020, at 11:06 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Mon, Jul 27, 2020 at 12:25 PM Roman Gushchin <guro@fb.com> wrote:
>>=20
>> As rlimit-based memory accounting is not used by bpf anymore,
>> there are no more reasons to play with memlock rlimit.
>>=20
>> Delete bpf_rlimit.h which contained a code to bump the limit.
>>=20
>> Signed-off-by: Roman Gushchin <guro@fb.com>
>> ---
>=20
> We run test_progs on old kernels as part of libbpf Github CI. We'll
> need to either leave setrlimit() or do it conditionally, depending on
> detected kernel feature support.

Hmm... I am surprised that running test_progs on old kernels is not=20
too noisy. Have we got any issue with that?

Thanks,
Song

>=20
>> samples/bpf/hbm.c                             |  1 -
>> tools/testing/selftests/bpf/bpf_rlimit.h      | 28 -------------------
>> .../selftests/bpf/flow_dissector_load.c       |  1 -
>> .../selftests/bpf/get_cgroup_id_user.c        |  1 -
>> .../bpf/prog_tests/select_reuseport.c         |  1 -
>> .../selftests/bpf/prog_tests/sk_lookup.c      |  1 -
>> tools/testing/selftests/bpf/test_btf.c        |  1 -
>> .../selftests/bpf/test_cgroup_storage.c       |  1 -
>> tools/testing/selftests/bpf/test_dev_cgroup.c |  1 -
>> tools/testing/selftests/bpf/test_lpm_map.c    |  1 -
>> tools/testing/selftests/bpf/test_lru_map.c    |  1 -
>> tools/testing/selftests/bpf/test_maps.c       |  1 -
>> tools/testing/selftests/bpf/test_netcnt.c     |  1 -
>> tools/testing/selftests/bpf/test_progs.c      |  1 -
>> .../selftests/bpf/test_skb_cgroup_id_user.c   |  1 -
>> tools/testing/selftests/bpf/test_sock.c       |  1 -
>> tools/testing/selftests/bpf/test_sock_addr.c  |  1 -
>> .../testing/selftests/bpf/test_sock_fields.c  |  1 -
>> .../selftests/bpf/test_socket_cookie.c        |  1 -
>> tools/testing/selftests/bpf/test_sockmap.c    |  1 -
>> tools/testing/selftests/bpf/test_sysctl.c     |  1 -
>> tools/testing/selftests/bpf/test_tag.c        |  1 -
>> .../bpf/test_tcp_check_syncookie_user.c       |  1 -
>> .../testing/selftests/bpf/test_tcpbpf_user.c  |  1 -
>> .../selftests/bpf/test_tcpnotify_user.c       |  1 -
>> tools/testing/selftests/bpf/test_verifier.c   |  1 -
>> .../testing/selftests/bpf/test_verifier_log.c |  2 --
>> 27 files changed, 55 deletions(-)
>> delete mode 100644 tools/testing/selftests/bpf/bpf_rlimit.h
>>=20
>=20
> [...]

