Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013C16EA367
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 07:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjDUF4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 01:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbjDUFz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 01:55:58 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B806E92
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 22:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682056557; x=1713592557;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DWandP+4Fbt1fnOk088s7X0DWT1znb6GKf3ZnmyF8ao=;
  b=eZgKDsxjaU1sxTvpWLNshQ2Upz9kXun1o6RCt0O9tP780a5N0Rf/Pdn8
   C+y5c2SDNHwWzL8XzYotROsTe8lT96shFL2dV2P1XhHauvwZEzJNWve/h
   mUGAQyAk2Jtnxm/ShjH65pozLEUZSV7Nq+RVneaRyLbKHxKT8RBuQG5Tf
   oD/imxY0nuxFTgMne+RtSmE671azrlB9N18yKUoiDOA2Uq56XFyAxy2Xq
   8/kqW6WHSNoE5tktOXELIbueyeGhUk5wy4jhRxEnD7sYsmofMCEj9UjxZ
   EnOqeG9cTy6ul22KsyPJOZNNltH4pZs7xy3NFtHv+KwdOkWLxCjd9andc
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="330121657"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="330121657"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 22:55:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="1021812960"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="1021812960"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 20 Apr 2023 22:55:56 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 22:55:56 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 22:55:56 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 22:55:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OavJ+7rKVTffGcXjeDXU/ZtO4JK8U15iuEtKHeocben+HbYJuzQdAVOllZiG2B8QkIm/uDB/MxSg95FXodvCirAs4KlktK5hcOBCHVGvPqU6d3fVpS0V5+uZU8CrxDga5/RThLPRTdHPkNuJSQqlkw3M6RJklaVb5uHeTLjpREkJizIcArNWrRWCGufPCzbGxRWjA86eTVnsfZ5C0ECSr4YdHjc9sJJLS7mN1H5kI/2bI307c+3OrmJug7hKuHDFGqRxd55AhQnJTcmsalnIbsGzQGxworGGjGun3YQrSceN7MzoLqvV2v3qX4bAR1faG4aietpxGE3060itjsglyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jd8UOGZTErEORKkugLV7QzF/DnSI5AKyXDqbA3hQwFY=;
 b=OzgYYNVxYdm7Tw7GVEv8mcHffniWA2l8/YAM370yB1ChqCa5eoy+/AHPYWlPJkzCz1lc0BYmqEBDAs98WL2LeA0kfnUmkKzj44vQm1c59sOdHB+8aNlFzgQWdgK5yqIytG2gGRgX3mmN/86V/JqHWmoyfmJh7R//2vvESb3HnLrVmtSQdqb9qe2RmmcfCSOki5DuWLV4CEdyyjbPRfFbPu8SS5kYp4WeSKGoykrTfCwpp/7if/nrGgJBYezkl7VDsWmjmE6AqmWXy0QXSWvMgAjeq22S6UpnPNns3DI+Xc1pB+nE030fWMC7mZZENoYG117py3Km9N+sbOaVkZW8UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3122.namprd11.prod.outlook.com (2603:10b6:208:75::32)
 by CH3PR11MB8314.namprd11.prod.outlook.com (2603:10b6:610:170::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 05:55:54 +0000
Received: from BL0PR11MB3122.namprd11.prod.outlook.com
 ([fe80::a4e7:9fa1:19f7:6a41]) by BL0PR11MB3122.namprd11.prod.outlook.com
 ([fe80::a4e7:9fa1:19f7:6a41%6]) with mapi id 15.20.6298.045; Fri, 21 Apr 2023
 05:55:54 +0000
From:   "Pucha, HimasekharX Reddy" <himasekharx.reddy.pucha@intel.com>
To:     "Raczynski, Piotr" <piotr.raczynski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Swiatkowski, Michal" <michal.swiatkowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH net-next v3 8/8] ice: add dynamic
 interrupt allocation
Thread-Topic: [Intel-wired-lan] [PATCH net-next v3 8/8] ice: add dynamic
 interrupt allocation
Thread-Index: AQHZXYKobowSNHOV0UuVzdioB4l5gK81cDew
Date:   Fri, 21 Apr 2023 05:55:54 +0000
Message-ID: <BL0PR11MB3122D2AF6CA3FFCE65FFD2FEBD609@BL0PR11MB3122.namprd11.prod.outlook.com>
References: <20230323122440.3419214-1-piotr.raczynski@intel.com>
 <20230323122440.3419214-9-piotr.raczynski@intel.com>
In-Reply-To: <20230323122440.3419214-9-piotr.raczynski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3122:EE_|CH3PR11MB8314:EE_
x-ms-office365-filtering-correlation-id: b3cef3ea-1846-4119-755e-08db422d11e7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uyqfaAqk3vNvqrS84BD3pcSN0XAWYwIYZAR48iPR14rsh3jfr+oKrk+CYO9tKb6xEfpwBwzZT7XMOHbB/cBPjKjRgmnHXL8ASQvaHkj7VXunKWqEzoZ867Vu1o8q5FgJs+Z5tr8ZJlr3riBBoRa7IOBbt1RtuMR6reZ7nyWY4WM5SB4Hf+cWPbUYiE0lsyIVIMf7bzio36+2EUK3ayJKB8SQjPav1toZi/C6WMJSGxWF7GzszQWYLbR0+dxxHGMuOZyW6r4drxUDydxf8IwjJ/UBEJgTYv9bHXBY1oZvo11/hl8+1TEUkmSt1b+3IyEce9ILzVxR9sVlv947ldOFA/pQnL9tL3T+XTB9fireeMIsiqAIiJpElW8ajyrN+lduw+LZk2cUF4CMQ9Z6vXrkxGyJee/3ftNouiduSLOIetNVvf3FW77cgv2hapKlPc6bZcO0nslmKxAKt25r6f+8K9q28p+Fo79/XDrZpNgLrIYt3L/2+pkctV/4XrxH87CsIm909d4Gg1ct2hfFgTc8B/gwulTLjejWsc0gBCbB2NSZoCTdHZg7X7gd8dh5u7/QToEk/O3iRYO19E1n63f1Q1wU/UiujnqK3tWG/H0pEMPpeAgrhy5gcaKVBbF5OPfP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3122.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(39860400002)(396003)(346002)(366004)(451199021)(33656002)(4326008)(316002)(110136005)(76116006)(66946007)(66476007)(66556008)(64756008)(66446008)(54906003)(7696005)(478600001)(71200400001)(55016003)(8936002)(5660300002)(8676002)(41300700001)(52536014)(2906002)(38070700005)(86362001)(82960400001)(38100700002)(107886003)(26005)(6506007)(53546011)(9686003)(83380400001)(122000001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?n5zNQBgaJQgD99DZTkFN/MlugFy9N+r1nP35gVWnw8i1OfI7on5JevX1ubIW?=
 =?us-ascii?Q?qjzHN+NP4fLsdiwWWSboHvSnEsRSVJotlJf//XqMxzsK//yQEBu6q4MU0xrt?=
 =?us-ascii?Q?lfBciRcArr8fJYSjYI3DnhWiS2eWf6mt6Fjq0GWetOhhXvRS2cM9MpN3jHGS?=
 =?us-ascii?Q?yQ993t/dlQ1r6SC3nCnlwQpkijfQq6qgCw6eYibeNWS6bdy19LwLqH8Eva3c?=
 =?us-ascii?Q?o7ixArTawe9eKvZ3UJlLMKXlBfYsfVfmOcnARVj738lARUR/KmE7/UJfCN4G?=
 =?us-ascii?Q?ulE5Vh0XJsvs7AmiapYifkraEUwjED/rcT/KaQ6OteBnvtOeczSwMsUwdaeK?=
 =?us-ascii?Q?mgsieXtxI3mkskVM1ISMuxJFO4KihSdqQfPdQaMsvvslqhOaoU5IYrD1dbM5?=
 =?us-ascii?Q?uWVUGi1t+khCf+mlg8MpQH3TtzjSPW16JM208wtZ8DrCp370Ifx1x/26nWQO?=
 =?us-ascii?Q?8VHc/J6ft8vWmG+V1mbOSBAj0Zdq55kuNHrLrZRHAoB0ta6D3ny8S1klXHQc?=
 =?us-ascii?Q?y73goJIV1qmn9CnwqYOlvw9JqMRH+XouVnfYtu2YG5mS0eB4kN6YBIINt5lM?=
 =?us-ascii?Q?xFuCUx7f+e3XlLaQD1hqgTQFZHm0CFRe1KJA1TwMCJXgegSnlj9CIHr4YQiB?=
 =?us-ascii?Q?KJ5Q95/X+aofnMPcT+jZh4GpKKSD6lbKHh1K+T0qXZ/Bo8NA516pbX+IESJo?=
 =?us-ascii?Q?KXdg014dPaGuQktqXHYFPoqmV12m0q/MhZI/PXS0SrAXJzs1TJJNNfITTVhs?=
 =?us-ascii?Q?+tR3qU28HlwNAZevxlDsEdRJr2Qjf3PNGheHXjucdqdaj+e3Z9eMOpiW6ltV?=
 =?us-ascii?Q?w4Bt5NhzSavk5AOp8Znesp7naq9qoQ52/R6aJ4HdwsAKbUUmIhm0Gk4SSKL6?=
 =?us-ascii?Q?elLhVrCyA7Axe3D7krZ7Osj4yYiqDlLBB56yoFyKj7pWtpj8/sNesjlYYz5q?=
 =?us-ascii?Q?xE6O0DMrf3wmgl4sJ+TAGLksY3T8vAaiZx+BTD3aKIKCkz1MnyN56w/sFhfc?=
 =?us-ascii?Q?wveGTz2eSbN0bH5s7NGrq/XBgG2omryxygV3IAht1yMycAdfis4mA/hlN5/y?=
 =?us-ascii?Q?fy1ydq7YRLxkEEqAMJzKjefmWZMinWrmFGQ50q5+RP6LKW77g3Inwmt1spc2?=
 =?us-ascii?Q?mEjEgvhnNntAdS1c9Nap71eyMkYmvJuQ7M1yyQH+fgth22+Y//9Fdlb/Cfjy?=
 =?us-ascii?Q?eAUsMfBgqewcXgEr92ygzFoCH25FLHknGqDekRW5Sd5D0OLw6cdX2Mhkb1we?=
 =?us-ascii?Q?ZNkNXsvyQPYotvvs3FJ15IpXKWD3OHYHdw1EF8Kh8bj+Wy1QFyJMxYnidMox?=
 =?us-ascii?Q?djtJSvxexhfHLbOx8wZrD6fnwzWjq+qQQSwp4cIVkXMEbgMRV1lJppxTrFik?=
 =?us-ascii?Q?R6RynQMPtRjmmZK5o044EDyfP1d1A3hqFnPH7559yZSkUX6vFu8Fo2rWpcEu?=
 =?us-ascii?Q?Xlj8sRXvlotE3N6d3snWCcTzjptZ21BW91W+dr8M8WAO5ocPUBg4CPoa/8co?=
 =?us-ascii?Q?q+65aXXlAGVMusw/vvBasoLsQQc0t2mT8TGOYsZMolcZ2ExcJyQBvf5kqA1y?=
 =?us-ascii?Q?sbUuCl3Frr94DV3NCTjgPbWZYsvOU4G225+Sfm9hOi9dtFItJToYK7g++FR0?=
 =?us-ascii?Q?mw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3122.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3cef3ea-1846-4119-755e-08db422d11e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 05:55:54.4355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RIibUGYFeiKRWJgZgfSo7eL/qzcgFnFPIR/b+cMlkG/BCBH7IZZqquZFi8yG18luwu9/UJm7FghtJXbL/SX7ToutpGR2ey2r6gAdl3/qkYnAkfJdYNDQVvC5IyAsaekr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8314
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of R=
aczynski, Piotr
> Sent: Thursday, March 23, 2023 5:55 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Swiatkowski, Michal <michal.swiatkowski@intel.com>; netdev@vger.kerne=
l.org; Brandeburg, Jesse <jesse.brandeburg@intel.com>; Saleem, Shiraz <shir=
az.saleem@intel.com>
> Subject: [Intel-wired-lan] [PATCH net-next v3 8/8] ice: add dynamic inter=
rupt allocation
>=20
> Currently driver can only allocate interrupt vectors during init phase by=
 calling pci_alloc_irq_vectors. Change that and make use of new pci_msix_al=
loc_irq_at/pci_msix_free_irq API and enable to allocate and free more inter=
rupts after MSIX has been enabled. Since not all platforms supports dynamic=
 allocation, check it with pci_msix_can_alloc_dyn.
>=20
> Extend the tracker to keep track how many interrupts are allocated initia=
lly so when all such vectors are already used, additional interrupts are au=
tomatically allocated dynamically. Remember each interrupt allocation metho=
d to then free appropriately. Since some features may require interrupts al=
located dynamically add appropriate VSI flag and take it into account when =
allocating new interrupt.
>=20
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h       |   3 +
>  drivers/net/ethernet/intel/ice/ice_base.c  |   2 +-
>  drivers/net/ethernet/intel/ice/ice_idc.c   |   2 +-
>  drivers/net/ethernet/intel/ice/ice_irq.c   | 107 ++++++++++++++++++---
>  drivers/net/ethernet/intel/ice/ice_irq.h   |   5 +-
>  drivers/net/ethernet/intel/ice/ice_main.c  |   2 +-
>  drivers/net/ethernet/intel/ice/ice_sriov.c |   5 +-
>  7 files changed, 105 insertions(+), 21 deletions(-)
>

Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Co=
ntingent worker at Intel)

