Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7642F4F403E
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385817AbiDEUFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447892AbiDEPrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 11:47:16 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173DCF8EF3
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 07:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649168689; x=1680704689;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RAgjp4TW5v+4Jpv1YE6mfnlHV1OlEWuvxMIE0oRhirs=;
  b=UcSf3yc8U3GH7qeWQ/xbueVrqaWhpP6WoFg5HxgF3unY0GkuD944kPZI
   QKLdV7HMoAuw3nba44LUXGOqgmNgNmJ80CGtxSTtkIYbVigKg+MOJAxrf
   n2CETCR4Yz6+cNoeTycCvXAMPLjdkb/EtNdXj4U8tFxLIftbPXRnBSqmM
   AWYoNs+gmDVkJxxuJc32BOOwL1wExgCwssEfEsJwMIzHNDYvRELJdXRir
   7H4RAXFAvXTLqC8gE7oXlWyZc/lYzo5bt3FvhyRf3PiCVQaBc8fK8hxrS
   GDYqJn3MTUYx+EFESMbpizoFJzKvL5o2ILLtMED+DvymPPN3aAX7C6mqJ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="260455835"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="260455835"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 07:24:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="524013930"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 05 Apr 2022 07:24:40 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 5 Apr 2022 07:24:39 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 5 Apr 2022 07:24:39 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 5 Apr 2022 07:24:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2YNTP7mds2KuUtUCCkyy1gUDzBq6Wxxzfy8hTkmDkpV0yGypM5e71J3gclMrCbG3NlLxm0vULWYNfUzbi8ePByNaZ0TvKYCCEswZGjiBVnxW1DQw99pvezQPdUBUlWLUGxABbZfguFWqoTYLq9+uNLSk9Rd04BKUxNmTCOYQY9prSt210Xpm7jc4rqjmmrCML7z8xcnvxuA/tBg8dSjK3MPnrL8vBamaJhhxwN1midl7vE04w0lEWjjz00mr4W3yAUL4jLaJgZI6f6FdbMAsLckztgBV/0aZfYt0kjJezDN5bDmsfiR9kdTk2YVbetKY5P5vtFFKCHUHZaDC2eoPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2AMEoUnScVdQu4GHR/j/pc39bRwAhfHkCBkF9NEbOZw=;
 b=QJOpgI0bwA7JP4l+YjjYt/k8mBN385Ztinss65b27KLVfw32r5xgZBLYLzqsP+jKBJvrIMtPrHX0EbrKtUy/umaI5Hwmouhh0yF8lqhHrjTY5eIjjXAtrRCdHIXIFTiD++cdnCYjmLXVntfUBZ3DE5Jssw1ZtgiJFiWT9kcpJZoiNhNd9x5ANtnqr4ov68q51jZttHpZ/5M5fHb9vkipXT+16GhF1g3UbGZkUa9/1gTb3zBCEtjxxaRHBGicdQjftccbNEdV8sMf/0rjRO2LwHvTklS50juRj65+SiYXJPzkUAMG78h59V8+rv07NG6uq0VyltwoDgq5KEc95lVAAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 SN6PR11MB3277.namprd11.prod.outlook.com (2603:10b6:805:c4::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Tue, 5 Apr 2022 14:24:34 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::c445:1c7b:8914:7968]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::c445:1c7b:8914:7968%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 14:24:33 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Swiatkowski, Michal" <michal.swiatkowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-net] ice: allow creating VFs for
 !CONFIG_NET_SWITCHDEV
Thread-Topic: [Intel-wired-lan] [PATCH intel-net] ice: allow creating VFs for
 !CONFIG_NET_SWITCHDEV
Thread-Index: AQHYRcfHnargUFdnFEWosdK6xUqDS6zhZhNw
Date:   Tue, 5 Apr 2022 14:24:33 +0000
Message-ID: <DM8PR11MB562144F46E4BFDFEF06A7B57ABE49@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20220401125438.292649-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20220401125438.292649-1-maciej.fijalkowski@intel.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 931aaf7d-a1d1-411c-9ec9-08da17100114
x-ms-traffictypediagnostic: SN6PR11MB3277:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <SN6PR11MB3277C6B5CDD4DA38AEFC8F5AABE49@SN6PR11MB3277.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QZiPPAIR9/jBs3f/gRlzSvCnItuTsgyJO6J97vUTvIUdWSe5XGLrj182TXtA72L/gOj3fOwY2w/xeHJWK8hqAWBlZlfxc0llyboJ4V7Cwc8GxqOyqOoiEY263zwevzTjDT8DN7/wqbL2sFi4J6bTRtXW1VePEtEwYtPOoUYkI1dBh9OL3zzd1cuKdf/0Xo16S4Xoh1VqndNljupGaFPTASTZtlXqSCzFrRHcJL7xRz+qd+E0fn3cwatP9u6wiBKMTnVCjWlHdCNj+MjKeSb5G9hQXZXl7W/3XwfKyyprBbShdO0GgYodSjS4YT18uu6ZTicTsVXblavzi3Z2Z3MhNwTTpVlYCdSgqZLsraOSrc+aSEmPbGivog3662hUkIfWlgrA/bBe9nNnpew9ax2XUQ/gzT7iV4boRF/EpYTRoQZ7ohM2olr6EgPCH/MZJfdp9ZDRODg1YwuVtUEdH2jHz/KQxWaLM2Fyb9XO9IgWfdgm/ZmwtjB56BGbfpKMeiw5SIV3C8BsRTmJ6XTMZIZNXrtz0KaTFrXutVNc/mcJDGYNEJLOXxhlr5eXufJHb7yqNIQjreI0NLjOlUxd5uKmFKyrRB7WubnGoj8tiXl8nF+N2S8dgiWZdngQ6FpATmD+5lMvRZHIOMAE42Ir34V68GPV2JnDWq+GcfTDmd8t4+SnARGamF5j4uu4UVOpewyPK5j6b9L0gkDi289jsyMnKg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(76116006)(4326008)(86362001)(64756008)(9686003)(66446008)(38100700002)(38070700005)(71200400001)(66556008)(53546011)(2906002)(5660300002)(52536014)(33656002)(8936002)(8676002)(66476007)(122000001)(7696005)(508600001)(55016003)(83380400001)(54906003)(110136005)(6506007)(316002)(186003)(82960400001)(107886003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cJr6hi3z1RQr1ByaggDxtsgLpZ0SQ+v33rooCp0UbN2z8wwyYVL0/zB5YTwW?=
 =?us-ascii?Q?3Zs/Sp0ErQoGIQ04lcm2PTA1B0wAsSuFjccSlLsoik59EYpvofUPLsMJb5tI?=
 =?us-ascii?Q?QtwihqCaiRqNhUdYCelJYqDrBceu1iJZMpXxsYFJK1NXREpx6PvT4sSLevTZ?=
 =?us-ascii?Q?ZLDxQM55jDcke5qA5bSAfe4C63e7ayMywfK3rzAzrM9ivSF7xCFb/kpGMk7c?=
 =?us-ascii?Q?uHvH8+tAbsbbn8nMUYJH3HABfqBQ8bH066dodrxxDQlGx0/WK5AMmANSnphH?=
 =?us-ascii?Q?oWDDUXPDPGET/HXG/qKkLK+/ot+VGxYPrp1LzrP9Bh3X3o4Gc7nmm7gJmCFZ?=
 =?us-ascii?Q?EcE6PyU0ZHu+2r4A7QWr0CX6kSaX60PaFwhVachh3TBod7niI2exgEopLwZa?=
 =?us-ascii?Q?Fo2/DfaLOyITwX7+dpvK0SX62Sicyd/sdewvOFN7jefpYsrGrE7dpUQxs2bO?=
 =?us-ascii?Q?RoNQZpFIUC/0QenS340Vi1RPzi2wXZC8QXW4S/zwvAgu7ZDwDZrQwGvndLP3?=
 =?us-ascii?Q?+9jCHj+8SCKf62kK1ScebQxwRpREEr5aWx7+FA9kPiXVrZrcgW7qv/qeCofi?=
 =?us-ascii?Q?cgE6bPvvTU1wpsG4vj9MHnQh45UrgA7qtljkIpVQxQsneDcKaXdQVtKfWsme?=
 =?us-ascii?Q?dO7B2xuyWHZtv7+ng5nb1Xu7MjR9zlBMuqvMSHgJcfniOC7mTJsD8vZsOnbF?=
 =?us-ascii?Q?6BneW943QXNAfGuhjgQX22I1o24ojCVJNq+6wS/heDB2wPMk1oxNwTd+P/lw?=
 =?us-ascii?Q?gwMUmh2cNBkLFYKG0tnvUa/SrBrdvrODd/RxY1FnkxavALcre7Y+kA5ZmVGl?=
 =?us-ascii?Q?I5P5QEBMDQvujsV91B4v3tYDnqtlkoCconbYxinMIwASEUlf57xPg/xN36y8?=
 =?us-ascii?Q?wCGL8gG/Iba9BQ38jA1S6R6xdxUGv39dqodCi6M50RAtbfrcoZA1SOtpegpQ?=
 =?us-ascii?Q?zwl1HsBP0dwxPxEh8jYUJ2mSG48ZELqyjz51QFQnqPhaFe+9kfifaEIIdVVw?=
 =?us-ascii?Q?k9A+/ICYNb5nEUXhCcL7etduZAxfr4rrCVDdEod9yLUpiynqS3kQVwjpFZ+e?=
 =?us-ascii?Q?0o1DaFVq4k9yq31DXmD41nYFg5aZzEyQCAHqSNytcHJNgW01HPuQ4JBn1FAj?=
 =?us-ascii?Q?ujGb9tpDDprRXmF/Dqdi1F3sOhQWYBNev8LNS18jf7eofRQHCzTsfShVFliv?=
 =?us-ascii?Q?r+/VByaDN8rKZlXP47o98WOw3xwntOpuZDHMtuTvy77AoL6orsvuS9sm/nqG?=
 =?us-ascii?Q?ktC9VE2Fq9cFugEyz9Tkl3I+2vpMIbibLeq5DD3fad/VZNjQkY3zu0TB1uO6?=
 =?us-ascii?Q?uYiKC3CdYgUQaZ6GA1rEq0U07b00YfXUBEdDPdOr4x0fyJIS4d/Ag8Ci7Q9m?=
 =?us-ascii?Q?8FUIDgecJ+YhL1CQNhav8mV2zsCxiWRJg5b36I3B/FCujg+kperjC2D7/BHO?=
 =?us-ascii?Q?ny/flEeF+rNVhU4pXDUkEr7XP/HiQiFhRrTDbigGHvQ5ByaURsoMT/vhgc8w?=
 =?us-ascii?Q?pnHWkxo32NA/BByEVJ00ALdRTRCypQlz551vv+jzl/cmLEW0bla5LJrLtiNd?=
 =?us-ascii?Q?GEBeVk07tKi85ClAGctuma08TFi5V/wtqVqHdoqf26NMzuQMTgbNw9CYTEuL?=
 =?us-ascii?Q?RatXnvNAOORzRLidehC9+lWSOfwGfKaxXnBNiIbk9XIBA2ylMXsa4eI3/WTb?=
 =?us-ascii?Q?LPWim2Q+U9k2DqWDRGFQW6jUgO4upYLFe8wzeqbJxzsZPLbDSukC7moIBHTe?=
 =?us-ascii?Q?8K478D+DUCJUg/SdtsYblfr/P6hCHGU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 931aaf7d-a1d1-411c-9ec9-08da17100114
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 14:24:33.0921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dONiGTdWoqkNgy9qO5sCT41Z6MwB1p6+LMe7TOWmqjpjCci2KqP2sWyLVzkMqsksn5HTan+gqkRJPWuLiwaKhjvvR5k6NdO0qJFobGtELlo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3277
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Maciej Fijalkowski
> Sent: Friday, April 1, 2022 2:55 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Swiatkowski, Michal <michal.swiatkowski@intel.com>;
> netdev@vger.kernel.org; kuba@kernel.org; davem@davemloft.net;
> Karlsson, Magnus <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH intel-net] ice: allow creating VFs for
> !CONFIG_NET_SWITCHDEV
>=20
> Currently for !CONFIG_NET_SWITCHDEV kernel builds it is not possible to
> create VFs properly as call to ice_eswitch_configure() returns -EOPNOTSUP=
P
> for us. This is because CONFIG_ICE_SWITCHDEV depends on
> CONFIG_NET_SWITCHDEV.
>=20
> Change the ice_eswitch_configure() implementation for
> !CONFIG_ICE_SWITCHDEV to return 0 instead -EOPNOTSUPP and let
> ice_ena_vfs() finish its work properly.
>=20
> CC: Grzegorz Nitka <grzegorz.nitka@intel.com>
> Fixes: 1a1c40df2e80 ("ice: set and release switchdev environment")
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_eswitch.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.h
> b/drivers/net/ethernet/intel/ice/ice_eswitch.h
> index bd58d9d2e565..6a413331572b 100644
> --- a/drivers/net/ethernet/intel/ice/ice_eswitch.h
> +++ b/drivers/net/ethernet/intel/ice/ice_eswitch.h

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
