Return-Path: <netdev+bounces-5275-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D8401710846
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 11:05:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C3BE1C20B9B
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 09:05:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3615D50C;
	Thu, 25 May 2023 09:05:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A885E849C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:05:50 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E52F195;
	Thu, 25 May 2023 02:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685005548; x=1716541548;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IX4LFww4cIUwiYyNTL/tCU+Jxaj6aW1IPCWD251CnfM=;
  b=RTpUVrRrcfzMR8z6o2Tk37VIXmU9SazKGF4izkXDloGtneB9mnqSQbzB
   nqQtv9WQuZQbK4gaWDEgPZIlkKvPFvEnTvZErWBohpECLsXVJHyo4Nuqq
   CDr706/vo5n7lr9MQ2SEUAu4XgNLf4AhJA9UUiexsPax0lXJWf7bY//qA
   1ZrFXLPvZZcn07pUiNHJHEUy8hMVgs37fVQ4jcawuDv2eFfguJo+cytB5
   BPCe320/9zctViKsgs6IC7L+BZijCGmCPJxqwVdO/4TjB6knCXKKLp6kr
   +EeItN34HB59nBw3Z7gdRrVBwsFK+0Dt33cs5doftf4LuAZdNNtNLTWT0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="343305330"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="343305330"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 02:05:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="794589063"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="794589063"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 25 May 2023 02:05:46 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 02:05:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 02:05:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 25 May 2023 02:05:45 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 25 May 2023 02:05:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhsaNB+L0bj+RhJBYDTEhh6FD2BZqZlcPjbatDpwmNJ4joLktvSCdqS4SWJ7Cfpg++2/n0ocleZ88yojc2lymw30FHLltmIkU83CxIZwBJJKbw96AHDxXDFHvRfA4Gc5ikYnc6aXvvTj0C0w3sRLz77RaC1sXHQnZ+NA8dWQNhuxBJgG+lXpk4dyqa+DUar8CnYEglav+R+2EOWjzZvhTpJbKesrIGM5GPmN1Qw8EgI7G1nooABJA/x9e5kZ48/CeTYKeszs7YkMs7ELqfyCQsvCwsbnNZjvDDG7Wxxs4kh6TjHQiGHoiJY0+SrvWwbFn1fgoCT5CcXTIunwKXwIwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IX4LFww4cIUwiYyNTL/tCU+Jxaj6aW1IPCWD251CnfM=;
 b=OVrlWttSmDf8u47ZvBWP0dKZbl+aMvtNww8hMTCUa0jarFhBfK0hQTnGihyjp5Iq1yrY6mIIBLRcg9NVII62g/0HOfdJaMQwgfUOi3k4x9Qp7xr6xQRxo5SjY/Axdpi8TV7ugQUGSAXld2pDURHTEUN9baW3bUD9klv4SwoTaSnRRpy0crc5B1BHA6hKX6LTDqzn2OpoMRgy9/H7mKuoE7lSl8atrELon/OwdkeMdDQ6mkGuskx63S+GwmlFZKvQUF2wwpJjE0ozvfCDgFaioF7VvFYpxBdDstVwg125M4AcJ5EXbXoIXj0nL+yU2hNa03vcvhdmeijs9hVN84EhaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DM4PR11MB6019.namprd11.prod.outlook.com (2603:10b6:8:60::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.16; Thu, 25 May 2023 09:05:42 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e%6]) with mapi id 15.20.6433.015; Thu, 25 May 2023
 09:05:42 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>
CC: Vadim Fedorenko <vadfed@meta.com>, Jakub Kicinski <kuba@kernel.org>,
	Jonathan Lemon <jonathan.lemon@gmail.com>, "Olech, Milena"
	<milena.olech@intel.com>, "Michalik, Michal" <michal.michalik@intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v7 5/8] ice: implement dpll interface to control cgu
Thread-Topic: [RFC PATCH v7 5/8] ice: implement dpll interface to control cgu
Thread-Index: AQHZeWdQDnOnlwLdVUynBqrraL/3s69If/yAgBOAjACAAItZgIAEvO4AgAmTWIA=
Date: Thu, 25 May 2023 09:05:42 +0000
Message-ID: <DM6PR11MB46579CA5B5907881B62226659B469@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
	 <20230428002009.2948020-6-vadfed@meta.com> <ZFJRIY1HM64gFo3a@nanopsycho>
	 <DM6PR11MB4657EAF163220617A94154A39B789@DM6PR11MB4657.namprd11.prod.outlook.com>
	 <ZGMiE1ByArIr8ARB@nanopsycho>
 <d049ebf92a973c0f293e29722959366086ad3c37.camel@redhat.com>
In-Reply-To: <d049ebf92a973c0f293e29722959366086ad3c37.camel@redhat.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|DM4PR11MB6019:EE_
x-ms-office365-filtering-correlation-id: 68583454-7668-4f15-228a-08db5cff379c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XUFirGkTwixLK6bJW2wp6o196jpjce0ZG2YqdOLRef121vCpn0i4aPEgsMvvGmFZ28K+L4/+Up1U/akiMwqdpc8hOh+aljLJoBCT6yoZitj+asGyPLZrPJ5u/vRwm+FA/2NijGgJ/l9KuQGqFq573PEZ+aJrQffliOfO/3UxbJ+45FifaSjzjxbnLBSLF53Tj2u6hGI5SFD6/j1fhNFX/RTICHspkiBsI/dkgG6NxypcqDygIy3IFSDXKDDEQ1uHDC6vrogGHVxFoNrDQwml4jqvzPRQB24vfjReZ43lrQJhqfClLHkZhsGQzHCm24E5ACmrVIwhdsGUCFYeD+py/c7d4Qc4vujWCB6JyGDLNkMbvjowX2yGucK/dOtd8t3C5qSOd+wNTqnBy9PLM7l07VZ8aiydbY7f7/gaetc7KMsgDhpPmPc83u3iGkF+GNlREeGH7uXwspFaCBPwpm4tegrbUeA8aaaepikIzw8eynomeu9w/ER5JeD4L5zznTXGB8kuETwg1Lmc5qBt7znfay7aKh4mCkb9BSllY3fguo6+Ao+8O58jVyLf4GEnsUZiZBtvyZKXaY/dzvdHw8YlSTDmDuKcbxZfKqJ1mXFr5dr+YGfk5xHobIOyuZUJbo+5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(39860400002)(346002)(136003)(396003)(451199021)(66446008)(66946007)(66556008)(66476007)(64756008)(76116006)(478600001)(54906003)(4326008)(316002)(110136005)(38070700005)(33656002)(86362001)(83380400001)(9686003)(6506007)(26005)(186003)(41300700001)(5660300002)(8936002)(8676002)(52536014)(7416002)(2906002)(7696005)(71200400001)(55016003)(38100700002)(82960400001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R3B3cGNibFc0Ly9zYzhmQ2paTXdYbWFOYUZaZ3I0dm0wUUl4UktQWXQ5UHIx?=
 =?utf-8?B?RGNCWVFKalU1RndmNjl1T2lqRHNESTB1S3ZjYlNFMk4zVEZZZ05wcUxucHI3?=
 =?utf-8?B?NWtuZGFOcG1yRTE2c1VUcDQ4NmtKU2NxdDZxRU05UE82SEhjTUFLT0NjemJk?=
 =?utf-8?B?RWVOOFNDRFdpSW1RdENTN0VJb3ZqKzZMMXVsOG1reEZkSW50ckdES01nWjho?=
 =?utf-8?B?a1pzcnFQY3g0UyszbWd0RFdjSjh2dmNyNWRPeFZQMU0wWW5ZdzByZFpNWjJ4?=
 =?utf-8?B?ZERYZGtROUpWcXhEaXpzOTVjUjdISU9RUGJ4TFhYN2tKZG13UW5McHVXZDVF?=
 =?utf-8?B?ZEdIN1JCWk9jSldER3ZpdXpyRTNDS01UVDRXZHM3QmpPRzd4U2pkckZoakd2?=
 =?utf-8?B?ZUdJMnVoK1FoZHpnK2h5bVNweE9BZW9tbWVaMVhzNGJ6cUx4SXZ5NG5UUEZV?=
 =?utf-8?B?QTMrZ1hWRFNsRDk1SkpGWGZ2azdWYUR6OGhYa1hXbGNzcW9HOE00cW9qNTV5?=
 =?utf-8?B?c1Rzc1Yrczgrb29mMkQvWmhFbDhKaW56OHFadmIzd1FFcjNycjNzbEpoeXFY?=
 =?utf-8?B?QkVFMSswYmp5b243Z0V2M0x3WmRObHZnbTRqdkVKSkhqNFJOeThSWkxVVmpw?=
 =?utf-8?B?Zmx2VWpranVqVWRoK21qVFc3RHMrOG1za00wSStucUNCMW9NdnNpMVNGSG5w?=
 =?utf-8?B?Vktvc0I0M0c4UlV4dWV5dUJzV0d6RXZlMUlIOHVzSHd1dy95aXBpeDV3TUo3?=
 =?utf-8?B?MWVJclVFMVBSMUlLWDJ6TDl5eVk0eTR3TTVSTHBjNDBqQy9hd1A3d1cvRW5x?=
 =?utf-8?B?UzZ1WVY2RlFuclVQcDUweTZNWE1RcjhHTllvSXNDa1kyVlg5ZUN1dnVRQnUv?=
 =?utf-8?B?QmZtRndFcm1EekJVa0lsYzdxVmU4SEd6N0s1bkJpbVdlMk9RMGdGc2Zmc1RJ?=
 =?utf-8?B?dVg4STVoV0h0dkN4MUpEZUVUN0ZwbTd3L0JQTlY4R0Zqd0ZHWHplZWZYeGIz?=
 =?utf-8?B?Q0FzY2F0UFRuV2lEL3FQdG9wN25lSmp2Mi9DcG1xRS9JWktzNnZISnJSeVhz?=
 =?utf-8?B?QTdBOHZUSnhDV0xkUlBZRUFmWkFNeERNRGNNTkZoSEdJS2RYaXNkUlRtMGF2?=
 =?utf-8?B?czFwRWRWcDhIVXFYSDFmby94cTlkTzhMUUxwUVNxNlZxdnNLanl0ZmxJMTV2?=
 =?utf-8?B?OC9heVhIWnAvWU1HWVRPNUtkNzF4bWdtWjlIZ01ncVNpZWt3amhhL3hnQ1M0?=
 =?utf-8?B?L3BaNlNzdHpYNVhlMFFFV3V0OVdnVzk2UHZoMG1pcnM3NEVack9zZDdyeFNy?=
 =?utf-8?B?c0dwaTVVM2QrcDlyRXlOVUY5bGhqNmVabWZ6QnhLcnNOdFdxODVkZmFIZ2ZI?=
 =?utf-8?B?VmtCRTVrcTVZVHFhLzhVNFk5RkNPaXoraHA3UzJWU3I2NDVrVFNRWm5PRU5o?=
 =?utf-8?B?UlpZOG5ZV1pyc3pJS3VXOTBsbU44ZVI2Kzk2YU9VOFRmdmNCc1JKdVNTRmVI?=
 =?utf-8?B?MHp1K1V4OWNMdzRQV0U4NjZxbE8vNmZNVXliTEhqM0hRb0c0NjBidTJIT3BO?=
 =?utf-8?B?ODVPb1JtYnQrQmplYkNybFBPYzhaYll4ZHNmQ2t0NVQ1Z0R0aG9qMEhweFNQ?=
 =?utf-8?B?WHlyQ3plbWdZRnJWb1ZFN1BVT040TE9aaUZ5eTEyN2lqUXhxMHhJOG42V2tx?=
 =?utf-8?B?ZHpMWGkzcUs2MGJxcXJZcmNsTHdEVm9jQnM5YU5hTkZDUGtINTZPWHF3UU1W?=
 =?utf-8?B?WWVuaXpPTG53S0pHL0d4Q08yazQvdGFMSnE1emhYZnhvWkE4ZkhwUVRxODN1?=
 =?utf-8?B?NGtBTmhhZ2Y0b3paUUVKRHpWdFhjeDQ5anpEdGRyNkNmRSttUWhKLzRZYklK?=
 =?utf-8?B?SEx2L2ZCaXE5NlhsOGs5YWl6YUsyUW5teEdJUkhQcUFoeENuaTlDL3NmUXhQ?=
 =?utf-8?B?T0lrV1lCZjFOc2g3TE5EckN1Zk1KdlFkd2d1QldVdGl0TjFPbVMvM1UweGRq?=
 =?utf-8?B?bXQ3ZWxQalZYRWtHcmhZNHdvaEpEMUFSSDc1bXhvRStYUzZ3M2xRQndGVE9P?=
 =?utf-8?B?RWVJdGpQbjhlOGRiKzdCdDVlWExIeW5XY0lCUlRRN2dBbnBMaVM4VnRyVW5x?=
 =?utf-8?B?OGpKZ0kycmNjUDlPNERjWjc1TURZdWxhNmZZWUJ4OG5NaXFzQlRDcm1NVjdL?=
 =?utf-8?B?UWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68583454-7668-4f15-228a-08db5cff379c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2023 09:05:42.2090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DBKk4RU3GcyuL6H9bR60ceLHEmQ+3J6N8ykJN5J5idPlpt2ul9MRCrHOik8PAw1tgdNle9W8GlWRANn+g02RMFKqz4NMCITkDUMfogG0Kbw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6019
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQo+RnJvbTogUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPg0KPlNlbnQ6IEZyaWRheSwg
TWF5IDE5LCAyMDIzIDg6NDggQU0NCj4NCj5PbiBUdWUsIDIwMjMtMDUtMTYgYXQgMDg6MjYgKzAy
MDAsIEppcmkgUGlya28gd3JvdGU6DQo+PiBUdWUsIE1heSAxNiwgMjAyMyBhdCAxMjowNzo1N0FN
IENFU1QsIGFya2FkaXVzei5rdWJhbGV3c2tpQGludGVsLmNvbQ0KPj4gPiA+IHdyb3RlOg0KPj4g
PiA+IEZyb206IEppcmkgUGlya28gPGppcmlAcmVzbnVsbGkudXM+DQo+PiA+ID4gU2VudDogV2Vk
bmVzZGF5LCBNYXkgMywgMjAyMyAyOjE5IFBNDQo+PiA+ID4NCj4+ID4gPiBGcmksIEFwciAyOCwg
MjAyMyBhdCAwMjoyMDowNkFNIENFU1QsIHZhZGZlZEBtZXRhLmNvbSB3cm90ZToNCj4+ID4gPiA+
IEZyb206IEFya2FkaXVzeiBLdWJhbGV3c2tpIDxhcmthZGl1c3oua3ViYWxld3NraUBpbnRlbC5j
b20+DQo+Pg0KPj4gWy4uLl0NCj4+DQo+Pg0KPj4gPiA+ID4gKyAqIGljZV9kcGxsX2ZyZXF1ZW5j
eV9zZXQgLSB3cmFwcGVyIGZvciBwaW4gY2FsbGJhY2sgZm9yIHNldA0KPj4gPiA+ID4gZnJlcXVl
bmN5DQo+PiA+ID4gPiArICogQHBpbjogcG9pbnRlciB0byBhIHBpbg0KPj4gPiA+ID4gKyAqIEBw
aW5fcHJpdjogcHJpdmF0ZSBkYXRhIHBvaW50ZXIgcGFzc2VkIG9uIHBpbiByZWdpc3RyYXRpb24N
Cj4+ID4gPiA+ICsgKiBAZHBsbDogcG9pbnRlciB0byBkcGxsDQo+PiA+ID4gPiArICogQGZyZXF1
ZW5jeTogZnJlcXVlbmN5IHRvIGJlIHNldA0KPj4gPiA+ID4gKyAqIEBleHRhY2s6IGVycm9yIHJl
cG9ydGluZw0KPj4gPiA+ID4gKyAqIEBwaW5fdHlwZTogdHlwZSBvZiBwaW4gYmVpbmcgY29uZmln
dXJlZA0KPj4gPiA+ID4gKyAqDQo+PiA+ID4gPiArICogV3JhcHMgaW50ZXJuYWwgc2V0IGZyZXF1
ZW5jeSBjb21tYW5kIG9uIGEgcGluLg0KPj4gPiA+ID4gKyAqDQo+PiA+ID4gPiArICogUmV0dXJu
Og0KPj4gPiA+ID4gKyAqICogMCAtIHN1Y2Nlc3MNCj4+ID4gPiA+ICsgKiAqIG5lZ2F0aXZlIC0g
ZXJyb3IgcGluIG5vdCBmb3VuZCBvciBjb3VsZG4ndCBzZXQgaW4gaHcgICovDQo+PiA+ID4gPiBz
dGF0aWMNCj4+ID4gPiA+ICtpbnQgaWNlX2RwbGxfZnJlcXVlbmN5X3NldChjb25zdCBzdHJ1Y3Qg
ZHBsbF9waW4gKnBpbiwNCj4+ID4gPiA+IHZvaWQgKnBpbl9wcml2LA0KPj4gPiA+ID4gKwkJICAg
ICAgIGNvbnN0IHN0cnVjdCBkcGxsX2RldmljZSAqZHBsbCwNCj4+ID4gPiA+ICsJCSAgICAgICBj
b25zdCB1MzIgZnJlcXVlbmN5LA0KPj4gPiA+ID4gKwkJICAgICAgIHN0cnVjdCBuZXRsaW5rX2V4
dF9hY2sgKmV4dGFjaywNCj4+ID4gPiA+ICsJCSAgICAgICBjb25zdCBlbnVtIGljZV9kcGxsX3Bp
bl90eXBlIHBpbl90eXBlKSB7DQo+PiA+ID4gPiArCXN0cnVjdCBpY2VfcGYgKnBmID0gcGluX3By
aXY7DQo+PiA+ID4gPiArCXN0cnVjdCBpY2VfZHBsbF9waW4gKnA7DQo+PiA+ID4gPiArCWludCBy
ZXQgPSAtRUlOVkFMOw0KPj4gPiA+ID4gKw0KPj4gPiA+ID4gKwlpZiAoIXBmKQ0KPj4gPiA+ID4g
KwkJcmV0dXJuIHJldDsNCj4+ID4gPiA+ICsJaWYgKGljZV9kcGxsX2NiX2xvY2socGYpKQ0KPj4g
PiA+ID4gKwkJcmV0dXJuIC1FQlVTWTsNCj4+ID4gPiA+ICsJcCA9IGljZV9maW5kX3BpbihwZiwg
cGluLCBwaW5fdHlwZSk7DQo+PiA+ID4NCj4+ID4gPiBUaGlzIGRvZXMgbm90IG1ha2UgYW55IHNl
bnNlIHRvIG1lLiBZb3Ugc2hvdWxkIGF2b2lkIHRoZSBsb29rdXBzIGFuZA0KPj4gPiA+IHJlbW92
ZQ0KPj4gPiA+IGljZV9maW5kX3BpbigpIGZ1bmN0aW9uIGVudGlyZWx5LiBUaGUgcHVycG9zZSBv
ZiBoYXZpbmcgcGluX3ByaXYgaXMNCj4+ID4gPiB0bw0KPj4gPiA+IGNhcnJ5IHRoZSBzdHJ1Y3Qg
aWNlX2RwbGxfcGluICogZGlyZWN0bHkuIFlvdSBzaG91bGQgcGFzcyBpdCBkb3duDQo+PiA+ID4g
ZHVyaW5nDQo+PiA+ID4gcGluIHJlZ2lzdGVyLg0KPj4gPiA+DQo+PiA+ID4gcGYgcG9pbnRlciBp
cyBzdG9yZWQgaW4gZHBsbF9wcml2Lg0KPj4gPiA+DQo+PiA+DQo+PiA+IEluIHRoaXMgY2FzZSBk
cGxsX3ByaXYgaXMgbm90IHBhc3NlZCwgc28gY2Fubm90IHVzZSBpdC4NCj4+DQo+PiBJdCBzaG91
bGQgYmUgcGFzc2VkLiBJbiBnZW5lcmFsIHRvIGV2ZXJ5IG9wIHdoZXJlICpkcGxsIGlzIHBhc3Nl
ZCwgdGhlDQo+PiBkcGxsX3ByaXYgcG9pbnRlciBzaG91bGQgYmUgcGFzc2VkIGFsb25nLiBQbGVh
c2UsIGZpeCB0aGlzLg0KPj4NCj4+DQo+PiA+IEJ1dCBpbiBnZW5lcmFsIGl0IG1ha2VzIHNlbnNl
IEkgd2lsbCBob2xkIHBmIGluc2lkZSBvZiBpY2VfZHBsbF9waW4NCj4+ID4gYW5kIGZpeCB0aGlz
Lg0KPj4NCj4+IE5vcGUsIGp1c3QgdXNlIGRwbGxfcHJpdi4gVGhhdCdzIHdoeSB3ZSBoYXZlIGl0
Lg0KPj4NCj4+DQo+PiBbLi4uXQ0KPj4NCj4+DQo+PiA+ID4gPiArLyoqDQo+PiA+ID4gPiArICog
aWNlX2RwbGxfcGluX3N0YXRlX3NldCAtIHNldCBwaW4ncyBzdGF0ZSBvbiBkcGxsDQo+PiA+ID4g
PiArICogQGRwbGw6IGRwbGwgYmVpbmcgY29uZmlndXJlZA0KPj4gPiA+ID4gKyAqIEBwaW46IHBv
aW50ZXIgdG8gYSBwaW4NCj4+ID4gPiA+ICsgKiBAcGluX3ByaXY6IHByaXZhdGUgZGF0YSBwb2lu
dGVyIHBhc3NlZCBvbiBwaW4gcmVnaXN0cmF0aW9uDQo+PiA+ID4gPiArICogQHN0YXRlOiBzdGF0
ZSBvZiBwaW4gdG8gYmUgc2V0DQo+PiA+ID4gPiArICogQGV4dGFjazogZXJyb3IgcmVwb3J0aW5n
DQo+PiA+ID4gPiArICogQHBpbl90eXBlOiB0eXBlIG9mIGEgcGluDQo+PiA+ID4gPiArICoNCj4+
ID4gPiA+ICsgKiBTZXQgcGluIHN0YXRlIG9uIGEgcGluLg0KPj4gPiA+ID4gKyAqDQo+PiA+ID4g
PiArICogUmV0dXJuOg0KPj4gPiA+ID4gKyAqICogMCAtIE9LIG9yIG5vIGNoYW5nZSByZXF1aXJl
ZA0KPj4gPiA+ID4gKyAqICogbmVnYXRpdmUgLSBlcnJvcg0KPj4gPiA+ID4gKyAqLw0KPj4gPiA+
ID4gK3N0YXRpYyBpbnQNCj4+ID4gPiA+ICtpY2VfZHBsbF9waW5fc3RhdGVfc2V0KGNvbnN0IHN0
cnVjdCBkcGxsX2RldmljZSAqZHBsbCwNCj4+ID4gPiA+ICsJCSAgICAgICBjb25zdCBzdHJ1Y3Qg
ZHBsbF9waW4gKnBpbiwgdm9pZCAqcGluX3ByaXYsDQo+PiA+ID4gPiArCQkgICAgICAgY29uc3Qg
ZW51bSBkcGxsX3Bpbl9zdGF0ZSBzdGF0ZSwNCj4+ID4gPg0KPj4gPiA+IFdoeSB5b3UgdXNlIGNv
bnN0IHdpdGggZW51bXM/DQo+PiA+ID4NCj4+ID4NCj4+ID4gSnVzdCBzaG93IHVzYWdlIGludGVu
dGlvbiBleHBsaWNpdGx5Lg0KPj4NCj4+IERvZXMgbm90IG1ha2UgYW55IHNlbnNlIHdoYXQgc28g
ZXZlci4gUGxlYXNlIGF2b2lkIGl0Lg0KPj4NCj4+DQo+PiA+ID4gPiArc3RhdGljIGludCBpY2Vf
ZHBsbF9yY2xrX3N0YXRlX29uX3Bpbl9nZXQoY29uc3Qgc3RydWN0IGRwbGxfcGluICpwaW4sDQo+
PiA+ID4gPiArCQkJCQkgIHZvaWQgKnBpbl9wcml2LA0KPj4gPiA+ID4gKwkJCQkJICBjb25zdCBz
dHJ1Y3QgZHBsbF9waW4gKnBhcmVudF9waW4sDQo+PiA+ID4gPiArCQkJCQkgIGVudW0gZHBsbF9w
aW5fc3RhdGUgKnN0YXRlLA0KPj4gPiA+ID4gKwkJCQkJICBzdHJ1Y3QgbmV0bGlua19leHRfYWNr
ICpleHRhY2spIHsNCj4+ID4gPiA+ICsJc3RydWN0IGljZV9wZiAqcGYgPSBwaW5fcHJpdjsNCj4+
ID4gPiA+ICsJdTMyIHBhcmVudF9pZHgsIGh3X2lkeCA9IElDRV9EUExMX1BJTl9JRFhfSU5WQUxJ
RCwgaTsNCj4+ID4gPg0KPj4gPiA+IFJldmVyc2UgY2hyaXN0bWFzIHRyZWUgb3JkZXJpbmcgcGxl
YXNlLg0KPj4gPg0KPj4gPiBGaXhlZC4NCj4+ID4NCj4+ID4gPg0KPj4gPiA+DQo+PiA+ID4gPiAr
CXN0cnVjdCBpY2VfZHBsbF9waW4gKnA7DQo+PiA+ID4gPiArCWludCByZXQgPSAtRUZBVUxUOw0K
Pj4gPiA+ID4gKw0KPj4gPiA+ID4gKwlpZiAoIXBmKQ0KPj4gPiA+DQo+PiA+ID4gSG93IGV4YWNs
eSB0aGlzIGNhbiBoYXBwZW4uIE15IHdpbGQgZ3Vlc3MgaXMgaXQgY2FuJ3QuIERvbid0IGRvIHN1
Y2gNCj4+ID4gPiBwb2ludGxlc3MgY2hlY2tzIHBsZWFzZSwgY29uZnVzZXMgdGhlIHJlYWRlci4N
Cj4+ID4gPg0KPj4gPg0KPj4gPiBGcm9tIGRyaXZlciBwZXJzcGVjdGl2ZSB0aGUgcGYgcG9pbnRl
ciB2YWx1ZSBpcyBnaXZlbiBieSBleHRlcm5hbCBlbnRpdHksDQo+PiA+IHdoeSBzaG91bGRuJ3Qg
aXQgYmUgdmFsZGlhdGVkPw0KPj4NCj4+IFdoYXQ/IFlvdSBwYXNzIGl0IGR1cmluZyByZWdpc3Rl
ciwgeW91IGdldCBpdCBiYWNrIGhlcmUuIE5vdGhpbmcgdG8NCj4+IGNoZWNrLiBQbGVhc2UgZHJv
cCBpdC4gTm9uLXNlbnNlIGNoZWNrcyBsaWtlIHRoaXMgaGF2ZSBubyBwbGFjZSBpbg0KPj4ga2Vy
bmVsLCB0aGV5IG9ubHkgY29uZnVzZSByZWFkZXIgYXMgaGUvc2hlIGFzc3VtZXMgaXQgaXMgYSB2
YWxpZCBjYXNlLg0KPj4NCj4+DQo+PiBbLi4uXQ0KPj4NCj4+DQo+PiA+ID4NCj4+ID4gPg0KPj4g
PiA+ID4gKwkJCXBpbnNbaV0ucGluID0gTlVMTDsNCj4+ID4gPiA+ICsJCQlyZXR1cm4gLUVOT01F
TTsNCj4+ID4gPiA+ICsJCX0NCj4+ID4gPiA+ICsJCWlmIChjZ3UpIHsNCj4+ID4gPiA+ICsJCQly
ZXQgPSBkcGxsX3Bpbl9yZWdpc3RlcihwZi0+ZHBsbHMuZWVjLmRwbGwsDQo+PiA+ID4gPiArCQkJ
CQkJcGluc1tpXS5waW4sDQo+PiA+ID4gPiArCQkJCQkJb3BzLCBwZiwgTlVMTCk7DQo+PiA+ID4g
PiArCQkJaWYgKHJldCkNCj4+ID4gPiA+ICsJCQkJcmV0dXJuIHJldDsNCj4+ID4gPiA+ICsJCQly
ZXQgPSBkcGxsX3Bpbl9yZWdpc3RlcihwZi0+ZHBsbHMucHBzLmRwbGwsDQo+PiA+ID4gPiArCQkJ
CQkJcGluc1tpXS5waW4sDQo+PiA+ID4gPiArCQkJCQkJb3BzLCBwZiwgTlVMTCk7DQo+PiA+ID4g
PiArCQkJaWYgKHJldCkNCj4+ID4gPiA+ICsJCQkJcmV0dXJuIHJldDsNCj4+ID4gPg0KPj4gPiA+
IFlvdSBoYXZlIHRvIGNhbGwgZHBsbF9waW5fdW5yZWdpc3RlcihwZi0+ZHBsbHMuZWVjLmRwbGws
IHBpbnNbaV0ucGluLCAuLikNCj4+ID4gPiBoZXJlLg0KPj4gPiA+DQo+PiA+DQo+PiA+IE5vLCBp
biBjYXNlIG9mIGVycm9yLCB0aGUgY2FsbGVyIHJlbGVhc2VzIGV2ZXJ5dGhpbmcNCj4+ID4gaWNl
X2RwbGxfcmVsZWFzZV9hbGwoLi4pLg0KPj4NCj4+DQo+PiBIb3cgZG9lcyBpY2VfZHBsbF9yZWxl
YXNlX2FsbCgpIHdoZXJlIHlvdSBmYWlsZWQ/IElmIHlvdSBuZWVkIHRvDQo+PiB1bnJlZ2lzdGVy
IG9uZSBvciBib3RoIG9yIG5vbmU/IEkga25vdyB0aGF0IGluIGljZSB5b3UgaGF2ZSBvZGQgd2F5
cyB0bw0KPj4gaGFuZGxlIGVycm9yIHBhdGhzIGluIGdlbmVyYWwsIGJ1dCB0aGlzIG9uZSBjbGVh
cmx5IHNlZW1zIHRvIGJlIGJyb2tlbi4NCj4+DQo+Pg0KPj4NCj4+DQo+Pg0KPj4gPg0KPj4gPiA+
DQo+PiA+ID4gPiArCQl9DQo+PiA+ID4gPiArCX0NCj4+ID4gPiA+ICsJaWYgKGNndSkgew0KPj4g
PiA+ID4gKwkJb3BzID0gJmljZV9kcGxsX291dHB1dF9vcHM7DQo+PiA+ID4gPiArCQlwaW5zID0g
cGYtPmRwbGxzLm91dHB1dHM7DQo+PiA+ID4gPiArCQlmb3IgKGkgPSAwOyBpIDwgcGYtPmRwbGxz
Lm51bV9vdXRwdXRzOyBpKyspIHsNCj4+ID4gPiA+ICsJCQlwaW5zW2ldLnBpbiA9IGRwbGxfcGlu
X2dldChwZi0+ZHBsbHMuY2xvY2tfaWQsDQo+PiA+ID4gPiArCQkJCQkJICAgaSArIHBmLT5kcGxs
cy5udW1faW5wdXRzLA0KPj4gPiA+ID4gKwkJCQkJCSAgIFRISVNfTU9EVUxFLCAmcGluc1tpXS5w
cm9wKTsNCj4+ID4gPiA+ICsJCQlpZiAoSVNfRVJSX09SX05VTEwocGluc1tpXS5waW4pKSB7DQo+
PiA+ID4gPiArCQkJCXBpbnNbaV0ucGluID0gTlVMTDsNCj4+ID4gPiA+ICsJCQkJcmV0dXJuIC1F
Tk9NRU07DQo+PiA+ID4NCj4+ID4gPiBEb24ndCBtYWtlIHVwIGVycm9yIHZhbHVlcyB3aGVuIHlv
dSBnZXQgdGhlbSBmcm9tIHRoZSBmdW5jdGlvbiB5b3UgY2FsbDoNCj4+ID4gPiAJcmV0dXJuIFBU
Ul9FUlIocGluc1tpXS5waW4pOw0KPj4gPg0KPj4gPiBGaXhlZC4NCj4+ID4NCj4+ID4gPg0KPj4g
PiA+ID4gKwkJCX0NCj4+ID4gPiA+ICsJCQlyZXQgPSBkcGxsX3Bpbl9yZWdpc3RlcihwZi0+ZHBs
bHMuZWVjLmRwbGwsDQo+PiA+ID4gPiBwaW5zW2ldLnBpbiwNCj4+ID4gPiA+ICsJCQkJCQlvcHMs
IHBmLCBOVUxMKTsNCj4+ID4gPiA+ICsJCQlpZiAocmV0KQ0KPj4gPiA+ID4gKwkJCQlyZXR1cm4g
cmV0Ow0KPj4gPiA+ID4gKwkJCXJldCA9IGRwbGxfcGluX3JlZ2lzdGVyKHBmLT5kcGxscy5wcHMu
ZHBsbCwNCj4+ID4gPiA+IHBpbnNbaV0ucGluLA0KPj4gPiA+ID4gKwkJCQkJCW9wcywgcGYsIE5V
TEwpOw0KPj4gPiA+ID4gKwkJCWlmIChyZXQpDQo+PiA+ID4gPiArCQkJCXJldHVybiByZXQ7DQo+
PiA+ID4NCj4+ID4gPiBZb3UgaGF2ZSB0byBjYWxsIGRwbGxfcGluX3VucmVnaXN0ZXIocGYtPmRw
bGxzLmVlYy5kcGxsLCBwaW5zW2ldLnBpbiwNCj4+Li4pDQo+PiA+ID4gaGVyZS4NCj4+ID4gPg0K
Pj4gPg0KPj4gPiBBcyBhYm92ZSwgaW4gY2FzZSBvZiBlcnJvciwgdGhlIGNhbGxlciByZWxlYXNl
cyBldmVyeXRoaW5nLg0KPj4NCj4+IEFzIGFib3ZlLCBJIGRvbid0IHRoaW5rIGl0IHdvcmtzLg0K
Pj4NCj4+DQo+PiBbLi4uXQ0KPj4NCj4+DQo+PiA+ID4gPiArCX0NCj4+ID4gPiA+ICsNCj4+ID4g
PiA+ICsJaWYgKGNndSkgew0KPj4gPiA+ID4gKwkJcmV0ID0gZHBsbF9kZXZpY2VfcmVnaXN0ZXIo
cGYtPmRwbGxzLmVlYy5kcGxsLA0KPj4gPiA+ID4gRFBMTF9UWVBFX0VFQywNCj4+ID4gPiA+ICsJ
CQkJCSAgICZpY2VfZHBsbF9vcHMsIHBmLCBkZXYpOw0KPj4gPiA+ID4gKwkJaWYgKHJldCkNCj4+
ID4gPiA+ICsJCQlnb3RvIHB1dF9wcHM7DQo+PiA+ID4gPiArCQlyZXQgPSBkcGxsX2RldmljZV9y
ZWdpc3RlcihwZi0+ZHBsbHMucHBzLmRwbGwsDQo+PiA+ID4gPiBEUExMX1RZUEVfUFBTLA0KPj4g
PiA+ID4gKwkJCQkJICAgJmljZV9kcGxsX29wcywgcGYsIGRldik7DQo+PiA+ID4gPiArCQlpZiAo
cmV0KQ0KPj4gPiA+DQo+PiA+ID4gWW91IGFyZSBtaXNzaW5nIGNhbGwgdG8gZHBsbF9kZXZpY2Vf
dW5yZWdpc3RlcihwZi0+ZHBsbHMuZWVjLmRwbGwsDQo+PiA+ID4gRFBMTF9UWVBFX0VFQyBoZXJl
LiBGaXggdGhlIGVycm9yIHBhdGguDQo+PiA+ID4NCj4+ID4NCj4+ID4gVGhlIGNhbGxlciBzaGFs
bCBkbyB0aGUgY2xlYW4gdXAsIGJ1dCB5ZWFoIHdpbGwgZml4IHRoaXMgYXMgaGVyZSBjbGVhbiB1
cA0KPj4gPiBpcyBub3QgZXhwZWN0ZWQuDQo+Pg0KPj4gOikgSnVzdCBtYWtlIHlvdXIgZXJyb3Ig
cGF0aHMgb2J2aW91cyBhbmQgZWFzeSB0byBmb2xsb3cgdG8gbm90IHRvDQo+PiBjb25mdXNlIGFu
eWJvZHksIHlvdSBpbmNsdWRlZC4NCj4NCj5JIGFncmVlIHdpdGggSmlyaS4gVGhlIGVycm9yIHBh
dGhzIGhlcmUgYW5kIGluIGljZV9kcGxsX2luaXRfaW5mbygpIGFyZQ0KPnF1aXRlIGNvbmZ1c2lu
ZyBhbmQgSU1ITyBlcnJvciBwcm9uZS4NCj4NCj5JdCB3aWxsIGdldCBtb3JlIGVhc3kgdG9yZWFk
IGFuZCBtb3JlIGNvbnNpc3RlbnQgaWYgZXZlcnkNCj5pbml0aWFsaXphdGlvbiBmdW5jdGlvbiBk
b2VzIHJldHVybiBhbiBlcnJvciBjb2RlIHdvdWxkIGxlYXZlIHRoZSBzdGF0ZQ0KPmNsZWFuIGlu
IGNhc2Ugb2YgZXJyb3IuIFRoYXQgaXMsIGluIGNhc2Ugb2YgZXJyb3IsIHN1Y2ggZnVuY3Rpb24g
c2hvdWxkDQo+Y2xlYW51cCBhbGwgdGhlIHBhcnRpYWxseSBhbGxvY2F0ZWQvaW5pdGlhbGl6ZWQg
cmVzb3VyY2VzLg0KPg0KPk5vdGUgdGhhdCBpbiBpY2VfZHBsbF9pbml0X2luZm8oKSB0aGUgc2l0
dWF0aW9uIGlzIG1vcmUgbWl4ZWQtdXAgYXMNCj5pY2VfZHBsbF9yZWxlYXNlX2luZm8oKSBpcyBj
YWxsZWQgb24gbW9zdCBlcnJvciBwYXRocywgZXhjZXB0IHRoZSBsYXN0DQo+b25lLiBNZW1vcnkg
c2hvdWxkIG5vdCBsZWFrZWQgZHVlIHRvIGxhdGVyIGljZV9kcGxsX3JlbGVhc2VfYWxsKCksIGJ1
dA0KPml0J3MgcmVhbGx5IGNvbmZ1c2luZy4NCj4NCj5DaGVlcnMsDQo+DQo+UGFvbG8NCg0KRml4
ZWQuDQoNClRoYW5rIHlvdSwNCkFya2FkaXVzeg0K

