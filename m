Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7EC50E4FD
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 18:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243125AbiDYQD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 12:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242684AbiDYQDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 12:03:23 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79EC0DEEF;
        Mon, 25 Apr 2022 09:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650902418; x=1682438418;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8irAdl31TZLLYfGyf7m/k7Yk0wQ6TZ24liPMVe+3NRM=;
  b=HmwJyVnG0ah7oUzKId+TRsp1VDtgjGKoho5pFke15ZzUuohW8XYX3nt1
   mSK41xbKk+zOdwxuKlE411JrHogyobaS7UT4viybxsocuqpCjNCegjTj0
   2XeeIvqQfMgpdyvfi4oIw5okp0lAQYW1YiiDlnbmS8FPSLFjp/ptvG6O2
   fwFcBe9/jxknG5orvj8AOHIVFZuHwpB/9tfw+UMVQsv/mO5Gceh9AnSEJ
   4U3wMeX8Sp0E/4/64YF5d48/+Kz7bZrPxePS9wAiMvvZalhH35NSmIea5
   yyQ2dp5lNHPoO8ougns8b1wlMGsUA25VIhSU1X1ya1aSjR80BOAd8t9sh
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="351734288"
X-IronPort-AV: E=Sophos;i="5.90,288,1643702400"; 
   d="scan'208";a="351734288"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 08:59:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,288,1643702400"; 
   d="scan'208";a="564144785"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 25 Apr 2022 08:59:59 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 25 Apr 2022 08:59:58 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 25 Apr 2022 08:59:58 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 25 Apr 2022 08:59:58 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 25 Apr 2022 08:59:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kx/Qp90JxpzJ5xg9WVYJUByB8a54mPj4W5Ia+OqGHgdaCRwpD1ZuOCL13sP4DHXPvG+ywUcFt2xVUS1sRyUlS39mUVlpwP0aeLEeqDSiLK0VSqTMCpuLrJmbkYXPeETWl5XYxYJykOnDBDHF183XGZoq7B6mUo5spTc3Y/n0piSJrpUZHIH/w4rUJv4USvqnyEidH4WuMSaGjY08TpCrvvww4kkFFqNBz5V2Xk3E11wBciECIZLADf/SeU98hg9U0EidqYzNIHRWNfSm3z10cEev8ZwG9b0ugGia3ABfLMhhBzOa54HuVQVxRNnci6kMsOoLXVUjfBPL0xSs1AKPoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RSCgO63enbxYmjXQIzg940Vd4nea5g0nFqme+Yp39D0=;
 b=asFv+YoMvTrncg+9G0FkulMsrqGhryzsOics6eFxZTqro21uLs2fnYS49yWqgKgzzaEEpBsGLNj2Z/Hurh2aKkEHMhd1Et38f4kM6wd8hy56P3m3AFs8KXn0OZoLzFrb1VSN+OHiwHu2gWet1cbnnFXt+fghmdfMvPtFhq3B5EvefeENOmQcqArL37MtsKKLxpXdfgfDVI/P4/517G4ZsOtpCFC9ycvDgqjpeu81cyp96D3ZM8JwCyzR7cnyRxk8O+1ALbTJOy1VxYLAICz1N7Hu7VQqSr9383LLpS5J2lv5r0+HHGYUMbq4eVEBAOn49KItehl1p0mtJRT5Wc4cAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18)
 by CY4PR11MB0037.namprd11.prod.outlook.com (2603:10b6:910:77::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.18; Mon, 25 Apr
 2022 15:59:52 +0000
Received: from MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::6820:41b6:a038:7a3b]) by MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::6820:41b6:a038:7a3b%6]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 15:59:52 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     ivecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v4] ice: Fix race during aux device (un)plugging
Thread-Topic: [PATCH net v4] ice: Fix race during aux device (un)plugging
Thread-Index: AQHYVvvS7+rYQkRlfEGFSsJ/CUUOEa0AyVKw
Date:   Mon, 25 Apr 2022 15:58:55 +0000
Message-ID: <MW5PR11MB5811DF21387703272C67E9B6DDF89@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20220423102021.4056946-1-ivecera@redhat.com>
In-Reply-To: <20220423102021.4056946-1-ivecera@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.401.20
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 760af7dd-718f-406d-43e3-08da26d4a259
x-ms-traffictypediagnostic: CY4PR11MB0037:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <CY4PR11MB0037A2CA59F1CA4FE4A0D1FBDDF89@CY4PR11MB0037.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QndfgScmMOaPwkdBgnia8lJyIC+Tyq7OlQ9YFiP5sJb0PpgNuMxjZUyBSVodUiizdQVfUaLeMeLWi4lipgrj3+kPL7l2rOcE5qAkdCCUOg0tmGVjtZ1EonjCyna+A78jwMSzHbL4ORh4slgg7cqbb8mmDD1OvagsVXxSf/AbFnEPqos+kEM8tPu7gbJVpaMpKEeau92NdyBn5U8w5SVNnnRcnhI6CtScExq+XiX1guGAPfHrjvc3p5X2EtZkb0HRMhL41Hct3jTfyhCwyVaAuNqB4+DmNria+G9L0aVBhHpJEiknneKEMUg6Jms/2F54DJ5O+GWuESfgh8ooYLMPLSFqB4ep+xJsZTuKhUhlGvNXawtmw6HoPvNbkkC2F70iAmP2xkC+D/GPlY8SX9nCxfZhFgtpYYNJbXyNBJ2P6mY6BSsqgltmSG+yUmNA3i3XJE9PAqMFxiJtYzdme4ZF1zonFnD+ZoNBznjr62gyrlZXcHHj5lapMtuZlUZA8yO/c27i0zyGjVpu3/FN/FoqafdTtjITJXDXSYL0rfJzz39uZLv6spyMRqAV2P2ts1w7SXruFBfUKTRt3XJAYyDqdDpmpyo3gQFGxABV8oe46UHc5uEGbTBpmxFyt3gMQSqfacRnrwZmQ0g+xQ5/UlHYMGNccgPacWhXWtoWg07ei46rM8Yc55vUUJOFL9Xu3rMIt3CIlMG7xRu4+SnPwWy+tA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5811.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66446008)(66946007)(66556008)(5660300002)(64756008)(110136005)(9686003)(76116006)(2906002)(7416002)(186003)(8936002)(52536014)(8676002)(508600001)(316002)(83380400001)(26005)(33656002)(54906003)(82960400001)(6506007)(4326008)(7696005)(122000001)(53546011)(71200400001)(86362001)(55016003)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KOgFc0W7mZD1i6tsp+3BhN8Af1ue9BJv155u/CHLfLV1/7j5LjiIJuwU57rJ?=
 =?us-ascii?Q?qc+YxALh6tmk65vlSNJGbaQsyCydtofTSUnWZaRY5acBnmJwdB2Gh63lv/yQ?=
 =?us-ascii?Q?DIPhrlKEapLJ36v9SSSfMoxu2IuD7/dK/nQ7p+V4yQlc5t2g28siN0fxsInZ?=
 =?us-ascii?Q?SScCIUzkm1V12SwezzFQG5bZb7+1aWPV9R6EYFytsL9FIazApS/WiyCLPT8+?=
 =?us-ascii?Q?sE3CzgfC/9hkA4Jd1DRRviSRaEHvKxVZT4kB5LBjZw6tfi11DpgxJfQVHDDR?=
 =?us-ascii?Q?2vqjcMKEoI1Em69sI4yXrCRlFjXl8Rb9jfHwl2E3GPDW/7rr4wjWPut+Rbbt?=
 =?us-ascii?Q?3qdO2NgQrTKId+XHZww5a/O4IXBQ1ALDLK1/mZ+nwSOvVPt/MYmIdLI8EUWw?=
 =?us-ascii?Q?kqyKZi59dijNm5xCcxV4sFMPDSdasDVJpOcjZ1hp2+ooU5dOoWx1kancGLk9?=
 =?us-ascii?Q?KSuhNocPrwuWoE3RH/PXiJNGvP854awll/PMZQnQYXh5c/VOH6IOr0j6SwR6?=
 =?us-ascii?Q?/hikqIMi5J0q56D+sOravnDyMAz0icI9obSdOqLj0R64/mCEEyqIpBb8xJhA?=
 =?us-ascii?Q?Daf803RYLXVosTMyFnC4/FbBpEWCKNBDLqODNXEFklhDYS2WqsbHO2hkd/BS?=
 =?us-ascii?Q?RaNbra1hNisUk9/z+3b/TzDmWZDCh++kG8qf6b1y9ydCm+yz55ICNCW+Nr8n?=
 =?us-ascii?Q?Iw0Gds8qufMv71L2IiJP+Cj/+Kzt2/S1fVNruPtgUT25qbsl0i+aRTGJu3xO?=
 =?us-ascii?Q?xnLpnYV0uRVheKiYerNX7naQGXLsPu8ssD0zWx53mOmRF83HU1cTvdkGS37T?=
 =?us-ascii?Q?vD/cPfasQygOkegi2lGKssGub9mTPJwt5T9DFRQwTm3C4vFH0rheK4RAy5Bp?=
 =?us-ascii?Q?CBI+iDBIz6yM7kwhHWs6/JEI4ngOpqqGdeJwurdLasmJngiHGJR2O3CuViwa?=
 =?us-ascii?Q?xX7gwIQKhZO95x/AWpJaqgdwIMr96UZvAKU2J+zD927240LSUliRjOM3ZVYz?=
 =?us-ascii?Q?dMGGTFiMopTo2R3SwsxNoGLBcj+ZOXluQGWQDQq5/syW+b0eQd7cOPocukMi?=
 =?us-ascii?Q?heADE0Hk9die9VHmZLpppAuydva4SDdgeNcuE1sEkVv5cj9stNe9HXTeL18i?=
 =?us-ascii?Q?giTrlHD31/RN7OMgQEAQYt/kq1/8Or8qzpzrkCtc0ORFIJRQanRRbgNyqc9j?=
 =?us-ascii?Q?QpM026t7MkTG2iEVbLfO0r4i968wXqbREG5nxYgoYIn58PX8Rf3qFjxAt9Yn?=
 =?us-ascii?Q?i7qhl78BXTqF5rz0mogGNDHCJU8RxkhNuHaAr8eVU2/RnhI9MZ4aZPnamt6Y?=
 =?us-ascii?Q?afh7S/lbkM4/YHTxiRbKF5rC8QpTgP0FVOigtN6UTYeUzvQPnLM8QOkpMQHz?=
 =?us-ascii?Q?dIvx44pZbBGXRoe78bNZ5Um+vO58n0KKx6HT2JpLhuehjfW6JovvjtIbly0M?=
 =?us-ascii?Q?0OYvYbE40XPnlkj5l3Iql0xS/JeFZWSc7s/h/HBwdNiyPAqLxobfu/n/Yyaz?=
 =?us-ascii?Q?VF1CiWWOQILxjIIwVpS48hb/dVxjSXiGPq0VNCLSbP+ZoxGpUvOQBnMnvP0/?=
 =?us-ascii?Q?uq0pJzcHrFoehb8D9tjz64zltjhGFvn3tA8MUoBUn3DCZM7tQiimR4IrlC5r?=
 =?us-ascii?Q?vykBNrHkwbGdwkPWOBDMC7dGeGX/ux4LB5zkPpE4BwXL2bQLb+OtwOBDAhpL?=
 =?us-ascii?Q?I942+HIF+oPDO62ZxKJawhzlAj15RPqoF1Ji8D2dKYUBVpLzFz9TbgXHn2Js?=
 =?us-ascii?Q?ALwk8nY6/hYVDx1joiKiznFROzV37uE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5811.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 760af7dd-718f-406d-43e3-08da26d4a259
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2022 15:58:55.2821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NEOH3s47cslzKrY6Je14crAm2ifkn0pEZ01R794GblICqPDjpfAo4S06mpqPMwg3SOUdK9G0X3580OoC7PDr1mPlq4E1T6xc4EbRVSSpblE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB0037
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Ivan Vecera <ivecera@redhat.com>
> Sent: Saturday, April 23, 2022 3:20 AM
> To: netdev@vger.kernel.org
> Cc: poros <poros@redhat.com>; mschmidt <mschmidt@redhat.com>; Leon
> Romanovsky <leonro@nvidia.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> Saleem, Shiraz <shiraz.saleem@intel.com>; Ertman, David M
> <david.m.ertman@intel.com>; moderated list:INTEL ETHERNET DRIVERS
> <intel-wired-lan@lists.osuosl.org>; open list <linux-kernel@vger.kernel.o=
rg>
> Subject: [PATCH net v4] ice: Fix race during aux device (un)plugging
>=20
> Function ice_plug_aux_dev() assigns pf->adev field too early prior
> aux device initialization and on other side ice_unplug_aux_dev()
> starts aux device deinit and at the end assigns NULL to pf->adev.
> This is wrong because pf->adev should always be non-NULL only when
> aux device is fully initialized and ready. This wrong order causes
> a crash when ice_send_event_to_aux() call occurs because that function
> depends on non-NULL value of pf->adev and does not assume that
> aux device is half-initialized or half-destroyed.
> After order correction the race window is tiny but it is still there,
> as Leon mentioned and manipulation with pf->adev needs to be protected
> by mutex.
>=20
> Fix (un-)plugging functions so pf->adev field is set after aux device
> init and prior aux device destroy and protect pf->adev assignment by
> new mutex. This mutex is also held during ice_send_event_to_aux()
> call to ensure that aux device is valid during that call.
> Note that device lock used ice_send_event_to_aux() needs to be kept
> to avoid race with aux drv unload.
>=20
> Reproducer:
> cycle=3D1
> while :;do
>         echo "#### Cycle: $cycle"
>=20
>         ip link set ens7f0 mtu 9000
>         ip link add bond0 type bond mode 1 miimon 100
>         ip link set bond0 up
>         ifenslave bond0 ens7f0
>         ip link set bond0 mtu 9000
>         ethtool -L ens7f0 combined 1
>         ip link del bond0
>         ip link set ens7f0 mtu 1500
>         sleep 1
>=20
>         let cycle++
> done
>=20
> In short when the device is added/removed to/from bond the aux device
> is unplugged/plugged. When MTU of the device is changed an event is
> sent to aux device asynchronously. This can race with (un)plugging
> operation and because pf->adev is set too early (plug) or too late
> (unplug) the function ice_send_event_to_aux() can touch uninitialized
> or destroyed fields. In the case of crash below pf->adev->dev.mutex.

--SNIP--

> Fixes: f9f5301e7e2d ("ice: Register auxiliary device to provide RDMA")
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h      |  1 +
>  drivers/net/ethernet/intel/ice/ice_idc.c  | 25 +++++++++++++++--------
>  drivers/net/ethernet/intel/ice/ice_main.c |  2 ++
>  3 files changed, 20 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice.h
> b/drivers/net/ethernet/intel/ice/ice.h
> index 8ed3c9ab7ff7..a895e3a8e988 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -540,6 +540,7 @@ struct ice_pf {
>  	struct mutex avail_q_mutex;	/* protects access to avail_[rx|tx]qs
> */
>  	struct mutex sw_mutex;		/* lock for protecting VSI alloc
> flow */
>  	struct mutex tc_mutex;		/* lock to protect TC changes
> */
> +	struct mutex adev_mutex;	/* lock to protect aux device access
> */
>  	u32 msg_enable;
>  	struct ice_ptp ptp;
>  	struct tty_driver *ice_gnss_tty_driver;
> diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c
> b/drivers/net/ethernet/intel/ice/ice_idc.c
> index 25a436d342c2..3e3b2ed4cd5d 100644
> --- a/drivers/net/ethernet/intel/ice/ice_idc.c
> +++ b/drivers/net/ethernet/intel/ice/ice_idc.c
> @@ -37,14 +37,17 @@ void ice_send_event_to_aux(struct ice_pf *pf, struct
> iidc_event *event)
>  	if (WARN_ON_ONCE(!in_task()))
>  		return;
>=20
> +	mutex_lock(&pf->adev_mutex);
>  	if (!pf->adev)
> -		return;
> +		goto finish;
>=20
>  	device_lock(&pf->adev->dev);
>  	iadrv =3D ice_get_auxiliary_drv(pf);
>  	if (iadrv && iadrv->event_handler)
>  		iadrv->event_handler(pf, event);
>  	device_unlock(&pf->adev->dev);
> +finish:
> +	mutex_unlock(&pf->adev_mutex);
>  }
>=20
>  /**
> @@ -290,7 +293,6 @@ int ice_plug_aux_dev(struct ice_pf *pf)
>  		return -ENOMEM;
>=20
>  	adev =3D &iadev->adev;
> -	pf->adev =3D adev;
>  	iadev->pf =3D pf;
>=20
>  	adev->id =3D pf->aux_idx;
> @@ -300,18 +302,20 @@ int ice_plug_aux_dev(struct ice_pf *pf)
>=20
>  	ret =3D auxiliary_device_init(adev);
>  	if (ret) {
> -		pf->adev =3D NULL;
>  		kfree(iadev);
>  		return ret;
>  	}
>=20
>  	ret =3D auxiliary_device_add(adev);
>  	if (ret) {
> -		pf->adev =3D NULL;
>  		auxiliary_device_uninit(adev);
>  		return ret;
>  	}
>=20
> +	mutex_lock(&pf->adev_mutex);
> +	pf->adev =3D adev;
> +	mutex_unlock(&pf->adev_mutex);
> +
>  	return 0;
>  }
>=20
> @@ -320,12 +324,17 @@ int ice_plug_aux_dev(struct ice_pf *pf)
>   */
>  void ice_unplug_aux_dev(struct ice_pf *pf)
>  {
> -	if (!pf->adev)
> -		return;
> +	struct auxiliary_device *adev;
>=20
> -	auxiliary_device_delete(pf->adev);
> -	auxiliary_device_uninit(pf->adev);
> +	mutex_lock(&pf->adev_mutex);
> +	adev =3D pf->adev;
>  	pf->adev =3D NULL;
> +	mutex_unlock(&pf->adev_mutex);
> +
> +	if (adev) {
> +		auxiliary_device_delete(adev);
> +		auxiliary_device_uninit(adev);
> +	}
>  }
>=20
>  /**
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
> b/drivers/net/ethernet/intel/ice/ice_main.c
> index 5b1198859da7..2cbbf7abefc4 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -3769,6 +3769,7 @@ u16 ice_get_avail_rxq_count(struct ice_pf *pf)
>  static void ice_deinit_pf(struct ice_pf *pf)
>  {
>  	ice_service_task_stop(pf);
> +	mutex_destroy(&pf->adev_mutex);
>  	mutex_destroy(&pf->sw_mutex);
>  	mutex_destroy(&pf->tc_mutex);
>  	mutex_destroy(&pf->avail_q_mutex);
> @@ -3847,6 +3848,7 @@ static int ice_init_pf(struct ice_pf *pf)
>=20
>  	mutex_init(&pf->sw_mutex);
>  	mutex_init(&pf->tc_mutex);
> +	mutex_init(&pf->adev_mutex);
>=20
>  	INIT_HLIST_HEAD(&pf->aq_wait_list);
>  	spin_lock_init(&pf->aq_wait_lock);
> --
> 2.35.1

Reviewed-by: Dave Ertman <david.m.ertman@intel.com>
