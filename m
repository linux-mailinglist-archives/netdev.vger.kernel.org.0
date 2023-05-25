Return-Path: <netdev+bounces-5331-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49ED9710CF5
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:05:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5C081C20E9D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 13:05:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41FC8101EC;
	Thu, 25 May 2023 13:05:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD09101D6
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 13:05:14 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39104E4E;
	Thu, 25 May 2023 06:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685019889; x=1716555889;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3dF9cgxshhiGe3wyUCmyP/HJC6pozdDirO4mfysXwgk=;
  b=AtPNVw4Oxmp/kx7Ll3i4P2dGtkQcUEf6oHVaqFzPPK6r6qBG+ysDmkbd
   t5NBLexfkB4eS/s55IzCx945GZp+CT5wMUrQ3xiQzbEAGeu2Rq7Ah+yN/
   /YxCwIn8/p+LKdORUrwYavVDHuu0aVi3J7r1n7Gr9lZ3KDkcZpXoPzsw+
   YceHMUrHL17NfZSF10bc3RKui1BzKxd3iFXQ+B8h9g34+oZbxWLQcdk+X
   MEegggYOViwymQQyELFP4wW5ay+jgiqPoD8bkPV7uQs4VWT0hHdwqSmzE
   t/8cFXYIIRMFXkn/hoxysnjW8gklO4aURt1CIAxI8JVb9SKIlJ2aOrXan
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="382124241"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="382124241"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 06:01:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="655192604"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="655192604"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 25 May 2023 06:01:38 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 06:01:37 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 06:01:37 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 25 May 2023 06:01:37 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 25 May 2023 06:01:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kfgGusn4SyIYHJcq+yhs3k/suQm+vpM7thspEiGuTXKJFar2FWPxKZIWsGDrD5G5Y0VF4RwDdfJZsvjmMQtoanT2ansS02PJOUEtXNYuxFHv43hFkkkpxtncPmOGGzpdSqpb6vqPBY7mh+PXmSuvu/FGcxisRkrqH9M3soPyNYsr6YL+7jhfgu9d56ZKI0HPBDRBzLgk2Gt7/ttH5ucKrlMn03BVgQN4OFeVYc5z/YtTh1eemPkfML4iWaLMzmpSKgUH+56HaENNfv2S9a68//Ow8YQfa0TASyegKT5iXerA+taB/aJB6y5olEayar2Yy9UAVYnybekYqOGNSo/hww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uEnTCkLiPye3YcxMBfe/9vQ7eHwpCD7iIKxQcxLiykw=;
 b=VegO4QPnKMifk9rDZQLLUDnge3txXZmxlLtFUVVCBi7l5RGPF3/zGNf+XVPiC81h/QRD+iM/80ELB/y7NSo4ac3Sa4tN+JVXx77yTiafhhvbQ/rk5ix48XmQIqq27c3NNAafSbQ984/6vpMI5HU7UPwPpB2CTiVW12yT/UQD52hGG48vj5JV4AzYxxl1EHy2fufozTAW2EV9CgyJW1GrSXwJ5G9kypiUISGn4lkVfPUS5+iIgKpRNW7pBw1UIoZErdAnDpCb4GfKmc4Qf2oWMyB9S0XET7kVejSNuJ5Y+HF4o8rcduJeEqbi7vU3e+NGo3p4x4s6wrf0Xdwy/eJ30g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14; Thu, 25 May
 2023 13:01:35 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e%6]) with mapi id 15.20.6433.015; Thu, 25 May 2023
 13:01:34 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>, Vadim Fedorenko <vadfed@meta.com>
CC: Jakub Kicinski <kuba@kernel.org>, Jonathan Lemon
	<jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>, "Olech, Milena"
	<milena.olech@intel.com>, "Michalik, Michal" <michal.michalik@intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v7 0/8] Create common DPLL configuration API
Thread-Topic: [RFC PATCH v7 0/8] Create common DPLL configuration API
Thread-Index: AQHZeWdMwpT4Id4KhEupVVmmO03v069UyFGAgBZVn+A=
Date: Thu, 25 May 2023 13:01:34 +0000
Message-ID: <DM6PR11MB4657CF4CF688D0542A00F6AD9B469@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <ZFyeydHS6iTECqiA@nanopsycho>
In-Reply-To: <ZFyeydHS6iTECqiA@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|SA2PR11MB5100:EE_
x-ms-office365-filtering-correlation-id: 6625ea8f-8fda-4828-5fe1-08db5d202b38
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0ixXlExd/hr64J1B5Bb1a2Vy+wkXt3IThWW/HwULXeJPBtcGenQWKhMgoU7DUaQNhyb5Jb4JlnALF8E2Zxj4tIuL95MZrebBBFFP2pPHFSwQ7Mw1v7FOSW/ngq2/LfKOM4ie46T41ZWqE6po0PNtnl3jZCl7ledocTQhLqZZY/Yx+tAikCgV/7GmXInojeVUr5BTspOrUk0I4dylxhtmpONJ/y+Ppf7nVYWpykbGK/WEA2PtUzRH6XcQePF9cWVTgMDLItdtJdDq+s3aHCfz0FDqqPIcF1ZLCdKN9yMQSG09fQ3Kz3drOAQ61r0Npj7X/3K/BbYMP//s4eM6MQTxRL/oDthaWrRdzw59DqwrlmZLXlzpzoqB3zUIdGtD5VpYAoR4C7ZFRt+cUeDCnNerD+o8t6+9IjDC4HjFY/IURBRdw5j2LaQUF4Qm5dizwDbyzwUxpik1QRJdu57rpjdWaPeAEbJnaMfmO/KWMUc3E4CNzPMs8DD01KmCoMVG1ImkJ9guEwaiE9H/Pj1WQX5QXMsPgFbA249LhAiSR4tZyRwe5HT0zLL/Z3tb1G3Rv8V1IEGlzWXIJzWm6YZvNQl5tmZl4leBPwTfPhBoNZY0f6vnQpRJBwVFEdid9UwoUJZR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(122000001)(6506007)(38100700002)(186003)(9686003)(83380400001)(7696005)(26005)(71200400001)(54906003)(110136005)(82960400001)(478600001)(8936002)(52536014)(7416002)(4326008)(76116006)(66446008)(66946007)(66556008)(66476007)(64756008)(5660300002)(33656002)(2906002)(41300700001)(38070700005)(316002)(86362001)(8676002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KUnomMKyjmvNvdcmo4UBb4VQKOZeVPLO7lOfJ6Jk3MtikVjPKvlekNUrc67R?=
 =?us-ascii?Q?mpxC4nDLNuKyORt3wOdMhn5QfX9ryR4nE9A7x72oaVFigw7GC2446jsMPlO1?=
 =?us-ascii?Q?g09NxIPP/29gvvR0OD41JSTuFINt5UPCpGtws8Ti7QBl0+aK+0bBKcut0Q7W?=
 =?us-ascii?Q?8bxNE60FE9A1HOiMaxB2b7OX6sf0EMbiqL5KdDLmQYKPJ1JrW6OXyxdU3h6O?=
 =?us-ascii?Q?uPYiv94iZAsY67encq8GboL841XIjU8JDNd1xBHUR8z0dYFiXsn5J4vRCSC8?=
 =?us-ascii?Q?9V64SuI0hLh5J5bU89/3By9e9QlvrUsk36PxLtKSjo/JEUcV3DUhdwj0f45r?=
 =?us-ascii?Q?Yh/W1CbybfIRjp7bX+xRepvrg9siGxIhvaIrwq+ZZRjIc4YtSPTvRe+Fee5a?=
 =?us-ascii?Q?Bl3AVUMlI1/R7mt2mEkJCkGmAzLyDrW8e9VzyCXKBJmcrFg+DNDoNGpuSHJI?=
 =?us-ascii?Q?h5A0mkSrVqw9AW+nlLn09fJ1j83cLCK+a7dthGbeTWD4o9QOOaILeTZzJtI6?=
 =?us-ascii?Q?thiksl+0v6Sq2qeQc/KNdjSFoGfXoI/CLg+mCY7KnSxoWS+pOYXatIPmPGKS?=
 =?us-ascii?Q?BmF7eZ/KlanArXvfYtn7a+tk3WoK/dS0kpCVivpdmgLQJMclpzpB6CbOOJfU?=
 =?us-ascii?Q?WcPyxaj11dgHdc3pEl/3kehG8MGUOZgkl10OnOU0tZyZGQV2ED+D66Fx7bFt?=
 =?us-ascii?Q?d54uM4ospg23ym40VLB3ENq/tlPP093rPIv9twKeq2m5+74hot6WAXe/GyAs?=
 =?us-ascii?Q?30Vt0Js2LvTjLFQGbezTuofvi50rUmtEWp0Gl7CbfNcXuItk45JssHiGGJSy?=
 =?us-ascii?Q?FNzEfOrVZZi/bUUvbfSDU3hZ2A7SvYMLQ0mGidOfyPmbw52BV82CDTBtDR/3?=
 =?us-ascii?Q?njK0HuNRm7OZblyxA0V4Aksrlj4KOy8YsNxQtKQ4egqz/Wo3SYGz1zj0f2yi?=
 =?us-ascii?Q?aC2KbVESq+RZtGvF2Y1KupQ0eKOBHvR/E5mGt9o9jEhRo81r0bYoE4I3SBwD?=
 =?us-ascii?Q?2uxlVByTmof71wyGrTrNl47IxuxVrFytsB+rAaC0wXcz1x/Q9nqi/JOmi5Z1?=
 =?us-ascii?Q?ojs/Sstcl9NznNeHD4DAba0cQlREo6AdvwovRH8jrK4FJfnv273qZ7gesKB3?=
 =?us-ascii?Q?Kx6wKkB4L8B/IFE/0fx8lTM/zMjqCNQ5K8rRu3zc31kquuSZzZsX2X4n5lpK?=
 =?us-ascii?Q?14nffMbcUXj3L+rPH3oB3Sfa1DZ4OZy6ULZ5VTbt23YR8mAJqiIIGv3PRDjI?=
 =?us-ascii?Q?qZMZyaUiqYszgI2YkN7ot5yQ8KccaX+OGVxd77yiS8VHJN5LxRobDJ+OfQYt?=
 =?us-ascii?Q?FHr93CM+qyRWRRUW7mZafLrwwgRcuddkBMfqB/KkXZhwbTfdkZ7FNg/T57vd?=
 =?us-ascii?Q?Z4gG/VkCPriezQpFSOu4fefBPWLxDoSiiSRVIy/10bRaS/SJbtB9EfIgC9s9?=
 =?us-ascii?Q?iwOVtLf/k9TZHWQpyJVHEcIHoFcSV3Vl5n/0W9t/GEj6f06E+I8nQq3/WHW4?=
 =?us-ascii?Q?qQ9gHt8B081eZP4wIYtTpd2D0GwXie9Ql3FHp/1dRXfNtnzvKyicf+qgAueb?=
 =?us-ascii?Q?CGh+c3cQ+mg9R8IVdtLqAH4dltaNqtk8uVAjUNcocmv3R+ExZU6GIXlQhfjV?=
 =?us-ascii?Q?Ag=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6625ea8f-8fda-4828-5fe1-08db5d202b38
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2023 13:01:34.8265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cwv6avutwbpROdPAMuPuChohyY7tvSIQhksu78W5dK00Fqv6r7LS8EvA5hLByQdVaF7PsKRcUvSi60x/jLgfDi+Z2T13H4c7g1Yi0Ij6GNc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5100
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Thursday, May 11, 2023 9:53 AM
>
>Fri, Apr 28, 2023 at 02:20:01AM CEST, vadfed@meta.com wrote:
>>From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>>
>>Implement common API for clock/DPLL configuration and status reporting.
>>The API utilises netlink interface as transport for commands and event
>>notifications. This API aim to extend current pin configuration and
>>make it flexible and easy to cover special configurations.
>>
>>v6 -> v7:
>> * YAML spec:
>>   - remove nested 'pin' attribute
>>   - clean up definitions on top of the latest changes
>> * pin object:
>>   - pin xarray uses id provided by the driver
>>   - remove usage of PIN_IDX_INVALID in set function
>>   - source_pin_get() returns object instead of idx
>>   - fixes in frequency support API
>> * device and pin operations are const now
>> * small fixes in naming in Makefile and in the functions
>> * single mutex for the subsystem to avoid possible ABBA locks
>> * no special *_priv() helpers anymore, private data is passed as void*
>> * no netlink filters by name anymore, only index is supported
>> * update ptp_ocp and ice drivers to follow new API version
>> * add mlx5e driver as a new customer of the subsystem
>>v5 -> v6:
>> * rework pin part to better fit shared pins use cases
>> * add YAML spec to easy generate user-space apps
>> * simple implementation in ptp_ocp is back again
>>v4 -> v5:
>> * fix code issues found during last reviews:
>>   - replace cookie with clock id
>>   - follow one naming schema in dpll subsys
>>   - move function comments to dpll_core.c, fix exports
>>   - remove single-use helper functions
>>   - merge device register with alloc
>>   - lock and unlock mutex on dpll device release
>>   - move dpll_type to uapi header
>>   - rename DPLLA_DUMP_FILTER to DPLLA_FILTER
>>   - rename dpll_pin_state to dpll_pin_mode
>>   - rename DPLL_MODE_FORCED to DPLL_MODE_MANUAL
>>   - remove DPLL_CHANGE_PIN_TYPE enum value
>> * rewrite framework once again (Arkadiusz)
>>   - add clock class:
>>     Provide userspace with clock class value of DPLL with dpll device du=
mp
>>     netlink request. Clock class is assigned by driver allocating a dpll
>>     device. Clock class values are defined as specified in:
>>     ITU-T G.8273.2/Y.1368.2 recommendation.
>>   - dpll device naming schema use new pattern:
>>     "dpll_%s_%d_%d", where:
>>       - %s - dev_name(parent) of parent device,
>>       - %d (1) - enum value of dpll type,
>>       - %d (2) - device index provided by parent device.
>>   - new muxed/shared pin registration:
>>     Let the kernel module to register a shared or muxed pin without find=
ing
>>     it or its parent. Instead use a parent/shared pin description to fin=
d
>>     correct pin internally in dpll_core, simplifing a dpll API
>> * Implement complex DPLL design in ice driver (Arkadiusz)
>> * Remove ptp_ocp driver from the series for now
>>v3 -> v4:
>> * redesign framework to make pins dynamically allocated (Arkadiusz)
>> * implement shared pins (Arkadiusz)
>>v2 -> v3:
>> * implement source select mode (Arkadiusz)
>> * add documentation
>> * implementation improvements (Jakub)
>>v1 -> v2:
>> * implement returning supported input/output types
>> * ptp_ocp: follow suggestions from Jonathan
>> * add linux-clk mailing list
>>v0 -> v1:
>> * fix code style and errors
>> * add linux-arm mailing list
>
>Vadim, did you try ynl monitor? I think there might be something wrong
>with the yaml spec:
># ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --
>subscribe monitor --sleep 10
>Unexpected msg id done while checking for ntf nl_len =3D 92 (76) nl_flags =
=3D
>0x0 nl_type =3D 19
>

One of the commits I have prepared already replaces old notifications with =
the
ones suggested previously, where format of notification is the same as form=
at
of get command.
It works there, altough not sure if it works only for me or for everyone,
I might have done some modifications to ynl-lib itself, need to double chec=
k
that.

Thank you,
Arkadiusz

