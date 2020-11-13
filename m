Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE062B22F4
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 18:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgKMRr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 12:47:27 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24696 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726902AbgKMRrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 12:47:14 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADHjKJ8016309;
        Fri, 13 Nov 2020 09:46:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=nmNc5qTuGMkSX2etJGROwrW2PWgQbiLK/UaAmQskRFA=;
 b=nfyzTqlD86rvhL5LVtN8QdSdtlEKAFcnFaO4S6uf7haFVzl6r9edlT8Ach+ZjBadvXe3
 i//qTTb93avLwWQEOOacEkn6QA4zNh8mEbM0c9OHY3uSoEMf0fVChj1oS8MNyq8k/y5D
 pPb9Qebkv+wA7r50CosTpVeQ46LeMaz8KUc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34s7dsy64f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Nov 2020 09:46:54 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 13 Nov 2020 09:46:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=grBqFL5FUUrGr9JZ/pdrkY38VIVxmrYv6tNrZ05bPZtchByWwwo2YYnJychsQMlFkPNAeEhOftUsfBQLtwlJhyvtFSjSPiRbr2n0+f5m0qrfpj291h89NY0cLsqt0kex/Awjpy2I264E4otuDQ946/qzsjZW+SsushyMxlIWjXdHCGsY26/pw8USPZ91L9sNV27y73yKOU6uRfkp/QBgufI97OwFFts37p/WasqNCYZdvyJaLdSutIcWw4gy97mdu3Jcc6CjOTUGT++UIo/BbVwvWzBYNjE8Oz20D3gQcoILdP6J6++SbS3TJlMVBTYExo/bFocABKZgcpGByOQcnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nmNc5qTuGMkSX2etJGROwrW2PWgQbiLK/UaAmQskRFA=;
 b=JBO6ZZTjOab7l7Dfdm3Mh2VqbqZggvMTxHpjsPT2yBsRYQ/X47Nvdl493Ri7fmSH9MFjrkiuBMflCyEdkRkfx8l9KgSROAAQQbAGaLxZpS2AIJIN98FSDmYIhrH2MzMgNBGK7PTvVyLHrYa31t7wQ81YCOvwCgoy6LuXAKGbDBS4I3hhIBYmI32KXATOvU3Q7YipkKw9fa5tStP9/wluVCWc70Fu5tLbQ/dhJMPSP8hl+JJsdO5Rrh7GrxvlmJrcIB4PxflAP0Gyvpe51N3wsgKVlHrkXRfkJbVXbcqbmx4ip64iBczFGfLtbpofMwHSzrA7J2ts1qfzyEWBk5AY2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nmNc5qTuGMkSX2etJGROwrW2PWgQbiLK/UaAmQskRFA=;
 b=AloUhHCQxFur3BE5xC3BREKjgQyv+q+hltzC3qM5iqa2WORBxomHI4BU7valmgkaZ/iYbZbXk+63TKDvufpmJtNmjv59+0uHrA5PHXqvc77BR0oS9DOuwz9n0wMp/EHg9jpmgbA55upP9uwnZK/QL/NXfH0LjtG/lTYO+LvaC2s=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3366.namprd15.prod.outlook.com (2603:10b6:a03:10d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Fri, 13 Nov
 2020 17:46:49 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 17:46:49 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Roman Gushchin <guro@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v5 06/34] bpf: prepare for memcg-based memory
 accounting for bpf maps
Thread-Topic: [PATCH bpf-next v5 06/34] bpf: prepare for memcg-based memory
 accounting for bpf maps
Thread-Index: AQHWuUMKg1vDyQyVG0KrHEFVr4bP66nGV2aA
Date:   Fri, 13 Nov 2020 17:46:49 +0000
Message-ID: <3645417A-F356-4422-B336-874DFEB74014@fb.com>
References: <20201112221543.3621014-1-guro@fb.com>
 <20201112221543.3621014-7-guro@fb.com>
In-Reply-To: <20201112221543.3621014-7-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c090:400::5:f6d8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e01643a-d237-4929-0314-08d887fc1948
x-ms-traffictypediagnostic: BYAPR15MB3366:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3366CA2AA7FE0009FAAF95BBB3E60@BYAPR15MB3366.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CERakLZZpe4hhHzHJ4gSD6EDSOQV112mKIabPxdcXZmonop53M17FdW8dh/3+Lo3lDs4Cer44RPwKeJF2mBO1mnXIG681NVA05vwb6yQhIbO6X5bq8BcpZI5UZ+fXDXb6kFrVOR3+JFKfiIOJUgeIeyVzEl2dW0TMgVAn/YNJpvuVuPUixAx+njkkrUt84QM2BN3I3D/1dJCX8RTnKwJNB+d6fv391CGTN5y6Sq68L5MrANXaWrt9UEcJgxJ7F2EbSdQFDdBsWH1G0brqdBpvnMP0w5TOul+R0/Z9zzrtNXl1Y7KbZGQmQv84YTPgJJ0COIGEmeMz8QNtm/PcaDQYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(396003)(366004)(346002)(91956017)(6506007)(64756008)(71200400001)(6862004)(478600001)(66476007)(4326008)(8676002)(6636002)(2906002)(186003)(86362001)(37006003)(54906003)(15650500001)(53546011)(2616005)(6486002)(6512007)(33656002)(66446008)(66556008)(83380400001)(76116006)(66946007)(36756003)(5660300002)(8936002)(316002)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 0LS9/7pYfXfXNDn6nplKv5OdSk44ibi57Omlg+1UwFZGsXMb60yLJmHZ/IB/zg7ArT+VySu985vSYiNQXyQWXOA5f2bBL3tf0zt5SSZJULq8Mc6n1S2wf/aJqnke5d5sGtC//GAjA/xCriLVctdFYcJDB2u53Kz5lkSSqcZwYVF5zRvgFAkIcPxZqJvkbChwtvZtJcXYCItL9wHpE01Hnq2oWyc6SW0gZqgp+dPJCxKUz1YOlWL4lHUiD2QW3H3YDpgq9aDdEKsLML7tUaU1g75arLdVwWwLNJ8eXZ9tMbc9c/+N5OWl8KNwW+AypvpgQ34Iw+kDBjRsxYw5DdCyw8kcMziZTk6l5A6gFyOskjU6zNO43QkwuOmHiM6rAK3xPJxddpZbPNKQLWwavrbH6pusTcMolTVrR1nu7TkRJ1ba2Fj4BcesWosnCKkH9WramjnUZ9hRZ/BF7k+6YEC+ngZjb0EvkIvRgjBF66XCxvwPru+Ba3l3FHd+0kifQCbEJBTYl5qYXN3XyZGD1Gf2ZCgUHTj3AdSCix61oIM6b7pfmOM8NU3m+CpioFcKUG+icSZrmRa6F+qUEuXNdLnjL1OTiUtO7f59cAfVTEbHFtWuy/8AGXoiRnp43L/ccKp0waLptxdsFCcGrx+rbJmCeJPNHpu+NGd4Vz7FkdeJO95LY9GkVBX9zkjK4JR/3HQwutLrz2K/zbexaU/lY7mE7P5CV/V5FRQciLWjCz3p/1klQejeB0g+FXHg6WY5PTXZgL07duXGGxiE9Yrb2+uKg6oH3bAhcw432TQhzSSq9bt8YkgSpapYzkR1tX1dLaxLjurk+UwAswj9UBVFX/DB/zFGiPOy0NaQ/uL0MA5Y/qsPFOfZlZempQG/ta2HjVPRU5niwaI47umXfiiOlKk8hGuyJYkzjoWB8/UGFmP+3zU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <04146EEBD69A454CBCDF837BD2DCD8EF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e01643a-d237-4929-0314-08d887fc1948
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2020 17:46:49.7473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KSxoRRsnruicab0bkRCZbXUetozo1MlugEv3RtT9+GD5UcoRHEco0AONmEkASO7h7t+cpVH57LcdfQWI71wAcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3366
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_10:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 mlxlogscore=723
 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011130115
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 12, 2020, at 2:15 PM, Roman Gushchin <guro@fb.com> wrote:

[...]

>=20
> +#ifdef CONFIG_MEMCG_KMEM
> +static __always_inline int __bpf_map_update_elem(struct bpf_map *map, vo=
id *key,
> +						 void *value, u64 flags)
> +{
> +	struct mem_cgroup *old_memcg;
> +	bool in_interrupt;
> +	int ret;
> +
> +	/*
> +	 * If update from an interrupt context results in a memory allocation,
> +	 * the memory cgroup to charge can't be determined from the context
> +	 * of the current task. Instead, we charge the memory cgroup, which
> +	 * contained a process created the map.
> +	 */
> +	in_interrupt =3D in_interrupt();
> +	if (in_interrupt)
> +		old_memcg =3D set_active_memcg(map->memcg);

set_active_memcg() checks in_interrupt() again. Maybe we can introduce anot=
her
helper to avoid checking it twice? Something like

static inline struct mem_cgroup *
set_active_memcg_int(struct mem_cgroup *memcg)
{
        struct mem_cgroup *old;

        old =3D this_cpu_read(int_active_memcg);
        this_cpu_write(int_active_memcg, memcg);
        return old;
}

Thanks,
Song

[...]=
