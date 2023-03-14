Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69296B9D8B
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjCNRwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjCNRwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:52:37 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D4EB421D;
        Tue, 14 Mar 2023 10:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678816317; x=1710352317;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ridKH5bfT43EwUzuRx7+KqBOWiV/YQdnvzHHHklLAvc=;
  b=isW5mmgX66p9H0cnfNabrHVj8wWYQldsP29r3NNLGXe9OiBoa6u+nGlH
   Sut4FAzsittNQq3kAFYrTa1BKawLIjXoauzRyuwRVlx2xU0EJy5Z2QOE7
   Cj131mcVQwwX3XLM7aVR/yN9qQIHEkDNn9F9NjNjgPaJzUxfmBQoSWIoC
   7txNCD7z4lce95bdXwcNdUsopcW0j3tPyD/Vtx3vthIZosgmZ5z9aubiR
   ottQo0p26A9Wiab4wfNp6oBI9D9mOQYkXFPardjIQO+MO7blphO5JOh01
   F8xtPJ9qbN9FZCnhtecYRvmTQ7fuVfIAzgRDw+Paq1+CWun4znEuNFqnY
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="317895731"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="317895731"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 10:51:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="711611770"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="711611770"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 14 Mar 2023 10:51:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 10:51:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 10:51:00 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 10:51:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6r0EzNLEHkN2630SQtQWPAM0JaD+S4e05qkrvJtPAxw6XPKukeXlBbutMOBmakHBh3cEVDwzFlr4iZQdRIvxtoMeFWIwqEyc6c3iZUEozOyNR6K1ZUVCO44aLUj/B9XAXAaIci6sy8W7jIZbX3qo1sCfuj+npHdopC6nw7PxVnFJ5btRJIwLJ/QEXlUKFtVpH/H/NO8vyxzdUyUJH+DHavWMvbvvj5l4mi06jEFLPnJBi2NFZ7kAe60LT8MugcI5/Xz9VWssN6OLdwu5epNnmLz912ApRux4vXuN0GY0frjPL1EIhqZ+k3etbFRxo/DbI0GqiRym1CUOtaKJpvN3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uOvmzVnT0ZI5ASV5sumkj3A78aUKAc8r08MPOZHDULs=;
 b=XBhzMYHJigA9KTqxXp9jMSysFO78QDQPBADw8fuCIeCVG9sx04i0dAoSbSHsxus9mNDjPgX438DnPLLXLLFPBNqGHsrzNXJKsnscFnCxuXc4aA8cfLxgqrTZNr2+C4mdXd3rcAZ0hrufCN6M0wpDR9FDbKFu+DVnfJsmX63kTJoDXlyh7YtAw6dXG+Xzm0y/KEmtnilGVbpcopbKiBinPV6cwsWLzT7CE6gThHJDbNTItyH7P0BiLJmVKMj0hz/vuC0oNae2XWHupPr4kWzGlc0G+wxH3uFI/nP99wCthHJDk81pPy+owqGMiOltCeiNAJRRJ/XJ/6dG/rR0EDeLKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 IA1PR11MB8097.namprd11.prod.outlook.com (2603:10b6:208:457::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 17:50:57 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946%8]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 17:50:57 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>
CC:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, poros <poros@redhat.com>,
        mschmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: RE: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Thread-Topic: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Thread-Index: AQHZVIponzEP4/hw1kCkgXiNnI8keq745oYAgABvVwCAAK3PgIAAe89w
Date:   Tue, 14 Mar 2023 17:50:57 +0000
Message-ID: <DM6PR11MB4657120805D656A745EF724E9BBE9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-3-vadfed@meta.com> <ZA9Nbll8+xHt4ygd@nanopsycho>
 <2b749045-021e-d6c8-b265-972cfa892802@linux.dev>
 <ZBA8ofFfKigqZ6M7@nanopsycho>
In-Reply-To: <ZBA8ofFfKigqZ6M7@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|IA1PR11MB8097:EE_
x-ms-office365-filtering-correlation-id: 81a97992-6005-47dd-c6ad-08db24b4aa3b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ntmjhrF1BPqTaJRiMdMfWeO1gmRCMGYxLIpaLrd7Z82Ah6JoziPxrIpV66jhFhJfzQB77ce+1naRFHkDHTJeQfzViYxJWsMwzQ0oCY6vgvLLRNU6YwXJ7psJmIuCDcBQm6UFXR/a823Gi04KAKUgt9h39/OBa0sVrjTLm/CH+I1DPU/+VajDNFdQrq1feszdFDqP4zrM9aqrnCff/jMjQSDYfpgdOXD3zeKiHASRtQVVkXrnyVY/ZEtMDym0gfDR9kzKNdGyZrdFkjchlEFzfSLmevQuNLzXN/jWzd0gfKvWkeOymdH5gfvu/7mi5gq1+GsQSMkWDaphThvpRMGiH0WFpE/GDg+rP/VCIopSf6Bt64ANWNCxzIGKC3jOO1n3w0l3tKILd2b6Zz31AOUK9v9YP98wgqgyQfFm4ryNmnweIBG5G/7t6V0OK8CU089NDg3cN0ijsrF+vvgmjR1hWPx88Axure/mukc+N5hgTPjLoAc7mRAS+e7Jx5ahtaBBuM4+drYaO1DV4PZaSpUUPVv6TFCGPgmlsOJSnQsimoj9BNWHejg2Rw+DSh4d/lH1jiul76xglzdOKlFAju3i4nVoVVyxRb0A9edaSp/PWA2mh9NjbFnUXyxXU50zFZghZLH0X4aFkokwFMpTCABb65uReMoFWPSXYJBdNpOwhkRwQIk4XKNE6IpPBFIGtufIz+Lyc50zqDglqavysLrXgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(376002)(136003)(396003)(39860400002)(451199018)(2906002)(66899018)(82960400001)(83380400001)(9686003)(7696005)(107886003)(30864003)(5660300002)(4326008)(71200400001)(66946007)(26005)(8676002)(6506007)(186003)(55016003)(86362001)(66476007)(66556008)(76116006)(41300700001)(52536014)(8936002)(7416002)(38070700005)(66446008)(64756008)(33656002)(122000001)(110136005)(316002)(38100700002)(54906003)(478600001)(559001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QSqfwVzBiLBE+S8WN/rBIUSS0xaV98TbkAbCwRfCBkSPv+0Fgrxj2z5MX4TY?=
 =?us-ascii?Q?qAV5stA9uPj7By0UaaICdOFpHfRAk17lByIKIvGom32IQjJV2UDB+BBCSFS4?=
 =?us-ascii?Q?uvrrEXPKxMtPaosWRJTkdv1dGjaD017j12/PtxGALwCGFfrTMKPECG23eYOl?=
 =?us-ascii?Q?qndQpJqUcsvX2jnnL/z04l2nWpP+RBGeQSugI2XQl/Tz+Ya8hw5H49Myew/2?=
 =?us-ascii?Q?ciSok0PRRcUi/kBxcFmlRLIRXC5IGsd0z5ttHT0FsKNy4LL+IdVCsWZ+ZEbi?=
 =?us-ascii?Q?sqRuedS3xBspB0zLqdpgx69kLvATsckFdq4BJ3+lyPbRo3NCETDJ8lYQqGbI?=
 =?us-ascii?Q?SABr7Bc45+7mQkTD8RRKDHg3xgTiinmhQuZ4g/8W6FKihMs5P+XHbFxuaFyI?=
 =?us-ascii?Q?aXyn5TwD5vHfSOVnsrWP2lHl/0Z9tembPBT1sgnBqU0GJ4npeEGEs02DJgJ9?=
 =?us-ascii?Q?swZgpdXDi8Tc7g6Ucn9HqNMw3mceyPADh+/x9ujrb17A5TatkD2JbDf+fPCm?=
 =?us-ascii?Q?x5IJ4YkkUdOV3F+4d/OHQeMeNE7bmKGQQ4LW1xyI9GXqrFks3ZuyUaoR0aMb?=
 =?us-ascii?Q?yvkAyznR/SSbaa4yNueIuzAatFk8u7g/IcSmoolB2zjzUCI8HskRlfgrJ8Ic?=
 =?us-ascii?Q?n2I/7Tns+amwf8dCPL/RAJfRdasDQ3CJSSZKHzZYMuf3+Iu8U0yBPSFtTha/?=
 =?us-ascii?Q?ZmSfQRWnXAjdeuW9G1WATShB7jqT5mY/fyJ7hz4u12vtWh3Ct1qYd3nqhHNT?=
 =?us-ascii?Q?2XMA97eWvLQhXLGQ7WKFmhkuHtW6dX2Si6tH3bCjtgPsk1A1C9pkbBgEBgXH?=
 =?us-ascii?Q?cl2BkVzOXMBn39I8bFkMGuS/HcX4HpxBbT4ZxRBofaCRZn159Gk49csb4isV?=
 =?us-ascii?Q?kzicQI1NBQyjbl/2oT5K40XJXAE5WfpNIrR1QZ0eh2AoUBRMYTp3zLUX8lII?=
 =?us-ascii?Q?o+Kko2YyLDQ5HGiMXsqEJ/VlhtYbK0ubT0XaDP4FIWHWmhcBxOfyNrqJ+ShH?=
 =?us-ascii?Q?1O1rp4zXpPAOUsbh/nfZV3EokHPIKpm8gJJ4GJ365sXFqYpdAW68TKPUQika?=
 =?us-ascii?Q?NiblVSq0j6XPVQdfi33F/YO1gLeOzVrr3VEUjDbgd4ovz3rBBfNKaQCWBbnS?=
 =?us-ascii?Q?gxWEXv38+3MHUtNk8UAxZ+j2p61oK/pR2k+t7iKw9PcMB84g+KAJBRc+Uy/o?=
 =?us-ascii?Q?AvIYSxlYTv9dY00qxjS3XSIagLImec9kt9P5pe5H3grg8/oqA2GmWxUnJ9JS?=
 =?us-ascii?Q?FEld/JOGgsMzgxBXmuu54HmYzSk2OUWkOiHAXR/YYd3Oj+F/HS0ElK6cDtWO?=
 =?us-ascii?Q?volRiZefHNmxK7XYum7RWvClcuFHvA4qn30zCE/SH45c87I7jv7r2QiNGQX1?=
 =?us-ascii?Q?zVPF4j1FG4dS3Zq/hVFLgeu/p0DRceJ3EI+xVonHk1/o3Nt4x47aKcbRjbsn?=
 =?us-ascii?Q?aDsVAfnoj7XS90o6IVOMmiNvU+F1uB6y94lj7nqARwvCo2VguVvfStesfgAk?=
 =?us-ascii?Q?LLO7O3upYwWHFSmPsQCFtFSe/67tluAgOdP3gmE5to6GT6lmEtVAmYzMrK3n?=
 =?us-ascii?Q?6GGuJHXz+6gWOQQxYopAXdi8a+yS8l0FYsdAasIQkUDv2djZvSm2hv/2+wVt?=
 =?us-ascii?Q?og=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81a97992-6005-47dd-c6ad-08db24b4aa3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 17:50:57.1658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mWneKadeF6w6i+vEy/IL73VL5UrvQ4zYRk0ohfZZpH90u+86JExJD/XiK7gDdt4mXyclmrtvlxtxmlPAnU3OLS50z7HC6tKNEmQS2l6XN14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8097
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Tuesday, March 14, 2023 10:22 AM
>
>Mon, Mar 13, 2023 at 11:59:32PM CET, vadim.fedorenko@linux.dev wrote:
>>On 13.03.2023 16:21, Jiri Pirko wrote:
>>> Sun, Mar 12, 2023 at 03:28:03AM CET, vadfed@meta.com wrote:
>
>[...]
>
>
>>> > diff --git a/drivers/dpll/Makefile b/drivers/dpll/Makefile
>>> > new file mode 100644
>>> > index 000000000000..d3926f2a733d
>>> > --- /dev/null
>>> > +++ b/drivers/dpll/Makefile
>>> > @@ -0,0 +1,10 @@
>>> > +# SPDX-License-Identifier: GPL-2.0
>>> > +#
>>> > +# Makefile for DPLL drivers.
>>> > +#
>>> > +
>>> > +obj-$(CONFIG_DPLL)          +=3D dpll_sys.o
>>>
>>> What's "sys" and why is it here?
>>
>>It's an object file for the subsystem. Could be useful if we will have
>>drivers
>>for DPLL-only devices.
>
>Yeah, but why "sys"? I don't get what "sys" means here.
>Can't this be just "dpll.o"?
>
>
>>
>>> > +dpll_sys-y                  +=3D dpll_core.o
>>> > +dpll_sys-y                  +=3D dpll_netlink.o
>>> > +dpll_sys-y                  +=3D dpll_nl.o
>>> > +
>
>[...]
>
>
>>> > +struct dpll_device *
>>> > +dpll_device_get(u64 clock_id, u32 dev_driver_id, struct module
>>> > *module)
>>> > +{
>>> > +	struct dpll_device *dpll, *ret =3D NULL;
>>> > +	unsigned long index;
>>> > +
>>> > +	mutex_lock(&dpll_device_xa_lock);
>>> > +	xa_for_each(&dpll_device_xa, index, dpll) {
>>> > +		if (dpll->clock_id =3D=3D clock_id &&
>>> > +		    dpll->dev_driver_id =3D=3D dev_driver_id &&
>>>
>>> Why you need "dev_driver_id"? clock_id is here for the purpose of
>>> identification, isn't that enough for you.
>>
>>dev_driver_id is needed to provide several DPLLs from one device. In ice
>>driver
>>implementation there are 2 different DPLLs - to recover from PPS input an=
d
>>to
>>recover from Sync-E. I believe there is only one clock, that's why clock =
id
>>is the same for both of them. But Arkadiusz can tell more about it.
>
>Okay, I see. Clock_id is the same. Could we have index for pin, could
>this be index too:
>
>dpll_device_get(u64 clock_id, u32 device_index, struct module *module);
>dpll_pin_get(u64 clock_id, u32 pin_index, struct module *module,
>	     const struct dpll_pin_properties *prop);
>
>This way it is consistent, driver provides custom index for both dpll
>device and dpll pin.
>
>Makes sense?
>

IMHO, Yes this better shows the intentions.

>
>>>
>>> Plus, the name is odd. "dev_driver" should certainly be avoided.
>>
>>Simply id doesn't tell anything either. dpll_dev_id?
>
>Yeah, see above.
>
>
>>
>>> > +		    dpll->module =3D=3D module) {
>>> > +			ret =3D dpll;
>>> > +			refcount_inc(&ret->refcount);
>>> > +			break;
>>> > +		}
>>> > +	}
>>> > +	if (!ret)
>>> > +		ret =3D dpll_device_alloc(clock_id, dev_driver_id, module);
>>> > +	mutex_unlock(&dpll_device_xa_lock);
>>> > +
>>> > +	return ret;
>>> > +}
>>> > +EXPORT_SYMBOL_GPL(dpll_device_get);
>>> > +
>>> > +/**
>>> > + * dpll_device_put - decrease the refcount and free memory if possib=
le
>>> > + * @dpll: dpll_device struct pointer
>>> > + *
>>> > + * Drop reference for a dpll device, if all references are gone, del=
ete
>>> > + * dpll device object.
>>> > + */
>>> > +void dpll_device_put(struct dpll_device *dpll)
>>> > +{
>>> > +	if (!dpll)
>>> > +		return;
>>>
>>> Remove this check. The driver should not call this with NULL.
>>
>>Well, netdev_put() has this kind of check. As well as spi_dev_put() or
>>i2c_put_adapter() at least. Not sure I would like to avoid a bit of safet=
y.
>
>IDK, maybe for historical reasons. My point is, id driver is callin
>this with NULL, there is something odd in the driver flow. Lets not
>allow that for new code.
>
>
>>
>>> > +	mutex_lock(&dpll_device_xa_lock);
>>> > +	if (refcount_dec_and_test(&dpll->refcount)) {
>>> > +		WARN_ON_ONCE(!xa_empty(&dpll->pin_refs));
>>>
>>> ASSERT_DPLL_NOT_REGISTERED(dpll);
>>
>>Good point!
>>
>>> > +		xa_destroy(&dpll->pin_refs);
>>> > +		xa_erase(&dpll_device_xa, dpll->id);
>>> > +		kfree(dpll);
>>> > +	}
>>> > +	mutex_unlock(&dpll_device_xa_lock);
>>> > +}
>>> > +EXPORT_SYMBOL_GPL(dpll_device_put);
>>> > +
>>> > +/**
>>> > + * dpll_device_register - register the dpll device in the subsystem
>>> > + * @dpll: pointer to a dpll
>>> > + * @type: type of a dpll
>>> > + * @ops: ops for a dpll device
>>> > + * @priv: pointer to private information of owner
>>> > + * @owner: pointer to owner device
>>> > + *
>>> > + * Make dpll device available for user space.
>>> > + *
>>> > + * Return:
>>> > + * * 0 on success
>>> > + * * -EINVAL on failure
>>> > + */
>>> > +int dpll_device_register(struct dpll_device *dpll, enum dpll_type ty=
pe,
>>> > +			 struct dpll_device_ops *ops, void *priv,
>>> > +			 struct device *owner)
>>> > +{
>>> > +	if (WARN_ON(!ops || !owner))
>>> > +		return -EINVAL;
>>> > +	if (WARN_ON(type <=3D DPLL_TYPE_UNSPEC || type > DPLL_TYPE_MAX))
>>> > +		return -EINVAL;
>>> > +	mutex_lock(&dpll_device_xa_lock);
>>> > +	if (ASSERT_DPLL_NOT_REGISTERED(dpll)) {
>>> > +		mutex_unlock(&dpll_device_xa_lock);
>>> > +		return -EEXIST;
>>> > +	}
>>> > +	dpll->dev.bus =3D owner->bus;
>>> > +	dpll->parent =3D owner;
>>> > +	dpll->type =3D type;
>>> > +	dpll->ops =3D ops;
>>> > +	dev_set_name(&dpll->dev, "%s_%d", dev_name(owner),
>>> > +		     dpll->dev_driver_id);
>>>
>>> This is really odd. As a result, the user would see something like:
>>> pci/0000:01:00.0_1
>>> pci/0000:01:00.0_2
>>>
>>> I have to say it is confusing. In devlink, is bus/name and the user
>>> could use this info to look trough sysfs. Here, 0000:01:00.0_1 is not
>>> there. Also, "_" might have some meaning on some bus. Should not
>>> concatename dev_name() with anything.
>>>
>>> Thinking about this some more, the module/clock_id tuple should be
>>> uniqueue and stable. It is used for dpll_device_get(), it could be used
>>> as the user handle, can't it?
>>> Example:
>>> ice/c92d02a7129f4747
>>> mlx5/90265d8bf6e6df56
>>>
>>> If you really need the "dev_driver_id" (as I believe clock_id should be
>>> enough), you can put it here as well:
>>> ice/c92d02a7129f4747/1
>>> ice/c92d02a7129f4747/2
>>>
>>
>>Looks good, will change it
>
>Great.
>
>
>>
>>> This would also be beneficial for mlx5, as mlx5 with 2 PFs would like t=
o
>>> share instance of DPLL equally, there is no "one clock master". >
>
>[...]
>
>
>>> > +	pin->prop.description =3D kstrdup(prop->description, GFP_KERNEL);
>>> > +	if (!pin->prop.description) {
>>> > +		ret =3D -ENOMEM;
>>> > +		goto release;
>>> > +	}
>>> > +	if (WARN_ON(prop->type <=3D DPLL_PIN_TYPE_UNSPEC ||
>>> > +		    prop->type > DPLL_PIN_TYPE_MAX)) {
>>> > +		ret =3D -EINVAL;
>>> > +		goto release;
>>> > +	}
>>> > +	pin->prop.type =3D prop->type;
>>> > +	pin->prop.capabilities =3D prop->capabilities;
>>> > +	pin->prop.freq_supported =3D prop->freq_supported;
>>> > +	pin->prop.any_freq_min =3D prop->any_freq_min;
>>> > +	pin->prop.any_freq_max =3D prop->any_freq_max;
>>>
>>> Make sure that the driver maintains prop (static const) and just save
>>> the pointer. Prop does not need to be something driver needs to change.
>>>
>>
>>What's the difference? For ptp_ocp, we have the same configuration for al=
l
>>ext pins and the allocator only changes the name of the pin. Properties o=
f
>>the DPLL pins are stored within the pin object, not the driver, in this
>case.
>>Not sure if the pointer way is much better...
>
>For things like this it is common to have static const array in the
>driver, like:
>
>static const struct dpll_pin_properties dpll_pin_props[] =3D {
>	{
>		.description =3D "SMA0",
>		.freq_supported =3D DPLL_PIN_FREQ_SUPP_MAX,
>		.type =3D DPLL_PIN_TYPE_EXT,
>		.any_freq_max =3D 10000000,
>		.capabilities =3D DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE,
>	},
>	{
>		.description =3D "SMA1",
>		.freq_supported =3D DPLL_PIN_FREQ_SUPP_MAX,
>		.type =3D DPLL_PIN_TYPE_EXT,
>		.any_freq_max =3D 10000000,
>		.capabilities =3D DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE,
>	},
>	{
>		.description =3D "SMA2",
>		.freq_supported =3D DPLL_PIN_FREQ_SUPP_MAX,
>		.type =3D DPLL_PIN_TYPE_EXT,
>		.any_freq_max =3D 10000000,
>		.capabilities =3D DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE,
>	},
>	{
>		.description =3D "SMA3",
>		.freq_supported =3D DPLL_PIN_FREQ_SUPP_MAX,
>		.type =3D DPLL_PIN_TYPE_EXT,
>		.any_freq_max =3D 10000000,
>		.capabilities =3D DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE,
>	},
>};
>
>Here you have very nice list of pins, the reader knows right away what
>is happening.
>
>Thinking about "description" name, I think would be more appropriate to
>name this "label" as it represents user-facing label on the connector,
>isn't it? Does not describe anything.
>

"label" seems good.

>
>>
>>>
>
>[...]
>
>
>>
>>>
>>> > +	     const struct dpll_pin_properties *prop)
>>> > +{
>>> > +	struct dpll_pin *pos, *ret =3D NULL;
>>> > +	unsigned long index;
>>> > +
>>> > +	mutex_lock(&dpll_pin_xa_lock);
>>> > +	xa_for_each(&dpll_pin_xa, index, pos) {
>>> > +		if (pos->clock_id =3D=3D clock_id &&
>>> > +		    pos->dev_driver_id =3D=3D device_drv_id &&
>>> > +		    pos->module =3D=3D module) {
>>>
>>> Compare prop as well.
>>>
>>> Can't the driver_id (pin index) be something const as well? I think it
>>> should. And therefore it could be easily put inside.
>>>
>>
>>I think clock_id + dev_driver_id + module should identify the pin exactly=
.
>>And now I think that *prop is not needed here at all. Arkadiusz, any
>>thoughts?
>
>IDK, no strong opinion on this. I just thought it may help to identify
>the pin and avoid potential driver bugs. (Like registering 2 pins with
>the same properties).
>

It would make most sense if pin_index would be a part of *prop.

>[...]
>
>
>>> > +/**
>>> > + * dpll_pin_register - register the dpll pin in the subsystem
>>> > + * @dpll: pointer to a dpll
>>> > + * @pin: pointer to a dpll pin
>>> > + * @ops: ops for a dpll pin ops
>>> > + * @priv: pointer to private information of owner
>>> > + * @rclk_device: pointer to recovered clock device
>>> > + *
>>> > + * Return:
>>> > + * * 0 on success
>>> > + * * -EINVAL - missing dpll or pin
>>> > + * * -ENOMEM - failed to allocate memory
>>> > + */
>>> > +int
>>> > +dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
>>> > +		  struct dpll_pin_ops *ops, void *priv,
>>> > +		  struct device *rclk_device)
>>>
>>> Wait a second, what is this "struct device *"? Looks very odd.
>>>
>>>
>>> > +{
>>> > +	const char *rclk_name =3D rclk_device ? dev_name(rclk_device) :
>>> >NULL;
>>>
>>> If you need to store something here, store the pointer to the device
>>> directly. But this rclk_device seems odd to me.
>>> Dev_name is in case of PCI device for example 0000:01:00.0? That alone
>>> is incomplete. What should it server for?
>>>
>>
>>Well, these questions go to Arkadiusz...
>


[ copy paste my answer from previous response ]
If pin is able to recover signal from some device this shall convey that
device struct pointer.
Name of that device is later passed to the user with DPLL_A_PIN_RCLK_DEVICE
attribute.
Sure we can have pointer to device and use dev_name (each do/dump) on netli=
nk
part. But isn't it better to have the name ready to use there?

It might be incomplete only if one device would have some kind of access to
a different bus? I don't think it is valid use case.

Basically the driver will refer only to the devices handled by that driver,
which means if dpll is on some bus, also all the pins are there, didn't not=
ice
the need to have bus here as well.

>Okay.
>
>[...]
>
>
>>> > + * dpll_pin_get_by_idx - find a pin ref on dpll by pin index
>>> > + * @dpll: dpll device pointer
>>> > + * @idx: index of pin
>>> > + *
>>> > + * Find a reference to a pin registered with given dpll and return
>>> > its pointer.
>>> > + *
>>> > + * Return:
>>> > + * * valid pointer if pin was found
>>> > + * * NULL if not found
>>> > + */
>>> > +struct dpll_pin *dpll_pin_get_by_idx(struct dpll_device *dpll, u32 i=
dx)
>>> > +{
>>> > +	struct dpll_pin_ref *pos;
>>> > +	unsigned long i;
>>> > +
>>> > +	xa_for_each(&dpll->pin_refs, i, pos) {
>>> > +		if (pos && pos->pin && pos->pin->dev_driver_id =3D=3D idx)
>>>
>>> How exactly pos->pin could be NULL?
>>>
>>> Also, you are degrading the xarray to a mere list here with lookup like
>>> this. Why can't you use the pin index coming from driver and
>>> insert/lookup based on this index?
>>>
>>Good point. We just have to be sure, that drivers provide 0-based indexes=
 for
>>their pins. I'll re-think it.
>
>No, driver can provide indexing which is completely up to his decision.
>You should use xa_insert() to insert the entry at specific index. See
>devl_port_register for inspiration where it is done exactly like this.
>
>And this should be done in exactly the same way for both pin and device.
>

Yes, I agree seems doable and better then it is now.

[...]

>>> > +static int
>>> > +dpll_msg_add_dev_handle(struct sk_buff *msg, const struct dpll_devic=
e
>>> >*dpll)
>>> > +{
>>> > +	if (nla_put_u32(msg, DPLL_A_ID, dpll->id))
>>>
>>> Why exactly do we need this dua--handle scheme? Why do you need
>>> unpredictable DPLL_A_ID to be exposed to userspace?
>>> It's just confusing.
>>>
>>To be able to work with DPLL per integer after iterator on the list deduc=
ts
>>which DPLL device is needed. It can reduce the amount of memory copies an=
d
>>simplify comparisons. Not sure why it's confusing.
>
>Wait, I don't get it. Could you please explain a bit more?
>
>My point is, there should be not such ID exposed over netlink
>You don't need to expose it to userspace. The user has well defined
>handle as you agreed with above. For example:
>
>ice/c92d02a7129f4747/1
>ice/c92d02a7129f4747/2
>
>This is shown in dpll device GET/DUMP outputs.
>Also user passes it during SET operation:
>$ dplltool set ice/c92d02a7129f4747/1 mode auto
>
>Isn't that enough stable and nice?
>

I agree with Vadim, this is rather to be used by a daemon tools, which
would get the index once, then could use it as long as device is there.

>
>>
>>>
>>> > +		return -EMSGSIZE;
>>> > +	if (nla_put_string(msg, DPLL_A_BUS_NAME, dev_bus_name(&dpll-
>>> > dev)))
>>> > +		return -EMSGSIZE;
>>> > +	if (nla_put_string(msg, DPLL_A_DEV_NAME, dev_name(&dpll->dev)))
>>> > +		return -EMSGSIZE;
>>> > +
>>> > +	return 0;
>>> > +}
>>
>>[...]
>>
>>> > +
>>> > +static int
>>> > +dpll_msg_add_pins_on_pin(struct sk_buff *msg, struct dpll_pin *pin,
>>> > +			 struct netlink_ext_ack *extack)
>>> > +{
>>> > +	struct dpll_pin_ref *ref =3D NULL;
>>>
>>> Why this needs to be initialized?
>>>
>>No need, fixed.
>>
>>
>>>
>>> > +	enum dpll_pin_state state;
>>> > +	struct nlattr *nest;
>>> > +	unsigned long index;
>>> > +	int ret;
>>> > +
>>> > +	xa_for_each(&pin->parent_refs, index, ref) {
>>> > +		if (WARN_ON(!ref->ops->state_on_pin_get))
>>> > +			return -EFAULT;
>>> > +		ret =3D ref->ops->state_on_pin_get(pin, ref->pin, &state,
>>> > +						 extack);
>>> > +		if (ret)
>>> > +			return -EFAULT;
>>> > +		nest =3D nla_nest_start(msg, DPLL_A_PIN_PARENT);
>>> > +		if (!nest)
>>> > +			return -EMSGSIZE;
>>> > +		if (nla_put_u32(msg, DPLL_A_PIN_PARENT_IDX,
>>> > +				ref->pin->dev_driver_id)) {
>>> > +			ret =3D -EMSGSIZE;
>>> > +			goto nest_cancel;
>>> > +		}
>>> > +		if (nla_put_u8(msg, DPLL_A_PIN_STATE, state)) {
>>> > +			ret =3D -EMSGSIZE;
>>> > +			goto nest_cancel;
>>> > +		}
>>> > +		nla_nest_end(msg, nest);
>>> > +	}
>>>
>>> How is this function different to dpll_msg_add_pin_parents()?
>>> Am I lost? To be honest, this x_on_pin/dpll, parent, refs dance is quit=
e
>>> hard to follow for me :/
>>>
>>> Did you get lost here as well? If yes, this needs some serious think
>>> through :)
>>>
>>
>>Let's re-think it again. Arkadiuzs, do you have clear explanation of the
>>relationship between these things?
>

[ copy paste my answer from previous response ]
No, it is just leftover I didn't catch, we can leave one function and use i=
t in
both cases. Sorry about that, great catch!

[...]

>>> > +	if (nla_put_u32(msg, DPLL_A_PIN_IDX, pin->dev_driver_id))
>>>
>>> Is it "ID" or "INDEX" (IDX). Please make this consistent in the whole
>>> code.
>>>
>>
>>I believe it's INDEX which is provided by the driver. I'll think about
>>renaming,
>>but suggestions are welcome.
>
>Let's use "index" and "INDEX" internalla and in Netlink attr names as
>well then.
>

For me makes sense to have a common name instead of origin-based one.

>[...]
>
>
>>
>>>
>>> > +	int rem, ret =3D -EINVAL;
>>> > +	struct nlattr *a;
>>> > +
>>> > +	nla_for_each_attr(a, genlmsg_data(info->genlhdr),
>>> > +			  genlmsg_len(info->genlhdr), rem) {
>>>
>>> This is odd. Why you iterace over attrs? Why don't you just access them
>>> directly, like attrs[DPLL_A_PIN_FREQUENCY] for example?
>>>
>>
>>I had some unknown crashes when I was using such access. I might have los=
t
>>some checks, will try it again.
>
>Odd, yet definitelly debuggable though :)
>
>[...]
>
>
>>> > +int dpll_pin_pre_dumpit(struct netlink_callback *cb)
>>> > +{
>>> > +	mutex_lock(&dpll_pin_xa_lock);
>>>
>>> ABBA deadlock here, see dpll_pin_register() for example where the lock
>>> taking order is opposite.
>>>
>>
>>Now I see an ABBA deadlock here, as well as in function before. Not sure
>>how to
>>solve it here. Any thoughts?
>
>Well, here you can just call dpll_pre_dumpit() before
>mutex_lock(&dpll_pin_xa_lock)
>to take the locks in the same order.
>

This double lock doesn't really improve anything.
Any objections on having single mutex/lock for access the dpll subsystem?

>
>>
>>>
>>> > +
>>> > +	return dpll_pre_dumpit(cb);
>>> > +}
>>> > +
>>> > +int dpll_pin_post_dumpit(struct netlink_callback *cb)
>>> > +{
>>> > +	mutex_unlock(&dpll_pin_xa_lock);
>>> > +
>>> > +	return dpll_post_dumpit(cb);
>>> > +}
>>> > +
>>> > +static int
>>> > +dpll_event_device_change(struct sk_buff *msg, struct dpll_device
>>> > *dpll,
>>> > +			 struct dpll_pin *pin, struct dpll_pin *parent,
>>> > +			 enum dplla attr)
>>> > +{
>>> > +	int ret =3D dpll_msg_add_dev_handle(msg, dpll);
>>> > +	struct dpll_pin_ref *ref =3D NULL;
>>> > +	enum dpll_pin_state state;
>>> > +
>>> > +	if (ret)
>>> > +		return ret;
>>> > +	if (pin && nla_put_u32(msg, DPLL_A_PIN_IDX, pin-
>>> > dev_driver_id))
>>> > +		return -EMSGSIZE;
>>>
>>> I don't really understand why you are trying figure something new and
>>> interesting with the change notifications. This object mix and random
>>> attrs fillup is something very wrong and makes userspace completely
>>> fuzzy about what it is getting. And yet it is so simple:
>>> You have 2 objects, dpll and pin, please just have:
>>> dpll_notify()
>>> dpll_pin_notify()
>>> and share the attrs fillup code with pin_get() and dpll_get() callbacks=
.
>>> No need for any smartness. Have this dumb and simple.
>>>
>>> Think about it more as about "object-state-snapshot" than "atomic-chang=
e"
>>
>>But with full object-snapshot user space app will lose the information ab=
out
>>what exactly has changed. The reason to have this event is to provide the
>>attributes which have changed. Otherwise, the app should have full snapsh=
ot
>>and
>>compare all attributes to figure out changes and that's might not be grea=
t
>>idea.
>
>Wait, are you saying that the app is stateless? Could you provide
>example use cases?
>
>From what I see, the app managing dpll knows the state of the device and
>pins, it monitors for the changes and saves new state with appropriate
>reaction (might be some action or maybe just log entry).
>

It depends on the use case, right? App developer having those information k=
nows
what has changed, thus can react in a way it thinks is most suitable.
IMHO from user perspective it is good to have a notification which actually
shows it's reason, so proper flow could be assigned to handle the reaction.

>
>>
>>>
>>> > +
>>> > +	switch (attr) {
>>> > +	case DPLL_A_MODE:
>>> > +		ret =3D dpll_msg_add_mode(msg, dpll, NULL);
>>> > +		break;
>>> > +	case DPLL_A_SOURCE_PIN_IDX:
>>> > +		ret =3D dpll_msg_add_source_pin_idx(msg, dpll, NULL);
>>> > +		break;
>>> > +	case DPLL_A_LOCK_STATUS:
>>> > +		ret =3D dpll_msg_add_lock_status(msg, dpll, NULL);
>>> > +		break;
>>> > +	case DPLL_A_TEMP:
>>> > +		ret =3D dpll_msg_add_temp(msg, dpll, NULL);
>>> > +		break;
>>> > +	case DPLL_A_PIN_FREQUENCY:
>>> > +		ret =3D dpll_msg_add_pin_freq(msg, pin, NULL, false);
>>> > +		break;
>>> > +	case DPLL_A_PIN_PRIO:
>>> > +		ref =3D dpll_xa_ref_dpll_find(&pin->dpll_refs, dpll);
>>> > +		if (!ref)
>>> > +			return -EFAULT;
>>> > +		ret =3D dpll_msg_add_pin_prio(msg, pin, ref, NULL);
>>> > +		break;
>>> > +	case DPLL_A_PIN_STATE:
>>> > +		if (parent) {
>>> > +			ref =3D dpll_xa_ref_pin_find(&pin->parent_refs, parent);
>>> > +			if (!ref)
>>> > +				return -EFAULT;
>>> > +			if (!ref->ops || !ref->ops->state_on_pin_get)
>>> > +				return -EOPNOTSUPP;
>>> > +			ret =3D ref->ops->state_on_pin_get(pin, parent, &state,
>>> > +							 NULL);
>>> > +			if (ret)
>>> > +				return ret;
>>> > +			if (nla_put_u32(msg, DPLL_A_PIN_PARENT_IDX,
>>> > +					parent->dev_driver_id))
>>> > +				return -EMSGSIZE;
>>> > +		} else {
>>> > +			ref =3D dpll_xa_ref_dpll_find(&pin->dpll_refs, dpll);
>>> > +			if (!ref)
>>> > +				return -EFAULT;
>>> > +			ret =3D dpll_msg_add_pin_on_dpll_state(msg, pin, ref,
>>> > +							     NULL);
>>> > +			if (ret)
>>> > +				return ret;
>>> > +		}
>>> > +		break;
>>> > +	default:
>>> > +		break;
>>> > +	}
>>> > +
>>> > +	return ret;
>>> > +}
>>> > +
>>> > +static int
>>> > +dpll_send_event_create(enum dpll_event event, struct dpll_device *dp=
ll)
>>> > +{
>>> > +	struct sk_buff *msg;
>>> > +	int ret =3D -EMSGSIZE;
>>> > +	void *hdr;
>>> > +
>>> > +	msg =3D genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>>> > +	if (!msg)
>>> > +		return -ENOMEM;
>>> > +
>>> > +	hdr =3D genlmsg_put(msg, 0, 0, &dpll_nl_family, 0, event);
>>> > +	if (!hdr)
>>> > +		goto out_free_msg;
>>> > +
>>> > +	ret =3D dpll_msg_add_dev_handle(msg, dpll);
>>> > +	if (ret)
>>> > +		goto out_cancel_msg;
>>> > +	genlmsg_end(msg, hdr);
>>> > +	genlmsg_multicast(&dpll_nl_family, msg, 0, 0, GFP_KERNEL);
>>> > +
>>> > +	return 0;
>>> > +
>>> > +out_cancel_msg:
>>> > +	genlmsg_cancel(msg, hdr);
>>> > +out_free_msg:
>>> > +	nlmsg_free(msg);
>>> > +
>>> > +	return ret;
>>> > +}
>>> > +
>>> > +static int
>>> > +dpll_send_event_change(struct dpll_device *dpll, struct dpll_pin *pi=
n,
>>> > +		       struct dpll_pin *parent, enum dplla attr)
>>> > +{
>>> > +	struct sk_buff *msg;
>>> > +	int ret =3D -EMSGSIZE;
>>> > +	void *hdr;
>>> > +
>>> > +	msg =3D genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>>> > +	if (!msg)
>>> > +		return -ENOMEM;
>>> > +
>>> > +	hdr =3D genlmsg_put(msg, 0, 0, &dpll_nl_family, 0,
>>> > +			  DPLL_EVENT_DEVICE_CHANGE);
>>>
>>> I don't really get it. Why exactly you keep having this *EVENT* cmds?
>>> Why per-object NEW/GET/DEL cmds shared with get genl op are not enough?
>>> I have to be missing something.
>>
>>Changes might come from other places, but will affect the DPLL device and=
 we
>>have to notify users in this case.
>
>I'm not sure I follow. There are 2 scenarios for change:
>1) user originated - user issues set of something
>2) driver originated - something changes in HW, driver propagates that
>
>With what I suggest, both scenarios work of course. My point is, user
>knows very well the objects: device and pin, he knows the format or
>messages that are related to GET/DUMP/SET operations of both. The
>notification should have the same format, that is all I say.
>
>Btw, you can see devlink code for example how the notifications like
>this are implemented and work.
>

Devlink packs all the info into a netlink message and notifies with it, isn=
't
it that it has all the info "buffered" in its structures?
A dpll subsystem keeps only some of the info in its internal structures, bu=
t
for most of it it has to question the driver. It would do it multiple times
i.e. if there would be a change on a pin connected to multiple dpll devices=
.

With current approach the notifications are pretty light to the subsystem a=
s
well as for the registered clients, and as you suggested with having info o=
f
what actually changed the userspace could implement a stateless daemon righ=
t
away.

Thank you,
Arkadiusz
