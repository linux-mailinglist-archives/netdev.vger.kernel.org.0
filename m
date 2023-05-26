Return-Path: <netdev+bounces-5616-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A375671244A
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:14:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E5181C20F51
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8BD5156CB;
	Fri, 26 May 2023 10:14:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94508107B6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:14:08 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE0EA9;
	Fri, 26 May 2023 03:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685096046; x=1716632046;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oku5KHDUS+STydP/bb4c7CjvlczLve9OOgBXz74xUrw=;
  b=SMifH5YOvO4/LcnFdyPamuL37gRm/sx3GOnBa55Ooomb6sUA1121Gxai
   gRuIvxjLM63pm6hLmKAjgjesMPLU5ibnps2DTvxuHDvkv3TuWYGtWr4jj
   KHZ9C5xzO/tAM7LRFn5L7oyqtx/F0jLRLVY2IUn4QkFgxje2ZdzWBajTA
   M9CYUybRL2S7H+wXRnrqfvKxcGSN13cXeCnVtsX1/uUBumDif7lZWdTDK
   Gr8kFhI1otoaXzCvFqpgsWKNtLLCAo9HxSWWIsXzIY0EkB/Sq/wT3YOP8
   t2ikH9h2GyAGFMqPzZif7aSYNkGl0P0/ejsvdgHSWDRkq5LnXuFNgt8ch
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="417654375"
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="417654375"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 03:14:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="738207913"
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="738207913"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 26 May 2023 03:14:05 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 26 May 2023 03:14:04 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 26 May 2023 03:14:04 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 26 May 2023 03:14:04 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 26 May 2023 03:14:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fWf5aUr3MxDZjOGb0FawcptVtSLLaz83YRWWOrBD2xatNfFVvn63GEYATZZX0qWU8d0hfXfjbjude/dKbA0GxTxIdFgQRcTnHDvDbBIfRLN/fcEGWV1417/cYinGZSSvZVah3Dykr4mSrwziNrXO/vU/rp3lu0aZaW7PYpPCOCBKNqQaYa8YmeRXmekIZoXFZCR3ZoAnq0HNhrIIFCfdzPL0SJtClgrOHsxrwEV7yxKzvd3fNbbSAV/g3//M4mGyiFiFYQyC9eXX6wj9LShhkfOUkPhwhy1eB+yadvSVkBBuS8xnJnmteGMm/q1x8hbj+LPR91pHzxiEB5QqP8oKvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1S1RQBles9MRgXJEmcLrykiMp1FnTGnYMEBsKhmS1s=;
 b=WZXwzRNmQq+2itdaCaxQ7siRTi1FJHhwTSJ/GpjL/PMvPfDOnDyy4mYsTcZdXCvzoswRgSqj1UsVKx+Oq6sVLVg+WvV23yKWWm0kBy1ZIX+AzBHTgDFC3B954ICun/OHTh9M8sIKqf2vh5hl3y6Olwcn+grgu6ePyEOOkUJ+1gLWkexx3PGtGtStlDq8Yn41435/C9bEFjUiXo/hsmjFYd463FbjSNVM2YxA2x4p2oCwnJiSweqY+UYYMOXIHZElk2BpTHFY81c2cCLPg0nGKf60+s0m57jHPSlV6EBVttY7kkHOYB0TCWYqJ+ffN3iMkFRCaGLXgfjnBTUSJ1a4ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 CH0PR11MB8191.namprd11.prod.outlook.com (2603:10b6:610:181::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.19; Fri, 26 May
 2023 10:14:02 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e%6]) with mapi id 15.20.6433.018; Fri, 26 May 2023
 10:14:01 +0000
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
Thread-Index: AQHZeWdMwpT4Id4KhEupVVmmO03v069eXxSAgA4cjJA=
Date: Fri, 26 May 2023 10:14:00 +0000
Message-ID: <DM6PR11MB46572080791FCA02107289549B479@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <ZGSp/XRLExRqOKQs@nanopsycho>
In-Reply-To: <ZGSp/XRLExRqOKQs@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|CH0PR11MB8191:EE_
x-ms-office365-filtering-correlation-id: 96df3d69-56b7-4842-b4f6-08db5dd1ed11
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Io/rsdm336SLyNUB1YFgdiUOH9qvyV71GrEos+sLYI9mrwdW8FcwbnnqdRM17LS+Fusg+Ls5ieA1/tItMkmLfMekT3P/okBsWad8BFoOtmzezRSkRtLN2BHIto5has2tXdokmbkvUcMr/+WOtiwP8X1BD+afM0FDzhGszjJP9Fc1JJdqIN1+zoW2y10Tbi2xExjPuinlByR+G3SZC6lQ2MOAY0L1zyVOqj144c52pWHFrGt90l92RLkpeb9vVBmUZShUUKj9eioJMOm9Nu8/CaKJbdMFcUPqaW4H+vxhPv4Rn9cZJQ3TftJWdH7NmCo0lSRN5OK5XFxWzwoDyTgxWgCFyDG0w4SnPL16JXTKdTj3J1hEQdHZYskkKLQjh4AAA8Z4FLws9qhtkb0/dikz3tmDJf8nMQURQGQ3qgQjwpdbN8ezf+u5hZ3r/OgpZA6eEECM5dc/QaUGlJ/ceDCoIMn05UHeW1Ip2RO709vVrM7AaT6YyBRHOKy+rZw6uw6YxiCxGCLdK2j905Ngp4lS1d/gffdghNbXYbISfqiKKNaIQtWXETznj6WO2CnWADls9zaXF+fZ/dmshTAwi6GUvhZVZMkjP4X2O+ZAHN2UneY9h60XRPl2Sx3eZH46s761sPs2aflW3bAVHcQMrm45Ag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(376002)(39860400002)(136003)(396003)(451199021)(41300700001)(38100700002)(316002)(7696005)(8936002)(8676002)(38070700005)(33656002)(86362001)(186003)(2906002)(7416002)(5660300002)(83380400001)(52536014)(9686003)(6506007)(26005)(55016003)(478600001)(66556008)(66476007)(66446008)(64756008)(66946007)(76116006)(110136005)(54906003)(122000001)(4326008)(71200400001)(82960400001)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9bMn5Rp7KGLx2ytPZRaEnRAO0v1GRQg1SyCeGakCJ+zpmYTqw/9kVAHTbv/r?=
 =?us-ascii?Q?PxZQwic86G8rvxrMnVKxM2mYhb0uIw4pnO5Ss2gNbPgaL09B6/qwRtdKGoxJ?=
 =?us-ascii?Q?DQuR0x+oymBiEbA/RM7q0OBdbyVSLfqouq0rV36h4Aq3GUC+neG5f6rpQTS/?=
 =?us-ascii?Q?gCe9IQWevksYd7NselNshTkog7t6CwvWkl0kmAiPZMxLBwTSyJ6ZCgJCQsGM?=
 =?us-ascii?Q?TgC7FKkrZOvaFj2fRirbmWMdTlomBWzK9m9O52bvjlSqbz4CFIjH84JNhDpY?=
 =?us-ascii?Q?0wCrUN9te7F+3Md/WTbNUYGtS28fF5UfUTCo2ecicwHQA5bZ0VrXkIThfSKB?=
 =?us-ascii?Q?yOVmky6nf2N1YDM/9Vir5u2Yw3bV1MXziIF/mh0k01DEcTBk+KUtgtPyVauT?=
 =?us-ascii?Q?pYEp2MiH0QZjsDTmLJrUqvhfBdWpDbLmptqfOV//4xo+gaHHOKr/E0vxDQrT?=
 =?us-ascii?Q?TqCutK44AFRBTUbeXkG/ZDECIYvqPcdhrqWq3+rX7oxXvtkuoF23UUUFN9Y1?=
 =?us-ascii?Q?Qp0leg1EdIc+bgiPDe2L8h1UWEExq+ZQeAmiRwcnQE1HhGjMAXNkmp2+Y5k5?=
 =?us-ascii?Q?00uXtfdh4/JvOAulBulBZivGakHUOw8BMv4QWzONjHL+vLb6xCLQ98SNA+SO?=
 =?us-ascii?Q?guwasvMiz9gEj9Z8cb4FOj1JIYbYF69cmIAkUY+vYo58lXx0ukpA99q1wihZ?=
 =?us-ascii?Q?nE3skEQTZer0BACuUyZm0EbJ7qoGMXlIR6r9Ny8ejE8g2741cvdxzO+IdAJV?=
 =?us-ascii?Q?/QYb4AtsWMiWFR/ipq5184x7VwLQOln0BLyvA2FaUS3qB/ml/0DjTTih+QjF?=
 =?us-ascii?Q?2B0uha+QOMX/B4yXdQUIZMfwQiFyWMHTNpyJCxf6JWrmhMsXsR8zWw6voROM?=
 =?us-ascii?Q?AHATsS5d21iVM/SUx3mO/rXoNBSSBd4URyGyG0/MVX0DeB7d+2rINyrdWVp7?=
 =?us-ascii?Q?MoWeCpsxlavWbrMqm3BFjM6RsE2ZwGlrO8BEy4bouJecw33O3l7uzvkX2mat?=
 =?us-ascii?Q?q66QGHYb5i8Qi4MUO0COupIx4tokAA6tEISpmrjQ3grPJjZNnrSVLpiC6L03?=
 =?us-ascii?Q?pSfx6UUqMC9qymuik/y1aaHqKK2fbL6Y6sgasWQ+EUxA4MUJrP+LA32WN5p+?=
 =?us-ascii?Q?vR7VJp99mSkaXlbsMcsQq9fxir4O7725gQB0BD4SFKzojRAJvYijLC3gGO6r?=
 =?us-ascii?Q?xKDvpTVzikkkoBIT5EcDG65Pr+giZ3s1j6gymxa0bqrF6JNISfk8sXsAjdye?=
 =?us-ascii?Q?/M+i6f6HB7lK+xIRzuXP0D6iOkG72X3QVFY0GH0XrHrclUT878nEjSg2gI+G?=
 =?us-ascii?Q?d9YJqOFUemHt6UGT/lnaTaPz5SK6LWKyw9dRpmKqla7bAy5+Zdx6KHfZn34c?=
 =?us-ascii?Q?ztD4V/Jxfix5KQcToorIhxxyckfqnqkogmSpSEdzM4HYKYJKNeUP38parLmR?=
 =?us-ascii?Q?85VhL20LSjafedxQ7lO2eX7vBevw6nZgfkslRUKjEAohyYmPYNMK84myCC+4?=
 =?us-ascii?Q?3dBXQrBjxONGgCXSdT+NO5IICJywl9d8aoyCjNMGUdTljeikpdeAFwcS1Vk3?=
 =?us-ascii?Q?9CmvYlk1nn26MPCSYttnWV7gDAnkErR1a8aKAtE7/te4B1xtJ5jc5K9ACgdw?=
 =?us-ascii?Q?8Q=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 96df3d69-56b7-4842-b4f6-08db5dd1ed11
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2023 10:14:00.9435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YuU9Bvgpdy5DrlTnfn8w0ctJG32vaGzRjh9M2RecP7OPTmrulrHrL9cnLtU/GUuba+yxmXZMsXQwSiVEHnNCMkOdny0Sht85N6nS0BFXvqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8191
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Wednesday, May 17, 2023 12:19 PM
>
>Let me summarize the outcome of the discussion between me and Jakub
>regarding attributes, handles and ID lookups in the RFCv7 thread:
>
>--------------------------------------------------------------
>** Needed changes for RFCv8 **
>
>1) No scoped indexes.
>   The indexes passed from driver to dpll core during call of:
>        dpll_device_get() - device_idx
>        dpll_pin_get() - pin_idx
>   should be for INTERNAL kernel use only and NOT EXPOSED over uapi.
>   Therefore following attributes need to be removed:
>   DPLL_A_PIN_IDX
>   DPLL_A_PIN_PARENT_IDX
>

Seems doable.
So just to be clear, configuring a pin-pair (MUXed pins) will now be done
with DPLL_A_PIN_PARENT nested attribute.
I.e. configuring state of pin on parent:
DPLL_CMD_PIN_SET
	DPLL_A_PIN_ID		(id of pin being configured)
	DPLL_A_PIN_PARENT	(nested)
		DPLL_A_PIN_ID	(id of parent pin)
		DPLL_A_PIN_STATE(expected state)
		...		(other pin-pair attributes to be set)

Is that ok, or we need separated attribute like DPLL_A_PIN_PARENT_ID??
I think there is no need for separated one, documentation shall just reflec=
t
that.
Also we have nested attribute DPLL_A_DEVICE which is used to show connectio=
ns
between PIN and multiple dpll devices, to make it consistent I will rename
it to `DPLL_A_DEVICE_PARENT` and make configuration set cmd for the pin-dpl=
l
pair similar to the above:
DPLL_CMD_PIN_SET
	DPLL_A_PIN_ID		(id of pin being configured)
	DPLL_A_DEVICE_PARENT	(nested)
		DPLL_A_ID	(id of parent dpll)
		DPLL_A_PIN_STATE(expected state)
		...		(other pin-dpll attributes to be set)

Does it make sense?


>2) For device, the handle will be DPLL_A_ID =3D=3D dpll->id.
>   This will be the only handle for device for every
>   device related GET, SET command and every device related notification.
>   Note: this ID is not deterministing and may be different depending on
>   order of device probes etc.
>

Seems doable.

>3) For pin, the handle will be DPLL_A_PIN_ID =3D=3D pin->id
>   This will be the only handle for pin for every
>   pin related GET, SET command and every pin related notification.
>   Note: this ID is not deterministing and may be different depending on
>   order of device probes etc.
>

Seems doable.

>4) Remove attribute:
>   DPLL_A_PIN_LABEL
>   and replace it with:
>   DPLL_A_PIN_PANEL_LABEL (string)
>   DPLL_A_PIN_XXX (string)
>   where XXX is a label type, like for example:
>     DPLL_A_PIN_BOARD_LABEL
>     DPLL_A_PIN_BOARD_TRACE
>     DPLL_A_PIN_PACKAGE_PIN
>

Sorry, I don't get this idea, what are those types?
What are they for?

>5) Make sure you expose following attributes for every device and
>   pin GET/DUMP command reply message:
>   DPLL_A_MODULE_NAME
>   DPLL_A_CLOCK_ID
>

Seems doable.

>6) Remove attributes:
>   DPLL_A_DEV_NAME
>   DPLL_A_BUS_NAME
>   as they no longer have any value and do no make sense (even in RFCv7)
>

Seems doable.

>
>--------------------------------------------------------------
>** Lookup commands **
>
>Basically these would allow user to query DEVICE_ID and PIN_ID
>according to provided atributes (see examples below).
>
>These would be from my perspective optional for this patchsets.
>I believe we can do it as follow-up if needed. For example for mlx5
>I don't have usecase for it, since I can consistently get PIN_ID
>using RT netlink for given netdev. But I can imagine that for non-SyncE
>dpll driver this would make sense to have.
>
>1) Introduce CMD_GET_ID - query the kernel for a dpll device
>                          specified by given attrs
>   Example:
>   -> DPLL_A_MODULE_NAME
>      DPLL_A_CLOCK_ID
>      DPLL_A_TYPE
>   <- DPLL_A_ID
>   Example:
>   -> DPLL_A_MODULE_NAME
>      DPLL_A_CLOCK_ID
>   <- DPLL_A_ID
>   Example:
>   -> DPLL_A_MODULE_NAME
>   <- -EINVAL (Extack: "multiple devices matched")
>
>   If user passes a subset of attrs which would not result in
>   a single match, kernel returns -EINVAL and proper extack message.
>

Seems ok.

>2) Introduce CMD_GET_PIN_ID - query the kernel for a dpll pin
>                              specified by given attrs
>   Example:
>   -> DPLL_A_MODULE_NAME
>      DPLL_A_CLOCK_ID
>      DPLL_A_PIN_TYPE
>      DPLL_A_PIN_PANEL_LABEL
>   <- DPLL_A_PIN_ID
>   Example:
>   -> DPLL_A_MODULE_NAME
>      DPLL_A_CLOCK_ID
>   <- DPLL_A_PIN_ID    (There was only one pin for given module/clock_id)
>   Example:
>   -> DPLL_A_MODULE_NAME
>      DPLL_A_CLOCK_ID
>   <- -EINVAL (Extack: "multiple pins matched")
>
>   If user passes a subset of attrs which would not result in
>   a single match, kernel returns -EINVAL and proper extack message.


Seems ok.

Will try to implement those now.

Thank you,
Arkadiusz

