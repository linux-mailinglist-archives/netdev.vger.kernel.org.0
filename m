Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183AE50C385
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbiDVWdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233933AbiDVWc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:32:58 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D301E68F9;
        Fri, 22 Apr 2022 14:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650662780; x=1682198780;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JOLAq6ZWzqN3c0vDzvIoJfqqgH9zgWkpMjBadDbvW/4=;
  b=nBtHopdGfQtCWZJ5WT97o/sQJbxhari4scfG2/WB4tyj7/uw0ei5oLuf
   Nz7ngTy9Lkc5J93/ZOqUS45P0gof9VDLRuiopAkMGlsCHz5RJ4/qZWfzI
   8Zlo+JcP6LZx39NGyYHfkyCJw1ePLf8DzpE8dRd5beioQAtOB/DVL2CVh
   GYrz3t/RjcN2wiDqIvI7bZ8CJeKvTzz9Z5GiUMkoH0BsA1Gm6SRbfFyrC
   8A7WNt20n0rL+qbIONO09iGv/hgPrOtXR9Cr4DcU04M3xzguKLn1HxCaQ
   a7mb+NOGzOAK/A5koxeNNcjjYFSKJu4STmxyFB8p1utjWfixmdGdfCeGD
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="245355461"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="245355461"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 13:55:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="578093161"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga008.jf.intel.com with ESMTP; 22 Apr 2022 13:55:18 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 22 Apr 2022 13:55:18 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 22 Apr 2022 13:55:17 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 22 Apr 2022 13:55:17 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 22 Apr 2022 13:55:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5Hi4pkLibxEgIOBeHU0zLtTzbxNT05mS8pONDEPI4rM5EvoFHEE1km1tYHZdwggL2QwwnQzCpuPuok3j4soM8IuQ7BfDMj4NBsD4bvIR0JigQAs/ofOxGSzWv/CE2PlbOJBqYagSuLCu/OlAvUtQWJzfYEip9o6DtSotgDxnKxbZgQ54EQjMgzdvh4LymkWfpAdcGKDgeHGAo0FytT9+32PIg273wu3hyhT3O6cmXGdI4gAPPHiGOBBXxqyq3waWHmwsjKtoSUwXWbVwi5S8aDPlRN0JafrtFt0O7aHpZfekgBjIUcxL51oEiACByordAjVqFufRx/pb14sLPrftg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fy2RUcTeNSSBkRQoCChK2mgFgeGO8GvJaP0eMbOkois=;
 b=jZBOpF8UKhqxMtrGKW+zz6de5Xp7Wy05g1zq1cOPgl1eb3xjlaGenCpvSrsHnkH94E+LBcysO6r89Ccc+vMQiwy7fN7sonVykQ+R1OGvdfjVeLCPpIFwMd0gHbGtXz/nfIwF2EYa8HDcqGFPrsW6/OpfcTHsdJuxlqkPQcX/HNXwwTStzzrgYRTnsgRzHx/sGBCYQf8Fpnvz1p62+cpQiTwpzVBjkDTfzf7SOcyIco1mVkMx2uTuo8+lWZGuoeuvUyhkrZtn7R2N3uSB2vvRENFfJ5wwlt2zOL3xIw63UfOCNaMAmovahBQy9eBhRw/uPVfkA1jMRazuwzOsRatt3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18)
 by BN7PR11MB2836.namprd11.prod.outlook.com (2603:10b6:406:ad::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 20:55:10 +0000
Received: from MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::6820:41b6:a038:7a3b]) by MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::6820:41b6:a038:7a3b%6]) with mapi id 15.20.5186.013; Fri, 22 Apr 2022
 20:55:10 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     ivecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v3] ice: Fix race during aux device (un)plugging
Thread-Topic: [PATCH net v3] ice: Fix race during aux device (un)plugging
Thread-Index: AQHYVUZcHI6VX+DIGkiO7KkonUY3tKz8NYDQgAA1qXA=
Date:   Fri, 22 Apr 2022 20:55:10 +0000
Message-ID: <MW5PR11MB58110D02BF761C889B29CBC7DDF79@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20220421060906.1902576-1-ivecera@redhat.com>
 <MW5PR11MB581100DBD307763A92012BEADDF79@MW5PR11MB5811.namprd11.prod.outlook.com>
In-Reply-To: <MW5PR11MB581100DBD307763A92012BEADDF79@MW5PR11MB5811.namprd11.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: 2939baf2-885f-4d00-4408-08da24a263b5
x-ms-traffictypediagnostic: BN7PR11MB2836:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN7PR11MB2836AEBCC7515C52545C45C6DDF79@BN7PR11MB2836.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j3cd14UJBVK9+f4DlxsCH5CxKVbawIrnBH1ZYNlzHUHXERvPTRBssLoRUowYvQvP98gbaq+vwB3YnSKIFOl2OruTL1dJnxNkNDBKsAfg7IddeuxomkIcufw7FXegxaE4iuvaL//A6+2bcYYLO3h1o3nRnfJPniLP4LgmUZDR6Ry+cXejNjIEaxm1NSumDraSXvq8y6xhHbsphSU+CrWV0//R04i0sodeHfbtxVgUOKQM7083gbz2ux9b8nusQ0/iOG5UUc4gK1ehzuidP3ECdTLdsDsyaBicNVvBWSv+SBO1Bkg7+X39kHdHzxSqFeyFNhqUVnUgMAAiPdd0qI5P0ZgjxhwILJaxIexhunN6zJj2SM0msy1DQm4m46Es+kCw1BxBm91yEclcZnebXU/24+aVW1nfeX600uCFMNXZ4jksuy74iacgpObaeiurNH2/B0BLT4ZrZHF9yoXjSKsiZhDKTX4oUXNqGQ586gQLC0SLYMRvQsuWUGphdbmriZ+PxHGxk8LOfhglY3sWuHZelvL/eK9z/Y9x9NUw/xn7zQ9DyLz2WOlUv6Zpb5JbjbxdrBxNOZne4CfbBSSxi0vVRAeSoIcATSPexyMvLeX0iqzlkdO2sVhZ3j/+DtmVyimGxOJHHsL0Wwkw1EvZiiJchUnpaZPRrJ3d/tdv21NXQ71OiCo7u/Tz6D2eCp+egZgwj/O0m4zMjG6SjIeWZukAjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5811.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(8936002)(53546011)(2940100002)(55016003)(9686003)(33656002)(38100700002)(5660300002)(7416002)(2906002)(82960400001)(52536014)(38070700005)(508600001)(66476007)(186003)(66946007)(7696005)(122000001)(26005)(66556008)(83380400001)(86362001)(66446008)(8676002)(76116006)(110136005)(54906003)(316002)(71200400001)(4326008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?f9UTItFN+UQj3bFztq4AxZUURsAUbNnFgSGJFcxZ+A0uliEI0j4WwRC2+6k5?=
 =?us-ascii?Q?1ihYZY/mTyaoOR1dyQ9PnbUf3skI7G3/VpODuYInIZtNx8zOXFofStducS2+?=
 =?us-ascii?Q?vuqi6VJwTvBZWSCBB3nwlpFt1jmu2gJqtCxmY3051hkTpnefxHUy/LEKviSu?=
 =?us-ascii?Q?2R4+WzgqExP+uxYSFLEmqqxFDf4sv08wuC+++8wdSzlK5n2jUd6CEwgN25Xs?=
 =?us-ascii?Q?0wy1nN5i843T5rNv+nvXP+0a+sMqgnQjKO4jM5EFw2G/mnnzVAr7IDGYGxUj?=
 =?us-ascii?Q?mu/sME2YPlJGsAvbOU1oQgSMBLqH2p6NrJx5oKIf4bl5XUc7C5HlH8rOcNu4?=
 =?us-ascii?Q?1LJteDFug/lgCsZKz8WezEcEX/bOL6C8qBUI6t9jIS1KAKEXyVtgnhLkYdGO?=
 =?us-ascii?Q?95tzkzzrzeVyU4P2ZfN4QSpCUZiZzF6TIzBCinYPMkWsiRerVWVHhvkrZIxs?=
 =?us-ascii?Q?n43AgTw83Bms6lZeyPUAURfzYWLkwSMMUGdzHWLRfAM95wZ98NQnH2Dlil9W?=
 =?us-ascii?Q?wsD6gF3dJI9jlAEjI1Gt2nx9nX37hFsrc7l9dbB1YzCaa05apyfCAmsJmKt0?=
 =?us-ascii?Q?OclzN1lmujPDKJOKuvQg89D4SyefEsQQlyjvmywpK0gzJqRqAAabz7E/JVfk?=
 =?us-ascii?Q?S5tQN5YkSXLeQQmxjuB2VM36ErNpFfaMnZZEJK4hAS59goA2E5nStC9uIj17?=
 =?us-ascii?Q?OAULPDaFSg2Ld6IMZF6eJdWi8T2ajbfsPOpcnj3YK+CZPYRmQmdWTsezr2P5?=
 =?us-ascii?Q?OyFBCoSHnrQmLdFegz+XrtmY/WsLep4TMcC5ouCV7bzftHx/GYLk3p+iyzqS?=
 =?us-ascii?Q?K0KApxmQ0g+bdN0JEw2HoZcs6O6sz+LPN1tjqVeyEIOfacEqKFWm7StluvFY?=
 =?us-ascii?Q?rA6z1bHS6oMJEgXpJe34LuhIZKU4lCmkGDbKO6zMKYpxfp6RkX/xazLZzXyj?=
 =?us-ascii?Q?pldPlAGrBVHO6Op/LxzBuvi16owc5ZEoSMMMCMvxmpE3lTNMD+6fI8iu7wkQ?=
 =?us-ascii?Q?b+XPHI4v7YJtfpQXqEF3NtNHewUqBVoOPfhxo/FOH2/lLcjoIDhRfkwpzd8+?=
 =?us-ascii?Q?oI+PnbbIO+SUZmgeBx7nDK5aqyTl44qlYRuyCogPdEwG9ldTvSL+S8/NnZu9?=
 =?us-ascii?Q?vDdx6lNY7kD5rh6P2gsl0i/Ufq/V9BZ7eHjagUpUETitTKipPjrIs9bl5OW+?=
 =?us-ascii?Q?Ohplj4mNZVFU37zWIh5gwP+GS3ePEouPipIi2DeFdgMM2ePyz5j/DkNS7dHV?=
 =?us-ascii?Q?++GNiR5Pnkfzo9jhrl55jBL7LMmq2PQ6XfPgqTYlGDEn2nOJEMXkXtb6TcBr?=
 =?us-ascii?Q?A6UrnuVGi3N17de4FoSW1BX4r+YFrQ7vkq6AvmIycgtRbUc18S5btoIfAom9?=
 =?us-ascii?Q?318uCuKY/IXuQ8v8oRXZaSCACkjtHH1ks8lHDeFLegUXUW1hC3WaapILOgRT?=
 =?us-ascii?Q?EQ6P9BZ0J9fHGUJI8clv99r2k8B2NZbwe9H5eGlQpiI/QnuFnpaPPtxuuYRq?=
 =?us-ascii?Q?gGANW0iVXCOTIajiaFZfDRxtRKK7FicTfSRPvIQmxC1UE/7UcVOLXXFeHtXN?=
 =?us-ascii?Q?q9qU46wuw1WFHIvnnHJPIFt+K+H+Iwu7z4tRHQHqY2bZtwQYQe6eIDVnV6cY?=
 =?us-ascii?Q?gimKpcveuSm510eTK8wNr3i7Lg9654PWVMy6U3nvbojgiDRJ1+fA0EZV+AXi?=
 =?us-ascii?Q?BhPJ+z8hoSDJTL1aPUgMeyaAzjqCLDygqrB4PxNRxdBR7kgw3VCoAnJtouPd?=
 =?us-ascii?Q?0EAlgtnpxAICYOWWa4UFuB2gPbQVysY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5811.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2939baf2-885f-4d00-4408-08da24a263b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2022 20:55:10.2315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ov+B7WHRhWaG9eQmX3ONRzNRmyKHeGqegIgPo124DGrdON8TvYvowAB6uCnmwAEXgYlKayuifkhb8iSobcTSmlD3pF3Q1sGQDQTJim6YOwI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2836
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
> From: Ertman, David M
> Sent: Friday, April 22, 2022 10:42 AM
> To: Ivan Vecera <ivecera@redhat.com>; netdev@vger.kernel.org
> Cc: poros <poros@redhat.com>; mschmidt <mschmidt@redhat.com>; Leon
> Romanovsky <leon@kernel.org>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> Saleem, Shiraz <shiraz.saleem@intel.com>; moderated list:INTEL ETHERNET
> DRIVERS <intel-wired-lan@lists.osuosl.org>; open list <linux-
> kernel@vger.kernel.org>
> Subject: RE: [PATCH net v3] ice: Fix race during aux device (un)plugging
>=20
> > -----Original Message-----
> > From: Ivan Vecera <ivecera@redhat.com>
> > Sent: Wednesday, April 20, 2022 11:09 PM
> > To: netdev@vger.kernel.org
> > Cc: poros <poros@redhat.com>; mschmidt <mschmidt@redhat.com>;
> Leon
> > Romanovsky <leon@kernel.org>; Brandeburg, Jesse
> > <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> > <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> > Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> > Ertman, David M <david.m.ertman@intel.com>; Saleem, Shiraz
> > <shiraz.saleem@intel.com>; moderated list:INTEL ETHERNET DRIVERS
> <intel-
> > wired-lan@lists.osuosl.org>; open list <linux-kernel@vger.kernel.org>
> > Subject: [PATCH net v3] ice: Fix race during aux device (un)plugging
> >
> > Function ice_plug_aux_dev() assigns pf->adev field too early prior
> > aux device initialization and on other side ice_unplug_aux_dev()
> > starts aux device deinit and at the end assigns NULL to pf->adev.
> > This is wrong because pf->adev should always be non-NULL only when
> > aux device is fully initialized and ready. This wrong order causes
> > a crash when ice_send_event_to_aux() call occurs because that function
> > depends on non-NULL value of pf->adev and does not assume that
> > aux device is half-initialized or half-destroyed.
> > After order correction the race window is tiny but it is still there,
> > as Leon mentioned and manipulation with pf->adev needs to be protected
> > by mutex.
> >
> > Fix (un-)plugging functions so pf->adev field is set after aux device
> > init and prior aux device destroy and protect pf->adev assignment by
> > new mutex. This mutex is also held during ice_send_event_to_aux()
> > call to ensure that aux device is valid during that call. Device
> > lock used ice_send_event_to_aux() to avoid its concurrent run can
> > be removed as this is secured by that mutex.
> >
> > Reproducer:
> > cycle=3D1
> > while :;do
> >         echo "#### Cycle: $cycle"
> >
> >         ip link set ens7f0 mtu 9000
> >         ip link add bond0 type bond mode 1 miimon 100
> >         ip link set bond0 up
> >         ifenslave bond0 ens7f0
> >         ip link set bond0 mtu 9000
> >         ethtool -L ens7f0 combined 1
> >         ip link del bond0
> >         ip link set ens7f0 mtu 1500
> >         sleep 1
> >
> >         let cycle++
> > done
> >
> > In short when the device is added/removed to/from bond the aux device
> > is unplugged/plugged. When MTU of the device is changed an event is
> > sent to aux device asynchronously. This can race with (un)plugging
> > operation and because pf->adev is set too early (plug) or too late
> > (unplug) the function ice_send_event_to_aux() can touch uninitialized
> > or destroyed fields. In the case of crash below pf->adev->dev.mutex.
> >
> > Crash:
> > [   53.372066] bond0: (slave ens7f0): making interface the new active o=
ne
> > [   53.378622] bond0: (slave ens7f0): Enslaving as an active interface =
with an
> u
> > p link
> > [   53.386294] IPv6: ADDRCONF(NETDEV_CHANGE): bond0: link becomes
> > ready
> > [   53.549104] bond0: (slave ens7f1): Enslaving as a backup interface w=
ith an
> > up
> >  link
> > [   54.118906] ice 0000:ca:00.0 ens7f0: Number of in use tx queues chan=
ged
> > inval
> > idating tc mappings. Priority traffic classification disabled!
> > [   54.233374] ice 0000:ca:00.1 ens7f1: Number of in use tx queues chan=
ged
> > inval
> > idating tc mappings. Priority traffic classification disabled!
> > [   54.248204] bond0: (slave ens7f0): Releasing backup interface
> > [   54.253955] bond0: (slave ens7f1): making interface the new active o=
ne
> > [   54.274875] bond0: (slave ens7f1): Releasing backup interface
> > [   54.289153] bond0 (unregistering): Released all slaves
> > [   55.383179] MII link monitoring set to 100 ms
> > [   55.398696] bond0: (slave ens7f0): making interface the new active o=
ne
> > [   55.405241] BUG: kernel NULL pointer dereference, address:
> > 0000000000000080
> > [   55.405289] bond0: (slave ens7f0): Enslaving as an active interface =
with an
> u
> > p link
> > [   55.412198] #PF: supervisor write access in kernel mode
> > [   55.412200] #PF: error_code(0x0002) - not-present page
> > [   55.412201] PGD 25d2ad067 P4D 0
> > [   55.412204] Oops: 0002 [#1] PREEMPT SMP NOPTI
> > [   55.412207] CPU: 0 PID: 403 Comm: kworker/0:2 Kdump: loaded Tainted:
> G
> > S
> >            5.17.0-13579-g57f2d6540f03 #1
> > [   55.429094] bond0: (slave ens7f1): Enslaving as a backup interface w=
ith an
> > up
> >  link
> > [   55.430224] Hardware name: Dell Inc. PowerEdge R750/06V45N, BIOS
> 1.4.4
> > 10/07/
> > 2021
> > [   55.430226] Workqueue: ice ice_service_task [ice]
> > [   55.468169] RIP: 0010:mutex_unlock+0x10/0x20
> > [   55.472439] Code: 0f b1 13 74 96 eb e0 4c 89 ee eb d8 e8 79 54 ff ff=
 66 0f 1f
> 84
> > 00 00 00 00 00 0f 1f 44 00 00 65 48 8b 04 25 40 ef 01 00 31 d2 <f0> 48 =
0f b1 17
> 75
> > 01 c3 e9 e3 fe ff ff 0f 1f 00 0f 1f 44 00 00 48
> > [   55.491186] RSP: 0018:ff4454230d7d7e28 EFLAGS: 00010246
> > [   55.496413] RAX: ff1a79b208b08000 RBX: ff1a79b2182e8880 RCX:
> > 0000000000000001
> > [   55.503545] RDX: 0000000000000000 RSI: ff4454230d7d7db0 RDI:
> > 0000000000000080
> > [   55.510678] RBP: ff1a79d1c7e48b68 R08: ff4454230d7d7db0 R09:
> > 0000000000000041
> > [   55.517812] R10: 00000000000000a5 R11: 00000000000006e6 R12:
> > ff1a79d1c7e48bc0
> > [   55.524945] R13: 0000000000000000 R14: ff1a79d0ffc305c0 R15:
> > 0000000000000000
> > [   55.532076] FS:  0000000000000000(0000) GS:ff1a79d0ffc00000(0000)
> > knlGS:0000000000000000
> > [   55.540163] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   55.545908] CR2: 0000000000000080 CR3: 00000003487ae003 CR4:
> > 0000000000771ef0
> > [   55.553041] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > 0000000000000000
> > [   55.560173] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> > 0000000000000400
> > [   55.567305] PKRU: 55555554
> > [   55.570018] Call Trace:
> > [   55.572474]  <TASK>
> > [   55.574579]  ice_service_task+0xaab/0xef0 [ice]
> > [   55.579130]  process_one_work+0x1c5/0x390
> > [   55.583141]  ? process_one_work+0x390/0x390
> > [   55.587326]  worker_thread+0x30/0x360
> > [   55.590994]  ? process_one_work+0x390/0x390
> > [   55.595180]  kthread+0xe6/0x110
> > [   55.598325]  ? kthread_complete_and_exit+0x20/0x20
> > [   55.603116]  ret_from_fork+0x1f/0x30
> > [   55.606698]  </TASK>
> >
> > Fixes: f9f5301e7e2d ("ice: Register auxiliary device to provide RDMA")
> > Cc: Leon Romanovsky <leon@kernel.org>
> > Signed-off-by: Ivan Vecera <ivecera@redhat.com>
>=20
> Sorry for previous mis-reply - hit the wrong button.
>=20
> LGTM
> Acked-by: Dave Ertman <david.m.ertman@intel.com>

After thinking about this for a bit longer, I did think of one issue.

With the removal of the device_lock in ice_send_event_to_aux(), there is no=
 guarantee that the
function pointer will not become NULL by the auxiliary_driver unloading.  I=
t is a very small window,
but it could happen.

I think the device_lock should probably stay also.

DaveE
