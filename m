Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5D741A644
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 06:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhI1EEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 00:04:45 -0400
Received: from mga06.intel.com ([134.134.136.31]:46386 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhI1EEo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 00:04:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="285626870"
X-IronPort-AV: E=Sophos;i="5.85,328,1624345200"; 
   d="scan'208";a="285626870"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 21:03:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,328,1624345200"; 
   d="scan'208";a="456475276"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 27 Sep 2021 21:03:05 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 27 Sep 2021 21:03:04 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 27 Sep 2021 21:03:04 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 27 Sep 2021 21:03:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NwhnnJRUS4TnQtxRkX9+eow2MvUqRNeaiSDRi6jSsD6TBcIAvntLyn8eWpGiM7FhqRbim2RjFEkGQoodjq+Nq8N/2o6r/d30xVJOzhxveLtaDfQ7qxItzNfB/MTZ5z0gkCXphaT07G5UUAnRKPbpXSbVF1Z7jWf0yxcMFy953jOOtZLNAKeQtR/LcHceVh2Y9B85azmrlnAvyhs4jd6alp1SdCCIAjxrPXHynp50Q83drM/15yQCzXKpsLRpT/RcGuGXkLKWVn4mTN2P+rP3LeT14yT8uCInuI7OotG0JQCs2o5fMHtf8jVkUkxEKxRRIUJI81oCfWcL2viEZwvUag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=h7fxcbnQyMKUSDyMr6MjGItktorKIQiBfq3YE3PbpQo=;
 b=IT1OlQAZwW7x7LloNG0TQIkHBV5X7jYmN28YpfOhTYPjUEWXp/XHrjsGaiCgKCoz1otKf0NeJHjZo70XXdUJ2l1jb9mOWNOFuRGvyMdgvrUb4XPLMy0MSJShrvoxERmvIZvXyYOltSAyRBzS3fLNDpWSI4cvG3YZizLp3R7txdfPPq3eKYcXVbzh/xPvgbxCVbrjVOgR4o1XTGyK+q36mvJO+hkBWDloxSaQvvbzOcELbUF8jbu/3ICKsCeh6Ougd0PbH0CCQOb50rcfh6Cosil8IoTYcuQ6qeBNMzMVxASZzdrVAm5IZtc3ge4ReAni3kC0BK894oKV3FMlDOxzMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h7fxcbnQyMKUSDyMr6MjGItktorKIQiBfq3YE3PbpQo=;
 b=kHqEm3UE7qEmzaqCY6B0zmaS5gapgn5SPefj792zpNNkHOtPwuvoq4VhR2Y5Fu6uHuCv2oI0l9E9gLAsevIWiH6hVj15Ns+8KY/NC0B+F2iLWuw/7Mw12KEBmSBtakj9426B23FHYisieHdWv6/UrF6mt0Fk6wp88biMSUmF6Gs=
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by MWHPR11MB1375.namprd11.prod.outlook.com (2603:10b6:300:23::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 28 Sep
 2021 04:03:02 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::a8a8:6311:c417:ebdf]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::a8a8:6311:c417:ebdf%7]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 04:03:02 +0000
From:   "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
To:     "kerneljasonxing@gmail.com" <kerneljasonxing@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
CC:     Shujin Li <lishujin@kuaishou.com>,
        Jason Xing <xingwanli@kuaishou.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH v7] ixgbe: let the xdpdrv work with more
 than 64 cpus
Thread-Topic: [Intel-wired-lan] [PATCH v7] ixgbe: let the xdpdrv work with
 more than 64 cpus
Thread-Index: AQHXnxodNuAOE0/4vU+mtMk0gqjMO6u4/REw
Date:   Tue, 28 Sep 2021 04:03:02 +0000
Message-ID: <MW3PR11MB455445ABC2EE8E063D72AEF89CA89@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20210901101206.50274-1-kerneljasonxing@gmail.com>
In-Reply-To: <20210901101206.50274-1-kerneljasonxing@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4375506-5f6b-44ff-8fc8-08d98234de3e
x-ms-traffictypediagnostic: MWHPR11MB1375:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB13752B671A71FBF9EA305F7C9CA89@MWHPR11MB1375.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MOO52P3l+gMsFKfroWLg9OsG5MvB+KLHloboaPRV3lbQbHa06waNM/Hz6gvS9kuLGen+yGhRSPP2n5s65z04OqJpGMx99+t/JiBmbboI1qzm96n08m2H7geiAa5NWjqduabMEi1kqH2DtPiRaxXuc82+s1cLUd8lPfGu+9snaUMnuyu03ZguE/SGPFBbi9H/lX5IwIErefeHu5IllP3a74n7DKCo0Iu+QTbJIa3bnUrnM/miEofUL+OKvurpIz6AlYZZg7rR0cSXQMBygkVkOD+hyazjQC2q1xL5kGw5me/pBdQ3y6ye+fS7VSo3sErr+Hf9PGzuxbo/iqV9WJ2zZCQUJjxKXxeaAkhoMl4qdnQG7wObyUSoL/p/7dtAOpu1PPK1Alw4exnp036JtaCB5pm2GHyPxxI4O2cBvc3q5/lnXUWOG5OpxqIqquFYJAOESpAQyt0SY1NCGYTIOLhFW9SohhY7KHvmhT8Tb/8DlAJ2KP4RNV5NBTrcL9YwhHXxd6/iyk43429hCZu/+t9Ga+u7Each9XVSgbuT1vJOeR3XRo+Or/aVuqgc8cWl83Bay7wywtT7l4h+dQqpcejUw2ccb8TSGtIU+eCL4naw8+1Yo/g40CoXp0Emwt9c67M+YRasZPmwhRrmnOLwn8usPgOU9kc2qXTNVDq/O1bgxADAop00AlUomykrLdYMtlRgM/L7ZBxNX9fksazIkZZ1TXGRJ3ZmYlvoBngBP3XuJst/vFC38JnMPXneCNMoK/z6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(38100700002)(6506007)(7416002)(55016002)(83380400001)(66556008)(2906002)(66476007)(86362001)(66446008)(921005)(64756008)(4326008)(5660300002)(508600001)(7696005)(8676002)(52536014)(66946007)(110136005)(122000001)(33656002)(71200400001)(76116006)(38070700005)(54906003)(186003)(316002)(8936002)(26005)(40753002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eGGwxR2zG/FMkmzxU1s9P2YuaNdNhUb4qd5DGMdkNlF+ZldmGuhcLZSXck89?=
 =?us-ascii?Q?Odxj2IxEf0GQojekBha/m2t7yJ2ARd4jXotr5rAb5oSvBa4jqnxc7K2qv5SQ?=
 =?us-ascii?Q?UK0mEZ1z4z1iWG4GsHlBqv1JpJfd1wOp4JlNdZi5e8apCbQ8MqNrdX7eLVqk?=
 =?us-ascii?Q?AoIypF5j2/J42et/5m/AHi1JwTA96VKDjy8AJQC7RCDzszz1ME68j+3e849S?=
 =?us-ascii?Q?yiahwa+hANmip/AXSRleSaE4JGscVWFZVHYH/E+x/Z0HSvNuWcL71mrFpmFn?=
 =?us-ascii?Q?dqloC0exJWGLf9SJCJkTVdhJdqnoh2qmpcc8ua7pbPiVcRC+vSE9EOAAiKW+?=
 =?us-ascii?Q?YYUp75zWS8olXWSD98HlqEK/4NS5Z2jco1UXerTExTmHhqOIJRIC2WGvkYBG?=
 =?us-ascii?Q?BD/kltQMJFxoL7Uk5jjGPFJhV4wjayN9X7XrkPYPMDsYurz929348CAZ0ByH?=
 =?us-ascii?Q?hfM/8MGtTLgDCGpIp59UzHnCTrXqSz+c3wmo9LvI3Gdsf5WHIpvG/NMNXIoc?=
 =?us-ascii?Q?g49dSqMk82FznnQoUgOqN8YQmKv3k/eLOQHh3EsNJum9SjkGzYOGtvIWSgfW?=
 =?us-ascii?Q?JriN5Gm6eNn4ZgD/6mQm2UqsQG1xFIjf0uRQUhTqeoyVobH7lybf3BNATf0F?=
 =?us-ascii?Q?igwLIw4t7cLDZgQ90LsKaNrMpRZvbHPKV9coiREtEthRuGHvlCLZ14TVYr4b?=
 =?us-ascii?Q?1jUYM46oAW5pOdYMcKJjhuR4mCu17nD6bjW2/0IXsErB2j1Pi1tBWYKwus+W?=
 =?us-ascii?Q?fWSk6fzZXNGfxIUl14ZBWI7Q7+1ac0Z8m6EYh02pg5da56xz/QpnejGJHvyP?=
 =?us-ascii?Q?J27INWcU5aKbKyVtlP9HQZCneMznkYOwOhW+ECrQJ1jtsdxHoB9uRSdkJ2RK?=
 =?us-ascii?Q?2GXbKwmW7KoPYpSNU+kJl5Jv60K2tlrd30OTYLE3Ph48Lg3vhY12ngVSPnxr?=
 =?us-ascii?Q?A5JBq/3JLIXreYdDUcsEKOUTune/3moNNTGUModQJ9+6VrnBZsceHdDbwDMW?=
 =?us-ascii?Q?/a4ZKXUcGJD8hqWIfT8g9bd9tDGRYFsL8ZFcsfWCdNj8/ImZQ8mTtukC+vji?=
 =?us-ascii?Q?9eM9gNPzKQErzuOw0fC8naGVnsdmIJRuCHK9dV8Vx3jqH/Mb8NxmZzYBlMn8?=
 =?us-ascii?Q?GYL3m5xbv7B0vZm5eYCxXM1JMGzwqpHLyudvkczc6wdnBaqT1XvpSGoFp5/t?=
 =?us-ascii?Q?NTb+2KSXPa1KPcafJnqQUBYXPVYzfWX9hk0fTijoUMbDBFn3uj4kCMjgO7Pu?=
 =?us-ascii?Q?WgiI1QckMZ6TM7o+PWQ3kn1SFGDhQdIxVb/hnzAU18qt8Hbj7dTYRVArQoLY?=
 =?us-ascii?Q?GXwE7wTrNAzp3gJCj23EJdER?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4375506-5f6b-44ff-8fc8-08d98234de3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 04:03:02.7361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PIhUVX2rcM44qjV00WquzvsuHTxvEIlAsAYwsCracjGBTzdaUw57F9K6hdEI4marU77M2AC7KPxsIihPkYXH5v488AWsBbGYWNI3ppGqa+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1375
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>kerneljasonxing@gmail.com
>Sent: Wednesday, September 1, 2021 3:42 PM
>To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
><anthony.l.nguyen@intel.com>; davem@davemloft.net; kuba@kernel.org;
>ast@kernel.org; daniel@iogearbox.net; hawk@kernel.org;
>john.fastabend@gmail.com; andrii@kernel.org; kafai@fb.com;
>songliubraving@fb.com; yhs@fb.com; kpsingh@kernel.org
>Cc: Shujin Li <lishujin@kuaishou.com>; Jason Xing
><xingwanli@kuaishou.com>; kerneljasonxing@gmail.com;
>netdev@vger.kernel.org; linux-kernel@vger.kernel.org; intel-wired-
>lan@lists.osuosl.org; bpf@vger.kernel.org
>Subject: [Intel-wired-lan] [PATCH v7] ixgbe: let the xdpdrv work with more
>than 64 cpus
>
>From: Jason Xing <xingwanli@kuaishou.com>
>
>Originally, ixgbe driver doesn't allow the mounting of xdpdrv if the serve=
r is
>equipped with more than 64 cpus online. So it turns out that the loading o=
f
>xdpdrv causes the "NOMEM" failure.
>
>Actually, we can adjust the algorithm and then make it work through mappin=
g
>the current cpu to some xdp ring with the protect of @tx_lock.
>
>Here're some numbers before/after applying this patch with xdp-example
>loaded on the eth0X:
>
>As client (tx path):
>                     Before    After
>TCP_STREAM send-64   734.14    714.20
>TCP_STREAM send-128  1401.91   1395.05
>TCP_STREAM send-512  5311.67   5292.84
>TCP_STREAM send-1k   9277.40   9356.22 (not stable)
>TCP_RR     send-1    22559.75  21844.22
>TCP_RR     send-128  23169.54  22725.13
>TCP_RR     send-512  21670.91  21412.56
>
>As server (rx path):
>                     Before    After
>TCP_STREAM send-64   1416.49   1383.12
>TCP_STREAM send-128  3141.49   3055.50
>TCP_STREAM send-512  9488.73   9487.44
>TCP_STREAM send-1k   9491.17   9356.22 (not stable)
>TCP_RR     send-1    23617.74  23601.60
>...
>
>Notice: the TCP_RR mode is unstable as the official document explaines.
>
>I tested many times with different parameters combined through netperf.
>Though the result is not that accurate, I cannot see much influence on thi=
s
>patch. The static key is places on the hot path, but it actually shouldn't=
 cause a
>huge regression theoretically.
>
>Fixes: 33fdc82f08 ("ixgbe: add support for XDP_TX action")
>Reported-by: kernel test robot <lkp@intel.com>
>Co-developed-by: Shujin Li <lishujin@kuaishou.com>
>Signed-off-by: Shujin Li <lishujin@kuaishou.com>
>Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
>---
>v7:
>- Factorized to a single spin_lock/unlock in ixgbe_xdp_xmit() (Eric)
>- Handle other parts of lock/unlock in ixgbe_run_xdp()/_zc() (Jason)
>
>v6:
>- Move the declaration of static-key to the proper position (Test Robot)
>- Add reported-by tag (Jason)
>- Add more detailed performance test results (Jason)
>
>v5:
>- Change back to nr_cpu_ids (Eric)
>
>v4:
>- Update the wrong commit messages. (Jason)
>
>v3:
>- Change nr_cpu_ids to num_online_cpus() (Maciej)
>- Rename MAX_XDP_QUEUES to IXGBE_MAX_XDP_QS (Maciej)
>- Rename ixgbe_determine_xdp_cpu() to ixgbe_determine_xdp_q_idx()
>(Maciej)
>- Wrap ixgbe_xdp_ring_update_tail() with lock into one function (Maciej)
>
>v2:
>- Adjust cpu id in ixgbe_xdp_xmit(). (Jesper)
>- Add a fallback path. (Maciej)
>- Adjust other parts related to xdp ring.
>---
> drivers/net/ethernet/intel/ixgbe/ixgbe.h           | 23 +++++++++-
> drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c       |  9 +++-
> drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      | 50 ++++++++++++++++-=
----
>-
> .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |  3 +-
> drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       | 16 ++++---
> 5 files changed, 77 insertions(+), 24 deletions(-)
>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
