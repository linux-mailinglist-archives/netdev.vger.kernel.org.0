Return-Path: <netdev+bounces-11326-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAB957329B8
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:25:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B87E52815E8
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2AFCBA58;
	Fri, 16 Jun 2023 08:25:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFA96117
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 08:25:54 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57902D65;
	Fri, 16 Jun 2023 01:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686903953; x=1718439953;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RaSUs4oYk/bHkwGsSDZA3v7gcVO38FpwLXwW8UzzU2Q=;
  b=GzuBDhmgXjCXrieVf0OgNzUXQhnMjQMe0g0BOi/pilWoBY8xeeReX9jL
   KsDr05fwLD9Ahrm5Fs8U8FHU/n79kESTnHqyw+Z1z1/Log/z6bi6/B4+4
   S6VgdcbW0BF3CJa0fJL+hJnfDVy5jrHytpFfneDCKcRtAqlwZ0bmaFSML
   jtiofDYFwmPeXI1ozbF5B02J/rN4n85e2FChxqAuQYsuEeUcKKX98Mzui
   ReF6Ud6J/3oBq1l6Qdqb9TQk3mgFdT/6ybmW7YaL0CKk5ywo/8QPNx5GJ
   926UPWyaARqKb7lfLYFTVDHD4tpScmmlNC2plsoqOwQnaHkj8O2YNyGSt
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="425098982"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="425098982"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 01:25:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="857298441"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="857298441"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 16 Jun 2023 01:25:50 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 01:25:50 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 16 Jun 2023 01:25:50 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 16 Jun 2023 01:25:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mf6xzVusBYvEzgVYAVaVdvoHSd6q7x9/Dst85fvPNS1kjiU/R956d5sX8eQ36efQDc9TqOIwtpoNJjykLRCWrHUIapRReTsZ8+yjY6IJmTAi97aF2Mq8ObHUpVjDw9uEKFUH2E2DJF8B+aTKudOaKOabMA8GvZ3GU4MGPRwjl9HqlPtAMa/TIZWHhuso/95AGvkrVD+f5iyM9zNkFoJqbpySdmfwmKqvaLdJSsQ5wdPdV0BxRtzImD7hn7XD6B4Db/EXcBbJ39bkTcSzwQc9epinmP/+qn7WUnxj+IrDJdjF8JJ13dMdzPlP8QSdT/IvGAl2jCVWl8Xm9IwTZcqhhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w46KFnVN2HJbDSR7JsqxP7QjbRivUOOgS3qleQkYvhc=;
 b=RKkA1iPiCn7n4dSNeND4d6R1mWMh8hrzyQ3cNklUpVtJO8aughHFVtoFCmloyVahQ6/XnJStCZJ4Nzmo3CBRkT1wxtQeBrvDevXrsGdjLJHN/7GwNPSXoIM4QWVLSSzGuiRCFWw5vhz0gTbAuu6RH56qyUFGO+7/ipPhN6AbWWTrAy4KcS9BxL6+gnz9MaTNRn14XWRLK4b4T2LgN/MV/BdBLZ9n5aJHwNABp2wERH+0UYypmKUuzVrvj/HiKOiP6p/sKgR71EldPxwPK3P+6AZzryHMiVip0pp4SN62ysCDH6xhVbkU2keaJYVFcqPcUi+cR28idjIsCKukuCrYBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ2PR11MB7545.namprd11.prod.outlook.com (2603:10b6:a03:4cc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.29; Fri, 16 Jun
 2023 08:25:48 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6500.026; Fri, 16 Jun 2023
 08:25:48 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Brett Creeley <brett.creeley@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>
CC: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v10 vfio 7/7] vfio/pds: Add Kconfig and documentation
Thread-Topic: [PATCH v10 vfio 7/7] vfio/pds: Add Kconfig and documentation
Thread-Index: AQHZlZ4hwSG0ERGfXEmCzdx3bMiWvK+NLKzQ
Date: Fri, 16 Jun 2023 08:25:47 +0000
Message-ID: <BN9PR11MB5276C91E587D0DE40883DD5D8C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-8-brett.creeley@amd.com>
In-Reply-To: <20230602220318.15323-8-brett.creeley@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ2PR11MB7545:EE_
x-ms-office365-filtering-correlation-id: 6e1ad0f4-ff06-4ae2-8fdc-08db6e43499d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4X/gHAExLiXMCEI4VupXK3UTk7VRuoD4GL2KufJlonh8h071qqbZIHVst3Y5U5izPkHNSkxsZptyZkaKPP6PSHTP98FtqRWd7YphHQzmIHfyolNhwkGu1cBxh603AN9iWa9yHfGZgvpOVkd/5r/eWpjx4wp0lh8hw5wYPvAh6qfAL/38t6s/7bVq+pP6SCcHYUoTuzBDJLabYzTZgeGVnGJ3ziir1IzXf9KW7Z73JdupX5BHWj0W0wXHrL56kwtFGSEiOM1WR6qdX3NcWcyMe8AZ5JLWso1YosyMJAWQ96EWcDVOkHPaEBAosHPWyQirLroBWZ/ZtRmnRH5saP0/YVwKzZGOlxfsafsx41zkJ+vBLvY+RkLS2KkRZ0MYExoLtCo9Gl5B3WMMZrXcMvD/EtuzYocZtFF549dT4U/FxL0B3NHug/iOJMqSlsAUOxwELdoJXV/HNuQ9CSZQBofWFThXlh09dixPsVpq1hmCyI4kimja8gtCRy8PspfdevH5zYpTtfvunl2ykJ/GaJHwCBkTWTxJW/lvsr0UWKYV//TFbnXy/ygSULsDW/FxIGkf9y2fZAKNB+09Ju3kVvYTlQlO9RyMkKaIkADOUwOIBaVlVsoJtVNU2ybORFLoLn+f
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(136003)(396003)(376002)(346002)(451199021)(4744005)(2906002)(38070700005)(122000001)(82960400001)(38100700002)(55016003)(41300700001)(316002)(7696005)(64756008)(66446008)(66476007)(66556008)(71200400001)(4326008)(52536014)(86362001)(5660300002)(8936002)(8676002)(110136005)(33656002)(478600001)(66946007)(76116006)(9686003)(6506007)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?I4NexdtpiHNGiqhHnvjG9xfSx2COg5n2vXJ5It75QpgwWDxcfZU1HgqMEK4N?=
 =?us-ascii?Q?O4mKQuxxE5+hCk2MNErHwSiYmJmM4YKvLQtQ5UWH9D3c0IGOO3AP9Wf604kn?=
 =?us-ascii?Q?XXT9wOH4zfwhqvqik80hVMLiRRkHKTOtobuNrklXZfHO5q+J8MARGhI8vwXN?=
 =?us-ascii?Q?LL2CmPCp4kjufg3Zny/2F2nWnQfVgPH6IGrpUm/5bnnc1QkQpnrsE5iSG6/q?=
 =?us-ascii?Q?cKEJCX+r2m/V6AVjsXeKCqWb3bS8wrlxm6/ebMA8bkWfV3zP3UAf6kecK+jC?=
 =?us-ascii?Q?y603ZmrwSKfmkuxMnudbmuQth3UUriZV9n/FSriVVOGgbcMyjPQ7fvvn+PvA?=
 =?us-ascii?Q?744zXlzwSci2mLFPGHnfhzaxMZygCCMmbk+JD6QlDdMJXy3MqwFz4nMMp+NL?=
 =?us-ascii?Q?86383Ml5zuoxx0dFTiSLMbaeHJOit2yIoQN2nCugVBtzn/un6DD6EcO25FsR?=
 =?us-ascii?Q?pAlRK6HpAaIyMx0TIeV+z+NuqVMdtIA1AdcEp7r+inPEXYuUjbG8HJgqAgNK?=
 =?us-ascii?Q?kX8OEFPuJCOGXP10pI0N04ZnO3vuI2vdUg1hyabE76Cf7Ap3amdO42rTdMgp?=
 =?us-ascii?Q?sFbXxqyc58yj2fZiG2y5non6yGetFZolPcnUhMBMamGBjc1NCUo35erlbxT6?=
 =?us-ascii?Q?1V8bl0GFppseffgM3qEA5mC0Dh3/0YhGWkwrM37XL0DIO/GGlt2WAAD55ioQ?=
 =?us-ascii?Q?ul2JPEuQmQUad8/S+8ia1S9HdfitOc2oAoCfqmflJjfv1NEAOXCKH5VzFqTd?=
 =?us-ascii?Q?XPz74JBzq8O+LWGLwwlhB7ADsLrXvEEJjVx4KWaVWJ+QJEv0zGmvZ1AlNm7V?=
 =?us-ascii?Q?aD2BhrPrDRkdD86hoIhGAA4wjY+jTJ6Ur+YO8WX0x4eB1BObUQjb2jx1x5E6?=
 =?us-ascii?Q?BejC5XwLi7ufJA4UMPxLPQKafdqlH2tMkbxPJmfE7oB0l/qavMgouUIxSXGa?=
 =?us-ascii?Q?tW2WN+cHrjlM+uNPaG0EpSl2QzaIvJF9pXMt290KpYKENmLFHJNOwiBxS66g?=
 =?us-ascii?Q?niUpA2gU2Zh1ZEYRwyIBrrYkVgn/q4iqLQb00PaPI6xFkvjRJj4YeKIMr6YK?=
 =?us-ascii?Q?IIRo5Ljv8uqNzY5r2MxpvKuSS4MLPHBTaHRliHXYXigdctzfI8pkOBANvFby?=
 =?us-ascii?Q?Ymnkdg7G293o39Ol6WSx6NHMaQ5u5WGFXMzzkv2LO/WUFzMYE3kA5sr+5zyJ?=
 =?us-ascii?Q?9NCmmj1M9cZAzvwzcdtDo3MO5Y2yRQq8zBmft5QESwNeO4Kn1j1u+R4w7iGO?=
 =?us-ascii?Q?8rP/WupGawr/yamF7uzKB3HFIHUU/V4vByaTYcs5mealKOukGjGidYQkF6c5?=
 =?us-ascii?Q?8JC0iFeTiFR43H4VcHWsIec7eF2uYsYfYce+gLpdmcNN6TQfnR3JlIZ8CegS?=
 =?us-ascii?Q?XTAeb/DT/Yvx5NLRgz5ihfCrwvxDK+D/OXcjW41hSdOt25aafv2Ft1+SWjcn?=
 =?us-ascii?Q?IvbkAY6LIb2ikFvDl+lkuw9tLn0jyZb6CTFUuCv0/yv+PaF16Tult1uxcLO+?=
 =?us-ascii?Q?hPalv96YxMNnCptl0AI6ALWY6+eTaaU1qFU3+gvss8BuGYv4XgHBVDzfPSFu?=
 =?us-ascii?Q?IvrxB3BIf6pbJEdvPr88s4ZMzoyuEQGT3mKqetAZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e1ad0f4-ff06-4ae2-8fdc-08db6e43499d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 08:25:47.9772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cy5KLH95mxmHyHATWXlxCvOD03ZKwDT5R3NcUv8XA2jXwPf4iZtXaKxsVBl1jD87e/c52TDF1gX9z/6E5qkm4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7545
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> From: Brett Creeley <brett.creeley@amd.com>
> Sent: Saturday, June 3, 2023 6:03 AM
> +
> +  # Prevent non-vfio VF driver from probing the VF device
> +  echo 0 >
> /sys/class/pci_bus/$PF_BUS/device/$PF_BDF/sriov_drivers_autoprobe
> +
> +  # Create single VF for Live Migration via VFIO
> +  echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs

s/via VFIO/via pds_core/

> +
> +config PDS_VFIO_PCI
> +	tristate "VFIO support for PDS PCI devices"
> +	depends on PDS_CORE
> +	depends on VFIO_PCI_CORE

this should be rebased on Alex's Kconfig change.

