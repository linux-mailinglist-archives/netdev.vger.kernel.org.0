Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D95E258F6A8
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 06:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbiHKEKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 00:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiHKEKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 00:10:47 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2138.outbound.protection.outlook.com [40.107.220.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8342F760EC;
        Wed, 10 Aug 2022 21:10:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obZHU+LW/ocheFmGS76XSk+kX80RcumoD1Hp6tV71kDdwe3Z5WNXCLFsRhIxWuQ051TXiUGOtdVrjN4Nki5Gr1hGd+yGe+TU6JHJNT0h110oQ0FYZe8zCbK4E7qtdnykrnv+JIf02Gc69RPRQvffvQSuUogEKrjzJaI9xcIy5prxlbNMAOGN+2VM2FL1lPHJ9pOJSbLc2mjctdmHwRuoVPJ7yfebRKuf5JfY+2Z1SYOOel+mZsV1RnlsX8rW88iOYfBXYQvELgyhIIO7QX/8WeXI8TcOV8+thh/2lI5k1npD8CJ2GLxX8cORvw1wtNuSkV82W1EntQ+Fpf3URF/TLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9oIkrrqnBXkj+6NXNIgAOGAV54JlA3sFcjDQGVRToyo=;
 b=ZzztDJEfH4VRNgJ1dTQwuolyOrFJ5ajOtJhgI2rELdSORGtsLi8oZM0FHgOmRw1V7YebqK5jEzFySVegoOXRb4OE8grapZRtew+YFlkhPdGf+dI9H/Nx6ONHYnP4Q5inx5RcWn0Q6VxlO+WsJYEzGx3hME781ElGs8idKmKcnmvzBW2NKbCgwvtAM5ggigLLAGhDCu7NWXsHbdZ5e3Czc2Iiec4gu8lkpDSestDDF49BT1KnCIeGw2EdLOcfMkiMBgsfj3597RTq8nZ2Z1PR59XdH1T5co7IcwBNInEv9f5a/j3o1CbPPg/ra8ktRkilLrx7wgOzzW5Y46jv8nTeAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oIkrrqnBXkj+6NXNIgAOGAV54JlA3sFcjDQGVRToyo=;
 b=p2L6hJRlfl7TqL0hks7feCmLl9cctBxbyJkgzAuvEN41P1QlmFm82Iaiw9qbkrFk0Ih06gzuNG2+lRkfOJN3X4fzUdEomLCgA2q2pye4iHHZ9NOwPo4knz77qEJRjikS6RpUFF6xeeEwuAx0Q58q3uIlGeLqtwUvkQzbFQ9Q5v4=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by SN6PR13MB2303.namprd13.prod.outlook.com (2603:10b6:805:5d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.8; Thu, 11 Aug
 2022 04:10:44 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::a9d5:4b03:a419:d0df]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::a9d5:4b03:a419:d0df%6]) with mapi id 15.20.5525.008; Thu, 11 Aug 2022
 04:10:44 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jialiang Wang <wangjialiang0806@163.com>,
        Simon Horman <simon.horman@corigine.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "niejianglei2021@163.com" <niejianglei2021@163.com>
CC:     oss-drivers <oss-drivers@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] nfp: fix use-after-free in area_cache_get()
Thread-Topic: [PATCH v3] nfp: fix use-after-free in area_cache_get()
Thread-Index: AQHYrIts+CmALgI/0EerXA0w0lgyta2pFsSg
Date:   Thu, 11 Aug 2022 04:10:44 +0000
Message-ID: <DM6PR13MB3705E2B4925F8BA9B1482DB3FC649@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20220810073057.4032-1-wangjialiang0806@163.com>
In-Reply-To: <20220810073057.4032-1-wangjialiang0806@163.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 761653bf-41dc-4db2-d76a-08da7b4f766c
x-ms-traffictypediagnostic: SN6PR13MB2303:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zt8BJWUZmLpx6XgUM25usk5Bs0UbzCr1oPXFluiTK2saIPN9xIJJIkWOBv1xHHMI61WL66f8w/uPaUIapq7mscCtRbJPYZyfLtIj2RWsppdjsYFmGSoRyR22iAvBFXLeDzZJW2WHEoVplCvpoNw1ZV3CaIVlmTg665Dq2eU1w9/AMTuU81BqBVKNJ48L8qRpRebSLGdc2eP8qklseadzoYSL7gYPgFrEhMwubZWA7lnB5DwWAJh/378lMUgds1Ydsa1tIzRw8To08Nif/2rtlFNZsDOV+MiYe+17jKVEMnKjK/6sosH8mnvdVvagZIa2/PIgENbMabVtMsn+g77Q3SkCN6tR1QsuddvJEdWB3FIcmN0x+ZRtyryTYtRuEYrX0sHhTYESTdK1YyORjN+NOqhPEL3SURqG6d4s2b0Olid57i8rlkULi/m+5jCvezKDUTMYT6CAAbjYCc/rAG0K0U3dXTLhIA/NKbYHdeG7ZdJomilLZCJQlZ8cg9e1OnfoP1c4kx6jaGyEm3lM+KATp9K6SvF4zSIKfmnEv50zUU98DLcV+l8QZ7tdkLqdwYYrus69pUuwJuadSVQNhuMT0wcy/eyozIl+6vLg3nIgzNMNCm9tTdfBz+RcJQvxk7gF+hj9E7NDYdCOCouyw9Vapr4hzkrUWnSRo4s3bvtcBZ28fW5dA1ChWwpZcq1OAXDCbpA2nDogCuAipI/vtnCyw8MzNeCqz/XIGuzujQgyNejK2cxmozVByMclFCH2YwsieRW8109nTYg0We1mNY/nH04LAOZrFCG4jb7T5sRwB4K4w1slZ1E89VXAtuHR6LNK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(346002)(136003)(39850400004)(376002)(478600001)(54906003)(38070700005)(41300700001)(71200400001)(26005)(86362001)(33656002)(7696005)(6506007)(110136005)(186003)(9686003)(4326008)(316002)(55016003)(8676002)(66446008)(5660300002)(66556008)(66476007)(64756008)(76116006)(66946007)(8936002)(44832011)(2906002)(52536014)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rKCRn2ZsY7xMgZqsafGrnfOygECZiQ1blJsx3c6RBwGhV7Jj16cHp5ef/UN/?=
 =?us-ascii?Q?Rm9fOR7IHDiTYb8dA4ZKdq7mKO8dnpIYyQPJ8uZhVP4r7vPej+k5Jw1jOpJj?=
 =?us-ascii?Q?/IHq4JpkB9toURViNf9g4WwLS+s4//BLFsTaRs2mLsFJ/NuUFbfZjA4Bx6xg?=
 =?us-ascii?Q?w+eG55zMBRFW9aMqWR3vLrz2t+0lhsTt9xWSd32FaUVTuH8if8Wh+mOVO6y0?=
 =?us-ascii?Q?0wsquQV9m7Di5fwLoNLfHaFoYVxFE0XoR/YJGRFB8clNPgpLFSIGqiQnt90m?=
 =?us-ascii?Q?ak1HQE5NcpcFcGb+BJLi4B+hKITMOipWJbEE3gRIPQpzEu37eaC0mLuiNPLF?=
 =?us-ascii?Q?ZpyXpIUP5pCu5mhCPKiC46lGcpkoSduqKsdxtaRFhen6el80TT5idA4guqy7?=
 =?us-ascii?Q?CLSnRHzqX/hglhyJC+1imQ8b30kuypXqLt9fxJaiDkjWBMj7GIt727OhkfLJ?=
 =?us-ascii?Q?p2f6ckk6RiKWbtU/ujBfo72A9ItJKr0x0Ui9oAoNJmgkBDFN/Qmf9lOIMn+3?=
 =?us-ascii?Q?ohpuuzLkc5x8iUHGcJcz4fav4UuQEdqgs8A1gu6biIEX+NsrigQntQw6BqiZ?=
 =?us-ascii?Q?THDXKsRQU0RgSeuVeXhqqEK3jyqeFnIyysaUsbNC8lNhVIsHXIhyLjiXv/HD?=
 =?us-ascii?Q?K5Hu7sJVw+ghaZDCANwo3nmOlA0cUP80T1m0rlJM0AHmS4YaQ+fUvoWKIAKu?=
 =?us-ascii?Q?kNY3lL7LPV5nPuBsyagt7l1mtyVUDgYrh7G/BapE3T5rkCw/oYgxuaBhPmYk?=
 =?us-ascii?Q?+Mkov9HuepdLgpjILjxphNK90qKvVswiYvvE7BqENadu/BPFehQ2q1AT57AA?=
 =?us-ascii?Q?/MLzlPuISqeO1GpdFvEQX1beQELrxOdht+2usn9+LElzorgww6FNd0caXPJh?=
 =?us-ascii?Q?fwJ1snIazRykVZsWFNC7raB4Qz79mtobKfXehdyuVUiltngMHibXZCnP+P1u?=
 =?us-ascii?Q?VxWvvh5ho8q+Mr8IOgBmbtb3KVQ2cQlyaDwIoygYiGMceY/m3CYc0uAa/jxa?=
 =?us-ascii?Q?/W2Z4jkp/60XIHn6qIcU4FNXrpmj9fVC9yirDDP805bjgcq4qyuidvFrdYmI?=
 =?us-ascii?Q?o8oOMOPP4S3StiSbV79xXwQZHbLbtT1R2ldY7eDjMCd7l5GqUIWQSoOYVmgu?=
 =?us-ascii?Q?23Tl8S25+thJrBxLP7lrGCtBtnS+iF8saxrqIh18OxgGfIlTDffGCR+B5VtO?=
 =?us-ascii?Q?i9ZStQWdI9ns/nGN0bxKBtXvGoB0rV3VJ6paSdudN/yYVe8+yDfKrTj0yOJ8?=
 =?us-ascii?Q?sNNc2cBbcn0cdiDLQHjtyGZBjNSYCI08aquiwhN57x2RfzwjuUMrrbX84Nif?=
 =?us-ascii?Q?Z0zh6BDoZ8SgGVm2fgu7aYm5YtC1axHWrp4PGa4/urHrey525HpKbrbQDdWy?=
 =?us-ascii?Q?ogI8UtZfQhO100tJWBqupZu+WuewRXA74CY/Z9och2t0DCoDQD9uow1VP8P2?=
 =?us-ascii?Q?f3p5bijdHb55S9a1HkDj/wAOguJtcmEY4MY0GQUU2kk6W2D127Tv4X/C9xME?=
 =?us-ascii?Q?KdsMP0J7eVqXDX4mPFpd91HNgt+Ko/lk0GSyVMJEFRXbdisI1VDS9DQwkAa+?=
 =?us-ascii?Q?7dvMumtEsuy27mjGso2hVH1SOhEEcfV8rXPR7Ii25M4BILfRffUDwXC2ye05?=
 =?us-ascii?Q?BA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 761653bf-41dc-4db2-d76a-08da7b4f766c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2022 04:10:44.5511
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +8791X+J1K8eUuJHMypWzXhl739ci6D0bcuYMmLcBGc16RtClbLY7j4FpSgeBk4GD+Jl/R7e11AfXDR3Ti3VYCPDYDlveWjI7zao2H4XNfc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR13MB2303
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Aug 2022 15:30:57 +0800 Jialiang Wang wrote:
> area_cache_get() is used to distribute cache->area and set cache->id,
>  and if cache->id is not 0 and cache->area->kref refcount is 0, it will
>  release the cache->area by nfp_cpp_area_release(). area_cache_get()
>  set cache->id before cpp->op->area_init() and nfp_cpp_area_acquire().
>=20
> But if area_init() or nfp_cpp_area_acquire() fails, the cache->id is
>  is already set but the refcount is not increased as expected. At this
>  time, calling the nfp_cpp_area_release() will cause use-after-free.
>=20
> To avoid the use-after-free, set cache->id after area_init() and
>  nfp_cpp_area_acquire() complete successfully.
>=20
> Note: This vulnerability is triggerable by providing emulated device
>  equipped with specified configuration.
>=20
>  BUG: KASAN: use-after-free in nfp6000_area_init (/home/user/Kernel/v5.19
> /x86_64/src/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c:7
> 60)
>   Write of size 4 at addr ffff888005b7f4a0 by task swapper/0/1
>=20
>  Call Trace:
>   <TASK>
>  nfp6000_area_init (/home/user/Kernel/v5.19/x86_64/src/drivers/net
> /ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c:760)
>  area_cache_get.constprop.8 (/home/user/Kernel/v5.19/x86_64/src/drivers
> /net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:884)
>=20
>  Allocated by task 1:
>  nfp_cpp_area_alloc_with_name
> (/home/user/Kernel/v5.19/x86_64/src/drivers
> /net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:303)
>  nfp_cpp_area_cache_add
> (/home/user/Kernel/v5.19/x86_64/src/drivers/net
> /ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:802)
>  nfp6000_init (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> /netronome/nfp/nfpcore/nfp6000_pcie.c:1230)
>  nfp_cpp_from_operations
> (/home/user/Kernel/v5.19/x86_64/src/drivers/net
> /ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:1215)
>  nfp_pci_probe (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> /netronome/nfp/nfp_main.c:744)
>=20
>  Freed by task 1:
>  kfree (/home/user/Kernel/v5.19/x86_64/src/mm/slub.c:4562)
>  area_cache_get.constprop.8 (/home/user/Kernel/v5.19/x86_64/src/drivers
> /net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:873)
>  nfp_cpp_read (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> /netronome/nfp/nfpcore/nfp_cppcore.c:924
> /home/user/Kernel/v5.19/x86_64
> /src/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:973)
>  nfp_cpp_readl (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> /netronome/nfp/nfpcore/nfp_cpplib.c:48)
>=20
> Signed-off-by: Jialiang Wang <wangjialiang0806@163.com>

Thanks.
Reviewed-by: Yinjun Zhang <yinjun.zhang@corigine.com>
