Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1079259A75A
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 23:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352041AbiHSU4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 16:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352061AbiHSU4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 16:56:43 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA983DE98
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 13:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660942602; x=1692478602;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IHMEOrQ8zNxB0R72fbQ/hAXRg9LFQqCQhn0Gux+nN0g=;
  b=hBVOWdQUjCPI/0X7mc91Xcf7XPxFrS7F6JxqKRLsxX4Z370lR3kXv6y+
   EtxSvaxVFRTnzYQwoLYQgnoOjKrk1wrUTDih1b93Em0XRE6MeSMNcAKoI
   IxXmn2mjT94qqQbnd9KK9bfcsmJsKqtiSKJ/eByPZ9VfDY72h3wi8sVk6
   4qChTyHG9rR+spgVTUJvJRv/P9uxULW8ywlIzwcrRzD2alFH0iAqews/0
   QP/+zE1PG+x8NeO/fGb2yuZ69vqxPrr8j1hC4SUM3RI9y+Nxa3LowC7Hc
   mDdgUGsg34utnFW/S4nexWCruJlYjQi2ShIo3EyxK9Viu7hDSfREXil8x
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="379396564"
X-IronPort-AV: E=Sophos;i="5.93,249,1654585200"; 
   d="scan'208";a="379396564"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 13:56:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,249,1654585200"; 
   d="scan'208";a="584788582"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 19 Aug 2022 13:56:41 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 19 Aug 2022 13:56:41 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 19 Aug 2022 13:56:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 19 Aug 2022 13:56:41 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Fri, 19 Aug 2022 13:56:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ce349wZgbV45NzW1mF11dJddI+sPIFhPBVP/6e4omQp98hq64KmwSfCZrGusZeYffaKOb/11bskQLi5jUjGN+tZD18WFXm/aV99q8I2milJq9q3ZbxaDHLM+r8mJ/mG8qO7oSpIpMVVrDj4r3nE58QYkjjG4TRGmGUuBKkrgL4va/FilAJkf3KxStcnJa6cAl2bow0//Kab8kVeU1bgwzVXNFjMZy+iZ9YIV9KpD0aKcNNXGCVsimoV8PECGKBo38YpoiMn/ssG24aStWGlNGzW26J3Etvhcx/2i5XSsywHiSU1jvSdSeOrhvdUtBIRW9geClunixjL537aAbzFf0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IHMEOrQ8zNxB0R72fbQ/hAXRg9LFQqCQhn0Gux+nN0g=;
 b=ItWMVYnFn8M20iqAFMSuG9+cO4E3JC6Xjp4xUr9LMv3OgHCSVQvXSUdkaPjnR4wi10zPMbuGlaLzVice4ueGdfbmp8HKg/NfPQbJcCsTYxWWa9hyCW/pMOmNQr9ESJywOjPTVZWSk3WOQm18O2mSDrR5ZZwBkTD/dMGZmsWZjyCc6iJG2OFGXvz/7JoMmiUFTnfOsUc4jRWgLHFLls24xgYj3+uN4LqEEUTwO2WhV7Z/6uXGe9Nenx06FhDGFclYVOPhCmBAC6GRO8870bfoooOW6/pFMxORpQU8/btjTqWdvusAHH+qMeLYX18qUtCQzVclFzBXw4C6Uac8TeJ9rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BN6PR11MB3923.namprd11.prod.outlook.com (2603:10b6:405:78::34) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Fri, 19 Aug
 2022 20:56:38 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5546.018; Fri, 19 Aug 2022
 20:56:38 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Stephen Hemminger" <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "Cui, Dexuan" <decui@microsoft.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Shyam Sundar S K" <Shyam-sundar.S-k@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Bryan Whitehead" <bryan.whitehead@microchip.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "Alexandre Torgue" <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Thampi, Vivek" <vithampi@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        Cai Huoqing <cai.huoqing@linux.dev>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: RE: [net-next 00/14] ptp: convert drivers to .adjfine
Thread-Topic: [net-next 00/14] ptp: convert drivers to .adjfine
Thread-Index: AQHYs1HIageA6kENL0CfkNm3+lSqhq211uCAgADejbA=
Date:   Fri, 19 Aug 2022 20:56:38 +0000
Message-ID: <CO1PR11MB5089804163547BD4593B7E06D66C9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220818222742.1070935-1-jacob.e.keller@intel.com>
 <Yv8+GdoEEIPpSYJB@hoboy.vegasvil.org>
In-Reply-To: <Yv8+GdoEEIPpSYJB@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec8be94e-909a-46b9-f327-08da82254f7d
x-ms-traffictypediagnostic: BN6PR11MB3923:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AcVjeoF+MD8dkRTZTdmvx/WjX22u81YGA/D91fSdO1F+Vt7pTcZEuXnUOJ910Q4MbzX6LW3T8hZ0Yl38aqdxSfs4VM0UWEg8T9vTUP3ho3upXliJtGpOV8/is9HruWIzptvVQO6BnZvsQDxwqL2BCrd1ToAvn/E6W3Vazx8km5ti4pveOcD6RvkxD/G/TjGXyaatJTnUH9LcbLDUNea0NUKRjZRdOHs73zG1BWHrrySSQ0hCyC3NI1Z9379K+sNBKErXDnbEdZKzDh/V6ZxN7V+ZLPEe52H+mQq2x2zgJFgC4B3oGvVk0ilUTWS8aPnC4LWxfCpqRvYiN5gUpEzOlpwmf/tgak4WAJOgUxOE5cDL1YPb8iMiWau/KcafFyt2yHeut1XNWzRt3/yl3TEJBRJf8luagcOUDZUoQUKnwC/2uKi6qFNblGC0qRvvaVwP2CtDeO3YHMVAw/snxVtWBb+ORJTLrzabXXiukeJ5eb8x+bThXY1PHSWoNi3wDR8TG4JzSHOSnqvJteqXzq/2G8TgcK6DMoV7sCsWvSv4w9IBT/JbU+5e4CO89hEJKJvweb6PPVXHsQZOzsL3wsGaTTnqED2MmjCZifv5s+WD64f3g269L3pWNuThiFZQlglzMD3Jnm7mvOkI5+1nYjWtOrTwTSsBeMEO3xyrzU1v4C8ccdPRtfCcpYBO+TckDweYl+FUuCJB5SEhknBDclynMwPkqSHGRwfH4IJjTxIkvZcSmguAR/9awa+3UQAdKU+roKpMEfepeyXFxUNNE59jKjHf3gjN5YQ3UpaT0B604uc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(39860400002)(376002)(396003)(366004)(33656002)(7696005)(86362001)(478600001)(6506007)(71200400001)(9686003)(26005)(41300700001)(53546011)(122000001)(38100700002)(2906002)(52536014)(54906003)(186003)(7416002)(82960400001)(38070700005)(76116006)(55016003)(83380400001)(7406005)(4326008)(316002)(64756008)(5660300002)(8936002)(6916009)(66446008)(66476007)(66946007)(66556008)(8676002)(142923001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1C6aWjxGsKkhi2yJWs0yJTOOHI+/JhLvEbgENUZtUcz+GEAmGfW6BMNcqUTN?=
 =?us-ascii?Q?fxtK1vJISSx66ySMJr3K+hdr/Fse2z24+fwBNo3KrZMbX1gktaW08xtovarq?=
 =?us-ascii?Q?CX+NhwaDKb94TpLcj7Ranx+zzW5EbvpNwN5k3+Sr/o2w0rp9bgAFZU713lz0?=
 =?us-ascii?Q?DAYCmR0mOdcqie8MAKq423k9CZ/NU6jHrKMnkLqf5No5eh7sSHB1kFq3kGoW?=
 =?us-ascii?Q?q1B+pRdaCL8/QX9xcIHg6PSnfcSf3UhA3DdqRyyIUWGiunOBSqrvlHc4gwns?=
 =?us-ascii?Q?++uC1peQI6dRswCBTkzkPa2zwcW3FYm5Qy8Ou6B8paw+Y/6IpPDf/muJ3iGj?=
 =?us-ascii?Q?ym9sRXZCmongiK+lE7g4g9E4TlcjOXTF1WYKqv6fWRdQ4iX0/ISTbAmnnNQF?=
 =?us-ascii?Q?mMViQELeAb+fAoIbx0eCp4dEms2pkzxjganNT4dQ4dVT2IZeYukuM+CnNRuh?=
 =?us-ascii?Q?9mzkmn9brt0LGMfNQ/S2OGvIfFl80XzYMtD4pI1KxIOQBQ6F+UvH5QjGUlFH?=
 =?us-ascii?Q?sQoBIeUGMKLxa7QyhZMST0X0dxHqSaS8GbE9/g4Vxgs5W5OUZ+I+5X5a0Php?=
 =?us-ascii?Q?T4c33fUvReBVdD3O3JvTvuzr88SOxKQPj5/A/4N9UU52Z5HgPHBescYlmbr4?=
 =?us-ascii?Q?vEBEkS2Pv2iSuP+LvkpgMrRUYOBm6IrR/EdnYyxafS+rnsT828WMHtN0vt3L?=
 =?us-ascii?Q?UNEulEIpTME85h9c7Ee8NegJla6ntifa7895WL9t8VyaY+z/rnbU1k5RbmLN?=
 =?us-ascii?Q?zLwRaAWR4CchzqGScEhi6EfAm8fyA6zwiAksYuhmpPeT08gfZwE1ugTcIWvJ?=
 =?us-ascii?Q?+PHhjv4B7e2PlGi6NKdpCA0iFtkkNQgbGrgv98ucKWty200HDTmbHjyaKErJ?=
 =?us-ascii?Q?nyPqVVjkAosx95ePjiaV2EpXrG5AfH2EDqz4m8FaGHPRpipdO/KteOJQvzRG?=
 =?us-ascii?Q?o0RhbK/yOyom4rwsAXroPJkxfdXK2+p7bU/FIAAYejoQcbgURa5L0IsoXi/a?=
 =?us-ascii?Q?49rdGnvTVx+gurqaDYnrnGcDQleD6I1leWB++77xj/+TKKFw9VDkQ+wJHZab?=
 =?us-ascii?Q?y38BkOZdxFhpZqF+Oggp+lH1X1ixmJ/XebfS/hDjlL58IYrm43ORKT0N0h6O?=
 =?us-ascii?Q?8ZvYcWk87WajepeLi2MjuBynAhAK0rH4+e/0Iet7ZCyEprXr1RzbLF7ImLfY?=
 =?us-ascii?Q?9gDf4WDeG9iJqzddklgIF8pZUukQOt/Kcsn3lmy5/qFg9WbnrRpc1YI+QZNQ?=
 =?us-ascii?Q?ygySrAGdcNVXK+yvfRpII8IBi9lP2WJ2+oldZ1PkLNvmw6B3uh7TWn3qgq2l?=
 =?us-ascii?Q?rN21Tcu/Uqke7VgQgneYNaRw+2BSye9ltIfuRiBRU7cHYm30dfWvacPYaGzk?=
 =?us-ascii?Q?KPW4e2TfuuXLljOp4rcu2pWd0+dcKcvWiiQLVWziZ3X1PsMyhoU9eoNxCOw8?=
 =?us-ascii?Q?dulayMyFljt828n5J+WYZyw4NR/pPCG5KTuDTvyAeJixBmc2vpudwhFfjnsy?=
 =?us-ascii?Q?gBaszfhbvhBZnGv71h4s+FDDw/AIpRLJMdoxpYX5mRXRQdaIN5IiCNpasVCo?=
 =?us-ascii?Q?NTgt/8yRaTVXe4O/sxjAE5Iz76BirJCxM36XMQFa?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec8be94e-909a-46b9-f327-08da82254f7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 20:56:38.5089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2qBGdcXB46iseb0/pz9zlYaCCIEn27NeVRX1XcdVTLm9tUP+cmtRTmsZ01Lxen96H2b88hDMAznOvqI/HA6C+r1laJpXn764iaNzsVEiK6k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3923
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Friday, August 19, 2022 12:39 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; K. Y. Srinivasan <kys@microsoft.com>; Haiyang
> Zhang <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; Cui, Dexuan
> <decui@microsoft.com>; Tom Lendacky <thomas.lendacky@amd.com>; Shyam
> Sundar S K <Shyam-sundar.S-k@amd.com>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub Kicinski
> <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Siva Reddy Kallam
> <siva.kallam@broadcom.com>; Prashant Sreedharan
> <prashant@broadcom.com>; Michael Chan <mchan@broadcom.com>; Yisen
> Zhuang <yisen.zhuang@huawei.com>; Salil Mehta <salil.mehta@huawei.com>;
> Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; Tariq Toukan <tariqt@nvidia.com>; Saeed
> Mahameed <saeedm@nvidia.com>; Leon Romanovsky <leon@kernel.org>;
> Bryan Whitehead <bryan.whitehead@microchip.com>; Sergey Shtylyov
> <s.shtylyov@omp.ru>; Giuseppe Cavallaro <peppe.cavallaro@st.com>;
> Alexandre Torgue <alexandre.torgue@foss.st.com>; Jose Abreu
> <joabreu@synopsys.com>; Maxime Coquelin <mcoquelin.stm32@gmail.com>;
> Thampi, Vivek <vithampi@vmware.com>; VMware PV-Drivers Reviewers <pv-
> drivers@vmware.com>; Jie Wang <wangjie125@huawei.com>; Guangbin Huang
> <huangguangbin2@huawei.com>; Eran Ben Elisha <eranbe@nvidia.com>; Aya
> Levin <ayal@nvidia.com>; Cai Huoqing <cai.huoqing@linux.dev>; Biju Das
> <biju.das.jz@bp.renesas.com>; Lad Prabhakar <prabhakar.mahadev-
> lad.rj@bp.renesas.com>; Phil Edworthy <phil.edworthy@renesas.com>; Jiashe=
ng
> Jiang <jiasheng@iscas.ac.cn>; Gustavo A. R. Silva <gustavoars@kernel.org>=
; Linus
> Walleij <linus.walleij@linaro.org>; Wan Jiabing <wanjiabing@vivo.com>; Lv=
 Ruyi
> <lv.ruyi@zte.com.cn>; Arnd Bergmann <arnd@arndb.de>
> Subject: Re: [net-next 00/14] ptp: convert drivers to .adjfine
>=20
> On Thu, Aug 18, 2022 at 03:27:28PM -0700, Jacob Keller wrote:
> > Many drivers implementing PTP have not yet migrated to the new .adjfine
> > frequency adjustment implementation.
>=20
> The re-factoring looks like it will remove much duplicated code.
> I guess you tested the Intel drivers yourself?
>=20
> The other drivers want sanity testing to make sure nothing broke.
>=20

Yes. I tried to CC as many folks as look like involved in the maintenance o=
f the PTP for those parts, and testing + sanity checks are necessary.

> I'm on vacation until Monday, but I can test cpts on BBB then.
>=20
> Thanks,
> Richard

That would be great, thanks!
