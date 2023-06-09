Return-Path: <netdev+bounces-9541-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CB73729AC8
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:56:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9C05281956
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:56:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60ACF171B8;
	Fri,  9 Jun 2023 12:56:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D27E168CD
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:56:00 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95AF359A;
	Fri,  9 Jun 2023 05:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686315345; x=1717851345;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=umpiFHjRSsvdbUFmv/o8QAntSsc4C5n2e0v8vqrxJz4=;
  b=Whj03zGqv5DoldehSc6RMQer0l4058q7bPN9sOgA/DxIvJMO2Q0YNizf
   pneP70vMES1TT0WnqbInpBejbABwe76jLyul8ZVlw7JSp7c9ExiC9AeOX
   F0ane2hjgzMIdBekMXSMN0Pa804inK03r4tz1NnKHYKGSeUFvU/JxWh40
   x2z4T2Wp8sIzoXS8jgqU6ZjmY8vi6nE+RAB7es5Ur0ThAxR/HuzQ5741Z
   HBxsLiu23l7kNns6/cfC2XY7xQry9xl4fUDijquigZCo+5ZCJLwE/qZ+7
   91qyNJxh6jhb3PMPw7AB/eLRuSNYhhXh6OpQt6EHRrSAu+O7AQA0yCAtQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="357591860"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="357591860"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 05:54:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="660753482"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="660753482"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 09 Jun 2023 05:54:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 05:54:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 05:54:42 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 9 Jun 2023 05:54:42 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 9 Jun 2023 05:54:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=foB8H/oDZl6ZScedkUPyodUv/fFPtDQrUqNPkVp+UZ1HjWkF38zbsWVYYu+nPOsA/8nMHhgLJgJuJbVgicsQOyH4+BVi8vZFMUWrzFajkrcZ1STK8Dp/YloQHZGS7CdxiCntJbiZQrl2SQC+j4fiyA7yAS7kZp0HQ0pBxg/L7XgwsjJALoNE6krdlH0lPU4b10b38lCFm3+NK3+oZ1oNJPHiuTtkIuzxjF6Ulo1B5rogTIENJty28e6F6yTd6za9oSARfRers9BKIFBljNSLHpFQXTk6wIw7/DXhXSTOZ7zD++apq5+AkLz/i1fEROSen+4AfyeH6PYM2DsF6dI9Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4OmuCtea3uy2o+gSWzQOm8b2iShoxhNlJhrgiIkG/nY=;
 b=PB4AvLJYV0UOMi05lz3B+b3Q28+WOWhM1Svxy78pT6o06YjyoaFMZ4hstFhtV7lia+6fu/oHWOtH7kfDxYM4cv5AixHPYC/aFSza8deDXJw3EVk3XBin0j+QpzOUVTaLS8aGXfJn5Vz+RRMKwvPnx3CxueGIXW7Qq3pWB4d4HtMTl0A+i+ntAgjd6jM2/0KkRjzA2IvRlD7lXtcRDoK/hL3UsDo9KEPkIRXHfsSnuqopqmfwE/UEmu7tfOMojcFaFNwul4fMUl36I8G0iKb12fen4i6H7ZyRhjcVMVp+QalEf+MFwihG/nJwJUfdvEoLf+SdvJqE6c1nYLz/DGX2cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 MN6PR11MB8194.namprd11.prod.outlook.com (2603:10b6:208:477::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Fri, 9 Jun
 2023 12:54:20 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6%3]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 12:54:20 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jakub Kicinski <kuba@kernel.org>, Vadim Fedorenko <vadfed@meta.com>
CC: Jiri Pirko <jiri@resnulli.us>, Jonathan Lemon <jonathan.lemon@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>, "Olech, Milena" <milena.olech@intel.com>,
	"Michalik, Michal" <michal.michalik@intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v7 2/8] dpll: Add DPLL framework base functions
Thread-Topic: [RFC PATCH v7 2/8] dpll: Add DPLL framework base functions
Thread-Index: AQHZeWdERHWnlPmo9kOdLErcTLxvj69KqfKAgDgGFOA=
Date: Fri, 9 Jun 2023 12:54:20 +0000
Message-ID: <DM6PR11MB465741624AC5C49C4CDEB3AF9B51A@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
	<20230428002009.2948020-3-vadfed@meta.com>
 <20230504142123.5fdb4e96@kernel.org>
In-Reply-To: <20230504142123.5fdb4e96@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|MN6PR11MB8194:EE_
x-ms-office365-filtering-correlation-id: 9a5c91ca-6f73-4aa3-566d-08db68e8a4ba
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: er/J8kg/FTAlxBEooTQ2YjM8MNjE1JfxM3mPXpQ6oUgd11gYeDu5kjFPhnZI6aaiQXPOgyE4Fiuhq0poYFynt1M0DAA66zs6jotIFNEl0kgFUJq8QOU8JkH3MMFYDyGgdo3yPIXbn89GtmRb5S6Qujz7fEKASiP45hXjbk2a3fTd3LC8kYwUighO+IhS655eSWLwX8LBZ+IqUt4gzdxQLrILUx6C0NyW/R+PoAqK7pQo2zqJadu/Bmo36EZIdAv31xChUgSLE5YPRO8QL7l0Tw+DRr2TPL9xJeEe3zLLOxp0QE3Dqg3l/MUdzh9EIX2d1N8M9VAAIPZWl2YUx0QmSSTVFGF9iEUt1OevNYJWlp6XSJJWmqvqfe0c3xS5dUpfjHZr/JGxTpkayGDDiUVgbC19NAOx/CAJaS4uNTsgmObh8+3+dLvyy70pHisj0Ld3/C0ddh+DKaw8srDWcZmtrn4P9fqDIe2CO8NEYP8TmVujK5yikGwCt73MMzyE0RQ5mdCmn9byGZnLvH9po6gV1IDvsYOfCa6uQDUH2ajaWVTKJPHqNKp2MVh+t1HkWbG51q1/4EuFMdZztxizE6D6LgkHhF6uNyWnrW/AhzkWd7bbbgYnxHm6PBgYEEUU2fC2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(396003)(136003)(376002)(39860400002)(451199021)(86362001)(8676002)(8936002)(110136005)(7696005)(54906003)(478600001)(41300700001)(55016003)(5660300002)(52536014)(316002)(6506007)(66446008)(26005)(4326008)(66476007)(71200400001)(64756008)(66556008)(76116006)(66946007)(9686003)(186003)(83380400001)(7416002)(2906002)(122000001)(82960400001)(38100700002)(33656002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ghx0rAekN+Lg+plg/xI0fbtiHM+7BCjV58LOPsWXuAadYm1nNNEGqs+fiWQz?=
 =?us-ascii?Q?FPkcmOPKc8d2Ss+Vs0/9KgesRJ5Ofpa3ISWC7EkhEjXaYo2UcRyoGrmjGi1d?=
 =?us-ascii?Q?hZ52EeD+3beHW5v/gmN0Q4Vb/qwmv8Gecfq0mGiKsGDgMJH3hG7yw+I8sdk/?=
 =?us-ascii?Q?oLN7/RlAKPtD5ht5DepgnraEngqAtJEhjkih8iPTQ7zRUBXMf3yA/QdgBJMv?=
 =?us-ascii?Q?y/6oTF9T2KlTpuKs/27RWHBCZZWBE2IaA9t0V08I4bDA8ykXzXP+VfTEPUMt?=
 =?us-ascii?Q?1VFTGCnc+5LT20SLK8YUZyQHJPtoKp4q0lSIjH6FEWGvV4cK8yjiW+xfrk5r?=
 =?us-ascii?Q?I8qF9+D6mM2rZwbK17PYE1iWJsgCm3k2E+pWDpxhBv/1kuMwOfusUBB9bf1N?=
 =?us-ascii?Q?kAikmKzffOam2x6dcbQc8zzHAfy3t6Kh9RbFwl/q07HCpOYpHvnPeatxT0Vt?=
 =?us-ascii?Q?Ya/nH/qylvy85o1XZlFU4tExn5ZjRiD+DaKDhJIhiFJrdjOCsXvesSEJCqcm?=
 =?us-ascii?Q?gb+h4YiARw5Ne/xsjWxKGde5PQRNvOMpMfS+83GgoDQAwMaHKkAcHEL5Xkxd?=
 =?us-ascii?Q?L7Sgy6Ee5pWR+61MlHeWbxctx9MAcNJ5F7J4NO3WbMnDqTgccYtCWsj1OtH3?=
 =?us-ascii?Q?pB88W8azlS4YrJMssPvDQQPfbBewVkCBZKWwT3lRKE+E0lC2LDWQgquwj5zm?=
 =?us-ascii?Q?K+yi96hBQyoRtX1ifz3SsBeBRuVN+KYC4we6Rs12ThLCnY+Qsj8xUC6NoE4J?=
 =?us-ascii?Q?tUYhUeo3ie6Yz3OSZJB/3TFcoY92jRsCntewS+kLJJ/ZekJdYAj3XaCHGoaU?=
 =?us-ascii?Q?Qgak8BkLGd8W9vx3ftZzIVtyJJHFAReclXDGC/vHiNKRZKSV8l4FRU7wHVqt?=
 =?us-ascii?Q?NxFDshWoBjAwcrMH9SerMkHU00G71MnfK8wCjUsrg/YP0rLh9wjS3q8xCSO7?=
 =?us-ascii?Q?adQEIwUfrc6u6AZ2UjRTVua0DQEd+59AfqvOA7374RIscctgZy+mxo6qG2Ub?=
 =?us-ascii?Q?1cQKqSlrQmMZtREFZeQJ0em3CQFu+K5O3I0uIUnPGSHr6+i+k9rRMkJTfT8U?=
 =?us-ascii?Q?pRzffgH/6YbRE5V8hmOX6hG0YH66Jf9DogJQVIik2vZI+2yWa6SXC2bbkNtp?=
 =?us-ascii?Q?NrGzgct6awpzwVfaNbpzct1uarooYSrYtdoWyoU57weCbqjRqw1mURhDGcvc?=
 =?us-ascii?Q?ahghFdiC+SZ+6L5uiyYvVmDPAWfiKUCAixa2dPnqcsA++1H0kuvPTtqa1tfj?=
 =?us-ascii?Q?YYHk8AdVmgOOrnG12NpuO1gmBTzO4gs4nnuSu5S82om3aOoiGOdh9xItbiJ6?=
 =?us-ascii?Q?zzaK82brL2z1ZuVzgWxtBPy+CrdADV3dH0nNzOeRxTWqfVxOc/64d6c9OEAE?=
 =?us-ascii?Q?0TBzg3aSgOMK8g/1u7Xw8rpZTk2JUihQ8hFEFhWJZS+m84A6VZq0IXpPUbnJ?=
 =?us-ascii?Q?R9cN0t08mtlt4+AM0BZW5/FVMFuBqPTibYs+UepXNrbxGDgZ+3CTwetdXJiD?=
 =?us-ascii?Q?MwUqkvejcVPrnz4yzKxxIWQTxzpsmAj2T23uas+NZYjnFGGb75ortno/CZq+?=
 =?us-ascii?Q?ir8s6B9/aPscKfFMVmRJzkINqGRz5P5cBicEJx0w1eO5Sj8rJun0wmVFGiBn?=
 =?us-ascii?Q?rQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a5c91ca-6f73-4aa3-566d-08db68e8a4ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2023 12:54:20.8296
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A41nV1pw3snTm5opuo6/PtAE7g/0QevMW9zGafvE6b2PU2tj45uiruvEFr9lHdAFHGs1EJrkU038eYa9I7m4W5NpTzCiMg7FrKW8XkE9io0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8194
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Thursday, May 4, 2023 11:21 PM
>
>On Thu, 27 Apr 2023 17:20:03 -0700 Vadim Fedorenko wrote:
>> +/**
>> + * struct dpll_pin - structure for a dpll pin
>> + * @idx:		unique idx given by alloc on global pin's XA
>> + * @dev_driver_id:	id given by dev driver
>> + * @clock_id:		clock_id of creator
>> + * @module:		module of creator
>> + * @dpll_refs:		hold referencees to dplls that pin is registered
>with
>> + * @pin_refs:		hold references to pins that pin is registered with
>> + * @prop:		properties given by registerer
>> + * @rclk_dev_name:	holds name of device when pin can recover clock
>from it
>> + * @refcount:		refcount
>> + **/
>> +struct dpll_pin {
>> +	u32 id;
>> +	u32 pin_idx;
>> +	u64 clock_id;
>> +	struct module *module;
>> +	struct xarray dpll_refs;
>> +	struct xarray parent_refs;
>> +	struct dpll_pin_properties prop;
>> +	char *rclk_dev_name;
>> +	refcount_t refcount;
>> +};
>
>The kdoc for structures is quite out of date, please run
>./scripts/kernel-doc -none $DPLL_FILES
>

Done.

>> +/**
>> + * dpll_device_notify - notify on dpll device change
>> + * @dpll: dpll device pointer
>> + * @attr: changed attribute
>> + *
>> + * Broadcast event to the netlink multicast registered listeners.
>> + *
>> + * Return:
>> + * * 0 - success
>> + * * negative - error
>> + */
>
>Let's move the kdoc to the implementation. I believe that's
>the preferred kernel coding style.

Sure, fixed.

Thank you,
Arkadiusz

