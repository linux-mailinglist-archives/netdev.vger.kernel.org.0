Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3EB94084ED
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 08:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237453AbhIMGtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 02:49:00 -0400
Received: from mga12.intel.com ([192.55.52.136]:18173 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237357AbhIMGs7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 02:48:59 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10105"; a="201097361"
X-IronPort-AV: E=Sophos;i="5.85,288,1624345200"; 
   d="scan'208";a="201097361"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2021 23:47:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,288,1624345200"; 
   d="scan'208";a="551435563"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 12 Sep 2021 23:47:24 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Sun, 12 Sep 2021 23:47:23 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Sun, 12 Sep 2021 23:47:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Sun, 12 Sep 2021 23:47:23 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Sun, 12 Sep 2021 23:47:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4GhBNKfeOp3Q9scPJsvFYRtNfWDVJwyAPATdaBI6thzL9cjYGPL8EqYBLkCqPInpsWK1U4fIJi2kujQDJ8HAUSS23po0IeMEhIrG7rYU6XeajRBcEXkwaEnk90vz42xHQfya2HDn1I/a/pWcdv1Fdh64FnyUFW3I3WzO20mhf/ZFyGYVyHrzT+N6MXZPT3tp1evQ9ZkPUYrhKcUeUf/yNxqXG18ruMg+T9s0V6YIxT2Eau+gB2KP4iBSVnTMOcB1EQyG2sFmIJr7Ol62+5on0qxJw6LKTogXTQE6g9ihbBPetvxGtPZR3CX+Ju37lpk3R8nPBmWK/BDAOGvduBpGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SZwQeyfRUvrHAMoTE5YUgTnsu4VgbS+t6oSWrOUkDJ0=;
 b=KDjPbO09K+mjLaqU9o7vuL+59BfBbihvd5x3GC9Pq6KlXvdfJbQaE1d0DeeV/34HDRnV+1CYY/uMFE+P/aZ8lo23oP+11NUEVKGYMXUtXboOBaJ9HXgpa3ITcdCTlwtiLHFOxdX9gUCs2sZ/MDV/XWTQxLcZymQ3jPF173oNaRekjjSArOmNCWNG+9o6pDVQhT6FXQAdBkC4/rctB+vxyz/R2zfUfczO6JVa7zjSoBDRLaFOArkvGzKdUrLqgORkVkchojSj8PC+VGgek6G8k3L+ZWCydhYUUwNqge9mBw5pq7QanTvwo18fa3B2OtPdM8ynHGWGZcIxYR5+EQ9zhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZwQeyfRUvrHAMoTE5YUgTnsu4VgbS+t6oSWrOUkDJ0=;
 b=daMSNCmdDRn/q0k/PHoS9jjj1SyJecxjks0N0lQHmpDv8uab3jxfBAPQ3pBNXUf4eyLSa9BfvvgmbS0M8akNshB9tGJcFe/pFBjuTkpYi/O6ad7tGmAUlaIBG2C5ZJy5FGuXrw+Zz4dBgqD4m5P1v5Li/RvBRnGXDb+kO/UK+yE=
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by BYAPR11MB2741.namprd11.prod.outlook.com (2603:10b6:a02:bf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 06:47:20 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::472:1876:61ac:f739]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::472:1876:61ac:f739%7]) with mapi id 15.20.4500.018; Mon, 13 Sep 2021
 06:47:20 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "joamaki@gmail.com" <joamaki@gmail.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "toke@redhat.com" <toke@redhat.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH v7 intel-next 1/9] ice: remove
 ring_active from ice_ring
Thread-Topic: [Intel-wired-lan] [PATCH v7 intel-next 1/9] ice: remove
 ring_active from ice_ring
Thread-Index: AQHXlPPzcQEhpnntFUas27SgJFZVSauhrDaw
Date:   Mon, 13 Sep 2021 06:47:20 +0000
Message-ID: <BYAPR11MB3367F6285437BF1AFB7C5A5EFCD99@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20210819120004.34392-1-maciej.fijalkowski@intel.com>
 <20210819120004.34392-2-maciej.fijalkowski@intel.com>
In-Reply-To: <20210819120004.34392-2-maciej.fijalkowski@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1295bce0-b072-4efa-d865-08d9768255d1
x-ms-traffictypediagnostic: BYAPR11MB2741:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB27419C9C5AE3F15A56690D40FCD99@BYAPR11MB2741.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:773;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1VUDGZ8eJ6QmWrPkki5rgnEptGcGCZ3g2fRFggNMamdrJUsFIB4qSt0YVC26kdQq1YPXHN9JTASE+Vhjo0/r0kUYJZvR8PrUpoPDpGfDXeILbK6j969QreZPqrFtqKdhUnT+jNGLWk/FAoPcVhjyG6Q5QLQWqFt5vLLl7avi5SrK/DUUTwd9g4j7e3YXovAePg+8nrNKBOXOJXoPFfabk4vG4xBizu0Llnza/P8zbwWlc/Vf74T1Fq5UvEYIRhRg12bIHgxsgHAouIB+3ENqg6HePF91Rbd+mETi5KDNGBJ9atQJ7tBI5j8LCvhnuZjrGQJqHUXBwrcse5MjzVIJz7Fias51O9EOGx2S63+v5dcq5JSfTX9dsh1jMpQj4lZKf2en5LuhOk3M/+XH+shpUtCej4BYlc8rD9fSvQ8z8bVYTdfOQY9gebEvywsVwB4psxc+hBvW2sb1X/NSsCo4cV1DnRmQqmzUQMocVdT8WFbydiTmQkSgQBkmcddE6gSUXoHa6UNz3CczTbtgqG9JrLforZV00AVSFN28hG+B7aSBXEudCU2FmzMKaX5kDjJk2fHQxdqjkKpFQnOvzGFAjnoGpMAMLlf2hh4o0ph8UjJWxprriNPMssYqcjVgpbGwZ1RqXPCzYaC2e1N7LJFpiGRZg8o97ToDItv19RB22YCiW1OumlO93YJbwJkZHUzG2+GfSGJ/QLqFQyeXumgX4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(8936002)(38100700002)(186003)(33656002)(122000001)(52536014)(86362001)(9686003)(66946007)(66446008)(4744005)(66556008)(26005)(4326008)(107886003)(53546011)(71200400001)(8676002)(316002)(38070700005)(64756008)(66476007)(2906002)(54906003)(55016002)(110136005)(83380400001)(6506007)(76116006)(7696005)(478600001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pD7iDabByhlj83c9khBrqZ8FLfS37rkRoPNtsvH+ma1R31J8ub8M6e4DocHd?=
 =?us-ascii?Q?aPSEpQW48Xl2LhDdSAzSZanG1NBzG6x4EYDSniQ1gUD2BIIbr1agfayGI0Jr?=
 =?us-ascii?Q?IhYOWiDeGc11uXHWvT7FGCJVq1X3KZeM+UcLpP268g1Oi+KBf+X8L6rKBDEd?=
 =?us-ascii?Q?5ghhVkSP9HE+q3JZPpXJITFyQDUEVvnygc3lwVcZ35mshfD552BVElwB+F0b?=
 =?us-ascii?Q?k65FcaDQEit3IpVX+iajDRaQMjGQCPgctF9DJASfwj6VzgM4SMnAJd4o5FNo?=
 =?us-ascii?Q?Fo3QWx3fCxYEyiwgF2zRRt+a5tHiD62puKgVPTpeQk8k64CKKjfEx2SU4PS3?=
 =?us-ascii?Q?DpfMY69ELsWCaNkd6A+1NizPaYyNnWTmD2zFOI9tUjMi7pgApslMve89AiVy?=
 =?us-ascii?Q?Q4JSEHwZDuNiCV99BnN4xuzCrZCiTW/HOYS0CRo3EywqDu/6Van8tDkMwtnw?=
 =?us-ascii?Q?kfX/2LqsKlJW9u7kwVPzWjkVIR5IKJLbrhtiLuG4rqJcJtSNCwWdnByuZcLz?=
 =?us-ascii?Q?Tdg7SOQmTt4vvt4kyVmvzF04KzG1XpGaUelDbQlzI3rNnj+dePSQSWXg0Sfs?=
 =?us-ascii?Q?5x4cjbIOfewagP5ZOJRaB0hRrCEhZ7EEBna29XnyT1g54GtqyMoRkXC6RIcf?=
 =?us-ascii?Q?CE19O6sqs47Fsk4XopNplzDLeg3dbQ/Px6plNb0SksSIOTcW/paGW3CNa3+J?=
 =?us-ascii?Q?hOpgPyF7h7Jy5KyiX1MBAVh/pvyTqCeq3fOrs/nvGp+2i0NnJztWrbBFfKzF?=
 =?us-ascii?Q?8AmU9I6moZvUDim/EDhXcCAd37R9jZ5vb0mKpW/3pLk0ChMjqpGcgXOMzpmC?=
 =?us-ascii?Q?zAvmoYyUxuwf/1oRLkVYOoAwMTd6z5/bXJnGQVqH5cT7GyPAZloIMueK1y1A?=
 =?us-ascii?Q?Sxpd3r/+V6fCTGgucXnZuKhN8G/Xj2PwCZCPSqieVLqyYtNAcEwHQmrQhkSO?=
 =?us-ascii?Q?YYvX2B4sDbDsIT6CiJHVBbhCg+RY5qHAl2OEK8vLrC2Vf2Zw3awBX9mU9V17?=
 =?us-ascii?Q?kpmi+ejZWSl2LuvIZNsmffmRGZWoO8+hZzRWAETZWxNwU56NxcLivtYtsgDL?=
 =?us-ascii?Q?cu4TWyL5CHIwftqEhZXVD11xwOF1j0fTA01K63DC00M0HnBXbsAYQNr5jf8X?=
 =?us-ascii?Q?OZd8GBBKwfpMRdHU8DBeuiPfU4VRsMLHJ9cdKtLVuPQy5h/66jWiJ0/xXU2Q?=
 =?us-ascii?Q?Yid7ZdHp6r9dCQnHiveOYCKhzhX10hAaC+E9kV3tM/c+wAZRwmMUCslApKg+?=
 =?us-ascii?Q?q/fHDFPTHymuPV4MqS5oxBNChP601txEkBctdv39WjpQzCp3Mmqr0PndmJiJ?=
 =?us-ascii?Q?CvIjKsGhIiUnttw34ClNgAk/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1295bce0-b072-4efa-d865-08d9768255d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2021 06:47:20.6268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UxSVdEZcpyz2ah+zbi/N3jKvjId9+rSoa0c3kj88sEuBszeYURfvhukXX/WPalhN2m3ksNue8Hpujhl1KK+/jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2741
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Maciej Fijalkowski
> Sent: Thursday, August 19, 2021 5:30 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: joamaki@gmail.com; Lobakin, Alexandr <alexandr.lobakin@intel.com>;
> netdev@vger.kernel.org; toke@redhat.com; bjorn@kernel.org;
> kuba@kernel.org; bpf@vger.kernel.org; davem@davemloft.net; Karlsson,
> Magnus <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH v7 intel-next 1/9] ice: remove ring_act=
ive
> from ice_ring
>=20
> This field is dead and driver is not making any use of it. Simply remove =
it.
>=20
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_lib.c  | 2 --
> drivers/net/ethernet/intel/ice/ice_main.c | 1 -
> drivers/net/ethernet/intel/ice/ice_txrx.h | 2 --
>  3 files changed, 5 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
