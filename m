Return-Path: <netdev+bounces-5273-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E340F710836
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 11:01:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55EF91C20C06
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 09:01:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9409D302;
	Thu, 25 May 2023 09:01:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0882BE77
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:01:16 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163FA98;
	Thu, 25 May 2023 02:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685005272; x=1716541272;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WowrIcXJecqIR9pxMwECVEJttudJteYXC11gTuo4qmk=;
  b=djQULr0HppPWPCRvRSFnngNv03Puh2U1rolRc5xmL5DoS+cQ+eE5o97X
   9IFV7HRWxnSlk1lUBPVZ3b55vlfSMfFyAF8lgNQwhe8lA+M4a1imMrG0E
   0PPTcDXade9O7ryh3Ds+gmX4ff7a8qAeekR477oJlj3lkqFYBKnOLCLG+
   V5I3UdP0KSmuqRPgBou5Y6AfSnowrdLrkOQRSHlqwF/g1IAaXExc5HH0S
   PfbshTLrjM/tP6OD0NM62wPvG0l1Drz5kTfCUNjrwamco6bZAvQBLM+u3
   mNevlot0MPKkufPHYI2rILzPz+DFQIvEdxa0e0rhd/nnDb5NJjat1YcUJ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="333451985"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="333451985"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 02:01:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="769803475"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="769803475"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 25 May 2023 02:01:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 02:01:10 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 02:01:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 25 May 2023 02:01:10 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 25 May 2023 02:01:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Auvv67g+ERCZoH0pNGcJY2dpFX8JHAbw4w/4jNPPb2f0ScCkoa0Hvfj5eeYw0MBnhyWlWORKTztfg1Oi2Hx+GOc7T35wNsbd0LC/qyVkQhTeEK3GS7DhQ44tFGI9J+uH3T/gEZvjp9SayURR21TSV1asJY3iZdMBHZu6chAD2MqKxSNfUcYgbeWNiqTYr8GyC6ZnPsTHXOlYrl/YyCXtSiU56HGf+FW+29TfxoSGOaJynLpc1pKn1eQhmn1Ey/H4ytcdm8j5/VnKVnssmRZPviGc38VwQ5r1WnxDOt6HasNhTYT9gYj/aFu4q7vCZ4IHh1cmrtTBfza+n+7mlTpLLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/jK4zMeJB5bER33E9ZBydrDzcSwADDsMg+YedpC3wsQ=;
 b=B4LpoO5F4QTvXe/7PkJZDqJMBG/VPpNLGYVeqZoyCc76ViN1cODOJP2pKRcphkE21rCMT1se97z3WZxpyFgtJJdOdKapVZTGUSh3cEW0oVXO/NygewIVcGLfuaU1aTP8FZQLYaLDgC0JZYkjD7OSsW8EytwfXuvjkjeWYE5VDnYb9J2iDljcvGRnbbqlZ2d/peRd1jSSpzmVRLNSgmsazZ0ipqeCm+qhAJfb0SaVJDKZ2oWVasKgeJrpscWC38J208qdZ22e/f9ZhfPaHMaa9V1aLkjyXiQkVZfYu9LXS9rAITQtMy4LGRXIKO7K8vNglVGS6uyLzH3FXyWHlP6kIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DM4PR11MB6019.namprd11.prod.outlook.com (2603:10b6:8:60::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.16; Thu, 25 May 2023 09:01:08 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e%6]) with mapi id 15.20.6433.015; Thu, 25 May 2023
 09:01:07 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>
CC: Vadim Fedorenko <vadfed@meta.com>, Jakub Kicinski <kuba@kernel.org>,
	Jonathan Lemon <jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
	"Olech, Milena" <milena.olech@intel.com>, "Michalik, Michal"
	<michal.michalik@intel.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v7 5/8] ice: implement dpll interface to control cgu
Thread-Topic: [RFC PATCH v7 5/8] ice: implement dpll interface to control cgu
Thread-Index: AQHZeWdQDnOnlwLdVUynBqrraL/3s69If/yAgBOAjACAAItZgIADxo+ggADtUgCACZujwA==
Date: Thu, 25 May 2023 09:01:07 +0000
Message-ID: <DM6PR11MB4657BBAED47B49A5C58B6E069B469@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-6-vadfed@meta.com> <ZFJRIY1HM64gFo3a@nanopsycho>
 <DM6PR11MB4657EAF163220617A94154A39B789@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZGMiE1ByArIr8ARB@nanopsycho>
 <DM6PR11MB4657F542DD71F61FD2A1C20B9B7F9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZGcT9tx/xsKGVYBU@nanopsycho>
In-Reply-To: <ZGcT9tx/xsKGVYBU@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|DM4PR11MB6019:EE_
x-ms-office365-filtering-correlation-id: ee971834-d0fe-455a-71a0-08db5cfe93fa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0A6UwufTfrB44qmb65VOYEtAyYlreHuJb9MMHlEsD1CwGtjKk7sCN4LgnGKv6hReXUxEUAyjCHJJJDPg0vOtcvME9RGfuA/ErDeF7hqhv1FY/8VrQif5rDm+c1YFwfskfBtAC+CN7DLVeS2bSy25MBnnOQXPfnv9arIT+A0ooPTSwf8DiNzdBAAVf8idA/wW+IHp5AWGZa+FXuoJKQBYitfwLEA9nInD/7lOOnYrgPLXV5mp5z10/Y8DIgLKmEv8McEjfRmO0IAqgbGSN4GoMS37gES/eIsbFxdyFKTg2iDmqOP0KlCGWIQM1uZeppmx+Glv8f6tuPdKBWVSkvliGJullQFsjVCdn5+PX4gG05Dc4Ve0qoycf0kL4toBFEJWrmwi5FbE0pd1CzLNaA5n33UalRn3SKyVV01fmQkAzhdkJ/OwrYVPskTYeJHdUO6OVWuxUWnzXMw9Ncy9s0IAgeLH1CQ9sgOAG/zMX+aTIvW5+Bz24m8XL1WYW9W240iVzDcx/vFh3jsjYub67SEO0Ad29z2oR7sEIRxN0Prp3zPxfL91C0sinMabA9qVyPh2uOLpXNqyPN3wOquhroizGFPoQGq1dB9MxWZ6u5xN9jjrf8bY63FrsKXEW+Vzn7OR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(39860400002)(346002)(136003)(396003)(451199021)(6916009)(66446008)(66946007)(66556008)(66476007)(64756008)(76116006)(478600001)(54906003)(4326008)(316002)(38070700005)(33656002)(86362001)(83380400001)(9686003)(6506007)(26005)(186003)(41300700001)(5660300002)(8936002)(8676002)(52536014)(7416002)(2906002)(7696005)(71200400001)(55016003)(38100700002)(82960400001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?D1qGxZ5swmQ+dXsvJCA9Cwp1anQwgk/42c8RfctHNo76hI27fD4JmcoZG2r2?=
 =?us-ascii?Q?9ofPNgqyhyxrzs1+/6lgQeEwM2W5QChHibg7YR2Yvl4eEPy8qbT4wv/FdoDP?=
 =?us-ascii?Q?oPvOxSbFIyxvsQznP2vmWFnrBFJT079CKIsTu4UtPp8K2i+yqa19vrZfVy1I?=
 =?us-ascii?Q?+ig/rJq+gok99axlOqfy/9lqJZcjdhxmgAqTVnNEkjZ58XbCIVbMDR0wyt9Y?=
 =?us-ascii?Q?/E9oJBM2pM3yBS98CWrn/Kyef0dtxuMhY+mEEr4eCfwxZV0ZEa8RYZw6SzYo?=
 =?us-ascii?Q?a2qRXik77R2ISCizSGfgEng0xS1C3lU05n4aV95IQTzVDXDFOgD0Ci2PU2yH?=
 =?us-ascii?Q?tRKXrc4t9b57InJQjisMXTMC1RlxWdpCzhuOg8Bq4E4SktYnq3rLXhNmUHno?=
 =?us-ascii?Q?3FlNUf1m0RMgJsox87ZIQYnHRYZU4G0kwEBK6JLbw8jtIxZSLO7VrZcwYgMk?=
 =?us-ascii?Q?WKoGVWOTyNaMOgz2pysfmi2vAXxKj4nRs+yFyPzj9ggiaVpZW1umJXMWFKuN?=
 =?us-ascii?Q?tlT3ngeDAbk3dXw3+GPmiNZ9aGSLMRvkOsMDlE0hAp3pgJ01ISPTQx069Hf2?=
 =?us-ascii?Q?lXEvWR3mceVCR9kCdrhRRWhHswCNKMlngiGFrqwlmYMaOKb6vn05c/+J2x6P?=
 =?us-ascii?Q?I5jlgb1UbiFWf27FKA6kZqa2mk9ISw/GCAxBKo/B7PbRNPwbk/2dRuVu4Gl+?=
 =?us-ascii?Q?QQc2zCdI6DQsicyDv311+kD/QC5FDO4SQhkVFRhQFqd8laUbeKvMQ4MsbGj/?=
 =?us-ascii?Q?iIrqtckckrBbMjfNuN0aonoNA3xPGlBX5ac6yYKsy3DpbwHOWSkMXCKo2h0o?=
 =?us-ascii?Q?0MedPjea9S+3HiSS+n5/XEFNbjsne4TeIKVmaLBCwABhi4nJQZTSg8UTuOrI?=
 =?us-ascii?Q?oLQQppo0Oz+0F56XBZmZiNsnt2pFgixHPtNuzbiHsGwVyvVy6zPyculKaC/M?=
 =?us-ascii?Q?jg0s04jTj7t8JO38oRTOsxgvR5Nf2XZLmOkDrsCx7qxstWMB2CuapsA2QXAK?=
 =?us-ascii?Q?7DIaHaZ8zIRUe+yQGci2lr7MiEuOshlcQbaC6GowS81UH3WpIqWGi8GtIeCv?=
 =?us-ascii?Q?0gZHzVO5yRUqTv/fAs6XkldHXVh94+s7dHedyui9iOsPKZ+CQ+rnyYDdDiev?=
 =?us-ascii?Q?wekhNLj+XhZ6clNmozprDRiXmslmBO9bN2NsZIXRuYNR/v6iHuL61X2QhDZO?=
 =?us-ascii?Q?SEGlPdl8JNlrVEgo9sWcbPJ/IPGpThaL9ayaIWrcamMrJLqUkCgi8eeS3lJT?=
 =?us-ascii?Q?fh7GkxzLtT5FxFBaEUBa1VD3UTy/mZlCuOUzqnf6KPXKcp8C3zbN2ZQIimKD?=
 =?us-ascii?Q?s3JOaTJavZN07kotgX/6w7NxfnyQpG+cwxFB+0p+rCtOpghvipFjRtRFXWJ2?=
 =?us-ascii?Q?jiqtVzjS1b64C98AR6WU2tcDMEO6oo3SxeptnRXSWlUuc5Dzs3H08hljif7Q?=
 =?us-ascii?Q?b5SHF/3UlIdwtE7O/fOmljhcXNjqnTwGJg++MwH6Fuzhl8iyC5Ir3amVDw43?=
 =?us-ascii?Q?qkPO0fc/l5XdtRV5jgSNoqIU6izKROAmYC3CC6qtGlA68Z+3vUWnBfB42Ngv?=
 =?us-ascii?Q?RWSHrh+OXaRwA+cIWtLwu8OcUWb8SDouPmRmtMNU2qWNIyFU5/Qrj7vutNcY?=
 =?us-ascii?Q?8w=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ee971834-d0fe-455a-71a0-08db5cfe93fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2023 09:01:07.7132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L2MtORcP6hT3AV7zyNkr+wAOmxGSi8Wu+Pz4VXe0h02G1us8Wl0Ad/9nojvoXmGwZb2rJglObRj3YCIIret6Lat6nLslYjZcus4MH1UA9zA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6019
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Friday, May 19, 2023 8:15 AM
>
>Thu, May 18, 2023 at 06:06:03PM CEST, arkadiusz.kubalewski@intel.com wrote=
:
>>>From: Jiri Pirko <jiri@resnulli.us>
>>>Sent: Tuesday, May 16, 2023 8:26 AM
>>>
>>>Tue, May 16, 2023 at 12:07:57AM CEST, arkadiusz.kubalewski@intel.com
>>>wrote:
>>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>>Sent: Wednesday, May 3, 2023 2:19 PM
>>>>>
>>>>>Fri, Apr 28, 2023 at 02:20:06AM CEST, vadfed@meta.com wrote:
>>>>>>From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>
>[...]
>
>
>>>>>>+			pins[i].pin =3D NULL;
>>>>>>+			return -ENOMEM;
>>>>>>+		}
>>>>>>+		if (cgu) {
>>>>>>+			ret =3D dpll_pin_register(pf->dplls.eec.dpll,
>>>>>>+						pins[i].pin,
>>>>>>+						ops, pf, NULL);
>>>>>>+			if (ret)
>>>>>>+				return ret;
>>>>>>+			ret =3D dpll_pin_register(pf->dplls.pps.dpll,
>>>>>>+						pins[i].pin,
>>>>>>+						ops, pf, NULL);
>>>>>>+			if (ret)
>>>>>>+				return ret;
>>>>>
>>>>>You have to call dpll_pin_unregister(pf->dplls.eec.dpll, pins[i].pin,
>>>>>..)
>>>>>here.
>>>>>
>>>>
>>>>No, in case of error, the caller releases everything
>>>ice_dpll_release_all(..).
>>>
>>>
>>>How does ice_dpll_release_all() where you failed? If you need to
>>>unregister one or both or none? I know that in ice you have odd ways to
>>>handle error paths in general, but this one clearly seems to be broken.
>>>
>>
>>It doesn't have to, as release all would release all anyway.
>>Leaving it for now.
>
>So you call dpll_pin_unregister() even for the pin that was not
>registered before? How is that even remotely correct?
>
>Fix your error paths, please. I don't understand the resistance here :)
>
>[...]

Fixed.

Thank you,
Arkadiusz

