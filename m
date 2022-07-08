Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E23256B222
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 07:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236803AbiGHFCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 01:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiGHFCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 01:02:10 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367D879695;
        Thu,  7 Jul 2022 22:02:10 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KPoPx010704;
        Thu, 7 Jul 2022 22:02:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=Q5v7NPxcZNm/gj3163zlgPRaXAw8aD+WRPW1F5zzq14=;
 b=JUogubRR5KO/E1oL4WBIW+Znm8PeIwrJrnabtKjLk+qNtiFBR5JbLnLNuv1b2LuwdbIo
 EE1ko5l0/oJ8DKaj/D3DVt4t846yKAjtm7jY5OvK1iPL9y+KiOGLQEaZs3cJSPBrDy0b
 ktKWPq1vxRHx+3eWfO21AVekOfqsQyhmfSg= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h5ashp2c8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 22:02:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MNjRn1Bx0/Dmd7fqex/zX8Tq4h0z7Mxj6AAjr9Ur5h+nOmi+eNanDyUm5u0DpsdYSQvgnDMc3fmwHhZXv9iEwXkp1HDJCunB8B7wvnNFVQm51pLnLZofxUuwySWXWXVKz1zb3YgjklUftV+fTgXFo9+eQ9bmDzKoUyB720JNGc+LGeQrz1ElAcJhboAZ/emyrZAsGDJ0IkkgGWCxfSU2LcRa5TuRB2m1uY9qQj5WN5oud1JK0jPjK2dFXW/JHj7XyLjx57VcSOr+TbHsOfgQdMlEFCkbMtge1X74ZNv/CUuSMEyFM8RYJWhTxeL17GYCu/QE4Jeh0g1Gsg533KQBkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q5v7NPxcZNm/gj3163zlgPRaXAw8aD+WRPW1F5zzq14=;
 b=Wg8JGUQVWmI1IKOkp8AjCRrXbwYlw17n9pE9vJR/myqKQl0ejXlRe4nK8ix7TvhxBG4VWwwaI2Cn4YMzcqgkddTiYre+Ni7BR/e48y9MpzPrnlI8q3l9dA5eLdwVxRGwtFj1/FfZHsxKqlzeoSHc9lnziieT+08S2d1u8VINCQMpP/s9VM1Wpt6M+Wra43PnVwkfKYzRK756SFj5SkmdLEvRMolsuBNPurRMyNmJFBbYYQwu7MRnllCoXgfWovj2NMuHWcg0kGsO1XWmk8r0FvkbOZCUbl7P3gPgrJ0qEa5EswaL6lQahlBRq/OiRzSl9jh42L94QdSVGgQfcYyAaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MW3PR15MB3993.namprd15.prod.outlook.com (2603:10b6:303:4e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Fri, 8 Jul
 2022 05:02:07 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a%7]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 05:02:07 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Pu Lehui <pulehui@huawei.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Grant Seltzer <grantseltzer@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH bpf-next] bpf, docs: Remove deprecated xsk libbpf APIs
 description
Thread-Topic: [PATCH bpf-next] bpf, docs: Remove deprecated xsk libbpf APIs
 description
Thread-Index: AQHYkn7L5T9/GFx4wUCdtbVyKv6cWK1z6r8A
Date:   Fri, 8 Jul 2022 05:02:07 +0000
Message-ID: <EC892D6C-2638-4C13-A725-536428582D63@fb.com>
References: <20220708042736.669132-1-pulehui@huawei.com>
In-Reply-To: <20220708042736.669132-1-pulehui@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3fa2332-081e-4e92-3b32-08da609f01b9
x-ms-traffictypediagnostic: MW3PR15MB3993:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EzltRmXu8bUIj1H5woeLblS/clZptV9NOp/J4+kiQCeol9rAAYE8NmVs3z9f/C0mFvCPkEKpFlQnOpKlTzzBbd0gXuwlD99TL/0hsHuRU4k08MS+uZhawUZdOhiviNnE/qy8K1BX/MMmk/E5AKnpHxEiWBEV5PnCe6d1juiVpr+NT03qKeXwsN1LuXihNFbdgRy4KaUegJdNHpnr/MRZ+YBB59HsVm9eAqkoI7plJtw1zhGm7n6URUEUng7DN08WWHOYdFaLDtECwx3ArOsSnQdVo2a+D4pb8Dgkj9cOKPlhxCd6E/+4+KJoz2QZHPB7qxzpYdeaZ+D3VVgUDtSuq+EZtWweXJVc5FV5WcFTo2ytWEbbSkR8vr4DqTuEpsTG2bNDqGUqonGmvU/qOI19hHHkO5B3IAYMqAeyaB0LNqONWIwxCyiKJMIAzbFxmYFG1dRt1QlObpwBCaBuaUtAYNpuem2ULjKyOIK3gk/4KV6vvtq0TUL7zeOWutiowiZNCA4PTPl/01eNHV9jRWuJlZ62AXOyUfOHAX9q3oIcHOp/p5W/WUSeopKDI+fFO55gUi8ktVEIcrNR4vMrFqB/dxeYb5Ap/86ZE0AJ885e5KWqjvYtda90UfZ235wvY/p0iJjxMjzsB41Fs1o6GkAd8hwYPPPunWi0jme2KPI5g+FVG7Fat5bM3sEXuesRyVUTjYQOhoZyX7cldEceN1av2S8z7OfIDD1IFzyxi0ZBaDOkpWzfFzCekLuKFrZUMWYBybOwfqZ5fn+ervFxx0u6anx9QWnNGiGr8sVzZxpLygYVQHxgU3V8/RyO8U6wRuMXNeE5M9bQJqZQ2in+6PuVbu0vz8qCdYuR/lRkQQJZl5w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(33656002)(8936002)(6486002)(478600001)(7416002)(66946007)(5660300002)(71200400001)(6512007)(66476007)(76116006)(8676002)(6506007)(66446008)(86362001)(53546011)(41300700001)(2906002)(66556008)(91956017)(64756008)(4326008)(6916009)(122000001)(316002)(38100700002)(186003)(38070700005)(54906003)(83380400001)(2616005)(36756003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xMQM7O7/yBFHY9WZNKi8SC9+jHdofZInbrVkX0H4wcKiOczy2KxpJJfAaj+s?=
 =?us-ascii?Q?/ot2eZGboHnPbKDOnzRHc24Ic7SH0DWs+AzlHHdebcNX559i8n6SABLCBs7Y?=
 =?us-ascii?Q?QBtSTqN+VjYam4gBmz68/t0eAtqWUrsUIEHl4mcebDK6C1dn1dlJV/4OIfUs?=
 =?us-ascii?Q?Ai5sF33/axy3zr6uDZ5HqD9wfJFY2gaSowb1CV0ySHB+oJqS1Kca0Dy58pmB?=
 =?us-ascii?Q?W+JH+n3D5Cy3aLTfO01nZZXyOZNV/vVIzyBF1LgEP4fsIEbuGXzoGBMAoMvX?=
 =?us-ascii?Q?I2cBAlfDmYgLeNVYYBk3FDomAsGs56Q6MiyTlfzOcWVEgLpiGGuodn4CQ1tS?=
 =?us-ascii?Q?WoRxjhDYWQukbyIfQCP2blyHaCG0aEMMCGw3poXMKw2mbFRfnyMgB6sg5QRu?=
 =?us-ascii?Q?dPsTxZhTLNJiRqJb3Yr7IkVmRUjjDLyIBsRZojCpube28QFzXWHdUbiIRI5N?=
 =?us-ascii?Q?H/6ZaCfwcyHdsBPx1SIUJpkjXTKtTuz6cDtOqjDGPrCSmDezfKMUDwfHOgAP?=
 =?us-ascii?Q?H1Wqg4SsD3K1qW/6Ch9uji6tzWFUy5bV5HTjDitU79sYKC3cmdjnGNvTQcmR?=
 =?us-ascii?Q?M2kT4JXW48GQPGskPuhE9W1trE1LNQ720cXbIUdtvaQyfHgiNkb8a6P7JPg7?=
 =?us-ascii?Q?b85bAFJxE80DNh7jaga6Ogw4IaI4QJvKwr0cPHKvgYQL+92k3IX4bJehMfhT?=
 =?us-ascii?Q?NsMp8GCEHxSb037ukhAytD5Vnw5J24sJrPHuM3+uFgpQJPYX8szOcG9YuH02?=
 =?us-ascii?Q?52jn3ic1FDzrIpqH1I6RldUmxeEUXlaXpVRnCrJUKCABbEsoNyujPvQqyXYi?=
 =?us-ascii?Q?Db1g3IfHbY8qyVl/13UzAdkS58PMUhWz+j4+g6HMH7FHTGA2ci81i0i7vjGu?=
 =?us-ascii?Q?L6Ojfn+ZraszJFUAJvSrMTI6Bpn0AC9TPoDCE26OijZBT5bdtiJiqOoUEoIT?=
 =?us-ascii?Q?1CG4XQUli2CrzeGtnRA/3+hP8vCnAx4yrK7pglFimRhIUfeP8NclKipvbVxB?=
 =?us-ascii?Q?VGn8alISMD/rf7DVgbdoXcf/OFIhTLpmhRIstvrj1tYNo7uifs3BbGyRgZm7?=
 =?us-ascii?Q?mEUZqgHvMxjq1JUfriZHpM3Y7wRpe4VCHP3z7jBDH1MMll+/+lzwUhaQ+7/K?=
 =?us-ascii?Q?eSvC/4X0lWHELdM8PnhGAa++fuwaATbO8UZ39N3IMNEHU9NHkgJJ5YCQ4TI9?=
 =?us-ascii?Q?6AblANX8y2ngWN0gHsNA4isqcrSztG8KbGnfLwe8Cw58bj4AaX8+mnZj9Ikc?=
 =?us-ascii?Q?TOTpXZ5rbT1buVqs5DHCEqzROI6D6Tl+Vm1+5MBlaNtYFI4NbYnWgPnGHtS4?=
 =?us-ascii?Q?qAxJ5pquksX+bzQGT9O8HIj073ju3vv013LGCsC+PizOF72OBWr1bfWYWj3s?=
 =?us-ascii?Q?zein3GPwU0XRGgOyHC9AH4w967Ya/zJC0g8wSJXArKeSy427nWxAZG3jAFoo?=
 =?us-ascii?Q?SXIfP+PQQJ8QWPIqRb7i1FRpeVkXfiYfmCs4qVwHF3LGB1oRIevoC3Mcq17/?=
 =?us-ascii?Q?IQg0gDFgRwHIRfC0yrt4DSPAZ8z9XfrL5HNs4O0Wy7z6Lda09DdUW47tRGzk?=
 =?us-ascii?Q?BEU/DSZVB53Zk+QPvQobfL4OVd/Eg28243ZPJXc4d9LtROfH37pvMdZLQzCu?=
 =?us-ascii?Q?pLpjSFVBx60gOl9ZGlB4cVo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6ABB0645F046F94285238B9049E111C9@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3fa2332-081e-4e92-3b32-08da609f01b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2022 05:02:07.1329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZmfY8DKk78OTOaJVEXmJuyJvCggf63DfjydjP5OXjWFx2CKhYlWGn2vbeKayCVmNzcoQMhADEwT23l2W/e1Hpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3993
X-Proofpoint-ORIG-GUID: iSvopBeSlCusNr6v-zD7mYINuwcJvGNP
X-Proofpoint-GUID: iSvopBeSlCusNr6v-zD7mYINuwcJvGNP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_04,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 7, 2022, at 9:27 PM, Pu Lehui <pulehui@huawei.com> wrote:
> 
> Since xsk APIs has been removed from libbpf, let's clean
> up the bpf docs simutaneously.
> 
> Signed-off-by: Pu Lehui <pulehui@huawei.com>

Acked-by: Song Liu <song@kernel.org>

> ---
> .../bpf/libbpf/libbpf_naming_convention.rst         | 13 ++-----------
> 1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/bpf/libbpf/libbpf_naming_convention.rst b/Documentation/bpf/libbpf/libbpf_naming_convention.rst
> index f86360f734a8..c5ac97f3d4c4 100644
> --- a/Documentation/bpf/libbpf/libbpf_naming_convention.rst
> +++ b/Documentation/bpf/libbpf/libbpf_naming_convention.rst
> @@ -9,8 +9,8 @@ described here. It's recommended to follow these conventions whenever a
> new function or type is added to keep libbpf API clean and consistent.
> 
> All types and functions provided by libbpf API should have one of the
> -following prefixes: ``bpf_``, ``btf_``, ``libbpf_``, ``xsk_``,
> -``btf_dump_``, ``ring_buffer_``, ``perf_buffer_``.
> +following prefixes: ``bpf_``, ``btf_``, ``libbpf_``, ``btf_dump_``,
> +``ring_buffer_``, ``perf_buffer_``.
> 
> System call wrappers
> --------------------
> @@ -59,15 +59,6 @@ Auxiliary functions and types that don't fit well in any of categories
> described above should have ``libbpf_`` prefix, e.g.
> ``libbpf_get_error`` or ``libbpf_prog_type_by_name``.
> 
> -AF_XDP functions
> --------------------
> -
> -AF_XDP functions should have an ``xsk_`` prefix, e.g.
> -``xsk_umem__get_data`` or ``xsk_umem__create``. The interface consists
> -of both low-level ring access functions and high-level configuration
> -functions. These can be mixed and matched. Note that these functions
> -are not reentrant for performance reasons.
> -
> ABI
> ---
> 
> -- 
> 2.25.1
> 

