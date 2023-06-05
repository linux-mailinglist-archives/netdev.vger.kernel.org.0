Return-Path: <netdev+bounces-7946-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54F3F7222ED
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:07:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A63C328126B
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02111156C9;
	Mon,  5 Jun 2023 10:07:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04375684
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 10:07:10 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52131DF;
	Mon,  5 Jun 2023 03:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685959629; x=1717495629;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+mRyqVSwIxawmUyerq3HAIPe6kNjauPExnc9wx+YFFs=;
  b=CGpPha6OkWDdZvts4QTBJkGs4Hswt7Tp2TuqHp42dLB/5Skz5I9KinCC
   ht4dHdJAMYZzH3QTkjkIUg7l16agTQPv21uUgcGifeNkNfMTJoBJ81whB
   4AzvHM2MYCFA2I7Y/dFD6/UdfRBkfHxxBSAQ5Ec1Py7OQmEJKZsku6N3l
   RVi9rug+4UV+fZ8AICW6h+HeK7pHJsjzmUgAy22watQ0V2CIAjs7LuTUi
   yj0v7zVV7zbgi8mlTTd4QE2vyQqtrPeKfmsAIhSfRkajN56x23q+Y5hOf
   wUlqM8+Jp87bg9zIWwFpMSWZYIr3xDtCqDXKSpRuL5V7IWvZQOpLqnLqm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="336686640"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="336686640"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 03:07:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="882850347"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="882850347"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 05 Jun 2023 03:07:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 03:07:04 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 03:07:04 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 03:07:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lzwO8sGfsGM8fB20EZDr7fPfiKv7lr/OdRj8x01kGULhKKpOjHdpvqunFJidwUh0/GfDnS1uJEJA0Fek3+G0XIY+yxO+18Cwcjj0N6kh5EgzUiTnowjLWXBz8e2CnHCzqUYV/DYug14N8QUuYqK+ncjxp00xKxVeu/ylQZvfnaGFrRLiL5JotB2zXtRt3lnlrcztg++G6jlI/StWqAkdesHf09erlTiMmJYtGt/EmFyydL411m4EroulqzyvQKDxx7Rnfs3icW3XgAYPf8JhCa+Hw8frBeM9V28vkEkzRWWmZaw05qXTRAClIECpm/UGHzAB7nAr7Y6rVvAmHJvaxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LJN3D+2r6RqlpR/WTz0+Vs3bAK+Uar7RdBioWmh+U34=;
 b=VV1dWR3aReW5tK1jG0ncvJn13JXAGX+kk+36t+E2ZlgrlE787608fxudpxzf41L/y4rg8GVEUWRdzcdos68nYOe5xOK1+FFyAjaak7CVHAaF6hrmQnBbjavNEsXV9RpW39akoXAhVCSnNnAC+nmxUt8D8yLwSBU/d6Q8YgVx2pd23/5kmEZLPJZuCUVqu/VL0UqFm1IZ9cfG2l4Fqf9Yy/4NOp4dVuAPcThY5mqbc7uTxj4RI7dj7VyzHlVBUo1rkVdX3A9CTB1CxlkOcvtLhuR8cHaw++xyv0WMwOoybxb+mq4pRgW18o9A9M8Wn2K+yA+Cm9C7E5IUqf32tYAfvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 PH7PR11MB7480.namprd11.prod.outlook.com (2603:10b6:510:268::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.31; Mon, 5 Jun 2023 10:07:01 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 10:07:01 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>
CC: Vadim Fedorenko <vadfed@meta.com>, Jakub Kicinski <kuba@kernel.org>,
	Jonathan Lemon <jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
	"Olech, Milena" <milena.olech@intel.com>, "Michalik, Michal"
	<michal.michalik@intel.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v7 0/8] Create common DPLL configuration API
Thread-Topic: [RFC PATCH v7 0/8] Create common DPLL configuration API
Thread-Index: AQHZeWdMwpT4Id4KhEupVVmmO03v069eXxSAgA4cjJCAAA5CAIAPrY3A
Date: Mon, 5 Jun 2023 10:07:01 +0000
Message-ID: <DM6PR11MB4657605F659D6E2B9B2C1A219B4DA@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <ZGSp/XRLExRqOKQs@nanopsycho>
 <DM6PR11MB46572080791FCA02107289549B479@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZHCMYJGMYS5a2+Bf@nanopsycho>
In-Reply-To: <ZHCMYJGMYS5a2+Bf@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|PH7PR11MB7480:EE_
x-ms-office365-filtering-correlation-id: f1ad7e2c-9f6c-4ba9-a3dc-08db65ac9b0b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GNoRvTrCkiZzSx7aoo6bwFQq9BUM5tCAYuRgB4kMURjcdCzUGLm6cvM169fLdYHVpnNvgHl3jXfllniFQoYUegacD77XAOOYB1sd0KNT84CibdngUw5R3rRTrPm2QccY+7Yb2vcSvxypuAAX1ybMRKHyNyY/P2Ha546OcM3pmqFWC/PiPWKJ8I1Ylm7IKu2jjwMI6TBYXWA8VIAOg8shg71S2qWBSaZLi1h6GjU3M+w7e8zL8XEfDMPZDPP49LojsfpMIDCblyKdbWkpD22eBGt2cb2MF7QhVZWLRuiukkRxcUFrhyjbMWkAOXmqpmeXu7M58pIhIpGObSiuSxclYq/shDytuN2DASagTRW/gnRnC6gLzWUq7etoc3HVKAQJEgAjGoNt2DYDRfKtpJ3/43Va3LGRsKaLGmwSbgMoaY6nfgbYmjIGmY10zZ1+ZkziqqpB+VocUkV33OvJR85NBe6eobh/iZI8cEFJIxnVNaCsSEdnU957d4MzCAfOo+yt4o0yqO3oPIBsTOEK4dSNWRku5fUIhoH4JWnkBJBiKSE3j/BjlLoAfHS1r9iVLRL4IcvEcioivIo8EhT395ky6jMjsfpqCH78ib1f3iYbIMvt3VLNz9kGe0V/OXCG6mSujBZ0jiSJt5NoNCthpMTYIg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(366004)(396003)(136003)(451199021)(8676002)(8936002)(66446008)(76116006)(66476007)(52536014)(5660300002)(64756008)(66946007)(66556008)(55016003)(7416002)(54906003)(316002)(4326008)(41300700001)(6916009)(186003)(2906002)(478600001)(82960400001)(122000001)(38100700002)(9686003)(26005)(6506007)(86362001)(33656002)(71200400001)(7696005)(38070700005)(83380400001)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GEi7q3P/jp7/HE7A4ACk8rySPJoCtzdcQndyJoNvgIfq9kS6WaH9/ArjgWh8?=
 =?us-ascii?Q?aYV9jlJT95JMzRzQVxdGyZ5UisXzVwT7XIXu42Raa22nNOiTbGNzNDLPfc92?=
 =?us-ascii?Q?LRtd4KhyELR7sA8KAcJ7OwTk/dmeA/BaUzNknc8qagUrWXGI2DhArbSjTkAV?=
 =?us-ascii?Q?sPGLNb9vsoxwW3dQCJyxaair5YlqHQcusoiaXaMePMdb+Z/vN6XvOfOTxim2?=
 =?us-ascii?Q?BEYPx9H4SSedcSn8axSO+sdT1RbFYqg1TrletcvP8AJAWZOn9gGeGFUDaVaE?=
 =?us-ascii?Q?sVb2baacW/ipLLl5Ac1f+t/2LOeoeBm1tpc4fq5iRBjoeaw5U/+slhbakmTb?=
 =?us-ascii?Q?JzNpHnHZlWGy/Dv3sB74dUXQHCtkDqTuGcWqLZRZ56YEOeDcpnXw+db17vrV?=
 =?us-ascii?Q?pKR35S6GqVkf+9TBB7FMO4AAI+5cxWb/+4T0w630U4lfgwELCIeKXfTpYZEh?=
 =?us-ascii?Q?vkrEUCKbWiSRKRLnCmq0gpCn0CkJgJi8R7T4bw6yZYXyK1CJwCuLCwSYO1xr?=
 =?us-ascii?Q?qxHejiEKaxbBq9YK2dql7ao+USaLRJ9V4DIcqKInI/2raQqghEtV/lWbGUxx?=
 =?us-ascii?Q?ToNPWF6WyztnIMbbqk0wR2XF+N1+hRt88gnZxxQdQXIdoqWPf6ATeZeAFoLv?=
 =?us-ascii?Q?63Mpwi8vxgaOSf2hesEyCo+sxSxXyMAoFNKb+GI3gmDcyo7k0/bvoKiXoH31?=
 =?us-ascii?Q?6nqHDleArB3DnOTGfkurLXiEOvyFrkW0JMgASpSh3v5qHZ+jcvbGW/K/Ho0H?=
 =?us-ascii?Q?SQSNxdkFKUgjPzTWFF0BmiDEEnvOISRWNp0UkAbECTDe5YHXNRsp3FY8zCnd?=
 =?us-ascii?Q?Ac3LfpkNKwzLhuTEIIA4pC/orhjZgsVIa0uLWLeo2T7wvDvxdLjiTzzF9AQz?=
 =?us-ascii?Q?80WsIh4OsOV22Ls/KcddmOyrlAgUgnGZS+R/fZh7VX/44XFjuHGZk6XqgEMu?=
 =?us-ascii?Q?PEVjwNzZYESzyE7+2Ja1Np+10/0+ADdI2B8xmpRu5j8OTzfYEVrxhaTEUU4z?=
 =?us-ascii?Q?x++3ujWSNO4AtnyJoC3NZ5WCPlAM/4iVxDtddBERZmkDaNzxH0ov1H9AsH32?=
 =?us-ascii?Q?DPsxzDiILJOHmfXIYQCPeYy+PURPyluOI0RbYXg/ltypk4odu3SUSA6SKIR1?=
 =?us-ascii?Q?x8PAb6M7d2ePA6IyNm9IxIX6d9k6DveUyjIXSSGUatevIgiTy080itwCxwjy?=
 =?us-ascii?Q?phVJpndlVyIHW9PCW32IG5Po6bN5e2GjrriryzbdpkVEuCQ0NUfEeZJ1nxLY?=
 =?us-ascii?Q?u9h9ogiC5mGFeOQACm1ixDJKMWCqAE5p2d+WZjSaGpw/7r0/7pCEzMnEFP/l?=
 =?us-ascii?Q?M9GYuVfc8r7swAmJEajpRIumu4ZF/TTNMTxXsYg9vtA/O+f1oQuLGF6TNXxV?=
 =?us-ascii?Q?1hakLIU2C6XYPHHz1c97MCz3lH2C/XP8XY1IkoSBrZMkgeRqPlXcolK2zPTO?=
 =?us-ascii?Q?iplolD9FNZU5pO92FlOsL9Rw3+boguiwtWnm4eqYRRfH0nkuTTrxMgQa0kwl?=
 =?us-ascii?Q?IDo67CDhM1qVBDLB2flpnnrMx6TR3LUPxWjcLntzWb84ZgP5DCO93Hgo18TF?=
 =?us-ascii?Q?6fmXQnmFKmF4pbN3shoeFP3S1/05kq21AhyKIkws3XKgfrO7yY2w25rR/L8o?=
 =?us-ascii?Q?UQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f1ad7e2c-9f6c-4ba9-a3dc-08db65ac9b0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 10:07:01.2765
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CGw9o/Mi0uIagtoe/ASAitTGRwr5hbcicducfIPH2C8Gq+WXMFa8Mdo7bMQw9JnJsNR+oNOFvyaF7T5LEoTNeTWqUQD2qUQx/SYOFKtrLyw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7480
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Friday, May 26, 2023 12:39 PM
>
>Fri, May 26, 2023 at 12:14:00PM CEST, arkadiusz.kubalewski@intel.com wrote=
:
>>>From: Jiri Pirko <jiri@resnulli.us>
>>>Sent: Wednesday, May 17, 2023 12:19 PM
>>>
>>>Let me summarize the outcome of the discussion between me and Jakub
>>>regarding attributes, handles and ID lookups in the RFCv7 thread:
>>>
>>>--------------------------------------------------------------
>>>** Needed changes for RFCv8 **
>>>
>>>1) No scoped indexes.
>>>   The indexes passed from driver to dpll core during call of:
>>>        dpll_device_get() - device_idx
>>>        dpll_pin_get() - pin_idx
>>>   should be for INTERNAL kernel use only and NOT EXPOSED over uapi.
>>>   Therefore following attributes need to be removed:
>>>   DPLL_A_PIN_IDX
>>>   DPLL_A_PIN_PARENT_IDX
>>>
>>
>>Seems doable.
>>So just to be clear, configuring a pin-pair (MUXed pins) will now be done
>>with DPLL_A_PIN_PARENT nested attribute.
>>I.e. configuring state of pin on parent:
>>DPLL_CMD_PIN_SET
>>	DPLL_A_PIN_ID		(id of pin being configured)
>>	DPLL_A_PIN_PARENT	(nested)
>>		DPLL_A_PIN_ID	(id of parent pin)
>>		DPLL_A_PIN_STATE(expected state)
>>		...		(other pin-pair attributes to be set)
>>
>>Is that ok, or we need separated attribute like DPLL_A_PIN_PARENT_ID??
>>I think there is no need for separated one, documentation shall just
>>reflect that.
>>Also we have nested attribute DPLL_A_DEVICE which is used to show
>connections
>>between PIN and multiple dpll devices, to make it consistent I will renam=
e
>>it to `DPLL_A_DEVICE_PARENT` and make configuration set cmd for the pin-d=
pll
>>pair similar to the above:
>>DPLL_CMD_PIN_SET
>>	DPLL_A_PIN_ID		(id of pin being configured)
>>	DPLL_A_DEVICE_PARENT	(nested)
>
>It is a parent of pin, not device. The name is confusing. But see below.
>
>
>>		DPLL_A_ID	(id of parent dpll)
>>		DPLL_A_PIN_STATE(expected state)
>>		...		(other pin-dpll attributes to be set)
>>
>>Does it make sense?
>
>Yeah, good idea. I like this. We will have consistent approach for
>parent pin and device. To take it even further, we can have one nested
>attr for parent and decide the parent type according to the id attr
>given:
>
>DPLL_CMD_PIN_SET
>	DPLL_A_PIN_ID		(id of pin being configured)
>	DPLL_A_PIN_PARENT	(nested)
>		DPLL_A_PIN_ID	(id of parent pin)
>		DPLL_A_PIN_STATE(expected state)
>		...		(other pin-pair attributes to be set)
>
>DPLL_CMD_PIN_SET
>	DPLL_A_PIN_ID		(id of pin being configured)
>	DPLL_A_PIN_PARENT	(nested)
>		DPLL_A_ID	(id of parent dpll)
>		DPLL_A_PIN_STATE(expected state)
>		...		(other pin-dpll attributes to be set)
>
>
>Same for PIN_GET
>
>Makes sense?
>

Sure, fixed.

>
>
>>
>>
>>>2) For device, the handle will be DPLL_A_ID =3D=3D dpll->id.
>>>   This will be the only handle for device for every
>>>   device related GET, SET command and every device related notification=
.
>>>   Note: this ID is not deterministing and may be different depending on
>>>   order of device probes etc.
>>>
>>
>>Seems doable.
>>
>>>3) For pin, the handle will be DPLL_A_PIN_ID =3D=3D pin->id
>>>   This will be the only handle for pin for every
>>>   pin related GET, SET command and every pin related notification.
>>>   Note: this ID is not deterministing and may be different depending on
>>>   order of device probes etc.
>>>
>>
>>Seems doable.
>>
>>>4) Remove attribute:
>>>   DPLL_A_PIN_LABEL
>>>   and replace it with:
>>>   DPLL_A_PIN_PANEL_LABEL (string)
>>>   DPLL_A_PIN_XXX (string)
>>>   where XXX is a label type, like for example:
>>>     DPLL_A_PIN_BOARD_LABEL
>>>     DPLL_A_PIN_BOARD_TRACE
>>>     DPLL_A_PIN_PACKAGE_PIN
>>>
>>
>>Sorry, I don't get this idea, what are those types?
>>What are they for?
>
>The point is to make the driver developer to think before passing
>randomly constructed label strings. For example, "board_label" would lead
>the developer to check how the pin is labeled on the board. The
>"panel_label" indicates this is label on a panel. Also, developer can
>fill multiple labels for the same pin.
>

Ok, makes sense, added as suggested.

Thank you,
Arkadiusz

>
>
>>
>>>5) Make sure you expose following attributes for every device and
>>>   pin GET/DUMP command reply message:
>>>   DPLL_A_MODULE_NAME
>>>   DPLL_A_CLOCK_ID
>>>
>>
>>Seems doable.
>>
>>>6) Remove attributes:
>>>   DPLL_A_DEV_NAME
>>>   DPLL_A_BUS_NAME
>>>   as they no longer have any value and do no make sense (even in RFCv7)
>>>
>>
>>Seems doable.
>>
>>>
>>>--------------------------------------------------------------
>>>** Lookup commands **
>>>
>>>Basically these would allow user to query DEVICE_ID and PIN_ID
>>>according to provided atributes (see examples below).
>>>
>>>These would be from my perspective optional for this patchsets.
>>>I believe we can do it as follow-up if needed. For example for mlx5
>>>I don't have usecase for it, since I can consistently get PIN_ID
>>>using RT netlink for given netdev. But I can imagine that for non-SyncE
>>>dpll driver this would make sense to have.
>>>
>>>1) Introduce CMD_GET_ID - query the kernel for a dpll device
>>>                          specified by given attrs
>>>   Example:
>>>   -> DPLL_A_MODULE_NAME
>>>      DPLL_A_CLOCK_ID
>>>      DPLL_A_TYPE
>>>   <- DPLL_A_ID
>>>   Example:
>>>   -> DPLL_A_MODULE_NAME
>>>      DPLL_A_CLOCK_ID
>>>   <- DPLL_A_ID
>>>   Example:
>>>   -> DPLL_A_MODULE_NAME
>>>   <- -EINVAL (Extack: "multiple devices matched")
>>>
>>>   If user passes a subset of attrs which would not result in
>>>   a single match, kernel returns -EINVAL and proper extack message.
>>>
>>
>>Seems ok.
>>
>>>2) Introduce CMD_GET_PIN_ID - query the kernel for a dpll pin
>>>                              specified by given attrs
>>>   Example:
>>>   -> DPLL_A_MODULE_NAME
>>>      DPLL_A_CLOCK_ID
>>>      DPLL_A_PIN_TYPE
>>>      DPLL_A_PIN_PANEL_LABEL
>>>   <- DPLL_A_PIN_ID
>>>   Example:
>>>   -> DPLL_A_MODULE_NAME
>>>      DPLL_A_CLOCK_ID
>>>   <- DPLL_A_PIN_ID    (There was only one pin for given module/clock_id=
)
>>>   Example:
>>>   -> DPLL_A_MODULE_NAME
>>>      DPLL_A_CLOCK_ID
>>>   <- -EINVAL (Extack: "multiple pins matched")
>>>
>>>   If user passes a subset of attrs which would not result in
>>>   a single match, kernel returns -EINVAL and proper extack message.
>>
>>
>>Seems ok.
>>
>>Will try to implement those now.
>
>Cool, thx!
>
>
>>
>>Thank you,
>>Arkadiusz

