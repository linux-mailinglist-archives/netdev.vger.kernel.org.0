Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A525948DD27
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 18:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237256AbiAMRvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 12:51:03 -0500
Received: from mga14.intel.com ([192.55.52.115]:30270 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237245AbiAMRvC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 12:51:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642096262; x=1673632262;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=m2jE1Xrco08L3VzCTmaN3TATvZrXjXwbUvRZxeCzYvA=;
  b=Ox+Ljflj23GBehAmjmUnSihGP2j1mIop6UNgNejsU3OQBkm43NnY9rY/
   9v54s6N0P93HxE0owipJE7TMf9aA/Fau1iS6oHHvdS+9glXy8aotkSMx8
   1FGmC5H7dJ59ndhBWXFd0+P5ccKdVriauwXA6HfMryQJ250wjfBfRNndu
   S6whV+wrP+Vkut+P3XF5SfQMU+bpAGUGGLTSpARzPnppTw3ohHIpE1C5v
   EPcl033E1+N6+Ka+jkI0DEgzcjgfQfepKUGPdBEDdqYwUa/2G4wLCQzxh
   xCUQspa7LKq7aLEpXwLGWiOD+qEb/1c4HB7rVunvDPRyn7SYdUk3vw9gb
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="244278072"
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="244278072"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 09:51:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="614038481"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jan 2022 09:51:02 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 09:51:01 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 13 Jan 2022 09:51:01 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 13 Jan 2022 09:51:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YBVNJz9zo2XgX9omnHDuMFBCjOZF6zZDg3Hykf4B2xiveRv+iIETUSS1al2ECNjyCqbVvemiT1BLPvAIWAKICSedJaDPX/tf52fj6wRD42mkVVTLbnvgyqf3/mPsEwNIzo/PEPlhkG/aRyJFFQwFlkOJ2GF6qIwBtYtpDRzWsSeE7be5pDmHjBPrfVTw2l40rFsygxl3gPkn7MPXZ+fRDYmzCjYgzVaNWuMZzUOU4xQtFlIP+elsOeCXoLIqYY9/ujnNhpxiZohCxKu+tf/RF/3Qa4QeI5PHRvU3I/Tf+0BkMZwrp5nMdrrLVUphE2+2nqZh2aX333VaHxqI4FyHkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VLk6jKjev9BMYcT+vFYiX5GxbDSTCbeUZzR3qUsvd9Y=;
 b=YG6njWFp/dzHgbNbCtKRJpgo7ZjPcFzBxx9884sHWTynxxqzAokMcqfT8SKaGDR0GzOeryg7wC/JmkUWQOk89Gm6EtwjVQ8jNufX2MxXgXzebA1kgBf3rvhWBNO2wi0BhP1MCofzUZPl9llqXeSKD5/e/sr3GwLLaZd9ZHG4Bh3sgbrBLWEbLQFhioUGHUuSFGIVk06JME7m6n33NdlLeuob+QqTWYzQwj2381Pp5CBsDcy0GAWvsj7LaHzRx8O4hadk13Ci/HwoEWLggo9cvvGt819Yj37spNzLck3Da5UrE7+tDdL4cA/WFKGAIKMvCTOXOGxVaVbnVk6xjapCpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by MN2PR11MB4046.namprd11.prod.outlook.com (2603:10b6:208:13b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Thu, 13 Jan
 2022 17:50:59 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b%4]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 17:50:59 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        Christoph Hellwig <hch@lst.de>
Subject: RE: [Intel-wired-lan] [PATCH] i40e: Remove useless DMA-32 fallback
 configuration
Thread-Topic: [Intel-wired-lan] [PATCH] i40e: Remove useless DMA-32 fallback
 configuration
Thread-Index: AQHYBXyct47XNXx/XUCIPN/yJ8St+6xhQSiQ
Date:   Thu, 13 Jan 2022 17:50:59 +0000
Message-ID: <BYAPR11MB33678E032ADCA171234C8132FC539@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <5549ec8837b3a6fab83e92c5206cc100ffd23d85.1641748468.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <5549ec8837b3a6fab83e92c5206cc100ffd23d85.1641748468.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c82424d4-a103-4df9-051e-08d9d6bd4241
x-ms-traffictypediagnostic: MN2PR11MB4046:EE_
x-microsoft-antispam-prvs: <MN2PR11MB4046DA11B098529B1466C26BFC539@MN2PR11MB4046.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vf8usACA+LR0UG+xzZQyBTXWzVpT80kFNuQsKuUbcZEmGy5Jlcl2s+DS6JTkNUPpc6QO2gEvBJu60ff18P6EvTFaEfcoRtObXvt3yXwRXRcr0WzSdGG2JqNW5MdJlPAtZVJ7ZaTb/zMtccU42VX7Rt7rk367F6ae9is4+0lu4cJI3Jdc/v+A3snlMDsqp9pjILddGBi7eqc2WE4jAPYmqTdkxlLheEzx6oI0vE1MAhferQQnc1D9Mtv5n9ZwxzjupH/fM1aKyHAfQXI5s6q9TsurUoQNyOZGodXfQ1gJz2a/GZiH9SrGnG0cgZ1v/vAz6wUHKmPVErd2PoNpHmTUQWDLU0qfURj2mjdCJj03cRwiAKffgADOMzJ+APBs6P724Rh8mzAndmoi3yUvYH8trS4TdADZaOpHlF67cX2bRFlvr+0WAEzja8ptte+fcon/MbCxF5ZHucTW6fds0VayFZnIyLP6DCzs2Q+Hd0QT7x1fuOSF+YvHdvoFzcn2Wp2IdMTtRyAKLEgFstR1Zt1akTTxTVGt9b9LeKj9DKLYJc+W4jcsoqvkl9wBTXQUaNxYiDcxjcncr9KNmsuTLrmLfvcFWuj7NZ9cR5rrMu1rntYFeCEgL9KxB57jeQUqs8iX0dLtm3fOC5XNWX00pDykEu8yeztjskbXVvtoT2uALxvY0pG/AjGiVGPgG0BXDFF6Sdma+sg8WOzs5BkRwmfMC0bpg9cKqgK1dkEsOS55sGEUZ9Jr6h7jEHI2Yim/2hz3pQ2IpSxhxdkdIGX4LEZS8x8Cwkh8qhGlc6P3Pvspdmw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(966005)(33656002)(8936002)(186003)(508600001)(38070700005)(7696005)(9686003)(8676002)(53546011)(86362001)(6506007)(26005)(4326008)(71200400001)(82960400001)(2906002)(55016003)(122000001)(83380400001)(52536014)(66476007)(66556008)(64756008)(66446008)(5660300002)(66946007)(76116006)(54906003)(110136005)(316002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZtNnWpFCBHdU3hTpyTOHX8C/yY/afgEWVO/Q3i1ZURhsR3vByMVsrt4v3zG1?=
 =?us-ascii?Q?Y44qXEMKKqHdeddWmi2wgg0KuqCO1LJiC02lPSWmvp8y+736TUjJuP0MRWJT?=
 =?us-ascii?Q?UNQgu3VAqIzuB2PtElFuTI8r208pU4pZFK81djme/BUQ+oaEpmsGbN7KKl+/?=
 =?us-ascii?Q?gEIPmEzro57WHLaBXUZLPD3oLvfGhb7IiPYkSAboSkCoynVi6NDmd427ZSSi?=
 =?us-ascii?Q?MQCxSKZd38riMkFGEK4ENF5MLFku7a4iRqMxfRqKIjYn/wO7yTzfeiRjCAdi?=
 =?us-ascii?Q?Q46c3hSO0Ud2uoeG9TPaomy59Gf8t+DePS87lSrKC+EPL0GWS5In1gEKE+b+?=
 =?us-ascii?Q?XqK/kjTE8tVmiuQjvmiHrm3Erb0/Xv4gQWiv2jfhykknsa5kPKXB26mTV5VX?=
 =?us-ascii?Q?P9vQbvXvsE7S1vYScg8xjHCcQcJAFNBl+PYc46+KPgXYO+tz4lLscmUJspk9?=
 =?us-ascii?Q?feUz05dKFp0xE3fJNpkBDx81Uh0+u7Wbp3vuUGYCAaaeD2uT+DjDttUnw6HX?=
 =?us-ascii?Q?0fO9LxUaCmphtgoQNUV5SND8OIHYNKGhWXRPECOv0aeIvFc09PHDwas5ijlA?=
 =?us-ascii?Q?PszWua8p354i1cmx8/PSXnzoCGqcd3QjcNKcGcg4ue+gq2db7HDj/7ZfF28t?=
 =?us-ascii?Q?32xUZmDFFlRhZ8CnAI0CzpPeLxctbxi8COejp4LcDahS/0lU+RxPgxmW1R6L?=
 =?us-ascii?Q?UlZZd2uzAk59kkdjtcBpEjzBqVOYWsdOhDkZe8vLw6asXOw/kRnLYe2+n3dC?=
 =?us-ascii?Q?ZHRrhRy4bmkvHotrHs+uUcaTbRiP0u4ifvHfv0BSR0EEslnV1qQsKg6EEKUi?=
 =?us-ascii?Q?O/X0vmslTy+Bjyvk4mwTRm5xs1OVgcuw3pP3duG9mqRfDY6byB7kFYc+3WPY?=
 =?us-ascii?Q?+CVAqImN9wFhBYZzGS3e4BM49aDscTnSgbcbC9YwPr0W11JZk1Sq3I9cvQdL?=
 =?us-ascii?Q?99H2v2lFfqIXgXhBrA5gwjxe00FcICtme2ZYj7x7JNk4GJJTsIYmV07r/W5u?=
 =?us-ascii?Q?CtehxhGlfDBly8/GrUyu3kYWu7+mJU4upaXps9e/g3fwgoN14uXFqeDyueFb?=
 =?us-ascii?Q?9PARQ65Os0Mt9ag6jNdy3YDMmP7p8GZK37/hPYXnrITtxZ4/jvVrCYBOMope?=
 =?us-ascii?Q?NNwO53ny/Pn2rfeEzKXuZoLZrZnK+r3XP8bT7i8adPnyXCTXJbdRGb5NuxX+?=
 =?us-ascii?Q?8vIclZ1HQ4ucLXRYHaICj4wCtf4CKsnqb4MH7jxSxsgX0QbnfTJDorEtw5dQ?=
 =?us-ascii?Q?db7j6g7FS97FSqwTEu+0VX8h5+/Vwf5qsOejjqreJ1W8Q3lYhqVAkavnJ7xA?=
 =?us-ascii?Q?pmGBWCJOgvR80wdo7yj1BZUl99jE2ahGdEidqXyaSlz4E1kLT5qXt/khuppU?=
 =?us-ascii?Q?5d7qUDojk1CZzX8oHFumKIaUybVp3V7irreBmhhuGLNiKCfC8NRtgpL3paBD?=
 =?us-ascii?Q?swDAy+KNpMkZM/wTaGE58uvPUbc76obNui4ewIhnBsrXWv0PP1yra3Fp4xoy?=
 =?us-ascii?Q?cpi4DIWnwqD0/MTxVPkgL4jCGriAPfxmFTAIQ6POhRAI/+WMKmH2J2xeQ+/E?=
 =?us-ascii?Q?RFervIi3tUM8fMAnHZbk6eoYbPhyHStnDkJmBoZiPnd9kKf/hEiGPpgMvUmM?=
 =?us-ascii?Q?ng=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c82424d4-a103-4df9-051e-08d9d6bd4241
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 17:50:59.7262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qSw9Q97qOsPgB6CsEA2n0RICg33fuGPrXiRfuYSkjuPx5q24kaMhbvrVwjDP4/iBYinztRdMQZZB+AgIIBFh2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4046
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Christophe JAILLET
> Sent: Sunday, January 9, 2022 10:45 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org; kernel-janitors@vger.kernel.org; linux-
> kernel@vger.kernel.org; Christophe JAILLET
> <christophe.jaillet@wanadoo.fr>; intel-wired-lan@lists.osuosl.org; Christ=
oph
> Hellwig <hch@lst.de>
> Subject: [Intel-wired-lan] [PATCH] i40e: Remove useless DMA-32 fallback
> configuration
>=20
> As stated in [1], dma_set_mask() with a 64-bit mask never fails if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
>=20
> So, if dma_set_mask_and_coherent() succeeds, 'pci_using_dac' is known to
> be 1.
>=20
> Simplify code and remove some dead code accordingly.
>=20
> [1]: https://lkml.org/lkml/2021/6/7/398
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c | 22 +++++++---------------
>  1 file changed, 7 insertions(+), 15 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
