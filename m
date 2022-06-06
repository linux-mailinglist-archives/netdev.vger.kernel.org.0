Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61E353F249
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 00:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbiFFW5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 18:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiFFW5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 18:57:07 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32379B4BC;
        Mon,  6 Jun 2022 15:57:06 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256LqDx0003391;
        Mon, 6 Jun 2022 15:57:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=IVtceYirS4QSMbKYDgnZti12awAcHeWO8msZJvuJ040=;
 b=PbCiWFfeDNkXP5vjTmDJ+XG8zDAthAjL0WGqFTr+HSabnBdZeULx7F4THcePkGGQQQ7h
 5qEMTlWIyOzZXYLLfFrAWqaq9tFgovuLII3DH+qbLKZWCrq+ssWIWAFr52iT+p41S5dx
 TjEh5N4BEO6Txym3dlqkNGnniD2JthDkPak= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gg2qkkwad-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 15:57:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YrBLe6tOvqS9kh+a4tHI4IL1+bRf3pIysiNEudraIDQDsCbmgb3qTu0Merfz5otEPpclQ70Ph9FyI86uCbkg8nPHmaj/em4vzLoSQZxa9j1XJof54E/TfXt/kdkkAAZ24jNkUi8naylZHiEKidH/y3gs8ACu2eqHlEI/4JcPvJZb6aStuDZS5MKPf8NW8kt+fgxAFy1w8V9DroLZuBMOuLZyVWgoWpQaBYChtKKJNFRQT9MsilYg/DX1Nv8wp6Bko8MGLVRxCfMNb/zOTxTVATTyXD090MuNuzHXKuT6Km9uUwNnBKBTerh1GakGY+I9i/9C9iZZyWeH+15+ERw1jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IVtceYirS4QSMbKYDgnZti12awAcHeWO8msZJvuJ040=;
 b=GNUAjnlctCwerjrJm+BF7BP0DLNE05Lj0c9worKw9pYmlNurBXe9qJmIXJMmvkkScqTewv1AqNvdrHYckvJsuTLX2M1s7wgwf71rArFKOJkpOWLvbbecREcSJeWiO/pYKCgxdl8v9MwMgzFX4bKqY4feTXLrwh+MUe8a2hmu6LXqMn8Cjo5EOBCu0+WFGnso+PeOd+juIqQEEUxSn1iwq3Xlk+/BihKGpFHPSlRJNJnwvCseo7KKGVHFFdqM14kvy93r4VO2veqaWS+YGdfgW+9ZE5UlxMhgSUw+1jZMBakklZzqMLGV7jw/Z2yjp3fDCHxDt5Hbm5pETECjas8aFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MW2PR1501MB2076.namprd15.prod.outlook.com (2603:10b6:302:8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Mon, 6 Jun
 2022 22:57:02 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::b9ad:f353:17ee:7be3]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::b9ad:f353:17ee:7be3%6]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 22:57:02 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH v2 bpf-next 0/5] ftrace: host klp and bpf trampoline
 together
Thread-Topic: [PATCH v2 bpf-next 0/5] ftrace: host klp and bpf trampoline
 together
Thread-Index: AQHYdrnMgR7UbO/WnEm8o1uHxIdxmK1DBAOA
Date:   Mon, 6 Jun 2022 22:57:02 +0000
Message-ID: <22E9FBBD-754F-4CAA-907F-29F4223DAAB7@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
In-Reply-To: <20220602193706.2607681-1-song@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 843e96cd-2fc8-49e2-69a7-08da480fdeda
x-ms-traffictypediagnostic: MW2PR1501MB2076:EE_
x-microsoft-antispam-prvs: <MW2PR1501MB207645831FD2D96AB4BAA63BB3A29@MW2PR1501MB2076.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ye6nYmDiDXl1UoeVeXNy4faWUUFcAE76AWuHm9OkpIiKzh9Ig5sTuXSauhq9P/FtYjU+mOevQiOHwe7YkR0K049imH0/jyjU9OepKV90zkgT61hdbWz5MHzRhGDB5qMwuDwYeEJY5OSY0gmhf5tTfgBhqOuidxQ05gXmvNBzxErBs5Dw+llGxSeUDgm2e58RPtyO/moo+TCsi8z3jfmQazGqAgNRdOZAzaJpAF4c1Kiaq9HxebgMQ3PHlOJLs2xHOmwiZcAVWfB9QYm7unz1pnz45hxRzus4DHBMG6gQ8pSQJKW0Dc1u0iLvnP9gzK1Ox7MwxfltyBnBM1Uz/ET7MNxDOWx+gMS42QRM5E4IMgcCG3uW25xhCXPDAOHpNaO3E/zDMxaKvb+YWfudQVydkQknazKoIaCbTx7CoUgcFiKkevRwnm3v5Vh8Szqpd0fOQ8YI8VEYWo+fxXP4MVW/b81xrfcElpulQd753IghiKDSuCl+/QQM4YZviOm/0kcaCQfdtpt+p5uJzTY2ZIiw6mRdKu2wo2O9yAFHD71uDOu7dsGzT5LClaU2hPNm3m/K6enrZfapy+iD3uRIsPGN195jc9EmXPW3jkRTxn83qRkzu3XLasIY1CuuHpapGs8f6zZsT/ItQlzCVKXTjlsn41DH3XMLc77CL/3QjNXmQl+wjvTHBVVyfni5lp2SFo98ncNlMrm6lJDij6/sCMZ2NBjFdcgDmzAFr4pNBeO7ICRZM5HBBYwKeoWtqMdkPISO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(6486002)(83380400001)(508600001)(316002)(86362001)(33656002)(186003)(2616005)(53546011)(54906003)(6916009)(71200400001)(6512007)(6506007)(122000001)(5660300002)(36756003)(7416002)(8936002)(4326008)(8676002)(91956017)(64756008)(66476007)(66446008)(66556008)(66946007)(76116006)(38070700005)(38100700002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vh3dp1g92DclsSk5RmjVGZ5k5dEtob4EnAP5Hz5gor1Rj7G06uobP3Clc3xx?=
 =?us-ascii?Q?Ua8BCJey4SUBfiEUyLvs+BIqgT+LthO85LD/3Qc2Z2tOb1Yi6kI0ZXqr5sUY?=
 =?us-ascii?Q?S1tmCfpOzbicB406yY4Tzi0E8dgqjaVWxlsMwbq9zU/uEOUrQDE/rHKW4cCY?=
 =?us-ascii?Q?hjcTKNfwrpqVdj+P2ag//gbegLbSd6ejIbrs9z3f3F0hq0h3RfIKQKk4INC8?=
 =?us-ascii?Q?ByUv+aBy9hv1XGb0IAchA1c+R58xzoII/ncfZRSQ5oqIGUMmslNWaWsY7A1C?=
 =?us-ascii?Q?HW8Npthn9FNHMKj6H9WBelwXEyoBh6LsvvZohXbWCEzNatPufwM+C9YpTGE9?=
 =?us-ascii?Q?7fl9NskepjqDmnENvWjpiEVxkUfCQWj58wzZ8T+33j5p4nVAJcE1IHQPPzHr?=
 =?us-ascii?Q?6ErjAMxiSZFQszc9Q9kl5rRHFdfK/z+ZAg7glbx5gY0IdtAD/cJceg0atpg9?=
 =?us-ascii?Q?9v2FZT651f8hHQkDFLcizRiZvycmWnUO3flEvF6+M/nsuzZgmy5iAOpZY3DM?=
 =?us-ascii?Q?Yz9LhfH5mpUWDcf9idef62Erv12xtm/nhfRmlz5OXKVCAIge9Smfe5NAqAiE?=
 =?us-ascii?Q?YlzWXT4eXhKZQL9n7mKyrkxt4LY1wIjCxzjfu1tjMiMlCv06hLwm2Jrh719T?=
 =?us-ascii?Q?7aG/De8dlYXw32QgQg6dOsMJrLt8OlkABEnBVzXUNDuVUYHTDGn508lqUZ//?=
 =?us-ascii?Q?G3WGP95YCUCdG3rNLuqrba/IYxD8c5Ns44UFdoVU7qAygUQPebQjfpi/8CCK?=
 =?us-ascii?Q?vFESFagXOjG3IdYhpfn2Rc16F1cb5WiWHU9YIhuCph/Zc7G7vxTo8gosj24P?=
 =?us-ascii?Q?rnMkJe88luzmGgTKO9XPYUZSyftB7nyI/2iabvYGatxg0Ay0lDm9EioZshpI?=
 =?us-ascii?Q?AZRpPFcFP8aVOFlBbTZlMNVP/ZmRXkfUiit1B9Rt9IHisf/kai6AI/3o0IJF?=
 =?us-ascii?Q?q2fqlUYqwFY3OFOSClEaYhpRt0SU0Riz00uEmNUOo89ThOGhW4ZN3mYVvCpW?=
 =?us-ascii?Q?4gGUnXGhcnS+4S5NakZF5uR2DvYU6TcVE68aV8mVnO1O7Onjl6dIOiu4zr/b?=
 =?us-ascii?Q?WpCtTxUdPruuw6nTscSwa44L0NIA9HbHjCesNKwQHO8uD9VksD+i1ntwzhqK?=
 =?us-ascii?Q?kJtC3fV4LB3gqYtsNnHYlPtYxVGdmB6GD9TRWZFGCFbKL8KVp4FnJmHSJTsq?=
 =?us-ascii?Q?4+8IRMIe0V0orDHqSBWR1QMuk2Pikt4XlYpBEFluTUU7QTEzTdiLAwfuaOZJ?=
 =?us-ascii?Q?DXi9SokP1pZ4SLZaANsioX4ZpOMVzXX6VydxDo+lKBoya+FogltYBNLn4HjW?=
 =?us-ascii?Q?Irkx33RTMwbtlJimzfyTO+WyCROhqo5ZrrfG45p1ANZpWjiL149/E1bh9Udv?=
 =?us-ascii?Q?xj2gcQk6zfDdlz7BnnseUnoZDqgtcm9F4OsN6txBG79qxvmH3FmK8vJzxYXZ?=
 =?us-ascii?Q?sla2Qqie8a0DxH7JM1ic+XEwtLS4FmcEWX8JThP0Qb3bqnOmVyn3lHjRYE00?=
 =?us-ascii?Q?d2lFPOmLNWMjjeSokFNCq+ef0gmY3aQwBwy4e40Ffbw9J7EWoa88gM0GPUBz?=
 =?us-ascii?Q?rmPyUZdTT5BUo7ZZFdbZ5Mzs5F5PgcsEg8QxTbm/OGLmyfBrU/gIv0U/ePRF?=
 =?us-ascii?Q?NR2FFWYRxMS4usdlxiZoFMOyOWJ7R1HPTFEpvlCSa+774QCr1hmU1qLwPJ9z?=
 =?us-ascii?Q?qO9K8ect05RwfalMorKgnRFeVP7tZ80rojiBKB7EtAMl2c1edg04AuTekC9q?=
 =?us-ascii?Q?ta98/xp2o2DC8+x/uObuZ/+7G6sWcaTiZDL6rjyEc2cIRsXMBnDy?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <70BAFBEBA2042B40867D2C42693936AA@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 843e96cd-2fc8-49e2-69a7-08da480fdeda
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2022 22:57:02.6286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M0ZGVrlydibCQb92dj26xNE9aw1Fjr0/1gPevs68wl+NNJh1KHTdfItxg+I6WLKrjS8h0GlW3ZZIqXzHmMFMYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2076
X-Proofpoint-ORIG-GUID: XYYZNR3s61UOmebxU0n4zwWP_HYpHtlt
X-Proofpoint-GUID: XYYZNR3s61UOmebxU0n4zwWP_HYpHtlt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_07,2022-06-03_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steven, 

> On Jun 2, 2022, at 12:37 PM, Song Liu <song@kernel.org> wrote:
> 
> Changes v1 => v2:
> 1. Fix build errors for different config. (kernel test robot)
> 
> Kernel Live Patch (livepatch, or klp) and bpf trampoline are important
> features for modern systems. This set allows the two to work on the same
> kernel function as the same time.
> 
> live patch uses ftrace with IPMODIFY, while bpf trampoline use direct
> ftrace. Existing policy does not allow the two to attach to the same kernel
> function. This is changed by fine tuning ftrace IPMODIFY policy, and allows
> one non-DIRECT IPMODIFY ftrace_ops and one non-IPMODIFY DIRECT ftrace_ops
> on the same kernel function at the same time. Please see 3/5 for more
> details on this.
> 
> Note that, one of the constraint here is to let bpf trampoline use direct
> call when it is not working on the same function as live patch. This is
> achieved by allowing ftrace code to ask bpf trampoline to make changes.

Could you please share your comments on this set? 

Thanks!
Song

> 
> Jiri Olsa (1):
>  bpf, x64: Allow to use caller address from stack
> 
> Song Liu (4):
>  ftrace: allow customized flags for ftrace_direct_multi ftrace_ops
>  ftrace: add modify_ftrace_direct_multi_nolock
>  ftrace: introduce FTRACE_OPS_FL_SHARE_IPMODIFY
>  bpf: trampoline: support FTRACE_OPS_FL_SHARE_IPMODIFY
> 
> arch/x86/net/bpf_jit_comp.c |  13 +-
> include/linux/bpf.h         |   8 ++
> include/linux/ftrace.h      |  79 +++++++++++
> kernel/bpf/trampoline.c     | 109 +++++++++++++--
> kernel/trace/ftrace.c       | 269 +++++++++++++++++++++++++++++++-----
> 5 files changed, 424 insertions(+), 54 deletions(-)
> 
> --
> 2.30.2

