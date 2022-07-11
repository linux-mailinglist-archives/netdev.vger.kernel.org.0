Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFA756F983
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 11:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiGKJBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 05:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiGKJBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 05:01:39 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C5B21E16;
        Mon, 11 Jul 2022 02:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657530097; x=1689066097;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ornNUA4Ly+R0B7C1s1W9sBPOP6X3AzNqXcjwc/t2mzo=;
  b=eqcxtAZTXOhv8ddn24CzZnXg21F3tOrUq33KRBfrwkdTwxEL+xYu2XIM
   UVKQMt/zpJDw0YVr9XHD3uWeNMhodAGql47Gpg318r+/+MvAehnqpxuQ6
   tJjNvCd5Ii6T26QdoiKz/gqLPgmYNi5fOxGlBbD5VTu8qJaXgmLX1H6tY
   0RVvrHabz4yB3bn2pTFa+93+0sr2bz4qYGEegDNl2i4UZWnlD6aozUXIK
   bva0eoz41ul/83h0cZc/JqVQcdzrk9iodvB5ZLjquAIzEguak4ZQlyiBi
   YBNiO5rlZ96NTxH86f3NmViIYN7yDroST92YwlimqfEP7jkU/dXZoZ6wz
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="282163298"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="282163298"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:01:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="697563270"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga002.fm.intel.com with ESMTP; 11 Jul 2022 02:01:37 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 11 Jul 2022 02:01:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 11 Jul 2022 02:01:36 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 11 Jul 2022 02:01:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eMBjqHr5ULCDG/ntQcSJXU+u2q15UaCRU8aAZZN8v3nfii3q8lSO0DXYB5TnaIU6b8vmEcxL0njyjkHUdN4mXjcRnkvF7tSnulVi28xHQGWualtrrjIQyfK9Z8MaS6yROObT4ogCGfsbqIEapEU1PdxMX3dqQ3ZIfr5wHuCcrMGG5jDdZhUkHPlQbW+XaL6gEHabnglTmFxtIcddnqaxR+y8ow2MUf6oZrerl4aUbtx8joIUma15C6oSRnZG344rRLOIsH6epDI0xq8WkrAwh6WpMjZcQr0YCTnnTqhwzWv+XgM1cD8KbQJRUH3tFc/b45JXDO+0/5N7m7v1IZZswA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5r8o4ZSQFdLtGNtCDLWgorsGLNzYxPpcQ9vZypKUGU=;
 b=NS63Hb5gZDTgCvqb6Q2jaPDbhfa7H9VzqjRxZPGNXVS7YvWRrkyLoXb2XDZwbvvB0OxxB/KP7BXTp66vhVEMr0WHWfuNL+rKIY6nixeu2qmvc3uUzrFTX5ZPbrrQFpOUg4Acz22XRrlhH5WtC6n9b/RSnAKuMbssr1cQMvcMNkmu0+E1StBAf0zr/Ej7L7UhXjTXrcLFbUQJ4J+KbGnaKNgRvF+ZbYeS997UxPixbSsnhzFnQefWRGa+jh1ifOXgJfWDD6AKeMkAR1nJ9xgI/Cg8JQd4eoT3v2SmwWJrlFozJ88l5mKfmxngrwM0RbnaumYrsYUTA9YA2WZ7ssbXrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DM6PR11MB2795.namprd11.prod.outlook.com (2603:10b6:5:bf::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.23; Mon, 11 Jul 2022 09:01:34 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::2ce4:94fa:eef0:b822]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::2ce4:94fa:eef0:b822%5]) with mapi id 15.20.5417.020; Mon, 11 Jul 2022
 09:01:34 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v2 1/3] dpll: Add DPLL framework base functions
Thread-Topic: [RFC PATCH v2 1/3] dpll: Add DPLL framework base functions
Thread-Index: AQHYiZJ9XsNFx64Yukic2kh2Sx3oGa149B1g
Date:   Mon, 11 Jul 2022 09:01:34 +0000
Message-ID: <DM6PR11MB4657460B855863E76EBB6BCD9B879@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20220626192444.29321-1-vfedorenko@novek.ru>
 <20220626192444.29321-2-vfedorenko@novek.ru>
In-Reply-To: <20220626192444.29321-2-vfedorenko@novek.ru>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4549e5d4-fb7c-483b-ea23-08da631bf4c6
x-ms-traffictypediagnostic: DM6PR11MB2795:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IcCxPdD3LU7S8qMJAebv4EtyPJeBsoAN++Gx3g+q3n/4AM4PRyagKq9tTR1QGjauVoFlDOUQzX4g9xZrirRUVgcdtBJK1HlclLrEKIX0ATT29pT7J2L3tyu/TV5/xVKR28xbxrhbdtMfBR+9+w+k9+75gSwshFTmvRxNrioCh7XY9lpFmKpA1g7s2M+yTFuMTP6WSBUe2xKfg2sFAtYSR9Omn4XsFUM+qfHeMbJdFEHVA2XHmASZi52bHpgPrADOhZtAhV0sjAs5DnXTnpkn7Fd6e3X9iWyR0+qW9E4B2sSl0N3nQyzQAuVv7Nas9NI/sTyjcr2tIn8D+8TzPRHTYW7rqa6tkGxgt5iUDLWz92NVzBF+rxT2At2Wtc+/+Yqu5u46Ah74jWJWUHyEKO+/e1rOrzrTcfj2KitqX5wCyli3qQl1iOeiZ9K+zT4VD9pYtNlRL6Y60WLLGBPx+uGyAZ2mwuhTi+kM343xVjHgwhjuFpo43WmnbKd5mt3QsJxjHS0/OghbvLb7onCk5VB/iMDUu5eHaErjm22HzrZBOlPQ6LiIt11D4zTX73uSlLPoULjdvnGLXfhwNPWKRXMKksiKggN7XxRNQZhVfvHB9/1Mr1Vk3mjvJcxej7ANBdwtCUnOicIEKIJz4mUiz0NYO9FUU0u2NbkGWMyu8L+5uEcwm7houv3cDpYSqyJMf8tnQbyArY7JAyQPh246piP8Js2Gi3An1Hiks0HXEt/3X1mx3hYLRK9n8J95v7AGiLEl5hNf5X/APGb895IJHSM58SajDztcg7/m6t2V+fo/47RLJotkd/qlrzOI27b0aruz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(396003)(39860400002)(376002)(136003)(83380400001)(38100700002)(8676002)(66476007)(64756008)(66946007)(122000001)(76116006)(66556008)(4326008)(66446008)(186003)(82960400001)(86362001)(8936002)(30864003)(55016003)(5660300002)(52536014)(7696005)(316002)(54906003)(6506007)(2906002)(41300700001)(26005)(71200400001)(33656002)(9686003)(110136005)(38070700005)(478600001)(579004)(559001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?z1BJl8Ya8eRBx1PJt7hq+DbkEVQkxeRuECIK0rNHAysPfbxy0pKcJ7RjmGE5?=
 =?us-ascii?Q?ql175nk/20A4fZJp3SBe864YQAIaGy85F6pgffz9TjiUEL3bsaeGBYM8qauR?=
 =?us-ascii?Q?QhqoFy4YnnjPQGg5AvGYcMkXeSIWm0PrQiR0bJ/8LBhC0qCbeYL1hWJiLLaY?=
 =?us-ascii?Q?iCZDvrrilpq/2H6sDx6tUoeNgNu2rJDRsf55BtaDynq4do/Z2ON5OnVoE1PY?=
 =?us-ascii?Q?oo9/w/9Z4ebq/Gl4UA1YWFB1oDdvl1A7y5/9qzK+JAShvA1FqovwSXfJPSda?=
 =?us-ascii?Q?GGZ1Jrqr9MGDXmeD8+jwrw2YhPSakeW7OifoSfjEJqDYNoMqtz2E8w/sjrtw?=
 =?us-ascii?Q?svu88h/uWJ3oWhmXKz6ZpeMiEfcV7EB8Lr9K7V28tCZ5AxeDmBh9K8BCu+VA?=
 =?us-ascii?Q?qahdTjrw6Ft7znO4SFmUBSggWO7vOpRO74QWWcGrjZWduAjujIOzKAIih6nf?=
 =?us-ascii?Q?XOc71ORPy3bATk4nZIZ4vUFxu4fmGpBsxUIbfi6pONAzRLO5ePs9DOWYhQMn?=
 =?us-ascii?Q?5ZlzuT0iYQY7FTc10WfPpGGZMvmCac66h5gOf6N7MmBw3yfU5NNGHOm3Aj4G?=
 =?us-ascii?Q?1eovdtkl0yzg0y/6GQVA6qsvJg8Cs07n/95Cz46LIAfOzaVTrlp1UfOquOJS?=
 =?us-ascii?Q?FZgbGfy/7f0y4zOIpxJVPtKySTEYPVc9p3UJpbsLtFmdv1G8oJNGKbgTrPDF?=
 =?us-ascii?Q?BLPIlw5tvgMHkJb0Kpjo4wVkOBS+S4qPMyh/h79GTVvKyGRQzYDsAJoHEo3H?=
 =?us-ascii?Q?WsbYZkV6NM/hbJTSe4cW54eFBrTmSAKe1soTvWbb4G1PXRGngdFo+Aus/HuG?=
 =?us-ascii?Q?MlPweZ8sD5Fr6F84n4yDAOggwK4XfcLUHCxv/j4ZiT9uD2H/gqARZlG5de9G?=
 =?us-ascii?Q?rB8n7uMif+N8KNZyMBiZ/F6O22EfT4d4OWrNPWIm6mBdSaj8GZzx27NU1Mrt?=
 =?us-ascii?Q?RnOBjZW/ElCjt8eDQwcMR81jIu9xxvQRp7alK7INsqOOTAPWfahigxqDBIPP?=
 =?us-ascii?Q?N1Yi+P6JNhyGOh0eAL9iTQKq0tn5WuBikGNVM6g8O1atAAt5o1N0tcNOdVcv?=
 =?us-ascii?Q?zpQxTTRWXjq9AOWZFc2GQqW0WUtMoCCtnp5X5qKb6B4G47fJH4nWJgyI1uMN?=
 =?us-ascii?Q?T50IGoVenGhMVRcPh2dL0HTs9hTyyU9PsumcOZnZudJNyxOlGSV8FgaRaPSI?=
 =?us-ascii?Q?D7rifgTfW3OjDIWxP4sh+8I0fisUTzPRirZaKuMk53gQ2XUyiGhzZijzHqee?=
 =?us-ascii?Q?ZyhXnWwIMU0YNa0YsakVwEZwpWVvcuLGsYdbZQ4Wmer9jkReK6i88x60jOip?=
 =?us-ascii?Q?k7ONdqXdjZUtdoUyvjh5gV88xn1UDbWPHGjD2vUeE08SLrI1p2VufUOJ18A8?=
 =?us-ascii?Q?TN8iQRiMXsVDFN7K3Om4KFovHLAuemfWMIdNomakgMRk8XxR8SSO8dw2DJND?=
 =?us-ascii?Q?kJM1A1dxl58cJE17j8f7+9bJAlqRx8EriD8IiaC2OVZs/LloLYRwYhw1EU/O?=
 =?us-ascii?Q?R7rbrU+BK0T5nckGudgvB/zqasZgCLg+0oAzlKb4zVYCeuvPdmOSOqmmeTl/?=
 =?us-ascii?Q?9hGE5B3eUurvh9um4hOek5dKTIoMAt+tHJIbI0sczLiZD9IfSeemYzdDTTXH?=
 =?us-ascii?Q?eQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4549e5d4-fb7c-483b-ea23-08da631bf4c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 09:01:34.7978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 44KD1+ikAYD2u8OFKivd95RnNMeT1lmyOPS8ti4jG5csIqJux5yJrnDUf6bD3NCVm1h7rDCXv26r3oV68gq4pOg91GW/yfFXmuEWAlAgvMo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2795
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----Original Message-----
From: Vadim Fedorenko <vfedorenko@novek.ru>=20
Sent: Sunday, June 26, 2022 9:25 PM
>
>From: Vadim Fedorenko <vadfed@fb.com>
>
>DPLL framework is used to represent and configure DPLL devices
>in systems. Each device that has DPLL and can configure sources
>and outputs can use this framework.
>
>Signed-off-by: Vadim Fedorenko <vadfed@fb.com>

Hi Vadim,
I've been trying to implement usage of this code in our driver.=20
Any chance for some testing/example app?

>---
> MAINTAINERS                 |   8 +
> drivers/Kconfig             |   2 +
> drivers/Makefile            |   1 +
> drivers/dpll/Kconfig        |   7 +
> drivers/dpll/Makefile       |   7 +
> drivers/dpll/dpll_core.c    | 159 +++++++++++++
> drivers/dpll/dpll_core.h    |  40 ++++
> drivers/dpll/dpll_netlink.c | 454 ++++++++++++++++++++++++++++++++++++
> drivers/dpll/dpll_netlink.h |   7 +
> include/linux/dpll.h        |  29 +++
> include/uapi/linux/dpll.h   |  79 +++++++
> 11 files changed, 793 insertions(+)
> create mode 100644 drivers/dpll/Kconfig
> create mode 100644 drivers/dpll/Makefile
> create mode 100644 drivers/dpll/dpll_core.c
> create mode 100644 drivers/dpll/dpll_core.h
> create mode 100644 drivers/dpll/dpll_netlink.c
> create mode 100644 drivers/dpll/dpll_netlink.h
> create mode 100644 include/linux/dpll.h
> create mode 100644 include/uapi/linux/dpll.h
>
>diff --git a/MAINTAINERS b/MAINTAINERS
>index 05fcbea3e432..5532130baf36 100644
>--- a/MAINTAINERS
>+++ b/MAINTAINERS
>@@ -6122,6 +6122,14 @@ F:	Documentation/networking/device_drivers/ethernet=
/freescale/dpaa2/switch-drive
> F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-switch*
> F:	drivers/net/ethernet/freescale/dpaa2/dpsw*
>=20
>+DPLL CLOCK SUBSYSTEM
>+M:	Vadim Fedorenko <vadfed@fb.com>
>+L:	netdev@vger.kernel.org
>+S:	Maintained
>+F:	drivers/dpll/*
>+F:	include/net/dpll.h
>+F:	include/uapi/linux/dpll.h
>+
> DPT_I2O SCSI RAID DRIVER
> M:	Adaptec OEM Raid Solutions <aacraid@microsemi.com>
> L:	linux-scsi@vger.kernel.org
>diff --git a/drivers/Kconfig b/drivers/Kconfig
>index b6a172d32a7d..dcdc23116eb8 100644
>--- a/drivers/Kconfig
>+++ b/drivers/Kconfig
>@@ -241,4 +241,6 @@ source "drivers/peci/Kconfig"
>=20
> source "drivers/hte/Kconfig"
>=20
>+source "drivers/dpll/Kconfig"
>+
> endmenu
>diff --git a/drivers/Makefile b/drivers/Makefile
>index 9a30842b22c5..acc370a2cda6 100644
>--- a/drivers/Makefile
>+++ b/drivers/Makefile
>@@ -189,3 +189,4 @@ obj-$(CONFIG_COUNTER)		+=3D counter/
> obj-$(CONFIG_MOST)		+=3D most/
> obj-$(CONFIG_PECI)		+=3D peci/
> obj-$(CONFIG_HTE)		+=3D hte/
>+obj-$(CONFIG_DPLL)		+=3D dpll/
>diff --git a/drivers/dpll/Kconfig b/drivers/dpll/Kconfig
>new file mode 100644
>index 000000000000..a4cae73f20d3
>--- /dev/null
>+++ b/drivers/dpll/Kconfig
>@@ -0,0 +1,7 @@
>+# SPDX-License-Identifier: GPL-2.0-only
>+#
>+# Generic DPLL drivers configuration
>+#
>+
>+config DPLL
>+  bool
>diff --git a/drivers/dpll/Makefile b/drivers/dpll/Makefile
>new file mode 100644
>index 000000000000..0748c80097e4
>--- /dev/null
>+++ b/drivers/dpll/Makefile
>@@ -0,0 +1,7 @@
>+# SPDX-License-Identifier: GPL-2.0
>+#
>+# Makefile for DPLL drivers.
>+#
>+
>+obj-$(CONFIG_DPLL)          +=3D dpll_sys.o
>+dpll_sys-y                  +=3D dpll_core.o dpll_netlink.o
>diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
>new file mode 100644
>index 000000000000..dc0330e3687d
>--- /dev/null
>+++ b/drivers/dpll/dpll_core.c
>@@ -0,0 +1,159 @@
>+// SPDX-License-Identifier: GPL-2.0
>+/*
>+ *  dpll_core.c - Generic DPLL Management class support.
>+ *
>+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>+ */
>+
>+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>+
>+#include <linux/device.h>
>+#include <linux/err.h>
>+#include <linux/slab.h>
>+#include <linux/string.h>
>+
>+#include "dpll_core.h"
>+
>+static DEFINE_MUTEX(dpll_device_xa_lock);
>+static DEFINE_XARRAY_FLAGS(dpll_device_xa, XA_FLAGS_ALLOC);
>+#define DPLL_REGISTERED XA_MARK_1
>+
>+#define ASSERT_DPLL_REGISTERED(d)                                        =
   \
>+	WARN_ON_ONCE(!xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
>+#define ASSERT_DPLL_NOT_REGISTERED(d)                                    =
  \
>+	WARN_ON_ONCE(xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
>+
>+
>+int for_each_dpll_device(int id, int (*cb)(struct dpll_device *, void *),=
 void *data)

Line is over 80 chars

>+{
>+	struct dpll_device *dpll;
>+	unsigned long index;
>+	int ret =3D 0;
>+
>+	mutex_lock(&dpll_device_xa_lock);
>+	xa_for_each_start(&dpll_device_xa, index, dpll, id) {
>+		if (!xa_get_mark(&dpll_device_xa, index, DPLL_REGISTERED))
>+			continue;
>+		ret =3D cb(dpll, data);
>+		if (ret)
>+			break;
>+	}
>+	mutex_unlock(&dpll_device_xa_lock);
>+
>+	return ret;
>+}
>+
>+struct dpll_device *dpll_device_get_by_id(int id)
>+{
>+	struct dpll_device *dpll =3D NULL;
>+
>+	if (xa_get_mark(&dpll_device_xa, id, DPLL_REGISTERED))
>+		dpll =3D xa_load(&dpll_device_xa, id);
>+	return dpll;
>+}
>+
>+void *dpll_priv(struct dpll_device *dpll)
>+{
>+	return dpll->priv;
>+}
>+EXPORT_SYMBOL_GPL(dpll_priv);
>+
>+static void dpll_device_release(struct device *dev)
>+{
>+	struct dpll_device *dpll;
>+
>+	dpll =3D to_dpll_device(dev);
>+
>+	dpll_device_unregister(dpll);
>+	dpll_device_free(dpll);
>+}
>+
>+static struct class dpll_class =3D {
>+	.name =3D "dpll",
>+	.dev_release =3D dpll_device_release,
>+};
>+
>+struct dpll_device *dpll_device_alloc(struct dpll_device_ops *ops, int so=
urces_count,
>+					 int outputs_count, void *priv)

Aren't there some alignment issues around function definitions?

>+{
>+	struct dpll_device *dpll;
>+	int ret;
>+
>+	dpll =3D kzalloc(sizeof(*dpll), GFP_KERNEL);
>+	if (!dpll)
>+		return ERR_PTR(-ENOMEM);
>+
>+	mutex_init(&dpll->lock);
>+	dpll->ops =3D ops;
>+	dpll->dev.class =3D &dpll_class;
>+	dpll->sources_count =3D sources_count;
>+	dpll->outputs_count =3D outputs_count;
>+
>+	mutex_lock(&dpll_device_xa_lock);
>+	ret =3D xa_alloc(&dpll_device_xa, &dpll->id, dpll, xa_limit_16b, GFP_KER=
NEL);
>+	if (ret)
>+		goto error;
>+	dev_set_name(&dpll->dev, "dpll%d", dpll->id);

Not sure if I mentioned it before, the user must be able to identify the
purpose and origin of dpll. Right now, if 2 dplls register in the system, i=
t is
not possible to determine where they belong or what do they do. I would say=
,
easiest to let caller of dpll_device_alloc assign some name or description.

>+	mutex_unlock(&dpll_device_xa_lock);
>+	dpll->priv =3D priv;
>+
>+	return dpll;
>+
>+error:
>+	mutex_unlock(&dpll_device_xa_lock);
>+	kfree(dpll);
>+	return ERR_PTR(ret);
>+}
>+EXPORT_SYMBOL_GPL(dpll_device_alloc);
>+
>+void dpll_device_free(struct dpll_device *dpll)
>+{
>+	if (!dpll)
>+		return;
>+
>+	mutex_destroy(&dpll->lock);
>+	kfree(dpll);
>+}

dpll_device_free() is defined in header, shouldn't it be exported?=20

>+
>+void dpll_device_register(struct dpll_device *dpll)
>+{
>+	ASSERT_DPLL_NOT_REGISTERED(dpll);
>+
>+	mutex_lock(&dpll_device_xa_lock);
>+	xa_set_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED);
>+	dpll_notify_device_create(dpll->id, dev_name(&dpll->dev));

dpll_notify_device_create is not yet defined, this is part of patch 2/3?
Also in patch 2/3 similar call was added in dpll_device_alloc().

>+	mutex_unlock(&dpll_device_xa_lock);
>+}
>+EXPORT_SYMBOL_GPL(dpll_device_register);
>+
>+void dpll_device_unregister(struct dpll_device *dpll)
>+{
>+	ASSERT_DPLL_REGISTERED(dpll);
>+
>+	mutex_lock(&dpll_device_xa_lock);
>+	xa_erase(&dpll_device_xa, dpll->id);
>+	mutex_unlock(&dpll_device_xa_lock);
>+}
>+EXPORT_SYMBOL_GPL(dpll_device_unregister);
>+
>+static int __init dpll_init(void)
>+{
>+	int ret;
>+
>+	ret =3D dpll_netlink_init();
>+	if (ret)
>+		goto error;
>+
>+	ret =3D class_register(&dpll_class);
>+	if (ret)
>+		goto unregister_netlink;
>+
>+	return 0;
>+
>+unregister_netlink:
>+	dpll_netlink_finish();
>+error:
>+	mutex_destroy(&dpll_device_xa_lock);
>+	return ret;
>+}
>+subsys_initcall(dpll_init);
>diff --git a/drivers/dpll/dpll_core.h b/drivers/dpll/dpll_core.h
>new file mode 100644
>index 000000000000..5ad3224d5caf
>--- /dev/null
>+++ b/drivers/dpll/dpll_core.h
>@@ -0,0 +1,40 @@
>+/* SPDX-License-Identifier: GPL-2.0 */
>+/*
>+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>+ */
>+
>+#ifndef __DPLL_CORE_H__
>+#define __DPLL_CORE_H__
>+
>+#include <linux/dpll.h>
>+
>+#include "dpll_netlink.h"
>+
>+/**
>+ * struct dpll_device - structure for a DPLL device
>+ * @id:		unique id number for each edvice
>+ * @dev:	&struct device for this dpll device
>+ * @sources_count:	amount of input sources this dpll_device supports
>+ * @outputs_count:	amount of outputs this dpll_device supports
>+ * @ops:	operations this &dpll_device supports
>+ * @lock:	mutex to serialize operations
>+ * @priv:	pointer to private information of owner
>+ */
>+struct dpll_device {
>+	int id;
>+	struct device dev;
>+	int sources_count;
>+	int outputs_count;
>+	struct dpll_device_ops *ops;
>+	struct mutex lock;
>+	void *priv;
>+};
>+
>+#define to_dpll_device(_dev) \
>+	container_of(_dev, struct dpll_device, dev)
>+
>+int for_each_dpll_device(int id, int (*cb)(struct dpll_device *, void *),
>+			  void *data);
>+struct dpll_device *dpll_device_get_by_id(int id);
>+void dpll_device_unregister(struct dpll_device *dpll);
>+#endif
>diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
>new file mode 100644
>index 000000000000..e15106f30377
>--- /dev/null
>+++ b/drivers/dpll/dpll_netlink.c
>@@ -0,0 +1,454 @@
>+// SPDX-License-Identifier: GPL-2.0
>+/*
>+ * Generic netlink for DPLL management framework
>+ *
>+ * Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>+ *
>+ */
>+#include <linux/module.h>
>+#include <linux/kernel.h>
>+#include <net/genetlink.h>
>+#include "dpll_core.h"
>+
>+#include <uapi/linux/dpll.h>
>+
>+static const struct genl_multicast_group dpll_genl_mcgrps[] =3D {
>+	{ .name =3D DPLL_CONFIG_DEVICE_GROUP_NAME, },
>+	{ .name =3D DPLL_CONFIG_SOURCE_GROUP_NAME, },
>+	{ .name =3D DPLL_CONFIG_OUTPUT_GROUP_NAME, },
>+	{ .name =3D DPLL_MONITOR_GROUP_NAME,  },
>+};
>+
>+static const struct nla_policy dpll_genl_get_policy[] =3D {
>+	[DPLLA_DEVICE_ID]	=3D { .type =3D NLA_U32 },
>+	[DPLLA_DEVICE_NAME]	=3D { .type =3D NLA_STRING,
>+				    .len =3D DPLL_NAME_LENGTH },
>+	[DPLLA_FLAGS]		=3D { .type =3D NLA_U32 },
>+};
>+
>+static const struct nla_policy dpll_genl_set_source_policy[] =3D {
>+	[DPLLA_DEVICE_ID]	=3D { .type =3D NLA_U32 },
>+	[DPLLA_SOURCE_ID]	=3D { .type =3D NLA_U32 },
>+	[DPLLA_SOURCE_TYPE]	=3D { .type =3D NLA_U32 },
>+};
>+
>+static const struct nla_policy dpll_genl_set_output_policy[] =3D {
>+	[DPLLA_DEVICE_ID]	=3D { .type =3D NLA_U32 },
>+	[DPLLA_OUTPUT_ID]	=3D { .type =3D NLA_U32 },
>+	[DPLLA_OUTPUT_TYPE]	=3D { .type =3D NLA_U32 },
>+};
>+
>+struct param {
>+	struct netlink_callback *cb;
>+	struct dpll_device *dpll;
>+	struct nlattr **attrs;
>+	struct sk_buff *msg;
>+	int dpll_id;
>+	int dpll_source_id;
>+	int dpll_source_type;
>+	int dpll_output_id;
>+	int dpll_output_type;
>+};
>+
>+struct dpll_dump_ctx {
>+	struct dpll_device *dev;
>+	int flags;
>+	int pos_idx;
>+	int pos_src_idx;
>+	int pos_out_idx;
>+};
>+
>+typedef int (*cb_t)(struct param *);
>+
>+static struct genl_family dpll_gnl_family;
>+
>+static struct dpll_dump_ctx *dpll_dump_context(struct netlink_callback *c=
b)
>+{
>+	return (struct dpll_dump_ctx *)cb->ctx;
>+}
>+
>+static int __dpll_cmd_device_dump_one(struct dpll_device *dpll,
>+					   struct sk_buff *msg)
>+{
>+	if (nla_put_u32(msg, DPLLA_DEVICE_ID, dpll->id))
>+		return -EMSGSIZE;
>+
>+	if (nla_put_string(msg, DPLLA_DEVICE_NAME, dev_name(&dpll->dev)))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int __dpll_cmd_dump_sources(struct dpll_device *dpll,
>+					   struct sk_buff *msg)
>+{
>+	struct nlattr *src_attr;
>+	int i, ret =3D 0, type;
>+
>+	for (i =3D 0; i < dpll->sources_count; i++) {
>+		src_attr =3D nla_nest_start(msg, DPLLA_SOURCE);
>+		if (!src_attr) {
>+			ret =3D -EMSGSIZE;
>+			break;
>+		}
>+		type =3D dpll->ops->get_source_type(dpll, i);
>+		if (nla_put_u32(msg, DPLLA_SOURCE_ID, i) ||
>+		    nla_put_u32(msg, DPLLA_SOURCE_TYPE, type)) {
>+			nla_nest_cancel(msg, src_attr);
>+			ret =3D -EMSGSIZE;
>+			break;
>+		}
>+		if (dpll->ops->get_source_supported) {
>+			for (type =3D 0; type <=3D DPLL_TYPE_MAX; type++) {
>+				ret =3D dpll->ops->get_source_supported(dpll, i, type);
>+				if (ret && nla_put_u32(msg, DPLLA_SOURCE_SUPPORTED, type)) {
>+					ret =3D -EMSGSIZE;
>+					break;
>+				}
>+			}
>+			ret =3D 0;
>+		}
>+		nla_nest_end(msg, src_attr);
>+	}
>+
>+	return ret;
>+}
>+
>+static int __dpll_cmd_dump_outputs(struct dpll_device *dpll,
>+					   struct sk_buff *msg)
>+{
>+	struct nlattr *out_attr;
>+	int i, ret =3D 0, type;
>+
>+	for (i =3D 0; i < dpll->outputs_count; i++) {
>+		out_attr =3D nla_nest_start(msg, DPLLA_OUTPUT);
>+		if (!out_attr) {
>+			ret =3D -EMSGSIZE;
>+			break;
>+		}
>+		type =3D dpll->ops->get_output_type(dpll, i);
>+		if (nla_put_u32(msg, DPLLA_OUTPUT_ID, i) ||
>+		    nla_put_u32(msg, DPLLA_OUTPUT_TYPE, type)) {
>+			nla_nest_cancel(msg, out_attr);
>+			ret =3D -EMSGSIZE;
>+			break;
>+		}
>+		if (dpll->ops->get_output_supported) {
>+			for (type =3D 0; type <=3D DPLL_TYPE_MAX; type++) {
>+				ret =3D dpll->ops->get_output_supported(dpll, i, type);
>+				if (ret && nla_put_u32(msg, DPLLA_OUTPUT_SUPPORTED, type)) {
>+					ret =3D -EMSGSIZE;
>+					break;
>+				}
>+			}
>+			ret =3D 0;
>+		}
>+		nla_nest_end(msg, out_attr);
>+	}
>+
>+	return ret;
>+}
>+
>+static int __dpll_cmd_dump_status(struct dpll_device *dpll,
>+					   struct sk_buff *msg)
>+{
>+	int ret;
>+
>+	if (dpll->ops->get_status) {
>+		ret =3D dpll->ops->get_status(dpll);
>+		if (nla_put_u32(msg, DPLLA_STATUS, ret))
>+			return -EMSGSIZE;
>+	}
>+
>+	if (dpll->ops->get_temp) {
>+		ret =3D dpll->ops->get_temp(dpll);
>+		if (nla_put_u32(msg, DPLLA_TEMP, ret))
>+			return -EMSGSIZE;
>+	}
>+
>+	if (dpll->ops->get_lock_status) {
>+		ret =3D dpll->ops->get_lock_status(dpll);

We shall have defined lock states, same for get status, as int is returned
by both, the userspace must have common understanding of values returned by
those functions.

>+		if (nla_put_u32(msg, DPLLA_LOCK_STATUS, ret))
>+			return -EMSGSIZE;
>+	}
>+
>+	return 0;
>+}
>+
>+static int dpll_device_dump_one(struct dpll_device *dpll, struct sk_buff =
*msg, int flags)
>+{
>+	struct nlattr *hdr;
>+	int ret;
>+
>+	hdr =3D nla_nest_start(msg, DPLLA_DEVICE);
>+	if (!hdr)
>+		return -EMSGSIZE;
>+
>+	mutex_lock(&dpll->lock);
>+	ret =3D __dpll_cmd_device_dump_one(dpll, msg);
>+	if (ret)
>+		goto out_cancel_nest;
>+
>+	if (flags & DPLL_FLAG_SOURCES && dpll->ops->get_source_type) {
>+		ret =3D __dpll_cmd_dump_sources(dpll, msg);
>+		if (ret)
>+			goto out_cancel_nest;
>+	}
>+
>+	if (flags & DPLL_FLAG_OUTPUTS && dpll->ops->get_output_type) {
>+		ret =3D __dpll_cmd_dump_outputs(dpll, msg);
>+		if (ret)
>+			goto out_cancel_nest;
>+	}
>+
>+	if (flags & DPLL_FLAG_STATUS) {
>+		ret =3D __dpll_cmd_dump_status(dpll, msg);
>+		if (ret)
>+			goto out_cancel_nest;
>+	}
>+
>+	mutex_unlock(&dpll->lock);
>+	nla_nest_end(msg, hdr);
>+
>+	return 0;
>+
>+out_cancel_nest:
>+	mutex_unlock(&dpll->lock);
>+	nla_nest_cancel(msg, hdr);
>+
>+	return ret;
>+}
>+
>+static int dpll_genl_cmd_set_source(struct param *p)
>+{
>+	const struct genl_dumpit_info *info =3D genl_dumpit_info(p->cb);
>+	struct dpll_device *dpll =3D p->dpll;
>+	int ret =3D 0, src_id, type;
>+
>+	if (!info->attrs[DPLLA_SOURCE_ID] ||
>+	    !info->attrs[DPLLA_SOURCE_TYPE])

Got a crash here (when tried to send a message without DPLLA_SOURCE_TYPE)

>+		return -EINVAL;
>+
>+	if (!dpll->ops->set_source_type)
>+		return -EOPNOTSUPP;
>+
>+	src_id =3D nla_get_u32(info->attrs[DPLLA_SOURCE_ID]);
>+	type =3D nla_get_u32(info->attrs[DPLLA_SOURCE_TYPE]);
>+
>+	mutex_lock(&dpll->lock);
>+	ret =3D dpll->ops->set_source_type(dpll, src_id, type);
>+	mutex_unlock(&dpll->lock);
>+
>+	return ret;
>+}
>+
>+static int dpll_genl_cmd_set_output(struct param *p)
>+{
>+	const struct genl_dumpit_info *info =3D genl_dumpit_info(p->cb);
>+	struct dpll_device *dpll =3D p->dpll;
>+	int ret =3D 0, out_id, type;
>+
>+	if (!info->attrs[DPLLA_OUTPUT_ID] ||
>+	    !info->attrs[DPLLA_OUTPUT_TYPE])
>+		return -EINVAL;
>+
>+	if (!dpll->ops->set_output_type)
>+		return -EOPNOTSUPP;
>+
>+	out_id =3D nla_get_u32(info->attrs[DPLLA_OUTPUT_ID]);
>+	type =3D nla_get_u32(info->attrs[DPLLA_OUTPUT_TYPE]);
>+
>+	mutex_lock(&dpll->lock);
>+	ret =3D dpll->ops->set_source_type(dpll, out_id, type);
>+	mutex_unlock(&dpll->lock);
>+
>+	return ret;
>+}
>+
>+static int dpll_device_loop_cb(struct dpll_device *dpll, void *data)
>+{
>+	struct dpll_dump_ctx *ctx;
>+	struct param *p =3D (struct param *)data;
>+
>+	ctx =3D dpll_dump_context(p->cb);
>+
>+	ctx->pos_idx =3D dpll->id;
>+
>+	return dpll_device_dump_one(dpll, p->msg, ctx->flags);
>+}
>+
>+static int dpll_cmd_device_dump(struct param *p)
>+{
>+	struct dpll_dump_ctx *ctx =3D dpll_dump_context(p->cb);
>+
>+	return for_each_dpll_device(ctx->pos_idx, dpll_device_loop_cb, p);
>+}
>+
>+static int dpll_genl_cmd_device_get_id(struct param *p)
>+{
>+	struct dpll_device *dpll =3D p->dpll;
>+	int flags =3D 0;
>+
>+	if (p->attrs[DPLLA_FLAGS])
>+		flags =3D nla_get_u32(p->attrs[DPLLA_FLAGS]);
>+
>+	return dpll_device_dump_one(dpll, p->msg, flags);
>+}
>+
>+static cb_t cmd_doit_cb[] =3D {
>+	[DPLL_CMD_DEVICE_GET]		=3D dpll_genl_cmd_device_get_id,
>+	[DPLL_CMD_SET_SOURCE_TYPE]	=3D dpll_genl_cmd_set_source,
>+	[DPLL_CMD_SET_OUTPUT_TYPE]	=3D dpll_genl_cmd_set_output,
>+};
>+
>+static cb_t cmd_dump_cb[] =3D {
>+	[DPLL_CMD_DEVICE_GET]		=3D dpll_cmd_device_dump,
>+};
>+
>+static int dpll_genl_cmd_start(struct netlink_callback *cb)
>+{
>+	const struct genl_dumpit_info *info =3D genl_dumpit_info(cb);
>+	struct dpll_dump_ctx *ctx =3D dpll_dump_context(cb);
>+
>+	ctx->dev =3D NULL;
>+	if (info->attrs[DPLLA_FLAGS])
>+		ctx->flags =3D nla_get_u32(info->attrs[DPLLA_FLAGS]);
>+	else
>+		ctx->flags =3D 0;
>+	ctx->pos_idx =3D 0;
>+	ctx->pos_src_idx =3D 0;
>+	ctx->pos_out_idx =3D 0;
>+	return 0;
>+}
>+
>+static int dpll_genl_cmd_dumpit(struct sk_buff *skb,
>+				   struct netlink_callback *cb)
>+{
>+	struct param p =3D { .cb =3D cb, .msg =3D skb };
>+	const struct genl_dumpit_info *info =3D genl_dumpit_info(cb);
>+	int cmd =3D info->op.cmd;
>+	int ret;
>+	void *hdr;
>+
>+	hdr =3D genlmsg_put(skb, 0, 0, &dpll_gnl_family, 0, cmd);
>+	if (!hdr)
>+		return -EMSGSIZE;
>+
>+	ret =3D cmd_dump_cb[cmd](&p);
>+	if (ret)
>+		goto out_cancel_msg;
>+
>+	genlmsg_end(skb, hdr);
>+
>+	return 0;
>+
>+out_cancel_msg:
>+	genlmsg_cancel(skb, hdr);
>+
>+	return ret;
>+}
>+
>+static int dpll_genl_cmd_doit(struct sk_buff *skb,
>+				 struct genl_info *info)
>+{
>+	struct param p =3D { .attrs =3D info->attrs, .dpll =3D info->user_ptr[0]=
 };
>+	int cmd =3D info->genlhdr->cmd;
>+	struct sk_buff *msg;
>+	void *hdr;
>+	int ret;
>+
>+	msg =3D genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>+	if (!msg)
>+		return -ENOMEM;
>+	p.msg =3D msg;
>+
>+	hdr =3D genlmsg_put_reply(msg, info, &dpll_gnl_family, 0, cmd);
>+	if (!hdr) {
>+		ret =3D -EMSGSIZE;
>+		goto out_free_msg;
>+	}
>+
>+	ret =3D cmd_doit_cb[cmd](&p);
>+	if (ret)
>+		goto out_cancel_msg;
>+
>+	genlmsg_end(msg, hdr);
>+
>+	return genlmsg_reply(msg, info);
>+
>+out_cancel_msg:
>+	genlmsg_cancel(msg, hdr);
>+out_free_msg:
>+	nlmsg_free(msg);
>+
>+	return ret;
>+}
>+
>+static int dpll_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
>+						 struct genl_info *info)
>+{
>+	struct dpll_device *dpll;
>+	int id;
>+
>+	if (!info->attrs[DPLLA_DEVICE_ID])
>+		return -EINVAL;
>+	id =3D nla_get_u32(info->attrs[DPLLA_DEVICE_ID]);
>+
>+	dpll =3D dpll_device_get_by_id(id);
>+	if (!dpll)
>+		return -ENODEV;
>+	info->user_ptr[0] =3D dpll;
>+
>+	return 0;
>+}
>+
>+static const struct genl_ops dpll_genl_ops[] =3D {
>+	{
>+		.cmd	=3D DPLL_CMD_DEVICE_GET,
>+		.start	=3D dpll_genl_cmd_start,
>+		.dumpit	=3D dpll_genl_cmd_dumpit,
>+		.doit	=3D dpll_genl_cmd_doit,
>+		.policy	=3D dpll_genl_get_policy,
>+		.maxattr =3D ARRAY_SIZE(dpll_genl_get_policy) - 1,
>+	},

I wouldn't leave non-privileged user with possibility to call any HW reques=
ts.

>+	{
>+		.cmd	=3D DPLL_CMD_SET_SOURCE_TYPE,
>+		.flags	=3D GENL_UNS_ADMIN_PERM,
>+		.doit	=3D dpll_genl_cmd_doit,
>+		.policy	=3D dpll_genl_set_source_policy,
>+		.maxattr =3D ARRAY_SIZE(dpll_genl_set_source_policy) - 1,
>+	},
>+	{
>+		.cmd	=3D DPLL_CMD_SET_OUTPUT_TYPE,
>+		.flags	=3D GENL_UNS_ADMIN_PERM,
>+		.doit	=3D dpll_genl_cmd_doit,
>+		.policy	=3D dpll_genl_set_output_policy,
>+		.maxattr =3D ARRAY_SIZE(dpll_genl_set_output_policy) - 1,
>+	},
>+};
>+
>+static struct genl_family dpll_gnl_family __ro_after_init =3D {
>+	.hdrsize	=3D 0,
>+	.name		=3D DPLL_FAMILY_NAME,
>+	.version	=3D DPLL_VERSION,
>+	.ops		=3D dpll_genl_ops,
>+	.n_ops		=3D ARRAY_SIZE(dpll_genl_ops),
>+	.mcgrps		=3D dpll_genl_mcgrps,
>+	.n_mcgrps	=3D ARRAY_SIZE(dpll_genl_mcgrps),
>+	.pre_doit	=3D dpll_pre_doit,
>+};
>+
>+int __init dpll_netlink_init(void)
>+{
>+	return genl_register_family(&dpll_gnl_family);
>+}
>+
>+void dpll_netlink_finish(void)
>+{
>+	genl_unregister_family(&dpll_gnl_family);
>+}
>+
>+void __exit dpll_netlink_fini(void)
>+{
>+	dpll_netlink_finish();
>+}
>diff --git a/drivers/dpll/dpll_netlink.h b/drivers/dpll/dpll_netlink.h
>new file mode 100644
>index 000000000000..e2d100f59dd6
>--- /dev/null
>+++ b/drivers/dpll/dpll_netlink.h
>@@ -0,0 +1,7 @@
>+/* SPDX-License-Identifier: GPL-2.0 */
>+/*
>+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>+ */
>+
>+int __init dpll_netlink_init(void);
>+void dpll_netlink_finish(void);
>diff --git a/include/linux/dpll.h b/include/linux/dpll.h
>new file mode 100644
>index 000000000000..4ebda933d5f6
>--- /dev/null
>+++ b/include/linux/dpll.h
>@@ -0,0 +1,29 @@
>+/* SPDX-License-Identifier: GPL-2.0 */
>+/*
>+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>+ */
>+
>+#ifndef __DPLL_H__
>+#define __DPLL_H__
>+
>+struct dpll_device;
>+
>+struct dpll_device_ops {
>+	int (*get_status)(struct dpll_device *dpll);
>+	int (*get_temp)(struct dpll_device *dpll);
>+	int (*get_lock_status)(struct dpll_device *dpll);
>+	int (*get_source_type)(struct dpll_device *dpll, int id);
>+	int (*get_source_supported)(struct dpll_device *dpll, int id, int type);
>+	int (*get_output_type)(struct dpll_device *dpll, int id);
>+	int (*get_output_supported)(struct dpll_device *dpll, int id, int type);
>+	int (*set_source_type)(struct dpll_device *dpll, int id, int val);
>+	int (*set_output_type)(struct dpll_device *dpll, int id, int val);
>+};
>+
>+struct dpll_device *dpll_device_alloc(struct dpll_device_ops *ops, int so=
urces_count,
>+					 int outputs_count, void *priv);
>+void dpll_device_register(struct dpll_device *dpll);
>+void dpll_device_unregister(struct dpll_device *dpll);
>+void dpll_device_free(struct dpll_device *dpll);
>+void *dpll_priv(struct dpll_device *dpll);
>+#endif
>diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
>new file mode 100644
>index 000000000000..7ce45c6b4fd4
>--- /dev/null
>+++ b/include/uapi/linux/dpll.h
>@@ -0,0 +1,79 @@
>+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>+#ifndef _UAPI_LINUX_DPLL_H
>+#define _UAPI_LINUX_DPLL_H
>+
>+#define DPLL_NAME_LENGTH	20
>+
>+/* Adding event notification support elements */
>+#define DPLL_FAMILY_NAME		"dpll"
>+#define DPLL_VERSION			0x01
>+#define DPLL_CONFIG_DEVICE_GROUP_NAME  "config"
>+#define DPLL_CONFIG_SOURCE_GROUP_NAME  "source"
>+#define DPLL_CONFIG_OUTPUT_GROUP_NAME  "output"
>+#define DPLL_MONITOR_GROUP_NAME        "monitor"
>+
>+#define DPLL_FLAG_SOURCES	1
>+#define DPLL_FLAG_OUTPUTS	2
>+#define DPLL_FLAG_STATUS	4
>+
>+/* Attributes of dpll_genl_family */
>+enum dpll_genl_attr {
>+	DPLLA_UNSPEC,
>+	DPLLA_DEVICE,
>+	DPLLA_DEVICE_ID,
>+	DPLLA_DEVICE_NAME,
>+	DPLLA_SOURCE,
>+	DPLLA_SOURCE_ID,
>+	DPLLA_SOURCE_TYPE,
>+	DPLLA_SOURCE_SUPPORTED,
>+	DPLLA_OUTPUT,
>+	DPLLA_OUTPUT_ID,
>+	DPLLA_OUTPUT_TYPE,
>+	DPLLA_OUTPUT_SUPPORTED,
>+	DPLLA_STATUS,
>+	DPLLA_TEMP,
>+	DPLLA_LOCK_STATUS,
>+	DPLLA_FLAGS,
>+
>+	__DPLLA_MAX,
>+};
>+#define DPLLA_MAX (__DPLLA_MAX - 1)
>+
>+/* DPLL signal types used as source or as output */
>+enum dpll_genl_signal_type {
>+	DPLL_TYPE_EXT_1PPS,
>+	DPLL_TYPE_EXT_10MHZ,
>+	DPLL_TYPE_SYNCE_ETH_PORT,
>+	DPLL_TYPE_INT_OSCILLATOR,
>+	DPLL_TYPE_GNSS,
>+
>+	__DPLL_TYPE_MAX,
>+};
>+#define DPLL_TYPE_MAX (__DPLL_TYPE_MAX - 1)
>+
>+/* Events of dpll_genl_family */
>+enum dpll_genl_event {
>+	DPLL_EVENT_UNSPEC,
>+	DPLL_EVENT_DEVICE_CREATE,		/* DPLL device creation */
>+	DPLL_EVENT_DEVICE_DELETE,		/* DPLL device deletion */
>+	DPLL_EVENT_STATUS_LOCKED,		/* DPLL device locked to source */
>+	DPLL_EVENT_STATUS_UNLOCKED,	/* DPLL device freerun */
>+	DPLL_EVENT_SOURCE_CHANGE,		/* DPLL device source changed */
>+	DPLL_EVENT_OUTPUT_CHANGE,		/* DPLL device output changed */
>+
>+	__DPLL_EVENT_MAX,
>+};
>+#define DPLL_EVENT_MAX (__DPLL_EVENT_MAX - 1)
>+
>+/* Commands supported by the dpll_genl_family */
>+enum dpll_genl_cmd {
>+	DPLL_CMD_UNSPEC,
>+	DPLL_CMD_DEVICE_GET,	/* List of DPLL devices id */
>+	DPLL_CMD_SET_SOURCE_TYPE,	/* Set the DPLL device source type */
>+	DPLL_CMD_SET_OUTPUT_TYPE,	/* Set the DPLL device output type */

This week, I am going to prepare the patch for DPLL mode and input priority=
 list
we have discussed on the previous patch series.

Thank you!
Arkadiusz

>+
>+	__DPLL_CMD_MAX,
>+};
>+#define DPLL_CMD_MAX (__DPLL_CMD_MAX - 1)
>+
>+#endif /* _UAPI_LINUX_DPLL_H */
>--=20
>2.27.0
>
